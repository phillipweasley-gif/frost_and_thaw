# Builds the Ten-Towns maps of Rime of the Frostmaiden's first chapter that Act I
# was missing (maps 2120-2139), and makes the small changes they need to maps
# built earlier in build_all.sh (run it last, after every other builder):
#
#   2124 the Velryn house (Targos)            "Mountain Climb"
#   2125 the open tundra, the Dwarven Valley  "Mountain Climb", "Foaming Mugs"
#   2126 Kelvin's Cairn, 2127 its heights, 2128 the yeti cave
#   2039 the western tundra and 2040 Garagai's ice lodge, rebuilt after map 1.8
#        ("Holed Up": three east openings, the bedroll room, the wolves at L1)
#   ...and further sections below for Lonelywood, Good Mead and Termalaine.
require_relative "ft_common"
require_relative "cavekit"

ID = {
  termalaine: 2120, termalaine_path: 2121, blue_clam: 2122, eastside: 2123, velryn: 2124,
  open_tundra: 2125, cairn: 2126, cairn_heights: 2127, yeti_cave: 2128,
  lonely_woods: 2129, elven_tomb: 2130, elven_barrow: 2131, gm_woods: 2132, verbeeg_lair: 2133,
  gem_mine: 2135, gem_mine_deep: 2136, ramshackle: 2137
}
NAMES = {
  termalaine: "Termalaine", termalaine_path: "Termalaine Path", blue_clam: "The Blue Clam", eastside: "The Eastside",
  velryn: "Velryn House", open_tundra: "Open Tundra", cairn: "Kelvin's Cairn", cairn_heights: "Kelvin's Cairn Heights",
  yeti_cave: "Yeti Cave", lonely_woods: "Lonelywood Forest", elven_tomb: "The Elven Tomb", elven_barrow: "The Elven Barrow",
  gm_woods: "Good Mead Woods", verbeeg_lair: "Verbeeg Lair", gem_mine: "Termalaine Gem Mine",
  gem_mine_deep: "Termalaine Gem Mine (Deep)", ramshackle: "Ramshackle"
}
MUSIC = {
  termalaine: "lake of rage", termalaine_path: "route38_39", blue_clam: "Lostlorn Forest", eastside: "mom_theme",
  velryn: "mom_theme", open_tundra: "strongWind", cairn: "Reversal Mountain (White 2)", cairn_heights: "strongWind",
  yeti_cave: "Seafoam Islands Music", lonely_woods: "Lostlorn Forest", elven_tomb: "sinjoh", elven_barrow: "newmoonIsland",
  gm_woods: "Lostlorn Forest", verbeeg_lair: "Seafoam Islands Music", gem_mine: "Seafoam Islands Music",
  gem_mine_deep: "Seafoam Islands Music", ramshackle: "Lavender Town"
}
TARGOS = 2001
BRYN = 2012
BRYN_ROAD = 2010
DOG = "Followers/MIGHTYENA"
GOBLIN = "Followers/SNEASEL"
BEAR = "Followers/BEARTIC"
YETI = "Followers/URSARING"
TYKE = "Followers/TEDDIURSA"
GOAT = "Followers/TAUROS"
CAT = "Followers/PERSIAN"

# switches (045_*.rb)
SW_MC_BOY_TAKEN = 4043; SW_MC_TAKEN = 4044; SW_MC_GARRET = 4045; SW_MC_PERILOU = 4046; SW_MC_DONE = 4047
SW_MC_DOGS_FREE = 4048; SW_MC_FATHER_GONE = 4052; SW_MC_ICE_BROKEN = 4058; SW_MC_GARRET_HOME = 4054; SW_MC_PERILOU_HOME = 4055
SW_FM_DWARVES = 4049; SW_FM_SLED = 4050; SW_FM_DONE = 4051; SW_FM_TAKEN = 4057
SW_HU_WOLVES_WAIT = 4041; SW_HU_BLIZZARD = 4042
SW_KIDS_FREED = 3919; SW_NORSU_CALM = 3923; SW_PACK_GONE = 3924; SW_KOBOLDS_GONE = 3925; SW_WOLVES_GONE = 3926

def save(b, key) = save_map(b, ID[key], MUSIC[key])

def stamp_pine(b, x, y) = tree(b, x, y, 2)

# A rectangle of open cells for forest_except.
def carve_into(open, x0, y0, w, h)
  (y0...y0 + h).each { |y| (x0...x0 + w).each { |x| open[[x, y]] = true } }
end

# An event shown only while switch `on` is on and switch `off` isn't (nil: no condition).
def shown_between(b, x, y, name, graphic, script, on: nil, off: nil, dir: 2, move: 0, step: false)
  pages = []
  pages << { graphic: "", through: true } if on
  pages << { switch: on, graphic: graphic, direction: dir, move_type: move, step_anime: step, script: script }.compact
  pages[0] = { graphic: graphic, direction: dir, move_type: move, step_anime: step, script: script } if !on
  pages << { switch: off, graphic: "", through: true } if off
  b.event(x, y, name, pages)
end

# ===========================================================================
# 2124: the Velryn house in Targos (Keegan and Garret)
v, ex = Builder.from_existing(644)
exits_to(v, ex, TARGOS, 41, 35)
v.event(13, 7, "Keegan", [{ graphic: "BW (54)", direction: 4, script: "FT.climb_homecoming(@event_id)" }])
v.event(1, 1, "Cutscene velryn_arrival", [
  {},
  { switch: SW_MC_BOY_TAKEN, trigger: 3, script: "FT.scene(:velryn_arrival, @event_id)" },
  { self_switch: "A" }
])
npc_when(v, 11, 6, "BWHiker", :garret_home, SW_MC_GARRET_HOME, dir: 2, name: "Garret")
npc_when(v, 7, 8, "BW (16)", :perilou_home, SW_MC_PERILOU_HOME, dir: 6, name: "Perilou")
npc_when(v, 12, 9, DOG, :boy_home, SW_MC_GARRET_HOME, dir: 4, name: "Boy")
v.sign(7, 5, :velryn_scrimshaw)
save(v, :velryn)

# ===========================================================================
# 2125: the open tundra east of the Bryn Shander road. Kelvin's Cairn in the
# north-east; the Dwarven Valley's tunnels in the north; Oobok's gully in the
# middle; the goblins' wagon to the south. A blizzard comes down on the way.
TW, TH = 60, 40
t = Builder.new(TW, TH)
t.fill(0, SNOW)
topen = {}
carve_into(topen, 0, 19, 8, 4)          # in from the Bryn Shander road
carve_into(topen, 5, 9, 50, 26)         # the open white
carve_into(topen, 18, 2, 18, 9)         # the Dwarven Valley
carve_into(topen, 46, 2, 10, 9)         # up toward the mountain
carve_into(topen, 54, 2, 6, 4)          # out, north-east
carve_into(topen, 30, 30, 18, 8)        # the goblins' hollow
forest_except(t, TW, TH, topen)
grass(t, 10, 12, 6, 5); grass(t, 14, 26, 7, 4); grass(t, 36, 12, 6, 4); grass(t, 48, 20, 5, 6); grass(t, 24, 18, 4, 4)
[[12, 22], [22, 28], [44, 14], [50, 28], [34, 22]].each { |x, y| t.stamp(ICE_BOULDER, x, y) }
[[28, 12], [40, 24], [20, 15]].each { |x, y| t.stamp(BOULDER, x, y) }
[[16, 10], [42, 30], [52, 16]].each { |x, y| stamp_pine(t, x, y) }
# the Dwarven Valley: tunnels into the slope, a sentry at the warm one
[[20, 2], [26, 2], [31, 3]].each { |x, y| t.stamp(CAVE, x, y) }   # mouths (21,4) (27,4) (32,5)
t.event(27, 6, "Dwarf sentry", [{ graphic: "BW (72)", direction: 2, script: "FT.dwarven_valley_rest(@event_id)" }])
t.sign(24, 8, :dwarven_valley)
# Oobok's remains in the gully
t.set(30, 24, 2, CRATE)
t.event(30, 24, "Oobok", [{ graphic: "", script: "FT.oobok_remains(@event_id)" }])
# the goblins, the sled, the wagon and the bears (once the dwarves have asked)
t.stamp(HUT, 40, 31)                                                 # the wagon on its runners
[[34, 34], [35, 34], [36, 34]].each { |x, y| t.set(x, y, 2, CRATE) } # the sled of iron
[[33, 33], [37, 33], [33, 35], [37, 35], [35, 33], [35, 35]].each_with_index do |(x, y), i|
  b_ = t.event(x, y, "Goblin #{i + 1}", [
    { graphic: "", through: true },
    { switch: SW_FM_TAKEN, graphic: GOBLIN, direction: i.even? ? 6 : 4, script: "FT.goblin_sled(@event_id)" },
    { switch: SW_FM_SLED, graphic: "", through: true }
  ])
end
[[45, 33], [45, 34]].each_with_index do |(x, y), i|
  t.event(x, y, "Polar bear", [
    { graphic: "", through: true },
    { switch: SW_FM_TAKEN, graphic: BEAR, direction: 6, step_anime: true, script: "FT.talk(:goblin_wagon, @event_id)" },
    { switch: SW_FM_SLED, graphic: "", through: true }
  ])
end
t.event(42, 30, "Izobai", [
  { graphic: "", through: true },
  { switch: SW_FM_TAKEN, graphic: GOBLIN, direction: 2, script: "FT.goblin_sled(@event_id)" },
  { switch: SW_FM_SLED, graphic: "", through: true }
])
# the blizzard comes down a couple of miles short of the sled
(24..33).each { |y| t.event(26, y, "Blizzard", [{ trigger: 1, through: true, script: "FT.mugs_blizzard(@event_id)" }]) }
[20, 21].each { |y| t.warp(0, y, BRYN_ROAD, 32, y == 20 ? 14 : 15, 4, name: "To the Bryn Shander Road") }
[3, 4].each { |y| t.warp(TW - 1, y, ID[:cairn], y == 3 ? 19 : 20, 54, 8, name: "To Kelvin's Cairn") }
t.cutscene(2, 20, :open_tundra_enter)
t.sign(52, 6, :sign_kelvins_cairn)
t.trainer(16, 18, "BW (75)", :tundra_runner, :WORKER, dir: 6, sight: 4)
t.trainer(38, 18, "BW (40)", :tundra_aurilite, :FT_AURILITE, dir: 4, sight: 4)
seal_edges(t)
save(t, :open_tundra)

# ===========================================================================
# 2126: Kelvin's Cairn, the lower slopes. Base camp at the foot; mountain
# goats on a big rock; the wide white expanse where the avalanche comes down;
# Garret, face down near the top.
CW, CH = 40, 56
c = Builder.new(CW, CH)
c.fill(0, SNOW)
copen = {}
carve_into(copen, 16, 46, 8, 10)        # in from the tundra (bottom)
carve_into(copen, 8, 38, 24, 10)        # base camp
carve_into(copen, 26, 28, 8, 12)        # the climb east
carve_into(copen, 6, 16, 28, 14)        # the white expanse
carve_into(copen, 6, 6, 10, 12)         # up the west side
carve_into(copen, 10, 4, 22, 6)         # the fallen climber's slope
carve_into(copen, 18, 0, 6, 6)          # on up (top)
forest_except(c, CW, CH, copen)
c.stamp(ROUND_HUT, 10, 39); c.stamp(HUT, 22, 39)                    # two tents
[[17, 43], [18, 43], [19, 43]].each { |x, y| c.set(x, y, 2, CRATE) } # the overturned sled
c.event(18, 43, "Crates", [{ graphic: "", script: "FT.cairn_crates(@event_id)" }])
[[16, 44], [20, 44], [16, 45], [20, 45], [17, 46]].each_with_index do |(x, y), i|
  c.event(x, y, "Sled dog #{i + 1}", [
    { graphic: DOG, direction: 2, step_anime: true, script: "FT.sled_dogs(@event_id)" },
    { switch: SW_MC_DOGS_FREE, graphic: "", through: true }
  ])
end
c.sign(14, 46, :cairn_base_camp)
# goats on their rock
c.stamp(BOULDER, 28, 32); c.stamp(BOULDER, 30, 33)
c.event(29, 31, "Mountain goats", [
  { graphic: GOAT, direction: 2, step_anime: true, script: "FT.mountain_goats(@event_id)" },
  { self_switch: "A", graphic: "", through: true }
])
c.sign(31, 36, :cairn_goats_sign)
# the white expanse: the avalanche comes down as you cross it
(6..33).each { |x| c.event(x, 22, "Avalanche", [{ trigger: 1, through: true, script: "FT.avalanche(@event_id)" }]) }
[[8, 18], [30, 18], [12, 27], [24, 27]].each { |x, y| c.stamp(ICE_BOULDER, x, y) }
grass(c, 9, 8, 5, 6); grass(c, 26, 5, 4, 4); grass(c, 12, 40, 5, 3)
# Garret
c.event(14, 6, "Garret", [
  { graphic: "BWHiker", direction: 8, step_anime: false, walk_anime: false, script: "FT.fallen_climber(@event_id)" },
  { switch: SW_MC_GARRET, graphic: "", through: true }
])
c.trainer(26, 36, "BWHiker", :climber_hask, :HIKER, dir: 4, sight: 4)
c.trainer(9, 12, "BWRanger_female", :climber_vala, :POKEMONRANGER_F, dir: 2, sight: 4)
[19, 20, 21, 22].each { |x| c.warp(x, CH - 1, ID[:open_tundra], TW - 2, x < 21 ? 3 : 4, 4, name: "To the Open Tundra") }
[18, 19, 20, 21, 22, 23].each { |x| c.warp(x, 0, ID[:cairn_heights], x < 21 ? 17 : 18, 42, 8, name: "To the Heights") }
c.cutscene(20, 53, :cairn_enter)
seal_edges(c)
save(c, :cairn)

# ===========================================================================
# 2127: the heights. Three hard pitches of ledge and ice; the cave above the
# blood on the snow; the ruined camp at the edge of the crevasse.
HW, HH = 36, 44
h = Builder.new(HW, HH)
h.fill(0, SNOW)
hopen = {}
carve_into(hopen, 15, 36, 6, 8)         # in from below
carve_into(hopen, 6, 30, 26, 7)         # first ledge
carve_into(hopen, 26, 20, 6, 11)        # east cliff
carve_into(hopen, 8, 18, 24, 4)         # second ledge
carve_into(hopen, 4, 8, 8, 12)          # west chimney
carve_into(hopen, 4, 4, 28, 5)          # the top: the cave and the crevasse
forest_except(h, HW, HH, hopen)
# the climb is all rock and ice up here: no trees inside the path
[[8, 32], [12, 34], [22, 32], [28, 31], [10, 19], [20, 19], [6, 12], [14, 5], [6, 5]].each { |x, y| h.stamp(ICE_BOULDER, x, y) }
[[18, 30], [24, 34]].each { |x, y| h.stamp(BOULDER, x, y) }
# the three pitches: step on them and you have to choose your line
[26, 27, 28, 29, 30, 31].each { |x| h.event(x, 28, "Pitch 1", [{ trigger: 1, through: true, script: "FT.climb_pitch(1, @event_id)" }]) }
[4, 5, 6, 7, 8, 9, 10, 11].each { |x| h.event(x, 17, "Pitch 2", [{ trigger: 1, through: true, script: "FT.climb_pitch(2, @event_id)" }]) }
[4, 5, 6, 7, 8, 9, 10, 11].each { |x| h.event(x, 9, "Pitch 3", [{ trigger: 1, through: true, script: "FT.climb_pitch(3, @event_id)" }]) }
# the cave
h.stamp(CAVE, 23, 2)                                                 # mouth (24, 4)
h.door(24, 4, ID[:yeti_cave], 15, 22, 8, name: "Yeti Cave")
h.sign(21, 6, :yeti_blood)
# the ruined camp at the crevasse (west end of the top)
(4..13).each { |x| h.set(x, 4, 2, EDGE_ROCK) }
h.stamp(HUT, 7, 4)
h.event(12, 7, "Astrix", [
  { graphic: "BW (33)", direction: 4, step_anime: false, walk_anime: false, opacity: 220, script: "FT.astrix(@event_id)" }
])
h.event(10, 7, "Blue boots", [{ graphic: "", script: "FT.blue_boots(@event_id)" }])
h.sign(5, 8, :cairn_crevasse)
h.sign(9, 8, :cairn_tent)
[15, 16, 17, 18, 19, 20].each { |x| h.warp(x, HH - 1, ID[:cairn], x < 18 ? 20 : 21, 1, 2, name: "Down the mountain") }
seal_edges(h)
save(h, :cairn_heights)

# ===========================================================================
# 2128: the yeti cave. F1 the chasm (a ledge, a stone bridge west to F2, and a
# sheet of ice over the south of it straight to F3); F2 the trophies; F3 the den.
y_ = cave_map(30, 24)
yfl = {}
carve_into(yfl, 13, 12, 5, 11)          # F1: the ledge inside the mouth
yfl[[15, 23]] = true                    #     and the way out
carve_into(yfl, 3, 4, 8, 14)            # F2: the trophy tunnel (west)
carve_into(yfl, 18, 4, 9, 8)            # F3: the den (north-east, raised)
carve_into(yfl, 11, 4, 7, 3)            # F2 -> F3 passage
carve_into(yfl, 18, 12, 3, 6)           # the ice sheet, straight from F1 to F3
cave_paint(y_, yfl)
cave_bridge_h(y_, 11, 12, 14)           # the natural stone bridge F1 -> F2
y_.door(15, 23, ID[:cairn_heights], 24, 5, 2, name: "Exit")
y_.cutscene(15, 21, :yeti_cave_enter)
y_.sign(12, 13, :yeti_bridge)
# the ice sheet: smash it and it's gone (its cells become the chasm)
(18..20).each { |x| (12..17).each { |yy| y_.event(x, yy, "Ice sheet", [{ through: true }, { switch: SW_MC_ICE_BROKEN, tile_id: CAVE_VOID, through: false }]) } }
(13..17).each { |yy| y_.event(17, yy, "Ice sheet edge", [{ trigger: 1, through: true, script: "FT.ice_sheet(@event_id)" }]) }
# the trophy niches: frozen heads in the rock
CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| y_.set(3 + i, 11 + j, 1, tl) } }
y_.event(4, 12, "Trophies", [{ graphic: "", script: "FT.yeti_trophies(@event_id)" }])
# F3: mother, tyke and Perilou
y_.event(24, 6, "Mother yeti", [{ graphic: YETI, direction: 2, step_anime: true, script: "FT.yeti_den(@event_id)" }])
y_.event(22, 7, "Yeti tyke", [{ graphic: TYKE, direction: 4, step_anime: true, script: "FT.yeti_den(@event_id)" }])
y_.event(21, 8, "Perilou", [
  { graphic: "BW (16)", direction: 8, script: "FT.yeti_den(@event_id)" },
  { switch: SW_MC_PERILOU, graphic: "", through: true }
])
CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| y_.set(25 + i, 9 + j, 1, tl) } }
y_.sign(25, 10, :yeti_den_gear)
# the father comes home: he's in the mouth when you come back out with Perilou
(13..17).each do |x|
  y_.event(x, 20, "Father yeti", [
    { through: true },
    { switch: SW_MC_PERILOU, trigger: 1, through: true, script: "FT.father_yeti(@event_id)" },
    { switch: SW_MC_FATHER_GONE, through: true }
  ])
end
save(y_, :yeti_cave)

# (Targos's Velryn house and Boy: build_act1.rb. The Bryn Shander road's way east: build_ch2.rb.)

# ===========================================================================
# "Holed Up": the western tundra (2039) and Garagai's ice lodge (2040), rebuilt
# after map 1.8 of the book. (These replace build_ch4.rb's versions, which run
# first; build_ch4.rb's lodge and tundra sections can go once this is merged.)
DOUGANS = 2035
TUNDRA_W = 2039
LODGE = 2040
WOLF = "Followers/ABSOL"
PUP = "Followers/POOCHYENA"
GAUNT = "Followers/MIGHTYENA"
KOBOLD = "Followers/GIBLE"
ICEWALL = { nw: 395, n: 396, ne: 397, w: 403, c: 404, e: 405, sw: 411, s: 412, se: 413 }

# --- 2039: the western tundra. The lodge's dome at the far west, three tall
# openings on its east face (to L2, L4, L3) and the remorhaz hole on its
# south side (to L8).
TW2, TH2 = 60, 34
w = Builder.new(TW2, TH2)
w.fill(0, SNOW)
wopen = {}
(0...TW2).each { |x| (0...TH2).each { |y| wopen[[x, y]] = true if y >= 4 && y <= TH2 - 4 || ([58, 59].include?(x) && [16, 17].include?(y)) } }
forest_except(w, TW2, TH2, wopen)
dome = []
(3..18).each { |x| (6..24).each { |y| dome << [x, y] if ((x - 10.5) / 8.2)**2 + ((y - 15) / 9.6)**2 <= 1 } }
w.nine_blob(1, ICEWALL, dome)
dome.each { |x, y| if w.get(x, y, 1) == ICEWALL[:c] then w.set(x, y, 1, 0); w.set(x, y, 0, 8426) end }
OPENINGS = { 10 => [38, 5], 15 => [38, 14], 20 => [38, 21] }      # tundra row => lodge arrival
OPENINGS.each_key { |y| w.set(y == 15 ? 18 : 17, y, 1, 0) }        # the three openings on the east face
w.stamp(CAVE, 9, 23)                                                 # the remorhaz hole, mouth (10, 25)
[[26, 8], [34, 22], [44, 9], [50, 24], [22, 26], [39, 14]].each { |x, y| w.stamp(ICE_BOULDER, x, y) }
[[30, 5], [46, 26], [24, 12]].each { |x, y| stamp_pine(w, x, y) }
grass(w, 28, 18, 6, 4); grass(w, 40, 6, 5, 4); grass(w, 47, 18, 5, 4); grass(w, 21, 6, 4, 3)
[16, 17].each { |y| w.warp(TW2 - 1, y, DOUGANS, 1, y == 16 ? 20 : 21, 6, name: "To Dougan's Hole") }
OPENINGS.each do |y, (lx, ly)|
  x = y == 15 ? 18 : 17
  w.door(x, y, LODGE, lx - 1, ly, 4, name: "Door Ice Lodge")
end
w.door(10, 25, LODGE, 17, 27, 8, name: "Door Remorhaz Tunnel")
w.cutscene(57, 16, :tundra_start)
w.sign(21, 9, :lodge_exterior)
# the starving pack, in the middle of the tundra
[[31, 14], [32, 16], [31, 18], [30, 16]].each_with_index do |(x, y), i|
  w.event(x, y, "Starving wolf", [
    { graphic: i == 3 ? GAUNT : PUP, direction: 4, script: "FT.starving_pack(@event_id)" },
    { switch: SW_PACK_GONE, graphic: "", through: true }
  ])
end
# L1: Koran and Kanan, sitting east of the main opening; once the children are
# out, they're the ambush
[[21, 14, "Koran"], [21, 16, "Kanan"]].each do |x, y, n|
  w.event(x, y, n, [
    { graphic: "", through: true },
    { switch: SW_HU_WOLVES_WAIT, graphic: WOLF, direction: 4, script: "FT.talk(:wolves_wait, @event_id)" },
    { switch: SW_KIDS_FREED, graphic: WOLF, direction: 4, script: "FT.wolves_ambush(@event_id)" },
    { switch: SW_WOLVES_GONE, graphic: "", through: true }
  ])
end
# they tell you Garagai isn't home when you come up to the openings
(6..26).each { |y| w.event(23, y, "Lodge approach", [{ trigger: 1, through: true, script: "FT.scene_lodge_approach_step(@event_id)" }]) }
# coming out of an east opening with the children: they're right there
(6..24).each do |y|
  w.event(20, y, "L1 ambush", [
    { through: true },
    { switch: SW_KIDS_FREED, trigger: 1, through: true, script: "FT.lodge_east_exit(@event_id)" },
    { switch: SW_WOLVES_GONE, through: true }
  ])
end
# on the way home (out of the remorhaz tunnel, they have to find you first)
(4..30).each do |y|
  w.event(26, y, "Ambush", [
    { through: true },
    { switch: SW_KIDS_FREED, trigger: 1, through: true, script: "FT.wolves_ambush(@event_id)" },
    { switch: SW_WOLVES_GONE, through: true }
  ])
end
w.trainer(42, 12, "BW (40)", :aurilite_nine, :FT_AURILITE, dir: 4, sight: 4)
w.trainer(46, 21, "BW (72)", :hunter_ulf, :HIKER, dir: 4, sight: 3)
w.sign(55, 15, :sign_tundra)
seal_edges(w)
save_map(w, TUNDRA_W, "strongWind")

# --- 2040: Garagai's ice lodge (map 1.8). Everything built for giants.
#   L2 flensing chamber (north-east), L4 the icicle corridor (east), L3 the
#   cage (south-east): each with its own opening on the east face. L5 the
#   oval tomb in the middle, Norsu and the ice throne. L6 the war room (west),
#   L7 Garagai's bedroll (north-west), L8 the whale oil (south), with the
#   remorhaz tunnel out the bottom.
LW2, LH2 = 40, 30
l = Builder.new(LW2, LH2)
l.fill(0, SNOW)
floor = {}
lc = ->(x0, y0, w_, h_) { Builder.rect_cells(x0, y0, w_, h_).each { |c_| floor[c_] = true } }
(13..27).each { |x| (8..20).each { |y| floor[[x, y]] = true if ((x - 20) / 7.6)**2 + ((y - 14) / 6.6)**2 <= 1 } }   # L5 the tomb
lc.(27, 13, 12, 3)            # L4 the entrance corridor (opening at x 38)
lc.(28, 2, 9, 7)              # L2 flensing chamber
lc.(36, 4, 3, 3)              #    its opening (x 38, y 5)
lc.(30, 8, 3, 5)              #    its passage down to the tomb
lc.(29, 18, 8, 7)             # L3 the cage
lc.(36, 20, 3, 3)             #    its opening (x 38, y 21)
lc.(25, 17, 5, 3)             #    its passage up to the tomb
lc.(3, 2, 9, 7)               # L7 Garagai's bedroll
lc.(9, 8, 5, 3)               #    its passage
lc.(3, 17, 9, 8)              # L6 the war room
lc.(11, 18, 5, 3)             #    its passage
lc.(14, 22, 8, 5)             # L8 whale-oil store
lc.(18, 19, 3, 4)             #    its passage up to the tomb
lc.(16, 27, 3, 3)             #    the remorhaz tunnel
wall = []
(0...LW2).each { |x| (0...LH2).each { |y| wall << [x, y] unless floor[[x, y]] } }
l.nine_blob(1, ICEWALL, wall, solid: ->(x, y) { x < 0 || y < 0 || x >= LW2 || y >= LH2 })
INNER = { se: 387, sw: 389, ne: 419, nw: 421 }
SOLID_ICE = 8426
wall.each do |x, y|
  next unless l.get(x, y, 1) == ICEWALL[:c]
  corner = INNER.find { |k, _tl| dx = k.to_s.include?("e") ? 1 : -1; dy = k.to_s.include?("s") ? 1 : -1; floor[[x + dx, y + dy]] }
  l.set(x, y, 1, corner ? corner[1] : 0)
  l.set(x, y, 0, SOLID_ICE) unless corner
end
# nothing on the map's rim may be walkable (the corner pieces are)
wall.each do |x, y|
  next unless x == 0 || y == 0 || x == LW2 - 1 || y == LH2 - 1
  l.set(x, y, 1, 0); l.set(x, y, 0, SOLID_ICE)
end
# icicles in the corridor; ice furniture
[[30, 13], [33, 15], [36, 13]].each { |x, y| l.set(x, y, 2, 476) }
l.stamp(ICE_BOULDER, 6, 20)                                         # the war-room table
[[5, 19], [9, 19], [5, 23], [9, 23]].each { |x, y| l.set(x, y, 2, 477) }   # chipped ice chairs
[[15, 23], [16, 23], [20, 23], [15, 25], [20, 25]].each { |x, y| l.set(x, y, 2, CRATE) }   # barrels of whale oil
[[30, 19], [31, 19], [32, 19], [33, 19], [30, 22], [31, 22], [33, 22]].each { |x, y| l.set(x, y, 2, FENCE_H) }   # the cage's black iron slats
[[30, 20], [30, 21], [33, 20], [33, 21]].each { |x, y| l.set(x, y, 2, FENCE_V) }
# the doors out: three on the east face, and the tunnel
{ 5 => 10, 14 => 15, 21 => 20 }.each { |ly, ty| l.door(38, ly, TUNDRA_W, ty == 15 ? 19 : 18, ty, 6, name: "Exit") }
[16, 17, 18].each { |x| l.door(x, LH2 - 1, TUNDRA_W, 10, 26, 2, name: "Exit tunnel") }
l.cutscene(37, 14, :lodge_enter)
# L4: the icicle corridor
[13, 14, 15].each { |y| l.event(33, y, "Icicles", [{ trigger: 1, through: true, script: "FT.ice_corridor(@event_id)" }]) }
# L5: Garagai in his tomb of ice; Norsu beside him; the throne
l.event(17, 14, "Garagai", [{ graphic: "BW (72)", direction: 2, opacity: 160, blend_type: 2, step_anime: false, walk_anime: false,
                              script: "FT.talk(:garagai_tomb, @event_id)" }])
l.event(19, 12, "Norsu", [
  { graphic: "Followers/MAMOSWINE", direction: 4, script: "FT.norsu(@event_id)" },
  { switch: SW_NORSU_CALM, graphic: "Followers/MAMOSWINE", direction: 4, script: "FT.talk(:norsu_calm, @event_id)" }
])
l.stamp(ICE_BOULDER, 21, 8)                                         # the ice throne on its dais
l.event(22, 9, "Ice throne", [{ graphic: "", script: "FT.ice_throne(@event_id)" }])
(8..20).select { |y| floor[[25, y]] }.each do |y|
  l.event(25, y, "Norsu wakes", [
    { trigger: 1, through: true, script: "FT.norsu_notice(@event_id)" },
    { self_switch: "A", through: true }
  ])
end
# L2: the flensing chamber
l.event(30, 4, "Whale", [{ graphic: "Followers/WAILORD", direction: 2, step_anime: false, walk_anime: false, script: "FT.talk(:flensing_whale, @event_id)" }])
l.sign(33, 3, :flensing_knife)
l.event(29, 7, "Stone chest", [
  { graphic: "", tile_id: CRATE, script: "FT.lodge_chest(@event_id)" },
  { self_switch: "A", graphic: "", tile_id: CRATE, script: "FT.talk(:stone_chest_empty, @event_id)" }
])
# L3: the cage
l.event(31, 20, "Silja", [
  { graphic: "BW (17)", direction: 2, script: "FT.cage(@event_id)" },
  { switch: SW_KIDS_FREED, graphic: "", through: true }
])
l.event(32, 20, "Finn", [
  { graphic: "BW (16)", direction: 2, script: "FT.cage(@event_id)" },
  { switch: SW_KIDS_FREED, graphic: "", through: true }
])
l.event(32, 22, "Cage gate", [
  { graphic: "", tile_id: FENCE_H, through: false, script: "FT.cage(@event_id)" },
  { switch: SW_KIDS_FREED, graphic: "", through: true }
])
# L6: the war room, three kobolds hiding behind the chairs
[[4, 18, "Holgi"], [10, 22, "Snorp"], [4, 24, "Zilbo"]].each do |x, y, n|
  l.event(x, y, n, [
    { graphic: KOBOLD, direction: 2, script: "FT.kobolds(@event_id)" },
    { switch: SW_KOBOLDS_GONE, graphic: "", through: true }
  ])
end
l.sign(8, 19, :chwinga_statuette)
# L7: Garagai's bedroll
l.set(5, 4, 2, 1836); l.set(6, 4, 2, 1836)
l.sign(6, 4, :garagai_bedroll)
# L8: whale oil, and the frosted residue in the remorhaz tunnel
l.event(17, 24, "Whale oil", [{ graphic: "", tile_id: CRATE, script: "FT.whale_oil(@event_id)" }])
l.sign(18, 27, :thrym_residue)
save_map(l, LODGE, "Seafoam Islands Music")

# ===========================================================================
# Termalaine (RotF pp. 93-99). Lonelywood connects only to Termalaine; the way
# north from Bryn Shander's gate is the snowy Termalaine Path (six hours), then
# Termalaine on the shore of Maer Dualdon, then the three-mile Lonelywood Road.
# The gem mine is up a trail into the woods north-east of town.
SW_TM_MINE_OPEN = 4059; SW_TM_SABOTEURS = 4060; SW_TM_RATS = 4061; SW_TM_GREK = 4062
SW_TM_GRELL = 4063; SW_TM_TREX = 4064; SW_TM_KOBOLDS_TOWN = 4065; SW_TM_OARUS_GONE = 4066
LONELY_ROAD = 2020
RAT = "Followers/RATICATE"
KOBOLD_TM = "Followers/GIBLE"
GRELL = "Followers/TANGELA"

# A one-cell prop the player can bump into: a crate on layer 2 (solid), with a
# sign or an object on it.
def prop_sign(b, x, y, key)
  b.set(x, y, 2, CRATE)
  b.sign(x, y, key)
end

# --- 2121: the Termalaine Path. North out of Bryn Shander's gate, six hours on
# foot through drifts and scattered pine, with the lake wind in your face.
PW, PH = 30, 48
p_ = Builder.new(PW, PH)
p_.fill(0, SNOW)
popen = {}
carve_into(popen, 12, 40, 6, 8)          # from Bryn Shander's north gate
carve_into(popen, 6, 30, 18, 11)         # the first drifts
carve_into(popen, 17, 19, 9, 12)         # a long bend east
carve_into(popen, 4, 11, 18, 9)          # the windbreak pines
carve_into(popen, 12, 0, 6, 12)          # on to Termalaine
forest_except(p_, PW, PH, popen)
grass(p_, 8, 32, 6, 5); grass(p_, 16, 35, 6, 4); grass(p_, 19, 22, 5, 6); grass(p_, 6, 13, 6, 4); grass(p_, 15, 14, 5, 4)
p_.stamp(ICE_BOULDER, 20, 31); p_.stamp(BOULDER, 7, 38); p_.stamp(ICE_BOULDER, 10, 16)
[12, 13, 14, 15, 16, 17].each { |x| p_.warp(x, PH - 1, BRYN, x < 15 ? 22 : 23, 2, 2, name: "To Bryn Shander") }
[12, 13, 14, 15, 16, 17].each { |x| p_.warp(x, 0, ID[:termalaine], x < 15 ? 26 : 27, 38, 8, name: "To Termalaine") }
p_.trainer(9, 34, "BWHiker", :path_hiker_dun, :HIKER, dir: 6, sight: 4)
p_.trainer(23, 24, "BW (33)", :path_skier_esk, :BEAUTY, dir: 4, sight: 3)
p_.trainer(6, 12, "BW (107)", :path_aurilite_rho, :FT_AURILITE, dir: 2, sight: 4)
prop_sign(p_, 12, 43, :sign_termalaine_path)
seal_edges(p_)
save(p_, :termalaine_path)

# --- 2120: Termalaine. The lake to the west, its docks and the Blue Clam on
# them; the Eastside's cluster of houses (one building, joined underground) to
# the east; Darmo on his box in the square; the trail north-east to the mine.
TMW, TMH = 50, 40
tshore = ->(y) { (8 + 0.015 * (y - 20)**2).round }
tm = Builder.new(TMW, TMH)
tm.fill(0, SNOW)
tmopen = {}
tlake = []
(0...TMH).each do |y|
  (0...TMW).each do |x|
    if x < tshore.(y)
      tmopen[[x, y]] = true
      tlake << [x, y]
    elsif y >= 6 && y <= 35 && x <= 41
      tmopen[[x, y]] = true
    end
  end
end
carve_into(tmopen, 15, 0, 6, 7)          # north along the shore, to Lonelywood
carve_into(tmopen, 24, 35, 6, 5)         # south, the path to Bryn Shander
(0..8).each { |i| carve_into(tmopen, 38 + (i * 0.6).round, 10 - i, 4, 2) }   # the trail into the woods, north-east
carve_into(tmopen, 41, 3, 5, 3)          # the mine's mouth
forest_except(tm, TMW, TMH, tmopen)
tm.autotile(0, 5, tlake)
# the docks
[[10, 6], [22, 7], [28, 6]].each do |y, len|
  s = tshore.(y)
  (s - len...s).each { |x| tm.set(x, y, 1, PLANK[:c]) }
  tm.set(s - len, y - 1, 1, PLANK[:c]); tm.set(s - len, y + 1, 1, PLANK[:c])
end
tm.stamp(CABIN, 10, 13)       # the Blue Clam, on the docks: door (12, 17)
tm.stamp(HOUSE, 32, 16)       # the Eastside: door (33, 20)
tm.stamp(HUT, 37, 16)         # ...and its other rooms, joined underground
tm.stamp(HUT, 36, 23)
tm.stamp(HOUSE, 19, 8)        # carved houses: wizards, djinn, tigers
tm.stamp(HUT, 25, 9)
tm.stamp(HUT, 15, 27)
tm.stamp(ROUND_HUT, 22, 28)
tm.stamp(CAVE, 42, 1)         # the gem mine: mouth (43, 3)
tm.stamp(HAY, 11, 24); [[10, 20], [11, 20], [11, 31]].each { |x, y| tm.set(x, y, 2, CRATE) }   # nets, barrels, fish drying
[[17, 19], [27, 16], [30, 25], [24, 33], [36, 12]].each { |x, y| tm.stamp(LAMP, x, y) }
tm.door(12, 17, ID[:blue_clam], 5, 11, 8, name: "Door Blue Clam")
tm.door(33, 20, ID[:eastside], 9, 11, 8, name: "Door Eastside")
tm.door(38, 19, ID[:eastside], 9, 11, 8, name: "Door Eastside (east rooms)")      # all one building, underground
tm.door(37, 26, ID[:eastside], 9, 11, 8, name: "Door Eastside (south rooms)")
tm.door(43, 3, ID[:gem_mine], 17, 27, 8, name: "Door Gem Mine")
[[20, 12], [26, 12], [16, 30], [23, 31]].each do |x, y|
  tm.event(x, y, "Door closed", [{ trigger: 1, script: "FT.talk(:tm_house_closed, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])" }])
end
(15..20).each { |x| tm.warp(x, 0, LONELY_ROAD, x < 18 ? 14 : 15, 58, 8, name: "To Lonelywood Road") }
(24..29).each { |x| tm.warp(x, TMH - 1, ID[:termalaine_path], x < 27 ? 14 : 15, 1, 2, name: "To the Termalaine Path") }
tm.cutscene(40, 34, :termalaine_arrival)
# the square
tm.event(24, 23, "Darmo Mazlu", [{ graphic: "BW (17)", direction: 2, step_anime: true, script: "FT.darmo_mazlu(@event_id)" }])
tm.event(14, 19, "Oarus Masthew", [{ graphic: "BW (54)", direction: 6, script: "FT.oarus_masthew(@event_id)" }])
tm.npc(15, 19, "BWOldWoman", :tm_shaelen, dir: 4, name: "Shaelen Masthew")
tm.set(21, 21, 2, CRATE); tm.set(22, 21, 2, CRATE)
tm.event(21, 22, "Trader", [{ graphic: "BW (62)", direction: 2, script: "FT.mart(:termalaine, @event_id)" }])
tm.npc(8, 22, "BWFisherman", :tm_fisher, dir: 4)
tm.event(9, 28, "Fisher (rumours)", [{ graphic: "BWFisherman", direction: 4, script: "FT.ten_towns_rumor(\"FISHER\", @event_id)" }])
tm.npc(28, 30, "BWPoliceman", :tm_officer_hint, dir: 2, name: "Militia officer")
tm.npc(38, 13, "BW (75)", :tm_miner_out, dir: 4, name: "Miner")
npc_when(tm, 27, 24, KOBOLD_TM, :tm_kobold_worker, SW_TM_KOBOLDS_TOWN, dir: 2, name: "Kobold worker")
npc_when(tm, 29, 24, KOBOLD_TM, :tm_kobold_worker, SW_TM_KOBOLDS_TOWN, dir: 4, name: "Kobold worker")
tm.trainer(34, 9, "BWPoliceman", :tm_officer_varn, :FT_MILITIA, dir: 2, sight: 3)
tm.trainer(40, 7, "BW (75)", :miner_jory, :FT_MINER, dir: 4, sight: 3)
prop_sign(tm, 28, 34, :sign_termalaine)
prop_sign(tm, 18, 23, :tm_carvings)
prop_sign(tm, 10, 32, :tm_wind)
prop_sign(tm, 35, 21, :eastside_tunnels)
prop_sign(tm, 41, 6, :mine_sign)
seal_edges(tm)
save(tm, :termalaine)

# --- 2122: the Blue Clam. Long benches by the hearths; scrimshaw on the walls.
bc, ex = Builder.from_existing(768)
exits_to(bc, ex, ID[:termalaine], 12, 18)
bc.event(3, 6, "Vernon Braig", [{ graphic: "BW (54)", direction: 6, script: "FT.talk(:vernon_braig, @event_id)" }])
bc.event(10, 8, "Fisher (rumours)", [{ graphic: "BWFisherman", direction: 2, script: "FT.ten_towns_rumor(\"FISHER\", @event_id)" }])
bc.npc(13, 5, "BW (77)", :tm_rumour_hint, dir: 4, name: "Fishers by the hearth")
save(bc, :blue_clam)

# --- 2123: the Eastside. Marta and her father, the warm cellar rooms.
es, ex = Builder.from_existing(644)
exits_to(es, ex, ID[:termalaine], 33, 21)
es.event(11, 6, "Marta Peskryk", [{ graphic: "BW (16)", direction: 2, script: "FT.marta_peskryk(@event_id)" }])
es.npc(13, 7, "BWOldMan", :clyde_peskryk, dir: 4, name: "Clyde Peskryk")
es.sign(7, 5, :eastside_tunnels)
save(es, :eastside)

# --- 2135: the gem mine, level 1. M1 the tool hall; M2 the tourmaline seam;
# M3 the river cavern (giant rats); M4 the miners' benches; M5 the walkway
# along the central shaft (the saboteurs); M6 the bucket lift down.
gm = cave_map(36, 30)
gfl = {}
carve_into(gfl, 13, 21, 8, 8)            # M1
gfl[[17, 29]] = true                     #    the way out
carve_into(gfl, 5, 22, 8, 5)             # M2 (west)
carve_into(gfl, 16, 12, 3, 9)            # the passage north
carve_into(gfl, 4, 8, 12, 7)             # M3 (north-west)
carve_into(gfl, 19, 14, 9, 5)            # M4 (east of the passage)
carve_into(gfl, 14, 9, 5, 3)             # the walkway's west landing
carve_into(gfl, 28, 6, 6, 8)             # M6
gfl.delete([31, 8])                      #    the hole in the floor the bucket hangs over
cave_paint(gm, gfl)
cave_bridge_h(gm, 19, 27, 10)            # M5: the plank walkway along the shaft (the shaft is the dark to the north)
gm.door(17, 29, ID[:termalaine], 43, 4, 2, name: "Exit")
CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| gm.set(19 + i, 22 + j, 1, tl) } }
gm.sign(19, 23, :mine_sign)
CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| gm.set(13 + i, 21 + j, 1, tl) } }
gm.sign(13, 22, :mine_tools)
# M2: the seam
[[5, 22], [9, 22]].each do |x, y|
  CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| gm.set(x + i, y + j, 1, tl) } }
  gm.event(x + 1, y + 1, "Tourmaline seam", [{ graphic: "", script: "FT.mine_wall(:gem, @event_id)" }])
end
# M3: the river runs along the north wall into the fissure; two giant rats
CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| gm.set(4 + i, 8 + j, 1, tl) } }
gm.sign(5, 9, :mine_river)
[[9, 10], [11, 11]].each_with_index do |(x, y), i|
  gm.event(x, y, "Giant rat #{i + 1}", [
    { graphic: RAT, direction: 2, step_anime: true, script: "FT.mine_rats(@event_id)" },
    { switch: SW_TM_RATS, graphic: "", through: true }
  ])
end
# M4: the benches, and a little stone dog under one of them
CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| gm.set(23 + i, 14 + j, 1, tl) } }
gm.event(24, 15, "Bench", [{ graphic: "", script: "FT.mine_dog_figurine(@event_id)" }])
# M5: the walkway (the kobolds are under it)
[10, 11].each do |y|
  gm.event(22, y, "Walkway", [{ trigger: 1, through: true, script: "FT.mine_saboteurs(@event_id)" }, { switch: SW_TM_SABOTEURS, through: true }])
end
# M6: the bucket lift
gm.event(31, 8, "Bucket lift", [{ graphic: "", script: "FT.mine_lift(@event_id)" }])
gm.sign(23, 9, :mine_shaft)
seal_edges(gm)
save(gm, :gem_mine)

# --- 2136: the gem mine, deep. M7 the landing; M8 the grell's lair; M9 the
# miners' break room (Grek and Smol); M10 the bucket shuttle across the shaft;
# M11 Trex's tunnel; M12 the illithid skull; M13 the geodes.
gd = cave_map(36, 30)
dfl = {}
carve_into(dfl, 18, 17, 8, 7)            # M7
dfl.delete([22, 19])                     #    the lift's hole in the ceiling (and the floor: the shaft goes on down)
carve_into(dfl, 8, 20, 10, 2)            # the west tunnel
carve_into(dfl, 2, 17, 7, 9)             # M9
carve_into(dfl, 12, 22, 2, 2)            # down to...
carve_into(dfl, 9, 24, 8, 5)             # M8
carve_into(dfl, 26, 20, 4, 2)            # the east tunnel (one set of prints, going east)
carve_into(dfl, 29, 9, 2, 12)            # ...and up
carve_into(dfl, 25, 3, 6, 6)             # M10: the near platform
carve_into(dfl, 15, 3, 6, 6)             # M10: the far platform (the shaft between, x 21-24)
carve_into(dfl, 5, 4, 10, 3)             # M11: Trex's tunnel
carve_into(dfl, 5, 7, 3, 3)              # down to...
carve_into(dfl, 3, 10, 8, 4)             # M12
carve_into(dfl, 11, 10, 6, 4)            # M13
cave_paint(gd, dfl)
gd.event(22, 19, "Bucket lift", [{ graphic: "", script: "FT.mine_lift_up(@event_id)" }])
CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| gd.set(24 + i, 17 + j, 1, tl) } }
gd.sign(24, 18, :mine_landing)
# M9: the break room, a table, two kobolds poking a dead rat
CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| gd.set(3 + i, 21 + j, 1, tl) } }
gd.sign(4, 22, :mine_benches)
[[5, 19, "Grek"], [6, 20, "Smol"]].each do |x, y, n|
  gd.event(x, y, n, [
    { graphic: KOBOLD_TM, direction: 4, step_anime: true, script: "FT.mine_grek(@event_id)" },
    { switch: SW_TM_GREK, graphic: "", through: true }
  ])
end
# M8: the grell's lair, and a seam in its wall
gd.event(13, 26, "Grell", [
  { graphic: GRELL, direction: 8, step_anime: true, script: "FT.mine_grell(@event_id)" },
  { switch: SW_TM_GRELL, graphic: "", through: true }
])
CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| gd.set(9 + i, 27 + j - 1, 1, tl) } }
gd.event(10, 27, "Tourmaline seam", [{ graphic: "", script: "FT.mine_wall(:gem, @event_id)" }])
# M10: the bucket shuttle on its rope across the shaft
cave_bridge_h(gd, 21, 24, 5)             # the suspension rope and its bucket, across the shaft
[21, 24].each { |x| [5, 6].each { |y| gd.event(x, y, "Bucket shuttle", [{ trigger: 1, through: true, script: "FT.mine_shuttle(@event_id)" }]) } }
gd.sign(23, 4, :mine_shuttle)
# M11: Trex and his bodyguards
[[11, 4, "Trex"], [10, 4, "Vott"], [12, 4, "Zurk"]].each do |x, y, n|      # (lurking along the tunnel's north wall)
  gd.event(x, y, n, [
    { graphic: KOBOLD_TM, direction: 2, script: "FT.trex(@event_id)" },
    { switch: SW_TM_TREX, graphic: "", through: true }
  ])
end
# M12: the skull in the wall; M13: the geodes
CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| gd.set(3 + i, 10 + j, 1, tl) } }
gd.event(4, 11, "Skull in the wall", [{ graphic: "", script: "FT.mine_skull(@event_id)" }])
[[12, 10], [15, 12]].each do |x, y|
  CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| gd.set(x + i, y + j, 1, tl) } }
  gd.event(x, y + 1, "Geode", [{ graphic: "", script: "FT.mine_wall(:geode, @event_id)" }])
end
seal_edges(gd)
save(gd, :gem_mine_deep)

# --- 2020: the Lonelywood Road's south end now comes down to Termalaine, not
# Bryn Shander (Lonelywood connects only to Termalaine).
lr = reopen(LONELY_ROAD)
lr.map.events.each_value do |e|
  next unless e.name == "To Bryn Shander"
  e.instance_variable_set(:@name, "To Termalaine")
  e.pages.each do |pg|
    pg.list.each do |c|
      next unless c.code == 201
      c.parameters[1] = ID[:termalaine]; c.parameters[2] = e.x < 15 ? 17 : 18; c.parameters[3] = 1; c.parameters[4] = 2
    end
  end
end
resave(lr, LONELY_ROAD)

# ===========================================================================
# "The White Moose" (RotF pp. 79-84): the Lonelywood forest east of town (the
# loggers' camps, the tracks, and the way on to the Glade), the elven tomb
# (map 1.15: E1-E5 outside, E6-E9 under the hill), and Ramshackle.
SW_WM_TOMB_FOUND = 4068; SW_WM_MOOSE_DEAD = 4069; SW_WM_RAVISIN = 4070; SW_WM_BARROW_OPEN = 4071
SW_WM_HALF_OPEN = 4072; SW_WM_SAHNAR = 4073; SW_WM_AWAKENED = 4074; SW_WM_RAMSHACKLE = 4075
LONELYWOOD = 2021
GLADE = 2026
STATUE = "BW (107)"          # (art request: a white marble elf statue)
CRYSTAL = "FT_frostina_crystal"
MOOSE = "Followers/STANTLER"

def statue_event(b, x, y, dir)
  b.event(x, y, "Elf statue", [
    { graphic: STATUE, direction: dir, opacity: 210, walk_anime: false, script: "FT.elf_statue(@event_id)" },
    { self_switch: "A", graphic: "", through: true }
  ])
end

# A thing lying on a rock (the rock is solid, so the player reaches it from beside).
def on_boulder(b, x, y, name, script)
  b.stamp(BOULDER, x, y)
  b.event(x, y + 1, name, [{ graphic: "", script: script }])
end

# --- 2129: the Lonelywood forest. In from Lonelywood's logging road (west);
# the loggers' camp; the path north to the Glade; the deep woods east, where
# the tracks are, and past them the elven ward and the way to the tomb.
FW, FH = 48, 36
f = Builder.new(FW, FH)
f.fill(0, SNOW)
fopen = {}
carve_into(fopen, 0, 15, 16, 5)           # the logging road, from town
carve_into(fopen, 12, 9, 17, 16)          # the loggers' camp
carve_into(fopen, 22, 0, 6, 10)           # north, to the Glade
carve_into(fopen, 28, 5, 16, 26)          # the deep woods
carve_into(fopen, 43, 14, 5, 6)           # east, where the ward turns you round
forest_except(f, FW, FH, fopen)
grass(f, 30, 7, 6, 5); grass(f, 36, 22, 6, 6); grass(f, 31, 25, 4, 4); grass(f, 39, 9, 4, 4)
[[17, 12], [24, 21]].each { |x, y| f.stamp(HAY, x, y) }                         # stacked logs
[[15, 21], [16, 21], [20, 12], [21, 12], [26, 15]].each { |x, y| f.set(x, y, 2, CRATE) }
[[33, 16], [40, 18], [30, 27]].each { |x, y| stamp_pine(f, x, y) }
[0, 1].each { |i| f.warp(0, 17 + i, LONELYWOOD, 42, 11 + i, 4, name: "To Lonelywood") }
[24, 25].each { |x| f.warp(x, 0, GLADE, x == 24 ? 14 : 15, 26, 8, name: "To the Glade") }
[16, 17].each { |y| f.warp(FW - 1, y, ID[:elven_tomb], 1, y - 1, 6, name: "To the elven tomb") }
f.npc(19, 16, "BW (77)", :lonely_forest_logger, dir: 2, name: "Logger")
f.npc(23, 18, "BWHiker", :lonely_forest_hunter, dir: 4, name: "Hunter")
f.sign(17, 12, :lonely_forest_logpile)
f.set(10, 14, 2, CRATE); f.sign(10, 14, :sign_lonely_forest)
f.trainer(25, 11, "BW (72)", :forest_hunter_brann, :FT_TRAPPER, dir: 2, sight: 3)
f.trainer(36, 13, "BW (75)", :forest_logger_tova, :WORKER, dir: 4, sight: 4)
f.event(21, 22, "Awakened bear", [
  { graphic: "", through: true },
  { switch: SW_WM_AWAKENED, graphic: "Followers/BEARTIC", direction: 4, step_anime: true, script: "FT.awakened_bear(@event_id)" },
  { switch: SW_WM_RAVISIN, graphic: "", through: true }
])
# the tracks (an hour's search each), the fox and the hare
[[31, 8], [39, 25], [41, 11], [29, 19]].each { |x, y| on_boulder(f, x, y, "Moose tracks", "FT.moose_tracks(@event_id)") }   # fresh tracks round a boulder
f.event(34, 21, "Fox", [{ graphic: "Followers/VULPIX", direction: 6, script: "FT.fox_and_hare(@event_id)" }, { self_switch: "A", graphic: "", through: true }])
f.event(37, 21, "Hare", [{ graphic: "Followers/BUNEARY", direction: 6, script: "FT.fox_and_hare(@event_id)" }, { self_switch: "A", graphic: "", through: true }])
# the four things the brazier wants (three of them grow out here)
on_boulder(f, 32, 28, "Pinecone", "FT.forest_pickup(:FT_PINECONE, @event_id)")
on_boulder(f, 41, 6, "Owl feather", "FT.forest_pickup(:FT_OWLFEATHER, @event_id)")
on_boulder(f, 13, 23, "Twig", "FT.forest_pickup(:FT_TWIG, @event_id)")
# the elven ward: until you're following the white moose's tracks, it turns you round
(14..19).each { |y| f.event(44, y, "Elven ward", [{ trigger: 1, through: true, script: "FT.tomb_ward(@event_id)" }, { switch: SW_WM_TOMB_FOUND, through: true }]) }
seal_edges(f)
save(f, :lonely_woods)

# --- 2130: the elven tomb, outside (map 1.15). The circular depression and its
# crystal gnomon (E5); the hole in its north-west wall, under the hill (E6);
# the berm east with the sarcophagus and five crystal pillars (E4); the marble
# gazebo north of the berm (E3); the statues south of it (E1); the barrow door
# in the hillside to the south (E2).
EW, EH = 36, 30
e = Builder.new(EW, EH)
e.fill(0, SNOW)
eopen = {}
carve_into(eopen, 0, 14, 6, 4)            # in from the forest, following the tracks
carve_into(eopen, 3, 5, 31, 21)           # the slope
forest_except(e, EW, EH, eopen)
[[30, 9], [32, 12], [31, 17], [33, 20]].each { |x, y| stamp_pine(e, x, y) }       # evergreens on the berm
e.stamp(ICE_BOULDER, 16, 13)              # the crystal gnomon (E5)
e.event(16, 14, "Moon dial", [{ graphic: "", script: "FT.moon_dial(@event_id)" }])
e.event(17, 14, "Moon dial", [{ graphic: "", script: "FT.moon_dial(@event_id)" }])
e.stamp(CAVE, 9, 6)                       # the hole punched in the north-west wall: mouth (10, 8)
e.door(10, 8, ID[:elven_barrow], 12, 3, 2, name: "Door barrow hole")
# E4: the sarcophagus on the berm, five crystal pillars round it, a seventh statue on the north tip
e.stamp(BOULDER, 27, 13)
e.event(27, 14, "Sarcophagus", [{ graphic: "", script: "FT.tomb_sarcophagus(@event_id)" }])
[[26, 11], [25, 13], [25, 15], [26, 17], [29, 16]].each_with_index do |(x, y), i|
  e.event(x, y, "Crystal pillar #{i + 1}", [{ graphic: CRYSTAL, direction: 2, walk_anime: false, script: "FT.talk(:tomb_pillars, @event_id)" }])
end
statue_event(e, 28, 9, 2)
# E3: the gazebo
(23..27).each { |x| (4..7).each { |y| e.set(x, y, 1, PLANK[:c]) } }
[[23, 3], [27, 3]].each { |x, y| e.stamp(LAMP, x, y) }
e.set(25, 5, 2, CRATE)
e.event(25, 5, "Brazier", [{ graphic: "", script: "FT.gazebo_brazier(@event_id)" }])
# E1: six statues on their pillars, facing north
[18, 20, 22, 24, 26, 28].each { |x| statue_event(e, x, 21, 8) }
# E2: the barrow door in the hillside
e.stamp(CAVE, 13, 21)                     # mouth (14, 23)
e.event(14, 23, "Barrow door", [
  { trigger: 1, script: "FT.talk(:tomb_e2, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])" },
  { switch: SW_WM_BARROW_OPEN, trigger: 1, commands: [e.send(:command, 201, [0, ID[:elven_barrow], 14, 23, 8, 1])] }
])
# a lookout in the trees, west
on_boulder(e, 4, 8, "Lookout", "FT.tomb_lookout(@event_id)")
[0, 1].each { |i| e.warp(0, 15 + i, ID[:lonely_woods], FW - 2, 16 + i, 4, name: "To the forest") }
e.cutscene(5, 24, :elven_tomb_arrival)
seal_edges(e)
save(e, :elven_tomb)

# --- 2131: under the hill. E6 the barrow (the animals, the moose, three more
# statues facing the east wall); E7 the mirror, west, at the end of a narrowing
# passage; E8 and E9, the tombs of the half-moon, north and south of the east hall.
br = cave_map(34, 26)
bfl = {}
carve_into(bfl, 12, 1, 2, 7)              # the hole, down from the moon dial
carve_into(bfl, 8, 8, 13, 11)             # E6
carve_into(bfl, 14, 19, 2, 6)             # down to the south door (E2)
bfl[[14, 25]] = true
carve_into(bfl, 4, 12, 4, 2)              # E7: the passage narrows...
carve_into(bfl, 2, 12, 2, 1)              #     ...to the mirror
carve_into(bfl, 21, 12, 3, 2)             # east, to the half-moon hall
carve_into(bfl, 24, 9, 3, 8)              # the half-moon hall
carve_into(bfl, 22, 2, 7, 6)              # E8 (north)
carve_into(bfl, 22, 18, 7, 6)             # E9 (south)
bfl[[25, 8]] = true; bfl[[25, 17]] = true # their doors
cave_paint(br, bfl)
br.door(13, 1, ID[:elven_tomb], 10, 9, 2, name: "Up to the moon dial")
br.event(14, 25, "South door", [
  { trigger: 1, script: "FT.talk(:tomb_e2, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])" },
  { switch: SW_WM_BARROW_OPEN, trigger: 1, commands: [br.send(:command, 201, [0, ID[:elven_tomb], 14, 24, 2, 1])] }
])
br.event(16, 23, "Lever", [{ graphic: "", script: "FT.barrow_lever(@event_id)" }])
# E6: the moose finds you as you come down; the sleeping animals; the bones; three statues
[12, 13].each { |x| br.event(x, 8, "The white moose wakes", [{ trigger: 1, through: true, script: "FT.barrow_moose(@event_id)" }, { switch: SW_WM_MOOSE_DEAD, through: true }]) }
br.event(16, 12, "White moose", [
  { graphic: MOOSE, direction: 4, step_anime: false, script: "FT.barrow_moose(@event_id)" },
  { switch: SW_WM_MOOSE_DEAD, graphic: "", through: true }
])
[["VULPIX", 14, 15], ["BUNEARY", 17, 16], ["HOOTHOOT", 19, 10], ["POOCHYENA", 18, 14], ["TEDDIURSA", 11, 16], ["DEERLING", 15, 17]].each do |sp, x, y|
  br.event(x, y, "Sleeping #{sp.downcase}", [
    { graphic: "Followers/#{sp}", direction: 2, walk_anime: false, script: "FT.talk(:barrow_animals, @event_id)" },
    { switch: SW_WM_MOOSE_DEAD, graphic: "", through: true }
  ])
end
CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| br.set(18 + i, 16 + j, 1, tl) } }
br.event(18, 17, "Bones", [{ graphic: "", script: "FT.barrow_bones(@event_id)" }])
[10, 12, 14].each { |y| statue_event(br, 9, y, 6) }
# E7: the mirror (on the end wall)
br.event(1, 12, "Mirror of the Full Moon", [{ graphic: "", script: "FT.full_moon_mirror(@event_id)" }])
# E8 / E9: the half-moon doors, and the tombs behind them
[[8, :e8], [17, :e9]].each do |y, k|
  br.event(25, y, "Half-moon door (#{k.upcase})", [
    { tile_id: CAVE_ROCKS[0][0], script: "FT.half_moon_door(:#{k}, @event_id)" },
    { switch: SW_WM_HALF_OPEN, through: true }
  ])
end
CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| br.set(24 + i, 3 + j, 1, tl) } }
br.event(25, 4, "Sarcophagus (E8)", [{ graphic: "", script: "FT.half_tomb_one(@event_id)" }])
CAVE_ROCKS.each_with_index { |row, j| row.each_with_index { |tl, i| br.set(24 + i, 21 + j, 1, tl) } }
br.event(24, 21, "Sarcophagus (E9)", [{ graphic: "", script: "FT.vurnis(@event_id)" }])
br.event(24, 20, "Ravisin", [
  { graphic: "BW (40)", direction: 8, script: "FT.ravisin(@event_id)" },
  { switch: SW_WM_RAVISIN, graphic: "", through: true }
])
br.event(27, 21, "Berry bush", [{ graphic: "Followers/SUDOWOODO", direction: 4, script: "FT.awakened_shrub(@event_id)" }])
seal_edges(br)
save(br, :elven_barrow)

# --- 2137: Ramshackle, Lonelywood's closed inn (yours, once the moose is dead)
rs, ex = Builder.from_existing(768)
exits_to(rs, ex, LONELYWOOD, 15, 32)
rs.event(4, 6, "The old bar", [{ graphic: "", script: "FT.ramshackle_rest(@event_id)" }])
rs.event(11, 5, "Notice", [{ graphic: "", script: "FT.talk(:ramshackle_notice, @event_id)" }])
save(rs, :ramshackle)

# --- Lonelywood: the logging road east now runs into the forest (the Glade is
# beyond it), and Ramshackle's door works once the inn is yours.
lw = reopen(LONELYWOOD)
lw.map.events.each_value do |ev|
  if ev.name == "To the Glade"
    ev.instance_variable_set(:@name, "To the Lonelywood forest")
    ev.pages.each { |pg| pg.list.each { |c| c.parameters[1, 4] = [ID[:lonely_woods], 1, ev.y + 6, 6] if c.code == 201 } }
  elsif ev.name == "Door ramshackle_closed"
    ev.instance_variable_set(:@name, "Door Ramshackle")
    pg = ev.pages[0]
    pg.instance_variable_set(:@list, lw.send(:script_commands, "FT.ramshackle_door(@event_id)") + [lw.send(:command, 0, [])])
  end
end
resave(lw, LONELYWOOD)
gl2 = reopen(GLADE)
gl2.map.events.each_value do |ev|
  next unless ev.name == "To Lonelywood"
  ev.instance_variable_set(:@name, "To the Lonelywood forest")
  ev.pages.each { |pg| pg.list.each { |c| c.parameters[1, 4] = [ID[:lonely_woods], ev.x + 10, 1, 2] if c.code == 201 } }
end
resave(gl2, GLADE)

# ===========================================================================
merge_infos(ID.map { |k, v| [v, NAMES[k]] }.select { |id, _| File.exist?(File.join(OUT, format("Map%04d.rxdata", id))) })
puts "built Ten-Towns maps into #{OUT}"
