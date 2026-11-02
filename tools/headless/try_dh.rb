require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
HL.new_game
HL.frames(200)
$Trainer.party.each { |pk| pk.level = 40; pk.calc_stats; pk.heal }
HL.warp(2035, 40, 2); HL.settle(3000)
ev = $game_map.events.values.find { |e| e.name =~ /Trainer/ }
puts "rorik: #{HL.talk_to(ev).inspect} at #{$game_map.map_id} #{HL.pos}"; puts HL.log.last(15)
HL.settle(3000)
pier = $game_map.events.values.find { |e| e.name =~ /dh_pier_fisher/ }
puts "pier fisher: #{HL.talk_to(pier).inspect}"
puts HL.log.last(6)
puts HL.problems
