# Checks the story driver's slide_to_event on the Overflow Channel's slick sap:
# from the landing, slide to Auril's relic in the middle of the flow and smash it.
#   PIF_DIR=/home/claude/pifrun_F3 ruby tools/headless/try_slide.rb
require_relative "driver"
require_relative "story_run"
HL.start_up
HL.quiet = !ENV["HL_VERBOSE"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1], [/save your game/, 1]]
HL.new_game; HL.frames(200)
FT = FrostThaw unless defined?(FT)
$Trainer.party.clear
[[:ARCANINE, 70], [:GYARADOS, 70], [:ALAKAZAM, 70]].each { |sp, lv| pk = Pokemon.new(sp, lv); HL.sensible_moves(pk); pk.calc_stats; $Trainer.party << pk }
FT.set_flag(:sephek_risen) rescue nil
$game_switches[FT::SW_AURIL_RELICS] = true
HL.warp(2067, 3, 3, 6)
$game_map.need_refresh = true; HL.frames(5)
ok = Story.slide_to_event(/Auril's relic \(relic_overflow\)/)
HL.settle(3000)
puts "#{ok && FT.flag?(:relic_overflow) ? 'ok  ' : 'FAIL'} slid to Auril's relic on the slick sap and smashed it (at #{$game_player.x},#{$game_player.y})"
