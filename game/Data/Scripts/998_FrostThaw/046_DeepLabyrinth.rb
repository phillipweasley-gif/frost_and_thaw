#===============================================================================
# Frost & Thaw - Act II, Chapter 7, Road B continued: the Heartroot Labyrinth's
# lower zones (after "Rootspire" Part IV-A, the Heartroot Labyrinth, and Tab 3's
# H1-H37 overlay and monster index)
#
# Below the Sap Wells, behind the knotted heart-wall Selrae's Root-Key opens:
#   H35 The Captain's Alcove (Root Gate): glyph-maps of the six zones.
#   Zone III, the Mirror Garden (2140): H9 the Petaled Threshold, H10 the
#     Reflection Ring (your worst selves; the Mirror Clones; a Verdant Seed),
#     H11 the Shattered Bed (a lodged shard Avarice can see through; the Mirror
#     Shard Focus), H12 the Perfume Grotto (Lirielle's old seeding; a rest).
#   Zone IV, the Hollow Core (2141-2142): H13 the Upper Root Bridge and its
#     sentries, H14 the Sap Burst Crossways, H15 the Cocoon Gallery (the pale
#     sovereign; the captive who warns of the Vault), H16 the Frozen Drop (the
#     time-lapse field; the mephit swarm), H17 the Underdark Mouth, H34 the
#     Lizard Nursery, H27 the Root-Kin Barracks.
#   Zone V, the Vault of Amber Dreams (2143-2144): H18 the Amber Threshold, H19
#     the Stasis Gallery (the Homunculus Core; the lab notes; the Temporal
#     Surge), H20 the Dissectory Annex (the cataloguer; the notes on binding
#     Auril; Autumn's crates), H28 the Suffering Pods, H21 the Mirror Scriptory
#     (the Mirror-Ink Wraith; Avarice's war-room; the glass sigil for the forge
#     door), H29 the Guest Seed Nests, H31 the Devil's Bloom, H30 the Root-Lift
#     Node (down to the door of iron and glass).
#   The Mirror-Root Vault (2145), Tab 1's H3: the broken ice mask (Avarice's
#     first homunculus, a failed vessel for Auril), the Mirror Sentinels, the
#     clue to Ithryn Athis, and the pit of liquid mirror: thirty years back, to
#     the night Avarice took Var Rime-Breaker. His echo tests Alerion.
# Zone VI (the Antechapel to the Echo Vault) is part of the Forge, Chapter 8
# (047's neighbour 046_ForgeRooms.rb).
#===============================================================================
module FrostThaw
  SW_HEARTWALL     = 4080   # the knotted heart-wall in the Sap Wells is open
  SW_RING_DONE     = 4081   # the Reflection Ring's petal-gate is open
  SW_BARRACKS_DONE = 4082   # the Root-Kin Barracks are dealt with: the stair down is clear
  SW_LIFT_NODE     = 4083   # the Root-Lift Node runs: its cage stands beside the forge door too
  SW_AMBER_PODS    = 4085   # the Amber Threshold's sap-sentries are broken

  MAPS.merge!(mirror_garden: 2140, hollow_upper: 2141, hollow_lower: 2142, amber_vault: 2143, scriptory: 2144, mirror_root: 2145)
  MAP_NAMES.merge!(
    2140 => "Heartroot: the Mirror Garden", 2141 => "Heartroot: the Hollow Core", 2142 => "Heartroot: the Frozen Drop",
    2143 => "Heartroot: the Vault of Amber Dreams", 2144 => "Heartroot: the Mirror Scriptory", 2145 => "Heartroot: the Mirror-Root Vault"
  )
  [2140, 2141, 2142, 2143, 2144, 2145].each { |m| MAP_METADATA[m] = { announce_location: true, battle_environment: :Cave } }
  AREAS.merge!(2140 => :heartroot, 2141 => :heartroot, 2142 => :heartroot, 2143 => :heartroot, 2144 => :heartroot, 2145 => :heartroot)
  HEARTWALL_ARRIVAL = [2140, 4, 4, 2]
  GROTTO_REST       = [2140, 37, 18, 8]
  LIFT_NODE_FOOT    = [2066, 18, 19, 4]     # beside the door of iron and glass, in the Guild Dig
  LIFT_NODE_TOP     = [2144, 21, 20, 2]

  ENCOUNTERS[2140] = { step_chances: { Cave: 7 },
                       Cave: [[25, :MISDREAVUS, 42, 44], [20, :SABLEYE, 42, 44], [20, :MRMIME, 42, 44],
                              [15, :BANETTE, 43, 45], [10, :FROSLASS, 43, 45], [10, :JYNX, 43, 45]] }
  ENCOUNTERS[2141] = { step_chances: { Cave: 6 },
                       Cave: [[30, :GOLBAT, 42, 44], [25, :TANGELA, 42, 44], [20, :PARASECT, 43, 45],
                              [15, :SKARMORY, 43, 45], [10, :SUDOWOODO, 43, 45]] }
  ENCOUNTERS[2142] = { step_chances: { Cave: 6 },
                       Cave: [[30, :GOLBAT, 43, 45], [25, :SNEASEL, 43, 45], [20, :PILOSWINE, 43, 45],
                              [15, :SWINUB, 44, 46], [10, :GLALIE, 44, 46]] }
  ENCOUNTERS[2143] = { step_chances: { Cave: 6 },
                       Cave: [[30, :HAUNTER, 44, 46], [25, :GOLETT, 44, 46], [20, :BANETTE, 44, 46],
                              [15, :HYPNO, 45, 47], [10, :DUSCLOPS, 45, 47]] }
  ENCOUNTERS[2144] = { step_chances: { Cave: 6 },
                       Cave: [[30, :HAUNTER, 44, 46], [25, :MISDREAVUS, 44, 46], [20, :GENGAR, 45, 47],
                              [15, :HOUNDOOM, 45, 47], [10, :KECLEON, 45, 47]] }

  #-----------------------------------------------------------------------------
  # Trainers
  #-----------------------------------------------------------------------------
  TRAINER_TYPES.merge!(
    FT_MARSHAL:     ["Summer Marshal", :ROUGHNECK, 0, 160, :LEADER_Brock],
    FT_MIRRORCLONE: ["Mirror Clone", :CHANNELER, 0, 0, :LEADER_Pryce]
  )
  TRAINERS.merge!(
    sapwarden_captain_hesk: [:FT_ROOTWARDEN, "Captain Hesk", [[:B42H217, 41], [:B71H200, 41], [:B266H59, 42]],
                             "The glyphs... I drew these maps for HER. For whatever's down there. I don't remember being asked."],
    sapwarden_tamsk: [:FT_ROOTWARDEN, "Sap-Warden Tamsk", [[:B71H185, 43], [:B42H266, 43]],
                      "The bridge holds. I held it. Who was I holding it for?"],
    sapwarden_irrel: [:FT_ROOTWARDEN, "Sap-Warden Irrel", [[:B185H71, 43], [:B227H185, 44]],
                      "My arms are full of sap. I can't feel my bowstring. I can't feel anything."],
    sapwarden_vesk:  [:FT_ROOTWARDEN, "Sap-Warden Vesk", [[:B266H42, 44], [:B439H71, 44]],
                      "Push them to the edge, she said. Push them to the edge. ...Which edge?"],
    duergar_miner_gelt: [:FT_DUERGAR, "Gelt", [[:GRAVELER, 44], [:B76H217, 44], [:MAGCARGO, 45]],
                         "We dug her a road to the deep. She paid us in fire."],
    duergar_spy_ossk: [:FT_DUERGAR, "Ossk", [[:B262H338, 45], [:B215H229, 45], [:B338H262, 46]],
                       "You weren't supposed to see me. Nobody's ever supposed to see me."],
    var_echo: [:FT_MARSHAL, "Var", [[:B227H327, 44], [:B59H217, 44], [:B68H208, 45], [:B329H59, 46]],
               "Ha! There it is. Winter in a man's hands, and the man still standing.", [:HYPERPOTION]]
  )
  TRAINER_INTROS.merge!(
    sapwarden_captain_hesk: "CAPTAIN HESK: Halt. This is a Rootwarden post. ...Isn't it?",
    sapwarden_tamsk: "SAP-WARDEN TAMSK: Nobody crosses the bridge. Nobody. Not even me.",
    sapwarden_irrel: "SAP-WARDEN IRREL: Loose! Loose! ...Why won't my hands loose?",
    sapwarden_vesk: "SAP-WARDEN VESK: The vines are hungry. Feed them a hero.",
    duergar_miner_gelt: "GELT: Topsiders in the deep mouth? Turn round. The dark's already spoken for.",
    duergar_spy_ossk: "OSSK: (stepping out of the roots, a knife of black glass in each hand) Ah. Inconvenient.",
    var_echo: "VAR: Come on, then. Show me winter can be held.",
    rootkin_sleepers: "SAP-SOLDIER: (groggy, swinging wild) Wha... who... GET THEM!",
    rootkin_soldiers: "SAP-SOLDIER: Awake. All of us. Good. Let's do this properly."
  )

  #-----------------------------------------------------------------------------
  # Dialogue
  #-----------------------------------------------------------------------------
  TEXT.merge!(
    sapwarden_captain_hesk_after: ["The maps are on the desk. Take them. I don't want to look at them anymore."],
    sapwarden_tamsk_after: ["I can feel my fingers again. That's... that's the worst part, actually."],
    sapwarden_irrel_after: ["Far below, the frozen sap glows like trapped lightning.", "I've been staring at it for days. It stares back."],
    sapwarden_vesk_after: ["The vines only take the ones who stop moving.", "Keep moving."],
    duergar_miner_gelt_after: ["Tell the deep road I'm sorry I opened it.", "No. Don't tell it anything. It listens."],
    duergar_spy_ossk_after: ["The guest-nests were for her friends. She has more friends than you'd think.", "Most of them are very warm."],
    grotto_mirror: ["The mirrors here are fogged, soft as breath on a window.", "Nothing looks back. It's the kindest mirror in the Heartroot."],
    root_ladder: ["A root-ladder dangles down the drop, knotted every arm's length.", "Wind rises from below: warm one breath, bitterly cold the next."],
    underdark_spoor: ["Claw-marks as wide as a door, gouged into the stone.", "Whatever made them was going up. Toward the Forge."],
    underdark_mouth: -> {
      ["A side tunnel breaks off from the shaft. The air in it is thicker and older.",
       "Beyond, the darkness tastes of stone and mushrooms, not sap and wood: the true Underdark, past the tree's reach.",
       herald?(:wyn) ? "(Your old post was the door to this. ...This is the back of the door.)" :
         (with_or_is?(:wyn) ? "WYN: (very quietly) My post was the door to that. At the Gate. ...This is the back of the door." : nil),
       "(The tunnel runs on, deeper than any lantern. Not today.)"].compact
    },
    root_pen: ["Root-pens, woven from living wood. Bark-mottled scales on the rails where something rubs."],
    barracks_bunks: ["Bunks of woven bark, weapon racks of sap-hardened wood. This is where the sap-soldiers sleep."],
    barracks_stair: ["The stair down is full of sleeping sap-soldiers' kit and boots. You'd have to wake them, or deal with them, to get through."],
    amber_chant: ["Inside the pod, a silhouette with its mouth open.", "The low chant is coming from all of them at once: Auril's name, bent wrong by something hellish."],
    homunculus_remains: ["A heap of melted glass and frozen sap, roughly the size of a woman.",
                         "Something was grown here, and didn't take."],
    lift_roots: ["A vertical root-cage hangs in a shaft. When the sap runs, it rises and falls like a lung."],
    guest_nest_second: ["A second seed-pod nest, grown soft as a bed. Red silk threads snagged on the thorns.",
                        "Someone with horns slept here. Someone with horns does not sleep well."]
  )

  PARTY_CHAT[:alberica].merge!(
    mirror_garden: ["Every flower in here wants to show me something I did.", "I'd rather they showed me something I'm going to do. Something fun."]
  ) if PARTY_CHAT[:alberica]
  PARTY_CHAT[:alerion].merge!(
    mirror_garden: ["Don't look at the petals.", "...I looked."]
  ) if PARTY_CHAT[:alerion]
  PARTY_CHAT[:reptin].merge!(
    mirror_garden: ["The wolf doesn't like these flowers.", "For once, I agree with him."]
  ) if PARTY_CHAT[:reptin]

  # Each petal of the Reflection Ring shows somebody's worst self.
  WORST_SELVES = {
    alberica: "Alberica, frost-white, on a throne of ice. Everyone she loves stands round her, smiling, perfectly still. Forever.",
    reptin: "Reptin, all wolf, standing over a sapling with its bark in his teeth. He isn't sorry.",
    alerion: "Alerion in a warm house with the door locked. A boy's coat on the peg. A necromancer's candle burning, and burning.",
    meat_meat: "V-7 on the cold table, eyes empty, a blade of thought in each hand, waiting to be told who.",
    glimmer: "A cat-man with a cold blue dagger, walking away from a girl in the snow. He doesn't look back.",
    wyn: "Wyn's bench at the Sap Gate, empty. Somewhere far away, Wyn, not coming back. Not even sorry.",
    you: "You, standing just outside every story, watching. Not helping. Not once."
  }

  module_function

  #-----------------------------------------------------------------------------
  # H35 - The Captain's Alcove (the Root Gate)
  #-----------------------------------------------------------------------------
  def captains_alcove(event_id = nil)
    say(["A captain's nook off the guard post: a root-desk, a lamp of sap, a stool worn smooth.",
         "Spread on the desk, tactical glyph-maps of the Heartroot, drawn in a careful Rootwarden hand."], event_id)
    return if flag?(:labyrinth_mapped)
    set_flag(:labyrinth_mapped)
    add_counter(:story_beats)
    say(["The Root Gate. The Sap Wells. And under them, more than anyone up top ever mapped:",
         "a garden of mirrors; a hollow core with bridges over a frozen lake; a vault of amber;",
         "and at the bottom, drawn over and over until the pen tore through: a heart.",
         "In the margin: \"Six zones. She lives in the sixth.\""])
    sayc([cl(:alerion, "Six. We've done two."),
          cl(:meat_meat, "Meat Meat counts four more. Meat Meat will need snacks."),
          cl(:wyn, "(tracing the heart with one finger) ...It's drawn like it's beating.")])
    state[:goal] = flag?(:root_key) ? "The knotted heart-wall in the Sap Wells: the Root-Key, and the zones below." : state[:goal]
  end

  #-----------------------------------------------------------------------------
  # The knotted heart-wall (Sap Wells) and the door of iron and glass
  #-----------------------------------------------------------------------------
  def heart_wall(event_id = nil)
    if !flag?(:root_key)
      return say(["The roots here are knotted tight as a fist. Behind them something beats, slow and enormous.",
                  "Warm air comes through the gaps, and with it, very faint, the smell of forge smoke.",
                  "In the middle of the knot, half grown over: a keyhole of black ice."], event_id)
    end
    if !flag?(:heartwall_open)
      say(["The Root-Key fits the keyhole of black ice. It turns as if the roots wanted it to.",
           "The knot loosens, root by root, like a fist opening.",
           "Beyond, a low grove. Flowers bloom from the walls. Every one of them has a mirror at its heart."], event_id)
      sayc([flag?(:selrae_ahead) ? cl(:alerion, "Frost on the roots. Selrae came this way.") : nil,
            cl(:reptin, "After you, darling. No, really. After you."),
            cl(:alberica, "Coward."),
            cl(:reptin, "Diplomat.")])
      set_flag(:heartwall_open)
      ($game_switches[SW_HEARTWALL] = true; $game_map.need_refresh = true if $game_map) if $game_switches
      add_counter(:story_beats)
      state[:goal] = "Down through the Heartroot's lower zones: the Mirror Garden, the Hollow Core, the Vault of Amber Dreams."
    else
      say(["The heart-wall stands open. Below, the mirror-flowers wait."], event_id)
    end
    transfer(*HEARTWALL_ARRIVAL)
  end

  # The door at the bottom of Hew's last ladder: iron (the Root-Key) and glass
  # (the sigil Avarice etched in her Scriptory).
  def labyrinth_forge_door(event_id = nil)
    if flag?(:root_key) && !flag?(:glass_sigil) && !flag?(:road_b_done)
      say(["A door of iron and mirror glass, fused into the living root.",
           "The Root-Key turns in the iron half, and the iron gives.",
           "The glass half doesn't. It has no keyhole: only a sigil etched into the pane, like frost that's been taught to write."], event_id)
      sayc([cl(:alerion, "Two locks. Iron and glass."),
            cl(:alberica, "Whoever wrote that sigil lives below the Sap Wells, sweetheart. I'd bet my good boots."),
            flag?(:heartwall_open) ? nil : "(Selrae's key opened the iron. Maybe it opens something else down there: the knotted wall in the Sap Wells.)"])
      state[:goal] = "The glass half of the door: somewhere below the Sap Wells. (The Root-Key opens the knotted heart-wall.)"
      pbMoveRoute($game_player, [PBMoveRoute::Backward]) rescue nil
      return
    end
    if flag?(:glass_sigil) && !flag?(:glass_door_open)
      set_flag(:glass_door_open)
      say(["You hold the sealed crystal to the pane. The sigil inside it turns once and matches the one in the glass.",
           "The glass goes soft as water, then clear."])
    end
    forge_door(:b, event_id)
  end

  #-----------------------------------------------------------------------------
  # Zone III - The Mirror Garden
  #-----------------------------------------------------------------------------
  def scene_mirror_garden_enter
    return if flag?(:mirror_garden_entered)
    set_flag(:mirror_garden_entered)
    add_counter(:story_beats)
    say(["The tunnel widens into a low grove where root-flowers bloom from the walls, each with a mirror at its centre.",
         "These first blossoms are dull and cracked. They reflect only vague silhouettes."])
    sayc([cl(:wyn, "Hyphora never grew these. Somebody planted them. On purpose."),
          cl(:meat_meat, "Meat Meat does not trust flowers with faces."),
          cl(:alberica, "Darling, you don't trust flowers without faces either.")])
  end

  # H9: the reflections lag by a heartbeat.
  def petaled_threshold(event_id = nil)
    say(["You lean close to a mirror-flower. Your reflection leans close too...", "...a heartbeat late."], event_id)
    return if flag?(:reflection_lag)
    set_flag(:reflection_lag)
    sayc([cl(:alerion, "It's lagging."),
          cl(:glimmer, "Seven years behind a mirror. Trust me: don't stare. It starts to think it's the one in front."),
          cl(:reptin, "Noted. Eyes front, everyone.")])
  end

  # H10: the petals round the ring.
  def reflection_petal(event_id = nil)
    order = ([herald || :you] + companions).uniq
    i = (state[:petal_look] = ((state[:petal_look] || -1) + 1)) % order.size
    who = order[i]
    say(["A mirror-petal turns toward you like a face toward the sun.", "In it:", WORST_SELVES[who] || WORST_SELVES[:you]], event_id)
    say(["(It's you. It's the you that could still happen.)"]) if who == herald || (who == :you && journey?)
  end

  def reflection_ring(event_id = nil)
    return say(["The petal-gate stands open. The ring's flowers have turned their faces to the wall."], event_id) if flag?(:ring_done)
    say(["A circular chamber, ringed by mirror-petaled flowers. Each one turns to follow you.",
         "In every petal, one of you. The worst one.",
         "At the far side, a gate of woven petals. To reach it, you'd have to cross the ring."], event_id)
    sayc([cl(:alerion, "Don't look at them."),
          cl(:alberica, "Bit late for that, pretty boy.")])
    c = pbMessage(_INTL("Cross the Reflection Ring..."), [_INTL("Without looking"), _INTL("Looking")], 0)
    if c == 0
      quiet = [with_or_is?(:wyn), with_or_is?(:reptin), with_or_is?(:alerion)].count(true)
      say(["Heads down. Eyes on your feet. One step, then another, the petals whispering your names."])
      if quiet >= 2
        say([with_or_is?(:wyn) ? "Wyn's shadow goes ahead of you, and the petals can't find your faces in it." :
                                 "Nobody looks up. Not once. The petals whisper themselves hoarse.",
             "You reach the petal-gate. It parts for you, sulking."])
        sayc([cl(:meat_meat, "Meat Meat peeked. Only one eye. It does not count.")])
        return open_reflection_ring(false)
      end
      say(["Halfway across, someone looks up. Just for a second. Just to check.",
           "Every petal in the ring opens at once."])
    else
      say(["You look. All of you look. Somebody has to.", "Every petal in the ring opens at once."])
    end
    say(["Out of the petals step your reflections: you, all of you, the worst of you, and they're smiling."])
    return if !mirror_clone_battle
    say(["The last reflection cracks across its smile and falls to pieces of petal.",
         "Where it stood, something green has pushed up through the broken glass: a seed, pulsing like a heartbeat."])
    give(:FT_VERDANTSEED)
    sayc([cl(:reptin, "I'm going to need a drink. And then another drink. And then a nap."),
          cl(:alberica, "(very quietly) Did anyone else's look like it was enjoying itself?"),
          cl(:alerion, "Mine.")])
    open_reflection_ring(true)
  end

  def open_reflection_ring(fought)
    set_flag(:ring_done)
    set_flag(:mirror_clones_beaten) if fought
    ($game_switches[SW_RING_DONE] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
  end

  # The Mirror Clones: every one of your Pokémon, mirrored, a little weaker.
  def mirror_clone_battle
    mons = $Trainer.party.reject { |pk| pk.egg? rescue false }.first(6).map do |pk|
      { species: pk.species, level: [pk.level - 2, 1].max, moves: pk.moves.map(&:id) }
    end
    type, name = :FT_MIRRORCLONE, "Your reflections"
    hash = { id: [type, name, 0], id_number: 9680, trainer_type: type, name: name, version: 0, items: [],
             lose_text: "(Your reflection's mouth moves. It says what you say, a heartbeat late.)", pokemon: mons }
    GameData::Trainer::DATA[[type, name, 0]] = GameData::Trainer.new(hash)
    pbTrainerBattle(type, name, nil, false, 0) ? true : false
  rescue StandardError => e
    log("mirror_clone_battle failed: #{e.message}")
    false
  end

  # H11: the Shattered Bed.
  def shattered_step(event_id = nil)
    if !flag?(:bed_pace_chosen)
      set_flag(:bed_pace_chosen)
      say(["The mirrors here have been shattered and melted into jagged glass-roots in the floor.",
           "Each step sends little reflections sliding across the walls: tiny, broken copies of all of you."])
      c = pbMessage(_INTL("Cross the Shattered Bed..."), [_INTL("Slowly, picking every step"), _INTL("Quickly, before it notices")], 0)
      if c == 0
        set_flag(:bed_slow)
        return say(["You go slowly, toe to heel, the way Reptin walks through a sleeping pack.",
                    "The glass-roots creak. Nothing cuts."])
      end
    end
    return say(["You pick your way across. The glass-roots creak, and hold."]) if flag?(:bed_slow)
    lead = $Trainer.first_able_pokemon rescue nil
    if lead
      lead.hp = [lead.hp - [lead.totalhp / 8, 1].max, 1].max
      say(["Glass-roots snap under your boots. #{lead.name} yelps: a long, thin cut."])
    end
    return if flag?(:avarice_shard_lodged) || !flag?(:bed_cut_once)
    set_flag(:avarice_shard_lodged)
    say(["A splinter of mirror lodges in your palm. You pull it out. You're sure you pull it out.",
         "For one heartbeat, from very far away, someone else is looking out of your hand."])
    sayc([cl(:glimmer, "...Did anyone else just feel watched?"),
          cl(:alerion, "Always.")])
  ensure
    set_flag(:bed_cut_once) if !flag?(:bed_slow) && flag?(:bed_pace_chosen)
  end

  def shard_focus(event_id = nil)
    return say(["Glass-roots, picked clean. You've taken the only shard worth taking."], event_id) if flag?(:shard_focus_found)
    say(["Among the glass-roots, one shard is whole: a clean, flat mirror the size of a palm.",
         "It shows the room a little more clearly than the room really is."], event_id)
    if !flag?(:bed_slow)
      return if !pbConfirmMessage(_INTL("Dig it out, slowly and carefully?"))
      set_flag(:bed_slow)
    end
    say(["You work it free, a hair at a time. It doesn't cut you. It seems almost grateful."])
    give_key(:FT_SHARDFOCUS)
    set_flag(:shard_focus_found)
  end

  # The Mirror Shard Focus sees true once.
  def use_shard_focus
    return false if !flag?(:shard_focus_found) || flag?(:shard_focus_used)
    set_flag(:shard_focus_used)
    say(["You hold up the Mirror Shard Focus. In it, the room is plainer than the room: every line where it really runs.",
         "Then the shard clouds over, used up. It's just glass now."])
    true
  end

  # H12: the Perfume Grotto, a safe rest niche.
  def perfume_grotto(event_id = nil)
    say(["A small alcove of moss and fragrant blooms: an echo of Lirielle Mossdancer's work, seeded ages ago.",
         "The air is warm and soothing. The mirrors here are fogged rather than harsh."], event_id)
    return if !pbConfirmMessage(_INTL("Rest a while in the grotto?"))
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_rest_at(GROTTO_REST)
    say(["You sleep an hour on the moss. Your Pokémon curl round you.", "When you wake, you're not afraid of mirrors. For a while."])
    if !flag?(:grotto_boon)
      set_flag(:grotto_boon)
      sayc(["There's a scent on the air you know: the perfume stalls in the Verdant Bazaar, where the moss-dancer sells her bottles.",
            cl(:alberica, "Lirielle's. Ten gold a bottle and worth twelve. She planted this, didn't she? Ages ago."),
            cl(:wyn, "(breathing it in) ...She dreams of roots burning. Maybe she dreamed this place too. To have somewhere safe."),
            "(Rested in the grotto, nothing in the Heartroot can frighten your party: once.)"])
    end
  end

  #-----------------------------------------------------------------------------
  # Zone IV - The Hollow Core
  #-----------------------------------------------------------------------------
  def scene_hollow_core_enter
    return if flag?(:hollow_core_entered)
    set_flag(:hollow_core_entered)
    add_counter(:story_beats)
    say(["The tunnel breaks into open space: a vertical shaft, crossed by narrow bridges of petrified root.",
         "Far below, a lake of frozen sap glows like trapped lightning.",
         "Heartbeats echo through the cavern. Slow. Enormous."])
    sayc([cl(:meat_meat, "Meat Meat will not look down. Meat Meat is looking down."),
          cl(:reptin, "Sentries on the far spur. Bows. Stay low on the bridge.")])
  end

  def sap_burst(event_id = nil)
    lead = $Trainer.first_able_pokemon rescue nil
    if rand(2) == 0
      say(["A crack in the root splits and spits radiant sap, bright as a struck match!"])
      if lead
        lead.hp = [lead.hp - [lead.totalhp / 8, 1].max, 1].max
        lead.status = :BURN if lead.status == :NONE && !(lead.hasType?(:FIRE) rescue false)
        say(["#{lead.name} is burned!"])
      end
    else
      say(["A bubble of acidic sap bursts underfoot and glues your boots to the root for a long, horrible moment."])
      if lead
        lead.hp = [lead.hp - [lead.totalhp / 10, 1].max, 1].max
        say(["#{lead.name} pulls you free, and gets sap-burned doing it."])
      end
    end
  end

  def frost_vines(event_id = nil)
    say(["Frost vines lash out of a crack and snare your ankle. They drag you, hard, toward the edge!"])
    if with_or_is?(:reptin) || with_or_is?(:alerion)
      say([with_or_is?(:alerion) ? "Alerion's hand closes on your collar and hauls you back. He doesn't say anything. He doesn't let go for a while." :
                                   "Reptin's hand closes on your collar. \"Not today, darling.\""])
    else
      say(["You grab a root and hang on until the vines get bored."])
    end
    pbMoveRoute($game_player, [PBMoveRoute::Backward, PBMoveRoute::Backward]) rescue nil
  end

  def crossways_construct(event_id = nil)
    return say(["A heap of roots and chardalyn wire, still twitching."], event_id) if flag?(:crossways_construct)
    say(["A root-construct pulls itself out of the crossways' tangle, joints of chardalyn wire grinding."], event_id)
    return if !boss_battle(named_mon(:B439H369, 44, "Root-construct"), named_mon(:B266H369, 43, "Root-construct"))
    set_flag(:crossways_construct)
    say(["The constructs fall apart into the sap. The bursts on the crossways ease, a little."])
  end

  # H15: three cocoons; the right one frees a Wennen scout who blesses you.
  GALLERY_COCOONS = {
    1 => ["An old one: amber gone cloudy with age, spider-webbing grey as hair.",
          "Inside, a child-shape, curled. Centuries old. One of the hag's.", :hag],
    2 => ["A newer one. The amber is clear. A Rootwarden is inside, sap in his veins, eyes open.", :captive],
    3 => ["A cocoon spun round something pale and long-limbed: moon-white fur, folded ears.", :wennen]
  }

  def gallery_cocoon(n, event_id = nil)
    return say(["The cocoon hangs open and empty."], event_id) if flag?(:"gallery_cocoon_#{n}")
    lines = GALLERY_COCOONS[n].dup
    kind = lines.pop
    say(["Roots hang from above, studded with cocoons of amber and spider-webbing: old hag experiments and newer Avarice projects, side by side."] +
        (flag?(:gallery_seen) ? [] : ["Some are empty and torn. Others twitch faintly."]) + lines, event_id)
    set_flag(:gallery_seen)
    return if !pbConfirmMessage(_INTL("Cut the cocoon open?"))
    set_flag(:"gallery_cocoon_#{n}")
    case kind
    when :hag
      say(["The amber cracks. Whatever was inside was dust a long time ago.",
           "The dust settles in the shape of a child, and then not."])
      sayc([cl(:alberica, "(softly) Thredra's pantry. Even down here."),
            cl(:meat_meat, "Meat Meat will remember this one. Somebody should.")])
    when :captive
      say(["The Rootwarden slides out into your arms. He's light as kindling. The sap in his veins is going dark.",
           "ROOTWARDEN: (a rasp) The vault... the vault of amber... she keeps the dreams there.",
           "ROOTWARDEN: Don't wake the core. Fourth pod from the throat. Fourth. It's the only one that's hungry.",
           "ROOTWARDEN: And the chant... don't sing along. It wants you to sing along.",
           "He goes soft, and then he goes to sap, and then he's gone."])
      sayc([cl(:wyn, "(hands shaking) ...I'm sorry. I'm sorry we were late."),
            cl(:reptin, "We'll carry his warning, then. That's what he gave us.")])
      set_flag(:core_warned)
    when :wennen
      say(["Moon-white fur, folded ears, a Wennen scout. Her eyes open: pale gold, and furious.",
           "WENNEN SCOUT: You are not the woman with white hair.",
           "WENNEN SCOUT: Good. I have bitten her once. She did not like it.",
           "She stands, tests her legs, and touches each of your foreheads with two cold fingers.",
           "WENNEN SCOUT: The Wennen walk through fear like through snow. So will you. Once."])
      if with_or_is?(:alerion) || flag?(:luna_spark)
        say(["WENNEN SCOUT: (to the party) Tell Luna her scout came home. Tell her the tree is sick, not dead."])
      end
      set_flag(:gallery_boon)
      say(["(The Wennen's blessing: the next thing in the Heartroot that tries to frighten or charm your party will fail.)"])
    end
  end

  # H15: the myconid-like sovereign, a survivor to bargain with.
  def gallery_sovereign(event_id = nil)
    if flag?(:sovereign_freed) || flag?(:sovereign_left)
      return say([flag?(:sovereign_freed) ? "Where the pale sovereign hung, a ring of tiny glowing caps has sprouted." :
                                            "The pale sovereign hangs in its torn amber, humming to itself."], event_id)
    end
    say(["Half out of a torn cocoon hangs a pale sovereign: something like a myconid, cap cracked, stem bound in amber.",
         "Spores drift from it, faint and blue. They smell of old rain."], event_id)
    if with_or_is?(:wyn)
      speak(:wyn, "(holding out a hand, letting spores settle on it) ...It's talking. Slowly. It's very old.", "...It's talking.")
    end
    say(["PALE SOVEREIGN: (in your head, slow as sap) Topside. Warm. The tree's children come down at last.",
         "PALE SOVEREIGN: She bound me to keep her pods sleeping. A spore for every dream. I am tired of dreams.",
         "PALE SOVEREIGN: Free me, and I will tell you what lies below. Or leave me, and I will keep her pods quiet for you."])
    c = pbMessage(_INTL("The pale sovereign waits."), [_INTL("Free it"), _INTL("Leave it to its work")], 0)
    if c == 0
      set_flag(:sovereign_freed)
      say(["You cut the amber. The sovereign settles to the floor of the gallery like a sigh.",
           "PALE SOVEREIGN: Below: a drop where time slips. Hold on to each other when it does.",
           "PALE SOVEREIGN: Below that: the sap-soldiers sleep. Below that, the amber, and the chant, and the core.",
           "PALE SOVEREIGN: And below all of it: a heart that is not a heart. It is a saint. It is a cage. Choose well.",
           "It sinks into the root, and is gone, and where it went the floor glows."])
      sayc([cl(:wyn, "It's going home. To Hyphora. ...Thank you."),
            cl(:alberica, "Lovely. Cryptic, but lovely.")])
      wheel(1)
    else
      set_flag(:sovereign_left)
      say(["PALE SOVEREIGN: Then I will keep them sleeping. For you, not for her. Go softly."])
      set_flag(:pods_quiet)
    end
  end

  def scene_frozen_drop_enter
    return if flag?(:frozen_drop_entered)
    set_flag(:frozen_drop_entered)
    say(["A vertical plunge where the bridges have fallen away, leaving a few skeletal spans and dangling root-ladders.",
         "Wind rises from below: warm one breath, bitterly cold the next."])
  end

  # H16: something small and cold rides the wind.
  def mephit_swarm(event_id = nil)
    return if flag?(:mephits_drop)
    say(["The cold breath brings something with it: a swarm of tiny ice-things, all elbows and spite, shrieking with laughter!"])
    return if !boss_battle(named_mon(:B428H42, 44, "Ice mephit"), named_mon(:B429H42, 44, "Ice mephit"))
    set_flag(:mephits_drop)
    sayc([cl(:meat_meat, "Little cold laughing things. Meat Meat hates little cold laughing things."),
          cl(:alberica, "They reminded me of my cousins.")])
  end

  # H16: the time-lapse field.
  def time_lapse(event_id = nil)
    say(["The air thickens like honey. Your next step happens before you take it."])
    $game_screen.start_flash(Color.new(220, 230, 255, 160), 12) rescue nil
    $game_player.moveto(17, 13) rescue nil
    say(["You're at the bottom of the root-ladder, breathing hard. Your hands hurt from a climb you don't remember."])
    if !flag?(:time_lapsed)
      set_flag(:time_lapsed)
      sayc([cl(:alerion, "We skipped something."),
            cl(:reptin, "Then let's hope it was something boring.")])
    end
  end

  # H34: root-drakes in their pens.
  def lizard_nursery(event_id = nil)
    return say(["The root-drakes doze in their pens, bark-scales rising and falling."], event_id) if flag?(:drakes_calm) || flag?(:drakes_fought)
    say(["A side passage lined with root-pens. Inside: scaled, root-blended riding lizards, mottled like bark.",
         "They lift their heads, smell you, and hiss."], event_id)
    if with_or_is?(:reptin) || with_or_is?(:meat_meat)
      c = pbMessage(_INTL("The root-drakes rise."), [_INTL("Calm them"), _INTL("Fight")], 0)
      if c == 0
        if with_or_is?(:reptin)
          speak(:reptin, "(crouching, palm low) Easy. Easy. Nobody's riding anybody today.", "...Easy.")
        else
          speak(:meat_meat, "(holding out a fistful of mushroom jerky) Lizards. Snack. Meat Meat shares. Once.", "...Snack.")
        end
        say(["The drakes sniff, decide you're not worth it, and lie back down."])
        set_flag(:drakes_calm)
        return
      end
    end
    return if !boss_battle(named_mon(:B278H297, 44, "Root-drake"), named_mon(:B297H278, 44, "Root-drake"))
    set_flag(:drakes_fought)
    say(["The drakes slink to the back of their pens and sulk."])
  end

  # H27: the Root-Kin Barracks.
  def root_kin_barracks(event_id = nil)
    return say(["The barracks are quiet. The sap-soldiers sit on their bunks, blinking at their own hands."], event_id) if flag?(:barracks_done)
    say(["Woven-bark bunks and weapon racks, deep in the shaft. This is where the core sap-soldiers sleep.",
         "Six of them, curled on the bunks, sap glowing faintly under their skin. They sleep with their eyes open."], event_id)
    sayc([cl(:alerion, "Sleeping enemies are enemies."),
          cl(:wyn, "Sorry, but... they're sap-dazed. Like Gant was. They might not even want to be."),
          cl(:reptin, "Then let's not make them.")])
    opts = [_INTL("Strike while they sleep"), _INTL("Wake them, and fight fair")]
    opts << _INTL("Slip past in the shadows") if with_or_is?(:wyn)
    c = pbMessage(_INTL("The sap-soldiers sleep."), opts, 1)
    if c == 2
      say([herald?(:wyn) ? "You fold your shadow round the party like a cloak." : "Wyn folds their shadow round the party like a cloak.",
           "You tiptoe past six sleeping soldiers. One of them sighs. None of them wake."])
      set_flag(:barracks_snuck)
    elsif c == 0
      say(["You move before they can wake. They come up groggy, swinging wild, sap thick in their limbs."])
      return if !trainer(:rootkin_sleepers, event_id)
      set_flag(:barracks_struck)
      say(["The last soldier drops back onto his bunk and doesn't get up.", "Nobody says anything about it."])
    else
      say(["You bang a shield against a rack. Six pairs of open eyes focus, all at once."])
      return if !trainer(:rootkin_soldiers, event_id)
      set_flag(:barracks_fair)
      wheel(1)
      say(["The last soldier lowers his weapon and sits down, hard.",
           "SAP-SOLDIER: ...Thank you for waking us first. Nobody's done that in a long time."])
    end
    set_flag(:barracks_done)
    ($game_switches[SW_BARRACKS_DONE] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
  end

  TRAINERS.merge!(
    rootkin_sleepers: [:FT_DUERGAR, "Sap-Soldiers (sleeping)", [[:B76H185, 41], [:B217H71, 41], [:GRAVELER, 42]],
                       "...Mmh. ...Is it morning?"],
    rootkin_soldiers: [:FT_DUERGAR, "Sap-Soldiers", [[:B76H185, 45], [:B217H71, 45], [:B208H266, 46], [:B68H185, 46]],
                       "Fair. That was fair. Nobody down here fights fair."]
  )

  #-----------------------------------------------------------------------------
  # Zone V - The Vault of Amber Dreams
  #-----------------------------------------------------------------------------
  def scene_amber_vault_enter
    return if flag?(:amber_vault_entered)
    set_flag(:amber_vault_entered)
    add_counter(:story_beats)
    say(["A narrow throat of roots opens into a rounded chamber where amber pods cluster like oversized fireflies.",
         "Each holds a silhouette, frozen.",
         "The hum of machinery is gone. In its place: a low, pulsing chant. Auril's name, twisted by infernal harmonics."])
    if flag?(:core_warned)
      sayc([cl(:reptin, "Don't sing along. The Rootwarden said."), cl(:alberica, "I would never. ...It's catchy, though.")])
    else
      sayc([cl(:alberica, "(humming before she can help it) ...Oh, that's horrible. Somebody stop me."),
            cl(:alerion, "Stop.")])
    end
  end

  def amber_sentries(event_id = nil)
    return say(["Two amber pods lie cracked across the throat, their sentries drained."], event_id) if flag?(:amber_sentries_down)
    say(["Two amber pods tear loose from the roots and unfold into sentries of amber and root-bark.",
         "Inside them, the silhouettes are moving."], event_id)
    return if !boss_battle(named_mon(:B416H213, 45, "Sap sentinel"), named_mon(:B213H416, 45, "Sap sentinel"))
    set_flag(:amber_sentries_down)
    ($game_switches[SW_AMBER_PODS] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    say(["The sentinels crack open like seed-pods. For a heartbeat, the whole chamber flickers: you're standing where you stood a moment ago, and a moment before that.",
         "Then time settles, sulky, back into order."])
  end

  STASIS_PODS = {
    1 => "A goblin child, curled tight, a brass plate on the pod: V-2.",
    2 => "A Wennen, mid-leap, fur gone colourless in the amber.",
    3 => "Something half elf, half wolf, frozen in the middle of becoming one or the other.",
    4 => "A shape that is mostly hands. The amber round it is warm. It breathes.",
    5 => "A coiled wyrmling, green-grey, the size of a cat. Its eyes are open. A plate: RAZ-MKI.",
    6 => "A woman made of ice, perfect and blank, a crack running from her brow to her chin."
  }

  # H19: the Stasis Gallery. The fourth pod holds the Homunculus Core.
  def stasis_pod(n, event_id = nil)
    if n == 4 && flag?(:core_destroyed)
      return say(["The fourth pod hangs empty and split, its amber gone cold."], event_id)
    end
    say(["Dozens of amber pods float at different heights among tangled roots, each holding something not quite human.",
         STASIS_PODS[n]], event_id)
    if n == 3 && with_or_is?(:reptin)
      speak(:reptin, "(very still) ...She tried to make one of me. Before there was a me to copy.", "...That's me. Nearly.")
    elsif n == 5 && with_or_is?(:meat_meat)
      speak(:meat_meat, "RAZ-MKI. Before Razzy. Meat Meat is going to break every pod in this place.", "...Before Razzy.")
    elsif n == 6
      sayc([cl(:alberica, "That's Auril's face. Badly done."), cl(:alerion, "A vessel. She wanted a goddess that fits in a jar.")])
    end
    return if n != 4
    if flag?(:core_warned)
      say(["(Fourth pod from the throat. The dying Rootwarden's warning: don't wake the core.)"])
    end
    return if !pbConfirmMessage(_INTL("Touch the fourth pod?"))
    say(["The amber softens under your hand like skin.",
         "The thing that is mostly hands opens its eyes, and its shell, and climbs out into the gallery.",
         "Behind it, two smaller constructs tear loose from the roots."])
    return if !boss_battle(named_mon(:B293H448, 47, "Homunculus Core"), named_mon(:B369H213, 45, "Lesser construct"))
    if !flag?(:core_rebound_seen)
      set_flag(:core_rebound_seen)
      say(["The Core drops, and its amber shell hardens over it like a fist. It gets up again.",
           "It doesn't get up a third time."])
    end
    set_flag(:core_destroyed)
    add_counter(:story_beats)
    say(["Where it fell, a fist-sized lump of warm amber with something ticking inside."])
    give(:FT_GREATVERDANTSEED) if !flag?(:core_seed)
    set_flag(:core_seed)
  end

  # H19: the lab notes - the dragon and divine-essence plan. One of them is the
  # clue a careful player can carry to the Heart Chamber.
  def stasis_notes(event_id = nil)
    say(["Lab notes on a lectern of root, in a neat white hand, page after page:",
         "\"The dragon will be built on the soul-echo method: the draconic one (Raz) and the goblin (V-7) proved it.\"",
         "\"Its heart: the old wyrm's, taken from the ice long ago. Corrupted, but beating. Chardalyn for bones. Mirror-glass for skin.\"",
         "\"The engine will burn the saint's heart for fuel. Summer without end; the Dale will love it, until it doesn't.\"",
         "\"Then the dragon flies. Ten-Towns melts. Every soul in the Dale, harvested warm.\"",
         "\"Enough souls, and I sit where the Frostmaiden sits. And the Dale goes down to my patron's circle, all of it, still warm.\""], event_id)
    if !flag?(:stasis_notes_read)
      set_flag(:stasis_notes_read)
      add_counter(:story_beats)
      sayc([cl(:meat_meat, "Proved it. On Meat Meat. On Razzy. Meat Meat is a proof."),
            herald?(:meat_meat) ? nil : cl(:reptin, "(a hand on her shoulder) You're a person. Proofs don't bite."),
            cl(:alerion, "Her patron's circle. The Hells."),
            cl(:alberica, "She wants to be the Frostmaiden. With a landlord.")])
    end
    say(["The last page is half torn. Under a sketch of a sleeping woman in a pod:",
         "\"Vessel IX: viable. Keep it warm. If they come, let them find me.\""])
    set_flag(:decoy_clue)
  end

  def temporal_surge(event_id = nil)
    say(["You step on a seam in the floor, and the gallery runs backwards:",
         "the pods drift up, your feet lift, you're standing where you were three breaths ago with the taste of a word you haven't said yet."])
    $game_screen.start_flash(Color.new(255, 230, 160, 160), 12) rescue nil
    pbMoveRoute($game_player, [PBMoveRoute::Backward, PBMoveRoute::Backward, PBMoveRoute::Backward]) rescue nil
    if !flag?(:temporal_surge_seen)
      set_flag(:temporal_surge_seen)
      sayc([cl(:alerion, "We were already here."), cl(:meat_meat, "Meat Meat was already annoyed. Meat Meat is annoyed again.")])
    end
  end

  # H20: the Dissectory Annex.
  def cataloguer(event_id = nil)
    say(["A lone researcher-construct, all thin brass arms, still dutifully cataloguing specimens.",
         "It turns its lamp-face toward you and begins to write."], event_id)
    lines = ["CATALOGUER: NEW SPECIMENS. RECORDING."]
    lines << "CATALOGUER: SPECIMEN: GOBLIN, V-SERIES, NUMBER SEVEN. STATUS: ESCAPED. RECAPTURE PRIORITY: HIGHEST." if with_or_is?(:meat_meat)
    lines << "CATALOGUER: SPECIMEN: ELF, LUPINE TAINT. PREVIOUS ATTEMPT: POD THREE. STATUS: SUPERIOR." if with_or_is?(:reptin)
    lines << "CATALOGUER: SPECIMEN: DWARF, MARKED. NOTE: THE RUNE ON HER CHEST IS NOT OURS. DO NOT TOUCH." if with_or_is?(:alberica)
    lines << "CATALOGUER: SPECIMEN: HUMAN, NECROMANTIC. NOTE: HE IS COLD ALREADY. INTERESTING." if with_or_is?(:alerion)
    lines << "CATALOGUER: SPECIMEN: FELINE, LIGHT-BEARING. NOTE: INCOMPATIBLE. BURN ON SIGHT." if with_or_is?(:glimmer)
    lines << "CATALOGUER: SPECIMEN: MYCONID-TOUCHED. NOTE: CANNOT BE FOUND WHEN NOT LOOKED FOR." if with_or_is?(:wyn)
    lines << "CATALOGUER: SPECIMEN: UNKNOWN. NOT ON THE WHEEL. CANNOT BE CATALOGUED. ERROR. ERROR." if journey?
    say(lines)
    say(["It finishes its page, files it into a slot in the root, and goes back to waiting."])
  end

  def dissectory_notes(event_id = nil)
    say(["A side lab where pods have been cracked and their contents laid out on root-tables.",
         "Tools of bone, chardalyn and hell-steel. And a stack of notes, sealed with frost:",
         "\"Attempt 31: the goddess will not stay in glass. The glass froze, then shattered, then wept.\"",
         "\"Attempt 38: a vessel of ice, shaped as her. It held her face for a day. It held nothing else.\"",
         "\"Attempt 40: a mortal lens. A drowned sailor she already loved. She poured herself into his heart, and it held.\"",
         "\"The Frost Saint is not a failure. It is a success I cannot control. Keep it in the engine. Keep it burning.\""], event_id)
    return if flag?(:knows_shard_origin)
    set_flag(:knows_shard_origin)
    add_counter(:story_beats)
    sayc([cl(:alerion, "Sephek. The heart in her engine isn't just his. It's Auril's, poured into him."),
          cl(:alberica, "An experiment that went too right. Oh, I hate that I understand her."),
          cl(:wyn, "So when it stops burning... what's left in it?"),
          cl(:reptin, "That, sweetheart, is the question we'll have to answer standing in front of it.")])
  end

  # Autumn's laboratories (for the trial): his sigil on her crates.
  def autumn_crates(event_id = nil)
    say(["Crates stacked against the wall, under a root-stair that climbs toward the Council Hall's foundations.",
         "Each is branded with a leaf over a coin: Autumn's sigil. Darrus Fell's."], event_id)
    return if flag?(:autumn_labs_seen)
    set_flag(:autumn_labs_seen)
    add_counter(:story_beats)
    say(["Inside: vials of blood, labelled by town. Ritual knives. Samples of Mirror Wraith, bottled in mirror-glass.",
         "A tally in Autumn's hand: \"Refugees, Easthaven: 40. Bryn Shander: 22. For the Frostmaiden's lottery, by the back door.\""])
    sayc([cl(:meat_meat, "Autumn. Autumn knew. Autumn paid for the cold table."),
          cl(:alberica, "Bring a vial up with us, darling. Somebody is going to ask us to prove it."),
          cl(:alerion, "Two.")])
  end

  def dissectory_golem(event_id = nil)
    return say(["The hammer-arm construct lies in pieces on its own root-table."], event_id) if flag?(:dissectory_golem)
    say(["A hammer-armed root-construct that had looked inactive straightens, and two sap assistants scuttle out from under the tables."], event_id)
    return if !boss_battle(named_mon(:B369H68, 46, "Hammer-arm"), named_mon(:B416H185, 44, "Sap assistant"))
    set_flag(:dissectory_golem)
  end

  # H28: the Suffering Pods.
  def suffering_pods(event_id = nil)
    return say(["The torturer-construct hangs limp from its hooks."], event_id) if flag?(:torturer_down)
    say(["A darker annex. These pods aren't rigged for sleep. They're rigged for pain.",
         "A torturer-construct turns from its work, humming, and its humming gets inside your head."], event_id)
    return if !boss_battle(named_mon(:B337H97, 46, "Torturer construct"))
    set_flag(:torturer_down)
    say(["The humming stops. In two of the pods, people stop screaming and start crying instead, which is better."])
  end

  def pain_pod(n, event_id = nil)
    key = :"pain_pod_#{n}"
    return say(["An empty pod, cut open."], event_id) if flag?(key)
    return say(["Someone inside the pod, twitching every time the construct hums."], event_id) if !flag?(:torturer_down)
    if n == 1
      say(["You cut open the pod. A caravan driver from Bryn Shander falls out, wheezing.",
           "DRIVER: They took the whole caravan. The food. Said it was for the summer. Said the summer was hungry."], event_id)
    else
      say(["You cut open the pod. A Rootwarden recruit, barely more than a child, falls into your arms.",
           "RECRUIT: I followed my captain down. I shouldn't have. I'm going home. I'm going home now."], event_id)
    end
    set_flag(key)
    if flag?(:pain_pod_1) && flag?(:pain_pod_2)
      set_flag(:pain_pods_freed)
      say(["The two of them help each other up the shaft, toward the light. Neither looks back."])
    end
  end

  #-----------------------------------------------------------------------------
  # Zone V - the Scriptory wing
  #-----------------------------------------------------------------------------
  def scene_scriptory_enter
    return if flag?(:scriptory_entered)
    set_flag(:scriptory_entered)
    say(["A split-level room. A pool of mirror-smooth sap in the middle, and shelves of chardalyn pages grown into the walls.",
         "Avarice writes here. She etches sigils into the sap and seals them into crystal."])
  end

  # H21: reading the pool. Mishandling it raises the Mirror-Ink Wraith.
  def mirror_scriptory(event_id = nil)
    if flag?(:scriptory_read)
      return say(["The pool lies still. The plans you read in it are still there, if you look. You'd rather not."], event_id)
    end
    say(["The pool's surface is etched all over with script: lines that move when you aren't watching them."], event_id)
    reader = with_or_is?(:alberica) ? :alberica : (with_or_is?(:alerion) ? :alerion : nil)
    opts = []
    opts << _INTL("Read it through the Mirror Shard Focus") if flag?(:shard_focus_found) && !flag?(:shard_focus_used)
    opts << _INTL("Let #{reader == :alberica ? 'Alberica' : 'Alerion'} read it") if reader && !herald?(reader)
    opts << _INTL("Read it yourself") if reader && herald?(reader)
    opts << _INTL("Touch the script to make it hold still")
    c = pbMessage(_INTL("How do you read the pool?"), opts, opts.size - 1)
    choice = opts[c] || opts.last
    safe = false
    if choice.include?("Focus")
      safe = use_shard_focus
    elsif choice.include?("Touch")
      safe = false
    else
      safe = true
      say([reader == :alberica ? (herald?(:alberica) ? "You hum the script into order. Bards know every alphabet, if you hum it." :
                                                        "ALBERICA: Hush, everyone. Bards know every alphabet. You just hum it.") :
                                 (herald?(:alerion) ? "You read it the way you read old graves: slowly, without touching." :
                                                      "ALERION: (reading, without touching) Old Infernal. Mirror-grammar. Give me a minute.")])
    end
    if !safe
      say(["Your fingertip touches the script, and the ink comes up out of the pool after it.",
           "It stands. It has no face. It has a great many hands, all dripping."])
      if flag?(:gallery_boon) && !flag?(:gallery_boon_used)
        set_flag(:gallery_boon_used)
        say(["(The Wennen scout's blessing: it reaches for your mind and finds only snow.)"])
      end
      return if !boss_battle(named_mon(:B94H122, 47, "Mirror-Ink Wraith"))
      say(["The wraith tears into ink and splashes back into the pool. The script lies flat, beaten, readable."])
      set_flag(:ink_wraith_fought)
    end
    set_flag(:scriptory_read)
    add_counter(:story_beats)
    say(["Flight plans: the dragon's path drawn in hot red over the Dale. Out of the roots, over the Wall,",
         "Good Mead first, for the bees and the mead-hall, then Bryn Shander, the biggest, then round the lake, town by town.",
         "Long-term goals, in a tidy list: \"Summer without end. The Dale's souls, harvested warm. Her throne. My patron's circle.\"",
         "Allies: a ledger of the courteous: a horned duke of the Hells' cold circle, \"who extends his courtesy through the Bloom\";",
         "the duergar who answer to the name Xardorok; Autumn, \"who is bought, and stays bought\";",
         "and a line about \"the White Womb\": a vault of ice far north, under a glacier. \"Where the goddess keeps what she can't bear to look at.\""])
    sayc([cl(:alberica, "Xardorok. She tells the duergar her name is Xardorok."),
          cl(:alerion, "Names are coats too."),
          cl(:meat_meat, "Good Mead first. Meat Meat likes Good Mead. Meat Meat is going to bite her."),
          cl(:glimmer, "A horned duke. A frozen throne. ...She doesn't want summer. She wants everything.")])
  end

  def scriptory_pages(event_id = nil)
    say(["Chardalyn pages, grown into the wall like shelf-fungus. Each one etched in Avarice's neat white hand.",
         "\"Xardorok: what the duergar call me. Their old king's name. Names are cheaper than chains, and hold better.\"",
         "\"Selrae Vorn calls my vault the White Womb. Let her. Priests are happiest when they're frightened.\""], event_id)
    set_flag(:knows_xardorok)
  end

  # H21: the sealed crystal: the glass half of the forge door.
  def scriptory_crystal(event_id = nil)
    return say(["An empty socket in the root, still warm."], event_id) if flag?(:glass_sigil)
    say(["A crystal sealed in the root, the size of a fist. A sigil turns slowly inside it, like a fish in ice."], event_id)
    if flag?(:root_key)
      say(["You've seen that sigil. Etched in the glass half of the door at the bottom of Hew's last ladder."])
    end
    return if !pbConfirmMessage(_INTL("Take the crystal?"))
    give_key(:FT_GLASSSIGIL)
    set_flag(:glass_sigil)
    add_counter(:story_beats)
    sayc([cl(:alerion, "Iron and glass. Now we have both."),
          cl(:reptin, "And a lift, if those roots can be persuaded.")])
    state[:goal] = "The Root-Lift Node beside the Scriptory goes down to the door of iron and glass."
  end

  # H29: the Guest Seed Nests.
  def guest_nests(event_id = nil)
    say(["A softer hollow where seed-pods have grown shaped for comfort: guest quarters, for outside allies."], event_id)
    return if flag?(:guest_nests_searched)
    set_flag(:guest_nests_searched)
    say(["In one, a duergar travel-pack stamped with a forge-mark: MUZGARDT, and a letter in Dwarvish that ends \"...the deep road is yours, Forge-Mistress.\"",
         "In another, a cultist's robe of red silk, embroidered with a horned eye. It's still warm."])
    sayc([cl(:alberica, "Visitors. She entertains."),
          cl(:alerion, "Allies. Not friends. Nobody here was a friend.")])
  end

  # H31: the Devil's Bloom: a social test first.
  def devils_bloom(event_id = nil)
    if flag?(:bloom_done)
      return say([flag?(:bloom_broken) ? "Shards of black glass, and a smell of struck matches." :
                                         "The black-glass flower sways, though nothing moves the air. \"Still here,\" it says, pleasantly."], event_id)
    end
    say(["A single huge flower of black-glass petals grows from the wall. Something sits inside it, bound, with its knees drawn up.",
         "It has very good manners, and far too many teeth.",
         "EMISSARY: Visitors! The Forge-Mistress's patron extends his courtesy. I am the courtesy.",
         "EMISSARY: Unbind me, and I'll carry word to the cold circle that the Heralds are... reasonable."], event_id)
    c = pbMessage(_INTL("The emissary waits."), [_INTL("\"Who is her patron?\""), _INTL("\"No.\""), _INTL("Break the bloom")], 0)
    if c == 0
      say(["EMISSARY: A duke of the cold circle. He has promised her a throne exactly where the Frostmaiden sits.",
           "EMISSARY: In exchange: the Dale, all of it, delivered warm. He hates a cold meal.",
           "EMISSARY: And now you know a secret. Secrets have prices. Mine is small: a drop of blood, for a glimpse of your own future."])
      c2 = pbMessage(_INTL("A drop of blood..."), [_INTL("Refuse, politely"), _INTL("Pay it")], 0)
      if c2 == 1
        set_flag(:bloom_bargain)
        wheel(-1)
        say(["You prick your thumb on a petal. The emissary breathes in the drop like perfume.",
             "EMISSARY: (delighted) You'll stand in a white room under the ice, and you'll be asked to hold something very cold.",
             "EMISSARY: Everyone always is. Do say hello to her for me."])
      else
        say(["EMISSARY: Wise. Dull, but wise. I'll stay. I'm very good at staying."])
      end
      set_flag(:bloom_done)
      return
    elsif c == 1
      say(["EMISSARY: Pity. I'd have liked the walk."])
      set_flag(:bloom_done)
      return
    end
    say(["You grip a black-glass petal. The emissary's smile goes on widening after its face has run out of room.",
         "EMISSARY: Oh, NOW we're talking."])
    return if !boss_battle(named_mon(:B229H352, 48, "Root-bound fiend"))
    set_flag(:bloom_broken)
    set_flag(:bloom_done)
    say(["The bloom shatters. Whatever was inside goes home the hard way.", "The air smells of struck matches for a long time."])
  end

  # H30: the Root-Lift Node: a hazard and a ride down to the forge door.
  def root_lift_node(event_id = nil)
    if !flag?(:lift_node_run)
      say(["An organic elevator: a vertical root-cage hung in a shaft. When the sap flows, it rises and falls like a lung.",
           "You step in. The roots close behind you like fingers."], event_id)
      return if !pbConfirmMessage(_INTL("Let the sap flow?"))
      $game_screen.start_shake(5, 8, 20) rescue nil
      say(["The cage drops. Not down: away. Your stomach stays three floors up.",
           "It catches with a crunch halfway down the shaft, and two root-constructs climb out of the walls to see what's in it."])
      return if !boss_battle(named_mon(:B369H439, 46, "Root-construct"), named_mon(:B439H369, 46, "Root-construct"))
      set_flag(:lift_node_run)
      ($game_switches[SW_LIFT_NODE] = true; $game_map.need_refresh = true if $game_map) if $game_switches
      add_counter(:story_beats)
      say(["The constructs fall away down the shaft. The cage creaks, considers, and goes on down more politely.",
           "It comes to rest in a familiar tunnel: the Guild Dig, beside the door of iron and glass."])
      return transfer(*LIFT_NODE_FOOT)
    end
    return if !pbConfirmMessage(_INTL("Ride the root-cage down to the Guild Dig?"))
    transfer(*LIFT_NODE_FOOT)
  end

  def root_lift_up(event_id = nil)
    say(["The root-cage from the Scriptory waits beside the door, breathing slowly."], event_id)
    return if !pbConfirmMessage(_INTL("Ride the root-cage up to the Vault of Amber Dreams?"))
    transfer(*LIFT_NODE_TOP)
  end

  #-----------------------------------------------------------------------------
  # The Mirror-Root Vault (Tab 1's H3)
  #-----------------------------------------------------------------------------
  def scene_mirror_root_enter
    return if flag?(:mirror_root_entered)
    set_flag(:mirror_root_entered)
    add_counter(:story_beats)
    say(["Half garden, half laboratory. Roots form a sphere around a pit of liquid mirror.",
         "Hovering above it: shards of glass, each holding a faint reflection of someone you know. Or perhaps will know.",
         "In the centre floats a broken mask of ice, shaped like a woman's face."])
  end

  # GQ2 (rootspire.md 8487): three successes to unbind the vault (Arcana or
  # Religion); every failure animates a Mirror Sentinel you have to fight while
  # you keep working. Progress survives a lost fight.
  WARD_THREADS = [
    ["A thread of frost and a thread of hellfire, knotted round the largest shard.",
     ["Unpick the hellfire first; frost was here before it", "Cut both at once", "Pull the frost thread"], 0],
    ["Three shards turn in a ring, each one reflecting the next. A sigil burns where the reflections cross.",
     ["Turn one shard so the ring breaks", "Smash the burning sigil", "Speak a prayer into the ring"], 0],
    ["The last thread runs into the broken ice mask itself, and pulses in time with your heartbeat.",
     ["Name what the mask was made for: a vessel. Refuse it.", "Hold your breath until it stops", "Pull it out of the mask"], 0]
  ]

  def mirror_root_wards(event_id = nil)
    return say(["The shards hang dull and harmless now, turning slowly."], event_id) if flag?(:mirror_wards_down)
    say(["The floating shards are bound with old enchantments: threads of frost and hellfire running between them."], event_id)
    done = state[:ward_successes] || 0
    if done == 0 && flag?(:shard_focus_found) && !flag?(:shard_focus_used) &&
       pbConfirmMessage(_INTL("Look for the pattern through the Mirror Shard Focus?")) && use_shard_focus
      say(["Through the shard you see where two of the threads are tied, plain as knots in string. You untie them in order."])
      done = 2
    end
    return if done == 0 && !pbConfirmMessage(_INTL("Try to unbind the vault's enchantments?"))
    while done < 3
      text, opts, right = WARD_THREADS[done]
      say([text])
      c = pbMessage(_INTL("The thread..."), opts.map { |o| _INTL(o) } + [_INTL("Step back")], opts.size)
      return (state[:ward_successes] = done) if c.nil? || c >= opts.size
      if c == right
        done += 1
        say(["The thread parts with a sound like a held note ending. (#{done} of 3.)"])
      else
        say(["Wrong. Every shard in the vault turns to look at you.",
             "Some of them fly together, edge to edge, into a shape like an empty suit of armour made of knives: a Mirror Sentinel!"])
        if !boss_battle(named_mon(:B429H122, 46, "Mirror Sentinel"))
          state[:ward_successes] = done
          return
        end
        say(["The sentinel shatters. The threads are still there, waiting."])
      end
    end
    state[:ward_successes] = 3
    say(["The last thread lets go. The shards sigh and go still, and sink a little, like birds landing."])
    set_flag(:mirror_wards_down)
  end

  def ice_mask(event_id = nil)
    say(["A mask of ice, broken across, shaped like a woman's face. Beautiful, blank, cold.",
         "The remains of Avarice's first homunculus: a failed vessel for Auril's power."], event_id)
    return if flag?(:ithryn_athis_clue)
    set_flag(:ithryn_athis_clue)
    add_counter(:story_beats)
    say(["Etched on the inside of the mask, in two hands, one neat and white, one older and cruder:",
         "\"Ithryn Athis.\" And under it, an arrow pointing north, and a dragon's eye drawn round a glacier."])
    sayc([cl(:alerion, "A draconic vault. North. Under a glacier."),
          cl(:alberica, "The White Womb. Or its front door."),
          cl(:glimmer, "Everybody keeps drawing that eye. I'm starting to take it personally.")])
  end

  # The pit of liquid mirror: stepping in is stepping across time - to the night
  # Avarice took Var Rime-Breaker, thirty years ago. His echo is still in the glass.
  def mirror_pit(event_id = nil)
    return say(["The liquid mirror shows only the vault now, and you in it, standing where Var stood."], event_id) if flag?(:var_story_known)
    # (The Summer Marshal is Avarice: Chapter 8's twist, owner's call 2026-11-05.
    # Before the Heart Chamber the vision stops short of who came out of the mirror.)
    unmasked = flag?(:summer_unmasked)
    if !flag?(:mirror_wards_down)
      return say(["The pit mirrors the sky of a frozen world: not this one, or not this year.",
                  "Above it the shards turn to watch you. Not yet. Not while they're watching."], event_id)
    end
    say(["The pit mirrors the sky of the frozen world outside: snow hanging in the air, an aurora gone still.",
         "Stepping in would be stepping across time."], event_id)
    return if !pbConfirmMessage(_INTL("Step into the liquid mirror?"))
    Stage.overlay("O-03", fade: 20) rescue nil
    say(["You step in, and fall upward, into a warm night thirty years gone.",
         "The Split Dock. Lanterns. A big, scarred man in the Summer Marshal's gold counts crates off a Corsair skiff.",
         "VAR: Thirty blades, forty bows, no Council stamp, no Council questions. That's the deal.",
         "CORSAIR: And the Council never knows.",
         "VAR: The Council argues for a living. I keep the peace for one. Go on, before somebody sober sees.",
         "He leans on a glaive with a blade of melted mirror-shard. It hums when he isn't touching it.",
         "Alone, he looks out at the Wall, and talks to nobody:",
         "VAR: My great-grandsire carried a spear for Naerth Maxildanarr. Gold-sick, the lot of them. Greed in the blood.",
         "VAR: Every bit of peace I keep pays a bit of it back. Never enough. Never enough.",
         "VAR: When the Heralds come home, and they will, I want the frost-one. The necromancer. I want to see if a man can hold winter in his hands and not let it eat him.",
         "A mirror on a crate catches the lantern. Something steps out of it as if out of a doorway.",
         unmasked ? "AVARICE: Marshal. Loud, scarred, beloved. The city trusts your face." : nil,
         "VAR: (the glaive coming up) Who in the Nine Hells are you?",
         unmasked ? "AVARICE: Close. I need a coat, Marshal. Yours will do." : nil,
         "The lantern goes out."].compact)
    say(["In the dark, someone is still standing in the mirror: Var, as he was, glaive in his hands, looking straight out at you."])
    target = with_or_is?(:alerion) ? :alerion : nil
    if target == :alerion && herald?(:alerion)
      say(["VAR: (to you) You. The frost-one. From the carvings. I've waited thirty years in here to see you up close."])
      speak(:alerion, "Then look. I'm standing.", "...I'm here.")
    elsif target == :alerion
      say(["VAR: (to Alerion) You. The frost-one. From the carvings. I've waited thirty years in here to see you up close.",
           "ALERION: Then look. I'm standing."])
    else
      say(["VAR: Heralds. Where's the frost-one? ...Never mind. Somebody show me winter can be held."])
    end
    say(["VAR: Come on, then. Show me winter can be held."])
    Stage.overlay_off("O-03", fade: 10) rescue nil
    won = pbTrainerBattle(:FT_MARSHAL, "Var", nil, false, 0) ? true : false
    return if !won
    say(["VAR: (laughing, leaning on the glaive) Ha! There it is. Winter in a man's hands, and the man still standing.",
         unmasked ? "VAR: She's wearing me, isn't she. Up there. Thirty years of my face, smiling at Kelyn." :
                    "VAR: How long have I been in here? ...Don't tell me. Tell Kelyn I kept the peace.",
         "VAR: Tell Rootspire I'm sorry. Tell them Naerth's debt is paid; I paid it in summers.",
         "VAR: And take this. She left it here because it hums when Sephek's near, and she didn't like it humming at her."])
    give_key(:FT_VARGLAIVE)
    say(["The mirror goes still. Var's echo raises a hand, and the glass is only glass."])
    set_flag(:var_story_known)
    set_flag(:var_glaive)
    set_flag(:corsair_arms_deal)
    add_counter(:story_beats)
    sayc([cl(:alerion, "(after a long while) He waited thirty years for that."),
          cl(:alberica, "Then we owe him the rest of the story, pretty boy. All of it. Out loud. At the Council."),
          cl(:reptin, "A Corsair arms deal behind the Council's back. Kelyn's going to love that.")])
  end
end

# The Verdant Seeds work like Rare Candy (one level; the greater seed, three).
if defined?(ItemHandlers)
  ItemHandlers::UseOnPokemon.add(:FT_VERDANTSEED, proc { |item, pkmn, scene|
    if pkmn.level >= GameData::GrowthRate.max_level || pkmn.shadowPokemon?
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    pbChangeLevel(pkmn, pkmn.level + 1, scene)
    scene.pbHardRefresh
    next true
  }) rescue nil
  ItemHandlers::UseOnPokemon.add(:FT_GREATVERDANTSEED, proc { |item, pkmn, scene|
    if pkmn.level >= GameData::GrowthRate.max_level || pkmn.shadowPokemon?
      scene.pbDisplay(_INTL("It won't have any effect."))
      next false
    end
    pbChangeLevel(pkmn, [pkmn.level + 3, GameData::GrowthRate.max_level].min, scene)
    scene.pbHardRefresh
    next true
  }) rescue nil
end
