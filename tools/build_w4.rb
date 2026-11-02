# Worker W4's maps for the faithful build-out (rootspire.md Tabs 4-8, and the
# White Vault): new places, and the people the trial week and the
# Undercanopy's side stories add to maps the earlier builders made.
#
#   2077 The Underdark Door (rebuilt: the old guard tunnels, Q3.2's crawl)
#   2078 Glasswater Lake (rebuilt: outdoors, past the thinned Wall, east of the Fields)
#   2160 The Undercity, below the Smuggler's Run (W1: Shadows in the Undercity)
#   2161 The Mirror Maze             (A1; the wraiths' testimony; the Echo sigil)
#   2163 Beyond the Auroral Wall     (B2; GQ4: Dougan's Hole, frozen time)
#   2164 The Drowned Hall            (GQ4: the Temporal Guardian)
#   2165 The Attunement Way          (Q1.2: the Heartroot's Test)
#   2166 The Crystals' Dream         (Gym 8: the Trial of the Four Seasons)
#   2168 The White Vault  2169 The Mirror Circuits  2170 The Seraph Cradle
#   2171 A Sporeling's Dream         (H5: the Dream Rescue)
#   2172 The Disused Root            (H2: the kobolds' nest)
#
# Run after build_act3.rb (it reopens maps every chapter builder has made).
require_relative "ft_common"
require_relative "cavekit"

TSETS = load_data(File.join(GAME_DIR, "Data/Tilesets.rxdata"))
MURKY = 6
WATER = 5
MIRROR_TILE = 809          # a pane of mirror-glass (Autumn's mirror uses it too)
ICE_CRYSTAL = 8518         # an ice crystal (the Outdoor tileset: the Ice Mountains use it)
GLOWCAP = 792              # a glowing cap, on a cave's rocks

NAMES = {
  2077 => "The Underdark Door", 2078 => "Glasswater Lake", 2160 => "The Undercity", 2161 => "The Mirror Maze",
  2163 => "Beyond the Auroral Wall", 2164 => "The Drowned Hall", 2165 => "The Attunement Way", 2166 => "The Crystals' Dream",
  2168 => "The White Vault", 2169 => "The Mirror Circuits", 2170 => "The Seraph Cradle", 2171 => "A Sporeling's Dream",
  2172 => "The Disused Root"
}

# Switches (the scripts' SW_ constants)
SW_TRIALS, SW_TALION, SW_TRIBUNAL = 3988, 3990, 3991
SW_MIRA_FREED = 3974
SW_RIFT_STORM, SW_RHEVEN_BLIGHT, SW_FANE_DELEGATION, SW_FANE_POISONER = 4120, 4121, 4122, 4123
SW_MEMORY_HEIST, SW_KOBOLD_NEST, SW_DREAM_OPEN = 4124, 4125, 4147
SW_SMUGGLERS, SW_ECHO_POCKET, SW_GLASSWATER, SW_BEYOND_WALL, SW_LEAF_SHELF, SW_FIELD_SPIRITS = 4127, 4128, 4129, 4137, 4141, 4146
SW_TALION_FIELDS, SW_WALL_WORKS, SW_DEBATES, SW_PETITIONS, SW_FOUR_SEASONS, SW_EIRWEN_SHRINE = 4131, 4132, 4133, 4134, 4135, 4136
SW_AURIL_RELICS, SW_SIGILS_MERGED, SW_VAULT_BROKEN = 4138, 4139, 4140
SW_MIRA_MIRROR, SW_REFUGEE_CAMP, SW_SLAUDI, SW_WOLF_RAID = 4142, 4143, 4144, 4145
SW_APPEAL, SW_CRIERS, SW_WYN_HEARING, SW_PELL = 4150, 4151, 4152, 4153

def cells(*rects) = rects.flat_map { |x, y, w, h| Builder.rect_cells(x, y, w, h) }

def floor_of(*rects)
  f = {}
  cells(*rects).each { |c| f[c] = true }
  f
end

# --- placing things on maps other builders made --------------------------------
def walkable?(b, x, y)
  return false unless b.inside?(x, y)
  t = TSETS[b.map.tileset_id]
  [2, 1, 0].each do |z|
    id = b.map.data[x, y, z]
    next if id == 0
    return false if t.passages[id] & 0x0f == 0x0f
    return true if t.priorities[id] == 0
  end
  true
end

def taken?(b, x, y) = b.map.events.values.any? { |e| e.x == x && e.y == y }

# The nearest free, walkable cell to (x, y), off the map's edge, that doesn't
# sit in a one-tile corridor (somebody standing there would block the way).
def place_near(b, x, y, radius: 6)
  (0..radius).each do |r|
    ring = (-r..r).flat_map { |dx| (-r..r).map { |dy| [dx, dy] } }.select { |dx, dy| [dx.abs, dy.abs].max == r }
    ring.sort_by { |dx, dy| dx.abs + dy.abs }.each do |dx, dy|
      cx, cy = x + dx, y + dy
      next if cx <= 0 || cy <= 0 || cx >= b.w - 1 || cy >= b.h - 1
      next if !walkable?(b, cx, cy) || taken?(b, cx, cy)
      open = [[1, 0], [-1, 0], [0, 1], [0, -1]].count { |ox, oy| walkable?(b, cx + ox, cy + oy) }
      next if open < 3
      return [cx, cy]
    end
  end
  raise "no room near (#{x},#{y}) on map #{b.map.inspect[0, 40]}"
end

# A person who's only about while a switch is on (and stands where there's room).
def person_when(b, x, y, name, graphic, script, switch, dir: 2, switch2: nil)
  px, py = place_near(b, x, y)
  page = { switch: switch, graphic: graphic, direction: dir, script: script }
  page[:switch2] = switch2 if switch2
  b.event(px, py, name, [{ graphic: "", through: true }, page])
end

# Something set into a wall (a shelf, a niche, a crack): read it by facing it.
def in_wall(b, x, y, name, script, switch: nil, tile: 0)
  raise "#{name}: (#{x},#{y}) isn't a wall" if walkable?(b, x, y)
  raise "#{name}: (#{x},#{y}) is taken" if taken?(b, x, y)
  pages = switch ? [{ graphic: "", through: true }, { switch: switch, tile_id: tile, script: script }] :
                   [{ tile_id: tile, script: script }]
  b.event(x, y, name, pages)
end

# A step-on moment that happens once (its script marks it done).
def once_trigger(b, x, y, name, script, switch: nil)
  first = { trigger: 1, through: true, script: "#{script}\nFT.set_self_switch(@event_id, 'A')" }
  pages = switch ? [{ through: true }, first.merge(switch: switch)] : [first]
  pages << { self_switch: "A", through: true }
  b.event(x, y, name, pages)
end

# A doorway that opens when a switch is on (else a line of text and a step back).
def gated_warp(b, x, y, name, closed_script, switch, to_map, tx, ty, dir)
  b.event(x, y, name, [
    { trigger: 1, script: "#{closed_script}\npbMoveRoute($game_player, [PBMoveRoute::Backward])" },
    { switch: switch, trigger: 1, through: true, commands: [b.command(201, [0, to_map, tx, ty, dir, 0])] }
  ])
end

def find_event(b, name) = b.map.events.values.find { |e| e.name == name }

# --- mirror-ice caverns (the Ice Cavern's snow floor and ice cliffs) -----------
ICE_FACE, ICE_WEST, ICE_EAST = 412, 405, 403    # cliff face; cliff with floor east of it; with floor west of it

def ice_map(w, h)
  b = Builder.new(w, h)
  b.fill(0, SNOW)
  b
end

def ice_paint(b, floor)
  (0...b.w).each do |x|
    (0...b.h).each do |y|
      next if floor[[x, y]]
      t = floor[[x + 1, y]] ? ICE_WEST : floor[[x - 1, y]] ? ICE_EAST : ICE_FACE
      b.set(x, y, 1, t)
    end
  end
end

def cave_floor(b, floor)
  cave_paint(b, floor)
end

# ==============================================================================
# 2077: the Underdark Door. Up from the old guard tunnels under the Root-Tier,
# past black pools where quippers swarm and creepers pull, and a still patch of
# air that breathes, to the broken door and the frost circle behind it.
ud = cave_map(20, 34)
ud_floor = floor_of([7, 28, 5, 5], [8, 33, 3, 1], [8, 22, 3, 6], [3, 17, 8, 5], [5, 10, 1, 7], [3, 11, 2, 4],
                    [5, 7, 3, 3], [8, 8, 4, 1], [8, 9, 4, 2], [12, 7, 4, 3], [14, 4, 1, 3], [6, 3, 9, 2])
cave_paint(ud, ud_floor)
pool1 = cells([3, 11, 2, 4]); pool2 = cells([8, 9, 4, 2])
(pool1 + pool2).each { |x, y| ud.set(x, y, 0, CAVE_FLOOR) }
ud.autotile(1, MURKY, pool1 + pool2)
[[7, 28], [11, 28], [3, 17], [10, 17], [6, 3], [14, 3]].each { |x, y| ud.set(x, y, 2, GLOWCAP) }
[8, 9, 10].each { |x| ud.warp(x, 33, 2055, 10, 20, 2, name: "Back to the Root-Tier") }
ud.cutscene(10, 30, :underdark_crawl)
once_trigger(ud, 5, 13, "Ambush pool", "FT.underdark_ambush(:pool, @event_id)")
once_trigger(ud, 10, 8, "Ambush weeds", "FT.underdark_ambush(:weeds, @event_id)")
once_trigger(ud, 14, 5, "Ambush stalker", "FT.underdark_ambush(:stalker, @event_id)")
ud.event(9, 2, "Broken door", [{ tile_id: 582, script: "FT.underdark_door(@event_id)" }])
save_map(ud, 2077, "Lavender Town")

# ==============================================================================
# 2078: Glasswater Lake. Out past the Blooming Fields where the Wall has thinned:
# a still lake, half thawed, that holds the wrong stars. The old boat is in the
# reeds on the near shore; the Wall stands on the far one.
GW, GH = 32, 24
gw = Builder.new(GW, GH)
gw.fill(0, SNOW)
lake = []
gopen = {}
(0...GH).each do |y|
  (0...GW).each do |x|
    d = ((x - 16.5) / 8.0)**2 + ((y - 11.5) / 6.0)**2
    lake << [x, y] if d < 1.0
    gopen[[x, y]] = true if d < 1.9 && x >= 2 && x <= GW - 4 && y >= 2 && y <= GH - 3
  end
end
cells([0, 9, 6, 5], [GW - 5, 9, 5, 5]).each { |c| gopen[c] = true }
forest_except(gw, GW, GH, gopen)
gw.autotile(0, WATER, lake)
grass(gw, 5, 4, 4, 2); grass(gw, 22, 18, 5, 2); grass(gw, 6, 18, 3, 2)
(0...GH).step(2) { |y| gw.stamp(ICE_BOULDER, GW - 2, y) unless (9..13).include?(y) || (9..13).include?(y + 1) }
[9, 10, 11, 12, 13].each { |y| gw.warp(0, y, 2060, 45, 14, 4, name: "To the Blooming Fields") }
[10, 11, 12].each do |y|
  gated_warp(gw, GW - 2, y, "Through the Wall", "FT.talk(:auroral_wall, @event_id)", SW_BEYOND_WALL, 2163, 4, 20, 6)
end
(9..13).each { |y| gw.set(GW - 1, y, 1, ICE_BOULDER.layers[2][0][0]) }   # the Wall's own edge, solid
gw.event(8, 9, "Old boat", [{ graphic: "", tile_id: CRATE, script: "FT.glasswater_boat(@event_id)" }])
gw.event(8, 14, "The lake's edge", [{ graphic: "", tile_id: ICE_CRYSTAL, opacity: 120, script: "FT.glasswater_shore(@event_id)" }])
gw.event(9, 12, "Talion at the lake", [{ graphic: "", through: true },
                                        { switch: SW_TALION, graphic: "BW (17)", direction: 6, opacity: 170, script: "FT.talion_ritual(@event_id)" }])
gw.event(26, 15, "Far-shore boat", [{ graphic: "", tile_id: CRATE, script: "FT.glasswater_boat(@event_id)" }])
gw.sign(4, 8, :glasswater_still)
seal_edges(gw)
save_map(gw, 2078, "Lavender Town")

# ==============================================================================
# 2160: the Smuggler's Run, under the Root-Tier docks: dripping caverns, moss-
# steam off black water, glow-worm lanterns; three forks in the spore cloud;
# the eyed colony at the end; and a Guild vault door in the rock.
sr = cave_map(34, 20)
sr_floor = floor_of([2, 2, 6, 5], [5, 7, 2, 6], [5, 13, 14, 1], [7, 14, 12, 3], [19, 6, 1, 8], [19, 5, 10, 1], [26, 6, 6, 8])
cave_paint(sr, sr_floor)
channel = cells([7, 14, 12, 3])
channel.each { |x, y| sr.set(x, y, 0, CAVE_FLOOR) }
sr.autotile(1, MURKY, channel)
[[2, 2], [7, 2], [26, 6], [31, 13], [20, 6]].each { |x, y| sr.set(x, y, 2, GLOWCAP) }
sr.event(4, 1, "Up into the Smuggler's Run", [{ trigger: 1, through: true, commands: [sr.command(201, [0, 2198, 31, 22, 8, 0])] }])
sr.cutscene(4, 3, :smugglers_run)
sr.sign(3, 6, :run_glowworms)
once_trigger(sr, 10, 13, "Spore fork 1", "FT.spore_trail(1, @event_id)")
once_trigger(sr, 19, 9, "Spore fork 2", "FT.spore_trail(2, @event_id)")
once_trigger(sr, 24, 5, "Spore fork 3", "FT.spore_trail(3, @event_id)")
sr.event(29, 9, "The eyed colony", [{ graphic: "Followers/PARASECT", direction: 2, blend_type: 2, opacity: 220, step_anime: true,
                                      script: "FT.undercity_colony(@event_id)" }])
in_wall(sr, 32, 11, "Guild vault door", "FT.talk(:guild_vault_sealed, @event_id)", tile: 582)
save_map(sr, 2160, "Lavender Town")
# (The hole at (4,1) is in the cave's rock: make it a floor cell so you can step on it.)
sr2 = reopen(2160)
sr2.set(4, 1, 0, CAVE_FLOOR)
resave(sr2, 2160)
# The Undercity is the Smuggler's Run's deepest part (one place, as in the notes):
# a spore-choked crack at the Run's far end (2198, W5's map) leads down to it.
run = reopen(2198)
run.event(31, 23, "Spore-choked crack", [{ tile_id: 582, through: false, script: "FT.talk(:run_hatch_shut, @event_id)" },
                                          { switch: SW_SMUGGLERS, tile_id: 582, through: true, trigger: 1,
                                            commands: [run.command(201, [0, 2160, 4, 3, 2, 0])] }])
resave(run, 2198)

# ==============================================================================
# 2161: the Mirror Maze, the pocket of mirror-ice behind the Echo Gate's frost:
# corridors that reflect corridors; three junctions; at its heart the pane
# with Alerion's lost reflection, and the ring of wraiths waiting to be asked.
mz = ice_map(25, 26)
mz_floor = floor_of([10, 20, 5, 4], [12, 24, 1, 2], [12, 15, 1, 5], [6, 11, 13, 4], [6, 5, 1, 6], [18, 5, 1, 6],
                    [6, 3, 13, 2], [7, 8, 3, 1], [15, 8, 3, 1], [9, 6, 1, 2], [15, 6, 1, 2])
ice_paint(mz, mz_floor)
mz.warp(12, 25, 2050, 8, 22, 6, name: "Back through the Echo Gate")
mz.cutscene(11, 22, :mirror_maze)
mz.event(13, 17, "Junction: wraiths", [{ tile_id: ICE_CRYSTAL, script: "FT.maze_junction(:stealth, @event_id)" }])
mz.event(5, 7, "Junction: three ways", [{ tile_id: ICE_CRYSTAL, script: "FT.maze_junction(:path, @event_id)" }])
mz.event(19, 7, "Junction: the shadow", [{ tile_id: ICE_CRYSTAL, script: "FT.maze_junction(:shadow, @event_id)" }])
mz.event(8, 2, "Alerion's reflection", [{ tile_id: ICE_CRYSTAL, script: "FT.maze_reflection(@event_id)" }])
mz.event(12, 2, "The ring of wraiths", [{ graphic: "Followers/MISMAGIUS_fly", direction: 2, opacity: 160, step_anime: true,
                                          script: "FT.maze_witness(@event_id)" }])
mz.event(11, 2, "Wraith", [{ graphic: "Followers/MISMAGIUS_fly", direction: 6, opacity: 140, step_anime: true, script: "FT.maze_witness(@event_id)" }])
mz.event(13, 2, "Wraith ", [{ graphic: "Followers/MISMAGIUS_fly", direction: 4, opacity: 140, step_anime: true, script: "FT.maze_witness(@event_id)" }])
[[9, 10], [15, 10], [8, 16], [16, 16]].each_with_index do |(x, y), i|
  mz.event(x, y, "Sign maze_pane #{i}", [{ tile_id: ICE_CRYSTAL, script: "FT.talk(:maze_pane, @event_id)" }]) if !mz_floor[[x, y]]
end
save_map(mz, 2161, "Lavender Town")

# ==============================================================================
# 2163: Beyond the Auroral Wall. Frozen time: snowflakes hanging mid-fall, a
# half-thawed lake with waves stopped mid-crest, and the ruins of Dougan's
# Hole under the ice. In from the Wall on the west; the glacier to the north.
BW_, BH = 40, 28
bw = Builder.new(BW_, BH)
bw.fill(0, SNOW)
bopen = {}
blake = []
cells([0, 17, 8, 7], [8, 20, 3, 1], [11, 18, 26, 6], [32, 15, 3, 3], [33, 12, 1, 3], [32, 9, 3, 3],
      [12, 4, 23, 5], [28, 0, 3, 4]).each { |c| bopen[c] = true }
(0...BH).each do |y|
  (0...BW_).each do |x|
    if ((x - 22.0) / 9.5)**2 + ((y - 13.0) / 4.6)**2 < 1.0
      blake << [x, y]
      bopen[[x, y]] = true
    end
  end
end
forest_except(bw, BW_, BH, bopen)
bw.autotile(0, WATER, blake)
[[16, 11], [23, 13], [27, 10]].each { |x, y| bw.stamp(ICE_BOULDER, x, y) }           # the frozen waves
bw.stamp(CABIN, 20, 3)                                                                # Dougan's Hole mead hall, sunk to its eaves
[[13, 4], [34, 20]].each { |x, y| bw.stamp(BOULDER, x, y) }
grass(bw, 12, 21, 5, 2); grass(bw, 26, 21, 5, 2); grass(bw, 30, 5, 3, 3)
[18, 19, 20, 21, 22, 23].each do |y|
  bw.event(0, y, "The Wall, closing", [{ trigger: 1, through: true, script: "FT.beyond_return(@event_id)" }])
end
bw.cutscene(4, 19, :beyond_wall)
once_trigger(bw, 9, 20, "Frozen time 1", "FT.time_hazard(1, @event_id)")
once_trigger(bw, 33, 13, "Frozen time 2", "FT.time_hazard(2, @event_id)")
once_trigger(bw, 29, 2, "Frozen time 3", "FT.time_hazard(3, @event_id)")
bw.event(20, 21, "Frozen Rootwarden", [{ graphic: "BW029", direction: 6, opacity: 170, step_anime: false, walk_anime: false,
                                         script: "FT.frozen_rootwarden(@event_id)" }])
bw.event(22, 7, "Mead hall door, under ice", [{ tile_id: ICE_CRYSTAL, script: "FT.drowned_hall_ice(@event_id)" }])
bw.sign(18, 8, :drowned_hall_sign)
bw.sign(15, 18, :beyond_waves)
bw.sign(6, 17, :beyond_snow)
[28, 29, 30].each do |x|
  gated_warp(bw, x, 0, "The path of glass", "FT.talk(:vault_gate_shut, @event_id)", SW_SIGILS_MERGED, 2168, 14, 26, 8)
end
seal_edges(bw)
save_map(bw, 2163, "Lavender Town")

# ==============================================================================
# 2164: the Drowned Hall: Dougan's Hole's mead hall under the lake ice, dark,
# dry and sealed; a feast frozen on the tables; the Temporal Guardian at the end.
module Hall
  VOID, FLOOR, WALL, BASE = 48, 692, 950, 958
  TABLE = [[1264, 1265], [[1272, 1273], [1280, 1281]]]
  CRATE = [[8114, 8115], [[8122, 8123], [8130, 8131]]]
end
def hall_obj(b, obj, x, y)
  over, rows = obj
  over.each_with_index { |t, i| b.set(x + i, y - 1, 2, t) }
  rows.each_with_index { |row, j| row.each_with_index { |t, i| b.set(x + i, y + j, 1, t) } }
end
dh = Builder.new(19, 17, tileset_id: 25)
dh.fill(0, Hall::VOID)
dh.fill(0, Hall::FLOOR, 1, 2, 17, 13)
dh.fill(0, Hall::WALL, 1, 0, 17, 1)
dh.fill(0, Hall::BASE, 1, 1, 17, 1)
dh.fill(0, Hall::FLOOR, 8, 15, 3, 2)
[[3, 6], [3, 10], [13, 6], [13, 10]].each { |x, y| hall_obj(dh, Hall::TABLE, x, y) }   # the frozen feast
hall_obj(dh, Hall::CRATE, 2, 3); hall_obj(dh, Hall::CRATE, 15, 3)
[8, 9, 10].each { |x| dh.warp(x, 16, 2163, 22, 8, 2, name: "Up through the ice") }
dh.event(9, 3, "Temporal Guardian", [{ graphic: "Followers/DUSKNOIR_fly", direction: 2, opacity: 200, step_anime: true,
                                       script: "FT.temporal_guardian(@event_id)" }])
dh.event(9, 2, "Chest under frost", [{ tile_id: 0, graphic: "BWPokeball", direction: 2, script: "FT.temporal_guardian(@event_id)" }])
save_map(dh, 2164, "Lavender Town")

# ==============================================================================
# 2165: the Attunement Way, below the Heartroot's seal: one path, older than the
# city. The passages that split; the spore-drift; the whispering roots; and the
# root with a single golden leaf at the end.
aw = cave_map(20, 26)
aw_floor = floor_of([8, 20, 5, 4], [10, 24, 1, 2], [10, 15, 1, 5], [6, 14, 9, 1], [6, 10, 1, 4], [14, 10, 1, 4],
                    [10, 8, 1, 6], [7, 4, 7, 4])
cave_paint(aw, aw_floor)
[[8, 20], [12, 20], [7, 4], [13, 4], [6, 10], [14, 10]].each { |x, y| aw.set(x, y, 2, GLOWCAP) }
aw.warp(10, 25, 2057, 18, 27, 2, name: "Back up to the seal")
once_trigger(aw, 10, 17, "The passages split", "FT.attunement_station(:passages, @event_id)")
once_trigger(aw, 10, 11, "The spore-drift", "FT.attunement_station(:spores, @event_id)")
once_trigger(aw, 10, 7, "The whispering roots", "FT.attunement_station(:whispers, @event_id)")
aw.event(10, 3, "The golden leaf", [{ tile_id: 0, graphic: "", script: "FT.attunement_leaf(@event_id)" }])
aw.sign(9, 19, :attunement_way)
save_map(aw, 2165, "Ecruteak City")

# ==============================================================================
# 2166: the Crystals' Dream: the Council Hall's four quarters, each a season.
cd = Builder.new(21, 17)
cd.fill(0, SNOW)
copen = {}
cells([2, 2, 17, 13]).each { |c| copen[c] = true }
forest_except(cd, 21, 17, copen)
FLOWER, MEADOW = 1249, 553
cells([2, 2, 8, 6]).each { |x, y| cd.set(x, y, 0, MEADOW) }                         # spring
[[3, 3], [5, 4], [7, 3], [4, 6], [8, 6]].each { |x, y| cd.set(x, y, 1, FLOWER) }
cells([11, 2, 8, 6]).each { |x, y| cd.set(x, y, 0, MEADOW) }                        # summer
tree(cd, 16, 2, 2)
grass(cd, 2, 9, 7, 2)                                                               # autumn: long grass going over
[[14, 10], [16, 12]].each { |x, y| cd.stamp(ICE_BOULDER, x, y) }                   # winter
cd.event(5, 5, "Spring", [{ tile_id: ICE_CRYSTAL, script: "FT.season_quarter(:spring, @event_id)" }])
cd.event(15, 5, "Summer", [{ tile_id: ICE_CRYSTAL, script: "FT.season_quarter(:summer, @event_id)" }])
cd.event(5, 12, "Autumn", [{ tile_id: ICE_CRYSTAL, script: "FT.season_quarter(:autumn, @event_id)" }])
cd.event(13, 12, "Winter", [{ graphic: "BWOldWoman", direction: 4, opacity: 200, script: "FT.season_quarter(:winter, @event_id)" }])
save_map(cd, 2166, "Ecruteak City")

# ==============================================================================
# 2168: the White Vault: a glacier, and in it a vault of white ice; the door
# of wings over a frozen eye at the end of the hall.
wv = ice_map(29, 28)
wv_floor = floor_of([13, 18, 3, 10], [6, 6, 17, 12])
cells([9, 9, 2, 2], [18, 9, 2, 2], [9, 13, 2, 2], [18, 13, 2, 2]).each { |c| wv_floor.delete(c) }   # pillars of ice
ice_paint(wv, wv_floor)
[13, 14, 15].each { |x| wv.warp(x, 27, 2163, 29, 1, 2, name: "Out to the glacier") }
wv.cutscene(14, 24, :vault_gate_enter)
wv.event(14, 6, "Door of wings", [
  { tile_id: ICE_CRYSTAL, script: "FT.vault_door(@event_id)" },
  { self_switch: "A", trigger: 1, through: true, commands: [wv.command(201, [0, 2169, 16, 21, 8, 0])] }
])
[13, 15].each { |x| wv.event(x, 5, "Sign vault_gate_shut #{x}", [{ tile_id: ICE_CRYSTAL, script: "FT.talk(:vault_gate_shut, @event_id)" }]) }
save_map(wv, 2168, "Lavender Town")

# 2169: the Mirror Circuits: machinery under the ice; three circuits (north,
# east, west) feed the cradle; Avarice in every mirror.
mc = ice_map(32, 24)
mc_floor = floor_of([15, 6, 3, 17], [16, 22, 1, 2], [3, 8, 8, 6], [22, 8, 8, 6], [10, 2, 13, 4], [11, 11, 4, 1], [18, 11, 4, 1])
ice_paint(mc, mc_floor)
mc.warp(16, 23, 2168, 14, 7, 2, name: "Back to the door of wings")
mc.cutscene(16, 20, :vault_circuits)
mc.event(4, 10, "Circuit west", [{ tile_id: ICE_CRYSTAL, script: "FT.vault_circuit(:circuit_west, @event_id)" }])
mc.event(28, 10, "Circuit east", [{ tile_id: ICE_CRYSTAL, script: "FT.vault_circuit(:circuit_east, @event_id)" }])
mc.event(12, 3, "Circuit north", [{ tile_id: ICE_CRYSTAL, script: "FT.vault_circuit(:circuit_north, @event_id)" }])
mc.event(16, 2, "To the cradle", [{ trigger: 1, through: true, commands: [mc.command(201, [0, 2170, 9, 13, 8, 0])] }])
[[14, 9], [18, 9], [14, 15], [18, 15]].each_with_index do |(x, y), i|
  mc.event(x, y, "Sign maze_pane v#{i}", [{ tile_id: ICE_CRYSTAL, script: "FT.talk(:maze_pane, @event_id)" }])
end
save_map(mc, 2169, "Lavender Town")

# 2170: the Seraph Cradle, at the glacier's heart.
sc = ice_map(19, 17)
ice_paint(sc, floor_of([3, 3, 13, 11], [8, 14, 3, 3]))
[8, 9, 10].each { |x| sc.warp(x, 16, 2169, 16, 3, 2, name: "Back to the circuits") }
sc.event(9, 5, "Avarice's cradle", [
  { graphic: "FT_avarice", direction: 2, opacity: 200, script: "FT.scene_vault_cradle" },
  { switch: SW_VAULT_BROKEN, graphic: "", tile_id: ICE_CRYSTAL, script: "FT.talk(:vault_cradle_empty, @event_id)" }
])
save_map(sc, 2170, "Lavender Town")

# ==============================================================================
# 2171: a sporeling's dream: a forest of stumps under a red sky, sawdust
# falling like snow, a giant logger's axe ringing somewhere.
dr = Builder.new(22, 22)
dr.fill(0, SNOW)
dopen = {}
cells([2, 3, 18, 16], [9, 19, 3, 2]).each { |c| dopen[c] = true }
forest_except(dr, 22, 22, dopen)
[[5, 6], [12, 8], [15, 13], [7, 14], [17, 5]].each { |x, y| dr.set(x, y, 2, CRATE) }       # stumps, cut flat
dr.cutscene(10, 17, :dream_logger)
dr.event(4, 9, "Hiding sporeling", [{ graphic: "Followers/SHROOMISH", direction: 2, script: "FT.dream_sporeling(@event_id)" }])
dr.event(15, 5, "Giant logger", [{ graphic: "BW (75)", direction: 2, script: "FT.dream_logger(@event_id)" }])
dr.event(10, 20, "Myr's thread", [{ tile_id: ICE_CRYSTAL, opacity: 160, script: "FT.dream_wake(@event_id)" }])
seal_edges(dr)
save_map(dr, 2171, "Lavender Town")

# 2172: the disused root where the kobolds keep their shinies.
kn = cave_map(16, 13)
cave_paint(kn, floor_of([3, 3, 10, 7], [6, 10, 3, 3]))
[[3, 3], [12, 3], [3, 9]].each { |x, y| kn.set(x, y, 2, GLOWCAP) }
[6, 7, 8].each { |x| kn.warp(x, 12, 2068, 24, 22, 4, name: "Back to the Bazaar") }
kn.event(7, 4, "Kobold nest", [{ graphic: "Followers/SANDSHREW", direction: 2, step_anime: true, script: "FT.kobold_nest(@event_id)" }])
in_wall(kn, 10, 2, "Sign kobold_hole", "FT.talk(:kobold_hole, @event_id)", tile: GLOWCAP)
save_map(kn, 2172, "Lavender Town")

# ==============================================================================
# Maps the earlier builders made: the trial week's people, and the rest.
# ------------------------------------------------------------------------------
# 2050 Rootspire: the criers, the Bazaar's gossip, the debate stage, the
# petitions, Anduin's fallen leaves, the Echo Gate's frost, Sorrel.
rs = reopen(2050)
rs.event(4, 0, "Cutscene trial_morning", [{ graphic: "", through: true }, { switch: SW_CRIERS, trigger: 3, script: "FT.scene_trial_morning" }])
person_when(rs, 26, 22, "Gossip 1", "BW (85)", "FT.talk(:trial_gossip_1, @event_id)", SW_TRIALS)
person_when(rs, 36, 21, "Gossip 2", "BWParasolLady", "FT.talk(:trial_gossip_2, @event_id)", SW_TRIALS)
person_when(rs, 15, 30, "Gossip 3", "BW (54)", "FT.talk(:trial_gossip_3, @event_id)", SW_TRIALS)
person_when(rs, 22, 31, "Children", "BW (20)", "FT.talk(:trial_children, @event_id)", SW_TRIALS)
person_when(rs, 40, 19, "Candlekeep scholar", "BW (72)", "FT.talk(:trial_scholar, @event_id)", SW_TRIALS)
person_when(rs, 52, 30, "Trader from the north", "BWHiker", "FT.talk(:trial_trader, @event_id)", SW_TRIALS)
person_when(rs, 30, 24, "Debate stage (Bazaar)", "BW (30)", "FT.debate_stage(:bazaar, @event_id)", SW_DEBATES)
person_when(rs, 27, 30, "Signer bazaar", "BW (61)", "FT.petition_signer(:bazaar, @event_id)", SW_PETITIONS)
fx, fy = place_near(rs, 22, 22)
rs.event(fx, fy, "Fallen leaves", [{ graphic: "", through: true }, { switch: SW_TRIALS, tile_id: 0, graphic: "Followers/SEEDOT", direction: 2,
                                                                     script: "FT.fallen_leaves(@event_id)" }])
rs.event(8, 21, "Echo Gate frost", [{ graphic: "", through: true }, { switch: SW_ECHO_POCKET, tile_id: ICE_CRYSTAL, script: "FT.echo_frost(@event_id)" }])
person_when(rs, 11, 22, "Sorrel", "BW029", "FT.wyn_emissary(@event_id)", SW_TRIALS, dir: 4)
resave(rs, 2050)

# 2053 the Rooted Hearth: the hush; Reptin's pack; the regulars sign.
rh = reopen(2053)
person_when(rh, 14, 7, "Hearth hush", "BW (54)", "FT.talk(:trial_hearth_hush, @event_id)", SW_TRIALS)
rh.event(3, 9, "Reptin's pack", [{ graphic: "BWPokeball", direction: 2, script: "FT.reptin_pack(@event_id)" }])
person_when(rh, 12, 9, "Signer hearth", "BW (62)", "FT.petition_signer(:hearth, @event_id)", SW_PETITIONS)
resave(rh, 2053)

# 2054 the Council Hall: Selrae's bid, Wyn's hearing, the spores hearing.
ch = reopen(2054)
sel = find_event(ch, "Selrae Vorn")
sel.pages << ch.build_page(sel.pages[0], { switch: SW_FOUR_SEASONS, graphic: "BWOldWoman", direction: 2, script: "FT.selrae_bid(@event_id)" })
person_when(ch, 12, 13, "Captain Kethan Vale (hearing)", "BW029", "FT.wyn_hearing(@event_id)", SW_WYN_HEARING, dir: 2)
person_when(ch, 7, 11, "Spring and Winter", "BW (30)", "FT.spores_debate(@event_id)", SW_TRIALS, dir: 6)
resave(ch, 2054)

# 2055 the Root-Tier: Pell at the tunnel mouth; the dockworker and the hatch
# down to the Smuggler's Run; Mira's trial-week page; the dockers sign.
rt = reopen(2055)
rt.map.events.delete_if { |_id, e| e.name == "To the Glasswater" }      # (the Glasswater is past the Wall now)
person_when(rt, 12, 19, "Pell", "BW029", "FT.pell(@event_id)", SW_PELL, dir: 4)
rt.npc(24, 9, "BW (38)", :smuggler_dockworker, dir: 2, name: "Dockworker")
# (The way down to the Undercity is the crack at the far end of the Smuggler's Run, 2198, below.)
mira = find_event(rt, "Mira of the North Wind")
mira.pages << rt.build_page(mira.pages[0], { switch: SW_MIRA_FREED, switch2: SW_TRIALS, graphic: "BW (33)", direction: 2, script: "FT.mira_trials(@event_id)" })
person_when(rt, 20, 21, "Signer dockers", "BW (38)", "FT.petition_signer(:dockers, @event_id)", SW_PETITIONS)
resave(rt, 2055)

# 2056 the Still Sky Shrine: Eirwen, this week. (Selrae's bid is in the Hall now.)
sh = reopen(2056)
sh.map.events.delete_if { |_id, e| e.name == "Selrae Vorn" }
person_when(sh, 12, 10, "Eirwen at the shrine", "BW (30)", "FT.eirwen_shrine(@event_id)", SW_EIRWEN_SHRINE)
resave(sh, 2056)

# 2057 the Heartroot: the appeal at the seal; Mira's cursed mirror; Auril's relic.
hr = reopen(2057)
person_when(hr, 19, 21, "Appeal to Hyphora", "", "FT.hyphora_appeal(@event_id)", SW_APPEAL)
ap = find_event(hr, "Appeal to Hyphora"); ap.pages[1].graphic.instance_variable_set(:@tile_id, MIRROR_TILE)
person_when(hr, 34, 22, "Mira's cursed mirror", "", "FT.mira_cursed_mirror(@event_id)", SW_MIRA_MIRROR)
mm = find_event(hr, "Mira's cursed mirror"); mm.pages[1].graphic.instance_variable_set(:@tile_id, MIRROR_TILE)
person_when(hr, 15, 22, "Auril's relic (seal)", "", "FT.auril_relic(:relic_seal, @event_id)", SW_AURIL_RELICS)
rl = find_event(hr, "Auril's relic (seal)"); rl.pages[1].graphic.instance_variable_set(:@tile_id, MIRROR_TILE)
resave(hr, 2057)

[[2058, 25, 5, :relic_wells], [2067, 13, 14, :relic_overflow]].each do |id, x, y, key|
  m = reopen(id)
  person_when(m, x, y, "Auril's relic (#{key})", "", "FT.auril_relic(:#{key}, @event_id)", SW_AURIL_RELICS)
  e = find_event(m, "Auril's relic (#{key})"); e.pages[1].graphic.instance_variable_set(:@tile_id, MIRROR_TILE)
  resave(m, id)
end

# 2060 the Blooming Fields: the wall, the crews, Rheven, the wolves; the camp
# and its voices; the Fields debate; Talion; the two spirits; the thin place in
# the Wall out to the Glasswater.
fl = reopen(2060)
person_when(fl, 40, 12, "Wall foreman", "BW (72)", "FT.wall_crew(@event_id)", SW_WALL_WORKS, dir: 4)
person_when(fl, 39, 16, "Captain Rheven (wall)", "BW (72)", "FT.rheven_wall(@event_id)", SW_WALL_WORKS, dir: 4)
person_when(fl, 41, 18, "Winter wolves", "Followers/MIGHTYENA", "FT.wall_wolves(@event_id)", SW_WOLF_RAID, dir: 4)
wrx, wry = place_near(fl, 38, 14)
fl.event(wrx, wry, "Wall rubble", [{ graphic: "", through: true }, { switch: SW_WALL_WORKS, tile_id: Builder::SIGNPOST_TILE, script: "FT.talk(:wall_rubble, @event_id)" }])
person_when(fl, 12, 16, "Refugee camp", "BW (37)", "FT.refugee_blankets(@event_id)", SW_REFUGEE_CAMP)
person_when(fl, 10, 18, "Refugee from Easthaven", "BWParasolLady", "FT.refugee_voice(:easthaven, @event_id)", SW_REFUGEE_CAMP)
person_when(fl, 15, 18, "Refugee from Bryn Shander", "BW (38)", "FT.refugee_voice(:bryn, @event_id)", SW_REFUGEE_CAMP)
person_when(fl, 17, 15, "Refugee from Termalaine", "BW (29)", "FT.refugee_voice(:termalaine, @event_id)", SW_REFUGEE_CAMP)
person_when(fl, 10, 15, "Signer refugees", "BW (30)", "FT.petition_signer(:refugees, @event_id)", SW_PETITIONS)
[[17, 19], [20, 18]].each { |x, y| fl.stamp(HAY, x, y) if [[x, y], [x + 1, y], [x, y + 1], [x + 1, y + 1]].all? { |c| walkable?(fl, *c) && !taken?(fl, *c) } }
person_when(fl, 26, 9, "Debate stage (Fields)", "BW (30)", "FT.debate_stage(:fields, @event_id)", SW_DEBATES)
person_when(fl, 39, 9, "Talion", "BW (17)", "FT.talion(@event_id)", SW_TALION_FIELDS, dir: 4)
person_when(fl, 31, 5, "Two spirits", "Followers/CASTFORM", "FT.field_spirits(@event_id)", SW_FIELD_SPIRITS)
fl.event(46, 14, "A thin place in the Wall", [{ through: true }, { switch: SW_GLASSWATER, trigger: 1, through: true,
                                                                   commands: [fl.command(201, [0, 2078, 1, 11, 6, 0])] }])
resave(fl, 2060)

# 2061 the Canopy-Tier: the Frostfell rifts at the Celestial Rift.
cn = reopen(2061)
# (An angel of the Frostfell, glimpsed through the shimmer: additive, like light.)
person_when(cn, 27, 7, "Frostfell rifts", "Followers/FROSLASS", "FT.frostfell_rifts(@event_id)", SW_RIFT_STORM)
rf = find_event(cn, "Frostfell rifts")
rf.pages[1].graphic.instance_variable_set(:@blend_type, 1)
rf.pages[1].graphic.instance_variable_set(:@opacity, 190)
rf.pages[1].instance_variable_set(:@step_anime, true)
resave(cn, 2061)

# 2062 the Wind-Glass Library: the gap on the chronal shelf; the oldest shelf;
# the scholars sign.
lb = reopen(2062)
in_wall(lb, 12, 2, "Chronal shelf", "FT.chronal_shelf(@event_id)", switch: SW_LEAF_SHELF, tile: 0)
in_wall(lb, 9, 2, "The oldest shelf", "FT.old_alliances(@event_id)", tile: 0)
person_when(lb, 10, 8, "Signer scholars", "BW (72)", "FT.petition_signer(:scholars, @event_id)", SW_PETITIONS)
resave(lb, 2062)

# 2012 Bryn Shander: Slaudi, by the fire.
br = reopen(2012)
person_when(br, 14, 28, "Slaudi", "BW (75)", "FT.slaudi(@event_id)", SW_SLAUDI)
resave(br, 2012)

# 2068 the Undercanopy: the nursery behind the moss; the tremor; Rheven at the
# blight; the Bazaar's spore games, duel and stolen amulets; the Fane's sap
# pool, thrones, niche, delegation and poisoner; Myr's circle, archive,
# threads and thief; and the myconids sign.
uc = reopen(2068)
in_wall(uc, 6, 31, "Moss curtain", "FT.secret_nursery(@event_id)")
uc.set(6, 31, 2, GLOWCAP)
once_trigger(uc, 11, 36, "Root tremor", "FT.garden_tremor(@event_id)", switch: SW_DREAM_OPEN)
person_when(uc, 13, 26, "Captain Rheven (blight)", "BW (72)", "FT.talk(:rheven_blight, @event_id)", SW_RHEVEN_BLIGHT, dir: 4)
person_when(uc, 28, 20, "Spore games", "Followers/SHROOMISH", "FT.spore_games(@event_id)", 3942)
person_when(uc, 33, 20, "Market duel", "Followers/BRELOOM", "FT.market_duel(@event_id)", 3942)
in_wall(uc, 25, 22, "Disused root", "FT.talk(:kobold_hole, @event_id)", tile: 0)
dr_ev = find_event(uc, "Disused root")
dr_ev.pages << uc.build_page(dr_ev.pages[0], { switch: SW_KOBOLD_NEST, commands: [uc.command(201, [0, 2172, 7, 10, 8, 0])] })
faria = find_event(uc, "Faria")
faria.pages[0].instance_variable_set(:@list, uc.script_commands("FT.faria_stall(@event_id)") + [uc.command(0, [])]) if faria
# the Fane
spx, spy = place_near(uc, 45, 21)
uc.event(spx, spy, "Sap pool", [{ tile_id: MIRROR_TILE, opacity: 200, blend_type: 1, script: "FT.sap_pool(@event_id)" }])
person_when(uc, 47, 22, "Root thrones", "", "FT.root_thrones(@event_id)", 3942)
th = find_event(uc, "Root thrones"); th.pages[1].graphic.instance_variable_set(:@tile_id, 582)
in_wall(uc, 49, 18, "Memory niche", "FT.memory_niche(@event_id)", tile: MIRROR_TILE)
person_when(uc, 43, 22, "Rootwarden delegation", "BW029", "FT.sap_delegation(@event_id)", SW_FANE_DELEGATION)
person_when(uc, 44, 20, "A Rootwarden at the pool", "BW029", "FT.fane_poisoner(@event_id)", SW_FANE_POISONER, dir: 6)
# Mnemosyne's chamber
person_when(uc, 15, 13, "Ritual circle", "", "FT.ritual_circle(@event_id)", 3942)
rc = find_event(uc, "Ritual circle"); rc.pages[1].graphic.instance_variable_set(:@tile_id, MIRROR_TILE)
in_wall(uc, 14, 13, "Memory archive", "FT.memory_archive(@event_id)", tile: MIRROR_TILE)
person_when(uc, 16, 11, "Tether threads", "", "FT.tether_threads(@event_id)", SW_DREAM_OPEN)
tt = find_event(uc, "Tether threads"); tt.pages[1].graphic.instance_variable_set(:@tile_id, MIRROR_TILE)
person_when(uc, 18, 14, "Archive thief", "BW (40)", "FT.memory_heist(@event_id)", SW_MEMORY_HEIST, dir: 8)
person_when(uc, 10, 38, "Signer myconids", "Followers/BRELOOM", "FT.petition_signer(:myconids, @event_id)", SW_PETITIONS)
resave(uc, 2068)

merge_infos(NAMES)
puts "built #{NAMES.size} maps into #{OUT} (and added W4's people to 2012, 2050, 2053-2058, 2060-2062, 2067, 2068)"
