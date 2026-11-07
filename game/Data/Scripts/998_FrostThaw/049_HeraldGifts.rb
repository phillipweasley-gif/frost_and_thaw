#===============================================================================
# Frost & Thaw - gifts that belong to one Herald's playthrough
#
# Razzy's Blanket (owner's call, 2026-11-06): Meat Meat's partner is a Noibat,
# Flying/Dragon, four times weak to Ice in a Dale that's all ice. In her own
# opening she finds the strip of lab blanket Razzy left in the hay; her Noibat
# sleeps in it. Held, it halves Ice-type damage. Only her playthrough has it
# (it's given in meat_meat_prologue, 005_NewGame.rb, and nowhere else).
#
# This file loads last so the item takes the next free number and no other
# item's number moves.
#===============================================================================
module FrostThaw
  RELIC_ITEMS.merge!(
    FT_RAZZYBLANKET: ["Razzy's Blanket", "Razzy's Blankets", 1, 0,
      "A strip of rough grey lab blanket Razzy left in the hay. Your Noibat sleeps in it. Held: Ice-type moves hit the holder for half.",
      0, 0, 0]
  )

  module_function

  # Meat Meat's opening, once her partner is with her: the blanket, and Noibat in it.
  def find_razzy_blanket(pkmn)
    return if !herald?(:meat_meat) || flag?(:razzy_blanket)
    set_flag(:razzy_blanket)
    pbMessage(_INTL("In the hay where Razzy slept: his lab blanket. A grey strip, rough, still a little warm."))
    pbMessage(_INTL("(Razzy would want it used. Razzy hated being cold.)"))
    if pkmn && !pkmn.item
      pkmn.item = :FT_RAZZYBLANKET
      pbMessage(_INTL("\\me[Item get]Your {1} wraps itself up in Razzy's Blanket!", pkmn.speciesName))
      pbMessage(_INTL("(Held, it halves the damage of Ice-type moves.)"))
    else
      give(:FT_RAZZYBLANKET)
    end
  rescue StandardError => e
    log("Razzy's blanket: #{e.message}")
  end
end

if defined?(BattleHandlers::DamageCalcTargetItem)
  BattleHandlers::DamageCalcTargetItem.add(:FT_RAZZYBLANKET,
    proc { |item, user, target, move, mults, baseDmg, type|
      mults[:final_damage_multiplier] /= 2 if type == :ICE
    }
  )
end
