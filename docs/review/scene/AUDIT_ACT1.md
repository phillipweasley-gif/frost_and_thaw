# Act I scene pass: audit after the build (0.7.5, 2026-11-06)

Built on `scene_a` (00 prologue, 01 Targos), `scene_b` (02 Bryn Shander, 03 Lonelywood), `scene_c` (04 the Eastway
and Dougan's Hole, 05 the Chasm, plus balance) and `scene_h` (14, Act I's side quests), merged into main, to the
brief in `BUILD_ACT1.md`.

## Checks

- Smoke test 231/231. All 157 maps pass the builder's map checks.
- Full games re-recorded (`traces_075/`): New Journey 244/245; Herald Reptin, Meat Meat and Alberica 236/237; Wyn
  235/236. The one miss is the postgame sigil merge, as on every baseline. **Meat Meat now finishes the whole game
  with her own starter** (it used to stall at Ranger Hadd).
- Act I as played, New Journey, 0.7.4 → 0.7.5:

  | Measure | 0.7.4 | 0.7.5 |
  | --- | --- | --- |
  | Boxes | 1442 | 1534 |
  | Boxes over 90 characters | 89 | 2 (both the base game's "You scurry back to a Pokémon Center") |
  | Lines spoken off screen | 27 | 5 (a child's voice in the dark, by design) |
  | Choices | 53 | 66 |
  | Staging events | 830 | 1032 |

- No speaker has four boxes in a row in any mode. A few stretches of 26–33 boxes pass without a choice in Chapter 5
  (the rift bridge, the dead yeti, Thredra's hall), but each is several separate events the player walks between.
- New lines checked as played by each builder in its own traces; the side quests also by 34 scenario tests.

## Fixed at the merge

- Builders' items in each other's files: the Golden Acorn on screen in Ch2 (c → b); Nimsy seeds the moose job, Shandar
  is a dwarf on sight, Good Mead's sign, the dead `fef_moryn` text, Durmoot names a finished favour, Hilda's bed
  (h → 015, 022, 045_HoledUp).
- Art batch 03 hooked up: S-03a, E-07, Glimmer, Boy (`Followers/BOY`), the ship backdrop (Alberica, Reptin, Alerion),
  Iskra's panel (S-11a), Var's trainer and cracked face.

## Not built (by builder)

- **a:** the Velryn interior's map (2124 is built by build_tentowns; h did its text).
- **b:** the engine's "awayin" bag string; act1_script.md drift (docs only).
- **c:** the rescued children don't follow you between the cage and the ambush (no follower system); Gerd's move; the
  walker's approach.
- **h:** Copper's Black Cabin stays colour (his flag is read back); "Garret sent home" fails one scenario test on old
  and new code alike (the bag has no potion).
- **Art and sound** requested by the builders are in Art List 2.
- **For the owner:** Meat Meat's Noibat is four times weak to Ice in an icy Dale; the balance fixes carry her, but her
  starter choice is a design question.
