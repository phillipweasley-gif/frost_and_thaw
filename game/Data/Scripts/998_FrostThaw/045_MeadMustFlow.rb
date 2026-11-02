#===============================================================================
# Frost & Thaw - "The Mead Must Flow" and the new town speaker (Good Mead;
# RotF pp. 72-78)
#
# Two days ago a verbeeg stole three casks of mead off a dogsled, and killed
# Speaker Kendrick Rielsbarrow when he tried to stop it. The townsfolk want
# revenge, and more than that they want their mead. The reward is free lodging
# and drink for a tenday.
#
#   Fef Moryn the trapper lurches out of the woods with a fox in one of his
#   traps (he'll sell it, for no less than a gold piece): he found five of the
#   militia clubbed to death. The ogre's tracks lead eight hours through the
#   woods; on the way a chwinga pelts the leader with a snowball (with the fox,
#   it gives a charm and rides off on the fox's back). The verbeeg lair (map
#   1.13): V1 three cave mouths, V2 the main entrance past a mammoth's bones,
#   V3 the firelit cave (the bonfire, Artin Glanhig on the spit, the named
#   livestock), V4 the refuse pit, V5 the ogre "Friend" asleep by the casks and
#   six hanging baskets, V6 the frozen stream, V7 Yogobor the cave bear and
#   the statue of Silvanus under the pool's ice, V8 the burial niches, V9 Duhg,
#   V10 the cursed chieftain's tomb. Leaving, Gahg arrives with her basket of
#   shiny bits (a wrecked nautiloid's weapon) for Duhg.
#
#   Then the election. Olivessa Untapoor asks the leader to run against Shandar
#   Froth, a dwarf logger the Zhentarim are blackmailing (he's wanted for murder
#   in Mirabar) into reporting to Naerth Maxildanarr. Shandar walks to Targos;
#   a day later eight thugs storm the mead hall and Shandar and his loggers
#   "drive them out", to make him a hero. Catch a thug and he'll tell you who
#   paid him. Fail to, and Shandar wins.
#===============================================================================
module FrostThaw
  SW_GM_FOX_BOUGHT   = 4076   # Fef's fox travels with you
  SW_GM_SHANDAR_AWAY = 4077   # Shandar's gone to Targos (or run off, exposed)
  SW_GM_THUGS        = 4078   # the staged "rescue" is waiting in the mead hall
  SW_GM_ELECTED      = 4079   # Good Mead has a new speaker

  MAPS.merge!(gm_woods: 2132, verbeeg_lair: 2133)
  MAP_NAMES.merge!(2132 => "Good Mead Woods", 2133 => "Verbeeg Lair")
  MAP_METADATA.merge!(
    2132 => { outdoor_map: true, announce_location: true, weather: [:Snow, 60], battle_environment: :Forest },
    2133 => { announce_location: true, battle_environment: :Cave }
  )
  AREAS.merge!(2132 => :gm_woods, 2133 => :verbeeg_lair)
  ENCOUNTERS[2132] = { step_chances: { Land: 18 },
                       Land: [[25, :SNEASEL, 22, 24], [20, :STANTLER, 22, 24], [15, :URSARING, 23, 25], [15, :NOCTOWL, 22, 24],
                              [15, :MIGHTYENA, 22, 24], [10, :PILOSWINE, 23, 25]] }
  ENCOUNTERS[2133] = { step_chances: { Cave: 6 },
                       Cave: [[35, :ZUBAT, 22, 24], [25, :GOLBAT, 23, 25], [25, :GRAVELER, 23, 25], [15, :URSARING, 24, 25]] }

  LAIR_ANIMALS = [
    # name, goat or sheep
    %w[Bessie goat], %w[Nibbles goat], %w[Old\ Horn goat], %w[Mudge goat], %w[Pebble goat], %w[Snort goat], %w[Wiggles goat],
    %w[Fluff sheep], %w[Clover sheep], %w[Mopsy sheep], %w[Little\ Duhg sheep], %w[Snowball sheep], %w[Tuft sheep]
  ]

  RELIC_ITEMS.merge!(
    FT_MEADCASK: ["Cask of Honey Mead", "Casks of Honey Mead", 8, 0,
      "A cask carved with Good Mead's mug-and-antler, twenty gallons of honey mead inside. Heavy as a person.", 0, 0, 6],
    FT_ARTINAXE: ["Artin's Battleaxe", "Artin's Battleaxes", 8, 0,
      "The battleaxe of Artin Glanhig, a shield dwarf lumberjack from Bryn Shander. Wrapped up with his thick leather boots.", 0, 0, 6],
    FT_MOSSAGATE: ["Moss Agate", "Moss Agates", 1, 1000, "A translucent pink moss agate. Pretty, and worth a little.", 0, 0, 0],
    FT_SLINGSTONES: ["Silvered Sling Stones", "Silvered Sling Stones", 1, 300,
      "Ten silvered sling stones in a little rabbit-skin bag.", 0, 0, 0],
    FT_PEARLOFPOWER: ["Pearl of Power", "Pearls of Power", 8, 0,
      "A pearl from a chieftain's dead hand. Cold, and humming. Whoever takes it from her tomb has no rest.", 0, 0, 6],
    FT_WARMAGEWAND: ["Wand of the War Mage", "Wands of the War Mage", 8, 0,
      "A wand from a chieftain's dead hand. The pictographs show her blasting monsters with it. The curse comes with it.", 0, 0, 6],
    FT_GAHGBASKET: ["Basket of Bits", "Baskets of Bits", 1, 7500,
      "Gahg's wicker basket of shiny metal fragments. The metal isn't from this world: pieces of something that fell burning out of the sky.", 0, 0, 0],
    FT_CHWINGACHARM: ["Charm of Animal Conjuring", "Charms of Animal Conjuring", 8, 0,
      "A chwinga's gift. In battle, call the beasts of the Dale: spirit wolves, owls and bears strike every foe. Three uses; then the charm fades.", 0, 10, 6]
  )

  TRAINER_INTROS.merge!(
    gm_thug_runner: "VARRO: You weren't in the script! Out of my way!"
  )
  TRAINERS.merge!(
    gm_thug_runner: [:FT_ZHENTARIM, "Varro", [[:MIGHTYENA, 24], [:B57H215, 25]], "All right! All right! I'll talk!"]
  )

  TEXT.merge!(
    gm_woods_sign: ["(A militia marker, knocked over in the snow: GOOD MEAD. Beyond it, only trees.)"],
    gm_carnage_body: ["One of Good Mead's militia, clubbed to death. New snow has begun to settle on the body."],
    gm_ogre_tracks: [{ if: { flag: :ogre_tracks_read }, lines: ["The huge barefoot tracks lead north-west, into the pines."] },
                     ["Huge, barefoot tracks, deep in the snow, leading away north-west. Easy to follow."]],
    lair_v1: ["A rocky hillside with pines growing round its base, and three caves in it.",
              "A frozen creek comes out of the west cave's low mouth. The middle cave, hewn from the rock, is half-blocked by",
              "a tight stand of conifers and two massive fallen logs. The north-east cave has a big, yawning mouth, and light flickers inside."],
    lair_v2: ["Half-sunk in the icy mire: the bones, skull and tusks of a long-dead mammoth. Beyond them, a yawning cave mouth."],
    lair_v3_cart: ["A wooden cart with a broken wheel. Two old crates: one packed with straw for the animals,",
                   "the other with ten big torches of wood and pitch. Two barrels, half-full of salt and pepper. For seasoning."],
    lair_spit: ["A hunk of meat on a spit drips juices into the bonfire. The smell is wonderful, until you see the boot by the log."],
    lair_v4: ["A dead-end cave with a crudely dug pit in the floor, twenty feet deep, five feet deep in bones, trash and filth."],
    lair_v6: ["The tunnel splits: one way follows the frozen stream north into the dark; the other veers east, toward a distant firelight."],
    lair_v8: ["A narrow passage lined with a dozen burial niches. Animals have savaged the bones.",
              "Nothing's left but a couple of skulls and some carved stone knives."],
    lair_v9_ring: ["A ring-shaped dig, once another burial chamber. The niches in the north end hold nothing at all."],
    lair_pictographs: ["Pictographs: a tribe crossing mighty mountains and a perilous tundra, fighting off terrible monsters,",
                       "and finding peace in a new home. Their chieftain leads them, a wand in her hand, blasting a monster apart."],
    gm_townsfolk_after: [{ if: { flag: :gahg_vengeful }, lines: ["Something big came out of the woods last night and smashed the honey sheds. Then it ran.",
                                                                  "Folk say it was crying."] },
                         { if: { flag: :mead_returned }, lines: ["The mead's back! Drink, drink! It's on the town. It's ALL on the town.",
                                                                 "...The verbeeg's not coming back, is he? Tell me he's not coming back."] }],
    gm_new_speaker: [{ if: { flag: :pc_speaker }, lines: ["LOGGER: (tipping his cap) Speaker. Mead's flowing, verbeeg's gone. Not bad for an outsider."] },
                     { if: { flag: :olivessa_speaker }, lines: ["LOGGER: Speaker Untapoor's down at the cooperage, still making casks. Says it's how she thinks.",
                                                                "LOGGER: Shandar? Gone. His own crew went looking for him with axes."] },
                     { if: { flag: :shandar_speaker }, lines: ["LOGGER: Speaker Froth! Hero of the mead hall! Drinks are on him. Again.",
                                                               "LOGGER: Funny. He's off to Targos again. Once a month, regular as the moon."] }],
    gm_gossip_before: ["The verbeeg ran off west with three casks under one arm. Like they were loaves.",
                       "Five of the militia went after it. They're not back. Fef went out to check his traps that way."],
    gm_thug_after: ["THUG: Naerth'll have my hide. Then the Black Network will have what's left."]
  )

  PARTY_CHAT[:alberica].merge!(gm_woods: ["Five of them, darling. They went in after a giant with spears. I hope somebody sings about them."],
                               verbeeg_lair: ["It smells like roast and goat and... oh. Oh, that isn't pork."])
  PARTY_CHAT[:reptin].merge!(gm_woods: ["Those tracks are bigger than the verbeeg's. Something else did this."],
                             verbeeg_lair: ["He's named the goats. A murderer who names his goats. People are complicated. Giants too."])
  PARTY_CHAT[:alerion].merge!(gm_woods: ["Clubbed. All of them. They never got close enough to use their spears."],
                              verbeeg_lair: ["Old tomb, older than the giants. The dead here are restless. Don't take anything that isn't ours."])
  PARTY_CHAT[:shade].merge!(gm_woods: ["Large giant's tracks. Heavy, slow, and not too bright about hiding them."],
                            verbeeg_lair: ["Baskets on pulleys. Somebody's careful about his things. Careful people notice things missing."])
  PARTY_CHAT[:meat_meat].merge!(gm_woods: ["Meat Meat smells ogre. Ogre smells like old cheese and bad decisions."],
                                verbeeg_lair: ["Meat Meat will not eat the roast. Meat Meat is not hungry any more. Forever, maybe."]) if PARTY_CHAT[:meat_meat]

  CHWINGA_CHARGES = 3

  module_function

  # The Charm of Animal Conjuring (RotF p. 74; the DMG's charm casts conjure
  # animals, three times, then vanishes). In a battle: beasts of the Dale come
  # at the chwinga's call and strike every foe for a quarter of its health.
  def chwinga_charm_usable?
    $PokemonBag && ($PokemonBag.pbHasItem?(:FT_CHWINGACHARM) rescue false) && state[:chwinga_charges].to_i > 0
  end

  def chwinga_charm_strike(battle)
    beasts = [["a pack of spirit wolves", "lopes"], ["a cloud of snowy owls", "dives"], ["a great white bear", "charges"]]
    kind, verb = beasts[(CHWINGA_CHARGES - state[:chwinga_charges].to_i) % beasts.size]
    battle.pbDisplay(_INTL("The charm warms in your hand. Out of nowhere, {1} {2} across the field!", kind, verb))
    battle.eachOtherSideBattler(0) do |b|
      next if b.fainted?
      dmg = [(b.totalhp / 4.0).round, 1].max
      b.pbReduceHP(dmg, false)
      battle.pbDisplay(_INTL("{1} is struck by the conjured beasts!", b.pbThis))
      b.pbFaint if b.fainted?
    end
    state[:chwinga_charges] = state[:chwinga_charges].to_i - 1
    if state[:chwinga_charges] <= 0
      $PokemonBag.pbDeleteItem(:FT_CHWINGACHARM) rescue nil
      battle.pbDisplay(_INTL("The beasts melt back into the snow, and the charm fades away with them."))
    else
      battle.pbDisplay(_INTL("The beasts melt back into the snow. (The charm has {1} use(s) left.)", state[:chwinga_charges]))
    end
  end

  #-----------------------------------------------------------------------------
  # Getting the quest
  #-----------------------------------------------------------------------------
  def mead_quest_offer(event_id = nil)
    return if flag?(:mead_taken)
    sayc(["The townsfolk crowd round as soon as they see you might be the sort who'd go after a giant.",
          "\"It took three casks! Off the sled! Kendrick stood in its way and it put a spear through him three times!\"",
          "\"We can't pay much. Lodging and drink for a tenday. All the drink you like. Once we HAVE drink.\"",
          cl(:alberica, "Free drink for a tenday. Darling, I'd fight a dragon for that.")], event_id)
    return if !pbConfirmMessage(_INTL("Go after the verbeeg and bring back Good Mead's casks?"))
    say(["\"It went west! Into the woods! Fef the trapper went that way this morning, checking his lines...\""])
    set_flag(:mead_taken)
    state[:mead_goal_prev] ||= state[:goal]
    state[:goal] = "Track the verbeeg west into the woods from Good Mead, and bring back the stolen casks of mead."
  end

  # Fef Moryn, lurching out of the woods with his traps.
  def fef_moryn(event_id = nil)
    mead_quest_offer(event_id) if !flag?(:mead_taken)
    if !flag?(:met_fef)
      set_flag(:met_fef)
      say(["A figure in cold-weather clothing comes floundering out of the woods through the deep snow, as fast as he can run.",
           "Slung over his back are two animal traps. In one of them, a panicked fox.",
           "FEF: Fef. Fef Moryn. I was out checking my traps and I found them. Five of the militia. In the woods.",
           "FEF: Their skulls stove in. Their chests. Something big, with a club. I came straight home."], event_id)
      sayc([cl(:shade, "Show us where."),
            "FEF: (backing off) No. No, no. I'm not going back. But my tracks are plain enough. Follow those."])
    end
    return if $game_switches[SW_GM_FOX_BOUGHT]
    say(["The fox in Fef's trap is rattled but unhurt. FEF: Want it? Not for less than a gold piece. It's a good fox."])
    return if !pbConfirmMessage(_INTL("Buy the fox for $100?"))
    return say(["You don't have it. FEF: No coin, no fox."]) if $Trainer.money < 100
    $Trainer.money -= 100
    sayc(["Fef opens the trap. The fox doesn't run. It sits by your boots, docile, watching the trees.",
          cl(:meat_meat, "Little fox. Meat Meat will carry you. No? Fine. Walk, then.")])
    set_switch(SW_GM_FOX_BOUGHT, true)
  end

  #-----------------------------------------------------------------------------
  # The woods
  #-----------------------------------------------------------------------------
  def gm_carnage(event_id = nil)
    return say(lines_for(:gm_carnage_body), event_id) if flag?(:saw_carnage)
    set_flag(:saw_carnage)
    sayc(["Deep in the woods, amid the snow-covered pines, you find the remains of the five militia members.",
          "They look like they were clubbed to death. New-fallen snow has already begun to settle on them.",
          cl(:reptin, "(kneeling, very quietly) Tempus, if you're still listening in that sad little shrine. These were yours."),
          cl(:alerion, "They followed the verbeeg. Something else stayed behind and waited for them.")], event_id)
  end

  def gm_ogre_tracks(event_id = nil)
    say(lines_for(:gm_ogre_tracks), event_id)
    return if flag?(:ogre_tracks_read)
    set_flag(:ogre_tracks_read)
    if with_or_is?(:shade)
      sayc([as(:shade, "(crouching) Not the verbeeg. Wider. Heavier. A Large giant. An ogre, I'd bet. It went home.")])
    else
      say(["Bigger than a man's. Bigger than a verbeeg's, even. Whatever made these went home, unhurried."])
    end
  end

  # The chwinga and the snowball.
  def gm_chwinga(event_id = nil)
    return if flag?(:gm_chwinga_done)
    set_flag(:gm_chwinga_done)
    set_self_switch(event_id, "A")
    say(["A tiny figure pops out of the snow and hurls a wee snowball. It hits you square in the face.",
         "Then it capers about on top of the snow, delighted with itself. A chwinga."], event_id)
    if $game_switches[SW_GM_FOX_BOUGHT]
      c = pbMessage(_INTL("The fox is straining toward the chwinga. Let it go?"), [_INTL("Let it go."), _INTL("Hold on to it.")], 0)
      if c == 0
        sayc(["The fox bolts across the snow. The chwinga bows to it, low and grave, and offers it a frozen berry.",
              "The fox gobbles it up. And just like that, they're the best of friends.",
              "The chwinga climbs onto the fox's back, waves a tiny hand at you, the one it hit with the snowball,",
              "and something settles over you like a warm scarf. Then the two of them ride off between the pines.",
              cl(:alberica, "(misty-eyed) Darling, that was the most beautiful thing I've ever seen. I'm not crying. It's snow.")])
        give_key(:FT_CHWINGACHARM)
        state[:chwinga_charges] = CHWINGA_CHARGES
        say(["(The Charm of Animal Conjuring: use it from the Bag in battle, up to three times.)"])
        set_switch(SW_GM_FOX_BOUGHT, false)
        set_flag(:fox_with_chwinga)
        return
      end
    end
    say(["The chwinga follows you a long way through the woods, copying your walk, a little way behind.",
         "At the lair, it stops at the treeline and won't come any closer."])
  end

  #-----------------------------------------------------------------------------
  # The lair
  #-----------------------------------------------------------------------------
  def scene_verbeeg_lair_outside
    say(lines_for(:lair_v1))
  end

  LAIR_CENTRE = [2133, 15, 30, 8]

  def lair_hillside(event_id = nil)
    return if flag?(:lair_seen)
    set_flag(:lair_seen)
    sayc(["The ogre's tracks lead to a frozen stream, and along it, eight hours from Good Mead, to the verbeeg's lair."] +
         lines_for(:lair_v1) +
         [cl(:shade, "The tracks go in the big one. Firelight. Nobody hides in the room with the fire."),
          cl(:alerion, "And there's a fourth mouth, round the east side. Past those bones.")], event_id)
  end

  def gm_carnage_first(event_id = nil)
    gm_carnage(event_id) if !flag?(:saw_carnage)
  end

  def gm_townsfolk(event_id = nil)
    return mead_quest_offer(event_id) if !flag?(:mead_taken)
    return say(lines_for(:gm_townsfolk_after), event_id) if flag?(:mead_returned)
    say(lines_for(:gm_townsfolk), event_id)
  end

  def gm_gossip(event_id = nil)
    return election_inquiries(event_id) if flag?(:election_asked) && !$game_switches[SW_GM_ELECTED]
    return say(lines_for(:gm_new_speaker), event_id) if $game_switches[SW_GM_ELECTED]
    say(lines_for(:gm_gossip_before), event_id)
  end

  def sneaky?(dc_easy = false)
    return true if with_or_is?(:shade)
    rand(100) < (dc_easy ? 85 : 55)
  end

  # V3: the livestock. Threaten them and Duhg calls everything off.
  def lair_livestock(event_id = nil)
    names = LAIR_ANIMALS.map { |n, kind| "#{n} the #{kind}" }
    say(["Seven goats and six sheep in a pen of crude wooden fence, all fat and healthy. Each has a name daubed on a board:",
         names.first(7).join(", ") + ",", names.last(6).join(", ") + ".",
         "He robbed them off travellers on the Eastway. He loves them."], event_id)
    return if flag?(:duhg_down) || flag?(:livestock_truce)
    return if !flag?(:duhg_here) || !pbConfirmMessage(_INTL("Threaten the animals, so the verbeeg backs off?"))
    sayc(["You put yourself between the pen and the bonfire, and look Duhg in the eye.",
          "DUHG: NO! Not Bessie! Not Little Duhg! Friend, stop! Yogobor, STOP!",
          "DUHG: (lowering his spear) ...Go. Go, then. Take your barrels. Leave my babies. Leave them!"])
    set_flag(:livestock_truce)
  end

  def lair_spit(event_id = nil)
    say(lines_for(:lair_spit), event_id)
    return if flag?(:artin_bundle)
    sayc(["By a log near the fire, a small bundle: a dwarf-sized battleaxe and a pair of thick leather boots.",
          "Next to them, a half-made knife for unpicking stitches. The meat on the spit was Artin Glanhig,",
          "a shield dwarf lumberjack from Bryn Shander.",
          cl(:reptin, "(after a moment) We'll take his axe home. Someone in Bryn Shander should have it.")])
    give_key(:FT_ARTINAXE)
    set_flag(:artin_bundle)
  end

  # V5: Friend.
  def lair_ogre(event_id = nil)
    return if flag?(:friend_down)
    say(["A heavy snore. A fat, battle-scarred ogre sits with its back to the west wall, chin on its chest, drooling.",
         "At its feet: a bloody greatclub with tufts of hair and bits of metal stuck in it."], event_id)
    c = pbMessage(_INTL("What do you do?"), [_INTL("Creep past it."), _INTL("Attack while it sleeps.")], 0)
    return lair_ogre_wakes if c == 1
    if sneaky?(true)
      say(["You creep round it. It snores on."])
      set_flag(:friend_asleep_passed)
    else
      say(["A loose stone skitters. The snoring stops."])
      lair_ogre_wakes
    end
  end

  def lair_ogre_wakes
    say(["The ogre lurches up and grabs its greatclub. OGRE: ME FRIEND!"])
    return if !boss_battle(named_mon(:B524H57, 25, "Friend"))
    sayc(["The ogre goes down with a crash that shakes icicles off the ceiling.",
          cl(:shade, "\"Friend.\" It couldn't remember its own name. The verbeeg named it for it.")])
    set_flag(:friend_down)
    $game_map.events.each_value { |e| set_self_switch(e.id, "A") if e.name == "Friend" } rescue nil
  end

  def lair_disturb
    return true if flag?(:friend_down)
    return true if sneaky?(true)
    say(["The basket ropes creak. In the corner, the ogre's snore cuts off mid-breath."])
    lair_ogre_wakes
    flag?(:friend_down)
  end

  # V5: the six baskets on their pulleys.
  def lair_basket(event_id = nil)
    key = :"basket_#{event_id}"
    return say(["An empty basket swings on its rope."], event_id) if flag?(key)
    return if !pbConfirmMessage(_INTL("Lower this basket?"))
    return if !lair_disturb
    set_flag(key)
    state[:baskets] = (state[:baskets] || 0) + 1
    state[:treasure_basket] ||= rand(6) + 1
    if state[:baskets] == state[:treasure_basket]
      say(["Down comes the verbeeg's treasure: a bag of silver and copper, a translucent pink moss agate,",
           "a healer's kit, a hunting trap, and a little rabbit-skin bag of silvered sling stones."])
      $Trainer.money += 1060
      pbMessage(_INTL("You got $1060!"))
      pbReceiveItem(:FT_MOSSAGATE) rescue nil
      pbReceiveItem(:FULLHEAL, 2) rescue nil
      pbReceiveItem(:FT_SLINGSTONES) rescue nil
    else
      say([["Sheep shears and a milk pail.", "Bristle brushes, and a sack of oats stolen off the Eastway.",
            "Bags of grain. Lots of grain.", "More grain, and a pail.", "A milk pail with the bottom out."][rand(5)]])
    end
  end

  # V5: the casks. One's empty; two hold twenty gallons each.
  def lair_casks(event_id = nil)
    return say(["One empty cask lies where you left it. The verbeeg and the ogre drank it dry."], event_id) if flag?(:mead_casks)
    say(["Three wooden casks clustered by the south wall, carved with Good Mead's mug and antler.",
         "One sloshes hollow: empty. The other two are full. Two hundred pounds each."], event_id)
    return if !pbConfirmMessage(_INTL("Take the two full casks?"))
    return if !lair_disturb
    if with_or_is?(:meat_meat)
      sayc([as(:meat_meat, "(hoisting one on each shoulder) Meat Meat carries. Meat Meat would carry coffee better. Meat Meat carries.")])
    elsif party_has_strength?
      say(["Your strongest Pokémon gets a cask on its back, and the rest of you take turns rolling the other."])
    else
      say(["You lash both casks to the verbeeg's broken cart, wedge the bad wheel with a crate lid, and drag."])
    end
    give_key(:FT_MEADCASK)
    set_flag(:mead_casks)
    state[:goal] = "Take the two casks of mead home to Good Mead."
  end

  # V7: Yogobor, asleep in the dark.
  def lair_bear(event_id = nil)
    return if flag?(:yogobor_gone)
    say(["In the western niche of the cave, something huge and brown is breathing slowly. A cave bear."], event_id)
    c = pbMessage(_INTL("What do you do?"), [_INTL("Sneak past in the dark."), _INTL("Fight it.")], 0)
    if c == 0 && sneaky?
      return say(["Lamps shuttered, feeling your way along the ice, you creep past. The bear doesn't stir."])
    end
    say(["The bear's eyes open. It's hungry, and you're food. Yogobor comes out of its niche."])
    return if !boss_battle(named_mon(:URSARING, 26, "Yogobor"))
    if flag?(:duhg_down) || !flag?(:duhg_here)
      say(["Badly hurt, with no verbeeg to call it back, Yogobor flees for its life down the tunnel and out into the snow."])
    else
      say(["Yogobor slumps against the wall, done."])
    end
    set_flag(:yogobor_gone)
    set_self_switch(event_id, "A")
  end

  def lair_bear_niche(event_id = nil)
    return say(["Bones in the niche, gnawed clean."], event_id) if !flag?(:yogobor_gone) && !pbConfirmMessage(_INTL("Look in the bear's niche?"))
    sayc(["The niche holds the gnawed skull and bones of a shield dwarf. Artin Glanhig, the rest of him.",
          cl(:alerion, "We'll tell Bryn Shander where he is.")], event_id)
  end

  # V7: Silvanus under the ice.
  def lair_silvanus(event_id = nil)
    say(["The frozen stream ends at a seven-foot-deep frozen pool. Trapped beneath its ice: a stone statue of a smiling",
         "young man, naked but for a well-placed oak leaf, his face turned to the sky."], event_id)
    sayc([cl(:reptin, "Silvanus. The Oak Father. That leaf's his holy symbol. Someone shaped this out of the pool's own stone.")])
    if flag?(:silvanus_drunk)
      return say(["The pool lies open, steaming faintly. You've each had your drink. It only gives once."])
    end
    return if !pbConfirmMessage(_INTL("Break through the foot of ice to the statue?"))
    if !party_has_fire? && !party_has_strength?
      return say(["A foot of ice. You'd need fire, or a lot of strength, to get through it."])
    end
    sayc(["You break through. Under the ice, the water's clear and cold and smells of green things.",
          "The moment the pool's open to the air, the statue seems to smile wider.",
          "You drink. It runs through you like spring: every ache, every frostbitten finger, every wound, gone."])
    $Trainer.heal_party rescue nil
    set_flag(:silvanus_drunk)
  end

  # V9: Duhg.
  def lair_duhg(event_id = nil)
    return if flag?(:duhg_down)
    set_flag(:duhg_here)
    if flag?(:livestock_truce)
      return say(["DUHG: You. You took my mead. Go. Leave my babies be. Go."], event_id)
    end
    say(["A verbeeg, huge and lanky and lopsided, sits cross-legged in the tunnel with a torch beside him,",
         "sharpening a stone knife he found in the old tomb. His spear leans against the wall, in easy reach.",
         "DUHG: (looking up) Oh. Little ones. Come for Duhg's honey? Duhg's honey is for Gahg."], event_id)
    c = pbMessage(_INTL("What do you do?"), [_INTL("Fight him."), _INTL("Back away.")], 0)
    return say(["You back away. He goes back to his knife, humming."]) if c == 1
    if !flag?(:friend_down) && !flag?(:friend_asleep_passed)
      say(["DUHG: (whistling, piercingly) FRIEND! YOGOBOR!", "Something big starts lumbering this way."])
    end
    return if !boss_battle(named_mon(:B68H297, 27, "Duhg"))
    sayc(["Duhg topples, and the torch rolls into the stream and hisses out.",
          cl(:alberica, "That's for Kendrick, darling. And for the five in the woods.")])
    set_flag(:duhg_down)
    set_self_switch(event_id, "A")
  end

  # V10: the chieftain's tomb. Moving the block takes a lot of strength.
  def lair_tomb(event_id = nil)
    say(lines_for(:lair_pictographs), event_id)
    if flag?(:chieftain_robbed)
      return lair_tomb_return
    end
    return if flag?(:chieftain_seen) && !pbConfirmMessage(_INTL("Look in the niche again?"))
    if !flag?(:chieftain_seen)
      return if !pbConfirmMessage(_INTL("Shift the stone block in the middle of the room?"))
      strong = $Trainer.party.count { |pk| !pk.egg? && !pk.fainted? && pk.attack >= 60 } rescue 0
      if strong < 2 && !with_or_is?(:meat_meat)
        return say(["Seven feet long, three feet tall. It won't move. You'd need two strong Pokémon at least, or more hands."])
      end
      say(["The block grinds aside. Beneath it, a shallow niche: the bones of a woman, her tribal garb dust and tatters.",
           "In her left hand, a pearl. In her right, a wand."])
      set_flag(:chieftain_seen)
    end
    sayc([cl(:alerion, "(very still) Leave them. Please. Whatever you take from her, she'll take something back.")])
    return if !pbConfirmMessage(_INTL("Take the pearl and the wand?"))
    give_key(:FT_PEARLOFPOWER)
    give_key(:FT_WARMAGEWAND)
    set_flag(:chieftain_robbed)
    set_flag(:chieftain_curse)
    say(["As your fingers close on them, the room goes cold in a way that has nothing to do with the ice."])
  end

  def lair_tomb_return
    return if !pbConfirmMessage(_INTL("Put the chieftain's pearl and wand back in her hands?"))
    take_key(:FT_PEARLOFPOWER)
    take_key(:FT_WARMAGEWAND)
    set_flag(:chieftain_robbed, false)
    set_flag(:chieftain_curse, false)
    say(["You fold her fingers back round them. The cold goes out of the room like a held breath let go."])
  end

  # The chieftain's curse: phantasmal nightmares at every long rest, and no benefit from it.
  class << self
    alias_method :set_rest_at_uncursed, :set_rest_at if method_defined?(:set_rest_at) && !method_defined?(:set_rest_at_uncursed)
  end

  def self.set_rest_at(point)
    set_rest_at_uncursed(point)
    long_rest_taken
  end

  # Nimsy's attic (015) keeps its own rest point: a night there is a night too.
  class << self
    alias_method :set_rest_point_plain, :set_rest_point if method_defined?(:set_rest_point) && !method_defined?(:set_rest_point_plain)
  end

  def self.set_rest_point
    set_rest_point_plain
    long_rest_taken
  end

  # Every night's sleep anywhere in the Dale (inns, attics, the mead hall): the
  # chieftain's nightmares, and another day gone by in Good Mead.
  def long_rest_taken
    chieftain_nightmare if flag?(:chieftain_curse)
    election_day_passes
  end

  def chieftain_nightmare
    say(["You sleep, and she's there: a woman in tribal furs, a wand raised, and a monster coming apart in front of her.",
         "Then she turns, and the wand points at you. You wake shaking, more tired than when you lay down."])
    $Trainer.party.each { |pk| pk.hp = [pk.hp, (pk.totalhp / 2.0).ceil].min if !pk.egg? && pk.hp > 0 } rescue nil
    say(["(The chieftain's curse: your Pokémon get no benefit from the rest. Return what you took from her tomb.)"])
  end

  # Leaving the lair with the casks: Gahg arrives.
  def lair_exit_gahg(event_id = nil)
    return if !flag?(:mead_casks) || flag?(:gahg_met)
    set_flag(:gahg_met)
    say(["A verbeeg strides through the snow toward the cave mouth. Her misshapen face bears a too-wide smile.",
         "She clutches a spear in one hand and cradles a wicker basket full of shiny bits of metal in the other.",
         "GAHG: Duhg? You home?"], event_id)
    c = pbMessage(_INTL("What do you do?"), [_INTL("Stand aside."), _INTL("Stop her."), _INTL("Run."),
                                              _INTL("Hide back in the cave.")], 0)
    case c
    when 3
      return gahg_hide_and_seek
      say(["You step into her path. Gahg's smile falls. Then her face twists.",
           "GAHG: What did you do to Duhg? WHAT DID YOU DO?", "She drops the basket and attacks."])
      if boss_battle(named_mon(:B68H297, 26, "Gahg"))
        say(["Gahg goes down in the snow beside her spilled basket."])
        pbReceiveItem(:FT_GAHGBASKET) rescue nil
        set_flag(:gahg_down)
      end
    when 2
      say(["You run for the trees, casks and all. Behind you, Gahg goes into the cave calling Duhg's name."])
    else
      say(["You stand aside. Gahg ducks into the cave, calling Duhg's name."])
    end
    if flag?(:duhg_down) && !flag?(:gahg_down)
      say(["A moment later, a howl comes out of the hillside that you'll hear for a long time afterwards."])
      set_flag(:gahg_vengeful)
    elsif !flag?(:duhg_down) && flag?(:gahg_down)
      set_flag(:duhg_vengeful)
    end
  end

  # You duck back into the lair to hide. Gahg finds Duhg first, and then she
  # comes looking for whoever was at his door.
  def gahg_hide_and_seek
    sayc(["You back into the dark of the cave mouth, casks and all, and press yourselves into a niche behind the icicles.",
          cl(:shade, "(a breath, no more) Nobody moves. Nobody breathes. Nobody sneezes, Meat Meat."),
          "Gahg ducks in past you, calling Duhg's name."])
    if flag?(:duhg_down)
      say(["Deep in the lair, she finds him. The sound she makes isn't a word.",
           "Then the torchlight comes back up the tunnel, slowly, and stops at every shadow. She's looking for you."])
    else
      say(["Deep in the lair, a booming, happy reunion. Then, quite suddenly, quiet.",
           "DUHG: Where's Gahg's honey? Duhg had honey for Gahg! Somebody TOOK it!",
           "Two torches come back up the tunnel, slowly, and stop at every shadow."])
    end
    if sneaky?
      say(["The torchlight passes a hand's breadth from your faces. The spear-point turns over a drift beside you, and moves on."])
      if flag?(:duhg_down)
        say(["At last Gahg goes back to him. When you creep out into the snow, she's sitting by his body in the firelight, rocking.",
             "Her basket of shiny bits lies forgotten by the door. You could take it. You do."])
        pbReceiveItem(:FT_GAHGBASKET) rescue nil
        set_flag(:gahg_vengeful)
      else
        say(["The two of them give up, grumbling, and go back to the fire. You slip out with the casks while they argue about it."])
        set_flag(:verbeegs_both_alive)
      end
      return
    end
    say(["A torch swings round. Gahg's too-wide face looks straight at you."])
    if flag?(:duhg_down)
      say(["GAHG: YOU. YOU did it!", "She comes at you with the spear."])
      if boss_battle(named_mon(:B68H297, 26, "Gahg"))
        say(["Gahg falls beside the cave mouth. Her basket of shiny bits spills across the floor."])
        pbReceiveItem(:FT_GAHGBASKET) rescue nil
        set_flag(:gahg_down)
      else
        set_flag(:gahg_vengeful)
      end
    else
      say(["DUHG: THIEVES! Gahg, THIEVES!", "Both verbeeg come at you at once."])
      if boss_battle(named_mon(:B68H297, 27, "Duhg"), named_mon(:B68H297, 26, "Gahg"))
        say(["Both verbeeg go down, one on top of the other, in the tunnel they shared."])
        pbReceiveItem(:FT_GAHGBASKET) rescue nil
        set_flag(:duhg_down)
        set_flag(:gahg_down)
      else
        set_flag(:verbeegs_both_alive)
      end
    end
  end

  #-----------------------------------------------------------------------------
  # Home with the mead
  #-----------------------------------------------------------------------------
  def mead_homecoming(event_id = nil)
    return if !flag?(:mead_casks) || flag?(:mead_returned)
    take_key(:FT_MEADCASK)
    set_flag(:mead_returned)
    sayc(["You come out of the trees with the casks, and somebody sees you, and shouts, and the whole town comes running.",
          "\"The MEAD! The mead's back!\"",
          "Within the hour the mead hall is full, the bees are humming, and somebody is already singing about you, badly."])
    if !flag?(:duhg_down) || flag?(:gahg_vengeful) || flag?(:verbeegs_both_alive)
      sayc(["Later, when the singing stops, the brewmistress finds you by the hive fire.",
            "BREWMISTRESS: The giant. You left it alive. (Or its mate.) What's to stop it coming back?",
            cl(:alerion, "Nothing. Keep the militia on the treeline. And keep the bees inside.")])
    end
    say(["The town keeps its word: lodging and drink for a tenday. The brewmistress presses three flasks into your hands",
         "(honey mead, stoppered tight: they restore like Berry Juice)."])
    pbReceiveItem(:BERRYJUICE, 3) rescue nil
    state[:goal] = state[:mead_goal_prev] if state[:mead_goal_prev]
    add_counter(:story_beats)
  end

  #-----------------------------------------------------------------------------
  # The new town speaker
  #-----------------------------------------------------------------------------
  def olivessa(event_id = nil)
    return say(lines_for(:olivessa_untapoor), event_id) if !flag?(:mead_returned) || $game_switches[SW_GM_ELECTED]
    return say(["OLIVESSA: Shandar's off to Targos, they say. Funny time to take a walk."], event_id) if flag?(:election_asked) && $game_switches[SW_GM_SHANDAR_AWAY]
    return say(["OLIVESSA: Whatever you decide. I'll back it."], event_id) if flag?(:election_asked)
    set_flag(:election_asked)
    say(["A middle-aged woman takes off her thick wool scarf so she can speak clearly.",
         "OLIVESSA: My name's Olivessa. I make the casks for the mead. Some friends of mine don't want Shandar Froth",
         "OLIVESSA: to become our next town speaker. They say he's untrustworthy. I don't know him that well,",
         "OLIVESSA: but I've been urged to run against him. I have no interest in the speakership.",
         "OLIVESSA: But you seem to be a good leader, and this town could use one. What do you say?"], event_id)
    c = pbMessage(_INTL("What do you say?"), [_INTL("\"I'll run.\""), _INTL("\"You should run. We'll back you.\""), _INTL("\"It's not our town.\"")], 0)
    case c
    when 0
      set_flag(:pc_candidate)
      say(["OLIVESSA: (with real relief) Then you have my support. That's not nothing, here. My family's been here since the founding."])
    when 1
      set_flag(:olivessa_candidate)
      say(["OLIVESSA: (a long breath) ...All right. All right. If you'll stand behind me. Somebody has to."])
    else
      set_flag(:no_challenger)
      say(["OLIVESSA: No. No, I suppose it isn't. (She wraps her scarf back up.) Then it'll be Shandar.",
           "OLIVESSA: The vote's in a week or so. Nobody'll stand against him now."])
      start_election_clock
      return
    end
    sayc(["Word gets round fast. Within the hour, Shandar Froth is shouldering through the crowd outside the cooperage.",
          "SHANDAR: Outsiders! Strangers with no stake in Good Mead telling us who should lead it!",
          "SHANDAR: (to the crowd) Where were they when the verbeeg came? Hm? HM?",
          cl(:shade, "Fetching your mead back, mostly."),
          "Shandar stamps off. By evening, someone says he's taken the road west. Toward Targos."])
    set_switch(SW_GM_SHANDAR_AWAY, true)
    start_election_clock
    state[:goal_prev_election] ||= state[:goal]
    state[:goal] = "Good Mead votes for a new speaker in about a week. Shandar Froth has walked off toward Targos."
  end

  # Ask around about the candidates (an hour of inquiries).
  def election_inquiries(event_id = nil)
    say(["You spend an hour asking round town about the candidates.",
         "Olivessa has deep roots in Good Mead: her family's lived here since the founding. She's reserved, has no family of",
         "her own, and lives alone in the house nearest the Shrine of the Flaming Sword.",
         "Shandar has lived here a few years, and the loggers love him. He's a bully and a blowhard, but there's nothing",
         "he wouldn't do for his friends. He lives with five other loggers in a small house on the west side of town."], event_id)
  end

  # A day later: eight thugs storm the mead hall, and Shandar saves the day.
  def scene_gm_thugs
    set_switch(SW_GM_THUGS, false)
    set_flag(:gm_thugs_done)
    sayc(["That evening, the mead hall doors bang open. Eight hard men in cold-weather clothing shoulder in,",
          "kicking over benches. THUG: Nice town. Shame if somebody burned it down. Where's your SPEAKER?",
          "Before you can get up, the doors bang again: Shandar Froth and five big loggers, axes on their shoulders.",
          "SHANDAR: Not in MY town!",
          "It's over in moments. The thugs fall over themselves getting out, and nobody seems to have been hurt at all.",
          "The hall erupts. Somebody hoists Shandar onto a table.",
          cl(:shade, "(very quietly) Not one cut. Not one bruise. That wasn't a fight. That was a play."),
          cl(:alerion, "One of them's slipping off toward the woods. Now, if we're going.")])
    set_switch(SW_GM_SHANDAR_AWAY, false)
    c = pbMessage(_INTL("What do you do?"), [_INTL("Run after the thug."), _INTL("Let it go.")], 0)
    if c == 1
      say(["The cheering goes on late into the night. Shandar buys everyone a drink. With whose money, nobody asks."])
      return election_days_left_note
    end
    say(["You catch him on the edge of the woods. He turns, swearing, and whistles up his Pokémon."])
    if pbTrainerBattle(:FT_ZHENTARIM, "Varro", nil, false, 0)
      sayc(["THUG: All right! All right! It was a job. Scare the town, get chased out by the dwarf. Easy money.",
            "THUG: Naerth Maxildanarr hired us. Speaker of Targos. He wants his dwarf in charge here.",
            "THUG: The dwarf's wanted for murder in Mirabar. The Black Network found him. Now he does what he's told.",
            cl(:alberica, "Well. That's going to make a lovely speech, darling.")])
      set_flag(:shandar_exposed)
    else
      say(["The thug gets away into the trees. By the time you're back, the hall is cheering for Shandar."])
    end
    if flag?(:shandar_exposed)
      say(["You lock the thug in Olivessa's cooperage, among the staves. He'll keep until the vote. He'll talk again, too."])
    end
    election_days_left_note
  end

  #-----------------------------------------------------------------------------
  # The election clock (RotF p. 72: "a week or two for the town to plan an
  # election"; p. 78: Shandar makes the eight-hour hike to Targos and promptly
  # returns; "a day later, eight human thugs storm the mead hall"). Each night's
  # rest anywhere is a day.
  #-----------------------------------------------------------------------------
  ELECTION_DAYS = 8          # the vote: a week and a day after Olivessa asks
  GOOD_MEAD_MAPS = (2031..2033).to_a       # the town, the mead hall, the cooperage

  def start_election_clock
    state[:gm_election_day] = 0
  end

  def election_days_left_note
    left = ELECTION_DAYS - state[:gm_election_day].to_i
    say(["(Good Mead votes in #{left > 1 ? "about #{left} days" : 'a day'}: rest, and come back to the mead hall for it.)"]) if left > 0
  end

  def election_day_passes
    return if state[:gm_election_day].nil? || ($game_switches && $game_switches[SW_GM_ELECTED])
    day = state[:gm_election_day] = state[:gm_election_day].to_i + 1
    here = GOOD_MEAD_MAPS.include?($game_map.map_id) rescue false
    contested = !flag?(:no_challenger)
    if contested && day == 1 && !flag?(:shandar_exposed)
      set_switch(SW_GM_SHANDAR_AWAY, false)          # back from Targos, overnight, very pleased with himself
    end
    if contested && day >= 2 && !flag?(:gm_thugs_done)
      if here
        set_switch(SW_GM_THUGS, true)                 # it happens in the mead hall, tonight
      else
        set_flag(:gm_thugs_done)
        set_flag(:gm_thugs_missed)
        say(["(Word reaches you from Good Mead: eight thugs stormed the mead hall, and Shandar Froth and his loggers",
             "drove them out with their tails between their legs. They're calling him a hero.)"])
      end
    end
    return if day < ELECTION_DAYS || (contested && !flag?(:gm_thugs_done))
    if here
      set_switch(SW_GM_THUGS, true)                   # the vote, in the shrine, when you're next in the mead hall
    else
      say(["(A rider from Good Mead finds you on the road. The town has voted.)"])
      election_result
    end
  end

  # The mead hall's evening news: the thugs, or the vote, whichever is due.
  def gm_mead_hall_news(event_id = nil)
    return if !$game_switches[SW_GM_THUGS]
    return scene_gm_thugs if !flag?(:gm_thugs_done) && !flag?(:no_challenger)
    set_switch(SW_GM_THUGS, false)
    election_result
  end

  def election_result
    say(["Good Mead votes in the Shrine of the Flaming Sword, under Kendrick's chipped painted Tempus."])
    if flag?(:shandar_exposed)
      sayc(["Olivessa brings the thug out of her cooperage, and he says it all again, to everyone.",
            "Shandar goes white, then red, and then he's gone out the back door. By morning his loggers are looking for him too."])
      if flag?(:pc_candidate)
        say(["The vote's not close. Good Mead has a new speaker: you. Olivessa claps loudest.",
             "(You won't be staying, but the town says the title's yours as long as you want it.)"])
        set_flag(:pc_speaker)
      else
        say(["The vote's not close. Speaker Olivessa Untapoor looks like she'd rather be anywhere else,",
             "and makes a short, sensible speech, and hands out honey cakes."])
        set_flag(:olivessa_speaker)
      end
      set_switch(SW_GM_SHANDAR_AWAY, true)
    elsif flag?(:no_challenger)
      sayc(["Nobody stands against him. Shandar Froth is speaker of Good Mead by a show of hands.",
            cl(:shade, "And now Naerth has a speaker in Good Mead. Somebody should write that down. Somewhere he can't read it.")])
      set_flag(:shandar_speaker)
      set_flag(:zhentarim_good_mead)
    else
      sayc(["Shandar Froth, hero of the mead hall, wins easily.",
            cl(:shade, "And now Naerth has a speaker in Good Mead. Somebody should write that down. Somewhere he can't read it.")])
      set_flag(:shandar_speaker)
      set_flag(:zhentarim_good_mead)
    end
    set_switch(SW_GM_ELECTED, true)
    state[:goal] = state[:goal_prev_election] if state[:goal_prev_election]
    add_counter(:story_beats)
  end

  # Shandar, in town (before and after).
  def shandar(event_id = nil)
    return say(lines_for(:gm_new_speaker), event_id) if flag?(:shandar_speaker)
    say(lines_for(:shandar_froth), event_id)
  end

  # The brewmistress has mead again.
  class << self
    alias_method :mead_hall_rest_dry, :mead_hall_rest if method_defined?(:mead_hall_rest) && !method_defined?(:mead_hall_rest_dry)
  end

  def self.mead_hall_rest(event_id = nil)
    if flag?(:mead_returned)
      say(["BREWMISTRESS: There they are! Sit, sit. Mead's on the house. It's on the house for a TENDAY. I said so."], event_id)
    end
    mead_hall_rest_dry(event_id)
  end
end

#-------------------------------------------------------------------------------
# The Charm of Animal Conjuring in battle (no target; the bag doesn't use it up:
# its three uses are counted in the story state)
#-------------------------------------------------------------------------------
if defined?(ItemHandlers::UseInBattle)
ItemHandlers::CanUseInBattle.add(:FT_CHWINGACHARM, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  if !FrostThaw.chwinga_charm_usable?
    scene.pbDisplay(_INTL("The charm is cold. Its magic is spent.")) if showMessages
    next false
  end
  next true
}) if defined?(ItemHandlers::CanUseInBattle)

ItemHandlers::UseInBattle.add(:FT_CHWINGACHARM, proc { |item, battler, battle|
  FrostThaw.chwinga_charm_strike(battle)
})
end
