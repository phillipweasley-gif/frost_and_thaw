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
#     gives you her husband's boots of the winterlands.
#===============================================================================
module FrostThaw
  SW_HU_WOLVES_WAIT = 4041    # Koran and Kanan are waiting outside the lodge (L1)
  SW_HU_BLIZZARD    = 4042    # the ice throne's blizzard is up around the lodge

  RELIC_ITEMS.merge!(
    FT_WINTERBOOTS: ["Boots of the Winterlands", "Boots of the Winterlands", 8, 0,
      "Fur-lined boots Hilda's husband won in a drinking contest. The warmest boots in the Dale.", 0, 0, 6]
  )

  TEXT.merge!(
    garagai_bedroll: ["The only furniture in this cavernous chamber: a big fur bedroll, matted and musty.",
                      "Garagai slept here. Nobody sleeps here now."],
    lodge_exterior: ["Jutting up out of the tundra: a towering edifice built entirely of ice.",
                     "Three tall openings on its east face. Easily three times the height of anything in Ten-Towns."],
    wolves_wait: ["KORAN: We'll stand guard out here. Garagai isn't home. Go on in.",
                  "KANAN: (not looking at you) Take the corridor in the middle. It's quickest."],
    ice_corridor: ["The passage is choked with ice.", "Icicles hang overhead in clusters, points sharp as daggers."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # Hilda
  #-----------------------------------------------------------------------------
  def hilda(event_id = nil)
    if flag?(:kids_home)
      say(["HILDA: Every time I look at them I have to count. One, two. One, two.",
           "HILDA: Whatever you need from Dougan's Hole, you come to this door first."], event_id)
    elsif flag?(:met_hilda)
      say(["HILDA: The bowls are still on the table. Go on. Please."], event_id)
    else
      set_flag(:met_hilda)
      say(["HILDA: Hilda Dejarr. Silja and Finn are mine. The Speaker says they're gone.",
           "HILDA: They're not. I keep their bowls on the table.",
           "HILDA: If you're going out there... please. Please."], event_id)
      hilda_bowls(event_id)
    end
  end

  def hilda_bowls(event_id = nil)
    return if !with_or_is?(:alberica)
    speak(:alberica, "(taking both her hands) Keep the bowls out. We'll fill them.",
                     "(taking both her hands) ...We'll bring them.", event_id)
  end

  # SC 4.03b - Hilda at the gate (context 04 M4-2): coming out of the Speaker's
  # lodge, the mother is waiting, so the homecoming pays off on someone you've met.
  def scene_hilda_at_gate
    return if flag?(:met_hilda) || flag?(:kids_freed) || !flag?(:met_durmoot)
    set_flag(:met_hilda)
    hilda = begin
      Stage.actor(:hilda, 21, 12, 2, graphic: "BW (56)")
    rescue StandardError
      nil
    end
    say(["A woman in a too-thin shawl is waiting outside the lodge. Bare feet in the snow."])
    Stage.approach(hilda) if hilda
    say(["HILDA: Hilda Dejarr. Silja and Finn are mine. The Speaker says they're gone.",
         "HILDA: They're not. I keep their bowls on the table.",
         "HILDA: If you're going out there... please. Please."])
    hilda_bowls
    Stage.leave(hilda, 21, 11) if hilda
    Stage.cleanup rescue nil
    state[:goal] = "Find Silja and Finn. West, out on the tundra."
  end

  # SC 4.07 - Coming home (context 04 M4-2, M4-4): dusk at the stockade, the
  # children run on ahead, and Hilda is at her own door.
  def scene_kids_homecoming
    return if flag?(:kids_home)
    set_flag(:kids_home)
    $game_switches[SW_KIDS_HOME] = true if $game_switches
    add_counter(:story_beats)
    say(["Dusk, by the time the stockade shows. Finn has stopped talking. Silja hasn't."])
    px, py = $game_player.x, $game_player.y
    silja = (Stage.actor(:silja, px + 1, py, 6, graphic: "BW (17)") rescue nil)
    finn  = (Stage.actor(:finn, px, py + 1, 6, graphic: "BW (16)") rescue nil)
    say(["Silja doesn't wait for anyone. She's off down the street, braids flying, Finn behind."])
    Stage.walk_to(silja, 21, 12, wait_for: false) if silja
    Stage.walk_to(finn, 22, 12, wait_for: false) if finn
    Stage.walk_to($game_player, 19, 13, face: 6)
    hilda = (Stage.actor(:hilda, 21, 11, 2, graphic: "BW (56)") rescue nil)
    Stage.hop(hilda) if hilda
    say(["Hilda runs out barefoot into the snow. She doesn't say anything. She doesn't have to."])
    Stage.leave(silja, 21, 11) if silja
    Stage.leave(finn, 21, 11) if finn
    say(["Through the open door: two bowls on the table. Somebody is already filling them."])
    Stage.approach(hilda) if hilda
    say(["Later, she comes out again with a pair of fur-lined boots.",
         "HILDA: These were my husband's. He won them off an adventurer. Drinking contest.",
         "HILDA: Passed a few years back. Warmest boots in the Dale.",
         "HILDA: Take them. He'd want them walking somewhere."])
    if !($PokemonBag.pbHasItem?(:FT_WINTERBOOTS) rescue false)
      ($PokemonBag.pbStoreItem(:FT_WINTERBOOTS, 1) rescue give_key(:FT_WINTERBOOTS))
      pbMessage(_INTL("\\me[Key item get]You got the Boots of the Winterlands!")) rescue nil
    end
    pbReceiveItem(:REVIVE, 2) rescue nil
    sayc([cl(:meat_meat, "Meat Meat not crying. That is snow."),
          cl(:alberica, "(sniffing loudly) Somebody give me a drink. For the wind.")])
    durmoot = (Stage.actor(:durmoot, 14, 11, 2, graphic: "BWOldWoman") rescue nil)
    Stage.pan_to(14, 10)
    say(["DURMOOT: (from her door, after a while) ...Lodge. Now. I said I'd fight you myself."])
    Stage.pan_back
    Stage.cleanup rescue nil
    state[:goal] = "Speaker Durmoot's lodge. She'll fight you for her seal."
  end

  #-----------------------------------------------------------------------------
  # Good wolf, bad wolf (RotF p. 54)
  #-----------------------------------------------------------------------------
  # SC 4.04 - The limping wolf
  def koran(event_id = nil)
    kor = (event_id && $game_map ? $game_map.events[event_id] : nil) rescue nil
    limp_up(kor)                             # he limps up to you on screen (notes 04 E9)
    say(["A white wolf the size of a pony limps out of the snow, whimpering like a kicked dog.",
         "KORAN: Please. Please, travellers. I'm Koran. My master did this. Garagai. A frost giant.",
         "KORAN: Mean old Garagai. He kicks me. He kicks me every day."], event_id)
    sayc([cl(:reptin, "(under his breath) Every day. Poor lamb.")], event_id)
    say(["KORAN: He took two of the little townsfolk. He keeps them in his lodge, west.",
         "KORAN: Help me free them. Let him feel what it's like to lose something."], event_id)
    choice = pbMessage(_INTL("What do you do?"),
                       [_INTL("\"Show us.\""), _INTL("\"Which leg was it, again?\""), _INTL("\"No.\"")], 0)
    if choice == 1
      Stage.hop(kor) if kor
      sayc(["Koran blinks. He was limping on the left leg. Now he's limping on the right.",
            cl(:shade, "Ha! Oh, I like this one. Terrible liar. Great coat."),
            cl(:alerion, "Liars forget which leg."),
            "KORAN: ...Clever. Follow anyway. The children are real, even if my limp isn't."])
      set_flag(:caught_koran)
    elsif choice == 2
      bad_wolf
    else
      sayc(["KORAN: This way. This way. Quickly, before the snow fills my tracks.",
            cl(:reptin, "(quietly) There's two of them. I can smell the other one."),
            cl(:meat_meat, "Meat Meat will walk next to the doggy. Close. Very friendly.")])
      set_flag(:followed_koran)
    end
    if !flag?(:refused_wolves)
      say(["Koran trots off west. Something else white trots after him, just out of sight."])
    end
    Stage.leave(kor, [kor.x - 4, 1].max, kor.y) if kor
    set_flag(:met_wolves)
    set_switch(SW_HU_WOLVES_WAIT, true)
    set_self_switch(event_id, "A")
    state[:goal] = "Follow the wolves' tracks west across the tundra, to Garagai's lodge."
  end

  # Koran comes up to you a step and a stop at a time: the limp you're meant to see.
  def limp_up(kor)
    return if !kor
    dirs = Stage.path_for(kor, $game_player.x, $game_player.y, adjacent: true)
    Stage.turn_to(kor)
    if !dirs || dirs.empty?             # (you walked right up to him: he limps back a step, and forward)
      Stage.walk(kor, [13, 15, 10, 12, 15, 10])
    else
      Stage.walk(kor, dirs.flat_map { |d| [Stage::MOVE[d], 15, 7] })
    end
    Stage.turn_to(kor)
    Stage.turn_to($game_player, kor)
  end

  # Kanan steps out to play the bad wolf; then both appeal to your conscience.
  def bad_wolf
    say(["A second white wolf rises out of a drift you'd have sworn was empty.",
         "KANAN: Kanan. My brother asked you nicely.",
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
    set_flag(:kanan_named)
    sayc([as(:alerion, "No."),
          cl(:meat_meat, "Meat Meat bites back. Meat Meat is very bitey."),
          "The wolves look at each other. Then the act drops, all at once.",
          "KORAN: It's awfully cold in that lodge.",
          "KANAN: They won't suffer much longer. It's only a matter of time before Garagai skins them and eats them.",
          "They bolt away west, leaving tracks a child could follow.",
          cl(:shade, "...And we're going to follow them. Aren't we.")])
    set_flag(:refused_wolves)
  end

  def scene_tundra_start
    # RotF: the blizzard on the crossing (DH10); wolves walking with you take its edge off.
    shield = flag?(:followed_koran) && !flag?(:refused_wolves)
    sayc(["West of Dougan's Hole, everything is white. The blizzard comes in sideways.",
          shield ? "Koran and a second white wolf fall in on the windward side, taking the worst of it." :
          flag?(:met_wolves) ? "The wolves' tracks run ahead, west, filling with snow almost as fast as you find them." :
                               "Under the drifts there are tracks: two wolves, enormous ones, heading west.",
          shield ? cl(:reptin, "(quietly) Very thoughtful of them. Suspiciously thoughtful.") : nil,
          cl(:shade, "Thirteen miles of this. Wonderful."),
          cl(:alberica, "Think of it as a long, cold walk with excellent company."),
          cl(:shade, "I am. That's the problem.")].compact)
    if shield
      say(["Half a mile on, the wolves lope ahead into the white.",
           "\"We'll go first,\" Koran calls back. \"Make sure the way's clear.\""])
    else
      say(["The wind finds every gap in your furs. By the time the snow eases, everyone is numb, Pokémon included."])
      $Trainer.party.each { |pk| pk.hp = [pk.hp - (pk.totalhp / 10), 1].max if !pk.egg? && pk.hp > 0 } rescue nil
    end
  end

  # The pack comes into view across the whole width of the tundra: you can't
  # walk round it (the campaign's bite is the root of Reptin's curse).
  def starving_pack_sighted(event_id = nil)
    return if ($game_switches && $game_switches[SW_PACK_GONE]) || flag?(:reptin_bitten)
    say(["Shapes rise out of the snow ahead, low and slow: four wolves, all ribs and eyes."])
    starving_pack(event_id)
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
            cl(:meat_meat, "Meat Meat gives the jerky. Not the coffee. Wolves don't deserve the beans.")])
      set_flag(:fed_pack)
      wheel(1)
    else
      say([me ? "(We need that food. You know. You share your own anyway.)" : "You put a hand on his arm. \"We need that food.\"",
           me ? nil : "REPTIN: I know. I'm sorry.",
           me ? nil : "He shares his own anyway."].compact)
      set_flag(:fed_pack_reptin_only)
    end
    # the bite, staged (context 04 M4-3): Reptin kneels, the she-wolf comes to him
    wolves = ($game_map.events.values.select { |e| e.name == "Starving wolf" && !e.character_name.to_s.empty? } rescue [])
    she = wolves.find { |e| e.character_name.to_s.include?("MIGHTYENA") } || wolves.first
    rep_ev = stand_in(:reptin, 0, -1, 2)
    Stage.pose(rep_ev, "P-REP-01", 3, per: 7) if rep_ev
    say(["The pack eats. One lean she-wolf comes close enough to touch."])
    Stage.walk_to(she, rep_ev.x, rep_ev.y, adjacent: true) if she && rep_ev
    Stage.turn_to(she, rep_ev) if she && rep_ev
    say([me ? "You reach out, and she bites: fast, deep, then gone." : "Reptin reaches out, and she bites: fast, deep, then gone."])
    Stage.cry(:MIGHTYENA)
    $game_screen.start_flash(Color.new(255, 255, 255, 150), 8) rescue nil
    $game_screen.start_shake(3, 8, 8) rescue nil
    wolves.each { |w| Stage.leave(w, [w.x - 12, 0].max, w.y) }
    speak(:reptin, "Fair. I'd bite me too. I'm very bitable.", "...Fair. I'd bite me too.")
    sayc(["The bite doesn't bleed. It burns like fire under snow.",
          cl(:alberica, "Let me see that, sweetheart."),
          as(:reptin, "I'm fine. Don't look at it. I'm fine."),
          cl(:meat_meat, "Wolf bite. Full moon comes, bite wakes up. Everybody knows that story.")])
    if me
      speak(:reptin, "Then I'll stay indoors at the full moon. Problem solved.", "...Then I'll stay in.")
    else
      sayc([cl(:reptin, "Then I'll stay indoors at the full moon. Problem solved.")])
    end
    if with_or_is?(:alerion)
      sayc([as(:alerion, "When is it?"),
            me ? "Not looking at your hand. (Soon.)" : "REPTIN: (not looking at his hand) Soon."])
    end
    Stage.cleanup rescue nil
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
    say(["Two white wolves sit in the snow before the lodge, as if they've been there for hours.",
         "KORAN: (sniffing the air, nose high) He's not home. Garagai. Out hunting whales.",
         flag?(:kanan_named) ? "KANAN: We'll stand guard out here. In case he comes back." :
                               "KORAN: My brother Kanan and I will stand guard. In case he comes back.",
         "KORAN: Go in by the corridor. The middle one. It's quickest to the children."])
    set_flag(:kanan_named)
    sayc([cl(:reptin, "(pleasantly) How thoughtful. And you won't come in yourselves?"),
          "KANAN: ...Wolves don't like ice houses.",
          cl(:shade, "(under their breath) Somebody's home."),
          cl(:alerion, "They won't go in."),
          cl(:shade, "Or they're waiting to see what's left of us.")])
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
    sayc(["Inside, the ice walls rise thirty feet. Everything here was built for giants.",
          "From deeper in comes a sound like a bellows: something enormous, breathing slowly.",
          "And under it, very faintly, a child coughing.",
          cl(:reptin, "Quiet."),
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
    # on camera, turning, angry (notes 04 E21)
    nu = Stage.find("Norsu")
    Stage.pan_to((nu.x + $game_player.x) / 2, (nu.y + $game_player.y) / 2) if nu && !Stage.on_screen?(nu)
    say(["An oval chamber with high walls of glittering ice, like a sepulchre.",
         "The frozen, hacked-up corpse of a frost giant lies on the floor, entombed in clear ice.",
         "Standing over it: a woolly mammoth."])
    Stage.turn_to(nu) if nu
    Stage.cry(:MAMOSWINE)
    say(["It turns, and it stares down at you with hate in its eyes.",
         "Something long ago taught this beast to think, and to grieve out loud."])
    Stage.emote(nu, :angry) if nu
    say(["NORSU: You are to blame for all of this!",
         "NORSU: Small ones killed him. Small ones took his axe, his breath. Small ones will pay.",
         "NORSU: The wolves bring me the town's food and gold. Soon they'll bring me the town."])
    choice = pbMessage(_INTL("What do you say?"),
                       [_INTL("\"We were his friends.\""), _INTL("\"We'll find who took the axe.\""), _INTL("Stand your ground")], -1)
    case choice
    when 0
      say(["NORSU: ...Friends. Garagai had friends. Giants, who sat at his table. Never small ones.",
           "NORSU: But you came to his tomb. His friends never came to his tomb.",
           "The mammoth's head lowers, slowly. (It believed you. Mostly.)"])
      calm_norsu
    when 1
      say(["NORSU: Find them? Small ones never come back for the dead. Not once.",
           "NORSU: ...Swear it. On his ice."])
      speak(:reptin, "I swear it. It comes back to him.", "...I swear it.")
      sayc([cl(:meat_meat, "Meat Meat swears too. Meat Meat bites whoever took it."),
            "The mammoth lowers his head."])
      set_flag(:garagai_vow)
      calm_norsu
    else
      Stage.cry(:MAMOSWINE)
      say(["Norsu lowers his tusks and charges!"])
      if boss_battle(named_mon(:MAMOSWINE, 28, "Norsu"))
        say(["Norsu staggers, groans, and sinks down beside his master. He doesn't get up.",
             "NORSU: ...Take what you came for. Leave us be."])
        set_flag(:norsu_beaten)
        set_flag(:norsu_met)
        $game_switches[SW_NORSU_CALM] = true if $game_switches
      end
      Stage.pan_back
    end
  end

  def calm_norsu
    say(["NORSU: Honour him, then. A prayer, or a gift. And then go, and let me mourn."])
    c = pbMessage(_INTL("Honour Garagai?"), [_INTL("Say a prayer over him."), _INTL("Leave a gift."), _INTL("Just go.")], 0)
    if c == 0
      sayc(["You say what you can about someone you never met.",
            cl(:alberica, "He kept a whale in his kitchen and a mammoth who loved him. That's a good life."),
            "Norsu listens to every word."])
    elsif c == 1
      sayc(["You leave something small on the ice over his chest. Norsu looks at it for a long time.",
            cl(:reptin, "(quietly) Grief takes gifts it'll never use. That's rather the point.")])
    end
    set_flag(:norsu_calmed)
    set_flag(:norsu_met)
    $game_switches[SW_NORSU_CALM] = true if $game_switches
    Stage.pan_back
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
    say(["Three kobolds, white-scaled lizard folk no bigger than children, cower behind the chairs.",
         "HOLGI: Don't hurt! We not mean to kill the little spirit! It jump at us! Now it stone!",
         "SNORP: We think house empty! House not empty! House have BIG HAIRY ANGRY!",
         "ZILBO: Wolves outside! Wolves everywhere! Help us get out? We very small. Very sorry."], event_id)
    sayc([cl(:meat_meat, "Little lizards! Meat Meat will not bite. Meat Meat promises."),
          cl(:reptin, "She's never promised that before. You should feel honoured.")])
    if pbConfirmMessage(_INTL("Help the kobolds escape?"))
      say(["You keep watch on the passage while they creep out, toward the oil store.",
           "At the door they bow, until their snouts touch the ice.",
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
      say(["A huge slatted cage stands against the wall. Garagai built it for Norsu, as a calf.",
           "Its gate hangs on rusty hinges as big as your head.",
           "Inside, two shivering teenagers look out at you.",
           "SILJA: Are you real? Are you from town? Did Mama send you?",
           "Silja is spindly, with pointy teeth and snow in her long braids.",
           "Her brother works at the brackets that hold the slats, with frostbitten hands.",
           "His teeth won't stop chattering.",
           "FINN: The slats won't b-bend. Too cold. And the gate screams if you open it.",
           "FINN: The hinges scream. Then HE comes."], event_id)
      sayc([cl(:alberica, "Hey. Look at me. Big breath, all the way in. There you go. We'll get you out."),
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
      say(["Your strongest Pokémon braces against the frame and hauls.", "The slats bend apart with a groan of metal.",
           "Slender Silja wriggles through, then pulls her brother after. The gate never moves. The hinges never make a sound."])
      return free_kids
    when :gate
      if flag?(:whale_oil)
        say(["You work the whale oil into the rusty hinges, slowly, until they're black and dripping.",
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
    $game_map.need_refresh = true if $game_map
    add_counter(:story_beats)
    # they walk out of the cage and come to you (context 04 M4-4)
    at = lambda do |name, fx, fy|
      e = ($game_map.events.values.find { |ev| ev.name == name } rescue nil)
      e ? [e.x, e.y] : [fx, fy]
    end
    sx, sy = at.("Silja", 6, 5)
    fx, fy = at.("Finn", 7, 5)
    silja = (Stage.actor(:silja, sx, sy, 2, graphic: "BW (17)") rescue nil)
    finn  = (Stage.actor(:finn, fx, fy, 2, graphic: "BW (16)") rescue nil)
    Stage.wait(2) rescue nil
    Stage.walk_to(silja, $game_player.x, $game_player.y, adjacent: true) if silja
    Stage.turn_to(silja) if silja
    Stage.walk_to(finn, silja.x, silja.y, adjacent: true) if finn && silja
    Stage.turn_to(finn) if finn
    say(["Silja is out first, pulling Finn after her. His teeth chatter so hard he can barely speak.",
         "SILJA: The wolves watch the big doors. They always watch the big doors.",
         flag?(:kobolds_freed) ? "SILJA: There's a tunnel in the oil room. The lizards went out that way." :
                                 "SILJA: But there's a tunnel in the oil room. The big worm dug it.",
         "FINN: I c-could've got out myself.",
         "SILJA: He couldn't."])
    sayc([cl(:shade, "Walk where I walk. All the way home."),
          cl(:alberica, "And if Finn wants to carry something heroic, he can carry my bag. Very heroic.")])
    Stage.cleanup rescue nil
    state[:goal] = "Take Silja and Finn home, east across the tundra."
  end

  # Silja and Finn, standing behind you (the way you came) while the wolves come.
  def kids_behind_you
    d = { 2 => [0, -1], 4 => [1, 0], 6 => [-1, 0], 8 => [0, 1] }[$game_player.direction] || [0, 1]
    px, py = $game_player.x, $game_player.y
    [Stage.actor(:silja, px + d[0], py + d[1], $game_player.direction, graphic: "BW (17)"),
     Stage.actor(:finn, px + d[0] * 2, py + d[1] * 2, $game_player.direction, graphic: "BW (16)")]
  rescue StandardError
    []
  end

  # Coming out of the lodge's east openings with the children: the wolves are
  # right there (L1). Out the remorhaz tunnel, they're not watching, and they
  # have to find you on the way home.
  def lodge_east_exit(event_id = nil)
    return if !flag?(:kids_freed) || flag?(:wolves_beaten) || !flag?(:met_wolves)
    say(["Two white shapes are waiting at the openings, exactly where they said they'd be."])
    wolves_ambush(event_id, true)
  end

  # Koran and Kanan spring their trap. Kill one, and the other runs.
  def wolves_ambush(event_id = nil, waiting = false)
    return if flag?(:wolves_beaten) || !flag?(:kids_freed)
    kids_behind_you
    say([waiting ? "They don't wait to be asked. Side by side, they come at you." :
                   "Two white shapes rise out of the blizzard ahead of you, side by side.",
         "KANAN: You're bringing back our dinner.",
         "KORAN: (no limp at all) Nothing personal. Norsu was supposed to do this part.",
         "KORAN: The Dale is very hungry. So are we."])
    lv = 0
    lv += 2 if flag?(:caught_koran)
    lv += 2 if $game_switches && $game_switches[SW_HU_BLIZZARD]
    sayc(["(You saw it coming. You're ready before they are.)", cl(:alerion, "Right leg.")]) if flag?(:caught_koran)
    say(["(The throne's blizzard is in their eyes and their noses. They can barely find you.)"]) if $game_switches && $game_switches[SW_HU_BLIZZARD]
    sayc([cl(:reptin, "(to the kids, not looking back) Behind me. Now.")])
    if boss_battle(named_mon(:B503H272, 26 - lv, "Koran"), named_mon(:B272H310, 27 - lv, "Kanan"))
      kids_behind_you if Stage.find("stage_silja").nil? rescue nil
      wolves = ($game_map.events.values.select { |e| %w[Koran Kanan].include?(e.name) && !e.character_name.to_s.empty? } rescue [])
      say(["Kanan yelps and bolts south, toward the chasm."])
      wolves.each { |w| Stage.leave(w, w.x, [w.y + 10, $game_map.height - 1].min) }
      say(["Koran stands a moment longer, looking at you. Then, alone now, he follows his brother."])
      sayc([cl(:shade, "South. Toward the laughing."),
            "SILJA: They talked to someone at night. Down through the ice. She laughed at everything.",
            "SILJA: ...Can we go home now?"])
      Stage.cleanup rescue nil
      state[:goal] = "Take Silja and Finn home, east across the tundra."
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
