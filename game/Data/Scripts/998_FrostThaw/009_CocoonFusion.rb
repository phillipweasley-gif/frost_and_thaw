#===============================================================================
# Frost & Thaw - working with the Cocoon Fusion mod
#
# Grafting is born from the World Tree, so in a Frost & Thaw save it only
# exists once the story grants it (flag :grafting). Before that the Cocoon
# Chamber is hidden.
# The mod's random grafting of NPC teams never runs in a Frost & Thaw save
# (2026-11-11): after the licence it rebuilt every hand-made team, and the
# Pokémon their lines name. The trainers who graft are picked by hand instead,
# and show it (051_Grafting). Infinite Fusion saves are unaffected.
#===============================================================================
module FrostThaw
  module_function

  def grafting_allowed?
    return true if !active?
    return flag?(:grafting)
  end
end

if defined?(CocoonFusion)
  if defined?(CocoonChamberPC)
    class CocoonChamberPC
      alias ft_orig_shouldShow? shouldShow? unless method_defined?(:ft_orig_shouldShow?)
      def shouldShow?
        return false if !FrostThaw.grafting_allowed?
        return ft_orig_shouldShow?
      end
    end
  end

  if defined?(CocoonFusion::Trainers) && CocoonFusion::Trainers.respond_to?(:apply!)
    module CocoonFusion
      module Trainers
        class << self
          alias ft_orig_apply! apply! unless method_defined?(:ft_orig_apply!)
          def apply!(*args)
            return if FrostThaw.active?
            ft_orig_apply!(*args)
          end
        end
      end
    end
  end
end

FrostThaw.log("Version #{FrostThaw::VERSION} loaded.") rescue nil
