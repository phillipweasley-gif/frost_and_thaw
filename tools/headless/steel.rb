require_relative "driver"
HL.start_up
list = GameData::Species::DATA.values.select { |s| s.is_a?(GameData::Species) && s.form == 0 && s.id_number <= 600 && [s.type1, s.type2].include?(:STEEL) }.uniq(&:id)
list.sort_by(&:id_number).each do |s|
  evo_from = (s.get_previous_species rescue s.id)
  puts "#{s.id_number}\t#{s.name}\t#{[s.type1, s.type2].uniq.join('/')}\tfrom #{evo_from == s.id ? '-' : GameData::Species.get(evo_from).name}"
end
