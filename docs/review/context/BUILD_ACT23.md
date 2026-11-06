# Brief: build the Act II–III context fixes (one worktree per builder)

Read `docs/review/context/BUILD.md` first: it is your brief (what to build, in what order, how, checks, hand-back).
What differs for you:

## Your setup

- Worktree `/home/claude/ft_X` (branch `context2_X`), test copy `/home/claude/pifrun_X`. Sync from your worktree
  root: `bash tools/sync_testgame.sh /home/claude/pifrun_X` (it now breaks hard links before writing, so it can't
  write into anyone else's copy). Run every test **from inside your test copy** (`cd /home/claude/pifrun_X`) and
  also pass `PIF_DIR=/home/claude/pifrun_X`; never run anything in `/home/claude/pifrun` or another builder's copy.
- `STOP_AT=N` stops before chapter N+1 (it can't stop inside Act I's chapter 1). A full run is about 3 minutes.
- **Maps:** you may change `tools/build_*.rb` and run `bash tools/build_all.sh` to rebuild, but **don't commit
  `build/maps/`**: binary maps conflict between builders. Main rebuilds them after the merge. Do commit the
  `tools/build_*.rb` change and say which maps it touches.

## What to build

- Your parts' `docs/review/context/NN.md` (§2 High gaps and §7, §3 missing scenes marked (a) or (b), §4, §5, §6,
  §8 secrets, then Medium and Low as time allows), and your parts' `docs/review/dialogue/NN.md` §3 "lines that
  don't follow".
- **The owner's decisions in `docs/review/context/DECISIONS_ACT23.md`** override any option a writer left open.
  Where a writer marked "owner question", the decision file has the answer; if it doesn't, build the writer's
  recommended option and say so in your report.
- Some writers put fixes in another part's code (e.g. 08.md wants Var's portrait in Chapter 6). **Build every fix
  that lands in your files**, from any NN.md: grep all of `docs/review/context/0[6-9].md` and `1[0-5].md` for your
  files' names and scene numbers. Don't edit another builder's files; if a fix of yours needs one, say so in your
  report and I'll do it after the merge.
- Herald Mode: use `as`, `cl`, `speak`, `outsider?` (New Journey or Wyn) and `my_glass`. A Herald's own stage
  directions now read "your" through `as` (under your breath, your own); check the rest by reading your Herald
  traces.

## Your files

- **d (06, 07):** 024_Chapter6.rb, 025_Chapter7.rb, 032_Chapter7A.rb, 033_Chapter7B.rb, 026_Rootspire.rb,
  028_Heartroot.rb, tools/build_ch6*.rb / build_ch7*.rb / build_rootspire*.rb.
- **e (08, 09):** 034_Chapter8.rb, 035_Chapter9.rb, 046_DeepLabyrinth.rb, 046_ForgeRooms.rb, their map builders.
- **f (10, 11):** 036_Chapter10.rb, 047b_TrialWeek.rb, 037_Chapter11.rb, 047a_Undercanopy.rb, their map builders.
  Iskra: also make her big (she's Auril's roc; the sprite reads as a small Articuno).
- **g (12, 13):** 038_Chapter12.rb, 039_Chapter13.rb, 047c_WhiteVault.rb, 040_Loop.rb, 027_Relics.rb (the Vault
  key items), and the Ch5 ghost's story in 023_Chapter5.rb (decision 6 only), plus their map builders.
- **h (14, 15):** 045_*.rb (Ten-Towns side quests and 045z_TownFavours.rb), 048_Rootspire_*.rb, 047d_FixRound.rb,
  006_Dialogue.rb (party chat) and their map builders. Duvessa's favours announcement sits in 014_Chapter2.rb: you
  own that one scene.
- Shared (`007_Story.rb`, `043_Stage.rb`, `041_LoopFlags.rb`, `031_StoryItems.rb`, `005_NewGame.rb`): small
  changes only, said in your report. New flags go in a new block at the end of `041_LoopFlags.rb` headed with your
  letter.

## Checks

As in BUILD.md, with full-game traces (no STOP_AT) in New Journey and as Alberica, Reptin and Wyn, plus Meat Meat if
your fixes touch her. Grep for every new line; no `[offstage]` for a speaker who should be on screen; no new box
over 90 characters; `ruby tests/smoke_test.rb /home/claude/pifrun_X` all pass. Report as BUILD.md says (under 300
words). Save and commit as you go, so a usage limit doesn't lose the work.
