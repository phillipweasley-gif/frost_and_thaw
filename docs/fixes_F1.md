# Fixes F1: Act I (reaudit E in full; reaudit A 1, 4, 9, 10, 14, 15, 18, 19)

Branch `worktree-agent-a54c5e61a95e64cf8`. Paths below are relative to `game/Data/Scripts/998_FrostThaw/` unless they start with `tools/` or `tests/`. Line numbers are as of the last F1 commit.

## Tests
- **`tools/headless/try_f1.rb` (new):** 76 checks, one or more for each item below. They run in the real game code: a fake battle for the mid-fight scripts, the compiled maps for events and warps, and walking the new road. **76/76 pass.**
- **`tests/smoke_test.rb`:** 207/212 pass.
  - The 5 failures are the cup-game pictures and the shipped-fusions check. Those assets are gitignored, so they are missing from a fresh worktree; they pass in the main checkout.
  - New check: Mishann brings the golden acorn after Duvessa's win.
  - The Duvessa check now looks for the "Steel Wing" message, because a second item is now received after the TM.
- **`tools/headless/try_w1_act1.rb`:** 59/59.
  - The old "the knife falls and the wheel turns back" check now checks the new rule: the cub is cut, it lives, and the act goes on.
  - The witch-queen and Hlin sections now clear the flags they depend on.
- **`ruby tools/check_all.rb`:** all map checks pass (156 maps, including the new 2101).
- **`tools/headless/try_loop.rb`:** 12/12 after the `start_loop` and `040_Loop` changes, with both act skips replaying your own run.

Run with: `cd /home/claude/pifrun_F1 && PIF_DIR=/home/claude/pifrun_F1 ruby <worktree>/tools/headless/try_f1.rb`

## Reaudit E

| Item | What I did | Where | Test (try_f1 unless noted) |
|---|---|---|---|
| E1 / DH11: the starving-pack bite can be skipped | <ul><li>The pack is now a trigger row across every walkable row of the crossing (x 35, y 4-30), so you can't walk round it.</li><li>`starving_pack_sighted` guards on the pack-gone switch and the bite, then runs the existing scene, so the bite always happens, and only once.</li></ul> | `tools/build_tentowns.rb:327`; `045_HoledUp.rb:163` | "E1: a trigger row...", "...Reptin is bitten", "...only once" |
| E2 / C84: the loop leaks Act I state | `start_loop` now:<ul><li>keeps only the player's own state (`LOOP_KEEP_STATE`: team, bag, bank, bargain memory, item charges...) and drops everything else, such as the election clock, tracks and baskets;</li><li>clears self switches on every map from 2001 up to 2399, including the 21xx side quests;</li><li>clears all story switches (3900-4199);</li><li>clears the story's counters (omens, watchers...), keeping only the wheel, the story beats, the loop count and trainers beaten (`LOOP_KEEP_COUNTERS`).</li></ul>So that "I remember this, skip ahead" still replays *your* act, `loop_snapshot` now also records the act's story state and counters, and `loop_skip` restores them (`loop_skip_state`). Without that, the skip would lose quest clocks, favours and scores that used to survive only by leaking.<br>There are no `$game_variables` in the Frost & Thaw scripts, so nothing else needs resetting. | `039_Chapter13.rb:556-580`; `040_Loop.rb:20-60` | six "E2:" checks; try_loop |
| E3: the third way assumes an optional golden acorn | <ul><li>New `morninglord_acorn`: Mishann brings Reptin the acorn on the hall steps straight after Duvessa's seal is won.</li><li>Visiting the House of the Morninglord still gives it, if you somehow don't have it.</li><li>The goal text no longer sends you to Mishann.</li></ul> | `014_Chapter2.rb:315-345`, called at `014_Chapter2.rb:700` | "E3:" ×2; smoke "...and Mishann brings Reptin the golden acorn" |
| E4 / T4: the Council can sit after Kendrick is dead | <ul><li>`council_sitting?` is true only the morning after the draw, before you reach Termalaine or Lonelywood.</li><li>Later, the clerk tells you that you missed it.</li></ul> | `045_TenTowns.rb:401`; clerk lines `045_TenTowns.rb:120-125` | "E4:" ×2 |
| E5 / BM16: Oarus talks after the grell kills him | <ul><li>Oarus has a "gone" page on switch 4066.</li><li>Shaelen gets a grief variant when `:oarus_dead` is set.</li></ul> | `tools/build_tentowns.rb:573-574`; `045_Termalaine.rb:106` | "E5:" ×2 |
| E6 / K15: three accounts of Sephek's victims | Everyone now gives the book's version:<ul><li>Naerth: "pay to keep their names off the board".</li><li>The lantern mother's sister paid the clerk to leave her name off the board, and was found frozen.</li></ul> | `007_Story.rb:310`; `006_Dialogue.rb:101` | "E6:" ×2 |
| E7 / C77, C79: the cub is never at risk; the lunge comes after the fight | <ul><li>**Stray harm:** the Heart's grey wave can hurt the chained cub (`state[:cub_hurt]`). The locket shields it.</li><li>**Mid-fight lunge:** when her last Pokémon drops below 25% HP, she lunges for the cub inside the battle (`hag_cornered?` / `hag_lunge_in_battle`).</li><li>**Four outcomes, each with a battle effect:**<ul><li>Shield the cub: your lead Pokémon takes 1/8 damage.</li><li>Smash the staff: her evasion is reset.</li><li>Tear the chains: the cub is freed.</li><li>Hold still: see A10.</li></ul></li><li>**Owner decision:** no lunge outcome ends the act. Holding still with no help means Reptin's wolf turns the knife. The cub is cut (`:cub_wounded`, a scar line, half HP if you take it), and the story goes on.</li><li>The old after-battle `hag_lunge` stays as a fallback for when she is KO'd before cornering.</li></ul> | `044_ChasmFaithful.rb:486-640`, `648` (fallback), `774-795` (aftermath) | seven "E7:"/"A10:" checks; try_w1_act1 "holding still without help..." |
| E8 / TG14: Garret can be rescued before Keegan asks | If Garret is already found, `keegan_after_garret` plays instead of the hiring speech:<ul><li>the reunion if Garret is with you, or the "he's asleep by the fire" version if you sent him home;</li><li>then Keegan asks you back up for the other three.</li></ul> | `045_MountainClimb.rb:176, 211-238` | "E8:" |
| E9 / K12: Hlin hires you for a man you've frozen | If you first meet Hlin after the Moon Temple, she says she has heard ("Seems I'm late") and pays straight away. | `044_ChasmFaithful.rb:1022-1029` | "E9:" |
| E10 / DH1: Dougan's Hole folk and the pier | <ul><li>The chorus lines now mention the misshapen ears and the pointed teeth.</li><li>New pier sign: the buckled pier and the two keelboats locked in the ice.</li></ul> | `022_Chapter4.rb:203-209`; `tools/build_ch4.rb:233` | "DH1:" ×2 |
| E10 / DH10: the blizzard crossing | <ul><li>Koran and Kanan shield the party when you follow them, then lope ahead.</li><li>Without them, the wind costs 10% HP.</li></ul> | `045_HoledUp.rb:142-160` | "DH10:" ×2 |
| E11 / K6: Torrga's four drivers | <ul><li>Three more Torg's hands stand in the camp: Oska, Corran and Skeld, plus Brannig. Each has a team and an intro.</li><li>Confronting her is now three battles: a double (Oska and Corran), then Skeld, then a double (Torrga and Brannig).</li></ul> | `044_ChasmFaithful.rb:79-97, 1131-1145`; `tools/build_ch3.rb:173-178` | "K6:" ×2 |
| E11 / K13: Torrga's grudge | <ul><li>If Sephek is frozen and Torrga isn't beaten, she tells you the lakes listen to her (`:torrga_grudge`).</li><li>Shops in Lonelywood, Termalaine and Good Mead refuse to sell to you (`torrga_refuses?`, hooked into `mart`).</li><li>Beating her ends the grudge.</li></ul> | `044_ChasmFaithful.rb:1119-1124, 1186-1210`; `007_Story.rb:76` | "K13:" ×4 |
| E12 / MM2: Fef's fox never leaves; Fef resells it | <ul><li>The fox's hide page now reads `SW_GM_FOX_BOUGHT` (4076), the switch the purchase sets.</li><li>Fef never offers it again once it's bought or gone with the chwinga.</li></ul> | `tools/build_tentowns.rb:1093-1096`; `045_MeadMustFlow.rb:183` | "E12:" ×2 |
| E13: Meat Meat's pronoun | "drawing herself up to her full height" | `045_WhiteMoose.rb:398` | "E13:" |
| E14 / TG7, TM6: Targos to Termalaine | New map **2101, Maer Dualdon Shore Road**:<ul><li>The book's four-hour shore walk, with a sign, an ice fisher and two trainers (Edda, Dov).</li><li>**Targos side:** the east gate is drifted shut (a rock tile with the old "buried in drifts" text) until Bryn Shander's seal (switch 3913), then opens onto the road.</li><li>**Termalaine side:** a south-west road back.</li></ul> | `tools/build_tentowns.rb:535, 568, 596-636`; encounters, trainers and texts in `045_TenTowns.rb:28-40, 88-99` | five "E14:" walking checks: blocked before the seal, then Targos → road → Termalaine → road → Targos |
| E14 / EH1, EH2: Easthaven | **Not changed.** The book makes it optional and the campaign never went there; the audit says it's harmless. | - | - |
| E15 / LW4: Iriskree | <ul><li>An introduction.</li><li>Her fond words for the dead, rotating through three sets.</li><li>Shade notices that she "stands like someone who's killed people for money".</li><li>Then her shop.</li></ul> | `015_Chapter3.rb:416-440`; `tools/build_ch3.rb` (event script) | "LW4:" |
| E15 / LW2 | The town sign now mentions the Sembian founders and the chimera post. | `015_Chapter3.rb:148` | "LW2:" |
| E15 / GM1 | Good Mead's arrival line mentions the dinosaur and serpent carvings, and its Chult and Vilhon founders. | `022_Chapter4.rb:409-410` | "GM1:" |
| E15 / FM8 | Izobai's two potions of animal friendship (two Friend Balls). | `045_FoamingMugs.rb:182` | "FM8:" |
| E15 / BM15 | After the fight you can grab the slower kobold, who gives the book's four lines about Trex. | `045_Termalaine.rb:403-430` | "BM15:" |
| E15 / TG10, TG19, T7 | **Not changed**, per the audit:<ul><li>TG10: Caer-Konig isn't in the game.</li><li>TG19: Yetot is a sensible adaptation.</li><li>T7: the book uses one starting quest.</li></ul> | - | - |
| E16: chasm whisper 3 behind you | Moved its trigger row to y 26, ahead of where you arrive. | `tools/build_ch5.rb:180` | "E16: whisper 3..." |
| E16: cancel picks the wrong option | Both chasm menus now pass `opts.size`. | `023_Chapter5.rb:435, 800` | "E16: the cancel key..." |
| E16: cancelling at the Gate insults it | Cancelling either bowl now means "You step back from the bowls". | `023_Chapter5.rb:618-622` | "E16: cancelling at the Gate..." (real `guardian_gate`, with `pbMessage` returning -1) |
| E16: Hruna's text promises a return | "You don't see them again." | `045_FoamingMugs.rb:102` | "E16: Hruna's refusal..." |
| E16: Koran's "trots after him" | The line is skipped once `:refused_wolves` is set. | `045_HoledUp.rb:109` | "E16: once both wolves are revealed..." |
| E16: reused names (Pell, Rhosk; owner decision) | Every Act I trainer who shared a name with a different person now has a distinct name:<ul><li>Bryn Shander guards Garvin and Haskel (were Pell and Rhosk)</li><li>bug catcher Nettle (was Pell)</li><li>Torg's hand Corran</li><li>shore hunter Edda</li><li>tundra hauler Gunnar</li><li>Auril cultist Vesna</li><li>moose hunter Halvard</li><li>Black Network thug Brosk</li><li>wolf hunter Orrin</li><li>Termalaine officer Stennis</li></ul>Iriskree's dead friend is Corvin Tull. | `014`, `015`, `016_TrainerLines`, `022`, `044`, `045_TenTowns`, `045_Termalaine`, `045_MountainClimb`, `045_WhiteMoose` | "E16: no Act I trainer shares a name with a different person" (scans every trainer table); "...Garvin and Haskel" |
| E16: dead code | <ul><li>Removed `scene_verbeeg_lair_outside`.</li><li>The captured thug now waits in the cooperage on switch 4006 (synced in `apply_w1_switches`) with his `gm_thug_after` line.</li><li>Elza thanks you once after Foaming Mugs (`elza_after_mugs`).</li></ul> | `tools/build_tentowns.rb:1118-1121`; `044_ChasmFaithful.rb:1210`; `045_TenTowns.rb:259-260` | "E16: the exposed thug...", "...his lines", "E16: Elza thanks you..." |

## Reaudit A (the Chasm side)

| Item | What I did | Where | Test |
|---|---|---|---|
| A1: the sanctum before the Gate | <ul><li>`hollow_wall` won't open until `:gate_open`.</li><li>The locket warms as a hint.</li></ul> | `023_Chapter5.rb:662-671` | "A1:" |
| A4: Reptin fights at the Heart | In round 2 of the minions fight, Reptin's wolf goes for Kanan (1/6 of his HP, `:reptin_fought_kanan`). | `044_ChasmFaithful.rb:458-469` | "A4:" |
| A9: the ghost's warning on the bridge | <ul><li>She points up first.</li><li>You throw yourself flat.</li><li>The ice lands where you were standing.</li></ul> | `023_Chapter5.rb:550-569` | "A9:" |
| A10: the ghost catching the knife was unreachable | The "hold still" choice now reaches both the locket (`:locket_caught_wrist`) and the ghost (`:ghost_caught_knife`), alone or together. | `044_ChasmFaithful.rb:590-611` | "A10:" ×2 |
| A14: hardcoded "SHADE:" lines | Wrapped in `as(:shade, ...)`. | `023_Chapter5.rb:423, 529` | "A14:" |
| A15: where you wake after the nightmare | You wake by the fissure only if you camped there (`:camp_disturbed`); otherwise "a long way from the chasm". | `044_ChasmFaithful.rb:752-759` | "A15:" |
| A18: the cub-dies ending loops | **Kept, per the owner decision.** It is reached only by "...Do it." plus the confirmation "Let her kill the cub? There is no taking this back." (`023_Chapter5.rb:955-959`). No lunge outcome reaches it. | `044_ChasmFaithful.rb:738` | try_w1_act1 (the bargain path loops; holding still doesn't) |
| A19: the TPK ending | **Kept** (the audit: "reasonable"). Ordinary losses are a nightmare and a retry (see A15). The witch-queen plays only after the bargain. | `044_ChasmFaithful.rb:752` | try_w1_act1 "witch-queen" |
| also in F1's files: A21, A23, A28, A29, A30, A32 | <ul><li>**A21:** the new-moon cackling and the town's plea (Mag, Durmoot).</li><li>**A23:** the locket's warmth.</li><li>**A28:** you can tell the ghost "We thought about letting her do it", and she absolves you and urges the light.</li><li>**A29:** `:order_wardens` is read in the epilogue glimpse (a new Order at the chasm mouth).</li><li>**A30:** the staff "goes hungry in the deep cold".</li><li>**A32:** Reptin's words over her resting place (`:warden_honoured`), "forsake your curse", and "Don't take another step!"</li></ul> | `022_Chapter4.rb:196, 631`; `023_Chapter5.rb:192, 203, 289, 797-819, 845`; `044_ChasmFaithful.rb:44, 812-817, 872` | "A19:", "A21:", "A23:", "A28:", "A29:", "A30:", "A32:" |
| A26, A27 | **Not mine:** these fixes land in `026_Rootspire.rb`, so they go to F2. | - | - |

## Flags and switches for other fixers

- **For F4 (A3, Reptin's vow payoff in Ch13):**
  - `:reptin_warden_vow` (`044:829`): he swears to come back for the Heart.
  - `:reptin_wolf_calm` (`044:811`).
  - `:warden_honoured`: he spoke over the warden's resting place.
  - `:order_wardens` (`023:769`).
  - `:reptin_fought_kanan`.
  - `:reptin_wolf_surged`: his wolf turned the knife at the lunge.
  - `:cub_wounded`: the cub's scar, which can carry to later reunions.
- **Other new flags:**
  - lunge: `:lunge_in_battle`, `:lunge_aftermath_said`, `:locket_caught_wrist`, `:ghost_caught_knife`
  - Torrga: `:torrga_grudge`, `:torrga_grudge_said`, `:torrga_grudge_felt`
  - quests and towns: `:kobold_questioned`, `:termalaine_arrived`
  - one-time lines: `:met_iriskree`, `:iriskree_noticed`, `:elza_thanked`
  - state and counters: `state[:cub_hurt]`, counter `:iriskree_talks`
- **Switch 4006** (W1 range): the captured thug in the cooperage.
- **New map 2101** (`lakeshore_road`).

## For the merge
- **Shared files touched:**
  - `039_Chapter13.rb` `start_loop`, `LOOP_KEEP_STATE` and `LOOP_KEEP_COUNTERS` (F4's file; the brief gives F1 this one function).
  - `040_Loop.rb` (F4's file): a minimal edit, so `loop_snapshot` also stores state and counters and the new `loop_skip_state` restores them.
  - `007_Story.rb` `mart`: a one-line hook at the top.
  - `tests/smoke_test.rb`: one check changed, one added.
  - `tools/headless/try_w1_act1.rb`.
- **Targos (2001) is patched in `tools/build_tentowns.rb`:**
  - it clears x 44-47, y 26-27;
  - it adds the drift and warp events.
  - So `build_tentowns.rb` must run after `build_act1.rb`, which `build_all.sh` already does.
- **Moved text:** `targos_termalaine_road` moved from `006_Dialogue.rb` to `045_TenTowns.rb`.
- **Still duplicated, outside F1's files:** "Pell" is both `scholar_pell` (`026_Rootspire.rb`, F2) and `guild_worker_pell` (`033_Chapter7B.rb`, F3). The owner's "three Pells" rule wants one of them renamed. I left it to the file owners to avoid a conflict. try_f1's name check covers Act I trainers only.
