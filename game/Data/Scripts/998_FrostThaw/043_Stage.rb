#===============================================================================
# Frost & Thaw - staging for cutscenes
#
# A small toolkit the story scenes use to act things out on the map instead of
# only describing them (see the Cutscene Art & Effects List):
#
#   Stage.actor(key, x, y, dir)     put a character on the map for the scene
#   Stage.herald(key, dx, dy, dir)  a Herald: their NPC if one is on the map, the
#                                   player if you are that Herald, or a stand-in
#   Stage.walk(ev, *moves)          walk them (PBMoveRoute codes), and wait
#   Stage.pose(ev, sheet, row, ...) play an action sheet's row (P-, K- files in
#                                   Graphics/Characters; rows: 0 down, 1 left,
#                                   2 right, 3 up), holding the last frame
#   Stage.fx(id, at, ...)           play a map effect (E- files in Graphics/
#                                   Animations: 192x192 cells, 5 a row, 20 fps)
#   Stage.balloon(ev, id)           a reaction balloon (B- files in Graphics/
#                                   Pictures/Balloons), in the background
#   Stage.panel(id) / panel_off     a full-screen story panel (S- files in
#                                   Graphics/Pictures) under the message box
#   Stage.wait(frames)              let the map run
#   Stage.cleanup                   remove everything the scene added
#
# Everything is best-effort: a missing file or a failed call is logged and the
# scene simply plays on without it.
#===============================================================================
module FrostThaw
  module Stage
    ACTOR_ID_BASE = 9000
    BALLOON_DIR = "Graphics/Pictures/Balloons/"
    @actors = {}        # event id => Game_Event (stand-ins we added)
    @posed = {}         # event id or :player => original look
    @fx = []            # running effect and balloon sprites
    @panel = nil
    @overlays = {}      # id => overlay (screen-wide O- art)
    @hid_player = false

    module_function

    def log(msg)
      FrostThaw.log("Stage: #{msg}") rescue nil
    end

    def map?
      $scene.is_a?(Scene_Map) && $game_map
    rescue StandardError
      false
    end

    def viewport
      Spriteset_Map.viewport
    end

    def ticks(fps = 20)
      [(Graphics.frame_rate / fps.to_f).round, 1].max
    rescue StandardError
      2
    end

    # Let the map (and our sprites) run for a number of frames.
    def wait(frames)
      return if !map?
      frames.to_i.times do
        Graphics.update
        Input.update
        pbUpdateSceneMap
      end
    rescue StandardError => e
      log("wait: #{e.message}")
    end

    #---------------------------------------------------------------------------
    # Actors
    #---------------------------------------------------------------------------
    def actor(key, x, y, dir = 2, graphic: nil)
      return nil if !map?
      id = ACTOR_ID_BASE + @actors.size + 1
      id += 1 while $game_map.events[id]
      ev = RPG::Event.new(x, y)
      ev.id = id
      ev.name = "stage_#{key}"
      pg = ev.pages[0]
      pg.graphic.character_name = graphic || default_graphic(key)
      pg.graphic.direction = dir
      pg.through = true
      pg.walk_anime = true
      pg.step_anime = false
      pg.move_speed = 3
      ge = Game_Event.new($game_map.map_id, ev, $game_map)
      $game_map.events[id] = ge
      sprites = $scene.spriteset.instance_variable_get(:@character_sprites)
      sprites.push(Sprite_Character.new(viewport, ge)) if sprites
      @actors[id] = ge
      ge
    rescue StandardError => e
      log("actor #{key}: #{e.message}")
      nil
    end

    # A stand-in's sprite: Alberica keeps Auril's mark once she has it (notes 02 E16).
    def default_graphic(key)
      return "FT_alberica_rune" if key.to_s == "alberica" && (FrostThaw.flag?(:alberica_marked) rescue false)
      "FT_#{key}"
    end

    def remove_actor(ge)
      return if !ge || !@actors.key?(ge.id)
      sprites = $scene.spriteset.instance_variable_get(:@character_sprites) rescue nil
      if sprites
        sprites.select { |s| s.character == ge }.each { |s| s.dispose rescue nil; sprites.delete(s) }
      end
      $game_map.events.delete(ge.id) if $game_map && $game_map.events[ge.id] == ge
      @actors.delete(ge.id)
    rescue StandardError => e
      log("remove_actor: #{e.message}")
    end

    # A named character already on the map (an NPC event), by its event name.
    def find(name)
      return nil if !map?
      $game_map.events.values.find { |e| e.name == name && !e.character_name.to_s.empty? }
    rescue StandardError
      nil
    end

    # A Herald for a scene: the player if you are them (hidden behind a stand-in
    # that can wear their action sheets), their NPC if they're on the map, or a
    # stand-in placed relative to the player.
    def herald(key, dx = 0, dy = -1, dir = 2)
      return nil if !map?
      name = key.to_s.split("_").map(&:capitalize).join(" ")
      if FrostThaw.herald?(key)
        ge = actor(key, $game_player.x, $game_player.y, $game_player.direction)
        $game_player.transparent = true if ge
        @hid_player = true if ge
        return ge
      end
      find(name) || actor(key, $game_player.x + dx, $game_player.y + dy, dir)
    end

    def walk(ev, *moves, wait_for: true)
      return if !ev
      route = moves.flatten
      pbMoveRoute(ev, route)
      return if !wait_for
      guard = 0
      while ev.move_route_forcing && guard < 600
        wait(1)
        guard += 1
      end
    rescue StandardError => e
      log("walk: #{e.message}")
    end

    def face(ev, dir)
      ev.instance_variable_set(:@direction, dir) if ev
    end

    #---------------------------------------------------------------------------
    # Action sheets
    #---------------------------------------------------------------------------
    ROW_DIR = [2, 4, 6, 8]

    def pose(ev, sheet, row = 0, frames: [0, 1, 2, 3], per: 6, hold: true)
      return if !ev
      return log("no sheet #{sheet}") if !pbResolveBitmap("Graphics/Characters/#{sheet}")
      key = ev.equal?($game_player) ? :player : ev.id
      @posed[key] ||= { ev: ev, name: ev.character_name, dir: ev.direction, pattern: ev.pattern,
                        lock: ev.lock_pattern, fix: ev.direction_fix }
      ev.character_name = sheet
      ev.direction_fix = false
      ev.instance_variable_set(:@direction, ROW_DIR[row] || 2)
      ev.direction_fix = true
      ev.lock_pattern = true
      frames.each do |f|
        ev.instance_variable_set(:@pattern, f)
        ev.instance_variable_set(:@original_pattern, f)
        wait(per)
      end
      unpose(ev) if !hold
    rescue StandardError => e
      log("pose #{sheet}: #{e.message}")
    end

    def unpose(ev)
      key = ev.equal?($game_player) ? :player : ev.id
      o = @posed.delete(key)
      return if !o
      ev.character_name = o[:name]
      ev.direction_fix = false
      ev.instance_variable_set(:@direction, o[:dir])
      ev.direction_fix = o[:fix]
      ev.instance_variable_set(:@pattern, o[:pattern])
      ev.instance_variable_set(:@original_pattern, o[:pattern])
      ev.lock_pattern = o[:lock]
    rescue StandardError => e
      log("unpose: #{e.message}")
    end

    def hide(ev)
      ev.transparent = true if ev
    end

    #---------------------------------------------------------------------------
    # Map effects and balloons (updated every frame through the spriteset)
    #---------------------------------------------------------------------------
    # at: a character (Game_Character) or [map x, map y]. oy lifts the effect off
    # the feet (e.g. 40 for a chest). frames: how many cells to play.
    def fx(id, at, frames: nil, oy: 0, ox: 0, fps: 20, hold: false, wait: true, loop_from: nil)
      return if !map?
      bmp = RPG::Cache.load_bitmap("Graphics/Animations/", id) rescue nil
      return log("no effect #{id}") if !bmp
      cols = [bmp.width / 192, 1].max
      total = frames || cols * [bmp.height / 192, 1].max
      sp = Sprite.new(viewport)
      sp.bitmap = bmp
      sp.src_rect.set(0, 0, 192, 192)
      sp.ox = 96
      sp.oy = 96
      sp.z = 1500
      f = { sprite: sp, at: at, ox: ox, oy: oy, cols: cols, total: total, per: ticks(fps), tick: 0,
            hold: hold, loop_from: loop_from, kind: :fx }
      place(f)
      @fx << f
      return f if !wait || loop_from
      wait(total * f[:per] + 1)
      f
    rescue StandardError => e
      log("fx #{id}: #{e.message}")
      nil
    end

    def balloon(ev, id, frames: 50)
      return if !map? || !ev
      bmp = RPG::Cache.load_bitmap(BALLOON_DIR, id) rescue nil
      return log("no balloon #{id}") if !bmp
      sp = Sprite.new(viewport)
      sp.bitmap = bmp
      sp.src_rect.set(0, 0, 32, 32)
      sp.ox = 16
      sp.oy = 32
      sp.z = 1600
      f = { sprite: sp, at: ev, ox: 0, oy: 62, tick: 0, life: frames, kind: :balloon }
      place(f)
      @fx << f
      f
    rescue StandardError => e
      log("balloon #{id}: #{e.message}")
      nil
    end

    def place(f)
      sp = f[:sprite]
      at = f[:at]
      if at.is_a?(Array)
        x = ((at[0] * Game_Map::REAL_RES_X - $game_map.display_x) / Game_Map::X_SUBPIXELS).round + 16
        y = ((at[1] * Game_Map::REAL_RES_Y - $game_map.display_y) / Game_Map::Y_SUBPIXELS).round + 32
      else
        x = at.screen_x
        y = at.screen_y
      end
      sp.x = x + f[:ox]
      sp.y = y - f[:oy]
    end

    def update
      update_summoned if !@summoned.empty? || !@leaving.empty? || (@actors && !@actors.empty?) || (@moved && !@moved.empty?)
      update_overlays if @overlays && !@overlays.empty?
      return if @fx.empty? && !@panel
      @fx.dup.each do |f|
        sp = f[:sprite]
        if sp.disposed?
          @fx.delete(f)
          next
        end
        place(f) rescue nil
        f[:tick] += 1
        if f[:kind] == :balloon
          t = f[:tick]
          cell = t < 4 ? 0 : t < 8 ? 1 : (2 + (t / 10) % 2)
          sp.src_rect.set(cell * 32, 0, 32, 32)
          if t >= f[:life]
            sp.dispose
            @fx.delete(f)
          end
          next
        end
        n = f[:tick] / f[:per]
        if n >= f[:total]
          if f[:loop_from]
            n = f[:loop_from] + (n - f[:total]) % [f[:total] - f[:loop_from], 1].max
          elsif f[:hold]
            n = f[:total] - 1
          else
            sp.dispose
            @fx.delete(f)
            next
          end
        end
        sp.src_rect.set((n % f[:cols]) * 192, (n / f[:cols]) * 192, 192, 192)
      end
    rescue StandardError => e
      log("update: #{e.message}")
      @fx.clear
    end

    def stop_fx(f)
      return if !f
      f[:sprite].dispose rescue nil
      @fx.delete(f)
    end

    #---------------------------------------------------------------------------
    # Full-screen story panels (S- files)
    #---------------------------------------------------------------------------
    def panel(id, fade: 16)
      bmp = RPG::Cache.load_bitmap("Graphics/Pictures/", id) rescue nil
      return log("no panel #{id}") if !bmp
      panel_off(fade: 0) if @panel
      vp = Viewport.new(0, 0, Graphics.width, Graphics.height)
      vp.z = 99_000
      sp = Sprite.new(vp)
      sp.bitmap = bmp
      sp.opacity = 0
      @panel = [vp, sp]
      fade.times { |i| sp.opacity = 255 * (i + 1) / fade; wait(1) }
      sp.opacity = 255
    rescue StandardError => e
      log("panel #{id}: #{e.message}")
    end

    def panel_off(fade: 16)
      return if !@panel
      vp, sp = @panel
      fade.times { |i| sp.opacity = 255 - 255 * (i + 1) / fade; wait(1) } if fade > 0
      sp.dispose rescue nil
      vp.dispose rescue nil
      @panel = nil
    rescue StandardError => e
      log("panel_off: #{e.message}")
      @panel = nil
    end

    #---------------------------------------------------------------------------
    # Screen overlays (O- files in Graphics/Pictures/Overlays): over the map and
    # its effects, under story panels and the message box.
    #   scroll_x / scroll_y: pixels per frame for tileable art (it wraps).
    #   frames: a horizontal strip of 512-wide frames played at fps; hold: stay on
    #   the last frame. pulse: a slow breath in opacity (the aurora).
    #---------------------------------------------------------------------------
    OVERLAY_DIR = "Graphics/Pictures/Overlays/"

    def overlay(id, scroll_x: 0, scroll_y: 0, opacity: 255, frames: nil, fps: 6, hold: true,
                fade: 16, pulse: false, wait: false, above_panels: false, ambient: false, stop_at: nil)
      return if !map?
      bmp = RPG::Cache.load_bitmap(OVERLAY_DIR, id) rescue nil
      return log("no overlay #{id}") if !bmp
      @overlays ||= {}
      overlay_off(id, fade: 0) if @overlays[id]
      vp = Viewport.new(0, 0, Graphics.width, Graphics.height)
      vp.z = above_panels ? 99_500 : 98_000
      count = frames || [bmp.width / 512, 1].max
      if scroll_x != 0 || scroll_y != 0
        sp = Plane.new(vp)
        sp.bitmap = bmp
      else
        sp = Sprite.new(vp)
        sp.bitmap = bmp
        sp.src_rect.set(0, 0, [bmp.width / count, 1].max, bmp.height)
        sp.zoom_x = Graphics.width / sp.src_rect.width.to_f
        sp.zoom_y = Graphics.height / bmp.height.to_f
      end
      sp.opacity = 0
      o = { vp: vp, sp: sp, sx: scroll_x, sy: scroll_y, fx: 0.0, fy: 0.0, count: count,
            per: ticks(fps), tick: 0, hold: hold, opacity: opacity, pulse: pulse, w: bmp.width / count,
            ambient: ambient, stop: stop_at }
      @overlays[id] = o
      if fade > 0
        fade.times { |i| sp.opacity = opacity * (i + 1) / fade; wait(1) }
      end
      sp.opacity = opacity
      wait(((stop_at || count - 1) + 1) * o[:per]) if wait && count > 1
      o
    rescue StandardError => e
      log("overlay #{id}: #{e.message}")
      nil
    end

    def overlay?(id)
      !!(@overlays && @overlays[id])
    end

    # With no id: every overlay the scenes put up (ambient ones stay, unless all:).
    def overlay_off(id = nil, fade: 16, all: false)
      @overlays ||= {}
      ids = id ? [id] : @overlays.keys.select { |k| all || !@overlays[k][:ambient] }
      ids.each do |k|
        o = @overlays.delete(k)
        next if !o
        if fade > 0 && map?
          start = o[:sp].opacity
          fade.times { |i| o[:sp].opacity = start - start * (i + 1) / fade; wait(1) }
        end
        o[:sp].dispose rescue nil
        o[:vp].dispose rescue nil
      end
    rescue StandardError => e
      log("overlay_off: #{e.message}")
    end

    def update_overlays
      @overlays.each_value do |o|
        sp = o[:sp]
        next if sp.disposed?
        o[:tick] += 1
        if o[:sx] != 0 || o[:sy] != 0
          o[:fx] += o[:sx]
          o[:fy] += o[:sy]
          sp.ox = o[:fx].round
          sp.oy = o[:fy].round
        elsif o[:count] > 1
          n = o[:tick] / o[:per]
          last = o[:stop] ? [o[:stop], o[:count] - 1].min : o[:count] - 1
          n = o[:hold] ? [n, last].min : n % (last + 1)
          sp.src_rect.set(n * o[:w], 0, o[:w], sp.bitmap.height)
        end
        if o[:pulse] == :hard          # a hard, even beat: like something built
          sp.opacity = (o[:tick] % 40) < 6 ? o[:opacity] : (o[:opacity] * 0.4).round
        elsif o[:pulse]
          sp.opacity = (o[:opacity] * (0.75 + 0.25 * Math.sin(o[:tick] / 18.0))).round
        end
      end
    rescue StandardError => e
      log("update_overlays: #{e.message}")
    end

    #---------------------------------------------------------------------------
    # Visions: step to another map for the length of a block, then come home to
    # the same tile. Panels and overlays stay up across the jump, so a scene can
    # cover the cut with a panel. The player is hidden while away.
    #   Stage.visit(2026, 14, 13, 8) { ...stage the vision... }
    #---------------------------------------------------------------------------
    def visit(map_id, x, y, dir = 2)
      return yield if !map? || !$scene.respond_to?(:transfer_player)
      home = [$game_map.map_id, $game_player.x, $game_player.y, $game_player.direction]
      jump(map_id, x, y, dir)
      $game_player.transparent = true rescue nil
      begin
        yield
      ensure
        jump(*home)
        $game_player.transparent = false rescue nil
      end
    end

    def jump(map_id, x, y, dir = 2)
      @fx.each { |f| f[:sprite].dispose rescue nil }
      @fx.clear
      @posed.delete_if { |k, _| k != :player }
      @actors.clear
      $game_temp.player_new_map_id    = map_id
      $game_temp.player_new_x         = x
      $game_temp.player_new_y         = y
      $game_temp.player_new_direction = dir
      $game_temp.player_transferring  = true
      @jumping = true
      $scene.transfer_player
    rescue StandardError => e
      log("jump #{map_id}: #{e.message}")
    ensure
      @jumping = false
    end

    #---------------------------------------------------------------------------
    def cleanup
      @fx.each { |f| f[:sprite].dispose rescue nil }
      @fx.clear
      @posed.values.each { |o| unpose(o[:ev]) rescue nil }
      @posed.clear
      @actors.values.dup.each { |ge| remove_actor(ge) }
      @actors.clear
      @summoned.clear
      @leaving.clear
      if @hid_player
        $game_player.transparent = false rescue nil
        @hid_player = false
      end
      panel_off(fade: 0)
      overlay_off(nil, fade: 0)
    rescue StandardError => e
      log("cleanup: #{e.message}")
    end

    # A transfer drops the map's events and sprites: forget ours without touching them.
    def forget
      @fx.each { |f| f[:sprite].dispose rescue nil }
      @fx.clear
      @posed.clear
      @actors.clear
      @summoned.clear
      @leaving.clear
      @moved&.clear
      if @hid_player
        $game_player.transparent = false rescue nil
        @hid_player = false
      end
      return if @jumping          # Stage.visit keeps its panel and frame across the cut
      panel_off(fade: 0)
      overlay_off(nil, fade: 0)
    rescue StandardError
      nil
    end
  end
end

if defined?(Scene_Map)
  class Scene_Map
    alias ft_stage_updateSpritesets updateSpritesets unless method_defined?(:ft_stage_updateSpritesets)
    def updateSpritesets(*args)
      ft_stage_updateSpritesets(*args)
      FrostThaw::Stage.update
    end
  end
end

if defined?(Events) && Events.respond_to?(:onMapChange)
  Events.onMapChange += proc { |_sender, _e| FrostThaw::Stage.forget }
end

#===============================================================================
# The Pokémon storytelling toolkit (WRITING_GUIDE §9a). The things every
# Pokémon game does on the map, so nobody talks from off screen:
#
#   Stage.emote(ev, :exclaim)       "!" / "?" / angry bubble over a character
#   Stage.cry(species)              a Pokémon's cry
#   Stage.theme(:tamsin)            a character's theme; Stage.theme(nil) = map BGM
#   Stage.jingle(:pokemon)          Pokémon get / item get / healing / badge
#   Stage.hop(ev)                   a little jump on the spot (surprise, joy)
#   Stage.turn_to(ev, other)        face someone (the player by default)
#   Stage.walk_to(ev, x, y)         walk there by the shortest clear path
#   Stage.approach(ev)              walk up to the player and face them
#   Stage.leave(ev, x, y)           walk off (to a door or the screen edge) and go
#   Stage.escort(leader, x, y)      "Follow me!": the leader walks, you follow
#   Stage.pan_to(x, y) / pan_back   slide the camera to show something, and back
#   Stage.on_screen?(ev)            is that character inside the camera?
#===============================================================================
module FrostThaw
  module Stage
    module_function

    EMOTES = { exclaim: :EXCLAMATION_ANIMATION_ID, question: :QUESTION_MARK_ANIMATION_ID,
               angry: :ANGRY_ANIMATION_ID }
    # Characters' themes (Audio/BGM). The rival's music starts when Tamsin
    # shows up to battle; the professor has his own.
    THEMES = { tamsin: "Pokémon_The_Origins_-_Rival_Encounter_Music_mp3", wynsnow: "oak_theme",
               college: "oak_lab", heralds: "tintower" }
    JINGLES = { pokemon: "Pkmn get", item: "Item get", key_item: "Key item get", heal: "Pokemon Healing",
                badge: "Badge get" }
    MOVE = { 2 => 1, 4 => 2, 6 => 3, 8 => 4 }          # direction -> PBMoveRoute code
    TURN = { 2 => 16, 4 => 17, 6 => 18, 8 => 19 }
    STEP = { 2 => [0, 1], 4 => [-1, 0], 6 => [1, 0], 8 => [0, -1] }

    def emote(ev, kind = :exclaim)
      return if !map? || !ev
      const = EMOTES[kind] || kind
      id = const.is_a?(Symbol) ? Settings.const_get(const) : const.to_i
      sprite = $scene.spriteset.addUserAnimation(id, ev.x, ev.y, false, 2) rescue nil
      guard = 0
      while sprite && !sprite.disposed? && guard < 90
        wait(1)
        guard += 1
      end
    rescue StandardError => e
      log("emote: #{e.message}")
    end

    def cry(species)
      pbPlayCrySpecies(species)
    rescue StandardError => e
      log("cry #{species}: #{e.message}")
    end

    def theme(key)
      return $game_map.autoplay if key.nil?
      pbBGMPlay(THEMES[key] || key.to_s)
    rescue StandardError => e
      log("theme #{key}: #{e.message}")
    end

    def jingle(key)
      pbMEPlay(JINGLES[key] || key.to_s)
    rescue StandardError => e
      log("jingle #{key}: #{e.message}")
    end

    def hop(ev, times = 1)
      return if !ev
      walk(ev, [14, 0, 0] * times)
    end

    def turn_to(ev, other = $game_player)
      return if !ev || !other
      pbTurnTowardEvent(ev, other)
    rescue StandardError => e
      log("turn_to: #{e.message}")
    end

    # Can ev step from (x,y) in direction d, ignoring its own through flag
    # (stand-ins are through, but should still walk round people and walls)?
    def step_ok?(ev, x, y, d, goal)
      nx, ny = x + STEP[d][0], y + STEP[d][1]
      return false unless $game_map.valid?(nx, ny)
      return false unless $game_map.passable?(x, y, d, ev) && $game_map.passable?(nx, ny, 10 - d, ev)
      return true if [nx, ny] == goal                    # the goal may be a door or a step-on event
      return false if !ev.equal?($game_player) && $game_player.x == nx && $game_player.y == ny
      $game_map.events.each_value do |o|
        next if o.equal?(ev) || o.through || o.x != nx || o.y != ny
        next if ev.equal?($game_player) && o.character_name.to_s.empty?
        return false
      end
      true
    end

    # Shortest clear path (direction list) from where ev stands to (tx, ty).
    # adjacent: stop beside the target instead of on it.
    def path_for(ev, tx, ty, adjacent: false)
      start = [ev.x, ev.y]
      done = adjacent ? ->(p) { (p[0] - tx).abs + (p[1] - ty).abs == 1 } : ->(p) { p == [tx, ty] }
      return [] if done.(start)
      prev = { start => nil }
      queue = [start]
      until queue.empty?
        cur = queue.shift
        [2, 4, 6, 8].each do |d|
          nxt = [cur[0] + STEP[d][0], cur[1] + STEP[d][1]]
          next if prev.key?(nxt)
          next unless step_ok?(ev, cur[0], cur[1], d, adjacent ? nil : [tx, ty])
          prev[nxt] = [cur, d]
          if done.(nxt)
            dirs = []
            p = nxt
            while prev[p]
              dirs.unshift(prev[p][1])
              p = prev[p][0]
            end
            return dirs
          end
          queue << nxt
        end
      end
      nil
    end

    def walk_to(ev, x, y, face: nil, adjacent: false, wait_for: true)
      return false if !ev
      dirs = path_for(ev, x, y, adjacent: adjacent)
      if !dirs
        log("walk_to: no path for #{ev.respond_to?(:name) ? ev.name : 'player'} to (#{x},#{y})")
        return false
      end
      route = dirs.map { |d| MOVE[d] }
      route << TURN[face] if face
      walk(ev, route, wait_for: wait_for) if !route.empty?
      true
    end

    # Walk up to the player (or another character) and face them.
    def approach(ev, target = $game_player)
      return if !ev || !target
      # A map character who walks up to you goes back to its place once you have
      # control again (send_moved_home), as a reload would put it: left beside
      # you, solid, it could close the only way out (Selrae in the Hall's aisle).
      # Scenes that walk someone to a set place (walk_to) leave them there.
      if ev.is_a?(Game_Event) && !@actors.key?(ev.id) && target.equal?($game_player)
        (@moved ||= {})[ev.id] ||= [ev, ev.x, ev.y, ev.direction]
      end
      walk_to(ev, target.x, target.y, adjacent: true)
      turn_to(ev, target)
      turn_to(target, ev) if target.equal?($game_player)
    end

    # Walk off to (x, y), then vanish (a stand-in is removed, a map event erased
    # for this visit; its page decides whether it's back next time).
    def leave(ev, x, y)
      return if !ev
      dirs = path_for(ev, x, y)
      moves = dirs ? dirs.map { |d| MOVE[d] } : path_straight(ev, x, y)
      walk(ev, [37] + moves + [38])                  # through at the end: the goal may be a door
      if @actors.key?(ev.id)
        remove_actor(ev)
      else
        ev.erase rescue (ev.transparent = true)
      end
    end

    # Several people walk off to (x, y) at once, then vanish, like leave() for
    # each of them (the five leaving a tavern together, strangers passing by).
    def leave_all(evs, x, y)
      evs = Array(evs).compact
      return if evs.empty?
      evs.each do |ev|
        dirs = path_for(ev, x, y)
        moves = dirs ? dirs.map { |d| MOVE[d] } : path_straight(ev, x, y)
        walk(ev, [37] + moves + [38], wait_for: false)
      end
      guard = 0
      while evs.any?(&:move_route_forcing) && guard < 900
        wait(1)
        guard += 1
      end
      evs.each do |ev|
        if @actors.key?(ev.id)
          remove_actor(ev)
        else
          ev.erase rescue (ev.transparent = true)
        end
      end
    rescue StandardError => e
      log("leave_all: #{e.message}")
    end

    # A fallback for leave(): straight lines, through anything.
    def path_straight(ev, x, y)
      dx, dy = x - ev.x, y - ev.y
      ([dx > 0 ? 3 : 2] * dx.abs) + ([dy > 0 ? 1 : 4] * dy.abs)
    end

    # "Follow me!" The leader walks to (x, y); the player walks one step behind.
    def escort(leader, x, y, facing: nil)
      return false if !leader
      dirs = path_for(leader, x, y)
      return false if !dirs || dirs.empty?
      lead = dirs.map { |d| MOVE[d] }
      beside = lambda do
        STEP.find { |_d, (sx, sy)| [$game_player.x + sx, $game_player.y + sy] == [leader.x, leader.y] }&.first
      end
      walk_to($game_player, leader.x, leader.y, adjacent: true) if !beside.call
      first = beside.call
      # the player steps onto the tile the leader just left, one step behind
      follow = (first ? [MOVE[first]] : []) + lead[0...-1]
      pbMoveRoute($game_player, [37] + follow + [38])
      walk(leader, lead)
      guard = 0
      while $game_player.move_route_forcing && guard < 600
        wait(1)
        guard += 1
      end
      face(leader, facing) if facing
      turn_to($game_player, leader)
      true
    rescue StandardError => e
      log("escort: #{e.message}")
      false
    end

    # The camera: centre the screen on (x, y), clamped to the map, over frames.
    def display_for(x, y)
      cx = (Graphics.width / 2 - Game_Map::TILE_WIDTH / 2) * Game_Map::X_SUBPIXELS
      cy = (Graphics.height / 2 - Game_Map::TILE_HEIGHT / 2) * Game_Map::Y_SUBPIXELS
      max_x = [($game_map.width - Graphics.width * 1.0 / Game_Map::TILE_WIDTH) * Game_Map::REAL_RES_X, 0].max
      max_y = [($game_map.height - Graphics.height * 1.0 / Game_Map::TILE_HEIGHT) * Game_Map::REAL_RES_Y, 0].max
      [[[x * Game_Map::REAL_RES_X - cx, 0].max, max_x].min, [[y * Game_Map::REAL_RES_Y - cy, 0].max, max_y].min]
    end

    def pan_to(x, y, frames: 30)
      return if !map?
      sx, sy = $game_map.display_x, $game_map.display_y
      tx, ty = display_for(x, y)
      frames.times do |i|
        t = (i + 1).to_f / frames
        t = t * t * (3 - 2 * t)                          # ease in and out
        $game_map.display_x = (sx + (tx - sx) * t).round
        $game_map.display_y = (sy + (ty - sy) * t).round
        wait(1)
      end
      @panned = true
    rescue StandardError => e
      log("pan_to: #{e.message}")
    end

    def pan_back(frames: 30)
      return if !@panned
      pan_to($game_player.x, $game_player.y, frames: frames)
      $game_player.center($game_player.x, $game_player.y) rescue nil
      @panned = false
    end

    def panned?
      @panned ? true : false
    end

    def on_screen?(ev)
      return false if !ev
      sx = ev.screen_x
      sy = ev.screen_y
      sx >= 0 && sx <= Graphics.width && sy >= 16 && sy <= Graphics.height + 16
    rescue StandardError
      true
    end

    # Things that share a name with a character but never talk: Shimmer's
    # statue, Hellen's carving, a sign about Naerth (review: "the statue says
    # ...Shimmer.").
    NOT_SPEAKERS = /statue|carving|mural|\bsign\b|portrait|painting|grave|tablet|plaque|effigy|banner|poster/i

    #---------------------------------------------------------------------------
    # Companions on screen (fix plan step 1, WRITING_GUIDE §9a). When a
    # companion travelling with you speaks and isn't on the map, they walk in
    # beside you for the line, and stay for the rest of the scene. When you get
    # control back, they step back out. (Followers aren't drawn in this game, so
    # this is how the party is seen.)
    #---------------------------------------------------------------------------
    @summoned = {}      # companion key => [Game_Event, the tile they came from]
    @leaving = []       # [Game_Event, frames left]

    def summoned?(ev)
      @summoned.values.any? { |g, _| g.equal?(ev) }
    end

    # A free standing tile near the player, beside them first, then behind:
    # [x, y, from_x, from_y], where from is one tile further out (where they
    # walk in from) when that tile is free too.
    def free_slot(reserved = [])
      px, py, d = $game_player.x, $game_player.y, $game_player.direction
      fx, fy = STEP[d]
      side = [[-fy, fx], [fy, -fx]]                 # left and right of the facing
      back = [-fx, -fy]
      offs = side + [back, [back[0] + side[0][0], back[1] + side[0][1]], [back[0] + side[1][0], back[1] + side[1][1]],
                     [side[0][0] * 2, side[0][1] * 2], [side[1][0] * 2, side[1][1] * 2]]
      taken = @summoned.values.map { |g, _| [g.x, g.y] } + reserved
      free = lambda do |x, y|
        next false if !$game_map.valid?(x, y) || [x, y] == [px, py] || taken.include?([x, y])
        next false if !($game_map.passable?(x, y, 0) rescue false)
        $game_map.events.values.none? { |e| e.x == x && e.y == y && !e.through && !e.character_name.to_s.empty? }
      end
      offs.each do |ox, oy|
        x, y = px + ox, py + oy
        next if !free.(x, y)
        sx = ox == 0 ? 0 : (ox > 0 ? 1 : -1)
        sy = oy == 0 ? 0 : (oy > 0 ? 1 : -1)
        from = free.(x + sx, y + sy) ? [x + sx, y + sy] : [x, y]
        return [x, y, *from]
      end
      nil
    end

    # Bring a travelling companion on screen for their line.
    def summon(key)
      return nil if !map? || FrostThaw.herald?(key)
      g = @summoned[key]
      return g[0] if g && $game_map.events[g[0].id].equal?(g[0])
      slot = free_slot || near_slot or return nil    # (a crowded bridge: a step or two further off)
      x, y, fx, fy = slot
      ge = actor(key, fx, fy, $game_player.direction)
      return nil if !ge
      @summoned[key] = [ge, [fx, fy]]
      walk_to(ge, x, y, face: $game_player.direction) if [fx, fy] != [x, y]
      ge.through = true             # a stand-in never blocks you, even after a walk
      ge
    rescue StandardError => e
      log("summon #{key}: #{e.message}")
      nil
    end

    # Several travelling companions walk in together through a door (x, y) at
    # the start of a scene, so they're seen arriving instead of popping up one by
    # one mid-scene (context/01.md B6). They then behave like summoned ones: say()
    # finds them, and they step out when you get control back.
    def arrive(keys, x, y)
      return if !map?
      reserved = []
      walkers = []
      Array(keys).each do |key|
        next if FrostThaw.herald?(key) || !FrostThaw.companions.include?(key)
        next if @summoned[key] && $game_map.events[@summoned[key][0].id].equal?(@summoned[key][0])
        slot = free_slot(reserved) || near_slot(reserved) or next
        reserved << [slot[0], slot[1]]
        ge = actor(key, x, y, 8) or next
        @summoned[key] = [ge, [x, y]]
        dirs = path_for(ge, slot[0], slot[1])
        if dirs && !dirs.empty?
          # A long way round (a hall full of tables): they were a few steps
          # behind you, and catch up over the last stretch.
          if dirs.length > ARRIVE_STEPS
            sx, sy = x, y
            dirs[0...(dirs.length - ARRIVE_STEPS)].each { |dd| sx += STEP[dd][0]; sy += STEP[dd][1] }
            ge.moveto(sx, sy)
            dirs = dirs[(dirs.length - ARRIVE_STEPS)..]
          end
          walk(ge, dirs.map { |dd| MOVE[dd] } + [TURN[$game_player.direction] || 19], wait_for: false)
        else
          ge.moveto(slot[0], slot[1])
        end
        walkers << ge
      end
      guard = 0
      while walkers.any?(&:move_route_forcing) && guard < 400
        wait(1)
        guard += 1
      end
      walkers.each { |ge| ge.through = true }
    rescue StandardError => e
      log("arrive: #{e.message}")
    end

    ARRIVE_STEPS = 9

    # Any free tile within three steps of you, nearest first (a small shop with
    # no room left beside you).
    def near_slot(reserved = [])
      px, py = $game_player.x, $game_player.y
      taken = @summoned.values.map { |g, _| [g.x, g.y] } + reserved
      cands = []
      (-3..3).each do |dx|
        (-3..3).each do |dy|
          d = dx.abs + dy.abs
          next if d < 2 || d > 3
          x, y = px + dx, py + dy
          next if !$game_map.valid?(x, y) || taken.include?([x, y])
          next if !($game_map.passable?(x, y, 0) rescue false)
          next if $game_map.events.values.any? { |e| e.x == x && e.y == y && !e.through && !e.character_name.to_s.empty? }
          cands << [d, x, y]
        end
      end
      c = cands.min_by(&:first) or return nil
      [c[1], c[2], c[1], c[2]]
    end

    # Hold the companions who walked in on screen while a scene runs outside an
    # event (a step trigger), where no interpreter marks the game as busy.
    def hold
      @hold = true
      yield
    ensure
      @hold = false
    end

    # Map characters who walked up to you: once you have control, if they stand
    # between you and ground you could otherwise reach, each walks back to where
    # it stood (straight there if the way is shut). Otherwise they stay put.
    def send_moved_home
      busy = @hold || ($game_system.map_interpreter.running? rescue false) || ($game_temp.message_window_showing rescue false) ||
             ($game_map.events.values.any?(&:starting) rescue false)
      return if busy
      live = @moved.values.select { |ev, *_| $game_map.events[ev.id].equal?(ev) && !ev.instance_variable_get(:@erased) }
      return @moved.clear if live.empty?
      # Only if they wall you in: most stay where they came to talk to you.
      if !walls_you_in?(live.map(&:first))
        @moved.clear
        return
      end
      live.each do |ev, hx, hy, hd|
        next if ev.move_route_forcing
        next if ev.x == hx && ev.y == hy
        next if $game_player.x == hx && $game_player.y == hy     # (you're standing in its place: leave it be)
        dirs = path_for(ev, hx, hy) rescue nil
        if dirs && !dirs.empty?
          pbMoveRoute(ev, dirs.map { |d| MOVE[d] } + [TURN[hd]].compact) rescue nil
        else
          ev.moveto(hx, hy) rescue nil
          ev.direction = hd rescue nil
        end
      end
      @moved.clear
    rescue StandardError => e
      log("send_moved_home: #{e.message}")
      @moved&.clear
    end

    # Whether these characters cut you off from ground you could reach without
    # them (a flood fill from where you stand, with and without them).
    def walls_you_in?(evs)
      reach = lambda do
        seen = { [$game_player.x, $game_player.y] => true }
        q = [[$game_player.x, $game_player.y]]
        until q.empty? || seen.size > 4000
          x, y = q.shift
          DIRS4.each do |d, (dx, dy)|
            nx, ny = x + dx, y + dy
            next if seen[[nx, ny]] || !$game_map.valid?(nx, ny)
            next unless $game_player.passable?(x, y, d)
            seen[[nx, ny]] = true
            q << [nx, ny]
          end
        end
        seen.size
      end
      with = reach.call
      was = evs.map(&:through)
      evs.each { |e| e.through = true }
      without = reach.call
      evs.zip(was).each { |e, t| e.through = t }
      without > with + 4
    rescue StandardError => e
      log("walls_you_in?: #{e.message}")
      false
    end
    DIRS4 = { 2 => [0, 1], 4 => [-1, 0], 6 => [1, 0], 8 => [0, -1] }

    # Called every frame: once the player has control again, the companions who
    # walked in step back out and go.
    def update_summoned
      # A scene's actors never block you once they've stopped walking: a forced
      # route ends with the event's through back off, and a party left standing
      # after a scene (the orb's visions, the Canticle in the Hall) boxed the
      # player into a corner with no way out but a map change.
      @actors.each_value { |ge| ge.through = true if !ge.through && !ge.move_route_forcing } if @actors && !@actors.empty?
      send_moved_home if @moved && !@moved.empty?
      return if @summoned.empty? && @leaving.empty?
      @leaving.dup.each do |pair|
        pair[1] -= 1
        next if pair[1] > 0
        remove_actor(pair[0])
        @leaving.delete(pair)
      end
      return if @summoned.empty?
      busy = @hold || ($game_system.map_interpreter.running? rescue false) || ($game_temp.message_window_showing rescue false)
      return if busy
      @summoned.each_value do |ge, from|
        dx, dy = from[0] - ge.x, from[1] - ge.y
        if dx != 0 || dy != 0
          d = dx > 0 ? 6 : dx < 0 ? 4 : dy > 0 ? 2 : 8
          pbMoveRoute(ge, [37, MOVE[d]]) rescue nil
        end
        @leaving << [ge, 18]
      end
      @summoned.clear
    rescue StandardError => e
      log("update_summoned: #{e.message}")
      @summoned.clear
    end

    # The character a line's speaker tag names ("TAMSIN: ..."), if one is on
    # the map and visible: the event that started the scene first, then any
    # character whose event name contains the speaker's name.
    def speaker(name, event_id = nil)
      return nil if !map? || !name
      want = name.to_s.downcase.strip
      seen = lambda do |e|
        e && !e.character_name.to_s.empty? && !e.transparent && !e.instance_variable_get(:@erased) &&
          e.name.to_s !~ NOT_SPEAKERS
      end
      label = lambda do |e|
        e.name.to_s.sub(/\Astage_/, "").tr("_", " ").downcase
      end
      first = event_id && event_id > 0 ? $game_map.events[event_id] : nil
      return first if seen.(first) && label.(first).split(/[^a-z']+/).include?(want.split.first)
      $game_map.events.values.select(&seen).find do |e|
        words = label.(e).split(/[^a-z'\-]+/)
        want.split.all? { |w| words.include?(w) }
      end
    rescue StandardError
      nil
    end
  end
end
