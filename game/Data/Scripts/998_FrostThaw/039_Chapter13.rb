#===============================================================================
# Frost & Thaw - Act III, Chapter 13: Grimskalle; the endings and the epilogue
# (script SC 13.01-13.10, 14.01-14.02)
#
#   2083 The Hall of the Four Winds (13.01): four doors, four tablets
#   2084 The Test of Cruelty (13.02, Meat Meat)      2085 Endurance (13.03, Reptin)
#   2086 The Test of Isolation (13.04, Alerion)      2087 Preservation (13.05, Alberica)
#   2088 The Crown (13.06 Iskra, 13.07 Sephek)
#   2089 The Throne of Frost (13.08 the Frostmaiden, 13.09 the Rewritten Auril,
#        13.10 what do we do with a god?)
#
# Endings: A, Shatter; B, the Third Way; C, the Still Keeper, which is a loop:
# time throws you back to the start with your team, and the story replays with
# people half-remembering it, until you choose A or B. In a loop you can skip
# ahead at the start of each act ("You remember this").
#===============================================================================
module FrostThaw
  SW_CROWN_OPEN    = 3999
  SW_FROSTINA_FREE = 3951   # Frostina is out of her crystal: the way to the throne room
  SW_AURIL_DOWN    = 3952   # the Frostmaiden has fallen (the throne room's scene is over)

  MAPS.merge!(hall_four_winds: 2083, test_cruelty: 2084, test_endurance: 2085, test_isolation: 2086,
              test_preservation: 2087, the_crown: 2088, throne_of_frost: 2089)
  MAP_NAMES.merge!(2083 => "The Hall of the Four Winds", 2084 => "The Test of Cruelty", 2085 => "The Test of Endurance",
                   2086 => "The Test of Isolation", 2087 => "The Test of Preservation", 2088 => "The Crown",
                   2089 => "The Throne of Frost")
  (2083..2089).each { |m| MAP_METADATA[m] = { announce_location: true, battle_environment: :Ice } }
  MAP_METADATA[2088] = { outdoor_map: true, announce_location: true, battle_environment: :Snow, weather: [:Snow, 100] }
  (2083..2089).each { |m| AREAS[m] = :grimskalle }
  HALL_ARRIVAL = [2083, 12, 18, 8]

  # The four tests: [key, Herald, tablet, trainer key, what it weakens]
  TESTS = [[:cruelty, :meat_meat, "CRUELTY", :gunvald, "the Cold Crone"],
           [:endurance, :reptin, "ENDURANCE", :jarund, "the Brittle Maiden"],
           [:isolation, :alerion, "ISOLATION", :tiger_queen, "Winter's Womb"],
           [:preservation, :alberica, "PRESERVATION", :still_keeper, "the Rewritten Auril"]]

  TRAINER_TYPES.merge!(
    FT_SHADE_KING: ["Shade of a King", :CHANNELER, 0, 200, :LEADER_Pryce],
    FT_STILL_KEEPER: ["The Still Keeper", :CHANNELER, 1, 220, :LEADER_Pryce],
    FT_FROST_SAINT: ["Frost Saint", :CHANNELER, 0, 220, :LEADER_Pryce]
  )
  TRAINERS.merge!(
    gunvald:      [:FT_SHADE_KING, "Gunvald", [[:URSARING, 61], [:B217H460, 62], [:B216H217, 62], [:B217H473, 63]],
                   "Compassion... feeds four mouths. Hm."],
    jarund:       [:FT_SHADE_KING, "Jarund", [[:STANTLER, 61], [:B234H473, 62], [:B473H234, 62], [:MAMOSWINE, 63]],
                   "You carried them. I left them. Which of us outlasted?"],
    tiger_queen:  [:FT_SHADE_KING, "The Tiger Queen", [[:B53H461, 62], [:B461H53, 63], [:B128H461, 63], [:B461H55, 64]],
                   "Then go back to them. Alone was only ever quiet."],
    still_keeper: [:FT_STILL_KEEPER, "Still Keeper", [[:B124H429, 63], [:B429H478, 64], [:B478H124, 64], [:B429H124, 65]],
                   "Memory's for remembering. ...I'd forgotten."],
    sephek_saint: [:FT_FROST_SAINT, "Sephek", [[:B87H461, 64], [:B144H215, 65], [:B473H87, 65], [:B215H478, 66]],
                   "She was never mine to take."]
  )
  TRAINER_INTROS.merge!(
    gunvald: "GUNVALD'S SHADE: Cut.", jarund: "JARUND'S SHADE: Outlast.", tiger_queen: "THE TIGER QUEEN'S SHADE: Stay.",
    still_keeper: "STILL KEEPER: Stay. Exactly like this.", sephek_saint: "SEPHEK: I held the knife."
  )

  # The Frostmaiden's forms (stand-ins until they have their own species)
  AURIL_CRONE  = :AURIL_CRONE # the Cold Crone: Ice/Dark (owl, wolf and goat)
  AURIL_MAIDEN = :B124H478    # the Brittle Maiden: a woman of ice (fragile to Fire)
  AURIL_WOMB   = :B131H362    # Winter's Womb: a floating diamond
  AURIL_REWRITTEN = :AURIL_REWRITTEN # the Rewritten Auril: Ice/Ghost

  TEXT.merge!(
    four_tablets: -> {
      broken = TESTS.select { |k, *| flag?(:"test_#{k}_broken") }.map { |t| t[2] }
      ["Four tablets of ice, each carved with one word:", "CRUELTY. ENDURANCE. ISOLATION. PRESERVATION."] +
        (broken.empty? ? [] : ["Cracked clean through: #{broken.join(', ')}."])
    },
    ice_dock_edge: ["The ice dock ends in black water. The way is up."],
    silver_egg: ["A silver egg in a nest of frost and feathers. It's warm.", "Something to come back for, one day."],
    throne_shut: ["A door of ice in the crown's heart.",
                  "Sephek stands between you and the crystal. The crystal stands between you and the door."],
    crown_stair_shut: ["A stair of ice winds up toward the crown.", "Four tests stand between you and it."],
    test_done: ["The vision has gone. Only an ice chamber now, and a tablet's echo on the wall."],
    loop_hall_carving: ["A seventh figure on Hellen's wall: a dwarf woman made of ice, hands over her heart.",
                        "Nobody remembers carving it."]
  )

  module_function

  def loop?
    (counter(:loop_count) rescue 0).to_i > 0
  end

  def tests_faced
    TESTS.count { |k, *| flag?(:"test_#{k}_faced") }
  end

  #-----------------------------------------------------------------------------
  # SC 13.01 - The Hall of the Four Winds
  #-----------------------------------------------------------------------------
  def scene_hall_four_winds
    return if flag?(:hall_entered)
    set_flag(:hall_entered)
    say(["A round hall with four doors, and four tablets of ice.",
         "Each is carved with one word. CRUELTY. ENDURANCE. ISOLATION. PRESERVATION.",
         "SEPHEK: (his voice from everywhere at once) Her tenets. Pass her tests, and she'll hear you.",
         "SEPHEK: Fail, and you'll stay here. And be beautiful."])
    speak(:alberica, "And if we don't want to pass them her way?", "...What if we pass them ours?")
    sayc(["SEPHEK: (after a long pause, almost curious) ...No one has ever asked that.",
          cl(:meat_meat, "Meat Meat will pass the tests. Then Meat Meat will bite the tests."),
          cl(:alerion, "That's not how tests work."),
          (with_or_is?(:alerion) ? cl(:meat_meat, "It is now.") : nil)])
    state[:goal] = "The four tests. Each Herald goes with you into one."
  end

  # A Herald's line in a test: theirs, your thought if you're them, or your partner's voice if they're missing.
  def tl(key, text)
    return as(key, text) if herald?(key)
    return "#{COMPANION_NAMES[key]}: #{text}" if with_or_is?(key)
    "(Your own voice, where theirs should be: #{text.sub(/\A\([^()]*\)\s*/, '')})"
  end

  # The test's key line: when you are that Herald, you choose how to say it.
  def test_line(key, loud, quiet, event_id = nil)
    return speak(key, loud, quiet, event_id) if herald?(key)
    say([tl(key, loud)], event_id)
  end

  def test_door(key, event_id = nil)
    return say(lines_for(:test_done), event_id) if flag?(:"test_#{key}_faced")
    send(:"test_#{key}", event_id)
  end

  def finish_test(key, won)
    set_flag(:"test_#{key}_faced")
    set_flag(:"test_#{key}_broken") if won
    add_counter(:story_beats)
    t = TESTS.find { |k, *| k == key }
    say(won ? ["Somewhere in the hall, the tablet #{t[2]} cracks from top to bottom.",
               "(#{t[4].sub(/^./, &:upcase)} will be weaker.)"] :
              ["The vision fades. The tablet #{t[2]} stays whole.",
               "(You'll face what it guards at full strength.)"])
    if tests_faced >= 4
      ($game_switches[SW_CROWN_OPEN] = true; $game_map.need_refresh = true if $game_map) if $game_switches
      state[:goal] = "Up the stair of ice, to the Crown."
    end
    transfer(*HALL_ARRIVAL)
  end

  # SC 13.02 - The Test of Cruelty (Meat Meat)
  def test_cruelty(event_id = nil)
    mm = herald?(:meat_meat)
    Stage.overlay("O-03", fade: 20)                  # the tests are visions
    say(["A camp of hide tents in a blizzard. Starving people.",
         "A big man in a bearskin sharpens a knife, watching four old people huddled by a dead fire.",
         "GUNVALD'S SHADE: Four mouths, or the whole tribe. Compassion makes you weak.",
         "GUNVALD'S SHADE: Cruelty is a knife. Cut.",
         "A blade of pure thought forms in #{mm ? 'your' : "Meat Meat's"} hand, on its own.",
         "AURIL: (a whisper) You were made a weapon, V-7. Be one."], event_id)
    test_line(:meat_meat, "(letting the blade go out) Meat Meat was made a weapon. Meat Meat chose to be a seed.",
              "(letting the blade go out) ...No. Meat Meat says no.")
    say(["#{mm ? 'You open your pack' : 'She opens her pack'}. Hellen's food:",
         "bread, cheese, honey cakes from Good Mead.",
         "One by one, to the old people.",
         tl(:meat_meat, "Eat. Meat Meat is not hungry. ...Meat Meat is a little hungry. Eat anyway.")])
    Stage.overlay_off("O-03", fade: 16)
    finish_test(:cruelty, trainer(:gunvald, nil))
  end

  # SC 13.03 - The Test of Endurance (Reptin)
  def test_endurance(event_id = nil)
    rp = herald?(:reptin)
    Stage.overlay("O-03", fade: 20)
    say(["A line of people walks into a blizzard.",
         "A child falls and doesn't get up. The line keeps walking.",
         "JARUND'S SHADE: Outlast. By any means. Those who fall, fall.",
         "#{rp ? 'You pick' : 'Reptin picks'} the child up. Then the next one who falls.",
         "Slower. The line pulls away."], event_id)
    test_line(:reptin, "(through gritted teeth) Somebody has to hold them. Fine. It's me.",
              "(to the children) Behind me. Now.")
    if flag?(:fed_pack)
      say(["Grey shapes run out of the snow on either side: wolves, thin and silent.",
           "They walk with the children between them, out of the storm."])
    else
      wolf = Stage.herald(:reptin, 1, 0, 2)
      Stage.pose(wolf, "P-REP-04", 0, frames: [0, 1, 2], per: 10) if wolf   # elf, half wolf, wolf
      say([rp ? "Your wolf comes out on its own. Slower, on four legs, you carry the children on your back." :
                "His wolf comes out on its own. Slower, on four legs, he carries the children on his back."])
      Stage.pose(wolf, "P-REP-04", 0, frames: [3], per: 20) if wolf          # an elf again, on his knees
      Stage.overlay_off("O-03", fade: 16)
      Stage.cleanup rescue nil
    end
    say(["(In this chamber the blizzard swallows anything that isn't a blow you can put your weight behind.)"])
    Stage.overlay_off("O-03", fade: 16)
    $ft_physical_only = true
    won = trainer(:jarund, nil)
    $ft_physical_only = false
    finish_test(:endurance, won)
  end

  # SC 13.04 - The Test of Isolation (Alerion)
  def test_isolation(event_id = nil)
    al = herald?(:alerion)
    Stage.overlay("O-03", fade: 20)
    say(["#{al ? 'Your' : "Alerion's"} village, snowed under.",
         "A warm house with a fire in it, and a door that would lock behind #{al ? 'you' : 'him'}.",
         "THE TIGER QUEEN'S SHADE: Solitude unlocks everything. Stay.",
         "THE TIGER QUEEN'S SHADE: Alone, nothing can be taken from you again.",
         tl(:alerion, "(a hand on the door) ...It would be quiet.")], event_id)
    say([flag?(:talion_released) ? "A boy's voice from nowhere, warm this time: \"Go back to them. You came back for me.\"" :
                                   "Frostina's four notes, very faint, from somewhere above the fortress."])
    if flag?(:dragoons_bound)
      say(["Behind #{al ? 'your' : 'his'} ribs, very faint and very far, a second heartbeat."])
    end
    test_line(:alerion, "(stepping back from the door) ...I need help. I've always needed help.",
              "(stepping back from the door) ...No. Not alone.")
    say([al ? "You hold out your hand, to whoever's there." : "He holds out his hand to you."])
    Stage.overlay_off("O-03", fade: 16)
    finish_test(:isolation, trainer(:tiger_queen, nil))
  end

  # SC 13.05 - The Test of Preservation (Alberica)
  def test_preservation(event_id = nil)
    Stage.overlay("O-03", fade: 20)
    say(["A little boy in wolf furs, the last of his family, laughing in the snow.",
         "A madman's shadow moves toward him.",
         "A figure steps out of the ice: Alberica, older, made of frost.",
         "The rune glows white on her chest.",
         "The Still Keeper."], event_id)
    if loop?
      say(["STILL KEEPER: You came back. They always come back. Stay this time."])
    else
      say(["STILL KEEPER: (Alberica's voice, gentle) You can keep him. Exactly like this. Laughing.",
           "STILL KEEPER: Forever. Nothing will ever hurt him. Isn't that what memory is for?"])
    end
    test_line(:alberica, "(very quiet) No, sweetheart. Memory's for remembering.", "(very quiet) ...No.")
    say([tl(:alberica, "He has to grow up, so there's something left to remember."),
         "STILL KEEPER: He'll suffer. He'll lose people. He'll die.",
         tl(:alberica, "Yes. And somebody will sing about it.")])
    if flag?(:canticle_learned)
      say(["#{herald?(:alberica) ? 'You sing' : 'Alberica sings'} the Cycle Canticle: three verses. Hope, loss, endurance.",
           "The frost on the reflection runs like water."])
      $ft_keeper_halved = true
    end
    Stage.overlay_off("O-03", fade: 16)
    won = trainer(:still_keeper, nil)
    $ft_keeper_halved = false
    finish_test(:preservation, won)
  end

  #-----------------------------------------------------------------------------
  # SC 13.06 - The roe's nest; 13.07 - The Frost Saint
  #-----------------------------------------------------------------------------
  def scene_the_crown
    return if flag?(:crown_reached)
    set_flag(:crown_reached)
    sayc(["On the roof of the world, inside the prongs of an ice crown,",
          "a vast white roe stands over a nest.",
          "In the nest, a silver egg. Beside it, Frostina in her crystal, her eyes open.",
          cl(:alerion, "(very quietly) I'm here. I'm here."),
          "Iskra lowers her antlers."])
  end

  def iskra(event_id = nil)
    return say(["Iskra watches you over her nest. She doesn't move."], event_id) if flag?(:iskra_passed)
    c = pbMessage(_INTL("Iskra lowers her antlers."), [_INTL("Hum Shimmer's four notes"), _INTL("Approach slowly"), _INTL("Fight")], 1)
    if c == 0 && flag?(:hummed_song)
      Stage.balloon($game_player, "B-05", frames: 50)
      Stage.wait(20)
      Stage.balloon(stage_event("Frostina's crystal"), "B-05", frames: 60)
      say(["You hum four notes. Inside the crystal, Frostina's eyes move. She hums them back.",
           "Iskra goes still. She listens. She steps aside."])
      set_flag(:iskra_calm)
    elsif c == 0 || c == 1
      say(["You go forward one step at a time.", "Iskra watches every step. She doesn't charge."])
    else
      return if !boss_battle(named_mon(:B234H144, 64, "Iskra"))
      say(["Iskra stumbles back over her nest and stays there, guarding the egg.", "She lets you pass."])
    end
    set_flag(:iskra_passed)
    say(["The silver egg stays in the nest. (Something to come back for, one day.)"]) if flag?(:iskra_calm)
  end

  # Frostina comes out of the crystal; her Dragoon feels it.
  def frostina_heartbeat
    say([herald?(:alerion) ? "(Behind your ribs, loud again: two heartbeats.)" :
                             "Alerion's hand goes to his own chest. Two heartbeats, loud again.",
         herald?(:alerion) ? "You breathe out for what feels like the first time since the Shrine." :
                             "He breathes out for what looks like the first time since the Shrine."])
  end

  def sephek_crown(event_id = nil)
    return if flag?(:sephek_turned) || flag?(:sephek_beaten)
    return say(["Iskra stands between you and the crystal."], event_id) if !flag?(:iskra_passed)
    say(["SEPHEK: (standing between you and the crystal) I held the knife.",
         "SEPHEK: I've held a lot of knives for her. Four hundred years in the ice.",
         "SEPHEK: The only thing I remembered was a woman laughing on an altar."], event_id)
    opts = []
    opts << [:rose, _INTL("Show him the Undying Rose")] if flag?(:rose_cutting)
    opts << [:shade, _INTL("Let Alerion speak")]
    opts << [:fight, _INTL("Fight him")]
    c = pbMessage(_INTL("Sephek..."), opts.map(&:last), opts.size - 1)
    pick = opts[[c, 0].max][0]
    if pick == :rose
      say(["He takes it. It stays warm in his frozen hand.", "SEPHEK: ...She grew this. From that."])
    elsif pick == :shade
      speak(:alerion, "She told you there was a third way. You heard her.", "...You heard her. You still do.")
      say([as(:alerion, "You've been hearing her for four hundred years.")])
    end
    if pick != :fight && flag?(:shade_curse_broken)
      say(["SEPHEK: (looking at Frostina) Her silence honours her. Not her return.",
           "He puts his hand on the crystal, and it melts.",
           "Frostina tumbles out and shakes herself like a dog."])
      frostina_heartbeat
      say(["Sephek puts his hand on his own chest."])
      sev = stage_event("Sephek")
      heart = sev ? Stage.fx("E-14", sev, oy: 36, loop_from: 0) : nil     # the heart, beating in his hand
      say(["SEPHEK: And this. She doesn't get this."])
      Stage.stop_fx(heart)
      $game_screen.start_flash(Color.new(180, 230, 255, 200), 10) rescue nil
      sayc(["He pulls out the frost-light heart and crushes it. He doesn't fall.",
            "He only looks, for the first time, cold.",
            "SEPHEK: (shivering, almost laughing) Oh. So that's what it feels like.",
            cl(:alberica, "Welcome to being a person, sweetheart. It's awful. You'll love it.")])
      set_flag(:sephek_turned)
    else
      say(["SEPHEK: Then let's see whose cold is colder."]) if pick != :fight
      return if !trainer(:sephek_saint, nil)
      say(["SEPHEK: (beaten, breaking the crystal himself) ...She was never mine to take.",
           "Frostina tumbles out and shakes herself like a dog."])
      frostina_heartbeat
      set_flag(:sephek_beaten)
    end
    sayc([cl(:meat_meat, "Frosty! Meat Meat missed you. Razzy missed you more. Razzy is very loud about it.")])
    set_flag(:frostina_freed)
    ($game_switches[SW_FROSTINA_FREE] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    state[:goal] = "The Throne of Frost."
  end

  #-----------------------------------------------------------------------------
  # SC 13.08 - The Frostmaiden; 13.09 - The Rewritten Auril
  #-----------------------------------------------------------------------------
  # One stage of the final fight: weaker if its test was broken; the twins breathe once each.
  def auril_stage(species, level, name, weakened)
    mon = named_mon(species, level, name)
    frac = 1.0
    frac -= 0.35 if weakened
    frac -= 0.15                      # Twin Breath: Razzilith and Frostina, one turn each
    mon.hp = [(mon.totalhp * frac).floor, 1].max
    boss_battle(mon)
  end

  def scene_throne
    return if flag?(:auril_down)
    if !flag?(:throne_entered)
      set_flag(:throne_entered)
      say(["A throne room with nothing in it but a throne. She needs nothing else.",
           "The woman in frost-furs is sitting on it.",
           "AURIL: You broke my tests."])
      speak(:alberica, "We passed them, darling. Our way.", "We passed them. Our way.")
      sayc(["AURIL: There is no other way. There is cold, and what's left when it's done.",
            "AURIL: (standing) I loved the world. I loved it so much I couldn't bear for it to change.",
            "AURIL: You'd have done the same, if you'd seen what I've seen end.",
            cl(:reptin, "No. We'd have grieved. It's messier. It works."),
            cl(:alerion, "I tried it your way. It doesn't."),
            "Through the roof, a green dragon lands on the ice, and Frostina beside him.",
            "They'll breathe for you, once each, every time she changes."])
    end
    stage = state[:auril_stage] || 0
    stages = [[AURIL_CRONE, 66, "The Cold Crone", :test_cruelty_broken],
              [AURIL_MAIDEN, 67, "The Brittle Maiden", :test_endurance_broken],
              [AURIL_WOMB, 68, "Winter's Womb", :test_isolation_broken]]
    while stage < stages.size
      sp, lv, nm, f = stages[stage]
      return if !auril_stage(sp, lv, nm, flag?(f))
      stage += 1
      state[:auril_stage] = stage
      say([["The crone's furs fall away. Under them is a woman made of ice, so thin the light goes through.",
            "The maiden shatters. The shards spin together into a floating diamond, humming.",
            "The diamond cracks."][stage - 1]])
    end
    scene_rewritten
  end

  def scene_rewritten
    al = herald?(:alberica)
    say(["The diamond cracks, and it pulls.",
         "Frost reaches out of it three ways.",
         "Toward Frostina. Toward #{al ? 'your' : "Alberica's"} rune. Toward the heart in Sephek's chest."])
    if flag?(:sephek_turned)
      say(["The third strand finds nothing. Sephek's chest is empty, and the frost recoils."])
    else
      say(["The third strand finds Sephek's heart and drags him, choking, toward the diamond."])
    end
    say(["Frostina screams. #{al ? 'You are' : 'Alberica is'} lifted off the floor."])
    speak(:alberica, "(through gritted teeth) Somebody. Remember for me.", "(through gritted teeth) ...Remember me.")
    sayc([as(:meat_meat, "Meat Meat remembers! Meat Meat remembers ALL of it!"),
          cl(:wyn, "...We all do. We're right here. Hold on."),
          "In the middle of the room something forms: a woman made of all three.",
          "Shimmer's face for a moment. Then Alberica's. Then no one's."])
    if flag?(:council_phildendrin)
      say(["(Phildendrin's people at the dock sent up a fire-arrow and a bag of every potion in Rootspire.)",
           "(Your team is fully healed.)"])
      pbFadeOutIn { $Trainer.heal_party } rescue nil
    end
    sung = false
    if flag?(:canticle_learned)
      sung = pbConfirmMessage(_INTL("Have Alberica sing the Cycle Canticle now? (It frees her from the pull, and takes one strand away.)")) rescue true
      say(["#{al ? 'You sing' : 'Alberica sings'}. Hope, loss, endurance.",
           "The strand round #{al ? 'you' : 'her'} goes slack and falls away."]) if sung
    end
    strands = (flag?(:sephek_turned) ? 2 : 3) - (sung ? 1 : 0)
    phases = strands >= 3 ? 2 : 1
    phases.times do |i|
      if i == 0 && flag?(:council_anduin)
        say(["A root breaks up through the ice floor, green and stubborn, and wraps your team for a breath.",
             "Hyphora's blessing. Everyone is healed."])
        pbFadeOutIn { $Trainer.heal_party } rescue nil
      end
      mon = named_mon(AURIL_REWRITTEN, 70, "The Rewritten Auril")
      frac = flag?(:test_preservation_broken) ? 0.7 : 1.0
      frac -= 0.15 if strands <= 1
      mon.hp = [(mon.totalhp * frac).floor, 1].max
      return if !boss_battle(mon)
      say(["She comes apart, and pulls herself back together round the last strand."]) if i == 0 && phases > 1
    end
    say(["The Rewritten Auril comes apart. Frostina drops, free.",
         "#{al ? 'You fall' : 'Alberica falls'} into #{herald?(:reptin) ? 'your' : "Reptin's"} arms. The rune on #{al ? 'your' : 'her'} chest is gone.",
         "On the floor lies a small, cracked diamond with a light inside it, very faint.",
         "It's Auril. All that's left of her.",
         "AURIL: (tiny, from the diamond) Everything I loved, I kept. Everything you love, you lose."])
    speak(:alberica, "(kneeling beside it) Yes. That's how you know you loved it.", "(kneeling beside it) ...I know.")
    set_flag(:auril_down)
    ($game_switches[SW_AURIL_DOWN] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    scene_what_do_we_do
  end

  #-----------------------------------------------------------------------------
  # SC 13.10 - What do we do with a god? and the endings
  #-----------------------------------------------------------------------------
  def scene_what_do_we_do
    say(["The Heralds stand round the tiny light on the floor. Nobody moves.",
         herald?(:meat_meat) ? "Dawnfang is in your hand. (One stab. No more winters. Ever.)" :
                               "MEAT MEAT: (Dawnfang in her hand) One stab. No more winters. Ever.",
         herald?(:meat_meat) ? "(...You'd miss snow a little.)" : "MEAT MEAT: ...Meat Meat would miss snow a little."])
    say(["SEPHEK: She'll come back. At the solstice. Gods with worshippers always do. Angrier."]) if flag?(:sephek_turned)
    sayc([cl(:reptin, "Or we hold her. Somebody could.")])
    speak(:alberica, "(very still) I could. I'm the one she wanted.", "(very still) ...I could.")
    speak(:alerion, "(looking at Frostina) Or. There was always a third way.", "(looking at Frostina) ...There's a third way.")
    sayc([cl(:wyn, "...Seasons. Like the spore beds. Things rest. Then they come back.")])
    if (counter(:loop_count) rescue 0).to_i >= 2
      say([herald?(:alberica) ? "(You've done this before. Haven't you. ...Don't hold her.)" :
                                "ALBERICA: I've done this before. Haven't I. ...Don't let me hold her."])
    end
    c = pbMessage(_INTL("What do we do with a god?"),
                  [_INTL("\"End her.\""), _INTL("\"Give winter back its place.\""), _INTL("\"Let Alberica hold her.\"")], -1)
    case c
    when 0 then ending_shatter
    when 2 then ending_still_keeper
    else ending_third_way
    end
  end

  def ending_shatter
    sayc(["#{herald?(:meat_meat) ? 'You drive' : 'Meat Meat drives'} Dawnfang into the diamond. It bursts into snow.",
          "The Rime breaks at once. The first sunrise over Icewind Dale in two years.",
          "The Auroral Wall falls, and the two times meet. Rootspire and Ten-Towns share one sky.",
          cl(:alberica, "...Well. That's one way to end a party.")])
    say(["SEPHEK: Next solstice."]) if flag?(:sephek_turned)
    set_flag(:ending_shatter)
    epilogue
  end

  def ending_third_way
    al = herald?(:alberica)
    say(["#{al ? 'You pick' : 'Alberica picks'} the diamond up. It's very cold, and very small."])
    speak(:alberica, "You don't have to keep everything. Let it go, and it'll come back.",
          "...You can let go. It comes back.")
    say([as(:alberica, "Every year. That's what a season is."),
         "AURIL: (tiny) And it ends? Every year?",
         as(:alberica, "And it comes back. Every year."),
         "Frostina lowers her head to the diamond and hums Shimmer's four notes:",
         "the song of the first vessel, the one who refused her. Razzilith puts his nose beside hers.",
         "The light in the diamond flickers, then settles.",
         "It goes into Frostina like breath into a lung. Winter, the season. Not the cage.",
         "And Frostina, Shimmer's answer, carries it.",
         herald?(:alerion) ? "Behind your ribs, the second heartbeat goes cold and clean, like a winter morning." :
                             "Alerion puts a hand to his chest and, very slightly, smiles."])
    sayc([cl(:meat_meat, "Razzy gets spring. Meat Meat called it. Meat Meat called it ages ago."),
          "The Rime ends. The Wall falls.",
          "That autumn the leaves fall in Rootspire. That winter it snows, and then it stops.",
          "In spring, the Dale thaws.",
          "Frostina and Razzilith turn the wheel: one carries winter in, the other carries it away."])
    set_flag(:ending_third_way)
    wheel(1)
    epilogue
  end

  # Ending C: the loop. No credits. Back to the start, keeping your team.
  def ending_still_keeper
    al = herald?(:alberica)
    sayc([as(:alberica, "Somebody has to hold it. Reptin taught me that."),
          cl(:reptin, "That's not what I... Alberica. Alberica, don't."),
          "#{al ? 'You press' : 'She presses'} the diamond to #{al ? 'your' : 'her'} chest.",
          "Frost spreads, slowly, from the heart outward."])
    Stage.overlay("O-04", fps: 3, fade: 0)                          # frost in from the edges, to white
    sayc(["#{al ? 'You smile' : 'She smiles'} at each of them until #{al ? 'you' : 'she'} can't.",
          "For one breath the world is perfectly still. No wind. No snow falling. Nothing changing at all.",
          "Then the wheel, held still too long, snaps back."])
    pbSEPlay("Earth3") rescue nil
    Stage.overlay("O-06", fps: 5, fade: 0, above_panels: true, wait: true)   # the white cracks like a mirror
    sayc(["The throne room cracks like a mirror.",
          "Every shard shows a moment of your journey, running backwards.",
          as(:alberica, "(from inside the ice, very far away) Oh. ...Oh, no. It doesn't end."),
          as(:alberica, "It just stops. And then it starts again.")])
    set_flag(:ending_still_keeper)
    start_loop
  end

  # Flags that survive the loop; everything else is the story, and replays.
  LOOP_KEEP = %i[intro_done fell_through]

  def start_loop
    n = (counter(:loop_count) rescue 0).to_i + 1
    keep_counters = { wheel: counter(:wheel), story_beats: counter(:story_beats) } rescue {}
    flags = state[:flags] || {}
    flags.keys.each { |k| flags.delete(k) unless LOOP_KEEP.include?(k) }
    state[:flags] = flags
    state[:counters] ||= {}
    state[:counters][:loop_count] = n
    keep_counters.each { |k, v| state[:counters][k] = v if v }
    state[:companions] = []
    state[:goal] = nil
    state.delete(:auril_stage); state.delete(:seams); state.delete(:attendant_asked)
    STORY_SWITCHES.each { |i| $game_switches[i] = false } if $game_switches
    $game_self_switches.instance_variable_get(:@data)&.delete_if { |(m, _e, _c), _| m >= 2001 && m < 2100 } rescue nil
    set_flag(:in_loop)
    pbMessage(_INTL("(Loop {1}. You keep your team, your items and your Pokédex. The story starts again.)", n)) rescue nil
    if journey?
      flags.delete(:fell_through)
      transfer(*PROLOGUE_START)
    else
      transfer(*TARGOS_START)
    end
  end

  #-----------------------------------------------------------------------------
  # SC 14.01 - Epilogue; 14.02 - Time is a wheel
  #-----------------------------------------------------------------------------
  def epilogue
    pbBGMFade(2.0) rescue nil
    say(["A year later."])
    al = herald?(:alerion)
    lines = [["Hellen's wall. A new carving, cut right through the shadowy figure with the knife:",
              "a cat-man with a golden dagger, mid-stride, stepping out of it. THE DAGGER REBORN."]]
    if journey?
      lines << "And under the small sixth figure, freshly cut: your name."
      lines << "TAMSIN: Told you. Told you it was you." if flag?(:saw_sixth_figure)
    end
    if flag?(:ending_third_way)
      lines << [al ? "At the Shrine, Frostina sleeps with her head in your lap, humming in her sleep." :
                     "At the Shrine, Frostina sleeps with her head in Alerion's lap, humming in her sleep.",
                al ? "You hum back, off-key, the way Shade used to." : "Alerion hums back, off-key, the way Shade used to."]
    end
    if flag?(:phildendrin_found)
      lines << ["Razzilith lands in the market with Meat Meat and Phildendrin on his back.",
                "Phildendrin is screaming happily#{flag?(:council_phildendrin) ? ", in the Autumn councillor's sash" : ''}.",
                herald?(:meat_meat) ? "(Hold on with your KNEES, Mama!)" : "MEAT MEAT: Mama! Hold on with your KNEES!"]
    end
    if flag?(:anduin_reconciled)
      lines << ["Reptin and Anduin kneel together in the Heartroot, planting something.",
                herald?(:reptin) ? "(It'll be a tree. Eventually. Everything comes round, eventually.)" :
                                   "REPTIN: It'll be a tree. Eventually. Everything comes round, eventually."]
    end
    lines << ["Round the Shrine stump, under the old vow, two new names:",
              "the first Dragoons in four hundred years. Rheven had them cut deep."] if flag?(:dragoons_bound)
    lines << (al ? "You're teaching a Rootwarden class how to fall off a dragon properly." :
                   "Alerion is teaching a Rootwarden class how to fall off a dragon properly.")
    lines << (al ? "Somebody says something, and you laugh. Nobody has ever heard you laugh." :
                   "He laughs at something. Nobody has ever seen him laugh.") if flag?(:talion_released)
    lines << ["In the spore beds under the Heartroot, every mushroom has a name now.",
              "Sableye is asleep on #{herald?(:wyn) ? 'your' : "Wyn's"} boot."] if herald?(:wyn) || flag?(:wyn_joined)
    lines << "Back at the Underdark door, a sign: BACK SOON. ASK THE MUSHROOMS." if flag?(:godspark_shadow)
    lines << ["In Lonelywood, a man in a coat, for the first time, buys soup.",
              "He's given a cookie shaped like a halfling."] if flag?(:sephek_turned)
    lines << ["In the Wind-Glass Library, Alberica finds a crystal page in her own handwriting, very old.",
              "She reads it, laughs, and starts to write it."]
    if flag?(:ending_third_way) && (counter(:wheel) rescue 0).to_i >= 4
      lines << ["The next autumn's Festival of Returning Light.",
                "Every Herald and Tamsin#{flag?(:sephek_turned) ? ', and Sephek,' : ''} round one table at the Hearth.",
                "And one empty chair, with a carved wooden cat on it.",
                "Hellen pours. Nobody makes a speech.",
                "Frostina and Razzilith sleep on the roof and keep it warm."]
    end
    lines.each { |l| say(Array(l)) }
    say(["Many years later. The Cackling Chasm."])
    px, py = ([$game_player.x, $game_player.y] rescue [0, 0])
    old = Stage.actor(:green_ghost, px, py, 2, graphic: "FT_green_ghost")
    hid = old && !$game_player.transparent
    $game_player.transparent = true if hid
    say(["An old dwarf woman in green robes stands in the hall where a hag once laughed.",
         "She looks exactly like the ghost.",
         "OLD ALBERICA: Time is a wheel, dear. Somebody has to stand in the right place when it turns."])
    Stage.face(old, 8) if old
    say(["She looks up at the cave mouth.",
         "Five travellers and a stranger are about to come in out of the cold."])
    Stage.face(old, 2) if old
    say(["OLD ALBERICA: (smiling) Hello again.",
         "THE END"])
    Stage.cleanup rescue nil
    $game_player.transparent = false if hid
    set_flag(:game_complete)
    add_counter(:story_beats)
    state[:goal] = "The end. (Rootspire is yours to wander.)"
    transfer(2050, 31, 28, 2)
  end

  %i[cruelty endurance isolation preservation].each do |k|
    define_method(:"scene_test_#{k}") { send(:"test_#{k}", nil) }
    module_function :"scene_test_#{k}"
  end

  def apply_chapter13_switches
    return if !active? || !$game_switches
    $game_switches[SW_CROWN_OPEN] = tests_faced >= 4
    $game_switches[SW_FROSTINA_FREE] = flag?(:frostina_freed)
    $game_switches[SW_AURIL_DOWN] = flag?(:auril_down)
  end
end

# The Test of Endurance: only blows you can put your weight behind (physical moves) land.
if defined?(Battle::Move) || defined?(PokeBattle_Move)
  klass = defined?(PokeBattle_Move) ? PokeBattle_Move : Battle::Move
  klass.class_eval do
    next if !method_defined?(:pbCalcDamage)
    alias ft_endurance_pbCalcDamage pbCalcDamage unless method_defined?(:ft_endurance_pbCalcDamage)
    def pbCalcDamage(user, target, numTargets = 1)
      ft_endurance_pbCalcDamage(user, target, numTargets)
      target.damageState.calcDamage = 0 if $ft_physical_only && specialMove? rescue nil
    end
  end
end

# The Still Keeper starts at half health if Alberica sang the Canticle.
if Events.respond_to?(:onTrainerPartyLoad)
  Events.onTrainerPartyLoad += proc { |_sender, e|
    begin
      trainer = e.is_a?(Array) ? e[0] : e
      if $ft_keeper_halved && trainer && trainer.name == "Still Keeper"
        trainer.party.each { |pk| pk.hp = [pk.totalhp / 2, 1].max }
      end
    rescue StandardError => err
      FrostThaw.log("Still Keeper's canticle failed: #{err.message}")
    end
  }
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter13_switches
  rescue StandardError => err
    FrostThaw.log("Chapter 13 switches failed: #{err.message}")
  end
}
