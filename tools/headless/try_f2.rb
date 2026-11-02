# F2's fixes, played in the real game (docs/fixes_F2.md): Hellen's errands and
# the old passages, the shrine vigil, the favour track, the Still Ones (shatter
# or help) and the Tree's lean, Alberica's straying and the omens' gate, the
# staff bonded at the Wall, Glimmer's Trial (the celestial envoy), the Cycle
# Canticle (failure, research, success, Verse XI), Eirwen's ledger dilemma,
# the festival on the seventh night with GQ3 (foiled, then the avatar), and the
# Rootwardens' night, the scorch, Eirwen and the Council's summons.
require_relative "driver"
HL.start_up
HL.quiet = !ENV["V"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1], [/What will you take/, ->(_t, c) { c.size - 1 }],
              [/rest your Pokémon/, 0], [/save your game/, 1]]
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
def has?(item) = ($PokemonBag.pbHasItem?(item) rescue false)
def answer(re, pick) = HL.answers.unshift([re, pick])
def unanswer(re) = HL.answers.reject! { |r, _| r == re }
def clear(*fs) = fs.each { |f| T.set_flag(f, false) }

T.state[:companions] = [:alberica, :reptin, :alerion, :glimmer, :meat_meat]
%i[reversal rootspire_arrived met_hellen wardens_emeritus heard_wall_rule twins_met orb_visions].each { |f| T.set_flag(f) }
$Trainer.party << Pokemon.new(:FORGEL, 80) while $Trainer.party.size < 3
$Trainer.party.each { |pk| pk.level = 80; pk.calc_stats; pk.heal }
$Trainer.money = 100_000
rest

#--- the dead Glimmer's journal, read at the Rift (reaudit A item 2) ------------
T.state[:companions] = [:alberica, :reptin, :alerion, :shade, :meat_meat]
$PokemonBag.pbStoreItem(:FT_GLIMMERJOURNAL) rescue nil
at(2061, 31, 7); talk("Lumen Shard"); heal
ok("Shade comes back as Glimmer, and reads the dead Glimmer's journal: his own hand", T.flag?(:glimmer_joined) && T.flag?(:glimmer_knows_journal) &&
   HL.instance_variable_get(:@log).any? { |l| l.include?("Will you bear hope when even the sun freezes?") })
T.state[:companions] = [:alberica, :reptin, :alerion, :glimmer, :meat_meat]

#--- Hellen's errands and the old passages -----------------------------------
T.set_flag(:badge_hearth)
rest
ok("Hellen tells you the family secret: the passage behind the sun-chalked cask", T.flag?(:hellen_passages) && $game_switches[T::SW_HEARTH_PASSAGE])
at(2059, 4, 23); talk("Sun-chalked cask"); HL.settle(3000)
ok("...the cask opens onto the Split Dock, under a barrel", $game_map.map_id == 2055, "map #{$game_map.map_id} #{HL.pos}")
talk("Barrel on the dock"); HL.settle(3000)
ok("...and the barrel goes back up to the Hearth's cellar", $game_map.map_id == 2059, "map #{$game_map.map_id} #{HL.pos}")
T.set_flag(:root_tier_arrived)
rest
ok("Hellen's sealed note, for Captain Ivran", T.flag?(:hellen_note_given) && has?(:FT_HELLENNOTE))
at(2055, 34, 8); talk("Captain Ivran"); heal
ok("...delivered past the Halo's tail: a Corsair berth north", T.flag?(:hellen_note_delivered) && T.flag?(:corsair_berth) && !has?(:FT_HELLENNOTE))
m = $Trainer.money
rest
ok("...and Hellen pays in Corsair coin", T.flag?(:hellen_note_thanked) && $Trainer.money == m + 2000, "#{m} -> #{$Trainer.money}")
rest
ok("Hellen asks you to sit up with the frosted shrine", T.flag?(:shrine_frost_asked))
at(2059, 4, 23); talk("Sign herald_shrine")
ok("...Tobin, talked down: the lantern-hooks named", T.flag?(:tobin_turned) && T.flag?(:shrine_frost_solved) && T.flag?(:lantern_runes_known))
rest
ok("...and Hellen's thanks", T.flag?(:shrine_frost_thanked) && has?(:LEFTOVERS))

#--- Alerion's Day 5: the potions don't lock the desk (reaudit C B11) ----------
(T.state[:dt] ||= {})[:alerion] = 3; (T.state[:dt_day] ||= {})[:alerion] = 0
money = $Trainer.money; $Trainer.money = 100
T.alerion_potions
ok("Alerion's Day 5 counts even when the six potions can't be bought", T.dt_done(:alerion) == 4 && T.flag?(:alerion_potions_held) && !T.flag?(:alerion_potions_bought))
$Trainer.money = money
T.alerion_held_potions
ok("...and Nivva holds them until he can", T.flag?(:alerion_potions_bought) && has?(:FT_RENEWALDRAUGHT))

#--- Kethan's clue: the warden map (reaudit B B1) ------------------------------
at(2183, 12, 20); talk("Sign warden_map")
ok("reading the Rootwarden Hall's patrol map counts as Kethan's clue", T.flag?(:warden_map_seen))

#--- the favour track --------------------------------------------------------
T.state[:favour] = { spring: 2 }; T.state[:patron_faction] = nil
before = ($PokemonBag.pbQuantity(:SITRUSBERRY) rescue 0)
T.favour_tick
ok("the first faction to warm to you is your patron, with a boon", T.state[:patron_faction] == :spring && ($PokemonBag.pbQuantity(:SITRUSBERRY) rescue 0) > before)
ok("...and its rival cools", T.favour_of(:winter) == -1, T.state[:favour].inspect)
T.favour(:spring, 2); T.favour_tick
ok("...trusted: Kelyn's brooch", T.flag?(:favour_trusted_spring) && has?(:MIRACLESEED))
T.favour(:winter, -1); T.favour_tick; heal
ok("a faction gone cold acts on it (the Winter inspector)", T.flag?(:favour_cold_winter))

#--- the Still Ones, the Tree's lean, the omens ------------------------------
answer(/What do you do\?/, 1)
%w[faith hope love].each { |k| at(2060, 44, 10); talk("Still One #{k}"); heal }
unanswer(/What do you do\?/)
ok("shattering a Still One: a Shard of Stillness, the frost counts it", T.flag?(:still_faith_shattered) && has?(:FT_STILLSHARD) && T.counter(:tree_frost) == 3)
answer(/What do you do\?/, 0)
at(2060, 44, 18); talk("Still One balance"); heal
unanswer(/What do you do\?/)
ok("...helping one finish counts for the green", T.flag?(:still_balance) && !T.flag?(:still_balance_shattered) && T.counter(:tree_verdant) == 1)
ok("...three broken, one helped: the Tree leans toward the frost, and the Blessing comes anyway", T.flag?(:tree_leans_frost) && !T.flag?(:tree_leans_verdant) && T.blessing?(:still_sky))
tier = T.omen_tier
T.set_flag(:saw_auril_bryn)
ok("Alberica's straying brings the omens on harder", tier == 1 && T.alberica_strayed == 2 && T.omen_tier == 2, "#{tier} #{T.alberica_strayed} #{T.omen_tier}")
T.set_flag(:auril_whisper); T.state[:omens] = {}
d = T.rs_day
ok("...and after the Whisper there are no more omens, and no more Hearth nights", !T.omen_check && (T.hearth_night; T.rs_day == d))
clear(:auril_whisper, :saw_auril_bryn)

#--- the staff, bonded at the edge of the Wall --------------------------------
T.set_flag(:crypt_open)
at(2065, 9, 17); talk("The first Warden"); heal
ok("the Rootwarden Crypt gives the staff unbonded", T.flag?(:staff_found) && has?(:FT_UNBONDEDSTAFF) && !has?(:FT_HEARTWARDENSTAFF))
at(2060, 44, 10); talk("Sign auroral_wall")
ok("...a night at the Auroral Wall bonds it: the Heartwarden's Staff", T.flag?(:staff_attuned) && has?(:FT_HEARTWARDENSTAFF) && !has?(:FT_UNBONDEDSTAFF))

#--- Glimmer's Trial: the celestial envoy -------------------------------------
%i[glimmer_joined glimmer_rite_done brightmane_answered].each { |f| T.set_flag(f) }
$game_switches[T::SW_TWINS_MET] = true
answer(/What do you tell him/, 1)
at(2061, 22, 26); talk("Lumin Weavemoss")
unanswer(/What do you tell him/)
ok("the celestial envoy asks Glimmer what the torch is for: judgment", T.flag?(:envoy_judged) && T.flag?(:glimmer_judgment) && has?(:CHARCOAL))
talk("Lumin Weavemoss")
ok("...once", !T.flag?(:glimmer_hope))

#--- the Cycle Canticle --------------------------------------------------------
T.set_flag(:key_found); T.set_flag(:met_eirwen)
answer(/The lost verses/, 1); answer(/(sings|You sing)\.\.\.$/, 2)
at(2054, 16, 13); talk("Living pillar"); heal
ok("improvised and sung badly: the old choir comes (Spectral Bards)", T.flag?(:canticle_haunted) && !T.flag?(:key_attuned))
talk("Living pillar")
ok("...and the crystals are spent until the next night", !T.flag?(:key_attuned) && T.state[:canticle_night] == T.rs_day)
unanswer(/The lost verses/); unanswer(/(sings|You sing)\.\.\.$/)
rest
answer(/And which one, for loss/, 1)
at(2062, 16, 6); talk("Eirwen Solglass")
unanswer(/And which one, for loss/)
ok("Eirwen's crystal leaves: the lost verses found", T.flag?(:canticle_researched))
answer(/(sings|You sing)\.\.\.$/, ->(t, c) { c.first.to_s =~ /Stand still/ ? 1 : 0 })
at(2054, 16, 13); talk("Living pillar")
unanswer(/(sings|You sing)\.\.\.$/)
ok("...the Canticle sung whole: the Whisper Key, the prophecy leaf, Verse XI", T.flag?(:key_attuned) && T.flag?(:canticle_learned) && has?(:FT_WHISPERKEY) && has?(:FT_PROPHECYLEAF) && T.flag?(:verse_xi_known))

#--- Eirwen's ledger -----------------------------------------------------------
at(2062, 16, 6); talk("Eirwen Solglass")
ok("Eirwen's sigil, after the Canticle", T.flag?(:sigil_eirwen))
w = T.favour_of(:winter)
talk("Eirwen Solglass")
ok("Eirwen's dilemma: Naerth's ledger, published", T.flag?(:naerth_ledger_decided) && T.flag?(:naerth_ledger_published) && T.favour_of(:winter) == w + 1)

#--- the festival: the seventh night ------------------------------------------
%i[rite_stopped glimmer_joined badge_hearth].each { |f| T.set_flag(f) }
T.state[:rs_day] = 3
rest
ok("the festival waits for the seventh night", !T.flag?(:festival_night) && T.state[:goal].to_s.include?("festival's last night"), T.state[:goal])
8.times { break if T.flag?(:festival_night); rest; HL.settle(5000) }
ok("...and comes on it", T.flag?(:festival_night) && T.rs_day >= T::FESTIVAL_NIGHT, "day #{T.rs_day}")
ok("GQ3: the lantern-hooks known, the Cycle Day Conspiracy foiled, the effigy saved", T.flag?(:cycle_day_done) && T.flag?(:effigy_saved) && T.flag?(:rootwardens_favour) && !T.flag?(:festival_casualties))
ok("...Wyn joins, and the roads aren't open yet", T.flag?(:wyn_joined) && !T.flag?(:ch7_started))
rest
ok("the Rootwardens at the door", T.flag?(:rootwardens_at_door))
at(2050, 9, 22); talk("Scorch marks")
ok("...the scorch at the Echo Gate: chardalyn", T.flag?(:chardalyn_found) && has?(:FT_CHARDALYN))
at(2062, 16, 6); talk("Eirwen Solglass")
ok("...Eirwen's audience, then the Council's summons: both roads open", T.flag?(:eirwen_audience) && T.flag?(:council_summoned) && T.flag?(:ch7_started))

#--- GQ3's other ending: Auril's Icy Avatar ------------------------------------
clear(:cycle_day_done, :effigy_saved, :lantern_runes_known, :summer_sense_used)
T.set_flag(:cult_warned)
answer(/\.\.\.$/, ->(t, c) { c.size == 3 && t !~ /sing/ ? 2 : 0 })
T.cycle_day_conspiracy; heal
unanswer(/\.\.\.$/)
ok("GQ3 lost: Auril's Icy Avatar at the Still Sky Shrine, and the festival's dead", T.flag?(:icy_avatar_fought) && T.flag?(:festival_casualties) && !T.flag?(:effigy_saved))
rest
ok("...and the Hearth mourns them", T.flag?(:hellen_mourned))
clear(:ch7_started, :council_summoned)
T.council_summons
ok("...and so does the Hall (Kelyn's summons names the dead)", T.flag?(:council_summoned) && HL.instance_variable_get(:@log).last(12).any? { |l| l.include?("We buried eleven") })

puts "\n#{$ok}/#{$ok + $bad} F2 checks passed"
probs = HL.instance_variable_get(:@problems) || []
puts "problems: #{probs.first(10).inspect}" if !probs.empty?
exit($bad == 0 ? 0 : 1)
