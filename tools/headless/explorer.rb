# An automatic completionist: on every map it can reach, it talks to every
# person, steps on every door, warp and trigger, fights whoever challenges it,
# and keeps going until nothing new happens anywhere. Because the story is
# built out of those same events, this plays the story too.
require_relative "driver"
require "set"

module Explorer
  @done = Set.new          # [state, map, event id] already tried in that story state
  @edges = {}              # map => { [event id] => destination map }
  @visited = Set.new
  @transcript = []
  @event_seen = Hash.new { |h, k| h[k] = Set.new }   # map => event ids interacted with
  class << self
    attr_reader :edges, :visited, :transcript, :event_seen
    attr_accessor :level_floor

    def state
      fl = (FrostThaw.state[:flags] || {}).select { |_k, v| v }.keys.map(&:to_s).sort
      sw = (3900..3999).select { |i| $game_switches[i] }
      [fl, sw, ($Trainer.badge_count rescue 0)].hash
    end

    def map_id; $game_map.map_id; end

    def transfers_of(ev)
      ev.instance_variable_get(:@event).pages.flat_map(&:list).select { |c| c.code == 201 }.map { |c| c.parameters[1] }
    end

    def visible?(ev); !ev.character_name.to_s.empty? || ev.tile_id.to_i > 0; end

    def interesting?(ev)
      return false if ev.instance_variable_get(:@erased)
      page = ev.instance_variable_get(:@page)
      return false if !page
      list = page.list || []
      return false if list.size <= 1 && !visible?(ev)
      return false if [3, 4].include?(ev.trigger)               # autorun / parallel run by themselves
      src = list.select { |c| [355, 655].include?(c.code) }.map { |c| c.parameters[0].to_s }.join("\n")
      return false if src =~ /pbPokeCenterPC|pbPCItemStorage|pbPCMailbox|pbTrainerPC/   # menus a person drives
      true
    end

    # Keep the team strong enough to see the whole story; the balance of
    # each fight is checked separately.
    def keep_team_fit
      return if !$Trainer || $Trainer.party.empty?
      $Trainer.party.each do |pk|
        if @level_floor && pk.level < @level_floor
          pk.level = @level_floor; pk.calc_stats
        end
        pk.heal
      end
    end

    def interact(ev)
      HL.say("go", "#{ev.name} (#{ev.x},#{ev.y}) on #{map_id}")
      before = HL.log.size
      if ev.trigger == 0 || visible?(ev)
        3.times do
          r = HL.talk_to(ev)
          return r if r != :ok
          break if HL.log.size > before || map_id != @cur
          HL.frames(30)       # a wandering NPC moved; try again
        end
        :ok
      else
        r = HL.walk_to(ev.x, ev.y)
        if r == :blocked
          r = HL.walk_to(ev.x, ev.y, adjacent: true)
          if r == :ok
            dx, dy = ev.x - $game_player.x, ev.y - $game_player.y
            d = HL::DIRS.find { |_k, v| v == [dx, dy] }&.first
            HL.step(d) if d
            r = :ok
          end
        end
        r
      end
    end

    # Everything left to try on the current map in the current story state.
    def todo
      st = state
      seen_dest = Set.new
      $game_map.events.values.select { |e| interesting?(e) && !@done.include?([st, map_id, e.id]) }
                       .reject { |e| d = transfers_of(e); !d.empty? && d.all? { |m| @done.include?([st, map_id, :dest, m]) } }
                       .sort_by { |e| [transfers_of(e).empty? ? 0 : 1, (e.x - $game_player.x).abs + (e.y - $game_player.y).abs] }
    end

    def explore_here
      @visited << map_id
      loop do
        HL.block_state = state
        keep_team_fit
        ev = todo.first
        return if !ev
        @cur = map_id
        st0 = state
        @done << [st0, map_id, ev.id]
        from_map, eid = map_id, ev.id
        $headless_watchdog = Graphics.frame_count + 80000
        begin
          r = interact(ev)
        rescue HeadlessStuck => e
          HL.problem("STUCK on map #{from_map} doing #{ev.name} (#{ev.x},#{ev.y}): #{e.backtrace.reject { |l| l =~ /internal|headless/ }.first(3).join(' <- ')}")
          unstick!
          r = :stuck
        end
        $headless_watchdog = nil
        HL.say("result", "#{r}") if r != :ok
        @event_seen[from_map] << eid if r == :ok || r == :moved_away
        HL.problem("can't reach #{ev.name} at (#{ev.x},#{ev.y}) on map #{from_map}") if r == :blocked && !@reported_blocked&.include?([from_map, eid]) && ((@reported_blocked ||= Set.new) << [from_map, eid])
        if map_id != from_map
          @done << [st0, from_map, :dest, map_id]
          (@edges[from_map] ||= {})[eid] = map_id
          return            # explore the new map first; the caller comes back
        end
      end
    end

    def unstick!
      pbMapInterpreter.setup(nil, 0) rescue nil
      $game_temp.message_window_showing = false
      $game_player.unlock rescue nil
    end

    # Travel to a map along doors we've already used.
    def path_to(target)
      prev = { map_id => nil }
      q = [map_id]
      until q.empty?
        m = q.shift
        return build(prev, target) if m == target
        (@edges[m] || {}).each do |eid, dest|
          next if prev.key?(dest)
          prev[dest] = [m, eid]
          q << dest
        end
      end
      nil
    end

    def build(prev, target)
      hops = []
      cur = target
      while (p = prev[cur])
        hops.unshift(p); cur = p[0]
      end
      hops
    end

    def travel_to(target)
      hops = path_to(target) or return false
      hops.each do |m, eid|
        return false if map_id != m
        ev = $game_map.events[eid] or return false
        $headless_watchdog = Graphics.frame_count + 80000
        begin
          interact(ev)
        rescue HeadlessStuck
          unstick!; return false
        ensure
          $headless_watchdog = nil
        end
        if map_id == m
          @edges[m].delete(eid)        # that door doesn't lead there (any more)
          return false
        end
      end
      map_id == target
    end

    def run(max_iterations: 400)
      explored = Set.new
      max_iterations.times do
        here = map_id
        explore_here
        next if map_id != here
        explored << [state, here]
        known = ([@visited.to_a] + @edges.values.map(&:values)).flatten.uniq
        pending = known.reject { |m| explored.include?([state, m]) }
        pending = pending.sort_by { |m| (path_to(m) || Array.new(99)).size }
        target = pending.find { |m| path_to(m) }
        break if !target
        explored << [state, target] if !travel_to(target)
      end
    end
  end
end
