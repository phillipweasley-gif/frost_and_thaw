require_relative "driver"
HL.start_up
puts "started; FT version #{FrostThaw::VERSION rescue '?'}"
HL.answers = [[/Which adventure/, 1]]
Game.start_new
puts "after start_new: map #{$game_map.map_id} #{HL.pos} scene=#{$scene.class}"
HL.frames(200)
puts "map #{$game_map.map_id} #{HL.pos}"
