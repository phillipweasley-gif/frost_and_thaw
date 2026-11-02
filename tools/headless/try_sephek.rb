require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0]]
HL.new_game; HL.frames(200)
%w[met_party badge_targos razzy_egg badge_bryn seen_sephek_bryn lonelywood_arrived rested_lonelywood shimmer_taken heart_of_ice].each { |f| FrostThaw.set_flag(f.to_sym) }
$PokemonGlobal.pokecenterMapId = 2021; $PokemonGlobal.pokecenterX = 14; $PokemonGlobal.pokecenterY = 24; $PokemonGlobal.pokecenterDirection = 2
$PokemonGlobal.repel = 999999
module FrostThaw; class << self; alias t_sss set_self_switch; def set_self_switch(ev, l = "A", v = true); puts "  set_self_switch(#{ev}, #{l}, #{v}) on map #{$game_map.map_id}"; t_sss(ev, l, v); end; end; end
HL.warp(2023, 12, 29, 8)
HL.frames(60); HL.settle(5000)
ev = $game_map.events.values.find { |e| e.name =~ /sephek_moon_temple/ } rescue nil
puts "after loss: map #{$game_map.map_id} #{HL.pos}; self A on 2023: #{$game_self_switches[[2023, 6, 'A']].inspect}"
$Trainer.party.each { |p| p.level = 60; p.calc_stats; p.heal }
HL.warp(2023, 12, 29, 8)
HL.frames(60); HL.settle(5000)
puts "second visit: defeated=#{FrostThaw.flag?(:sephek_defeated)}"
