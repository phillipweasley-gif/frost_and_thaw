#===============================================================================
# Frost & Thaw - Act II, Chapter 6 (continued): Rootspire, the hub
#
# Rootspire is Act II's hub (the Story Bible's "Seven Days of Summer"). From it
# the quest lines go out and come back: the Heartroot (the market well), the
# myconid colony (Wyn's Sap Gate in the Root-Tier) and, later, the Rootsun
# Forge, and they meet in the heart of the tree. Built from the campaign
# documents: the Story Bible, Rootspire Parts II-IV, Hyphora's Undercanopy,
# the Seasonal Factions dossier, the Wennen and Feycorn books, Hatchlings and
# the Bloom Guard dream visions.
#
#   The Rooted Hearth's root-cellar: Gym 4, Hellen Brightrun (Normal, a blender),
#     and the shrine her family kept to the Heralds. Tamsin, her kid (the New
#     Journey rival), challenges you outside.
#   The Verdant Bazaar: Pip the pocket tailor (bag upgrades), the Wennen
#     (Lirielle Mossdancer's perfumes and dreams, Nivva Sunwick's apothecary,
#     Reva Mosscut's flower-sculpture of the Heralds), Captain Rheven.
#   The Canopy-Tier (the root-lift): the Shrine of the Twinned Dragons, where
#     Razzilith and Frostina, adolescents now, come down to meet the Heralds,
#     and Lumin Weavemoss reads the Wennen's "Dragon Warriors"; the Aerie
#     Markets; a Feycorn who came up through the roots from another plane; the
#     Celestial Rift and the Lumen Shard, waiting for its bearer; the Wind-Glass
#     Library (Eirwen, and Alberica's sub-vault); the College of Auroral Arts
#     (Professor Wynsnow, the Grafting licence, the Lecture in Blue Fire).
#   The Root-Tier: Captain Ivran Solmar and the Split Dock; Meat Meat's
#     driftwood chest; the Rootwarden Crypt (Reptin's staff); the Sap Gate.
#   Hyphora's Undercanopy: the myconid colony, Hyphora the god-sapling, the
#     Mnemosyne, the Shadow Mycolith in the lake, and Gym 7, Sovereign Luminara.
#===============================================================================
module FrostThaw
  SW_HEARTH_BADGE = 3940   # Hellen's seal
  SW_CRYPT_OPEN   = 3941   # Rheven has unsealed the Rootwarden Crypt
  SW_SAP_GATE     = 3942   # Eira lets you into the Undercanopy
  SW_LAKE_CLEAN   = 3943   # the Shadow Mycolith is destroyed
  SW_UNDER_BADGE  = 3944   # Luminara's seal
  SW_TWINS_MET    = 3945   # the twins came down at the shrine
  SW_HALO_ORB     = 3946   # the Halo splinter is driven from the orb
  SW_WRAITHS      = 3947   # the Echo Gate's Mirror Wraiths are dispelled

  MAPS.merge!(fields: 2060, hearth_cellar: 2059, canopy: 2061, library: 2062, college: 2063, crypt: 2065, undercanopy: 2068)
  MAP_NAMES.merge!(
    2059 => "The Hearth's Root-Cellar", 2060 => "The Blooming Fields", 2061 => "Rootspire Canopy-Tier", 2062 => "The Wind-Glass Library",
    2063 => "College of Auroral Arts", 2065 => "The Rootwarden Crypt", 2068 => "Hyphora's Undercanopy"
  )
  MAP_METADATA.merge!(
    2059 => { announce_location: true },
    2060 => { outdoor_map: true, announce_location: true, battle_environment: :Grass },
    2061 => { outdoor_map: true, announce_location: true, battle_environment: :Forest },
    2062 => { announce_location: true }, 2063 => { announce_location: true },
    2065 => { announce_location: true, battle_environment: :Cave },
    2068 => { announce_location: true, battle_environment: :Cave }
  )
  AREAS.merge!(2060 => :fields, 2059 => :hearth, 2061 => :canopy, 2062 => :library, 2063 => :college, 2065 => :crypt,
               2068 => :undercanopy)

  CANOPY_ARRIVAL = [2061, 12, 33, 8]
  LIFT_LANDING   = [2050, 15, 12, 2]
  CELLAR_ARRIVAL = [2059, 11, 24, 8]
  UNDER_ARRIVAL  = [2068, 10, 42, 8]
  UNDER_REST     = [2068, 9, 31, 8]

  ENCOUNTERS[2068] = { step_chances: { Cave: 8 },
                       Cave: [[20, :PARASECT, 37, 40], [20, :SHROOMISH, 37, 39], [10, :BRELOOM, 39, 41],
                              [15, :GLOOM, 37, 39], [10, :SABLEYE, 38, 40], [10, :GOLBAT, 38, 40],
                              [10, :MISDREAVUS, 38, 40], [5, :GLOAMCAP, 39, 41]] }
  VERSION_ENCOUNTERS[:frost][2068] = { Cave: [[8, :SNEASEL, 38, 40]] }
  VERSION_ENCOUNTERS[:thaw][2068]  = { Cave: [[8, :VILEPLUME, 39, 41]] }
  ENCOUNTERS[2060] = { step_chances: { Land: 21 },
                       Land: [[20, :SKIPLOOM, 35, 37], [15, :PILOSWINE, 36, 38], [15, :GLOOM, 35, 37], [10, :NOCTOWL, 36, 38],
                              [10, :STANTLER, 36, 38], [10, :SNEASEL, 36, 38], [10, :ROSELIA, 35, 37], [10, :DELIBIRD, 35, 37]] }
  VERSION_ENCOUNTERS[:frost][2060] = { Land: [[10, :GLALIE, 37, 38]] }
  VERSION_ENCOUNTERS[:thaw][2060]  = { Land: [[10, :SUNFLORA, 36, 38]] }
  ENCOUNTERS[2061] = { step_chances: { Land: 21 },
                       Land: [[20, :SKIPLOOM, 36, 38], [15, :NATU, 36, 38], [15, :SWABLU, 36, 38], [10, :XATU, 37, 39],
                              [10, :NOCTOWL, 37, 39], [10, :BELLOSSOM, 37, 39], [10, :ALTARIA, 38, 39], [10, :MURKROW, 36, 38]] }
  ENCOUNTERS[2065] = { step_chances: { Cave: 6 },
                       Cave: [[30, :HAUNTER, 38, 40], [30, :TANGELA, 37, 39], [20, :MISDREAVUS, 38, 40], [20, :GOLBAT, 38, 40]] }

  MARTS[:apothecary] = [:SUPERPOTION, :HYPERPOTION, :FT_SAPSALVE, :FULLHEAL, :ICEHEAL, :REVIVE, :ETHER]
  MARTS[:aerie]      = [:ULTRABALL, :QUICKBALL, :TIMERBALL, :MOONSTONE, :SUNSTONE, :LEAFSTONE, :DAWNSTONE, :MAXREPEL]
  MARTS[:faria]      = [:FT_SAPSALVE, :FULLHEAL, :REVIVE, :TINYMUSHROOM, :BIGMUSHROOM, :DUSKBALL, :NESTBALL]

  COMPANION_NAMES[:wyn] ||= "WYN"

  #-----------------------------------------------------------------------------
  # Trainers
  #-----------------------------------------------------------------------------
  TRAINER_TYPES.merge!(
    FT_HEARTH_LEADER: ["Hearth-Keeper", :BEAUTY, 1, 120, :LEADER_Brock],
    FT_TAMSIN_I:      ["Hearth-Kid", :PICNICKER, 1, 80, :LEADER_Brock],
    FT_TAMSIN_G:      ["Hearth-Kid", :PICNICKER, 1, 80, :LEADER_Brock],
    FT_TAMSIN_F:      ["Rootwarden", :PICNICKER, 1, 80, :LEADER_Brock],   # sworn in during the trial week (whole read T7)
    FT_SKYSAILOR:     ["Sky-Sailor", :PICNICKER, 1, 60],
    FT_SCHOLAR:       ["Auroral Scholar", :GENTLEMAN, 0, 70],
    FT_SOVEREIGN:     ["Myconid Sovereign", :BEAUTY, 1, 140, :LEADER_Brock]
  )
  TRAINERS.merge!(
    # Gym 4: the Hearth's regulars, then Hellen. Normal, blended (the Bible: a "blender").
    hearth_dunstan: [:WORKER, "Dunstan", [[:B208H162, 38], [:B76H20, 38]],
                     "Fair's fair. Down you go. Mind the third step."],
    hearth_mellow:  [:BEAUTY, "Mellow", [[:B36H39, 38], [:LOPUNNY, 39]],
                     "Oh, Hellen will be thrilled. She hates an easy guest."],
    hearth_corrie:  [:FISHERMAN, "Old Corrie", [[:B55H161, 38], [:B130H128, 39]],
                     "Four hundred years my family waited to lose to you. Worth it."],
    hearth_tallis:  [:GENTLEMAN, "Tallis", [[:GIRAFARIG, 38], [:B124H40, 39]],
                     "I'll put this in the song. I'll sound better in the song."],
    hellen_gym:     [:FT_HEARTH_LEADER, "Hellen", [[:B184H241, 37], [:B266H217, 38], [:B38H128, 38], [:B149H143, 40]],   # (whole read P3: was ace 42, the most-lost fight)
                     "Well. The wall had you right, love.", [:HYPERPOTION, :FULLRESTORE]],
    # Tamsin, Hellen's kid: the starter that beats yours
    tamsin_i: [:FT_TAMSIN_I, "Tamsin", [[:FURRET, 37], [:JUMPLUFF, 38], [:B331H154, 40]], "No. No! ...Okay. Rematch. Soon."],
    tamsin_g: [:FT_TAMSIN_G, "Tamsin", [[:FURRET, 37], [:JUMPLUFF, 38], [:FORGEL, 40]], "No. No! ...Okay. Rematch. Soon."],
    tamsin_f: [:FT_TAMSIN_F, "Tamsin", [[:FURRET, 37], [:JUMPLUFF, 38], [:B9H221, 40]], "No. No! ...Okay. Rematch. Soon."],
    # The Blooming Fields
    bough_teo:      [:FT_ROOTWARDEN, "Teo", [[:BRELOOM, 36], [:STANTLER, 37]], "Bough circle's still standing. Mostly."],
    pilgrim_ysolde: [:PICNICKER, "Ysolde", [[:SKIPLOOM, 36], [:SUNFLORA, 36], [:B36H182, 37]], "Nine days' walk to lose in one turn. Fair."],
    hiker_gromm:    [:HIKER, "Gromm", [[:PILOSWINE, 37], [:B95H274, 38]], "Sky-Path's steep. So are you. Ha!"],
    halo_kael:      [:FT_HALO, "Brother Kael", [[:SNEASEL, 37], [:B429H124, 38]], "Leave the Still Ones be. They were blessed."],
    eren:           [:FT_ROOTWARDEN, "Eren", [[:NOCTOWL, 37], [:GLACEON, 38], [:B163H272, 39]], "You fight like the stories. Cold. Careful."],
    # The Canopy-Tier
    sky_wren:    [:FT_SKYSAILOR, "Wren",  [[:SKARMORY, 38], [:ALTARIA, 38]], "Wind took my line. It does that up here."],
    sky_talla:   [:FT_SKYSAILOR, "Talla", [[:XATU, 38], [:B227H18, 39]], "You win. Don't tell the Aerie. I had money on me."],
    halo_ilse:   [:FT_HALO_F, "Sister Ilse", [[:JYNX, 38], [:B87H215, 39]], "She's the goddess's daughter. Someone should tell her."],
    halo_vosk:   [:FT_HALO, "Brother Vosk", [[:DELIBIRD, 38], [:B91H200, 39]], "The orb was nearly cold. Nearly."],
    scholar_pell:  [:FT_SCHOLAR, "Hollis",  [[:KADABRA, 37], [:PORYGON2, 38]], "My thesis survives. Barely. Footnotes everywhere."],
    scholar_quill: [:FT_SCHOLAR, "Quill", [[:XATU, 37], [:B82H122, 38]], "Chronal anomalies hit harder than expected. Noted."],
    # The Undercanopy
    masked_trader: [:FT_HALO, "Masked Trader", [[:SNEASEL, 39], [:B429H124, 40], [:B200H215, 40]],
                    "The Frost Saint walks again. The lake remembers."],
    luminara:      [:FT_SOVEREIGN, "Luminara", [[:B71H182, 42], [:B89H355, 43], [:VILEPLUME, 43], [:B45H439, 44]],
                    "(The thread holds. Because you held it.)", [:HYPERPOTION, :FULLRESTORE]]
  )
  TRAINER_INTROS.merge!(
    hearth_dunstan: "DUNSTAN: Cellar's Hellen's. Nobody gets to her past the regulars. That's us.",
    hearth_mellow:  "MELLOW: Heralds in the cellar! Oh, good. I dressed up.",
    hearth_corrie:  "OLD CORRIE: My great-great-great-grandad watched you sail off. Show me what he saw.",
    hearth_tallis:  "TALLIS: Every bard in the Hearth sings about you. Let's see what they made up.",
    bough_teo:      "TEO: Bough circle. We walk to the Wall and back. Today you're the patrol.",
    pilgrim_ysolde: "YSOLDE: A battle on the Sky-Path means luck on the walk home!",
    hiker_gromm:    "GROMM: Flowers in the snow! Battles in the flowers! Ha!",
    halo_kael:      "KAEL: You walk past the Still Ones like they're furniture. They're saints.",
    eren:           "EREN: You're the one with the ring. My family tells stories about you. Please. Battle me.",
    sky_wren:       "WREN: Sky-sailor's rule! Anyone on the high bridges owes a duel!",
    sky_talla:      "TALLA: The Aerie bets on everything. Today I'm betting on me.",
    halo_ilse:      "ILSE: Leave the orb. She's listening. She's nearly listening.",
    halo_vosk:      "VOSK: The Matron said winter's daughter comes home through this orb. Not past you, then.",
    scholar_pell:   "HOLLIS: Chronal anomalies! The Professor said you'd come. I'm testing you first.",
    scholar_quill:  "QUILL: A practical, then. My Pokémon against your four hundred years.",
    masked_trader:  "MASKED TRADER: Whispers of the Echo Gate! Rare goods for... ah. You saw my gloves.",
    hellen_gym:     "HELLEN: Sleeves up, love. Let's see you.",
    tamsin_i:       "TAMSIN: Here goes!", tamsin_g: "TAMSIN: Here goes!", tamsin_f: "TAMSIN: Here goes!",
    luminara:       "LUMINARA: (Let me see where you sit in the cycle.)"
  )

  #-----------------------------------------------------------------------------
  # Dialogue
  #-----------------------------------------------------------------------------
  TEXT.merge!(
    # --- the Trunk-Tier ----------------------------------------------------------
    # (context 12 row 12.05: on the eve of the crossing the twins' line is Act II's; it
    # names the roost only when the griffons are the way you're going)
    lift_keeper: -> {
      if T.flag?(:ch11_done) && !T.flag?(:solstice_sighted)      # (the eve of the crossing)
        T.respond_to?(:voyage_route) && T.voyage_route == :griffons ?
          ["LIFT-KEEPER: Canopy again? Griffons have been pacing the roost since dawn."] :
          ["LIFT-KEEPER: Canopy again? It's quiet up there, without the white one circling."]
      elsif T.flag?(:dragon_launched) && !T.flag?(:dragon_down)
        ["LIFT-KEEPER: Canopy? Something black tore out of the roots. The twins went mad."]
      elsif T.flag?(:dragon_down)
        ["LIFT-KEEPER: Canopy? The twins are back on their roost. The whole city's still staring."]
      elsif T.flag?(:twins_met)
        ["LIFT-KEEPER: Canopy? The dragons have circled low since you came.",
         "LIFT-KEEPER: Whole city's got a crick in its neck from looking up."]
      else
        ["LIFT-KEEPER: Root-lift, up to the Canopy-Tier. Hold on to something that isn't me."]
      end
    },
    lirielle: -> {
      if T.flag?(:lirielle_dream)
        ["LIRIELLE: I wrote your scent down. Snow, smoke, something green. I'm calling it Herald.",
         "LIRIELLE: I still dream of the roots burning. Under the tree, where the old town was.",
         "LIRIELLE: Something down there is making fire that shouldn't be."]
      else
        T.set_flag(:lirielle_dream)
        ["A grey-furred Wennen with flowers round her ears sniffs the air as you pass.",
         "She writes something in a notebook, in violet ink.",
         "LIRIELLE: Oh! Sorry. Lirielle Mossdancer, of the Perfumed Root. I read the air.",
         "LIRIELLE: Yours is very old. And very new. That's not supposed to happen.",
         "LIRIELLE: My people came from the Circle in Lonelywood. We carry the Moon Requiem with us.",
         "Her ears go flat.",
         "LIRIELLE: The night the frost egg hatched. You know it?",
         "LIRIELLE: (sniffing) ...You were there. It's still on your coat. Snow, and a lullaby.",
         "LIRIELLE: Lately I dream every night. Roots burning. Sap screaming.",
         "She lowers her voice.",
         "LIRIELLE: Something below is burning the seasons alive.",
         "LIRIELLE: Nobody wants to hear that during a festival. You look like you'd go and check."]
      end
    },
    nivva: ["NIVVA: Run & Bloom Apothecary! Draughts, frost-balm and Sap-Skin Salve.",
            "NIVVA: One jar and you can sleep in a snowdrift. Please don't, though.",
            "NIVVA: Red heals. Green's for frost. Muddled ones are a surprise. Surprises cost extra."],
    reva: [{ if: { flag: :twins_met }, lines: ["REVA: I'm adding two dragons to the sculpture. They keep growing.",
                                                "REVA: The dragons, I mean. Also the sculpture."] },
           ["A Wennen with pink-tipped ears ties living flowers into a sculpture of four figures.",
            "One of them has a wolf's shadow.",
            "REVA: Reva Mosscut. The Heralds, in bloom. I can never get the faces right.",
            "REVA: ...Hold still. No, look that way. Hm. No."]],
    rheven: -> {
      if T.flag?(:crypt_open)
        ["RHEVEN: The Crypt's open to you. Our first Wardens sleep in the sap.",
         "RHEVEN: Walk softly. Some of them still listen."]
      elsif T.flag?(:badge_hearth)
        T.set_flag(:crypt_open)
        $game_switches[FrostThaw::SW_CRYPT_OPEN] = true if $game_switches
        $game_map.need_refresh = true if $game_map
        ["RHEVEN: Hellen's seal. She doesn't give that to anyone she wouldn't trust with her cellar.",
         "RHEVEN: So I'll trust you with ours. Below the Root-Tier there's a crypt.",
         "His direwolf thumps her tail on the cobbles, once.",
         "RHEVEN: The first Rootwardens, standing in clear sap, as they asked to.",
         "RHEVEN: One holds a staff grown from the World Tree's first roots.",
         "RHEVEN: The creed says it waits for whoever taught us the creed.",
         "He touches two fingers to his chest, the way the Rootwardens do.",
         "RHEVEN: Guard the pulse. Let neither flame nor frost claim it wholly.",
         "RHEVEN: The door's unsealed, south-east in the Root-Tier. If it wants you, it'll say."]
      else
        ["A huge half-orc in wolf-skin watches the crowd, arms folded. A direwolf dozes at his feet.",
         "RHEVEN: Captain Rheven Stormbranch, Rootwardens. Guard the pulse.",
         "RHEVEN: Let neither flame nor frost claim it wholly.",
         "RHEVEN: My wardens keep going missing past the Wall. I've no time for festivals.",
         "RHEVEN: But you came back. That's worth a lantern.",
         "RHEVEN: Earn Hellen Brightrun's seal, down in the Hearth's cellar. Then find me.",
         "RHEVEN: The Rootwardens have something that's been waiting for you."]
      end
    },
    rheven_wolf: ["The direwolf lifts its head and looks at you for a long time.",
                  "It's the way old dogs look at people they used to know.",
                  "Somewhere far back in its eyes, a wolf you once fed in the snow is looking too."],
    hew_talmire: [{ if: { flag: :ch7_started }, lines: ["HEW: My diggers! The Guild dig under the market broke into the Heartroot.",
                                                         "HEW: A week ago. Two crews down. None back up.",
                                                         "HEW: It meets the Heartroot near the old Rootguard post. If you're going down anyway...",
                                                         "HEW: Look for them. Please. And don't touch the amber fuel."] },
                  ["A sap-stained gnome is trying to bottle a lantern's glow, and losing.",
                   "HEW: Master Hew Talmire, Guild of Roots and Stone! We build everything that isn't growing.",
                   "HEW: And some things that are. Tree-light, bottled! That's the dream.",
                   "HEW: It keeps getting out. Very politely, mind."]],
    tamsin_after: -> {
      if T.journey?
        ["TAMSIN: #{player_display_name}! You were gone ONE HOUR. And you came back with the HERALDS.",
         "TAMSIN: Mum's going to sit you at the head of the table forever. It's so unfair."]
      else
        T.flag?(:badge_hearth) ? ["TAMSIN: You beat Mum. Nobody beats Mum. She's been humming all day. It's unbearable."] :
                                 ["TAMSIN: Mum says the cellar's open to you. Mum never opens the cellar.",
                                  "TAMSIN: Go and lose to her. It's tradition. Everybody does."]
      end
    },
    hearth_dunstan_after: ["DUNSTAN: Barrel-hoops and battles. Both want a firm hand."],
    hearth_mellow_after: ["MELLOW: Hellen's at the back, by the shrine. Mind the roots. They trip people on purpose."],
    hearth_corrie_after: ["OLD CORRIE: My great-great-great-grandad would've liked you. He liked anyone who beat him."],
    hearth_tallis_after: ["TALLIS: 'And lo, the Heralds came down, and Tallis was SPLENDID.' ...It's a draft."],
    bough_teo_after: ["TEO: Rheven's lost four of us this year. If you see Bough colours by the Wall... tell him."],
    pilgrim_ysolde_after: ["YSOLDE: Flowers grow right through the snow. Gran called it the Dale arguing with itself."],
    hiker_gromm_after: ["GROMM: Wall's that way. Don't touch it. Time's stuck on the other side, and it's sticky."],
    halo_kael_after: ["KAEL: The Reversal caught them mid-step. Mid-prayer. We call them saints.", "KAEL: They call for help."],
    eren_after: ["EREN: There's a hunter frozen at the Wall. He looks like you, Alerion. A bit like me, too.",
                 "EREN: I've never dared touch his cloak."],
    sky_wren_after: ["WREN: Up here the wind picks the winner. Today it picked you."],
    sky_talla_after: ["TALLA: The dragons came down to the market! The whole Aerie lost its bets."],
    halo_ilse_after: ["ILSE: Frostina's the goddess's daughter. Doesn't she deserve her mother?"],
    halo_vosk_after: ["VOSK: The Matron will find another way in. There's always another way in."],
    scholar_pell_after: ["HOLLIS: The Professor's lecture is today. Bring something fireproof."],
    scholar_quill_after: ["QUILL: Thesis revised: 'Chronal anomalies hit hard.' That's the whole thesis now."],
    masked_trader_after: ["..."],
    fields_sign: ["THE BLOOMING FIELDS. The Sky-Path, to the Auroral Wall.", "Rootwardens patrol this road. Travellers, keep to the path."],
    boundary_stone: ["A Boundary Stone, frost-furred, dated Year 192 VR:",
                     "\"Winter remembers those who walk softly across its back.",
                     "The Froststride does not conquer the cold. He teaches it to kneel.\""],
    auroral_wall: ["The Auroral Wall: a curtain of light from the snow to the sky.",
                   "On the other side, snowflakes hang in the air, mid-fall. Time is still frozen there.",
                   "Your hand stops an inch from the light, as if it has changed its mind."],
    # --- the Hearth's root-cellar ---------------------------------------------------
    hearth_stair_shut: ["A stair goes down behind the bar, into the warm dark under the tree.",
                        "A sign hangs across it: PRIVATE. FAMILY ONLY. YES, THAT MEANS YOU, CORRIE."],
    cellar_sign: ["THE ROOTED HEARTH'S ROOT-CELLAR. Hearth-Keeper: Hellen Brightrun.", "\"The Heralds will drink once more before the seasons turn.\""],
    herald_shrine: -> {
      lines = ["Behind the casks, a little shrine is grown into the living root.",
               "Four figures carved in pale wood. A lantern nobody has ever let go out.",
               "Four cups, cleaned and set out, as if four guests are expected any minute. For centuries."]
      lines << "A fifth cup has been added. Its rim is still rough from the knife." if T.flag?(:badge_hearth)
      lines
    },
    # --- the Hall of Seasons (the Heralds' statues) -----------------------------------
    statue_alberica: ["A dwarf with a pendant at her throat, mid-song. ALBERICA, THE DWARF OF SONG. MEMORY.",
                      "Someone's left a lute at her feet. It's a very bad lute. It's been left with love."],
    statue_reptin: ["An elf with a wolf's shadow at his heels, one hand open, one closed.",
                    "REPTIN. GROWTH. THE WARDEN. The stone at his feet is worn smooth by hands, for luck."],
    statue_alerion: ["An eladrin with a ring of frost on one hand, bow lowered.",
                     "ALERION FROSTSTRIDE. HE TAUGHT THE COLD TO KNEEL. Frost grows on it even in summer.",
                     "The cleaners have given up."],
    statue_meat_meat: ["A small statue of a goblin, grinning, goggles pushed up, long hair swept down her back.",
                       "A wyrmling is coiled round her shoulders. MEAT MEAT. THE LIGHT HALF.",
                       "It's the only statue with snacks at its feet. The snacks are always gone by morning."],
    # --- the Canopy-Tier ------------------------------------------------------------------
    canopy_sign: ["THE CANOPY-TIER. Shrine of the Twinned Dragons, the Aerie Markets, the Celestial Rift.",
                  "East: the Wind-Glass Library. South: the College of Auroral Arts.",
                  "West, over the leaf-bridge: the Lightfall Promenade."],
    aerie_merchant: ["AERIE MERCHANT: Air-fruit! Wing-leaf sails! Stones with a bit of sky in them!",
                     "AERIE MERCHANT: Everything up here is lighter. Even the prices. Some of the prices."],
    aarakocra_seer: -> {
      if T.flag?(:seer_motes)
        ["SEER: The frozen world outside the Wall is waking. I've said it. Now I sleep."]
      else
        T.set_flag(:seer_motes)
        T.give(:FT_AURORALMOTE, 2)
        ["An aarakocra with a bandaged wing sits among bottles of light, watching the aurora.",
         "SEER: You. The ones from before. Listen: the frozen world outside the Wall is starting to wake.",
         "SEER: Take these. Motes of the northern lights. The market collectors pay well.",
         "SEER: Where you're going, you'll need the money."]
      end
    },
    cornipus: -> {
      if T.flag?(:met_cornipus) && T.flag?(:lake_cleansed) && !T.flag?(:balanus_explained)
        T.set_flag(:balanus_explained)
        ["CORNIPUS: Oh. Oh, put that down. No, don't. Hold it. Carefully.",
         "CORNIPUS: That's a seed of Balanus. The first World Tree on this plane.",
         "He takes his cap off. Then he puts it back on.",
         "CORNIPUS: The Frostmaiden cut him down before your great-grandmothers were born.",
         "CORNIPUS: He didn't stop being a tree just because he was dead. Seeds remember.",
         "CORNIPUS: Keep it. Someday something will need planting, and you'll know."]
      elsif T.flag?(:met_cornipus)
        ["CORNIPUS: Still here! Still growing! My shell's gone barky at the edges.",
         "CORNIPUS: That happens when we're away from home too long. I'm ignoring it."]
      else
        T.set_flag(:met_cornipus)
        T.give(:FT_RENEWALSEED)
        ["Something the size of a large acorn is sitting on the railing, kicking its little feet.",
         "It has a face, tiny arms, and a cap like a hat.",
         "CORNIPUS: Hello! Cornipus, Seed of Plaito. I'm a Feycorn. Fruit of a God-Tree!",
         "CORNIPUS: Mine's on another plane entirely. I came up through the roots.",
         "He swings his little feet.",
         "CORNIPUS: Every plane has a World Tree, you know. Their roots reach through everything.",
         "CORNIPUS: When a World Tree's old enough to bear fruit, it becomes a god. We're the fruit.",
         "CORNIPUS: We wake up with a job and a terrible urge to travel.",
         "He leans in, very serious.",
         "CORNIPUS: This tree's four hundred years old. A baby! It should take thousands.",
         "CORNIPUS: But it grew on dragon-breath and stubbornness, and it's thinking about godhood.",
         "CORNIPUS: Nobody's told it it isn't allowed, so.",
         "He taps the railing with one tiny hand.",
         "CORNIPUS: Something under it is listening, for the tree. Ask the mushrooms.",
         "CORNIPUS: Got a story for me? Four hundred years ago, you say? Oh, that's a good one. Here, have a seed."]
      end
    },
    lumen_shard: -> {
      lines = ["The sky opens above you. No clouds, no stars: only aurora, pouring down gold and green.",
               "In the heart of it floats a splinter of crystal light the size of a heart.",
               "You reach for it, and a shadow of yourself forms in the light, eyes black as void.",
               "\"Will you bear hope when even the sun freezes?\"",
               "Your hand closes on nothing. The shard isn't yours. It's waiting for someone else."]
      lines << T.as(:shade, "It's waiting for a person. I can feel it. Like a seat kept at a table.") if T.with_or_is?(:shade)
      lines << T.as(:alberica, "Shade, sweetheart, you've gone pale. Paler. Breathe.") if T.with_or_is?(:shade) && T.with_or_is?(:alberica) && !T.herald?(:shade)
      lines
    },
    rift_sign: ["\"From the Spark was born the Lumen Shard, hope crystallized.",
                "May its bearer light paths that never knew dawn.\" (Carved on the Rift's inner ring.)"],
    shrine_halo_blocked: ["Two robed figures kneel at the orb, pouring something white and freezing into the light."],
    # --- the Wind-Glass Library ------------------------------------------------------------
    eirwen: -> {
      if T.flag?(:met_eirwen)
        ["EIRWEN: The leaves are listening, Heralds. Speak kindly near the shelves."]
      else
        T.set_flag(:met_eirwen)
        ["An elf with bare feet and frost-dust in their hair turns from a shelf of clear bark.",
         "EIRWEN: Archivist Eirwen Solglass. Every word spoken in Rootspire is written here.",
         "EIRWEN: On leaves of light. Yours too, now. Mind your language.",
         "On the nearest shelf a leaf flickers, writing that down.",
         "EIRWEN: In the oldest roots I keep Naerth Maxildanarr's last ledger.",
         "EIRWEN: It says a pale lady in a tower was bleeding Targos white long before the Rime.",
         "They glance at the door, as if someone might be listening.",
         "EIRWEN: I've never known who to show it to. And there's a sub-vault. Alberica's.",
         "EIRWEN: Her students wrote it into the founding charter: a case only she may open.",
         "EIRWEN: A lovely, safe, symbolic thing to write. Until about an hour ago.",
         T.cl(:alberica, "(very quietly) A case. Of mine. ...Huh.") || "Somewhere in the shelves, a leaf rustles.",
         T.with_or_is?(:alberica) ? "EIRWEN: (to #{T.herald?(:alberica) ? 'you' : 'Alberica'}, shy) I've read every verse you wrote. Here they're scripture." : nil,
         T.with_or_is?(:alberica) ? "EIRWEN: I never thought I'd have to stand in front of the author and be sensible about it." : nil,
         "EIRWEN: The chronal leaves are yours to read, whenever you like. They remember days."].compact
      end
    },
    # (dialogue 06 §3.7, 15 line 1: he says why he has the riddles, and who
    # they're for, to the Journey kid too. The Goal lines are 048_F's.)
    lorn_scribe: -> {
      next ["LORN SCRIBE: (writing backwards) .ti dah syawla uoY .yek eht dnuof uoy taht nwod etorw I"] if T.flag?(:key_found)
      ["An old dwarf draped in frost-paper scrolls writes without looking.", "His eyes are milky, inked with runes.",
                   T.journey? ? "LORN SCRIBE: Four riddles, kept for the Heralds. You'll do to carry them, Herald's friend." :
                                "LORN SCRIBE: Four riddles, kept four hundred years for the Heralds. One for each of you.",
                   "LORN SCRIBE: The blade sleeps in the silt where the boats were frozen.",
                   "LORN SCRIBE: The staff stands with the first Wardens, in sap clear as glass.",
                   "His pen doesn't stop.",
                   "LORN SCRIBE: The mantle waits where the world stops at the wall of light.",
                   "LORN SCRIBE: The key is in this room. It always was. Begin where the year sleeps.",
                   "He dips his pen. He hasn't looked up once."]
    },
    wennen_scholar: ["A Wennen scholar copies old carvings onto leaf-paper.",
                     "WENNEN SCHOLAR: Old Wennen. 'Dragon Warriors.' Partners of dragons. Never masters.",
                     "WENNEN SCHOLAR: And this: 'the wyrm cannot turn the wheel alone. With a guide, it may.'",
                     "WENNEN SCHOLAR: Nobody knows who the guides are. I have theories. Nobody listens to them."],
    library_note: ["A crystal leaf, filed under A, glows with handwriting. Four hundred years old.",
                   "It's Alberica's hand.",
                   "\"The Cycle Canticle has four verses. Begin where the year sleeps.",
                   "Sing it alone, before dawn, in the hall of the four lights.\""],
    # --- the College of Auroral Arts ---------------------------------------------------------
    college_relics: ["A glass case: THE HERALDS' RELICS.", "A medallion of everfrost, a ring of frost, a pendant of black ice.",
                     "They're copies, a card says. Underneath, smaller: 'Probably.'"],
    college_student: ["STUDENT: The Professor calls you chronal anomalies. He says it like a compliment.",
                      "STUDENT: Is it a compliment? I genuinely can't tell with him."],
    # --- the Root-Tier ------------------------------------------------------------------------
    ivran: [{ if: { flag: :twins_met }, lines: ["IVRAN: You've seen them, then. The dragons. I told the Corsairs they were omens.",
                                                 "IVRAN: They laughed. They've stopped laughing."] },
            ["A dock captain with burn scars and one glass-blue eye watches the black water.",
             "IVRAN: Captain Ivran Solmar. I run what moves on this water. I watch what moves under it.",
             "IVRAN: The night before you came: two shapes under the Glasswater. Wyrmling-shaped.",
             "IVRAN: Green, and white. And the Corsairs lost two crews to ice that came off the shore.",
             "IVRAN: Somebody's praying for cold. Somebody's being answered."]],
    driftwood_chest_shut: ["Half buried in the silt below the pier: a driftwood chest.",
                           "It's sealed with a scorched laboratory seal. A stylized \"A\".",
                           "The lock is tiny. Goblin-sized. Someone small would know the trick of it."],
    driftwood_chest_empty: ["The driftwood chest lies open in the silt, empty except for a candle stub."],
    crypt_door_shut: ["A round door of petrified roots, carved with a wolf's paw over a leaf.",
                      "It's sealed with the Rootwardens' willow knot. Captain Rheven keeps the key."],
    sap_gate_shut: ["The Sap Gate: a great knot of living root, bound in iron and willow.",
                    "The old way down to the Underdark is sealed behind it. The Rootwarden's post is empty.",
                    "The Gate hums, very low, like someone singing on the other side."],
    crypt_inscription: ["Carved in the wall above the petrified Wardens:",
                        "\"When the first Warden fell, his staff took root and waited for balance to return.",
                        "May the next bearer remember that rage is only winter longing for spring.\""],
    crypt_warden: ["A druid stands sealed in clear sap, eyes closed, a hand raised in the Rootwarden blessing.",
                   "They look peaceful. They look like they're listening."],
    # --- Hyphora's Undercanopy -----------------------------------------------------------------
    yarro: -> {
      if T.flag?(:blight_burned)
        ["YARRO: (A voice like warm rain.) The gardens breathe easier. Rest, little ones."]
      else
        ["A small myconid hums over beds of glowing caps. Its voice blooms in your head, like rain.",
         "YARRO: (Gently. Gently. You walk on hyphae. Every step is a hand you're standing on.)",
         "YARRO: (The vermilion caps by the far wall have gone black. A blight. It spreads.)",
         "YARRO: (Fire would stop it. We have no fire.)"]
      end
    },
    lysella: -> {
      word = if T.with_or_is?(:meat_meat)
               [T.as(:meat_meat, "Coffee."), "LYSELLA: (...'Coffee.' What does it mean?)", T.as(:meat_meat, "Everything.")]
             else
               ["You teach her 'lantern'.", "LYSELLA: (...'Lantern.' A light you carry. That one's going on a shelf.)"]
             end
      ["A myconid with shelf-fungi round its cap like bookshelves speaks quickly into your head.",
       "LYSELLA: (A word first. Teach me one of yours. I pay in history.)"] + word +
        ["LYSELLA: (Ours, for you: 'mycelium'. It means family, mostly.)",
         "Her shelf-cap creaks as she settles in to pay you in history.",
         "LYSELLA: (Balanus was the first World Tree. Erato was his seed, a Feycorn.)",
         "LYSELLA: (She planted herself, and became a tree, and a god.)",
         "LYSELLA: (Her last seeds scattered through many worlds. One woke here.)"]
    },
    korun: ["A broad myconid hammers a sheet of hyphae into armour.",
            "It looks at your gear and releases a small, scornful puff of spores.",
            "KORUN: (Gear. Mend it. Respect it. Made things remember who made them.)"],
    zym: -> {
      if T.flag?(:spy_unmasked)
        ["ZYM: (Spy gone. You are owed. Take this. It rings when trouble waits.)"]
      else
        ["A myconid sentry with a spear and acid scars stands at attention.",
         "ZYM: (Lake is foul. Something in it. Something under it.)",
         "ZYM: (And a stranger in the market who smells of frost. Watch him.)"]
      end
    },
    faria: ["A small myconid with a bright toadstool cap tosses glittering spores into the air.",
            "FARIA: (Customers! I take stories, favours, and, since you're surfacers, money.)",
            "FARIA: (Make me laugh and I'll knock a bit off.)"],
    myr_threads: ["Thin silver threads hang from the ceiling into the earth, trembling.",
                  "Through them, very faintly, other trees on other worlds are humming."],
    hyphora_roots: [{ if: { flag: :lake_clean }, lines: ["Hyphora's roots pulse slow and strong through the chamber, green-gold.",
                                                          "Somewhere above, leaves you'll never see turn toward a sun."] },
                    ["The roots of a young tree pulse faintly through the walls.",
                     "They're a different colour from the World Tree's. Smaller. Younger. Sick."]],
    barricade: ["The north-east tunnel runs on toward the hag's old lair under Dougan's Hole.",
                "Duergar ironwork walls it off, riveted into the root. Smoke leaks through the seams.",
                "Behind it, a sound like hammers. Someone has scratched a note in Rootwarden script:",
                "THE ROOTWARD BARRICADE. NOT YET."],
    mycolith_gone: ["The lake is clear. Pale myconid sprouts bumble along the shore, poking at the water."]
  )

  # Party chat in these places. Each Herald talks the way the Voices tab says;
  # a few lines change when their partner in a pair is travelling with you.
  PARTY_CHAT[:alberica].merge!(
    fields: ["Flowers punching up through the snow. The Dale's arguing with itself, darling.",
             "I hope it never makes its mind up. Arguing's how you know something's alive."],
    guild_dig: ["That amber fuel hums like a crowd. A choir that's forgotten the words.",
                "I've sung to rooms like that. You don't get your voice back. Don't touch it, sugar."],
    canopy: [{ if: { with: :alerion, flag: :twins_met }, lines: ["Pretty boy's ring went white the second Frostina looked at him.",
                                                                 "I've never been jealous of a lizard before. It's a whole new feeling."] },
             ["The leaves up here hum when the wind moves. It's nearly a chord.",
              "I keep trying to finish it. It keeps not letting me."]],
    library: ["My handwriting. On a leaf. Four hundred years old.",
              "I don't know whether to cry or correct the spelling. I'll do both. Later. With a drink."],
    college: [{ if: { with: :reptin }, lines: ["Copies of our things in a case. Reptin's already charmed the curator.",
                                               "I'm checking my neck for the pendant anyway. ...Still gone. Of course it is."] },
              ["Copies of our things, in a case. The real pendant cracked in Lonelywood, of course.",
               "I'm checking my neck anyway. Habit."]],
    crypt: ["Sap like glass. They're not dead, are they. They're waiting.",
            "...Hush. I just don't like being the loudest thing in a room. Is all."],
    undercanopy: [{ if: { with: :wyn }, lines: ["Wyn's home. Look at them, sweetheart, they're glowing. Literally. Spores.",
                                                "I'd marry the whole cave just to see that face again."] },
                  ["They talk inside your head down here. Mine's crowded enough already.", "I'm making room. Shove up, everyone."]]
  )
  PARTY_CHAT[:reptin].merge!(
    fields: ["The Wall. Time's frozen behind it. I can smell snow from four hundred years ago.",
             "Lovely. Nostalgic. I'd like to go no closer, thank you."],
    guild_dig: ["They cut into the tree. You don't cut into something alive. You ask it.",
                "(under his breath) Diplomacy. Even with trees. Especially with trees."],
    canopy: ["Two dragons. Ours. Grown. I keep thinking of an egg in a coat,",
             "and a name said like a promise. ...I'm fine. The pollen up here is criminal."],
    library: ["Every word ever spoken here is kept.", "I've said some things I'd like the tree to forget. Diplomatically."],
    college: [{ if: { with: :alberica }, lines: ["A licence. To graft. In my day you fell into a chasm and hoped.",
                                                 "Alberica asked the Professor if grafting works on people. He's still blushing."] },
              ["A licence. To graft. In my day you just fell into a chasm and hoped."]],
    crypt: ["'Rage is only winter longing for spring.' Somebody carved that for me.", "Somebody I've never met. That's either sweet or deeply unsettling."],
    undercanopy: [{ if: { with: :wyn }, lines: ["There's a second tree down here. Younger. Sick.",
                                                "Take your time, Wyn. The roots aren't going anywhere. Well. Mostly."] },
                  ["There's a second tree down here. Younger. Sick.", "The wolf in me wants to guard it. So do I. For once we agree."]]
  )
  PARTY_CHAT[:alerion].merge!(
    fields: ["The Still Ones. Caught mid-step.", "I was like that, once. Somebody let me finish."],
    guild_dig: ["Prototype 3 has her letter on it.", "She made a child out of clay and left it here to pray. No."],
    canopy: [{ if: { flag: :twins_met }, lines: ["Frostina looked at me like she'd been waiting.", "My ring's colder than it's ever been. It doesn't hurt. That's new."] },
             ["The orb keeps pulsing. Two beats. Out of step.", "Something up there is deciding about us."]],
    library: ["Naerth's ledger. Of course Avarice was in it.", "She was in everything."],
    college: ["The Professor looks at us like equations.", "I've been looked at like that before. By her."],
    crypt: ["The dead here are at peace. My ring's quiet.", "That almost never happens. I don't like it."],
    undercanopy: [{ if: { with: :wyn }, lines: ["Wyn doesn't talk much down here. Neither do I.", "It's the best conversation I've had in four hundred years."] },
                  ["Something in that lake is looking up at us.", "I'd like to look back first."]]
  )
  PARTY_CHAT[:shade].merge!(
    fields: ["Snow and flowers. Shimmer would've picked one of each and called it a bouquet."],
    guild_dig: ["Two saboteurs, one fuse each. Amateurs. I'm almost offended."],
    canopy: [{ if: { flag: :twins_met }, lines: ["Frostina tilted her head at me. The way Shimmer did.", "I'm fine. I'm fine. Keep walking."] },
             ["The shard up there. It feels like a seat kept at a table.", "I don't know whose. I'd like it to stop looking at me."]],
    library: ["A library that remembers everything. I've robbed a few of those.", "This one would remember. Hands in pockets, everyone."],
    college: ["Grafting. Two Pokémon in one cocoon, by consent.", "...Shimmer would've had opinions about that. Loud ones."],
    crypt: ["Quiet places make the dagger whisper. It's not whispering.", "That's worse."],
    undercanopy: ["Mushroom people. Telepathic mushroom people.", "I'm thinking very loudly about nothing. Nothing. Nothing at all."]
  )
  PARTY_CHAT[:meat_meat] ||= {}
  PARTY_CHAT[:meat_meat].merge!(
    fields: ["Pretty flowers. Meat Meat is not eating them.", "Meat Meat is thinking about it."],
    guild_dig: ["Little clay one is praying to tree. Little clay one has an A. Meat Meat also has an A.",
                "Meat Meat does not pray. Meat Meat bites."],
    rootspire: ["Big tree! Big, big tree. Meat Meat would climb it, but it is somebody's house.",
                "Coffee in market: six out of ten. Strong. Sad. Meat Meat drank three anyway."],
    hearth: [{ if: { with: :alberica }, lines: ["Free snacks. Meat Meat is staying here forever. Tell the dragons.",
                                                "Alberica drinks sad juice. Meat Meat drinks war. Hellen's coffee: eight out of ten."] },
             ["Free snacks. Meat Meat is staying here forever. Tell the dragons.", "Hellen's coffee: eight out of ten. Hellen is a good person."]],
    council: ["Statue of Meat Meat has snacks. Meat Meat respects this city very much."],
    root_tier: ["Fish smell. Secret smell. Meat Meat likes both."],
    shrine: ["Cold lady statue. Meat Meat does not like her eyes.", "Somebody keeps making them sharp. Meat Meat will find somebody."],
    heartroot: ["Tree's tummy. It is rumbling.", "Meat Meat would also rumble, with sap in tummy. Meat Meat has coffee in tummy. Better."],
    canopy: [{ if: { with: :alerion, flag: :twins_met }, lines: ["RAZZY! Razzy is big now! Razzy is SO big! Meat Meat is not crying. That is sap.",
                                                                 "Ice Prince is crying too. Meat Meat poked him. He said 'no.' He is crying."] },
             { if: { flag: :twins_met }, lines: ["RAZZY! Razzy is big now! Razzy is SO big!", "Meat Meat is not crying. That is sap."] },
             ["Something big is up in the sky. Meat Meat can smell it. It smells like Razzy.", "Meat Meat is not getting hopes up. Meat Meat's hopes are up."]],
    library: ["Meat Meat cannot read the leaves. Leaves can read Meat Meat, though. Rude."],
    college: ["Professor has ink on his nose. Meat Meat will not tell him.", "It is funnier. Coffee here: two out of ten. It is tea. It is lying."],
    crypt: ["Sleepy wardens. Meat Meat whispers.", "Wardens do not mind whispers. Meat Meat checked."],
    undercanopy: [{ if: { with: :wyn }, lines: ["Mushrooms are talking in Meat Meat's head! They are very polite!",
                                                "Anyone touches mushroom person's mushrooms, Meat Meat bites. Fondly. Then not fondly."] },
                  ["Mushrooms are talking in Meat Meat's head! They are very polite!", "Meat Meat is talking back very polite too!"]]
  )
  # Wyn travels with you from festival night (SC 6.09).
  PARTY_CHAT[:wyn] ||= {}
  PARTY_CHAT[:wyn].merge!(
    fields: ["The snow-flowers... they're called rimebells. They only open for people who walk slowly.",
             "...Um. So. If we could walk slowly. Only if that's alright."],
    guild_dig: ["The amber's wrong. It's... sap that's been made to scream.", "Sorry. I'll be quiet. I just... can't stand it."],
    canopy: [{ if: { with: :alberica }, lines: ["It's very high. I'm fine. Sableye's fine. Sableye has his eyes shut.",
                                                "Alberica's holding my hand. She says it's for her nerves. ...She hasn't got nerves."] },
             ["It's very high. I'm fine. Sableye's fine.", "Sableye has his eyes shut. That's how he's fine."]],
    library: ["The leaves keep everything we say.", "I've... I've been trying to say only kind things near them. It's harder than it sounds."],
    college: ["Grafting's beautiful, when they want it. Two that love each other, made into one.",
              "...Oh. I said that out loud. Please don't tell Alberica I said that."],
    crypt: ["They're not afraid, the Wardens. You can feel it in the sap.", "I'd like to be that calm. Someday. Not today."],
    undercanopy: [{ if: { with: :meat_meat }, lines: ["Home. ...Meat Meat's guarding the spore beds. Nobody asked her to.",
                                                      "I made her a second cup. She's guarding them harder now."] },
                  ["Home. It smells right again. Damp and gold.", "Yarro waved at me. I'm... I'm going to wave back. There. I did it."]]
  )

  module_function

  # A line from a companion, or your own thought if you're that Herald; nothing
  # if they aren't here.
  def with_or_is?(key) = herald?(key) || companions.include?(key)

  def cl(key, text)
    return nil if !with_or_is?(key)
    as(key, text)
  end

  def sayc(lines, event_id = nil)
    say(Array(lines).flatten.compact, event_id)
  end

  def badges_held
    ($Trainer.badge_count rescue 0) || 0
  end

  #-----------------------------------------------------------------------------
  # Razzy hatches in the Verdant Reversal ("only in the Reversal may the wheel
  # turn forward again"): reborn as Razzilith, the green wyrmling.
  #-----------------------------------------------------------------------------
  def razzy_hatch
    return if flag?(:razzy_hatched) || !flag?(:razzy_egg)
    set_flag(:razzy_hatched)
    pbSEPlay("Saint7") rescue nil
    sayc(["Under your coat, the egg moves.",
          "It's been warm since the frost-light chasm, since a name was spoken over it.",
          "Now it's hot. And it's cracking.",
          "Shell falls away in green flakes. A wyrmling unfolds in your arms, no bigger than a cat.",
          "Scales of iridescent moss, flecked with silver. Bright, knowing eyes.",
          "It sneezes. A puff of spores drifts out, and where it lands on the ice, moss grows."])
    if with_or_is?(:meat_meat)
      speak(:meat_meat, "Razzy. RAZZY. Meat Meat is here. Meat Meat heard you fall. Meat Meat came.",
            "(very quiet) ...Hi, Razzy. Meat Meat came. Meat Meat promised.")
    end
    sayc([cl(:reptin, "Easy. Easy, little one. You know my voice. I gave you my blood once."),
          cl(:reptin, "You can have it again if you need it. ...Don't tell Meat Meat I offered."),
          (with_or_is?(:meat_meat) && with_or_is?(:reptin) ? cl(:meat_meat, "Meat Meat heard. Meat Meat will allow it. Once.") : nil),
          "Razzy looks at each of you. Then he laughs, like a meadow. It shouldn't fit in a chasm.",
          "It does.",
          "He spreads his wings, wet and new, and before anyone can catch him he's gone.",
          "Up, into the light pouring from the broken mirrors. After the green."])
  end

  # For saves that crossed the Reversal before Razzy hatched there.
  def razzy_hatch_memory
    return if flag?(:razzy_hatched) || !flag?(:razzy_egg)
    set_flag(:razzy_hatched)
    sayc(["Your coat is light. Too light. The egg is gone.",
          "And you remember, suddenly, as if a page turned back.",
          "In the Heart of the Chasm, when time came loose, the egg cracked in your arms.",
          "A green wyrmling, moss and silver, sneezing spores that grew moss on the ice. Razzy.",
          "He laughed, and flew up into the light, after the green.",
          cl(:meat_meat, "Razzy hatched! Meat Meat remembers now! Meat Meat said hello!"),
          cl(:meat_meat, "Razzy flew away. Very rude. Meat Meat will bite him."),
          cl(:reptin, "Four hundred years. If he flew forward with us, he's out there. Somewhere above.")])
  end

  #-----------------------------------------------------------------------------
  # The root-lift
  #-----------------------------------------------------------------------------
  def root_lift(event_id = nil)
    talk(:lift_keeper, event_id)
    return if !pbConfirmMessage(_INTL("Ride the root-lift up to the Canopy-Tier?"))
    say(["The lift is a basket of woven root on a vine as thick as a mast.",
         "It rises through the trunk, past windows full of lanterns, into green light."])
    if !flag?(:canopy_lift_banter)
      set_flag(:canopy_lift_banter)
      lines = []
      if with_or_is?(:alberica) && with_or_is?(:alerion)
        lines << ask_as(:alberica, "Pretty boy, you're gripping the rail. Afraid of heights?", "...Afraid of heights?")
        lines << as(:alerion, "No. I'm afraid of falling. Different thing.")
      end
      lines << cl(:meat_meat, "Meat Meat is not afraid. Meat Meat holds Reptin's sleeve for Reptin's sake.") if with_or_is?(:reptin)
      lines << cl(:reptin, "Very generous of you. Truly. My sleeve and I are touched.") if with_or_is?(:meat_meat)
      lines << cl(:wyn, "...Sableye likes it. He's never been this far from the ground. He keeps looking down.")
      sayc(lines.compact) if lines.compact.size >= 2
    end
    transfer(*CANOPY_ARRIVAL)
  end

  def root_lift_down(event_id = nil)
    return if !pbConfirmMessage(_INTL("Ride the root-lift back down to the Trunk-Tier?"))
    transfer(*LIFT_LANDING)
  end

  #-----------------------------------------------------------------------------
  # Pip, the pocket tailor
  #-----------------------------------------------------------------------------
  PIP_QUESTIONS = [
    "Isn't a pocket the greatest thing anyone ever invented?",
    "Wouldn't the world be kinder if every coat had at least six pockets?",
    "Be honest: a pocket inside a pocket. Genius, right?",
    "Should Poké Balls have little pockets on them? I think they should.",
    "Pockets are the most important part of any outfit. Agree?"
  ]
  PIP_UPGRADES = [
    # [name, limit, badges needed, price]
    ["Pip's Satchel", 30, 2, 3000],
    ["Pip's Rucksack", 50, 4, 8000]
  ]

  def pip(event_id = nil)
    if !flag?(:met_pip)
      set_flag(:met_pip)
      say(["A tiny tailor sits buried in thread at a stall made mostly of pockets.",
           "A Pokémon in a silk cocoon spins beside her.",
           "PIP: Only twenty things to a pocket? Oh, you poor thing. Sit. Let me look at your seams.",
           "PIP: Pip! I sew bags. Bigger bags. Bags with more room than they've any right to.",
           "PIP: Bring me badges and money, and I'll make your bag better."], event_id)
      sayc([cl(:alberica, "Darling, I'd let you look at my seams any day of the week."),
            (with_or_is?(:alberica) ? cl(:reptin, "What my colleague means is: thank you, Pip. We'd be delighted.") : nil)].compact)
    else
      say(["PIP: A pocket is just a little room you carry with you. A room! For your hands!"], event_id)
    end
    limit = state[:bag_limit] || BAG_START_LIMIT
    PIP_UPGRADES.each do |name, new_limit, need, price|
      next if limit < 0 || limit >= new_limit
      if badges_held < need
        say(["PIP: Come back with #{need} badges, and I'll make you #{name}.",
             "PIP: #{new_limit} kinds of thing in every pocket!"])
        break
      end
      if pbConfirmMessage(_INTL("Buy {1} ({2} kinds of item per pocket) for ${3}?", name, new_limit, price))
        if $Trainer.money < price
          say(["PIP: Oh. You can't afford it. That's alright. I'll keep it folded for you."])
        else
          $Trainer.money -= price
          state[:bag_limit] = new_limit
          state[:pip_upgrades] = (state[:pip_upgrades] || 0) + 1
          pbMessage(_INTL("\\me[Item get]Pip sewed in {1}! Each pocket now holds {2} kinds of item.", name, new_limit))
          say([new_limit >= 50 ? "PIP: Fifty. Fifty pockets. I might cry. I'm going to cry." : "PIP: Thirty! Feel that? That's the feeling of being prepared."])
          limit = new_limit
        end
      end
      break
    end
    pip_question
  end

  def pip_question
    asked = state[:pip_yes] || 0
    return if asked >= PIP_QUESTIONS.size
    unlocked = [1 + (state[:pip_upgrades] || 0) + [badges_held - 3, 0].max, PIP_QUESTIONS.size].min
    return if asked >= unlocked
    if pbConfirmMessage(_INTL("PIP: {1}", PIP_QUESTIONS[asked]))
      state[:pip_yes] = asked + 1
      if asked + 1 >= PIP_QUESTIONS.size
        set_flag(:pocket_person)
        say(["PIP: You're one of us now. A Pocket Person. I'm sewing you something.",
             "PIP: It has... so many pockets. It isn't finished. Pockets take time."])
      else
        say(["PIP: I KNEW it. I knew you were a pocket person."])
      end
    else
      say(["PIP: ...I'll pretend I didn't hear that."])
    end
  end

  #-----------------------------------------------------------------------------
  # Shops on the Trunk-Tier and Canopy-Tier
  #-----------------------------------------------------------------------------
  def nivva(event_id = nil)
    talk(:nivva, event_id)
    mart(:apothecary, event_id)
  end

  def aerie_mart(event_id = nil)
    talk(:aerie_merchant, event_id)
    mart(:aerie, event_id)
  end

  #-----------------------------------------------------------------------------
  # Tamsin, Hellen's kid (the New Journey rival): the starter that beats yours
  #-----------------------------------------------------------------------------
  def tamsin(event_id = nil)
    return say(lines_for(:tamsin_after), event_id) if flag?(:beat_tamsin)
    Stage.theme(:tamsin)                     # the rival squares up (notes 06 E9)
    if journey?
      say(["TAMSIN: #{player_display_name}! Best of three. You owe me two more.",
           "TAMSIN: I don't care if it was months for you. For me it was an HOUR.",
           "TAMSIN: And you came back with the wall people. And your Pokémon's HUGE."], event_id)
      sayc([cl(:alberica, "Oh, I love this one. Go on, give your friend a proper fight.")])
      say(["TAMSIN: We got our first Pokémon the SAME MORNING. So you're battling me. Right now.",
           "TAMSIN: Before I have to think about the sixth figure."], event_id)
      sayc([cl(:reptin, "Be gentle. Or don't. They'll never forgive you for being gentle.")].compact)
    else
      say(["A kid with Hellen's chin and a Poké Ball in each hand blocks the Hearth's door.",
           "TAMSIN: Tamsin Brightrun! Mum's been talking about you since you walked in.",
           "TAMSIN: All of you. She's never like this. If the Heralds are real, I want to see.",
           "TAMSIN: Battle me!"], event_id)
      sayc([cl(:meat_meat, "Small one has big eyes. Meat Meat likes small one. Meat Meat will still win."),
            cl(:alerion, "They're holding them upside down."),
            (with_or_is?(:alerion) && with_or_is?(:alberica) ? cl(:alberica, "Don't tell them, pretty boy. Let them find out. That's how you learn.") : nil)].compact)
    end
    type = case state[:starter]
           when :B330H152 then :FT_TAMSIN_G
           when :WICKIT   then :FT_TAMSIN_F
           else :FT_TAMSIN_I
           end
    won = pbTrainerBattle(type, "Tamsin", nil, false, 0)
    ($game_map.autoplay rescue nil)
    return if !won
    set_flag(:beat_tamsin)
    add_counter(:trainers_beaten)
    say(["TAMSIN: ...Okay. You're real. Everyone's real. Best and worst day ever."])
    if flag?(:badge_hearth)
      say(["TAMSIN: And you already beat Mum. In her own cellar. I'll never hear the end of it."])
    else
      say(["TAMSIN: Mum keeps the cellar for the Hearth's battles. She'll want to test you herself.",
           "TAMSIN: She tests everyone she likes. It's horrible."])
    end
  end

  #-----------------------------------------------------------------------------
  # Gym 4: Hellen Brightrun, in the Hearth's root-cellar
  #-----------------------------------------------------------------------------
  def leader_hellen(event_id = nil)
    if flag?(:badge_hearth)
      return say(["HELLEN: You've got my seal, love. Go on. And come back for supper. I'm not asking."], event_id)
    end
    sayc(["Hellen stands in the warm dark among the roots, sleeves rolled up, like at closing.",
          "HELLEN: Sit down first. Eat that. ...Good. Four hundred years I've told your stories.",
          "HELLEN: Show me I wasn't lying.",
          cl(:shade, "Look at her stance. That's not a barkeep. That's a bouncer."),
          (with_or_is?(:shade) ? cl(:alberica, "Shade, darling, she's both. The best ones always are.") : nil),
          cl(:meat_meat, "Meat Meat ate the bread. Meat Meat will now fight the bread lady. Respectfully.")].compact, event_id)
    trainer_intro(:hellen_gym, event_id) rescue nil
    return if !pbTrainerBattle(:FT_HEARTH_LEADER, "Hellen", nil, false, 0)
    $Trainer.badges[3] = true
    set_flag(:badge_hearth)
    ($game_switches[SW_HEARTH_BADGE] = true; $game_map.need_refresh = true if $game_map) if $game_switches
    add_counter(:story_beats)
    say(["HELLEN: The Hearthstone Seal. A little cup, see? You always come back to the Hearth."])
    pbMessage(_INTL("\\me[Badge get]{1} received the Hearthstone Seal!", $Trainer.name))
    give(:TM42)
    say(["HELLEN: And you never pay for a drink here again.",
         "HELLEN: That TM's Facade. Hits harder when you're hurt. Like most of the people in my bar.",
         "Upstairs, the regulars are stamping on the floorboards.",
         "HELLEN: Go and see Pip in the Bazaar. Four badges? She'll want to make you a rucksack.",
         "HELLEN: She'll cry. Let her."])
    sayc([cl(:alberica, "Never pay for a drink again. Hellen, I'm moving in."),
          (with_or_is?(:alberica) ? "HELLEN: Then you're washing glasses, love." : nil)].compact)
    state[:goal] = festival_ready? ? "The festival's last night. Rest at the Hearth." : state[:goal]
  end

  #-----------------------------------------------------------------------------
  # The College of Auroral Arts: Professor Wynsnow and Grafting
  #-----------------------------------------------------------------------------
  def wynsnow(event_id = nil)
    if flag?(:grafting)
      if flag?(:lecture_done)
        return if respond_to?(:wynsnow_chronal) && wynsnow_chronal(event_id)   # the Chronal Debt (048)
        return if respond_to?(:research_sigils) && research_sigils(event_id)   # researching the sigils (048)
        return say(["WYNSNOW: Remember: no cocoon holds a stranger.",
                    "WYNSNOW: Graft what loves each other, and the tree remembers both."], event_id)
      end
      return lecture_in_blue_fire(event_id)
    end
    if journey?
      say(["WYNSNOW: You fell into a lantern and came back with legends. Hold still.",
           "He measures you with a brass rule. Then with a candle. Then with a look.",
           "WYNSNOW: Your shadow is a quarter-second late. Remarkable. Horrifying."], event_id)
    else
      say(["A half-elf in an ink-stained coat looks up from three books at once, and drops them all.",
           "WYNSNOW: The Heralds. In my lab. Hold still. I've waited my whole life to measure you."], event_id)
    end
    # (dialogue 06 §3.5: Alerion's "No." answers something, in every mode)
    sayc([with_or_is?(:alerion) ? "WYNSNOW: (the rule swinging to #{herald?(:alerion) ? 'you' : 'Alerion'}) Two degrees colder than a corpse. Hold still." : nil,
          cl(:alerion, "No."),
          (with_or_is?(:alerion) ? cl(:reptin, "He means he'd rather not. Measure me instead, Professor. I'm very measurable.") : nil),
          "WYNSNOW: You'll want this. A licence. Grafting: two Pokémon merged in a cocoon of sap.",
          "WYNSNOW: The old way. One gives itself to the other and comes out part of it.",
          "WYNSNOW: Splicers fuse two for a while. A graft is for keeps.",
          "He holds up a jar. Inside, a Natu and a Sunkern sleep in one cocoon of sap.",
          "WYNSNOW: The rules are the lore. No cocoon holds a stranger: they must be close in level.",
          "WYNSNOW: And seedlings remember: eggs keep their parent's growth.",
          "WYNSNOW: Never into a person. That's Joining, and it's forbidden.",
          ask_cl(:meat_meat, "...Why forbidden?", "...Why?"),
          "WYNSNOW: Because the last person who tried it made monsters. A pale woman. Long ago.",
          cl(:alerion, "(very quietly) Naerth's pale lady."),
          herald?(:meat_meat) ? "(You don't say anything. Your hands have gone cold.)" : (with_or_is?(:meat_meat) ? "Meat Meat doesn't say anything else. She puts her hands in her pockets." : nil),
          # (dialogue 06 §4: the subtext stays subtext)
          (with_or_is?(:meat_meat) && with_or_is?(:alberica) && !herald?(:meat_meat) ?
            (herald?(:alberica) ? "You put a hand on Meat Meat's head, and say nothing." : "Alberica puts a hand on Meat Meat's head, and says nothing.") : nil)].compact)
    first_graft_gift(event_id)               # the jar hatches; the graft is yours (051, owner 11 Nov)
    set_flag(:grafting_licence)
    set_flag(:grafting)
    add_counter(:story_beats)
    pbMessage(_INTL("\\me[Item get]{1} received a Grafting licence! The Cocoon Chamber is open in every PC.", $Trainer.name))
    say([flag?(:jar_graft) ? "WYNSNOW: Next time, do your own at any PC. Choose the one that stays first, then the one that gives itself." : nil,
         "WYNSNOW: Now, excuse me. I'm about to lecture on the Reversal.",
         "WYNSNOW: Come and watch, if you like. It's about you."].compact)
  end

  def lecture_in_blue_fire(event_id = nil)
    say(["WYNSNOW: Today: the Verdant Reversal, and the time it left loose.",
         "WYNSNOW: Observe! A small chronal aperture. Perfectly contained, perfectly safe-"], event_id)
    wyn_ev = stage_event(event_id)
    ($game_screen.start_flash(Color.new(140, 190, 255, 220), 16)) rescue nil
    pbSEPlay("Ice8") rescue nil
    Stage.fx("E-06", stage_spot(wyn_ev, 0, -1).then { |x, y| [x, y - 1] }, frames: 10, oy: 16) rescue nil
    say(["The air in front of him splits like ice. Blue fire pours through.",
         "Cold comes with it, four hundred years old: snow, Targos harbour, and something walking.",
         "A wight steps out of the frozen past, wreathed in blue flame. It eyes the class.",
         "WYNSNOW: -less contained than expected! Heralds! Practical demonstration! Please!"], event_id)
    sayc([cl(:alberica, "Oh, he's dreadful. I love him. Somebody hit the skeleton."),
          (with_or_is?(:alberica) ? cl(:alerion, "On it.") : nil)].compact)
    return if !boss_battle(named_mon(:B124H94, 40, "Temporal Wight"))
    set_flag(:lecture_done)
    add_counter(:story_beats)
    say(["The wight comes apart into snow. The snow falls upward, back through the crack.",
         "The crack seals with a sound like a page turning.",
         "WYNSNOW: ...And that concludes the lecture. Class dismissed.",
         "WYNSNOW: Somebody open a window. Somebody close that window.",
         "WYNSNOW: Thank you. Truly. The prize for the best practical is... very clearly you."])
    give(:LUCKYEGG)
    sayc([cl(:meat_meat, "Meat Meat also did practical. Meat Meat bit the skeleton."),
          (with_or_is?(:meat_meat) ? cl(:reptin, "And it was a beautiful bite. We'll put it in the minutes.") : nil)].compact)
  end

  #-----------------------------------------------------------------------------
  # The Shrine of the Twinned Dragons: Razzilith and Frostina come down
  #-----------------------------------------------------------------------------
  # The orb at the Shrine of the Twinned Dragons. The twins came down in the
  # market (SC 6.03); here Lumin reads what the orb shows each Herald.
  def twin_orb(event_id = nil)
    if !flag?(:twins_met)
      return sayc(["Two spires twist together above you, one jade, one white crystal.",
                   "Two dragons, carved circling one another. Between them hangs an orb of shifting light.",
                   "It pulses like a heartbeat. At each pulse, worshippers sing a line of the Cycle Canticle.",
                   "Softly, the way you'd sing to something asleep: winter, spring, summer, autumn, and round.",
                   "LUMIN: Lumin Weavemoss, of the Circle. The orb's been green-white since you arrived.",
                   "LUMIN: It glows when either wyrm stirs. Tonight it hasn't stopped.",
                   "LUMIN: They know you're here. They're deciding."], event_id)
    end
    if flag?(:orb_visions)
      return say(["The orb between the spires pulses green, then white, then green.",
                  "Two heartbeats, out of step. Then in step.",
                  "The worshippers at its foot sing the Canticle with it, a verse to each pulse.",
                  "High above, two shapes circle the crown of the World Tree."], event_id)
    end
    return if respond_to?(:orb_halo_scene) && !orb_halo_scene   # the Halo splinter at the orb first (048)
    sayc(["LUMIN: (still shaking) You came up just in time. The dragons have been waiting up here for you.",
          "LUMIN: Put your hands to the orb. It shows the guides what they're guiding.",
          "The orb pulses: two heartbeats, out of step.",
          "LUMIN: Two roads for each of you. Not what will be. What might.",
          "LUMIN: That's the old teaching. I've never once seen it work."], event_id)
    pbSEPlay("Saint7") rescue nil
    bloom_guard_visions
    sayc(["The light lets you go.",
          "LUMIN: ...It worked. Oh, it worked. Dragon Warriors. Partners. Never masters.",
          "LUMIN: Two roads each. The wyrms will follow whichever one you walk.",
          cl(:shade, "(very quietly) Her eyes. In the street, when she hummed. I knew."),
          cl(:meat_meat, "Meat Meat saw a meadow. Razzy was in it. Meat Meat is keeping that one."),
          cl(:alerion, "I saw a forest with no dawn. ...It was quiet. I liked it. Don't tell anyone."),
          (with_or_is?(:alerion) && with_or_is?(:alberica) ? cl(:alberica, "Everyone heard you, pretty boy. We're all going to tell everyone.") : nil),
          "LUMIN: Take this: a moon-charm of the Circle, for whoever woke the wyrms."].compact)
    give(:MOONSTONE)
    set_flag(:orb_visions)
    set_flag(:halo_orb_cleared)
    add_counter(:story_beats)
  end

  def lumin(event_id = nil)
    return twin_orb(event_id) if !flag?(:orb_visions)
    return if respond_to?(:lumin_rite) && lumin_rite(event_id)      # Glimmer's seven-day rite (048)
    return if respond_to?(:glimmer_envoy) && glimmer_envoy(event_id) # Glimmer's Trial: the celestial envoy (048_H)
    talk(:wennen_scholar, event_id)
  end

  # The Bloom Guard visions (from the campaign's dream visions), for each Herald
  # here: the place, the memory it calls up, and the two fates it shows.
  # Scene pass (notes 06 E8, E10, F9): one vision at a time, under the vision
  # overlay (O-03), and the player picks whose road to look down next.
  def bloom_guard_visions
    say(["The orb's light washes over you. For a moment, each of you is somewhere else.",
         "Afterwards, Lumin will call it by its old name: the Dreaming of the Bloom Guard."])
    left = %i[alerion meat_meat alberica glimmer reptin].select do |k|
      k == :glimmer ? (with_or_is?(:glimmer) || with_or_is?(:shade)) : with_or_is?(k)
    end
    Stage.overlay("O-03", fade: 20) rescue nil
    first = true
    until left.empty?
      names = left.map do |k|
        mine = k == :glimmer ? (herald?(:glimmer) || herald?(:shade)) : herald?(k)
        next _INTL("Your own") if mine
        k == :glimmer ? (with_or_is?(:glimmer) ? _INTL("Glimmer's") : _INTL("Shade's")) : _INTL("{1}'s", COMPANION_NAMES[k].to_s.split.map(&:capitalize).join(" "))
      end
      opts = names + (first ? [] : [_INTL("Let go of the orb")])
      c = pbMessage(_INTL(first ? "Whose road do you look down first?" : "Whose road next?"), opts, first ? 0 : opts.size - 1)
      break if c.nil? || c < 0 || c >= left.size
      key = left.delete_at(c)
      send(:"bloom_vision_#{key}")
      first = false
    end
    Stage.overlay_off("O-03", fade: 20) rescue nil
    set_flag(:bloom_guard_dreamed)
  end

  def bloom_vision_alerion
    me = herald?(:alerion)
    sayc([me ? "(A black forest under a sky that never knew dawn. Two pale moons: Frostina's eyes.)" :
               "Alerion stands in a black forest under a sky that never knew dawn.",
          me ? nil : "Between the trunks, two pale moons: Frostina's eyes.",
          "\"Guardian of the Dark Half. Keeper of stillness, and the endings that turn the wheel.\"",
          "Shimmer, her breath silver in the night, looking at a man with a shield. It's Alerion.",
          me ? "(You were Shimmer's shield, once, a whole life ago. You know her eyes. They're Frostina's.)" :
               "In another life, long ago, he guarded her. Now Frostina has her eyes, and something of her soul.",
          "Two roads open through the black trees.",
          "On one: a sentinel at the northern ruins, a sword in the snow, keeping watch on a silence.",
          "On the other: a shape under great white wings, and Frostina crying out a name he's forgotten.",
          "Both roads are his."].compact)
  end

  def bloom_vision_meat_meat
    me = herald?(:meat_meat)
    sayc([me ? "(The ice cracks and a meadow breaks through. Razzilith lies coiled in the wildflowers.)" :
               "Meat Meat stands in a meadow that's broken through the ice. Razzilith lies in the flowers.",
          "\"Guardian of the Light Half. Keeper of renewal and song. Without you, the wheel rots.\"",
          me ? "(You remember feeding him. Acorns, one at a time. Flowers, which he ate, then sneezed.)" :
               "She's feeding him. Acorns, one at a time. Flowers, which he eats, and then sneezes.",
          me ? "(The first time he laughed. You taught him that.)" : "He laughs. She taught him that.",
          "Two futures, side by side like reflections in a pond.",
          "In one: the earth thaws as far as the eye can see, and his roar cracks the mountains open.",
          "In the other: she cradles his muzzle while the meadow burns. The flames are his."])
  end

  def bloom_vision_alberica
    me = herald?(:alberica)
    sayc(["The Vault of the North, half buried in rime, half bathed in gold.",
          "Faces press against the inside of it, crying to be remembered.",
          "\"Keeper of Memory. Your key is the life you have carried. Hold it all.\"",
          "\"Without memory, the wheel does not turn.\"",
          me ? "(On your chest, a rune you've never seen burns cold, brightest when you face the vault.)" :
               "Where her pendant used to hang, a rune burns cold. Brightest when she faces the vault.",
          me ? "(And you're in Bryn Shander's square again, pouring warmth into a frightened crowd.)" :
               "And she's in Bryn Shander's square again, pouring warmth into a frightened crowd.",
          "Two paths, and the snow falls on both.",
          "On one: her hand turns a key, and the whole Dale is locked in winter forever. Safe. Still.",
          "On the other: she sings the tender and the terrible both, and the vault shatters.",
          "Every face inside it remembers its name.",
          # (context 06 §6, 15 §6: Herald Alberica notices; the price stays unsaid)
          me ? as(:alberica, "A key. A vault. The family's bargain had a key in it. Nobody said what for.") : nil].compact)
  end

  def bloom_vision_glimmer
    me = herald?(:glimmer) || herald?(:shade)
    who = with_or_is?(:glimmer) ? "Glimmer" : "Shade"
    sayc(["A plain of stars like embers. A unicorn strides out of it, mane aflame: Brightmane.",
          "Where her hooves fall, the frost shatters, and flowers spring up through the cracks.",
          "\"Sparkbearer. My light is yours.\"",
          "\"Shimmer gave the ice of her heart so others might live. Her torch is yours to carry.\"",
          "Shimmer's last breath. The rose. Her heart of ice, sung into an egg, waiting to wake.",
          me ? "(You weep. In the tears you see fire. It's been burning since #{flag?(:glimmer_joined) ? 'the mirror' : 'the Glade'}.)" :
               "#{who} weeps, and in the tears there is fire. It's been burning since #{flag?(:glimmer_joined) ? 'the mirror' : 'the Glade'}.",
          "Two flames.",
          "In one: the spark leaps from the torch to the two dragons, and they blaze with life.",
          "In the other: despair closes over the torch like a hand, and the flame gutters to ash."])
  end

  def bloom_vision_reptin
    me = herald?(:reptin)
    sayc(["A graveyard, where roots tear through the soil and flowers bloom blood-red against frost.",
          "Wolves pace at its edge, neither cruel nor kind.",
          "\"Warden of Life and Death. Without either, there is only stillness: the enemy.\"",
          me ? "(The old wolf-bite in your hand sears: fire beneath snow. You remember the starving pack.)" :
               "Reptin's old wolf-bite sears, fire beneath snow. He remembers the starving pack.",
          "He fed them out of mercy, and one of them gave him the curse. He carries both.",
          "Two visions, one on each side of the graveyard wall.",
          "In one: he walks between the living and the dying with a lantern, and neither is afraid.",
          "In the other: the beast tears free of him, and somewhere in the dark two dragons cower.",
          "His job isn't to pick one. It's to keep the wheel turning between them."])
  end

  #-----------------------------------------------------------------------------
  # The Wind-Glass Library: Alberica's sub-vault, and the Cycle Canticle
  #-----------------------------------------------------------------------------
  def subvault(event_id = nil)
    if flag?(:key_found)
      return say(["The instrument case lies open and empty. Its lock of two notes still hums, faintly."], event_id)
    end
    say(["Behind a curtain of crystal leaves: a small instrument case.",
         "Its lock is two music notes, interlocked."], event_id)
    if !with_or_is?(:alberica)
      return say(["The lock won't turn. It hums one bar of a melody, very softly,",
                  "and waits for someone who knows the next bar."])
    end
    say(["The moment #{herald?(:alberica) ? 'you touch' : 'Alberica touches'} it, the case hums a melody.", "Nobody here remembers composing it."])
    speak(:alberica, "I know this. I wrote this. I haven't written it yet. ...Pour me a drink.",
          "(very quietly) ...I know this one. I wrote it. I haven't written it yet.")
    sayc([cl(:reptin, "Then you'll write it beautifully. You always do. Eventually. After the drinks."),
          "The lock opens. Inside, on velvet: a slender tuning-key of silver and frost glass.",
          "Runes run down its shaft. They shift to match whatever's said near it."])
    set_flag(:key_found)
    say(["The Key of Whispering Memory is cold, and quiet. It's waiting to be woken.",
         "(Inside the lid, in Alberica's own hand: sing the Canticle alone, before dawn,",
         "in the hall of the four lights.)"])
  end

  # Quest B1, Canticle of Seasons (rootspire.md 8336-8350): Eirwen invites
  # Alberica to sing the Cycle Canticle anew, to weave severed memories back into
  # the chronicle. Three verses, one for each hard season: spring (hope), autumn
  # (loss), winter (endurance). Two of three complete the song; the Key may ring
  # one verse instead of her voice. Fewer, and the choir who failed centuries
  # ago comes for her. The lost verses can be recovered first in the Library.
  CANTICLE_VERSES = [
    [:spring, "Spring, the verse of hope",
     ["\"Under the snow the seed keeps count, and it is counting toward you.\"",
      "\"The green comes back because it was never really gone.\"",
      "\"Sing louder, and the thaw will come faster.\""], [0, 1],
     "\"The green comes back...\" (the leaf's ink runs; you're guessing)"],
    [:autumn, "Autumn, the verse of loss",
     ["\"Let go of the leaf, and the tree remembers it all winter.\"",
      "\"Hold on to the leaf, and it will never fall.\"",
      "\"Nothing is lost that was loved.\""], [0, 2],
     "\"...the tree remembers...\" (half the line is gone)"],
    [:winter, "Winter, the verse of endurance",
     ["\"Stand still, and the cold will pass you by.\"",
      "\"Keep the fire small and keep it going, and morning is a promise kept.\"",
      "\"Endure, and the year turns round to find you still singing.\""], [1, 2],
     "\"...keep it going...\" (the rest is frost)"]
  ]

  # At the living pillar in the Hall of Seasons.
  def council_pillar(event_id = nil)
    if !flag?(:key_found) || flag?(:key_attuned)
      return talk(:council_heart, event_id)
    end
    # (notes 15 E10: Eirwen is on the map when she speaks)
    eir = Stage.actor(:eirwen, $game_player.x - 1, $game_player.y, 6, graphic: "FT_eirwen_solglass") if Stage.map?
    council_pillar_rite(event_id)
  ensure
    Stage.remove_actor(eir) if eir
  end

  def council_pillar_rite(event_id = nil)
    me = herald?(:alberica)
    say(["The Council Hall of Seasons is lit by four pulsing crystals: green, red, white and gold.",
         "The colours shift in a slow dance: spring to winter to autumn to summer.",
         "Archivist Eirwen Solglass is waiting, barefoot on the polished root floor.",
         "EIRWEN: (whispering) It isn't my song. It's yours, Alberica. The crystals are waiting.",
         "EIRWEN: Before dawn. They won't hold the song past it."], event_id)
    if !with_or_is?(:alberica)
      return say(["EIRWEN: ...Ah. Not yours. The Key won't wake for anyone but the Dwarf of Song."])
    end
    if state[:canticle_night] == rs_day
      return say(["EIRWEN: The crystals are spent tonight. Even choirs sleep. Tomorrow, before dawn."])
    end
    if !flag?(:canticle_researched) && !flag?(:canticle_partial)
      say(["EIRWEN: Half the old verses were lost in the Reversal. The Library's leaves keep the rest.",
           "EIRWEN: You could find them first. Or sing now, and make up what's missing."])
      c = pbMessage(_INTL("The lost verses..."), [_INTL("Research them in the Library first"), _INTL("Sing now, and improvise")], 0)
      if c == 0
        say(["EIRWEN: Wise. Come to the Library. I'll leave the oldest case unlocked."])
        state[:goal] = "Find the Canticle's lost verses with Eirwen in the Wind-Glass Library, then sing it at the Council Hall's pillar."
        return
      end
    end
    return if !pbConfirmMessage(_INTL("Sing the Cycle Canticle now?"))
    state[:canticle_night] = rs_day
    known = flag?(:canticle_researched)
    say(["#{me ? 'You stand' : 'Alberica stands'} at the living pillar with the Key of Whispering Memory in #{me ? 'your' : 'her'} hand.",
         "Very faint in the crystals: other singers. The choir who tried this before, and failed.",
         "They're watching."])
    key_used = false
    hits = 0
    misses = 0
    CANTICLE_VERSES.each_with_index do |(season, title, lines, right, garbled), i|
      break if misses >= 3
      lost = !known && (season == :autumn || (flag?(:canticle_partial) ? false : season == :winter))
      say(["The #{%w[green red white][i]} crystal brightens. #{title}."])
      say(["(You never found this verse. #{garbled})"]) if lost
      opts = lines.map { |l| _INTL(l) }
      opts << _INTL("Let the Key ring this verse instead") if !key_used
      c = pbMessage(me ? _INTL("You sing...") : _INTL("Alberica sings..."), opts, -1)
      if !key_used && c == lines.size
        key_used = true
        hits += 1
        say(["The Key rings one long note, and the crystal answers. Magic, not voice. It counts."])
        next
      end
      good = right.include?(c)
      good = false if lost && c == right[1]        # improvising: only the truest line of the two will hold
      if good
        hits += 1
        say([["The green crystal holds. Somewhere, a name you'd lost comes back.",
              "The red crystal holds. A face comes back with it.",
              "The white crystal holds. And a voice."][i]])
      else
        misses += 1
        say(["The verse slips. The crystal flickers, and in it the old choir leans closer."])
      end
    end
    if hits >= 2
      canticle_success(known)
    else
      canticle_failure
    end
  end

  def canticle_success(known)
    set_flag(:key_attuned)
    set_flag(:canticle_learned)
    add_counter(:story_beats)
    sayc(["Hope, and loss, and enduring. And round again.",
          "The crystal veins light one after another, in time. The Key rings like a struck bell.",
          "The old choir in the crystals is singing with you now.",
          "Then they bow, all together, and go out like candles at dawn.",
          "For a moment the hall is full of voices: everyone who ever knew you, singing back."])
    if with_or_is?(:alberica)
      speak(:alberica, "...Oh. Oh, there you all are. Hello, darlings. I missed you. Every one.",
            "...Oh. There you all are.")
    end
    give(:FT_WHISPERKEY)
    say(["(The Key of Whispering Memory: held by a Pokémon, sound moves are 30% stronger.)"])
    # Eirwen's reward: a chronal leaf with a prophecy, and the lore of Verse XI.
    sayc(["EIRWEN: (wiping their eyes) The chronicle's mended. I felt it close, like a door.",
          "EIRWEN: Take this. A chronal leaf from the oldest case. It's been waiting for the song.",
          "On the leaf, in gold, a verse no one has sung yet:",
          "\"The Frost Saint will climb the Spire when the roots bleed.\"",
          "EIRWEN: The leaves have whispered it a month. Now it must come true, or be stopped.",
          "EIRWEN: And the line we carve over the Library door, so you know it's yours:",
          "\"The Dwarf of Song taught memory to sing, so the world would not forget it had been warm.\"",
          "(Verse Eleven. The Ballads of the Verdant Reversal.)"])
    give_key(:FT_PROPHECYLEAF)
    set_flag(:verse_xi_known)
    wheel(2)
  end

  # Fewer than two verses hold: the vengeful chorus (spectral bards, a swarm
  # dealing psychic harm). Escaping or beating them still gives a turn of the
  # wheel, a few secrets, and a melody stuck in her head; she may try again on
  # another night, before dawn.
  def canticle_failure
    me = herald?(:alberica)
    say(["The song breaks. All four crystals go dark at once.",
         "Out of them pours the choir who failed here before you: bards of light with hollow faces.",
         "They sing a wrong note, together, louder and louder."])
    won = boss_battle(named_mon(:WOOBAT, 42, "Spectral Bard"), named_mon(:WOOBAT, 42, "Spectral Bard"))
    sayc([won ? "The spectral bards scatter like moths, and the wrong note goes with them." :
                "You get out with your hands over your ears. Behind you the chorus sings to an empty room.",
          "The ritual's broken. But some of the chronicle came back anyway, through the cracks:",
          "a founding charter with one name scratched out; a Summer seal on a decree nobody signed;",
          "a goblin's name in a breeding ledger.",
          me ? "(One melody won't leave your head: the choir's wrong note. You'll hum it for days.)" :
               "Alberica hums under her breath all the way back. The choir's wrong note. She can't stop.",
          "EIRWEN: (shaken) Not tonight, then. The crystals will hold the song one more night.",
          "EIRWEN: Tomorrow, before dawn, if you'll try again."].compact)
    set_flag(:canticle_haunted)
    wheel(1) if !flag?(:canticle_failed_once)
    set_flag(:canticle_failed_once)
  end

  #-----------------------------------------------------------------------------
  # The Root-Tier: Meat Meat's blade, the Rootwarden Crypt, the Sap Gate
  #-----------------------------------------------------------------------------
  def driftwood_chest(event_id = nil)
    return talk(:driftwood_chest_empty, event_id) if flag?(:blade_found)
    return talk(:driftwood_chest_shut, event_id) if !with_or_is?(:meat_meat)
    sayc(["Half buried in the silt below the pier: a driftwood chest.",
          "A single candle still burns inside it, somehow, behind the wood.",
          herald?(:meat_meat) ? "(The tiny lock opens for your fingers like it was made for them. It was.)" : "Meat Meat's fingers find the tiny lock. It opens like it was made for them.",
          "Inside: a dagger, wrapped in a ledger page with a scorched laboratory seal: an \"A\".",
          "Across the top, in a hand you almost recognize:",
          "\"Subject V-7, the one who escaped.\""], event_id)
    speak(:meat_meat, "...Meat Meat's number. That is Meat Meat's number.",
          "...That's... Meat Meat's number.")
    sayc([cl(:reptin, "Not any more. It's a page in a box in the mud. You're the one holding it."),
          cl(:alberica, "Burn the page, sweetheart. Keep the knife.")].compact)
    sayc(["The blade is curved and goblin-sized: mirrored steel, veined with green crystal.",
          "Its reflection moves half a heartbeat out of step.",
          herald?(:meat_meat) ? "(You close your hand on it, and you're on the cold table. Other yous fade into frost.)" :
                                "Meat Meat closes her hand on it and goes very still. Her eyes are on a cold table.",
          herald?(:meat_meat) ? nil : "A dozen others like her are fading into frost there.",
          "A voice, counting. Then, under it: \"Will you remain a weapon, or become a seed?\""])
    c = pbMessage(_INTL("Weapon, or seed?"), [_INTL("A seed"), _INTL("A weapon")], 0)
    if c == 1
      set_flag(:blade_weapon)
      sayc(["The reflection in the blade bares its teeth, and agrees.",
            cl(:meat_meat, "Weapon. For now. Weapons protect seeds. Meat Meat knows what Meat Meat is for.")])
    else
      set_flag(:blade_seed)
      sayc(["The green in the blade brightens, like a shoot finding the sun.",
            cl(:meat_meat, "Seed. Meat Meat is a seed. Seeds grow into anything."),
            cl(:meat_meat, "Even things the lady didn't plan.")])
    end
    set_flag(:blade_found)
    set_self_switch(event_id, "A")
    add_counter(:story_beats)
    give(:FT_VERDANTBLADE)
    say(["(The Verdant Blade: held by a Pokémon, its not very effective moves do double damage.)"])
  end

  def crypt_staff(event_id = nil)
    return say(["The petrified Warden's hands are empty now, curled round a staff that isn't there."], event_id) if flag?(:staff_found)
    say(["In the ring of petrified druids, one stands taller than the rest.",
         "Its hands hold a staff of living root. The tip burns faintly gold inside the sap."], event_id)
    if !with_or_is?(:reptin)
      return say(["The sap is clear as glass, hard as stone. Whatever the staff is waiting for, it isn't you."])
    end
    if !flag?(:crypt_guardian_down)
      say(["As you step closer, the sap stirs. Something grows up out of the floor, in your way.",
           "Bark, old wolf hide, and two green, sleepy eyes. The crypt's guardian.",
           "It wants to know if you came to take, or to keep."])
      sayc([cl(:reptin, "To keep. Obviously. I'd say that even if it weren't true, but it is."),
            cl(:alerion, "It doesn't believe you.")].compact)
      return if !boss_battle(named_mon(:B103H439, 41, "Crypt Guardian"))
      set_flag(:crypt_guardian_down)
      say(["The guardian folds back into the floor, like someone sitting down after a long day.",
           "It doesn't look beaten. It looks satisfied."])
    end
    sayc([herald?(:reptin) ? "(You touch the sap, and it softens under your hand like warm wax.)" : "Reptin touches the sap, and it softens under his hand like warm wax.",
          "The bark of the staff splits. Under it, carved into the heartwood: a wolf's head.",
          "His totem. Four hundred years, waiting for his hand."])
    speak(:reptin, "'Rage is only winter longing for spring.' ...I'll try to remember. No promises.",
          "Rage is only winter longing for spring. ...I'll try to remember.")
    sayc([cl(:meat_meat, "Reptin's wolf is on a stick now. Meat Meat approves of stick."),
          "A gnarled length of living root, bound in frozen wolf hide, capped with a gem.",
          "The gem flickers between emerald and pearl, in time with the tree's heartbeat."].compact)
    set_flag(:staff_found)
    add_counter(:story_beats)
    # The staff must be bonded at the edge of the Auroral Wall, through a whole
    # cycle of seasons (rootspire.md 1681-1683): auroral_wall_edge (048_H).
    give_key(:FT_UNBONDEDSTAFF)
    say(["The staff hums, but a beat out of time with #{herald?(:reptin) ? 'you' : 'Reptin'}, like a song in the wrong key.",
         "Carved under the wolf's head, very small:",
         "REST AT THE EDGE OF THE LIGHT, AND LET THE YEAR GO ROUND YOU.",
         cl(:wyn, "(softly) The old wardens bonded their staves at the Auroral Wall. One whole night.")].compact)
    state[:goal] = "Bond the Heartwarden's Staff: a night's rest at the edge of the Auroral Wall (the Blooming Fields)." if with_or_is?(:reptin)
  end

  def crypt_door(event_id = nil)
    return talk(:crypt_door_shut, event_id) if !flag?(:crypt_open)
    say(["The willow knot is cut. The round door swings inward on a breath of cold, clean air."], event_id)
    true
  end

  #-----------------------------------------------------------------------------
  # Hyphora's Undercanopy
  #-----------------------------------------------------------------------------
  def masked_trader(event_id = nil)
    return say(["The stall is empty. A sign lies face down: WHISPERS OF THE ECHO GATE."], event_id) if flag?(:spy_unmasked)
    say(["A cloaked, masked human sells rare surface goods from a stall made of crates.",
         "The sign reads: WHISPERS OF THE ECHO GATE.",
         "There's frost in the grain of his gloves. In the Undercanopy, where nothing freezes."], event_id)
    sayc([(with_or_is?(:meat_meat) ? cl(:reptin, "Leave the talking to me. ...Actually, no. Leave the hitting to Meat Meat.") : nil),
          cl(:meat_meat, "Meat Meat is ready. Meat Meat was born ready. In a jar.")].compact)
    return if !pbConfirmMessage(_INTL("Call him out?"))
    return if !trainer(:masked_trader, event_id)
    set_flag(:spy_unmasked)
    say(["The trader's mask cracks. Underneath: the cracked-snowflake tattoo of the Fractured Halo.",
         "MASKED TRADER: The Matron sent me to learn the little tree's true name.",
         "MASKED TRADER: She says with a young god's name, the goddess could have a body again.",
         "He breaks a vial of frost against the floor."], event_id)
    tr = stage_event(event_id)
    Stage.fx("E-09", stage_spot(tr), frames: 9, oy: 16) rescue nil
    (tr.erase rescue (tr.transparent = true)) if tr
    say(["When the white smoke clears, he's gone.",
         "ZYM: (Spy. He smelled of frost. Come. You are owed.)"])
    give(:FT_SPORECHIME)
    say(["(The Sporechime: carry it, and it chimes when a trainer here still wants to battle.)"])
  end

  def undercanopy_rest(event_id = nil)
    say(["YARRO: (Rest, surfacer. The spores are soft here. You'll wake mended.)"], event_id)
    pbFadeOutIn { $Trainer.heal_party } rescue ($Trainer.heal_party rescue nil)
    set_rest_at(UNDER_REST)
    say(["(Your Pokémon are rested. If you black out, you'll wake here.)"])
    return if flag?(:undercanopy_rest_banter)
    lines = []
    if with_or_is?(:wyn) && with_or_is?(:meat_meat)
      lines << as(:wyn, "...Um. These are the spore beds. I grew up sleeping next to them.")
      lines << as(:meat_meat, "Meat Meat will guard them. Nobody asked. Meat Meat is guarding.")
      lines << as(:wyn, "Oh. You don't have to.")
      lines << as(:meat_meat, "Meat Meat does not have to. Meat Meat wants to. Different thing.")
    elsif with_or_is?(:wyn)
      lines << as(:wyn, "The spores are humming. That means they like you. ...Sorry. That was a lot at once.")
    end
    if with_or_is?(:alerion) && lines.size >= 2
      lines << as(:alerion, "Let her. She guards better than she sleeps.")
    end
    if with_or_is?(:alberica) && with_or_is?(:wyn)
      lines << as(:alberica, "Wyn, sweetheart, you've gone pink. In the dark. It's very fetching.")
      lines << as(:wyn, "It's the spores. ...Mostly the spores.")
    end
    if lines.size >= 2
      set_flag(:undercanopy_rest_banter)
      sayc(lines)
    end
  end

  #-----------------------------------------------------------------------------
  # The Echo Gate's Mirror Wraiths (a Frostshard Sigil)
  #-----------------------------------------------------------------------------
  def echo_wraiths
    return false if flag?(:echo_wraiths_down) || !flag?(:wardens_emeritus)
    return false if !pbConfirmMessage(_INTL("Linger, and listen to the voices?"))
    sayc(["You stand still in the gate. The voices come closer: your names, whispered over and over.",
          "Under them, the wind itself, one word at a time: \"Don't... turn... back...\"",
          "The frost patterns on the walls aren't patterns. They're eyes. They follow you.",
          "Then Sephek's voice, close enough to feel: \"The lake remembers.\"",
          with_or_is?(:alerion) ? "And a boy's voice behind it, far off: \"Alerion? You said you'd come back for me.\"" : nil,
          with_or_is?(:alerion) ? cl(:alerion, "(gone white) ...Talion?") : nil,
          "The frost on the walls opens like eyes. Two shapes step out of it:",
          "figures of mirror-glass, with your faces, cracked.",
          cl(:alerion, "Mirror wraiths. Back to back. Now."),
          (with_or_is?(:alerion) ? cl(:alberica, "Ooh, he's bossy when it matters. Back to back, everyone, you heard the man.") : nil)].compact)
    if !boss_battle(named_mon(:B122H429, 39, "Mirror Wraith"), named_mon(:B122H429, 39, "Mirror Wraith"))
      return true
    end
    set_flag(:echo_wraiths_down)
    add_counter(:story_beats)
    say(["The wraiths burst into shards. They hang in the air, turning, catching the light.",
         "Before they fall, they spell a single word:",
         "V A U L T",
         "Among the fallen glass, one crystal doesn't break.", "It hums, a low note that pulls toward the Heartroot."])
    give(:FT_FROSTSIGIL)
    set_flag(:sigil_echo)
    # (owner's decision 4: the sigils find the Vault's door and wake it; they don't open it.
    # Context 06 §4: one line ties the name to Selrae's.)
    say(["(A Frostshard Sigil. One of three that find the White Vault's door, far in the north.)"])
    sayc([flag?(:selrae_white_womb) ? cl(:alerion, "The White Vault. The Matron called it the White Womb.") : nil].compact)
    if with_or_is?(:alerion)
      set_flag(:talion_foreshadowed)
      sayc([cl(:alerion, "(gone white) Talion. My brother. ...The lake took him."),
            cl(:alberica, "(very gently) \"The lake remembers.\" Lakes are liars. Mostly.")].compact)
    end
    echoes_at_the_wall if respond_to?(:echoes_at_the_wall)
    true
  end

  #-----------------------------------------------------------------------------
  # The Still Sky Shrine: cleansing it (the Blessing of Warmth)
  #-----------------------------------------------------------------------------
  def shrine_cleanse(event_id = nil)
    # Eline's ritual circle, cut into the floor before the runes: its channel runs
    # down to the Heartroot (rootspire.md 1022).
    talk(:eline_circle, event_id)
    return talk(:frost_saint_runes) if !flag?(:rite_stopped)
    return say(["The marble is warm now. The new runes are scratches. The old prayers are just prayers."], event_id) if blessing?(:warmth)
    say(["The new runes, cut over the old prayers: THE FROST SAINT WALKS AGAIN.",
         "Frost still lives in the grooves, cold enough to burn."], event_id)
    return if !pbConfirmMessage(_INTL("Scour the frost out of the runes with the spilled sap?"))
    sayc(["You work warm sap into every groove. The frost hisses and fights,", "then runs out of the stone like water.",
          "Under the new runes, the old prayers to Auril are still there.",
          "A gentle winter. A safe road home. Not stillness. Just mercy.",
          cl(:alberica, "People used to pray to her for mercy. I'd forgotten that."),
          cl(:alberica, "...I think she has too."),
          cl(:reptin, "Then we'll remind her. Politely, the first time."),
          "The statue's freshly cut eyes don't look sharp any more. Just old."].compact, event_id)
    grant_blessing(:warmth, "Blessing of Warmth", "Your Pokémon can no longer be frozen.")
  end

  #-----------------------------------------------------------------------------
  # The Blooming Fields: the Still Ones, and Alerion's Boundary Hunt
  #-----------------------------------------------------------------------------
  STILL_ONES = {
    faith:   ["A woman in a priest's robe, frozen kneeling, hands together. Her lips still move, slowly.",
              :B200H124, "Still One of Faith", :CLEANSETAG],
    hope:    ["A child frozen mid-run, holding up a lantern long gone out. Her eyes are on the Wall.",
              :B365H220, "Still One of Hope", :LUCKYEGG],
    love:    ["Two figures frozen holding hands. Frost has grown their fingers together.",
              :B429H131, "Still One of Love", :SOOTHEBELL],
    balance: ["A Rootwarden frozen mid-stride, one foot in flowers and one in snow, holding empty scales.",
              :B215H438, "Still One of Balance", :FT_AURORALMOTE]
  }

  def still_one(key, event_id = nil)
    text, species, name, reward = STILL_ONES[key]
    if flag?(:"still_#{key}")
      return say(["Where the frozen figure stood, the snow has melted into a ring of small, stubborn flowers."], event_id)
    end
    say([text, "Up close you can hear it: the faintest whisper, over and over. \"Finish... finish...\""], event_id)
    # The notes (rootspire.md 1185-1192): each embodies a lost virtue; destroying
    # or redeeming them shifts the Tree's alignment toward Frost or Verdant.
    c = pbMessage(_INTL("What do you do?"), [_INTL("Help it finish"), _INTL("Shatter it"), _INTL("Leave it be")], 2)
    return if c != 0 && c != 1
    if c == 1
      say(["You strike the frost hard. It doesn't crack: it bursts, like a dropped lantern.",
           "For one moment you hear it scream. Then the virtue in it goes out, and the shards ring.",
           "Along the Wall the snow thickens, as if something cold just took a deep breath."])
      set_flag(:"still_#{key}")
      set_flag(:"still_#{key}_shattered")
      add_counter(:tree_frost)
      add_counter(:story_beats)
      wheel(-1)
      give(:FT_STILLSHARD)
    else
      say(["You touch the frost. It cracks.",
           "Something that's waited four hundred years to move pours out, half-panicked, all cold!"])
      return if !boss_battle(named_mon(species, 38, name))
      set_flag(:"still_#{key}")
      add_counter(:tree_verdant)
      add_counter(:story_beats)
      say(["The frozen figure sighs. The frost runs off it like water. There's nobody inside at all.",
           "Just snow, settling. Finished. Something is left behind in the slush."])
      give(reward)
    end
    if STILL_ONES.keys.all? { |k| flag?(:"still_#{k}") }
      frost = (counter(:tree_frost) rescue 0).to_i
      verdant = (counter(:tree_verdant) rescue 0).to_i
      if verdant >= frost
        sayc(["All four Still Ones are gone.", "Along the Wall, the snow-flowers lean the same way, like a field after wind.",
              cl(:reptin, "#{frost == 0 ? 'Faith, hope, love, balance. All finished.' : 'Finished, most of them. The rest...'} The tree felt that."),
              cl(:reptin, "And I felt it feel it. Which is a sentence I never expected to say."),
              cl(:wyn, "...They're resting now. Properly. Thank you for helping them.")].compact)
        set_flag(:tree_leans_verdant)
      else
        sayc(["All four Still Ones are gone. Along the Wall the flowers have closed. The snow lies hard.",
              "Somewhere very deep, something pleased turns over in its sleep.",
              cl(:reptin, "(very quiet) We broke them. The tree felt that too."),
              cl(:reptin, "It's leaning toward the cold now. I can feel it lean."),
              cl(:wyn, "...They wanted to finish. Not to end. Those aren't the same.")].compact)
        set_flag(:tree_leans_frost)
      end
      grant_blessing(:still_sky, "Blessing of Still Sky", "You keep your footing on ice and snow: no more sliding. (Sap is another matter.)")
    end
  end

  def frozen_hunter(event_id = nil)
    if flag?(:mantle_found)
      return say(["Where the hunter stood, two sets of footprints: one toward the Wall, one coming back."], event_id)
    end
    say(["At the foot of the Auroral Wall stands a hunter frozen mid-stride, in silver-white mail.",
         "His face is turned to the light. A cloak of rime-touched feathers hangs on his shoulders."], event_id)
    if !with_or_is?(:alerion)
      return say(["His face is a stranger's. Whoever he's waiting for, it isn't you."])
    end
    say([herald?(:alerion) ? "(His face is yours. Not like yours. Yours.)" : "His face is Alerion's. Not like Alerion's. Alerion's."])
    speak(:alerion, "...That's me. A me that didn't come back.", "...That's me.")
    say(["The hunter's lips are parted. Frost has written a word on them, fine as lace: TALION.",
         herald?(:alerion) ? "(Your brother's name. The one you tried to bring back.)" : "Alerion's brother's name. The one he tried to bring back."])
    set_flag(:talion_foreshadowed)
    sayc([cl(:alberica, "(quietly, a hand on his arm) Pretty boy. Breathe."),
          "As #{herald?(:alerion) ? 'you reach' : 'Alerion reaches'} for the cloak, the frozen hunter breathes.",
          "\"Finish the step I never could.\"",
          "Tracks lead away from him along the Wall: something big and hungry, heading for the city.",
          "The cloak won't come free. Not yet."].compact)
    set_flag(:hunter_seen)
    rime_stalker(event_id)
  end

  # The trial: bring down a predator that threatens Rootspire without killing it (catch it).
  def rime_stalker(event_id = nil)
    return if flag?(:mantle_found) || !flag?(:hunter_seen)
    sayc(["Out of the snow-flowers rises a lean shape, white on white.",
          "A stalker of the frost: the predator the tracks belonged to.",
          cl(:alerion, "The cloak wants it brought down. Not killed. ...Catch it.")])
    setBattleRule("cannotRun")
    decision = pbWildBattleCore(named_mon(:B310H272, 38, "Rime Stalker")) rescue 0
    if decision == 4
      set_flag(:mantle_found)
      add_counter(:story_beats)
      sayc(["The moment the stalker's caught, the hunter's cloak slides into #{herald?(:alerion) ? 'your' : "Alerion's"} hands.",
            "The mail cracks and falls. There's no one in it. Just two footprints, turned toward home.",
            cl(:alerion, "Walk softly, he'd say. I'll try."),
            cl(:meat_meat, "Ice Prince walks very loud. Meat Meat has heard him. Meat Meat will help."),
            (with_or_is?(:meat_meat) ? cl(:alerion, "...Thank you.") : nil),
            "A mantle woven from frost-hawk feathers and the scales of a long-dead dragon.",
            "Cold air spirals lazily off it. Never unkind."].compact)
      give(:FT_RIMEMANTLE)
      say(["(The Rime Mantle: held by a Pokémon, Ice moves are 20% stronger; no freezing, no hail.)"])
    elsif decision == 1
      say(["The stalker falls still in the snow. The cloak's feathers freeze solid.",
           "The stalker won't stay down. It has to be caught, not beaten. (Come back and try again.)"])
    end
  end

  def apply_rootspire_switches
    return if !active? || !$game_switches
    sync_switch(SW_HEARTH_BADGE, flag?(:badge_hearth))
    sync_switch(SW_CRYPT_OPEN, flag?(:crypt_open))
    sync_switch(SW_SAP_GATE, flag?(:sap_gate_open))
    sync_switch(SW_LAKE_CLEAN, flag?(:lake_clean))
    sync_switch(SW_UNDER_BADGE, flag?(:badge_undercanopy))
    sync_switch(SW_TWINS_MET, flag?(:twins_met))
    sync_switch(SW_HALO_ORB, flag?(:halo_orb_cleared) || flag?(:twins_met))
    sync_switch(SW_WRAITHS, flag?(:echo_wraiths_down))
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_rootspire_switches
  rescue StandardError => err
    FrostThaw.log("Rootspire switches failed: #{err.message}")
  end
}
