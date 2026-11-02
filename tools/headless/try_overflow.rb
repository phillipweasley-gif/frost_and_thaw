# The Overflow Channel's slick sap, in the real engine: does the sap slide
# like ice, can the slide be solved to both ledges and back, and does the
# Blessing of Still Sky stop the sliding?
require_relative "driver"
HL.start_up
HL.quiet = !ENV["V"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
HL.new_game
HL.frames(100)
%i[reversal rootspire_arrived met_hellen wardens_emeritus rite_stopped ch7_started heartroot_entered seal_open
   overflow_entered met_mirror_child mirror_twin_known].each { |f| FrostThaw.set_flag(f) }
$PokemonGlobal.repel = 999999 rescue nil
HL.warp(2067, 3, 3) rescue (puts "warp failed #{$!.message}")
HL.frames(30); HL.settle(2000)
puts "at #{$game_map.map_id} #{HL.pos}"
ice = ->(x, y) { $game_map.terrain_tag(x, y).ice rescue false }
puts "slick at (10,10): #{ice.(10, 10)}  plain floor at (3,3): #{ice.(3, 3)}"

D = HL::DIRS
# predicted result of one step from (x,y) in direction d, as the engine slides
def predict(x, y, d)
  dx, dy = HL::DIRS[d]
  return nil unless $game_player.passable?(x, y, d)
  nx, ny = x + dx, y + dy
  ice = ->(a, b) { $game_map.terrain_tag(a, b).ice rescue false }
  while ice.(nx, ny) && $game_player.passable?(nx, ny, d)
    nx += dx; ny += dy
  end
  [nx, ny]
end

def plan(from, goal)
  prev = { from => nil }; q = [from]
  until q.empty?
    c = q.shift
    return path_back(prev, c) if goal.(c)
    HL::DIRS.each_key do |d|
      n = predict(*c, d) or next
      next if prev.key?(n)
      prev[n] = [c, d]; q << n
    end
  end
  nil
end

def path_back(prev, c)
  out = []
  while (p = prev[c]); out.unshift(p[1]); c = p[0]; end
  out
end

def run_plan(dirs)
  dirs.each do |d|
    want = predict($game_player.x, $game_player.y, d)
    HL.step(d); HL.frames(10); HL.settle(2000)
    got = [$game_player.x, $game_player.y]
    if got != want
      puts "  step #{d}: expected #{want.inspect}, ended at #{got.inspect}"
      return false
    end
  end
  true
end

frag = ->(c) { c[0] >= 29 && c[1].between?(16, 19) }
mirr = ->(c) { c[1] >= 23 }
home = ->(c) { c == [3, 3] || c == [3, 4] || c == [4, 3] }
ok = true
[["to the fragment's ledge", frag], ["back to the landing", home], ["to the mirror's ledge", mirr], ["back to the landing", home]].each do |label, goal|
  pl = plan([$game_player.x, $game_player.y], goal)
  if pl.nil? then puts "NO PLAN #{label}"; ok = false; next end
  r = run_plan(pl)
  puts "#{r ? 'ok  ' : 'FAIL'} #{label} in #{pl.size} moves -> #{HL.pos}"
  ok &&= r
  if label =~ /fragment/ && r
    ev = $game_map.events.values.find { |e| e.name == "Congealed sap" }
    HL.talk_to(ev); HL.settle(2000)
    puts "#{FrostThaw.flag?(:vault_map_1) ? 'ok  ' : 'FAIL'} the Vault Map fragment"
  end
  if label =~ /mirror/ && r
    ev = $game_map.events.values.find { |e| e.name == "Twin mirror" }
    3.times { |i| $Trainer.party << Pokemon.new(%i[FORGEL B331H154 B9H221][i], 44) } if $Trainer.party.size < 3; $Trainer.party.each { |pk| pk.level = 45; pk.calc_stats; pk.heal }
    HL.talk_to(ev); HL.settle(3000)
    puts "#{FrostThaw.flag?(:twin_broken) ? 'ok  ' : 'FAIL'} the twin mirror broken"
  end
end
# the Blessing of Still Sky: no sliding
HL.warp(2067, 3, 3); HL.frames(20); HL.settle(2000)
FrostThaw.set_flag(:blessing_still_sky)
HL.walk_to(7, 4); HL.step(6); HL.settle(2000)
puts "#{$game_player.x == 8 ? 'ok  ' : 'FAIL'} with Still Sky you stop one tile onto the slick (at #{HL.pos})"
puts HL.problems.uniq.inspect
puts File.read("FrostThaw.log").lines.last(5).join rescue nil
