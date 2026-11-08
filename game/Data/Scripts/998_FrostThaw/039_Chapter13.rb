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
  SW_HALL_SPRING   = 4185   # Eirwen's servants' stair: a warm spring in the Hall

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
    FT_SHADE_KING: ["Chief's Shade", :CHANNELER, 0, 200, :LEADER_Pryce],    # "Chief's Shade Gunvald" (notes 13 E21)
    FT_STILL_KEEPER: ["Reflection", :CHANNELER, 1, 220, :LEADER_Pryce],
    FT_FROST_SAINT: ["Frost Saint", :CHANNELER, 0, 220, :LEADER_Pryce]
  )
  TRAINERS.merge!(
    gunvald:      [:FT_SHADE_KING, "Gunvald", [[:URSARING, 61], [:B217H221, 62], [:B216H217, 62], [:B217H274, 63]],
                   "Compassion... feeds four mouths. Hm."],
    jarund:       [:FT_SHADE_KING, "Jarund", [[:STANTLER, 61], [:B234H274, 62], [:B274H234, 62], [:MAMOSWINE, 63]],
                   "You carried them. I left them. Which of us outlasted?"],
    tiger_queen:  [:FT_SHADE_KING, "the Tiger Queen", [[:B53H262, 62], [:B262H53, 63], [:B128H262, 63], [:B262H55, 64]],
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
    hall_spring: ["Warm water wells up where the servants' stair comes out, just as Eirwen's plans said.",
                  "Your team drinks. Everyone is rested."],
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
  # Sopo on the climb (notes 12 E14): the dock's after-line, then he runs for it.
  def sopo_on_the_climb(event_id = nil)
    ev = stage_event(event_id)
    Stage.emote(ev, :exclaim) if ev
    say(lines_for(:sopo_after), event_id)
    Stage.leave(ev, ev.x + 6, ev.y) if ev
    set_self_switch(event_id, "A")
  end

  # Purpose: the rules of the climb. Sephek (a voice through the ice) sets
  # Auril's four tests; Alberica asks the question the ending will answer
  # ("what if we pass them ours?"), and Sephek has never heard it before.
  def scene_hall_four_winds
    return if flag?(:hall_entered)
    loop_snapshot(:act3) if respond_to?(:loop_snapshot)    # (the Still Keeper's loop can skip to here)
    set_flag(:hall_entered)
    say(["A round hall with four doors, and four tablets of ice.",
         "Each is carved with one word. CRUELTY. ENDURANCE. ISOLATION. PRESERVATION.",
         # (a voice through the ice, from everywhere: Sephek is up at the Crown)
         "SEPHEK: (his voice from everywhere) Her tenets. The Dale's old chiefs lived by them.",
         "SEPHEK: Their shades still keep the doors. Pass them, and she'll hear you.",
         "SEPHEK: Fail, and you'll stay here. And be beautiful."])
    speak(:alberica, "And if we don't want to pass them her way?", "...What if we pass them ours?")
    sayc(["SEPHEK: (after a long pause, almost curious) ...No one has ever asked that.",
          cl(:meat_meat, "Meat Meat will pass the tests. Then Meat Meat will bite the tests."),
          cl(:alerion, "That's not how tests work."),
          (with_or_is?(:alerion) ? cl(:meat_meat, "It is now.") : nil)])
    # Wyn has no test; they get the Hall (notes 13 E23)
    cline(:wyn, "(counting the doors) Four doors. Five of us. ...I'll mind the coats.", "(counting the doors) ...Four doors.")
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

  # A door of the Hall (notes 13 §2: every door is seen and carved). Its vision
  # waits behind it; a test you lost can be faced again (E9).
  def test_door(key, event_id = nil)
    t = TESTS.find { |k, *| k == key } or return
    if flag?(:"test_#{key}_broken")
      return say(["The door of #{t[2]}. Behind it the vision has gone, and its tablet is cracked."], event_id)
    end
    if flag?(:"test_#{key}_faced")
      say(["The door of #{t[2]}. Its tablet is still whole. The vision is waiting behind it."], event_id)
      return if !pbConfirmMessage(_INTL("Face the test again?"))
      id = state[:"test_#{key}_event"]
      set_self_switch(id, "A", false, MAPS[:"test_#{key}"]) if id          # the vision plays again
    elsif !flag?(:"test_#{key}_door_seen")
      set_flag(:"test_#{key}_door_seen")
      say(["A door of ice, carved #{t[2]}."], event_id)
    end
    transfer(MAPS[:"test_#{key}"], 9, 10, 8)
  end

  # Eirwen's servants' stair comes out by a warm spring in the Hall (notes 13
  # E13; Nass's and Ukuma's rewards are given at the jaw, 038).
  def hall_shortcut(kind, event_id = nil)
    case kind
    when :spring
      say(lines_for(:hall_spring), event_id)
      pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    end
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
  TEST_SHADES = { cruelty: "Gunvald's Shade", endurance: "Jarund's Shade", isolation: "The Tiger Queen's Shade",
                  preservation: "Still Keeper" }

  def finish_test(key, won)
    set_flag(:"test_#{key}_faced")
    set_flag(:"test_#{key}_broken") if won
    add_counter(:story_beats)
    t = TESTS.find { |k, *| k == key }
    if won
      shade = stage_event(TEST_SHADES[key])
      if shade
        $game_screen.start_flash(Color.new(220, 240, 255, 180), 12) rescue nil
        set_self_switch(shade.id, "A")                     # the shade goes with its vision
      end
      say(["Somewhere in the hall, the tablet #{t[2]} cracks from top to bottom.",
           "(#{AURIL_FORM_NAMES[key]}, will be weaker.)"])
    else
      say(["The vision fades. The tablet #{t[2]} stays whole.",
           tl(t[1], TEST_LOSS_LINES[key]),
           "(While it stands, #{AURIL_FORM_NAMES[key]}, fights at full strength.)",
           "(You can face the test again: its door in the Hall is still open.)"])
      # (the Hall's door clears the vision's switch when you go back in: not
      # here, or it would start again before you've left)
      ev = $game_map.events.values.find { |e| e.name == "Test #{key}" } rescue nil
      state[:"test_#{key}_event"] = ev.id if ev
    end
    Stage.cleanup rescue nil
    if tests_faced >= 4
      ($game_switches[SW_CROWN_OPEN] = true; $game_map.need_refresh = true if $game_map) if $game_switches
      state[:goal] = "Up the stair of ice, to the Crown."
    end
    transfer(*HALL_ARRIVAL)
  end

  # The test's Herald, beside you: their stand-in (or you, if you are them).
  def test_herald(key)
    return $game_player if herald?(key)
    return nil if !companions.include?(key)
    Stage.summon(key)
  end

  # SC 13.02 - The Test of Cruelty (Meat Meat)
  # Purpose: Auril offers Meat Meat the knife she was made to be; she feeds the
  # old people instead. Decisive beat: the battle, after her refusal.
  def test_cruelty(event_id = nil)
    mm = herald?(:meat_meat)
    Stage.overlay("O-03", fade: 20)                  # the tests are visions
    # four old people by a dead fire, under the chief's eye
    olds = [[7, 7, "BWOldMan"], [8, 7, "BWOldWoman"], [10, 7, "BWOldWoman"], [11, 7, "BWOldMan"]].map do |x, y, g|
      Stage.actor(:old_one, x, y, 8, graphic: g)
    end
    say(["A camp of hide tents in a blizzard. Starving people.",
         "A big man in a bearskin sharpens a knife: the shade of Gunvald, chief of the Bear Tribe.",
         "He's watching four old people huddled by a dead fire.",
         "GUNVALD'S SHADE: Four mouths, or the whole tribe. Old people eat what children need.",
         "GUNVALD'S SHADE: Cruelty is a knife. Cut.",
         "A blade of pure thought forms in #{mm ? 'your' : "Meat Meat's"} hand, on its own.",
         # (Auril in her head: a voice, no body)
         "AURIL: (a whisper) You were made to cut, V-7. Cut.",
         "AURIL: (a whisper) Or be a seed, and rot in the snow with them."], event_id)
    test_line(:meat_meat, "(the blade goes out) Meat Meat was made a weapon. Meat Meat chose to be a seed.",
              "(letting the blade go out) ...No. Meat Meat says no.")
    giver = test_herald(:meat_meat)
    Stage.walk_to(giver, 9, 8, face: 8) if giver && giver != $game_player
    olds.compact.each { |o| Stage.turn_to(o, giver || $game_player) }
    say(["#{mm ? 'You open your pack' : 'She opens her pack'}. Hellen's food:",
         "bread, cheese, honey cakes from Good Mead.",
         "One by one, to the old people.",
         tl(:meat_meat, "Eat. Meat Meat is not hungry. ...Meat Meat is a little hungry. Eat anyway.")])
    Stage.overlay_off("O-03", fade: 16)
    finish_test(:cruelty, test_battle(:gunvald))
  end

  # SC 13.03 - The Test of Endurance (Reptin)
  # Purpose: the shade leaves the fallen behind; Reptin carries them, and the
  # pack he fed in Chapter 4 (if he did) walks them out. Decisive beat: the battle.
  def test_endurance(event_id = nil)
    rp = herald?(:reptin)
    Stage.overlay("O-03", fade: 20)
    line = [[8, 6, "BWMan1"], [9, 6, "BWWoman1"], [10, 6, "BWHiker"]].map { |x, y, g| Stage.actor(:walker, x, y, 8, graphic: g) }
    child = Stage.actor(:child, 9, 8, 2, graphic: "BWBoy")
    say(["A line of people walks into a blizzard behind the shade of Jarund, chief of the Elk Tribe.",
         "A child falls and doesn't get up. The line keeps walking."], event_id)
    Stage.leave_all(line, 9, 3)
    say(["JARUND'S SHADE: Outlast. By any means. Those who fall, fall."])
    carrier = test_herald(:reptin)
    Stage.walk_to(carrier, 9, 9, face: 8) if carrier && carrier != $game_player
    say([rp ? "(Your medallion, quiet since Dougan's Hole, fogs once and clears.)" :
              "Reptin's medallion, quiet since Dougan's Hole, fogs once and clears."]) if with_or_is?(:reptin)   # (whole read T25)
    say(["#{rp ? 'You pick' : 'Reptin picks'} the child up. Then the next one who falls.",
         "Slower. The line pulls away."])
    Stage.remove_actor(child) if child
    test_line(:reptin, "(through gritted teeth) Somebody has to hold them. Fine. It's me.",
              "(to the children) Behind me. Now.")
    if flag?(:fed_pack)
      wolves = [[5, 9], [13, 9]].map { |x, y| Stage.actor(:wolf, x, y, x < 9 ? 6 : 4, graphic: "Followers/MIGHTYENA") }
      wolves.compact.each { |w| Stage.walk_to(w, w.x < 9 ? 8 : 10, 9, wait_for: false) }
      Stage.wait(24)
      say(["Grey shapes run out of the snow on either side: wolves, thin and silent.",
           "They walk with the children between them, out of the storm."])
    else
      wolf = Stage.herald(:reptin, 1, 0, 2)
      Stage.pose(wolf, "P-REP-04", 0, frames: [0, 1, 2], per: 10) if wolf   # elf, half wolf, wolf
      say([rp ? "Your wolf comes out on its own. Slower, on four legs, you carry the children on your back." :
                "His wolf comes out on its own. Slower, on four legs, he carries the children on his back."])
      Stage.pose(wolf, "P-REP-04", 0, frames: [3], per: 20) if wolf          # an elf again, on his knees
    end
    say(["(Only physical moves land in this blizzard.)"])
    Stage.overlay_off("O-03", fade: 16)
    $ft_physical_only = true
    won = test_battle(:jarund)
    $ft_physical_only = false
    finish_test(:endurance, won)
  end

  # SC 13.04 - The Test of Isolation (Alerion)
  # Purpose: a warm house where nothing can be taken from him again; Alerion
  # steps back from the door and asks for help. Decisive beat: his hand, then the battle.
  def test_isolation(event_id = nil)
    al = herald?(:alerion)
    Stage.overlay("O-03", fade: 20)
    say(["#{al ? 'Your' : "Alerion's"} village, snowed under.",
         "A warm house with a fire in it, and a door that would lock behind #{al ? 'you' : 'him'}.",
         "By the fire sits a shade in striped furs: the Tiger Queen, who ruled her tribe alone.",
         "THE TIGER QUEEN'S SHADE: Solitude unlocks everything. Stay.",
         "THE TIGER QUEEN'S SHADE: Alone, nothing can be taken from you again."], event_id)
    him = test_herald(:alerion)
    Stage.walk_to(him, 9, 7, face: 8) if him && him != $game_player     # toward the house
    say([tl(:alerion, "(a hand on the door) ...It would be quiet.")])
    if flag?(:talion_haunted) || flag?(:talion_chased)
      # "If he tries to control Talion... he may face a vengeful specter later" (Ch X, Quest 4)
      tal = Stage.actor(:talion, 9, 5, 2, graphic: "FT_talion")
      say(["The door swings open. On the threshold stands a youth with mirror-glass for skin.",
           "TALION: (like ice cracking) You kept me. You KEPT me. Stay in the house, you said.",
           "TALION: Stay with me. Stay in the house. Forever."])
      boss_battle(named_mon(:B92H122, 63, "Talion's Echo"))
      say(["The echo cracks down the middle.",
           "Through the crack, for one breath, a boy's face, not angry any more.",
           "TALION: (very small) ...Go back to them. It's all right. Go back."])
      Stage.remove_actor(tal) if tal
      set_flag(:talion_laid)
    elsif flag?(:talion_restored)
      say(["A voice behind you, alive and cross: \"Alerion! You said you'd be back for supper!\"",
           "(Talion, at home in Rootspire, waiting. Somebody's waiting for you to come back.)"])
    else
      say([flag?(:talion_released) ? "A boy's voice from nowhere, warm this time: \"Go back to them. You came back for me.\"" :
                                     "Frostina's four notes, very faint, from somewhere above the fortress."])
    end
    if flag?(:dragoons_bound)
      say(["Behind #{al ? 'your' : 'his'} ribs, very faint and very far, a second heartbeat."])
    end
    Stage.walk_to(him, 9, 9, face: 2) if him && him != $game_player       # back, to you
    test_line(:alerion, "(stepping back from the door) ...I need help.",
              "(stepping back from the door) ...No. Not alone.")
    # (the decisive beat is yours: his hand, or yours held out)
    pbMessage(_INTL(al ? "You hold out your hand, to whoever's there." : "He holds out his hand to you."),
              [_INTL("(Take it.)")], 0)
    say([al ? "A hand closes round yours. Warm." : "You take it. His hand is very cold, and it holds on."])
    Stage.overlay_off("O-03", fade: 16)
    finish_test(:isolation, test_battle(:tiger_queen))
  end

  # SC 13.05 - The Test of Preservation (Alberica)
  # Purpose: her own frost reflection offers to keep a boy she knows the end of
  # forever; she chooses a song over a statue. It is Ending C, shown early.
  def test_preservation(event_id = nil)
    al = herald?(:alberica)
    Stage.overlay("O-03", fade: 20)
    boy = Stage.actor(:aerix, 9, 7, 2, graphic: "BWBoy")
    Stage.hop(boy, 2) if boy
    say(["A little boy in wolf furs, the last of his family, laughing in the snow."], event_id)
    # (Aerix: a Wolf Tribe boy whose tribe's song Alberica knows; owner's decision 5)
    say([al ? "(Aerix. Wolf Tribe. You sang at their fires once. You know how their song ends.)" :
              "ALBERICA: (very quiet) Aerix. Wolf Tribe. I sang at their fires once. I know how it ends."])
    mad = Stage.actor(:madman, 4, 7, 6, graphic: "BW (40)")
    Stage.walk_to(mad, 6, 7, face: 6) if mad
    say(["A madman's shadow moves toward him."])
    keeper = stage_event("Still Keeper")
    Stage.walk_to(keeper, 9, 6, face: 2) if keeper
    say([al ? "A figure steps out of the ice: you, older, made of frost." :
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
    else
      # the golden-path song (story review 13): Shimmer's four notes, from Chapter 3
      say(["#{al ? 'You hum' : 'Alberica hums'} four notes: Shimmer's song. The boy laughs at the tune."])
    end
    Stage.leave(mad, 2, 7) if mad
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
    Stage.actor(:eline, x, y, 2, graphic: "FT_matron_eline")
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
    iskra_ev = stage_event("Iskra")
    Stage.emote(iskra_ev, :angry) if iskra_ev
    c = pbMessage(_INTL("Iskra won't move from her nest."), [_INTL("Hum Shimmer's four notes"), _INTL("Approach slowly"), _INTL("Fight")], 1)
    # the four notes have been heard all game; any of these taught them well enough (whole read T27)
    if c == 0 && (flag?(:hummed_song) || flag?(:luna_spark) || flag?(:frostina_sang_north) || flag?(:glimmer_joined))
      Stage.balloon($game_player, "B-05", frames: 50)
      Stage.wait(20)
      Stage.balloon(stage_event("Frostina's crystal"), "B-05", frames: 60)
      say(["You hum four notes. Inside the crystal, Frostina's eyes move. She hums them back.",
           "Iskra goes still. She listens. She folds her wings and steps aside."])
      set_flag(:iskra_calm)
    elsif c == 0
      # (notes 13 E16: without the song from Chapter 9 the hum is yours, and half known)
      say(["You hum the four notes. Iskra's head tilts. Frostina, inside the ice, can't hear you.",
           "You go forward one step at a time.", "Iskra watches every step. She doesn't charge."])
    elsif c == 1
      say(["You go forward one step at a time.", "Iskra watches every step. She doesn't charge."])
    else
      return if !boss_battle(named_mon(:B18H144, 64, "Iskra"))
      say(["Iskra stumbles back over her nest and stays there, guarding the egg.", "She lets you pass."])
    end
    set_flag(:iskra_passed)
    say(["The silver egg stays in the nest, warm under Iskra's wing."]) if flag?(:iskra_calm)
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
      # (Chapter 11 said why; here it's one box: dialogue 13 §4)
      say([(herald?(:meat_meat) ? "SEPHEK: (to you) " : "SEPHEK: (to Meat Meat) ") + "A drop of your blood and winter never thaws. I'd have asked nicely."])
    end
    if with_or_is?(:alerion)
      say([(herald?(:alerion) ? "SEPHEK: (to you) " : "SEPHEK: (to Alerion) ") + "And you. She's quieter in me since the Shrine. Louder in you.",
           as(:alerion, "Then stop listening.")])
    end
    if flag?(:took_cold_blessing)
      say(["SEPHEK: You took my blessing on the road, in the dream. You know what the cold is for.",
           "SEPHEK: It keeps things."])
    end
  end

  def sephek_crown(event_id = nil)
    return if flag?(:sephek_turned) || flag?(:sephek_beaten)
    return say(["Iskra stands between you and the crystal."], event_id) if !flag?(:iskra_passed)
    eline_actor
    say(["SEPHEK: (standing between you and the crystal) I held the knife.",
         "SEPHEK: I held a lot of knives for her. Then four hundred years of ice.",
         "SEPHEK: The only thing I remembered was a woman on an altar, saying no."], event_id)
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
      say(["You tell him what you did in the silver pool, under the dead engine.",
           "Green fire and gold. The light going out of it like breath.",
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
      say(["Something rings on the ice where he fell: a Frostshard Sigil, shaken out of him."])
      give(:FT_FROSTSIGIL)
      set_flag(:sigil_sephek)
    end
    frostina = Stage.actor(:frostina, 12, 5, 2) rescue nil       # out of the crystal, on the ice
    Stage.hop(frostina) if frostina
    sayc([cl(:meat_meat, "Frosty! Meat Meat missed you. Razzy missed you more. Razzy is LOUD about it.")])
    eline_dies = flag?(:eline_spared) && !flag?(:eline_captured) && !flag?(:eline_fate)
    el = eline_dies ? eline_actor : nil
    if el
      # the last wave, out from under the throne-room door (13,2): she walks into it (notes 13 E4)
      $game_screen.start_flash(Color.new(230, 245, 255, 255), 16) rescue nil
      pbSEPlay("Ice8") rescue nil
      Stage.walk_to(el, el.x, el.y - 1, face: 8)
      el.instance_variable_set(:@tone, Tone.new(60, 60, 90, 255)) rescue nil
      el.instance_variable_set(:@opacity, 200) rescue nil
      Stage.balloon(stage_event("Sephek"), "B-07") rescue nil
    end
    eline_at_the_crown(:after)                    # (spared at the Shrine, she dies for him)
    # (Alberica's "Somebody should sit with her" plays once, inside eline_at_the_crown: whole read V17/T14)
    set_flag(:frostina_freed)
    ($game_switches[SW_FROSTINA_FREE] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    state[:goal] = "The Throne of Frost."
  end

  #-----------------------------------------------------------------------------
  # SC 13.08 - The Frostmaiden; 13.09 - The Rewritten Auril
  #-----------------------------------------------------------------------------
  # One stage of the final fight: weaker if its test was broken; the twins breathe once each.
  FINAL_FORM_BGM = "cynthia_battle"     # Auril's three forms (notes 13 E15: not the wild-battle theme)
  FINAL_BOSS_BGM = "dpp_legend"         # the Rewritten Auril
  def auril_stage(species, level, name, weakened, courtesy = false)
    mon = named_mon(species, level, name)
    frac = 1.0
    frac -= 0.35 if weakened
    frac -= 0.10 if courtesy          # (the Silent Chapel: "I'll remember you were polite")
    frac -= 0.15                      # Twin Breath: Razzilith and Frostina, one turn each
    mon.hp = [(mon.totalhp * frac).floor, 1].max
    boss_battle(mon, bgm: FINAL_FORM_BGM)
  end

  # How Auril looks on the throne-room floor at each stage of the fight
  # (notes 13 E3: the map changes with her). Stand-ins: the furs, the same thin
  # as ice, a crystal for the floating diamond.
  def auril_look(stage, ev = stage_event("Auril"))
    return if !ev
    g, o = [["FT_auril_furs", 255], ["FT_auril_furs", 120], ["Followers/CRYOGONAL", 230], ["FT_auril_furs", 200]][[stage, 3].min]
    ev.instance_variable_set(:@character_name, g)
    ev.instance_variable_set(:@opacity, o)
    ev.moveto(9, 6) if stage > 0 && ev.y < 6
  rescue StandardError => e
    log("auril_look: #{e.message}")
  end

  # Purpose: the god at last, in person. She makes her case; the Heralds answer
  # it; she sees the one who isn't on her wheel. Then four forms, each weaker
  # for the test that was broken.
  def scene_throne
    if flag?(:auril_down)
      # (owner, 2026-11-07: an autosave before the god choice. Loading it re-runs this
      # cutscene's script, so it comes back here and asks the question again.)
      return if ending_chosen?
      return scene_what_do_we_do
    end
    throne = stage_event("Auril")
    if !flag?(:throne_entered)
      set_flag(:throne_entered)
      broken = TESTS.count { |k, *| flag?(:"test_#{k}_broken") }
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
      say(["AURIL: There is no other way. There is cold, and what's left when it's done."])
      Stage.walk_to(throne, 9, 6, face: 2) if throne                  # (standing, and coming down to you)
      sayc(["AURIL: (standing) I watched every summer in this Dale rot by autumn. So I stopped the rot.",
            "AURIL: You'd have done the same, if you'd seen what I've seen end.",
            cl(:reptin, "No. We'd have grieved. It's messier. It works."),
            cl(:alerion, "I tried it your way. It doesn't.")])
      cline(:wyn, "(quietly) Spore beds rot too. Then the next ones grow in them.", "(quietly) ...Rot feeds things.")
      auril_sees_you
      # Razzilith followed the griffons (12.02) and lands now; Frostina came in with you
      px, py = $game_player.x, $game_player.y
      $game_screen.start_shake(4, 8, 12) rescue nil
      pbSEPlay("Earth3") rescue nil
      razz = (Stage.actor(:razzilith, px - 2, py - 3, 2) rescue nil)
      frost = (Stage.actor(:frostina, px + 1, py, 8) rescue nil)
      Stage.walk_to(frost, px - 1, py - 3) if frost
      say(["Through the roof, Razzilith lands on the ice. Frostina goes to his side.",
           "Before each of her forms, they'll breathe on her once. It will hurt."])
    end
    stage = state[:auril_stage] || 0
    auril_look(stage, throne)
    stages = [[AURIL_CRONE, 66, "The Cold Crone", :test_cruelty_broken],
              [AURIL_MAIDEN, 67, "The Brittle Maiden", :test_endurance_broken],
              [AURIL_WOMB, 68, "Winter's Womb", :test_isolation_broken]]
    while stage < stages.size
      sp, lv, nm, f = stages[stage]
      polite = stage == 0 && flag?(:chapel_auril)
      if polite && !flag?(:auril_courtesy_said)
        set_flag(:auril_courtesy_said)
        say(["AURIL: (almost fond) You answered me politely once. In a little shrine, under the Forge.",
             "AURIL: I said I'd remember. I'll give you the first breath."])
      end
      Stage.pan_back if Stage.panned?
      return if !auril_stage(sp, lv, nm, flag?(f), polite)
      stage += 1
      state[:auril_stage] = stage
      # between forms: a flash, frost where she stood, a new shape (notes 13 E3)
      $game_screen.start_flash(Color.new(220, 240, 255, 230), 14) rescue nil
      Stage.fx("E-01", throne) if throne
      auril_look(stage, throne)
      line = ["The crone's furs fall away. Under them, a woman of ice so thin the light goes through.",
              "The maiden shatters. The shards spin together into a floating diamond, humming.",
              nil][stage - 1]
      say([line]) if line
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
         # Ch11's look back, read here (whole read T3)
         flag?(:looked_at_auril) ? "AURIL: You looked back at me, once. I thought that made you mine. It didn't." : nil,
         "AURIL: You chose, and I felt it. You don't turn on my wheel. You don't turn on theirs.",
         "AURIL: Go home, little stranger. This isn't your winter."].compact)
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

  # Where the diamond lies, once she's down to it: in front of you.
  def auril_diamond
    stage_event("stage_auril_diamond")
  end

  # Purpose: the god wears all three of her hearts at once and takes Alberica
  # off her feet; the party holds on. Ends with Auril as a diamond on the floor.
  def scene_rewritten
    al = herald?(:alberica)
    throne = stage_event("Auril")
    $game_screen.start_shake(5, 10, 16) rescue nil
    say(["The diamond cracks, and it pulls.",
         "Frost reaches out of it three ways.",
         "Toward Frostina. Toward #{al ? 'your' : "Alberica's"} rune. Toward the heart in Sephek's chest."])
    if flag?(:sephek_turned)
      # what the Crown did with his heart, read back (whole read V16/T2)
      say([flag?(:shard_purified) ? "The third strand finds Sephek's heart, warm now, only his. It slides off." :
           flag?(:shard_destroyed) ? "The third strand finds only scar where the splinters were. The frost recoils." :
                                     "The third strand finds nothing. Sephek's chest is empty, and the frost recoils."])
    else
      say(["The third strand finds Sephek's heart and drags him, choking, toward the diamond."])
    end
    # Alberica, lifted off the floor by the rune (P-ALB-04, the rune blazing)
    alb = al ? Stage.herald(:alberica) : (companions.include?(:alberica) ? Stage.summon(:alberica) : nil)
    Stage.walk(alb, [14, 0, -1]) if alb
    Stage.pose(alb, "P-ALB-04", 0) if alb
    say(["Frostina screams. #{al ? 'You are' : 'Alberica is'} lifted off the floor."])
    speak(:alberica, "(through gritted teeth) Somebody. Remember for me.", "(through gritted teeth) ...Remember me.")
    sayc([as(:meat_meat, "Meat Meat remembers! Meat Meat remembers ALL of it!"),
          cl(:wyn, "...We all do. We're right here. Hold on.")])
    cline(:wyn, "(to the diamond, not loud) No. You'll stop.", "(to the diamond) ...You'll stop.")
    auril_look(3, throne)
    $game_screen.start_flash(Color.new(255, 255, 255, 200), 12) rescue nil
    sayc([
          "In the middle of the room something forms: a woman made of all three.",
          "Shimmer's face for a moment. Then #{al ? 'yours' : "Alberica's"}. Then no one's."])
    if flag?(:council_phildendrin)
      say(["(Phildendrin's people at the dock sent up a fire-arrow and every potion in Rootspire.)",
           "(Your team is fully healed.)"])
      pbFadeOutIn { $Trainer.heal_party } rescue nil
    end
    sung = false
    if flag?(:canticle_learned)
      ask = al ? _INTL("Sing the Cycle Canticle? (It frees you, and weakens Auril.)") :
                 _INTL("Have Alberica sing the Cycle Canticle? (It frees her, and weakens Auril.)")
      sung = pbConfirmMessage(ask) rescue true
      say(["#{al ? 'You sing' : 'Alberica sings'}. Hope, loss, endurance.",
           "The strand round #{al ? 'you' : 'her'} goes slack and falls away."]) if sung
      if sung && alb
        Stage.unpose(alb)
        Stage.walk(alb, [14, 0, 1])
      end
    end
    strands = (flag?(:sephek_turned) ? 2 : 3) - (sung ? 1 : 0)
    phases = strands >= 3 ? 2 : 1
    phases.times do |i|
      if i == 0 && flag?(:council_anduin)
        say(["A root breaks up through the ice, green and stubborn, and wraps your team for a breath.",
             "Hyphora's blessing. Everyone is healed."])
        pbFadeOutIn { $Trainer.heal_party } rescue nil
      end
      mon = named_mon(AURIL_REWRITTEN, 70, "The Rewritten Auril")
      frac = flag?(:test_preservation_broken) ? 0.7 : 1.0
      frac -= 0.15 if strands <= 1
      mon.hp = [(mon.totalhp * frac).floor, 1].max
      return if !boss_battle(mon, bgm: FINAL_BOSS_BGM)
      say(["She comes apart, and pulls herself back together round the last strand."]) if i == 0 && phases > 1
    end
    # she comes apart; what's left is a small light on the floor in front of you
    $game_screen.start_flash(Color.new(255, 255, 255, 255), 20) rescue nil
    Stage.fx("E-01", throne) if throne
    throne.instance_variable_set(:@opacity, 0) if throne
    Stage.actor(:auril_diamond, $game_player.x, $game_player.y - 2, 2, graphic: "Followers/CARBINK")
    if alb
      Stage.unpose(alb)
      Stage.walk(alb, [14, 0, 1]) if !sung
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
    autosave_before_choice
    scene_what_do_we_do
  end

  # Map 2089's pages after Auril falls (whole read P1): ask the choice if it
  # hasn't been answered; once it has, rest the autorun page.
  def throne_resume(event_id = nil)
    if ending_chosen?
      if event_id && $game_self_switches
        $game_self_switches[[$game_map.map_id, event_id, "A"]] = true
        $game_map.need_refresh = true
      end
      return
    end
    scene_what_do_we_do
  end

  def ending_chosen?
    flag?(:ending_shatter) || flag?(:ending_third_way) || flag?(:ending_still_keeper)
  end

  # One of the game's autosave slots, written just before the choice, so each ending can be
  # seen without replaying Grimskalle (owner, 2026-11-07).
  def autosave_before_choice
    return if !defined?(Game) || !Game.respond_to?(:auto_save)
    # dump in memory first, so a bad object never leaves a half-written slot (whole read P17)
    dumps = (defined?(SaveData) && SaveData.respond_to?(:compile_save_hash)) ?
              ((Marshal.dump(SaveData.compile_save_hash) && true) rescue false) : true
    ok = dumps && (Game.auto_save rescue false)
    pbMessage(ok ? _INTL("\\me[GUI save game](The game autosaved here, before the choice.)") :
                   _INTL("(The autosave didn't work. Save from the menu if you'd like to.)")) rescue nil
  rescue StandardError => e
    log("autosave_before_choice: #{e.message}")
  end

  #-----------------------------------------------------------------------------
  # SC 13.10 - What do we do with a god? and the endings
  #-----------------------------------------------------------------------------
  # Purpose: the game's question, asked aloud, and the player answers it. The
  # music stops. Auril's last cold stills everyone she ever touched; the one
  # who was never on her wheel can still move, and carries the diamond (story
  # review 13, problem 1). The party argued this on the dock (12.md M12-6); the
  # menu remembers which side you took, and the pick is confirmed (M13-6).
  def scene_what_do_we_do
    pbBGMFade(1.5) rescue nil                                   # (notes 13 E15: silence for the choice)
    if flag?(:sephek_turned)
      Stage.actor(:sephek, $game_player.x + 1, $game_player.y + 1, 8) rescue nil
      say(["Sephek has followed you in. He stands at the back, shivering."])
    end
    still = outsider?
    say(["The Heralds stand round the tiny light on the floor. Nobody moves."])
    if still
      $game_screen.start_tone_change(Tone.new(20, 30, 60, 60), 20) rescue nil
      say(["AURIL: (tiny, from the diamond) Then be still with me.",
           "Frost climbs everyone in the ring, to the shoulders. Their breath stops in the air.",
           flag?(:looked_at_auril) ? "Not yours. She thought she had you. She never did." : "Not yours. You were never on her wheel."])
      pbMessage(_INTL("The diamond lies at your feet."), [_INTL("(Pick it up.)")], 0)
      Stage.remove_actor(auril_diamond) if auril_diamond
      say(["It's very cold, and very small. Every face in the ring is turned to you."])
    end
    say([herald?(:meat_meat) ? "Dawnfang is in your hand. (One stab. No more winters. Ever.)" :
                               "MEAT MEAT: (Dawnfang in her hand) One stab. No more winters. Ever.",
         herald?(:meat_meat) ? "(...Meat Meat would miss snow a little.)" : "MEAT MEAT: ...Meat Meat would miss snow a little."])
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
    if still
      say([["You hold the diamond out on your open palm, toward Meat Meat's blade.",
            "You carry the diamond to Alberica, and Frostina beside her.",
            "You put the diamond in Alberica's hands."][c],
           "The frost lets go of all of them at once."])
      $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 20) rescue nil
    end
    case c
    when 0 then ending_shatter
    when 2 then ending_still_keeper
    else ending_third_way
    end
  end

  # Purpose: the god ended, with the cost said: Meat Meat is a weapon once more,
  # and winter will come back angrier (story review 13, problem 2).
  def ending_shatter
    mm = herald?(:meat_meat)
    sayc([mm ? "(You were a seed. ...Once more a weapon.)" :
               cl(:meat_meat, "(Dawnfang raised, not moving) Meat Meat was a seed. ...Once more a weapon.")])
    Stage.remove_actor(auril_diamond) if auril_diamond
    $game_screen.start_flash(Color.new(255, 255, 255, 255), 16) rescue nil
    pbSEPlay("Ice8") rescue nil
    sayc(["#{mm ? 'You drive' : (with_or_is?(:meat_meat) ? 'Meat Meat drives' : 'You drive')} Dawnfang into the diamond. It bursts into snow.",
          "The Rime breaks at once. The first sunrise over Icewind Dale in two years.",
          "The Auroral Wall falls, and the two times meet. Rootspire and Ten-Towns share one sky.",
          cl(:alberica, "...Well. That's one way to end a party.")])
    Stage.theme("strongWind")
    say(["SEPHEK: Next solstice."]) if flag?(:sephek_turned)
    their_time_payoff
    set_flag(:ending_shatter)
    epilogue
  end

  # Purpose: the third way Shimmer promised Sephek in Chapter 3. Winter goes
  # into Frostina as a season, and the twins turn the wheel.
  def ending_third_way
    al = herald?(:alberica)
    alb = al ? nil : (Stage.speaker("ALBERICA") || (companions.include?(:alberica) ? Stage.summon(:alberica) : nil))
    Stage.remove_actor(auril_diamond) if auril_diamond
    say([outsider? ? "#{al ? 'You hold' : 'Alberica holds'} it up to the light, in both hands." :
                     "#{al ? 'You pick' : 'Alberica picks'} the diamond up. It's very cold, and very small."])
    speak(:alberica, "You don't have to keep everything. Open your hand. It comes back.",
          "...You can let go. It comes back.")
    say([as(:alberica, "Every year. That's what a season is."),
         # (a statement, not a plea: she never begs)
         "AURIL: (tiny) And it ends. Every year.",
         as(:alberica, "And it comes back. Every year.")])
    frost = stage_event("stage_frostina")
    razz = stage_event("stage_razzilith")
    tx, ty = alb ? [alb.x, alb.y] : [$game_player.x, $game_player.y]
    Stage.walk_to(frost, tx, ty - 1, face: 2) if frost
    Stage.walk_to(razz, tx + 1, ty - 1, face: 4) if razz
    Stage.balloon(frost, "B-05", frames: 60) if frost
    say(["Frostina lowers her head to the diamond and hums Shimmer's four notes:",
         "the song of the first vessel, who refused her. Razzilith puts his nose beside hers."])
    # (the player's beat in it: the song came from Chapter 3, and you've heard it since)
    c = pbMessage(_INTL("The four notes, over and over."), [_INTL("(Hum along.)"), _INTL("(Listen.)")], 1)
    say([c == 0 ? "Your four notes come out a little flat. Frostina doesn't mind." :
                  "Nobody else makes a sound."])
    $game_screen.start_flash(Color.new(200, 230, 255, 200), 20) rescue nil
    Stage.fx("E-14", frost, oy: 24) if frost
    say(["The light in the diamond flickers, then settles.",
         "It goes into Frostina like breath into a lung. Winter, the season. Not the cage.",
         "And Frostina, Shimmer's answer, carries it.",
         "A medallion fogs. A ring frosts. Dawnfang hums. The chord from Targos, once."])   # (whole read T25)
    Stage.theme("lake_crater")
    say([herald?(:alerion) ? "Behind your ribs, the second heartbeat goes cold and clean, like a winter morning." :
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
  # Purpose: the trap the Still Keeper showed in Alberica's test, sprung. It's
  # legible (what happens, what you keep) and cheap to leave (you can skip).
  def ending_still_keeper
    al = herald?(:alberica)
    Stage.remove_actor(auril_diamond) if auril_diamond
    sayc([as(:alberica, "Somebody has to hold it. Reptin taught me that."),
          cl(:reptin, "That's not what I... Alberica. Alberica, don't."),
          "#{al ? 'You press' : 'She presses'} the diamond to #{al ? 'your' : 'her'} chest.",
          "Frost spreads, slowly, from the heart outward."])
    Stage.overlay("O-04", fps: 3, fade: 0)                          # frost in from the edges, to white
    sayc(["#{al ? 'You smile' : 'She smiles'} at each of them until #{al ? 'you' : 'she'} can't.",
          # (for one breath she looks exactly like the Still Keeper from her test)
          al ? "For a moment you look exactly like the Still Keeper." : "For a moment she looks exactly like the Still Keeper.",
          "For one breath the world is perfectly still. No wind. No snow. Nothing changing at all.",
          # the restart has a rule you've heard: the Chasm ghost's, in Chapter 5 (context 13 M13-6)
          loop? ? nil : "From very far off, a voice in green: \"Go round again, dear. Find the third way.\"",
          "Then the wheel, held still too long, snaps back."])
    pbSEPlay("Earth3") rescue nil
    Stage.theme("fusion_reversed")                                  # the journey, running backwards
    Stage.overlay("O-06", fps: 5, fade: 0, above_panels: true, wait: true)   # the white cracks like a mirror
    sayc(["The throne room cracks like a mirror.",
          "Every shard shows a moment of your journey, running backwards.",
          as(:alberica, "(from inside the ice, very far away) Oh. ...Oh, no. It doesn't end."),
          as(:alberica, "...I can hear the lottery drums.")])
    set_flag(:ending_still_keeper)
    start_loop
  end

  # Flags that survive the loop; everything else is the story, and replays.
  LOOP_KEEP = %i[intro_done fell_through razzy_blanket]   # (the Blanket isn't handed over twice: whole read P7)
  # Everything else in state is the story, and replays. These belong to the
  # player (the team, the bag and what's in it, the save), not the story.
  LOOP_KEEP_STATE = %i[flags counters companions goal loop_snap loop_gifts bargain_memory mode herald version active starter
                       bag_limit bank pip_upgrades pip_yes chwinga_charges grass_line_v2 locket_day]
  # Counters that are the player's, not the story's: the wheel, the beats and
  # the loops themselves, and how many trainers you've beaten.
  # (the Wheel isn't kept: a loop re-earns it; a skip restores what that act earned. Whole read T31)
  LOOP_KEEP_COUNTERS = %i[story_beats loop_count trainers_beaten]

  def start_loop
    n = (counter(:loop_count) rescue 0).to_i + 1
    flags = state[:flags] || {}
    remember_loop_gifts(flags)
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
    take_story_keys                         # (notes 13 E18: the story hands them out again, or a skip gives them back)
    apply_herald_switches rescue nil         # your own Herald stays hidden, even if Act I is skipped (whole read P14)
    pbMessage(_INTL("(Loop {1}. The story starts over. You keep your team, your bag and your Pokédex.)", n)) rescue nil
    pbMessage(_INTL("(The story's keepsakes go back where you found them. You can skip what you remember.)")) rescue nil
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
  # Purpose: what every choice became, a year on, and the loop closing in the
  # Chasm. It opens at the Hearth with the Heralds' theme; you choose whom to
  # look in on, and each place is a short cut to that place (notes 13 E1: the
  # montage moves, and the player keeps a hand on it). The coda plays in the
  # Cackling Chasm. Old Alberica is the Chapter 5 ghost (owner's decision 6):
  # she comes back to keep the Order's post, and greets the travellers who are
  # about to meet her ghost.
  HEARTH_EPILOGUE = [2053, 5, 11, 8]
  CHASM_CODA = [2042, 16, 36, 8]
  EPILOGUE_PLACES = { wall: nil, shrine: [2061, 23, 20], market: [2050, 31, 28], heartroot: [2057, 9, 14],
                      council: [2054, 11, 13], library: [2062, 16, 6], chasm: [2042, 16, 36], lonelywood: [2021, 42, 35] }
  EPILOGUE_LABELS = { wall: "Hellen's wall", shrine: "The Shrine", market: "The market", heartroot: "The Heartroot",
                      council: "The Council Hall", library: "The Wind-Glass Library", chasm: "The Cackling Chasm",
                      lonelywood: "Lonelywood" }

  # The vignettes, by place: only the ones your story gave (each a few boxes).
  def epilogue_vignettes
    al = herald?(:alerion)
    v = Hash.new { |h, k| h[k] = [] }
    v[:wall] << ["Hellen's wall. A new carving, cut right through the shadowy figure with the knife:",
                 "a cat-man with a golden dagger, mid-stride, stepping out of it: Glimmer, who was Shade.",
                 "Under it: THE DAGGER REBORN."]
    v[:wall] << "On the shelf under the new carving, a little wooden cat. Hellen dusts round it."   # (Shimmer's "Keep the cat": whole read T17)
    if outsider?
      v[:wall] << ["And under the small sixth figure, freshly cut: your name.",
                   flag?(:told_tamsin) ? "TAMSIN: Told you, #{player_display_name}. Told you it was you." :
                                         "TAMSIN: You never said. I cut it anyway. It's my wall too."]
      if flag?(:beat_tamsin_final)
        v[:wall] << (herald?(:wyn) ? "TAMSIN: (sitting down, chin in hands) Right. Everything. In order. Start at the Sap Gate." :
                                     "TAMSIN: (sitting down, chin in hands) Right. Everything. In order. Start at the lantern.")
      end
    end
    if flag?(:ending_third_way)
      v[:shrine] << [al ? "At the Shrine, Frostina sleeps with her head in your lap, humming in her sleep." :
                          "At the Shrine, Frostina sleeps with her head in Alerion's lap, humming in her sleep.",
                     al ? "You hum back, off-key, the way Shade used to." : "Alerion hums back, off-key, the way Shade used to."]
    end
    if flag?(:eline_martyred)
      v[:shrine] << ["On the Shrine steps, someone has carved a small figure in blue, her hands open.",
                     "Nobody will say who. Sephek leaves snowdrops there."]
    end
    v[:shrine] << ["Round the Shrine stump, under the old vow, two new names:",
                   "the first Dragoons in four hundred years. Rheven had them cut deep."] if flag?(:dragoons_bound)
    if flag?(:phildendrin_found)
      v[:market] << ["Razzilith lands in the market with Meat Meat and Phildendrin on his back.",
                     "Phildendrin is screaming happily#{flag?(:council_phildendrin) ? ', in the Autumn sash' : ''}.",
                     herald?(:meat_meat) ? "(Hold on with your KNEES, Mama!)" : "MEAT MEAT: Mama! Hold on with your KNEES!"]
    end
    # the trial's sentence, come due (whole read T11)
    if flag?(:verdict_service) && (herald?(:meat_meat) || with_or_is?(:meat_meat) || flag?(:meat_meat_joined))
      v[:market] << (herald?(:meat_meat) ? "(You serve your season at the refugee camp. By week two you run it. There is coffee.)" :
                                           "Meat Meat serves her season at the camp. By week two she runs it. There is coffee.")
    end
    v[:market] << (al ? "You're teaching a Rootwarden class how to fall off a dragon properly." :
                        "Alerion is teaching a Rootwarden class how to fall off a dragon properly.")
    if flag?(:talion_released)
      v[:market] << (al ? "You laugh at something Alberica says. Nobody has ever heard you laugh." :
                     herald?(:alberica) ? "Alerion laughs at something you say. Nobody has ever seen him laugh." :
                                          "He laughs at something Alberica says. Nobody has ever seen him laugh.")
    end
    if flag?(:anduin_leaving) && !flag?(:anduin_reconciled)
      v[:heartroot] << (herald?(:reptin) ? "(You plant something in the Heartroot alone. You write to Anduin every week.)" :
                                           "Reptin plants something in the Heartroot alone. He writes to Anduin every week.")
    end
    if flag?(:anduin_reconciled)
      v[:heartroot] << [herald?(:reptin) ? "You and Anduin kneel together in the Heartroot, planting something." :
                                           "Reptin and Anduin kneel together in the Heartroot, planting something.",
                        herald?(:reptin) ? "(It'll be a tree. Eventually. Everything comes round, eventually.)" :
                                           "REPTIN: It'll be a tree. Eventually. Everything comes round, eventually."]
    end
    v[:heartroot] << ["In the spore beds under the Heartroot, every mushroom has a name now.",
                      "Sableye is asleep on #{herald?(:wyn) ? 'your' : "Wyn's"} boot."] if herald?(:wyn) || flag?(:wyn_joined)
    v[:heartroot] << "Back at the Underdark door, a sign: BACK SOON. ASK THE MUSHROOMS." if flag?(:godspark_shadow)
    if flag?(:eline_captured)
      v[:council] << ["Down in the root-cells, a woman in threadbare blue still prays every morning.",
                      "Backwards, mostly. Some mornings now, the warden says, a line comes out the right way."]
    end
    # the city you voted for (whole read T12)
    v[:council] << "Summer's chair has a direwolf asleep under it. Rheven says it's a security measure." if flag?(:council_rheven)
    v[:council] << "Mira's chair faces the window, toward the Glasswater. She sails on recess." if flag?(:council_mira)
    v[:council] << "Eirwen chairs the Autumn session barefoot. The minutes are in verse." if flag?(:council_eirwen)
    v[:council] << "Anduin keeps an iron ring on the Council table, for whoever's late. It's always Kelyn." if flag?(:council_anduin)
    if flag?(:council_heralds)
      v[:council] << ["In the Council Hall, Summer's chair has a Herald's cloak over the back of it,",
                      "and a coffee ring on the arm."]
    end
    v[:library] << (herald?(:alberica) ?
                    ["In the Wind-Glass Library, you find a crystal page in your own hand, very old.",
                     "You read it, laugh, and start to write it.",
                     "The Council gives you a new title: Keeper of Time. You make them spell it properly."] :
                    ["In the Wind-Glass Library, Alberica finds a crystal page in her own hand, very old.",
                     "She reads it, laughs, and starts to write it.",
                     "The Council gives her a new title: Keeper of Time. She makes them spell it properly."])
    # Skant's "I'll tell you the thought later" (13.05), paid (notes 13 E13)
    v[:library] << ["On a shelf, a talking orb finally tells a librarian the thought.",
                    "It takes three days. It was a good one."] if flag?(:skant_freed)
    if flag?(:reptin_warden_vow)
      v[:chasm] << [herald?(:reptin) ? "Every winter you go back to the Cackling Chasm, as you swore." :
                                       "Every winter Reptin goes back to the Cackling Chasm, as he swore.",
                    herald?(:reptin) ? "The wolves meet you at the bridge." : "The wolves meet him at the bridge.",
                    flag?(:chasm_watch_kept) ? "The grey wolf is greyer now." : nil].compact
    end
    # Reptin's vow to Garagai, kept (whole read T13)
    v[:chasm] << "At Garagai's lodge, Norsu noses the axe-head back onto its peg, and stays by it all day." if flag?(:garagai_axe)
    v[:chasm] << "A grown yeti watches from the ridge above the Chasm, and doesn't come closer." if flag?(:got_yetot)
    v[:lonelywood] << ["In Lonelywood, a man in a coat, for the first time, buys soup.",
                       "He's given a cookie shaped like a halfling."] if flag?(:sephek_turned)
    v.reject { |_k, l| l.flatten.compact.empty? }
  end

  # Map music stays the epilogue's while it cuts from place to place.
  def hold_music
    $ft_hold_music = true
    yield
  ensure
    $ft_hold_music = false
  end

  def epilogue
    pbBGMFade(2.0) rescue nil
    pbFadeOutIn { Stage.jump(*HEARTH_EPILOGUE) } rescue nil
    Stage.theme(:heralds)                                         # the Heralds' theme (notes 13 E1)
    say([flag?(:ending_shatter) ? "A year later. The first frost has come early. Nobody says why." : "A year later."])
    places = epilogue_vignettes
    hold_music do
      until places.empty?
        keys = places.keys
        c = pbMessage(_INTL("Whom do you look in on?"), keys.map { |k| _INTL(EPILOGUE_LABELS[k]) }, -1)
        k = keys[(c && c >= 0) ? c : 0]
        lines = places.delete(k)
        epilogue_place(k) { lines.each { |l| say(Array(l).compact) } }
      end
      # Shatter's last image: the owl at midwinter (notes 13 E19)
      if flag?(:ending_shatter)
        Stage.visit(2050, 31, 28) do
          owl = Stage.actor(:owl, 31, 26, 2, graphic: "Followers/NOCTOWL")
          say(["Midwinter. On a branch over the market, a white owl sits very still.",
               "It watches the people under it. It doesn't blink.",
               flag?(:sephek_turned) ? "Three weeks to midwinter's night. In Lonelywood, Sephek has started counting." : nil].compact)
          Stage.remove_actor(owl) if owl
        end
      end
    end
    if flag?(:ending_third_way) && (counter(:wheel) rescue 0).to_i >= 4
      Stage.theme("Ecruteak City")                                # the Hearth's own music
      say(["The next autumn's Festival of Returning Light.",
           journey? ? "All the Heralds, Tamsin#{flag?(:sephek_turned) ? ' and Sephek' : ''}, round one table at the Hearth, and you." :
                       "All of you, Tamsin#{flag?(:sephek_turned) ? ' and Sephek' : ''}, round one table at the Hearth.",
           "And one empty chair, with a carved wooden cat on it."])
      c = pbMessage(_INTL("Hellen fills your cup."), [_INTL("(Raise it to the empty chair.)"), _INTL("(Raise it to everyone.)")], 0)
      set_flag(c == 0 ? :toast_empty_chair : :toast_everyone)
      say(["Hellen pours. Nobody makes a speech.",
           "Frostina and Razzilith sleep on the roof and keep it warm."])
    end
    epilogue_coda
  end

  # One place in the montage: a cut to it, then back to the Hearth.
  def epilogue_place(key)
    spot = EPILOGUE_PLACES[key]
    if !spot
      tam = outsider? ? (Stage.actor(:tamsin, $game_player.x + 1, $game_player.y, 4) rescue nil) : nil
      yield
      Stage.remove_actor(tam) if tam
      return
    end
    Stage.visit(*spot) { yield }
  rescue StandardError => e
    log("epilogue_place #{key}: #{e.message}")
    yield
  end

  def epilogue_coda
    # the coda: the ghost was her (owner's decision 6)
    pbBGMFade(1.0) rescue nil
    pbFadeOutIn { Stage.jump(*CHASM_CODA) } rescue nil
    Stage.theme("sinjoh")                                        # time, turning (not the Chasm's own music)
    say(["Many years later. The Cackling Chasm."])
    px, py = ([$game_player.x, $game_player.y] rescue [0, 0])
    own = (pbResolveBitmap("Graphics/Characters/FT_alberica_old") rescue nil)
    old = Stage.actor(:old_alberica, px, py, 2, graphic: own ? "FT_alberica_old" : "FT_green_ghost")
    hid = old && !$game_player.transparent
    $game_player.transparent = true if hid
    say(own ? ["An old dwarf woman in a faded beret stands in the hall where a hag once laughed.",
               "Under the beret, the ghost's face.",
               "Over her arm, a dark green robe, folded.",
               "At her belt, a silver locket: half sun, half moon."] :
              ["An old dwarf woman in green robes stands in the hall where a hag once laughed.",
               "She looks exactly like the ghost.",
               "At her belt, a silver locket: half sun, half moon."])
    say(["(It's you. It was always going to be you.)"]) if herald?(:alberica)
    say(["OLD ALBERICA: Time's a wheel, dear. Somebody has to stand where it turns.",
         "OLD ALBERICA: The Order needs one last guardian down here. I've had worse jobs."])
    Stage.face(old, 8) if old
    Stage.pan_to(px, py - 4) rescue nil                          # the cave mouth, up the hall
    say(["She looks up at the cave mouth.",
         # a stranger only where somebody fell out of a lantern (whole read T8)
         (journey? || herald?(:wyn)) ? "Five travellers and a stranger are about to come in out of the cold." :
                                       "Five travellers are about to come in out of the cold.",
         journey? ? "The stranger fell out of a lantern." :
         herald?(:wyn) ? "The stranger has a Sableye asleep on their boot." :
         herald?(:alberica) ? "One of the five is you. Louder. Younger." : "One of the five is you."])
    Stage.pan_back rescue nil
    Stage.face(old, 2) if old
    say(["OLD ALBERICA: (smiling) Oh. You're early."])   # (her ghost's first line, so the loop closes on it: whole read V22)
    # (the last input: the story's over, and the game goes on)
    pbMessage(_INTL("THE END"), [_INTL("(Keep playing.)")], 0)
    Stage.cleanup rescue nil
    $game_player.transparent = false if hid
    set_flag(:game_complete)
    add_counter(:story_beats)
    state[:goal] = "The story's done. Rootspire is yours to wander, and Hellen's Hearth is open."
    pbFadeOutIn { Stage.jump(2050, 31, 28, 2) } rescue (transfer(2050, 31, 28, 2) rescue nil)
    postgame_vault_hook
  end

  # After the end, Hellen and Tamsin know it's over (notes 13 E17).
  POSTGAME_HELLEN = ["HELLEN: (pouring before you ask) New verse from the bard. It's dreadful. Everyone sings it.",
                     "HELLEN: Sit. Eat. Nobody's going anywhere frightening tonight."]
  POSTGAME_TAMSIN = ["TAMSIN: I wrote it all down. In order. You're in it.",
                     "TAMSIN: ...You can be the hero in the second edition. Maybe."]

  %i[cruelty endurance isolation preservation].each do |k|
    define_method(:"scene_test_#{k}") { send(:"test_#{k}", nil) }
    module_function :"scene_test_#{k}"
  end

  def apply_chapter13_switches
    return if !active? || !$game_switches
    $game_switches[SW_CROWN_OPEN] = tests_faced >= 4
    $game_switches[SW_FROSTINA_FREE] = flag?(:frostina_freed)
    $game_switches[SW_AURIL_DOWN] = flag?(:auril_down)
    # Eirwen's shortcut, seen in the Hall (notes 13 E13)
    $game_switches[SW_HALL_SPRING] = flag?(:council_eirwen)
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
      say([{ reptin: "(The Dale and Anduin's husband, on the same morning. He'll want to see the lake.)",
             alerion: "(Your village is out there under the snow. You can visit. You don't have to stay.)",
             meat_meat: "(Mama's Dale and Razzy's tree. Same morning. Meat Meat needs two coffees.)",
             alberica: "(Ironhollow, out there. Never drew a name. Somebody should go home and say what it cost.)",
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

# The epilogue's music holds while it cuts from place to place (a visit would
# otherwise start each map's own music).
if defined?(Game_Map)
  class Game_Map
    unless method_defined?(:ft_j_autoplay)
      alias ft_j_autoplay autoplay
      def autoplay(*args)
        return if $ft_hold_music
        ft_j_autoplay(*args)
      end
    end
    if method_defined?(:autoplayAsCue) && !method_defined?(:ft_j_autoplayAsCue)
      alias ft_j_autoplayAsCue autoplayAsCue
      def autoplayAsCue(*args)
        return if $ft_hold_music
        ft_j_autoplayAsCue(*args)
      end
    end
  end
end

# After the end, the people who stayed home know it's over (notes 13 E17).
module FrostThaw
  class << self
    unless method_defined?(:ft_j_hellen)
      alias ft_j_hellen hellen
      def hellen(event_id = nil)
        return ft_j_hellen(event_id) if !flag?(:game_complete)
        lines = POSTGAME_HELLEN.dup
        lines << "HELLEN: Somebody keeps leaving a cup by the cat's chair. ...It's me." if flag?(:toast_empty_chair)
        lines << "HELLEN: You raised a cup to the lot of us. Nobody's let me forget it." if flag?(:toast_everyone)
        say(lines, event_id)
      end
    end
    unless method_defined?(:ft_j_tamsin)
      alias ft_j_tamsin tamsin
      def tamsin(event_id = nil)
        return ft_j_tamsin(event_id) if !flag?(:game_complete) || !journey? || !flag?(:beat_tamsin)
        say(POSTGAME_TAMSIN, event_id)
      end
    end
  end
end
