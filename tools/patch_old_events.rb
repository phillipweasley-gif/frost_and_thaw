# One-off fixes to already-built maps (the builders have the same changes):
#  - 2011: the Frost-light, once the egg is taken, stays as a faint glow you can
#    look at (a blank event on open ground only answers if you stand on it).
#  - 2026: the Glade altar's events sit on the altar itself, not in front of it.
require_relative "ft_common"
m = reopen(2011)
ev = m.map.events.values.find { |e| e.name == "Frost-light" }
pg = ev.pages[1]
pg.graphic.instance_variable_set(:@character_name, "BW (134)")
pg.graphic.instance_variable_set(:@opacity, 90)
pg.instance_variable_set(:@through, false)
resave(m, 2011)
g = reopen(2026)
g.map.events.values.select { |e| e.name == "Altar" }.each { |e| e.y = 11 }
resave(g, 2026)
puts "patched 2011 and 2026"
