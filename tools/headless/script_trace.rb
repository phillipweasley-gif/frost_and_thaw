# As-played script: runs the story driver (same env as story_run.rb) and logs,
# in order, everything a player would see and hear, not just the words:
#   [map]    you arrive on a map (name, where you stand)
#   [msg]    a message box, with who speaks and whether they're on screen
#   [ask]/[pick]  a choice and what was picked
#   [stage]  a Stage call: actors placed, walks, emotes, pans, panels, overlays,
#            effects, poses, balloons, themes, jingles, cries
#   [music]/[me]/[se]  music, jingles and sound effects
#   [screen] shakes, flashes, tone changes (fades)
#   [battle] battles (already logged by the driver)
#   [goal]   the pause menu's Goal changing
#   [flag]   story flags as they're set
#   [talk]   the driver walking up to someone and pressing A
# Usage: SCRIPT_TRACE=out.txt [SWEEP=1] HL_MODE=journey ruby tools/headless/script_trace.rb
$after_start_up = proc do
  ft = FrostThaw
  name_of = lambda do |ev|
    next "you" if ev.equal?($game_player)
    next "?" if !ev
    n = ev.respond_to?(:name) ? ev.name.to_s.sub(/\Astage_/, "") : ev.to_s
    "#{n}(#{ev.x},#{ev.y})"
  end
  where = lambda { "#{ft::MAP_NAMES[$game_map.map_id] || $game_map.map_id} [#{$game_map.map_id}]" rescue "?" }

  # Stage calls
  stage = ft::Stage.singleton_class
  {
    actor: ->(a) { "#{a[0]} appears at (#{a[1]},#{a[2]})#{a[4].is_a?(Hash) && a[4][:graphic] ? ' as ' + a[4][:graphic].to_s : ''}" },
    walk: ->(a) { "#{name_of.(a[0])} moves #{a[1..].flatten.inspect}" },
    walk_to: ->(a) { "#{name_of.(a[0])} walks to (#{a[1]},#{a[2]})" },
    approach: ->(a) { "#{name_of.(a[0])} walks up to #{name_of.(a[1] || $game_player)}" },
    leave: ->(a) { "#{name_of.(a[0])} leaves toward (#{a[1]},#{a[2]})" },
    escort: ->(a) { "#{name_of.(a[0])} leads you to (#{a[1]},#{a[2]})" },
    emote: ->(a) { "#{name_of.(a[0])} #{a[1] || :exclaim} bubble" },
    balloon: ->(a) { "#{a[1]} balloon over #{name_of.(a[0])}" },
    hop: ->(a) { "#{name_of.(a[0])} hops" },
    turn_to: ->(a) { "#{name_of.(a[0])} turns to #{name_of.(a[1] || $game_player)}" },
    face: ->(a) { "#{name_of.(a[0])} faces #{{ 2 => 'down', 4 => 'left', 6 => 'right', 8 => 'up' }[a[1]] || a[1]}" },
    pose: ->(a) { "#{name_of.(a[0])} pose #{a[1]} row #{a[2] || 0}" },
    fx: ->(a) { "effect #{a[0]} at #{a[1].is_a?(Array) ? a[1].inspect : name_of.(a[1])}" },
    panel: ->(a) { "PANEL #{a[0]}" },
    panel_off: ->(_a) { "panel off" },
    overlay: ->(a) { "OVERLAY #{a[0]}" },
    overlay_off: ->(a) { "overlay off #{a[0]}" },
    pan_to: ->(a) { "camera pans to (#{a[0]},#{a[1]})" },
    pan_back: ->(_a) { "camera pans back to you" },
    theme: ->(a) { a[0].nil? ? "map music resumes" : "theme #{a[0]}" },
    jingle: ->(a) { "jingle #{a[0]}" },
    cry: ->(a) { "cry #{a[0]}" },
    hide: ->(a) { "#{name_of.(a[0])} hidden" },
    visit: ->(a) { "CUT to map #{ft::MAP_NAMES[a[0]] || a[0]} (#{a[1]},#{a[2]}) [vision]" },
    cleanup: nil, forget: nil, jump: nil
  }.each do |m, fmt|
    next unless stage.method_defined?(m)
    orig = stage.instance_method(m)
    stage.send(:define_method, m) do |*args, **kw, &blk|
      $st_depth = ($st_depth || 0)
      (HL.say("stage", fmt.(args + (kw.empty? ? [] : [kw]))) rescue nil) if fmt && $st_depth.zero?
      $st_depth += 1
      begin
        kw.empty? ? orig.bind(self).call(*args, &blk) : orig.bind(self).call(*args, **kw, &blk)
      ensure
        $st_depth -= 1
      end
    end
  end

  # flags and goals
  fsc = ft.singleton_class
  orig_flag = fsc.instance_method(:set_flag)
  fsc.send(:define_method, :set_flag) do |k, v = true|
    (HL.say("flag", "#{k}#{v == true ? '' : " = #{v}"}") rescue nil) unless (flag?(k) rescue false) == v
    orig_flag.bind(self).call(k, v)
  end

  # who speaks, and can you see them
  orig_note = fsc.instance_method(:note_offstage)
  fsc.send(:define_method, :note_offstage) do |tag, why|
    HL.say("offstage", "#{tag} #{why}")
    orig_note.bind(self).call(tag, why)
  end

  # sound and screen
  Object.class_eval do
    %i[pbBGMPlay pbMEPlay pbSEPlay].each do |m|
      next unless private_method_defined?(m) || method_defined?(m)
      o = instance_method(m)
      kind = { pbBGMPlay: "music", pbMEPlay: "me", pbSEPlay: "se" }[m]
      define_method(m) do |*a, &b|
        nm = a[0].respond_to?(:name) ? a[0].name : a[0]
        (HL.say(kind, nm.to_s) rescue nil) unless kind == "se" && nm.to_s =~ /Cursor|Choose|Decision|Player bump|Battle|puddle|step|grass|bump|jump/i
        o.bind(self).call(*a, &b)
      end
    end
  end
  Game_Screen.class_eval do
    { start_shake: "shake", start_flash: "flash", start_tone_change: "tone" }.each do |m, k|
      o = instance_method(m)
      define_method(m) do |*a|
        (HL.say("screen", "#{k} #{a.map { |x| x.is_a?(Tone) || x.is_a?(Color) ? "(#{x.red.to_i},#{x.green.to_i},#{x.blue.to_i})" : x }.join(' ')}") rescue nil)
        o.bind(self).call(*a)
      end
    end
  end

  # the driver talking to people
  hsc = HL.singleton_class
  orig_talk = hsc.instance_method(:talk_to)
  hsc.send(:define_method, :talk_to) do |ev|
    (HL.say("talk", "#{ev.name} at (#{ev.x},#{ev.y}) on #{where.call}") rescue nil)
    orig_talk.bind(self).call(ev)
  end

  # map arrivals and goal changes, checked every frame
  $st_last_map = nil
  $st_last_goal = nil
  orig_frame = hsc.instance_method(:frame)
  note_map = lambda do
    if $game_map && $game_map.map_id != $st_last_map && !$game_temp.player_transferring
      $st_last_map = $game_map.map_id
      HL.say("map", "#{where.call} at (#{$game_player.x},#{$game_player.y})")
    end
  rescue StandardError
  end
  orig_scene = fsc.instance_method(:scene)
  fsc.send(:define_method, :scene) do |key, event_id = nil|
    note_map.call
    HL.say("scene", key.to_s)
    orig_scene.bind(self).call(key, event_id)
  end
  hsc.send(:define_method, :frame) do |keys = nil|
    note_map.call
    r = orig_frame.bind(self).call(keys)
    begin
      note_map.call
      g = ft.state[:goal]
      if g != $st_last_goal
        $st_last_goal = g
        HL.say("goal", g.to_s) if g
      end
    rescue StandardError
    end
    r
  end
end
at_exit do
  File.write(ENV["SCRIPT_TRACE"] || "script_trace.txt", HL.log.map { |l| l.dup.force_encoding("UTF-8") }.join("\n"))
end
ENV["STAGE_TRACE"] ||= "1"      # (lets story_run.rb's main run when loaded from here)
load File.expand_path("story_run.rb", __dir__)
