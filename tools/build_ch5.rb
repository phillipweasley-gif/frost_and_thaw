# Builds every map for Act I, Chapter 5 (the Cackling Chasm, after the
# campaign's "The Cackling Chasm" adventure and "Frost Hag" encounter): the
# Laughing Waste south of Dougan's Hole, the chasm's upper caves (the laughing
# entrance, the frozen feast hall, the hall of illusions), the pit, the frozen
# rift and the Guardian's Gate, the hidden sanctum, and the Heart of the Chasm.
require_relative "ft_common"
require_relative "cavekit"

ID = { waste: 2041, upper_caves: 2042, pit: 2043, rift: 2044, sanctum: 2045, heart: 2046, rift_floor: 2100 }
NAMES = {
  waste: "The Laughing Waste", upper_caves: "The Cackling Chasm", pit: "The Pit",
  rift: "The Frozen Rift", sanctum: "Hidden Sanctum", heart: "The Heart of the Chasm", rift_floor: "The Rift Floor"
}
MUSIC = {
  waste: "wind", upper_caves: "scary_ambient", pit: "scary_ambient", rift: "strongWind",
  sanctum: "sealed_chamber", heart: "Entrance of the Forbidden Gate [Pokemon B2-W2 Remix]", rift_floor: "scary_ambient"
}
DOUGANS = 2035
SW_HAG_DOWN    = 3922    # Chapter 4 done: the way south of Dougan's Hole opens
SW_ICEFALL     = 3927    # the icefall and the mephits at the entrance are done
SW_YETI_DOWN   = 3928    # the mother yeti has been faced
SW_PIT_DONE    = 3929    # the ghouls in the pit are beaten
SW_GATE_OPEN   = 3930    # the Guardian's Gate stands open
SW_GHOST_REST  = 3931    # Alberica's ghost has spoken and gone to her rest
SW_REVERSAL    = 3932    # the Verdant Reversal: Act I is over
SW_WALKER_DOWN = 4002    # the coldlight walker on the far ledge is laid to rest (044_ChasmFaithful.rb)
SW_MOTHER_DEAD = 4003    # the mother yeti fought to the death over her mate
SW_CODEX_TAKEN = 4004    # the Druidic Codex is off the sanctum shelf
SW_RIFT_GNOLL  = 4005    # the gnoll ghost on the rift floor is quiet
WOLF = "Followers/ABSOL"

def save(b, key) = save_map(b, ID[key], MUSIC[key])

# A one-time touch trigger across several cells (all share one flag in the scripts).
def trigger_row(b, cells, script, name, switch: nil)
  cells.each do |x, y|
    pages = [{ trigger: 1, through: true, script: script }]
    pages = [{ through: true }, { switch: switch, trigger: 1, through: true, script: script }] if switch
    b.event(x, y, name, pages)
  end
end

def tall_crystal(b, x, y, color = :blue)
  top, bottom = color == :blue ? [800, 808] : [801, 809]
  b.set(x, y - 1, 2, top); b.set(x, y, 2, bottom)
end

# ---------------------------------------------------------------------------
# 2041: the Laughing Waste. South of Dougan's Hole: open, broken country where
# the wind carries a cackle, down to a black crack in a hillside.
WW, WH = 30, 48
w = Builder.new(WW, WH)
w.fill(0, SNOW)
wopen = {}
path = ->(y) { (14 + 6 * Math.sin(y / 6.5)).round }
(0...WH).each { |y| c = path.(y); ((c - 6)..(c + 6)).each { |x| wopen[[x, y]] = true if x.between?(0, WW - 1) } }
[14, 15].each { |x| (0..2).each { |y| wopen[[x, y]] = true } }
forest_except(w, WW, WH, wopen)
grass(w, path.(8) - 5, 6, 4, 4); grass(w, path.(19) + 1, 17, 5, 4); grass(w, path.(31) - 6, 29, 5, 4); grass(w, path.(38) + 2, 36, 4, 3)
[[path.(12) - 3, 12], [path.(23) + 2, 23], [path.(27) - 4, 27], [path.(34) + 3, 34]].each { |x, y| w.stamp(ICE_BOULDER, x, y) }
[[path.(15) + 4, 15], [path.(40) - 5, 40]].each { |x, y| w.stamp(BOULDER, x, y) }
# the crack in the hillside: a cave mouth flanked by ice
mx = path.(44)
w.stamp(CAVE, mx - 1, 43)                                   # mouth (mx, 45)
[[mx - 3, 43], [mx + 2, 43]].each { |x, y| w.stamp(ICE_BOULDER, x, y) }
w.door(mx, 45, ID[:upper_caves], 16, 36, 8, name: "Door Cackling Chasm")
[14, 15].each { |x| w.warp(x, 0, DOUGANS, x == 14 ? 2 : 3, 44, 8, name: "To Dougan's Hole") }
w.cutscene(14, 1, :waste_start)
w.sign(path.(4) + 2, 4, :sign_waste)
w.trainer(path.(10) + 3, 10, "BW (40)", :aurilite_ten, :FT_AURILITE, dir: 4, sight: 4)
w.trainer(path.(20) - 4, 20, "BW (72)", :hunter_gerd, :HIKER, dir: 6, sight: 3)
w.trainer(path.(29) + 4, 29, "BW030", :ranger_brisa, :POKEMONRANGER_F, dir: 4, sight: 3)
w.trainer(path.(37) - 3, 37, "BW (40)", :channeler_odda, :CHANNELER, dir: 6, sight: 3)
w.npc(path.(24) - 1, 24, "BW (72)", :waste_trapper, dir: 2)
seal_edges(w)
save(w, :waste)

# ---------------------------------------------------------------------------
# 2042: the chasm's upper caves. 1. the laughing entrance (an icefall, ice
# mephits, a frozen locket); 2. the frozen feast hall (a yeti family); 3. the
# hall of illusions, where the way splits: left, a child's voice and a light
# (the pit); right, the sound of an old woman weeping (the true way on).
UW, UH = 34, 40
u = cave_map(UW, UH)
ufl = {}
uc = ->(x0, y0, ww, hh) { Builder.rect_cells(x0, y0, ww, hh).each { |c| ufl[c] = true } }
uc.(15, 29, 4, 10)                                                                   # 1. the entrance tunnel
(9..23).each { |x| (16..28).each { |y| ufl[[x, y]] = true if ((x - 16) / 7.4)**2 + ((y - 22) / 6.4)**2 <= 1 } }  # 2. the feast hall
uc.(15, 9, 3, 8)                                                                     # 3. the glassy corridor
uc.(5, 6, 13, 3)                                                                     #    left: the false light
uc.(3, 4, 5, 6)                                                                      #    ...its dead end
uc.(17, 6, 12, 3)                                                                    #    right: the weeping dark
uc.(26, 1, 3, 6)                                                                     #    ...and on, down to the rift
cave_paint(u, ufl)
[[10, 19], [22, 19], [12, 26], [21, 26], [16, 30], [4, 5]].each { |x, y| tall_crystal(u, x, y) }
[[13, 18], [19, 25], [11, 23]].each { |x, y| u.set(x, y, 2, 792) }                 # frozen bones under the ice
[16, 17].each { |x| u.door(x, 38, ID[:waste], mx, 46, 2, name: "Exit") }
[26, 27, 28].each { |x| u.warp(x, 1, ID[:rift], x == 26 ? 4 : (x == 27 ? 5 : 6), 28, 8, name: "Down to the rift") }
u.cutscene(16, 37, :cackling_enter)
trigger_row(u, [[15, 33], [16, 33], [17, 33], [18, 33]], "FT.chasm_icefall(@event_id)", "Icefall")
trigger_row(u, [[15, 35], [16, 35], [17, 35], [18, 35]], "FT.chasm_whisper(1, @event_id)", "Whisper")
u.event(15, 31, "Fallen ice", [                                                    # a gnoll's femur in the ice
  { graphic: "", through: true },
  { switch: SW_ICEFALL, graphic: "", tile_id: 792, script: "FT.chasm_fallen_ice(@event_id)" }
])
u.event(17, 31, "Something gleaming", [
  { graphic: "", through: true },
  { switch: SW_ICEFALL, graphic: "", tile_id: 792, script: "FT.chasm_locket(@event_id)" },
  { self_switch: "A", graphic: "", through: true }
])
# the feast hall
trigger_row(u, [[15, 29], [16, 29], [17, 29], [18, 29]], "FT.scene_feast_hall_enter", "Feast hall")
u.event(9, 22, "Blood runes", [{ graphic: "", tile_id: 792, script: "FT.blood_runes(@event_id)" }])
u.event(21, 25, "Coins", [
  { graphic: "BWPokeball", direction: 2, script: "FT.chasm_coins(@event_id)" },
  { self_switch: "A", graphic: "", through: true }
])
u.event(12, 25, "Gnoll", [
  { graphic: "", tile_id: 792, script: "FT.gnoll_axe(@event_id)" },
  { self_switch: "A", graphic: "", tile_id: 792, script: "FT.talk(:gnoll_axe_left, @event_id)" }
])
u.event(16, 22, "Dead yeti", [{ graphic: "Followers/YETITAN", direction: 8, opacity: 200, step_anime: false, walk_anime: false,
                                 script: "FT.dead_yeti(@event_id)" }])
u.event(16, 18, "Mother yeti", [
  { graphic: "Followers/YETITAN", direction: 2, script: "FT.mother_yeti(@event_id)" },
  { switch: SW_YETI_DOWN, graphic: "Followers/YETITAN", direction: 2, step_anime: false, walk_anime: false,
    script: "FT.talk(:mother_yeti_after, @event_id)" },
  { switch: SW_MOTHER_DEAD, graphic: "", through: true }      # she lies over her mate now (the dead yeti's lines)
])
trigger_row(u, (12..20).map { |x| [x, 24] }, "FT.yeti_notice(@event_id)", "Yeti wakes")
u.event(11, 21, "Bone pile", [{ graphic: "", tile_id: 792, script: "FT.bone_pile(@event_id)" }])
u.event(21, 22, "Backpack", [
  { graphic: "BWPokeball", direction: 2, script: "FT.chasm_backpack(@event_id)" },
  { self_switch: "A", graphic: "", through: true }
])
# the fork
trigger_row(u, [[15, 12], [16, 12], [17, 12]], "FT.chasm_whisper(2, @event_id)", "Whisper")
trigger_row(u, [[15, 9], [16, 9], [17, 9]], "FT.scene(:illusion_fork, @event_id)", "Fork")
trigger_row(u, [[5, 6], [5, 7], [5, 8]], "FT.pit_trap(@event_id)", "Pit trap")
u.event(4, 7, "False light", [
  { graphic: "Followers/CHINGLING", direction: 4, opacity: 140, step_anime: true, through: true },
  { switch: SW_PIT_DONE, graphic: "", through: true }
])
trigger_row(u, [[22, 6], [22, 7], [22, 8]], "FT.scene(:weeping_dark, @event_id)", "Weeping")
save(u, :upper_caves)

# 2043: the pit under the false light
pt = cave_map(14, 12)
pfl = {}
Builder.rect_cells(3, 3, 8, 6).each { |c| pfl[c] = true }
cave_paint(pt, pfl)
pt.set(4, 4, 2, 792); pt.set(9, 7, 2, 792)
pt.event(6, 6, "Pit bottom", [{ trigger: 3, script: "FT.pit_bottom(@event_id)" }, { self_switch: "A" }])
pt.sign(3, 3, :pit_message)
pt.event(9, 4, "Pouch", [
  { graphic: "BWPokeball", direction: 2, script: "FT.pit_pouch(@event_id)" },
  { self_switch: "A", graphic: "", through: true }
])
pt.event(7, 2, "Rope", [{ graphic: "", through: false, script: "FT.pit_climb(@event_id)" }])   # on the wall, read facing it
save(pt, :pit)

# ---------------------------------------------------------------------------
# 2044: the frozen rift and the Guardian's Gate. A ledge, a long bridge over
# the abyss, the far side (a sheltered nook out of the wind), and the sealed
# door of the Order of Life and Death. Beside it, a hollow-sounding wall.
RW, RH = 40, 34
r = cave_map(RW, RH)
rfl = {}
rc = ->(x0, y0, ww, hh) { Builder.rect_cells(x0, y0, ww, hh).each { |c| rfl[c] = true } }
rc.(2, 18, 8, 11)          # the near ledge
rc.(4, 28, 3, 5)           # ...from the upper caves
rc.(25, 14, 13, 16)        # the far ledge
rc.(29, 5, 5, 9)           # the passage to the gate
rc.(30, 1, 3, 4)           # beyond the gate
cave_paint(r, rfl)
cave_bridge_h(r, 9, 25, 22)
[[3, 20], [8, 27], [27, 16], [36, 18], [36, 28], [26, 28]].each { |x, y| tall_crystal(r, x, y) }
[4, 5, 6].each { |x| r.warp(x, 32, ID[:upper_caves], 27, 2, 2, name: "Up to the caves") }
r.cutscene(5, 28, :rift_arrive)
trigger_row(r, [[4, 26], [5, 26], [6, 26]], "FT.chasm_whisper(3, @event_id)", "Whisper")   # (ahead of you as you arrive at y 28)
trigger_row(r, [[10, 22], [10, 23]], "FT.scene_rift_walker_wakes", "Walker wakes")
trigger_row(r, [[13, 22], [13, 23]], "FT.bridge_crack(@event_id)", "Bridge")
trigger_row(r, [[16, 22], [16, 23]], "FT.bridge_slip(@event_id)", "Slip")
trigger_row(r, [[19, 22], [19, 23]], "FT.bridge_gust(@event_id)", "Gust")
trigger_row(r, [[22, 22], [22, 23]], "FT.rift_voices(@event_id)", "Voices")
# the coldlight walker: a frozen wanderer on the far ledge, lamps for eyes (optional)
r.event(36, 15, "Coldlight walker", [
  { graphic: "BWMan1", direction: 4, opacity: 170, step_anime: false, script: "FT.coldlight_walker(@event_id)" },
  { switch: SW_WALKER_DOWN, graphic: "", tile_id: 792, script: "FT.coldlight_walker(@event_id)" }
])
r.event(35, 27, "Campfire", [{ graphic: "", tile_id: 582, script: "FT.chasm_camp(@event_id)" }])
# the Guardian's Gate (three slabs of carved granite) and its offering bowls
[30, 31, 32].each do |x|
  r.event(x, 4, "Guardian's Gate", [
    { graphic: "", tile_id: x == 31 ? 475 : (x == 30 ? 474 : 477), script: "FT.guardian_gate(@event_id)" },
    { switch: SW_GATE_OPEN, graphic: "", through: true }
  ])
end
r.sign(29, 6, :gate_arch)
r.event(34, 8, "Hollow wall", [{ graphic: "", through: false, script: "FT.hollow_wall(@event_id)" }])
r.door(31, 1, ID[:heart], 12, 46, 8, name: "Door Heart")
save(r, :rift)

# 2045: the hidden sanctum: a bier under silver lichen, and the last guardian
sa = cave_map(13, 11)
sfl = {}
Builder.rect_cells(3, 2, 7, 7).each { |c| sfl[c] = true }
cave_paint(sa, sfl)
[[3, 3], [9, 3], [3, 8], [9, 8]].each { |x, y| sa.set(x, y, 2, 792) }
sa.event(6, 4, "Bier", [          # the corpse on the bier; her spirit steps out of it in the scene
  { graphic: "", tile_id: 474, script: "FT.order_ghost(@event_id)" },
  { switch: SW_GHOST_REST, graphic: "", tile_id: 474, script: "FT.talk(:bier_after, @event_id)" }
])
sa.event(8, 3, "Codex shelf", [    # the Druidic Codex, behind the bier
  { graphic: "", tile_id: 792, script: "FT.codex_shelf(@event_id)" },
  { switch: SW_CODEX_TAKEN, graphic: "", tile_id: 792, script: "FT.codex_shelf(@event_id)" }
])
[5, 6, 7].each { |x| sa.door(x, 8, ID[:rift], 33, 8, 4, name: "Exit") }
save(sa, :sanctum)

# ---------------------------------------------------------------------------
# 2046: the Heart of the Chasm (the old altar cavern): a raised dais, purple
# ice pillars, and on the dais a crystal of blood-red ice that beats.
hb, _ex = Builder.from_existing(324)
hb.map.events.clear
[[5, 4], [5, 5]].each { |x, y| hb.set(x, y, 2, 0) }    # the old ladder in the corner
hb.door(12, 47, ID[:rift], 31, 2, 2, name: "Exit")
hb.cutscene(12, 46, :heart_enter)
trigger_row(hb, (10..14).map { |x| [x, 40] }, "FT.chasm_whisper(4, @event_id)", "Whisper")
hb.event(10, 7, "Cauldron", [          # the hag's ritual brew, over blue flames
  { graphic: "BARREL", direction: 2, script: "FT.talk(:heart_cauldron, @event_id)" },
  { switch: SW_REVERSAL, graphic: "BARREL", direction: 2, script: "FT.talk(:heart_cauldron_after, @event_id)" }
])
hb.event(12, 5, "Heart of the Chasm", [
  { graphic: "", tile_id: 809, script: "FT.talk(:heart_crystal, @event_id)" },
  { switch: SW_REVERSAL, graphic: "", tile_id: 808, script: "FT.heart_gateway(@event_id)" }
])
hb.event(13, 7, "Yeti cub", [
  { graphic: "Followers/YETOT", direction: 2, step_anime: true, script: "FT.talk(:yeti_cub_chained, @event_id)" },
  { switch: SW_REVERSAL, graphic: "", through: true }
])
hb.event(11, 6, "Thredra", [
  { graphic: "FT_thredra", direction: 2, script: "FT.thredra(@event_id)" },
  { switch: SW_REVERSAL, graphic: "", through: true }
])
hb.event(10, 10, "Kanan", [
  { graphic: WOLF, direction: 2, script: "FT.thredra(@event_id)" },
  { switch: SW_REVERSAL, graphic: "", through: true }
])
hb.event(14, 10, "Ice troll", [
  { graphic: "Followers/MACHAMP", direction: 2, script: "FT.thredra(@event_id)" },
  { switch: SW_REVERSAL, graphic: "", through: true }
])
# her mirrors, all around the cavern
[[4, 9], [20, 9], [9, 16], [16, 21], [4, 14], [20, 13], [12, 12]].each_with_index do |(x, y), i|
  hb.event(x, y, "Mirror #{i + 1}", [
    { graphic: "FT_thredra_echo", direction: 2, opacity: 190, step_anime: true, script: "FT.talk(:heart_mirror, @event_id)" },
    { switch: SW_REVERSAL, graphic: "", through: true }
  ])
end
trigger_row(hb, (9..15).map { |x| [x, 13] }, "FT.thredra(@event_id)", "Confrontation")
save(hb, :heart)

# ---------------------------------------------------------------------------
# 2100: the rift floor, eighty feet under the bridge: a slope of ice and broken
# stone where the gnolls of Yeenoghu ended, and where you land if you fall.
# An ice chute up the far wall climbs back to the near ledge.
fl = cave_map(30, 18)
ffl = {}
Builder.rect_cells(4, 3, 22, 12).each { |c| ffl[c] = true }
Builder.rect_cells(22, 1, 3, 3).each { |c| ffl[c] = true }        # the chute's foot
cave_paint(fl, ffl)
[[6, 4], [24, 12], [5, 13], [18, 4]].each { |x, y| tall_crystal(fl, x, y) }
[[7, 9], [8, 11], [10, 10], [12, 12], [20, 9], [21, 11]].each { |x, y| fl.set(x, y, 2, 792) }   # gnoll bones
fl.cutscene(14, 7, :rift_floor_arrive)
fl.event(9, 10, "Gnoll remains", [
  { graphic: "", tile_id: 792, script: "FT.gnoll_remains(@event_id)" },
  { switch: SW_RIFT_GNOLL, graphic: "", tile_id: 792, script: "FT.talk(:gnoll_quiet, @event_id)" }
])
fl.event(5, 6, "Wisps", [{ graphic: "Followers/LITWICK", direction: 2, opacity: 140, step_anime: true, through: true,
                           script: "FT.talk(:rift_wisp_light, @event_id)" }])
fl.event(23, 1, "Ice chute", [{ graphic: "", tile_id: 809, through: false, script: "FT.rift_floor_climb(@event_id)" }])
save(fl, :rift_floor)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT}"
