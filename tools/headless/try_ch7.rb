require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
HL.new_game
HL.frames(100)
%i[reversal rootspire_arrived met_hellen wardens_emeritus rite_stopped ch7_started heartroot_entered seal_open].each { |f| FrostThaw.set_flag(f) }
$Trainer.party.clear
3.times { |i| pk = Pokemon.new(%i[B7H221 FORGEL B331H154][i], 42); $Trainer.party << pk }
HL.warp(2057, 17, 29) rescue (puts "warp failed #{$!.message}")
HL.frames(30)
puts "at #{$game_map.map_id} #{HL.pos}"
r = HL.walk_to(15, 30); puts "walk #{r}"
HL.settle(5000)
HL.walk_to(9, 33); HL.settle(5000)
puts "now #{$game_map.map_id} #{HL.pos}"
puts HL.problems.inspect rescue nil
[:thrall_oren, :thrall_mae].each do |k|
  begin
    r = FrostThaw.trainer(k, nil); puts "#{k} -> #{r.inspect}"
  rescue => e
    puts "#{k} ERROR #{e.class}: #{e.message}\n  " + e.backtrace.first(8).join("\n  ")
  end
end
puts File.read("FrostThaw.log").lines.last(8).join rescue nil
