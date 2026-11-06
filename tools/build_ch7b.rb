# Builds the Heartroot's side ways (Act II, Chapter 7 continued): the Guild
# dig (Hew Talmire's lost diggers, the Halo's saboteurs, the praying
# construct, a ladder up to the market) and the Overflow Channel (a slide of
# slick sap, the Vault Map fragment, the twin of the child's mirror).
require_relative "ft_common"
require_relative "cavekit"

ID = { guild_dig: 2066, overflow: 2067 }
NAMES = { guild_dig: "Heartroot: the Guild Dig", overflow: "Heartroot: the Overflow Channel" }
MUSIC = { guild_dig: "tintower", overflow: "Seafoam Islands Music" }
ROOT_GATE, SAP_WELLS = 2057, 2058
SW_GUILD_LADDER = 3948

def save(b, key) = save_map(b, ID[key], MUSIC[key])

def floor_rects(rects)
  fl = {}
  rects.each { |x, y, w, h| Builder.rect_cells(x, y, w, h).each { |c| fl[c] = true } }
  fl
end

# ---------------------------------------------------------------------------
# 2066: the Guild dig. In from the Root Gate's guard post on the east; the
# Guild's tunnels run west, timbered, to the ladder shaft up to the market.
gd = cave_map(38, 24)
cave_paint(gd, floor_rects([
  [30, 10, 7, 6],                     # where the dig broke into the Heartroot
  [18, 11, 13, 3],                    # the main drift
  [20, 3, 4, 9], [14, 3, 10, 4],      # north: the first sap cache
  [18, 14, 4, 7], [10, 18, 12, 3],    # south: the second sap cache
  [4, 9, 15, 5],                      # west: the construct's root, the ladder shaft
  [4, 4, 4, 6]
]))
[[31, 15], [36, 10], [22, 13], [19, 4], [11, 20], [5, 12], [17, 9]].each { |x, y| gd.set(x, y, 2, 792) }
# the dig's break into the Heartroot: braided shut from this side until the Root Gate's seal is open
[12, 13].each do |y|
  gd.event(36, y, "Into the Heartroot", [
    { trigger: 1, script: "FT.talk(:dig_roots_shut, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])" },
    { switch: 3938, trigger: 1, through: true, commands: [gd.send(:command, 201, [0, ROOT_GATE, 3, y + 20, 6, 0])] }
  ])
end
gd.cutscene(33, 12, :guild_dig_enter)
gd.event(25, 12, "Digger Gant", [{ graphic: "BW (75)", direction: 4, script: "FT.digger(:digger_gant, @event_id)" }])
gd.event(12, 11, "Digger Hobb", [{ graphic: "BW (75)", direction: 6, script: "FT.digger(:digger_hobb, @event_id)" }])
gd.event(15, 3, "Sap cache 1", [{ graphic: "", tile_id: 809, script: "FT.sap_cache(1, @event_id)" }])
gd.event(10, 20, "Sap cache 2", [{ graphic: "", tile_id: 809, script: "FT.sap_cache(2, @event_id)" }])
gd.sign(21, 3, :guild_amber)
gd.event(9, 9, "Prototype 3", [{ graphic: "FT_prototype_3", direction: 8, step_anime: true, script: "FT.father_construct(@event_id)" }])
# SC 7B.02: Hew comes down his ladder with you and waits in the Annex; two of his workers stand guard
gd.event(7, 6, "Hew Talmire", [{ graphic: "", through: true },
                                         { switch: 3972, graphic: "FT_master_hew_talmire", direction: 2, script: "FT.leader_hew(@event_id)" }])
gd.trainer(10, 10, nil, :guild_worker_pell, :FT_GUILD, dir: 4, sight: 2)
gd.trainer(15, 12, nil, :guild_worker_rusk, :FT_GUILD, dir: 4, sight: 2)
# SC 7B.08: the door of iron and glass at the bottom of Hew's last ladder
[15, 16].each do |x|
  gd.event(x, 21, "Door of iron and glass", [
    { tile_id: 582, trigger: 1, script: "FT.labyrinth_forge_door(@event_id)" },
    { switch: 3981, tile_id: 582, trigger: 1, script: "FT.labyrinth_forge_door(@event_id)", commands: [gd.send(:command, 201, [0, 2072, 4, 14, 6, 1])] }
  ])
end
# the Root-Lift Node's cage comes up here once it's working (build_ch7_deep.rb, 2144)
gd.event(19, 19, "Root-lift", [{ graphic: "", through: true },
                               { switch: 4083, graphic: "Followers/KLINKLANG", direction: 2, script: "FT.root_lift_up(@event_id)" }])
gd.event(5, 4, "Ladder shaft", [{ graphic: "", tile_id: 582, script: "FT.guild_ladder(@event_id)" }])
save(gd, :guild_dig)

# ---------------------------------------------------------------------------
# 2067: the Overflow Channel. A landing at the top left (down from the Sap
# Wells), then a long slope of slick sap: once you're moving, you're moving.
# The map fragment is caught in congealed sap on the far wall (east), the
# twin mirror on a ledge (south-west). Stones in the flow stop a slide.
OW_, OH = 34, 28
ov = cave_map(OW_, OH)
LAND = floor_rects([[2, 2, 6, 5]])
SLICK = floor_rects([[8, 3, 21, 20]])
FRAG = floor_rects([[29, 16, 3, 4]])      # the far ledge
MIRR = floor_rects([[6, 23, 5, 3]])       # the low ledge
floor = LAND.merge(SLICK).merge(FRAG).merge(MIRR)
cave_paint(ov, floor)
# the slick: the cave tileset's dark, wet-looking floor (a 2x2 repeat), which the
# game treats as ice on this map (028_Heartroot.rb)
SLICK.each_key { |x, y| ov.set(x, y, 0, [[523, 524], [531, 532]][y % 2][x % 2]) }

# Stones in the flow, chosen so the slide can be solved both ways (checked below).
STONES = [[12, 3], [9, 8], [15, 6], [20, 4], [26, 7], [11, 13], [18, 11], [24, 13],
          [14, 17], [21, 19], [27, 18], [9, 20], [17, 22], [23, 9], [28, 12]]
STONES.each { |x, y| ov.set(x, y, 2, 792) }

# --- the solver: can you get from the landing to both ledges and back? -----------
walk = ->(c) { floor[c] && !STONES.include?(c) }
slick = ->(c) { SLICK[c] }
step = lambda do |c, d|
  n = [c[0] + d[0], c[1] + d[1]]
  return nil if !walk.(n)
  while slick.(n)
    nn = [n[0] + d[0], n[1] + d[1]]
    break if !walk.(nn)
    n = nn
  end
  n
end
reach = lambda do |start|
  seen = { start => true }; q = [start]
  until q.empty?
    c = q.shift
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |d|
      n = step.(c, d)
      next if !n || seen[n]
      seen[n] = true; q << n
    end
  end
  seen
end
from_land = reach.([3, 3])
ok_frag = FRAG.keys.any? { |c| from_land[c] }
ok_mirr = MIRR.keys.any? { |c| from_land[c] }
back_f = FRAG.keys.select { |c| from_land[c] }.all? { |c| reach.(c)[[3, 3]] }
back_m = MIRR.keys.select { |c| from_land[c] }.all? { |c| reach.(c)[[3, 3]] }
puts "overflow slide: fragment ledge #{ok_frag}, mirror ledge #{ok_mirr}, back from them #{back_f}/#{back_m}"
raise "overflow slide not solvable" unless ok_frag && ok_mirr && back_f && back_m

[3, 4].each { |y| ov.warp(2, y, SAP_WELLS, 37, y + 6, 4, name: "Up to the Sap Wells") }
ov.cutscene(4, 4, :overflow_enter)
ov.sign(5, 2, :overflow_sign)
ov.event(31, 17, "Congealed sap", [
  { graphic: "", tile_id: 809, script: "FT.map_fragment(@event_id)" },
  { self_switch: "A", graphic: "", tile_id: 808, script: "FT.talk(:fragment_taken, @event_id)" }
])
ov.event(8, 25, "Twin mirror", [{ graphic: "", tile_id: 809, script: "FT.twin_mirror(@event_id)" }])
[[11, 13], [24, 13]].each { |x, y| ov.sign(x, y, :sap_bones) }
save(ov, :overflow)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT}"
