#===============================================================================
# Frost & Thaw - Act II, Chapter 8: the Rootsun Forge (script SC 8.01-8.09)
#
# Find the Summer Marshal and stop what's burning. Both roads end here, in the
# hag's old lair under the ruins of Dougan's Hole.
#
#   2072 The Rootward Barricade (8.01): root and iron fused into a wall;
#        enthralled duergar and Hew's missing diggers; the passphrase.
#   2073 The Hag's Abandoned Domain (8.02): a tea table set for six, and
#        Thredra's echo in a cracked mirror.
#   2074 The Domain's lower level (8.03): the cocoon pens. RAZ-MKI, MKII, V-3,
#        V-5, V-6, and an empty one: V-7.
#   2075 The Dragonforge (8.04, 8.05, 8.09): the sap-pit bridge where Autumn
#        falls; the Twenty Stones and the chardalyn dragon.
#   2076 The Heart Chamber (8.06-8.08): Var, who is Avarice; Glimmer's better
#        fire; the coat falls off.
#===============================================================================
module FrostThaw
  SW_BARRICADE_OPEN = 3975   # the passphrase was spoken: the Barricade's gate is open
  SW_HAG_MIRROR     = 3976   # the tea-table mirror is dealt with (deal or broken)
  SW_AUTUMN_FELL    = 3977   # Darrus has fallen; the bridge is clear
  SW_FORGE_CLEARED  = 3978   # the forge's gauntlet is beaten: the way to the Heart Chamber
  SW_ENGINE_DEAD    = 3979   # the engine is dead (Glimmer is gone)
  SW_SELRAE_PEN     = 3980   # Selrae is in the last cocoon (selrae_ahead, not yet rescued)

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
    duergar_kord:  [:FT_DUERGAR, "Kord",  [[:MAGCARGO, 45], [:B208H126, 46]], "The Forge-Mistress said you'd come. The failures always return."],
    duergar_brask: [:FT_DUERGAR, "Brask", [[:B76H59, 45], [:B205H229, 46]], "My hands... why are my hands so hot?"],
    duergar_hild:  [:FT_DUERGAR, "Hild",  [[:B95H126, 46], [:TORKOAL, 46]], "Rimebound. Rise unbroken. That's all she lets us say."],
    duergar_thane: [:FT_DUERGAR, "Thane", [[:B112H59, 47], [:B227H229, 47]], "Stoke. Stoke. Stoke. ...Is it quiet? Why is it quiet?"],
    devil_priest:  [:FT_DEVIL, "Vexmortis", [[:HOUNDOOM, 47], [:B229H94, 48], [:B126H229, 48]],
                    "She'll forge a better one of me, she said. She always says that."],
    avarice:       [:FT_AVARICE, "Avarice", [[:B229H122, 49], [:B208H126, 49], [:B82H429, 50], [:B229H150, 52]],
                    "Variables. Always variables.", [:FULLRESTORE, :FULLRESTORE, :HYPERPOTION]]
  )
  TRAINER_INTROS.merge!(
    duergar_kord:  "KORD: The Forge-Mistress said you'd come. The failures always return.",
    duergar_brask: "BRASK: Stoke the fire. Feed the engine. Don't look at the dragon.",
    duergar_hild:  "HILD: Halt! Speak the words or burn.",
    duergar_thane: "THANE: More fuel. More fuel. You'll do.",
    devil_priest:  "VEXMORTIS: A congregation! How long since anyone came to my sermon on purpose."
  )

  TEXT.merge!(
    duergar_kord_after:  ["The fire's in my head. It's quieter when I lose."],
    duergar_brask_after: ["I had a name before the Forge. I'm sure I did."],
    duergar_hild_after:  ["The words are in the ledger. Everyone knows them. Nobody says them."],
    duergar_thane_after: ["Go on, then. The engine doesn't care who feeds it."],
    devil_priest_after:  ["Go on. She's waiting. She's always waiting. That's the worst of her."],
    barricade_illusion: ["On the wall, an illusion plays on a loop.", "A black dragon circles ten little towns on a frozen lake.",
                         "Each time it passes over a town, the town's lights go out. And come back. And go out."],
    duergar_ledger: ["A duergar ledger, sap-stained. Tallies of fuel, tallies of hands.",
                     "At the top of every page, the same words in a cramped hand:",
                     "\"Rimebound. Rise unbroken.\""],
    glassy_digger: -> {
      flag?(:barricade_passed) ? ["DIGGER: (blinking) ...Is this the Guild? Is Hew here? I was hauling. I don't remember what."] :
                                 ["DIGGER: (hauling sap, smiling, eyes like glass) Warm. Warm. Down's where the warm is."]
    },
    tea_table: -> {
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
    engine_dead: ["The engine hangs dark and cold. Where Glimmer knelt, the stone is still warm."]
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
    say(["Root and iron, fused into a wall. Duergar wearing Avarice's sigils guard it.",
         "Among them, Hew's missing diggers haul sap with blank smiles.",
         "DUERGAR: The Forge-Mistress said you'd come. The failures always return."])
    say(lines_for(:barricade_illusion))
    sayc([with_or_is?(:alberica) ? as(:alberica, "That's the Dale. Our Dale. Outside the Wall.") : "That's the Dale. Outside the Wall.",
          cl(:meat_meat, "Failures. Meat Meat has been called worse. By better."),
          cl(:reptin, "That's the spirit.")])
    state[:goal] = "Get through the Barricade. The duergar have words they say at the gate."
  end

  def barricade_gate(event_id = nil)
    return say(["The gate stands open. Heat rolls through it."], event_id) if flag?(:barricade_passed)
    say(["A gate of root and iron, with a grille at head height. Behind the grille, eyes.",
         "VOICE BEHIND THE GATE: Words."], event_id)
    opts = [_INTL("\"Rimebound. Rise unbroken.\""), _INTL("\"Let us through.\""), _INTL("Say nothing")]
    c = pbMessage(_INTL("The voice behind the gate waits."), opts, 2)
    if c != 0
      return say(["VOICE BEHIND THE GATE: Wrong. Go and burn somewhere else."])
    end
    if !flag?(:read_ledger)
      say(["(You say it the way the duergar say it, flat and tired.)",
           "(You're not sure where you heard it. It works anyway.)"])
    end
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
    sayc(["THREDRA: (from the glass, very small) My, my. The children come back to mother's kitchen.",
          herald?(:alberica) ? "(You're dead. We were there.)" : (with_or_is?(:alberica) ? "ALBERICA: You're dead. We were there." : "You're dead."),
          "THREDRA: I'm remembered, dearie. Mirrors always remember.",
          "THREDRA: And she took my kitchen. My mirrors, my stones, my lovely root.",
          "THREDRA: She uses my glass to wear people like coats.",
          cl(:reptin, "(under his breath) Says the woman who kept a pantry of children."),
          "THREDRA: Burn her forge, dearies, and I'll whisper you a secret."])
    mspot = stage_spot(stage_event(event_id))
    c = pbMessage(_INTL("Thredra's mirror..."), [_INTL("\"Tell us.\""), _INTL("Break the mirror")], 0)
    if c == 0
      say(["THREDRA: The heart in her engine isn't hers. The body she wears isn't hers.",
           "THREDRA: Break the heart, and the coat falls off."])
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
    if herald?(:meat_meat)
      speak(:meat_meat, "Meat Meat is not a method.", "...Not a method.")
      sayc([with_or_is?(:reptin) ? "REPTIN: (kneeling beside you) No. You're not." : nil,
            with_or_is?(:alberica) ? "Alberica doesn't make a joke. She just holds out her arm, and you lean into it." : nil])
    else
      sayc(["MEAT MEAT: (after a long time) Meat Meat is not a method.",
            with_or_is?(:reptin) ? as(:reptin, "(kneeling beside her) No. You're not.") : nil,
            herald?(:alberica) ? "You don't make a joke. You just hold out your arm, and Meat Meat leans into it." :
              (with_or_is?(:alberica) ? "Alberica doesn't make a joke. She just holds out her arm, and Meat Meat leans into it." : nil)])
    end
    set_flag(:mm_origin_seen)
  end

  def selrae_cocoon(event_id = nil)
    return say(["An empty cocoon, cut open, the amber still soft at the edges."], event_id) if flag?(:selrae_rescued) || !flag?(:selrae_ahead)
    say(["In the last cocoon: the Winter Matron, half-frozen in amber. Her eyes are open.",
         "You cut her free."], event_id)
    sayc(["SELRAE: ...Thank you. I'll be quieter about my opinions from now on.",
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
  def scene_autumn_falls
    return if flag?(:autumn_fell)
    say(["Darrus Fell, his velvet scorched, drags a cocoon toward the forge. Inside it, a child's face.",
         "DARRUS: Stand aside! The engine needs one more. One more, and it never stops.",
         "DARRUS: Eternal summer! No famine years, no winters, ever.",
         "DARRUS: Do you know what Autumn's ledgers could do with that?"])
    if with_or_is?(:meat_meat)
      speak(:meat_meat, "That is a child.", "...Put the child down.")
    end
    say(["DARRUS: It's fuel."])
    if herald?(:meat_meat)
      say(["You move faster than anyone has ever seen you move.", "A blade of pure thought flashes in your hand.",
           "Darrus stumbles back, lets go of the cocoon, and goes over the rail.",
           "He catches the edge. Below him, the sap boils.",
           "DARRUS: (clinging) Help me. Goblin. Help me."])
      c = pbMessage(_INTL("Darrus is hanging from the edge. The child's cocoon is rolling toward the pit."),
                    [_INTL("Take the child"), _INTL("Reach for Darrus")], 0)
      if c == 1
        say(["You reach for him. His hand finds yours.",
             "Then the bridge shakes, and his hand slides out of yours like water.",
             "He falls."])
        set_flag(:mm_reached)
      else
        say(["You look at him for a long moment. Then you pick up the cocoon instead.",
             "He falls."])
        set_flag(:mm_turned)
      end
    else
      say(["Meat Meat moves faster than anyone has ever seen her move.", "A blade of pure thought flashes in her hand.",
           "Darrus stumbles back, lets go of the cocoon, and goes over the rail.",
           "He catches the edge. Below him, the sap boils.",
           "DARRUS: (clinging) Help me. Goblin. Help me.",
           "Meat Meat looks at him for a long moment. Then she picks up the cocoon instead.",
           "He falls."])
      set_flag(:mm_turned)
    end
    sayc([cl(:alerion, "(after a beat) ...We'll talk about that later."),
          herald?(:meat_meat) ? "(Holding the child: Yes.)" : "MEAT MEAT: (holding the child) Yes.",
          cl(:wyn, "(very quietly) ...Is the little one breathing?")])
    set_flag(:autumn_fell)
    set_flag(:child_saved)
    ($game_switches[SW_AUTUMN_FELL] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    say(["The child in the cocoon is breathing. Somebody will have to carry them up.",
         herald?(:meat_meat) ? "You don't let anybody else." : "Meat Meat doesn't let anybody else."])
  end

  #-----------------------------------------------------------------------------
  # SC 8.05 - The Dragonforge
  #-----------------------------------------------------------------------------
  def scene_dragonforge
    return if flag?(:forge_seen)
    set_flag(:forge_seen)
    dragon = stage_event("Chardalyn dragon")
    heart = dragon ? Stage.fx("E-14", [dragon.x, dragon.y], oy: 40, loop_from: 0) : nil   # the stolen heart, beating
    sayc(["A cavern ringed by twenty standing stones.",
          "Chained among them, on a cradle of iron and root: a dragon of black crystal and mirror glass.", "Its eyes are dark.",
          "Above it hangs the engine, a cage of chardalyn and roots.",
          "In its heart burns a sliver of blue frost-light, wrapped in Hyphora's gold sap.", "Blue at the edges. Red at the core.",
          as(:wyn, "(stricken) That's her sap. That's Hyphora's blood."),
          cl(:alerion, "And that's his heart. Sephek's."),
          cl(:glimmer, "(the Rimefang shaking in his hand) ...Brightmane said I'd know the fire when I saw it.")])
    Stage.stop_fx(heart)
    Stage.cleanup rescue nil
    state[:goal] = "Through the forge's keepers, to the engine."
  end

  def devil_priest(event_id = nil)
    return say(lines_for(:devil_priest_after), event_id) if flag?(:forge_reached)
    sayc(["A barbed devil in priest's robes turns from the stones, smiling with too many teeth.",
          cl(:alberica, "Ooh. Lovely smile. Too many teeth, but lovely.")], event_id)
    return if !trainer(:devil_priest, event_id)
    set_flag(:forge_reached)
    ($game_switches[SW_FORGE_CLEARED] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    say(["VEXMORTIS: Go on. She's waiting. She's always waiting. That's the worst of her.",
         "Behind him, a stair of black glass winds up into the engine's heart."])
    state[:goal] = "The Heart Chamber. The engine."
  end

  #-----------------------------------------------------------------------------
  # SC 8.06 - Summer; 8.07 - A better fire; 8.08 - The coat falls off
  #-----------------------------------------------------------------------------
  def scene_heart_chamber
    return if flag?(:engine_dead)
    say(["A big, scarred man in the Summer Marshal's gold stands at the engine's controls, his back to you.",
         "KELYN: (over a sending-stone) Var? Var, thank the seasons...",
         "He turns. His face is Var's. His eyes are red-gold, and they don't blink.",
         "VAR: (a woman's voice, amused) Variables that refused to die. Hello again, my little failures.",
         "The face cracks like a mirror.", "Behind the cracks: white hair, infernal sigils, a smile like arithmetic.",
         "AVARICE: Thirty years I've worn this man. Thirty years of summer.",
         "AVARICE: A season that never ends has a god's worth of power in it. Mine.",
         "AVARICE: The Frostmaiden wants the world still. I want it running. On my schedule. Forever."])
    if with_or_is?(:meat_meat)
      speak(:meat_meat, "You took Razzy's voice.", "...You.")
    end
    sayc(["AVARICE: I took a great deal more than that, V-7. Come here and I'll show you.",
          herald?(:meat_meat) ? cl(:reptin, "(stepping in front of you) She's not going anywhere near you.") :
                                cl(:reptin, "(stepping in front of Meat Meat) She's not going anywhere near you.")])
    if flag?(:took_hag_secret)
      say(["(The hag's whisper: the heart in her engine isn't hers.)",
           "(You can see it now, under the gold: a seam of blue frost-light where the coat is stitched on.)"])
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
      won = pbTrainerBattle(type, name, nil, false, 0, i == 0) ? true : false
      $ft_avarice_weak = false
      break if won
    end
    return if !won
    scene_better_fire
  end

  def scene_better_fire
    say(["Avarice staggers, laughing. Behind her, the engine screams.",
         "Blue frost-light and red fire twist together.", "It's going to burst, and take the tree's heart with it.",
         "AVARICE: Kill me and it blows. Leave me and it runs forever. Your move.",
         "Glimmer steps past her.",
         "GLIMMER: This blade's been killing me slowly since Saltmarsh.",
         "GLIMMER: Brightmane said the curse breaks in a sacred fire.",
         "He lifts the Rimefang.",
         "GLIMMER: I am a sacred fire. Brightmane made me one."])
    if with_or_is?(:alberica)
      speak(:alberica, "Glimmer. Sweetheart. Don't you dare.", "...Glimmer.")
    end
    sayc(["GLIMMER: It's all right. Shimmer found the third way. I'm only following her.",
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
    scene_coat_falls
  end

  def scene_coat_falls
    sayc(["With the engine dead, Var's body cracks all over, like ice on a lake.",
          "Avarice looks down at her hands.",
          "AVARICE: (almost admiring) Oh. That was clever.",
          "She steps backward into a shard of the hag's old mirror. She's half gone before anyone can move.",
          "AVARICE: We'll speak again in the White Womb, little failures. Mind the dragon."])
    var = stage_event("Var Rime-Breaker")
    Stage.fx("E-06", stage_spot(var, 0, -2), frames: 10, oy: 32)   # the mirror shatters behind her
    sayc(["The mirror shatters. Var Rime-Breaker's body falls, empty, and turns to glass.",
          cl(:alberica, "(very plainly) She doesn't get away. Not from us. Not after this.")])
    set_flag(:avarice_fled)
    set_flag(:summer_dead)
    add_counter(:story_beats)
    scene_launch
  end

  #-----------------------------------------------------------------------------
  # SC 8.09 - Launch
  #-----------------------------------------------------------------------------
  def scene_launch
    pbSEPlay("Earth3") rescue nil
    $game_screen.start_shake(6, 8, 40) rescue nil
    sayc(["Below, among the Twenty Stones, the black dragon's eyes light up, gold.",
          "It doesn't need the engine. It was always meant to fly on its own.",
          "It tears free of its chains, roars, and smashes straight up through the roots, toward the sky.",
          herald?(:meat_meat) ? "(You scream it before you know you're going to: RAZZY!)" : "MEAT MEAT: RAZZY!",
          cl(:alerion, "(already running) Frostina."),
          "Far above, two dragons are already diving."])
    set_flag(:dragon_launched)
    add_counter(:story_beats)
    say(["END OF CHAPTER 8"]) rescue nil
    state[:goal] = "Up. Back to the market. The dragon is loose."
    return chapter9_start if respond_to?(:chapter9_start)
    transfer(2050, 31, 28, 2)
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
    if $ft_avarice_weak && trainer && trainer.name == "Avarice" && trainer.party && !trainer.party.empty?
      ace = trainer.party.last
      ace.hp = [(ace.totalhp * 0.55).floor, 1].max
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
