# The Ten-Towns favours: picks pay the item picked; all five towns send the Council's thanks.
require_relative "story_run"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1],
              [/What should the dwarves forge/, 2], [/Which stone first/, 4], [/And the second/, 0]]
FT = FrostThaw unless defined?(FT)
ok = ->(c, m) { puts "#{c ? 'ok  ' : 'FAIL'} #{m}"; $fails = ($fails || 0) + (c ? 0 : 1) }
has = ->(i) { $PokemonBag.pbHasItem?(i) }
HL.new_game; HL.frames(200)
FT.favour_forge
ok.(has.(:CHOICESCARF) && !has.(:CHOICEBAND), "the forge makes the piece you pick (scarf)")
FT.favour_seam
ok.(has.(:ICESTONE) && has.(:FIRESTONE), "the seam gives the two stones you pick (ice, then fire)")
%i[climb_done mugs_done mine_done white_moose_done].each { |f| FT.set_flag(f) }
n = HL.log.size
FT.town_quest_finished
ok.(HL.log[n..].join("\n") =~ /4 of 5.*Good Mead/m && !has.(:INFINITESPLICERS), "four towns: the count, and which town is left")
FT.set_flag(:mead_returned)
FT.town_quest_finished
ok.(has.(:INFINITESPLICERS) && FT.flag?(:ten_towns_thanked), "all five: the Council sends Infinite Splicers")
n = HL.log.size
FT.town_quest_finished
ok.(HL.log[n..].join("\n") !~ /Council runner/, "the thanks comes once")
puts($fails.to_i.zero? ? "ALL OK" : "#{$fails} FAILED")
