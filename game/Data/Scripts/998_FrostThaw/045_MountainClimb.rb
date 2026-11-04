#===============================================================================
# Frost & Thaw - "Mountain Climb" (Rime of the Frostmaiden, pp. 87-92)
#
# A sled dog runs through the streets of Targos dragging a broken harness:
# Boy, who belonged to Garret Velryn, a wilderness guide who led three
# adventurers up Kelvin's Cairn. Garret's husband Keegan asks you to find him.
#
#   Targos: Boy -> the Velryn house (2124). Keegan's cider, his story, the ask.
#   The open tundra east of the Bryn Shander road (2125), past the Dwarven
#     Valley, to the foot of Kelvin's Cairn (2126):
#   Base camp: two tents, an overturned sled, five howling dogs still in harness.
#   Mountain goats; an avalanche; Garret face-down in the snow; two crag cats,
#     the "Hunters of Men"; Garret's missing three (Mokingo, Perilou, Astrix).
#   The perilous climb (2127): ledges and icy cliffs, three hard pitches.
#   The frozen cave (2128): F1 the chasm, its stone bridge and ice sheet; F2 the
#     trophies (Mokingo's bones, the frozen heads: Oobok, Barthoom...); F3 the
#     yeti den, where a tyke bats Perilou about like a ball. The father comes
#     home with a goat under his arm.
#   The ruined camp at the crevasse: Astrix, frozen, staring at a pair of blue
#     boots: Barthoom Hammerhome, dead a month.
#   Home: Keegan and Garret. A box of four scrimshaw figurines, and free rooms
#     at the Luskan Arms. Perilou decides her adventuring days are over.
#===============================================================================
module FrostThaw
  SW_MC_BOY_TAKEN   = 4043   # Boy has led you home: he's no longer in the street
  SW_MC_TAKEN       = 4044   # you took the quest (Keegan's waiting; the mountain's open to you)
  SW_MC_GARRET      = 4045   # Garret found: he's gone from the slope
  SW_MC_PERILOU     = 4046   # Perilou rescued: she's gone from the den
  SW_MC_DONE        = 4047   # Garret's home in Targos
  SW_MC_DOGS_FREE   = 4048   # the sled dogs at base camp are cut loose
  SW_MC_FATHER_GONE = 4052   # the father yeti has been dealt with
  SW_MC_AVALANCHE   = 4053   # the avalanche has come down
  SW_MC_GARRET_HOME = 4054   # Garret is back in the Velryn house
  SW_MC_PERILOU_HOME = 4055  # Perilou has come down the mountain with you (she's in Targos a while)
  SW_MC_ICE_BROKEN  = 4058   # the ice sheet over the yeti cave's chasm is smashed

  MAPS.merge!(open_tundra: 2125, cairn_slopes: 2126, cairn_heights: 2127, yeti_cave: 2128)
  MAP_NAMES.merge!(2125 => "Open Tundra", 2126 => "Kelvin's Cairn", 2127 => "Kelvin's Cairn Heights",
                   2128 => "Yeti Cave")
  MAP_METADATA.merge!(
    2125 => { outdoor_map: true, announce_location: true, weather: [:Snow, 100], battle_environment: :Snow },
    2126 => { outdoor_map: true, announce_location: true, weather: [:Snow, 80], battle_environment: :Snow },
    2127 => { outdoor_map: true, announce_location: true, weather: [:Snow, 100], battle_environment: :Snow },
    2128 => { announce_location: true, battle_environment: :Cave }
  )
  AREAS.merge!(2125 => :open_tundra, 2126 => :kelvins_cairn, 2127 => :kelvins_cairn, 2128 => :yeti_cave)

  ENCOUNTERS[2125] = { step_chances: { Land: 21 },
                       Land: [[25, :SWINUB, 15, 18], [20, :SNORUNT, 15, 18], [15, :DELIBIRD, 16, 18],
                              [15, :MIGHTYENA, 16, 19], [10, :STANTLER, 17, 19], [10, :SNEASEL, 17, 19], [5, :PILOSWINE, 18, 20]] }
  ENCOUNTERS[2126] = { step_chances: { Land: 21 },
                       Land: [[25, :TAUROS, 19, 21], [20, :SNORUNT, 19, 21], [20, :SNEASEL, 19, 22],
                              [15, :GRAVELER, 19, 21], [10, :DELIBIRD, 20, 22], [10, :PILOSWINE, 20, 22]] }
  ENCOUNTERS[2127] = { step_chances: { Land: 25 },
                       Land: [[25, :SNEASEL, 21, 23], [20, :GLALIE, 21, 23], [20, :PILOSWINE, 21, 23],
                              [15, :GRAVELER, 21, 23], [10, :SKARMORY, 22, 24], [10, :ABSOL, 22, 24]] }

  RELIC_ITEMS.merge!(
    FT_SCRIMSHAWBOX: ["Velryn Scrimshaw", "Velryn Scrimshaws", 8, 0,
      "Keegan's wooden box of four figurines: a spouting whale, a smiling fox, two dancing hares, and a walrus carved \"BIG LOVE\".", 0, 0, 6],
    FT_ASTRIXBOOK: ["Astrix's Spellbook", "Astrix's Spellbooks", 8, 0,
      "A leather-bound wizard's spellbook, frozen stiff. Its owner swore a lot, Garret said. She also wrote very neatly.", 0, 0, 6],
    FT_OOBOKHEAD: ["Oobok's Remains", "Oobok's Remains", 8, 0,
      "Wrapped in a cloak. Oobok the dwarf, who died bringing iron to Bryn Shander. His friends should have him back.", 0, 0, 6]
  )

  TEXT.merge!(
    cairn_base_camp: ["Two tents pitched in the snow by an icy outcrop, a natural windbreak.",
                      "Between them, an overturned sled. Still harnessed to it: five dogs, howling."],
    cairn_crates: ["Under the sled: two small crates. One's been broken into: the dogs ate the provisions.",
                   "The other's out of their reach. Rations for four people, three days."],
    cairn_goats_sign: ["The howling wind, blowing snow and slippery ice make the climb treacherous."],
    cairn_crevasse: ["The edge of a vast, deep crevasse. Nowhere to go but down. Nobody goes down."],
    cairn_tent: ["A collapsed tent, half buried. Barthoom's. A shield dwarf explorer who climbed this high and made camp, a month ago."],
    yeti_blood: ["Blood on the snow, some distance from the cave mouth. Old, and frozen black."],
    yeti_bridge: ["A natural bridge of stone over the chasm, safe to cross."],
    yeti_ice_sheet: ["A foot-thick sheet of ice spans the south of the chasm. It holds your weight. For now."],
    yeti_trophies: ["The tunnel floor is strewn with bones: a goliath's. Mokingo Growling Bear. Torn hide armour. A greataxe.",
                    "His head has been ripped off, gnawed, and stuffed in a niche dug out of the wall.",
                    "Seven more crude niches hold the frozen heads of others the yetis have killed."],
    yeti_den_gear: ["Under the shattered remains of a dogsled: a mess kit, an explorer's pack, and blood-spattered cold-weather clothing."],
    dwarven_valley: ["Tracks run up to tunnels carved into the valley's slopes. Shield dwarves live below, in halls that join the mines.",
                     "They rarely come up nowadays, except to hunt and forage."],
    dwarf_sentry: [{ if: { flag: :mugs_done }, lines: ["DWARF: Battlehammer's friends! Come in, come in out of the wind. Stay as long as ye like.",
                                                       "DWARF: Hruna told us. Iron's in Bryn Shander. That's a debt, and we pay ours."] },
                   ["DWARF: Clan Battlehammer. You can rest a night, if ye must. We've little food to spare and less time.",
                    "DWARF: Civil, mind. Civil's all we've got this winter."]],
    keegan_after: ["KEEGAN: Garret's out chopping wood he doesn't need to chop. He does that when he's been somewhere bad.",
                   "KEEGAN: Boy hasn't left his side. Neither have I, honestly."],
    garret_home: ["GARRET: Mokingo's gone. Astrix too. I took them up there.",
                  "GARRET: Keegan says it's not on me. Keegan's kind. ...Thank you. For coming up after a fool."],
    perilou_home: ["PERILOU: I'm done. Yondalla kept me alive in a yeti's den. I'm not going to ask Her twice.",
                   "PERILOU: I'll go home and grow turnips. Big turnips. Nothing that bites."]
  )

  PARTY_CHAT[:alberica].merge!(
    open_tundra: ["All this white. If I squint, it's a bed sheet. If I don't squint, it's death. I'm squinting."],
    kelvins_cairn: ["A mountain. In a blizzard. Looking for people who climbed a mountain in a blizzard.",
                    "Darling, we are the cautionary tale."],
    yeti_cave: ["Keep your voices down. Mothers don't like guests. Trust me. I've been the guest."]
  )
  PARTY_CHAT[:reptin].merge!(
    open_tundra: ["Kelvin's Cairn, there. The dwarves say it's hollow. The yetis say it's theirs. Neither asked the mountain."],
    kelvins_cairn: ["Goat tracks. Cat tracks. Something heavier than both.", "Let's be very polite to all of them."],
    yeti_cave: ["They're a family. That makes this their home, not their lair.", "We are, technically, the burglars."]
  )
  PARTY_CHAT[:alerion].merge!(
    open_tundra: ["Stay in sight of each other. People go missing out here in a single gust."],
    kelvins_cairn: ["My ring's cold. Somebody's dead up here. More than one."],
    yeti_cave: ["Heads in the walls. Keep moving. Don't count them."]
  )
  PARTY_CHAT[:shade].merge!(
    open_tundra: ["Goblin tracks. Snowshoes. Six of them, maybe. Going somewhere in a hurry."],
    kelvins_cairn: ["Garret's a guide. Guides don't get lost. Something made him lost."],
    yeti_cave: ["I've robbed worse places than a yeti's house. I don't remember when."]
  )
  PARTY_CHAT[:shimmer].merge!(
    open_tundra: ["The cold out here is different. Bigger. Like it's got all the room in the world."],
    kelvins_cairn: ["Somebody up there is still alive. I can feel it. Don't ask how."],
    yeti_cave: ["My stone likes it in here. That's not a good sign about my stone."]
  )

  TRAINER_INTROS.merge!(
    climber_hask: "HASK: You're climbing the Cairn? In this? Prove you can climb ME first!",
    climber_vala: "VALA: Ranger patrol. Everyone going up gets tested. Everyone coming down gets counted.",
    tundra_runner: "GUNNAR: Out of my way, I'm hauling! ...Or battle me. Hauling's boring.",
    tundra_aurilite: "VESNA: You cross Her tundra without an offering? Then you are the offering."
  )
  TRAINER_TYPES.merge!(FT_CLIMBER: ["Climber", :HIKER, 0, 40])
  TRAINERS.merge!(
    climber_hask:  [:HIKER, "Hask", [[:GRAVELER, 19], [:B75H220, 20]], "The mountain wins again. You win too, I suppose."],
    climber_vala:  [:POKEMONRANGER_F, "Vala", [[:SNEASEL, 20], [:B227H220, 20]], "Watch the cornices up top. They'll go if you breathe on them."],
    tundra_runner: [:WORKER, "Gunnar", [[:MIGHTYENA, 17], [:B503H58, 18]], "I'm hauling for the dwarves. Even dwarves need someone to haul."],
    tundra_aurilite: [:FT_AURILITE, "Vesna", [[:SNORUNT, 17], [:B220H124, 18]], "She'll take the mountain too, one day. All of it."]
  )
  TEXT.merge!(
    climber_hask_after: ["Cairn's named for Kelvin. He climbed it once. That's the whole story. Nobody remembers why."],
    climber_vala_after: ["Yetis took a party last week. Goliath, halfling, tiefling. I saw the tracks. I didn't follow them."],
    tundra_runner_after: ["Dwarven Valley's just north. Civil folk. Not friendly. Civil."],
    tundra_aurilite_after: ["The crag cats are Hers too. Hunters of Men, the old Ten-Towners call them."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # Targos: Boy, and the Velryn house
  #-----------------------------------------------------------------------------
  def boy_sled_dog(event_id = nil)
    say(["You hear a bark over the whistle of the wind.",
         "A wolf-sized sled dog with light grey fur runs at you, a broken leather harness dragging behind it.",
         "It tackles you into the snow, whimpers, and licks your whole face.",
         "Then it grabs your bootstrap in its teeth and tugs. Hard. That way. THAT way."], event_id)
    sayc([cl(:alberica, "Oh! Oh, he's a darling. He's a darling with a job."),
          cl(:reptin, "That's a harness, not a collar. He's run a long way. Someone's in trouble.")])
    return if !pbConfirmMessage(_INTL("Follow the dog?"))
    set_switch(SW_MC_BOY_TAKEN, true)
    say(["Boy drags you a few blocks through the snow, to the door of a modest house, and barks and scratches at it."])
    transfer(*VELRYN_DOOR)        # Keegan answers (the house's arrival scene)
  end

  VELRYN_DOOR = [2124, 9, 10, 8]

  # The house's arrival scene, the first time Boy brings you.
  def scene_velryn_arrival
    keegan(nil)
  end

  def keegan(event_id = nil)
    if flag?(:climb_done)
      return say(lines_for(:keegan_after), event_id)
    end
    if flag?(:climb_taken)
      return say(["KEEGAN: Kelvin's Cairn. East, past the Bryn Shander road and across the tundra.",
                  "KEEGAN: Boy knows the way. He'll take you straight to the camp. Please hurry."], event_id)
    end
    return keegan_after_garret(event_id) if flag?(:garret_found)
    say(["A handsome man in his thirties opens the door. The dog races past him inside.",
         "When he sees you instead of his husband, his smile fades.",
         "KEEGAN: ...Come in. Come in out of the cold. You'll want cider. Everyone wants cider. Sit.",
         "He gives each of you a cup of warm cider. His hands aren't steady.",
         "KEEGAN: Keegan Velryn. I was born in Ten-Towns. My husband came from a wealthy family in Neverwinter.",
         "KEEGAN: Garret didn't care for city life. When I met him he was working as a guide. He loves the outdoors.",
         "KEEGAN: He lives to climb mountains.",
         "KEEGAN: A few days ago some adventurers hired him to lead them up the slopes of Kelvin's Cairn.",
         "KEEGAN: He took six dogs and a sled. Boy here was his favourite. Raised him from a pup.",
         "KEEGAN: Boy would never leave Garret's side. Not unless something terrible had happened."], event_id)
    sayc([cl(:shimmer, "(quietly) Unless someone sent him."),
          cl(:alerion, "Or unless he chose to go for help.")])
    say(["KEEGAN: It's a lot to ask. Could I persuade you to go up there and find Garret and his companions?",
         "KEEGAN: I don't have money. But the proprietor of the Luskan Arms is a friend of mine. I could get you free rooms there.",
         "KEEGAN: And I'm a scrimshander by trade. I can give you some of my work. It's not worth much, I confess.",
         "KEEGAN: Frozenfar Expeditions in Caer-Konig would have been the last place anyone saw him. That's days away.",
         "KEEGAN: Or you cut straight across the tundra: east, off the Bryn Shander road, through the Dwarven Valley."])
    if !pbConfirmMessage(_INTL("Go up Kelvin's Cairn to find Garret?"))
      return say(["KEEGAN: ...Of course. It's a mountain. I'm sorry I asked. (He sits down very carefully.)",
                  "Boy whines and looks at you."])
    end
    sayc([cl(:alberica, "Sweetheart, we'd love to. Keep the cider warm."),
          cl(:reptin, "We'll bring him home, Keegan. That's a promise, not a pleasantry."),
          "KEEGAN: (to the dog, very quietly) Go with them, Boy. Find him.",
          "Boy is already at the door."])
    set_flag(:climb_taken)
    set_flag(:boy_with_you)
    set_switch(SW_MC_TAKEN, true)
    side_goal(:climb, "Kelvin's Cairn: east off the Bryn Shander road, across the tundra. Find Garret Velryn.")
  end

  # You found Garret on the mountain before anyone asked you to. Keegan already
  # knows (Garret's home, or he's standing behind you); the others are still up there.
  def keegan_after_garret(event_id = nil)
    if flag?(:keegan_told_garret)
      say(["KEEGAN: (opening the door before you knock) You came back. He's been watching the mountain all day."], event_id)
    elsif flag?(:garret_sent_home)
      say(["Keegan opens the door with Garret's coat still over his arm. Garret is asleep by the fire, bandaged to the eyebrows.",
           "KEEGAN: You're the ones. He told me. A yeti, and the cats, and you, out of nowhere.",
           "KEEGAN: He won't stop talking about the others. Perilou, Astrix, Mokingo. He keeps trying to get up."], event_id)
    else
      say(["Keegan opens the door, sees who's standing behind you, and makes a sound you'll remember for a long time.",
           "GARRET: (sheepish, bloody) I'm all right. I'm all right. They found me. Ow. Not so hard.",
           "KEEGAN: (not letting go) You absolute idiot. You absolute, impossible idiot."], event_id)
      set_flag(:garret_with_you, false)
      set_flag(:garret_sent_home)
      set_switch(SW_MC_GARRET_HOME, true)
    end
    set_flag(:keegan_told_garret)
    say(["KEEGAN: I've no money. The Luskan Arms will give you rooms, I'll see to it, and my scrimshaw, what it's worth.",
         "KEEGAN: But his friends are still on that mountain. Would you go back up for them?"])
    if !pbConfirmMessage(_INTL("Go back up Kelvin's Cairn for the others?"))
      return say(["KEEGAN: ...Of course. You've done more than enough. (He looks at the window, at the mountain, for a long time.)"])
    end
    sayc([cl(:reptin, "All three. We swore it on the mountain and we'll swear it here."),
          "KEEGAN: Take Boy. He knows the way up better than anyone now."])
    set_flag(:climb_taken)
    set_flag(:boy_with_you)
    set_switch(SW_MC_TAKEN, true)
    side_goal(:climb, "Kelvin's Cairn, again: find Perilou, Astrix and Mokingo.")
  end

  #-----------------------------------------------------------------------------
  # The open tundra and the Dwarven Valley
  #-----------------------------------------------------------------------------
  def scene_open_tundra_enter
    say(["East of the road the forest gives out. Open tundra, white to the end of the world.",
         "Kelvin's Cairn stands up out of it in the north-east, its head lost in cloud."])
    say(["Boy puts his nose down and pulls ahead, north-east, then waits for you to catch up."]) if flag?(:boy_with_you)
  end

  def dwarven_valley_rest(event_id = nil)
    say(lines_for(:dwarf_sentry), event_id)
    return if !pbConfirmMessage(_INTL("Rest a while with the dwarves?"))
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    long_rest_taken
    say([flag?(:mugs_done) ? "They give you the warm end of the hall, and a song you don't know the words to." :
                             "They give you a corner of a tunnel out of the wind, and want you gone by morning."])
  end

  #-----------------------------------------------------------------------------
  # Kelvin's Cairn: base camp, the goats, the avalanche, Garret and the crag cats
  #-----------------------------------------------------------------------------
  def scene_cairn_enter
    if flag?(:boy_with_you)
      say(["Boy leads you straight to the foot of the mountain without once lifting his nose."])
    else
      say(["The wind has wiped out every track. Somewhere at the foot of the mountain is a camp.",
           "It takes hours of searching in the blowing snow before you find it."])
    end
  end

  def sled_dogs(event_id = nil)
    if $game_switches && $game_switches[SW_MC_DOGS_FREE]
      return say(["Only the empty harness, and a lot of paw prints heading back toward Ten-Towns."], event_id)
    end
    say(["Five sled dogs, still harnessed to the overturned sled. Friendly. Cold. Hungry. Miserable."], event_id)
    say(["Boy licks each of their faces in turn, very seriously, like a roll call."]) if flag?(:boy_with_you)
    if pbConfirmMessage(_INTL("Cut the dogs loose?"))
      say(["You cut the traces. The dogs bolt off downhill toward Ten-Towns and shelter, howling all the way."])
      set_switch(SW_MC_DOGS_FREE, true)
      wheel(1)
    end
  end

  def cairn_crates(event_id = nil)
    return say(["The broken crate, empty, and the other one, empty now too."], event_id) if flag?(:cairn_rations)
    say(lines_for(:cairn_crates), event_id)
    pbReceiveItem(:MOOMOOMILK, 3) rescue nil
    set_flag(:cairn_rations)
  end

  def mountain_goats(event_id = nil)
    say(["Four mountain goats perch on a big rock formation you have to work your way around.",
         "They bleat at you, loudly, and otherwise don't care that you exist."], event_id)
    c = pbMessage(_INTL("What do you do?"), [_INTL("Leave them be."), _INTL("Attack.")], 0)
    if c == 0
      return say(["You edge around the rocks. The goats watch, chewing, unimpressed."])
    end
    sayc([cl(:reptin, "Must we? ...Apparently we must."), "The goats lower their heads and charge!"])
    if boss_battle(named_mon(:TAUROS, 19, "Mountain goat"))
      say(["The goats scatter up the rocks, offended."])
      set_self_switch(event_id, "A")
    end
  end

  # The avalanche: a crack above, a rumble, and the slope starts to move.
  def avalanche(event_id = nil)
    return if $game_switches && $game_switches[SW_MC_AVALANCHE]
    set_switch(SW_MC_AVALANCHE, true)
    pbSEPlay("Earth3") rescue nil
    $game_screen.start_shake(5, 8, 40) rescue nil
    say(["Hundreds of feet up, halfway across a glistening white expanse of packed snow, you hear a loud CRACK above you.",
         "Then a rumble. The ground starts to shake. It's an avalanche!"])
    c = pbMessage(_INTL("Which way?"), [_INTL("Run for the rocks at the side!"), _INTL("Dig in and brace.")], 0)
    if c == 0
      say(["You run. The last of you throws themselves behind the rocks as two hundred feet of snow thunders past.",
           "Then it's very quiet. Everyone's here. Everyone's counting everyone."])
      sayc([cl(:alberica, "(lying in the snow, laughing a little wildly) Again! ...No. Never again.")])
    else
      say(["The avalanche hits like a wall. Snow, then dark, then cold, then hands digging you out."])
      $Trainer.party.each { |pk| pk.hp = [pk.hp - (pk.totalhp / 3), 1].max unless pk.egg? || pk.fainted? } rescue nil
      say(["(Your Pokémon are battered and half frozen, but alive.)"])
      sayc([cl(:shade, "Next time we run. That's not a suggestion.")])
    end
  end

  # Garret, face down in the snow; tend him, and the crag cats come.
  def fallen_climber(event_id = nil)
    if flag?(:garret_found)
      return say(["GARRET: Find them. Mokingo, Perilou, Astrix. Please."], event_id)
    end
    say(["A steep, snow-covered incline dotted with jagged rocks.",
         "Lying face down in the snow, barely conscious: a man in bloodstained cold-weather clothing.",
         "A rugged, bearded man in his prime. Garret Velryn. His weapons and a climber's kit, and nothing else."], event_id)
    say(["Boy throws himself on Garret, whining, licking, shoving with his whole body.",
         "GARRET: (faint) ...Boy? Boy. Good boy. Good boy, you went for help."]) if flag?(:boy_with_you)
    say(["You tend his wounds. He comes round enough to talk.",
         "GARRET: A yeti. It came out from under a drift by a cave, higher up. Took us by surprise.",
         "GARRET: I lured it away from the others. Got it to chase me down the mountain.",
         "GARRET: It mauled me. Then it just... stopped following."])
    pbSEPlay("Cry") rescue nil
    say(["Two pale shapes are suddenly much closer than they were. Big cats, white as the snow.",
         "GARRET: Crag cats. Hunters of Men. They've had my scent since yesterday..."])
    sayc([cl(:alerion, "Stay down, Garret. Behind me."),
          cl(:reptin, "Easy. Easy. We're not dinner.")])
    if !boss_battle(named_mon(:B262H53, 21, "Crag cat"))
      return say(["(The crag cats circle back up the slope. Garret is still lying in the snow.)"])
    end
    say(["The crag cat goes down in a spray of snow. The other one stops, looks at it, and bolts down the mountain."])
    set_flag(:crag_cats_beaten)
    set_flag(:garret_found)
    set_switch(SW_MC_GARRET, true)
    say(["GARRET: There were three more. I need to find them. They're still up there. I know they are.",
         "GARRET: Mokingo Growling Bear. A goliath. Wanted to find Oyaminartok and test himself against her.",
         "GARRET: Perilou Fishfinger. A halfling. Follows Yondalla. Stuck to Mokingo like his shadow.",
         "GARRET: And Astrix. A tiefling. Mumbles. Swears a lot. I never did learn her story."])
    c = pbMessage(_INTL("What do you say?"), [_INTL("\"Go home. We'll find them.\""), _INTL("\"Then come with us.\"")], 0)
    if c == 0
      if ($PokemonBag.pbHasItem?(:SUPERPOTION) rescue false) || ($PokemonBag.pbHasItem?(:POTION) rescue false)
        item = ($PokemonBag.pbHasItem?(:SUPERPOTION) rescue false) ? :SUPERPOTION : :POTION
        $PokemonBag.pbDeleteItem(item) rescue nil
        say(["You use a #{GameData::Item.get(item).name} on his wounds until he can stand on his own.",
             "GARRET: ...You'll search for all three? You swear it?"])
        speak(:reptin, "We swear it. All three. Go home to your husband.", "...We swear it.") if with_or_is?(:reptin)
        say(["GARRET: Then I'll go. Keegan will kill me if I don't. Come on, Boy. Home."])
        say(["Boy looks at you, then at Garret, and goes with Garret. Of course he does."]) if flag?(:boy_with_you)
        set_flag(:boy_with_you, false)
        set_flag(:garret_sent_home)
        set_switch(SW_MC_GARRET_HOME, true)
      else
        say(["He can barely stand. You have nothing left to treat him with.",
             "GARRET: Then I'm coming. I'm not lying in the snow waiting for the cats to come back."])
        set_flag(:garret_with_you)
      end
    else
      say(["GARRET: (getting up, swaying) Good. I know the route. What's left of it."])
      set_flag(:garret_with_you)
    end
    side_goal(:climb, "Up the mountain: a cave above, where the yeti came from. Find Mokingo, Perilou and Astrix.")
  end

  # The perilous climb: three pitches of ledge and ice. Get each one wrong and
  # you lose an hour, and your Pokémon pay for it in exhaustion.
  CLIMB_PITCHES = {
    1 => ["A narrow ledge runs left; an icy chimney goes straight up.", [_INTL("Take the ledge."), _INTL("Climb the chimney.")], 0,
          "The ledge holds. The chimney, you find out from above, was solid ice."],
    2 => ["A short wall of ice, and a long way round over loose scree.", [_INTL("Cut steps up the wall."), _INTL("Go round on the scree.")], 0,
          "Step by step, up the wall. The scree, below, slides away in a hiss."],
    3 => ["An overhang of rotten snow, or a crack in the rock beside it.", [_INTL("Go over the overhang."), _INTL("Wedge up the crack.")], 1,
          "Up the crack, knees and elbows. The overhang lets go behind you and is gone."]
  }

  def climb_pitch(n, event_id = nil)
    key = :"climb_pitch_#{n}"
    return if flag?(key)
    text, opts, right, done = CLIMB_PITCHES[n]
    loop do
      say([text], event_id)
      say(["GARRET: (pointing) Not that way. I went that way. Look where it got me."]) if flag?(:garret_with_you) && n == 3
      c = pbMessage(_INTL("Which way?"), opts, -1)
      if c == right
        say([done])
        set_flag(key)
        return
      end
      say(["It's wrong. An hour of nothing, slipping and hauling and getting nowhere, and you're back where you started."])
      $Trainer.party.each { |pk| pk.hp = [pk.hp - (pk.totalhp / 8), 1].max unless pk.egg? || pk.fainted? } rescue nil
      say(["(Your Pokémon are wearing out.)"])
      break if !pbConfirmMessage(_INTL("Try again?"))
    end
    pbMoveRoute($game_player, [PBMoveRoute::Backward]) rescue nil
  end

  #-----------------------------------------------------------------------------
  # The frozen cave (yeti den)
  #-----------------------------------------------------------------------------
  def scene_yeti_cave_enter
    say(["A fifteen-foot cave mouth. Inside, the floor has fallen away: a chasm eighty feet deep.",
         "All that's left is a rocky ledge, a natural stone bridge to a tunnel, and a sheet of ice over the far side.",
         "From somewhere deeper, a sound like a child laughing. And a much bigger sound, like a mother humming."])
  end

  # F1: the ice sheet over the chasm. It holds; you can walk straight across
  # it to the den. Or you can smash it, and it's gone for good.
  def ice_sheet(event_id = nil)
    return if flag?(:ice_sheet_seen)
    set_flag(:ice_sheet_seen)
    say(lines_for(:yeti_ice_sheet), event_id)
    sayc([cl(:shade, "Shortcut to whatever's laughing back there. Or a trapdoor. Hard to say with ice.")])
    if pbConfirmMessage(_INTL("Smash the ice sheet?"))
      say(["You hammer at it from the edge. It cracks, groans, and falls away into the dark in great white plates.",
           "A long time later, you hear them land. The way across is the stone bridge now, or nothing."])
      set_flag(:ice_sheet_broken)
      set_switch(SW_MC_ICE_BROKEN, true)
    end
  end

  # F2: the trophies. Mokingo, and the frozen heads in the niches (Oobok among them).
  def yeti_trophies(event_id = nil)
    say(lines_for(:yeti_trophies), event_id)
    return if flag?(:oobok_found)
    say(["One head belongs to a dwarf, his beard braided with iron rings. A Battlehammer clasp. Oobok.",
         "Another, older, wears the frost of a month: a dwarf with a miner's look. Barthoom."])
    sayc([cl(:alberica, "(very quietly) Oh, you poor lads."),
          cl(:alerion, "We take the dwarf home. His friends will want him.")])
    if pbConfirmMessage(_INTL("Wrap Oobok's remains and take them back to his friends?"))
      give_key(:FT_OOBOKHEAD)
      set_flag(:oobok_found)
    end
  end

  # F3: the yeti den. Mother and tyke; Perilou being batted about like a ball.
  def yeti_den(event_id = nil)
    return if flag?(:perilou_saved)
    say(["A strange sight: a female yeti watching her child, a yeti tyke, play with a halfling.",
         "The halfling is curled up tight in her cold-weather clothes. The tyke is knocking her around like a ball.",
         "From her cries, she's still alive.",
         "The tyke sees you, squeals, and scrambles up onto its mother's back.",
         "The mother rises to her full height and ROARS. A warning, not an attack. Yet."], event_id)
    c = pbMessage(_INTL("What do you do?"),
                  [_INTL("Keep still. Show her you've only come for the halfling."), _INTL("Fight.")], 0)
    if c == 0
      sayc(["Nobody moves. Slowly, slowly, you point at the halfling, and then at yourselves, and back the way you came.",
            cl(:reptin, "(softly, palms out) We only want our friend. Not your child. Not your home."),
            "The mother yeti watches you a long time. Then she sits down, and pulls her tyke into her lap.",
            "She lets you take the halfling."])
      set_flag(:yeti_den_peace)
      wheel(1)
    else
      return if !boss_battle(named_mon(:YETITAN, 23, "Mother yeti"))
      say(["The mother yeti staggers back against the wall, clutching her tyke, and doesn't come at you again."])
      set_flag(:mother_yeti_beaten)
    end
    say(["The halfling uncurls. Three days of cold and terror are in her face.",
         "PERILOU: Perilou. Perilou Fishfinger. Yondalla... Yondalla be thanked. And you.",
         "PERILOU: Mokingo... it killed Mokingo. He came to help Garret and it...",
         "PERILOU: I hid in here. Then it came back. Then it gave me to the baby.",
         "PERILOU: Astrix ran. Up the mountain, not down. I don't know what happened to her."])
    sayc([cl(:alberica, "Up you come, love. Arm round my neck. That's it."),
          cl(:shade, "(checking the dogsled wreck) Gear here. Clothes, a pack. Useful.")])
    pbReceiveItem(:FULLHEAL) rescue nil
    set_flag(:perilou_saved)
    set_switch(SW_MC_PERILOU, true)
    side_goal(:climb, "Astrix fled up the mountain. Find her, then get Perilou home to Targos.")
  end

  # Leaving the cave: the father comes home with a goat under one arm.
  def father_yeti(event_id = nil)
    return if $game_switches && $game_switches[SW_MC_FATHER_GONE]
    return if !flag?(:perilou_saved)
    say(["At the cave mouth, a shape blocks out the light.",
         "A male yeti, coming home, a dead mountain goat tucked under one arm.",
         "He sees you, and the halfling, and his den behind you. He drops the goat."], event_id)
    friend = $Trainer.party.any? { |pk| !pk.egg? && %i[YETOT YETITAN].include?(pk.species) } rescue false
    if friend
      say(["Your yeti steps out in front of you, small and fierce, and makes a sound you've never heard it make.",
           "The father yeti stops. He sniffs it. He looks at you for a long moment.",
           "Then he picks up his goat, and steps aside."])
      set_flag(:father_yeti_calmed)
    else
      sayc([cl(:alerion, "Back to back. Now."),
            "The father yeti charges!"])
      return if !boss_battle(named_mon(:YETITAN, 25, "Father yeti"))
      say(["The father yeti reels away into the den, to his family. He doesn't follow you."])
      set_flag(:father_yeti_beaten)
    end
    set_switch(SW_MC_FATHER_GONE, true)
  end

  #-----------------------------------------------------------------------------
  # The ruined camp
  #-----------------------------------------------------------------------------
  def astrix(event_id = nil)
    if flag?(:astrix_found)
      return say(["Astrix, frozen solid, teeth clenched, still staring at the boots."], event_id)
    end
    say(["A figure in cold-weather clothing sits in the snow by the crevasse, knees pulled tight to her chest.",
         "Horns push up from under her fur-lined hood.",
         "Astrix. Frozen solid. Teeth clenched, eyes staring at the pair of blue boots sticking out of the snow.",
         "She got away from the yeti, but in her panic she ran up the mountain instead of down.",
         "She hid here, too frightened to go back past the cave. The sight of the boots finished what the cold started."], event_id)
    sayc([cl(:shimmer, "...She was so close to just walking down."),
          cl(:alerion, "Panic doesn't walk. It climbs.")])
    say(["Tucked in her coat: a potion of invisibility, and a leather-bound spellbook."])
    pbReceiveItem(:SMOKEBALL) rescue nil
    give_key(:FT_ASTRIXBOOK)
    if flag?(:perilou_saved)
      say(["PERILOU: (kneeling beside her) Astrix. You stupid, stubborn... (She doesn't finish.)",
           "PERILOU: At least now I know. At least I can tell people."])
    end
    set_flag(:astrix_found)
  end

  def blue_boots(event_id = nil)
    if flag?(:barthoom_found)
      return say(["Barthoom Hammerhome's headless body, laid out properly now, under his tent."], event_id)
    end
    say(["A pair of blue leather boots, jutting out of a snowbank.",
         "You tug on them. A headless body comes out of the snow with them: a shield dwarf. Barthoom Hammerhome.",
         "On him: an empty wineskin, a half-eaten block of goat's cheese, and a miner's pick."], event_id)
    sayc([cl(:reptin, "A month up here, alone. (He lays the body straight.) Rest now, friend."),
          cl(:meat_meat, "Meat Meat does not want the cheese. ...Meat Meat wants the cheese a little.")])
    set_flag(:barthoom_found)
  end

  #-----------------------------------------------------------------------------
  # Home
  #-----------------------------------------------------------------------------
  # Back in the Velryn house with Garret (or with news of him).
  def climb_homecoming(event_id = nil)
    return keegan(event_id) if !flag?(:climb_taken) || flag?(:climb_done)
    if !flag?(:garret_found)
      return keegan(event_id)
    end
    if !flag?(:perilou_saved) && !flag?(:astrix_found)
      return say(["KEEGAN: Garret's home. Garret's HOME. (He can't stop touching his husband's sleeve.)",
                  "GARRET: The others, though. Perilou. Astrix. You swore."], event_id)
    end
    say(["Keegan opens the door, sees Garret, and makes a sound that isn't a word.",
         "For a while nobody says anything at all. Boy runs circles round the both of them until he falls over."], event_id) if !flag?(:garret_sent_home)
    say(["Garret is already there, wrapped in three blankets by the fire, Boy across his feet.",
         "Keegan takes both your hands in both of his."], event_id) if flag?(:garret_sent_home)
    if flag?(:perilou_saved)
      say(lines_for(:perilou_home))
    end
    say(["KEEGAN: I told you it wasn't worth much. It's worth something to me.",
         "He gives you a little wooden box. Inside: four scrimshaw figurines.",
         "A spouting whale. A smiling fox. A pair of dancing hares. And a walrus, with \"BIG LOVE\" carved into its side.",
         "KEEGAN: And Owenn at the Luskan Arms knows. Your beds there are free, as long as he has beds."])
    give_key(:FT_SCRIMSHAWBOX)
    pbReceiveItem(:RARECANDY) rescue nil
    sayc([cl(:alberica, "(holding up the walrus) Big love. I'm putting this on my tombstone."),
          cl(:shade, "You're not getting a tombstone. You're getting a song. You'll write it yourself.")])
    set_flag(:climb_done)
    set_flag(:garret_home)
    set_flag(:boy_with_you, false)
    set_switch(SW_MC_DONE, true)
    set_switch(SW_MC_GARRET_HOME, true)
    set_switch(SW_MC_PERILOU_HOME, true) if flag?(:perilou_saved)
    side_goal_done(:climb)
    add_counter(:story_beats)
  end
end
