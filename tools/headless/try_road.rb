require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0]]
HL.new_game
HL.frames(200)
FrostThaw.set_flag(:met_party); FrostThaw.set_flag(:badge_targos); $Trainer.badges[0] = true
HL.warp(2001, 8, 41, 2)
HL.quiet = false
puts "at #{$game_map.map_id} #{HL.pos}"
HL.step(2); puts "after step down: #{$game_map.map_id} #{HL.pos}"
HL.step(2); puts "after step down: #{$game_map.map_id} #{HL.pos}"
HL.settle
puts "at #{$game_map.map_id} #{HL.pos} dir #{$game_player.direction}"
path = HL.route(12, 57, adjacent: true)
puts "route: #{path.inspect}"
5.times { |i| d = path[i]; HL.step(d); puts "step #{d}: #{$game_map.map_id} #{HL.pos}" }
