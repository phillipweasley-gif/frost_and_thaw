#===============================================================================
# Frost & Thaw - the Cup of Seasons (postgame)
#
# After the credits, Tamsin runs a tournament in the Hall of Seasons: three
# rounds against the strongest people in the city, then the final against her.
# Your Pokémon are healed between rounds. Lose once and you're out; the Cup can
# be entered again as often as you like. (The game's Champion Cup, in the
# spirit of Sword and Shield's: owner's ask, 2026-11-11, "depth like X/Y or
# Sword and Shield".)
#
# Only people who are in the city after the ending are drawn: Mira if she was
# freed, Luminara if the colony stayed, Selrae if she wasn't sentenced.
#===============================================================================
module FrostThaw
  CUP_VERSION = 5      # trainer versions 5-8 (the scaled leaders use 0-2)

  # key => [trainer class, name, party at round 1, lose text, items]
  # Each round after the first adds two levels.
  CUP_TEAMS = {
    duvessa:  [:FT_SPEAKER_F, "Duvessa",
               [[:SKARMORY, 66], [:MAGNETON, 66], [:B161H81, 67], [:URSARING, 67], [:STEELIX, 68], [:B52H227, 69]],
               "Good. I'd hate to lose to anyone who wasn't worth it.", [:FULLRESTORE]],
    hellen:   [:FT_HEARTH_LEADER, "Hellen",
               [[:MILTANK, 66], [:ARCANINE, 66], [:B266H217, 67], [:B38H128, 67], [:B184H241, 68], [:B149H143, 69]],
               "Well. That's me told. Go on, love. Win the thing.", [:FULLRESTORE]],
    hew:      [:FT_GUILDMASTER, "Hew",
               [[:GOLEM, 66], [:RHYDON, 66], [:B208H76, 67], [:B95H205, 67], [:B232H82, 68], [:B76H208, 69]],
               "That's a lesson. I'll be feeling it in the morning.", [:FULLRESTORE]],
    kethan:   [:FT_WATCHMAN, "Kethan",
               [[:PRIMEAPE, 66], [:HITMONLEE, 66], [:MACHAMP, 67], [:B68H112, 67], [:B76H208, 68], [:B112H68, 69]],
               "Honest fight. Thank you for it.", [:FULLRESTORE]],
    mira:     [:FT_CORSAIR_CAPT, "Mira",
               [[:STARMIE, 66], [:GYARADOS, 66], [:B80H121, 67], [:B131H199, 67], [:B121H80, 68], [:B130H196, 69]],
               "Well. I've just lost a bet to myself.", [:FULLRESTORE]],
    luminara: [:FT_SOVEREIGN, "Luminara",
               [[:PARASECT, 66], [:VENUSAUR, 66], [:B71H182, 67], [:B89H355, 67], [:VILEPLUME, 68], [:B45H439, 69]],
               "Tasted. Strong. The colony is pleased.", [:FULLRESTORE]],
    selrae:   [:FT_WINTER_MATRON, "Selrae",
               [[:JYNX, 66], [:CLOYSTER, 66], [:MAMOSWINE, 67], [:B124H200, 67], [:B131H225, 68], [:B221H215, 69]],
               "Hm. Spring, then. For today.", [:FULLRESTORE]]
  }

  # What each of them says as they step out onto the floor
  CUP_INTROS = {
    duvessa:  ["DUVESSA: Tamsin put me in as 'the wall'. I've been called worse.",
               "DUVESSA: I held a town together through two years of night. Let's see if I can hold you."],
    hellen:   ["HELLEN: Don't look at me like that. I paid the entry fee same as everyone.",
               "HELLEN: Sleeves up, love."],
    hew:      ["HEW: Forty years of digging, and I'm still learning. Teach me something."],
    kethan:   ["KETHAN: (pop, pop) No speeches. Fists."],
    mira:     ["MIRA: The docks have money on this match. Most of it's on you.",
               "MIRA: Some of it's mine. I haven't decided which way yet."],
    luminara: ["LUMINARA: (wind through reeds) The colony wanted to see you fight. So: I fight."],
    selrae:   ["SELRAE: Winter doesn't enter tournaments. I'm making an exception.",
               "SELRAE: Don't make me regret it."]
  }

  # Tamsin's final team: her three from the Hearth, grown up, and three more
  # (a Noctowl for the Hoothoot she grafted, and two lanterns: she loves a lantern).
  CUP_TAMSIN_ACE = { FT_TAMSIN_G: :FORGEL, FT_TAMSIN_F: :B9H221, FT_TAMSIN_I: :B331H154 }
  CUP_ROUNDS = 3

  module_function

  def cup_open?
    flag?(:game_complete) && flag?(:beat_tamsin)
  end

  # Who's in the city after the ending
  def cup_pool
    pool = %i[duvessa hellen hew kethan]
    pool << :mira if !flag?(:mira_left_possessed) || flag?(:mira_freed_late)
    pool << :luminara if !flag?(:colony_exiled)
    pool << :selrae if !flag?(:selrae_sentenced)
    pool
  end

  def cup_tamsin_type
    case state[:starter]
    when :B330H152 then :FT_TAMSIN_G
    when :WICKIT   then :FT_TAMSIN_F
    else :FT_TAMSIN_I
    end
  end

  def cup_register(type, name, party, lose_text, items, round)
    version = CUP_VERSION + round
    mons = party.map { |sp, lv| { species: sp, level: [lv + 2 * round, 100].min } }
    mons.select! do |h|
      ok = GameData::Species.exists?(h[:species]) rescue false
      log("Cup: no species #{h[:species]} for #{name}") if !ok
      ok
    end
    items = (items || []).select { |i| GameData::Item.exists?(i) rescue false }
    hash = { id: [type, name, version], id_number: 9900 + round * 20 + (CUP_TEAMS.keys.index(name.downcase.to_sym) || 19),
             trainer_type: type, name: name, version: version, items: items, lose_text: lose_text, pokemon: mons }
    GameData::Trainer::DATA[[type, name, version]] = GameData::Trainer.new(hash)
    version
  end

  def cup_battle(key, round)
    type, name, party, lose_text, items = CUP_TEAMS[key]
    version = cup_register(type, name, party, lose_text, items, round)
    pbTrainerBattle(type, name, nil, false, version, true) ? true : false
  rescue StandardError => e
    log("cup_battle(#{key}) failed: #{e.class}: #{e.message}")
    false
  end

  def cup_final_battle
    type = cup_tamsin_type
    party = [[:FURRET, 69], [:NOCTOWL, 69], [:JUMPLUFF, 69], [:AMPHAROS, 70], [:LANTURN, 70], [CUP_TAMSIN_ACE[type], 72]]
    version = cup_register(type, "Tamsin", party, "...Okay. Okay. Next year.", [:FULLRESTORE], CUP_ROUNDS)
    pbTrainerBattle(type, "Tamsin", nil, false, version, true) ? true : false
  rescue StandardError => e
    log("cup_final_battle failed: #{e.class}: #{e.message}")
    false
  end

  def cup_heal
    $Trainer.heal_party rescue ($Trainer.party.each { |pk| pk.heal } rescue nil)
  end

  # Tamsin's invitation, and the Cup itself
  def seasons_cup(event_id = nil)
    if !flag?(:cup_invited)
      set_flag(:cup_invited)
      if journey?
        say(["TAMSIN: Also. I've organised something. Don't make that face.",
             "TAMSIN: The Cup of Seasons. Three rounds in the Hall of Seasons, then the final. Kelyn lent us the floor.",
             "TAMSIN: Everyone strong in this city signed up. Mum entered. Of course Mum entered.",
             "TAMSIN: And I'm in the final. I seeded myself. It's allowed. I made the rules."], event_id)
      else
        say(["TAMSIN: Heralds! I've organised something. Kelyn lent us the Hall of Seasons.",
             "TAMSIN: The Cup of Seasons. Three rounds, then the final. Everyone strong in this city signed up.",
             "TAMSIN: Mum entered. Of course Mum entered.",
             "TAMSIN: And I'm in the final. I seeded myself. It's allowed. I made the rules."], event_id)
      end
    elsif flag?(:cup_champion)
      say(["TAMSIN: Back to defend it? Good. I've been practising."], event_id)
    else
      say(["TAMSIN: The Cup's on every evening. Want another go?"], event_id)
    end
    return if !pbConfirmMessage(_INTL("Enter the Cup of Seasons? (Your Pokémon are healed between rounds. Lose once, and you're out.)"))
    if ($Trainer.able_pokemon_count rescue 1) < 1
      return say(["TAMSIN: Your Pokémon can't stand up. Go and see Mum first."], event_id)
    end
    cup_heal
    say(["TAMSIN: Right! See you in the final. Don't lose before then. That would be embarrassing for both of us."], event_id)
    run_cup
  end

  def run_cup
    picks = cup_pool.shuffle.first(CUP_ROUNDS)
    say(["That evening, the Hall of Seasons is cleared for the Cup. The galleries are full, and somebody's selling buns.",
         "Four chairs on the dais. Kelyn's in one of them, trying very hard to look neutral."])
    picks.each_with_index do |key, round|
      label = ["The first round", "The second round", "The semi-final"][round]
      say(["#{label}. Your opponent walks out from the far side of the floor."] + CUP_INTROS[key])
      if !cup_battle(key, round)
        cup_heal
        say(["You're out of the Cup.",
             "TAMSIN: (from the gallery rail) Unlucky! Mum's got soup on. Come back and try again."])
        add_counter(:cup_losses)
        return false
      end
      cup_heal
      say(["The gallery stamps its feet. A runner brings water for your Pokémon."])
    end
    say(["The final.",
         "Tamsin walks out from the far side of the floor, grinning like she's already won."])
    if journey?
      say(["TAMSIN: You and me. Same as the first morning, except the whole city's watching.",
           "TAMSIN: I've lost to you every time. I wrote every one of them down. Today I'm writing a different one."])
    else
      say(["TAMSIN: The Heralds, against a kid from the Hearth. The bard's already writing it.",
           "TAMSIN: I've studied every fight you've had in this city. Every single one. Come on!"])
    end
    Stage.theme(:tamsin) rescue nil
    won = cup_final_battle
    cup_heal
    if !won
      say(["TAMSIN: I WON! I won. Write that down. Somebody write that down!",
           "TAMSIN: ...Okay. Come back tomorrow, and we'll do it properly. Best of three."])
      add_counter(:cup_losses)
      return false
    end
    cup_victory
    true
  end

  def cup_victory
    first = !flag?(:cup_champion)
    add_counter(:cup_wins)
    say(["The Hall comes apart in noise. Somebody's banging a pot with a ladle. That'll be Hellen."])
    if first
      say(["TAMSIN: (handing it over, scowling, then not) The Cup. It's a mug, really. Mum made it.",
           "TAMSIN: You're the champion. I'm putting your name on the wall under your carving.",
           "TAMSIN: Next year it's mine."])
      set_flag(:cup_champion)
      give(:RARECANDY, 3)
      give(:PPMAX, 2)
      give(:MASTERBALL)
    else
      say(["TAMSIN: Again. AGAIN. ...Fine. Here. Mum says the winner gets something every time."])
      give(%i[RARECANDY PPUP FULLRESTORE MAXREVIVE].sample)
    end
  end
end

# Tamsin, after the ending, runs the Cup (the postgame lines in 039 come first)
module FrostThaw
  class << self
    unless method_defined?(:ft_k_tamsin)
      alias ft_k_tamsin tamsin
      def tamsin(event_id = nil)
        return ft_k_tamsin(event_id) if !cup_open?
        say(POSTGAME_TAMSIN, event_id) if journey? && !flag?(:cup_invited)
        seasons_cup(event_id)
      end
    end
  end
end
