require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0]]
HL.new_game; HL.frames(200)
key = (ENV["KEY"] || "ranger_aldo").to_sym
type, name, party = FrostThaw::TRAINERS[key]
$Trainer.party.clear
[FrostThaw::STARTERS[(ENV["ST"]||0).to_i][:species], :SPHEAL, :GEODUDE].each { |s| pk = Pokemon.new(s, (ENV["LV"]||15).to_i); HL.sensible_moves(pk, FrostThaw::STARTER_MOVES[s]); $Trainer.party << pk }
begin
  pbTrainerBattle(type, name, nil, false, 0, true)
rescue StandardError => e
  puts e.message.lines.first(3); puts e.backtrace.first(12)
end
