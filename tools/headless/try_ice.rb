require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0]]
HL.new_game; HL.frames(200)
FrostThaw.set_flag(:met_party); FrostThaw.set_flag(:badge_targos); FrostThaw.set_flag(:met_razzy)
$Trainer.party.each { |p| p.level = 30; p.calc_stats }
HL.warp(2011, 21, 31, 8)
HL.quiet = false
ev = $game_map.events.values.find { |e| e.x == 23 && e.y == 19 }
puts "trainer #{ev&.name} at #{ev&.x},#{ev&.y}; route: #{HL.route(23, 19, adjacent: true).inspect}"
$headless_watchdog = Graphics.frame_count + 6000
begin
  r = HL.talk_to(ev)
  puts "result #{r} pos #{HL.pos}"
rescue HeadlessStuck => e
  puts "STUCK at #{HL.pos} facing #{$game_player.direction} msg=#{$game_temp.message_window_showing} interp=#{pbMapInterpreterRunning?} moving=#{$game_player.moving?} trans=#{$game_temp.transition_processing} transfer=#{$game_temp.player_transferring} jumping=#{$game_player.jumping?} sliding=#{$PokemonGlobal.sliding rescue 0} in_menu=#{$game_temp.in_menu} diag=#{$game_player.instance_variable_get(:@diag_move_active)} spd=#{$game_player.move_speed_real rescue "?"} ms=#{$game_player.move_speed} fr=#{Graphics.frame_rate} rx=#{$game_player.real_x} ry=#{$game_player.real_y}"
  puts "running event: #{pbMapInterpreter.instance_variable_get(:@event_id)} list #{(pbMapInterpreter.instance_variable_get(:@list)||[]).map{|c| c.code}.inspect}" rescue nil
  puts e.backtrace.reject { |l| l.include?("internal") }.first(12)
end
