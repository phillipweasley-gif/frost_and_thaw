# F1 (the fix round after the re-audit): every Act I fix, checked in the real
# game code. See docs/fixes_F1.md for which re-audit item each check covers.
#   PIF_DIR=/home/claude/pifrun_F1 ruby tools/headless/try_f1.rb
require_relative "driver"
HL.start_up
HL.quiet = !ENV["HL_VERBOSE"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1], [/save your game/, 1]]
HL.new_game; HL.frames(200)
FT = FrostThaw unless defined?(FT)
$results = []
def ok(c, m) = ($results << [c, m]; puts "#{c ? 'ok  ' : 'FAIL'} #{m}")
def mark = HL.log.size
def said_since?(m, re) = HL.log[m..].any? { |l| l =~ re }
def bag?(it) = ($PokemonBag.pbHasItem?(it) rescue false)
def clear(*fl) = fl.each { |f| (FT.state[:flags] || {}).delete(f) }
def map(id) = Marshal.load(File.binread("Data/FrostThaw/Map#{id}.rxdata"))
def src(f) = File.read(File.join(__dir__, "../../game/Data/Scripts/998_FrostThaw", f), encoding: "UTF-8")
def events_named(m, re) = m.events.values.select { |e| e.name =~ re }
def strong_party
  $Trainer.party.clear
  [[:ARCANINE, 62], [:GYARADOS, 62], [:ALAKAZAM, 62], [:MACHAMP, 62], [:B6H130, 62], [:SNORLAX, 62]].each do |sp, lv|
    pk = Pokemon.new(sp, lv); HL.sensible_moves(pk); pk.calc_stats; $Trainer.party << pk
  end
end
$game_switches[Settings::NO_MONEY_LOSS] = true rescue nil
FT.state[:companions] = %i[alberica reptin alerion shade meat_meat]
%i[met_party badge_targos badge_bryn].each { |f| FT.set_flag(f) }
strong_party

# A stand-in battle, for the in-battle scripts (the lunge, Reptin and Kanan).
class FakeBattler
  attr_accessor :name, :hp, :totalhp, :stages
  def initialize(name, hp, total, foe) = (@name = name; @hp = hp; @totalhp = total; @foe = foe; @stages = { EVASION: 1 })
  def fainted? = @hp <= 0
  def opposes?(_i) = @foe
  def pbReduceHP(n) = (@hp = [@hp - n, 0].max)
  def pbThis = @name
  def egg? = false
  def pbRecoverHP(n) = (@hp = [@hp + n, @totalhp].min)
  def pbCanConfuse?(*) = false
  def pbCanRaiseStatStage?(*) = false
  def pbRaiseStatStage(*) = nil
end
class FakeBattle
  attr_reader :battlers, :shown
  def initialize(battlers, pick: 0) = (@battlers = battlers; @pick = pick; @shown = [])
  def pbDisplay(m) = (@shown << m)
  def pbShowCommands(_m, _c, _cancel = true) = @pick
  def pbParty(side) = @battlers.select { |b| b.opposes?(0) == (side == 1) }.map { |b| Struct.new(:hp, :egg?).new(b.hp, false) }
end

# --- E1: the starving pack can't be walked round ---------------------------------
t = map(2039)
watch = events_named(t, /The pack watches/)
rows = watch.map(&:y).sort
ok(rows == (4..30).to_a && watch.all? { |e| e.x == 35 && e.pages[0].trigger == 1 },
   "E1: a trigger row across the whole tundra crossing (x 35, every walkable row)")
clear(:reptin_bitten); $game_switches[3924] = false
HL.answers.unshift([/What do you do\?/, 0])
m = mark; FT.starving_pack_sighted(nil)
ok(FT.flag?(:reptin_bitten) && $game_switches[3924] && said_since?(m, /four wolves, all ribs and eyes/), "E1: ...the pack comes into view and Reptin is bitten")
m = mark; FT.starving_pack_sighted(nil)
ok(!said_since?(m, /ribs and eyes/), "E1: ...only once")
HL.answers.shift

# --- DH10: the blizzard crossing --------------------------------------------------
clear(:followed_koran, :refused_wolves, :met_wolves); FT.set_flag(:followed_koran)
m = mark; FT.scene_tundra_start
ok(said_since?(m, /coats take the worst of it/) && said_since?(m, /lope ahead into the white/), "DH10: Koran and Kanan shield you from the blizzard, then go ahead")
clear(:followed_koran); hp0 = $Trainer.party.map(&:hp).sum
FT.scene_tundra_start
ok($Trainer.party.map(&:hp).sum < hp0, "DH10: ...without them, the wind bites")
$Trainer.party.each { |pk| pk.heal }

# --- E16: Koran's narration after "Stand firm" ------------------------------------
HL.warp(2035, 10, 20, 2)
clear(:refused_wolves, :met_wolves, :followed_koran, :caught_koran)
HL.answers.unshift([/Stand firm/, 1], [/Which leg was it/, 2])
m = mark; FT.koran(nil)
ok(FT.flag?(:refused_wolves) && !said_since?(m, /something else white trots after him/), "E16: once both wolves are revealed, nothing 'trots after him, just out of sight'")
2.times { HL.answers.shift }

# --- E7 / A10 / A4: the lunge, mid-battle, and in every outcome ---------------------
def lunge_with(pick, flags = [])
  clear(:lunge_done, :lunge_in_battle, :shielded_cub, :broke_hag_staff, :freed_cub_midfight, :cub_wounded, :reptin_wolf_surged,
        :ghost_caught_knife, :locket_caught_wrist, :locket_talisman, :ghost_blessing)
  flags.each { |f| FT.set_flag(f) }
  hag = FakeBattler.new("Thredra's Pokémon", 10, 100, true)
  me = FakeBattler.new("Arcanine", 200, 200, false)
  b = FakeBattle.new([me, hag], pick: pick)
  FT.thredra_round(b, 4, { kind: :thredra })     # the warm pulse, then she's cornered
  [b, hag, me]
end
b, hag, = lunge_with(3)
ok(FT.flag?(:lunge_in_battle) && FT.flag?(:cub_wounded) && FT.flag?(:reptin_wolf_surged) && !FT.flag?(:cub_sacrificed),
   "E7: at a quarter HP she lunges mid-battle; holding still with no help, Reptin's wolf turns the knife: the cub is cut, not killed")
b, hag, = lunge_with(1)
ok(FT.flag?(:broke_hag_staff) && hag.stages[:EVASION] == 0, "E7: ...smashing her staff mid-battle strips her evasion")
b, _, me = lunge_with(0)
ok(FT.flag?(:shielded_cub) && me.hp < me.totalhp, "E7: ...throwing yourself between them costs your lead Pokémon")
b, = lunge_with(2)
ok(FT.flag?(:freed_cub_midfight), "E7: ...or you tear the cub free")
b, = lunge_with(3, %i[locket_talisman ghost_blessing])
ok(FT.flag?(:locket_caught_wrist) && FT.flag?(:ghost_caught_knife), "A10: the locket warns you AND the ghost's hand closes on the blade (the branch is reachable)")
b, = lunge_with(3, %i[ghost_blessing])
ok(FT.flag?(:ghost_caught_knife) && !FT.flag?(:cub_wounded), "A10: ...the ghost alone catches it")
FT.set_flag(:lunge_done)
b2 = FakeBattle.new([FakeBattler.new("Arcanine", 200, 200, false), FakeBattler.new("Thredra's Pokémon", 10, 100, true)])
FT.thredra_round(b2, 3, { kind: :thredra })
ok(b2.shown.none? { |l| l =~ /snatches a knife/ }, "E7: she only lunges once")
# the grey wave catches the chained cub (stray harm), unless the locket shields everyone
clear(:locket_talisman, :freed_cub_midfight); FT.state[:cub_hurt] = 0
b3 = FakeBattle.new([FakeBattler.new("Arcanine", 200, 200, false), FakeBattler.new("Thredra's Pokémon", 100, 100, true)])
FT.thredra_round(b3, 2, { kind: :thredra })
ok(FT.state[:cub_hurt] == 1 && b3.shown.any? { |l| l =~ /washes over the chained cub/ }, "E7: the Heart's grey wave can hurt the chained cub")
# Reptin fights at the Heart (A4)
clear(:reptin_fought_kanan)
kanan = FakeBattler.new("Kanan", 120, 120, true)
$ft_battle_script = { kind: :minions }
b4 = FakeBattle.new([FakeBattler.new("Arcanine", 200, 200, false), kanan])
FT.minions_round(b4, 2)
$ft_battle_script = nil
ok(FT.flag?(:reptin_fought_kanan) && kanan.hp < 120 && b4.shown.any? { |l| l =~ /wolf against wolf/ }, "A4: Reptin's wolf goes for Kanan at the Heart")

# --- E2: the loop resets every story map and the story's state ----------------------
FT.state[:gm_election_day] = 7; FT.state[:track_sets] = 3; FT.state[:baskets] = 2; FT.state[:bargain_memory] = 1
FT.state[:chwinga_charges] = 2
$game_self_switches[[2133, 27, "A"]] = true; $game_self_switches[[2101, 5, "A"]] = true; $game_self_switches[[2050, 9, "A"]] = true
$game_switches[4076] = true
FT.state[:counters][:omens_seen] = 3; FT.state[:counters][:trainers_beaten] = 9; wheel0 = FT.counter(:wheel)
FT.loop_snapshot(:act1)
FT.start_loop rescue nil
HL.frames(30); HL.settle(800)
ok(!FT.state.key?(:gm_election_day) && !FT.state.key?(:track_sets) && !FT.state.key?(:baskets), "E2: the loop drops Act I quest state (election clock, tracks, baskets)")
ok(FT.state[:bargain_memory] == 1 && FT.state[:chwinga_charges] == 2, "E2: ...but keeps the bargain's memory and what's on your items")
ok(!$game_self_switches[[2133, 27, "A"]] && !$game_self_switches[[2101, 5, "A"]] && !$game_self_switches[[2050, 9, "A"]],
   "E2: ...and clears self switches on every story map (21xx side quests too)")
ok(!$game_switches[4076], "E2: ...and the 4000+ story switches")
ok(FT.counter(:omens_seen).to_i == 0 && FT.counter(:trainers_beaten) == 9 && FT.counter(:wheel) == wheel0,
   "E2: ...and the story's counters (the wheel, the beats and your record stay)")
FT.loop_skip_state(:act1)
ok(FT.state[:gm_election_day] == 7 && FT.state[:baskets] == 2 && FT.counter(:omens_seen) == 3,
   "E2: skipping the act puts your own quest state and counters back, like its flags")
%i[gm_election_day track_sets baskets].each { |k| FT.state.delete(k) }; FT.state[:counters].delete(:omens_seen)
FT.state[:companions] = %i[alberica reptin alerion shade meat_meat]
%i[met_party badge_targos badge_bryn].each { |f| FT.set_flag(f) }
strong_party

# --- E3: the acorn can't go missing (smoke test covers Duvessa's battle) ------------
clear(:golden_acorn)
m = mark; FT.morninglord_acorn(nil)
ok(FT.flag?(:golden_acorn) && bag?(:FT_GOLDENACORN) && said_since?(m, /golden acorn/), "E3: Mishann's acorn scene gives the acorn")
m = mark; FT.morninglord(nil)
ok(said_since?(m, /Come in out of the dark/), "E3: ...after which the House is just the House")

# --- E4: the Council only sits the morning after the draw ---------------------------
clear(:council_session, :termalaine_arrived, :lonelywood_arrived); FT.set_flag(:lottery_stand)
ok(FT.council_sitting?, "E4: the morning after the draw, the speakers sit")
FT.set_flag(:termalaine_arrived)
ok(!FT.council_sitting? && FT.lines_for(:council_clerk).join =~ /You missed it/, "E4: once you're on the road north, it's been and gone (no living-Kendrick scene later)")

# --- E5: Oarus is gone when the grell takes him -------------------------------------
oarus = events_named(map(2120), /Oarus Masthew/).first
ok(oarus && oarus.pages.any? { |pg| pg.condition.switch1_valid && pg.condition.switch1_id == 4066 && pg.graphic.character_name == "" },
   "E5: Oarus's event has a 'gone' page on switch 4066")
FT.set_flag(:oarus_dead)
ok(FT.lines_for(:tm_shaelen).join =~ /went in with a lantern/, "E5: ...and Shaelen grieves")
clear(:oarus_dead)

# --- E6: one account of Sephek's victims (the book's) -------------------------------
ok(FT.lines_for(:lantern_mother).join =~ /paid the clerk to leave her name off the board/, "E6: the lantern mother's sister bought her way out, and was found frozen")
src7 = src("007_Story.rb")
ok(src7.include?("pay to keep their names off the board") && !src7.include?("People who run before the draw"), "E6: Naerth tells it the same way")

# --- E8: Keegan knows when Garret's already been found ------------------------------
clear(:climb_taken, :climb_done, :garret_found, :garret_sent_home, :garret_with_you, :keegan_told_garret, :boy_with_you)
FT.set_flag(:garret_found); FT.set_flag(:garret_with_you)
HL.answers.unshift([/Go back up Kelvin's Cairn/, 0])
m = mark; FT.keegan(nil)
ok(said_since?(m, /You absolute idiot/) && FT.flag?(:garret_sent_home) && FT.flag?(:climb_taken) && $game_switches[4044],
   "E8: Garret found first: Keegan's reunion, then he asks you back up for the others")
HL.answers.shift

# --- E9: Hlin, met after the Moon Temple -------------------------------------------
clear(:hlin_hired, :hlin_paid); FT.set_flag(:sephek_defeated)
money = $Trainer.money
m = mark; FT.hlin(nil)
ok(FT.flag?(:hlin_paid) && $Trainer.money > money && said_since?(m, /Seems I'm late/) && !said_since?(m, /Sephek's the one in his shirtsleeves/),
   "E9: Hlin met after the temple: she's heard, and pays at once (no hiring you for a man you've frozen)")

# --- K6 / K13: Torrga's four hands, and her grudge ----------------------------------
clear(:torrga_beaten, :torrga_grudge, :torrga_grudge_said, :torrga_grudge_felt, :found_torgs_corpse)
$game_switches[4000] = false
FT.apply_w1_switches
ok(FT.flag?(:torrga_grudge), "K13: Torrga survives and blames you: the grudge starts")
m = mark; FT.mart(:lonelywood, nil)
ok(said_since?(m, /can't sell to you. Torrga Icevein/), "K13: ...Lonelywood's trader won't sell to you")
m = mark; FT.mart(:targos, nil) rescue nil
ok(!said_since?(m, /Torrga Icevein/), "K13: ...but Targos isn't hers")
HL.warp(2021, 36, 20, 8)
HL.answers.unshift([/Torrga waits/, 1])
m = mark; FT.torrga(nil)
ok(said_since?(m, /Her four drivers drop the dogs' traces/) && said_since?(m, /Oska and Corran go down/),
   "K6: four hands come round the sleds: two, then Skeld, then Torrga and Brannig")
ok(FT.flag?(:torrga_beaten) && !FT.flag?(:torrga_grudge), "K13: ...beating her ends the grudge")
HL.answers.shift
hands = events_named(map(2021), /Torg's hand/)
ok(hands.size == 4, "K6: four of Torg's hands stand in the camp")

# --- E12: Fef's fox -------------------------------------------------------------
fox = events_named(map(2031), /Fef's fox/).first
ok(fox && fox.pages.any? { |pg| pg.condition.switch1_valid && pg.condition.switch1_id == 4076 }, "E12: Fef's fox leaves his feet once it's bought")
$game_switches[4076] = true; FT.set_flag(:mead_taken); FT.set_flag(:met_fef)
m = mark; FT.fef_moryn(nil)
ok(!said_since?(m, /Want it\?/), "E12: ...and he never sells it twice")

# --- E13 / names / Hruna ---------------------------------------------------------
moose = src("045_WhiteMoose.rb")
ok(moose.include?("drawing herself up to her full height") && !moose.include?("drawing himself"), "E13: Meat Meat is she/her at the white moose")
# every trainer name in the game: one name, one person (the same person may appear twice)
SAME_PERSON = %w[Sephek Thredra Ash Tamsin Eren Arvik] + ["Sister Ilse", "Brother Ansel"]
by_name = FT::TRAINERS.group_by { |_k, v| v[1] }.select { |n, v| v.size > 1 && !SAME_PERSON.include?(n) }
act1_files = %w[004_Trainers 014_Chapter2 015_Chapter3 022_Chapter4 023_Chapter5 044_ChasmFaithful 045_TenTowns 045_Termalaine
                045_MountainClimb 045_WhiteMoose 045_MeadMustFlow 045_HoledUp 045_FoamingMugs]
act1_keys = act1_files.flat_map { |f| (src("#{f}.rb").scan(/^\s+(\w+):\s+\[:\w+,\s+"/).flatten rescue []) }.map(&:to_sym)
clash = by_name.select { |_n, v| v.any? { |k, _| act1_keys.include?(k) } }
ok(clash.empty?, "E16: no Act I trainer shares a name with a different person (#{clash.keys.join(', ')})")
ok(FT::TRAINERS[:bhall_militia_1][1] == "Garvin" && FT::TRAINERS[:bhall_militia_2][1] == "Haskel", "E16: ...the hall's guards are Garvin and Haskel, not Pell and Rhosk")
ok(src("045_FoamingMugs.rb").include?("You don't see them again."), "E16: Hruna's refusal no longer promises a return")

# --- E14: the shore road, Targos to Termalaine (RotF: four hours) ------------------
sr = map(2101)
to_t = events_named(sr, /To Targos/); to_tm = events_named(sr, /To Termalaine/)
ok(to_t.size == 2 && to_tm.size == 4, "E14: the Maer Dualdon shore road has its two ends")
tg = map(2001)
ok(events_named(tg, /East gate drift/).all? { |e| e.pages[1].condition.switch1_id == 3913 } && events_named(tg, /To the Shore Road/).size == 2,
   "E14: Targos's east gate: drifts until Bryn Shander's seal, then the road")
ok(events_named(map(2120), /To the Shore Road/).size == 4, "E14: ...and Termalaine's south-west road back")
def pos = [$game_map.map_id, $game_player.x, $game_player.y]
def walk_on(x, y) = (HL.walk_to(x, y); HL.frames(60); HL.settle(800))
clear(:badge_bryn); $game_switches[3913] = false      # (the seal is synced from the badge on every map load)
HL.answers.unshift([/Skip ahead to the fall/, 1])     # (the loop's offer, on first coming back to Targos)
HL.warp(2001, 43, 27, 6); walk_on(47, 27)
ok($game_map.map_id == 2001 && $game_player.x <= 43, "E14: before Bryn Shander, the drifts at Targos's east gate don't let you by #{pos.inspect}")
FT.set_flag(:badge_bryn); $game_switches[3913] = true
HL.warp(2001, 43, 27, 6); walk_on(47, 27)
ok($game_map.map_id == 2101, "E14: after it, you walk out of Targos onto the shore road #{pos.inspect}")
walk_on(48, 0)
ok($game_map.map_id == 2120, "E14: ...and along the shore, past its hunter and its fisher, into Termalaine #{pos.inspect}")
HL.warp(2120, 16, 35, 2); walk_on(16, 39)
ok($game_map.map_id == 2101, "E14: ...and from Termalaine back down the shore #{pos.inspect}")
walk_on(0, 12)
ok($game_map.map_id == 2001, "E14: ...to Targos #{pos.inspect}")

# --- E15: small flavour -----------------------------------------------------------
HL.warp(2028, 6, 8, 8)
m = mark; FT.iriskree(nil); m2 = mark; FT.iriskree(nil)
ok(said_since?(m, /Iriskree Harrowhill/) && HL.log[m2..].any? { |l| l =~ /Corvin Tull|Mags Ullan|He's dead now/ }, "LW4: Iriskree, and her fond words for the dead")
ok(FT.lines_for(:lonely_sign).join =~ /chimera/, "LW2: Lonelywood's Sembian founders and their chimera crest")
m = mark; FT.scene_good_mead_arrival
ok(said_since?(m, /dinosaurs and serpents/) && said_since?(m, /Chult and the Vilhon Reach/), "GM1: Good Mead's carvings and founders")
ok(src("045_FoamingMugs.rb").include?("give(:FRIENDBALL, 2)"), "FM8: Izobai's two potions of animal friendship")
HL.warp(2135, 10, 10, 2)
$game_switches[4062] = false; clear(:kobold_questioned, :grek_fled)
HL.answers.unshift([/Grab the slower one/, 0])
m = mark; FT.mine_grek(nil)
ok(FT.flag?(:kobold_questioned) && said_since?(m, /Trex led us here/), "BM15: a captured kobold talks")
HL.answers.shift
ok(FT.lines_for(:dh_chorus_ears).join =~ /misshapen ears/ && FT.lines_for(:dh_chorus_teeth).join =~ /pointed teeth/, "DH1: Dougan's Hole's ears and teeth")
ok(map(2035).events.values.any? { |e| e.pages[0].list.any? { |c| c.parameters.to_s =~ /dh_pier(?!_)/ } } && FT.lines_for(:dh_pier).join =~ /keelboat/i,
   "DH1: the buckled pier and the keelboats")

# --- E16: the chasm's whisper is ahead of you; the cancel keys ---------------------
w3 = map(2044).events.values.select { |e| e.pages.any? { |pg| pg.list.any? { |c| c.parameters.to_s.include?("chasm_whisper(3") } } }
ok(!w3.empty? && w3.all? { |e| e.y == 26 }, "E16: whisper 3 is ahead of where you arrive (y 26), not behind")
src5 = src("023_Chapter5.rb")
ok(src5.include?('choose."), opts, opts.size)') && src5.include?('Ask the ghost..."), opts, opts.size)'), "E16: the cancel key leaves the clue and question menus")
class Object; alias f1_pbMessage pbMessage; end
def pbMessage(msg, cmds = nil, *r) = (cmds && msg.to_s =~ /wolf and moon/ ? -1 : f1_pbMessage(msg, cmds, *r))
clear(:gate_open)
m = mark; FT.guardian_gate(nil)
ok(said_since?(m, /step back from the bowls/) && !said_since?(m, /insulted/), "E16: cancelling at the Gate is stepping back, not an insult")
class Object; alias pbMessage f1_pbMessage; end

# --- the cooperage thug and Elza -------------------------------------------------
thug = events_named(map(2033), /Captured thug/).first
FT.set_flag(:shandar_exposed); $game_switches[4079] = false
FT.apply_w1_switches
ok(thug && thug.pages[1].condition.switch1_id == 4006 && $game_switches[4006], "E16: the exposed thug waits, tied up, in the cooperage until the vote")
ok(FT.lines_for(:gm_thug_after).join =~ /Naerth/, "E16: ...and has his lines")
FT.set_flag(:met_elza); FT.set_flag(:mugs_done); clear(:elza_thanked)
m = mark; FT.elza_shop(nil) rescue nil
ok(said_since?(m, /Battlehammer iron/), "E16: Elza thanks you after Foaming Mugs")

# --- A1: the sanctum only opens after the Gate --------------------------------------
clear(:gate_open); FT.set_flag(:order_locket)
m = mark; FT.hollow_wall(nil)
ok(said_since?(m, /won't give. Not yet/) && !$game_temp.player_transferring, "A1: the locket warms at the wall, but it won't open before the Gate's rite")

# --- A9: the warning on the bridge ----------------------------------------------
clear(:bridge_cracked)
m = mark; FT.bridge_crack(nil)
ok(said_since?(m, /She points up/) && said_since?(m, /right where you were standing/), "A9: she points up before the ice falls")

# --- A15: you wake where you last rested ---------------------------------------
clear(:camp_disturbed); FT.state[:chasm_nightmare] = true
m = mark; FT.chasm_loss_nightmare
ok(said_since?(m, /a long way from the chasm/), "A15: no fissure camp, no waking by the fissure")

# --- A14 / A19 / A21 / A23 / A28 / A29 / A30 / A32: lines restored --------------
ok(src5.include?('as(:shade, "(already moving) That\'s...")') && src5.include?('as(:shade, "She knew her name.'), "A14: Shade's chasm lines go through as()")
ok(src5.scan("forsake your curse").size >= 2, "A19: \"Abandon your bond, forsake your curse, and be free\"")
ok(src5.include?("Don't take another step!"), "A19: \"Don't take another step!\"")
ok(FT.lines_for(:channeler_mag_after).join =~ /new moon/, "A21: the cackling on the new moon, and the town's plea")
ok(src5.include?("As if someone still watches over it."), "A23: the locket's warmth")
ok(src5.include?('We thought about letting her do it.') && src5.include?("choose the light now"), "A28: the ghost absolves, and urges the light")
src44 = src("044_ChasmFaithful.rb")
ok(src44.include?("a new Order, small and stubborn"), "A29: the Order rekindled (order_wardens is read)")
ok(src44.include?("goes hungry in the deep cold"), "A30: the staff's taint")
ok(src44.include?("Rest, warden. We kept it."), "A32: Reptin's words over her resting place")

puts "\n#{$results.count { |c, _| c }}/#{$results.size} F1 checks passed"
exit($results.all?(&:first) ? 0 : 1)
