# W4's slice, played headlessly from the end of Chapter 9: the trial week
# (every trial, the civic layer, the side stories, Gym 8, the verdict and the
# vote), then Chapter 11's Minor Avatar, the sigils, Auril's relics and the
# White Vault. STOP_AT=10 stops after the vote. Usage (from the test game):
#   PIF_DIR=/home/claude/pifrun_W4 ruby <wt>/tools/headless/try_w4.rb
require_relative "story_run"
FT = FrostThaw unless defined?(FT)

HL.start_up
HL.quiet = !ENV["HL_VERBOSE"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, ENV["HL_MODE"] == "herald" ? 1 : 0], [/Choose a difficulty/, 1],
              [/rest your Pokémon/, 0], [/save your game/, 1], [/endorse first|And second/, 0],
              [/^Talion\.\.\./, ->(t, c) { c.index { |x| x.to_s =~ /Decide what to do|Accept he's a reflection/ } || 0 }],
              [/Escape\?/, 0], [/Who speaks for the Heralds/, 0], [/Help with\.\.\./, 0]]
HL.answers << [/Which Herald|Who will you be|Which of the Heralds/, ->(t, c) { c.index { |x| x.to_s =~ /#{ENV['HL_HERALD']}/i } || 0 }] if ENV["HL_HERALD"]
HL.new_game
HL.frames(200)

# The end of Chapter 9, as the story leaves it
flags = %i[intro_done act1_done reversal rootspire_arrived met_hellen wardens_sworn rite_stopped ch7_started
           undercanopy_entered blight_cleared yarro_witness badge_undercanopy hyphora_named hyphora_sworn lake_cleansed
           mycolith_down godspark_shadow road_a_done heartroot_entered seal_open hew_confessed badge_hew mira_freed badge_mira
           mira_witness road_b_done child_saved autumn_fell forge_reached engine_dead glimmer_gone avarice_fled avarice_faked_death
           dragon_launched summer_ended mounted_up air_seams good_mead_saved air_pursuit dragon_down refugees_follow
           heralds_arrested twins_met glimmer_joined sap_gate_open wyn_joined]
flags.each { |f| FT.set_flag(f) }
FT.state[:companions] = %i[alberica reptin alerion meat_meat wyn] - [FT.state[:herald]]
[3934, 3935, 3936, 3937, 3938, 3942, 3944, 3945, 3974, 3981].each { |s| $game_switches[s] = true }
$Trainer.party.clear
%i[B330H152 FORGEL B7H221 SPOREYE B331H154 MYCONARCH].each { |sp| $Trainer.party << Pokemon.new(sp, 56) }
8.times { |i| $Trainer.badges[i] = i < 7 }
$Trainer.money = 30000
Story.fit(56)
FT.chapter10_start
HL.frames(30); HL.settle(5000)
t = Time.now
begin
  $headless_watchdog = Graphics.frame_count + 2_000_000
  Story.chapter10
rescue HeadlessStuck => e
  HL.problem("STUCK: #{e.backtrace.reject { |l| l =~ /internal/ }.first(6).join(' <- ')}")
end
puts "\n#{Story.beats.count { |_l, ok| ok }}/#{Story.beats.size} story beats in #{(Time.now - t).round}s"
puts "problems:"; puts HL.problems.uniq
File.write(ENV["HL_OUT"] || "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/w4.txt",
           HL.log.map { |l| l.dup.force_encoding("UTF-8") }.join("\n"))
