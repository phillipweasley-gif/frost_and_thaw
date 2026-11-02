#===============================================================================
# Frost & Thaw - Act I, Chapter 4: Dougan's Hole
#
# The Eastway, Good Mead (map 1.12) and Dougan's Hole (map 1.7) of Rime of the
# Frostmaiden, its "Holed Up" quest (map 1.8, Garagai's ice lodge), and the
# first meeting with the hag of the Cackling Chasm, who "plunged the remote
# town of Dougan's Hole into a magical deep-freeze" (The Cackling Chasm).
#
#   1. The Eastway out of Bryn Shander's east gate; Good Mead, leaderless, its
#      mead stolen; the Redwaters shore down to Dougan's Hole.
#   2. Dougan's Hole: winter wolves have taken Silja and Finn Dejarr and say
#      nobody leaves until the town pays. Speaker Edgra Durmoot believes the
#      children are dead and won't lift a finger. Dark shapes stand on the ice.
#   3. Koran, the "good" wolf, limps up with a story about a cruel frost giant.
#      Across the tundra (a starving pack: feed them, or drive them off) to
#      Garagai's ice lodge: Norsu the mammoth grieves his dead master; kobolds
#      hide in the war room; whale oil quiets the cage's hinges.
#   4. Koran and Kanan spring their trap on the way home. The children go home.
#   5. Gym 3: Speaker Durmoot, Ice and Ground.
#   6. That night the hag comes to the Twenty Stones of Thruun. Her mirrors
#      break, she flees laughing toward the chasm, and the shapes on the ice
#      thaw: her frozen victims, the Targos widow's husband among them.
#===============================================================================
module FrostThaw
  SW_DH_WEST_OPEN = 3918
  SW_KIDS_FREED   = 3919
  SW_KIDS_HOME    = 3920
  SW_DH_BADGE     = 3921
  SW_HAG_DOWN     = 3922
  SW_NORSU_CALM   = 3923
  SW_PACK_GONE    = 3924
  SW_KOBOLDS_GONE = 3925
  SW_WOLVES_GONE  = 3926

  MAPS.merge!(eastway: 2030, good_mead: 2031, mead_hall: 2032, cooperage: 2033, redwaters: 2034,
              dougans: 2035, durmoot_lodge: 2036, hilda_house: 2037, smokehouse: 2038, tundra: 2039, ice_lodge: 2040)
  MAP_NAMES.merge!(
    2030 => "The Eastway", 2031 => "Good Mead", 2032 => "Good Mead Mead Hall", 2033 => "Untapoor Cooperage",
    2034 => "Redwaters Shore", 2035 => "Dougan's Hole", 2036 => "Speaker Durmoot's Lodge", 2037 => "Hilda's House",
    2038 => "The Knucklehead Smokehouse", 2039 => "The Western Tundra", 2040 => "Garagai's Ice Lodge"
  )
  MAP_METADATA.merge!(
    2030 => { outdoor_map: true, announce_location: true, weather: [:Snow, 60], battle_environment: :Snow },
    2031 => { outdoor_map: true, announce_location: true, weather: [:Snow, 40], battle_environment: :Snow },
    2034 => { outdoor_map: true, announce_location: true, weather: [:Snow, 60], battle_environment: :Snow },
    2035 => { outdoor_map: true, announce_location: true, weather: [:Snow, 50], battle_environment: :Snow },
    2039 => { outdoor_map: true, announce_location: true, weather: [:Blizzard, 80], battle_environment: :Snow },
    2040 => { announce_location: true, battle_environment: :Cave }
  )
  AREAS.merge!(2030 => :eastway, 2031 => :good_mead, 2032 => :good_mead, 2033 => :good_mead, 2034 => :redwaters,
               2035 => :dougans, 2037 => :dougans, 2038 => :dougans, 2036 => :durmoot_lodge, 2039 => :tundra,
               2040 => :ice_lodge)
  MARTS[:good_mead] = [:POKEBALL, :GREATBALL, :POTION, :SUPERPOTION, :ANTIDOTE, :PARLYZHEAL, :AWAKENING,
                       :ICEHEAL, :BURNHEAL, :ESCAPEROPE, :REPEL, :SUPERREPEL, :HONEY]
  MARTS[:dougans]   = [:POKEBALL, :GREATBALL, :POTION, :SUPERPOTION, :ICEHEAL, :BURNHEAL, :PARLYZHEAL,
                       :ESCAPEROPE, :SUPERREPEL]
  # Where you wake after losing, once you've rested there.
  GOOD_MEAD_REST = [2031, 15, 11, 2]
  DOUGANS_REST   = [2035, 26, 22, 2]

  ENCOUNTERS[2030] = { step_chances: { Land: 21 },
                       Land: [[20, :STANTLER, 20, 23], [20, :SNEASEL, 20, 22], [15, :SWINUB, 20, 23],
                              [15, :DELIBIRD, 21, 23], [15, :TEDDIURSA, 20, 22], [10, :POOCHYENA, 20, 22],
                              [5, :SNORUNT, 21, 23]] }
  ENCOUNTERS[2034] = { step_chances: { Land: 21 },
                       Land: [[20, :SWINUB, 22, 24], [20, :SNORUNT, 22, 24], [15, :POOCHYENA, 22, 24],
                              [15, :HOUNDOUR, 22, 24], [10, :STANTLER, 22, 25], [10, :SNEASEL, 23, 25],
                              [10, :DELIBIRD, 22, 24]] }
  ENCOUNTERS[2039] = { step_chances: { Land: 25 },
                       Land: [[20, :POOCHYENA, 24, 26], [15, :MIGHTYENA, 25, 27], [15, :SNORUNT, 24, 26],
                              [15, :SWINUB, 24, 26], [10, :PILOSWINE, 26, 27], [10, :SNEASEL, 25, 27],
                              [10, :DELIBIRD, 24, 26], [5, :GLALIE, 26, 27],
                              [4, :YETOT, 24, 26]] }      # a yeti cub strayed down from the peaks
  VERSION_ENCOUNTERS[:frost][2030] = { Land: [[10, :SMOOCHUM, 20, 22]] }
  VERSION_ENCOUNTERS[:thaw][2030]  = { Land: [[10, :PHANPY, 20, 22]] }
  VERSION_ENCOUNTERS[:frost][2039] = { Land: [[10, :MISDREAVUS, 24, 26]] }
  VERSION_ENCOUNTERS[:thaw][2039]  = { Land: [[10, :GROWLITHE, 24, 26]] }

  COMPANION_NAMES[:meat_meat] ||= "MEAT MEAT"

  #-----------------------------------------------------------------------------
  # Trainers
  #-----------------------------------------------------------------------------
  TRAINER_TYPES.merge!(
    FT_TRAPPER: ["Trapper",    :HIKER,     0, 45],
    FT_HAG:     ["Granny",     :CHANNELER, 1, 150, :LEADER_Pryce],
    FT_HAG_NIGHT: ["Granny",   :CHANNELER, 1, 150, :LEADER_Pryce],   # her night at the Stones (SC 4.09)
    FT_SPEAKER_DH: ["Speaker", :POKEMONRANGER_F, 1, 100, :LEADER_Brock]
  )
  TRAINERS.merge!(
    # the Eastway
    ranger_hadd:    [:POKEMONRANGER_M, "Hadd",  [[:STANTLER, 22], [:B234H215, 23]],
                     "The Eastway's mine to watch. Today I watched me lose on it."],
    aurilite_seven: [:FT_AURILITE,     "Corra", [[:SNORUNT, 22], [:B87H215, 23]],
                     "The crone on the ice is Auril's. She keeps her the way you keep a dog."],
    hiker_durn:     [:HIKER,           "Durn",  [[:GRAVELER, 22], [:B231H220, 23]],
                     "Flattened. On the flattest road in the Dale."],
    musher_toma:    [:WORKER,          "Toma",  [[:POOCHYENA, 22], [:B503H58, 23]],
                     "My dogs pull sleds. They don't fight. You've proved it."],
    zhent_grisk:    [:FT_ZHENTARIM,    "Grisk", [[:KOFFING, 22], [:B109H198, 23]],
                     "Naerth will hear about this. Naerth hears about everything."],
    # the Redwaters shore
    fisher_vash:    [:FISHERMAN,       "Vash",  [[:BARBOACH, 23], [:B86H223, 24]],
                     "Knucklehead trout don't bite when the ice laughs. Neither do I."],
    skater_lys:     [:BEAUTY,          "Lys",   [[:SMOOCHUM, 23], [:B225H124, 24]],
                     "I skate Redwaters every winter. This one, I'll skate it faster."],
    aurilite_eight: [:FT_AURILITE,     "Nell",  [[:B427H200, 24], [:SNEASEL, 24]],
                     "The ones on the ice can hear you. It's all they can do."],
    trapper_birk:   [:HIKER,           "Birk",  [[:TEDDIURSA, 23], [:B217H220, 24]],
                     "Wolves took my best traps. You took my best Pokémon. Busy week."],
    channeler_mag:  [:CHANNELER,       "Mag",   [[:GASTLY, 24], [:B200H429, 25]],
                     "She laughed at me, child. From under the ice."],
    # Dougan's Hole
    fisher_rorik:   [:FISHERMAN,       "Rorik", [[:QWILFISH, 24], [:B211H86, 25]],
                     "Dougan's Hole folk fight the way we fish. Badly, and often."],
    # the tundra
    aurilite_nine:  [:FT_AURILITE,     "Vesk",  [[:B428H215, 26], [:GLALIE, 25]],
                     "Go on, then. To the giant's house. The cold's expecting you."],
    hunter_ulf:     [:HIKER,           "Ulf",   [[:PILOSWINE, 25], [:B503H310, 26]],
                     "I hunt wolves. Two of them hunt me back. The talking ones."],
    # Speaker Durmoot's lodge (Gym 3)
    trapper_brann:  [:FT_TRAPPER,      "Brann", [[:SANDSLASH, 26], [:B87H28, 26]],
                     "The Speaker's tougher than me. Most things are."],
    trapper_holt:   [:FT_TRAPPER,      "Holt",  [[:PILOSWINE, 26], [:DELIBIRD, 26]],
                     "Fair's fair. Go on back."],
    trapper_ysa:    [:FT_TRAPPER,      "Ysa",   [[:B232H220, 27]],
                     "Edgra skinned a winter wolf barehanded once. She says. I believe her."],
    durmoot:        [:FT_SPEAKER_DH,   "Durmoot", [[:B87H28, 27], [:B131H217, 27], [:B232H274, 29]],
                     "Hmph. Dougan's Hole doesn't bend. It can say thank you, though.", [:SUPERPOTION, :SUPERPOTION]],
    # the hag at the Twenty Stones
    hag:            [:FT_HAG_NIGHT,    "Thredra", [[:B429H124, 27], [:B255H200, 27], [:B124H429, 28]],
                     "Heh... heh-heh... The wheel turns, dearies. Let's see where it stops.", [:SUPERPOTION, :FULLHEAL]]
  )

  #-----------------------------------------------------------------------------
  # Dialogue
  #-----------------------------------------------------------------------------
  TEXT.merge!(
    bryn_east_guard_open: ["GUARD: Eastway's open. Good Mead's a day's walk. Dougan's Hole is half a day past.",
                           "GUARD: Nobody's come back from Dougan's Hole in a month.",
                           "GUARD: Be the ones who do."],
    # --- the Eastway -----------------------------------------------------------------
    sign_eastway_fork: ["THE EASTWAY", "North-east: Easthaven (road closed).", "South: Good Mead, then Dougan's Hole."],
    easthaven_digger: ["A slide came off the ridge and buried the Easthaven road.",
                       "Took the sled and both dogs with it. We'll dig it out by spring.",
                       "...Ha. Spring."],
    eastway_traveler: ["I'm walking to Bryn Shander. Good Mead's out of mead.",
                       "A giant stole it. No, really. A great ugly verbeeg, three casks under one arm.",
                       "Killed their Speaker doing it."],
    ranger_hadd_after: ["Wind's from the east today. Smells like the lake. Smells like nothing, really."],
    aurilite_seven_after: ["The crone's mirrors show you what you're afraid of.",
                           "I looked once. I saw myself, warm."],
    hiker_durn_after: ["Dougan's Hole's down the Good Mead road. They don't like visitors.",
                       "They don't much like each other, either."],
    musher_toma_after: ["Sled dogs howl different when winter wolves are about. Mine haven't stopped all week."],
    zhent_grisk_after: ["Shandar Froth in Good Mead keeps an eye on things for us. You didn't hear it from me."],
    # --- Good Mead -------------------------------------------------------------------
    sign_good_mead: ["GOOD MEAD", "Home of the finest honey mead in Ten-Towns.", "(Someone has scrawled underneath: \"OUT OF STOCK.\")"],
    gm_beekeeper: ["The hives are in the mead hall, by the big fire. Bees hate the Rime as much as we do.",
                   "Listen. Hear that? Still humming. Stubborn little things. Like this town."],
    shandar_froth: [{ if: { flag: :badge_dougans }, lines: ["SHANDAR: Back from the Hole, are you? See anything interesting?",
                                                             "SHANDAR: Asking for a friend. In Targos."] },
                    ["SHANDAR: Shandar Froth. Logger. Candidate for Speaker, as it happens.",
                     "SHANDAR: Good Mead needs a strong hand. Where are you bound? No reason. Just neighbourly."]],
    gm_townsfolk: ["The verbeeg came out of the woods three days back. Speaker Kendrick stood in its way.",
                   "Kendrick was a big man. The verbeeg was bigger. He's lying in the shrine now."],
    shrine_flaming_sword: ["SHRINE OF THE FLAMING SWORD. A painted Tempus raises a chipped red sword over the door.",
                           "Inside, under a blanket on the long table, lies Speaker Kendrick Rielsbarrow.",
                           "The town keeps a candle burning for him. (You don't go in.)"],
    gm_door_closed: ["The door is barred. Someone inside calls, \"We're not buying!\""],
    fef_moryn: ["FEF: Fef Moryn. Trapper. Five of the militia went after that verbeeg.",
                "FEF: I found what was left. Something big did it, with a club. Not the verbeeg. Something dumber.",
                "FEF: I'm not going back in those woods."],
    fef_fox: ["A white fox sits by Fef's boots, ears flat, watching the treeline."],
    mead_drinker: ["The last cask in Good Mead. We're drinking it slowly. In memory.",
                   "Mostly in memory."],
    mead_hive_keeper: ["The hive room's the warmest place in town.",
                       "The bees sleep in a ball round the queen. We sleep in a ball round the fire."],
    olivessa_untapoor: ["OLIVESSA: Headed to the Hole? Eat first. Nobody comes back from there fat.",
                        "She presses a honey cake into every hand in reach.",
                        "OLIVESSA: I make the casks. Cakes are a hobby. Feeding people is a hobby."],
    luna_camp_dh: ["LUNA CARVER: We keep what the cold leaves. We kept an egg for two years.",
                   "LUNA CARVER: The cold man sleeps on the sledge. His heart still beats.",
                   "LUNA CARVER: We'll watch it from here, at the edge of town."],
    cooper_apprentice: ["I'm learning to bend staves. Mostly I'm learning to hit my thumb."],
    # --- the Redwaters shore -------------------------------------------------------------
    sign_redwaters: ["REDWATERS", "Named for the old feud with Dougan's Hole, not the colour of the lake.", "(Mostly.)"],
    redwaters_icefisher: ["See that, way out on the ice? Been standing there three days. Doesn't move. Doesn't fish.",
                          "I called out to it once. Something laughed back.",
                          "Not it. Something under it."],
    fisher_vash_after: ["Cut a hole, drop a line, wait. That's the whole art. The waiting's the hard part."],
    skater_lys_after: ["Don't skate near the dark ones on the ice. It's thinner round them.",
                       "Like they're melting it from below."],
    aurilite_eight_after: ["Twenty stones in a ring, in Dougan's Hole. Older than the town. She likes old things."],
    trapper_birk_after: ["Dougan's Hole? Mind your fingers. They'll bite you for a trout."],
    channeler_mag_after: ["There's a chasm south of the Hole. It used to laugh. Now it waits."],
    # --- Dougan's Hole -----------------------------------------------------------------
    sign_dougans: ["DOUGAN'S HOLE", "Speaker: Edgra Durmoot.", "(Someone has carved a crude wolf into the post, and scratched it out.)"],
    sign_twenty_stones: ["THE TWENTY STONES OF THRUUN.", "Nineteen granite menhirs in a rough triangle, and one at the centre.",
                         "Nobody knows who raised them. They were here when Dougan Dubrace found the place."],
    dh_door_closed: ["Nobody answers. A curtain twitches."],
    dh_chorus_ears: [{ if: { flag: :kids_home }, lines: ["You brought 'em back! By Thruun's Stones, you brought 'em back!"] },
                     ["Them wolves are big as horses! They know words, an' a mighty lot of 'em!"]],
    dh_chorus_teeth: [{ if: { flag: :kids_home }, lines: ["Sil an' Finn are home! I'm gonna tell everybody! I already told everybody!"] },
                      ["They took Sil an' her brother Finn th' other day! Big ol' wolves did!"]],
    dh_chorus_sister: [{ if: { flag: :kids_home }, lines: ["Hilda's not stopped crying since. The good kind, mind."] },
                       ["Wolves say they ain't givin' 'em back till the town pays a king's ransom. Food an' gold.",
                        "This town can barely feed itself. An' there ain't no gold."]],
    dh_militia_block: ["MILITIA: Nobody leaves town. Them wolves swore they'd kill anyone who tries!",
                       "MILITIA: Speaker's orders. Don't like it, go tell Edgra. Big lodge, up the hill."],
    dh_militia_open: [{ if: { flag: :kids_freed, not_flag: :wolves_beaten }, lines: ["MILITIA: You found 'em? Then where are they?",
                                                                                     "MILITIA: Hid back in the giant's house while the wolves ran you off?",
                                                                                     "MILITIA: Then go back for 'em! The wolves'll be waitin' on the tundra."] },
                      { if: { flag: :kids_home }, lines: ["MILITIA: Speaker says you come an' go as you please. Says it like it hurts her."] },
                      ["MILITIA: Speaker says you're grown and can freeze where you like. West's that way."]],
    dh_pier_fisher: [{ if: { flag: :hag_defeated }, lines: ["They walked in off the ice this morning, every one. Blue as trout. Alive."] },
                     ["Those shapes on the ice? Fisherfolk. Some of ours, some from other towns.",
                      "They walked out one by one, the night the laughing started.",
                      "Nobody's brave enough to fetch 'em."]],
    dh_shapes_talk: [{ if: { flag: :hag_defeated }, lines: ["The laughing's stopped. First quiet night in a month. I don't trust it."] },
                     ["Don't look at the shapes too long. My husband looked too long.",
                      "Now he's out there with 'em."]],
    fisher_rorik_after: ["Good Mead started the feud. Don't let 'em tell you different."],
    silja_home: ["SILJA: You came. Nobody ever comes to Dougan's Hole. You came anyway.",
                 "SILJA: Finn says he could've got out himself. He couldn't."],
    finn_home: ["FINN: I almost had the slats bent. Almost.", "FINN: ...Thanks."],
    smoke_fisher: ["Knucklehead trout, smoked. It's what we eat, what we trade, and what we talk about."],
    smoke_trout_wife: ["We don't get many visitors. The ones we get mostly want something. What do you want?",
                       "...Oh. To help? Huh."],
    dh_lodge_guide: [{ if: { flag: :kids_home }, lines: ["The trappers are back off the ice line. They'll want a go at you first. Edgra likes it that way.",
                                                         "Her Pokémon are like her. Cold, thick-skinned, and they don't go down easy."] },
                     ["The trappers are all out on the ice line, watching for wolves. Edgra sent every one.",
                      "She'd never say it, but she's hoping. We all are."]],
    trapper_brann_after: ["Edgra's at the back. Mind the traps on the walls. Some are still set."],
    trapper_holt_after: ["The Speaker lost her husband to the ice. She doesn't lose anything else, if she can help it."],
    trapper_ysa_after: ["Go on. She's been waiting. She just won't say so."],
    # --- the tundra and the lodge ------------------------------------------------------------
    sign_tundra: ["West of Dougan's Hole: open tundra for thirteen miles.", "Beyond that, nothing. And then a house of ice."],
    aurilite_nine_after: ["The giant's dead. His beast isn't. Isn't that sad? Isn't that lovely?"],
    hunter_ulf_after: ["There's a starving pack out here. Ordinary wolves.",
                       "Don't mistake 'em for the talking kind."],
    garagai_tomb: ["Sealed in clear ice lies the hacked-up body of a frost giant. Garagai.",
                   "Whoever killed him took his axe and everything else.",
                   "They left him here for his mammoth to mourn."],
    norsu_calm: ["Norsu lies beside his master, head lowered. He doesn't look at you. That's a kindness."],
    ice_throne: ["A giant's throne, carved from one block of ice. A rune is cut into the backrest:",
                 "the Giant rune for \"ice\". It hums under your hand, like a held-back storm."],
    flensing_whale: ["The frozen body of a whale, crudely butchered. The air stinks of old decay."],
    flensing_knife: ["Beside the whale lies a paring knife the size of a longsword. Garagai's. Too heavy to lift."],
    stone_chest_empty: ["The stone chest holds only giant-sized flensing tools now."],
    chwinga_statuette: ["Under the table lies a little stone figure of a spindly creature. A chwinga.",
                        "It isn't a carving. It turned to stone when it died."],
    thrym_residue: ["A frosted white residue is smeared along the tunnel wall: thrym.",
                    "Remorhazes leave it just before they give birth.",
                    "Something big dug this tunnel. Something long gone, you hope."],
    lodge_side_opening: ["Ice has choked this opening solid."],
    # --- after the hag -------------------------------------------------------------------
    thawed_fisher_a: ["I walked out to my hole one night because I heard my name.",
                      "Then I was cold for a month. Then you."],
    thawed_old_man: ["She sat on the ice and drank tea with us. Every night. Phantom tea.",
                     "She asked about our children. I told her everything.",
                     "Gods forgive me, I told her everything."],
    thawed_husband: -> {
      T.set_flag(:husband_thawed)
      ["I'm from Targos. Came down fishing for knuckleheads, and heard someone laughing on the ice.",
       "My wife... she'll think I'm dead. Tell her I'm coming home.",
       "Tell her to keep the lamp lit."]
    },
    thawed_woman: ["The mirrors showed me my mother. She's been dead twenty years.",
                   "I followed her out onto the ice anyway."],
    thawed_fisher_b: ["She kept saying it. \"The wheel will turn.\" Like a threat."]
  )

  PARTY_CHAT[:alberica].merge!(
    eastway: ["Open country, finally. I can hear myself think.",
              "Not sure I like what I'm thinking. Sing something, someone. Anyone. Not Alerion."],
    good_mead: ["A town that makes honey wine out of nothing, in Icewind Dale.",
                "I want to write them a song. I want to drink them dry first. Out of respect."],
    redwaters: [{ if: { flag: :hag_defeated }, lines: ["The ice sounds different now, sweetheart. Like it's breathing out."] },
                ["The shapes on the ice... my pendant's gone, and my skin still prickles when I look."]],
    dougans: [{ if: { flag: :hag_defeated }, lines: ["She called me \"daughter of song\". Like she knew a verse I haven't written yet.",
                                                      "I don't like people who know my verses."] },
              ["Small, cold and suspicious. I've played towns like this.",
               "You win them over, or you leave by the window. I've done both. Same night, once."]],
    durmoot_lodge: ["Furs and traps. Every pelt on these walls has a story. None of them end well for the animal."],
    tundra: ["I can't see my own hand. Stay close, darling. If you lose me, follow the singing."],
    ice_lodge: ["Even the echoes freeze in here. Somebody hold me. For warmth. Mostly for warmth."]
  )
  PARTY_CHAT[:reptin].merge!(
    eastway: ["The snow's deep, but the roots under it are awake. They always are.",
              "Which is more than I can say for Alerion before breakfast."],
    good_mead: ["Bees in the Rime, kept alive in a hall full of fire.",
                "That's faith, of a sort. Also very good honey. Mostly the honey."],
    redwaters: ["Something under the ice is wrong. Not dead. Stopped."],
    dougans: [{ if: { flag: :hag_defeated }, lines: ["She called me \"wolf of seasons\". Said balance is a leash.",
                                                      "...She's wrong. I'm fairly sure she's wrong."] },
              ["These people have been hungry a long time. Hunger makes you hard.",
               "Leave the talking to me. And keep Meat Meat away from the trout."]],
    durmoot_lodge: ["She skins wolves. I keep thinking about the starving pack.",
                    "(rubbing his hand) I'm fine. Don't look at me."],
    tundra: [{ if: { flag: :fed_pack }, lines: ["They're following us. Not hunting. Keeping pace.",
                                                 "An escort. Every diplomat should have one."] },
             ["Wolves hunt out here because there's nothing else left to hunt.",
              "Remember that, if they come."]],
    ice_lodge: ["He's grieving. Norsu. Grief makes anything dangerous. Let me talk first."]
  )
  PARTY_CHAT[:alerion].merge!(
    eastway: ["Easthaven's buried. Good Mead has no Speaker. Nobody comes back from Dougan's Hole.",
              "The Dale's coming apart at the edges."],
    good_mead: ["Honey and woodsmoke. My ring's warmer here than it's been since Targos.",
                "I don't trust it."],
    redwaters: ["My ring is cold out here. The people on that ice aren't dead.", "Not yet."],
    dougans: [{ if: { flag: :hag_defeated }, lines: ["She went south. Toward the chasm.", "We'll follow her. We always end up following them."] },
              ["If the wolf comes, watch which leg it favours.", "Liars forget."]],
    durmoot_lodge: ["Durmoot isn't cruel. She's priced hope and decided she can't afford it."],
    tundra: ["The blizzard's covering our tracks. Good for us.", "Good for anything following us."],
    ice_lodge: ["A frost giant's tomb. Thirty-foot ceilings. Every step echoes.", "Walk soft."]
  )
  PARTY_CHAT[:shade].merge!(
    eastway: ["Keep walking. If I stop, I start thinking about her.", "So I'm not stopping."],
    good_mead: ["Out of mead. Of course they're out of mead. That's the Dale for you."],
    redwaters: ["She'd have walked straight out onto that ice to see who they were.",
                "She never could leave a mystery alone."],
    dougans: [{ if: { flag: :hag_defeated }, lines: ["Next time I see that hag, she doesn't get to laugh."] },
              ["Everyone here looks at us like we're about to steal something.", "I might."]],
    durmoot_lodge: ["I like her. Don't tell her."],
    tundra: ["I can't feel my face. That's fine. It wasn't doing anything useful."],
    ice_lodge: ["Two kids in a cage in a dead giant's house.", "Let's get them out. Then we can be clever."]
  )
  PARTY_CHAT[:meat_meat] ||= {}
  PARTY_CHAT[:meat_meat].merge!(
    eastway: ["Big empty. Meat Meat likes big empty. Nobody to count pockets."],
    good_mead: ["Bees! Tiny honey goblins! Meat Meat will meet the queen. Politely.",
                "No coffee here. Only honey. Meat Meat gives Good Mead four bees out of ten."],
    redwaters: ["The still ones on the ice smell like old mushroom. Bad mushroom."],
    dougans: [{ if: { flag: :hag_defeated }, lines: ["Laughing lady ran away. Meat Meat laughed back. Meat Meat laughs better."] },
              ["Small town with pointy teeth. Meat Meat feels very at home.",
               "Coffee here tastes like fish. Meat Meat drank it anyway. Meat Meat is brave."]],
    durmoot_lodge: ["Lady Speaker has a scary face. Meat Meat has a scarier face. Meat Meat practised."],
    tundra: ["Too much snow. Meat Meat is going inside your coat. No arguing."],
    ice_lodge: ["Little lizard people! Meat Meat will say hello. Fondly. With teeth."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # Rest stops
  #-----------------------------------------------------------------------------
  def set_rest_at(point)
    return if !$PokemonGlobal
    map_id, x, y, dir = point
    $PokemonGlobal.pokecenterMapId     = map_id
    $PokemonGlobal.pokecenterX         = x
    $PokemonGlobal.pokecenterY         = y
    $PokemonGlobal.pokecenterDirection = dir
  end

  def mead_hall_rest(event_id = nil)
    say(["BREWMISTRESS: Come in, come in! Sit by the hive fire.",
         "BREWMISTRESS: No mead to sell, but warmth's free in Good Mead.",
         "BREWMISTRESS: Some nights you hear it from here. Laughing, out on Redwaters.",
         "BREWMISTRESS: The bees go quiet when it starts."], event_id)
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_rest_at(GOOD_MEAD_REST)
    sayc(["BREWMISTRESS: There. Listen to them hum. Sounds like summer, doesn't it?",
          cl(:alberica, "A mead hall with no mead. It's like a bed with no company. Technically works."),
          cl(:meat_meat, "Meat Meat asked for coffee. Lady gave Meat Meat hot honey water."),
          cl(:meat_meat, "Meat Meat is not angry. Meat Meat is disappointed. Three bees out of ten."),
          cl(:reptin, "Thank you, it's lovely. She's saying it's lovely."),
          cl(:alerion, "She isn't.")], event_id)
  end

  def smokehouse_rest(event_id = nil)
    if flag?(:kids_home)
      say(["SMOKER: Sit, sit. You brought back Hilda's young'uns.",
           "SMOKER: You'll never pay for a trout in this town again."], event_id)
    else
      say(["SMOKER: Only warm room in Dougan's Hole. Sit by the racks if you like. Mind the trout."], event_id)
    end
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_rest_at(DOUGANS_REST)
    sayc(["The racks drip. Everything in here smells of smoke and fish.",
          cl(:shade, "Shimmer liked smoked trout. Hated the smell. Ate it anyway."),
          cl(:alberica, "(quietly) Then we'll eat it anyway too, sugar. For her."),
          cl(:meat_meat, "Meat Meat will eat two. One for Shimmer. One for Meat Meat."),
          cl(:alerion, "That's three you've eaten.")], event_id)
  end

  #-----------------------------------------------------------------------------
  # Arrivals
  #-----------------------------------------------------------------------------
  def scene_eastway_start
    set_flag(:eastway_started)
    sayc(["Past Bryn Shander's east gate, the Eastway runs out across open snowfields.",
          "South-east, past Good Mead, is Dougan's Hole. Zenith said a hag laughs in a chasm there.",
          cl(:shade, "A laughing hag. In a chasm. Is anything in this Dale just a nice lake?"),
          as(:alerion, "Then let's go and find out what's so funny."),
          cl(:alberica, "Look at that, pretty boy made a joke. Mark the date, somebody.")])
  end

  # SC 4.01 - Good Mead
  def scene_good_mead_arrival
    set_flag(:good_mead_arrived)
    set_flag(:good_mead_met)
    sayc(["Good Mead: squat houses carved with serpents, and a mead hall with eaves painted like wyverns.",
          "Bees hum somewhere in a heated hall. The whole town smells of honey.",
          "OLIVESSA: Headed to the Hole? Eat first. Nobody comes back from there fat.",
          cl(:alberica, "A woman who feeds strangers on sight. I think I'm in love."),
          cl(:meat_meat, "Meat Meat smells honey. Meat Meat does not smell coffee. Suspicious town.")])
  end

  # SC 4.02 - The still ones on the ice
  def scene_dougans_arrival
    set_flag(:dh_arrived)
    add_counter(:story_beats)
    say(["Dougan's Hole huddles on the shore of Redwaters.",
         "Out on the frozen lake, dark figures stand over fishing holes. Snow has drifted against their legs.",
         "Between them, panes of ice stand upright, like mirrors."])
    speak(:reptin, "Those aren't fishers. Fishers fidget.", "...Those aren't fishers.")
    sayc([as(:alerion, "They're people. Stopped."),
          cl(:alberica, "Stopped how, pretty boy?"),
          as(:alerion, "Like I was."),
          "\"Don't go out there.\" \"Wolves took the Dejarr kids.\" \"Nobody leaves.\" \"Speaker's orders.\"",
          "(Speaker Edgra Durmoot's lodge is up the hill.)"])
    state[:goal] = "Speaker Durmoot's lodge, up the hill. Wolves took two children."
  end

  #-----------------------------------------------------------------------------
  # Gym 3: Speaker Edgra Durmoot
  #-----------------------------------------------------------------------------
  def leader_durmoot(event_id)
    if flag?(:badge_dougans)
      say(["DURMOOT: You've got my seal. Don't make a fuss about it.",
           "DURMOOT: And if that crone comes back... you'll hear her before you see her. You always do."], event_id)
      return
    end
    if !flag?(:met_durmoot)
      set_flag(:met_durmoot)
      $game_switches[SW_DH_WEST_OPEN] = true if $game_switches
      say(["DURMOOT: Strangers. In Dougan's Hole. In winter. Either you're lost or you're stupid.",
           "DURMOOT: Wolves took Hilda's kids. Silja and Finn. They're dead.",
           "DURMOOT: Wolves don't keep prisoners. They keep dinner."], event_id)
      speak(:reptin, "Speaker, you're clearly a practical woman. So humour me. And if they aren't dead?",
                     "And if they aren't?", event_id)
      sayc(["DURMOOT: ...Then bring them home, and I'll fight you for my seal myself.",
            cl(:meat_meat, "Lady Speaker. Meat Meat likes her. Meat Meat would still bite her."),
            cl(:reptin, "(aside) Please don't."),
            "DURMOOT: The west way's open to you. Freeze where you like. I've told the militia."], event_id)
      state[:goal] = "Find Silja and Finn. West, out on the tundra."
      return
    end
    if !flag?(:kids_home)
      say(["DURMOOT: Still here? The west way's open. Bring them back, or don't come back."], event_id)
      return
    end
    say(["DURMOOT: ...I said I'd fight you myself.",
         "DURMOOT: Dougan's Hole keeps its word. Even when it's sorry it gave it."], event_id)
    won = pbTrainerBattle(:FT_SPEAKER_DH, "Durmoot", nil, false, 0)
    return if !won
    $Trainer.badges[2] = true
    set_flag(:badge_dougans)
    $game_switches[SW_DH_BADGE] = true if $game_switches
    add_counter(:story_beats)
    say(["DURMOOT: Thruun Seal. Don't lose it."], event_id)
    pbMessage(_INTL("\\me[Badge get]{1} received the Thruun Seal!", $Trainer.name))
    pbReceiveItem(:TM79) rescue nil
    sayc(["DURMOOT: That TM's Frost Breath. Every hit's a deep one. Like a Dougan's Hole winter.",
          "DURMOOT: ...Stay in tonight.",
          cl(:alberica, "Was that concern? I think that was concern. She likes us."),
          cl(:alerion, "She told the wolves to stay in too.")], event_id)
    state[:goal] = "Rest for the night. (Durmoot said stay in. Durmoot tells everyone to stay in.)"
  end

  #-----------------------------------------------------------------------------
  # Hilda
  #-----------------------------------------------------------------------------
  def hilda(event_id = nil)
    if flag?(:kids_home)
      say(["HILDA: Every time I look at them I have to count. One, two. One, two.",
           "HILDA: Whatever you need from Dougan's Hole, you come to this door first."], event_id)
    else
      sayc(["HILDA: My Sil. My Finn. The Speaker says they're gone. Everyone says they're gone.",
            "HILDA: They're not. A mother knows. I keep their bowls on the table.",
            "HILDA: If you're going out there... please. Please.",
            cl(:alberica, "(taking both her hands) Keep the bowls out, love. We'll fill them.")], event_id)
    end
  end

  def scene_kids_homecoming
    return if flag?(:kids_home)
    set_flag(:kids_home)
    $game_switches[SW_KIDS_HOME] = true if $game_switches
    add_counter(:story_beats)
    say(["Silja doesn't wait for anyone. She's off down the street, braids flying, Finn stumbling after her.",
         "Hilda runs out barefoot into the snow. She doesn't say anything. She doesn't have to.",
         "HILDA: ...Take these. They were my brother's. He'd want them used."])
    pbReceiveItem(:REVIVE, 2) rescue nil
    sayc([cl(:alberica, "(sniffing loudly) I'm not crying. It's the wind. Somebody give me a drink for the wind."),
          cl(:meat_meat, "Meat Meat is also not crying. That is snow."),
          "DURMOOT: (from her door, after a while) ...Lodge. Now. I said I'd fight you myself."])
    state[:goal] = "Speaker Durmoot's lodge. She'll fight you for her seal."
  end

  #-----------------------------------------------------------------------------
  # Good wolf, bad wolf
  #-----------------------------------------------------------------------------
  # SC 4.04 - The limping wolf
  def koran(event_id = nil)
    say(["A white wolf lies in the snow, licking a paw.",
         "KORAN: Help me. My leg. My brother's gone mad. He has the children.",
         "KORAN: I'll show you."], event_id)
    choice = pbMessage(_INTL("What do you do?"), [_INTL("\"Show us.\""), _INTL("\"Which leg was it, again?\"")], 0)
    if choice == 1
      sayc(["Koran blinks. He was limping on the left leg. Now he's limping on the right.",
            as(:shade, "Ha! Oh, I like this one. Terrible liar. Great coat."),
            cl(:alerion, "Told you. Liars forget."),
            "KORAN: ...Clever. Follow anyway. You need me."])
      set_flag(:caught_koran)
    else
      sayc(["KORAN: This way. This way. Quickly, before the snow fills my tracks.",
            as(:reptin, "(quietly) There's two of them. I can smell the other one."),
            cl(:meat_meat, "Meat Meat will walk next to the doggy. Close. Very friendly.")])
      set_flag(:followed_koran)
    end
    say(["Koran trots off west into the white."])
    set_flag(:met_wolves)
    set_self_switch(event_id, "A")
    state[:goal] = "Follow the wolf's tracks west across the tundra."
  end

  def scene_tundra_start
    sayc(["West of Dougan's Hole, everything is white. The blizzard comes in sideways.",
          flag?(:met_wolves) ? "The wolves' tracks run ahead, west, filling with snow almost as fast as you find them." :
                               "Under the drifts there are tracks: two wolves, enormous ones, heading west.",
          as(:shade, "Thirteen miles of this. Wonderful."),
          cl(:alberica, "Think of it as a long, cold walk with excellent company."),
          cl(:shade, "I am. That's the problem.")])
  end

  # SC 4.05 - The starving pack. Reptin feeds them whatever you choose, and one bites him.
  def starving_pack(event_id = nil)
    return if $game_switches && $game_switches[SW_PACK_GONE]
    me = herald?(:reptin)
    say(["Not winter wolves. Ordinary ones, so thin you can count their ribs.",
         "They don't attack. They just watch the packs on your backs.",
         me ? "You're already unbuckling your food bag. (The Dale isn't sparing them. We can.)" :
              "REPTIN: (already unbuckling his food bag) The Dale isn't sparing them. We can."], event_id)
    opts = me ? [_INTL("Share it all."), _INTL("Share only your own.")] : [_INTL("Help him."), _INTL("Hold him back.")]
    choice = pbMessage(_INTL("What do you do?"), opts, 0)
    if choice == 0
      sayc([me ? "The others put their rations out beside yours." : "You both put out the rations.",
            cl(:meat_meat, "...Meat Meat gives the jerky. Not the coffee beans. Wolves don't deserve the beans.")])
      set_flag(:fed_pack)
      wheel(1)
    else
      say([me ? "(We need that food. You know. You share your own anyway.)" : "You put a hand on his arm. \"We need that food.\"",
           me ? nil : "REPTIN: I know. I'm sorry.",
           me ? nil : "He shares his own anyway."].compact)
      set_flag(:fed_pack_reptin_only)
    end
    say(["The pack eats. One lean she-wolf comes close enough to touch.",
         me ? "You reach out, and she bites: fast, deep, then gone." : "Reptin reaches out, and she bites: fast, deep, then gone."])
    speak(:reptin, "Fair. I'd bite me too. I'm very bitable.", "...Fair. I'd bite me too.")
    sayc(["The bite doesn't bleed. It burns like fire under snow.",
          cl(:alberica, "Let me see that, sweetheart."),
          as(:reptin, "I'm fine. Don't look at it. I'm fine.")])
    set_flag(:reptin_bitten)
    $game_switches[SW_PACK_GONE] = true if $game_switches
  end

  #-----------------------------------------------------------------------------
  # Boss battles against creatures that can't be caught (and can't be run from)
  #-----------------------------------------------------------------------------
  def boss_battle(*mons)
    sw = (SWITCH_CANNOT_CATCH_POKEMON rescue 75)
    was = $game_switches[sw]
    $game_switches[sw] = true
    setBattleRule("cannotRun")
    setBattleRule("double") if mons.size >= 2
    decision = pbWildBattleCore(*mons)
    return decision == 1
  ensure
    $game_switches[sw] = was if $game_switches && sw
  end

  def named_mon(species, level, name)
    pk = Pokemon.new(species, level)
    pk.name = name
    pk.calc_stats
    pk
  end

  #-----------------------------------------------------------------------------
  # Garagai's ice lodge
  #-----------------------------------------------------------------------------
  def scene_lodge_enter
    set_flag(:lodge_entered)
    add_counter(:story_beats)
    sayc(["Out of the tundra rises a dome of solid ice, three times the height of anything in Ten-Towns.",
          "Inside, icicles hang overhead, their points sharp as daggers.",
          "From deeper in comes a sound like a bellows: something enormous, breathing slowly.",
          "And under it, very faintly, a child coughing.",
          cl(:reptin, "(one word, flat) Quiet."),
          cl(:meat_meat, "(very quiet, very fast) Meat Meat hears it. Meat Meat is going.")])
  end

  def norsu_notice(event_id = nil)
    return if flag?(:norsu_met)
    norsu(event_id)
  end

  def norsu(event_id = nil)
    if flag?(:norsu_met)
      return talk(:norsu_calm, event_id)
    end
    say(["A frost giant sits frozen on his throne, an axe-shaped gap in his grip.",
         "A woolly mammoth stands guard over him.",
         "NORSU: You did this! You took his axe! You took his breath!"])
    choice = pbMessage(_INTL("What do you say?"),
                       [_INTL("\"We were his friends.\""), _INTL("\"We'll find who took the axe.\""), _INTL("Stand your ground")], -1)
    case choice
    when 0
      say(["NORSU: ...Friends. Garagai had friends. Giants, who sat at his table. Never small ones.",
           "NORSU: But you came to his tomb. His friends never came to his tomb.",
           "The mammoth's head lowers, slowly."])
      calm_norsu
    when 1
      say(["NORSU: The ones who killed him took his axe, and left him for me to watch.",
           "NORSU: ...Swear it. On his ice."])
      speak(:reptin, "I swear it. Whoever took his axe will answer for it, and the axe comes back to him.",
                     "I swear it. It comes back to him.")
      sayc([cl(:meat_meat, "Meat Meat swears too. Meat Meat bites whoever took it."),
            "The mammoth lowers his head."])
      set_flag(:garagai_vow)
      calm_norsu
    else
      say(["Norsu lowers his tusks and charges!"])
      if boss_battle(named_mon(:MAMOSWINE, 28, "Norsu"))
        say(["Norsu staggers, groans, and sinks down beside his master. He doesn't get up.",
             "NORSU: ...Take what you came for. Leave us be."])
        set_flag(:norsu_beaten)
        set_flag(:norsu_met)
        $game_switches[SW_NORSU_CALM] = true if $game_switches
      end
    end
  end

  def calm_norsu
    say(["NORSU: Honour him, then. And go."])
    if pbConfirmMessage(_INTL("Say a few words over Garagai?"))
      sayc(["You say what you can about someone you never met.",
            cl(:alberica, "(softly, after you) He kept a whale in his kitchen and a mammoth who loved him. That's a good life."),
            "Norsu listens to every word."])
    end
    set_flag(:norsu_calmed)
    set_flag(:norsu_met)
    $game_switches[SW_NORSU_CALM] = true if $game_switches
  end

  def whale_oil(event_id = nil)
    if flag?(:whale_oil)
      return say(["Five barrels of whale oil, each as heavy as a sled. You've already filled a flask."], event_id)
    end
    sayc(["A foul smell fills the room: barrels of whale oil, rendered from Garagai's catches.",
          "You fill an empty flask. It reeks, and it's slick as anything.",
          cl(:shade, "Lovely. Now we smell like a dead giant's pantry. Very stealthy.")], event_id)
    pbMessage(_INTL("\\me[Item get]You got a flask of whale oil."))
    set_flag(:whale_oil)
  end

  def lodge_chest(event_id = nil)
    say(["A stone chest, half buried in ice. You chip it free.",
         "Inside: giant-sized flensing tools, and a tiny scrimshaw goat that fits in your hand."], event_id)
    pbReceiveItem(:NUGGET) rescue nil
    set_self_switch(event_id, "A")
  end

  def kobolds(event_id = nil)
    return if $game_switches && $game_switches[SW_KOBOLDS_GONE]
    say(["Three small white-scaled kobolds cower behind the ice chairs, clutching each other.",
         "HOLGI: Don't hurt! Don't hurt! We not mean to kill little stone thing! It startle us!",
         "SNORP: We think house empty! House not empty! House have BIG HAIRY ANGRY!",
         "ZILBO: And wolves outside! Wolves everywhere! Help us get out? We very small and very sorry."], event_id)
    sayc([cl(:meat_meat, "Little lizards! Meat Meat will not bite. Meat Meat promises."),
          cl(:reptin, "She means you're safe. Mostly.")])
    if pbConfirmMessage(_INTL("Help the kobolds escape?"))
      say(["You point them to the oil store and the tunnel in its floor. They bow until their snouts touch the ice.",
           "HOLGI: Kind big ones! Take shiny! Shiny cold! Never melts! We find it, now we give it!"])
      pbReceiveItem(:NEVERMELTICE) rescue nil
      say(["They scurry off in a line, tails held high, and are gone."])
      set_flag(:kobolds_freed)
      $game_switches[SW_KOBOLDS_GONE] = true if $game_switches
    else
      say(["The kobolds hunker back down behind the chairs, shivering."])
    end
  end

  def cage(event_id = nil)
    return if flag?(:kids_freed)
    if !flag?(:met_kids)
      set_flag(:met_kids)
      say(["A huge slatted animal cage stands against the wall. Its gate hangs on rusty hinges as big as your head.",
           "Inside, two shivering teenagers look out at you.",
           "SILJA: Are you real? Are you from town? Did Mama send you?",
           "Silja is spindly, with pointy teeth and snow in her long braids.",
           "Her brother works at the slats with frostbitten hands.",
           "FINN: The slats won't bend. Too cold. And the gate screams if you open it.",
           "FINN: The hinges scream. Then HE comes."], event_id)
      sayc([cl(:alberica, "Hey. Look at me. Big breath, all the way in. There you go. We're getting you out."),
            cl(:shade, "(already looking at the hinges) Screaming hinges. I've opened worse. Give me a minute.")])
    end
    if flag?(:whale_oil)
      say(["You work the whale oil into the great rusty hinges, slowly, until they're black and dripping.",
           "The gate swings open without a sound."])
    elsif flag?(:norsu_beaten)
      say(["You haul on the gate. The hinges SHRIEK, and the sound fills the whole lodge.",
           "From the tomb comes only a long, tired groan. Norsu doesn't get up."])
    else
      if !pbConfirmMessage(_INTL("Force the gate open?"))
        say(["(Something might quiet those hinges. Something slick...)"])
        return
      end
      say(["You haul on the gate. The hinges SHRIEK, and the sound fills the whole lodge.",
           "The floor shakes. Something enormous is coming down the passage. Fast.",
           "NORSU: THIEVES! You would rob his tomb too?!"])
      if !boss_battle(named_mon(:MAMOSWINE, 28, "Norsu"))
        return
      end
      say(["Norsu crashes against the ice and lies there, breathing hard.",
           "Then he turns, slowly, and drags himself back to his master."])
      set_flag(:norsu_beaten)
      set_flag(:norsu_met)
      $game_switches[SW_NORSU_CALM] = true if $game_switches
    end
    set_flag(:kids_freed)
    $game_switches[SW_KIDS_FREED] = true if $game_switches
    add_counter(:story_beats)
    say(["Silja is out first, pulling Finn after her. His teeth chatter so hard he can barely speak.",
         "SILJA: The wolves watch the big doors. They always watch the big doors.",
         "SILJA: But there's a tunnel in the oil room. The big worm dug it.",
         "FINN: I c-could've got out myself.",
         "SILJA: He couldn't."])
    sayc([as(:shade, "Stay behind us. All the way home. Whatever happens."),
          cl(:alberica, "And if Finn wants to carry something heroic, he can carry my bag. It's very heroic.")])
  end

  # Koran and Kanan spring their trap on the way home.
  def wolves_ambush(event_id = nil)
    return if flag?(:wolves_beaten) || !flag?(:kids_freed)
    say(["Two white shapes rise out of the blizzard ahead of you, side by side.",
         "KANAN: You're bringing back our dinner.",
         "KORAN: (no limp at all) Nothing personal. The Dale is very hungry."])
    lv = flag?(:caught_koran) ? 2 : 0
    sayc(["(You saw it coming. You're ready before they are.)", cl(:alerion, "Right leg.")]) if lv > 0
    sayc([cl(:reptin, "(to the kids, not looking back) Behind me. Now.")])
    if boss_battle(named_mon(:B503H272, 26 - lv, "Koran"), named_mon(:B272H310, 27 - lv, "Kanan"))
      say(["Kanan yelps and bolts south, toward the chasm.",
           "Koran stands a moment longer, looking at you. Then he follows his brother.",
           "SILJA: ...Can we go home now?"])
      set_flag(:wolves_beaten)
      $game_switches[SW_WOLVES_GONE] = true if $game_switches
      add_counter(:story_beats)
    else
      say(["(Silja and Finn fled back to the ice lodge to hide.)",
           "(Koran and Kanan are still waiting out on the tundra.)"])
    end
  end

  #-----------------------------------------------------------------------------
  # The night of the hag
  #-----------------------------------------------------------------------------
  NIGHT_TONE = [-90, -80, -30, 60]

  def night_on_ice?
    flag?(:badge_dougans) && !flag?(:hag_defeated)
  end

  def apply_night_tone
    return if !$game_screen || !$game_map
    if $game_map.map_id == MAPS[:dougans] && night_on_ice?
      $game_screen.start_tone_change(Tone.new(*NIGHT_TONE), 0)
      state[:dh_night_tone] = true
    elsif state[:dh_night_tone]
      $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 0)
      state[:dh_night_tone] = false
    end
  end

  # SC 4.09 - Night of the hag
  def scene_dh_night
    return if !night_on_ice?
    $game_screen.start_tone_change(Tone.new(*NIGHT_TONE), 30) rescue nil
    state[:dh_night_tone] = true
    pbBGMPlay("scary_ambient") rescue nil
    sayc(["Laughter on the ice. It comes from everywhere at once. Your relics go so cold they burn.",
          "Among the Twenty Stones, south-west of town, stand three tall mirrors of ice.",
          "In each one, an old woman in a patchwork cloak is smiling.",
          as(:alberica, "Durmoot told us to stay in."),
          as(:shade, "Durmoot tells everyone to stay in."),
          cl(:meat_meat, "Meat Meat never stays in. Meat Meat is already outside.")])
    state[:goal] = "The Twenty Stones. Find who's calling."
  end

  def mirrors_broken
    (1..3).count { |i| flag?(:"hag_mirror_#{i}") }
  end

  def hag(event_id = nil)
    return if !night_on_ice?
    if !flag?(:hag_parley)
      set_flag(:hag_parley)
      pbSEPlay("Ice2") rescue nil
      say(["THREDRA: Come in, dearies. Mind the cold. Mind your step.",
           "THREDRA: Did you like my little trinkets? A pendant for the daughter of song.",
           "THREDRA: A medallion for the wolf of seasons. A ring for the boy outside time.",
           cl(:alerion, "...Boy."),
           "THREDRA: A dagger for the one who hides in shadow.",
           "THREDRA: And the one who'd been worn before needed no gift from me. She already carried a door."].compact, event_id)
      speak(:alberica, "You sent them. You sent me that pendant, you dried-up old...", "...You sent them.", event_id)
      lines = ["THREDRA: I sent them. My watchers watched you aboard.",
               "THREDRA: She wants a new coat to wear, you see. I'm only her seamstress."]
      lines << "THREDRA: (squinting at you) And this one isn't anywhere at all. Interesting. Very interesting." if journey? || herald?(:wyn)
      lines << cl(:reptin, "(aside) Seamstress. Lovely. Let's not let her take our measurements.")
      say(lines.compact, event_id)
      hag_bargain_offer(event_id)       # the module's "A Hag's Bargain" (044_ChasmFaithful.rb)
      say(["THREDRA: Now. Let's dance upon the glass, and see who shatters first.",
           "THREDRA: Break my mirrors, dearies. If you can bear to look in them."], event_id)
      set_flag(:thredra_sent_relics)
      return
    end
    if mirrors_broken < 3
      n = mirrors_broken
      say(["THREDRA: Heh-heh. #{n == 0 ? 'Not one' : (n == 1 ? 'One' : 'Two')} of three. The wheel turns so slowly, doesn't it?"], event_id)
      return
    end
    say(["The last mirror lies in pieces. The crone stops laughing."], event_id)
    won = pbTrainerBattle(:FT_HAG_NIGHT, "Thredra", nil, false, 0)
    return if !won
    scene_hag_defeated
  end

  def hag_mirror(i, event_id = nil)
    return if flag?(:"hag_mirror_#{i}")
    if !flag?(:hag_parley)
      say(["A tall pane of ice stands between the stones. Your reflection looks back at you.",
           "Behind its shoulder, a crone is smiling. (She's waiting at the centre stone.)"], event_id)
      return
    end
    say(["You look into the mirror. Your reflection grins back with someone else's teeth.",
         "The glass bulges, and something climbs out of it!"], event_id)
    foe = [[:SNORUNT, 26], [:B429H427, 27], [:GLALIE, 27]][i - 1]
    return if !boss_battle(named_mon(foe[0], foe[1], "Mirror-wight"))
    pbSEPlay("Ice2") rescue nil
    # staging: the pane cracks top to bottom and falls (E-06)
    pane = (event_id && $game_map ? $game_map.events[event_id] : nil) rescue nil
    if pane
      Stage.hide(pane)
      Stage.fx("E-06", pane, oy: 56)
    end
    say(["The mirror cracks top to bottom and falls into the snow in a hundred laughing pieces.",
         "Behind you, the crone stops laughing, just for a moment."])
    Stage.cleanup rescue nil
    set_flag(:"hag_mirror_#{i}")
    set_self_switch(event_id, "A")
  end

  def scene_hag_defeated
    set_flag(:hag_defeated)
    set_flag(:hag_fled)
    $game_switches[SW_HAG_DOWN] = true if $game_switches
    add_counter(:story_beats)
    pbSEPlay("Ice2") rescue nil
    say(["THREDRA: Clever. Clever, clever. You broke them. Do you know how long it takes to grow a mirror?",
         "THREDRA: Come and find me in the chasm, dearies. Bring your wolf. Granny keeps her bargains.",
         "She splits into shards and blows away south.",
         "Out on the lake, the frozen figures breathe. One by one they sag, gasp, and fall to their knees."])
    sayc([cl(:reptin, "(hand closing over the bite) ...Bring your wolf. She means me."),
          cl(:alerion, "She means all of us. She just said your name first.")])
    set_flag(:husband_thawed)
    say(["A fisherman with a Spheal-shaped float on his line looks up at you, shaking.",
         "FISHERMAN: Targos. Tell my wife I'm coming home. Tell her not to give the Spheal away."])
    if flag?(:widow_spheal)
      say(["(You already have it. You let it out of its ball.)",
           "He laughs until he cries."])
    end
    $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 40) rescue nil
    state[:dh_night_tone] = false
    pbBGMPlay("Lavender Town") rescue nil
    # SC 4.10 - Don't tell anyone (morning)
    sayc(["Morning. Speaker Durmoot comes down the hill carrying a lantern she doesn't need any more.",
          "DURMOOT: Thank you.",
          "DURMOOT: ...Don't tell anyone I said that.",
          cl(:alberica, "Oh, sugar, I'm writing a song about it."),
          "DURMOOT: Chasm's south. Take this. It's the only thing in this town that cuts the wind."])
    pbReceiveItem(:TM95) rescue nil
    set_flag(:dh_morning)
    state[:goal] = "The Cackling Chasm, south of Dougan's Hole. She's there."
  end

  def apply_chapter4_switches
    return if !active? || !$game_switches
    sync_switch(SW_DH_WEST_OPEN, flag?(:met_durmoot))
    sync_switch(SW_KIDS_FREED, flag?(:kids_freed))
    sync_switch(SW_KIDS_HOME, flag?(:kids_home))
    sync_switch(SW_DH_BADGE, flag?(:badge_dougans))
    sync_switch(SW_HAG_DOWN, flag?(:hag_defeated))
    sync_switch(SW_NORSU_CALM, flag?(:norsu_calmed) || flag?(:norsu_beaten))
    sync_switch(SW_PACK_GONE, flag?(:fed_pack) || flag?(:drove_pack))
    sync_switch(SW_KOBOLDS_GONE, flag?(:kobolds_freed))
    sync_switch(SW_WOLVES_GONE, flag?(:wolves_beaten))
    apply_night_tone
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_chapter4_switches
  rescue StandardError => err
    FrostThaw.log("Chapter 4 switches failed: #{err.message}")
  end
}
