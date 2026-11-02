require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0]]
HL.new_game; HL.frames(200)
$PokemonGlobal.repel = 999999 rescue nil
FrostThaw.set_flag(:met_razzy)
[[16, 31, 4], [16, 30, 4], [14, 27, 6], [14, 28, 6], [16, 29, 4], [17,31,8],[15,31,8]].each do |x, y, d|
  HL.warp(2011, x, y, d)
  ok = $game_map.passable?(x, y, 0, $game_player)
  HL.step(d); HL.frames(40)
  puts "from (#{x},#{y}) pressing #{d} -> #{HL.pos}  (start passable=#{ok})"
end
p HL.slopes
