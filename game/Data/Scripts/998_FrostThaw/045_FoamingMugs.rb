#===============================================================================
# Frost & Thaw - "Foaming Mugs" (Rime of the Frostmaiden, pp. 34-36)
#
# Three frostbitten shield dwarves, Hruna, Korux and Storn, had to abandon a
# sled of Battlehammer iron (each ingot stamped with a foaming mug) out on the
# tundra when a yeti tore their friend Oobok apart. They'll pay a gemstone
# apiece to anyone who brings the sled to Blackiron Blades.
#
#   Bryn Shander: the dwarves in the street (accept, or they leave in a huff).
#   The open tundra (2125): a blizzard comes down; Oobok's remains in a gully,
#     goblin tracks fresh in the snow, heading south; six goblins hauling the
#     sled toward a twenty-foot wagon pulled by two roaring polar bears.
#     Izobai, the one-eared boss, watches from the roof with a torch and a
#     hooded hawk; two archers shoot from inside the wagon.
#   Fight them; or free the starving polar bears (they'd sooner eat a goblin);
#   or be kind to cold, miserable goblins and they'll give up the sled. Beaten,
#   they'll trade the iron for their lives; cornered, Izobai fires the wagon.
#   Home: three hundred ingots for Hruna, a bloodstone each, and a tenth off
#   at Blackiron Blades. And the dwarves of Icewind Dale remember.
#===============================================================================
module FrostThaw
  SW_FM_DWARVES   = 4049   # the dwarves have left the street (quest taken or refused)
  SW_FM_SLED      = 4050   # the goblins and the sled are dealt with (gone from the tundra)
  SW_FM_DONE      = 4051   # the iron's in Bryn Shander
  SW_FM_BLIZZARD  = 4056   # the blizzard has come down near the sled
  SW_FM_TAKEN     = 4057   # you said yes: the goblins are on the tundra with the sled

  RELIC_ITEMS.merge!(
    FT_BLOODSTONE: ["Bloodstone", "Bloodstones", 1, 2000,
      "A dark green gemstone flecked with red. The Battlehammer dwarves pay their debts in these.", 0, 0, 0],
    FT_BONEWHISTLE: ["Bone Whistle", "Bone Whistles", 8, 0,
      "Izobai's whistle. Her hawk came to it. Nothing comes to it now.", 0, 0, 6]
  )

  TRAINER_TYPES.merge!(FT_GOBLIN: ["Goblin", :CAMPER, 0, 20])
  TRAINER_INTROS.merge!(
    goblin_haulers: "GOBLINS: Our sled! Ours! We found it! Get them!",
    goblin_archers: "GOBLINS: (from inside the wagon) Shoot through the gaps! Shoot shoot shoot!",
    izobai: "IZOBAI: You want iron? Izobai give you iron. Pointy end first!"
  )
  TRAINERS.merge!(
    goblin_haulers: [:FT_GOBLIN, "Sled haulers", [[:SNEASEL, 15], [:B215H56, 15], [:GLIGAR, 16]],
                     "Ugh! Sled too heavy anyway! Take it! No, wait, Izobai say keep it!"],
    goblin_archers: [:FT_GOBLIN, "Wagon archers", [[:B22H215, 16], [:MURKROW, 16]],
                     "Out of arrows! Out of arrows! IZOBAI!"],
    izobai:         [:FT_GOBLIN, "Izobai", [[:B17H215, 17], [:B87H217, 18]],
                     "Fine! FINE! Take your stupid iron! Izobai has better things to steal!"]
  )

  TEXT.merge!(
    oobok_remains: ["A frozen, dismembered corpse in the gully.",
                    "Snow covers some of it. The headless torso and limbs show through.",
                    "A dwarf. The yeti ate his arms and most of him, and took his head away with it.",
                    "All round him, tracks: not the yeti's, the wind's had those. Small ones. Snowshoes. Fresh.",
                    "And the grooves of a heavy sled, dragged away south."],
    goblin_wagon: ["A twenty-foot wagon on runners, its walls full of gaps for arrows.",
                   "Two polar bears in the traces. They don't look happy. They look hungry."],
    hruna_after: ["HRUNA: Garn's already melting the first lot.",
                  "HRUNA: The whole shop smells of it. Best smell in the world.",
                  "HRUNA: Ye've friends under the mountain now. Don't forget it. We won't."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # Bryn Shander: Hruna, Korux and Storn
  #-----------------------------------------------------------------------------
  def foaming_mugs_dwarves(event_id = nil)
    return say(lines_for(:hruna_after), event_id) if flag?(:mugs_done)
    if flag?(:mugs_taken)
      if flag?(:mugs_sled)
        return mugs_deliver(event_id)
      end
      return say(["HRUNA: Halfway to Kelvin's Cairn, on the open tundra.",
                  "HRUNA: Straight east off the Bryn Shander road.",
                  "STORN: (glancing at the sky) Watch for dragons. White ones. I'm just saying. Watch."], event_id)
    end
    # "Not yet" never loses them (context 14, M14-3; notes 14 E7): a second talk
    # goes straight to the ask.
    return mugs_ask(event_id) if flag?(:mugs_asked)
    # Purpose: three dwarves who ran from a yeti need someone to fetch what they
    # left behind; Korux's silence is what it cost them (dialogue 14 §4).
    giver_hello(event_id)
    say(["Three stocky dwarves in cold-weather gear, snowshoes on their backs.",
         "One steps out to meet you.",
         "She holds up a gloved hand and speaks through a thick wool scarf, in a smoker's rasp.",
         "HRUNA: Ye look like ye can walk in snow. Good. We need walkers."], event_id)
    # Oobok, found before you met his friends (M14-4): they read the bundle.
    if ($PokemonBag.pbHasItem?(:FT_OOBOKHEAD) rescue false)
      say(["Hruna's eyes go to the cloak-wrapped bundle on your pack, and the foaming-mug clasp on it.",
           "HRUNA: ...That's Oobok's clasp. Where did ye find him?",
           "You tell her: the yeti's cave on Kelvin's Cairn. Korux turns away."])
    end
    say(["Frostbite has taken her right ear and two fingers.",
         "The silent one has lost more: his nose, for one.",
         "HRUNA: Hruna. That's Korux, and Storn. We were hauling Battlehammer iron to Bryn Shander.",
         "HRUNA: A yeti took Oobok. We ran. (Korux looks at her. She doesn't look back.)",
         "Korux says nothing.",
         "Storn keeps glancing up at the sky, as if a white dragon might drop out of it.",
         "HRUNA: The sled's still out there. Fetch it, and there's a bloodstone each for ye.",
         "HRUNA: And Garn the Hammer's forge, down the street, will make ye a piece to fit.",
         "STORN: And a dwarf owes ye. That's rarer than dragons.",
         "HRUNA: Ye'll need snowshoes to make the trip in good time."])
    if ($Trainer.has_running_shoes rescue false)
      say(["KORUX: (pointing at your feet, wordlessly, and nodding once.)"])
    else
      say(["KORUX: (pressing a pair of snowshoes into your hands without a word)"])
      $Trainer.has_running_shoes = true rescue nil
      set_flag(:got_snowshoes)
    end
    sayc([cl(:shade, "Iron's heavy. Goblin raiders love heavy things they didn't have to carry.")])
    mugs_ask(event_id)
  end

  def mugs_ask(event_id = nil)
    set_flag(:mugs_asked)
    # The guard said nobody leaves on a draw night (M14-3 box 2).
    say(["HRUNA: Not tonight, they say. Draw night.",
         "HRUNA: First light, then. Before something else finds it."], event_id) if !flag?(:lottery_stand)
    c = pbMessage(_INTL("Go and fetch the dwarves' sled?"), [_INTL("Yes"), _INTL("Not yet")], -1)
    if c == 0
      sayc([cl(:reptin, "A yeti, a sled, and a blizzard season. Your sales pitch needs work."),
            "HRUNA: Straight toward Kelvin's Cairn.",
            "HRUNA: The sled's halfway between here and the mountain, out on the tundra.",
            "HRUNA: East off the Bryn Shander road. Ye'll see the mountain. Walk at it."], event_id)
      set_flag(:mugs_taken)
      set_flag(:mugs_refused, false)
      set_switch(SW_FM_TAKEN, true)
      set_switch(SW_FM_DWARVES, false)
      side_goal(:mugs, "The Battlehammer sled: on the tundra, east off the Bryn Shander road.",
                done: :mugs_done)
    else
      say(["HRUNA: Hmph. We'll be right here, by the Northlook door. Find yer spine, come find us."], event_id)
      set_flag(:mugs_refused)
    end
  end

  #-----------------------------------------------------------------------------
  # The open tundra
  #-----------------------------------------------------------------------------
  # A couple of miles from the sled, a blizzard sweeps down from the north.
  def mugs_blizzard(event_id = nil)
    return if !flag?(:mugs_taken) || ($game_switches && $game_switches[SW_FM_BLIZZARD])
    set_switch(SW_FM_BLIZZARD, true)
    $game_screen.weather(:Blizzard, 9, 20) rescue ($game_screen.weather(:Snow, 9, 20) rescue nil)
    say(["A blizzard sweeps down from the north and swallows you. You can see twenty feet. Less.",
         "Kelvin's Cairn vanishes. The wind howls in a voice like a lot of people very far away."])
    c = pbMessage(_INTL("What do you do?"), [_INTL("Stop and wait for it to pass."), _INTL("Press on.")], 0)
    if c == 0
      say(["You dig in behind a drift and huddle for hours, till the wind drops and the peak is back."])
      if has_key?(:FT_RINGOFWARMTH)
        # Marta's ring does something (notes 14 E13)
        say(["Marta's ring stays warm in your fist the whole time.",
             "Your Pokémon crowd round it. Nobody freezes."])
      else
        pbFadeOutIn { $Trainer.party.each { |pk| pk.hp = [pk.hp - pk.totalhp / 10, 1].max unless pk.egg? || pk.fainted? } } rescue nil
      end
    else
      say(["You press on into the white.",
           "When it lifts, nothing is where it should be. You've lost your bearings."])
      pbMoveRoute($game_player, [PBMoveRoute::Backward, PBMoveRoute::Backward, PBMoveRoute::Backward]) rescue nil
      sayc([cl(:alerion, "We've walked in a circle. Again. Slower, this time.")])
    end
  end

  def oobok_remains(event_id = nil)
    say(lines_for(:oobok_remains), event_id)
    set_flag(:mugs_oobok_seen)
    sayc([cl(:alerion, "(crouching at the tracks) Half a dozen."),
          cl(:alerion, "Small. On snowshoes. An hour old, no more."),
          cl(:shade, "And dragging three hundred bars of iron."),
          cl(:shade, "They won't get far. Nobody does, with loot.")])
  end

  # The goblins with the sled, and their wagon.
  def goblin_sled(event_id = nil)
    return if flag?(:mugs_sled)
    say(["The tracks lead you over a rise.",
         "Below: six small figures, grunting and cursing, haul a bulky sled through the snow.",
         "They're dragging it toward a twenty-foot wagon on runners.",
         "Two polar bears roar in its traces.",
         "Goblins. They haven't seen you.",
         "On the wagon roof: a one-eared goblin, a torch in one fist, a hooded hawk on her arm."], event_id)
    sayc([cl(:meat_meat, "Goblins. Meat Meat knows goblins."),
          cl(:meat_meat, "Goblins are cold too. Goblins are always cold."),
          cl(:reptin, "(eyeing the bears) Those two haven't been fed in a week. Look at the ribs.")])
    opts = [_INTL("Attack while they're busy with the sled."), _INTL("Creep up and free the polar bears."),
            _INTL("Walk down openly and offer them something warm.")]
    c = pbMessage(_INTL("What do you do?"), opts, -1)
    case c
    when 1 then goblin_bears
    when 2 then goblin_kindness
    else        goblin_fight
    end
  end

  def goblin_fight
    say(["You come down on them out of the snow. The goblins duck behind the sled and loose arrows.",
         "One blows a horn. On the roof, the one-eared boss stands up to watch."])
    return if !pbTrainerBattle(:FT_GOBLIN, "Sled haulers", nil, false, 0)
    say(["IZOBAI: Shoot them! Shoot them through the walls!",
         "Arrows come whistling out of the gaps in the wagon."])
    return if !pbTrainerBattle(:FT_GOBLIN, "Wagon archers", nil, false, 0)
    say(["Most of the goblins are down or hiding.",
         "Izobai looks at the burning end of her torch, then at you.",
         "IZOBAI: ...Truce? Truce! You take sled. We keep our lives. Fair?"])
    c = pbMessage(_INTL("What do you say?"), [_INTL("\"Truce. Take your lives and go.\""), _INTL("\"Come down and fight.\"")], 0)
    if c == 0
      say(["IZOBAI: Good. Good! Smart big ones. Cold, cold, everyone cold this winter. Even goblins.",
           "They scramble back into the wagon.",
           "The bears lurch off south, toward Karkolohk, wherever that is."])
      wagon_leaves
      return goblins_resolved
    end
    say(["IZOBAI: Then Izobai fights! (She doesn't look happy about it.)"])
    if !pbTrainerBattle(:FT_GOBLIN, "Izobai", nil, false, 0)
      return
    end
    say(["Izobai jams her torch into the straw beds inside the wagon. It goes up like a bonfire."])
    wagon_burns
    goblins_scatter
    say(["When the smoke clears, she's gone: her hawk, her pouch, and the last of her goblins.",
         "In the snow where she stood: a bone whistle she dropped running."])
    give_key(:FT_BONEWHISTLE)
    $Trainer.money += 400
    pbMessage(_INTL("You found $400 in a dropped sealskin pouch."))
    say(["Rolled up in the pouch with the coins: two stoppered vials sealed with a paw print.",
         "Potions of animal friendship.",
         "(A creature that drinks one is your friend for a while. They work like Friend Balls.)"])
    give(:FRIENDBALL, 2)
    set_flag(:izobai_fled)
    goblins_resolved
  end

  def goblin_bears
    say(["You go wide in the blowing snow and come up on the wagon from behind, where the bears are."])
    calmer = with_or_is?(:reptin) ? (herald?(:reptin) ? "You" : "Reptin") : nil
    if calmer
      say(["#{calmer == 'You' ? 'You walk' : 'Reptin walks'} up to the nearest bear with both hands open, humming low.",
           "The bear's nose works. It doesn't charge.",
           as(:reptin, "There. There. Nobody here is going to beat you. Except possibly the goblins.")])
    else
      lead = $Trainer.first_pokemon rescue nil
      say(["You approach slowly with your Pokémon at your side, and let the bear smell you both."])
      if lead && !(lead.hasType?(:ICE) || lead.hasType?(:NORMAL))
        say(["The bear rears up and roars at you. Both bears are hostile now. The goblins hear it."])
        return goblin_fight
      end
    end
    say(["The buckles of the harness are stiff with frost. One bear is loose. Then the other.",
         "They don't so much as look at you. They look at the goblins.",
         "The goblins look at the bears.",
         "Then they drop the sled and run, screaming, in six directions at once."])
    goblins_scatter
    bears = $game_map.events.values.select { |e| e.name == "Polar bear" && !e.character_name.to_s.empty? } rescue []
    Stage.leave_all(bears, 30, 37)
    say(["The bears go lumbering after the fattest one. Nobody sees how that ends."])
    sayc([cl(:alberica, "Well. That's one way to unionise."),
          cl(:shade, "And the sled's just sitting there. Lovely.")])
    set_flag(:goblin_bears_freed)
    wheel(1)
    goblins_resolved
  end

  def goblin_kindness
    say(["You walk down into plain sight with your hands where they can see them.",
         "The goblins freeze.",
         "IZOBAI: STOP! Who you? What you want? This our sled! We found it!"])
    # Izobai answers, so Meat Meat's line is spoken (context 14 §6).
    speak(:meat_meat, "Meat Meat was cold like goblins once. Very cold. In a cage.",
                      "Meat Meat was cold once. In a cage.") if with_or_is?(:meat_meat)
    sayc([cl(:alberica, "Oh, you look frozen to the bone. Here.")])
    gift = if ($PokemonBag.pbHasItem?(:MOOMOOMILK) rescue false) then :MOOMOOMILK
           elsif ($PokemonBag.pbHasItem?(:FRESHWATER) rescue false) then :FRESHWATER
           elsif ($PokemonBag.pbHasItem?(:LEMONADE) rescue false) then :LEMONADE
           end
    if gift
      $PokemonBag.pbDeleteItem(gift) rescue nil
      say(["You hand over a #{GameData::Item.get(gift).name}, and a blanket off your own back."])
    else
      say(["You hand over a blanket off your own back. It's all you've got. It's enough."])
    end
    say(["The goblins pass the blanket round, all six under it at once, like a very lumpy tent.",
         "IZOBAI: ...Hmph. Nobody give goblins anything. Ever. This winter, worst winter.",
         "IZOBAI: Take sled. Iron no good to eat anyway. We go home to Karkolohk.",
         "They climb into the wagon. The bears, a little less miserable, pull them away south."])
    wagon_leaves
    set_flag(:goblins_kind)
    wheel(1)
    goblins_resolved
  end

  # The goblins on the map, and where each runs to (the text says six ways).
  GOBLIN_RUN = [[30, 30], [47, 30], [30, 37], [47, 37], [38, 37], [38, 30]]

  def goblins_on_map
    ($game_map.events.values.select { |e| e.name =~ /\AGoblin \d/ && !e.character_name.to_s.empty? &&
                                         !e.instance_variable_get(:@erased) } rescue [])
  end

  def goblins_scatter
    return if !Stage.map?
    gs = goblins_on_map
    gs.each_with_index do |g, i|
      tx, ty = GOBLIN_RUN[i % GOBLIN_RUN.size]
      dirs = Stage.path_for(g, tx, ty)
      moves = dirs ? dirs.map { |d| Stage::MOVE[d] } : Stage.path_straight(g, tx, ty)
      Stage.walk(g, [37] + moves + [38], wait_for: false)
    end
    Stage.wait(40)
    gs.each { |g| g.erase rescue nil }
    iz = Stage.find("Izobai")
    Stage.leave(iz, 38, 37) if iz
  end

  # The wagon goes up: a flash of firelight and the roar of it (a stand-in for
  # a fire effect sheet: art request).
  def wagon_burns
    pbSEPlay("Fire2") rescue nil
    $game_screen.start_flash(Color.new(255, 140, 40, 180), 20) rescue nil
    $game_screen.start_shake(2, 6, 12) rescue nil
    wagon = ($game_map.events.values.find { |e| e.name.to_s =~ /wagon/i } rescue nil)
    fire = (Stage.fx("E-34", wagon || $game_player, oy: 16, fps: 10, loop_from: 4) rescue nil)   # it goes up (E-34)
    Stage.wait(48)
    Stage.stop_fx(fire) rescue nil
  end

  # Everyone back in the wagon, and away south behind the bears.
  def wagon_leaves
    return if !Stage.map?
    team = goblins_on_map + [Stage.find("Izobai")].compact
    Stage.leave_all(team, 40, 33)
    bears = $game_map.events.values.select { |e| e.name == "Polar bear" && !e.character_name.to_s.empty? } rescue []
    Stage.leave_all(bears, 45, 37)
  end

  def goblins_resolved
    set_flag(:mugs_sled)
    set_switch(SW_FM_SLED, true)
    say(["The sled: three hundred iron ingots wrapped in thick burlap, strapped down with leather.",
         "Each ingot is stamped with a foaming mug. The Battlehammer clan's mark.",
         "Getting it back to Bryn Shander takes the rest of the day, and everyone's back."])
    side_goal(:mugs, "Bring the Battlehammer iron to Hruna, in Bryn Shander.", done: :mugs_done)
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # Home
  #-----------------------------------------------------------------------------
  def mugs_deliver(event_id = nil)
    say(["HRUNA: (pulling the burlap back and laughing, rough as gravel) The foaming mug!",
         "HRUNA: Every last ingot!",
         "STORN: And no dragons. See?",
         "STORN: I said watch, and we watched, and there weren't any.",
         "KORUX: (just nods, and nods, and doesn't stop)"], event_id)
    if ($PokemonBag.pbHasItem?(:FT_OOBOKHEAD) rescue false)
      say(["You give them what you found of Oobok, wrapped in a cloak, from the yeti's cave.",
           "Hruna doesn't say anything for a long time.",
           "Korux takes the bundle and holds it like a child.",
           "HRUNA: ...He'll go home under the mountain. Thank ye. That's worth more than iron."])
      take_key(:FT_OOBOKHEAD)
      set_flag(:oobok_home)
      wheel(1)
    end
    say(["HRUNA: A bloodstone each, as promised.",
         "HRUNA: And Garn's to knock a tenth off anything ye buy at Blackiron Blades. Forever."])
    pbReceiveItem(:FT_BLOODSTONE, 5) rescue nil
    favour_forge
    # (only if you've seen Garn's swords: Blackiron Blades, down the street)
    if flag?(:met_garn)
      sayc([cl(:alberica, "A tenth off Garn's swords. I'll buy one to hang over the bar."),
            cl(:alerion, "They're cheap swords. A tenth off a cheap sword is nearly free.")])
    else
      sayc([cl(:alberica, "A tenth off, forever. I've had proposals that offered less.")])
    end
    quest_done_box("The Battlehammer iron is home.")
    set_flag(:mugs_done)
    set_switch(SW_FM_DONE, true)
    town_quest_finished
    add_counter(:story_beats)
  end
end
