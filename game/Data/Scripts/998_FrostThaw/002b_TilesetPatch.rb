#===============================================================================
# Frost & Thaw: our animated autotiles on the base game's tilesets (2026-11-09)
#
# A-15, the sap channel: a full 48-shape autotile in the Cave tileset's empty
# 7th slot (tile ids 336-383; nothing in the base game paints them), solid.
# A-06, the Auroral Wall: three single-tile animated autotiles laid over three
# blank tiles of the Outdoor tileset that no map uses (checked across every base
# map and ours), through PIF's own EXTRA_AUTOTILES table. They draw above the
# player; the wall's two are solid, the soft edge isn't.
#
# The map tools load this same file (tools/ft_tilesets.rb), so their passability
# checks see exactly what the game does. Graphics: tools/autotilegen.py.
#===============================================================================
module FrostThaw
  # tileset id => { autotiles: { slot => file }, extra: { tile id => file }, tiles: { ids => [passage, priority] } }
  TILESET_PATCH = {
    32 => { autotiles: { 6 => "FT_sap_flow[6]" },
            tiles: { (336..383) => [0x0f, 0] } },
    23 => { extra: { 11311 => "FT_aurora_edge[2]", 11335 => "FT_aurora_wall[2]", 11247 => "FT_aurora_wall_b[2]" },
            tiles: { 11311 => [0, 1], 11335 => [0x0f, 1], 11247 => [0x0f, 1] } }
  }
  SAP_AUTOTILE = 7          # the Builder's autotile index (slot + 1) for the sap channel
  AURORA_EDGE, AURORA_WALL, AURORA_WALL_B = 11311, 11335, 11247

  def self.patch_tilesets(tilesets)
    return if !tilesets
    TILESET_PATCH.each do |id, p|
      ts = tilesets[id]
      next if !ts
      (p[:autotiles] || {}).each { |slot, file| ts.autotile_names[slot] = file }
      (p[:tiles] || {}).each do |ids, (passage, priority)|
        (ids.is_a?(Range) ? ids.to_a : [ids]).each do |t|
          ts.passages[t] = passage
          ts.priorities[t] = priority
        end
      end
    end
    if defined?(TilemapRenderer::EXTRA_AUTOTILES)
      TILESET_PATCH.each do |id, p|
        next if !p[:extra]
        TilemapRenderer::EXTRA_AUTOTILES[id] ||= {}
        TilemapRenderer::EXTRA_AUTOTILES[id].merge!(p[:extra])
      end
    end
    tilesets
  end
end

if defined?(Game_Map) && Game_Map.method_defined?(:updateTileset)
  class Game_Map
    alias ft_patch_updateTileset updateTileset unless method_defined?(:ft_patch_updateTileset)
    def updateTileset
      if !$ft_tilesets_patched || !$ft_tilesets_patched.equal?($data_tilesets)
        FrostThaw.patch_tilesets($data_tilesets)
        $ft_tilesets_patched = $data_tilesets
      end
      ft_patch_updateTileset
    end
  end
end
