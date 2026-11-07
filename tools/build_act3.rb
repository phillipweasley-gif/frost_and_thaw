# Builds Act III (script SC 11.01-14.02): its scenes in places you know, and
# Solstice and Grimskalle.
#   2079 Solstice (from Infinite Fusion's Ice Mountains: the dock below, the
#        climb, the skull's cave above)
#   2080 The Statue Fields (from the Ice Cavern's slide room)
#   2081 The Garden of Death (from the Ice Cavern)
#   2082 The Grimskalle Gate        2083 The Hall of the Four Winds
#   2084-2087 The Four Tests        2088 The Crown       2089 The Throne of Frost
require_relative "ft_common"
require_relative "cavekit"

ID = { solstice: 2079, statue_fields: 2080, garden: 2081, gate: 2082, hall: 2083, cruelty: 2084, endurance: 2085,
       isolation: 2086, preservation: 2087, crown: 2088, throne: 2089 }
NAMES = { solstice: "Solstice", statue_fields: "The Statue Fields", garden: "The Garden of Death", gate: "The Grimskalle Gate",
          hall: "The Hall of the Four Winds", cruelty: "The Test of Cruelty", endurance: "The Test of Endurance",
          isolation: "The Test of Isolation", preservation: "The Test of Preservation", crown: "The Crown", throne: "The Throne of Frost" }
MUSIC = Hash.new("Lavender_Town_Pokemon_Tower_Remix").merge(solstice: "route38_39", gate: "tintower", crown: "tintower")
SW_CH11_HEARTH, SW_CH11_SHRINE, SW_CH11_COUNCIL = 3993, 3994, 3995
SW_DOCK_CLEARED, SW_TROLL_DOWN, SW_CROWN_OPEN = 3996, 3997, 3999
SW_FROSTINA_FREE, SW_AURIL_DOWN = 3951, 3952

def save(b, key) = save_map(b, ID[key], MUSIC[key])
def cells(*rects) = rects.flat_map { |x, y, w, h| Builder.rect_cells(x, y, w, h) }
def paint(b, *rects)
  f = {}
  cells(*rects).each { |c| f[c] = true }
  cave_paint(b, f)
end
def autorun(b, x, y, name, switch, script)
  b.event(x, y, name, [{ graphic: "", through: true }, { switch: switch, trigger: 3, script: script }])
end
def fresh(id)
  b, _ex = Builder.from_existing(id)
  b.map.events.clear
  b
end
def statue(b, x, y, graphic, n)
  b.event(x, y, "Statue #{n}", [
    { graphic: graphic, direction: 2, opacity: 150, blend_type: 0, step_anime: false, walk_anime: false,
      script: "FT.talk(:ice_statue, @event_id)\nFT.statue_touched(@event_id) if pbConfirmMessage(_INTL(\"Touch it?\"))" },
    { self_switch: "A", graphic: graphic, direction: 2, opacity: 150, step_anime: false, walk_anime: false, script: "FT.talk(:ice_statue, @event_id)" }
  ])
end

# --- scenes in places you know ------------------------------------------------
h = reopen(2053); autorun(h, 1, 1, "Cutscene auril_whisper", SW_CH11_HEARTH, "FT.scene_auril_whisper"); resave(h, 2053)
cn = reopen(2061)
autorun(cn, 1, 1, "Cutscene frost_saint_walks", SW_CH11_SHRINE, "FT.scene_frost_saint_walks")
cn.event(16, 30, "Griffon roost", [{ graphic: "Followers/PIDGEOT", direction: 2, script: "FT.departure(:griffons, @event_id)" }])
resave(cn, 2061)
ch = reopen(2054); autorun(ch, 2, 1, "Cutscene four_chairs", SW_CH11_COUNCIL, "FT.scene_four_chairs"); resave(ch, 2054)
rt = reopen(2055)
rt.event(32, 9, "Wennen bell", [{ graphic: "FT_wennen_generic", direction: 8, script: "FT.departure(:whale, @event_id)" }])
resave(rt, 2055)

# --- 2079: Solstice -------------------------------------------------------------
so = fresh(670)
# Infinite Fusion's mountain runs on into other maps at its edges; here it's an island: snow-rock at the rim
(0...so.map.width).each do |x|
  (0...so.map.height).each do |y|
    next unless x == 0 || y == 0 || x == so.map.width - 1 || y == so.map.height - 1
    so.set(x, y, 2, 443)
  end
end
[18, 19, 20].each { |x| so.set(x, 58, 2, 443) }     # the dock ends in black water
so.event(19, 53, "Sopo", [
  { graphic: "Followers/SNORUNT", direction: 2, step_anime: true, script: "FT.sopo(@event_id)" },
  { switch: SW_DOCK_CLEARED, graphic: "", through: true }
])
[18, 20].each do |x|
  so.event(x, 53, "Sopo's pack", [
    { graphic: "Followers/GLALIE", direction: 2, step_anime: true, script: "FT.sopo(@event_id)" },
    { switch: SW_DOCK_CLEARED, graphic: "", through: true }
  ])
end
# the camp at the end of the dock: rest, or go home (FT.solstice_camp)
so.event(19, 57, "Your camp", [{ graphic: "BW_Sailor", direction: 8, script: "FT.solstice_camp(@event_id)" }])
so.event(104, 13, "The skull's cave", [{ trigger: 1, commands: [so.send(:command, 201, [0, ID[:statue_fields], 14, 31, 8, 0])] }])
save(so, :solstice)

# --- 2080: the Statue Fields --------------------------------------------------------
sf = fresh(698)
[14, 15].each { |x| sf.warp(x, 32, ID[:solstice], 104, 14, 2, name: "Back out to the mountain") }
sf.cutscene(14, 30, :statue_fields)
graphics = %w[Followers/URSARING Followers/STANTLER Followers/MAMOSWINE Followers/DRAGONITE Followers/PILOSWINE
              Followers/SNEASEL Followers/DELIBIRD Followers/ABSOL]
[[9, 23], [12, 23], [18, 23], [22, 23], [10, 24], [20, 24], [25, 24], [9, 18]].each_with_index { |(x, y), i| statue(sf, x, y, graphics[i], i + 1) }
sf.event(20, 12, "Shimmer", [{ graphic: "P-SHI-04", direction: 2, step_anime: false, walk_anime: false, script: "FT.shimmer_statue(@event_id)" }])   # Shimmer in ice (batch 02 art)
(0...sf.map.height).each { |y| sf.set(34, y, 2, 443) if y > 0 }      # (the old way east is snowed shut)
# the slide only goes one way up; a rope along the north wall goes back down
sf.event(18, 11, "Rope down", [{ trigger: 1, commands: [sf.send(:command, 201, [0, ID[:statue_fields], 14, 30, 2, 0])] }])
sf.event(17, 11, "On, into the dead", [{ trigger: 1, commands: [sf.send(:command, 201, [0, ID[:garden], 21, 31, 8, 0])] }])
# the slide solver: from the entrance you can reach the top (and Shimmer), and every place
# you can slide to still has a way on (up to the exit) or back (to the entrance)
TS23 = load_data(File.join(GAME_DIR, "Data/Tilesets.rxdata"))[sf.map.tileset_id]
spass = lambda do |x, y|
  next false if x < 0 || y < 0 || x >= sf.w || y >= sf.h
  r = true
  [2, 1, 0].each { |z| id = sf.map.data[x, y, z]; next if id == 0; (r = false; break) if TS23.passages[id] & 15 == 15; break if TS23.priorities[id] == 0 }
  r
end
sice = ->(x, y) { (0..2).any? { |z| TS23.terrain_tags[sf.map.data[x, y, z]] == 12 } }
sblock = {}
sf.map.events.each_value { |e| pg = e.pages[0]; sblock[[e.x, e.y]] = true unless pg.graphic.character_name.empty? && pg.graphic.tile_id == 0 }
swalk = ->(c) { spass.(*c) && !sblock[c] }
sstep = lambda do |c, d|
  n = [c[0] + d[0], c[1] + d[1]]
  next nil if !swalk.(n)
  while sice.(*n)
    nn = [n[0] + d[0], n[1] + d[1]]
    break if !swalk.(nn)
    n = nn
  end
  n
end
sreach = lambda do |st|
  seen = { st => true }; q = [st]
  until q.empty?
    c = q.shift
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each { |d| n = sstep.(c, d); next if !n || seen[n]; seen[n] = true; q << n }
  end
  seen
end
from_door = sreach.([14, 31])
stuck = from_door.keys.reject { |c| r = sreach.(c); r[[17, 12]] || r[[14, 31]] }
ok = from_door[[17, 12]] && [[19, 12], [21, 12], [20, 13]].any? { |c| from_door[c] } && stuck.empty?
puts "statue fields slide: top #{!!from_door[[17, 12]]}, Shimmer #{[[19, 12], [21, 12], [20, 13]].any? { |c| from_door[c] }}, stuck spots #{stuck.size}"
# once you've crossed (and found Shimmer), a rope goes back up from the entrance, so
# losing a battle beyond the fields doesn't mean sliding the whole puzzle again
rope_up = [[15, 31], [13, 31], [15, 30], [13, 30], [16, 31], [12, 31]].find { |c| swalk.(c) && !sice.(*c) && !sf.map.events.values.any? { |e| [e.x, e.y] == c } }
raise "no spot for the rope up" if !rope_up
sf.event(rope_up[0], rope_up[1], "Rope up", [{ graphic: "", through: true },
  { switch: 3906, trigger: 1, commands: [sf.send(:command, 201, [0, ID[:statue_fields], 17, 12, 2, 0])] }])
puts "statue fields rope up at #{rope_up.inspect}"
raise "the Statue Fields slide isn't solvable" unless ok
save(sf, :statue_fields)

# --- 2081: the Garden of Death --------------------------------------------------
gd = fresh(693)
[21, 22].each { |x| gd.warp(x, 32, ID[:statue_fields], 17, 12, 2, name: "Back to the fields") }
gd.cutscene(21, 30, :garden_of_death)
[[12, 24], [24, 23], [10, 18], [25, 19], [14, 13], [26, 13]].each_with_index do |(x, y), i|
  gd.event(x, y, "Frozen dead #{i + 1}", [{ graphic: %w[BW_Sailor BW (72) BW (40) BW029 BW (55) BW054][i], direction: 2, opacity: 140,
                                           step_anime: false, walk_anime: false, script: "FT.talk(:garden_block, @event_id)" }])
end
gd.event(13, 28, "Nass", [{ graphic: "BW (40)", direction: 2, opacity: 120, script: "FT.nass(@event_id)" }])
# the talking orb in Nass's hands, so Skant's lines have someone to come from (notes 13 §2)
gd.event(14, 28, "Professor Skant (an orb)", [{ graphic: "Followers/SOLOSIS", direction: 2, opacity: 160, step_anime: true,
                                               script: "FT.nass(@event_id)" }])
gd.event(19, 11, "Ice troll", [
  { graphic: "Followers/PILOSWINE", direction: 2, step_anime: true, script: "FT.ice_troll(@event_id)" },
  { switch: SW_TROLL_DOWN, graphic: "", through: true }
])
[18].each { |x| gd.event(x, 4, "Up, to the skull", [{ trigger: 1, through: true, commands: [gd.send(:command, 201, [0, ID[:gate], 9, 16, 8, 0])] }]) }
save(gd, :garden)

# --- 2082: the Grimskalle Gate (the skull's jaw, a rink inside it) ----------------
gt = cave_map(20, 20)
paint(gt, [4, 4, 12, 11], [8, 15, 3, 3])
[8, 9, 10].each { |x| gt.warp(x, 17, ID[:garden], 18, 5, 2, name: "Back down") }
# Ukuma slides round and round his rink (notes 13 E8): a loop round the middle of the ice
gt.event(10, 9, "Ukuma", [{ graphic: "Followers/WALREIN", direction: 4, step_anime: true, move_speed: 4, move_frequency: 5,
                            move_route: [[2, []], [2, []], [1, []], [1, []], [3, []], [3, []], [4, []], [4, []]],
                            script: "FT.ukuma(@event_id)" }])
[9, 10].each { |x| gt.event(x, 3, "The skull's jaw", [{ tile_id: 582, script: "FT.grimskalle_jaw(@event_id)" }]) }
save(gt, :gate)

# --- 2083: the Hall of the Four Winds -----------------------------------------------
hl = cave_map(25, 22)
paint(hl, [6, 4, 13, 13], [11, 17, 3, 3], [3, 9, 3, 3], [19, 9, 3, 3], [11, 1, 3, 3])
hl.cutscene(12, 18, :hall_four_winds)
[[12, 9], [11, 10], [13, 10], [12, 11]].each_with_index do |(x, y), i|
  hl.event(x, y, "Tablet #{i + 1}", [{ tile_id: 800, script: "FT.talk(:four_tablets, @event_id)" }])
end
# The four doors: each one a dark opening you can see, carved with its word; the
# door says whether its vision is still waiting (a lost test can be faced again).
{ cruelty: [2, 10, 4], endurance: [22, 10, 6], isolation: [12, 0, 8], preservation: [10, 18, 4] }.each_with_index do |(k, (x, y, d)), i|
  hl.event(x, y, "Door of #{k}", [{ tile_id: 582, trigger: 1, script: "FT.test_door(:#{k}, @event_id)" }])
end
# No way back out but the way you came: a rope down through the jaw (notes 13 E12)
hl.event(12, 19, "Rope down to the jaw", [{ trigger: 1, through: true, commands: [hl.send(:command, 201, [0, ID[:gate], 9, 4, 2, 0])] }])
# What the three shortcuts are for (notes 13 E13): each makes the climb easier, none skips a Test.
SW_HALL_SPRING, SW_HALL_CACHE, SW_HALL_BACKDOOR = 4185, 4186, 4187
hl.event(7, 5, "Warm spring", [{ graphic: "", through: true },
  { switch: SW_HALL_SPRING, tile_id: 774, script: "FT.hall_shortcut(:spring, @event_id)" }])
hl.event(17, 15, "Nass's cache", [{ graphic: "", through: true },
  { switch: SW_HALL_CACHE, tile_id: 780, script: "FT.hall_shortcut(:cache, @event_id)" }])
hl.event(7, 15, "Ukuma's back door", [{ graphic: "", through: true },
  { switch: SW_HALL_BACKDOOR, tile_id: 582, script: "FT.hall_shortcut(:backdoor, @event_id)" }])
# the crown stair (behind the preservation door, the hall's south passage is the way in; the stair is east of the tablets)
hl.event(18, 4, "Stair of ice", [
  { tile_id: 582, script: "FT.talk(:crown_stair_shut, @event_id)" },
  { switch: SW_CROWN_OPEN, tile_id: 582, trigger: 0, commands: [hl.send(:command, 201, [0, ID[:crown], 9, 12, 8, 0])] }
])
save(hl, :hall)

# --- 2084-2087: the Four Tests (each a vision; it plays when you walk in) -------------
%i[cruelty endurance isolation preservation].each do |k|
  t = cave_map(20, 14)
  paint(t, [3, 3, 14, 9])
  [[4, 4], [15, 4], [4, 10], [15, 10]].each { |x, y| t.set(x, y, 2, 792) }
  t.event(1, 1, "Test #{k}", [{ trigger: 3, script: "FT.scene(:test_#{k}, @event_id)" }, { self_switch: "A" }])
  # The test's shade, named as its lines name it so its words get a bubble (notes 13 E6);
  # gone once its tablet cracks (FT.finish_test sets its self switch)
  shade = { cruelty: "Gunvald's Shade", endurance: "Jarund's Shade", isolation: "The Tiger Queen's Shade", preservation: "Still Keeper" }[k]
  t.event(9, 4, shade, [{ graphic: { cruelty: "BW (72)", endurance: "BW029", isolation: "BW (33)", preservation: "FT_alberica_rune" }[k],
                          direction: 2, opacity: k == :preservation ? 140 : 180, script: "FT.talk(:test_done, @event_id)" },
                        { self_switch: "A", graphic: "", through: true }])
  [8, 9, 10].each { |x| t.warp(x, 11, ID[:hall], 12, 16, 8, name: "Back to the hall") }
  save(t, k)
end

# --- 2088: the Crown -------------------------------------------------------------------
cr = cave_map(20, 16)
paint(cr, [3, 3, 14, 10], [8, 13, 3, 2])
[8, 9, 10].each { |x| cr.warp(x, 14, ID[:hall], 17, 5, 2, name: "Down the stair of ice") }
cr.cutscene(9, 12, :the_crown)
cr.event(6, 5, "Iskra", [{ graphic: "FT_iskra", direction: 2, step_anime: true, script: "FT.iskra(@event_id)" }])
cr.event(5, 4, "Silver egg", [{ tile_id: 792, script: "FT.talk(:silver_egg, @event_id)" }])
cr.event(12, 4, "Frostina's crystal", [
  { graphic: "FT_frostina_crystal", direction: 2, step_anime: false, walk_anime: false, script: "FT.sephek_crown(@event_id)" },
  { switch: SW_FROSTINA_FREE, graphic: "", through: true }
])
cr.event(12, 6, "Sephek", [
  { graphic: "FT_sephek", direction: 2, script: "FT.sephek_crown(@event_id)" },
  { switch: SW_FROSTINA_FREE, graphic: "", through: true }
])
[13, 14].each do |x|
  cr.event(x, 2, "The throne room", [
    { tile_id: 582, script: "FT.talk(:throne_shut, @event_id)" },
    { switch: SW_FROSTINA_FREE, tile_id: 582, commands: [cr.send(:command, 201, [0, ID[:throne], 9, 12, 8, 0])] }
  ])
end
save(cr, :crown)

# --- 2089: the Throne of Frost ----------------------------------------------------------
th = cave_map(20, 16)
paint(th, [3, 3, 14, 10], [8, 13, 3, 2])
[[4, 4], [15, 4], [4, 11], [15, 11]].each { |x, y| th.set(x, y - 1, 2, 800); th.set(x, y, 2, 808) }
[8, 9, 10].each { |x| th.warp(x, 14, ID[:crown], 13, 3, 2, name: "Back to the Crown") }
th.event(9, 4, "Auril", [
  { graphic: "FT_auril_furs", direction: 2, script: "FT.scene_throne" },
  { switch: SW_AURIL_DOWN, graphic: "", through: true }
])
th.event(1, 1, "Cutscene throne", [{ trigger: 3, script: "FT.scene_throne" }, { switch: SW_AURIL_DOWN }])
save(th, :throne)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT} (and added Act III's scenes to 2053, 2054, 2055, 2061)"
