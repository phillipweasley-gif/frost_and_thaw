#===============================================================================
# Frost & Thaw - Act II, Chapter 9: Destruction's Light (script SC 9.01-9.07)
#
# Stop the chardalyn dragon before it reaches Ten-Towns' people. It leads the
# party back out into the Dale they left a few weeks ago, by the Dale's clock.
#
#   9.01 The leaves fall (Rootspire's market): summer ends; the Wall thins.
#   9.02 Mount up (the Shrine of the Twinned Dragons): the twins, and Dawnfang;
#        the dragons bind Alerion (Frostina, winter) and Meat Meat (Razzilith,
#        spring) as Dragoons. You ride behind your version's Dragoon
#        (Frost: Alerion on Frostina; Thaw: Meat Meat on Razzilith).
#   9.03 Through the Wall: the sky chase, the first air battle ("Seams"), and
#        Good Mead burning: get the bees out.
#   9.04 Malevolent presence: the dragon reaches into your rider's mind; the
#        second air battle ("Pursuit").
#   9.05 The trap (Bryn Shander, re-dressed): Anduin; the final battle.
#   9.06 The green light on the horizon: the refugees follow you south.
#   9.07 Slayers of Summer (the market, autumn): the Heralds are arrested.
#
# The chase in the air is told in scenes and fought in battles; you land in
# real places (Good Mead, Bryn Shander) and walk them.
#===============================================================================
module FrostThaw
  SW_CH9_MARKET   = 3982   # you're back in the market after the forge: the leaves fall (9.01)
  SW_CH9_GOODMEAD = 3983   # Good Mead is burning (9.03): the mead hall door, your dragon in the square
  SW_CH9_MEADSAFE = 3984   # the bees and Olivessa are out
  SW_CH9_BRYN     = 3985   # Bryn Shander is packed with refugees (9.05)
  SW_CH9_AFTER    = 3986   # the dragon is down (9.06): Anduin and the hooded woman in the square
  SW_CH9_RETURN   = 3987   # walking back into Rootspire with the refugees (9.07)
  SW_RIDES_FROSTINA = 3953 # your mount is Frostina (Frost); otherwise Razzilith

  CHARDALYN = :CHARDALYN    # the Chardalyn Dragon (Dragon/Steel)

  TEXT.merge!(
    dragons_waiting: -> {
      flag?(:mounted_up) ? ["The dragons pace the stump. They know where it's going."] :
                           ["Frostina and Razzilith are restless.",
                            "The light over the Canopy keeps changing, and they don't like it."]
    },
    your_dragon: -> { flag?(:rides_frostina) ? ["Frostina lowers her wing. Snow slides off her like water."] :
                                               ["Razzilith lowers his neck.",
                                                "Where a snowflake lands on him, a tiny leaf grows, and falls off."] },
    anduin_after: -> { ["ANDUIN: Five weeks. I'm not letting go of his sleeve.",
                        "ANDUIN: You'd have to fight me for it. I'd win, too."] },
    hooded_woman: ["A hooded goblin woman stands very still in a moving crowd.",
                   "When you look at her, she pulls her hood lower."],
    refugee: ["REFUGEE: Every town that saw it fly over sent its people here.",
              "REFUGEE: Walls. As if walls help against wings."],
    autumn_leaf: ["A brown leaf skitters over the cobbles.",
                  "People keep picking them up, turning them over, putting them in their pockets."]
  )

  module_function

  def rider_key
    flag?(:rides_frostina) ? :alerion : :meat_meat
  end

  def mount_name
    flag?(:rides_frostina) ? "Frostina" : "Razzilith"
  end

  # After the forge (SC 8.09): up to the market.
  def chapter9_start
    set_switch(SW_CH9_MARKET, true)
    transfer(2050, 31, 28, 2)
  end

  #-----------------------------------------------------------------------------
  # SC 9.01 - The leaves fall
  #-----------------------------------------------------------------------------
  def scene_leaves_fall
    set_switch(SW_CH9_MARKET, false)
    return if flag?(:summer_ended)
    say(["The gold dawn flickers. Goes rose. Then pale.",
         "For the first time in thirty years, the light changes.",
         "A leaf falls in the market. Then a hundred. People hold out their hands like it's rain."])
    if journey?
      say(["TAMSIN: (catching one) It's brown. Why is it brown? Is it sick?"])
    else
      say(["A kid with Hellen's chin catches one.",
           "TAMSIN: It's brown. Why is it brown? Is it sick?"])
    end
    say(["RHEVEN: (looking up at the crown) It's not sick, kid. Summer's over.",
         "RHEVEN: It's autumn. It's supposed to happen. ...It's been a while, that's all.",
         cl(:alberica, "Put it in your hair, Tamsin. Autumn's the best-dressed season. Trust me."),
         cl(:meat_meat, "Meat Meat has never seen autumn. Meat Meat is suspicious of autumn."),
         cl(:alerion, "It's leaves."),
         cl(:meat_meat, "Ice Prince says that about everything."),
         "Past the valley's edge, the shimmering Auroral Wall goes thin as breath.",
         "Beyond it, snowflakes that have hung in the air for four hundred years begin, slowly, to fall."].compact)
    set_flag(:summer_ended)
    set_flag(:wall_thinning)
    add_counter(:story_beats)
    state[:goal] = "The Shrine of the Twinned Dragons, on the Canopy-Tier. The dragons are waiting."
  end

  #-----------------------------------------------------------------------------
  # SC 9.02 - Mount up (the twins at the Shrine, after the Forge). From here on
  # Alerion is Frostina's Dragoon, and Meat Meat is Razzilith's.
  #-----------------------------------------------------------------------------
  def dragon_shrine(which, event_id = nil)
    if !flag?(:summer_ended) || flag?(:mounted_up)
      return talk(which == :frostina ? :frostina_shrine : :razzilith_shrine, event_id)
    end
    say(["Frostina waits at the Shrine, very still. Razzilith paces the stump and won't settle.",
         "Frostina looks past all of you, at the steps, for someone who isn't there.",
         "Then she looks at the golden dagger."], event_id)
    say([as(:meat_meat, "(holding out Dawnfang) Glimmer said to tell you. It was a better fire."),
         "Frostina lowers her head to the blade and hums four notes.",
         "She stops halfway, like a song with a voice missing."])
    speak(:alerion, "(a hand on her neck) ...I'll watch her. Somebody has to.",
                    "(a hand on her neck) ...I'll watch her.")
    # The bond (the Dragoon lore: a whisper in the blood, a second heartbeat).
    pbSEPlay("Saint7") rescue nil
    if herald?(:alerion)
      say(["Frostina turns and lays her brow against yours.",
           "Cold runs up your arm under the skin, a pale light in the veins.",
           "It settles behind your ribs, and stays."])
    else
      say(["Frostina turns and lays her brow against Alerion's.",
           "Frost-light runs up his arm under the skin, and settles behind his ribs."])
    end
    say([as(:alerion, "...She's in there. Her heart. It's beating once in her and once in me."),
         cl(:alberica, "(softly) Pretty boy. You're glowing."),
         as(:alerion, "I know.")].compact)
    if herald?(:meat_meat)
      say(["Razzilith shoves his snout into your chest hard enough to sit you down in the leaves.",
           "Something green and warm goes in over your heart, and stays."])
    else
      say(["Razzilith shoves his snout into Meat Meat's chest and sits her down in the leaves.",
           "A green glow goes in over her heart, and stays."])
    end
    say([as(:meat_meat, "(delighted) He is warm. Inside Meat Meat. Like coffee."),
         as(:meat_meat, "Razzilith is Meat Meat's. Meat Meat watches him. That is the rule now.")])
    reader = with_or_is?(:reptin) ? (herald?(:reptin) ? "You read" : "Reptin reads") : "You read"
    say(["Round the old stump, so old the bark has grown over half of it, there's a carving.",
         "#{reader} it out loud:",
         "THE TWINNED DRAGONS CHOOSE TWO. NOT RIDERS. DRAGOONS.",
         "GUIDES TO YOUNG DRAGONS. KEEPERS OF FRAGILE SEASONS.",
         "A LIVING VOW THAT THE SKY WILL OPEN AGAIN.",
         cl(:reptin, "...Well. Congratulations on the new job titles. I assume there's no pay."),
         as(:alerion, "I didn't apply."),
         as(:meat_meat, "Dragoon. Meat Meat likes it. It has teeth in it."),
         cl(:wyn, "(very softly, to Razzilith) ...Congratulations. Both of you."),
         "RAZZILITH: (a painted thought: the black dragon, and teeth) ...CHASE."].compact)
    set_flag(:dragoons_bound)
    # A Dragoon rides their own dragon; anyone else rides behind their
    # version's Dragoon.
    on_frostina = herald?(:alerion) ? true : herald?(:meat_meat) ? false : version == :frost
    if on_frostina
      set_flag(:rides_frostina)
      set_switch(SW_RIDES_FROSTINA, true)
      say([herald?(:alerion) ? "Frostina lowers her wing. You take the front, at the base of her neck, where a Dragoon sits." :
                               "Frostina lowers her wing. Alerion takes the front, at the base of her neck.",
           herald?(:alerion) ? nil : "That's where a Dragoon sits. You climb up behind him."].compact)
    else
      set_flag(:rides_razzilith)
      say([herald?(:meat_meat) ? "Razzilith lowers his neck. You take the front, where a Dragoon sits." :
                                 "Razzilith lowers his neck. Meat Meat takes the front, where a Dragoon sits.",
           herald?(:meat_meat) ? nil : "You climb up behind her."].compact)
    end
    say(["The other Heralds climb onto the other dragon, behind its Dragoon."])
    set_flag(:mounted_up)
    set_flag(:guardians_sworn)
    add_counter(:story_beats)
    set_rest_at(HEARTH_REST) rescue nil
    return if !pbConfirmMessage(_INTL("Take off after the black dragon?"))
    sky_chase
  end

  # (old saves: the Shrine event that was Shade's)
  def shade_shrine(event_id = nil)
    dragon_shrine(:frostina, event_id)
  end

  #-----------------------------------------------------------------------------
  # Air battles: a phase of the chase. Every phase you win knocks a piece off
  # the dragon's chardalyn seams, and it starts the final fight weaker.
  #-----------------------------------------------------------------------------
  # The dragon's three weapons (audit C108): frostfire breath, a sonic shatter
  # from the mirror-glass in its throat, and the burst when it dies. In battle
  # the breath is Ice Beam and Flamethrower, the shatter is Hyper Voice.
  DRAGON_MOVES = [:ICEBEAM, :FLAMETHROWER, :HYPERVOICE, :DRAGONPULSE]

  def chardalyn_dragon(level)
    pk = named_mon(CHARDALYN, level, "Chardalyn Dragon")
    begin
      pk.forget_all_moves rescue (pk.moves.clear rescue nil)
      DRAGON_MOVES.each { |m| pk.learn_move(m) rescue nil }
    rescue
    end
    pk
  end

  DRAGON_TELLS = {
    seams:   ["The dragon's jaw unhinges. Behind the black glass teeth, something burns blue and orange at once.",
              "Frostfire: a breath that freezes and scorches in the same breath. The snow under it turns to steam, then to ice again.",
              "Infernal runes glow along its ribs, red in the chardalyn, keeping time with the fire."],
    pursuit: ["The dragon opens its throat and screams. It isn't a roar: it's the sound of a mirror breaking, held for a whole breath.",
              "A sonic shatter. Every icicle on the Dale's roofs falls at once. Your ears ring and the cold in your chest cracks.",
              "Frost essence leaks from the cracks in its seams like breath on a cold morning."]
  }

  def dragon_tell(phase)
    lines = DRAGON_TELLS[phase] or return
    say(lines)
    if phase == :pursuit
      $Trainer.party.each { |p| next if p.fainted?; p.hp = [p.hp - (p.totalhp / 10), 1].max } rescue nil
      say(["(Your team is shaken by the shatter.)"])
    end
  end

  def air_battle(phase, level)
    setBattleRule("canLose") rescue nil
    dragon_tell(phase)
    won = boss_battle(chardalyn_dragon(level))
    if won
      state[:seams] = (state[:seams] || 0) + 1
      rider = rider_key
      if herald?(rider)
        say(["(You let go of #{mount_name}'s neck and drop: a falling star with a blade in it.)",
             "(Gravity is a suggestion made by someone timid.)"])
      else
        say(["#{rider == :alerion ? 'Alerion' : 'Meat Meat'} lets go of #{mount_name}'s neck and drops, blade first.",
             "A falling star with a blade in it: a Dragoon's dive."])
      end
      say(["#{mount_name} swoops under and catches #{herald?(rider) ? 'you' : (rider == :alerion ? 'him' : 'her')} a heartbeat later.",
           "A seam of black crystal cracks off the dragon and falls away into the snow, glittering."])
    else
      say(["The dragon shrugs you off and pulls ahead.",
           "You'll have to catch it at the end."])
    end
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_flag(:"air_#{phase}")
    won
  end

  #-----------------------------------------------------------------------------
  # SC 9.03 - Through the Wall
  #-----------------------------------------------------------------------------
  def sky_chase
    pbBGMPlay("Battle! Kyurem") rescue nil
    say(["You fly into the Auroral Wall. For a moment the air is cold water.",
         "Then you're through, into the Rime. No sun. Snow in your face.",
         "Two years of night, exactly as you left it."])
    speak(:alberica, "(shouting over the wind) It's the same winter! We've been gone a month!",
                     "(into the wind, quietly) ...It's the same winter. Nothing's moved.")
    say([cl(:reptin, "(shouting back) Lovely to be home, isn't it? Never again!"),
         "Ahead, a black dragon with burning gold eyes dives on a town of beehives and honey-halls.",
         "Good Mead. Its breath is a line of light. Roofs go up like paper."].compact)
    if flag?(:flight_path_seen)
      # A4's root model: the Heralds know its path.
      sayc([cl(:alerion, "(over the wind) The model at the Barricade. Good Mead first, then Bryn Shander. Same order."),
            cl(:meat_meat, "Then Meat Meat knows where it goes next. Meat Meat will be there first.")])
    end
    air_battle(:seams, 50)
    say(["You land in the burning square.",
         "Someone is pounding on the inside of the mead hall door."])
    set_switch(SW_CH9_GOODMEAD, true)
    state[:goal] = "Good Mead is burning. Get the mead hall door open."
    transfer(2031, 16, 12, 8)
  end

  def mead_hall_door(event_id = nil)
    return if flag?(:good_mead_saved)
    say(["The mead hall door is jammed in its frame, the wood swollen with heat.",
         "OLIVESSA: (inside) The bees! Get the bees out!",
         "OLIVESSA: Never mind me, get the bees!"], event_id)
    strong = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? && pk.moves.any? { |m| m && (m.id == :STRENGTH || (GameData::Move.get(m.id).type == :FIGHTING rescue false)) } }
    who = strong ? strong.name : (with_or_is?(:reptin) ? "Reptin" : "You")
    say(["#{who} #{strong ? 'hits' : 'hit'} the door. Once. Twice.",
         "It bursts inward in a cloud of smoke and furious bees.",
         "Olivessa stumbles out with them, coughing, a hive in her arms."])
    say([flag?(:good_mead_met) ? "OLIVESSA: You! The honey-cake people! It's been a month, where were you?" :
                                 "OLIVESSA: Whoever you are, you've got a hive's worth of thanks and a jar of mead coming.",
         cl(:alberica, "Mead. Darling, I could kiss you. Later. When less of the town is on fire."),
         cl(:meat_meat, "Does Good Mead have coffee?"),
         "OLIVESSA: ...We have mead.",
         cl(:meat_meat, "Good Mead is dead to Meat Meat. ...After the dragon."),
         cl(:wyn, "(cupping a dazed bee in both hands) ...You're all right. You're all right, little one.")].compact)
    set_flag(:good_mead_saved)
    set_switch(SW_CH9_MEADSAFE, true)
    add_counter(:story_beats)
    give(:FT_AURORALMOTE) rescue nil
    state[:goal] = "Back on #{mount_name}. After the dragon."
  end

  #-----------------------------------------------------------------------------
  # SC 9.04 - Malevolent presence
  #-----------------------------------------------------------------------------
  def your_dragon(event_id = nil)
    say(lines_for(:your_dragon), event_id)
    return say(["(The mead hall first. Someone's still inside.)"]) if !flag?(:good_mead_saved)
    return if !pbConfirmMessage(_INTL("Take off again?"))
    rider = rider_key
    say(["Over Redwaters, the black dragon turns its head and looks at you.",
         "Something reaches into #{herald?(rider) ? 'your' : 'your Dragoon\'s'} mind like a cold hand."])
    if herald?(rider)
      say([rider == :alerion ? "(Your own voice, flat and wrong: ...Turn back. She's right. Let it burn.)" :
                               "(Your own voice, flat and wrong: ...Meat Meat should go home. To the cold table.)",
           rider == :alerion ? "(Stillness is easier.)" : "(Meat Meat belongs there.)"])
    else
      say([rider == :alerion ? "ALERION: (flat, wrong) ...Turn back. She's right. Let it burn." :
                               "MEAT MEAT: (flat, wrong) ...Meat Meat should go home. To the cold table.",
           rider == :alerion ? "ALERION: Stillness is easier." : "MEAT MEAT: Meat Meat belongs there."])
    end
    say(["#{mount_name} falters and banks away."])
    opts = herald?(rider) ? [_INTL("Say your own name"), _INTL("Hum Shimmer's four notes"), _INTL("Listen for the second heartbeat")] :
                            [_INTL("Say their name"), _INTL("Hum Shimmer's four notes"), _INTL("Grab the reins")]
    c = pbMessage(herald?(rider) ? _INTL("The cold hand is in your head.") : _INTL("The cold hand is in your Dragoon's head."), opts, 0)
    case c
    when 1
      if flag?(:requiem_done)
        say(["You hum four notes. Frostina hums them with you, wherever she is in the snow.",
             "The cold hand lets go at once."])
        wheel(1)
      else
        say(["You hum four notes you only half know. It's enough. The cold hand lets go."])
      end
      set_flag(:hummed_song)
    when 2
      if herald?(rider)
        say(["Under the cold, #{mount_name}'s heart is still going: once in #{rider == :alerion ? 'her' : 'him'}, once in you.",
             "You hold on to that, and the cold hand lets go.",
             "#{mount_name} feels you come back, and climbs."])
      else
        say(["You grab the reins and steer straight back into the chase.",
             "Your Dragoon shakes it off in a minute.",
             rider == :alerion ? "ALERION: ...Thanks. Don't do that again." :
                                 "MEAT MEAT: ...Thank you. Meat Meat will bite you later. Fondly."])
      end
    else
      say([herald?(rider) ? "You say your own name out loud, once, the way a friend would across a table." :
                            "You say their name once, the way you'd say it across a table.",
           herald?(rider) ? "It sounds like yours again." : "They blink, and come back."])
    end
    air_battle(:pursuit, 52)
    say(["The dragon breaks off and dives south-west, toward the biggest walls in the Dale.",
         as(:alerion, "Bryn Shander. Everyone's there."),
         cl(:reptin, "Of course they are. Nobody ever runs away from the dragon. Always towards the walls.")].compact)
    set_switch(SW_CH9_GOODMEAD, false)
    set_switch(SW_CH9_BRYN, true)
    transfer(2012, 17, 12, 8)
  end

  #-----------------------------------------------------------------------------
  # SC 9.05 - The trap; 9.06 - The green light on the horizon
  #-----------------------------------------------------------------------------
  def scene_bryn_trap
    return if flag?(:dragon_down)
    say(["Bryn Shander's square is packed. Every town that saw the dragon has sent its people here.",
         "Behind walls that can't stop anything with wings.",
         "DUVESSA: (on the wall) You. You left with my seal a month ago. Where have you...",
         "DUVESSA: Never mind. Never mind! Is that thing yours?",
         as(:alerion, "It's coming here. It always meant to come here."),
         "DUVESSA: (understanding, horrified) Everyone's here. That's the point, isn't it.",
         cl(:wyn, "(very quietly) ...There are so many children."),
         cl(:alberica, "Then nobody's dying today, sweetheart. Stay close to me.")].compact)
    if with_or_is?(:reptin)
      say(["In the crowd, a tall elf in travelling clothes turns at #{herald?(:reptin) ? 'your' : "Reptin's"} voice.",
           "He has an iron ring on his finger.",
           "ANDUIN: ...Reptin?",
           as(:reptin, "(not able to move) ...Anduin.")])
    end
    pbSEPlay("Earth3") rescue nil
    $game_screen.start_shake(6, 8, 30) rescue nil
    say(["The black dragon lands in the square, scattering the crowd. It roars.",
         "#{mount_name} comes down beside you, wings spread over the crowd."])
    seams = state[:seams] || 0
    dragon = chardalyn_dragon(55)
    say(["Up close you can see what it's made of: black chardalyn, mirror-glass panes for scales, and red infernal runes cut into every plate.",
         "Under its breastplate something beats. Not an engine. A heart: an old wyrm's, stolen and frozen black.",
         "The runes are Avarice's sigils. They hold the heart in place the way a nail holds a picture.",
         "Every rune is drinking from the crowd. You can feel it pulling, a thread from every chest in the square, toward the dragon.",
         cl(:alerion, "It isn't here to burn Bryn Shander. It's here to collect it."),
         cl(:alberica, "(her memory-threads pulled tight toward it) A soul harvest. Everyone at once, all of them for the White Womb.")].compact)
    if seams > 0
      dragon.hp = [(dragon.totalhp * (1.0 - 0.2 * seams)).floor, 1].max
      say([seams >= 2 ? "(Its chardalyn seams are cracked all over where you hit them in the air. It's badly hurt.)" :
                        "(One of its chardalyn seams is cracked where you hit it in the air. It's hurt already.)"])
    end
    say(["#{mount_name} breathes first: #{flag?(:rides_frostina) ? 'a white line of frost' : 'a green rush of leaves and light'} across its flank.",
         "It staggers."])
    dragon.hp = [(dragon.hp * 0.85).floor, 1].max
    return if !boss_battle(dragon)
    $game_screen.start_flash(Color.new(200, 230, 255, 255), 20) rescue nil
    say(["As it dies, everything inside it bursts at once: frost essence and infernal fire, in a ring that races out across the square.",
         "#{mount_name} throws its wings wide over the crowd. The ring breaks on them like a wave on a sea-wall.",
         "Where it touched the ground, the cobbles are frozen and scorched in the same stroke."])
    $Trainer.party.each { |p| next if p.fainted?; p.hp = [p.hp - (p.totalhp / 8), 1].max } rescue nil
    say(["The dragon shatters into a thousand pieces of black crystal.",
         "One shard skitters to your feet. In it, a pale face, smiling.",
         "AVARICE: (from the shard) Pick me up.",
         herald?(:meat_meat) ? "You stamp on it before anyone can move." : "Meat Meat stamps on it before anyone can move.",
         as(:meat_meat, "No.")])
    set_flag(:dragon_down)
    add_counter(:story_beats)
    scene_green_light
  end

  def scene_green_light
    say(["The square is quiet. Snow falls on the black glass."])
    if with_or_is?(:reptin)
      say(["#{herald?(:reptin) ? 'You and Anduin are' : 'Reptin and Anduin are'} holding each other. Anduin is shaking.",
           "ANDUIN: Five weeks. Five weeks I waited in Bryn Shander.",
           "ANDUIN: And you come down out of the sky on a dragon. What happened to you? You look..."])
      speak(:reptin, "(trying for a smile) Older?", "...I don't know.")
      say(["ANDUIN: (touching his face) No. Like something's growing in you.",
           "ANDUIN: What have you become?"])
    end
    say(["On the south-east horizon, where Dougan's Hole used to be, a green light glows through the snow.",
         "The crown of a tree, piercing the aurora.",
         "DUVESSA: What is that?"])
    speak(:alberica, "Home. Somebody's home. Warm, and with food. The Wall's thin enough to walk through now.",
                     "...Home. It's warm there. You can walk through the Wall now.")
    say([cl(:meat_meat, "And coffee. Alberica forgot coffee."),
         cl(:alberica, "I never forget coffee, sweetheart. I just don't count it as food."),
         "DUVESSA: (to the whole square) Bryn Shander! Pack what you can carry!"].compact)
    if flag?(:husband_thawed)
      say(["The Targos widow and her husband walk past, arm in arm.",
           "WIDOW: You! The Spheal people!"])
    end
    say(["At the back of the crowd, a hooded goblin woman can't stop looking at #{herald?(:meat_meat) ? 'you' : 'Meat Meat'}.",
         "When #{herald?(:meat_meat) ? 'you look' : 'Meat Meat looks'} back, she pulls her hood lower."])
    set_flag(:refugees_follow)
    set_flag(:anduin_found)
    set_flag(:saw_hooded_woman)
    add_counter(:story_beats)
    set_switch(SW_CH9_BRYN, false)
    set_switch(SW_CH9_AFTER, true)
    state[:goal] = "Lead the refugees south-east, to Rootspire."
    return if !pbConfirmMessage(_INTL("Lead the refugees south, to the green light?"))
    lead_refugees
  end

  # Anduin in the square, after: he'll walk with you, whenever you're ready to lead them south.
  def anduin_ch9(event_id = nil)
    say(lines_for(:anduin_after), event_id)
    return if !pbConfirmMessage(_INTL("Lead the refugees south, to the green light?"))
    lead_refugees
  end

  # The walk south (from Bryn Shander, after the dragon).
  def lead_refugees(event_id = nil)
    say(["A long line of people walks out of Bryn Shander behind you, toward the green light."], event_id)
    say([cl(:alberica, "(singing to a row of tired kids, terribly) Oh, the dragon came down, and the dragon went BOOM..."),
         cl(:wyn, "(handing out mushroom biscuits) ...Um. One each. They're good for you. Sorry."),
         cl(:meat_meat, "Meat Meat is carrying the small one. The small one bites. Meat Meat respects her."),
         cl(:alerion, "They're all following you, Alberica."),
         cl(:alberica, "Everybody follows a good song, pretty boy. Even a bad one, if you're loud.")].compact)
    say(["Three days. Nobody complains.",
         "Then the snow thins, the air goes soft, and the Wall is only a shimmer you walk through."])
    set_switch(SW_CH9_AFTER, false)
    set_switch(SW_CH9_RETURN, true)
    transfer(2050, 9, 22, 6)
  end

  #-----------------------------------------------------------------------------
  # SC 9.07 - Slayers of Summer
  #-----------------------------------------------------------------------------
  def scene_slayers_of_summer
    set_switch(SW_CH9_RETURN, false)
    return if flag?(:heralds_arrested)
    say(["A long line of refugees walks out of the snow and into autumn.",
         "Rootspire's people stare at them. They stare back.",
         "Rootwardens close in with spears lowered. Rheven leads them. He looks unhappy.",
         "RHEVEN: (not meeting your eyes) In the name of the Verdant Council.",
         "RHEVEN: The Heralds of Dawn and Dusk. For the deaths of Summer Marshal Var Rime-Breaker...",
         "RHEVEN: ...and #{autumn_hand[:title]}.",
         as(:meat_meat, "Var was a coat! A coat!"),
         cl(:reptin, "(hands up, smiling) Let's all be very reasonable. Especially the people with spears."),
         cl(:alerion, "She's right. He was a coat."),
         "KELYN: (arriving, white-faced) I can't stop this. The city saw the summer die.",
         "KELYN: Half of them think you saved them. Half think you killed it.",
         "SOMEONE IN THE CROWD: Murderers!",
         "SOMEONE ELSE: Liberators!",
         "KELYN: There will be a trial. The Trials of the Roots. ...I'm sorry."].compact)
    set_flag(:heralds_arrested)
    add_counter(:story_beats)
    say(["END OF CHAPTER 9"])
    state[:goal] = "The Trials of the Roots. You're under watch, but free to move in the city."
    chapter10_start if respond_to?(:chapter10_start)
  end

  def apply_chapter9_switches
    return if !active? || !$game_switches
    $game_switches[SW_CH9_GOODMEAD] = flag?(:air_seams) && !flag?(:air_pursuit)
    $game_switches[SW_RIDES_FROSTINA] = flag?(:rides_frostina)
    $game_switches[SW_CH9_MEADSAFE] = flag?(:good_mead_saved)
    $game_switches[SW_CH9_BRYN] = flag?(:air_pursuit) && !flag?(:dragon_down)
    $game_switches[SW_CH9_AFTER] = flag?(:dragon_down) && !flag?(:heralds_arrested) && !$game_switches[SW_CH9_RETURN]
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter9_switches
  rescue StandardError => err
    FrostThaw.log("Chapter 9 switches failed: #{err.message}")
  end
}
