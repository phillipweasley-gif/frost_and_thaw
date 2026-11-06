# Whole-game map checks, run after every build:
#   - every place a door/warp/start sends the player is walkable, and part of a
#     real walkable area (not water, a wall, a boat or a little island)
#   - every door, warp and person can be reached from where the player arrives
#   - nobody stands inside a wall
#   - nothing walkable sits on a map's edge without a warp (you'd walk off the map)
# Exit code 1 if anything is wrong.
require_relative "rgss_stub"
require_relative "dirpass"     # one-way ledges and fences, as the game reads them
TS = load_data("/home/claude/pif-682/Data/Tilesets.rxdata")
def passable?(m, x, y)
  return false if x < 0 || y < 0 || x >= m.width || y >= m.height
  t = TS[m.tileset_id]
  [2, 1, 0].each do |z|
    id = m.data[x, y, z]
    next if id == 0
    return false if t.passages[id] & 0x0f == 0x0f
    return true if t.priorities[id] == 0
  end
  true
end
def area(m, x, y, limit = 400)
  seen = { [x, y] => true }; q = [[x, y]]; n = 0
  until q.empty?
    cx, cy = q.shift; n += 1
    return n if n >= limit
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dx, dy|
      c = [cx + dx, cy + dy]
      next if seen[c] || !passable?(m, *c)
      seen[c] = true; q << c
    end
  end
  n
end
maps = {}
Dir[File.expand_path("../build/maps/Map*.rxdata", __dir__)].each { |f| maps[f[/Map(\d+)/, 1].to_i] = load_data(f) }
problems = []
arrivals = Hash.new { |h, k| h[k] = [] }
maps.each do |id, m|
  m.events.each_value do |e|
    e.pages.each { |pg| pg.list.each { |c| arrivals[c.parameters[1]] << [c.parameters[2], c.parameters[3], "from #{id} #{e.name}"] if c.code == 201 } }
  end
end
# starts, respawn points and teleport destinations from the scripts
extra = [[2001, 33, 21, "new game start"], [2001, 20, 23, "Meat Meat start"], [2003, 10, 7, "first center"],
         [2001, 14, 28, "Targos teleport"], [2012, 10, 22, "Bryn teleport"], [2021, 14, 24, "Lonelywood rest"]]
extra.each { |id, x, y, why| arrivals[id] << [x, y, why] }
# ...and every point the story scripts send you to (constants and transfer calls)
Dir[File.join(__dir__, "../game/Data/Scripts/998_FrostThaw/*.rb")].each do |f|
  File.read(f, encoding: "UTF-8").scan(/(?:([A-Z][A-Z0-9_]+)\s*=\s*\[|transfer\()\s*(2\d\d\d),\s*(\d+),\s*(\d+)/) do |name, id, x, y|
    next if x.to_i >= 1000 || y.to_i >= 1000      # a list of map ids (e.g. ROOT_MAPS = [2196, 2197, ...]), not a place
    arrivals[id.to_i] << [x.to_i, y.to_i, "script #{name || 'transfer'} (#{File.basename(f)})"]
  end
end
# legacy destinations from older versions of the maps (see LEGACY_ARRIVALS in 011_Safety.rb)
arrivals.each do |id, list|
  m = maps[id] or next
  list.uniq.each do |x, y, why|
    if !passable?(m, x, y)
      problems << "#{id} (#{x},#{y}) arrival is not walkable (#{why})"
    elsif area(m, x, y) < 40 && m.width * m.height > 400
      problems << "#{id} (#{x},#{y}) arrival is on a small cut-off area (#{why})"
    end
  end
end
maps.each do |id, m|
  starts = arrivals[id].map { |x, y, _| [x, y] }.uniq.select { |x, y| passable?(m, x, y) }
  next if starts.empty?
  blocking = {}
  m.events.each_value do |e|
    pg = e.pages[0]
    next unless !pg.through && !(pg.graphic.character_name.to_s.empty? && pg.graphic.tile_id == 0)
    # a gate that a story switch opens (a later page on a game switch that's
    # walkable) isn't a wall: what's behind it is reachable once it opens
    opens = e.pages[1..].any? { |p2| p2.condition.switch1_valid && (p2.through || (p2.graphic.character_name.to_s.empty? && p2.graphic.tile_id == 0)) }
    blocking[[e.x, e.y]] = true unless opens
  end
  seen = {}; q = starts.dup; q.each { |c| seen[c] = true }
  until q.empty?
    x, y = q.shift
    [[1, 0], [-1, 0], [0, 1], [0, -1]].each do |dx, dy|
      c = [x + dx, y + dy]
      next if seen[c] || !passable?(m, *c)
      seen[c] = true
      q << c unless blocking[c]
    end
  end
  # the same, but obeying one-way ledges and fences: where you can really walk
  walk = {}; q = starts.dup; q.each { |c| walk[c] = true }
  until q.empty?
    x, y = q.shift
    DSTEP.each do |d, (dx, dy)|
      c = [x + dx, y + dy]
      next if walk[c] || !passable?(m, *c) || !can_step?(m, x, y, d)
      walk[c] = true
      q << c unless blocking[c]
    end
  end
  warp_cells = {}
  m.events.each_value do |e|
    cmds = e.pages.flat_map(&:list)
    warp_cells[[e.x, e.y]] = true if cmds.any? { |c| c.code == 201 }
    g = e.pages[0].graphic.character_name.to_s
    if !g.empty? && !passable?(m, e.x, e.y) && e.pages[0].trigger != 3 && !(e.name =~ /EV00\d/)
      problems << "#{id}: #{e.name} at (#{e.x},#{e.y}) stands inside a wall"
    end
    transfer = cmds.any? { |c| c.code == 201 }
    talk = cmds.any? { |c| c.code == 355 && c.parameters[0] =~ /FT\.|pbTrainerIntro/ }
    next unless transfer || talk
    next if e.pages[0].trigger == 3
    reach_cells = [[0, 0], [1, 0], [-1, 0], [0, 1], [0, -1]]
    reach_cells += [[0, 2], [0, -2], [2, 0], [-2, 0]] if !transfer      # (people can be talked to across a counter; doors must be touched)
    near = reach_cells.any? { |dx, dy| walk[[e.x + dx, e.y + dy]] }
    problems << "#{id}: #{e.name} at (#{e.x},#{e.y}) can't be reached" unless near || e.name =~ /Bolt tunnel|Cutscene/
  end
  # walking on water: a walkable cell over water that isn't a dock or pier plank
  ts = TS[m.tileset_id]
  dock = [1920, 1922, 1925, 1928, 1930, 1933, 1944, 1947, 1949]
  (0...m.width).each do |x|
    (0...m.height).each do |y|
      next unless seen[[x, y]]
      next unless ts.terrain_tags[m.data[x, y, 0]] == 7
      next if [1, 2].any? { |z| dock.include?(m.data[x, y, z]) }
      problems << "#{id}: (#{x},#{y}) can be walked on, but it's water"
    end
  end
  # walking off the edge of an outdoor map
  (0...m.width).each do |x|
    (0...m.height).each do |y|
      next unless x == 0 || y == 0 || x == m.width - 1 || y == m.height - 1
      next unless seen[[x, y]] && !warp_cells[[x, y]]
      next if id == 2000      # (the intro void: setup runs there, then the game moves you on)
      problems << "#{id}: (#{x},#{y}) on the map edge is walkable but leads nowhere"
    end
  end
end
# every trainer's overworld sprite matches its battle picture's class
require_relative "mapkit"
trainer_class = {}
Dir[File.expand_path("../game/Data/Scripts/998_FrostThaw/*.rb", __dir__)].each do |f|
  File.read(f, encoding: "UTF-8").scan(/^\s{4}(\w+):\s+\[:(\w+),\s+"[^"]+",\s+\[\[/) { |k, t| trainer_class[k] = t.to_sym }
end
leaders = { "Naerth" => "FT_speaker_naerth", "Duvessa" => "FT_speaker_duvessa_shane", "Durmoot" => "FT_speaker_edgra_durmoot",
            "Matron Eline" => "FT_matron_eline", "Selrae Vorn" => "FT_winter_matron_selrae_vorn",
            "Hew Talmire" => "FT_master_hew_talmire", "Torrga" => "FT_torrga_icevein", "Kelyn of Spring" => "FT_high_speaker_kelyn_of_spring",
            "Professor Wynsnow" => "FT_professor_wynsnow", "Eirwen Solglass" => "FT_eirwen_solglass", "Darrus Fell" => "FT_darrus_fell",
            "Zenith Abbott" => "FT_wennen_zenith", "Luna Carver" => "FT_wennen_luna", "Eira Shadebloom" => "FT_myconid_eira", "Mira of the North Wind" => "FT_mira_of_the_north_wind", "Sephek in ice" => "FT_sephek_frozen" }
maps.each do |id, m|
  m.events.each_value do |e|
    src = e.pages.flat_map(&:list).select { |c| [355, 655].include?(c.code) }.map { |c| c.parameters[0] }.join("\n")
    if src =~ /FT\.trainer\(:(\w+)/
      want = MapKit::Builder::TRAINER_OW[trainer_class[$1]]
      pg = e.pages.find { |p| p.list.any? { |c| [355, 655].include?(c.code) && c.parameters[0].to_s.include?("FT.trainer(") } }
      got = pg.graphic.character_name
      problems << "#{id}: trainer #{$1} looks like #{got} but battles as #{trainer_class[$1]} (#{want})" if want != got
    end
    if leaders[e.name] && !e.pages.any? { |pg| pg.graphic.character_name == leaders[e.name] }
      problems << "#{id}: #{e.name}'s sprite doesn't match their battle picture"
    end
  end
end
# a trainer who spots you walks up to you and then stays there after the battle:
# if that spot is on a plank bridge, the bridge is blocked for good
BRIDGE_TILES = [637, 638, 639, 645, 646, 647]
maps.each do |id, m|
  m.events.each_value do |e|
    next unless e.name =~ /\ATrainer\((\d+)\)/
    sight = $1.to_i
    pg = e.pages[0] or next
    dx, dy = { 2 => [0, 1], 4 => [-1, 0], 6 => [1, 0], 8 => [0, -1] }[pg.graphic.direction] || [0, 1]
    (1...sight).each do |n|                       # where it stops: one short of where it saw you
      x, y = e.x + dx * n, e.y + dy * n
      break unless passable?(m, x, y)
      if BRIDGE_TILES.include?(m.data[x, y, 1])
        problems << "#{id}: #{e.name} at (#{e.x},#{e.y}) can walk onto the bridge at (#{x},#{y}) and block it after the battle"
        break
      end
    end
  end
end
# every switch an event page waits for must be one the game will actually read:
# Infinite Fusion ignores unnamed switches, so ours must sit in the range
# 019_Switches.rb reads directly (STORY_SWITCHES there)
STORY_RANGE = begin
  src = File.read(File.join(__dir__, "../game/Data/Scripts/998_FrostThaw/019_Switches.rb"), encoding: "UTF-8")
  m_ = src.match(/STORY_SWITCHES\s*=\s*\((\d+)\.\.(\d+)\)/)
  m_ ? (m_[1].to_i..m_[2].to_i) : (3900..3999)
end
maps.each do |id, m|
  m.events.each_value do |e|
    e.pages.each do |pg|
      c = pg.condition
      [[c.switch1_valid, c.switch1_id], [c.switch2_valid, c.switch2_id]].each do |valid, sid|
        next unless valid
        problems << "#{id}: #{e.name} waits for switch #{sid}, which the game would never see as on" unless STORY_RANGE.include?(sid)
      end
    end
  end
end
# slopes: an invisible "stairs" event moves you one step diagonally; nobody may
# stand where a slope sets you down, or you're stuck on the stairs
maps.each do |id, m|
  slopes = m.events.values.select do |e|
    e.pages[0].graphic.character_name.empty? &&
      e.pages[0].list.any? { |c| c.code == 209 && c.parameters[1].respond_to?(:list) && c.parameters[1].list.any? { |mc| [5, 6, 7, 8].include?(mc.code) } }
  end
  slope_cells = slopes.map { |e| [e.x, e.y] }
  landings = slopes.flat_map { |e| [[-1, -1], [1, 1], [-1, 1], [1, -1]].map { |dx, dy| [e.x + dx, e.y + dy] } } - slope_cells
  m.events.each_value do |e|
    next if e.pages.all? { |pg| pg.graphic.character_name.empty? }
    problems << "#{id}: #{e.name} at (#{e.x},#{e.y}) blocks where a slope sets you down" if landings.include?([e.x, e.y])
  end
end
# one connected place: every arrival and every door on a map must be reachable
# from the map's main way in (not just from its own landing spot)
maps.each do |id, m|
  starts = arrivals[id].map { |x, y, _| [x, y] }.uniq.select { |x, y| passable?(m, x, y) }
  next if starts.size < 2
  next if [2080].include?(id)      # ice slides: the builder's own slide solver checks these (build_act3.rb)
  # people who never move stand in the way too
  people = m.events.values.select { |e| e.pages.all? { |pg| !pg.graphic.character_name.empty? && !pg.through && pg.move_type == 0 } }.map { |e| [e.x, e.y] }   # (story guards who later step aside don't count)
  open_cell = ->(x, y) { passable?(m, x, y) && !people.include?([x, y]) }
  comp = {}
  starts.each do |s0|
    next if comp[s0]
    seen = { s0 => true }; q = [s0]
    until q.empty?
      cx, cy = q.shift
      DSTEP.each do |d, (dx, dy)|
        c = [cx + dx, cy + dy]
        next if seen[c] || !open_cell.(*c) || !can_step?(m, cx, cy, d)
        seen[c] = true; q << c
      end
    end
    starts.each { |s1| comp[s1] ||= s0 if seen[s1] }
  end
  groups = starts.group_by { |s1| comp[s1] }
  if groups.size > 1
    sizes = groups.values.map { |g| g.map { |x, y| "(#{x},#{y})" }.join(" ") }
    problems << "#{id}: the map is split - from one way in you can't walk to the others (ledges, fences or people in the way): #{sizes.join('  |  ')}"
  end
end
# two doors on one tile: which one fires is up to event order, so the tile
# means two different places (an old builder's warp left under a new one)
maps.each do |id, m|
  by_cell = Hash.new { |h, k| h[k] = [] }
  m.events.each_value do |e|
    c = e.pages[0].list.find { |x| x.code == 201 } or next
    by_cell[[e.x, e.y]] << [c.parameters[1], e.name]
  end
  by_cell.each do |(x, y), list|
    next if list.map(&:first).uniq.size < 2
    problems << "#{id}: (#{x},#{y}) has #{list.size} doors to different maps: #{list.map { |d, n| "#{n} -> #{d}" }.join(', ')}"
  end
end
# a sign you can't see on open ground can only be read by standing on it
maps.each do |id, m|
  m.events.each_value do |e|
    next unless e.name.start_with?("Sign ")
    g = e.pages[0].graphic
    next if !g.character_name.empty? || g.tile_id > 0
    problems << "#{id}: #{e.name} at (#{e.x},#{e.y}) is invisible and stands on open ground - nobody can read it" if passable?(m, e.x, e.y)
  end
end
# the same goes for anything you press A on: an event with no picture on open
# ground only answers if you stand right on top of it
maps.each do |id, m|
  m.events.each_value do |e|
    next if e.name.start_with?("Sign ")
    e.pages.each_with_index do |pg, i|
      next unless pg.trigger == 0 && pg.list.any? { |c| [355, 655].include?(c.code) }
      g = pg.graphic
      next if !g.character_name.empty?
      if g.tile_id > 0
        t = TS[m.tileset_id]
        if t.passages[g.tile_id].to_i & 0x0f != 0x0f && t.priorities[g.tile_id].to_i == 0 && passable?(m, e.x, e.y)
          problems << "#{id}: #{e.name} at (#{e.x},#{e.y}) (page #{i + 1}) is a walk-over tile - pressing A next to it does nothing"
        end
        next
      end
      problems << "#{id}: #{e.name} at (#{e.x},#{e.y}) (page #{i + 1}) has no picture and stands on open ground - pressing A next to it does nothing" if passable?(m, e.x, e.y)
    end
  end
end
# no bouncing: if you keep holding the direction you walked out in, you must
# not walk straight onto a warp that sends you back (or anywhere)
DIRV = { 2 => [0, 1], 4 => [-1, 0], 6 => [1, 0], 8 => [0, -1] }
def transfer_at(m, x, y)
  m.events.values.find { |e| e.x == x && e.y == y && e.pages.any? { |pg| pg.list.any? { |c| c.code == 201 } } }
end
maps.each do |id, m|
  m.events.each_value do |e|
    cmd = e.pages.flat_map(&:list).find { |c| c.code == 201 } or next
    dest = maps[cmd.parameters[1]] or next
    tx, ty = cmd.parameters[2], cmd.parameters[3]
    # which way was the player walking when they stepped on this warp?
    d = if e.y == m.height - 1 then 2 elsif e.y == 0 then 8 elsif e.x == 0 then 4 elsif e.x == m.width - 1 then 6
        else DIRV.find { |_k, (dx, dy)| passable?(m, e.x - dx, e.y - dy) }&.first end
    next if !d
    dx, dy = DIRV[d]
    if transfer_at(dest, tx, ty)
      problems << "#{id} #{e.name}: you arrive at #{cmd.parameters[1]} (#{tx},#{ty}) right on top of another warp"
      next
    end
    (1..2).each do |k|
      nx, ny = tx + dx * k, ty + dy * k
      break if !passable?(dest, nx, ny)
      if (w = transfer_at(dest, nx, ny))
        problems << "#{id} #{e.name}: keep walking #{{ 2 => 'down', 4 => 'left', 6 => 'right', 8 => 'up' }[d]} after arriving at #{cmd.parameters[1]} (#{tx},#{ty}) and you hit #{w.name} at (#{nx},#{ny}) - you bounce straight back"
        break
      end
    end
  end
end
# counter clerks are talked to across the counter: known and fine
problems.reject! { |p| p =~ /^(2002|2007|2014|2016|2024|2028|2005): (Barkeep|Ma Yarbroul|Clerk|Innkeeper|Danae|Iriskree|Naerth)/ }
puts problems.empty? ? "all map checks passed (#{maps.size} maps)" : problems
exit(problems.empty? ? 0 : 1)
