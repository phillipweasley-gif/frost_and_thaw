# MapKit: builds RPG Maker XP maps for Pokémon Infinite Fusion from code.
# Maps are made from the game's own tilesets; pieces of existing maps can be
# copied in as "stamps" (a house, a Pokémon Center, a stretch of forest).
require_relative "rgss_stub"
require "json"

GAME_DIR = ENV["GAME"] || "/home/claude/pif-682"

module MapKit
  # Essentials' neighbour-mask -> autotile shape table (TileDrawingHelper).
  NEIGHBORS_TO_AUTOTILE_INDEX = [
    46, 44, 46, 44, 43, 41, 43, 40, 46, 44, 46, 44, 43, 41, 43, 40,
    42, 32, 42, 32, 35, 19, 35, 18, 42, 32, 42, 32, 34, 17, 34, 16,
    46, 44, 46, 44, 43, 41, 43, 40, 46, 44, 46, 44, 43, 41, 43, 40,
    42, 32, 42, 32, 35, 19, 35, 18, 42, 32, 42, 32, 34, 17, 34, 16,
    45, 39, 45, 39, 33, 31, 33, 29, 45, 39, 45, 39, 33, 31, 33, 29,
    37, 27, 37, 27, 23, 15, 23, 13, 37, 27, 37, 27, 22, 11, 22,  9,
    45, 39, 45, 39, 33, 31, 33, 29, 45, 39, 45, 39, 33, 31, 33, 29,
    36, 26, 36, 26, 21,  7, 21,  5, 36, 26, 36, 26, 20,  3, 20,  1,
    46, 44, 46, 44, 43, 41, 43, 40, 46, 44, 46, 44, 43, 41, 43, 40,
    42, 32, 42, 32, 35, 19, 35, 18, 42, 32, 42, 32, 34, 17, 34, 16,
    46, 44, 46, 44, 43, 41, 43, 40, 46, 44, 46, 44, 43, 41, 43, 40,
    42, 32, 42, 32, 35, 19, 35, 18, 42, 32, 42, 32, 34, 17, 34, 16,
    45, 38, 45, 38, 33, 30, 33, 28, 45, 38, 45, 38, 33, 30, 33, 28,
    37, 25, 37, 25, 23, 14, 23, 12, 37, 25, 37, 25, 22, 10, 22,  8,
    45, 38, 45, 38, 33, 30, 33, 28, 45, 38, 45, 38, 33, 30, 33, 28,
    36, 24, 36, 24, 21,  6, 21,  4, 36, 24, 36, 24, 20,  2, 20,  0
  ]

  def self.load_map(id)
    load_data(File.join(GAME_DIR, format("Data/Map%03d.rxdata", id)))
  end

  def self.deep_copy(o)
    Marshal.load(Marshal.dump(o))
  end

  # A rectangle of tiles copied from an existing map.
  class Stamp
    attr_reader :w, :h, :layers, :name
    def initialize(name, w, h, layers)
      @name, @w, @h, @layers = name, w, h, layers
    end

    # The same stamp with some cells left empty (stray bits of neighbouring
    # objects that the tileset packs into the same rectangle).
    def without(cells)
      layers = @layers.transform_values { |rows| rows.map(&:dup) }
      cells.each { |dx, dy| layers.each_value { |rows| rows[dy][dx] = 0 } }
      Stamp.new(@name, @w, @h, layers)
    end

    # A rectangle cut straight out of the tileset image (row/col in tiles).
    def self.tileset(name, row, col, w, h, layer: 2)
      rows = (0...h).map { |dy| (0...w).map { |dx| 384 + (row + dy) * 8 + col + dx } }
      new(name, w, h, { layer => rows })
    end

    # layers: which layers to copy; skip: tile ids to leave out (e.g. paths).
    def self.from_map(name, map_id, x0, y0, w, h, layers: [1, 2], skip: [])
      m = MapKit.load_map(map_id)
      data = {}
      layers.each do |z|
        data[z] = (0...h).map do |dy|
          (0...w).map do |dx|
            t = m.data[x0 + dx, y0 + dy, z]
            skip.any? { |s| s === t } ? 0 : t
          end
        end
      end
      new(name, w, h, data)
    end
  end

  class Builder
    attr_reader :map, :w, :h

    def initialize(w, h, tileset_id: 23, template_map: 631)
      @w, @h = w, h
      @map = MapKit.deep_copy(MapKit.load_map(template_map))
      @map.width = w
      @map.height = h
      @map.tileset_id = tileset_id
      @map.data = Table.new(w, h, 3)
      @map.events = {}
      @map.encounter_list = []
      @event_template = MapKit.deep_copy(MapKit.load_map(631).events.values.find { |e| e.name == "EV011" })
      @door_template = MapKit.deep_copy(MapKit.load_map(631).events[1])
      @autotile_fills = []
    end

    # Start from an existing interior: same tiles, no events except `keep`.
    # Returns [builder, exits] where exits are the positions of the original
    # doors leading out (to re-point at our own maps).
    def self.from_existing(map_id, keep: [])
      src = MapKit.load_map(map_id)
      b = new(src.width, src.height, tileset_id: src.tileset_id, template_map: map_id)
      b.map.data = MapKit.deep_copy(src.data)
      doors = []
      src.events.each_value do |e|
        if keep.include?(e.id)
          # kept events keep their ids: other events refer to them by number
          # (the nurse moves the healing machine, event 4, for example)
          b.map.events[e.id] = MapKit.deep_copy(e)
          next
        end
        cmd = e.pages[0].list.find { |c| c.code == 201 }
        doors << [e.x, e.y, cmd.parameters[1]] if cmd && e.pages[0].trigger == 1
      end
      # The way outside is the place most of the doors lead; any other door
      # (an escalator, a back room) is closed off.
      outside = doors.map(&:last).tally.max_by { |_, n| n }&.first
      exits = doors.select { |d| d[2] == outside }.map { |x, y, _| [x, y] }
      inner = doors.reject { |d| d[2] == outside }.map { |x, y, _| [x, y] }
      inner.each do |x, y|
        b.event(x, y, "Closed", [{ trigger: 1, script: "FT.talk(:closed_off, @event_id)" }])
      end
      [b, exits]
    end

    def inside?(x, y) = x >= 0 && y >= 0 && x < @w && y < @h

    def set(x, y, z, t)
      @map.data[x, y, z] = t if inside?(x, y)
    end

    def get(x, y, z) = inside?(x, y) ? @map.data[x, y, z] : 0

    def fill(z, t, x0 = 0, y0 = 0, w = @w, h = @h)
      (y0...y0 + h).each { |y| (x0...x0 + w).each { |x| set(x, y, z, t) } }
    end

    # Repeats a 2D pattern of tile ids over a rectangle.
    def pattern(z, rows, x0 = 0, y0 = 0, w = @w, h = @h)
      (y0...y0 + h).each do |y|
        (x0...x0 + w).each { |x| set(x, y, z, rows[y % rows.size][x % rows[0].size]) }
      end
    end

    # Marks cells to be filled with an autotile (index 1..7). Shapes are
    # resolved in finish so neighbouring fills join up.
    def autotile(z, index, cells)
      @autotile_fills << [z, index, cells]
    end

    def autotile_rect(z, index, x0, y0, w, h)
      cells = []
      (y0...y0 + h).each { |y| (x0...x0 + w).each { |x| cells << [x, y] } }
      autotile(z, index, cells)
    end

    # Nine-slice: a rectangle drawn with corner/edge/centre tiles.
    # tiles: {nw:, n:, ne:, w:, c:, e:, sw:, s:, se:}
    def nine(z, tiles, x0, y0, w, h)
      (0...h).each do |dy|
        (0...w).each do |dx|
          row = dy == 0 ? "n" : (dy == h - 1 ? "s" : "")
          col = dx == 0 ? "w" : (dx == w - 1 ? "e" : "")
          key = (row + col).empty? ? :c : (row + col).to_sym
          t = tiles[key] || tiles[:c]
          t = t.call(dx, dy) if t.respond_to?(:call)
          set(x0 + dx, y0 + dy, z, t)
        end
      end
    end

    # Nine-slice over any set of cells (union of rectangles) so joins are seamless.
    # solid: optional lambda (x, y) -> true where an edge should NOT be drawn
    # (e.g. land next to a boardwalk), so edges only face water.
    def nine_blob(z, tiles, cells, solid: nil)
      set_of = {}
      cells.each { |c| set_of[c] = true }
      inside = ->(x, y) { set_of[[x, y]] || (solid && solid.(x, y)) }
      set_of.each_key do |(x, y)|
        n = inside.(x, y - 1); s = inside.(x, y + 1)
        w = inside.(x - 1, y); e = inside.(x + 1, y)
        row = !n ? "n" : (!s ? "s" : "")
        col = !w ? "w" : (!e ? "e" : "")
        key = (row + col).empty? ? :c : (row + col).to_sym
        set(x, y, z, tiles[key] || tiles[:c])
      end
    end

    def self.rect_cells(x0, y0, w, h)
      (y0...y0 + h).flat_map { |y| (x0...x0 + w).map { |x| [x, y] } }
    end

    def stamp(st, x0, y0, to_layers: nil)
      st.layers.each do |z, rows|
        dz = to_layers ? to_layers[z] : z
        rows.each_with_index do |row, dy|
          row.each_with_index { |t, dx| set(x0 + dx, y0 + dy, dz, t) if t != 0 }
        end
      end
    end

    # --- events -----------------------------------------------------------
    def next_event_id = (@map.events.keys.max || 0) + 1

    def command(code, params, indent = 0)
      c = RPG::EventCommand.allocate
      c.instance_variable_set(:@code, code)
      c.instance_variable_set(:@indent, indent)
      c.instance_variable_set(:@parameters, params)
      c
    end

    def script_commands(src, indent = 0)
      lines = src.split("\n")
      [command(355, [lines[0]], indent)] + lines[1..].map { |l| command(655, [l], indent) }
    end

    # pages: array of hashes {graphic:, direction:, trigger:, move_type:, script:,
    #   self_switch:, switch:, through:, step_anime:, direction_fix:, always_on_top:}
    def event(x, y, name, pages)
      e = MapKit.deep_copy(@event_template)
      e.instance_variable_set(:@id, next_event_id)
      e.instance_variable_set(:@name, name)
      e.instance_variable_set(:@x, x)
      e.instance_variable_set(:@y, y)
      base_page = e.pages[0]
      e.instance_variable_set(:@pages, pages.map { |pd| build_page(base_page, pd) })
      @map.events[e.id] = e
      e
    end

    def build_page(base, pd)
      pg = MapKit.deep_copy(base)
      cond = pg.condition
      cond.instance_variable_set(:@switch1_valid, false)
      cond.instance_variable_set(:@switch2_valid, false)
      cond.instance_variable_set(:@variable_valid, false)
      cond.instance_variable_set(:@self_switch_valid, false)
      if pd[:self_switch]
        cond.instance_variable_set(:@self_switch_valid, true)
        cond.instance_variable_set(:@self_switch_ch, pd[:self_switch])
      end
      if pd[:switch]
        cond.instance_variable_set(:@switch1_valid, true)
        cond.instance_variable_set(:@switch1_id, pd[:switch])
      end
      if pd[:switch2]
        cond.instance_variable_set(:@switch2_valid, true)
        cond.instance_variable_set(:@switch2_id, pd[:switch2])
      end
      g = pg.graphic
      g.instance_variable_set(:@character_name, pd[:graphic] || "")
      g.instance_variable_set(:@tile_id, pd[:tile_id] || 0)
      g.instance_variable_set(:@direction, pd[:direction] || 2)
      g.instance_variable_set(:@pattern, 0)
      g.instance_variable_set(:@character_hue, 0)
      g.instance_variable_set(:@opacity, pd[:opacity] || 255)
      g.instance_variable_set(:@blend_type, pd[:blend_type] || 0)
      pg.instance_variable_set(:@trigger, pd[:trigger] || 0)
      pg.instance_variable_set(:@move_type, pd[:move_type] || 0)
      pg.instance_variable_set(:@move_frequency, pd[:move_frequency] || 3)
      pg.instance_variable_set(:@move_speed, pd[:move_speed] || 3)
      pg.instance_variable_set(:@through, pd[:through] || false)
      pg.instance_variable_set(:@step_anime, pd[:step_anime] || false)
      pg.instance_variable_set(:@walk_anime, pd.fetch(:walk_anime, true))
      pg.instance_variable_set(:@direction_fix, pd[:direction_fix] || false)
      pg.instance_variable_set(:@always_on_top, pd[:always_on_top] || false)
      list = []
      list += script_commands(pd[:script]) if pd[:script]
      list += pd[:commands] if pd[:commands]
      list << command(0, [])
      pg.instance_variable_set(:@list, list)
      pg
    end

    # A door: stepping on it fades out and moves the player.
    def door(x, y, to_map, to_x, to_y, dir = 2, name: "Door")
      se = MapKit.deep_copy(@door_template.pages[0].list[0].parameters[0])
      black = Tone.new(-255, -255, -255, 0)
      clear = Tone.new(0, 0, 0, 0)
      cmds = [
        command(250, [se]),
        command(223, [black, 6]),
        command(106, [8]),
        command(201, [0, to_map, to_x, to_y, dir, 1]),
        command(223, [clear, 6])
      ]
      event(x, y, name, [{ trigger: 1, commands: cmds, through: false }])
    end

    # A talking NPC. `hide_switch`: when that game switch is on, the NPC is gone
    # (used to hide a Herald when the player is that Herald).
    def npc(x, y, graphic, key, dir: 2, move: 0, hide_switch: nil, name: nil)
      pages = [{ graphic: graphic, direction: dir, move_type: move, script: "FT.talk(:#{key}, @event_id)" }]
      pages << { switch: hide_switch, graphic: "", through: true } if hide_switch
      event(x, y, name || "NPC #{key}", pages)
    end

    # The overworld sprite that goes with each trainer class's battle picture
    # (the pairings Infinite Fusion's own maps use; Frost & Thaw's classes use
    # the sprite of the class whose battle picture they borrow).
    TRAINER_OW = {
      FISHERMAN: "BW056", SAILOR: "BW_Sailor", BIKER: "BW055", ROUGHNECK: "BW054", HIKER: "BW (72)",
      PICNICKER: "BW (23)", POKEMONRANGER_M: "BW029", POKEMONRANGER_F: "BW030", GENTLEMAN: "BW (55)",
      BUGCATCHER: "BWBugCatcher_male", WORKER: "BW (75)", BEAUTY: "BW (33)", CHANNELER: "BW (40)",
      FT_ZHENTARIM: "BW054", FT_ZHENTARIM_F: "BW040", FT_AURILITE: "BW (40)",
      FT_TRAPPER: "BW (72)", FT_ROOTWARDEN: "BW029", FT_HALO: "BW (40)", FT_WINTER_MATRON: "BWOldWoman",
      FT_SKYSAILOR: "BW (23)", FT_SCHOLAR: "BW (55)", FT_GUILD: "BW (75)", FT_DUERGAR: "BW054", FT_DEVIL: "BW (40)"
    }

    # Trainer classes as the game scripts define them (key => class).
    def self.script_trainer_class(key)
      @script_classes ||= begin
        h = {}
        Dir[File.expand_path("../game/Data/Scripts/998_FrostThaw/*.rb", __dir__)].each do |f|
          File.read(f, encoding: "UTF-8").scan(/^\s{4}(\w+):\s+\[:(\w+),\s+"[^"]+",\s+\[\[/) { |k, t| h[k.to_sym] = t.to_sym }
        end
        h
      end
      @script_classes[key.to_sym]
    end

    # A trainer who spots the player (sight in tiles) and battles once. The
    # sprite always matches the trainer class's battle picture.
    def trainer(x, y, graphic, key, tr_type, dir: 2, sight: 3)
      tr_type = Builder.script_trainer_class(key) || tr_type     # the scripts decide the class
      graphic = TRAINER_OW[tr_type] || raise("No overworld sprite paired with trainer class #{tr_type}")
      battle = "pbTrainerIntro(:#{tr_type})\nKernel.pbNoticePlayer(get_character(0))\npbTrainerEnd\nFT.trainer(:#{key}, @event_id)"
      event(x, y, "Trainer(#{sight})", [
        { graphic: graphic, direction: dir, trigger: 2, script: battle },
        { graphic: graphic, direction: dir, self_switch: "A", script: "FT.talk(:#{key}_after, @event_id)" }
      ])
    end

    # A one-time cutscene that runs when the player arrives (autorun).
    def cutscene(x, y, key)
      event(x, y, "Cutscene #{key}", [
        { trigger: 3, script: "FT.scene(:#{key}, @event_id)" },
        { self_switch: "A" }
      ])
    end

    # A sign or object the player can read.
    def sign(x, y, key, graphic: "")
      event(x, y, "Sign #{key}", [{ graphic: graphic, script: "FT.talk(:#{key}, @event_id)" }])
    end

    # An edge or warp tile without the door sound.
    def warp(x, y, to_map, to_x, to_y, dir = 2, name: "Warp")
      cmds = [command(201, [0, to_map, to_x, to_y, dir, 0])]
      event(x, y, name, [{ trigger: 1, commands: cmds, through: true }])
    end

    # --- finishing --------------------------------------------------------
    def resolve_autotiles
      @autotile_fills.each do |z, index, cells|
        set_of = {}
        cells.each { |c| set_of[c] = true if inside?(*c) }
        same = ->(x, y) { !inside?(x, y) || set_of[[x, y]] }
        set_of.each_key do |(x, y)|
          i = 0
          i |= 0x01 if same.(x, y - 1)
          i |= 0x02 if same.(x + 1, y - 1)
          i |= 0x04 if same.(x + 1, y)
          i |= 0x08 if same.(x + 1, y + 1)
          i |= 0x10 if same.(x, y + 1)
          i |= 0x20 if same.(x - 1, y + 1)
          i |= 0x40 if same.(x - 1, y)
          i |= 0x80 if same.(x - 1, y - 1)
          set(x, y, z, 48 * index + NEIGHBORS_TO_AUTOTILE_INDEX[i])
        end
      end
    end

    def finish
      resolve_autotiles
      @map
    end

    # Background music for the map (a file in Audio/BGM, no extension); nil = keep playing whatever was on.
    def music(name, volume: 100, pitch: 100)
      if name
        @map.autoplay_bgm = true
        @map.bgm.name = name
        @map.bgm.volume = volume
        @map.bgm.pitch = pitch
      else
        @map.autoplay_bgm = false
        @map.bgm.name = ""
      end
    end

    def save(path)
      finish
      post_signs
      save_data(@map, path)
    end

    SIGNPOST_TILE = 9736     # the small wooden sign Infinite Fusion's own maps use

    # A sign standing on open ground needs a signpost: an invisible sign on a
    # walkable tile can only be read by standing on it, which nobody does.
    def post_signs
      ts = load_data(File.join(GAME_DIR, "Data/Tilesets.rxdata"))[@map.tileset_id]
      walk = lambda do |x, y|
        return false if x < 0 || y < 0 || x >= @map.width || y >= @map.height
        [2, 1, 0].each do |z|
          id = @map.data[x, y, z]
          next if id == 0
          return false if ts.passages[id] & 0x0f == 0x0f
          return true if ts.priorities[id] == 0
        end
        true
      end
      taken = @map.events.values.map { |e| [e.x, e.y] }
      @map.events.each_value do |e|
        next unless e.name.start_with?("Sign ")
        pg = e.pages[0]
        next if !pg.graphic.character_name.empty? || pg.graphic.tile_id > 0
        next unless walk.(e.x, e.y)
        if @map.tileset_id == 23
          e.pages.each { |p| p.graphic.instance_variable_set(:@tile_id, SIGNPOST_TILE) if p.graphic.character_name.empty? }
        else
          # indoors there's no signpost: hang it on the nearest wall instead,
          # where you read it by facing the wall
          spot = [[0, -1], [-1, 0], [1, 0], [0, 1]].map { |dx, dy| [e.x + dx, e.y + dy] }
                                                  .find { |x, y| !walk.(x, y) && !taken.include?([x, y]) && x.between?(0, @map.width - 1) && y.between?(0, @map.height - 1) }
          if spot
            taken << spot
            e.x, e.y = spot
          end
        end
      end
    end

    def to_json_file(path)
      ts = load_data(File.join(GAME_DIR, "Data/Tilesets.rxdata"))[@map.tileset_id]
      evs = @map.events.values.map do |e|
        pg = e.pages[0]
        { id: e.id, name: e.name, x: e.x, y: e.y, char: pg.graphic.character_name,
          dir: pg.graphic.direction, tile: pg.graphic.tile_id }
      end
      File.write(path, JSON.generate(w: @w, h: @h, data: @map.data.data,
                                     tileset: ts.tileset_name, autotiles: ts.autotile_names, events: evs))
    end
  end
end

EDGE_ROCK = 1336                                     # the icy rock at the foot of an ice boulder

# Any walkable cell on the map's edge that isn't a warp gets a rock: the player
# must never be able to walk off the edge of a map.
def seal_edges(b)
  warp = {}
  b.map.events.each_value { |e| warp[[e.x, e.y]] = true if e.pages.any? { |pg| pg.list.any? { |c| c.code == 201 } } }
  ts = load_data(File.join(GAME_DIR, "Data/Tilesets.rxdata"))[b.map.tileset_id]
  walk = lambda do |x, y|
    [2, 1, 0].each do |z|
      id = b.map.data[x, y, z]
      next if id == 0
      return false if ts.passages[id] & 0x0f == 0x0f
      return true if ts.priorities[id] == 0
    end
    true
  end
  b.resolve_autotiles
  (0...b.w).each do |x|
    (0...b.h).each do |y|
      next unless x == 0 || y == 0 || x == b.w - 1 || y == b.h - 1
      next if warp[[x, y]] || !walk.(x, y)
      b.set(x, y, 2, EDGE_ROCK)
    end
  end
end


