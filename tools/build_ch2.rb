# Builds every map for Act I, Chapter 2 (Razzy): the North Road out of Targos,
# the Frost-Light Chasm, and Bryn Shander with its Speaker's Hall (Gym 2).
# Output: ../build/maps/MapNNNN.rxdata (+ .json previews), merged into mapinfos.json
require_relative "mapkit"
include MapKit

OUT = File.expand_path("../build/maps", __dir__)
Dir.mkdir(OUT) unless Dir.exist?(OUT)

ID = {
  north_road: 2010, chasm: 2011, bryn: 2012, bryn_center: 2013, bryn_mart: 2014, bryn_gym: 2015,
  northlook: 2016, bryn_house_a: 2017, bryn_house_b: 2018, morninglord: 2019, council_hall: 2134
}
OPEN_TUNDRA = 2125         # "Mountain Climb" / "Foaming Mugs" (build_tentowns.rb)
TERMALAINE_PATH = 2121     # the snowy path from Bryn Shander's north gate to Termalaine (build_tentowns.rb)
NAMES = {
  north_road: "Bryn Shander Road", chasm: "Frost-Light Chasm", bryn: "Bryn Shander",
  bryn_center: "Bryn Shander Pokémon Center", bryn_mart: "Blackiron Blades", bryn_gym: "Bryn Shander Town Hall",
  northlook: "The Northlook", bryn_house_a: "Weaver's House", bryn_house_b: "Lottery House",
  morninglord: "House of the Morninglord", council_hall: "Council Hall"
}
TARGOS = 2001
SW_ROAD_OPEN = 3910       # on once Naerth's seal is won: the Targos guards step aside

MUSIC = {
  north_road: "Reversal Mountain (White 2)", chasm: "Seafoam Islands Music", bryn: "Opelucid City (White)",
  bryn_center: "pokecenter", bryn_mart: "Ecruteak City", bryn_gym: "gym_kanto", northlook: "Lostlorn Forest",
  bryn_house_a: "Lavender Town", bryn_house_b: "Lavender Town", morninglord: "sinjoh", council_hall: "Ecruteak City"
}

def save(b, key)
  b.music(MUSIC[key]) if MUSIC.key?(key)
  b.save(File.join(OUT, format("Map%04d.rxdata", ID[key])))
  b.to_json_file(File.join(OUT, format("Map%04d.json", ID[key])))
end

def exits_to(b, exits, map, x, y)
  exits.each { |ex, ey| b.door(ex, ey, map, x, y, 2, name: "Exit") }
end

# An NPC that appears only when a game switch is on (page 1 is empty and walkable).
def npc_when(b, x, y, graphic, key, switch, dir: 2, name: nil)
  b.event(x, y, name || "NPC #{key}", [
    { graphic: "", through: true },
    { switch: switch, graphic: graphic, direction: dir, script: "FT.talk(:#{key}, @event_id)" }
  ])
end

# An NPC that stands in the way until a game switch turns on, then is gone.
def npc_until(b, x, y, graphic, key, switch, dir: 2, name: nil)
  b.npc(x, y, graphic, key, dir: dir, hide_switch: switch, name: name)
end

# A step-on trigger that runs once (a scene that waits for the player at a spot).
def trigger(b, x, y, key, name: nil)
  b.event(x, y, name || "Trigger #{key}", [
    { trigger: 1, through: true, script: "FT.scene(:#{key}, @event_id)" },
    { self_switch: "A", through: true }
  ])
end

SNOW = 444
GRASS = 8510                                        # snowy tall grass (wild Pokémon)
TREE = [[4582, 4583], [4590, 4591], [4598, 4599], [4606, 4607]]
ICE_BOULDER = Stamp.tileset(:ice_boulder, 118, 0, 2, 2)
BOULDER = Stamp.tileset(:boulder, 114, 2, 2, 2)
CAVE = Stamp.tileset(:cave, 25, 2, 3, 3)            # the mouth is the bottom-middle tile
PLANK = { nw: 1920, n: 1922, ne: 1925, w: 1928, c: 1930, e: 1933, sw: 1944, s: 1947, se: 1949 }
FENCE_H = 384 + 134 * 8 + 1                         # a run of log posts
FENCE_V = 384 + 133 * 8 + 4
LAMP = Stamp.tileset(:lamp, 82, 4, 1, 2)
HUT = Stamp.tileset(:hut, 675, 2, 5, 4)
ROUND_HUT = Stamp.tileset(:round_hut, 680, 2, 5, 4).without([[4, 0]])
CABIN = Stamp.tileset(:cabin, 982, 0, 6, 5)
HOUSE = Stamp.tileset(:house, 629, 0, 4, 5)
CENTER = Stamp.tileset(:center, 457, 0, 7, 7)
GYM = Stamp.tileset(:gym, 254, 0, 7, 7)
CRATE = 1056
HAY = Stamp.tileset(:hay, 79, 1, 2, 2)

# Trees on alternating layers, so a row of trees can overlap the one above it
# without opening walkable gaps (the canopy is drawn over the player anyway).
def tree(b, x, y, layer = 2)
  TREE.each_with_index { |row, dy| row.each_with_index { |t, dx| b.set(x + dx, y + dy, layer, t) } }
end

# Forest everywhere except the open cells: a tree is planted only where its two
# solid rows stay clear of the open area (its canopy may hang over it).
def forest_except(b, w, h, open)
  plant = []
  (-1...h).step(2).each_with_index do |y, i|
    (0...w).step(2) do |x|
      solid = [[x, y + 1], [x + 1, y + 1], [x, y + 2], [x + 1, y + 2]]
      next if solid.any? { |c| open[c] }
      plant << [x, y, i.even? ? 1 : 2]
    end
  end
  planted = {}
  plant.each { |x, y, _| planted[[x, y]] = true }
  plant.each do |x, y, layer|
    TREE.each_with_index do |row, dy|
      # the trunk's foot is drawn only where no tree stands right below
      next if dy == 3 && planted[[x, y + 2]]
      row.each_with_index { |t, dx| b.set(x + dx, y + dy, layer, t) }
    end
  end
end

# Fills a rectangle with dense forest (2x2 grid of trees, rows overlapping).
def forest(b, x0, y0, w, h)
  (y0...y0 + h).step(2).each_with_index do |y, i|
    (x0...x0 + w).step(2) { |x| tree(b, x, y - 1, i.even? ? 1 : 2) }
  end
end

def grass(b, x0, y0, w, h)
  (y0...y0 + h).each { |y| (x0...x0 + w).each { |x| b.set(x, y, 1, GRASS) } }
end

# ---------------------------------------------------------------------------
# 2010: the Bryn Shander Road, from Targos's south-west gate (bottom) to Bryn Shander's (top).
# A winding snowfield between walls of pine. Two grass fields, a frozen pond,
# trainers on the way, and the glow of the Frost-Light Chasm off to the east.
W, H = 34, 70
r = Builder.new(W, H)
r.fill(0, SNOW)
# forest everywhere, then carve the road out of it
open = {}
carve = lambda do |x0, y0, w, h|
  (y0...y0 + h).each { |y| (x0...x0 + w).each { |x| open[[x, y]] = true } }
end
carve.(14, 62, 6, 6)          # the bottom: the road turns west towards Targos
carve.(0, 65, 20, 3)          # ...and leaves by the west edge (Targos's gate)
carve.(8, 50, 16, 13)         # first field
carve.(6, 40, 10, 11)
carve.(10, 34, 20, 8)         # east bend towards the chasm
carve.(24, 25, 8, 11)         # chasm clearing
carve.(10, 20, 8, 15)
carve.(8, 8, 18, 13)          # second field
carve.(26, 14, 8, 2)          # a trail east onto the open tundra, toward Kelvin's Cairn
carve.(14, 0, 6, 9)           # the top: Bryn Shander
forest_except(r, W, H, open)
# a tree row's canopy overhangs the tile above it: put the canopies back along carved bottoms
grass(r, 9, 52, 7, 5)
grass(r, 17, 55, 6, 5)
grass(r, 7, 42, 6, 6)
grass(r, 11, 22, 5, 7)
grass(r, 9, 10, 6, 5)
grass(r, 19, 13, 6, 6)
r.autotile(0, 5, Builder.rect_cells(20, 36, 7, 4))      # a frozen pond (lake autotile)
r.stamp(ICE_BOULDER, 12, 45); r.stamp(ICE_BOULDER, 26, 27); r.stamp(BOULDER, 21, 9)
r.stamp(ICE_BOULDER, 16, 60); r.stamp(BOULDER, 9, 37)
r.stamp(CAVE, 28, 26)                                    # the chasm mouth: door at (29, 28)
r.door(29, 28, ID[:chasm], 21, 31, 8, name: "Frost-Light Chasm")
# Targos is off the west edge, so walking on (whichever key you hold) never bounces you back
[65, 66, 67].each { |y| r.warp(0, y, TARGOS, y < 66 ? 8 : 9, 42, 8, name: "To Targos") }
[14, 15, 16, 17, 18, 19].each { |x| r.warp(x, 0, ID[:bryn], x < 17 ? 9 : 10, 43, 8, name: "To Bryn Shander") }
r.cutscene(16, 67, :north_road_start)
(6..15).each { |x| trigger(r, x, 42, :razzy_appears) }
# until the egg is safe, the party won't go on north without the little goblin
(10..17).each do |x|
  r.event(x, 33, "Razzy wait", [{ trigger: 1, through: true, script: "FT.razzy_block(@event_id)" }])
end
r.trainer(12, 57, "BWHiker", :hiker_tor, :HIKER, dir: 6, sight: 4)
r.trainer(21, 50, "BWBackpacker_female", :backpacker_wen, :PICNICKER, dir: 4, sight: 4)
r.trainer(8, 44, "BWRanger_male", :ranger_aldo, :POKEMONRANGER_M, dir: 6, sight: 3)
r.trainer(15, 26, "BW (107)", :aurilite_one, :FT_AURILITE, dir: 2, sight: 4)
r.trainer(23, 11, "BWRanger_female", :ranger_lune, :POKEMONRANGER_F, dir: 4, sight: 4)
r.trainer(10, 16, "BWHiker", :hiker_bram, :HIKER, dir: 6, sight: 3)
r.npc(13, 47, "BW (77)", :road_old_trapper, dir: 6)
r.npc(20, 18, "BWPoliceman", :road_caravan_guard, dir: 2)
r.sign(17, 64, :sign_north_road)
r.sign(27, 33, :sign_chasm)
r.sign(13, 4, :sign_bryn_ahead)
[14, 15].each { |y| r.warp(W - 1, y, OPEN_TUNDRA, 1, y == 14 ? 20 : 21, 6, name: "To the Open Tundra") }
r.sign(27, 13, :sign_tundra_east)
seal_edges(r)
save(r, :north_road)

# ---------------------------------------------------------------------------
# 2011: the Frost-Light Chasm (Ice Cavern layout). Razzy runs ahead; at the
# bottom, the frost-light takes him.
c, ex = Builder.from_existing(693, keep: (4..18).to_a)
exits_to(c, ex, ID[:north_road], 29, 29)
c.cutscene(0, 0, :frostlight_enter)   # its own key: the Cackling Chasm (Ch5) uses :cackling_enter
c.trainer(12, 24, "BW (107)", :aurilite_two, :FT_AURILITE, dir: 6, sight: 4)
c.trainer(23, 19, "BW (108)", :aurilite_three, :FT_AURILITE, dir: 4, sight: 4)
# Razzy waits at the lip of the crack (in the open, clear of the slope's landing);
# pressing A on him, or stepping up to the lip, starts the scene. After it the
# crack is dark, and stepping into it says so (notes 02 E3: no placeholder sprite left in the crack).
c.event(22, 6, "Frost-light", [
  { graphic: "FT_razzy", direction: 2, step_anime: true, script: "FT.scene(:razzy_falls, @event_id)" },
  { self_switch: "A", graphic: "", through: true, trigger: 1, script: "FT.talk(:chasm_after, @event_id)" }   # step into the dark crack
])
[[21, 6], [23, 6], [22, 7]].each { |x, y| trigger(c, x, y, :razzy_falls, name: "Lip razzy_falls") }
save(c, :chasm)

# 2012: Bryn Shander, after map 1.2 of the book: the largest of the Ten-Towns,
# a round hill town inside a log wall with three gates (north to Lonelywood,
# east onto the Eastway, south-west towards Targos). The Northlook stands by
# the north gate, the Town Hall (Speaker Duvessa Shane, Gym 2) beside the
# central square, the House of the Morninglord to the north-east, the Council
# Hall to the south, the stables by the west wall.
BW_, BH_ = 50, 46
BC = [25, 23]
BR = 20
binside = ->(x, y) { (x - BC[0])**2 + (y - BC[1])**2 <= BR**2 }
t = Builder.new(BW_, BH_)
t.fill(0, SNOW)
bopen = {}
(0...BW_).each { |x| (0...BH_).each { |y| bopen[[x, y]] = true if binside.(x, y) } }
[22, 23].each { |x| (0..4).each { |y| bopen[[x, y]] = true } }              # north gate road
(44...BW_).each { |x| [22, 23].each { |y| bopen[[x, y]] = true } }          # east gate road (the Eastway)
(8..11).each { |x| (34...BH_).each { |y| bopen[[x, y]] = true } }           # south-west gate road
forest_except(t, BW_, BH_, bopen)
sw_gate = ->(x, y) { (x - 10.5)**2 + (y - 37.5)**2 <= 3.2 }
(0...BW_).each do |x|
  (0...BH_).each do |y|
    next unless binside.(x, y)
    next unless [[1, 0], [-1, 0], [0, 1], [0, -1]].any? { |dx, dy| !binside.(x + dx, y + dy) }
    next if [22, 23].include?(x) && y < 6                                   # north gate
    next if [22, 23].include?(y) && x > 40                                  # east gate
    next if sw_gate.(x, y)                                                  # south-west gate
    t.set(x, y, 1, FENCE_H)
  end
end
streets = []
streets += Builder.rect_cells(22, 3, 2, 17)                                 # north street
streets += Builder.rect_cells(18, 20, 17, 6)                                # the central square
streets += Builder.rect_cells(35, 22, 11, 2)                                # east street (the Eastway)
streets += Builder.rect_cells(6, 22, 12, 2)                                 # west street
streets += Builder.rect_cells(24, 26, 2, 8)                                 # south street
(0..12).each { |i| x = 19 - (i * 8 / 12.0).round; y = 25 + i; streets += [[x, y], [x + 1, y]] }   # south-west street
streets += Builder.rect_cells(9, 37, 3, 9).select { |x, y| y >= 37 }
streets += Builder.rect_cells(17, 16, 2, 4)                                 # Blackiron Blades' doorstep
streets.each { |x, y| t.set(x, y, 1, PLANK[:c]) if bopen[[x, y]] }
t.stamp(GYM, 28, 13)           # Town Hall, door (31, 19)
t.stamp(HUT, 16, 12)           # Blackiron Blades, door (17, 15)
t.stamp(CABIN, 15, 6)          # the Northlook, door (17, 10)
t.stamp(ROUND_HUT, 32, 7)      # House of the Morninglord, door (33, 10)
t.stamp(CENTER, 7, 15)         # Pokémon Center, door (10, 21)
t.stamp(HOUSE, 23, 34)         # Council Hall (closed), door (24, 38)
t.stamp(HUT, 33, 28)           # Weaver's House, door (34, 31)
t.stamp(ROUND_HUT, 38, 26)     # Lottery House, door (39, 29)
t.stamp(HAY, 6, 28); t.stamp(HAY, 8, 30); t.set(10, 29, 2, CRATE)         # the stables
[[21, 19], [27, 19], [21, 26], [35, 21], [6, 21], [26, 33], [21, 4]].each { |x, y| t.stamp(LAMP, x, y) }
t.door(31, 19, ID[:bryn_gym], 10, 19, 8, name: "Door Town Hall")
t.door(10, 21, ID[:bryn_center], 10, 11, 8, name: "Door Pokemon Center")
t.door(17, 15, ID[:bryn_mart], 6, 12, 8, name: "Door Blackiron Blades")
t.door(17, 10, ID[:northlook], 5, 11, 8, name: "Door Northlook")
t.door(34, 31, ID[:bryn_house_a], 9, 11, 8, name: "Door Weaver")
t.door(39, 29, ID[:bryn_house_b], 9, 11, 8, name: "Door Lottery House")
t.door(33, 10, ID[:morninglord], 9, 11, 8, name: "Door Morninglord")
t.door(24, 38, ID[:council_hall], 10, 13, 8, name: "Door Council Hall")
t.sign(22, 39, :bryn_council_hall)
(8..11).each { |x| t.warp(x, BH_ - 1, ID[:north_road], x < 10 ? 16 : 17, 1, 2, name: "To Bryn Shander Road") }
[22, 23].each { |x| t.warp(x, 0, TERMALAINE_PATH, x == 22 ? 14 : 15, 46, 8, name: "To the Termalaine Path") }
# the gates
t.npc(12, 36, "BWPoliceman", :bryn_south_guard, dir: 4)
# the north gate: guards across every way up to it, until Duvessa's seal (switch 3913)
[19, 20, 22, 23].each do |x|
  t.event(x, 5, "Guard", [
    { graphic: "BWPoliceman", direction: 2, script: "FT.talk(:bryn_north_guard, @event_id)" },
    { switch: 3913, graphic: "", through: true }
  ])
end
npc_when(t, 21, 6, "BWPoliceman", :bryn_north_guard_open, 3913, dir: 6)
[22, 23].each do |y|
  t.event(44, y, "Guard", [
    { graphic: "BWPoliceman", direction: 4, script: "FT.talk(:bryn_east_guard, @event_id)" },
    { switch: 3914, graphic: "", through: true }
  ])
end
npc_when(t, 43, 21, "BWPoliceman", :bryn_east_guard_open, 3914, dir: 4)
t.cutscene(10, 43, :bryn_arrival)
t.npc(24, 23, "BW (38)", :bryn_square_talk, move: 1)
t.npc(20, 24, "BW (77)", :bryn_lottery_talk, dir: 6)
t.npc(13, 24, "BW (20)", :bryn_kid_talk, move: 1)
t.npc(30, 32, "BW (54)", :bryn_sephek_talk, dir: 8)
t.npc(29, 24, "BW (61)", :bryn_trade_talk, dir: 2)
t.sign(27, 20, :bryn_sign_hall)
t.sign(19, 19, :bryn_sign_square)
t.trainer(16, 23, "BW (57)", :bryn_zhent_a, :FT_ZHENTARIM, dir: 6, sight: 3)
t.event(31, 23, "Sheriff Southwell", [{ graphic: "BWPoliceman", direction: 2, script: "FT.sheriff_southwell(@event_id)" }])
t.npc(19, 6, "BWPoliceman", :southwell_militia, dir: 2, name: "Militia")
t.sign(8, 40, :bryn_heraldry)
t.sign(22, 18, :bryn_lanterns)
# "Foaming Mugs": Hruna, Korux and Storn, frostbitten, in the street by the Northlook
[[10, 12, "Hruna"], [11, 12, "Korux"], [12, 12, "Storn"]].each do |x, y, n|
  t.event(x, y, n, [
    { graphic: "BW (72)", direction: 2, script: "FT.foaming_mugs_dwarves(@event_id)" },
    { switch: 4049, graphic: "", through: true }
  ])
end
# lottery night (SC 2.06): resting at the Northlook brings you out to the square at sundown
t.event(25, 24, "Lottery night", [{ graphic: "", through: true }, { switch: 3955, trigger: 3, script: "FT.lottery_night" }])
# SC 2.09: out of the hall with the seal, Mishann is waiting on the steps (notes 02 E4, E18)
t.event(1, 1, "Cutscene mishann_steps", [{}, { switch: 3912, trigger: 3, script: "FT.scene(:mishann_steps, @event_id)" },
                                         { self_switch: "A" }])
seal_edges(t)
save(t, :bryn)

# 2019: the House of the Morninglord (Lathander's priests keep a fire lit for travelers)
ml, ex = Builder.from_existing(644)
exits_to(ml, ex, ID[:bryn], 33, 11)
ml.event(13, 7, "Mishann", [{ graphic: "BW (98)", direction: 4, script: "FT.morninglord(@event_id)" }])
ml.npc(7, 6, "BW (62)", :morninglord_acolyte, dir: 2)
ml.event(11, 8, "Copper Knobberknocker", [{ graphic: "BW (24)", direction: 4, script: "FT.copper_knobberknocker(@event_id)" }])
save(ml, :morninglord)

# 2013: Pokémon Center
pc, ex = Builder.from_existing(632, keep: [4, 8, 10])
exits_to(pc, ex, ID[:bryn], 10, 22)
pc.npc(15, 9, "BW (35)", :bryn_center_traveler, dir: 4)
save(pc, :bryn_center)

# 2014: market
m, ex = Builder.from_existing(81)
exits_to(m, ex, ID[:bryn], 17, 16)
m.event(6, 6, "Elza", [{ graphic: "BW (56)", direction: 2, script: "FT.elza_shop(@event_id)" }])
m.event(5, 8, "Garn the Hammer", [{ graphic: "BW (72)", direction: 6, script: "FT.garn_hammer(@event_id)" }])
m.npc(10, 9, "BW (62)", :bryn_market_customer, dir: 6)
save(m, :bryn_mart)

# 2016: the Northlook (tavern; the Zhentarim keep a back table here)
n, ex = Builder.from_existing(768)
exits_to(n, ex, ID[:bryn], 17, 11)
n.event(3, 6, "Scramsax", [{ graphic: "BW (72)", direction: 6, script: "FT.scramsax(@event_id)" }])   # rest until the lottery (SC 2.06)
n.event(9, 4, "Ol' Bitey", [{ graphic: "", script: "FT.ol_bitey(@event_id)" }])
n.event(6, 8, "Regular (rumours)", [{ graphic: "BW (77)", direction: 6, script: "FT.ten_towns_rumor(\"REGULAR\", @event_id)" }])
n.npc(13, 5, "BW (92)", :zhent_broker, dir: 4, name: "Broker")
n.trainer(10, 8, "BW (63)", :northlook_zhent, :FT_ZHENTARIM, dir: 2, sight: 2)
n.npc(10, 10, "BWBackpacker_male", :northlook_traveler, dir: 8)
n.npc(15, 9, "BWOldMan", :northlook_old_hand, dir: 4)
save(n, :northlook)

# 2017-2018: houses
h, ex = Builder.from_existing(644)
exits_to(h, ex, ID[:bryn], 34, 32)
h.npc(13, 7, "BW (62)", :bryn_weaver, dir: 4, name: "Brenna")
h.npc(7, 6, "BW (16)", :bryn_ilda, dir: 2, name: "Ilda")
save(h, :bryn_house_a)
h, ex = Builder.from_existing(644)
exits_to(h, ex, ID[:bryn], 39, 30)
h.npc(13, 7, "BW (56)", :bryn_lottery_mother, dir: 4)
h.npc(7, 6, "BW (17)", :bryn_lottery_child, dir: 2)
save(h, :bryn_house_b)

# ---------------------------------------------------------------------------
# 2015: the Town Hall (Gym 2). The town's winter stores stacked into walls of
# crates, one of Sheriff Southwell's militia at every gap, and the Speaker at
# the long table at the back.
module Hall
  VOID, FLOOR, WALL, BASE = 48, 692, 950, 958
  TABLE = [[1264, 1265], [[1272, 1273], [1280, 1281]]]
  CRATE = [[8114, 8115], [[8122, 8123], [8130, 8131]]]
  BOXES = [[3782, 3783], [[3790, 3791]]]
  CAN   = [[4502], [[4510]]]
  CANS  = [[4528, 4529], [[4536, 4537]]]
  STOOL = 1836
  SHELF = [[8978, 8979], [8986, 8987]]
end

def hall_obj(b, obj, x, y)
  over, rows = obj
  over.each_with_index { |tl, i| b.set(x + i, y - 1, 2, tl) }
  rows.each_with_index { |row, j| row.each_with_index { |tl, i| b.set(x + i, y + j, 1, tl) } }
end

def hall_line(b, x0, x1, y, pattern)
  x = x0
  i = 0
  while x <= x1
    obj = pattern[i % pattern.size]
    w = obj[0].size
    w = 1 if x + w - 1 > x1
    obj = Hall::CAN if w == 1
    if obj[1].size == 1
      hall_obj(b, obj, x, y + 1)
      hall_obj(b, obj, x, y)
    else
      hall_obj(b, obj, x, y)
    end
    x += w
    i += 1
  end
end

g = Builder.new(21, 21, tileset_id: 25)
g.fill(0, Hall::VOID)
g.fill(0, Hall::FLOOR, 1, 2, 19, 17)
g.fill(0, Hall::WALL, 1, 0, 19, 1)
g.fill(0, Hall::BASE, 1, 1, 19, 1)
g.fill(0, Hall::FLOOR, 9, 19, 3, 1)
[[2, 0], [17, 0]].each do |x, y|
  Hall::SHELF.each_with_index { |row, j| row.each_with_index { |tl, i| g.set(x + i, y + j, 2, tl) } }
end
# the long council table across the back, with the Speaker behind it
[[6, 4], [13, 4]].each { |x, y| hall_obj(g, Hall::TABLE, x, y) }
# three walls of strongboxes; the gaps go left, right, middle
hall_line(g, 4, 19, 15, [Hall::CRATE, Hall::BOXES, Hall::CRATE, Hall::CANS])
g.set(1, 15, 1, 4510); g.set(1, 16, 1, 4510)                      # gap at x 2-3
hall_line(g, 1, 16, 11, [Hall::BOXES, Hall::CRATE, Hall::CANS, Hall::CRATE])
g.set(19, 11, 1, 4510); g.set(19, 12, 1, 4510)                    # gap at x 17-18
hall_line(g, 1, 8, 7, [Hall::CRATE, Hall::BOXES, Hall::CRATE])
hall_line(g, 12, 19, 7, [Hall::CRATE, Hall::CANS, Hall::CRATE])   # gap at x 9-11
[[6, 18], [14, 18], [5, 14], [15, 14], [4, 10], [12, 10], [6, 6], [15, 6]].each { |x, y| g.set(x, y, 1, Hall::STOOL) }
[9, 10, 11].each { |x| g.door(x, 20, ID[:bryn], 31, 20, 2, name: "Exit") }
g.event(10, 3, "Duvessa", [{ graphic: "FT_speaker_duvessa_shane", direction: 2, script: "FT.gym_leader(:duvessa, @event_id)" }])
g.trainer(2, 13, "BWPoliceman", :bhall_militia_1, :FT_MILITIA, dir: 2, sight: 2)
g.trainer(17, 9, "BWGentleman", :bhall_clerk_2, :GENTLEMAN, dir: 2, sight: 2)
g.trainer(10, 6, "BWPoliceman", :bhall_militia_2, :FT_MILITIA, dir: 2, sight: 1)
g.npc(13, 18, "BW (80)", :bhall_guide, dir: 4)
save(g, :bryn_gym)

# ---------------------------------------------------------------------------
# 2134: the Council Hall. Ten chairs round a long table, a plaque on each: the
# Council of Speakers of Ten-Towns meets here, when there's call to (RotF p. 21).
ch = Builder.new(21, 16, tileset_id: 25)
ch.fill(0, Hall::VOID)
ch.fill(0, Hall::FLOOR, 1, 2, 19, 12)
ch.fill(0, Hall::WALL, 1, 0, 19, 1)
ch.fill(0, Hall::BASE, 1, 1, 19, 1)
ch.fill(0, Hall::FLOOR, 9, 14, 3, 1)
[[2, 0], [17, 0]].each { |x, y| Hall::SHELF.each_with_index { |row, j| row.each_with_index { |tl, i| ch.set(x + i, y + j, 2, tl) } } }
[[5, 6], [7, 6], [9, 6], [11, 6], [13, 6]].each { |x, y| hall_obj(ch, Hall::TABLE, x, y) }   # the long table
[[5, 5], [7, 5], [9, 5], [11, 5], [13, 5], [5, 9], [7, 9], [9, 9], [11, 9], [13, 9]].each { |x, y| ch.set(x + 1, y, 1, Hall::STOOL) }
[9, 10, 11].each { |x| ch.door(x, 15, ID[:bryn], 24, 39, 2, name: "Exit") }
ch.npc(16, 11, "BW (55)", :council_clerk, dir: 4, name: "Council clerk")
ch.sign(10, 1, :council_charter)
ch.sign(12, 6, :council_plaques)
# the morning after lottery night, the speakers are sitting: step in and the session starts
[9, 10, 11].each { |x| ch.event(x, 12, "Council session", [{ trigger: 1, through: true, script: "FT.council_enter(@event_id)" }]) }
save(ch, :council_hall)

# ---------------------------------------------------------------------------
# Targos: the guards at the south-west gate step aside once you hold Naerth's
# seal, and the road beyond leads to Bryn Shander.
targos = load_data(File.join(OUT, "Map2001.rxdata"))
tb = Builder.allocate
tb.instance_variable_set(:@map, targos)
tb.instance_variable_set(:@w, targos.width)
tb.instance_variable_set(:@h, targos.height)
tb.instance_variable_set(:@autotile_fills, [])
tb.instance_variable_set(:@event_template, MapKit.deep_copy(MapKit.load_map(631).events.values.find { |e| e.name == "EV011" }))
tb.instance_variable_set(:@door_template, MapKit.deep_copy(MapKit.load_map(631).events[1]))
targos.events.each_value do |e|
  next unless e.pages[0].list.any? { |cm| cm.code == 355 && cm.parameters[0].to_s.include?(":targos_gate_guard") }
  next if e.pages.size > 1
  e.pages << tb.build_page(e.pages[0], { switch: SW_ROAD_OPEN, graphic: "", through: true })
end
unless targos.events.values.any? { |e| e.name == "To Bryn Shander Road" }
  npc_when(tb, 7, 39, "BWPoliceman", :targos_gate_guard_open, SW_ROAD_OPEN, dir: 6)
  npc_when(tb, 10, 39, "BWPoliceman", :targos_gate_guard_open, SW_ROAD_OPEN, dir: 4)
  [8, 9].each { |x| tb.warp(x, targos.height - 1, ID[:north_road], 1, x == 8 ? 66 : 67, 6, name: "To Bryn Shander Road") }
end
save_data(targos, File.join(OUT, "Map2001.rxdata"))
tb.to_json_file(File.join(OUT, "Map2001.json"))

infos_path = File.join(OUT, "mapinfos.json")
infos = File.exist?(infos_path) ? JSON.parse(File.read(infos_path)) : {}
ID.each { |k, v| infos[v.to_s] = NAMES[k] }
File.write(infos_path, JSON.pretty_generate(infos))
puts "built #{ID.size} maps into #{OUT}"
