# Fixer F4: Chapter 7A, Chapters 10-13, the White Vault

Branch `worktree-agent-a8098f662fe31f135`. Assignment (docs/FIX_ROUND.md):
- all of reaudit D except items 9, 12, 13 and 14;
- reaudit A items 3 and 5;
- from reaudit B: Sephek's motives, B2 and B3;
- reaudit C item B11.

Paths below are relative to `game/Data/Scripts/998_FrostThaw/` unless they start with `tools/`. The line numbers are for this branch's head.

Tests:
- **f4**: `tools/headless/try_f4_week.rb`, new in this round. It plays every item below in the real game, with checks named after each item.
- **w5q**: `tools/headless/try_w5_quests.rb` (A1 / the Mirror Maze section).
- **story**: `tools/headless/story_run.rb`, the full story driver. It now goes up the Council tower for the Ledger and walks the Mirror Maze.
- **maps**: `tools/check_all.rb` via `tools/build_all.sh`.

## Reaudit D (rootspire.md Tabs 3-8)

| # | Item | What I did (file:line) | Test |
|---|---|---|---|
| 1 | A1 existed twice (048_D and 047b) and the copies contradicted each other | It is now one quest, in one place: the Mirror Maze (map 2161). `enter_mirror_maze` 047b:176 is reached from the Echo Gate frost in Ch6 and from the frost door later. 048_D:764 `echoes_at_the_wall` keeps its intro lines, then calls the same function. The old text maze is gone. `reflection_done?` 047b:189 reads either flag. | w5q (A1 section: map 2161, three junctions, the reflection, both flags); story |
| 2 | The Mirror Maze could soft-lock A1 | `maze_junction` 047b:209: a failure plus a lost wraith fight leaves the junction open. Two failures fold the maze back to the start. `maze_reflection` 047b:237: on success it sets both flags and gives the reward. On failure the junctions reset. After three failures the pane waits until the next day (the dawn rule). | w5q; story (`mirror_maze` story_run:710) |
| 3 | Anduin's nomination could soft-lock | `check_nomination` 036:538 runs whenever any of its three pieces arrives (signatures, the Rootwardens' leave, Reptin's word). It is called from `petition_signer`, `rheven_wall` and `anduin_after`. | f4 "Anduin: fifteen names... then the wardens and Reptin's word" |
| 4 | The Maera branch: Ch10 still treated Autumn as Darrus | Autumn's hand comes from 034 `autumn_hand` throughout Ch10. `witness_line` 036:226 resolves {MAERA_KEPT}/{MAERA_CARRIED}. The lines for Rheven, Phildendrin, the mirror and Kelyn's "a man/a woman" follow whichever hand it was. Maera has her own evidence: `:maera_apprentice_heard` (witness 036:141, set in 048_B's post-Forge apprentice branch), plus the robes and the weasel. | f4 "the Maera branch...", "...and Darrus kept them", "Maera Vell's apprentice is her own witness" |
| 5 | Q1's Leaf of Hyphora was unreachable | The attunement leaf success sets `:leaf_presented` and adds an Anduin line (036, attunement). The leaf is a witness (036:113) and sways Anduin (`anduin_win_back` 036:740). | f4 "Eirwen's word and Hyphora's leaf win back a doubtful Anduin" |
| 6 | The memory bubble counted whether you got it or not | The witness entry is keyed on `:memory_bubble`. `luminara_bubble` 036:1556 is a separate trip during the week, from `leader_luminara` (032:255). A refusal sets `:bubble_declined`, which the verdict reads (036:1791). | f4 (witness list); story |
| 7 | "Hyphora: Shadow answered my call" was shown on a failure | The witness is keyed on `:hyphora_alibi`, which only the `wyn_alibi` success sets (036:1151). | f4 "Hyphora's alibi isn't heard just because Wyn's case closed" |
| 8 | Mira's favour finished at Kelyn | `mira_trials` 036:1327 has a "Give back the cursed mirror" option. The call from `kelyn_trials` is removed. | f4 "Mira's cursed mirror goes back to Mira" |
| 10 | The Ledger of Corruption was a free Forge pickup | The trial-week break-in into Summer's quarters is built (new map 2173, `tools/build_w4.rb:597`). The stair is in the Council Hall's back corner (build_w4:471, `tower_stair` 047d:570). The lock opens with the Marshal's badge, by picking, or by finding the warm knot; failing raises the mud. Inside: alarm glyphs (`quarters_glyph` 047d:620; a failure wakes a construct); the bone-and-ice construct (`quarters_construct` 047d:634; slip past or break it); the floorboard and the Ledger (047d:654); Var's wardrobe (047d:672); the mirror turned to the wall (047d:684, `:avarice_doubt`). The Forge's floorboard (046_ForgeRooms:217) now holds only the empty hollow and a note, "Ledger to the tower" (`:ledger_trail`), and Alberica remembers it at the stair. Only one Ledger exists. | f4 "the tower stair...", "an alarm glyph...", "the bone-and-ice construct...", "under the desk... the Ledger", "the turned mirror...", "back down the stair", "a glyph you can't unwrite..."; story ("side Q6") |
| 11 | The election had no "run yourselves" path and no neutral choice | `election_stance` 047d:350 is asked by Kelyn the first time in the week (alias 047d:770), or at the vote. You can endorse, stand, or stay out. Standing needs the Wardens' oath (a faction) or a petition of five (`CANDIDATES[:heralds]` 047d:309; `petition_signer` takes it). The Heralds also answer at the debates (036:451). `scene_vote` 036:1853: standing auto-picks the Heralds and you speak for a second candidate; neutral makes no picks and sets `:council_uncertain` (036:1902); endorsing a winner makes an ally (036:1905). Consequences at the Council's first session (`four_chairs_consequences` 047d:801): a Heralds' seat picks the route north (`heralds_pick_route` 047d:831, `voyage_route` 037:254); an ally gives a gift (`ALLY_GIFTS` 047d:791); an uncertain Council gives nothing and says so. | f4 "standing for a chair...", "without an oath...", "...five names...", "the Heralds take a turn at the debate stages", "standing, the Heralds win...", "a seat on the Council: the Heralds choose...", "staying out of it...", "speaking for a winner makes an ally" |
| 15 | Consequence flags that were set but never read | **`verdict_geas`**: the Echo Gate turns you back (024:248, `geas_turns_back` 047d:721), and the way beyond the Wall stays shut while it binds (047d:740). The appeal or the Council's first session lifts it. **`wyn_barred`**: Kethan keeps the stores shut (048_B:324) until the Council's first act (047d:801). **`canopy_martial_law`/`canopy_watched`**: a walkway warden on 2061 (build_w4:540, `canopy_warden` 047d:699); under martial law you show the oath or fight; lifted at the first session. **`blight_scarred`**: see 21. **`rootwardens_angered`**: see 22; it also costs Wyn a point at her hearing (036:1029). **`sap_grudge`**: the raid night (`sap_raid` 047d:512), followed by a shared watch at the vats (build_w4:589); if the sap is taken, the spore-guard won't sign petitions that week (036:509). **`pool_poisoned`**: the pool runs cold until Yarro's tincture (047a:312). **`chapel_auril`**: Auril gives you the first breath (039:394, 039:426). **`chapel_avarice`**: Avarice's reflection is stronger at the cradle (047c:367). **`pods_quiet`** and **`pain_pods_freed`**: both are witnesses against Summer (036:144-145). **Eira's patrols** are reported back (047a:592, `eira_patrol_report` 047d:728, condition 032:165). | f4 "the verdict's geas...", "...stays shut", "lifted...", "Wyn barred...", "martial law...", "...who lets a sworn Warden through", "the Rootwardens angered...", "the poisoned pool...", "Eira hears...", "night three... the Rootwardens come for the sap", "a shared watch...", "the Silent Chapel's polite answer...", "the Silent Chapel's fire answered..." |
| 16 | Q4 counted testimony that never happened | `:talion_haunted` is dropped from Talion's witness entry. | f4 "Talion haunted gives no testimony" |
| 17 | W1's spore penalty did nothing | When you are spored, the commune needs a second success: "Hold on to your own voice" (047b:389). The no-op line is gone. | f4 "breathing the spores..." |
| 18 | Wyn's post was in two places | It is the Sap Gate everywhere. At the Underdark Door: "My post at the Sap Gate was set to guard this..." (036:1090). | text change; story passes it |
| 19 | Three NPCs called Pell | The Q3 warden is **Ivo** (036:123; build_w4 event "Ivo"; story_run talks to /^Ivo$/). The College scholar is **Orrin** (026:124). The 033 Guild worker keeps "Pell"; the Act I Pells are F1's. | f4 "Ivo is the junior Rootwarden now"; story |
| 20 | `phildendrin_after` refused the petition after `:mm_atoned` | The condition is now `!nominated?(:phildendrin)` (036:185). | story |
| 21 | R1: `:blight_scarred` never read | Selrae's debate starts one failure down, with a line (036:1626). | f4 "the blight's scar..." |
| 22 | W1: the identical branches; burning never angered anyone | With Wyn, `spore_trail` follows her nose (047b:363); without her it is a plain choice. `:rootwardens_angered` means Rheven makes you earn his testimony even after the wall (036:943), and Wyn's hearing loses a point (036:1029). | f4 "the Rootwardens angered..." |
| 23 | Q5: refusing never led to combat | "None of their business" brings Selrae's wardens off the wall: a fight, or the floor of the Hall plus mud (036:1452, `:spores_fought`). | f4 "Q5: refusing to explain..." |
| 24 | H4: Yarro's purification ritual was missing | `lake_purification` 032:409 runs after the lake-wyrm (032:377): two herb checks (Yarro's lake sample gives the right recipe), then pseudopods (one creeper, or two if the mix smokes), then the rain. | f4 "H4: Yarro's ritual at the lake..." |
| 25 | Missing Undercanopy goods | Sap-Stones, the Hyphal Lash and the Rootbond Armlet come from Korun (`korun_craft` 047d:99). The Wand of Spores is from Faria (047d:152, via `faria_stall` 047a:250). Hyphora's Seed (for the lake) and Hyphora's Crown (for the sworn) come from Luminara (`luminara_gifts` 047d:131). Each has a battle handler (047d:179-255); the Seed and the Rootbond Armlet are battler hooks (047d:262 onward). | f4 "Korun: a maker's discount...", "Faria sells the Wand...", "Luminara: Hyphora's Seed... the Crown...", "the new goods work in battle" |
| 26 | Korun was a one-line NPC | `korun_smith` 047d:58 mends PP (free for a maker, Meat Meat), scorns neglect, sells his craft, and makes a hyphae toy for the nursery's sporeling. The event is in `tools/build_ch6b.rb:202`. | f4 "Korun: a maker's discount..." |
| 27 | Q1's evidence never swayed Anduin | `anduin_win_back` 036:740: two proofs, or one plus an honest word, win back a doubtful Anduin, once. | f4 "...win back a doubtful Anduin" |
| 28 | GQ4: the trapped penalty was gone | `beyond_trapped` 047b:682: half the Wheel is lost, and a Rootwarden rope-line (Brisa's, if you freed her) hauls you out. It costs the day during the trial week. | f4 "GQ4: trapped in the stopped snow..." |
| 29 | The enraged Mycolith healed to full | It now starts at 215/350 of its HP (032:496). | f4 "the Shadow Mycolith doesn't heal to full" |

## Reaudit A (session_log.md)

| # | Item | What I did | Test |
|---|---|---|---|
| 3 | Reptin's vow at the Chasm is never kept | On the third trial night a grey wolf from the Chasm waits outside the Hearth (`reptin_wolf_message` 047d:452). It shows what became of the Chasm: kobolds, the yeti, the ghost's candle, the wolves. Reptin repeats his vow (`:chasm_watch_kept`). In the epilogue Reptin goes back to the Chasm every winter (039:632). | f4 "night three: a grey wolf from the Chasm...", "the epilogue: Reptin goes back..." |
| 5 | The Whisper lost three clauses; `:omens_seen` was never read | Restored: "a sentinel chained to frost" (037:54), "stop them, and all is mine", and "Guard them if you must... the wheel turns for me" (037:66), before "Come and be beautiful forever". With three or more omens seen (037:60): "You've seen them. Every sign... You told no one." | f4 "the Whisper...", "...the wheel turns for me", "...and she knows you saw every omen" |

## Reaudit B (rootspire.md Tab 1)

| Item | What I did | Test |
|---|---|---|
| Sephek's motives (B #2) | **The hooded pilgrim with a cold blessing** (`pilgrim_dream` 047d:482) comes on the second trial night. He calls Meat Meat "Prototype Verdant" and says Alerion is "one too many". Taking the blessing freezes your lead Pokémon and costs the Wheel; Sephek remembers it at the crown. **At the Minor Avatar** (047c:144-151) he wants Meat Meat's engine-cooked blood and calls Alerion his rival. **At the crown** (`sephek_motive_lines` 039:300): "Frost doesn't share". | f4 "night two: Sephek comes as a hooded pilgrim...", "...'Prototype Verdant'...", "taking the cold blessing...", "the Minor Avatar...", "at the crown Sephek wants Meat Meat's blood..." |
| B2 Darrus's redemption pays off | `darrus_pays` 047d:845 runs at the Council's first session. A Corsair runner brings his crate: sap-scrip 10,000, two Full Restores, a Max Revive, and a note saying it is "for the voyage, and for the vault after it". If nobody elected has a route north, he charters the Requiem (`voyage_route` 037:258) and the long voyage is off. On the ship he is in the hold, counting barrels (038:138). The Corsairs aboard fight at Sopo's dock (038:223). | f4 "Darrus pays for the voyage...", "...Darrus charters the Requiem" |
| B3 the Favour Track has an effect | On the first trial morning (alias 047d:762, `favour_boons` 047d:391), warm or trusted factions give a boon: Spring gives seeds and a good word, Winter's Order keeps the mud off, Autumn's Court gives a purse. Cold factions turn their backs (mud). Inherited rivalries also add mud: Autumn heckles Spring's friends, Spring heckles Autumn's, and the old Summer loyalists heckle Winter's. At the vote (`favour_votes` 047d:435; 036:1881), a warm or trusted faction brings out its candidate's votes, and a cold one costs your first pick a vote. | f4 "a warm Spring sends its friends a basket", "...a cold Autumn turns its back...", "at the vote, warm Spring..." |

## Reaudit C

| # | Item | What I did | Test |
|---|---|---|---|
| B11 | The Frostfire Flask in the trial | It is a witness against Summer (036:143), read from `:frostfire_flask`. F3 sets that flag where the flask is found. | f4 "the Frostfire Flask is evidence against Summer" |

## Test results (this branch's head)

Run on /home/claude/pifrun_F4 (heavy runs under `flock /tmp/ft_heavy.lock`):
- `tools/build_all.sh`: all map checks passed (156 maps; the new one is 2173).
- `try_f4_week.rb`: 66 ok, 0 failed, 0 problems.
- `try_w5_quests.rb`: 29/29.
- `try_loop.rb`, `try_w4.rb`, `try_w4_7a.rb`, `try_w4_paths.rb`: all pass (exit 0, no FAIL/MISS, no problems).
- `tests/smoke_test.rb`: 206/211. The 5 failures are the known missing pictures in a worktree copy (the cup game's four pictures, and "those pictures are shipped"). They are not code.
- `story_run.rb`: 234/234 story beats, ending in SC 13.10 (`game_complete`), in 277s (8 retries after lost battles). The new beats were reached: "side Q6: Summer's quarters", "side: the Mirror Maze", A5's `ledger_trail`, the vote and four chairs. The driver's own navigation notes at the end ("no way from 2050 to 2089", "nobody called /Root-drakes/" and so on) come from retry loops in other chapters, and every one of those beats still came up OK.

## For the merge

- **The Ledger (with F3).** The break-in at Summer's quarters is now the only way to get the Ledger. The Forge's `loose_floorboard` (046_ForgeRooms:217) is reworked in this branch into the empty hollow plus the "Ledger to the tower" note. If F3's branch also edits that function, keep this version. story_run's A5 beat now waits for `:ledger_trail`, and the trial-week side runs the break-in ("side Q6").
- **047c (with F3).** F3 also edited Sephek's Minor Avatar, the Vault cradle and the Throne scene. My hunks are small and self-contained: the Prototype Verdant/rival lines just after "Mine, while they stand" (047c:144-151), and the chapel line before the soul's HP (047c:367).
- **The 036 vote.** `scene_vote` is reworked around the stance. `CANDIDATES`, `CANDIDATE_BASE`, `SIGNATURES_NEEDED` and the debate answers gain `:heralds` in 047d:309, not in 036.
- **Aliases.** 047d aliases `trial_day_passes`, `scene_trial_morning` and `kelyn_trials`, guarded with `method_defined?`. Anyone else wrapping them should load before 047d or alias the same way.
- **New ids.** Map 2173 "Summer's Quarters" (base PIF map 35). Switches 4154 (the vat watch) and 4155 (the Canopy warden). Trainer data `[:FT_ROOTWARDEN, "Lis", 1]` (id_number 9894) is Warden Lis's second team; her Ch6 team stays version 0. New trainers in TRAINERS: Oakes, Checkpoint Warden, Selrae's Warden.
- **New flags others may read.** `council_heralds`, `council_uncertain`, `state[:council_ally]`, `state[:voyage_pick]`, `darrus_paid`, `darrus_chartered`, `took_cold_blessing`, `chasm_watch_kept`, `ledger_trail`, `ledger_from_quarters`, `sap_raided`/`sap_raid_stopped`, `pool_cured`, `eira_patrols_reported`, `beyond_rescued`, `spores_fought`, `lake_ritual_done`, `wyn_bar_lifted`.
- **F3's new flags.** `:mira_left_possessed` gives the Requiem to Mira's first mate in the voyage text (038 `voyage`) and in the Heralds' route pick (047d `heralds_pick_route`). `:shard_sanctified` doesn't bear on my scenes.
