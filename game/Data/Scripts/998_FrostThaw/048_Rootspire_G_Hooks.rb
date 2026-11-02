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
