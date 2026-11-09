# 0.8.5 (2026-11-09): the animated autotiles, the dragons in motion

- **A-06, the Auroral Wall:** a shimmering curtain of light (green, teal, a little violet) along the Blooming Fields'
  east edge, where ice boulders stood in for it: two solid columns and a soft edge you can walk into, drawn above
  you. Three single-tile animated autotiles (8 frames) on three blank Outdoor tiles no map uses, through PIF's own
  EXTRA_AUTOTILES table.
- **A-15, the sap:** a full 48-shape animated autotile (32 frames) in the Cave tileset's empty 7th slot, made from the
  game's own murky-water autotile with its water and foam turned to amber sap (the banks are the game's pixels).
  Live sap now fills the Dragonforge pit under the bridge (where Autumn falls) and a seam in the Guild dig.
- One patch, `game/Data/Scripts/998_FrostThaw/002b_TilesetPatch.rb`, sets the autotiles, passages and priorities in
  the game; the map tools load the same file (`tools/ft_tilesets.rb`), so `check_all` sees what the game does.
  Graphics: `tools/autotilegen.py`.
- **The dragons' cutscene sheets** (`tools/dragongen.py`, from their own sprites, 18 sheets): Frostina lands like
  snow, lowers her head to hum, takes off, breathes frost, is closed in her crystal and tumbles out of it shaking;
  Razzilith lands hard (the cobbles crack), takes off, roars, breathes leaves and light; the chained dragon's eyes
  light gold, it strains, tears free and goes up, dives on Good Mead breathing a line of light, lands in the square
  and roars, and shatters. Wired into the market landing and take-off (Ch6), the Dragonforge (Ch8), the Shrine
  take-off, Good Mead and the square (Ch9), the Shrine crystal (Ch11), and the crown (Ch13). Flying sheets carry no
  riders (a cast sprite on a dragon's back reads as a giant head). Iskra still has no sprite of her own.

## Checks
- Maps rebuilt (`build_all`), all 159 pass `check_all`; smoke test 241/241.
- **Final round on 0.8.5:** Journey 247/247, Shatter 247/247, Still Keeper 241/245 (by design), Heralds Alberica,
  Meat Meat 239/239, Wyn 238/238; Reptin and Alerion fell short in the round (the driver stuck before Duvessa's
  badge; a missed side beat on an unchanged map) and reran clean at 239/239 each.
