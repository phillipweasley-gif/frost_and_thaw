# Builds Targos (Act I, Year 0) as map 2001.
require_relative "mapkit"
include MapKit

ID = {
  targos: 2001, tavern: 2002, center: 2003, luskan: 2004, gym: 2005,
  hut_a: 2006, mart: 2007, hut_b: 2008, hut_c: 2009
}

W, H = 50, 42
b = Builder.new(W, H)

SNOW = 444
b.fill(0, SNOW)

# --- lake Maer Dualdon --------------------------------------------------
lake = Builder.rect_cells(0, 31, W, H - 31)
b.autotile(0, 5, lake)

# --- snowy pines around the town ----------------------------------------
TREE = [[4582, 4583], [4590, 4591], [4598, 4599], [4606, 4607]]
def tree(b, x, y)
  TREE.each_with_index { |row, dy| row.each_with_index { |t, dx| b.set(x + dx, y + dy, 2, t) } }
end
(0...W).step(2) { |x| tree(b, x, 0) unless (22..27).include?(x) }      # north edge, gap for the gate
(4..24).step(4) { |y| [0, 2, 46, 48].each { |x| tree(b, x, y) } }      # west and east edges
tree(b, 20, 0); tree(b, 28, 0)

# --- boardwalks (plank streets) and piers --------------------------------
PLANK = { nw: 1920, n: 1922, ne: 1925, w: 1928, c: 1930, e: 1933, sw: 1944, s: 1947, se: 1949 }
streets = []
streets += Builder.rect_cells(23, 0, 4, 30)     # north gate down to the docks
streets += Builder.rect_cells(5, 14, 40, 2)     # upper street
streets += Builder.rect_cells(5, 26, 40, 2)     # lower street
streets += Builder.rect_cells(22, 28, 6, 10)    # main pier
streets += Builder.rect_cells(8, 28, 4, 7)      # fishing pier
streets += Builder.rect_cells(38, 28, 4, 6)     # east pier
b.nine_blob(1, PLANK, streets)

# --- buildings (cut straight from the tileset) ---------------------------
center = Stamp.tileset(:center, 457, 0, 7, 7)
gym    = Stamp.tileset(:gym, 254, 0, 7, 7)
house  = Stamp.tileset(:house, 629, 0, 4, 5)
cabin  = Stamp.tileset(:cabin, 982, 0, 6, 5)
lodge  = Stamp.tileset(:lodge, 695, 3, 5, 5)
hut    = Stamp.tileset(:hut, 675, 2, 5, 5)
round  = Stamp.tileset(:round_hut, 680, 2, 5, 5)

b.stamp(center, 6, 7)    # door (9,13)
b.stamp(hut, 15, 8)      # door (16,11)
b.stamp(gym, 33, 7)      # door (36,13) - Speaker Naerth's hall
b.stamp(round, 41, 8)    # door (42,11)
b.stamp(lodge, 9, 21)    # door (11,25) - the Three Sails
b.stamp(house, 17, 21)   # door (18,25) - market
b.stamp(cabin, 31, 21)   # door (33,25) - the Luskan Arms
b.stamp(hut, 39, 21)     # door (40,24)

# --- harbour and street props --------------------------------------------
boat = Stamp.tileset(:sailboat, 64, 0, 5, 5)
b.stamp(boat, 28, 33)                       # the ship the travelers arrived on
b.stamp(boat, 12, 30)                       # a fishing boat by the west pier
LAMP = Stamp.tileset(:lamp, 82, 4, 1, 2)
[[22, 12], [27, 12], [22, 24], [27, 24], [5, 24], [44, 24], [5, 12], [44, 12]].each { |x, y| b.stamp(LAMP, x, y) }
CRATE = 1048
[[22, 36], [27, 35], [8, 33], [41, 32], [40, 32], [9, 28]].each { |x, y| b.set(x, y, 2, CRATE) }
HAY = Stamp.tileset(:hay, 79, 1, 2, 2)
b.stamp(HAY, 14, 22)
b.stamp(HAY, 29, 18)

# --- doors (interiors come next) -----------------------------------------
b.door(9, 13, ID[:center], 7, 14, 8, name: "Door Pokemon Center")
b.door(16, 11, ID[:hut_a], 4, 7, 8, name: "Door House A")
b.door(36, 13, ID[:gym], 7, 14, 8, name: "Door Speaker's Hall")
b.door(42, 11, ID[:hut_b], 4, 7, 8, name: "Door House B")
b.door(11, 25, ID[:tavern], 7, 12, 8, name: "Door Three Sails")
b.door(18, 25, ID[:mart], 4, 7, 8, name: "Door Market")
b.door(33, 25, ID[:luskan], 7, 12, 8, name: "Door Luskan Arms")
b.door(40, 24, ID[:hut_c], 4, 7, 8, name: "Door House C")

b.save("/home/claude/frost-thaw/build/Map2001.rxdata")
b.to_json_file("/home/claude/frost-thaw/build/Map2001.json")
puts "ok"
