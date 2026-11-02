require_relative "driver"
HL.start_up
HL.quiet = !ENV["V"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
HL.new_game
HL.frames(60)
FrostThaw.state[:companions] = [:alberica, :reptin, :alerion, :shade, :meat_meat]
%i[reversal rootspire_arrived met_hellen wardens_emeritus].each { |f| FrostThaw.set_flag(f) }
$Trainer.party << Pokemon.new(:FORGEL, 70) if $Trainer.party.size < 2; $Trainer.party.each { |pk| pk.level = 70; pk.calc_stats; pk.heal }; puts "party #{$Trainer.party.map { |p| [p.species, p.level] }.inspect}"
HL.warp(2061, 31, 6); HL.frames(20); HL.settle(2000)
ev = $game_map.events.values.find { |e| e.name == "Lumen Shard" }
HL.talk_to(ev); HL.settle(2000)
puts(FrostThaw.flag?(:glimmer_joined) ? "FAIL Glimmer came before the twins" : "ok   before the twins, the Shard just waits")
FrostThaw.set_flag(:twins_met)
n = HL.log.size
HL.talk_to(ev); HL.settle(2000)
said = HL.log[n..]
puts(FrostThaw.flag?(:glimmer_joined) ? "ok   Glimmer steps through the Rift" : "FAIL no Glimmer")
puts(FrostThaw.companions.include?(:glimmer) && !FrostThaw.companions.include?(:shade) ? "ok   Glimmer joins, Shade leaves (#{FrostThaw.companions.inspect})" : "FAIL party #{FrostThaw.companions.inspect}")
puts(said.any? { |l| l =~ /SHADE: \.\.\.Glimmer\?/ } ? "ok   Shade knows him" : "FAIL no Shade line")
HL.frames(10)
sh = $game_map.events.values.find { |e| e.name == "Shade" }
HL.talk_to(sh); HL.settle(2000)
puts(HL.log.last(5).any? { |l| l =~ /keep watch|come through me|terrible with directions/ } ? "ok   Shade keeps watch at the Shrine" : "FAIL Shade at shrine: #{HL.log.last(3)}")
n = HL.log.size
HL.talk_to(ev); HL.settle(2000)
puts(HL.log[n..].any? { |l| l =~ /only light now/ } ? "ok   the Rift is empty afterwards" : "FAIL rift after")
puts HL.problems.uniq.inspect
