# Writes every fusion name involving the new Pokémon as JSON (for the review page).
src = File.read(File.expand_path("../tests/smoke_test.rb", __dir__))
cut = src.index("FT = FrostThaw unless defined?(FT)")
eval(src[0...cut], binding, File.expand_path("../tests/smoke_test.rb", __dir__))
FT = FrostThaw unless defined?(FT)
require "json"
FT.register_species
FT.apply_species_patches(true)
ours = (577..581).to_a
names = {}
(1..581).each { |n| names[n] = GameData::Species.get(n).name }
fus = {}
ours.each do |o|
  (1..581).each do |n|
    [[o, n], [n, o]].each do |h, b|
      fus["#{h}.#{b}"] = GameData::Species.get(:"B#{b}H#{h}").name rescue fus["#{h}.#{b}"] = "?"
    end
  end
end
File.write(ENV["OUT"], JSON.generate({ species: names, fusions: fus }))
puts fus.size
