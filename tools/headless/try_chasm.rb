require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0]]
HL.new_game; HL.frames(200)
FrostThaw.set_flag(:met_party); FrostThaw.set_flag(:badge_targos); FrostThaw.set_flag(:met_razzy)
HL.warp(2011, 21, 31, 8)
HL.quiet = false
puts "at #{$game_map.map_id} #{HL.pos}"
# reachable region by plain walking
seen = { [$game_player.x, $game_player.y] => true }; q = [[$game_player.x, $game_player.y]]
until q.empty?
  x, y = q.shift
  HL::DIRS.each { |d, (dx, dy)| n = [x + dx, y + dy]; next if seen[n] || !$game_map.valid?(*n) || !$game_player.passable?(x, y, d); seen[n] = true; q << n }
end
(0...$game_map.height).each { |y| puts (0...$game_map.width).map { |x| ev = $game_map.events.values.find { |e| e.x == x && e.y == y }; [x, y] == [$game_player.x, $game_player.y] ? "@" : ev ? (seen[[x, y]] ? "E" : "e") : seen[[x, y]] ? "." : " " }.join + " #{y}" }
