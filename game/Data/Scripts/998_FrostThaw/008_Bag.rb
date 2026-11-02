#===============================================================================
# Frost & Thaw - a bag with limits (until Pip sews more room)
#
# In a Frost & Thaw save each pocket holds BAG_START_LIMIT kinds of item.
# Key Items and TMs never fill up. Anything that doesn't fit goes to the PC
# instead of being lost. Pip's upgrades raise state[:bag_limit] (-1 = no limit).
#===============================================================================
module FrostThaw
  UNLIMITED_POCKETS = [4, KEY_ITEMS_POCKET]   # TMs & HMs, Key Items

  module_function

  def pc_storage
    $PokemonGlobal.pcItemStorage ||= PCItemStorage.new
    return $PokemonGlobal.pcItemStorage
  end

  def pc_can_take?(item, qty)
    return pc_storage.pbCanStore?(item, qty)
  rescue StandardError
    return false
  end

  def send_to_pc(item, qty)
    return false if !pc_can_take?(item, qty)
    pc_storage.pbStoreItem(item, qty)
    name = (GameData::Item.get(item).name rescue item.to_s)
    pbMessage(_INTL("Your bag has no room for more kinds of item in that pocket, so the {1} went to your PC.", name)) rescue nil
    return true
  end
end

class PokemonBag
  alias ft_orig_maxPocketSize maxPocketSize unless method_defined?(:ft_orig_maxPocketSize)
  def maxPocketSize(pocket)
    return ft_orig_maxPocketSize(pocket) if !FrostThaw.active?
    return -1 if FrostThaw::UNLIMITED_POCKETS.include?(pocket)
    limit = FrostThaw.state[:bag_limit]
    return -1 if !limit || limit < 0
    return limit
  end

  alias ft_orig_pbCanStore? pbCanStore? unless method_defined?(:ft_orig_pbCanStore?)
  def pbCanStore?(item, qty = 1)
    return true if ft_orig_pbCanStore?(item, qty)
    return FrostThaw.active? && FrostThaw.pc_can_take?(item, qty)
  end

  alias ft_orig_pbStoreItem pbStoreItem unless method_defined?(:ft_orig_pbStoreItem)
  def pbStoreItem(item, qty = 1)
    return ft_orig_pbStoreItem(item, qty) if !FrostThaw.active? || ft_orig_pbCanStore?(item, qty)
    return FrostThaw.send_to_pc(item, qty)
  end
end
