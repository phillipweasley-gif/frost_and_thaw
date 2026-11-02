# Re-audit D: rootspire.md lines 7089-10436 (Tabs 3, 4, 5, Mycolith, 6, 8)

Auditor read every source line in the slice (7089-10436, in ~300-line chunks) and the implementing code:
025_Chapter7, 028_Heartroot, 032_Chapter7A, 033_Chapter7B, 034_Chapter8 (Heart choice), 036_Chapter10 (all),
046_DeepLabyrinth (all), 046_ForgeRooms (Zone VI), 047a_Undercanopy (all), 047b_TrialWeek (all), 047c_WhiteVault
(Sephek/relics), 048_Rootspire_C/D/F (relevant parts), 026_Rootspire (Canticle, Echo Gate, Undercanopy NPCs), and the
builders build_w4, build_ch6/6b/7/7_deep/7b/8_deep/10. `ruby tools/check_all.rb` passes (155 maps) and
`ruby tools/reach.rb` on every slice map (2077/2078/2140-2145/2153-2155/2160/2161/2163/2164/2198) reports everything
reachable. Nothing under /home/claude/frost-thaw was modified.

## 1. Summary

93 story-bearing rows checked.

| Verdict | Count |
|---|---|
| Full | 77 (4 of them, rows 78/81/83/91, carry bugs) |
| Compressed | 7 |
| Changed | 7 |
| Missing | 1 (election: "run yourselves" / "stay neutral") |
| Unreachable | 1 (Q1 evidence: the Leaf of Hyphora never counts) |
| Bugs found (in addition) | 17 (2 soft-locks, 1 duplicate quest, several contradictions) |

Section 2 has 29 entries, more than the 16 non-Full rows: it also lists the bugs inside Full rows and some minor
compressions folded into Full rows of the table.

Honest judgement: this slice is mostly in the game, and done well. All 37 Heartroot areas (H1-H37), both Sephek stages, the
Undercanopy, the Mycolith, the Frostfell Rifts, the Wall, the Glasswater, the Mirror Maze, and nearly the whole Tab 8 trial
week are reachable, with the notes' skill challenges turned into choice prompts and fights. Six areas are weak:
(a) **A1 is implemented twice**, and the two versions contradict each other. The Mirror Maze version can also soft-lock
permanently. (b) The **Ch10 evidence ledger has wiring bugs**: one piece can never count; two pieces count when they
shouldn't; Mira's favour finishes at Kelyn. (c) **Anduin's nomination can soft-lock** if the player does things in the
"wrong" order. (d) In the **Maera Vell branch** (Darrus exposed), the trial still justifies Autumn's death with Darrus's
crimes and calls the dead Warden "a man". (e) **GQ3 Cycle Day** is cut down to a single trainer battle, and **M2** and
**B1** are reshaped. (f) The **election lacks the "run yourselves / stay neutral"** options, and several failure
consequences (martial law, the geas, Rootwarden anger, the sap raid, the scarred blight) are set as flags that nothing
ever reads.

Integration choices judged:
- *Darrus exposed -> Corsairs, Maera takes Autumn's place*: fine in itself, but Ch10 was not updated for it (row 78/91,
  bug B8). As shipped, that branch betrays Q2's logic: the evidence that justifies the killing is about the wrong person.
- *Pell stands in for the notes' junior warden*: fair. The notes' "Darrus Fell, a junior Rootwarden" clashes with Darrus
  the Autumn Warden. One note: Pell is at the Root-Tier tunnel mouth (Q3), not in the Mirror Maze as the brief says.
  Also, "Pell" is already the name of two other NPCs (bug B13). The code comment at 036_Chapter10.rb:1034-1036 says
  Darrus is "dead at the Forge", which is false in the exposed branch (cosmetic).
- *Wyn's colony = the Undercity, deep end of the Smuggler's Run*: faithful. W1's read-aloud literally sets it "beneath
  the Root-Tier docks, the Smuggler's Run".
- *Razzy's scale core*: mostly outside this slice; nothing here contradicts it.

## 2. Every row that is NOT Full, ranked by importance

**1. A1 "Echoes at the Auroral Wall" exists twice, and the copies contradict each other. Changed + bug.** Source 8262-8277.
- 048_Rootspire_D_Quests.rb:754-800 `echoes_at_the_wall` (flag `:alerion_reflection`) runs in Ch6, straight after the
  Echo Gate wraiths (026_Rootspire.rb:1183, if Alerion is along).
- 047b_TrialWeek.rb:157-243 runs the Mirror Maze (2161) from Ch7 on (flag `:reflection_claimed`).
- Neither checks the other's flag. So after the Ch6 version, the Maze still opens with Alerion saying "That one's mine. I
  left it here" (047b:185), and he reabsorbs his soul fragment a second time and gets a second reward.
- Fix: keep one. Either treat `flag?(:alerion_reflection)` as done in `scene_mirror_maze`/`maze_reflection` (give the Maze
  pane "Just ice now" and skip the line), or delete `echoes_at_the_wall` and its call at 026:1183.

**2. The Mirror Maze soft-locks A1. Bug.** Source 8274-8276.
- In `maze_junction` (047b:190-208), each of the 3 junctions is pushed to `st[:done]` even when the wraith skirmish is
  lost. `maze_reflection` needs `st[:ok] >= 3`.
- One lost Mirror Wraith fight therefore makes the reflection unreachable forever. The only reset (047b:237) sits behind
  the `ok >= 3` gate, and nothing else resets `state[:maze]`.
- The notes' "two failures" end-and-retry rule is not implemented either.
- Fix: on a failure, don't mark the junction done. Or, when `st[:bad] >= 2`, reset `state[:maze] = {ok:0,bad:0,done:[]}`
  with a "the maze folds up; try again" line.

**3. Anduin's nomination can soft-lock. Bug.** Source 10411, 10422-10423.
- `petition_signer` (036:488-518) only checks for nomination while a signer is signing. For Anduin it also needs
  `:rootwardens_accept_anduin`, which `rheven_wall` (036:894-902) sets without re-checking.
- Each signer signs once (`signed[[who,k]]`). If the player collects the 15+ signatures before winning Rheven over,
  Anduin can never be nominated.
- Fix: pull out a `check_nomination(k)` helper and call it from `petition_signer`, from `rheven_wall` after it sets the
  flag, and from `anduin_after`.

**4. Maera Vell branch: Ch10 still treats Autumn as Darrus. Bug; the integration choice is broken.** Source 10300-10321.
- With `:heist_exposed`, 034_Chapter8.rb:267-275 makes the fallen Autumn Warden Maera Vell. Ch10 still hardcodes Darrus
  or "he", in these places:
  - 036:117 ("I saw his lists")
  - 036:183 and 036:820 ("where Darrus kept his secrets" / "Darrus watched the whole city")
  - 036:796 ("Autumn was a tyrant. He had children in pens")
  - 036:843 ("People Darrus watched. People he kept")
  - 036:877-878 ("He meant to turn them into sacrifices")
  - 036:1705 ("was the death of a man feeding children to a fire")
  - 036:139: the reliquary exposing Darrus counts as :autumn evidence for Maera's death.
- So the court excuses Maera's death with Darrus's crimes.
- Fix: route every Autumn line through `autumn_hand`. In the exposed branch, write Maera-specific evidence (her
  coronation robes for the Heralds, her weasel spies, carrying the robes below) and reword the Darrus items as "the
  office of Autumn".

**5. Q1 evidence: the Leaf of Hyphora. Unreachable.** Source 10295.
- WITNESSES keys it on `:leaf_presented` (036:113), and nothing ever sets that flag. `attunement_leaf` (036:619-634)
  gives FT_HYPHORALEAF but never presents it.
- Fix: `set_flag(:leaf_presented)` when the leaf is plucked successfully, or offer "present the leaf" at
  `kelyn_trials`/`anduin_after`.

**6. Q6 Myconid memory bubble: counted whether or not you got it. Bug, Changed.** Source 10401.
- The witness keys on `:colony_recognised` (036:132), but the bubble sets `:memory_bubble` (036:1451) and only on a
  passed challenge. Refusing or failing still counts it, and adds about +2 to the Summer verdict.
- The bubble is also only offered inside a successful Q5. The notes make it a separate trip to Luminara.
- Fix: key the entry on `:memory_bubble`. Optionally let `leader_luminara` offer it during the week after Q5.

**7. Q3: the "Hyphora: Shadow answered my call" witness shows up on failure. Bug.** Source 10342.
- `wyn_alibi`'s failure branch (036:1077-1081, "the crystals stay dark") also sets `:wyn_cleared`, and WITNESSES (036:125)
  lists Hyphora's words for `:wyn_cleared`.
- Fix: set a separate `:hyphora_alibi` only in the success branch and key the witness on it.

**8. Mira's favour finishes at Kelyn. Bug.** Source 10320, 10417.
- `mira_mirror_return` (036:1299-1305, "MIRA: (taking it...)") is only called from `kelyn_trials` (036:1651). The player
  hands Mira's mirror back by talking to Kelyn in the Council Hall, and Mira's lines play there. `mira_trials`
  (036:1243-1286) has no return option.
- Fix: add a "return the cursed mirror" option to `mira_trials` and remove the call from `kelyn_trials`.

**9. GQ3 "The Cycle Day Conspiracy". Compressed (heavily).** Source 8494-8513.
- The game has only `festival_effigy` (048_Rootspire_F_Downtime.rb:644-654): one Halo trainer at an effigy. `effigy_saved`
  is set even if you lose.
- Lost: the rumour investigation (lantern runes); the 5-before-3 festival skill challenge (shadow cultists, find lanterns,
  disarm runes, blend in, spot); cultist confrontations on each failure; Auril's Icy Avatar at the Still Sky shrine
  if half the lanterns are carved; protecting civilians and the casualties consequence.
- Fix: build it as a festival-night skill chain (5 checks, 3 strikes) with an Icy Avatar boss at 2056 on failure, and a
  casualty flag the Hearth and Hall lines read.

**10. Q6 Ledger of Corruption. Changed / Compressed.** Source 10403.
- It is now a free floorboard pickup in the Forge in Ch8 (046_ForgeRooms.rb:214-227).
- The trial-week infiltration of Avarice's quarters atop the Council tower is gone: the lock, the alarms, the
  bone-and-ice constructs. If the floorboard is missed in Ch8, the ledger is probably lost for the trial.
- Fix: also place the tower-quarters infiltration during the trial week (Council Hall upstairs), giving the ledger if
  not already found.

**11. Election: the party cannot run themselves, or stay neutral. Missing.** Source 10267, 10407, 10429-10431.
- `scene_vote` (036:1726-1764) forces two endorsements and has no "run yourselves" path, and the "winning a council seat
  grants political power" outcome is gone.
- Fix: add a "Stand ourselves" petition and candidate (a Herald's name), plus an "abstain" choice at the vote.

**12. M2 "The Whispering Mirror". Changed (neither an owner decision nor an integration choice).** Source 8317-8331.
- Kept: the first half is faithful (048_Rootspire_C_Folk.rb:660-680: the boy, the smirking reflection, Mira's "just a
  scrying shard", Avarice's voice).
- Changed in the second half (033_Chapter7B.rb:229-260): the twin is in the Overflow Channel, not the Heartroot Vault;
  Alberica leads the scene; and a Mirror Echo replaces the Mirror Sentinel.
- Lost: reuniting the two mirrors and holding them (the Athletics check); imprisoning the fragment in a crystal lattice.
  The mirror is simply smashed, and it is no longer Meat Meat's quest.
- Fix: let Meat Meat carry the boy's mirror to the twin (require her), add the "hold the mirrors steady" choice with
  failure releasing a Mirror Wraith, and end with the fragment trapped (an item), not just smashed.

**13. B1 "Canticle of Seasons". Changed / Compressed, with a contradiction.** Source 8336-8350.
- 026_Rootspire.rb:982-1019 is a four-verse ordering puzzle (winter, spring, summer, autumn) at the Hall's pillar,
  after the Library sub-vault.
- Gone: Eirwen does not invite or attend; no Library research check; no spectral bards fight on failure (only voices);
  no prophecy chronal leaf. The reward is the Whisper Key plus Eirwen's sigil.
- 039_Chapter13.rb:249 and 039:441 say the Canticle has "three verses. Hope, loss, endurance", which matches the notes
  but contradicts 026's four verses.
- Fix: align the verse counts (or say "four verses, three hard ones"). Add Eirwen's invitation and a swarm fight on a
  failed singing.

**14. GQ2 "Purifying the Heartroot". Changed.** Source 8471-8492.
- The Blessing of Verdant Fire comes from *destroying* the Shard (034_Chapter8.rb:664-669). The notes give it for
  *sanctifying*.
- "Destroying ensures Sephek cannot return from this shard" is reversed: he returns in Ch11 whatever you chose
  (037_Chapter11.rb:120-133).
- The Mirror-Root Vault is one choice (046_DeepLabyrinth.rb:964-981), not 3 successes with a sentinel per failure. The
  wells give one map fragment (033:315-343), not three.
- Fix: either swap the blessing to Purify, or document the change. Have `shard_destroyed` alter Sephek's return (for
  example, his Minor Avatar starts weakened, or he comes back by a different vessel), so the choice matters as the notes
  intend.

**15. Q6 / Tab 8 consequences that are never enforced. Compressed.** Source 10263, 10406, 10427, 10431, 8565-8568,
8386, 8422.
- Each of these flags is set and then never read:
  - `verdict_geas` ("may not leave Rootspire")
  - `wyn_barred` (Rootwarden stores closed)
  - `canopy_martial_law` / `canopy_watched` (surveillance)
  - `blight_scarred` (R1: "disadvantage on one Council skill challenge")
  - `rootwardens_angered` (W1 burn)
  - `sap_grudge` (the threatened sap raid)
  - `pool_poisoned`
  - `chapel_auril` / `chapel_avarice`
  - `pods_quiet`
- Eira asks you to find her lost patrols; `missing_patrol_found` (047b:566) is never reported back to her.
- Fix: read each flag in at least one later line or effect, e.g. a geas guard at the Echo Gate until the appeal,
  martial-law wardens on the Canopy, a raid night scene for `sap_grudge`, Eira's thanks for the patrols, +1 trial DC
  for `blight_scarred`.

**16. Q4 witness counts testimony that never happened. Bug.** Source 10354.
- WITNESSES (036:131) counts `:talion_haunted` as "Talion, through the lake" testifying. In the haunted outcome
  (036:1232-1236) he gives no testimony.
- Fix: drop `:talion_haunted` from that entry.

**17. W1: the spore-inhalation penalty does nothing. Bug.** Source 8418.
- `ok = false if flag?(:undercity_spored) && !ok` (047b:340) is a no-op. `spore_trail` also has identical branches
  (047b:319-320).
- Fix: when spored, remove the right answer from the commune options, or require a second success.

**18. Wyn's post is two different places. Contradiction.** Source 10325.
- 032_Chapter7A.rb:121-126 has Wyn's post as the Sap Gate ("I sat here every night for three years... the one night it
  mattered, I wasn't here"). 036_Chapter10.rb:1015 has Wyn at the Underdark Door (2077) saying "This is where I stood.
  Every night. Until the one night."
- Fix: reword 036:1015 to "This is the door my post was set to guard" (and the Sap Gate is the way to it), or the reverse.

**19. Three different NPCs are called Pell. Bug (confusing).**
- 033_Chapter7B.rb:43 (a Guild worker, "forty years down here"); 026_Rootspire.rb:146 (a College scholar); 036:1037 (the
  junior Rootwarden, "barely shaving"). Fix: rename the Q3 warden.

**20. Ch X Q2 redemption mission. Changed (minor).** Source 10312.
- The source's "retrieve a cursed frost-glass mirror from the Heartroot Vault and cleanse it" became "break Autumn's
  spying mirror in the Sap Wells" (036:839-861). Mira's cursed mirror (036:1289) carries the other half. Acceptable.
- Minor bug: `phildendrin_after` (036:832) won't offer the petition once `:mm_atoned` is set. If the player declined at
  the cell and atoned first, Phildendrin can't stand. Fix: drop `&& !flag?(:mm_atoned)`.

**21. R1 "Verdant Sickness". Compressed (minor).** Source 8372-8386.
- The ritual is faithful (047a:110-144). The partial-failure consequence (`:blight_scarred`) is never read; see row 15.

**22. W1 "Shadows in the Undercity". Compressed (minor).**
- Faithful otherwise. It carries the no-op penalty (row 17), and "burning angers the Rootwardens" is never read.

**23. Q5 "Spores of Contention". Compressed (minor).** Source 10375-10377.
- "Combat may erupt if the party refuses" became a standoff line (036:1430-1433). The journey uses the Sap Gate, not the
  Echo Gate.

**24. Tab 5 H4 the Tainted Lake. Changed (minor).** Source 9401-9407.
- After the monster, Reptin or Wyn calls rain from the roots (032:370-394) instead of Yarro's purification ritual with
  Medicine checks and pseudopods. The reward (Hyphora's blessing) is kept.

**25. Tab 5 magic items and the market list. Compressed.** Source 9483-9623, 9823-9846, 9659-9661.
- Present: Luminescent Lantern (FT_SPORELANTERN), Sap-Skin Salve, Sporechime, Rootwrap Cloak, Spore-Spear, Hyphora's
  Circlet, Seed of Renewal, Elixir of Clear Mind, the hoard art.
- Missing: Hyphal Lash, Sap-Stones, Rootbond Armlet, Hyphora's Crown, Wand of Spores, and **Hyphora's Seed**, the named
  reward of the "Cleanse the Lake" hook (the lake gives the Balanus fossil seed instead).
- Fix: give FT_HYPHORASEED from Luminara after `lake_cleansed`; add the lash, stones and armlet to Faria's or Korun's
  stock.

**26. Korun. Compressed.**
- Only a one-line NPC (026:414-416; build_ch6b.rb:202). He has no smithing or mending service, no sporeling toys, and
  no respect-for-crafters reaction.

**27. Q1 "Roots of Love" evidence ordering. Compressed (minor).** Source 10292-10296.
- The reconciliation is scored at the first meeting (036:542-566). Eirwen's testimony and the leaf, gathered later,
  only appear in the witness list. They never sway Anduin, which the notes intend ("to reassure Anduin").

**28. GQ4 "Beyond the Wall": the trapped penalty. Compressed (minor).** Source 8536.
- Failing the return sprint gives one wight skirmish and you go home anyway (047b:620-628). The "lose half god points,
  need rescue" outcome is gone.

**29. Shadow Mycolith enraged phase. Changed (minor).** Source 10223.
- Tab 6 says explicitly "It does not heal to full". The game's second battle is a fresh, full-HP "Mycolith, Enraged"
  (032:463). Fix: set its HP to (current + 50) as in the note.

## 3. Full table

Status key: F = Full, C = Compressed, Ch = Changed, M = Missing, U = Unreachable.
"Where" gives file:line, or the builder that places the event.

### Tab 3: the Heartroot Labyrinth (7089-8128)

| # | Element (source lines) | Status | Where / note |
|---|---|---|---|
| 1 | H1 Root-Spiral; heartbeat hook (7095-7101) | F | 025_Chapter7.rb:59, 118-130 |
| 2 | H2 Runic Seal Circle, Sap Wraith, death vision (7104-7108, 7876-7916) | F | 025:155-215 |
| 3 | H3 Warden's Overlook, "She will take the heart" (7111-7117) | F | 025:60-63; build_ch7 |
| 4 | H4 Rootguard Post, enthralled wardens (7120-7126) | F | 025:64-66; 028:7, 43-46 |
| 5 | H35 Captain's Alcove: Hesk, glyph-maps (7457-7459) | F | 046_DeepLabyrinth.rb:158-172 |
| 6 | H5 Threshold of Dripping Gold (7133-7139) | F | 025:227-229 |
| 7 | H6 Central Wells: visions, backlash, map (7142-7146) | C | 033:315-343 (one fragment, not three) |
| 8 | H7 Overflow Channel: slide, bones, map fragment (7149-7161) | F | 028:131-160; 025:235-242 |
| 9 | H8 Whispering Attendant: answers for a promise (7164-7172, 7920-7952) | F | 033:345-376; kept/broken at 046_ForgeRooms:971-985, 034:673 |
| 10 | H9 Petaled Threshold, lagging reflections (7178-7184) | F | 046:238-245 |
| 11 | H10 Reflection Ring: worst selves, clones, Verdant Seed (7187-7189, 7956-7974) | F | 046:143-151, 248-310 |
| 12 | H11 Shattered Bed: shard Avarice scries through, Shard Focus (7191-7203) | F | 046:313-361 |
| 13 | H12 Perfume Grotto, Lirielle (7206-7218) | F | 046:364-378 |
| 14 | H13 Upper Root Bridge sentries (7225-7231, 7505-7507) | F | Tamsk/Irrel, build_ch7_deep |
| 15 | H14 Sap Burst Crossways (7234-7246) | F | 046:394-429; Vesk |
| 16 | H15 Cocoon Gallery: sovereign, captive's warning, boon (7249-7261) | F | 046:432-507 |
| 17 | H16 Frozen Drop: time-lapse, flyer (7264-7274) | F | 046:509-537 |
| 18 | H17 Underdark Mouth: duergar, spoor (7277-7285) | F | 046:113-120; Gelt |
| 19 | H34 Lizard Nursery (7530-7532) | F | 046:540-560 |
| 20 | H27 Root-Kin Barracks (7534-7536) | F | 046:563-600 |
| 21 | H18 Amber Threshold: chant, sentries (7294-7300) | F | 046:605-629 |
| 22 | H19 Stasis Gallery: Core, lab notes, Temporal Surge (7303-7307, 8021-8061) | F | 046:631-706 |
| 23 | H20 Dissectory Annex: cataloguer, Auril-binding notes, shard origin (7310-7322) | F | 046:709-759 |
| 24 | H28 Suffering Pods, two prisoners (7558-7560) | F | 046:762-787 |
| 25 | H29 Guest Seed Nests: Muzgardt, spy (7562-7564) | F | 046:875-883; Ossk |
| 26 | H30 Root-Lift Node (7566-7568) | F | 046:926-950 |
| 27 | H31 Devil's Bloom: social test, fiend (7570-7572) | F | 046:886-923 |
| 28 | H21 Mirror Scriptory: plans, allies, Mirror-Ink Wraith (7325-7337, 7978-8017) | F | 046:792-872 |
| 29 | H22 Auroral Antechapel: guardians, Shard echo (7344-7356) | F | 046_ForgeRooms:809-874 |
| 30 | H32 Thorn-Run Hall (7582-7584) | F | ForgeRooms:877-881 |
| 31 | H23/H24 Heart Chamber, Breaking Circle, purify/preserve/destroy (7359-7373, 8065-8116) | F | 034_Chapter8:386-525, 633-677 |
| 32 | H33 Hammer-Heart Workshop (7594-7596) | F | ForgeRooms:884-893 |
| 33 | H37 Silent Chapel of the Patron (7610-7616) | F | ForgeRooms:896-921 (choice flags unread, row 15) |
| 34 | H25 Sloughing Veins: escape, mirror-spawn, bridge (7376-7382) | F | ForgeRooms:927-962 |
| 35 | H26 Echo Vault: trap, guardian, seeds, items, World-Tree prophecy (7385-7399) | F | ForgeRooms:964-1051 (3rd sigil comes from Sephek, 047c:181; acceptable) |
| 36 | H36 Aurora Treasury (7606-7608) | F | ForgeRooms:1054-1064 |
| 37 | Heartroot monster index and homebrew bosses (7745-8116) | F | fusion stand-ins throughout 046 (mechanics skipped) |

### Tab 4: the Sephek encounters (8132-8254)

| # | Element (source lines) | Status | Where / note |
|---|---|---|---|
| 38 | Sephek 2.0 Minor Avatar: druids, mephits, half-HP cap, reforms (8140-8198) | F | 047c_WhiteVault.rb:140-189, called from 037:133 (location: the Twinned Dragons shrine) |
| 39 | Sephek 2.5 Major Avatar: below half, transformation, winter wolves, coldlight walker, Divine Rejuvenation by relics (8200-8254) | F | 047c:225-253; relics 047c:194-220, placed by build_w4:491-500; called from 039:353 |

### Tab 4: the personal quests (8256-8440)

| # | Element (source lines) | Status | Where / note |
|---|---|---|---|
| 40 | A1 Echoes at the Auroral Wall (8262-8277) | Ch + bug | two copies: 048_D:754-800 and 047b:157-243; soft-lock (rows 1-2) |
| 41 | A2 The Still Beast (8279-8295) | F | 048_D:139-235; build_ch6b |
| 42 | M1 The Verdant Heist: 4-before-2 wards, three deliveries (8300-8314) | F | 048_D:808-979 (integration choice judged above) |
| 43 | M2 The Whispering Mirror (8317-8331) | Ch | 048_C:660-680 and 033:229-260 (row 12) |
| 44 | B1 Canticle of Seasons (8336-8350) | Ch/C | 026:959-1019; contradicts 039:249 (row 13) |
| 45 | B2 The Stolen Leaf: lake, Wall, frozen warden, time wight, mending (8353-8367) | F | 047b:452-574 (only after summer ends) |
| 46 | R1 Verdant Sickness (8372-8386) | C | 047a:110-144; 032:194-213 (row 21) |
| 47 | R2 Pulse of the Blooming Fields (8389-8403) | F | 048_D:684-747 |
| 48 | W1 Shadows in the Undercity (8408-8422) | C | 047b:306-378 (rows 17, 22) |
| 49 | W2 The Mirror Lake Ghost (8425-8439) | F | 047b:383-447 |

### Tab 4: the group quests (8446-8572)

| # | Element (source lines) | Status | Where / note |
|---|---|---|---|
| 50 | GQ1 Closing the Frostfell Rifts (8450-8468) | F | 047a:640-687 (only while Glimmer lives) |
| 51 | GQ2 Purifying the Heartroot (8471-8492) | Ch | row 14 |
| 52 | GQ3 The Cycle Day Conspiracy (8494-8513) | C | 048_F:644-654 (row 9) |
| 53 | GQ4 Beyond the Auroral Wall (8515-8536) | F | 047b:480-628 (penalty compressed, row 28) |
| 54 | GQ5 Trial of the Four Seasons: debate 4-before-2, four seasons, three outcomes (8538-8568) | F | 036:1486-1612 (as Gym 8) |

### Tab 5: Hyphora's Undercanopy (8577-9895)

| # | Element (source lines) | Status | Where / note |
|---|---|---|---|
| 55 | Lore recap: Hyphora, Erato and Balanus, "the thread that binds" (8597-8621) | F | 032:297-329 |
| 56 | Sovereign Luminara (8633-8719) | F | 032:246-292 |
| 57 | Spore Tender Yarro (8721-8793) | F | 032:178-241; 047a:149-195 |
| 58 | Spore Scribe Lysella (8795-8861) | F | 047a:296, 350-362 |
| 59 | Shroomsmith Korun (8863-8933) | C | 026:414 (row 26) |
| 60 | Mushroom Merchant Faria (8935-8985) | F | 047a:218-269 |
| 61 | Sentry Zym (8987-9053) | F | 026:417-423, 1117 |
| 62 | Mnemosyne Myr (9055-9137) | F | 032:297-329; 047a:412-564 |
| 63 | Eira Shadebloom: intro, lore, patrols, trial (9685-9817) | F | 032:142-173; 047a:569-598 (patrols not reported back, row 15) |
| 64 | H1 Spore Gardens: blight, nursery, Yarro's errand, tremor (9149-9205) | F | 047a:149-195 |
| 65 | H2 Fungal Bazaar: games, masked spy, theft, duel (9207-9247) | F | 047a:200-301; 026:148 |
| 66 | H3 Council Fane: Vision Table, thrones, niche, delegation, poisoner (9269-9337) | F | 047a:306-407 |
| 67 | H4 The Tainted Lake: monster, Balanus seed, purification (9339-9407) | Ch | 032:346-397 (row 24) |
| 68 | H5 Mnemosyne's Chamber: circle, archive, threads, heist, Dream Rescue (9409-9473) | F | 047a:412-564 |
| 69 | Magic items and market list (9475-9623, 9821-9848) | C | row 25 |
| 70 | Quest hooks: lake, memory trade, diplomacy, Echo Gate spy (9655-9683) | F | Hyphora's Seed reward missing (row 25) |
| 71 | The Mycolith's hoard (9852-9893) | F | 047a:622-635 |

### The Shadow Mycolith and Tab 6 (9897-10236)

| # | Element (source lines) | Status | Where / note |
|---|---|---|---|
| 72 | Shadow Mycolith: Five Domains door, two phases, Wyn's god-spark (9897-10236) | F | 032:402-487 (enraged HP, row 29) |
| 73 | Lake minions: quipper swarms, spore-lash creepers (9929-9993) | F | 047a:603-620; reused at 036:992-1011 |

### Tab 8: Chapter X, Trials of the Roots (10241-10436)

| # | Element (source lines) | Status | Where / note |
|---|---|---|---|
| 74 | Aftermath: thinned Wall, frost, walls, cloaks, refugees, scholars, children's stories (10253-10257, 10265) | F | 036:172-202; build_w4:436-449 |
| 75 | Justice system and the Tribunal: seats, punishments, appeal to Hyphora (10263) | F | 036:268-299, 1624-1642 (Autumn dead, not arrested: earlier chapters) |
| 76 | Q1 Roots of Love: reconciliation, the 6-before-3 Heartroot Test, treant, Anduin leaves (10275-10290) | F | 036:523-699; Attunement Way 2165 |
| 77 | Q1 evidence: memento, Leaf of Hyphora, Eirwen (10292-10296) | U / C | leaf_presented never set (row 5); ordering (row 27) |
| 78 | Q2 Assassin's Reckoning: cell, escape, Phildendrin (owner decision), mission, verdict (10298-10314) | F + bug | 036:736-861 (Maera branch, row 4; mission, row 20) |
| 79 | Q2 evidence: Rheven, labs, Mira, refugees (10316-10321) | F | 036:864-904, 1243-1329; 046:741-752 |
| 80 | Q3 Absent Watcher: citation, hearing, Underdark Door crawl, revelation (10323-10335) | F | 036:910-1084 (Pell: integration choice) |
| 81 | Q3 evidence: runes, Pell, wraith witness, Hyphora alibi (10337-10342) | F + bug | row 7 |
| 82 | Q4 Brother from Beyond: Talion, investigation, embrace, three resolutions (10344-10356) | F | 036:1089-1240 |
| 83 | Q4 evidence: memento, lake inquiry, Mira's advice, wraith riddle (10358-10363) | F + bug | 036:1134-1138; 047b:251-277, 396-404 (row 16) |
| 84 | Q5 Spores of Contention: debate, escort, verdict, Fungal Liaison (10365-10384) | F (C minor) | 036:1335-1481 (row 23) |
| 85 | Q6 lead: Slaudi (10400) | F | 047b:120-135; Bryn Shander 2012 |
| 86 | Q6 lead: the myconid memory bubble (10401) | Ch + bug | row 6 |
| 87 | Q6 lead: Mirror Wraith echo (10402) | F | 047b:279-291 |
| 88 | Q6 lead: Ledger of Corruption (10403) | Ch/C | row 10 |
| 89 | Q6 lead: Rheven's sigil horns (10404) | F | 036:884-893 |
| 90 | Q6 public outreach: wall, timber, spirits, blankets, days and neglect (10406) | F | 036:321-407 |
| 91 | Q6 electioneering, candidates, petitions; trial and verdict (10407-10429) | F + bugs | 036:412-518, 1663-1724 (rows 3, 4, 8) |
| 92 | Q6 the vote: run yourselves / stay neutral (10267, 10429-10431) | M | row 11 |
| 93 | Q6 outcomes and consequences (10427, 10431) | C | row 15 |

### Also checked and Full (no separate row)
- The Ch10 Mirror Maze witnesses.
- Sorrel's citation.
- The town criers.
- The winter-wolf raid.
- The appeal at the seal circle.
- The Heartwood treant reward.
- The Lumin long-voyage fallback when no ship-owning candidate wins.
- The temporal guardian's map fragment 3 and the Blessing of Still Sky.
- The Seasons' Token used to free the frozen warden.
