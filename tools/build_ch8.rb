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
# A2-A7: the inner rooms, up from the north alcove (build_ch8_deep.rb, 2146)
[22, 23].each { |x| ba.warp(x, 8, 2146, 18, 21, 8, name: "Into the inner rooms") }
# A13: the sap-lift's Root stop, once the Rootwatch is cleared
ba.event(28, 15, "Sap-lift", [{ tile_id: 582, script: "FT.sap_lift(:root, @event_id)" },
                              { switch: 4087, tile_id: 582, script: "FT.sap_lift(:root, @event_id)" }])
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
[24, 25, 26].each { |x| hd.warp(x, 17, 2147, 5, 4, 2, name: "Down the Deep Root Shaft") }
save(hd, :hag_domain)

# ---------------------------------------------------------------------------
# 2074: the Cocoon Pens. Rows of amber cocoons in the root walls; the journal;
# Selrae in the last cocoon (if she went ahead); Garagai's axe-head.
cp = cave_map(28, 20)
paint(cp, [2, 2, 4, 4], [4, 5, 20, 10], [22, 14, 3, 4], [6, 15, 10, 4])
[2, 3, 4].each { |x| cp.warp(x, 1, 2149, 42, 25, 8, name: "Up to the root-keep gate") }
# A27: the rootbeast pens (failed prototypes for Razzy); A28: the prison root-cocoons
cp.event(10, 17, "Rootbeasts", [{ graphic: "Followers/MAMOSWINE", direction: 8, script: "FT.rootbeast_pens(@event_id)" }])
cp.event(13, 16, "Cage", [{ tile_id: 809, script: "FT.talk(:rootbeast_cage, @event_id)" }])
[[8, 13], [16, 13], [20, 12]].each_with_index { |(x, y), i| cp.event(x, y, "Prison pod #{i + 1}", [{ tile_id: 808, script: "FT.prison_pod(#{i + 1}, @event_id)" }]) }
cp.cutscene(3, 4, :cocoon_pens)
[6, 9, 12, 15, 18].each { |x| cp.event(x, 4, "Cocoon", [{ tile_id: 809, script: "FT.talk(:cocoon_plate, @event_id)" }]) }
cp.event(21, 4, "Cocoon V-7", [{ tile_id: 808, script: "FT.talk(:cocoon_v7, @event_id)" }])
cp.event(12, 9, "Journal", [{ tile_id: 581, script: "FT.talk(:pens_journal, @event_id)" }])
cp.event(23, 7, "Last cocoon", [
  { tile_id: 808, script: "FT.selrae_cocoon(@event_id)" },
  { switch: SW_SELRAE_PEN, graphic: "BWOldWoman", direction: 2, opacity: 170, step_anime: false, script: "FT.selrae_cocoon(@event_id)" }
])
cp.event(5, 14, "Shelf", [{ tile_id: 581, script: "FT.garagai_shelf(@event_id)" }])
[22, 23, 24].each { |x| cp.warp(x, 18, 2150, 5, 4, 2, name: "Down into the Dragonforge's upper works") }
save(cp, :hag_pens)

# ---------------------------------------------------------------------------
# 2075: the Dragonforge. A bridge over the sap pit (where Autumn falls), then
# the cavern of the Twenty Stones with the chained dragon at its heart, and the
# black-glass stair up to the Heart Chamber behind the devil-priest.
df = cave_map(40, 30)
paint(df, [0, 13, 6, 3], [16, 4, 21, 23])
cave_bridge_h(df, 6, 15, 14)                                    # over the boiling sap
[13, 14, 15].each { |y| df.warp(0, y, 2150, 13, 27, 8, name: "Back up to the root-keep gate") }
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
  { switch: SW_FORGE_CLEARED, graphic: "BW (40)", direction: 4, script: "FT.devil_priest(@event_id)" },
  { self_switch: "B", graphic: "", through: true }                # (fled, outnumbered: 034_Chapter8.rb)
])
[25, 26, 27].each do |x|
  df.event(x, 4, "Black-glass stair", [
    { trigger: 1, script: "FT.talk(:forge_stair_shut, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])" },
    { switch: SW_FORGE_CLEARED, trigger: 1, through: true, commands: [df.send(:command, 201, [0, 2152, 21, 29, 8, 0])] }
  ])
end
save(df, :dragonforge)

# ---------------------------------------------------------------------------
# 2076: the Heart Chamber (H23): an enormous cavern of glowing roots round a
# pool of silver sap. The engine hangs over the pool; Var at the controls.
# Twelve root-spires ring the pool (H24, the Breaking Circle). In from the
# Auroral Antechapel on the west; the fight starts when you walk in.
SW_CIRCLE_PHASE = 4095
hc = cave_map(32, 24)
hfloor = {}
Builder.rect_cells(3, 3, 26, 18).each { |c| hfloor[c] = true }
Builder.rect_cells(13, 9, 6, 5).each { |c| hfloor.delete(c) }        # the pool of silver sap
cave_paint(hc, hfloor)
[11, 12, 13].each { |y| hc.warp(3, y, 2153, 41, 14, 4, name: "Back to the Antechapel") }
# the engine: the Sealed Chamber's great machine, hanging over the pool (6x6 tiles, layer 2)
(0..5).each { |dy| (0..5).each { |dx| hc.set(13 + dx, 3 + dy, 2, 704 + dy * 8 + dx) } }
hc.event(15, 14, "The engine", [{ tile_id: 809, script: "FT.talk(:engine_dead, @event_id)" }])
[[11, 7], [20, 7], [21, 9], [22, 11], [21, 13], [19, 15], [17, 16], [14, 16], [12, 15], [10, 13], [9, 11], [10, 9]].each_with_index do |(x, y), i|
  hc.event(x, y, "Root-spire #{i + 1}", [{ tile_id: 792, script: "FT.breaking_spire(#{i + 1}, @event_id)" }])
end
hc.event(16, 18, "Var Rime-Breaker", [
  { graphic: "FT_var", direction: 8 },
  { switch: SW_CIRCLE_PHASE, graphic: "FT_var_cracked", direction: 4, script: "FT.avarice_phase_two(@event_id)" },
  { switch: SW_ENGINE_DEAD, graphic: "", through: true }
])
hc.event(0, 0, "Heart chamber", [
  { trigger: 3, script: "FT.scene_heart_chamber" },
  { switch: SW_CIRCLE_PHASE },
  { switch: SW_ENGINE_DEAD }
])
save(hc, :heart_chamber)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT}"
