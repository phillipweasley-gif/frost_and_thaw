#===============================================================================
# Frost & Thaw - one-time repairs to saves affected by earlier mistakes
#===============================================================================
module FrostThaw
  module_function

  # Shops once listed :PARALYZEHEAL, which isn't an Infinite Fusion item (it's
  # :PARLYZHEAL), so they sold an unknown "Thing" for $50. Swap any Things in
  # the bag for real Paralyze Heals.
  def repair_things
    return if !active? || !$PokemonBag
    qty = $PokemonBag.pbQuantity(:UNKNOWN)
    return if qty <= 0
    $PokemonBag.pbDeleteItem(:UNKNOWN, qty)
    $PokemonBag.pbStoreItem(:PARLYZHEAL, qty)
    log("Swapped #{qty} unknown 'Thing' item(s) for Paralyze Heals.")
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.repair_things
  rescue StandardError => err
    FrostThaw.log("Repair failed: #{err.message}")
  end
}

# A save keeps a snapshot of the map you saved on: who stood where, and which
# people existed. When that map has since been fixed or rebuilt, loading the
# old snapshot brings back the old problems (a character still blocking the
# stairs). On Frost & Thaw maps, always rebuild the current map from its file
# when a save is loaded; your position and story progress are kept.
if defined?(Game) && Game.respond_to?(:load_map)
module Game
  class << self
    alias ft_orig_load_map load_map unless method_defined?(:ft_orig_load_map)
    def load_map
      fresh = false
      begin
        fresh = FrostThaw.active? && $game_map && $game_map.map_id >= 2000 && !$PokemonGlobal.safesave
        $PokemonGlobal.safesave = true if fresh
      rescue StandardError => e
        FrostThaw.log("Map refresh on load skipped: #{e.message}")
      end
      ft_orig_load_map
    ensure
      $PokemonGlobal.safesave = false if fresh && $PokemonGlobal
    end
  end
end
end

# Quash (move 11E) walks every battler slot, and in a single battle the empty
# slots are nil, so the base game crashes ("undefined method `effects' for nil")
# the moment anyone uses it. Found by the full Herald runs, 2026-11-05.
if defined?(PokeBattle_Move_11E)
  class PokeBattle_Move_11E
    def ft_highest_quash
      @battle.battlers.compact.map { |b| b.effects[PBEffects::Quash] }.max || 0
    end

    def pbFailsAgainstTarget?(user, target)
      return true if pbMoveFailedTargetAlreadyMoved?(target)
      if !@battle.choices[target.index][2]
        @battle.pbDisplay(_INTL("But it failed!"))
        return true
      end
      highestQuash = ft_highest_quash
      if highestQuash > 0 && target.effects[PBEffects::Quash] == highestQuash
        @battle.pbDisplay(_INTL("But it failed!"))
        return true
      end
      if highestQuash == 0 && @battle.pbPriority.last.index == target.index
        @battle.pbDisplay(_INTL("But it failed!"))
        return true
      end
      return false
    end

    def pbEffectAgainstTarget(user, target)
      target.effects[PBEffects::Quash] = ft_highest_quash + 1
      target.effects[PBEffects::MoveNext] = false
      @battle.pbDisplay(_INTL("{1}'s move was postponed!", target.pbThis))
    end
  end
end
