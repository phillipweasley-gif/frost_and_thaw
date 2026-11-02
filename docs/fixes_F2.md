# Fixes F2: Rootspire and Chapter 6

Branch `worktree-agent-ad601e034140ed67b`. Paths are under game/Data/Scripts/998_FrostThaw unless they start with
tools/ or tests/. Line numbers are as of the final F2 commit.

Tests:
- `tools/headless/try_f2.rb` plays these fixes in the real game: 42 checks, all pass. Run it with
  `PIF_DIR=<test copy> ruby tools/headless/try_f2.rb`.
- `tests/smoke_test.rb` has the new F2 checks. It passes 216/221; the 5 failures are environmental and listed at
  the end.
- `bash tools/build_all.sh`: all map checks pass (155 maps).
- `story_run.rb` passes in every mode tried:
  - Journey run to the end of Ch7: 134/134 beats.
  - Herald runs as Alberica, Shade and Reptin, to the end of Ch6: 90/90 beats each.
- try_w5_city 27/27, try_w5_quests 28/28, try_w5_sweep 11/11, try_loop: all pass.

## Reaudit A (session log)

| Item | What I did | Where | Test |
|---|---|---|---|
| 2 Glimmer's journal payoff | If the bag holds FT_GLIMMERJOURNAL, Glimmer reads it at the Rift. He sees his own hand ("I'm still trying. Apparently I always am."), which pays off the ghost's "You'll see". Sets `:glimmer_knows_journal`. The Ch5 corpse is now "a half-chewed skeleton, too long in the arm to be human, with claws" (one-line edit in F1's file). | 029_Glimmer.rb:127-140; 023_Chapter5.rb:393 | try_f2 "Shade comes back as Glimmer, and reads the dead Glimmer's journal"; smoke "F2's restored lines in 029/023" |
| 6 Glimmer's vision, and its timing slips | Restored: "weeps, and in the tears there is fire" and the heart of ice going into "the root the acorn woke". "since the mirror" now branches on `glimmer_joined` (otherwise "the Glade"). "wyrmlings wake/tremble" become "they blaze with life" and "two dragons cower". Seen before the Rift, the vision is Brightmane's first call ("Sparkbearer. My light is yours."). | 026_Rootspire.rb:940-952, 964 | smoke "F2's restored lines in 026_Rootspire" |
| 7 Pendant "still there" | Now "...Still gone. Of course it is." | 026_Rootspire.rb:459 | smoke, same check |
| 8 Omens: dead stop-gates, and "harsher if she strays" | Both gates now check `flag?(:auril_whisper)`. `omen_tier` goes up one step when `alberica_strayed >= 2`. That count covers saw_auril_bryn, hag_bargain_taken, chapel_auril, shard_preserved, tree_leans_frost and any cursed Still Shards. The Whisper's `:omens_seen` line is F4's. | 048_Rootspire_E_Nights.rb:104-123, 163 | try_f2 "Alberica's straying brings the omens on harder", "...after the Whisper there are no more omens, and no more Hearth nights"; smoke "the omens stop with the Whisper..." |
| 11 Alerion's vision | "Shimmer, her breath silver in the night, her eyes locked on a man with a shield. Him."; "Frostina's cry echoing across the void"; "Both roads are his." | 026_Rootspire.rb:903-914 | smoke 026 check |
| 12 Reptin's second fate | Added "...as the curse bound him to hunger" and "Even so, the wheel turns. Even ruin is motion. Both have to keep moving." | 026_Rootspire.rb:957-967 | smoke 026 check |
| 13 Reptin's bite | "wolf-bite in your hand" | 026_Rootspire.rb:959-960 | smoke 026 check |

## Reaudit B (Tab 1), Missing

| Item | What I did | Where | Test |
|---|---|---|---|
| 1 Glimmer's Trial: the celestial envoy | A full scene at Lumin, after Brightmane's rite. The envoy comes from Brightmane, and the party gives its counsel. Then you choose: hope (Shell Bell, `:glimmer_hope`), judgment (Charcoal, `:glimmer_judgment`), or "yours to choose" (Glimmer picks hope). Plays once (`:envoy_judged`). | 048_Rootspire_H_Faithful.rb:234-276; hooked from `lumin`, 026_Rootspire.rb:894 | try_f2 "the celestial envoy asks Glimmer... judgment", "...once" |
| 4 Eirwen's ledger dilemma | On a later visit, Eirwen means to put Naerth's ledger on the open shelves at the festival, and Alerion, Reptin and Alberica react. You choose: publish (+Winter, -Spring, and a Halo preacher reads it aloud), seal (+Spring), or take it to the Council privately (Kelyn and Selrae; +Spring, -Winter). Sets `:naerth_ledger_published` / `_sealed` / `_council` and `:naerth_ledger_decided`. | 048_Rootspire_H_Faithful.rb:309-348; 048_Rootspire_D_Quests.rb:582 | try_f2 "Eirwen's dilemma: Naerth's ledger, published" |
| 5 Hellen's old passages | Hellen's errands run once each, over several Hearth visits: (1) after the Seal, the family passage, which sets SW 4180; (2) a sealed note for Ivran, delivered past a Halo tail (lose him, or fight `halo_silencer`), which earns a Corsair berth (`:corsair_berth`); (3) her thanks, $2000; (4) frost on the Heralds' shrine and a night vigil, where you talk Tobin down (he names the lantern-hooks) or he is arrested; (5) her thanks: Leftovers and berries. The passage runs from the sun-chalked cask in the cellar (2059 (5,24)) to a barrel on the Split Dock (2055 (34,9)) and back. | 048_Rootspire_H_Faithful.rb:354-476; 024_Chapter6.rb:361; 048_Rootspire_D_Quests.rb:505; tools/build_ch6b.rb:47-57; tools/build_ch6.rb:234-240 | try_f2: Hellen checks 1-9 (both directions of the passage, the note, the coin, the vigil, the thanks) |
| Verse XI | Shown after the Canticle succeeds, as the line Eirwen carves over the Library door. Sets `:verse_xi_known`. | 026_Rootspire.rb:1104-1107 | try_f2 "...the Canticle sung whole: ... Verse XI" |
| Avarice's birth-cries | On the mirror night, if you hold your reflection's gaze, the white-haired woman whispers five newborn cries, each one yours, then "I know the ones you were born with." | 048_Rootspire_E_Nights.rb:298-306 | smoke 048_E check ("a newborn's cry") |
| 2 Sephek's motives / 3 Hew's gift / 6 Mira possessed | Not mine: F4, F3 and F3, per FIX_ROUND. | - | - |

## Reaudit B, Bugs

| Item | What I did | Where | Test |
|---|---|---|---|
| B1 `:warden_map_seen` never set | Now set by the warden-map sign. Kethan's reveal lists only the clues you actually found. | 048_Rootspire_B_People.rb:40; 048_Rootspire_D_Quests.rb:308-318 | try_f2 "reading the Rootwarden Hall's patrol map counts as Kethan's clue" |
| B3 Favour track has no effect | `favour_tick` runs each Hearth night. The first faction to reach +2 becomes your patron: it gives a boon, and its rival drops one point. At +4 it trusts you and gives a second boon (Kelyn's brooch, Selrae's stone, Lumea's coin, Summer's orb). Any faction at -2 or lower acts on it once: the Winter inspector or a Summer zealot (trainer battles), an Autumn tax bill, or Spring's cold shoulder. The vote-side rivalry is F4's. | 048_Rootspire_H_Faithful.rb:510-583 | try_f2 favour checks 1-4 |
| B2 Darrus financing, B5 Echoes at the Wall | F4 (B2 is in their list; B5 is part of the A1 merge they own). | - | - |
| B4 Mira, B6 Still Sky vs H7 | F3. | - | - |

## Reaudit B, Compressed

| # | What I did | Where | Test |
|---|---|---|---|
| 10 Wardens Emeritus, and Kelyn's terror | She now says "Wardens Emeritus of Rootspire. Sworn against the old cold gods." Added her fear of Auril: her white hand on the seat's arm, "I still can't sleep in a cold room". | 024_Chapter6.rb:592-607 | smoke 024 check |
| 11 Still Ones: shatter or redeem | Three options: help it finish (boss fight, counts toward the green), shatter it (`still_<k>_shattered`, a Still Shard, `wheel(-1)`, counts toward the frost), or leave it be. After all four, the Tree leans verdant or frost (`:tree_leans_verdant` / `:tree_leans_frost`), with different lines. The dawn's colour shows the lean, and the frost lean counts as Alberica straying. | 026_Rootspire.rb:1338-1386; 048_Rootspire_E_Nights.rb:188-189 | try_f2 Still Ones checks 1-3 |
| 12 Eirwen's holy texts, chronal leaves | Eirwen tells Alberica that her verses are scripture here, and offers the chronal leaves. | 026_Rootspire.rb:353-355 | smoke 026 check |
| 13 Sephek's mirror-ice | The fisher and the Corsair sailor speak of mirror-ice, and of a barefoot man walking north with no coat. | 024_Chapter6.rb:90-95 (TEXT fisher, corsair_sailor) | smoke 024 check ("Mirror-ice") |
| 14 Expansion debate | At the first Council session: Darrus wants the lower terraces; Kelyn ("the tree forgets what balance is") against Selrae ("Expansion is a wall"). | 024_Chapter6.rb:624-628 (Council session) | smoke 024 check |
| 15 Darrus's ruin | `autumn_ruin`, once after `heist_exposed`: flour doubles, half the Bazaar is shuttered, and the Guild freezes his accounts. | 048_Rootspire_H_Faithful.rb:585-594 | covered by code path only (it plays from hearth_extras like favour_tick) |
| 16 Worshippers sing the Canticle | They sing it at the orb, before and after the visions. | 026_Rootspire.rb:859-860, 868 | smoke 026 check |
| 17 Staff attuned at the Auroral Wall | The crypt now gives `FT_UNBONDEDSTAFF`, and Reptin is told it must be bonded at the Wall. A night at the edge of the light ("Sign auroral_wall", 2060 (46,9)/(46,17)) runs through the four seasons with two choices. Fail and the party loses a quarter of its HP; either way the staff becomes the Heartwarden's Staff. Sets `:staff_attuned`. | 026_Rootspire.rb:1172-1205; 048_Rootspire_H_Faithful.rb:480-504; tools/build_ch6b.rb:105 | try_f2 staff checks 1-2; story_run "side: the staff bonded at the Auroral Wall" |
| 18 The shadow's question | Now always played in `glimmer_arrives`: "Will you bear hope when even the sun freezes?", plus the Rift inscription. | 029_Glimmer.rb:103-109 | try_f2 journal check (reads the log); smoke 029 check |
| 21 Leaf on the Pillow | Moved from the Promenade bench to HEARTH_VIGNETTES ("on your bed"). | 048_Rootspire_E_Nights.rb:564 | smoke "faction events (9 by map, 5 at the Hearth...)" |
| 7, 8, 19, 20, 22 | F4 (7 Var's glaive, 8 Eline's mercy, 20 relics as keys) and F3 (19 visions, 22 Hew). | - | - |
| 9 | Same as B3. | - | - |
| 23, 24, 25 | Re-audit says "Acceptable" (and 25 is the Var owner decision). No change. | - | - |

## Reaudit B, Changed (26-36)

- 26 Echo Gate location: accepted; it carries Krolf, the scorch and the wraiths.
- 27 Smuggler's Run: kept as the Guild tunnels (the Heist needs them). The Corsair sailor now says they run the
  tunnels under the Split Dock "when the Council isn't looking", which restores "controlled by the Auroral
  Corsairs".
- 28 Cycle Day:
  - The festival's last night is now the seventh night, and the Cycle Day Conspiracy plays on it (see D9).
  - Its failure branch brings Auril's Icy Avatar to the Still Sky Shrine, which is the source's Still Sky
    manifestation on Cycle Day.
  - Eline's Rite stays on the Council night before. The festival requires it (`festival_business_done?`), and the
    Halo's heart plot follows from it.
  - The opening now names the Festival Circle.
- 29, 31, 32, 33, 34, 35, 36: integration choices or owner decisions (the Var/Avarice coat twist, Talion). No change.
- 30: F3 (M2 / Mira).

## Reaudit C (Tab 2 / the Forge)

| Item | What I did | Where | Test |
|---|---|---|---|
| B1 No "before the Forge" gate | `dt_ready?` and `eirwen_audience_due?` now check `!barricade_entered`. `dt_ready?` gates Arvik, Alerion's desk, Lumin's rite and Meat Meat's days. `investigation_night` needs `festival_night && !ch7_started`. The roads down (`ch7_started`, SW 3937) now open only at the Council's summons, which comes after the chardalyn. So outline steps 1-6 always play between the festival and the descent. | 048_Rootspire_F_Downtime.rb:27, 699; 048_Rootspire_E_Nights.rb:196-217; 024_Chapter6.rb:507-522 | smoke "the downtime week and the GM outline end at the Forge's door"; try_f2 festival checks 4-7 |
| B2 Seventh night | `festival_ready?` requires `rs_day >= FESTIVAL_NIGHT` (7). Until then Hellen counts down the nights, and the goal names who to spend the days with (Arvik, Alerion's desk, Lumin, Razzilith, the Lorn Scribe). | 024_Chapter6.rb:344-394 | try_f2 "the festival waits for the seventh night", "...and comes on it"; smoke "festival night needs the rite, Glimmer and Hellen's seal (...and the seventh night)" |
| B4 Summons repeats the mission | Kelyn's mission line moved out of the festival ("Stay in the city tonight... the Council will send for you") into the new `council_summons`, which Eirwen's audience calls. That gives the source's order: festival, door, scorch, Eirwen, Razzilith, summons, mission. | 024_Chapter6.rb:481-522; 048_Rootspire_F_Downtime.rb:715-718 | try_f2 "...Eirwen's audience, then the Council's summons: both roads open"; story_run beats "the Rootwardens at the door" to "Eirwen's audience, then the Council's summons" |
| B11 Brightmane "she" | "Brightmane said I'd know the fire..." | 048_Rootspire_B_People.rb:646 | smoke 048_B check |
| B11 Alerion's potion lock | Day 5 now counts whether or not the potions are bought: Nivva holds them (`:alerion_potions_held`) and sells them later. | 048_Rootspire_F_Downtime.rb:252-291; 048_Rootspire_B_People.rb:124 | try_f2 "Alerion's Day 5 counts even when the six potions can't be bought", "...and Nivva holds them until he can" |
| B11 Frostfire Flask, dragon eyes | F3 / F4. | - | - |
| C2 Outline steps after the mission | Fixed by B1 and B4. | as above | as above |
| C6 The horn | Re-audit: "No fix needed" (it follows the Shade-to-Glimmer owner decision). Unchanged. | - | - |
| C7 Festival location | The festival stays in the market. `festival_opening` now calls it the Festival Circle, at the market's heart round the Council Hall's steps, which matches the source's names. | 048_Rootspire_F_Downtime.rb:658 | smoke 048_F check |
| P3 Mural; "children of the Reversal" | The mural carved in living bark, whose figures shift when nobody looks; Kelyn's "We are the children of the Reversal". | 048_Rootspire_F_Downtime.rb:661-669 | smoke 048_F check |
| P4 Heightened Summer-Sense | Meat Meat's dawn day sets it for the next day. It plays a part in GQ3: she finds the carved lanterns without a check. | 048_Rootspire_F_Downtime.rb:569-576; 048_Rootspire_H_Faithful.rb:166-173 | code path; try_f2 GQ3 runs without it (the check is the auto-success branch) |
| P5 The 11/25 recap | `glasswater_recap`, on the first morning: icy glimmers under the Glasswater, green sparks like fireflies, and the smell of frost. | 048_Rootspire_H_Faithful.rb:70-78 | plays in try_f2's rests (log) |
| C1 (F3's), the lines in my files | Added Glimmer's "Hammers. Deep in the roots" and Frostina restless on the Rootwardens' night. Eirwen's passage line is F3's. | 048_Rootspire_E_Nights.rb:212-214 | smoke 048_E check |

## Reaudit D

| Item | What I did | Where | Test |
|---|---|---|---|
| 9 GQ3 the Cycle Day Conspiracy | Built in full. | 048_Rootspire_H_Faithful.rb:83-229; 048_Rootspire_F_Downtime.rb:678-681; 024_Chapter6.rb:511 | try_f2 "GQ3: ... foiled, the effigy saved", "GQ3 lost: Auril's Icy Avatar...", "...and the Hearth mourns them", "...and so does the Hall" |
| 13 B1 the Canticle | Rewritten to the notes. | 026_Rootspire.rb:995-1130; 048_Rootspire_H_Faithful.rb:281-307 | try_f2 Canticle checks 1-4; smoke "the Cycle Canticle has three verses..., matching Ch13"; story_run beats "the Canticle's lost verses" and "the Cycle Canticle (Whisper Key, Verse XI)" |

How GQ3 works:
- **The rumours.** From night 3, the rumours bring a choice of who to ask:
  - the apprentice reveals the runes (`:lantern_runes_known`);
  - the Corsair is a waste of the night;
  - the grey pilgrim warns the cult (`:cult_warned`).
  - Tobin's vigil at the shrine can also reveal the runes.
- **The festival-night chain.** Seven challenges: shadow, find, disarm, blend, spot, the last string, and the effigy.
  - You need 5 successes before 3 failures.
  - You start one success up if you know the runes, or one failure down if not.
  - Each failure brings a Frost Cultist trainer battle.
- **Win:** the effigy is saved, you gain the Rootwardens' favour, Spring +1 and `wheel(3)`.
- **Lose:** Auril's Icy Avatar appears at the Still Sky Shrine (2056). It is a boss, B124H144 L46. Eleven people
  die (`:festival_casualties`):
  - Hellen mourns them at the Hearth;
  - Kelyn's summons names them in the Hall;
  - you still get `wheel(2)`.

How the Canticle works now:
- **Eirwen invites you.** It needs Alberica, and you get one try a night, before dawn.
- **The lost verses.** You can research them first with Eirwen: two Library checks find all three verses, or a
  failure finds two. Or you can improvise.
- **The song.** Three verses: spring (hope), autumn (loss) and winter (endurance).
  - The Key may ring one verse in place of her voice.
  - On a lost verse, only the truest line holds.
- **Two verses or more succeed.** You get:
  - the Whisper Key;
  - Eirwen's chronal leaf with the prophecy "The Frost Saint will climb the Spire when the roots bleed."
    (FT_PROPHECYLEAF);
  - Verse XI;
  - `wheel(2)`.
- **Fewer than two fail.** The spectral bards attack (a double battle against two Woobat L42). Some secrets come
  back anyway, you get `wheel(1)` once, and you can try again another night.
- **Ch13 matches.** It already says "three verses. Hope, loss, endurance", so 039 needed no edit.

## Bugs found while testing (fixed)

- **The sun-chalked cask blocked the shrine.** At (3,23) it covered the only tile you can pray at the Heralds'
  shrine from. It is now in the corner at (5,24). The passage landings are 2059 (6,24) and 2055 (37,9), so neither
  bounces you off the other end.
- **The Canticle research could come back after the song.** It was offered when `canticle_learned` was set without
  `key_attuned`. It now checks for both (H_Faithful:282).
- **"You sings..." in Herald mode.** The prompt is now "You sing..." / "Alberica sings..." (026:1060).

## Shared edits outside my files (minimal)

- 023_Chapter5.rb:393 (F1): the skeleton line.
- tools/headless/story_run.rb:
  - The festival loop rests until the seventh night, then plays the door, the scorch and Eirwen's summons.
  - Eirwen's research comes before the pillar.
  - The staff is bonded at the Wall.
  - New answers for "And which one, for loss" and the verse prompts. The obsolete `/Verse \d/` rule is gone.
- tools/headless/try_w5_quests.rb: one line, giving Naerth's ledger a visit of its own before the ritual.
- tests/smoke_test.rb:
  - The festival check now also needs the seventh night and the summons.
  - The faction-event counts are now 9 by map and 5 at the Hearth.
  - New checks: the restored lines, the omen gates, the Forge-door gate and the three-verse Canticle.

## New switches, items and flags (cross-worker contract)

- **Switch:** SW_HEARTH_PASSAGE = 4180, the Hearth passage (in F2's 4160-4199 range).
- **Items:**
  - FT_PROPHECYLEAF, FT_UNBONDEDSTAFF and FT_HELLENNOTE (key items, with no icons yet; they use the default icon);
  - FT_STILLSHARD is now also given by shattering a Still One.
- **Flags others may read:**
  - Glimmer: `:glimmer_hope` / `:glimmer_judgment` (`:envoy_judged`), `:glimmer_knows_journal`.
  - Eirwen's ledger: `:naerth_ledger_published` / `_sealed` / `_council` (`:naerth_ledger_decided`).
  - The Canticle: `:canticle_haunted`, `:verse_xi_known`, `:canticle_researched` / `:canticle_partial`.
  - GQ3: `:effigy_saved`, `:cycle_day_done`, `:icy_avatar_fought`, `:festival_casualties`, `:lantern_runes_known`,
    `:cult_warned`.
  - The festival and the summons: `:council_summoned`. `:ch7_started` now means "the Council sent you down", not
    "the festival ended".
  - Hellen and Tobin: `:corsair_berth`, `:hellen_passages`, `:tobin_turned` / `:tobin_arrested`.
  - The staff and the Tree: `:staff_attuned`, `:tree_leans_frost` / `:tree_leans_verdant`, `still_<key>_shattered`.
  - Favour: `state[:patron_faction]`, `favour_trusted_<f>`, `favour_cold_<f>`.
- **Loop skip lists.** 041_LoopFlags.rb is a dump from a full run, used only as a fallback. It doesn't list the new
  flags. Regenerate it with LOOP_DUMP after the merge if you want them in the skip fallback.

## Environmental smoke failures (not regressions)

- "and those pictures are shipped" and the four "cup game picture" checks fail.
- They read build/ft_battlers and build/cups, which are gitignored build outputs (`.gitignore:6 build/*`) and don't
  exist in a fresh worktree. They pass in the main checkout, where those folders exist.

## Notes for the merge

- **story_run.rb.** If another fixer changes the Ch6 section of story_run.rb, keep the festival loop: the festival
  no longer opens the roads, so a driver that only talks to Hellen once stalls at `ch7_started`.
- **Rebuild the maps** (`tools/build_all.sh`) after merging build_ch6.rb and build_ch6b.rb. The barrel, the cask and
  the Wall signs are events in 2055, 2059 and 2060.
- **Flaky driver warnings.** Herald runs sometimes report "couldn't reach ... (moved_away)", once each for Hellen
  and the Lumen Shard. These are random battle or path interruptions. The beats still pass, and a rerun didn't
  reproduce them.
