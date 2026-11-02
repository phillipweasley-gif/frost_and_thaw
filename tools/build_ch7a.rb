# Builds Act II, Chapter 7, Road A's new maps (script SC 7A.05-7A.07) and the
# Undercanopy's way down to them:
#   2069 The Tainted Lake: a cave lake, slicked with rot; the scalded lake-wyrm
#        blocks the narrow south shore until it's beaten.
#   2070 Mycolith's Hollow: the door of the Five Domains, then icy platforms
#        over a black lake, bridged, and the Shadow Mycolith.
#   2071 The Root Chapel: Hyphora's light, and the door of iron and glass on
#        the far side (the way down to the Rootsun Forge).
# Run after build_ch6b.rb (it reopens the Undercanopy, 2068).
require_relative "ft_common"
require_relative "cavekit"

ID = { tainted_lake: 2069, mycolith_hollow: 2070, root_chapel: 2071 }
NAMES = { tainted_lake: "The Tainted Lake", mycolith_hollow: "Mycolith's Hollow", root_chapel: "The Root Chapel" }
MUSIC = { tainted_lake: "Seafoam Islands Music", mycolith_hollow: "Lavender Town", root_chapel: "Ecruteak City" }
UNDERCANOPY = 2068
SW_LAKE_DOWN, SW_DOMAINS_OPEN, SW_MYCOLITH, SW_HYPHORA, SW_LAKE_OPEN = 3967, 3968, 3969, 3970, 3971
MURKY = 6                     # the Cave tileset's murky-water autotile (Union Cave's lake)

def save(b, key) = save_map(b, ID[key], MUSIC[key])
def cells(*rects) = rects.flat_map { |x, y, w, h| Builder.rect_cells(x, y, w, h) }

# An event that blocks the way until a switch turns on, then is gone.
def blocker(b, x, y, name, graphic, script, switch, dir: 2, opacity: 255, blend: 0)
  b.event(x, y, name, [
    { graphic: graphic, direction: dir, opacity: opacity, blend_type: blend, step_anime: false, script: script },
    { switch: switch, graphic: "", through: true }
  ])
end

# ---------------------------------------------------------------------------
# 2069: the Tainted Lake. In at the top left (the root-tunnel from the Fane);
# round the west shore and along the south shore; a narrow neck at (21,21)
# where the lake-wyrm waits; the east landing goes on down to the Hollow.
lk = cave_map(36, 28)
lake = cells([8, 5, 23, 12], [12, 17, 15, 3], [28, 4, 4, 6], [19, 20, 5, 2])
floor = cells([2, 2, 8, 4], [2, 6, 5, 16], [2, 20, 17, 5], [19, 22, 5, 1], [24, 18, 9, 8], [30, 10, 4, 8])
f = {}
(floor + lake).each { |c| f[c] = true }
cave_paint(lk, f)
lake.each { |x, y| lk.set(x, y, 0, CAVE_FLOOR) }
lk.autotile(1, MURKY, lake)
[[3, 3], [3, 21], [17, 23], [32, 24], [25, 24]].each { |x, y| lk.set(x, y, 2, 792) }   # glow-caps in the corners
lk.warp(4, 2, UNDERCANOPY, 48, 19, 4, name: "Up to the Undercanopy")
lk.cutscene(4, 4, :tainted_lake)
lk.sign(7, 8, :tainted_lake_sign)
# the neck of the south shore: one tile between the water and the wall, and the lake-wyrm in it
lk.event(21, 22, "Lake-wyrm", [
  { graphic: "Followers/GYARADOS", direction: 8, step_anime: true, script: "FT.lake_monster(@event_id)" },
  { switch: SW_LAKE_DOWN, graphic: "", through: true }
])
[[32, 25], [31, 25]].each { |x, y| lk.warp(x, y, ID[:mycolith_hollow], 4, 21, 6, name: "Down to the Hollow") }
save(lk, :tainted_lake)

# ---------------------------------------------------------------------------
# 2070: Mycolith's Hollow. In at the bottom left; an antechamber with the five
# carvings on its north wall and the sealed door in the middle; beyond, a
# platform, a bridge over the black lake, and the monolith's platform. Past it
# the roots open on to the Root Chapel.
ho = cave_map(32, 26)
hf = {}
cells([2, 20, 8, 4], [10, 17, 11, 7], [14, 11, 2, 6], [11, 6, 7, 5], [23, 4, 7, 8]).each { |c| hf[c] = true }
cave_paint(ho, hf)
cave_bridge_h(ho, 18, 22, 8)                                   # over the black lake to the monolith
[21, 22].each { |y| ho.warp(1, y, ID[:tainted_lake], 31, 24, 8, name: "Up to the lake") }
ho.cutscene(4, 21, :mycolith_hollow)
{ mask: 11, fist: 12, hourglass: 17, paw: 18, shadow: 19 }.each do |k, x|   # cut into the north wall
  ho.event(x, 16, "Carving #{k}", [{ graphic: "", script: "FT.domain_carving(:#{k}, @event_id)" }])
end
[14, 15].each do |x|
  ho.event(x, 16, "Door of the Five Domains", [
    { tile_id: 582, script: "FT.talk(:hollow_door_shut, @event_id)" },
    { switch: SW_DOMAINS_OPEN, graphic: "", through: true }
  ])
end
ho.event(26, 7, "Shadow Mycolith", [
  { graphic: "Followers/PARASECT", direction: 2, blend_type: 2, step_anime: true, script: "FT.shadow_mycolith(@event_id)" },
  { switch: SW_MYCOLITH, graphic: "", through: true }
])
[25, 26, 27].each { |x| ho.event(x, 3, "Roots", [{ graphic: "", trigger: 1, script: "FT.talk(:hollow_roots_shut, @event_id)\npbMoveRoute($game_player, [PBMoveRoute::Backward])" },
                                                  { switch: SW_MYCOLITH, trigger: 1, through: true, commands: [ho.send(:command, 201, [0, ID[:root_chapel], 9, 12, 8, 0])] }]) }
save(ho, :mycolith_hollow)

# ---------------------------------------------------------------------------
# 2071: the Root Chapel, under the Fane. Hyphora speaks through the roots;
# the far (east) side is the door of iron and mirror glass.
rc = cave_map(20, 16)
rf = {}
cells([3, 3, 13, 9], [8, 12, 3, 3], [16, 6, 2, 3]).each { |c| rf[c] = true }
cave_paint(rc, rf)
[[4, 4], [14, 4], [4, 10], [14, 10]].each { |x, y| rc.set(x, y, 2, 792) }
[8, 9, 10].each { |x| rc.warp(x, 14, ID[:mycolith_hollow], 26, 5, 2, name: "Back to the Hollow") }
rc.cutscene(9, 11, :root_chapel)
rc.event(9, 2, "Hyphora's light", [{ graphic: "", script: "FT.talk(:chapel_light, @event_id)" }])
[6, 7, 8].each do |y|
  rc.event(17, y, "Door of iron and glass", [
    { tile_id: 582, trigger: 1, script: "FT.forge_door(:a, @event_id)" },
    { switch: 3981, tile_id: 582, trigger: 1, script: "FT.forge_door(:a, @event_id)", commands: [rc.send(:command, 201, [0, 2072, 4, 14, 6, 1])] }
  ])
end
save(rc, :root_chapel)

# ---------------------------------------------------------------------------
# The Undercanopy (2068): the cave mouth north-east becomes the root-tunnel
# down to the lake; the lake in the cavern itself is just water now.
uc = reopen(UNDERCANOPY)
uc.map.events.delete_if { |_id, e| e.name == "The lake" || e.name.start_with?("Lake tunnel") || e.name == "Sign barricade" }
uc.event(49, 19, "Lake tunnel", [{ trigger: 1, script: "FT.lake_tunnel(@event_id)" },
                                 { switch: SW_LAKE_OPEN, trigger: 1, commands: [uc.send(:command, 201, [0, ID[:tainted_lake], 4, 4, 2, 0])] }])
uc.event(39, 27, "The lake", [{ graphic: "", script: "FT.talk(:undercanopy_water, @event_id)" }])
resave(uc, UNDERCANOPY)

merge_infos(ID.map { |k, v| [v, NAMES[k]] })
puts "built #{ID.size} maps into #{OUT} (and reopened #{UNDERCANOPY})"
