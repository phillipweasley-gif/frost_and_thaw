# Brief: the whole-game read (0.8.1)

Every part of Frost & Thaw has been through three passes: a review (`docs/review/notes`, `dialogue`, `story`), a
context pass (`docs/review/context`) and a scene pass (`docs/review/scene`). Each was built and checked one act at a
time, by nine different builders. Nobody has yet read the game **end to end**. This read does that.

You are a **reviewer**, not a builder: change no game code, maps or tests. Write findings that a builder can act
on without asking you anything.

## What you read

- The game as it plays now: `docs/review/scene/traces_080/` (`journey.txt` (New Journey, the Third Way),
  `journey_shatter.txt`, `journey_still_keeper.txt`, `herald_alberica.txt`, `herald_reptin.txt`, `herald_wyn.txt`,
  `herald_meat_meat.txt`). Each line is what the player saw: `[msg]`, `[pick]`, `[ask]`, `[flag]`, `[stage]`,
  `[bgm]`, `[offstage]`, `[map]`, `[battle]`. Grep for a line to find its code in
  `game/Data/Scripts/998_FrostThaw/`.
- The canon: `docs/story/story_bible.md` (both "Owner's decisions" lists win over everything else),
  `docs/story/voices.md`, `docs/WRITING_GUIDE.md`, `docs/review/context/DECISIONS_ACT23.md`.
- Earlier findings, so you don't repeat what's known: the audits in `docs/review/context/` and
  `docs/review/scene/`.

## If you need to play something

Test copies `/home/claude/pifrun_X` exist; sync one first (`bash tools/sync_testgame.sh /home/claude/pifrun_X` from
`/home/claude/frost-thaw`) and run **from inside it** with `PIF_DIR` set. Runs share three slots: every trace goes
through `bash /tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/slot.sh <command>`. Driver
basics: `tools/headless/script_trace.rb`, `SCRIPT_TRACE=file`, `HL_MODE=journey|herald`, `HL_HERALD=…`
(`HL_STARTER=1` for Wyn and Meat Meat), `HL_PICK='prompt regex=>option regex'`. The driver loses some battles; a
missed beat after a lost battle, or "couldn't reach X (moved_away)", is the driver (map 2072's two gates are known
driver misses). Name scratch files with your letter as a prefix. Use the copy your task names.

## How to write findings

One file, `docs/review/whole/<YOURS>.md`: a two-line summary, then a table, most severe first:

| # | Severity | Where (trace file:line, and code file:line) | What's wrong | Why it matters | Fix (concrete) |

Severity: **Block** (the game can't be finished, or a mode breaks), **High** (a player would notice and be
confused or pulled out: a contradiction, a wrong name, a voice break, a dangling thread), **Medium**, **Low**.
Quote the line. Say which modes it affects. A fix names the file and what to change, in the scene's voice. Under 60
findings; merge duplicates. End with "Checked and fine": a one-line list of what you checked and found clean.
