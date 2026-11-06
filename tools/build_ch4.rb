# Builds every map for Act I, Chapter 4 (Dougan's Hole): the Eastway out of
# Bryn Shander, Good Mead and its mead hall, the Redwaters shore path, Dougan's
# Hole (after map 1.7 of the book), the Speaker's lodge (Gym 3), Hilda's house,
# the smokehouse, the western tundra and Garagai's ice lodge.
require_relative "ft_common"

ID = {
  eastway: 2030, good_mead: 2031, mead_hall: 2032, cooperage: 2033, redwaters: 2034,
  dougans: 2035, durmoot_lodge: 2036, hilda_house: 2037, smokehouse: 2038, tundra: 2039, ice_lodge: 2040
}
NAMES = {
  eastway: "The Eastway", good_mead: "Good Mead", mead_hall: "Good Mead Mead Hall", cooperage: "Untapoor Cooperage",
  redwaters: "Redwaters Shore", dougans: "Dougan's Hole", durmoot_lodge: "Speaker Durmoot's Lodge",
  hilda_house: "Hilda's House", smokehouse: "The Knucklehead Smokehouse", tundra: "The Western Tundra",
  ice_lodge: "Garagai's Ice Lodge"
}
MUSIC = {
  eastway: "route38_39", good_mead: "safari - Icirrus City Music (HQ)", mead_hall: "Ecruteak City", cooperage: "mom_theme",
  redwaters: "lake_crater", dougans: "Lavender Town", durmoot_lodge: "gym_kanto", hilda_house: "mom_theme",
  smokehouse: "pokecenter", tundra: "strongWind", ice_lodge: "Seafoam Islands Music"
}
BRYN = 2012
SW_REQUIEM_DONE = 3914    # Chapter 3 done: Bryn Shander's east gate opens
SW_DH_WEST_OPEN = 3918    # the Speaker has spoken: the west way out of Dougan's Hole opens
SW_KIDS_FREED   = 3919    # Silja and Finn are out of the cage
SW_KIDS_HOME    = 3920    # back with their mother
SW_DH_BADGE     = 3921    # Durmoot's seal: that night the hag comes
SW_HAG_DOWN     = 3922    # the hag is driven off: the shapes on the ice thaw
SW_NORSU_CALM   = 3923    # Norsu was calmed (or beaten) and lets you be
SW_PACK_GONE    = 3924    # the starving pack was fed (or driven off)
SW_KOBOLDS_GONE = 3925    # the kobolds scurried out of the lodge
SW_WOLVES_GONE  = 3926    # Koran and Kanan beaten on the way home
SW_HAG_NIGHT    = 3933    # you've rested after the seal: that night the hag comes
WOLF = "Followers/ABSOL"
PUP = "Followers/POOCHYENA"
GAUNT = "Followers/MIGHTYENA"
KOBOLD = "Followers/GIBLE"

def save(b, key) = save_map(b, ID[key], MUSIC[key])

def stamp_pine(b, x, y) = tree(b, x, y, 2)

# A dark shape standing silent out on the ice (a figure drawn as a shadow).
def shape(b, x, y, graphic, key, name)
  b.event(x, y, name, [
    { graphic: graphic, direction: 8, opacity: 210, blend_type: 2, step_anime: false, walk_anime: false,
      script: "FT.frozen_shape(:#{key}, @event_id)" },          # what you see up close (notes 04 E12)
    { switch: SW_HAG_DOWN, graphic: graphic, direction: 2, script: "FT.talk(:#{key}, @event_id)" }
  ])
end

# A closed front door: walking into it just tells you so.
def shut_door(b, x, y, key)
  b.event(x, y, "Door #{key}", [{ trigger: 1, script: "FT.talk(:#{key}, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])" }])
end

# ---------------------------------------------------------------------------
# 2030: the Eastway. Out of Bryn Shander's east gate, across open snowfields
# dotted with pines, to a fork: north-east to Easthaven (buried by a slide),
# south to Good Mead.
W, H = 56, 30
e = Builder.new(W, H)
e.fill(0, SNOW)
eopen = {}
carve = ->(x0, y0, w, h) { Builder.rect_cells(x0, y0, w, h).each { |c| eopen[c] = true } }
carve.(0, 10, 22, 9)          # out of the gate
carve.(16, 5, 18, 16)         # the wide snowfield
carve.(30, 9, 18, 10)         # east
carve.(43, 0, 6, 12)          # north-east: towards Easthaven
carve.(41, 17, 8, 13)         # south: to Good Mead
forest_except(e, W, H, eopen)
road = Builder.rect_cells(0, 13, 45, 2) + Builder.rect_cells(44, 2, 2, 13) + Builder.rect_cells(44, 13, 2, 17)
road.each { |x, y| e.set(x, y, 1, PLANK[:c]) if (x + y).odd? || x > 42 } if false   # (left as snow: the road is buried)
grass(e, 4, 16, 7, 2); grass(e, 19, 7, 6, 4); grass(e, 26, 16, 6, 3); grass(e, 36, 10, 4, 4); grass(e, 42, 22, 3, 5)
[[12, 11], [29, 6], [33, 17], [39, 15]].each { |x, y| stamp_pine(e, x, y) }
e.stamp(BOULDER, 23, 13); e.stamp(ICE_BOULDER, 37, 12)
# the slide across the Easthaven road
[[43, 2], [45, 2], [47, 2], [44, 0], [46, 0]].each { |x, y| e.stamp(ICE_BOULDER, x, y) }
[13, 14].each { |y| e.warp(0, y, BRYN, 48, y == 13 ? 22 : 23, 4, name: "To Bryn Shander") }
[44, 45].each { |x| e.warp(x, H - 1, ID[:good_mead], x == 44 ? 16 : 17, 1, 2, name: "To Good Mead") }
e.cutscene(2, 13, :eastway_start)
e.sign(42, 12, :sign_eastway_fork)
e.npc(46, 6, "BW (75)", :easthaven_digger, dir: 8)
e.npc(30, 14, "BWBackpacker_male", :eastway_traveler, dir: 4)
e.trainer(10, 17, "BW029", :ranger_hadd, :POKEMONRANGER_M, dir: 8, sight: 3)
e.trainer(22, 8, "BW (40)", :aurilite_seven, :FT_AURILITE, dir: 2, sight: 4)
e.trainer(28, 17, "BW (72)", :hiker_durn, :HIKER, dir: 4, sight: 3)
e.trainer(38, 11, "BW (75)", :musher_toma, :WORKER, dir: 2, sight: 3)
e.trainer(46, 21, "BW054", :zhent_grisk, :FT_ZHENTARIM, dir: 4, sight: 3)
seal_edges(e)
save(e, :eastway)

# ---------------------------------------------------------------------------
# 2031: Good Mead (map 1.12): squat houses carved with serpents, the two-storey
# mead hall with its wyvern eaves, the Shrine of the Flaming Sword on the
# shore, and Redwaters to the east.
GW, GH = 36, 32
g = Builder.new(GW, GH)
g.fill(0, SNOW)
gshore = ->(y) { 28 - (y > 18 ? (y - 18) / 2 : 0) }
gopen = {}
glake = []
(0...GH).each do |y|
  (0...GW).each do |x|
    if x >= gshore.(y) + 2 then glake << [x, y]; gopen[[x, y]] = true
    elsif x >= 5 && y >= 3 || ([16, 17].include?(x) && y < 3) || (x < 5 && [27, 28].include?(y)) then gopen[[x, y]] = true   # (west: the woods)
    end
  end
end
forest_except(g, GW, GH, gopen)
g.autotile(0, 5, glake)
g.stamp(CABIN, 13, 6)          # the mead hall, door (15, 10)
g.stamp(HUT, 6, 13)            # Untapoor cooperage, door (7, 16)
g.stamp(ROUND_HUT, 22, 17)     # Shrine of the Flaming Sword, door (23, 20)
g.stamp(HUT, 7, 22)            # house, door (8, 25)
g.stamp(HOUSE, 14, 21)         # house, door (15, 25)
[[9, 5], [11, 5]].each { |x, y| g.stamp(HAY, x, y) }   # the hive boxes, banked with straw
[[12, 11], [20, 11], [12, 20], [20, 26]].each { |x, y| g.stamp(LAMP, x, y) }
g.set(18, 14, 2, CRATE); g.set(19, 14, 2, CRATE)        # empty mead casks
(gshore.(24)..gshore.(24) + 4).each { |x| g.set(x, 24, 1, PLANK[:c]) }   # a jetty
g.door(15, 10, ID[:mead_hall], 5, 11, 8, name: "Door Mead Hall")
g.door(7, 16, ID[:cooperage], 9, 11, 8, name: "Door Cooperage")
shut_door(g, 23, 20, :shrine_flaming_sword)
shut_door(g, 8, 25, :gm_door_closed)
shut_door(g, 15, 25, :gm_door_closed)
[16, 17].each { |x| g.warp(x, 0, ID[:eastway], x == 16 ? 44 : 45, H - 2, 8, name: "To the Eastway") }
[20, 21].each { |x| g.warp(x, GH - 1, ID[:redwaters], x == 20 ? 14 : 15, 1, 2, name: "To Redwaters Shore") }
g.cutscene(16, 2, :good_mead_arrival)
[27, 28].each { |y| g.warp(0, y, 2132, 38, y - 7, 4, name: "To the woods") }          # "The Mead Must Flow" (build_tentowns.rb)
[27, 28].each { |y| g.event(2, y, "Home with the mead", [{ trigger: 1, through: true, script: "FT.mead_homecoming(@event_id)" }]) }
npc_when(g, 20, 23, "BW (77)", :gm_new_speaker, 4079, dir: 2, name: "Logger (the election)")
g.event(9, 19, "Gossip", [{ graphic: "BW (38)", direction: 6, script: "FT.gm_gossip(@event_id)" }])
g.sign(18, 4, :sign_good_mead)
g.npc(10, 8, "BW (54)", :gm_beekeeper, dir: 2)
g.npc(24, 23, "BWHiker", :shandar_froth, dir: 4, name: "Shandar Froth")
g.npc(19, 18, "BW (38)", :gm_townsfolk, move: 1)
g.npc(11, 27, "BW (75)", :fef_moryn, dir: 6, name: "Fef Moryn")
g.event(12, 27, "Fef's fox", [{ graphic: "Followers/VULPIX", direction: 4, step_anime: true, script: "FT.talk(:fef_fox, @event_id)" }])
seal_edges(g)
save(g, :good_mead)

# 2032: the mead hall: warmth, beds by the hive room, and a shop
mh, ex = Builder.from_existing(768)
exits_to(mh, ex, ID[:good_mead], 15, 11)
mh.event(3, 6, "Brewmistress", [{ graphic: "BW (59)", direction: 6, script: "FT.mead_hall_rest(@event_id)" }])
mh.event(13, 5, "Cask seller", [{ graphic: "BW (85)", direction: 4, script: "FT.mart(:good_mead, @event_id)" }])
mh.npc(10, 8, "BW (54)", :mead_drinker, dir: 2)
mh.npc(7, 10, "BW (62)", :mead_hive_keeper, dir: 8)
save(mh, :mead_hall)

# 2033: the Untapoor cooperage (Olivessa makes the casks)
co, ex = Builder.from_existing(644)
exits_to(co, ex, ID[:good_mead], 7, 17)
co.npc(13, 7, "BW (56)", :olivessa_untapoor, dir: 4, name: "Olivessa Untapoor")
co.npc(7, 6, "BW (16)", :cooper_apprentice, dir: 2)
save(co, :cooperage)

# ---------------------------------------------------------------------------
# 2034: Redwaters Shore. South from Good Mead between the pines and the frozen
# lake. Far out on the ice, something stands very still.
RW, RH = 32, 56
r = Builder.new(RW, RH)
r.fill(0, SNOW)
rshore = ->(y) { (21 + 3 * Math.sin(y / 7.0)).round }
ropen = {}
rlake = []
(0...RH).each do |y|
  (0...RW).each do |x|
    if x >= rshore.(y) + 1 then rlake << [x, y]; ropen[[x, y]] = true
    elsif x >= rshore.(y) - 9 then ropen[[x, y]] = true
    end
  end
end
[14, 15].each { |x| (0..3).each { |y| ropen[[x, y]] = true } }
[14, 15].each { |x| (RH - 4...RH).each { |y| ropen[[x, y]] = true } }
forest_except(r, RW, RH, ropen)
r.autotile(0, 5, rlake)
floe = Builder.rect_cells(27, 30, 2, 2)
floe.each { |x, y| r.set(x, y, 1, 504 + (y % 4) * 8 + x % 4) }
grass(r, rshore.(8) - 8, 6, 4, 4); grass(r, rshore.(20) - 7, 18, 4, 5); grass(r, rshore.(36) - 8, 34, 5, 4); grass(r, rshore.(46) - 7, 45, 4, 4)
r.stamp(ICE_BOULDER, rshore.(25) - 3, 25); r.stamp(BOULDER, rshore.(40) - 6, 40)
[14, 15].each { |x| r.warp(x, 0, ID[:good_mead], x == 14 ? 20 : 21, GH - 2, 8, name: "To Good Mead") }
[14, 15].each { |x| r.warp(x, RH - 1, ID[:dougans], x == 14 ? 40 : 41, 1, 2, name: "To Dougan's Hole") }
r.event(27, 30, "Far shape", [
  { graphic: "BWFisherman", direction: 8, opacity: 210, blend_type: 2, step_anime: false, walk_anime: false },
  { switch: SW_HAG_DOWN, graphic: "", through: true }
])
r.sign(rshore.(5) - 2, 5, :sign_redwaters)
r.npc(rshore.(28) - 1, 28, "BWFisherman", :redwaters_icefisher, dir: 6)
r.trainer(rshore.(12) - 3, 12, "BW056", :fisher_vash, :FISHERMAN, dir: 4, sight: 3)
r.trainer(rshore.(22) - 6, 22, "BW (33)", :skater_lys, :BEAUTY, dir: 6, sight: 3)
r.trainer(rshore.(31) - 7, 31, "BW (40)", :aurilite_eight, :FT_AURILITE, dir: 6, sight: 4)
r.trainer(rshore.(39) - 2, 39, "BW (72)", :trapper_birk, :HIKER, dir: 4, sight: 3)
r.trainer(rshore.(49) - 5, 49, "BW (40)", :channeler_mag, :CHANNELER, dir: 6, sight: 3)
seal_edges(r)
save(r, :redwaters)

# ---------------------------------------------------------------------------
# 2035: Dougan's Hole, after map 1.7: a tight cluster of houses on the north-
# west shore of Redwaters, the Speaker's lodge among them, a long pier out
# into the ice, and in the south-west, the Twenty Stones of Thruun. The way
# in from Good Mead is at the north-east; the way west is onto the tundra.
DW, DH = 52, 46
d = Builder.new(DW, DH)
d.fill(0, SNOW)
lake_y = ->(x) { 47 - 1.05 * (x - 14) }       # the shoreline runs south-west to north-east
dopen = {}
ice = []
water = []
(0...DH).each do |y|
  (0...DW).each do |x|
    dopen[[x, y]] = true
    ly = lake_y.(x)
    if y > ly + 6 then water << [x, y]
    elsif y > ly then ice << [x, y]
    end
  end
end
# woods in the north-west corner and along the top
wood = {}
(0...DW).each { |x| (0...DH).each { |y| wood[[x, y]] = true if (y < 3 && x < 36) || (x < 3 && y < 16) || (x < 8 && y < 6) } }
dopen.each_key { |c| dopen[c] = false if wood[c] }
[40, 41].each { |x| (0..3).each { |y| dopen[[x, y]] = true } }
forest_except(d, DW, DH, dopen)
d.autotile(0, 5, water)
ice.each { |x, y| d.set(x, y, 0, 504 + (y % 4) * 8 + x % 4) }
# the pier, out from the bottom of the main street
pier = Builder.rect_cells(33, 16, 2, 19) + Builder.rect_cells(31, 34, 6, 2)
ice_at = {}
ice.each { |c| ice_at[c] = true }
pier.each do |x, y|
  d.set(x, y, 1, PLANK[:c])
  d.set(x, y, 0, SNOW) if ice_at[[x, y]]     # no sliding along the boards (the game reads the ice under them)
end
d.sign(34, 31, :dh_pier)        # RotF: the buckled pier, and the two keelboats locked in the ice
# the main street (packed boards) from the north-east road down to the pier
street = Builder.rect_cells(24, 14, 16, 2) + Builder.rect_cells(38, 2, 2, 12)
street.each { |x, y| d.set(x, y, 1, PLANK[:c]) }
d.stamp(HOUSE, 13, 6)           # the Speaker's lodge, door (14, 10)
d.stamp(HUT, 20, 8)             # Hilda's house, door (21, 11)
d.stamp(CABIN, 24, 17)          # the smokehouse, door (26, 21)
d.stamp(HUT, 27, 4)             # door (28, 7)
d.stamp(ROUND_HUT, 32, 7)       # door (33, 10)
d.stamp(HUT, 6, 12)             # door (7, 15)
d.stamp(ROUND_HUT, 12, 15)      # door (13, 18)
d.stamp(HUT, 18, 20)            # door (19, 23)
d.stamp(HUT, 41, 7)             # door (42, 10)
d.stamp(ROUND_HUT, 45, 3)       # door (46, 6)
d.stamp(ROUND_HUT, 21, 2)       # door (22, 5)
d.stamp(HUT, 8, 6)              # door (9, 9)
d.stamp(HUT, 13, 20)            # door (14, 23)
d.stamp(HUT, 23, 24)            # door (24, 27)
[[23, 13], [35, 13], [30, 20], [11, 11]].each { |x, y| d.stamp(LAMP, x, y) }
[[36, 18], [29, 24]].each { |x, y| d.stamp(HAY, x, y) }                       # boats hauled up on the shore
d.set(31, 22, 2, CRATE); d.set(36, 21, 2, CRATE)
# the Twenty Stones of Thruun: nineteen in a rough triangle and one at its heart
tri = [[10, 24], [3, 39], [17, 39]]
peri = tri.each_with_index.map { |(ax, ay), i| bx, by = tri[(i + 1) % 3]; [ax, ay, bx, by, Math.hypot(bx - ax, by - ay)] }
total = peri.sum { |q| q[4] }
STONES = (0...19).map do |k|
  dist = total * k / 19.0
  ax, ay, bx, by, len = peri.find { |q| (dist -= q[4]) < 0 || q.equal?(peri.last) }
  t = (dist + len) / len
  [(ax + (bx - ax) * t).round, (ay + (by - ay) * t).round]
end + [[10, 33]]
raise "stones overlap: #{STONES.inspect}" if STONES.uniq.size != 20
STONES.each { |x, y| d.set(x, y, 2, 1336) }   # each stone: an icy menhir
d.door(14, 10, ID[:durmoot_lodge], 10, 15, 8, name: "Door Speaker's Lodge")
d.door(21, 11, ID[:hilda_house], 9, 11, 8, name: "Door Hilda")
d.door(26, 21, ID[:smokehouse], 5, 11, 8, name: "Door Smokehouse")
[[28, 7], [33, 10], [7, 15], [13, 18], [19, 23], [42, 10], [46, 6], [22, 5], [9, 9], [14, 23], [24, 27]].each { |x, y| shut_door(d, x, y, :dh_door_closed) }
[40, 41].each { |x| d.warp(x, 0, ID[:redwaters], x == 40 ? 14 : 15, RH - 2, 8, name: "To Redwaters Shore") }
[20, 21].each { |y| d.warp(0, y, ID[:tundra], 58, y == 20 ? 16 : 17, 4, name: "To the Western Tundra") }
# south, past the Stones, to the Laughing Waste and the chasm (Chapter 5): a
# trapper keeps folk from it until the hag has been driven off
[2, 3].each { |x| d.warp(x, DH - 1, 2041, x == 2 ? 14 : 15, 1, 2, name: "To the Laughing Waste") }
[2, 3].each do |x|
  d.event(x, DH - 3, "Trapper", [
    { graphic: "BW (72)", direction: 2, script: "FT.talk(:dh_south_block, @event_id)" },
    { switch: SW_HAG_DOWN, graphic: "", through: true }
  ])
end
d.cutscene(40, 2, :dougans_arrival)
# the west way out: townsfolk keep everyone in until the Speaker has spoken
[20, 21].each do |y|
  d.event(2, y, "Militia", [
    { graphic: "BW (54)", direction: 6, script: "FT.talk(:dh_militia_block, @event_id)" },
    { switch: SW_DH_WEST_OPEN, graphic: "", through: true }
  ])
end
(0..3).each { |x| [19, 22].each { |y| d.set(x, y, 2, FENCE_H) } }   # a stockade along the west way: only through the gap
npc_when(d, 4, 19, "BW (54)", :dh_militia_open, SW_DH_WEST_OPEN, dir: 2, name: "Militia")
# Koran, the "good" wolf, waits at the edge of town once the way is open
d.event(5, 22, "Koran", [
  { graphic: "", through: true },
  { switch: SW_DH_WEST_OPEN, graphic: WOLF, direction: 4, step_anime: true, script: "FT.koran(@event_id)" },
  { self_switch: "A", graphic: "", through: true }
])
# coming home with the Dejarr siblings
d.event(41, 4, "Cutscene kids_homecoming", [
  {},
  { switch: SW_WOLVES_GONE, trigger: 3, script: "FT.scene(:kids_homecoming, @event_id)" },
  { self_switch: "A" }
])
# that night (after the rest at the smokehouse): the hag at the Stones
d.event(10, 32, "The Hag", [
  { graphic: "", through: true },
  { switch: SW_HAG_NIGHT, graphic: "FT_thredra", direction: 2, script: "FT.hag(@event_id)" },
  { switch: SW_HAG_DOWN, graphic: "", through: true }
])
# her three ice mirrors between the stones (her reflection laughs in each)
[[7, 35], [13, 35], [10, 29]].each_with_index do |(x, y), i|
  d.event(x, y, "Ice mirror #{i + 1}", [
    { graphic: "", through: true },
    { switch: SW_HAG_NIGHT, graphic: "FT_thredra_echo", direction: 2, opacity: 200, step_anime: true, script: "FT.hag_mirror(#{i + 1}, @event_id)" },
    { switch: SW_HAG_NIGHT, self_switch: "A", graphic: "", through: true },
    { switch: SW_HAG_DOWN, graphic: "", through: true }
  ])
end
d.event(40, 4, "Cutscene dh_night", [
  {},
  { switch: SW_HAG_NIGHT, trigger: 3, script: "FT.scene(:dh_night, @event_id)" },
  { self_switch: "A" }
])
# the shapes on the ice: the hag's frozen victims (they thaw when she's gone)
# (each stands on the first row of ice, so once thawed they can be spoken to from the shore)
# (the old man, who drank tea with her, stands where the path south passes: context 04 §3)
[[22, "BWOldMan", :thawed_old_man], [27, "BWFisherman", :thawed_fisher_a], [30, "BW (54)", :thawed_husband],
 [19, "BW (56)", :thawed_woman], [40, "BWFisherman", :thawed_fisher_b]].each do |x, gfx, key|
  shape(d, x, lake_y.(x).floor + 1, gfx, key, "Shape on the ice")
end
# the Wennen camp at the edge of town, with Sephek's ice on a sledge (SC 3.08; they're inside the bubble when it forms)
npc_when(d, 46, 3, "Followers/BUNEARY", :luna_camp_dh, 3964, dir: 4, name: "Luna Carver")
d.sign(39, 5, :sign_dougans)
d.sign(11, 25, :sign_twenty_stones)
d.npc(25, 15, "BW (54)", :dh_chorus_ears, dir: 2)
d.npc(28, 15, "BW (20)", :dh_chorus_teeth, move: 1)
d.npc(17, 13, "BW (56)", :dh_chorus_sister, dir: 6)
d.npc(34, 30, "BWFisherman", :dh_pier_fisher, dir: 4)
d.npc(36, 12, "BWOldWoman", :dh_shapes_talk, dir: 4)
d.trainer(35, 35, "BW056", :fisher_rorik, :FISHERMAN, dir: 4, sight: 2)
# coming out of the Speaker's lodge: Hilda is waiting (context 04 M4-2)
d.event(16, 12, "Cutscene hilda_at_gate", [
  {},
  { switch: SW_DH_WEST_OPEN, trigger: 3, script: "FT.scene(:hilda_at_gate, @event_id)" },
  { self_switch: "A" }
])
# panes of ice standing upright on the lake between the shapes, "like mirrors" (notes 04 E12)
[[26, 35], [29, 33], [32, 30], [35, 28]].each do |x, y|
  d.event(x, y, "Ice pane", [
    { graphic: "", tile_id: 1336, script: "FT.talk(:dh_ice_pane, @event_id)" },
    { switch: SW_HAG_DOWN, graphic: "", through: true }
  ])
end
seal_edges(d)
save(d, :dougans)

# 2037: Hilda's house
hh, ex = Builder.from_existing(644)
exits_to(hh, ex, ID[:dougans], 21, 12)
hh.event(13, 7, "Hilda", [{ graphic: "BW (56)", direction: 4, script: "FT.hilda(@event_id)" }])
npc_when(hh, 7, 6, "BW (17)", :silja_home, SW_KIDS_HOME, dir: 2, name: "Silja")
npc_when(hh, 9, 6, "BW (16)", :finn_home, SW_KIDS_HOME, dir: 2, name: "Finn")
save(hh, :hilda_house)

# 2038: the smokehouse (warmth, a bed, knucklehead trout and a few supplies)
sm, ex = Builder.from_existing(768)
exits_to(sm, ex, ID[:dougans], 26, 22)
sm.event(3, 6, "Smoker", [{ graphic: "BWOldMan", direction: 6, script: "FT.smokehouse_rest(@event_id)" }])
sm.event(13, 5, "Trader", [{ graphic: "BW (85)", direction: 4, script: "FT.mart(:dougans, @event_id)" }])
sm.npc(10, 8, "BWFisherman", :smoke_fisher, dir: 2)
sm.npc(7, 10, "BW (62)", :smoke_trout_wife, dir: 8)
save(sm, :smokehouse)

# ---------------------------------------------------------------------------
# 2036: the Speaker's lodge (Gym 3). A long trappers' hall: furs, traps and
# drying racks in rows, a trapper at each gap, and Edgra Durmoot at the back.
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

dl = Builder.new(21, 17, tileset_id: 25)
dl.fill(0, Hall::VOID)
dl.fill(0, Hall::FLOOR, 1, 2, 19, 13)
dl.fill(0, Hall::WALL, 1, 0, 19, 1)
dl.fill(0, Hall::BASE, 1, 1, 19, 1)
dl.fill(0, Hall::FLOOR, 9, 15, 3, 1)
[[2, 0], [17, 0]].each { |x, y| Hall::SHELF.each_with_index { |row, j| row.each_with_index { |tl, i| dl.set(x + i, y + j, 2, tl) } } }
[[5, 4], [14, 4]].each { |x, y| hall_obj(dl, Hall::TABLE, x, y) }
hall_line(dl, 1, 7, 11, [Hall::CRATE, Hall::BOXES, Hall::CANS])           # gap at x 8-12
hall_line(dl, 13, 19, 11, [Hall::CANS, Hall::CRATE, Hall::BOXES])
hall_line(dl, 4, 19, 7, [Hall::BOXES, Hall::CRATE, Hall::CANS, Hall::CRATE]) # gap at x 1-3
[[5, 14], [15, 14], [3, 9], [17, 9], [6, 5], [14, 5]].each { |x, y| dl.set(x, y, 1, Hall::STOOL) }
[9, 10, 11].each { |x| dl.door(x, 16, ID[:dougans], 14, 11, 2, name: "Exit") }
dl.event(10, 3, "Durmoot", [{ graphic: "BWOldWoman", direction: 2, script: "FT.gym_leader(:durmoot, @event_id)" }])
# The trappers are out on the ice line hunting wolves until the children are
# home; then they're back, and they test anyone who wants the Speaker's seal.
def trapper_when_home(b, x, y, key, dir, sight)
  ev = b.trainer(x, y, "BW (72)", key, :FT_TRAPPER, dir: dir, sight: sight)
  cond = ev.pages[0].condition
  cond.instance_variable_set(:@switch1_valid, true)
  cond.instance_variable_set(:@switch1_id, SW_KIDS_HOME)
  ev.pages.unshift(b.build_page(ev.pages[0], { graphic: "", through: true }))
  ev
end
trapper_when_home(dl, 8, 12, :trapper_brann, 6, 2)
trapper_when_home(dl, 2, 9, :trapper_holt, 2, 2)
trapper_when_home(dl, 12, 5, :trapper_ysa, 4, 2)
dl.npc(14, 14, "BW (54)", :dh_lodge_guide, dir: 4)
save(dl, :durmoot_lodge)

# ---------------------------------------------------------------------------
# 2039: the western tundra. Open white country under a blizzard; a starving
# pack prowls the middle; Garagai's ice lodge rises at the far west, with a
# remorhaz tunnel coming out on its south side.
TW, TH = 60, 34
t = Builder.new(TW, TH)
t.fill(0, SNOW)
topen = {}
(0...TW).each { |x| (0...TH).each { |y| topen[[x, y]] = true if y >= 4 && y <= TH - 4 || ([58, 59].include?(x) && [16, 17].include?(y)) } }
forest_except(t, TW, TH, topen)
# the lodge: a great dome of ice (x 3-18, y 6-24); openings on its east face
ICEWALL = { nw: 395, n: 396, ne: 397, w: 403, c: 404, e: 405, sw: 411, s: 412, se: 413 }
dome = []
(3..18).each { |x| (6..24).each { |y| dome << [x, y] if ((x - 10.5) / 8.2)**2 + ((y - 15) / 9.6)**2 <= 1 } }
t.nine_blob(1, ICEWALL, dome)
dome.each { |x, y| if t.get(x, y, 1) == ICEWALL[:c] then t.set(x, y, 1, 0); t.set(x, y, 0, 8426) end }
t.set(18, 15, 1, 0)                                                  # the tall opening on the east face
t.stamp(CAVE, 9, 23)                                                 # the remorhaz hole on the south side, mouth (10, 25)
[[26, 8], [34, 22], [44, 9], [50, 24], [22, 25], [39, 14]].each { |x, y| t.stamp(ICE_BOULDER, x, y) }
[[30, 5], [46, 26], [24, 12]].each { |x, y| stamp_pine(t, x, y) }
grass(t, 28, 18, 6, 4); grass(t, 40, 6, 5, 4); grass(t, 47, 18, 5, 4); grass(t, 21, 6, 4, 3)
[16, 17].each { |y| t.warp(TW - 1, y, ID[:dougans], 1, y == 16 ? 20 : 21, 6, name: "To Dougan's Hole") }
t.door(18, 15, ID[:ice_lodge], 36, 14, 4, name: "Door Ice Lodge")
t.door(10, 25, ID[:ice_lodge], 33, 25, 8, name: "Door Remorhaz Tunnel")
t.cutscene(57, 16, :tundra_start)
# the starving pack, across the way in the middle of the tundra
[[31, 14], [32, 16], [31, 18], [30, 16]].each_with_index do |(x, y), i|
  t.event(x, y, "Starving wolf", [
    { graphic: i == 3 ? GAUNT : PUP, direction: 4, script: "FT.starving_pack(@event_id)" },
    { switch: SW_PACK_GONE, graphic: "", through: true }
  ])
end
# Koran and Kanan, waiting when you come out with the children
[[22, 14], [22, 17]].each_with_index do |(x, y), i|
  t.event(x, y, i == 0 ? "Koran" : "Kanan", [
    { graphic: "", through: true },
    { switch: SW_KIDS_FREED, graphic: WOLF, direction: 4, script: "FT.wolves_ambush(@event_id)" },
    { switch: SW_WOLVES_GONE, graphic: "", through: true }
  ])
end
(4..30).each do |y|
  t.event(24, y, "Ambush", [
    { through: true },
    { switch: SW_KIDS_FREED, trigger: 1, through: true, script: "FT.wolves_ambush(@event_id)" },
    { switch: SW_WOLVES_GONE, through: true }
  ])
end
t.trainer(42, 12, "BW (40)", :aurilite_nine, :FT_AURILITE, dir: 4, sight: 4)
t.trainer(46, 21, "BW (72)", :hunter_ulf, :HIKER, dir: 4, sight: 3)
t.sign(55, 15, :sign_tundra)
seal_edges(t)
save(t, :tundra)

# ---------------------------------------------------------------------------
# 2040: Garagai's ice lodge (map 1.8): walls of ice thirty feet high. The
# entrance corridor (L4) from the east; the oval tomb in the middle (L5) where
# Norsu mourns his master; the flensing chamber (L2) and the cage (L3) to the
# north; the war room (L6) and the whale-oil store (L8) to the south, where
# the remorhaz tunnel leads back out.
LW, LH = 40, 30
l = Builder.new(LW, LH)
l.fill(0, SNOW)
floor = {}
lc = ->(x0, y0, w, h) { Builder.rect_cells(x0, y0, w, h).each { |c| floor[c] = true } }
(13..27).each { |x| (8..20).each { |y| floor[[x, y]] = true if ((x - 20) / 7.6)**2 + ((y - 14) / 6.6)**2 <= 1 } }   # L5 the tomb
lc.(27, 13, 11, 3)            # L4 the entrance corridor
lc.(29, 3, 8, 7)              # L2 flensing chamber
lc.(31, 9, 3, 5)              #    its passage
lc.(4, 3, 8, 7)               # L3 the cage
lc.(9, 9, 6, 3)               #    its passage
lc.(4, 18, 8, 8)              # L6 the war room
lc.(10, 19, 7, 3)             #    its passage
lc.(29, 18, 8, 8)             # L8 whale-oil store
lc.(25, 17, 5, 3)             #    its passage
lc.(33, 26, 2, 4)             #    the remorhaz tunnel
wall = []
(0...LW).each { |x| (0...LH).each { |y| wall << [x, y] unless floor[[x, y]] } }
l.nine_blob(1, ICEWALL, wall, solid: ->(x, y) { x < 0 || y < 0 || x >= LW || y >= LH })
INNER = { se: 387, sw: 389, ne: 419, nw: 421 }
SOLID_ICE = 8426                                   # deep ice: solid, drawn on the ground layer
wall.each do |x, y|
  next unless l.get(x, y, 1) == ICEWALL[:c]
  corner = INNER.find { |k, _tl| dx = k.to_s.include?("e") ? 1 : -1; dy = k.to_s.include?("s") ? 1 : -1; floor[[x + dx, y + dy]] }
  l.set(x, y, 1, corner ? corner[1] : 0)
  l.set(x, y, 0, SOLID_ICE) unless corner
end
# icicles in the entrance corridor; ice furniture
[[30, 13], [33, 15], [36, 13]].each { |x, y| l.set(x, y, 2, 476) }
l.stamp(ICE_BOULDER, 6, 21)                       # the war-room table
[[5, 20], [9, 20], [5, 24], [9, 24]].each { |x, y| l.set(x, y, 2, 477) }   # chipped ice chairs
[[30, 19], [31, 19], [35, 19], [30, 23], [35, 23]].each { |x, y| l.set(x, y, 2, CRATE) }   # barrels of whale oil
FENCE_POST = FENCE_V
[[5, 4], [6, 4], [7, 4], [8, 4], [5, 7], [6, 7], [8, 7]].each { |x, y| l.set(x, y, 2, FENCE_H) }  # the cage: slats of black iron
[[5, 5], [5, 6], [8, 5], [8, 6]].each { |x, y| l.set(x, y, 2, FENCE_POST) }
l.door(37, 14, ID[:tundra], 19, 15, 6, name: "Exit")
[33, 34].each { |x| l.door(x, LH - 1, ID[:tundra], 10, 26, 2, name: "Exit tunnel") }
l.cutscene(36, 14, :lodge_enter)
# L5: Garagai in his tomb of ice; Norsu beside him; the throne
l.event(17, 14, "Garagai", [{ graphic: "BW (72)", direction: 2, opacity: 160, blend_type: 2, step_anime: false, walk_anime: false,
                              script: "FT.talk(:garagai_tomb, @event_id)" }])
l.event(19, 12, "Norsu", [
  { graphic: "Followers/MAMOSWINE", direction: 4, script: "FT.norsu(@event_id)" },
  { switch: SW_NORSU_CALM, graphic: "Followers/MAMOSWINE", direction: 4, script: "FT.talk(:norsu_calm, @event_id)" }
])
l.stamp(ICE_BOULDER, 14, 9)
l.sign(15, 11, :ice_throne)
(8..20).select { |y| floor[[24, y]] }.map { |y| [24, y] }.each do |x, y|
  l.event(x, y, "Norsu wakes", [
    { trigger: 1, through: true, script: "FT.norsu_notice(@event_id)" },
    { self_switch: "A", through: true }
  ])
end
# L2: the flensing chamber
l.event(31, 5, "Whale", [{ graphic: "Followers/WAILORD", direction: 2, step_anime: false, walk_anime: false, script: "FT.talk(:flensing_whale, @event_id)" }])
l.sign(34, 4, :flensing_knife)
l.event(35, 8, "Stone chest", [
  { graphic: "", tile_id: 1056, script: "FT.lodge_chest(@event_id)" },
  { self_switch: "A", graphic: "", tile_id: 1056, script: "FT.talk(:stone_chest_empty, @event_id)" }
])
# L3: the cage
l.event(6, 5, "Silja", [
  { graphic: "BW (17)", direction: 2, script: "FT.cage(@event_id)" },
  { switch: SW_KIDS_FREED, graphic: "", through: true }
])
l.event(7, 5, "Finn", [
  { graphic: "BW (16)", direction: 2, script: "FT.cage(@event_id)" },
  { switch: SW_KIDS_FREED, graphic: "", through: true }
])
l.event(7, 7, "Cage gate", [
  { graphic: "", tile_id: FENCE_H, through: false, script: "FT.cage(@event_id)" },
  { switch: SW_KIDS_FREED, graphic: "", through: true }
])
# L6: the war room, three kobolds hiding behind the chairs
[[4, 19, "Holgi"], [10, 23, "Snorp"], [5, 25, "Zilbo"]].each do |x, y, n|
  l.event(x, y, n, [
    { graphic: KOBOLD, direction: 2, script: "FT.kobolds(@event_id)" },
    { switch: SW_KOBOLDS_GONE, graphic: "", through: true }
  ])
end
l.sign(8, 20, :chwinga_statuette)
# L8: whale oil, and the frosted residue in the remorhaz tunnel
l.event(32, 21, "Whale oil", [
  { graphic: "", tile_id: CRATE, script: "FT.whale_oil(@event_id)" }
])
l.sign(35, 25, :thrym_residue)
save(l, :ice_lodge)

# ---------------------------------------------------------------------------
# Bryn Shander: the east gate leads onto the Eastway.
bryn = reopen(BRYN)
unless has_event?(bryn, "To the Eastway")
  (45..49).each { |x| [22, 23].each { |y| bryn.set(x, y, 2, 0); bryn.set(x, y, 1, PLANK[:c]) } }   # the road out under the pines
  [22, 23].each { |y| bryn.warp(49, y, ID[:eastway], 1, y == 22 ? 13 : 14, 6, name: "To the Eastway") }
end
resave(bryn, BRYN)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT}"
