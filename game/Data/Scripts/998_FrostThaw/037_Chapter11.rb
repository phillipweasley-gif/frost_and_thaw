#===============================================================================
# Frost & Thaw - Act III, Chapter 11: The Frost Saint Walks (script SC 11.01-11.04)
#
# No goal at first: it's a celebration. Then Auril moves, and the goal is to
# get Frostina back.
#
#   11.01 The wheel and the ones who bind it (the Hearth, the night of the Vote)
#   11.02 The Frost Saint walks (the Shrine of the Twinned Dragons)
#   11.03 Three hearts            11.04 Four chairs (the Council, morning)
#===============================================================================
module FrostThaw
  SW_CH11_HEARTH = 3993   # the night of the Vote, at the Hearth (11.01)
  SW_CH11_SHRINE = 3994   # run to the Shrine (11.02)
  SW_CH11_COUNCIL = 3995  # the morning after, at the Council (11.04)

  TRAINERS.merge!(
    halo_vigilant: [:FT_HALO, "Brother Ansel", [[:B124H221, 56], [:WEAVILE, 57]], "The Frost Saint walks. You're too late, as you were always going to be."],
    eline_sephek:  [:FT_HALO_MATRON, "Matron Eline", [[:B215H124, 58], [:B131H429, 59], [:B87H221, 59], [:B144H215, 60]],
                    "Patience is a winter virtue. And the Saint is patience itself."]
  )
  TRAINER_INTROS.merge!(
    halo_vigilant: "ANSEL: Kneel. The Saint is waking.",
    eline_sephek: "ELINE: Stand back from the Saint."
  )

  module_function

  # After the Vote (SC 10.09): the night at the Hearth.
  def act3_start
    set_switch(SW_CH11_HEARTH, true)
    transfer(2053, 5, 9, 8)
  end

  #-----------------------------------------------------------------------------
  # SC 11.01 - The wheel and the ones who bind it
  #-----------------------------------------------------------------------------
  def scene_auril_whisper
    set_switch(SW_CH11_HEARTH, false)
    return if flag?(:auril_whisper)
    al = herald?(:alberica)
    # Context 11 M11-1: an act card, then where and when this is.
    say(["ACT III. THE FROSTMAIDEN"])
    say(["The Rooted Hearth, the night of the vote. The bard is playing the Heralds' song, badly.",
         "HELLEN: (stopping, eyes wet) New verse. Glimmer's. The city calls him the Dagger Reborn.",
         cl(:alerion, "(to Hellen) The verse is good. Keep going."),
         cl(:meat_meat, "Meat Meat has had four coffees. Meat Meat can hear colours."),
         cl(:reptin, "(to the room) She means she's happy. Mostly."),
         al ? "You set down your cup. The rune on your chest is glowing through your shirt." :
              "Alberica sets down her cup. The rune on her chest is glowing through her shirt.",
         "The room goes white. #{al ? 'Only you can move' : 'Only Alberica can move'}."].compact)
    (pbBGMFade(1.0) rescue nil)
    Stage.overlay("O-04", fps: 4, stop_at: 2, fade: 0, wait: true)   # frost in from the edges
    $game_screen.start_tone_change(Tone.new(60, 60, 80, 120), 20) rescue nil
    auril = (Stage.actor(:auril, $game_player.x, $game_player.y - 2, 2, graphic: "FT_auril_furs") rescue nil)
    say(["A woman in frost-furs is sitting across the table. Nobody else can see her."])
    # The outsider was marked at the last mirror (Ch5): this is the first time
    # since then that Auril has been in a room with them.
    if outsider?
      say(["You can. Since the last mirror, you've been on her wheel."])
      c = pbMessage(_INTL("(She turns her head toward you.)"), [_INTL("(Look back.)"), _INTL("(Look away.)")], -1)
      if c == 0
        set_flag(:looked_at_auril)
        say(["AURIL: (to you, pleased) There you are. The one who wasn't on my wheel. Now you are."])
      else
        set_flag(:looked_away)
        say(["AURIL: You'll look, in the end. Everyone does."])
      end
      say(["She turns back to #{al ? 'you' : 'Alberica'}."])
    end
    say(["AURIL: Hear the wheel, and the ones who bind it.",
         "AURIL: The dark half guards silence, a sentinel chained to frost.",
         "AURIL: The light half births flame. And flame consumes as easily as it warms. The spark is spent.",
         "Her breath frosts the table between you.",
         "AURIL: Life and death march only so long as they move. Stop them, and all is mine.",
         "AURIL: And memory keeps the key. Keys open, Alberica. They also lock."])
    speak(:alberica, "(through her teeth) Get out of my head.", "(barely) ...Get out.")
    # The omens she sent all through the city (048_E): she knows which ones you saw.
    if (counter(:omens_seen) rescue 0).to_i >= 3
      say(["AURIL: You've seen them. Every sign. Frost on his shadow. Vines on her breath. Your own throat, cold.",
           *{ never: ["AURIL: \"Never,\" you told yourself."],
              not_yet: ["AURIL: \"Not yet,\" you said. Every night, \"not yet.\""] }[herald?(:alberica) ? state[:omen_secret] : nil].to_a,
           "AURIL: You told no one. That's how I knew you were mine."])
    end
    say(["She leans in.",
         "AURIL: You are my vessel, little songbird. You always were.",
         "AURIL: Guard them if you must. But remember: they cannot escape their fates, and the wheel turns for me.",
         "AURIL: Come and be beautiful forever."])
    # Herald Alberica knows there was a bargain (her prologue): let her connect it (context 11 §6).
    say(["(Keys. The family's bargain. Nobody ever said what it locked.)"]) if al
    Stage.hide(auril) if auril
    Stage.overlay_off("O-04", fade: 20)
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 20) rescue nil
    say(["The room comes back."])
    stage_act(:alberica, :kneel, dx: 1, dy: 0, dir: 2)    # on her knees
    say(["#{al ? 'You are' : 'Alberica is'} on #{al ? 'your' : 'her'} knees. #{herald?(:meat_meat) ? 'You are' : 'Meat Meat is'} holding #{al ? 'your' : 'her'} hands."])
    speak(:alberica, "(hoarse) She's coming. No. She's already here. ...Don't make a thing of it.",
                     "(hoarse) ...Something's pulling me north. Don't make a thing of it.")
    say([cl(:meat_meat, "Meat Meat is making a thing of it.")].compact)
    set_flag(:auril_whisper)
    add_counter(:story_beats)
    pbSEPlay("Earth3") rescue nil
    say(["Far above, at the crown of the tree, something screams.",
         "A dragon. Frostina."])
    # Context 11 M11-2: Alerion runs; you follow.
    if with_or_is?(:alerion)
      speak(:alerion, "(already on his feet) She's calling me. Up. Now.", "(already on his feet) ...Up. Now.")
      runner = Stage.summon(:alerion)
      Stage.leave(runner, 5, 12) if runner
    end
    Stage.cleanup rescue nil
    set_switch(SW_CH11_SHRINE, true)
    state[:goal] = "The Shrine of the Twinned Dragons, at the top of the root-lift. Frostina."
    transfer(2061, 12, 33, 8)
  end

  #-----------------------------------------------------------------------------
  # SC 11.02 - The Frost Saint walks; 11.03 - Three hearts
  #-----------------------------------------------------------------------------
  # What Eline carries up to the Shrine depends on what the Heralds did with the
  # Frost Saint Shard in the Heart Chamber (034 scene_heart_choice).
  def saint_heart_lines
    if flag?(:shard_purified)
      ["Eline holds a heart. It beats, but there's no light in it: a man's heart, cold and clean.",
       "ELINE: When the roots fell, we went down for it. It was beating in the rubble.",
       "ELINE: You burned her out of it. We felt it in every shrine in the Dale.",
       "ELINE: It doesn't matter. He kept faith four hundred years with no light to see by."]
    elsif flag?(:shard_destroyed)
      ["Eline holds a fistful of ice splinters, threaded together on Halo prayer-wire.",
       "They're beating, out of step with each other.",
       "ELINE: You broke her heart. We went down on our knees and gathered every piece.",
       "ELINE: We are very patient."]
    else
      ["Eline holds a blue light in her hands. It's beating: the frost-light heart.",
       "ELINE: When your engine died, the heart fell free. We were waiting.",
       "ELINE: We are very patient."]
    end
  end

  # Where you stand when it happens: by the great stump, with the twins.
  SHRINE_STEPS = [[21, 23], [22, 23], [20, 23], [21, 22], [23, 22], [22, 26], [21, 26]]

  # Context 11 M11-2: the run from the root-lift to the Shrine, behind Alerion.
  def run_to_the_shrine
    return if !Stage.map?
    lead = herald?(:alerion) ? $game_player : Stage.summon(:alerion)
    return if !lead
    spot = SHRINE_STEPS.find { |x, y| Stage.path_for(lead, x, y) }
    return if !spot
    say([herald?(:alerion) ? "You run for the great stump. You can hear her." :
                             "Alerion is already running for the great stump. You run after him."])
    if lead.equal?($game_player)
      Stage.walk_to($game_player, *spot, face: 8)
    else
      Stage.escort(lead, *spot, facing: 8)
      Stage.face($game_player, 8)
    end
  end

  def scene_frost_saint_walks
    set_switch(SW_CH11_SHRINE, false)
    return if flag?(:frostina_taken)
    run_to_the_shrine
    px, py = ([$game_player.x, $game_player.y] rescue [0, 0])
    real = stage_event("Frostina")
    real.transparent = true if real rescue nil          # the scene's Frostina stands in for her
    sephek = Stage.actor(:sephek, px, py - 3, 2, graphic: "FT_sephek_frozen")
    eline = Stage.actor(:eline, px - 1, py - 2, 6, graphic: "FT_matron_eline")
    [[px - 3, py - 2], [px + 1, py - 4], [px - 2, py - 4]].each_with_index { |(x, y), i| Stage.actor(:halo_robe, x, y, 2, graphic: i.odd? ? "FT_halo_disciple_female" : "FT_halo_disciple_male") }
    heart = Stage.fx("E-14", [px - 1, py - 2], oy: 24, loop_from: 0)   # beating in Eline's hands
    frostina = Stage.actor(:frostina, px + 3, py - 3, 4)
    # Context 11 M11-2: name the two who come back after four chapters, and how the heart got here.
    say(["The Shrine is full of Halo robes.",
         "On the altar lies Sephek Kaltro, who killed Shimmer, still in his ice.",
         "The Halo carried him up from the Still Sky Shrine while the city voted.",
         flag?(:canopy_free) ? "(The Canopy stayed free, as you argued. Nobody was watching the stair.)" : nil,
         "Matron Eline kneels beside him. Last time, she got away from you by a back door.",
         *saint_heart_lines,
         "She presses it into the hollow in Sephek's chest."].compact)
    Stage.stop_fx(heart)
    if sephek
      Stage.fx("E-14", sephek, frames: 6, oy: 36)
      sephek.character_name = "FT_sephek" rescue nil
    end
    say(["The ice cracks. Sephek breathes in, four hundred years late.",
         "His eyes open, blue as a frozen lake.",
         flag?(:shard_destroyed) ? "SEPHEK: (his voice coming in pieces) ...It's cold. It's so loud in here. Why is it so loud?" :
                                   "SEPHEK: (very quietly) ...It's cold. Why is it still so cold?",
         "ELINE: (kneeling) The Frost Saint walks again.",
         herald?(:alerion) ? "You got here first. You always hear her first." :
                             "Alerion got here first. He always hears her first.",
         herald?(:alerion) ? "You're standing between them and Frostina. Your ring is white with frost." :
                             "He's standing between them and Frostina, his ring white with frost."])
    # (said to the Halo, and Sephek answers it: spoken, context 11 §6)
    speak(:alerion, "You don't get her twice.", "...Not twice.") if with_or_is?(:alerion)
    say([herald?(:meat_meat) ? "(Both arms around Razzilith's neck. He wants to go through them. So do you.)" :
                               "MEAT MEAT: (both arms around Razzilith's neck, holding him back) Not yet, Razzy. Not yet."])
    # The Minor Avatar (rootspire.md Tab 4, 1.1): his followers first; he can't
    # be killed in Rootspire, and he drops a Frostshard Sigil when he breaks.
    sephek_minor_avatar
    iskra_takes_frostina(px, py, frostina, sephek)
    down = stage_act(:alerion, :down, dx: 0, dy: 1, dir: 2, per: 6)   # in the snow on the steps
    if herald?(:alerion)
      say(["You're lying in the snow on the Shrine steps, a hand pressed to your chest.",
           "Where her second heartbeat was. It's so faint now.",
           "Razzilith is roaring at the sky."])
    else
      say(["Alerion is lying in the snow on the Shrine steps, a hand pressed to his chest.",
           "Where Frostina's second heartbeat was.",
           herald?(:meat_meat) ? "Razzilith is roaring at the sky, and you're roaring with him." :
                                 "Razzilith is roaring at the sky, and Meat Meat is roaring with him."])
    end
    say([as(:alerion, "(not getting up yet) ...She's still beating. Far. North."),
         as(:alerion, "A Dragoon can follow that.")])
    # (an input in the long run from the Minor Avatar to the three hearts)
    if herald?(:alerion)
      pbMessage(_INTL("(Razzilith is still roaring. Get up?)"), [_INTL("(Get up.)"), _INTL("(Lie still a moment longer.)")], -1)
      stage_act(:alberica, :kneel, dx: 1, dy: 1, dir: 2) if down
      speak(:alberica, "(kneeling, a hand on your back) Then up you get, pretty boy. Slowly.", "...Up. Slowly.")
    else
      helped = pbConfirmMessage(_INTL("Help Alerion up?"))
      stage_act(:alberica, :kneel, dx: 1, dy: 1, dir: 2) if down
      if helped
        say(["You get an arm under him.",
             cl(:alberica, "(kneeling, his other side) Then up you get, pretty boy. Slowly.")].compact)
      elsif with_or_is?(:alberica)
        speak(:alberica, "(kneeling, a hand on his back) Then up you get, pretty boy. Slowly.", "...Up. Slowly.")
      end
    end
    Stage.pose(down, "P-ALE-03", 0, frames: [3, 2, 1, 0], per: 8) if down   # getting up, slowly
    set_flag(:frostina_taken)
    set_flag(:sephek_risen)
    set_switch(3954, true)            # Frostina is gone from the Shrine
    add_counter(:story_beats)
    scene_three_hearts
  end

  #-----------------------------------------------------------------------------
  # Iskra, Auril's roc (story_bible "Characters"; context 11 M11-3): she's on
  # screen, and she's huge. Until she has art of her own she wears the flying
  # follower sheet, drawn three times over and paled to white (Sprite_Character
  # below), so she reads as a vast white bird, not a follower-sized Articuno.
  #-----------------------------------------------------------------------------
  # Her own sheet (128-pixel frames) when it's there, else the Articuno stand-in (64)
  def iskra_own?
    @iskra_own = (pbResolveBitmap("Graphics/Characters/FT_iskra") ? true : false rescue false) if @iskra_own.nil?
    @iskra_own
  end
  def iskra_graphic; iskra_own? ? "FT_iskra" : "Followers/ARTICUNO_fly"; end
  def iskra_zoom; iskra_own? ? 1.5 : 3.0; end
  def iskra_shadow_zoom; iskra_own? ? 2.25 : 4.5; end

  # Called for every character sprite each frame (cheap: a name check).
  def iskra_sprite(sp)
    ch = sp.character
    return if !ch.is_a?(Game_Event)
    name = ch.name.to_s
    return if name !~ /\A(stage_)?iskra(_shadow)?\z/i
    if name =~ /shadow/i
      sp.zoom_x = sp.zoom_y = iskra_shadow_zoom
      sp.color = Color.new(10, 10, 30, 255)
    else
      sp.zoom_x = sp.zoom_y = iskra_zoom
      sp.color = Color.new(240, 248, 255, 120) if !iskra_own?   # white, not Articuno's blue
    end
  end

  def iskra_takes_frostina(px, py, frostina, sephek)
    (pbBGMFade(0.5) rescue nil)                                     # the Canopy's music stops
    $game_screen.start_tone_change(Tone.new(-50, -50, -25, 0), 10) rescue nil
    say(["The sky above the Canopy tears open."])
    # her shadow first: wider than the stump, sliding north to south
    shadow = Stage.actor(:iskra_shadow, px + 1, py - 9, 2, graphic: iskra_graphic)
    if shadow
      shadow.opacity = 90
      shadow.through = true
      Stage.walk(shadow, [PBMoveRoute::ChangeSpeed, 6] + [PBMoveRoute::Down] * 16)
      Stage.remove_actor(shadow)
    end
    say(["A shadow slides over the whole Canopy, wide as a sail. Then the wind of her wings."])
    iskra = Stage.actor(:iskra, px + 3, py - 8, 2, graphic: iskra_graphic)
    if iskra
      iskra.instance_variable_set(:@step_anime, true) rescue nil
      Stage.walk(iskra, [PBMoveRoute::ChangeSpeed, 5] + [PBMoveRoute::Down] * 4)
      $game_screen.start_shake(4, 6, 12) rescue nil
    end
    Stage.cry(:ARTICUNO)
    say(["Through the thinned Wall, a white bird drops out of the night. A roc, vast as a ship.",
         "Aurora trails from her wingtips.",
         "Iskra."])
    say([as(:alerion, "(barely breathing) The Frostmaiden's roc. Frostina's egg fell from her.")])
    if frostina
      Stage.fx("E-04", frostina, frames: 10, hold: true, wait: true, oy: 8)   # the crystal closes over her
      frostina.character_name = "FT_frostina_crystal" rescue nil
    end
    say(["Sephek raises one hand. Ice blooms around Frostina: a crystal, not a cage.",
         "She goes still inside it, her eyes still open.",
         "SEPHEK: (to Alerion, and he means it) I'm sorry. I'm taking her home.",
         "SEPHEK: To Solstice. To the nest she fell from. She was always going home.",
         as(:alerion, "(very quietly) She was never Auril's.")])
    # the bible's beat: Alerion, her Dragoon, is thrown down trying to stop them
    al = herald?(:alerion)
    goer = al ? nil : Stage.summon(:alerion)
    Stage.walk(goer, PBMoveRoute::Up) if goer
    $game_screen.start_shake(7, 8, 16) rescue nil
    pbSEPlay("Wind1") rescue nil
    Stage.walk(goer, [PBMoveRoute::ChangeSpeed, 6, PBMoveRoute::Backward, PBMoveRoute::Backward]) if goer
    say([al ? "You go for the crystal. One beat of her wings throws you down the steps." :
              "Alerion goes for the crystal. One beat of her wings throws him down the steps.",
         "Iskra takes the crystal in her talons."])
    Stage.panel("S-11a")                       # (the roc mantling over Frostina's crystal on the Shrine stump)
    say(["For one breath she spreads her wings over the Shrine stump, guarding what she's taken."])
    Stage.panel_off
    say([flag?(:eline_captured) ? "Sephek climbs onto her back alone. In the root-cords, Eline is still praying backwards." :
                                  "Sephek and Eline climb onto her back."])
    if iskra
      [frostina, sephek, stage_event("stage_eline")].each { |e| e.opacity = 0 if e rescue nil }   # they go with her
      Stage.walk(iskra, [PBMoveRoute::Up] * 10)
    end
    say(["The roc turns north, toward the Sea of Moving Ice, and is gone."])
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 20) rescue nil
    Stage.cleanup rescue nil
  end

  # Context 11 M11-4: three hearts, the act's doorway, and Alberica's secret out.
  def scene_three_hearts
    lumin = stage_event("Lumin Weavemoss")
    Stage.approach(lumin) if lumin
    say(["Lumin comes down the Shrine steps with an old Wennen book open in both paws.",
         "LUMIN: (paws shaking) \"One heart of ice is grief. Two is a burden.\"",
         "LUMIN: \"Three is a summons.\"",
         flag?(:knows_three_hearts) ? cl(:reptin, "Luna Carver told us that. Four hundred years ago. Last month.") : nil,
         "LUMIN: Shimmer's heart, sung into that egg. And his, beating in him. Two."].compact)
    speak(:alberica, "(a hand on her chest) And she wants me for the third.", "(a hand on her chest) ...And the third's me.")
    if with_or_is?(:alberica)
      say([cl(:reptin, "(turning) ...You knew. How long have you known?")].compact)
      quiet = speak(:alberica, "Since the festival. She's been counting us off. Dark half. Light half.",
                    "...Since the festival. I didn't tell you.")
      # Owner's decision 3: the family bargain, hinted here; the whole of it comes the night before the end.
      say([as(:alberica, "(quieter) My family made her a bargain once. Nobody ever said the price.")])
      say([as(:alberica, "The spark was Glimmer. Life and death's you. Memory's me. I didn't tell you.")]) if quiet == 0
      say([cl(:alerion, "(flat) No. You didn't.")].compact)
    end
    # Selrae comes up the root-lift: she heard the scream from the Hall, and she knows this rite.
    selrae = Stage.actor(:selrae, 12, 33, 8, graphic: "FT_winter_matron_selrae_vorn")
    Stage.approach(selrae) if selrae
    say(["SELRAE: (out of breath) I heard the scream. I know this rite. I sat with them for years.",
         "SELRAE: Solstice. Her island in the Sea of Moving Ice.",
         "SELRAE: She'll pour herself into all three at once, and walk out of there in a body.",
         "LUMIN: The Wennen had a name for that. The Rewritten Auril.",
         as(:meat_meat, "Then Meat Meat breaks her.")])
    if with_or_is?(:reptin)
      speak(:reptin, "Then we go and get Frostina back.", "...We get her back.")
      speak(:reptin, "And on the way, we decide what happens to Auril.", "...And we decide what happens to Auril.")
    end
    if with_or_is?(:wyn)
      speak(:wyn, "(quietly) ...Nobody's taking Alberica. I won't let them.", "(quietly) ...Nobody's taking her.")
      speak(:alberica, "(softly) ...Look at you. My brave little mushroom.", "(softly) ...Look at you.") if with_or_is?(:alberica)
    end
    # The Act III doorway for the player (Bell, the walk-away test): two dragons turn the wheel.
    if outsider?
      say(["LUMIN: (to you) And your Wall. Two dragons turn the wheel. Never one.",
           "LUMIN: Without her the wheel stays stuck. The Wall stays up. Your time and theirs, apart.",
           with_or_is?(:reptin) ? as(:reptin, "(to you, gently) You're home, darling. Nobody would blame you for staying.") :
                                  "LUMIN: (to you) You're home, though. Nobody would blame you for staying."])
      c = pbMessage(_INTL("(They wait.)"), [_INTL("I'm coming"), _INTL("I'm not done with that Wall"), _INTL("(Say nothing.)")], -1)
      c = 2 if !c || c < 0
      set_flag(%i[act3_coming act3_wall act3_silent][c])
      say([[cl(:alerion, "(on his feet now, just) Good.") || "LUMIN: Good.",
            cl(:reptin, "Then it's all of our Wall now.") || "LUMIN: Then it's all of ours now.",
            cl(:meat_meat, "Quiet one is coming. Meat Meat can tell.") || "LUMIN: You're coming. I can tell."][c]])
      side_goal(:their_time, "Your own: bring Frostina home. Two dragons turn the wheel; with one, the Wall stays up.",
                done: %i[ending_third_way ending_shatter ending_still_keeper])
    else
      say(["LUMIN: Two dragons turn the wheel. Never one. With her gone, it stays stuck."])
    end
    # Divine Rejuvenation: the Halo seeded the Heartroot with Auril's relics.
    say(["SELRAE: (very low) You broke him and he got up again? Then it's begun.",
         "SELRAE: The Halo carried three of her relics into the Heartroot. Black ice. I let them in.",
         "SELRAE: While one of them stands, the Saint stands back up. Every time.",
         cl(:alerion, "Then we break them first."),
         cl(:reptin, "The Root Gate's seal, the Sap Wells, the Overflow Channel. We know those roots.")].compact)
    set_flag(:knows_auril_relics)
    set_flag(:knows_rewritten)
    set_switch(SW_CH11_COUNCIL, true)
    state[:goal] = "Morning. The Council Hall: four chairs, all filled."
    relic_goal
    # Context 11 M11-5: night becomes morning, and the Council is waiting.
    Stage.cleanup rescue nil
    transfer(*COUNCIL_MORNING)
  end

  COUNCIL_MORNING = [2054, 11, 18, 8]

  #-----------------------------------------------------------------------------
  # SC 11.04 - Four chairs
  #-----------------------------------------------------------------------------
  COUNCILLOR_LOOKS = { rheven: "FT_captain_rheven_stormbranch", mira: "FT_mira_of_the_north_wind", eirwen: "BW (30)", phildendrin: "FT_phildendrin",
                       anduin: "FT_anduin" }

  def scene_four_chairs
    set_switch(SW_CH11_COUNCIL, false)
    return if flag?(:ch11_done)
    Stage.arrive(companions, 11, 19) rescue nil
    # the two new councillors in the empty chairs (context 11 M11-5; notes E1)
    seats = [[10, 13], [16, 13]]
    COUNCILLOR_LOOKS.keys.select { |k| flag?(:"council_#{k}") }.first(2).each_with_index do |k, i|
      Stage.actor(k, *seats[i], 2, graphic: COUNCILLOR_LOOKS[k])
    end
    $game_screen.start_tone_change(Tone.new(30, 15, -10, 0), 1) rescue nil   # dawn through the doors
    say(["Morning. In the Council Hall, all four chairs are filled."])
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 40) rescue nil
    say(["KELYN: The Council of four seasons. Its first session."])
    say(["KELYN: The geas is lifted."]) if flag?(:verdict_geas)
    say(["KELYN: Meat Meat's service to the camp waits until she's home."]) if flag?(:verdict_service)
    say(["KELYN: One item."])
    lines = []
    lines << "RHEVEN: The Skytower clan owes you a debt. Griffons, tomorrow at first light." if flag?(:council_rheven)
    lines << "MIRA: The Requiem's provisioned. My Corsairs have wanted somewhere frightening for years." if flag?(:council_mira)
    lines << "EIRWEN: I found Grimskalle's plans in the oldest leaves. There's a servants' stair." if flag?(:council_eirwen)
    lines << "EIRWEN: Grimskalle's her fortress on Solstice. Frost giants carved it out of a skull." if flag?(:council_eirwen)
    lines << "EIRWEN: Nobody ever guards the servants' stair." if flag?(:council_eirwen)
    lines << "PHILDENDRIN: Duvessa's people will hold this city. Go. And bring my daughter home." if flag?(:council_phildendrin)
    lines << "ANDUIN: The Wennen will ring the old bell. Something very large will answer." if flag?(:council_anduin)
    say(lines) if !lines.empty?
    # The Council asks the one person who isn't a Herald (context 11 M11-5 box 7)
    ask = if flag?(:act3_coming) then "KELYN: (to you) Lumin says you've already said you're going. Then go with ours."
          elsif flag?(:act3_wall) then "KELYN: (to you) For the Wall, Lumin says. Good. It's the city's Wall now too."
          elsif flag?(:act3_silent) then "KELYN: (to you) You didn't say. You're here, though. I'll take that as an answer."
          elsif !outsider? then "KELYN: Heralds. The city can't order you north. It's asking."
          end
    say([ask]) if ask
    four_chairs_consequences if respond_to?(:four_chairs_consequences)
    say([as(:alerion, "(bandaged, standing anyway) I'm coming.")])
    speak(:reptin, "You can barely walk.", "...You can barely walk.") if with_or_is?(:reptin)
    say([as(:alerion, "I've walked on less. She's mine to watch. I'm not done watching."),
         cl(:meat_meat, "Ice Prince can lean on Meat Meat. Meat Meat is short. It will be funny.")].compact)
    speak(:alberica, "And I'm going. If she wants me, she can ask me to my face.",
                     "...I'm going. She doesn't get to wait for me.")
    say([cl(:reptin, "(sighing) Then I'd better pack something nice. I'm not meeting a god in travel clothes.")].compact)
    # The White Vault thread: Eirwen keeps the second sigil; Sephek dropped the third.
    eirwen = stage_event("stage_eirwen") || Stage.actor(:eirwen, 12, 19, 8, graphic: "BW (30)")
    Stage.approach(eirwen) if eirwen
    say(["As the Council rises, Eirwen Solglass pads over, barefoot on the cold floor."])
    eirwen_sigil
    if !try_merge_sigils && !flag?(:sigils_merged)
      say(["EIRWEN: Three sigils, for a door I've never found. I've given you mine. Keep it for after."]) if sigils_held >= 3
      if sigils_held < 3
        say(["EIRWEN: The sigils are keys, for a door I've never found. Keep mine for after.",
             "EIRWEN: The Echo Gate's mirror-wraiths keep another. Linger in the Gate and listen."])
        set_switch(SW_ECHO_POCKET, true) rescue nil
      end
    end
    # Context 12 M12-1: the last thing said in the room is why you're going.
    say([cl(:alerion, "(at the door) Dawn, at the roost. She's beating north. I can feel it from here."),
         cl(:alberica, "Then we'd better sleep, pretty boy. You first. You look like a snowdrift.")].compact)
    set_flag(:ch11_done)
    add_counter(:story_beats)
    state[:goal] = case voyage_route
                   when :ship then "The Boreal Requiem, at the Split Dock. Sail to Solstice and bring Frostina home."
                   when :griffons then "The griffon roost, on the Canopy-Tier. Fly to Solstice and bring Frostina home."
                   else "The Wennen bell pier, in the Root-Tier. Cross to Solstice and bring Frostina home."
                   end
    relic_goal
  end

  # Auril's relics keep their own line under the Goal, with the count, until
  # all three are smashed (review Ch11 E4: the chapter's last goal dropped them).
  def relic_goal
    return if !flag?(:knows_auril_relics) || flag?(:auril_relics_destroyed)
    n = relics_left rescue 3
    side_goal(:auril_relics, "Before you fly: Auril's relics in the Heartroot, #{n} of 3 left. Smash them, and Sephek stays down.",
              done: :auril_relics_destroyed)
  end

  # How you get to Solstice: Mira's ship, Rheven's griffons, Anduin's whale, or Lumin's bell.
  def voyage_route
    return state[:voyage_pick] if flag?(:council_heralds) && state[:voyage_pick]   # (the Heralds' own seat chose)
    return :ship if flag?(:council_mira)
    return :griffons if flag?(:council_rheven)
    return :whale if flag?(:council_anduin)
    return :ship if flag?(:darrus_redeemed)                                         # (Darrus chartered the Requiem)
    :bell
  end

  def apply_chapter11_switches
    return if !active? || !$game_switches
    $game_switches[SW_CH11_COUNCIL] = flag?(:knows_rewritten) && !flag?(:ch11_done)
    $game_switches[3954] = flag?(:frostina_taken) && !flag?(:frostina_freed)
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter11_switches
  rescue StandardError => err
    FrostThaw.log("Chapter 11 switches failed: #{err.message}")
  end
}

# Iskra is drawn huge (context 11 M11-3; the owner's art list wants her BIG):
# any event named Iskra, on any map, is scaled up and paled to white.
if defined?(Sprite_Character)
  class Sprite_Character
    alias ft_iskra_update update unless method_defined?(:ft_iskra_update)
    def update
      ft_iskra_update
      (FrostThaw.iskra_sprite(self) rescue nil) if @character
    end
  end
end
