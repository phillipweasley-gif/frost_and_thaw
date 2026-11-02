# ASCII passability: ruby ascii_pass.rb <rxdata path> [x0 y0 w h]   (. walkable, # blocked, E event)
require_relative "rgss_stub"
TS = load_data("/home/claude/pif-682/Data/Tilesets.rxdata")
m = load_data(ARGV[0])
t = TS[m.tileset_id]
pass = lambda do |x, y|
  [2, 1, 0].each do |z|
    id = m.data[x, y, z]
    next if id == 0
    return false if t.passages[id] & 0x0f == 0x0f
    return true if t.priorities[id] == 0
  end
  true
end
x0, y0, w, h = (ARGV[1] ? ARGV[1..4].map(&:to_i) : [0, 0, m.width, m.height])
ev = {}
m.events.each_value { |e| ev[[e.x, e.y]] = true }
puts "    " + (x0...x0 + w).map { |x| (x % 10).to_s }.join
(y0...y0 + h).each do |y|
  puts y.to_s.rjust(3) + " " + (x0...x0 + w).map { |x| ev[[x, y]] ? "E" : (pass.(x, y) ? "." : "#") }.join
end
