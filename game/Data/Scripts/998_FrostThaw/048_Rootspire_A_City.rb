#===============================================================================
# Frost & Thaw - Rootspire as a living city (the faithful build-out, part A)
#
# The city the Rootspire campaign documents describe, all of it, not just the
# streets the story runs through:
#   - the Merchant & Downtime Compendium's eighteen shops, on the tiers it puts
#     them, each with its keeper, read-aloud, rumour and ten-item stock turned
#     into Pokémon goods (Run & Bloom, the Sap-Smith, the Auroral Atelier, the
#     Glasswater Outfitter, the Wind-Glass Library's counter, the Shrine of
#     Balance, the Still Sky Shrine's black market, Rootwarden Hall, Ink &
#     Ember, Crystal Quill, Gem & Thorn, the Perfumed Root, Verdant Stables,
#     Mirror-Dust, Auroral Arms, the shuttered Suncleft Emporium, the Thorned
#     Ledger Bank and Frost-Thread);
#   - the Seasonal Factions & Intrigue Dossier's people and their secrets;
#   - the "20 New Rootspire NPCs";
#   - the ten lore-aligned surveillance creatures (as watchers you can catch
#     sight of, and corner);
#   - the downtime week and the festival's loose threads (048_Rootspire_E).
#
# This file holds the registries: maps, switches, items, shops, trainers.
#===============================================================================
module FrostThaw
  SW_SUNCLEFT_OPEN = 4160   # the Ember-Rat's trail opens the shuttered Suncleft Emporium
  SW_CELLAR_FOUND  = 4161   # the Frozen Cellar's door under the old brewery is found
  SW_RUN_OPEN      = 4162   # the Smuggler's Run hatch under the Split Dock is unbarred
  SW_ASH_EXPOSED   = 4163   # the Rootwarden infiltrator is unmasked
  SW_FROZEN_RUN    = 4164   # Ivran's escort across the frozen half is under way
  SW_DARRUS_HIDING = 4165   # exposed, Darrus hides at the Run's old moorings
  SW_LANTERN       = 4166   # you carry Jast's Lantern of Revealing: the watchers show
  SW_ORB_HALO      = 4167   # the Halo splinter is kneeling at the orb (before the visions)
  SW_KELYN_ORB     = 4169   # Kelyn is at the orb by night, dreaming with Razzilith
  SW_EREN_TROUBLED = 4170   # Eren is at the Armory, troubled by the gift of memory
  SW_SPIRITS       = 4171   # the summer and winter spirits are quarrelling in the Blooming Fields
  SW_STILL_BEAST   = 4172   # the Still Beast prowls the thaw line
  SW_TALWYN_FIELDS = 4173   # Talwyn has followed you as far as the Blooming Fields
  SW_SCORCH        = 4174   # warm scorch marks by the Echo Gate (after the festival)
  SW_HALDEN        = 4176   # Halden Vex has set up his reset-engine in the Library

  ROOTSPIRE_LIFE_MAPS = {
    2180 => "The Verdant Halls", 2181 => "Run & Bloom Apothecary", 2182 => "Glasswater Outfitter",
    2183 => "Rootwarden Hall", 2184 => "Gem & Thorn Exchange", 2185 => "The Perfumed Root",
    2186 => "Auroral Arms", 2187 => "Thorned Ledger Bank", 2188 => "The Frozen Cellar",
    2189 => "The Lightfall Promenade", 2190 => "Auroral Atelier", 2191 => "Shrine of Balance",
    2192 => "Ink & Ember Bookhouse", 2193 => "Crystal Quill Scrollworks", 2194 => "Suncleft Emporium",
    2195 => "Frost-Thread Clothier", 2196 => "Verdant Stables", 2197 => "Mirror-Dust Curiosity Shop",
    2198 => "The Smuggler's Run", 2199 => "The Frozen Run"
  }
  MAP_NAMES.merge!(ROOTSPIRE_LIFE_MAPS)
  MAPS.merge!(verdant_halls: 2180, run_bloom: 2181, outfitter: 2182, warden_hall: 2183, gem_thorn: 2184,
              perfumed_root: 2185, auroral_arms: 2186, ledger_bank: 2187, frozen_cellar: 2188, promenade: 2189,
              atelier: 2190, balance_shrine: 2191, ink_ember: 2192, crystal_quill: 2193, suncleft: 2194,
              frost_thread: 2195, stables: 2196, mirror_dust: 2197, smugglers_run: 2198, frozen_run: 2199)
  MAP_METADATA.merge!(
    2180 => { outdoor_map: true, announce_location: true, battle_environment: :Forest },
    2189 => { outdoor_map: true, announce_location: true, battle_environment: :Forest },
    2183 => { announce_location: true }, 2188 => { announce_location: true, battle_environment: :Cave },
    2194 => { announce_location: true },
    2198 => { announce_location: true, battle_environment: :Cave },
    2199 => { outdoor_map: true, announce_location: true, weather: [:Snow, 60], battle_environment: :Snow }
  )
  (2181..2187).each { |m| MAP_METADATA[m] ||= {} }
  (2190..2197).each { |m| MAP_METADATA[m] ||= {} }
  AREAS.merge!(2180 => :verdant_halls, 2181 => :verdant_halls, 2182 => :verdant_halls, 2183 => :warden_hall,
               2184 => :verdant_halls, 2185 => :verdant_halls, 2186 => :verdant_halls, 2187 => :ledger_bank,
               2188 => :frozen_cellar, 2189 => :promenade, 2190 => :promenade, 2191 => :promenade, 2192 => :promenade,
               2193 => :promenade, 2194 => :suncleft, 2195 => :promenade, 2196 => :root_tier, 2197 => :mirror_dust,
               2198 => :smugglers_run, 2199 => :frozen_run)

  # Every Rootspire map where the city's life (vignettes, watchers, omens) can find you.
  ROOTSPIRE_MAPS = (2180..2199).to_a + [2050, 2051, 2052, 2053, 2054, 2055, 2056, 2059, 2060, 2061, 2062, 2063]

  ENCOUNTERS[2198] = { step_chances: { Cave: 7 },
                       Cave: [[25, :GOLBAT, 38, 40], [20, :RATICATE, 37, 39], [15, :MISDREAVUS, 38, 40],
                              [15, :SNEASEL, 38, 40], [15, :QWILFISH, 38, 40], [10, :HAUNTER, 39, 41]] }

  #-----------------------------------------------------------------------------
  # Goods (the compendium's stock in Pokémon terms, and the downtime's keepsakes)
  #-----------------------------------------------------------------------------
  RELIC_ITEMS.merge!(
    FT_SANGUINETONIC: ["Sanguine Sap Tonic", "Sanguine Sap Tonics", 2, 900,
      "Run & Bloom's red draught: bright red with a gold shimmer, sweet and warm. Restores 70 HP. \"The tree likes to see you healthy.\"", 1, 1, 0],
    FT_VITALITYPHIAL: ["Verdant Vitality Phial", "Verdant Vitality Phials", 2, 800,
      "A green draught with leaves of light swirling in it. Mint and basil. Cures any status problem and restores 20 HP.", 1, 1, 0],
    FT_RENEWALDRAUGHT: ["Heartroot Renewal Draught", "Heartroot Renewal Draughts", 2, 1400,
      "The muddled one: red and green chasing each other like vine round flame. Restores 100 HP and cures any status problem.", 1, 1, 0],
    FT_EMBERLEAF: ["Emberleaf Capsule", "Emberleaf Capsules", 2, 1200,
      "Red with green wisps: heartfire and verdant threads. In battle, raises a Pokémon's Attack and Sp. Atk.", 0, 2, 0],
    FT_STILLSHARD: ["Shard of Stillness", "Shards of Stillness", 1, 600,
      "A splinter of mirror from the Still Sky's black market. It goes cold near a hidden watcher, and your reflection blinks a beat late.", 0, 0, 0],
    FT_LOOPBAND: ["Rootwarden's Loop-Band", "Rootwarden's Loop-Bands", 8, 0,
      "A wristband of living bark from Arvik. It grows to fit, and moves with the World Tree. With the Quiet Step, half as many wild Pokémon find you in grass.", 0, 0, 6],
    FT_CHARDALYN: ["Chardalyn Fragment", "Chardalyn Fragments", 8, 0,
      "A black crystal found by the Echo Gate, still warm, cut through with infernal sigils. It hums like something far below is being forged.", 0, 0, 6],
    FT_MEMORYCODEX: ["Memory Codex", "Memory Codices", 8, 0,
      "Alberica's codex, begun in the Rooted Hearth. Four fragments of a timeline glow in its ink.", 2, 0, 6],
    FT_MANEBRAID: ["Mane-braid Pendant", "Mane-braid Pendants", 8, 0,
      "Lumin's gift to Glimmer on the Litany of the Mane: a braid of gold thread, warm as a hand.", 0, 0, 6],
    FT_RELIQUARY: ["Sealed Reliquary", "Sealed Reliquaries", 8, 0,
      "A box older than the tree, from the Guild's vault. Inside, something made of mirror is whispering.", 0, 0, 6],
    FT_REVEALLANTERN: ["Lantern of Revealing", "Lanterns of Revealing", 8, 0,
      "Jast's lantern. While you carry it, the city's hidden watchers show themselves.", 0, 0, 6],
    FT_ECHOCODEX: ["Echo Codex", "Echo Codices", 8, 0,
      "A book of crystal leaves that repeats what Rootspire's wind has said. Read it, and it whispers a page.", 2, 0, 6],
    FT_AURORALCOMPASS: ["Auroral Compass", "Auroral Compasses", 8, 0,
      "Tirena's compass. Its needle ignores north and points at the nearest place where the world is thin.", 2, 0, 6]
  )

  # Two key items the scene pass added (notes/15 E6, E19), registered on their
  # own numbers after the Vault's key so no other item's number moves.
  SCENE2H_ITEMS = {
    FT_WARMORE: ["Lump of Warm Ore", "Lumps of Warm Ore", 8, 0,
      "Black ore from the Smuggler's Run, warm as a hand, smelling of smoke shut up in stone. The tag said SAP-SMITH.", 0, 0, 6],
    FT_WAXMAP: ["Viessa's Wax Map", "Viessa's Wax Maps", 8, 0,
      "Viessa's map of Rootspire, spattered with wax wherever her candles went sideways. Six places. Read it to see them.", 2, 0, 6]
  }
  SCENE2H_ITEM_NUMBER = 9620

  MARTS.merge!(
    # 1. Run & Bloom Apothecary (Trunk-Tier, Spring; Bryn of Spring, Nivva at the annex stand)
    run_bloom:   [:POTION, :SUPERPOTION, :HYPERPOTION, :FT_SANGUINETONIC, :FT_VITALITYPHIAL, :FT_RENEWALDRAUGHT,
                  :FT_EMBERLEAF, :FT_SAPSALVE, :ICEHEAL, :ANTIDOTE, :FULLHEAL, :REVIVE],
    # 2. The Sap-Smith (Trunk-Tier forge annex, Summer; Gorran Ashal-Forge)
    sap_smith:   [:MUSCLEBAND, :HARDSTONE, :METALCOAT, :CHARCOAL, :HEATROCK, :SHELLBELL, :QUICKCLAW, :RAZORCLAW, :MAGMARIZER, :FLAMEORB],
    # 3. Auroral Atelier (Canopy, Autumn; Lumea Keth): illusions and lightcraft
    atelier:     [:BRIGHTPOWDER, :SMOKEBALL, :ZOOMLENS, :WIDELENS, :LIGHTCLAY, :SHINYSTONE, :DUSKSTONE, :DAWNSTONE, :EXPERTBELT, :SILVERPOWDER],
    # 4. Glasswater Outfitter (Trunk-Tier; Tirena Loch-Vine): rangers, climbers, mounts
    outfitter:   [:ESCAPEROPE, :MAXREPEL, :DIVEBALL, :NETBALL, :NESTBALL, :MYSTICWATER, :NEVERMELTICE, :SOFTSAND, :GRIPCLAW, :SAFETYGOGGLES],
    # 5. Wind-Glass Library counter (Canopy, Winter; Solvaran): scrolls and lore
    solvaran:    [:TM04, :TM29, :TM16, :TM33, :TM77, :TM85, :TM100, :FT_ECHOCODEX],
    # 6. Shrine of Balance (Canopy, Winter; Ysera Dorn): cleric's goods
    balance:     [:FULLHEAL, :REVIVE, :MAXREVIVE, :HEALPOWDER, :ENERGYROOT, :REVIVALHERB, :CLEANSETAG, :SPELLTAG, :LUMBERRY],
    # 8. Rootwarden Hall (Trunk-Tier, the civic ring; Captain Kethan Vale): a guard's kit
    warden_hall: [:GREATBALL, :ULTRABALL, :SUPERPOTION, :HYPERPOTION, :FULLHEAL, :XATTACK, :XDEFENSE, :XSPEED, :GUARDSPEC, :DIREHIT],
    # 9. Ink & Ember Bookhouse (Canopy; Mirna Cowl): tomes and manuals
    ink_ember:   [:CALCIUM, :ZINC, :IRON, :PROTEIN, :CARBOS, :HPUP, :PPUP, :TM49, :TM48, :FT_ECHOCODEX],
    # 10. Crystal Quill Scrollworks (Canopy; Filgen Rootfoot): spell scrolls
    crystal_quill: [:TM35, :TM24, :TM57, :TM61, :TM111, :TM92, :TM98, :TM73, :TM43, :TM62],
    # 11. Gem & Thorn Exchange (Trunk-Tier; Arvoss Ember-Scale)
    gem_thorn:   [:PEARL, :STARDUST, :FOCUSBAND, :AMULETCOIN, :ICESTONE, :MOONSTONE, :SUNSTONE, :OVALSTONE, :SHINYSTONE, :KINGSROCK],
    # 12. The Perfumed Root (Trunk-Tier; Lirielle Mossdancer): scents
    perfumed_root: [:LAXINCENSE, :FULLINCENSE, :SEAINCENSE, :ROSEINCENSE, :ODDINCENSE, :PUREINCENSE, :ROCKINCENSE, :WAVEINCENSE, :LUCKINCENSE],
    # 13. Verdant Stables (Root-Tier; Thim Wicker): tack, feed and friendship
    stables:     [:FRIENDBALL, :HEALBALL, :LUREBALL, :LEVELBALL, :ORANBERRY, :SITRUSBERRY, :PECHABERRY, :CHESTOBERRY, :RAWSTBERRY, :ASPEARBERRY],
    # 14. Mirror-Dust Curiosity Shop (Root-Tier; Jast Penumbran): oddities
    mirror_dust: [:SMOKEBALL, :CLEANSETAG, :SOOTHEBELL, :DESTINYKNOT, :REDCARD, :EJECTBUTTON, :RINGTARGET, :FT_STILLSHARD],
    # 15. Auroral Arms (Trunk-Tier; Brogar Frostvein)
    auroral_arms: [:MUSCLEBAND, :SCOPELENS, :RAZORFANG, :METALCOAT, :ROCKYHELMET, :PROTECTIVEPADS, :SHARPBEAK, :NEVERMELTICE],
    # 18. Frost-Thread Clothier (Canopy; Maera Vell): enchanted garments
    frost_thread: [:SILKSCARF, :CHOICESCARF, :EXPERTBELT, :BLACKBELT, :FOCUSBAND, :SHEDSHELL, :REDSCARF, :BLUESCARF, :PINKSCARF, :GREENSCARF]
  )

  # The Suncleft's untouched shelves (16) don't run like a shop.
  SUNCLEFT_SHELVES = [:FIRESTONE, :CHARCOAL, :HEATROCK, :FLAMEORB, :MAGMARIZER, :FIREGEM]

  #-----------------------------------------------------------------------------
  # Trainers: the city's guards, cultists, revenants and rivals
  #-----------------------------------------------------------------------------
  TRAINER_TYPES.merge!(
    FT_ARVIK:     ["Rootwarden Trainer", :POKEMONRANGER_M, 0, 90, :LEADER_Brock],
    FT_ARVIK2:    ["Rootwarden Trainer", :POKEMONRANGER_M, 0, 100, :LEADER_Brock],
    FT_WATCHMAN:  ["Rootwarden Captain", :POKEMONRANGER_M, 0, 110, :LEADER_Brock],
    FT_TURNCOAT:  ["Turncoat Warden", :POKEMONRANGER_M, 0, 90],
    FT_DREAMER:   ["Frost-Touched", :POKEMONRANGER_M, 0, 70]
  )
  TRAINERS.merge!(
    warden_bryony:   [:FT_ROOTWARDEN, "Bryony", [[:STANTLER, 39], [:B188H183, 40]], "Seed circle. We mend. Today I'm the one mending."],
    clerk_fenn:      [:FT_SCHOLAR, "Fenn", [[:B137H81, 39], [:NATU, 39]], "Civic ring clerk. Defeated, and recorded as such."],
    warden_claw:     [:FT_ROOTWARDEN, "Hode", [[:B59H232, 40], [:PILOSWINE, 40]], "Claw circle holds the line. Mostly. Not against you."],
    warden_seed:     [:FT_ROOTWARDEN, "Ama", [[:BELLOSSOM, 40], [:B182H113, 41]], "The Seed circle heals what it breaks. Hold still."],
    halo_frost_wick: [:FT_HALO, "Brother Wick", [[:SNEASEL, 41], [:B124H215, 42]], "Perfect stillness. Perfect silence."],
    halo_soot_ren:   [:FT_HALO_F, "Sister Ren", [[:B228H124, 41], [:B126H220, 42]], "Freeze it. Then burn what's left. Then nothing."],
    halo_cinder_oda: [:FT_HALO_F, "Oda the Silent", [[:JYNX, 42], [:B229H215, 43]], "..."],
    prom_patron_vell:  [:GENTLEMAN, "Lord Aster", [[:B36H38, 41], [:GIRAFARIG, 41]], "An Autumn salon loss. How very seasonal."],
    prom_artist_cora:  [:BEAUTY, "Cora", [[:BELLOSSOM, 41], [:B122H65, 41]], "You've ruined the composition. Thank you."],
    run_warden_moss:   [:FT_ROOTWARDEN, "Moss", [[:B91H215, 41], [:STANTLER, 41]], "Guild vault. Rootwarden-warded. And you walked past the wards."],
    run_smuggler_kett: [:SAILOR, "Kett", [[:QWILFISH, 41], [:B130H215, 42]], "You never saw me. I never saw you. Deal?"],
    revenant_hask:     [:SAILOR, "Revenant Hask", [[:B91H93, 42], [:B131H200, 42]], "...the... ice... came... off... the... shore..."],
    revenant_moirin:   [:SAILOR, "Revenant Moirin", [[:B87H93, 43], [:B73H200, 43]], "...still... rowing..."],
    revenant_tobe:     [:SAILOR, "Revenant Tobe", [[:B131H94, 44], [:B130H93, 44]], "...tell... the... Corsairs... we... kept... the... course..."],
    # the people the quests set you against
    arvik_spar:   [:FT_ARVIK, "Arvik", [[:B59H232, 40], [:STANTLER, 40], [:B188H183, 41]], "Up. Again. ...No, that was good. Don't let it go to your head."],
    arvik_ambush: [:FT_ARVIK2, "Arvik", [[:B59H232, 42], [:STANTLER, 42], [:B188H183, 43], [:B215H59, 43]], "You moved before you thought. That's the whole lesson."],
    ash_turned:   [:FT_TURNCOAT, "Ash", [[:B228H215, 43], [:B126H59, 43], [:B59H126, 44]], "Summer pays better than balance. It always has."],
    halo_ambusher: [:FT_HALO, "Halo Knife", [[:SNEASEL, 41], [:B124H215, 41]], "The Frost Saint knows your names."],
    eren_touched: [:FT_DREAMER, "Eren", [[:B163H124, 43], [:GLACEON, 44], [:B215H163, 44]], "...I can remember everything. Everything. Make it stop."],
    halden_vex:   [:FT_SCHOLAR, "Halden Vex", [[:B137H82, 43], [:B65H178, 43], [:B178H137, 44]], "Reset... failed. Fascinating. Distressing. Fascinating."],
    eira_voss:    [:FT_HALO_F, "Eira Voss", [[:B124H94, 44], [:B228H215, 44], [:B94H124, 45]], "...silence... after... both..."],
    kethan_duel:  [:FT_WATCHMAN, "Kethan", [[:B68H112, 44], [:B76H208, 44], [:B112H68, 45]], "Truthful. Your fists, I mean. That's rare."]
  )
  TRAINER_INTROS.merge!(
    warden_bryony:   "BRYONY: Seed circle! I patch people up. First I have to make some people to patch.",
    clerk_fenn:      "FENN: Civic ring regulations, section nine: Heralds may be challenged once per festival.",
    warden_claw:     "HODE: The Armory trains on whoever walks in. You walked in.",
    warden_seed:     "AMA: Spar with a healer? You'll lose and feel wonderful about it.",
    halo_frost_wick: "WICK: You found the cellar. Then you'll stay in it.",
    halo_soot_ren:   "REN: The Frozen Flame burns cold, and then it burns everything.",
    halo_cinder_oda: "ODA: ...",
    prom_patron_vell:  "ASTER: Autumn's salon is open to anyone who can afford to lose gracefully.",
    prom_artist_cora:  "CORA: Stand there. No, there. Perfect. Now: battle!",
    run_warden_moss:   "MOSS: The Rootwardens guard this vault for the Guild. Turn round.",
    run_smuggler_kett: "KETT: Wrong tunnel, friend. Wrong tunnel for everybody but me.",
    revenant_hask:     "The frozen sailor turns, ice cracking at every joint. Its eyes are open. They see you.",
    revenant_moirin:   "The revenant lifts an oar of solid ice, and swings it like a cutlass.",
    revenant_tobe:     "A revenant at a frozen wheel. It turns, very slowly, and steers at you.",
    halo_ambusher:     "HALO KNIFE: (out of the dark under the Hearth's eaves) Stillness, Heralds!",
    arvik_spar:        "ARVIK: Guard the pulse. ...Guard YOUR pulse, then. Come on.",
    arvik_ambush:      "ARVIK: (dropping out of a branch above you) Ambush! Move!",
    ash_turned:        "ASH: You couldn't leave it alone. Fine. Rootwardens settle things the old way.",
    eren_touched:      "EREN: (frost on his lashes) She gave me every winter there ever was. Let me show you.",
    halden_vex:        "HALDEN: Hold still, displaced centuries! You're out of place, and I'm putting you back!",
    kethan_duel:       "KETHAN: (cracking his knuckles: pop, pop, like ice splitting) Words lie. Fists don't."
  )

  #-----------------------------------------------------------------------------
  # The watchers (the ten "Lore-Aligned Surveillance Enemies"): who sent them,
  # what they report on, and what they look like here.
  #   [key, name, faction master, species for the battle, overworld sprite, flag that lets them start watching]
  #-----------------------------------------------------------------------------
  WATCHERS = [
    [:stalker, "Root-Hollow Stalker", "Bryn of Spring", :B185H93, "Followers/SUDOWOODO", :met_bryn,
     "It reports anyone examining the Heartroot, using fire, or asking about burning roots."],
    [:veil_shade, "Frost-Veil Shade", "Ysera Dorn", :B200H124, "Followers/MISDREAVUS_fly", :met_ysera,
     "It reports who talks with Autumn or Summer, any necromancy, any heart out of balance."],
    [:moth_swarm, "Auroral Moth-Swarm", "Lumea Keth", :B49H122, "Followers/VENOMOTH_fly", :met_lumea,
     "It reports what moves you: beauty, praise, resistance. Autumn's flattery needs to know."],
    [:ember_rat, "Infernal Ember-Rat", "Gorran Ashal-Forge", :B20H228, "Followers/RATICATE", :met_gorran,
     "It follows heat: anyone near the Suncleft, anyone with fire, any wyrmling's warmth."],
    [:homunculus, "Mirror-Shard Homunculus", "Jast Penumbran", :B137H122, "Followers/PORYGON", :met_jast,
     "It reports mirror shards, anyone who says Avarice's name, every Root-Tier shrine visit."],
    [:weasel, "Garden-Whisper Weasel", "Maera Vell", :B162H215, "Followers/FURRET", :met_maera,
     "It steals the details of you: hair, cloth, scent, who you trust. Maera plans a crowning."],
    [:wraithling, "Soul-Thread Wraithling", "Ysera Dorn and the Rootwarden captains", :B93H167, "Followers/HAUNTER_fly", :met_kethan,
     "It guards the Heartroot's doors, and sees the threads between people like strings."],
    [:rune_beetle, "Echo-Rune Beetle", "Lumea Keth", :B165H178, "Followers/LEDYBA_fly", :atelier_fox_seen,
     "It keeps thirty seconds of anything said near it. Doubts about Autumn, most of all."],
    [:raven, "Snow-Still Raven", "Eira Voss", :B198H124, "Followers/MURKROW", :rite_stopped,
     "Auril's sacred bird, altered. It reports anyone who shields warmth or wyrmlings."],
    [:lurker, "Shadow-Heat Lurker", "Avarice herself", :B94H229, "Followers/GENGAR", :ch7_started,
     "It lives in your own shadow. It studies your fears, your loyalties, and the wyrmlings."]
  ]

  # Where each watcher can be cornered: [map, x, y].
  WATCHER_SPOTS = {
    stalker: [2050, 15, 14], veil_shade: [2189, 16, 30], moth_swarm: [2189, 46, 33], ember_rat: [2052, 3, 9],
    homunculus: [2055, 20, 23], weasel: [2189, 26, 39], wraithling: [2050, 43, 18], rune_beetle: [2190, 6, 8],
    raven: [2055, 15, 6], lurker: [2053, 12, 9]
  }
end

# The scene pass's two key items, on their own numbers (see SCENE2H_ITEMS).
module GameData
  class << self
    alias ft_scene2h_load_all load_all unless method_defined?(:ft_scene2h_load_all)
    def load_all
      ft_scene2h_load_all
      begin
        n = FrostThaw::SCENE2H_ITEM_NUMBER
        FrostThaw::SCENE2H_ITEMS.each do |id, (name, plural, pocket, price, desc, field, battle, type)|
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
        FrostThaw.log("Scene-pass key items failed: #{e.message}")
      end
    end
  end
end

if defined?(ItemHandlers::UseInField)
  ItemHandlers::UseInField.add(:FT_WAXMAP, proc { |_item| FrostThaw.wax_map_use; next 1 })
end
