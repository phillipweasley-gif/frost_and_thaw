# Act III scene pass: audit after the build (0.8.0, 2026-11-07)

Built on `scene3_i` (12: the Sea of Moving Ice and the White Vault) and `scene3_j` (13: Grimskalle, the Tests, the
Crown, the Throne, the three endings and the epilogue), merged on `act3_merge` with the owner's Nov 7 calls (the
coffee choice, Rootspire's cuts on `scene2_h`, the Scratching Hollow), to the brief in `BUILD_ACT3.md`. Then one
short round in which j built what i listed for its files.

## Checks

- Smoke test 236/236. All 159 maps pass the builder's map checks.
- Full games re-recorded on fresh test copies (`traces_080/`): New Journey 244/245 (the Third Way); Herald
  Alberica, Reptin and Meat Meat 236/237; Wyn 235/236. The one miss is the postgame sigil merge, as on every
  baseline. (A first Journey run missed the root-keep gate on map 2072 after a lost battle; the rerun passed. The
  driver has missed that gate before.)
- **Every ending traced:** the Third Way (every mode above), Shatter (`journey_shatter.txt`, 244/245) and the
  Still Keeper (`journey_still_keeper.txt`): the loop sends you back to the start, so the driver scores 241/245
  because the flags it checks afterwards are gone; the loop itself plays as written.
- Act III as played (`ch11_done` to the end), 0.7.8 → 0.8.0:

  | Measure | Journey 0.7.8 | Journey 0.8.0 | Wyn 0.7.8 | Wyn 0.8.0 | Meat Meat 0.7.8 | Meat Meat 0.8.0 |
  | --- | --- | --- | --- | --- | --- | --- |
  | Boxes | 409 | 442 | 413 | 457 | 401 | 428 |
  | Boxes over 90 characters | 17 | 0 | 17 | 0 | 15 | 0 |
  | Lines spoken off screen | 22 | 6 | 22 | 6 | 22 | 6 |
  | Choices | 18 | 29 | 21 | 35 | 18 | 32 |
  | Staging events | 182 | 284 | 174 | 274 | 159 | 262 |

- **In every trace, from `ch11_done` to the end:** no box over 90 characters, no speaker four boxes in a row, no
  run over 25 boxes without an input. The six lines off screen are by design: Sephek's voice from the ice (four)
  and Auril's whisper (two).
- **Act II again, after the coffee move:** no run over 25 boxes without an input anywhere in Act II now (the
  coffee choice sits mid-scene); the only boxes over 90 are the four protected lines and the base game's strings.

## What was built

- **i (12):** the crossing staged: griffons at the roost, a fade into the floes panel (S-12a) with the Rime's
  music, one obstacle per route with a battle you can lose without a whiteout, and day two in fog (S-12b).
  Tamsin's goodbye is a real rival battle; Hellen hands over the Full Restores herself. Sopo's dock scene (two
  Corsairs take his pack), the Relic-Warden rising, the night camp with only wind. Herald Mode lines that another
  Herald answers became loud or quiet choices. Avarice's intro at the throne and both her fights with their own
  music. **The White Vault:** Avarice in the panes, each Herald answering her, her case changing with your ending,
  the cradle staged with her reforged body, shorter retries. Every long box in 038 and 047c trimmed.
- **j (13):** the Tests (shades on screen and gone once beaten, each vision staged, Alerion's hand an input, a
  lost test retried from its door); the Hall (visible doors with their carved words); the Crown (Eline's death
  staged, with Alberica's beat); the Throne (Auril walks down, changes form, lifts Alberica, the diamond falls;
  the final-boss music, then silence for the choice); the outsider carries the diamond; Shatter's cost and its
  owl; a "hum along" input in the Third Way; a legible Still Keeper loop; the epilogue lets you pick each place,
  with cuts and music; Act III's loop skip; key items taken and given back across skips; Hellen and Tamsin after
  the end. Round 2: Sopo on the climb.
- **h (Rootspire, owner's yes):** Glimmer's rite in two days (the Severance, the Acceptance); Meat Meat's mornings
  four into two; the Frostfell portal cut (old saves handled); Eira's market folded into the Frozen Cellar, where
  you meet her. Flags retired (none read elsewhere): `frostfell_seen`, `met_eira`, `met_eira_voss`,
  `stillshards_cursed`, `blue_lights_heard`, `summer_imbalance_seen`, and the black-market table.
- **Owner's calls:** the coffee choice (four cups, each a stat lifted for three battles; `050_Coffee.rb`), and the
  Umbound Chasm renamed the Scratching Hollow.

## Not built

- The Root-Gate stair box in 025 (one long box, outside both builders' files).
- The story review's reworks of the Tests: the owner's Aerix decision stands.
- The old `try_w5_*` scenario scripts still name Rootspire's cut days; they predate the scene passes and aren't
  part of the checks.
- The loop's fallback flag lists (`041_LoopFlags.rb`) still lag a full playthrough; they're used only for a save
  with no loop snapshot of its own.
- **Art:** on hold with the designer; Act III's requests are in Art List 2, "From the Act III scene pass".

## For the owner

- **An autosave before the god choice?** The three endings branch at one menu; the Still Keeper loops you back
  to the start.
