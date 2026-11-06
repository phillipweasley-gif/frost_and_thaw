# Plays the story from a new game to the end of Chapter 3 on foot, the way a
# player would: walking between places through the real doors and roads,
# talking to the people the story needs, fighting every battle in the way.
# Reports each story beat as reached or not, and anything that got in the way.
$stdout.sync = true
require_relative "driver"
require "set"

module Story
  # People and things that move you between maps by script (no warp event).
  SCRIPTED_PASSAGES = { heartwall: /Knotted heart-wall/, rootcage: /Root-lift cage/, rootlift: /^Root-lift$/ }
  @world = nil
  @beats = []
  class << self
    attr_reader :beats

    # Static map of which door/warp leads where (from the map files).
    def world
      @world ||= begin
        w = Hash.new { |h, k| h[k] = [] }
        Dir["Data/FrostThaw/Map*.rxdata"].each do |f|
          id = f[/Map(\d+)/, 1].to_i
          load_data(f).events.each_value do |e|
            e.pages.each do |pg|
              c = pg.list.find { |x| x.code == 201 } or next
              sw = pg.condition.switch1_valid ? pg.condition.switch1_id : nil
              w[id] << [e.id, e.x, e.y, c.parameters[1], sw]
            end
          end
        end
        w[2050] << [:lift, 16, 11, 2061]      # the root-lift (a person, not a door)
        w[2061] << [:lift, 12, 34, 2050]
        w[2050] << [:hew, 48, 27, 2066]       # Hew takes you down his ladder (a person, not a door)
        w[2066] << [:ladder, 5, 4, 2050]      # and the ladder back up (a bell-rope and a question)
        w[2058] << [:heartwall, 20, 26, 2140] # the Root-Key opens the knotted heart-wall (046_DeepLabyrinth.rb)
        w[2144] << [:rootcage, 21, 18, 2066]  # the Root-Lift Node rides down to the forge door
        w[2066] << [:rootlift, 19, 19, 2144, 4083]   # ...and back up, once it runs
        w.each_value(&:uniq!)
        w
      end
    end

    def map_path(from, to)
      prev = { from => nil }; q = [from]
      until q.empty?
        m = q.shift
        break if m == to
        world[m].each { |_eid, _x, _y, d, sw| next if prev.key?(d) || (sw && !$game_switches[sw]); prev[d] = m; q << d }
      end
      return nil if !prev.key?(to)
      path = [to]
      path.unshift(prev[path.first]) while prev[path.first]
      path
    end

    # Walk to another map through the doors, as a player would.
    # Slides across ice (or the Overflow Channel's slick sap) to stand next to an
    # event, the way a player would: once you're moving, you're moving.
    def slide_to_event(re)
      ev = $game_map.events.values.find { |e| e.name =~ re }
      return false if !ev
      dirs = { 2 => [0, 1], 4 => [-1, 0], 6 => [1, 0], 8 => [0, -1] }
      ice = ->(x, y) { ($game_map.terrain_tag(x, y).ice rescue false) }
      mv = lambda do |(x, y), d|
        return nil if !$game_player.passable?(x, y, d)
        dx, dy = dirs[d]; x += dx; y += dy
        while ice.(x, y) && $game_player.passable?(x, y, d)
          x += dx; y += dy
        end
        [x, y]
      end
      start = [$game_player.x, $game_player.y]
      prev = { start => nil }; q = [start]; goal = nil
      until q.empty? || goal
        c = q.shift
        dirs.each do |d, (dx, dy)|
          (goal = [c, d]; break) if [c[0] + dx, c[1] + dy] == [ev.x, ev.y]
          n = mv.(c, d)
          next if !n || prev.key?(n)
          prev[n] = [c, d]; q << n
        end
      end
      return false if !goal
      path = []; c = goal[0]
      while prev[c]
        pc, d = prev[c]; path.unshift(d); c = pc
      end
      path.each { |d| HL.step(d) }
      HL.face(goal[1]); HL.press_c
      true
    end

    def travel(to, tries: 12)
      tries.times do
        return true if $game_map.map_id == to
        path = map_path($game_map.map_id, to) or (HL.problem("no way from map #{$game_map.map_id} to #{to}"); return false)
        nxt = path[1]
        if world[$game_map.map_id].any? { |e, _x, _y, d| e == :lift && d == nxt }
          nxt == 2061 ? (talk(/Lift-keeper/); HL.settle(3000)) : lift_down
          next
        end
        if world[$game_map.map_id].any? { |e, _x, _y, d| e == :hew && d == nxt }
          talk(/Hew Talmire/); HL.settle(3000)
          next
        end
        if world[$game_map.map_id].any? { |e, _x, _y, d| e == :ladder && d == nxt }
          talk(/Ladder shaft/); HL.settle(3000)
          next
        end
        sp = world[$game_map.map_id].find { |e, _x, _y, d| SCRIPTED_PASSAGES[e] && d == nxt }
        if sp
          talk(SCRIPTED_PASSAGES[sp[0]]); HL.frames(20); HL.settle(3000)
          next
        end
        doors = world[$game_map.map_id].select { |e, _x, _y, d| d == nxt && !e.is_a?(Symbol) }
        # no walking route to any door (e.g. the Statue Fields' slide): try a warp
        # inside this map that's live now (the rope back up), then look again
        if !doors.empty? && doors.all? { |_e, x, y, _d| HL.route(x, y).nil? }
          here = $game_map.map_id
          inner = world[here].select do |e, _x, _y, d|
            next false if e.is_a?(Symbol) || d != here
            pg = $game_map.events[e]&.instance_variable_get(:@page)
            pg && pg.list.any? { |c| c.code == 201 }
          end
          used = inner.find { |_e, x, y, _d| HL.route(x, y) }
          if used
            HL.walk_to(used[1], used[2]); HL.settle(3000)
            next
          end
        end
        moved = false
        doors.sort_by { |_e, x, y, _d| HL.route(x, y)&.size || 999 }.each do |eid, x, y, _d|
          ev = $game_map.events[eid] or next
          next if ev.instance_variable_get(:@page).nil?
          r = HL.walk_to(x, y)
          if r == :blocked
            r = HL.walk_to(x, y, adjacent: true)
            if r == :ok
              d = HL::DIRS.find { |_k, v| v == [x - $game_player.x, y - $game_player.y] }&.first
              HL.step(d) if d
            end
          end
          HL.settle(3000)
          if $game_map.map_id != nxt && ev.instance_variable_get(:@page) && ev.instance_variable_get(:@page).trigger == 0
            HL.talk_to(ev); HL.settle(3000)       # a door you open by pressing A (the Root-Gate's fence)
          end
          if $game_map.map_id == nxt then moved = true; break end
        end
        unless moved
          @stuck_tries = (@stuck_tries || 0) + 1
          if @stuck_tries < 4
            HL.frames(80)          # someone wandering may be in the way: wait and try again
            next
          end
          @stuck_tries = 0
          HL.problem("couldn't get from map #{$game_map.map_id} to #{nxt} on foot (at #{HL.pos})")
          return false
        end
        @stuck_tries = 0
      end
      $game_map.map_id == to
    end

    def find_event(name)
      $game_map.events.values.find { |e| e.name.to_s =~ name && e.instance_variable_get(:@page) }
    end

    # Beat every trainer on this map who's still waiting (they may stand in the way).
    def clear_trainers
      $game_map.events.values.select { |e| e.name =~ /^Trainer/ && e.instance_variable_get(:@page) && !$game_self_switches[[$game_map.map_id, e.id, "A"]] }.each do |e|
        HL.talk_to(e); HL.settle(3000)
        break if $game_map.map_id != @here
      end
    end

    def talk(name)
      ev = find_event(name) or (HL.problem("nobody called #{name.inspect} on map #{$game_map.map_id}"); return false)
      @here = $game_map.map_id
      if HL.route(ev.x, ev.y, adjacent: true).nil?
        clear_trainers
        ev = find_event(name) or return false
      end
      r = HL.talk_to(ev)
      HL.problem("couldn't reach #{ev.name} on map #{$game_map.map_id} (#{r})") if r != :ok
      HL.settle(3000)
      pg = ev.instance_variable_get(:@page)
      if r == :ok && pg && pg.trigger == 1 && $game_map.map_id == @here && !ev.starting   # a touch event: walk into it
        d = HL::DIRS.find { |_k, v| v == [ev.x - $game_player.x, ev.y - $game_player.y] }&.first
        HL.step(d) if d
        HL.settle(3000)
      end
      r == :ok
    end

    def step_on(name)
      ev = find_event(name) or (HL.problem("no #{name.inspect} on map #{$game_map.map_id}"); return false)
      r = HL.walk_to(ev.x, ev.y)
      HL.settle(3000)
      r != :blocked
    end

    def beat(label, flag = nil)
      ok = flag.nil? || FrostThaw.flag?(flag)
      if ENV["LOOP_DUMP"] && ok && %i[act1_done ch10_done].include?(flag)
        File.write("#{ENV['LOOP_DUMP']}_#{flag}.txt", (FrostThaw.state[:flags] || {}).select { |_k, v| v }.keys.map(&:to_s).sort.join("\n"))
      end
      @beats << [label, ok]
      puts "#{ok ? 'OK  ' : 'MISS'} #{label}#{flag ? " (#{flag})" : ''}  [map #{$game_map.map_id} #{HL.pos}]"
      ok
    end

    def fit(level)
      level = [level, 100].min
      $Trainer.party.each do |pk|
        if pk.level < level
          pk.level = level
          # a player who trained this far would have evolved it
          8.times { ns = (pk.check_evolution_on_level_up(false) rescue nil); break if !ns || ns == pk.species; pk.species = ns; pk.level = level }
          HL.sensible_moves(pk, FrostThaw::STARTER_MOVES[pk.species]); pk.calc_stats
        end
        pk.heal
      end
      puts "  [fit #{level}] " + $Trainer.party.map { |pk| "#{pk.species}/#{pk.level}(#{pk.moves.map(&:id).join(',')})" }.join(" ") if ENV["FIT_LOG"]
    end

    # Try a beat; if a battle is lost, train up (like a player would) and retry.
    def until_flag(flag, tries = 4)
      tries.times do |i|
        return true if FrostThaw.flag?(flag)     # (already done, e.g. inside an earlier talk)
        yield
        return true if FrostThaw.flag?(flag)
        lv = ($Trainer.party.map(&:level).max || 10) + 3
        HL.say("note", "lost or blocked; training to L#{lv} and trying again")
        @retries = (@retries || 0) + 1
        fit(lv)
      end
      false
    end

    # Visit every place and talk to everyone/everything in the current story state.
    def sweep(label)
      maps = world.keys.sort
      start = $game_map.map_id
      before_err = HL.problems.size
      talked = 0
      maps.each do |m|
        next unless travel(m)
        $game_map.events.values.select { |e| (!e.character_name.to_s.empty? || e.name =~ /^Sign/) && e.instance_variable_get(:@page) }.each do |e|
          next if e.instance_variable_get(:@page).list.size <= 1
          before = HL.log.size
          $headless_watchdog = Graphics.frame_count + 60000
          r = (HL.talk_to(e) rescue :stuck)
          HL.settle(3000)
          talked += 1
          said = HL.log[before..].select { |l| l.start_with?("[msg]") }
          HL.problem("#{label}: #{e.name} on map #{m} said nothing") if r == :ok && said.empty? && $game_map.map_id == m && e.name !~ /Trainer|Spar|EV\d/
          HL.problem("#{label}: #{e.name} on map #{m} gave the placeholder line") if said.any? { |l| l.strip == "[msg] ..." }
          HL.problem("#{label}: couldn't reach #{e.name} at (#{e.x},#{e.y}) on map #{m}") if r == :blocked
          travel(m) if $game_map.map_id != m
        end
      end
      $headless_watchdog = nil
      travel(start)
      puts "SWEEP #{label}: talked to #{talked} people and things; #{HL.problems.size - before_err} new problems"
    end

    # The New Journey prologue (SC 0.01-0.04): Rootspire's festival morning.
    def prologue
      return unless FrostThaw.journey?
      HL.frames(30); HL.settle(3000)
      beat("festival morning at the Hearth", :intro_started)
      travel(2091)
      talk(/Lift-keeper/); HL.frames(30); HL.settle(8000)
      beat("Tamsin leads you to the lecture room", :pro_led_to_room)
      step_on(/Lecture room door/); HL.settle(8000)
      beat("meet Professor Wynsnow", :met_wynsnow)
      talk(/Starter ball #{(ENV["HL_STARTER"] || 0).to_i + 1}/) unless FrostThaw.flag?(:got_starter)   # (a loop: you have yours)
      HL.settle(12000)
      beat("first Pokémon from Wynsnow's table", :got_starter)
      beat("first battle with Tamsin", :pro_battle_done)
      travel(2091); HL.frames(30); HL.settle(12000)
      beat("Tamsin leads you back to the Hearth", :pro_led)
      HL.frames(30); HL.settle(8000)
      beat("the sixth figure", :saw_sixth_figure)
      travel(2091); HL.frames(60); HL.settle(8000)
      beat("through the lantern", :fell_through)
    end

    # SC 1.03: you meet the five by sitting at each table (Shade's covers Shimmer).
    def tavern_tables
      %w[Alberica Reptin Alerion Shade].each do |n|
        break if FrostThaw.flag?(:met_party)
        ev = find_event(/\A#{n}\z/)
        next if !ev || ev.character_name.to_s.empty?
        talk(/\A#{n}\z/)
        HL.settle(3000)
      end
    end

    def run
      prologue
      return if ENV["STOP_AT"] == "0"
      fit(14)
      beat("arrive in Targos", :arrived_targos)
      travel(2002); HL.frames(20); HL.settle(3000)
      tavern_tables
      beat("meet the party at Three Flags Sailing", :met_party)
      travel(2001)
      travel(2008); talk(/Widow/); travel(2001)
      beat("the widow's Spheal", :widow_spheal)
      travel(2006); talk(/Epheris/); travel(2001)
      beat("Pokédex from Epheris", :got_pokedex)
      travel(2001); talk(/Trapper/)
      beat("snowshoes from the trapper", :got_snowshoes)
      sweep("start of the game") if ENV["SWEEP"]
      fit(16)
      travel(2004); talk(/Naerth/); travel(2001)
      beat("Naerth's terms at the Luskan Arms", :naerth_terms)
      until_flag(:badge_targos) { travel(2005); talk(/Naerth/) }
      beat("Naerth's seal", :badge_targos)
      beat("DNA Splicers from Naerth", :got_splicers)
      travel(2001)
      fit(18)
      travel(2010)
      beat("north road begins")
      # the little goblin crosses the road ahead
      ev = $game_map.events.values.find { |e| e.name =~ /razzy_appears/ }
      HL.walk_to(ev.x, ev.y) if ev
      HL.settle(3000)
      beat("Razzy appears", :met_razzy)
      travel(2011)
      talk(/Frost-light/)
      beat("the Moon-Touched Egg", :razzy_egg)
      travel(2010)
      travel(2012)
      HL.frames(30); HL.settle(3000)
      beat("arrive in Bryn Shander", :bryn_arrived)
      # a loss to the inn's Zhentarim sends you back to Targos's Pokémon Center: walk back, as a player would
      until_flag(:lottery_stand) { travel(2012); travel(2016); talk(/Innkeeper|Scramsax/); travel(2012) }
      beat("lottery night: Alberica's stand", :lottery_stand)
      beat("Auril marks Alberica", :alberica_marked)
      beat("Sephek in Bryn Shander", :seen_sephek_bryn)
      fit(FrostThaw.herald? ? 28 : 24)
      until_flag(:badge_bryn) { travel(2015); clear_trainers; talk(/Duvessa/) }
      beat("Duvessa's badge", :badge_bryn)
      travel(2012); travel(2019); talk(/Mishann/); travel(2012)
      beat("the Morninglord's acorn", :golden_acorn)
      sweep("after two badges") if ENV["SWEEP"]
      fit(24)
      travel(2020)
      beat("Lonelywood road")
      travel(2021)
      HL.frames(30); HL.settle(3000)
      beat("arrive in Lonelywood", :lonelywood_arrived)
      talk(/Sephek at Torg/)          # Sephek at the sleds, on the spine (context 03 M3-2)
      beat("Sephek at Torg's", :met_sephek_torgs)
      travel(2027)
      talk(/Nimsy/)
      beat("rest in Nimsy's attic", :rested_lonelywood)
      beat("Shimmer is taken", :shimmer_taken)
      travel(2021)
      travel(2026)
      ev = $game_map.events.values.find { |e| e.name =~ /Glade aftermath/ && e.instance_variable_get(:@page)&.trigger == 1 }
      HL.walk_to(ev.x, ev.y) if ev
      HL.settle(3000)
      beat("the Glade: Heart of Ice", :heart_of_ice)
      travel(2021)
      fit(28)
      until_flag(:sephek_defeated) { travel(2023); HL.frames(60); HL.settle(5000) }
      beat("Sephek at the Moon Temple", :sephek_defeated)
      travel(2022)
      talk(/Zenith/)
      beat("the Moon Requiem", :requiem_done)
      beat("the Frost Egg (not hatched yet)", :frost_egg)
      talk(/Luna Carver/)
      beat("one, two, three: the Wennen follow", :wennen_follow)
      HL.frames(30); HL.settle(3000)  # (Zenith says it in the Warren; the Wennen's sledge takes you to Bryn Shander)
      beat("the laughing is the calling", :hag_named)
      sweep("end of Chapter 3") if ENV["SWEEP"]
      chapter4 unless ENV["STOP_AT"] == "3"
    end

    def chapter4
      fit(26)
      travel(2012)
      travel(2030); HL.frames(20); HL.settle(3000)
      beat("the Eastway", :eastway_started)
      travel(2031); HL.frames(20); HL.settle(3000)
      beat("Good Mead", :good_mead_arrived)
      travel(2032); talk(/Brewmistress/); travel(2031)
      travel(2035); HL.frames(20); HL.settle(3000)
      beat("arrive in Dougan's Hole", :dh_arrived)
      travel(2036); talk(/Durmoot/); travel(2035)
      beat("meet Speaker Durmoot", :met_durmoot)
      talk(/Koran/)
      beat("Koran, the good wolf", :met_wolves)
      fit(27)
      travel(2039); HL.frames(20); HL.settle(3000)
      talk(/Starving wolf/)
      beat("the starving pack", :fed_pack)
      travel(2040); HL.frames(20); HL.settle(3000)
      beat("Garagai's ice lodge", :lodge_entered)
      talk(/Whale oil/)
      beat("whale oil", :whale_oil)
      talk(/Holgi/)
      beat("the kobolds", :kobolds_freed)
      until_flag(:kids_freed) { talk(/Cage gate/) }
      beat("Norsu", :norsu_met)
      beat("Silja and Finn freed", :kids_freed)
      fit(31)
      until_flag(:wolves_beaten) do
        travel(2039); HL.walk_to(28, 15); HL.settle(3000)
        talk(/^Koran$/) if !FrostThaw.flag?(:wolves_beaten) && $game_map.map_id == 2039     # (a retry: they wait on the tundra)
      end
      travel(2035)
      beat("Koran and Kanan", :wolves_beaten)
      travel(2035) if $game_map.map_id != 2035
      HL.frames(30); HL.settle(3000)
      beat("the children come home", :kids_home)
      sweep("Dougan's Hole, before the badge") if ENV["SWEEP"]
      fit(30)
      until_flag(:badge_dougans) { travel(2036); talk(/Durmoot/) }
      beat("Durmoot's seal", :badge_dougans)
      travel(2038); talk(/Smoker/); HL.frames(30); HL.settle(3000)        # rest for the night (context 04 M4-5)
      beat("the night's rest at the smokehouse", :hag_night_ready)
      travel(2035) if $game_map.map_id != 2035; HL.frames(30); HL.settle(3000)
      talk(/The Hag/)
      beat("the hag at the Stones", :hag_parley)
      (1..3).each { |i| until_flag(:"hag_mirror_#{i}") { travel(2035); talk(/Ice mirror #{i}/) } }
      beat("her three mirrors", :hag_mirror_3)
      fit(31)
      until_flag(:hag_defeated) { travel(2035); talk(/The Hag/) }
      beat("the hag driven off", :hag_defeated)
      talk(/Shape on the ice/)
      sweep("end of Chapter 4") if ENV["SWEEP"]
      chapter5 unless ENV["STOP_AT"] == "4"
    end

    def chapter5
      fit(30)
      travel(2035)
      travel(2041); HL.frames(20); HL.settle(3000)
      beat("the Laughing Waste", :waste_started)
      travel(2042); HL.frames(20); HL.settle(3000)
      beat("into the Cackling Chasm", :chasm_entered)
      until_flag(:mephits_done) { travel(2042); HL.walk_to(16, 31); HL.settle(3000) }
      beat("the icefall and the ice mephits", :mephits_done)
      talk(/Something gleaming/)
      beat("the Order's Locket", :order_locket)
      fit(31)
      until_flag(:yeti_faced) { travel(2042); HL.walk_to(14, 19); HL.settle(3000) }
      beat("the mother yeti", :yeti_faced)
      talk(/Bone pile/); talk(/Backpack/); talk(/Dead yeti/)
      beat("Granny Thredra's name", :thredra_named)
      HL.walk_to(16, 10); HL.settle(3000)
      until_flag(:pit_done) { travel(2042) if ![2042, 2043].include?($game_map.map_id); HL.walk_to(5, 7) if $game_map.map_id == 2042; HL.frames(20); HL.settle(3000) }
      beat("the pit under the false light", :pit_done)
      talk(/Rope/) if $game_map.map_id == 2043
      travel(2044); HL.frames(20); HL.settle(3000)
      beat("the frozen rift", :rift_arrived)
      HL.walk_to(30, 22); HL.settle(3000)
      talk(/Campfire/)
      until_flag(:gate_open) { travel(2044); talk(/Guardian's Gate/) }
      beat("the Guardian's Gate", :gate_open)
      talk(/Hollow wall/); HL.frames(20); HL.settle(3000)
      talk(/Bier/)
      beat("the ghost's first beat (the Heart, the wolves, Reptin's choice)", :ghost_beat_one)
      talk(/Bier/)                     # take what she left on the bier (context 05 M5-8)
      beat("the last guardian of the Order", :ghost_blessing)
      travel(2044)
      fit(34)
      travel(2046); HL.frames(20); HL.settle(3000)
      until_flag(:reversal) { travel(2046); talk(/Thredra/) }
      beat("Granny Thredra and her mirrors", :thredra_beaten)
      beat("the Verdant Reversal", :reversal)
      beat("the twins hatch together", :frostina_hatched)
      beat("the yeti cub", :got_yeti_cub)
      beat("the fall: end of Act I", :act1_done)
      if ENV["POSTCHECK"]                     # after Act I: can you still walk back down to the Heart?
        ok = travel(2046)
        puts "POSTCHECK walk back to the Heart: #{ok ? 'ok' : 'FAILED'} (map #{$game_map.map_id} at #{$game_player.x},#{$game_player.y})"
        puts "POSTCHECK gate switch #{$game_switches[3930]} gate flag #{FrostThaw.flag?(:gate_open)}"
      end
      sweep("end of Act I") if ENV["SWEEP"]
      chapter6 unless ENV["STOP_AT"] == "5"
    end

    # Act II, Chapter 6: out of the lantern into Rootspire, the festival week, festival night.
    def chapter6
      if $game_map.map_id != 2050
        travel(2046); HL.frames(20); HL.settle(3000)
        talk(/Heart of the Chasm/)
      end
      HL.frames(30); HL.settle(3000)
      beat("out of the lantern into Rootspire", :rootspire_arrived)
      fit(36)
      travel(2053); talk(/Hellen/)
      beat("SC 6.02 the Rooted Hearth (you're in my wall)", :heard_wall_rule)
      talk(/Rumours/)
      travel(2050); HL.frames(30); HL.settle(5000)
      beat("SC 6.03 the twins land in the market", :twins_met)
      travel(2052); talk(/Tarin/)
      travel(2051); travel(2054); talk(/Kelyn/)
      beat("SC 6.04 the empty throne (the Wardens' oath)", :wardens_sworn)
      fit(39)
      until_flag(:badge_hearth) { travel(2059); talk(/Hellen Brightrun/) }
      beat("SC 6.06 GYM 4: Hellen Brightrun's Hearthstone Seal", :badge_hearth)
      fit(40)
      until_flag(:orb_visions) { lift_up if $game_map.map_id != 2061; talk(/Twin orb/) }
      beat("side: the orb's visions (Lumin)", :orb_visions)
      until_flag(:glimmer_joined) { lift_up if $game_map.map_id != 2061; talk(/Lumen Shard/) }
      beat("SC 6.08 Shade steps through the Celestial Rift and comes back as Glimmer", :glimmer_joined)
      puts "  party now: #{FrostThaw.companions.inspect}"
      travel(2063); talk(/Professor Wynsnow/)
      beat("SC 6.05 the College (Grafting licence)", :grafting_licence)
      rootspire_side unless ENV["NO_SIDE"]
      travel(2055); HL.frames(20); HL.settle(3000)
      beat("down to the Root-Tier", :root_tier_arrived)
      travel(2056); HL.frames(20); HL.settle(3000)
      until_flag(:rite_stopped) { travel(2056); talk(/Matron Eline/) }
      beat("SC 6.07 the Rite of Stillness (Summer has the heart)", :heart_given_summer)
      unless ENV["NO_SIDE"]
        talk(/Frost Saint runes/)
        beat("side: scour the Still Sky Shrine (Blessing of Warmth)", :blessing_warmth)
      end
      # The festival's last night is the seventh: the downtime week comes first
      # (one rest at the Hearth a night; a plain loop, so the team isn't levelled).
      10.times do
        break if FrostThaw.flag?(:festival_night)
        travel(2053); talk(/Hellen/); HL.frames(40); HL.settle(5000)
      end
      puts "  festival on night #{FrostThaw.rs_day}"
      beat("SC 6.09 festival night (the seventh night)", :festival_night)
      travel(2053); talk(/Hellen/); HL.frames(40); HL.settle(5000)
      beat("  the Rootwardens at the door", :rootwardens_at_door)
      travel(2050); talk(/Scorch marks/)
      beat("  the scorch marks at the Echo Gate (chardalyn)", :chardalyn_found)
      travel(2061) if $game_map.map_id != 2062; travel(2062); talk(/Eirwen/)
      beat("  Eirwen's audience, then the Council's summons (both roads open)", :ch7_started)
      beat("  Wyn joins", :wyn_joined) unless FrostThaw.herald?(:wyn)
      puts "  party now: #{FrostThaw.companions.inspect}"
      # (before Chapter 7: chapter7 plays on to the ending, and after Ch9 the
      # thinned Wall lets you through the Echo Gate)
      2.times do
        travel(2050)
        HL.walk_to(8, 22) rescue nil; HL.step(4) rescue nil; HL.frames(20)
        HL.settle(3000)
        mirror_maze if $game_map.map_id == 2161     # (A1: with Alerion along, the Gate opens on the maze)
      end
      beat("side: the Echo Gate's Mirror Wraiths (a Frostshard Sigil)", :echo_wraiths_down) unless ENV["NO_SIDE"]
      puts "ECHO GATE (the Wall holds until Ch9): #{$game_map.map_id == 2050 ? 'ok' : "FAILED (map #{$game_map.map_id} #{HL.pos})"}"
      sweep("Rootspire") if ENV["SWEEP"]
      chapter7 unless ENV["STOP_AT"] == "6"
    end

    # Act II, Chapter 7: the Heartroot's Root Gate and Sap Wells, and Selrae.
    def chapter7
      road_a
      road_b
      chapter8 if FrostThaw.flag?(:road_b_done) && FrostThaw.flag?(:road_a_done) && ENV["STOP_AT"] != "7"
    end

    # Act II, Chapter 8: the Rootsun Forge (SC 8.01-8.09).
    def chapter8
      HL.frames(30); HL.settle(3000)
      beat("SC 8.01 the Rootward Barricade", :barricade_entered)
      fit(48)
      clear_trainers
      talk(/Duergar ledger/)
      # Level 1's inner rooms (A2-A7)
      travel(2146); HL.frames(20); HL.settle(3000)
      beat("  A2 the Echo Hall", :inner_rooms_entered)
      talk(/Sap puddle/); clear_trainers
      talk(/Mural/); talk(/Open journal/); talk(/Loose floorboard/)
      beat("  A5 Avarice's quarters: the journal, and the Ledger's empty hollow (it's up the Council tower)", :ledger_trail)
      until_flag(:effigy_broken, 3) { travel(2146); talk(/Mirror-root effigy/) }
      beat("  A5 the mirror-root effigy", :effigy_broken)
      talk(/Sooty duergar/); talk(/Root-maps/)
      beat("  A6 the traitor: the Great Unchaining", :knows_great_unchaining)
      talk(/Sap-fed machinery/)
      travel(2072); talk(/Barricade gate/)
      beat("  the Rootgate open (#{FrostThaw.flag?(:traitor_lever) ? 'the traitor\'s lever' : 'the passphrase'})", :barricade_passed)
      travel(2073); talk(/Tea table/)
      beat("SC 8.02 mother's kitchen (#{FrostThaw.flag?(:took_hag_secret) ? 'took the secret' : 'broke the mirror'})", :hag_mirror_done)
      # Level 2 (A9-A18)
      travel(2147); HL.frames(20); HL.settle(3000)
      beat("  A9 the Deep Root Shaft", :deep_shaft_entered)
      talk(/Rib-roots/); talk(/Cracked mirror/); talk(/Workbench/); talk(/Scribbled notes/)
      beat("  A10/A11 the dragon limb, and a future self", :future_self_warned)
      fit(49)
      travel(2148); HL.frames(20); HL.settle(3000)
      until_flag(:golems_down, 3) { travel(2148); talk(/Thorn-bound dummy/) }
      beat("  A12 the training hall's sap golems", :golems_down)
      clear_trainers
      until_flag(:rootwatch_cleared, 3) { travel(2148); clear_trainers; talk(/Infernal Rootbreaker/) }
      beat("  A14 the Rootwatch and its Infernal Rootbreaker (the sap-lift runs)", :rootwatch_cleared)
      talk(/Heartroot of command/)
      beat("  A15 the sap-gate controls (once a winter altar)", :winter_altar_known)
      travel(2149); HL.frames(20); HL.settle(3000)
      until_flag(:umber_hulk_done, 3) { travel(2149); step_on(/Soft earth/) }
      beat("  A16 the Umbound Chasm", :umber_hulk_done)
      until_flag(:rust_feasters_done, 3) { travel(2149); talk(/Rust-feasters/) }
      beat("  A17 the rust-feast tunnels", :rust_feasters_done)
      clear_trainers
      travel(2074); HL.frames(20); HL.settle(3000)
      beat("SC 8.03 the cocoon pens", :pens_seen)
      talk(/Shelf/); talk(/Last cocoon/)
      beat("  Garagai's axe-head", :garagai_axe) if FrostThaw.flag?(:garagai_vow)
      beat("  Selrae cut free", :selrae_rescued) if FrostThaw.flag?(:selrae_ahead)
      talk(/Rootbeasts/); talk(/Prison pod 1/); talk(/Prison pod 1/); talk(/Prison pod 2/); talk(/Prison pod 3/)
      beat("  A27/A28 the rootbeast pens and the prison cocoons", :prisoners_freed)
      # Level 3 (A19-A25, A29, A30)
      fit(50)
      travel(2150); HL.frames(20); HL.settle(3000)
      beat("  Level 3: the womb of iron", :forge_womb_seen)
      until_flag(:quaggoth_down, 3) { travel(2150); talk(/Quaggoth/) }
      talk(/Tortured myconid/)
      beat("  A19 the Root-Throne: the quaggoth, and the myconid that begs to die", :myconid_spores_known)
      talk(/Hiding duergar/); talk(/Shelves of flasks/)
      beat("  A21 the heart-fuel", :frostfire_flask)
      until_flag(:rootbreaker_elevator, 3) { travel(2150); talk(/Infernal Rootbreaker/) }
      until_flag(:vantage_cleared, 3) do
        travel(2151); HL.frames(20); HL.settle(3000)
        talk(/Balcony rail/); clear_trainers; talk(/Bolt-slits/); talk(/Ritual circle/)
      end
      beat("  A24/A25 the vantage towers cleared", :vantage_cleared)
      beat("  A29 the mind-flayer corpse", :saw_mindflayer)
      until_flag(:rootkeep_gate_open, 3) { travel(2150); clear_trainers; talk(/Root-keep gate/) }
      beat("  A23 the root-keep gate", :rootkeep_gate_open)
      travel(2075); HL.frames(20); HL.settle(3000)
      HL.walk_to(16, 14) rescue nil; HL.frames(30); HL.settle(5000)
      beat("SC 8.04 Autumn falls", :autumn_fell)
      beat("SC 8.05 the Dragonforge", :forge_seen)
      fit(51)
      clear_trainers
      until_flag(:forge_reached) { travel(2075); talk(/Devil-priest/) }
      beat("  the devil-priest (A31)", :forge_reached)
      # Avarice's rooms (A32-A37) and Zone VI
      travel(2152); HL.frames(20); HL.settle(3000)
      talk(/Chanting duergar/); talk(/Flickering silhouette/); talk(/Bound captain/)
      until_flag(:mirror_hall_sprung, 2) { travel(2152); step_on(/Wrong reflections/) }
      beat("  A32 the mirror-hall trap (wrong reflections)", :mirror_hall_sprung)
      beat("  A34/A35 the tortured captain and Mother Thruuna's chamber", :thruuna_lore)
      until_flag(:mechs_down, 3) { travel(2152); talk(/Rootbound mech/) }
      talk(/Pedestal/)
      5.times { talk(/Vault relic/) }
      beat("  A37 Avarice's root-vault", :vault_looted)
      fit(52)
      travel(2153); HL.frames(20); HL.settle(3000)
      talk(/Ghost of the Shard/)
      beat("  H22 the ghost of the Shard", :shard_echo_heard)
      until_flag(:antechapel_cleared, 3) { travel(2153); talk(/Aurora-lit guardian/) }
      talk(/Shrine of two sigils/)
      until_flag(:hammer_heart_done, 2) { travel(2153); talk(/Hanging root-golem/) }
      beat("  H22/H33/H37 the Antechapel", :antechapel_cleared)
      fit(53)
      travel(2076); HL.frames(30); HL.settle(8000)
      until_flag(:circle_phase, 3) { travel(2076); HL.frames(30); HL.settle(8000) } if !FrostThaw.flag?(:circle_done)
      beat("  H32 the Thorn-Run Hall", :thorn_run_crossed)
      beat("SC 8.06 Summer (Avarice): her opening and her mechs", :heart_mechs_won)
      # H24: work the spires (the sixth action wakes her); then the fight itself
      (1..12).each { |n| break if FrostThaw.flag?(:circle_done); talk(/^Root-spire #{n}$/) }
      beat("  H24 the Breaking Circle (#{(FrostThaw.state[:circle_restored] || 0)} restored, #{(FrostThaw.state[:circle_broken] || 0)} broken)", :circle_done)
      until_flag(:engine_dead, 3) { travel(2076); HL.frames(30); HL.settle(8000) }
      beat("SC 8.06 Avarice", :engine_dead)
      beat("SC 8.07 a better fire (Glimmer is gone)", :glimmer_gone)
      beat("  H23 the Frost Saint Shard rises (#{FrostThaw.flag?(:shard_beaten) ? 'beaten' : 'outlasted'})", :shard_fought)
      beat("  H23 the Frost Saint Shard (#{%i[shard_purified shard_preserved shard_destroyed].find { |f| FrostThaw.flag?(f) }})", :heart_choice_made)
      beat("SC 8.08 the coat falls off (she burns)", :avarice_faked_death)
      beat("SC 8.09 launch", :dragon_launched)
      HL.frames(30); HL.settle(3000)
      beat("  H25 the Sloughing Veins", :veins_entered)
      travel(2155); HL.frames(20); HL.settle(3000)
      beat("  H26 the Echo Vault", :echo_vault_entered)
      until_flag(:echo_guardian_done, 2) { talk(/Drifting guardian/) }
      talk(/Seed-pods/); talk(/Chardalyn fragments/); talk(/The tree's whisper/)
      until_flag(:aurora_treasury_done, 2) { talk(/Auroral roots/) }
      beat("  H26/H36 the tree's prophecy and the Aurora Treasury", :tree_prophecy)
      beat("  H26 the Mirror Lens and the charm (tailored relics)", :mirror_lens)
      beat("  the personal-quest visions", :personal_visions)
      talk(/Root-stair up/); HL.frames(30); HL.settle(3000)
      puts "  party now: #{FrostThaw.companions.inspect}; on map #{$game_map.map_id}"
      chapter9 if FrostThaw.flag?(:dragon_launched) && ENV["STOP_AT"] != "8"
    end

    # Act II, Chapter 9: Destruction's Light (SC 9.01-9.07).
    def chapter9
      HL.frames(30); HL.settle(5000)
      beat("SC 9.01 the leaves fall", :summer_ended)
      fit(54)
      lift_up; talk(/^Frostina$/); HL.frames(30); HL.settle(8000)
      beat("SC 9.02 mount up (#{FrostThaw.flag?(:rides_frostina) ? 'Frostina' : 'Razzilith'})", :mounted_up)
      beat("SC 9.03 through the Wall (air battle: seams)", :air_seams)
      talk(/Mead hall door/)
      beat("  Good Mead's bees", :good_mead_saved)
      fit(56)
      talk(/Your dragon/); HL.frames(30); HL.settle(8000)
      beat("SC 9.04 malevolent presence (air battle: pursuit)", :air_pursuit)
      beat("SC 9.05 the trap (the chardalyn dragon, #{FrostThaw.state[:seams] || 0} seams cracked)", :dragon_down)
      beat("SC 9.06 the green light on the horizon", :refugees_follow)
      HL.frames(30); HL.settle(5000)
      beat("SC 9.07 slayers of summer", :heralds_arrested)
      chapter10 if FrostThaw.flag?(:heralds_arrested) && ENV["STOP_AT"] != "9"
    end

    # Act II, Chapter 10: Trials of the Roots (SC 10.01-10.09).
    def chapter10
      HL.frames(30); HL.settle(5000)
      beat("SC 10.01 the Tribunal opens", :trials_open)
      fit(56)
      travel(2050); HL.frames(30); HL.settle(5000)
      beat("  the town criers; a carpenter wants arms on the wall", :criers_heard)
      # the civic layer: a day on the wall, the camp's blankets, the wolves
      travel(2060)
      talk(/Wall foreman/)
      talk(/Refugee camp/)
      talk(/Captain Rheven \(wall\)/)
      rest_a_day
      travel(2060); talk(/Wall foreman/)
      until_flag(:wolves_driven_off, 2) { travel(2060); talk(/Winter wolves/) }
      beat("  the wall, the camp and the winter wolves (#{FrostThaw.trial[:helped]} days' help)", :wolves_driven_off)
      talk(/Refugee from Easthaven/); talk(/Refugee from Termalaine/)
      beat("  the refugees will testify", :refugees_testify)
      # Q1: Reptin and Anduin; the Heartroot's Test on the Attunement Way
      travel(2050); talk(/^Anduin$/); HL.settle(3000)
      if $game_map.map_id == 2165
        step_on(/The passages split/); step_on(/The spore-drift/); step_on(/The whispering roots/)
        talk(/The golden leaf/); HL.settle(3000)
      end
      beat("SC 10.02 roots of love: the Heartroot's Test (#{FrostThaw.flag?(:anduin_reconciled) ? 'reconciled' : 'doubtful'})", :attunement_done)
      travel(2056); talk(/Eirwen at the shrine/)
      beat("  Eirwen: witness to restraint, and Naerth's last ledger", :naerth_ledger)
      # Q2: Meat Meat, Phildendrin, Autumn's mirror
      travel(2054); talk(/Root-cells/)
      beat("SC 10.03 assassin's reckoning (Phildendrin)", :phildendrin_found)
      until_flag(:mm_atoned, 3) { travel(2058); talk(/Autumn's mirror/) }
      beat("  Autumn's spying mirror broken", :mm_atoned)
      # Q3: Wyn's summons, the hearing, the Underdark Door, Pell, Hyphora's alibi
      travel(2050); talk(/^Sorrel$/)
      beat("  Sorrel's citation", :wyn_summoned)
      travel(2054); talk(/Kethan Vale \(hearing\)/); HL.settle(3000)
      if $game_map.map_id == 2077
        HL.frames(20); HL.settle(3000)
        fit(58)
        step_on(/Ambush pool/); step_on(/Ambush weeds/); step_on(/Ambush stalker/)
        talk(/Broken door/)
      end
      beat("  the Underdark Door (the ritual runes)", :underdark_door_seen)
      travel(2055); talk(/^Ivo$/)
      travel(2054); talk(/Kethan Vale \(hearing\)/)
      beat("SC 10.04 absent watcher (Wyn #{FrostThaw.flag?(:wyn_barred) ? 'sentenced' : 'cleared'})", :wyn_cleared)
      # Q4: Talion in the Fields
      travel(2060); 3.times { talk(/^Talion$/) unless FrostThaw.talion_resolved? }
      beat("SC 10.05 brother from beyond (#{%i[talion_released talion_restored talion_chased talion_haunted].find { |f| FrostThaw.flag?(f) }})", :talion_met)
      # Q5: Alberica's spores
      travel(2054); talk(/Spring and Winter/)
      travel(2068); talk(/Kelyn and Selrae/)
      beat("SC 10.06 spores of contention (#{FrostThaw.flag?(:colony_recognised) ? 'recognised' : 'exiled'})", :spores_debated)
      trial_week_side unless ENV["NO_SIDE"]
      # Gym 8: Selrae's bid, and the crystals' dream
      fit(58)
      until_flag(:badge_selrae) do
        travel(2054); talk(/Selrae Vorn/); HL.settle(3000)
        if $game_map.map_id == 2166
          %w[Spring Summer Autumn Winter].each { |s| talk(/^#{s}$/) }
          HL.settle(5000)
        end
      end
      beat("SC 10.07 GYM 8: the Four Seasons (#{%i[canopy_free canopy_watched canopy_martial_law].find { |f| FrostThaw.flag?(f) }})", :badge_selrae)
      puts "  witnesses: #{FrostThaw.witnesses.size} (summer #{FrostThaw.witnesses(:summer).size}, autumn #{FrostThaw.witnesses(:autumn).size}); opinion #{FrostThaw.opinion_word}"
      travel(2054); talk(/^Kelyn/)
      beat("SC 10.08 the verdict (#{%i[verdict_acquitted verdict_service verdict_fine verdict_geas].find { |f| FrostThaw.flag?(f) }}; Meat Meat #{%i[mm_commuted mm_outlaw].find { |f| FrostThaw.flag?(f) } || 'serves'})", :verdict_heard)
      beat("SC 10.09 the vote: end of Act II (#{%i[rheven mira eirwen phildendrin anduin].select { |k| FrostThaw.flag?(:"council_#{k}") }.join(', ')})", :ch10_done)
      chapter11 if FrostThaw.respond_to?(:act3_start) && FrostThaw.flag?(:ch10_done) && ENV["STOP_AT"] != "10"
    end

    # A night at the Rooted Hearth: the trial week's next day.
    def rest_a_day
      travel(2053); talk(/Hellen/); HL.settle(3000)
    end

    # A1 in the Mirror Maze: three junctions (three successes before two
    # failures; a lost round folds the maze up), then the pane; a failed
    # meditation sends you back through the junctions.
    def mirror_maze
      HL.frames(20); HL.settle(3000)
      4.times do
        break if FrostThaw.flag?(:reflection_claimed)
        [/Junction: wraiths/, /Junction: three ways/, /Junction: the shadow/].each { |j| talk(j) }
        talk(/Alerion's reflection/)
        ($Trainer.heal_party rescue nil)
      end
      6.times { talk(/The ring of wraiths/) unless FrostThaw.flag?(:sigil_echo) || (FrostThaw.flag?(:echo_wraiths_down) && FrostThaw.flag?(:wraith_echo_avarice)) }
      travel(2050)
    end

    # The trial week's side stories (rootspire.md Tab 4 and Tab 6).
    def trial_week_side
      # the Mirror Maze, behind the Echo Gate's frost (A1; the wraiths' testimony; the Echo sigil)
      travel(2050); talk(/Echo Gate frost/); HL.settle(3000)
      mirror_maze if $game_map.map_id == 2161
      beat("side: the Mirror Maze (Alerion's reflection; the wraiths' testimony)", :reflection_claimed)
      beat("  the Echo sigil (from the maze, or the Echo Gate's wraiths)", nil) if FrostThaw.flag?(:sigil_echo) || FrostThaw.flag?(:echo_wraiths_down)
      # Q6: the break-in at Summer's quarters, atop the Council tower (the Ledger of Corruption)
      travel(2054)
      if (st = find_event(/Tower stair/))
        HL.walk_to(st.x, st.y + 1); HL.step(8); HL.settle(3000); HL.frames(20); HL.settle(3000)
        if $game_map.map_id == 2173
          HL.walk_to(9, 9); HL.step(8); HL.settle(2000)
          talk(/Bone-and-ice construct/); talk(/Loose floorboard/)
          travel(2054)
        end
      end
      beat("side Q6: Summer's quarters atop the Council tower (the Ledger of Corruption)", :ledger_found)
      # W1: the Smuggler's Run
      travel(2055); talk(/Dockworker/); travel(2198); talk(/Spore-choked crack/); HL.settle(3000)
      if $game_map.map_id == 2160
        HL.frames(20); HL.settle(3000)
        step_on(/Spore fork 1/); step_on(/Spore fork 2/); step_on(/Spore fork 3/)
        talk(/The eyed colony/)
      end
      beat("side W1: shadows in the Undercity (#{FrostThaw.flag?(:undercity_bargain) ? 'a bargain' : 'burned'})", :undercity_done)
      # the Library's missing leaf; out through the thinned Wall to the Glasswater
      lift_up; travel(2062); talk(/Chronal shelf/); talk(/The oldest shelf/)
      beat("side B2: the stolen leaf (Eirwen's request)", :leaf_quest)
      travel(2061); lift_down
      travel(2060); talk(/Two spirits/)
      beat("side R2: the Fields' two spirits", :field_spirits_done)
      travel(2078); talk(/The lake's edge/)
      beat("side W2: the Mirror Lake ghost", :lake_ghost_done)
      fit(60)
      talk(/^Old boat$/); HL.settle(3000)
      if $game_map.map_id == 2163
        HL.frames(20); HL.settle(3000)
        step_on(/Frozen time 1/)
        talk(/Frozen Rootwarden/)
        step_on(/Frozen time 2/)
        talk(/Mead hall door/); HL.settle(3000)
        talk(/Temporal Guardian/) if $game_map.map_id == 2164
        travel(2163)
        beat("side GQ4: beyond the Wall (the third map fragment)", :vault_map_3)
        ev = find_event(/The Wall, closing/)
        HL.walk_to(ev.x + 1, ev.y) if ev; HL.step(4) if ev; HL.settle(3000)
      end
      beat("side B2: the chronal leaf, from the frozen warden", :rootwarden_freed)
      lift_up; travel(2062); talk(/Chronal shelf/)
      beat("  the leaf restored", :leaf_restored)
      travel(2061); lift_down
    end

    # Act III, Chapter 11: The Frost Saint Walks (SC 11.01-11.04).
    def chapter11
      HL.frames(30); HL.settle(8000)
      beat("SC 11.01 the wheel and the ones who bind it", :auril_whisper)
      fit(60)
      HL.frames(30); HL.settle(8000)
      beat("SC 11.02 the Frost Saint walks (Frostina taken)", :frostina_taken)
      beat("  Sephek's Minor Avatar (a Frostshard Sigil falls)", :sigil_sephek)
      beat("SC 11.03 three hearts (Auril's relics)", :knows_rewritten)
      travel(2054); HL.frames(30); HL.settle(5000)
      beat("SC 11.04 four chairs (route: #{FrostThaw.voyage_route})", :ch11_done)
      beat("  Eirwen's sigil; the three sigils merge", :sigils_merged)
      act3_side unless ENV["NO_SIDE"]
      chapter12
    end

    # Before sailing: Auril's relics in the Heartroot, and the White Vault.
    def act3_side
      fit(64)
      until_flag(:relic_seal, 2) { travel(2057); talk(/Auril's relic \(seal\)/) }
      until_flag(:relic_wells, 2) { travel(2058); talk(/Auril's relic \(relic_wells\)/) }
      until_flag(:relic_overflow, 2) do
        travel(2067)
        slide_to_event(/Auril's relic \(relic_overflow\)/) || talk(/Auril's relic \(relic_overflow\)/)
      end
      beat("side: Auril's three relics smashed (no Divine Rejuvenation)", :auril_relics_destroyed)
      return if !FrostThaw.flag?(:sigils_merged)
      travel(2078); talk(/^Old boat$/); HL.settle(3000)
      travel(2163); travel(2168); HL.frames(20); HL.settle(3000)
      beat("side: the White Vault", :vault_entered)
      until_flag(:vault_door_open, 2) { travel(2168); talk(/Door of wings/) }
      travel(2169); HL.frames(20); HL.settle(3000)
      %w[west east north].each { |k| until_flag(:"circuit_#{k}", 2) { travel(2169); talk(/Circuit #{k}/) } }
      fit(66)
      until_flag(:avarice_body_broken, 3) { travel(2170); talk(/Avarice's cradle/) }
      beat("side: Avarice Reforged, in the Seraph Cradle (#{FrostThaw.flag?(:avarice_soul_shattered) ? 'shattered' : 'fled north'})", :avarice_revealed)
      travel(2163); ev = find_event(/The Wall, closing/)
      if ev then HL.walk_to(ev.x + 1, ev.y); HL.step(4); HL.settle(3000) end
      travel(2050)
    end

    # Act III, Chapter 12: The Sea of Moving Ice (SC 12.01-12.06).
    def chapter12
      fit(62)
      case FrostThaw.voyage_route
      when :ship then travel(2055); talk(/Boreal Requiem/)
      when :griffons then lift_up; talk(/Griffon roost/)
      else travel(2055); talk(/Wennen bell/)
      end
      HL.frames(30); HL.settle(5000)
      beat("SC 12.01 one more battle (Tamsin)", :rival_final)
      beat("SC 12.02 fog and masts", :solstice_sighted)
      talk(/Your camp/)        # (rest at the camp: blackouts on Solstice come back here)
      until_flag(:dock_cleared, 3) { travel(2079); talk(/^Sopo$/) }
      beat("SC 12.03 Sopo", :dock_cleared)
      travel(2080); HL.frames(20); HL.settle(3000)
      beat("SC 12.04 the Statue Fields", :statue_fields_entered)
      # (the slide is checked by its builder; the test stands at the top)
      $game_player.moveto(19, 12); HL.settle(1000); talk(/^Shimmer$/)
      beat("  Shimmer, in ice", :fields_crossed)
      $game_player.moveto(17, 12); HL.settle(1000); HL.step(8); HL.frames(20); HL.settle(3000)
      beat("SC 12.05 the Garden of Death", :garden_entered)
      until_flag(:troll_down, 3) { travel(2081); talk(/Ice troll/) }
      talk(/^Nass$/)
      travel(2082); talk(/^Ukuma$/)
      talk(/The skull's jaw/); HL.frames(20); HL.settle(3000)
      beat("SC 12.06 the crowned skull", :grimskalle_entered)
      chapter13
    end

    # Act III, Chapter 13: Grimskalle, and the ending (SC 13.01-13.10, 14.01).
    def chapter13
      HL.frames(20); HL.settle(3000)
      beat("SC 13.01 the Hall of the Four Winds", :hall_entered)
      fit(66)
      %w[cruelty endurance isolation preservation].each do |k|
        travel(2083)
        talk(/Door of #{k}/)
        HL.frames(30); HL.settle(8000)
        beat("SC 13.0#{%w[cruelty endurance isolation preservation].index(k) + 2} the Test of #{k.capitalize} (#{FrostThaw.flag?(:"test_#{k}_broken") ? 'broken' : 'held'})", :"test_#{k}_faced")
      end
      travel(2088); HL.frames(20); HL.settle(3000)
      talk(/^Iskra$/)
      beat("SC 13.06 the roe's nest", :iskra_passed)
      until_flag(:frostina_freed, 3) { travel(2088); talk(/^Sephek$/) }
      beat("SC 13.07 the Frost Saint (#{FrostThaw.flag?(:sephek_turned) ? 'turned' : 'beaten'})", :frostina_freed)
      fit(70)
      until_flag(:auril_down, 3) { travel(2089); HL.frames(30); HL.settle(10000) }
      beat("SC 13.08-13.09 the Frostmaiden and the Rewritten Auril", :auril_down)
      beat("  Avarice's last splinter, at the throne", :avarice_ended)
      beat("SC 13.10 an ending (#{%i[ending_shatter ending_third_way ending_still_keeper].find { |f| FrostThaw.flag?(f) }})", :game_complete)
    end

    # Act II, Chapter 7, Road B: the Forge Road (SC 7B.01-7B.08).
    def road_b
      travel(2050); talk(/Hew Talmire/); HL.frames(30); HL.settle(3000)
      beat("SC 7B.01 down Hew's ladder into the Guild Dig", :guild_dig_entered)
      fit(44)
      talk(/Digger Gant/); talk(/Digger Hobb/)
      fit(46)
      until_flag(:cache_1_safe, 3) { travel(2066); talk(/Sap cache 1/) }
      until_flag(:cache_2_safe, 3) { travel(2066); talk(/Sap cache 2/) }
      beat("  the sap caches saved", :cache_2_safe)
      talk(/Prototype 3/)
      fit(46)
      clear_trainers
      until_flag(:badge_hew) { travel(2066); talk(/Hew Talmire/) }
      beat("SC 7B.02 GYM 5: Hew's Guild Seal (v#{FrostThaw.scaled_version rescue '?'})", :hew_confessed)
      travel(2066); talk(/Door of iron and glass/)
      beat("  the door at the bottom of Hew's ladder is locked (no key yet)", nil)
      travel(2050); talk(/Root-Gate/); HL.frames(30); HL.settle(3000)
      beat("down into the Heartroot", :heartroot_entered)
      # A wild battle between runes can knock the team out and send them up to
      # the Hearth: go back down and carry on from the rune you were on (the
      # game keeps state[:rune_seq]), the way a player would.
      until_flag(:seal_open, 4) do
        (fit(50); travel(2050); talk(/Root-Gate/); HL.frames(30); HL.settle(3000)) if $game_map.map_id != 2057
        talk(/Seal circle/) if !FrostThaw.flag?(:seal_circle_read) rescue nil
        FrostThaw.rune_answer.each do |season|
          break if FrostThaw.flag?(:seal_open)
          next if (FrostThaw.state[:rune_seq] || []).include?(season)
          (travel(2050); talk(/Root-Gate/); HL.frames(30); HL.settle(3000)) if $game_map.map_id != 2057
          talk(/Rune of #{season.to_s.capitalize}/)
        end
      end
      beat("SC 7B.05 the aurora seal", :seal_open)
      # H35 sits on the Root Gate's lower landing, past the thralls and Captain Hesk.
      until_flag(:labyrinth_mapped, 3) do
        (travel(2050); talk(/Root-Gate/); HL.frames(30); HL.settle(3000)) if $game_map.map_id != 2057
        clear_trainers; talk(/Captain's root-desk/)
      end
      beat("H35 the Captain's Alcove", :labyrinth_mapped)
      travel(2058); HL.frames(20); HL.settle(3000)
      talk(/Sap well 1/); talk(/Sap well 2/); talk(/Sap well 3/)
      beat("SC 7B.06 three wells", :wells_seen)
      talk(/Whispering attendant/)
      travel(2058); talk(/Selrae Vorn/)
      beat("SC 7B.07 Selrae, below (the Root-Key)", :root_key)
      # M2 is Meat Meat's: take the boy's mirror off him in the Bazaar first.
      if !($PokemonBag.pbHasItem?(:FT_BOYSMIRROR) rescue false) && !FrostThaw.flag?(:mirror_child_free)
        until_flag(:boy_mirror_taken, 3) { travel(2050); talk(/Boy with a mirror/) }
        beat("  M2: Meat Meat takes the boy's mirror", :boy_mirror_taken)
      end
      travel(2067); HL.frames(20); HL.settle(3000)
      # (the slide puzzle is checked by its builder; the test walks onto the mirror's ledge)
      $game_player.moveto(8, 24); HL.settle(1000)
      fit(46)
      until_flag(:mirror_child_free, 3) { talk(/Twin mirror/) }
      beat("SC 7B.03 the child in the mirror", :mirror_child_free)
      $game_player.moveto(3, 3); HL.settle(1000)
      fit(47)
      until_flag(:badge_mira) { travel(2055); talk(/Boreal Requiem/) }
      beat("SC 7B.04 GYM 6: Mira's Tide Seal (v#{FrostThaw.scaled_version rescue '?'})", :mira_freed)
      deep_labyrinth
      travel(2066); talk(/Door of iron and glass/)
      beat("SC 7B.08 the door of iron and glass (road B done)", :road_b_done)
    end

    # The Heartroot Labyrinth's lower zones (046_DeepLabyrinth.rb): through the
    # heart-wall under the Sap Wells, down to the Scriptory's glass sigil, and the
    # Root-Lift back to the forge door.
    def deep_labyrinth
      travel(2058); talk(/Knotted heart-wall/); HL.frames(30); HL.settle(3000)
      beat("the heart-wall opens (the Root-Key)", :heartwall_open)
      fit(47)
      beat("H9 the Mirror Garden", :mirror_garden_entered)
      talk(/Mirror-flower/); talk(/Mirror-petal/)
      until_flag(:ring_done, 3) { travel(2140); talk(/Petal-gate/) }
      beat("H10 the Reflection Ring (#{FrostThaw.flag?(:mirror_clones_beaten) ? 'the Mirror Clones' : 'crossed without looking'})", :ring_done)
      talk(/Glass-roots/)
      beat("H11 the Shattered Bed: the Mirror Shard Focus", :shard_focus_found)
      talk(/Moss bed/)
      beat("H12 the Perfume Grotto", :grotto_boon)
      travel(2141); HL.frames(20); HL.settle(3000)
      beat("H13 the Hollow Core", :hollow_core_entered)
      clear_trainers
      until_flag(:crossways_construct, 3) { travel(2141); talk(/Root-construct/) }
      talk(/Cocoon 1/); talk(/Cocoon 2/); talk(/Cocoon 3/); talk(/Pale sovereign/)
      beat("H14/H15 the crossways and the Cocoon Gallery", :core_warned)
      travel(2142); HL.frames(20); HL.settle(3000)
      beat("H16 the Frozen Drop", :frozen_drop_entered)
      clear_trainers
      talk(/The Underdark Mouth/); talk(/Root-drakes/)
      until_flag(:barracks_done, 3) { travel(2142); talk(/Sleeping sap-soldiers/) }
      beat("H17/H34/H27 the Underdark Mouth, the nursery, the Root-Kin Barracks", :barracks_done)
      fit(48)
      travel(2143); HL.frames(20); HL.settle(3000)
      beat("H18 the Vault of Amber Dreams", :amber_vault_entered)
      until_flag(:amber_sentries_down, 3) { travel(2143); talk(/Amber pod$/) }
      talk(/Lab notes/)
      until_flag(:core_destroyed, 3) { travel(2143); talk(/Amber pod 4/) }
      beat("H19 the Stasis Gallery: the Homunculus Core and the lab notes", :core_destroyed)
      talk(/Cataloguing construct/); talk(/Root-table/); talk(/Sealed crates/)
      beat("H20 the Dissectory Annex (Autumn's crates)", :autumn_labs_seen)
      until_flag(:dissectory_golem, 2) { travel(2143); talk(/Hammer-arm construct/) }
      until_flag(:torturer_down, 2) { travel(2143); talk(/Torturer construct/) }
      talk(/Pain-pod 1/); talk(/Pain-pod 2/)
      beat("H28 the Suffering Pods", :pain_pods_freed)
      travel(2145); HL.frames(20); HL.settle(3000)
      until_flag(:mirror_wards_down, 3) { travel(2145); talk(/Floating shards/) }
      talk(/Broken ice mask/)
      until_flag(:var_story_known, 3) { travel(2145); talk(/The liquid mirror/) }
      beat("H3 the Mirror-Root Vault: Ithryn Athis, and Var's echo", :var_story_known)
      travel(2144); HL.frames(20); HL.settle(3000)
      clear_trainers
      until_flag(:scriptory_read, 3) { travel(2144); talk(/Script pool/) }
      talk(/Chardalyn pages/); talk(/Sealed crystal/)
      beat("H21 the Mirror Scriptory: the glass sigil", :glass_sigil)
      talk(/Seed-pod nest/); talk(/Black-glass bloom/)
      beat("H29/H31 the guest nests and the Devil's Bloom", :bloom_done)
      until_flag(:lift_node_run, 3) { travel(2144); talk(/Root-lift cage/) }
      beat("H30 the Root-Lift Node, down to the forge door", :lift_node_run)
    end

    # Act II side paths out of Rootspire (each one tied to a reward).
    def lift_up
      travel(2050); talk(/Lift-keeper/); HL.settle(3000)
    end

    def lift_down
      ev = find_event(/Root-lift down/) or return
      HL.walk_to(ev.x, ev.y - 1); HL.step(2); HL.settle(3000)
    end

    def rootspire_side
      fit(40)
      travel(2050)
      talk(/Tamsin/)
      beat("side: Tamsin's rematch (best of three)", :beat_tamsin)
      $Trainer.money = [$Trainer.money, 20000].max
      talk(/^Pip$/)
      beat("side: Pip sews in a bigger bag", nil)
      puts "  bag limit now #{FrostThaw.state[:bag_limit]}"
      talk(/Lirielle/); talk(/Reva/); talk(/Nivva/)
      talk(/Captain Rheven/)
      beat("side: Rheven unseals the Rootwarden Crypt", :crypt_open)
      lift_up
      talk(/Cornipus/); talk(/Aarakocra/)
      beat("side: a Feycorn's Seed of Renewal", :met_cornipus)
      until_flag(:lecture_done) { travel(2063); talk(/Professor Wynsnow/) }
      beat("side: the Lecture in Blue Fire (Lucky Egg)", :lecture_done)
      travel(2061); travel(2062); talk(/Eirwen/); talk(/Lorn Scribe/); talk(/Sub-vault/)
      beat("side: Alberica's sub-vault (the Key)", :key_found)
      talk(/Eirwen/)
      beat("side: the Canticle's lost verses (Eirwen's crystal leaves)", :canticle_researched)
      travel(2061); lift_down
      travel(2054); talk(/Living pillar/)
      beat("side: the Cycle Canticle (Whisper Key, Verse XI)", :canticle_learned)
      talk(/Statue statue_meat_meat/)
      travel(2060)
      beat("out to the Blooming Fields", nil) if $game_map.map_id == 2060
      %i[faith hope love balance].each { |k| fit(40); until_flag(:"still_#{k}", 2) { travel(2060); talk(/Still One #{k}/) } }
      fit(40)
      beat("side: the Still Ones finish (Blessing of Still Sky)", :blessing_still_sky)
      talk(/Frozen hunter/)
      unless FrostThaw.flag?(:mantle_found)
        # (the game's AI can't throw Poké Balls; stand in for a successful catch)
        Object.send(:alias_method, :hl_orig_pbWildBattleCore, :pbWildBattleCore) unless Object.private_method_defined?(:hl_orig_pbWildBattleCore)
        Object.send(:define_method, :pbWildBattleCore) { |*a| a.first.respond_to?(:name) && a.first.name == "Rime Stalker" ? 4 : hl_orig_pbWildBattleCore(*a) }
        talk(/Frozen hunter/)
      end
      beat("side: the Boundary Hunt (Rime Mantle)", :mantle_found)
      travel(2055)
      talk(/Driftwood chest/)
      beat("side: Meat Meat's driftwood chest (Verdant Blade)", :blade_found)
      until_flag(:staff_found) { travel(2065); talk(/The first Warden/) }
      beat("side: the Rootwarden Crypt (the unbonded staff)", :staff_found)
      travel(2060); talk(/Sign auroral_wall/)
      beat("side: the staff bonded at the Auroral Wall (Heartwarden's Staff)", :staff_attuned)
    end

    # Act II, Chapter 7, Road A: the Heartroot through the myconids (SC 7A.01-7A.07).
    def road_a
      travel(2055); talk(/Sap Gate/)
      unless FrostThaw.flag?(:sap_gate_open)        # (a gate you walk into: bump it)
        HL.walk_to(9, 21); HL.step(4); HL.settle(3000)
      end
      travel(2068); HL.frames(20); HL.settle(3000)
      beat("SC 7A.01 declare your purpose (Eira at the Sap Gate)", :undercanopy_entered)
      talk(/Eira/); talk(/The Blight/)
      beat("SC 7A.02 Yarro's blight", :blight_cleared)
      unless ENV["NO_SIDE"]
        talk(/Lysella/); talk(/Korun/)
        until_flag(:spy_unmasked) { travel(2068); talk(/Masked trader/) }
        beat("side: unmask the Halo spy (Sporechime)", :spy_unmasked)
      end
      fit(44)
      until_flag(:badge_undercanopy) { travel(2068); talk(/Sovereign Luminara/) }
      beat("SC 7A.03 GYM 7: Sovereign Luminara's Rapport Seal (v#{FrostThaw.scaled_version rescue '?'})", :badge_undercanopy)
      until_flag(:hyphora_named, 3) { travel(2068); talk(/Mnemosyne Myr/) }
      beat("SC 7A.04 the thread that binds (Hyphora named)", :hyphora_named)
      travel(2069); HL.frames(20); HL.settle(3000)
      beat("SC 7A.05 the lake remembers", :lake_entered)
      fit(46)
      until_flag(:lake_cleansed) { travel(2069); talk(/Lake-wyrm/) }
      beat("  the lake cleansed (Hyphora's Blessing, the Seed of Balanus)", :lake_cleansed)
      travel(2070); HL.frames(20); HL.settle(3000)
      %w[mask fist hourglass paw shadow].each { |k| talk(/Carving #{k}/) }
      beat("SC 7A.06 the door of the Five Domains", :domains_open)
      fit(48)
      until_flag(:mycolith_down) { travel(2070); talk(/Shadow Mycolith/) }
      beat("  the Shadow Mycolith (the godspark settles on Wyn)", :godspark_shadow)
      travel(2071); HL.frames(20); HL.settle(3000)
      beat("SC 7A.07 Hyphora's leave (road A done)", :road_a_done)
      unless ENV["NO_SIDE"]
        lift_up; talk(/Cornipus/)
        beat("side: Cornipus knows the Seed of Balanus", :balanus_explained)
      end
    end

    def heartroot_side
      travel(2057)
      fit(42)
      clear_trainers
      travel(2066); HL.frames(20); HL.settle(3000)
      talk(/Digger Gant/); fit(42); talk(/Digger Hobb/); fit(42)
      until_flag(:cache_1_safe, 3) { travel(2066); talk(/Sap cache 1/) }; fit(42)
      until_flag(:cache_2_safe, 3) { travel(2066); talk(/Sap cache 2/) }
      beat("side: the Guild dig (diggers rescued, caches saved)", :cache_2_safe)
      talk(/Prototype 3/)
      talk(/Ladder shaft/); HL.settle(3000)
      beat("up the Guild's ladder to the market", nil) if $game_map.map_id == 2050
      talk(/Hew Talmire/)
      beat("side: Hew's thanks", :hew_thanked)
    end
  end
end

# (Run directly to play the story; required by a focused test, only Story is loaded.)
if __FILE__ == $0 || ENV["STAGE_TRACE"]
  HL.start_up
  $after_start_up&.call
  HL.quiet = !ENV["HL_VERBOSE"]
  mode = ENV["HL_MODE"] || "journey"
  HL.answers = [[/Which adventure/, 1], [/How would you like to play/, mode == "journey" ? 0 : 1],
                [/Choose a difficulty/, 1], [/Another round/, 1], [/Spar with/, 1], [/How much are you putting down/, 3],
                [/rest your Pokémon/, 0], [/What do you say/, 1], [/save your game/, 1],
                [/scythe and child/, /Bone dust|silence/],
                [/And which one, for loss/, 1], [/(sings|You sing)\.\.\.$/, ->(t, c) { c.first.to_s =~ /Stand still/ ? 1 : 0 }],
                [/Weapon, or seed/, 0], [/What do you do about Selrae/, 0], [/Swear the Wardens/, 0], [/endorse first|And second/, 0], [/What do we do with a god/, 1], [/Iskra lowers/, 0],
                [/^Talion\.\.\./, ->(t, c) { c.index { |x| x.to_s =~ /Decide what to do|Accept he's a reflection/ } || 0 }],
                [/Escape\?/, 0], [/Who speaks for the Heralds/, 0], [/Help with\.\.\./, 0], [/^Sephek\.\.\./, ->(t, c) { c.index { |x| x.to_s =~ /Rose/ } || c.index { |x| x.to_s =~ /Alerion/ } || 0 }]]
  HL.answers << [/Which Pokémon/, ENV["HL_STARTER"].to_i] if ENV["HL_STARTER"]
  HL.answers << [/Which Herald|Who will you be|Which of the Heralds/, ->(t, c) { c.index { |x| x.to_s =~ /#{ENV['HL_HERALD']}/i } || 0 }] if ENV["HL_HERALD"]
  HL.new_game
  HL.frames(200)
  $PokemonGlobal.repel = 999999 if ENV["REPEL"]
  t = Time.now
  begin
    $headless_watchdog = Graphics.frame_count + 2_000_000
    Story.run
  rescue HeadlessStuck => e
    HL.problem("STUCK: #{e.backtrace.reject { |l| l =~ /internal/ }.first(6).join(' <- ')}")
  end
  puts "\n#{Story.beats.count { |_l, ok| ok }}/#{Story.beats.size} story beats in #{(Time.now - t).round}s (#{Story.instance_variable_get(:@retries) || 0} retries after lost battles)"
  puts "problems:"; puts HL.problems.uniq
  File.write(ENV["HL_OUT"] || "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/story.txt", HL.log.map { |l| l.dup.force_encoding("UTF-8") }.join("\n"))
end
