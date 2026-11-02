# Cave maps on Infinite Fusion's Cave tileset (32): rock floor islands in a
# black void, the void edged with the rocky lip the game's own pits use.
CAVE_TS = 32
CAVE_FLOOR = 529
CAVE_VOID = 642
CAVE_RIM = { nw: 632, n: 634, ne: 636, w: 640, c: 642, e: 644, sw: 656, s: 658, se: 660 }
CAVE_INNER = { se: 619, sw: 616, ne: 595, nw: 592 }   # void corner pieces where floor touches only diagonally
CAVE_BRIDGE_H = [[637, 638, 639], [645, 646, 647]]  # a two-row plank bridge, posts at each end
CAVE_ROCKS = [[474, 475], [476, 477]]               # boulders (2x2, solid)
CAVE_MOUTH = Stamp.from_map(:cave_mouth_dummy, 285, 0, 0, 1, 1) rescue nil

def cave_map(w, h)
  b = Builder.new(w, h, tileset_id: CAVE_TS, template_map: 285)
  b.fill(0, CAVE_VOID)
  b
end

# floor: { [x, y] => true }
def cave_paint(b, floor)
  void = []
  (0...b.w).each { |x| (0...b.h).each { |y| if floor[[x, y]] then b.set(x, y, 0, CAVE_FLOOR) else void << [x, y] end } }
  b.nine_blob(0, CAVE_RIM, void, solid: ->(x, y) { x < 0 || y < 0 || x >= b.w || y >= b.h })
  void.each do |x, y|
    next unless b.get(x, y, 0) == CAVE_VOID
    CAVE_INNER.each do |k, t|
      dx = k.to_s.include?("e") ? 1 : -1
      dy = k.to_s.include?("s") ? 1 : -1
      if floor[[x + dx, y + dy]] then b.set(x, y, 0, t); break end
    end
  end
end

# A horizontal bridge over the void from (x0, y) to (x1, y), two tiles tall (y, y+1).
def cave_bridge_h(b, x0, x1, y)
  (x0..x1).each do |x|
    col = x == x0 ? 0 : (x == x1 ? 2 : 1)
    b.set(x, y, 1, CAVE_BRIDGE_H[0][col]); b.set(x, y + 1, 1, CAVE_BRIDGE_H[1][col])
  end
end
