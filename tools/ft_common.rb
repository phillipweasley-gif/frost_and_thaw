# Shared pieces for the Frost & Thaw chapter builders (Chapter 3 onward).
require_relative "mapkit"
include MapKit

OUT = File.expand_path("../build/maps", __dir__) unless defined?(OUT)
Dir.mkdir(OUT) unless Dir.exist?(OUT)

def save_map(b, id, music = nil)
  b.music(music) if music
  b.save(File.join(OUT, format("Map%04d.rxdata", id)))
  b.to_json_file(File.join(OUT, format("Map%04d.json", id)))
end

def merge_infos(ids_names)
  path = File.join(OUT, "mapinfos.json")
  infos = File.exist?(path) ? JSON.parse(File.read(path)) : {}
  ids_names.each { |id, name| infos[id.to_s] = name }
  File.write(path, JSON.pretty_generate(infos))
end

# Opens an already-built map for more edits.
def reopen(id)
  m = load_data(File.join(OUT, format("Map%04d.rxdata", id)))
  b = Builder.allocate
  b.instance_variable_set(:@map, m)
  b.instance_variable_set(:@w, m.width)
  b.instance_variable_set(:@h, m.height)
  b.instance_variable_set(:@autotile_fills, [])
  b.instance_variable_set(:@event_template, MapKit.deep_copy(MapKit.load_map(631).events.values.find { |e| e.name == "EV011" }))
  b.instance_variable_set(:@door_template, MapKit.deep_copy(MapKit.load_map(631).events[1]))
  b
end

def resave(b, id)
  save_data(b.map, File.join(OUT, format("Map%04d.rxdata", id)))
  b.to_json_file(File.join(OUT, format("Map%04d.json", id)))
end

def has_event?(b, name)
  b.map.events.values.any? { |e| e.name == name }
end

def exits_to(b, exits, map, x, y)
  exits.each { |ex, ey| b.door(ex, ey, map, x, y, 2, name: "Exit") }
end

# An NPC that appears only when a game switch is on (page 1 is empty and walkable).
def npc_when(b, x, y, graphic, key, switch, dir: 2, name: nil)
  b.event(x, y, name || "NPC #{key}", [
    { graphic: "", through: true },
    { switch: switch, graphic: graphic, direction: dir, script: "FT.talk(:#{key}, @event_id)" }
  ])
end

# An NPC that stands in the way until a game switch turns on, then is gone.
def npc_until(b, x, y, graphic, key, switch, dir: 2, name: nil)
  b.npc(x, y, graphic, key, dir: dir, hide_switch: switch, name: name)
end

# A step-on trigger that runs once (a scene that waits for the player at a spot).
def trigger(b, x, y, key, name: nil)
  b.event(x, y, name || "Trigger #{key}", [
    { trigger: 1, through: true, script: "FT.scene(:#{key}, @event_id)" },
    { self_switch: "A", through: true }
  ])
end

SNOW = 444
GRASS = 8510                                        # snowy tall grass (wild Pokémon)
TREE = [[4582, 4583], [4590, 4591], [4598, 4599], [4606, 4607]]
ICE_BOULDER = Stamp.tileset(:ice_boulder, 118, 0, 2, 2)
BOULDER = Stamp.tileset(:boulder, 114, 2, 2, 2)
CAVE = Stamp.tileset(:cave, 25, 2, 3, 3)            # the mouth is the bottom-middle tile
PLANK = { nw: 1920, n: 1922, ne: 1925, w: 1928, c: 1930, e: 1933, sw: 1944, s: 1947, se: 1949 }
FENCE_H = 384 + 134 * 8 + 1                         # a run of log posts
FENCE_V = 384 + 133 * 8 + 4
LAMP = Stamp.tileset(:lamp, 82, 4, 1, 2)
HUT = Stamp.tileset(:hut, 675, 2, 5, 4)
ROUND_HUT = Stamp.tileset(:round_hut, 680, 2, 5, 4).without([[4, 0]])
CABIN = Stamp.tileset(:cabin, 982, 0, 6, 5)
HOUSE = Stamp.tileset(:house, 629, 0, 4, 5)
CENTER = Stamp.tileset(:center, 457, 0, 7, 7)
GYM = Stamp.tileset(:gym, 254, 0, 7, 7)
CRATE = 1056
HAY = Stamp.tileset(:hay, 79, 1, 2, 2)

# Trees on alternating layers, so a row of trees can overlap the one above it
# without opening walkable gaps (the canopy is drawn over the player anyway).
def tree(b, x, y, layer = 2)
  TREE.each_with_index { |row, dy| row.each_with_index { |t, dx| b.set(x + dx, y + dy, layer, t) } }
end

# Forest everywhere except the open cells: a tree is planted only where its two
# solid rows stay clear of the open area (its canopy may hang over it).
def forest_except(b, w, h, open)
  plant = []
  (-1...h).step(2).each_with_index do |y, i|
    (0...w).step(2) do |x|
      solid = [[x, y + 1], [x + 1, y + 1], [x, y + 2], [x + 1, y + 2]]
      next if solid.any? { |c| open[c] }
      plant << [x, y, i.even? ? 1 : 2]
    end
  end
  planted = {}
  plant.each { |x, y, _| planted[[x, y]] = true }
  plant.each do |x, y, layer|
    TREE.each_with_index do |row, dy|
      # the trunk's foot is drawn only where no tree stands right below
      next if dy == 3 && planted[[x, y + 2]]
      row.each_with_index { |t, dx| b.set(x + dx, y + dy, layer, t) }
    end
  end
end

# Fills a rectangle with dense forest (2x2 grid of trees, rows overlapping).
def forest(b, x0, y0, w, h)
  (y0...y0 + h).step(2).each_with_index do |y, i|
    (x0...x0 + w).step(2) { |x| tree(b, x, y - 1, i.even? ? 1 : 2) }
  end
end

def grass(b, x0, y0, w, h)
  (y0...y0 + h).each { |y| (x0...x0 + w).each { |x| b.set(x, y, 1, GRASS) } }
end

