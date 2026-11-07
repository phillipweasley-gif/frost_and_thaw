# Act II scene pass, part 15 (builder h): Rootspire's side content, played in
# the real game, beat by beat. The story driver never walks most of it, so
# this warps to each quest, sets what it needs, talks to the people, and
# checks the flags and the lines.
#   PIF_DIR=/home/claude/pifrun_X ruby tools/headless/try_rootspire_side.rb
#   HL_OUT=log.txt to keep the as-played log (for the box checks)
$stdout.sync = true
require_relative "driver"

HL.start_up
# the as-played trace's hooks ([offstage], [stage], [screen]...), without its story run
def clean_binding = binding     # (its own locals: the trace's closures mustn't share ours)
eval(File.read(File.expand_path("script_trace.rb", __dir__)).split(/^at_exit do/).first, clean_binding, "script_trace.rb")
$after_start_up&.call
HL.quiet = !ENV["HL_VERBOSE"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1],
              [/What will you take/, ->(_t, c) { c.size - 1 }]]
HL.new_game
HL.frames(60)
T = FrostThaw

$checks = []
def check(ok, label)
  $checks << [ok, label]
  puts "#{ok ? 'ok  ' : 'FAIL'} #{label}"
end
def ev(name) = $game_map.events.values.find { |e| e.name == name || e.name.start_with?(name) }
def heal = $Trainer.party.each { |pk| pk.heal }
def talk(name)
  e = ev(name) or (check(false, "no event #{name.inspect} on map #{$game_map.map_id}"); return)
  HL.log << "[talk] #{e.name} on #{$game_map.map_id}"
  r = HL.talk_to(e)
  HL.settle(4000)
  heal
  r
end
def answer(*rules) = HL.answers.unshift(*rules.reverse)
def go(map, x, y, dir = 2) = HL.warp(map, x, y, dir)
def flag(f) = T.flag?(f)
def set(*fs) = fs.each { |f| T.set_flag(f) }
def unset(*fs) = fs.each { |f| T.set_flag(f, false) }
def said?(re, from = 0) = HL.log[from..].any? { |l| l.start_with?("[msg]") && l =~ re }
def logpos = HL.log.size
def offstage_since(n) = T.offstage_speakers.drop(n)

T.state[:companions] = [:alberica, :reptin, :alerion, :glimmer, :meat_meat]
%i[reversal rootspire_arrived met_hellen wardens_emeritus heard_wall_rule twins_met glimmer_joined
   rite_stopped badge_hearth act1_done].each { |f| set(f) }
T.state[:rs_day] = 2
$Trainer.party << Pokemon.new(:FORGEL, 75) while $Trainer.party.size < 3
$Trainer.party.each { |pk| pk.level = 75; HL.sensible_moves(pk, nil); pk.calc_stats; pk.heal }
$Trainer.money = 90_000
$PokemonGlobal.repel = 999_999 rescue nil
off0 = T.offstage_speakers.size

begin
  # --- greeters at the top of each new tier (notes/15 F1) ----------------------
  go(2180, 62, 40, 4)
  n = logpos; talk("Clerk at the stair")
  check(said?(/\ACLERK: |\[msg\] CLERK: /, n) || said?(/CLERK:/, n), "a clerk at the top of the root-stair says what the Halls hold")
  go(2189, 27, 43, 8)
  n = logpos; talk("Doorman at the bridge")
  check(said?(/DOORMAN:/, n), "a doorman at the leaf-bridge says what the Promenade holds")

  # --- Lumea's fox is out on the Promenade (notes/15 E6) -----------------------
  check(ev("Escaped illusion") && !ev("Escaped illusion").character_name.to_s.empty?, "the escaped fox waits on the Promenade")
  talk("Escaped illusion")
  check(flag(:atelier_fox_seen), "it says its piece (\"Choose warmth.\")")

  # --- a master shows their watcher at the first meeting (notes/15 E3) ----------
  go(2181, 8, 8, 8)
  n = logpos; talk("Bryn of Spring")
  check(flag(:met_bryn) && said?(/twiggy ducks out of sight/, n), "Bryn's first meeting shows his watcher in the doorway")

  # --- the Suncleft opens on the same press, no bump (notes/15 E9) --------------
  set(:warm_window_seen)
  answer([/Force the warm lock/, 0])
  go(2189, 31, 38, 8)
  HL.step(8); HL.settle(4000)
  check(flag(:suncleft_open) && $game_map.map_id == 2194, "the Suncleft's warm lock gives, and you're inside (map #{$game_map.map_id})")

  # --- Gorran and the warm ore (notes/15 E4) ------------------------------------
  T.give_key(:FT_WARMORE)
  set(:met_gorran)
  answer([/warm ore on Gorran's anvil/, 0])
  go(2052, 8, 8, 8)
  n = logpos; talk("Gorran Ashal-Forge")
  check(flag(:gorran_confronted) && !T.has_key?(:FT_WARMORE), "the warm ore goes on Gorran's anvil, and he owns up")
  check(said?(/Same boat Jorik's fell off\. Busy boat\./, n), "Alerion: \"Same boat Jorik's fell off. Busy boat.\"")

  # --- the Frozen Run: Ivran's ship keeps pace, and the shape under the ice -----
  set(:ch7_started, :met_shivven, :shivven_told)
  answer([/Escort Ivran's ship/, 0])
  go(2055, 25, 7, 8)
  talk("Captain Ivran Solmar")
  talk("Captain Ivran Solmar") if !flag(:frozen_run_started) && $game_map.map_id == 2055
  HL.settle(4000)
  check($game_map.map_id == 2199, "Ivran's escort starts on the Frozen Run (map #{$game_map.map_id})")
  ship = ev("Ivran on his sledge-ship")
  check(ship && !ship.character_name.to_s.empty?, "the sledge-ship (Ivran, standing in for it) is on the ice")
  x0 = ship && ship.x
  %i[revenant_hask revenant_moirin revenant_tobe].each do |k|
    e = $game_map.events.values.find { |v| v.name.start_with?("Trainer(") && v.list.any? { |c| c.parameters.any? { |p| p.to_s.include?(":#{k}") } } }
    check(e, "the revenant #{k} walks the ice")
    next if !e
    HL.talk_to(e); HL.settle(4000); heal
    check(T.trainer_beaten?(k), "#{k} put down")
    HL.frames(150); HL.settle(3000)
  end
  check(ship && ship.x > x0.to_i, "the ship creaks on as the revenants fall (#{x0} -> #{ship && ship.x})")
  go(2199, 44, 10, 6)
  talk("The far shore")
  check(ship && ship.x >= 40, "the ship comes up the lane to meet you at the shore (x #{ship && ship.x})")
  check(flag(:frozen_run_done), "across the Frozen Run")
  go(2199, 40, 13, 2)
  n = logpos; talk("Dark ice")
  HL.settle(4000)
  check(said?(/Home\. Now\. Please\./, n), "the dark ice: Alberica's \"Home. Now. Please.\"")
  check($game_map.map_id == 2055, "and you're back on the Split Dock (map #{$game_map.map_id})")

  # --- the Verdant Heist: the four wards, answered right ------------------------
  set(:heist_offered); $game_switches[T::SW_RUN_OPEN] = true rescue nil
  answer([/Slip past in the dark/, /Slip past/], [/loose end/, /loose end/], [/Pick it/, /Pick it/], [/Feel for it/, /Feel for it/])
  go(2198, 5, 5, 2)
  [[10, 5], [25, 10], [18, 15], [8, 15]].each { |x, y| HL.walk_to(x, y); HL.settle(2000); heal }
  check((T.state[:heist] || {})[:wins].to_i >= 4, "past the four wards (#{T.state[:heist].inspect})")
  talk("Guild vault")
  check(($PokemonBag.pbHasItem?(:FT_RELIQUARY) rescue false), "the sealed reliquary")

  # --- Kelyn at the orb, by night: she denies it first (dialogue/15 §5) --------
  answer([/What do you tell Kelyn/, 1])
  set(:autumn_note, :orb_visions, :halo_orb_cleared); T.state[:rs_day] = 4   # (Kelyn's at the orb from the third night)
  go(2061, 23, 24, 8)
  n = logpos; talk("High Speaker at the orb")
  check(said?(/I come up here to think/, n) && said?(/You don't believe me/, n), "Kelyn denies it before she owns up")
  check(flag(:kelyn_secret), "Pellar's note turns her (kelyn_secret)")
  HL.frames(40)
  check(($game_screen.tone.red rescue 0).zero?, "day comes back after the night scene")

  # --- Kethan's traitor, picked by the player; Ash denies, Kethan walks in -----
  set(:warden_map_seen, :jorik_confessed, :gem_vibrates, :met_kethan)
  answer([/whose name sits under/, /Ash, on the south steps/], [/Look at the Hall's stores/, 1], [/Spar\?/, 1])
  go(2183, 12, 15, 8)
  talk("Captain Kethan Vale")
  talk("Captain Kethan Vale") if !flag(:ash_named)
  check(flag(:ash_named), "you name Ash to Kethan")
  go(2050, 28, 27, 8)
  ash = ev("Trainer(3)"); $game_self_switches[[2050, ash.id, "A"]] = true if ash   # (beaten once, as a trainer)
  $game_map.need_refresh = true; HL.settle(300)
  $Trainer.party.each { |pk| pk.level = 100; pk.calc_stats; pk.heal }
  # (Ash's team has Flash Fire; lead with water so the driver doesn't punch fire into it)
  $Trainer.party.unshift(Pokemon.new(:BLASTOISE, 100).tap { |pk| HL.sensible_moves(pk, nil); pk.calc_stats; pk.heal }) if $Trainer.party.size < 6
  n = logpos; talk("Trainer(3)")
  if !flag(:ash_exposed)                             # (the driver loses a battle now and then: once more)
    heal; go(2050, 28, 27, 8)
    $game_self_switches[[2050, ev("Trainer(3)").id, "A"]] = true if ev("Trainer(3)")
    $game_map.need_refresh = true; HL.settle(300)
    talk("Trainer(3)")
  end
  check(said?(/Pull on the rope, Kethan\. See who pulls back\./, n) || flag(:ash_exposed), "Ash denies, then Kethan comes for him")
  check(flag(:ash_exposed), "Ash is exposed (ash_exposed)")

  # --- Wynsnow's anchor: the third choice (notes/15 E7) ------------------------
  set(:grafting, :lecture_done)
  answer([/Wynsnow waits/, /Anchor us/])
  go(2063, 13, 6, 8)
  n = logpos; talk("Professor Wynsnow")
  check(flag(:chronal_anchored), "Anchor us: the full vision, at a price (chronal_anchored)")

  # --- Halden: kick the chair over (notes/15 E12) -------------------------------
  set(:met_halden)
  T.state[:halden_seen_at] = 0 rescue nil
  answer([/What do you do\?/, /Kick the chair/])
  go(2062, 6, 12, 8)
  3.times { talk("Professor Halden Vex") if !flag(:halden_done) }
  check(flag(:halden_done), "Halden's engine ends without a battle when you kick the chair (#{T.flag?(:met_halden)})")

  # --- Hellen's note, the grey cloak, and Ivran (dialogue/15 §3) ----------------
  set(:root_tier_arrived, :hellen_passages)
  unset(:hellen_note_given)
  go(2053, 4, 7, 8)
  n = logpos; talk("Hellen Brightrun")
  check(flag(:hellen_note_given) && said?(/a man in a grey cloak puts down his cup/, n), "Hellen's note, with the grey cloak at the bar")
  answer([/You're being followed/, /Turn round/])
  go(2055, 25, 7, 8)
  n = logpos; talk("Captain Ivran Solmar")
  check(flag(:hellen_note_delivered) && said?(/the Requiem remembers/, n), "the note reaches Ivran; the follower is faced on the dock")

  # --- the shrine in Hellen's cellar: Tobin (048_H) -----------------------------
  set(:hellen_note_thanked, :shrine_frost_asked)
  answer([/Sit up with the shrine/, 0], [/The novice/, 0])
  go(2059, 3, 23, 8)
  n = logpos; talk("Sign herald_shrine")
  check(flag(:tobin_turned) && flag(:lantern_runes_known), "Tobin, at the shrine at night, tells you about the hooks")

  # --- Eirwen: the ledger to the Council, and Kelyn comes up (notes/15 E10) -----
  set(:met_eirwen)
  answer([/Naerth's ledger/, /Take it to the Council/])
  go(2062, 7, 6, 8)
  n = logpos; talk("Eirwen Solglass")
  check(flag(:naerth_ledger_council), "the ledger goes to the Council")
  check(said?(/has had a great many things it decided the city wasn't ready for/, n) ||
        said?(/a lot of things it decided we weren't ready for/, n) || said?(/aren't ready for a lot/, n), "and someone says what the Council does with things")

  # --- the Canticle's lost verses (dialogue/15 §5) ------------------------------
  set(:key_found); unset(:key_attuned, :canticle_learned, :canticle_researched, :canticle_partial)
  answer([/How do you want to look/, 0], [/sung for hope/, /Spring/], [/for loss/, /Autumn/])
  go(2062, 7, 6, 8)
  n = logpos; talk("Eirwen Solglass")
  check(said?(/humming like a song with no words/, n), "Eirwen answers the humming key")
  check(flag(:canticle_researched), "the three verses come back")

  # --- Glimmer's envoy, and the Heralds answering each other (dialogue/15 §3) ---
  set(:glimmer_rite_done, :orb_visions); unset(:envoy_judged)
  answer([/What do you tell him\?/, /yours to choose/])
  go(2061, 20, 24, 8)
  n = logpos; talk("Lumin Weavemoss"); talk("Lumin Weavemoss") if !flag(:envoy_judged)
  check(flag(:envoy_judged) && said?(/Hope's slow, Reptin\./, n), "the envoy; Alerion answers Reptin")
  check(said?(/rolled her eyes about it\./, n) && said?(/But she'd have said it\./, n), "Glimmer's line, word for word, in two boxes")

  # --- the Heartwarden's Staff at the Wall, by night ----------------------------
  T.give_key(:FT_UNBONDEDSTAFF)
  answer([/Rest the night here/, 0], [/The cold is the old cold/, /Breathe with the staff/], [/Then spring again/, /Let it turn/])
  go(2060, 45, 9, 6)
  n = logpos; talk("Sign auroral_wall")
  check(flag(:staff_attuned), "the staff is bonded at the edge of the light")
  check(($game_screen.tone.red rescue 0).zero?, "and the night tone clears")

  # --- the Hearth's mornings: Selrae at the back door, the favour track ---------
  set(:eline_named_selrae, :selrae_courted); unset(:selrae_halo_known, :ch7_started)
  set(:glasswater_recap); T.state[:favour] = {}
  go(2053, 4, 7, 8)
  n = logpos; talk("Hellen Brightrun")
  check(flag(:selrae_halo_known) && said?(/Better a cult I can see/, n), "Selrae owns up at the back door after the Rite")
  T.state[:favour] = { spring: 2 }; T.state[:patron_faction] = nil
  n = logpos; talk("Hellen Brightrun")
  check(T.state[:patron_faction] == :spring && said?(/Renewal Wardens of Spring count you as friends now/, n),
        "Spring's boon names the faction, and its rival notices (#{T.state[:favour].inspect})")
  check((T.state[:favour][:autumn] || 0) < 0, "the rival is Autumn, from the one rival table (047d)")

  # --- the Cycle Day Conspiracy (GQ3), lanterns known -------------------------
  set(:lantern_runes_known); unset(:cycle_day_done, :effigy_saved)
  # (challenge options come in a shuffled order: answer by what they say)
  right = [[/Follow her how/, /three dancers/], [/Which lanterns/, /don't flicker/], [/Break the rune how/, /last stroke/],
           [/Get past the ring how/, /round-dance/], [/Who isn't looking up/, /counting/], [/The last string/, /Cut it/],
           [/The kneelers/, /Break their hands/]]
  answer(*right)
  go(2050, 31, 28, 2)
  T.cycle_day_conspiracy; HL.settle(3000); heal
  check(flag(:cycle_day_done) && flag(:effigy_saved), "the festival hunt: each step its own question, the effigy saved")
  HL.answers.shift(right.size)

  # --- ...and lost: Auril's Icy Avatar, the music cut, the dead counted ---------
  unset(:lantern_runes_known, :cycle_day_done, :effigy_saved, :festival_casualties)
  answer([/Follow her how|Which lanterns|Break the rune how|Get past the ring how|Who isn't looking up|The last string|The kneelers/,
          /Follow close|brightest|Blow the candle|Push through|crying with joy|Shout for the Rootwardens|Talk to them/])
  go(2050, 31, 28, 2)
  n = logpos; T.cycle_day_conspiracy; HL.settle(3000); heal
  check(flag(:icy_avatar_fought) && flag(:festival_casualties), "three misses: the avatar at the Still Sky Shrine")
  check(HL.log[n..].any? { |l| l =~ /Eleven\. Eleven, on the seventh night/ }, "Kelyn counts the dead in the Circle")
  check(HL.log[n..].any? { |l| l =~ /^\[music\].*Lavender/ }, "the music goes quiet for it")
  HL.answers.shift

  # --- the trial week and the Council (047d) ------------------------------------
  unset(:pilgrim_dream)
  go(2053, 4, 7, 8)
  n = logpos; T.pilgrim_dream
  check(said?(/That night, you all dream the same dream/, n) && said?(/who listen for the cold/, n), "the pilgrim dream, at night, to Alerion")
  set(:council_support, :rootwardens_favour, :darrus_redeemed); T.state[:council_ally] = :rheven
  unset(:council_heralds, :council_uncertain, :council_support_paid, :darrus_paid)
  set(:council_rheven)
  go(2054, 12, 15, 8)
  FrostThaw::Stage.actor(:rheven, 10, 13, 2, graphic: "FT_captain_rheven_stormbranch")    # (seated, as scene_four_chairs seats him)
  n = logpos; T.four_chairs_consequences
  check(said?(/That's two the Rootwardens owe you/, n), "Rheven remembers the festival")
  check(flag(:council_support_paid) && said?(/whatever you need/, n), "the Council's support is read back")
  check(said?(/a man in a borrowed coat/, n), "Darrus's crate: a man in a borrowed coat")

  # --- owner's cuts (story/15, 2026-11-07): the two-day rite, Meat Meat's two days, Eira ---
  unset(:glimmer_rite_done, :brightmane_answered, :lumin_rite_offered, :envoy_judged)
  T.state[:dt] = {}; T.state[:dt_day] = {}
  answer([/Begin the rite with Lumin/, 0])
  go(2061, 20, 24, 8)
  n = logpos; talk("Lumin Weavemoss")
  check(said?(/Two days, sun-up to sundown/, n) && said?(/THE FIRST DAY/, n) && ($PokemonBag.pbHasItem?(:FT_MANEBRAID) rescue false),
        "the rite's first day: the Severance, and the mane-braid at dusk")
  T.state[:rs_day] = T.rs_day + 1
  n = logpos; talk("Lumin Weavemoss")
  check(flag(:glimmer_rite_done) && said?(/THE SECOND DAY/, n) && flag(:brightmane_answered), "the second day: the Acceptance, and Brightmane answers")
  unset(:razzy_first_flight, :mm_undercity_walk); T.state[:summer_sense_day] = nil
  answer([/Razzilith in the glade|undercity alone/, 0], [/climb on/i, 0])
  go(2053, 4, 7, 8)
  T.meat_meat_day; HL.settle(3000)
  check(flag(:razzy_first_flight) && ($PokemonBag.pbHasItem?(:QUICKCLAW) rescue false), "Meat Meat's first day: the glade, and the roof drills that night")
  T.state[:rs_day] = T.rs_day + 1
  go(2053, 4, 7, 8)
  n = logpos; T.meat_meat_day; HL.settle(3000)
  check(flag(:mm_undercity_walk) && said?(/the dawn is wrong/, n) && T.state[:summer_sense_day], "her second: the undercity, out into a wrong dawn")
  go(2056, 12, 14, 8)
  check(!ev("Eira Voss"), "Eira's stall is gone from the Shrine")
  unset(:cellar_cleared)
  go(2188, 16, 12, 8)
  n = logpos; talk("Eira Voss")
  check(said?(/I sold stillness at the Shrine/, n), "Eira, met in the Frozen Cellar, says what she sold")
rescue StandardError => e
  check(false, "#{e.class}: #{e.message} #{e.backtrace.first(4).join(' | ')}")
end

off = T.offstage_speakers.drop(off0)
check(off.empty?, "nobody speaks off stage (#{off.inspect})")
bad = $checks.reject(&:first)
puts "\n#{$checks.size - bad.size}/#{$checks.size} checks passed"
File.write(ENV["HL_OUT"], HL.log.join("\n")) if ENV["HL_OUT"]
