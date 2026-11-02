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

  # The College's east lecture room (built by tools/build_prologue.rb).
  PRO_BALL_Y = 4                    # the three balls sit on the table's top row, x 19-21
  PRO_ROOM_DOOR = [[19, 8], [20, 8]]
  PRO_WYNSNOW_DESK = [20, 3]

  MAP_NAMES.merge!(PRO_HEARTH => "The Rooted Hearth", PRO_MARKET => "Rootspire", PRO_COLLEGE => "College of Auroral Arts")
  MAP_METADATA[PRO_MARKET] = { outdoor_map: true, announce_location: true }

  # Who beats whom: Tamsin always takes the starter that beats yours.
  TAMSIN_COUNTER = { B7H220: :B330H152, B330H152: :WICKIT, WICKIT: :B7H220 }

  TEXT.merge!(
    pro_hellen: -> {
      if flag?(:saw_sixth_figure)
        ["HELLEN: Go on, then. Lanterns are lit, and Tamsin's already at the stall.",
         "HELLEN: Take a bun for the road. Take two. You're too thin for a festival."]
      elsif flag?(:got_starter)
        ["HELLEN: There it is. Your first. Here, it can have a crust. Everyone eats in my house.",
         "HELLEN: Don't let Tamsin tell you it was a fair fight, whichever way it went.",
         "HELLEN: They're at the wall. They check it every festival."]
      else
        ["HELLEN: (pressing a warm roll into your hand) Eat that on the way. College. Go.",
         "HELLEN: Wynsnow won't hold a Pokémon for anybody, and you know it."]
      end
    },
    pro_bard: ["BARD: \"...and the dwarf sang, and the wolf-man wept, and the cold came down like a closing door...\"",
               "BARD: Third time this morning. They'll want it thirty more by tonight."],
    pro_drinker: ["The festival's the one day a year the whole city looks up at the same thing.",
                  "Four hundred years since the tree grew in a night. Four hundred! And the light's still gold."],
    # The edges of town are shut for the parade; the crowd tells you where to go instead.
    pro_crowd: -> {
      if flag?(:saw_sixth_figure)
        ["The parade's coming through. Nobody gets past until tonight.",
         "The lantern stall? Right outside the Rooted Hearth. Your friend's been there an age."]
      elsif flag?(:pro_battle_done)
        ["The parade's coming through. Nobody gets past until tonight.",
         "Tamsin Brightrun? Ran past toward the Rooted Hearth, yelling about cake."]
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
      flag?(:saw_sixth_figure) ? ["LANTERN SELLER: Real Reversal glass! Dug out of the deep roots, where the old hag's mirrors broke!"] :
        ["LANTERN SELLER: Lanterns tonight, little one! Come back when you've a Pokémon to show them to."]
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
    pro_tamsin_stall: ["TAMSIN: Hang on, I'm haggling. I'm very good at haggling."],
    pro_student_west: ["STUDENT: Festival day, and I'm still revising. The Reversal doesn't take holidays.",
                       "STUDENT: That's what Wynsnow says, anyway. He also says that about lunch."],
    pro_student_hall: ["STUDENT: You're getting your first Pokémon today? I remember mine. It bit me.",
                       "STUDENT: We're friends now. It still bites me."],
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
    say(["Gold light through the tavern's knot-window. It's been gold every morning of your life.",
         "You fell asleep at the corner table again, somewhere in the middle of last night's stories."])
    pbSEPlay("Exit Door") rescue nil
    tamsin = Stage.actor(:tamsin, 6, 11, 8)
    Stage.walk(tamsin, 4, 4)
    say(["TAMSIN: Up! UP! #{pro_name}! Wynsnow said first light, and first light was an hour ago!"])
    Stage.approach(tamsin)
    Stage.hop(tamsin)
    say(["Tamsin Brightrun: Hellen's kid, about your age, and set on being a Rootwarden since birth.",
         "TAMSIN: Yes, it's always first light. That's not the point. The point is POKÉMON."])
    # Tamsin tows you to the bar, where Hellen has breakfast waiting.
    Stage.escort(tamsin, 6, 6, facing: 4) || Stage.walk_to($game_player, 5, 6)
    Stage.walk_to($game_player, 5, 6, face: 4) if [$game_player.x, $game_player.y] != [5, 6]
    Stage.face($game_player, 4)
    Stage.face(tamsin, 4)
    Stage.turn_to(hellen) if hellen
    say(["Hellen Brightrun keeps the Rooted Hearth, and nobody has ever left it hungry.",
         "HELLEN: (sliding a plate over) Eat first. Heralds didn't save the Dale on an empty stomach.",
         "TAMSIN: They saved it on pine-mead and spite. You told us!",
         "HELLEN: And I'll tell you again, with toast. Eat. Then College."])
    Stage.hop(tamsin)
    Stage.leave(tamsin, 6, 12)
    pbSEPlay("Exit Door") rescue nil
    say(["Tamsin's gone, toast in their teeth.",
         "(The College of Auroral Arts is at the top of the tree. Take the root-lift from the market.)"])
    state[:goal] = "Get to the College at the top of the tree. Take the root-lift from the market."
    set_flag(:intro_started)
    Stage.cleanup
  end

  # The root-lift up to the College. Everything else in the market is shut for the festival.
  def pro_lift(event_id = nil)
    say(lines_for(:pro_lift), event_id)
    transfer(PRO_COLLEGE, 13, 18, 8)
  end

  #-----------------------------------------------------------------------------
  # SC 0.02a - The College. Purpose: Tamsin, waiting in the hall, leads you to
  # Wynsnow's lecture room, where the three Pokémon are.
  #-----------------------------------------------------------------------------
  def scene_pro_college_arrive
    return if flag?(:got_starter)
    tamsin = Stage.actor(:tamsin, 13, 15, 8)
    Stage.wait(12)
    Stage.face(tamsin, 2)
    Stage.emote(tamsin, :exclaim)
    say(["TAMSIN: THERE you are! He's put them out already, #{pro_name}. All three!"])
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
         "WYNSNOW: Ah. The errand-runner and the future Rootwarden."])
    Stage.hop(tamsin) if tamsin
    say(["TAMSIN: I'm the future Rootwarden. #{pro_name}'s the errand-runner. For now."])
    if (mine = pro_looped_starter)
      pro_take_ball(pro_ball_event(mine))
      say(["WYNSNOW: Three Pokémon, three futures. And... two balls. I counted three this morning.",
           "TAMSIN: (staring at your belt) Where'd you get that? You didn't have it at breakfast."])
      set_flag(:got_starter)
      return pro_rival(mine)
    end
    say(["WYNSNOW: Three Pokémon, three futures. Choose before I start measuring them."])
    Stage.walk_to($game_player, 20, 6, face: 8)
    say(["WYNSNOW: Look in each Poké Ball first, then pick one. I'll be writing all of it down."])
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
    if !pbConfirmMessage(_INTL("WYNSNOW: So! You want {1}, the {2} Pokémon?", name, s[:label]))
      say(["WYNSNOW: Take your time. Not all of it, mind. The lanterns go up at dusk."])
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
    say(["TAMSIN: Rootwarden against errand-runner. Ready? Doesn't matter. GO!"])
    won = tamsin_prologue_battle(theirs)
    Stage.theme(:tamsin)
    if won
      set_flag(:pro_beat_tamsin)
      say(["TAMSIN: ...Best of three. Later. That one didn't count, #{pro_name}. It was practice!"])
    else
      Stage.hop(tamsin, 2) if tamsin
      say(["TAMSIN: Ha! HA! Rootwarden material. I told you. I told everyone."])
    end
    Stage.approach(wyn) if wyn
    begin
      pbFadeOutIn { $Trainer.heal_party }
    rescue StandardError
      $Trainer.heal_party rescue nil
    end
    Stage.jingle(:heal)
    say(["WYNSNOW: There. Patched up. Off you go, both of you. I have measuring to do."])
    Stage.walk_to(wyn, *PRO_WYNSNOW_DESK, face: 8, wait_for: false) if wyn
    Stage.turn_to(tamsin) if tamsin
    say(["TAMSIN: Hearth! Hellen's got festival cake.",
         "TAMSIN: And there's something on the wall I want to show you.",
         "TAMSIN: Come ON, #{pro_name}!"])
    Stage.leave(tamsin, 13, 19) if tamsin
    Stage.theme(nil)
    set_flag(:pro_battle_done)
    set_switch(SW_PRO_STARTER, true)
    state[:goal] = "Tamsin's run back to the Rooted Hearth. Take the root-lift down to the market."
    Stage.cleanup
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

  #-----------------------------------------------------------------------------
  # Back in the market: Tamsin waits by the lift and leads you to the Hearth.
  #-----------------------------------------------------------------------------
  def scene_pro_market_lead
    return if flag?(:saw_sixth_figure)
    tamsin = Stage.find("Tamsin")
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
      say(["TAMSIN: Over here! Quick, before the cake goes."])
      Stage.pan_back
    end
    Stage.walk_to($game_player, 15, 8, face: 6)
    Stage.face(tamsin, 6) if tamsin
    say(["TAMSIN: Look. Every festival I check if it moved.",
         "Five heroes, carved in the living wood. One wreathed in snow, one in flame, one with a lute.",
         "One with a wolf. One half in shadow, with a knife. Two dragons coil above them.",
         "In the corner, half-hidden by a root, a small sixth figure. No face.",
         counter(:loop_count) > 0 ? "And a seventh: a dwarf woman made of ice, hands over her heart." : nil,
         counter(:loop_count) > 0 ? "Nobody remembers carving it." : nil].compact)
    Stage.turn_to(tamsin) if tamsin
    say(["TAMSIN: Hellen says nobody's ever known who that is. Not even the carver."])
    if hellen
      Stage.pan_to(hellen.x, hellen.y)
      Stage.turn_to(hellen)
    end
    say(["HELLEN: (from the bar) The carver was my great-great-something. She said the wood grew it."])
    Stage.pan_back
    say(["TAMSIN: Lanterns! The stall's right outside. Come on, before they sell the good ones."])
    Stage.leave(tamsin, 6, 12) if tamsin
    pbSEPlay("Exit Door") rescue nil
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
         flag?(:pro_battle_done) ? "Tamsin wants to show you this properly. They always do." :
                                   "Tamsin will want to show you this properly. They always do."], event_id)
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
    say(["LANTERN SELLER: Real Reversal glass! Dug out of the deep roots, where the old hag's mirrors broke!"])
    if tamsin
      Stage.turn_to(tamsin)
      say([looped ? "TAMSIN: Weird. I already bought you this. Didn't I?" :
                    "TAMSIN: It's not real. Everybody knows it's not real."])
      Stage.turn_to(tamsin, seller) if seller
      pbSEPlay("Mart buy item") rescue nil
      Stage.wait(20)
      Stage.approach(tamsin)
      say([looped ? "TAMSIN: ...Here." : "TAMSIN: Here. For your first Pokémon day, #{pro_name}."])
    end
    pbMessage(_INTL("\\me[Item get]Tamsin gave you a lantern of Reversal glass!"))
    say(["The glass in the lantern is old, with a crack like frost."])
    pbSEPlay("Earth3") rescue nil
    $game_screen.start_shake(4, 6, 20) rescue nil
    Stage.wait(20)
    say(["The ground shudders. Once. Every lantern in the market swings. Nobody else notices."])
    Stage.panel("S-01", fade: 20)
    say(["The crack in the glass widens. Inside it, it's night.",
         "A dock in a blizzard. Five figures coming down a gangplank."])
    $game_screen.start_shake(2, 4, 16) rescue nil
    Stage.panel_off(fade: 12)
    Stage.emote(tamsin, :exclaim) if tamsin
    say(["TAMSIN: Hey... #{pro_name}? What are you..."])
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
    state[:goal] = nil                     # the prologue's goals end here; Targos sets the next
    [SW_PRO_STARTER, SW_PRO_MURAL, SW_PRO_LECTURE, SW_PRO_LED].each { |sw| set_switch(sw, false) }
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 20) rescue nil
    Stage.cleanup
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
    set_switch(SW_PRO_LECTURE, prologue? && flag?(:pro_led_to_room))
    set_switch(SW_PRO_STARTER, prologue? && flag?(:pro_battle_done))
    set_switch(SW_PRO_LED, prologue? && flag?(:pro_led))
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
