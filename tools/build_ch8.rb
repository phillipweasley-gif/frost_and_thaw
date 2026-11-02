# Builds Act II, Chapter 8: the Rootsun Forge (script SC 8.01-8.09), under the
# ruins of Dougan's Hole, in the hag's old lair:
#   2072 The Rootward Barricade   2073 The Hag's Abandoned Domain
#   2074 The Cocoon Pens          2075 The Dragonforge     2076 The Heart Chamber
# Both of Chapter 7's roads come out at the Barricade's west end (the door of
# iron and glass, 034_Chapter8.rb FORGE_ARRIVAL).
require_relative "ft_common"
require_relative "cavekit"

ID = { barricade: 2072, hag_domain: 2073, hag_pens: 2074, dragonforge: 2075, heart_chamber: 2076 }
NAMES = { barricade: "The Rootward Barricade", hag_domain: "The Hag's Abandoned Domain", hag_pens: "The Cocoon Pens",
          dragonforge: "The Dragonforge", heart_chamber: "The Heart Chamber" }
MUSIC = { barricade: "tintower", hag_domain: "Lavender Town", hag_pens: "Lavender Town",
          dragonforge: "Seafoam Islands Music", heart_chamber: "tintower" }
GUILD_DIG = 2066
SW_BARRICADE_OPEN, SW_HAG_MIRROR, SW_AUTUMN_FELL, SW_FORGE_CLEARED, SW_ENGINE_DEAD, SW_SELRAE_PEN =
  3975, 3976, 3977, 3978, 3979, 3980

def save(b, key) = save_map(b, ID[key], MUSIC[key])
def cells(*rects) = rects.flat_map { |x, y, w, h| Builder.rect_cells(x, y, w, h) }
def paint(b, *rects)
  f = {}
  cells(*rects).each { |c| f[c] = true }
  cave_paint(b, f)
end
def rocks(b, x, y) = CAVE_ROCKS.each_with_index { |row, dy| row.each_with_index { |t, dx| b.set(x + dx, y + dy, 2, t) } }

# ---------------------------------------------------------------------------
# 2072: the Rootward Barricade. In at the west (the door of iron and glass);
# a long hall where duergar drive the diggers; the gate at the east end.
ba = cave_map(36, 22)
paint(ba, [2, 11, 27, 6], [8, 8, 6, 3], [18, 8, 6, 3], [29, 13, 5, 2])
[[3, 12], [27, 16], [9, 9], [22, 9]].each { |x, y| ba.set(x, y, 2, 792) }
[13, 14].each { |y| ba.warp(1, y, GUILD_DIG, 15, 20, 8, name: "Back up to the Guild Dig") }
ba.cutscene(4, 14, :barricade)
ba.event(5, 12, "Woken digger", [{ graphic: "BW (75)", direction: 2, script: "FT.forge_rest(@event_id)" }])
ba.event(10, 7, "Duergar ledger", [{ graphic: "", script: "FT.duergar_ledger(@event_id)" }])
ba.sign(20, 7, :barricade_illusion)
[[12, 14], [17, 12], [23, 15]].each_with_index do |(x, y), i|
  ba.event(x, y, "Glassy digger #{i + 1}", [{ graphic: "BW (75)", direction: i.even? ? 6 : 4, move_type: 0, script: "FT.talk(:glassy_digger, @event_id)" }])
end
ba.trainer(15, 15, nil, :duergar_kord, :FT_DUERGAR, dir: 8, sight: 3)
ba.trainer(21, 11, nil, :duergar_brask, :FT_DUERGAR, dir: 2, sight: 3)
ba.trainer(26, 13, nil, :duergar_hild, :FT_DUERGAR, dir: 4, sight: 2)
[13, 14].each do |y|
  ba.event(29, y, "Barricade gate", [
    { graphic: "BW054", direction: 4, script: "FT.barricade_gate(@event_id)" },
    { switch: SW_BARRICADE_OPEN, graphic: "", through: true }
  ])
end
[13, 14].each { |y| ba.warp(33, y, ID[:hag_domain], 2, y - 3, 6, name: "Into the hag's lair") }
save(ba, :barricade)

# ---------------------------------------------------------------------------
# 2073: the Hag's Abandoned Domain. Her kitchen: a tea table set for six under
# a cracked mirror; a stair down to the pens at the east.
hd = cave_map(30, 22)
paint(hd, [1, 9, 6, 4], [6, 5, 14, 12], [19, 9, 8, 4], [24, 12, 3, 6])
[[7, 6], [18, 6], [7, 15], [18, 15]].each { |x, y| hd.set(x, y, 2, 792) }
[10, 11].each { |y| hd.warp(1, y, ID[:barricade], 32, y + 3, 4, name: "Back to the Barricade") }
hd.event(12, 8, "Tea table", [
  { tile_id: 581, script: "FT.hag_tea_table(@event_id)" }
])
hd.event(12, 4, "Cracked mirror", [{ graphic: "", script: "FT.hag_tea_table(@event_id)" }])
[24, 25, 26].each { |x| hd.warp(x, 17, ID[:hag_pens], 3, 3, 2, name: "Down to the pens") }
save(hd, :hag_domain)

# ---------------------------------------------------------------------------
# 2074: the Cocoon Pens. Rows of amber cocoons in the root walls; the journal;
# Selrae in the last cocoon (if she went ahead); Garagai's axe-head.
cp = cave_map(28, 20)
paint(cp, [2, 2, 4, 4], [4, 5, 20, 10], [22, 14, 3, 4])
[2, 3, 4].each { |x| cp.warp(x, 1, ID[:hag_domain], 25, 16, 8, name: "Up to the kitchen") }
cp.cutscene(3, 4, :cocoon_pens)
[6, 9, 12, 15, 18].each { |x| cp.event(x, 4, "Cocoon", [{ tile_id: 809, script: "FT.talk(:cocoon_plate, @event_id)" }]) }
cp.event(21, 4, "Cocoon V-7", [{ tile_id: 808, script: "FT.talk(:cocoon_v7, @event_id)" }])
cp.event(12, 9, "Journal", [{ tile_id: 581, script: "FT.talk(:pens_journal, @event_id)" }])
cp.event(23, 7, "Last cocoon", [
  { tile_id: 808, script: "FT.selrae_cocoon(@event_id)" },
  { switch: SW_SELRAE_PEN, graphic: "BWOldWoman", direction: 2, opacity: 170, step_anime: false, script: "FT.selrae_cocoon(@event_id)" }
])
cp.event(5, 14, "Shelf", [{ tile_id: 581, script: "FT.garagai_shelf(@event_id)" }])
[22, 23, 24].each { |x| cp.warp(x, 18, ID[:dragonforge], 2, 14, 6, name: "On toward the forge") }
save(cp, :hag_pens)

# ---------------------------------------------------------------------------
# 2075: the Dragonforge. A bridge over the sap pit (where Autumn falls), then
# the cavern of the Twenty Stones with the chained dragon at its heart, and the
# black-glass stair up to the Heart Chamber behind the devil-priest.
df = cave_map(40, 30)
paint(df, [0, 13, 6, 3], [16, 4, 21, 23])
cave_bridge_h(df, 6, 15, 14)                                    # over the boiling sap
[13, 14, 15].each { |y| df.warp(0, y, ID[:hag_pens], 23, 16, 8, name: "Back to the pens") }
df.event(11, 14, "Darrus Fell", [
  { graphic: "BW (55)", direction: 4, script: "FT.scene_autumn_falls" },
  { switch: SW_AUTUMN_FELL, graphic: "", through: true }
])
[14, 15].each { |y| trigger(df, 8, y, :autumn_falls) }        # stepping on to the bridge
# the Twenty Stones round the dragon's cradle
cx, cy, r = 26, 15, 7
20.times do |i|
  a = 2 * Math::PI * i / 20
  x = (cx + r * Math.cos(a)).round; y = (cy + r * 0.85 * Math.sin(a)).round
  next if (x - 26).abs <= 1 && y < cy          # leave the north gap open, to the stair
  df.set(x, y, 2, 792)
end
df.event(26, 15, "Chardalyn dragon", [
  { graphic: "FT_chardalyn", direction: 2, blend_type: 0, step_anime: false, walk_anime: false, script: "FT.talk(:chardalyn_chained, @event_id)" },
  { switch: SW_ENGINE_DEAD, tile_id: 808, script: "FT.talk(:chardalyn_chained, @event_id)" }
])
df.sign(17, 3, :twenty_stones)
df.event(0, 0, "Cutscene dragonforge", [{ switch: SW_AUTUMN_FELL, trigger: 3, script: "FT.scene(:dragonforge, @event_id)" },
                                         { self_switch: "A" }])
df.trainer(20, 20, nil, :duergar_thane, :FT_DUERGAR, dir: 6, sight: 3)
df.event(26, 6, "Devil-priest", [
  { graphic: "BW (40)", direction: 2, script: "FT.devil_priest(@event_id)" },
  { switch: SW_FORGE_CLEARED, graphic: "BW (40)", direction: 4, script: "FT.devil_priest(@event_id)" }
])
[25, 26, 27].each do |x|
  df.event(x, 4, "Black-glass stair", [
    { trigger: 1, script: "FT.talk(:forge_stair_shut, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])" },
    { switch: SW_FORGE_CLEARED, trigger: 1, through: true, commands: [df.send(:command, 201, [0, ID[:heart_chamber], 9, 12, 8, 0])] }
  ])
end
save(df, :dragonforge)

# ---------------------------------------------------------------------------
# 2076: the Heart Chamber. The engine hangs over a pit of light; Var at the
# controls. The fight starts when you walk in (and again if you come back).
hc = cave_map(20, 16)
paint(hc, [3, 3, 13, 8], [8, 11, 3, 3])
[8, 9, 10].each { |x| hc.warp(x, 13, ID[:dragonforge], 26, 5, 2, name: "Down the black-glass stair") }
# the engine: the Sealed Chamber's great machine, hanging over the pit (6x6 tiles, layer 2)
(0..5).each { |dy| (0..5).each { |dx| hc.set(7 + dx, dy, 2, 704 + dy * 8 + dx) } }
hc.event(9, 6, "The engine", [
  { tile_id: 809, script: "FT.talk(:engine_dead, @event_id)" }
])
hc.event(9, 8, "Var Rime-Breaker", [
  { graphic: "FT_var", direction: 8 },
  { switch: SW_ENGINE_DEAD, graphic: "", through: true }
])
hc.event(0, 0, "Heart chamber", [
  { trigger: 3, script: "FT.scene_heart_chamber" },
  { switch: SW_ENGINE_DEAD }
])
save(hc, :heart_chamber)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT}"
