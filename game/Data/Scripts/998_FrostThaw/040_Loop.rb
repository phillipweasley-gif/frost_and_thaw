#===============================================================================
# Frost & Thaw - the Still Keeper's loop (Ending C)
#
# Inside the loop people half-remember things (the [loop: 1+] lines live in
# their scenes), and at the start of each act you can say "I remember this" and
# skip ahead: to the fall at the end of Act I, to the Vote at the end of
# Act II, or (at Act III's card) up to the Hall of the Four Winds in
# Grimskalle (notes 13 E10: the design's "a couple of hours", not a full Act
# III). The loop only breaks when you choose Shatter or the Third Way.
#
# The story's keepsakes (every key item it hands out) are taken when the loop
# starts, so no scene gives a second copy; a skip gives back the ones you had
# by then (notes 13 E18).
#===============================================================================
module FrostThaw
  # (filled in from a full playthrough: tools/headless/story_run.rb LOOP_DUMP; see 041_LoopFlags.rb)
  LOOP_ACT1_FLAGS = [] unless const_defined?(:LOOP_ACT1_FLAGS)
  LOOP_ACT2_FLAGS = [] unless const_defined?(:LOOP_ACT2_FLAGS)

  module_function

  LOOP_SNAP_SKIP = %i[in_loop loop_skip_asked_act1 loop_skip_asked_act2 loop_skip_asked_act3 hall_entered]

  # Every key item the story hands out (the Key Items pocket of RELIC_ITEMS).
  def story_key_items
    RELIC_ITEMS.select { |_id, d| d[2] == 8 }.keys
  end

  def story_keys_held
    story_key_items.each_with_object({}) do |id, h|
      n = ($PokemonBag.pbQuantity(id) rescue 0).to_i
      h[id] = n if n > 0
    end
  end

  def take_story_keys
    story_keys_held.each { |id, n| $PokemonBag.pbDeleteItem(id, n) rescue nil }
  end

  # Quietly, the ones you'd have had by the end of the act you skip.
  def give_back_story_keys(act)
    snap = state[:loop_snap] && state[:loop_snap][act]
    (snap && snap[:keys] || {}).each do |id, n|
      have = ($PokemonBag.pbQuantity(id) rescue 0).to_i
      $PokemonBag.pbStoreItem(id, n - have) if n > have rescue nil
    end
  end

  # Companions given as gifts (whole read P7): a replayed act plays the scene but
  # doesn't hand over a second Sahnar, Heartwood, Spheal or Yetot.
  LOOP_GIFTS = %i[widow_spheal sahnar_with_you treant_given got_yeti_cub]
  def remember_loop_gifts(flags)
    state[:loop_gifts] = ((state[:loop_gifts] || []) | LOOP_GIFTS.select { |f| flags[f] })
  end

  def looped_gift?(f)
    loop? && (state[:loop_gifts] || []).include?(f)
  end

  # Called as each act ends: remember how *this* playthrough went, so a skip in
  # the loop replays your own choices (the static lists are only a fallback).
  def loop_snapshot(act)
    snaps = (state[:loop_snap] ||= {})
    flags = (state[:flags] || {}).select { |k, v| v && !LOOP_SNAP_SKIP.include?(k) }.keys
    # ...and the story's own state and counters (start_loop clears them; a skip puts yours back)
    keep = defined?(LOOP_KEEP_STATE) ? LOOP_KEEP_STATE : %i[flags counters companions loop_snap]
    story = state.reject { |k, _v| keep.include?(k) }
    story = (Marshal.load(Marshal.dump(story)) rescue {})
    counters = (state[:counters] || {}).reject { |k, _v| k == :loop_count }.dup
    snaps[act] = { flags: flags, companions: (state[:companions] || []).dup, state: story, counters: counters,
                   keys: story_keys_held, switches: loop_switches_held, self_switches: loop_self_switches_held }
  rescue StandardError => e
    log("loop snapshot failed: #{e.message}") rescue nil
  end

  # The maps' own memory (whole read P6): story switches and the self switches of
  # every Frost & Thaw map, so a skip brings back finished favours, beaten trainers
  # and taken items along with the flags.
  def loop_switches_held
    return [] if !$game_switches
    STORY_SWITCHES.select { |i| $game_switches[i] }
  end

  def loop_self_switches_held
    data = ($game_self_switches.instance_variable_get(:@data) rescue nil) || {}
    data.select { |(m, _e, _c), v| v && m >= 2001 && m < 2400 }.keys
  end

  def loop_skip_switches(act)
    snap = state[:loop_snap] && state[:loop_snap][act]
    return if !snap
    (snap[:switches] || []).each { |i| $game_switches[i] = true } if $game_switches
    (snap[:self_switches] || []).each { |k| $game_self_switches[k] = true } if $game_self_switches
    $game_map.need_refresh = true if $game_map
  rescue StandardError => e
    log("loop skip switches failed: #{e.message}") rescue nil
  end

  def loop_skip_flags(act)
    snap = state[:loop_snap] && state[:loop_snap][act]
    return snap[:flags] if snap && snap[:flags] && !snap[:flags].empty?
    act == :act1 ? LOOP_ACT1_FLAGS : LOOP_ACT2_FLAGS
  end

  # Your own state and counters from the act you're skipping (quest clocks,
  # scores, favours): a skip replays them like the flags.
  def loop_skip_state(act)
    snap = state[:loop_snap] && state[:loop_snap][act]
    return if !snap
    (snap[:state] || {}).each { |k, v| state[k] = (Marshal.load(Marshal.dump(v)) rescue v) }
    state[:counters] ||= {}
    (snap[:counters] || {}).each { |k, v| state[:counters][k] = v if k != :loop_count }
  rescue StandardError => e
    log("loop skip state failed: #{e.message}") rescue nil
  end

  # Returns true if the player chose to skip (and has been moved on).
  def loop_skip(act)
    return false if !loop? || flag?(:"loop_skip_asked_#{act}")
    # Act III has no fallback list: only a loop that reached the Hall can skip to it
    return false if act == :act3 && !(state[:loop_snap] && state[:loop_snap][:act3])
    set_flag(:"loop_skip_asked_#{act}")
    prompt = act == :act1 ? _INTL("You remember this. All of it. Skip ahead to the fall, at the end of Act I?") :
             act == :act2 ? _INTL("You remember this, too. Skip ahead to the night of the Vote, at the end of Act II?") :
                            _INTL("You remember the rest. Skip ahead to Grimskalle, and the Hall of the Four Winds?")
    return false if !pbConfirmMessage(prompt)
    loop_skip_flags(act).each { |f| set_flag(f) }
    loop_skip_state(act)
    loop_skip_switches(act)
    give_back_story_keys(act)
    badges = act == :act1 ? (0..2) : (0..7)
    badges.each { |i| $Trainer.badges[i] = true } rescue nil
    if act == :act1
      say(["The days go by like pages: Targos, Bryn Shander, Lonelywood, Dougan's Hole, the Chasm.",
           "You remember every one. And then the fall."])
      transfer(*ARRIVAL_POINT)
    elsif act == :act3
      snap = state[:loop_snap][:act3]
      state[:companions] = snap[:companions].to_a.empty? ? (%i[alberica reptin alerion meat_meat wyn] - [herald]).uniq :
                                                          snap[:companions].dup
      say(["The Shrine. The Council's four chairs. The sea of moving ice, the statues, the dead.",
           "You remember every one. And then the skull's jaw, and the Hall of the Four Winds."])
      set_rest_at(HALL_ARRIVAL) rescue nil
      transfer(*HALL_ARRIVAL)
    else
      snap = state[:loop_snap] && state[:loop_snap][:act2]
      state[:companions] = snap && !snap[:companions].to_a.empty? ? snap[:companions].dup :
                           (%i[alberica reptin alerion meat_meat wyn] - [herald]).uniq
      say(["The festival. The roots. The forge, and Glimmer's better fire. The dragon. The Trials.",
           "You remember every one. And then the Vote, and four chairs filled."])
      act3_start
    end
    true
  end
end

# The Act III skip is offered at Act III's card, the night of the Vote, before
# Chapter 11 replays (037's scene_auril_whisper is wrapped here, not edited).
module FrostThaw
  class << self
    if method_defined?(:scene_auril_whisper) && !method_defined?(:ft_j_scene_auril_whisper)
      alias ft_j_scene_auril_whisper scene_auril_whisper
      def scene_auril_whisper(*args)
        if !flag?(:auril_whisper) && loop_skip(:act3)
          set_switch(SW_CH11_HEARTH, false) rescue nil
          return
        end
        ft_j_scene_auril_whisper(*args)
      end
    end
  end
end
