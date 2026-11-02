# W2's focused checks: each Ten-Towns side quest and each of its branches, in
# the real game, headless. One scenario per run:
#   PIF_DIR=/home/claude/pifrun_W2 SCEN=mine BRANCH=ghost ruby tools/headless/try_w2.rb
# Scenarios (BRANCH in brackets): route, mine [clean|ghost|grell|town], moose
# [outside|barrow|cookies|spare], mead [run|back|decline|letgo|curse], climb [peace|fight],
# mugs [fight|bears|kindness], holed [lie|bad], council, bryn, targos, termalaine.
$stdout.sync = true
require_relative "driver"

SCEN = ENV["SCEN"] || "route"
BRANCH = ENV["BRANCH"] || ""
HL.start_up
HL.quiet = !ENV["HL_VERBOSE"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, ENV["HERALD"] ? 1 : 0], [/Choose a difficulty/, 1]]
HL.answers << [/Which Herald|Who will you be|Which of the Heralds/, ->(t, c) { c.index { |x| x.to_s =~ /#{ENV['HERALD']}/i } || 0 }] if ENV["HERALD"]
HL.new_game
HL.frames(200)

$checks = []
def check(ok, label)
  $checks << [ok, label]
  puts "#{ok ? 'ok  ' : 'FAIL'} #{label}"
end
def ev(re) = $game_map.events.values.find { |e| e.name =~ re }
def visible?(re) = (e = ev(re)) && !e.character_name.to_s.empty?
def talk(re)
  e = ev(re) or (check(false, "no event #{re.inspect} on map #{$game_map.map_id}"); return)
  r = HL.talk_to(e)
  HL.settle(3000)
  check(r == :ok || r == :moved_away, "reached #{e.name} on #{$game_map.map_id} (#{r})")
end
def answer(*rules) = HL.answers.unshift(*rules.reverse)
def go(map, x, y, dir = 2) = HL.warp(map, x, y, dir)
def walk(x, y)
  r = HL.walk_to(x, y); HL.settle(2000); r
end
def flag(f) = FrostThaw.flag?(f)
def sw(n) = $game_switches[n]

# a party that can win its fights, and the whole crew along
$Trainer.party.each { |pk| pk.level = 48; HL.sensible_moves(pk, nil); pk.calc_stats; pk.heal }
while $Trainer.party.size < 3
  pk = Pokemon.new(%i[MACHAMP ARCANINE CLEFABLE][$Trainer.party.size], 48); HL.sensible_moves(pk, nil); pk.calc_stats; $Trainer.party << pk
end
FrostThaw.state[:companions] = %i[alberica reptin alerion shade meat_meat] unless ENV["HERALD"]
FrostThaw.state[:companions] -= [:shade] if ENV["NOSHADE"] && FrostThaw.state[:companions]   # (no sneak, no tracker: the dice decide)
$Trainer.money = 50_000
$PokemonGlobal.repel = 999_999 rescue nil

begin
  case SCEN
  when "route"
    # Bryn Shander's north gate -> Termalaine Path -> Termalaine -> Lonelywood Road -> Lonelywood
    $game_switches[3913] = true
    go(2012, 22, 2, 8)
    walk(22, 0); check($game_map.map_id == 2121, "Bryn Shander's north gate leads to the Termalaine Path (#{$game_map.map_id})")
    walk(14, 0); check($game_map.map_id == 2120, "the Termalaine Path leads to Termalaine (#{$game_map.map_id})")
    check(flag(:termalaine_arrived) || HL.log.any? { |l| l =~ /most picturesque town/ }, "Termalaine's arrival scene plays")
    walk(17, 0); check($game_map.map_id == 2020, "Termalaine's north road is the Lonelywood Road (#{$game_map.map_id})")
    go(2020, 14, 1)
    walk(14, 0); check($game_map.map_id == 2021, "the Lonelywood Road reaches Lonelywood (#{$game_map.map_id})")
    walk(43, 11); check($game_map.map_id == 2129, "Lonelywood's logging road runs into the forest (#{$game_map.map_id})")
    walk(24, 0); check($game_map.map_id == 2026, "the forest path reaches the Glade (#{$game_map.map_id})")
    go(2026, 14, 26, 2); walk(14, 27); check($game_map.map_id == 2129, "the Glade leads back into the forest (#{$game_map.map_id})")
    go(2031, 1, 27, 6); walk(0, 27); check($game_map.map_id == 2132, "Good Mead's west edge leads into the woods (#{$game_map.map_id})")
    walk(39, 20); check($game_map.map_id == 2031, "and back to Good Mead (#{$game_map.map_id})")

  when "termalaine"
    go(2120, 26, 30)
    talk(/Darmo/); check(flag(:heard_of_mine), "Darmo shouts the news of the mine")
    talk(/Shaelen/); talk(/Militia officer/)
    walk(12, 18); walk(12, 17); check($game_map.map_id == 2122, "the Blue Clam's door works")
    talk(/Vernon/); talk(/rumours/)
    go(2120, 33, 21, 8); walk(33, 20); check($game_map.map_id == 2123, "the Eastside's door works")
    answer([/What do you tell her/, 0])
    talk(/Marta/); check(flag(:met_marta), "Marta sings her song"); check(flag(:marta_ring), "Marta gives the ring of warmth when asked")
    check(($PokemonBag.pbHasItem?(:FT_RINGOFWARMTH) rescue false), "the ring is in the bag")

  when "mine"
    answer([/Clear out the gem mine/, 0])
    go(2120, 14, 21, 8); talk(/Oarus/); check(flag(:mine_taken), "Oarus gives the mine job")
    walk(43, 4); walk(43, 3); check($game_map.map_id == 2135, "the mine's door works (#{$game_map.map_id})")
    talk(/Giant rat 1/); check(sw(4061), "the giant rats are beaten")
    answer([/What do you do/, BRANCH == "town" ? 0 : 1], [/Look under the planks/, 0])
    walk(21, 10); walk(22, 10)
    check(sw(4060), "the saboteurs on the walkway are dealt with (#{flag(:saboteurs_spared) ? 'spared' : 'one fell'})")
    talk(/Bench/); check(flag(:mine_dog), "the little stone dog with tourmaline eyes")
    talk(/Tourmaline seam/)
    talk(/Bucket lift/); check($game_map.map_id == 2136, "the bucket lift goes down (#{$game_map.map_id})")
    HL.answers.reject! { |re, _| re.source == "What do you do" }
    answer([/What do you do/, 0])
    talk(/Grek/); check(sw(4062), "Grek and Smol fight, then flee")
    if BRANCH != "grell"
      talk(/^Grell/); check(sw(4063), "the grell is killed")
    end
    walk(25, 5); HL.face(4); walk(24, 5); HL.settle(3000)
    check($game_player.x <= 21, "the bucket shuttle carries you across the shaft (now at x=#{$game_player.x})")
    HL.answers.reject! { |re, _| re.source == "What do you do" }
    trex_pick = { "town" => 0, "ghost" => 1, "clean" => 1, "grell" => 1 }[BRANCH] || 1
    answer([/What do you do\?/, trex_pick], [/What do you do with the satchel/, BRANCH == "ghost" ? 1 : 0],
           [/What about the kobolds/, BRANCH == "town" ? 0 : 1])
    talk(/Trex/); check(sw(4064), "Trex's business is settled")
    talk(/Skull/); check(flag(:psi_crystal), "the psi crystal from the mind flayer's skull")
    talk(/Geode/)
    walk(20, 5); HL.face(6); walk(21, 5); HL.settle(3000)
    check($game_player.x >= 24, "and back across")
    go(2120, 14, 21, 8); talk(/Oarus/)
    check(flag(:mine_done), "Oarus hears the report and the mine is done")
    case BRANCH
    when "grell" then check(flag(:oarus_dead), "with the grell left alive, Oarus never comes back up")
    when "ghost", "town" then check(flag(:oarus_possessed), "with Janth's ghost loose, Oarus comes back... talking about lichen")
    else check(!flag(:oarus_dead) && !flag(:oarus_possessed), "a clean mine: Oarus pays up, himself")
    end
    if flag(:oarus_possessed)
      answer([/Destroy Janth's satchel/, 0]); talk(/Oarus/); check(flag(:janth_rested) && !flag(:oarus_possessed), "Janth can still be laid to rest from Oarus")
    end
    if BRANCH == "town"
      go(2120, 26, 26); check(visible?(/Kobold worker/), "the kobolds are working in Termalaine")
    end

  when "moose"
    %i[met_nimsy rested_lonelywood shimmer_taken].each { |f| FrostThaw.set_flag(f) }
    answer([/What do you say/, BRANCH == "cookies" ? 0 : 1], [/Rest in Nimsy/, 1])
    go(2027, 13, 8, 8); talk(/Nimsy/)
    check(flag(:white_moose_taken), "Speaker Huddle asks about the white moose")
    check(BRANCH == "cookies" || flag(:moose_fee), "pressing her: the fee and Ramshackle")
    go(2129, 2, 17, 6)
    HL.answers.unshift([/Spend an hour searching/, 0])
    searches = 0
    tracks = $game_map.events.values.select { |x| x.name == "Moose tracks" }
    40.times do |i|
      break if sw(4068)
      searches += 1
      HL.talk_to(tracks[i % tracks.size]); HL.settle(3000)
      $Trainer.party.each(&:heal)
    end
    check(sw(4068), "the white moose's tracks are found (#{searches} hour-long searches, #{FrostThaw.state[:track_sets].to_i} sets of tracks)")
    check(FrostThaw.state[:track_sets].to_i <= FrostThaw::WHITE_MOOSE_PITY, "never more than #{FrostThaw::WHITE_MOOSE_PITY} sets of tracks")
    check(searches == 1 || HL.log.any? { |l| l =~ /squinting at snow|hunter's snare|turn out to be wolves|realise you're lost|hunter's cache|catches your eye|sense of being watched|find a moose/ },
          "the searches that don't find the white moose still turn something up")
    talk(/Fox/)
    %w[Pinecone Owl\ feather Twig].each { |n| talk(/^#{n}/) }
    walk(46, 16); walk(47, 16); check($game_map.map_id == 2130, "past the ward to the elven tomb (#{$game_map.map_id})")
    if BRANCH == "outside"
      answer([/Watch the tomb/, 0]); talk(/Lookout/); check(sw(4069), "watching from the trees, the moose comes out and you fight it")
    end
    talk(/Moon dial/); check(flag(:dial_read), "the moon dial's inscriptions are read")
    walk(10, 9); walk(10, 8); check($game_map.map_id == 2131, "the hole in the hill leads to the barrow (#{$game_map.map_id})")
    HL.settle(3000); walk(12, 9)
    check(sw(4069), "the white moose is dead")
    talk(/Bones/); check(($PokemonBag.pbHasItem?(:FT_SKELETALHAND) rescue false), "a hand from the bones")
    talk(/Lever/); check(sw(4071), "the barrow door opens from inside")
    talk(/Mirror/)
    check(FrostThaw.state[:mirror_asked].to_i > 0 || HL.log.any? { |l| l =~ /frame is dark/ }, "the mirror answers (or is dark without the full moon)")
    talk(/statue/i)
    go(2130, 14, 24, 2)
    talk(/Brazier/); check(flag(:brazier_lit), "the brazier burns silver")
    talk(/Sarcophagus/); check(sw(4073), "Sahnar the mummy sits up")
    check($Trainer.party.any? { |p| p.name == "Sahnar" } || ($PokemonStorage.boxes.any? { |b| b.pokemon.any? { |p| p && p.name == "Sahnar" } } rescue false), "Sahnar joins you")
    answer([/Light a symbol/, 1])
    talk(/Moon dial/); check(sw(4072), "a half-moon lit with Sahnar's help (or a moonbeam)")
    go(2131, 25, 10, 8)
    talk(/Half-moon door \(E8\)/); walk(25, 6)
    answer([/Lift the sarcophagus/, 0]); talk(/Sarcophagus \(E8\)/); check(flag(:e8_opened), "the first half-moon tomb: bow, arrowheads, cup")
    if BRANCH == "spare"     # leave Ravisin be: newly awakened beasts keep coming
      go(2027, 13, 8, 8); talk(/Nimsy/)
      check(flag(:white_moose_done) && sw(4074), "with Ravisin alive, the reward comes with a warning: awakened beasts")
      go(2129, 20, 24, 8); check(visible?(/Awakened bear/), "an awakened polar bear harasses the loggers")
      answer([/What do you do/, 0]); talk(/Awakened bear/)
      raise StopIteration
    end
    go(2131, 25, 15, 2)
    talk(/Half-moon door \(E9\)/); walk(25, 19)
    talk(/Ravisin/); check(sw(4070), "Ravisin is beaten")
    talk(/Berry bush/); check(flag(:shrub_talked), "the berry bush talks")
    talk(/Sarcophagus \(E9\)/); check(flag(:vurnis_opened), "Vurnis, and the two potions")
    go(2027, 13, 8, 8); talk(/Nimsy/)
    check(flag(:white_moose_done), "Speaker Huddle's reward")
    check(sw(4075), "Ramshackle is yours")
    go(2021, 15, 32, 8); walk(15, 31); check($game_map.map_id == 2137, "Ramshackle's door opens for you (#{$game_map.map_id})")
    answer([/Clear a corner/, 0]); talk(/The old bar/)

  when "mead"
    answer([/Go after the verbeeg/, 0], [/Buy the fox/, 0])
    go(2031, 19, 20, 8); talk(/townsfolk/)
    check(flag(:mead_taken), "Good Mead asks you to bring the casks back")
    talk(/Fef Moryn/); check(sw(4076), "you buy Fef's fox")
    go(2031, 1, 27, 6); walk(0, 27); check($game_map.map_id == 2132, "into the woods")
    walk(30, 20); check(flag(:saw_carnage), "the five militia in the clearing")
    talk(/Ogre tracks/)
    answer([/Let it go\?/, BRANCH == "letgo" ? 0 : 1])
    walk(16, 14); check(flag(:gm_chwinga_done), "the chwinga and its snowball")
    check(BRANCH != "letgo" || ($PokemonBag.pbHasItem?(:FT_CHWINGACHARM) rescue false), "the fox rides off with the chwinga, and you get a charm")
    walk(10, 11); check(flag(:lair_seen), "the hillside with the three caves")
    walk(23, 5); walk(23, 4); check($game_map.map_id == 2133, "in through the firelit mouth (#{$game_map.map_id})")
    talk(/Bonfire/); check(flag(:artin_bundle), "Artin's axe and boots by the fire")
    talk(/Livestock/)
    answer([/What do you do/, 1])
    talk(/^Friend$/); check(flag(:friend_down), "Friend wakes up shouting ME FRIEND! and goes down")
    answer([/Lower this basket/, 0]); $game_map.events.values.select { |e| e.name == "Basket" }.each { |e| HL.talk_to(e); HL.settle(2000) }
    check(($PokemonBag.pbHasItem?(:FT_MOSSAGATE) rescue false), "one basket held the verbeeg's treasure")
    answer([/Take the two full casks/, 0]); talk(/Mead casks/); check(flag(:mead_casks), "the two full casks")
    HL.answers.reject! { |re, _| re.source == "What do you do" }
    answer([/What do you do/, 1]); talk(/Yogobor/); check(flag(:yogobor_gone), "Yogobor the cave bear")
    answer([/Break through the foot of ice/, 0]); talk(/Frozen pool/); check(flag(:silvanus_drunk), "the Silvanus pool, drunk from")
    HL.answers.reject! { |re, _| re.source == "What do you do" }
    answer([/What do you do/, BRANCH == "hidealive" ? 1 : 0]); talk(/^Duhg$/)
    check(BRANCH == "hidealive" ? !flag(:duhg_down) : flag(:duhg_down), "Duhg, sharpening his knife (#{BRANCH == 'hidealive' ? 'left be' : 'fought'})")
    if BRANCH == "curse"
      answer([/Shift the stone block/, 0], [/Take the pearl and the wand/, 0])
      talk(/Stone block/); check(flag(:chieftain_curse), "the chieftain's curse")
      FrostThaw.set_rest_at(FrostThaw::GOOD_MEAD_REST)
      check(HL.log.any? { |l| l =~ /chieftain's curse/ }, "a cursed rest gives nightmares and no benefit")
      answer([/Put the chieftain's pearl/, 0]); talk(/Stone block/); check(!flag(:chieftain_curse), "putting them back ends the curse")
    end
    HL.answers.reject! { |re, _| re.source == "What do you do" }
    answer([/What do you do/, { "back" => 1, "hide" => 3, "hidealive" => 3 }[BRANCH] || 0])
    go(2133, 28, 30, 2); walk(28, 31); HL.settle(2000); walk(23, 6)
    check(flag(:gahg_met), "Gahg arrives with her basket")
    case BRANCH
    when "back" then check(flag(:gahg_down), "Gahg: stopped")
    when "hide" then check(HL.log.any? { |l| l =~ /press yourselves into a niche/ } && (flag(:gahg_vengeful) || flag(:gahg_down)), "hiding: Gahg finds Duhg dead, and hunts for you (#{flag(:gahg_down) ? 'found you' : 'missed you'})")
    when "hidealive" then check(HL.log.any? { |l| l =~ /Somebody TOOK it/ } && (flag(:verbeegs_both_alive) || flag(:duhg_down)), "hiding: the two of them come looking for their honey (#{flag(:duhg_down) ? 'found you' : 'missed you'})")
    else check(flag(:gahg_vengeful), "Gahg: left grieving and vengeful")
    end
    go(2132, 38, 20, 6); walk(39, 20); walk(2, 27); check(flag(:mead_returned), "home with the mead")
    pick = { "run" => 0, "back" => 1, "decline" => 2 }[BRANCH] || 0
    HL.answers.reject! { |re, _| re.source == "What do you do" }
    answer([/What do you say/, pick], [/What do you do/, BRANCH == "letgo" ? 1 : 0])
    go(2033, 9, 10, 8); talk(/Olivessa/)
    check(flag(:election_asked), "Olivessa asks")
    if BRANCH != "decline"
      check(sw(4077) && sw(4078), "Shandar storms off to Targos")
      go(2031, 15, 11, 8); walk(15, 10); HL.settle(3000)
      check(sw(4079), "the thugs storm the mead hall, and the town votes")
      if BRANCH == "letgo" then check(flag(:shandar_speaker), "let the thug go: Shandar wins, and Naerth has his speaker")
      else
        check(flag(:shandar_exposed), "the thug talks: Naerth hired them")
        check(pick == 0 ? flag(:pc_speaker) : flag(:olivessa_speaker), "the new speaker")
      end
    end

  when "searches"
    # every outcome of a failed search for moose tracks plays without error
    go(2129, 20, 17)
    seen = {}
    60.times do
      before = HL.log.size
      FrostThaw.failed_track_search
      $Trainer.party.each(&:heal)
      HL.log[before..].each do |l|
        { snow: /squinting at snow/, snare: /hunter's snare/, wolves: /turn out to be wolves/, lost: /realise you're lost/,
          cache: /hunter's cache/, find: /catches your eye|sense of being watched/ }.each { |k, re| seen[k] = true if l =~ re }
      end
    end
    check(seen.size == 6, "all six things a failed search can turn up happen (#{seen.keys.join(', ')})")
    check((($PokemonBag.pbHasItem?(:PECHABERRY) && $PokemonBag.pbHasItem?(:SUPERPOTION)) rescue false), "the snare's berry and the cache's potion")

  when "charm"
    # the Charm of Animal Conjuring: three uses in battle, then it fades
    FrostThaw.give_key(:FT_CHWINGACHARM) rescue $PokemonBag.pbStoreItem(:FT_CHWINGACHARM)
    FrostThaw.state[:chwinga_charges] = FrostThaw::CHWINGA_CHARGES
    class PokeBattle_AI
      alias w2_choose pbDefaultChooseEnemyCommand unless method_defined?(:w2_choose)
      def pbDefaultChooseEnemyCommand(idx)
        if @battle.pbOwnedByPlayer?(idx) && !$w2_used_this_battle && FrostThaw.chwinga_charm_usable?
          $w2_used_this_battle = true
          $w2_foe_hp_before = @battle.battlers[1].hp
          return if @battle.pbRegisterItem(idx, :FT_CHWINGACHARM, -1)
        end
        w2_choose(idx)
      end
    end
    3.times do |i|
      $w2_used_this_battle = false
      HL.battle_log = []
      pbWildBattle(:SNORLAX, 40) rescue check(false, "battle #{i + 1}: #{$!.message}")
      check(HL.battle_log.any? { |m| m =~ /struck by the conjured beasts/ }, "use #{i + 1}: the conjured beasts strike the foe")
      check(FrostThaw.state[:chwinga_charges] == 2 - i, "use #{i + 1}: #{2 - i} use(s) left")
      $Trainer.party.each(&:heal)
    end
    check(!($PokemonBag.pbHasItem?(:FT_CHWINGACHARM) rescue true), "after three uses the charm fades from the bag")
    check(!FrostThaw.chwinga_charm_usable?, "and can't be used again")

  when "climb", "mugs", "holed", "council", "bryn", "targos"
    load File.join(__dir__, "try_w2_more.rb")
  end
rescue StopIteration
rescue Exception => e
  check(false, "ERROR #{e.class}: #{e.message} @ #{e.backtrace.first(3).join(' <- ')}")
end
puts HL.problems.uniq.map { |p| "problem: #{p}" }
fails = $checks.count { |ok, _| !ok }
puts "#{SCEN}/#{BRANCH}: #{$checks.size - fails}/#{$checks.size} checks"
File.write("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/w2_#{SCEN}_#{BRANCH}.log", HL.log.join("\n")) rescue nil
