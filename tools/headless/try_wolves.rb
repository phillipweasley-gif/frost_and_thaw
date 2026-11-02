require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, ENV["HERALD"] ? 1 : 0], [/Choose a difficulty/, 1]]
HL.answers << [/Which Herald|Who will you be|Which of the Heralds/, ->(t, c) { c.index { |x| x.to_s =~ /#{ENV['HERALD']}/i } || 0 }] if ENV["HERALD"]
HL.new_game
HL.frames(200)
puts "party: #{$Trainer.party.map { |p| "#{p.species} L#{p.level}" }.inspect}"
$Trainer.party.each { |pk| pk.level = (ENV["LV"] || 30).to_i; HL.sensible_moves(pk, nil); pk.calc_stats; pk.heal }; puts $Trainer.party.map { |p| p.moves.map(&:id).inspect }
FrostThaw.set_flag(:kids_freed); $game_switches[3919] = true
HL.warp(2039, 30, 15); HL.settle(3000)
begin
  FrostThaw.wolves_ambush(nil)
rescue Exception => e
  puts "ERR #{e.class}: #{e.message}"; puts e.backtrace.first(8)
end
puts "beaten: #{FrostThaw.flag?(:wolves_beaten)}"
puts HL.log.last(12)
puts HL.problems
