require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
HL.new_game
HL.frames(60)
$PokemonBag.pbStoreItem(:FT_SPORECHIME, 1)
$PokemonBag.pbStoreItem(:FT_SPORELANTERN, 1)
$PokemonGlobal.repel = 999999 rescue nil
HL.warp(2061, 12, 33); HL.frames(30); HL.settle(2000)
HL.step(8); HL.settle(2000)
puts(HL.log.any? { |l| l =~ /Sporechime tinkles: 2 trainers/ } ? "ok   the Sporechime counts the Canopy's two sky-sailors" : "FAIL no chime: #{HL.log.last(3)}")
n = HL.log.size
HL.step(2); HL.step(8); HL.settle(1000)
puts(HL.log[n..].none? { |l| l =~ /Sporechime/ } ? "ok   ...and only once per map" : "FAIL it chimed again")
