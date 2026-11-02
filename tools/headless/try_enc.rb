require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
HL.new_game
HL.frames(100)
[2039, 2041].each do |m|
  HL.warp(m, 20, 20) rescue nil
  HL.frames(5)
  $PokemonEncounters.setup(m)
  counts = Hash.new(0)
  2000.times { e = $PokemonEncounters.choose_wild_pokemon(:Land); counts[e[0]] += 1 if e }
  puts "map #{m}: " + counts.sort_by { |k, v| -v }.map { |k, v| "#{k} #{v}" }.join(", ")
end
pk = Pokemon.new(:YETOT, 25)
puts "YETOT: #{pk.name} #{pk.species_data.type1}/#{pk.species_data.type2} moves #{pk.moves.map(&:id).inspect} ability #{pk.ability.name}"
