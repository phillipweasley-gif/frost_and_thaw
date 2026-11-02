require_relative "driver"
HL.start_up
ENV["MONS"].split(",").each do |s|
  pk = Pokemon.new(s.to_sym, 5); d = pk.species_data
  b = d.base_stats
  puts "#{s} #{pk.name} #{[d.type1, d.type2].uniq.join('/')} base HP#{b[:HP]} Atk#{b[:ATTACK]} Def#{b[:DEFENSE]} SpA#{b[:SPECIAL_ATTACK]} SpD#{b[:SPECIAL_DEFENSE]} Spe#{b[:SPEED]} (total #{b.values.sum}) abilities #{d.abilities.map { |a| GameData::Ability.get(a).name }.join('/')}"
end
