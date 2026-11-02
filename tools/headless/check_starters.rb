require_relative "driver"
HL.start_up
FrostThaw::STARTER_MOVES.each_key do |sp|
  pk = FrostThaw.starter_pokemon(sp)
  puts "#{pk.name}: #{pk.moves.map { |m| GameData::Move.get(m.id).name }.join(', ')}"
end
