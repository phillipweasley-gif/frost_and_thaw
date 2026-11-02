require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0]]
HL.new_game; HL.frames(200)
FrostThaw.set_flag(:met_party); FrostThaw.set_flag(:badge_targos); FrostThaw.set_flag(:met_razzy)
$Trainer.party.each { |p| p.level = 40; p.calc_stats }
pbAddPokemonSilent(Pokemon.new(:SPHEAL, 40))
$PokemonGlobal.repel = 999999 rescue nil
HL.warp(2011, 21, 31, 8)
puts "slopes: #{HL.slopes.size}"
fl = $game_map.events.values.find { |e| e.name == "Frost-light" }
puts "route to frost-light: #{HL.route(fl.x, fl.y, adjacent: true)&.size}"
$headless_watchdog = Graphics.frame_count + 60000
HL.quiet = false
r = HL.talk_to(fl)
puts "result #{r} at #{HL.pos}; flags #{FrostThaw.state[:flags].keys.join(' ')}"
HL.warp(2011, 21, 31, 8)
20.times do
  path = HL.route(fl.x, fl.y, adjacent: true)
  break if !path || path.empty?
  d = path.first
  before = HL.pos
  HL.step(d); HL.frames(30)
  puts "#{before} press #{d} -> #{HL.pos}   (plan #{path.first(6).join})"
end
