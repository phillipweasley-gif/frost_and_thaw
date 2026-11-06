# Brief for the Act II–III context writers (0.7.3)

Read `docs/review/context/BRIEF.md` first: it is your brief, including the section "Added for Acts II and III".
What differs for you:

- **Your parts:** given in your assignment. Write `docs/review/context/NN.md` for each, in the same format as the
  Act I files 00–05 (read `03.md` as the model).
- **What plays:** the 0.7.3 runs in `docs/review/context/traces_073/`: `journey.txt` (New Journey, the whole game),
  `herald_alberica.txt`, `herald_wyn.txt` and `herald_reptin.txt` (Herald Mode). Same log format as the Act I log.
  Act I ends at `[flag] act1_done`. Use them, not the older `journey_log.txt`, to say what the player has seen before
  a given point (Act I now has the context fixes; don't re-report Act I gaps).
- **The as-played scripts** `docs/review/script/NN.md` are from before 0.7.3; check against the traces where they
  disagree.
- **Built since the Act I pass** (keep to these): Wyn has the player's own goal (the Sap Gate shard; `outsider?` and
  `my_glass` in `017_TargosExtras.rb`); at the last mirror the outsider chooses, and only then does Auril see them and
  mark them with the owl feather; the Order's dagger breaks the last mirror; Iskra is Auril's roc (a giant white bird),
  named by Luna in Chapter 3. Alberica's family bargain (story bible, Alberica): her village is spared the Rime so long
  as the White Vault stays sealed; her pendant unlocks it; the Vault is postgame.
- **WRITING_GUIDE §3b** is the context standard; your §2 table includes the "three questions" column and you mark
  skip-test failures (facts only in optional content).
- **Read-only** on the game, maps and design docs. Your only output is your NN.md file(s). Save each section as you go.
- Keep helper use modest: don't start sub-agents.
- **Finish** with a report under 250 words: files, gaps by severity, missing scenes written, your top 5.
