# 0.8.3 (2026-11-09): the art standard, the rebuilt cast, effects and props from code

## The art standard (owner, 2026-11-08)
- Every walking sprite is built on one of Infinite Fusion's own 320x320 overworld sheets (the chibi template is
  retired): a clean-faced base, its body and walk kept, hair, face, clothes and colours repainted. Rules and pictures:
  the art guide's "Style guide: build on the game's own sprites"; text copy `References/STYLE-CURRENT.md`.
- `tools/art_check.py` measured against the base game (height, colours, value, outline, feet, `--base` body match,
  floating pixels, prop sheets). `tools/face_eyes.py` stamps the game's 2x2 eye from a sheet's own palette.

## In the game (all md5-verified on the Mac)
- **Sprites (designer, reviewed):** batch 1 Ten-Towns (approved by Phil), batch 2 Council + Mira + 4 battle
  pictures, batch 3 Rootspire city, the main cast (Alberica, Reptin, Alerion, Wyn, Anduin, Var, Tamsin, Shade,
  Shimmer, Hellen, Sephek, Thredra, Darrus, Hlin, Edgra, Rheven), Meat Meat (custom head on BW (36)'s body).
- **Effects (code, `tools/fxgen.py`), 17:** E-05, E-10, E-11, E-13, E-16, E-17, E-18, E-21, E-22, E-23, E-24, E-25,
  E-31, E-32, E-33, E-34, E-35; 15 placed in their scenes (E-24 rain and E-32 sparkle drawn, not placed).
  `Stage.fx` gained `start:` (a row of a multi-effect sheet) and `mirror:`.
- **Balloons (code, `tools/balloongen.py`), 6:** B-02, B-03, B-04, B-08, B-09, B-10 on B-01's bubble; `say` shows
  them over an on-screen speaker from the line's stage direction (`FT.reaction_balloon`).
- **Ambient (code):** overlays A-11 spores and A-12 embers by map (`ambient_overlays`); props (`tools/propgen.py`,
  placed by `tools/build_props.rb` after every build): A-01 lanterns (31), A-02 season banners (4), A-03 ice
  twinkles (44), A-04 sap drips (16), A-13 laundry (6). `check_all` lets FT_prop_ scenery hang on walls.
- **Act title cards (code, `tools/cardgen.py`):** S-25a-c, shown by `FT.act_card` at each act's opening.
- **Panels pre-wired** to their moments (each shows as soon as its file exists): S-02, S-03, S-06, S-10, S-11,
  S-12, S-13, S-14, S-15, S-16, S-17, S-18, S-19, S-20, S-21, S-22, S-23, S-24a-d.
- Zenith is "she" (Ch3 hint fixed). Pip is a female Wennen, fat and fancy; Wennen have full rabbit heads (bible).
- A stale copy of eight sprites in `build/gfx/Characters` overwrote the new ones when the game was assembled; removed,
  and the smoke test now checks for shadowed sprites.

## Checks
- Smoke test 241/241; all 159 maps pass; Journey 247/247 and Herald Meat Meat 239/239 after each risky change.
- The full eight-run round on the final state: see the end of this file.

- **Final round on 0.8.3 (all eight):** Journey 247/247, Shatter 247/247, Still Keeper 241/245 (the loop's four by design;
  a first run's 237 was the driver losing its way in the loop's replay, and a rerun gave 241), Heralds Alberica,
  Reptin, Meat Meat, Alerion 239/239, Wyn 238/238. Smoke test 241/241.
