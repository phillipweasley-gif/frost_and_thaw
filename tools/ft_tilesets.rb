# The game's own tileset patch (game/Data/Scripts/998_FrostThaw/002b_TilesetPatch.rb: our animated autotiles, their
# passages and priorities), applied to the base Tilesets.rxdata the map tools read, so a check sees what the game does.
#   FTTilesets.load(path) -> the patched tilesets
module FTTilesets
  GAME_PATCH = File.expand_path("../game/Data/Scripts/998_FrostThaw/002b_TilesetPatch.rb", __dir__)
  def self.load(path)
    Kernel.load(GAME_PATCH) if !defined?(FrostThaw::TILESET_PATCH)
    FrostThaw.patch_tilesets(load_data(path))
  end
end

# the patch's constants (FrostThaw::AURORA_WALL, SAP_AUTOTILE, ...) for the map builders
Kernel.load(FTTilesets::GAME_PATCH) if !defined?(FrostThaw::TILESET_PATCH)
