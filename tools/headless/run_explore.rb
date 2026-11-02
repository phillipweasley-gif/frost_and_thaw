$stdout.sync = true
require_relative "explorer"
HL.start_up
HL.quiet = !ENV["HL_VERBOSE"]
mode = (ENV["HL_MODE"] || "journey")
HL.answers = [[/Which adventure/, 1], [/Another round/, 1], [/How much are you putting down/, 0], [/How would you like to play/, mode == "journey" ? 0 : 1],
              [/Choose a difficulty/, 1]]
HL.answers << [/Which Herald|Who are you/, ->(t, c) { c.index { |x| x.to_s =~ /#{ENV['HL_HERALD']}/i } || 0 }] if ENV["HL_HERALD"]
HL.new_game
HL.frames(200)
Explorer.level_floor = (ENV["HL_LEVEL"] || 0).to_i
t = Time.now
Explorer.run(max_iterations: (ENV["HL_ITER"] || 200).to_i)
puts "\n=== #{(Time.now - t).round}s; visited maps: #{Explorer.visited.to_a.sort.join(' ')}"
puts "flags: #{FrostThaw.state[:flags].select { |_k, v| v }.keys.map(&:to_s).join(' ')}"
puts "badges: #{$Trainer.badge_count}; party: #{$Trainer.party.map { |p| "#{p.name} L#{p.level}" }.join(', ')}"
puts "problems:"; puts HL.problems.uniq
File.write(ENV["HL_OUT"] || "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/transcript.txt", HL.log.map { |l| l.dup.force_encoding("UTF-8") }.join("\n"))
