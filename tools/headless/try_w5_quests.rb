# Rootspire as a living city (W5): the rest of the city's quests, played in
# the real game: Kelyn's secret, Eren, Selrae and Eline, the Frozen Cellar,
# the Amber Experiment, the Chronal Debt, Eirwen's sigil and ritual, Alerion's
# Echoes at the Wall, the Frostfell portal, the Requiem's vault, the
# investigation after the festival, Council Petitions and the Festival of
# Balance, Alberica's Codex, Alerion's library days, Meat Meat's days.
require_relative "driver"
HL.start_up
HL.quiet = !ENV["V"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1], [/What will you take/, ->(_t, c) { c.size - 1 }]]
HL.new_game
HL.frames(60)
T = FrostThaw
$ok = 0; $bad = 0
def ok(name, cond, extra = nil)
  if cond then $ok += 1; puts "ok   #{name}" else $bad += 1; puts "FAIL #{name}#{extra ? ": #{extra}" : ''}" end
end
def ev(name) = $game_map.events.values.find { |e| (e.name == name || e.name.start_with?(name)) && e.instance_variable_get(:@page) }
def talk(name)
  e = ev(name)
  return HL.problem("no event #{name} on #{$game_map.map_id}") if !e
  HL.talk_to(e); HL.settle(4000)
end
def heal = $Trainer.party.each { |pk| pk.heal }
def at(map, x, y) = (HL.warp(map, x, y, 8); HL.frames(8); T.apply_rootspire_life_switches; HL.frames(2))
def rest = (at(2053, 4, 7); talk("Hellen"); heal)

T.state[:companions] = [:alberica, :reptin, :alerion, :shade, :meat_meat]
%i[reversal rootspire_arrived met_hellen wardens_emeritus heard_wall_rule].each { |f| T.set_flag(f) }
$Trainer.party << Pokemon.new(:FORGEL, 80) while $Trainer.party.size < 3
$Trainer.party.each { |pk| pk.level = 80; pk.calc_stats; pk.heal }
$Trainer.money = 100_000
rest

# Selrae courts the knife-bearer (Shade, before the Rift)
at(2054, 16, 13); talk("Selrae Vorn")
ok("Selrae courts the Sparkbearer with the black-ice dagger, and names the White Womb", T.flag?(:selrae_courted) && T.flag?(:selrae_white_womb))
# Eline tries to convert the knife-bearer at the rite
at(2056, 14, 17); talk("Matron Eline"); heal
ok("Eline tries to bring the Sparkbearer in, and names the Winter Matron", T.flag?(:eline_named_selrae))
ok("...and the rite is stopped", T.flag?(:rite_stopped))
at(2054, 16, 13); talk("Selrae Vorn")

# the twins, the orb, Kelyn at night
T.state[:companions] = [:alberica, :reptin, :alerion, :glimmer, :meat_meat]
%i[twins_met glimmer_joined].each { |f| T.set_flag(f) }
at(2061, 22, 26); talk("Sister Ilse"); heal
rest; rest
at(2061, 22, 26)
ok("Kelyn is at the orb by night", ev("High Speaker at the orb"))
T.set_flag(:autumn_note)
HL.answers.unshift([/What do you tell Kelyn/, 1])
talk("High Speaker at the orb")
ok("Kelyn's secret, and Autumn's plot named", T.flag?(:kelyn_secret) && T.flag?(:kelyn_warned))

# Eren and the gift of memory
at(2183, 12, 22); HL.frames(5)
talk("Eren Frostborn")
ok("Eren refuses the gift of memory and becomes Alerion's pupil", T.flag?(:eren_pupil) && T.flag?(:eren_settled))

# the Amber Experiment
at(2050, 45, 30); talk("Guild assessor")
ok("the Amber Experiment: the fuel that whispers", T.flag?(:amber_tested))

# the Echo Gate: the wraiths, then Alerion's reflection (A1)
HL.answers.unshift([/Which way\?/, ->(t, c) { $echo_pick ||= [0, 0, 1, 0]; $echo_pick.shift || 0 }])
at(2050, 9, 22); HL.frames(2)
T.echo_wraiths; heal
ok("the Echo Gate whispers, and Talion is foreshadowed", T.flag?(:echo_wraiths_down) && T.flag?(:talion_foreshadowed))
ok("Alerion's Echoes at the Wall: the reflection comes home", T.flag?(:alerion_reflection))

# the library: Eirwen's sigil and ritual; Wynsnow's Chronal Debt; the sigils researched
T.set_flag(:key_found); T.set_flag(:canticle_learned); T.set_flag(:lecture_done); T.set_flag(:grafting)
at(2062, 7, 6); talk("Eirwen Solglass")
ok("Eirwen's Frostshard Sigil (:sigil_eirwen)", T.flag?(:sigil_eirwen) && ($PokemonBag.pbQuantity(:FT_FROSTSIGIL) rescue 0) >= 2)
talk("Eirwen Solglass")
ok("Eirwen's ritual: a day of the frozen past", T.flag?(:eirwen_ritual))
at(2063, 13, 7); talk("Professor Wynsnow")
ok("Wynsnow's Chronal Debt offered (and refused)", T.flag?(:chronal_debt_done) && T.flag?(:wynsnow_confessed))
talk("Professor Wynsnow")
ok("the two sigils point to Ithryn Athis", T.flag?(:sigils_researched))
at(2062, 5, 9); talk("The Lorn Scribe")
ok("the Lorn Scribe keeps Alberica's pages: the Memory Codex", ($PokemonBag.pbHasItem?(:FT_MEMORYCODEX) rescue false))
rest
ok("the Codex's four fragments, the next morning", T.flag?(:codex_fragments), "rs_day #{T.rs_day}")

# Alerion's library days
6.times do
  break if T.dt_done(:alerion) >= 6
  if T.dt_done(:alerion) == 3
    at(2181, 6, 7); talk("Nivva Sunwick")
  else
    at(2062, 12, 6); talk("Alerion's desk")
  end
  rest
end
ok("Alerion's Days 2-7, with Day 5's six potions", T.dt_done(:alerion) >= 6 && ($PokemonBag.pbHasItem?(:FT_RENEWALDRAUGHT) rescue false), "done #{T.dt_done(:alerion)}")
ok("...and the golden key's tunnels", T.flag?(:golden_key_tunnels))
ok("Meat Meat's days: Razzilith's warning and the first flight", T.flag?(:razzy_summer_warning) && T.flag?(:razzy_first_flight))

# the festival, then the investigation
T.set_flag(:badge_hearth)
rest                              # Hellen's festival night
HL.settle(3000)
ok("the festival's last night", T.flag?(:festival_night) && T.flag?(:effigy_saved))
rest
ok("the Rootwardens at the door after the festival", T.flag?(:rootwardens_at_door))
at(2050, 10, 21); talk("Scorch marks")
ok("the scorch marks and the chardalyn fragment", T.flag?(:chardalyn_found))
at(2062, 7, 6); talk("Eirwen Solglass")
ok("Eirwen's private audience: the Twenty Stones under the city", T.flag?(:eirwen_audience))

# the Frozen Cellar
T.set_flag(:cellar_hint); T.apply_rootspire_life_switches
at(2180, 33, 46); HL.face(8); HL.step(8); HL.settle(2000)
ok("down into the Frozen Cellar under the old brewery", $game_map.map_id == 2188, "on #{$game_map.map_id}")
HL.settle(3000)
$game_map.events.values.select { |e| e.name.start_with?("Trainer") }.each do |e|
  next if $game_self_switches[[2188, e.id, "A"]]
  HL.talk_to(e); HL.settle(5000); heal
end
talk("Frozen Flame altar"); talk("Eira Voss"); heal
ok("Eira Voss and the Frozen Flame", T.flag?(:cellar_cleared) && T.flag?(:souls_ledger_seen),
   "cleared #{T.flag?(:cellar_cleared)} ledger #{T.flag?(:souls_ledger_seen)} on #{$game_map.map_id} at #{HL.pos}; #{HL.problems.last(3).inspect}")

# the Requiem's vault; a Frostfell portal after an auroral storm
T.set_flag(:mira_freed)
at(2055, 34, 8); talk("Captain's strongbox")
ok("the Requiem's relic vault: Razzy's scale core", ($PokemonBag.pbHasItem?(:FT_SCALECORE) rescue false))
T.night_auroral_storm; heal
at(2061, 32, 7); talk("Portal to the Frostfell"); heal
ok("the Frostfell portal and the ice-winged angel", T.flag?(:frostfell_seen))

# after the Forge: petitions and the Festival of Balance
%i[engine_dead ash_exposed heist_exposed].each { |f| T.set_flag(f) }
at(2054, 10, 16); talk("Petitioners' bench")
ok("Council Petitions win the Council's support", T.flag?(:council_support))
talk("Petitioners' bench")
ok("the Festival of Balance: Rootspire as home", T.flag?(:rootspire_haven))

puts "\n#{$ok}/#{$ok + $bad} W5 quest checks passed"
puts HL.problems.uniq.first(10).inspect
