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
    say(["Pine-mead. Someone's playing the bard's song about the Heralds, badly.",
         "Hellen has added a verse about the Dagger Reborn. She keeps having to stop.",
         cl(:alerion, "(to Hellen) The verse is good. Keep going."),
         cl(:meat_meat, "Meat Meat has had four coffees. Meat Meat can hear colours."),
         cl(:reptin, "(to the room) She means she's happy. Mostly."),
         al ? "You set down your cup. The rune on your chest is glowing through your shirt." :
              "Alberica sets down her cup. The rune on her chest is glowing through her shirt.",
         "The room goes white. #{al ? 'Only you can move' : 'Only Alberica can move'}."].compact)
    Stage.overlay("O-04", fps: 4, stop_at: 2, fade: 0, wait: true)   # frost in from the edges
    $game_screen.start_tone_change(Tone.new(60, 60, 80, 120), 20) rescue nil
    auril = (Stage.actor(:auril, $game_player.x, $game_player.y - 2, 2, graphic: "FT_auril_furs") rescue nil)
    say(["A woman in frost-furs is sitting across the table. Nobody else can see her.",
         "AURIL: Hear the wheel, and the ones who bind it.",
         "AURIL: The dark half guards silence, a sentinel chained to frost.",
         "AURIL: The light half births flame. And flame consumes as easily as it warms. The spark is spent.",
         "Her breath frosts the table between you.",
         "AURIL: Life and death march only so long as they move. Stop them, and all is mine.",
         "AURIL: And memory keeps the key. Keys open, Alberica. They also lock."])
    # The omens she sent all through the city (048_E): she knows which ones you saw.
    if (counter(:omens_seen) rescue 0).to_i >= 3
      say(["AURIL: You've seen them. Every sign. Frost on his shadow. Vines on her breath. Your own throat, cold.",
           "AURIL: You told no one. That's how I knew you were mine."])
    end
    say(["She leans in.",
         "AURIL: You are my vessel, little songbird. You always were.",
         "AURIL: Guard them if you must. But remember: they cannot escape their fates, and the wheel turns for me.",
         "AURIL: Come and be beautiful forever."])
    Stage.hide(auril) if auril
    Stage.overlay_off("O-04", fade: 20)
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 20) rescue nil
    say(["The room comes back."])
    stage_act(:alberica, :kneel, dx: 1, dy: 0, dir: 2)    # on her knees
    say(["#{al ? 'You are' : 'Alberica is'} on #{al ? 'your' : 'her'} knees. #{herald?(:meat_meat) ? 'You are' : 'Meat Meat is'} holding #{al ? 'your' : 'her'} hands."])
    speak(:alberica, "(hoarse) She's coming. No. She's already here.",
                     "(hoarse) ...Something's pulling me north. Don't make a thing of it.")
    say([cl(:meat_meat, "Meat Meat is making a thing of it.")].compact)
    Stage.cleanup rescue nil
    set_flag(:auril_whisper)
    add_counter(:story_beats)
    pbSEPlay("Earth3") rescue nil
    say(["Far above, at the crown of the tree, something screams.",
         "A dragon."])
    set_switch(SW_CH11_SHRINE, true)
    state[:goal] = "The Shrine of the Twinned Dragons. Now."
    transfer(2061, 12, 33, 8)
  end

  #-----------------------------------------------------------------------------
  # SC 11.02 - The Frost Saint walks; 11.03 - Three hearts
  #-----------------------------------------------------------------------------
  # What Eline carries up to the Shrine depends on what the Heralds did with the
  # Frost Saint Shard in the Heart Chamber (034 scene_heart_choice).
  def saint_heart_lines
    if flag?(:shard_purified)
      ["Eline holds a heart in her hands. It's beating, but there's no light in it at all: only a man's heart, cold and clean.",
       "ELINE: You burned her out of it. We felt it in every shrine in the Dale.",
       "ELINE: It doesn't matter. He kept faith four hundred years with no light to see by. He'll keep it again."]
    elsif flag?(:shard_destroyed)
      ["Eline holds a fistful of ice splinters, threaded together on Halo prayer-wire. They're beating, out of step with each other.",
       "ELINE: You broke her heart. We went down into the roots on our knees and gathered every piece that crawled away.",
       "ELINE: We are very patient."]
    else
      ["Eline holds a blue light in her hands. It's beating: the frost-light heart.",
       "ELINE: When your engine died, the heart fell free. We were waiting.",
       "ELINE: We are very patient."]
    end
  end

  def scene_frost_saint_walks
    set_switch(SW_CH11_SHRINE, false)
    return if flag?(:frostina_taken)
    px, py = ([$game_player.x, $game_player.y] rescue [0, 0])
    sephek = Stage.actor(:sephek, px, py - 3, 2, graphic: "FT_sephek_frozen")
    heart = Stage.fx("E-14", [px - 1, py - 2], oy: 24, loop_from: 0)   # beating in Eline's hands
    frostina = Stage.actor(:frostina, px + 3, py - 3, 4)
    say(["The Shrine is full of Halo robes.",
         "On the dragons' altar lies Sephek's frozen body. The Halo carried it up while the city voted.",
         *saint_heart_lines,
         "She presses it into the hollow in Sephek's chest."])
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
                             "He's standing between them and Frostina, his ring white with frost.",
         as(:alerion, "You don't get her twice."),
         herald?(:meat_meat) ? "(Both arms around Razzilith's neck. He wants to go through them. So do you.)" :
                               "MEAT MEAT: (both arms around Razzilith's neck, holding him back) Not yet, Razzy. Not yet."])
    # The Minor Avatar (rootspire.md Tab 4, 1.1): his followers first; he can't
    # be killed in Rootspire, and he drops a Frostshard Sigil when he breaks.
    sephek_minor_avatar
    say(["The sky above the Canopy tears open.",
         "Through the thinned Wall, a vast white roe comes down out of the night, antlers trailing aurora.",
         "Iskra."])
    if frostina
      Stage.fx("E-04", frostina, frames: 10, hold: true, wait: true, oy: 8)   # the crystal closes over her
      frostina.character_name = "FT_frostina_crystal" rescue nil
    end
    say(["Sephek raises one hand. Ice blooms around Frostina: a crystal, not a cage.",
         "She goes still inside it, her eyes still open.",
         "SEPHEK: (to Alerion, and he means it) I'm sorry. I'm taking her home.",
         "SEPHEK: She was always going home.",
         as(:alerion, "(very quietly) She's not hers."),
         flag?(:eline_captured) ? "Iskra lifts the crystal in her antlers. Sephek climbs onto her back alone. Below, in the root-cords, Eline is still praying backwards." :
                                  "Iskra lifts the crystal in her antlers. Sephek and Eline climb onto her back.",
         "The roe turns north, toward the Sea of Moving Ice, and is gone."])
    Stage.cleanup rescue nil
    down = stage_act(:alerion, :down, dx: 1, dy: 0, dir: 2, per: 6)   # in the snow on the steps
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
    stage_act(:alberica, :kneel, dx: 2, dy: 0, dir: 2) if down
    say([cl(:alberica, "(kneeling, a hand on his back) Then up you get, pretty boy. Slowly.")].compact)
    Stage.pose(down, "P-ALE-03", 0, frames: [3, 2, 1, 0], per: 8) if down   # getting up, slowly
    Stage.cleanup rescue nil
    set_flag(:frostina_taken)
    set_flag(:sephek_risen)
    set_switch(3954, true)            # Frostina is gone from the Shrine
    add_counter(:story_beats)
    scene_three_hearts
  end

  def scene_three_hearts
    say(["LUMIN: (reading an old Wennen text, paws shaking) \"One heart of ice is grief. Two is a burden.\"",
         "LUMIN: \"Three is a summons.\"",
         cl(:alerion, "Shimmer's heart is in Frostina. Sephek's is in Sephek."),
         as(:alberica, "(a hand on her chest) And she wants me for the third."),
         "SELRAE: Solstice. Her island in the Sea of Moving Ice.",
         "SELRAE: She'll pour herself into all three at once, and walk out of there in a body.",
         "SELRAE: The Wennen called it the Rewritten Auril.",
         as(:meat_meat, "Then Meat Meat breaks her."),
         cl(:reptin, "Then we go and get Frostina back."),
         cl(:reptin, "And on the way, we decide what happens to Auril."),
         cl(:wyn, "(quietly) ...Nobody's taking Alberica. I won't let them."),
         with_or_is?(:wyn) ? as(:alberica, "(softly) ...Look at you. My brave little mushroom.") : nil].compact)
    if flag?(:knows_three_hearts)
      say([cl(:reptin, "Luna Carver told us that. Four hundred years ago. Last month.")].compact)
    end
    # Divine Rejuvenation: the Halo seeded the Heartroot with Auril's relics.
    sayc(["SELRAE: (very low) And you saw him get up again. In the snow, after you broke him.",
          "SELRAE: The Halo carried her relics into the Heartroot while I was their prisoner. Three of them. Black ice.",
          "SELRAE: While one of them stands, the Saint stands back up. Every time.",
          cl(:alerion, "Then we break them first."),
          cl(:reptin, "The Root Gate's seal, the Sap Wells, the Overflow Channel. We know those roots. Pleasantly, even.")])
    set_flag(:knows_auril_relics)
    set_flag(:knows_rewritten)
    set_switch(SW_CH11_COUNCIL, true)
    state[:goal] = "Morning. The Council Hall: four chairs, all filled. (Auril's relics wait in the Heartroot: smash them, and Sephek stays down.)"
  end

  #-----------------------------------------------------------------------------
  # SC 11.04 - Four chairs
  #-----------------------------------------------------------------------------
  def scene_four_chairs
    set_switch(SW_CH11_COUNCIL, false)
    return if flag?(:ch11_done)
    say(["KELYN: The Council of four seasons. Its first session."])
    say(["KELYN: The geas is lifted."]) if flag?(:verdict_geas)
    say(["KELYN: Meat Meat's service to the camp waits until she's home."]) if flag?(:verdict_service)
    say(["KELYN: One item."])
    lines = []
    lines << "RHEVEN: The Skytower clan owes Kethan a debt. Griffons. You fly at dawn." if flag?(:council_rheven)
    lines << "MIRA: The Requiem's provisioned. My Corsairs have wanted to sail somewhere frightening for thirty years." if flag?(:council_mira)
    lines << "EIRWEN: I found Grimskalle's plans in the oldest leaves. There's a servants' stair." if flag?(:council_eirwen)
    lines << "EIRWEN: Nobody ever guards the servants' stair." if flag?(:council_eirwen)
    lines << "PHILDENDRIN: Duvessa's people will hold this city. Go. And bring my daughter home." if flag?(:council_phildendrin)
    lines << "ANDUIN: The Wennen will ring the old bell. Something very large will answer." if flag?(:council_anduin)
    say(lines) if !lines.empty?
    four_chairs_consequences if respond_to?(:four_chairs_consequences)
    say([as(:alerion, "(bandaged, standing anyway) I'm coming."),
         cl(:reptin, "You can barely walk."),
         as(:alerion, "I've walked on less. She's mine to watch. I'm not done watching."),
         cl(:meat_meat, "Ice Prince can lean on Meat Meat. Meat Meat is short. It will be funny.")].compact)
    speak(:alberica, "And I'm going. If she wants me, she can ask me to my face.",
                     "...I'm going. She doesn't get to wait for me.")
    say([cl(:reptin, "(sighing) Then I'd better pack something nice. I'm not meeting a god in travel clothes.")].compact)
    # The White Vault thread: Eirwen keeps the second sigil; Sephek dropped the third.
    say(["As the Council rises, Eirwen Solglass pads over, barefoot on the cold floor."])
    eirwen_sigil
    if !try_merge_sigils && !flag?(:sigils_merged)
      say(["EIRWEN: Three sigils point to the White Vault. I've given you mine.",
           "EIRWEN: The Echo Gate's mirror-wraiths keep another. Linger in the Gate, and listen, and they'll come.",
           "(Hold all three Frostshard Sigils together, and they'll show you the way beyond the Auroral Wall.)"])
      set_switch(SW_ECHO_POCKET, true) rescue nil
    end
    set_flag(:ch11_done)
    add_counter(:story_beats)
    state[:goal] = case voyage_route
                   when :ship then "The Boreal Requiem, at the Split Dock in the Root-Tier."
                   when :griffons then "The griffon roost, on the Canopy-Tier."
                   else "The Wennen bell pier, in the Root-Tier."
                   end
    state[:goal] += " (The sigils point beyond the Auroral Wall: the White Vault, past the Glasswater.)" if flag?(:sigils_merged)
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
