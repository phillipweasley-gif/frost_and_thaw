# Brief: the Act II scene pass (one worktree per builder)

Same job as the Act I scene pass (`BUILD_ACT1.md`, read it: the method, rules and checks are the same), now for
Chapters 6–11 and Rootspire's side content (part 15). The context pass made every scene make sense; this pass
makes each scene **play well**: staged, paced, voiced, and read comfortably on a Pokémon text box.

Read `docs/WRITING_GUIDE.md` first (all of it; the checks at the end are your test), then your parts'
`docs/review/notes/NN.md` and `docs/review/dialogue/NN.md`. `docs/review/context/NN.md` (and `AUDIT_ACT23.md`)
show what the context pass already built: don't redo it.

## Your setup

- Worktree `/home/claude/ft_X` (branch `scene2_X`, at current `main`), test copy `/home/claude/pifrun_X`. Sync from
  your worktree root: `bash tools/sync_testgame.sh /home/claude/pifrun_X`. Run every test **from inside your test
  copy** (`cd /home/claude/pifrun_X`) with `PIF_DIR=/home/claude/pifrun_X`; never run anything in
  `/home/claude/pifrun` or another builder's copy.
- Commit with `git -c user.name="Phillip Weasley" -c user.email="phillip.weasley@gmail.com" commit`, each message
  ending with the two lines `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>` and
  `Claude-Session: https://claude.ai/code/session_01QGLuppdMkLtrZrpfouuEnr`. Don't push, don't merge, don't start
  sub-agents. Never use `pkill`; kill only processes you started, by PID. Commit as you go.
- **Maps:** you may change `tools/build_*.rb` and run `bash tools/build_all.sh`, but **don't commit `build/maps/`**;
  main rebuilds after the merge. Commit the builder change and say which maps it touches. `build_all.sh` and
  `ruby tools/check_all.rb` check every map; fix anything they flag in your maps.
- Headless runs: `tools/headless/script_trace.rb` (as-played log; `SCRIPT_TRACE=file`), `HL_MODE=journey|herald`,
  `HL_HERALD="Alberica"` etc. (Wyn and Meat Meat need `HL_STARTER=1`). `STOP_AT=N` stops before chapter N+1; for
  Act II run full games (about 3 minutes). `HL_PICK='prompt regex=>option regex'` makes the driver pick a
  particular option (e.g. `'What do you do=>^Fight'`) so you can trace a branch. The driver loses some battles at
  random; a missed beat after a lost battle, or "couldn't reach X (moved_away)", is the driver: rerun.
- **Art is in now.** Most of Act II's people have their own sprites (`build/gfx/Characters/FT_*`: the Speakers,
  Rheven and his direwolf, Kelyn, Eirwen, Eline, Selrae, the Halo brother and sister, Hew, Mira and possessed
  Mira, Darrus and his Corsair coat, Wynsnow, Talion, the Wennen, the Myconids, the duergar, Var's echo, Prototype
  3), and the bosses have battle pictures. Stage scenes around them (who stands where, who walks up, who turns).
  `docs/review/ART_IN.md` lists what's where. Stage tools in `043_Stage.rb`: `actor`, `herald`, `walk_to`,
  `approach`, `turn_to`, `emote`, `pose`/`unpose`/`release`, `battle_pose`, `panel`, `fx`, `pan_to`/`pan_back`,
  `theme`. Missing art: stand-in and list the request in your report.

## What to build, in order

1. **Already fixed?** For every item below, first check the code and a fresh trace. Skip what the context pass or
   a later fix already did; list those in your report in one line each.
2. **The two Top 5 lists:** `notes/NN.md` §4 and `dialogue/NN.md` §7.
3. **`notes/NN.md` §1 Editor:** staging and animation (people who talk on screen, walk up, react; WRITING_GUIDE
   §9a), structure and pacing, where to go, continuity, side-content engagement. Then §2 First-time player and §3
   Dialogue.
4. **`dialogue/NN.md`:** §3 scene by scene, §4 line notes (and §4b in 15.md), §5 the old rewrites that are
   themselves a problem. Keep every line in §6 "Lines to protect", word for word. Voices follow
   `docs/story/voices.md`.
5. **Scene checks (WRITING_GUIDE checks 46–50):** score each scene in your chapters by Mills's four questions.
   Anything under 8: fix with the review's suggestion, or your own, small, in the scene's voice. A big beat gets a
   sequel beat (reaction, dilemma, decision). The player gives an input on each scene's decisive beat.
6. **The box rules, for every box that plays in your chapters** (any mode): about 90 characters including
   `NAME: `; no more than three boxes in a row from one speaker; no run of more than 25 boxes without an input.
   Count from your own traces.
7. **Music:** a scene whose mood changes gets a cue (`pbBGMPlay`, `Stage.theme`) where the notes ask for one.

Owner's decisions stand (`docs/story/story_bible.md`, both "Owner's decisions" lists, and
`docs/review/context/DECISIONS_ACT23.md`). Among them: "Summer is Avarice" stays a Chapter 8 twist (nothing
before it gives it away); Ironhollow is Alberica's village; Mira has black hair; Meat Meat keeps her Noibat (with
Razzy's Blanket); Hellen keeps her current sprite.

## Your files

- **d (06, 07):** 024_Chapter6.rb, 025_Chapter7.rb, 032_Chapter7A.rb, 033_Chapter7B.rb, 026_Rootspire.rb,
  028_Heartroot.rb, 029_Glimmer.rb, tools/build_ch6.rb, build_ch6b.rb, build_ch7.rb, build_ch7a.rb, build_ch7b.rb,
  build_ch7_deep.rb.
- **e (08, 09):** 034_Chapter8.rb, 035_Chapter9.rb, 046_DeepLabyrinth.rb, 046_ForgeRooms.rb, tools/build_ch8*.rb,
  build_ch9.rb.
- **f (10, 11):** 036_Chapter10.rb, 047b_TrialWeek.rb, 037_Chapter11.rb, 047a_Undercanopy.rb, tools/build_ch10.rb.
- **h (15, Rootspire's side content):** 048_Rootspire_*.rb, 047d_FixRound.rb, 006_Dialogue.rb (party chat),
  tools/build_rootspire_life.rb.
- Shared (`007_Story.rb`, `043_Stage.rb`, `041_LoopFlags.rb`, `031_StoryItems.rb`, `005_NewGame.rb`, and
  `tools/build_w4.rb`, which adds the trial week's people to many maps): small
  changes only, said in your report. New flags go in a new block at the end of `041_LoopFlags.rb` headed
  `scene2 <letter>`. A fix that needs another builder's file: don't make it; list it in your report. Some notes put
  fixes in another part's code: build every fix that lands in **your** files, from any NN.md (grep
  `docs/review/notes/0[6-9].md`, `1[015].md` and the dialogue files for your files' names and scene numbers).

## Checks (all of them, before you hand back)

1. `ruby -c` on every changed file; `ruby tests/smoke_test.rb /home/claude/pifrun_X` all pass;
   `ruby tools/check_all.rb` passes after `bash tools/build_all.sh`.
2. Full-game traces in New Journey and as Alberica, Reptin, Wyn and Meat Meat (h: also your side quests' own
   beats; the traces' `OK` lines name them). The story-beat counts must not drop below main's (New Journey 244/245,
   Alberica and Reptin and Meat Meat 236/237, Wyn 235/236). Grep each trace for every line you added or changed:
   it plays, in order, with no `[offstage]` for a speaker who should be on screen.
3. No box over 90 characters, no four-in-a-row speaker, no 26-box run without input, in your chapters' parts of
   the traces (a script over the trace, not by eye).
4. Report (under 300 words): commits; what you built by note number; what was already done; what you skipped and
   why; art requests; shared-file changes; check results.
