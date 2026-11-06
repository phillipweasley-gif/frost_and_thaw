#===============================================================================
# Frost & Thaw - Act II, Chapter 7, Road A: the Heartroot (script SC 7A.01-7A.07)
#
# Reach the tree's heart from below, through the people who tend it. Wyn leads.
# Either road can come first; lines change when Road B is already done.
#
#   7A.01 The Sap Gate: Eira Shadebloom, "Declare your purpose."
#   7A.02 Yarro's blight in the Spore Gardens (a Fire move burns it clean).
#   7A.03 Gym 7: Sovereign Luminara, the Rapport Seal (team scales with badges).
#   7A.04 The Mnemosyne, Myr: Hyphora's name, the thread that binds.
#   7A.05 The Tainted Lake (2069): Sephek's heart echoes in the water; the lake
#         monster; Reptin calls rain from the roots; the fossil seed of Balanus.
#   7A.06 Mycolith's Hollow (2070): the door of the Five Domains, and the Shadow
#         Mycolith, a dead god's grief. Its godspark settles on Wyn.
#   7A.07 The Root Chapel (2071): Hyphora opens her roots to the burning place.
#
# Also here: the badge-scaled gym teams for Gyms 5-7 (Hew, Mira, Luminara),
# whose roads can be taken in either order.
#===============================================================================
module FrostThaw
  SW_LAKE_DOWN    = 3967   # the Tainted Lake's monster is beaten: the shore path is clear
  SW_DOMAINS_OPEN = 3968   # the five carvings are touched: the Hollow's door is open
  SW_MYCOLITH     = 3969   # the Shadow Mycolith has fallen: the way to the Root Chapel
  SW_HYPHORA      = 3970   # Hyphora has opened her roots (road A done)
  SW_FORGE_OPEN   = 3981   # both roads are done: the door of iron and glass opens on to the Rootsun Forge
  SW_LAKE_OPEN    = 3971   # the Sovereign has tasted you and Myr has named Hyphora: the tunnel to the lake

  MAPS.merge!(tainted_lake: 2069, mycolith_hollow: 2070, root_chapel: 2071)
  MAP_NAMES.merge!(2069 => "The Tainted Lake", 2070 => "Mycolith's Hollow", 2071 => "The Root Chapel")
  MAP_METADATA.merge!(
    2069 => { announce_location: true, battle_environment: :Cave },
    2070 => { announce_location: true, battle_environment: :Cave },
    2071 => { announce_location: true, battle_environment: :Cave }
  )
  AREAS.merge!(2069 => :undercanopy, 2070 => :undercanopy, 2071 => :root_chapel)

  ENCOUNTERS[2069] = { step_chances: { Cave: 8 },
                       Cave: [[25, :GOLBAT, 41, 43], [20, :TENTACOOL, 40, 42], [15, :GLOOM, 41, 43],
                              [15, :PARASECT, 41, 43], [15, :QUAGSIRE, 41, 43], [10, :GLOAMCAP, 42, 44]] }
  ENCOUNTERS[2070] = { step_chances: { Cave: 6 },
                       Cave: [[30, :HAUNTER, 42, 44], [25, :PARASECT, 42, 44], [20, :MISDREAVUS, 42, 44],
                              [15, :SABLEYE, 42, 44], [10, :GLOAMCAP, 43, 45]] }

  LAKE_ARRIVAL   = [2069, 4, 4, 2]
  HOLLOW_ARRIVAL = [2070, 4, 21, 6]
  CHAPEL_ARRIVAL = [2071, 9, 12, 8]
  SAP_GATE_TOP   = [2055, 9, 21, 2]     # beside the Sap Gate, in the Root-Tier

  # The five domains on the Hollow's door: [carving, Herald, domain]
  DOMAINS = [[:mask, :alerion, "Illusion"], [:fist, :meat_meat, "Force"], [:hourglass, :alberica, "Time"],
             [:paw, :reptin, "Wild"], [:shadow, :wyn, "Shadow"]]

  # Kelyn's sending-stone, given at the Council's summons (024 council_summons;
  # context 08 M8-1). Defined here because the item table (027) loads after 024.
  RELIC_ITEMS.merge!(
    FT_SENDSTONE: ["Sending-Stone", "Sending-Stones", 8, 0,
      "A flat grey stone, Kelyn's. Its twin is Var's. Speak into it and the other one hears.", 0, 0, 6]
  )

  TEXT.merge!(
    tainted_lake_sign: ["The water shines like oil on a puddle. Where it laps the stone, the stone has gone soft."],
    hollow_door_open: ["The door of the Five Domains stands open. Cold breathes out of it."],
    chapel_light: -> {
      flag?(:hyphora_leave) ? ["The roots glow amber, slow as breathing.", "Somewhere far above, something very young is asleep, and not afraid."] :
                              ["The roots glow amber. Something enormous and very young is looking at you through them."]
    },
    hollow_door_shut: ["A sealed door of black shelf-fungus, hard as stone.",
                       "Above it, five carvings: a mask, a fist, an hourglass, a paw, a shadow."],
    hollow_roots_shut: ["Roots, braided shut. Beyond them, very faint, an amber light.",
                        "The thing on the platform is between you and it."],
    undercanopy_water: -> {
      flag?(:lake_cleansed) ? ["The water's clearing, even up here. Pale sprouts are poking up along the shore."] :
                              ["The water here has a sheen on it, like oil.",
                               "It drains away east, past the Fane, down a root-tunnel that smells of rot."]
    },
    forge_door_glass: ["A door of iron and mirror glass, fused into the living root.",
                       "In the glass: your own face, and behind it, firelight that isn't in this room."]
  )

  # One line from each Herald as their own domain lights (SC 7A.06).
  DOMAIN_QUIPS = { alerion: "Illusion. ...Fine.", meat_meat: "Force. Obviously.",
                   alberica: "Time. Darling, I'm always late.", reptin: "Wild. Not one word, any of you.",
                   wyn: "...Shadow. Oh." }
  HERALD_THEIR = { alerion: "his", meat_meat: "her", alberica: "her", reptin: "his", wyn: "their" }

  module_function

  #-----------------------------------------------------------------------------
  # Badge-scaled gym teams (Gyms 5-7 can be fought in any order). Version 0 is
  # the team as written for four badges; each badge beyond that adds 3 levels,
  # and at version 2 the leader brings the extra Pokémon listed in SCALED_EXTRA.
  #-----------------------------------------------------------------------------
  SCALED_EXTRA = {}

  def scaled_version
    [[badges_held - 4, 0].max, 2].min
  end

  def register_scaled(key)
    type, name, party, lose_text, items = TRAINERS[key]
    (0..2).each do |v|
      mons = party.map { |sp, lv, moves| h = { species: sp, level: lv + 3 * v }; h[:moves] = moves if moves; h }
      if v == 2 && SCALED_EXTRA[key]
        sp, lv = SCALED_EXTRA[key]
        mons.insert([mons.size - 1, 0].max, { species: sp, level: lv + 6 })
      end
      hash = { id: [type, name, v], id_number: 9700 + (TRAINERS.keys.index(key) || 0) * 3 + v, trainer_type: type, name: name, version: v,
               items: items || [], lose_text: lose_text, pokemon: mons }
      GameData::Trainer::DATA[[type, name, v]] = GameData::Trainer.new(hash)
    end
  end

  def scaled_leader_battle(key)
    register_scaled(key)
    type, name = TRAINERS[key]
    pbTrainerBattle(type, name, nil, false, scaled_version) ? true : false
  rescue StandardError => e
    log("scaled_leader_battle(#{key}) failed: #{e.message}")
    false
  end

  #-----------------------------------------------------------------------------
  # SC 7A.01 - Declare your purpose
  #-----------------------------------------------------------------------------
  def sap_gate(event_id = nil)
    return say(["The Sap Gate stands open. Warm, spore-sweet air drifts up from below."], event_id) if flag?(:sap_gate_open)
    return talk(:sap_gate_shut, event_id) if !flag?(:ch7_started)
    # Context 07 M7-1 read-back: Hew's road came first.
    if flag?(:hew_down)
      sayc([as(:wyn, flag?(:road_first_b) ? "You let Hew go first. ...That's fair. His people are louder than mine." :
                                              "Hew's ladder first after all. ...That's fair. His people are louder than mine.")], event_id)
    end
    # Context 07 M7-2: what the Gate is, and the night the curtain tore.
    if herald?(:wyn)
      say(["Your post. Your Gate. The bench where you sat every night for three years.",
           "The place on the root you wore smooth with your thumb.",
           "The knot of bark where the old mirror shard sat is empty. It's in your pocket.",
           as(:wyn, "It brought me back. It took four hundred years and a hag to do it."),
           "At the Gate's foot the spore-curtain hangs torn and grey. Boot-prints go down through it."], event_id)
      speak(:wyn, "(to the Gate) I'm back. I'm sorry I was gone.", "...")
    else
      say(["WYN: My post. I sat here every night for three years.",
           "WYN: (to you) The Sap Gate. It's the myconids' door, and theirs is the door to the deep.",
           "WYN: The Underdark. Everything under the tree that isn't the tree. We keep it shut.",
           "At the Gate's foot the spore-curtain hangs torn and grey. Boot-prints go down through it.",
           "WYN: Festival night the spores went quiet. I ran up to tell the Captain.",
           "WYN: I left it open behind me. Somebody went down while I was gone.",
           "WYN: (a hand on the root) ...The one night it mattered, I wasn't here."], event_id)
    end
    sayc([cl(:alberica, "You're here now, sweetheart. That counts double.")])
    stage_act(:wyn, :reach, dx: 0, dy: -1, dir: 8)    # a hand on the root, the knot
    if herald?(:wyn)
      say(["You know the knot that opens it. You were never supposed to use it.",
           "The Gate unknots itself, slowly, with a sound like a sigh."])
    else
      say(["Wyn finds a knot in the root with their thumb, the way you'd find a lamp in the dark.",
           "The Gate unknots itself, slowly, with a sound like a sigh."])
    end
    Stage.cleanup rescue nil
    set_flag(:sap_gate_open)
    ($game_switches[SW_SAP_GATE] = true; $game_map.need_refresh = true if $game_map) if $game_switches
  end

  def scene_undercanopy_enter
    return if flag?(:undercanopy_entered)
    set_flag(:undercanopy_entered)
    add_counter(:story_beats)
    say(["Fungal beds glow green, blue and amber. The ceiling rises and falls, like breathing.",
         "A myconid with a violet-veined cap steps into the tunnel. Its spear is tipped with mirror-glass.",
         "Its voice arrives inside your head, like a cold creek running over stones.",
         "EIRA: Halt. Declare your purpose."])
    speak(:wyn, "They're with me, Eira. The roots are burning.", "...The roots are burning.")
    say([herald?(:wyn) ? "EIRA: You left your post. The night the curtain tore. The tree noticed." :
                         "EIRA: (to Wyn) You left your post. The night the curtain tore. The tree noticed."])
    speak(:wyn, "I know. I'm here to answer for it.", "...I know.")
    sayc([cl(:reptin, "(gently) And we're here to stand next to them while they do."),
          cl(:meat_meat, "Anyone pokes mushroom friend with a spear, Meat Meat pokes back."),
          "EIRA: ...Pass. Touch nothing that sings.",
          cl(:alberica, "Touch nothing that sings. Well. There goes my evening."),
          cl(:alerion, "You could not sing."),
          cl(:alberica, "Pretty boy, I could not breathe, either. Neither's happening.")])
    state[:goal] = "The Spore Gardens: Yarro's blight. Then the Sovereign, in the Fane."
  end

  def eira(event_id = nil)
    if flag?(:blight_cleared) && flag?(:badge_undercanopy) && (!(flag?(:eira_lore) && flag?(:eira_patrols) && (flag?(:spore_guard) || !with_or_is?(:wyn))) ||
                                                         (flag?(:missing_patrol_found) && flag?(:eira_patrols) && !flag?(:eira_patrols_reported)))
      return eira_development(event_id)
    end
    if flag?(:hyphora_leave)
      return say(["EIRA: The tree breathes. The spore-guard owes you. We don't forget a debt."], event_id)
    end
    say(["EIRA: The Sovereign holds court in the Fane, east, past the water.",
         "EIRA: The Mnemosyne keeps to her chamber above the gardens.",
         "EIRA: Touch nothing that sings."], event_id)
  end

  #-----------------------------------------------------------------------------
  # SC 7A.02 - Yarro's blight
  #-----------------------------------------------------------------------------
  def yarro_blight(event_id = nil)
    if flag?(:blight_cleared)
      return yarro_tincture(event_id) if flag?(:spores_debated) && !flag?(:colony_recognised) && !flag?(:colony_exiled)
      return yarro_errand(event_id) if flag?(:hyphora_named) && flag?(:badge_undercanopy) && !flag?(:yarro_errand_done)
      if flag?(:blight_cleansed)
        return say(["Where the black-red caps were, the beds glow a healthy amber. The sap under them beats steady."], event_id)
      end
      return say(["Where the black-red caps were, new vermilion ones are pushing up through the ash.", "They're tiny, and bright."], event_id)
    end
    sayc(["Glowing fungal beds, and in the middle of them a spreading patch of black-red caps.",
          "The air above them shimmers with heat.",
          "YARRO: (a voice like warm rain) They grow where the roots run hot.",
          "YARRO: Something below is cooking them. Cooking her.",
          cl(:reptin, "Her? Forgive me. Who's 'her'?"),
          "YARRO: We don't say her name to people we've just met.",
          cl(:alberica, "Then buy us a drink first, sugar. That's how it works upstairs.")], event_id)
    # R1, Verdant Sickness: Rheven comes down, and asks Reptin to cleanse it or cut it out.
    if with_or_is?(:reptin)
      r = verdant_sickness_ritual
      return if r == false
      if r == true
        set_flag(:blight_cleared)
        set_flag(:blight_cleansed)
        set_flag(:yarro_witness)
        set_flag(:verdant_sickness)
        add_counter(:story_beats)
        set_switch(SW_RHEVEN_BLIGHT, false)
        sayc([cl(:wyn, "(to the root, very softly) There. You can breathe now."),
              "RHEVEN: I owe you a drink, Reptin. Several. Come up to the Root-Tier when this is done.",
              "YARRO: Mended, not burned. The gardens will remember you. So will I, if anyone asks.",
              "YARRO: Take a lantern-puff. Squeeze it and it glows. Carry it and the dark leaves you be."])
        give(:FT_SPORELANTERN)
        say(["(The Luminescent Lantern: while you carry it, half as many wild Pokémon find you in caves.)"])
        state[:goal] = "The Fane, east past the water: Sovereign Luminara."
        return
      end
      say(["RHEVEN: Cut it, then. Cleanly. I'll hold the lamp."])
    end
    fire = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? && pk.moves.any? { |m| m && (GameData::Move.get(m.id).type == :FIRE rescue false) } }
    if fire
      return if !pbConfirmMessage(_INTL("Have {1} burn the blight, and nothing else?", fire.name))
      say(["#{fire.name} breathes a careful line of fire across the black caps, and not a hair further.",
           "They curl, crackle, and go to ash."])
    elsif with_or_is?(:glimmer)
      return if !pbConfirmMessage(_INTL("None of your Pokémon knows a Fire move. Ask Glimmer?"))
      sayc(["GLIMMER: Let me. Brightmane says I'm a fire now. Let's find out if she's right.",
            "The Lumen Shard in his chest flares. He draws one finger through the air over the black caps.",
            "They curl and go to ash. The healthy beds don't even get warm.",
            cl(:meat_meat, "Cat is a lighter now. Useful cat.")])
    else
      return say(["It needs fire, and a careful one. None of your Pokémon knows a Fire-type move right now."])
    end
    set_flag(:blight_cleared)
    set_flag(:blight_burned)
    set_flag(:yarro_witness)
    add_counter(:story_beats)
    set_switch(SW_RHEVEN_BLIGHT, false) rescue nil
    sayc([cl(:wyn, "(to the ash, very softly) There. You can grow back now."),
          "YARRO: Gently done. The gardens will remember you. So will I, if anyone asks.",
          "YARRO: Take a lantern-puff. Squeeze it and it glows. Carry it and the dark leaves you be."])
    give(:FT_SPORELANTERN)
    say(["(The Luminescent Lantern: while you carry it, half as many wild Pokémon find you in caves.)"])
    state[:goal] = "The Fane, east past the water: Sovereign Luminara."
  end

  #-----------------------------------------------------------------------------
  # SC 7A.03 - Gym 7: Sovereign Luminara
  #-----------------------------------------------------------------------------
  def leader_luminara(event_id = nil)
    if flag?(:badge_undercanopy)
      return luminara_blessing(event_id) if flag?(:spores_debated) && !flag?(:colony_recognised) && !flag?(:colony_exiled)
      # Q6's lead: the summer's memory, asked for in its own audience during the trial week
      if flag?(:trials_open) && !flag?(:ch10_done) && !flag?(:memory_bubble) && !flag?(:colony_exiled) &&
         pbConfirmMessage(_INTL("Ask Luminara for the memory of the summer's work in the roots?"))
        return luminara_bubble(event_id)
      end
      return if respond_to?(:luminara_gifts) && luminara_gifts
      if flag?(:mycolith_down)
        return say(["LUMINARA: The lake is clean. The god is still. Now we help you, surface-friend. Ask."], event_id)
      end
      if flag?(:hyphora_named)
        return say(["LUMINARA: Tasted. Honest. But the lake still stinks of him.",
                    "LUMINARA: Clean the water, and the Undercanopy will stand with you. Not before."], event_id)
      end
      return say(["LUMINARA: Tasted. Honest. Go to the Mnemosyne, if you haven't.",
                  "LUMINARA: She decides who may hear the name."], event_id)
    end
    if !flag?(:blight_cleared)
      return say(["A myconid taller than the rest sits on the root-throne of the Fane.", "Her cap glows like stained glass.",
                  "LUMINARA: (wind through reeds) Surface. Sap-takers. Root-burners.",
                  "LUMINARA: My gardener's beds are burning, and you come asking, asking.",
                  "LUMINARA: Help Yarro. Then ask."], event_id)
    end
    say(["LUMINARA: (wind through reeds) Surface. Sap-takers. Root-burners.",
         "LUMINARA: You come asking, asking. What do you bring?"], event_id)
    if with_or_is?(:reptin)
      speak(:reptin, "Good manners, Sovereign. And your gardener's beds, mended. And a fight, if you'd like one.",
            "Your gardener's beds. Mended.")
    else
      say(["You brought back her gardener's beds."])
    end
    sayc([cl(:glimmer, "And a little light. I'm told I'm good for that now."),
          "LUMINARA: Then share spores with us. Battle is how we taste a stranger.",
          cl(:meat_meat, "Meat Meat will not be tasted. Meat Meat does the tasting."),
          cl(:reptin, "(under his breath) What she means is, thank you for having us.")])
    return if !scaled_leader_battle(:luminara)
    $Trainer.badges[6] = true
    set_flag(:badge_undercanopy)
    set_flag(:badge_luminara)
    ($game_switches[SW_UNDER_BADGE] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    set_switch(SW_LAKE_OPEN, true) if flag?(:hyphora_named)
    (apply_undercanopy_switches; $game_map.need_refresh = true if $game_map) if respond_to?(:apply_undercanopy_switches)
    add_counter(:story_beats)
    say(["LUMINARA: Tasted. Honest. The Rapport Seal."])
    pbMessage(_INTL("\\me[Badge get]{1} received the Rapport Seal!", $Trainer.name))
    give(:TM53)
    sayc(["LUMINARA: Energy Ball. Light, gathered by green things, thrown hard.",
          "LUMINARA: Go to the Mnemosyne. She will decide if you may hear the name.",
          cl(:wyn, "(barely out loud) She said honest. She never says honest.")])
    state[:goal] = flag?(:hyphora_named) ? "The water past the Fane: the lake remembers." : "The Mnemosyne, above the gardens."
  end

  #-----------------------------------------------------------------------------
  # SC 7A.04 - The thread that binds
  #-----------------------------------------------------------------------------
  def myr(event_id = nil)
    if flag?(:hyphora_named)
      return myr_after(event_id) if respond_to?(:myr_after)
      return say(["MYR: (many voices at once, slow as roots) Hyphora is afraid. Go down to the water. Go carefully."], event_id)
    end
    sayc(["An ancient myconid, layered like old bark, sits in a ring of stone tablets.",
          "MYR: (many voices at once) I remember the first logger. I remember the sapling.",
          "MYR: I remember the night the seed drank four hundred years.",
          herald?(:reptin) ? "MYR: (to you) You carried the seed." : (with_or_is?(:reptin) ? "MYR: (to Reptin) You carried the seed." : "MYR: One of you carried the seed."),
          cl(:reptin, "A golden acorn, from a priest in Bryn Shander. I did ask nicely."),
          "MYR: A seed of Erato, who was a seed of Balanus.",
          "MYR: And Balanus was the World Tree, before the Frostmaiden cut it down.",
          cl(:alberica, "...That's a lot of grandmothers for one acorn."),
          "MYR: You planted a god, warden. Swear to protect it, and I will tell you its name."], event_id)
    c = pbMessage(_INTL("Swear to protect the tree?"),
                  [flag?(:wardens_sworn) ? _INTL("\"We already have.\"") : _INTL("\"We swear.\""), _INTL("\"What happens if we don't?\"")], 0)
    if c == 1
      sayc(["MYR: Then you'll protect something you can't call by name. That's harder.",
            "A long pause. The tablets around her hum.",
            cl(:alerion, "We'll do it anyway.")])
    end
    set_flag(:hyphora_sworn)
    sayc(["MYR: Hyphora. It means the thread that binds.",
          cl(:wyn, "(very quietly) Hyphora. ...Hello."),
          "MYR: And Hyphora is afraid. Something under her burns hotter every night.",
          "MYR: It drinks her sap. It has carved her old roots into a machine.",
          "MYR: Past the Fane the water has gone bad. Go down that way.", "MYR: The lake remembers things it shouldn't."])
    set_flag(:hyphora_named)
    add_counter(:story_beats)
    set_switch(SW_LAKE_OPEN, true) if flag?(:badge_undercanopy)
    (apply_undercanopy_switches; $game_map.need_refresh = true if $game_map) if respond_to?(:apply_undercanopy_switches)
    state[:goal] = flag?(:badge_undercanopy) ? "The water past the Fane: the lake remembers." : "The Fane: Sovereign Luminara. Then the water beyond."
  end

  # The root-tunnel down from the Fane's far side to the lake.
  def lake_tunnel(event_id = nil)
    if !flag?(:hyphora_named) || !flag?(:badge_undercanopy)
      say(["A root-tunnel slopes down into the dark. The air coming up it smells of rot and warm metal.",
           "EIRA: (from somewhere behind you) Not that way. Not yet.",
           "EIRA: Not until the Sovereign has tasted you and the Mnemosyne has named you."], event_id)
      pbMoveRoute($game_player, [PBMoveRoute::Backward]) rescue nil
      return
    end
    transfer(*LAKE_ARRIVAL)
  end

  #-----------------------------------------------------------------------------
  # SC 7A.05 - The lake remembers
  #-----------------------------------------------------------------------------
  def scene_tainted_lake
    return if flag?(:lake_entered)
    set_flag(:lake_entered)
    sayc(["An underground lake, iridescent with slime.",
          "A voice rises off the water: calm, charming, and very familiar.",
          "VOICE IN THE WATER: The lake remembers. The lake remembers.",
          cl(:glimmer, "(a hand on the dagger at his hip) The Rimefang's gone cold. It knows that voice."),
          cl(:alerion, "Sephek."),
          as(:wyn, "(a hand out to the spores) Not him. The spores taste it. His heart, burning."),
          as(:wyn, "The sap carries the echo up here."),
          cl(:meat_meat, "Meat Meat hates this lake. Meat Meat is not drinking this lake.")])
  end

  def lake_monster(event_id = nil)
    return say(["The water is still. Under it, something large has gone back to sleep."], event_id) if flag?(:lake_cleansed)
    sayc(["The slick on the water bulges. Something huge and pale rises out of it.",
          "Its gills flare. It's furious at the heat that woke it.",
          cl(:reptin, "It's not evil. It's scalded. Gently, if we can."),
          cl(:meat_meat, "Meat Meat can be gentle."),
          cl(:alberica, "Since when, sweetheart?"),
          cl(:meat_meat, "Since now. Watch.")], event_id)
    return if !boss_battle(named_mon(:B73H130, 45, "Scalded Lake-Wyrm"))
    ($game_switches[SW_LAKE_DOWN] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    say(["The creature sinks back under the slick, exhausted. The water still stinks of rot and heat."])
    lake_purification
    stage_act(with_or_is?(:reptin) ? :reptin : :wyn, :kneel, dx: 0, dy: -1, dir: 8)   # a hand flat on the root
    if herald?(:reptin)
      say(["You kneel at the edge and lay your hand flat on the root that runs under the water."])
      speak(:reptin, "(to the root) Excuse me. Could we trouble you for a little rain?", "(to the root) ...Please.")
      say(["You ask. The tree answers."])
    elsif with_or_is?(:reptin)
      say(["Reptin kneels at the edge and lays his hand flat on the root that runs under the water.",
           "REPTIN: (softly, to the root) Excuse me. Could we trouble you for a little rain?",
           "He asks. The tree answers."])
    else
      say(["Wyn kneels and lays a hand flat on a root. The tree answers."])
    end
    pbSEPlay("Rain") rescue nil
    sayc(["Rain falls from the roots overhead: clean water, cold, pattering on the lake.",
          "The slick breaks up, drifts apart, and is gone.",
          "The lake goes clear. At the bottom, something round and stony glints.",
          with_or_is?(:reptin) ? cl(:alberica, "Reptin, darling, you have to teach me that. For baths.") :
                                 cl(:alberica, "Wyn, sweetheart, you have to teach me that. For baths.")])
    Stage.cleanup rescue nil
    set_flag(:lake_cleansed)
    set_flag(:lake_clean)
    ($game_switches[SW_LAKE_CLEAN] = true) if $game_switches
    add_counter(:story_beats)
    grant_blessing(:hyphora, "Hyphora's Blessing", "Wild Grass- and Bug-type Pokémon are now easier to catch.")
    give_key(:FT_BALANUSSEED)
    say(["(A fossilised seed, heavy as a stone. Cornipus on the Canopy-Tier would know what it is.)"])
    state[:goal] = "On, past the lake. Something down there wouldn't let go."
  end

  # H4 (Tab 5): Yarro's purification ritual, before the rain: "channeling
  # magic, DC 13 Medicine checks to mix herbs, fending off lingering pseudopods".
  def lake_purification
    return if flag?(:lake_ritual_done)
    yarro = flag?(:yarro_errand_done)
    say([yarro ? "Yarro comes padding down the root-tunnel with his jars, humming. He heard the lake's story; he knows the end of it." :
                 "Yarro comes padding down the root-tunnel with his jars, out of breath. \"The lake! Don't let it scar!\"",
         "YARRO: Herbs first. Then the tree's rain. Then it sleeps clean. Keep the slick off me."])
    good = 0
    good += 1 if challenge("Mix the herbs.", [yarro ? "Moss, sap and the lake's own clean silt, the way the sample said" : "Moss and warm sap, packed close",
                                              "Everything in the jars at once", "Snow, to cool it"], 0)
    good += 1 if challenge("Grind them.", ["Slowly, sunwise, while Yarro hums", "As fast as you can", "Let Meat Meat do it"], 0)
    say(["The slick bulges again: pseudopods, grey and blind, feeling along the shore for Yarro's jars."])
    if good < 2
      say(["The mixture smokes wrong. The slick smells it, and comes for it faster."])
      skirmish(named_mon(:B114H72, 45, "Spore-Lash Creeper"), named_mon(:B114H72, 45, "Spore-Lash Creeper"))
    else
      skirmish(named_mon(:B114H72, 45, "Spore-Lash Creeper"))
    end
    say(["YARRO: (tipping the jar into the water) Now. Ask her for the rain."])
    set_flag(:lake_ritual_done)
  end

  #-----------------------------------------------------------------------------
  # SC 7A.06 - The fallen god
  #-----------------------------------------------------------------------------
  def scene_mycolith_hollow
    return if flag?(:hollow_entered)
    set_flag(:hollow_entered)
    sayc(["A sealed door with five carvings: a mask, a fist, an hourglass, a paw, a shadow.",
          cl(:alerion, "Places like this always ask."),
          cl(:reptin, "Five carvings, five of us. I do love a door with a guest list.")])
  end

  def domain_carving(key, event_id = nil)
    carving, who, domain = DOMAINS.find { |c, _, _| c == key }
    return if !carving
    return say(["The #{carving} is warm now, and faintly lit."], event_id) if flag?(:"domain_#{carving}")
    name = COMPANION_NAMES[who].to_s.split.map(&:capitalize).join(" ")
    lines = if herald?(who)
              ["You put your hand on the #{carving}. #{domain}.",
               "It's yours. You know it the way you know your own name.",
               as(who, DOMAIN_QUIPS[who])]
            elsif with_or_is?(who)
              ["#{name} puts a hand on the #{carving}. #{domain}. It lights under #{HERALD_THEIR[who]} palm.",
               as(who, DOMAIN_QUIPS[who])]
            else
              partner = $Trainer.party.find { |pk| !pk.egg? }
              ["Nobody here holds #{domain}.",
               "#{partner ? partner.name : 'Your partner'} touches the #{carving} instead, and it lights anyway."]
            end
    if with_or_is?(who)
      ce = stage_event(event_id)
      dx, dy = ce ? [ce.x - $game_player.x, ce.y - $game_player.y + 1] : [0, -1]
      stage_act(who, :reach, dx: dx, dy: dy, dir: 8, per: 6)   # a hand on the carving
    end
    say(lines, event_id)
    Stage.cleanup rescue nil
    set_flag(:"domain_#{carving}")
    if DOMAINS.all? { |c, _, _| flag?(:"domain_#{c}") }
      pbSEPlay("Door exit") rescue nil
      say(["All five carvings glow at once.", "The door grinds open, and cold breathes out of it."])
      set_flag(:domains_open)
      ($game_switches[SW_DOMAINS_OPEN] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    end
  end

  def shadow_mycolith(event_id = nil)
    return say(["Where the monolith stood: black water, and a ring of tiny white caps along the edge."], event_id) if flag?(:mycolith_down)
    sayc(["Icy platforms over a black lake.", "On them, a shelf-fungus monolith with an auroral crack down its middle.",
          "It's breathing.",
          as(:wyn, "It's the old tree. What's left of Balanus's grief."),
          as(:wyn, "A god that died, and wouldn't let go."),
          cl(:alerion, "(very quietly) I know how that goes."),
          "SHADOW MYCOLITH: (roots of sound) STILL. STAY. STILL."], event_id)
    if !flag?(:mycolith_minions_1)
      return if !mycolith_minions(1)
      set_flag(:mycolith_minions_1)
    end
    return if !boss_battle(named_mon(:B47H439, 46, "Shadow Mycolith"))
    say(["The monolith splits along its crack.",
         "Something darker pours out of the gap, and stands up.",
         "SHADOW MYCOLITH: STILL! STAY! STILL!"])
    if !flag?(:mycolith_minions_2)
      return if !mycolith_minions(2)
      set_flag(:mycolith_minions_2)
    end
    # (Tab 6: "It does not heal to full": 165 -> 215, of 350.)
    enraged = named_mon(:B439H47, 48, "Mycolith, Enraged")
    enraged.hp = [(enraged.totalhp * 215 / 350.0).floor, 1].max
    return if !boss_battle(enraged)
    set_flag(:mycolith_down)
    ($game_switches[SW_MYCOLITH] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    stage_act(:wyn, :kneel, dx: 1, dy: 0, dir: 2)
    if herald?(:wyn)
      say(["When it falls, a spark of shadow rises from it like a moth, and settles on your hand."])
      speak(:wyn, "Oh. That's... mine now. Isn't it.", "...Oh.")
      say([as(:wyn, "A god's last spark. It doesn't want to hide any more. ...Neither do I.")])
    else
      say(["When it falls, a spark of shadow rises from it like a moth, and settles on Wyn's hand.",
           "WYN: (quiet) Oh. That's... mine now. Isn't it.",
           "WYN: A god's last spark. The part of it that hid. It doesn't want to hide any more."])
    end
    if with_or_is?(:meat_meat)
      sayc([cl(:meat_meat, "Mushroom friend is a god now. Meat Meat is still the bodyguard."),
            as(:wyn, "...Thank you. For both of those.")])
    end
    Stage.cleanup rescue nil
    mycolith_hoard
    set_flag(:godspark_shadow)
    if (sp = $Trainer.party.find { |pk| pk.species == :SPOREYE && pk.level >= 36 })
      say(["#{sp.name} looks up at the spark, and its gems flicker.",
           "(It's ready to grow now. The next time it gains a level, it may evolve.)"])
    end
    state[:goal] = "Through the roots beyond the platforms."
  end

  #-----------------------------------------------------------------------------
  # SC 7A.07 - Hyphora's leave
  #-----------------------------------------------------------------------------
  def scene_root_chapel
    return if flag?(:hyphora_leave)
    sayc(["The roots around you glow amber. Something enormous and very young looks at you through them.",
          "HYPHORA: (no words at first; only the feeling of being held)",
          "HYPHORA: You planted me. You came back.",
          "HYPHORA: Below me: fire. The cold man's heart. A woman who counts.",
          "HYPHORA: It burns his heart to keep me in summer. My leaves forget how to fall.",
          "HYPHORA: Thirty summers. No winter, no spring. The wheel can't turn on one season.",
          flag?(:promised_their_time) || flag?(:herald_wall_vow) ?
            "HYPHORA: (to you) You want the light-wall gone. Then help me let go of summer." : nil,
          cl(:reptin, "(very quietly) I only planted an acorn. I didn't know it would be someone."),
          "HYPHORA: I will open my roots to the burning place.", "HYPHORA: Go carefully. I am only four hundred years old.",
          cl(:alberica, "Only four hundred? Sweetheart, I've got shoes older than that."),
          cl(:reptin, "You do not."),
          cl(:alberica, "Spiritually."),
          cl(:wyn, "(a hand on the root) We'll be careful. I promise.")])
    set_flag(:hyphora_leave)
    set_flag(:road_a_done)
    ($game_switches[SW_HYPHORA] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    if flag?(:road_b_done)
      say(["The roots part. Hew's ladder is on the far side.", "The heart of the forge is straight down."])
      state[:goal] = "Down. The forge."
    else
      sayc(["The roots part, but a door of iron and mirror glass blocks the far side.",
            cl(:alerion, "Locked. From the city side."),
            as(:wyn, "The Guild Dig. Hew's tunnels touch it."),
            "Hyphora's roots carry you up, slow and warm, to the Sap Gate. It's dusk when you come out."])
      state[:goal] = "The other road: Hew's ladder, east of the market. The door of iron and glass is locked from that side."
      transfer(*SAP_GATE_TOP)
    end
  end

  # The way down to the forge, from either road (SC 7A.07 / 7B.08).
  def forge_door(side, event_id = nil)
    if side == :b
      if !flag?(:root_key)
        say(lines_for(:forge_door_glass) + ["There's a keyhole, small and black, rimed with frost."], event_id)
        pbMoveRoute($game_player, [PBMoveRoute::Backward]) rescue nil
        return
      end
      if !flag?(:road_b_done)
        say(["The Root-Key turns. Behind the door of iron and glass: a wall of roots, braided shut."], event_id)
        set_flag(:road_b_done)
        add_counter(:story_beats)
        event_id = nil
      end
    end
    if flag?(:road_a_done) && flag?(:road_b_done)
      if $game_switches && $game_switches[SW_FORGE_OPEN]
        return say(["The roots know you. They open. Heat and hammering pour up the shaft."], event_id)   # (the door's own page takes you down)
      end
      set_switch(SW_FORGE_OPEN, true)
      say(["The roots know you. They open. Heat and hammering pour up the shaft."], event_id)
      return transfer(*FORGE_ARRIVAL) if forge_door_talk
      pbMoveRoute($game_player, [PBMoveRoute::Backward]) rescue nil
      return
    elsif side == :a
      say(lines_for(:forge_door_glass) + ["It's locked from the other side: the Guild Dig."], event_id)
    else
      sayc([as(:wyn, "The roots won't open for iron. Only for Hyphora."),
            cl(:reptin, "Then we ask her. Nicely. I'm very good at nicely."),
            "(Hyphora's roots are the other way down: the Sap Gate, in the Root-Tier.)"], event_id)
      state[:goal] = "The other road: the Sap Gate in the Root-Tier, and Hyphora."
    end
    pbMoveRoute($game_player, [PBMoveRoute::Backward]) rescue nil
  end

  # Context 07 M7-8: both roads done, at the door. Who's below, what waiting
  # costs, and the walk-away test (Bell pp. 33-37). Returns true to go down now.
  def forge_door_talk
    return true if flag?(:forge_door_talk)
    set_flag(:forge_door_talk)
    pbSEPlay("Earth3") rescue nil
    $game_screen.start_shake(2, 4, 12) rescue nil
    sayc(["Far below: hammers, in time. And under them, something like a heartbeat, too slow.",
          cl(:reptin, "Hyphora's leave, and Selrae's key. That's both locks."),
          cl(:alerion, "Var's down there. Or what she left of him."),
          cl(:meat_meat, "And her. The lady. Meat Meat can smell the cold table from here."),
          cl(:glimmer, "(a hand on the Rimefang) Cold since the stair. It knows where it's going.")])
    if with_or_is?(:wyn)
      speak(:wyn, "(very quietly) We could go up. Tell the Council. Let the Rootwardens come.", "...We could go up.")
    end
    if with_or_is?(:alberica)
      speak(:alberica, "And every night we wait, the tree burns a bit more. You heard her, sweetheart.",
            "...Every night we wait, it burns.")
    end
    c = pbMessage(_INTL("Go down now?"), [_INTL("Now."), _INTL("(Go back up and rest first.)")], 1)
    if c == 0
      sayc([herald?(:alerion) ? cl(:reptin, "Single file, then. Mind your heads.") : cl(:alerion, "Single file.")])
      return true
    end
    sayc([herald?(:reptin) ? cl(:alberica, "An hour, then, darling. One. The hammers won't wait longer.") :
                             cl(:reptin, "An hour, then. One. The hammers won't wait longer than that.")])
    false
  end

  def apply_road_a_switches
    return if !active? || !$game_switches
    sync_switch(SW_LAKE_OPEN, flag?(:hyphora_named) && flag?(:badge_undercanopy))
    sync_switch(SW_LAKE_DOWN, flag?(:lake_cleansed))
    sync_switch(SW_DOMAINS_OPEN, flag?(:domains_open))
    sync_switch(SW_MYCOLITH, flag?(:mycolith_down))
    sync_switch(SW_HYPHORA, flag?(:hyphora_leave))
    sync_switch(SW_FORGE_OPEN, flag?(:road_a_done) && flag?(:road_b_done))
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_road_a_switches
  rescue StandardError => err
    FrostThaw.log("Road A switches failed: #{err.message}")
  end
}
