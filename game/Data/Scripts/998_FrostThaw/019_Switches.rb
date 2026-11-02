#===============================================================================
# Frost & Thaw - story switches that people on the map actually obey
#
# Infinite Fusion only treats an event switch as "on" if that switch has a
# name in the game's System data, and only switches up to 1200 have names.
# Frost & Thaw's story switches live at 3900-3999 (well clear of the base
# game's own), so without this every page that depends on one - the Targos
# gate guards stepping aside, Bryn Shander's gates, Heralds hiding their own
# NPC - was ignored. Here those switches are read directly.
#===============================================================================
module FrostThaw
  STORY_SWITCHES = (3900..4199)   # 4000-4199: added for the faithful build-out (Nov 2026)
end

if defined?(Game_Event)
  class Game_Event
    alias ft_switchIsOn? switchIsOn? unless method_defined?(:ft_switchIsOn?)
    def switchIsOn?(id)
      return !!$game_switches[id] if FrostThaw::STORY_SWITCHES.include?(id) && $game_switches
      ft_switchIsOn?(id)
    end
  end
end
