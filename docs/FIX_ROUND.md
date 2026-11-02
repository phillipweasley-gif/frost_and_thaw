# Fix round after the re-audit (Nov 2026)

The five re-audits are in docs/reaudit/ (A, B, C, D, E; BRIEF.md has the owner decisions). Every row that is not
Full, and every bug, gets fixed - built to the source's level, not patched over. Owner rule: no shortcuts.

## Decisions for this round
- Follow the notes wherever a re-audit marks something "Changed" that is neither an owner decision nor clearly
  the campaign's own rewrite (e.g. B1's Canticle, M2's twin mirrors, GQ3 Cycle Day, the Ledger break-in, the
  election's run/neutral options, GQ2's sanctify-for-blessing).
- The dark ending (C84): only deliberately accepting the hag's bargain ("...Do it.", with a confirmation) leads to
  the loop. Failing at the cub's lunge must not end the act: the cub is hurt (and the consequences carry), and
  the story continues.
- Keep Shade's face in the WAIT picture (A16): at Ch5 Frostina is Shimmer's answer to Shade.
- Three NPCs named Pell, and reused "Rhosk": give each a distinct name.
- The cross-worker flag contract in docs/BUILD_OUT.md still holds; add any new shared flags to your fixes doc.

## Who fixes what (a row goes to the owner of the file where the fix lands; minimal edits elsewhere are fine)
- F1 Act I (014-017, 022, 023, 044, 045_*, 006/007 Act I lines, build_act1/ch2/ch3/ch4/ch5/tentowns, and the
  loop reset in 039 start_loop): ALL of reaudit E; reaudit A items 1, 4, 9, 10, 14, 15, 18, 19; Reptin's vow
  payoff from A item 3 goes to F4 (Ch13) but F1 records the flags.
- F2 Rootspire & Ch6 (024, 026, 027, 029, 048_*, build_ch6/6b/rootspire_life): reaudit A items 2 (Glimmer's
  journal payoff), 6, 7, 8 (omens; the Whisper side is F4's), 11, 12, 13; ALL of reaudit B except Mira (F3),
  Hew's gift (F3) and Sephek's motives (F4); reaudit C items B1, B2, B4, B11 (Brightmane "she", Alerion's
  potion lock), C2, C6, C7, P3, P4, P5; reaudit D items 9 (GQ3) and 13 (B1 Canticle - and fix Ch13's "three
  verses" lines to match, minimal edit in 039).
- F3 Labyrinth/Forge/Ch7B-9 (025, 027 slide fix, 028, 033, 034, 035, 046_*, build_ch7/7b/7_deep/8/8_deep/9):
  reaudit C items B3, B5, B6, B7, B8, B9, B10, B11 (Frostfire Flask as evidence -> coordinate with F4, dragon
  eyes), C1, C3, C5, P1, P2; reaudit B: Mira (contradiction B4, Mira left possessed), Hew's gift, B6 (Still Sky
  blessing vs the H7 slide); reaudit D items 12 (M2) and 14 (GQ2); the Ledger break-in from D item 10 is F4's,
  so remove or rework the free Forge pickup in agreement with F4 (F4 decides; F3 removes the pickup).
- F4 Ch7A, Ch10-13, White Vault (032, 036, 037, 038, 039, 040, 047*, build_ch7a/ch10/act3/w4): ALL of reaudit D
  except items 9, 12, 13, 14; reaudit A items 3 (Reptin's vow payoff) and 5 (Auril's Whisper, and reading
  :omens_seen); reaudit B: Sephek's motives, Darrus's redemption paying off (B2), favour_of boons/rivalries in the
  vote (B3); reaudit C item B11 (Frostfire Flask in the trial). A1 is duplicated between 048_D and 047b: F4
  merges them into one quest (edit 048_D minimally) and fixes the Mirror Maze soft-lock.

## Process
Worktree per fixer. Own test copy (tools/make_testgame.sh /home/claude/pifrun_<F>; tools/sync_testgame.sh).
Heavy runs under `flock /tmp/ft_heavy.lock`. Keep smoke + map checks green; add a check or a focused test for
every fix. Commit small and often, messages ending with the attribution lines. Finish with docs/fixes_<F>.md:
every assigned item -> what you did (file:line) -> the test that shows it. Nothing left open without an exact
reason.
