#===============================================================================
# Frost & Thaw - Act II, Chapter 7: the Heartroot (the Root Gate and the Sap Wells)
#
# After "Rootspire" Part IV-A, the Heartroot Labyrinth, zones I and II, with
# Part III's Winter Matron Selrae Vorn ("Selrae's Secret"):
#
#   1. The morning after the festival: Selrae is gone, and so is the forged
#      decree. The High Speaker unseals the Root-Gate for her Wardens.
#   2. The Root Gate: the root-spiral, the runic seal circle (align the
#      seasons to tonight's aurora, or wake the Sap Wraith), the Warden's
#      overlook ("She will take the heart if we don't"), the Rootguard post and
#      its enthralled Rootwardens.
#   3. The Sap Wells: golden wells that heal and show visions of Avarice's
#      work, a Vault Map fragment caught in the overflow, the whispering
#      attendant, and Selrae, who calls the Vault "the White Womb".
#===============================================================================
module FrostThaw
  SW_ROOT_GATE = 3937
  SW_SEAL_OPEN = 3938
  SW_SELRAE    = 3939

  MAPS.merge!(root_gate: 2057, sap_wells: 2058)
  MAP_NAMES.merge!(2057 => "Heartroot: the Root Gate", 2058 => "Heartroot: the Sap Wells")
  MAP_METADATA.merge!(
    2057 => { announce_location: true, battle_environment: :Cave },
    2058 => { announce_location: true, battle_environment: :Cave }
  )
  AREAS.merge!(2057 => :heartroot, 2058 => :heartroot)
  ROOT_GATE_ARRIVAL = [2057, 7, 4, 2]

  ENCOUNTERS[2057] = { step_chances: { Cave: 8 },
                       Cave: [[25, :GOLBAT, 38, 40], [20, :TANGELA, 38, 40], [15, :HAUNTER, 38, 40],
                              [15, :PARASECT, 38, 40], [15, :SUDOWOODO, 38, 40], [10, :MISDREAVUS, 39, 41]] }
  ENCOUNTERS[2058] = { step_chances: { Cave: 8 },
                       Cave: [[25, :GOLBAT, 39, 41], [20, :TANGELA, 39, 41], [15, :HAUNTER, 39, 41],
                              [15, :EXEGGCUTE, 39, 41], [15, :MISDREAVUS, 39, 41], [10, :GLOAMCAP, 40, 42]] }

  #-----------------------------------------------------------------------------
  # Trainers
  #-----------------------------------------------------------------------------
  TRAINER_TYPES.merge!(
    FT_WINTER_MATRON: ["Winter Matron", :CHANNELER, 1, 180, :LEADER_Pryce]
  )
  TRAINERS.merge!(
    thrall_oren: [:FT_ROOTWARDEN, "Oren", [[:VICTREEBEL, 39], [:B42H189, 40]],
                  "...Where... where am I? The sap was singing. It was singing my name."],
    thrall_mae:  [:FT_ROOTWARDEN, "Mae",  [[:B103H200, 39], [:PILOSWINE, 40]],
                  "I was guarding the gate. Then I was guarding HER. Who did I say I was guarding?"],
    selrae:      [:FT_WINTER_MATRON, "Selrae", [[:B124H200, 40], [:B131H225, 41], [:B221H215, 42]],
                  "Winter yields. As it should. As it always must, in the end.", [:HYPERPOTION, :HYPERPOTION]]
  )

  #-----------------------------------------------------------------------------
  # Dialogue
  #-----------------------------------------------------------------------------
  TEXT.merge!(
    seal_open: ["The four runes glow softly in turn, and the braided-root door stands open."],
    root_door_shut: ["A door of braided roots, each thick as your arm, woven shut. Sap beads on it like sweat.",
                     "Behind it, something knocks. Slowly. Like a heartbeat."],
    warden_overlook: ["A balcony of root bone curves out over a dark drop.",
                      "Far below, something glows, faint and golden.",
                      "The railing is covered in tally marks. Dozens. Hundreds.",
                      "Under them, cut deep in two scripts: \"SHE WILL TAKE THE HEART IF WE DON'T.\""],
    rootguard_post: ["A cramped guardroom: bark-fibre bunks, a brazier of sizzling sap still warm.",
                     "On the rack, tools etched with infernal script. Not Rootwarden tools.",
                     "Someone else's tools, borrowed by Rootwarden hands."],
    thrall_oren_after: ["I can still hear it. Down there.", "Like a heart, if a heart could want things."],
    thrall_mae_after: ["Go on. Go down. Somebody has to.", "I can't make my feet do it anymore."],
    fragment_taken: ["Only a clear smear of sap is left where the map fragment was."],
    selrae_after: -> { flag?(:selrae_ahead) ? ["Selrae's footprints lead deeper, into the frost-grown roots.", "Frost follows them."] :
                                              ["Where Selrae sat, the root is still rimed with frost in the shape of her hands."] }
  )

  PARTY_CHAT[:alberica].merge!(
    heartroot: [{ if: { flag: :selrae_faced }, lines: ["'The White Womb.' She said it like a prayer.",
                                                        "I'd like to never hear anyone say it like that again, sweetheart."] },
                ["It's like walking inside a song that's forgotten its words.", "The tree's still humming the tune. Badly. I could help."]]
  )
  PARTY_CHAT[:reptin].merge!(
    heartroot: ["'Growth,' the Council calls me. This is growth too.", "It's growing toward something. And it's hungry. Charming."]
  )
  PARTY_CHAT[:alerion].merge!(
    heartroot: ["Avarice built machines that dream.", "If they're down here, they're dreaming about us."]
  )
  PARTY_CHAT[:shade].merge!(
    heartroot: ["Every drop of sap sounds like a footstep. I've turned round nine times.", "Nobody's there. Yet."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # The morning after: Kelyn unseals the Root-Gate
  #-----------------------------------------------------------------------------
  def ch7_council(event_id = nil)
    if !flag?(:ch7_started)
      say(["KELYN: The aurora touched the tree tonight, and the tree held. Because of you.",
           "DARRUS: The Halo are off the streets. Var's still missing. And somebody still signed that decree.",
           "KELYN: The festival runs to its seventh night. Come to the Hearth for the last one.",
           "KELYN: The whole city will be there.",
           cl(:alberica, "A party in our honour? Speaker, you shouldn't have. I'll be there early."),
           with_or_is?(:alberica) ? cl(:reptin, "(smoothly) She means thank you. And she will be there early.") : nil].compact, event_id)
    elsif flag?(:selrae_home)
      say(["KELYN: Selrae told us. All of it. Thirty years of letting the Halo in, for a little winter.",
           "KELYN: She'll answer for it at the Trials.",
           "KELYN: You found her, and you brought her home. Thank you for that."], event_id)
    else
      say(["KELYN: Find Var. Find what's burning. There are two ways down.",
           "KELYN: Wyn's Sap Gate in the Root-Tier, or Hew's dig and the Split Dock.",
           "DARRUS: (not looking up) And watch what you sign for, down there."], event_id)
    end
  end

  # (the Root-Gate event takes you down itself, right after this)
  def root_gate_descend(event_id = nil)
    aurora_hue
    say(["The Rootwardens' willow seal lies cut on the ground.",
         "Warm air rises out of the well: sap, and old ice.",
         "A stair of living root spirals down into the dark. You climb over the fence and go down."], event_id)
  end

  #-----------------------------------------------------------------------------
  # The Root Gate
  #-----------------------------------------------------------------------------
  def scene_heartroot_enter
    return if flag?(:heartroot_entered)
    set_flag(:heartroot_entered)
    add_counter(:story_beats)
    hue = aurora_hue
    say(["The stairwell breathes. Sap drips from the ceiling in slow amber tears.",
         "Each drop hits the roots below with the sound of a heartbeat.",
         "The air goes warm, then cold, as if the seasons can't agree whose turn it is.",
         "Somewhere ahead, water whispers against glass.",
         "Faint aurora trickles down through hairline cracks. #{HUE_WORDS[hue][0]}, tonight: #{HUE_WORDS[hue][1]}'s colour.",
         cl(:alerion, "Tonight's aurora is #{HUE_WORDS[hue][0].downcase}. Remember that. Places like this always ask."),
         with_or_is?(:alerion) ? cl(:reptin, "He means: everyone, please take notes.") : nil,
         with_or_is?(:alerion) && with_or_is?(:reptin) ? cl(:alerion, "I meant remember it.") : nil,
         cl(:wyn, "(very softly) ...The tree's frightened. Sorry. I just... thought someone should say.")].compact)
  end

  SEASON_RUNES = {
    spring: "The Rune of Spring bleeds green sap. It's warm to the touch.",
    summer: "The Rune of Summer bleeds gold sap. It's hot as a stone in the sun.",
    autumn: "The Rune of Autumn bleeds red sap, thick and slow.",
    winter: "The Rune of Winter bleeds white sap that freezes as it runs."
  }
  CYCLE = %i[spring summer autumn winter]
  # The city's dawn hue (Part I's Cycle Pulse): green spring, gold summer, red autumn, white winter.
  HUE_WORDS = { spring: ["Green", "Spring"], summer: ["Gold", "Summer"], autumn: ["Red", "Autumn"], winter: ["White", "Winter"] }

  # Tonight's aurora, chosen once per save (Spring for saves from before the puzzle).
  def aurora_hue
    state[:aurora_hue] ||= (flag?(:heartroot_entered) ? :spring : CYCLE[rand(4)])
  end

  # The order the runes must be pressed: begin where the sky begins, turn as the year turns.
  def rune_answer
    i = CYCLE.index(aurora_hue)
    CYCLE.rotate(i)
  end

  def season_rune(season, event_id = nil)
    say([SEASON_RUNES[season]], event_id)
    return if flag?(:seal_open)
    seq = (state[:rune_seq] ||= [])
    if seq.include?(season)
      return say(["The rune is already glowing, waiting for the others."])
    end
    return if !pbConfirmMessage(_INTL("Press your palm to the rune?"))
    seq << season
    pbSEPlay("Saint1") rescue nil
    say(["The rune lights under your hand, and its sap runs bright down the channel toward the centre."])
    return if seq.size < 4
    state[:rune_seq] = []
    if seq == rune_answer
      say(["Four colours of sap meet in the hollow at the centre.",
           "They climb the thread of aurora like ivy up a wall, in order, round and round.",
           "The circle sighs. Below you, the braided-root door unknots itself, root by root.",
           cl(:meat_meat, "Puzzle beaten. Meat Meat would like that on the wall too.")].compact)
      open_seal
    elsif !flag?(:sap_wraith_fought)
      say(["The sap runs into the hollow in the wrong order. It boils. It rises. It stands up.",
           "A shape of sap and splinters pulls itself out of the circle, mouth full of amber.",
           "It screams with the tree's voice!"])
      return if !boss_battle(named_mon(:B93H114, 40, "Sap Wraith"))
      set_flag(:sap_wraith_fought)
      set_flag(:sap_wraith_vision)
      say(["The Sap Wraith bursts like a seed-pod. For an instant you see through its eyes:",
           "a white room under the ice. Rows of glass. Something in the glass that has your faces.",
           "Then it's gone, and the four runes go dark again.",
           "The circle is waiting to be asked properly."])
    else
      say(["The sap tangles in the hollow, hisses, and drains away. The four runes go dark.",
           "The circle is waiting to be asked properly."])
    end
  end

  def open_seal
    set_flag(:seal_open)
    ($game_switches[SW_SEAL_OPEN] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
  end

  def rune_seal(event_id = nil)
    return say(["The four runes glow softly in turn, and the braided-root door stands open."], event_id) if flag?(:seal_open)
    hue = aurora_hue
    say(["A circle of bare heartroot, carved with four seasonal runes. Each bleeds a different colour of sap.",
         "At the centre, a hollow where the colours could meet.",
         "Above it, a crack in the roof lets in a thread of aurora: #{HUE_WORDS[hue][0].downcase}.",
         "Round the rim, in Druidic and in Wennen:",
         "BEGIN WHERE THE SKY BEGINS. TURN AS THE YEAR TURNS."], event_id)
    seq = state[:rune_seq] || []
    if !seq.empty?
      say(["#{seq.size == 1 ? 'One rune is' : "#{seq.size} runes are"} glowing: #{seq.map { |k| HUE_WORDS[k][1] }.join(', ')}."])
      if pbConfirmMessage(_INTL("Let the runes go dark and start again?"))
        state[:rune_seq] = []
        say(["The glowing runes dim, one by one."])
      end
    end
  end

  #-----------------------------------------------------------------------------
  # The Sap Wells
  #-----------------------------------------------------------------------------
  def scene_sap_wells_enter
    return if flag?(:sap_wells_entered)
    set_flag(:sap_wells_entered)
    say(["A low arch of roots opens onto a cavern. Golden sap rains from the ceiling in thin strands.",
         "It fills shallow basins. Some of them glow with the aurora's reflection.",
         "The air smells like honey left too long in the sun.",
         cl(:alberica, "Oh, that's indecent. Somebody hold my hair, I'm going to drink a wall."),
         with_or_is?(:alberica) ? cl(:wyn, "Please... please don't drink the wall.") : nil].compact)
  end


  def map_fragment(event_id = nil)
    return talk(:fragment_taken, event_id) if flag?(:vault_map_1)
    say(["Caught in a lump of congealed sap on the far wall: a scrap of hide.",
         "It's painted with lines of frost that won't melt."], event_id)
    set_self_switch(event_id, "A")
    set_flag(:vault_map_1)
    add_counter(:story_beats)
    say(["A fragment of a map. The Heartroot, and under it, something drawn in white.",
         cl(:alberica, "That's the map I saw in the well. One piece of it."),
         cl(:alberica, "There'll be more, darling. There always are."),
         cl(:alerion, "Keep it dry.")].compact)
  end


  def apply_chapter7_switches
    return if !active? || !$game_switches
    sync_switch(SW_ROOT_GATE, flag?(:ch7_started))
    sync_switch(SW_SEAL_OPEN, flag?(:seal_open))
    sync_switch(SW_SELRAE, flag?(:selrae_faced))
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter7_switches
  rescue StandardError => err
    FrostThaw.log("Chapter 7 switches failed: #{err.message}")
  end
}
