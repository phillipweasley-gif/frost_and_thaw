# The rest of W2's scenarios (loaded by try_w2.rb, which sets up the party and
# the helpers): Mountain Climb, Foaming Mugs, Holed Up, the Council, Bryn
# Shander's people and Targos's.
case SCEN
when "targos"
  go(2004, 9, 11, 8); talk(/Owenn/); talk(/rats|Rat/i) if ev(/Rat/)
  go(2007, 6, 12, 8); talk(/Jestin/); check(flag(:met_jestin), "Jestin Hunrae at Triglio")
  go(2002, 5, 11, 8); talk(/rumours/)
  check(HL.log.count { |l| l =~ /^\[msg\] FISHER:/ } >= 2, "the Three Flags fisher passes on a rumour")

when "bryn"
  go(2012, 31, 25, 8)
  talk(/Sheriff Southwell/)
  answer([/Rest until sundown/, 1])
  go(2016, 5, 11, 8); talk(/Scramsax/); check(flag(:met_scramsax), "Scramsax offers credit at interest")
  talk(/Ol' Bitey/); talk(/Ol' Bitey/); talk(/Ol' Bitey/)
  check(HL.log.any? { |l| l =~ /Bitey/i }, "Ol' Bitey in his barrel")
  go(2019, 9, 11, 8); answer([/What do you say/, 1]); talk(/Copper/); check(flag(:copper_asked), "Copper and the Black Cabin")
  go(2014, 6, 12, 8); talk(/Elza/); talk(/Garn/); check(flag(:met_elza), "Elza and Garn at Blackiron Blades")
  FrostThaw.state[:scramsax_tab] = 300; FrostThaw.set_flag(:badge_bryn)   # (the bill comes due after the seal: notes 02 E24)
  go(2016, 5, 11, 8); answer([/Pay Scramsax/, 1]); talk(/Scramsax/)
  check(FrostThaw.state[:scramsax_tab].to_i == 0, "Scramsax collects his tab, one way or another")

when "council"
  FrostThaw.set_flag(:lottery_stand)
  go(2012, 24, 39, 8); walk(24, 38); check($game_map.map_id == 2134, "the Council Hall's door")
  walk(10, 12); HL.settle(3000)
  check(flag(:council_session) && sw(4040), "the Council of Speakers sits")
  check(HL.log.any? { |l| l =~ /NAERTH:/ }, "Naerth speaks at the table")

when "climb"
  answer([/Follow the dog/, 0], [/Go up Kelvin's Cairn/, 0])
  go(2001, 29, 34, 8); FrostThaw.boy_sled_dog(ev(/^Boy$/)&.id); HL.settle(3000)
  check(flag(:climb_taken) && sw(4044), "Boy leads you to Keegan, who asks you to find Garret")
  go(2125, 1, 20, 6); HL.settle(3000)
  walk(58, 3); walk(59, 3); check($game_map.map_id == 2126, "the open tundra leads to Kelvin's Cairn (#{$game_map.map_id})")
  answer([/Which way\?/, ->(t, c) { $game_map.map_id == 2127 ? FrostThaw::CLIMB_PITCHES[{ 28 => 1, 17 => 2, 9 => 3 }[$game_player.y] || 1][2] : 0 }])
  answer([/What do you say/, BRANCH == "fight" ? 0 : 1])
  talk(/Sled dogs/) if ev(/Sled dogs/)
  talk(/^Garret$/); check(flag(:garret_found), "Garret, face down on the slope, and the crag cats")
  check(BRANCH == "fight" ? flag(:garret_sent_home) : flag(:garret_with_you), "Garret #{BRANCH == 'fight' ? 'sent home' : 'comes along'}")
  walk(20, 0); check($game_map.map_id == 2127, "up to the heights (#{$game_map.map_id})")
  check(sw(4053) || flag(:avalanche_survived) || HL.log.any? { |l| l =~ /avalanche|snow comes down/i }, "the avalanche on the way up")
  walk(24, 5); walk(24, 4)
  check(flag(:climb_pitch_1) && flag(:climb_pitch_2) && flag(:climb_pitch_3), "the three pitches, climbed")
  check($game_map.map_id == 2128, "into the yeti cave (#{$game_map.map_id})")
  answer([/Smash the ice sheet/, 1])
  answer([/What do you do/, BRANCH == "fight" ? 1 : 0])
  talk(/Mother yeti/)
  check(flag(:perilou_saved), "Perilou is saved")
  check(BRANCH == "fight" ? flag(:mother_yeti_beaten) : flag(:yeti_den_peace), "the mother yeti: #{BRANCH == 'fight' ? 'fought' : 'left in peace'}")
  walk(15, 21); HL.settle(3000)
  check(sw(4052), "the father yeti comes home")
  walk(15, 23); check($game_map.map_id == 2127, "out of the cave")
  talk(/^Astrix/); talk(/Blue boots/)
  go(2124, 9, 10, 8); talk(/Keegan/)
  check(flag(:climb_done) && sw(4047), "home: Keegan's reward")

when "mugs"
  answer([/Go and fetch the dwarves' sled/, 0])
  go(2012, 11, 14, 8); talk(/Hruna/); check(flag(:mugs_taken) && sw(4057), "Hruna, Korux and Storn ask for their sled")
  go(2125, 1, 20, 6); HL.settle(3000)
  answer([/What do you do\?/, 0]); walk(27, 28); check(sw(4056), "the blizzard comes down")
  HL.answers.reject! { |re, _| re.source == "What do you do\\?" }
  answer([/Wrap Oobok/, 0]); talk(/^Oobok$/)
  pick = { "fight" => 0, "bears" => 1, "kindness" => 2 }[BRANCH] || 0
  answer([/What do you do\?/, pick], [/What do you say/, 0])
  talk(/^Izobai$/)
  check(flag(:mugs_sled) && sw(4050), "the sled is won back (#{BRANCH})")
  case BRANCH
  when "bears" then check(flag(:goblin_bears_freed), "the polar bears go free")
  when "kindness" then check(flag(:goblins_kind), "the goblins take the warm thing, and the truce")
  end
  go(2012, 11, 14, 8); talk(/Hruna/)
  check(flag(:mugs_done), "the dwarves pay in bloodstones")
  go(2014, 6, 12, 8); talk(/Elza/)
  check(HL.log.any? { |l| l =~ /shop:/ }, "Elza's shop opens (with the dwarves' discount)")

when "holed"
  pick = { "lie" => 1, "bad" => 2 }[BRANCH] || 0
  answer([/What do you do/, pick])
  $game_switches[3918] = true
  go(2035, 6, 21, 4); talk(/^Koran$/)
  check(flag(:met_wolves) && sw(4041), "Koran's Garagai lie, and the wolves wait")
  check(BRANCH != "lie" || flag(:caught_koran), "catching the limp on the wrong leg")
  check(BRANCH != "bad" || flag(:refused_wolves) || flag(:followed_koran), "Kanan plays the bad wolf")
  HL.answers.reject! { |re, _| re.source == "What do you do" }
  answer([/What do you do/, 0], [/How do you go/, 0], [/What do you say/, 0], [/Honour Garagai/, 0],
         [/How do you get them out/, ->(t, c) { c.index { |x| x.to_s =~ /Pick the lock/ } || 0 }], [/Climb up and sit/, 0], [/Call a blizzard/, 0])
  go(2039, 30, 15, 4); HL.settle(3000)
  talk(/Starving wolf/) if ev(/Starving wolf/)
  walk(19, 15); HL.settle(3000); check(flag(:lodge_wolves_seen), "at the lodge the wolves nudge you to the middle door and wait")
  walk(18, 15); HL.settle(3000); check($game_map.map_id == 2040, "inside the lodge (#{$game_map.map_id})")
  walk(32, 14); HL.settle(3000); check(flag(:corridor_crossed), "the icicle corridor")
  talk(/Ice throne/); check(flag(:throne_blizzard), "the ice throne's blizzard")
  check(flag(:norsu_met), "Norsu, the master behind it all")
  talk(/Whale oil/); check(flag(:whale_oil), "whale oil")
  talk(/Cage gate/); check(flag(:kids_freed), "Silja and Finn out of the cage")
  FrostThaw.wolves_ambush(nil); check(flag(:wolves_beaten), "the wolves' ambush on the way home")
  go(2035, 40, 2, 2); HL.settle(4000)          # back into Dougan's Hole: the homecoming
  go(2037, 9, 10, 8); talk(/Hilda/)
  check(flag(:kids_home), "the Dejarrs home; Hilda's boots")
  check(($PokemonBag.pbHasItem?(:FT_WINTERBOOTS) rescue false), "the boots of the winterlands")
end
