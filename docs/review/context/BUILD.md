# Brief: build the context fixes into the game (one worktree per builder)

The context pass (`docs/review/context/NN.md`, brief in `BRIEF.md`) found where the game assumes the player knows
things it never showed, and wrote the fixes as playable beats. You build them, for your chapters, in your own git
worktree and test copy, then hand back a branch.

## Your setup

- Worktree: `/home/claude/ft_X` (branch `context_X`), already at the current `main`. Work and commit **only** there.
- Test copy: `/home/claude/pifrun_X`. Sync your worktree into it with `bash tools/sync_testgame.sh /home/claude/pifrun_X`
  (run from your worktree root). Never touch `/home/claude/pifrun` or another builder's copy or worktree.
- Commit with `git -c user.name="Phillip Weasley" -c user.email="phillip.weasley@gmail.com" commit`, and end each
  message with:
  `Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>` and
  `Claude-Session: https://claude.ai/code/session_01QGLuppdMkLtrZrpfouuEnr` (two lines). Don't push, don't merge.
- Never use `pkill`. Kill only processes you started, by PID.

## What to build

Your chapters' files in `docs/review/context/`. Build, in this order:

1. Every **High** gap's fix in §2 (scene by scene), and the §7 priority list.
2. Every **missing scene / beat** in §3 that the writer marked (a) or (b): build it as written, adjusting only to
   make it work in the code (speaker tags, the box rules, staging that exists in `043_Stage.rb`).
3. §4 (words used before they're explained) and §5 (bridges).
4. §6 Herald Mode fixes for your chapters.
5. Medium and Low gaps, as time allows. Say in your report which you skipped.

Also read your chapters' `docs/review/dialogue/NN.md` §3 "lines that don't follow" and fix those lines in the same
places, since they are the same complaint ("doesn't make sense"). Don't take on the rest of the dialogue notes yet.

## How

- Read the code around each change before editing (`scene_*` methods, `say`, `sayc`, `cl` / `as` / `speak` for
  companions and Herald Mode, `journey?`, `herald?(key)`, flags with `set_flag` / `flag?`). Follow the patterns
  already there. New flags that Act I sets go in `041_LoopFlags.rb`'s fallback lists (see the end of that file).
- Box rules (WRITING_GUIDE §2): about 90 characters per box including `NAME: `; no more than three boxes in a row
  from one speaker; no run over 25 boxes without an input. Speakers who talk must be on screen: companions now walk
  in by themselves when they speak (`Stage.summon`, via `say`); anyone else needs `Stage.actor` / `Stage.approach`
  or an existing event (WRITING_GUIDE §9a).
- Herald Mode: every line that names "you" or a Herald must read correctly when the player *is* that Herald
  (`as(:key, ...)`, `cl(:key, ...)`, `speak(:key, a, b)`); New Journey-only beats go under `journey?`.
- Keep the owner's decisions (2026-11-05): the player's own goal (the lantern glass, `lantern_glass_reading`,
  `last_mirror_choice`, `their_time_beat`), "Summer is Avarice" kept for Chapter 8, the White Vault postgame,
  the Ten-Towns favours. Keep the good lines the dialogue review says to protect.
- Don't change files outside your chapters' scenes unless a fix needs it; if you must touch a shared file
  (`007_Story.rb`, `043_Stage.rb`, `006_Dialogue.rb`), keep the change small and say so in your report.

## Check your work (all of it, before you hand back)

1. `ruby -c` on every file you changed.
2. `ruby tests/smoke_test.rb /home/claude/pifrun_X` after syncing: all checks pass.
3. Re-record your chapters as played, and read the result:
   `cd /home/claude/pifrun_X && STOP_AT=<your last chapter> SCRIPT_TRACE=<scratch>/trace_X.txt HL_MODE=journey ruby /home/claude/ft_X/tools/headless/script_trace.rb`
   (STOP_AT=N stops before chapter N+1; omit chapters before yours by reading only your part of the log). Grep
   the log for every new line you added: each must appear, in the right order, with no `[offstage]` for a
   speaker who should be there. Also run one Herald Mode pass for Act I
   (`HL_MODE=herald HL_HERALD="Alberica"`, and `"Meat Meat"` or another Herald your fixes touch).
4. Box lengths: no new box over 90 characters (check with a script over your diff).

## Hand back

A short report (under 300 words): the commits on your branch, what you built (by gap number / scene), what you
skipped and why, anything in a shared file, and the check results (smoke test, which new lines you saw play).
