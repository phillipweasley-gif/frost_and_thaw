# Rootspire as a living city (W5): plays the city's quests headlessly in the
# real game. Run with PIF_DIR set to a test copy (V=1 shows the dialogue).
require_relative "driver"
HL.start_up
HL.quiet = !ENV["V"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
HL.new_game
HL.frames(60)
T = FrostThaw
$ok = 0; $bad = 0
def ok(name, cond, extra = nil)
  if cond then $ok += 1; puts "ok   #{name}" else $bad += 1; puts "FAIL #{name}#{extra ? ": #{extra}" : ''}" end
end
def ev(name) = $game_map.events.values.find { |e| e.name == name || e.name.start_with?(name) }
def talk(name)
  e = ev(name)
  return HL.problem("no event #{name} on #{$game_map.map_id}") if !e
  HL.talk_to(e); HL.settle(4000)
end
def said_since(n) = HL.log[n..] || []
def heal = $Trainer.party.each { |pk| pk.heal }

T.state[:companions] = [:alberica, :reptin, :alerion, :glimmer, :meat_meat]
%i[reversal rootspire_arrived met_hellen wardens_emeritus heard_wall_rule twins_met glimmer_joined].each { |f| T.set_flag(f) }
$Trainer.party << Pokemon.new(:FORGEL, 75) while $Trainer.party.size < 3
$Trainer.party.each { |pk| pk.level = 75; pk.calc_stats; pk.heal }
$Trainer.money = 50_000

# --- the Halo at the orb, and the Bloom Guard visions --------------------------
HL.warp(2061, 22, 26, 8); HL.frames(10)
ok("the Halo splinter kneels at the orb", ev("Sister Ilse") && $game_switches[T::SW_ORB_HALO])
n = HL.log.size
talk("Sister Ilse"); heal
ok("they're driven off the orb first", T.flag?(:halo_orb_cleared))
ok("the visions play, with the Glimmer branch", T.flag?(:orb_visions) && said_since(n).any? { |l| l =~ /Sparkbearer\. My light is yours/ })
ok("...and Alerion's two fates", said_since(n).any? { |l| l =~ /sentinel at the ruins of the north/ })

# --- Glimmer's rite with Lumin: a day at a time --------------------------------
def rest
  HL.warp(2053, 4, 7, 8); HL.frames(5)
  talk("Hellen")
  heal
end
6.times do |i|
  HL.warp(2061, 20, 23, 8); HL.frames(5)
  talk("Lumin")
  rest
end
ok("Glimmer's seven-day rite, with the Acceptance", T.flag?(:glimmer_rite_done), "done #{T.dt_done(:glimmer)} day #{T.rs_day}")
ok("Brightmane answers, and shows the chardalyn dragon", T.flag?(:brightmane_answered) && T.flag?(:chardalyn_vision))
ok("the mane-braid pendant", ($PokemonBag.pbHasItem?(:FT_MANEBRAID) rescue false))
ok("the nights went by (Day #{T.rs_day})", T.rs_day >= 6)
ok("some of the ten night events have happened", (T.state[:nights_done] || []).size >= 1, (T.state[:nights_done] || []).inspect)
ok("Auril's omens came to Alberica", T.counter(:omens_seen) >= 1)

# --- Reptin: Arvik's training ---------------------------------------------------
6.times do
  HL.warp(2183, 11, 22, 8); HL.frames(5)
  talk("Arvik"); heal
  rest
end
ok("Arvik's Days 2-7, and the Loop-Band", ($PokemonBag.pbHasItem?(:FT_LOOPBAND) rescue false), "done #{T.dt_done(:reptin)}")

# --- the Oath of Roots, Rheven's counsel ---------------------------------------
T.set_flag(:crypt_open); $game_switches[3941] = true
HL.warp(2183, 11, 22, 8); HL.frames(5)
HL.answers.unshift([/Before the living tree/, 2])
talk("Rheven at the Armory")
ok("Rheven asks Reptin about violence and the hungry root", T.flag?(:rheven_counselled))
talk("Oath pillar"); heal
ok("the Oath of Roots", T.flag?(:oath_of_roots))
talk("Rheven at the Armory")
ok("the Still Beast hunt is set", T.flag?(:still_beast_asked))

# --- the Verdant Heist (Meat Meat's M1) ----------------------------------------
HL.warp(2054, 11, 17, 8); HL.frames(5)
talk("Darrus Fell")
ok("Darrus offers Meat Meat the reliquary job", T.flag?(:heist_offered))
HL.warp(2055, 29, 14, 8); HL.frames(10)
ok("the dock hatch is unbarred", $game_switches[T::SW_RUN_OPEN])
r = HL.walk_to(29, 13)
HL.settle(2000)
ok("down the hatch into the Smuggler's Run", $game_map.map_id == 2198, "on #{$game_map.map_id} #{r}")
[[10, 5], [25, 10], [18, 15], [8, 15]].each { |x, y| HL.walk_to(x, y); HL.settle(2000); heal }
ok("past the four wards", (T.state[:heist] || {})[:wins].to_i >= 3, T.state[:heist].inspect)
talk("Guild vault")
ok("the sealed reliquary", ($PokemonBag.pbHasItem?(:FT_RELIQUARY) rescue false))
HL.warp(2054, 11, 17, 8); HL.frames(5)
HL.answers.unshift([/What do you do with the reliquary/, 1])
talk("Darrus Fell")
ok("exposed before the Council (:heist_exposed)", T.flag?(:heist_exposed) && !T.flag?(:heist_delivered))

# --- Kethan, Ash and "A Season Too Long" ---------------------------------------
%i[warden_map_seen jorik_confessed].each { |f| T.set_flag(f) }
HL.warp(2183, 11, 22, 8); HL.frames(5)
talk("Captain Kethan"); talk("Captain Kethan")
ok("Kethan names the infiltrator", T.flag?(:ash_named))

# --- the Frozen Run --------------------------------------------------------------
T.set_flag(:ch7_started)
HL.warp(2055, 25, 6, 8); HL.frames(5)
talk("Captain Ivran")
ok("Ivran's sledge-ship sets out on the Frozen Run", $game_map.map_id == 2199)
HL.walk_to(44, 9); HL.settle(4000); heal
HL.walk_to(44, 9); HL.settle(4000)
talk("The far shore") if $game_map.map_id == 2199
ok("across the still half to the far shore", T.flag?(:frozen_run_done))

# --- Reptin's Pulse of the Blooming Fields -------------------------------------
HL.warp(2060, 30, 8, 8); HL.frames(10)
ok("the two spirits are quarrelling", $game_switches[T::SW_SPIRITS])
talk("Two spirits")
ok("the pulse brokered, and the berries", T.flag?(:fields_pulse) && ($PokemonBag.pbHasItem?(:OCCABERRY) rescue false))

# --- a watcher ------------------------------------------------------------------
T.set_flag(:met_bryn)
HL.warp(2050, 15, 15, 8); HL.frames(10)
talk("Watcher stalker"); heal
ok("Spring's Root-Hollow Stalker found", T.flag?(:watcher_stalker))

puts "\n#{$ok}/#{$ok + $bad} W5 city checks passed"
puts HL.problems.uniq.first(10).inspect
