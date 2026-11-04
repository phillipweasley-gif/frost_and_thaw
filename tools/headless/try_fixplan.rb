# Fix plan step 2 (what breaks play), checked in the game itself:
#   - Ch9: "No" at the Shrine's take-off can be taken back (the soft-lock)
#   - Ch13: a lost test doesn't black out, is said out loud, and can be retried
#   - Ch8: the Level 3 rest moves where a loss sends you
#   - the remapped fusion codes are real species
require_relative "story_run"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
FT = FrostThaw unless defined?(FT)
ok = ->(c, m) { puts "#{c ? 'ok  ' : 'FAIL'} #{m}"; $fails = ($fails || 0) + (c ? 0 : 1) }
HL.new_game; HL.frames(200)
team = ->(lv) { $Trainer.party.clear; %i[MAMOSWINE CHARIZARD GARCHOMP].each { |s| $Trainer.party << Pokemon.new(s, lv) } }

# --- Ch9: the Shrine ----------------------------------------------------------
team.(60)
FT.set_flag(:summer_ended)
HL.answers.unshift([/Take off after the black dragon/, 1])     # "No"
FT.dragon_shrine(:frostina)
ok.(FT.flag?(:mounted_up) && !FT.flag?(:air_seams), "saying No leaves you bound but on the ground")
n = HL.log.size
HL.answers.shift; HL.answers.unshift([/Take off after the black dragon/, 0])  # "Yes"
FT.dragon_shrine(:frostina)
said = HL.log[n..].join("\n")
ok.(said =~ /Take off after the black dragon/ && FT.flag?(:air_seams), "talking to her again offers the take-off, and Yes flies")
HL.answers.shift

# --- Ch13: a test lost, then retried ------------------------------------------
HL.warp(*FT::HALL_ARRIVAL)
team.(5)
n = HL.log.size
FT.test_door(:cruelty)
said = HL.log[n..].join("\n")
ok.(FT.flag?(:test_cruelty_faced) && !FT.flag?(:test_cruelty_broken), "a weak team loses the test (faced, not broken)")
ok.(said !~ /scurry back|Pokémon Center/i, "no whiteout text")
ok.(said =~ /The food counted/ && said =~ /face the test again/i, "Meat Meat answers the loss, and the game says you can retry")
ok.($game_map.map_id == FT::HALL_ARRIVAL[0], "you're back in the Hall (map #{$game_map.map_id})")
ok.($Trainer.party.all? { |p| p.hp == p.totalhp }, "your team is healed after the loss")
team.(70)
HL.answers.unshift([/Face the test again/, 0])
n = HL.log.size
FT.test_door(:cruelty)
said = HL.log[n..].join("\n")
ok.(said =~ /still whole/ && FT.flag?(:test_cruelty_broken), "the door offers a retry, and a win breaks the tablet")
n = HL.log.size
FT.test_door(:cruelty)
ok.(HL.log[n..].join("\n") =~ /The vision has gone/, "a broken tablet's door stays shut")

# --- Ch8: the Level 3 camp ----------------------------------------------------
FT.forge_camp
ok.($PokemonGlobal.pokecenterMapId == 2150, "a loss after the Level 3 camp sends you to the Root-Throne (#{$PokemonGlobal.pokecenterMapId})")
ev = $MapFactory.getMap(2150).events.values.find { |e| e.name == "Woken digger" } rescue nil
ok.(ev, "the digger stands on the Root-Throne map")

# --- the remapped fusion codes -------------------------------------------------
codes = %i[B427H215 B428H124 B200H427 B225H427 B59H272 B234H274 B274H234 B217H221 B217H274 B274H87 B274H221
           B53H262 B262H53 B128H262 B262H55 B87H262 B215H429 B225H429 B429H87 B144H429 B429H92 B429H215
           B429H122 B92H429 B124H429 B131H428 B449H124 B449H227 B227H449 B92H449 B275H429 B87H429]
bad = codes.reject { |c| (GameData::Species.get(c) rescue nil) }
ok.(bad.empty?, "every remapped fusion is a real species (#{bad.inspect})")
puts "problems:"; puts HL.problems.uniq
puts($fails.to_i.zero? ? "ALL OK" : "#{$fails} FAILED")
