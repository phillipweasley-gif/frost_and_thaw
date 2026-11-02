# Audit B — `rootspire.md` Tab 1 (lines 1–3808) vs. Pokémon Frost & Thaw

Scope: every story-bearing element of Tab 1 (city & tiers, Heartroot, factions, major NPCs, Heartroot Labyrinth H1–H26, Relics of the Future Past, downtime/transition, merchant compendium, night events, down-the-root hooks, seasonal factions dossier, 20 new NPCs, 10 surveillance enemies). All 3808 lines were read in order. Game evidence comes from `game/Data/Scripts/998_FrostThaw/*.rb` and the map builders in `tools/build_*.rb`, checked against the current compiled maps in `build/maps/`.

## 1. Summary

**Row counts (214 rows in the table below):**

| Status | Rows | Of which in Parts I–IV (lines 1–1876, the "story" half) |
|---|---|---|
| Full | 53 | 51 |
| Compressed | 26 | 20 |
| Changed (approved) | 3 | 3 |
| Changed (not approved) | 30 | 24 |
| Missing | 101 | 43 |
| n/a (pure mechanics) | 1 | 0 |

So across Parts I–IV (141 rows) 50% is Full or Compressed (71), 19% Changed (27) and 30% Missing (43). Across the compendium, dossier, new NPCs and watchers (73 rows) 11% is Full or Compressed (8), 8% Changed (6) and 79% Missing (58).

**How Tab 1 splits by kind of content:**

- **Core Rootspire spine: well covered, often word for word.** This means Parts I–III, the Part IV-B relics and Labyrinth zones I–II. The Rooted Hearth, all six rumours, the Council Hall, the Still Sky Shrine, the Echo Gate, the Wind-Glass Library, the Aerie Markets, the Still Ones and the Root Gate seal puzzle are in. So are the Sap Wells, the Overflow Channel, the whispering attendant, the Guild of Roots and Stone, Hew's construct, and four of the five relic quests. Many read-alouds are copied nearly verbatim (Heartroot intro, Root-Tier atmosphere, Aerie seer, Lorn Scribe, the crypt and Boundary Stone inscriptions, the Lumen Shard question).
- **Heartroot Labyrinth: only about a third is in.** H1–H8 (zones I–II) are Full. H9–H26 (zones III–VI: Mirror Garden, Hollow Core, Vault of Amber Dreams, Antechapel, Breaking Circle, Sloughing Veins, Echo Vault) are almost entirely absent. The Ch7 header says so itself ("zones I and II"). The later-tab Rootsun Forge (Ch8) replaces the bottom of the dungeon. The Cocoon Pens and Avarice's journal stand in for H15/H19. The original H3 Mirror-Root Vault (Avarice's first homunculus, the ice mask, the liquid-mirror pit) is gone.
- **Back third of Tab 1: almost entirely missing.** This is the GM's "living city" layer (lines 2763–3804):
  - 0/10 night events
  - 0/12 ambient events
  - 0/12 faction window-events
  - 0/10 surveillance creatures
  - 2/20 "new NPCs" (Ivran, Reva)
  - 4 of the 9 named dossier figures (Lirielle, Kethan, plus the shops of Bryn and Gorran under new keepers)
  - 4/18 shops present in any form

  The Seasonal Factions intrigue (Autumn's Court of Splendor, Summer's Absent Throne with Gorran and Helion Vael, Winter's soul-hoarding fear, the Frozen Flame's Eira Voss and Jast) has been folded into two people: Var, now an empty "coat" worn by Avarice, and Darrus. The Summer/Autumn conspiracy as a web of named agents does not exist.
- **Dangling threads.** These are set up in the game and never paid off:
  - Frostshard Sigils: one given, described as "one of three keys to the White Vault", never used again.
  - Vault Map: one fragment found, never used again.
  - The White Vault transition is absent.
- **Dead content.** Written but not reachable in the current maps:
  - The Halo splinter at the twin-dragon orb: trainers `halo_ilse` and `halo_vosk`, text `shrine_halo_blocked`.
  - Mira's merchant dialogue: `mira_north_wind`, in both the 024 and 028 versions.
  - The possessed child in the market: `mirror_child`.
  - The Corsair sailor on the Root-Tier: `corsair_sailor`.

  None of these appears in any current builder or in `build/maps/*.rxdata`. Mira's dialogue, the child and the sailor are still in older staged builds (`build/ch6_stage`, `build/ch7_stage`), so a later builder rewrite seems to have dropped them.
- **Continuity bug.**
  - `025_Chapter7.rb:15` says Selrae calls the Vault "the White Womb".
  - Alberica's chat after meeting Selrae (`025_Chapter7.rb:75`) says "'The White Womb.' She said it like a prayer."
  - Selrae's actual scene (`033_Chapter7B.rb:356-389`) never says it. Only Avarice says it, later (`034_Chapter8.rb:431`).

**Overall judgement.** For the parts of Tab 1 that drive the plot, the adaptation is careful and faithful, not a shortcut job. For Tab 1 as a whole it took real shortcuts, in two specific places:

- the lower two-thirds of the Heartroot Labyrinth
- nearly the whole intrigue and texture layer (seasonal factions, their agents, the watcher creatures, the night and ambient events, the extra NPCs)

The owner's worry is justified for those two areas and largely unjustified for the core city, quests and relics. Several Tab 1 characters were also overwritten by the later "Summer Marshal / Rootsun Forge" plot from Tabs 2+. Var, Darrus and Avarice are the clearest cases; Sephek and Mira were changed too, but less. That change is coherent, but it is not on the approved list.

## 2. Biggest gaps (ranked)

1. **Heartroot Labyrinth zones III–VI (H9–H26) and the Mirror-Root Vault** (lines 497–513, 1354–1577). This is about 17 keyed areas:
   - the Mirror Garden: Reflection Ring mirror-clones, Verdant Seed, Shattered Bed, Perfume Grotto
   - the Hollow Core: bridges, Sap Burst Crossways, Frozen Drop
   - the Vault of Amber Dreams: Amber Threshold, Dissectory, Mirror Scriptory
   - the Auroral Antechapel, the Breaking Circle rune-flipping, the Sloughing Veins escape and the Echo Vault treasure
   - H3's homunculus and ice mask

   *Suggestion:* put the Mirror Garden on Road B between the Overflow Channel (2067) and Hew's last ladder, and the Hollow Core bridges on Road A between Mycolith's Hollow (2070) and the Root Chapel (2071). Turn the Ch8 Heart Chamber fight into H24's rune circle.
2. **Frostshard Sigils / Vault Map / White Vault transition** (lines 492, 937, 1052, 1235, 1571, 1839–1847). One sigil (`026_Rootspire.rb:1133`) and one map fragment (`025_Chapter7.rb:240`) are given; "three keys" is promised and nothing uses them. *Suggestion:* Eirwen hands over sigil 2 after the Library beat or the Vote. Sigil 3 drops from Sephek in Ch13, or sits in an Echo Vault room. Play the "three sigils merge" read-aloud at the Ch11 departure. Otherwise reword the item text.
3. **The Seasonal Factions & Intrigue Dossier as a cast** (lines 2806–3293). These are all missing:
   - Bryn of Spring (root-rot cover-up)
   - Ysera Dorn (souls hoarded beneath the roots)
   - Lumea Keth and Maera Vell (Autumn propaganda and coronation robes for an Eternal Summer)
   - Gorran Ashal-Forge (infernal ore to Avarice)
   - Helion Vael and the locked Suncleft Emporium
   - Eira Voss and Jast Penumbran (Frozen Flame)

   *Suggestion:* add each as a one-event NPC in the Trunk-Tier or Canopy (`build_ch6.rb`, `build_ch6b.rb`) with their secret-motive line after Ch7 starts. Make the Suncleft Emporium a locked door on the Canopy that opens after Ch8.
4. **Night events, ambient events and faction events** (lines 2763–2788, 2867–3256; 34 vignettes, 0 in game). These carry the tone the doc asks for: "observed, admired, stalked." *Suggestion:* a random vignette on each rest at the Hearth (`024_Chapter6.rb:350`) or on a new day, drawn from the d10/d12 tables. Most are pure text and cost little to add.
5. **Var Rime-Breaker's Tab 1 character** (lines 583, 811–834). The brash veteran with guilt over an ancestor who served Naerth, a wish to test Alerion, a Corsair arms deal and a mirror-shard glaive never appears. In the game Var is only an empty body worn by Avarice (`034_Chapter8.rb:333-438`). This is not an approved change. *Suggestion:* show the real Var in Luminara's memory bubble (`036_Chapter10.rb:45`), or in a letter or ledger in the Cocoon Pens.
6. **Mira of the North Wind before her rescue, and the first half of "Mirror, Mirror"** (lines 282–284, 691–711, 1059–1081). Mira's mirror stall and the child who buys a possessed mirror are written (`024_Chapter6.rb:115-121`, `028_Heartroot.rb:62-89`) but not placed on any current map. Mira is only met at the wheel or after she is freed. *Suggestion:* restore her stall and the child on Map 2050 in `build_ch6.rb`, gated on switch 3974 being off.
7. **The Halo splinter at the Shrine of the Twinned Dragons** (line 395). The trainers Sister Ilse and Brother Vosk and the blocked-orb text exist (`026_Rootspire.rb:122-123,144-145,247-248,338`), but `build_ch6b.rb` never places them, and `twin_orb` just sets `halo_orb_cleared` (026:878). *Suggestion:* place them on the Canopy (2061) by the orb, gated on `!halo_orb_cleared`.
8. **The 20 new NPCs: 18 missing** (lines 3295–3495). These are all cheap hooks:
   - Krolf at the Echo Gate (hears Sephek)
   - Old Yorin's prophetic songs in the Bazaar
   - Shivven Pearlbite (Auril's silhouette under the ice) at the Split Dock
   - Sister Selene's scripture at the Shrine
   - Talwyn shadowing the party
   - Harget's blackmail document
   - Felka's hidden shard in the Heartroot outer ring
   - Viessa's candle-map of Avarice's magic
   - Pimmlet's "Shimmer's Heart" scroll (ties to `037_Chapter11.rb:163`)

   *Suggestion:* add one-screen NPCs across 2050, 2055 and 2061.
9. **Kelyn's secret and her betrayal hook** (lines 795–806). She secretly communes with Razzilith's dreams; her chamber has a mural of Reptin and Glimmer; she could misuse the relics and trigger a verdant surge. None of this is in. *Suggestion:* a Ch7 or Ch10 scene in the Council Hall, which could fold into Alberica's "Spores of Contention" trial (`036_Chapter10.rb:14`).
10. **Darrus Fell's Tab 1 arc** (lines 838–861). He offers Meat Meat a job stealing a sealed reliquary from the Guild (part of the Mirror Mother's heart); an Avarice construct blackmails him; he flees to the Corsairs or redeems himself. The game makes him a zealot who dies (`034_Chapter8.rb:248-293`). *Suggestion:* an optional Ch6–7 errand for Meat Meat, with the reliquary found in the Guild Annex.
11. **The Rootwardens' internal story** (lines 339–347, 607–638):
    - the Spire Armory
    - the "Still Beast" hunt for Rheven
    - the Claw/Bough/Seed circles
    - the infiltrator feeding the Halo
    - frozen Bough bodies reanimated by Avarice's constructs
    - Rheven's belief that the Heartroot is hungry and must be destroyed
    - the "Oath of Roots" mercy-and-fury trial

    *Suggestion:* a Rheven side quest in the Blooming Fields (2060) after Ch7, with a reanimated Bough patrol as a boss.
12. **Eren Frostborn and the Alerion lineage** (lines 1138–1158). Eren has dreams in which Auril offers him "the gift of memory" (accepting would fragment Alerion's soul), and a bow from Frostina's scale. The game has him only as a trainer (`026_Rootspire.rb:118`). *Suggestion:* a follow-up after the Rime Mantle is found, or during the Ch11–12 Alerion beats.
13. **Glimmer-facing intrigue** (lines 879–887, 1016–1020, 958):
    - Selrae courts Glimmer as a vessel; her black-ice dagger
    - Eline tries to convert Glimmer and speaks in reversed prayer
    - Wynsnow's "remember what the centuries forgot" offer and his plan to anchor the Heralds' souls

    These fit the window between `029_Glimmer.rb` (Ch6) and his death at the Forge. *Suggestion:* add these lines with `cl(:glimmer, ...)`. Also fix the White Womb bug by giving Selrae the line in `033_Chapter7B.rb:356-389`.
14. **Auroral Corsairs' depth** (lines 213, 687–711). Missing: the Smuggler's Run under the Split Dock, the guild symbol, the Boreal Requiem's relic vault with a dormant wyrmling scale core, and "The Frozen Run" escort with revenant sailors. *Suggestion:* add the escort as the content of Mira's ship after the Tide Seal, and give her `corsair_sailor` line back its map spot on 2055.
15. **Chronal side quests at the College and Library** (lines 752, 939, 3485). Missing: Wynsnow's "Chronal Debt", Eirwen's ritual to relive one day of the frozen past, and Halden Vex's plan to "reset" the Heralds. *Suggestion:* a single flashback-map quest from the Library (2062).

## 3. Full table

Game paths are relative to `game/Data/Scripts/998_FrostThaw/` unless they start with `tools/`.

### Part I – II: Origins, geography, districts

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Arrival read-aloud beneath the World Tree | 13–19 | Compressed | 024_Chapter6.rb:257-286 | Arrival comes through the cracked lantern; "tree so tall its crown is lost in the aurora". The humming wind and spring-air prose isn't used. |
| Timeline of Renewal (sapling, Heart of Spring, wyrmlings Y113, Rootspire named, "Heralds of Dawn and Dusk") | 23–32 | Changed | 024_Chapter6.rb:317, 325-329, 480, 543 | Became a time bubble: "grew in one night that lasted 400 years" inside the Wall, with the outside frozen. "Heart of Spring" and "Heralds of Dawn and Dusk" kept. The wyrmlings are said to wait for partners, not to have shaped the tree. |
| Nature of Rootspire: triune Council (Growth/Memory/Balance), Cycle faith, economy, tone | 36–48 | Compressed | 024_Chapter6.rb:157 ("Memory, Alberica's line"); 025_Chapter7.rb:80 ("'Growth,' the Council calls me"); 026_Rootspire.rb:271-280 statues | Glimmer's "Balance/faith" seat and the economy are not reflected. There are statues of four Heralds, but none of Shade/Glimmer. |
| Root-Tier atmosphere & Dougan's Hole beneath | 57–73, 194–200 | Full | 024_Chapter6.rb:559-569; map 2055 (tools/build_ch6.rb) | The read-aloud is nearly verbatim. |
| R1 Split Dock + crystallized Corsair crews hook | 203–215 | Compressed | 024_Chapter6.rb:88-94, 111-114; 026_Rootspire.rb:376-382 | Crews frozen at the oars and "the lake remembers" are kept. The Smuggler's Run beneath the dock is missing. The `corsair_sailor` text (024:92) is no longer placed on 2055 in build/maps. |
| R2 Still Sky Shrine (cracked Auril statue, fresh-cut eyes, vigils, "cool the heart", Frost Saint runes, Blessing of Warmth) | 220–235 | Full | 024_Chapter6.rb:98-110, 571-615; 026_Rootspire.rb:1141-1155; 027_Relics.rb:170-180 | Blessing of Warmth means Pokémon can't be frozen. |
| R3 Echo Gate (names whispered, Sephek "The lake remembers", Frost Saint's Sigil, 2 Mirror Wraiths spelling VAULT) | 240–253 | Full | 024_Chapter6.rb:239-254; 026_Rootspire.rb:1115-1136 | Relocated: the Echo Gate is now the west road to the Auroral Wall. |
| Trunk-Tier atmosphere | 257–262 | Compressed | map 2050 (tools/build_ch6.rb) | Mostly implied; no heartbeat or birdsong text. |
| T1 Verdant Bazaar (micro-climates, frost-glass, wyrmling idols) | 266–275 | Compressed | 024_Chapter6.rb:76, 122-126 (lanterns, festival); 026_Rootspire.rb:15-17 | The market exists, with Pip, the Wennen and Tarin. The snow-side/heat-side micro-climate is missing. |
| Tarin Goldlash, dwarf sap-smith, "liquid sunlight" | 280 | Full | 024_Chapter6.rb:291-304; Goldlash Sap-Works (2052) | |
| Mira's mirror stall and the child possessed by a mirror ("Mirror, Mirror", first half) | 282–284, 706 | Changed | 033_Chapter7B.rb:224-255; orphaned: 024_Chapter6.rb:115-121, 028_Heartroot.rb:62-89 | The child is now Mira's daughter, trapped inside the twin mirror in the Overflow Channel. The market stall and the child who bought a mirror are not on any current map (they exist only in old build/ch6_stage). "Track the twin to the Heartroot" survives. |
| T2 Rooted Hearth (hollow knot, murals of heroes in flame and snow) | 289–296 | Full | 024_Chapter6.rb:132-133, 310-353; 026_Rootspire.rb:260-269 | |
| Rumours table d6 | 297–308 | Full | 024_Chapter6.rb:488-502 | All six, close to verbatim. |
| Hellen insists the PCs stay as guests | 311 | Full | 024_Chapter6.rb:320, 345-352 | Free rooms; the Hearth is the rest point. |
| T3 Council Hall of Seasons (four obelisks, debate) | 315–332 | Full | 024_Chapter6.rb:148-149, 507-554 | Four crystals; three councillors and the empty, scorched Summer seat. |
| Forged decree ordering a Heartroot dig (Avarice's sigil in the wax) / "The Frozen Edict" | 334, 600 | Compressed | 024_Chapter6.rb:139-142, 524-529; 025_Chapter7.rb:97 | The decree is present, with a "cracked mirror" mark. It is never investigated or resolved; the festival-night shudder launches the Heartroot instead. |
| T4 Spire Armory (Rootwarden training scene) | 339–345 | Missing | — | There is no armory location. Rheven stands in the Bazaar (tools/build_ch6.rb). |
| "The Still Beast" side quest (Avarice-sigiled bone-and-ice construct, CR 7) | 347, 636 | Missing | — | The Rime Stalker (026:1217) is Alerion's relic trial, not this hunt. |
| District hook: bazaar mirrors spread Avarice's mind | 354 | Compressed | 033_Chapter7B.rb:266-282 (mirror-core, Mira's "we") | Reduced to Mira's ship. |
| District hook: Winter Matron covertly funds the Halo | 356 | Full | 033_Chapter7B.rb:361-362; 025_Chapter7.rb:103 | |
| Cycle Day festival; cult plans to ignite the "Frost Saint" effigy | 358, 545–553 | Changed | 024_Chapter6.rb:122-124, 406-461 | Renamed the Festival of Returning Light (7 nights). The read-aloud survives ("whether warmth or winter wins"). There is no effigy; the cult's attempt is the Rite of Stillness. |
| Canopy-Tier atmosphere | 371–376 | Compressed | map 2061 (tools/build_ch6b.rb); 026_Rootspire.rb:451 | Leaves hum, nearly a chord; no misty rainbows. |
| C1 Shrine of the Twinned Dragons (twin spires, orb glows when wyrms stir, dream visions) | 380–393 | Full | 026_Rootspire.rb:849-918; 029_Glimmer.rb:24-34 | The Bloom Guard visions are delivered through the orb. The *Cycle Canticle* sung by worshippers is absent here. |
| C1 hook: Halo splinter corrupting the orb to channel Auril into Frostina | 395 | Missing (dead content) | 026_Rootspire.rb:122-123, 144-145, 247-248, 338 | Trainers and text are written but not placed in tools/build_ch6b.rb or build/maps. `twin_orb` auto-sets `halo_orb_cleared` (026:878). |
| C2 Wind-Glass Library (leaves record speech; Eirwen; Naerth's ledger; Alberica's handwriting) | 400–414 | Full | 026_Rootspire.rb:340-369; map 2062 | |
| C3 Celestial Rift (aurora column, Glimmer's site) | 419–429 | Changed (approved) | 026_Rootspire.rb:326-337; 029_Glimmer.rb:59-139 | Shade steps through Brightmane's mirror here. |
| C3: portals to the Frostfell; ice-winged angels with Avarice's mark | 431–433 | Missing | — | |
| C4 Aerie Markets (air-fruit, sky-sailor duels, Aarakocra Seer, Auroral Motes) | 438–448 | Full | 026_Rootspire.rb:120-121, 284-297; MARTS[:aerie] 026:80; 027_Relics.rb:59 | The seer's quote is verbatim. The duels are trainers. |
| Upper hook: Library prophecy "Frost Saint will climb the Spire when the roots bleed" | 455 | Missing | — | (Ch11 has the Frost Saint walking at the Shrine, but there's no prophecy setup.) |
| Upper hook: Winter Matron wants the Canopy under martial law | 457 | Missing | — | |
| Upper hook: Glimmer's Trial (celestial envoy: hope vs judgment) | 459 | Changed (approved) | 029_Glimmer.rb:66-139 | Superseded by Brightmane's mirror. |
| Original H1 Root-Gate (seasonal rune puzzle matched to the aurora hue; Sap Wraith on failure) | 473–481, 1282–1286 | Full | 025_Chapter7.rb:140-219 | The vision on the Wraith's defeat is kept (025:187-190). |
| Original H2 Sap-Wells (heal + visions; 3 fragments unlock the next arc) | 486–492 | Compressed | 033_Chapter7B.rb:304-329; 025_Chapter7.rb:235-246 | Three visions, but only one physical fragment (`vault_map_1`), and it is never used. |
| Original H3 Mirror-Root Vault (Avarice's first homunculus, broken ice mask, liquid-mirror pit across time, Mirror Sentinels, clue to Ithryn Athis) | 497–513 | Missing | — | No "Ithryn Athis" anywhere in the game. |
| Original H4 Heart Chamber: Frost Saint Shard re-forming; Blessing of Verdant Fire | 518–528 | Changed | 034_Chapter8.rb:331-440 | The Heart Chamber is now the Rootsun Forge engine holding Sephek's heart, with Avarice in Var. No Blessing of Verdant Fire; no "goddess still waits in the ice". |
| Heartroot hook: Avarice's devices draw on the tree; Reptin senses corruption | 536 | Full | 025_Chapter7.rb:80, 137; 032_Chapter7A.rb:280-282 | Wyn and Myr carry most of it. |
| Heartroot hook: Verdant Sickness (sap turns black) | 538 | Compressed | 032_Chapter7A.rb:175-210 (blight); 026_Rootspire.rb:431-434 | Moved to Hyphora's blight in the Undercanopy. |
| Heartroot hook: rune puzzle opens a conduit to the White Vault | 540 | Missing | — | |
| Surrounding terrain: Auroral Wall (time frozen beyond) | 129 | Full | 024_Chapter6.rb:239-254; 026_Rootspire.rb:256-258 | |
| Surrounding terrain: Glasswater Lake (Dougan's Hole beneath; reflected constellations wrong) | 131 | Compressed | 026_Rootspire.rb:380; 036_Chapter10.rb:64 (Glasswater Shore 2078) | The wrong constellations are missing. |
| Surrounding terrain: Blooming Fields (flowers and snow; Reptin senses the seasons' struggle) | 133 | Full | map 2060; 026_Rootspire.rb:240, 445, 465 | |
| Surrounding terrain: Sky-Path (merchants, pilgrims, Rootwardens, frost-fire lanterns) | 135 | Full | 026_Rootspire.rb:116, 252; pilgrim Ysolde 026:115 | |
| Cycle Pulse (dawn hue shifts green/gold/red/white) | 142 | Changed | 025_Chapter7.rb:147-153 | Used only as the nightly aurora hue for the rune puzzle. |
| Auroral Echoes (chronal songs bards can record) | 144 | Missing | — | |
| Verdant Storm (tenday storm wakes roots/undead) | 147 | Missing | — | |

### Part III-A: Factions

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Verdant Council: symbol, motto, 4 seats, tensions | 569–595 | Compressed | 024_Chapter6.rb:507-554; 036_Chapter10.rb:102-124 | Kelyn vs Selrae is there. The "Balance is survival" motto and the four-leaf symbol are missing. |
| Hook "A Season Too Long" (cycle stalled on Summer) | 598 | Changed | 024_Chapter6.rb:531 ("stuck in this summer for thirty years"); 034_Chapter8.rb:338-340 | The cause is Avarice's engine, not a Rootwarden ritual gone wrong. |
| Political Favour Track (standing with one seasonal faction) | 602 | Changed | 036_Chapter10.rb:50-56, 445; 037_Chapter11.rb:192-219 | Became the Vote for new councillors (Rheven, Mira, Eirwen, Phildendrin, Anduin), which decides your transport. Not seasonal factions. |
| Rootwardens: symbol (wolf paw over a leaf), creed | 609–619 | Full | 026_Rootspire.rb:202-203, 387 | The creed is verbatim. |
| Rootwardens: ~200 members, Claw/Bough/Seed circles | 621–623 | Compressed | 026_Rootspire.rb:114, 209, 239 | Only the Bough circle is named. |
| Rootwardens' crisis: Bough members missing at the Wall; frozen bodies reanimated by Avarice constructs | 629 | Compressed | 026_Rootspire.rb:209, 239; 024_Chapter6.rb:136 | Missing patrols, yes. Reanimated bodies, no. |
| Rheven suspects an infiltrator feeding the Halo | 631 | Missing | — | (Kethan's similar suspicion, line 2939, is also missing.) |
| Hook "Oath of Roots" (initiation trial: mercy vs fury) | 638 | Changed | 024_Chapter6.rb:533-549 | Replaced by swearing the Wardens' oath at the Council's living pillar; no trial. |
| Fractured Halo: symbol, goal, Eline, Still Sky Shrine hideout, beliefs, mirror-glass prayer tokens, fallen Rootwardens | 643–672 | Full | 024_Chapter6.rb:52-69, 167-168, 571-615; 026_Rootspire.rb:1075 | Sister Wenna is an ex-Rootwarden. The snowflake tattoo appears. |
| Halo hideout: Frozen Cellar beneath an abandoned brewery | 654 | Missing | — | |
| Hook "Echo of Saint Kaltro" (recover fragments of Sephek's heart) | 676 | Changed | 024_Chapter6.rb:590-596; 037_Chapter11.rb:93-106 | The Halo gave the heart to Summer. Eline restores it in Ch11. |
| Hook "The Rite of Stillness" | 678 | Full | 024_Chapter6.rb:582-615 | |
| Hook "Selrae's Secret" | 680 | Full | 033_Chapter7B.rb:356-389; 025_Chapter7.rb:102-104; 036 (trial) | |
| Auroral Corsairs: identity, Mira captain, Boreal Requiem, alliance/naval support | 685–711 | Compressed | 024_Chapter6.rb:92-94; 033_Chapter7B.rb:56-67, 260-299; 037_Chapter11.rb:193, 209 | The ship's-wheel symbol is missing. |
| Corsairs: relic vault aboard with a dormant wyrmling scale core | 700 | Missing | — | |
| Hook "The Frozen Run" (escort through the frozen half; revenant sailors) | 708 | Missing | — | |
| Guild of Roots and Stone (Hew, infrastructure, mines touch the Heartroot, workers vanish, semi-sentient sap fuel) | 715–728 | Full | 026_Rootspire.rb:218-225; 028_Heartroot.rb:7-13, 91-94; 033_Chapter7B.rb:84-219 | |
| Hook "The Amber Experiment" (fuel that whispers when burned) | 732 | Compressed | 028_Heartroot.rb:91-94; 033_Chapter7B.rb:54 | Whispering amber is present; the PCs aren't hired to test it. |
| Hook "Sabotage at the Mine" (Halo ignite sap caches) | 734 | Full | 033_Chapter7B.rb:127-152 | |
| College of Auroral Arts (Dean Aldric Wynsnow, temporal anomalies, PCs as "chronal anomalies") | 739–746 | Full | 026_Rootspire.rb:786-842; 030_Prologue.rb | Wynsnow is also the Journey-mode starter professor. The first name "Aldric" is unused. |
| Hook "Lecture in Blue Fire" | 750 | Full | 026_Rootspire.rb:821-842 | A temporal wight comes through the rift. |
| Hook "Chronal Debt" (glimpse the missing centuries, at a cost) | 752 | Missing | — | |
| Intrigue Web overview / summary | 757–774, 1196–1208 | Compressed | — | Only Council, Halo, Corsairs, Guild and Avarice threads exist; the College and the World Tree "dreaming via the Lorn Scribe" don't. |

### Part III-B: Major NPCs

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| High Speaker Kelyn of Spring: public face; Wardens Emeritus sanction | 784–798 | Full | 024_Chapter6.rb:508-554 (`wardens_emeritus`) | |
| Kelyn's secret communion with Razzilith's dreams; mural of Reptin & Glimmer; verdant-surge betrayal | 795, 804–806 | Missing | — | |
| Summer Marshal Var Rime-Breaker (brash veteran, Naerth-ancestry guilt, wants to test Alerion, Corsair arms deal, mirror-shard glaive) | 583, 811–834 | Changed | 024_Chapter6.rb:524-525; 034_Chapter8.rb:333-438; 035_Chapter9.rb:420 | Not approved. Missing from the start; a "coat" Avarice has worn for 30 years. Follows the later-tab Summer Marshal plot, but every Tab 1 trait is lost. |
| Autumn Warden Darrus Fell (tiefling, clove bark, silver tongue) | 838–847 | Full | 024_Chapter6.rb:139-142, 523 | |
| Darrus: relic dealing, Avarice blackmail, reliquary job for Meat Meat (Mirror Mother's heart), flees to the Corsairs, redemption by financing the White Vault | 849–860 | Changed | 034_Chapter8.rb:248-293; 036_Chapter10.rb:39, 67 | Becomes an Eternal-Summer zealot who tries to feed a child to the engine and falls. None of the Tab 1 hooks remain. |
| Winter Matron Selrae Vorn: ex-Auril priestess, Halo patron, villain-or-ally | 865–885 | Full | 024_Chapter6.rb:143-147; 033_Chapter7B.rb:356-389; 034_Chapter8.rb:223-235; 036_Chapter10.rb (Gym 8) | |
| Selrae courts Glimmer as Auril's vessel; black-ice dagger that prays to Auril | 879, 883 | Missing | — | |
| Selrae calls the Vault "the White Womb" | 887 | Changed | 034_Chapter8.rb:431 (Avarice says it); 025_Chapter7.rb:15, 75 | Bug: Alberica's chat says Selrae said it "like a prayer", but Selrae's scene (033:356-389) never says it. |
| Captain Rheven Stormbranch: public face, creed, direwolf (offspring of the old ally), tree-screams dreams | 892–912 | Full | 026_Rootspire.rb:190-217; 024_Chapter6.rb:425-428 (`fed_pack`) | |
| Rheven: believes the Heartroot is sentient and hungry, would destroy it; seeks Reptin's counsel on violence; leads the expedition to the Avarice machinery | 903, 906, 914 | Missing | — | (Reptin's "hungry" chat, 025:80, is a faint echo.) |
| Archivist Eirwen Solglass: they/them, barefoot, frost-dust; Naerth ledger; wants to publish it | 919–933 | Full | 026_Rootspire.rb:340-353; 036_Chapter10.rb:53 ("The truth, published") | |
| Eirwen: custodian of a Frostshard Sigil; ritual to relive a day of the past (flashback side quests) | 937–939 | Missing | — | |
| Professor Wynsnow: plan to tie the heroes' life-threads to Rootspire; offer to Glimmer and Alberica | 955–958 | Missing | — | |
| Hellen Brightrun: matron, pine-mead, shrine to the PCs in her cellar, family prophecy, instant recognition, quest-giver | 969–991 | Full | 024_Chapter6.rb:310-353; 026_Rootspire.rb:260-269, 756-781 | She's also Gym 4. The old passages from her tavern to the docks are missing. |
| Matron Eline: Manifest Rite on Cycle Day with sap + Sephek's heart | 1002–1013 | Full | 024_Chapter6.rb:583-615; 037_Chapter11.rb:83-133 | Split across Ch6 (cool the tree) and Ch11 (heart returned). |
| Eline: tries to convert Glimmer and Selrae; speaks in reversed prayer when captured; final foe or tragic martyr | 1016–1024 | Missing | — | The ritual circle "under the docks" is partly echoed by the Underdark circle (036_Chapter10.rb:62-63). |
| Sephek Kaltro, Frost Saint Shard (mirror-ice statue, hooded pilgrim in visions) | 1029–1043 | Changed | 024_Chapter6.rb:586-596; 032_Chapter7A.rb:304-315; 037_Chapter11.rb:93-133; 039_Chapter13.rb:285-330 | Frozen body plus a stolen heart, not a mirror-ice shard. |
| Sephek seeks Meat Meat's blood ("Prototype Verdant"); Alerion as the rival frost aspect; drops a Frostshard Sigil | 1046–1052 | Missing | — | |
| Sephek redemption: "Auril's silence, not her return, honors her" | 1054 | Full | 039_Chapter13.rb:303 | Verbatim. |
| Mira of the North Wind: plural speech, mirror-core on the flagship, naval aid on redemption | 1059–1081 | Compressed | 033_Chapter7B.rb:56-67, 260-299; 037_Chapter11.rb:193 | The core is faithful. Her pre-rescue merchant scenes are cut, and she gains a daughter. |
| Avarice Reforged: "variables that refused to die", archvillain | 1086–1103 | Changed | 034_Chapter8.rb:59, 331-440 | Appears in person in Ch8 as Forge-Mistress wearing Var, rather than "only through mirrors or dreams until the White Vault". The quote is kept. |
| Avarice: Seraph-Draco plan (Razzy's scale core + Meat Meat's blood); body like the Mirror Mother's; whispers each PC's birth-cry | 1097, 1106–1108 | Compressed | 034_Chapter8.rb:91-96, 342-344 (RAZ-MK cocoons, "took Razzy's voice") | The dragon-essence experiments are hinted at; the Seraph-Draco and birth-cry are missing. |
| The Lorn Scribe: blind dwarf, riddles unlocking each hero's side quest, writes backwards | 1113–1127 | Full | 026_Rootspire.rb:355-361; tools/build_ch6b.rb:130 | |
| Lorn Scribe: works for the World Tree; can't die (turns to script); keeps pages of Alberica's journal | 1124, 1131–1133 | Missing | — | |
| Eren Frostborn: young ranger of Alerion's line | 1138–1146 | Compressed | 026_Rootspire.rb:118, 141, 243-244 | Present only as a trainer. |
| Eren: Auril's "gift of memory" dreams (Alerion's soul would fragment); Frostina-scale bow; pupil or mirror | 1148–1158 | Missing | — | |
| Master Hew Talmire: siphons sap; prototype prays to the tree as "Father" | 1163–1177 | Full | 033_Chapter7B.rb:154-177, 182-219 | His gift of a device holding a dormant Avarice code fragment is missing. |
| The Still Ones (Faith, Hope, Love, Balance; finish dying; shift the tree's alignment) | 1181–1192 | Full | 026_Rootspire.rb:1160-1194 | Reward: Blessing of Still Sky. |

### Part IV-A: Heartroot Labyrinth (22/26-room expansion)

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Labyrinth read-aloud intro | 1221–1225 | Full | 025_Chapter7.rb:129-133 | Verbatim. |
| Dungeon purpose: recover the third Frostshard Sigil, complete the White Vault map | 1233–1239 | Changed | 033_Chapter7B.rb; 034_Chapter8.rb | Purpose re-pointed to finding Var and stopping the burning. |
| H1 Root-Spiral Approach (knocking from below) | 1273–1279 | Full | 025_Chapter7.rb:58-59, 124-138; tools/build_ch7.rb | |
| H2 Runic Seal Circle / Sap Wraith | 1282–1286 | Full | 025_Chapter7.rb:140-219 | |
| H3 Warden's Overlook ("She will take the heart if we don't") | 1291–1296 | Full | 025_Chapter7.rb:60-63 | |
| H4 Rootguard Post (infernal tools, enthralled guards) | 1298–1305 | Full | 025_Chapter7.rb:45-48, 64-66; 028_Heartroot.rb:43-46 | Four enthralled Rootwardens. |
| H5 Threshold of Dripping Gold | 1311–1317 | Full | 025_Chapter7.rb:224-232 | |
| H6 Central Wells (heal; visions) | 1320–1324 | Full | 033_Chapter7B.rb:304-329 | The failed-save psychic damage isn't modelled. |
| H7 Overflow Channel (slide, bone-like constructs, map fragment) | 1327–1339 | Full | 028_Heartroot.rb:100-107, 142-178; 025_Chapter7.rb:235-246 | |
| H8 Whispering Attendant (answers questions) | 1342–1349 | Full | 033_Chapter7B.rb:331-351 | Its price ("burn the forge" / "free the heart") is dropped. |
| H9 Petaled Threshold (lagging reflections) | 1356–1362 | Missing | — | |
| H10 Reflection Ring (worst selves, Mirror Clones, Verdant Seed) | 1365–1367 | Missing | — | |
| H11 Shattered Bed (shard Avarice scries through; Mirror Shard Focus) | 1369–1381 | Missing | — | |
| H12 Perfume Grotto (Lirielle's old seeding; safe rest) | 1384–1396 | Missing | — | |
| H13 Upper Root Bridge (frozen-sap lake far below) | 1403–1409 | Missing | — | |
| H14 Sap Burst Crossways (sap bursts, frost vines) | 1412–1424 | Missing | — | |
| H15 Cocoon Gallery (hag and Avarice cocoons; a captive warns) | 1427–1439 | Changed | 034_Chapter8.rb:201-235 (Cocoon Pens) | Relocated to the hag's domain. The captive is Selrae (`selrae_ahead`). |
| H16 Frozen Drop (climb; time-lapse field) | 1442–1452 | Missing | — | |
| H17 Underdark Mouth (duergar stragglers; back door) | 1455–1463 | Changed | 026_Rootspire.rb:435-438; 034_Chapter8.rb:116-155; 036_Chapter10.rb:239-262 | The duergar and the Underdark Door exist, in other chapters. |
| H18 Amber Threshold (pods, twisted chant to Auril) | 1472–1478 | Missing | — | |
| H19 Stasis Gallery (Homunculus Core, lab notes on the dragon/divine plan, Temporal Surge) | 1481–1486 | Changed | 034_Chapter8.rb:91-96, 205-209 | Only the journal on RAZ-MKIII and V-7 survives. |
| H20 Dissectory Annex (cataloguing construct; Auril-binding notes) | 1488–1500 | Missing | — | |
| H21 Mirror Scriptory (Avarice's war-room; Mirror-Ink Wraith) | 1503–1515 | Missing | — | |
| H22 Auroral Antechapel (ghost echoes of the Shard; last parley) | 1522–1534 | Missing | — | |
| H23 Heart Chamber boss + purify/preserve/destroy choice | 1537–1539 | Changed | 034_Chapter8.rb:331-424 | Avarice boss with engine overheat. The moral choice becomes "Kill me and it blows" plus Glimmer's sacrifice (approved). |
| H24 Breaking Circle (flip overwritten runes mid-fight; changes the epilogue) | 1541–1551 | Missing | — | The Twenty Stones (034:101) are flavour only. |
| H25 Sloughing Veins escape | 1554–1560 | Changed | 034_Chapter8.rb:445-459 | A shake, the dragon launch and a transfer up; no escape sequence. |
| H26 Echo Vault (third sigil, higher Verdant Seed, tailored items, World Tree prophecy) | 1563–1577 | Missing | — | |
| Treasure & aftermath: Verdant Fire Charm, Cycle of Roots scroll, personal-quest visions | 1611–1617 | Missing | — | Personal quests come instead from the Ch10 trials, which use other sources. |
| Transition: the Labyrinth concludes the Rootspire arc with the full White Vault map | 1622–1625 | Changed | 034–036 | The arc ends instead in the Ch9 arrest, the Ch10 Trials and the Vote. |

### Part IV-B: Relics, downtime, transition

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Meat Meat: Verdant Prototype's Blade (driftwood chest, scorched "A", "Subject V-7", cold-table dream, "weapon or seed") | 1633–1660 | Full | 026_Rootspire.rb:987-1022; 027_Relics.rb:43-44, 122-126 | The trial becomes a dialogue choice, which has no later payoff. |
| Blade curse (prototype faces on killing blows); Eirwen's lore fragment "On the First Reversal" | 1662–1667 | Missing | — | |
| Reptin: Heartwarden's Staff (crypt under the Armory, petrified druids in sap, his totem, crypt inscription) | 1671–1700 | Full | 026_Rootspire.rb:190-204, 392-396, 1024-1054 | The crypt is in the Root-Tier, not under the Armory. The Auroral Wall meditation is replaced by a Crypt Guardian fight. |
| Alerion: Mantle of Returning Winter (Boundary Hunt, double frozen at the Wall, "Finish the step", bring a predator down alive, Boundary Stone Y192) | 1712–1752 | Full | 026_Rootspire.rb:253-255, 1196-1240 | |
| Alberica: Key of Whispering Memory (sub-vault, her old handwriting, lock of notes, Cycle Canticle alone before dawn in the Hall, spectral bards on failure, voices of those who knew you) | 1756–1787 | Full | 026_Rootspire.rb:366-369, 923-982 | |
| Glimmer: Lumen Shard (Celestial Rift, mirror-shadow, "Will you bear hope...", Rift inscription) | 1791–1818 | Changed (approved) | 026_Rootspire.rb:326-337; 029_Glimmer.rb:59-139 | It sinks into Glimmer's chest and is not a held item. The discovery text is verbatim. |
| Downtime: Research the Sigils (Wynsnow translates the map) | 1828 | Missing | — | |
| Downtime: Council Petitions | 1830 | Changed | 036_Chapter10.rb:36-48 | Became the witness-gathering for the Trials. |
| Downtime: Tree Communion (cleanse the Heartroot) | 1832 | Missing | — | Reptin calling rain at the lake (032:328-345) is a loose echo. |
| Downtime: Festival of Balance (Heralds celebrated; Rootspire as safe haven) | 1834 | Changed | 024_Chapter6.rb:406-461 | Celebration happens before the descent; the Hearth is the safe haven. |
| Transition to the White Vault read-aloud (three sigils merge) | 1839–1847 | Missing | — | |
| Blessings & Relics table: Blessing of Still Sky | 1861 | Full | 026_Rootspire.rb:1192; 027_Relics.rb:314-323 | No sliding on ice. |
| Blessings & Relics table: Verdant Fire Charm, Cycle of Roots, Verdant Seed, Mirror Lens, Blessing of Verdant Fire | 1856–1860 | Missing | — | The game's Seed of Renewal (027:53) is a different item from Cornipus. |
| Campaign notes: Rootspire as base of operations | 1867 | Full | 024_Chapter6.rb:350-352 | |
| Campaign notes: relics as keys to White Vault puzzles; surviving factions pick who goes north; wyrmlings' awakening mirrors the heroes | 1869–1873 | Changed | 037_Chapter11.rb:192-219 | The Vote's winner provides transport, a nice adaptation. Relics are not keys. |

### Merchant & downtime compendium

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Master economy rules (50% DMG, stock limits) | 1904–1921 | n/a | — | Not story; Pokémon marts are used. |
| 1. Run & Bloom Apothecary (Bryn of Spring; rumour: stolen rebirth sap) | 1931–1975 | Changed | 026_Rootspire.rb:79, 181-183, 708-711 | The shop exists, kept by Nivva Sunwick (Wennen). Bryn and his rumour are gone. |
| 2. The Sap-Smith (Gorran Ashforged; "voices in the flame") | 1980–2024 | Changed | 024_Chapter6.rb:291-304 (Goldlash Sap-Works) | Same "sap-smith" niche, kept by Tarin. Gorran is absent. |
| 3. Auroral Atelier (Lumea Keth; escaped illusion) | 2029–2073 | Missing | — | |
| 4. Glasswater Outfitter (Tirena Loch-Vine; maps change with the aurora) | 2078–2120 | Missing | — | |
| 5. Wind-Glass Library shop (Solvaran; forbidden codex) | 2125–2167 | Compressed | 026_Rootspire.rb:340-369 | The Library exists, with Eirwen. No shop, no Solvaran. |
| 6. Shrine of Balance (Ysera Dorn; dragon of light trapped below) | 2172–2214 | Missing | — | |
| 7. Still Sky Shrine black market (Eira Voss; sacrifices for "The Perfect Season") | 2219–2261 | Changed | 026_Rootspire.rb:1065-1082 | The cult black market became the Halo's Masked Trader ("Whispers of the Echo Gate") in the Undercanopy. |
| 8. Rootwarden Hall (Captain Kethan Vale; hammering under the Heartroot) | 2266–2310 | Missing | — | No hall; Kethan only appears in Ch10. |
| 9. Ink & Ember Bookhouse (Mirna Cowl; Avarice's mirror-glass letters) | 2313–2353 | Missing | — | |
| 10. Crystal Quill Scrollworks (Filgen Rootfoot; scrolls whisper names) | 2358–2398 | Missing | — | |
| 11. Gem & Thorn Exchange (Arvoss Ember-Scale; gem vibrates near the vault) | 2403–2443 | Missing | — | |
| 12. Perfumed Root (Lirielle; prophetic fire-scent) | 2448–2488 | Compressed | 026_Rootspire.rb:162-180 | Lirielle names the shop and has the fire dreams. No shop or perfumes. |
| 13. Verdant Stables (Thim Wicker; beast heard the tree cry) | 2493–2533 | Missing | — | |
| 14. Mirror-Dust Curiosity Shop (Jast Penumbran; buys shards for "a collector") | 2538–2578 | Missing | — | |
| 15. Auroral Arms (Brogar Frostvein; crystal arm hums when Avarice forges) | 2583–2623 | Missing | — | |
| 16. Suncleft Emporium (closed; missing Helion Vael) | 2628–2668 | Missing | — | |
| 17. Thorned Ledger Bank (the Accountancy; spore repeats "Avarice") | 2673–2713 | Missing | — | |
| 18. Frost-Thread Clothier (Maera Vell; Autumn's "crowning robes") | 2718–2758 | Missing | — | Pip the pocket tailor (026:635-703) is a separate invention. |
| Rootspire Night Events d10 (Reflection Smiles First, Halo Ambush, Tavern Revelry, Runaway Rootwarden, Autumn "Visit", Missing Yeti Child, Auroral Storm, Perfume Prophecy, Silent Market, Dream of the Tree) | 2763–2788 | Missing | — | 0/10. |
| Down-the-root hooks (heat at night, gems vibrating, infernal sigils in mirrors, Autumn's spies on the Verdant Cask, Ysera's failed divinations, Frostina senses burning) | 2792–2804 | Compressed | 024_Chapter6.rb:416-425; 026_Rootspire.rb:164-178 | Only "something below is burning" survives (festival shudder, Lirielle, Glimmer). The other five are missing. |

### Seasonal Factions & Intrigue Dossier

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Spring: the Renewal Wardens (fear of Eternal Summer) | 2812–2817 | Missing | — | Kelyn is "of Spring" but there is no faction. |
| Bryn of Spring (root-rot near the Heartroot, covered up) | 2821–2840 | Missing | — | |
| Lirielle Mossdancer (Wennen perfumer; grey fur, flower rings, notebook; dreams of burning roots) | 2844–2863 | Full | 026_Rootspire.rb:162-180; tools/build_ch6.rb | Close to verbatim. Adds a Wennen Lonelywood tie. |
| Spring events (Blooming Name; Whispering Sapling "Help...") | 2867–2884 | Missing | — | |
| Winter: Order of Balance (fear that souls are harvested below) | 2888–2893 | Missing | — | |
| Ysera Dorn (knows someone hoards souls beneath the roots) | 2897–2916 | Missing | — | |
| Captain Kethan Vale (Goliath, Skytower clan; suspects a Summer infiltrator) | 2920–2939 | Compressed | 036_Chapter10.rb:61, 240-262; 037_Chapter11.rb:192 | Present in Ch10 as Wyn's judge, with the Skytower tie. The infiltrator plot is missing. |
| Winter events (Frost Warning "Don't trust the warmth"; Silent Watcher) | 2943–2960 | Missing | — | |
| Autumn: Court of Splendor (steer toward Eternal Summer) | 2964–2969 | Changed | 034_Chapter8.rb:250-253 | Reduced to Darrus's personal zeal. |
| Lumea Keth (Autumn propaganda illusions) | 2973–2992 | Missing | — | |
| Maera Vell (coronation garb for Summer's return) | 2996–3015 | Missing | — | |
| Autumn events (Leaf on the Pillow; Fox of Light "Choose warmth") | 3019–3038 | Missing | — | |
| Summer: the Absent Throne (Summer + Avarice building the Eternal Summer Engine) | 3042–3047 | Changed | 024_Chapter6.rb:412, 517-518; 034_Chapter8.rb:298-340 | The empty scorched throne and the engine exist. "Summer" is now just Avarice wearing Var. |
| Gorran Ashal-Forge (infernal ore from the Heartroot to Avarice) | 3051–3070 | Missing | — | |
| Helion Vael (missing Summer archmage; would-be Herald of Eternal Summer) | 3074–3092 | Missing | — | |
| Summer events (Warm Window, Scorched Mark, Ember Footprint) | 3096–3118 | Missing | — | |
| Fractured Halo as the "Frozen Flame" (Auril + Avarice heresy) | 3122–3127 | Compressed | 024_Chapter6.rb:594; 033_Chapter7B.rb:140-141 | The Halo–Summer alliance is there ("We gave it to Summer"); the "burn what remains" doctrine is thin. |
| Eira Voss (Reghed warlock; delivers souls to Avarice's forge) | 3131–3150 | Missing | — | The "Eira" in the game is a myconid sentry (032:149), a different character. |
| Jast Penumbran (collects mirror shards for Avarice) | 3154–3173 | Missing | — | |
| Fractured Halo events (Flicker of Faith; Pocket Shard; Perfect Stillness) | 3177–3199 | Missing | — | |
| Solo ambient events d12 ("All factions watching") | 3203–3256 | Missing | — | 0/12. |
| Overall tone: observed, admired, stalked, courted by danger | 3272–3293 | Compressed | 024_Chapter6.rb:98-100; 029_Glimmer.rb:45 | "Admired" lands well: murals, statues, Hellen, Tamsin. "Observed" and "stalked" barely do. |

### 20 New Rootspire NPCs

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| 1. Talwyn Frostrill (initiate who thinks the PCs are Frostina's chosen) | 3299–3305 | Missing | — | |
| 2. Jorik Pinebellow (smuggles infernal ore for Gorran) | 3309–3315 | Missing | — | |
| 3. Serelle of the Still Veil (visions of "a god of light made wrong") | 3319–3325 | Missing | — | |
| 4. Pimmlet Natch (hides the scroll of *Shimmer's Heart*) | 3329–3335 | Missing | — | The lore exists elsewhere (037_Chapter11.rb:163), not via Pimmlet. |
| 5. Reva Mosscut (Wennen floral sculptor; vine-spy for Autumn) | 3339–3345 | Changed | 026_Rootspire.rb:184-189 | Sculpts the Heralds; the spy secret is dropped. |
| 6. Captain Ivran Solmar (burn scars, glass eye; wyrmling silhouettes under the Glasswater as omens) | 3349–3355 | Full | 026_Rootspire.rb:376-382 | |
| 7. Mistress Felka Thornhand (hides an Avarice-voiced shard in the roots) | 3359–3365 | Missing | — | |
| 8. Old Yorin the Chanter (prophetic songs) | 3369–3375 | Missing | — | |
| 9. Dathra Spineshade (Deepfire Quartz for the Engine) | 3379–3385 | Missing | — | |
| 10. Gurk Thistlebane (hammer whispers of Auril's agents) | 3389–3395 | Missing | — | |
| 11. Elitha Snowmere (sculpture imprisons a sliver of Auril's will) | 3399–3405 | Missing | — | |
| 12. Pellar Wicket (courier carrying Autumn's coded notes) | 3409–3415 | Missing | — | |
| 13. Sister Selene Marr (writes scripture about the PCs) | 3419–3425 | Missing | — | Lumin Weavemoss (026:854) fills the shrine-priest role but not this hook. |
| 14. Krolf the Mossback (hears Sephek in the Echo Gate winds) | 3429–3435 | Missing | — | |
| 15. Viessa Arialune (candles map Avarice's magic) | 3439–3445 | Missing | — | |
| 16. Harget Flinttoe (blackmail document naming the Heralds) | 3449–3455 | Missing | — | |
| 17. Mira Thynelight (steals PCs' hair for identity-stealing garments) | 3459–3465 | Missing | — | |
| 18. Shivven Pearlbite (Auril's avatar in the frozen deep) | 3469–3475 | Missing | — | |
| 19. Professor Halden Vex (wants to "reset" the PCs) | 3479–3485 | Missing | — | Partly overlaps the "chronal anomalies" framing of Wynsnow. |
| 20. Rilka Dawnshard (sent by Glimmer's future church) | 3489–3495 | Missing | — | Under the approved Glimmer death this hook needs rethinking anyway. |

### Lore-aligned surveillance enemies

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| 1. Root-Hollow Stalker (Spring → Bryn) | 3503–3529 | Missing | — | |
| 2. Frost-Veil Shade (Winter → Ysera) | 3533–3559 | Missing | — | |
| 3. Auroral Moth-Swarm (Autumn → Lumea) | 3563–3589 | Missing | — | |
| 4. Infernal Ember-Rat (Summer → Gorran) | 3593–3620 | Missing | — | |
| 5. Mirror-Shard Homunculus (Halo → Jast) | 3624–3650 | Missing | — | |
| 6. Garden-Whisper Weasel (Autumn → Maera) | 3654–3680 | Missing | — | |
| 7. Soul-Thread Wraithling (Winter + Rootwardens) | 3684–3712 | Missing | — | |
| 8. Echo-Rune Beetle (Autumn → Lumea) | 3716–3742 | Missing | — | |
| 9. Snow-Still Raven (Halo → Eira Voss) | 3746–3772 | Missing | — | |
| 10. Shadow-Heat Lurker (Avarice herself) | 3776–3804 | Missing | — | Every one of these could be a wild "watcher" Pokémon or fusion that flees with a line of text. |
