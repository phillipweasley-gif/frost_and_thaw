#===============================================================================
# Frost & Thaw - battle rules
#
# No running from (or forfeiting) a trainer battle, like the classic games.
# Wild battles and Infinite Fusion saves are unchanged.
#===============================================================================
class PokeBattle_Battle
  alias ft_orig_pbRun pbRun unless method_defined?(:ft_orig_pbRun)
  def pbRun(idxBattler, duringBattle = false)
    if FrostThaw.active? && trainerBattle? && !@battlers[idxBattler].opposes? &&
       !($DEBUG && Input.press?(Input::CTRL))
      pbDisplayPaused(_INTL("No! There's no running from a Trainer battle!"))
      return 0
    end
    ft_orig_pbRun(idxBattler, duringBattle)
  end
end
