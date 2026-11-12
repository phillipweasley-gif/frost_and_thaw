#===============================================================================
# Frost & Thaw - step goals for the three long stretches
#
# The Goal menu (007) always says where the story goes next. A trace audit before
# launch (2026-11-12) found three stretches where it said the same thing for
# 40+ story steps and up to nine maps, which is exactly where a player coming
# back after a week gets lost:
#
#   the hag's old lair, the Cocoon Pens and the Root-Throne (Ch8)
#   the Heartroot's lower zones (Ch7B)
#   Avarice's sanctum up to the Heart Chamber (Ch8)
#
# Each stretch's Goal now moves on as you pass its landmarks. A step only
# replaces the stretch's own Goal (or an earlier step of it), so nothing here
# can overwrite a goal set later by the story.
#===============================================================================
module FrostThaw
  # [the stretch's opening Goal (prefix), [[flag, the next Goal], ...]]
  GOAL_STEPS = [
    ["Back to the Barricade gate. It's open now", [
      [:deep_shaft_entered, "Down the Deep Root Shaft. Thredra's old lair runs deeper than anyone mapped it."],
      [:rootwatch_cleared,  "On through the Scratching Hollow. The Cocoon Pens are past it."],
      [:rust_feasters_done, "The Cocoon Pens are just past the Hollow. Free whoever's in the cocoons."],
      [:prisoners_freed,    "Up into the Root-Throne. Get past the duergar to the root-keep gate."],
      [:rootkeep_gate_open, "Down the ramp past the root-keep gate, into the Dragonforge."]
    ]],
    ["Down through the Heartroot's lower zones", [
      [:hollow_core_entered,  "The Hollow Core. Below it: the Frozen Drop, then the Vault of Amber Dreams."],
      [:frozen_drop_entered,  "The Frozen Drop. The Vault of Amber Dreams is below it."],
      [:amber_vault_entered,  "The Vault of Amber Dreams. The Mirror-Root Vault and the Mirror Scriptory open off it."],
      [:mirror_root_entered,  "The Mirror-Root Vault. Then the Mirror Scriptory: whatever she wrote down is in there."]
    ]],
    ["Up the black-glass stair", [
      [:sanctum_entered,    "Avarice's sanctum. Find the way up. The Heart Chamber's above it, and her dragon flies at first light."],
      [:antechapel_entered, "The Auroral Antechapel. The Heart Chamber is the next way up."]
    ]]
  ]

  module_function

  def goal_step_after(flag_name)
    g = state[:goal]
    return if !g.is_a?(String)
    GOAL_STEPS.each do |opening, steps|
      own = [opening] + steps.map(&:last)
      next if own.none? { |t| g.start_with?(t) }
      idx = steps.index { |f, _t| f == flag_name }
      next if !idx
      at = own.index { |t| g.start_with?(t) }      # 0 = the opening, n = step n
      state[:goal] = steps[idx][1] if idx + 1 > at  # only ever forwards
      return
    end
  end
end

module FrostThaw
  class << self
    unless method_defined?(:ft_g_set_flag)
      alias ft_g_set_flag set_flag
      def set_flag(name, value = true)
        r = ft_g_set_flag(name, value)
        goal_step_after(name) if value
        r
      end
    end
  end
end
