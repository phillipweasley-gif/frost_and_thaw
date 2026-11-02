#===============================================================================
# Frost & Thaw - "Holed Up" (Rime of the Frostmaiden, pp. 53-58)
#
# Two winter wolves are extorting Dougan's Hole for food and treasure on behalf
# of Norsu, an awakened woolly mammoth who watches over the frozen corpse of
# his master, the frost giant Garagai, and delights in killing humanoids to
# avenge him. The wolves hold Silja and Finn Dejarr in Garagai's ice lodge.
#
#   * Good wolf, bad wolf: Koran limps up and lies (Garagai is alive, kicks
#     him, holds the prisoners). Refuse him and Kanan bares his fangs; refuse
#     both and they appeal to your conscience, then bolt for the lodge.
#   * The starving pack on the tundra (the campaign: Reptin feeds it, and a
#     she-wolf bites him).
#   * The lodge (map 1.8): three openings on the east face lead to the flensing
#     chamber (L2), the cage (L3) and the icicle corridor (L4). The wolves say
#     Garagai isn't home, nudge you toward L4 and wait outside to see Norsu
#     kill you. L5 the tomb and the ice throne (its rune calls a blizzard);
#     L6 the war room and its kobolds; L7 Garagai's bedroll; L8 the whale oil
#     and the remorhaz tunnel out the south side, which the wolves don't watch.
#   * The cage: oil the hinges, or heat the slats and pull them apart, or pick
#     the lock (and the hinges still scream unless they're oiled).
#   * Home: the wolves strike on the way; kill one and the other flees. Hilda
#     gives you her husband's boots of the winterlands. (He was also her
#     older brother. It's a small town.)
#===============================================================================
module FrostThaw
  SW_HU_WOLVES_WAIT = 4041    # Koran and Kanan are waiting outside the lodge (L1)
  SW_HU_BLIZZARD    = 4042    # the ice throne's blizzard is up around the lodge

  RELIC_ITEMS.merge!(
    FT_WINTERBOOTS: ["Boots of the Winterlands", "Boots of the Winterlands", 8, 0,
      "Fur-lined boots Hilda's husband won in a drinking contest. Warm in any cold; they never slip on ice.", 0, 0, 6]
  )

  TEXT.merge!(
    garagai_bedroll: ["The only furniture in this cavernous chamber: a big fur bedroll, matted and musty.",
                      "Garagai slept here. Nobody sleeps here now."],
    lodge_exterior: ["Jutting up out of the tundra: a towering edifice built entirely of ice.",
                     "Three tall openings on its east face. Easily three times the height of anything in Ten-Towns."],
    wolves_wait: ["KORAN: We'll stand guard out here. Garagai isn't home. Go on in.",
                  "KANAN: (not looking at you) Take the corridor in the middle. It's quickest."],
    ice_corridor: ["The passage is choked with ice. Icicles hang overhead in clusters, points sharp as daggers."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # Hilda
  #-----------------------------------------------------------------------------
  def hilda(event_id = nil)
    if flag?(:kids_home)
      say(["HILDA: Every time I look at them I have to count. One, two. One, two.",
           "HILDA: Whatever you need from Dougan's Hole, you come to this door first."], event_id)
    else
      sayc(["HILDA: My Sil. My Finn. The Speaker says they're gone. Everyone says they're gone.",
            "HILDA: They're not. A mother knows. I keep their bowls on the table.",
            "HILDA: If you're going out there... please. Please.",
            cl(:alberica, "(taking both her hands) Keep the bowls out, love. We'll fill them.")], event_id)
    end
  end

  def scene_kids_homecoming
    return if flag?(:kids_home)
    set_flag(:kids_home)
    $game_switches[SW_KIDS_HOME] = true if $game_switches
    add_counter(:story_beats)
    say(["Silja doesn't wait for anyone. She's off down the street, braids flying, Finn stumbling after her.",
         "Hilda runs out barefoot into the snow. She doesn't say anything. She doesn't have to.",
         "Later, she comes out again with a pair of fur-lined boots.",
         "HILDA: These were my husband's. He won them off a wayward adventurer. Drinking contest. He was a hunter.",
         "HILDA: Passed a few years back. Warmest boots in the Dale. They'll not slip on ice, not ever.",
         "HILDA: Take them. He was my older brother too, and he'd want them used."])
    give_key(:FT_WINTERBOOTS)
    pbReceiveItem(:REVIVE, 2) rescue nil
    sayc([cl(:shade, "(very quietly) ...Her husband was her brother."),
          cl(:alerion, "Small town."),
          cl(:alberica, "(sniffing loudly) I'm not crying. It's the wind. Somebody give me a drink for the wind."),
          cl(:meat_meat, "Meat Meat is also not crying. That is snow."),
          "DURMOOT: (from her door, after a while) ...Lodge. Now. I said I'd fight you myself."])
    state[:goal] = "Speaker Durmoot's lodge. She'll fight you for her seal."
  end

  #-----------------------------------------------------------------------------
  # Good wolf, bad wolf (RotF p. 54)
  #-----------------------------------------------------------------------------
  # SC 4.04 - The limping wolf
  def koran(event_id = nil)
    say(["A white wolf the size of a pony limps out of the snow on one back leg, whimpering like a kicked dog.",
         "KORAN: Please. Please, travellers. I'm Koran. My master did this. Garagai. A frost giant.",
         "KORAN: Mean old Garagai. He kicks me. He kicks me every day.",
         "KORAN: He took two of the little townsfolk. He keeps them in his lodge, west, more than half a day.",
         "KORAN: Help me free them. Let him feel what it's like, to lose something."], event_id)
    choice = pbMessage(_INTL("What do you do?"),
                       [_INTL("\"Show us.\""), _INTL("\"Which leg was it, again?\""), _INTL("\"No.\"")], 0)
    if choice == 1
      sayc(["Koran blinks. He was limping on the left leg. Now he's limping on the right.",
            as(:shade, "Ha! Oh, I like this one. Terrible liar. Great coat."),
            cl(:alerion, "Told you. Liars forget."),
            "KORAN: ...Clever. Follow anyway. The children are real, even if my limp isn't."])
      set_flag(:caught_koran)
    elsif choice == 2
      bad_wolf
    else
      sayc(["KORAN: This way. This way. Quickly, before the snow fills my tracks.",
            as(:reptin, "(quietly) There's two of them. I can smell the other one."),
            cl(:meat_meat, "Meat Meat will walk next to the doggy. Close. Very friendly.")])
      set_flag(:followed_koran)
    end
    say(["Koran trots off west into the white, and something else white trots after him, just out of sight."])
    set_flag(:met_wolves)
    set_switch(SW_HU_WOLVES_WAIT, true)
    set_self_switch(event_id, "A")
    state[:goal] = "Follow the wolves' tracks west across the tundra, to Garagai's lodge."
  end

  # Kanan steps out to play the bad wolf; then both appeal to your conscience.
  def bad_wolf
    say(["A second white wolf rises out of a drift you'd have sworn was empty.",
         "KANAN: My brother asked you nicely.",
         "He bares teeth like icicles, very close to your face.",
         "KANAN: Garagai kicked him. He'll think twice before he hurts one of us again.",
         "KANAN: So you'll walk with us. Or you'll be dinner. Choose."])
    c = pbMessage(_INTL("What do you do?"), [_INTL("Change your mind."), _INTL("Stand firm.")], 0)
    if c == 0
      sayc([cl(:reptin, "(very calm) We'll come. No need for teeth. Teeth are so... last resort."),
            "KANAN: (sitting back, satisfied) Good."])
      set_flag(:followed_koran)
      return
    end
    sayc([as(:alerion, "No."),
          cl(:meat_meat, "Meat Meat bites back. Meat Meat is very bitey."),
          "The wolves look at each other. Then the act drops, all at once.",
          "KORAN: It's awfully cold in that lodge.",
          "KANAN: They won't suffer much longer. It's only a matter of time before Garagai skins them and eats them.",
          "They bolt away west, leaving tracks a child could follow.",
          cl(:shade, "...They want us to follow. That's the whole trick, and it's working.")])
    set_flag(:refused_wolves)
  end

  def scene_tundra_start
    sayc(["West of Dougan's Hole, everything is white. The blizzard comes in sideways.",
          flag?(:met_wolves) ? "The wolves' tracks run ahead, west, filling with snow almost as fast as you find them." :
                               "Under the drifts there are tracks: two wolves, enormous ones, heading west.",
          as(:shade, "Thirteen miles of this. Wonderful."),
          cl(:alberica, "Think of it as a long, cold walk with excellent company."),
          cl(:shade, "I am. That's the problem.")])
  end

  # SC 4.05 - The starving pack. Ordinary wolves, gaunt with hunger. Reptin
  # feeds them whatever you choose, and one bites him (the campaign).
  def starving_pack(event_id = nil)
    return if $game_switches && $game_switches[SW_PACK_GONE]
    me = herald?(:reptin)
    say(["Not winter wolves. Ordinary ones, so thin you can count their ribs.",
         "They don't attack. They just watch the packs on your backs.",
         me ? "You're already unbuckling your food bag. (The Dale isn't sparing them. We can.)" :
              "REPTIN: (already unbuckling his food bag) The Dale isn't sparing them. We can."], event_id)
    opts = me ? [_INTL("Share it all."), _INTL("Share only your own.")] : [_INTL("Help him."), _INTL("Hold him back.")]
    choice = pbMessage(_INTL("What do you do?"), opts, 0)
    if choice == 0
      sayc([me ? "The others put their rations out beside yours." : "You both put out the rations.",
            cl(:meat_meat, "...Meat Meat gives the jerky. Not the coffee beans. Wolves don't deserve the beans.")])
      set_flag(:fed_pack)
      wheel(1)
    else
      say([me ? "(We need that food. You know. You share your own anyway.)" : "You put a hand on his arm. \"We need that food.\"",
           me ? nil : "REPTIN: I know. I'm sorry.",
           me ? nil : "He shares his own anyway."].compact)
      set_flag(:fed_pack_reptin_only)
    end
    say(["The pack eats. One lean she-wolf comes close enough to touch.",
         me ? "You reach out, and she bites: fast, deep, then gone." : "Reptin reaches out, and she bites: fast, deep, then gone."])
    speak(:reptin, "Fair. I'd bite me too. I'm very bitable.", "...Fair. I'd bite me too.")
    sayc(["The bite doesn't bleed. It burns like fire under snow.",
          cl(:alberica, "Let me see that, sweetheart."),
          as(:reptin, "I'm fine. Don't look at it. I'm fine.")])
    set_flag(:reptin_bitten)
    $game_switches[SW_PACK_GONE] = true if $game_switches
  end

  #-----------------------------------------------------------------------------
  # Garagai's ice lodge (map 1.8)
  #-----------------------------------------------------------------------------
  # L1: the wolves got here first. They sniff the air, say Garagai isn't home,
  # and offer to stand guard while you go in. (They're waiting for Norsu.)
  def scene_lodge_approach
    return if !flag?(:met_wolves) || flag?(:kids_freed)
    say(["Two white wolves sit in the snow before the lodge's openings, as if they've been there for hours.",
         "KORAN: (sniffing the air, nose high) He's not home. Garagai. Out hunting whales.",
         "KANAN: We'll stand guard out here. In case he comes back.",
         "KORAN: Go in by the corridor. The middle one. It's quickest to the children."])
    sayc([cl(:reptin, "(pleasantly) How thoughtful. And you won't come in yourselves?"),
          "KANAN: ...Wolves don't like ice houses.",
          cl(:shade, "(under their breath) They're lying about the giant. He's in there. Something is."),
          cl(:alerion, "Then why stay outside? Afraid of their master?"),
          cl(:shade, "Or waiting to see what's left of us.")])
    set_flag(:lodge_wolves_seen)
  end

  # Stepping up toward the lodge's openings (once).
  def scene_lodge_approach_step(event_id = nil)
    return if flag?(:lodge_wolves_seen) || !flag?(:met_wolves) || flag?(:kids_freed)
    scene_lodge_approach
  end

  def scene_lodge_enter
    set_flag(:lodge_entered)
    add_counter(:story_beats)
    sayc(["Inside, the walls are glittering ice thirty feet high. Everything here was built for giants.",
          "From deeper in comes a sound like a bellows: something enormous, breathing slowly.",
          "And under it, very faintly, a child coughing.",
          cl(:reptin, "(one word, flat) Quiet."),
          cl(:meat_meat, "(very quiet, very fast) Meat Meat hears it. Meat Meat is going.")])
  end

  # L4: the icicle corridor. Creep through, or the noise wakes the tomb.
  def ice_corridor(event_id = nil)
    return if flag?(:corridor_crossed) || flag?(:norsu_met)
    say(lines_for(:ice_corridor), event_id)
    c = pbMessage(_INTL("How do you go?"), [_INTL("Creep through, one at a time."), _INTL("Hurry.")], 0)
    set_flag(:corridor_crossed)
    if c == 0
      sayc(["You go through in single file, slow as cold syrup, ducking every point.",
            cl(:alerion, "(barely a breath) Mind your heads."),
            "Nothing falls. Nothing wakes."])
    else
      say(["Someone's shoulder clips an icicle. It falls, and shatters like a dropped plate.",
           "Deep in the lodge, the breathing stops."])
      norsu(event_id)
    end
  end

  def norsu_notice(event_id = nil)
    return if flag?(:norsu_met)
    norsu(event_id)
  end

  # L5: Norsu. Calm him by claiming friendship with Garagai, or by vowing to
  # avenge him; otherwise he charges.
  def norsu(event_id = nil)
    if flag?(:norsu_met)
      return talk(:norsu_calm, event_id)
    end
    say(["An oval chamber with high walls of glittering ice, like a sepulchre.",
         "The frozen, hacked-up corpse of a frost giant lies on the floor, entombed in clear ice.",
         "Standing over it: a woolly mammoth. It turns, and it stares down at you with hate in its eyes.",
         "NORSU: You are to blame for all of this!",
         "NORSU: Small ones killed him. Small ones took his axe, his breath. Small ones will pay for it.",
         "NORSU: The wolves bring me their food. Their gold. And one day, them."])
    choice = pbMessage(_INTL("What do you say?"),
                       [_INTL("\"We were his friends.\""), _INTL("\"We'll find who took the axe.\""), _INTL("Stand your ground")], -1)
    case choice
    when 0
      say(["NORSU: ...Friends. Garagai had friends. Giants, who sat at his table. Never small ones.",
           "NORSU: But you came to his tomb. His friends never came to his tomb.",
           "The mammoth's head lowers, slowly. (It believed you. Mostly.)"])
      calm_norsu
    when 1
      say(["NORSU: The ones who killed him took his axe, and left him for me to watch.",
           "NORSU: ...Swear it. On his ice."])
      speak(:reptin, "I swear it. Whoever took his axe will answer for it, and the axe comes back to him.",
                     "I swear it. It comes back to him.")
      sayc([cl(:meat_meat, "Meat Meat swears too. Meat Meat bites whoever took it."),
            "The mammoth lowers his head."])
      set_flag(:garagai_vow)
      calm_norsu
    else
      say(["Norsu lowers his tusks and charges!"])
      if boss_battle(named_mon(:MAMOSWINE, 28, "Norsu"))
        say(["Norsu staggers, groans, and sinks down beside his master. He doesn't get up.",
             "NORSU: ...Take what you came for. Leave us be."])
        set_flag(:norsu_beaten)
        set_flag(:norsu_met)
        $game_switches[SW_NORSU_CALM] = true if $game_switches
      end
    end
  end

  def calm_norsu
    say(["NORSU: Honour him, then. A prayer, or a gift. And then go, and let me mourn."])
    c = pbMessage(_INTL("Honour Garagai?"), [_INTL("Say a prayer over him."), _INTL("Leave a gift."), _INTL("Just go.")], 0)
    if c == 0
      sayc(["You say what you can about someone you never met.",
            cl(:alberica, "(softly, after you) He kept a whale in his kitchen and a mammoth who loved him. That's a good life."),
            "Norsu listens to every word."])
    elsif c == 1
      sayc(["You leave something small on the ice over his chest. Norsu looks at it for a long time.",
            cl(:reptin, "(quietly) Grief takes gifts it'll never use. That's rather the point.")])
    end
    set_flag(:norsu_calmed)
    set_flag(:norsu_met)
    $game_switches[SW_NORSU_CALM] = true if $game_switches
  end

  # L5: the ice throne. The Giant rune for "ice" in its backrest; sit in it and
  # you can call a blizzard that wraps the lodge for hours (once a tenday).
  def ice_throne(event_id = nil)
    say(lines_for(:ice_throne), event_id)
    if !flag?(:norsu_met)
      return say(["(Norsu is watching. Not now.)"])
    end
    return if !pbConfirmMessage(_INTL("Climb up and sit in the throne?"))
    say(["You climb up. The throne is far too big; your feet dangle like a child's.",
         "The rune hums through your spine. You understand, without being told: you could call a storm from here."])
    day = (pbGetTimeNow.to_i / 86_400 rescue 0)
    last = state[:throne_day]
    if last && day - last < 10
      return say(["The rune is dull, still drawing breath from the last storm. (It needs a tenday to recover.)"])
    end
    return if !pbConfirmMessage(_INTL("Call a blizzard?"))
    state[:throne_day] = day
    set_switch(SW_HU_BLIZZARD, true)
    set_flag(:throne_blizzard)
    pbSEPlay("Wind1") rescue nil
    $game_screen.start_flash(Color.new(255, 255, 255, 160), 20) rescue nil
    sayc(["The rune flares. Outside, the wind changes key.",
          "Within a minute the lodge is wrapped in white. A mile of blizzard, in every direction.",
          cl(:shade, "Well. Now nobody's following our tracks home. Including us."),
          cl(:alerion, "The wolves can't see through that. Good.")])
  end

  def whale_oil(event_id = nil)
    if flag?(:whale_oil)
      return say(["Five barrels of whale oil, each as heavy as a sled. You've already filled a flask."], event_id)
    end
    sayc(["A foul smell fills the room: barrels of whale oil, rendered from Garagai's catches.",
          "You fill an empty flask. It reeks, and it's slick as anything.",
          cl(:shade, "Lovely. Now we smell like a dead giant's pantry. Very stealthy.")], event_id)
    pbMessage(_INTL("\\me[Item get]You got a flask of whale oil."))
    set_flag(:whale_oil)
  end

  def lodge_chest(event_id = nil)
    say(["A stone chest, half buried in ice. It takes a long while to chip it free.",
         "Inside: giant-sized flensing tools, and a tiny scrimshaw goat that fits in your hand."], event_id)
    pbReceiveItem(:NUGGET) rescue nil
    set_self_switch(event_id, "A")
  end

  def kobolds(event_id = nil)
    return if $game_switches && $game_switches[SW_KOBOLDS_GONE]
    say(["Three small white-scaled kobolds cower behind the ice chairs, clutching each other.",
         "HOLGI: Don't hurt! Don't hurt! We not mean to kill little stone thing! It startle us!",
         "SNORP: We think house empty! House not empty! House have BIG HAIRY ANGRY!",
         "ZILBO: And wolves outside! Wolves everywhere! Help us get out? We very small and very sorry."], event_id)
    sayc([cl(:meat_meat, "Little lizards! Meat Meat will not bite. Meat Meat promises."),
          cl(:reptin, "She means you're safe. Mostly.")])
    if pbConfirmMessage(_INTL("Help the kobolds escape?"))
      say(["You point them to the oil store and the tunnel in its floor. They bow until their snouts touch the ice.",
           "HOLGI: Kind big ones! Take shiny! Shiny cold! Never melts! We find it, now we give it!"])
      pbReceiveItem(:NEVERMELTICE) rescue nil
      say(["They scurry off in a line, tails held high, and are gone."])
      set_flag(:kobolds_freed)
      $game_switches[SW_KOBOLDS_GONE] = true if $game_switches
    else
      say(["The kobolds hunker back down behind the chairs, shivering."])
    end
  end

  # L3: the cage. Three ways in: oil and open the gate; heat the slats and pull
  # two apart; or pick the lock (the hinges still scream unless oiled).
  def party_has_fire?
    $Trainer.party.any? do |pk|
      next false if pk.egg? || pk.fainted?
      pk.hasType?(:FIRE) || pk.moves.any? { |m| %i[EMBER FIREFANG FLAMEWHEEL FLAMETHROWER FIREPUNCH HEATWAVE INCINERATE FIRESPIN].include?(m.id) }
    end
  rescue StandardError
    false
  end

  def party_has_strength?
    $Trainer.party.any? do |pk|
      next false if pk.egg? || pk.fainted?
      pk.hasType?(:FIGHTING) || pk.attack >= 60 || pk.moves.any? { |m| %i[STRENGTH ROCKSMASH].include?(m.id) }
    end
  rescue StandardError
    false
  end

  def cage(event_id = nil)
    return if flag?(:kids_freed)
    if !flag?(:met_kids)
      set_flag(:met_kids)
      say(["A huge slatted animal cage stands against the wall. Garagai built it for Norsu, when the mammoth was young.",
           "Its gate hangs on rusty hinges as big as your head. Inside, two shivering teenagers look out at you.",
           "SILJA: Are you real? Are you from town? Did Mama send you?",
           "Silja is spindly, with pointy teeth and snow in her long braids.",
           "Her brother works at the brackets that hold the slats, with frostbitten hands. His teeth won't stop chattering.",
           "FINN: The slats won't b-bend. Too cold. And the gate screams if you open it.",
           "FINN: The hinges scream. Then HE comes."], event_id)
      sayc([cl(:alberica, "Hey. Look at me. Big breath, all the way in. There you go. We're getting you out."),
            cl(:shade, "(already looking at the lock) I've opened worse. Give me a minute.")])
    end
    opts = []
    opts << [:gate, flag?(:whale_oil) ? _INTL("Oil the hinges and open the gate.") : _INTL("Haul the gate open.")]
    opts << [:slats, _INTL("Heat the slats and pull two apart.")]
    opts << [:lock, _INTL("Pick the lock.")] if with_or_is?(:shade) && !flag?(:cage_unlocked)
    opts << [:leave, _INTL("Not yet.")]
    c = pbMessage(_INTL("How do you get them out?"), opts.map(&:last), opts.size)
    way = c && c >= 0 ? opts[c][0] : :leave
    case way
    when :leave
      return say(["(Something might quiet those hinges. Something slick... Or something hot, for the slats.)"])
    when :lock
      say([herald?(:shade) ? "You kneel at the lock with your picks. A minute of nothing, then a click." :
                             "Shade kneels at the lock with a set of picks. A minute of nothing, then a click.",
           as(:shade, "Done. Now, the hinges. Those, I can't pick.")])
      set_flag(:cage_unlocked)
      return cage(event_id)
    when :slats
      if !party_has_fire?
        return say(["The metal is so cold it burns your fingers. It won't move a hair.",
                    "(Heat would make the slats pliable. A fire-breathing Pokémon, perhaps.)"])
      end
      say(["Your Pokémon breathes fire along two of the slats until they glow a dull red, and the frost on them hisses away."])
      if !party_has_strength?
        return say(["You haul on the hot slats. They give a little, then stiffen as they cool.",
                    "(Someone stronger is needed, while they're hot. A Pokémon with real strength.)"])
      end
      say(["Your strongest Pokémon braces against the frame and hauls. The slats bend apart with a groan of metal.",
           "Slender Silja wriggles through, then pulls her brother after. The gate never moves. The hinges never make a sound."])
      return free_kids
    when :gate
      if flag?(:whale_oil)
        say(["You work the whale oil into the great rusty hinges, slowly, until they're black and dripping.",
             "The gate swings open without a sound."])
        return free_kids
      end
      if flag?(:norsu_beaten)
        say(["You haul on the gate. The hinges SHRIEK, and the sound fills the whole lodge.",
             "From the tomb comes only a long, tired groan. Norsu doesn't get up."])
        return free_kids
      end
      if !pbConfirmMessage(_INTL("Force the gate open? (The hinges will scream.)"))
        return
      end
      say(["You haul on the gate. The hinges SHRIEK, and the sound fills the whole lodge.",
           "The floor shakes. Something enormous is coming down the passage. Fast.",
           "NORSU: THIEVES! You would rob his tomb too?! I will crush you underfoot!"])
      return if !boss_battle(named_mon(:MAMOSWINE, 28, "Norsu"))
      say(["Norsu crashes against the ice and lies there, breathing hard.",
           "Then he turns, slowly, and drags himself back to his master."])
      set_flag(:norsu_beaten)
      set_flag(:norsu_met)
      $game_switches[SW_NORSU_CALM] = true if $game_switches
      free_kids
    end
  end

  def free_kids
    set_flag(:kids_freed)
    $game_switches[SW_KIDS_FREED] = true if $game_switches
    add_counter(:story_beats)
    say(["Silja is out first, pulling Finn after her. His teeth chatter so hard he can barely speak.",
         "SILJA: The wolves watch the big doors. They always watch the big doors.",
         "SILJA: But there's a tunnel in the oil room. The big worm dug it.",
         "FINN: I c-could've got out myself.",
         "SILJA: He couldn't."])
    sayc([as(:shade, "Stay behind us. All the way home. Whatever happens."),
          cl(:alberica, "And if Finn wants to carry something heroic, he can carry my bag. It's very heroic.")])
  end

  # Coming out of the lodge's east openings with the children: the wolves are
  # right there (L1). Out the remorhaz tunnel, they're not watching, and they
  # have to find you on the way home.
  def lodge_east_exit(event_id = nil)
    return if !flag?(:kids_freed) || flag?(:wolves_beaten) || !flag?(:met_wolves)
    say(["Two white shapes are waiting at the openings, exactly where they said they'd be."])
    wolves_ambush(event_id)
  end

  # Koran and Kanan spring their trap. Kill one, and the other runs.
  def wolves_ambush(event_id = nil)
    return if flag?(:wolves_beaten) || !flag?(:kids_freed)
    say(["Two white shapes rise out of the blizzard ahead of you, side by side.",
         "KANAN: You're bringing back our dinner.",
         "KORAN: (no limp at all) Nothing personal. Norsu was supposed to do this part.",
         "KORAN: The Dale is very hungry. So is he."])
    lv = 0
    lv += 2 if flag?(:caught_koran)
    lv += 2 if $game_switches && $game_switches[SW_HU_BLIZZARD]
    sayc(["(You saw it coming. You're ready before they are.)", cl(:alerion, "Right leg.")]) if flag?(:caught_koran)
    say(["(The throne's blizzard is in their eyes and their noses. They can barely find you.)"]) if $game_switches && $game_switches[SW_HU_BLIZZARD]
    sayc([cl(:reptin, "(to the kids, not looking back) Behind me. Now.")])
    if boss_battle(named_mon(:B503H272, 26 - lv, "Koran"), named_mon(:B272H310, 27 - lv, "Kanan"))
      say(["Kanan yelps and bolts south, toward the chasm.",
           "Koran stands a moment longer, looking at you. Then, alone now, he follows his brother.",
           "SILJA: ...Can we go home now?"])
      set_flag(:wolves_beaten)
      $game_switches[SW_WOLVES_GONE] = true if $game_switches
      set_switch(SW_HU_WOLVES_WAIT, false)
      set_switch(SW_HU_BLIZZARD, false)
      add_counter(:story_beats)
    else
      say(["(Silja and Finn fled back to the ice lodge to hide.)",
           "(Koran and Kanan are still waiting out on the tundra.)"])
    end
  end
end
