require_relative "driver"
HL.start_up
(ARGV.empty? ? %w[B216H208 B204H95 SNEASEL MEOWTH B52H227 B161H81 B109H228 MACHOP] : ARGV).each do |s|
  pk = Pokemon.new(s.to_sym, 15)
  d = pk.species_data
  puts "#{s} #{pk.name} #{[d.type1, d.type2].uniq.join('/')} stats HP#{pk.totalhp} Atk#{pk.attack} Def#{pk.defense} SpA#{pk.spatk} SpD#{pk.spdef} Spe#{pk.speed} ability #{pk.ability&.name} moves #{pk.moves.map { |m| GameData::Move.get(m.id).name }.join('/')}"
end
