# Act I context pass: audit after the build (0.7.3, 2026-11-05)

Built on `context_a` (00–01), `context_b` (02–03) and `context_c` (04–05), merged into main, plus the owner's
answers of 2026-11-05 (Wyn has the player's own goal; the Order's dagger breaks the last mirror; Auril sees and marks
the outsider only after the last-mirror choice) and Iskra as a roc.

## Checks

- Smoke test 229/229 on the merged main.
- Act I re-recorded (STOP_AT=5) in New Journey (70/70 beats) and as Alberica, Reptin, Alerion and Wyn (62/62 each).
  Meat Meat: every beat through Chapter 3, then the headless driver loses the forced Ranger Hadd battle on the
  Eastway with her two-Pokémon team (Noibat, Spheal) and stalls; a story run, not a story bug. Worth a balance look:
  Hadd's Stantler has Intimidate and Take Down, and he blocks the only road.
- `tools/headless/try_last_mirror.rb`: all six branches of the last mirror (ALL OK).
- New lines: each builder grepped its own trace; the owner's-answer lines and the lift lead were checked here.

## Not built yet (by part)

- **00/01 (builder a):** the ship backdrop and a daytime Rootspire backdrop (new art); the unreachable tavern lines
  (`006_Dialogue.rb` 74–76, the ring's meaning; Alberica's "My family was his kind"); Keegan's full rebuild (dialogue
  review top 5, #4); Anduin, left unsaid by the owner's call. Tamsin leading you to the lift: built after the merge.
- **02/03 (builder b):** no map rebuilds, so no footprint events (a camera pan stands in), the attic is the main room
  at night, 3.19 plays in the Warren; the "Rime" music cue; notes E7 (Sephek walking out of the gate), E19, E23, E31;
  Torrga (E4); folding the three-hearts talk into the Requiem; panel S-03a (art); Shimmer's song (a jingle stands in).
- **04/05 (builder c):** Low items (Olivessa's walk-up, the Redwaters ice-fisher, the east-gate guard, Odda's intro,
  the walker's note); Chapter 2's "(Reptin carries the Golden Acorn)" box.

## Found during the audit

- **Over-long boxes.** About 50 Act I boxes over 90 characters were split at sentence boundaries. About 150 remain
  (`long_boxes_act1.txt`, as played across all six runs): ternaries, interpolated lines, `pbMessage` boxes and
  speeches that need rewording, not a mechanical split. They go in the Act I scene pass.
- **A speaker over three boxes in a row** after the splits: Koran's ask in `045_HoledUp.rb` (five boxes). Scene pass.
- **Item icons:** 123 of 155 story items have no icon, including the Lantern Glass and the Sap Gate Shard. Art list.
- **Test copies:** the builders' test copies were hard-linked to the main one and `boot.rb` defaults to it; all three
  are unlinked now. Brief for later builders: always set `PIF_DIR`.
