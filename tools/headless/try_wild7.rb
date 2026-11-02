require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
HL.new_game
HL.frames(100)
$Trainer.party.clear
3.times { |i| $Trainer.party << Pokemon.new(%i[B7H221 FORGEL B331H154][i], 45) }
[2057, 2058].each do |m|
  HL.warp(m, 10, 10) rescue nil
  HL.frames(10)
  %i[GOLBAT TANGELA HAUNTER PARASECT SUDOWOODO MISDREAVUS EXEGGCUTE GLOAMCAP].each do |sp|
    begin
      $Trainer.party.each(&:heal)
      r = pbWildBattle(sp, 40); puts "#{m} #{sp} -> #{r.inspect}"
    rescue => e
      puts "#{m} #{sp} ERROR #{e.class}: #{e.message}\n  " + e.backtrace.first(6).join("\n  ")
    end
  end
end
