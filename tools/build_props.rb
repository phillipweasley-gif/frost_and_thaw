# Ambient props (Art List A-01 lanterns, A-02 banners), added after every other map builder has run.
# Generated art: tools/propgen.py (FT_prop_lantern, FT_prop_banner).
#
# Lanterns: one on the wall beside each building door ("Door ..." events) in the towns, on the door's right if
# that tile is building facade (a tile on it and the one above), else on its left. Rootspire's are paper lanterns
# (row 1 of the sheet, direction 2), Ten-Towns' iron lamps (row 2, direction 4).
# Banners: the four season banners on the Council Hall of Seasons' inner walls, by the statue.
# Every prop is walk-through, fixed facing, step-animated, with no commands: scenery only.
require_relative "ft_common"
require_relative "rgss_stub"
TS = load_data("/home/claude/pif-682/Data/Tilesets.rxdata") if !defined?(TS)

# As check_all.rb reads a tile: a wall is a tile the player can't walk onto.
def wall?(m, x, y)
  return false if x < 0 || y < 0 || x >= m.width || y >= m.height
  t = TS[m.tileset_id]
  [2, 1, 0].each do |z|
    id = m.data[x, y, z]
    next if id == 0
    return true if t.passages[id] & 0x0f == 0x0f
    return false if t.priorities[id] == 0
  end
  false
end

# Rebuilding is safe: the props this file added last time are taken out first.
def clear_props(b, name)
  b.map.events.delete_if { |_, e| e.name == name }
end

LANTERN_MAPS = { 2001 => 4, 2012 => 4, 2050 => 2, 2180 => 2 }   # map => sheet row (2 paper, 4 iron)
BANNERS = { 2054 => [[8, 11, 2], [10, 11, 4], [13, 11, 6], [15, 11, 8]] }   # x, y, row (spring, summer, autumn, winter)

def prop_page(graphic, dir)
  { graphic: graphic, direction: dir, step_anime: true, walk_anime: false, direction_fix: true, through: true }
end

def occupied?(b, x, y)
  b.map.events.values.any? { |e| e.x == x && e.y == y }
end

def facade?(b, x, y)
  wall?(b.map, x, y) && wall?(b.map, x, y - 1)       # a wall tile, with wall above it: the building's face
end

LANTERN_MAPS.each do |id, dir|
  b = reopen(id)
  clear_props(b, "Lantern")
  n = 0
  b.map.events.values.select { |e| e.name.start_with?("Door ") }.sort_by { |e| [e.y, e.x] }.each do |d|
    spot = [[d.x + 1, d.y], [d.x - 1, d.y]].find { |x, y| facade?(b, x, y) && !occupied?(b, x, y) }
    next if !spot
    b.event(spot[0], spot[1], "Lantern", [prop_page("FT_prop_lantern", dir)])
    n += 1
  end
  resave(b, id)
  puts "#{id}: #{n} lanterns"
end

BANNERS.each do |id, spots|
  b = reopen(id)
  clear_props(b, "Banner")
  spots.each { |x, y, dir| b.event(x, y, "Banner", [prop_page("FT_prop_banner", dir)]) }
  resave(b, id)
  puts "#{id}: #{spots.size} banners"
end
