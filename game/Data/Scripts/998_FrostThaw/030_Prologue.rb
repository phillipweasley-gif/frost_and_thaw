#===============================================================================
# Frost & Thaw - the Prologue (script SC 0.01-0.04, New Journey)
#
# Rootspire, year 400 of the Verdant Reversal, the morning of the Festival of
# Returning Light. Tamsin wakes you at the Rooted Hearth; Professor Wynsnow's
# three Pokémon wait on a table in his lecture room; Tamsin takes the one that
# beats yours and battles you; Tamsin shows you the sixth figure on Hellen's
# wall and buys you a lantern of "real Reversal glass", and you fall through it
# into Targos, four hundred years earlier. This is real time travel, not a memory.
#
# Staged the way Pokémon games stage things (WRITING_GUIDE §9a): everyone who
# speaks is on screen, people walk in and out, "!" when they notice you, the
# rival's theme when Tamsin squares up, the professor's when you meet him,
# three Poké Balls on a table you look into one by one, and Tamsin leads you
# wherever you need to go next. The pause menu's "Goal" always says where.
#
# The prologue has its own copies of the Hearth, the market and the College
# (maps 2090-2092), so nothing in Act II's Rootspire has to change for it.
#===============================================================================
module FrostThaw
  PRO_HEARTH  = 2090
  PRO_MARKET  = 2091
  PRO_COLLEGE = 2092
  # You fell asleep on the stool at the corner table, halfway through last night's stories.
  PROLOGUE_START = [PRO_HEARTH, 13, 5, 4]

  SW_PRO_STARTER = 3960   # the battle's done: Tamsin has run back to the Hearth (and waits in the market)
  SW_PRO_MURAL   = 3962   # you've seen the sixth figure: Tamsin is at the lantern stall
  SW_PRO_LECTURE = 3956   # Tamsin has led you to Wynsnow's lecture room and waits by the table
  SW_PRO_LED     = 3957   # Tamsin has led you from the lift to the Hearth (the market Tamsin is gone)
  SW_PRO_MORNING = 3958   # breakfast's done, no starter yet: Tamsin waits outside to lead you to the lift

  # The College's east lecture room (built by tools/build_prologue.rb).
  PRO_BALL_Y = 4                    # the three balls sit on the table's top row, x 19-21
  PRO_ROOM_DOOR = [[19, 8], [20, 8]]
  PRO_WYNSNOW_DESK = [20, 3]

  MAP_NAMES.merge!(PRO_HEARTH => "The Rooted Hearth", PRO_MARKET => "Rootspire", PRO_COLLEGE => "College of Auroral Arts")
  MAP_METADATA[PRO_MARKET] = { outdoor_map: true, announce_location: true }

  # Who beats whom: Tamsin always takes the starter that beats yours.
  TAMSIN_COUNTER = { B7H220: :B330H152, B330H152: :WICKIT, WICKIT: :B7H220 }

  # Where and when, before the morning: the lanterns are hung by day and lit at
  # dusk (notes E5), and the fall comes by day.
  PRO_CARD = ["Rootspire, the city under the World Tree. Year 400 since the tree grew, all in one night.",
              "This morning is the Festival of Returning Light.",
              "Every lantern in the city is hung for the Heralds of Dawn and Dusk."]

  TEXT.merge!(
    pro_hellen: -> {
      if flag?(:saw_sixth_figure)
        ["HELLEN: Go on, then. Tamsin's already at the lantern stall.",
         "HELLEN: Take a bun for the road. Take two. You're too thin for a festival."]
      elsif flag?(:got_starter)
        ["HELLEN: Fed it yet? Everyone eats in my house. Pokémon too.",
         "HELLEN: Don't let Tamsin tell you it was a fair fight, whichever way it went.",
         "HELLEN: Tamsin's at the wall. Checks it every festival, like it's going to run off."]
      else
        ["HELLEN: (pressing a warm roll into your hand) Eat that on the way. College. Go.",
         "HELLEN: Wynsnow won't hold a Pokémon for anybody, and you know it."]
      end
    },
    pro_bard: ["BARD: \"...and the dwarf sang, and the wolf-man wept, and the cold came down like a closing door...\"",
               "BARD: (singing) \"...the Shade and the Shimmer, who smuggled the last of the light...\"",
               "BARD: Third time this morning. They'll want it thirty more by tonight."],
    pro_drinker: ["The festival's the one day a year the whole city looks up at the same thing.",
                  "Four hundred years since the tree grew in a night. Four hundred! And still gold."],
    # The edges of town are shut for the parade; the crowd tells you where to go instead.
    pro_crowd: -> {
      if flag?(:saw_sixth_figure)
        ["The parade's coming through. Nobody gets past until tonight.",
         "The lantern stall? Right outside the Rooted Hearth. Your friend's been there an age."]
      elsif flag?(:pro_battle_done)
        ["The parade's coming through. Nobody gets past until tonight.",
         "Tamsin Brightrun? Ran past toward the Rooted Hearth, yelling about some wall."]
      else
        ["The parade's coming through. Nobody gets past until tonight.",
         "Off to the College for your first Pokémon? Root-lift's by the big stair, north of here."]
      end
    },
    pro_closed: ["Shut for the festival. Everyone's out in the market."],
    pro_festival_goer: ["They're selling lanterns of real Reversal glass. From the deep roots, they say.",
                        "Where the old hag's mirrors broke."],
    pro_mural_kid: ["Are you going to the College? Everyone gets their first Pokémon at the festival.",
                    "I get mine in three years. Three! That's forever!"],
    pro_lantern_seller: -> {
      flag?(:saw_sixth_figure) ? ["LANTERN SELLER: Real Reversal glass! Dug from the deep roots!",
                                  "LANTERN SELLER: From right where the old hag's mirrors broke!"] :
        ["LANTERN SELLER: Lanterns for dusk, little one! Come back with a Pokémon to show them."]
    },
    pro_wynsnow: -> {
      if flag?(:got_starter)
        ["WYNSNOW: Hm? Still here? Go and show somebody. That's what the festival's for.",
         "WYNSNOW: And keep it away from my notes. It's already eaten a page."]
      else
        ["WYNSNOW: The table, errand-runner. Look in each Poké Ball, then choose one."]
      end
    },
    pro_tamsin_table: ["TAMSIN: Pick one already! I've been waiting since first light!",
                       "TAMSIN: ...Not that one. Unless you want that one. Then that one."],
    pro_tamsin_wall: ["TAMSIN: Look at it! Every festival I check if it moved."],
    pro_tamsin_lift: ["TAMSIN: The Hearth! The wall! Come ON, slowcoach."],
    pro_tamsin_stall: ["TAMSIN: Hang on, I'm haggling. I'm very good at haggling."],
    pro_student_west: ["STUDENT: Festival day, and I'm still revising. The Reversal doesn't take holidays.",
                       "STUDENT: That's what Wynsnow says, anyway. He also says that about lunch."],
    pro_student_hall: ["STUDENT: You're getting your first Pokémon today? I remember mine. It bit me.",
                       "STUDENT: We're friends now. It still bites me."],
    pro_lift: ["LIFT-KEEPER: Hold on to the rail. She's slow on festival days, but she gets there."]
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

  # A loop through the Still Keeper's wheel: you already have your partner.
  def pro_looped_starter
    (counter(:loop_count) rescue 0).to_i > 0 && state[:starter] ? state[:starter] : nil
  end

  #-----------------------------------------------------------------------------
  # SC 0.01 - Festival morning. Purpose: meet Tamsin and Hellen, on screen, and
  # leave with the goal: the College, by the root-lift from the market.
  #-----------------------------------------------------------------------------
  def scene_pro_morning
    hellen = Stage.find("Hellen")
    if !flag?(:pro_card_shown)                        # (over the Hearth: no daytime backdrop yet)
      set_flag(:pro_card_shown)
      say(PRO_CARD)
    end
    say(["Gold light through the tavern's knot-window. It's been gold every morning of your life.",
         "You fell asleep at the corner table again, halfway through last night's Herald stories."])
    pbSEPlay("Exit Door") rescue nil
    tamsin = Stage.actor(:tamsin, 6, 11, 8)
    Stage.walk(tamsin, 4, 4)
    say(["TAMSIN: Up! UP! #{pro_name}! Wynsnow said first light, and first light was an hour ago!"])
    Stage.approach(tamsin)
    Stage.hop(tamsin)
    say(["Tamsin Brightrun. Hellen's kid, your best friend, set on joining the tree's Rootwardens."])
    Stage.face($game_player, 8)                      # you glance at the gold window
    Stage.wait(16)
    say(["TAMSIN: Don't look at the window. It's gold every morning. The point is POKÉMON."])
    Stage.turn_to($game_player, tamsin)
    # Tamsin tows you to the bar, where Hellen has breakfast waiting.
    Stage.escort(tamsin, 6, 6, facing: 4) || Stage.walk_to($game_player, 5, 6)
    Stage.walk_to($game_player, 5, 6, face: 4) if [$game_player.x, $game_player.y] != [5, 6]
    Stage.face($game_player, 4)
    Stage.face(tamsin, 4)
    Stage.turn_to(hellen) if hellen
    say(["Hellen Brightrun keeps the Rooted Hearth, and nobody has ever left it hungry."])
    # (The plate is staging, not words: the hook word "on" stays where Tamsin
    # bounces off it, dialogue/00 §6. "Eat first" is Ma Yarbroul's too, four
    # hundred years earlier: an echo on purpose, said once by each.)
    say(["HELLEN: Eat first. Heralds didn't save the Dale on an empty stomach.",
         "TAMSIN: They saved it on pine-mead and spite. You told us!",
         "HELLEN: And I'll tell you again, with toast. Eat. Then College."])
    Stage.hop(tamsin)
    Stage.leave(tamsin, 6, 12)
    pbSEPlay("Exit Door") rescue nil
    say(["Tamsin's gone, toast in their teeth.",
         loop? ? "(The College, top of the tree. Wynsnow's table. You know this part.)" :
                 "(Your first Pokémon is at the College, top of the tree. The root-lift's in the market.)"])
    # (in the loop you already have a team: whole read P15)
    state[:goal] = loop? ? "The College, top of the tree. You know this part." :
                           "Your first Pokémon is at the College. The root-lift's by the big stair, north."
    set_flag(:intro_started)
    set_switch(SW_PRO_MORNING, true)
    Stage.cleanup
  end

  # The first time out of the Hearth (context 00 bridges; notes E10): the lift is
  # 31 tiles off across a market you've never been shown, so Tamsin waits by the
  # door and takes you there, the way a rival does in a Pokémon opening.
  def scene_pro_market_up
    return if flag?(:pro_led_up) || flag?(:pro_battle_done)
    set_flag(:pro_led_up)
    tamsin = Stage.actor(:tamsin, $game_player.x + 1, $game_player.y + 1, 8)
    if tamsin
      Stage.emote(tamsin, :exclaim)
      Stage.turn_to($game_player, tamsin)
      say(["TAMSIN: (still chewing) Finally. Lift's up by the big stair. Come ON."])
      if Stage.escort(tamsin, 17, 12, facing: 4)
        say(["LIFT-KEEPER: Two for the College? Festival's got the cage running slow."])
        Stage.hop(tamsin)
        say(["TAMSIN: Slow? I'm taking the stairs. Race you to the top!"])
        Stage.leave(tamsin, 22, 12)
      else
        say(["TAMSIN: North, by the big stair. Race you!"])
        Stage.leave(tamsin, $game_player.x, $game_player.y + 3)
      end
    end
    set_switch(SW_PRO_MORNING, false)
    Stage.cleanup
  end

  # The root-lift up to the College. Everything else in the market is shut for the festival.
  def pro_lift(event_id = nil)
    say(lines_for(:pro_lift), event_id)
    say(["The root-lift creaks up through the branches, past nests and lanterns."])
    transfer(PRO_COLLEGE, 13, 18, 8)
  end

  #-----------------------------------------------------------------------------
  # SC 0.02a - The College. Purpose: Tamsin, waiting in the hall, leads you to
  # Wynsnow's lecture room, where the three Pokémon are.
  #-----------------------------------------------------------------------------
  def scene_pro_college_arrive
    return if flag?(:got_starter)
    # She came up the stairs first and has been peeking at the table: she runs
    # out of the lecture-room corridor, off screen, to meet you (notes E17).
    tamsin = Stage.actor(:tamsin, 20, 10, 2)
    Stage.walk_to(tamsin, 13, 15, face: 2) || (tamsin && tamsin.moveto(13, 15))
    Stage.face(tamsin, 2)
    Stage.emote(tamsin, :exclaim)
    say(["TAMSIN: THERE you are! He's put them out already. All three!"])
    Stage.approach(tamsin)
    say(["TAMSIN: Wynsnow's lecture room, the east one. Come on, follow me!"])
    Stage.escort(tamsin, 20, 9, facing: 8)
    Stage.walk_to(tamsin, 22, 5, face: 4)
    Stage.remove_actor(tamsin)
    set_flag(:pro_led_to_room)
    set_switch(SW_PRO_LECTURE, true)
    state[:goal] = "Go into Professor Wynsnow's lecture room. Your first Pokémon is on his table."
    Stage.cleanup
  end

  # The lecture room's doorway: the first time in, you meet Wynsnow; trying to
  # leave without a Pokémon, Wynsnow stops you (a person, not a wall).
  def pro_lecture_door(event_id = nil)
    return if flag?(:got_starter)
    return scene_pro_wynsnow if !flag?(:met_wynsnow)
    wyn = Stage.find("Professor Wynsnow")
    Stage.emote(wyn, :exclaim) if wyn
    say(["WYNSNOW: Not yet! A Pokémon first. They're on the table, errand-runner."])
    Stage.walk($game_player, 4)
    Stage.face($game_player, 8)
  end

  #-----------------------------------------------------------------------------
  # SC 0.02 - Three Pokémon. Purpose: meet Professor Wynsnow, who sets out the
  # choice: look in each ball on the table, then pick one.
  #-----------------------------------------------------------------------------
  def scene_pro_wynsnow
    set_flag(:met_wynsnow)
    wyn = Stage.find("Professor Wynsnow")
    tamsin = Stage.find("Tamsin")
    Stage.theme(:wynsnow)
    Stage.walk($game_player, 4)
    Stage.emote(wyn, :exclaim) if wyn
    Stage.turn_to(wyn) if wyn
    say(["Professor Aldric Wynsnow, Dean of the College. You've run his errands for years.",
         "WYNSNOW: Ah. The future Rootwarden, and the errand-runner."])   # (to you first: wrong way round)
    Stage.hop(tamsin) if tamsin
    say(["TAMSIN: I'M the future Rootwarden. That one's the errand-runner. For now."])
    if (mine = pro_looped_starter)
      pro_take_ball(pro_ball_event(mine))
      say(["WYNSNOW: Three Pokémon, three futures. And... two balls. I counted three this morning.",
           "TAMSIN: (staring at your belt) Where'd you get that? You didn't have it at breakfast."])
      set_flag(:got_starter)
      return pro_rival(mine)
    end
    Stage.face(wyn, 2) if wyn                        # from the blackboard to the table
    say(["WYNSNOW: A Pokémon in each. Raise it well and it'll fight beside you. Usually for you.",
         "WYNSNOW: Three Pokémon, three futures. Choose before I start measuring them."])
    Stage.walk_to($game_player, 20, 6, face: 8)
    say(["WYNSNOW: Look in each Poké Ball first, then pick one."])
    state[:goal] = "Look in the three Poké Balls on Wynsnow's table, and choose your first Pokémon."
  end

  def pro_ball_event(species)
    i = STARTERS.index { |s| s[:species] == species }
    return nil if !i || !$game_map
    $game_map.events.values.find { |e| e.name == "Starter ball #{i + 1}" && !e.instance_variable_get(:@erased) }
  end

  # A ball leaves the table for good (its page 2 is empty once self switch A is on).
  def pro_take_ball(ev)
    return if !ev
    set_self_switch(ev.id, "A")
    ev.erase rescue nil
  end

  # The Pokémon in its opened Poké Ball, as Infinite Fusion shows starters. Our
  # own Pokémon (Wickit) are plain species with a dex number past the fusions,
  # so their picture is claimed from our sprite folder directly.
  def pro_show_in_ball(species, name)
    data = GameData::Species.get(species)
    loader = BattleSpriteLoader.new
    sprite = if new_species?(data.id_number)
               loader.ft_claim(PIFSprite.new(:BASE, data.id_number, nil, ""))
             else
               loader.get_pif_sprite_from_species(species)
             end
    showPokemonInPokeballWithMessage(sprite, _INTL("This Poké Ball contains {1}.", name))
  rescue StandardError => e
    log("Starter picture failed for #{species}: #{e.message}")
    say(["This Poké Ball contains #{name}."])
  end

  # What Wynsnow says over each ball.
  def pro_starter_line(species, name)
    case species
    when :B7H220   then "WYNSNOW: #{name}. Ice and Water. Slow to get going, and nothing knocks it over."
    when :B330H152 then "WYNSNOW: #{name}. Grass and Steel. Leaf on top, blades below. Mind your fingers."
    when :WICKIT   then "WYNSNOW: #{name}. Fire. It will set your sleeve alight at least once. Plan for twice."
    else "WYNSNOW: #{name}. A good one. They're all good ones."
    end
  end

  # A Poké Ball on the table: see the Pokémon inside, hear it, and choose it or not.
  def pro_ball(index, event_id = nil)
    s = STARTERS[index] or return
    return say(["The Poké Ball nobody chose. Wynsnow is already writing about it."]) if flag?(:got_starter)
    return say(["A Poké Ball on Professor Wynsnow's table."]) if !flag?(:met_wynsnow)
    sp = s[:species]
    name = (GameData::Species.get(sp).name rescue s[:label])
    Stage.face($game_player, 8)
    Stage.cry(sp)
    pro_show_in_ball(sp, name)
    say([pro_starter_line(sp, name)])
    wyn = Stage.find("Professor Wynsnow")
    pbCallBub(2, wyn.id) rescue nil if wyn
    if !pbConfirmMessage(_INTL("WYNSNOW: So! {1}? Think carefully. It's already thinking about you.", name))
      say(["WYNSNOW: Take your time. Not all of it, mind. The lanterns are lit at dusk."])
      return
    end
    pro_take_ball(event_id && $game_map.events[event_id])
    pkmn = starter_pokemon(sp)
    pbAddPokemonSilent(pkmn)
    state[:starter] = sp
    set_flag(:got_starter)
    pbMessage(_INTL("\\me[Pkmn get]{1} received {2}!", $Trainer.name, name))
    begin
      pbNickname(pkmn)
    rescue StandardError => e
      log("Nickname: #{e.message}")
    end
    pro_rival(sp)
  end

  #-----------------------------------------------------------------------------
  # SC 0.02b - Tamsin takes the one that beats yours, and your first battle.
  # Purpose: the rivalry, and your Pokémon's first fight; then Tamsin runs home.
  #-----------------------------------------------------------------------------
  def pro_rival(mine)
    wyn = Stage.find("Professor Wynsnow")
    tamsin = Stage.find("Tamsin")
    theirs = TAMSIN_COUNTER[mine] || :B330H152
    their_name = (GameData::Species.get(theirs).name rescue "that one")
    Stage.emote(tamsin, :exclaim) if tamsin
    Stage.theme(:tamsin)
    say(["TAMSIN: Then I'll take the one that beats yours. Obviously."])
    ball = pro_ball_event(theirs)
    if tamsin && ball
      Stage.walk_to(tamsin, ball.x, ball.y + 2, face: 8)
    end
    pro_take_ball(ball)
    Stage.cry(theirs)
    pbMessage(_INTL("\\me[Pkmn get]Tamsin received {1}!", their_name))
    Stage.turn_to(tamsin) if tamsin
    say(["WYNSNOW: Obviously. Battle in the hall. Not in my lecture room. Never in my lecture room."])
    # Out to the hall: Tamsin squares up, Wynsnow watches from his doorway.
    Stage.walk_to(tamsin, 20, 11, face: 8) if tamsin
    Stage.walk_to($game_player, 20, 9, face: 2)
    Stage.walk_to(wyn, 19, 8, face: 2) if wyn
    Stage.hop(tamsin) if tamsin
    say([pro_type_gloat(mine),
         "TAMSIN: Rootwarden against errand-runner. Ready? Doesn't matter. GO!"])
    won = tamsin_prologue_battle(theirs)
    Stage.theme(:tamsin)
    if won
      set_flag(:pro_beat_tamsin)
      say(["TAMSIN: ...Best of three. Later. That one didn't count!"])
    else
      Stage.hop(tamsin, 2) if tamsin
      say(["TAMSIN: Ha! HA! Rootwarden material. I told you. I told everyone."])
    end
    Stage.approach(wyn) if wyn
    say(["WYNSNOW: Lost? Good. Now you know what it hits like. Next time you'll pick your moment."]) if !won
    begin
      pbFadeOutIn { $Trainer.heal_party }
    rescue StandardError
      $Trainer.heal_party rescue nil
    end
    Stage.jingle(:heal)
    say(["WYNSNOW: There. Patched up. Off you go, both of you. I have measuring to do.",
         "WYNSNOW: And these. Five Poké Balls, two Potions. The College's festival gift."])
    pbReceiveItem(:POKEBALL, 5) rescue nil
    pbReceiveItem(:POTION, 2) rescue nil
    say(["WYNSNOW: Wild ones live in long grass. Tire one out, then throw a ball. Bring me notes."])
    Stage.walk_to(wyn, *PRO_WYNSNOW_DESK, face: 8, wait_for: false) if wyn
    Stage.turn_to(tamsin) if tamsin
    say(["TAMSIN: The Hearth! The wall! If it moved this year, I'm telling EVERYONE.",
         "TAMSIN: Come ON!"])
    Stage.leave(tamsin, 13, 19) if tamsin
    Stage.theme(nil)
    set_flag(:pro_battle_done)
    set_switch(SW_PRO_STARTER, true)
    state[:goal] = "Head back down to the market. Tamsin's racing you to the Hearth."
    Stage.cleanup
  end

  # Tamsin takes the counter, and says why (the type rule, shown as a gloat).
  def pro_type_gloat(mine)
    case TAMSIN_COUNTER[mine]
    when :B330H152 then "TAMSIN: Grass beats Water. Everybody knows that!"
    when :WICKIT   then "TAMSIN: Fire beats Grass. Everybody knows that!"
    when :B7H220   then "TAMSIN: Water beats Fire. Everybody knows that!"
    end
  end

  def tamsin_prologue_battle(species)
    key = [:FT_TAMSIN_I, "Tamsin", 1]
    mon = { species: species, level: STARTER_LEVEL }
    mon[:moves] = STARTER_MOVES[species] if STARTER_MOVES[species]
    hash = { id: key, id_number: 9890, trainer_type: :FT_TAMSIN_I, name: "Tamsin", version: 1,
             items: [], lose_text: "Hey! That one was practice.", pokemon: [mon] }
    GameData::Trainer::DATA[key] = GameData::Trainer.new(hash)
    # A rival's fight, not a gym leader's: FT_TAMSIN_I borrows Brock's class,
    # music and all (notes E12).
    $PokemonGlobal.nextBattleBGM = pbStringToAudioFile(TAMSIN_BATTLE_BGM) rescue nil
    return pbTrainerBattle(:FT_TAMSIN_I, "Tamsin", nil, false, 1, true) ? true : false
  rescue StandardError => e
    log("Tamsin's prologue battle failed: #{e.message}")
    return false
  ensure
    $PokemonGlobal.nextBattleBGM = nil rescue nil
  end
  TAMSIN_BATTLE_BGM = "Pokemon HeartGold and SoulSilver - Trainer Battle (Kanto)"

  #-----------------------------------------------------------------------------
  # Back in the market: Tamsin waits by the lift and leads you to the Hearth.
  #-----------------------------------------------------------------------------
  def scene_pro_market_lead
    return if flag?(:saw_sixth_figure)
    tamsin = Stage.find("Tamsin")
    say(["The lift rattles down to the market. Tamsin's already at the bottom, out of breath."]) if tamsin
    if tamsin
      Stage.approach(tamsin) if (tamsin.x - $game_player.x).abs + (tamsin.y - $game_player.y).abs > 1
      Stage.emote(tamsin, :exclaim)
      Stage.turn_to(tamsin)
      say(["TAMSIN: Too slow! The Hearth's this way. Follow me!"])
      if Stage.escort(tamsin, 31, 28)
        Stage.leave(tamsin, 31, 27)
        pbSEPlay("Entering Door") rescue nil
        Stage.walk_to($game_player, 31, 28, face: 8)
        set_flag(:pro_led)
        set_switch(SW_PRO_LED, true)
        state[:goal] = "Tamsin's at the mural in the Rooted Hearth."
        transfer(PRO_HEARTH, 5, 11, 8)
        return
      end
      say(["TAMSIN: The Hearth's down by the lantern stall. Race you!"])
      Stage.leave(tamsin, 31, 27)
    end
    set_flag(:pro_led)
    set_switch(SW_PRO_LED, true)
    state[:goal] = "Go back to the Rooted Hearth, down by the lantern stall. Tamsin's at the mural."
  end

  #-----------------------------------------------------------------------------
  # SC 0.03 - The sixth figure. Purpose: see the faceless sixth figure (it's
  # you) before you know it's you. Tamsin calls you over as you come in.
  #-----------------------------------------------------------------------------
  def scene_pro_mural
    return if flag?(:saw_sixth_figure)
    tamsin = Stage.find("Tamsin")
    hellen = Stage.find("Hellen")
    if tamsin
      Stage.pan_to(tamsin.x, tamsin.y)               # the camera finds Tamsin at the far wall
      Stage.emote(tamsin, :exclaim)
      say(["TAMSIN: Over here! Quick! I think it moved!"])
      Stage.pan_back
    end
    Stage.walk_to($game_player, 15, 8, face: 6)
    Stage.face(tamsin, 6) if tamsin
    Stage.theme(:heralds)
    say(["TAMSIN: Look. Every festival I check. Every single one."])
    Stage.panel("S-00")                               # the carving itself (art request; skipped until it exists)
    say(["Five heroes in the living wood. One wreathed in snow, one in flame, one with a lute.",
         "One with a wolf. One half in shadow, with a knife. Two dragons coil above them."])
    Stage.panel_off
    # "Last night's stories": Tamsin recites the legend and gets it wrong; Hellen,
    # who told it, puts it right (context/00.md M1).
    Stage.hop(tamsin) if tamsin
    say(["TAMSIN: The Heralds of Dawn and Dusk! Alberica, with the lute. Reptin and his wolf.",
         "TAMSIN: Alerion, all in snow. The Shimmer, in the fire. And the Shade. The knife one's my favourite."])
    Stage.turn_to(tamsin) if tamsin
    say(["TAMSIN: They walked into the never-ending winter, fought a hag, and the dragons ate her."])
    if hellen
      Stage.pan_to(9, 7)                              # the bar and the wall, both in view
      Stage.turn_to(hellen)
    end
    say(["HELLEN: (from the bar) Nobody ate anybody. They broke her mirrors, that's all.",
         "HELLEN: Something in the glass let go. A seed took root, and the tree grew in one night."])
    Stage.face(tamsin, 4) if tamsin
    say(["TAMSIN: The Verdant Reversal. Year nought. Four hundred years ago today. I KNOW, Hellen.",
         "HELLEN: Then tell them who that is in the corner."])
    Stage.pan_back
    Stage.face(tamsin, 6) if tamsin
    Stage.face($game_player, 6)
    say(["In the corner, half-hidden by a root, a small sixth figure. No face.",
         counter(:loop_count) > 0 ? "And a seventh: a dwarf woman made of ice, hands over her heart." : nil,
         counter(:loop_count) > 0 ? "Nobody remembers carving it." : nil].compact)
    Stage.turn_to(tamsin) if tamsin
    say(["TAMSIN: ...Nobody knows. Not even the carver.",
         "TAMSIN: But it's further out from the root than last year. I'm SURE it is."])
    if hellen
      Stage.pan_to(9, 7)
      Stage.turn_to(hellen)
    end
    say(["HELLEN: The carver was my great-great-something. She said the wood grew it."])
    # Hellen is the only one who notices your first Pokémon, and feeds it: it's out of its ball to be fed.
    Stage.partner_out
    mon = ($Trainer.party.first rescue nil)
    say(["#{mon ? mon.name : 'Your Pokémon'} wriggles out of its ball at the smell of the kitchen.",
         "HELLEN: There it is. Your first. Here, it can have a crust. Everyone eats in my house."])
    Stage.partner_in
    Stage.pan_back
    Stage.turn_to(tamsin) if tamsin
    say(["TAMSIN: Lanterns! The stall's right outside. Come on, before they sell the good ones."])
    Stage.leave(tamsin, 6, 12) if tamsin
    pbSEPlay("Exit Door") rescue nil
    Stage.theme(nil)
    set_flag(:saw_sixth_figure)
    set_switch(SW_PRO_MURAL, true)
    state[:goal] = "Tamsin's at the lantern stall, just outside the Hearth."
    Stage.cleanup
  end

  # The mural itself, when you look at it.
  def pro_mural(event_id = nil)
    if flag?(:saw_sixth_figure)
      return say(["Five heroes and two dragons. In the corner, half-hidden by a root, a small sixth figure.",
                  "It has no face."], event_id)
    end
    say(["Five heroes carved in the living wood, with two dragons above them.",
         flag?(:pro_battle_done) ? "Tamsin wants to show you this properly. Tamsin always does." :
                                   "Tamsin will want to show you this properly. Tamsin always does."], event_id)
  end

  #-----------------------------------------------------------------------------
  # SC 0.04 - Reversal glass. Purpose: Tamsin's gift, and the fall. Plays as
  # you come out of the Hearth: Tamsin is at the stall, haggling.
  #-----------------------------------------------------------------------------
  def scene_pro_lantern
    seller = Stage.find("Lantern seller")
    tamsin = Stage.find("Tamsin")
    looped = counter(:loop_count) > 0
    Stage.turn_to(seller, tamsin) if seller && tamsin
    say(["LANTERN SELLER: Real Reversal glass! Dug from the deep roots!",
         "LANTERN SELLER: From right where the old hag's mirrors broke!"])
    if tamsin
      Stage.turn_to(tamsin)
      say([looped ? "TAMSIN: Weird. I already bought you this. Didn't I?" :
                    "TAMSIN: It's not real. Everybody knows it's not real."])
      # The world's first rule, from the one man with a reason to say it.
      if seller && !looped
        Stage.turn_to(seller, tamsin)
        say(["LANTERN SELLER: Mirror-glass keeps what it sees, little one. That glass saw the Heralds."])
      end
      Stage.turn_to(tamsin, seller) if seller
      pbSEPlay("Mart buy item") rescue nil
      Stage.wait(20)
      Stage.approach(tamsin)
      say([looped ? "TAMSIN: ...Here." : "TAMSIN: Here. For your first Pokémon day, #{pro_name}."])
    end
    pbMessage(_INTL("\\me[Item get]Tamsin gave you a lantern of Reversal glass!"))
    Stage.cry(state[:starter]) if state[:starter]        # your partner is the first to sense it
    say(["The glass in the lantern is old, with a crack like frost."])
    pbSEPlay("Earth3") rescue nil
    $game_screen.start_shake(4, 6, 20) rescue nil
    pbBGMFade(1.0) rescue nil                            # the festival music cuts dead
    Stage.wait(20)
    say(["The ground shudders. Once. The lantern swings in your hand."])
    if tamsin && !looped
      Stage.turn_to(tamsin)
      say(["TAMSIN: Did you feel that?"])
    end
    Stage.panel("S-01", fade: 20)
    say(["Inside the crack in the glass, it's night.",
         "A dock in a blizzard. Five figures on a gangplank. A lute. A wolf. A knife."])
    $game_screen.start_shake(2, 4, 16) rescue nil
    Stage.panel_off(fade: 12)
    say(["The crack is bigger than the lantern now. Cold comes out of it, and the smell of the sea."])
    pro_look_in
    Stage.emote(tamsin, :exclaim) if tamsin
    say(["TAMSIN: Hey... #{pro_name}? What are you..."])
    fall_through
  end

  # The player's one input in the fall (story/00 §8 step 6): the lantern pulses
  # until you look into it. No menu; press the button, or step toward the light.
  def pro_look_in
    return if !Stage.map?
    frames = 0
    loop do
      $game_screen.start_flash(Color.new(200, 230, 255, 90), 20) rescue nil if frames % 40 == 0
      Stage.wait(1)
      frames += 1
      break if (Input.trigger?(Input::USE) rescue false) || (Input.trigger?(Input::C) rescue false)
      break if Input.dir4.to_i > 0 rescue false
      break if frames > 1200                              # (never strand anyone: about half a minute)
    end
    $game_player.straighten rescue nil
  end

  # Into the glass, and out of the air over the Targos pier, four hundred years
  # earlier. The white holds through the map change (the Targos side clears it).
  def fall_through
    begin
      $game_screen.start_flash(Color.new(255, 255, 255, 255), 30) rescue nil
      $game_screen.start_tone_change(Tone.new(255, 255, 255, 0), 20)
      pbWait(24) rescue nil
    rescue StandardError
    end
    say(["The glass pulls like a door in a gale. You fall into the Heralds' winter."])
    pbMessage(_INTL("TAMSIN: (far away, over the white) {1}!", pro_name)) if counter(:loop_count).to_i == 0
    set_flag(:fell_through)
    state[:goal] = nil                     # the prologue's goals end here; Targos sets the next
    state[:white_pending] = true
    [SW_PRO_STARTER, SW_PRO_MURAL, SW_PRO_LECTURE, SW_PRO_LED].each { |sw| set_switch(sw, false) }
    Stage.cleanup
    transfer(*TARGOS_START)
  end

  # The white from the fall clears once you're on the Targos pier.
  def clear_fall_white
    return if !state[:white_pending]
    return if [PRO_HEARTH, PRO_MARKET, PRO_COLLEGE].include?($game_map.map_id)
    state[:white_pending] = nil
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 30) rescue nil
  end

  # Turns a story switch on or off and makes the map's people re-check it.
  def set_switch(id, on)
    return if !$game_switches
    $game_switches[id] = on ? true : false
    $game_map.need_refresh = true if $game_map
  end

  def apply_prologue_switches
    return if !active? || !$game_switches
    set_switch(SW_PRO_LECTURE, prologue? && flag?(:pro_led_to_room))
    set_switch(SW_PRO_STARTER, prologue? && flag?(:pro_battle_done))
    set_switch(SW_PRO_LED, prologue? && flag?(:pro_led))
    set_switch(SW_PRO_MURAL, prologue? && flag?(:saw_sixth_figure))
    set_switch(SW_PRO_MORNING, prologue? && flag?(:intro_started) && !flag?(:pro_led_up) && !flag?(:pro_battle_done))
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_prologue_switches
    FrostThaw.clear_fall_white
  rescue StandardError => err
    FrostThaw.log("Prologue switches failed: #{err.message}")
  end
}
