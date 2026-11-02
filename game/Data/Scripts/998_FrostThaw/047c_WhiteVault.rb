#===============================================================================
# Frost & Thaw - the White Vault thread; Sephek's two avatars; Auril's relics
#
# From the notes (rootspire.md: Tab 1 "Avarice Reforged", "Transition to the
# White Vault"; Tab 4 "Revised Sephek Encounters"):
#
#   * Three Frostshard Sigils: the Echo Gate's wraiths, Eirwen (their custodian)
#     and Sephek, whose defeat drops one. Held together they merge: "wings spread
#     over a frozen eye", and somewhere beyond the Auroral Wall a door opens.
#   * Sephek fights in two stages. The Minor Avatar leans on his followers (two
#     frost druids, ice mephits) and can't be killed inside Rootspire: he
#     reforms. The Major Avatar comes when Auril pours herself into him, with
#     winter wolves and a coldlight walker, and Divine Rejuvenation: while one
#     of Auril's relics in the Heartroot stands, he gets up again.
#   * Avarice faked her death at the Forge. A fragment of her soul lived on in
#     the mirror circuits and now wears a crystalline body in the White Vault of
#     Ithryn Athis. She wants Razzy's scale core and Meat Meat's blood, to make
#     the Seraph-Draco: a living god of ordered seasons. Until the Vault she is
#     only seen in mirrors and dreams. If you never go, she comes to you: in
#     the Throne of Frost, for what's left of Auril.
#===============================================================================
module FrostThaw
  SW_AURIL_RELICS = 4138   # Sephek has risen: Auril's relics wait in the Heartroot
  SW_SIGILS_MERGED = 4139  # the three sigils are one: the door beyond the Wall is open
  SW_VAULT_BROKEN = 4140   # Avarice's cradle is broken

  MAPS.merge!(vault_gate: 2168, vault_circuits: 2169, vault_cradle: 2170)
  MAP_NAMES.merge!(2168 => "The White Vault", 2169 => "The Mirror Circuits", 2170 => "The Seraph Cradle")
  MAP_METADATA.merge!(
    2168 => { announce_location: true, battle_environment: :Ice },
    2169 => { announce_location: true, battle_environment: :Ice },
    2170 => { announce_location: true, battle_environment: :Ice }
  )
  AREAS.merge!(2168 => :white_vault, 2169 => :white_vault, 2170 => :white_vault)
  ENCOUNTERS[2168] = { step_chances: { Cave: 6 },
                       Cave: [[30, :SNEASEL, 60, 62], [25, :GLALIE, 60, 62], [20, :JYNX, 60, 62],
                              [15, :FROSLASS, 61, 63], [10, :DUSCLOPS, 61, 63]] }
  VAULT_ARRIVAL = [2168, 14, 26, 8]

  RELIC_ITEMS.merge!(
    FT_SERAPHSIGIL: ["Seraph Sigil", "Seraph Sigils", 8, 0,
      "Three Frostshard Sigils, merged: wings spread over a frozen eye. It pulls north, toward a door beyond the Auroral Wall.", 0, 0, 6],
    # (FT_SCALECORE is defined once, in 048_Rootspire_D_Quests.rb: the Corsairs' wyrmling scale core.)
  )

  TRAINER_TYPES.merge!(
    FT_FROST_DRUID: ["Frost Druid", :CHANNELER, 0, 120, :LEADER_Pryce],
    FT_AVARICE_R: ["Avarice Reforged", :CHANNELER, 1, 250, :LEADER_Pryce]
  )
  TRAINERS.merge!(
    frost_druid_ansel: [:FT_FROST_DRUID, "Brother Ansel", [[:B124H221, 56], [:WEAVILE, 57], [:B361H215, 57]],
                        "The Saint walks. You're too late, as you were always going to be."],
    frost_druid_ilse:  [:FT_FROST_DRUID, "Sister Ilse", [[:B87H215, 56], [:B225H478, 57], [:MAMOSWINE, 58]],
                        "She'll make you beautiful. She'll make you still."],
    crown_druid_ansel: [:FT_FROST_DRUID, "Brother Ansel", [[:B124H221, 63], [:WEAVILE, 64], [:B361H215, 64], [:B473H221, 65]],
                        "You again. Always you again."],
    crown_druid_ilse:  [:FT_FROST_DRUID, "Sister Ilse", [[:B87H215, 63], [:B225H478, 64], [:MAMOSWINE, 65], [:B478H87, 65]],
                        "The Saint will rise. He always rises."]
  )
  TRAINER_INTROS.merge!(
    frost_druid_ansel: "ANSEL: Kneel. The Saint is waking.",
    frost_druid_ilse: "SISTER ILSE: Hush. Listen. That's her breathing.",
    crown_druid_ansel: "ANSEL: Kneel. This time you kneel.",
    crown_druid_ilse: "SISTER ILSE: On her island, the cold answers us.",
    avarice_reforged: "AVARICE: Let's see what the variables are worth."
  )

  # Sephek's stand-in bodies (Ice/Ghost fusions until he has his own species)
  SEPHEK_MINOR = :B478H87   # the Minor Avatar: frost-pale, a man of hoarfrost
  SEPHEK_MAJOR = :B144H478  # the Major Avatar: a towering crystalline horror
  COLDLIGHT    = :B478H92   # a coldlight walker
  AVARICE_BODY = :B437H124  # Avarice Reforged's crystal body (machinery and a mirror's face)
  AVARICE_SOUL = :B429H122  # her mirror-soul

  # Auril's three relics in the Heartroot: [flag, map, where]
  AURIL_RELICS = [[:relic_seal, 2057, "in the seal circle at the Root Gate"],
                  [:relic_wells, 2058, "under the Sap Wells' basins"],
                  [:relic_overflow, 2067, "in the bone-heap of the Overflow Channel"]]

  TEXT.merge!(
    auril_relic_gone: ["Black ice, smashed. The frost-runes round it have gone to water."],
    vault_gate_shut: ["A door of white ice set into the glacier, three times the height of a giant.",
                      "Carved across it: wings spread over a frozen eye. Three hollows in the eye, each the shape of a sigil."],
    vault_gate_open: ["The door of wings stands open. Cold breathes out, and under the cold, the hum of machinery."],
    vault_circuit_dead: ["The mirror circuit is dark. The reflections in it are only yours."],
    vault_cradle_empty: ["The cradle is empty. Crystal dust, a broken mirror, the smell of hot metal on ice."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # The three Frostshard Sigils
  #-----------------------------------------------------------------------------
  def sigils_held
    [flag?(:echo_wraiths_down) || flag?(:sigil_echo), flag?(:sigil_eirwen), flag?(:sigil_sephek)].count(true)
  end

  def vault_map_pieces
    %i[vault_map_1 vault_map_2 vault_map_3].count { |f| flag?(f) }
  end

  # Called whenever a sigil arrives: three together merge (the notes' read-aloud).
  def try_merge_sigils
    return false if flag?(:sigils_merged) || sigils_held < 3
    pbSEPlay("Saint7") rescue nil
    $game_screen.start_flash(Color.new(220, 240, 255, 180), 20) rescue nil
    say(["The aurora brightens, stretching northward like a path of glass.",
         "You hold the three Frostshard Sigils together, and they merge into a single symbol of draconic design:",
         "wings spread over a frozen eye.",
         "The World Tree shivers, and from its roots rises a wind that smells of ancient ice.",
         "Somewhere beyond the Auroral Wall, a door has opened.",
         "The White Vault awaits."])
    take_key(:FT_FROSTSIGIL) rescue nil
    give_key(:FT_SERAPHSIGIL)
    set_flag(:sigils_merged)
    set_switch(SW_SIGILS_MERGED, true)
    sayc([cl(:alberica, "(very quietly) Wings over a frozen eye. That's the vault I saw in the well."),
          cl(:alerion, "Then we know where it is."),
          vault_map_pieces >= 3 ? cl(:reptin, "And with all three pieces of the map, we know where its heart is. Lovely. I hate it.") : nil,
          cl(:wyn, "...Something in there is awake. I can hear it counting.")])
    add_counter(:story_beats)
    true
  end

  # Eirwen is the sigils' custodian (rootspire.md, Eirwen Solglass: "custodian of
  # one of the three Frostshard Sigils"). She hands hers over when it's time.
  def eirwen_sigil
    return if flag?(:sigil_eirwen)
    say(["EIRWEN: (barefoot, frost-dust in their hair, holding out a crystal) I've kept this since before the Rime.",
         "EIRWEN: A Frostshard Sigil. My teacher said: give it to the ones who come back.",
         "EIRWEN: You keep coming back. I think that's you."])
    give(:FT_FROSTSIGIL)
    set_flag(:sigil_eirwen)
  end

  #-----------------------------------------------------------------------------
  # Sephek, the Minor Avatar (SC 11.02, at the Shrine of the Twinned Dragons)
  #-----------------------------------------------------------------------------
  # Returns true if the party stood (it changes the lines; Iskra comes either way).
  def sephek_minor_avatar
    sayc(["Sephek lifts one hand. Two of the Halo step out of the ranks and throw back their hoods:",
          "frost druids, their beards white with rime. The snow at the altar's foot boils, and ice mephits climb out of it, giggling.",
          "SEPHEK: (gently) Mine, while they stand. Let's see how long they stand."])
    # (losing to his followers doesn't end the scene: they just keep standing, and he keeps his strength)
    fought = 0
    %i[frost_druid_ansel frost_druid_ilse].each do |k|
      type, name = TRAINERS[k]
      won = pbTrainerBattle(type, name, nil, false, 0, true) ? true : false
      fought += 1 if won
      pbFadeOutIn { $Trainer.heal_party } rescue nil if !won
    end
    say(["The mephits come at you in a cackling knot."])
    setBattleRule("canLose") rescue nil
    fought += 1 if boss_battle(named_mon(:B361H215, 56, "Ice Mephit"), named_mon(:B361H215, 56, "Ice Mephit"))
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    if fought >= 3
      say(["The last mephit pops like a soap bubble full of snow.",
           "Sephek trembles. Frost runs out of him like sweat. For a moment he's only a cold man, alone on an altar."])
    else
      say(["The Halo's followers fall back round him, still standing. He doesn't tremble at all."])
    end
    able = $Trainer.party.count { |pk| !pk.egg? && pk.hp > 0 }
    say(["ELINE and SEPHEK: (together, as if one were the other's echo) Stand back from the Saint."])
    won_eline = pbTrainerBattle(:FT_HALO_MATRON, "Matron Eline", nil, able >= 2, 0, true) ? true : false
    say([won_eline ? "Eline goes down on one knee." : "Eline doesn't even look at you. She's looking at him."])
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    av = named_mon(SEPHEK_MINOR, 61, "Sephek, Minor Avatar")
    av.hp = [(av.totalhp * (fought >= 3 ? 0.5 : 1.0)).floor, 1].max   # alone, he can't heal above half
    setBattleRule("canLose") rescue nil       # (he can't die here: win or lose, he shatters and reforms)
    won = boss_battle(av)
    if won
      say(["Your last blow goes through him like a hand through mist.",
           "He shatters into a whirlwind of ice, and the whirlwind keeps turning."])
    else
      say(["The cold comes off him in a wave and puts every Pokémon on the Shrine on the ground.",
           "Then, without anyone touching him, he shatters into a whirlwind of ice."])
    end
    say(["Something falls out of the whirlwind and rings on the altar stone: a crystal that hums.",
         "Then the ice runs back together, flake by flake, and Sephek stands up again.",
         "SEPHEK: (almost sorry) Not here. Not in her garden. Here I come back."])
    if !flag?(:sigil_sephek)
      give(:FT_FROSTSIGIL)
      set_flag(:sigil_sephek)
      say(["(A Frostshard Sigil. It fell out of the Frost Saint.)"])
    end
    set_flag(:sephek_minor_fought)
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    won
  end

  #-----------------------------------------------------------------------------
  # Auril's relics in the Heartroot (Divine Rejuvenation)
  #-----------------------------------------------------------------------------
  def relics_left
    AURIL_RELICS.count { |f, _, _| !flag?(f) }
  end

  def auril_relic(which, event_id = nil)
    f, _m, where = AURIL_RELICS.find { |k, _, _| k == which }
    return if !f
    return say(lines_for(:auril_relic_gone), event_id) if flag?(f)
    say(["A shard of black ice #{where}, in a nest of frost-runes. It hums with her cold.",
         "The frost-runes are fresh. The Halo has been down here, carrying it in."], event_id)
    sayc([cl(:alerion, "(a hand on his chest) It's beating. In time with him."),
          cl(:wyn, "...It's taking from the tree. Just a little. Like a tick.")])
    return if !pbConfirmMessage(_INTL("Smash Auril's relic?"))
    say(["The runes flare. The cold stands up out of the shard and takes a shape: a woman of rime, faceless."])
    return if !boss_battle(named_mon(:B478H215, 62, "Relic-Warden"))
    pbSEPlay("Ice8") rescue nil
    say(["The shard cracks, and cracks again, and goes to black water on the root."])
    set_flag(f)
    left = relics_left
    if left == 0
      sayc(["Far away, north, something that was holding its breath lets it out.",
            cl(:alerion, "That's all three. He won't get up again.")])
      set_flag(:auril_relics_destroyed)
    else
      say(["(#{left == 1 ? 'One relic is' : "#{left} relics are"} still somewhere in the Heartroot.)"])
    end
  end

  #-----------------------------------------------------------------------------
  # Sephek, the Major Avatar (SC 13.07, at the Crown) - the fight
  #-----------------------------------------------------------------------------
  def sephek_major_fight
    say(["SEPHEK: Then let's see whose cold is colder."])
    ok = trainer(:crown_druid_ansel, nil)
    ok = trainer(:crown_druid_ilse, nil) && ok
    return false if !ok
    say(["His followers down, Sephek sways. He's below half, and he knows it."])
    return false if !trainer(:sephek_saint, nil)
    say(["Behind him, in her crystal, Frostina's eyes find yours. Warmth comes off the crystal like a hearth.",
         "(Your Pokémon get their breath back.)"])
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    sayc(["Auril pours herself into him.",
          "His form shatters into a whirlwind of ice and reassembles, taller, wider: a towering crystalline horror.",
          "The cold coming off him is a wall. Every follower who fell makes it colder.",
          "SEPHEK: (a voice like a glacier moving) STAND STILL."])
    say(["Two winter wolves lope out of the blizzard at his call."])
    return false if !boss_battle(named_mon(:B59H471, 64, "Winter Wolf"), named_mon(:B59H471, 64, "Winter Wolf"))
    major = named_mon(SEPHEK_MAJOR, 68, "Sephek, Major Avatar")
    walker = named_mon(COLDLIGHT, 64, "Coldlight Walker")
    return false if !boss_battle(major, walker)
    if !flag?(:auril_relics_destroyed)
      sayc(["He falls. The ice runs back together anyway, slower now, one shard at a time.",
            "Somewhere far south, in the Heartroot, black ice hums.",
            "SEPHEK: While one of her relics stands, I stand."])
      again = named_mon(SEPHEK_MAJOR, 68, "Sephek, Major Avatar")
      again.hp = [(again.totalhp * 0.4).floor + 40, again.totalhp].min
      return false if !boss_battle(again)
    end
    true
  end

  #-----------------------------------------------------------------------------
  # The White Vault of Ithryn Athis (after the sigils merge)
  #-----------------------------------------------------------------------------
  def scene_vault_gate_enter
    return if flag?(:vault_entered)
    set_flag(:vault_entered)
    add_counter(:story_beats)
    sayc(["A glacier, and in the glacier a vault of white ice, older than any name in the Dale.",
          "The path of glass ends at a door carved with wings spread over a frozen eye.",
          cl(:alberica, "(the rune on her chest prickling) I dreamed this door. Before the Chasm. Before any of it."),
          cl(:meat_meat, "Meat Meat smells hot metal. Under ice. That is wrong."),
          cl(:reptin, "(quietly) Everyone stay close. And nobody touch anything that hums.")])
  end

  def vault_door(event_id = nil)
    return say(lines_for(:vault_gate_open), event_id) if flag?(:vault_door_open)
    say(lines_for(:vault_gate_shut), event_id)
    if !flag?(:sigils_merged)
      return say(["The hollows are cold and empty. It wants three sigils, made one."])
    end
    return if !pbConfirmMessage(_INTL("Press the Seraph Sigil into the frozen eye?"))
    say(["The sigil sinks into the ice. The frozen eye opens.",
         "Behind the door, two things of mirror and iron stir: Mirror Sentinels, helmed and hollow."])
    return if !boss_battle(named_mon(:B437H227, 62, "Mirror Sentinel"), named_mon(:B437H227, 62, "Mirror Sentinel"))
    say(["The sentinels come apart into plates of glass and lie still.", "The door of wings stands open."])
    set_flag(:vault_door_open)
    set_self_switch(event_id, "A") rescue nil
    $game_map.need_refresh = true if $game_map
  end

  # The Mirror Circuits: Avarice, only in the mirrors; three circuits feed her cradle.
  VAULT_CIRCUITS = %i[circuit_north circuit_east circuit_west]

  def scene_vault_circuits
    return if flag?(:circuits_seen)
    set_flag(:circuits_seen)
    al = herald?(:alberica)
    sayc(["Machinery under the ice: pipes of mirror-glass, brass wheels the size of houses, all of it humming.",
          "Every mirror shows you. Then, one by one, every mirror shows her.",
          "White hair. Infernal sigils. A smile like arithmetic.",
          "AVARICE: (from every mirror at once) Variables that refused to die. Hello again.",
          cl(:alberica, "(very still) You're dead. We watched you die."),
          al ? "AVARICE: You watched a coat burn, songbird. Did you think I only had one?" :
               "AVARICE: You watched a coat burn, Alberica. Did you think I only had one?",
          "AVARICE: A little of me lived in the mirrors under the Heartroot. A little is all I've ever needed."])
    whispers = []
    whispers << (herald?(:meat_meat) ? "(She says your number. V-7. Then, softly, the sound you made the day you were born.)" :
                                       "AVARICE: (to Meat Meat) V-7. I still have the sound you made the day you were made.") if with_or_is?(:meat_meat)
    whispers << "AVARICE: (to Alerion) The boy in the lake. You know where you learned to call him back? I taught a ghost to teach you." if with_or_is?(:alerion)
    whispers << "AVARICE: (to Reptin) Your wolf howled at your birth. I heard it. I hear everything said in my laboratories." if with_or_is?(:reptin)
    whispers << "AVARICE: (to Wyn) Little shadow. You'd make a lovely lens." if with_or_is?(:wyn)
    sayc(whispers)
    sayc(["AVARICE: Draconic essence, and divine. Razzy's scale core and V-7's blood, and a season I can wind like a clock.",
          "AVARICE: The Seraph-Draco: a living god of ordered seasons. No more Rime. No more Summer. Just the schedule.",
          "AVARICE: Come to the cradle. You were always going to.",
          cl(:meat_meat, "Meat Meat is coming. Meat Meat is bringing her teeth.")])
    if vault_map_pieces >= 3
      say(["(The three map fragments fit together in your head: three circuits feed the cradle. North, east and west.)",
           "(Break them, and whatever's waiting in the cradle will be weaker for it.)"])
    else
      say(["(The machinery runs in three great circuits. Each one hums toward the far door.)"])
    end
  end

  def vault_circuit(key, event_id = nil)
    return say(lines_for(:vault_circuit_dead), event_id) if flag?(key)
    say(["A ring of mirror-glass turning inside a ring of brass. In every pane, her face, smiling."], event_id)
    return if !pbConfirmMessage(_INTL("Break the circuit?"))
    say(["The panes turn toward you. Ink runs out of them and stands up: a Mirror-Ink Wraith."])
    return if !boss_battle(named_mon(:B429H200, 61, "Mirror-Ink Wraith"))
    say(["The wraith spatters across the ice. The ring grinds to a stop, and the mirrors go dark one by one."])
    set_flag(key)
    left = VAULT_CIRCUITS.count { |k| !flag?(k) }
    say([left == 0 ? "(All three circuits are dark. Far off, something in a cradle stops humming.)" :
                     "(#{left} circuit#{left == 1 ? '' : 's'} still turning.)"])
  end

  def scene_vault_cradle
    return if flag?(:avarice_body_broken)
    mm = herald?(:meat_meat)
    if flag?(:mira_left_possessed)
      # rootspire.md 1079: left possessed, Mira becomes Avarice's new body.
      sayc(["A cradle of brass and mirror at the heart of the glacier.",
            "In it, Mira of the North Wind sits up. Her silver hair has gone white. Her skin is turning to crystal from the fingertips in.",
            "AVARICE: (in Mira's voice, only one voice now) You left her to me. On her own ship. With her daughter watching.",
            herald?(:meat_meat) ? "(You remember. You said you would.)" : cl(:meat_meat, "(white to the lips) Meat Meat said. Meat Meat SAID she would remember.")])
    end
    sayc([flag?(:mira_left_possessed) ? nil : "A cradle of brass and mirror at the heart of the glacier.",
          flag?(:mira_left_possessed) ? "Mira's body stands. Machinery unfolds around it like a dress being fitted." :
                                        "In it, a woman made of crystal sits up. Her body mirrors the Mirror Mother's, framed in machinery.",
          "Behind her, in a case of ice, a crystal grown round one green scale: RAZ-MKIII.",
          "AVARICE: (stretching, with a sound like a chandelier) There you are. Right on time."])
    if with_or_is?(:meat_meat)
      sayc([mm ? "A needle of mirror-glass slides out of the cradle toward your arm." :
                 "A needle of mirror-glass slides out of the cradle toward Meat Meat's arm.",
            "AVARICE: A drop. Only a drop, V-7. You owe me at least that.",
            mm ? "(You bite the needle in half.)" : "MEAT MEAT: (biting the needle in half) Meat Meat owes you NOTHING."])
    end
    sayc([cl(:reptin, "(stepping in front of her, as he did at the Forge) No. Not her. Not ever."),
          cl(:alerion, "You faked your death to hide in an icebox. Come out."),
          "AVARICE: Oh, I'll come out."])
    circuits = VAULT_CIRCUITS.count { |k| flag?(k) }
    type, name = TRAINERS[:avarice_reforged]
    $ft_avarice_circuits = circuits
    won = pbTrainerBattle(type, name, nil, false, 0) ? true : false
    $ft_avarice_circuits = 0
    return if !won
    say(["Her crystal body cracks across, from the crown down.",
         "Something pours out of it that isn't light: her, a smear of mirror, fleeing into the glass."])
    if flag?(:mira_left_possessed)
      sayc(["What's left in the cradle is Mira, or most of her: crystal to the elbows, breathing.",
            "MIRA: (one voice, very small) ...Is my girl warm? Somebody tell me she's warm.",
            cl(:alberica, "(kneeling, taking her crystal hands) She's warm, darling. She's on the ship. She's waiting."),
            "Mira never sails again. But she lives."])
      set_flag(:mira_freed_late)
    end
    soul = named_mon(AVARICE_SOUL, 64, "Avarice's Reflection")
    soul.hp = [(soul.totalhp * (1.0 - 0.2 * circuits)).floor, 1].max
    caught = boss_battle(soul)
    if caught
      sayc(["Her reflection shatters. One splinter of it, no bigger than a fingernail, flies off north, toward Solstice.",
            "AVARICE: (very small, very far) The Frostmaiden is a variable too, my failures. I'll see you at her throne."])
    else
      sayc(["Her reflection slides into the ice and away, north, laughing, toward Solstice.",
            "AVARICE: (from very far) I'll see you at her throne."])
    end
    if flag?(:scale_core_given)
      sayc(["The case of ice cracks open. Empty, except for a label in the neat white hand: RAZ-MKIII CORE. RECOVER FROM THE CORSAIRS.",
            cl(:meat_meat, "(patting her pack) Mira gave it to Meat Meat. She never got it back. Ha.")])
    else
      give_key(:FT_SCALECORE)
      sayc(["The case of ice cracks open. A crystal core grown round a cluster of green wyrmling scales drops into your hands. RAZ-MKIII. It's warm.",
            cl(:meat_meat, "(holding it against her chest) Razzy's. From the cold table. Meat Meat keeps this. Forever.")])
      set_flag(:scale_core_given)
    end
    sayc([
          cl(:alberica, "She isn't dead. She's never been dead. Why do the clever ones never stay dead?"),
          cl(:wyn, "...She went north. To the island. To Auril.")])
    set_flag(:avarice_revealed)
    set_flag(:avarice_body_broken)
    set_flag(:avarice_soul_shattered) if caught
    set_switch(SW_VAULT_BROKEN, true)
    add_counter(:story_beats)
    state[:goal] = flag?(:ch11_done) ? "Back to Rootspire, and north to Solstice. She went ahead of you." : state[:goal]
  end

  #-----------------------------------------------------------------------------
  # The Throne of Frost: what's left of Avarice comes for what's left of Auril
  #-----------------------------------------------------------------------------
  def avarice_at_the_throne
    return if flag?(:avarice_ended)
    if flag?(:avarice_body_broken)
      sayc(["In the throne room's ice wall, a splinter of mirror catches the diamond's light. A face moves in it.",
            "AVARICE: (thin as a draught under a door) A god in a gem. The last variable. Give it to me, failures.",
            "The splinter strains toward the diamond. It has nothing left to strain with."])
      sayc([herald?(:meat_meat) ? "(You walk over, and step on it.)" : (with_or_is?(:meat_meat) ? "Meat Meat walks over, and steps on it." : "You walk over, and step on it."),
            "It goes out like a spark in snow.",
            cl(:meat_meat, "That is for Razzy's voice. Meat Meat stamped. Meat Meat is DONE.")])
    else
      sayc(["Behind the throne the ice wall goes silver, then clear, then it's a mirror, and she steps out of it.",
            "A woman of crystal, framed in machinery, white hair, infernal sigils, a smile like arithmetic.",
            cl(:alberica, "(on her knees, not believing it) No. No, we watched you burn."),
            flag?(:mira_left_possessed) ? "AVARICE: (in Mira's voice) You watched a coat burn. I had another. You left her for me, on her own ship." :
                                          "AVARICE: You watched a coat burn. I had another in a glacier. You never came to look.",
            "AVARICE: A god in a gem. The last variable. Thank you for weighing her out for me."])
      type, name = TRAINERS[:avarice_reforged]
      $ft_avarice_circuits = 0
      won = pbTrainerBattle(type, name, nil, false, 0, true) ? true : false
      pbFadeOutIn { $Trainer.heal_party } rescue nil
      if won
        say(["Her crystal body cracks across, from the crown down, and her reflection runs out of it into the ice.",
             "Frostina breathes on the ice. It freezes solid, with the reflection inside it, and doesn't thaw."])
      else
        say(["She reaches for the diamond. Razzilith gets there first, and bites her hand off at the wrist.",
             "Frostina breathes on the ice wall, and the mirror freezes solid with her in it."])
      end
      set_flag(:avarice_revealed)
    end
    set_flag(:avarice_ended)
    add_counter(:story_beats)
  end

  def apply_white_vault_switches
    return if !active? || !$game_switches
    $game_switches[SW_AURIL_RELICS] = flag?(:sephek_risen) && !flag?(:auril_relics_destroyed) && !flag?(:frostina_freed)
    $game_switches[SW_SIGILS_MERGED] = flag?(:sigils_merged)
    $game_switches[SW_VAULT_BROKEN] = flag?(:avarice_body_broken)
  end
end

# Avarice Reforged: her crystal body is weaker for every circuit you broke.
module FrostThaw
  TRAINERS[:avarice_reforged] = [:FT_AVARICE_R, "Avarice", [[:B437H124, 64], [:B474H429, 65], [:B227H437, 65], [:B92H122, 66], [AVARICE_BODY, 68]],
                                 "Variables. Always variables. ...Recalculating."]
end

if Events.respond_to?(:onTrainerPartyLoad)
  Events.onTrainerPartyLoad += proc { |_sender, e|
    begin
      trainer = e.is_a?(Array) ? e[0] : e
      n = $ft_avarice_circuits.to_i
      if n > 0 && trainer && trainer.name == "Avarice" && FrostThaw.flag?(:vault_entered)
        trainer.party.each { |pk| pk.hp = [(pk.totalhp * (1.0 - 0.15 * n)).floor, 1].max }
      end
    rescue StandardError => err
      FrostThaw.log("Avarice's circuits failed: #{err.message}")
    end
  }
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_white_vault_switches
  rescue StandardError => err
    FrostThaw.log("White Vault switches failed: #{err.message}")
  end
}
