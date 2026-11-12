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
  SW_DIGGERS_WAKE   = 4091   # the gate opened by the traitor's lever: Hew's diggers wake when you're back
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
    duergar_thane: [:FT_DUERGAR, "Gorm",  [[:B112H59, 47], [:B227H229, 47]], "Stoke. Stoke. Stoke. ...Is it quiet? Why is it quiet?"],
    devil_priest:  [:FT_DEVIL, "Vexmortis", [[:HOUNDOOM, 47], [:B229H94, 48], [:B126H229, 48]],
                    "She'll forge a better one of me, she said. She always says that."],
    avarice:       [:FT_AVARICE, "Avarice", [[:B229H122, 49], [:B208H126, 49], [:B82H429, 50], [:B229H150, 52]],
                    "Variables. Always variables.", [:FULLRESTORE, :FULLRESTORE, :HYPERPOTION]]
  )
  # Avarice's three fights are all hers on the battle screen ("Forge-Mistress
  # Avarice"), not "Avarice (opening)" or "Forge-Mistress Infernal Rootbreakers"
  # (notes 08 E26): the opening and the mechs are her other parties.
  AVARICE_OPENING = 1
  AVARICE_MECHS   = 2
  AVARICE_PARTIES = { AVARICE_OPENING => :avarice_opening, AVARICE_MECHS => :rootbreaker_mechs }

  def self.register_avarice_parties
    AVARICE_PARTIES.each do |version, key|
      _type, _name, party, lose_text = TRAINERS[key]
      next if !party
      hash = { id: [:FT_AVARICE, "Avarice", version], id_number: 9890 + version, trainer_type: :FT_AVARICE,
               name: "Avarice", version: version, items: [], lose_text: lose_text,
               pokemon: party.map { |sp, lv| { species: sp, level: lv } } }
      GameData::Trainer::DATA[[:FT_AVARICE, "Avarice", version]] = GameData::Trainer.new(hash)
    end
  rescue StandardError => e
    FrostThaw.log("Avarice's parties: #{e.message}")
  end

  class << self
    alias ft_ch8_register_trainer_data register_trainer_data unless method_defined?(:ft_ch8_register_trainer_data)
    def register_trainer_data
      ft_ch8_register_trainer_data
      register_avarice_parties
    end
  end

  TRAINER_INTROS.merge!(
    duergar_kord:  "KORD: Back to the sap! The engine's hungry!",
    duergar_brask: "BRASK: Stoke the fire. Feed the engine. Don't look at the dragon.",
    duergar_hild:  "HILD: Halt! Speak the words or burn.",
    duergar_thane: "GORM: More fuel. More fuel. You'll do.",
    devil_priest:  "VEXMORTIS: A congregation! How long since anyone came to my sermon on purpose."
  )

  TEXT.merge!(
    duergar_kord_after:  ["It's quieter when I lose. Isn't that a thing."],
    duergar_brask_after: ["I had a name before the Forge. I'm sure I did."],
    duergar_hild_after:  ["The words are in the ledger. Everyone knows them. Nobody says them."],
    duergar_thane_after: ["Go on, then. The engine doesn't care who feeds it."],
    devil_priest_after:  ["Go on. She's waiting. She's always waiting. That's the worst of her.",
                          "Her dragon flies at first light. She's never late."],
    barricade_illusion: ["By the wall, a model of the Dale has grown out of the roots: ten little towns of knotwood.",
                         "Over it, an illusion on a loop: a dragon of frost and fire, its eyes hell-red.",
                         "It circles the ten towns in the same order every time.",
                         "Over each, the town's lights go out. And come back. And go out.",
                         "Good Mead first. Then Bryn Shander."],
    duergar_ledger: ["A duergar ledger, sap-stained. Tallies of fuel, tallies of hands.",
                     "At the top of every page, the same words in a cramped hand:",
                     "\"Rimebound. Rise unbroken.\""],
    glassy_digger: -> {
      flag?(:barricade_passed) ? ["DIGGER: ...Is this the Guild? Is Hew here? I was hauling. I forget what."] :
                                 ["DIGGER: (hauling sap) Warm. Warm. Down's where the warm is."]
    },
    tea_table: -> {
      if flag?(:sworn_to_thredra) && flag?(:engine_dead)
        next ["A tea table set for six, a skin of frost on every cup.",
              "In the cracked glass, the hag with the ember eye lifts her cup to you.",
              "THREDRA: Burned. Paid in full, dearies. Mother's kitchen thanks you."]
      end
      flag?(:hag_mirror_done) ? ["A tea table set for six, a skin of frost on every cup.",
                                 "The cracked mirror over it is just a mirror now. Nearly."] :
                                ["A tea table set for six. Six cups, six saucers, six cakes gone hard as stone.",
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
                                ["Chained among the stones, on a cradle of iron and root: a dragon of black crystal.",
                                 "Its eyes are dark."]
    },
    forge_stair_shut: ["A stair of black glass winds up toward the engine.", "The devil-priest stands on the bottom step, smiling."],
    engine_dead: -> {
      flag?(:engine_dead) ? ["The engine hangs dark and cold. Where Glimmer knelt, the stone is still warm."] :
                            ["The engine hangs over the silver pool, a cage of chardalyn and roots.",
                             "It beats slowly, like something refusing to die."]
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
    guard = Stage.actor(:duergar, 8, 13, 4, graphic: "FT_duergar_guard")   # the one who speaks, on screen
    say(["The tunnel narrows until a wall of fused root and blackened iron blocks the way.",
         "The wood pulses like a heart under strain. Infernal sigils glow on its iron plates.",
         "A slit near the top leaks red-gold light. Beyond it, something patient is hammering.",
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
    # (notes 08 E5: the model is shown, not told from sixteen tiles away)
    Stage.pan_to(20, 9)
    say(lines_for(:barricade_illusion))
    Stage.pan_back
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
    say([c == 1 ? "KELYN: (from the stone) ...Then find Var. He'll know what it is." :
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
      speak(:wyn, "...Or something else. The roots don't know his name.", "...The roots don't know him.")
    end
  end

  # The comic-to-horror turn (rootspire.md 1177): at the siege of the Barricade,
  # the dormant fragment in Hew's compass hears its maker's sigils, and wakes.
  def hew_compass_wakes
    set_flag(:hew_compass_woke)
    # (notes 08 F3: whose compass, and who "Father" is)
    say(["In your pack, Hew's compass, built from his construct's parts, starts ticking faster.",
         "Then it chirps.",
         "COMPASS: (tinny, very pleased) Hello! Hello! Warm! So warm! Father, is that you?",
         herald?(:reptin) ? "(It's talking. Of course it's talking.)" : cl(:reptin, "(staring at the pack) It's talking. Of course it's talking."),
         "COMPASS: Warm warm warm warm warm warm warm warm",
         "The ticking stops.",
         "COMPASS: (a new voice: level, cool, patient) Prototype accepted. Hello, little failures.",
         "COMPASS: Variables. Always variables. Let me tell the gate you're here."].compact)
    $game_screen.start_shake(3, 6, 16) rescue nil
    say(["The brass splits along seams nobody put there. Root-legs unfold out of it.",
         "It climbs out of your pack on its own."])
    won = boss_battle(named_mon(:B208H82, 44, "Root-Compass Thing"))
    say([won ? "It falls over, legs twitching, and goes quiet. Its sap-bead cracks and turns black." :
               "It skitters for the gate on its root-legs. You catch it with a boot, and it cracks."])
    take_key(:FT_ROOTCOMPASS) rescue nil
    give_key(:FT_DEADCOMPASS)
    # Context 08 M8-1 boxes 12-13: the third "little failures", heard as the third.
    heard = [flag?(:mira_core_broken) || flag?(:mira_freed) ? "Mira said that." : nil,
             flag?(:met_mirror_child) ? "The boy's mirror said that." : nil].compact
    sayc([cl(:meat_meat, heard.empty? ? "Little failures. Meat Meat knows that voice. From the cold table." :
                                        "#{heard.join(' ')} Little failures."),
          cl(:alberica, "Built from parts Summer's people paid for. Lovely. Somebody check my pockets."),
          cl(:alerion, "Then she knows we're here."), cl(:wyn, "She always knew.")])
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
                   "(The duergar have words for this gate. Someone wrote them down, or says them on losing.)"])
      return
    end
    say(["(You say it the way the duergar say it, flat and tired.)"])
    pbSEPlay("Door exit") rescue nil
    say(["The bar slides. The gate grinds open.",
         "The duergar behind it steps back, blinks, and stares at his hands like they're not his."])
    set_flag(:barricade_passed)
    ($game_switches[SW_BARRICADE_OPEN] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    diggers_wake
    state[:goal] = "Through the gate, east, and down into the hag's old lair."
  end

  # Hew's diggers wake when the gate opens, whichever way it opened (notes 08
  # E13): at the gate, or the next time you come back to the Barricade after
  # the traitor's lever (an autorun on SW_DIGGERS_WAKE, tools/build_ch8.rb).
  def diggers_wake
    return if flag?(:diggers_woken)
    set_flag(:diggers_woken)
    ($game_switches[SW_DIGGERS_WAKE] = false; $game_map.need_refresh = true if $game_map) if $game_switches
    diggers = $game_map.events.values.select { |e| e.name =~ /^Glassy digger/ } rescue []
    Stage.pan_to(17, 13) if !diggers.empty? && !diggers.all? { |e| Stage.on_screen?(e) }
    say([flag?(:traitor_lever) ? "Far down the hall, the Barricade gate stands open. The diggers stop hauling." :
                                 "Behind you, the diggers stop hauling.",
         "One by one they sit down where they are, and look around, and start to cry."])
    diggers.each { |e| Stage.emote(e, :question) }
    Stage.pan_back if Stage.panned?
    sayc([flag?(:hew_confessed) ? cl(:meat_meat, "Hew's people. Hew will come for them. Hew owes them that.") : nil,
          cl(:wyn, "(already handing out a blanket) It's all right. You're all right now.")])
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
    mirror = stage_event("Cracked mirror")
    mspot = stage_spot(mirror)                    # (notes 08 E9: the mirror cracks, not the teacups)
    # (notes 08 E28: she's in the glass, half there)
    hag = Stage.actor(:thredra, mspot[0], mspot[1], 2, graphic: "FT_thredra_echo")
    if hag
      hag.opacity = 0
      stage_fade(hag, 140, 8, 3)
    end
    say(["In the glass, the table isn't empty: a stooped hag sips tea that isn't there.",
         "One of her eyes is dead and white. The other is a burning ember."])
    say(["THREDRA: (from the glass) My, my. The children come back to mother's kitchen."])
    # (WRITING_GUIDE §5: she answers it, so it's spoken, not thought)
    speak(:alberica, "You're dead. We were there.", "...You're dead.") if with_or_is?(:alberica)
    sayc(["THREDRA: I'm remembered, dearie. Mirrors always remember.",
          "THREDRA: And she took my kitchen. My mirrors, my stones, my lovely root.",
          "THREDRA: She uses my glass to wear people like coats.",
          cl(:reptin, "(under his breath) Says the woman who kept a pantry of children."),
          "THREDRA: Rootspire's stories call me Mother Thruuna. They forget. She doesn't.",
          "THREDRA: Burn her forge, dearies, and I'll whisper you a secret."])
    # The source's order: the price first. Swear to burn the forge, and then she whispers.
    c = pbMessage(_INTL("Thredra's mirror..."), [_INTL("Swear to burn her forge"), _INTL("Break the mirror")], 0)
    if c == 0
      say(["You swear it. The ember in her eye flares, pleased.",
           "THREDRA: There. A promise in my kitchen. Mirrors remember those too, dearies.",
           "THREDRA: Lean close. The heart in her engine isn't hers. The body she wears isn't hers.",
           "THREDRA: Break the heart, and the coat falls off."])
      set_flag(:sworn_to_thredra)
      Stage.fx("E-06", mspot, frames: 4, oy: 40)        # it only cracks wider
      say(["The mirror cracks wider. Thredra laughs."])
      stage_fade(hag, 0, 10, 3)
      Stage.remove_actor(hag) if hag
      say(["She goes on laughing after her face has gone."])
      set_flag(:took_hag_secret)
      wheel(-1)
    else
      if with_or_is?(:meat_meat)
        speak(:meat_meat, "Meat Meat does not make deals with mirrors.", "...No.")
      end
      Stage.remove_actor(hag) if hag
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
    say(["Amber cocoons in rows in the root walls. In some, shapes that might have been goblins.",
         "Labels on brass plates: RAZ-MKI. RAZ-MKII. V-3. V-5. V-6.",
         "One plate is empty, its cocoon split open from the inside, long ago. V-7.",
         herald?(:meat_meat) ? "(Very quietly, to yourself: ...That one is Meat Meat.)" : "MEAT MEAT: ...That one is Meat Meat."])
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
            "MEAT MEAT: Meat Meat is not a method.",
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
    sayc(["SELRAE: ...Thank you. Winter does not ask to be rescued. It seems I do.",
          "SELRAE: Go on. I will find my own way up. I have had practice being in the wrong place.",
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

  # The act's moral turn, staged (notes 08 E3): Darrus on the bridge with the
  # child's cocoon; Meat Meat goes at him with a blade of thought; he goes over
  # the rail and hangs there; she takes the child, and he falls into the sap.
  # The player gives an input on the beat (Journey: what you do while she does
  # it, read back at the arrest in Chapter 9).
  def scene_autumn_falls
    return if flag?(:autumn_fell)
    a = autumn_hand
    darrus = stage_event("Darrus Fell")
    Stage.turn_to(darrus) if darrus
    # the cocoon he's dragging, on the bridge beside him (it rolls for the rail when he lets go)
    cocoon = darrus ? Stage.actor(:cocoon, darrus.x + 1, darrus.y, 2, graphic: "FT_prop_cocoon") : nil
    # Context 08 M8-4: who he is (name and role again, two chapters on), and his case.
    say(["#{a[:full]}, #{a[:intro]}, drags a cocoon toward the forge.",
         "#{a[:His]} #{a[:dress]}. Inside the cocoon, a child's face, asleep.",
         "#{a[:tag]}: Stand aside! The engine needs one more. One more, and it never stops.",
         # (dialogue 08 §4.14: his velvet voice, so the case is a temptation)
         "#{a[:tag]}: (smooth again) One child. Then no famine years, ever. Be sensible.",
         "#{a[:tag]}: Do you know what Autumn's ledgers could do with that?"])
    if with_or_is?(:reptin)
      speak(:reptin, "(very pleasantly) You sold her the city, for a summer.", "...You sold her the city.")
    end
    say(["#{a[:tag]}: Autumn counts what winter will take. I've counted for thirty years. I'm done."])
    if with_or_is?(:meat_meat)
      speak(:meat_meat, "That is a child.", "...Put the child down.")
    end
    say(["#{a[:tag]}: It's fuel."])
    first = a[:full].split.first
    if herald?(:meat_meat)
      Stage.walk_to($game_player, darrus.x, darrus.y, adjacent: true) if darrus
      say(["You move faster than anyone has ever seen you move."])
      autumn_blade(darrus)
      say(["A blade of pure thought flashes in your hand.",
           "#{first} stumbles back, lets go of the cocoon, and goes over the rail."])
      autumn_over_rail(darrus)
      say(["#{a[:He]} catches the edge. Below #{a[:him]}, the sap boils.",
           "#{a[:tag]}: (clinging) Help me. Goblin. Help me."])
      Stage.walk(cocoon, [8]) if cocoon
      c = pbMessage(_INTL("#{first} is hanging from the edge. The child's cocoon is rolling toward the pit."),
                    [_INTL("Take the child"), _INTL("Reach for #{first}")], 0)
      if c == 1
        say(["You reach for #{a[:him]}. #{a[:His]} hand finds yours.",
             "Then the bridge shakes, and #{a[:his]} hand slides out of yours like water."])
        set_flag(:mm_reached)
      else
        say(["You look at #{a[:him]} for a long moment. Then you pick up the cocoon instead."])
        Stage.remove_actor(cocoon) if cocoon
        set_flag(:mm_turned)
      end
      autumn_into_sap(darrus)
      say(["#{a[:He]} falls."])
      Stage.remove_actor(cocoon) if cocoon          # (reaching for him, you left it: now you go back for it)
    else
      mm = with_or_is?(:meat_meat) ? Stage.summon(:meat_meat) : nil
      Stage.walk_to(mm, darrus.x, darrus.y, adjacent: true) if mm && darrus
      say(["Meat Meat moves faster than anyone has ever seen her move."])
      autumn_blade(darrus)
      say(["A blade of pure thought flashes in her hand.",
           "#{first} stumbles back, lets go of the cocoon, and goes over the rail."])
      autumn_over_rail(darrus)
      say(["#{a[:He]} catches the edge. Below #{a[:him]}, the sap boils.",
           "#{a[:tag]}: (clinging) Help me. Goblin. Help me."])
      Stage.emote(mm, :exclaim) if mm
      Stage.walk(cocoon, [8]) if cocoon
      c = pbMessage(_INTL("Meat Meat stands over #{a[:him]}, very still. The cocoon rolls."),
                    [_INTL("Grab the cocoon"), _INTL("Shout her name")], 0)
      if c == 1
        set_flag(:you_called_mm)
        say(["You shout her name. Meat Meat looks back at you.",
             "Then she looks at #{a[:him]} for a long moment, and picks up the cocoon instead."])
        Stage.remove_actor(cocoon) if cocoon
      else
        set_flag(:you_took_cocoon)
        Stage.remove_actor(cocoon) if cocoon
        say(["You catch the cocoon at the edge of the bridge.",
             "Meat Meat looks at #{a[:him]} for a long moment. Then she takes the child out of your arms."])
      end
      autumn_into_sap(darrus)
      say(["#{a[:He]} falls."])
      set_flag(:mm_turned)
    end
    sayc([cl(:alerion, "...We'll talk about that later."),
          herald?(:meat_meat) ? "Holding the child. (Yes.)" : "MEAT MEAT: (holding the child) Yes.",
          cl(:wyn, "...Is the little one breathing?")])
    set_flag(:autumn_fell)
    set_flag(:child_saved)
    ($game_switches[SW_AUTUMN_FELL] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    child_goes_up(a)
  end

  # The blade of thought: a cut of light, and the sound of it.
  def autumn_blade(darrus)
    pbSEPlay("Psycho Cut") rescue nil
    $game_screen.start_flash(Color.new(210, 170, 255, 230), 12) rescue nil
    Stage.wait(8)
  end

  # He stumbles back a step, then over the rail, and hangs from the edge.
  def autumn_over_rail(darrus)
    return if !darrus
    Stage.walk(darrus, [13]) rescue nil            # (a step backward, still facing her)
    darrus.through = true
    darrus.direction_fix = true rescue nil
    darrus.jump(0, -1) rescue nil
    Stage.wait(14)
  end

  # Into the boiling sap: a splash where he went, and he's gone.
  def autumn_into_sap(darrus)
    return if !darrus
    pbSEPlay("Splash") rescue nil
    stage_fade(darrus, 0, 6, 2)
    Stage.fx("E-07", [darrus.x, darrus.y], frames: 8)
    Stage.hide(darrus)
  end

  # Context 08 M8-5: Rootwardens the Speaker sent down take the child up, and
  # hear from Meat Meat where Autumn went (the witness for Chapter 9's charge).
  def child_goes_up(a)
    Stage.actor(:cocoon_held, $game_player.x, $game_player.y + 1, 2, graphic: "FT_prop_cocoon") rescue nil   # in arms
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
    say(["Heat slams into you like a living wall.",
         "A cathedral of a cavern, carved into the World Tree's roots. Molten sap churns below.",
         "Round the floor stand the Twenty Stones, the hag's altar, where the Reversal began."])
    # (notes 08 E5: the dragon is eighteen tiles off; go and look at it)
    Stage.pan_to(dragon.x, dragon.y) if dragon
    heart = dragon ? Stage.fx("E-14", [dragon.x, dragon.y], oy: 40, loop_from: 0) : nil   # the stolen heart, beating
    say(["Chained among them on a cradle of iron and root: a dragon of black crystal and mirror.",
         # (notes 08 E21: the engine is in the chamber above, not here)
         "Far above, through a shaft in the roots, a red glow beats: the engine, over the forge.",
         "In its heart, a sliver of blue frost-light, wrapped in Hyphora's gold sap."])
    Stage.stop_fx(heart)
    Stage.pan_back
    Stage.panel("S-11", fade: 20)                                  # the black crystal dragon among the Twenty Stones (panel, when drawn)
    say(["The Dragonforge."])
    Stage.panel_off
    sayc([as(:wyn, "(stricken) That's her sap. That's Hyphora's blood."),
          cl(:alerion, flag?(:heart_given_summer) ? "That's the cold Sephek carried. Eline said Summer had his heart." :
                                                    "That's the cold Sephek carried. I'd know it anywhere. That's his heart."),
          # (the spine, owner 2026-11-11: Auril is the threat under everything; Summer is burning a piece of her)
          cl(:reptin, "She's burning a piece of Auril to keep her summer going. When it burns out, Auril comes to take her winter back."),
          # (Brightmane's own words if the player heard her answer, 048_F; else Ch6's, on the spine)
          cl(:glimmer, flag?(:brightmane_answered) ? "(the Rimefang shaking) ...Brightmane said I'd know the fire when I saw it." :
                                                     "(the Rimefang shaking in his hand) ...Brightmane said I'd find a better fire.")])
    Stage.cleanup rescue nil
    state[:goal] = "Through the forge's keepers, to the engine."
  end

  def devil_priest(event_id = nil)
    if flag?(:forge_reached)
      return say(["Where the priest knelt, a scorch-mark in the shape of folded wings."], event_id) if flag?(:devil_fled)
      return say(lines_for(:devil_priest_after), event_id)
    end
    sayc(["A duergar priest kneels at a mirror-root altar by the stair, chanting in a rough tongue.",
          "As you come close, its shadow ripples, and wings unfold from it, impossibly wide.",
          "It turns: a devil all hooks and barbs, in priest's robes, smiling with too many teeth.",
          cl(:alberica, "Ooh. Lovely smile. Too many teeth, but lovely.")], event_id)
    return if !trainer(:devil_priest, event_id)
    set_flag(:forge_reached)
    ($game_switches[SW_FORGE_CLEARED] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    # Context 08 M8-6: the clock, on the spine (it used to live in her vault).
    # (dialogue 08 §3: he counts you and decides first; his last word sends you on)
    priest = event_id ? $game_map.events[event_id] : nil
    if companions.size >= 3
      set_flag(:devil_fled)
      say(["He counts you, and counts again, and decides he's outnumbered.",
           "VEXMORTIS: I serve her willingly. Not THAT willingly.",
           "VEXMORTIS: (folding his wings) Hurry, if you like. Her dragon flies at first light.",
           "VEXMORTIS: Go on. She's waiting. She's always waiting. That's the worst of her."], event_id)
      # (notes 08 E7: he goes, in smoke, not off a page)
      pbSEPlay("Fire1") rescue nil
      $game_screen.start_flash(Color.new(255, 90, 40, 160), 10) rescue nil
      stage_fade(priest, 0, 8, 2)
      say(["His wings fold round him, and he's gone in a smell of struck matches."])
      set_self_switch(event_id, "B") if event_id
      sayc([cl(:alerion, "Then it's tonight."),
            # (context 08 §4: "my patron" glossed on the spine, by the one who knows deals)
            cl(:glimmer, "(watching the smoke) A devil minding her stair. She's made a deal with something.")])
    else
      say(["VEXMORTIS: Hurry, if you like. Her dragon flies at first light. She's never late.",
           "VEXMORTIS: Go on. She's waiting. She's always waiting. That's the worst of her."], event_id)
      sayc([cl(:alerion, "Then it's tonight.")])
    end
    set_flag(:clock_first_light)
    say(["Behind the altar, a black-glass stair winds up toward her rooms, and the Heart beyond."])
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
  # The Heart Chamber's camera: the door you come in by, the pool, the engine
  # over it and Avarice at its foot, all in one view (notes 08 E4).
  HEART_VIEW   = [11, 11]
  CLIMAX_VIEW  = [14, 11]
  CLIMAX_SPOT  = [12, 14]   # where you stand for the better fire (clear of the spires)
  GLIMMER_SPOT = [14, 14]   # the pool's edge, under the engine

  def scene_heart_chamber
    return if flag?(:engine_dead) || flag?(:circle_phase)
    if !flag?(:heart_met)
      set_flag(:heart_met)
      heart_reveal
    else
      Stage.pan_to(*HEART_VIEW) if stage_event(VAR_EVENT)
      (stage_event(VAR_EVENT).character_name = "FT_var_cracked") rescue nil
      say(["Avarice is back at the engine's controls, still wearing what's left of Var, humming.",
           "AVARICE: Again? Again. I love a repeatable experiment."])
      Stage.pan_back rescue nil
    end
    heart_lair_actions
    return avarice_fight if flag?(:circle_done)
    if !flag?(:heart_opening_won)
      Stage.pan_to(*HEART_VIEW) if stage_event(VAR_EVENT)
      say([TRAINER_INTROS[:avarice_opening]])          # (notes 08 E26: her intro, shown)
      Stage.pan_back
      $ft_var_mask = true                       # she's still in Var's cracked face for the opening
      won = begin
        pbTrainerBattle(:FT_AVARICE, "Avarice", nil, false, AVARICE_OPENING) ? true : false
      ensure
        $ft_var_mask = false
      end
      return if !won
      set_flag(:heart_opening_won)
    end
    if !flag?(:heart_mechs_won)
      $game_screen.start_shake(4, 6, 16) rescue nil
      Stage.pan_to(*HEART_VIEW) if stage_event(VAR_EVENT)      # (she stays in view between the fights)
      (stage_event(VAR_EVENT).character_name = "FT_var_cracked") rescue nil   # (the map page still shows his face)
      say(["AVARICE: Round two. I brought friends.",
           "The silver pool heaves. Two Infernal Rootbreaker mechs climb out of it, sheeting sap."])
      setBattleRule("double")
      won = pbTrainerBattle(:FT_AVARICE, "Avarice", nil, false, AVARICE_MECHS) ? true : false
      return if !won
      set_flag(:heart_mechs_won)
      say(["The mechs sink back into the silver, steaming, and don't come up."])   # (notes 08 E7)
    end
    start_breaking_circle
  end

  # Context 08 M8-7: the reveal, with its clues. Var at the engine (his own
  # sprite, panned to); Kelyn on the sending-stone, offered a hostage and then
  # not; the face cracks; three clues from the player's own road, one box each.
  # Dialogue 08 §3b: then an exchange, not a speech: Reptin asks what the Dale
  # pays, and she answers with sums; the player gets a word in at the reveal.
  def heart_reveal
    var = stage_event(VAR_EVENT)
    Stage.pan_to(*HEART_VIEW) if var            # Var at the engine and you at the door, both in view
    say(["The enormous cavern of glowing roots opens round a pool of silver sap.",
         # (the portrait over his seat plays at the first Council, 024 kelyn on main: M8-3)
         (flag?(:wardens_sworn) || flag?(:wardens_refused)) ? "At the engine stands the man from the portrait: big, scarred, in gold. Var." :
                                     "A big, scarred man in the Summer Marshal's gold stands at the engine, his back to you.",
         "Over the pool hangs the engine, beating slowly, like something refusing to die.",
         "In your pack, the sending-stone warms.",
         "KELYN: (from the stone) Did you find him? Is Var down there?"])
    c = pbMessage(_INTL("The stone..."), [_INTL("Hold it up to him"), _INTL("Keep it covered")], 0)
    say([c == 0 ? "You hold it out across the pool. He doesn't turn round." : "You close your hand over it. He hears her anyway.",
         "VAR: (warm and rough, without turning) Kelyn. I'm here. It's worse than I told you.",
         "KELYN: (from the stone) Oh, thank the seasons. Var, come up. Come up now."])
    sayc([cl(:meat_meat, "He talks like the cold table. Slow. Counting.")])
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
    c = pbMessage(_INTL("Avarice waits, smiling."), [_INTL("\"Where's Var?\""), _INTL("Say nothing")], 0)
    say([c == 0 ? "AVARICE: (a hand on the cracked face) You're looking at him. What's left." :
                  "AVARICE: Nothing to say? Good. The ones who count are quiet."])
    # The look-back (never more than three): clues the player walked past.
    recall = []
    recall << "(Eline, at the Shrine: \"Summer has the heart. Summer keeps promises.\")" if flag?(:heart_given_summer)
    recall << "(Selrae, in the Sap Wells: \"The Root-Key. Summer gave Winter a copy.\" Her own key.)" if flag?(:root_key)
    recall << "(The compass Summer's people paid for: \"Hello, little failures.\")" if flag?(:hew_compass_woke) && !flag?(:var_story_known)
    recall << "(Var at the Split Dock, glaive up: \"Who in the Nine Hells are you?\" No answer, ever.)" if flag?(:var_story_known)
    say(recall.first(3)) if !recall.empty?
    say(["KELYN: (from the stone) ...Var?",
         "AVARICE: (to the stone) Gone thirty years, Speaker. Do keep up.",
         "The stone goes cold in your hand."])
    say(["AVARICE: The duergar call me Xardorok. Names are coats too. So is summer.",
         "AVARICE: When my dragon flies, Ten-Towns melts, and I sit where the Frostmaiden sits."])
    if with_or_is?(:reptin)
      speak(:reptin, "And the Dale? What does your summer cost them?", "...And the Dale?")
    end
    say(["AVARICE: Auril takes one a month and calls it mercy. I take them once. Do the sums.",
         "AVARICE: One harvest, warm, for the White Womb, and nobody in the Dale freezes again.",
         # (notes 08 E24: her case, the design's line)
         "AVARICE: Auril wants the world still. I want it running. On my schedule. Forever."])
    if with_or_is?(:meat_meat)
      speak(:meat_meat, "You took Razzy's voice.", "...You.")
    end
    sayc(["AVARICE: I took a great deal more than that, V-7. Come here and I'll show you.",
          herald?(:meat_meat) ? cl(:reptin, "(stepping in front of you) She's not going anywhere near you.") :
                                cl(:reptin, "(stepping in front of Meat Meat) She's not going anywhere near you.")])
    if flag?(:avarice_shard_lodged)
      say(["AVARICE: (past him) I watched you come down through my garden.",
           "AVARICE: You've been carrying my eye since the Shattered Bed."])
    end
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
      lines << "From the vantage towers above the forge, red-hot bolts come down through the roots!"
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
    Stage.pan_to(*HEART_VIEW) if stage_event(VAR_EVENT)
    say(["Avarice lays both hands on the engine. It drinks from her, or she from it.",
         "AVARICE: The engine needs a minute to drink. So do I.",
         "AVARICE: Fiddle with my circle, if you like. Every second, my dragon wakes a little more.",
         "Twelve root-spires ring the pool: Auril's frost-sigils under, Avarice's glyphs on top."])
    if flag?(:captain_hints)
      say(["(The tortured captain: scratch hers off, and she drinks less.)"])
    end
    sayc([cl(:alerion, "Scour her glyphs and the frost shows through. Break both and nothing does."),
          cl(:alberica, "And if Auril's sigils show through, Auril gets a word in. She always does.")])
    # (notes 08 F8: what each does for you, plainly)
    say(["(Scour a spire: she draws less, but Auril hears you. Break one: quiet, but it hurts.)",
         "(Six spires before the engine's next beat. Or speak to Avarice when you're ready.)"])
    Stage.pan_back rescue nil
    ($game_switches[SW_CIRCLE_PHASE] = true; $game_map.need_refresh = true if $game_map) if $game_switches
  end

  NUMBER_WORDS = %w[zero one two three four five six seven eight nine ten eleven twelve]

  def breaking_spire(n, event_id = nil)
    done = (state[:circle_spires] ||= {})
    if flag?(:engine_dead)
      return say([done[n] == :restored ? "A root-spire, its frost-sigil showing clean through the scratched-out fire." :
                  done[n] == :broken ? "A root-spire, both its runes broken. Silent." : "A root-spire, its runes cold and quiet now."], event_id)
    end
    if !flag?(:circle_phase)
      return say(["A root-spire carved with two runes: Auril's frost-sigil under, Avarice's glyph on top.",
                  "Whispers come off it. Not loud. Not yet."], event_id)
    end
    return say(["You've already worked this spire."], event_id) if done[n]
    left = 6 - (state[:circle_actions] || 0)
    say(["Under her glyph, a frost-sigil glitters, half buried. " +
         (left > 1 ? "(This one and #{NUMBER_WORDS[left - 1]} more.)" : "(The last one. Then the engine.)")], event_id)
    c = pbMessage(_INTL("The spire..."), [_INTL("Scour off her glyph"), _INTL("Break both runes"), _INTL("Leave it")], 2)
    return if c.nil? || c == 2
    if c == 0
      done[n] = :restored
      say(["You scrape the infernal glyph off. The frost-sigil underneath lights, cold and clean.",
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
          "A link snaps somewhere below with a crack like river ice. The engine beats faster.",
          "The whole chamber shudders as the dragon heaves. Dust and frost rain off the roots.",
          "You can hear its breath through the stone now: frost and fire, like a forge's bellows.",
          "The chains scream. Avarice smiles without opening her eyes."][[state[:circle_actions] - 1, 5].min]])
    $game_screen.start_shake(2, 4, 8 + 4 * state[:circle_actions]) rescue nil
    restored = done.values.count(:restored)
    if restored >= 4 && !flag?(:auril_heard_heart)
      set_flag(:auril_heard_heart)
      Stage.pan_to(*HEART_VIEW)                 # (Avarice on screen for her one crack)
      say(["From under the silver pool, very far away, a voice like a winter morning, almost clear:",
           "AURIL: Little thief. Little moth. You burn my saint for a candle, and call it summer."])
      Stage.emote(stage_event(VAR_EVENT), :angry)
      say(["AVARICE: (eyes snapping open) Be QUIET."])
      Stage.pan_back
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
    Stage.pan_to(*HEART_VIEW) if forced
    say([forced ? "The engine beats, once, like a door slamming. Avarice opens her eyes." : "AVARICE: (opening her eyes) Done? Good.",
         "AVARICE: Let's see what you've cost me."], event_id)
    if restored > 0
      say(["She draws on the engine, and it gives her less than it should.",
           "#{restored == 1 ? 'One spire' : "#{NUMBER_WORDS[restored].capitalize} spires"} of frost won't feed her."])
    end
    if broken == 0
      say(["The whispers off the spires press in on all of you, Auril's and Avarice's both, deafening."])
      if (flag?(:gallery_boon) && !flag?(:gallery_boon_used)) || (flag?(:grotto_boon) && !flag?(:grotto_boon_used))
        set_flag(:gallery_boon_used) if flag?(:gallery_boon)
        set_flag(:grotto_boon_used) if !flag?(:gallery_boon) && flag?(:grotto_boon)
        say(["(But you've been blessed against fear down here, and the whispers find nothing to hold.)"])
      else
        $Trainer.party.each { |pk| pk.hp = [pk.hp - [pk.totalhp / 12, 1].max, 1].max if pk.hp > 0 } rescue nil
        say(["The whispers find a grip. Your Pokémon flinch."])      # (notes 08 E18: said, not silent)
      end
    else
      say(["Where you broke the spires, the whispers have stopped. It's quieter. You can think."])
    end
    Stage.pan_back if Stage.panned?
    avarice_fight
  end

  # Avarice's last fight. If you lose, the engine vents: she stands up whole, and
  # so do you, once (the captain's warning, 046_ForgeRooms.rb tortured_captain).
  def avarice_fight
    type, name = TRAINERS[:avarice]
    tries = flag?(:engine_vented) ? 1 : 2
    won = false
    tries.times do |i|
      if i == 1
        set_flag(:engine_vented)
        $game_screen.start_shake(5, 8, 20) rescue nil
        Stage.fx("E-13", $game_player) rescue nil                  # the ring of heat rolls out (Art List E-13)
        say(["The engine screams and vents. A wave of heat throws everyone to the floor.",
             "When you can see again, Avarice is on her feet, laughing, whole.",
             "AVARICE: Again? Again. I love a repeatable experiment."])
        pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
        say(["(The vent stood you up too. It won't do that twice.)"])
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

  # SC 8.07: a better fire. The order (notes 08 E11): Glimmer breaks the engine;
  # Avarice reacts to it while she still can (the coat falls off, and she burns,
  # or seems to); the party grieves; then, after a fade, the Shard and your
  # choice in the empty chamber; then the dragon flies.
  def scene_better_fire
    var = stage_event(VAR_EVENT)
    var.character_name = "FT_var_cracked" if var rescue nil   # (page 1 still draws his whole face)
    Stage.walk_to($game_player, *CLIMAX_SPOT, face: 6) rescue nil
    Stage.pan_to(*CLIMAX_VIEW)
    say(["Avarice staggers, laughing. Behind her, the engine screams.",
         "Blue frost-light and red fire twist together. It'll burst, and take the tree's heart too.",
         "AVARICE: Kill me and it blows. Leave me and it runs forever. Your move."])
    gl = herald?(:glimmer) ? nil : Stage.summon(:glimmer)
    # (dialogue 08 §3b: he answers her; 6.08's words, and the echo turns)
    say(["GLIMMER: (stepping past her) Neither."])
    Stage.walk_to(gl, *GLIMMER_SPOT, face: 8) if gl
    say(["GLIMMER: This blade's been killing me since it turned up in my boot.",
         flag?(:brightmane_answered) ? "GLIMMER: \"You'll know it when you see it,\" Brightmane said." : "GLIMMER: Brightmane said I'd find a better fire.",
         "He lifts the Rimefang.",
         "GLIMMER: She never said it'd be me."])
    c = pbMessage(_INTL("Glimmer..."), [_INTL("Reach for him"), _INTL("Let him go")], 0)
    say([c == 0 ? "You reach for him. He's already past you." : "You let him go. It's the hardest thing you've done down here."])
    if with_or_is?(:alberica)
      speak(:alberica, "Glimmer. Glimmer, don't you dare.", "...Glimmer.")
    end
    say(["AVARICE: (interested, not moving) Go on. I want to see the sums.",
         "GLIMMER: Shimmer found the third way. I'm only following her."])
    # Shimmer's "Keep the cat", handed on (whole read T17)
    say([herald?(:alberica) ? "He presses Shimmer's carved cat into your hand." :
         with_or_is?(:alberica) ? "He presses Shimmer's carved cat into Alberica's hand." :
                                  "He sets Shimmer's carved cat down on the stone, where you'll find it."])
    # The Rimefang into the engine (a panel when the art comes: see the report).
    heart = Stage.fx("E-14", [15, 6], oy: 16, loop_from: 0)
    say(["He drives the Rimefang into the heart of the engine.",
         "The Lumen Shard in his chest blazes like a sunrise."])
    pbSEPlay("Saint7") rescue nil
    $game_screen.start_flash(Color.new(255, 230, 160, 255), 30) rescue nil
    say(["The dagger melts. Re-forms. Gold now, not blue."])
    Stage.stop_fx(heart)
    $game_screen.start_shake(4, 6, 20) rescue nil
    say(["Far above, at the Shrine of the Twinned Dragons, Frostina lifts her head and goes quiet.",
         "The engine goes dark."])
    Stage.face(gl, 2) if gl
    say(["Glimmer is kneeling where it was. Light is coming out of him, through his fur, his coat.",
         "He's smiling. He looks at you last."])
    # (a farewell the player gives: WRITING_GUIDE §3, losses leave room for one)
    c = pbMessage(_INTL("Glimmer looks at you."), [_INTL("Nod"), _INTL("Say his name")], 0)
    say([c == 0 ? "You nod. He nods back, as if you'd agreed on something." : "You say his name. He hears it."])
    # S-12 as drawn: Glimmer over the stone, the Rimefang gone gold in the forge-light. It carries his last words;
    # the light rising out of him plays on the map (E-11).
    Stage.panel("S-12", fade: 20)                                  # a better fire: Glimmer and the reforged dagger
    say([
         "GLIMMER: The cold's gone. Years of it.",
         "GLIMMER: ...Tell Frostina it was a better fire. She'll know what I mean."])
    Stage.panel_off
    $game_screen.start_flash(Color.new(255, 250, 220, 200), 40) rescue nil
    stage_fade(gl, 120, 8, 3)
    Stage.fx("E-11", gl, oy: 24) rescue nil if gl                     # his light rises out of him (E-11)
    say(["The light goes up, through the roots, through the tree, toward a plain of stars."])
    stage_fade(gl, 0, 10, 4)
    Stage.remove_actor(gl) if gl
    say(["The unicorn's horn goes with it.",
         "Where he was, a golden dagger lies on the stone, warm."])
    if flag?(:glimmer_has_rose)
      # (notes 08 E16: the rose he pocketed is read back; Chapter 9 gives it to Frostina)
      say(["Beside it, a jar of black ice, and Shimmer's rose in it, still in bloom."])
      give_key(:FT_FROZENROSE)
    end
    state[:companions] = (state[:companions] || []) - [:glimmer]
    set_flag(:glimmer_gone)
    set_flag(:shade_curse_broken)
    set_flag(:engine_dead)
    set_flag(:engine_dead_heart) if flag?(:took_hag_secret)
    add_counter(:story_beats)
    # (SW_ENGINE_DEAD waits for the coat to fall: Var's page stays till then, E4)
    scene_coat_falls
    glimmer_grief
    scene_heart_choice
    scene_launch
  end

  # The grief beat, before anything else happens (WRITING_GUIDE §3: losses leave
  # room for a farewell). Meat Meat picks the dagger up, and holds it out to you,
  # and doesn't let go until you've both got hold (notes 08 E22).
  def glimmer_grief
    Stage.pan_to(*CLIMAX_VIEW)
    say(["Nobody moves for a while."])
    if herald?(:meat_meat)
      say(["You pick up the golden dagger and hold it against your chest for a long time."])
      Stage.balloon($game_player, "B-07", frames: 60)
      speak(:meat_meat, "Meat Meat not crying. That is sap.", "...")
    elsif with_or_is?(:meat_meat)
      mm = Stage.summon(:meat_meat)
      Stage.walk_to(mm, *GLIMMER_SPOT, face: 8) if mm
      Stage.balloon(mm, "B-07", frames: 60) if mm
      say(["Meat Meat picks up the golden dagger and holds it against her chest for a long time.",
           "MEAT MEAT: Meat Meat not crying. That is sap."])
      Stage.approach(mm) if mm
      c = pbMessage(_INTL("Meat Meat holds the dagger out to you."), [_INTL("Take it with her"), _INTL("Close her hands round it")], 0)
      say([c == 0 ? "You take hold of it too. She doesn't let go until you've both got it." :
                    "You close her hands round it. She closes yours round it too. Neither of you lets go."])
    end
    sayc([cl(:alerion, "He always hummed Shimmer's song wrong. On purpose, I think.")])
    give_key(:FT_DAWNFANG)
    Stage.cleanup rescue nil
    pbMessage(_INTL("Glimmer is gone.")) rescue nil
    pbFadeOutIn {} rescue nil                    # (a breath before the Shard rises: story review 08 §8)
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
    Stage.pan_to(*CLIMAX_VIEW)
    say(["The chamber is empty now but for you, and it's coming apart. Roots creak overhead.",
         "In the silver pool, something floats free, gathering ice and light: the Frost Saint Shard.",
         "Sephek's heart, veined with frost-light. It whispers prayers in a voice that isn't his."])
    lines = []
    lines << "(The lab notes: a goddess poured into a drowned man's heart. It worked too well.)" if flag?(:knows_shard_origin)
    lines << "(The ghost in the Antechapel: cleanse me, leave me whole, or break me. None clean.)" if flag?(:shard_echo_heard)
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
    sayc([cl(:meat_meat, "Meat Meat wants to stab it. ...Meat Meat will listen. For him."),
          # (dialogue 08 §5: no pet name in grief, and not a cliché)
          cl(:alberica, "You choose. We'll all carry it.")])
    c = pbMessage(_INTL("The Frost Saint Shard..."), [_INTL("Sanctify it"), _INTL("Leave it whole"), _INTL("Destroy it")], 0)
    case c
    when 0
      set_flag(:shard_purified)
      say(["You lift it out of the pool. It's so cold your hands go white.",
           "Inside it, under the goddess's light, something else listens: Sephek's echo, curled small."])
      # GQ2 (rootspire.md 8489): tend it (Medicine), then talk the echo into
      # accepting Verdant Fire (Persuasion). Both, and the blessing is yours.
      # (notes 08 E15: a wrong answer is felt, and gets one more try)
      tend = shard_ask(_INTL("The heart is cracked with frost. How do you hold it?"),
                       [_INTL("Warm it slowly, against you"), _INTL("Plunge it into the hot sap"), _INTL("Chip the frost off")],
                       "The frost bites back. The cracks spread a hair wider. Gently, then.")
      persuade = shard_ask(_INTL("The echo of Sephek flinches from the gold. What do you tell it?"),
                           [_INTL("\"This fire is only to warm you.\""), _INTL("\"Take it, or we break you.\""), _INTL("\"Auril is gone. Let go.\"")],
                           "The echo curls tighter round itself. It doesn't believe you.")
      say([with_or_is?(:wyn) ? "Wyn pours Hyphora's gold sap over it, and you lay the warm golden dagger against it." :
                               "You pour gold sap from the engine's cage over it, and lay the golden dagger against it."])
      if tend == 0 && persuade == 0
        say(["The echo uncurls. It lets the green fire in.",
             "Green fire and gold. The frost-light screams, and thins, and goes out of it like a breath.",
             "What's left beats once, slowly. Only a man's heart. Cold. Clean.",
             "The green fire doesn't go out. It runs up the dagger, into your arms, into your Pokémon.",
             "A sliver of the light breaks off and stays lit. It hums four notes. Shimmer's notes."])
        grant_blessing(:verdant_fire, "Blessing of Verdant Fire", "Your Pokémon's Fire- and Grass-type moves are a little stronger.")
        give_key(:FT_SAINTSECHO)
        set_flag(:shard_sanctified)
        wheel(1)
      else
        say(["The echo shies from the fire, and the frost-light floods back into the space it left.",
             "The Shard wrenches out of your hands. A wraith of rime rises off it, drowned-faced."])
        boss_battle(named_mon(:B92H215, 50, "Frost Saint Echo"), bgm: SHARD_BGM)
        say(["The Echo comes apart in sleet. What's left in your hands beats once. Only a man's heart.",
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
      say(["You drive Dawnfang through it.", "The Shard bursts like a frozen lake in spring. The light out of it is cold, and goes out.",
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

  # One of the sanctify questions: a wrong answer shows itself, and you get one
  # more try (returns 0 if you got it right).
  def shard_ask(prompt, opts, wrong)
    c = pbMessage(prompt, opts, 0)
    return 0 if c == 0
    say([wrong])
    pbMessage(prompt, opts, 0)
  end

  # The Shard's music: a frozen god's, not a wild Pokémon's (notes 08 E26).
  SHARD_BGM = "regibattle"

  # H23's boss (rootspire.md: "a fragment of Auril, part ritual object, part
  # angel-of-winter"): with the engine dead, the Shard defends itself. Every
  # spire you restored in the Breaking Circle let Auril speak through it less
  # angrily (it starts weaker); every one you broke left it nothing to hold.
  def shard_battle
    set_flag(:shard_fought)
    $game_screen.start_shake(3, 5, 16) rescue nil
    say(["The Shard rises out of the pool. Ice gathers on it, plate by plate, into a shape:",
         "tall, winged, faceless, with a spear of rime in its hand.",
         "The air round it goes so cold your breath falls as snow.",
         "SHARD: (a frozen lake, cracking) You killed the fire that fed me. Now feed me yourselves."])
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
      say(["(Auril's Echo presses on your mind, but your blessing from the Labyrinth holds it off.)"])
    else
      $Trainer.party.each { |pk| pk.hp = [pk.hp - [pk.totalhp / 16, 1].max, 1].max if pk.hp > 0 } rescue nil
      say(["(Frozen Sanctity: the chill bites your whole team before the fight even starts.)"])
    end
    setBattleRule("canLose") rescue nil
    if boss_battle(shard, bgm: SHARD_BGM)
      set_flag(:shard_beaten)
      say(["The ice-shape shatters. The Shard falls back into the pool, small again, and quiet."])
    else
      set_flag(:shard_overcame)
      say(["The Shard's spear drives you to the pool's edge. Then, spent, the ice-shape falls apart.",
           "It sinks into the silver, still whispering, with nothing left to fight with. Nor have you."])
    end
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
  end

  # Avarice fakes her death (the owner's canon): Hell's Veil takes her, and what's
  # left in the ring of melted glass is a body with white hair. The party believes
  # it. A careful player can catch the lie: Vessel IX (the Stasis Gallery's last
  # page), bare arms, and a mirror shard that fogs once, as if breathed on.
  # She steps out of Var as the engine dies (notes 08 E4, E11: she reacts to it
  # now, while she can); Var's emptied body stays where he stood until it breaks.
  def scene_coat_falls
    var = stage_event(VAR_EVENT)
    Stage.pan_to(*CLIMAX_VIEW)
    sayc(["With the engine dead, Var's body cracks all over, like ice on a lake."])
    av = var ? Stage.actor(:avarice, var.x, var.y, 2, graphic: "FT_avarice") : nil
    Stage.walk(av, [1]) if av                   # she steps out of him, down off the pool's edge
    Stage.turn_to(av) if av
    sayc(["Avarice steps out of him, and looks down at her own hands.",
          "AVARICE: Oh. That was clever.",
          "She reaches for a shard of the hag's old mirror. It's cracked through. It won't take her."])
    pbSEPlay("Fire1") rescue nil
    $game_screen.start_flash(Color.new(200, 30, 20, 220), 20) rescue nil
    $game_screen.start_shake(4, 6, 20) rescue nil
    veil = (Stage.fx("E-31", av, oy: 24, fps: 12, loop_from: 4) rescue nil)   # Hell's Veil (E-31), burning while she talks
    sayc(["A pillar of red-black flame roars up round her: Hell's Veil, eating the air.",
          # (notes 08 E19, dialogue 08 §5: no promise to return, and no death-cry;
          # she's faking it, so she sells it with style)
          "AVARICE: (from inside the fire, in no hurry at all) Mind the dragon."])
    stage_fade(av, 0, 8, 3)
    Stage.stop_fx(veil) rescue nil
    say(["The pillar collapses inward with a sound like a door slamming. Then nothing."])
    Stage.fx("E-06", stage_spot(var, 0, 1), frames: 10, oy: 16)   # the ring of melted glass
    # (notes 08 E19: there is a body in the glass, for "Look more closely")
    if av
      av.direction = 8 rescue nil
      stage_fade(av, 200, 6, 2)
    end
    sayc(["When the smoke clears, a body lies in a ring of melted glass: white hair, face down."])
    Stage.fx("E-06", var, frames: 10, oy: 32) if var
    Stage.hide(var) if var
    say(["Beside it, Var Rime-Breaker's borrowed body turns to glass, and breaks."])
    ($game_switches[SW_ENGINE_DEAD] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    sayc([with_or_is?(:alerion) ? as(:alerion, "(not touching her) ...Dead. Nothing in her. Nothing at all.") : "She doesn't move.",
          cl(:alberica, "She doesn't get to come back from that. Not even her."),
          cl(:meat_meat, "...Good.")])
    # (an input on the beat for everyone; only the player who read the lab's
    # last page knows what the bare arms mean)
    c = pbMessage(_INTL("The body in the glass..."), [_INTL("Look more closely"), _INTL("Leave it")], 1)
    if c == 0 && flag?(:decoy_clue)
      set_flag(:avarice_doubt)
      say(["You look at the arms. They're bare.", "Avarice's arms were covered in burned sigils. These have none.",
           "(The note in the labyrinth: \"Vessel IX: viable. Keep it warm.\" A spare body.)",
           "You don't say anything. Nobody else noticed. You're not sure you want them to."])
    elsif c == 0
      say(["You look. White hair, burned black. The glass round her is still warm.", "Nothing moves."])
    end
    white_womb_beat
    # Context 08 M8-9: Kelyn heard it all; the city didn't.
    say(["The sending-stone warms in your hand.",
         "KELYN: (from the stone) I heard her. All of it. ...The leaves are turning up here.",
         "KELYN: (from the stone) Come up. Before the city decides what it saw."])
    set_flag(:kelyn_heard_reveal)
    say(["On the floor, a splinter of the hag's mirror fogs once, as if breathed on from far away."])
    set_flag(:avarice_faked_death)
    set_flag(:avarice_believed_dead)
    set_flag(:summer_dead)
    add_counter(:story_beats)
  end

  # Context 08 §6: the White Womb, in her sums at the reveal, is a place
  # Alberica's family has a word for (her bargain: the Vault stays shut).
  # §8b: with the ice mask's name, Alerion joins the three names.
  def white_womb_beat
    if herald?(:alberica)
      say(["(The White Womb, she said. Gran's word for it was \"the Vault\". The one we keep shut.)"])
    elsif with_or_is?(:alberica)
      say([as(:alberica, "(a hand on her rune) The White Womb, she said. Gran had a word for that place.")])
      if with_or_is?(:alerion)
        speak(:alerion, "What word?", "...What word?")
        say([as(:alberica, "...Later, pretty boy.")])
      end
    end
    if flag?(:ithryn_athis_clue) && with_or_is?(:alerion)
      say([as(:alerion, "The White Womb. The glass mask called it Ythryn. The sigils call it a vault.")])
    end
  end

  #-----------------------------------------------------------------------------
  # SC 8.09 - Launch
  #-----------------------------------------------------------------------------
  # Shown, not told from another map (notes 08 E5): a cut down to the
  # Dragonforge, where the dragon tears free and goes up through the roof.
  def scene_launch
    pbSEPlay("Earth3") rescue nil
    $game_screen.start_shake(6, 8, 40) rescue nil
    say(["Below, among the Twenty Stones, the engine's last pulse runs into the dragon's chains."])
    Stage.visit(MAPS[:dragonforge], 26, 19, 8) do
      dragon = Stage.actor(:chardalyn, 26, 15, 2, graphic: "FT_chardalyn")
      Stage.pose(dragon, "K-CHD-01", 0, frames: [0, 1, 2, 3], per: 8) if dragon   # (K-CHD-01) its eyes light gold
      $game_screen.start_shake(7, 9, 40) rescue nil
      Stage.pose(dragon, "K-CHD-02", 0, frames: [0, 1], per: 10) if dragon        # (K-CHD-02) it strains at the chains
      say(["The sap rivers surge. Chains snap like thunder. A roar shakes the World Tree itself."])
      Stage.pose(dragon, "K-CHD-02", 0, frames: [2], per: 6) if dragon            # ...and they break
      say(["The dragon tears free. Infernal runes blaze. Wings of mirror-glass unfurl.",
           "In its chest beats another heart, older than Sephek's, and never its own."])
      pbSEPlay("Explosion3") rescue nil
      Stage.pose(dragon, "K-CHD-02", 0, frames: [3], per: 10) if dragon           # straight up
      Stage.remove_actor(dragon) if dragon
      say(["It blasts through the roof and the roots, and rises into the night: toward Ten-Towns."])
    end
    # (context 08 M8-6: the cost of winning is the player's own doing)
    sayc([flag?(:clock_first_light) ? cl(:alerion, "First light, she said. We woke it early.") : nil])
    # (dialogue 08 §3: the shout, then the picture, each in its own box; the
    # round of reported feelings is cut, dialogue 08 §4.34)
    say([herald?(:meat_meat) ? "(You scream it before you know you're going to: RAZZY!)" : "MEAT MEAT: RAZZY!",
         "Far above, Razzilith panics. A picture in all your heads: every scale on end, then rage."])
    lines = []
    lines << cl(:alerion, "(already running) That heart's an old frost wyrm's. Older than her. ...Frostina!")
    lines << (herald?(:meat_meat) ? "In your hands, the golden dagger hums, and won't stop." :
              with_or_is?(:meat_meat) ? "In your hands, and Meat Meat's, the golden dagger hums, and won't stop." :
                                        "In your pack, the golden dagger hums, and won't stop.")
    lines << "Far above, two dragons are already diving after it."
    sayc(lines)
    # P1: Meat Meat's own rage (the source gives it to her, not only to Razzy).
    if with_or_is?(:meat_meat)
      speak(:meat_meat, "(through her teeth) She built it out of Razzy. Meat Meat will take it apart.",
            "(through her teeth) ...Meat Meat is going to take it apart.")
    end
    set_flag(:dragon_launched)
    add_counter(:story_beats)
    $game_screen.start_shake(8, 9, 50) rescue nil
    say(["The Heart Chamber comes apart. Part of the cavern folds into a tunnel of cooling sap.",
         cl(:reptin, "That's our way out. GO!")].compact)
    # (the player's last look, a beat for Glimmer before the run)
    c = pbMessage(_INTL("The roof is coming down."), [_INTL("Run"), _INTL("Look back once")], 0)
    say([c == 0 ? "You run." : "You look back once: the engine's dark cage, sliding into the silver. Then you run."])
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
  # Until the gate opens they're still glassy-eyed (notes 08 E13: nobody is
  # "woken" before the gate is); after, the woken one tells you about the lift.
  # The first rest here, the party talks (once before the engine, once after).
  def forge_rest(event_id = nil)
    if flag?(:barricade_passed)
      say(["A digger who's woken up shares a flask of warm sap with you and your Pokémon.", "Everyone feels better."], event_id)
    else
      say(["A digger with glassy eyes pours you warm sap without looking up.",
           "DIGGER: Warm. Warm. Down's where the warm is.", "Everyone feels better anyway."], event_id)
    end
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_rest_at(FORGE_REST) rescue nil
    if flag?(:barricade_passed) && flag?(:rootwatch_cleared) && !flag?(:forge_camp_met) && !flag?(:lift_told)
      set_flag(:lift_told)
      say(["DIGGER: The lift's running again. By the gate. Root to Forge, quick as you like."], event_id)
    end
    if !flag?(:glimmer_gone) && !flag?(:banter_forge_rest)
      set_flag(:banter_forge_rest)
      sayc([cl(:meat_meat, "This sap tastes like coffee that gave up."),
            cl(:wyn, "Um. I have the mushroom kind. In my bag. If anyone..."),
            cl(:meat_meat, "Mushroom friend is a hero."),
            cl(:glimmer, "(holding out a cup) Seven years without a decent cup. Fill it, please."),
            cl(:alberica, "Seven years? Kitten, I'll pour it myself."),
            cl(:alerion, "Don't."),
            # (notes 08 F9, dialogue 08 §5: the curse shown, in his fur-joke voice)
            cl(:glimmer, "The fur helps. Mostly.")])
    elsif flag?(:glimmer_gone) && !flag?(:banter_forge_rest_after)
      set_flag(:banter_forge_rest_after)
      sayc(["Nobody says much. The diggers' flask goes round twice.",
            cl(:alberica, "He'd have made a joke about this sap. A terrible one."),
            cl(:alerion, "He did."),
            cl(:wyn, "...I poured him a cup. I don't know why."),
            cl(:meat_meat, "Leave it. Meat Meat will guard it.")])
    end
  end

  # Losing in the Forge wakes you on the diggers' floor, not at "a Pokémon
  # Center" (notes 08 E26, F7). The base game's line is swapped for this one
  # while you're whiting out to a Forge rest.
  FORGE_REST_MAPS = [2072, 2150]

  def forge_whiteout_line
    return nil if !active? || !$PokemonGlobal || !FORGE_REST_MAPS.include?($PokemonGlobal.pokecenterMapId)
    $PokemonGlobal.pokecenterMapId == 2150 ? "You come to by the Root-Throne. A digger presses warm sap into your hands." :
                                              "You come to on the Barricade floor. A digger presses warm sap into your hands."
  end

  def apply_chapter8_switches
    return if !active? || !$game_switches
    sync_switch(SW_BARRICADE_OPEN, flag?(:barricade_passed))
    sync_switch(SW_HAG_MIRROR, flag?(:hag_mirror_done))
    sync_switch(SW_AUTUMN_FELL, flag?(:autumn_fell))
    sync_switch(SW_FORGE_CLEARED, flag?(:forge_reached))
    sync_switch(SW_ENGINE_DEAD, flag?(:engine_dead))
    $game_switches[SW_SELRAE_PEN] = flag?(:selrae_ahead) && !flag?(:selrae_rescued)
    $game_switches[SW_DIGGERS_WAKE] = flag?(:traitor_lever) && !flag?(:diggers_woken)
  end

  # A character fades out (or in) over a few frames: a ghost leaving a mirror,
  # a man going into the sap, a light going up (notes 08 E7: what "fades" fades).
  def stage_fade(ev, to = 0, steps = 8, per = 3)
    return if !ev
    from = ev.opacity rescue 255
    steps.times do |i|
      ev.opacity = from + (to - from) * (i + 1) / steps rescue nil
      Stage.wait(per)
    end
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

# The whiteout line at a Forge rest (FrostThaw.forge_whiteout_line). Only the
# base game's "scurry back to a Pokémon Center" message is swapped, and only
# while pbStartOver runs.
if defined?(pbStartOver) && defined?(pbMessage)
alias ft_forge_pbStartOver pbStartOver unless defined?(ft_forge_pbStartOver)
def pbStartOver(*args)
  $ft_whiteout_line = (FrostThaw.forge_whiteout_line rescue nil)
  ft_forge_pbStartOver(*args)
ensure
  $ft_whiteout_line = nil
end

alias ft_forge_pbMessage pbMessage unless defined?(ft_forge_pbMessage)
def pbMessage(message, *args, &block)
  if $ft_whiteout_line && message.is_a?(String) && message.include?("scurry back to a Pok")
    message = "\\w[]\\wm\\c[8]\\l[3]" + $ft_whiteout_line
  end
  ft_forge_pbMessage(message, *args, &block)
end
end
