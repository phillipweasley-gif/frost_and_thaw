# Chapter 10: Trials of the Roots (script SC 10.01-10.09). Two new places,
# and the trial week's people added to the maps the earlier builders made:
#   2077 The Underdark Door (the old guard tunnels under the Root-Tier)
#   2078 The Glasswater Shore (a still lake under the roots, where Talion waits)
require_relative "ft_common"
require_relative "cavekit"

ID = { underdark_door: 2077, glasswater: 2078 }
NAMES = { underdark_door: "The Underdark Door", glasswater: "The Glasswater Shore" }
MUSIC = { underdark_door: "Lavender Town", glasswater: "Lavender Town" }
SW_TRIBUNAL, SW_TRIALS, SW_PHIL_MIRROR, SW_TALION = 3991, 3988, 3989, 3990
MURKY = 6

def cells(*rects) = rects.flat_map { |x, y, w, h| Builder.rect_cells(x, y, w, h) }
def paint(b, *rects)
  f = {}
  cells(*rects).each { |c| f[c] = true }
  cave_paint(b, f)
end
def during_trials(b, x, y, name, graphic, script, dir: 2, switch: SW_TRIALS)
  b.event(x, y, name, [{ graphic: "", through: true },
                       { switch: switch, graphic: graphic, direction: dir, script: script }])
end

# 2077: the Underdark Door
ud = cave_map(20, 16)
paint(ud, [8, 3, 3, 10], [6, 3, 7, 4], [8, 13, 3, 2])
[[6, 3], [12, 3]].each { |x, y| ud.set(x, y, 2, 792) }
[8, 9, 10].each { |x| ud.warp(x, 15, 2055, 10, 20, 2, name: "Back to the Root-Tier") }
ud.event(9, 2, "Broken door", [{ tile_id: 582, script: "FT.underdark_door(@event_id)" }])
save_map(ud, ID[:underdark_door], MUSIC[:underdark_door])

# 2078: the Glasswater Shore
gw = cave_map(24, 18)
lake = cells([4, 2, 16, 8])
paint(gw, [4, 2, 16, 8], [3, 10, 18, 3], [10, 13, 3, 3])
lake.each { |x, y| gw.set(x, y, 0, CAVE_FLOOR) }
gw.autotile(1, MURKY, lake)
[10, 11, 12].each { |x| gw.warp(x, 15, 2055, 26, 18, 2, name: "Back to the Root-Tier") }
gw.sign(5, 13, :glasswater_still)
gw.event(11, 10, "Talion", [{ graphic: "", through: true },
                            { switch: SW_TALION, graphic: "BW (17)", direction: 2, opacity: 160, script: "FT.talion(@event_id)" }])
save_map(gw, ID[:glasswater], MUSIC[:glasswater])

# 2054: the Council Hall (the Tribunal, the root-cells, the gallery)
ch = reopen(2054)
ch.event(1, 1, "Cutscene tribunal", [{ graphic: "", through: true }, { switch: SW_TRIBUNAL, trigger: 3, script: "FT.scene_tribunal" }])
ch.event(17, 5, "Root-cells", [{ graphic: "", through: true }, { switch: SW_TRIALS, graphic: "FT_phildendrin_hooded", direction: 8, script: "FT.root_cells(@event_id)" }])
during_trials(ch, 9, 7, "Gallery", "BW (30)", "FT.talk(:trial_gallery, @event_id)")
during_trials(ch, 16, 12, "Gallery 2", "BW (38)", "FT.talk(:trial_gallery, @event_id)")
resave(ch, 2054)

# 2050: Anduin by the market
rs = reopen(2050)
during_trials(rs, 20, 24, "Anduin", "FT_anduin", "FT.anduin_trial(@event_id)")
resave(rs, 2050)

# 2055: Captain Kethan Vale; the way to the Glasswater shore
rt = reopen(2055)
during_trials(rt, 10, 19, "Captain Kethan Vale", "BW029", "FT.kethan(@event_id)")
rt.event(27, 19, "To the Glasswater", [
  { trigger: 1, script: "FT.talk(:glasswater_shut, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])" },
  { switch: SW_TALION, trigger: 1, commands: [rt.send(:command, 201, [0, ID[:glasswater], 11, 13, 8, 0])] }
])
resave(rt, 2055)

# 2058: Autumn's spying mirror, in the Sap Wells
sw = reopen(2058)
sw.event(17, 18, "Autumn's mirror", [{ graphic: "", through: true }, { switch: SW_PHIL_MIRROR, tile_id: 809, script: "FT.autumn_mirror(@event_id)" }])
resave(sw, 2058)

# 2068: Kelyn and Selrae in the Undercanopy
uc = reopen(2068)
during_trials(uc, 11, 41, "Kelyn and Selrae", "BW (30)", "FT.councillors_undercanopy(@event_id)", dir: 4)
resave(uc, 2068)

# 2056: the Trial of Winter
sh = reopen(2056)
during_trials(sh, 14, 18, "Selrae Vorn", "BWOldWoman", "FT.selrae_trial(@event_id)")
resave(sh, 2056)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT} (and added the trial week to 2050, 2054, 2055, 2056, 2058, 2068)"
