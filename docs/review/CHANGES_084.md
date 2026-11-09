# 0.8.4 (2026-11-09): the story panels, the poses on model, ambient life

## Story panels (designer, reviewed; each fitted to its lines)
- Tier 1, all in: S-04 (redraw), S-14, S-15, S-17, S-18, S-19, S-20. Tier 2: S-10, S-11, S-12, S-13. S-02 redrawn
  with our cast (Phil: the old one "doesn't look like our characters"); Alberica's cap recoloured purple.
- S-17, S-18, S-19 were painted at full 512x384: brought to the panels' 256x192-doubled scale (`tools/panel2x.py`).
- Panels moved to the lines they show: S-14 now covers the flight through the Wall (the black dragon plays on the
  map after it); S-10 waits for Glimmer's reveal; S-12 carries Glimmer's last words. S-12's stray forehead horn
  painted out. S-20 revised by the designer (a calm smile, as the script says).
- `References/CAST-REFERENCE.png` (`tools/castref.py`): every main character's sprite and the traits a panel keeps.

## Sprites
- Designer: Luna, Zenith, Lumin (full rabbit heads), Glimmer's tail, Razzy as a goblin on BW (16).
- Mine: Luna's braids ice-blue then plaited, dress a value darker; Razzy's hair darkened; Alberica's and Wyn's caps
  and Master Hew's hat on every facing (they were front-only); Meat Meat's eyes violet (bible); the Wennen heads
  rounded from behind; a dark underside to Glimmer's tail; the generic Wennen and jet sentry remade on the new Wennen.
- Cutscene poses: all 24 P-* sheets were still on the retired chibi template. Rebuilt from each character's own
  walking sheet (`tools/posegen.py`: kneel, reach, fall and lie, clutch, hold out, arms out, ice, dissolve, the wolf
  flicker), plus REP-05, REP-06, SEP-05, SEP-06, THR-04 on model (their batch-04 copies removed). Variants
  FT_alberica_rune, FT_sephek_frozen, FT_var_cracked, FT_thredra_echo remade the same way.

## Ambient and effects
- E-24 rain on the lake (Ch7A), E-32 green bond on Meat Meat and Razzilith (Ch9).
- Props (`tools/propgen.py`, placed by `tools/build_props.rb`): A-05 spore beds, A-07 bees over Good Mead's hives,
  A-08 snow birds, A-14 snow sliding off roofs now and then (a route through the sheet's rows), A-16 Wennen peeking
  from burrows.
- Townsfolk at work (`tools/townsfolkgen.py`, from the base game's villagers): A-10 a brazier with two villagers
  warming their hands, A-17 shovellers, A-09 ice fishers.
- Six missing bag icons (`tools/icongen.py`).

## Story
- Choices paid off in the epilogue: the freed root-beasts, the saved sporelings, Shimmer's rose at Frostina's nest,
  Selrae at the Echo Gate. Hew at the Trials follows what you told him in Ch7B.

## Checks
- Alberica beardless (owner): `tools/alberica_beardless.py`; her poses and rune variant regenerated.
- Maps rebuilt from scratch (`build_all`); all 159 pass `check_all`. Smoke test 241/241.
- **Final round on 0.8.4 (all eight):** Journey 247/247, Shatter 247/247, Still Keeper 241/245 (the loop's four by
  design), Heralds Alberica, Reptin, Meat Meat, Alerion 239/239, Wyn 238/238.
