#===============================================================================
# Frost & Thaw - Rootspire as a living city (part G): the city's switches,
# signs, and the hooks the older Rootspire scripts call.
#===============================================================================
module FrostThaw
  TEXT.merge!(
    timeline_wall: ["A long panel of living bark, carved with the city's years: FROM DOUGAN'S HOLE TO ROOTSPIRE.",
                    "YEAR 0 VR. The Heralds shatter the hag's mirrors. A sapling bursts from the thawed soil above Dougan's Hole.",
                    "YEAR 57 VR. The roots lace the valley. Druids, exiles and fisherfolk build walkways among them, and name the tree the Heart of Spring.",
                    "YEAR 113 VR. Two wyrmlings, Razzilith the Verdant and Frostina the Pale, circle the valley. Their breath quickens the tree.",
                    "YEAR 250 VR. The trunk hardens to crystal-oak. The canopy pierces the aurora. Dougan's Hole is gone beneath the roots. Rootspire is named.",
                    "YEAR 400 VR. The Heralds of Dawn and Dusk return.",
                    "Someone has scratched underneath, more recently: AND THE SUMMER NEVER ENDED."],
    prophecy_leaf: [{ if: { flag: :summer_ended }, lines: ["A crystal leaf that used to whisper. It's gone quiet now. The roots bled, and you were there."] },
                    ["A single frost-glass leaf in a case of its own, labelled DO NOT READ ALOUD.",
                     "It whispers anyway, to anyone who leans close:",
                     "\"The Frost Saint will climb the Spire when the roots bleed.\""]],
    dock_hatch_barred: ["A hatch in the dock planks, barred from below. Fish-oil and smoke seep up through the cracks.",
                        "Somebody's using whatever's under the Split Dock. Somebody with a key."],
    great_root: ["A root as wide as a house, rising out of the market toward the trunk. It's warm. It's always warm."]
  )

  module_function

  #-----------------------------------------------------------------------------
  # Downtime after the Heartroot: Council Petitions (present what you found and
  # win the Council's support) and the Festival of Balance (accept, and
  # Rootspire is your safe haven).
  #-----------------------------------------------------------------------------
  PETITION_FINDINGS = [
    [:chardalyn_found, "the chardalyn fragment from the Echo Gate, still warm"],
    [:ledger_found, "the Ledger of Corruption: Project Rime"],
    [:heist_exposed, "the Guild's reliquary, and what Darrus did for it"],
    [:ash_exposed, "Ash's confession: the patrols, and the Rite of the Long Gold"],
    [:selrae_white_womb, "the Winter Matron's black-ice dagger, and the White Womb"],
    [:souls_ledger_seen, "Eira Voss's ledger: twelve souls delivered to the forge"],
    [:forge_glimpsed, "what the mirror showed: the forge under the roots"]
  ]

  def petition_bench(event_id = nil)
    if !flag?(:engine_dead)
      return say(["The petitioners' bench, in front of the four crystals. Rootspire's citizens wait here for the Council's ear.",
                  "A clerk's sign: PETITIONS HEARD BETWEEN SEASONS. (There haven't been seasons for thirty years.)"], event_id)
    end
    return council_petitions(event_id) if !flag?(:council_petitioned)
    return festival_of_balance(event_id) if !flag?(:festival_of_balance)
    say(["The petitioners' bench. Somebody has carved five small figures into the end of it, and a sixth, newer, smaller."], event_id)
  end

  def council_petitions(event_id = nil)
    have = PETITION_FINDINGS.select { |f, _| flag?(f) }
    say(["The Council sits for petitions, the first time since the summer began.",
         "KELYN: Heralds. You've been under the city and out to its edges. Tell the Council what you found. Persuade us."], event_id)
    if have.size < 2
      return say(["You haven't enough to lay before them yet. (Bring the Council proof: what you found under the city and in it.)"])
    end
    wins = 0; fails = 0
    seats = [["KELYN: (to the Hall) Spring will hear it.", :spring], ["SELRAE's empty seat is filled by her deputy, a frost-bearded old Warden.", :winter],
             ["DARRUS's seat has a new Autumn Warden in it, very nervous.", :autumn], ["The Rootwardens' captains, at the back, arms folded.", :spring]]
    seats.each do |intro, faction|
      break if wins >= 3 || fails >= 2
      say([intro])
      opts = have.map { |_, t| _INTL("Show {1}.", t) } + [_INTL("Appeal to them without proof.")]
      c = pbMessage(_INTL("What do you lay before them?"), opts, 0)
      if c < have.size
        wins += 1
        favour(faction, 1)
        say(["A murmur runs round the Hall. Heads nod, slowly. #{have[c][1].capitalize}: nobody can argue with that."])
        have.delete_at(c) if have.size > 1
      else
        fails += 1
        say(["Polite silence. Somebody coughs. You've lost them, a little."])
      end
    end
    set_flag(:council_petitioned)
    if wins >= 3
      set_flag(:council_support)
      wheel(1)
      add_counter(:story_beats)
      say(["KELYN: (standing) The Council of Seasons supports the Heralds. Whatever you need, for whatever comes next. North, if it's north.",
           "Every crystal in the Hall glows at once."])
    else
      say(["KELYN: (carefully) The Council... thanks the Heralds. And will consider. At length.",
           "(You can't win the Council over today. The support you have will have to do.)"])
    end
  end

  def festival_of_balance(event_id = nil)
    say(["KELYN: The city wants to thank you. A Festival of Balance, in the Hall of Seasons. The Heralds celebrated.",
         "KELYN: And if you'll accept it: Rootspire as your home. Whatever comes, there's a bed here, and a door that's never locked."], event_id)
    c = pbMessage(_INTL("Accept the city's thanks?"), [_INTL("\"We accept.\""), _INTL("\"Not yet. When it's finished.\"")], 0)
    set_flag(:festival_of_balance)
    if c == 0
      set_flag(:rootspire_haven)
      sayc(["That night the whole city comes. Rootwood pipes, frost-glass lanterns, and for once the dawn comes up green.",
            "Hellen cries. Tamsin pretends not to. Somebody carves your names into the Council's living pillar, under the four leaves.",
            cl(:alberica, "Home. Sweethearts, I haven't had one of those in four hundred years."),
            cl(:reptin, "We've had one. We just kept leaving it.")].compact)
      wheel(1)
    else
      say(["KELYN: Then the door's open when it's finished. It'll stay open."])
    end
  end

  def tree_communion_or_talk(event_id = nil)
    return if respond_to?(:tree_communion) && tree_communion(event_id)
    talk(:great_root, event_id)
  end

  # The switches the city's events show and hide on, kept true to the story.
  def apply_rootspire_life_switches
    return if !active? || !$game_switches
    s = lambda { |id, on| $game_switches[id] = on ? true : false }
    s.call(SW_ORB_HALO, flag?(:twins_met) && !flag?(:halo_orb_cleared))
    s.call(SW_KELYN_ORB, flag?(:orb_visions) && !flag?(:kelyn_secret) && rs_day >= 3)
    s.call(SW_EREN_TROUBLED, flag?(:twins_met) && !flag?(:eren_settled))
    s.call(SW_SPIRITS, (flag?(:rheven_counselled) || flag?(:ch7_started)) && !flag?(:fields_pulse))
    s.call(SW_STILL_BEAST, flag?(:still_beast_asked) && !flag?(:still_beast_done))
    s.call(SW_LANTERN, ($PokemonBag.pbHasItem?(:FT_REVEALLANTERN) rescue false))
    s.call(SW_ASH_EXPOSED, flag?(:ash_exposed))
    s.call(SW_DARRUS_HIDING, flag?(:heist_exposed))
    s.call(SW_SCORCH, flag?(:rootwardens_at_door) && !flag?(:chardalyn_found))
    s.call(SW_FROSTFELL, flag?(:auroral_storm_seen) && !flag?(:frostfell_seen))
    s.call(SW_TALWYN_FIELDS, (state[:talwyn] || 0) >= 1)
    s.call(SW_HALDEN, flag?(:met_halden) && flag?(:ch7_started) && !flag?(:halden_done))
    s.call(SW_FROZEN_RUN, false) if flag?(:frozen_run_done)
    $game_switches[SW_RUN_OPEN] = true if flag?(:heist_offered) || flag?(:jorik_confessed) || flag?(:viessa_map)
    $game_switches[SW_CELLAR_FOUND] = true if flag?(:cellar_hint) || (flag?(:viessa_map) && flag?(:rite_stopped))
    $game_switches[SW_SUNCLEFT_OPEN] = true if flag?(:suncleft_open)
    $game_map.need_refresh = true if $game_map
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.apply_rootspire_life_switches
  rescue StandardError => err
    FrostThaw.log("Rootspire life switches failed: #{err.message}")
  end
}

#-------------------------------------------------------------------------------
# The Verdant Prototype's Blade's curse: each time it scores a killing blow, the
# mirror in its guard flickers with another face, one of Avarice's unfinished
# prototypes.
#-------------------------------------------------------------------------------
if defined?(BattleHandlers::UserItemAfterMoveUse)
  BattleHandlers::UserItemAfterMoveUse.add(:FT_VERDANTBLADE,
    proc { |_item, user, targets, _move, _numHits, battle|
      next if !targets.any? { |b| b.fainted? && b.opposes?(user) }
      faces = ["a goblin child with no eyes", "a small green thing with a dragon's jaw", "a girl made of mirror, half finished",
               "a face that's almost Meat Meat's", "something that was meant to have wings"]
      n = (FrostThaw.state[:blade_faces] = (FrostThaw.state[:blade_faces] || 0) + 1)
      battle.pbDisplay(_INTL("In the mirror of the Verdant Blade, another face flickers: {1}.", faces[(n - 1) % faces.size]))
    }
  )
end
