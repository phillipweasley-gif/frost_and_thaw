require_relative "driver"
HL.start_up
HL.answers = [[/Which adventure/, 1]]
$headless_watchdog = Graphics.frame_count + 5000
begin
  Game.start_new
  HL.frames(200)
rescue HeadlessStuck => e
  puts "STUCK: #{e.message}"; puts e.backtrace.first(25)
end
puts "map #{$game_map.map_id} #{HL.pos}"
