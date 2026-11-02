# Builds every map for Act I, Chapter 1 (The Convergence, Targos).
# Output: ../build/maps/MapNNNN.rxdata (+ .json previews) and ../build/maps/mapinfos.json
require_relative "ft_common"

# (OUT comes from ft_common)
Dir.mkdir(OUT) unless Dir.exist?(OUT)

ID = {
  intro: 2000, targos: 2001, tavern: 2002, center: 2003, luskan: 2004, gym: 2005,
  hut_a: 2006, mart: 2007, hut_b: 2008, hut_c: 2009
}
NAMES = {
  intro: "Frost & Thaw", targos: "Targos", tavern: "Three Flags Sailing", center: "Targos Pokémon Center",
  luskan: "The Luskan Arms", gym: "Speaker's Hall", hut_a: "Thornweald's Relics", mart: "Triglio",
  hut_b: "Fisher's Cottage", hut_c: "Lantern House"
}
# Switches the scripts turn on when the player IS that Herald (hides the NPC).
SW = { alberica: 3901, reptin: 3902, alerion: 3903, meat_meat: 3904, wyn: 3905 }
SW_PARTY_FORMED = 3961   # the Heralds have met (SC 1.03)
SW_NAERTH_TERMS = 3963   # Naerth has set his terms at the Luskan Arms (SC 1.05)

# Music: cold and quiet for the Dale; the story code sets the intro's music itself.
MUSIC = {
  intro: nil,
  # Act I is a town dying under an endless winter: everything leans melancholy.
  targos: "mountsilver",
  tavern: "Lostlorn Forest",
  center: "pokecenter",                     # the one warm, safe place
  luskan: "Pokemon RBY - Team Rocket Hideout -Jazz Arrange-",
  gym: "gym_kanto",
  hut_a: "sinjoh",                          # Epheris's relics: old, strange magic
  mart: "Ecruteak City",
  hut_b: "lake_crater",
  hut_c: "Lavender Town",
}

def save(b, key)
  b.music(MUSIC[key]) if MUSIC.key?(key)
  b.save(File.join(OUT, format("Map%04d.rxdata", ID[key])))
  b.to_json_file(File.join(OUT, format("Map%04d.json", ID[key])))
end

# Points every original exit of a copied interior back to Targos.
def exits_to(b, exits, x, y)
  exits.each { |ex, ey| b.door(ex, ey, ID[:targos], x, y, 2, name: "Exit") }
end

# ---------------------------------------------------------------------------
# 2000: the intro void (setup happens here, then the game moves you on)
intro = Builder.new(20, 15, tileset_id: 25)
intro.cutscene(0, 0, :intro)
save(intro, :intro)

# ---------------------------------------------------------------------------
# 2001: Targos, after map 1.16 of the book. A log palisade rings the town and
# its harbor: the bay of Maer Dualdon opens to the north-east inside the wall,
# lined with docks, and the town fills the land to the west and south. The
# Town Hall stands at the top of the main street; Three Flags Sailing on the
# west shore of the bay; the Luskan Arms (Naerth's residence) on the south
# shore. The road to Bryn Shander leaves through the south-west gate.
W, H = 48, 44
b = Builder.new(W, H)
b.fill(0, SNOW)
CX, CY, R = 33, 13, 12.5
bay = ->(x, y) { (x - CX)**2 + ((y - CY) * 1.05)**2 <= R**2 || (y <= 3 && x >= 27 && x <= 39) }
inside = ->(x, y) { x >= 3 && x <= W - 4 && y >= 3 && y <= H - 4 && (x + y >= 9) && (W - 1 - x + y >= 9) && (x + H - 1 - y >= 9) && (W - 1 - x + H - 1 - y >= 9) }
topen = {}
water = []
(0...W).each do |x|
  (0...H).each do |y|
    if bay.(x, y)
      water << [x, y]; topen[[x, y]] = true
    elsif inside.(x, y)
      topen[[x, y]] = true
    end
  end
end
[8, 9].each { |x| (H - 4...H).each { |y| topen[[x, y]] = true } }      # out through the south-west gate
forest_except(b, W, H, topen)
b.autotile(0, 5, water)
# the palisade: every cell on the edge of the walled area (water edge included, as a breakwater),
# with the gate on the south side and the ships' gap at the top of the bay
ring = []
(0...W).each do |x|
  (0...H).each do |y|
    next unless inside.(x, y)
    edge = [[1, 0], [-1, 0], [0, 1], [0, -1]].any? { |dx, dy| !inside.(x + dx, y + dy) }
    next unless edge
    next if y == H - 4 && [8, 9].include?(x)                       # south-west gate
    next if y <= 3 && x >= 28 && x <= 38                            # where ships come in
    ring << [x, y]
  end
end
ring.each { |x, y| b.set(x, y, 1, bay.(x, y) ? PLANK[:c] : FENCE_H) }
ring.select { |x, y| bay.(x, y) }.each { |x, y| b.set(x, y, 2, FENCE_H) }
# docks: a boardwalk along the bay's west and south shores, piers out into the water
(0...W).each do |x|
  (0...H).each do |y|
    next if bay.(x, y) || !inside.(x, y)
    near = [[1, 0], [-1, 0], [0, 1], [0, -1]].any? { |dx, dy| bay.(x + dx, y + dy) }
    b.set(x, y, 1, PLANK[:c]) if near && x < 44 && y > 4
  end
end
PIERS = [[[21, 8], 1, 0, 5], [[21, 12], 1, 0, 6], [[21, 16], 1, 0, 5], [[27, 24], 0, -1, 5], [[33, 26], 0, -1, 8], [[39, 23], 0, -1, 5]]
PIERS.each do |(x0, y0), dx, dy, len|
  len.times { |i| b.set(x0 + dx * i, y0 + dy * i, 1, PLANK[:c]) }
end
streets = []
streets += Builder.rect_cells(8, 13, 2, 28)                          # main street: gate to Town Hall
streets += Builder.rect_cells(4, 19, 17, 2)                          # cross street to the docks
streets += Builder.rect_cells(10, 30, 22, 2)                         # lower street to the Luskan Arms
streets.each { |x, y| b.set(x, y, 1, PLANK[:c]) }
b.stamp(GYM, 5, 6)             # Town Hall, door (8, 12)
b.stamp(CABIN, 13, 13)         # Three Flags Sailing, door (15, 17)
b.stamp(CABIN, 23, 26)         # the Luskan Arms, door (25, 30)
b.stamp(HOUSE, 3, 22)          # Triglio, door (4, 26)
b.stamp(CENTER, 11, 21)        # Pokemon Center, door (14, 27)
b.stamp(HUT, 3, 31)            # Thornweald's Relics, door (4, 34)
b.stamp(HUT, 33, 31)           # Fisher's Cottage, door (34, 34)
b.stamp(ROUND_HUT, 15, 34)     # Lantern House, door (16, 37)
b.stamp(HOUSE, 40, 30)         # the Velryn house (Keegan and Garret), door (41, 34)
[[7, 18], [10, 18], [7, 29], [10, 29], [20, 21], [30, 29], [20, 32]].each { |x, y| b.stamp(LAMP, x, y) }
b.stamp(HAY, 18, 22); b.stamp(HAY, 18, 24)                          # Meat Meat's hiding place
[[26, 23], [37, 22], [20, 7], [40, 28]].each { |x, y| b.set(x, y, 2, CRATE) }
boat = Stamp.tileset(:sailboat, 64, 0, 5, 5)
b.stamp(boat, 29, 9)          # moored out in the bay, away from the piers
b.stamp(boat, 35, 12)
b.door(8, 12, ID[:gym], 10, 19, 8, name: "Door Town Hall")
b.door(15, 17, ID[:tavern], 5, 11, 8, name: "Door Three Flags Sailing")
b.door(25, 30, ID[:luskan], 9, 11, 8, name: "Door Luskan Arms")
b.door(4, 26, ID[:mart], 6, 12, 8, name: "Door Triglio")
b.door(14, 27, ID[:center], 10, 11, 8, name: "Door Pokemon Center")
b.door(4, 34, ID[:hut_a], 9, 11, 8, name: "Door Thornweald")
b.door(34, 34, ID[:hut_b], 9, 11, 8, name: "Door Fisher's Cottage")
b.door(16, 37, ID[:hut_c], 9, 11, 8, name: "Door Lantern House")
b.door(41, 34, 2124, 9, 11, 8, name: "Door Velryn")
# "Mountain Climb": Boy, Garret Velryn's sled dog, runs loose in the streets with a broken harness
b.event(18, 30, "Boy", [
  { graphic: "Followers/MIGHTYENA", direction: 4, move_type: 1, move_frequency: 5, move_speed: 4, step_anime: true,
    script: "FT.boy_sled_dog(@event_id)" },
  { switch: 4043, graphic: "", through: true }
])
b.cutscene(33, 20, :targos_arrival)                                    # the ship docks at the long pier
b.npc(8, H - 4, "BWPoliceman", :targos_gate_guard, dir: 2)
b.npc(9, H - 4, "BWPoliceman", :targos_gate_guard, dir: 2)
b.npc(35, 27, "BWFisherman", :orvus_hollowgale, dir: 4)
b.npc(12, 15, "BW (38)", :targos_cold_talk, move: 1)
b.npc(28, 31, "BW (54)", :targos_sacrifice_talk, move: 1)
b.npc(22, 19, "BW (62)", :targos_lake_talk, dir: 6)
b.npc(17, 30, "BW (20)", :targos_child_talk, move: 1)
b.sign(10, 11, :targos_sign_hall)
b.sign(10, 19, :targos_sign_square)
b.sign(W - 6, 36, :targos_termalaine_road)
b.trainer(23, 12, "BWFisherman", :fisher_hob, :FISHERMAN, dir: 4, sight: 3)
b.trainer(39, 25, "BWSailor", :sailor_brannoc, :SAILOR, dir: 8, sight: 3)
# The Commons: snowy grazing land with wild Pokémon, so a newcomer can catch a second partner
grass(b, 22, 34, 10, 5)
grass(b, 37, 36, 5, 3)
b.sign(21, 34, :targos_sign_commons)
# The Sparring Ring: a planked yard between the Town Hall and the docks
(12..19).each { |x| (4..10).each { |y| b.set(x, y, 1, PLANK[:c]) } }
[[12, 4], [19, 4], [12, 10], [19, 10]].each { |x, y| b.set(x, y, 1, FENCE_H) }
b.sign(12, 10, :targos_sign_ring)
{ spar_tess: [13, 7, :PICNICKER, 6], spar_brin: [16, 5, :SAILOR, 2], spar_jod: [18, 8, :WORKER, 4] }.each do |key, (x, y, cls, dir)|
  b.event(x, y, "Spar #{key}", [{ graphic: Builder::TRAINER_OW[cls], direction: dir, script: "FT.spar(:#{key}, @event_id)" }])
end
# Kip's Cups: a shell game in the alley between the Pokémon Center and the Luskan Arms
b.event(20, 27, "Kip", [{ graphic: "BWPunkGuy", direction: 2, script: "FT.cup_game(@event_id)" }])
seal_edges(b)
save(b, :targos)

# ---------------------------------------------------------------------------
# 2002: the Three Sails (Celadon Café layout: one whole, warm room)
t, ex = Builder.from_existing(768)
exits_to(t, ex, 15, 18)
t.event(3, 6, "Barkeep", [{ graphic: "BW (53)", direction: 6, script: "FT.barkeep(@event_id)" }])
# The five sit at their tables until they've met (SC 1.03); then they travel with you,
# so their tavern selves are gone (switch 3961).
[t.npc(9, 8, "FT_alberica", :npc_alberica, dir: 2, hide_switch: SW[:alberica], name: "Alberica"),
 t.npc(10, 10, "FT_reptin", :npc_reptin, dir: 4, hide_switch: SW[:reptin], name: "Reptin"),
 t.npc(13, 5, "FT_alerion", :npc_alerion, dir: 4, hide_switch: SW[:alerion], name: "Alerion"),
 t.npc(13, 8, "FT_shade", :npc_shade, dir: 2, name: "Shade"),
 t.npc(15, 10, "FT_shimmer", :npc_shimmer, dir: 4, name: "Shimmer")].each do |e|
  e.pages << t.build_page(e.pages[0], { switch: SW_PARTY_FORMED, graphic: "", through: true })
end
t.trainer(7, 7, "BWBiker", :tavern_brawler, :BIKER, dir: 2, sight: 3)
t.event(6, 8, "Fisher (rumours)", [{ graphic: "BWFisherman", direction: 6, script: "FT.ten_towns_rumor(\"FISHER\", @event_id)" }])
t.cutscene(0, 0, :tavern_convergence)
save(t, :tavern)

# 2003: Pokémon Center (keeps the nurse, PC and healing machine)
c, ex = Builder.from_existing(632, keep: [4, 8, 10])
exits_to(c, ex, 14, 28)
c.event(15, 9, "Trapper", [{ graphic: "BW (35)", direction: 4, script: "FT.snowshoes(@event_id)" }])
save(c, :center)

# 2004: the Luskan Arms (Zhentarim den)
l, ex = Builder.from_existing(428)
exits_to(l, ex, 25, 31)
l.npc(14, 7, "BW (63)", :marek_draeven, dir: 2)
l.trainer(10, 8, "BW (57)", :zhent_thug_1, :ROUGHNECK, dir: 2, sight: 3)
l.trainer(6, 8, "BWPunkGirl", :zhent_thug_2, :ROUGHNECK, dir: 2, sight: 3)
l.npc(5, 8, "BW (26)", :skath, dir: 2)
l.event(12, 8, "Owenn Tarsenel", [{ graphic: "BWOldMan", direction: 4, script: "FT.owenn_tarsenel(@event_id)" }])
l.event(6, 9, "Rat", [{ graphic: "Followers/RATTATA", direction: 2, move_type: 1, move_frequency: 6, move_speed: 5,
                        step_anime: true, through: true, script: "FT.talk(:luskan_rats, @event_id)" }])
l.sign(5, 5, :luskan_decor)
l.sign(9, 5, :naerth_snakes)
# Naerth does business here until he's set his terms (SC 1.05), then waits at the Town Hall.
l.event(8, 6, "Naerth", [{ graphic: "BW_giovanni", direction: 2, script: "FT.naerth_terms(@event_id)" },
                         { switch: SW_NAERTH_TERMS, graphic: "", through: true }])
save(l, :luskan)

# 2005: Speaker's Hall (Gym 1) - Naerth's smoky hall. Rows of tables, crates
# and barrels make walls you weave between; one of his people watches each gap;
# Naerth holds court behind the bar at the very back.
module Hall
  VOID, FLOOR, WALL, BASE = 48, 692, 950, 958
  # [overhang row (drawn over you), footprint rows (solid)] - all 2 tiles wide unless noted
  TABLE = [[1264, 1265], [[1272, 1273], [1280, 1281]]]
  CRATE = [[8114, 8115], [[8122, 8123], [8130, 8131]]]
  BOXES = [[3782, 3783], [[3790, 3791]]]            # one solid row
  CAN   = [[4502], [[4510]]]                        # 1 wide, one solid row
  CANS  = [[4528, 4529], [[4536, 4537]]]            # 2 wide, one solid row
  STOOL = 1836                                      # walkable, decoration
  SHELF = [[8978, 8979], [8986, 8987]]              # bottles on the back wall
  COUNTER = [[2541, 0, 0, 0, 0, 2542],             # the bar (from the Saffron Bar)
             [2552, 2553, 2553, 2553, 2554, 2555],
             [2560, 2561, 2561, 2561, 2562, 2563]]
end

def hall_obj(b, obj, x, y)            # y = first solid row
  over, rows = obj
  over.each_with_index { |t, i| b.set(x + i, y - 1, 2, t) }
  rows.each_with_index { |row, j| row.each_with_index { |t, i| b.set(x + i, y + j, 1, t) } }
end

# A wall of furniture across rows y..y+1, solid from x0 to x1 (inclusive).
def hall_line(b, x0, x1, y, pattern)
  x = x0
  i = 0
  while x <= x1
    obj = pattern[i % pattern.size]
    w = obj[0].size
    w = 1 if x + w - 1 > x1
    obj = Hall::CAN if w == 1
    if obj[1].size == 1               # one-row objects: stack two to fill both rows
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
g.fill(0, Hall::FLOOR, 9, 19, 3, 1)                    # doorway
[[2, 0], [5, 0], [14, 0], [17, 0]].each do |x, y|       # bottles behind the bar
  Hall::SHELF.each_with_index { |row, j| row.each_with_index { |t, i| g.set(x + i, y + j, 2, t) } }
end
Hall::COUNTER.each_with_index { |row, j| row.each_with_index { |t, i| g.set(7 + i, 2 + j, 1, t) if t > 0 } }
Hall::COUNTER[1..2].each_with_index { |row, j| row.each_with_index { |t, i| g.set(7 + i + 6, 3 + j, 1, t) if false } }
# three walls of furniture, the gap alternating right, left, right
hall_line(g, 1, 17, 15, [Hall::TABLE, Hall::CRATE, Hall::CANS, Hall::TABLE, Hall::BOXES, Hall::CRATE])
g.set(19, 15, 1, 4510); g.set(19, 16, 1, 4510); g.set(19, 14, 2, 4502)   # gap at x 18
hall_line(g, 2, 19, 11, [Hall::CRATE, Hall::TABLE, Hall::BOXES, Hall::TABLE, Hall::CANS, Hall::CRATE])
hall_line(g, 1, 18, 7, [Hall::TABLE, Hall::CANS, Hall::CRATE, Hall::TABLE, Hall::BOXES, Hall::TABLE])
# stools along the walkways, for the look of a working bar
[[4, 14], [8, 14], [12, 13], [6, 10], [10, 10], [14, 10], [5, 6], [15, 6], [3, 18], [17, 18]].each { |x, y| g.set(x, y, 1, Hall::STOOL) }
[9, 10, 11].each { |x| g.door(x, 20, ID[:targos], 8, 13, 2, name: "Exit") }
g.event(9, 3, "Naerth", [{ graphic: "", through: true },
                         { switch: SW_NAERTH_TERMS, graphic: "BW_giovanni", direction: 2, script: "FT.gym_leader(:naerth, @event_id)" }])
g.trainer(17, 17, "BW (57)", :hall_enforcer_2, :ROUGHNECK, dir: 6, sight: 1)     # watches the first gap
g.trainer(2, 13, "BW (63)", :hall_enforcer_1, :ROUGHNECK, dir: 4, sight: 1)      # watches the second
g.trainer(18, 9, "BWGentleman", :hall_dealer, :ROUGHNECK, dir: 6, sight: 1)          # watches the third
g.npc(8, 18, "BW (80)", :hall_guide, dir: 6)
save(g, :gym)

# 2006-2009: houses and market
h, ex = Builder.from_existing(644)
exits_to(h, ex, 4, 35)
h.event(13, 7, "Epheris", [{ graphic: "BW (55)", direction: 4, script: "FT.epheris(@event_id)" }])
save(h, :hut_a)

m, ex = Builder.from_existing(81)
exits_to(m, ex, 4, 27)
m.event(6, 6, "Jestin Hunrae", [{ graphic: "BW (85)", direction: 2, script: "FT.jestin_hunrae(@event_id)" }])
m.npc(10, 9, "BW (20)", :market_customer, dir: 6)
m.sign(12, 7, :triglio_sign)
save(m, :mart)

h, ex = Builder.from_existing(644)
exits_to(h, ex, 34, 35)
h.event(7, 6, "Widow", [{ graphic: "BWOldWoman", direction: 2, script: "FT.widow_gift(@event_id)" }])
save(h, :hut_b)

h, ex = Builder.from_existing(644)
exits_to(h, ex, 16, 38)
h.npc(13, 7, "BW (62)", :lantern_mother, dir: 4)
h.npc(7, 6, "BW (16)", :lantern_child, dir: 2)
save(h, :hut_c)

File.write(File.join(OUT, "mapinfos.json"), JSON.pretty_generate(ID.map { |k, v| [v, NAMES[k]] }.to_h))
puts "built #{ID.size} maps into #{OUT}"
