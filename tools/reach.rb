# Reachability: from every arrival point on a map, which transfer and talkable
# events can actually be reached on foot? Usage: ruby reach.rb [map ids...]
require_relative "rgss_stub"
TS = load_data("/home/claude/pif-682/Data/Tilesets.rxdata")
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
want = ARGV.map(&:to_i)
arrivals = Hash.new { |h, k| h[k] = [] }
maps.each_value do |m|
  m.events.each_value { |e| e.pages.each { |pg| pg.list.each { |c| arrivals[c.parameters[1]] << [c.parameters[2], c.parameters[3]] if c.code == 201 } } }
end
arrivals[2001] << [24, 35]
bad = 0
(want.empty? ? maps.keys.sort : want).each do |id|
  m = maps[id] or next
  blocking = {}
  m.events.each_value do |e|
    pg = e.pages[0]
    solid = !pg.through && !(pg.graphic.character_name.to_s.empty? && pg.graphic.tile_id == 0)
    blocking[[e.x, e.y]] = true if solid
  end
  starts = arrivals[id].uniq
  next if starts.empty?
  seen = {}
  q = starts.select { |x, y| passable?(m, x, y) }
  q.each { |c| seen[c] = true }
  until q.empty?
    x, y = q.shift
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dx, dy|
      n = [x + dx, y + dy]
      next if seen[n] || !passable?(m, *n)
      seen[n] = true
      q << n unless blocking[n]
    end
  end
  m.events.each_value do |e|
    cmds = e.pages.flat_map(&:list)
    transfer = cmds.any? { |c| c.code == 201 }
    talk = cmds.any? { |c| c.code == 355 && c.parameters[0] =~ /FT\.|pbTrainerIntro/ }
    next unless transfer || talk
    next if e.pages[0].trigger == 3
    near = [[0, 0], [1, 0], [-1, 0], [0, 1], [0, -1]].any? { |dx, dy| seen[[e.x + dx, e.y + dy]] }
    next if near
    puts "#{id}: #{e.name} at (#{e.x},#{e.y}) can't be reached"
    bad += 1
  end
end
puts bad == 0 ? "everything reachable" : "#{bad} unreachable"
