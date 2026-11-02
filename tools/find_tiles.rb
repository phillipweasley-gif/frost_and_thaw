# Usage: ruby find_tiles.rb ROW0 ROW1 [tileset_id]  -> maps that use tiles in those tileset rows
require_relative "rgss_stub"
r0, r1, tsid = ARGV[0].to_i, ARGV[1].to_i, (ARGV[2] || 23).to_i
lo, hi = 384 + r0 * 8, 384 + r1 * 8 + 7
infos = load_data("/home/claude/pif-682/Data/MapInfos.rxdata")
res = []
Dir["/home/claude/pif-682/Data/Map[0-9][0-9][0-9]*.rxdata"].each do |f|
  id = f[/Map(\d+)/, 1].to_i
  m = load_data(f) rescue next
  next unless m.tileset_id == tsid
  d = m.data; xs = []; ys = []; n = 0
  (0...m.height).each { |y| (0...m.width).each { |x| 3.times { |z| t = d[x, y, z]; if t >= lo && t <= hi then n += 1; xs << x; ys << y end } } }
  res << [n, id, infos[id]&.name, xs.min, ys.min, xs.max, ys.max] if n > 0
end
res.sort_by { |r| -r[0] }.first(12).each { |r| puts r.inspect }
