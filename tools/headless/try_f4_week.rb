# Fixer F4's round (docs/fixes_F4.md), played in the real game: the election
# stance (endorse, stand, stay out), the Favour Track, the trial week's nights
# (Sephek's pilgrim, Reptin's wolf, the sap raid), Summer's quarters atop the
# Council tower, the consequences the week sets (geas, Wyn barred, the Canopy
# watch, the blight's scar, the Rootwardens' anger, the poisoned pool, Eira's
# patrols, the spores, Q5's refusal, GQ4's trap), the Tainted Lake ritual, the
# Mycolith's enraged HP, the Council's first session (the Heralds' seat, an
# ally, Darrus paying), the Whisper in full, Sephek's motives, and the Silent
# Chapel's answer at Auril's throne and Avarice's cradle.
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
def at(map, x, y, d = 8) = (HL.warp(map, x, y, d); HL.frames(8); T.apply_fix_round_switches; HL.frames(2))
def said?(re, from = 0) = HL.log[from..].any? { |l| l =~ re }
def mark = HL.log.size
def qty(item) = ($PokemonBag.pbQuantity(item) rescue 0)
def unflag(*fs) = fs.each { |f| T.state[:flags].delete(f) }
def answer(*rules) = HL.answers.unshift(*rules.reverse)

T.state[:companions] = [:alberica, :reptin, :alerion, :wyn, :meat_meat]
%i[reversal rootspire_arrived met_hellen wardens_emeritus heard_wall_rule summer_ended].each { |f| T.set_flag(f) }
$Trainer.party << Pokemon.new(:FORGEL, 80) while $Trainer.party.size < 3
$Trainer.party.each { |pk| pk.level = 80; pk.calc_stats; pk.heal }
$Trainer.money = 100_000

# ------------------------------------------------------------------------------
# The trial week opens; the Favour Track on the first morning
T.set_flag(:trials_open); T.trial
T.state[:favour] = { spring: 3, winter: 0, autumn: -2, summer: 0 }
herbs = qty(:REVIVALHERB)
T.scene_trial_morning
ok("a warm Spring sends its friends a basket (Favour Track boon)", qty(:REVIVALHERB) == herbs + 2 && T.trial[:opinion] >= 1)
ok("...a cold Autumn turns its back, and Spring's rival heckles its friends (inherited rivalry)", T.trial[:mud] == 2, T.trial[:mud])
votes = T.favour_votes({ eirwen: 3, rheven: 4, mira: 3 }, [:mira])
ok("at the vote, warm Spring brings out Eirwen's people; cold Autumn costs your first pick", votes[:eirwen] == 4 && votes[:mira] == 2, votes)
T.trial[:mud] = 0; T.trial[:opinion] = 0

# The election stance: stand, with Spring's oath behind you
T.set_flag(:wardens_sworn)
answer([/In the election, the Heralds will/, 1])
T.election_stance
ok("standing for a chair: the Wardens' oath is a faction, and the Heralds' name goes forward", T.state[:election_stance] == :stand && T.nominated?(:heralds))
# ...or with a petition of five
T.state[:election_stance] = nil; unflag(:wardens_sworn, :nominated_heralds, :petition_heralds)
answer([/In the election, the Heralds will/, 1])
T.election_stance
ok("without an oath, standing starts a petition", T.flag?(:petition_heralds) && !T.nominated?(:heralds))
T.petition_signer(:refugees); T.petition_signer(:bazaar)
ok("...refugees and the Bazaar sign, and five names put the Heralds forward", T.nominated?(:heralds))
ok("the Heralds take a turn at the debate stages", T::DEBATE_QUESTIONS.all? { |_, a| a[:heralds] })

# ------------------------------------------------------------------------------
# The trial's evidence (reaudit D 4-8, 16, 27; C B11)
T.set_flag(:heist_exposed)
ok("the Maera branch: Autumn's lists were carried below by Maera Vell when Darrus ran", T.witness_line("x{MAERA_CARRIED}") =~ /Maera Vell/)
unflag(:heist_exposed)
ok("...and Darrus kept them, if he never ran", T.witness_line("x{MAERA_CARRIED}") == "x")
T.set_flag(:maera_apprentice_heard)
ok("Maera Vell's apprentice is her own witness", T.witnesses(:autumn).any? { |_, who, _, _| who =~ /apprentice/ })
T.set_flag(:talion_haunted)
ok("Talion haunted gives no testimony (D16)", T.witnesses.none? { |_, who, _, _| who =~ /Talion/ })
T.set_flag(:wyn_cleared)
ok("Hyphora's alibi isn't heard just because Wyn's case closed (D7)", T.witnesses.none? { |_, who, _, _| who =~ /Hyphora/ })
T.set_flag(:frostfire_flask)
ok("the Frostfire Flask is evidence against Summer (C B11)", T.witnesses(:summer).any? { |_, who, _, _| who =~ /frostfire/i })
T.set_flag(:mira_mirror_taken)
answer([/Ask Mira/, ->(_t, c) { c.index { |o| o.to_s =~ /Give back/ } }])
T.mira_trials
ok("Mira's cursed mirror goes back to Mira, at the Requiem (D8)", T.flag?(:mira_mirror_returned))
# Anduin: the nomination goes forward in whatever order its pieces arrive (D3)
T.set_flag(:petition_anduin); T.trial[:signatures][:anduin] = 15
ok("Anduin: fifteen names, but not yet the wardens' leave", !T.check_nomination(:anduin))
T.set_flag(:rootwardens_accept_anduin); T.set_flag(:reptin_endorsed)
ok("...then the wardens and Reptin's word, and the name goes forward", T.check_nomination(:anduin) && T.nominated?(:anduin))
# ...and his doubt can be won back with Q1's evidence (D27)
%i[anduin_doubtful eirwen_restraint leaf_presented].each { |f| T.set_flag(f) }
T.anduin_after
ok("Eirwen's word and Hyphora's leaf win back a doubtful Anduin", T.flag?(:anduin_reconciled) && !T.flag?(:anduin_doubtful))
# Korun, Faria, Luminara (D25, D26)
at(2068, 9, 19)
answer([/^Korun\.\.\./, 1], [/^Buy\.\.\./, ->(_t, c) { c.index { |o| o.to_s =~ /Hyphal Lash/ } }])
money = $Trainer.money
talk("Korun")
ok("Korun: a maker's discount on the Hyphal Lash", qty(:FT_HYPHALLASH) == 1 && $Trainer.money == money - 2250)
T.set_flag(:badge_undercanopy)
T.faria_wand
ok("Faria sells the Wand of Spores", qty(:FT_WANDOFSPORES) == 1)
%i[lake_cleansed hyphora_sworn colony_recognised].each { |f| T.set_flag(f) }
T.luminara_gifts
ok("Luminara: Hyphora's Seed for the lake, the Crown for the sworn", qty(:FT_HYPHORASEED) == 1 && qty(:FT_HYPHORACROWN) == 1)
ok("the new goods work in battle", %i[FT_SAPSTONE FT_HYPHALLASH FT_WANDOFSPORES FT_HYPHORACROWN FT_HYPHORASEED].all? { |i| ItemHandlers.hasUseInBattle(i) })
unflag(:colony_recognised, :lake_cleansed)
ok("Ivo is the junior Rootwarden now (one Pell fewer)", (at(2055, 9, 21); $game_map.events.values.any? { |e| e.name == "Ivo" }))

# ------------------------------------------------------------------------------
# The week's nights: the pilgrim, Reptin's wolf, the sap raid
T.set_flag(:reptin_warden_vow); T.set_flag(:sap_grudge); T.set_flag(:kobolds_freed)
T.trial[:day] = 1
m = mark; T.trial_day_passes
ok("night two: Sephek comes as a hooded pilgrim with a cold blessing", T.flag?(:pilgrim_dream) && said?(/hooded pilgrim/, m))
ok("...and calls Meat Meat 'Prototype Verdant', and Alerion one too many", said?(/Prototype Verdant/, m) && said?(/one too many/, m))
heal
m = mark; T.trial_day_passes; heal
ok("night three: a grey wolf from the Chasm, with news (Reptin's vow kept)", T.flag?(:chasm_watch_kept) && said?(/kobolds' fires/, m))
ok("...and the Rootwardens come for the sap; the Heralds stand in the way", T.flag?(:sap_raid_done) && T.flag?(:sap_raid_stopped) && T.flag?(:sap_settled))
at(2068, 44, 24)
ok("a shared watch stands at the vats after the raid", ev("Sap vat watch"))
# the cold blessing, taken
unflag(:pilgrim_dream)
answer([/The pilgrim's cold blessing/, 1])
w0 = T.counter(:wheel).to_i
T.pilgrim_dream
ok("taking the cold blessing freezes your lead Pokémon and costs the Wheel", T.flag?(:took_cold_blessing) && $Trainer.party[0].status == :FROZEN && T.counter(:wheel).to_i == w0 - 1)
heal; $Trainer.party.each { |pk| pk.status = :NONE }

# ------------------------------------------------------------------------------
# Summer's quarters, atop the Council tower
at(2054, 6, 5)
answer([/Creep up/, 0], [/The lock/, ->(_t, c) { c.index { |o| o.to_s =~ /Pick the lock/ } }])
HL.step(8); HL.settle(2000); HL.frames(20); HL.settle(2000)
ok("the tower stair, the root-lock picked: up into Summer's quarters", $game_map.map_id == 2173, $game_map.map_id)
ok("...thirty years of somebody very tidy (arrival scene)", T.flag?(:quarters_entered))
HL.walk_to(9, 9); HL.step(8); HL.settle(2000)
ok("an alarm glyph underfoot: unwritten", T.flag?(:quarters_glyph_1))
answer([/The construct\.\.\./, 0])
talk("Bone-and-ice construct")
ok("the bone-and-ice construct in the alcove: slipped past", T.flag?(:quarters_construct))
HL.frames(4)
talk("Loose floorboard")
ok("under the desk, the loose floorboard: the Ledger of Corruption", T.flag?(:ledger_found) && qty(:FT_CORRUPTLEDGER) == 1)
T.set_flag(:avarice_faked_death); T.set_flag(:var_story_known)
talk("Turned mirror"); talk("Wardrobe")
ok("the turned mirror: something smiles at the back of it (Avarice's doubt); Var's wardrobe", T.flag?(:avarice_doubt) && T.flag?(:var_wardrobe_seen))
HL.walk_to(9, 10); HL.step(2); HL.settle(2000); HL.frames(10); HL.settle(2000)
ok("back down the stair to the Council Hall", $game_map.map_id == 2054, $game_map.map_id)
# a glyph that flares: the construct herds you out
unflag(:quarters_glyph_2)
answer([/The alarm glyph/, 1])
at(2173, 9, 7)
m = mark; T.quarters_glyph(2)
ok("a glyph you can't unwrite wakes a construct", said?(/Bone-and-Ice Construct/, m) || said?(/unfolds/, m))
at(2054, 11, 15)

# ------------------------------------------------------------------------------
# What the week carries forward
# the geas holds at the Wall
T.set_flag(:verdict_geas); T.set_flag(:wall_thinning)
at(2050, 9, 22)
m = mark; T.echo_gate
ok("the verdict's geas: your feet stop at the Wall", said?(/The geas/, m) && $game_map.map_id == 2050)
T.apply_fix_round_switches
ok("...and the way beyond the Wall stays shut while it binds", !$game_switches[T::SW_BEYOND_WALL])
unflag(:verdict_geas)
T.apply_fix_round_switches
ok("lifted (the appeal), the way beyond the Wall opens again", $game_switches[T::SW_BEYOND_WALL])
# Wyn barred from the Rootwardens' stores
T.set_flag(:wyn_barred); T.set_flag(:met_kethan)
m = mark; T.kethan
ok("Wyn barred: Kethan keeps the Rootwardens' stores shut", said?(/stores are closed to you/, m))
# the Canopy under martial law
T.set_flag(:canopy_martial_law); T.set_flag(:wardens_sworn)
at(2061, 12, 32)
ok("martial law: a warden on the Canopy walkway", ev("Walkway warden"))
talk("Walkway warden")
ok("...who lets a sworn Warden through", T.flag?(:checkpoint_done))
# the blight's scar at Selrae's bid
T.set_flag(:blight_scarred)
answer([/Enter the crystals' dream/, 1])
m = mark; T.selrae_bid
ok("the blight's scar: the debate starts one failure down", said?(/blight scar a root/, m))
unflag(:seasons_debated); T.state[:seasons_debate] = nil
# the Rootwardens angered by the burning
T.set_flag(:rootwardens_angered); T.set_flag(:wall_helped)
answer([/Ask Rheven/, 0])
m = mark; T.rheven_wall
ok("the Rootwardens angered: Rheven makes you earn his testimony, wall or no wall", said?(/burned a colony/, m) && said?(/Rheven looks at you a long time/, m))
# the poisoned pool, and Yarro's tincture
T.set_flag(:pool_poisoned); T.set_flag(:badge_undercanopy); T.set_flag(:yarro_errand_done)
answer([/Drink from the sap pool/, 1])
T.sap_pool
ok("the poisoned pool runs cold until Yarro's tincture cures it", T.flag?(:pool_cured))
# Eira's patrols
%i[eira_lore eira_patrols missing_patrol_found blight_cleared spore_guard].each { |f| T.set_flag(f) }
answer([/^Eira\.\.\./, ->(_t, c) { c.index { |o| o.to_s =~ /what you found/ } || 0 }])
T.eira
ok("Eira hears what became of her patrols", T.flag?(:eira_patrols_reported))
# W1's spores: a second success to commune
unflag(:undercity_done); T.set_flag(:undercity_spored); T.set_flag(:wyn_joined)
answer([/Hold on to your own voice/, 1])
m = mark; T.undercity_colony; heal
ok("breathing the spores: the colony takes your voice, and the commune fails into a fight", said?(/your own voice/, m) && said?(/Spore Swarm/, m))
# Q5: refusing the councillors
unflag(:spores_debated, :colony_recognised, :colony_exiled)
answer([/Ask Selrae/, 1], [/The councillors wait/, 2])
T.spores_debate; heal
ok("Q5: refusing to explain, and Selrae's wardens step off the wall", T.flag?(:spores_fought))
# GQ4: trapped beyond the Wall
T.state[:counters][:wheel] = 4 rescue (T.add_counter(:wheel, 4 - T.counter(:wheel).to_i))
answer([/Get back to the Wall/, 1])
T.beyond_return; heal
ok("GQ4: trapped in the stopped snow, half the Wheel is lost and a rope-line hauls you out", T.counter(:wheel).to_i == 2 && T.flag?(:beyond_rescued), T.counter(:wheel))

# ------------------------------------------------------------------------------
# Fights whose numbers changed: the battles are stubbed to record what's fought
$fought = []
class << T
  alias f4_boss_battle boss_battle
  def boss_battle(*mons) = ($fought << mons.map { |pk| [pk.name, pk.hp, pk.totalhp] }; true)
end
T.lake_purification
ok("H4: Yarro's ritual at the lake: herbs mixed, pseudopods fought off", T.flag?(:lake_ritual_done) && $fought.flatten(1).any? { |n, _, _| n =~ /Creeper/ })
$fought.clear
%i[mycolith_minions_1 mycolith_minions_2].each { |f| T.set_flag(f) }
T.shadow_mycolith
en = $fought.flatten(1).find { |n, _, _| n == "Mycolith, Enraged" }
ok("the Shadow Mycolith doesn't heal to full: enraged at 215/350", en && (en[1].to_f / en[2] - 215 / 350.0).abs < 0.02, en)
$fought.clear
T.auril_stage(T::AURIL_CRONE, 66, "The Cold Crone", false, false)
T.auril_stage(T::AURIL_CRONE, 66, "The Cold Crone", false, true)
a, b = $fought.flatten(1)
ok("the Silent Chapel's polite answer: Auril gives the first breath (her first stage weaker)", a && b && b[1] < a[1], [a, b])
class << T
  alias boss_battle f4_boss_battle
end

# ------------------------------------------------------------------------------
# The vote, standing; then the Council's first session
T.trial[:day] = 7
T.set_flag(:darrus_redeemed); T.set_flag(:heist_exposed); T.set_flag(:badge_selrae)
T.state[:election_stance] = :stand
answer([/other chair/, 0])
T.trial[:support][:heralds] = 3
T.scene_vote; HL.settle(2000)
ok("standing, the Heralds win Summer's chair", T.flag?(:council_heralds))
T.set_flag(:knows_rewritten)
money = $Trainer.money
answer([/The Heralds will go north/, 1])
T.scene_four_chairs; HL.settle(2000)
ok("a seat on the Council: the Heralds choose how they go north (griffons)", T.voyage_route == :griffons)
ok("the Council's first act: Wyn's stores open again; the Canopy's martial law ends", T.flag?(:wyn_bar_lifted))
ok("Darrus pays for the voyage and the vault: coin and supplies from the Corsairs", T.flag?(:darrus_paid) && $Trainer.money >= money + 10_000)
# with no route on the Council, Darrus charters the Requiem
%i[council_heralds council_rheven council_mira council_anduin darrus_paid].each { |f| unflag(f) }
T.set_flag(:long_voyage)
T.darrus_pays
ok("...and with nobody elected holding a ship, Darrus charters the Requiem", T.flag?(:darrus_chartered) && T.voyage_route == :ship && !T.flag?(:long_voyage))
# staying out of it
%i[council_heralds council_rheven council_mira council_eirwen council_phildendrin council_anduin].each { |f| unflag(f) }
T.state[:election_stance] = :neutral
T.scene_vote; HL.settle(2000)
ok("staying out of it: the city chooses without you, and the Council doesn't know what you are", T.flag?(:council_uncertain))
# endorsing: an ally
%i[council_heralds council_rheven council_mira council_eirwen council_phildendrin council_anduin council_uncertain].each { |f| unflag(f) }
T.state[:election_stance] = :endorse
answer([/Who do you endorse first/, ->(_t, c) { c.index { |o| o.to_s =~ /Rheven/ } }])
T.scene_vote; HL.settle(2000)
ok("speaking for a winner makes an ally", T.state[:council_ally] == :rheven)

# ------------------------------------------------------------------------------
# The Whisper in full, and the omens she sent
T.add_counter(:omens_seen, 3 - T.counter(:omens_seen).to_i)
unflag(:auril_whisper)
at(2053, 5, 9)
m = mark; T.scene_auril_whisper; HL.settle(2000)
ok("the Whisper: a sentinel chained to frost; stop them, and all is mine", said?(/sentinel chained to frost/, m) && said?(/all is mine/, m))
ok("...the wheel turns for me", said?(/the wheel turns for me/, m))
ok("...and she knows you saw every omen", said?(/You've seen them/, m))
# Sephek's motives at the crown
m = mark; T.sephek_motive_lines
ok("at the crown Sephek wants Meat Meat's blood, and names Alerion his rival", said?(/Prototype Verdant/, m) && said?(/Frost doesn't share/, m))

# The Minor Avatar, Avarice's cradle and the epilogue, with the fights stubbed
$fought = []
class << T
  alias f4_boss_battle2 boss_battle
  def boss_battle(*mons) = ($fought << mons.map { |pk| [pk.name, pk.hp, pk.totalhp] }; true)
end
alias f4_pbTrainerBattle pbTrainerBattle
def pbTrainerBattle(*a) = true
m = mark
T.sephek_minor_avatar rescue puts("  (minor avatar: #{$!.message})")
ok("the Minor Avatar: Sephek names Prototype Verdant, and Alerion one too many", said?(/Prototype Verdant\. You're smaller/, m) && said?(/One too many/, m))
souls = lambda do
  $fought.clear
  unflag(:avarice_body_broken)
  T.scene_vault_cradle rescue puts("  (cradle: #{$!.message})")
  s = $fought.flatten(1).find { |n, _, _| n == "Avarice's Reflection" }
  s && s[1].to_f / s[2]
end
%i[circuit_north circuit_east].each { |f| T.set_flag(f) }
T.state[:flags].delete(:chapel_avarice)
plain = souls.call
T.set_flag(:chapel_avarice)
m = mark
answered = souls.call
ok("the Silent Chapel's fire answered: Avarice's reflection is stronger at the cradle", plain && answered && answered > plain && said?(/You answered me once/, m), [plain, answered])
alias pbTrainerBattle f4_pbTrainerBattle
class << T
  alias boss_battle f4_boss_battle2
end
m = mark
T.epilogue rescue puts("  (epilogue: #{$!.message})")
ok("the epilogue: Reptin goes back to the Chasm every winter, as he swore", said?(/Every winter Reptin goes back to the Cackling Chasm/, m))

puts "\n#{$ok} ok, #{$bad} failed; problems: #{HL.problems.size}"
HL.problems.each { |p| puts "  #{p}" }
exit($bad.zero? && HL.problems.empty? ? 0 : 1)
