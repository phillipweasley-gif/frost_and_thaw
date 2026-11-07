#===============================================================================
# Frost & Thaw - Act II, Chapter 8 continued: the rest of the Rootsun Forge
# (after "Rootspire" Tab 2, Chapter 3: the Rootsun Forge, Areas 1-37) and the
# Heartroot Labyrinth's Zone VI (Tab 1 / Tab 3: H22-H26, H32, H33, H36, H37).
#
#   Level 1 (2146, the inner rooms): A2 the Echo Hall, A3 the guardhold
#     ("Xardorok said you'd come"), A5 Avarice's quarters (the mural, the
#     journal, the mirror-root effigy, and under the floorboard the Ledger of
#     Corruption), A6 the traitor and the lever (the Great Unchaining), A7 the
#     root archives.
#   Level 2 (2147-2149): A9 the Deep Root Shaft, A10 the guest quarters (a
#     dragon limb; "the goblin sample failed"), A11 the Warden's bunker (a
#     future self: "Don't let her take the heart"), A12 the training hall's sap
#     golems, A13 the sap-lift (Root, Deep, Forge), A14 the Rootwatch and its
#     Infernal Rootbreaker, A15 the sap-gate controls (once a winter altar),
#     A16 the Scratching Hollow, A17 the rust-feast tunnels, A18 the root-keep gate.
#   Level 3 (2150-2152, and the pens): the womb of iron; A19 the Root-Throne
#     (the quaggoth and the myconid that begs to die), A20 the broken
#     root-works, A21 the heart-fuel, A22 the root-shaft elevator, A23 the
#     root-keep gate, A24/A25 the vantage towers, A27 the rootbeast pens, A28
#     the prison cocoons, A29 the mind-flayer corpse, A30 the lower elevator,
#     A32 the mirror-hall, A33 the barracks ("Fire replaces frost"), A34 the
#     tortured captain, A35 Mother Thruuna's chamber, A36 the mech guards, A37
#     Avarice's root-vault.
#   Zone VI (2153-2155): H22 the Auroral Antechapel (the ghost of the Shard),
#     H32 the Thorn-Run Hall, H33 the Hammer-Heart workshop, H37 the Silent
#     Chapel; then (034_Chapter8.rb) the Heart Chamber and the Breaking
#     Circle; then H25 the Sloughing Veins, H26 the Echo Vault and H36 the
#     Aurora Treasury, and up, at last, to Rootspire.
#===============================================================================
module FrostThaw
  SW_SAPLIFT   = 4087   # the Rootwatch is cleared: the sap-lift runs between Root, Deep and Forge
  SW_ROOTWATCH = 4088   # the Rootwatch's levers are free (the way on to the sap-gate controls)
  SW_L3_GATE   = 4092   # the root-keep gate down to the Dragonforge is open
  SW_MECHS     = 4093   # the rootbound mechs are down: the vault is open
  SW_ANTECHAPEL = 4094  # the Antechapel's guardians are down: the breathing door lets you through
  SW_GOLEMS    = 4100   # the training hall's sap golems are down

  MAPS.merge!(forge_inner: 2146, deep_shaft: 2147, rootwatch: 2148, umbound: 2149, forge_upper: 2150, vantage: 2151,
              forge_sanctum: 2152, antechapel: 2153, sloughing: 2154, echo_vault: 2155)
  MAP_NAMES.merge!(
    2146 => "The Barricade: the inner rooms", 2147 => "The Hag's Domain: the Deep Root Shaft", 2148 => "The Hag's Domain: the Rootwatch",
    2149 => "The Hag's Domain: the Scratching Hollow", 2150 => "The Dragonforge: the Root-Throne", 2151 => "The Dragonforge: the vantage towers",
    2152 => "The Dragonforge: Avarice's sanctum", 2153 => "Heartroot: the Auroral Antechapel", 2154 => "Heartroot: the Sloughing Veins",
    2155 => "Heartroot: the Echo Vault"
  )
  (2146..2155).each { |m| MAP_METADATA[m] = { announce_location: true, battle_environment: :Cave } }
  AREAS.merge!(2146 => :forge, 2147 => :hag_domain, 2148 => :hag_domain, 2149 => :hag_domain, 2150 => :forge, 2151 => :forge,
               2152 => :forge, 2153 => :heartroot, 2154 => :heartroot, 2155 => :heartroot)
  SAPLIFT_STOPS = { root: [2072, 27, 15, 4], deep: [2148, 28, 12, 2], forge: [2150, 33, 16, 2] }
  LOWER_ELEVATOR_FOOT = [2150, 29, 24, 8]
  VEINS_ARRIVAL = [2154, 3, 12, 6]

  ENCOUNTERS[2147] = { step_chances: { Cave: 6 },
                       Cave: [[30, :HAUNTER, 46, 48], [25, :BANETTE, 46, 48], [20, :CROBAT, 46, 48], [15, :DUSCLOPS, 47, 49], [10, :SABLEYE, 47, 49]] }
  ENCOUNTERS[2148] = { step_chances: { Cave: 6 },
                       Cave: [[30, :MAGCARGO, 46, 48], [25, :TORKOAL, 46, 48], [20, :GOLURK, 46, 48], [15, :HOUNDOOM, 47, 49], [10, :SKARMORY, 47, 49]] }
  ENCOUNTERS[2149] = { step_chances: { Cave: 6 },
                       Cave: [[30, :GRAVELER, 46, 48], [25, :ONIX, 46, 48], [20, :MAGCARGO, 47, 49], [15, :STEELIX, 47, 49], [10, :TORKOAL, 47, 49]] }
  ENCOUNTERS[2150] = { step_chances: { Cave: 6 },
                       Cave: [[30, :MAGCARGO, 47, 49], [25, :HOUNDOOM, 47, 49], [20, :TORKOAL, 47, 49], [15, :MAGMAR, 48, 50], [10, :SKARMORY, 48, 50]] }

  #-----------------------------------------------------------------------------
  # Trainers
  #-----------------------------------------------------------------------------
  TRAINERS.merge!(
    duergar_ruk:  [:FT_DUERGAR, "Ruk",  [[:B76H59, 46], [:MAGCARGO, 46]], "Xardorok will hear of this. Xardorok hears everything."],
    duergar_varn: [:FT_DUERGAR, "Varn", [[:B208H126, 46], [:B95H229, 47]], "The runes on my arms are cooling. Why are they cooling?"],
    duergar_watch_ord:  [:FT_DUERGAR, "Ord",  [[:B76H126, 47], [:TORKOAL, 47]], "Rootwatch holds. Rootwatch always holds."],
    duergar_watch_ysk:  [:FT_DUERGAR, "Ysk",  [[:B219H95, 47], [:B229H76, 47]], "The levers are grown, not made. They like my hands. They don't like yours."],
    duergar_watch_brod: [:FT_DUERGAR, "Brod", [[:B208H59, 47], [:B126H208, 48]], "She'll stoke me for this. She stokes everyone eventually."],
    duergar_keep_hrem:  [:FT_DUERGAR, "Hrem",  [[:B227H126, 47], [:B59H208, 48]], "The bolts were red-hot. My hands are red-hot. Everything's red-hot."],
    duergar_keep_vosh:  [:FT_DUERGAR, "Vosh",  [[:B126H227, 47], [:B229H219, 48]], "You crossed. Nobody crosses. Fine. Go on, then."],
    duergar_keep_dagna: [:FT_DUERGAR, "Dagna", [[:B95H59, 48], [:MAGCARGO, 48]], "Below's the pens. Don't look in the pens."],
    duergar_keep_turl:  [:FT_DUERGAR, "Turl",  [[:B76H229, 48], [:TORKOAL, 48]], "Fire replaces frost. That's what she says. Fire replaces everything."],
    duergar_gate_kell:  [:FT_DUERGAR, "Kell",  [[:B227H229, 48], [:B208H126, 49]], "Molten sap below, bolts above, and you walked straight through. Huh."],
    duergar_gate_morn:  [:FT_DUERGAR, "Morn",  [[:B219H208, 48], [:B126H59, 49]], "We aim with our eyes shut now. She says it's kinder."],
    duergar_gate_sharl: [:FT_DUERGAR, "Sharl", [[:B59H126, 49], [:B208H219, 49]], "The gate's bar lifts from this side. I'll lift it. I'm tired of holding it down."],
    duergar_gate_ulf:   [:FT_DUERGAR, "Ulf",   [[:B229H76, 49], [:B95H126, 49]], "Down there's the forge. Down there's her. Up here's me. I like up here."],
    duergar_tower_grik: [:FT_DUERGAR, "Grik",  [[:B227H59, 49], [:B229H227, 49]], "From up here you can see the whole forge. You can see HER. I don't look."],
    duergar_tower_nall: [:FT_DUERGAR, "Nall",  [[:B59H227, 49], [:B126H95, 50]], "Bolts down on anybody who fights her. That's the job. ...It was the job."],
    broken_duergar:     [:FT_DUERGAR, "Broken Duergar", [[:B76H93, 49], [:B208H93, 49], [:B219H93, 50]], "Fire... replaces... frost..."],
    rootbreaker_mechs:  [:FT_AVARICE, "Infernal Rootbreakers", [[:B293H59, 49], [:B337H229, 49]], "(The mechs vent steam and fold back into the sap.)"],
    avarice_opening:    [:FT_AVARICE, "Avarice (opening)", [[:B229H122, 49], [:B208H126, 49]], "Ah. You've grown. How irritating."]
  )
  TRAINER_INTROS.merge!(
    duergar_ruk:  "RUK: Topsiders in the guardhold? Xardorok will want you for fuel.",
    duergar_varn: "VARN: Back! Back to the sap-pool! Xardorok's orders!",
    duergar_watch_ord:  "ORD: Rootwatch post. Who sent you down? ...Nobody? Then you're fuel.",
    duergar_watch_ysk:  "YSK: Hands off the levers!",
    duergar_watch_brod: "BROD: Topsiders. In the Rootwatch. She'll stoke us all.",
    duergar_keep_hrem:  "HREM: Loose! Over the sap! Loose!",
    duergar_keep_vosh:  "VOSH: You crossed the sap-bridge? Then you don't leave it.",
    duergar_keep_dagna: "DAGNA: You crossed? Then I'm the one who stops you.",
    duergar_keep_turl:  "TURL: Fire replaces frost!",
    duergar_gate_kell:  "KELL: Aim for the bridge! The bridge!",
    duergar_gate_morn:  "MORN: Root-keep holds!",
    duergar_gate_sharl: "SHARL: (eyes hollow with fear) Please don't make me.",
    duergar_gate_ulf:   "ULF: Turn round. Turn round and I won't have to.",
    duergar_tower_grik: "GRIK: Intruders on the vantage!",
    duergar_tower_nall: "NALL: Down! Get down off my tower!",
    broken_duergar: "BROKEN DUERGAR: Fire replaces frost! FIRE REPLACES FROST!",
    rootbreaker_mechs: "(Two Infernal Rootbreakers lurch out of the silver pool, sap sheeting off their plates.)",
    avarice_opening: "AVARICE: Come along, then. Show me what survived."
  )

  #-----------------------------------------------------------------------------
  # Dialogue
  #-----------------------------------------------------------------------------
  TEXT.merge!(
    duergar_ruk_after: ["Xardorok. That's the name she lets us use. We've never seen him. We've only seen her."],
    duergar_varn_after: ["She killed the old thanes. All of them. In one night. We kept the name; she kept the rest."],
    duergar_watch_ord_after: ["The lift goes where the levers send it. Root, Deep, Forge."],
    duergar_watch_ysk_after: ["The hammerer's guarding the levers now. Was guarding. Is it still guarding?"],
    duergar_watch_brod_after: ["The controls past the post: don't touch the runes. They fight each other."],
    duergar_keep_hrem_after: ["The sap below us boils. Don't fall. Nobody comes back from the sap."],
    duergar_keep_vosh_after: ["Through there's the pens. I hear them crying at night."],
    duergar_keep_dagna_after: ["Go on down. The pens won't hurt you. They can't."],
    duergar_keep_turl_after: ["(staring at his hands) ...Fire replaces frost. Then what replaces fire?"],
    duergar_gate_kell_after: ["The gate's bar lifts once the root-keep's down. It's down. You're it."],
    duergar_gate_morn_after: ["Below the gate's the Dragonforge. You'll hear it before you see it."],
    duergar_gate_sharl_after: ["Thank you. I didn't want to hold it any more."],
    duergar_gate_ulf_after: ["I'll stay up here. Somebody has to tell the others it's over. If it's over."],
    duergar_tower_grik_after: ["You can see her from the rail. All that gold. Never blinks. I told you I don't look."],
    duergar_tower_nall_after: ["No more bolts. Whoever goes down there goes down without us shooting at them."],
    broken_duergar_after: ["...fire... replaces... ...", "(He goes back to chanting, softer now.)"],
    guardhold_pool: ["A pool of burning sap in a barracks of petrified root. Duergar sat round it till just now.",
                     "Their armour hangs on pegs, etched with glowing infernal runes."],
    avarice_bed: ["A bed of woven frostglass roots, cold as a grave. The room smells of ash and cold perfume."],
    root_archives: ["An office nobody's used in weeks. Maps of Rootspire's roots cover the walls.",
                    "Every sap-line, every tunnel, every place the roots run close to the old stones.",
                    "Someone has circled the Heartroot in red. And the Council Hall. And the dragons' Shrine."],
    shaft_ribs: ["Forty feet down, the light shows the supports: infernal iron, red-hot with her sigils.",
                 "They curve up out of the rootbone like the ribs of a colossal creature."],
    shaft_webbing: ["Old webbing hangs like shrouds, full of hag-spider husks, each the size of a dog."],
    bunker_hammock: ["A hammock woven from bark-sinew, slung between spiraling roots. A Warden slept here, once."],
    rootbeast_cage: ["A wooden cage, one bar gnawed half through. Cold smoke curls up from something inside."],
    gnawed_struts: ["Something has eaten through the iron struts here, leaving grooves like teeth marks.",
                    "The roots were laced with iron long ago, for the hag's rites. Rust-feasters graze it now."],
    thruun_throne: ["A throne of petrified bark on a dais of cracked mirror-stone, glowing faintly blue-white.",
                    "The old throne of Thruun. Nobody's sat in it for years. Somebody's been sitting beside it."],
    mirror_hall_after: ["The mirror-rock is just rock now, with thorn-holes in it.", "Your reflections look as tired as you are."],
    barracks_hammocks: ["Hammocks and root-bunks for dozens. In every one, a duergar staring at nothing."],
    rootwatch_levers: ["Levers grown from crystal roots, not made. Amber light pumps through them like blood.",
                       "The way past them to the sap-gate controls is locked to the Rootwatch's hammerer."]
  )

  module_function

  # Every trainer standing on this map has been beaten.
  def all_trainers_beaten_here?
    $game_map.events.values.select { |e| e.name =~ /^Trainer/ }.all? { |e| $game_self_switches[[$game_map.map_id, e.id, "A"]] }
  rescue StandardError
    true
  end

  # Several things picked up at once: one box naming the haul, not two boxes
  # an item (notes 07 E11's way; a stack of item boxes is a run with nothing in it).
  def give_haul(items, line)
    items.each do |item, qty|
      ok = ($PokemonBag.pbStoreItem(item, qty || 1) rescue false)
      give(item, qty || 1) if !ok                  # (a full pocket: the usual route to the PC)
    end
    pbMEPlay("Item get") rescue nil
    say([line])
  end

  def hurt_lead(fraction, line = nil)
    lead = $Trainer.first_able_pokemon rescue nil
    return if !lead
    lead.hp = [lead.hp - [(lead.totalhp * fraction).floor, 1].max, 1].max
    say([line.gsub("{1}", lead.name)]) if line
  end

  #=============================================================================
  # Level 1 - the Barricade's inner rooms (2146)
  #=============================================================================
  def scene_inner_rooms_enter
    return if flag?(:inner_rooms_entered)
    set_flag(:inner_rooms_entered)
    say(["Root-walls twist into a narrow chamber filled with the soft drip of warm sap.",
         "The puddles reflect you wrong: strangers with your faces, standing a little too close.",
         "One reflection smiles.", "None of you do."])
  end

  # A2: the Echo Hall: a remnant of the hag's mirror magic.
  def echo_hall(event_id = nil)
    say(["You look into a sap puddle. Your reflection stands a step closer than you do."], event_id)
    return if flag?(:echo_hall_stared)
    set_flag(:echo_hall_stared)
    say(["You stare too long. For a moment you can't tell which of you is the reflection."])
    sayc([cl(:alberica, "Hag-glass. Thredra's leftovers. Don't let it get a good look at you, darling."),
          cl(:meat_meat, "Meat Meat stamps in the puddle. There. No more face.")])
  end

  # A5: Avarice's quarters.
  def avarice_mural(event_id = nil)
    say(["Above the bed, a mural: Auril and a horned, winged figure, locked in a frozen storm.",
         "You can't tell if they're fighting or dancing. Maybe Avarice couldn't either."], event_id)
    return if flag?(:saw_avarice_mural)
    set_flag(:saw_avarice_mural)
    sayc([cl(:alerion, "Auril doesn't dance."),
          cl(:glimmer, "That's not a painting of a war. That's a painting of a deal.")])
  end

  def avarice_journal(event_id = nil)
    say(["A journal lies open on the desk, pages blackened at the edges. A neat white hand:",
         "\"Raz-MKIII showed resilience. The goblin survived far longer than expected.\"",
         "\"The frost-born subject screamed the name 'Alberica' before expiring.\"",
         "\"The cycle fails. Fire must replace the rime.\""], event_id)
    return if flag?(:read_avarice_journal)
    set_flag(:read_avarice_journal)
    add_counter(:story_beats)
    sayc([cl(:meat_meat, "Raz-MKIII. Razzy. \"Showed resilience.\" Razzy showed TEETH.")])
    if with_or_is?(:alberica)
      speak(:alberica, "(very quietly) Somebody screamed my name. Down here. Before I was ever here.", "...My name.")
    end
    sayc([with_or_is?(:alberica) ? cl(:reptin, "(to #{herald?(:alberica) ? 'you' : 'Alberica'}, gently) Something of Auril's she cut open. And it knew you.") :
                                   cl(:reptin, "A frost-born subject. Something of Auril's she cut open, and it knew Alberica.")])
  end

  # Under the loose floorboard: the Ledger of Corruption (evidence for the Trials).
  # The Ledger of Corruption lives atop the Council tower (Tab 8 Q6: the trial
  # week's break-in into Summer's quarters, 047d tower_stair): down here, only
  # the hollow it was kept in, and the note that sends you up the tower.
  def loose_floorboard(event_id = nil)
    return say(["The loose floorboard, and the empty hollow under it."], event_id) if flag?(:ledger_found) || flag?(:ledger_trail)
    say(["One floorboard of frostglass root sits a finger higher than the rest."], event_id)
    return if !pbConfirmMessage(_INTL("Lift it?"))
    say(["Under it, a hollow lined with oilcloth, the shape of a book. Empty.",
         "Caught in the fold, a scrap of paper in a neat white hand:",
         "\"Ledger to the tower. Nothing that matters stays below.\""])
    set_flag(:ledger_trail)
    sayc([cl(:alberica, "\"The tower.\" Which one? This city's nothing but towers."),
          cl(:reptin, "Then it's waiting up one of them. When the city lets us near a stair.")])
  end

  # A5's trap: the mirror-root effigy of Auril lashes out with psychic cold.
  def auril_effigy(event_id = nil)
    return say(["The effigy lies cracked across, its frost gone grey."], event_id) if flag?(:effigy_broken)
    say(["A statue of Auril, grown from mirror-root, stands in the corner.",
         "As you pass, its head turns. Its eyes are your eyes. Psychic cold pours out of it!"], event_id)
    if flag?(:gallery_boon) && !flag?(:gallery_boon_used)
      set_flag(:gallery_boon_used)
      say(["(The Wennen scout's blessing: the cold slides off your minds like snow off a roof.)",
           "The cold finds nothing to hold. The effigy cracks across the face on its own."])
      return set_flag(:effigy_broken)
    end
    return if !boss_battle(named_mon(:B429H551, 46, "Mirror-root effigy"))
    set_flag(:effigy_broken)
    say(["The effigy cracks across the face. The cold goes out of the room like a held breath."])
  end

  # A6: the traitor.
  def traitor_duergar(event_id = nil)
    if flag?(:traitor_met) && flag?(:engine_dead)
      return say(["The sooty duergar sits on a crate, scrubbing at the cold sigils on his arms with snow.",
                  # (notes 08 E25: not "Bram", the Ch2 hiker's name)
                  "DURN: You asked my name. Before. It's Durn. Durn Coalhand. Of Thane Ostra's hold.",
                  "DURN: (looking at his hands) It came back when the fire went out. Funny, what comes back."], event_id)
    end
    if flag?(:traitor_met)
      return say([flag?(:barricade_passed) ? "SOOTY DUERGAR: You're through. Good. Go and do it. Kill her." :
                                             "SOOTY DUERGAR: The lever. By the machinery. Pull it, and the Barricade gate's yours."], event_id)
    end
    set_flag(:traitor_met)
    add_counter(:story_beats)
    say(["A lone duergar paces beside sap-fed machinery, eyes bloodshot, beard crusted with soot.",
         "He flinches when he sees you. Then he whispers:",
         "SOOTY DUERGAR: Kill her. Kill the Forge-Mistress before she burns the Dale."], event_id)
    c = pbMessage(_INTL("The duergar waits."), [_INTL("\"Tell us about her.\""), _INTL("\"Why should we trust you?\"")], 0)
    if c == 1
      say(["SOOTY DUERGAR: You shouldn't. Trust my runes. Look: they're cold. She can't hear me."])
    end
    # (dialogue 08 §4.4, §5: somebody pushes back, so it's an exchange, not a speech)
    sayc(["SOOTY DUERGAR: The thanes found the hag's old warrens, and thought: a fortress. Ours.",
          "SOOTY DUERGAR: She came out of a mirror and killed all six thanes, at their own table.",
          cl(:reptin, "(quietly) And you stayed."),
          "SOOTY DUERGAR: She burned the sigils in. You don't leave, after.",
          "SOOTY DUERGAR: She told us her name was Xardorok. Our old king's name. We had to say it.",
          "SOOTY DUERGAR: She talks of a Great Unchaining: the dragon flies, the seasons come loose.",
          cl(:alberica, "The Great Unchaining. She does love a title."),
          "SOOTY DUERGAR: Summer forever, she says. The Dale goes to the Hells, warm. She goes up.",
          "SOOTY DUERGAR: That lever opens the Barricade gate from this side. Pull it. End her."])
    sayc([cl(:meat_meat, "Meat Meat will end her. Meat Meat has been practising."),
          cl(:reptin, "(gently) What's your name, friend?"),
          "SOOTY DUERGAR: I had one. Before the sigils. Ask me after."])
    set_flag(:knows_great_unchaining)
  end

  def gate_lever(event_id = nil)
    return say(["The lever stands down. Far off, the Barricade gate stands open."], event_id) if flag?(:barricade_passed)
    say(["Sap-fed machinery, grown as much as built. An iron lever juts from a root like a bone."], event_id)
    if !flag?(:traitor_met)
      return say(["It's locked with a burning sigil. Somebody who knows the machinery could free it."])
    end
    return if !pbConfirmMessage(_INTL("Pull the lever?"))
    pbSEPlay("Door exit") rescue nil
    say(["The sooty duergar puts his hand over yours and pulls with you.",
         "Far off, iron grinds. The Barricade gate's bar slides back."])
    set_flag(:barricade_passed)
    set_flag(:traitor_lever)
    ($game_switches[SW_BARRICADE_OPEN] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    state[:goal] = "Back to the Barricade gate. It's open now: east, and down into the hag's old lair."   # (notes 08 F15)
  end

  #=============================================================================
  # Level 2 - the Hag's Abandoned Domain
  #=============================================================================
  def scene_deep_shaft_enter
    return if flag?(:deep_shaft_entered)
    set_flag(:deep_shaft_entered)
    add_counter(:story_beats)
    say(["Below the World Tree's roots, the hag once cracked seasons apart in her mirrors.",
         "A chasm yawns before you, plunging down into darkness lit by pulses of molten gold.",
         "The walls are ribbed with petrified roots, charred at the tips. The air is warm and sour.",
         "Something deep below beats, slow and steady, like a heart too large to name."])
    sayc([cl(:alberica, "Oh, I remember this smell. Rot, sap, and old magic that doesn't know it's dead."),
          cl(:wyn, "(very small) The tree is hurting down here. All the way down.")])
  end

  # A11: the lagging mirror, and a future self.
  def bunker_mirror(event_id = nil)
    say(["A cracked mirror leans against the wall. It shows the room a half-second late.",
         "Your party's reflection moves just a fraction wrong."], event_id)
    return if flag?(:future_self_warned)
    return if !pbConfirmMessage(_INTL("Look into it?"))
    set_flag(:future_self_warned)
    add_counter(:story_beats)
    say(["You look. In the glass, you're older. Frostbitten. Tired in a way you haven't earned yet.",
         "Your reflection leans close to the glass and whispers:",
         "\"Don't let her take the heart...\"",
         "Then it's only you, a half-second late."])
    sayc([flag?(:read_overlook) ? cl(:alerion, "Nearly the same words as the overlook. \"She will take the heart if we don't.\"") :
                                  cl(:alerion, "Whoever you are in there, you sound tired."), cl(:glimmer, "Everybody down here keeps warning us about a heart."),
          cl(:alberica, "Then we find out whose heart, kitten. Before she does.")])
  end

  # A10: the abandoned guest quarters. Meat Meat's past.
  def dragon_limb(event_id = nil)
    say(["On a workbench, a half-made mechanical limb: a dragon's foreleg of chardalyn and gears.",
         "Its gears are ticking faintly, though nothing is driving them.",
         "Runes are etched along the joints, in the same hand as the sigils on the duergar's arms."], event_id)
  end

  def limb_notes(event_id = nil)
    say(["Scribbled notes, pinned under the limb's claw:",
         "\"Heart nearly stable. Needs more frost essence.\"",
         "\"The goblin sample failed.\""], event_id)
    return if flag?(:read_limb_notes)
    set_flag(:read_limb_notes)
    if herald?(:meat_meat)
      speak(:meat_meat, "The goblin sample did not fail. The goblin sample LEFT.", "...Didn't fail.")
    elsif with_or_is?(:meat_meat)
      say(["MEAT MEAT: (tearing the page off) The goblin sample did not fail. The goblin sample LEFT."])
    end
    sayc([cl(:reptin, "With a dragon. On purpose. Best escape I ever heard of.")])
  end

  # A12: the Rootward training hall.
  def scene_training_hall_enter
    return if flag?(:training_hall_entered)
    set_flag(:training_hall_entered)
    say(["Roots weave into a circular hall full of wooden dummies bound in thorn-vines.",
         "The air is warm, too warm, as if the walls are breathing out heat."])
  end

  def training_hall(event_id = nil)
    return say(["The dummies hang limp in their thorn-vines, their ember-eyes dark."], event_id) if flag?(:golems_down)
    say(["The vines twitch. The dummies jerk upright, eyes glowing with emberlight.",
         "Sap golems! Heat haze rolls off them in waves."], event_id)
    return if !boss_battle(named_mon(:B369H185, 47, "Sap golem"), named_mon(:B185H369, 47, "Sap golem"))
    set_flag(:golems_down)
    ($game_switches[SW_GOLEMS] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    say(["The golems slump back into dummies. The thorn-vines across the far door unravel."])
  end

  # A13: the sap-lift: Root (the Barricade), Deep (here), Forge (Level 3).
  def sap_lift(stop, event_id = nil)
    if !$game_switches || !$game_switches[SW_SAPLIFT]
      return say(["A pillar of glowing sap flows upward through a wound in the wood.",
                  "A platform of hardened sap drifts on it like a leaf.",
                  "An iron console juts from the roots, marked with three sigils: Root, Deep and Forge.",
                  "It won't answer. The Rootwatch's levers run it, and the Rootwatch is still manned."], event_id)
    end
    say(["The sap-lift hums. Root, Deep, Forge."], event_id)
    names = { root: _INTL("Root (the Barricade)"), deep: _INTL("Deep (the training hall)"), forge: _INTL("Forge (the Root-Throne)") }
    keys = %i[root deep forge] - [stop]
    c = pbMessage(_INTL("Where does the lift go?"), keys.map { |k| names[k] } + [_INTL("Stay here")], keys.size)
    return if c.nil? || c >= keys.size
    dest = keys[c]
    if dest == :forge && !flag?(:forge_upper_reached)
      return say(["The Forge sigil flares and dies. The lift won't go somewhere you haven't been yet."])
    end
    say(["The platform drifts on the sap like a leaf in a slow river."])
    transfer(*SAPLIFT_STOPS[dest])
  end

  # A14: the Rootwatch's Infernal Rootbreaker; A22: the elevator's.
  def rootbreaker(where, event_id = nil)
    key = :"rootbreaker_#{where}"
    return say(["The Rootbreaker lies in its own puddle of cooling sap."], event_id) if flag?(key)
    if where == :watch && !all_trainers_beaten_here?
      return say(["A duergar hammerer in infernal iron guards the levers. Its crew is still at its back."], event_id)
    end
    say(["A duergar hammerer, more machine than duergar, stomps forward: an Infernal Rootbreaker.",
         "Its eyes flare molten red."], event_id)
    return if !boss_battle(named_mon(where == :watch ? :B293H59 : :B337H229, where == :watch ? 48 : 49, "Infernal Rootbreaker"))
    set_flag(key)
    # (notes 08 E7: it bursts, so it's gone; a puddle where it stood)
    hulk = event_id ? $game_map.events[event_id] : nil
    Stage.fx("E-07", hulk, frames: 8) if hulk
    say(["It bursts, splashing molten sap!"])
    set_self_switch(event_id, "A") if event_id
    hurt_lead(0.12, "{1} is scalded by the splash.")
    if where == :watch
      set_flag(:rootwatch_cleared)
      ($game_switches[SW_ROOTWATCH] = true; $game_switches[SW_SAPLIFT] = true; $game_map.need_refresh = true if $game_map) if $game_switches
      add_counter(:story_beats)
      say(["With the Rootbreaker down, the levers are free.", "Far above, by the Barricade gate, the sap-lift hums awake. Root, Deep, Forge."])
    else
      set_flag(:forge_upper_reached)
    end
  end

  # A15: the sap-gate controls: once a winter altar.
  def sapgate_controls(event_id = nil)
    say(["A vast heartroot hangs from the ceiling, carved with runes of command.",
         "As you step closer, the runes flicker between frost-blue and hellish red."], event_id)
    return if flag?(:winter_altar_known)
    set_flag(:winter_altar_known)
    # (dialogue 08 §4.7: one feels it, the other answers her, nobody reads it out)
    if with_or_is?(:alberica)
      speak(:alberica, "(a hand on her rune) It itches. Like someone writing on me.", "...It itches.")
    end
    if with_or_is?(:alerion)
      speak(:alerion, "Someone's writing on it. That's a winter altar, under the red.", "...A winter altar, under the red.")
    elsif with_or_is?(:wyn)
      speak(:wyn, "It was a winter altar. Once. Her old magic, under the red.", "...A winter altar, once.")
    else
      say(["(Under the red runes, older blue ones: a winter altar once. Someone is rewriting it.)"])
    end
  end

  # A16: the Scratching Hollow.
  def scene_umbound_enter
    return if flag?(:umbound_entered)
    set_flag(:umbound_entered)
    say(["A long chamber of tangled roots and soft dirt. Under the floor: a slow, hungry scratching."])
  end

  def umber_hulk(event_id = nil)
    return if flag?(:umber_hulk_done)
    say(["The scratching stops."])
    $game_screen.start_shake(6, 8, 24) rescue nil     # (notes 08 E9)
    pbSEPlay("Earth4") rescue nil
    say(["Then the floor explodes.",
         "A beetle big as a cart heaves out of the earth: an umber hulk, eyes grown over with sap.",
         "Two duergar shapes at the far end of the chamber flicker and vanish, invisible, fleeing."])
    return if !boss_battle(named_mon(:B208H51, 48, "Umber hulk"))
    set_flag(:umber_hulk_done)
    add_counter(:story_beats)
    sayc([flag?(:saw_claw_marks) ? cl(:alerion, "Those were its claw-marks, by the Underdark mouth. Going up.") :
                                   cl(:alerion, "Something that big has been digging up through the roots for weeks."),
          cl(:reptin, "Then it came all this way to meet us. Rude not to.")])
  end

  # A17: the rust-feast tunnels.
  def rust_feasters(event_id = nil)
    return say(["The rust-feasters are gone. The struts round here are gnawed to lace."], event_id) if flag?(:rust_feasters_done)
    say(["Metallic crunching. A faint acrid smell.", "Three rust-feasters look up from an iron strut, antennae twitching, at your Pokémon."], event_id)
    return if !boss_battle(named_mon(:B356H421, 47, "Rust-feaster"), named_mon(:B421H356, 47, "Rust-feaster"))
    say(["The third rust-feaster skitters out of the dark for the iron on your belts."])
    return if !boss_battle(named_mon(:B356H421, 46, "Rust-feaster"))
    set_flag(:rust_feasters_done)
  end

  #=============================================================================
  # The Cocoon Pens (2074): A27 the rootbeast pens, A28 the prison cocoons
  #=============================================================================
  def rootbeast_pens(event_id = nil)
    say(["Wooden cages line the room, each holding a malformed root-beast: half-grown, half-forged.",
         "One has a mechanical limb. Another breathes cold smoke.",
         "They whine and cower as you come close."], event_id)
    return if flag?(:saw_rootbeasts)
    set_flag(:saw_rootbeasts)
    sayc(["Burned into each cage: RAZ-PROTOTYPE. A number. A line through it.",
          cl(:meat_meat, "These are... before Razzy. Practice Razzies. Meat Meat is going to be sick."),
          cl(:wyn, "(kneeling by the bars) Hey. It's all right. ...Can we let them out? At least that?")])
    if pbConfirmMessage(_INTL("Open the cages?"))
      set_flag(:rootbeasts_freed)
      wheel(1)
      say(["You open the cages. The root-beasts press against your legs, then slip into the roots."])
      beast = event_id ? $game_map.events[event_id] : nil
      Stage.leave(beast, 2, 3) if beast             # (notes 08 E7: they go, and stay gone)
      set_self_switch(event_id, "A") if event_id
    end
  end

  def prison_pod(n, event_id = nil)
    if n == 1 && !flag?(:rootwarden_plea)
      set_flag(:rootwarden_plea)
      return say(["Root-pods hang from the ceiling, each with a prisoner in amber like a trapped insect.",
                  "Some twitch. Some weep. Some stare blankly.",
                  "One Rootwarden lifts his head as you pass, and whispers:",
                  "ROOTWARDEN: She's burning the seasons away... please... stop her...",
                  # (context 08 §6: what the Rootwardens think Reptin is, before Ch9 leans on it)
                  with_or_is?(:reptin) ? "ROOTWARDEN: (seeing #{herald?(:reptin) ? 'you' : 'Reptin'}) ...Warden. You came. The Hall said you would." : nil].compact,
                 event_id)
    end
    key = :"prison_pod_#{n}"
    return say(["The pod hangs open and empty."], event_id) if flag?(key)
    return if !pbConfirmMessage(_INTL("Cut the prisoner free?"))
    set_flag(key)
    pod = event_id ? $game_map.events[event_id] : nil
    # (the child is a stand-in sprite until a duergar child's comes: see the report)
    freed = pod ? Stage.actor(%i[rootwarden fisherwoman duergar_child][n - 1] || :prisoner, pod.x, pod.y + 1, 2,
                              graphic: ["BW029", "BW (37)", "BW (17)"][n - 1] || "BW029") : nil
    case n
    when 1 then say(["The Rootwarden slides out and catches your arm.", "ROOTWARDEN: Stop her. Don't wait for me. Stop her."])
    when 2 then say(["A Ten-Towns fisherwoman tumbles out, still in her oilskins.", "FISHERWOMAN: Caer-Konig. She took the whole boat. Where's my boat?"])
    else        say(["A duergar child, no sigils yet. They run before you can say anything."])
    end
    Stage.leave(freed, 3, 2) if freed                 # (WRITING_GUIDE §9a: out, up the way you came)
    set_flag(:prisoners_freed) if flag?(:prison_pod_1) && flag?(:prison_pod_2) && flag?(:prison_pod_3)
  end

  #=============================================================================
  # Level 3 - the Dragonforge (2150, 2151, 2152)
  #=============================================================================
  def scene_forge_womb
    return if flag?(:forge_womb_seen)
    set_flag(:forge_womb_seen)
    set_flag(:forge_upper_reached)
    add_counter(:story_beats)
    say(["The air down here is warm, too warm, like a fever hiding under skin.",
         "Every surface pulses faintly with amber light: roots, stone, metal.",
         "This is the hollow heart of the hag's first lair, where mirror-rock and wood fused.",
         "The duergar dug the chambers. Avarice made them a womb of iron, flame and frost.",
         "Something is alive in this place.", "And something is trying to be born."])
  end

  # A19: the quaggoth and the myconid.
  def thruun_throne(event_id = nil)
    return say(["The quaggoth's brand lies cold on the dais."], event_id) if flag?(:quaggoth_down)
    say(["A quivering fungal creature hangs suspended from thorny vines.",
         "Beside it, a white-furred brute, more beast than man, burns it with a hot brand.",
         "Each strike releases a puff of glowing spores. Both turn as you enter."], event_id)
    return if !boss_battle(named_mon(:B217H262, 49, "Quaggoth"))
    set_flag(:quaggoth_down)
    say(["The quaggoth goes down across the dais, and its brand hisses out in a puddle of sap."])
    # (notes 08 E7: it went down, so it isn't standing; its brand is left)
    brute = event_id ? $game_map.events[event_id] : nil
    FrostThaw.stage_fade(brute, 0, 6, 2) if brute
    set_self_switch(event_id, "A") if event_id
  end

  def tortured_myconid(event_id = nil)
    if flag?(:myconid_mercy) || flag?(:myconid_carried)
      return say([flag?(:myconid_mercy) ? "A ring of spores on the floor, glowing faintly, going out one by one." :
                                          "Empty vines. Wyn's satchel glows faintly blue."], event_id)
    end
    say(["The fungal creature in the vines lifts its cap a little. Its voice is barely a tremble:",
         "MYCONID: Please... let me die..."], event_id)
    return if !flag?(:quaggoth_down) && !pbConfirmMessage(_INTL("The quaggoth is still here. Go to the myconid anyway?"))
    if with_or_is?(:wyn)
      speak(:wyn, "(spore to spore) ...She's been using its spores to make the constructs walk.", "...She's been using it.")
    else
      say(["(Its spores drift onto the roots, and they twitch. That's what made the constructs walk.)"])
    end
    set_flag(:myconid_spores_known)
    opts = [_INTL("Grant its wish")]
    opts << _INTL("Carry its spores home to Hyphora") if with_or_is?(:wyn)
    c = pbMessage(_INTL("The myconid waits."), opts, 0)
    if c == 1
      set_flag(:myconid_carried)
      say(["Wyn holds it very gently while it lets go of itself, spore by spore, into Wyn's satchel.",
           "MYCONID: (fading, almost a hum) ...Home. Thank you."])
      sayc([cl(:wyn, "(very quietly) Hyphora will have it back. Nothing goes to waste. Not even this.")])
      wheel(1)
    else
      set_flag(:myconid_mercy)
      say(["You cut the vines. It sighs, a long blue sigh of spores, and is still."])
    end
    myc = event_id ? $game_map.events[event_id] : nil
    FrostThaw.stage_fade(myc, 0, 8, 3) if myc
    set_self_switch(event_id, "A") if event_id
  end

  # A20: the broken root-works.
  def broken_works(event_id = nil)
    say(["Part of the ceiling has come down. Mirror-rock glitters on the floor like shattered stars.",
         "Four duergar hide in the rubble, exhausted, terrified, sigils carved into their flesh.",
         "DUERGAR: (whispering) Don't fight. She watches everything. The Forge-Mistress watches.",
         "DUERGAR: Even the roots obey her."], event_id)
    return if flag?(:broken_works_told)
    set_flag(:broken_works_told)
    sayc([cl(:glimmer, "Then go up. Now, while she's busy watching us."),
          "They look at each other. Then they go up, toward the sap-lift, as quietly as they can."])
    hiders = event_id ? $game_map.events[event_id] : nil
    Stage.leave(hiders, 5, 3) if hiders               # (notes 08 E7: and they're gone)
    set_self_switch(event_id, "A") if event_id
  end

  # A21: the heart-fuel.
  def heart_fuel(event_id = nil)
    say(["Ironwood shelves hold dozens of flasks of frostfire: blue at the edges, red at the core.",
         "The air shivers around them, cold and heat wrestling in every breath.",
         "Heart-fuel, distilled from the engine. She means to burn it into the dragon's core."], event_id)
    return if flag?(:frostfire_flask)
    return if !pbConfirmMessage(_INTL("Take a flask?"))
    if rand(2) == 0
      hurt_lead(0.12, "The flask bites with frost as you lift it. {1} shudders with cold.")
    else
      hurt_lead(0.12, "The flask flares with heat as you lift it. {1} flinches from the burn.")
    end
    give_key(:FT_FROSTFIREFLASK)
    set_flag(:frostfire_flask)
    # (dialogue 08 §4.10, §3: no See & Say; no pet names from Reptin)
    sayc([cl(:alerion, "(holding it at arm's length) That cold came out of somebody."),
          cl(:reptin, "Evidence. The Council adores evidence. Wrap it in something thick.")])
  end

  # A23: the root-keep gate.
  def rootkeep_gate(event_id = nil)
    if !all_trainers_beaten_here?
      return say(["A fortified gate of living root and hammered iron bars blocks the ramp down.",
                  "The root fibres shift, testing you. Somebody behind you is still aiming a crossbow."], event_id)
    end
    say(["The last crossbowman lifts the gate's bar from the inside, and steps back.",
         "The ramp beyond runs down into heat and hammering: the Dragonforge."], event_id)
    set_flag(:rootkeep_gate_open)
    ($game_switches[SW_L3_GATE] = true; $game_map.need_refresh = true if $game_map) if $game_switches
  end

  # A24: the west vantage. First sight of the dragon.
  def vantage_west(event_id = nil)
    say(["A balcony overlooks a vast chamber of burning amber and twisted metal.",
         "You see it now: the dragon. Chained. Unchained. Alive. Not alive.",
         "Its body glints with chardalyn and mirror-glass scales, each plate veined with frostfire.",
         "It thrashes once."], event_id)
    $game_screen.start_shake(5, 7, 20) rescue nil      # (notes 08 E9)
    say(["The whole chamber trembles."])
    return if flag?(:dragon_seen_vantage)
    set_flag(:dragon_seen_vantage)
    add_counter(:story_beats)
    if with_or_is?(:meat_meat)
      # (notes 08 §3: the spoken word in a box of its own, with a bubble)
      if herald?(:meat_meat)
        say(["(Razzy.) A picture slams into your head from far above: Razzilith, every scale on end.",
             "(He's screaming. He knows it. He KNOWS it.)"])
      else
        say(["MEAT MEAT: (grabbing the rail) Razzy.",
             "Far above, Razzilith screams: a picture in all your heads, every scale on end."])
      end
    end
    if with_or_is?(:glimmer)
      say(["The Lumen Shard in Glimmer's chest flares bright as a lamp. He presses a hand over it.",
           "GLIMMER: (through his teeth) The Shard knows that thing. It wants to go and meet it."])
    end
    sayc([cl(:alerion, "Chardalyn. Demon-forged. Black as a bad tooth."),
          cl(:alerion, "Built on what she learned from Razzy. From Meat Meat. The cold table, with wings.")])
  end

  # A25: the east vantage: its guards would rain bolts on the forge fight.
  def vantage_east(event_id = nil)
    if all_trainers_beaten_here?
      if !flag?(:vantage_cleared)
        set_flag(:vantage_cleared)
        say(["Bolt-slits aimed down at the forge floor, and racks of red-hot bolts, abandoned.",
             "Nobody is going to rain bolts on whoever fights her down there. Not now."], event_id)
        sayc([cl(:reptin, "One less thing shooting at us. I'll take it.")])
      else
        say(["The bolt-slits are empty. The racks have gone cold."], event_id)
      end
    else
      say(["The platform shakes with every beat of the chamber below. Chains rattle like thunder.",
           "Bolt-slits aimed at the forge floor. The guards are still at them."], event_id)
    end
  end

  # A29: the mind-flayer corpse.
  def mindflayer_corpse(event_id = nil)
    # (notes 08 F6: what you see first; the D&D name after)
    say(["Slumped over a scorched circle: a frost-burned corpse with a squid's face. A mind flayer.",
         "Its skull has been opened. Someone took its brain out with surgical precision."], event_id)
    return if flag?(:saw_mindflayer)
    set_flag(:saw_mindflayer)
    sayc([cl(:alerion, "(crouching) Its last thoughts are still in the circle. Rage. Then nothing."),
          # (dialogue 08 §4.12: her under-pressure habit, not Avarice's word)
          cl(:alberica, "(quietly) Somebody ought to sing for it. Nobody will."),
          cl(:wyn, "...She takes everything apart to see how it works. Even people. Even gods.")])
  end

  # A30: the lower elevator: back down to the root-keep gate.
  def lower_elevator(event_id = nil)
    say(["A woven platform circles down a spiral. Sap flows up past it like rain in reverse."], event_id)
    return if !pbConfirmMessage(_INTL("Ride it down?"))
    transfer(*LOWER_ELEVATOR_FOOT)
  end

  #-----------------------------------------------------------------------------
  # Past the devil-priest's stair (2152)
  #-----------------------------------------------------------------------------
  def scene_sanctum_enter
    return if flag?(:sanctum_entered)
    set_flag(:sanctum_entered)
    say(["The black-glass stair opens into her rooms: a hall of mirror-rock, barracks, a vault.",
         "It's quieter up here. That's worse."])
  end

  # A32: the mirror-hall trap.
  def mirror_hall(event_id = nil)
    return if flag?(:mirror_hall_sprung)
    set_flag(:mirror_hall_sprung)
    say(["A corridor of mirror-rock reflects you over and over. Each reflection is slightly wrong.",
         "One bleeds from the eyes. One smiles too wide. One mouths:",
         "\"She will take the heart.\"",
         "Root-thorns burst from the mirrors!"])
    if flag?(:grotto_boon) && !flag?(:grotto_boon_used)
      set_flag(:grotto_boon_used)
      say(["(Rested in Lirielle's grotto, you don't flinch. You duck the thorns instead.)"])
    else
      hurt_lead(0.15, "A thorn takes {1} across the shoulder.")
    end
  end

  # A33: the barracks of the broken.
  def duergar_barracks(event_id = nil)
    say(["Dozens of duergar huddle in hammocks and root-bunks. Their eyes are vacant.",
         "They chant softly under their breath, all of them, the same words:",
         "\"Fire replaces frost... fire replaces frost...\""], event_id)
    return if flag?(:barracks_broken_seen)
    set_flag(:barracks_broken_seen)
    # (dialogue 08 §4.16: his own "friend", not a speech)
    sayc([cl(:reptin, "(crouching, gently) Friend? ...Friend."),
          cl(:alberica, "(her hand on her rune, very quiet) ...Fire replaces frost.")])
    c = pbMessage(_INTL("The broken duergar chant."), [_INTL("Leave them be"), _INTL("Try to shake one awake")], 0)
    return if c == 0
    say(["You shake the nearest one. Three rise at once, chanting louder, reaching for you!"])
    if trainer(:broken_duergar, nil)
      say(["They sit back down. They go on chanting, softer."])
    end
  end

  # A34: the tortured captain.
  def tortured_captain(event_id = nil)
    if flag?(:captain_saved) || flag?(:captain_died)
      return say([flag?(:captain_saved) ? "The captain sits against the wall in your blanket, sharpening a knife very slowly." :
                                          "The captain lies where he fell, his eyes closed. Somebody has folded his hands."], event_id)
    end
    say(["A duergar captain hangs bound to a root-spike, burned black. He doesn't lift his head.",
         "CAPTAIN: Kill her... or she will kill the seasons..."], event_id)
    if !flag?(:captain_hints)
      set_flag(:captain_hints)
      # (notes 08 E14: the vent as it plays; dialogue 08 §5: Alerion pushes back)
      sayc(["CAPTAIN: Listen. There isn't time. The spires round her pool: scratch her runes off them.",
            cl(:alerion, "Her runes are over Auril's. So we'd be feeding Auril."),
            "CAPTAIN: Better her than this one. She drinks less.",
            "CAPTAIN: Her engine vents once. If she floors you, it stands you both up again. Not twice.",
            "CAPTAIN: Clear the towers, or they'll shoot you while you fight. And watch her mirrors."])
    end
    return if !pbConfirmMessage(_INTL("Cut him down?"))
    heal = %i[FULLRESTORE MAXPOTION HYPERPOTION SUPERPOTION].find { |it| ($PokemonBag.pbHasItem?(it) rescue false) }
    if heal
      $PokemonBag.pbDeleteItem(heal) rescue nil
      say(["You cut him down and get a #{GameData::Item.get(heal).name rescue 'potion'} into him before the shock can.",
           "He breathes. He keeps breathing.",
           "CAPTAIN: ...Huh. I'd made my peace. Now I'll have to make it again."])
      set_flag(:captain_saved)
      wheel(1)
    else
      say(["You cut him down. He's lighter than he should be.", "CAPTAIN: Thank you. ...Go on.",
           "He doesn't say anything else. You had nothing to heal him with."])
      set_flag(:captain_died)
    end
  end

  # A35: Mother Thruuna's residual chamber.
  def thruuna_chamber(event_id = nil)
    return say(["The walls are quiet. Somewhere, very faint, an old woman is still laughing."], event_id) if flag?(:thruuna_lore)
    say(["This room is full of phantom laughter.",
         "A hag's silhouette flickers along the walls, muttering scraps of old spells."], event_id)
    set_flag(:thruuna_lore)
    add_counter(:story_beats)
    sayc(["SILHOUETTE: (to nobody) Twenty stones for twenty winters. A little winter in each mirror.",
          "SILHOUETTE: Break one, and the winter comes out. Break them all, and time comes loose.",
          # (dialogue 08 §4.17: not "as you know": what she never asked)
          cl(:alberica, "We broke twenty winters loose in that Chasm. Never asked where they went."),
          "SILHOUETTE: The rites of the mirror: what you see, you keep. What you keep, you are.",
          "SILHOUETTE: Mother's stones. Mother's kitchen. She took it all, the fire-girl. All of it."])
    ghost = event_id ? $game_map.events[event_id] : nil
    FrostThaw.stage_fade(ghost, 0, 10, 3) if ghost       # (notes 08 E7: she fades, so she's gone)
    set_self_switch(event_id, "A") if event_id
    sayc(["The laughter goes on after the silhouette fades.",
          cl(:alerion, "And the Stones are still down there. Round the dragon."),
          cl(:reptin, "Then we know what she's chained it to. Charming.")])
  end

  # A36: the rootbound mech guards.
  def mech_guards(event_id = nil)
    return if flag?(:mechs_down)
    say(["Two infernal root-constructs guard a door of knotted roots."], event_id)
    return if !boss_battle(named_mon(:B293H369, 49, "Rootbound mech"), named_mon(:B369H293, 49, "Rootbound mech"))
    set_flag(:mechs_down)
    ($game_switches[SW_MECHS] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    say(["The mechs fold down into heaps of root and iron. The vault door unknots itself."])
  end

  # A37: Avarice's root-vault.
  def vault_journal(event_id = nil)
    say(["A chamber grown from interlocking roots opens into a vault of heat and shadow.",
         "Things taken from Rootspire, tools from Ten-Towns caravans, things that pulse with aurora.",
         "A single journal lies open on a pedestal:",
         "\"Tomorrow, the dragon flies. Tonight, I will burn a path to godhood.\""], event_id)
    return if flag?(:vault_looted)
    set_flag(:vault_looted)
    add_counter(:story_beats)
    give_haul([[:FULLRESTORE, 2], [:MAXREVIVE, 1], [:PPMAX, 1], [:RARECANDY, 2]],
              "Things worth taking back: two Full Restores, a Max Revive, a PP Max, two Rare Candies.")
    sayc([cl(:meat_meat, "First light. The devil wasn't lying. Meat Meat hates that.")])   # (context 08 M8-6: the clock is on the spine now)
  end

  VAULT_RELICS = {
    mirror: [["A broken hand-mirror. Its crack runs exactly like the crack in Thredra's mirror."], :FT_BROKENFROSTMIRROR],
    note: [["A charred note in the neat white hand:",
            "\"V-7: recapture at any cost. The only proof that survived. Keep her alive; keep her cold.\""], :FT_CHARREDNOTE],
    scale: [["A green scale small as a thumbnail, in a velvet box. A label: \"Raz. First shed. Taken.\""], :FT_RAZZYSCALE],
    rose: [["A rose, frozen in bloom, in a jar of black ice. It's warm to the touch."], :FT_FROZENROSE],
    glaive: [["The Summer Marshal's badge, gold gone dull. Folded inside it, a Corsair cargo-list.",
              "Thirty blades, forty bows. No Council stamp."], :FT_MARSHALBADGE]
  }

  def vault_relic(kind, event_id = nil)
    text, item = VAULT_RELICS[kind]
    key = :"vault_relic_#{kind}"
    return say(["An empty space on the shelf, a clean shape in the dust where it sat."], event_id) if flag?(key)
    say(text, event_id)
    set_flag(key)
    # (Glimmer keeps Shimmer's rose; it comes back to you when he's gone, 034 scene_better_fire)
    give_key(item) if !(kind == :rose && with_or_is?(:glimmer))
    case kind
    when :mirror
      sayc([cl(:alberica, "Thredra's glass. She's been picking up after a dead woman.")])
    when :note
      if with_or_is?(:meat_meat)
        speak(:meat_meat, "Keep her cold. Meat Meat will keep HER cold. In the ground.", "...Keep her cold.")
      end
    when :scale
      if with_or_is?(:meat_meat)
        speak(:meat_meat, "(cheek to it) Razzy's. Razzy's first. Meat Meat is taking it home.", "...Razzy's.")
      end
      set_flag(:razzy_scale)
    when :rose
      if with_or_is?(:glimmer)
        say(["GLIMMER: (taking the jar, very carefully) Shimmer's rose. From the Glade. She kept it.",
             "GLIMMER: ...Everything's down here, isn't it. Everything she ever took.",
             "He puts the jar inside his coat, over the Lumen Shard, and says nothing for a while."])
        set_flag(:glimmer_has_rose)
      end
    when :glaive
      if flag?(:var_story_known)
        sayc([cl(:alerion, "Var's. The deal he made at the Split Dock. ...Then where's Var?")])
      else
        sayc([cl(:reptin, "The Marshal's badge. In her vault. ...Why does she have Var's badge?")])
      end
      set_flag(:corsair_arms_deal)
    end
  end

  #=============================================================================
  # Zone VI - the approach to the Heart (2153)
  #=============================================================================
  def scene_antechapel_enter
    return if flag?(:antechapel_entered)
    set_flag(:antechapel_entered)
    add_counter(:story_beats)
    say(["Root-columns glow from inside, green, white and red, like stained glass.",
         "At the far end, a doorway of braided roots opens and closes, like a breathing mouth."])
    sayc([cl(:wyn, "(barely a whisper) Last chance. To turn round."),
          cl(:wyn, "...I'm not turning round. I just thought someone should say it."),
          cl(:glimmer, "Noted, Wyn. Nobody's turning round.")])
  end

  # H22: two aurora-lit guardians test your resolve.
  def antechapel_guardians(event_id = nil)
    return say(["The guardians stand aside, faint as breath on glass."], event_id) if flag?(:antechapel_cleared)
    say(["Two figures step out of the columns, lit from inside by the aurora.",
         "They raise their hands: not to strike. To test."], event_id)
    if (flag?(:gallery_boon) && !flag?(:gallery_boon_used)) || (flag?(:grotto_boon) && !flag?(:grotto_boon_used))
      say(["(Their whisper of winter reaches for your fear, and finds none left to take.)"])
    end
    return if !boss_battle(named_mon(:B429H200, 49, "Aurora-lit guardian"), named_mon(:B200H429, 49, "Aurora-lit guardian"))
    set_flag(:antechapel_cleared)
    say(["The guardians bow, both at once, and fade into the columns."])
    guards = $game_map.events.values.select { |e| e.name == "Aurora-lit guardian" } rescue []
    10.times { |i| guards.each { |g| g.opacity = 255 - 25 * (i + 1) }; Stage.wait(3) }   # (notes 08 E7)
    ($game_switches[SW_ANTECHAPEL] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    say(["The breathing door holds its breath, open."])
  end

  # H22: the ghost-images of the Frost Saint Shard.
  def shard_echo(event_id = nil)
    say(["A ghost flickers between the columns: a drowned sailor with frost in his hair. Sephek.",
         "Not him: an echo of the thing in the engine, thrown up like light on a ceiling."], event_id)
    asked = (state[:shard_asked] ||= [])
    loop do
      opts = []
      opts << [:who, _INTL("\"What are you?\"")] if !asked.include?(:who)
      opts << [:purify, _INTL("\"What if we cleanse you?\"")] if !asked.include?(:purify)
      opts << [:keep, _INTL("\"What if we leave you whole?\"")] if !asked.include?(:keep)
      opts << [:break, _INTL("\"What if we break you?\"")] if !asked.include?(:break)
      break if opts.empty?
      c = pbMessage(_INTL("The echo waits."), opts.map(&:last) + [_INTL("Go")], opts.size)
      break if c.nil? || c >= opts.size
      key = opts[c][0]
      asked << key
      case key
      when :who
        say(["ECHO: A man she loved, who drowned. A goddess, poured into him like water into a jug.",
             "ECHO: A saint, they called it. They cut out his heart, and a forge-witch caged it to burn."])
      when :purify
        say(["ECHO: Burn her out of me with green fire and gold. What's left is a man's heart. Clean.",
             "ECHO: Put it back in him, and he'd wake as himself. He'd hate you for it, for a while."])
      when :keep
        say(["ECHO: Leave me whole, and I am hers, and she is in me. The goddess still waits in the ice.",
             "ECHO: Someone patient will come for me. Someone always does.",
             # (dialogue 08 §4.21: the echo wants something)
             "ECHO: (a drowned man's voice, under it) ...Don't. Don't leave me with her."])
      when :break
        say(["ECHO: Break me, and the saint is gone, and some of her with him.",
             "ECHO: But pieces of a god are still a god. Pieces get swept up."])
      end
    end
    if asked.size >= 4 && !flag?(:shard_echo_heard)
      set_flag(:shard_echo_heard)
      add_counter(:story_beats)
      sayc([cl(:alerion, "Three ways. None of them clean."),
            cl(:alberica, "Shimmer said there's always a third way. ...Bit much, having three.")])
    end
  end

  def breathing_door(event_id = nil)
    say(["The braided doorway breathes in, breathes out. Two figures in the columns turn their heads."], event_id)
  end

  # H32: the Thorn-Run Hall.
  def thorn_run(event_id = nil)
    say(["Thorned roots lash from the walls; a pulse of light makes it all happen a beat early!"])
    hurt_lead(0.08, "A thorn catches {1}.")
    set_flag(:thorn_run_crossed)
  end

  # H33: the Hammer-Heart workshop.
  def hammer_heart(event_id = nil)
    return say(["Root-golems hang from their hooks, still and finished."], event_id) if flag?(:hammer_heart_done)
    say(["A hidden workshop where half-made root-golems hang from hooks, swinging gently like meat."], event_id)
    return if !pbConfirmMessage(_INTL("Go in among them?"))
    say(["One of them opens its eyes. Then the next. They drop off their hooks."])
    return if !boss_battle(named_mon(:B369H337, 50, "Hammer-heart golem"), named_mon(:B337H369, 50, "Hammer-heart golem"))
    set_flag(:hammer_heart_done)
    say(["In the chest of the last golem, a core of warm amber: a heart, half-made."])
    give(:FT_GREATVERDANTSEED)
  end

  # H37: the Silent Chapel of the Patron.
  def silent_chapel(event_id = nil)
    if flag?(:chapel_done)
      return say(["The little shrine is quiet. The two sigils on it have stopped fighting, for now."], event_id)
    end
    say(["A hushed niche off the Heart, and a small shrine in it.",
         "Auril's sigil and Avarice's, woven together, each overwriting the other.",
         "As you come close, both of them speak."], event_id)
    say(["FROST SIGIL: (a winter morning) Bring me what's left of my saint, I'll be kind.",
         "FIRE SIGIL: (smiling) Leave the engine running. I'll make you summer's saints, every one."], event_id)
    c = pbMessage(_INTL("The two sigils wait."), [_INTL("Answer the frost"), _INTL("Answer the fire"), _INTL("Break the shrine")], 2)
    if c == 0
      set_flag(:chapel_auril)
      say(["FROST SIGIL: Good. Good. I'll remember you were polite.", "The fire sigil laughs, and goes on laughing quietly for a long time."])
    elsif c == 1
      set_flag(:chapel_avarice)
      wheel(-1)
      say(["FIRE SIGIL: Lovely. I knew you were reasonable.", "The frost sigil says nothing at all, which is worse."])
    else
      say(["You bring the shrine down. Out of the pieces rises a shape of frost and fire, furious!"])
      return if !boss_battle(named_mon(:B448H229, 51, "Avatar of two sigils"))
      set_flag(:chapel_broken)
      wheel(1)
      say(["The avatar comes apart into frost and sparks, and the sparks go out, and the frost melts."])
    end
    set_flag(:chapel_done)
  end

  #=============================================================================
  # After the Heart: H25 the Sloughing Veins, H26 the Echo Vault, H36 the
  # Aurora Treasury
  #=============================================================================
  def scene_sloughing_veins
    return if flag?(:veins_entered)
    set_flag(:veins_entered)
    say(["A tunnel of sloughing roots and cooling sap runs back toward Rootspire.",
         "Heat, dust and drifting frost mix in the air. Behind you, the Heart Chamber caves in."])
    pbSEPlay("Earth3") rescue nil
    $game_screen.start_shake(4, 6, 60) rescue nil       # (notes 08 E9: it's coming down)
    say(["Run."])
  end

  def veins_debris(event_id = nil)
    say(["Roots slough off the ceiling in a wet roar!"])
    $game_screen.start_shake(3, 6, 12) rescue nil
    if herald?(:reptin) && rand(2) == 0
      say(["You shoulder the others clear, half-wolf for a heartbeat, and take it on your back."])
    elsif with_or_is?(:reptin) && rand(2) == 0
      say(["Reptin shoulders you out of the way, half-wolf for a heartbeat, and takes it on his back.",
           "REPTIN: Keep going!"])
    else
      hurt_lead(0.08, "A falling root clips {1}.")
    end
  end

  def veins_mirror_spawn(event_id = nil)
    return if flag?(:veins_spawn_done)
    set_flag(:veins_spawn_done)
    say(["A last mirror-spawn pulls itself out of the cooling sap and grabs for the nearest ankle!"])
    if boss_battle(named_mon(:B122H429, 50, "Mirror-spawn"))
      say(["It shatters, and the sap it came from goes dull."])
    else
      say(["It drags you back three steps before somebody stamps on it."])
    end
  end

  def veins_bridge(event_id = nil)
    return if flag?(:veins_bridge_done)
    set_flag(:veins_bridge_done)
    say(["The last root-bridge over the drop is coming apart under your feet, fibre by fibre."])
    sayc([cl(:alerion, "Don't stop."), cl(:meat_meat, "Meat Meat is not stopping. Meat Meat is FLYING. Without a dragon."),
          cl(:alberica, "Everyone hold hands! ...No, that's slower, let go, let go!")])
    say(["You make it across. Behind you, the bridge folds down into the dark without a sound."])
  end

  def scene_echo_vault_enter
    return if flag?(:echo_vault_entered)
    set_flag(:echo_vault_entered)
    add_counter(:story_beats)
    say(["A small chamber grown from smooth heartroot. Quiet, at last. A stair of root goes up.",
         "The tree's whisper is faint here, and very tired."])
    if flag?(:attendant_promise) && attendant_promise_kept?
      say(["Somewhere in the walls, the many voices of the whispering attendant, very small:",
           "ATTENDANT: You kept it. The promise. The sap is calmer now. Take the seed. It's yours."])
      give(:FT_GREATVERDANTSEED)
      set_flag(:attendant_paid)
    end
  end

  def attendant_promise_kept?
    case state[:attendant_promise]
    when :burn then flag?(:engine_dead)
    when :free then flag?(:shard_purified) || flag?(:shard_preserved)
    else false
    end
  end

  def vault_guardian(event_id = nil)
    return say(["The guardian drifts in a slow circle, harmless now."], event_id) if flag?(:echo_guardian_done)
    say(["A lantern of root and glass drifts up from the floor and turns its glow on you."], event_id)
    return if !boss_battle(named_mon(:B337H353, 49, "Drifting guardian"))
    set_flag(:echo_guardian_done)
  end

  def echo_vault_pods(event_id = nil)
    return say(["The seed-pods are empty now, split like opened hands."], event_id) if flag?(:echo_pods_taken)
    say(["Seed-pods in the root like eggs in a nest, left for whoever gets this far. One glows."], event_id)
    set_flag(:echo_pods_taken)
    give_haul([[:FT_GREATVERDANTSEED, 1], [:FT_VERDANTSEED, 2]], "You take a Greater Verdant Seed, and two Verdant Seeds.")
  end

  def echo_vault_items(event_id = nil)
    return say(["A shelf of chardalyn fragments, picked over."], event_id) if flag?(:echo_items_taken)
    if !flag?(:echo_guardian_done) && !flag?(:echo_sap_lash)
      set_flag(:echo_sap_lash)
      say(["You reach for the shelf and a lash of sap whips out of the wall at the greedy hand!"])
      hurt_lead(0.1, "{1} takes the lash.")
    end
    say(["Among the chardalyn: a charm of verdant fire, a bark scroll, and a lens of mirror-glass.",
         "Through the lens, the air is full of drifting shapes you couldn't see before."], event_id)
    set_flag(:echo_items_taken)
    give_haul([[:FT_VERDANTFIRECHARM, 1], [:FT_CYCLEOFROOTS, 1]], "You take the Verdant Fire Charm and the Cycle of Roots.")
    give_key(:FT_MIRRORLENS)
    set_flag(:mirror_lens)
    sayc([cl(:alberica, "(peering through it) Oh, they're everywhere. Little ghosts. Shy ones."),
          cl(:meat_meat, "Meat Meat sees them. Meat Meat does not like being watched by soup.")])
  end

  # What each Herald sees when the tree's echo touches them: "a vision leading
  # to their personal secret quest" (rootspire.md 1617). A quest already done is
  # confirmed; one still open is pointed at, as the notes intend.
  ATTENDANT_VISIONS = {
    alberica:  [:key_found, "Alberica sees a Library door with her own handwriting on it, and a lock made of notes.",
                :canticle_learned, "Alberica sees the Still Sky Shrine at night, and an unsung verse waiting in the rafters.",
                "Alberica sees her own hand on the Library door, and the lock of notes opening. Done. Kept."],
    reptin:    [:staff_found, "Reptin sees petrified druids in sap under the Root-Tier, one with his totem in its hands.",
                :fields_pulse, "Reptin sees the Blooming Fields in flower and snow, and two whirlwinds, arguing.",
                "Reptin sees the totem warm in his hand, and the stone druids nodding. Done. Carried."],
    alerion:   [:mantle_found, "Alerion sees himself at the Auroral Wall, frozen mid-step, and hears: \"Finish the step.\"",
                :reflection_claimed, "Alerion sees a maze of mirror-ice, and his reflection walking away from him, deeper in.",
                "Alerion sees his reflection turn in the ice and walk back to him. The step is finished."],
    meat_meat: [:blade_found, "Meat Meat sees a driftwood chest on a beach, with a scorched \"A\" on the lid.",
                :mirror_child_free, "Meat Meat sees a boy holding a mirror, and a girl inside it, waving.",
                "Meat Meat sees the driftwood chest, empty, and her own footprints leading away. Good."],
    wyn:       [:spy_unmasked, "Wyn sees a mushroom ring in the dark that sings when they stand in the middle of it.",
                :undercity_done, "Wyn sees black water under the docks, and a colony with eyes, whispering their name.",
                "Wyn sees the mushroom ring again, quiet now, and themself sitting in it, not afraid."]
  }

  # A vision meant for the Herald you are, in the second person (context 08
  # §6: "You see her own hand", "whispering her name").
  def herald_vision(v)
    v.sub(/\A\w+(?: \w+)? sees/, "You see")
     .gsub(/\b(he|she) hasn't\b/, "you haven't").gsub(/\b(he|she) stands\b/, "you stand").gsub(/\bthey stand\b/, "you stand")
     .gsub(/\b(himself|herself|themself)\b/, "yourself").gsub(/\b(from|to) (him|her|them)\b/, '\1 you')
     .gsub(/\b(his|her|their)\b/, "your").gsub(/\band hears\b/, "and hear")
  end

  def attendant_vision(who)
    first_flag, first, second_flag, second, done = ATTENDANT_VISIONS[who]
    return first if !flag?(first_flag)
    return second if !flag?(second_flag)
    done
  end

  # H26: the World Tree's prophecy about the wyrmlings and the seasons.
  def world_tree_echo(event_id = nil)
    say(["You put your hand on the heartroot. Very faint, the tree speaks in a voice of leaves:"], event_id)
    # (context 09 M9-2: the riders and the third season are told on the spine
    # now, by Lumin at the Shrine; the tree keeps a shorter echo for the finder)
    say(["TREE: Two eggs in a dark place. Two seasons, curled small. One green and one white.",
         "TREE: The white carries the cold in, when it's time. The green carries it away.",
         "TREE: Seasons are not held. Seasons are turned."])
    return if flag?(:tree_prophecy)
    set_flag(:tree_prophecy)
    add_counter(:story_beats)
    sayc([cl(:meat_meat, "Razzy and Frostina. The tree remembers them small."),
          cl(:alberica, "(her hand on her rune) Not held. Turned. ...Hm.")])
    lines = ATTENDANT_VISIONS.keys.select { |k| with_or_is?(k) }
                             .map { |k| v = attendant_vision(k); herald?(k) ? "(#{herald_vision(v)})" : v }
    if !lines.empty?
      say(["Then the tree's voice goes quiet, and each of you sees something meant only for you."])
      Stage.overlay("O-03")                        # (notes 08 E9: O-03 means a vision)
      say(lines)
      Stage.overlay_off("O-03")
      set_flag(:personal_visions)
    end
  end

  # H36: the Aurora Treasury, more heavily trapped.
  def aurora_treasury(event_id = nil)
    return say(["The inner recess is bare. The auroral roots have stopped pretending to be anything."], event_id) if flag?(:aurora_treasury_done)
    say(["A recess where treasures lie webbed in auroral roots.",
         "As you reach in, the roots unclench. They were never roots."], event_id)
    return if !boss_battle(named_mon(:B439H290, 51, "Root-mimic"))
    set_flag(:aurora_treasury_done)
    give_haul([[:TM58, 1], [:PPMAX, 1], [:FT_AURORALMOTE, 3]],
              "The root-mimic lets go of everything it held: TM58, a PP Max, three Auroral Motes.")
  end

  # The way up, and out, to Rootspire: Chapter 9.
  def echo_vault_exit(event_id = nil)
    say(["A stair of living root climbs from the vault, toward warm air and the smell of the market."], event_id)
    return if !pbConfirmMessage(_INTL("Climb up, out of the Heartroot?"))
    say(["You climb for a long time. Nobody talks. Somewhere far above, something huge is flying."])
    say(["END OF CHAPTER 8"]) rescue nil
    state[:goal] = "Up. Back to the market. The dragon is loose."
    return chapter9_start if respond_to?(:chapter9_start)
    transfer(2050, 31, 28, 2)
  end

  def apply_forge_rooms_switches
    return if !active? || !$game_switches
    sync_switch(SW_SAPLIFT, flag?(:rootwatch_cleared))
    sync_switch(SW_ROOTWATCH, flag?(:rootwatch_cleared))
    sync_switch(SW_L3_GATE, flag?(:rootkeep_gate_open))
    sync_switch(SW_MECHS, flag?(:mechs_down))
    sync_switch(SW_ANTECHAPEL, flag?(:antechapel_cleared))
    sync_switch(SW_GOLEMS, flag?(:golems_down))
    sync_switch(SW_HEARTWALL, flag?(:heartwall_open))
    sync_switch(SW_RING_DONE, flag?(:ring_done))
    sync_switch(SW_BARRACKS_DONE, flag?(:barracks_done))
    sync_switch(SW_LIFT_NODE, flag?(:lift_node_run))
    sync_switch(SW_AMBER_PODS, flag?(:amber_sentries_down))
    sync_switch(SW_CIRCLE_PHASE, flag?(:circle_phase) && !flag?(:engine_dead))
  end

  #-----------------------------------------------------------------------------
  # Items: the Labyrinth's and the Forge's
  #-----------------------------------------------------------------------------
  RELIC_ITEMS.merge!(
    FT_VERDANTSEED: ["Verdant Seed", "Verdant Seeds", 1, 0,
      "A seed of living green that pulses like a heartbeat. It raises a Pokémon's level by one.", 1, 0, 0],
    FT_GREATVERDANTSEED: ["Greater Verdant Seed", "Greater Verdant Seeds", 1, 0,
      "A seed from deep in the Heartroot, heavy and warm. It raises a Pokémon's level by three.", 1, 0, 0],
    FT_SHARDFOCUS: ["Mirror Shard Focus", "Mirror Shard Foci", 8, 0,
      "A clean, flat shard from the Shattered Bed. It shows things a little more truly than they are. Once.", 0, 0, 6],
    FT_GLASSSIGIL: ["Glass Sigil", "Glass Sigils", 8, 0,
      "A crystal from Avarice's Scriptory with a sigil turning inside it. The glass half of a door of iron and glass.", 0, 0, 6],
    FT_VARGLAIVE: ["Var's Glaive", "Var's Glaives", 8, 0,
      "The Summer Marshal's glaive, its blade of melted mirror-shard. It hums when Sephek is near.", 0, 0, 6],
    FT_CORRUPTLEDGER: ["Ledger of Corruption", "Ledgers of Corruption", 8, 0,
      "Halo payments, lists of Ten-Towners marked for the lottery, and \"Project Rime: reforge the Everlasting Summer.\"", 0, 0, 6],
    FT_BOYSMIRROR: ["Boy's Mirror", "Boy's Mirrors", 8, 0,
      "A frost-glass hand-mirror from Mira's stall. Something in it is watching you carry it. Its twin is in the Heartroot.", 0, 0, 6],
    FT_MIRRORLATTICE: ["Mirror Lattice", "Mirror Lattices", 8, 0,
      "Two mirrors fused by a lattice of frost-crystal, with a fragment of Avarice caught inside. Very quiet. Very angry.", 0, 0, 6],
    FT_ROOTCOMPASS: ["Guild Root-Compass", "Guild Root-Compasses", 8, 0,
      "Hew's gift: a brass compass with a sap-bead for a needle, built from Prototype 3's spare parts. It points to whatever's warmest below. It ticks.", 0, 0, 6],
    FT_DEADCOMPASS: ["Burnt-Out Compass", "Burnt-Out Compasses", 8, 0,
      "Hew's compass, its sap-bead cracked and black. Something in it spoke in a woman's voice. Now it doesn't.", 0, 0, 6],
    FT_FROSTFIREFLASK: ["Frostfire Flask", "Frostfire Flasks", 8, 0,
      "Heart-fuel from the Forge: blue at the edges, red at the core. Distilled from a saint's heart.", 0, 0, 6],
    FT_BROKENFROSTMIRROR: ["Broken Frost-Mirror", "Broken Frost-Mirrors", 8, 0,
      "A hand-mirror of frost-glass from Avarice's vault, cracked exactly like the hag's.", 0, 0, 6],
    FT_CHARREDNOTE: ["Charred Note", "Charred Notes", 8, 0,
      "\"V-7: recapture at any cost. The only proof that survived.\" From Avarice's vault.", 0, 0, 6],
    FT_RAZZYSCALE: ["Razzy's First Scale", "Razzy's First Scales", 8, 0,
      "A green scale small as a thumbnail, from Razzy's first shed. Stolen years ago. Home now.", 0, 0, 6],
    FT_FROZENROSE: ["Frozen Rose", "Frozen Roses", 8, 0,
      "A rose frozen in bloom in a jar of black ice. One of Shimmer's. Warm to the touch.", 0, 0, 6],
    FT_MARSHALBADGE: ["Marshal's Badge", "Marshal's Badges", 8, 0,
      "Var Rime-Breaker's Summer Marshal badge, and a Corsair cargo-list with no Council stamp.", 0, 0, 6],
    FT_VERDANTFIRECHARM: ["Verdant Fire Charm", "Verdant Fire Charms", 1, 0,
      "A charm from the Echo Vault, warm as a coal. Held, it makes a Pokémon's Fire- and Grass-type moves stronger.", 0, 0, 0],
    FT_CYCLEOFROOTS: ["Cycle of Roots", "Cycles of Roots", 1, 0,
      "A scroll of living bark, written in roots. Read once, it restores your whole party completely.", 2, 0, 0],
    FT_SAINTSECHO: ["Saint's Echo", "Saint's Echoes", 8, 0,
      "A sliver of clean frost-light from the Frost Saint's cleansed heart. It hums Shimmer's four notes.", 0, 0, 6],
    FT_MIRRORLENS: ["Mirror Lens", "Mirror Lenses", 8, 0,
      "A lens of clear mirror-glass in a ring of root, from the Echo Vault. Through it you see what's ethereal: your Pokémon's Normal and Fighting moves can touch Ghosts.", 0, 0, 6]
  )

  LOOP_ACT2_FLAGS.concat(%i[heartwall_open ring_done barracks_done amber_vault_entered glass_sigil lift_node_run
                            var_story_known ledger_found autumn_labs_seen knows_shard_origin stasis_notes_read
                            barricade_passed rootwatch_cleared rootkeep_gate_open forge_upper_reached
                            antechapel_cleared avarice_faked_death avarice_believed_dead heart_choice_made
                            veins_entered echo_vault_entered]).uniq! if defined?(LOOP_ACT2_FLAGS)
end

if defined?(ItemHandlers)
  # Hew's mechanical assistance: the compass points at the warmest thing below,
  # which is usually where the story goes next.
  ItemHandlers::UseFromBag.add(:FT_ROOTCOMPASS, proc { |item|
    goal = (FrostThaw.state[:goal] rescue nil)
    pbMessage(_INTL("The sap-bead swings, settles, and ticks. Tick. Tick. It points down, and a little to the left."))
    pbMessage(_INTL("(Where it's warm: {1})", goal)) if goal
    next 1
  }) rescue nil
  ItemHandlers::UseFromBag.add(:FT_CYCLEOFROOTS, proc { |item|
    $Trainer.heal_party
    pbMessage(_INTL("You read the Cycle of Roots aloud. The words grow as you say them, and your whole party is made whole."))
    next 3
  }) rescue nil
end

# The Verdant Fire Charm (held) and the Blessing of Verdant Fire: Fire and Grass
# moves hit harder.
if defined?(PokeBattle_Move) && PokeBattle_Move.method_defined?(:pbCalcDamageMultipliers)
  class PokeBattle_Move
    alias ft_verdant_pbCalcDamageMultipliers pbCalcDamageMultipliers unless method_defined?(:ft_verdant_pbCalcDamageMultipliers)
    def pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
      ft_verdant_pbCalcDamageMultipliers(user, target, numTargets, type, baseDmg, multipliers)
      begin
        if [:FIRE, :GRASS].include?(type) && FrostThaw.active? && FrostThaw.ft_player_side?(user)
          multipliers[:base_damage_multiplier] *= 1.2 if user.hasActiveItem?(:FT_VERDANTFIRECHARM)
          multipliers[:base_damage_multiplier] *= 1.1 if FrostThaw.blessing?(:verdant_fire)
        end
      rescue StandardError
      end
    end
  end
end

# The Mirror Lens (Echo Vault): with it in the bag, your Pokémon see what's
# ethereal, so Normal and Fighting moves touch Ghosts (as Foresight does).
if defined?(PokeBattle_Move) && PokeBattle_Move.method_defined?(:pbCalcTypeModSingle)
  class PokeBattle_Move
    alias ft_lens_pbCalcTypeModSingle pbCalcTypeModSingle unless method_defined?(:ft_lens_pbCalcTypeModSingle)
    def pbCalcTypeModSingle(moveType, defType, user, target)
      ret = ft_lens_pbCalcTypeModSingle(moveType, defType, user, target)
      begin
        if defType == :GHOST && Effectiveness.ineffective_type?(moveType, defType) &&
           FrostThaw.active? && FrostThaw.ft_player_side?(user) && FrostThaw.flag?(:mirror_lens)
          ret = Effectiveness::NORMAL_EFFECTIVE_ONE
        end
      rescue StandardError
      end
      ret
    end
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_forge_rooms_switches
  rescue StandardError => err
    FrostThaw.log("Forge rooms switches failed: #{err.message}")
  end
}

#-------------------------------------------------------------------------------
# A base-game battle bug: Quash walks every battler slot looking for the highest
# Quash count, and an empty slot (a double battle where one side has a single
# Pokémon left, like the Forge's rust-feasters) is nil, which crashed the turn.
#-------------------------------------------------------------------------------
if defined?(PokeBattle_Move_11E)
  class PokeBattle_Move_11E
    alias ft_quash_pbFailsAgainstTarget? pbFailsAgainstTarget? unless method_defined?(:ft_quash_pbFailsAgainstTarget?)
    def pbFailsAgainstTarget?(user, target)
      real = @battle.instance_variable_get(:@battlers)
      if real && real.include?(nil)
        @battle.instance_variable_set(:@battlers, real.compact)
        begin
          return ft_quash_pbFailsAgainstTarget?(user, target)
        ensure
          @battle.instance_variable_set(:@battlers, real)
        end
      end
      ft_quash_pbFailsAgainstTarget?(user, target)
    end
  end
end
