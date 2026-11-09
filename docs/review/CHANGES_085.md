# 0.8.5 (2026-11-09): the animated autotiles

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

## Checks
