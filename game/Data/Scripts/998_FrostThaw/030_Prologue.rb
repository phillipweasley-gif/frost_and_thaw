#===============================================================================
# Frost & Thaw - the Prologue (script SC 0.01-0.04, New Journey)
#
# Rootspire, year 400 of the Verdant Reversal, the morning of the Festival of
# Returning Light. You wake at the Rooted Hearth, get your first Pokémon from
# Professor Wynsnow, lose (or win) to Tamsin, see the sixth figure on Hellen's
# wall, and fall through a lantern of "real Reversal glass" into Targos, four
# hundred years earlier. This is real time travel, not a memory.
#
# The prologue has its own copies of the Hearth, the market and the College
# (maps 2090-2092), so nothing in Act II's Rootspire has to change for it.
#===============================================================================
module FrostThaw
  PRO_HEARTH  = 2090
  PRO_MARKET  = 2091
  PRO_COLLEGE = 2092
  PROLOGUE_START = [PRO_HEARTH, 8, 8, 2]

  SW_PRO_STARTER = 3960   # you have your first Pokémon: Tamsin waits by the mural
  SW_PRO_MURAL   = 3962   # you've seen the sixth figure: the lantern stall is waiting

  MAP_NAMES.merge!(PRO_HEARTH => "The Rooted Hearth", PRO_MARKET => "Rootspire", PRO_COLLEGE => "College of Auroral Arts")
  MAP_METADATA[PRO_MARKET] = { outdoor_map: true, announce_location: true }

  # Who beats whom: Tamsin always takes the starter that beats yours.
  TAMSIN_COUNTER = { B7H220: :B330H152, B330H152: :WICKIT, WICKIT: :B7H220 }

  TEXT.merge!(
    pro_hellen: -> {
      if flag?(:saw_sixth_figure)
        ["HELLEN: Go on, then. Lanterns are lit, and Tamsin's been at that stall since breakfast.",
         "HELLEN: Take a bun for the road. Take two. You're too thin for a festival."]
      elsif flag?(:got_starter)
        ["HELLEN: There it is. Your first. Here, it can have a crust. Everyone eats in my house.",
         "HELLEN: Don't let Tamsin tell you it was a fair fight, whichever way it went.",
         "HELLEN: She's at the wall. She checks it every festival."]
      else
        ["HELLEN: (pressing a warm roll into your hand) Eat that on the way. College. Go.",
         "HELLEN: Wynsnow won't hold a Pokémon for anybody, and you know it."]
      end
    },
    pro_bard: ["BARD: \"...and the dwarf sang, and the wolf-man wept, and the cold came down like a closing door...\"",
               "BARD: Third time this morning. They'll want it thirty more by tonight."],
    pro_drinker: ["The festival's the one day a year the whole city looks up at the same thing.",
                  "Four hundred years since the tree grew in a night. Four hundred! And the light's still gold."],
    pro_crowd: ["The parade's coming through. You won't get past this way until tonight."],
    pro_closed: ["Shut for the festival. Everyone's out in the market."],
    pro_festival_goer: ["They're selling lanterns of real Reversal glass. From the deep roots, they say.",
                        "Where the old hag's mirrors broke."],
    pro_mural_kid: ["Are you going to the College? Everyone gets their first Pokémon at the festival.",
                    "I get mine in three years. Three! That's forever!"],
    pro_lantern_seller: -> {
      flag?(:saw_sixth_figure) ? ["LANTERN SELLER: Real Reversal glass! Dug out of the deep roots, where the old hag's mirrors broke!"] :
        ["LANTERN SELLER: Lanterns tonight, little one! Come back when you've a Pokémon to show them to."]
    },
    pro_wynsnow: -> {
      flag?(:got_starter) ?
        ["WYNSNOW: Hm? Still here? Go and show somebody. That's what the festival's for.",
         "WYNSNOW: And keep it away from my notes. It's already eaten a page."] :
        ["WYNSNOW: ..."]
    },
    pro_lift: ["LIFT-KEEPER: Up to the Canopy-Tier? The College is right at the top. Hold on to the rail."]
  )

  module_function

  def prologue?
    return journey? && !flag?(:fell_through)
  end

  # Tamsin calls you by your full name. Always.
  def pro_name
    n = ($Trainer.name rescue nil)
    n.is_a?(String) && !n.empty? ? n : "you"
  end

  # SC 0.01 - Festival morning
  def scene_pro_morning
    say(["Gold light through the tavern's knot-window. It's been gold every morning of your life.",
         "TAMSIN: Up! UP! #{pro_name}! Wynsnow said first light, and first light was an hour ago!",
         "TAMSIN: Yes, it's always first light. That's not the point. The point is POKÉMON.",
         "HELLEN: (sliding a plate across) Eat first. Heralds didn't save the Dale on an empty stomach.",
         "TAMSIN: They saved it on pine-mead and spite. You told us!",
         "HELLEN: And I'll tell you again, with toast. Eat. Then College.",
         "Tamsin is already out of the door, toast in her teeth.",
         "(The College of Auroral Arts is at the top of the tree. Take the root-lift from the market.)"])
    set_flag(:intro_started)
  end

  # The root-lift up to the College. Everything else in the market is shut for the festival.
  def pro_lift(event_id = nil)
    say(lines_for(:pro_lift), event_id)
    transfer(PRO_COLLEGE, 13, 18, 8)
  end

  # SC 0.02 - Three Pokémon
  def scene_pro_college
    say(["WYNSNOW: Ah. The errand-runner and the future Rootwarden.",
         "TAMSIN: I'm the future Rootwarden. #{pro_name}'s the errand-runner. For now.",
         "WYNSNOW: Three Pokémon, three futures. Choose before I start measuring them."])
    choose_starter
    set_flag(:got_starter)
    mine = state[:starter]
    theirs = TAMSIN_COUNTER[mine] || :B330H152
    their_name = (GameData::Species.get(theirs).name rescue "that one")
    say(["TAMSIN: Then I'll take the one that beats yours. Obviously.",
         "Tamsin scoops up #{their_name} before Wynsnow can blink.",
         "WYNSNOW: Obviously. Battle in the courtyard. Not the lab. Never the lab."])
    won = tamsin_prologue_battle(theirs)
    if won
      set_flag(:pro_beat_tamsin)
      say(["TAMSIN: ...Best of three. Later. That one didn't count, #{pro_name}. It was practice!"])
    else
      say(["TAMSIN: Ha! HA! Rootwarden material. I told you. I told everyone."])
    end
    begin
      pbFadeOutIn { $Trainer.heal_party }
    rescue StandardError
      $Trainer.heal_party rescue nil
    end
    say(["WYNSNOW: There. Patched up. Off you go, both of you. I have measuring to do.",
         "TAMSIN: Hearth! Hellen's got festival cake, and there's something on the wall I want to show you.",
         "TAMSIN: Come ON, #{pro_name}!"])
    set_switch(SW_PRO_STARTER, true)
  end

  def tamsin_prologue_battle(species)
    key = [:FT_TAMSIN_I, "Tamsin", 1]
    mon = { species: species, level: STARTER_LEVEL }
    mon[:moves] = STARTER_MOVES[species] if STARTER_MOVES[species]
    hash = { id: key, id_number: 9890, trainer_type: :FT_TAMSIN_I, name: "Tamsin", version: 1,
             items: [], lose_text: "Hey! That one was practice.", pokemon: [mon] }
    GameData::Trainer::DATA[key] = GameData::Trainer.new(hash)
    return pbTrainerBattle(:FT_TAMSIN_I, "Tamsin", nil, false, 1, true) ? true : false
  rescue StandardError => e
    log("Tamsin's prologue battle failed: #{e.message}")
    return false
  end

  # SC 0.03 - The sixth figure (Tamsin by the wall, or the wall itself)
  def pro_mural(event_id = nil)
    if !flag?(:got_starter)
      return say(["Five heroes carved in the living wood, with two dragons above them.",
                  "Tamsin will want to show you this properly. She always does."], event_id)
    end
    if flag?(:saw_sixth_figure)
      return say(["Five heroes, two dragons, and in the corner, half-hidden by a root,",
                  "a small sixth figure with no face."], event_id)
    end
    say(["TAMSIN: Look. Every festival I check if it moved.",
         "Five heroes carved in the living wood: one wreathed in snow, one in flame, one with a lute,",
         "one with a wolf, and one half in shadow, with a knife.",
         "Two dragons coil above them. In the corner, half-hidden by a root, a small sixth figure. No face.",
         "TAMSIN: Hellen says nobody's ever known who that is. Not even the carver.",
         counter(:loop_count) > 0 ? "And a seventh figure: a dwarf woman made of ice, hands over her heart." : nil,
         counter(:loop_count) > 0 ? "Nobody remembers carving it." : nil,
         "HELLEN: (from the bar) The carver was my great-great-something. She said the wood grew it.",
         "TAMSIN: Lanterns! The stall's out by the door. Come on, #{pro_name}, before they sell the good ones."].compact, event_id)
    set_flag(:saw_sixth_figure)
    set_switch(SW_PRO_MURAL, true)
  end

  # SC 0.04 - Reversal glass (autorun in the market once you've seen the wall)
  def scene_pro_lantern
    say(["LANTERN SELLER: Real Reversal glass! Dug out of the deep roots, where the old hag's mirrors broke!",
         counter(:loop_count) > 0 ? "TAMSIN: Weird. I already bought you this. Didn't I?" :
                                    "TAMSIN: It's not real. Everybody knows it's not real.",
         "She buys it anyway.",
         counter(:loop_count) > 0 ? "TAMSIN: Here." : "TAMSIN: Here. For your first Pokémon day, #{pro_name}.",
         "The glass in the lantern is old, with a crack like frost.",
         "The ground shudders. Once. Every lantern in the market swings. Nobody else notices."])
    pbSEPlay("Earth3") rescue nil
    $game_screen.start_shake(4, 6, 20) rescue nil
    Stage.panel("S-01", fade: 20)
    say(["The crack in the glass widens. Inside it, it's night.",
         "A dock in a blizzard. Five figures coming down a gangplank.",
         "TAMSIN: Hey... #{pro_name}? What are you..."])
    $game_screen.start_shake(2, 4, 16) rescue nil
    Stage.panel_off(fade: 12)
    fall_through
  end

  # Into the glass, and out of the air over the Targos pier, four hundred years earlier.
  def fall_through
    begin
      $game_screen.start_tone_change(Tone.new(255, 255, 255, 0), 20)
      pbWait(24) rescue nil
    rescue StandardError
    end
    set_flag(:fell_through)
    set_switch(SW_PRO_STARTER, false)
    set_switch(SW_PRO_MURAL, false)
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 20) rescue nil
    transfer(*TARGOS_START)
  end

  # Turns a story switch on or off and makes the map's people re-check it.
  def set_switch(id, on)
    return if !$game_switches
    $game_switches[id] = on ? true : false
    $game_map.need_refresh = true if $game_map
  end

  def apply_prologue_switches
    return if !active? || !$game_switches
    set_switch(SW_PRO_STARTER, prologue? && flag?(:got_starter))
    set_switch(SW_PRO_MURAL, prologue? && flag?(:saw_sixth_figure))
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_prologue_switches
  rescue StandardError => err
    FrostThaw.log("Prologue switches failed: #{err.message}")
  end
}
