require_relative "driver"
HL.start_up
HL.quiet = !ENV["V"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0]]
HL.new_game; HL.frames(200)
(ENV["FLAGS"] || "").split(",").each { |f| FrostThaw.set_flag(f.to_sym) }
FrostThaw.apply_story_switches rescue nil
FrostThaw.apply_chapter3_switches rescue nil
m, x, y = ENV["AT"].split(",").map(&:to_i)
$Trainer.party.each { |p| p.level = 40; p.calc_stats; p.heal }
$PokemonGlobal.repel = 999999
HL.warp(m, x, y, 2)
HL.frames(20); HL.settle(3000)
puts "at #{$game_map.map_id} #{HL.pos}"
seen = { [$game_player.x, $game_player.y] => true }; q = [[$game_player.x, $game_player.y]]
until q.empty?
  cx, cy = q.shift
  HL::DIRS.each { |d, (dx, dy)| n = [cx + dx, cy + dy]; next if seen[n] || !$game_map.valid?(*n) || !$game_player.passable?(cx, cy, d); seen[n] = true; q << n }
end
(0...$game_map.height).each { |yy| puts (0...$game_map.width).map { |xx| ev = $game_map.events.values.find { |e| e.x == xx && e.y == yy && e.instance_variable_get(:@page) }; [xx, yy] == [$game_player.x, $game_player.y] ? "@" : ev ? (seen[[xx, yy]] ? "E" : "e") : seen[[xx, yy]] ? "." : "#" }.join + " #{yy}" }
