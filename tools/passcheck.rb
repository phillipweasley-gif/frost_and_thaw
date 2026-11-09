require_relative "rgss_stub"
require_relative "ft_tilesets"
TS = FTTilesets.load("/home/claude/pif-682/Data/Tilesets.rxdata")
def passable?(m, x, y)
  return false if x < 0 || y < 0 || x >= m.width || y >= m.height
  t = TS[m.tileset_id]
  [2, 1, 0].each do |z|
    id = m.data[x, y, z]
    next if id == 0
    return false if t.passages[id] & 0x0f == 0x0f
    return true if t.priorities[id] == 0
  end
  true
end
maps = {}
Dir["../build/maps/Map*.rxdata"].each { |f| maps[f[/Map(\d+)/, 1].to_i] = load_data(f) }
problems = []
# arrival points of every transfer, plus the Targos start
targets = [[2001, 24, 35, "start"]]
maps.each do |id, m|
  m.events.each_value do |e|
    e.pages.each { |pg| pg.list.each { |c| targets << [c.parameters[1], c.parameters[2], c.parameters[3], "door from #{id} ev#{e.id}"] if c.code == 201 } }
    g = e.pages[0].graphic.character_name
    problems << "#{id}: NPC #{e.name} at (#{e.x},#{e.y}) stands on a wall" if !g.empty? && !passable?(m, e.x, e.y) && e.pages[0].trigger != 3
  end
end
targets.each do |mid, x, y, why|
  m = maps[mid] or next
  problems << "#{mid} (#{x},#{y}) arrival blocked (#{why})" unless passable?(m, x, y)
end
# each door in Targos must be reachable from the tile below it
puts problems.empty? ? "all arrival points and NPC spots are walkable" : problems
if ARGV[0]
  m = maps[ARGV[0].to_i]
  evs = {}; m.events.each_value { |e| evs[[e.x, e.y]] = e }
  (0...m.height).each { |y| puts y.to_s.rjust(2) + " " + (0...m.width).map { |x| evs[[x, y]] ? (evs[[x,y]].pages[0].list.any? { |c| c.code == 201 } ? "D" : "E") : (passable?(m, x, y) ? "." : "#") }.join }
end
