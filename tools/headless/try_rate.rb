require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0]]
HL.new_game; HL.frames(200)
FrostThaw.set_flag(:met_party); FrostThaw.set_flag(:badge_targos)
$Trainer.party.each { |p| p.level = 40; p.calc_stats }
map, x, y = (ENV["AT"] || "2011,13,36").split(",").map(&:to_i)
HL.warp(map, x, y, 6)
battles = 0; steps = 0
orig = method(:pbStartBattle) rescue nil
class PokeBattle_Battle; alias cnt_start pbStartBattle; def pbStartBattle; $nb = ($nb || 0) + 1; cnt_start; end; end
200.times do |i|
  d = i % 20 < 10 ? 6 : 4
  steps += 1 if HL.step(d)
  $Trainer.party.each(&:heal)
end
puts "map #{map}: #{steps} steps, #{$nb || 0} wild battles"
