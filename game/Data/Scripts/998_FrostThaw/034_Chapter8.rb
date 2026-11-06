#===============================================================================
# Frost & Thaw - Act II, Chapter 8: the Rootsun Forge (script SC 8.01-8.09)
#
# Find the Summer Marshal and stop what's burning. Both roads end here, in the
# hag's old lair under the ruins of Dougan's Hole.
#
#   2072 The Rootward Barricade (8.01, A1/A3/A4): root and iron fused into a
#        wall; enthralled duergar and Hew's missing diggers; the passphrase.
#   2146 its inner rooms (046_ForgeRooms.rb): A2, A3, A5, A6, A7.
#   2073 The Hag's Abandoned Domain (8.02, A8): a tea table set for six, and
#        Thredra's echo in a cracked mirror.
#   2147-2149 the rest of Level 2 (046_ForgeRooms.rb): A9-A18.
#   2074 The Domain's lower level (8.03, A27, A28): the cocoon pens. RAZ-MKI,
#        MKII, V-3, V-5, V-6, and an empty one: V-7. The rootbeast pens; the
#        prison cocoons.
#   2150-2151 Level 3's upper works (046_ForgeRooms.rb): A19-A25, A29, A30.
#   2075 The Dragonforge (8.04, 8.05, A26, A31): the sap-pit bridge where
#        Autumn falls; the Twenty Stones and the chardalyn dragon; the
#        devil-priest at the black-glass stair.
#   2152 Avarice's rooms (046_ForgeRooms.rb): A32-A37. 2153: the Heartroot
#        Labyrinth's Zone VI, the Antechapel (H22, H32, H33, H37).
#   2076 The Heart Chamber (8.06-8.08, H23, H24): Var, who is Avarice; her
#        opening and her mechs; the Breaking Circle; Glimmer's better fire;
#        the Frost Saint Shard and your choice; the coat falls off, and she
#        burns (or seems to). 8.09: the launch; then the Sloughing Veins
#        (H25), the Echo Vault (H26, H36), and the way up (046_ForgeRooms.rb).
#===============================================================================
module FrostThaw
  SW_BARRICADE_OPEN = 3975   # the passphrase was spoken: the Barricade's gate is open
  SW_HAG_MIRROR     = 3976   # the tea-table mirror is dealt with (deal or broken)
  SW_AUTUMN_FELL    = 3977   # Darrus has fallen; the bridge is clear
  SW_FORGE_CLEARED  = 3978   # the forge's gauntlet is beaten: the way to the Heart Chamber
  SW_ENGINE_DEAD    = 3979   # the engine is dead (Glimmer is gone)
  SW_SELRAE_PEN     = 3980   # Selrae is in the last cocoon (selrae_ahead, not yet rescued)
  SW_CIRCLE_PHASE   = 4095   # the Breaking Circle: the engine drinks, and you can work the spires
  # The Heart Chamber's Var event: his name and hers, so both VAR: and AVARICE:
  # lines find him on screen (notes 08 E2; tools/build_ch8.rb).
  VAR_EVENT = "Var Rime-Breaker (Avarice)"

  MAPS.merge!(barricade: 2072, hag_domain: 2073, hag_pens: 2074, dragonforge: 2075, heart_chamber: 2076)
  MAP_NAMES.merge!(2072 => "The Rootward Barricade", 2073 => "The Hag's Abandoned Domain", 2074 => "The Cocoon Pens",
                   2075 => "The Dragonforge", 2076 => "The Heart Chamber")
  MAP_METADATA.merge!(
    2072 => { announce_location: true, battle_environment: :Cave },
    2073 => { announce_location: true, battle_environment: :Cave },
    2074 => { announce_location: true, battle_environment: :Cave },
    2075 => { announce_location: true, battle_environment: :Cave },
    2076 => { announce_location: true, battle_environment: :Cave }
  )
  AREAS.merge!(2072 => :forge, 2073 => :hag_domain, 2074 => :hag_domain, 2075 => :forge, 2076 => :forge)
  FORGE_ARRIVAL = [2072, 4, 14, 6]
  FORGE_REST    = [2072, 5, 14, 6]
  FORGE_CAMP    = [2150, 12, 6, 2]   # Level 3, by the Root-Throne

  ENCOUNTERS[2072] = { step_chances: { Cave: 6 },
                       Cave: [[30, :MAGCARGO, 45, 47], [25, :GRAVELER, 45, 47], [20, :TORKOAL, 45, 47],
                              [15, :SKARMORY, 46, 48], [10, :HOUNDOOM, 46, 48]] }
  ENCOUNTERS[2073] = { step_chances: { Cave: 6 },
                       Cave: [[30, :HAUNTER, 45, 47], [25, :MISDREAVUS, 45, 47], [20, :SABLEYE, 45, 47],
                              [15, :BANETTE, 46, 48], [10, :DUSCLOPS, 46, 48]] }

  TRAINER_TYPES.merge!(
    FT_DUERGAR:  ["Duergar Forgehand", :ROUGHNECK, 0, 80],
    FT_DEVIL:    ["Devil-Priest", :CHANNELER, 0, 120, :LEADER_Pryce],
    FT_AVARICE:  ["Forge-Mistress", :CHANNELER, 1, 250, :LEADER_Pryce]
  )
  TRAINERS.merge!(
    duergar_kord:  [:FT_DUERGAR, "Kord",  [[:MAGCARGO, 45], [:B208H126, 46]], "The fire's in my head. Quieter now."],
    duergar_brask: [:FT_DUERGAR, "Brask", [[:B76H59, 45], [:B205H229, 46]], "My hands... why are my hands so hot?"],
    duergar_hild:  [:FT_DUERGAR, "Hild",  [[:B95H126, 46], [:TORKOAL, 46]], "Rimebound. Rise unbroken. That's all she lets us say."],
    duergar_thane: [:FT_DUERGAR, "Thane", [[:B112H59, 47], [:B227H229, 47]], "Stoke. Stoke. Stoke. ...Is it quiet? Why is it quiet?"],
    devil_priest:  [:FT_DEVIL, "Vexmortis", [[:HOUNDOOM, 47], [:B229H94, 48], [:B126H229, 48]],
                    "She'll forge a better one of me, she said. She always says that."],
    avarice:       [:FT_AVARICE, "Avarice", [[:B229H122, 49], [:B208H126, 49], [:B82H429, 50], [:B229H150, 52]],
                    "Variables. Always variables.", [:FULLRESTORE, :FULLRESTORE, :HYPERPOTION]]
  )
  TRAINER_INTROS.merge!(
    duergar_kord:  "KORD: Back to the sap! The engine's hungry!",
    duergar_brask: "BRASK: Stoke the fire. Feed the engine. Don't look at the dragon.",
    duergar_hild:  "HILD: Halt! Speak the words or burn.",
    duergar_thane: "THANE: More fuel. More fuel. You'll do.",
    devil_priest:  "VEXMORTIS: A congregation! How long since anyone came to my sermon on purpose."
  )

  TEXT.merge!(
    duergar_kord_after:  ["(rubbing his temples) It's quieter when I lose. Isn't that a thing."],
    duergar_brask_after: ["I had a name before the Forge. I'm sure I did."],
    duergar_hild_after:  ["The words are in the ledger. Everyone knows them. Nobody says them."],
    duergar_thane_after: ["Go on, then. The engine doesn't care who feeds it."],
    devil_priest_after:  ["Go on. She's waiting. She's always waiting. That's the worst of her.",
                          "Her dragon flies at first light. She's never late."],
    barricade_illusion: ["Out of a root platform by the wall, a model of the Dale has grown: hills of bark, a lake of sap gone hard and pale, ten little towns of knotwood.",
                         "Over it an illusion flares on a loop: a mechanical dragon of frost and fire, its eyes burning hell-red.",
                         "It circles the ten towns in the same order every time. Each time it passes over one, the town's lights go out. And come back. And go out.",
                         "Good Mead first. Then Bryn Shander."],
    duergar_ledger: ["A duergar ledger, sap-stained. Tallies of fuel, tallies of hands.",
                     "At the top of every page, the same words in a cramped hand:",
                     "\"Rimebound. Rise unbroken.\""],
    glassy_digger: -> {
      flag?(:barricade_passed) ? ["DIGGER: (blinking) ...Is this the Guild? Is Hew here? I was hauling. I don't remember what."] :
                                 ["DIGGER: (hauling sap, smiling, eyes like glass) Warm. Warm. Down's where the warm is."]
    },
    tea_table: -> {
      if flag?(:sworn_to_thredra) && flag?(:engine_dead)
        next ["A tea table set for six, a skin of frost on every cup.",
              "In the cracked glass, the hag with the ember eye lifts her phantom cup to you.",
              "THREDRA: (very small) Burned. Paid in full, dearies. Mother's kitchen thanks you."]
      end
      flag?(:hag_mirror_done) ? ["A tea table set for six, a skin of frost on every cup.",
                                 "The cracked mirror over it is just a mirror now. Nearly."] :
                                ["A tea table set for six. Six cups, six saucers, six little cakes gone hard as stone.",
                                 "Over it hangs a cracked mirror."]
    },
    cocoon_plate: ["Brass plates under rows of amber cocoons: RAZ-MKI. RAZ-MKII. V-3. V-5. V-6."],
    cocoon_v7: ["One plate is empty, its cocoon split open from the inside, long ago. V-7."],
    pens_journal: ["A journal on a lectern, in a neat white hand:",
                   "\"Raz-MKIII showed resilience. Wyrm-essence holding.\"",
                   "\"The goblin survived far longer than expected. V-7 escaped with him.\"",
                   "\"Irrelevant: the method is proven.\""],
    garagai_shelf: -> {
      flag?(:garagai_axe) ? ["An empty shelf, and a ring of old frost where something heavy sat."] :
                            ["On a shelf: the head of a giant's axe, rimed with old frost."]
    },
    twenty_stones: ["Twenty standing stones ring the cavern, each carved with a mirror and a flame."],
    chardalyn_chained: -> {
      flag?(:dragon_launched) ? ["Broken chains, and a hole in the roof of the world."] :
                                ["Chained among the stones on a cradle of iron and root: a dragon of black crystal and mirror glass.",
                                 "Its eyes are dark."]
    },
    forge_stair_shut: ["A stair of black glass winds up toward the engine.", "The devil-priest stands on the bottom step, smiling."],
    engine_dead: -> {
      flag?(:engine_dead) ? ["The engine hangs dark and cold. Where Glimmer knelt, the stone is still warm."] :
                            ["The engine hangs over the silver pool, a cage of chardalyn and roots, beating slowly, like something refusing to die."]
    }
  )

  module_function

  #-----------------------------------------------------------------------------
  # SC 8.01 - The Rootward Barricade
  #-----------------------------------------------------------------------------
  def scene_barricade
    return if flag?(:barricade_entered)
    set_flag(:barricade_entered)
    add_counter(:story_beats)
    set_rest_at(FORGE_REST) rescue nil
    guard = Stage.actor(:duergar, 8, 13, 4, graphic: "BW054")   # the one who speaks, on screen
    say(["The tunnel narrows until a wall of fused root and blackened iron blocks the way.",
         "The exposed wood pulses faintly, like a heart under strain. Infernal sigils glow along the iron plates hammered into it.",
         "A single slit near the top leaks a strip of red-gold light. Something beyond is hammering. Something patient. Something building.",
         "Grey dwarves, duergar, wearing Avarice's sigils, guard it.",
         "Among them, Hew's missing diggers haul sap with blank smiles.",
         "DUERGAR: Xardorok said you'd come. The failures always return."])
    # (dialogue 08 §3.1: the answer straight after the line it answers; §4:
    # "Xardorok" said to be a name nobody here can put a face to)
    sayc([cl(:meat_meat, "Failures. Meat Meat has been called worse. By better.")])
    if with_or_is?(:reptin)
      speak(:reptin, "That's the spirit. ...Who's Xardorok?", "...Xardorok?")
    end
    sayc([cl(:alerion, "Whoever's in charge down here. It's an old grey-dwarf king's name.")])
    Stage.leave(guard, 26, 13) if guard
    say(lines_for(:barricade_illusion))
    set_flag(:flight_path_seen)
    say([with_or_is?(:alberica) ? as(:alberica, "That's the Dale. Our Dale. Outside the Wall.") : "That's the Dale. Outside the Wall."])
    barricade_stone
    state[:goal] = "Through the Barricade. Find Var, whoever he's become. The duergar have words at the gate."
    hew_compass_wakes if flag?(:hew_gift) && !flag?(:hew_compass_woke)
  end

  # Context 08 M8-1: Kelyn's sending-stone (given at the Council's summons, Ch6)
  # warms, and the chapter's question is said aloud, with its two wrong answers.
  def barricade_stone
    set_flag(:stone_barricade)
    say(["In your pack, the sending-stone warms. Kelyn's voice comes out of it, thin and far.",
         "KELYN: (from the stone) Heralds? The tree shook again. Have you found Var?"])
    c = pbMessage(_INTL("Tell Kelyn..."), [_INTL("\"Not yet.\""), _INTL("\"There's a dragon.\"")], 0)
    say([c == 1 ? "KELYN: (from the stone, a long pause) ...Then find Var. He'll know what it is." :
                  "KELYN: (from the stone) Then keep looking. If he's down there, he's been there a week.",
         "The stone goes cool."])
    if with_or_is?(:alerion)
      speak(:alerion, "Summer took the Saint's heart. Paid for the sap. Gave Selrae a key down here.",
                      "...Summer's in all of it.")
    end
    if with_or_is?(:reptin)
      speak(:reptin, "So Var's a prisoner down here, or he's the one handing out the keys.", "...Prisoner, or keeper.")
    end
    if with_or_is?(:wyn)
      speak(:wyn, "(very quietly) ...Or something else. The roots don't know his name.", "...The roots don't know him.")
    end
  end

  # The comic-to-horror turn (rootspire.md 1177): at the siege of the Barricade,
  # the dormant fragment in Hew's compass hears its maker's sigils, and wakes.
  def hew_compass_wakes
    set_flag(:hew_compass_woke)
    say(["In your pack, Hew's compass starts ticking faster. Then it chirps.",
         "COMPASS: (a tinny little voice, very pleased with itself) Hello! Hello! Warm! So warm! Father, is that you?",
         herald?(:reptin) ? "(It's talking. Of course it's talking.)" : cl(:reptin, "(staring at the pack) It's talking. Of course it's talking."),
         "COMPASS: Warm warm warm warm warm warm warm warm",
         "The ticking stops.",
         "COMPASS: (in a different voice now: level, cool, and patient) Prototype accepted. Hello, little failures.",
         "COMPASS: Variables. Always variables. Let me tell the gate you're here."].compact)
    $game_screen.start_shake(3, 6, 16) rescue nil
    say(["The brass splits along seams nobody put there. Thin legs of root unfold out of it, and it climbs out of your pack on its own."])
    won = boss_battle(named_mon(:B208H82, 44, "Root-Compass Thing"))
    say([won ? "It falls over, legs still twitching, and goes quiet. The sap-bead in its middle cracks and turns black." :
               "It skitters off toward the gate on its root-legs. You catch it with a boot before it gets there, and it cracks."])
    take_key(:FT_ROOTCOMPASS) rescue nil
    give_key(:FT_DEADCOMPASS)
    # Context 08 M8-1 boxes 12-13: the third "little failures", heard as the third.
    heard = [flag?(:mira_core_broken) || flag?(:mira_freed) ? "Mira said that." : nil,
             flag?(:met_mirror_child) ? "The boy's mirror said that." : nil].compact
    sayc([cl(:meat_meat, heard.empty? ? "(very still) Little failures. Meat Meat knows that voice. From the cold table." :
                                        "(very still) #{heard.join(' ')} Little failures."),
          cl(:alberica, "Built from parts Summer's people paid for. Lovely. Somebody check my pockets."),
          cl(:alerion, "Then she knows we're here."), cl(:wyn, "(very quietly) She always knew.")])
  end

  def barricade_gate(event_id = nil)
    return say(["The gate stands open. Heat rolls through it."], event_id) if flag?(:barricade_passed)
    say(["A gate of root and iron, with a grille at head height. Behind the grille, eyes.",
         "VOICE BEHIND THE GATE: Words."], event_id)
    # The words have to be learned first (A1-A3): the duergar ledger, or Hild's
    # lose-text. Otherwise the gate opens only from inside, by the A6 lever.
    knows = flag?(:read_ledger) || flag?(:heard_passphrase) || (trainer_beaten?(:duergar_hild) rescue false)
    opts = []
    opts << [:words, _INTL("\"Rimebound. Rise unbroken.\"")] if knows
    opts << [:ask, _INTL("\"Let us through.\"")]
    opts << [:none, _INTL("Say nothing")]
    c = pbMessage(_INTL("The voice behind the gate waits."), opts.map(&:last), opts.size - 1)
    pick = (c && c >= 0) ? opts[c][0] : :none
    if pick != :words
      say(["VOICE BEHIND THE GATE: Wrong. Go and burn somewhere else."])
      say([knows ? "(The words. The ones in the ledger.)" :
                   "(The duergar must have words they say here. Somebody will have written them down, or will say them if they lose.)"])
      return
    end
    say(["(You say it the way the duergar say it, flat and tired.)"])
    pbSEPlay("Door exit") rescue nil
    say(["The bar slides. The gate grinds open.",
         "The duergar behind it steps back, blinks, and looks at his hands as if they were somebody else's."])
    set_flag(:barricade_passed)
    ($game_switches[SW_BARRICADE_OPEN] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    sayc(["Behind you, the diggers stop hauling.",
          "One by one they sit down where they are, and look around, and start to cry.",
          flag?(:hew_confessed) ? cl(:meat_meat, "Hew's people. Hew will come for them. Hew owes them that.") : nil,
          cl(:wyn, "(already handing out a blanket) It's all right. You're all right now.")])
    state[:goal] = "Down, into the hag's old lair."
  end

  def duergar_ledger(event_id = nil)
    set_flag(:read_ledger)
    say(lines_for(:duergar_ledger), event_id)
  end

  #-----------------------------------------------------------------------------
  # SC 8.02 - Mother's kitchen
  #-----------------------------------------------------------------------------
  def hag_tea_table(event_id = nil)
    return say(lines_for(:tea_table), event_id) if flag?(:hag_mirror_done)
    say(lines_for(:tea_table), event_id)
    say(["In the glass, the table isn't empty. A hag sits at its head, spectral and stooped, sipping tea that isn't there.",
         "One of her eyes is dead and white. The other is a burning ember."])
    sayc(["THREDRA: (from the glass, very small) My, my. The children come back to mother's kitchen.",
          herald?(:alberica) ? "(You're dead. We were there.)" : (with_or_is?(:alberica) ? "ALBERICA: You're dead. We were there." : "You're dead."),
          "THREDRA: I'm remembered, dearie. Mirrors always remember.",
          "THREDRA: And she took my kitchen. My mirrors, my stones, my lovely root.",
          "THREDRA: She uses my glass to wear people like coats.",
          "THREDRA: Mother Thruuna, the duergar called me, when this was my kitchen and they were my guests. They forget. She doesn't.",
          cl(:reptin, "(under his breath) Says the woman who kept a pantry of children."),
          "THREDRA: Burn her forge, dearies, and I'll whisper you a secret."])
    mspot = stage_spot(stage_event(event_id))
    # The source's order: the price first. Swear to burn the forge, and then she whispers.
    c = pbMessage(_INTL("Thredra's mirror..."), [_INTL("Swear to burn her forge"), _INTL("Break the mirror")], 0)
    if c == 0
      say(["You swear it. The ember in her eye flares, pleased.",
           "THREDRA: There. A promise in my kitchen. Mirrors remember those too, dearies.",
           "THREDRA: Now lean close. The heart in her engine isn't hers. The body she wears isn't hers.",
           "THREDRA: Break the heart, and the coat falls off."])
      set_flag(:sworn_to_thredra)
      Stage.fx("E-06", mspot, frames: 4, oy: 40)        # it only cracks wider
      say(["The mirror cracks wider. Thredra laughs, and goes on laughing after her face has gone."])
      set_flag(:took_hag_secret)
      wheel(-1)
    else
      if with_or_is?(:meat_meat)
        speak(:meat_meat, "No more deals with mirrors.", "...No.")
      end
      Stage.fx("E-06", mspot, frames: 10, oy: 40)       # it falls in pieces
      say(["The glass breaks into a hundred pieces. None of them laugh."])
      set_flag(:broke_hag_mirror)
      wheel(1)
    end
    set_flag(:hag_mirror_done)
    ($game_switches[SW_HAG_MIRROR] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # SC 8.03 - The cocoon pens
  #-----------------------------------------------------------------------------
  def scene_cocoon_pens
    return if flag?(:pens_seen)
    set_flag(:pens_seen)
    add_counter(:story_beats)
    say(["Rows of amber cocoons in the root walls. In some, shapes that might have been goblins.",
         "Labels on brass plates: RAZ-MKI. RAZ-MKII. V-3. V-5. V-6.",
         "One plate is empty, its cocoon split open from the inside, long ago. V-7.",
         herald?(:meat_meat) ? "(Very quietly, to yourself: ...That one is Meat Meat.)" : "MEAT MEAT: (very quietly) ...That one is Meat Meat."])
    say(lines_for(:pens_journal))
    # Context 08 M8-2: the name and the face meet. Meat Meat goes to the empty
    # V-7 plate and names the neat white hand (the Act I "lady with books and
    # bones" is Avarice); then what the method was proven for (the dragon).
    if herald?(:meat_meat)
      Stage.walk_to($game_player, 21, 5, face: 8) rescue nil
      say(["You put your hand flat on the empty plate.",
           "(Neat white hand. Hers. Avarice.)"])
      speak(:meat_meat, "Meat Meat is not a method.", "...Not a method.")
      sayc([with_or_is?(:reptin) ? "REPTIN: (kneeling beside you) No. You're not." : nil,
            with_or_is?(:alberica) ? "Alberica doesn't make a joke. She just holds out her arm, and you lean into it." : nil])
    elsif with_or_is?(:meat_meat)
      mm = Stage.summon(:meat_meat)
      Stage.walk_to(mm, 21, 5, face: 8) if mm
      Stage.walk_to($game_player, 19, 5, face: 6) rescue nil   # you go with her; the camera follows
      sayc(["MEAT MEAT: (a hand flat on the empty plate) Neat white hand. That is her. Avarice.",
            "MEAT MEAT: She wrote on Meat Meat too. Under the hair. Same seven.",
            "MEAT MEAT: (after a long time) Meat Meat is not a method.",
            with_or_is?(:reptin) ? as(:reptin, "(kneeling beside her) No. You're not.") : nil,
            herald?(:alberica) ? "You don't make a joke. You just hold out your arm, and Meat Meat leans into it." :
              (with_or_is?(:alberica) ? "Alberica doesn't make a joke. She just holds out her arm, and Meat Meat leans into it." : nil)])
    end
    if with_or_is?(:alerion)
      speak(:alerion, "(reading it again) Raz-MKIII. Razzy. And \"the method is proven.\" Proven for what?",
                      "...\"The method is proven.\" For what?")
    else
      say(["(Raz-MKIII. Razzy. \"The method is proven.\" Proven for what?)"])
    end
    if with_or_is?(:meat_meat)
      dir = herald?(:alberica) ? "(into your sleeve)" : with_or_is?(:alberica) ? "(into Alberica's sleeve)" : "(very quietly)"
      speak(:meat_meat, "#{dir} For something bigger than Razzy.", "...Bigger.")
    end
    set_flag(:mm_origin_seen)
  end

  def selrae_cocoon(event_id = nil)
    return say(["An empty cocoon, cut open, the amber still soft at the edges."], event_id) if flag?(:selrae_rescued)
    return say(["An empty cocoon, split long ago. Whatever was in it got out."], event_id) if !flag?(:selrae_ahead)
    say(["In the last cocoon: the Winter Matron, half-frozen in amber. Her eyes are open.",
         "You cut her free."], event_id)
    sayc(["SELRAE: ...Thank you. Winter doesn't ask to be rescued. It seems I do.",
          "SELRAE: Go on. I'll find my own way up. I've had a lot of practice being in the wrong place.",
          cl(:alerion, "Told you she'd get caught."),
          cl(:alberica, "Nobody likes a told-you-so, pretty boy."),
          cl(:alerion, "I do.")])
    set_flag(:selrae_rescued)
    ($game_switches[SW_SELRAE_PEN] = false; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
  end

  def garagai_shelf(event_id = nil)
    say(lines_for(:garagai_shelf), event_id)
    return if flag?(:garagai_axe) || !flag?(:garagai_vow)
    say([with_or_is?(:reptin) ? as(:reptin, "Garagai's axe. I gave my word. It's going home.") : "Garagai's. Someone swore to bring it home."])
    give_key(:FT_GARAGAIAXE)
    set_flag(:garagai_axe)
  end

  #-----------------------------------------------------------------------------
  # SC 8.04 - Autumn falls
  #-----------------------------------------------------------------------------
  # Who carries Autumn's mantle at the Forge. If the Heralds exposed Darrus in
  # the Verdant Heist, he ran to the Corsairs (048_Rootspire_D_Quests.rb), and
  # Maera Vell of the Frost-Thread Clothier, Autumn's robe-maker, took his place.
  def autumn_hand
    if flag?(:heist_exposed)
      { full: "Maera Vell", tag: "MAERA", he: "she", him: "her", his: "her", He: "She", His: "Her",
        dress: "crowning robes are scorched", title: "Autumn's Maera Vell",
        intro: "Autumn's robe-maker in Darrus's place", who: "Autumn's Maera Vell" }
    else
      { full: "Darrus Fell", tag: "DARRUS", he: "he", him: "him", his: "his", He: "He", His: "His",
        dress: "velvet is scorched", title: "Autumn Warden Darrus Fell",
        intro: "the Autumn Warden from the Council", who: "The Autumn Warden" }
    end
  end

  def scene_autumn_falls
    return if flag?(:autumn_fell)
    a = autumn_hand
    # Context 08 M8-4: who he is (name and role again, two chapters on), and his case.
    say(["#{a[:full]}, #{a[:intro]}, drags a cocoon toward the forge.",
         "#{a[:His]} #{a[:dress]}. Inside the cocoon, a child's face, asleep.",
         "#{a[:tag]}: Stand aside! The engine needs one more. One more, and it never stops.",
         "#{a[:tag]}: Eternal summer! No famine years, no winters, ever.",
         "#{a[:tag]}: Do you know what Autumn's ledgers could do with that?"])
    if with_or_is?(:reptin)
      speak(:reptin, "(very pleasantly) You sold her the city, for a summer.", "...You sold her the city.")
    end
    say(["#{a[:tag]}: Autumn counts what winter will take. I've counted for thirty years. I'm done."])
    if with_or_is?(:meat_meat)
      speak(:meat_meat, "That is a child.", "...Put the child down.")
    end
    say(["#{a[:tag]}: It's fuel."])
    if herald?(:meat_meat)
      say(["You move faster than anyone has ever seen you move.", "A blade of pure thought flashes in your hand.",
           "#{a[:full].split.first} stumbles back, lets go of the cocoon, and goes over the rail.",
           "#{a[:He]} catches the edge. Below #{a[:him]}, the sap boils.",
           "#{a[:tag]}: (clinging) Help me. Goblin. Help me."])
      c = pbMessage(_INTL("#{a[:full].split.first} is hanging from the edge. The child's cocoon is rolling toward the pit."),
                    [_INTL("Take the child"), _INTL("Reach for #{a[:full].split.first}")], 0)
      if c == 1
        say(["You reach for #{a[:him]}. #{a[:His]} hand finds yours.",
             "Then the bridge shakes, and #{a[:his]} hand slides out of yours like water.",
             "#{a[:He]} falls."])
        set_flag(:mm_reached)
      else
        say(["You look at #{a[:him]} for a long moment. Then you pick up the cocoon instead.",
             "#{a[:He]} falls."])
        set_flag(:mm_turned)
      end
    else
      say(["Meat Meat moves faster than anyone has ever seen her move.", "A blade of pure thought flashes in her hand.",
           "#{a[:full].split.first} stumbles back, lets go of the cocoon, and goes over the rail.",
           "#{a[:He]} catches the edge. Below #{a[:him]}, the sap boils.",
           "#{a[:tag]}: (clinging) Help me. Goblin. Help me.",
           "Meat Meat looks at #{a[:him]} for a long moment. Then she picks up the cocoon instead.",
           "#{a[:He]} falls."])
      set_flag(:mm_turned)
    end
    sayc([cl(:alerion, "(after a beat) ...We'll talk about that later."),
          herald?(:meat_meat) ? "(Holding the child: Yes.)" : "MEAT MEAT: (holding the child) Yes.",
          cl(:wyn, "(very quietly) ...Is the little one breathing?")])
    set_flag(:autumn_fell)
    set_flag(:child_saved)
    ($game_switches[SW_AUTUMN_FELL] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    child_goes_up(a)
  end

  # Context 08 M8-5: Rootwardens the Speaker sent down take the child up, and
  # hear from Meat Meat where Autumn went (the witness for Chapter 9's charge).
  def child_goes_up(a)
    say(["The child in the cocoon is breathing."])
    pbBGMFade(0.8) rescue nil                    # only the forge's hammering
    w1 = Stage.actor(:rootwarden, 1, 14, 6, graphic: "BW029")
    w2 = Stage.actor(:rootwarden_2, 1, 15, 6, graphic: "BW029")
    Stage.approach(w1)
    Stage.walk_to(w2, ($game_player.x - 2 rescue 5), ($game_player.y + 1 rescue 15), face: 6) if w2
    say(["ROOTWARDEN: (soot to the knees) The Speaker sent us. Your stone went quiet.",
         "ROOTWARDEN: ...Is that a child?"])
    speak(:meat_meat, "(holding the cocoon tighter) Meat Meat found her. Meat Meat carries her.", "...Mine to carry.")
    say(["ROOTWARDEN: #{a[:who]} came down this way. Where is #{a[:he]}?"])
    Stage.face(w1, 2) if w1                      # he follows her look, over the rail
    if flag?(:mm_reached)
      speak(:meat_meat, "In the sap. Meat Meat reached for #{a[:him]}. Not fast enough.", "...In the sap. Not fast enough.")
    else
      speak(:meat_meat, "In the sap. #{a[:He]} let go of the child. Meat Meat let go of #{a[:him]}.", "...In the sap.")
    end
    say(["The Rootwarden looks down at the sap for a long time.",
         "ROOTWARDEN: Give her to me. She'll be up top by dawn. So will this."])
    if herald?(:meat_meat)
      pbMessage(_INTL("The child..."), [_INTL("Hand her over"), _INTL("Hold on a moment longer")], 0)
      say(["You don't let go. Then you do."])
    else
      c = pbMessage(_INTL("Meat Meat holds on to the cocoon."), [_INTL("Nod to her"), _INTL("Wait")], 0)
      say([c == 0 ? "You nod. Meat Meat doesn't let go. Then she does." : "You wait. Meat Meat doesn't let go. Then she does."])
    end
    Stage.leave_all([w1, w2].compact, 0, 14)
    set_flag(:child_carried_up)                  # (Chapter 9: Rheven's wardens heard what happened)
    Stage.theme(nil) rescue nil
  end

  #-----------------------------------------------------------------------------
  # SC 8.05 - The Dragonforge
  #-----------------------------------------------------------------------------
  def scene_dragonforge
    return if flag?(:forge_seen)
    set_flag(:forge_seen)
    dragon = stage_event("Chardalyn dragon")
    heart = dragon ? Stage.fx("E-14", [dragon.x, dragon.y], oy: 40, loop_from: 0) : nil   # the stolen heart, beating
    sayc(["Heat slams into you like a living wall.",
          "A cathedral-sized cavern: a hollow womb carved into the fused roots of the World Tree, where molten sap rivers churn like liquid gold.",
          "Mechanical arms churn. Round the floor stand the Twenty Stones, the hag's old ring.",
          "This was the hag's first lair, where the Reversal began. The Stones were her altar.",
          "The altar still beats: a holy wound in the roots, Avarice's sigils driven in like nails.",
          "Chained among them, on a cradle of iron and root: a dragon of black crystal and mirror glass.", "Its eyes are dark now, but its chains are still swinging from the last time it pulled.",
          "Above it hangs the engine, a cage of chardalyn and roots.",
          "In its heart burns a sliver of blue frost-light, wrapped in Hyphora's gold sap.", "Blue at the edges. Red at the core.",
          as(:wyn, "(stricken) That's her sap. That's Hyphora's blood."),
          cl(:alerion, flag?(:heart_given_summer) ? "That's the cold Sephek carried. Eline said Summer had his heart. There it is." :
                                                    "That's the cold Sephek carried. I'd know it anywhere. That's his heart."),
          # (Brightmane's own words if the player heard her answer, 048_F; else Ch6's, on the spine)
          cl(:glimmer, flag?(:brightmane_answered) ? "(the Rimefang shaking) ...Brightmane said I'd know the fire when I saw it. That's it." :
                                                     "(the Rimefang shaking in his hand) ...Brightmane said I'd find a better fire. That's it.")])
    Stage.stop_fx(heart)
    Stage.cleanup rescue nil
    state[:goal] = "Through the forge's keepers, to the engine."
  end

  def devil_priest(event_id = nil)
    if flag?(:forge_reached)
      return say(["Where the priest knelt, a scorch-mark in the shape of folded wings."], event_id) if flag?(:devil_fled)
      return say(lines_for(:devil_priest_after), event_id)
    end
    sayc(["A duergar priest kneels before a mirror-root altar at the foot of the stair, chanting in a guttural language.",
          "As you come close, its shadow ripples, and wings unfold from it, stretching impossibly wide.",
          "It turns: a barbed devil in priest's robes, smiling with too many teeth.",
          cl(:alberica, "Ooh. Lovely smile. Too many teeth, but lovely.")], event_id)
    return if !trainer(:devil_priest, event_id)
    set_flag(:forge_reached)
    ($game_switches[SW_FORGE_CLEARED] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    # Context 08 M8-6: the clock, on the spine (it used to live in her vault).
    say(["VEXMORTIS: Go on. She's waiting. She's always waiting. That's the worst of her.",
         "VEXMORTIS: Hurry, if you like. Her dragon flies at first light. She's never late."], event_id)
    sayc([cl(:alerion, "Then it's tonight.")])
    set_flag(:clock_first_light)
    if companions.size >= 3
      set_flag(:devil_fled)
      say(["He counts you, and counts again, and decides he's outnumbered.",
           "VEXMORTIS: I serve her willingly. Not THAT willingly."], event_id)
      say(["His wings fold round him, and he's gone in a smell of struck matches."])
      set_self_switch(event_id, "B") if event_id
      # (context 08 §4: "my patron" glossed on the spine, by the one who knows deals)
      sayc([cl(:glimmer, "(watching the smoke) A devil minding her stair. She's made a deal with something.")])
    end
    say(["Behind the altar, a stair of black glass winds up toward her rooms, and the Heart beyond them."])
    state[:goal] = "Up the black-glass stair: Avarice's rooms, and the Heart Chamber. Her dragon flies at first light."
  end

  #-----------------------------------------------------------------------------
  # SC 8.06 - Summer; 8.07 - A better fire; 8.08 - The coat falls off
  #-----------------------------------------------------------------------------
  # The Heart Chamber (H23), with the Breaking Circle (H24) round its pool:
  #   1. Var turns; the coat cracks; Avarice (her taunt, her plan, her alias).
  #   2. Her opening; then two Infernal Rootbreaker mechs join (round two).
  #   3. The Breaking Circle: while the engine drinks, six actions among twelve
  #      root-spires: scour her glyphs (Auril's sigils show through) or break
  #      both. Talk to her, or spend the sixth action, and she's ready again.
  #   4. Avarice. Then Glimmer's better fire; then the Shard, and your choice;
  #      then she burns, and the dragon flies, and the chamber comes down.
  def scene_heart_chamber
    return if flag?(:engine_dead) || flag?(:circle_phase)
    if !flag?(:heart_met)
      set_flag(:heart_met)
      heart_reveal
    else
      Stage.pan_to(10, 15) if stage_event(VAR_EVENT)
      (stage_event(VAR_EVENT).character_name = "FT_var_cracked") rescue nil
      say(["Avarice is back at the engine's controls, still wearing what's left of Var, humming.",
           "AVARICE: Again? Again. I love a repeatable experiment."])
      Stage.pan_back rescue nil
    end
    heart_lair_actions
    return avarice_fight if flag?(:circle_done)
    if !flag?(:heart_opening_won)
      $ft_var_mask = true                       # she's still in Var's cracked face for the opening
      won = begin
        pbTrainerBattle(:FT_AVARICE, "Avarice (opening)", nil, false, 0) ? true : false
      ensure
        $ft_var_mask = false
      end
      return if !won
      set_flag(:heart_opening_won)
    end
    if !flag?(:heart_mechs_won)
      $game_screen.start_shake(4, 6, 16) rescue nil
      Stage.pan_to(10, 15) if stage_event(VAR_EVENT)      # (she stays in view between the fights)
      (stage_event(VAR_EVENT).character_name = "FT_var_cracked") rescue nil   # (the map page still shows his face)
      say(["AVARICE: Round two, little failures.",
           "The silver pool heaves. Two Infernal Rootbreaker mechs climb out of it, sap sheeting off their plates."])
      setBattleRule("double")
      won = pbTrainerBattle(:FT_AVARICE, "Infernal Rootbreakers", nil, false, 0) ? true : false
      return if !won
      set_flag(:heart_mechs_won)
    end
    start_breaking_circle
  end

  # Context 08 M8-7: the reveal, with its clues. Var at the engine (his own
  # sprite, panned to); Kelyn on the sending-stone, offered a hostage and then
  # not; the face cracks; three clues from the player's own road, one box each.
  def heart_reveal
    var = stage_event(VAR_EVENT)
    Stage.pan_to(10, 15) if var                 # Var at the engine and you at the door, both in view
    say(["The enormous cavern of glowing roots opens round a pool of silver sap.",
         # (the portrait over his seat plays at the first Council, 024 kelyn on main: M8-3)
         (flag?(:wardens_sworn) || flag?(:wardens_refused)) ? "At the engine stands the man from the portrait: big, scarred, in the Marshal's gold. Var." :
                                     "A big, scarred man in the Summer Marshal's gold stands at the engine, his back to you.",
         "Over the pool hangs the engine, beating slowly, unnaturally, like something refusing to die.",
         "In your pack, the sending-stone warms.",
         "KELYN: (from the stone) Did you find him? Is Var down there?"])
    c = pbMessage(_INTL("The stone..."), [_INTL("Hold it up to him"), _INTL("Keep it covered")], 0)
    say([c == 0 ? "You hold it out across the pool. He doesn't turn round." : "You close your hand over it. He hears her anyway.",
         "VAR: (warm and rough, without turning) Kelyn. I'm here. It's worse than I told you.",
         "KELYN: (from the stone) Oh, thank the seasons. Var, come up. Come up now."])
    sayc([cl(:meat_meat, "(very still) He talks like the cold table. Slow. Counting.")])
    Stage.turn_to(var) if var
    say(["He turns. His face is Var's. His eyes are red-gold, and they don't blink.",
         "VAR: (a woman's voice, amused) Variables that refused to die.",
         "VAR: Hello again, my little failures."])
    pbBGMFade(0.8) rescue nil                   # silence for the crack
    Stage.fx("E-06", var, frames: 10, oy: 32) if var
    var.character_name = "FT_var_cracked" if var rescue nil
    say(["The face cracks like a mirror.",
         "Behind the cracks: white hair like frostfire, sigils burned into her arms. Avarice.",
         "AVARICE: Thirty years I've worn this man. Thirty years of summer."])
    Stage.theme(nil) rescue nil                 # the chamber's music comes back under her
    set_flag(:summer_unmasked)
    # The look-back (never more than three): clues the player walked past.
    recall = []
    recall << "(Eline, at the Shrine: \"Summer has the heart. Summer keeps promises.\")" if flag?(:heart_given_summer)
    recall << "(Selrae, in the Sap Wells: \"The Root-Key. Summer gave Winter a copy.\" Her own key.)" if flag?(:root_key)
    recall << "(The compass Summer's people paid for: \"Hello, little failures.\")" if flag?(:hew_compass_woke) && !flag?(:var_story_known)
    recall << "(Var at the Split Dock, glaive up: \"Who in the Nine Hells are you?\" No answer, ever.)" if flag?(:var_story_known)
    say(recall.first(3)) if !recall.empty?
    say(["KELYN: (from the stone, very small) ...Var?",
         "AVARICE: (to the stone) Gone thirty years, Speaker. Do keep up.",
         "The stone goes cold in your hand."])
    say(["AVARICE: The duergar call me Xardorok. Names are coats too. So is summer.",
         "AVARICE: A summer without end is a god's worth of power. When my dragon flies, it's mine.",
         "AVARICE: Ten-Towns melts. Every soul in the Dale is harvested warm. I take Auril's seat."])
    # (dialogue 08 §3b: an exchange, not a speech; she answers with sums)
    if with_or_is?(:reptin)
      speak(:reptin, "(politely) And the Dale? What does your summer cost them?", "...And the Dale?")
      say(["AVARICE: Auril takes one a month and calls it mercy. I take them all at once. Do the sums."])
    end
    if flag?(:avarice_shard_lodged)
      say(["AVARICE: (to you, almost fond) I watched you come down through my garden.",
           "AVARICE: You've been carrying my eye since the Shattered Bed."])
    end
    if with_or_is?(:meat_meat)
      speak(:meat_meat, "You took Razzy's voice.", "...You.")
    end
    sayc(["AVARICE: I took a great deal more than that, V-7. Come here and I'll show you.",
          herald?(:meat_meat) ? cl(:reptin, "(stepping in front of you) She's not going anywhere near you.") :
                                cl(:reptin, "(stepping in front of Meat Meat) She's not going anywhere near you.")])
    if flag?(:took_hag_secret)
      say(["(The hag was right: under the gold, a seam of frost-light where the coat is stitched on.)"])
    end
    Stage.pan_back rescue nil
  end

  # Lair actions: molten sap bursts and frost-blasts every round, and the
  # towers' bolts if nobody cleared them.
  def heart_lair_actions
    lead = $Trainer.first_able_pokemon rescue nil
    lines = ["The pool spits molten sap. Frost blasts out of the engine's vents."]
    if lead
      lead.hp = [lead.hp - [lead.totalhp / 10, 1].max, 1].max
      lines << "#{lead.name} is caught between them."
    end
    if !flag?(:vantage_cleared)
      lines << "And from the vantage towers above the forge, red-hot bolts come down through the roots!"
      if lead
        lead.hp = [lead.hp - [lead.totalhp / 10, 1].max, 1].max
        lines << "#{lead.name} takes a bolt."
      end
    end
    say(lines)
  end

  # H24: the Breaking Circle. Six actions, twelve spires.
  def start_breaking_circle
    set_flag(:circle_phase)
    state[:circle_actions] ||= 0
    Stage.pan_to(10, 15) if stage_event(VAR_EVENT)
    say(["Avarice steps back to the engine and lays both hands on it. It drinks from her, or she from it.",
         "AVARICE: (eyes half closed) The engine needs a minute to drink. So do I. Fiddle with my circle, if you like.",
         "AVARICE: Every second you spend, my dragon wakes a little more.",
         "Twelve root-spires ring the pool. Auril's frost-sigils underneath. Avarice's infernal glyphs scarred on top."])
    if flag?(:captain_hints)
      say(["(The tortured captain: scratch hers off, and she drinks less.)"])
    end
    sayc([cl(:alerion, "Scour her glyphs and the frost shows through. Break both and nothing does."),
          cl(:alberica, "And if Auril's sigils show through, darling, Auril gets a word in."),
          "(Before the engine's next beat, you have time to work on six spires. Speak to Avarice when you're ready.)"])
    Stage.pan_back rescue nil
    ($game_switches[SW_CIRCLE_PHASE] = true; $game_map.need_refresh = true if $game_map) if $game_switches
  end

  def breaking_spire(n, event_id = nil)
    done = (state[:circle_spires] ||= {})
    if flag?(:engine_dead)
      return say([done[n] == :restored ? "A root-spire, its frost-sigil showing clean through the scratched-out fire." :
                  done[n] == :broken ? "A root-spire, both its runes broken. Silent." : "A root-spire, its runes cold and quiet now."], event_id)
    end
    if !flag?(:circle_phase)
      return say(["A root-spire carved with overwritten runes: Auril's frost-sigils underneath, Avarice's infernal glyphs scarred on top.",
                  "Whispers come off it. Not loud. Not yet."], event_id)
    end
    return say(["You've already worked this spire."], event_id) if done[n]
    left = 6 - (state[:circle_actions] || 0)
    say(["Spire #{n}. Under Avarice's glyph, a frost-sigil glitters, half buried. (#{left} more before the engine's beat.)"], event_id)
    c = pbMessage(_INTL("The spire..."), [_INTL("Scour off her glyph"), _INTL("Break both runes"), _INTL("Leave it")], 2)
    return if c.nil? || c == 2
    if c == 0
      done[n] = :restored
      say(["You scrape the infernal glyph off with whatever's to hand. The frost-sigil underneath lights, cold and clean.",
           "The engine shudders. Avarice frowns without opening her eyes."])
    else
      done[n] = :broken
      say(["You break the spire's runes, both of them. The whispers off it stop dead."])
      lead = $Trainer.first_able_pokemon rescue nil
      if lead
        lead.hp = [lead.hp - [lead.totalhp / 12, 1].max, 1].max
        say(["The backlash burns #{lead.name}."])
      end
    end
    state[:circle_actions] = (state[:circle_actions] || 0) + 1
    # A26: behind her, the dragon strains harder each round (a map away, but you hear it).
    say([["Far below the floor, chains groan. The dragon pulls once, testing them.",
          "The chains groan again, longer. Something heavy shifts on its cradle.",
          "A link snaps somewhere below with a crack like river ice. The engine beats faster to answer it.",
          "The whole chamber shudders as the dragon heaves. Dust and frost rain off the roots.",
          "You can hear its breath now, through the stone: frost and fire, in and out, like a forge's bellows.",
          "The chains scream. Avarice smiles without opening her eyes."][[state[:circle_actions] - 1, 5].min]])
    restored = done.values.count(:restored)
    if restored >= 4 && !flag?(:auril_heard_heart)
      set_flag(:auril_heard_heart)
      say(["From under the silver pool, from very far away, a voice like a winter morning, almost clear:",
           "AURIL: Little thief. Little moth. You burn my saint for a candle, and call it summer.",
           "AVARICE: (eyes snapping open) Be QUIET."])
    end
    return avarice_phase_two(nil, true) if state[:circle_actions] >= 6
  end

  # Avarice, rested. Called from her event (talk to her) or the sixth spire.
  def avarice_phase_two(event_id = nil, forced = false)
    return if flag?(:engine_dead)
    done = state[:circle_spires] || {}
    restored = done.values.count(:restored)
    broken = done.values.count(:broken)
    set_flag(:circle_phase, false)
    set_flag(:circle_done)
    ($game_switches[SW_CIRCLE_PHASE] = false; $game_map.need_refresh = true if $game_map) if $game_switches
    state[:circle_restored] = restored
    state[:circle_broken] = broken
    set_flag(:circle_worked) if restored + broken > 0
    say([forced ? "The engine beats, once, like a door slamming. Avarice opens her eyes." : "AVARICE: (opening her eyes) Done? Good.",
         "AVARICE: Let's see what you've cost me."], event_id)
    if restored > 0
      say(["She draws on the engine, and it gives her less than it should. #{restored == 1 ? 'One spire' : "#{restored} spires"} of frost won't feed her."])
    end
    if broken == 0
      say(["The whispers off the spires press in on all of you, Auril's and Avarice's both, deafening."])
      if (flag?(:gallery_boon) && !flag?(:gallery_boon_used)) || (flag?(:grotto_boon) && !flag?(:grotto_boon_used))
        set_flag(:gallery_boon_used) if flag?(:gallery_boon)
        set_flag(:grotto_boon_used) if !flag?(:gallery_boon) && flag?(:grotto_boon)
        say(["(But you've been blessed against fear down here, and the whispers find nothing to hold.)"])
      else
        $Trainer.party.each { |pk| pk.hp = [pk.hp - [pk.totalhp / 12, 1].max, 1].max if pk.hp > 0 } rescue nil
      end
    else
      say(["Where you broke the spires, the whispers have stopped. It's quieter. You can think."])
    end
    avarice_fight
  end

  # The engine overheats as you fight. If the engine vents (you lose), it resets once and you go again.
  def avarice_fight
    type, name = TRAINERS[:avarice]
    tries = flag?(:engine_vented) ? 1 : 2
    won = false
    tries.times do |i|
      if i == 1
        set_flag(:engine_vented)
        say(["The engine screams and vents. A wave of heat throws everyone to the floor.",
             "When you can see again, Avarice is on her feet, laughing, whole.",
             "AVARICE: Again? Again. I love a repeatable experiment."])
        pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
      end
      $ft_avarice_weak = flag?(:took_hag_secret)
      $ft_avarice_spires = (state[:circle_restored] || 0)
      won = pbTrainerBattle(type, name, nil, false, 0, i == 0) ? true : false
      $ft_avarice_weak = false
      $ft_avarice_spires = 0
      break if won
    end
    return if !won
    scene_better_fire
  end

  def scene_better_fire
    say(["Avarice staggers, laughing. Behind her, the engine screams.",
         "Blue frost-light and red fire twist together.", "It's going to burst, and take the tree's heart with it.",
         "AVARICE: Kill me and it blows. Leave me and it runs forever. Your move.",
         # (dialogue 08 §3b: he answers her; 6.08's words, and the echo turns)
         "GLIMMER: (stepping past her) Neither.",
         "GLIMMER: This blade's been killing me slowly since Saltmarsh.",
         flag?(:brightmane_answered) ? "GLIMMER: \"You'll know it when you see it,\" Brightmane said." : "GLIMMER: Brightmane said I'd find a better fire.",
         "He lifts the Rimefang.",
         "GLIMMER: She never said it'd be me."])
    c = pbMessage(_INTL("Glimmer..."), [_INTL("Reach for him"), _INTL("Let him go")], 0)
    say([c == 0 ? "You reach for him. He's already past you." : "You let him go. It's the hardest thing you've done down here."])
    if with_or_is?(:alberica)
      speak(:alberica, "Glimmer. Sweetheart. Don't you dare.", "...Glimmer.")
    end
    say(["AVARICE: (interested, not moving) Go on. I want to see the sums."])
    sayc(["GLIMMER: Shimmer found the third way. I'm only following her.",
          "He drives the Rimefang into the heart of the engine.",
          "The Lumen Shard in his chest blazes like a sunrise."])
    pbSEPlay("Saint7") rescue nil
    $game_screen.start_flash(Color.new(255, 230, 160, 255), 30) rescue nil
    say(["The dagger melts. Re-forms. Gold now, not blue.",
         "Far above, at the Shrine of the Twinned Dragons, Frostina lifts her head and goes quiet.",
         "The engine goes dark.",
         "Glimmer is kneeling where it was. Light is coming out of him, through his fur, through his coat.",
         "He's smiling.",
         "GLIMMER: The cold's gone. Years of it. ...Tell Frostina it was a better fire. She'll know what I mean.",
         "The light goes up, through the roots, through the tree, toward a plain of stars.",
         "The unicorn's horn goes with it.",
         "Where he was, a golden dagger lies on the stone, warm."])
    state[:companions] = (state[:companions] || []) - [:glimmer]
    set_flag(:glimmer_gone)
    set_flag(:shade_curse_broken)
    set_flag(:engine_dead)
    set_flag(:engine_dead_heart) if flag?(:took_hag_secret)
    ($game_switches[SW_ENGINE_DEAD] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    if herald?(:meat_meat)
      say(["You pick up the golden dagger and hold it against your chest for a long time."])
      Stage.balloon($game_player, "B-07", frames: 60)
      speak(:meat_meat, "Meat Meat not crying. That is sap.", "...")
    elsif with_or_is?(:meat_meat)
      mm = Stage.herald(:meat_meat, 1, 0, 2)
      Stage.balloon(mm, "B-07", frames: 60) if mm
      say(["Meat Meat picks up the golden dagger and holds it against her chest for a long time.",
           "MEAT MEAT: Meat Meat not crying. That is sap."])
    end
    sayc([cl(:alerion, "(very quietly) He always hummed it wrong. On purpose, I think.")])
    Stage.cleanup rescue nil
    give_key(:FT_DAWNFANG)
    pbMessage(_INTL("Glimmer is gone.")) rescue nil
    pbFadeOutIn {} rescue nil                    # (a breath before the Shard rises: story review 08 §8)
    scene_heart_choice
    scene_coat_falls
  end

  # H23's moral multi-ending: the engine is dead, and in the silver pool the Frost
  # Saint Shard floats free: Sephek's heart, with Auril poured into it.
  #   Purify: burn Auril out of it with Hyphora's sap and the dagger's gold;
  #           only a man's heart is left (:shard_purified).
  #   Preserve: leave it whole; it re-forms as an echo, "The goddess still waits
  #           in the ice" (:shard_preserved).
  #   Destroy: Dawnfang through it; no blessing, and Sephek can never come back
  #           whole from it (:shard_destroyed). Sanctify (Purify) earns the
  #           Blessing of Verdant Fire, as GQ2 (rootspire.md 8489) has it.
  def scene_heart_choice
    return if flag?(:heart_choice_made)
    say(["In the silver pool beneath the dead engine, something floats free, gathering ice and auroral light: the Frost Saint Shard.",
         "Sephek's heart, veined with frost-light. It whispers prayers in a voice that isn't his."])
    lines = []
    lines << "(The lab notes: a goddess poured into a drowned man's heart. It went too right.)" if flag?(:knows_shard_origin)
    lines << "(The ghost in the Antechapel: cleanse me, leave me whole, or break me. None of them clean.)" if flag?(:shard_echo_heard)
    lines << "(The whispering attendant's price, still owing: #{state[:attendant_promise] == :free ? 'free the heart' : 'burn the forge'}.)" if state[:attendant_promise]
    say(lines.first(2)) if !lines.empty?          # (notes 08 F13: no more than two memories here)
    shard_battle if !flag?(:shard_fought)
    # Context 08 M8-8: what each choice does, from someone who'd pick it.
    sayc([cl(:wyn, "(kneeling at the pool's edge) It's... it's frightened. Both of them in there are.")])
    if with_or_is?(:wyn)
      speak(:wyn, "Hyphora's sap could burn her out of it. Only his heart would be left.", "...Only his heart would be left.")
    else
      say(["(Hyphora's gold sap could burn Auril out of it. Only Sephek's heart would be left.)"])
    end
    if with_or_is?(:alerion)
      speak(:alerion, "Or leave it whole. Then it's still hers, and someone will come for it.", "...Or leave it whole. Someone will come.")
    else
      say(["(Or leave it whole: still hers, and someone will come for it.)"])
    end
    if with_or_is?(:meat_meat)
      speak(:meat_meat, "Or break it. She loses a piece. And he never comes back. Not ever.", "...Or break it. He never comes back.")
    else
      say(["(Or break it: Auril loses a piece, and Sephek never comes back.)"])
    end
    sayc([cl(:meat_meat, "(quietly) Meat Meat wants to stab it. ...Meat Meat will listen. For him."),
          cl(:alberica, "Darling, whatever we do, we do it together.")])
    c = pbMessage(_INTL("The Frost Saint Shard..."), [_INTL("Sanctify it"), _INTL("Leave it whole"), _INTL("Destroy it")], 0)
    case c
    when 0
      set_flag(:shard_purified)
      say(["You lift it out of the pool. It's so cold your hands go white.",
           "Inside it, under the goddess's frost-light, something else is listening: an echo of Sephek, the drowned man, curled small."])
      # GQ2 (rootspire.md 8489): tend it (Medicine), then talk the echo into
      # accepting Verdant Fire (Persuasion). Both, and the blessing is yours.
      tend = pbMessage(_INTL("The heart is cracked with frost. How do you hold it?"),
                       [_INTL("Warm it slowly, against your chest"), _INTL("Plunge it into the hot sap"), _INTL("Chip the frost off")], 0)
      persuade = pbMessage(_INTL("The echo of Sephek flinches from the gold. What do you tell it?"),
                           [_INTL("\"She burned you to keep you. This fire is only to warm you.\""),
                            _INTL("\"Take it, or we break you.\""), _INTL("\"Auril is gone. Let go.\"")], 0)
      say([with_or_is?(:wyn) ? "Wyn pours Hyphora's gold sap over it, and you lay the warm golden dagger against it." :
                               "You pour gold sap from the engine's cage over it, and lay the warm golden dagger against it."])
      if tend == 0 && persuade == 0
        say(["The echo uncurls. It lets the green fire in.",
             "Green fire and gold. The frost-light screams, and thins, and goes out of it like breath out of a lung.",
             "What's left beats once, slowly. Only a man's heart. Cold. Clean.",
             "The green fire doesn't go out. It runs up the dagger, into your arms, into your Pokémon.",
             "A sliver of the light breaks off, and doesn't go out either: it hums four notes. Shimmer's notes."])
        grant_blessing(:verdant_fire, "Blessing of Verdant Fire", "Your Pokémon's Fire- and Grass-type moves are a little stronger.")
        give_key(:FT_SAINTSECHO)
        set_flag(:shard_sanctified)
        wheel(1)
      else
        say(["The echo shies from the fire and the frost-light floods back into the space it left.",
             "The Shard wrenches out of your hands. Something rises off it: a wraith of rime with a drowned man's face. The Frost Saint's Echo."])
        boss_battle(named_mon(:B92H215, 50, "Frost Saint Echo"))
        say(["The Echo comes apart in sleet. What's left in your hands beats once, slowly. Only a man's heart. Cold. Clean.",
             "No blessing comes of it. But the corruption's out of it."])
      end
    when 1
      set_flag(:shard_preserved)
      say(["You leave it in the pool. The ice gathers round it again, patient as frost on a window.",
           "It re-forms, piece by piece, until it's whole, and its whisper is suddenly very clear:",
           "\"The goddess still waits in the ice.\""])
      sayc([cl(:alerion, "Someone will come for it."), cl(:reptin, "Then we'll know where they'll be going.")])
    else
      set_flag(:shard_destroyed)
      say(["You drive Dawnfang through it.", "The Shard bursts like a frozen lake in spring, and the light that comes out of it is cold and white, and goes out.",
           "Most of the shards melt. A few skitter away into the roots, where the light can't follow.",
           "(Whatever comes back from this, it won't come back whole.)"])
    end
    set_flag(:heart_choice_made)
    add_counter(:story_beats)
    if state[:attendant_promise] == :free && flag?(:shard_destroyed)
      set_flag(:attendant_promise_broken)
      say(["(Somewhere in the roots, many small voices go quiet. You promised to free the heart.)"])
    end
  end

  # H23's boss (rootspire.md: "a fragment of Auril, part ritual object, part
  # angel-of-winter"): with the engine dead, the Shard defends itself. Every
  # spire you restored in the Breaking Circle let Auril speak through it less
  # angrily (it starts weaker); every one you broke left it nothing to hold.
  def shard_battle
    set_flag(:shard_fought)
    say(["The Shard rises out of the pool. Ice gathers on it, plate by plate, into a shape: tall, winged, faceless, a spear of rime in its hand.",
         "The air round it goes so cold your breath falls as snow.",
         "SHARD: (in a voice like a frozen lake cracking) You killed the fire that fed me. Now feed me yourselves."])
    restored = state[:circle_restored] || 0
    broken = state[:circle_broken] || 0
    shard = named_mon(:B448H429, 52, "Frost Saint Shard")
    cut = [0.06 * restored + 0.04 * broken, 0.5].min
    if cut > 0
      shard.hp = [(shard.totalhp * (1.0 - cut)).floor, 1].max
      say([restored > 0 ? "(Where you scoured the spires, Auril's frost-sigils hum. The Shard flinches from them.)" :
                          "(The broken spires are silent. The Shard has less to draw on.)"])
    end
    if !flag?(:gallery_boon_used) && !flag?(:grotto_boon_used) && (flag?(:gallery_boon) || flag?(:grotto_boon))
      say(["(Auril's Echo presses on your mind, but the blessing you carry from the Labyrinth holds it off.)"])
    else
      $Trainer.party.each { |pk| pk.hp = [pk.hp - [pk.totalhp / 16, 1].max, 1].max if pk.hp > 0 } rescue nil
      say(["(Frozen Sanctity: the chill bites your whole team before the fight even starts.)"])
    end
    setBattleRule("canLose") rescue nil
    if boss_battle(shard)
      set_flag(:shard_beaten)
      say(["The ice-shape shatters. The Shard falls back into the pool, small again, and the whispering stops for a breath."])
    else
      set_flag(:shard_overcame)
      say(["The Shard's spear drives you back to the edge of the pool, and then, spent, the ice-shape slumps and falls apart on its own.",
           "It sinks back into the silver, still whispering. It has nothing left to fight with. Neither do you."])
    end
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
  end

  # Avarice fakes her death (the owner's canon): Hell's Veil takes her, and what's
  # left in the ring of melted glass is a body with white hair. The party believes
  # it. A careful player can catch the lie: Vessel IX (the Stasis Gallery's last
  # page), bare arms, and a mirror shard that fogs once, as if breathed on.
  def scene_coat_falls
    var = stage_event(VAR_EVENT)
    av = var ? Stage.actor(:avarice, var.x, var.y, 2, graphic: "FT_var_cracked") : nil   # (notes 08 E2: she's seen to the end)
    sayc(["With the engine dead, Var's body cracks all over, like ice on a lake.",
          "Avarice looks down at her hands.",
          "AVARICE: (almost admiring) Oh. That was clever.",
          "She reaches for a shard of the hag's old mirror, and the shard is cracked through. It won't take her.",
          "A pillar of red-black flame roars up round her: Hell's Veil, eating the air.",
          "From inside the fire, her voice, not laughing now:",
          # (notes 08 E19: no promise to return, or nobody would believe "Dead.")
          "AVARICE: The White Womb. I was so close to th-",
          "The pillar collapses inward with a sound like a door slamming. Then nothing."])
    Stage.hide(av) if av
    Stage.fx("E-06", stage_spot(var, 0, -2), frames: 10, oy: 32)   # the shard shatters in the heat
    sayc(["When the smoke clears, there's a body in a ring of melted mirror-glass: white hair, burned black at the ends, face down.",
          "Beside it, Var Rime-Breaker's borrowed body falls, empty, and turns to glass, and breaks.",
          with_or_is?(:alerion) ? as(:alerion, "(crouching, one hand over her, not touching) ...Dead. Nothing in her. Nothing at all.") : "She doesn't move.",
          cl(:alberica, "(very plainly) She doesn't get to come back from that. Not even her."),
          cl(:meat_meat, "(after a long time) ...Good.")])
    if flag?(:decoy_clue)
      c = pbMessage(_INTL("The body in the glass..."), [_INTL("Look more closely"), _INTL("Leave it")], 1)
      if c == 0
        set_flag(:avarice_doubt)
        say(["You look at the arms. They're bare.", "Avarice's arms were covered in burned sigils. These have none.",
             "(The note in the labyrinth: \"Vessel IX: viable. Keep it warm.\" A spare body.)",
             "You don't say anything. Nobody else noticed. You're not sure you want them to."])
      end
    end
    white_womb_beat
    # Context 08 M8-9: Kelyn heard it all; the city didn't.
    say(["The sending-stone warms in your hand.",
         "KELYN: (from the stone, hoarse) I heard her. All of it. ...The leaves are turning up here.",
         "KELYN: (from the stone) Come up. Before the city decides what it saw."])
    set_flag(:kelyn_heard_reveal)
    say(["On the floor, a last splinter of the hag's mirror fogs once, as if somebody very far away had breathed on it."])
    set_flag(:avarice_faked_death)
    set_flag(:avarice_believed_dead)
    set_flag(:summer_dead)
    add_counter(:story_beats)
    scene_launch
  end

  # Context 08 §6: the White Womb, said by her as she burned, is a place
  # Alberica's family has a word for (her bargain: the Vault stays shut).
  # §8b: with the ice mask's name, Alerion joins the three names.
  def white_womb_beat
    if herald?(:alberica)
      say(["(The White Womb. Gran's word for it was \"the Vault\". The one we keep shut.)"])
    elsif with_or_is?(:alberica)
      say([as(:alberica, "(a hand on her rune) The White Womb. Gran had a word for that place.")])
      if with_or_is?(:alerion)
        speak(:alerion, "What word?", "...What word?")
        say([as(:alberica, "...Later, pretty boy.")])
      end
    end
    if flag?(:ithryn_athis_clue) && with_or_is?(:alerion)
      say([as(:alerion, "The White Womb. The glass mask called it Ithryn. The sigils call it a vault.")])
    end
  end

  #-----------------------------------------------------------------------------
  # SC 8.09 - Launch
  #-----------------------------------------------------------------------------
  def scene_launch
    pbSEPlay("Earth3") rescue nil
    $game_screen.start_shake(6, 8, 40) rescue nil
    sayc(["Below, among the Twenty Stones, the heart-engine's last pulse runs down into the dragon's chains.",
          "The molten sap rivers surge. Chains snap like thunder. A roar comes up the roots and shakes the World Tree itself.",
          "The dragon tears free. Infernal runes blaze. Frost pours from its jaws. Wings of mirror-glass unfurl.",
          "In its chest beats another heart, older than Sephek's, and never its own.",
          "It blasts through the roof and the roots, and rises into the night: toward Ten-Towns.",
          # (context 08 M8-6: the cost of winning is the player's own doing)
          flag?(:clock_first_light) ? cl(:alerion, "First light, she said. We woke it early.") : nil])
    say([herald?(:meat_meat) ? "(You scream it before you know you're going to: RAZZY!) And far above, Razzilith panics: a picture in your head of every scale on end." :
                               "MEAT MEAT: RAZZY! (Far above, Razzilith panics: a picture in all your heads of every scale on end, and then pure rage.)"])
    lines = []
    lines << cl(:alerion, "(already running) That's old frostcraft. Older than her. ...Frostina.")
    lines << (herald?(:alberica) ? "(Every memory-thread you have is screaming at once.)" : cl(:alberica, "(a hand to her rune, white-faced) The memory-threads are screaming. All of them."))
    lines << (herald?(:reptin) ? "(The seasons spike in your chest like a fever breaking the wrong way.)" : cl(:reptin, "(staggering) The seasons just spiked. Like a fever breaking the wrong way."))
    lines << (herald?(:meat_meat) ? "In your hands, the golden dagger hums, and won't stop." :
              with_or_is?(:meat_meat) ? "In Meat Meat's hands, the golden dagger hums, and won't stop." :
                                        "In your pack, the golden dagger hums, and won't stop.")
    lines << "Far above, two dragons are already diving."
    sayc(lines)
    # P1: Meat Meat's own rage (the source gives it to her, not only to Razzy).
    if with_or_is?(:meat_meat)
      speak(:meat_meat, "(through her teeth) She put RAZZY'S work in that. Razzy's scales. Razzy's cold table. Meat Meat is going to take it back apart.",
            "(through her teeth) ...Meat Meat is going to take it apart.")
    end
    set_flag(:dragon_launched)
    add_counter(:story_beats)
    $game_screen.start_shake(8, 9, 50) rescue nil
    say(["The Heart Chamber starts to come apart. Roots slough off the walls. Part of the cavern folds into a tunnel of cooling sap.",
         cl(:reptin, "That's our way out. GO!")].compact)
    state[:goal] = "Out through the Sloughing Veins, before the Heart Chamber comes down."
    transfer(*VEINS_ARRIVAL)
  end

  # Level 3's rest: one of the woken diggers followed you down (review Ch8 E10).
  def forge_camp(event_id = nil)
    if !flag?(:forge_camp_met)
      set_flag(:forge_camp_met)
      say(["DIGGER: Followed you down. Somebody has to keep the flask warm.",
           "DIGGER: Get knocked flat down there, you wake up here. Not at the gate."], event_id)
    end
    say(["The digger pours warm sap for you and your Pokémon.", "Everyone feels better."], event_id)
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_rest_at(FORGE_CAMP) rescue nil
  end

  # The Rootsun Forge mends nothing, but the Barricade's diggers can rest you.
  # The first rest here, the party talks (once before the engine, once after).
  def forge_rest(event_id = nil)
    say(["A digger who's woken up shares a flask of warm sap with you and your Pokémon.", "Everyone feels better."], event_id)
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_rest_at(FORGE_REST) rescue nil
    if !flag?(:glimmer_gone) && !flag?(:banter_forge_rest)
      set_flag(:banter_forge_rest)
      sayc([cl(:meat_meat, "This sap tastes like coffee that gave up."),
            cl(:wyn, "Um. I have the mushroom kind. In my bag. If anyone..."),
            cl(:meat_meat, "Mushroom friend is a hero."),
            cl(:glimmer, "(holding out a cup) Seven years without a decent cup. Fill it, please."),
            cl(:alberica, "Seven years? Kitten, I'll pour it myself."),
            cl(:alerion, "Don't.")])
    elsif flag?(:glimmer_gone) && !flag?(:banter_forge_rest_after)
      set_flag(:banter_forge_rest_after)
      sayc(["Nobody says much. The diggers' flask goes round twice.",
            cl(:alberica, "(quietly) He'd have made a joke about this sap. A terrible one."),
            cl(:alerion, "He did."),
            cl(:wyn, "...I poured him a cup. I don't know why."),
            cl(:meat_meat, "Leave it. Meat Meat will guard it.")])
    end
  end

  def apply_chapter8_switches
    return if !active? || !$game_switches
    sync_switch(SW_BARRICADE_OPEN, flag?(:barricade_passed))
    sync_switch(SW_HAG_MIRROR, flag?(:hag_mirror_done))
    sync_switch(SW_AUTUMN_FELL, flag?(:autumn_fell))
    sync_switch(SW_FORGE_CLEARED, flag?(:forge_reached))
    sync_switch(SW_ENGINE_DEAD, flag?(:engine_dead))
    $game_switches[SW_SELRAE_PEN] = flag?(:selrae_ahead) && !flag?(:selrae_rescued)
  end
end

# The hag's secret (SC 8.02): with it, Avarice's ace (the Pokémon stitched to the
# engine's heart) comes into the fight already badly hurt.
if Events.respond_to?(:onTrainerPartyLoad)
Events.onTrainerPartyLoad += proc { |_sender, e|   # (guarded below for the test harness)
  begin
    trainer = e.is_a?(Array) ? e[0] : e
    if trainer && trainer.name == "Avarice" && trainer.party && !trainer.party.empty?
      ace = trainer.party.last
      ace.hp = [(ace.totalhp * 0.55).floor, 1].max if $ft_avarice_weak
      # every frost-sigil scoured clean on the Breaking Circle feeds her less
      n = ($ft_avarice_spires || 0).to_i
      if n > 0
        frac = [1.0 - 0.08 * n, 0.4].max
        trainer.party.each { |pk| pk.hp = [(pk.hp * frac).floor, 1].max }
      end
    end
  rescue StandardError => err
    FrostThaw.log("Avarice's weak point failed: #{err.message}")
  end
}
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter8_switches
  rescue StandardError => err
    FrostThaw.log("Chapter 8 switches failed: #{err.message}")
  end
}
