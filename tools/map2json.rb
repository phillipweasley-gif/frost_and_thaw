# Usage: ruby map2json.rb <map.rxdata> <out.json> [game_dir]
require_relative "rgss_stub"
require "json"
game = ARGV[2] || "/home/claude/pif-682"
m = load_data(ARGV[0])
ts = load_data(File.join(game, "Data/Tilesets.rxdata"))[m.tileset_id]
evs = m.events.values.map do |e|
  pg = e.pages[0]
  { id: e.id, name: e.name, x: e.x, y: e.y,
    char: pg.graphic.character_name, dir: pg.graphic.direction, pattern: pg.graphic.pattern,
    tile: pg.graphic.tile_id }
end
File.write(ARGV[1], JSON.generate(
  w: m.width, h: m.height, data: m.data.data, tileset: ts.tileset_name,
  autotiles: ts.autotile_names, events: evs))
