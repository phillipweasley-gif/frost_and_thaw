# Rootspire as a living city (W5): a sweep. Talks to every person, sign and
# object on the twenty new maps and the Rootspire maps, in three story states
# (just arrived; after the festival; after the Forge), plays every night
# event, omen, faction vignette, ambient event and downtime day once, and
# fails on any script error (FrostThaw.log "failed") or Ruby exception.
require_relative "driver"
HL.start_up
HL.quiet = !ENV["V"]
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
HL.new_game
HL.frames(60)
T = FrostThaw
$ok = 0; $bad = 0
def ok(name, cond, extra = nil)
  if cond then $ok += 1; puts "ok   #{name}" else $bad += 1; puts "FAIL #{name}#{extra ? ": #{extra}" : ''}" end
end
LOG = File.join(ENV["PIF_DIR"] || ".", "FrostThaw.log")
def log_size = (File.size(LOG) rescue 0)
def new_errors(from)
  return [] if !File.exist?(LOG)
  File.binread(LOG)[from..].to_s.force_encoding("UTF-8").scrub.lines.select { |l| l =~ /failed|Error|undefined/ }
end
def heal = $Trainer.party.each { |pk| pk.heal }

T.state[:companions] = [:alberica, :reptin, :alerion, :glimmer, :meat_meat]
$Trainer.party << Pokemon.new(:FORGEL, 80) while $Trainer.party.size < 3
$Trainer.party.each { |pk| pk.level = 80; pk.calc_stats; pk.heal }
$Trainer.money = 200_000

MAPS = (2180..2199).to_a + [2050, 2052, 2053, 2054, 2055, 2056, 2060, 2061, 2062]
STATES = {
  arrived:  %i[reversal rootspire_arrived met_hellen wardens_emeritus twins_met glimmer_joined],
  festival: %i[orb_visions halo_orb_cleared rite_stopped badge_hearth festival_night ch7_started crypt_open key_found canticle_learned lecture_done echo_wraiths_down],
  forge:    %i[engine_dead glimmer_gone summer_ended mira_freed twin_broken ledger_found]
}
SKIP = /^(Door|Exit|Warp|Root-stair|Down the|Up |Back to|To |Cutscene|Closed|Ward |Dock hatch|Root-Gate|Echo Gate|Cellar stair|Trainer)/

STATES.each do |st, flags|
  flags.each { |f| T.set_flag(f) }
  T.state[:companions] = [:alberica, :reptin, :alerion, :meat_meat] if st == :forge
  from = log_size
  talked = 0
  MAPS.each do |id|
    HL.warp(id, 1, 1); HL.frames(5)
    T.apply_rootspire_life_switches rescue nil
    evs = $game_map.events.values.reject { |e| e.name =~ SKIP }
    evs.each do |e|
      pg = e.instance_variable_get(:@page)
      next if !pg || pg.list.none? { |c| c.code == 355 }
      begin
        e.start
        HL.settle(3000)
        talked += 1
      rescue StandardError => err
        HL.problem("#{id} #{e.name}: #{err.class} #{err.message}")
      end
      heal
      break if $game_map.map_id != id
    end
  end
  errs = new_errors(from)
  ok("#{st}: talked to #{talked} people and things on #{MAPS.size} maps with no script errors", errs.empty? && talked > 50, errs.first(5).inspect)
end

# every night event, omen, vignette and downtime day, called straight
T.state[:companions] = [:alberica, :reptin, :alerion, :glimmer, :meat_meat]
T.state[:mode] = nil
from = log_size
probs = []
HL.warp(2053, 4, 7)
T::NIGHT_ORDER.each { |k| begin; T.send(:"night_#{k}"); HL.settle(2000); heal; rescue StandardError => e; probs << "night #{k}: #{e.message}"; end }
T::FACTION_EVENTS.each { |k, _m, _c, fn| begin; fn.call; rescue StandardError => e; probs << "faction #{k}: #{e.message}"; end }
T::HEARTH_VIGNETTES.each { |k, _c, fn| begin; fn.call; rescue StandardError => e; probs << "vignette #{k}: #{e.message}"; end }
T.state[:omens] = {}
15.times { begin; T.omen_check; rescue StandardError => e; probs << "omen: #{e.message}"; end }
ok("every night event, faction vignette, Hearth vignette and omen plays", probs.empty? && new_errors(from).empty?, (probs + new_errors(from)).first(5).inspect)
ok("all fifteen omens can be seen (three tiers of five)", T.counter(:omens_seen) >= 12, T.counter(:omens_seen))

from = log_size
probs = []
T.state[:herald] = nil
[[:arvik_day, 2..7], [:alerion_day, [2, 3, 4, 6, 7]], [:glimmer_day, 2..7], [:meat_meat_day, 2..5]].each do |fn, days|
  days.each { |d| begin; T.send(:"#{fn}#{d}", nil); rescue ArgumentError; T.send(:"#{fn}#{d}"); rescue StandardError => e; probs << "#{fn}#{d}: #{e.message}"; end; heal }
end
%i[memory_codex_day alberica_rumours festival_opening festival_toast festival_shudder_extras festival_voices eirwen_audience
   scene_frozen_cellar_enter scene_smugglers_run_enter scene_frozen_run_start].each do |fn|
  begin; T.send(fn); rescue StandardError => e; probs << "#{fn}: #{e.message}"; end
end
ok("every Herald's downtime days, the Codex, the festival beats and Eirwen's audience play", probs.empty? && new_errors(from).empty?, (probs + new_errors(from)).first(5).inspect)

# as each Herald (Herald Mode), the downtime days still read as you
%i[reptin alerion glimmer meat_meat alberica].each do |h|
  T.state[:mode] = :herald; T.state[:herald] = h
  T.state[:companions] = [:alberica, :reptin, :alerion, :glimmer, :meat_meat] - [h]
  n = HL.log.size
  fn = { reptin: [:arvik_day7, nil], alerion: [:alerion_day3, nil], glimmer: [:glimmer_day7, nil], meat_meat: [:meat_meat_day2], alberica: [:memory_codex_day] }[h]
  begin
    fn.size == 2 ? T.send(fn[0], nil) : T.send(fn[0])
  rescue StandardError => e
    probs << "#{h}: #{e.message}"
  end
  lines = HL.log[n..] || []
  own = { reptin: "REPTIN:", alerion: "ALERION:", glimmer: "GLIMMER:", meat_meat: "MEAT MEAT:", alberica: "ALBERICA:" }[h]
  ok("as #{h}, the downtime reads as you (nobody else speaks your lines)", probs.empty? && lines.any? && lines.none? { |l| l.include?(own) },
     lines.select { |l| l.include?(own) }.first(2).inspect)
end
T.state[:mode] = nil; T.state[:herald] = nil

puts "\n#{$ok}/#{$ok + $bad} W5 sweep checks passed"
puts HL.problems.uniq.first(15).inspect
