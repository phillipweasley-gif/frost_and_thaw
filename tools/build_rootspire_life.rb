# Builds Rootspire as a living city (the faithful build-out, worker W5):
# the eighteen shops of the Merchant & Downtime Compendium, on the tiers the
# compendium puts them, with the Seasonal Factions dossier's people behind the
# counters; the Rootwarden Hall and Spire Armory; the Fractured Halo's Frozen
# Cellar under the old Verdant Cask brewery; the Smuggler's Run under the Split
# Dock (the Verdant Heist); and the Frozen Run across the still half of the
# Glasswater (the Corsairs' escort).
#
#   2180 The Verdant Halls        Trunk-Tier civic ring (shops, Rootwarden Hall, the old brewery)
#   2181 Run & Bloom Apothecary   2182 Glasswater Outfitter     2183 Rootwarden Hall & Spire Armory
#   2184 Gem & Thorn Exchange     2185 The Perfumed Root         2186 Auroral Arms
#   2187 Thorned Ledger Bank      2188 The Frozen Cellar
#   2189 The Lightfall Promenade  Canopy-Tier (ateliers, shrines, the shuttered Suncleft)
#   2190 Auroral Atelier          2191 Shrine of Balance         2192 Ink & Ember Bookhouse
#   2193 Crystal Quill Scrollworks 2194 Suncleft Emporium        2195 Frost-Thread Clothier
#   2196 Verdant Stables          2197 Mirror-Dust Curiosity Shop  (Root-Tier)
#   2198 The Smuggler's Run       2199 The Frozen Run
#
# The way in to each tier is added by build_ch6.rb (Trunk, Root) and
# build_ch6b.rb (Canopy), which this file runs after.
require_relative "ft_common"
require_relative "cavekit"

ID = { halls: 2180, run_bloom: 2181, outfitter: 2182, warden_hall: 2183, gem_thorn: 2184, perfumed_root: 2185,
       auroral_arms: 2186, ledger_bank: 2187, frozen_cellar: 2188, promenade: 2189, atelier: 2190,
       balance_shrine: 2191, ink_ember: 2192, crystal_quill: 2193, suncleft: 2194, frost_thread: 2195,
       stables: 2196, mirror_dust: 2197, smugglers_run: 2198, frozen_run: 2199 }
NAMES = { halls: "The Verdant Halls", run_bloom: "Run & Bloom Apothecary", outfitter: "Glasswater Outfitter",
          warden_hall: "Rootwarden Hall", gem_thorn: "Gem & Thorn Exchange", perfumed_root: "The Perfumed Root",
          auroral_arms: "Auroral Arms", ledger_bank: "Thorned Ledger Bank", frozen_cellar: "The Frozen Cellar",
          promenade: "The Lightfall Promenade", atelier: "Auroral Atelier", balance_shrine: "Shrine of Balance",
          ink_ember: "Ink & Ember Bookhouse", crystal_quill: "Crystal Quill Scrollworks", suncleft: "Suncleft Emporium",
          frost_thread: "Frost-Thread Clothier", stables: "Verdant Stables", mirror_dust: "Mirror-Dust Curiosity Shop",
          smugglers_run: "The Smuggler's Run", frozen_run: "The Frozen Run" }
MUSIC = { halls: "Azalea Town", run_bloom: "Violet City ", outfitter: "Violet City ", warden_hall: "Ecruteak City",
          gem_thorn: "Violet City ", perfumed_root: "Ecruteak City", auroral_arms: "Violet City ", ledger_bank: "Ecruteak City",
          frozen_cellar: "Lavender Town", promenade: "Azalea Town", atelier: "Ecruteak City", balance_shrine: "tintower",
          ink_ember: "Ecruteak City", crystal_quill: "Violet City ", suncleft: "Lavender_Town_Pokemon_Tower_Remix",
          frost_thread: "Violet City ", stables: "route38_39", mirror_dust: "Lavender Town",
          smugglers_run: "Seafoam Islands Music", frozen_run: "Seafoam Islands Music" }
ROOTSPIRE, ROOT_TIER, CANOPY, SAP_SHOP, SHRINE = 2050, 2055, 2061, 2052, 2056
SW_RITE_STOPPED = 3936
SW_SUNCLEFT_OPEN = 4160      # the Ember-Rat's trail leads into the shuttered Suncleft Emporium
SW_CELLAR_FOUND  = 4161      # the Frozen Cellar's trapdoor is found (a Halo token, or Kethan's tip)
SW_RUN_OPEN      = 4162      # the Smuggler's Run hatch is unbarred (Darrus's job, or Jorik's ore)
SW_ASH_EXPOSED   = 4163      # the Rootwarden infiltrator is unmasked: gone from his post
SW_FROZEN_RUN    = 4164      # Ivran's escort is under way

def save(b, key) = save_map(b, ID[key], MUSIC[key])

# An interior whose base map runs off its own edge: the open edge cells become
# the room's corner wall (whatever the base map has at 0,0).
def seal_room(b)
  wall = (0..2).map { |z| b.map.data[0, 0, z] }
  (0...b.w).each do |x|
    (0...b.h).each do |y|
      next unless x == 0 || y == 0 || x == b.w - 1 || y == b.h - 1
      (0..2).each { |z| b.map.data[x, y, z] = wall[z] }
    end
  end
end

SW_LANTERN = 4166; SW_EREN_TROUBLED = 4170
# A faction's watcher (see build_ch6.rb): faint, plain under Jast's lantern, gone once dealt with.
def watcher(b, x, y, key, sprite)
  b.event(x, y, "Watcher #{key}", [
    { graphic: sprite, direction: 2, opacity: 60, step_anime: true, script: "FT.watcher(:#{key}, @event_id)" },
    { switch: SW_LANTERN, graphic: sprite, direction: 2, opacity: 230, step_anime: true, script: "FT.watcher(:#{key}, @event_id)" },
    { self_switch: "A", graphic: "", through: true }
  ])
end

# An interior grown from a base-game map, with its way out given explicitly
# (some base maps have as many stairs as front doors).
def interior(base, exits)
  b, _auto = Builder.from_existing(base)
  b.map.events.delete_if { |_id, e| e.name == "Closed" && exits.include?([e.x, e.y]) }
  [b, exits]
end

# Where the base map's own people stood (walkable, and facing the room).
def spots(base)
  m = MapKit.load_map(base)
  m.events.values.select { |e| !e.pages[0].graphic.character_name.empty? && e.pages[0].list.none? { |c| c.code == 201 } }
           .sort_by { |e| [e.y, e.x] }.map { |e| [e.x, e.y, e.pages[0].graphic.direction] }
end

# A shopkeeper (or anyone) whose talk is a function: FT.<fn>(@event_id).
def person(b, x, y, graphic, fn, dir: 2, name: nil, pages: nil)
  b.event(x, y, name || fn.to_s, pages || [{ graphic: graphic, direction: dir, script: "FT.#{fn}(@event_id)" }])
end

# A door in a cave floor or a wall that only opens once a story switch is on.
def gated(b, x, y, switch, closed_script, to, name, tile: nil)
  se = MapKit.deep_copy(b.instance_variable_get(:@door_template).pages[0].list[0].parameters[0])
  cmds = [b.send(:command, 250, [se]), b.send(:command, 223, [Tone.new(-255, -255, -255, 0), 6]), b.send(:command, 106, [8]),
          b.send(:command, 201, [0, *to, 1]), b.send(:command, 223, [Tone.new(0, 0, 0, 0), 6])]
  closed = { trigger: 1, script: "#{closed_script}\npbMoveRoute($game_player, [PBMoveRoute::Backward])" }
  open = { switch: switch, trigger: 1, commands: cmds }
  if tile
    closed[:tile_id] = tile; open[:tile_id] = tile
  end
  b.event(x, y, name, [closed, open])
end

# ---------------------------------------------------------------------------
# 2180: the Verdant Halls, the Trunk-Tier's civic ring (grown from Violet
# City: green terraces round a tower). Up the root-stair from the market's
# north-west corner. Shops, the Rootwarden Hall in the tower, and the old
# Verdant Cask brewery, shut these thirty years.
vh, _ex = Builder.from_existing(230)
vh.map.events.clear
HALL_DOORS = {
  [10, 29] => [:run_bloom, 9, 9],       [20, 30] => [:outfitter, 12, 12],  [25, 27] => [:gem_thorn, 6, 12],
  [31, 29] => [:auroral_arms, 6, 11],   [38, 12] => [:warden_hall, 11, 22], [54, 30] => [:perfumed_root, 9, 14],
  [55, 30] => [:perfumed_root, 9, 14],  [49, 42] => [:ledger_bank, 4, 14]
}
HALL_DOORS.each { |(x, y), (key, ix, iy)| vh.door(x, y, ID[key], ix, iy, 8, name: "Door #{NAMES[key]}") }
# the old brewery: shut, until somebody finds the cellar under it
gated(vh, 33, 45, SW_CELLAR_FOUND, "FT.talk(:brewery_shut, @event_id)", [ID[:frozen_cellar], 25, 24, 8], "Door old brewery")
(39..41).each { |y| vh.warp(63, y, ROOTSPIRE, 17, 9, 2, name: "Root-stair down to the market") }
vh.sign(58, 32, :halls_sign)
vh.sign(36, 14, :armory_sign)
# people of the civic ring (the dossier's Trunk-Tier, and the 20 new NPCs)
person(vh, 22, 31, "BW (28)", :talwyn, dir: 2, name: "Talwyn Frostrill")
person(vh, 41, 31, "BW (52)", :harget, dir: 2, name: "Harget Flinttoe")
person(vh, 30, 31, "BW (84)", :pellar, dir: 4, name: "Pellar Wicket")
person(vh, 16, 31, "BW (67)", :yorin, dir: 2, name: "Old Yorin")
person(vh, 45, 32, "BW (133)", :rilka, dir: 8, name: "Rilka Dawnshard")
person(vh, 52, 31, "BW (115)", :gurk, dir: 2, name: "Gurk Thistlebane")
# a sapling between the planks (Spring's "Whispering Sapling")
person(vh, 35, 32, "", :whispering_sapling, name: "Sapling", pages: [{ graphic: "Followers/SEEDOT", direction: 2, step_anime: false,
                                                                      walk_anime: false, opacity: 200, script: "FT.whispering_sapling(@event_id)" }])
# the Council's standing-board (the seasonal factions' favour), and the Timeline of Renewal carved in the ring
person(vh, 58, 31, "", :favour_board, name: "Standing-board")
vh.sign(24, 28, :timeline_wall)
vh.trainer(27, 33, nil, :warden_bryony, :FT_ROOTWARDEN, dir: 4, sight: 3)
vh.trainer(48, 31, nil, :clerk_fenn, :FT_SCHOLAR, dir: 4, sight: 2)
seal_edges(vh)
save(vh, :halls)

# 2181 Run & Bloom Apothecary: Bryn of Spring, and Nivva at the annex stand
rb, ex = interior(439, [[8, 10], [9, 10], [10, 10]])
exits_to(rb, ex, ID[:halls], 10, 30)
s = spots(439)
person(rb, *s[0][0, 2], "BW (29)", :bryn, dir: 2, name: "Bryn of Spring")
person(rb, 5, 6, "Followers/BUNEARY", :nivva_shop, dir: 6, name: "Nivva Sunwick")
rb.sign(12, 5, :run_bloom_corks)
save(rb, :run_bloom)

# 2182 Glasswater Outfitter: Tirena Loch-Vine and her maps
go, ex = interior(834, [[11, 13], [12, 13], [13, 13]])
exits_to(go, ex, ID[:halls], 20, 31)
seal_room(go)
s = spots(834)
person(go, *s[0][0, 2], "BW030", :tirena, dir: s[0][2], name: "Tirena Loch-Vine")
go.sign(4, 4, :tirena_maps)
save(go, :outfitter)

# 2183 Rootwarden Hall & the Spire Armory: Captain Kethan Vale; Arvik in the
# training yard; the Oath of Roots before the living pillar.
wh, ex = interior(432, [[10, 23], [11, 23], [12, 23], [13, 23]])
exits_to(wh, ex, ID[:halls], 38, 13)
person(wh, 12, 13, "BW (71)", :kethan, dir: 2, name: "Captain Kethan Vale")
person(wh, 6, 6, "BW029", :arvik, dir: 2, name: "Arvik")
person(wh, 9, 9, "FT_captain_rheven_stormbranch", :rheven_hall, dir: 4, name: "Rheven at the Armory",
       pages: [{ graphic: "", through: true },
               { switch: 3941, graphic: "FT_captain_rheven_stormbranch", direction: 4, script: "FT.rheven_hall(@event_id)" }])
wh.sign(2, 9, :armory_targets)
wh.sign(13, 17, :warden_map)
wh.event(11, 18, "Oath pillar", [{ graphic: "", script: "FT.oath_pillar(@event_id)" }])
wh.event(13, 21, "Eren Frostborn", [{ graphic: "", through: true },
                                    { switch: SW_EREN_TROUBLED, graphic: "BW029", direction: 8, script: "FT.eren_armory(@event_id)" }])
wh.trainer(6, 12, nil, :warden_claw, :FT_ROOTWARDEN, dir: 6, sight: 3)
wh.trainer(17, 10, nil, :warden_seed, :FT_ROOTWARDEN, dir: 4, sight: 3)
save(wh, :warden_hall)

# 2184 Gem & Thorn Exchange: Arvoss Ember-Scale
gt, ex = interior(280, [[5, 13], [6, 13], [7, 13]])
exits_to(gt, ex, ID[:halls], 25, 28)
s = spots(280)
person(gt, *s[0][0, 2], "BW (104)", :arvoss, dir: s[0][2], name: "Arvoss Ember-Scale")
gt.event(13, 8, "Humming gem", [{ graphic: "", script: "FT.humming_gem(@event_id)" }])
save(gt, :gem_thorn)

# 2185 The Perfumed Root: Lirielle's own shop
pr, ex = interior(407, [[8, 15], [9, 15], [10, 15]])
exits_to(pr, ex, ID[:halls], 54, 31)
s = spots(407)
person(pr, 10, 8, "Followers/BUNEARY", :perfumer, dir: 2, name: "Lirielle's counter")
pr.sign(12, 10, :perfume_shelf)
save(pr, :perfumed_root)

# 2186 Auroral Arms: Brogar Frostvein and his crystal arm
aa, ex = interior(370, [[6, 12]])
exits_to(aa, ex, ID[:halls], 31, 30)
s = spots(370)
person(aa, *s[0][0, 2], "BW (113)", :brogar, dir: s[0][2], name: "Brogar Frostvein")
save(aa, :auroral_arms)

# 2187 Thorned Ledger Bank: the Accountancy (a fungal collective) and its vault
lbk, ex = interior(298, [[4, 15], [5, 15]])
exits_to(lbk, ex, ID[:halls], 49, 43)
person(lbk, 8, 10, "Followers/BRELOOM", :accountancy, dir: 2, name: "The Accountancy")
person(lbk, 3, 11, "Followers/SHROOMISH", :counting_spore, dir: 2, name: "Counting spore",
       pages: [{ graphic: "Followers/SHROOMISH", direction: 2, step_anime: true, script: "FT.counting_spore(@event_id)" }])
lbk.sign(2, 12, :vault_door)
lbk.map.events.delete_if { |_id, e| e.name == "Closed" }
save(lbk, :ledger_bank)

# 2188 The Frozen Cellar, under the old Verdant Cask brewery: the Fractured
# Halo's second hideout (and where Eline's Frozen Flame meets).
fc, ex = interior(625, [[24, 25], [25, 25], [26, 25]])
exits_to(fc, ex, ID[:halls], 33, 46)
fc.cutscene(25, 23, :frozen_cellar_enter)
fc.event(18, 9, "Frozen Flame altar", [{ graphic: "", script: "FT.frozen_flame_altar(@event_id)" }])
fc.trainer(20, 19, nil, :halo_frost_wick, :FT_HALO, dir: 4, sight: 3)
fc.trainer(16, 14, nil, :halo_soot_ren, :FT_HALO, dir: 4, sight: 4)
fc.trainer(21, 10, nil, :halo_cinder_oda, :FT_HALO, dir: 4, sight: 3)
fc.event(16, 10, "Eira Voss", [
  { graphic: "BW (51)", direction: 2, script: "FT.eira_voss_cellar(@event_id)" },
  { self_switch: "A", graphic: "", through: true }
])
fc.sign(30, 22, :cellar_casks)
save(fc, :frozen_cellar)

# ---------------------------------------------------------------------------
# 2189: the Lightfall Promenade, on the Canopy-Tier (grown from Ecruteak City:
# towers among red and gold leaves). The Atelier's prism-tower, the Shrine of
# Balance, the bookhouse and scrollworks, the clothier, and the Suncleft
# Emporium on the Upper Sunwalk, shuttered since the Reversal.
pm, _ex = Builder.from_existing(359)
pm.map.events.clear
PROM_DOORS = {
  [22, 37] => [:atelier, 9, 13], [15, 15] => [:balance_shrine, 9, 13], [21, 29] => [:ink_ember, 25, 6],
  [29, 28] => [:crystal_quill, 7, 12], [30, 28] => [:crystal_quill, 8, 12], [37, 28] => [:frost_thread, 9, 7],
  [38, 28] => [:frost_thread, 9, 7]
}
PROM_DOORS.each { |(x, y), (key, ix, iy)| pm.door(x, y, ID[key], ix, iy, 8, name: "Door #{NAMES[key]}") }
[31].each { |x| gated(pm, x, 37, SW_SUNCLEFT_OPEN, "FT.suncleft_door(@event_id)", [ID[:suncleft], 11, 14, 8], "Door Suncleft Emporium") }
[[37, 37], [52, 37], [47, 37], [66, 19], [65, 20], [66, 21], [60, 34], [60, 35]].each do |x, y|
  pm.event(x, y, "Closed", [{ trigger: 1, script: "FT.talk(:promenade_closed, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])" }])
end
(28..31).each { |x| pm.warp(x, 45, CANOPY, 9, 13, 2, name: "Down the leaf-bridge to the Canopy") }
pm.sign(34, 40, :promenade_sign)
pm.sign(30, 37, :sunwalk_sign)
# the Canopy's people (dossier: Autumn's Artisan Promenade, the Lightfall walk)
person(pm, 41, 33, "BW (107)", :elitha, dir: 2, name: "Elitha Snowmere")
pm.event(42, 32, "Frost sculpture", [{ graphic: "Followers/FROSLASS", direction: 2, opacity: 150, step_anime: false, walk_anime: false,
                                       script: "FT.elitha_sculpture(@event_id)" }])
person(pm, 24, 32, "BW (88)", :mira_thynelight, dir: 2, name: "Mira Thynelight")
person(pm, 18, 33, "BW033", :serelle, dir: 2, name: "Serelle of the Still Veil")
watcher(pm, 16, 30, :veil_shade, "Followers/MISDREAVUS_fly")
watcher(pm, 46, 33, :moth_swarm, "Followers/VENOMOTH_fly")
watcher(pm, 26, 39, :weasel, "Followers/FURRET")
pm.trainer(33, 31, nil, :prom_patron_vell, :GENTLEMAN, dir: 2, sight: 3)
pm.trainer(44, 39, nil, :prom_artist_cora, :BEAUTY, dir: 8, sight: 3)
seal_edges(pm)
save(pm, :promenade)

# 2190 Auroral Atelier: Lumea Keth
at, ex = interior(385, [[8, 14], [9, 14], [10, 14]])
exits_to(at, ex, ID[:promenade], 22, 38)
watcher(at, 6, 8, :rune_beetle, "Followers/LEDYBA_fly")
s = spots(385)
person(at, *s[0][0, 2], "BW (64)", :lumea, dir: s[0][2], name: "Lumea Keth")
at.event(14, 8, "Escaped illusion", [{ graphic: "Followers/VULPIX", direction: 2, opacity: 140, step_anime: true, script: "FT.atelier_fox(@event_id)" },
                                      { self_switch: "A", graphic: "", through: true }])
save(at, :atelier)

# 2191 Shrine of Balance: Ysera Dorn
bs, ex = interior(649, [[9, 14]])
exits_to(bs, ex, ID[:promenade], 15, 16)
seal_room(bs)
person(bs, 9, 7, "BW (100)", :ysera, dir: 2, name: "Ysera Dorn")
bs.sign(4, 11, :four_arches)
save(bs, :balance_shrine)

# 2192 Ink & Ember Bookhouse: Mirna Cowl
ie, ex = interior(381, [[26, 5], [26, 6]])
exits_to(ie, ex, ID[:promenade], 21, 30)
s = spots(381)
person(ie, *s[0][0, 2], "BW (78)", :mirna, dir: s[0][2], name: "Mirna Cowl")
ie.event(12, 9, "Mirror-glass letters", [{ graphic: "", script: "FT.mirror_letters(@event_id)" }])
save(ie, :ink_ember)

# 2193 Crystal Quill Scrollworks: Filgen Rootfoot
cq, ex = interior(206, [[7, 13], [8, 13]])
exits_to(cq, ex, ID[:promenade], 29, 29)
s = spots(206)
person(cq, *s[0][0, 2], "BW (109)", :filgen, dir: s[0][2], name: "Filgen Rootfoot")
cq.event(14, 11, "Blank scrolls", [{ graphic: "", script: "FT.blank_scrolls(@event_id)" }])
save(cq, :crystal_quill)

# 2194 Suncleft Emporium: shut since the Reversal, shelves still full
sc, ex = interior(292, [[10, 15], [11, 15], [12, 15], [13, 15]])
exits_to(sc, ex, ID[:promenade], 31, 38)
sc.cutscene(11, 13, :suncleft_enter)
sc.event(12, 9, "Helion's mural", [{ graphic: "", script: "FT.helion_mural(@event_id)" }])
sc.event(3, 7, "Shelves", [{ graphic: "", script: "FT.suncleft_shelves(@event_id)" }])
sc.event(19, 5, "Warm hatch", [{ graphic: "", script: "FT.suncleft_hatch(@event_id)" }])
save(sc, :suncleft)

# 2195 Frost-Thread Clothier: Maera Vell
ft, ex = interior(514, [[8, 8], [9, 8], [10, 8]])
exits_to(ft, ex, ID[:promenade], 37, 29)
s = spots(514)
person(ft, 9, 5, "BW (89)", :maera, dir: 2, name: "Maera Vell")
ft.event(12, 6, "Crowning robes", [{ graphic: "", script: "FT.crowning_robes(@event_id)" }])
save(ft, :frost_thread)

# ---------------------------------------------------------------------------
# 2196 Verdant Stables (Root-Tier): Thim Wicker, frost-elk and pseudodragons
st, ex = interior(204, [[5, 14], [6, 14], [7, 14]])
exits_to(st, ex, ROOT_TIER, 11, 18)
s = spots(204)
person(st, *(s[0] ? s[0][0, 2] : [6, 8]), "BW (16)", :thim, dir: 2, name: "Thim Wicker")
st.event(13, 6, "Frost elk", [{ graphic: "Followers/STANTLER", direction: 2, script: "FT.stable_beast(@event_id)" }])
st.event(3, 6, "Pseudodragon", [{ graphic: "Followers/DRATINI", direction: 2, step_anime: true, script: "FT.talk(:stable_pseudodragon, @event_id)" }])
save(st, :stables)

# 2197 Mirror-Dust Curiosity Shop (Root-Tier, Narrow Spine Alley): Jast Penumbran
md, ex = interior(713, [[7, 13], [8, 13], [9, 13], [10, 13]])
exits_to(md, ex, ROOT_TIER, 22, 18)
s = spots(713)
person(md, *(s[0] ? s[0][0, 2] : [8, 6]), "BW (110)", :jast, dir: 2, name: "Jast Penumbran")
md.event(4, 9, "Tall mirror", [{ graphic: "", script: "FT.jast_mirror(@event_id)" }])
save(md, :mirror_dust)

# ---------------------------------------------------------------------------
# 2198 The Smuggler's Run: tunnels under the Split Dock. Jorik's ore cache,
# the Rootwardens' wards, and the Guild of Roots and Stone's sealed vault
# (the reliquary Darrus wants). East, the Corsairs' old moorings.
sr = cave_map(44, 26)
fl = {}
[[3, 2, 6, 5], [8, 4, 14, 3], [20, 2, 8, 7], [24, 8, 3, 8], [14, 14, 13, 4], [6, 10, 4, 12], [9, 18, 8, 3],
 [27, 15, 12, 3], [36, 6, 5, 10], [29, 20, 10, 4], [33, 17, 2, 4]].each do |x, y, w, h|
  Builder.rect_cells(x, y, w, h).each { |c| fl[c] = true }
end
cave_paint(sr, fl)
[[4, 3], [21, 3], [27, 3], [7, 11], [7, 20], [15, 15], [37, 7], [38, 22]].each { |x, y| sr.set(x, y, 2, 792) }
sr.warp(5, 2, ROOT_TIER, 29, 12, 2, name: "Up through the dock hatch")
sr.cutscene(5, 4, :smugglers_run_enter)
# Jorik's cache: crates of infernal ore
[[21, 5], [22, 5], [23, 5]].each { |x, y| sr.set(x, y, 2, CRATE) }
sr.event(22, 6, "Ore crates", [{ graphic: "BARREL", script: "FT.ore_crates(@event_id)" }])
# the heist: four wards and watches between the hatch and the vault
{ [10, 5] => 1, [25, 10] => 2, [18, 15] => 3, [8, 15] => 4 }.each do |(x, y), n|
  sr.event(x, y, "Ward #{n}", [{ trigger: 1, through: true, script: "FT.heist_ward(#{n}, @event_id)" },
                              { self_switch: "A", through: true }])
end
sr.event(12, 17, "Guild vault", [{ graphic: "", script: "FT.guild_vault(@event_id)" }])
sr.trainer(26, 13, nil, :run_warden_moss, :FT_ROOTWARDEN, dir: 8, sight: 3)
sr.trainer(15, 16, nil, :run_smuggler_kett, :SAILOR, dir: 2, sight: 3)
# the old moorings, east: where Darrus runs if he's exposed
sr.event(41, 10, "Old moorings", [{ graphic: "", script: "FT.old_moorings(@event_id)" }])
sr.event(36, 21, "Darrus, hiding", [{ graphic: "", through: true },
                                    { switch: 4165, graphic: "BW (55)", direction: 4, script: "FT.darrus_hiding(@event_id)" }])
save(sr, :smugglers_run)

# 2199 The Frozen Run: across the still-frozen half of the Glasswater, beside
# Captain Ivran's trade sledge-ship. Revenant sailors walk the ice.
FRW, FRH = 46, 20
fr = Builder.new(FRW, FRH)
fr.fill(0, SNOW)
SOLID_ICE = 8426
lane = {}
Builder.rect_cells(1, 7, 44, 6).each { |c| lane[c] = true }
[[8, 4, 5, 4], [19, 12, 6, 5], [30, 3, 6, 5], [38, 12, 5, 4]].each { |x, y, w, h| Builder.rect_cells(x, y, w, h).each { |c| lane[c] = true } }
(0...FRW).each { |x| (0...FRH).each { |y| fr.set(x, y, 0, SOLID_ICE) unless lane[[x, y]] } }
# frozen hulls and crews standing in the ice
[[10, 5], [21, 14], [32, 4], [40, 13]].each { |x, y| fr.stamp(ICE_BOULDER, x, y) }
[[14, 8], [26, 11], [35, 8]].each { |x, y| fr.set(x, y, 2, CRATE) }
fr.warp(0, 9, ROOT_TIER, 36, 8, 4, name: "Back to the Split Dock")
fr.warp(0, 10, ROOT_TIER, 36, 8, 4, name: "Back to the Split Dock")
fr.cutscene(2, 9, :frozen_run_start)
fr.trainer(12, 9, nil, :revenant_hask, :SAILOR, dir: 4, sight: 4)
fr.trainer(24, 10, nil, :revenant_moirin, :SAILOR, dir: 4, sight: 4)
fr.trainer(33, 9, nil, :revenant_tobe, :SAILOR, dir: 4, sight: 4)
fr.event(45, 9, "The far shore", [{ graphic: "", script: "FT.frozen_run_end(@event_id)" }])
fr.event(45, 10, "The far shore", [{ graphic: "", script: "FT.frozen_run_end(@event_id)" }])
# (each stands on the ice just below a frozen hull)
[[11, 7], [22, 16], [33, 7], [41, 15]].each_with_index do |(x, y), i|
  fr.event(x, y, "Frozen sailor #{i + 1}", [{ graphic: "BW_Sailor", direction: 2, opacity: 150, step_anime: false, walk_anime: false,
                                                    script: "FT.talk(:frozen_sailor, @event_id)" }])
end
seal_edges(fr)
save(fr, :frozen_run)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT}"
