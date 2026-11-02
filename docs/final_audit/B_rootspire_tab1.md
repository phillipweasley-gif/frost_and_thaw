# Final audit B: Rootspire Tab 1 (rootspire.md lines 1-3808)

Auditor B. Read only. I read all 3808 source lines in chunks of about 300, then the game code: 024, 025, 026, 027, 028, 029, 033, 034 (Heart Chamber), 046_DeepLabyrinth, 046_ForgeRooms (Zone VI), 047b/c/d (where they touch Tab 1), and all of 048_Rootspire_A-H. I also read the builders that place the Tab 1 content: build_ch6, build_ch6b, build_rootspire_life, build_ch7, build_ch7b, build_ch7_deep and build_ch8_deep.

Reachability checks:
- A script (scratchpad `bnotes/chk.rb`) confirmed that every `FT.xxx` function, `talk`/sign text key, cutscene scene and NPC text these eight builders place exists in the scripts. Nothing was missing.
- I opened the compiled maps (`build/maps/Map2050/2055/2056/2060/2061/2062/2145/2153/2155/2180/2188/2189`) and found the key events in them.
- For each gate I traced its switch or flag to the code that sets it.

I wrote this report before opening docs/reaudit. Afterwards I compared. All six "Missing" items and six bugs from the previous re-audit are now fixed: Glimmer's envoy, Sephek's "Prototype Verdant", Hew's compass, Eirwen's ledger dilemma, Hellen's passages, the Mira-possessed path, warden_map_seen, darrus_redeemed, the favour track, Mira's daughter, the Echo maze fallback, and Still Sky versus sap.

## 1. Summary

| Status | Rows |
|---|---|
| Full | 151 |
| Compressed | 9 |
| Changed | 9 (5 owner decision or follows a later tab, 1 integration choice, 3 neither, all minor) |
| Missing | 2 (both minor) |
| Unreachable | 0 |
| Bugs (separate list) | 7 (2 medium-low, 5 low) |

**Honest judgement:** Tab 1 is now covered faithfully and almost completely.
- **City:** every keyed location of Parts I-II is a real, reachable place or scene.
- **Factions and NPCs:**
  - All seven factions of Part III have their scenes.
  - All 14 major NPC profiles have their secrets, and each secret can be played.
  - All 18 shops are open, with their keeper, read-aloud line and rumour.
  - All 10 night events, the 6 down-the-root hooks, the 12 faction vignettes and the 12 solo-ambient events are present.
  - All 20 new NPCs are placed and have their reveals, and all 10 watchers can be caught.
- **Dungeon:** H1-H26 and the Mirror-Root Vault are built as real maps, with every keyed beat.
- **Relics and transition:** the five relic discoveries keep their trials and lore lines, and the White Vault merge read-aloud is verbatim.

What is not Full is minor: a few changed beats that follow later tabs or owner decisions, two missing flavour lines, and a handful of continuity bugs. Nothing story-bearing is cut short and nothing is unreachable. The most visible problem is continuity. Selrae (who has vanished below by then) and Eira Voss (who has been arrested by then) still turn up in scenes that come after.

## 2. Every row that is NOT Full, ranked by importance

### Bugs

**B1 (medium-low). Selrae speaks in scenes she can't be in.** After the Rite, her Council seat is empty: the text reads "Her fur-trimmed cloak still hangs on it" (024_Chapter6.rb:144). She is down in the Sap Wells, and later in a cocoon (033:461-496, 034:286). She only comes back if the player chose `selrae_home` or rescued her.
- Evidence (scenes with no gate on her return):
  - The heist exposure at the Council table has "SELRAE: Little things. Like a dig under the Heartroot" (048_Rootspire_D_Quests.rb:924).
  - Eirwen's ledger choice has "SELRAE: (behind her, very dry)..." (048_Rootspire_H_Faithful.rb:341). Its only gate is `wardens_emeritus` (048_H:309).
  - The Winter "trusted" boon has Selrae at the Hearth's back door (048_H:517).
- Contrast: `council_petitions` handles her absence correctly with "her deputy" (048_G:104).
- Fix: gate each line on `!flag?(:rite_stopped) || flag?(:selrae_home) || flag?(:selrae_rescued)`. Otherwise give it to the frost-bearded deputy from 048_G:104.

**B2 (medium-low). Eira Voss is arrested, then keeps selling.** Beating her in the Frozen Cellar sends her off with the Rootwardens, still whispering backwards (048_D:992-1002).
- Evidence: her black-market event in the Still Sky Shrine has only two pages, blank and `SW_RITE_STOPPED` (build_ch6.rb:295-296). `eira_black_market` never checks `:cellar_cleared` (048_B:268-282). So she is still behind the counter afterwards.
- Fix: after `cellar_cleared`, have a disciple run the market ("Sister Voss is with the Rootwardens. The tithe is still the tithe."). Either add a third page on a new switch, or branch at the top of `eira_black_market`.

**B3 (low). Selrae "says the White Womb aloud for the first time" twice.** If Shade or Glimmer is present at the first Council session, `selrae_court` has her name the vault "The White Womb" there (048_D:420) and sets `:selrae_white_womb`.
- Evidence: in the Sap Wells she then says it again with "I never thought I'd say it aloud" (033_Chapter7B.rb:475). That line never checks the flag.
- Fix: branch on `:selrae_white_womb`, for example: "The White Womb. I said it to your Sparkbearer once, to frighten him. Now I'm frightened."

**B4 (low). Kethan's reveal sends you to the wrong district.**
- Evidence:
  - The reveal says "the Warden on the civic ring's south steps. Ash." (048_D:320).
  - "Civic ring" is the Verdant Halls, map 2180 (048_E:509).
  - Ash actually stands in the Trunk-Tier Bazaar: map 2050, (28,25) (build_ch6.rb:117-121).
- Fix: change the line to "the Warden by the Bazaar's south lane, near the Hearth", or move Ash's trainer to 2180.

**B5 (low). Kelyn can borrow a relic you don't have.** Option 0, "Lend her a relic", always runs `kelyn_surge` (048_D:89-93), even with no relic in the bag. Her plea names "the staff, the blade, the key".
- Fix: offer the option only if one of FT_VERDANTBLADE, FT_UNBONDEDSTAFF or FT_HEARTWARDENSTAFF, FT_WHISPERKEY or FT_RIMEMANTLE is held. Name the lent relic in the surge text.

**B6 (low, dead code). Gates that can never fire.**
- `:met_kelyn` and `:met_rheven` are read (048_E:256, :258, :542) but never set anywhere. Each condition has a working fallback (`wardens_emeritus`, `still_beast_asked`/`rs_day>=5`, `met_ysera`), so nothing is lost.
- `:suncleft_open` is never set (048_G:175). The door works anyway, because `suncleft_door` sets the switch directly (048_B:602).
- Fix: set `met_kelyn` in `kelyn` and `met_rheven` in the `rheven` text. Have `suncleft_door` also `set_flag(:suncleft_open)`.

**B7 (trivial).**
- `WATCHER_SPOTS[:ember_rat]` says `[2052, 3, 9]` (048_A:237), but the event is at (5,9) (build_ch6.rb:151). The table is never read. Fix: correct it or delete it.
- The dossier revised NPC races to "Icewind Dale races + Wennen only" (source 2808). The game applies that to Bryn (human), Kethan (goliath) and Jast (gnome), but keeps the compendium's aasimar Ysera (048_B:237) and eladrin Lumea (048_B:165). The dossier makes them half-elf (2899) and high elf (2975). Fix: two words.

### Missing

**M1 (minor). Mira's line "The Vault stirs. You should see what you began."** (source 1073).
- Evidence: Mira speaks for Avarice in plural (048_C:641-660, 033:315-322), but this line appears nowhere. A grep of the scripts finds no match.
- Fix: give it to the cold voice on the Requiem (033:319), or to the possessed Mira's farewell (033:382).

**M2 (minor). Hew's comic relief turning to horror "if the construct awakens during a siege"** (source 1177).
- Evidence: Prototype 3 only kneels and prays in the Guild Dig (033:159-182), and the construct is never mentioned again (grep). The Avarice code fragment *is* paid off: the Root-Compass wakes in Ch8 (034:153-172).
- Fix: in the Ch9 dragon siege, a short beat where Prototype 3 climbs Hew's ladder screaming "Father is burning". It ends gently if `:construct_kept`, or badly if it was shut down.

### Changed

**Ch1 (neither, but backed by the source).** The Heartroot is meant to yield "the third Frostshard Sigil, completing the map" (src 1235, 1571, 1624), but the Echo Vault (H26) holds no sigil (046_ForgeRooms.rb:1011-1028). The third sigil drops from Sephek in Ch11 (047c:180-184; fallback 039:380-384). Source line 1052 ("His defeat drops a Frostshard Sigil") supports this.
- Consequence: finishing the Labyrinth doesn't complete the map. The merge read-aloud is held back to the Ch11 Council (037:236-241) or the Echo maze (047b:340).
- The "rune puzzle opens a conduit toward the glacier fields" (src 540) is replaced by the sigil merge in the same way.
- Acceptable. If the owner wants the source's order, put a fragment-hint in H26 ("a socket shaped for a sigil, empty: someone took it north").

**Ch2 (follows later tabs).** In Tab 1, Eline's Manifest Rite at Cycle Day mixes World-Tree sap with Sephek's crystal heart "to give Auril flesh" (src 1013, 664, 678). In the game:
- Eline has already given the heart to Summer (024:675-679).
- The Rite of Stillness on the festival's first night is "cool the tree" (024:663-698).
- On the seventh night, the Cycle Day conspiracy, if lost, makes Auril's Icy Avatar manifest at the Shrine (048_H:147-229).

The goal (Auril manifesting at the festival) survives, and the heart-to-engine line matches Tab 2/3.

**Ch3 (the source contradicts itself; the game follows the later tab).**
- Part II-B gives the *Blessing of Verdant Fire* for destroying the Shard (src 526).
- The game grants it for sanctifying the Shard (034_Chapter8.rb:686-716), as GQ2 does.
- "Leave it whole" keeps "The goddess still waits in the ice" verbatim (034:737).

**Ch4 (owner decision).** Var Rime-Breaker is not a sitting member of the four-seat Council (src 583). He is "missing seven days" and his Summer throne stands scorched (024:578-586). His own story is restored in the Mirror-Root pit (046_DeepLabyrinth.rb:1024-1077): Naerth's soldier ancestor, the Corsair arms deal, wanting to test Alerion, the mirror-shard glaive, and Avarice taking his body.

**Ch5 (integration choice).** Darrus "if exposed, flees to the Corsairs" (048_D:925-926, hiding at 2198) and "may seek redemption by financing the White Vault expedition" (`darrus_redeemed`, read at 037:259, 038:137 and 047d:846). This is faithful. Maera taking Autumn's place at the Forge (048_B:656-662) is the integration choice; it does not betray the source.

**Ch6 (follows later tabs).** The source's tone and Cycle Pulse ("verdant by day, frozen by night", four dawn colours, src 48, 142) become a 30-year gold summer: `dawn_hue` (048_E:181-190) shows the other colours only after Tree Communion or the summer's end. This is Tab 2's story.

**Ch7 (neither, minor).** Selrae courts the Sparkbearer at the first Council meeting (048_D:406-427), usually while that person is still Shade, with the Rimefang as the hook. The source has her court Glimmer.

**Ch8 (neither, minor).** Two placements move from the 20-NPC list:
- Felka (source: Heartroot outer ring) stands at the sealed Root-Gate in the market (build_ch6.rb:130).
- Dathra (source: Root-Tier Curiosity Row) is in the Sap-Works (build_ch6.rb:150).

Both are reachable and fit the story.

**Ch9 (owner decision).** Eline's fates are mercy (martyr) or binding (backwards prayer), or, unbeaten, a final foe (047c:563-610). This matches the brief exactly.

### Compressed

- **C1. Selrae's black-ice dagger** whispers to Auril "if it draws blood" (src 883). In the game it whispers when crystal-light touches it (048_D:417-418). No blood.
- **C2. Selrae as "villain or redeemable ally depending on whether she destroys or embraces the cult"** (src 885). The game's fork is home or ahead, then rescue and the Trials (033:476-487, 034:286). Her choice about the cult itself is never posed.
- **C3. Glimmer's Lumen Shard attunement** (src 1802-1812). The Con-save hour in the Rift becomes seven years behind Brightmane's glass (029:66-118), which is good.
  - Kept: the read-aloud, the shadow's question and the inscription are verbatim.
  - Lost: "your shadow sometimes moves a moment late, speaking prophecy in reverse".
  - Fix: one Glimmer line in a later chapter.
- **C4. H1 (Part II-B) Root-Gate**: "shapes flicker inside the frozen sap, too human to be knots" (src 477). The gate is reduced to a willow seal plus the knocking door (025:58-59, 116-118).
- **C5. "Echo of Saint Kaltro"** (src 676): cultists recovering fragments of Sephek's heart. Here the heart was handed to Summer before play (024:675). The Halo's later hunt for it is folded into the Ch8 engine.
- **C6. Rheven "may lead the expedition that first uncovers the Avarice machinery"** (src 914). Var and Selrae go down; Rheven stays topside. His creed question, his dreams and his "burn it out" threat are all present (048_D:139-180).
- **C7. Hellen's family prophecy** "The Heralds will drink once more before the seasons turn" (src 983). It exists only as the cellar sign (026:262). Hellen never says it.
- **C8. Rootwardens: "about 200 members", and Rheven suspecting an infiltrator** (src 621, 631). The infiltrator plot belongs to Kethan instead (048_D:282-347), as the dossier has it (src 2939). Rheven never voices suspicion.
- **C9. Sky-Path caravans with frost-fire lanterns** (src 135). Only the sign "The Sky-Path, to the Auroral Wall" and a pilgrim trainer remain (026:252, build_ch6b.rb:94).

## 3. Full table

F = Full, C = Compressed, Ch = Changed, M = Missing. File:line references are under game/Data/Scripts/998_FrostThaw unless they start with build_ (tools/).

### Part I - Origins and geography
| Src | Element | St | Evidence |
|---|---|---|---|
| 13-19 | Arrival read-aloud | F | 024:259-277, nearly verbatim; cutscene build_ch6.rb:94 |
| 23-32 | Timeline of Renewal (5 eras, Heralds of Dawn and Dusk) | F | 048_G:7-13 timeline_wall (build_rootspire_life.rb:136); Hellen 024:322 |
| 36-48 | Nature: triune council Growth/Memory/Balance, Rootwardens, faiths, economy | F | Kelyn 024:621; relic fish 048_C:538; Cycle faith via Lumin/Selene |
| 48 | Tone: verdant by day, frozen by night | Ch | Ch6 |
| 55 | Concentric tiers and causeways | F | 2050/2055/2061/2180/2189, root-lift, leaf-bridge |
| 57-73 | Root-Tier: Undercity, Split Dock, Still Sky Shrine, Echo Gate | F | 2055, 2056; ATMOSPHERE 048_E:507 |
| 76-92 | Trunk-Tier: Bazaar, Rooted Hearth, Council Hall | F | 2050-2054 |
| 95-111 | Canopy-Tier: Twinned Dragons shrine, Library, Celestial Rift | F | 2061, 2062 |
| 114-122 | Heartroot -40ft, constructs in mirror-glass roots | F | 2057-2058, 2140-2145 |
| 127-135 | Terrain: Auroral Wall, Glasswater (mismatched stars), Blooming Fields | F | 048_E:507-508; 2060; 026:256 |
| 135 | Sky-Path caravans | C | C9 |
| 142 | Cycle Pulse | F/Ch | dawn_hue 048_E:181 (Ch6) |
| 144 | Auroral Echoes, chronal songs | F | Echo Codex 048_F:726-753 |
| 147 | Verdant Storm wakes the frozen dead | F | night_verdant_storm 048_E:429-438 |

### Part II-A
| Src | Element | St | Evidence |
|---|---|---|---|
| 198-215 | R1 Split Dock read-aloud, dockworkers, Smuggler's Run | F | 024:639-649; 2198 |
| 215 | Two Corsair crews crystallised mid-oar, Sephek's mirror-ice | F | 024:88-95, 112-115 |
| 220-235 | R2 Still Sky Shrine: freshly cut statue eyes, Eline's vigil, steal sap | F | 024:99-101, 651-661 |
| 232 | "The Frost Saint walks again" runes | F | 024:109-111; 026:1311 |
| 235 | Blessing of Warmth | F | shrine_cleanse 026:1305-1322 |
| 240-252 | R3 Echo Gate: names whispered, "The lake remembers" | F | echo_wraiths 026:1268-1300; Krolf 048_C:390 |
| 250-252 | Frost Saint's Sigil, 2 Mirror Wraiths spelling VAULT | F | 026:1281-1292 |
| 266-284 | T1 Bazaar: microclimates, Tarin, Mira's scrying mirrors | F | 048_E:502-504; 024:298; 048_C:635-662 |
| 284 | Child possessed by a mirror; twin in the Heartroot | F | 048_C:664-723; 033:237-302 (2067) |
| 289-311 | T2 Rooted Hearth, murals, d6 rumours, Hellen insists they stay | F | 024:317-345, RUMOURS 024:550-558 (all 6) |
| 315-334 | T3 Council Hall read-aloud, three councillors, expansion debate | F | 024:576-635; council_heart 024:149 |
| 334 | Forged decree, Avarice's sigil in the wax | F | 024:586-588; harget_decree 048_C:482-493 |
| 339-347 | T4 Spire Armory, Rheven, Still Beast hook | F | 2183; armory_targets 048_B:38; 048_D:185-235 |
| 354 | Hook: mirrors spread Avarice's awareness | F | Mirna's letters 048_C:358 "Every glass is an eye" |
| 356 | Hook: the Winter Matron funds the Halo | F | 048_D:395-401, 446-448 |
| 358 | Hook: Cycle Day effigy | F | cycle_day_conspiracy 048_H:147-229 |

### Part II-B
| Src | Element | St | Evidence |
|---|---|---|---|
| 380-395 | C1 Shrine of the Twinned Dragons, orb, Cycle Canticle | F | twin_orb 026:855-889 |
| 393 | Dream-vision from the wyrmlings | F | bloom_guard_visions 026:900-968 |
| 395 | Halo splinter channelling Auril into Frostina | F | orb_halo_scene 048_D:46-64 |
| 400-414 | C2 Library: Eirwen, Naerth's ledger, Alberica's handwriting | F | 026:340-372; 048_H:311-348 |
| 419-433 | C3 Celestial Rift, Frostfell portals, ice-winged angels with Avarice's mark | F | 048_E:378-390, 442-457 |
| 438-448 | C4 Aerie: sky-sailor duels, Aarakocra Seer, Auroral Motes | F | build_ch6b.rb:144-148; 026:286-297 |
| 455 | Library prophecy "Frost Saint will climb the Spire when the roots bleed" | F | 048_G:14-17; 026:1102 |
| 457 | Winter Matron wants martial law on the Canopy | F | 024:622-624 |
| 459 | Glimmer's Trial: celestial envoy, hope or judgment | F | glimmer_envoy 048_H:234-276 |
| 473-481 | H1 Root-Gate: braided roots, shapes in the sap | C | C4 (season-rune puzzle present, 025:161-219) |
| 481 | Sap Wraith, radiant purge | F | 025:180-190 |
| 486-492 | H2 Sap-Wells: heal, visions, 3 Vault Map fragments | F | sap_well 033:395-423; vault_map_1/2/3 (025:235, 033:419, 047b:663) |
| 497-513 | H3 Mirror-Root Vault: read-aloud, ice mask, first homunculus | F | 046_DL:955-1020 (map 2145) |
| 509 | Skill challenge, Mirror Sentinels | F | mirror_root_wards 046_DL:976-1007 |
| 511 | Clue to the Vault of Ithryn Athis | F | ice_mask 046_DL:1015-1019 |
| 513 | Pit = stepping across time | F | mirror_pit, Var's night 046_DL:1024-1077 |
| 518-528 | H4 Heart Chamber: Shard re-forms; destroy gives blessing; leave it and "goddess still waits" | F/Ch | 034:686-745 (Ch3) |
| 536 | Avarice's devices drain the tree; Reptin senses it | F | tree_communion 048_D:642-663 |
| 538 | Verdant Sickness: sap turns black | F | whispering_sapling 048_E:664-676; Bryn 048_B:102-111 |
| 540 | Rune puzzle opens a conduit to the White Vault | Ch | Ch1 |
| 545-553 | Cycle Day festival read-aloud, cult's manifestation | F/Ch | 048_H:149-152; avatar 207-229 (Ch2) |

### Part III-A - Factions
| Src | Element | St | Evidence |
|---|---|---|---|
| 569-585 | Council: symbol, motto, four seats | F/Ch | 024:618-619; Var (Ch4) |
| 589-593 | Kelyn vs Selrae; Darrus's corruption; Selrae shelters the Halo | F | 024:625-631; 048_D:922; 048_D:397 |
| 598 | "A Season Too Long" (Rootwarden ritual gone wrong) | F | kethan_business 048_D:298-306 (Rite of the Long Gold) |
| 600 | "The Frozen Edict" | F | harget_decree 048_C:482 |
| 602 | Political Favour Track | F | favour/favour_tick/rivalry 048_E:474-489, 048_H:510-580 |
| 611-617 | Rootwardens: symbol, creed | F | 048_B:19; 026:203 |
| 621-625 | 200 members, Claw/Bough/Seed circles | C/F | trainers Hode/Teo/Ama, 048_A:159-162 (C8) |
| 629 | Bough dead reanimated by constructs | F | still_beast 048_D:203-235 |
| 631 | Rheven suspects an infiltrator | C | C8 |
| 636 | Still Beast hook | F | 048_D:185-235 |
| 638 | Oath of Roots | F | oath_pillar 048_D:239-278 |
| 643-656 | Halo: symbol, Still Sky Shrine, Frozen Cellar under the brewery | F | 048_B:49; 2188, 048_D:966-1003 |
| 659-670 | Halo beliefs, fallen Rootwardens, mirror tokens | F | Ash 048_D:327-347; 048_E:373 |
| 676 | "Echo of Saint Kaltro" | C | C5 |
| 678 | "Rite of Stillness" | F/Ch | 024:663-698 (Ch2) |
| 680 | "Selrae's Secret" | F | 025:102-105; 033:461-496 |
| 689-700 | Corsairs: symbol, Mira as captain, Boreal Requiem, scale core | F | 048_C:744-746; 048_D:487-506 |
| 706-710 | Mirror, Mirror; Frozen Run; alliance and naval aid | F | 048_C:664; 048_D:508-556; corsair_favour |
| 719-727 | Guild: symbol, mines, missing diggers, sentient sap fuel | F | 048_D:875; 033:105-130; amber_assessor 048_D:669-692 |
| 732 | "The Amber Experiment" | F | 048_D:669-692 |
| 734 | "Sabotage at the Mine" | F | sap_cache 033:132-157 |
| 739-752 | College: Wynsnow, chronal anomalies, Lecture in Blue Fire, Chronal Debt | F | 026:790-848; 048_D:454-482 |
| 757-774 | Intrigue web leading to the Labyrinth and White Vault | F | (structure) |

### Part III-B - Major NPCs
| Src | Element | St | Evidence |
|---|---|---|---|
| 784-806 | Kelyn: grief, fear of Auril, Razzilith's dreams, Wardens Emeritus, mural, betrayal hook | F | 024:589-600; kelyn_orb/surge 048_D:72-130; kelyn_mural 048_D:28-32; Pellar 048_C:343-351 (B5) |
| 811-833 | Var: ancestry, test of Alerion, Corsair deal, glaive | F/Ch | 046_DL:1034-1077; glaive_resonates 047c (Ch4) |
| 838-860 | Darrus: clove bark, relic sales, blackmail, Meat Meat's heist, flight, redemption | F | 024:582; 048_D:789-960 |
| 865-887 | Selrae: Halo patron, courts the vessel, dagger, villain or ally, "White Womb" | F/C/Ch | 048_D:392-427; 033:461-496 (C1, C2, Ch7, B3) |
| 892-914 | Rheven: dreams, hungry root, Reptin's counsel, direwolf | F | 048_D:139-180; 026:215-217 |
| 914 | Rheven leads the expedition | C | C6 |
| 919-939 | Eirwen: ledger, publish dilemma, chronal leaves, sigil custodian, relive a day | F | 048_H:311-348; 048_D:569-623 |
| 944-964 | Aldric: anchoring, offer to Glimmer and Alberica, temporal wight | F | 048_D:454-482; 026:827-848 |
| 969-991 | Hellen: shrine, recognition, low-violence errands, passages | F | 024:317; 048_H:354-475; build_ch6b.rb:47-56 |
| 983 | Hellen's family prophecy | C | C7 |
| 1002-1024 | Eline: conversion of Glimmer and Selrae, backwards prayer, circle to the Heartroot, foe or martyr | F/Ch | eline_conversion 048_D:432-449; 047c:563-610; eline_circle 048_H:47 (Ch2, Ch9) |
| 1029-1054 | Sephek: pilgrim visions, "Prototype Verdant", Alerion as rival, reforming, sigil, redemption | F | 047d:481-497; 047c:150-189; 039:376-384 |
| 1059-1081 | Mira: plural speech, scrying shards, mirror-core, possessed path becomes Avarice's body, naval aid | F | 048_C:635-662; 033:307-384; 047c:353-442 |
| 1073 | "The Vault stirs..." line | M | M1 |
| 1086-1108 | Avarice Reforged: crystal body, Seraph-Draco, "variables", body like the Mirror Mother, birth-cries | F | 047c:325, 362; 048_E:303-307 |
| 1113-1133 | Lorn Scribe: backwards writing, works for the tree, riddles, ink, journal pages | F | 026:358-364; 048_F:583-601 |
| 1138-1158 | Eren: gift of memory, Alerion's soul, pupil or mirror, Frostina-scale bow | F | eren_armory 048_D:353-385 |
| 1163-1177 | Hew: Prototype 3 "Father", device with an Avarice code fragment | F | 033:159-221; 034:153-172 |
| 1177 | Hew: horror in the siege | M | M2 |
| 1181-1192 | Still Ones: four virtues, verdant or frost lean | F | still_one 026:1327-1387 |

### Part IV-A - Heartroot Labyrinth
| Src | Element | St | Evidence |
|---|---|---|---|
| 1221-1225 | Read-aloud ("The stairwell breathes...") | F | 025:129-133 |
| 1235 | Purpose: the third sigil | Ch | Ch1 |
| 1250-1262 | Six zones | F | captains_alcove 046_DL:158-172; maps 2057-2155 |
| 1273 | H1 Root-Spiral, knocking heartbeat | F | 025:58-59, 124-138 |
| 1282 | H2 Runic Seal, Sap Wraith, vision at 0 HP | F | 025:161-219 |
| 1289 | H3 Warden's Overlook, two-script phrase | F | 025:60-63 |
| 1298 | H4 Rootguard Post, infernal tools, enthralled guards | F | 025:64-66; thralls build_ch7.rb:62-65 |
| 1311 | H5 Threshold of Dripping Gold | F | 025:224-232 |
| 1320 | H6 Central Wells | F | 033:395-423 |
| 1327 | H7 Overflow Channel: slide, bones, fragment | F | build_ch7b.rb:68-131; 025:235-246 |
| 1342 | H8 Whispering Attendant, burn-or-free bargain | F | 033:425-456; payoff 046_FR:980-994 |
| 1356 | H9 Petaled Threshold, lagging reflections | F | 046_DL:238-245 |
| 1365 | H10 Reflection Ring, clones, Verdant Seed | F | 046_DL:256-310 |
| 1369 | H11 Shattered Bed: lodged shard, Shard Focus | F | 046_DL:313-361 |
| 1384 | H12 Perfume Grotto, Lirielle echo | F | 046_DL:364-378 |
| 1403 | H13 Upper Root Bridge | F | 046_DL:383-392 |
| 1412 | H14 Sap Burst Crossways, frost vines | F | 046_DL:394-429 |
| 1427 | H15 Cocoon Gallery: hag and Avarice cocoons, sovereign, captive's warning, boon | F | 046_DL:432-507 |
| 1442 | H16 Frozen Drop, time-lapse | F | 046_DL:509-537 |
| 1455 | H17 Underdark Mouth, duergar, spoor | F | build_ch7_deep.rb:131-133 |
| 1472 | H18 Amber Threshold, chant, glitches | F | 046_DL:605-629 |
| 1481 | H19 Stasis Gallery: Homunculus Core, lab notes, Temporal Surge | F | 046_DL:641-706 |
| 1488 | H20 Dissectory: cataloguer, failed bindings, Shard as success | F | 046_DL:709-759 |
| 1503 | H21 Mirror Scriptory: plans, allies, Mirror-Ink Wraith | F | 046_DL:792-872 |
| 1522 | H22 Antechapel: talking to the Shard's ghost | F | 046_FR:830-883 |
| 1537 | H23 Heart Chamber, three endings | F | 034:686-745 |
| 1541 | H24 Breaking Circle, 12 spires, epilogue | F | 034:510-560 |
| 1554 | H25 Sloughing Veins, mirror-spawn | F | 046_FR:936-971 (VEINS_ARRIVAL 034:859) |
| 1563 | H26 Echo Vault: higher seed, items, tree prophecy | F | 046_FR:1003-1078 |
| 1571 | H26 third sigil | Ch | Ch1 |
| 1611-1617 | Verdant Fire Charm, Cycle of Roots, per-PC visions | F | 046_FR:1018-1077 |

### Part IV-B - Relics, downtime, transition, appendix
| Src | Element | St | Evidence |
|---|---|---|---|
| 1635-1638 | Meat Meat's blade: driftwood chest, "Subject V-7" | F | 026:1135-1170 |
| 1646 | Trial: "weapon or seed?" | F | 026:1153-1164 |
| 1662 | Blade's curse: prototype faces | F | 048_G:193-203 |
| 1664-1667 | Eirwen's "On The First Reversal" quote | F | 048_F:327-329 |
| 1673-1700 | Reptin's staff: crypt, totem, Wall trial, inscription | F | 026:1172-1207; 048_H:480-504; 026:395 |
| 1714-1752 | Alerion's mantle: frozen hunter, "Finish the step", catch-not-kill, Boundary Stone | F | 026:1389-1436; 026:253 |
| 1758-1787 | Alberica's key: sub-vault, Canticle, spectral bards, Verse XI | F | 026:973-1115; 048_H:281-307 |
| 1793-1818 | Glimmer's Lumen Shard: question, sinks into the chest, inscription | F | 029:66-118; 026:336 |
| 1802-1812 | Lumen trial and late shadow | C | C3 |
| 1828 | Downtime: research the sigils | F | 048_D:626-638 |
| 1830 | Council petitions | F | 048_G:96-132 |
| 1832 | Tree Communion | F | 048_D:642-663 |
| 1834 | Festival of Balance, safe haven | F | 048_G:134-149 |
| 1841-1847 | White Vault transition read-aloud | F | 047c:103-123 (verbatim) |
| 1855-1861 | Blessings and relics table (Charm, Cycle, Seed, Mirror Lens, Verdant Fire, Still Sky) | F | 046_FR:1022-1025; 034:707; 026:1385 |
| 1867-1873 | Base of operations; factions decide who goes north | F | rootspire_haven; voyage_route 037:257 |

### Merchant and Downtime Compendium (18 shops)
| Src | Shop / keeper / rumour | St | Evidence |
|---|---|---|---|
| 1889-1899 | Temporal-bubble economy, districts, black market | F | 048_A:108-146 |
| 1931 | 1 Run and Bloom, Bryn, corks line, stolen rebirth sap | F | 048_B:93-118 (2181) |
| 1980 | 2 Sap-Smith, Gorran, "Fire remembers...", voices in the flame | F | 048_B:131-157 (2052) |
| 2029 | 3 Auroral Atelier, Lumea, escaped illusion | F | 048_B:162-194 (2190) |
| 2078 | 4 Glasswater Outfitter, Tirena, shifting maps, compass | F | 048_B:199-213 (2182) |
| 2125 | 5 Library counter, Solvaran, codex under the floor, Echo Codex | F | 048_B:218-229 |
| 2172 | 6 Shrine of Balance, Ysera, "soul-flow is blocked", dragon of light | F | 048_B:234-263 (2191) |
| 2219 | 7 Still Sky black market, Eira, "Perfect stillness", cursed goods | F | 048_B:268-306 (B2) |
| 2266 | 8 Rootwarden Hall, Kethan, hammering under the Heartroot | F | 048_B:311-331 (2183) |
| 2313 | 9 Ink and Ember, Mirna, Avarice's mirror-glass letters | F | 048_B:336-366 (2192) |
| 2358 | 10 Crystal Quill, Filgen, scrolls whispering names | F | 048_B:371-391 (2193) |
| 2403 | 11 Gem and Thorn, Arvoss, vibrating gem | F | 048_B:396-413 (2184) |
| 2448 | 12 Perfumed Root, Lirielle, prophetic fire scent | F | 048_B:418-441 (2185) |
| 2493 | 13 Verdant Stables, Thim, "heard the tree cry" | F | 048_B:446-476 (2196) |
| 2538 | 14 Mirror-Dust, Jast, shards for the collector | F | 048_B:481-523 (2197) |
| 2583 | 15 Auroral Arms, Brogar, humming arm | F | 048_B:528-541 (2186) |
| 2628 | 16 Suncleft (closed), Helion, the infernal dragon | F | 048_B:595-650 (2194, gated by the Ember-Rat or Warm Window) |
| 2673 | 17 Thorned Ledger Bank, the Accountancy, spore saying "Avarice" | F | 048_B:547-590 (2187) |
| 2718 | 18 Frost-Thread, Maera, crowning robes | F | 048_B:655-696 (2195) |
| 2765-2787 | Night events 1-10 | F | 048_E:242-469 (all 10, plus the Verdant Storm) |
| 2794-2804 | Down-the-root hooks 1-6 | F | heat_rising 048_E:586; gem 048_B:408; DOWN_THE_ROOT 048_E:614-623 |

### Seasonal Factions and Intrigue Dossier
| Src | Element | St | Evidence |
|---|---|---|---|
| 2812-2840 | Spring, Bryn (human), root-rot cover-up | F | 048_B:93-111 |
| 2844-2863 | Lirielle (Wennen), dreams of burning roots | F | 026:162-179 |
| 2867-2884 | Blooming Name; Whispering Sapling | F | 048_E:516-541, 664-676 |
| 2888-2916 | Winter, Ysera, souls hoarded below | F/Ch | 048_B:245-254 (race: B7) |
| 2920-2939 | Kethan (goliath, Skytower), knuckle-pop, infiltrator | F | 048_B:311-322; 048_D:282-347 |
| 2943-2957 | Frost Warning; Silent Watcher | F | 048_E:522-545 |
| 2964-2992 | Autumn, Lumea's propaganda | F/Ch | 048_B:171-179 (race: B7) |
| 2996-3015 | Maera, freezes at "Summer", coronation garb | F | 048_B:664-696 |
| 3019-3038 | Leaf on the Pillow; Fox of Light | F | 048_E:567-573, 546-551; 048_B:187-194 |
| 3042-3070 | Summer, Eternal Summer Engine, Gorran's ore | F | 048_B:139-149; 048_E:678-690 |
| 3074-3092 | Helion: mural, "child"/"sapling", Herald of Eternal Summer | F | 048_B:616-628 |
| 3096-3118 | Warm Window; Scorched Mark; Ember Footprint | F | 048_E:528-532, 574-581 |
| 3122-3150 | Halo as the Frozen Flame; Eira (Reghed) delivering souls | F | 048_D:966-1003 |
| 3154-3173 | Jast: talks to reflections, futures where she wins | F | 048_B:481-523 |
| 3177-3198 | Flicker of Faith; Pocket Shard; Perfect Stillness | F | 048_E:533-561 |
| 3203-3253 | Solo-ambient d12 | F | AMBIENT 048_E:600-612 (11) plus THRONE KNOWS note 048_E:582 |
| 3259-3293 | Locations and tone ("observed, admired, stalked") | F | 048_D:1032-1034 |

### 20 New NPCs (all placed; each reveal checked)
| # | NPC | St | Evidence |
|---|---|---|---|
| 1 | Talwyn: Frostina's chosen, follows | F | 048_C:13-49; 2180, 2060 |
| 2 | Jorik: ore for Gorran | F | 048_C:55-87; 2055 |
| 3 | Serelle: "god of light made wrong" | F | 048_C:93-109; 2189 |
| 4 | Pimmlet: Shimmer's Heart scroll | F | 048_C:115-137; 2062 |
| 5 | Reva: vine-person spy | F | 048_C:143-161; 2050 |
| 6 | Ivran: wyrmling silhouettes as omens | F | 026:379-385; 2055 |
| 7 | Felka: hidden Avarice shard | F/Ch | 048_C:167-190; placement (Ch8) |
| 8 | Yorin: prophetic songs | F | 048_C:196-230; 2180 |
| 9 | Dathra: Deepfire Quartz | F/Ch | 048_C:236-269; placement (Ch8) |
| 10 | Gurk: whispering hammer | F | 048_C:275-295; 2180 |
| 11 | Elitha: sculpture imprisoning a sliver of Auril | F | 048_C:301-330; 2189 |
| 12 | Pellar: Autumn's coded notes | F | 048_C:336-355; 2180 |
| 13 | Selene: scripture | F | 048_C:361-384; 2061 |
| 14 | Krolf: Sephek's voice in the wind | F | 048_C:390-412; 2050 |
| 15 | Viessa: candle map | F | 048_C:418-439; 2055 |
| 16 | Harget: blackmail charter | F | 048_C:446-479; 2180 |
| 17 | Mira Thynelight: identity garments | F | 048_C:500-529; 2189 |
| 18 | Shivven: Auril's silhouette in the ice | F | 048_C:535-554; 048_D:547-550; 2055 |
| 19 | Halden Vex: reset engine | F | 048_C:560-599; 2062 |
| 20 | Rilka: Glimmer's future church | F | 048_C:606-628; 2180 |

### 10 surveillance creatures (WATCHERS 048_A:212-233; watcher() 048_D:1009-1037)
| # | Watcher, master | St | Evidence |
|---|---|---|---|
| 1 | Root-Hollow Stalker, Bryn | F | 2050 (15,14); Bryn's confession 048_B:102 |
| 2 | Frost-Veil Shade, Ysera | F | 2189 (16,30); 048_B:245 |
| 3 | Auroral Moth-Swarm, Lumea | F | 2189 (46,33) |
| 4 | Infernal Ember-Rat, Gorran | F | 2052 (5,9); opens the Suncleft 048_B:598 |
| 5 | Mirror-Shard Homunculus, Jast | F | 2055 (20,23) |
| 6 | Garden-Whisper Weasel, Maera | F | 2189 (26,39); Reva 048_C:148 |
| 7 | Soul-Thread Wraithling, Ysera and the Rootwardens | F | 2050 (43,18) |
| 8 | Echo-Rune Beetle, Lumea | F | 2190 (6,8) |
| 9 | Snow-Still Raven, Eira | F | 2055 (15,6) |
| 10 | Shadow-Heat Lurker, Avarice | F | 2053 (12,9); all-10 reward 048_D:1031-1036 |

### Memory note for the main session
Nothing new about the user came up in this slice. The memory preferences (no shortcuts; audit when a build-out is done; check content proactively) shaped how thorough this pass was. Memory gave no instructions beyond that.
