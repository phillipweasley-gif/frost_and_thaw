# Fights Chapter 4's wild bosses (Norsu, Koran & Kanan, the mirror-wights) with
# a fair team: the starter at the stage its level gives it, plus two catches.
require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
HL.new_game
HL.frames(200)
CATCH = (ENV["CATCH"] || "SPHEAL,STANTLER").split(",").map(&:to_sym)
N = (ENV["N"] || 4).to_i
BOSSES = ENV["CH7"] ? {
  "Selrae (40-42)"       => [42, -> { FrostThaw.trainer(:selrae, nil) }]
} : ENV["CH5"] ? {
  "ice mephits (28/28)"   => [28, -> { FrostThaw.boss_battle(FrostThaw.named_mon(:SNORUNT, 28, "Ice mephit"), FrostThaw.named_mon(:SNORUNT, 28, "Ice mephit")) }],
  "mother yeti (31)"      => [31, -> { FrostThaw.boss_battle(FrostThaw.named_mon(:YETITAN, 31, "Yeti")) }],
  "ghouls (29/30)"        => [30, -> { FrostThaw.boss_battle(FrostThaw.named_mon(:DUSKULL, 29, "Ghoul"), FrostThaw.named_mon(:BANETTE, 30, "Ghoul")) }],
  "gate guardians (30/31)" => [31, -> { FrostThaw.boss_battle(FrostThaw.named_mon(:MAROWAK, 30, "Guardian"), FrostThaw.named_mon(:B105H312, 31, "Guardian")) }],
  "Kanan & troll (33/33)" => [33, -> { FrostThaw.boss_battle(FrostThaw.named_mon(:B272H310, 33, "Kanan"), FrostThaw.named_mon(:B68H221, 33, "Ice troll")) }],
  "reflection (36)"       => [35, -> { FrostThaw.boss_battle(FrostThaw.named_mon(:B124H255, 36, "Reflection")) }]
} : {
  "Norsu (L28)"          => [28, -> { FrostThaw.boss_battle(FrostThaw.named_mon(:MAMOSWINE, 28, "Norsu")) }],
  "Koran & Kanan (26/27)" => [27, -> { FrostThaw.boss_battle(FrostThaw.named_mon(:B503H272, 26, "Koran"), FrostThaw.named_mon(:B272H310, 27, "Kanan")) }],
  "mirror-wight 2 (L27)" => [27, -> { FrostThaw.boss_battle(FrostThaw.named_mon(:B429H427, 27, "Mirror-wight")) }]
}
HL.warp(2035, 26, 22) rescue nil
FrostThaw::STARTERS.map { |s| s[:species] }.each do |st|
  BOSSES.each do |name, (lv, fight)|
    wins = 0
    N.times do
      sp = st
      while (ns = Pokemon.new(sp, lv).check_evolution_on_level_up(false)) && ns != sp do sp = ns end
      $Trainer.party.clear
      ([sp] + CATCH).each { |s| pk = Pokemon.new(s, lv); HL.sensible_moves(pk, FrostThaw::STARTER_MOVES[s]); $Trainer.party << pk }
      $game_switches[Settings::NO_MONEY_LOSS] = true
      wins += 1 if (fight.call rescue (puts "  error #{$!.message}"; false))
    end
    puts format("%-10s %-24s won %d/%d", st, name, wins, N)
  end
end
