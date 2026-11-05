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

  def town_quests_done
    TOWN_QUESTS.count { |f, _| flag?(f) }
  end

  # Called at the end of each town's payout.
  def town_quest_finished
    n = town_quests_done
    left = TOWN_QUESTS.reject { |f, _| flag?(f) }.map(&:last)
    if n >= TOWN_QUESTS.size
      council_thanks
    else
      say(["(Ten-Towns favours: #{n} of 5. Still owed a debt: #{left.join(', ')}.)"])
    end
  end

  def council_thanks
    return if flag?(:ten_towns_thanked)
    set_flag(:ten_towns_thanked)
    pbMEPlay("Item get") rescue nil
    say(["Before the day is out, a Council runner from Bryn Shander catches you up, red-faced from the cold.",
         "She hands over a parcel wrapped in oilcloth, and a letter with Speaker Duvessa's seal.",
         "\"Five speakers have written to me about you. Five. They have never agreed on anything.\"",
         "\"Each says you paid a debt that wasn't yours. The Council can't pay what that's worth. It can send this.\"",
         "In the parcel: a pair of splicers in black iron, the Council's seal worked into the grip."])
    give(:INFINITESPLICERS)
    say(["(Infinite Splicers: they never wear out. Fuse and unfuse your Pokémon as often as you like.)"])
    sayc([cl(:reptin, "The Council of Speakers, agreeing. Somebody write the date down."),
          cl(:alberica, "Frame the letter. I'm serious. I'll hang it over the bar at the Hearth."),
          cl(:meat_meat, "Meat Meat would like the runner to stay for soup. She is very red.")])
    add_counter(:story_beats)
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
    say(["HRUNA: And Garn's lit the forge for ye. One piece, made to fit. Ye choose what it's for."])
    _name, item = favour_pick("What should the dwarves forge?", CHOICE_FORGE)
    say(["The hammer rings till dark. In the morning it's waiting for you, still warm."])
    give(item)
  end

  def favour_seam
    say(["OARUS: The miners held back the first two stones from the new seam. For you. Pick."])
    picked = []
    2.times do
      left = SEAM_STONES.reject { |_n, it| picked.include?(it) }
      _name, item = favour_pick(picked.empty? ? "Which stone first?" : "And the second?", left)
      picked << item
      give(item)
    end
  end
end
