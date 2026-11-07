# Builds Act II, Chapter 6 (Rootspire: the Festival of Returning Light), first part:
# Rootspire's Trunk-Tier market ring (the Verdant Bazaar, after the supplement's
# T1-T3), its Pokémon Center, Tarin Goldlash's sap-shop, the Rooted Hearth
# (Hellen Brightrun's tavern) and the Council Hall of Seasons. The Echo Gate on
# the west side is the way back to the Dale of 400 years ago (the Heart of the
# Chasm), and the Heart's mirror-frame is the way here.
require_relative "ft_common"
require_relative "cavekit"

ID = { rootspire: 2050, rs_center: 2051, sap_shop: 2052, hearth: 2053, council: 2054, root_tier: 2055, shrine: 2056 }
NAMES = { rootspire: "Rootspire", rs_center: "Rootspire Pokémon Center", sap_shop: "Goldlash Sap-Works",
          hearth: "The Rooted Hearth", council: "Council Hall of Seasons", root_tier: "Rootspire Root-Tier",
          shrine: "The Still Sky Shrine" }
MUSIC = { rootspire: "Azalea Town", rs_center: "pokecenter", sap_shop: "Violet City ", hearth: "Ecruteak City",
          council: "tintower", root_tier: "Seafoam Islands Music", shrine: "Lavender_Town_Pokemon_Tower_Remix" }
SW_WARDENS = 3935       # Kelyn has named you Wardens Emeritus
SW_RITE_STOPPED = 3936  # Matron Eline's Rite of Stillness is broken

def save(b, key) = save_map(b, ID[key], MUSIC[key])

# --- the faithful build-out (W5): Rootspire as a living city -----------------
LIFE = { halls: 2180, stables: 2196, mirror_dust: 2197, smugglers_run: 2198 }
SW_RUN_OPEN = 4162; SW_ASH_EXPOSED = 4163; SW_LANTERN = 4166; SW_MIRA_FREED = 3974
SW_KELYN_ORB = 4169; SW_SCORCH = 4174
# A faction's watcher: faint until you've met its master (or carry Jast's
# lantern, which shows it plainly); gone once caught or driven off.
def watcher(b, x, y, key, sprite)
  b.event(x, y, "Watcher #{key}", [
    { graphic: sprite, direction: 2, opacity: 60, step_anime: true, script: "FT.watcher(:#{key}, @event_id)" },
    { switch: SW_LANTERN, graphic: sprite, direction: 2, opacity: 230, step_anime: true, script: "FT.watcher(:#{key}, @event_id)" },
    { self_switch: "A", graphic: "", through: true }
  ])
end

# Someone whose talk is a function, who leaves once a switch is on.
def person_until(b, x, y, graphic, fn, switch, dir: 2, name: nil)
  b.event(x, y, name || fn.to_s, [{ graphic: graphic, direction: dir, script: "FT.#{fn}(@event_id)" },
                                  { switch: switch, graphic: "", through: true }])
end

# A doorway in a cave wall (no house door): steps you through.
def cave_doorway(b, x, y, to, name, switch: nil, closed: nil)
  se = MapKit.deep_copy(b.instance_variable_get(:@door_template).pages[0].list[0].parameters[0])
  cmds = [b.send(:command, 250, [se]), b.send(:command, 223, [Tone.new(-255, -255, -255, 0), 6]), b.send(:command, 106, [8]),
          b.send(:command, 201, [0, *to, 1]), b.send(:command, 223, [Tone.new(0, 0, 0, 0), 6])]
  pages = []
  pages << { trigger: 1, tile_id: 582, script: "#{closed}\npbMoveRoute($game_player, [PBMoveRoute::Backward])" } if switch
  pages << { switch: switch, trigger: 1, tile_id: 582, commands: cmds }
  b.event(x, y, name, pages)
end

# A door that only opens once a story switch is on (before that, it says why and steps you back).
def gated_door(b, x, y, to_map, to_x, to_y, dir, switch, key, name: "Door")
  se = MapKit.deep_copy(b.instance_variable_get(:@door_template).pages[0].list[0].parameters[0])
  cmds = [b.send(:command, 250, [se]), b.send(:command, 223, [Tone.new(-255, -255, -255, 0), 6]), b.send(:command, 106, [8]),
          b.send(:command, 201, [0, to_map, to_x, to_y, dir, 1]), b.send(:command, 223, [Tone.new(0, 0, 0, 0), 6])]
  b.event(x, y, name, [
    { trigger: 1, script: "FT.talk(:#{key}, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])" },
    { switch: switch, trigger: 1, commands: cmds }
  ])
end

# ---------------------------------------------------------------------------
# 2050: Rootspire, the Trunk-Tier (map grown from Azalea Town: a town in the
# roots of an old forest). Doors: Center (24,18), sap-shop (34,16), the
# Rooted Hearth (31,27), the Council Hall (20,28); the root-well (44-45,12) is
# the sealed Root-Gate down to the Heartroot; the west road is the Echo Gate.
rs, _ex = Builder.from_existing(338)
rs.map.events.clear
# no bulldozer parked in the World Tree's market (Azalea's road works): path tiles under it
(50..56).each do |x|
  (25..31).each do |y|
    rs.set(x, y, 2, 0) if (11360..11392).cover?(rs.map.data[x, y, 2])
    rs.set(x, y, 1, 1070) if (8520..8548).cover?(rs.map.data[x, y, 1])
  end
end
rs.door(24, 18, ID[:rs_center], 10, 11, 8, name: "Door Pokemon Center")
rs.door(34, 16, ID[:sap_shop], 6, 12, 8, name: "Door Sap-Works")
rs.door(31, 27, ID[:hearth], 5, 11, 8, name: "Door Rooted Hearth")
rs.door(20, 28, ID[:council], 11, 18, 8, name: "Door Council Hall")
[21, 22, 23].each { |y| rs.event(7, y, "Echo Gate", [{ trigger: 1, script: "FT.echo_gate(@event_id)" }]) }
[44, 45].each do |x|                                           # the fence round the root-well: the Root-Gate
  rs.event(x, 16, "Root-Gate", [
    { graphic: "", script: "FT.talk(:root_gate_sealed, @event_id)" },
    { switch: 3937, graphic: "", commands: [
      rs.send(:command, 355, ["FT.root_gate_descend(@event_id)"]),
      rs.send(:command, 250, [MapKit.deep_copy(rs.instance_variable_get(:@door_template).pages[0].list[0].parameters[0])]),
      rs.send(:command, 223, [Tone.new(-255, -255, -255, 0), 6]), rs.send(:command, 106, [8]),
      rs.send(:command, 201, [0, 2057, 7, 4, 2, 1]), rs.send(:command, 223, [Tone.new(0, 0, 0, 0), 6])] }
  ])
end
# the road east (where the bulldozer stood) runs out to the Blooming Fields
(28..31).each { |y| rs.warp(59, y, 2060, 1, y - 14, 6, name: "To the Blooming Fields") }
rs.cutscene(9, 22, :rootspire_arrival)
# SC 6.03: once you've met Hellen, the twins come down into the market
rs.event(0, 0, "Cutscene twins_land", [{ switch: 3934, trigger: 3, script: "FT.scene(:twins_land, @event_id)" },
                                       { self_switch: "A" }])
# SC 6.09: the festival's last night, when you sit down for it at the Hearth (switch 3966 is turned off again by the scene)
rs.event(1, 0, "Cutscene festival_night", [{ switch: 3966, trigger: 3, script: "FT.scene_festival_night" }])
rs.sign(18, 21, :sign_rootspire)
rs.npc(12, 10, "BW (37)", :kurt_door, dir: 6, name: "Woodcarver")
gated_door(rs, 14, 9, ID[:root_tier], 8, 4, 2, SW_WARDENS, :root_stair_closed, name: "Door Woodcarver")
rs.npc(28, 21, "BW (38)", :rs_dockhand, dir: 4, name: "Dockhand")
# the hub: the root-lift, Pip, the Wennen, Tamsin, Rheven, Hew
rs.event(16, 11, "Lift-keeper", [{ graphic: "BW (62)", direction: 4, script: "FT.root_lift(@event_id)" }])
rs.event(33, 20, "Pip", [{ graphic: "BW (35)", direction: 2, script: "FT.pip(@event_id)" }])
rs.event(24, 20, "Nivva Sunwick", [{ graphic: "Followers/BUNEARY", direction: 2, step_anime: true, script: "FT.nivva(@event_id)" }])
rs.npc(46, 21, "Followers/BUNEARY", :lirielle, dir: 4, name: "Lirielle Mossdancer")
rs.npc(13, 28, "Followers/LOPUNNY", :reva, dir: 6, name: "Reva Mosscut")
rs.event(32, 29, "Tamsin", [{ graphic: "FT_tamsin", direction: 8, script: "FT.tamsin(@event_id)" }])
rs.npc(50, 29, "FT_captain_rheven_stormbranch", :rheven, dir: 4, name: "Captain Rheven")
rs.npc(51, 29, "Followers/FT_rheven_direwolf", :rheven_wolf, dir: 4, name: "Rheven's direwolf")
rs.event(48, 27, "Hew Talmire", [{ graphic: "FT_master_hew_talmire", direction: 2, script: "FT.hew(@event_id)" }])   # the Guild's ladder comes up beside him
rs.npc(16, 23, "BWParasolLady", :rs_festival_goer, dir: 2)
rs.npc(44, 27, "BW (30)", :rs_lantern_maker, dir: 6)   # (standing still: the east gap under the ledge is one tile wide)
rs.npc(13, 25, "BW (29)", :rs_mural_kid, dir: 8)
rs.trainer(28, 25, nil, :warden_ash, :FT_ROOTWARDEN, dir: 8, sight: 3)
ash = rs.map.events.values.max_by(&:id)                      # Ash, after his battle: the Summer infiltrator (048)
ash.pages[1] = rs.send(:build_page, ash.pages[0], { graphic: ash.pages[0].graphic.character_name, direction: 8,
                                                    self_switch: "A", script: "FT.warden_ash(@event_id)" })
ash.pages << rs.send(:build_page, ash.pages[0], { switch: SW_ASH_EXPOSED, graphic: "", through: true })
rs.trainer(42, 20, nil, :warden_lis, :FT_ROOTWARDEN, dir: 4, sight: 3)
rs.trainer(18, 31, nil, :warden_tobin, :FT_ROOTWARDEN, dir: 8, sight: 2)
# W5: the root-stair up to the Verdant Halls (the civic ring), at the top of the north lane
rs.door(17, 8, LIFE[:halls], 62, 40, 4, name: "Root-stair to the Verdant Halls")
# Mira of the North Wind's mirror stall in the Bazaar, until she's herself again; the boy with the mirror
person_until(rs, 36, 20, "FT_mira_possessed", :mira_stall, SW_MIRA_FREED, dir: 2, name: "Mira's mirror stall")
# the boy with the mirror: named "Child" so his CHILD: lines bubble on him (notes 07 E2); a boy's sprite (BW (17) is Mira's girl)
rs.event(38, 20, "Child with a mirror", [{ graphic: "BW (18)", direction: 2, script: "FT.rs_mirror_child(@event_id)" }])
rs.event(10, 23, "Krolf the Mossback", [{ graphic: "BW (115)", direction: 4, script: "FT.krolf(@event_id)" }])
rs.event(47, 18, "Mistress Felka", [{ graphic: "BWOldWoman", direction: 4, script: "FT.felka(@event_id)" }])
rs.event(46, 29, "Guild assessor", [{ graphic: "BW (84)", direction: 4, script: "FT.amber_assessor(@event_id)" }])
rs.event(46, 16, "The great root", [{ graphic: "", script: "FT.tree_communion_or_talk(@event_id)" }])
rs.event(9, 21, "Scorch marks", [{ graphic: "", through: true }, { switch: SW_SCORCH, graphic: "", script: "FT.scorch_marks(@event_id)" }])
watcher(rs, 15, 14, :stalker, "Followers/SUDOWOODO")
watcher(rs, 43, 18, :wraithling, "Followers/HAUNTER_fly")
save(rs, :rootspire)

# 2051: Pokémon Center (the nurse, machine and PC kept)
pc, ex = Builder.from_existing(632, keep: [4, 8, 10])
exits_to(pc, ex, ID[:rootspire], 24, 19)
pc.npc(15, 9, "BW (35)", :rs_center_pilgrim, dir: 4)
save(pc, :rs_center)

# 2052: Goldlash Sap-Works (Tarin Goldlash bottles "liquid sunlight")
sw, ex = Builder.from_existing(81)
exits_to(sw, ex, ID[:rootspire], 34, 17)
sw.event(6, 6, "Tarin Goldlash", [{ graphic: "BW (85)", direction: 2, script: "FT.tarin(@event_id)" }])
sw.npc(10, 9, "BW (62)", :sap_customer, dir: 6)
sw.event(8, 6, "Gorran Ashal-Forge", [{ graphic: "BW (113)", direction: 2, script: "FT.gorran(@event_id)" }])
sw.event(11, 6, "Dathra Spineshade", [{ graphic: "BW (104)", direction: 2, script: "FT.dathra(@event_id)" }])
watcher(sw, 5, 9, :ember_rat, "Followers/RATICATE")
save(sw, :sap_shop)

# 2053: the Rooted Hearth, a tavern grown into a hollow knot of the tree
rh, ex = Builder.from_existing(768)
rh.map.events.delete_if { |_id, e| e.name == "Closed" }   # (the source map's stair: the cellar stair below, notes 06 E28)
exits_to(rh, ex, ID[:rootspire], 31, 28)
rh.event(3, 6, "Hellen Brightrun", [{ graphic: "FT_hellen", direction: 6, script: "FT.hellen(@event_id)" }])
rh.event(13, 5, "Rumours", [{ graphic: "BW (85)", direction: 4, script: "FT.hearth_rumour(@event_id)" }])
rh.npc(10, 8, "BW (54)", :hearth_drinker, dir: 2)
rh.npc(7, 10, "BW (62)", :hearth_bard, dir: 8)
[5, 6].each { |x| gated_door(rh, x, 3, 2059, 11, 24, 8, 3934, :hearth_stair_shut, name: "Cellar stair") }
watcher(rh, 12, 9, :lurker, "Followers/GENGAR")
save(rh, :hearth)

# 2054: the Council Hall of Seasons (grown from Sprout Tower's hall: a round
# chamber around a living pillar of the tree)
ch, ex = Builder.from_existing(272)
exits_to(ch, ex, ID[:rootspire], 20, 29)
[11, 12].each { |x| ch.event(x, 12, "Living pillar", [{ graphic: "", script: "FT.council_pillar(@event_id)" }]) }
ch.event(14, 13, "Kelyn of Spring", [
  { graphic: "FT_high_speaker_kelyn_of_spring", direction: 2, script: "FT.kelyn(@event_id)" }
])
# (once he's fallen in the forge (3977) he's gone: notes/09 E6, the dead Autumn
# Warden no longer stands in the Hall he's charged in)
ch.event(8, 13, "Darrus Fell", [{ graphic: "FT_darrus_fell", direction: 2, script: "FT.darrus(@event_id)" },
                                { switch: 3977, graphic: "", through: true }])
# (after the rite (3936) Selrae goes down after Var: her seat is empty, her
# cloak on it, until you've found her below (3939); context 06 M6-10. The
# trial week's page is added by build_w4.)
ch.event(17, 12, "Selrae Vorn", [{ graphic: "FT_winter_matron_selrae_vorn", direction: 4, script: "FT.selrae_hall(@event_id)" },
                                 { switch: 3936, graphic: "FT_winter_matron_selrae_vorn", direction: 4, opacity: 0, script: "FT.selrae_hall(@event_id)" },
                                 { switch: 3939, graphic: "FT_winter_matron_selrae_vorn", direction: 4, script: "FT.selrae_hall(@event_id)" }])
ch.event(14, 11, "Speaker's alcove", [{ graphic: "", script: "FT.talk(:kelyn_mural, @event_id)" }])
ch.event(9, 16, "Petitioners' bench", [{ graphic: "", script: "FT.petition_bench(@event_id)" }])
# the Heralds' statues along the side aisles (each with their partner Pokémon carved at their feet)
{ [5, 6] => [:statue_alberica, "Followers/CHINGLING"], [5, 9] => [:statue_reptin, "Followers/BULBASAUR"],
  [18, 6] => [:statue_alerion, "Followers/ZORUA"], [18, 9] => [:statue_meat_meat, "Followers/NOIBAT_fly"] }.each do |(x, y), (key, g)|
  ch.event(x, y, "Statue #{key}", [{ graphic: g, direction: 2, opacity: 160, step_anime: false, walk_anime: false, script: "FT.talk(:#{key}, @event_id)" }])
end
save(ch, :council)

# ---------------------------------------------------------------------------
# 2055: the Root-Tier, the undercity where Dougan's Hole once lay: a stair
# down from the woodcarver's workshop, the Split Dock on black water, and the
# plaza before the Still Sky Shrine. Glow-fungus (small crystals) everywhere.
rt = cave_map(40, 30)
fl = {}
[[3, 2, 7, 6], [9, 5, 16, 3], [22, 3, 9, 12], [14, 7, 5, 13], [8, 18, 19, 8]].each do |x, y, w, h|
  Builder.rect_cells(x, y, w, h).each { |c| fl[c] = true }
end
cave_paint(rt, fl)
cave_bridge_h(rt, 31, 37, 8)                                   # the Split Dock's pier, out over the water
[[4, 6], [8, 3], [12, 7], [23, 4], [29, 13], [15, 15], [9, 19], [25, 19], [10, 25], [24, 25]].each { |x, y| rt.set(x, y, 2, 792) }
[[13, 24], [21, 24]].each { |x, y| rt.set(x, y - 1, 2, 801); rt.set(x, y, 2, 809) }   # pink crystal pillars by the shrine
rt.warp(6, 2, ID[:rootspire], 14, 10, 2, name: "Stair up")
rt.cutscene(4, 3, :root_tier_arrival)
rt.npc(28, 9, "BW (38)", :split_dock_fisher, dir: 6, name: "Fisher")
rt.event(37, 8, "Boreal Requiem gangplank", [{ graphic: "BW_Sailor", direction: 4, script: "FT.boreal_requiem(@event_id)" }])
# SC 7B.04: once she's herself again, Mira and her daughter stand on the pier
npc_when(rt, 36, 9, "FT_mira_of_the_north_wind", :mira_after, 3974, dir: 8, name: "Mira of the North Wind")
npc_when(rt, 35, 9, "BW (17)", :mira_daughter, 3974, dir: 8, name: "Mira's daughter")
rt.trainer(16, 12, nil, :halo_vigil, :FT_HALO, dir: 2, sight: 3)
rt.trainer(22, 21, nil, :halo_ascetic, :FT_HALO, dir: 4, sight: 3)
rt.door(17, 25, ID[:shrine], 14, 6, 2, name: "Door Still Sky Shrine")
# a door in the floor of the cave edge: closed until a switch, then it takes you through
def root_door(b, x, y, switch, closed_script, to, name)
  se = MapKit.deep_copy(b.instance_variable_get(:@door_template).pages[0].list[0].parameters[0])
  cmds = [b.send(:command, 250, [se]), b.send(:command, 223, [Tone.new(-255, -255, -255, 0), 6]), b.send(:command, 106, [8]),
          b.send(:command, 201, [0, *to, 1]), b.send(:command, 223, [Tone.new(0, 0, 0, 0), 6])]
  b.event(x, y, name, [
    { trigger: 1, tile_id: 582, script: "#{closed_script}\npbMoveRoute($game_player, [PBMoveRoute::Backward])" },
    { switch: switch, trigger: 1, tile_id: 582, commands: cmds }
  ])
end
root_door(rt, 8, 21, 3942, "FT.sap_gate(@event_id)", [2068, 10, 42, 8], "Sap Gate")
root_door(rt, 26, 22, 3941, "FT.crypt_door(@event_id)", [2065, 9, 17, 8], "Rootwarden Crypt")
rt.event(30, 10, "Driftwood chest", [
  { graphic: "BWPokeball", direction: 2, script: "FT.driftwood_chest(@event_id)" },
  { self_switch: "A", graphic: "", through: true }
])
rt.event(25, 5, "Captain Ivran Solmar", [{ graphic: "BW (54)", direction: 2, script: "FT.ivran(@event_id)" }])
cave_doorway(rt, 11, 17, [LIFE[:stables], 6, 13, 8], "Verdant Stables")
cave_doorway(rt, 22, 17, [LIFE[:mirror_dust], 8, 12, 8], "Mirror-Dust Curiosity Shop")
cave_doorway(rt, 29, 13, [LIFE[:smugglers_run], 5, 3, 2], "Dock hatch", switch: SW_RUN_OPEN, closed: "FT.talk(:dock_hatch_barred, @event_id)")
rt.event(33, 9, "Corsair sailor", [{ graphic: "BW_Sailor", direction: 2, script: "FT.corsair_sailor(@event_id)" }])
rt.event(34, 7, "Captain's strongbox", [{ graphic: "", tile_id: 1056, script: "FT.requiem_vault(@event_id)" }])
rt.event(26, 10, "Jorik Pinebellow", [{ graphic: "BW (75)", direction: 4, script: "FT.jorik(@event_id)" }])
rt.event(27, 12, "Split crate", [{ graphic: "BARREL", script: "FT.dock_ore(@event_id)" }])
rt.event(31, 9, "Shivven Pearlbite", [{ graphic: "BW (38)", direction: 2, script: "FT.shivven(@event_id)" }])
rt.event(23, 6, "Viessa Arialune", [{ graphic: "BW (107)", direction: 2, script: "FT.viessa(@event_id)" }])
# Hellen's old passage comes out under a barrel on the Split Dock (048_H; switch 4180)
rt.event(34, 9, "Barrel on the dock", [
  { graphic: "BARREL", script: "FT.talk(:dock_barrel_shut, @event_id)" },
  { switch: 4180, graphic: "BARREL", commands: [
    rt.send(:command, 355, ["FT.hearth_passage_up(@event_id)"]),
    rt.send(:command, 223, [Tone.new(-255, -255, -255, 0), 6]), rt.send(:command, 106, [8]),
    rt.send(:command, 201, [0, 2059, 6, 24, 4, 1]), rt.send(:command, 223, [Tone.new(0, 0, 0, 0), 6])] }
])
watcher(rt, 20, 23, :homunculus, "Followers/PORYGON")
watcher(rt, 15, 6, :raven, "Followers/MURKROW")
save(rt, :root_tier)

# 2056: the Still Sky Shrine (grown from the Sealed Chamber: blue stone, a long
# hall, a dais). Auril's statue, the Rite of Stillness, Matron Eline.
sh, _ex = Builder.from_existing(810)
sh.map.events.clear
[13, 14, 15].each { |x| sh.door(x, 5, ID[:root_tier], 15, 23, 2, name: "Exit") }
# below the hall the Sealed Chamber's underwater floor runs on to the map edge: wall it off
# (black, with the tileset's invisible blocker 390 on top); and anything else you can't reach gets the blocker too
(0...sh.map.width).each { |x| (28...sh.map.height).each { |y| sh.set(x, y, 0, 389); sh.set(x, y, 1, 0); sh.set(x, y, 2, 390) } }
UW = load_data("#{GAME_DIR}/Data/Tilesets.rxdata")[sh.map.tileset_id]
pass = lambda do |x, y|
  next false if x < 0 || y < 0 || x >= sh.map.width || y >= sh.map.height
  ok = true
  [2, 1, 0].each do |z|
    id = sh.map.data[x, y, z]
    next if id == 0
    (ok = false; break) if UW.passages[id] & 0x0f == 0x0f
    break if UW.priorities[id] == 0
  end
  ok
end
bare_black = ->(x, y) { sh.map.data[x, y, 0] == 389 && sh.map.data[x, y, 1] == 0 }    # the black void around the chamber
seen = { [14, 6] => true, [13, 5] => :door, [14, 5] => :door, [15, 5] => :door }; todo = [[14, 6]]   # the doors are walls: they take you out
until todo.empty?
  cx, cy = todo.pop
  [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dx, dy|
    q = [cx + dx, cy + dy]
    next if seen[q] || !pass.(*q) || bare_black.(*q)
    seen[q] = true; todo << q
  end
end
(0...sh.map.width).each { |x| (0...sh.map.height).each { |y| sh.set(x, y, 2, 390) if pass.(x, y) && (!seen[[x, y]] || bare_black.(x, y)) } }
sh.cutscene(14, 7, :shrine_enter)
sh.event(14, 21, "Auril's statue", [
  { graphic: "Followers/FROSLASS", direction: 2, opacity: 170, step_anime: false, walk_anime: false, script: "FT.talk(:auril_statue, @event_id)" }
])
sh.event(14, 19, "Matron Eline", [
  { graphic: "FT_matron_eline", direction: 2, script: "FT.eline(@event_id)" },
  { switch: SW_RITE_STOPPED, graphic: "", through: true }
])
[[11, 20], [17, 20]].each_with_index do |(x, y), i|
  sh.event(x, y, "Disciple #{i + 1}", [
    { graphic: i == 0 ? "FT_halo_disciple_female" : "FT_halo_disciple_male", direction: i == 0 ? 6 : 4, script: "FT.talk(:halo_disciple, @event_id)" },
    { switch: SW_RITE_STOPPED, graphic: "", through: true }
  ])
end
# SC 6.07: Sephek, four hundred years in the ice, on the altar beside Auril's statue
sh.event(13, 21, "Sephek in ice", [
  { graphic: "FT_sephek_frozen", direction: 2, step_anime: false, walk_anime: false, script: "FT.talk(:sephek_altar, @event_id)" }
])
[13, 14, 15].each { |x| sh.event(x, 24, "Frost Saint runes", [{ graphic: "", script: "FT.shrine_cleanse(@event_id)" }]) }
sh.event(10, 12, "Eira Voss", [{ graphic: "", through: true },
                               { switch: SW_RITE_STOPPED, graphic: "BW (40)", direction: 6, script: "FT.eira_black_market(@event_id)" }])
save(sh, :shrine)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT}"
