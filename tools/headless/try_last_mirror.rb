# The last mirror (owner's calls, 2026-11-05): the Order's dagger breaks it;
# Wyn sees the Sap Gate; Auril marks the outsider only after the choice.
require_relative "story_run"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
FT = FrostThaw unless defined?(FT)
ok = ->(c, m) { puts "#{c ? 'ok  ' : 'FAIL'} #{m}"; $fails = ($fails || 0) + (c ? 0 : 1) }
HL.new_game; HL.frames(200)
run = lambda do |mode, herald, dagger, pick|
  FT.state[:mode] = mode; FT.state[:herald] = herald
  FT.state[:flags].delete(:tried_to_leave); FT.state[:flags].delete(:broke_last_mirror)
  dagger ? FT.set_flag(:order_dagger) : FT.state[:flags].delete(:order_dagger)
  HL.answers = [[/The last mirror/, pick]]
  n = HL.log.size
  mode == :herald && herald != :wyn ? FT.scene_third_way_mirror_only : FT.last_mirror_choice
  FT.chasm_keepsakes
  HL.log[n..].join("\n")
end
FT.define_singleton_method(:scene_third_way_mirror_only) do
  say(["Thredra's Reflection cracks. The last mirror.",
       flag?(:order_dagger) ? "You break it with the Order's silver dagger. Fey glass. It screams." : "You're the one who breaks it."])
end
t = run.(:journey, nil, true, 1)
ok.(t =~ /draw the Order's silver dagger/ && t =~ /like ice on a pond/, "Journey, break, with dagger: the dagger breaks it")
ok.(t =~ /chose this side of the glass/ && t =~ /Now she can/, "and Auril marks you because you chose")
t = run.(:journey, nil, false, 1)
ok.(t =~ /You break it\./ && t !~ /dagger/, "Journey, break, no dagger: bare break")
t = run.(:journey, nil, false, 0)
ok.(t =~ /reached for the way home/, "Journey, step through: the mark follows the reach")
t = run.(:herald, :wyn, true, 0)
ok.(t =~ /Sap Gate/ && t =~ /Sableye's reflection/ && t =~ /gate shard/, "Wyn sees the Sap Gate and Sableye")
t = run.(:herald, :alberica, false, 1)
ok.(t =~ /has seen what you did/ && t !~ /Until now/, "Herald: the old mark line")
puts($fails.to_i.zero? ? "ALL OK" : "#{$fails} FAILED")
