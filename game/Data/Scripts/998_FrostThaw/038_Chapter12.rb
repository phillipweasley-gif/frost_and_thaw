#===============================================================================
# Frost & Thaw - Act III, Chapter 12: The Sea of Moving Ice (script SC 12.01-12.06)
#
# Reach Solstice and get inside Grimskalle.
#
#   12.01 One more battle: Tamsin, at your departure point
#   12.02 Fog and masts: the voyage (ship, griffons, whale, or Lumin's bell)
#   2079  Solstice: the ice dock (12.03, Sopo) and the climb to the skull
#   2080  The Statue Fields (12.04): cross without touching a statue
#   2081  The Garden of Death (12.05): the ice troll; Nass and Professor Skant
#   2082  The Grimskalle Gate (12.06): Ukuma on his rink
#===============================================================================
module FrostThaw
  SW_DOCK_CLEARED = 3996
  SW_TROLL_DOWN   = 3997
  SW_FIELDS_ROPE  = 3906   # the Statue Fields are crossed: a rope back up from the entrance
  SW_UKUMA_RACED  = 3998

  MAPS.merge!(solstice: 2079, statue_fields: 2080, garden_of_death: 2081, grimskalle_gate: 2082)
  MAP_NAMES.merge!(2079 => "Solstice", 2080 => "The Statue Fields", 2081 => "The Garden of Death", 2082 => "The Grimskalle Gate")
  MAP_METADATA.merge!(
    2079 => { outdoor_map: true, announce_location: true, battle_environment: :Snow, weather: [:Snow, 100] },
    2080 => { announce_location: true, battle_environment: :Ice },
    2081 => { announce_location: true, battle_environment: :Ice },
    2082 => { announce_location: true, battle_environment: :Ice }
  )
  AREAS.merge!(2079 => :solstice, 2080 => :solstice, 2081 => :solstice, 2082 => :solstice)
  SOLSTICE_DOCK = [2079, 19, 56, 8]

  ENCOUNTERS[2079] = { step_chances: { Land: 10 },
                       Land: [[25, :SNEASEL, 56, 58], [20, :PILOSWINE, 56, 58], [20, :DELIBIRD, 56, 58],
                              [15, :GLALIE, 57, 59], [10, :WEAVILE, 58, 60], [10, :MAMOSWINE, 58, 60]] }
  ENCOUNTERS[2081] = { step_chances: { Cave: 8 },
                       Cave: [[30, :HAUNTER, 57, 59], [25, :DUSCLOPS, 57, 59], [20, :SNEASEL, 57, 59],
                              [15, :GLALIE, 58, 60], [10, :MISDREAVUS, 58, 60]] }

  TRAINER_TYPES.merge!(FT_MEPHIT: ["Ice Mephit", :CHANNELER, 0, 100])
  TRAINERS.merge!(
    sopo: [:FT_MEPHIT, "Sopo", [[:SNORUNT, 56], [:GLALIE, 57], [:B361H215, 57], [:B362H124, 59]],
           "No, no, no! You were supposed to fall into a hole!"]
  )
  TRAINER_INTROS.merge!(sopo: "SOPO: Visitors! I'm a guide. I guide people into holes, mostly!")

  TEXT.merge!(
    ice_statue: ["An ice sculpture, too perfect for any hand.",
                 "Every whisker. Every feather. Every scale. Don't touch it."],
    garden_block: ["Someone sealed upright in a block of clear ice.", "Their eyes are open."],
    ukuma_after: ["UKUMA: (sliding past) Guarding! Still guarding. Very, very busy."],
    sopo_after: ["SOPO: (from a safe distance, giggling) She's expecting you! She's expecting EVERYONE!"],
    grimskalle_jaw: ["The skull's jaw is a gate, and the gate stands open.",
                     "Cold breathes out of it, like a breath someone has held for a very long time."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # SC 12.01 - One more battle (at the departure point)
  #-----------------------------------------------------------------------------
  def departure(where, event_id = nil)
    if !flag?(:ch11_done)
      return say(["(Not yet. Not until everyone's ready.)"], event_id)
    end
    if voyage_route != where && !(where == :whale && voyage_route == :bell)
      return say([{ ship: "The Boreal Requiem rides at her moorings. Nobody aboard is going anywhere today.",
                    griffons: "The griffon roost is quiet. The griffons look at you like you're lunch.",
                    whale: "The Wennen bell hangs over the black water, silent." }[where]], event_id)
    end
    tamsin_final if !flag?(:rival_final)
    return if !flag?(:rival_final)
    return if !pbConfirmMessage(_INTL("Set out for Solstice?"))
    voyage
  end

  def tamsin_final
    sayc(["TAMSIN: (blocking the way, their Rootwarden cloak on crooked) Hold it. HOLD it.",
          "TAMSIN: You're going to fight a GOD. With THAT team? Not without one more battle first.",
          cl(:alberica, "Look at them. All grown up and threatening people. I could cry."),
          cl(:reptin, "They mean they'll miss us. That's how Tamsin says it."),
          "TAMSIN: I mean I'll WIN."])
    if journey?
      say(["TAMSIN: Also. That's you. On Hellen's wall. The sixth figure.",
           "TAMSIN: I've known since you fell out of the lantern. I just wanted you to say it."])
      c = pbMessage(_INTL("The sixth figure..."), [_INTL("Nod"), _INTL("Say nothing")], 0)
      if c == 0
        say(["TAMSIN: ...I KNEW it. I knew it, I knew it, I KNEW it."]); set_flag(:told_tamsin)
      else
        say(["TAMSIN: Fine. Be mysterious. You're still on my wall."])
      end
    end
    mine = state[:starter]
    ace = { B7H220: :B330H152, B330H152: :WICKIT, WICKIT: :B7H220 }[mine] || :B330H152
    ace_final = { B330H152: :B331H154, WICKIT: :FORGEL, B7H220: :B9H221 }[ace] || ace
    key = [:FT_TAMSIN_I, "Tamsin", 2]
    mons = [{ species: :FURRET, level: 58 }, { species: :JUMPLUFF, level: 58 }, { species: :B184H241, level: 59 },
            { species: :B38H128, level: 59 }, { species: :B149H143, level: 59 }, { species: ace_final, level: 60 }]
    GameData::Trainer::DATA[key] = GameData::Trainer.new({ id: key, id_number: 9893, trainer_type: :FT_TAMSIN_I, name: "Tamsin",
                                                           version: 2, items: [:FULLRESTORE], lose_text: "Okay. Okay! You can go.", pokemon: mons })
    # (a send-off, not a wall: win or lose, she lets you go)
    won = pbTrainerBattle(:FT_TAMSIN_I, "Tamsin", nil, false, 2, true) ? true : false
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_flag(:rival_final)
    set_flag(:beat_tamsin_final) if won
    add_counter(:story_beats)
    if won
      say(["TAMSIN: (after) Okay. Okay! You can go.",
           "TAMSIN: Come back and tell me everything. Every single thing. In order."])
    else
      say(["TAMSIN: (after, very quietly) ...Huh. I didn't think I'd actually win.",
           "TAMSIN: That's worse. That's so much worse. Train on the boat. Please."])
    end
    sayc([cl(:meat_meat, "Meat Meat will train. Meat Meat will train SO hard. After coffee."),
          cl(:alerion, "You said that last time."),
          "HELLEN: (packing food into every bag you own) Nobody saves the Dale on an empty stomach.",
          "HELLEN: Eat first. Then heroics.",
          cl(:wyn, "...Um. I packed blankets. Extra ones. For after.")])
    give(:FULLRESTORE, 3) rescue nil
  end

  #-----------------------------------------------------------------------------
  # SC 12.02 - Fog and masts
  #-----------------------------------------------------------------------------
  def voyage
    case voyage_route
    when :ship
      paid = flag?(:council_mira) ? nil : flag?(:council_heralds) ? "the Council's warrant" : "Darrus Fell's coin"
      if flag?(:mira_left_possessed)
        # (F3's branch: Mira was left possessed; her first mate sails the Requiem)
        say(["The Boreal Requiem noses through the pack ice#{paid ? ", on #{paid}" : ''}.",
             "FIRST MATE: (at the wheel) Captain's below, talking to the mirrors again. I've got the ship.",
             "FIRST MATE: If you hear singing, that's the ice. If you hear laughing, don't go below."])
      else
        say(["The Boreal Requiem noses through the pack ice#{paid ? ", on #{paid}" : ''}.",
             paid ? "MIRA: (at the wheel) No chair on the Council for me. Still the Requiem's captain, though. Somebody has to be." : nil,
             "MIRA: If you hear singing, that's the ice. If you hear laughing, that's me.",
             "MIRA: Don't worry about either."].compact)
      end
      if flag?(:darrus_redeemed)
        say(["Down in the hold, a tiefling in a Corsair's coat is counting barrels. Twice.",
             "DARRUS: (not looking up) Every one paid for. Go on. Somebody has to keep count."])
      end
    when :griffons
      say(["Griffons, beating hard over a white sea.",
           flag?(:council_rheven) ? "RHEVEN: Don't look down. ...No. Actually, do. You'll never see anything like it again." :
                                    "KETHAN: (on the lead griffon) Don't look down. ...No. Do. Skytower's never flown this far north."])
    else
      if voyage_route == :bell
        say(["Nobody you elected has a ship, or a griffon, or a whale.",
             "Lumin rings Angajuk's bell anyway. With both paws. Very hard."])
      end
      say(["A whale two hundred years old rises under the bell pier, a boat strapped to his back.",
           "ANGAJUK: Climb on, small ones. I know her island. She took my eye."])
      if voyage_route == :bell
        say(["It's a long way, and the sea has teeth."])
        boss_battle(named_mon(:WALREIN, 57, "Walrein")) rescue nil
        boss_battle(named_mon(:CLOYSTER, 58, "Cloyster")) rescue nil
        pbFadeOutIn { $Trainer.heal_party } rescue nil
      end
    end
    say(["Fog comes down. The masts of sunken ships stand up out of it like dead trees."])
    speak(:alerion, "(at the rail) Every one of those was somebody.", "(at the rail) ...So many.")
    if with_or_is?(:reptin) && !herald?(:alerion)
      sayc([cl(:reptin, "He means: be careful."), "ALERION: I meant what I said."])
    end
    say(["The fog parts. An island of ice, shaped like a snowflake. Six jagged arms.",
         "On it, a mountain carved into a giant skull, wearing a crown."])
    sayc([cl(:meat_meat, "Meat Meat does not like the skull. The skull is showing off.")])
    speak(:alberica, "(the rune glowing) She knows we're here. She's watched us the whole way.",
          "(the rune glowing) ...Something's pulling me north. Don't make a thing of it.")
    sayc([cl(:reptin, "We noticed, darling. You've been glowing since breakfast. It's very festive.")])
    set_flag(:solstice_sighted)
    add_counter(:story_beats)
    state[:goal] = "Solstice. Up to the crowned skull."
    set_rest_at(SOLSTICE_DOCK)
    transfer(*SOLSTICE_DOCK)
  end

  # The camp on the dock: whatever brought you here waits. Rest, or go home for a while.
  def solstice_camp(event_id = nil)
    who = { ship: "The Boreal Requiem is tied up at the giants' dock, a stove going in the galley.",
            griffons: "The griffons have dug a hollow in the snow and are asleep in a heap.",
            whale: "Angajuk floats at the end of the dock, his boat still strapped to his back.",
            bell: "Angajuk floats at the end of the dock, his boat still strapped to his back." }[voyage_route]
    say([who], event_id)
    c = pbMessage(_INTL("What now?"), [_INTL("Rest"), _INTL("Go back to the Dale"), _INTL("Stay")], 2)
    if c == 0
      pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
      set_rest_at(SOLSTICE_DOCK)
      say(["You sleep a few hours out of the wind. Your Pokémon are rested."])
      solstice_camp_banter
    elsif c == 1
      say(["Back across the sea of moving ice.",
           "Rootspire will still be there when you come back. So will Solstice."])
      set_rest_at(HEARTH_REST)
      transfer(*HEARTH_REST)
    end
  end

  # The first night on Solstice: whoever's with you, round the camp stove.
  def solstice_camp_banter
    return if flag?(:solstice_camp_talk)
    lines = [cl(:meat_meat, "This island has no coffee. This island is dead to Meat Meat."),
             cl(:wyn, "...Um. I brought some. Mushroom. It's still a bit warm, if you hold it close."),
             (with_or_is?(:wyn) ? cl(:meat_meat, "Mushroom friend. Meat Meat will die for you. Tomorrow, probably.") : nil),
             cl(:alberica, "Nobody's dying tomorrow, sugar. I haven't finished my drink."),
             cl(:alerion, "You finished it an hour ago."),
             (with_or_is?(:alerion) ? cl(:alberica, "Then I'll pour another. Problem solved, pretty boy.") : nil)].compact
    return if lines.size < 3
    set_flag(:solstice_camp_talk)
    say(lines)
  end

  #-----------------------------------------------------------------------------
  # SC 12.03 - Sopo
  #-----------------------------------------------------------------------------
  def sopo(event_id = nil)
    return say(lines_for(:sopo_after), event_id) if flag?(:dock_cleared)
    sayc(["A ruined dock built for giants.",
          "A small grinning thing made of ice sits on a bollard, kicking its heels.",
          "SOPO: Visitors! Oh, VISITORS! I'm the guide. I guide people. Mostly into holes.",
          "SOPO: (cackling at nothing) She's expecting you! Everybody's expecting you. Even the dead ones!",
          cl(:reptin, "Charming. We'll find our own way, thank you."),
          cl(:meat_meat, "Meat Meat will bite it. Not fondly.")], event_id)
    help = flag?(:council_mira) || flag?(:corsair_favour) || voyage_route == :ship   # (the Requiem's crew came too)
    if help
      say(["A Corsair sloop slides out of the fog and grinds against the dock.",
           "Mira's people pile off, shouting, and fall on Sopo's pack.",
           "CORSAIR: Captain's compliments! The little ones are ours. The giggly one's yours."])
      return if !boss_battle(named_mon(:B362H124, 59, "Sopo"))
    else
      return if !pbTrainerBattle(:FT_MEPHIT, "Sopo", nil, false, 0)
    end
    set_flag(:dock_cleared)
    ($game_switches[SW_DOCK_CLEARED] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    say(["Sopo scrambles away up the ice, giggling.",
         "It follows you at a distance, and bolts whenever you turn around."])
  end

  #-----------------------------------------------------------------------------
  # SC 12.04 - Defilers
  #-----------------------------------------------------------------------------
  def scene_statue_fields
    return if flag?(:statue_fields_entered)
    set_flag(:statue_fields_entered)
    sayc(["A field of ice sculptures, too perfect for any hand.",
          "Bears. Elk. Sabertooths. Yetis. Dragons with their wings half open.",
          "Every whisker. Every feather. Every scale.",
          as(:meat_meat, "(whispering) Are they alive?"),
          cl(:alerion, "They were."),
          cl(:alberica, "Nobody touch anything. I mean it. Hands in pockets, sweethearts."),
          cl(:reptin, "Says the woman who has never once in her life kept her hands to herself.")])
  end

  # Touching a statue wakes the Snow Aspect (once per statue).
  def statue_touched(event_id = nil)
    say(["Your hand brushes the ice.",
         "The snow round your feet rises into a woman seven feet tall, with Auril's face.",
         "AURIL: DEFILERS!"], event_id)
    boss_battle(named_mon(:B124H144, 59, "Snow Aspect"))
    say(["The Snow Aspect crumbles. The statue isn't even scratched.",
         "It was never going to be scratched."])
    set_self_switch(event_id, "A") rescue nil
  end

  def shimmer_statue(event_id = nil)
    if flag?(:fields_crossed)
      return say(["Shimmer, in ice. Arms open, smiling into the wind.", "It's only what she looked like."], event_id)
    end
    say(["At the far edge, one statue isn't an animal.",
         "A young woman, arms open, smiling into the wind.",
         as(:alerion, "(stopping dead) ...Shimmer."),
         as(:alberica, "It's her. From the vision. Auril kept her. She kept the moment.")], event_id)
    speak(:alerion, "(touching the cold cheek) She didn't keep anything. That's not her.",
          "(touching the cold cheek) ...No.", event_id)
    sayc([as(:alerion, "It's what she looked like. Shimmer's in Frostina now. Shade made sure of that."),
          cl(:meat_meat, "Shade would have said something clever here. Meat Meat will say it instead."),
          cl(:meat_meat, "...Meat Meat does not know what it was."),
          cl(:reptin, "(softly) That was it, Meat Meat. That was exactly it.")], event_id)
    set_flag(:fields_crossed)
    set_switch(SW_FIELDS_ROPE, true)   # a rope back up from the entrance, from now on
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # SC 12.05 - The Garden of Death
  #-----------------------------------------------------------------------------
  def scene_garden_of_death
    return if flag?(:garden_entered)
    set_flag(:garden_entered)
    sayc(["An ice-walled graveyard.",
          "Everyone who ever froze on Solstice is here, each sealed upright in a block of clear ice.",
          "Sailors. Giants. A wizard with an orb still in her hands.",
          "An ice troll is gnawing on one of the blocks.",
          cl(:alberica, "...And I thought my last party was grim."),
          cl(:alerion, "It was.")])
  end

  def ice_troll(event_id = nil)
    return if flag?(:troll_down)
    say(["The ice troll looks up from its block with ice in its teeth, and grins."], event_id)
    return if !boss_battle(named_mon(:B221H68, 60, "Ice Troll"))
    set_flag(:troll_down)
    ($game_switches[SW_TROLL_DOWN] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    sayc(["The troll goes down in pieces.",
          "The pieces are already crawling back together. You don't stay to watch.",
          cl(:meat_meat, "Meat Meat bit a piece. It tasted like a cellar.")])
  end

  def nass(event_id = nil)
    if flag?(:skant_freed)
      return say(["NASS: The safe way's past the third row of the dead.",
                  "NASS: Up, not down. Up is always the way out of here."], event_id)
    end
    say(["NASS: (a ghost in wizard's robes) You're not with Vellynne? ...Good.",
         "NASS: The orb in my hands talks. Too much. Free it, and I'll show you the safe way up."], event_id)
    able = $Trainer.party.find { |pk| !pk.egg? && !pk.fainted? && pk.moves.any? { |m| m && ((GameData::Move.get(m.id).type rescue nil).then { |t| t == :FIGHTING || t == :FIRE }) } }
    return say(["(The ice is thick. A Fighting or Fire move would crack it.)"]) if !able
    return if !pbConfirmMessage(_INTL("Have {1} break Nass's block?", able.name))
    sayc(["#{able.name} hits the block. It splits top to bottom with a sound like a bell.",
          "PROFESSOR SKANT: (from the orb, very fast) Finally! Do you know how long I've held that thought?",
          "PROFESSOR SKANT: Four hundred and eleven years. I'll tell you the thought later. It's a good one.",
          "NASS: (fading) Up, not down. Up is always the way out of here.",
          cl(:reptin, "Lovely to meet you both. We'll be going. Up, apparently.")])
    set_flag(:skant_freed)
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # SC 12.06 - The crowned skull
  #-----------------------------------------------------------------------------
  def ukuma(event_id = nil)
    return say(lines_for(:ukuma_after), event_id) if flag?(:ukuma_raced) || flag?(:ukuma_lost)
    say(["Inside the jaw, a giant walrus slides round and round an ice rink, ignoring you.",
         "UKUMA: (not stopping) Guarding. I am guarding. Very busy guarding."], event_id)
    return if !pbConfirmMessage(_INTL("Race Ukuma round the rink?"))
    fast = $Trainer.party.reject(&:egg?).max_by { |pk| pk.speed }
    if fast && fast.speed >= 120
      sayc(["#{fast.name} takes the ice like it was born on it.",
            "Ukuma loses by a whisker, sits down hard, and laughs like a foghorn.",
            "UKUMA: Fast! Fast little thing! Fine. FINE. Back door. Hall of the Four Winds.",
            "UKUMA: Don't tell her.",
            cl(:meat_meat, "Meat Meat likes the walrus. The walrus has priorities.")])
      set_flag(:ukuma_raced)
    else
      say(["#{fast ? fast.name : 'You'} slides, spins, and ends up in a snowbank.",
           "Ukuma doesn't even slow down.",
           "UKUMA: Guarding! Still guarding!"])
      set_flag(:ukuma_lost)
    end
  end

  def grimskalle_jaw(event_id = nil)
    shortcuts = []
    shortcuts << "Eirwen's plans: the servants' stair" if flag?(:council_eirwen)
    shortcuts << "Nass's safe way up" if flag?(:skant_freed)
    shortcuts << "Ukuma's back door" if flag?(:ukuma_raced)
    say(lines_for(:grimskalle_jaw), event_id)
    say(["(Your shortcuts: #{shortcuts.join('; ')}. None of them skips a Test.)"]) if !shortcuts.empty?
    return if !pbConfirmMessage(_INTL("Go into Grimskalle?"))
    set_flag(:grimskalle_entered)
    add_counter(:story_beats)
    set_rest_at(HALL_ARRIVAL) rescue nil
    transfer(*HALL_ARRIVAL)
  end

  def apply_chapter12_switches
    return if !active? || !$game_switches
    $game_switches[SW_DOCK_CLEARED] = flag?(:dock_cleared)
    $game_switches[SW_TROLL_DOWN] = flag?(:troll_down)
    $game_switches[SW_FIELDS_ROPE] = flag?(:fields_crossed)
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter12_switches
  rescue StandardError => err
    FrostThaw.log("Chapter 12 switches failed: #{err.message}")
  end
}
