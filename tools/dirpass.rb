# Directional passability, the way the game checks it: leaving a tile in a
# direction and entering the next tile from the opposite side.
require_relative "rgss_stub"
DIRPASS_TS = load_data("/home/claude/pif-682/Data/Tilesets.rxdata")
DIRBIT = { 2 => 1, 4 => 2, 6 => 4, 8 => 8 }
DSTEP = { 2 => [0, 1], 4 => [-1, 0], 6 => [1, 0], 8 => [0, -1] }
def tile_pass?(m, x, y, d)
  return false if x < 0 || y < 0 || x >= m.width || y >= m.height
  t = DIRPASS_TS[m.tileset_id]
  bit = DIRBIT[d]
  [2, 1, 0].each do |z|
    id = m.data[x, y, z]
    next if id.nil? || id == 0
    pas = t.passages[id]
    return false if pas & bit != 0
    return false if pas & 0x0f == 0x0f
    return true if t.priorities[id] == 0
  end
  true
end
def can_step?(m, x, y, d)
  dx, dy = DSTEP[d]
  tile_pass?(m, x, y, d) && tile_pass?(m, x + dx, y + dy, 10 - d)
end
def reach_dir(m, sx, sy, blocked = [])
  seen = { [sx, sy] => true }; q = [[sx, sy]]
  until q.empty?
    x, y = q.shift
    DSTEP.each do |d, (dx, dy)|
      n = [x + dx, y + dy]
      next if seen[n] || blocked.include?(n) || !can_step?(m, x, y, d)
      seen[n] = true; q << n
    end
  end
  seen
end
if __FILE__ == $0
  m = load_data(ARGV[0]); pts = ARGV[1..].map { |s| s.split(",").map(&:to_i) }
  comps = pts.map { |x, y| reach_dir(m, x, y) }
  (0...m.height).each do |y|
    puts (0...m.width).map { |x| c = comps.each_index.select { |i| comps[i][[x, y]] }; c.empty? ? (tile_pass?(m, x, y, 2) ? "," : "#") : (c.size > 1 ? "*" : c[0].to_s) }.join + " #{y}"
  end
end
