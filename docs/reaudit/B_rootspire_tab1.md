# Re-audit B: rootspire.md Tab 1 (lines 1-3808)

Scope read in full: Part I (arrival, timeline, nature, tiers, terrain, phenomena), II-A (R1-R3, T1-T4, hooks), II-B (C1-C4, original H1-H4, hooks, Cycle Day), III-A factions, III-B NPC profiles (both halves), IV-A Heartroot Labyrinth H1-H26 + treasure, IV-B Relics of the Future Past + downtime + White Vault transition + appendix, the Merchant & Downtime Compendium (18 shops, night events, down-the-root hooks), the Seasonal Factions & Intrigue Dossier (all vignettes, solo-ambient d12, locations, tone), the 20 new NPCs and the 10 surveillance creatures.

Code checked: 024, 025, 026, 027, 028, 029, 033, 034 (H23/H24 refs), 046_DeepLabyrinth, 046_ForgeRooms (Zone VI/aftermath), 047c (sigils, Sephek), 048_A-G; builders build_ch6, build_ch6b, build_rootspire_life, build_ch7, build_ch7b, build_ch7_deep, build_ch8_deep (function lists). Every Full row below was traced to a builder event (or a scene called from one) and a reachable switch/flag.

Note on scope: Tab 1 contains only H1-H26 (plus the original six-node H1-H4 of Part II-B). H27-H37 come from Tab 3's overlay; they exist in code (046_DeepLabyrinth.rb, 046_ForgeRooms.rb) but are outside this slice and were not audited against source.

## 1. Summary

Rows audited: 277 (the full table in section 3). Mixed verdicts are counted by their weaker half: "F / C" counts as C, "Ch / C" as Ch.

| Verdict | Count |
|---|---|
| Full | 238 |
| Compressed | 20 |
| Changed (owner decision / integration choice / other) | 11 |
| Missing | 8 (6 substantive, 2 minor lore lines) |
| Unreachable | 0 (but one missable quest, B5) |

Bugs found: 6. One is a dead clue flag that makes some dialogue wrong. Two are payoffs that are set up and then never read. One is a contradiction between scenes (Mira). One is a missable window (Alerion's A1). One is a blessing that switches off a puzzle.

Honest judgement: this is the most thoroughly covered part of the campaign I have seen in this code. All 18 shops exist, each with its keeper (dossier appearance and cues), read-aloud, rumour, and a secret where the source gives one. All 20 new NPCs are placed and reachable. Each has an outward face and a secret reveal. All 10 watchers are placed, gated on meeting their master, and catchable. All ten night events, all six down-the-root hooks, every faction vignette and all twelve solo-ambient events fire from real hooks (Hearth rest, first step on a map). The labyrinth H1-H26 is implemented room by room, with the source's mechanics turned into choices and fights. What is lost is mostly second-tier character texture from the III-B profiles: Glimmer's celestial envoy, Sephek wanting Meat Meat's blood, Hew's code-fragment gift, Eirwen's publish dilemma, Hellen's tunnels, Mira's "left possessed" branch. There are also three set-ups that never pay off (Darrus's financing, the Favour Track, Var's glaive).

## 2. Every row that is not Full, ranked by importance

### Missing

1. **Glimmer's Trial: a celestial envoy demands he choose between hope and judgment** (src 459).
   Evidence: no "envoy" or hope/judgment choice anywhere in 998_FrostThaw. Glimmer's arc runs through Brightmane's seven-day rite instead (048_Rootspire_F_Downtime.rb:317-436).
   Fix: add an envoy beat to `lumin_rite` (Day 6 or 7) or to `brightmane_questions`: a choice between hope and judgment that sets a flag for later Glimmer scenes.

2. **Sephek seeks Meat Meat's altered blood ("Prototype Verdant") and treats Alerion as the rival aspect of frost he must destroy** (src 1046). Also missing: Sephek appearing in visions as a hooded pilgrim offering "cold blessings" (src 1037).
   Evidence: the blood motive is given only to Avarice (047c_WhiteVault.rb:17, :307). No "Prototype Verdant" anywhere. No pilgrim vision. Sephek's redemption IS present ("Her silence honours her", 039_Chapter13.rb:331).
   Fix: give Sephek a line at the Minor Avatar fight (047c:140-189) addressing Meat Meat as "Prototype Verdant" and Alerion as his rival. Add one Alberica omen or a night event where a hooded pilgrim offers a cold blessing.

3. **Hew's gift: a device holding a dormant Avarice code fragment, plus the comic-to-horror turn if the construct wakes in a siege** (src 1174-1177).
   Evidence: Hew's scenes (026:218-225, 033:89-224) and Prototype 3 (033:159-182) have no gift device.
   Fix: have Hew hand over a gadget after the Gym 5 win (033:200-221). Let it misbehave at the Forge or in the Ch10 siege.

4. **Eirwen means to publish Naerth's ledger, unaware it could destabilise Rootspire's faith** (src 930).
   Evidence: Eirwen mentions the ledger once (026_Rootspire.rb:348-349). There is no publish choice, and the ledger is never shown as an item.
   Fix: add a choice in `eirwen` (048_D:558): "publish / keep it sealed", with Kelyn or Selrae reacting.

5. **Hellen knows old passages connecting the Hearth to the Root-Tier docks** (src 989).
   Evidence: absent from `hellen` (024:315-359) and from the cellar map (build_ch6b.rb:37-49). Viessa's map flags "a cluster right under the Hearth" (048_C:429), which is a hook with no matching passage.
   Fix: a cellar-to-Root-Tier shortcut in the Hearth cellar (2059), unlocked by Hellen after the Hearthstone Seal.

6. **Mira left possessed becomes Avarice's new body** (src 1080).
   Evidence: there is only one path. You break the mirror-core (033_Chapter7B.rb:270-287), and the Tide Seal is a gym badge.
   Fix: optional. Since Mira is a gym, a fail-state may be inappropriate. At least foreshadow it: Mira's mirrors showing Avarice "trying her on".

(Also missing, low importance: the Verse XI lore fragment "The Dwarf of Song taught memory to sing..." (src 1786) is never shown. Fix: add it to `council_pillar` after the Canticle, 026:1005-1014. Avarice "whispering each PC's birth-cry" (src 1108) does not appear either. Fix: one omen line.)

### Bugs

B1. **Kethan's infiltrator clue `:warden_map_seen` is never set.**
   Evidence: it is counted at 048_Rootspire_D_Quests.rb:308, but the warden-map sign (048_Rootspire_B_People.rb:39-44) never sets it. The quest still completes with two of the other three clues. However, the reveal text (048_D:313) always cites "the patrol pins moved to the Wall's edge", even when the player never saw them.
   Fix: `T.set_flag(:warden_map_seen)` inside the `warden_map` lambda. Optionally build the 313 text from the clues the player actually holds.

B2. **Darrus's redemption payoff is never read.**
   Evidence: `:darrus_redeemed` is set at 048_D:976 ("I'd pay... for the voyage") and read nowhere else.
   Fix: read it at the Ch11 departure or in the White Vault prep (money, furs or ship supplies), as the source says ("financing the expedition").

B3. **Political Favour Track has no effect.**
   Evidence: `favour()` is written by the Autumn visit, the faction vignettes and the petitions (048_E:446-449). `favour_of` is defined at 048_E:451 and never called. The board only displays it.
   Fix: give each faction at "warm"/"trusted" a small boon (a shop discount, a free item) and at "cold" a rival reaction. The source says "small boons but inheriting rivalries".

B4. **Mira contradiction between scenes.**
   Evidence: the Corsair gangplank says "Captain Mira's not seeing anyone. Not since her little one went missing" (033:69-70). Yet Mira runs a cheerful mirror stall in the Bazaar the whole time (build_ch6.rb:127; 048_C:635-658), and never mentions her missing daughter. Also, the Bazaar's possessed child is "a boy" (048_C:666), while the twin mirror holds "a girl... my mama's Mira" (033:233-256). Two children, never connected on screen.
   Fix: have the stall Mira say something fractured about her daughter ("We- I put her to bed. She's... somewhere wet"). Have the boy's reflection reference the girl in the twin mirror, so the two children read as one plot.

B5. **Alerion's Echoes at the Wall (A1) is missable.**
   Evidence: it runs only from `echo_wraiths` (026:1183), which `echo_gate` calls only while `!wall_thinning` (024:240-243). Once Ch9 thins the Wall, the Echo Gate becomes the exit to the Dale. The sigil has a fallback (047b_TrialWeek.rb:254-299), but `echoes_at_the_wall` has none.
   Fix: let `echo_gate` offer `echoes_at_the_wall` after `wall_thinning` too, or add a fallback trigger elsewhere.

B6. **The Blessing of Still Sky switches off the Overflow Channel's slide puzzle.**
   Evidence: the blessing is earnable in Ch6 (Still Ones, 026:1236-1242), and with it `pbSlideOnIce` returns early (027:317-323). The H7 slick-sap channel (028:37-39) then becomes plain walking. Not blocking, but H7's hazard vanishes.
   Fix: exempt `SAP_SLICK_MAPS` from the blessing, or have the blessing say it only covers ice.

### Compressed (ranked)

7. **Var's mirror-shard glaive "resonates if Sephek appears"** (src 833). It is given as a key item (046_DeepLabyrinth.rb:1042), but no Sephek scene checks `:var_glaive`. Fix: add a hum line in the Minor/Major Avatar fights (047c:140, :226).
8. **Eline: "if captured she speaks only in reversed prayer"; "final foe or tragic martyr depending on mercy"** (src 1020-1024). Eline escapes in Ch6 (024:627-628), reappears beside Sephek (037:85-146; 047c:163-165), and gets no mercy-dependent end. The reversed-speech trait was moved to Eira Voss (048_D:1017-1018). Fix: a mercy choice when Eline kneels (047c:165).
9. **Political Favour Track** (src 602): display only. See B3.
10. **Kelyn offers sanction as "Wardens Emeritus"** (src 798). The flag is `:wardens_emeritus`, but she says "Wardens of Rootspire" (024:553). Her secret terror of Auril's return (src 582) is not voiced. Fix: use the title in the line, and add one fearful line.
11. **Still Ones: "destroying or redeeming them shifts the Tree's alignment toward Verdant or Frost"** (src 1192). There is only one option, "Help it finish" (026:1226), and no alignment shift. Fix: add a "shatter" option that moves `wheel` the other way.
12. **Naerth's ledger, Eirwen's admiration of Alberica's writings as holy texts, the "chronal leaves"** (src 412, 930-933). One line each (026:345-352). See Missing 4.
13. **R1: the crystallised Corsair crews show "traces of Sephek's mirror-ice"** (src 215). The crews and the "ice came off the shore" are Full (024:88-94, 111-114), but Sephek is never named as the source. Fix: one line from Ivran or the fisher.
14. **Council debate over whether expansion threatens balance; Kelyn vs Selrae disputes** (src 332, 589). Only hinted ("She always says no", 024:567-570). Fix: one more exchange at the first Council session.
15. **Darrus: "his ruin could collapse trade"** (src 858). There is no economic consequence after `heist_exposed`. Fix: a Bazaar NPC or shop line after the exposure.
16. **C1: worshippers sing the Cycle Canticle when the orb glows** (src 390). Lumin describes the orb (026:853-858), but there is no singing. Fix: one ambient line.
17. **Reptin's staff attunement: a long rest at the Auroral Wall through the cycle of seasons** (src 1683). Replaced by a crypt-guardian battle (026:1069-1079). The discovery itself is Full.
18. **Glimmer's Lumen Shard trial (an hour in the Rift, the shadow asking "Will you bear hope...")** (src 1795-1804). The shadow's question appears only if the player visits the Rift before the twins land (026:326-335). After that, the shard is taken in the Glimmer arrival scene (029:60-139). This is the owner decision (Shade becomes Glimmer at the Rift), but the question is lost on the usual route. Fix: put the shadow's question into `glimmer_arrives`.
19. **Treasure & Aftermath: "each PC receives a vision leading to their personal secret quest"** (src 1617). Present (046_ForgeRooms.rb:1023-1050), but the relic quests were already done in Ch6, so the visions only look back. Fix: reword them as confirmations, or point them at quests still open (Echoes at the Wall, Eren, the Lorn Scribe).
20. **Campaign transition: "each Relic serves as key or resonant focus for puzzles in the White Vault"; "surviving factions determine which NPCs accompany them north"** (src 1869-1871). No relic or faction checks in 047c that I found. Fix: one relic-gated door or shortcut in the White Vault.
21. **Autumn vignette "Leaf on the Pillow"** (src 3026). The velvet box is on "a bench at the Promenade's edge" (048_E:500-505), not on your bed, which loses the intrusion. Fix: move it to `HEARTH_VIGNETTES`.
22. **Hew: comic relief that turns to horror if the construct wakes in a siege** (src 1177). See Missing 3.
23. **Kelyn's betrayal hook: "if manipulated by Avarice's agents"** (src 806). The manipulator is Autumn/Lumea (048_C:343-352; 048_D:83-130). This is close to the source, since Autumn serves Summer/Avarice. Acceptable.
24. **Matron Eline tries to convert Selrae** (src 1016). Reduced to "tell your Winter Matron her chair is beside mine" (048_D:440-442). Acceptable.
25. **Var's glaive / Var commanding the militia in crises** (src 829-833). This falls under the Var/Avarice owner decision. The glaive is covered in 7.

### Changed

26. **The Echo Gate moves** from a Root-Tier tunnel (src 73, 240-253) to the Trunk-Tier's west road, where it doubles as the Auroral Wall crossing (build_ch6.rb:81; 024:239-254). Neither an owner decision nor a listed integration choice. Harmless: Krolf, the scorch marks and the wraiths all follow it.
27. **The Smuggler's Run**: "controlled by the Auroral Corsairs" (src 213) becomes old Guild tunnels with Rootwarden wards, the Guild vault and Gorran's ore; the Corsairs keep only the old moorings (build_rootspire_life.rb:330-359). This serves the Verdant Heist. Acceptable.
28. **Cycle Day and the Rite of Stillness**: the festival is renamed the Festival of Returning Light (024:122). The Rite is fought on the Council night before the festival's last night (024:603-636), not during Cycle Day (src 678, 1013). The Frost Saint effigy attempt (src 358) does happen on festival night (048_F:644-654). The source's "Manifest Rite of the Still Sky" becomes "Rite of Stillness".
29. **The Halo's plan for Sephek's heart**: in the source they merge his shard with the Tree's sap to rebirth Auril, and hunt "fragments of his crystalline heart" (Echo of Saint Kaltro, src 664, 676). In game they have already given his heart to Summer, which is Avarice's engine (024:614; 033:389). They gather the pieces later (037:85-99). This integrates the Forge plot; the "Echo of Saint Kaltro" hook survives only as Ch11's heart retrieval.
30. **The mirror's twin**: "tracking the mirror's twin to the Heartroot Vault" (src 284) becomes the Overflow Channel, H7 (033:229-259), with Mira's trapped daughter added. Acceptable, but see B4.
31. **Frostshard Sigils**: the source gives inconsistent origins (Echo Gate "Frost Saint's Sigil", Eirwen, Sephek's defeat, the Labyrinth's "third sigil" in the Echo Vault, src 250, 937, 1052, 1235, 1571). The game settles on three: Echo Gate wraiths, Eirwen, Sephek (047c:7-9, 94-96). A reasonable reconciliation. The Echo Vault (H26) gives other treasure.
32. **Heartroot hook "Portal to the Vault"**: the rune puzzle opens a conduit to the glacier fields (src 540). In game the merged sigils open the way (047c:103-123). Consistent with 31.
33. **"Completing the Labyrinth concludes the Rootspire arc"** (src 1624). The game continues into Ch9-Ch11 with the Forge, the summer's end and the Trials. Structural, fine.
34. **Tone "verdant by day, frozen by night"** (src 48). The game's Rootspire is stuck in a 30-year summer (dawn_hue, 048_E:166-174; Kethan's Rite of the Long Gold). This comes from the other campaign documents, and the source's own Part III-A hook "A Season Too Long" supports it.
35. **Var Rime-Breaker**: Avarice has worn his body for 30 years, and his own story is told through the Mirror-Root Vault's pit (046_DeepLabyrinth.rb:998-1051): the Naerth guilt, the Corsair arms deal, testing Alerion, the glaive. This is the owner decision, faithfully done.
36. **Talion (Alerion's brother) folded into the Echo Gate, the frozen hunter and Krolf** (026:1160-1181, 1256-1258; 048_C:398-408). An addition from other tabs; it doesn't displace Tab 1 content.

## 3. Full table

Legend: F = Full, C = Compressed, Ch = Changed, M = Missing. File references are game/Data/Scripts/998_FrostThaw unless they start with tools/.

### Part I - Origins & Geography
| # | Element (src line) | Verdict | Evidence |
|---|---|---|---|
| 1 | Arrival read-aloud (13-19) | F | 024:257-291 scene_rootspire_arrival; cutscene at build_ch6.rb:94 |
| 2 | Timeline Year 0-400 VR (25-32) | F | 048_G:7-13 timeline_wall; build_rootspire_life.rb:136 |
| 3 | Council triune Growth/Memory/Balance (40) | F | 024:564 |
| 4 | Rootwardens; faiths; economy (42-46) | F | Rootwardens throughout; Halo as the Aurilian sect; relic fish (048_C:538) |
| 5 | Tone verdant by day, frozen by night (48) | Ch | #34 |
| 6 | Root-Tier: Undercity, docks, smuggler caves (57-73) | F | build_ch6.rb:184-235 |
| 7 | Trunk-Tier landmarks (76-92) | F | build_ch6.rb:63-182 |
| 8 | Canopy-Tier landmarks (95-111) | F | build_ch6b.rb:103-172 |
| 9 | Heartroot restricted; constructs in mirror-glass roots (114-122) | F | root_gate_sealed 024:77-79; 046_DeepLabyrinth |
| 10 | Auroral Wall (129) | F | 026:256-258; 024:239-254 |
| 11 | Glasswater: constellations don't match (131) | F | 048_E:479-480 |
| 12 | Blooming Fields; Reptin senses seasons (133) | F | build_ch6b.rb:51-101; fields_spirits 048_D:684 |
| 13 | Sky-Path, pilgrims, Rootwardens (135) | F | fields_sign 026:252; pilgrim_ysolde |
| 14 | Cycle Pulse dawn hue (142) | F | dawn_hue 048_E:166; rune puzzle 025:147-159 |
| 15 | Auroral Echoes / chronal songs (144) | F | Echo Codex 048_F:697-724 |
| 16 | Verdant Storm once a tenday, waking undead (147) | F | night_verdant_storm 048_E:401 (rs_day>=10) |

### Part II-A
| # | Element | Verdict | Evidence |
|---|---|---|---|
| 17 | R1 Split Dock read-aloud and dockworkers (203-211) | F | root_tier_arrival 024:579; fisher 024:88 |
| 18 | R1 Smuggler's Run controlled by Corsairs (213) | Ch | #27 |
| 19 | R1 two crews crystallised; Sephek's mirror-ice (215) | C | #13 |
| 20 | R2 Still Sky Shrine read-aloud, re-cut eyes (220-226) | F | auril_statue 024:98-100; shrine_enter 024:591 |
| 21 | R2 Eline's disciples; steal sap to "cool the heart" (230) | F | 024:594-597; disciples build_ch6.rb:276 |
| 22 | R2 runes "The Frost Saint walks again" (232) | F | frost_saint_runes 024:108; shrine_cleanse 026:1190 |
| 23 | R2 Blessing of Warmth (235) | F | 026:1203; 027:170-180 |
| 24 | R3 Echo Gate voices, own names, Sephek "The lake remembers" (240-248) | F | 026:1153-1160 (relocated, #26) |
| 25 | R3 Frost Saint's Sigil humming near the Heartroot (250) | Ch | becomes a Frostshard Sigil, 026:1174-1177; #31 |
| 26 | R3 two Mirror Wraiths spell VAULT (252) | F | 026:1166-1173 |
| 27 | T1 Bazaar read-aloud, two micro-climates (266-274) | F | ATMOSPHERE 2050, 048_E:474 |
| 28 | T1 Tarin Goldlash, liquid sunlight (280) | F | 024:296-309; build_ch6.rb:147 |
| 29 | T1 Mira's frost-glass mirrors = Avarice's scrying shards (282) | F | mira_stall 048_C:635; Mirna letters 048_B:353 |
| 30 | T1 possessed child, twin mirror (284) | Ch | #30; 048_C:660; 033:229 |
| 31 | T2 Rooted Hearth read-aloud, murals (289-295) | F | hearth_drinker 024:132; hellen 024:320-325 |
| 32 | T2 Rumours d6 (297-308) | F | RUMOURS 024:499-513, all six |
| 33 | T2 Hellen recognises them from the murals, keeps them as guests (311) | F | 024:320-358 |
| 34 | T3 Council Hall read-aloud, four crystals (315-319) | F | 024:528; council_heart 024:148 |
| 35 | T3 Kelyn, Darrus, Selrae (326-330) | F | build_ch6.rb:170-174 |
| 36 | T3 expansion debate (332) | C | #14 |
| 37 | T3 forged decree with Avarice's sigil in the wax (334) | F | 024:537-539; harget_decree 048_C:482-493 |
| 38 | T4 Spire Armory: blooming targets (341-343) | F | armory_targets 048_B:38 |
| 39 | T4 Rheven, Reptin's successor (345) | F | 026:190-213 |
| 40 | T4 Still Beast hunt (347) | F | 048_D:185-235; build_ch6b.rb:98 |
| 41 | Hook: mirrors spread Avarice's consciousness (354) | F | Mirna letters; Felka 048_C:167; jast_mirror |
| 42 | Hook: Winter Matron funds the Halo (356) | F | selrae_hall 048_D:389-394; 033:386 |
| 43 | Hook: Cycle Day effigy ignited with divine power (358) | F (renamed) | festival_effigy 048_F:644; #28 |

### Part II-B
| # | Element | Verdict | Evidence |
|---|---|---|---|
| 44 | Canopy atmosphere (375) | F | ATMOSPHERE 2061 |
| 45 | C1 Shrine read-aloud, orb (380-384) | F | twin_orb 026:851-858 |
| 46 | C1 worshippers sing the Cycle Canticle (390) | C | #16 |
| 47 | C1 dream-vision from the wyrmlings (393) | F | bloom_guard_visions 026:893-956 |
| 48 | C1 Halo splinter channels Auril into Frostina (395) | F | orb_halo_scene 048_D:46-64; build_ch6b.rb:121-122 |
| 49 | C2 Library read-aloud; records every story (400-408) | F | eirwen 026:340-353 |
| 50 | C2 Eirwen; Naerth's ledger (410-412) | C | #12 |
| 51 | C2 Alberica's handwriting centuries old (414) | F | library_note 026:366-369; chat 026:453 |
| 52 | C3 Rift read-aloud; Glimmer's communications (419-429) | F | 029:60-139 |
| 53 | C3 auroral-storm portals to the Frostfell (431) | F | night_auroral_storm 048_E:350; frostfell_portal 048_E:414; build_ch6b.rb:125 |
| 54 | C3 ice-winged angels bearing Avarice's mark (433) | F | 048_E:419-422 |
| 55 | C4 Aerie Markets goods (438) | F | aerie_mart 026:713; build_ch6b.rb:134 |
| 56 | C4 sky-sailor duels (444) | F | sky_wren, sky_talla |
| 57 | C4 aarakocra seer "frozen half dreams of walking"; motes (446-448) | F | 026:286-297 |
| 58 | Upper hook: prophecy "Frost Saint will climb the Spire when the roots bleed" (455) | F | prophecy_leaf 048_G:14; build_ch6b.rb:154 |
| 59 | Upper hook: Matron wants martial law on the Canopy (457) | F | 024:567 |
| 60 | Upper hook: Glimmer's Trial, celestial envoy (459) | M | #1 |
| 61 | Heartroot atmosphere (468) | F | scene_heartroot_enter 025:124 |
| 62 | H1 Root-Gate rune puzzle and Sap Wraith (473-481) | F | 025:140-219 |
| 63 | H2 Sap-Wells heal plus visions; three Vault Map fragments (486-492) | F | sap_well 033:315-343; vault_map_1/2/3 (025:235; 033:336; 047b:613) |
| 64 | H3 Mirror-Root Vault read-aloud (497-503) | F | scene_mirror_root_enter 046_DeepLabyrinth.rb:955 |
| 65 | H3 Avarice's first homunculus, failed vessel for Auril (507) | F | ice_mask 046:983; homunculus_remains sign |
| 66 | H3 Mirror Sentinels (509) | F | mirror_root_wards 046:964-981 |
| 67 | H3 clues to the Draconic Vault of Ithryn Athis (511) | F | 046:986-993 |
| 68 | H3 pit mirrors the frozen world; stepping in crosses time (513) | F | mirror_pit 046:998 (used for Var, #35) |
| 69 | H4 Frost Saint Shard: destroy → Blessing of Verdant Fire; leave → "goddess still waits" (518-528) | F | 034_Chapter8.rb:626-680 |
| 70 | Hook: Avarice's devices draw on the tree; Reptin senses corruption (536) | F | Reptin heartroot chat 025:80; whispering_sapling 048_E:634 |
| 71 | Hook: Verdant Sickness, black sap (538) | F | Bryn's rot 048_B:101-110; myconid blight |
| 72 | Hook: rune puzzle opens a conduit to the White Vault (540) | Ch | #32 |
| 73 | Cycle Day Festival read-aloud; cult's chosen moment (545-553) | F (renamed) | scene_festival_night 024:412; festival_opening 048_F:628; #28 |

### Part III-A - Factions
| # | Element | Verdict | Evidence |
|---|---|---|---|
| 74 | Council symbol and motto (573-575) | F | 024:562-563 |
| 75 | Four seats incl. the empty Summer Marshal (579-585) | F | 024:528-535 (Var missing) |
| 76 | Tensions: Kelyn vs Selrae (589) | C | #14 |
| 77 | Darrus funds relic hunts via Corsair channels (591) | F | heist_delivery 048_D:940-943 |
| 78 | Selrae shelters the Halo (593) | F | 048_D:389-394 |
| 79 | Hook: A Season Too Long, a Rootwarden ritual gone wrong (598) | F | kethan_business 048_D:299-304; ash 048_D:329 |
| 80 | Hook: The Frozen Edict (600) | F | harget_decree 048_C:482 |
| 81 | Hook: Political Favor Track (602) | C | #9 / B3 |
| 82 | Rootwardens symbol and creed (611-617) | F | crypt_door_shut 026:387; armory_sign 048_B:19 |
| 83 | Circles Claw/Bough/Seed (623) | F | warden_claw, bough_teo, warden_seed/bryony |
| 84 | Crisis: Bough missing, reanimated by constructs (629) | F | still_beast 048_D:203-235 |
| 85 | Infiltrator feeding the Halo (631) | F | Ash 048_D:321-341 (suspicion moved to Kethan, per dossier) |
| 86 | Hook: Oath of Roots (638) | F | oath_pillar 048_D:239-278; build_rootspire_life.rb:171 |
| 87 | Halo symbol, goal, leadership (647-649) | F | halo_ambush token 048_E:345; Eline |
| 88 | Halo hideouts: the Shrine and the Frozen Cellar under the old brewery (652-655) | F | build_rootspire_life.rb:120, 211-225; gurk 048_C:282 |
| 89 | Beliefs: thaw is heresy; Sephek = Frost Saint (659-661) | F | 024:611; halo trainer lines |
| 90 | Merge Sephek's shard with the Tree's sap (664) | Ch | #29 |
| 91 | Members: fallen Rootwardens; mirror-glass prayer tokens (669-671) | F | Sister Wenna 024:67; Alerion chat 024:168 |
| 92 | Hook: Echo of Saint Kaltro (676) | Ch | #29 |
| 93 | Hook: Rite of Stillness during Cycle Day (678) | Ch (timing) | 024:603-636; #28 |
| 94 | Hook: Selrae's Secret fractures the Council (680) | F | selrae_heartroot 033:381-416; ch7_council 025:102-105 |
| 95 | Corsairs: symbol, Mira as captain (689-691) | F | corsair_sailor 048_C:683-688; mira_stall |
| 96 | Corsairs: Boreal Requiem relic vault with the wyrmling scale core (700) | F | requiem_vault 048_D:481-496 (integration choice) |
| 97 | Hook: Mirror, Mirror (706) | F | 048_C:635-680; 033:229-304 |
| 98 | Hook: The Frozen Run (708) | F | ivran 048_D:498-545; build_rootspire_life.rb:361-388 |
| 99 | Corsair alliance / naval support (710) | F | corsair_favour; departure(:ship) 033:266 |
| 100 | Guild symbol and Hew (719-720) | F | guild_vault 048_D:894; 026:218 |
| 101 | Guild mines brush the Heartroot; workers vanish (725) | F | 033:89-130 |
| 102 | Frozen sap fuel, partly sentient (727) | F | guild_amber 028:91; amber_assessor 048_D:654 |
| 103 | Hook: The Amber Experiment (732) | F | 048_D:654-677; build_ch6.rb:131 |
| 104 | Hook: Sabotage at the Mine (734) | F | sap_cache 033:132-157 |
| 105 | College; Aldric (as Professor Wynsnow), "chronal anomalies" (739-746) | F | 026:786-844; scholars |
| 106 | Hook: Lecture in Blue Fire (750) | F | 026:823-844 |
| 107 | Hook: Chronal Debt (752) | F | wynsnow_chronal 048_D:448-476 |
| 108 | Intrigue Web Overview (757-774) | F | delivered across 048 |

### Part III-B - NPC profiles
| # | Element | Verdict | Evidence |
|---|---|---|---|
| 109 | Kelyn: face, personality, old grief (784-792) | F | 024:519-574 |
| 110 | Kelyn: communes with Razzilith's dreams (795) | F | kelyn_orb 048_D:72-112; build_ch6b.rb:123 |
| 111 | Kelyn: sanction as Wardens Emeritus; secret terror of Auril (582, 798) | C | #10 |
| 112 | Kelyn: chamber mural of Reptin and Glimmer (804) | F | kelyn_mural 048_D:28-32; build_ch6.rb:175 |
| 113 | Kelyn: betrayal hook, verdant surge (806) | F | kelyn_surge 048_D:115-130 (#23) |
| 114 | Var: face, personality, Naerth guilt (811-822) | F | mirror_pit 046:1015-1016 (#35) |
| 115 | Var: wants to test Alerion (825) | F | 046:1017, 1024-1036 |
| 116 | Var: secret Corsair arms deal (831) | F | 046:1010-1012; 046_ForgeRooms:802 |
| 117 | Var: relic glaive resonates with Sephek (833) | C | #7 |
| 118 | Darrus: tiefling, velvet, clove bark (838-846) | F | 024:534; 048_D:819 |
| 119 | Darrus: relic dealing; blackmailed by an Avarice construct (849) | F | 048_D:941-943 |
| 120 | Darrus: Meat Meat's reliquary job, the Mirror Mother's heart (852) | F | darrus/heist 048_D:808-960 |
| 121 | Darrus: if exposed, flees to the Corsairs (856) | F | 048_D:944-945, 966-979 (integration choice) |
| 122 | Darrus: ruin could collapse trade (858) | C | #15 |
| 123 | Darrus: redemption by financing the White Vault expedition (860) | C (payoff unread) | B2 |
| 124 | Selrae: widow in furs, controlled, melancholy (865-873) | F | 024:145-147 |
| 125 | Selrae: secret Halo patron (876) | F | 048_D:389-394 |
| 126 | Selrae: courts Glimmer as Auril's vessel (879) | F | selrae_court 048_D:400-422 |
| 127 | Selrae: black-ice dagger whispers prayers (883) | F | 048_D:411-412 |
| 128 | Selrae: villain or redeemable (885) | F | home/ahead choice 033:396-407 |
| 129 | Selrae: calls the Vault "the White Womb" (887) | F | 033:395; 048_D:414 |
| 130 | Rheven: dreams of the tree screaming (900) | F | rheven_hall 048_D:142; festival 024:434 |
| 131 | Rheven: Heartroot hungry; will destroy it (903) | F | 048_D:143-144 |
| 132 | Rheven: asks Reptin whether violence can serve balance (906) | F | 048_D:146-171 |
| 133 | Rheven: direwolf, offspring of the party's old ally (912) | F | rheven_wolf 026:215; 024:435-437 |
| 134 | Rheven: leads the expedition that finds the machinery (914) | F | rheven_wall (w4); blight follow-up 048_D:175-178 |
| 135 | Eirwen: they/them, barefoot, frost-dust (919-927) | F | 026:345 |
| 136 | Eirwen: ledger proving Avarice manipulated the Speaker; means to publish (930) | M | #4 |
| 137 | Eirwen: treats Alberica's writings as holy; chronal leaves (933) | C | #12 |
| 138 | Eirwen: custodian of a Frostshard Sigil (937) | F | 048_D:561-571; 047c:127 |
| 139 | Eirwen: ritual to relive one day of the frozen past (939) | F | eirwen_ritual_offer 048_D:579-608 |
| 140 | Wynsnow: anchor the heroes' life-threads to Rootspire (955) | F | 048_D:455-470 |
| 141 | Wynsnow: offer to Glimmer and Alberica (958) | F | 048_D:450 |
| 142 | Wynsnow: temporal wight from the frozen world (962) | F | 026:826-836 |
| 143 | Hellen: cheerful matron, pine-mead, iron discipline (969-977) | F | 024:315-359; festival 024:418 |
| 144 | Hellen: shrine to the heroes in her cellar (980) | F | herald_shrine 026:263; build_ch6b.rb:47 |
| 145 | Hellen: "The Heralds will drink once more..." (983) | F | cellar_sign 026:262 |
| 146 | Hellen: quest-giver for low-violence intrigue (987) | C | gives directions and rests; no missions of her own |
| 147 | Hellen: old passages from the tavern to the docks (989) | M | #5 |
| 148 | Eline: pale, threadbare blue, silence is mercy (1002-1010) | F | eline 024:603-636 |
| 149 | Eline: rite with the Tree's sap and Sephek's heart (1013) | Ch | #29 |
| 150 | Eline: tries to convert Glimmer and Selrae (1016) | F | eline_conversion 048_D:426-443 (#24) |
| 151 | Eline: reversed prayer if captured; final foe or martyr (1020-1024) | C | #8 |
| 152 | Eline: ritual circle under the docks leads to the Heartroot (1022) | C | the shrine connects only to the Root-Tier |
| 153 | Sephek: mirror-ice statue; hooded-pilgrim visions (1033-1037) | C | living ice 024:606; no pilgrim visions (Missing #2) |
| 154 | Sephek: wants Meat Meat's blood ("Prototype Verdant"); Alerion as his rival (1046) | M | #2 |
| 155 | Sephek: cannot die inside Rootspire; reforms (1050) | F | 047c:169-180 |
| 156 | Sephek: defeat drops a Frostshard Sigil (1052) | F | 047c:181-185 |
| 157 | Sephek: redemption, "Auril's silence honours her" (1054) | F | 039_Chapter13.rb:331 |
| 158 | Mira: silver hair, mirrors, plural speech (1063-1067) | F | 048_C:638-641; 033:273 |
| 159 | Mira: Avarice's intellect in her mirrors; "The Vault stirs" (1070-1073) | F | 033:273-277 |
| 160 | Mira: saved by breaking the flagship's mirror-core (1077) | F | 033:270-287 |
| 161 | Mira: if left possessed, becomes Avarice's new body (1079) | M | #6 |
| 162 | Mira: redemption grants naval aid (1081) | F | 033:303; 048_C:686 |
| 163 | Avarice Reforged: crystalline body in the White Vault; Seraph-Draco (1091-1097) | F | 047c:15-20, :307 |
| 164 | Avarice: "variables that refused to die" (1100) | F | 048_C:671; 048_B:353 |
| 165 | Avarice: appears only in mirrors and dreams (1104) | F | ambient 048_E:574; night_reflection_smiles |
| 166 | Avarice: body like the Mirror Mother's, framed in machinery (1106) | F | 047c:336 |
| 167 | Avarice: whispers each PC's birth-cry (1108) | M (minor) | listed under Missing |
| 168 | Lorn Scribe: blind dwarf, writes backwards, riddles per hero (1117-1127) | F | 026:355-361; build_ch6b.rb:148 |
| 169 | Lorn Scribe: works for the Tree; turns to script when slain; keeps Alberica's pages (1124-1133) | F | lorn_scribe 048_F:555-573 |
| 170 | Eren Frostborn: Auril's gift of memory; Alerion's soul (1142-1149) | F | eren_armory 048_D:347-379 |
| 171 | Eren: pupil or tragic mirror; bow of Frostina's scale (1156-1158) | F | 048_D:353, 360-375 |
| 172 | Hew: construct prays to the Tree as "Father" (1171) | F | father_construct 033:159-182 |
| 173 | Hew: device with a dormant Avarice code fragment; horror turn (1174-1177) | M | #3 |
| 174 | Still Ones: mid-gesture revenants; four virtues (1185-1192) | C | 026:1209-1243 (#11) |
| 175 | Intrigue Web Summary (1196-1208) | F | across 048 |

### Part IV-A - Heartroot Labyrinth H1-H26
| # | Element | Verdict | Evidence |
|---|---|---|---|
| 176 | Read-aloud introduction (1221-1225) | F | scene_heartroot_enter 025:129-133 |
| 177 | H1 Root-Spiral approach; rhythmic knocking (1273-1279) | F | 025:129-137; root_door_shut 025:58 |
| 178 | H2 Runic Seal Circle; Sap Wraith with lair vision (1282-1286) | F | 025:161-219 |
| 179 | H3 Warden's Overlook, "She will take the heart if we don't" (1289-1295) | F | warden_overlook 025:60; build_ch7.rb:66 |
| 180 | H4 Rootguard Post: infernal tools, enthralled guards (1298-1304) | F | rootguard_post 025:64; thralls build_ch7.rb:67-70 |
| 181 | H5 Threshold of Dripping Gold (1311-1317) | F | scene_sap_wells_enter 025:224 |
| 182 | H6 Central Wells: heal, visions, backlash, map fragments (1320-1324) | F | 033:315-343 |
| 183 | H7 Overflow Channel: slope, bones, map fragment (1327-1339) | F | 028:37-39, 100-102; map_fragment 025:235 (see B6) |
| 184 | H8 Whispering Attendant: answers for a promise (1342-1348) | F | attendant 033:345-376; promise paid 046_ForgeRooms:971-985 |
| 185 | H9-H12 Mirror Garden (lag, Reflection Ring clones + Verdant Seed, Shattered Bed shard + Focus, Perfume Grotto) (1356-1396) | F | 046_DeepLabyrinth.rb:237-378 |
| 186 | H13-H17 Hollow Core (bridge sentries, sap bursts/vines, Cocoon Gallery sovereign + captive, Frozen Drop time-lapse, Underdark Mouth) (1403-1463) | F | 046:383-537; build_ch7_deep.rb:129-132 |
| 187 | H18-H21 Vault of Amber Dreams (threshold glitches, Stasis Gallery core/notes/surge, Dissectory, Scriptory + Mirror-Ink Wraith) (1470-1515) | F | 046:605-872 |
| 188 | H22 Antechapel: Shard ghost-images you can question (1522-1534) | F | shard_echo 046_ForgeRooms:834-870 |
| 189 | H23 Heart Chamber, three-way ending (1537-1539) | F | 034:377, 626-680 |
| 190 | H24 Breaking Circle runes (1541-1551) | F | 034:463 |
| 191 | H25 Sloughing Veins escape (1554-1560) | F | 046_ForgeRooms:927-962 |
| 192 | H26 Echo Vault: seeds, chardalyn, tree prophecy (1563-1577) | F (sigil moved, #31) | 046_ForgeRooms:964-1051 |
| 193 | Treasure: Verdant Fire Charm, Cycle of Roots, personal visions (1611-1617) | F / C | items 046_ForgeRooms:1009-1015; visions only look back (#19) |
| 194 | Transition: Labyrinth concludes the Rootspire arc (1622-1625) | Ch | #33 |

### Part IV-B - Relics, downtime, transition, appendix
| # | Element | Verdict | Evidence |
|---|---|---|---|
| 195 | Meat Meat's blade: chest in the silt, V-7 page, dream, weapon-or-seed, curse faces, Eirwen fragment (1633-1667) | F | driftwood_chest 026:1025-1060; curse 048_G:193-203; fragment 048_F:307-309 |
| 196 | Reptin's staff: crypt, petrified druids, totem, inscription (1671-1700) | F | 026:1062-1092; build_ch6b.rb:174-186 |
| 197 | Reptin's staff attunement at the Wall (1683) | C | #17 |
| 198 | Alerion's mantle: boundary hunt, frozen hunter, "Finish the step", catch the predator, Boundary Stone (1712-1752) | F | frozen_hunter/rime_stalker 026:1245-1292; boundary_stone 026:253 |
| 199 | Alberica's key: sub-vault, music-note lock, Canticle before dawn, failed-bard voices (1756-1771) | F | subvault 026:961; council_pillar 026:986-1020 |
| 200 | Alberica's Verse XI lore fragment (1786) | M (minor) | listed under Missing |
| 201 | Glimmer's Lumen Shard: discovery, shadow question, trial, inscription (1791-1818) | Ch / C | owner decision; 029:60-139; rift_sign 026:336 (#18) |
| 202 | Downtime: Research the Sigils (1828) | F | research_sigils 048_D:611 |
| 203 | Downtime: Council Petitions (1830) | F | council_petitions 048_G:96-132 |
| 204 | Downtime: Tree Communion (1832) | F | tree_communion 048_D:627; build_ch6.rb:132 |
| 205 | Downtime: Festival of Balance, safe haven (1834) | F | festival_of_balance 048_G:134-149 |
| 206 | Transition to the White Vault read-aloud (1841-1847) | F | try_merge_sigils 047c:103-112 |
| 207 | Appendix: Verdant Fire Charm, Cycle of Roots, Verdant Seed, Mirror Lens, Blessing of Verdant Fire, Blessing of Still Sky (1855-1861) | F | 046_ForgeRooms:1013-1015, 1097; 034:669; 026:1241 |
| 208 | Campaign notes: relics as White Vault keys; factions decide companions (1869-1871) | C | #20 |

### Merchant & Downtime Compendium
| # | Element | Verdict | Evidence |
|---|---|---|---|
| 209 | 1 Run & Bloom: Bryn; stolen rebirth sap (1931-1975) | F | bryn 048_B:92; build_rootspire_life.rb:146 |
| 210 | 2 Sap-Smith: Gorran; voices in the flame (1980-2024) | F | gorran 048_B:130; build_ch6.rb:149 |
| 211 | 3 Auroral Atelier: Lumea; escaped illusion (2029-2073) | F | lumea/atelier_fox 048_B:161-193 |
| 212 | 4 Glasswater Outfitter: Tirena; shifting maps; Auroral Compass (2078-2120) | F | tirena 048_B:198; compass_use 048_F:726 |
| 213 | 5 Wind-Glass Library counter: Solvaran; codex under the floor; Echo Codex (2125-2167) | F | solvaran 048_B:217; build_ch6b.rb:149 |
| 214 | 6 Shrine of Balance: Ysera; "dragon of light trapped below" (2172-2214) | F | ysera 048_B:233 |
| 215 | 7 Still Sky black market: Eira Voss; 10% curse (2219-2261) | F | eira_black_market/black_market 048_B:267-305 |
| 216 | 8 Rootwarden Hall: Kethan; hammering under the Heartroot (2266-2308) | F | kethan 048_B:310 |
| 217 | 9 Ink & Ember: Mirna; Avarice's mirror-glass letters (2313-2353) | F | mirna/mirror_letters 048_B:332-362 |
| 218 | 10 Crystal Quill: Filgen; blank scrolls whisper names (2358-2398) | F | filgen/blank_scrolls 048_B:367-387 |
| 219 | 11 Gem & Thorn: Arvoss; gem hums near the vault (2403-2443) | F | arvoss/humming_gem 048_B:392-409 |
| 220 | 12 Perfumed Root: Lirielle; prophetic fire vision (2448-2488) | F | perfumer/perfume_prophecy 048_B:414-437 |
| 221 | 13 Verdant Stables: Thim; beast heard the tree cry (2493-2533) | F | thim/stable_beast 048_B:442-472 |
| 222 | 14 Mirror-Dust: Jast; buying shards for a collector (2538-2578) | F | jast/jast_mirror 048_B:477-519 |
| 223 | 15 Auroral Arms: Brogar; crystal arm hums (2583-2623) | F | brogar 048_B:524 |
| 224 | 16 Suncleft Emporium (closed): Helion missing, works with Avarice (2628-2668) | F | suncleft_door/helion_mural/shelves/hatch 048_B:591-646 |
| 225 | 17 Thorned Ledger Bank: the Accountancy; spore says "Avarice" (2673-2713) | F | accountancy/counting_spore 048_B:543-586 |
| 226 | 18 Frost-Thread: Maera; Autumn's crowning robes (2718-2758) | F | maera/crowning_robes 048_B:651-691 |
| 227 | Night events 1-10 (2763-2787) | F | 048_E:217-441, all ten plus the Verdant Storm |
| 228 | Down-the-root hooks x6 (2792-2804) | F | DOWN_THE_ROOT 048_E:584-593; heat_rising; humming_gem |

### Seasonal Factions & Intrigue Dossier
| # | Element | Verdict | Evidence |
|---|---|---|---|
| 229 | Spring: Bryn appearance, cues, secret root-rot (2821-2840) | F | 048_B:94-110 |
| 230 | Spring: Lirielle appearance, cues, burning-roots dreams (2844-2863) | F | 026:162-180 |
| 231 | Spring events: Blooming Name, Whispering Sapling (2871-2883) | F | 048_E:488-493, 515-519, 634-646 |
| 232 | Winter: Ysera, harvested souls (2897-2916) | F | 048_B:244-253 |
| 233 | Winter: Kethan, Skytower goliath, Summer infiltrator (2920-2939) | F | 048_B:312-321; 048_D:282-341 |
| 234 | Winter events: Frost Warning, Silent Watcher (2947-2958) | F | 048_E:494-499, 520-523 |
| 235 | Autumn: Lumea's propaganda (2973-2992) | F | 048_B:170-178 |
| 236 | Autumn: Maera's coronation garb for Summer (2996-3015) | F | 048_B:659-675 |
| 237 | Autumn event: Leaf on the Pillow (3023) | C | #21 |
| 238 | Autumn event: Fox of Light (3030) | F | 048_E:524-529 |
| 239 | Summer: Gorran channels infernal ore for Avarice (3051-3070) | F | 048_B:138-148; ore_crates 048_E:649 |
| 240 | Summer: Helion Vael, Herald of Eternal Summer (3074-3092) | F | helion_mural 048_B:612-624 |
| 241 | Summer events: Warm Window, Scorched Mark, Ember Footprint (3098-3115) | F | 048_E:506-510, 544-551 |
| 242 | Halo: Eira Voss delivers souls to the forge (3131-3150) | F | frozen_flame_altar/eira_voss_cellar 048_D:992-1022 |
| 243 | Halo: Jast collects shards showing futures where Avarice wins (3154-3173) | F | jast_mirror 048_B:507-519 |
| 244 | Halo events: Flicker of Faith, Pocket Shard, Perfect Stillness (3179-3197) | F | 048_E:511-514, 530-539 |
| 245 | Solo-ambient d12 (3203-3253) | F | AMBIENT 048_E:570-582 (11) + ambient_note (12th) |
| 246 | Faction locations summary (3259-3268) | F | placements match |
| 247 | Overall tone: observed, admired, stalked (3272-3293) | F | throttled vignettes 048_E:595-629; all_watchers line 048_D:1050-1053 |

### 20 New NPCs (all placed; secret reveals checked)
| # | NPC | Verdict | Evidence |
|---|---|---|---|
| 248 | 1 Talwyn: follows them; Frostina circling the Heartroot | F | 048_C:13-49; build_rootspire_life.rb:125; build_ch6b.rb:97 |
| 249 | 2 Jorik: smuggles ore for Gorran | F | 048_C:55-87; build_ch6.rb:229-230 |
| 250 | 3 Serelle: "god of light made wrong" | F | 048_C:93-109; build_rootspire_life.rb:252 |
| 251 | 4 Pimmlet: Shimmer's Heart scroll | F | 048_C:115-137; build_ch6b.rb:150 |
| 252 | 5 Reva: vine-person spy for Autumn | F | 048_C:143-161; build_ch6.rb:109 |
| 253 | 6 Ivran: wyrmling silhouettes under the Glasswater | F | 026:376-382; 048_D:498 |
| 254 | 7 Felka: mirror shard with Avarice's voice hidden in the roots | F | 048_C:167-190; build_ch6.rb:130 |
| 255 | 8 Old Yorin: prophecy in rhyme | F | 048_C:196-230 |
| 256 | 9 Dathra: Deepfire Quartz for the Engine | F | 048_C:236-269; build_ch6.rb:150 |
| 257 | 10 Gurk: hammer whispers warnings | F | 048_C:275-295 |
| 258 | 11 Elitha: sculpture imprisoning a sliver of Auril | F | 048_C:301-330 |
| 259 | 12 Pellar: Autumn's coded notes | F | 048_C:336-355 |
| 260 | 13 Selene: scripture of the Heralds | F | 048_C:361-384; build_ch6b.rb:124 |
| 261 | 14 Krolf: Sephek's voice in the Gate's wind | F | 048_C:390-412; build_ch6.rb:129 |
| 262 | 15 Viessa: candles map Avarice's magic | F | 048_C:418-439 |
| 263 | 16 Harget: blackmail over the Heralds charter | F | 048_C:446-479 |
| 264 | 17 Mira Thynelight: identity-stealing garments for Maera | F | 048_C:500-529 (needs a new rs_day) |
| 265 | 18 Shivven: Auril-like silhouette in the deep | F | 048_C:535-554; echoed by Ivran 048_D:536-539 |
| 266 | 19 Halden Vex: reset them to their origin | F | 048_C:560-599; build_ch6b.rb:151-152 |
| 267 | 20 Rilka: sent by Glimmer's future church | F | 048_C:606-628 |

### 10 Surveillance creatures (WATCHERS 048_A:212-240; watcher() 048_D:1028-1056)
| # | Watcher → master | Verdict | Placement |
|---|---|---|---|
| 268 | Root-Hollow Stalker → Bryn | F | build_ch6.rb:134; unlocks Bryn's confession |
| 269 | Frost-Veil Shade → Ysera | F | build_rootspire_life.rb:253; unlocks Ysera's warning |
| 270 | Auroral Moth-Swarm → Lumea | F | build_rootspire_life.rb:254 |
| 271 | Infernal Ember-Rat → Gorran | F | build_ch6.rb:151; opens the Suncleft 048_B:594 |
| 272 | Mirror-Shard Homunculus → Jast | F | build_ch6.rb:233 |
| 273 | Garden-Whisper Weasel → Maera | F | build_rootspire_life.rb:255; unlocks Reva |
| 274 | Soul-Thread Wraithling → Ysera + Rootwarden captains | F | build_ch6.rb:135 |
| 275 | Echo-Rune Beetle → Lumea | F | build_rootspire_life.rb:264 |
| 276 | Snow-Still Raven → Eira Voss | F | build_ch6.rb:234 |
| 277 | Shadow-Heat Lurker → Avarice | F | build_ch6.rb:162 |

(Not audited, by design: shop stock lists, prices and economy rules, DCs and stat blocks. The game turns each shop's ten items into Pokémon goods: MARTS in 048_A:108-146.)
