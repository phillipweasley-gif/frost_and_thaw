# Builds Rootspire's hub maps (Act II, Chapter 6 continued): the Hearth's
# root-cellar (Gym 4), the Blooming Fields, the Canopy-Tier, the Wind-Glass
# Library, the College of Auroral Arts, the Rootwarden Crypt and Hyphora's
# Undercanopy (the myconid colony, Gym 7).
require_relative "ft_common"
require_relative "cavekit"

ID = { hearth_cellar: 2059, fields: 2060, canopy: 2061, library: 2062, college: 2063, crypt: 2065, undercanopy: 2068 }
NAMES = { hearth_cellar: "The Hearth's Root-Cellar", fields: "The Blooming Fields", canopy: "Rootspire Canopy-Tier",
          library: "The Wind-Glass Library", college: "College of Auroral Arts", crypt: "The Rootwarden Crypt",
          undercanopy: "Hyphora's Undercanopy" }
MUSIC = { hearth_cellar: "gym_kanto", fields: "route38_39", canopy: "Azalea Town", library: "Ecruteak City",
          college: "Violet City ", crypt: "Lavender Town", undercanopy: "Seafoam Islands Music" }
ROOTSPIRE, HEARTH, ROOT_TIER = 2050, 2053, 2055
SW_TWINS_MET = 3945
SW_LAKE_CLEAN = 3943

def save(b, key) = save_map(b, ID[key], MUSIC[key])

# --- the faithful build-out (W5) --------------------------------------------
PROMENADE = 2189
SW_LANTERN = 4166; SW_ORB_HALO = 4167; SW_KELYN_ORB = 4169; SW_EREN_TROUBLED = 4170
SW_SPIRITS = 4171; SW_STILL_BEAST = 4172; SW_TALWYN_FIELDS = 4173; SW_HALDEN = 4176; SW_FROSTFELL = 4177
def shown_on(b, x, y, name, switch, graphic, script, dir: 2, opacity: 255)
  b.event(x, y, name, [{ graphic: "", through: true },
                       { switch: switch, graphic: graphic, direction: dir, opacity: opacity, script: script }])
end

def stairs_closed(b, x, y)
  b.event(x, y, "Closed", [{ trigger: 1, script: "FT.talk(:closed_off, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])" }])
end

# ---------------------------------------------------------------------------
# 2059: the Hearth's root-cellar (grown from Azalea's gym: roots growing down
# through the floor like a forest). Gym 4: Hellen Brightrun. The shrine her
# family kept to the Heralds stands by the stair.
hc, ex = Builder.from_existing(337)
hc.map.events.clear
# the gym's cut-the-web gates: open them for good (roots grown aside, not webs)
[[8, 11], [14, 11], [12, 14], [11, 11], [6, 16], [5, 14], [12, 17], [8, 14]].each { |x, y| hc.set(x, y, 1, 0); hc.set(x, y, 2, 0) }
exits_to(hc, ex, HEARTH, 5, 4)
hc.event(15, 8, "Hellen Brightrun", [{ graphic: "FT_hellen", direction: 2, script: "FT.leader_hellen(@event_id)" }])
hc.trainer(7, 15, nil, :hearth_dunstan, :WORKER, dir: 6, sight: 3)
hc.trainer(11, 12, nil, :hearth_mellow, :BEAUTY, dir: 2, sight: 3)
hc.trainer(14, 15, nil, :hearth_corrie, :FISHERMAN, dir: 4, sight: 2)
hc.trainer(12, 20, nil, :hearth_tallis, :GENTLEMAN, dir: 6, sight: 3)
hc.event(3, 22, "Sign herald_shrine", [{ graphic: "", script: "FT.herald_shrine_event(@event_id)" }])   # Hellen's errand (048_H)
# Hellen's old passage down to the Root-Tier docks, behind the sun-chalked cask (048_H; switch 4180)
# (in the corner below the shrine: (3,23) is where you stand to pray at it)
hc.event(5, 24, "Sun-chalked cask", [
  { graphic: "BARREL", script: "FT.talk(:old_cask, @event_id)" },
  { switch: 4180, graphic: "BARREL", commands: [
    hc.send(:command, 355, ["FT.hearth_passage_down(@event_id)"]),
    hc.send(:command, 223, [Tone.new(-255, -255, -255, 0), 6]), hc.send(:command, 106, [8]),
    hc.send(:command, 201, [0, 2055, 37, 9, 4, 1]), hc.send(:command, 223, [Tone.new(0, 0, 0, 0), 6])] }
])
hc.sign(14, 22, :cellar_sign)
save(hc, :hearth_cellar)

# ---------------------------------------------------------------------------
# 2060: the Blooming Fields. The Sky-Path east out of the market, across
# tundra where flowers and snow grow together, to the Auroral Wall. The Still
# Ones stand frozen near the Wall; so does a hunter with Alerion's face.
FW, FH = 48, 26
fl = Builder.new(FW, FH)
fl.fill(0, SNOW)
fopen = {}
carve = ->(x0, y0, w, h) { Builder.rect_cells(x0, y0, w, h).each { |c| fopen[c] = true } }
carve.(0, 12, 12, 7)          # in from the market
carve.(8, 5, 14, 16)          # the first meadow
carve.(20, 9, 12, 10)         # the Sky-Path
carve.(28, 3, 12, 20)         # the second meadow
carve.(38, 6, 9, 16)          # before the Wall
forest_except(fl, FW, FH, fopen)
FLOWER, MEADOW = 1249, 553
# green meadow ground with flowers, breaking through the snow in patches
# (soft-edged patches: an ellipse, its rim broken up so it doesn't read as a carpet)
[[9, 6, 7, 5], [14, 15, 7, 5], [29, 4, 6, 5], [33, 17, 6, 5], [40, 8, 5, 6]].each_with_index do |(x0, y0, w, h), i|
  cx, cy = x0 + (w - 1) / 2.0, y0 + (h - 1) / 2.0
  Builder.rect_cells(x0 - 1, y0 - 1, w + 2, h + 2).each do |x, y|
    d = ((x - cx) / (w / 2.0))**2 + ((y - cy) / (h / 2.0))**2
    edge = ((x * 7 + y * 13 + i) % 5) == 0
    fl.set(x, y, 0, MEADOW) if fopen[[x, y]] && (d < 0.75 || (d < 1.15 && !edge))
  end
end
[[10, 7], [12, 8], [16, 16], [18, 17], [30, 5], [32, 6], [34, 18], [36, 19], [41, 9], [42, 11], [11, 18], [25, 16]].each { |x, y| fl.set(x, y, 1, FLOWER) }
grass(fl, 9, 11, 5, 3); grass(fl, 22, 10, 6, 2); grass(fl, 30, 10, 4, 5); grass(fl, 39, 15, 4, 3)
[[17, 8], [26, 15], [35, 12]].each { |x, y| tree(fl, x, y, 2) }
# the Auroral Wall: a shimmer of light from the snow to the sky, the map's east edge
# (A-06: the animated curtain, 002b_TilesetPatch.rb; its two columns are solid, the soft edge before them isn't)
(0...FH).each do |y|
  fl.set(FW - 3, y, 2, FrostThaw::AURORA_EDGE) if fl.get(FW - 3, y, 2) == 0
  fl.set(FW - 2, y, 2, FrostThaw::AURORA_WALL)
  fl.set(FW - 1, y, 2, FrostThaw::AURORA_WALL_B)
end
[12, 13, 14, 15, 16, 17, 18].each { |y| fl.warp(0, y, ROOTSPIRE, 58, [[y + 14, 28].max, 31].min, 4, name: "To Rootspire") }
fl.sign(4, 11, :fields_sign)
fl.trainer(13, 13, nil, :bough_teo, :FT_ROOTWARDEN, dir: 4, sight: 3)
fl.trainer(18, 7, nil, :pilgrim_ysolde, :PICNICKER, dir: 2, sight: 3)
fl.trainer(25, 12, nil, :hiker_gromm, :HIKER, dir: 4, sight: 3)
fl.trainer(31, 9, nil, :halo_kael, :FT_HALO, dir: 2, sight: 3)
fl.trainer(37, 16, nil, :eren, :FT_ROOTWARDEN, dir: 4, sight: 3)
fl.stamp(BOULDER, 33, 12)
fl.sign(33, 13, :boundary_stone)
# the Still Ones, frozen along the Wall, and the hunter with Alerion's face
{ [43, 7] => :faith, [43, 11] => :hope, [43, 15] => :love, [43, 19] => :balance }.each do |(x, y), key|
  fl.event(x, y, "Still One #{key}", [{ graphic: "BW (40)", direction: 6, opacity: 150, step_anime: false, walk_anime: false, script: "FT.still_one(:#{key}, @event_id)" }])
end
fl.event(45, 13, "Frozen hunter", [{ graphic: "BW029", direction: 6, opacity: 170, step_anime: false, walk_anime: false, script: "FT.frozen_hunter(@event_id)" }])
# the edge of the light: where the Heartwarden's Staff is bonded (048_H auroral_wall_edge)
[9, 17].each { |y| fl.event(FW - 2, y, "Sign auroral_wall", [{ graphic: "", script: "FT.auroral_wall_edge(@event_id)" }]) }
shown_on(fl, 24, 14, "Talwyn, guarding", SW_TALWYN_FIELDS, "BW (28)", "FT.talwyn_fields(@event_id)", dir: 4)
shown_on(fl, 40, 18, "The Still Beast", SW_STILL_BEAST, "Followers/PILOSWINE", "FT.still_beast(@event_id)", dir: 4, opacity: 210)
shown_on(fl, 34, 6, "Two spirits", SW_SPIRITS, "Followers/VULPIX", "FT.fields_spirits(@event_id)", opacity: 180)
seal_edges(fl)
save(fl, :fields)

# ---------------------------------------------------------------------------
# 2061: the Canopy-Tier (grown from the Pinkan Forest: frost-glass leaves in
# aurora pink). Up from the root-lift in the south-west; the College south-
# east, the Library east, the Celestial Rift at the crown, the Shrine of the
# Twinned Dragons on the great stump, the Aerie Markets in the west clearing.
cn, _ex = Builder.from_existing(531)
cn.map.events.clear
[12, 13].each { |x| cn.event(x, 34, "Root-lift down", [{ trigger: 1, script: "FT.root_lift_down(@event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])" }]) }
[29, 30].each { |x| cn.door(x, 34, ID[:college], 13, 17, 8, name: "To the College") }
[34, 35].each { |x| cn.door(x, 18, ID[:library], 16, 6, 4, name: "To the Library") }
cn.sign(11, 32, :canopy_sign)
cn.event(22, 24, "Twin orb", [{ graphic: "", script: "FT.twin_orb(@event_id)" }])
cn.event(20, 22, "Lumin Weavemoss", [
  { graphic: "FT_wennen_lumin", direction: 2, script: "FT.twin_orb(@event_id)" },
  { switch: SW_TWINS_MET, graphic: "FT_wennen_lumin", direction: 2, script: "FT.lumin(@event_id)" }
])
cn.event(31, 5, "Lumen Shard", [{ graphic: "", script: "FT.lumen_shard(@event_id)" }])
cn.door(9, 12, PROMENADE, 29, 44, 8, name: "Leaf-bridge to the Lightfall Promenade")
shown_on(cn, 21, 25, "Sister Ilse", SW_ORB_HALO, "FT_halo_disciple_female", "FT.twin_orb(@event_id)", dir: 8)
shown_on(cn, 23, 25, "Brother Vosk", SW_ORB_HALO, "FT_halo_disciple_male", "FT.twin_orb(@event_id)", dir: 8)
shown_on(cn, 23, 23, "High Speaker at the orb", SW_KELYN_ORB, "FT_high_speaker_kelyn_of_spring", "FT.kelyn_orb(@event_id)", dir: 4)
cn.event(24, 21, "Sister Selene Marr", [{ graphic: "BW (107)", direction: 6, script: "FT.selene(@event_id)" }])
shown_on(cn, 32, 6, "Portal to the Frostfell", SW_FROSTFELL, "Followers/FROSLASS", "FT.frostfell_portal(@event_id)", opacity: 140)
# (Shade used to keep watch here; Shade became Glimmer at the Rift in Ch6. The twins carry SC 9.02 now.)
cn.sign(30, 5, :rift_sign)
# the twins, once they've come down (SC 6.03): around the Shrine from now on
cn.event(21, 19, "Razzilith", [{ graphic: "", through: true },
                               { switch: SW_TWINS_MET, graphic: "FT_razzilith", direction: 2, step_anime: true, script: "FT.dragon_shrine(:razzilith, @event_id)" }])
cn.event(24, 19, "Frostina", [{ graphic: "", through: true },
                              { switch: SW_TWINS_MET, graphic: "FT_frostina", direction: 2, step_anime: true, script: "FT.dragon_shrine(:frostina, @event_id)" },
                              { switch: 3954, graphic: "", through: true }])
cn.event(10, 14, "Aerie merchant", [{ graphic: "BW (33)", direction: 2, script: "FT.aerie_mart(@event_id)" }])
cn.npc(14, 13, "Followers/XATU", :aarakocra_seer, dir: 2, name: "Aarakocra Seer")
cn.npc(17, 16, "Followers/SEEDOT", :cornipus, dir: 4, name: "Cornipus, Seed of Plaito")
cn.trainer(11, 24, nil, :sky_wren, :FT_SKYSAILOR, dir: 2, sight: 3)
cn.trainer(27, 8, nil, :sky_talla, :FT_SKYSAILOR, dir: 4, sight: 3)
save(cn, :canopy)

# ---------------------------------------------------------------------------
# 2062: the Wind-Glass Library (grown from a museum hall: cases of crystal
# leaves). Eirwen Solglass, the Lorn Scribe, Alberica's sub-vault.
lb, ex = Builder.from_existing(96)
lb.map.events.clear
[6, 7].each { |y| lb.door(17, y, ID[:canopy], 34, 17, 8, name: "Exit") }   # (the museum's own way out was out of reach)
lb.event(7, 4, "Eirwen Solglass", [{ graphic: "FT_eirwen_solglass", direction: 2, script: "FT.eirwen(@event_id)" }])
lb.event(4, 9, "The Lorn Scribe", [{ graphic: "BW (72)", direction: 6, script: "FT.lorn_scribe(@event_id)" }])
lb.event(10, 3, "Solvaran's counter", [{ graphic: "BW (109)", direction: 2, script: "FT.solvaran(@event_id)" }])
lb.event(12, 10, "Pimmlet Natch", [{ graphic: "BW (17)", direction: 4, script: "FT.pimmlet(@event_id)" }])
lb.event(6, 10, "Professor Halden Vex", [{ graphic: "BW (55)", direction: 6, script: "FT.halden_vex(@event_id)" }])
shown_on(lb, 7, 11, "Halden's engine", SW_HALDEN, "", "FT.halden_reset(@event_id)")
lb.event(11, 5, "Alerion's desk", [{ graphic: "", script: "FT.alerion_desk(@event_id)" }])
lb.sign(2, 9, :prophecy_leaf)
lb.npc(14, 8, "FT_wennen_generic", :wennen_scholar, dir: 4, name: "Wennen scholar")
lb.sign(4, 4, :library_note)
lb.event(15, 4, "Sub-vault", [{ graphic: "", script: "FT.subvault(@event_id)" }])
save(lb, :library)

# ---------------------------------------------------------------------------
# 2063: the College of Auroral Arts (grown from a school: two lecture rooms
# off a long hall). Professor Wynsnow; Grafting; the Lecture in Blue Fire.
cg, _ex = Builder.from_existing(360)
cg.map.events.clear
[12, 13, 14].each { |x| cg.door(x, 19, ID[:canopy], 28, 32, 8, name: "Exit") }
stairs_closed(cg, 13, 2)
cg.event(13, 4, "Professor Wynsnow", [{ graphic: "FT_professor_wynsnow", direction: 2, script: "FT.wynsnow(@event_id)" }])
cg.trainer(6, 5, nil, :scholar_pell, :FT_SCHOLAR, dir: 2, sight: 2)
cg.trainer(20, 5, nil, :scholar_quill, :FT_SCHOLAR, dir: 2, sight: 2)
cg.sign(3, 11, :college_relics)
cg.npc(21, 12, "BW (17)", :college_student, dir: 4)
save(cg, :college)

# ---------------------------------------------------------------------------
# 2065: the Rootwarden Crypt, under the Root-Tier. A ring of petrified druids
# stands in clear sap; one holds the Heartwarden's Staff.
cr = cave_map(21, 21)
cave_paint(cr, Builder.rect_cells(4, 3, 13, 15).to_h { |c| [c, true] }.merge(Builder.rect_cells(9, 17, 3, 3).to_h { |c| [c, true] }))
[[5, 4], [15, 4], [5, 15], [15, 15]].each { |x, y| cr.set(x, y, 2, 792) }
cr.warp(10, 19, ROOT_TIER, 25, 22, 4, name: "Up to the Root-Tier")
cr.event(10, 7, "The first Warden", [{ graphic: "BW029", direction: 2, opacity: 200, step_anime: false, walk_anime: false, script: "FT.crypt_staff(@event_id)" }])
[[7, 6], [13, 6], [6, 9], [14, 9], [8, 11], [12, 11]].each_with_index do |(x, y), i|
  cr.event(x, y, "Petrified Warden #{i + 1}", [{ graphic: i.even? ? "BW029" : "BW030", direction: 2, opacity: 140, step_anime: false, walk_anime: false, script: "FT.talk(:crypt_warden, @event_id)" }])
end
cr.sign(10, 3, :crypt_inscription)
save(cr, :crypt)

# ---------------------------------------------------------------------------
# 2068: Hyphora's Undercanopy (grown from the Dark Cave). In through the Sap
# Gate in the south-west: the spore-guard, the Spore Gardens, the Mnemosyne's
# chamber, the Fungal Bazaar, the lake, and the Sovereign's Fane. North-east,
# the root-tunnel to the Rootsun Forge is barricaded.
uc, _ex = Builder.from_existing(364, keep: [11, 12, 13, 14, 15, 16])   # (the side-stairs onto the ledges)
uc.map.events.delete_if { |id, _| ![11, 12, 13, 14, 15, 16].include?(id) }
uc.warp(9, 44, ROOT_TIER, 9, 21, 6, name: "Up through the Sap Gate")
uc.cutscene(9, 42, :undercanopy_enter)
uc.event(10, 40, "Eira Shadebloom", [{ graphic: "FT_myconid_eira", direction: 2, script: "FT.eira(@event_id)" }])
uc.event(9, 30, "Yarro", [{ graphic: "FT_myconid_yarro", direction: 2, step_anime: true, script: "FT.undercanopy_rest(@event_id)" }])
uc.npc(8, 33, "Followers/SHROOMISH", :yarro, dir: 6, name: "Sporeling")
uc.event(12, 25, "The Blight", [{ graphic: "Followers/SHROOMISH", direction: 2, blend_type: 2, step_anime: false, walk_anime: false, script: "FT.yarro_blight(@event_id)" }])
uc.npc(13, 17, "Followers/GLOOM", :lysella, dir: 2, name: "Lysella")
uc.event(8, 19, "Korun", [{ graphic: "FT_myconid_generic", direction: 6, script: "FT.korun_smith(@event_id)" }])   # (his forge: 047d)
uc.event(17, 12, "Mnemosyne Myr", [{ graphic: "FT_myconid_myr", direction: 2, script: "FT.myr(@event_id)" }])
uc.sign(19, 12, :myr_threads)
uc.event(21, 20, "Faria", [{ graphic: "Followers/SHROOMISH", direction: 2, step_anime: true, script: "FT.talk(:faria, @event_id)\nFT.mart(:faria, @event_id)" }])
uc.event(23, 21, "Masked trader", [{ graphic: "FT_halo_disciple_male", direction: 2, script: "FT.masked_trader(@event_id)" }])
uc.event(26, 19, "Zym", [{ graphic: "FT_myconid_generic", direction: 4, script: "FT.talk(:zym, @event_id)" }])
uc.event(39, 27, "The lake", [{ graphic: "", script: "FT.shadow_mycolith(@event_id)" }])
uc.event(45, 17, "Sovereign Luminara", [{ graphic: "FT_luminara", direction: 2, script: "FT.leader_luminara(@event_id)" }])
uc.sign(44, 16, :hyphora_roots)
uc.sign(49, 19, :barricade)          # the root-tunnel east, toward the Rootsun Forge
# glowing caps (the cave's crystals) in corners where they block nobody: each one
# is only kept if every cell that could be walked to before still can be
def walkable_cells(b)
  ts = FTTilesets.load(File.join(GAME_DIR, "Data/Tilesets.rxdata"))[b.map.tileset_id]
  pass = lambda do |x, y|
    next false if x < 0 || y < 0 || x >= b.w || y >= b.h
    r = true
    [2, 1, 0].each { |z| id = b.map.data[x, y, z]; next if id == 0; (r = false; break) if ts.passages[id] & 0x0f == 0x0f; break if ts.priorities[id] == 0 }
    r
  end
  pass
end
def reachable(b, pass, start, blocked)
  seen = { start => true }; q = [start]
  until q.empty?
    x, y = q.shift
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dx, dy|
      c = [x + dx, y + dy]
      next if seen[c] || blocked[c] || !pass.(*c)
      seen[c] = true; q << c
    end
  end
  seen
end
upass = walkable_cells(uc)
evcells = {}
uc.map.events.each_value { |e| (-1..1).each { |dx| (-1..1).each { |dy| evcells[[e.x + dx, e.y + dy]] = true } } }
blocked = {}
base = reachable(uc, upass, [10, 42], blocked)
placed = []
base.keys.sort.each do |x, y|
  next if evcells[[x, y]] || placed.any? { |px, py| (px - x).abs + (py - y).abs < 6 }
  walls = [[1, 0], [-1, 0], [0, 1], [0, -1]].count { |dx, dy| !upass.(x + dx, y + dy) }
  next if walls < 2
  trial = blocked.merge([x, y] => true)
  after = reachable(uc, upass, [10, 42], trial)
  next if after.size != base.size - 1
  blocked = trial; base = after; placed << [x, y]
  break if placed.size >= 18
end
placed.each_with_index do |(x, y), i|
  case i % 3
  when 0 then uc.set(x, y, 2, 792)
  when 1 then uc.set(x, y - 1, 2, 800) if !upass.(x, y - 1); uc.set(x, y, 2, 808)
  else        uc.set(x, y - 1, 2, 801) if !upass.(x, y - 1); uc.set(x, y, 2, 809)
  end
end
puts "undercanopy: #{placed.size} glowing caps"
save(uc, :undercanopy)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT}"
