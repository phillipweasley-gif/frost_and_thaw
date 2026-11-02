require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0]]
HL.new_game; HL.frames(200)
HL.warp(2021, 14, 24, 2)
[[30, 12], [38, 11], [25, 12], [20, 13]].each do |x, y|
  tags = [0, 1, 2].map { |z| id = $game_map.data[x, y, z]; "#{id}:tag#{$game_map.terrain_tags[id]}" }
  puts "(#{x},#{y}) map.passable?=#{$game_map.passable?(x, y, 0)} dir4=#{$game_map.passable?(x, y, 4)} #{tags.join(' ')} terrain=#{$game_map.terrain_tag(x, y).id rescue '?'}"
end
