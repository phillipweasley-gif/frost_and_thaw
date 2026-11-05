# The White Vault is postgame: three sigils only hum before the credits, and
# wake after them, with a side line pointing the way.
require_relative "story_run"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
FT = FrostThaw unless defined?(FT)
ok = ->(c, m) { puts "#{c ? 'ok  ' : 'FAIL'} #{m}"; $fails = ($fails || 0) + (c ? 0 : 1) }
HL.new_game; HL.frames(200)
%i[sigil_echo sigil_eirwen sigil_sephek].each { |f| FT.set_flag(f) }
n = HL.log.size
FT.try_merge_sigils
ok.(!FT.flag?(:sigils_merged) && HL.log[n..].join("\n") =~ /won't wake while Auril/, "before the credits, three sigils only hum")
ok.(FT.side_goals.none? { |t| t =~ /Vault/ }, "no Vault line in the Goal during the story")
FT.set_flag(:game_complete)
FT.postgame_vault_hook
ok.(FT.flag?(:sigils_merged), "after the credits they merge")
ok.(FT.side_goals.any? { |t| t =~ /White Vault/ }, "and the Goal has a postgame line: #{FT.side_goals.inspect}")
FT.set_flag(:avarice_body_broken)
ok.(FT.side_goals.none? { |t| t =~ /Vault/ }, "the line goes when the Vault is done")
puts($fails.to_i.zero? ? "ALL OK" : "#{$fails} FAILED")
