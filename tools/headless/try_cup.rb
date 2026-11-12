# The Cup of Seasons, with real battles: every round's team loads, the battles
# run to an end, and a run either crowns you or puts you out.
#   PIF_DIR=/home/claude/pifrun_a ruby tools/headless/try_cup.rb      (LV=80 N=2)
require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1], [/Which Pokémon/, 0]]
HL.new_game
HL.frames(200)
FT = FrostThaw unless defined?(FT)
fails = 0
ok = ->(c, m) { puts "#{c ? 'ok  ' : 'FAIL'} #{m}"; fails += 1 unless c }
lv = (ENV["LV"] || 80).to_i
%i[GYARADOS ARCANINE MACHAMP ALAKAZAM GENGAR].each { |sp| pbAddPokemonSilent(Pokemon.new(sp, lv)) }
$Trainer.party.each { |p| p.level = lv; p.reset_moves; p.calc_stats; p.heal }
FT.set_flag(:game_complete); FT.set_flag(:beat_tamsin)
ok.(FT.cup_open?, "the Cup opens after the credits")
FT.cup_pool.each_with_index do |k, i|
  t = FT::CUP_TEAMS[k]
  v = FT.cup_register(t[0], t[1], t[2], t[3], t[4], i % 3)
  tr = GameData::Trainer.get(t[0], t[1], v) rescue nil
  ok.(tr && tr.pokemon.size == 6 && (tr.to_trainer rescue nil), "#{t[1]} round #{i % 3 + 1}: six Pokémon, Lv #{tr&.pokemon&.map { |p| p[:level] }&.minmax&.join('-')}")
end
ENV["HL_BATTLE"] = "1"
results = []
(ENV["N"] || 2).to_i.times do
  $Trainer.party.each(&:heal)
  n = HL.log.size
  r = FT.run_cup
  results << r
  txt = HL.log[n..].join("\n")
  puts "  reached: " + HL.log[n..].grep(/round\.|semi-final\.|^The final|out of the Cup|I WON|It's a mug|AGAIN/).map { |l| l[0, 40] }.join(" | ")
  ok.(txt =~ /Hall of Seasons/ && (r ? txt =~ /The Cup\. It's a mug|Again\. AGAIN/ : txt =~ /out of the Cup|I WON/), "a run ends properly (#{r ? 'champion' : 'out'})")
end
ok.(results.none?(&:nil?), "every run returned")
ok.(!results.any? || FT.flag?(:cup_champion), "a win makes you champion")
ok.($Trainer.party.all? { |p| p.hp == p.totalhp }, "the team is healed after the Cup")
puts(fails.zero? ? "ALL OK (#{results.inspect})" : "#{fails} FAILED")
