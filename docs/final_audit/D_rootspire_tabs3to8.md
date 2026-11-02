# Final audit D: rootspire.md lines 7089-10436 (Tabs 3, 4, 5, Shadow Mycolith, 6, 8)

## How I checked

I read every source line in the slice in chunks of 300-320 lines: 7089-7388, 7388-7687, 7688-7987, 7988-8287, 8288-8587, 8588-8887, 8888-9187, 9188-9507, 9508-9827, 9828-10137 and 10137-10436.

I then read the implementing code. Files read in full: 025_Chapter7 (Root Gate / Sap Wells), 028_Heartroot, 046_DeepLabyrinth, 047b_TrialWeek, 047c_WhiteVault (sigils, both Sephek avatars, relics), 036_Chapter10 lines 60-1954, and 047a_Undercanopy lines 40-719. Files read in the relevant parts: 033_Chapter7B (wells, attendant, twin mirror), 032_Chapter7A (blight, lake, Mycolith), 034_Chapter8 (Heart Chamber, Breaking Circle, Shard choice, Autumn's fall), 046_ForgeRooms (Zone VI), 026_Rootspire (Canticle), 048_Rootspire_C/D/F/G/H (A2, M1, M2, R2, A1 hook, GQ3, petitions), 047d_FixRound (tower ledger, Heralds' candidacy, election stance), 037_Chapter11 and 039_Chapter13 (where Sephek is fought).

For reachability I wrote a Marshal dumper (scratchpad `d_work/idx.rb`). It lists all 3,344 event pages in `build/maps/*.rxdata`, with their switch, self-switch and variable conditions and their script/transfer commands. I traced every story function in my slice to a map event or to a caller, and traced each gating switch to the place that sets it. Nothing under /home/claude/frost-thaw was modified.

I compared with docs/reaudit/D only after finishing my own pass. Most of its 29 findings are now fixed: the Maze reset, `check_nomination`, the leaf evidence, `:memory_bubble`, `:hyphora_alibi`, Mira's return, GQ3 rebuilt, the tower Ledger, the run/neutral election, M2 and B1 rebuilt, Blessing of Verdant Fire moved to Sanctify, and the flags it listed as never read. One of its findings is still partly open: the Maera Vell branch (bug 1 below).

## 1. Summary

128 story-bearing rows checked (section 3).

| Verdict | Rows |
|---|---|
| Full | 114, of which 6 have a minor change of place or route noted (rows 39, 41, 47, 50, 108, 122), and 5 hold bugs or gating (rows 46, 100, 102, 110, 119) |
| Compressed | 9 |
| Changed | 4 (rows 31, 35, 59, 109) |
| Missing | 1 (row 74) |
| Unreachable | 0 outright; 1 conditional gap (Mira's services, inside rows 110 and 119; section 2 item 4) |
| Bugs | 7 (section 2 items 1-3 and 5-7; item 4's possessed-Mira contradiction makes 8) |

Section 2 lists 21 ranked items: every non-Full row, plus the bugs and changes that sit inside Full rows.

**Honest judgement:** this slice is now very well covered, and every section has a reachable home:

- all 37 Heartroot areas;
- both Sephek stages, with Auril's relics;
- all ten personal quests and all five group quests;
- the whole Undercanopy, the Shadow Mycolith with its lake minions, and its hoard;
- the full Tab 8 trial week: the Tribunal, five charges and their evidence, the walls, the debates, petitions and nominations, the Verdict, the Hyphora appeal and the Vote.

The notes' skill challenges are choice prompts with the notes' success and failure counts (3-before-2, 4-before-2, 5-before-3, 6-before-3), and failure branches lead to fights. What remains is mostly continuity, not missing content. The worst problems:

- **The Darrus/Maera branch still leaks.** The Tribunal and the Verdict say "the Autumn Warden died" even when Darrus fled alive.
- **Darrus's NPC is never removed** from the Council Hall. He keeps chatting there after he dies at the Forge, and during the trial at which his chair is draped in white.
- **Darrus speaks at the Ch7 council** even if he was exposed and fled during the Ch6 week.
- **Mira's whole trial-week role is gated on Gym 6 being settled.** If it isn't, Q4's ritual can't be done, and her testimony and memory vial are lost.

The judgement calls (Avarice as the Heart Chamber boss, Sephek's two stages split across Ch11 and Ch13, the third sigil moved off the Echo Vault) are reasonable integrations.

**Integration choices judged:**

- **Darrus exposed, flees to the Corsairs, Maera at the Forge.** Sound, and it resolves a real contradiction (M1 exposes Darrus, but Tab 8 Q2 has Autumn killed). The implementation is incomplete: see bugs 1-3.
- **"Pell" for the notes' junior warden.** The in-game name is now **Ivo** (036_Chapter10.rb:1112-1131, witness 036:123); only the function and switch are still called `pell`. That is faithful to Q3, and the brief's name is out of date. He is at the Root-Tier tunnel mouth (map 2055, switch 4153), not in the Mirror Maze.
- **Wyn's colony is the Undercity, the deep end of the Smuggler's Run.** Faithful: W1's read-aloud literally sets it "beneath the Root-Tier docks, the Smuggler's Run". It is reached from 2198 through a crack gated by switch 4127, which opens when Wyn travels with you.
- **Razzy's scale core.** Outside this slice; nothing here contradicts it.

## 2. Every row that is NOT Full (and the bugs inside Full rows), ranked

**1. BUG: in the exposed branch, the Tribunal and the Verdict still say "the Autumn Warden died by Meat Meat's hand".**
- Source: 10300-10314 and 10427.
- Where: 036_Chapter10.rb:293 (scene_tribunal: "Meat Meat is charged separately. The Autumn Warden died by her hand.") and 036_Chapter10.rb:1826 (scene_verdict: "The death of the Autumn Warden, by Meat Meat's hand...").
- With `:heist_exposed`, the Autumn Warden (Darrus) fled alive to the Corsairs. He can be met at the Run's moorings: 048_Rootspire_D_Quests.rb:947-959, map 2198, switch 4165. The person who fell at the Forge was Maera Vell (034_Chapter8.rb:313-321).
- Everything else in Ch10 already goes through `autumn_hand` and `witness_line`. These two lines don't.
- Fix: `"#{autumn_hand[:title]} died by her hand"` (and the same in the verdict). In the Maera branch the title would read "Autumn's Maera Vell".

**2. BUG: Darrus's Council Hall NPC never goes away.**
- Source: 10394 ("Four chairs await, two empty") and 10427 ("empty chairs draped in white cloth where Summer and Autumn once sat").
- Map 2054, event 7 "Darrus Fell" (8,13): it has one page with no condition and the sprite "BW (55)". It calls `FT.darrus`.
- `darrus` (048_Rootspire_D_Quests.rb:789-796) returns `talk(:darrus_fell)` unless the heist was exposed. That text (024_Chapter6.rb:140) is "DARRUS: Law and trade, Wardens. Find who forged that decree...".
- In the normal branch, Darrus dies at the Forge in Ch8 (034_Chapter8.rb:323-367). He still stands in the Hall and says that line all through the Ch10 trial over his own death.
- In the exposed branch, his sprite still stands there while he says "Darrus's seat is empty".
- Fix: add a page that is blank or empty-chaired, conditioned on SW_AUTUMN_FELL. Have `darrus` say the empty-chair line when `flag?(:autumn_fell) || flag?(:heist_exposed)`.

**3. BUG: Darrus speaks at the Ch7 council after being exposed in Ch6.**
- The heist opens as soon as `:wardens_emeritus` is set, which is the start of the festival week (024_Chapter6.rb:614; 048_D:794-799). So it can be completed, with Darrus running ("Darrus runs... toward the water", 048_D:925), before the festival ends.
- `ch7_council` then has him speak anyway: 025_Chapter7.rb:97 ("DARRUS: The Halo are off the streets...") and 025_Chapter7.rb:109 ("DARRUS: (not looking up) And watch what you sign for").
- Fix: when `:heist_exposed`, swap those for Kelyn or Selrae lines, or "(Darrus's seat is empty.)".

**4. CONDITIONALLY UNREACHABLE: Mira's trial-week services need Gym 6 to be settled.**
- Source: 10320 (Q2 Mira testimony and favour), 10341 and 10402 (memory vial, 50 gp), 10354 and 10362 (Q4 frost-glass mirror and advice), 10417 (her candidacy deed).
- Map 2055, event 5: page 0 has no script; page 2 (`FT.mira_trials`) needs switches 3974 (SW_MIRA_FREED) and 3988.
- `:mira_freed` is set only by Gym 6 (033_Chapter7B.rb:345 and 375). Gym 6 needs M2 finished, and M2 needs Meat Meat in the party (033:238-245). Road B and the Forge don't need Gym 6: `forge_door` only checks the Root-Key and the glass sigil (032_Chapter7A.rb:553-570).
- A player who skips the gym therefore loses all of these:
  - Q4 option (a), the ritual. `talion_ritual` requires FT_FROSTGLASS (036:1273-1276), which only Mira sells.
  - The Mira mirror testimony and Mira's favour.
  - The memory vial. Wyn's rapport is an alternative only when Wyn is along (047b:289).
  - Mira's platform deed (036:447).
- Related contradiction: the left-possessed branch says "no naval aid, no testimony" (033_Chapter7B.rb:357-359), but `mira_trials` (036:1319-1365) gives the testimony anyway.
- Fixes:
  - Make page 2 condition on switch 3988 alone, with a "possessed Mira" variant.
  - Or add a second frost-glass seller in the Bazaar.
  - Gate the `:who` option on `!flag?(:mira_left_possessed)`.

**5. BUG: the Council petitions describe the wrong chairs.**
- `council_petitions` (048_Rootspire_G_Hooks.rb:104-105) is open whenever `:engine_dead` is set, which includes the whole trial week. It says "SELRAE's empty seat is filled by her deputy" and "DARRUS's seat has a new Autumn Warden in it, very nervous."
- Tab 8 (10267 and 10427) and Ch10 (036:290, 1789) have Selrae presiding, and Autumn's chair empty and draped until the Vote fills it.
- Fix: gate `petition_bench` to before `:trials_open`, or after `:ch10_done`. Otherwise use the elected councillor's name (`council_*` flags), and drop the Selrae-deputy line once she is back (`:selrae_home`).

**6. BUG (pronouns): Wyn's vision at the Echo Vault uses "she/her/herself".**
- 046_ForgeRooms.rb:1046-1048 (ATTENDANT_VISIONS[:wyn]).
- Everywhere else Wyn is "they/their": HERALD_THEIR at 032_Chapter7A.rb:76, and 046_DeepLabyrinth.rb:574, 047b_TrialWeek.rb:305 and 483.
- Fix: "when they stand in the middle of it", "whispering their name", "themself sitting in it".

**7. BUG (minor): merging the sigils leaves two Frostshard Sigils in the bag.**
- `try_merge_sigils` calls `take_key(:FT_FROSTSIGIL)` (047c_WhiteVault.rb:113). That runs `pbDeleteItem(item)` with the default quantity of 1 (031_StoryItems.rb:52-53).
- All three sigils were given with `give` (047b:337, 047c:132 and 199, 048_D:581).
- Fix: `$PokemonBag.pbDeleteItem(:FT_FROSTSIGIL, 3)`, or loop until none are left.

**8. CHANGED (neither): Sephek's two avatars are two separate encounters in different places.**
- Source: 8138, 8187 and 8202. The notes have one confrontation "in Grimskalle or within the Heartroot", where the 2.0 form turns into 2.5 once the minions fall and his hit points drop below 50.
- The game:
  - The Minor Avatar is fought at the Shrine of the Twinned Dragons in Rootspire, in Ch11 (037_Chapter11.rb:139 calling 047c:140-206).
  - The Major Avatar comes only on the Crown branch where Sephek isn't turned, in Ch13 (039_Chapter13.rb:373 calling 047c:242-270).
- Kept:
  - Minor: two frost druids and ice mephits; half HP once all minions fall (047c:179).
  - Major: winter wolves, a coldlight walker, and Divine Rejuvenation while any of the three Auril relics in the Heartroot stands. The relics are on maps 2057/2058/2067 behind switch 4138, and are destroyed in `auril_relic`, 047c:215-237.
- Compressed away: the lair actions (Howling Gale, Mirror of Ice, Chill of the Grave; Blizzard Surge, Ethereal Frost, Grim Skulk), Frost Nova, Frost Chains, Auroral Storm, and the cumulative frost aura (one line of flavour at 047c:254).
- Judgement: an acceptable integration with the main plot. It doesn't betray the notes' idea of a prelude and a crescendo.
- Optional fix: give the Major Avatar fight one scripted "lair" beat per round, like the `heart_lair_actions` pattern at 034:492.

**9. CHANGED (owner-consistent): the Shard-destroy outcome.**
- Source: 8492 ("destroying ensures Sephek cannot return from this shard").
- `:shard_destroyed` makes Sephek return anyway, weaker and "wired back together from splinters" (047c_WhiteVault.rb:180-185; 037:127). Purify and Preserve also change his lines (039:355-371).
- This is how the main plot is built (Sephek always rises in Ch11), and the choice now visibly matters. Acceptable; it's worth a note to the owner.

**10. CHANGED (integration): the third Frostshard Sigil is not in the Echo Vault.**
- Source: 7393 (H26 treasure: "the third Frostshard Sigil").
- The Echo Vault gives a Verdant Fire charm, the Cycle of Roots scroll, the Mirror Lens, Verdant Seeds and the World Tree prophecy (046_ForgeRooms.rb:1003-1078).
- The game's three sigils come from the Echo Gate wraiths, Eirwen and Sephek (047c_WhiteVault.rb:7-9 and 94-96), following Tab 1. That is consistent with Tab 1, but differs from this tab.
- Fix (optional): have the Echo Vault's chardalyn shelf hum toward the Echo Gate as a pointer, so H26 keeps a sigil hook.

**11. CHANGED (integration): the Heart Chamber boss.**
- Source: 7588 (a "reduced Sephek-avatar" boss) and 7361 (the Frost Saint Shard).
- The H23 boss is Avarice: her opening, two Rootbreaker mechs, the Breaking Circle and the fight (034_Chapter8.rb:431-626). After that the Frost Saint Shard is fought as its own boss, with Frozen Sanctity and Auril's Echo pre-battle chip, and the twelve spires weakening it (034:757-787). The three-way choice follows (034:688-751).
- Faithful to H23 and H24's intent, and to the stat block. The "Sephek-avatar" overlay is replaced by Tab 2's Avarice. Acceptable.

**12. COMPRESSED: GQ2 and H6, the Sap Wells' map fragments.**
- Source: 8485 ("Each vision reveals a fragment... three fragments needed to progress") and 7144.
- The wells give one fragment, after all three visions (033_Chapter7B.rb:395-422). The others come from the Overflow Channel (025_Chapter7.rb `map_fragment`, map 2067) and the Drowned Hall beyond the Wall (047b:661-663).
- The fragments gate nothing. They only add a hint at the White Vault circuits (047c:328-331).
- Fix (optional): let three fragments open the circuit hint, or a shortcut at the Vault.

**13. COMPRESSED: Tab 5 Undercanopy details.**
- Source: 9157-9175 ("Cradles of Sprouts": harmed sprouts cry out and summon Yarro and two spore guards).
- Source: 9379-9383 and 9395-9399 (the ignitable acid slicks and the stalactites at the Tainted Lake).
- Source: 9729 (Eira summons unseen protectors and mirror-wraiths if the party is evasive or aggressive).
- Source: 9817 (Eira's request to confront Fractured Halo cultists in the Still Sky Shrine).
- None of these four has code:
  - `scene_undercanopy_enter` (032_Chapter7A.rb:142-161) always ends with "Pass".
  - `eira_development` (047a:581-613) offers the patrols and the spore-guard trial only.
  - The sprout mechanic is absent.
- The market staples (Frost-Fruit, Hyphal Rope, mushroom rations, goodberry spores, spore pouch, Potion of Spore Sight; 9826-9846) appear only as flavour text. Those are close to pure GM economy, so they rank low.
- Fixes:
  - An "evasive" answer option at Eira's "Declare your purpose" that triggers a two-wraith skirmish.
  - An Eira option pointing at the Shrine cultists (`shrine_cleanse` already exists in 026).
  - A sprout NPC in the gardens that brings Yarro running if it is pushed.

**14. COMPRESSED: god-point rewards for the Tab 8 quests.**
- Source: 10288, 10314, 10335, 10356, 10377 and 10431.
- `wheel` stands in for god points elsewhere: A1, A2, B1, R2 and GQ3 all call it. The Ch10 resolutions never call it:
  - `attunement_finish` (036:668-711): no `wheel(1)` for the test.
  - `wyn_alibi` (036:1134-1160).
  - The verdict and Meat Meat's commutation (036:1785-1847).
  - The vote (036:1849-1922).
  - The colony's recognition (036:1509-1520).
- Only Talion's release calls `wheel(1)` (036:1243 and 1299).
- The Q2 "outlaw" outcome (`:mm_outlaw`) is read only by the appeal in 036. Nothing after Act II reflects it.
- Fix: add the `wheel` calls the notes give, and have `:mm_outlaw` and `:anduin_leaving` appear once in Act III dialogue.

**15. COMPRESSED (harsher): the GQ4 return.**
- Source: 8533 ("failure delays them and triggers another time anomaly") and 8536 ("If trapped, they lose half their god points and require rescue").
- `beyond_return` (047b:670-679): any failed sprint means a wight and being trapped right away, with half the wheel lost (047b:682-697). The notes' intermediate "delayed, another anomaly" step is skipped.
- Fix: on the first failure, run one `time_hazard`-style anomaly and let the player retry. Trap only on a second failure.

**16. CHANGED (neither): Q2, the "assassination" of Autumn.**
- Source: 10300 ("Meat Meat previously assassinated Autumn").
- In 034_Chapter8.rb:323-367, Meat Meat's thought-blade knocks Autumn over the rail. She then chooses between the child and his hand, or (as a companion) takes the child, and he falls.
- Softened from murder to a refusal to save him. Ch10 builds on it consistently (036:811-818). It still reads as a killing the court can charge, so the change is mild and defensible.
- (Vasha becoming Phildendrin is the owner's decision.)

**17. CHANGED (minor): Q5, the escort route.**
- Source: 10374 ("using the Echo Gate as an entrance").
- The councillors are taken down through the Sap Gate to the Undercanopy (036:1461, 1464-1487). Mirror Wraiths, the collapse and the Luminara verdict are all kept. Harmless.

**18. CHANGED (minor): M2, where the twin is.**
- Source: 8323 and 8329 ("the mirror's twin in the Heartroot Vault").
- The twin is in the Overflow Channel (map 2067, 033_Chapter7B.rb:237-305), and it also holds Mira's daughter. The rest is faithful: Meat Meat is required, the Mirror Sentinel, holding the mirrors (failure releases a Mirror Wraith), and the crystal lattice. Fine.

**19. CHANGED (minor): R1, where the blight is.**
- Source: 8376 ("Thick sap drips from the roots beneath the Heartroot").
- Rheven comes down to the Undercanopy's Spore Gardens (032_Chapter7A.rb:179-235; 047a:110-144). It is Tab 5 H1's "Blight" merged with R1. Faithful otherwise: the Perception, Medicine, Nature and Persuasion steps, the spore blight on failure, and `:blight_scarred` read by GQ5's debate (036:1624-1627).

**20. MISSING (minor): the H31 "glimpse of your future" bargain has no payoff.**
- `:bloom_bargain` (046_DeepLabyrinth.rb:902) is never read. The emissary's prophecy ("a white room under the ice... hold something very cold") is never echoed in the White Vault or at Auril's throne.
- Fix: one line in `scene_vault_circuits` or at the Throne of Frost when `flag?(:bloom_bargain)`.

**21. COMPRESSED (minor): GQ2 Heart Chamber "destroy" mechanics.**
- Source: 8489 (50 radiant damage in one round, or a DC 17 spellcasting check).
- Destroying is now one choice, "Destroy it" with Dawnfang (034:739-744). Sanctify keeps its two checks: "warm it" and "persuade the echo".

**Small non-ranked notes (inside Full rows):**
- Q1: if the Heartroot's Test ends on three failures before the leaf, the golden leaf can still be plucked afterwards. It still sets `:leaf_presented`, which counts as evidence (036:649-666). Harmless.
- `quarters_glyph` shares one flag across nine glyph events per row (047d events on 2173). The alarm checks happen only twice. Intended or not, it reads fine.

## 3. Full table

Key: F = Full, C = Compressed, Ch = Changed, M = Missing, U = Unreachable. Paths are under game/Data/Scripts/998_FrostThaw unless they are maps.

### Tab 3: the Heartroot Labyrinth (H1-H37) and its monster index

| # | Element (source lines) | Verdict | Evidence |
|---|---|---|---|
| 1 | H1 Root-Spiral Approach, the "heartbeat" (7095-7101, 7441) | F | 025:131-147 `scene_heartroot_enter`; map 2057 |
| 2 | H2 Runic Seal Circle: four runes, tonight's aurora, Sap Wraith, vision at 0 HP (7104-7108, 7445) | F | 025:149-221; 2057 events 1-5 |
| 3 | H3 Warden's Overlook: tally marks, "She will take the heart if we don't" (7111-7117) | F | 025:60-63; 2057 event 11 |
| 4 | H4 Rootguard Post: infernal tools; 3-5 enthralled guards (7120-7126, 7453) | F | 025:64-66; 4 thralls, 2057 events 12-15 |
| 5 | H35 Captain's Alcove: glyph-maps, captain (7457-7459) | F | 046DL:158-172; Hesk; 2057 event 19 |
| 6 | H5 Threshold of Dripping Gold (7133-7139) | F | 025:224-232 |
| 7 | H6 Central Wells: heal, visions, backlash, map fragment (7142-7146) | C | 033:395-422 (one fragment; row 12) |
| 8 | H7 Overflow Channel: slide, bones, fragment in sap (7149-7161) | F | 028 (slick), `sap_bones`, `map_fragment`; map 2067 |
| 9 | H8 Whispering Attendant: questions for a promise to "burn the forge" or "free the heart" (7164-7172) | F | 033:425-458; paid off at 046FR:980-994 and 034:695, 747 |
| 10 | H9 Petaled Threshold: lagging reflections (7178-7184) | F | 046DL:238-245 |
| 11 | H10 Reflection Ring: worst selves, crossing without looking, Mirror Clones, Verdant Seed (7187-7189, 7489-7491, 7956-7972) | F | 046DL:248-310 |
| 12 | H11 Shattered Bed: cuts, lodged shard Avarice sees through, Mirror Shard Focus (7191-7203) | F | 046DL:313-361; payoff at 034:454-456 |
| 13 | H12 Perfume Grotto: Lirielle's niche, rest, fear boon (7206-7218) | F | 046DL:364-378; boon used at 034:591-594 |
| 14 | H13 Upper Root Bridge: sentries over the frozen lake (7225-7231, 7505-7507) | F | 046DL:383-392; Tamsk and Irrel on map 2141 |
| 15 | H14 Sap Burst Crossways: bursts, frost vines, foes (7234-7246) | F | 046DL:394-429; Vesk |
| 16 | H15 Cocoon Gallery: sovereign bargain, captive who warns, cocoon boon (7249-7261, 7513-7519) | F | 046DL:432-507 |
| 17 | H16 Frozen Drop: climb, time-lapse, flying predator (7264-7274, 7522-7524) | F | 046DL:509-537 |
| 18 | H17 Underdark Mouth: deep air, duergar, spoor (7277-7285) | F | 046DL:113-120; Gelt; claw-marks on map 2142 |
| 19 | H34 Lizard Nursery (7530-7532) | F | 046DL:540-560 (calm them or fight) |
| 20 | H27 Root-Kin Barracks: asleep or alerted (7534-7536) | F | 046DL:563-600 (strike, wake, or sneak with Wyn) |
| 21 | H18 Amber Threshold: chanting pods, time glitches, sentries (7294-7300, 7542-7544) | F | 046DL:605-629 |
| 22 | H19 Stasis Gallery: Homunculus Core, lab notes, Temporal Surge (7303-7307, 7546-7548, 8021-8061) | F | 046DL:631-706 |
| 23 | H20 Dissectory Annex: cataloguer, notes on binding Auril, the Shard "gone too right", hammerer (7310-7322) | F | 046DL:709-759 |
| 24 | H21 Mirror Scriptory: plans, infernal allies, Mirror-Ink Wraith (7325-7337, 7978-8017) | F | 046DL:800-872 |
| 25 | H28 Suffering Pods: torturer construct, two prisoners (7558-7560) | F | 046DL:762-787 |
| 26 | H29 Guest Seed Nests: visitors' evidence, duergar spy (7562-7564) | F | 046DL:875-883; Ossk |
| 27 | H30 Root-Lift Node (7566-7568) | F | 046DL:926-950 |
| 28 | H31 Devil's Bloom: social test, devil (7570-7572) | F | 046DL:886-923 (blood-bargain payoff missing; row 20) |
| 29 | H22 Auroral Antechapel: ghost-images of the Shard, stakes, guardians (7344-7356, 7578-7580) | F | 046FR:818-883 |
| 30 | H32 Thorn-Run Hall (7582-7584) | F | 046FR:886-890 |
| 31 | H23 Heart Chamber: boss, lair effects, purify, preserve or destroy (7359-7361, 7586-7588, 8065-8116) | Ch | 034:431-787 (Avarice, then the Shard; row 11) |
| 32 | H24 Breaking Circle: flip runes, epilogue effects (7363-7373, 7590-7592) | F | 034:510-602; 12 spires on map 2076 |
| 33 | H33 Hammer-Heart Workshop (7594-7596) | F | 046FR:893-902 |
| 34 | H25 Sloughing Veins: escape chase (7376-7382, 7598-7600) | F | 046FR:936-971; map 2154 |
| 35 | H26 Echo Vault: seeds, chardalyn, World Tree prophecy, third sigil (7385-7399) | Ch | 046FR:973-1078 (no sigil here; row 10) |
| 36 | H36 Aurora Treasury (7606-7608) | F | 046FR:1081-1091 |
| 37 | H37 Silent Chapel of the Patron (7610-7616) | F | 046FR:905-930 |
| 38 | Mirror-Root Vault (GQ2 3, Tab 1 H3): mask, wards with sentinels, Var's echo (8487) | F | 046DL:955-1077 |

### Tab 4: the revised Sephek encounters

| # | Element | Verdict | Evidence |
|---|---|---|---|
| 39 | Sephek 2.0, Minor Avatar: druids and mephits, his edge while they stand, half-HP ceiling (8140-8198) | F (Ch location) | 047c:140-206; called at 037:139 (row 8) |
| 40 | 2.0 lair actions, Frost Nova, Frost Step (8154-8193) | C | flavour only (row 8) |
| 41 | Sephek 2.5, Major Avatar: Auril pours in, wolves, coldlight walker (8200-8254) | F (Ch location) | 047c:242-270; 039:373 |
| 42 | Divine Rejuvenation and the Heartroot relics (8216) | F | 047c:75-78, 211-237; maps 2057/2058/2067, switch 4138 |
| 43 | 2.5 aura, Frost Chains, Auroral Storm, lair actions (8214-8250) | C | flavour line at 047c:254 (row 8) |

### Tab 4: the character quests

| # | Element | Verdict | Evidence |
|---|---|---|---|
| 44 | A1 Echoes at the Auroral Wall: gate whispers save, maze 3-before-2 with wraiths, the pane, flees until dawn (8262-8276) | F | 047b:157-284; map 2161; entered via 2050 event 59 (switch 4128) or 026:1298 |
| 45 | A2 The Still Beast: Rheven at the Spire Armory, tracking, capture alive or it shatters (8279-8295) | F | 048D:139-235; map 2183 event 9, 2060 event 23 |
| 46 | M1 The Verdant Heist: Darrus's offer, 4-before-2 wards, psychic theft, three deliveries (8300-8314) | F | 048D:789-941; map 2198. Exposure leaks: bugs 1-3 |
| 47 | M2 The Whispering Mirror: the child, Mira, the twin, the sentinel, holding, the lattice (8317-8331) | F (Ch location) | 048C:664-720; 033:237-305 (row 18) |
| 48 | B1 Canticle of Seasons: Eirwen, Library research, three verses, spectral bards, chronal prophecy leaf (8336-8350) | F | 026:1019-1131; 048D:569-583 |
| 49 | B2 The Stolen Leaf: Glasswater, the Wall, the frozen Rootwarden, time wight, shattered leaf mended (8353-8367) | F | 047b:502-552, 590-624 |
| 50 | R1 Verdant Sickness: Rheven's question, sensing the blight, three-check ritual, spore blight, partial failure (8372-8386) | F (Ch location) | 048D:139-178; 032:179-235; 047a:110-144 (row 19) |
| 51 | R2 Pulse of the Blooming Fields: the twin spirits, 3-before-2, resistance boon (8389-8403) | F | 048D:699-762; map 2060 event 24 |
| 52 | W1 Shadows in the Undercity: dockworker, spore trail, commune, memory or HP, bargain or burn (8408-8422) | F | 047b:347-428; maps 2198 and 2160 |
| 53 | W2 The Mirror Lake Ghost: new moon, approach, regret, rest or bind (8425-8439) | F | 047b:433-497; map 2078 event 10 |

### Tab 4: the group quests

| # | Element | Verdict | Evidence |
|---|---|---|---|
| 54 | GQ1 Closing the Frostfell Rifts: three rifts, angels, surges, Lumen Shard, six rounds (8450-8468) | F | 047a:655-702; map 2061 (switch 4120, Ch7 while Glimmer lives) |
| 55 | GQ2.1 Root-Gate puzzle and Sap Wraith (8483) | F | row 2 |
| 56 | GQ2.2 Sap-Wells: three fragments (8485) | C | row 12 |
| 57 | GQ2.3 Mirror-Root Vault: 3 successes, a sentinel per failure (8487) | F | 046DL:967-1007 |
| 58 | GQ2.4 Heart Chamber: destroy or sanctify, Verdant Fire, Frost Saint Echo (8489) | F (destroy compressed) | 034:701-744 (row 21) |
| 59 | GQ2 reward: destroying stops Sephek's return (8492) | Ch | 047c:180-185 (row 9) |
| 60 | GQ3 Cycle Day Conspiracy: rumours, 5-before-3, cultist fights, Icy Avatar, casualties (8494-8513) | F | 048H:81-225; called from the festival toast 048F:666-681 |
| 61 | GQ4 Beyond the Auroral Wall: crossing, frozen-time 3-before-2, Dougan's Hole, Temporal Guardian, Still Sky blessing (8515-8536) | F | 047b:531-667; maps 2163/2164 |
| 62 | GQ4.4 return before the Wall closes; trapped means losing half and a rescue (8533-8536) | C | 047b:670-697 (row 15) |
| 63 | GQ5 Trial of the Four Seasons: martial-law bid, 4-before-2 debate, four seasonal tests, three outcomes (8538-8568) | F | 036:1604-1735 (Gym 8); map 2166; consequences at 047d:740-743 |

### Tab 5: Hyphora's Undercanopy

| # | Element | Verdict | Evidence |
|---|---|---|---|
| 64 | Lore: Hyphora as Erato's seed, Balanus, year 120, "thread that binds", the name kept secret (8597-8605) | F | 026 `lysella`; 032:302-326 |
| 65 | Tensions: tainted lake, cultists at the Echo Gate, Sephek's voice in the roots (8615-8621) | F | 032 lake ("The lake remembers"); masked trader |
| 66 | Sovereign Luminara: voice of Hyphora, wants the lake cleansed first (8633-8719) | F | Gym 7 (`leader_luminara`); 036:1488-1531 |
| 67 | Spore Tender Yarro: healer, lullabies, respect (8721-8793) | F | 026 `yarro`; 047a:149-177; 036:1589-1599 |
| 68 | Spore Scribe Lysella: words for lore, the archives (8795-8861) | F | 026 `lysella`; 047a:277-299, 362-374 |
| 69 | Shroomsmith Korun: blunt, craft, scorn (8863-8933) | F | 026 `korun`; 047d:55-90 |
| 70 | Mushroom Merchant Faria: gossip, haggling (8935-8985) | F | 026 `faria`; 047a:218-269 |
| 71 | Sentry Zym: acid scars, distrusts newcomers (8987-9053) | F | 026:420-427 `zym` |
| 72 | Mnemosyne Myr: memory swap, dreamwalk, guards the name (9055-9137) | F | 032 (naming); 047a:424-576 |
| 73 | H1 Spore Gardens: the Blight (9179-9185) | F | 032:179-235 |
| 74 | H1 Cradles of Sprouts: harmed sprouts summon Yarro (9157-9175) | M | none (row 13) |
| 75 | H1 Secret Nursery (9187-9191) | F | 047a:149-162 |
| 76 | H1 Yarro's lake errand and ambush; root tremor (9195-9205) | F | 047a:164-195 |
| 77 | H2 Fungal Bazaar: barter, spore games, outsider spy (9207-9233) | F | 047a:200-216; 026 `masked_trader` |
| 78 | H2 Theft and kobolds; market duel and the archive law (9237-9247) | F | 047a:218-302; map 2172 |
| 79 | H3 Council Fane: sap pool and the d6 Vision Table, thrones, memory niche (9269-9323) | F | 047a:307-374 |
| 80 | H3 Rootwarden delegation; cultist poisoning the pool (9327-9337) | F | 047a:377-419; sap raid at 047d |
| 81 | H4 Tainted Lake: monster, Balanus seed, Yarro's purification, Hyphora's blessing (9339-9407) | F | 032:355-428 |
| 82 | H4 acid slicks and stalactites (9379-9383, 9395-9399) | C | flavour only (row 13) |
| 83 | H5 Mnemosyne's Chamber: circle, archive, tether threads and shadow demons (9409-9435) | F | 047a:424-457 |
| 84 | H5 Memory Heist; Dream Rescue (9437-9473) | F | 047a:459-576; map 2171 |
| 85 | Magic items: lantern, salve, sporechime, cloak, lash, sap-stones, circlet, spear, armlet, Seed of Renewal (9475-9623) | F | 047a:51-74; 047d; 027 |
| 86 | Quest hooks: Cleanse the Lake (Hyphora's Seed), Memory Trade, Rootwarden Diplomacy, Echo Gate Shadows (9655-9673) | F | 047d:133-145; 047a:477-502, 377-400; 026 spy |
| 87 | Long-term impact: the lake strengthens the tree (9675-9683) | F | flags read in 026, 047d |
| 88 | Eira Shadebloom: greeting, telepathic link, escort (9693-9729) | F | 032:142-161 |
| 89 | Eira hostile branch: summons wraiths and stalkers (9729, 9767) | C | absent (row 13) |
| 90 | Eira development: stalker lore, missing patrols, spore-guard trial (9813-9817) | F | 047a:581-613; 047d:728 report |
| 91 | Eira development: Halo cultists at the Still Sky Shrine (9817) | C | absent (row 13) |
| 92 | Market goods list (9821-9848) | C | mostly flavour (low priority) |
| 93 | Shadow Mycolith hoard: art, coins, potions, reagents (9852-9893) | F | 047a:637-650 |

### The Shadow Mycolith (and Tab 6)

| # | Element | Verdict | Evidence |
|---|---|---|---|
| 94 | Puzzle of the Five Domains before the fight (10001) | F | 032:433-472 |
| 95 | Phase 1, with the quipper swarm and spore-lash creeper (9929-10014) | F | 032:474-488; 047a:618-635 |
| 96 | Enraged phase, not healed to full (10017-10021, 10221-10236) | F | 032:489-497 (215/350 HP) |
| 97 | Wyn receives the God-Spark of Shadow (10247) | F | 032:500-515 `:godspark_shadow` |

### Tab 8: Chapter X, Trials of the Roots

| # | Element | Verdict | Evidence |
|---|---|---|---|
| 98 | Aftermath: Wall thins, summer ends, frost, falling leaves, cloaks, mirrored charms, walls, refugees (10253-10257) | F | 036:178-208 gossip on map 2050 (switch 3988); 047b `fallen_leaves` |
| 99 | Social attitudes: liberators or murderers, hush at the Hearth, gossip, children's wraith stories, Candlekeep scholars (10261-10265) | F | 036:179-207; maps 2050/2053/2054 |
| 100 | The Verdant Tribunal: four seats, witnesses and evidence, punishments (10263) | F (bug 1) | 036:282-313 |
| 101 | Appeal to Hyphora in the Heartroot (10263) | F | 036:1747-1765; map 2057 event "Appeal" (switch 4150) |
| 102 | Election and rebuilding setup: two vacancies, candidates, walls (10267) | F (bugs 2, 5) | 036:151-176, 317-333 |
| 103 | Q1.1 Reconciliation: Anduin at the fountain, honesty checks (10279-10287) | F | 036:553-601; map 2050 |
| 104 | Q1.2 Heartroot's Test: 6-before-3, Anduin's hand, vision, outcomes, treant (10288-10290) | F (no wheel, row 14) | 036:603-711; map 2165 |
| 105 | Q1 evidence: cedar charm, Leaf of Hyphora, Eirwen's word of restraint (10292-10296) | F | 047b:93-115; 036:649-666, 769-798 |
| 106 | Q2 arrest, root-cell, escape options (10302-10310) | F | 036:803-854; map 2054 |
| 107 | Q2 mother's return (Phildendrin) and the apology (10311) | F (owner's decision) | 036:855-881 |
| 108 | Q2 Trial of Redemption: the cursed mirror (10312) | F (Ch location) | 036:886-928; map 2058 (switch 3989) |
| 109 | Q2 background: Meat Meat "assassinated" Autumn (10300) | Ch | 034:323-367 (row 16) |
| 110 | Q2 evidence: Rheven's testimony, Autumn's labs, Mira's mirror testimony, two refugees (10316-10321) | F (Mira gated, row 4) | 036:931-951; 046DL:741-752; 036:1319-1408 |
| 111 | Q3 citation at the Echo Gate (Sorrel) (10327) | F | 036:981-994; map 2050 |
| 112 | Q3 hearing: Hyphora or dream, DC-style checks (10331) | F | 036:996-1041 |
| 113 | Q3 Underdark Door crawl with escorts, quippers, creepers, stalkers (10332) | F | 036:1056-1086; map 2077 |
| 114 | Q3 revelation: ritual circle (10333) and the runes evidence (10339) | F | 036:1088-1107 |
| 115 | Q3 junior warden's account (Ivo, for the notes' "Darrus") (10340) | F (integration) | 036:1112-1131; map 2055 (switch 4153) |
| 116 | Q3 Mirror Wraith witness, vial or rapport (10341) | F | 047b:287-309 |
| 117 | Q3 alibi from Hyphora, the Fungal Liaison boost, reprimand or barred (10342, 10335) | F | 036:1134-1160 |
| 118 | Q4 Talion in the Fields: investigation, embrace, specter (10346-10353) | F | 036:1169-1266; map 2060 (switch 4131) |
| 119 | Q4 resolution: ritual at the Mirror-Lake, or acceptance (10354-10356) | F (Mira gated, row 4) | 036:1270-1316; map 2078 (switch 3990) |
| 120 | Q4 evidence: memento, lake inquiry, Mira's advice, the wraith's riddle (10358-10363) | F | 036:1210-1214; 047b:446-454, 310-315 |
| 121 | Q5 debate with Winter and Spring; "why do you fear the spores" (10369-10373, 10382) | F | 036:1414-1462 |
| 122 | Q5 journey down, Mirror Wraiths, Luminara's verdict, Fungal Liaison or exodus (10374-10377) | F (Ch route, row 17) | 036:1464-1532; map 2068 |
| 123 | Q5 evidence: blessed leaf, tincture, history leaf, allies (10379-10384) | F | 036:1577-1599; 047b:140-150 |
| 124 | Q6 opening: criers and the carpenter (10390-10394) | F | 036:317-333; map 2050 (switch 4151) |
| 125 | Q6 evidence: Slaudi, memory bubble, wraith echo, Ledger (tower break-in), Rheven's horns (10398-10405) | F | 047b:120-135; 036:1535-1574; 047b:320-330; 047d:569-680 (map 2173); 036:954-963 |
| 126 | Q6 public outreach and walls, neglect raising the difficulty, wolves (10406, 10410) | F | 036:336-421; map 2060 |
| 127 | Q6 electioneering, mud-slinging, petitions and nominations, platforms, the Heralds standing or neutral (10407-10424) | F | 036:426-548; 047d:309-372 |
| 128 | Trial, Verdict and Vote, with their outcomes (10427-10431) | F (bug 1; no god points, row 14) | 036:1785-1922 |
