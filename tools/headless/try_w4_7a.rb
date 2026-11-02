# W4's Chapter 7A remainder, played headlessly from the Sap Gate: Verdant
# Sickness, the nursery, the Bazaar, the Fane, Mnemosyne's chamber, Eira, the
# Mycolith's minions and hoard; and the Frostfell rifts on the Canopy.
#   PIF_DIR=/home/claude/pifrun_W4 ruby <wt>/tools/headless/try_w4_7a.rb
require_relative "story_run"
FT = FrostThaw unless defined?(FT)

HL.start_up
HL.quiet = !ENV["HL_VERBOSE"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1],
              [/rest your Pokémon/, 0], [/save your game/, 1],
              [/^Ask Myr\.\.\./, ->(t, c) { c.index { |x| x.to_s =~ /wrong/ } || 0 }],
              [/^Eira\.\.\./, 0]]
HL.new_game
HL.frames(200)
%i[intro_done act1_done reversal rootspire_arrived met_hellen wardens_sworn rite_stopped ch7_started twins_met glimmer_joined
   sap_gate_open wyn_joined].each { |f| FT.set_flag(f) }
FT.state[:companions] = %i[alberica reptin alerion meat_meat wyn glimmer]
[3934, 3935, 3936, 3942, 3945].each { |s| $game_switches[s] = true }
$Trainer.party.clear
%i[B330H152 FORGEL B7H221 SABLEYE B331H154].each { |sp| $Trainer.party << Pokemon.new(sp, 44) }
4.times { |i| $Trainer.badges[i] = true }
Story.fit(46)
S = Story
FT.transfer(2050, 24, 21, 2)
$PokemonGlobal.repel = 999999
HL.frames(30); HL.settle(3000)
t = Time.now
begin
  $headless_watchdog = Graphics.frame_count + 2_000_000
  # GQ1: the rifts, while Glimmer lives
  S.lift_up; S.until_flag(:rifts_closed, 3) { S.travel(2061); S.talk(/Frostfell rifts/) }
  S.beat("GQ1 the Frostfell rifts closed (Rift-Warden's Light)", :rifts_closed)
  S.travel(2061); S.lift_down
  S.travel(2055); S.talk(/Sap Gate/); HL.walk_to(9, 21); HL.step(4); HL.settle(3000)
  S.travel(2068); HL.frames(20); HL.settle(3000)
  S.beat("into the Undercanopy", :undercanopy_entered)
  S.talk(/Captain Rheven \(blight\)/)
  S.until_flag(:blight_cleared, 3) { S.travel(2068); S.talk(/The Blight/) }
  S.beat("R1 Verdant Sickness (#{FT.flag?(:blight_cleansed) ? 'cleansed' : 'burned'})", :blight_cleared)
  S.talk(/Moss curtain/)
  S.beat("H1 the Secret Nursery", nil)
  puts "  nursery blessing: #{FT.blessing?(:nursery)}"
  S.talk(/^Faria$/)
  S.beat("H2 Faria's stolen amulets: the trail", :theft_tracking)
  S.talk(/Disused root/); HL.settle(3000)
  S.talk(/Kobold nest/) if $game_map.map_id == 2172
  S.beat("  the kobolds' nest", :amulets_found)
  S.travel(2068); S.talk(/^Faria$/)
  S.beat("  the amulets home (Rapport Amulet)", :amulets_returned)
  S.talk(/Spore games/)
  S.beat("H2 the spore games (Spore Charm)", :spore_games_won)
  S.talk(/Market duel/)
  S.beat("H2 the market duel", :duel_settled)
  S.talk(/Eira/)
  S.until_flag(:badge_undercanopy) { S.travel(2068); S.talk(/Sovereign Luminara/) }
  S.beat("GYM 7 Luminara", :badge_undercanopy)
  S.talk(/Sap pool/); S.talk(/Root thrones/); S.talk(/Memory niche/)
  S.beat("H3 the sap pool (a vision) and the memory niche", :niche_read)
  S.talk(/Rootwarden delegation/)
  S.beat("H3 the Rootwarden delegation (#{FT.flag?(:sap_settled) ? 'settled' : 'a grudge'})", :rootwarden_diplomacy)
  S.until_flag(:hyphora_named, 2) { S.travel(2068); S.talk(/Mnemosyne Myr/) }
  S.beat("H5 Hyphora named", :hyphora_named)
  HL.frames(10); HL.settle(2000)
  S.talk(/Ritual circle/); S.talk(/Memory archive/)
  S.beat("H5 the ritual circle", :circle_shared)
  S.fit(47)
  S.until_flag(:threads_defended, 2) { S.travel(2068); S.talk(/Tether threads/) }
  S.beat("H5 the tether threads (Hyphora's Circlet)", :threads_defended)
  S.talk(/Archive thief/)
  S.beat("H5 the Memory Heist", :heist_thwarted)
  S.talk(/A Rootwarden at the pool/)
  S.beat("H3 the cultist poisoner", :poisoner_caught)
  S.talk(/Mnemosyne Myr/)          # the dream
  if $game_map.map_id == 2171
    HL.frames(20); HL.settle(3000)
    S.talk(/Hiding sporeling/); S.talk(/Giant logger/)
  end
  S.beat("H5 the Dream Rescue", :dream_rescued)
  S.travel(2068); S.talk(/Mnemosyne Myr/)   # the trade
  S.beat("H5 the Memory Trade", :memory_traded)
  S.step_on(/Root tremor/)
  S.beat("H1 the root tremor", :tremor_done)
  S.talk(/^Eira/); S.talk(/^Eira/)
  S.until_flag(:spore_guard, 3) { S.fit(48); S.travel(2068); S.talk(/^Eira/) }
  S.beat("Eira: the stalkers, the missing patrols, the spore-guard", :spore_guard)
  S.fit(48)
  S.talk(/The Blight/)
  S.beat("H1 Yarro's lake errand", :yarro_errand_done)
  S.fit(48)
  S.until_flag(:lake_cleansed) { S.travel(2069); S.talk(/Lake-wyrm/) }
  S.travel(2070); HL.frames(20); HL.settle(3000)
  %w[mask fist hourglass paw shadow].each { |k| S.talk(/Carving #{k}/) }
  S.until_flag(:mycolith_down, 4) { S.travel(2070); S.talk(/Shadow Mycolith/) }
  S.beat("the Mycolith's lake minions, both phases", :mycolith_minions_2)
  S.beat("the Mycolith's hoard", :mycolith_hoard)
  S.travel(2068); S.talk(/Sovereign Luminara/)
rescue HeadlessStuck => e
  HL.problem("STUCK: #{e.backtrace.reject { |l| l =~ /internal/ }.first(6).join(' <- ')}")
end
puts "\n#{Story.beats.count { |_l, ok| ok }}/#{Story.beats.size} beats in #{(Time.now - t).round}s"
puts "problems:"; puts HL.problems.uniq
File.write(ENV["HL_OUT"] || "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/w4_7a.txt",
           HL.log.map { |l| l.dup.force_encoding("UTF-8") }.join("\n"))
