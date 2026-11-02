# Builds the Heartroot Labyrinth's lower zones (after "Rootspire" Part IV-A and
# Tab 3's H1-H37 overlay): below the Sap Wells, behind the knotted heart-wall
# that the Root-Key opens.
#   2140 Zone III, the Mirror Garden: H9 Petaled Threshold, H10 the Reflection
#        Ring, H11 the Shattered Bed, H12 the Perfume Grotto
#   2141 Zone IV, the Hollow Core (upper): H13 Upper Root Bridge, H14 Sap Burst
#        Crossways, H15 the Cocoon Gallery
#   2142 Zone IV, the Hollow Core (lower): H16 the Frozen Drop, H17 the
#        Underdark Mouth, H34 the Lizard Nursery, H27 the Root-Kin Barracks
#   2143 Zone V, the Vault of Amber Dreams: H18 Amber Threshold, H19 the Stasis
#        Gallery, H20 the Dissectory Annex, H28 the Suffering Pods
#   2144 Zone V, the Scriptory wing: H21 the Mirror Scriptory, H29 the Guest
#        Seed Nests, H31 the Devil's Bloom, H30 the Root-Lift Node
#   2145 the Mirror-Root Vault (Tab 1's original H3): the pit of liquid mirror,
#        the broken ice mask, Avarice's first homunculus
# The Root-Lift Node comes out beside the door of iron and glass in the Guild
# Dig (build_ch7b.rb). Zone VI is the Forge's approach (build_ch8_deep.rb).
require_relative "ft_common"
require_relative "cavekit"

ID = { mirror_garden: 2140, hollow_upper: 2141, hollow_lower: 2142, amber_vault: 2143, scriptory: 2144, mirror_root: 2145 }
NAMES = { mirror_garden: "Heartroot: the Mirror Garden", hollow_upper: "Heartroot: the Hollow Core",
          hollow_lower: "Heartroot: the Frozen Drop", amber_vault: "Heartroot: the Vault of Amber Dreams",
          scriptory: "Heartroot: the Mirror Scriptory", mirror_root: "Heartroot: the Mirror-Root Vault" }
MUSIC = { mirror_garden: "Seafoam Islands Music", hollow_upper: "tintower", hollow_lower: "tintower",
          amber_vault: "Lavender Town", scriptory: "Lavender Town", mirror_root: "Lavender Town" }
SAP_WELLS, GUILD_DIG = 2058, 2066
SW_HEARTWALL, SW_RING_DONE, SW_BARRACKS_DONE, SW_LIFT_NODE, SW_AMBER_PODS = 4080, 4081, 4082, 4083, 4085

def save(b, key) = save_map(b, ID[key], MUSIC[key])
def floor_of(rects)
  f = {}
  rects.each { |x, y, w, h| Builder.rect_cells(x, y, w, h).each { |c| f[c] = true } }
  f
end
def paint_rooms(b, rects)
  f = floor_of(rects)
  cave_paint(b, f)
  f
end
# a readable thing on the floor (a solid tile, so it can be pressed from beside it)
def thing(b, x, y, name, script, tile: 809)
  b.event(x, y, name, [{ tile_id: tile, script: script }])
end
def step_trigger(b, x, y, name, script)
  b.event(x, y, name, [{ trigger: 1, through: true, script: script }, { self_switch: "A", through: true }])
end
# a creature or person to talk to
def being(b, x, y, name, graphic, script, dir: 2, step: false)
  b.event(x, y, name, [{ graphic: graphic, direction: dir, step_anime: step, script: script }])
end
# blocks a passage until a switch turns on (then it's gone)
def barrier(b, x, y, name, script, switch, graphic: "", tile: 0)
  b.event(x, y, name, [
    { graphic: graphic, tile_id: tile, trigger: 1, through: false, script: script },
    { switch: switch, graphic: "", through: true }
  ])
end

# ---------------------------------------------------------------------------
# 2140: Zone III, the Mirror Garden.
mg = cave_map(46, 30)
paint_rooms(mg, [
  [2, 2, 9, 7],                         # H9: the Petaled Threshold (in from the Sap Wells)
  [10, 5, 6, 3],
  [15, 2, 15, 13],                      # H10: the Reflection Ring
  [29, 7, 5, 3],                        # the petal-gate out of the ring
  [33, 3, 11, 9],                       # H11: the Shattered Bed
  [36, 12, 3, 3], [33, 15, 9, 6],       # H12: the Perfume Grotto
  [41, 12, 3, 11], [30, 22, 14, 5]      # down toward the Hollow Core
])
[[3, 8], [9, 2], [16, 3], [28, 3], [16, 14], [28, 14], [43, 3], [33, 11], [34, 20], [41, 20]].each { |x, y| mg.set(x, y, 2, 792) }
[3, 4].each { |x| mg.warp(x, 2, SAP_WELLS, 20, 25, 8, name: "Up to the Sap Wells") }
mg.cutscene(5, 5, :mirror_garden_enter)
thing(mg, 8, 3, "Mirror-flower", "FT.petaled_threshold(@event_id)")
thing(mg, 4, 7, "Mirror-flower", "FT.petaled_threshold(@event_id)", tile: 808)
[[18, 5], [26, 5], [18, 11], [26, 11]].each { |x, y| thing(mg, x, y, "Mirror-petal", "FT.reflection_petal(@event_id)") }
[7, 8, 9].each { |y| barrier(mg, 30, y, "Petal-gate", "FT.reflection_ring(@event_id)", SW_RING_DONE) }
[[35, 6], [38, 9], [40, 5], [42, 8]].each { |x, y| step_trigger(mg, x, y, "Shattered glass", "FT.shattered_step(@event_id)") }
thing(mg, 43, 5, "Glass-roots", "FT.shard_focus(@event_id)", tile: 808)
thing(mg, 37, 17, "Moss bed", "FT.perfume_grotto(@event_id)", tile: 581)
thing(mg, 40, 16, "Fogged mirror", "FT.talk(:grotto_mirror, @event_id)", tile: 808)
[35, 36].each { |x| mg.warp(x, 26, ID[:hollow_upper], 4, 4, 2, name: "Down to the Hollow Core") }
save(mg, :mirror_garden)

# ---------------------------------------------------------------------------
# 2141: Zone IV, the Hollow Core (upper): a shaft of root bridges over a lake of
# frozen sap, far below.
hu = cave_map(48, 34)
paint_rooms(hu, [
  [2, 3, 7, 6],                         # H13: the ledge (in from the Mirror Garden)
  [21, 2, 12, 11],                      # H14: the Sap Burst Crossways
  [26, 13, 3, 5],
  [18, 18, 22, 9]                       # H15: the Cocoon Gallery
])
cave_bridge_h(hu, 9, 20, 5)             # H13: the Upper Root Bridge
[[3, 8], [8, 3], [22, 12], [32, 2], [19, 26], [39, 18]].each { |x, y| hu.set(x, y, 2, 792) }
[3, 4].each { |x| hu.warp(x, 3, ID[:mirror_garden], x == 3 ? 35 : 36, 24, 8, name: "Up to the Mirror Garden") }
hu.cutscene(5, 6, :hollow_core_enter)
hu.trainer(7, 7, nil, :sapwarden_tamsk, :FT_ROOTWARDEN, dir: 6, sight: 4)
hu.trainer(22, 6, nil, :sapwarden_irrel, :FT_ROOTWARDEN, dir: 4, sight: 1)   # sight stops short of the bridge
[[24, 4], [30, 5], [27, 10]].each { |x, y| step_trigger(hu, x, y, "Sap burst", "FT.sap_burst(@event_id)") }
[[25, 11], [31, 9]].each { |x, y| step_trigger(hu, x, y, "Frost vines", "FT.frost_vines(@event_id)") }
hu.trainer(29, 8, nil, :sapwarden_vesk, :FT_ROOTWARDEN, dir: 4, sight: 3)
being(hu, 23, 9, "Root-construct", "Followers/TREVENANT", "FT.crossways_construct(@event_id)", dir: 6)
[[21, 19], [28, 19], [35, 19]].each_with_index { |(x, y), i| thing(hu, x, y, "Cocoon #{i + 1}", "FT.gallery_cocoon(#{i + 1}, @event_id)", tile: i == 1 ? 808 : 809) }
being(hu, 33, 23, "Pale sovereign", "Followers/SHIINOTIC", "FT.gallery_sovereign(@event_id)", dir: 4, step: true)
[37, 38].each { |x| hu.warp(x, 26, ID[:hollow_lower], 4, 4, 2, name: "Down the Frozen Drop") }
save(hu, :hollow_upper)

# ---------------------------------------------------------------------------
# 2142: Zone IV, the Hollow Core (lower): the Frozen Drop, the Underdark Mouth,
# the Lizard Nursery and the Root-Kin Barracks.
hl = cave_map(48, 36)
paint_rooms(hl, [
  [2, 2, 8, 5],                         # H16: the top of the Frozen Drop
  [9, 4, 10, 3], [16, 7, 3, 8],         # skeletal spans and root-ladders
  [10, 15, 24, 6],                      # the bottom of the shaft
  [2, 15, 8, 6],                        # H17: the Underdark Mouth
  [34, 12, 12, 7],                      # H34: the Lizard Nursery
  [16, 21, 14, 8],                      # H27: the Root-Kin Barracks
  [21, 29, 3, 4]                        # down to the Vault of Amber Dreams
])
[[2, 6], [9, 2], [10, 20], [33, 15], [45, 12], [16, 28], [29, 28]].each { |x, y| hl.set(x, y, 2, 792) }
[3, 4].each { |x| hl.warp(x, 2, ID[:hollow_upper], x == 3 ? 37 : 38, 24, 8, name: "Up to the Cocoon Gallery") }
hl.cutscene(5, 5, :frozen_drop_enter)
step_trigger(hl, 13, 5, "Wind from below", "FT.mephit_swarm(@event_id)")
step_trigger(hl, 17, 9, "Time-lapse", "FT.time_lapse(@event_id)")
thing(hl, 18, 12, "Root-ladder", "FT.talk(:root_ladder, @event_id)", tile: 792)
hl.trainer(5, 17, nil, :duergar_miner_gelt, :FT_DUERGAR, dir: 6, sight: 3)
thing(hl, 3, 16, "Claw-marks", "FT.talk(:underdark_spoor, @event_id)", tile: 792)
thing(hl, 2, 19, "The Underdark Mouth", "FT.talk(:underdark_mouth, @event_id)", tile: 582)
being(hl, 40, 15, "Root-drakes", "Followers/SCEPTILE", "FT.lizard_nursery(@event_id)", dir: 4)
thing(hl, 43, 13, "Root-pen", "FT.talk(:root_pen, @event_id)", tile: 809)
thing(hl, 18, 23, "Bark bunks", "FT.talk(:barracks_bunks, @event_id)", tile: 581)
being(hl, 22, 25, "Sleeping sap-soldiers", "BW054", "FT.root_kin_barracks(@event_id)", dir: 2)
[21, 22, 23].each { |x| barrier(hl, x, 29, "Barracks stair", "FT.talk(:barracks_stair, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])", SW_BARRACKS_DONE) }
[21, 22, 23].each { |x| hl.warp(x, 32, ID[:amber_vault], 23, 4, 2, name: "Down into the amber") }
save(hl, :hollow_lower)

# ---------------------------------------------------------------------------
# 2143: Zone V, the Vault of Amber Dreams.
av = cave_map(48, 34)
paint_rooms(av, [
  [20, 2, 8, 6],                        # H18: the Amber Threshold
  [22, 8, 4, 2],
  [14, 9, 20, 11],                      # H19: the Stasis Gallery
  [34, 12, 2, 3], [35, 10, 10, 8],      # H20: the Dissectory Annex
  [12, 12, 3, 3], [3, 10, 10, 8],       # H28: the Suffering Pods
  [22, 20, 4, 4],                       # down to the Mirror-Root Vault
  [8, 18, 4, 3], [7, 21, 6, 7]          # west, to the Scriptory
])
[[20, 7], [27, 7], [14, 9], [33, 9], [14, 19], [33, 19], [44, 10], [3, 17]].each { |x, y| av.set(x, y, 2, 792) }
[22, 23, 24].each { |x| av.warp(x, 2, ID[:hollow_lower], 22, 30, 8, name: "Up to the Root-Kin Barracks") }
av.cutscene(23, 5, :amber_vault_enter)
[[21, 6], [26, 6]].each { |x, y| being(av, x, y, "Amber pod", "Followers/SHUCKLE", "FT.amber_sentries(@event_id)") }
[22, 23, 24, 25].each { |x| barrier(av, x, 8, "Pods in the throat", "FT.amber_sentries(@event_id)", SW_AMBER_PODS) }
thing(av, 21, 3, "Chanting pod", "FT.talk(:amber_chant, @event_id)", tile: 808)
[[16, 11], [31, 11], [16, 17], [31, 17], [19, 14], [28, 14]].each_with_index do |(x, y), i|
  thing(av, x, y, "Amber pod #{i + 1}", "FT.stasis_pod(#{i + 1}, @event_id)", tile: i.even? ? 808 : 809)
end
thing(av, 24, 12, "Lab notes", "FT.stasis_notes(@event_id)", tile: 581)
step_trigger(av, 24, 16, "Temporal Surge", "FT.temporal_surge(@event_id)")
being(av, 40, 12, "Cataloguing construct", "Followers/GOLETT", "FT.cataloguer(@event_id)", dir: 4)
thing(av, 43, 15, "Root-table", "FT.dissectory_notes(@event_id)", tile: 581)
thing(av, 37, 16, "Sealed crates", "FT.autumn_crates(@event_id)", tile: 809)
being(av, 41, 16, "Hammer-arm construct", "Followers/GOLURK", "FT.dissectory_golem(@event_id)", dir: 8)
being(av, 7, 12, "Torturer construct", "Followers/KLINKLANG", "FT.suffering_pods(@event_id)", dir: 2)
[[4, 11], [10, 11]].each_with_index { |(x, y), i| thing(av, x, y, "Pain-pod #{i + 1}", "FT.pain_pod(#{i + 1}, @event_id)", tile: 808) }
[23, 24].each { |x| av.warp(x, 23, ID[:mirror_root], 13, 4, 2, name: "Down to the Mirror-Root Vault") }
[8, 9].each { |x| av.warp(x, 27, ID[:scriptory], x == 8 ? 5 : 6, 24, 8, name: "West, to the Scriptory") }
save(av, :amber_vault)

# ---------------------------------------------------------------------------
# 2144: Zone V, the Scriptory wing.
sc = cave_map(44, 30)
paint_rooms(sc, [
  [3, 22, 8, 5],                        # in from the Vault of Amber Dreams
  [6, 13, 3, 9],
  [3, 3, 14, 10],                       # H21: the Mirror Scriptory
  [17, 6, 2, 3], [19, 3, 10, 8],        # H29: the Guest Seed Nests
  [29, 6, 2, 3], [31, 3, 11, 9],        # H31: the Devil's Bloom
  [9, 15, 6, 3], [14, 14, 14, 10]       # H30: the Root-Lift Node
])
[[3, 3], [16, 3], [19, 10], [28, 3], [41, 3], [14, 23], [27, 23], [3, 26]].each { |x, y| sc.set(x, y, 2, 792) }
[25, 26].each { |y| sc.warp(10, y, ID[:amber_vault], 11, y, 6, name: "Back to the Vault of Amber Dreams") }
sc.cutscene(7, 23, :scriptory_enter)
thing(sc, 9, 7, "Script pool", "FT.mirror_scriptory(@event_id)", tile: 582)
thing(sc, 4, 5, "Chardalyn pages", "FT.scriptory_pages(@event_id)", tile: 809)
thing(sc, 14, 5, "Sealed crystal", "FT.scriptory_crystal(@event_id)", tile: 808)
thing(sc, 22, 5, "Seed-pod nest", "FT.guest_nests(@event_id)", tile: 809)
thing(sc, 26, 8, "Seed-pod nest", "FT.talk(:guest_nest_second, @event_id)", tile: 808)
sc.trainer(27, 4, nil, :duergar_spy_ossk, :FT_DUERGAR, dir: 4, sight: 4)
being(sc, 37, 6, "Black-glass bloom", "Followers/SPIRITOMB", "FT.devils_bloom(@event_id)", dir: 2)
being(sc, 21, 18, "Root-lift cage", "Followers/KLINKLANG", "FT.root_lift_node(@event_id)", dir: 2)
thing(sc, 25, 16, "Lift roots", "FT.talk(:lift_roots, @event_id)", tile: 792)
save(sc, :scriptory)

# ---------------------------------------------------------------------------
# 2145: the Mirror-Root Vault: half garden, half laboratory. Roots form a sphere
# round a pit of liquid mirror.
mr = cave_map(28, 24)
paint_rooms(mr, [[11, 2, 5, 4], [6, 6, 16, 12]])
[[6, 6], [21, 6], [6, 17], [21, 17]].each { |x, y| mr.set(x, y, 2, 792) }
[12, 13, 14].each { |x| mr.warp(x, 2, ID[:amber_vault], 23, 21, 8, name: "Up to the Stasis Gallery") }
mr.cutscene(13, 5, :mirror_root_enter)
(12..15).each { |x| (10..12).each { |y| mr.set(x, y, 1, 582) } }   # the pit of liquid mirror
thing(mr, 13, 9, "Broken ice mask", "FT.ice_mask(@event_id)", tile: 808)
thing(mr, 13, 13, "The liquid mirror", "FT.mirror_pit(@event_id)", tile: 582)
thing(mr, 8, 8, "Floating shards", "FT.mirror_root_wards(@event_id)", tile: 809)
thing(mr, 19, 8, "Floating shards", "FT.mirror_root_wards(@event_id)", tile: 809)
thing(mr, 8, 15, "Homunculus remains", "FT.talk(:homunculus_remains, @event_id)", tile: 581)
save(mr, :mirror_root)

# ---------------------------------------------------------------------------
# Hooks in the existing Heartroot maps.
sw = reopen(SAP_WELLS)
sw.map.events.delete_if { |_k, e| e.name == "Sign heart_wall" }
[19, 20, 21].each { |x| sw.event(x, 26, "Knotted heart-wall", [{ tile_id: 809, script: "FT.heart_wall(@event_id)" }]) }
resave(sw, SAP_WELLS)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT}"
