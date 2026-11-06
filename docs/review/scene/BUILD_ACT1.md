# Brief: the Act I scene pass (one worktree per builder)

The context pass made every Act I scene make sense to someone who's never seen the story. The scene pass makes
each scene **play well**: staged, paced, voiced, and read comfortably on a Pokémon text box. You fix what the
review found and the context pass left, in your chapters, in your own worktree and test copy, then hand back a
branch.

Read `docs/WRITING_GUIDE.md` first (all of it; the checks at the end are your test), then your parts'
`docs/review/notes/NN.md` and `docs/review/dialogue/NN.md`. `docs/review/context/NN.md` shows what the context
pass already built: don't redo it.

## Your setup

- Worktree `/home/claude/ft_X` (branch `scene_X`, at current `main`), test copy `/home/claude/pifrun_X`. Sync from
  your worktree root: `bash tools/sync_testgame.sh /home/claude/pifrun_X`. Run every test **from inside your test
  copy** (`cd /home/claude/pifrun_X`) with `PIF_DIR=/home/claude/pifrun_X`; never run anything in
  `/home/claude/pifrun` or another builder's copy.
- Commit with `git -c user.name="Phillip Weasley" -c user.email="phillip.weasley@gmail.com" commit`, each message
  ending with the two lines `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>` and
  `Claude-Session: https://claude.ai/code/session_01QGLuppdMkLtrZrpfouuEnr`. Don't push, don't merge, don't start
  sub-agents. Never use `pkill`; kill only processes you started, by PID. Commit as you go.
- **Maps:** you may change `tools/build_*.rb` and run `bash tools/build_all.sh`, but **don't commit `build/maps/`**;
  main rebuilds after the merge. Commit the builder change and say which maps it touches. `build_all.sh` checks
  every map; fix anything it flags in your maps.
- Headless runs: `tools/headless/script_trace.rb` (as-played log) with `STOP_AT=N` (stops before chapter N+1),
  `HL_MODE=journey|herald`, `HL_HERALD="Alberica"` etc. (Wyn and Meat Meat need `HL_STARTER=1`). The driver loses
  some battles at random; a missed beat after a lost battle is the driver, not you: rerun.

## What to build, in order

1. **Already fixed?** For every item below, first check the code and a fresh trace. Skip what the context pass or
   a later fix already did, and list those in your report in one line each.
2. **The two Top 5 lists:** `notes/NN.md` §4 and `dialogue/NN.md` §9.
3. **`notes/NN.md` §1 Editor:** staging and animation (people who talk on screen, walk up, react; WRITING_GUIDE
   §9a), structure and pacing, continuity, side-quest engagement, the sweep findings. Then §3 Dialogue.
4. **`dialogue/NN.md`:** §4 scene by scene, §5 line notes, §6 the old rewrites that are themselves a problem. Keep
   every line in §7 "Lines to protect", word for word. Voices follow `docs/story/voices.md` (§2 says where each
   one drifts).
5. **Scene checks (WRITING_GUIDE checks 46–50):** score each scene in your chapters by Mills's four questions.
   Anything under 8: fix with the review's suggestion, or your own, small, in the scene's voice. A big beat gets a
   sequel beat (reaction, dilemma, decision). The player gives an input on each scene's decisive beat.
6. **The box rules, for every box that plays in your chapters** (any mode): about 90 characters including
   `NAME: `; no more than three boxes in a row from one speaker; no run of more than 25 boxes without an input.
   Reword where a split would break a sentence; `docs/review/context/long_boxes_act1.txt` has the ones found at
   0.7.3. Count from your own traces, not the list.
7. **Music:** a scene whose mood changes gets a cue (`pbBGMPlay`, `Stage.theme`) where the notes ask for one.

Art: don't wait for it. If a fix needs art that isn't there, use a stand-in and list the request in your report
(the owner's art list is in a doc; I'll add yours to it).

Owner's decisions stand (`docs/story/story_bible.md`, "Owner's decisions"): Wyn shares the player's goal; the
Order's dagger breaks the last mirror; Auril marks the outsider after the last-mirror choice; Iskra is a roc;
Ironhollow is Alberica's village; "Summer is Avarice" stays a Chapter 8 twist.

## Your files

- **a (00 prologue, 01 Targos):** 030_Prologue.rb, 005_NewGame.rb (the openings), 007_Story.rb (Ch1 scenes),
  017_TargosExtras.rb, 016_TrainerLines.rb, 006_Dialogue.rb (the Targos/tavern lines), tools/build_prologue.rb,
  build_targos.rb, build_act1.rb.
- **b (02 Bryn Shander, 03 Lonelywood):** 014_Chapter2.rb, 015_Chapter3.rb, tools/build_ch2.rb, build_ch3.rb.
- **c (04 the Eastway and Dougan's Hole, 05 the Chasm):** 022_Chapter4.rb, 023_Chapter5.rb, 044_ChasmFaithful.rb,
  045_HoledUp.rb (Koran's five boxes), tools/build_ch4.rb, build_ch5.rb. Also the **balance** of three fights a
  two-Pokémon team loses: Ranger Hadd on the Eastway, the Good Mead fight, the Frozen Rift walker (Culie). Keep them
  a challenge for a full team.
- **h (14, Act I's side quests):** 045_FoamingMugs, 045_MountainClimb, 045_MeadMustFlow, 045_Termalaine,
  045_WhiteMoose, 045_TenTowns, 045z_TownFavours, tools/build_tentowns.rb. The reworks the context pass skipped
  (Keegan's clock, Korux, Marta, the Prompters), `notes/14.md` E13 (rewards that promise what the game doesn't
  do), and E20 (swap the yetis' Ursaring stand-ins for the Yetot and Yetitan followers that exist).
- Shared (`007_Story.rb` outside Ch1, `043_Stage.rb`, `041_LoopFlags.rb`, `031_StoryItems.rb`): small changes only,
  said in your report. New flags go in a new block at the end of `041_LoopFlags.rb` headed `scene <letter>`.
  A fix that needs another builder's file: don't make it; list it in your report.

## Checks (all of them, before you hand back)

1. `ruby -c` on every changed file; `ruby tests/smoke_test.rb /home/claude/pifrun_X` all pass.
2. Act I traces (`STOP_AT=5`) in New Journey and as Alberica, Reptin, Wyn and Meat Meat (h: also the side quests'
   own beats). Grep each for every line you added or changed: it plays, in order, with no `[offstage]` for a
   speaker who should be on screen.
3. No box over 90 characters, no four-in-a-row speaker, no 26-box run without input, in your chapters' parts of
   the traces (a script over the trace, not by eye).
4. Report (under 300 words): commits; what you built by note number; what was already done; what you skipped and
   why; art requests; shared-file changes; check results.
