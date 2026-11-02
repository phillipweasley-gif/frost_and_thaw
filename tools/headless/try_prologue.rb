# The New Journey prologue, start to fall: each starter on Wynsnow's table
# (PICK=0/1/2), and the Still Keeper's loop replay (LOOPED=1), where you
# already have your partner and must not get a second one.
require_relative "story_run"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
FT = FrostThaw unless defined?(FT)
ok = ->(c, m) { puts "#{c ? 'ok  ' : 'FAIL'} #{m}"; $fails = ($fails || 0) + (c ? 0 : 1) }
pick = (ENV["PICK"] || 0).to_i
ENV["HL_STARTER"] = pick.to_s
HL.new_game; HL.frames(200)
if ENV["LOOPED"]
  FT.state[:counters] ||= {}
  FT.state[:counters][:loop_count] = 1
  FT.state[:starter] = FT::STARTERS[pick][:species]
  $Trainer.party << FT.starter_pokemon(FT.state[:starter])
end
if ENV["GATE"]
  # Leaving Wynsnow's room without a Pokémon: he stops you (a person, not a wall).
  Story.send(:travel, 2091); Story.send(:talk, /Lift-keeper/); HL.frames(30); HL.settle(8000)
  Story.send(:step_on, /Lecture room door/); HL.settle(8000)
  ok.(FT.flag?(:met_wynsnow), "met Wynsnow at the door")
  n = HL.log.size
  HL.walk_to(20, 8); HL.settle(4000)
  said = HL.log[n..].join("\n")
  ok.(said.include?("Not yet!") && $game_player.y < 8, "Wynsnow stops you at the door (you're at #{HL.pos})")
  ok.(FT.state[:goal].to_s =~ /Poké Balls/, "the goal says what to do (#{FT.state[:goal]})")
  puts($fails.to_i.zero? ? "ALL OK" : "#{$fails} FAILED")
  exit
end
Story.prologue
mine = FT.state[:starter]
theirs = FT::TAMSIN_COUNTER[mine]
tr = GameData::Trainer::DATA[[:FT_TAMSIN_I, "Tamsin", 1]]
ok.(FT.flag?(:met_wynsnow) && FT.flag?(:got_starter) && FT.flag?(:pro_battle_done), "Wynsnow, the table and the battle")
ok.(FT.flag?(:pro_led) && FT.flag?(:saw_sixth_figure) && FT.flag?(:fell_through), "Tamsin leads you home, the mural, the fall")
ok.(mine == FT::STARTERS[pick][:species], "your partner is the one you picked (#{mine})")
ok.($Trainer.party.size == 1, "exactly one Pokémon in your party (#{$Trainer.party.map(&:species).inspect})")
ok.(tr && tr.pokemon[0][:species] == theirs, "Tamsin took the one that beats yours (#{tr && tr.pokemon[0][:species]})")
balls = (0..2).map { |i| $game_self_switches[[FT::PRO_COLLEGE, i, "A"]] }   # (ids looked up below)
ids = Marshal.load(File.binread("Data/FrostThaw/Map2092.rxdata")).events.values.select { |e| e.name =~ /Starter ball/ }.sort_by(&:name).map(&:id)
taken = ids.map { |id| $game_self_switches[[FT::PRO_COLLEGE, id, "A"]] ? true : false }
want = FT::STARTERS.map { |s| [mine, theirs].include?(s[:species]) }
ok.(taken == want, "two balls gone from the table for good, the third still there (#{taken.inspect})")
if ENV["LOOPED"]
  ok.(FT.flag?(:loop_skip_asked_act1), "Targos offers the loop's Act I skip after the fall")
else
  ok.($game_map.map_id == FT::TARGOS_START[0], "out of the air over Targos (map #{$game_map.map_id})")
  ok.(FT.state[:goal].to_s =~ /Three Flags/, "Targos sets the next goal (#{FT.state[:goal]})")
end
puts "problems:"; puts HL.problems.uniq.reject { |p| p =~ /no way from map 2001/ }
puts($fails.to_i.zero? ? "ALL OK" : "#{$fails} FAILED")
