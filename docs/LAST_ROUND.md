# Last fix round, from the final audit (docs/final_audit/A-E; BRIEF.md has every decision)

Fix EVERY bug and every Compressed / Missing row the final audits list, to the source's level. Owner rule: no
shortcuts. Changed rows the auditors judged acceptable (owner decisions, fix-round decisions, fair integration
choices) stay as they are unless the auditor gave a concrete fix.

Decisions for this round:
- Hooks and rumours that advertise content the campaign never visited (Easthaven's quests, Nature Spirits,
  Copper's Black Cabin): the campaign's route is the source of truth; reword them so they don't promise a quest,
  or point them at content that exists. Do not build Easthaven.
- Wyn is they/them everywhere.
- Destroying the Shard: keep "he comes back weaker" (a defensible reading); add one line that makes the
  consequence explicit to the player.
- Sephek's two stages stay two fights, but bring the notes' lair actions (Frost Nova, Frost Chains, Auroral
  Storm) into the Major Avatar fight as real effects, not only flavour.

## G1: Act I and the Chasm
ALL of final_audit/E_act1_published.md except its B8; final_audit/A_session_log.md items B6, B7, C111 (the
"wise survivor" line), C21 (the mimicking mephit), C93 (freeing the cub mid-fight), C105 (Alberica's journal
in the tomb). Files: 006/007 Act I lines, 014-017, 022, 023, 040_Loop (loop_skip), 044, 045_*,
build_act1/ch2/ch3/ch4/ch5/tentowns.

## G2: Rootspire, the Labyrinth and Forge, Chapters 7-13
ALL of final_audit/B_rootspire_tab1.md, C_rootspire_tab2_forge.md and D_rootspire_tabs3to8.md; plus
final_audit/A_session_log.md items B1, B2, B3, B4, B5 and its T4 / C39 / C73 notes where it gives a fix; plus
final_audit/E_act1_published.md item B8. Files: 024-039, 046-048_*, and their builders.

## Process
Worktree; own test copy (tools/make_testgame.sh /home/claude/pifrun_<G>; tools/sync_testgame.sh); heavy runs
under `flock /tmp/ft_heavy.lock`. Keep smoke + map checks green, and add a check or a focused test for every
fix. Commit small and often with the attribution lines. Finish with docs/last_<G>.md: every item -> what you
did (file:line) -> the test that shows it.
