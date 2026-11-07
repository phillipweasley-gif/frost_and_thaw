# Brief: the Act III scene pass (one worktree per builder)

Same job as the Act I and Act II scene passes (`BUILD_ACT1.md`, `BUILD_ACT2.md`: read both; the method, rules and
checks are the same), now for Chapters 12–13, the endings, the epilogue and the White Vault. The context pass made
every scene make sense; this pass makes each scene **play well**: staged, paced, voiced, and read comfortably on a
Pokémon text box.

Read `docs/WRITING_GUIDE.md` first (all of it; the checks at the end are your test), then your parts'
`docs/review/notes/NN.md`, `docs/review/dialogue/NN.md` and `docs/review/story/NN.md`.
`docs/review/context/NN.md` (and `AUDIT_ACT23.md`) show what the context pass already built: don't redo it.
`docs/review/scene/AUDIT_ACT2.md` shows how Act II was audited.

## Your setup

- Worktree `/home/claude/ft_X` (branch `scene3_X`, at current `main`), test copy `/home/claude/pifrun_X`. Sync from
  your worktree root: `bash tools/sync_testgame.sh /home/claude/pifrun_X`. Run every test **from inside your test
  copy** (`cd /home/claude/pifrun_X`) with `PIF_DIR=/home/claude/pifrun_X`; never run anything in another copy.
- **Traces share three slots** (the box runs out of memory at five): run every trace through
  `bash /tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/slot.sh <command>`.
  Scratch files in that shared scratchpad start with your letter (`i_`, `j_`).
- Commit with `git -c user.name="Phillip Weasley" -c user.email="phillip.weasley@gmail.com" commit`, each message
  ending with the two lines `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>` and
  `Claude-Session: https://claude.ai/code/session_01QGLuppdMkLtrZrpfouuEnr`. Don't push, don't merge, don't start
  sub-agents. Never use `pkill`; kill only processes you started, by PID. Commit as you go.
- **Maps:** you may change `tools/build_*.rb` and run `bash tools/build_all.sh`, but **don't commit `build/maps/`**;
  main rebuilds after the merge. Say which maps your builder changes touch. `ruby tools/check_all.rb` must pass.
- Headless runs: `tools/headless/script_trace.rb` (`SCRIPT_TRACE=file`), `HL_MODE=journey|herald`,
  `HL_HERALD="Alberica"` etc. (Wyn and Meat Meat need `HL_STARTER=1`). Act III needs full games (about 4 minutes).
  `HL_PICK='prompt regex=>option regex'` makes the driver pick an option, to trace a branch (an ending, a test).
  A missed beat after a lost battle, or "couldn't reach X (moved_away)", is the driver: rerun.
- **Art is on hold.** The designer has put every new draft on hold until it is checked against the owner's
  reference sheets. Stage scenes with the sprites already in `build/gfx` (`docs/review/ART_IN.md`) and base-game
  stand-ins; **don't add any file from the designer's folder.** Missing art: stand in, and list the request in
  your report (check `docs/review/scene/AUDIT_ACT2.md` and Art List 2 first so you don't repeat one). Stage tools in
  `043_Stage.rb`: `actor`, `herald`, `walk_to`, `approach`, `turn_to`, `emote`, `pose`/`unpose`/`release`,
  `battle_pose`, `panel`, `overlay`, `fx`, `pan_to`/`pan_back`, `theme`.

## What to build, in order

1. **Already fixed?** For every item below, check the code and a fresh trace first. Skip what's done; list those
   in one line each.
2. **The Top 5 lists:** `notes/NN.md` §4, `dialogue/NN.md` §7, and `story/NN.md`'s verdicts.
3. **`notes/NN.md` §1 Editor:** staging (every Herald who speaks is on screen; WRITING_GUIDE §9a), structure and
   pacing, where to go, continuity. Then §2 First-time player and §3 Dialogue.
4. **`dialogue/NN.md`:** §3 scene by scene, §4 line notes, §5 the old rewrites that are themselves a problem. Keep
   every line in §6 "Lines to protect", word for word. Voices follow `docs/story/voices.md`.
5. **Scene checks (WRITING_GUIDE checks 46–50):** score each scene by Mills's four questions; fix anything under 8,
   small and in the scene's voice. A big beat gets a sequel beat. The player gives an input on each decisive beat.
   **The endings** (Shatter, the Third Way, the Still Keeper loop) are the game's biggest payoffs: each must be
   staged, scored and traced (use `HL_PICK` for each).
6. **The box rules, for every box that plays in your chapters** (any mode): about 90 characters including
   `NAME: `; no more than three boxes in a row from one speaker; no run of more than 25 boxes without an input.
   Count from your own traces with a script, not by eye.
7. **Music:** a scene whose mood changes gets a cue where the notes ask for one.

Owner's decisions stand (`docs/story/story_bible.md`, both "Owner's decisions" lists, and
`docs/review/context/DECISIONS_ACT23.md`). Among them: Mira has black hair (white in the Vault); Meat Meat keeps her
Noibat (with Razzy's Blanket); Hellen keeps her current sprite; the Still Keeper is a trap that loops time until
you choose Shatter or the Third Way.

## Your files

- **i (12, the Sea of Moving Ice and the White Vault):** 038_Chapter12.rb, 047c_WhiteVault.rb (not the Ch11
  Shrine fight at its top, which is done), tools/build_w4.rb's White Vault, Mirror Circuits and Seraph Cradle maps (2168–2170).
- **j (13, Grimskalle, the endings, the epilogue):** 039_Chapter13.rb, 040_Loop.rb, tools/build_act3.rb.
- Shared (`007_Story.rb`, `043_Stage.rb`, `041_LoopFlags.rb`, `031_StoryItems.rb`, `005_NewGame.rb`,
  `004_Trainers.rb`): small changes only, said in your report. New flags go in a new block at the end of
  `041_LoopFlags.rb` headed `scene3 <letter>`. A fix that needs the other builder's file: don't make it; list it.
  Some notes put fixes in other parts' code (grep `docs/review/notes/1[1-3].md` and the dialogue files for your
  files' names and scene numbers): build every fix that lands in **your** files.

## Checks (all of them, before you hand back)

1. `ruby -c` on every changed file; `ruby tests/smoke_test.rb /home/claude/pifrun_X` all pass;
   `ruby tools/check_all.rb` passes after `bash tools/build_all.sh`.
2. Full-game traces in New Journey and as Alberica, Reptin, Wyn and Meat Meat. The story-beat counts must not drop
   below main's (New Journey 244/245; Alberica, Reptin and Meat Meat 236/237; Wyn 235/236). Grep each trace for
   every line you added or changed: it plays, in order, with no `[offstage]` for a speaker who should be on screen.
   Trace each ending at least once (`HL_PICK`).
3. No box over 90 characters, no four-in-a-row speaker, no 26-box run without input, in your chapters' parts of
   the traces (from `ch11_done` to the end), by a script.
4. Report (under 300 words): commits; what you built by note number; what was already done; what you skipped and
   why; art requests; shared-file changes; check results.
