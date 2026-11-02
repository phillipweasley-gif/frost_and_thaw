# Print tile ids of a region per layer. Usage: ruby grid.rb MAPID x y w h
require_relative "rgss_stub"
id, x0, y0, w, h = ARGV.map(&:to_i)
m = load_data(format("/home/claude/pif-682/Data/Map%03d.rxdata", id))
3.times do |z|
  puts "layer #{z}"
  (y0...y0 + h).each { |y| puts (x0...x0 + w).map { |x| m.data[x, y, z].to_s.rjust(5) }.join }
end
