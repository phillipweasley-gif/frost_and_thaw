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

# --- A-13 laundry, A-04 sap drips, A-03 ice twinkles ------------------------------------------------------------
def floor?(m, x, y)
  x >= 0 && y >= 0 && x < m.width && y < m.height && !wall?(m, x, y)
end

def plain?(m, x, y)
  t = TS[m.tileset_id]
  [0, 1, 2].all? { |z| (i = m.data[x, y, z]) == 0 || t.terrain_tags[i] == 0 }
end

def near_event?(b, x, y, r)
  b.map.events.values.any? { |e| (e.x - x).abs <= r && (e.y - y).abs <= r }
end

def spaced?(spots, x, y, d)
  spots.none? { |sx, sy| (sx - x).abs + (sy - y).abs < d }
end

# Laundry: in front of homes (not shops, halls or the Center), two tiles beside the door and one below.
NOT_HOME = /Pokemon|Center|Hall|Arms|Blades|Lottery|Council|Morninglord|Northlook|Inn|Shop|Mart|Tavern|Temple|Sailing|Triglio/
{ 2001 => 3, 2021 => 3 }.each do |id, max|
  b = reopen(id)
  clear_props(b, "Laundry")
  spots = []
  b.map.events.values.select { |e| e.name.start_with?("Door ") && e.name !~ NOT_HOME }.sort_by { |e| [e.y, e.x] }.each do |d|
    break if spots.size >= max
    s = [[d.x + 2, d.y + 1], [d.x - 2, d.y + 1]].find { |x, y| floor?(b.map, x, y) && floor?(b.map, x, y + 1) && !occupied?(b, x, y) && !near_event?(b, x, y, 0) }
    spots << s if s
  end
  spots.each { |x, y| b.event(x, y, "Laundry", [prop_page("FT_prop_laundry", 2)]) }
  resave(b, id)
  puts "#{id}: #{spots.size} laundry lines"
end

# Sap drips: on the floor at the foot of a root wall, away from people and doors, spread out.
{ 2055 => 4, 2057 => 4, 2058 => 4, 2066 => 4 }.each do |id, max|
  b = reopen(id)
  clear_props(b, "Sap drip")
  m, spots = b.map, []
  rng = Random.new(id)
  cells = (1...m.height).flat_map { |y| (0...m.width).map { |x| [x, y] } }.shuffle(random: rng)
  cells.each do |x, y|
    break if spots.size >= max
    next if !floor?(m, x, y) || !wall?(m, x, y - 1) || near_event?(b, x, y, 2) || !spaced?(spots, x, y, 8)
    spots << [x, y]
  end
  spots.each { |x, y| b.event(x, y, "Sap drip", [prop_page("FT_prop_sapdrip", 2)]) }
  resave(b, id)
  puts "#{id}: #{spots.size} sap drips"
end

# Ice twinkles: on open ice and snow (plain floor: no grass, no water), spread out, each row of the sheet a
# different phase so they glint in turn.
{ 2101 => 12, 2034 => 12, 2079 => 20 }.each do |id, max|
  b = reopen(id)
  clear_props(b, "Ice twinkle")
  m, spots = b.map, []
  rng = Random.new(id)
  cells = (0...m.height).flat_map { |y| (0...m.width).map { |x| [x, y] } }.shuffle(random: rng)
  cells.each do |x, y|
    break if spots.size >= max
    next if !floor?(m, x, y) || !plain?(m, x, y) || near_event?(b, x, y, 1) || !spaced?(spots, x, y, 6)
    spots << [x, y]
  end
  spots.each_with_index { |(x, y), i| b.event(x, y, "Ice twinkle", [prop_page("FT_prop_twinkle", [2, 4, 6, 8][i % 4])]) }
  resave(b, id)
  puts "#{id}: #{spots.size} ice twinkles"
end

# --- A-05 spore beds, A-07 bees, A-08 snow birds, A-16 Wennen burrows -------------------------------------------
# Scattered the same way as the twinkles: plain floor, away from people and doors, spread out; a seeded shuffle so a
# rebuild puts them in the same places.
def scatter(id, name, graphic, max, gap, near, dirs)
  b = reopen(id)
  clear_props(b, name)
  m, spots = b.map, []
  rng = Random.new(id * 7 + name.size)
  cells = (1...m.height - 1).flat_map { |y| (1...m.width - 1).map { |x| [x, y] } }.shuffle(random: rng)
  cells.each do |x, y|
    break if spots.size >= max
    next if !floor?(m, x, y) || !plain?(m, x, y) || near_event?(b, x, y, near) || !spaced?(spots, x, y, gap)
    spots << [x, y]
  end
  spots.each_with_index { |(x, y), i| b.event(x, y, name, [prop_page(graphic, dirs[i % dirs.size])]) }
  resave(b, id)
  puts "#{id}: #{spots.size} x #{name}"
end

{ 2068 => 10, 2070 => 10, 2171 => 8 }.each { |id, n| scatter(id, "Spore bed", "FT_prop_spores", n, 5, 1, [2, 4, 6]) }
{ 2001 => 3, 2012 => 3, 2020 => 3, 2021 => 2, 2031 => 2, 2035 => 2 }.each { |id, n| scatter(id, "Snow birds", "FT_prop_birds", n, 9, 2, [2, 4, 6, 8]) }
{ 2021 => 2, 2022 => 2, 2055 => 2 }.each { |id, n| scatter(id, "Wennen burrow", "FT_prop_wennen", n, 10, 2, [2, 4, 6, 8]) }

# Bees over Good Mead's two hive boxes (build_tentowns: the HAY stamps at (9,5) and (11,5)).
b = reopen(2031)
clear_props(b, "Bees")
[[9, 5, 2], [11, 5, 4]].each { |x, y, d| b.event(x, y, "Bees", [prop_page("FT_prop_bees", d)]) }
resave(b, 2031)
puts "2031: 2 bees"

# A-14 snow sliding off a roof: on the ground two tiles beside a door, under the building's face, in the snowy
# towns. The route waits several seconds, then turns through the sheet's rows (falling, landing, the puff) and back
# to the empty one; each roof waits a different time so they don't slide together.
SLIDE_ROUTE = lambda { |wait| [[15, [wait]], [17, []], [15, [2]], [18, []], [15, [2]], [19, []], [15, [4]], [16, []]] }
{ 2001 => 3, 2012 => 3, 2031 => 2, 2035 => 2, 2021 => 2 }.each do |id, max|
  b = reopen(id)
  clear_props(b, "Roof snow")
  spots = []
  b.map.events.values.select { |e| e.name.start_with?("Door ") }.sort_by { |e| [e.y, e.x] }.each do |d|
    break if spots.size >= max
    s = [[d.x + 2, d.y + 1], [d.x - 2, d.y + 1]].find do |x, y|
      floor?(b.map, x, y) && wall?(b.map, x, y - 1) && !occupied?(b, x, y) && !near_event?(b, x, y, 0) && spaced?(spots, x, y, 4)
    end
    spots << s if s
  end
  spots.each_with_index do |(x, y), i|
    b.event(x, y, "Roof snow", [{ graphic: "FT_prop_snowslide", direction: 2, through: true, always_on_top: false,
                                  walk_anime: false, step_anime: false, direction_fix: false, move_frequency: 6,
                                  move_route: SLIDE_ROUTE.call(110 + 37 * i + (id % 5) * 11) }])
  end
  resave(b, id)
  puts "#{id}: #{spots.size} x Roof snow"
end

# --- A-09 ice fishers, A-10 a brazier and two villagers warming their hands, A-17 a shoveller ---------------------
# (tools/townsfolkgen.py: the base game's own villagers at work.) Solid, like any villager, and placed only where
# the tiles round them stay open, so they never block a way through.
def open_spot?(b, x, y, r)
  m = b.map
  (-1..1).all? { |dx| (-1..1).all? { |dy| floor?(m, x + dx, y + dy) } } && plain?(m, x, y) && !near_event?(b, x, y, r)
end

def first_spot(b, id, name, &ok)
  rng = Random.new(id * 13 + name.size)
  m = b.map
  (2...m.height - 2).flat_map { |y| (2...m.width - 2).map { |x| [x, y] } }.shuffle(random: rng).find(&ok)
end

def worker(graphic, dir)
  { graphic: graphic, direction: dir, step_anime: true, walk_anime: false, direction_fix: true, through: false }
end

[2001, 2012].each do |id|
  b = reopen(id)
  %w[Brazier Warming\ hands].each { |n| clear_props(b, n) }
  s = first_spot(b, id, "Brazier") { |x, y| open_spot?(b, x, y, 3) && open_spot?(b, x - 1, y, 0) && open_spot?(b, x + 1, y, 0) }
  if s
    x, y = s
    b.event(x, y, "Brazier", [{ graphic: "FT_prop_brazier", direction: 2, step_anime: true, walk_anime: false, direction_fix: true }])
    b.event(x - 1, y, "Warming hands", [worker("FT_town_warm_a", 6)])
    b.event(x + 1, y, "Warming hands", [worker("FT_town_warm_b", 4)])
  end
  resave(b, id)
  puts "#{id}: brazier #{s.inspect}"
end

{ 2001 => 6, 2012 => 4, 2035 => 6 }.each do |id, dir|
  b = reopen(id)
  clear_props(b, "Shovelling")
  s = first_spot(b, id, "Shovelling") { |x, y| open_spot?(b, x, y, 3) }
  b.event(*s, "Shovelling", [worker("FT_town_shovel", dir)]) if s
  resave(b, id)
  puts "#{id}: shoveller #{s.inspect}"
end

{ 2035 => %w[FT_town_fish_a FT_town_fish_b], 2034 => %w[FT_town_fish_b] }.each do |id, gs|
  b = reopen(id)
  clear_props(b, "Ice fishing")
  gs.each_with_index do |g, i|
    s = first_spot(b, id, "Ice fishing #{i}") { |x, y| open_spot?(b, x, y, 3) && floor?(b.map, x + 2, y) }
    b.event(*s, "Ice fishing", [worker(g, 6)]) if s
    puts "#{id}: fisher #{s.inspect}"
  end
  resave(b, id)
end
