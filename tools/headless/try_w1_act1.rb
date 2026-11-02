# W1 (the faithful build-out): plays every new and rewritten Act I scene of the
# Cackling Chasm and Sephek's "Cold-Hearted Killer" in the real game code, with
# real battles, and checks each branch lands where it should.
#   PIF_DIR=/home/claude/pifrun_W1 ruby tools/headless/try_w1_act1.rb
require_relative "driver"
HL.start_up
HL.quiet = !ENV["HL_VERBOSE"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1], [/save your game/, 1]]
HL.new_game; HL.frames(200)
FT = FrostThaw unless defined?(FT)
$results = []
def ok(c, m) = ($results << [c, m]; puts "#{c ? 'ok  ' : 'FAIL'} #{m}")
def msgs = HL.log.select { |l| l.start_with?("[msg]") }
def said?(re) = HL.log.any? { |l| l =~ re }
def mark = HL.log.size
def since(m) = HL.log[m..]
def said_since?(m, re) = since(m).any? { |l| l =~ re }
def bag?(it) = ($PokemonBag.pbHasItem?(it) rescue false)
def ev(name) = $game_map.events.values.find { |e| e.name == name }
def clear(*fl) = fl.each { |f| (FT.state[:flags] || {}).delete(f) }
def strong_party
  $Trainer.party.clear
  [[:ARCANINE, 62], [:GYARADOS, 62], [:ALAKAZAM, 62], [:MACHAMP, 62], [:B6H130, 62], [:SNORLAX, 62]].each do |sp, lv|
    pk = Pokemon.new(sp, lv); HL.sensible_moves(pk); pk.calc_stats; $Trainer.party << pk
  end
end
$game_switches[Settings::NO_MONEY_LOSS] = true rescue nil
FT.state[:companions] = %i[alberica reptin alerion shade meat_meat]
%i[met_party badge_targos badge_bryn badge_dougans golden_acorn stood_with_alberica].each { |f| FT.set_flag(f) }
strong_party

# --- SC 4.09: the hag's bargain at the Twenty Stones ---------------------------------
HL.warp(2035, 10, 20, 2)
m = mark
HL.answers.unshift([/The hag waits for your answer/, 0])
FT.hag(nil)
ok(FT.flag?(:hag_bargain_offered) && FT.flag?(:asked_hag_task), "the hag offers her bargain at the Stones (and names the task)")
ok(said_since?(m, /end the winter/) && said_since?(m, /take the wolf out of him/), "...the winter and Reptin's wolf, in her words")
ok(said_since?(m, /REPTIN: \(quietly\) \.\.\.She can do that\?/), "...and Reptin is tempted")

# --- SC 5.01-5.02: the dream, and the crone at the door ------------------------------
HL.warp(2041, 14, 2, 2)
m = mark; FT.scene_waste_start
ok(said_since?(m, /Give it to me\. Let me take it away/), "Reptin's dream carries the crone's offer")
HL.warp(2042, 16, 36, 8)
HL.answers.unshift([/The crone waits, smiling/, 1])
m = mark; clear(:chasm_entered); FT.scene_cackling_enter
ok(FT.flag?(:saw_through_illusion), "watching the crone closely shows she's an illusion")
ok(said_since?(m, /Granny's fire/) && said_since?(m, /cure for all your troubles/), "...after Granny's fire and the cure ahead")
m = mark; FT.chasm_whisper(1); FT.chasm_whisper(1)
ok(since(m).count { |l| l.include?("whispers your name") } == 1, "names are whispered once, not twice")
FT.set_flag(:mephits_done); $game_switches[3927] = true
FT.chasm_fallen_ice(nil)
ok(FT.flag?(:saw_gnoll_femur), "the gnoll femur in the fallen ice")

# --- SC 5.04: the feast hall ---------------------------------------------------------
m = mark; FT.scene_feast_hall_enter
ok(FT.flag?(:reptin_amber) && FT.flag?(:read_blood_runes), "the feast hall: Reptin's eyes go amber, the Yeenoghu runes are read")
ok(said_since?(m, /human arm/) && said_since?(m, /HUNGER\. FEAST\./), "...the carnage and the runes in full")
money = $Trainer.money
coins = ev("Coins"); FT.chasm_coins(coins&.id)
ok($Trainer.money == money + 1250, "the scattered coins are worth something")
HL.answers.unshift([/Take the greataxe/, 0])
FT.gnoll_axe(ev("Gnoll")&.id)
ok(bag?(:FT_GNOLLAXE), "the gnoll's greataxe can be taken (the ears can't)")
# the mother yeti, three ways
clear(:yeti_faced, :yeti_calmed, :yeti_avoided, :yeti_mother_dead)
HL.answers.unshift([/What do you do\?/, 2])
FT.mother_yeti(nil)
ok(FT.flag?(:yeti_avoided) && !FT.flag?(:yeti_mother_dead), "backing away leaves the mother alive, guarding her mate")
clear(:yeti_faced, :yeti_avoided); HL.answers.shift
HL.answers.unshift([/What do you do\?/, 0])
FT.mother_yeti(nil)
ok(FT.flag?(:yeti_calmed), "the lullaby (if you stood with Alberica) calms her")
clear(:yeti_faced, :yeti_calmed); HL.answers.shift
HL.answers.unshift([/What do you do\?/, 1])
m = mark; FT.mother_yeti(nil)
ok(FT.flag?(:yeti_mother_dead) && said_since?(m, /A whole family, destroyed/), "fighting her: she fights to the death over her mate")
ok(said_since?(m, /time is ticking/i), "...and the hag's echo: time is ticking")
ok(FT.lines_for(:mother_yeti_after).first.include?("doesn't move"), "...and stays dead")
HL.answers.shift
m = mark; FT.dead_yeti(nil)
ok(FT.flag?(:found_swaddling) && said_since?(m, /We won't let her do this to anyone else/), "the swaddling, and Reptin's vow")
m = mark; FT.chasm_backpack(nil)
ok(bag?(:FT_GLIMMERJOURNAL) && said_since?(m, /desperate to save Alberica/) && said_since?(m, /signed: Glimmer/), "Glimmer's journal, as written")

# --- SC 5.05: the hall of illusions --------------------------------------------------
m = mark; clear(:seen_illusion_fork); FT.scene_illusion_fork
ok(said_since?(m, /grinning/) && said_since?(m, /A loop/) && said_since?(m, /Colder air/) && said_since?(m, /don't line up/),
   "the fork: grinning reflections, and every clue (air, reflections, the looped weeping)")
clear(:seen_weeping_dark, :took_left, :took_right, :fork_talked)
m = mark; FT.scene_weeping_dark
ok(said_since?(m, /Don't leave me! Please!/) && said_since?(m, /never was/), "the dark way: the child begs, the weeping was never there")

# --- SC 5.06: the rift: the crossing, the fall, the floor ----------------------------
HL.warp(2044, 5, 28, 8)
HL.answers.unshift([/How do you cross/, 2])
FT.scene_rift_arrive
ok(FT.state[:bridge_plan] == :walk, "you choose how to cross the bridge")
m = mark; FT.scene_rift_walker_wakes
ok(said_since?(m, /pinpoints of blue-white light/), "the coldlight walker's eyes ignite as you start across")
HL.answers.unshift([/You're going over/, 0])
FT.bridge_slip(nil); HL.frames(10); HL.settle(800)
ok($game_map.map_id == 2100 && FT.flag?(:fell_into_rift), "walking it, grabbing the old railing: you fall to the rift floor (#{$game_map.map_id})")
FT.scene_rift_floor_arrive
ok(said?(/eighty feet down/) && FT.flag?(:rift_floor_seen), "...and land eighty feet down")
gr = ev("Gnoll remains"); FT.gnoll_remains(gr&.id)
ok(FT.flag?(:rift_gnoll_laid), "the gnoll ghost on the rift floor is laid to rest")
HL.answers.unshift([/Climb back up/, 0])
FT.rift_floor_climb(nil); HL.frames(10); HL.settle(800)
ok($game_map.map_id == 2044, "the ice chute climbs back to the rift")
clear(:rift_voices); FT.set_flag(:took_right); clear(:took_left)
m = mark; FT.rift_voices(nil)
ok(said_since?(m, /mother laughing/) && said_since?(m, /You said you'd come back/) && said_since?(m, /Why won't you help me/),
   "voices on the wind, one each, and the girl's reflection")
HL.answers.unshift([/Fight the coldlight walker/, 0])
FT.coldlight_walker(ev("Coldlight walker")&.id)
ok(FT.flag?(:walker_down), "the coldlight walker can be laid to rest")
clear(:bridge_slipped); FT.state[:bridge_plan] = :rope
m = mark; FT.bridge_slip(nil)
ok(said_since?(m, /rope snaps taut/), "roped up, a slip leaves you dangling, not falling")
# the gate: a wrong offering
HL.answers.unshift([/Make an offering/, 0], [/wolf and moon/, 2], [/scythe and child/, /coin/i])
m = mark; FT.guardian_gate(nil)
ok(said_since?(m, /deathly cold/) && FT.flag?(:gate_hint), "an insulting offering: the necrotic burst, the guardians, then the hint")
3.times { HL.answers.shift }
FT.set_flag(:bone_dust)
HL.answers.unshift([/Make an offering/, 0], [/wolf and moon/, 0], [/scythe and child/, /Bone dust/])
FT.guardian_gate(nil)
ok(FT.flag?(:gate_open), "the right offering opens the gate")
3.times { HL.answers.shift }

# --- SC 5.07: the last guardian ------------------------------------------------------
HL.warp(2045, 6, 7, 8)
FT.set_flag(:order_locket)
m = mark; FT.order_ghost(ev("Bier")&.id)
ok(FT.flag?(:ghost_blessing) && FT.flag?(:locket_talisman) && bag?(:FT_ORDERDAGGER) && FT.flag?(:tip_staff) && FT.flag?(:tip_flame),
   "the ghost: blessing, talisman, silver dagger, the staff and flame tips")
ok(said_since?(m, /Yeenoghu/) && said_since?(m, /Children of the Wolf/) && said_since?(m, /yeti child/) && said_since?(m, /howl of the wolf meets the cry/),
   "...the Order's fall, the wardens, the warning about the cub, the prophecy")
ok(said_since?(m, /soul-debt/) && said_since?(m, /Her cure is a ploy/) && said_since?(m, /eyes fly open/), "...the questions: the winter, the cure; the corpse rising")
HL.frames(5)
FT.codex_shelf(ev("Codex shelf")&.id)
ok(bag?(:FT_DRUIDCODEX), "the Druidic Codex from the shelf")

# --- the ice troll: only fire stops it knitting ---------------------------------------
def troll_fight(sp, moves)
  $Trainer.party.clear
  pk = Pokemon.new(sp, 40); pk.forget_all_moves; moves.each { |mv| pk.learn_move(mv) }; pk.calc_stats
  $Trainer.party << pk
  HL.battle_log = []
  FT.with_battle_script(:minions) { FT.boss_battle(FT.named_mon(:B68H221, 33, "Ice troll")) }
  (HL.battle_log || []).join("\n")
end
log = troll_fight(:MACHAMP, [:TACKLE])
ok(log =~ /knits itself back together/ && log =~ /Warm blood/, "the ice troll's flesh knits back between blows")
log = troll_fight(:ARCANINE, [:EMBER])
ok(log =~ /sears the troll's wounds shut/, "...unless fire hit it: then it can't")

# --- SC 5.08-5.10: the Heart ---------------------------------------------------------
strong_party
HL.warp(2046, 12, 45, 8)
HL.answers.unshift([/What do you do\?/, 0], [/She's going for the cub/, 1], [/Take Yetot/, 1], [/The Heart pulses/, 0])
m = mark
clear(:thredra_parley, :minions_down, :thredra_beaten, :reversal, :lunge_done)
FT.thredra(ev("Thredra")&.id); HL.frames(5); HL.settle(1500)
ok(said_since?(m, /necklace of what look like frozen baby teeth/) && said_since?(m, /I always keep my end of a bargain/) && said_since?(m, /How weak/),
   "the hag in full, her bargain called in, and her taunt")
bl = (HL.battle_log || []).join("\n")
ok(bl =~ /rises into the air/ && bl =~ /grey cold/, "her battle: the flight on the staff, the Heart's lair magic")

ok(FT.flag?(:broke_hag_staff) && FT.flag?(:reversal), "her lunge at the cub is stopped (the staff smashed), and the third way follows")
ok(%i[FT_GRAYSTAFF FT_OPAL FT_BLACKICERING FT_WOLFPELT FT_OWLFEATHER FT_WOLFBLOOM].all? { |i| bag?(i) }, "the spoils and the keepsakes are in your bag")
ok(said_since?(m, /wildflower/) && said_since?(m, /Glimmer in the Chasm/) && said_since?(m, /Balance is restored/), "the legacy glimpses as you fall")
ok(FT.flag?(:reptin_wolf_calm) && FT.flag?(:reptin_warden_vow), "the Heart knows its warden; Reptin's vow")
4.times { HL.answers.shift }

# --- the dark path: agree, and where it leads -----------------------------------------
strong_party
HL.warp(2046, 12, 45, 8)
clear(:thredra_parley, :minions_down, :thredra_beaten, :reversal, :lunge_done, :cub_sacrificed, :act1_done)
HL.answers.unshift([/What do you do\?/, 3], [/Let her kill the cub/, 0])
loops = FT.counter(:loop_count).to_i
m = mark
FT.thredra(ev("Thredra")&.id); HL.frames(10); HL.settle(1500)
ok(FT.flag?(:hag_bargain_taken) || FT.counter(:loop_count).to_i > loops, "you can agree to her bargain")
ok(said_since?(m, /sun comes up/) && said_since?(m, /howl/), "...the cub dies, the winter breaks, Reptin is cured")
ok(said_since?(m, /THE CRONE'S BARGAIN/) && FT.counter(:loop_count).to_i == loops + 1, "...and the wheel turns back (loop #{FT.counter(:loop_count)})")
ok((FT.state[:bargain_memory] || 0) >= 1, "...and the bargain is remembered next time round")
2.times { HL.answers.shift }

# --- on Hard, the module's coven: a second hag ------------------------------------------
strong_party
old_diff = $Trainer.selected_difficulty
$Trainer.selected_difficulty = 2
m = mark
won = FT.thredra_battle
ok(won && FT.flag?(:coven_sister) && said_since?(m, /ETHEL: You promised me a share/), "on Hard, her coven sister steps out of the ice and fights beside her")
$Trainer.selected_difficulty = old_diff

# --- holding still at her lunge, with no help: the cub is cut, not killed (F1) --------------
# Only the bargain, agreed out loud, ends the act; a wrong pick at the lunge mustn't.
FT.state[:companions] = %i[alberica reptin alerion shade meat_meat]
%i[golden_acorn stood_with_alberica].each { |f| FT.set_flag(f) }
strong_party
HL.warp(2046, 12, 45, 8)
clear(:thredra_parley, :minions_down, :thredra_beaten, :reversal, :lunge_done, :lunge_in_battle, :lunge_aftermath_said,
      :cub_sacrificed, :ghost_blessing, :locket_talisman, :locket_caught_wrist, :ghost_caught_knife, :cub_wounded,
      :reptin_wolf_surged, :shielded_cub, :broke_hag_staff, :freed_cub_midfight, :cub_home)
HL.answers.unshift([/What do you do\?/, 0], [/She's going for the cub/, 3], [/Take Yetot with you/, 1])
# (the mid-battle lunge is its own test in try_f1.rb; here she's KO'd before she can try, so it's the after-battle prompt)
orig_cornered = FT.method(:hag_cornered?)
FT.define_singleton_method(:hag_cornered?) { |_battle| false }
loops = FT.counter(:loop_count).to_i
m = mark
FT.thredra(ev("Thredra")&.id); HL.frames(10); HL.settle(1500)
ok(FT.flag?(:cub_wounded) && FT.flag?(:reptin_wolf_surged) && !FT.flag?(:cub_sacrificed) && FT.counter(:loop_count).to_i == loops,
   "holding still without help: Reptin's wolf turns the knife, the cub is cut but lives, and the act goes on")
ok(FT.flag?(:reversal) && said_since?(m, /It'll scar\. It'll live\./), "...the third way follows, and the cub's scar is remembered")
3.times { HL.answers.shift }
FT.define_singleton_method(:hag_cornered?, orig_cornered)

# --- losing to the Winter-Crowned hag: the witch-queen ending ---------------------------
$Trainer.party.clear
pk = Pokemon.new(:MAGIKARP, 5); pk.calc_stats; $Trainer.party << pk
HL.warp(2046, 12, 45, 8)
FT.state[:companions] = %i[alberica reptin alerion shade meat_meat]
clear(:thredra_parley, :minions_down, :thredra_beaten, :reversal, :lunge_done, :cub_sacrificed, :golden_acorn)   # (no acorn: "...Do it." is the third choice)
HL.answers.unshift([/What do you do\?/, 2], [/Let her kill the cub/, 0])
m = mark
FT.thredra(ev("Thredra")&.id); HL.frames(10); HL.settle(1500)
ok(said_since?(m, /Witch-Queen of the North/), "losing to her after the bargain: the witch-queen ending")
2.times { HL.answers.shift }

# --- losing in her lair: the nightmare, and you wake by the fissure ----------------------
$Trainer.party.clear
pk = Pokemon.new(:MAGIKARP, 5); pk.calc_stats; $Trainer.party << pk
HL.warp(2046, 12, 45, 8)
FT.state[:companions] = %i[alberica reptin alerion shade meat_meat]
clear(:thredra_parley, :minions_down, :thredra_beaten, :reversal, :lunge_done, :cub_sacrificed)
FT.set_flag(:thredra_parley)
m = mark
FT.thredra(ev("Thredra")&.id); HL.frames(10); HL.settle(1500)
ok(said_since?(m, /You dream of the Heart of the Chasm/), "losing in her lair: the witch-queen nightmare, and you wake")

# --- Sephek: Hlin, Torg's, and what he is ---------------------------------------------
FT.state[:companions] = %i[alberica reptin alerion shade shimmer]
HL.warp(2024, 15, 10, 8)
clear(:sephek_defeated, :hlin_hired, :hlin_paid, :torrga_beaten, :torrga_grudge)   # (met before the Moon Temple)
HL.answers.unshift([/Take Hlin's job/, 0])
m = mark; FT.hlin(ev("Hlin Trollbane")&.id)
ok(FT.flag?(:hlin_hired) && said_since?(m, /glassblower in Bryn Shander/) && said_since?(m, /Torg's/), "Hlin Trollbane hires you: three ice-dagger murders, Torg's")
HL.warp(2021, 36, 22, 8)
HL.answers.unshift([/What do you ask him/, 1])
m = mark; FT.sephek_torgs(nil)
ok(FT.flag?(:sephek_confessed) && said_since?(m, /She is owed/), "Sephek at Torg's: he admits the murders, and won't fight in town")
FT.torgs_sack(nil)
ok(FT.flag?(:found_torgs_corpse), "the frozen half-elf in Torrga's sack")
m = mark; FT.sephek_true_nature
ok(FT.flag?(:sephek_origin_known) && said_since?(m, /born in the water/), "what Sephek really is: a drowned sailor, and the frost druid wearing him")
FT.set_flag(:sephek_defeated)
strong_party
HL.answers.unshift([/Torrga waits/, 1])
FT.torrga(nil)
ok(FT.flag?(:torrga_beaten) && bag?(:FT_GEMSTONE), "confronting Torrga: the fight, and her strongbox")
money = $Trainer.money
FT.hlin(nil)
ok(FT.flag?(:hlin_paid) && $Trainer.money > money, "Hlin pays out once the murders stop")

puts "\n#{$results.count { |c, _| c }}/#{$results.size} W1 checks passed"
puts "problems:"; puts HL.problems.uniq
