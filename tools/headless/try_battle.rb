require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, (ENV["DIFF"] || 1).to_i], [/Which Pokémon/, (ENV["ST"] || 0).to_i]]
HL.new_game
HL.frames(200)
FrostThaw.set_flag(:met_party)
HL.warp((ENV["MAP"] || 2005).to_i, 10, 18) unless ENV["MAP"] == "none"
puts "battle map #{$game_map.map_id} weather #{$game_screen.weather_type}"
lv = (ENV["LV"] || 14).to_i
$Trainer.party.each { |p| p.level = lv; p.reset_moves; p.calc_stats; p.heal }
pbAddPokemonSilent(Pokemon.new(:SPHEAL, lv + 1)) if ENV["TWO"]
HL.quiet = false
ENV["HL_BATTLE"] = "1"
puts "party: " + $Trainer.party.map { |p| "#{p.name} L#{p.level} #{p.moves.map(&:name).join('/')} HP#{p.totalhp}" }.join("; ")
t = GameData::Trainer.get(:FT_SPEAKER, "Naerth", 0)
puts "Naerth: " + t.pokemon.inspect
won = 0
(ENV["N"] || 1).to_i.times do
  $Trainer.party.each(&:heal)
  r = pbTrainerBattle(:FT_SPEAKER, "Naerth", nil, false, 0, true)
  won += 1 if r
end
puts "won #{won}"
