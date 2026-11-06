#===============================================================================
# Frost & Thaw - the Ten-Towns favours (owner's call, 2026-11-05)
#
# Each of the five towns' quests pays something a trainer can use, and finishing
# all five earns the Council's thanks:
#   Targos        Mountain Climb    Keegan's carved charm (Exp. Share), free rooms at the Luskan Arms
#   Bryn Shander  Foaming Mugs      one dwarf-forged Choice item, your pick; a tenth off at Garn's
#   Termalaine    A Beautiful Mine  two evolution stones from the new seam, your pick; $5,000
#   Lonelywood    The White Moose   Nimsy's lucky coin (Amulet Coin); Ramshackle, to rest in
#   Good Mead     The Mead Must Flow the queen hive's royal jelly (Ability Capsule); a tenday's lodging
#   All five      The Council's thanks: Infinite Splicers, sent from Bryn Shander
#===============================================================================
module FrostThaw
  module_function

  TOWN_QUESTS = [
    [:climb_done,       "Targos"],
    [:mugs_done,        "Bryn Shander"],
    [:mine_done,        "Termalaine"],
    [:white_moose_done, "Lonelywood"],
    [:mead_returned,    "Good Mead"]
  ]

  # A finished favour has its own signal (notes 14 E15): a jingle and one
  # plain box, before the counter.
  Stage::JINGLES[:quest] ||= "Voltorb Flip Win"

  def quest_done_box(text)
    Stage.jingle(:quest)
    say(["(#{text})"])
  end

  # Someone travelling with you who isn't a Herald (Garret on the climb,
  # Perilou coming down): they walk in beside you for their line, and step
  # back out when you have control again, the way the companions do.
  def walk_in(key, graphic)
    return nil if !Stage.map?
    ev = $game_map.events.values.find { |e| e.name == "stage_#{key}" && !e.transparent } rescue nil
    return ev if ev
    slot = Stage.free_slot || Stage.near_slot or return nil
    x, y, fx, fy = slot
    ge = Stage.actor(key, fx, fy, $game_player.direction, graphic: graphic) or return nil
    Stage.walk_to(ge, x, y) if [fx, fy] != [x, y]
    Stage.turn_to(ge)
    ge.through = true
    (Stage.instance_variable_get(:@summoned) || {})[key] = [ge, [fx, fy]]
    ge
  rescue StandardError => e
    log("walk_in #{key}: #{e.message}")
    nil
  end

  def town_quests_done
    TOWN_QUESTS.count { |f, _| flag?(f) }
  end

  def town_quests_left
    TOWN_QUESTS.reject { |f, _| flag?(f) }.map(&:last)
  end

  # The Goal menu's "Also:" line for the favours (context 14, M14-1): names the
  # five towns that count, and drops each as it's done. Gone after the thanks,
  # and after the fall (the Dale's jobs close with Act I).
  def favours_goal
    left = town_quests_left
    return side_goal_done(:favours) if left.empty?
    text = "Ten-Towns favours: help #{list_and(left)}."
    side_goal(:favours, text, done: [:ten_towns_thanked, :act1_done])
  end

  def list_and(names)
    names.size < 2 ? names.join : "#{names[0..-2].join(', ')} and #{names[-1]}"
  end

  # The counter, as one or two plain boxes (context 14, M14-1 C).
  def favours_count_lines(note = nil)
    n = town_quests_done
    left = town_quests_left
    return [] if left.empty?
    lines = []
    lines << (note ? "(Ten-Towns favours: #{n} of 5 towns. #{note})" : "(Ten-Towns favours: #{n} of 5 towns.)") if n > 0
    lines << (left.size == 1 ? "(One town left: #{left[0]}. Speaker Duvessa's Council is waiting on it.)" :
                               "(Still to help: #{left.join(', ')}.)")
    lines
  end

  # Called at the end of each town's payout. note: an honest word when the
  # favour didn't end well (Termalaine's mine, with its Speaker gone).
  def town_quest_finished(note = nil)
    n = town_quests_done
    if n >= TOWN_QUESTS.size
      council_thanks
    else
      # A player who helped a town before Duvessa explained the favours (M14-1 C box 1).
      say(["(Word travels in Ten-Towns. Speakers write to Speakers, and Bryn Shander's reads it all.)"]) if n == 1 && !flag?(:badge_bryn)
      say(favours_count_lines(note))
    end
    favours_goal
  end

  def council_thanks
    return if flag?(:ten_towns_thanked)
    set_flag(:ten_towns_thanked)
    pbMEPlay("Item get") rescue nil
    say(["Before the day is out, a Council runner from Bryn Shander catches you up, red with cold.",
         "She hands over a parcel wrapped in oilcloth, and a letter with Speaker Duvessa's seal.",
         "\"Five Speakers have written to me about you. Five. I said the Council would pay. It does.\"",
         "\"They have never agreed on anything. Each says you paid a debt that wasn't yours.\"",
         "In the parcel: a pair of splicers in black iron, the Council's seal worked into the grip."])
    give(:INFINITESPLICERS)
    say(["(Infinite Splicers: shop splicers break after one fusion. These never wear out.)"])
    sayc([cl(:reptin, "The Council of Speakers, agreeing. Somebody write the date down."),
          cl(:alberica, "Frame the letter. I'm serious. I'll hang it over the bar at the Hearth."),
          cl(:meat_meat, "Meat Meat would like the runner to stay for soup. She is very red.")])
    add_counter(:story_beats)
  end

  # After the fall, the Dale's unfinished jobs close in fiction (context 14,
  # M14-9 B): outside the Wall the night is the same night (Hellen's rule), so
  # nobody up there has had time to miss you. Plays once, the first night at
  # the Hearth, and only if a job was taken and left.
  ACT1_JOBS_LEFT = [
    [:climb_taken, :climb_done, -> { flag?(:garret_found) ? "Garret's friends are still on that mountain." : "Garret's still on that mountain." }],
    [:mugs_taken, :mugs_done, -> { "Hruna's still drinking to Oobok." }],
    [:mine_taken, :mine_done, -> { "Termalaine's mine's still shut." }],
    [:white_moose_taken, :white_moose_done, -> { "Nimsy's moose is still loose." }],
    [:mead_taken, :mead_returned, -> { "Good Mead's still dry." }]
  ]

  def act1_jobs_goodbye
    # Marta's ring, read at the act's end (notes 14 E14): Alberica made the promise
    if flag?(:act1_done) && has_key?(:FT_RINGOFWARMTH) && !flag?(:marta_ring_read) && with_or_is?(:alberica)
      set_flag(:marta_ring_read)
      sayc([cl(:alberica, "(turning Marta's ring over) Still warm. Even here."),
            cl(:alberica, "I promised her a thaw. I keep my promises. Eventually.")])
    end
    return if flag?(:act1_jobs_goodbye) || !flag?(:act1_done)
    left = ACT1_JOBS_LEFT.select { |taken, done, _| flag?(taken) && !flag?(done) }.map { |_, _, l| l.call }
    return if left.empty?
    set_flag(:act1_jobs_goodbye)
    sayc([cl(:alberica, "(at the window, toward the Wall) It's the same night out there. Hellen said so."),
          left.size > 1 ? cl(:alberica, left[0]) : nil,
          cl(:alberica, "#{left[left.size > 1 ? 1 : 0]} Nobody's had time to miss us yet."),
          cl(:reptin, "Then we go back when we can. They'll keep. That's the one mercy in that snow.")])
  end

  # Pick from a list (the dwarves' forge, the mine's seam).
  def favour_pick(question, options)
    names = options.map { |o| o[0] }
    i = pbMessage(_INTL(question), names, -1) rescue 0
    i = 0 if !i.is_a?(Integer) || i < 0
    options[i]
  end

  CHOICE_FORGE = [
    ["A band, for the arm that hits", :CHOICEBAND],
    ["A lens, for the eye that aims", :CHOICESPECS],
    ["A scarf, for the feet that run", :CHOICESCARF]
  ]
  SEAM_STONES = [
    ["Fire Stone", :FIRESTONE], ["Water Stone", :WATERSTONE], ["Thunder Stone", :THUNDERSTONE],
    ["Leaf Stone", :LEAFSTONE], ["Ice Stone", :ICESTONE], ["Moon Stone", :MOONSTONE],
    ["Sun Stone", :SUNSTONE], ["Dusk Stone", :DUSKSTONE], ["Dawn Stone", :DAWNSTONE], ["Shiny Stone", :SHINYSTONE]
  ]

  def favour_forge
    say(["HRUNA: And Garn's lit the forge for ye. One piece, made to fit. Ye choose what it's for.",
         # What a Choice item costs, in a dwarf's words (context 14, M14-5).
         "HRUNA: Garn says they make 'em strong, and stubborn. One move till ye call 'em back."])
    _name, item = favour_pick("What should the dwarves forge?", CHOICE_FORGE)
    say(["The hammer rings till dark. In the morning it's waiting for you, still warm."])
    give(item)
  end

  def favour_seam
    say(["OARUS: The miners held back the first two stones from the new seam. For you. Pick.",
         "(Some Pokémon change when they touch the right stone. Pick the ones your team needs.)"])
    picked = []
    2.times do
      left = SEAM_STONES.reject { |_n, it| picked.include?(it) }
      _name, item = favour_pick(picked.empty? ? "Which stone first?" : "And the second?", left)
      picked << item
      give(item)
    end
  end

  #-----------------------------------------------------------------------------
  # The world remembers (notes 14 E14): once a town's favour is done, the
  # Heralds' talk in that town says so. Each line is a variant that plays
  # first, in front of whatever the town's chat already was.
  #-----------------------------------------------------------------------------
  def self.remember_in_chat(who, area, cond, lines)
    return if !defined?(PARTY_CHAT) || !PARTY_CHAT[who]
    old = PARTY_CHAT[who][area]
    PARTY_CHAT[who][area] = -> { condition_met?(cond) ? lines : resolve(old) }
  end

  FAVOUR_CHAT = [
    [:alberica, :targos, { flag: :climb_done }, ["\"BIG LOVE\", on a walrus. I'm going to think about that walrus for a week.",
                                                 "Garret was chopping wood he didn't need. Boy was sitting on his feet."]],
    [:reptin, :targos, { flag: %i[climb_done yeti_den_peace] }, ["The yeti mother let us take Perilou. She decided to.",
                                                                  "I keep thinking about that. A mother, deciding."]],
    [:reptin, :targos, { flag: %i[climb_done mother_yeti_beaten] }, ["We fought a mother in her own den. It was the right call.",
                                                                      "I don't have to like it."]],
    [:alerion, :targos, { flag: %i[climb_done mokingo_promised] }, ["We told Garret we'd go up for Mokingo in the spring. I'm holding us to it."]],
    [:alerion, :targos, { flag: :climb_done }, ["Garret says spring, for Mokingo. Somebody should hold him to it."]],
    [:shade, :bryn, { flag: %i[mugs_done goblins_kind] }, ["The goblins went home under a blanket, with their lives. Most raids end worse.",
                                                            "I'd know."]],
    [:shade, :bryn, { flag: :mugs_done }, ["Garn's melting the iron already. You can smell it from the gate. Good smell."]],
    [:alberica, :bryn, { flag: :oobok_home }, ["They'll take Oobok home under the mountain. I hope somebody sings for him there."]],
    [:reptin, :termalaine, { flag: :oarus_dead }, ["Shaelen stands at the mine road every morning. We left that thing down there."]],
    [:alerion, :termalaine, { flag: %i[mine_done kobolds_to_town] }, ["Kobolds hauling carts in the street. The town's stopped staring. Mostly."]],
    [:reptin, :lonelywood, { flag: :white_moose_done }, ["The moose could talk. Someone gave it words, and nothing to say with them but hate."]],
    [:alberica, :good_mead, { flag: %i[mead_returned council_session] }, ["Kendrick said the first cask was on him.",
                                                                          "...I had it. I drank it for him."]]
  ]
  FAVOUR_CHAT.reverse_each { |who, area, cond, lines| remember_in_chat(who, area, cond, lines) }
end
