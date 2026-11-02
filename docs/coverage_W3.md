# Coverage: W3 (the Heartroot Labyrinth's lower zones, the Rootsun Forge, Ch7B / Ch8 / Ch9)

Every row of W3's slice in the three audits, with its status now, where it lives and what tests it.

## How to read this

**Status** is one of:
- **Built**: now in the game in full.
- **Full (kept)**: the audit already found it complete. It was checked and left alone, or only touched up.
- **Changed (approved)**: an owner-approved change.
- **Contract**: deliberately left to another worker by the BUILD_OUT flag contract. The flag that hands it over is named.

**Paths** are relative to `game/Data/Scripts/998_FrostThaw/` unless they start with `tools/`. Line numbers are where the function or event starts at commit time.

**Tests:**
- **SR "…"** is a beat in `tools/headless/story_run.rb`. The run prints `OK` or `MISS` for it.
- **smoke "…"** is a check in `tests/smoke_test.rb`.
- **check_all** is the map checker run by `tools/build_all.sh`. It covers reachable arrivals, no bounce-back warps, invisible gates, switch range, and (new) trainers that would block a bridge.

**Maps (all new maps are W3's, IDs 2140–2155):**
- 2140 Mirror Garden
- 2141 Hollow Core
- 2142 Frozen Drop
- 2143 Vault of Amber Dreams
- 2144 Mirror Scriptory
- 2145 Mirror-Root Vault
- 2146 Barricade inner rooms
- 2147 Deep Root Shaft
- 2148 Rootwatch / training hall
- 2149 Umbound Chasm
- 2150 Root-Throne / Level 3
- 2151 vantage towers
- 2152 Avarice's sanctum
- 2153 Auroral Antechapel
- 2154 Sloughing Veins
- 2155 Echo Vault

**Builders:**
- `tools/build_ch7_deep.rb` builds 2140–2145, and reopens 2058 for the heart-wall.
- `tools/build_ch8_deep.rb` builds 2146–2155.
- The existing Forge maps 2072–2076 are rebuilt in `tools/build_ch8.rb`.

**Switches:** 4080–4100, 4087–4095 (all inside 4080–4119).

---

## Audit B: rootspire.md Tab 1

### Part IV-A: the Heartroot Labyrinth

| Row | Was | Status now | Where | Test |
|---|---|---|---|---|
| Labyrinth read-aloud intro | Full | Full (kept) | 025_Chapter7.rb:129 | SR "down into the Heartroot" |
| Dungeon purpose: third Frostshard Sigil, complete the White Vault map | Changed | Built. Contract for the third sigil. | The purpose is now told at the wells and in the Scriptory (033_Chapter7B.rb:315; 046_DeepLabyrinth.rb:800 `mirror_scriptory`: the White Womb, the plan). Map fragment 2 at the wells sets `:vault_map_2` (033_Chapter7B.rb:336). Fragment 3 and sigil 3 belong to W4 by contract (`:vault_map_3`, `:sigil_sephek`), so the Echo Vault does not hand out a duplicate sigil. | SR "SC 7B.06 three wells", "H21 the Mirror Scriptory" |
| H1 Root-Spiral Approach | Full | Full (kept) | 025_Chapter7.rb:124; tools/build_ch7.rb | SR "down into the Heartroot" |
| H2 Runic Seal Circle / Sap Wraith | Full | Full (kept) | 025_Chapter7.rb:140 | SR "SC 7B.05 the aurora seal" |
| H3 Warden's Overlook | Full | Full (kept). Also built: the homunculus and the ice mask (audit gap #1). | 025_Chapter7.rb:60. The Homunculus Core is in pod 4 (046_DeepLabyrinth.rb:641 `stasis_pod`). The ice mask is in 2145 (046_DeepLabyrinth.rb:983 `ice_mask`, sets `:ithryn_athis_clue`). | SR "H19 … the Homunculus Core", "H3 the Mirror-Root Vault: Ithryn Athis, and Var's echo" |
| H4 Rootguard Post | Full | Full (kept) | 025_Chapter7.rb:45 | SR "SC 7B.05" |
| H35 Captain's Alcove (not in B; D row 5) | — | Built | tools/build_ch7.rb:72 (Captain Hesk, the root-desk); 046_DeepLabyrinth.rb:158 `captains_alcove` | SR "H35 the Captain's Alcove" |
| H5 Threshold of Dripping Gold | Full | Full (kept) | 025_Chapter7.rb:224 | — (walked through on the way to 2058) |
| H6 Central Wells (failed-save psychic damage) | Full, minus backlash | Built | 033_Chapter7B.rb:315 `sap_well`. Backlash takes 10% from the party (line 327). All three wells give `:vault_map_2`. | SR "SC 7B.06 three wells" |
| H7 Overflow Channel | Full | Full (kept) | 028_Heartroot.rb:100 | SR "SC 7B.03 the child in the mirror" |
| H8 Whispering Attendant (its price) | Full, minus the price | Built | 033_Chapter7B.rb:345 `attendant`: "burn the forge" or "free the heart" sets `state[:attendant_promise]` and `:attendant_promise`. It is paid in the Echo Vault (046_ForgeRooms.rb:963, the Great Verdant Seed). Breaking it costs `:attendant_promise_broken` (034_Chapter8.rb:619). | SR "SC 7B.06", "H26 the Echo Vault" |
| H9 Petaled Threshold | Missing | Built | Map 2140; 046_DeepLabyrinth.rb:226 `scene_mirror_garden_enter`, :238 `petaled_threshold` | SR "H9 the Mirror Garden" |
| H10 Reflection Ring (worst selves, Mirror Clones, Verdant Seed) | Missing | Built | 2140 petal-gate (SW 4081). 046_DeepLabyrinth.rb:248 `reflection_petal` (WORST_SELVES for each Herald). :256 `reflection_ring`: cross without looking, or look and fight :298 `mirror_clone_battle`, a copy of your own party at −2 levels. FT_VERDANTSEED (+1 level). | SR "H10 the Reflection Ring" |
| H11 Shattered Bed (shard Avarice scries through; Mirror Shard Focus) | Missing | Built | 2140; :313 `shattered_step` (sets `:avarice_shard_lodged`, which Avarice quotes at 034_Chapter8.rb:371); :341 `shard_focus` gives FT_SHARDFOCUS | SR "H11 the Shattered Bed" |
| H12 Perfume Grotto (Lirielle's seeding; safe rest) | Missing | Built | 2140 (37,17); :364 `perfume_grotto` (rest point GROTTO_REST, `:grotto_boon`, which shields you from the whispers later) | SR "H12 the Perfume Grotto" |
| H13 Upper Root Bridge | Missing | Built | 2141 bridge x9–20; :383 `scene_hollow_core_enter` | SR "H13 the Hollow Core" |
| H14 Sap Burst Crossways | Missing | Built | 2141; :394 `sap_burst`, :412 `frost_vines`, :423 `crossways_construct` | SR "H14/H15 the crossways and the Cocoon Gallery" |
| H15 Cocoon Gallery (hag and Avarice cocoons; a captive warns) | Changed | Built in place. The pens version in Ch8 is kept as well. | 2141; :439 `gallery_cocoon` (hag remains; a captive who warns, `:core_warned`; a Wennen who blesses, `:gallery_boon`); :478 `gallery_sovereign` | SR "H14/H15 …" |
| H16 Frozen Drop (climb; time-lapse field) | Missing | Built | 2142; :509, :517 `mephit_swarm`, :527 `time_lapse` | SR "H16 the Frozen Drop" |
| H17 Underdark Mouth | Changed | Built in place | 2142, "The Underdark Mouth" and duergar miner Gelt | SR "H17/H34/H27 …" |
| H18 Amber Threshold (pods, twisted chant) | Missing | Built | 2143; :605 `scene_amber_vault_enter`, :620 `amber_sentries` | SR "H18 the Vault of Amber Dreams" |
| H19 Stasis Gallery (Homunculus Core, lab notes, Temporal Surge) | Changed | Built | 2143; :641 `stasis_pod` (pod 4 is the Core), :677 `stasis_notes` (the dragon/divine plan, plus the "Vessel IX" decoy clue, `:decoy_clue`), :697 `temporal_surge` | SR "H19 the Stasis Gallery" |
| H20 Dissectory Annex | Missing | Built | 2143; :709 `cataloguer`, :724 `dissectory_notes` (Auril-binding notes, `:knows_shard_origin`), :741 `autumn_crates` (`:autumn_labs_seen`), :754 `dissectory_golem` | SR "H20 the Dissectory Annex" |
| H21 Mirror Scriptory (war-room; Mirror-Ink Wraith) | Missing | Built | 2144; :800 `mirror_scriptory` (Wraith battle; flight plans, Xardorok, the White Womb), :850 `scriptory_pages`, :859 `scriptory_crystal` (FT_GLASSSIGIL, which opens the glass half of the forge door: :203 `labyrinth_forge_door`) | SR "H21 the Mirror Scriptory: the glass sigil", "SC 7B.08 the door of iron and glass" |
| H22 Auroral Antechapel (Shard ghosts; last parley) | Missing | Built | 2153; 046_ForgeRooms.rb:809, :821 `antechapel_guardians`, :834 `shard_echo` (four questions, `:shard_echo_heard`) | SR "H22 the ghost of the Shard", "H22/H33/H37 the Antechapel" |
| H23 Heart Chamber boss and the purify/preserve/destroy choice | Changed | Built. Glimmer's death stays (approved). | 2076 rebuilt (tools/build_ch8.rb:138). 034_Chapter8.rb:371 `scene_heart_chamber`, :432 lair actions, :538 `avarice_fight`; :669 `shard_battle` (the Frost Saint Shard boss, weakened by restored and broken spires); :619 `scene_heart_choice`: purify gives FT_SAINTSECHO and wheel +1, preserve gives the echo "The goddess still waits in the ice", destroy gives the Blessing of Verdant Fire. | SR "H23 the Frost Saint Shard rises", "H23 the Frost Saint Shard (…)" |
| H24 Breaking Circle | Missing | Built | 12 root-spires (tools/build_ch8.rb:153). 034_Chapter8.rb:450 `start_breaking_circle`, :466 `breaking_spire` (six actions, scour or break; Auril speaks at 4 restored, `:auril_heard_heart`), :506 `avarice_phase_two`. Avarice's party loses 8% HP per restored spire (034:538). The epilogue flags are `state[:circle_restored]`/`[:circle_broken]`. | SR "H24 the Breaking Circle (n restored, m broken)" |
| H25 Sloughing Veins | Changed | Built | 2154; 046_ForgeRooms.rb:926–956 (debris, mirror-spawn, the bridge that folds away); entered from 034_Chapter8.rb:741 `scene_launch` | SR "H25 the Sloughing Veins" |
| H26 Echo Vault (third sigil, higher Verdant Seed, tailored items, prophecy) | Missing | Built. The third sigil is Contract. | 2155; :993 `echo_vault_pods` (Great Verdant Seed, +3 levels), :1001 `echo_vault_items` (Verdant Fire Charm, Cycle of Roots, Mirror Lens), :1031 `world_tree_echo` (the prophecy and the personal-quest visions), :1066 the exit to Ch9. The sigil is W4's `:sigil_sephek` per BUILD_OUT. | SR "H26 the Echo Vault", "H26/H36 …", "H26 the Mirror Lens…", "the personal-quest visions" |
| Treasure & aftermath: Verdant Fire Charm, Cycle of Roots, personal-quest visions | Missing | Built | Charm (+20% Fire/Grass when held: 046_ForgeRooms.rb damage hook). Cycle of Roots heals the party once (UseFromBag). Visions: `ATTENDANT_VISIONS` at :1021, shown in `world_tree_echo`. | SR "H26 the Mirror Lens…", "the personal-quest visions" |
| Transition: the Labyrinth ends with the full White Vault map | Changed | Contract | `:vault_map_2` (W3) is set. The full map needs `:vault_map_3` (W4). | SR "SC 7B.06" |

### Part IV-B: relics touching W3's slice

| Row | Was | Status now | Where | Test |
|---|---|---|---|---|
| Blessings & Relics: Verdant Fire Charm, Cycle of Roots, Verdant Seed, Mirror Lens, Blessing of Verdant Fire | Missing | Built | RELIC_ITEMS in 046_ForgeRooms.rb (FT_VERDANTFIRECHARM, FT_CYCLEOFROOTS, FT_VERDANTSEED/FT_GREATVERDANTSEED, FT_MIRRORLENS). Handlers: the seeds level a Pokémon (046_DeepLabyrinth.rb). The Lens lets Normal and Fighting moves hit Ghosts (`pbCalcTypeModSingle` hook). The Blessing comes from the destroy choice and gives Fire/Grass ×1.1. | SR "H26 …"; smoke (full suite green) |
| Other IV-B rows (Meat Meat's blade and curse, Reptin's staff, Alerion's mantle, Alberica's key, Glimmer's shard, downtime, Festival, Research the Sigils, White Vault read-aloud) | various | Contract (W5 city and relics; W4 White Vault) | — | — |

### Tab-1 gaps in W3's brief

| Row | Was | Status now | Where | Test |
|---|---|---|---|---|
| Gap #5: Var Rime-Breaker's Tab 1 character (ancestor who served Naerth, Corsair arms deal, mirror-shard glaive, wanting to test Alerion) | Changed, not approved | Built. The coat twist is kept (owner decision). | 2145 "The liquid mirror": 046_DeepLabyrinth.rb:998 `mirror_pit` (the vision and the Var echo battle; gives FT_VARGLAIVE; sets `:var_story_known`, `:var_glaive`, `:corsair_arms_deal`). Avarice's intro calls back to it (034_Chapter8.rb:371). The Corsair arms ledger is in the root-vault relics (046_ForgeRooms.rb:770). | SR "H3 the Mirror-Root Vault: … Var's echo" |
| Gap #13: White Womb bug (Avarice's line had no set-up) | Bug | Built | Selrae says it first (033_Chapter7B.rb:395). The Scriptory explains it (046_DeepLabyrinth.rb:800). Avarice's parting curse is at 034_Chapter8.rb:712. | SR "SC 7B.07 Selrae, below" |
| Gap #2: Vault Map fragments | Compressed | Built (fragment 2); Contract (fragment 3) | 033_Chapter7B.rb:336 `:vault_map_2` | SR "SC 7B.06 three wells" |
| All other B rows (Parts I–III, factions, NPCs, merchants, dossier, the 20 new NPCs, surveillance enemies) | various | Contract (W5: Rootspire city) | — | — |

---

## Audit C: rootspire.md Tab 2 (the Forge)

Rows 1–48 and 53–73 (Glimmer's conversion, Reptin's training, the downtime week, rumours, the festival night) belong to W5 by BUILD_OUT ("downtime week, factions, NPCs, night events"). They are marked Contract and not repeated below. The rest are W3's.

| Row | Was | Status now | Where | Test |
|---|---|---|---|---|
| 49 Session recap | Full | Full (kept) | 026_Rootspire.rb:4 | — |
| 50 Truth of the Forge | Full | Full (kept) | 034_Chapter8.rb:314 | SR "SC 8.05 the Dragonforge" |
| 51 Duergar tunnelled in; leadership slaughtered; dragon bound in the Stones; "holy wound" | Compressed | Built | The thanes slaughtered "all six, in one night" (046_ForgeRooms.rb:244 `traitor_duergar`). The holy wound is at 034_Chapter8.rb:314 `scene_dragonforge`. | SR "A6 the traitor: the Great Unchaining", "SC 8.05" |
| 52 Level 3: burning sap, the hag's still-beating altar, sigils in the tree's memory | Compressed | Built | 034_Chapter8.rb:314 (the altar still beating, sigils into the tree's memory); 046_ForgeRooms.rb:403 `sapgate_controls`; Heartroot of command (2148) | SR "A15 the sap-gate controls" |
| 74 Council summons | Full | Full (kept) | 024_Chapter6.rb:439 | — |
| 75 Avarice's goal: burn the seasons, consume Ten-Towns, devour souls, supplant the Frostmaiden, merge with the Nine Hells | Changed | Built | 034_Chapter8.rb:371 ("every soul in the Dale is harvested warm, and I sit where the Frostmaiden sits… stitched to the Nine Hells"); the Ch9 soul harvest (035_Chapter9.rb:372); the Great Unchaining (046_ForgeRooms.rb:244); the Devil's Bloom patron (046_DeepLabyrinth.rb:886) | SR "SC 8.06 Summer (Avarice)…", "SC 9.05 the trap" |
| 76 "Xardorok" alias | Changed | Built | Kord: "Xardorok said you'd come" (034_Chapter8.rb:64, 139); the traitor (046_ForgeRooms.rb:244); Avarice: "The duergar call me Xardorok" (034:371); the Scriptory pages (`:knows_xardorok`). Her own face shows when Var's cracks (034:371). | SR "SC 8.01", "A6 …" |
| 77 A1 Rootgate | Full | Full (kept). A second way through: the traitor's lever. | 034_Chapter8.rb:147; 046_ForgeRooms.rb:271 `gate_lever` | SR "the Rootgate open (…)" |
| 78 A2 Echo Hall | Missing | Built | 2146; 046_ForgeRooms.rb:176 `echo_hall` | SR "A2 the Echo Hall" |
| 79 A3 Duergar guardhold | Full | Full (kept) | 034_Chapter8.rb:64 | SR "SC 8.01" |
| 80 A4 Flight-path model | Full | Full (kept) | 034_Chapter8.rb | SR "SC 8.01" |
| 81 A5 Avarice's quarters: mural, journal (Raz-MKIII, "Alberica", "fire must replace the rime"), effigy | Compressed | Built | 2146; :186 `avarice_mural`, :195 `avarice_journal` (all four lines), :214 `loose_floorboard` (the Ledger of Corruption, "Project Rime", `:ledger_found`), :230 `auril_effigy` | SR "A5 Avarice's quarters…", "A5 the mirror-root effigy" |
| 82 A6 The traitor duergar | Missing | Built | :244 `traitor_duergar` (`:knows_great_unchaining`) | SR "A6 the traitor" |
| 83 A8 Thruuna's dining hall | Full | Full (kept) | 034_Chapter8.rb:181 | SR "SC 8.02 mother's kitchen" |
| 84 Level 2 and A9 Deep Root Shaft (ribs, hag-spiders, the thump) | Compressed | Built | 2147; :291 `scene_deep_shaft_enter`; TEXT shaft_ribs/shaft_webbing | SR "A9 the Deep Root Shaft" |
| 85 A10 Guest quarters: the dragon limb, "Needs more frost essence. The goblin sample failed." | Compressed | Built | 2147; :321 `dragon_limb`, :327 `limb_notes` | SR "A10/A11 the dragon limb, and a future self" |
| 86 A11 Warden's bunker: lagging mirror, future self | Changed | Built | 2147; :305 `bunker_mirror` (`:future_self_warned`) | SR "A10/A11 …" |
| 87 A12–A18: sap golems, sap-lift, Rootwatch and Rootbreaker, sap-gate controls ("once a winter altar"), umber hulk, rust monsters, the crossbow root-keep | Missing | Built | 2148: :349 `training_hall` (A12); :360 `sap_lift` Root/Deep/Forge (A13; stops at 2072 (28,15), 2148, 2150); :380 `rootbreaker` (A14); :403 `sapgate_controls` (A15). 2149: :428 `umber_hulk` (A16), :440 `rust_feasters` (A17), crossbow keep trainers over the sap bridge (A18). | SR "A12 …", "A14 …", "A15 …", "A16 …", "A17 …"; check_all (bridge rule) |
| 88 Level 3 intro: fever, "a womb of iron, flame and frost", "something is trying to be born" | Missing | Built | 2150; :490 `scene_forge_womb` | SR "Level 3: the womb of iron" |
| 89 A19 Root-Throne: quaggoth and myconid ("Please… let me die") | Missing | Built | 2150; :503 `thruun_throne`, :513 `tortured_myconid` (mercy, or Wyn carries it out) | SR "A19 the Root-Throne…" |
| 90 A20 Broken root-works | Compressed | Built | 2150; :543 `broken_works` | SR "A21 the heart-fuel" (same visit) |
| 91 A21 Heart-fuel flasks | Compressed | Built | 2150; :555 `heart_fuel` (FT_FROSTFIREFLASK) | SR "A21 the heart-fuel" |
| 92 A24/A25 vantage towers: first sight of the dragon; Razzy reacts | Compressed | Built | 2151; :585 `vantage_west` (Razzilith panics; Glimmer's shard resonates), :605 `vantage_east` | SR "A24/A25 the vantage towers cleared" |
| 93 A26 Dragonforge proper | Changed | Built (the wearing-Var reveal is kept: owner decision) | 034_Chapter8.rb:314 (read-aloud), :371 (white hair, sigils, red-gold eyes, "my little failures") | SR "SC 8.05 the Dragonforge" |
| 94 Avarice's taunt | Compressed | Built | 034_Chapter8.rb:371 ("You survived my early prototypes… come home, to die in the womb that birthed you") | SR "SC 8.06 Summer (Avarice)…" |
| 95 Boss fight: lair actions, two Rootbreaker mechs, the dragon straining, a timer | Compressed | Built | 034_Chapter8.rb:432 `heart_lair_actions`; opening battle, then a double battle against two Infernal Rootbreakers (`:heart_mechs_won`); the circle's six-action timer; :538 `avarice_fight` (engine vents once on a loss) | SR "SC 8.06 Summer (Avarice): her opening and her mechs", "SC 8.06 Avarice" |
| 96 A27 Rootbeast pens | Changed | Built | 2074 rebuilt (tools/build_ch8.rb:80); 046_ForgeRooms.rb:450 `rootbeast_pens` | SR "A27/A28 …" |
| 97 A28 Prison root-cocoons: the Rootwarden's plea | Compressed | Built | 2074 prison pods 1–3; :467 `prison_pod` ("She's burning the seasons away… please… stop her…", `:prisoners_freed`) | SR "A27/A28 the rootbeast pens and the prison cocoons" |
| 98 A29 Mind-flayer corpse | Missing | Built | 2151 "Ritual circle"; :622 `mindflayer_corpse` (`:saw_mindflayer`) | SR "A29 the mind-flayer corpse" |
| 99 A31 False priest | Full | Full (kept), plus the disguise reveal and flight | 034_Chapter8.rb:335 `devil_priest` (`:devil_fled` with 3+ companions) | SR "the devil-priest (A31)" |
| 100 A32 Mirror-hall trap | Missing | Built | 2152 "Wrong reflections"; :650 `mirror_hall` | SR "A32 the mirror-hall trap" |
| 101 A33 Duergar barracks ("Fire replaces frost") | Compressed | Built | 2152; :666 `duergar_barracks` | SR "A34/A35 …" (same room run) |
| 102 A34 Tortured captain | Missing | Built | 2152; :684 `tortured_captain` (hints; saved with a potion, `:captain_saved`) | SR "A34/A35 the tortured captain and Mother Thruuna's chamber" |
| 103 A35 Thruuna's residual chamber | Compressed | Built | 2152; :716 `thruuna_chamber` | SR "A34/A35 …" |
| 104 A37 Avarice's root-vault ("Tomorrow, the dragon flies…"; the PC relics) | Missing | Built | 2152; :742 `vault_journal`, :770 `vault_relic` (broken frost-mirror, charred note, Razzy's scale, frozen rose, Var's glaive ledger) | SR "A37 Avarice's root-vault" |
| 105 Dragon launch | Full | Full (kept), expanded | 034_Chapter8.rb:741 `scene_launch` | SR "SC 8.09 launch" |
| 106 Avarice's escape: pillar of red-black flame; "We will speak again in the White Womb" | Full | Changed to the owner's canon: she fakes her death | 034_Chapter8.rb:705 `scene_coat_falls`: Hell's Veil, the curse line, a decoy body. The subtle clue is optional "Look more closely" with `:decoy_clue` → `:avarice_doubt`; a mirror splinter fogs once. Sets `:avarice_faked_death` and `:avarice_believed_dead`. She escapes after the fight, not at 25% HP mid-fight: a Pokémon battle can't stop part-way, and the source's own beat order (fight, then escape) is kept. | SR "SC 8.08 the coat falls off (she burns)" |
| 107 Glimmer's part (dies at the Forge) | Changed (approved) | Changed (approved) | 034_Chapter8.rb:561 | SR "SC 8.07 a better fire" |
| 108 Mechanical dragon: frostfire breath, sonic shatter, death burst | Compressed | Built | 035_Chapter9.rb:186 `chardalyn_dragon` (Ice Beam and Flamethrower for the frostfire, Hyper Voice for the shatter); :196 `DRAGON_TELLS` before each air battle (the shatter knocks 10% off your team); the death burst at the end of the Bryn Shander fight; the anatomy read-aloud before it (:372) | smoke "the Chardalyn Dragon breathes frostfire and shatters with sound"; SR "SC 9.03…", "SC 9.04…", "SC 9.05 the trap" |
| 109 Dragon lore: soul-echo methods tested on Razzy and Meat Meat; stolen dragon heart; Avarice's sigils; harvest souls | Changed | Built | Raz-MKIII and V-7 notes (046_ForgeRooms.rb:195; 034_Chapter8.rb:105); "an old wyrm's heart, stolen from the ice" (034:741, 035:372); the sigils as nails (035:372); the soul harvest (035:372, 034:371). The engine still burns Sephek's heart: that is a separate object, the Shard. | SR "SC 8.09 launch", "SC 9.05" |
| 110 Party reactions to the dragon | Compressed | Built | 034_Chapter8.rb:741: Razzy panics, Meat Meat screams, Alerion names Winter's Revenant frostcraft, Alberica's threads scream, Reptin's season spike, Glimmer's dagger hums; vantage reactions (046_ForgeRooms.rb:585) | SR "SC 8.09 launch" |
| 1–48, 53–73 | various | Contract (W5) | — | — |

---

## Audit D: rootspire.md Tab 3 (the Heartroot Labyrinth, H1–H37)

| Row | Was | Status now | Where | Test |
|---|---|---|---|---|
| 1 H1 / 2 H2 / 3 H3 / 4 H4 / 6 H5 / 8 H7 / 10 H8 | Full | Full (kept); H8's price is built (see B) | as in B above | as in B |
| 5 H35 Captain's Alcove | Missing | Built | tools/build_ch7.rb:72; 046_DeepLabyrinth.rb:158 | SR "H35 the Captain's Alcove" |
| 7 H6 Central Wells (fragments, backlash) | Changed | Built | 033_Chapter7B.rb:315–339 | SR "SC 7B.06 three wells" |
| 9 Vault Map (three fragments) | Compressed | Built (1 exists, 2 is W3's); Contract for 3 (W4) | 025_Chapter7.rb:235 (`:vault_map_1`); 033_Chapter7B.rb:336 (`:vault_map_2`) | SR "SC 7B.06" |
| 11–14 H9–H12 | Missing | Built | 2140 (see B) | SR "H9" … "H12" |
| 15 H13/H14/H16 Hollow Core | Missing | Built | 2141, 2142 | SR "H13", "H14/H15", "H16" |
| 16 H15 Cocoon Gallery | Changed | Built (see B) | 2141 | SR "H14/H15" |
| 17 H17 Underdark Mouth | Changed | Built in place (see B) | 2142 | SR "H17/H34/H27" |
| 18 H27 Root-Kin Barracks; H34 Lizard Nursery | Missing | Built | 2142; 046_DeepLabyrinth.rb:540 `lizard_nursery`, :563 `root_kin_barracks` (strike, fair fight or sneak with Wyn; SW 4082) | SR "H17/H34/H27 …" |
| 19 H18–H19 | Compressed | Built (see B) | 2143 | SR "H18", "H19" |
| 20 H20 Dissectory | Missing | Built | 2143 | SR "H20" |
| 21 H21 Scriptory | Missing | Built | 2144 | SR "H21" |
| 22 H28 Suffering Pods | Compressed | Built | 2143; :762 `suffering_pods` (Torturer construct), :771 `pain_pod` (`:pain_pods_freed`) | SR "H28 the Suffering Pods" |
| 23 H29 Guest Seed Nests (Muzgardt, infernal cultists) | Missing | Built | 2144; :875 `guest_nests` | SR "H29/H31 the guest nests and the Devil's Bloom" |
| 24 H30 Root-Lift Node | Missing | Built | 2144 Root-lift cage; :926 `root_lift_node` / :946 `root_lift_up`; the Guild Dig end (tools/build_ch7b.rb:62, SW 4083) | SR "H30 the Root-Lift Node" |
| 25 H31 Devil's Bloom (social test) | Changed | Built in place | 2144; :886 `devils_bloom` (bargain, refuse or break; the Nine Hells patron) | SR "H29/H31 …" |
| 26 H33 Hammer-Heart Workshop | Changed | Built in place | 2153; 046_ForgeRooms.rb:883 `hammer_heart` | SR "H22/H33/H37 the Antechapel" |
| 27 H22 Auroral Antechapel | Missing | Built | 2153 | SR "H22 the ghost of the Shard" |
| 28 H32 Thorn-Run Hall | Missing | Built | 2153 thorn triggers at x29 and x34; :877 `thorn_run` | SR "H22/H33/H37 …" (the walk to the golems crosses it) |
| 29 H23 Heart Chamber: the Shard boss, Auril's whispers, purify/preserve/destroy | Changed | Built (see B H23) | 034_Chapter8.rb:619, :669 | SR "H23 …" (both beats) |
| 30 H24 Breaking Circle | Missing | Built | 034_Chapter8.rb:450–537 | SR "H24 the Breaking Circle" |
| 31 H25 Sloughing Veins | Missing | Built | 2154 | SR "H25" |
| 32 H26 Echo Vault | Missing | Built (third sigil: Contract, W4 `:sigil_sephek`) | 2155 | SR "H26" (four beats) |
| 33 H36 Aurora Treasury | Missing | Built | 2155; 046_ForgeRooms.rb:1053 `aurora_treasury` (root-mimic) | SR "H26/H36 the tree's prophecy and the Aurora Treasury" |
| 34 H37 Silent Chapel of the Patron | Changed | Built | 2153 "Shrine of two sigils"; :895 `silent_chapel` (answer the frost, the fire, or break it) | SR "H22/H33/H37 …" |
| 50 GQ2 Purifying the Heartroot (steps 1–4) | Compressed | Built | (1) 025 seal; (2) wells and fragment 2; (3) the Mirror-Root Vault's Mirror Sentinels, 046_DeepLabyrinth.rb:964 `mirror_root_wards`; (4) the Shard choice, 034_Chapter8.rb:619 (Blessing of Verdant Fire, or the Saint's Echo) | SR "SC 7B.05", "SC 7B.06", "H3 the Mirror-Root Vault", "H23 …" |
| 35–49, 51–80+ (Sephek's escalation, character and group quests, Undercanopy, Ch10) | various | Contract (W4: Sephek, Ch10, Wyn's quests, rifts; W5: city quests) | — | — |

---

## Fixes found while testing (not audit rows)

- **MAPS[:sanctum]** was used by both Act I's sanctum (2045) and the Forge (2152). Act I was sending the player into the Forge after the Guardian's Gate. Renamed the Forge's key to `forge_sanctum`. Test: smoke "no two chapters register the same map name key".
- **Wild tables in 2140–2150 listed fusions.** Infinite Fusion fuses wild encounters itself (1 in 5), and a fusion of a fusion crashes `getFusionSpeciesSymbol`. They now list plain species. Test: smoke "no wild encounter table lists a fusion".
- **Trainers who would walk onto a plank bridge** (2141 Irrel, 2149 Hrem and Vosh, 2150 Kell and Morn) would stand there after the battle and block it. Their sight is now shorter, and there is a new check_all rule for it. It was proven by putting Kell back at sight 15, which check_all flagged.

## Test results at commit time

- `tools/build_all.sh`: all map checks passed (105 maps).
- `ruby tests/smoke_test.rb`: 168/173. The 5 failures are build assets missing from the worktree (gitignored): "and those pictures are shipped" and the four cup-game pictures. They pass on a full checkout.
- `story_run.rb` (full run, PIF_DIR=/home/claude/pifrun_W3): see the final report.
