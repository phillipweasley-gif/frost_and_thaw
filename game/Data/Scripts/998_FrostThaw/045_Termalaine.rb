#===============================================================================
# Frost & Thaw - Termalaine and "A Beautiful Mine" (RotF pp. 93-99)
#
# Lonelywood connects only to Termalaine (a three-mile path); Termalaine to
# Targos and, by a snowy six-hour path, to Bryn Shander. So the way north from
# Bryn Shander's gate runs through Termalaine: the most picturesque town in
# Icewind Dale, carved with wizards, homunculi, tigers and smiling djinn, until
# the north wind finds you.
#
#   Speaker Oarus Masthew, half-orc, adopted son of the old speaker Shaelen,
#   who won a close election and lacks the militia's support; the Blue Clam
#   (Vernon Braig's chowder); the Eastside (Marta Peskryk, her bedridden father
#   Clyde, her song, and the ring of warmth on a chain round her neck).
#
#   "A Beautiful Mine": Darmo Mazlu shouts the news from his box. The gem mine
#   is closed: kobolds. Oarus never mentions that his own militia refused to
#   clear it, because officers in Naerth's pocket want him out. In the mine:
#   M1 tools and tracks; M2 tourmaline; M3 the river cavern and two giant rats;
#   M4 the miners' benches and a little stone dog; M5 the shaft walkway, where
#   two kobold saboteurs saw at the struts; M6/M7 the bucket lift; M8 the
#   grell's lair; M9 two hungry kobolds; M10 the bucket shuttle across the
#   shaft; M11 Trex, with his fake dragon wings and his satchel, possessed by
#   the ghost of Janth Alowar, a sage killed by a yeti two years ago; M12 a
#   mind flayer's fossil skull and the psi crystal inside; M13 the geodes.
#   How it ends depends on what's left down there: the grell, the ghost, the
#   kobolds.
#===============================================================================
module FrostThaw
  SW_TM_MINE_OPEN   = 4059   # you've taken Oarus's job (the trail to the mine is open)
  SW_TM_SABOTEURS   = 4060   # Scorp and Thwip are dealt with
  SW_TM_RATS        = 4061   # the river cavern's giant rats are beaten
  SW_TM_GREK        = 4062   # Grek and Smol are beaten or fled
  SW_TM_GRELL       = 4063   # the grell is dead
  SW_TM_TREX        = 4064   # Trex's business is settled (the kobolds leave the tunnel)
  SW_TM_KOBOLDS_TOWN = 4065  # the kobolds came to live in Termalaine
  SW_TM_OARUS_GONE  = 4066   # Oarus went into the mine and didn't come back (the grell)
  SW_TM_BUCKET      = 4067   # the bucket lift is down (level 2 reachable)

  MAPS.merge!(termalaine: 2120, termalaine_path: 2121, blue_clam: 2122, eastside: 2123,
              gem_mine: 2135, gem_mine_deep: 2136)
  MAP_NAMES.merge!(2120 => "Termalaine", 2121 => "Termalaine Path", 2122 => "The Blue Clam", 2123 => "The Eastside",
                   2135 => "Termalaine Gem Mine", 2136 => "Termalaine Gem Mine (Deep)")
  MAP_METADATA.merge!(
    2120 => { outdoor_map: true, announce_location: true, weather: [:Snow, 80], battle_environment: :Snow },
    2121 => { outdoor_map: true, announce_location: true, weather: [:Snow, 100], battle_environment: :Snow },
    2123 => { teleport_destination: [2120, 33, 21] },
    2135 => { announce_location: true, battle_environment: :Cave },
    2136 => { announce_location: true, battle_environment: :Cave }
  )
  AREAS.merge!(2120 => :termalaine, 2121 => :termalaine_path, 2122 => :termalaine, 2123 => :termalaine,
               2135 => :gem_mine, 2136 => :gem_mine)
  TERMALAINE_REST = [2120, 33, 21, 2]

  ENCOUNTERS[2121] = { step_chances: { Land: 21 },
                       Land: [[25, :SWINUB, 14, 16], [20, :SNORUNT, 14, 16], [15, :HOOTHOOT, 14, 16],
                              [15, :SNEASEL, 15, 17], [10, :DELIBIRD, 15, 17], [10, :TEDDIURSA, 14, 16], [5, :STANTLER, 16, 17]] }
  ENCOUNTERS[2135] = { step_chances: { Cave: 6 },
                       Cave: [[30, :ZUBAT, 15, 18], [25, :GEODUDE, 15, 18], [20, :RATTATA, 15, 17], [15, :ONIX, 16, 18], [10, :GIBLE, 16, 18]] }
  ENCOUNTERS[2136] = { step_chances: { Cave: 8 },
                       Cave: [[30, :ZUBAT, 17, 19], [25, :GRAVELER, 17, 19], [20, :RATICATE, 17, 19], [15, :GIBLE, 17, 19], [10, :MISDREAVUS, 18, 19]] }
  MARTS[:termalaine] = [:POKEBALL, :GREATBALL, :POTION, :SUPERPOTION, :ANTIDOTE, :PARLYZHEAL, :AWAKENING,
                        :BURNHEAL, :ICEHEAL, :ESCAPEROPE, :REPEL]

  RELIC_ITEMS.merge!(
    FT_TOURMALINE: ["Tourmaline", "Tourmalines", 1, 400,
      "A translucent gemstone from the Termalaine mine. Pale green, pink, black... no two the same.", 0, 0, 0],
    FT_GEODE: ["Geode", "Geodes", 1, 300,
      "An intact geode from the Termalaine mine. Glassy crystals inside, like frozen fireworks.", 0, 0, 0],
    FT_PSICRYSTAL: ["Psi Crystal", "Psi Crystals", 8, 0,
      "A crystal grown in a dead mind flayer's brain. Hold it, and you hear a cry for help from very far away, over and over.", 0, 0, 6],
    FT_RINGOFWARMTH: ["Ring of Warmth", "Rings of Warmth", 8, 0,
      "A plain ring, warm as a hand. A woman in a red cloak gave it to Marta's grandparents fifty years ago, fleeing the wind.", 0, 0, 6]
  )

  TRAINER_TYPES.merge!(FT_MINER: ["Miner", :HIKER, 0, 40],
                       FT_SPIRIT: ["Restless Spirit", :CHANNELER, 0, 0])
  TRAINER_INTROS.merge!(
    path_hiker_dun:    "DUN: Termalaine path's mine, stranger! My path! Battle for it!",
    path_skier_esk:    "ESK: The wind off the lake can knock you flat. Can you knock me flat?",
    path_aurilite_rho: "RHO: The north wind is Hers. Termalaine was built right in its teeth.",
    miner_jory:        "JORY: Mine's closed, so I'm out here with nothing to hit but you.",
    tm_officer_varn:   "VARN: The Speaker sent you to do our job? Let's see if you're worth his gold."
  )
  TRAINERS.merge!(
    path_hiker_dun:    [:HIKER, "Dun", [[:GEODUDE, 15], [:B74H220, 16]], "Fine! It's your path too. Mind the drifts."],
    path_skier_esk:    [:BEAUTY, "Esk", [[:SMOOCHUM, 15], [:B124H215, 16]], "Flat. Very flat. I'll stay down here a while."],
    path_aurilite_rho: [:FT_AURILITE, "Rho", [[:SNORUNT, 16], [:B220H92, 16]], "The wind will have you anyway."],
    miner_jory:        [:FT_MINER, "Jory", [[:GEODUDE, 16], [:ONIX, 17]], "Should've been kobolds you were hitting. Not me."],
    tm_officer_varn:   [:FT_MILITIA, "Varn", [[:GROWLITHE, 16], [:B227H58, 17]], "...You'll tell Masthew we helped. Won't you."],
    trex_ghost:        [:FT_SPIRIT, "Janth", [[:MISDREAVUS, 18], [:B200H92, 19]], "My lichens... my... lichens..."]
  )
  TRAINER_INTROS[:trex_ghost] = "JANTH: (from the empty air where the kobold was) You'll carry my satchel. You'll carry ME."

  TEXT.merge!(
    sign_termalaine: ["TERMALAINE", "Speaker: Oarus Masthew.", "The heraldry: a fish's open jaws swallowing a rose-pink tourmaline, on sky blue."],
    sign_termalaine_path: ["TERMALAINE PATH", "North to Termalaine (six hours, on foot). Mind the wind off the lake."],
    tm_carvings: ["The houses are carved with wizards and homunculi, tigers and smiling djinn. Calishite work, old and fine.",
                  "Termalaine is the most picturesque town in Icewind Dale. Then the north wind gets through your coat."],
    tm_wind: ["The wind comes straight down off the lake and through every layer you own.",
              "Termalaine was built right in its path. Nobody remembers why. Somebody probably thought it was pretty."],
    tm_fisher: ["We fish till dark, then the Blue Clam. Feet to the hearth, chowder, and Vernon's lies about the old days.",
                "Some nights a sled comes down from Lonelywood with a haunch of moose. Then we sing louder."],
    tm_miner_out: [{ if: { flag: :mine_done }, lines: ["Back to work! Picks in the walls again. Best sound in the world."] },
                   ["The mine's closed. Kobolds. We ran out when they came in. Didn't stop to ask what they wanted.",
                    "And Hessa never came back up, the week before. They say she fell down the shaft. They say."]],
    tm_shaelen: ["SHAELEN: Shaelen Masthew. I was Speaker here, once. Now I'm Oarus's mother, which is harder.",
                 "SHAELEN: His parents were adventurers. Half-orcs. They didn't come back from a job. I did.",
                 "SHAELEN: He won the speakership by a hair. Half the militia still won't salute him. He hasn't told you that, has he?"],
    tm_officer_hint: ["OFFICER: The mine? Not our job. Speaker asked. We declined.",
                      "OFFICER: Termalaine needs a speaker who knows how things work. Speaker Maxildanarr in Targos agrees.",
                      "OFFICER: You didn't hear that. Move along."],
    vernon_braig: ["VERNON: Vernon Braig. The Blue Clam's mine, and so's the chowder. Spiced. Sit by a hearth.",
                   "VERNON: I've hunters in Lonelywood who owe me. When a sled comes down the north trail with hares or moose, we eat like lords.",
                   "VERNON: Scrimshaw on the walls is all local. Best in the Dale. Don't tell Targos."],
    tm_rumour_hint: ["Fishers on long benches by the hearths, warming their feet."],
    eastside_tunnels: ["What looks from outside like separate houses is one building, its rooms joined by passages underground.",
                       "The guest rooms are in the cellar, out of the wind. Warmest beds in Termalaine."],
    clyde_peskryk: ["A retired fisherman, propped up in bed. He smiles at you, and doesn't try to talk.",
                    "MARTA: That's Da. He can't get up any more. He likes visitors. He likes the song."],
    mine_sign: ["A crude wooden sign propped against an empty cart: \"Kobolds only!\"",
                "It's written in charcoal, in far more elegant calligraphy than you'd expect from a kobold."],
    mine_tools: ["Racks of picks and hammers nailed to the walls. Rock dust on the floor, and tracks in it:",
                 "reptilian prints, mixed with human boots, and something like a pair of very big rats."],
    mine_river: ["An underground river, kept from freezing by vents somewhere below.",
                 "It leaves the cave through a narrow fissure in the south wall, gathering speed toward the shaft.",
                 "Anything that wades into that fissure goes down the shaft with it. Thousands of feet."],
    mine_benches: ["Benches and tables where the miners cleaned their stones. Gravel everywhere; dropped hammers; broken lanterns.",
                   "The miners left in a hurry."],
    mine_shaft: ["A walkway of planks and struts along the wall of a vertical shaft that just keeps going down.",
                 "A narrow waterfall cascades down the far wall. You have to shout to hear each other."],
    mine_landing: ["The bucket lift creaks down to a little cave with two dusty tunnels going opposite ways.",
                   "Lots of kobold feet have come and gone to the west. One set of kobold prints goes east, and doesn't come back."],
    mine_shuttle: ["The tunnel ends at the shaft. A bucket dangles on a rope stretched across it to a platform fifteen feet away.",
                   "Looking down: nothing but dark. Looking up: the underside of the walkway on level one."],
    mine_skull: ["A fossilised skull juts out of the wall at head height. Huge eye sockets, a ridge between them, no nose,",
                 "and four small holes where teeth should be."],
    mine_geodes: ["Sparkling geodes stick out of the walls like glassy shards. The floor rises to a ridge along the east wall."],
    mine_lift: ["A wooden pulley system around a hole in the floor. A bucket big enough for one person hangs on thick rope.",
                "A crank on the side raises and lowers it. It takes a minute either way."],
    oarus_after: [{ if: { flag: :oarus_possessed }, lines: ["OARUS: Have you ever really LOOKED at lichen? Crustose, foliose, fruticose...",
                                                            "OARUS: (He blinks.) ...Sorry. Where was I? I keep losing my place. Oh, look, moss."] },
                  { if: { flag: :mine_done }, lines: ["OARUS: The mine's open, the miners are back, and the militia's very quiet.",
                                                      "OARUS: I'll take quiet. Thank you. Termalaine owes you one."] },
                  ["OARUS: The mine's north-east of town. Half an hour on the trail. Bring a light."]],
    tm_house_closed: ["Carved shutters, carved lintel, a carved djinn grinning over the door. Nobody answers.",
                      "They're all out on the lake, or at the Blue Clam."],
    path_hiker_dun_after: ["DUN: Six hours of this path. I do it every week. It doesn't get shorter."],
    path_skier_esk_after: ["ESK: Lean into the wind. It's the only way to stay up."],
    path_aurilite_rho_after: ["RHO: Termalaine's pretty. The Frostmaiden likes pretty things. She keeps them."],
    miner_jory_after: [{ if: { flag: :mine_done }, lines: ["JORY: Back to work tomorrow! Thanks to you. Don't let it go to your head."] },
                       ["JORY: Fifty gold from the Speaker, they say. The militia won't touch it. Wonder why."]],
    tm_officer_varn_after: ["VARN: Masthew won by a hair. Hairs get cut."],
    tm_kobold_worker: ["KOBOLD: Termalaine! Warm! Work! The big ones laugh at our tails. Then they share chowder.",
                       "KOBOLD: Good town. Trex is quiet now. Trex is just Trex. That is fine. We like just Trex."]
  )

  PARTY_CHAT[:alberica].merge!(
    termalaine_path: ["Six hours of this, and then a town carved with djinn. I'll take the djinn."],
    termalaine: ["Darling, look at the carvings! Tigers! Little wizards! Somebody here had TASTE.", "...And then the wind. Of course."],
    gem_mine: ["Tourmalines. In the walls. I'm being very good. I'm not touching anything. Mostly."]
  )
  PARTY_CHAT[:reptin].merge!(
    termalaine_path: ["Every town on this lake hates every other town on this lake. Termalaine just hates more politely."],
    termalaine: ["A speaker the militia won't obey. I've worked for that kind of church.", "It never ends well for the priest."],
    gem_mine: ["Something's floating in the dark. I saw it once, at the edge of the lamp. I'd rather not see it twice."]
  )
  PARTY_CHAT[:alerion].merge!(
    termalaine_path: ["Keep together. This is the kind of road people walk off in the dark and aren't missed."],
    termalaine: ["Naerth's men are here too. Officers. You can tell by how they stand when the Speaker walks past."],
    gem_mine: ["My ring's cold. There's a dead man in here. Or what's left of one."]
  )
  PARTY_CHAT[:shade].merge!(
    termalaine_path: ["Footprints. Bare ones. He came this way too. Sephek."],
    termalaine: ["Kobolds in a mine aren't news. A speaker who can't order his own guards is."],
    gem_mine: ["Fancy handwriting on a kobold sign. Somebody's pretending to be something they aren't.", "I'd know."]
  )
  PARTY_CHAT[:shimmer].merge!(
    termalaine_path: ["Lonelywood's past Termalaine. He said Lonelywood. He's waiting.", "Let's not make him wait too long. Or too short."],
    termalaine: ["That girl at the inn. Her song. A woman in red, running from the wind.", "...I know how that one ends."],
    gem_mine: ["My stone hates it down here. It keeps turning toward the shaft."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # The town
  #-----------------------------------------------------------------------------
  def scene_termalaine_arrival
    say(["Termalaine spreads out from the shore of Maer Dualdon, bordered north and west by tall pines.",
         "The houses are carved with wizards and homunculi, tigers and smiling djinn.",
         "It's the most picturesque town in Icewind Dale. Then the north wind comes down off the lake and finds you."])
    sayc([cl(:alberica, "Oh, it's PRETTY. Why is it pretty? Nothing in this Dale is allowed to be pretty."),
          cl(:shade, "Give it a minute.")])
  end

  # Darmo Mazlu, on his box.
  def darmo_mazlu(event_id = nil)
    if flag?(:mine_done)
      return say(["DARMO: The gemstone mine is OPEN! Speaker Masthew says it's SAFE! Heroes from the south!",
                  "DARMO: (quieter) That's you. I'm shouting about you."], event_id)
    end
    say(["A boy wrapped in heavy winter clothes stands on a box, shouting the news at people who don't stop.",
         "DARMO: The gemstone mine is closed because of MONSTERS! Speaker Masthew is offering FIFTY GOLD to anyone who clears it out!",
         "He sees you've stopped. He looks delighted.",
         "DARMO: You want the mine? It's north-east, half an hour up the trail into the woods. It's very important for Termalaine.",
         "DARMO: Without the mine, nobody has any money. The Speaker's at the Blue Clam, on the docks. Go! Go!"], event_id)
    set_flag(:heard_of_mine)
  end

  # Oarus, outside the Blue Clam with a friend.
  def oarus_masthew(event_id = nil)
    set_flag(:mine_taken) if !flag?(:mine_taken) && $game_switches && $game_switches[SW_TM_TREX]
    if flag?(:mine_taken)
      return mine_report(event_id) if mine_report_ready?
      return janth_in_oarus(event_id) if flag?(:oarus_possessed) && !flag?(:janth_rested)
      return say(lines_for(:oarus_after), event_id)
    end
    say(["Two bundled-up figures are talking outside the tavern. One of them waves.",
         "OARUS: You seem entirely too prepared for trouble. Are you here about the mine?",
         "A broad half-orc with a sharp, tired face. Speaker Oarus Masthew.",
         "OARUS: A gang of kobolds crept into the gem mine a few days back. Came in from the surface. The miners ran.",
         "OARUS: Nobody's been killed. But kobolds are too much for miners with picks.",
         "OARUS: And a miner went missing the week before. Hessa. Some of them think something's crawled up from the Underdark.",
         "OARUS: I think she fell down the central shaft. It goes down so far you'd never find a body.",
         "OARUS: Fifty gold to whoever clears the mine. It matters, more than I can say. No mine, no money. No money..."], event_id)
    sayc([cl(:alerion, "Your militia can't deal with kobolds?"),
          "OARUS: (a pause that goes on a little too long) ...They're busy.",
          cl(:shade, "(aside) He asked them. They said no. That's a speaker with a problem.")])
    if pbConfirmMessage(_INTL("Clear out the gem mine for Speaker Masthew?"))
      say(["OARUS: Good. Good. North-east, the trail into the woods. Bring a light. Bring two."])
      set_flag(:mine_taken)
      set_switch(SW_TM_MINE_OPEN, true)
      state[:mine_goal_prev] = state[:goal]
      state[:goal] = "Termalaine's gem mine, north-east of town: kobolds. (Speaker Masthew pays fifty gold.)"
    else
      say(["OARUS: Then enjoy Termalaine. It's very pretty. Until you have to live in it."])
    end
  end

  def marta_peskryk(event_id = nil)
    if !flag?(:met_marta)
      set_flag(:met_marta)
      say(["A willowy teenager with her sleeves rolled up, carrying a basin. She's singing to herself:",
           "MARTA: \"Ahead of winter's wind she came / The lovely woman with no name;",
           "MARTA: Draped in a fur-lined cloak of red / To the icy lake she fled;",
           "MARTA: The wind pursued her all the same / As sure as night she's dead.\"",
           "She sees you, and blushes.",
           "MARTA: Marta. Marta Peskryk. I keep the Eastside. Me and Da. Well. Me. Da's poorly."], event_id)
      sayc([cl(:alberica, "Sweetheart, that's a lovely song and a terrible ending. Where's it from?")])
      say(["MARTA: Fifty years ago, a woman in a fur-lined red cloak stopped here on her way to Lonelywood.",
           "MARTA: She was alone, and frightened. My grandparents kept the inn then. Retired adventurers.",
           "MARTA: They tried to comfort her. She gave them a ring, for their kindness.",
           "MARTA: Not long after, a howling wind burst into the inn. It tossed her about like a rag doll.",
           "MARTA: Gran and Grandad got between them. The wind beat them senseless, and she got away.",
           "MARTA: Then it went on hunting her. Nobody ever saw her again.",
           "She touches a chain round her neck. On it, a plain ring.",
           "MARTA: This is it. It's always warm. Always. Even now."])
      sayc([cl(:shimmer, "(very quietly) A woman running from the wind."),
            cl(:reptin, "(gently) That's a ring of warmth, Marta. A real one.")])
    end
    if !flag?(:marta_ring) && pbConfirmMessage(_INTL("Ask Marta for the ring?"))
      say(["MARTA: (her hand closing round it) It's all I've got of them."])
      c = pbMessage(_INTL("What do you tell her?"),
                    [_INTL("\"It could help us end the winter.\""), _INTL("\"Never mind. Keep it.\"")], 1)
      if c == 0
        sayc([cl(:alberica, "Marta. We're going north, after the thing that's making this winter. All the way."),
              cl(:reptin, "Whoever she was, she was running from the same cold. Let it help us run toward it."),
              "MARTA: ...You mean it. You actually mean it.",
              "She unclasps the chain and puts the ring in your hand. It's warm as a hand.",
              "MARTA: Bring the summer back. That's the price. Da wants to see the lake thaw once more."])
        give_key(:FT_RINGOFWARMTH)
        set_flag(:marta_ring)
        wheel(1)
      else
        say(["MARTA: (relieved) Thank you. If it ever could help... come back and ask me again."])
      end
    end
    return if !pbConfirmMessage(_INTL("Rest at the Eastside?"))
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_rest_at(TERMALAINE_REST)
    say(["The cellar room is warm. Somewhere through the wall, Marta is singing to her father."])
  end

  #-----------------------------------------------------------------------------
  # The mine
  #-----------------------------------------------------------------------------
  # M2, M8, M13: chip at the walls with a pick for an hour and see what turns up.
  MINING_TABLE = [[80, nil], [15, :FT_TOURMALINE], [4, :FT_TOURMALINE], [1, :FT_TOURMALINE]]

  def mine_wall(kind, event_id = nil)
    key = :"mined_#{kind}_#{event_id}"
    if flag?(key)
      return say(["You've chipped this face back to bare rock."], event_id)
    end
    if kind == :geode
      say(lines_for(:mine_geodes), event_id)
      return if !pbConfirmMessage(_INTL("Spend an hour chipping out a geode?"))
      set_flag(key)
      say(["An hour of careful work, and a geode comes away whole in your hands."])
      return pbReceiveItem(:FT_GEODE) rescue nil
    end
    say(["Small gem deposits gleam in the rock, seductively."], event_id)
    return if !pbConfirmMessage(_INTL("Spend an hour chipping at the wall with a miner's pick?"))
    set_flag(key)
    roll = rand(100)
    if roll < 80
      say(["An hour of chipping. Rock dust, sore arms, and nothing else."])
    elsif roll < 95
      say(["A pebble-sized tourmaline, pale green, drops into your hand."])
      pbReceiveItem(:FT_TOURMALINE) rescue nil
    elsif roll < 99
      say(["An acorn-sized tourmaline! Flawed, but beautiful. Pink, going to black at one end."])
      pbReceiveItem(:FT_TOURMALINE, 3) rescue nil
    else
      say(["An acorn-sized tourmaline, perfect, the colour of a red sunset. Everyone stops to look at it."])
      pbReceiveItem(:FT_TOURMALINE, 10) rescue nil
    end
  end

  # M3: two giant rats.
  def mine_rats(event_id = nil)
    return if $game_switches && $game_switches[SW_TM_RATS]
    say(["Between you and the river: two halfling-sized grey rodents with long tails and beady eyes. They rush you."], event_id)
    if boss_battle(named_mon(:RATICATE, 16, "Giant rat"), named_mon(:RATICATE, 16, "Giant rat"))
      set_switch(SW_TM_RATS, true)
    end
  end

  # M4: the little stone dog.
  def mine_dog_figurine(event_id = nil)
    return say(lines_for(:mine_benches), event_id) if flag?(:mine_dog)
    say(lines_for(:mine_benches), event_id)
    say(["Under a bench: a small dog carved out of rock, with two pebble tourmalines for eyes. A miner made it on a break."])
    pbReceiveItem(:FT_TOURMALINE, 2) rescue nil
    set_flag(:mine_dog)
  end

  # M5: Scorp and Thwip, sawing at the walkway's struts from underneath.
  def mine_saboteurs(event_id = nil)
    return if $game_switches && $game_switches[SW_TM_SABOTEURS]
    say(lines_for(:mine_shaft), event_id)
    return if !pbConfirmMessage(_INTL("Look under the planks?"))
    say(["Under the walkway, clinging to the struts: two kobolds with saws, working away cheerily.",
         "They've almost cut through. Another day and the walkway would drop anyone heavier than two kobolds."])
    c = pbMessage(_INTL("What do you do?"), [_INTL("Shout at them to come up."), _INTL("Knock them off.")], 0)
    if c == 0
      say(["You shout over the waterfall. The kobolds squeak, drop their saws (down, down, gone), and scramble up onto the planks.",
           "SCORP: Don't hurt! Trex say break the walkway so big ones can't follow!",
           "THWIP: Trex say! Not us! We just saw!",
           "They bolt off toward the lift."])
      set_flag(:saboteurs_spared)
    else
      say(["One good thump on the planks. One kobold loses its grip and falls without a sound, down the shaft.",
           "The other scrambles up, shrieking, and runs."])
      sayc([cl(:reptin, "(staring down into the dark) ...That was a person. A small one. But a person."),
            cl(:alerion, "It was trying to drop us down the same hole.")])
      set_flag(:saboteur_killed)
    end
    set_switch(SW_TM_SABOTEURS, true)
  end

  # M6: the bucket lift to level 2.
  def mine_lift(event_id = nil)
    say(lines_for(:mine_lift), event_id)
    return if !pbConfirmMessage(_INTL("Ride the bucket down, one at a time?"))
    say(["A minute of creaking, one by one. Then you're all down."])
    transfer(*MINE_LIFT_BOTTOM)
  end

  def mine_lift_up(event_id = nil)
    return if !pbConfirmMessage(_INTL("Ride the bucket back up?"))
    transfer(*MINE_LIFT_TOP)
  end

  MINE_LIFT_BOTTOM = [2136, 22, 20, 2]
  MINE_LIFT_TOP    = [2135, 31, 9, 2]

  # M8: the grell. It hangs near the ceiling and waits for someone to be alone.
  def mine_grell(event_id = nil)
    return if $game_switches && $game_switches[SW_TM_GRELL]
    say(["Floating near the ceiling, fifteen feet up, almost invisible against the rock: a huge, pale brain with a beak,",
         "trailing long barbed tentacles. A grell.",
         "It sees there are several of you. It drifts back into the dark, and waits for one of you to wander off."], event_id)
    c = pbMessage(_INTL("What do you do?"), [_INTL("Attack it now, together."), _INTL("Back away, carefully.")], 0)
    if c == 1
      return say(["It lets you go. You feel it following. Thirty feet behind. Always thirty feet."])
    end
    if boss_battle(named_mon(:B114H92, 19, "Grell"))
      say(["The grell drops, twitching, and its tentacles go limp.",
           "Under the ledge where it nested: bones, and a miner's boot. Hessa didn't fall down the shaft."])
      sayc([cl(:alerion, "Something from the Underdark. Up the shaft, looking for food.")])
      set_switch(SW_TM_GRELL, true)
      set_flag(:grell_dead)
    end
  end

  # M9: Grek and Smol, poking a dead giant rat with javelins.
  def mine_grek(event_id = nil)
    return if $game_switches && $game_switches[SW_TM_GREK]
    say(["On a table in the miners' break room, two kobolds are poking a dead giant rat with their javelins.",
         "They screech when they see you and charge!"], event_id)
    if boss_battle(named_mon(:GIBLE, 17, "Grek"), named_mon(:GIBLE, 16, "Smol"))
      say(["The moment one of them is hurt, both have a change of heart and flee north, down the tunnel to level three."])
      set_flag(:grek_fled)
      set_switch(SW_TM_GREK, true)
    end
  end

  # M10: the bucket shuttle across the shaft.
  def mine_shuttle(event_id = nil)
    say(lines_for(:mine_shuttle), event_id)
    return if !pbConfirmMessage(_INTL("Haul yourselves across in the bucket, one or two at a time?"))
    say(["Hand over hand along the suspension rope, one at a time, the dark breathing up at you.",
         "Nobody looks down. Everybody looks down."])
    transfer(*($game_player.x > 22 ? MINE_SHUTTLE_FAR : MINE_SHUTTLE_NEAR))
  end

  MINE_SHUTTLE_FAR  = [2136, 20, 5, 4]
  MINE_SHUTTLE_NEAR = [2136, 25, 5, 6]

  # M11: Trex, with his fake wings and his satchel, and the ghost inside him.
  def trex(event_id = nil)
    return say(["The tunnel is empty now. A few scales, a few crumbs."], event_id) if $game_switches && $game_switches[SW_TM_TREX]
    say(["Three skittish kobolds lurk in a dusty tunnel. One wears fake dragon wings of thin wood and tattered white cloth,",
         "and a threadbare satchel over one shoulder. He raises his hands at once.",
         "TREX: We mean you no harm. Please don't hurt us.",
         "His Common is fluent. Better than fluent. His bodyguards, Vott and Zurk, look at him as if they've never heard him talk like that."], event_id)
    say(["TREX: We were chased out of the foothills of Kelvin's Cairn by a yeti, and sought refuge here.",
         "TREX: The miners took fright and fled before I could explain that we meant no harm.",
         "TREX: The everlasting winter has made the wilderness unsafe for my kind, and the preternatural cold dulls our wits.",
         "TREX: Please. We only want a place to stay out of this horrible weather. We can work. We won't cause trouble.",
         "TREX: Termalaine would be richer for having us."])
    sayc([cl(:shade, "(very quietly) \"Preternatural.\" He said preternatural. That kobold can't spell kobold."),
          cl(:alerion, "(his hand on his ring) Something's riding him. My ring's gone ice cold."),
          cl(:meat_meat, "Little lizard smells like old books. Meat Meat does not like it.")])
    opts = [_INTL("\"We'll take you to Termalaine.\""), _INTL("\"Give us the satchel.\""), _INTL("Attack.")]
    c = pbMessage(_INTL("What do you do?"), opts, 0)
    case c
    when 0
      say(["TREX: (smiling far too widely for a kobold) Thank you. Thank you. Termalaine. Yes. Somewhere... important."])
      set_flag(:kobolds_to_town)
      set_flag(:janth_unresolved)
      set_switch(SW_TM_KOBOLDS_TOWN, true)
    when 1
      say(["TREX: (clutching it) No. No. These are mine. My samples. Two years of moss and lichen and...",
           "His voice cracks into someone else's. An old man's. Then the kobold's eyes go white.",
           "JANTH: They are MINE. I died for them!"])
      return trex_ghost_battle
    else
      say(["Vott and Zurk throw themselves in the way, squealing. Trex falls back behind them.",
           "Then Trex's eyes go white, and a pale shape tears itself up out of him. The kobold drops like a sack.",
           "JANTH: Fine. FINE. I'll take one of YOU, then. One who can carry my satchel!"])
      return trex_ghost_battle
    end
    set_switch(SW_TM_TREX, true)
  end

  def trex_ghost_battle
    if !pbTrainerBattle(:FT_SPIRIT, "Janth", nil, false, 0)
      return say(["The ghost sinks back into the kobold. Trex blinks at you, frightened, and backs away into the dark."])
    end
    say(["The ghost of an old man in a sage's robe hangs in the air, flickering. He reaches for the satchel.",
         "JANTH: Janth. Janth Alowar. I catalogued the flora of the Dale. All of it. A yeti took my head in the foothills.",
         "JANTH: Two years. My samples. If they go, I go."])
    c = pbMessage(_INTL("What do you do with the satchel?"), [_INTL("Destroy it, and let him rest."), _INTL("Leave it be.")], 0)
    if c == 0
      sayc(["You tear the satchel open and scatter its moss and lichen into the river's spray. It's all gone in a moment.",
            "JANTH: ...Oh. Oh, that's... lighter. That's much lighter.",
            "He fades like breath on a window.",
            cl(:reptin, "(softly) Rest, scholar. The tundra will grow you more.")])
      set_flag(:janth_rested)
    else
      say(["You set the satchel down on a rock by the tunnel wall, gently. The ghost settles over it like dust.",
           "JANTH: (fading, but not gone) Someone will come. Someone always comes. Someone who can carry it..."])
      set_flag(:janth_unresolved)
    end
    say(["Trex sits up, shakes his head, and looks at you with small, ordinary kobold eyes.",
         "TREX: ...Where Trex? Why Trex wearing wings? Vott? Zurk? WHY TREX WEARING WINGS?"])
    sayc([cl(:alberica, "Darling, I've asked myself that about a lot of outfits. You'll be fine.")])
    c = pbMessage(_INTL("What about the kobolds?"), [_INTL("\"Come to Termalaine. You can work.\""), _INTL("\"Go. Get out of the mine.\"")], 0)
    if c == 0
      set_flag(:kobolds_to_town)
      set_switch(SW_TM_KOBOLDS_TOWN, true)
      say(["TREX: Work! Food! Warm! Yes yes yes."])
    else
      set_flag(:kobolds_left)
      say(["The kobolds scurry off up the tunnel, out of the mine, into the snow."])
    end
    set_switch(SW_TM_TREX, true)
  end

  # M12: the mind flayer's skull.
  def mine_skull(event_id = nil)
    say(lines_for(:mine_skull), event_id)
    return if flag?(:psi_crystal)
    sayc([cl(:alerion, "That's no animal. That's an illithid. A mind flayer. Old, very old."),
          cl(:reptin, "Leave it in the wall, perhaps? As a general policy for skulls?")])
    return if !pbConfirmMessage(_INTL("Pry the skull out of the rock?"))
    say(["The skull shatters as it comes away. Where its brain would have been: a crystal shard, faintly glowing.",
         "You lever it out with a pick. When your fingers close round it, you hear, very far away, a cry for help.",
         "Over and over. Not in any language. Just: HELP. HELP. HELP."])
    give_key(:FT_PSICRYSTAL)
    set_flag(:psi_crystal)
  end

  #-----------------------------------------------------------------------------
  # Back to Oarus
  #-----------------------------------------------------------------------------
  def mine_report_ready?
    !flag?(:mine_done) && $game_switches && ($game_switches[SW_TM_TREX] || flag?(:mine_cleared_kobolds))
  end

  def mine_report(event_id = nil)
    say(["OARUS: You're back! All of you. That's a good sign. Is it done?",
         "You tell him what was down there."], event_id)
    grell = flag?(:grell_dead)
    ghost_loose = flag?(:janth_unresolved) && !flag?(:janth_rested)
    if flag?(:kobolds_to_town)
      say(["OARUS: Kobolds. Living in Termalaine. (He rubs his face.) The council will love that. The militia will love that more.",
           "OARUS: ...They'll work? Really work? Then they'll have work. Menial work, mind. And we'll see."])
    end
    say(["OARUS: I'll go down myself, tomorrow, and inspect it. Can't pay you till I know it's safe. Stay a few days."])
    pbFadeOutIn {} rescue nil
    if !grell
      say(["Oarus goes into the mine the next morning with a lantern.",
           "He doesn't come out. That evening, the miners refuse to go in after him.",
           "Termalaine has no speaker."])
      sayc([cl(:alerion, "...The thing in the dark. We left it there."),
            cl(:reptin, "(very quietly) We should have gone back for it.")])
      set_flag(:oarus_dead)
      set_switch(SW_TM_OARUS_GONE, true)
      set_flag(:mine_done)
      return mine_finish
    end
    if ghost_loose
      say(["Oarus comes back up the trail the next day, smiling, a clump of lichen in his hand.",
           "OARUS: All clear! Perfectly safe. And the FLORA down there, have you ever really looked at it?",
           "OARUS: Crustose, foliose, fruticose... (He stops. He blinks.) ...I'm sorry. What was I saying?",
           "He pays you fifty gold. His handwriting on the receipt is beautiful, and nothing like a half-orc's."])
      sayc([cl(:alerion, "(very low) That isn't him. Not all of him."),
            cl(:shade, "The ghost. We left it down there, and it found someone who matters. Just like it wanted.")])
      set_flag(:oarus_possessed)
    else
      say(["Oarus comes back up the trail the next day, filthy and grinning.",
           "OARUS: Not a kobold, not a monster, not a sound but the river. The miners are already going back in.",
           "OARUS: Fifty gold, as promised. And Termalaine's thanks. The militia's too, whether they like it or not."])
    end
    if flag?(:kobolds_to_town)
      say(["Within the week the kobolds have jobs: hauling, sweeping, carrying tools. The townsfolk tease them about their tails.",
           "Then the townsfolk start sharing their chowder. By the end of the week, the kobolds have won them over."])
    end
    $Trainer.money += 5000
    pbMessage(_INTL("You got $5000!"))
    set_flag(:mine_done)
    mine_finish
  end

  # The ghost rode the satchel (or Trex) up to the surface and found someone
  # important. You can still lay him to rest: the satchel is on Oarus's desk.
  def janth_in_oarus(event_id = nil)
    say(lines_for(:oarus_after), event_id)
    sayc([cl(:alerion, "(his ring ice-cold) Janth. We know you're in there."),
          "OARUS: (the half-orc's face goes still, and an old man looks out of it) ...I only need a little longer. My samples...",
          "A threadbare satchel sits on the desk beside him, full of moss and lichen."])
    return if !pbConfirmMessage(_INTL("Destroy Janth's satchel?"))
    sayc(["You take the satchel out into the wind and shake its moss and lichen out over the lake. The gusts take it all.",
          "Behind you, Oarus sits down hard in the snow.",
          "OARUS: ...Have I been... talking about moss? For DAYS?",
          cl(:reptin, "(gently) Rest, scholar. The tundra will grow you more."),
          cl(:shade, "He'll be fine. He was already a speaker nobody listens to. Now he has a reason.")])
    set_flag(:janth_rested)
    set_flag(:oarus_possessed, false)
  end

  def mine_finish
    state[:goal] = state[:mine_goal_prev] if state[:mine_goal_prev]
    add_counter(:story_beats)
  end
end
