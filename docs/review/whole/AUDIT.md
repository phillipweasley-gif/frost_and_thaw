# Whole-game read: the fix round and its audit (0.8.2, 2026-11-08)

Three reviewers read the whole game end to end (`VOICES.md`, `THREADS.md`, `PLAY.md`): 79 findings, none that stop
the game (several found by two reviewers). This round fixed all of them except the few under "Not changed", each
with its reason.

## Checks

RESULTS

## What was fixed

**Herald Mode (VOICES 1, 2, 3, 4, 10, 13, 14, 15; THREADS 29).**
- A line an NPC answers is now said aloud, by choice (`ask_as` / `ask_cl` in 014; `say` runs them in place):
  19 places in Acts I–II where a Herald's thought was answered, including the ghost's "You have my face", "We?" and
  "Who are you?", Meat Meat's "Mama?" and "Is there coffee in the sunlight?". The rest of the trace scan's hits were
  already spoken choices.
- Alberica's fall line fits whoever she grabs (no "pretty boy" for the kid, Wyn or Meat Meat).
- Tamsin and Eirwen are "they" everywhere; Herald Mode meets Tamsin by name in Ch9.
- The Herald you play is "you": the petals, Eirwen's chronal leaf, Reptin's "then you stay", Alerion's "From you",
  the dockworker, Ivo, the pilgrim, Sephek's lines to Meat Meat and Alerion, the Codex page, the lock, Wyn's account.
- Two broken second-person sentences in Alberica's Codex and omen; three garbled Herald thoughts.

**Continuity (VOICES 5–9, 11, 12, 16–22, 24–29; THREADS 1–6, 9, 10, 14, 18, 22–24, 28).**
- Anduin stays unnamed in Act I (owner's decision 7); in Ch6 he's "counting days", not in Bryn Shander.
- The Ch9 "Tell them" choice is read back at the trial and at the throne; nobody is blamed for a secret they shared.
- Sephek's heart at the throne follows what the Crown did with it. Eline's grief line plays once.
- Kethan is captain of the Hall watch (the bible updated); Rheven commands the Rootwardens.
- Selrae went down "the night the tree shook". Selrae "stood in the dock", not the Halo's prisoner.
- Before the Heart Chamber: Var's echo no longer says he's trapped; Bryn and Dathra no longer describe Summer;
  Eirwen's ledger names "a pale lady"; Grik sees the fire, not "her gold".
- The Rimefang came in Shade's boot in Targos (four lines), and a Lonelywood line sets its cold up.
- Thredra says she gave the pendant back; Alberica says she threw it in the sea, on the dock too.
- Shimmer's heart went into an egg. Reptin says "dear"; Alberica's plain voice when Glimmer goes. Ythryn spelt as the
  bible spells it. The last line is the ghost's own first line. "Mushroom person" until the coffee. Small tics cut.

**Payoffs (THREADS 3, 7, 8, 11–13, 15–17, 19–21, 25–27, 30–32).**
- Auril reads back the Ch11 look. Tamsin is sworn into the Rootwardens in the trial week and calls you their friend
  from the gallery; their last battle class is "Rootwarden".
- Epilogue: the Vote's councillors, Meat Meat's sentence, Reptin alone if Anduin left, Garagai's axe, the yeti, the
  carved cat on Hellen's shelf (and Glimmer hands it on at the Forge).
- "V-7" at the Test of Cruelty. Meat Meat's "DONE" moves to the Vault's last blow. The arms deal is read at the trial.
- Lumin keeps Iskra warm in Ch6; the hum works for a player who heard the four notes; the silver egg promise is gone.
- The medallion and the relics' chord return once. The bard's song comes from the journal. The coda's "stranger" only
  where somebody fell out of a lantern. The forge-pod prisoners among the refugees. Good Mead saved is read back.
- The loop re-earns the Wheel instead of banking it.

**Playability (PLAY 1, 3–9, 10, 12–17).**
- The throne: a page on map 2089 asks the god choice again if a save loads without its running event (a game update
  can clear it), and rests once an ending is chosen. The autosave dumps in memory first.
- Hellen's gym ace 42 → 40; Durmoot 29 → 28; Thredra 33 → 32; Mira's scaling capped at version 1.
- Wild Pokémon in the Hall of the Four Winds (62–66); the jaw's prompt says what's ahead.
- The loop: a skip restores the story switches and the maps' self switches (finished favours stay finished); a
  replayed act doesn't hand over Sahnar, Heartwood, the Spheal or Yetot twice, nor the Blanket; your own Herald
  stays hidden.
- Day 7 says the crystals sit when you tell Kelyn. Still Sky's text matches what it does. The side goal no longer
  warns of a Wall that can't stay up. The Prophecy Leaf has no "Use"; the Shard Focus doesn't promise "Once".
  The tincture's witness is the brewing, not a bottle you might drink. Glimmer's journal flag fixed.
- The driver plays the sigils' merge and the White Vault after the ending (PLAY 10), so every baseline now covers
  the postgame. A Herald Alerion run joins the baselines (PLAY 11).

## Not changed

- PLAY 2: the court choice *is* read back (`scene_verdict`, "KELYN: And the one who came out of the lantern with
  them."); the reviewer missed it.
- VOICES 23: NPCs you talk to don't carry a name tag, everywhere in the game; only Grik's hint was changed.
- THREADS 4, Selrae's "Avarice": kept. By Road B the Echo Gate has named her as Meat Meat's maker, and Selrae names
  her as the Halo's friend "down here too", beside Summer, not as Summer.
- THREADS 30: `rootbeasts_freed` still has no reader (no scene where they'd be seen).
- PLAY 12: the other dead `||` alternatives stay; each is covered by its other flag.
- The October art list and Art List 2 disagree on Iskra (roe) and the game (roc): asked in the art doc.
