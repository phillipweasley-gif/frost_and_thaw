# Builds Act II, Chapter 7: the Heartroot Labyrinth, zones I-II (after the
# supplement's Part IV-A key): the Root Gate (H1 root-spiral approach, H2 the
# runic seal circle, H3 the Warden's overlook, H4 the Rootguard post) and the
# Sap Wells (H5 threshold of dripping gold, H6 the central wells, H7 the
# overflow channel, H8 the whispering attendant). The way in is the root-well
# in Rootspire's market, once the High Speaker unseals it.
require_relative "ft_common"
require_relative "cavekit"

ID = { root_gate: 2057, sap_wells: 2058 }
NAMES = { root_gate: "Heartroot: the Root Gate", sap_wells: "Heartroot: the Sap Wells" }
MUSIC = { root_gate: "tintower", sap_wells: "Seafoam Islands Music" }
ROOTSPIRE = 2050
SW_SEAL_OPEN = 3938    # the runic seal circle is aligned (or the Sap Wraith is beaten): the braided-root door opens
SW_SELRAE    = 3939    # Selrae has been found and faced in the Sap Wells

def save(b, key) = save_map(b, ID[key], MUSIC[key])

def floor_rects(rects)
  fl = {}
  rects.each { |x, y, w, h| Builder.rect_cells(x, y, w, h).each { |c| fl[c] = true } }
  fl
end

def crystal(b, x, y, colour)
  top, bottom = colour == :blue ? [800, 808] : [801, 809]
  b.set(x, y - 1, 2, top); b.set(x, y, 2, bottom)
end

# ---------------------------------------------------------------------------
# 2057: the Root Gate. In at the top left (the root-spiral from the well);
# the spiral winds down to the seal circle (four runes round a braided-root
# door); past the door, the overlook on the right and the guard post below,
# and the way down to the Sap Wells at the bottom.
rg = cave_map(40, 36)
cave_paint(rg, floor_rects([
  [3, 2, 6, 5],                       # H1: the top of the spiral (arrival)
  [6, 6, 3, 8], [6, 12, 14, 3],       # the spiral, winding down and east
  [16, 14, 3, 4],
  [11, 17, 13, 9],                    # H2: the seal circle
  [17, 26, 3, 3],                     # the braided-root door (17-19, 26)
  [12, 28, 22, 3],                    # the passage past the door
  [30, 20, 7, 8],                     # H3: the overlook
  [10, 30, 3, 4], [6, 31, 10, 4],     # H4: the guard post, and the stair down
  [16, 31, 5, 4],                     # H35: the Captain's Alcove (Tab 3)
  [2, 32, 4, 2]                      # the Guild's dig breaks in from the west
]))
[[4, 3], [7, 9], [13, 13], [19, 15], [12, 18], [22, 18], [12, 25], [22, 25], [31, 21], [35, 26], [27, 29], [14, 33]].each { |x, y| rg.set(x, y, 2, 792) }
# the four seasonal runes, bleeding coloured sap, on the circle's rim
{ [12, 21] => :spring, [22, 21] => :summer, [12, 24] => :autumn, [22, 24] => :winter }.each do |(x, y), season|
  crystal(rg, x, y, season == :winter || season == :spring ? :blue : :pink)
  rg.event(x, y, "Rune of #{season.to_s.capitalize}", [{ graphic: "", script: "FT.season_rune(:#{season}, @event_id)" }])
end
rg.event(17, 20, "Seal circle", [
  { graphic: "", tile_id: 582, script: "FT.rune_seal(@event_id)" },
  { switch: SW_SEAL_OPEN, graphic: "", tile_id: 582, script: "FT.talk(:seal_open, @event_id)" }
])
[17, 18, 19].each do |x|
  rg.event(x, 26, "Braided-root door", [
    { graphic: "", tile_id: 434, through: false, script: "FT.talk(:root_door_shut, @event_id)" },
    { switch: SW_SEAL_OPEN, graphic: "", through: true }
  ])
end
rg.warp(5, 2, ROOTSPIRE, 44, 17, 2, name: "Up the root-spiral")
rg.cutscene(4, 4, :heartroot_enter)
rg.event(36, 23, "Overlook railing", [{ graphic: "", tile_id: 792, script: "FT.talk(:warden_overlook, @event_id)" }])
rg.trainer(13, 31, nil, :thrall_oren, :FT_ROOTWARDEN, dir: 6, sight: 3)
rg.trainer(29, 29, nil, :thrall_mae, :FT_ROOTWARDEN, dir: 4, sight: 3)
rg.trainer(19, 28, nil, :thrall_bryce, :FT_ROOTWARDEN, dir: 2, sight: 2)
rg.trainer(25, 30, nil, :thrall_ulla, :FT_ROOTWARDEN, dir: 8, sight: 2)
[32, 33].each { |y| rg.warp(2, y, 2066, 33, y - 20, 4, name: "Into the Guild dig") }
rg.trainer(19, 32, nil, :sapwarden_captain_hesk, :FT_ROOTWARDEN, dir: 4, sight: 3)
rg.event(20, 34, "Captain's root-desk", [{ graphic: "", tile_id: 581, script: "FT.captains_alcove(@event_id)" }])
rg.event(8, 32, "Rootguard brazier", [{ graphic: "", tile_id: 581, script: "FT.talk(:rootguard_post, @event_id)" }])
[7, 8].each { |x| rg.warp(x, 34, ID[:sap_wells], x == 7 ? 4 : 5, 3, 2, name: "Down to the Sap Wells") }
save(rg, :root_gate)

# ---------------------------------------------------------------------------
# 2058: the Sap Wells. Down from the Root Gate at the top left; the threshold,
# three golden wells in the central cavern, the overflow channel running east
# with a map fragment caught in the sap, and the attendant on its root column.
# Selrae waits at the far end.
sw = cave_map(42, 30)
cave_paint(sw, floor_rects([
  [2, 2, 7, 6],                       # H5: the threshold
  [8, 5, 6, 3],
  [12, 3, 16, 14],                    # H6: the central wells
  [27, 8, 12, 3],                     # H7: the overflow channel, east
  [34, 10, 5, 12],
  [24, 17, 14, 6],                    # H8: the attendant's hollow
  [16, 17, 9, 9]                      # Selrae's chamber
]))
[[3, 3], [7, 6], [13, 4], [26, 4], [14, 15], [30, 9], [37, 14], [25, 21], [36, 21], [17, 24], [23, 24]].each { |x, y| sw.set(x, y, 2, 792) }
[[16, 7], [22, 7], [19, 12]].each_with_index do |(x, y), i|
  sw.event(x, y, "Sap well #{i + 1}", [{ graphic: "", tile_id: 582, script: "FT.sap_well(#{i + 1}, @event_id)" }])
end
[9, 10].each { |y| sw.warp(38, y, 2067, 3, y - 6, 2, name: "Down the Overflow Channel") }
sw.sign(20, 26, :heart_wall)
sw.event(30, 18, "Whispering attendant", [{ graphic: "Followers/PHANTUMP_fly", direction: 2, step_anime: true, script: "FT.attendant(@event_id)" }])
sw.event(20, 20, "Selrae Vorn", [
  { graphic: "BWOldWoman", direction: 2, script: "FT.selrae_heartroot(@event_id)" },
  { switch: SW_SELRAE, graphic: "", through: true }
])
[4, 5].each { |x| sw.warp(x, 2, ID[:root_gate], x == 4 ? 7 : 8, 33, 8, name: "Up to the Root Gate") }
sw.cutscene(3, 5, :sap_wells_enter)
save(sw, :sap_wells)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT}"
