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
  # Which of Auril's forms each test weakens, said the first time (context 13 M13-2)
  AURIL_FORM_NAMES = { cruelty: "Auril's first form, the Cold Crone", endurance: "Auril's second form, the Brittle Maiden",
                       isolation: "Auril's third form, Winter's Womb", preservation: "Auril's last form, the Rewritten Auril" }

  TRAINER_TYPES.merge!(
    FT_SHADE_KING: ["Shade of a King", :CHANNELER, 0, 200, :LEADER_Pryce],
    FT_STILL_KEEPER: ["The Still Keeper", :CHANNELER, 1, 220, :LEADER_Pryce],
    FT_FROST_SAINT: ["Frost Saint", :CHANNELER, 0, 220, :LEADER_Pryce]
  )
  TRAINERS.merge!(
    gunvald:      [:FT_SHADE_KING, "Gunvald", [[:URSARING, 61], [:B217H221, 62], [:B216H217, 62], [:B217H274, 63]],
                   "Compassion... feeds four mouths. Hm."],
    jarund:       [:FT_SHADE_KING, "Jarund", [[:STANTLER, 61], [:B234H274, 62], [:B274H234, 62], [:MAMOSWINE, 63]],
                   "You carried them. I left them. Which of us outlasted?"],
    tiger_queen:  [:FT_SHADE_KING, "The Tiger Queen", [[:B53H262, 62], [:B262H53, 63], [:B128H262, 63], [:B262H55, 64]],
                   "Then go back to them. Alone was only ever quiet."],
    still_keeper: [:FT_STILL_KEEPER, "Still Keeper", [[:B124H429, 63], [:FROSLASS, 64], [:B87H429, 64], [:B429H124, 65]],
                   "Memory's for remembering. ...I'd forgotten."],
    sephek_saint: [:FT_FROST_SAINT, "Sephek", [[:B87H262, 64], [:B144H215, 65], [:B274H87, 65], [:B215H429, 66]],
                   "She was never mine to take."]
  )
  TRAINER_INTROS.merge!(
    gunvald: "GUNVALD'S SHADE: Cut.", jarund: "JARUND'S SHADE: Outlast.", tiger_queen: "THE TIGER QUEEN'S SHADE: Stay.",
    still_keeper: "STILL KEEPER: Stay. Exactly like this.", sephek_saint: "SEPHEK: I held the knife."
  )

  # The Frostmaiden's forms (stand-ins until they have their own species)
  AURIL_CRONE  = :AURIL_CRONE # the Cold Crone: Ice/Dark (owl, wolf and goat)
  AURIL_MAIDEN = :B124H429    # the Brittle Maiden: a woman of ice (fragile to Fire)
  AURIL_WOMB   = :B131H428    # Winter's Womb: a floating diamond
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
         "SEPHEK: (his voice from everywhere) Her tenets. The Dale's old chiefs lived by them.",
         "SEPHEK: Their shades still keep the doors. Pass them, and she'll hear you.",
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
    return say(lines_for(:test_done), event_id) if flag?(:"test_#{key}_broken")
    if flag?(:"test_#{key}_faced")
      # Lost once: the tablet is still whole, and you may try again (review Ch13 E9).
      t = TESTS.find { |k, *| k == key }
      say(["The tablet #{t[2]} is still whole. The vision is waiting behind it."], event_id)
      return if !pbConfirmMessage(_INTL("Face the test again?"))
    end
    send(:"test_#{key}", event_id)
  end

  # A test's battle: you can lose it without blacking out (there's no Pokémon
  # Center on Solstice), and your team is healed after either way.
  def test_battle(key)
    data = TRAINERS[key] or return false
    trainer_intro(key) rescue nil
    won = pbTrainerBattle(data[0], data[1], nil, false, 0, true) ? true : false
    add_counter(:trainers_beaten) if won
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    won
  end

  # What the test's Herald says when the shade wins the fight but not the argument.
  TEST_LOSS_LINES = {
    cruelty:      "(wiping her nose) Meat Meat lost the fight. Not the food. The food counted.",
    endurance:    "(setting the last child down) They're out. That's the part that counted.",
    isolation:    "(not letting go) ...Lost. Not alone, though. That's new.",
    preservation: "(to the tablet) You're still standing. So am I. Call it a draw."
  }

  def finish_test(key, won)
    set_flag(:"test_#{key}_faced")
    set_flag(:"test_#{key}_broken") if won
    add_counter(:story_beats)
    t = TESTS.find { |k, *| k == key }
    if won
      say(["Somewhere in the hall, the tablet #{t[2]} cracks from top to bottom.",
           "(#{AURIL_FORM_NAMES[key]}, will be weaker.)"])
    else
      say(["The vision fades. The tablet #{t[2]} stays whole.",
           tl(t[1], TEST_LOSS_LINES[key]),
           "(While it stands, #{AURIL_FORM_NAMES[key]}, fights at full strength.)",
           "(You can face the test again.)"])
    end
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
         "A big man in a bearskin sharpens a knife: the shade of Gunvald, chief of the Bear Tribe.",
         "He's watching four old people huddled by a dead fire.",
         "GUNVALD'S SHADE: Four mouths, or the whole tribe. Old people eat what children need.",
         "GUNVALD'S SHADE: Cruelty is a knife. Cut.",
         "A blade of pure thought forms in #{mm ? 'your' : "Meat Meat's"} hand, on its own.",
         "AURIL: (a whisper) You were made to cut, little knife. Cut.",
         "AURIL: (a whisper) Or be a seed, and rot in the snow with them."], event_id)
    test_line(:meat_meat, "(letting the blade go out) Meat Meat was made a weapon. Meat Meat chose to be a seed.",
              "(letting the blade go out) ...No. Meat Meat says no.")
    say(["#{mm ? 'You open your pack' : 'She opens her pack'}. Hellen's food:",
         "bread, cheese, honey cakes from Good Mead.",
         "One by one, to the old people.",
         tl(:meat_meat, "Eat. Meat Meat is not hungry. ...Meat Meat is a little hungry. Eat anyway.")])
    Stage.overlay_off("O-03", fade: 16)
    finish_test(:cruelty, test_battle(:gunvald))
  end

  # SC 13.03 - The Test of Endurance (Reptin)
  def test_endurance(event_id = nil)
    rp = herald?(:reptin)
    Stage.overlay("O-03", fade: 20)
    say(["A line of people walks into a blizzard behind the shade of Jarund, chief of the Elk Tribe.",
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
    say(["(Only physical moves land in this blizzard.)"])
    Stage.overlay_off("O-03", fade: 16)
    $ft_physical_only = true
    won = test_battle(:jarund)
    $ft_physical_only = false
    finish_test(:endurance, won)
  end

  # SC 13.04 - The Test of Isolation (Alerion)
  def test_isolation(event_id = nil)
    al = herald?(:alerion)
    Stage.overlay("O-03", fade: 20)
    say(["#{al ? 'Your' : "Alerion's"} village, snowed under.",
         "A warm house with a fire in it, and a door that would lock behind #{al ? 'you' : 'him'}.",
         "By the fire sits a shade in striped furs: the Tiger Queen, who ruled her tribe alone.",
         "THE TIGER QUEEN'S SHADE: Solitude unlocks everything. Stay.",
         "THE TIGER QUEEN'S SHADE: Alone, nothing can be taken from you again.",
         tl(:alerion, "(a hand on the door) ...It would be quiet.")], event_id)
    if flag?(:talion_haunted) || flag?(:talion_chased)
      # "If he tries to control Talion... he may face a vengeful specter later" (Ch X, Quest 4)
      say(["The door swings open by itself. On the threshold stands a youth with mirror-glass for skin.",
           "TALION: (in a voice like ice cracking) You kept me. You KEPT me. Stay in the house, you said.",
           "TALION: Stay with me. Stay in the house. Forever."])
      boss_battle(named_mon(:B92H122, 63, "Talion's Echo"))
      say(["The echo cracks down the middle. Through the crack, for one breath, a boy's face, not angry any more.",
           "TALION: (very small) ...Go back to them. It's all right. Go back."])
      set_flag(:talion_laid)
    elsif flag?(:talion_restored)
      say(["A voice from the hall behind you, alive and annoyed: \"Alerion! You said you'd be back for supper!\"",
           "(Talion, at home in Rootspire, waiting. Somebody's waiting for you to come back.)"])
    else
      say([flag?(:talion_released) ? "A boy's voice from nowhere, warm this time: \"Go back to them. You came back for me.\"" :
                                     "Frostina's four notes, very faint, from somewhere above the fortress."])
    end
    if flag?(:dragoons_bound)
      say(["Behind #{al ? 'your' : 'his'} ribs, very faint and very far, a second heartbeat."])
    end
    test_line(:alerion, "(stepping back from the door) ...I need help. I've always needed help.",
              "(stepping back from the door) ...No. Not alone.")
    say([al ? "You hold out your hand, to whoever's there." : "He holds out his hand to you."])
    Stage.overlay_off("O-03", fade: 16)
    finish_test(:isolation, test_battle(:tiger_queen))
  end

  # SC 13.05 - The Test of Preservation (Alberica)
  def test_preservation(event_id = nil)
    al = herald?(:alberica)
    Stage.overlay("O-03", fade: 20)
    say(["A little boy in wolf furs, the last of his family, laughing in the snow."], event_id)
    # (Aerix: a Wolf Tribe boy whose tribe's song Alberica knows; owner's decision 5)
    say([al ? "(Aerix. Wolf Tribe. You sang at their fires once. You know how their song ends.)" :
              "ALBERICA: (very quiet) Aerix. Wolf Tribe. I sang at their fires once. I know how it ends.",
         "A madman's shadow moves toward him.",
         al ? "A figure steps out of the ice: you, older, made of frost." :
              "A figure steps out of the ice: Alberica, older, made of frost.",
         al ? "The rune glows white on its chest. You, if you never let anything go." :
              "The rune glows white on its chest. Alberica, if she never lets anything go.",
         "The Still Keeper."])
    if loop?
      say(["STILL KEEPER: You came back. They always come back. Stay this time."])
    else
      say(["STILL KEEPER: (Alberica's voice, gentle) You can keep him. Exactly like this. Laughing.",
           "STILL KEEPER: Forever. Nothing will ever hurt him. Isn't that what memory is for?"])
    end
    test_line(:alberica, "(very quiet) No. Memory's for remembering.", "(very quiet) ...No.")
    say([tl(:alberica, "He has to grow up, so there's something left to remember."),
         "STILL KEEPER: He'll suffer. He'll lose people. He'll die.",
         tl(:alberica, "Yes. And somebody will sing about it.")])
    if flag?(:canticle_learned)
      say(["#{herald?(:alberica) ? 'You sing' : 'Alberica sings'} the Cycle Canticle: three verses. Hope, loss, endurance.",
           "The frost on the reflection runs like water."])
      $ft_keeper_halved = true
    end
    Stage.overlay_off("O-03", fade: 16)
    won = test_battle(:still_keeper)
    $ft_keeper_halved = false
    finish_test(:preservation, won)
  end

  #-----------------------------------------------------------------------------
  # SC 13.06 - The roc's nest; 13.07 - The Frost Saint
  #-----------------------------------------------------------------------------
  # Eline came north with him (Ch11). If she's still free, she stands at his
  # shoulder from the moment you arrive, so her end at the Crown is someone you
  # saw (context 13 M13-1).
  def eline_actor
    return nil if flag?(:eline_captured) || flag?(:eline_fate)
    return nil if !flag?(:eline_spared) && !flag?(:eline_unbeaten)
    ev = stage_event("stage_eline")
    return ev if ev
    sev = stage_event("Sephek")
    x, y = sev ? [sev.x - 1, sev.y] : [$game_player.x - 1, $game_player.y - 3]
    Stage.actor(:eline, x, y, 2, graphic: "BW (40)")
  rescue StandardError
    nil
  end

  def scene_the_crown
    return if flag?(:crown_reached)
    set_flag(:crown_reached)
    eline = eline_actor
    sayc(["On the roof of the world, inside the prongs of an ice crown,",
          "a vast white roc stands over a nest.",
          "In the nest, a silver egg. Beside it, Frostina in her crystal, her eyes open.",
          eline && flag?(:eline_spared) ? "By the crystal stands Sephek. At his shoulder, Matron Eline, her hands empty." :
          eline ? "By the crystal stands Sephek. At his shoulder, Matron Eline, frost on her hands." :
                  "By the crystal stands Sephek.",
          cl(:alerion, "(very quietly) I'm here. I'm here.")])
    if eline && flag?(:eline_spared)
      Stage.turn_to(eline)
      say(["ELINE: (not moving) You let me go at the Shrine. I came here. I'm sorry."])
    end
    say(["Iskra mantles over the nest, wings out, beak open."])
  end

  def iskra(event_id = nil)
    return say(["Iskra watches you over her nest. She doesn't move."], event_id) if flag?(:iskra_passed)
    c = pbMessage(_INTL("Iskra mantles over the nest, wings out."), [_INTL("Hum Shimmer's four notes"), _INTL("Approach slowly"), _INTL("Fight")], 1)
    if c == 0 && flag?(:hummed_song)
      Stage.balloon($game_player, "B-05", frames: 50)
      Stage.wait(20)
      Stage.balloon(stage_event("Frostina's crystal"), "B-05", frames: 60)
      say(["You hum four notes. Inside the crystal, Frostina's eyes move. She hums them back.",
           "Iskra goes still. She listens. She folds her wings and steps aside."])
      set_flag(:iskra_calm)
    elsif c == 0 || c == 1
      say(["You go forward one step at a time.", "Iskra watches every step. She doesn't charge."])
    else
      return if !boss_battle(named_mon(:B18H144, 64, "Iskra"))
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

  def sephek_motive_lines
    return if flag?(:sephek_motives_crown)
    set_flag(:sephek_motives_crown)
    if with_or_is?(:meat_meat)
      say(["SEPHEK: (looking past you, at Meat Meat) Prototype Verdant. The engine's child. Your blood doesn't freeze.",
           "SEPHEK: One drop of it in her new heart, and winter would never thaw again. I'd have asked nicely. Once."])
    end
    if with_or_is?(:alerion)
      say(["SEPHEK: (to Alerion) And you. She speaks to two of us. Frost doesn't share.",
           as(:alerion, "Then stop listening.")])
    end
    if flag?(:took_cold_blessing)
      say(["SEPHEK: You took my blessing on the road, in the dream. You know what the cold is for. It keeps things."])
    end
  end

  def sephek_crown(event_id = nil)
    return if flag?(:sephek_turned) || flag?(:sephek_beaten)
    return say(["Iskra stands between you and the crystal."], event_id) if !flag?(:iskra_passed)
    eline_actor
    say(["SEPHEK: (standing between you and the crystal) I held the knife.",
         "SEPHEK: I held a lot of knives for her. Then four hundred years of ice.",
         "SEPHEK: The only thing I remembered was a woman laughing on an altar."], event_id)
    eline_at_the_crown(:before)                   # (unbeaten at the Shrine, she's his last follower)
    glaive_resonates                              # (Var's glaive knows him: rootspire.md 833)
    # rootspire.md Tab 1: he wants Meat Meat's altered blood, and Alerion is the rival he must break.
    sephek_motive_lines
    opts = []
    opts << [:rose, _INTL("Show him the Undying Rose")] if flag?(:rose_cutting)
    opts << [:shade, _INTL("Let Alerion speak")]
    opts << [:clean, _INTL("Tell him the heart is clean")] if flag?(:shard_purified)
    opts << [:fight, _INTL("Fight him")]
    c = pbMessage(_INTL("Sephek..."), opts.map(&:last), opts.size - 1)
    pick = opts[[c, 0].max][0]
    if pick == :rose
      say(["He takes it. It stays warm in his frozen hand.", "SEPHEK: ...She grew this. From that."])
    elsif pick == :shade
      speak(:alerion, "Shimmer told you there was a third way. You heard her.", "...Shimmer said there was a third way.")
      say([as(:alerion, "You've heard her laughing for four hundred years.")])
    elsif pick == :clean
      say(["You tell him what you did in the silver pool, under the dead engine. Green fire and gold. The light going out of it like breath.",
           "SEPHEK: (a hand flat on his chest, listening) ...There's no one in here but me.",
           "SEPHEK: Since the Forge. I've been choosing her all by myself since the Forge."])
    end
    # A heart broken into splinters and wired back together is too loud to hear
    # anyone through, unless it's the rose, which he grew from.
    if flag?(:shard_destroyed) && pick == :shade
      say(["The splinters in his chest grind against each other. He can't hear a word of it.",
           "SEPHEK: (hands over his ears) Too loud. She's too loud. Make it stop."])
      pick = :fight
    end
    if pick != :fight && flag?(:shade_curse_broken)
      say(["SEPHEK: (looking at Frostina) Her silence, not her return, honours her.",
           "SEPHEK: She died saying no to Auril. I won't make her say yes.",
           "He puts his hand on the crystal, and it melts.",
           "Frostina tumbles out and shakes herself like a dog."])
      frostina_heartbeat
      say(["Sephek puts his hand on his own chest."])
      sev = stage_event("Sephek")
      heart = sev ? Stage.fx("E-14", sev, oy: 36, loop_from: 0) : nil     # the heart, beating in his hand
      say([flag?(:shard_purified) ? "SEPHEK: And this. It was never hers. It's just been cold for a long time." :
                                    "SEPHEK: And this. She doesn't get this."])
      Stage.stop_fx(heart)
      $game_screen.start_flash(Color.new(180, 230, 255, 200), 10) rescue nil
      sayc([flag?(:shard_purified) ? "He presses both hands over the clean heart until it warms. He doesn't fall." :
            flag?(:shard_destroyed) ? "He pulls out the wired splinters and crushes them to powder. He doesn't fall." :
                                      "He pulls out the frost-light heart and crushes it. He doesn't fall.",
            "He only looks, for the first time, cold.",
            "SEPHEK: (shivering, almost laughing) Oh. So that's what it feels like.",
            cl(:alberica, "Welcome to being a person, sweetheart. It's awful. You'll love it.")])
      set_flag(:sephek_turned)
    else
      # The Major Avatar (rootspire.md Tab 4, 1.2): his followers, the
      # transformation, winter wolves and a coldlight walker; Divine
      # Rejuvenation while any of Auril's Heartroot relics stands.
      return if !sephek_major_fight
      say(["The crystal horror comes apart. What's left on the ice is a man, and he's shivering.",
           "SEPHEK: (beaten, breaking the crystal himself) ...She was never mine to take.",
           "Frostina tumbles out and shakes herself like a dog."])
      frostina_heartbeat
      set_flag(:sephek_beaten)
    end
    if !flag?(:sigil_sephek)                       # (if the Shrine never got its sigil out of him)
      say(["Something rings on the ice where he fell: a Frostshard Sigil, shaken out of the Frost Saint."])
      give(:FT_FROSTSIGIL)
      set_flag(:sigil_sephek)
    end
    sayc([cl(:meat_meat, "Frosty! Meat Meat missed you. Razzy missed you more. Razzy is very loud about it.")])
    eline_at_the_crown(:after)                    # (spared at the Shrine, she dies for him)
    set_flag(:frostina_freed)
    ($game_switches[SW_FROSTINA_FREE] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    state[:goal] = "The Throne of Frost."
  end

  #-----------------------------------------------------------------------------
  # SC 13.08 - The Frostmaiden; 13.09 - The Rewritten Auril
  #-----------------------------------------------------------------------------
  # One stage of the final fight: weaker if its test was broken; the twins breathe once each.
  def auril_stage(species, level, name, weakened, courtesy = false)
    mon = named_mon(species, level, name)
    frac = 1.0
    frac -= 0.35 if weakened
    frac -= 0.10 if courtesy          # (the Silent Chapel: "I'll remember you were polite")
    frac -= 0.15                      # Twin Breath: Razzilith and Frostina, one turn each
    mon.hp = [(mon.totalhp * frac).floor, 1].max
    boss_battle(mon)
  end

  def scene_throne
    return if flag?(:auril_down)
    if !flag?(:throne_entered)
      set_flag(:throne_entered)
      broken = TESTS.count { |k, *| flag?(:"test_#{k}_broken") }
      throne = stage_event("Auril")
      Stage.pan_to(throne.x, throne.y + 4) if throne       # her and you, both in view
      say(["A throne room with nothing in it but a throne. She needs nothing else.",
           "The woman in frost-furs is sitting on it.",
           broken >= 4 ? "AURIL: You broke my tests." :
           broken == 0 ? "AURIL: You failed every test. And still you climbed." :
                         "AURIL: You broke #{%w[no one two three][broken]} of my tests. The rest still stand."])
      if broken >= 4
        speak(:alberica, "We passed them, darling. Our way.", "We passed them. Our way.")
      elsif broken == 0
        speak(:alberica, "We're bad at tests, darling. Our way.", "...Our way, then.")
      else
        speak(:alberica, "So do we, darling. Our way.", "...So do we.")
      end
      sayc(["AURIL: There is no other way. There is cold, and what's left when it's done.",
            "AURIL: (standing) I loved the world. I loved it so much I couldn't bear for it to change.",
            "AURIL: You'd have done the same, if you'd seen what I've seen end.",
            cl(:reptin, "No. We'd have grieved. It's messier. It works."),
            cl(:alerion, "I tried it your way. It doesn't.")])
      auril_sees_you
      # Razzilith followed the griffons (12.02) and lands now; Frostina came in with you
      px, py = $game_player.x, $game_player.y
      razz = (Stage.actor(:razzilith, px - 2, py - 3, 2) rescue nil)
      frost = (Stage.actor(:frostina, px + 1, py, 8) rescue nil)
      Stage.walk_to(frost, px - 1, py - 3) if frost
      say(["Through the roof, Razzilith lands on the ice. Frostina goes to his side.",
           "They'll breathe for you, once each, every time she changes."])
    end
    stage = state[:auril_stage] || 0
    stages = [[AURIL_CRONE, 66, "The Cold Crone", :test_cruelty_broken],
              [AURIL_MAIDEN, 67, "The Brittle Maiden", :test_endurance_broken],
              [AURIL_WOMB, 68, "Winter's Womb", :test_isolation_broken]]
    while stage < stages.size
      sp, lv, nm, f = stages[stage]
      polite = stage == 0 && flag?(:chapel_auril)
      if polite && !flag?(:auril_courtesy_said)
        set_flag(:auril_courtesy_said)
        say(["AURIL: (to you, almost fond) You answered me politely once. In a little shrine, under the Forge.",
             "AURIL: I said I'd remember. I'll give you the first breath."])
      end
      Stage.pan_back if Stage.panned?
      return if !auril_stage(sp, lv, nm, flag?(f), polite)
      stage += 1
      state[:auril_stage] = stage
      say([["The crone's furs fall away. Under them is a woman made of ice, so thin the light goes through.",
            "The maiden shatters. The shards spin together into a floating diamond, humming.",
            "The diamond cracks."][stage - 1]])
    end
    scene_rewritten
  end

  # The owl feather's payoff (context 13 M13-4; owner's call 2026-11-05: Auril
  # couldn't see the outsider until the last-mirror choice, then marked them).
  # The walk-away, offered one last time in the villain's voice. Outsiders only.
  def auril_sees_you
    return if !outsider? || flag?(:auril_saw_you)
    set_flag(:auril_saw_you)
    auril = stage_event("Auril")
    Stage.turn_to(auril) if auril
    say([herald?(:wyn) ? "AURIL: (to you) And you. The tree's little warden. You came through a crack in my glass." :
                         "AURIL: (to you) And you. I couldn't see you at all, until the hag's last glass.",
         "AURIL: You chose, and I felt it. You don't turn on my wheel. You don't turn on theirs.",
         "AURIL: Go home, little stranger. This isn't your winter."])
    opts = [[:wall, _INTL("\"It's my Wall.\"")]]
    opts << [:feather, _INTL("(Hold up the owl feather.)")] if has_key?(:FT_OWLFEATHER)
    opts << [:no, _INTL("\"...No.\"")]
    c = pbMessage(_INTL("The Frostmaiden waits."), opts.map(&:last), opts.size - 1)
    case opts[[c, 0].max][0]
    when :wall
      set_flag(:auril_answered_wall)
      say(["AURIL: Your Wall. ...So you belong to something after all. How tiresome."])
    when :feather
      set_flag(:auril_answered_feather)
      say(["The rime on the feather runs to water in your hand.",
           "AURIL: (very quietly) ...So it does."])
    else
      set_flag(:auril_answered_no)
      say(["AURIL: (almost a smile) No. They all say it, in the end. A girl said it to me first."])
    end
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
          cl(:wyn, "...We all do. We're right here. Hold on.")])
    cline(:wyn, "(to the diamond, not loud) No. You'll stop.", "(to the diamond) ...You'll stop.")
    sayc([
          "In the middle of the room something forms: a woman made of all three.",
          "Shimmer's face for a moment. Then #{al ? 'yours' : "Alberica's"}. Then no one's."])
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
    avarice_at_the_throne          # what's left of Avarice comes for what's left of Auril
    set_flag(:auril_down)
    ($game_switches[SW_AURIL_DOWN] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    scene_what_do_we_do
  end

  #-----------------------------------------------------------------------------
  # SC 13.10 - What do we do with a god? and the endings
  #-----------------------------------------------------------------------------
  # The party argued this on the dock (12.md M12-6); the menu remembers which
  # side you took, and the pick that can't be undone is confirmed (context 13
  # M13-6; WRITING_GUIDE §6).
  def scene_what_do_we_do
    if flag?(:sephek_turned)
      Stage.actor(:sephek, $game_player.x + 1, $game_player.y + 1, 8) rescue nil
      say(["Sephek has followed you in. He stands at the back, shivering."])
    end
    say(["The Heralds stand round the tiny light on the floor. Nobody moves.",
         herald?(:meat_meat) ? "Dawnfang is in your hand. (One stab. No more winters. Ever.)" :
                               "MEAT MEAT: (Dawnfang in her hand) One stab. No more winters. Ever.",
         herald?(:meat_meat) ? "(...You'd miss snow a little.)" : "MEAT MEAT: ...Meat Meat would miss snow a little."])
    say(["SEPHEK: She'll come back. At the solstice. Gods with worshippers always do. Angrier."]) if flag?(:sephek_turned)
    sayc([cl(:reptin, "Or we hold her. Somebody could.")])
    speak(:alberica, "(very still) I could. I'm the one she wanted.", "(very still) ...I could.")
    cline(:reptin, "(too quickly) I didn't mean you.", "(too quickly) ...Not you.")
    say(["(Balance. Not a cage. You've broken enough things fixing them.)"]) if herald?(:reptin)
    speak(:alerion, "(looking at Frostina) Or. There was always a third way.", "(looking at Frostina) ...There's a third way.")
    cline(:wyn, "...Seasons. Like the spore beds. Things rest. Then they come back.", "...Seasons. Like the spore beds.")
    if (counter(:loop_count) rescue 0).to_i >= 2
      say([herald?(:alberica) ? "(You've done this before. Haven't you. ...Don't hold her.)" :
                                "ALBERICA: I've done this before. Haven't I. ...Don't let me hold her."])
    end
    # what you said on the dock, read back
    if flag?(:camp_view_end)
      sayc([herald?(:meat_meat) ? cl(:reptin, "(to you) On the dock you said end her, dear.") :
                                  cl(:meat_meat, "(to you) On the dock you said end her. Meat Meat remembers.")])
    elsif flag?(:camp_view_place)
      sayc([herald?(:wyn) ? cl(:alerion, "(to you) On the dock you said give it back its place.") :
                            cl(:wyn, "(to you) ...On the dock you said give it back its place.")])
    elsif flag?(:camp_view_unsure)
      sayc([herald?(:alberica) ? cl(:reptin, "(to you) You didn't know last night, dear. Know now.") :
                                 cl(:alberica, "(to you) You didn't know last night, sugar. Know now.")])
    end
    hold = herald?(:alberica) ? _INTL("\"Hold her myself.\"") : _INTL("\"Let Alberica hold her.\"")
    opts = [_INTL("\"End her.\""), _INTL("\"Give winter back its place.\""), hold]
    c = nil
    loop do
      c = pbMessage(_INTL("What do we do with a god?"), opts, -1)
      c = 1 if !c || c < 0
      sayc([herald?(:alerion) ? cl(:reptin, "Say it once more, dear. So we all know.") :
                                cl(:alerion, "Say it once more. So we all know.")])
      break if pbConfirmMessage(_INTL("{1} Is that your answer?", opts[c]))
    end
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
    their_time_payoff
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
          "The Rime, her endless winter, ends. The Auroral Wall falls.",
          "That autumn the leaves fall in Rootspire. That winter it snows, and then it stops.",
          "In spring, the Dale thaws.",
          "Frostina and Razzilith turn the wheel: one carries winter in, the other carries it away."])
    their_time_payoff
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
          # the restart has a rule you've heard: the Chasm ghost's, in Chapter 5 (context 13 M13-6)
          loop? ? nil : "From very far off, a voice in green: \"Go round again, dear. Find the third way.\"",
          "Then the wheel, held still too long, snaps back."])
    pbSEPlay("Earth3") rescue nil
    Stage.overlay("O-06", fps: 5, fade: 0, above_panels: true, wait: true)   # the white cracks like a mirror
    sayc(["The throne room cracks like a mirror.",
          "Every shard shows a moment of your journey, running backwards.",
          as(:alberica, "(from inside the ice, very far away) Oh. ...Oh, no. It doesn't end."),
          as(:alberica, "...I can hear the lottery drums.")])
    set_flag(:ending_still_keeper)
    start_loop
  end

  # Flags that survive the loop; everything else is the story, and replays.
  LOOP_KEEP = %i[intro_done fell_through]
  # Everything else in state is the story, and replays. These belong to the
  # player (the team, the bag and what's in it, the save), not the story.
  LOOP_KEEP_STATE = %i[flags counters companions goal loop_snap bargain_memory mode herald version active starter
                       bag_limit bank pip_upgrades pip_yes chwinga_charges grass_line_v2 locket_day]
  # Counters that are the player's, not the story's: the wheel, the beats and
  # the loops themselves, and how many trainers you've beaten.
  LOOP_KEEP_COUNTERS = %i[wheel story_beats loop_count trainers_beaten]

  def start_loop
    n = (counter(:loop_count) rescue 0).to_i + 1
    flags = state[:flags] || {}
    flags.keys.each { |k| flags.delete(k) unless LOOP_KEEP.include?(k) }
    state[:flags] = flags
    state[:counters] ||= {}
    state[:counters].keys.each { |k| state[:counters].delete(k) unless LOOP_KEEP_COUNTERS.include?(k) }   # omens, watchers... replay
    state[:counters][:loop_count] = n
    state[:companions] = []
    state[:goal] = nil
    state.keys.each { |k| state.delete(k) unless LOOP_KEEP_STATE.include?(k) }
    STORY_SWITCHES.each { |i| $game_switches[i] = false } if $game_switches
    # every Frost & Thaw map (2001 up: Act I, its side quests at 2100+, Rootspire and on)
    $game_self_switches.instance_variable_get(:@data)&.delete_if { |(m, _e, _c), _| m >= 2001 && m < 2400 } rescue nil
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
  # The montage plays at the Hearth, under Hellen's wall, where Tamsin can be
  # seen saying her lines; the coda in the Cackling Chasm; then Rootspire
  # (context 13 §5, notes E1). Old Alberica is the Chapter 5 ghost (owner's
  # decision 6): she comes back to keep the Order's post, and greets the
  # travellers who are about to meet her ghost.
  HEARTH_EPILOGUE = [2053, 5, 11, 8]
  CHASM_CODA = [2042, 16, 36, 8]

  def epilogue
    pbBGMFade(2.0) rescue nil
    pbFadeOutIn { Stage.jump(*HEARTH_EPILOGUE) } rescue nil
    say(["A year later."])
    al = herald?(:alerion)
    lines = [["Hellen's wall. A new carving, cut right through the shadowy figure with the knife:",
              "a cat-man with a golden dagger, mid-stride, stepping out of it: Glimmer, who was Shade.",
              "Under it: THE DAGGER REBORN."]]
    lines.each { |l| say(Array(l)) }
    if outsider?
      tam = (Stage.actor(:tamsin, $game_player.x + 1, $game_player.y, 4) rescue nil)
      say(["And under the small sixth figure, freshly cut: your name.",
           flag?(:told_tamsin) ? "TAMSIN: Told you, #{player_display_name}. Told you it was you." :
                                 "TAMSIN: You never said. I cut it anyway. It's my wall too."])
      if flag?(:beat_tamsin_final)
        say([herald?(:wyn) ? "TAMSIN: (sitting down, chin in hands) Right. Everything. In order. Start at the Sap Gate." :
                             "TAMSIN: (sitting down, chin in hands) Right. Everything. In order. Start at the lantern."])
      end
    end
    lines = []
    if flag?(:ending_third_way)
      lines << [al ? "At the Shrine, Frostina sleeps with her head in your lap, humming in her sleep." :
                     "At the Shrine, Frostina sleeps with her head in Alerion's lap, humming in her sleep.",
                al ? "You hum back, off-key, the way Shade used to." : "Alerion hums back, off-key, the way Shade used to."]
    end
    if flag?(:eline_captured)
      lines << ["Down in the root-cells, a woman in threadbare blue still prays every morning.",
                "Backwards, for most of the year. Some mornings now, the warden on duty says, she gets a line or two the right way round."]
    elsif flag?(:eline_martyred)
      lines << "On the Shrine steps, someone has carved a small figure in blue with her hands open. Nobody will say who. Sephek leaves snowdrops there."
    end
    if flag?(:phildendrin_found)
      lines << ["Razzilith lands in the market with Meat Meat and Phildendrin on his back.",
                "Phildendrin is screaming happily#{flag?(:council_phildendrin) ? ", in the Autumn councillor's sash" : ''}.",
                herald?(:meat_meat) ? "(Hold on with your KNEES, Mama!)" : "MEAT MEAT: Mama! Hold on with your KNEES!"]
    end
    if flag?(:council_heralds)
      lines << "In the Council Hall, Summer's chair has a Herald's cloak over the back of it, and a coffee ring on the arm."
    end
    if flag?(:reptin_warden_vow)
      lines << [herald?(:reptin) ? "Every winter you go back to the Cackling Chasm, as you swore. The wolves meet you at the bridge." :
                                   "Every winter Reptin goes back to the Cackling Chasm, as he swore. The wolves meet him at the bridge.",
                flag?(:chasm_watch_kept) ? "The grey wolf is greyer now." : nil].compact
    end
    if flag?(:anduin_reconciled)
      lines << [herald?(:reptin) ? "You and Anduin kneel together in the Heartroot, planting something." :
                                   "Reptin and Anduin kneel together in the Heartroot, planting something.",
                herald?(:reptin) ? "(It'll be a tree. Eventually. Everything comes round, eventually.)" :
                                   "REPTIN: It'll be a tree. Eventually. Everything comes round, eventually."]
    end
    lines << ["Round the Shrine stump, under the old vow, two new names:",
              "the first Dragoons in four hundred years. Rheven had them cut deep."] if flag?(:dragoons_bound)
    lines << (al ? "You're teaching a Rootwarden class how to fall off a dragon properly." :
                   "Alerion is teaching a Rootwarden class how to fall off a dragon properly.")
    if flag?(:talion_released)
      lines << (al ? "You laugh at something Alberica says. Nobody has ever heard you laugh." :
                herald?(:alberica) ? "Alerion laughs at something you say. Nobody has ever seen him laugh." :
                                     "He laughs at something Alberica says. Nobody has ever seen him laugh.")
    end
    lines << ["In the spore beds under the Heartroot, every mushroom has a name now.",
              "Sableye is asleep on #{herald?(:wyn) ? 'your' : "Wyn's"} boot."] if herald?(:wyn) || flag?(:wyn_joined)
    lines << "Back at the Underdark door, a sign: BACK SOON. ASK THE MUSHROOMS." if flag?(:godspark_shadow)
    lines << ["In Lonelywood, a man in a coat, for the first time, buys soup.",
              "He's given a cookie shaped like a halfling."] if flag?(:sephek_turned)
    # Keeper of Time (context 13 M13-9 boxes 1-3)
    lines << (herald?(:alberica) ?
              ["In the Wind-Glass Library, you find a crystal page in your own hand, very old.",
               "You read it, laugh, and start to write it.",
               "The Council gives you a new title: Keeper of Time. You make them spell it properly."] :
              ["In the Wind-Glass Library, Alberica finds a crystal page in her own hand, very old.",
               "She reads it, laughs, and starts to write it.",
               "The Council gives her a new title: Keeper of Time. She makes them spell it properly."])
    if flag?(:ending_third_way) && (counter(:wheel) rescue 0).to_i >= 4
      lines << ["The next autumn's Festival of Returning Light.",
                outsider? ? "All the Heralds, Tamsin#{flag?(:sephek_turned) ? ' and Sephek' : ''}, round one table at the Hearth, and you." :
                            "All of you, Tamsin#{flag?(:sephek_turned) ? ' and Sephek' : ''}, round one table at the Hearth.",
                "And one empty chair, with a carved wooden cat on it.",
                "Hellen pours. Nobody makes a speech.",
                "Frostina and Razzilith sleep on the roof and keep it warm."]
    end
    lines.each { |l| say(Array(l)) }
    # the coda: the ghost was her (owner's decision 6)
    pbFadeOutIn { Stage.jump(*CHASM_CODA) } rescue nil
    say(["Many years later. The Cackling Chasm."])
    px, py = ([$game_player.x, $game_player.y] rescue [0, 0])
    old = Stage.actor(:old_alberica, px, py, 2, graphic: "FT_green_ghost")
    hid = old && !$game_player.transparent
    $game_player.transparent = true if hid
    say(["An old dwarf woman in green robes stands in the hall where a hag once laughed.",
         "She looks exactly like the ghost.",
         "At her belt, a silver locket: half sun, half moon."])
    say(["(It's you. It was always going to be you.)"]) if herald?(:alberica)
    say(["OLD ALBERICA: Time's a wheel, dear. Somebody has to stand where it turns.",
         "OLD ALBERICA: The Order needs one last guardian down here. I've had worse jobs."])
    Stage.face(old, 8) if old
    say(["She looks up at the cave mouth.",
         "Five travellers and a stranger are about to come in out of the cold.",
         journey? ? "The stranger fell out of a lantern." :
         herald?(:wyn) ? "The stranger has a Sableye asleep on their boot." :
         herald?(:alberica) ? "One of the five is you. Louder. Younger." : "One of the five is you."])
    Stage.face(old, 2) if old
    say(["OLD ALBERICA: (smiling) Hello again.",
         "THE END"])
    Stage.cleanup rescue nil
    $game_player.transparent = false if hid
    set_flag(:game_complete)
    add_counter(:story_beats)
    state[:goal] = "The end. (Rootspire is yours to wander.)"
    pbFadeOutIn { Stage.jump(2050, 31, 28, 2) } rescue (transfer(2050, 31, 28, 2) rescue nil)
    postgame_vault_hook
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

module FrostThaw
  module_function

  # Postgame: the White Vault (owner's call, 2026-11-05). After the credits, the
  # three Frostshard Sigils wake; until you hold all three, a side line says where
  # the missing ones are.
  def postgame_vault_hook
    return if !flag?(:game_complete) || flag?(:avarice_body_broken)
    try_merge_sigils if sigils_held >= 3
    if flag?(:sigils_merged)
      side_goal(:vault, VAULT_GOAL, done: :avarice_body_broken)
    else
      side_goal(:vault, "Postgame: three Frostshard Sigils wake a door in the north. Eirwen keeps one; the Echo Gate's wraiths and Sephek the others.",
                done: %i[sigils_merged avarice_body_broken])
    end
  end
end

module FrostThaw
  module_function

  # The player's second goal, paid (owner's call, 2026-11-05): the Wall comes
  # down. Every mode (context 13 M13-7): for a Herald the Wall stood between
  # their own Dale and the city that told their stories; for Wyn, between their
  # post and the Dale they fell into. Reads back what you told Auril.
  def their_time_payoff
    return if journey? && !flag?(:their_time_known)
    say(["Where the Auroral Wall stood, there's a line of melting frost across the snow.",
         journey? ? "On one side, your city. On the other, their Dale. One morning, for both." :
         herald?(:wyn) ? "On one side, your post at the Sap Gate. On the other, the Dale you fell into." :
                         "On one side, the city that told your stories. On the other, your Dale. One morning."])
    if journey?
      if flag?(:promised_their_time)
        sayc([cl(:reptin, "(to you) You said you'd get us home, dear. You brought home to us. I'll allow it.")])
      else
        sayc([cl(:alberica, "(to you) You said sorry. This is better.")])
      end
    else
      say([{ reptin: "(Out there, Anduin's had weeks. You've had four hundred years. Now it's one morning.)",
             alerion: "(Your village is out there under the snow. You can visit. You don't have to stay.)",
             meat_meat: "(Mama's Dale and Razzy's tree. Same morning. Meat Meat needs two coffees.)",
             alberica: "(Out there, a village that never drew a name. Somebody should go and ask why.)",
             wyn: "(Sableye's going to want to see the snow. ...So am I.)" }[herald] || nil].compact)
    end
    if flag?(:auril_answered_wall)
      say(["You told her it was your Wall. Now it's water."])
    elsif flag?(:auril_answered_feather)
      say(["In your pack, the owl feather is only a feather now."])
    elsif flag?(:auril_answered_no)
      say(["You told her no. She was right: in the end, everyone did."])
    end
  end
end
