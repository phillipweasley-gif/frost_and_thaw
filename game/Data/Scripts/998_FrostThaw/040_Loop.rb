#===============================================================================
# Frost & Thaw - the Still Keeper's loop (Ending C)
#
# Inside the loop people half-remember things (the [loop: 1+] lines live in
# their scenes), and at the start of each act you can say "I remember this" and
# skip ahead: to the fall at the end of Act I, or to the Vote at the end of
# Act II. The loop only breaks when you choose Shatter or the Third Way.
#===============================================================================
module FrostThaw
  # (filled in from a full playthrough: tools/headless/story_run.rb LOOP_DUMP; see 041_LoopFlags.rb)
  LOOP_ACT1_FLAGS = [] unless const_defined?(:LOOP_ACT1_FLAGS)
  LOOP_ACT2_FLAGS = [] unless const_defined?(:LOOP_ACT2_FLAGS)

  module_function

  LOOP_SNAP_SKIP = %i[in_loop loop_skip_asked_act1 loop_skip_asked_act2]

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
    snaps[act] = { flags: flags, companions: (state[:companions] || []).dup, state: story, counters: counters }
  rescue StandardError => e
    log("loop snapshot failed: #{e.message}") rescue nil
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
    (snap[:counters] || {}).each { |k, v| state[:counters][k] = v if !%i[loop_count wheel].include?(k) }
  rescue StandardError => e
    log("loop skip state failed: #{e.message}") rescue nil
  end

  # Returns true if the player chose to skip (and has been moved on).
  def loop_skip(act)
    return false if !loop? || flag?(:"loop_skip_asked_#{act}")
    set_flag(:"loop_skip_asked_#{act}")
    prompt = act == :act1 ? _INTL("You remember this. All of it. Skip ahead to the fall, at the end of Act I?") :
                            _INTL("You remember this, too. Skip ahead to the night of the Vote, at the end of Act II?")
    return false if !pbConfirmMessage(prompt)
    loop_skip_flags(act).each { |f| set_flag(f) }
    loop_skip_state(act)
    badges = act == :act1 ? (0..2) : (0..7)
    badges.each { |i| $Trainer.badges[i] = true } rescue nil
    if act == :act1
      say(["The days go by like pages turning: Targos, Bryn Shander, Lonelywood, Dougan's Hole, the Chasm. You remember every one.",
           "And then the fall."])
      transfer(*ARRIVAL_POINT)
    else
      snap = state[:loop_snap] && state[:loop_snap][:act2]
      state[:companions] = snap && !snap[:companions].to_a.empty? ? snap[:companions].dup :
                           (%i[alberica reptin alerion meat_meat wyn] - [herald]).uniq
      say(["The festival. The roots. The forge, and Glimmer's better fire. The dragon. The Trials. You remember every one.",
           "And then the Vote, and four chairs filled."])
      act3_start
    end
    true
  end
end
