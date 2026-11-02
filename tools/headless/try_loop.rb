# Ending C, the loop and the act skips; then the other two endings' epilogue.
require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0]]
HL.new_game; HL.frames(200)
FT = FrostThaw unless defined?(FT)
ok = ->(c, m) { puts "#{c ? 'ok  ' : 'FAIL'} #{m}" }
act1 = %i[act1_done razzy_named frostina_hatched hag_defeated took_left]
act2 = act1 + %i[ch10_done council_mira council_rheven wardens_sworn verdict_acquitted]
act1.each { |f| FT.set_flag(f) }; FT.loop_snapshot(:act1)
%i[ch10_done council_mira council_rheven wardens_sworn verdict_acquitted].each { |f| FT.set_flag(f) }
FT.state[:companions] = %i[alberica reptin wyn]; FT.loop_snapshot(:act2)
FT.set_flag(:intro_done)
FT.ending_still_keeper rescue (puts "ending C raised: #{$!.message}")
HL.frames(60); HL.settle(2000)
ok.(FT.flag?(:in_loop) && FT.counter(:loop_count) == 1, "Ending C starts loop 1")
ok.(!FT.flag?(:act1_done) && !FT.flag?(:council_mira), "the story's flags are gone")
ok.(FT.flag?(:intro_done), "the intro stays done")
ok.([FT::PROLOGUE_START[0], FT::TARGOS_START[0]].include?($game_map.map_id), "back at the start (map #{$game_map.map_id})")
ok.(FT.state[:loop_snap] && FT.state[:loop_snap][:act1][:flags].include?(:hag_defeated), "your own Act I is remembered")
# skip Act I
r = FT.loop_skip(:act1) rescue (puts "skip raised #{$!.message}"; nil)
HL.frames(60); HL.settle(2000)
ok.(r && act1.all? { |f| FT.flag?(f) }, "skipping Act I replays your own Act I flags")
# (landing at Rootspire plays SC 6.01, which then offers the Act II skip; the driver says yes)
ok.(FT.flag?(:rootspire_arrived) || FT.flag?(:loop_skip_asked_act2), "lands at Rootspire and plays the arrival")
ok.(FT.flag?(:loop_skip_asked_act2) && FT.flag?(:council_mira) && FT.voyage_route == :ship, "skipping Act II replays your Vote (route #{FT.voyage_route})")
ok.((%i[alberica reptin wyn] - FT.state[:companions]).empty?, "with your own companions (#{FT.state[:companions].inspect})")
ok.(FT.flag?(:auril_whisper) && FT.flag?(:frostina_taken), "and Act III begins (map #{$game_map.map_id})")
ok.(!FT.loop_skip(:act1) && !FT.loop_skip(:act2), "each skip is only offered once per loop")
# the other endings
FT.ending_shatter rescue (puts "shatter raised: #{$!.message}")
HL.frames(60); HL.settle(2000)
ok.(FT.flag?(:ending_shatter) && FT.flag?(:game_complete), "Shatter ends the game (map #{$game_map.map_id})")
puts "problems:"; puts HL.problems.uniq
