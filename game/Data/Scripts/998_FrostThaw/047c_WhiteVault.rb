#===============================================================================
# Frost & Thaw - the White Vault thread; Sephek's two avatars; Auril's relics
#
# From the notes (rootspire.md: Tab 1 "Avarice Reforged", "Transition to the
# White Vault"; Tab 4 "Revised Sephek Encounters"):
#
#   * Three Frostshard Sigils: the Echo Gate's wraiths, Eirwen (their custodian)
#     and Sephek, whose defeat drops one. Held together they merge: "wings spread
#     over a frozen eye", and far north, where the Wall stood, a door wakes.
#     Alberica's Pendant of Black Ice is the one key that opens it (owner's
#     decision 4, 2026-11-06): her family kept it so the door stayed shut.
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
  SW_SIGILS_MERGED = 4139  # the three sigils are one: the Vault's door has woken
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
  VAULT_GOAL = "Postgame: past the Glasswater, where the Wall stood, to the White Vault. Alberica's door."

  RELIC_ITEMS.merge!(
    FT_SERAPHSIGIL: ["Seraph Sigil", "Seraph Sigils", 8, 0,
      "Three Frostshard Sigils, merged: wings spread over a frozen eye. It pulls north, past where the Auroral Wall stood, toward a door of wings.", 0, 0, 6],
    # (FT_SCALECORE is defined once, in 048_Rootspire_D_Quests.rb: the Corsairs' wyrmling scale core.)
  )

  VAULT_KEY_ITEMS = {
    FT_BLACKPENDANT: ["Pendant of Black Ice", "Pendants of Black Ice", 8, 0,
      "Alberica's pendant, come back again. Her family kept it so a door would stay shut: it's the White Vault's one key.", 0, 0, 6]
  }
  VAULT_KEY_ITEM_NUMBER = 9600   # well clear of the relics (9100 up, 134 of them at 0.7.4)

  TRAINER_TYPES.merge!(
    FT_FROST_DRUID: ["Frost Druid", :CHANNELER, 0, 120, :LEADER_Pryce],
    FT_AVARICE_R: ["Avarice Reforged", :CHANNELER, 1, 250, :LEADER_Pryce]
  )
  TRAINERS.merge!(
    frost_druid_ansel: [:FT_FROST_DRUID, "Brother Ansel", [[:B124H221, 56], [:WEAVILE, 57], [:B427H215, 57]],
                        "The Saint walks. You're too late, as you were always going to be."],
    frost_druid_ilse:  [:FT_FROST_DRUID, "Sister Ilse", [[:B87H215, 56], [:B225H429, 57], [:MAMOSWINE, 58]],
                        "She'll make you beautiful. She'll make you still."],
    crown_druid_ansel: [:FT_FROST_DRUID, "Brother Ansel", [[:B124H221, 63], [:WEAVILE, 64], [:B427H215, 64], [:B274H221, 65]],
                        "You again. Always you again."],
    crown_druid_ilse:  [:FT_FROST_DRUID, "Sister Ilse", [[:B87H215, 63], [:B225H429, 64], [:MAMOSWINE, 65], [:B429H87, 65]],
                        "The Saint will rise. He always rises."]
  )
  TRAINER_INTROS.merge!(
    frost_druid_ansel: "ANSEL: Kneel. The Saint is waking.",
    frost_druid_ilse: "SISTER ILSE: Hush. Listen. That's her breathing.",
    crown_druid_ansel: "ANSEL: Kneel. This time you kneel.",
    crown_druid_ilse: "SISTER ILSE: On her island, the cold answers us.",
    avarice_reforged: "AVARICE: Let's see what the variables are worth.",
    avarice_vault: "AVARICE: Again? Fine. Let's see what the variables are worth now."
  )

  # Sephek's stand-in bodies (Ice/Ghost fusions until he has his own species)
  SEPHEK_MINOR = :B429H87   # the Minor Avatar: frost-pale, a man of hoarfrost
  SEPHEK_MAJOR = :B144H429  # the Major Avatar: a towering crystalline horror
  COLDLIGHT    = :B429H92   # a coldlight walker
  AVARICE_BODY = :B449H124  # Avarice Reforged's crystal body (machinery and a mirror's face)
  AVARICE_SOUL = :B429H122  # her mirror-soul

  # Auril's three relics in the Heartroot: [flag, map, where]
  AURIL_RELICS = [[:relic_seal, 2057, "in the seal circle at the Root Gate"],
                  [:relic_wells, 2058, "under the Sap Wells' basins"],
                  [:relic_overflow, 2067, "in the bone-heap of the Overflow Channel"]]

  TEXT.merge!(
    auril_relic_gone: ["Black ice, smashed. The frost-runes round it have gone to water."],
    vault_gate_shut: ["A door of white ice set into the glacier, three times the height of a giant.",
                      "Carved across it: wings spread over a frozen eye.",
                      "Three hollows in the eye, each the shape of a sigil."],
    vault_gate_open: ["The door of wings stands open. Cold breathes out, and under it, the hum of machinery."],
    vault_circuit_dead: ["The mirror circuit is dark. The reflections in it are only yours."],
    vault_cradle_empty: ["The cradle is empty. Crystal dust, a broken mirror, the smell of hot metal on ice."],
    vault_case: ["A case of ice behind the cradle. Inside it, something green catches the light."]
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
  # The White Vault is postgame (owner's call, 2026-11-05; the bible's own plan):
  # while Auril holds the north the sigils only hum. Once the story is over,
  # three held together wake.
  def try_merge_sigils
    return false if flag?(:sigils_merged) || sigils_held < 3
    if !flag?(:game_complete)
      return false if flag?(:sigils_humming)
      set_flag(:sigils_humming)
      say(["The three Frostshard Sigils knock together in your bag and hum, very low.",
           "Then they go quiet, as if something to the north is listening for them.",
           "(They won't wake while Auril holds the north. Keep them.)"])
      return false
    end
    # The hook, after the end (context 13 M13-8): the bargain paid forward (the
    # dock told it, 12.md M12-6), the map made true (the Wall has fallen), and
    # the White Womb joined to the White Vault.
    say(["Rootspire. Some time later."])
    pbSEPlay("Saint7") rescue nil
    $game_screen.start_flash(Color.new(220, 240, 255, 180), 20) rescue nil
    say(["The aurora brightens, stretching northward like a path of glass.",
         "You hold the three Frostshard Sigils together. They merge: wings spread over a frozen eye.",
         "The World Tree shivers, and from its roots rises a wind that smells of ancient ice.",
         "Far north, the mirror Frostina froze at Auril's throne splits. Whatever was in it is gone.",
         "Further north still, past where the Wall stood, a door wakes. The White Vault is waiting."])
    take_key(:FT_FROSTSIGIL) rescue nil
    give_key(:FT_SERAPHSIGIL)
    set_flag(:sigils_merged)
    set_switch(SW_SIGILS_MERGED, true)
    side_goal(:vault, VAULT_GOAL, done: :avarice_body_broken)
    al = herald?(:alberica)
    seen = flag?(:well_vision_3)
    if al
      say(["You say it very quietly.",
           seen ? "(Wings over a frozen eye. The vault you saw in the well.)" : "(Wings over a frozen eye. You've dreamed that door.)",
           "Your hand goes to your throat, where the pendant hung. Something cold pulses there."])
      speak(:alberica, "Gran's door. The one that had to stay shut.", "...I know that door.")
    elsif with_or_is?(:alberica)
      say([seen ? "ALBERICA: (quietly) The well showed me a map with that on it. I thought it was a bird." :
                  "ALBERICA: (very quietly) Wings over a frozen eye. I've dreamed that door.",
           "Where her pendant used to hang, something cold pulses. Brightest facing north.",
           "ALBERICA: (a hand at her throat) Gran's door. The one that had to stay shut."])
    end
    if with_or_is?(:alberica)
      told = flag?(:bargain_told) || flag?(:bargain_heard_out)
      cline(:reptin, told ? "Your family's bargain. What happens if it opens?" : "Alberica? You've gone white, dear.",
            told ? "...The bargain. What happens if it opens?" : "...Alberica?")
      cline(:alberica, "I don't know. Nobody ever said what's behind it. We'd have to open it to see.",
            "...I don't know. Nobody ever said.")
      if flag?(:bargain_pushed)
        say(["ALBERICA: (to you) You said it wasn't mine to pay. Let's find out whose it is."])
      end
    end
    sayc([cl(:alerion, "Then it's waiting for us."),
          vault_map_pieces >= 3 ? cl(:reptin, "And with all three pieces of the map, we know where its heart is. Lovely. I hate it.") : nil,
          cl(:meat_meat, "Selrae called it the White Womb. So did Avarice. Meat Meat hates both names."),
          cl(:wyn, "...Something in there is awake. I can hear it counting.")])
    add_counter(:story_beats)
    true
  end

  # Eirwen is the sigils' custodian (rootspire.md, Eirwen Solglass: "custodian of
  # one of the three Frostshard Sigils"). She hands hers over when it's time.
  def eirwen_sigil
    return if flag?(:sigil_eirwen)
    say(["EIRWEN: (holding out a crystal) We've kept this since before the Rime. Teacher to teacher.",
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
    # (notes/11 E6: his followers step forward and the mephits come up out of the snow, on screen)
    robes = $game_map.events.values.select { |e| e.name.to_s == "stage_halo_robe" }.first(2) rescue []
    say(["Sephek lifts a hand. Two of the Halo throw back their hoods: frost druids, rimed white."])
    robes.each { |r| Stage.walk(r, PBMoveRoute::Down) }
    sx, sy = robes.first ? [robes.first.x, robes.first.y] : [$game_player.x, $game_player.y - 3]
    mephits = [[-1, 2], [3, 1]].map { |dx, dy| Stage.actor(:ice_mephit, sx + dx, sy + dy, 2, graphic: "Followers/SNORUNT") }.compact
    mephits.each { |m| Stage.hop(m) }
    say(["The snow at the altar's foot boils. Ice mephits climb out of it, giggling.",
         "SEPHEK: Mine, while they stand. Let's see how long they stand.",
         "(While his followers stand, the cold in him stays strong.)"])
    glaive_resonates
    # rootspire.md Tab 1 (Sephek): Meat Meat's blood, "Prototype Verdant"; Alerion the rival aspect of frost.
    # (dialogue 11 Top 4: nothing he couldn't know, and "quietly sorry", not greedy)
    if with_or_is?(:meat_meat)
      sayc(["SEPHEK: (eyes on Meat Meat) ...Prototype Verdant. The Halo prayed about you. You're small.",
            "SEPHEK: Summer's engine cooked your blood. It won't freeze. She'd like a drop. I'm sorry.",
            cl(:meat_meat, "The dream man. Meat Meat knew it."),
            cl(:meat_meat, "Meat Meat's blood is for Meat Meat. Bite the frost man, Razzy.")])
    end
    if with_or_is?(:alerion)
      sayc(["SEPHEK: (to Alerion, almost kindly) Two of us hear her. When she wakes, one of us stops."])
    end
    # (losing to his followers doesn't end the scene: they just keep standing, and he keeps his strength)
    fought = 0
    [[:frost_druid_ansel, :ansel], [:frost_druid_ilse, :sister_ilse]].each_with_index do |(k, who), i|
      robe = robes[i]
      if robe
        robe.instance_variable_set(:@name, "stage_#{who}") rescue nil
        robe.instance_variable_get(:@event).name = "stage_#{who}" rescue nil
      end
      trainer_intro(k)                           # (notes/11 E8: they speak before they fight)
      type, name = TRAINERS[k]
      won = pbTrainerBattle(type, name, nil, false, 0, true) ? true : false
      fought += 1 if won
      pbFadeOutIn { $Trainer.heal_party } rescue nil if !won
    end
    say(["The mephits come at you in a cackling knot."])
    setBattleRule("canLose") rescue nil
    fought += 1 if boss_battle(named_mon(:B427H215, 56, "Ice Mephit"), named_mon(:B427H215, 56, "Ice Mephit"))
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    if fought >= 3
      mephits.each { |m| Stage.remove_actor(m) }
      say(["The last mephit pops like a soap bubble full of snow.",
           "Sephek trembles. Frost runs out of him like sweat. For a moment he's only a cold man."])
    else
      say(["The Halo's followers fall back round him, still standing. He doesn't tremble at all."])
    end
    able = $Trainer.party.count { |pk| !pk.egg? && pk.hp > 0 }
    say(["ELINE: (Sephek's lips moving with hers) Stand back from the Saint."])
    won_eline = pbTrainerBattle(:FT_HALO_MATRON, "Matron Eline", nil, able >= 2, 0, true) ? true : false
    say([won_eline ? "Eline goes down on one knee." : "Eline doesn't even look at you. She's looking at him."])
    eline_mercy(won_eline)
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    av = named_mon(SEPHEK_MINOR, 61, "Sephek, Minor Avatar")
    av.hp = [(av.totalhp * (fought >= 3 ? 0.5 : 1.0)).floor, 1].max   # alone, he can't heal above half
    # GQ2 (rootspire.md 8492): destroying the Shard means he can't truly return
    # from it. Wired back together from splinters, he comes back less than whole.
    if flag?(:shard_destroyed)
      av.hp = [(av.hp * 0.6).floor, 1].max
      say(["The splinters in his chest grind against each other. He comes at you a beat slow, like something put together from memory."])
    end
    setBattleRule("canLose") rescue nil       # (he can't die here: win or lose, he shatters and reforms)
    won = boss_battle(av, bgm: "regibattle")   # (notes/11 E7: the chapter's boss gets a boss's music)
    if won
      say(["Your last blow goes through him like a hand through mist.",
           "He shatters into a whirlwind of ice, and the whirlwind keeps turning."])
    else
      say(["The cold comes off him in a wave and puts every Pokémon on the Shrine on the ground.",
           "Then, without anyone touching him, he shatters into a whirlwind of ice."])
    end
    seph = stage_event("stage_sephek")
    if seph
      Stage.fx("E-04", seph, frames: 10, oy: 16)         # the whirlwind of ice
      seph.opacity = 60
    end
    $game_screen.start_shake(5, 8, 12) rescue nil
    say(["Something falls out of the whirlwind and rings on the altar stone: a crystal that hums."])
    seph.opacity = 255 if seph rescue nil
    say(["Then the ice runs back together, flake by flake, and Sephek stands up again.",
         "SEPHEK: (almost sorry) Not here. Not while her relics stand under this tree.", "SEPHEK: Here, I come back."])
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
    # Three relics, three different beats (context 12 M12-2): the first names
    # whose heart it keeps and what smashing it does; the others move on.
    place = where.sub(/^./, &:upcase)
    case relics_left
    when 3
      say(["A shard of black ice #{where}.", "It sits in a nest of frost-runes, and hums with her cold.",
           "The frost-runes are fresh. The Halo carried it in while Selrae was their prisoner."], event_id)
      sayc([cl(:alerion, "(a hand on his chest) It's beating. In time with Sephek."),
            cl(:wyn, "...It's taking from the tree. Like a tick. While it stands, he gets back up.")])
    when 2
      say(["#{place}: the second shard. Fresh runes, still wet."], event_id)
      sayc([cl(:alerion, "(a hand on his chest) Same beat. Faster. He knows we're here."),
            cl(:meat_meat, "Tick. Meat Meat squashes ticks.")])
    else
      say(["#{place}, the last shard of black ice."], event_id)
      sayc([cl(:alberica, "Last one, darlings. Then he stays down.")])
    end
    return if !pbConfirmMessage(_INTL("Smash Auril's relic?"))
    # the warden rises on the map before the fight (notes 12 E11)
    rel = event_id ? $game_map.events[event_id] : nil
    Stage.fx("E-04", rel || $game_player, frames: 10, oy: 16) rescue nil
    Stage.cry(:B429H215)
    say(["The runes flare. The cold stands up out of the shard: a woman of rime, faceless."])
    return if !boss_battle(named_mon(:B429H215, 62, "Relic-Warden"))
    pbSEPlay("Ice8") rescue nil
    Stage.fx("E-06", rel, frames: 10, oy: 16) rescue nil if rel
    set_flag(f)
    relic_tiles
    say(["The shard cracks, and cracks again, and goes to black water on the root."])
    left = relics_left
    if left == 0
      sayc(["Far away, north, a breath that was being held runs out.",
            herald?(:reptin) ? "(The tree leans toward you a little when the last one breaks. You'd swear it.)" : nil,
            cl(:alerion, "That's all three. He won't get up again.")])
      set_flag(:auril_relics_destroyed)
    else
      say(["(#{left == 1 ? 'One relic is' : "#{left} relics are"} still somewhere in the Heartroot.)"])
      relic_goal
    end
  end

  # A smashed relic's black ice is gone from the root (notes 12 E11): its event
  # stays to be read ("smashed"), but shows nothing.
  def relic_tiles
    return if !$game_map
    $game_map.events.values.each do |e|
      next if e.name.to_s !~ /\AAuril's relic/
      k = e.name[/\((\w+)\)/, 1]
      f = k == "seal" ? :relic_seal : k.to_sym
      next if !flag?(f)
      e.instance_variable_set(:@tile_id, 0)
      e.instance_variable_set(:@character_name, "")
    end
  rescue StandardError => e
    log("relic tiles: #{e.message}")
  end

  #-----------------------------------------------------------------------------
  # Sephek, the Major Avatar (SC 13.07, at the Crown) - the fight
  #-----------------------------------------------------------------------------
  def sephek_major_fight
    say(["SEPHEK: (quietly) Then I'm sorry. Again."])     # (dialogue 13: quietly sorry, not a stock taunt)
    ok = trainer(:crown_druid_ansel, nil)
    ok = trainer(:crown_druid_ilse, nil) && ok
    return false if !ok
    say(["His followers down, Sephek sways. He's below half, and he knows it."])
    return false if !trainer(:sephek_saint, nil)
    say(["Behind him, in her crystal, Frostina's eyes find yours. Warmth comes off it like a hearth.",
         "(Your Pokémon get their breath back.)"])
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    sayc(["Auril pours herself into him.",
          "He shatters into a whirlwind of ice and comes back taller, wider: a crystalline horror.",
          "The cold coming off him is a wall. Every follower who fell makes it colder.",
          "SEPHEK: (a voice like a glacier moving) STAND STILL."])
    say(["Two winter wolves lope out of the blizzard at his call."])
    return false if !boss_battle(named_mon(:B59H272, 64, "Winter Wolf"), named_mon(:B59H272, 64, "Winter Wolf"))
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
          cl(:alberica, "(her rune prickling) I dreamed this door. Before the Chasm. Before any of it."),
          cl(:meat_meat, "Meat Meat smells hot metal. Under ice. That is wrong."),
          cl(:reptin, "(quietly) Everyone stay close. And nobody touch anything that hums.")])
  end

  def vault_door(event_id = nil)
    return say(lines_for(:vault_gate_open), event_id) if flag?(:vault_door_open)
    say(lines_for(:vault_gate_shut), event_id)
    if !flag?(:sigils_merged)
      return say(["The hollows are cold and empty. It wants three sigils, made one."])
    end
    if !flag?(:vault_eye_open)
      return if !pbConfirmMessage(_INTL("Press the Seraph Sigil into the frozen eye?"))
      vault_pendant_returns
    end
    return if !flag?(:vault_door_unlocked) && !vault_pendant_turns
    # the sentinels step out of the door on the map (notes 12 E11)
    door = event_id ? $game_map.events[event_id] : nil
    dx, dy = door ? [door.x, door.y] : [$game_player.x, $game_player.y - 2]
    sents = [-1, 1].map { |o| Stage.actor(:mirror_sentinel, dx + o, dy, 2, graphic: "Followers/AEGISLASH") }.compact
    sents.each { |e| e.opacity = 0 }
    8.times { |i| sents.each { |e| e.opacity = 25 * (i + 1) }; Stage.wait(2) }
    sents.each { |e| Stage.walk(e, PBMoveRoute::Down, wait_for: false) }
    Stage.wait(16)
    say(["Behind the door, two things of mirror and iron stir: Mirror Sentinels, helmed and hollow."])
    won = boss_battle(named_mon(:B449H227, 72, "Mirror Sentinel"), named_mon(:B449H227, 72, "Mirror Sentinel"))
    if !won
      sents.each { |e| Stage.remove_actor(e) }
      return
    end
    sents.each { |e| Stage.fx("E-06", e, frames: 10, oy: 16, wait: false) rescue nil }
    Stage.wait(20)
    sents.each { |e| Stage.remove_actor(e) }
    say(["The sentinels come apart into plates of glass and lie still.", "The door of wings stands open."])
    set_flag(:vault_door_open)
    set_self_switch(event_id, "A") rescue nil
    $game_map.need_refresh = true if $game_map
  end

  # The sigils wake the door; the pendant opens it (owner's decision 4). The
  # pendant cracked in Lonelywood and was gone; it has always come back (she
  # threw it in the sea once), and at Gran's door, it does.
  def vault_pendant_returns
    al = herald?(:alberica)
    say(["The sigil sinks into the ice. The frozen eye opens, and looks at #{al ? 'you' : 'Alberica'}.",
         "Under the eye, a hollow in the door: a teardrop, the size of a pendant."])
    say([al ? "Frost gathers in the hollow of your throat, and hardens." : "Frost gathers in the hollow of Alberica's throat, and hardens.",
         "And it's there: the Pendant of Black Ice."])
    cline(:alberica, "I threw you in the sea once. You came back. Of course you came back.", "...Of course you came back.")
    give_key(:FT_BLACKPENDANT) if al rescue nil      # (yours to carry when you are her)
    set_flag(:vault_eye_open)
    set_flag(:pendant_returned)
  end

  # Returns true once the door of wings is unlocked.
  def vault_pendant_turns
    al = herald?(:alberica)
    q = al ? _INTL("Set your pendant in the door?") : _INTL("Alberica holds the pendant up to the door. Let her?")
    if !pbConfirmMessage(q)
      cline(:alberica, "(lowering it) Not yet. Gran kept it shut for longer than this.", "...Not yet.")
      return false
    end
    say(["#{al ? 'You set' : 'Alberica sets'} the pendant in the hollow. It fits like it was cut for it. It was.",
         "The door of wings swings inward, very slowly, with a sound like ice letting go of a ship."])
    set_flag(:vault_door_unlocked)
    cline(:alberica, "(very quietly) Somewhere south, Ironhollow just felt that. My village.", "...Ironhollow felt that.")
    true
  end

  # The Mirror Circuits: Avarice, only in the mirrors; three circuits feed her cradle.
  VAULT_CIRCUITS = %i[circuit_north circuit_east circuit_west]

  AVARICE_BGM = "Powerplant & Pokemon Mansion Remix"    # the lab under the ice: her music
  AVARICE_BATTLE_BGM = "BW2_Ghetsis Battle"             # a villain's fight, not a gym leader's
  VAULT_PANES = [[14, 9], [18, 9], [14, 15], [18, 15]]     # the maze-panes on the Circuits map

  # Avarice in every mirror (notes 12 E4, dialogue 12 Top 1): the light goes
  # cold, her face fills the panes, her music comes in, and each whisper gets
  # its Herald's answer. Her case is aimed at the ending you chose.
  def scene_vault_circuits
    return if flag?(:circuits_seen)
    set_flag(:circuits_seen)
    al = herald?(:alberica)
    say(["Machinery under the ice: mirror-glass pipes, brass wheels the size of houses, humming."])
    $game_screen.start_tone_change(Tone.new(-30, -15, 25, 140), 20) rescue nil
    pbBGMFade(1.0) rescue nil
    say(["Every mirror shows you. Then, one by one, every mirror shows her."])
    # (the nearer panes first, so her bubble lands on one you can see; the camera lifts to take them in)
    panes = VAULT_PANES.sort_by { |_x, y| -y }.map { |x, y| Stage.actor(:avarice, x, y, 2, graphic: "FT_avarice") }.compact
    Stage.pan_to($game_player.x, [$game_player.y - 4, 15].max)
    panes.each { |e| e.opacity = 0; Stage.turn_to(e) }
    8.times { |i| panes.each { |e| e.opacity = 18 * (i + 1) }; Stage.wait(2) }
    pbBGMPlay(AVARICE_BGM) rescue nil
    sayc(["White hair. Infernal sigils. A smile like arithmetic.",
          "AVARICE: (from every mirror at once) Variables that refused to die. How untidy.",
          nil])
    cline(:alberica, "(very still) We froze you. At her throne. We watched it hold.", "(very still) ...We froze you.")
    sayc([al ? "AVARICE: You froze a mirror, songbird. Did you think I kept only one?" :
               "AVARICE: You froze a mirror, Alberica. Did you think I kept only one?",
          "AVARICE: A little of me lived in every mirror I made. A little is all I've ever needed."])
    if with_or_is?(:meat_meat)
      say([herald?(:meat_meat) ? "(She says your number. V-7. Then, softly, the sound you made the day you were born.)" :
                                 "AVARICE: (to Meat Meat) V-7. I still have the sound you made the day you were made."])
      cline(:meat_meat, "(very quiet, very fast) Meat Meat's name is Meat Meat.", "...Meat Meat's name is Meat Meat.")
    end
    if with_or_is?(:alerion)
      say(["AVARICE: (to Alerion) The boy in the lake. Who taught you to call him back?"])
      cline(:alerion, "Talion did.")
    end
    if with_or_is?(:reptin)
      say(["AVARICE: (to Reptin) And the wolf. I heard it bite, through a puddle."])
      cline(:reptin, "(smiling) Listening at puddles. How lonely for you.")
    end
    if with_or_is?(:wyn)
      say(["AVARICE: (to Wyn) Little shadow. You'd make a lovely lens."])
      cline(:wyn, "(very quietly) ...Sableye doesn't like you. He's usually right.")
    end
    say(["AVARICE: Razzy's scale core. V-7's blood. And a season I can wind like a clock."])
    cline(:meat_meat, "Razzy's OLD scales. From the lab. Razzy is a DRAGON now.", "...Razzy's old scales. Razzy is a dragon now.")
    # her case, against the ending you chose (dialogue 12 §1a)
    sayc([flag?(:ending_shatter) ? "AVARICE: You broke a god for a sunrise. I'll build you a better one." :
          flag?(:ending_third_way) ? "AVARICE: You let winter go round again. Sloppy. I'd have put it on a schedule." : nil,
          "AVARICE: The Seraph-Draco. Ordered seasons. No Rime, no Summer. Just the schedule.",
          "AVARICE: Come to the cradle. You were always going to.",
          cl(:meat_meat, "Meat Meat is coming. Meat Meat is bringing her teeth.")])
    8.times { |i| panes.each { |e| e.opacity = 144 - 18 * (i + 1) }; Stage.wait(2) }
    panes.each { |e| Stage.remove_actor(e) }
    Stage.pan_back
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 20) rescue nil
    Stage.theme(nil)
    # what the circuits do, always (notes 12 E9): the map pieces only say where
    if vault_map_pieces >= 3
      say(["(The three map pieces fit together: three circuits feed the cradle. North, east, west.)"])
    else
      say(["(The machinery runs in three great circuits. Each one hums toward the far door.)"])
    end
    say(["(Break them, and whatever's waiting in the cradle will be weaker for it.)"])
  end

  def vault_circuit(key, event_id = nil)
    return say(lines_for(:vault_circuit_dead), event_id) if flag?(key)
    say(["A ring of mirror-glass turning inside a ring of brass. In every pane, her face, smiling."], event_id)
    return if relic_stops_circuit(key)
    return if !pbConfirmMessage(_INTL("Break the circuit?"))
    ring = event_id ? $game_map.events[event_id] : nil
    wr = ring ? Stage.actor(:wraith, ring.x, ring.y + 1, 2, graphic: "Followers/MISMAGIUS_fly") : nil
    wr.opacity = 170 if wr
    say(["The panes turn toward you. Ink runs out of them and stands up: a Mirror-Ink Wraith."])
    won = boss_battle(named_mon(:B429H200, 71, "Mirror-Ink Wraith"))
    Stage.fx("E-09", wr, frames: 9, oy: 16) rescue nil if wr && won
    Stage.remove_actor(wr) if wr
    return if !won
    say(["The wraith spatters across the ice. The ring grinds to a stop, its mirrors going dark."])
    set_flag(key)
    left = VAULT_CIRCUITS.count { |k| !flag?(k) }
    say([left == 0 ? "(All three circuits are dark. Far off, something in a cradle stops humming.)" :
                     "(#{left} circuit#{left == 1 ? '' : 's'} still turning.)"])
  end

  # The Seraph Cradle (notes 12 E10, E16, E17, E22): Avarice is the event on
  # the map, so her lines bubble on her; the needle, the ward and the crack are
  # shown; the core is given after the moment that gives it; a retry is short.
  def scene_vault_cradle(event_id = nil)
    return if flag?(:avarice_body_broken)
    mm = herald?(:meat_meat)
    av = event_id ? $game_map.events[event_id] : stage_event("Avarice")
    av.character_name = "FT_mira_possessed" if av && flag?(:mira_left_possessed) rescue nil
    if flag?(:cradle_seen)
      say(["AVARICE: Again? I do love a repeatable experiment."], event_id)
    else
      if flag?(:mira_left_possessed)
        # rootspire.md 1079: left possessed, Mira becomes Avarice's new body.
        sayc(["A cradle of brass and mirror at the heart of the glacier.",
              "In it, Mira of the North Wind sits up. Her black hair has gone white.",
              "Her skin is turning to crystal, from the fingertips in.",
              "AVARICE: (in Mira's voice) You left her to me. On her own ship. Her daughter watching.",
              herald?(:meat_meat) ? "(You remember. You said you would.)" : cl(:meat_meat, "(white to the lips) Meat Meat said. Meat Meat SAID she would remember.")], event_id)
        Stage.hop(av) if av
        sayc(["Mira's body stands. Machinery unfolds around it like a dress being fitted."], event_id)
      else
        say(["A cradle of brass and mirror at the heart of the glacier."], event_id)
        Stage.hop(av) if av
        say(["In it, a woman of crystal sits up, framed in machinery. She's smiling like a sum."], event_id)
      end
      case_ev = stage_event("Case of ice")
      Stage.pan_to(case_ev.x, case_ev.y + 2) if case_ev
      sayc(["Behind her, in a case of ice, a crystal grown round green scales: RAZ-MKIII.",
            "AVARICE: (stretching, with a sound like a chandelier) There you are. Right on time."], event_id)
      Stage.pan_back if case_ev
      if with_or_is?(:meat_meat)
        mev = mm ? $game_player : Stage.summon(:meat_meat)
        Stage.fx("E-07", mev, frames: 8, oy: 16, wait: false) rescue nil if mev   # the needle's glint
        sayc([mm ? "A needle of mirror-glass slides out of the cradle toward your arm." :
                   "A needle of mirror-glass slides out of the cradle toward Meat Meat's arm.",
              "AVARICE: A drop. Only a drop, V-7. You owe me at least that.",
              mm ? "(You bite the needle in half.)" : "MEAT MEAT: (biting the needle in half) Meat Meat owes you NOTHING."], event_id)
        if with_or_is?(:reptin) && !herald?(:reptin) && mev
          rep = Stage.summon(:reptin)
          Stage.walk_to(rep, mev.x, mev.y - 1, face: 8) if rep && !mm
        end
      end
      sayc([cl(:reptin, "(stepping in front of her) No. Not her. Ask me instead.")], event_id)
      cline(:alerion, "You faked your death to hide in an icebox. Come out.", "...Come out.")
      say(["AVARICE: Oh, I'll come out."], event_id)
      verdant_blade_cuts_ward
      # what the rings did (notes 12 E9): the player sees the circuits pay
      dark = VAULT_CIRCUITS.count { |k| flag?(k) }
      if dark > 0
        say(["(#{dark == 3 ? 'All three' : dark == 2 ? 'Two' : 'One'} of her rings #{dark == 1 ? 'is' : 'are'} dark. " \
             "Her body flickers where #{dark == 1 ? 'it' : 'they'} fed it.)"])
      end
      set_flag(:cradle_seen)
      trainer_intro(:avarice_vault, event_id)
    end
    circuits = VAULT_CIRCUITS.count { |k| flag?(k) } + (flag?(:blade_cut_ward) ? 1 : 0)
    type, name = TRAINERS[:avarice_vault]
    $ft_avarice_circuits = circuits
    ($PokemonGlobal.nextBattleBGM = pbStringToAudioFile(AVARICE_BATTLE_BGM)) rescue nil
    won = pbTrainerBattle(type, name, nil, false, 0) ? true : false
    ($PokemonGlobal.nextBattleBGM = nil) rescue nil
    $ft_avarice_circuits = 0
    return if !won
    Stage.fx("E-06", av, frames: 10, oy: 16) rescue nil if av
    say(["Her crystal body cracks across, from the crown down.",
         "Something pours out of it that isn't light: her, a smear of mirror, fleeing into glass."])
    if flag?(:mira_left_possessed)
      sayc(["What's left in the cradle is Mira, or most of her: crystal to the elbows, breathing.",
            "MIRA: (one voice, very small) ...Is my girl warm? Somebody tell me she's warm.",
            cl(:alberica, "(taking her crystal hands) She's warm. She's on the ship. She's waiting."),
            "Mira never sails again. But she lives."], event_id)
      set_flag(:mira_freed_late)
    elsif av
      av.opacity = 110                                   # (what stands there now is her reflection)
    end
    soul = named_mon(AVARICE_SOUL, 76, "Avarice's Reflection")
    broken = circuits
    if flag?(:chapel_avarice)
      # (the Silent Chapel: you answered the fire, and a door you open stays open)
      say(["AVARICE'S REFLECTION: (warmly) You answered me once, in my little chapel.",
           "AVARICE'S REFLECTION: Leave the engine running, I said. You listened.",
           "AVARICE'S REFLECTION: A door you open for me stays open, failures."])
      broken = [circuits - 1, 0].max
    end
    soul.hp = [(soul.totalhp * (1.0 - 0.2 * broken)).floor, 1].max
    caught = boss_battle(soul)
    if caught
      Stage.fx("E-06", av, frames: 10, oy: 16) rescue nil if av
      av.opacity = 0 if av && !flag?(:mira_left_possessed)
      sayc(["Her reflection shatters, and every splinter of it goes dark.",
            "AVARICE: (very small, from no mirror at all) ...Recalculating..."])
    else
      av.opacity = 0 if av && !flag?(:mira_left_possessed)
      sayc(["Her reflection slides deep into the glacier, laughing. Frostina breathes after it,",
            "and the ice closes over it a mile thick. It doesn't thaw."])
    end
    case_ev = stage_event("Case of ice")
    Stage.fx("E-06", case_ev, frames: 10, oy: 16) rescue nil if case_ev
    case_ev.opacity = 0 if case_ev
    if flag?(:scale_core_given)
      sayc(["The case of ice cracks open. Empty, but for a label in a neat white hand:",
            "RAZ-MKIII CORE. RECOVER FROM THE CORSAIRS.",
            cl(:meat_meat, "(patting her pack) Mira gave it to Meat Meat. She never got it back. Ha.")])
    else
      say(["The case of ice cracks open. A crystal core drops into your hands.",
           "Green wyrmling scales, grown into crystal. RAZ-MKIII. It's warm."])
      give_key(:FT_SCALECORE)
      sayc([cl(:meat_meat, "(hugging it) Razzy's. From the cold table. Meat Meat keeps this. Forever.")])
      set_flag(:scale_core_given)
    end
    sayc([cl(:alberica, "Why do the clever ones never stay dead?"),
          caught ? cl(:wyn, "...It's quiet down here now. She's stopped counting.") :
                   cl(:wyn, "(very quietly) ...Like spores. You never get all of them.")])
    set_flag(:avarice_revealed)
    set_flag(:avarice_body_broken)
    set_flag(:avarice_soul_shattered) if caught
    set_switch(SW_VAULT_BROKEN, true)
    add_counter(:story_beats)
    side_goal_done(:vault)
  end

  #-----------------------------------------------------------------------------
  # The Throne of Frost: what's left of Avarice comes for what's left of Auril
  #-----------------------------------------------------------------------------
  def avarice_at_the_throne
    return if flag?(:avarice_ended)
    if flag?(:avarice_body_broken)
      sayc(["In the ice wall, a splinter of mirror catches the diamond's light. A face moves in it.",
            "AVARICE: (thin as a draught) A god in a gem. The last variable. Give it to me, failures.",
            "The splinter strains toward the diamond. It has nothing left to strain with."])
      sayc([herald?(:meat_meat) ? "(You walk over, and step on it.)" : (with_or_is?(:meat_meat) ? "Meat Meat walks over, and steps on it." : "You walk over, and step on it."),
            "It goes out like a spark in snow.",
            cl(:meat_meat, "That is for Razzy's voice. Meat Meat is DONE.")])
    else
      sayc(["Behind the throne the ice wall turns to a mirror, and she steps out of it."])
      av = (Stage.actor(:avarice, $game_player.x + 1, $game_player.y - 4, 2, graphic: "FT_avarice_reforged") rescue nil)
      Stage.fx("E-06", av, frames: 10, oy: 16) rescue nil if av
      sayc(["A woman of crystal in machinery: white hair, infernal sigils, a smile like arithmetic.",
            herald?(:alberica) ? "You're on your knees. You don't believe it. (No. No, we watched you burn.)" :
                                 cl(:alberica, "(on her knees, not believing it) No. No, we watched you burn."),
            # the one secret you kept alone (Ch8, "Nobody else noticed"), come due (context 13 M13-5)
            flag?(:avarice_doubt) ? "You knew. You saw her arms in the Forge, bare, and you never said." : nil,
            flag?(:mira_left_possessed) ? "AVARICE: (in Mira's voice) You watched a coat burn. I had another: you left her for me." :
                                          "AVARICE: You watched a coat burn. I keep a wardrobe.",   # (dialogue 12 §4)
            "AVARICE: A god in a gem. The last variable. Thank you for weighing her out for me."])
      trainer_intro(:avarice_reforged)          # (notes 12 E21: her last line before the fight)
      type, name = TRAINERS[:avarice_reforged]
      $ft_avarice_circuits = 0
      ($PokemonGlobal.nextBattleBGM = pbStringToAudioFile(AVARICE_BATTLE_BGM)) rescue nil
      won = pbTrainerBattle(type, name, nil, false, 0, true) ? true : false
      ($PokemonGlobal.nextBattleBGM = nil) rescue nil
      pbFadeOutIn { $Trainer.heal_party } rescue nil
      if won
        Stage.fx("E-06", av, frames: 10, oy: 16) rescue nil if av
        say(["Her crystal body cracks from the crown down. Her reflection runs out of it into the ice.",
             "Frostina breathes on the ice. It freezes solid round the reflection, and doesn't thaw."])
      else
        say(["She reaches for the diamond. Razzilith gets there first and bites off her hand.",
             "Frostina breathes on the ice wall, and the mirror freezes solid with her in it."])
      end
      Stage.fx("E-04", av, frames: 10, oy: 16) rescue nil if av
      Stage.remove_actor(av) if av
      # Razzy's voice, paid at last (dialogue 12 §1a: the short branch can't play on the main path now)
      sayc([cl(:meat_meat, "(to the ice) That is for Razzy's voice. Meat Meat is DONE.")])
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
    relic_tiles
  end
end

# Avarice Reforged: her crystal body is weaker for every circuit you broke.
module FrostThaw
  TRAINERS[:avarice_reforged] = [:FT_AVARICE_R, "Avarice", [[:B449H124, 64], [:B275H429, 65], [:B227H449, 65], [:B92H122, 66], [AVARICE_BODY, 68]],
                                 "Variables. Always variables. ...Recalculating."]
  # The postgame Vault: her last body, past the final battle's levels.
  TRAINERS[:avarice_vault] = [:FT_AVARICE_R, "Avarice", [[:B449H124, 74], [:B275H429, 75], [:B227H449, 75], [:B92H122, 76], [AVARICE_BODY, 78]],
                              "Variables. Always variables. ...Recalculating."]
end

if Events.respond_to?(:onTrainerPartyLoad)
  Events.onTrainerPartyLoad += proc { |_sender, e|
    begin
      trainer = e.is_a?(Array) ? e[0] : e
      # her crystal body (the last of her party) has a picture of its own
      if trainer && trainer.name == "Avarice" && trainer.trainer_type.to_s == "FT_AVARICE_R" && (last = trainer.party.last) &&
         last.species == FrostThaw::AVARICE_BODY
        last.instance_variable_set(:@ft_picture, "FT_AVARICE_BODY")
      end
      n = $ft_avarice_circuits.to_i
      if n > 0 && trainer && trainer.name == "Avarice" && FrostThaw.flag?(:vault_entered)
        trainer.party.each { |pk| pk.hp = [(pk.totalhp * (1.0 - 0.15 * n)).floor, 1].max }
      end
    rescue StandardError => err
      FrostThaw.log("Avarice's circuits failed: #{err.message}")
    end
  }


end

module FrostThaw
  module_function
  #-----------------------------------------------------------------------------
  # The Relics of the Future Past as keys and resonant foci in the White Vault
  # (rootspire.md 1869-1871): each circuit answers to one Herald's relic, if
  # it's in the bag or held by a Pokémon. A relic stills its ring without the
  # wraith; the Verdant Blade, at the cradle, cuts one of her mirror-wards.
  #-----------------------------------------------------------------------------
  CIRCUIT_RELICS = {
    circuit_west:  [:FT_HEARTWARDENSTAFF, :reptin,
                    ["The Heartwarden's Staff wakes. Its roots reach for the brass, find it, and close.",
                     "The ring grinds, strains, and stops, held fast in living wood.",
                     "Somewhere a tree four hundred years away leans, very slightly, toward you."]],
    circuit_east:  [:FT_RIMEMANTLE, :alerion,
                    ["The Rime Mantle's frost answers the mirror-frost. Cold to cold: the panes fog white.",
                     "Her face goes out of every pane at once.",
                     "A ring of mirrors that can't see itself doesn't know which way to turn."]],
    circuit_north: [:FT_WHISPERKEY, :alberica,
                    ["The Whisper Key hums, then fits the ring's empty heart as if it was cut for it.",
                     "A turn, a held note. The ring remembers it was only brass and glass once, and stops."]]
  }

  def relic_owned?(item)
    return true if ($PokemonBag.pbHasItem?(item) rescue false)
    ($Trainer.party.any? { |pk| pk.item_id == item rescue false }) ? true : false
  end

  def relic_stops_circuit(key)
    item, who, lines = CIRCUIT_RELICS[key]
    return false if !item || !relic_owned?(item)
    name = (GameData::Item.get(item).name rescue item.to_s)
    owner = herald?(who) ? "Your" : "#{COMPANION_NAMES[who].to_s.split.map(&:capitalize).join(' ')}'s"
    say(["#{owner} #{name} stirs. It knows this ring."])      # (whose it is: first-time player 11)
    return false if !pbConfirmMessage(_INTL("Hold the {1} to the circuit?", name))
    say(lines)
    sayc([cl(who, who == :reptin ? "(very quietly) Steady. Hold. That's all a root ever does." :
                  who == :alerion ? "Let her look for herself in the fog." :
                                    "(turning the key) Keys open. They also lock. A goddess told me that.")].compact)
    set_flag(key)
    set_flag(:"#{key}_by_relic")
    left = VAULT_CIRCUITS.count { |k| !flag?(k) }
    say([left == 0 ? "(All three circuits are dark. Far off, something in a cradle stops humming.)" :
                     "(#{left} circuit#{left == 1 ? '' : 's'} still turning.)"])
    true
  end

  # The Verdant Blade at the cradle: Meat Meat's relic cuts one ward.
  def verdant_blade_cuts_ward
    return 0 if !relic_owned?(:FT_VERDANTBLADE)
    sayc(["The Verdant Blade warms in #{herald?(:meat_meat) ? 'your' : "Meat Meat's"} hand. Its mirrored steel shows no face at all.",
          "#{herald?(:meat_meat) ? 'You cut' : 'Meat Meat cuts'} a mirror-ward round the cradle. It falls like water and stays down.",
          cl(:meat_meat, "Meat Meat's blade. Meat Meat's rules. No mirrors.")].compact)
    set_flag(:blade_cut_ward)
    1
  end

  #-----------------------------------------------------------------------------
  # Var's mirror-shard glaive "resonates if Sephek appears" (rootspire.md 833).
  #-----------------------------------------------------------------------------
  def glaive_resonates
    return if !flag?(:var_glaive) && !relic_owned?(:FT_VARGLAIVE)
    key = flag?(:frostina_taken) ? :glaive_hummed_crown : :glaive_hummed_shrine
    return if flag?(key)
    set_flag(key)
    say(["Var's mirror-shard glaive hums in your pack: the same note as the frost in Sephek's chest.",
         flag?(:var_story_known) ? "Var forged it to cut a frost-touched thing. Thirty years on, it still remembers what for." :
                                   "Whoever forged it meant it for something like him."])
    sayc([cl(:alerion, "(very quietly) It knows him. So do I.")].compact)
  end

  #-----------------------------------------------------------------------------
  # Eline (rootspire.md 1020-1024): "if captured she speaks only in reversed
  # prayer"; "final foe or tragic martyr depending on mercy".
  #-----------------------------------------------------------------------------
  def eline_mercy(won)
    if !won
      set_flag(:eline_unbeaten)          # she rides north with him, and stands with him at the end
      return
    end
    c = pbMessage(_INTL("Eline looks up at you, her hands open."),
                  [_INTL("Show her mercy"), _INTL("Bind her for the Rootwardens")], 0)
    if c == 0
      set_flag(:eline_spared)
      say(["You step back. Eline looks up, and for a moment she doesn't understand.",
           "ELINE: (slowly) ...Silence is mercy. I taught it for years. I never once felt it.",
           "She gets up, and goes to stand beside him again. But she doesn't raise her hands."])
    else
      set_flag(:eline_captured)
      say(["Rootwardens come up the steps with cords of woven root. Eline doesn't fight them.",
           "She prays the whole way down. It takes you a while to hear that every word runs backwards.",
           "ELINE: ...hcaer ruoy dnoyeb ylno si ecnelis. ...ecnelis, ecnelis, ecnelis."])
      sayc([cl(:wyn, "(very quietly) She's saying it backwards so the goddess can't hear her asking. I think."),
            cl(:alberica, "Or so we can't. Either way, darling, somebody should sit with her.")].compact)
    end
  end

  # At the Crown: Eline's end, depending on mercy. Unbeaten, she is the last of
  # his followers (a final foe). Spared, she dies for him (a tragic martyr).
  def eline_at_the_crown(stage)
    return if flag?(:eline_captured) || flag?(:eline_fate)
    if stage == :before && flag?(:eline_unbeaten)
      el = (eline_actor rescue nil)
      sev = stage_event("Sephek")
      Stage.walk_to(el, sev.x, sev.y + 1) if el && sev
      say(["ELINE: (stepping between you and him) No further. I carried his heart up a mountain.",
           "ELINE: I'll carry it up this one.",
           "ELINE: Silence is mercy, and I've been merciful long enough."])
      type, name = TRAINERS[:eline_sephek]
      if pbTrainerBattle(type, name, nil, false, 0, true)
        say(["Eline falls back against the crystal. The frost on her hands goes out like a candle.",
             "ELINE: (to Sephek, very softly) I'm sorry. I was so sure."])
        set_flag(:eline_fate)
        set_flag(:eline_final_foe)
      end
    elsif stage == :after && flag?(:eline_spared)
      # the wave comes from the throne-room door, and she walks into it on screen (notes 13 E4)
      el = (eline_actor rescue nil)
      say(["Cold rolls out under the throne-room door in one last wave, at all of you, at him."])
      $game_screen.start_flash(Color.new(230, 245, 255, 220), 16) rescue nil
      Stage.walk(el, PBMoveRoute::Up) if el
      say(["Eline steps into it. She doesn't say anything at all."])
      if el
        Stage.fx("E-04", el, frames: 10, oy: 16) rescue nil
        el.opacity = 150
      end
      sayc(["When it passes, she's kneeling where she stood, frosted white to her open hands.",
            "She doesn't get up.",
            "SEPHEK: (on his knees beside her) ...Eline. Eline, you didn't have to. You never had to.",
            cl(:wyn, "(very quietly) She chose. Somebody let her, once."),
            cl(:alberica, "(quietly) ...Somebody should sit with her. After.")])
      set_flag(:eline_fate)
      set_flag(:eline_martyred)
    end
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_white_vault_switches
  rescue StandardError => err
    FrostThaw.log("White Vault switches failed: #{err.message}")
  end
}

# The Pendant of Black Ice, the Vault's key (owner's decision 4): registered on
# its own number after the relics, so no other item's number moves.
module GameData
  class << self
    alias ft_vault_load_all load_all unless method_defined?(:ft_vault_load_all)
    def load_all
      ft_vault_load_all
      begin
        n = FrostThaw::VAULT_KEY_ITEM_NUMBER
        FrostThaw::VAULT_KEY_ITEMS.each do |id, (name, plural, pocket, price, desc, field, battle, type)|
          it = GameData::Item.new(id: id, id_number: n, name: name, name_plural: plural, pocket: pocket,
                                  price: price, description: desc, field_use: field, battle_use: battle, type: type)
          it.define_singleton_method(:name) { name }
          it.define_singleton_method(:name_plural) { plural }
          it.define_singleton_method(:description) { desc }
          GameData::Item::DATA[id] = it
          GameData::Item::DATA[n] = it
          n += 1
        end
      rescue StandardError => e
        FrostThaw.log("Vault key items failed: #{e.message}")
      end
    end
  end
end

# After the Wall falls, the map that was "Beyond the Auroral Wall" is where it
# stood (context 13 M13-8; WRITING_GUIDE §9: all depictions of a place agree).
if defined?(pbGetMapNameFromId)
  alias ft_vault_pbGetMapNameFromId pbGetMapNameFromId unless defined?(ft_vault_pbGetMapNameFromId)
  def pbGetMapNameFromId(id)
    return "Where the Wall Stood" if id == 2163 && (FrostThaw.active? && FrostThaw.flag?(:game_complete) rescue false)
    ft_vault_pbGetMapNameFromId(id)
  end
end
