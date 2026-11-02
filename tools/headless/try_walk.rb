require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1]]
HL.new_game
HL.frames(200)
HL.quiet = false
evs = $game_map.events.values.reject { |e| e.character_name.to_s.empty? }
evs.each do |e|
  next if $game_map.map_id != 2001
  $headless_watchdog = Graphics.frame_count + 8000
  begin
    r = HL.talk_to(e)
  rescue HeadlessStuck => ex
    puts "STUCK talking to #{e.name}: #{ex.message}"; puts ex.backtrace.reject { |l| l.include?("<internal") }.first(14); break
  end
  puts "== #{e.name} (#{e.x},#{e.y}): #{r}; now map #{$game_map.map_id} #{HL.pos}"
  break if $game_map.map_id != 2001
end
puts HL.problems
