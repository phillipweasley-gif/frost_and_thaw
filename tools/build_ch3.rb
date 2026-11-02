# Builds every map for Act I, Chapter 3 (Shimmer's Requiem): the road north
# from Bryn Shander, Lonelywood on the shore of Maer Dualdon, the Wennen's
# Warren, the Moon Temple (grounds, Zenith Abbott's lodge, the sanctum) and
# the Glade of the Unmade.
require_relative "ft_common"

ID = {
  lonely_road: 2020, lonelywood: 2021, warren: 2022, moon_grounds: 2023, lucky_liar: 2024,
  moon_sanctum: 2025, glade: 2026, speaker_house: 2027, scrimshander: 2028, fisher_house: 2029
}
NAMES = {
  lonely_road: "Lonelywood Road", lonelywood: "Lonelywood", warren: "Wennen's Warren",
  moon_grounds: "Moon Temple", lucky_liar: "The Lucky Liar", moon_sanctum: "Moon Temple Sanctum",
  glade: "Glade of the Unmade", speaker_house: "Speaker Huddle's House", scrimshander: "The Happy Scrimshander",
  fisher_house: "Fisher's House"
}
MUSIC = {
  lonely_road: "Lostlorn Forest", lonelywood: "lake of rage", warren: "New Bark Town",
  moon_grounds: "sinjoh", lucky_liar: "Lostlorn Forest", moon_sanctum: "fullmoonIsland", glade: "newmoonIsland",
  speaker_house: "mom_theme", scrimshander: "Ecruteak City", fisher_house: "Lavender Town"
}
BRYN = 2012
SW_NORTH_OPEN  = 3913     # Sephek walked out the north gate: the road to Lonelywood opens
SW_SEPHEK_DOWN = 3915     # Sephek defeated at the Moon Temple
SW_SHIMMER_TAKEN = 3916   # the night Shimmer is taken: Sephek's tracks, the Wennen scout
SW_REQUIEM_DONE = 3914    # the Moon Requiem is done: the laughing is the calling (SC 3.09), the east gate opens
SW_WENNEN_FOLLOW = 3964   # the Wennen haul Sephek's ice south (SC 3.08)
SW_MEAT_JOINED = 3965     # Meat Meat travels with you
SW_HERALD_MEAT = 3904     # you ARE Meat Meat (Herald Mode)
SW_TORRGA_GONE = 4000     # Torg's is dealt with: Torrga beaten, the camp packed up (044_ChasmFaithful.rb)
SW_HLIN_PAID   = 4001     # Hlin Trollbane has paid out and gone
LOPUNNY = "Followers/LOPUNNY"
BUNEARY = "Followers/BUNEARY"

def save(b, key) = save_map(b, ID[key], MUSIC[key])

# ---------------------------------------------------------------------------
# 2020: Lonelywood Road. North out of Bryn Shander through deep pine, across a
# frozen stream (a log bridge), into the woods around Lonelywood.
W, H = 30, 60
r = Builder.new(W, H)
r.fill(0, SNOW)
open = {}
carve = ->(x0, y0, w, h) { (y0...y0 + h).each { |y| (x0...x0 + w).each { |x| open[[x, y]] = true } } }
carve.(12, 52, 6, 8)         # bottom: from Bryn Shander's north gate
carve.(6, 40, 18, 13)        # first clearing
carve.(4, 30, 8, 11)         # west bend
carve.(4, 24, 22, 7)         # the stream valley
carve.(18, 12, 8, 13)        # east climb
carve.(8, 6, 18, 7)          # top clearing
carve.(12, 0, 6, 7)          # top: Lonelywood
forest_except(r, W, H, open)
r.autotile(0, 5, Builder.rect_cells(4, 26, 22, 3))                     # the stream (ice-skinned water)
[[13, 26], [14, 26], [13, 27], [14, 27], [13, 28], [14, 28]].each { |x, y| r.set(x, y, 1, PLANK[:c]) }  # log bridge
grass(r, 7, 42, 6, 5); grass(r, 15, 45, 7, 5); grass(r, 5, 32, 5, 6); grass(r, 19, 14, 6, 6); grass(r, 9, 7, 5, 4)
r.stamp(ICE_BOULDER, 17, 41); r.stamp(BOULDER, 6, 50); r.stamp(ICE_BOULDER, 22, 7)
[12, 13, 14, 15, 16, 17].each { |x| r.warp(x, H - 1, BRYN, x < 15 ? 22 : 23, 2, 2, name: "To Bryn Shander") }
[12, 13, 14, 15, 16, 17].each { |x| r.warp(x, 0, ID[:lonelywood], 42, x < 15 ? 35 : 36, 4, name: "To Lonelywood") }
r.cutscene(14, 57, :lonely_road_start)
r.trainer(8, 47, "BWBugCatcher_male", :bug_catcher_pell, :BUGCATCHER, dir: 6, sight: 4)
r.trainer(20, 43, "BW (33)", :lady_maren, :BEAUTY, dir: 4, sight: 3)
r.trainer(8, 34, "BWHiker", :hiker_osk, :HIKER, dir: 2, sight: 4)
r.trainer(21, 18, "BW (107)", :aurilite_four, :FT_AURILITE, dir: 4, sight: 4)
r.trainer(11, 9, "BWRanger_female", :ranger_tamsa, :POKEMONRANGER_F, dir: 6, sight: 3)
r.npc(17, 30, "BW (77)", :lonely_road_woodcutter, dir: 2)
r.sign(15, 55, :sign_lonely_road)
r.sign(16, 29, :sign_stream)
seal_edges(r)
save(r, :lonely_road)

# ---------------------------------------------------------------------------
# 2021: Lonelywood, after map 1.14 of the book: a crescent of houses on the
# east shore of Maer Dualdon, four piers out into the lake, and three fingers
# of forest with roads between them. North: the path into the pinewoods (the
# Moon Temple and the Wennen's Warren). East: the logging road (the Glade of
# the Unmade). South-east: the road back towards Bryn Shander.
LW, LH = 44, 40
shore = ->(y) { (11 + 0.028 * (y - 21)**2).round }
t = Builder.new(LW, LH)
t.fill(0, SNOW)
lopen = {}
lake = []
(0...LH).each do |y|
  (0...LW).each do |x|
    if x < shore.(y)
      lopen[[x, y]] = true
      lake << [x, y]
    elsif y >= 2 && y <= LH - 2 && x <= shore.(y) + 8
      lopen[[x, y]] = true
    end
  end
end
road = lambda do |x0, y0, x1, y1, w = 2|
  n = [(x1 - x0).abs, (y1 - y0).abs].max
  (0..n).each do |i|
    x = (x0 + (x1 - x0) * i.to_f / n).round
    y = (y0 + (y1 - y0) * i.to_f / n).round
    w.times { |d| lopen[[x, y + d]] = true; lopen[[x + d, y]] = true }
  end
end
road.(28, 0, 29, 4)                       # north path into the pinewoods
[29, 30].each { |x| [0, 1].each { |y| lopen[[x, y]] = true } }
road.(19, 12, 43, 10, 4)                  # the logging road, east (wide enough that the pines can't close it)
road.(18, 24, 31, 22)                     # the middle road
(29..37).each { |x| (17..24).each { |y| lopen[[x, y]] = true } }   # clearing at its end
road.(19, 33, 43, 35)                     # south-east: to Termalaine and the Eastway
forest_except(t, LW, LH, lopen)
t.autotile(0, 5, lake)
# piers
[[6, 7], [10, 7], [17, 7], [24, 7], [29, 6]].each do |y, len|
  s = shore.(y)
  (s - len...s).each { |x| t.set(x, y, 1, PLANK[:c]) }
  t.set(s - len, y - 1, 1, PLANK[:c]); t.set(s - len, y + 1, 1, PLANK[:c])   # a T at the end
end
t.stamp(CABIN, 22, 3)         # the Lucky Liar, door (24, 7)
t.stamp(HUT, 14, 12)          # the Happy Scrimshander, door (15, 15)
t.stamp(HOUSE, 13, 19)        # Speaker Huddle's house, door (14, 23)
t.stamp(ROUND_HUT, 14, 28)    # Ramshackle (closed), door (15, 31)
t.stamp(HUT, 31, 18)          # a fisher's house, door (32, 21)
[[21, 9], [20, 17], [19, 26], [19, 35], [36, 23]].each { |x, y| t.stamp(LAMP, x, y) }
t.stamp(HAY, 25, 13); t.set(33, 23, 2, CRATE); t.set(34, 23, 2, CRATE)
t.door(24, 7, ID[:lucky_liar], 5, 11, 8, name: "Door Lucky Liar")
t.door(15, 15, ID[:scrimshander], 6, 12, 8, name: "Door Scrimshander")
t.door(14, 23, ID[:speaker_house], 9, 11, 8, name: "Door Speaker's House")
t.door(32, 21, ID[:fisher_house], 9, 11, 8, name: "Door Fisher")
t.event(15, 31, "Door ramshackle_closed", [{ trigger: 1, script: "FT.talk(:ramshackle_closed, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])" }])
[35, 36].each { |y| t.warp(LW - 1, y, ID[:lonely_road], y == 35 ? 14 : 15, 1, 2, name: "To Lonelywood Road") }
[29, 30].each { |x| t.warp(x, 0, ID[:moon_grounds], 12, 29, 8, name: "To the Moon Temple") }
[11, 12].each { |y| t.warp(LW - 1, y, ID[:glade], y == 11 ? 14 : 15, 26, 8, name: "To the Glade") }
t.cutscene(41, 35, :lonelywood_arrival)
# SC 3.09: back in town after the Requiem, the laughing is the calling (once)
t.event(1, 1, "Cutscene laughing_calling", [{}, { switch: SW_REQUIEM_DONE, trigger: 3, script: "FT.scene(:laughing_calling, @event_id)" },
                                             { self_switch: "A" }])
t.npc(16, 24, "BW (16)", :scoop_huddle, dir: 4, name: "Scoop")      # (stands still: wandering, he blocked the door)
t.npc(12, 17, "BWFisherman", :lonely_fisher, dir: 4)
t.npc(26, 12, "BW (54)", :lonely_logger, dir: 2)
t.npc(17, 36, "BWOldWoman", :lonely_moon_talk, dir: 8)
t.npc(27, 4, "BW (38)", :lonely_north_path, dir: 2)
npc_when(t, 15, 25, LOPUNNY, :jet_sentry_town, SW_SHIMMER_TAKEN, dir: 8, name: "Jet Sentry")
t.trainer(10, 24, "BWFisherman", :fisher_garrow, :FISHERMAN, dir: 4, sight: 4)
t.trainer(33, 12, "BWWorker", :logger_breck, :WORKER, dir: 4, sight: 4)
t.sign(40, 33, :lonely_sign)
t.sign(28, 3, :sign_moon_temple)
t.sign(40, 10, :sign_glade_road)
# Torg's (Rime of the Frostmaiden, "Cold-Hearted Killer"): Torrga Icevein's
# travelling company, camped in the clearing past the fisher's house. Sephek
# Kaltro is her bodyguard, until the night he takes Shimmer.
t.set(36, 17, 2, CRATE); t.set(37, 17, 2, CRATE)                       # the sleds, laden
t.event(35, 17, "Torg's flag", [
  { graphic: "", tile_id: CRATE, script: "FT.talk(:torgs_flag, @event_id)" },
  { switch: SW_TORRGA_GONE, graphic: "", tile_id: CRATE, script: "FT.talk(:torgs_camp_gone, @event_id)" }
])
t.event(36, 18, "Torrga", [
  { graphic: "BW040", direction: 2, script: "FT.torrga(@event_id)" },
  { switch: SW_TORRGA_GONE, graphic: "", through: true }
])
t.event(37, 20, "Sephek at Torg's", [
  { graphic: "FT_sephek", direction: 4, script: "FT.sephek_torgs(@event_id)" },
  { switch: SW_SHIMMER_TAKEN, graphic: "", through: true }
])
t.event(37, 21, "Torg's sack", [
  { graphic: "BARREL", direction: 2, script: "FT.torgs_sack(@event_id)" },
  { switch: SW_TORRGA_GONE, graphic: "", through: true }
])
t.event(35, 23, "Sled dogs", [
  { graphic: "Followers/STOUTLAND", direction: 4, step_anime: true, script: "FT.talk(:torgs_dogs, @event_id)" },
  { switch: SW_TORRGA_GONE, graphic: "", through: true }
])
t.event(29, 18, "Torg's hand", [
  { graphic: "BW054", direction: 6, script: "FT.talk(:torgs_hand_idle, @event_id)" },
  { switch: SW_TORRGA_GONE, graphic: "", through: true }
])
# (RotF: four hands drive and guard the other sleds)
[[37, 18, "BW (38)", 4], [34, 22, "BW (40)", 6], [37, 23, "BW (72)", 4]].each do |x, y, g, dir|
  t.event(x, y, "Torg's hand", [
    { graphic: g, direction: dir, script: "FT.talk(:torgs_hand_idle, @event_id)" },
    { switch: SW_TORRGA_GONE, graphic: "", through: true }
  ])
end
seal_edges(t)
save(t, :lonelywood)

# 2027: Speaker Nimsy Huddle's house: halfling-sized furniture, cookies, and
# the heated attic where visitors sleep (Lonelywood has no inn).
sh, ex = Builder.from_existing(644)
exits_to(sh, ex, ID[:lonelywood], 14, 24)
sh.event(13, 7, "Nimsy Huddle", [{ graphic: "BW (24)", direction: 4, script: "FT.nimsy(@event_id)" }])
sh.npc(7, 6, "BW (16)", :huddle_kids, dir: 2, name: "Huddle kids")
sh.npc(9, 9, "BW (17)", :huddle_kids, move: 1, name: "Huddle kids")
save(sh, :speaker_house)

# 2024: the Lucky Liar (tavern)
ll, ex = Builder.from_existing(768)
exits_to(ll, ex, ID[:lonelywood], 24, 8)
ll.event(3, 6, "Danae", [{ graphic: "BW (59)", direction: 6, script: "FT.talk(:danae_xotal, @event_id)" }])
ll.npc(10, 8, "BW (54)", :liar_tall_tale, dir: 2)
ll.npc(13, 5, "BWFisherman", :liar_fisher, dir: 4)
ll.trainer(10, 10, "BW (57)", :liar_brawler, :ROUGHNECK, dir: 8, sight: 2)
# Hlin Trollbane, sitting apart with her pipe: the ice-dagger killer's hunter
ll.event(15, 9, "Hlin Trollbane", [
  { graphic: "BWOldWoman", direction: 8, script: "FT.hlin(@event_id)" },
  { switch: SW_HLIN_PAID, graphic: "", through: true }
])
save(ll, :lucky_liar)

# 2028: the Happy Scrimshander (Iriskree Harrowhill's shop)
sc, ex = Builder.from_existing(81)
exits_to(sc, ex, ID[:lonelywood], 15, 16)
sc.event(6, 6, "Iriskree", [{ graphic: "BWOldWoman", direction: 2, script: "FT.iriskree(@event_id)" }])
sc.npc(10, 9, "BW (62)", :scrim_customer, dir: 6)
save(sc, :scrimshander)

# 2029: a fisher's house
fh, ex = Builder.from_existing(644)
exits_to(fh, ex, ID[:lonelywood], 32, 22)
fh.npc(13, 7, "BWOldMan", :lakeside_elder, dir: 4)
save(fh, :fisher_house)

# 2022: the Wennen's Warren (Union Cave layout): rounded halls, fungal light,
# the Circle of Thirteen in their chambers, the Undying Rose at the heart.
wr, _ex = Builder.from_existing(285, keep: [12, 13, 14])
wr.map.events.delete_if { |_k, e| e.name == "Closed" || e.name == "Exit" }
wr.door(34, 45, ID[:moon_grounds], 20, 28, 2, name: "Exit")
[[9, 47], [10, 31], [33, 9]].each { |x, y| wr.event(x, y, "Bolt tunnel", [{ trigger: 1, script: "FT.talk(:warren_bolt_tunnel, @event_id)" }]) }
# the Circle of Thirteen, each in their chamber (Nova Keeper waits at the Moon
# Temple, Aphelion Roads in its sanctum)
{ jet_sentry: [33, 42, LOPUNNY, 4], aurora_traveller: [22, 41, BUNEARY, 6],        # resting chamber
  eclipse_spicer: [26, 25, BUNEARY, 2],                                            # council hollow
  pulsar_bond: [32, 31, LOPUNNY, 4],                                               # herbal chambers
  celeste_scribe: [31, 17, LOPUNNY, 2], cosmo_bookman: [33, 20, BUNEARY, 4],      # library tunnel
  stellar_fletcher: [22, 16, LOPUNNY, 6], helios_meadow: [26, 15, BUNEARY, 2],    # forge cavern
  umbra_rider: [30, 6, LOPUNNY, 2] }.each do |key, (x, y, gfx, dir)|   # dreaming alcove
  wr.npc(x, y, gfx, key, dir: dir, name: key.to_s.split("_").map(&:capitalize).join(" "))
end
wr.event(20, 6, "Luna Carver", [{ graphic: BUNEARY, direction: 2, script: "FT.luna(@event_id)" }])   # SC 3.08
wr.event(10, 10, "Zenith Abbott", [{ graphic: LOPUNNY, direction: 2, script: "FT.zenith(@event_id)" }])
wr.sign(11, 9, :undying_rose_warren)
wr.sign(9, 34, :warren_nursery)
wr.sign(22, 18, :shadow_vault)
wr.cutscene(34, 44, :warren_enter)
save(wr, :warren)

# 2023: the Moon Temple grounds (Sinjoh ruins layout) just outside the Warren.
g, _ex = Builder.from_existing(589)
g.map.events.delete_if { |_k, e| e.name == "Closed" }
[10, 11].each { |x| g.door(x, 12, ID[:moon_sanctum], 9, 32, 8, name: "Door Sanctum") }
g.door(20, 27, ID[:warren], 34, 44, 8, name: "Door Warren")
# The way to and from Lonelywood: the foot of the main path (the old corner at
# (8, 31) was a pocket walled in by one-way ledges)
g.warp(12, 30, ID[:lonelywood], 29, 1, 2, name: "To Lonelywood")
g.cutscene(12, 29, :moon_grounds_arrival)
g.event(13, 27, "Cutscene sephek_moon_temple", [
  {},
  { switch: 3917, trigger: 3, script: "FT.scene(:sephek_moon_temple, @event_id)" },
  { self_switch: "A" }
])
g.event(14, 29, "Sephek in ice", [
  { graphic: "", through: true },
  { switch: SW_SEPHEK_DOWN, graphic: "FT_sephek_frozen", direction: 2, step_anime: false, walk_anime: false,
    script: "FT.talk(:sephek_frozen, @event_id)" },
  { switch: SW_WENNEN_FOLLOW, graphic: "", through: true }     # the Wennen have taken him south on a sledge
])
g.npc(9, 19, LOPUNNY, :nova_keeper, dir: 6, name: "Nova Keeper")
g.trainer(12, 24, "BW (107)", :aurilite_five, :FT_AURILITE, dir: 4, sight: 3)
g.trainer(16, 29, "BW (108)", :aurilite_six, :FT_AURILITE, dir: 4, sight: 3)
save(g, :moon_grounds)

# 2025: the Moon Temple sanctum (three altars under the moon)
sa, ex = Builder.from_existing(590)
exits_to(sa, ex, ID[:moon_grounds], 10, 13)
sa.npc(9, 16, LOPUNNY, :aphelion_roads, dir: 2, name: "Aphelion Roads")
sa.npc(6, 18, "BW (107)", :sanctum_aurilite_ghost, dir: 6, name: "Old priestess")
save(sa, :moon_sanctum)

# ---------------------------------------------------------------------------
# 2026: the Glade of the Unmade. A ring of trees around a moonlit clearing, a
# circle of standing stones, and at its centre a slab older than names, where
# Shimmer made her choice. (After the "Shimmer's Sacrifice" campaign notes.)
GW, GH = 30, 28
gl = Builder.new(GW, GH)
gl.fill(0, SNOW)
gopen = {}
(0...GW).each { |x| (0...GH).each { |y| gopen[[x, y]] = true if (x - 14.5)**2 + ((y - 12.5) * 1.15)**2 <= 9.5**2 } }
[14, 15].each { |x| (18...GH).each { |y| gopen[[x, y]] = true } }
forest_except(gl, GW, GH, gopen)
# the stone circle (gaps north and south) and the altar slab at its centre
[[9, 6], [19, 6], [6, 11], [22, 11], [8, 16], [20, 16], [12, 4], [16, 4]].each { |x, y| gl.stamp(BOULDER, x, y) }
gl.stamp(ICE_BOULDER, 14, 10)                                          # the altar, rimed in ice
[14, 15].each { |x| gl.warp(x, GH - 1, ID[:lonelywood], 42, x == 14 ? 11 : 12, 4, name: "To Lonelywood") }
gl.event(14, 11, "Altar", [
  { graphic: "", through: false, script: "FT.talk(:glade_altar_before, @event_id)" },
  { switch: SW_SHIMMER_TAKEN, graphic: "", through: false, script: "FT.talk(:undying_rose, @event_id)" }
])
gl.event(15, 11, "Altar", [{ graphic: "", through: false, script: "FT.talk(:undying_rose, @event_id)" }])
[13, 14, 15, 16].each do |x|
  gl.event(x, 18, "Glade aftermath", [
    { through: true },
    { switch: SW_SHIMMER_TAKEN, trigger: 1, through: true, script: "FT.scene(:glade_aftermath, @event_id)" },
    { self_switch: "A", through: true }
  ])
end
mm = npc_when(gl, 18, 13, "FT_meat_meat", :meat_meat_glade, SW_SHIMMER_TAKEN, dir: 4, name: "Meat Meat")
# gone once she travels with you, and never there when you ARE her
[SW_HERALD_MEAT, SW_MEAT_JOINED].each { |sw| mm.pages << gl.build_page(mm.pages[0], { switch: sw, graphic: "", through: true }) }
seal_edges(gl)
save(gl, :glade)

# ---------------------------------------------------------------------------
# Bryn Shander: the north gate opens once Sephek has walked out of it.
bryn = reopen(BRYN)
unless has_event?(bryn, "To Lonelywood Road")
  [22, 23].each { |x| (-1..2).each { |y| [1, 2].each { |z| bryn.set(x, y, z, 0) } } }
  bryn.map.events.each_value do |e|
    next unless e.pages[0].list.any? { |c| c.code == 355 && c.parameters[0].to_s.include?(":bryn_north_guard") }
    e.pages << bryn.build_page(e.pages[0], { switch: SW_NORTH_OPEN, graphic: "", through: true }) if e.pages.size == 1
  end
  npc_when(bryn, 21, 4, "BWPoliceman", :bryn_north_guard_open, SW_NORTH_OPEN, dir: 6)
  [22, 23].each { |x| bryn.warp(x, 0, ID[:lonely_road], x == 22 ? 14 : 15, H - 2, 8, name: "To Lonelywood Road") }
  # Jet Sentry ran ahead and waits by the east gate (SC 3.09)
  npc_when(bryn, 42, 21, LOPUNNY, :jet_sentry_gate, SW_REQUIEM_DONE, dir: 4, name: "Jet Sentry")
end
resave(bryn, BRYN)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT}"
