#===============================================================================
# Frost & Thaw - Ten-Towns as Rime of the Frostmaiden draws them (chapter 1)
#
# The people and places of the towns that Act I passes through, as the book
# describes them, and the rules the towns live by:
#
#  * The Ten-Towns Rumors table (RotF p. 18), told in the taverns.
#  * Sacrifices to Auril (p. 21): only Bryn Shander, Easthaven and Targos hold
#    the lottery; smaller towns give up their food (Lonelywood) or their warmth
#    (Good Mead, Dougan's Hole, Termalaine) on the night of the new moon.
#  * Targos (pp. 85-86): Owenn Tarsenel's Luskan Arms with its rats and the
#    Speaker's three caged flying snakes; "Ma" Ethen Yarbroul's Three Flags
#    Sailing; Jestin Hunrae's Triglio.
#  * Bryn Shander (pp. 31-33): Sheriff Markham Southwell; Garn the Hammer and
#    his sister Elza at Blackiron Blades; Copper Knobberknocker in Mishann's
#    attic, worried about Macreadus at the Black Cabin; Scramsax and his credit
#    at the Northlook; Ol' Bitey on the wall; and the Council of Speakers in
#    the Council Hall.
#===============================================================================
module FrostThaw
  SW_TT_COUNCIL_DONE = 4040    # the Council of Speakers has met (its chairs empty again)

  MAPS.merge!(keegan_house: 2124, council_hall: 2134, lakeshore_road: 2101)
  MAP_NAMES.merge!(2124 => "Velryn House", 2134 => "Council Hall", 2101 => "Maer Dualdon Shore Road")
  AREAS.merge!(2124 => :targos, 2134 => :council_hall, 2101 => :termalaine_path)
  MAP_METADATA.merge!(2101 => { outdoor_map: true, announce_location: true, weather: [:Snow, 60], battle_environment: :Snow })
  # RotF: the shore of Maer Dualdon between Targos and Termalaine
  ENCOUNTERS[2101] = { step_chances: { Land: 21 },
                       Land: [[25, :SWINUB, 13, 15], [20, :SNORUNT, 13, 15], [15, :SPHEAL, 13, 15],
                              [15, :HOOTHOOT, 13, 15], [10, :DELIBIRD, 14, 16], [10, :SNEASEL, 14, 16], [5, :STANTLER, 15, 16]] }
  TRAINERS.merge!(
    shore_hunter_ilsa: [:HIKER, "Edda", [[:SWINUB, 14], [:TEDDIURSA, 15]], "Four hours of shore, and you're the only thing I've caught."],
    shore_fisher_dov:  [:FISHERMAN, "Dov", [[:SPHEAL, 14], [:GOLDEEN, 15]], "Knucklehead trout. They're worth more than me. Ask anyone."]
  )
  TRAINER_INTROS.merge!(shore_hunter_ilsa: "EDDA: Trail's long and cold. Let's warm up.",
                        shore_fisher_dov: "DOV: You're on my ice. That's a battle where I'm from.")

  TRAINER_TYPES.merge!(
    FT_SELLSWORD: ["Sellsword", :BLACKBELT, 0, 60],
    FT_MILITIA:   ["Militia", :POLICE, 0, 50]
  )
  TRAINER_INTROS.merge!(
    scramsax: "SCRAMSAX: Pay up, or we do this the old way. I always liked the old way.",
    bhall_militia_1: "GARVIN: Sheriff Southwell's orders. Nobody walks up to the Speaker untested.",
    bhall_militia_2: "HASKEL: Last gap before the Speaker. Last chance to turn round."
  )
  TRAINERS.merge!(
    scramsax:          [:FT_SELLSWORD, "Scramsax", [[:MACHOKE, 18], [:B57H83, 18], [:B262H68, 19]],
                        "Ha! Still got it. Not as much as you, mind."],
    bhall_militia_1:   [:FT_MILITIA,   "Garvin",     [[:GROWLITHE, 14], [:MAGNEMITE, 14]],
                        "The Sheriff said strangers would come knocking. He didn't say they'd hit this hard."],
    bhall_militia_2:   [:FT_MILITIA,   "Haskel",  [[:SKARMORY, 14], [:B227H58, 15]],
                        "Walls hold. I don't, apparently."]
  )

  #-----------------------------------------------------------------------------
  # The Ten-Towns Rumors table (RotF p. 18), and who's already been dealt with.
  #-----------------------------------------------------------------------------
  # [rumour, flag that means it's old news (nil: never)]
  TEN_TOWNS_RUMORS = [
    ["In Bremen, fishers are being terrorised by a monster that lives in Maer Dualdon.",
     "Strange that none of the other towns on that lake have been harangued by it.", nil],
    ["In Bryn Shander, some dwarves will pay good money to anyone who can find a lost shipment for them.",
     "Iron ingots, on a sled. Somewhere out toward Kelvin's Cairn.", :mugs_done],
    ["In Caer-Dineval, no one's seen Speaker Crannoc for a long time. Fallen ill, they say.",
     "But sinister figures go in and out of the castle at odd hours.", nil],
    ["In Caer-Konig, the shops are beset by vandals and thieves nobody ever sees.",
     "Speaker Trovus could really use some help catching them.", nil],
    ["In Dougan's Hole, people live in fear of winter wolves that haunt the outskirts of town.",
     "As big as horses, they are, and smarter than normal wolves.", :kids_home],
    ["In Easthaven they caught an evil wizard who killed some adventurers. They mean to burn him at the stake.",
     "The captain of the guard wants adventurers for another job. Might be related. Might not.", nil],
    ["In Good Mead, the speaker was killed by a nine-foot-tall giant. It stole a shipment of honey mead.",
     "Without that mead, half the taverns in Ten-Towns might go dry!", :mead_returned],
    ["In Lonelywood, beware the dreaded white moose! It attacks loggers and trappers on sight.",
     "The town's best hunters can't catch it. They could use some help.", :white_moose_done],
    ["In Targos, a band of adventurers set off up Kelvin's Cairn, hunting Oyaminartok.",
     "She's a goliath who turns into a polar bear. Hurry, you might catch them up!", :climb_done],
    ["In Termalaine, Speaker Masthew has closed one of the gem mines. A gang of kobolds crept in.",
     "Anyone who clears out the mine can expect to be well paid.", :mine_done]
  ]

  TEXT.merge!(
    # --- The shore road: Targos to Termalaine, round Maer Dualdon (RotF) ----------
    targos_termalaine_road: [{ if: { flag: :badge_bryn }, lines: ["The east road to Termalaine, round the lake's east shore. About four hours on foot.",
                                                                  "Bryn Shander's diggers have cut the drifts back from the gate."] },
                             ["The east road to Termalaine runs outside the wall, round the lake's east shore.",
                              "It's buried in drifts higher than the gate. The speakers dig the roads out when the roads matter.",
                              "(Nobody's dug it out since the last storm.)"]],
    sign_shore_road_targos: ["MAER DUALDON SHORE ROAD", "West: Targos. North, up the east shore: Termalaine. Four hours. Keep the lake on your left."],
    shore_hunter_ilsa_after: ["Four hours of shore. I've walked it forty times. It never gets shorter, but it gets quieter."],
    shore_fisher_dov_after: ["Knucklehead trout bite best when the ice sings. Hear it? That groaning? That's singing."],
    sign_shore_road_tm: ["SHORE ROAD", "South-west round the lake to Targos. Four hours, if the drifts are kind."],
    shore_road_fisher: ["An ice fisher sits on an upturned bucket, a line down a hole in the lake, a sledge of knucklehead trout beside him.",
                        "FISHER: Targos boats fish the middle of the lake. Termalaine fishes the east side. Out here's nobody's.",
                        "FISHER: That's why the trout are fat. Don't tell either town."],
    # --- Targos: the Luskan Arms --------------------------------------------------
    luskan_rats: ["A rat scurries along the skirting and vanishes between the floorboards.",
                  "The floorboards are rotten. A cold draft comes up through them from the cellar."],
    luskan_decor: ["The oldest public house in Ten-Towns, built to look like an inn in Luskan, the City of Sails.",
                   "Most of the decor is two hundred years old: Luskan as it was before its decline.",
                   "The walls are sturdy. Nothing else is."],
    naerth_snakes: [{ if: { flag: :badge_targos }, lines: ["Three caged flying snakes coil on their perches. One has a message tube tied to its tail.",
                                                           "Off to some spy of the Speaker's, somewhere in Ten-Towns."] },
                    ["Behind the Speaker's chair, three slender snakes sleep in a cage. They have wings.",
                     "Naerth sends his messages by them. Nobody in Targos asks to whom."]],
    # --- Targos: Triglio -------------------------------------------------------
    triglio_sign: ["TRIGLIO - General Store.",
                   "\"Trig-lee-oh, lads, an' 'oist upon the line / Trig-lee-oh, lads, an' bring yon fishers in.\""],
    # --- Bryn Shander --------------------------------------------------------------
    bryn_heraldry: ["A banner over the gate: black antlers above a shaft of golden wheat, on a white field.",
                    "Bryn Shander's strength, and its prosperity on the tundra. Two years since the last wheat."],
    bryn_lanterns: ["Bright lanterns hang over the narrow streets and twist in the wind.",
                    "The only colour in town. Somebody climbs up every evening to keep them lit."],
    southwell_militia: ["MILITIA: Sheriff Southwell wants the walls walked every hour. So we walk the walls.",
                        "MILITIA: Bryn Shander can put two hundred and fifty spears on them. We've never had to. Yet."],
    elza_after_mugs: ["ELZA: My brother says the Battlehammer iron's the best he's ever ruined. High praise, from Garn."],
    copper_after: ["COPPER: Still nothing from Macreadus. Typical. Not a word, not a postcard, not a spark.",
                   "COPPER: ...Thanks for saying you'd look. Nobody looks."],
    council_clerk: [{ if: { flag: :council_session }, lines: ["CLERK: The chairs are empty again. They will be until something worse happens.",
                                                             "CLERK: Then they'll all come back and argue about it."] },
                    { if: { flag: :lottery_stand }, lines: ["CLERK: The speakers sat the morning after the draw. You missed it. Shouting, mostly.",
                                                            "CLERK: Speaker Shane kept Bryn Shander's name. The others went home to think about it."] },
                    ["CLERK: The Council Hall. The speakers of all ten towns sit here, when there's call to.",
                     "CLERK: Shared business. Disputes between towns. Which happen more, the colder it gets."]],
    council_plaques: ["Ten chairs around a long table, a plaque on each:",
                      "BRYN SHANDER. TARGOS. TERMALAINE. LONELYWOOD. BREMEN.",
                      "EASTHAVEN. GOOD MEAD. DOUGAN'S HOLE. CAER-DINEVAL. CAER-KONIG.",
                      "Dougan's Hole's chair is dusty. Lonelywood's has cookie crumbs on it."],
    council_charter: ["A charter on the wall, signed by ten speakers a little over a year ago:",
                      "\"On the night of each new moon, every town shall make its offering to the Frostmaiden,",
                      "as each town's speaker judges it can bear: a life, or its food, or its warmth.",
                      "We judge this a necessary evil, and will end it in a heartbeat when she is appeased.\"",
                      "Under it, in smaller writing: \"or dealt with in some other way.\""],
    # --- the sacrifices, in each town -------------------------------------------------
    sacrifice_warmth_gm: ["New moon nights, Good Mead gives the Frostmaiden its warmth.",
                          "No fires from dusk to dawn. Not the hive fire. Not the hearths. Not a candle.",
                          "We sleep in heaps, like the bees do. Anyone who lights a fire gets a beating. My cousin did."],
    sacrifice_warmth_dh: ["Warmth, that's what the Hole gives Her. One night a month, no fire.",
                          "We'd give a trout, but we ain't got trout to spare. We'd give a person, but we ain't got many o' those either."],
    sign_tundra_east: ["A trail east, off the road, onto the open tundra.", "Far off, a mountain: Kelvin's Cairn."],
    sign_kelvins_cairn: ["KELVIN'S CAIRN", "(Someone has scratched underneath: \"YETIS. GO HOME.\")"],
    velryn_scrimshaw: ["Shelves of Keegan's scrimshaw: whales, foxes, hares, walruses, all carved in knucklehead-trout bone.",
                       "Half of them are of a bearded man climbing things."],
    boy_home: ["Boy lies across Garret's feet and won't move for anybody. He thumps his tail at you."],
    sacrifice_food_lw: ["Lonelywood can't spare people. Too few of us. So we give Her our catch.",
                        "A whole day's trout, strung up on racks a mile out of town, every new moon.",
                        "Something comes for it in the night. Big footprints. We don't follow them."]
  )

  PARTY_CHAT[:alberica].merge!(
    council_hall: ["Ten chairs, and not one of them comfortable. That's how you know it's a government.",
                   "Darling, if I ever sit on a council, shoot me. Gently. In the foot."]
  )
  PARTY_CHAT[:reptin].merge!(
    council_hall: ["Ten towns that don't much like each other, agreeing on one thing: to feed Her.",
                   "The Flame would have called it a sin. I'm starting to think it's just arithmetic."]
  )
  PARTY_CHAT[:alerion].merge!(
    council_hall: ["They signed it. All ten of them. And then they went home and drew names."]
  )
  PARTY_CHAT[:shade].merge!(
    council_hall: ["Naerth's chair is nearest the door. Of course it is."]
  )
  PARTY_CHAT[:shimmer].merge!(
    council_hall: ["\"A necessary evil.\" That's what they always call it. Right before it's you."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # Rumours (taverns: Three Flags Sailing, the Northlook, the Blue Clam...)
  #-----------------------------------------------------------------------------
  def ten_towns_rumor(who, event_id = nil)
    fresh = TEN_TOWNS_RUMORS.reject { |_a, _b, done| done && flag?(done) }
    fresh = TEN_TOWNS_RUMORS if fresh.empty?
    state[:rumor_i] = ((state[:rumor_i] || -1) + 1) % fresh.size
    a, b, = fresh[state[:rumor_i]]
    say(["#{who}: #{a}", "#{who}: #{b}"], event_id)
  end

  #-----------------------------------------------------------------------------
  # Targos
  #-----------------------------------------------------------------------------
  # Owenn Tarsenel keeps the Luskan Arms; after the Velryns are reunited, his
  # rooms are free to you (Keegan's promise).
  def owenn_tarsenel(event_id = nil)
    if flag?(:climb_done)
      say(["OWENN: Keegan's friends sleep free. Garret's home. That's worth more than a room.",
           "OWENN: ...Two years since I've had good news to pass on. I'd forgotten how it sits."], event_id)
      if pbConfirmMessage(_INTL("Rest at the Luskan Arms?"))
        pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
        long_rest_taken
        say(["The rats keep you company all night. They mean well."])
      end
      return
    end
    say(["OWENN: Owenn Tarsenel. I keep the Arms. Oldest public house in Ten-Towns.",
         "A quiet, balding man. He polishes the same glass the whole time he talks.",
         "OWENN: Mind the floorboards. And the rats. And the Speaker's guests.",
         "OWENN: It'll be summer again one day, they tell me. (He doesn't believe it. You can see he doesn't.)"], event_id)
    sayc([cl(:alberica, "(softly) Oh, sweetheart. Somebody hug this man."),
          cl(:reptin, "(aside) Please don't hug the innkeeper.")])
  end

  # Triglio: Jestin Hunrae sells everything but fishing and sailing supplies.
  def jestin_hunrae(event_id = nil)
    if !flag?(:met_jestin)
      set_flag(:met_jestin)
      say(["JESTIN: Welcome to Triglio. Jestin Hunrae. Mind the hand.",
           "A scarecrow of a man. His left hand is wrapped and stiff.",
           "JESTIN: Fished the lake twenty years. A Termalaine boat came out of the fog and crushed it against the rail.",
           "JESTIN: So now I sell everything a body needs. Except fishing gear and sailing gear.",
           "JESTIN: Targos has crafters for those. And I don't like to look at it."], event_id)
    end
    mart(:targos, event_id)
  end

  #-----------------------------------------------------------------------------
  # Bryn Shander
  #-----------------------------------------------------------------------------
  def sheriff_southwell(event_id = nil)
    if flag?(:lottery_stand)
      say(["SOUTHWELL: Markham Southwell. Sheriff. I command the militia, for what that's worth against weather.",
           "SOUTHWELL: I was on the square last night. Torch in my hand, same as always.",
           "SOUTHWELL: First time I didn't have to drag anybody to the post. I'd like that to keep happening.",
           "SOUTHWELL: So whatever you're going to do about Her, do it quick."], event_id)
    else
      say(["SOUTHWELL: Markham Southwell, Sheriff of Bryn Shander. You're the strangers off the Targos road.",
           "SOUTHWELL: Speaker Shane runs the town. I run the walls. Stay on the right side of both.",
           "SOUTHWELL: Draw's at sundown. On a draw night nobody leaves. Not you, not anyone."], event_id)
    end
  end

  # Blackiron Blades: Garn the Hammer makes the cheapest blades in Ten-Towns;
  # his sister Elza sells the gear. After Foaming Mugs: ten percent off.
  def garn_hammer(event_id = nil)
    if flag?(:mugs_done)
      return say(["GARN: Battlehammer iron! Three hundred ingots! I can make three hundred bad swords with that!",
                  "GARN: ...Good swords. I meant good. Elza, tell them I meant good.",
                  "GARN: You get a tenth off anything in this shop, forever. Don't argue. Elza already wrote it down."], event_id)
    end
    say(["GARN: Garn the Hammer! Cheapest blades in Ten-Towns!",
         "A shield dwarf with forearms like hams, beaming at you over a rack of very dull swords.",
         "GARN: The sellswords laugh. \"An' 'e was carryin' a Blackiron blade, to boot!\" Ha! They come back, though.",
         "GARN: Nobody else sells swords this cheap. Nobody."], event_id)
    sayc([cl(:shade, "(testing an edge with a thumb) There's a reason for that."),
          cl(:alerion, "It's a sword. It's pointy. It's enough.")])
    if !flag?(:mugs_done) && flag?(:mugs_taken)
      say(["GARN: Hruna's lot lost my iron out on the tundra? Bah. No iron, no blades. No blades, no jokes about my blades."])
    end
  end

  def elza_shop(event_id = nil)
    if !flag?(:met_elza)
      set_flag(:met_elza)
      say(["ELZA: Elza. Garn's sister. He makes the swords; I sell the things that keep you alive long enough to use them.",
           "ELZA: Rations, cold-weather gear, ice picks, snowshoes. Poké Balls, potions. Whatever the tundra wants from you."], event_id)
    elsif flag?(:mugs_done) && first_time?(:elza_thanked)
      say(lines_for(:elza_after_mugs), event_id)
    end
    stock = MARTS[:bryn].dup
    $game_temp.mart_prices = {} if $game_temp && $game_temp.mart_prices.nil?
    if flag?(:mugs_done) && $game_temp
      stock.each do |item|
        price = (GameData::Item.get(item).price rescue 0)
        next if price <= 0
        $game_temp.mart_prices[item] = [(price * 9 / 10.0).round, -1]
      end
      say(["ELZA: Your tenth's already off. Garn insisted. Loudly."], event_id)
    end
    pbPokemonMart(stock)
  ensure
    $game_temp.clear_mart_prices if $game_temp && $game_temp.respond_to?(:clear_mart_prices)
  end

  # Mishann's attic: Copper Knobberknocker, a pessimistic rock gnome tinkerer
  # in a fuzzy suit, worried about his friend Macreadus at the Black Cabin.
  def copper_knobberknocker(event_id = nil)
    if flag?(:copper_asked)
      return say(lines_for(:copper_after), event_id)
    end
    say(["A rock gnome in a fuzzy hooded suit he clearly made himself. He looks like a very small, very cross bear.",
         "COPPER: Copper Knobberknocker. I rent the attic. I help with the services. Begrudgingly.",
         "MISHANN: (from below) You help with nothing!",
         "COPPER: The Morninglord is Lathander, Mishann!",
         "MISHANN: The Morninglord is AMAUNATOR!",
         "COPPER: ...We do this every day. It's the only warm thing in the house.",
         "He sighs, and his whole suit sighs with him.",
         "COPPER: Listen. I've a friend. Macreadus. He's doing research out at an old cabin in the wilderness.",
         "COPPER: He's building a device. He thinks it could end the Frostmaiden's winter. Bring the summer back.",
         "COPPER: It won't work. Nothing works. But I haven't heard from him in weeks.",
         "COPPER: If you're ever out that way, near the Black Cabin... would you look in on him?"], event_id)
    c = pbMessage(_INTL("What do you say?"), [_INTL("\"We'll look in on him.\""), _INTL("\"Where's the Black Cabin?\"")], 0)
    if c == 1
      say(["COPPER: Out on the tundra, past Bryn Shander. Nobody goes there. That's the point of a cabin.",
           "COPPER: You won't go either. Nobody does. ...But if you do."])
    else
      say(["COPPER: You won't. Nobody ever does. (He looks at you a moment longer.) ...But thank you for saying it."])
    end
    sayc([cl(:reptin, "A device to end winter, built in a cabin. I've heard worse plans. Mostly from us."),
          cl(:alberica, "Sugar, I adore your suit. Is there one in my size?"),
          "COPPER: ...There could be."])
    set_flag(:copper_asked)
  end

  # The Northlook: Scramsax, a retired sellsword, lets adventurers between
  # jobs stay on credit, then hands them a bill fattened with interest.
  SCRAMSAX_ROOM = 300

  def scramsax_tab
    (state[:scramsax_tab] || 0).to_i
  end

  def scramsax(event_id = nil)
    if scramsax_tab > 0
      owed = scramsax_tab + scramsax_tab / 2       # his interest
      say(["SCRAMSAX: Ah. My favourite debtors. You stayed on credit, remember? Interest's been working while you weren't.",
           "SCRAMSAX: That's $#{owed}. And I don't take \"later\" for an answer."], event_id)
      if $Trainer.money >= owed
        if pbConfirmMessage(_INTL("Pay Scramsax ${1}?", owed))
          $Trainer.money -= owed
          state[:scramsax_tab] = 0
          say(["SCRAMSAX: Pleasure doing business. Bed's yours whenever. Same terms."])
        else
          scramsax_collects(owed)
        end
      else
        say(["SCRAMSAX: Short? Everyone's short. That's why I keep this.",
             "He lays a notched old sword on the bar. It hasn't been oiled for show."])
        scramsax_collects(owed)
      end
      return
    end
    if !flag?(:met_scramsax)
      set_flag(:met_scramsax)
      say(["SCRAMSAX: Scramsax. I own the Northlook. Rowdiest house in Bryn Shander, and the best place in the Dale for a lead.",
           "A grey old sellsword with more scar than face.",
           "SCRAMSAX: I know how an adventurer's life goes. Flush one week, eating snow the next.",
           "SCRAMSAX: So I'll let you stay on credit, between jobs. You pay me when you're paid. With a little extra for my trouble."], event_id)
    end
    northlook_keeper(event_id)
  end

  def scramsax_collects(owed)
    say(["SCRAMSAX: Then we'll settle it the old way. Don't worry. I go easy on regulars. Ish."])
    if pbTrainerBattle(:FT_SELLSWORD, "Scramsax", nil, false, 0)
      say(["SCRAMSAX: (wiping his mouth) Ha! Still got it. You've still got it more. Call it square.",
           "SCRAMSAX: Don't tell anybody. Bad for business."])
      state[:scramsax_tab] = 0
    else
      paid = [$Trainer.money, owed].min
      $Trainer.money -= paid
      state[:scramsax_tab] = [owed - paid, 0].max
      say(["SCRAMSAX: Told you. I don't take \"later\". I take what's in your purse."])
    end
  end

  # Resting at the Northlook: free if you can pay, on credit if you can't.
  def northlook_rest_on_credit?
    return false if $Trainer.money >= SCRAMSAX_ROOM
    say(["SCRAMSAX: Can't pay? Between jobs? Stay on credit. You'll settle up after your next payday."])
    state[:scramsax_tab] = scramsax_tab + SCRAMSAX_ROOM
    true
  end

  # Ol' Bitey, the stuffed knucklehead trout over the hearth: it snaps at
  # anyone within reach, and now and then it sings.
  def ol_bitey(event_id = nil)
    state[:bitey] = (state[:bitey] || 0) + 1
    if state[:bitey] % 3 == 0
      pbSEPlay("Voltorb Flip tile") rescue nil
      say(["The stuffed fish on the plaque turns its head toward you, opens its mouth, and sings:",
           "OL' BITEY: There's a place I like to go / Farther up the river's flow;",
           "OL' BITEY: Where it is, I do not know; / Must be under all that snow.",
           "Then it's just a fish on a board again."], event_id)
      return
    end
    pbSEPlay("Bite") rescue nil
    $game_screen.start_shake(2, 8, 6) rescue nil
    say(["A battle-scarred knucklehead trout, stuffed and mounted over the hearth. A brass plate: OL' BITEY.",
         "You lean in to read it. The fish turns and SNAPS at your nose!",
         "SCRAMSAX: Ha! Gets everyone. Kintyre and the Maverick hauled him out of Maer Dualdon.",
         "SCRAMSAX: Pulled half the fishers on that lake under, he did. I bought him off 'em before they could cook him.",
         "SCRAMSAX: Some prankster wizard put a spell on him years back. Now he bites. Sometimes he sings."], event_id)
    sayc([cl(:shade, "I like him. Professional."),
          cl(:alberica, "(very seriously) Darling, I need that fish to sing at my funeral.")])
  end

  #-----------------------------------------------------------------------------
  # The Council of Speakers (RotF p. 21): they meet, infrequently, in the
  # Council Hall in Bryn Shander. The morning after Bryn Shander kept its name
  # on a draw night, Speaker Shane calls them together.
  #-----------------------------------------------------------------------------
  # Stepping in from the door: if the speakers are sitting, the session starts.
  def council_enter(event_id = nil)
    return if !council_sitting?
    council_session(event_id)
  end

  def council_sitting?
    flag?(:lottery_stand) && !flag?(:council_session) && !flag?(:termalaine_arrived) && !flag?(:lonelywood_arrived)
  end

  def council_session(event_id = nil)
    if !council_sitting?
      return say(lines_for(:council_clerk), event_id)
    end
    set_flag(:council_session)
    st = Stage
    if st.map?
      st.actor(:duvessa, 10, 5, 2, graphic: "BW_Jasmine")
      st.actor(:naerth, 6, 5, 2, graphic: "BW_giovanni")
      st.actor(:oarus, 14, 5, 2, graphic: "BWHiker")
      st.actor(:kendrick, 8, 9, 8, graphic: "BW (72)")
      st.actor(:danneth, 12, 9, 8, graphic: "BW (54)")
    end
    say(["The Council Hall is full for the first time in a year.",
         "Duvessa Shane sits at the head of the long table. Young. Tired. Very straight.",
         "Down one side: Naerth Maxildanarr of Targos, drumming his rings on the wood.",
         "A broad half-orc in a Termalaine coat: Speaker Oarus Masthew. He keeps glancing at the door, as if he's needed elsewhere.",
         "A huge man with a beard like a hedge: Kendrick Rielsbarrow of Good Mead, a mug of his own town's mead at his elbow.",
         "Danneth Waylen of Easthaven, a plain, humble man wrapped to the eyes, steam coming off his furs.",
         "Lonelywood's chair is empty, except for a basket of halfling-shaped cookies. Dougan's Hole's chair is empty, full stop.",
         "DUVESSA: Last night Bryn Shander drew a name and did not give it up.",
         "DUVESSA: I won't apologise for it. I'm telling you because we agreed to do this together, and I broke it alone."])
    say(["NAERTH: Alone? (He smiles at you.) I'd say she had help.",
         "NAERTH: Strangers off my docks. I let them out of Targos. I'm starting to think I should be charging them rent.",
         "DANNETH: Easthaven drew too, last night. A fisher's widow. She walked out onto the ice herself. I let her.",
         "DANNETH: If Bryn Shander stops and Easthaven doesn't, and the storm comes for both of us anyway...",
         "KENDRICK: Good Mead gives its warmth. Our people sleep in a heap round the hive like bees, one night a month.",
         "KENDRICK: It's miserable. It doesn't kill anybody. I'd sooner do that a hundred nights than draw one name.",
         "OARUS: Termalaine gives warmth too. And my own militia won't walk the walls for me, so don't ask me to promise anything."])
    sayc([as(:alberica, "Excuse me. Speakers. Hello. Who wrote \"necessary\" in that charter?"),
          "NAERTH: All of us, my dear. Unanimously.",
          as(:alberica, "Then you can all unwrite it."),
          "DUVESSA: (quietly) We'd end it in a heartbeat. It says so. If She were appeased.",
          "DUVESSA: Or dealt with some other way."])
    sayc([cl(:reptin, "(gently) Speaker, what would \"some other way\" look like, to this council?"),
          "OARUS: Like somebody walking out of that door and doing something none of us can.",
          "KENDRICK: (raising his mug to you) Like that, maybe.",
          "NAERTH: Or like five strangers getting themselves killed and the storm coming anyway. We'll see which."])
    say(["DUVESSA: Then the charter stands, for every town that wants it. Bryn Shander draws no more names on my word...",
         "DUVESSA: ...until the next storm comes. And then I'll be back in this chair, eating this.",
         "She takes a halfling-shaped cookie out of Lonelywood's basket, looks at it, and bites its head off.",
         "The speakers file out. Kendrick claps you on the shoulder hard enough to hurt.",
         "KENDRICK: Come to Good Mead when this is done. First cask's on me."])
    Stage.cleanup rescue nil
    set_switch(SW_TT_COUNCIL_DONE, true)
    add_counter(:story_beats)
  end
end
