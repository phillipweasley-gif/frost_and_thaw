# Act I scene pass, parts 00-01: the beats the story driver doesn't walk through.
#   PIF_DIR=/home/claude/pifrun_X ruby tools/headless/try_act1_scene.rb            (New Journey)
#   PIF_DIR=/home/claude/pifrun_X HERALD=Alberica ruby tools/headless/try_act1_scene.rb
$stdout.sync = true
require_relative "driver"

HL.start_up
HL.quiet = !ENV["HL_VERBOSE"]
$backdrops = []
FrostThaw.singleton_class.prepend(Module.new do
  def backdrop(name)
    $backdrops << name
    super
  end
end)
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, ENV["HERALD"] ? 1 : 0], [/Choose a difficulty/, 1]]
HL.answers << [/Which Herald/, ->(t, c) { c.index { |x| x.to_s =~ /#{ENV['HERALD']}/i } || 0 }] if ENV["HERALD"]
HL.new_game
HL.frames(200)

$checks = []
def check(ok, label)
  $checks << [ok, label]
  puts "#{ok ? 'ok  ' : 'FAIL'} #{label}"
end
def ev(re) = $game_map.events.values.find { |e| e.name =~ re }
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
def said?(re, from = 0) = HL.log[from..].any? { |l| l.start_with?("[msg]") && l =~ re }
def set(*fs) = fs.each { |f| FrostThaw.set_flag(f) }
def unset(*fs) = fs.each { |f| FrostThaw.set_flag(f, false) }

$Trainer.party.each { |pk| pk.level = 40; HL.sensible_moves(pk, nil); pk.calc_stats; pk.heal }
$PokemonGlobal.repel = 999_999 rescue nil

begin
  if ENV["HERALD"]
    check($backdrops.include?(:ship), "the ship opening shows the ship's deck (#{$backdrops.inspect})")
    check((pbResolveBitmap("Graphics/Pictures/FrostThaw/scene_ship") rescue nil), "scene_ship.png loads")
  else
    check(!$backdrops.include?(:ship), "New Journey never shows the ship (#{$backdrops.inspect})")
  end

  # Boy: the husky sprite, and he spots you and runs up (notes/14 E1, E2)
  set(:fell_through, :intro_done, :arrived_targos)
  answer([/Follow the dog/, 1])
  go(2001, 11, 30, 6)
  boy = ev(/\ABoy\z/)
  check(boy && boy.character_name == "Followers/BOY", "Boy is the sled dog on map 2001 (#{boy && boy.character_name})")
  n = HL.log.size
  walk(13, 30)
  check(flag(:boy_spotted) && said?(/sled dog/, n), "Boy spots you from three tiles off and runs up")
  check(ev(/Sign velryn_sign/), "the Velryn house has its sign")

  # The tavern: the door calls you back until you've met them all
  unset(:met_party); $game_switches[3961] = false
  go(2002, 5, 11, 8); HL.settle(4000)
  check(flag(:tavern_woman), "1.02 plays on the way in")
  n = HL.log.size
  HL.step(2); HL.settle(3000)
  check($game_map.map_id == 2002 && said?(/Out in that\?/, n), "Shade calls you back from the door before the five have met")
  %w[Alberica Reptin Alerion Shade].each { |nm| talk(/\A#{nm}\z/) if !flag(:met_party) && (e = ev(/\A#{nm}\z/)) && !e.character_name.to_s.empty? }
  check(flag(:met_party), "sitting at each table ends in the party")
  check(FrostThaw.offstage_speakers.none? { |m, _t, _w| m == 2002 }, "nobody speaks off stage in the tavern (#{FrostThaw.offstage_speakers.inspect})")

  # The widow's Spheal comes to you, and she's a she
  go(2008, 9, 11, 8)
  check(ev(/\ASpheal\z/) && !ev(/\ASpheal\z/).character_name.to_s.empty?, "the Spheal waits by the cottage door")
  talk(/\AWidow\z/)
  sp = $Trainer.party.find { |pk| pk.species == :SPHEAL }
  check(sp && sp.female?, "the widow's Spheal joins you, female")
  check(ev(/\ASpheal\z/).nil? || ev(/\ASpheal\z/).character_name.to_s.empty? || ev(/\ASpheal\z/).instance_variable_get(:@erased), "and she's gone from the door")

  # The hall before Naerth's terms: the guide holds the first gap
  unset(:naerth_terms); $game_switches[3963] = false
  go(2005, 10, 19, 8)
  $game_map.events.values.select { |e| e.name =~ /\ATrainer/ }.each { |e| $game_self_switches[[2005, e.id, "A"]] = true }
  $game_map.need_refresh = true; HL.settle(500)
  g = $game_map.events.values.find { |e| e.name == "Hall guide" && e.x == 18 && e.y == 16 }
  check(g && !g.character_name.to_s.empty?, "the guide stands in the first gap before the terms")
  n = HL.log.size
  talk(/Hall guide/)
  check(said?(/GUIDE: The Speaker's not in/, n), "and says the Speaker's at the Luskan Arms")

  # Marta's sister, once Shimmer has said Sephek's name to Naerth
  set(:naerth_terms); $game_switches[3963] = true
  go(2009, 9, 11, 8)
  n = HL.log.size
  talk(/lantern_mother/)
  check(said?(/MARTA:/, n), "Marta is named")
  check(FrostThaw.herald? || said?(/SHIMMER: \(very quietly\) Sephek/, n), "Shimmer knows the man in shirtsleeves")

  # The rest after the seal: night, and the five round the fire
  set(:badge_targos); unset(:heard_of_glimmer)
  FrostThaw.state[:goal] = FrostThaw::TARGOS_REST_GOAL
  answer([/Rest at Three Flags/, 0])
  go(2002, 5, 7, 8); walk(5, 6)
  $game_player.turn_left
  before = FrostThaw.offstage_speakers.size
  talk(/Ma Yarbroul/)
  check(flag(:heard_of_glimmer), "the rest plays: the carved cat")
  check(FrostThaw.offstage_speakers.size == before, "everyone at the fire is on screen (#{FrostThaw.offstage_speakers.last(3).inspect})")
  check(FrostThaw.state[:goal] == FrostThaw::TARGOS_ROAD_GOAL, "and the goal moves on to the road")
  check(($game_screen.tone.red rescue 0).zero?, "the night tone clears after the rest")
rescue StandardError => e
  check(false, "#{e.class}: #{e.message} #{e.backtrace.first(3).join(' | ')}")
end

bad = $checks.reject(&:first)
puts "\n#{$checks.size - bad.size}/#{$checks.size} checks passed"
File.write(ENV["HL_OUT"], HL.log.join("\n")) if ENV["HL_OUT"]
