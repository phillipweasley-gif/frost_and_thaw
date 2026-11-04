# Drives the real game headlessly: messages are answered by rules instead of
# a person, battles are fought by the game's own AI on the player's side, and
# the overworld advances one frame at a time with scripted button presses.
require_relative "boot"

module HL
  @log = []
  @answers = []        # [regex, choice index] rules for menus
  @problems = []
  class << self
    attr_reader :log, :problems
    attr_accessor :answers, :battle_log, :quiet

    def say(kind, text)
      line = "[#{kind}] #{text.to_s.gsub(/\\[a-zA-Z]+\[[^\]]*\]|\\[a-zA-Z.|!^]/, '').strip}"
      @log << line
      puts line unless @quiet
    end

    def problem(msg)
      @problems << msg
      puts "!!! #{msg}"
    end

    # Which option to pick for a prompt (default: the first).
    def choose(text, commands)
      @answers.each do |re, pick|
        next unless text.to_s =~ re || commands.any? { |c| c.to_s =~ re }
        idx = pick.is_a?(Proc) ? pick.call(text, commands) : pick
        idx = commands.index { |c| c.to_s =~ idx } if idx.is_a?(Regexp)
        return idx if idx && idx >= 0 && idx < commands.size
      end
      0
    end
  end
end

# --- messages: logged, answered by rules -----------------------------------------
def pbMessage(message, commands = nil, cmdIfCancel = 0, skin = nil, defaultCmd = 0, &block)
  HL.say("msg", message)
  return 0 if !commands
  idx = HL.choose(message, commands)
  HL.say("pick", "#{commands[idx]}  (of #{commands.map(&:to_s).join(' | ')})")
  idx
end
def pbMessageNoSound(*a, &b); pbMessage(*a, &b); end
def pbConfirmMessage(message, &block)
  HL.say("ask", message)
  HL.choose(message, ["Yes", "No"]) == 0
end
def pbConfirmMessageSerious(message, &block); pbConfirmMessage(message, &block); end
def pbShowCommands(msgwindow, commands = nil, cmdIfCancel = 0, defaultCmd = 0, *rest)
  return 0 if !commands
  idx = HL.choose("", commands)
  HL.say("pick", "#{commands[idx]}  (of #{commands.map(&:to_s).join(' | ')})")
  idx
end
def pbMessageChooseNumber(message, params, &block); HL.say("number", message); 1; end
def pbEnterText(helptext, *rest); HL.say("text", helptext); "Test"; end
def pbEnterPlayerName(*a); "Tester"; end
def pbEnterPokemonName(*a); ""; end
def pbEnterBoxName(*a); "Box"; end
def pbMessageDisplay(msgwindow, message, *rest, &block); HL.say("msg", message); 0; end
def pbCallBub(*); end
def pbWait(n = 1); n.times { Graphics.update }; end

# --- battles: the game's AI fights for you too ----------------------------------
class PokeBattle_Battle
  alias hl_pbStartBattle pbStartBattle unless method_defined?(:hl_pbStartBattle)
  def pbStartBattle
    @controlPlayer = true
    HL.say("battle", "start vs " + (@opponent ? @opponent.map(&:full_name).join(" & ") : @party2.map(&:name).join(", ")))
    hl_pbStartBattle
  end
  alias hl_pbDisplay pbDisplay unless method_defined?(:hl_pbDisplay)
  def pbDisplay(msg, &block); (HL.battle_log ||= []) << msg; HL.say("bmsg", msg) if ENV["HL_BATTLE"]; end
  def pbDisplayPaused(msg, &block); pbDisplay(msg); end
  def pbDisplayBrief(msg); pbDisplay(msg); end
  def pbDisplayConfirm(msg); pbDisplay(msg); true; end
end

class HLBattleScene < PokeBattle_DebugSceneNoLogging
  def pbDisplayMessage(msg, brief = false); HL.say("bmsg", msg) if ENV["HL_BATTLE"]; (HL.battle_log ||= []) << msg; end
  def pbDisplayPausedMessage(msg); pbDisplayMessage(msg); end
  def method_missing(n, *a, &b); nil; end
  def respond_to_missing?(*); true; end
end
def pbNewBattleScene; HLBattleScene.new; end

# A script that runs its own little loop (a minigame, a menu) waits for a
# button: press confirm for it every so often, like a player would.
$hl_nested = 0
$headless_frame_hook = proc do
  if $hl_driver_update
    $hl_nested = 0
  else
    $hl_nested += 1
    Input.queue.push(Input::C) if $hl_nested % 45 == 0 && Input.queue.empty?
  end
end

# --- start-up, as the game's main function does it ---------------------------------
module HL
  class << self
    def start_up
      MessageTypes.loadMessageFile("Data/messages.dat") if safeExists?("Data/messages.dat")
      PluginManager.runPlugins rescue nil
      Game.initialize
      Game.set_up_system
    end

    # One frame of the overworld, exactly like Scene_Map's loop.
    def frame(keys = nil)
      Input.queue.push(keys) if keys
      $hl_driver_update = true
      Graphics.update
      $hl_driver_update = false
      Input.update
      if $scene.is_a?(Scene_Map) && !$scene.instance_variable_get(:@spritesets)
        $scene.createSpritesets
      end
      begin
        $scene.update if $scene.respond_to?(:update)
      rescue HeadlessStuck
        raise
      rescue StandardError, ScriptError => e
        # in the real game this is a crash with an error window
        first = e.message.to_s.lines.first(8).join.strip + (ENV["HL_BT"] ? "\n" + e.backtrace.first(8).join("\n") : "")
        problem("GAME ERROR on map #{$game_map&.map_id} at #{pos}: #{first}")
        File.open("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/x2/game_errors.txt", "a") { |f| f.puts "#{Time.now} map #{$game_map&.map_id} #{pos}: #{e.class}: #{e.message.lines.first}", e.backtrace.first(15).map { |l| "    #{l}" } } rescue nil
        (@errors ||= []) << e
        pbMapInterpreter.setup(nil, 0) rescue nil
        $game_temp.message_window_showing = false rescue nil
        $game_player.unlock rescue nil
      end
      check_scene
    end

    def frames(n, key = nil)
      n.times { frame(key) }
    end

    def check_scene
      return if $scene.is_a?(Scene_Map) || $scene.nil?
      # a menu or other scene took over: let it run its own main loop with no input
      HL.say("scene", $scene.class.name)
    end

    def busy?
      $game_temp.message_window_showing || pbMapInterpreterRunning? || $game_player.moving? ||
        $game_temp.transition_processing || $game_temp.player_transferring
    end

    def settle(max = 400)
      max.times do
        frame
        return true if !busy?
      end
      problem("still busy after #{max} frames on map #{$game_map.map_id} at #{pos}")
      false
    end

    def pos; "(#{$game_player.x},#{$game_player.y})"; end
  end
end

# --- no drawing: sprite sets are empty shells -------------------------------------
class HLNull < BasicObject
  def initialize(map = nil); @map = map; end
  def map; @map; end
  def method_missing(n, *a, &b)
    return false if n.to_s.end_with?("?")
    return nil if n.to_s.end_with?("=")
    ::HLNull.new
  end
  def respond_to?(*); true; end
  def respond_to_missing?(*); true; end
  def is_a?(k); k == ::HLNull; end
  def kind_of?(k); is_a?(k); end
  def nil?; false; end
  def !; false; end
  def ==(o); equal?(o); end
  def class; ::HLNull; end
  def to_s; "HLNull"; end
  def inspect; "HLNull"; end
  def dispose; end
  def disposed?; true; end      # animations end at once
  def character_sprites; []; end
  def each(*); end
  def to_a; []; end
  def getAnimations; []; end
  def restoreAnimations(*); end
end
class Scene_Map
  def createSpritesets
    @map_renderer = HLNull.new
    @spritesetGlobal = HLNull.new
    @spritesets = {}
    $MapFactory.maps.each { |map| @spritesets[map.map_id] = HLNull.new(map) }
    $MapFactory.setSceneStarted(self)
  end
  def createSingleSpriteset(map)
    @spritesets[map] = HLNull.new($MapFactory.maps[map])
    $MapFactory.setSceneStarted(self)
  end
  def updateSpritesets(*)
    @spritesets ||= {}; $MapFactory.maps.each { |m| @spritesets[m.map_id] ||= HLNull.new(m) }
    FrostThaw::Stage.update_summoned rescue nil     # (the game's own per-frame staging that isn't drawing)
  end
end

# --- moving around like a player ------------------------------------------------------
require "set"
module HL
  DIRS = { 2 => [0, 1], 4 => [-1, 0], 6 => [1, 0], 8 => [0, -1] }
  class << self
    attr_accessor :block_state
    # Shortest route over tiles the engine says the player can walk.
    def route(tx, ty, adjacent: false)
      sx, sy = $game_player.x, $game_player.y
      goal = adjacent ? ->(x, y) { (x - tx).abs + (y - ty).abs == 1 } : ->(x, y) { x == tx && y == ty }
      return [] if goal.(sx, sy)
      prev = { [sx, sy] => nil }
      q = [[sx, sy]]
      until q.empty?
        x, y = q.shift
        DIRS.each do |d, (dx, dy)|
          nx, ny = x + dx, y + dy
          next if prev.key?([nx, ny]) || !$game_map.valid?(nx, ny)
          next unless $game_player.passable?(x, y, d)
          next if !goal.(nx, ny) && warp_tiles.include?([nx, ny])     # don't wander through doors on the way
          if (sl = slopes[[nx, ny]]) && !goal.(nx, ny)
            # a stairway: stepping on carries you diagonally (maybe several times)
            cx, cy = nx, ny
            6.times do
              s2 = slopes[[cx, cy]] or break
              code = s2[:face] == d ? s2[:yes] : s2[:no]
              ddx, ddy = SLOPE_D[code] || [0, 0]
              lx, ly = cx + ddx, cy + ddy
              break unless $game_map.valid?(lx, ly) && $game_map.passable?(lx, ly, 0, $game_player)
              cx, cy = lx, ly
            end
            nx, ny = cx, cy
            next if prev.key?([nx, ny])
          end
          next if (@blocked ||= Set.new).include?([$game_map.map_id, nx, ny, @block_state])
          prev[[nx, ny]] = [x, y, d]
          if goal.(nx, ny)
            path = []
            cur = [nx, ny]
            while (p = prev[cur])
              path.unshift(p[2]); cur = [p[0], p[1]]
            end
            return path
          end
          q << [nx, ny]
        end
      end
      nil
    end

    SLOPE_D = { 1 => [0, 1], 2 => [-1, 0], 3 => [1, 0], 4 => [0, -1], 5 => [-1, 1], 6 => [1, 1], 7 => [-1, -1], 8 => [1, -1] }

    # Diagonal stairways: invisible step-on events that move you with a
    # move route depending on which way you face.
    def slopes
      @slopes_cache ||= {}
      @slopes_cache[$game_map.map_id] ||= begin
        h = {}
        $game_map.events.values.each do |e|
          list = (e.instance_variable_get(:@page)&.list || [])
          br = list.find { |c| c.code == 111 && c.parameters[0] == 6 && c.parameters[1] == -1 } or next
          routes = list.select { |c| c.code == 209 && c.parameters[0] == -1 }.map { |c| c.parameters[1].list.first&.code }
          next if routes.size < 2 || !(SLOPE_D.key?(routes[0]) && SLOPE_D.key?(routes[1])) || ([routes[0], routes[1]] & [5, 6, 7, 8]).empty?
          h[[e.x, e.y]] = { face: br.parameters[2], yes: routes[0], no: routes[1] }
        end
        h
      end
    end

    def warp_tiles
      $game_map.events.values.select do |e|
        pg = e.instance_variable_get(:@page)
        pg && [1, 2].include?(e.trigger) && pg.list.any? { |c| c.code == 201 }
      end.map { |e| [e.x, e.y] }
    end

    # Takes one step; returns true if the player ended up somewhere new.
    def step(d)
      map0, x0, y0 = $game_map.map_id, $game_player.x, $game_player.y
      12.times do
        frame(d)
        break if $game_player.moving?
      end
      settle(600)
      [$game_map.map_id, $game_player.x, $game_player.y] != [map0, x0, y0]
    end

    def face(d)
      $game_player.turn_toward_dir(d) rescue nil
      { 2 => :turn_down, 4 => :turn_left, 6 => :turn_right, 8 => :turn_up }[d].then { |m| $game_player.send(m) }
    end

    def press_c
      frame(Input::C)
      settle(2000)
    end

    # Walks to (x, y) (or next to it). Returns :ok, :blocked or :moved_away
    # (an event or warp took the player elsewhere on the way).
    def walk_to(tx, ty, adjacent: false, max_steps: 400)
      map0 = $game_map.map_id
      max_steps.times do
        return :moved_away if $game_map.map_id != map0
        path = route(tx, ty, adjacent: adjacent)
        return :blocked if path.nil?
        return :ok if path.empty?
        d = path.first
        x0, y0 = $game_player.x, $game_player.y
        nx, ny = x0 + DIRS[d][0], y0 + DIRS[d][1]
        moved = step(d)
        if $game_map.map_id == map0 && ($game_player.x == x0 && $game_player.y == y0 ||
                                         $game_player.x == x0 - DIRS[d][0] && $game_player.y == y0 - DIRS[d][1])
          # something turned us back or held us (a story block): don't try that tile again now
          (@blocked ||= Set.new) << [map0, nx, ny, @block_state]
        end
        unless moved
          return :moved_away if $game_map.map_id != map0
          # something stopped us (an event moved into the way); try again next loop
          frames(10)
        end
      end
      :blocked
    end

    # Walk up to an event and talk to it (across a counter if need be).
    def talk_to(ev)
      r = walk_to(ev.x, ev.y, adjacent: true)
      if r == :blocked
        # stand two tiles away, facing it; across a counter first (shop counters,
        # the Poké Ball table), since that's where the game lets you talk over
        order = DIRS.sort_by { |_d, (dx, dy)| ($game_map.counter?(ev.x - dx, ev.y - dy) rescue false) ? 0 : 1 }
        order.each do |d, (dx, dy)|
          cx, cy = ev.x - dx * 2, ev.y - dy * 2
          next if route(cx, cy).nil?
          next if walk_to(cx, cy) != :ok
          face(d); frames(2); press_c
          return :ok
        end
        return :blocked
      end
      return r if r != :ok
      dx, dy = ev.x - $game_player.x, ev.y - $game_player.y
      d = DIRS.key([dx <=> 0, dy <=> 0]) || DIRS.find { |_k, v| v == [dx, dy] }&.first
      face(d) if d
      frames(2)
      press_c
      :ok
    end
  end
end

# --- screens a person drives: logged instead of opened --------------------------------
def pbPokeCenterPC(*); HL.say("ui", "PC"); end
def pbTrainerPC(*); HL.say("ui", "PC"); end
def pbPCItemStorage(*); HL.say("ui", "item PC"); end
def pbPokemonMart(stock, *rest)
  names = stock.map { |i| d = GameData::Item.try_get(i); d ? d.name : "#{i}??" }
  unknown = stock.reject { |i| GameData::Item.try_get(i) }
  HL.say("ui", "shop: #{names.join(', ')}")
  HL.problem("shop sells items the game doesn't know: #{unknown.inspect}") if !unknown.empty?
end

# --- the player's side fights like a sensible person: strongest hit that works --------
class PokeBattle_AI
  alias hl_pbDefaultChooseEnemyCommand pbDefaultChooseEnemyCommand unless method_defined?(:hl_pbDefaultChooseEnemyCommand)
  def pbDefaultChooseEnemyCommand(idxBattler)
    return hl_pbDefaultChooseEnemyCommand(idxBattler) if !@battle.pbOwnedByPlayer?(idxBattler)
    user = @battle.battlers[idxBattler]
    target = user.pbDirectOpposing(true)
    best, best_score = nil, 0
    user.eachMoveWithIndex do |m, i|
      next if !@battle.pbCanChooseMove?(idxBattler, i, false)
      next if m.baseDamage <= 1 && !m.is_a?(PokeBattle_FixedDamageMove)
      power = m.baseDamage <= 1 ? 40 : m.baseDamage
      tmod = (pbCalcTypeMod(m.type, user, target) rescue Effectiveness::NORMAL_EFFECTIVE).to_f / Effectiveness::NORMAL_EFFECTIVE
      stab = user.pbHasType?(m.type) ? 1.5 : 1.0
      acc = m.accuracy > 0 ? m.accuracy / 100.0 : 1.0
      phys = m.physicalMove? ? user.attack.to_f / [target.defense, 1].max : user.spatk.to_f / [target.spdef, 1].max
      score = power * tmod * stab * acc * phys
      best, best_score = i, score if score > best_score
    end
    return hl_pbDefaultChooseEnemyCommand(idxBattler) if best.nil?
    @battle.pbRegisterMove(idxBattler, best, false)
    @battle.pbRegisterTarget(idxBattler, target.index) if @battle.pbSideSize(1) > 1
  end
end

module HL
  # "New Game" from the title menu, the way the load screen does it.
  def self.new_game
    Game.start_new
    initialize_alt_sprite_substitutions
    $PokemonGlobal.autogen_sprites_cache = {} rescue nil
  end
end

module HL
  # Move the player straight to a map (like a debug warp) and let it settle.
  def self.warp(map_id, x, y, dir = 2)
    $game_temp.player_transferring = true
    $game_temp.player_new_map_id = map_id
    $game_temp.player_new_x = x
    $game_temp.player_new_y = y
    $game_temp.player_new_direction = dir
    frames(5)
    settle(800)
  end
end

module HL
  # The moves a sensible player would have at this level: what it started
  # with plus everything learned so far, keeping the best attack of each type
  # (strongest first) and filling up with the rest.
  def self.sensible_moves(pk, start_moves = nil)
    pool = (start_moves || []) + pk.getMoveList.select { |lv, _m| lv <= pk.level }.map { |_lv, m| m }
    pool = pool.uniq.map { |m| GameData::Move.get(m) }
    attacks = pool.select { |m| m.base_damage > 1 }.sort_by { |m| -m.base_damage * (m.accuracy > 0 ? m.accuracy : 100) }
    picked = []
    attacks.each { |m| picked << m if picked.none? { |p| p.type == m.type } }
    picked += (attacks - picked)
    picked += (pool - picked)
    pk.forget_all_moves
    picked.first(4).each { |m| pk.learn_move(m.id) }
    pk
  end
end

class Scene_Map
  alias hl_spriteset spriteset unless method_defined?(:hl_spriteset)
  def spriteset; (hl_spriteset rescue nil) || HLNull.new($game_map); end
end
Dir.mkdir(System.data_directory) unless Dir.exist?(System.data_directory)

# The game's error window: record the error instead.
def pbPrintException(e)
  bt = (e.backtrace || []).reject { |l| l.include?("<internal") }.first(6).join("\n      ")
  HL.problem("GAME ERROR (error window): #{e.class}: #{e.message.to_s.lines.first&.strip}\n      #{bt}")
end

# Evolution happens without the animation.
class PokemonEvolutionScene
  def pbStartScreen(pokemon, newspecies, reversing = false); @pokemon = pokemon; @newspecies = newspecies; end
  def pbEndScreen; end
  def pbUpdate; end
  def pbEvolution(cancancel = true, reversing = false)
    old = @pokemon.name
    @pokemon.species = @newspecies
    @pokemon.calc_stats
    $Trainer.pokedex.register(@pokemon) rescue nil
    HL.say("evolve", "#{old} evolved into #{GameData::Species.get(@newspecies).name}")
  end
end

# No internet in the test: downloads simply fail, as they do offline.
require "json"
module HTTPLite
  JSON = ::JSON
  def self.get(*); { status: 404, body: "" }; end
  def self.post_body(*); { status: 404, body: "" }; end
end
