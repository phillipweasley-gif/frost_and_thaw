# Companions walk in to speak, and step back out when you get control again.
require_relative "story_run"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
FT = FrostThaw unless defined?(FT)
ok = ->(c, m) { puts "#{c ? 'ok  ' : 'FAIL'} #{m}"; $fails = ($fails || 0) + (c ? 0 : 1) }
HL.new_game; HL.frames(200)
FT.state[:companions] = %i[alberica reptin alerion shade shimmer]
FT.set_flag(:met_party)
HL.warp(2006, 9, 10, 8)
ep = $game_map.events.values.find { |e| e.name =~ /Epheris/ }
HL.talk_to(ep); HL.settle(4000)
stand = -> { $game_map.events.values.select { |e| e.name.to_s.start_with?("stage_") } }
puts "after the scene: #{stand.().map { |e| [e.name, e.x, e.y, e.through] }.inspect}"
puts "interpreter running? #{pbMapInterpreterRunning?} msg? #{$game_temp.message_window_showing} player #{HL.pos} forcing #{$game_player.move_route_forcing}"
HL.frames(60)
ok.(stand.().empty?, "the companions have gone once you have control (#{stand.().size} left)")
r = HL.route(9, 11)
ok.(r, "you can walk to the door (#{r.inspect})")
puts($fails.to_i.zero? ? "ALL OK" : "#{$fails} FAILED")
