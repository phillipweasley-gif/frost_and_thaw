#===============================================================================
# Frost & Thaw - Act III, Chapter 12: The Sea of Moving Ice (script SC 12.01-12.06)
#
# Reach Solstice and get inside Grimskalle.
#
#   12.01 One more battle: Tamsin, at your departure point
#   12.02 Fog and masts: the voyage (ship, griffons, whale, or Lumin's bell)
#   2079  Solstice: the ice dock (12.03, Sopo) and the climb to the skull
#   2080  The Statue Fields (12.04): cross without touching a statue
#   2081  The Garden of Death (12.05): the ice troll; Nass and Professor Skant
#   2082  The Grimskalle Gate (12.06): Ukuma on his rink
#===============================================================================
module FrostThaw
  SW_DOCK_CLEARED = 3996
  SW_TROLL_DOWN   = 3997
  SW_FIELDS_ROPE  = 3906   # the Statue Fields are crossed: a rope back up from the entrance
  SW_UKUMA_RACED  = 3998

  MAPS.merge!(solstice: 2079, statue_fields: 2080, garden_of_death: 2081, grimskalle_gate: 2082)
  MAP_NAMES.merge!(2079 => "Solstice", 2080 => "The Statue Fields", 2081 => "The Garden of Death", 2082 => "The Grimskalle Gate")
  MAP_METADATA.merge!(
    2079 => { outdoor_map: true, announce_location: true, battle_environment: :Snow, weather: [:Snow, 100] },
    2080 => { announce_location: true, battle_environment: :Ice },
    2081 => { announce_location: true, battle_environment: :Ice },
    2082 => { announce_location: true, battle_environment: :Ice }
  )
  AREAS.merge!(2079 => :solstice, 2080 => :solstice, 2081 => :solstice, 2082 => :solstice)
  SOLSTICE_DOCK = [2079, 19, 56, 8]

  ENCOUNTERS[2079] = { step_chances: { Land: 10 },
                       Land: [[25, :SNEASEL, 56, 58], [20, :PILOSWINE, 56, 58], [20, :DELIBIRD, 56, 58],
                              [15, :GLALIE, 57, 59], [10, :WEAVILE, 58, 60], [10, :MAMOSWINE, 58, 60]] }
  ENCOUNTERS[2081] = { step_chances: { Cave: 8 },
                       Cave: [[30, :HAUNTER, 57, 59], [25, :DUSCLOPS, 57, 59], [20, :SNEASEL, 57, 59],
                              [15, :GLALIE, 58, 60], [10, :MISDREAVUS, 58, 60]] }

  TRAINER_TYPES.merge!(FT_MEPHIT: ["Ice Mephit", :CHANNELER, 0, 100])
  TRAINERS.merge!(
    sopo: [:FT_MEPHIT, "Sopo", [[:SNORUNT, 56], [:GLALIE, 57], [:B427H215, 57], [:B428H124, 59]],
           "No, no, no! You were supposed to fall into a hole!"]
  )
  TRAINER_INTROS.merge!(sopo: "SOPO: Visitors! I'm a guide. I guide people into holes, mostly!")

  TEXT.merge!(
    ice_statue: ["An ice sculpture, too perfect for any hand.",
                 "Every whisker. Every feather. Every scale. Don't touch it."],
    garden_block: ["Someone sealed upright in a block of clear ice.", "Their eyes are open."],
    ukuma_after: ["UKUMA: (sliding past) Guarding! Still guarding. Very, very busy."],
    sopo_after: ["SOPO: (from a safe distance, giggling) She's expecting you! She's expecting EVERYONE!"],
    grimskalle_jaw: ["The skull's jaw is a gate, and the gate stands open.",
                     "Cold breathes out of it, like a breath someone has held for a very long time."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # SC 12.01 - One more battle (at the departure point)
  #-----------------------------------------------------------------------------
  def departure(where, event_id = nil)
    if !flag?(:ch11_done)
      return say(["(Not yet. Not until everyone's ready.)"], event_id)
    end
    if voyage_route != where && !(where == :whale && voyage_route == :bell)
      return say([{ ship: "The Boreal Requiem rides at her moorings. Nobody aboard is going anywhere today.",
                    griffons: "The griffon roost is quiet. The griffons look at you like you're lunch.",
                    whale: "The Wennen bell hangs over the black water, silent." }[where]], event_id)
    end
    tamsin_final if !flag?(:rival_final)
    return if !flag?(:rival_final)
    return if !pbConfirmMessage(_INTL("Set out for Solstice?"))
    voyage
  end

  # A Herald's line where someone answers it: theirs if they're with you, your
  # own words (you pick how to say them) if you are them, nothing if they're
  # not here (WRITING_GUIDE §5).
  def cline(key, loud, quiet = nil)
    return if !with_or_is?(key)
    herald?(key) ? speak(key, loud, quiet) : say([as(key, loud)])
  end

  # The rival's send-off (context 12 M12-4): Tamsin runs in to square up one
  # last time and owns up to knowing you're the sixth figure; Hellen walks in
  # with the food the Tests will use. Both on screen, both walk off.
  def tamsin_final
    px, py = $game_player.x, $game_player.y
    Stage.theme(:tamsin)
    tam = Stage.actor(:tamsin, px + 4, py, 4)
    if tam
      Stage.walk_to(tam, px + 3, py, face: 4)     # (past the tiles companions walk in to)
      Stage.turn_to($game_player, tam)
      Stage.emote(tam, :exclaim)
    end
    sayc(["TAMSIN: (cloak on crooked, planting their feet) Hold it. HOLD it, #{player_display_name}!",
          "TAMSIN: You're going to fight a GOD. With THAT team? Not without one more battle first."])
    cline(:alberica, "Look at them. All grown up and threatening people. I could cry.", "...Look at them. All grown up.")
    sayc([cl(:reptin, "They mean they'll miss us. That's how Tamsin says it."),
          "TAMSIN: I mean I'll WIN."])
    if outsider?
      say([herald?(:wyn) ? "TAMSIN: Also. Hellen's wall. The sixth figure. It's got a Sableye on its boot." :
                           "TAMSIN: Also. Hellen's wall. The sixth figure, the small one with no face.",
           herald?(:wyn) ? "TAMSIN: I've known since you came back with them. I just wanted you to say it." :
                           "TAMSIN: I've known since you fell out of the lantern. I just wanted you to say it."])
      c = pbMessage(_INTL("The sixth figure..."), [_INTL("Nod"), _INTL("Say nothing")], 0)
      if c == 0
        say(["TAMSIN: ...I KNEW it. I knew it, I knew it, I KNEW it."]); set_flag(:told_tamsin)
      else
        say(["TAMSIN: Fine. Be mysterious. You're still on my wall."])
      end
    end
    mine = state[:starter]
    ace = { B7H220: :B330H152, B330H152: :WICKIT, WICKIT: :B7H220 }[mine] || :B330H152
    ace_final = { B330H152: :B331H154, WICKIT: :FORGEL, B7H220: :B9H221 }[ace] || ace
    key = [:FT_TAMSIN_I, "Tamsin", 2]
    mons = [{ species: :FURRET, level: 58 }, { species: :JUMPLUFF, level: 58 }, { species: :B184H241, level: 59 },
            { species: :B38H128, level: 59 }, { species: :B149H143, level: 59 }, { species: ace_final, level: 60 }]
    GameData::Trainer::DATA[key] = GameData::Trainer.new({ id: key, id_number: 9893, trainer_type: :FT_TAMSIN_I, name: "Tamsin",
                                                           version: 2, items: [:FULLRESTORE], lose_text: "Okay. Okay! You can go.", pokemon: mons })
    # (a send-off, not a wall: win or lose, she lets you go)
    won = pbTrainerBattle(:FT_TAMSIN_I, "Tamsin", nil, false, 2, true) ? true : false
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_flag(:rival_final)
    set_flag(:beat_tamsin_final) if won
    add_counter(:story_beats)
    if won
      say(["TAMSIN: (after) Okay. Okay! You can go.",
           "TAMSIN: Come back and tell me everything. Every single thing. In order."])
    else
      say(["TAMSIN: (after, very quietly) ...Huh. I didn't think I'd actually win.",
           "TAMSIN: That's worse. That's so much worse. Train on the way. Please."])
    end
    sayc([cl(:meat_meat, "Meat Meat will train. Meat Meat will train SO hard. After coffee."),
          cl(:alerion, "You said that last time.")])
    hel = Stage.actor(:hellen, px + 5, py + 1, 4)
    Stage.walk_to(hel, px + 3, py + 1, face: 4) if hel
    sayc(["HELLEN: (packing food into every bag you own) Nobody saves the Dale on an empty stomach.",
          "HELLEN: Eat first. Then heroics.",
          outsider? ? "HELLEN: (to the Heralds) And bring them back. I've only just got you on the right wall." :
                      "HELLEN: (to all of you) And come back. I've only just got you on the right wall.",
          cl(:wyn, "...Um. I packed blankets. Extra ones. For after.")])
    give(:FULLRESTORE, 3) rescue nil
    Stage.leave_all([tam, hel].compact, px + 6, py)
    Stage.theme(nil)
  end

  #-----------------------------------------------------------------------------
  # SC 12.02 - Fog and masts: the crossing (context 12 M12-3). The Sea of
  # Moving Ice is seen; two days pass; Razzilith keeps pace (he lands at the
  # throne); the Wall behind you is your own reason to go; and the owl feather
  # wakes as she looks up. Ends on Solstice, with Grimskalle named.
  #-----------------------------------------------------------------------------
  # Whoever carries you north, standing by at the departure point so their lines
  # have a face (Mira has her own event on the Root-Tier).
  def voyage_guide(route)
    px, py = $game_player.x, $game_player.y
    case route
    when :griffons
      roost = stage_event("Griffon roost")
      x, y = roost ? [roost.x + 1, roost.y] : [px + 1, py]
      flag?(:council_rheven) ? Stage.actor(:rheven, x, y, 8, graphic: "BW (72)") :
                               Stage.actor(:kethan, x, y, 8, graphic: "BW (98)")
    when :whale, :bell
      bell = stage_event("Wennen bell")
      x, y = bell ? [bell.x, bell.y - 2] : [px, py - 2]
      Stage.actor(:angajuk, x, y, 2, graphic: "Followers/WAILORD")
    end
  rescue StandardError
    nil
  end

  # The guide's name in their line tag, and what Reptin calls them.
  def voyage_guide_tag(route)
    case route
    when :griffons then flag?(:council_rheven) ? "RHEVEN" : "KETHAN"
    when :ship then flag?(:mira_left_possessed) ? "FIRST MATE" : "MIRA"
    else "ANGAJUK"
    end
  end

  def voyage_crossing(route)
    tag = voyage_guide_tag(route)
    say([{ griffons: "Below: the Sea of Moving Ice. Floes the size of towns, grinding past each other.",
           ship: "Round the hull: the Sea of Moving Ice. Floes the size of towns, grinding past each other." }[route] ||
           "Round Angajuk: the Sea of Moving Ice. Floes the size of towns, grinding past each other.",
         "Behind you, the Auroral Wall rings Rootspire like a curtain. From out here, it's thin."])
    # the Wall is why you go (context 12 §2 adhesive; your own goal, Ch6)
    if herald?(:wyn)
      say(["(Your post's in there. Sableye's in there. And it's all inside a wall.)"])
    elsif !journey?
      say(["(Out here it's your Dale again, still frozen. Bring her winter round, and the Wall falls.)"])
    elsif flag?(:promised_their_time) && with_or_is?(:reptin)
      say(["REPTIN: (to you) Bring her winter round, and that falls. Your promise."])
    elsif with_or_is?(:alerion)
      say(["ALERION: (to you) Turn the wheel and that comes down. Remember that."])
    end
    say([{ griffons: "Above the clouds a green shape keeps pace: Razzilith, too big to ride a griffon's wake.",
           ship: "Above the masts a green shape keeps pace: Razzilith, too big for any deck." }[route] ||
           "Above you a green shape keeps pace: Razzilith, too big for any boat."])
    sayc([cl(:meat_meat, "Razzy follows. Razzy is not allowed to land first. Meat Meat SAID.")])
    cline(:alerion, "(a hand to the heart) North. A little east. She's beating louder.", "(a hand to the heart) ...That way.")
    if with_or_is?(:alerion) && with_or_is?(:reptin)
      who = { "RHEVEN" => "Captain", "MIRA" => "Captain", "KETHAN" => "Kethan", "FIRST MATE" => "mate" }[tag] || "old one"
      sayc([cl(:reptin, herald?(:alerion) ? "Our Dragoon steers by heartbeat, #{who}. Do keep up." :
                                            "He's steering by his dragon's heart, #{who}. Do keep up.")])
    end
    # the second day (a fade marks the time)
    pbFadeOutIn { $game_screen.start_tone_change(Tone.new(-10, -5, 10, 90), 0) rescue nil } rescue nil
    say(["The second day."])
  end

  def voyage
    route = voyage_route
    guide = voyage_guide(route)
    Stage.turn_to($game_player, guide) if guide
    say(["#{voyage_guide_tag(route).capitalize} whistles, and the griffons crouch for you to climb on."]) if route == :griffons
    pbFadeOutIn { $game_screen.start_tone_change(Tone.new(30, 40, 70, 40), 0) rescue nil } rescue nil
    case voyage_route
    when :ship
      paid = flag?(:council_mira) ? nil : flag?(:council_heralds) ? "the Council's warrant" : "Darrus Fell's coin"
      if flag?(:mira_left_possessed)
        # (F3's branch: Mira was left possessed; her first mate sails the Requiem)
        say(["The Boreal Requiem noses through the pack ice#{paid ? ", on #{paid}" : ''}.",
             "FIRST MATE: (at the wheel) Captain's below, talking to the mirrors again. I've got the ship.",
             "FIRST MATE: If you hear singing, that's the ice. If you hear laughing, don't go below."])
      else
        say(["The Boreal Requiem noses through the pack ice#{paid ? ", on #{paid}" : ''}.",
             paid ? "MIRA: (at the wheel) No chair on the Council for me. Still the Requiem's captain, though. Somebody has to be." : nil,
             "MIRA: If you hear singing, that's the ice. If you hear laughing, that's me.",
             "MIRA: Don't worry about either."].compact)
      end
      if flag?(:darrus_redeemed)
        say(["Down in the hold, a tiefling in a Corsair's coat is counting barrels. Twice.",
             "DARRUS: (not looking up) Every one paid for. Go on. Somebody has to keep count."])
      end
    when :griffons
      say(["Griffons, beating hard over a white sea.",
           flag?(:council_rheven) ? "RHEVEN: Don't look down. ...No. Actually, do. You'll never see anything like it again." :
                                    "KETHAN: (on the lead griffon) Don't look down. ...No. Do. Skytower's never flown this far north."])
    else
      if voyage_route == :bell
        say(["Nobody you elected has a ship, or a griffon, or a whale.",
             "Lumin rings Angajuk's bell anyway. With both paws. Very hard."])
      end
      say(["A whale two hundred years old rises under the bell pier, a boat strapped to his back.",
           "ANGAJUK: Climb on, small ones. I know her island. She took my eye."])
      if voyage_route == :bell
        say(["It's a long way, and the sea has teeth."])
        boss_battle(named_mon(:WALREIN, 57, "Walrein")) rescue nil
        boss_battle(named_mon(:CLOYSTER, 58, "Cloyster")) rescue nil
        pbFadeOutIn { $Trainer.heal_party } rescue nil
      end
    end
    voyage_crossing(route)
    say(["Fog comes down. The masts of sunken ships stand up out of it like dead trees."])
    rail = { griffons: "looking down past the wing", ship: "at the rail" }[route] || "looking down into the water"
    speak(:alerion, "(#{rail}) Every one of those was somebody.", "(#{rail}) ...So many.")
    if with_or_is?(:reptin) && !herald?(:alerion)
      sayc([cl(:reptin, "He means: be careful."), "ALERION: I meant what I said."])
    end
    if outsider? && has_key?(:FT_OWLFEATHER)
      say(["In your pack, the owl feather stiffens with frost, as if something looked up."])
    end
    Stage.theme(nil) rescue nil
    say(["The fog parts. An island of ice, shaped like a snowflake. Six jagged arms.",
         "On it, a mountain carved into a giant skull, wearing a crown."])
    # Grimskalle, joined to the skull (Eirwen's plans named it at the Council)
    stair = flag?(:council_eirwen) ? " Eirwen's servants' stair is round the back." : " She moved in."
    say([{ "RHEVEN" => "RHEVEN: Grimskalle. The giants' old fortress.#{stair}",
           "KETHAN" => "KETHAN: Grimskalle. The giants' old fortress.#{stair}",
           "MIRA" => "MIRA: Grimskalle. Giants built it. She moved in.",
           "FIRST MATE" => "FIRST MATE: Grimskalle, that is. Giants built it. Now it's hers." }[voyage_guide_tag(route)] ||
           "ANGAJUK: Grimskalle. She sat on it the day she took my eye."])
    sayc([cl(:meat_meat, "Meat Meat does not like the skull. The skull is showing off.")])
    speak(:alberica, "(the rune glowing) She knows we're here. She's been counting the wingbeats.",
          "(the rune glowing) ...Something's pulling me north. Don't make a thing of it.")
    sayc([cl(:reptin, "We noticed. You've been glowing since breakfast. It's very festive.")])
    set_flag(:solstice_sighted)
    add_counter(:story_beats)
    state[:goal] = "Solstice. Grimskalle, the crowned skull: Frostina is at the top."
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 0) rescue nil
    set_rest_at(SOLSTICE_DOCK)
    transfer(*SOLSTICE_DOCK)
  end

  # The camp on the dock: whatever brought you here waits. Rest, or go home for a while.
  def solstice_camp(event_id = nil)
    who = { ship: "The Boreal Requiem is tied up at the giants' dock, a stove going in the galley.",
            griffons: "The griffons have dug a hollow in the snow and are asleep in a heap.",
            whale: "Angajuk floats at the end of the dock, his boat still strapped to his back.",
            bell: "Angajuk floats at the end of the dock, his boat still strapped to his back." }[voyage_route]
    say([who], event_id)
    c = pbMessage(_INTL("What now?"), [_INTL("Rest"), _INTL("Go back to the Dale"), _INTL("Stay")], 2)
    if c == 0
      pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
      set_rest_at(SOLSTICE_DOCK)
      say(["You sleep a few hours out of the wind. Your Pokémon are rested."])
      solstice_camp_banter
    elsif c == 1
      say(["Back across the sea of moving ice.",
           "Rootspire will still be there when you come back. So will Solstice."])
      set_rest_at(HEARTH_REST)
      transfer(*HEARTH_REST)
    end
  end

  # The night on the giants' dock (context 12 M12-6), the last rest before the
  # end. Reptin said they'd decide on the way what to do with Auril: here they
  # do, each Herald taking a side and its cost, and you take one too (13.10
  # reads it back). Then Alberica tells you the whole of her family's bargain
  # (owner's decision 3), the setup the Vault hook pays. Plays once, after Rest.
  def solstice_camp_banter
    return if flag?(:solstice_council)
    party = %i[alberica reptin alerion meat_meat wyn].select { |k| companions.include?(k) }
    return if party.size < 2
    set_flag(:solstice_council)
    set_flag(:solstice_camp_talk)
    night = Tone.new(-85, -75, -20, 50)
    stand = []
    pbFadeOutIn do
      $game_screen.start_tone_change(night, 0) rescue nil
      # round the stove (the camp is the tile in front of you), facing in
      ring = [[-1, 1, 6], [1, 1, 4], [-1, 0, 2], [1, 0, 2], [0, -1, 2]]
      party.each_with_index { |k, i| dx, dy, d = ring[i]; stand << [k, stand_in(k, dx, dy, d)] }
    end rescue nil
    say(["Night on the giants' dock. Up the ice, the skull's eyes are lit from inside."])
    sayc([cl(:meat_meat, "This island has no coffee. This island is dead to Meat Meat.")])
    if with_or_is?(:wyn)
      cline(:wyn, "...Um. I brought some. Mushroom. It's still a bit warm, if you hold it close.",
            "...Um. Mushroom coffee? It's still warm.")
      sayc([cl(:meat_meat, "Mushroom friend. Meat Meat will die for you. Tomorrow, probably.")])
    end
    cline(:alberica, "Nobody dies tomorrow, sugar. I've got a song half-written about tomorrow.",
          "...Nobody dies tomorrow. I've got a song to finish.")
    if with_or_is?(:alerion)
      sayc([cl(:alerion, "You finished it an hour ago.")])
      sayc([cl(:alberica, "Then I'll write another. Problem solved, pretty boy.")])
    end
    # what do we do with her? (Reptin's promise at the Shrine: "on the way, we decide")
    cline(:reptin, "(setting the cup down) I said we'd decide on the way. This is the end of the way.",
          "(setting the cup down) ...We said we'd decide. So.")
    cline(:meat_meat, "(a hand on Dawnfang) Meat Meat decided. One stab. No more winters.",
          "(a hand on Dawnfang) ...Meat Meat would miss snow a little.")
    cline(:reptin, "Kill a god and her faithful pray her back. Then we do this again, older.")
    cline(:alberica, "(very still) Or somebody holds her. Keeps her still. I'm good at keeping.",
          "(very still) ...Or somebody holds her.")
    cline(:alerion, "No.", "...No. Not you.")
    cline(:wyn, "...Um. In the spore beds nothing's ever gone. It rests. Then it comes back.")
    cline(:alerion, "Shimmer told Sephek there was a third way. She never said what it was.")
    asker = herald?(:reptin) ? :alberica : :reptin
    if outsider?
      sayc([cl(asker, asker == :reptin ? "(to you) You've been quiet, dear. And it's your Wall riding on it." :
                                         "(to you) You've been quiet, wolf. And it's your Wall riding on it.")])
      if has_key?(:FT_OWLFEATHER)
        if companions.include?(:wyn)
          say(["WYN: (very quietly) And she's marked you. Like Alberica. I saw the feather."])
        elsif companions.include?(:alberica)
          say(["ALBERICA: (very quietly) And she's marked you. Like me. I saw the feather."])
        end
      end
    else
      sayc([cl(asker, asker == :reptin ? "(to you) You haven't said, dear." : "(to you) You haven't said, wolf.")])
    end
    c = pbMessage(_INTL("What do we do with her?"),
                  [_INTL("\"End her.\""), _INTL("\"Give winter back its place.\""), _INTL("\"I don't know yet.\"")], 2)
    case c
    when 0
      set_flag(:camp_view_end)
      if herald?(:meat_meat)
        sayc([cl(:reptin, "(to you) One vote, dear. A loud one. It's a start.")])
      else
        sayc([cl(:meat_meat, "Meat Meat and you. That's two."), cl(:reptin, "Two is a start, dear. Not a vote.")])
      end
    when 1
      set_flag(:camp_view_place)
      sayc([herald?(:wyn) ? nil : cl(:wyn, "(brightening, a little) ...Like the spore beds."),
            cl(:alerion, "Then we find out what that means.")])
    else
      set_flag(:camp_view_unsure)
      if herald?(:alberica)
        sayc([cl(:reptin, "Honest. I'll take honest, the night before.")])
      else
        sayc([cl(:alberica, "Good. People who know the night before are liars.")])
      end
    end
    cline(:alerion, "We choose up there. All of us. Nobody does it alone.", "...Up there. All of us.")
    solstice_bargain(stand) if with_or_is?(:alberica)
    pbFadeOutIn do
      Stage.cleanup rescue nil
      $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 0) rescue nil
    end rescue nil
    say(["Dawn comes up grey over the ice. Up the slope, the skull is waiting."])
    if !flag?(:statue_fields_entered)
      state[:goal] = "Grimskalle, the crowned skull. Frostina is at the top. So is Auril."
    end
  end

  # Alberica's family bargain, told whole, the night before the end (owner's
  # decision 3; bible "The family bargain"): her village is spared Auril's
  # hardships as long as the White Vault stays sealed, and the pendant was the
  # key her family kept so it would stay that way. What's behind the door, she
  # doesn't know: the postgame Vault answers that. Playing Alberica, you choose
  # whether to tell Reptin.
  def solstice_bargain(stand)
    me = herald?(:alberica)
    # the others lie down; Alberica (and, playing her, whoever you'd tell) stays up
    keep = me ? [(companions.include?(:reptin) ? :reptin : companions.first)] : [:alberica]
    pbFadeOutIn do
      stand.each { |k, ev| Stage.remove_actor(ev) if ev && !keep.include?(k) }
    end rescue nil
    say([me ? "The others sleep. You don't. Your fingers keep finding the hollow of your throat." :
              "The others sleep. Alberica doesn't. Her fingers keep finding the hollow of her throat."])
    sig = sigils_held rescue 0
    if me
      who = keep.first
      nice = who.to_s.split("_").map(&:capitalize).join(" ")
      name = nice.upcase
      c = pbMessage(_INTL("{1} is still awake, watching you.", nice),
                    [_INTL("(Tell {1}.)", nice), _INTL("(Keep it.)")], 1)
      if c == 0
        set_flag(:bargain_told)
        speak(:alberica, "My family made a bargain with Auril, long ago. Our village never drew a name.")
        speak(:alberica, "No lottery. No frost in the wells. Two years of Rime, and we ate every night.")
        say(["You touch the empty place at your throat, where the pendant used to hang."])
        speak(:alberica, "The price was a door. The White Vault. It stays shut, and we stay spared.")
        speak(:alberica, "Gran kept the key: the pendant. \"Keep it close. It keeps the far future out.\"")
        say([who == :reptin ? "REPTIN: (very gently) Then tomorrow we find out together. That's the price of me." :
                              "#{name}: (very quietly) Then tomorrow we find out what's behind it. Together."])
      else
        set_flag(:bargain_kept)
        say(["(Not tonight. Tomorrow, if there is one.)"])
      end
      return
    end
    set_flag(:bargain_told)
    say([outsider? ? "ALBERICA: (low, to you) You came in from outside all this. So you get told. Nobody else." :
                     "ALBERICA: (low, to you) You've known me a month. That's longer than most. So you get told.",
         "ALBERICA: My family made a bargain with Auril, long ago. Our village never drew a name.",
         "ALBERICA: No lottery. No frost in the wells. Two years of Rime, and we ate every night.",
         "She touches the empty place at her throat, where the pendant used to hang.",
         "ALBERICA: The price was a door. The White Vault. It stays shut, and we stay spared.",
         "ALBERICA: Gran kept the key: the pendant. \"Keep it close. It keeps the far future out.\"",
         "The stove ticks. Out on the ice, Razzilith sighs in his sleep."])
    say(["ALBERICA: Those sigils in your bag hum at that door. I've heard them. I've said nothing."]) if sig > 0
    say(["ALBERICA: Nobody ever said what's behind it. I think tomorrow she'll tell me herself."])
    c = pbMessage(_INTL("Alberica waits."), [_INTL("(Listen.)"), _INTL("\"It's not yours to pay.\"")], 0)
    if c == 0
      set_flag(:bargain_heard_out)
      say([herald?(:reptin) ? "ALBERICA: ...Thank you. And don't make a plan, wolf. You will anyway." :
                              "ALBERICA: ...Thank you. Don't tell Reptin. He'll make a plan."])
    else
      set_flag(:bargain_pushed)
      say(["ALBERICA: (a tired laugh) Everybody says that until it's due. ...Go to sleep."])
    end
  end

  #-----------------------------------------------------------------------------
  # SC 12.03 - Sopo
  #-----------------------------------------------------------------------------
  def sopo(event_id = nil)
    return say(lines_for(:sopo_after), event_id) if flag?(:dock_cleared)
    sayc(["A ruined dock built for giants.",
          "A small grinning thing made of ice sits on a bollard, kicking its heels.",
          "SOPO: Visitors! Oh, VISITORS! I'm the guide. I guide people. Mostly into holes.",
          "SOPO: (cackling) The Frostmaiden's expecting you! Everybody is. Even the dead ones!",
          cl(:reptin, "Charming. We'll find our own way, thank you."),
          cl(:meat_meat, "Meat Meat will bite it. Not fondly.")], event_id)
    help = flag?(:council_mira) || flag?(:corsair_favour) || voyage_route == :ship   # (the Requiem's crew came too)
    if help
      # whose sloop that is (context 12 M12-5): the favour from Mira's gym, and
      # Hellen's note to her where you carried it
      say(["A Corsair sloop slides out of the fog and grinds against the dock.",
           "Mira's people pile off, shouting, and fall on Sopo's pack."])
      px, py = $game_player.x, $game_player.y
      cor = Stage.actor(:corsair, px + 3, py + 1, 4, graphic: "BW_Sailor")
      Stage.walk_to(cor, px + 1, py, face: 4) if cor
      say([flag?(:mira_left_possessed) ? "CORSAIR: The Requiem's compliments. The captain would want it." :
           flag?(:hellen_note_delivered) ? "CORSAIR: Captain Mira's compliments. The Brightruns' debt, paid." :
                                           "CORSAIR: Captain Mira's compliments. She pays her debts.",
           "CORSAIR: The little ones are ours. The giggly one's yours."])
      Stage.leave(cor, px + 3, py + 1) if cor
      return if !boss_battle(named_mon(:B428H124, 59, "Sopo"))
    else
      return if !pbTrainerBattle(:FT_MEPHIT, "Sopo", nil, false, 0)
    end
    set_flag(:dock_cleared)
    ($game_switches[SW_DOCK_CLEARED] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    say(["Sopo scrambles away up the ice, giggling.",
         "It follows you at a distance, and bolts whenever you turn around."])
  end

  #-----------------------------------------------------------------------------
  # SC 12.04 - Defilers
  #-----------------------------------------------------------------------------
  def scene_statue_fields
    return if flag?(:statue_fields_entered)
    set_flag(:statue_fields_entered)
    sayc(["A field of ice sculptures, too perfect for any hand.",
          "Bears. Elk. Sabertooths. Yetis. Dragons with their wings half open.",
          "Every whisker. Every feather. Every scale.",
          as(:meat_meat, "(whispering) Are they alive?"),
          cl(:alerion, "They were."),
          cl(:alberica, "Nobody touch anything. I mean it. Hands in pockets, sweethearts."),
          cl(:reptin, "Says the woman who has never once in her life kept her hands to herself.")])
  end

  # Touching a statue wakes the Snow Aspect (once per statue).
  def statue_touched(event_id = nil)
    say(["Your hand brushes the ice.",
         "The snow round your feet rises into a woman seven feet tall, with Auril's face.",
         "AURIL: DEFILERS!"], event_id)
    boss_battle(named_mon(:B124H144, 59, "Snow Aspect"))
    say(["The Snow Aspect crumbles. The statue isn't even scratched.",
         "It was never going to be scratched."])
    set_self_switch(event_id, "A") rescue nil
  end

  def shimmer_statue(event_id = nil)
    if flag?(:fields_crossed)
      return say(["Shimmer, in ice. Arms open, smiling into the wind.", "It's only what she looked like."], event_id)
    end
    say(["At the far edge, one statue isn't an animal.",
         "A young woman, arms open, smiling into the wind.",
         as(:alerion, "(stopping dead) ...Shimmer."),
         as(:alberica, "It's her. Auril kept her. Like a flower pressed in a book.")], event_id)
    speak(:alerion, "(touching the cold cheek) She didn't keep anything. That's not her.",
          "(touching the cold cheek) ...No.", event_id)
    sayc([as(:alerion, "It's what she looked like. Shimmer's in Frostina now. Shade made sure of that."),
          cl(:meat_meat, "Shade would have said something clever here. Meat Meat will say it instead."),
          cl(:meat_meat, "...Meat Meat does not know what it was."),
          cl(:reptin, "(softly) That was it, Meat Meat. That was exactly it.")], event_id)
    set_flag(:fields_crossed)
    set_switch(SW_FIELDS_ROPE, true)   # a rope back up from the entrance, from now on
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # SC 12.05 - The Garden of Death
  #-----------------------------------------------------------------------------
  def scene_garden_of_death
    return if flag?(:garden_entered)
    set_flag(:garden_entered)
    sayc(["An ice-walled graveyard.",
          "Everyone who ever froze on Solstice is here, each sealed upright in a block of clear ice.",
          "Sailors. Giants. A wizard with an orb still in her hands.",
          "An ice troll is gnawing on one of the blocks.",
          cl(:alberica, "...And I thought my last party was grim."),
          cl(:alerion, "It was.")])
  end

  def ice_troll(event_id = nil)
    return if flag?(:troll_down)
    say(["The ice troll looks up from its block with ice in its teeth, and grins."], event_id)
    return if !boss_battle(named_mon(:B221H68, 60, "Ice Troll"))
    set_flag(:troll_down)
    ($game_switches[SW_TROLL_DOWN] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    sayc(["The troll goes down in pieces.",
          "The pieces are already crawling back together. You don't stay to watch.",
          cl(:meat_meat, "Meat Meat bit a piece. It tasted like a cellar.")])
  end

  def nass(event_id = nil)
    if flag?(:skant_freed)
      return say(["NASS: The safe way's past the third row of the dead.",
                  "NASS: Up, not down. Up is always the way out of here."], event_id)
    end
    say(["NASS: (a ghost in wizard's robes) You're not with her? The frost woman? ...Good.",
         "NASS: The orb in my hands talks. Too much. Free it, and I'll show you the safe way up."], event_id)
    able = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? && pk.moves.any? { |m| m && ((GameData::Move.get(m.id).type rescue nil).then { |t| t == :FIGHTING || t == :FIRE }) } }
    return say(["(The ice is thick. A Fighting or Fire move would crack it.)"]) if !able
    return if !pbConfirmMessage(_INTL("Have {1} break Nass's block?", able.name))
    sayc(["#{able.name} hits the block. It splits top to bottom with a sound like a bell.",
          "PROFESSOR SKANT: (from the orb, very fast) Finally! Do you know how long I've held that thought?",
          "A talking orb. A wizard's familiar, from the sound of it.",
          "PROFESSOR SKANT: Four hundred and eleven years. I'll tell you the thought later. It's a good one.",
          "NASS: (fading) Up, not down. Up is always the way out of here.",
          cl(:reptin, "Lovely to meet you both. We'll be going. Up, apparently.")])
    set_flag(:skant_freed)
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # SC 12.06 - The crowned skull
  #-----------------------------------------------------------------------------
  def ukuma(event_id = nil)
    return say(lines_for(:ukuma_after), event_id) if flag?(:ukuma_raced) || flag?(:ukuma_lost)
    say(["Inside the jaw, a giant walrus slides round and round an ice rink, ignoring you.",
         "UKUMA: (not stopping) Guarding. I am guarding. Very busy guarding."], event_id)
    return if !pbConfirmMessage(_INTL("Race Ukuma round the rink?"))
    fast = $Trainer.party.reject(&:egg?).max_by { |pk| pk.speed }
    if fast && fast.speed >= 120
      sayc(["#{fast.name} takes the ice like it was born on it.",
            "Ukuma loses by a whisker, sits down hard, and laughs like a foghorn.",
            "UKUMA: Fast! Fast little thing! Fine. FINE. Back door. Hall of the Four Winds.",
            "UKUMA: Don't tell her.",
            cl(:meat_meat, "Meat Meat likes the walrus. The walrus has priorities.")])
      set_flag(:ukuma_raced)
    else
      say(["#{fast ? fast.name : 'You'} slides, spins, and ends up in a snowbank.",
           "Ukuma doesn't even slow down.",
           "UKUMA: Guarding! Still guarding!"])
      set_flag(:ukuma_lost)
    end
  end

  def grimskalle_jaw(event_id = nil)
    shortcuts = []
    shortcuts << "Eirwen's plans: the servants' stair" if flag?(:council_eirwen)
    shortcuts << "Nass's safe way up" if flag?(:skant_freed)
    shortcuts << "Ukuma's back door" if flag?(:ukuma_raced)
    say(lines_for(:grimskalle_jaw), event_id)
    say(["(Your shortcuts: #{shortcuts.join('; ')}.)", "(Each makes the climb easier. None of them skips a Test.)"]) if !shortcuts.empty?
    return if !pbConfirmMessage(_INTL("Go into Grimskalle?"))
    set_flag(:grimskalle_entered)
    add_counter(:story_beats)
    set_rest_at(HALL_ARRIVAL) rescue nil
    transfer(*HALL_ARRIVAL)
  end

  def apply_chapter12_switches
    return if !active? || !$game_switches
    $game_switches[SW_DOCK_CLEARED] = flag?(:dock_cleared)
    $game_switches[SW_TROLL_DOWN] = flag?(:troll_down)
    $game_switches[SW_FIELDS_ROPE] = flag?(:fields_crossed)
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter12_switches
  rescue StandardError => err
    FrostThaw.log("Chapter 12 switches failed: #{err.message}")
  end
}
