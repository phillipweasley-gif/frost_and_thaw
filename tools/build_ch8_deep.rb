# Builds the rest of the Rootsun Forge (after "Rootspire" Tab 2, Chapter 3: the
# Rootsun Forge, Areas 1-37) and the Heartroot Labyrinth's Zone VI (Tab 1 /
# Tab 3: H22-H26, H32, H33, H36, H37), around the maps in build_ch8.rb:
#   2146 Level 1, the Barricade's inner rooms: A2 the Echo Hall, A3 the duergar
#        guardhold, A5 Avarice's quarters, A6 the traitor and the lever, A7 the
#        root archives
#   2147 Level 2: A9 the Deep Root Shaft, A10 the abandoned guest quarters, A11
#        the Warden's root-bunker
#   2148 Level 2: A12 the Rootward training hall, A13 the sap-lift station, A14
#        the Rootwatch post, A15 the sap-gate controls
#   2149 Level 2: A16 the Scratching Hollow, A17 the rust-feast tunnels, A18 the
#        sap-bridge over boiling sap
#   2150 Level 3: the womb of iron (intro), A19 the Root-Throne of Thruun, A20
#        the broken root-works, A21 the heart-fuel stores, A22 the root-shaft
#        elevator, A23 the root-keep gate
#   2151 Level 3: A24/A25 the forge-vantage towers, A29 the mind-flayer corpse,
#        A30 the lower elevator
#   2152 Level 3, past the devil-priest: A32 the mirror-hall, A33 the duergar
#        barracks, A34 the tortured captain, A35 Mother Thruuna's chamber, A36
#        the rootbound mech guards, A37 Avarice's root-vault; H33 the golems
#   2153 Zone VI: H22 the Auroral Antechapel, H32 the Thorn-Run Hall, the Echo
#        Vault's gifts (and H36), H37 the Silent Chapel of the Patron
#   2154 H25 the Sloughing Veins (the escape)
#   2155 H26 the Echo Vault: the tree's whisper, and the stair up
# A27 (the rootbeast pens) and A28 (the prison cocoons) are in the Cocoon Pens,
# and H23/H24 (the Heart Chamber, the Breaking Circle) in the Heart Chamber
# (both build_ch8.rb).
require_relative "ft_common"
require_relative "cavekit"

ID = { inner_rooms: 2146, deep_shaft: 2147, training_hall: 2148, umbound: 2149, forge_upper: 2150,
       vantage: 2151, sanctum: 2152, antechapel: 2153, sloughing: 2154, echo_vault: 2155 }
NAMES = { inner_rooms: "The Barricade: the inner rooms", deep_shaft: "The Hag's Domain: the Deep Root Shaft",
          training_hall: "The Hag's Domain: the Rootwatch", umbound: "The Hag's Domain: the Scratching Hollow",
          forge_upper: "The Dragonforge: the Root-Throne", vantage: "The Dragonforge: the vantage towers",
          sanctum: "The Dragonforge: Avarice's sanctum", antechapel: "Heartroot: the Auroral Antechapel",
          sloughing: "Heartroot: the Sloughing Veins", echo_vault: "Heartroot: the Echo Vault" }
MUSIC = { inner_rooms: "tintower", deep_shaft: "Lavender Town", training_hall: "tintower", umbound: "tintower",
          forge_upper: "Seafoam Islands Music", vantage: "Seafoam Islands Music", sanctum: "Lavender Town",
          antechapel: "Seafoam Islands Music", sloughing: "tintower", echo_vault: "Seafoam Islands Music" }
BARRICADE, HAG_DOMAIN, PENS, DRAGONFORGE, HEART = 2072, 2073, 2074, 2075, 2076
SW_SAPLIFT, SW_ROOTWATCH, SW_CHASM, SW_ROOTKEEP, SW_L3_GATE, SW_MECHS, SW_ANTECHAPEL, SW_GOLEMS =
  4087, 4088, 4089, 4090, 4092, 4093, 4094, 4100

def save(b, key) = save_map(b, ID[key], MUSIC[key])
def paint_rooms(b, rects)
  f = {}
  rects.each { |x, y, w, h| Builder.rect_cells(x, y, w, h).each { |c| f[c] = true } }
  cave_paint(b, f)
  f
end
def thing(b, x, y, name, script, tile: 809)
  b.event(x, y, name, [{ tile_id: tile, script: script }])
end
def step_trigger(b, x, y, name, script)
  b.event(x, y, name, [{ trigger: 1, through: true, script: script }, { self_switch: "A", through: true }])
end
def being(b, x, y, name, graphic, script, dir: 2, step: false, opacity: 255)
  b.event(x, y, name, [{ graphic: graphic, direction: dir, step_anime: step, opacity: opacity, script: script }])
end
# Someone who goes when their beat is done (notes 08 E7: who leaves, leaves):
# a second page, on a self switch or a story switch, with nobody standing there.
# With left: a tile left where they were (a puddle, a brand), to look at.
def gone_after(b, x, y, name, graphic, script, dir: 2, opacity: 255, switch: nil, left: nil)
  b.event(x, y, name, [{ graphic: graphic, direction: dir, opacity: opacity, script: script },
                       (switch ? { switch: switch } : { self_switch: "A" }).merge(
                         left ? { tile_id: left, through: true, script: script } : { graphic: "", through: true })])
end
def barrier(b, x, y, name, script, switch, tile: 0)
  b.event(x, y, name, [
    { tile_id: tile, trigger: 1, through: false, script: script },
    { switch: switch, graphic: "", through: true }
  ])
end
def rock(b, cells) = cells.each { |x, y| b.set(x, y, 2, 792) }

# ---------------------------------------------------------------------------
# 2146: Level 1, the Barricade's inner rooms (up from the north alcove).
ir = cave_map(40, 26)
paint_rooms(ir, [
  [16, 20, 6, 4],                       # in from the Barricade
  [17, 12, 4, 8],                       # A2: the Echo Hall
  [14, 14, 3, 3], [3, 10, 12, 8],       # A3: the duergar guardhold
  [15, 3, 10, 9],                       # A5: Avarice's quarters
  [21, 15, 4, 3], [25, 13, 12, 7],      # A6: the traitor and the lever
  [30, 10, 3, 3], [27, 3, 10, 7]        # A7: the root archives
])
rock(ir, [[3, 10], [14, 17], [15, 3], [24, 3], [36, 13], [36, 19], [27, 3], [36, 9]])
[18, 19].each { |x| ir.warp(x, 23, BARRICADE, x + 4, 10, 2, name: "Back to the Barricade") }
ir.cutscene(18, 21, :inner_rooms_enter)
thing(ir, 17, 16, "Sap puddle", "FT.echo_hall(@event_id)", tile: 582)
thing(ir, 20, 14, "Sap puddle", "FT.echo_hall(@event_id)", tile: 582)
thing(ir, 8, 13, "Burning sap-pool", "FT.talk(:guardhold_pool, @event_id)", tile: 582)
ir.trainer(6, 12, nil, :duergar_ruk, :FT_DUERGAR, dir: 2, sight: 3)
ir.trainer(12, 15, nil, :duergar_varn, :FT_DUERGAR, dir: 4, sight: 3)
thing(ir, 20, 3, "Mural", "FT.avarice_mural(@event_id)", tile: 809)
thing(ir, 16, 5, "Frostglass bed", "FT.talk(:avarice_bed, @event_id)", tile: 581)
thing(ir, 23, 5, "Open journal", "FT.avarice_journal(@event_id)", tile: 581)
thing(ir, 17, 9, "Loose floorboard", "FT.loose_floorboard(@event_id)", tile: 581)
being(ir, 21, 7, "Mirror-root effigy", "Followers/FROSLASS", "FT.auril_effigy(@event_id)")
being(ir, 32, 15, "Sooty duergar", "FT_duergar_worker", "FT.traitor_duergar(@event_id)", dir: 4)
thing(ir, 35, 18, "Sap-fed machinery", "FT.gate_lever(@event_id)", tile: 792)
thing(ir, 31, 4, "Root-maps", "FT.talk(:root_archives, @event_id)", tile: 581)
save(ir, :inner_rooms)

# ---------------------------------------------------------------------------
# 2147: Level 2, the Deep Root Shaft, the guest quarters and the Warden's bunker.
ds = cave_map(44, 32)
paint_rooms(ds, [
  [2, 2, 8, 5],                         # in from the hag's kitchen
  [9, 3, 3, 20],                        # A9: the Deep Root Shaft, down the rib-roots
  [12, 14, 8, 6],                       # A11: the Warden's root-bunker
  [9, 23, 14, 5],                       # the bottom of the shaft
  [22, 24, 3, 3], [24, 20, 10, 8],      # A10: the abandoned guest quarters
  [34, 22, 6, 3]                        # on, toward the training hall
])
rock(ds, [[2, 6], [9, 2], [12, 19], [19, 14], [9, 27], [33, 20], [24, 27]])
[4, 5, 6].each { |x| ds.warp(x, 2, HAG_DOMAIN, 25, 16, 8, name: "Up to the hag's kitchen") }
ds.cutscene(5, 4, :deep_shaft_enter)
thing(ds, 11, 8, "Rib-roots", "FT.talk(:shaft_ribs, @event_id)", tile: 792)
thing(ds, 9, 16, "Old webbing", "FT.talk(:shaft_webbing, @event_id)", tile: 809)
thing(ds, 16, 15, "Bark-sinew hammock", "FT.talk(:bunker_hammock, @event_id)", tile: 581)
thing(ds, 18, 18, "Cracked mirror", "FT.bunker_mirror(@event_id)", tile: 808)
thing(ds, 30, 21, "Workbench", "FT.dragon_limb(@event_id)", tile: 581)
thing(ds, 26, 25, "Scribbled notes", "FT.limb_notes(@event_id)", tile: 581)
[23, 24].each { |y| ds.warp(39, y, ID[:training_hall], 4, 14, 6, name: "On to the training hall") }
save(ds, :deep_shaft)

# ---------------------------------------------------------------------------
# 2148: Level 2, the Rootward training hall, the sap-lift, the Rootwatch post
# and the sap-gate controls.
th = cave_map(46, 30)
paint_rooms(th, [
  [2, 12, 6, 5],                        # in from the shaft
  [8, 9, 14, 12],                       # A12: the Rootward training hall
  [22, 13, 3, 3], [25, 10, 8, 8],       # A13: the sap-lift station
  [33, 8, 11, 10],                      # A14: the Rootwatch post
  [36, 18, 3, 2], [25, 20, 14, 5],      # A15: the sap-gate controls
  [39, 21, 4, 3]                        # on, toward the chasm
])
rock(th, [[8, 9], [21, 9], [8, 20], [21, 20], [43, 8], [25, 24]])
[13, 14].each { |y| th.warp(2, y, ID[:deep_shaft], 38, y + 10, 4, name: "Back to the guest quarters") }
th.cutscene(4, 14, :training_hall_enter)
being(th, 12, 11, "Thorn-bound dummy", "Followers/GOLURK", "FT.training_hall(@event_id)")
being(th, 17, 18, "Thorn-bound dummy", "Followers/GOLURK", "FT.training_hall(@event_id)", dir: 8)
step_trigger(th, 14, 14, "Emberlit eyes", "FT.training_hall(@event_id)")
[13, 14, 15].each { |y| barrier(th, 23, y, "Thorn-vines", "FT.training_hall(@event_id)", SW_GOLEMS) }
thing(th, 28, 11, "Iron console", "FT.sap_lift(:deep, @event_id)", tile: 581)
th.trainer(36, 10, nil, :duergar_watch_ord, :FT_DUERGAR, dir: 2, sight: 3)
th.trainer(40, 12, nil, :duergar_watch_ysk, :FT_DUERGAR, dir: 4, sight: 4)
th.trainer(35, 15, nil, :duergar_watch_brod, :FT_DUERGAR, dir: 6, sight: 3)
gone_after(th, 41, 15, "Infernal Rootbreaker", "Followers/METAGROSS", "FT.rootbreaker(:watch, @event_id)", dir: 4, left: 582)
thing(th, 30, 21, "Heartroot of command", "FT.sapgate_controls(@event_id)", tile: 809)
[36, 37, 38].each { |x| barrier(th, x, 18, "Root levers", "FT.talk(:rootwatch_levers, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])", SW_ROOTWATCH) }
[22, 23].each { |y| th.warp(42, y, ID[:umbound], 4, 6, 6, name: "On toward the hollow") }
save(th, :training_hall)

# ---------------------------------------------------------------------------
# 2149: Level 2, the Scratching Hollow, the rust-feast tunnels and the root-keep
# gate over boiling sap.
um = cave_map(46, 32)
paint_rooms(um, [
  [2, 4, 6, 5],                         # in from the sap-gate controls
  [8, 3, 16, 8],                        # A16: the Scratching Hollow
  [24, 4, 3, 14], [14, 15, 10, 3],      # A17: the rust-feast tunnels
  [14, 18, 3, 6], [17, 21, 14, 3],
  [31, 18, 4, 10], [41, 18, 3, 10]      # A18: the sap-bridge (west bank, east bank)
])
cave_bridge_h(um, 35, 40, 22)           # the root-bridge over the boiling sap
rock(um, [[2, 8], [8, 10], [23, 3], [26, 17], [31, 27], [43, 18]])
[5, 6].each { |y| um.warp(2, y, ID[:training_hall], 41, y + 17, 4, name: "Back to the sap-gate controls") }
um.cutscene(4, 6, :umbound_enter)
(3..10).each { |y| step_trigger(um, 15, y, "Soft earth", "FT.umber_hulk(@event_id)") }
being(um, 25, 9, "Rust-feasters", "Followers/NINJASK_fly", "FT.rust_feasters(@event_id)", dir: 2, step: true)
thing(um, 15, 20, "Gnawed struts", "FT.talk(:gnawed_struts, @event_id)", tile: 792)
um.trainer(43, 22, nil, :duergar_keep_hrem, :FT_DUERGAR, dir: 4, sight: 2)   # short sight: a trainer who walks onto the bridge would block it
um.trainer(43, 23, nil, :duergar_keep_vosh, :FT_DUERGAR, dir: 4, sight: 2)
um.trainer(42, 19, nil, :duergar_keep_dagna, :FT_DUERGAR, dir: 2, sight: 3)
um.trainer(42, 26, nil, :duergar_keep_turl, :FT_DUERGAR, dir: 8, sight: 3)
[41, 42, 43].each { |x| um.warp(x, 27, PENS, 3, 3, 2, name: "Down to the cocoon pens") }
save(um, :umbound)

# ---------------------------------------------------------------------------
# 2150: Level 3: the Root-Throne, the broken root-works, the heart-fuel, the
# root-shaft elevator and the root-keep gate to the Dragonforge.
fu = cave_map(46, 34)
paint_rooms(fu, [
  [2, 2, 7, 5],                         # in from the cocoon pens
  [8, 4, 2, 3], [10, 3, 14, 11],        # A19: the Root-Throne of Thruun
  [24, 4, 10, 8],                       # A20: the broken root-works
  [34, 4, 9, 7],                        # A21: the heart-fuel stores
  [28, 12, 3, 2], [26, 14, 10, 8],      # A22: the root-shaft elevator
  [28, 22, 4, 8], [12, 22, 4, 8]        # A23: the root-keep gate (east bank, west bank)
])
cave_bridge_h(fu, 16, 27, 25)           # over the molten sap river
rock(fu, [[2, 6], [10, 13], [23, 3], [33, 11], [42, 4], [35, 21], [31, 29]])
[4, 5, 6].each { |x| fu.warp(x, 2, PENS, 23, 16, 8, name: "Up to the cocoon pens") }
fu.cutscene(5, 4, :forge_womb)
thing(fu, 16, 4, "Throne of petrified bark", "FT.talk(:thruun_throne, @event_id)", tile: 581)
gone_after(fu, 19, 9, "Quaggoth", "Followers/URSARING", "FT.thruun_throne(@event_id)", dir: 4, left: 581)
gone_after(fu, 21, 6, "Tortured myconid", "FT_myconid_generic", "FT.tortured_myconid(@event_id)", dir: 4, left: 582)
gone_after(fu, 30, 7, "Hiding duergar", "FT_duergar_worker", "FT.broken_works(@event_id)", dir: 2)
thing(fu, 38, 5, "Shelves of flasks", "FT.heart_fuel(@event_id)", tile: 809)
gone_after(fu, 31, 17, "Infernal Rootbreaker", "Followers/METAGROSS", "FT.rootbreaker(:elevator, @event_id)", dir: 2, left: 582)
thing(fu, 34, 15, "Iron console", "FT.sap_lift(:forge, @event_id)", tile: 581)
# A rest on Level 3, so a loss at the root-keep costs one walk, not six maps (review Ch8 E10)
being(fu, 12, 5, "Woken digger", "BW (75)", "FT.forge_camp(@event_id)", dir: 2)
fu.trainer(12, 25, nil, :duergar_gate_kell, :FT_DUERGAR, dir: 6, sight: 3)   # stays on the bank (see 2149)
fu.trainer(12, 26, nil, :duergar_gate_morn, :FT_DUERGAR, dir: 6, sight: 3)
fu.trainer(13, 23, nil, :duergar_gate_sharl, :FT_DUERGAR, dir: 2, sight: 4)
fu.trainer(15, 23, nil, :duergar_gate_ulf, :FT_DUERGAR, dir: 2, sight: 3)
[12, 13, 14, 15].each { |x| barrier(fu, x, 28, "Root-keep gate", "FT.rootkeep_gate(@event_id)", SW_L3_GATE) }
[12, 13, 14, 15].each { |x| fu.warp(x, 29, DRAGONFORGE, 1, 14, 6, name: "Down to the Dragonforge") }
[7, 8].each { |y| fu.warp(42, y, ID[:vantage], 4, 12, 6, name: "Up to the vantage towers") }
save(fu, :forge_upper)

# ---------------------------------------------------------------------------
# 2151: Level 3: the vantage towers over the Dragonforge, the mind-flayer
# corpse, the lower elevator.
va = cave_map(40, 26)
paint_rooms(va, [
  [2, 10, 6, 5],                        # in from the heart-fuel stores
  [8, 9, 26, 5],                        # the walkway along the cavern wall
  [10, 3, 8, 6],                        # A24: the west tower
  [24, 3, 8, 6],                        # A25: the east tower
  [15, 14, 3, 1], [12, 15, 9, 6],       # A29: the mind-flayer corpse
  [26, 14, 3, 1], [24, 15, 8, 7]        # A30: the lower elevator
])
rock(va, [[2, 14], [33, 9], [10, 3], [31, 3], [12, 20], [31, 21]])
[11, 12].each { |y| va.warp(2, y, ID[:forge_upper], 40, y - 4, 4, name: "Back to the heart-fuel stores") }
thing(va, 13, 3, "Balcony rail", "FT.vantage_west(@event_id)", tile: 792)
va.trainer(26, 5, nil, :duergar_tower_grik, :FT_DUERGAR, dir: 2, sight: 3)
va.trainer(30, 5, nil, :duergar_tower_nall, :FT_DUERGAR, dir: 2, sight: 3)
thing(va, 28, 3, "Bolt-slits", "FT.vantage_east(@event_id)", tile: 792)
thing(va, 16, 17, "Ritual circle", "FT.mindflayer_corpse(@event_id)", tile: 581)
thing(va, 28, 18, "Woven platform", "FT.lower_elevator(@event_id)", tile: 582)
save(va, :vantage)

# ---------------------------------------------------------------------------
# 2152: Level 3, past the devil-priest's stair: the mirror-hall, the barracks,
# the tortured captain, Mother Thruuna's chamber, the mech guards, the vault.
sa = cave_map(44, 34)
paint_rooms(sa, [
  [18, 28, 8, 4],                       # up from the black-glass stair
  [20, 18, 4, 10],                      # A32: the mirror-hall
  [18, 18, 2, 2], [4, 10, 14, 10],      # A33: the duergar barracks
  [9, 9, 3, 1], [4, 2, 12, 7],          # A35: Mother Thruuna's residual chamber
  [24, 18, 3, 2], [26, 11, 10, 9],      # A34: the tortured captain
  [18, 8, 8, 10],                       # A36: the mech guards' hall
  [17, 2, 10, 6],                       # A37: Avarice's root-vault
  [36, 12, 6, 3]                        # on, to the Heart's approach
])
rock(sa, [[18, 31], [25, 31], [4, 19], [17, 10], [4, 2], [15, 8], [35, 11], [26, 19], [17, 2], [26, 2]])
[20, 21, 22, 23].each { |x| sa.warp(x, 31, DRAGONFORGE, 26, 5, 2, name: "Down the black-glass stair") }
sa.cutscene(21, 29, :sanctum_enter)
(20..23).each { |x| step_trigger(sa, x, 24, "Wrong reflections", "FT.mirror_hall(@event_id)") }
thing(sa, 23, 21, "Mirror-rock", "FT.talk(:mirror_hall_after, @event_id)", tile: 808)
being(sa, 8, 12, "Chanting duergar", "FT_duergar_sleeper", "FT.duergar_barracks(@event_id)", dir: 2)
being(sa, 13, 16, "Chanting duergar", "FT_duergar_sleeper", "FT.duergar_barracks(@event_id)", dir: 8)
thing(sa, 6, 17, "Root-bunks", "FT.talk(:barracks_hammocks, @event_id)", tile: 581)
gone_after(sa, 10, 4, "Flickering silhouette", "FT_thredra_echo", "FT.thruuna_chamber(@event_id)", opacity: 150)
being(sa, 31, 13, "Bound captain", "FT_duergar_bound_captain", "FT.tortured_captain(@event_id)", dir: 2)
[[20, 9], [23, 9]].each { |x, y| gone_after(sa, x, y, "Rootbound mech", "Followers/METAGROSS", "FT.mech_guards(@event_id)", switch: SW_MECHS) }
# H33, the Hammer-Heart workshop, moved up here from the Antechapel (notes 08 E17:
# the last room before the Heart isn't all optional fights)
[[28, 17], [33, 17]].each { |x, y| being(sa, x, y, "Hanging root-golem", "Followers/GOLURK", "FT.hammer_heart(@event_id)") }
(18..25).each { |x| barrier(sa, x, 8, "Vault threshold", "FT.mech_guards(@event_id)", SW_MECHS) }
thing(sa, 21, 3, "Pedestal", "FT.vault_journal(@event_id)", tile: 581)
{ [18, 4] => :mirror, [24, 4] => :note, [19, 6] => :scale, [25, 6] => :rose, [22, 6] => :glaive }.each do |(x, y), k|
  thing(sa, x, y, "Vault relic", "FT.vault_relic(:#{k}, @event_id)", tile: k == :note ? 581 : (k == :scale || k == :glaive ? 809 : 808))
end
[13, 14].each { |y| sa.warp(41, y, ID[:antechapel], 4, 14, 6, name: "On toward the Heart") }
save(sa, :sanctum)

# ---------------------------------------------------------------------------
# 2153: Zone VI: the Auroral Antechapel, the Thorn-Run Hall, the Hammer-Heart
# workshop and the Silent Chapel; the breathing door to the Heart Chamber.
an = cave_map(46, 30)
paint_rooms(an, [
  [2, 12, 5, 5],                        # in from the sanctum
  [7, 11, 18, 7],                       # H22: the Auroral Antechapel
  [25, 13, 14, 3],                      # H32: the Thorn-Run Hall
  [30, 12, 3, 1], [27, 4, 10, 8],       # H33: the Hammer-Heart workshop
  [30, 16, 3, 1], [27, 17, 10, 8],      # H37: the Silent Chapel of the Patron
  [39, 12, 5, 5]                        # the breathing door
])
[[9, 11], [12, 17], [15, 11], [18, 17], [21, 11]].each { |x, y| an.set(x, y, 2, x.odd? ? 800 : 801) }   # root-columns lit from within
rock(an, [[27, 4], [36, 4], [27, 24], [36, 24]])
[13, 14].each { |y| an.warp(2, y, ID[:sanctum], 40, y, 4, name: "Back to the sanctum") }
an.cutscene(4, 14, :antechapel_enter)
[[14, 13], [18, 15]].each { |x, y| gone_after(an, x, y, "Aurora-lit guardian", "Followers/FROSLASS", "FT.antechapel_guardians(@event_id)", dir: 4, switch: SW_ANTECHAPEL) }
being(an, 22, 12, "Ghost of the Shard (the echo)", "FT_sephek", "FT.shard_echo(@event_id)", dir: 4, opacity: 120)   # (ECHO: lines find it)
[29, 34].each { |x| (13..15).each { |y| step_trigger(an, x, y, "Thorned roots", "FT.thorn_run(@event_id)") } }
# The Echo Vault's gifts wait here now, before the Heart, not after the dragon
# flies (notes 08 E12): the seed-pods, the chardalyn, their guardian, the mimic.
thing(an, 29, 5, "Seed-pods", "FT.echo_vault_pods(@event_id)", tile: 809)
thing(an, 34, 5, "Chardalyn fragments", "FT.echo_vault_items(@event_id)", tile: 808)
being(an, 31, 8, "Drifting guardian", "Followers/DRIFBLIM_fly", "FT.vault_guardian(@event_id)", step: true)
being(an, 34, 9, "Auroral roots", "Followers/TREVENANT", "FT.aurora_treasury(@event_id)", dir: 4)
thing(an, 31, 19, "Shrine of two sigils: frost sigil, fire sigil", "FT.silent_chapel(@event_id)", tile: 582)   # (both voices find it)
[13, 14, 15].each { |y| barrier(an, 39, y, "Breathing door", "FT.breathing_door(@event_id)", SW_ANTECHAPEL) }
[13, 14, 15].each { |y| an.warp(43, y, HEART, 4, 12, 6, name: "Into the Heart Chamber") }
save(an, :antechapel)

# ---------------------------------------------------------------------------
# 2154: the Sloughing Veins: the chamber collapses into a tunnel of sloughing
# roots and cooling sap, back toward Rootspire.
sv = cave_map(40, 24)
paint_rooms(sv, [[2, 9, 30, 6], [37, 9, 2, 6]])
cave_bridge_h(sv, 32, 36, 11)           # the last root-bridge
rock(sv, [[9, 9], [17, 14], [25, 9]])
sv.cutscene(4, 12, :sloughing_veins)
[[8, 11], [14, 13], [20, 10], [23, 12]].each { |x, y| step_trigger(sv, x, y, "Falling debris", "FT.veins_debris(@event_id)") }
(9..14).each { |y| step_trigger(sv, 28, y, "Mirror-spawn", "FT.veins_mirror_spawn(@event_id)") }
step_trigger(sv, 32, 11, "Collapsing bridge", "FT.veins_bridge(@event_id)")
step_trigger(sv, 32, 12, "Collapsing bridge", "FT.veins_bridge(@event_id)")
[11, 12].each { |y| sv.warp(38, y, ID[:echo_vault], 4, 11, 6, name: "Into the quiet") }
save(sv, :sloughing)

# ---------------------------------------------------------------------------
# 2155: the Echo Vault, and the Aurora Treasury in its inner recess.
ev = cave_map(32, 22)
paint_rooms(ev, [[2, 9, 5, 5], [7, 5, 14, 13], [21, 8, 8, 6]])
rock(ev, [[7, 17], [20, 17], [28, 8]])
ev.cutscene(4, 11, :echo_vault_enter)
thing(ev, 13, 16, "The tree's whisper", "FT.world_tree_echo(@event_id)", tile: 582)
thing(ev, 13, 5, "Root-stair up", "FT.echo_vault_exit(@event_id)", tile: 582)
save(ev, :echo_vault)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT}"
