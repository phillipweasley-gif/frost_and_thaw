# Fights every Frost & Thaw trainer with a "fair" team (your starter plus one
# catch, both at the trainer's highest level) where they stand, with each of
# the three starters, and reports how often you win.
require_relative "driver"
HL.start_up
HL.quiet = true
starter_pick = 0
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1],
              [/Which Pokémon/, ->(_t, _c) { starter_pick }]]
HL.new_game
HL.frames(200)

# where each trainer stands
where = {}
Dir["Data/FrostThaw/Map*.rxdata"].each do |f|
  id = f[/Map(\d+)/, 1].to_i
  m = load_data(f)
  m.events.each_value do |e|
    src = e.pages.flat_map(&:list).select { |c| [355, 655].include?(c.code) }.map { |c| c.parameters[0] }.join("\n")
    where[$1.to_sym] = [id, e.x, e.y] if src =~ /FT\.trainer\(:(\w+)/
    where[$1.to_sym] = [id, e.x, e.y] if src =~ /FT\.gym_leader\(:(\w+)/
  end
end
where[:sephek] ||= [2023, 10, 10]

STARTERS = ENV["STARTERS"] ? ENV["STARTERS"].split(",").map(&:to_sym) : FrostThaw::STARTERS.map { |s| s[:species] }
CATCH = (ENV["CATCH"] || "SPHEAL").split(",").map(&:to_sym)
only = ENV["ONLY"]&.split(",")&.map(&:to_sym)
runs = (ENV["N"] || 3).to_i
FrostThaw::TRAINERS.each do |key, (type, name, party)|
  next if only && !only.include?(key)
  top = party.map { |p| p[1] }.max
  map = where[key]
  HL.warp(map[0], map[1], map[2] + 1) if map rescue nil
  wins = 0
  runs.times do |i|
    sp = STARTERS[i % STARTERS.size]
    $Trainer.party.clear
    ([sp] + CATCH).each do |s|
      if ENV["EVOLVE"] && s == sp          # the stage a starter at this level would be
        while (ns = Pokemon.new(s, top).check_evolution_on_level_up(false)) && ns != s
          s = ns
        end
      end
      pk = Pokemon.new(s, top)
      HL.sensible_moves(pk, FrostThaw::STARTER_MOVES[s])
      $Trainer.party << pk
    end
    sw = Settings::NO_MONEY_LOSS
    $game_switches[sw] = true
    won = begin
      pbTrainerBattle(type, name, nil, false, 0, true)
    rescue StandardError => e
      puts "  error: #{e.message[0, 120]}"; false
    end
    wins += 1 if won
  end
  weather = $game_screen.weather_type rescue "?"
  puts format("%-18s %-16s L%-3d team %-44s on %-5s %-6s won %d/%d", key, "#{name}", top,
              party.map { |p| "#{p[0]}#{p[1]}" }.join(" "), map&.first, weather, wins, runs)
  $stdout.flush
end
