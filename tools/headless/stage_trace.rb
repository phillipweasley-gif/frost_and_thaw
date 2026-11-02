# Storyboard trace: run the story driver and record, for every message box,
# where the camera is and who is on the map (for tools/storyboard.py).
#   STAGE_TRACE=out.json ruby tools/headless/stage_trace.rb   (same env as story_run.rb)
require "json"
$stage_trace = []
$after_start_up = proc do
FrostThaw.singleton_class.class_eval do
    alias st_orig_say say
    def say(lines, event_id = nil)
      Array(lines).flatten.compact.each do |line|
        begin
          chars = $game_map.events.values.reject { |e| e.character_name.to_s.empty? || e.transparent || e.instance_variable_get(:@erased) }
                           .map { |e| { name: e.name, x: e.x, y: e.y, real_x: e.real_x, real_y: e.real_y, g: e.character_name, d: e.direction } }
          $stage_trace << { line: line, map: $game_map.map_id, dx: $game_map.display_x, dy: $game_map.display_y,
                            player: { x: $game_player.x, y: $game_player.y, d: $game_player.direction },
                            chars: chars }
        rescue StandardError
        end
        st_orig_say([line], event_id)
      end
    end
end
end
at_exit { File.write(ENV["STAGE_TRACE"] || "stage_trace.json", JSON.pretty_generate($stage_trace)) }
load File.expand_path("story_run.rb", __dir__)
