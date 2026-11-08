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
  SW_HAG_NIGHT    = 3933    # you've rested after the seal: the hag's night at the Stones (context 04 M4-5)

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
    # (balance, scene pass: on the road out of Bryn Shander. His old Stantler
    # lead, with Intimidate, Stomp's flinch and Take Down, beat a two-Pokémon
    # team two times in three. A Swinub leads now, with the moves a Swinub
    # knows at 20; his Sneasel-headed Stantler stays the ace and the test.)
    ranger_hadd:    [:POKEMONRANGER_M, "Hadd",  [[:SWINUB, 20, [:MUDSLAP, :POWDERSNOW, :ENDURE, :TACKLE]],
                                                 [:B234H215, 23, [:FURYSWIPES, :QUICKATTACK, :ICYWIND, :LEER]]],
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
    # (balance, scene pass: Nell and Birk stand on the shore path a few steps
    # apart, with no rest between; four Pokémon back to back beat two-Pokémon
    # teams nine times in ten. Nell keeps her ghost of the ice and Birk his big
    # bear, one Pokemon each.)
    aurilite_eight: [:FT_AURILITE,     "Nell",  [[:B427H200, 23]],
                     "The ones on the ice can hear you. It's all they can do."],
    trapper_birk:   [:HIKER,           "Birk",  [[:B217H220, 23]],
                     "Wolves took my best traps. You took my best Pokémon. Busy week."],
    channeler_mag:  [:CHANNELER,       "Mag",   [[:GASTLY, 24], [:B200H429, 25]],
                     "She laughed at me, child. From under the ice."],
    # Dougan's Hole
    fisher_rorik:   [:FISHERMAN,       "Rorik", [[:QWILFISH, 24], [:B211H86, 25]],
                     "Dougan's Hole folk fight the way we fish. Badly, and often."],
    # the tundra
    aurilite_nine:  [:FT_AURILITE,     "Vesk",  [[:B428H215, 26], [:GLALIE, 25]],
                     "Go on, then. To the giant's house. The cold's expecting you."],
    hunter_ulf:     [:HIKER,           "Orrin", [[:PILOSWINE, 25], [:B503H310, 26]],
                     "I hunt wolves. Two of them hunt me back. The talking ones."],
    # Speaker Durmoot's lodge (Gym 3)
    trapper_brann:  [:FT_TRAPPER,      "Brann", [[:SANDSLASH, 26], [:B87H28, 26]],
                     "The Speaker's tougher than me. Most things are."],
    trapper_holt:   [:FT_TRAPPER,      "Holt",  [[:PILOSWINE, 26], [:DELIBIRD, 26]],
                     "Fair's fair. Go on back."],
    trapper_ysa:    [:FT_TRAPPER,      "Ysa",   [[:B232H220, 27]],
                     "Edgra skinned a winter wolf barehanded once. She says. I believe her."],
    durmoot:        [:FT_SPEAKER_DH,   "Durmoot", [[:B87H28, 27], [:B131H217, 27], [:B232H274, 28]],   # (whole read P4)
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
    sign_good_mead: [{ if: { flag: :mead_returned }, lines: ["GOOD MEAD", "Home of the finest honey mead in Ten-Towns.",
                                                             "(Under it, \"OUT OF STOCK\" has been scrubbed out. Somebody drew a bee.)"] },
                     ["GOOD MEAD", "Home of the finest honey mead in Ten-Towns.", "(Someone has scrawled underneath: \"OUT OF STOCK.\")"]],
    gm_beekeeper: ["The hives are in the mead hall, by the big fire. Bees hate the Rime as much as we do.",
                   "Listen. Hear that? Still humming. Stubborn little things. Like this town."],
    shandar_froth: [{ if: { flag: :badge_dougans }, lines: ["SHANDAR: Back from the Hole, are you? See anything interesting?",
                                                             "SHANDAR: Asking for a friend. In Targos."] },
                    ["A stocky shield dwarf with a logger's shoulders and a politician's smile.",
                     "SHANDAR: Shandar Froth. Logger. Candidate for Speaker, as it happens.",
                     "SHANDAR: Good Mead needs a strong hand. Where are you bound? No reason. Just neighbourly."]],
    gm_townsfolk: ["The verbeeg came out of the woods three days back. Speaker Kendrick stood in its way.",
                   "Kendrick was a big man. The verbeeg was bigger. He's lying in the shrine now."],
    shrine_flaming_sword: ["SHRINE OF THE FLAMING SWORD. A painted Tempus raises a chipped red sword over the door.",
                           "Inside, under a blanket on the long table, lies Speaker Kendrick Rielsbarrow.",
                           "The town keeps a candle burning for him. (You don't go in.)"],
    gm_door_closed: ["The door is barred. Someone inside calls, \"We're not buying!\""],
    # (fef_moryn's lines live in 045_MeadMustFlow's FT.fef_moryn: notes/14 E31)
    fef_fox: ["A white fox sits by Fef's boots, ears flat, watching the treeline."],
    mead_drinker: ["The last cask in Good Mead. We're drinking it slowly. In memory.",
                   "Mostly in memory."],
    mead_hive_keeper: ["The hive room's the warmest place in town.",
                       "The bees sleep in a ball round the queen. We sleep in a ball round the fire."],
    olivessa_untapoor: ["OLIVESSA: You again! Did you eat? You didn't. Here.",
                        "She presses another honey cake on you, and one on everyone behind you.",
                        "OLIVESSA: Casks are the job. Cakes are a hobby. Feeding people is a hobby."],
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
    channeler_mag_after: ["There's a chasm south of the Hole. Hunters say it laughs on the new moon.", "The cackling carries for miles on the wind.",
                          "Folk here think the witch who froze us made it her lair.", "Somebody ought to make sure she can't come back up out of it."],
    # --- Dougan's Hole -----------------------------------------------------------------
    sign_dougans: ["DOUGAN'S HOLE", "Speaker: Edgra Durmoot.", "(Someone has carved a crude wolf into the post, and scratched it out.)"],
    sign_twenty_stones: ["THE TWENTY STONES OF THRUUN.", "Nineteen granite menhirs in a rough triangle, and one at the centre.",
                         "Nobody knows who raised them. They were here when Dougan Dubrace found the place."],
    dh_door_closed: ["Nobody answers. A curtain twitches."],
    dh_chorus_ears: [{ if: { flag: :kids_home }, lines: ["(beaming) You brought 'em back! By Thruun's Stones, you brought 'em back!"] },
                     ["A local with small, misshapen ears grabs your sleeve.", "Them wolves are big as horses! They know words, an' a mighty lot of 'em!"]],
    dh_chorus_teeth: [{ if: { flag: :kids_home }, lines: ["(grinning, all pointed teeth) Sil an' Finn are home! I'm gonna tell everybody!", "I already told everybody!"] },
                      ["Someone grins at you with a mouthful of little pointed teeth.", "They took Sil an' her brother Finn th' other day! Big ol' wolves did!"]],
    dh_pier: ["A single wooden pier, buckled by the ice so it humps up like a frozen wave.",
              "Two keelboats are locked in the ice beside it, masts white with rime.", "Nobody has sailed since the Rime came.",
              "Fifty people live in Dougan's Hole. You'd guess fewer."],
    dh_chorus_sister: [{ if: { flag: :kids_home }, lines: ["Hilda's not stopped crying since. The good kind, mind."] },
                       ["Wolves say they ain't givin' 'em back till the town pays a king's ransom. Food an' gold.",
                        "This town can barely feed itself. An' there ain't no gold."]],
    dh_militia_block: ["MILITIA: Nobody leaves town. Them wolves swore they'd kill anyone who tries!",
                       "MILITIA: Speaker's orders. Don't like it, go tell Edgra. Big lodge, west end of town."],
    dh_militia_open: [{ if: { flag: :kids_freed, not_flag: :wolves_beaten }, lines: ["MILITIA: You found 'em? Then where are they?",
                                                                                     "MILITIA: Hid back in the giant's house while the wolves ran you off?",
                                                                                     "MILITIA: Then go back for 'em! The wolves'll be waitin' on the tundra."] },
                      { if: { flag: :kids_home }, lines: ["MILITIA: Speaker says you come an' go as you please. Says it like it hurts her."] },
                      ["MILITIA: Speaker says you're grown and can freeze where you like. West's that way."]],
    dh_pier_fisher: [{ if: { flag: :hag_defeated }, lines: ["They walked in off the ice this morning, every one. Blue as trout. Alive."] },
                     ["Those shapes on the ice? Fisherfolk. Some of ours, some from other towns.",
                      "They walked out one by one, the night the laughing started.",
                      "Nobody's brave enough to fetch 'em."]],
    dh_ice_pane: ["A pane of ice taller than you, standing on its edge in the lake. Nobody cut it.",
                  "Your reflection in it doesn't blink when you do."],
    dh_shapes_talk: [{ if: { flag: :hag_defeated }, lines: ["The laughing's stopped. First quiet night in a month. I don't trust it."] },
                     ["Don't look at the shapes too long. My husband looked too long.",
                      "Now he's out there with 'em."]],
    fisher_rorik_after: ["Good Mead started the feud. Don't let 'em tell you different."],
    silja_home: ["SILJA: You came. Nobody ever comes to Dougan's Hole. You came anyway.",
                 "SILJA: Mama's fed us three times since. Finn's on his fourth."],
    finn_home: ["FINN: I almost had the slats bent. Almost.", "FINN: ...Thanks."],
    smoke_fisher: ["Knucklehead trout, smoked. It's what we eat, what we trade, and what we talk about."],
    smoke_trout_wife: ["We don't get many visitors. The ones we get mostly want something. What do you want?",
                       "...Oh. To help? Huh."],
    dh_lodge_guide: [{ if: { flag: :kids_home }, lines: ["The trappers are back off the ice line. They'll want a go at you first.", "Edgra likes it that way.",
                                                         "Her Pokémon are like her. Cold, thick-skinned, and they don't go down easy."] },
                     ["The trappers are all out on the ice line, watching for wolves. Edgra sent every one.",
                      "She'd never say it, but she's hoping. We all are."]],
    trapper_brann_after: ["Edgra's at the back. Mind the traps on the walls. Some are still set."],
    trapper_holt_after: ["The Speaker lost her husband to the ice. She doesn't lose anything else if she can help it."],
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
    flensing_knife: ["Beside the whale, a paring knife the size of a longsword. Garagai's. Too heavy to lift."],
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
      ["I'm from Targos. Came down fishing for knuckleheads, and heard laughing on the ice.",
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
    durmoot_lodge: ["Furs and traps. Every pelt on these walls has a story. None end well for the animal."],
    tundra: ["I can't see my own hand. Stay close, darling. If you lose me, follow the singing."],
    ice_lodge: ["Even the echoes freeze in here. Somebody hold me. For warmth. Mostly for warmth."]
  )
  PARTY_CHAT[:reptin].merge!(
    eastway: ["The snow's deep, but the roots under it are awake. They always are.",
              "Which is more than I can say for Alerion before breakfast."],
    good_mead: ["Bees in the Rime, kept alive in a hall full of fire.",
                "That's faith, of a sort. Also very good honey. Mostly the honey."],
    redwaters: ["Something under the ice is wrong. Not dead. Stopped."],
    dougans: [{ if: { flag: :hag_defeated }, lines: ["She called me \"wolf of seasons\". Said she'd take the wolf out of me. Root and all.",
                                                      "...I'm fairly sure I don't want that. Fairly sure."] },
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
    durmoot_lodge: ["I like her. Don't tell her."],
    tundra: ["The blizzard's covering our tracks. Good for us.", "Good for anything following us."],
    ice_lodge: ["A frost giant's tomb. Thirty-foot ceilings. Every step echoes.", "Walk soft."]
  )
  PARTY_CHAT[:shade].merge!(
    eastway: ["She'd have hated this road. Too flat. Nowhere to hide."],
    good_mead: ["Out of mead. Of course they're out of mead. That's the Dale for you."],
    redwaters: ["She'd have walked straight out onto that ice to see who they were.",
                "She never could leave a mystery alone."],
    dougans: [{ if: { flag: :hag_defeated }, lines: ["Next time I see that hag, she doesn't get to laugh."] },
              ["Everyone here looks at us like we're about to steal something.", "I might."]],
    durmoot_lodge: ["Durmoot isn't cruel. She's priced hope and decided she can't afford it."],
    tundra: ["I can't feel my face. That's fine. It wasn't doing anything useful."],
    ice_lodge: ["Two kids in a cage in a dead giant's house.", "Let's get them out. Then we can be clever."]
  )
  PARTY_CHAT[:meat_meat] ||= {}
  PARTY_CHAT[:meat_meat].merge!(
    eastway: ["Big empty. Meat Meat likes big empty. Nobody to count pockets."],
    good_mead: ["Bees! Tiny honey goblins! Meat Meat will meet the queen. Politely.",
                "No coffee here. Only honey. Meat Meat gives Good Mead three bees out of ten."],
    redwaters: ["The still ones on the ice smell like old mushroom. Bad mushroom."],
    dougans: [{ if: { flag: :hag_defeated }, lines: ["Laughing lady ran away. Meat Meat laughed back. Meat Meat laughs better."] },
              ["Small town with pointy teeth. Meat Meat feels very at home.",
               "Coffee here tastes like fish. Meat Meat drank it anyway. Meat Meat is brave."]],
    durmoot_lodge: ["Lady Speaker has a scary face. Meat Meat has a scarier face. Meat Meat practised."],
    tundra: ["Too much snow. Meat Meat is going inside your coat. No arguing."],
    ice_lodge: ["Little lizard people! Meat Meat will say hello. With teeth."]
  )

  module_function

  # A Herald on screen for a scene: the one who already walked in to speak, if
  # they're here (so nobody is drawn twice), else Stage.herald's stand-in.
  def stand_in(key, dx = 0, dy = -1, dir = 2)
    if !herald?(key)
      ev = ($game_map.events.values.find { |e| e.name == "stage_#{key}" && !e.transparent } rescue nil)
      return ev if ev
    end
    Stage.herald(key, dx, dy, dir)
  end

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

  # The rest stop: the laughing planted (the bees go quiet), then a heal. The
  # banter plays on the first rest only (notes 04 E30); later rests just heal.
  def mead_hall_rest(event_id = nil)
    if flag?(:mead_hall_rested)
      say(["BREWMISTRESS: Back again? Sit by the hives. The fire's free."], event_id)
      pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
      set_rest_at(GOOD_MEAD_REST)
      return
    end
    set_flag(:mead_hall_rested)
    say(["BREWMISTRESS: In you go. Sit by the hive fire. No mead to sell, but the warmth's free.",
         "BREWMISTRESS: Some nights you hear it from here. Laughing, out on Redwaters.",
         "BREWMISTRESS: The bees go quiet when it starts."], event_id)
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_rest_at(GOOD_MEAD_REST)
    sayc(["Behind the fire, the hives hum. It sounds like summer.",
          cl(:alberica, "A mead hall with no mead. It's like a bed with no company. Technically works."),
          cl(:meat_meat, "Meat Meat asked for coffee. Lady gave Meat Meat hot honey water."),
          cl(:meat_meat, "Meat Meat is not angry. Meat Meat is disappointed. Three bees out of ten."),
          cl(:reptin, "Thank you, it's lovely. Hot honey water. A classic."),
          cl(:alerion, "It isn't.")], event_id)
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
    smokehouse_night(event_id) if flag?(:badge_dougans) && !flag?(:hag_night_ready) && !flag?(:hag_defeated)
  end

  # SC 4.08b - The night's rest, after the seal (context 04 M4-5). Shimmer is
  # missed out loud, the eggs and the acorn are remembered before the Heart
  # needs them, and the night comes after a fade, not at the gym door.
  def smokehouse_night(event_id = nil)
    sayc(["The racks drip. Everything in here smells of smoke and fish.",
          cl(:shade, "Shimmer liked smoked trout. Hated the smell. Ate it anyway."),
          cl(:alberica, "(quietly) Then we'll eat it anyway too. For her."),
          cl(:meat_meat, "Meat Meat will eat two. One for Shimmer. One for Meat Meat."),
          cl(:alerion, "That's three you've eaten.")], event_id)
    if flag?(:frost_egg) && flag?(:razzy_egg)
      say([herald?(:shade) ? "You set the Frost Egg by the racks, where it's warm. Reptin sets the green one by it." :
           herald?(:reptin) ? "Shade sets the Frost Egg by the racks, where it's warm. You set the green one by it." :
                              "Shade sets the Frost Egg by the racks, where it's warm. Reptin sets the green one by it."])
    elsif flag?(:frost_egg)
      say([herald?(:shade) ? "You set the Frost Egg by the racks, where it's warm." :
                             "Shade sets the Frost Egg by the racks, where it's warm."])
    end
    if flag?(:razzy_egg) && with_or_is?(:meat_meat)
      speak(:meat_meat, "(to the green egg) Warm spot, Razzy. Best one. Meat Meat saved it.", "...Warm spot.", event_id)
    end
    if flag?(:golden_acorn)
      sayc([cl(:reptin, "(turning the acorn) \"Somewhere the sun can't reach,\" she said. Take your pick.")], event_id)
    end
    set_flag(:hag_night_ready)
    $game_switches[SW_HAG_NIGHT] = true if $game_switches
    pbBGMFade(1.5) rescue nil
    $game_screen.start_tone_change(Tone.new(-255, -255, -255, 0), 20) rescue nil
    Stage.wait(24) rescue nil
    say(["..."])
    transfer(MAPS[:dougans], 26, 22, 2)          # out of the smokehouse door, into the night (scene_dh_night)
  end

  #-----------------------------------------------------------------------------
  # Arrivals
  #-----------------------------------------------------------------------------
  def scene_eastway_start
    set_flag(:eastway_started)
    sayc(["Past Bryn Shander's east gate, the Eastway runs out across open snowfields.",
          outsider? ? "South-east, past Good Mead, is Dougan's Hole, and the hag's mirrors." :
                     "South-east, past Good Mead, is Dougan's Hole, where the laughing comes from.",
          cl(:shade, "A laughing hag. In a chasm. Is anything in this Dale just a nice lake?"),
          cl(:alerion, "No."),
          cl(:alberica, "He's right. That's the worst part.")])
  end

  # SC 4.01 - Good Mead. A rest town on the way, and a face the player needs
  # in Chapter 9: Olivessa walks up with honey cake, then goes back to her
  # cooperage (notes 04 E11).
  def scene_good_mead_arrival
    set_flag(:good_mead_arrived)
    set_flag(:good_mead_met)
    say(["A day's walk east, and the snow smells of honey.",
         "Good Mead: squat houses carved with dinosaurs and serpents.",
         "Over them, a two-storey mead hall, its eaves painted like wyverns.",
         "Its founders came from the hot south. The beasts on its lintels have never seen snow."])
    oli = (Stage.actor(:olivessa, $game_player.x + 3, $game_player.y + 4, 8, graphic: "BW (56)") rescue nil)
    say(["A woman with sawdust on her apron comes up the road at a trot, a basket on her arm."])
    Stage.approach(oli) if oli
    sayc(["OLIVESSA: Olivessa. I make casks. Headed to the Hole? Take a cake.",
          "OLIVESSA: Nobody comes back from there fat.",
          "She presses a honey cake into every hand in reach.",
          cl(:alberica, "Cake first, questions later. My kind of town."),
          cl(:meat_meat, "Meat Meat smells honey. Meat Meat does not smell coffee. Suspicious town.")])
    say(["OLIVESSA: Cooperage is the low hut on the west side. Come and see me before you go south."]) if oli
    Stage.leave(oli, 7, 16) if oli
    Stage.cleanup rescue nil
  end

  # SC 4.02 - The still ones on the ice. The player's goal (the hag's mirrors)
  # reaches its town: the shapes and the panes are shown, the glass answers, and
  # Alerion says three words about where he's been (context 04 M4-1).
  def scene_dougans_arrival
    set_flag(:dh_arrived)
    add_counter(:story_beats)
    Stage.pan_to(30, 30)
    say(["Dougan's Hole huddles on the shore of Redwaters.",
         "Out on the frozen lake, dark figures stand over fishing holes.",
         "Snow has drifted against their legs.",
         "Between them, panes of ice stand upright, like mirrors."])
    Stage.pan_back
    say(["In your pocket the #{my_glass} goes cold. Colder than the snow. Close, now."]) if outsider?
    speak(:reptin, "Those aren't fishers. Fishers fidget.", "...Those aren't fishers.")
    sayc([cl(:alerion, "They're people. Stopped.")])
    if with_or_is?(:alberica) && with_or_is?(:alerion)
      speak(:alberica, "Stopped how, pretty boy?", "...Stopped how?")
      sayc([as(:alerion, "Like I was.")])
      speak(:alberica, "You were stopped? When?", "...When?")
      speak(:alerion, "Before your grandmother was born.", "...A long time.")
    end
    sayc(["\"Don't go out there.\" \"Wolves took the Dejarr kids.\" \"Nobody leaves.\" \"Speaker's orders.\"",
          "(Speaker Edgra Durmoot's lodge is the big house at the west end of town.)"])
    state[:goal] = "Speaker Durmoot's lodge, at the west end of town. Wolves took two children."
  end

  #-----------------------------------------------------------------------------
  # Gym 3: Speaker Edgra Durmoot
  #-----------------------------------------------------------------------------
  def leader_durmoot(event_id)
    if flag?(:badge_dougans)
      say(["DURMOOT: You've got my seal. Don't make a fuss about it.",
           "DURMOOT: And if that crone comes back, you'll hear her before you see her. You always do."], event_id)
      return
    end
    if !flag?(:met_durmoot)
      set_flag(:met_durmoot)
      $game_switches[SW_DH_WEST_OPEN] = true if $game_switches
      say(["DURMOOT: Strangers. In Dougan's Hole. In winter. Either you're lost or you're stupid.",
           "DURMOOT: Wolves took Hilda Dejarr's kids. Silja and Finn. They're dead.",
           "DURMOOT: Wolves don't keep prisoners. They keep dinner."], event_id)
      speak(:reptin, "Speaker, you're clearly a practical woman. So humour me. And if they aren't dead?",
                     "And if they aren't?", event_id)
      sayc(["DURMOOT: ...Then bring them home, and I'll fight you for my seal myself.",
            cl(:meat_meat, "Lady Speaker. Meat Meat likes her. Meat Meat would still bite her."),
            cl(:reptin, "(aside) Please don't."),
            "DURMOOT: The west way's open to you. Freeze where you like. I've told the militia."], event_id)
      state[:goal] = "Find Silja and Finn, west on the tundra. Durmoot will fight you for her seal."
      return
    end
    if !flag?(:kids_home)
      say(["DURMOOT: Still here? The west way's open. Bring them back, or don't come back."], event_id)
      return
    end
    say(["DURMOOT: You brought them home.",
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
          cl(:alberica, "Was that concern? She likes us."),
          cl(:alerion, "She likes nobody. She said it anyway.")], event_id)
    state[:goal] = "Rest at the smokehouse for the night. Durmoot said stay in."
  end

  # (Hilda, Koran and Kanan, the tundra and the starving pack: see 045_HoledUp.rb)

  #-----------------------------------------------------------------------------
  # Boss battles against creatures that can't be caught (and can't be run from)
  #-----------------------------------------------------------------------------
  # bgm: a boss's music, not the wild-battle theme (notes 04 E24, 05 E16).
  BOSS_BGM = "ancientbattle"

  def boss_battle(*mons, bgm: BOSS_BGM)
    sw = (SWITCH_CANNOT_CATCH_POKEMON rescue 75)
    was = $game_switches[sw]
    $game_switches[sw] = true
    ($PokemonGlobal.nextBattleBGM = pbStringToAudioFile(bgm)) rescue nil if bgm && $PokemonGlobal
    setBattleRule("cannotRun")
    setBattleRule("double") if mons.size >= 2
    decision = pbWildBattleCore(*mons)
    return decision == 1
  ensure
    $game_switches[sw] = was if $game_switches && sw
  end

  # Bosses with a battle picture of their own (Graphics/Battlers/FrostThaw/bosses)
  BOSS_PICTURES = {
    "Shadow Mycolith" => "FT_SHADOW_MYCOLITH", "Mycolith, Enraged" => "FT_SHADOW_MYCOLITH_ENRAGED",
    "Sephek, Minor Avatar" => "FT_SEPHEK_MINOR_AVATAR", "Sephek, Major Avatar" => "FT_SEPHEK_MAJOR_AVATAR",
    "Avarice's Reflection" => "FT_AVARICE_SOUL", "The Brittle Maiden" => "FT_AURIL_BRITTLE_MAIDEN",
    "Winter's Womb" => "FT_AURIL_WINTER_S_WOMB"
  }

  def named_mon(species, level, name)
    pk = Pokemon.new(species, level)
    pk.name = name
    pk.instance_variable_set(:@ft_picture, BOSS_PICTURES[name]) if BOSS_PICTURES[name]
    pk.calc_stats
    pk
  end

  # (Garagai's ice lodge: see 045_HoledUp.rb)

  #-----------------------------------------------------------------------------
  # The night of the hag
  #-----------------------------------------------------------------------------
  NIGHT_TONE = [-90, -80, -30, 60]

  def night_on_ice?
    flag?(:hag_night_ready) && !flag?(:hag_defeated)
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

  # SC 4.09 - Night of the hag (after the rest: context 04 M4-5)
  def scene_dh_night
    return if !night_on_ice?
    $game_screen.start_tone_change(Tone.new(*NIGHT_TONE), 30) rescue nil
    state[:dh_night_tone] = true
    say(["That night."])
    pbBGMPlay("scary_ambient") rescue nil
    cackle
    relics = if herald?(:alberica) then "Under your coat, the rune burns blue. The others' relics frost over."
             elsif herald?(:meat_meat) then "The others' relics frost over. Under Alberica's coat, the rune glows blue."
             elsif herald? then "Your relic frosts over. Under Alberica's coat, the rune glows blue."
             else "Their relics frost over. Under Alberica's coat, the rune glows blue."
             end
    sayc(["Laughter on the ice. It comes from everywhere at once.",
          relics,
          outsider? ? "In your pocket, the #{my_glass} rings like a struck bell." : nil,
          flag?(:frost_egg) ? (herald?(:shade) ? "In your coat, the Frost Egg goes cold." : "In Shade's coat, the Frost Egg goes cold.") : nil,
          flag?(:frost_egg) ? cl(:shade, "She doesn't like it either.") : nil,
          "Among the Twenty Stones, south-west of town, stand three tall mirrors of ice.",
          "In each one, an old woman in a patchwork cloak is smiling.",
          cl(:alberica, "Durmoot told us to stay in."),
          cl(:shade, "Durmoot tells everyone to stay in."),
          cl(:meat_meat, "Meat Meat never stays in. Meat Meat is already outside.")])
    state[:goal] = outsider? ? "The Twenty Stones: who's calling them, and the mirrors you came through." : "The Twenty Stones. Find who's calling."
  end

  # Her laugh. (Art/audio request: a crone's cackle SE. A Mismagius cry, a
  # shrill witch's laugh, stands in.)
  def cackle
    if (audioFileExists(:SE, "FT_cackle") rescue false)
      pbSEPlay("FT_cackle") rescue nil
    else
      Stage.cry(:MISMAGIUS)
    end
  end

  def mirrors_broken
    (1..3).count { |i| flag?(:"hag_mirror_#{i}") }
  end

  # SC 4.09 - Granny Thredra at the Stones. She names herself, every epithet
  # finds its owner, "she" is Auril and the coat is Alberica, the bite is
  # confirmed as a curse, and the dare says what breaking a mirror does
  # (context 04 M4-6). Then her three mirrors, each with its own truth (M4-7).
  def hag(event_id = nil)
    return if !night_on_ice?
    if !flag?(:hag_parley)
      set_flag(:hag_parley)
      pbSEPlay("Ice2") rescue nil
      say(["THREDRA: Come in, dearies. Mind the cold. Mind your step.",
           "THREDRA: Granny Thredra. Everyone's granny, sooner or later.",
           "THREDRA: Did you like my little trinkets? A pendant for the daughter of song."], event_id)
      cackle
      if herald?(:alberica)
        say(["Your hand goes to your throat. The pendant isn't there any more."])
      elsif with_or_is?(:alberica)
        say(["Alberica's hand goes to her throat, where the pendant used to hang."])
      end
      say(["THREDRA: The sea gave it back to me, dearie, and I gave it back to you.",   # (whole read T9)
           "THREDRA: A medallion for the wolf of seasons. A ring for the boy outside time."], event_id)
      say(["(The medallion fogs in your palm. \"It knows,\" the captain said.)"]) if herald?(:reptin)
      sayc([cl(:alerion, "...Boy."),
            "THREDRA: A dagger for the one who hides in shadow.",
            "THREDRA: And the one who'd been worn before needed no gift. She already carried a door."], event_id)
      if with_or_is?(:shade)
        speak(:shade, "Her name was Shimmer.", "...Shimmer.", event_id)
        say(["THREDRA: Names are for the living, dearie."], event_id)
      end
      speak(:alberica, "You fished it out. I threw that in the sea, you dried-up old...", "...You sent them.", event_id)
      say(["THREDRA: Old, dearie. Not dried. My watchers saw each of you onto your ships."], event_id)
      if herald?(:alberica)
        say(["(The tall thing at the edge of the lamplight. On the ship. That was hers.)"])
      else
        sayc([cl(:alberica, "The tall thing on our deck, at the edge of the lamplight. That was yours.")], event_id)
      end
      say(["THREDRA: She wants a new coat to wear, you see. I'm only her seamstress."], event_id)
      sayc([cl(:alberica, "(very plain) Auril. And the coat's me.")], event_id)
      lines = []
      if outsider?
        lines << "THREDRA: (squinting at you) And this one fell through my glass. Lost, dearie?"
        lines << "THREDRA: Granny could send you home. Granny's very good at sending."
      end
      lines << cl(:reptin, "(aside) Seamstress. Lovely. Let's not let her take our measurements.")
      say(lines.compact, event_id)
      hag_bargain_offer(event_id)       # the module's "A Hag's Bargain" (044_ChasmFaithful.rb)
      say(["THREDRA: My still ones sleep in my glass, dearies. Every fisher on that ice.",
           "THREDRA: Break a mirror and one goes free. If you can bear to look in it.",
           outsider? ? "THREDRA: (to you) Mind, lost one. One of Granny's mirrors is your way home. Choose well." : nil].compact, event_id)
      set_flag(:thredra_sent_relics)
      state[:goal] = outsider? ? "Break Thredra's three mirrors at the Stones. Is one of them yours?" :
                                "Break Thredra's three ice mirrors among the Twenty Stones."
      return
    end
    if mirrors_broken < 3
      n = mirrors_broken
      say(["THREDRA: Heh-heh. #{n == 0 ? 'Not one' : (n == 1 ? 'One' : 'Two')} of three. The wheel turns so slowly, doesn't it?"], event_id)
      return
    end
    say(["The last mirror lies in pieces. Thredra isn't smiling now.",
         "THREDRA: Then let's dance upon the glass, dearies, and see who shatters first."], event_id)
    won = pbTrainerBattle(:FT_HAG_NIGHT, "Thredra", nil, false, 0)
    return if !won
    scene_hag_defeated(event_id)
  end

  # What each mirror shows before something climbs out of it. Mirror 3 wears the
  # Journey player's home, and the lantern glass says it isn't theirs (M4-7).
  def hag_mirror_sight(i)
    case i
    when 1
      [herald?(:reptin) ? "You look into the mirror. Your reflection has yellow eyes. You don't." :
                          "You look into the mirror. Reptin's reflection has yellow eyes. Reptin doesn't."]
    when 2
      [herald?(:shade) ? "You look into the mirror. At your shoulder, Shimmer turns a carved cat. You look away." :
                         "You look into the mirror. At your shoulder, Shimmer turns a carved cat. Shade looks away."]
    else
      if herald?(:wyn)
        ["You look into the mirror. It shows the Sap Gate at festival. Your post, a lamp still lit.",
         "The shard in your pocket stays quiet. This glass is wearing your home. It isn't yours."]
      elsif journey?
        ["You look into the mirror. It shows Hellen's tavern, warm. Someone is saving your seat.",
         "The glass in your pocket stays quiet. This mirror is wearing your home. It isn't yours."]
      else
        ["You look into the mirror. You're warm in it, by a summer fire. Then it grins."]
      end
    end
  end

  def hag_mirror(i, event_id = nil)
    return if flag?(:"hag_mirror_#{i}")
    if !flag?(:hag_parley)
      say(["A tall pane of ice stands between the stones. Your reflection looks back at you.",
           "Behind its shoulder, a crone is smiling. (She's waiting at the centre stone.)"], event_id)
      return
    end
    say(hag_mirror_sight(i) + ["The glass bulges, and something climbs out of it!"], event_id)
    foe = [[:SNORUNT, 26], [:B429H427, 27], [:GLALIE, 27]][i - 1]
    return if !boss_battle(named_mon(foe[0], foe[1], "Mirror-wight"))
    pbSEPlay("Ice2") rescue nil
    # staging: the pane cracks top to bottom and falls (E-06)
    pane = (event_id && $game_map ? $game_map.events[event_id] : nil) rescue nil
    if pane
      Stage.hide(pane)
      Stage.fx("E-06", pane, oy: 56)
    end
    cackle
    set_flag(:"hag_mirror_#{i}")
    after = ["Behind you, the crone's laugh catches, just for a moment.",
             "Out on the lake, one of the dark shapes lifts its head.",
             "Behind you, the laughing has stopped."][mirrors_broken - 1]
    say(["The mirror cracks top to bottom and falls into the snow in a hundred laughing pieces.", after].compact)
    Stage.cleanup rescue nil
    set_self_switch(event_id, "A")
    state[:goal] = "The mirrors are broken. Face Thredra at the centre stone." if mirrors_broken >= 3
  end

  # SC 4.10 - The thaw, shown, and a morning that's earned (context 04 M4-8):
  # breaking her mirrors frees what they held, on screen; then a fade, and Durmoot.
  def scene_hag_defeated(event_id = nil)
    set_flag(:hag_defeated)
    set_flag(:hag_fled)
    add_counter(:story_beats)
    pbSEPlay("Ice2") rescue nil
    thr = (event_id && $game_map ? $game_map.events[event_id] : nil) rescue nil
    say(["THREDRA: Clever. Clever, clever. You broke them.",
         "THREDRA: Do you know how long it takes to grow a mirror?",
         "Her outline flickers, thin as frost on a windowpane.",
         "THREDRA: Come and find me in the chasm, dearies. Bring your wolf.",
         "THREDRA: Granny keeps her bargains."], event_id)
    say(["THREDRA: (to you) And you, lost one. My last glass is in the chasm. Yours too."], event_id) if outsider?
    if thr
      Stage.hide(thr)
      Stage.fx("E-06", thr, oy: 40)
    end
    pbBGMFade(1.0) rescue nil
    say(["She splits into shards, and the wind takes them south."])
    $game_switches[SW_HAG_DOWN] = true if $game_switches
    $game_map.need_refresh = true if $game_map
    Stage.pan_to(28, 34)
    say(["Out on the lake, the frozen figures breathe. One by one they gasp and fall to their knees."])
    Stage.pan_back
    sayc([cl(:reptin, "(hand closing over the bite) ...Bring your wolf. She means me."),
          cl(:alerion, "She means all of us. She just started with you.")])
    set_flag(:husband_thawed)
    fisher = begin
      Stage.actor(:fisherman, $game_player.x + 4, $game_player.y, 4, graphic: "BW (54)")
    rescue StandardError
      nil
    end
    say(["A fisherman with a Spheal-shaped float on his line stumbles up the shore to you."])
    Stage.approach(fisher) if fisher
    say(["FISHERMAN: Targos. Tell my wife I'm coming home. Tell her to keep the lamp lit."])
    if flag?(:widow_spheal)
      say(["(You already have his Spheal. You let it out of its ball.)",
           "He laughs until he cries."])
    else
      say(["(A widow in Targos is waiting on this man.)"])
    end
    Stage.cleanup rescue nil
    # SC 4.10 - Don't tell anyone (morning)
    begin
      pbFadeOutIn { $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 0) }
    rescue StandardError
      $game_screen.start_tone_change(Tone.new(0, 0, 0, 0), 0) rescue nil
    end
    state[:dh_night_tone] = false
    pbBGMPlay("Lavender Town") rescue nil
    say(["Morning."])
    durmoot = begin
      Stage.actor(:durmoot, $game_player.x + 3, $game_player.y - 2, 2, graphic: "FT_speaker_edgra_durmoot")
    rescue StandardError
      nil
    end
    say(["Speaker Durmoot comes down from her lodge with a lantern she doesn't need any more."])
    Stage.approach(durmoot) if durmoot
    sayc(["DURMOOT: Thank you.",
          "DURMOOT: ...Don't tell anyone I said that.",
          cl(:alberica, "Oh, sugar, I'm writing a song about it."),
          "DURMOOT: Chasm's south. Take this. Snarl. It's how this town answers the wind."], nil)
    pbMessage(_INTL("Durmoot holds out the TM."), [_INTL("Take it.")], 0) rescue nil
    sayc([
          "DURMOOT: And make sure she never comes back up out of it. Not for us. For Ten-Towns.",
          "DURMOOT: ...Don't tell anyone I said that either."])
    # (notes/14 E14 (4): a Speaker on the spine names a favour you finished)
    done_word = [[:climb_done, "You brought the Velryn boy down off Kelvin's Cairn."],
                 [:mead_returned, "Good Mead has its mead back. Even we heard."],
                 [:mine_done, "Termalaine's mine is open again."],
                 [:white_moose_done, "Lonelywood's loggers are back in the woods."],
                 [:mugs_done, "The Battlehammers brought their dead home."]].find { |f, _| flag?(f) }
    say(["DURMOOT: Word walks faster than you do. #{done_word[1]}", "DURMOOT: ...Fine. You're useful."]) if done_word
    # The last chance at Act I's favours, said before the door (context 14, M14-9 A).
    if respond_to?(:town_quests_done) && town_quests_done < 5 && !flag?(:ten_towns_thanked)
      sayc([cl(herald?(:reptin) ? :alerion : :reptin,
               "The Chasm's a long way down. If we owe anyone up the road, now's the time to pay.")] +
           favours_count_lines)
    end
    pbReceiveItem(:TM95) rescue nil
    Stage.cleanup rescue nil
    set_flag(:dh_morning)
    state[:goal] = outsider? ? "The Cackling Chasm, south of Dougan's Hole. She's there, with the last of her mirrors." :
                              "The Cackling Chasm, south of Dougan's Hole. She's there."
  end

  # A shape on the ice, up close, before the thaw (notes 04 E12; act1_script SC 4.02).
  FROZEN_SHAPES = {
    thawed_fisher_a: "A man with a fishing line, mid-cast. His breath is frozen in the air in front of him.",
    thawed_old_man:  "An old man on a stool by his hole, a cup halfway to his mouth. The cup is empty.",
    thawed_husband:  "A man with a Spheal-shaped float on his line. Frost holds him mid-step, facing north.",
    thawed_woman:    "A woman with her arms held out, as if to hug someone. There's nobody there.",
    thawed_fisher_b: "A fisher on one knee by a hole, one hand in the water. The water froze round it."
  }

  def frozen_shape(key, event_id = nil)
    say([FROZEN_SHAPES[key] || "Someone stands on the ice, stopped mid-breath. Snow has drifted at their legs.",
         "Their eyes are open. They don't blink."], event_id)
  end

  def apply_chapter4_switches
    return if !active? || !$game_switches
    sync_switch(SW_DH_WEST_OPEN, flag?(:met_durmoot))
    sync_switch(SW_KIDS_FREED, flag?(:kids_freed))
    sync_switch(SW_KIDS_HOME, flag?(:kids_home))
    sync_switch(SW_DH_BADGE, flag?(:badge_dougans))
    sync_switch(SW_HAG_DOWN, flag?(:hag_defeated))
    set_flag(:hag_night_ready) if flag?(:hag_parley) && !flag?(:hag_night_ready)   # (saves from before the rest)
    sync_switch(SW_HAG_NIGHT, flag?(:hag_night_ready))
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
