require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0]]
HL.new_game; HL.frames(200)
%w[met_party badge_targos razzy_egg].each { |f| FrostThaw.set_flag(f.to_sym) }
$PokemonGlobal.repel = 999999
$PokemonGlobal.pokecenterMapId = 2013; $PokemonGlobal.pokecenterX = 10; $PokemonGlobal.pokecenterY = 7; $PokemonGlobal.pokecenterDirection = 8
HL.warp(2015, 10, 19, 8)
ev = $game_map.events.values.find { |e| e.name == "Duvessa" }
$headless_watchdog = Graphics.frame_count + 50000
r = HL.walk_to(ev.x, ev.y, adjacent: true) rescue :stuck
puts "weak attempt: #{r}, now map #{$game_map.map_id} #{HL.pos}"
pos = $game_map.events.values.select { |e| e.name =~ /Trainer/ }.map { |e| "#{e.name}@(#{e.x},#{e.y}) A=#{$game_self_switches[[2015, e.id, 'A']]}" } if $game_map.map_id == 2015
puts pos.inspect if pos
$Trainer.party.each { |p| p.level = 60; p.calc_stats; p.heal }
HL.warp(2015, 10, 19, 8)
puts "back in gym: trainers " + $game_map.events.values.select { |e| e.name =~ /Trainer/ }.map { |e| "(#{e.x},#{e.y}) A=#{$game_self_switches[[2015, e.id, 'A']]}" }.join(" ")
ev = $game_map.events.values.find { |e| e.name == "Duvessa" }
puts "route to Duvessa: #{HL.route(ev.x, ev.y, adjacent: true)&.size.inspect}"
r = HL.walk_to(ev.x, ev.y, adjacent: true)
puts "strong attempt: #{r} at #{HL.pos}; trainers now " + $game_map.events.values.select { |e| e.name =~ /Trainer/ }.map { |e| "(#{e.x},#{e.y})" }.join(" ")
