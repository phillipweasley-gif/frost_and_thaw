#===============================================================================
# Frost & Thaw - Relics, Blessings and Rootspire goods
#
# Why Act II's side paths are worth walking. Everything here comes from the
# Rootspire campaign documents, turned into Pokémon terms and balanced against
# the items Infinite Fusion already has:
#
#   RELICS OF THE FUTURE PAST (Part IV-B): one unique held item per Herald,
#   each found on that Herald's personal side quest.
#     Verdant Prototype's Blade  (Meat Meat)  Tinted Lens as an item: the
#        holder's "not very effective" hits do double damage.
#        (Book: ignores resistance; extra harm to the wounded.)
#     Heartwarden's Staff        (Reptin)     Fire and Ice moves hit the holder
#        for half; once a battle, below half HP, Verdant Pulse heals 1/4.
#        (Book: resist cold and fire; Verdant Pulse heals.)
#     Mantle of Returning Winter (Alerion)    Ice moves 1.2x (as Never-Melt
#        Ice); the holder can't be frozen and ignores hail.
#        (Book: Winter Stride, cold resistance, +1d6 cold.)
#     Key of Whispering Memory   (Alberica)   sound moves 1.3x (as Punk Rock).
#        (Book: a bard's focus; +1 to spell DCs.)
#
#   BLESSINGS (Appendix: Rootspire Blessings and Relics Table): permanent,
#   party-wide, earned by putting something right.
#     Blessing of Warmth   cleanse the Still Sky Shrine -> your Pokémon can't
#                          be frozen.
#     Hyphora's Blessing   purify the Undercanopy's lake ("Plant Speech")
#                          -> wild Grass and Bug Pokémon are 1.5x easier to catch.
#
#   GOODS (Hyphora's Undercanopy, Section 3; the Aerie Markets):
#     Sap-Skin Salve      60 HP and thaws (a Super Potion that also cures freeze).
#     Seed of Renewal     revives every fainted Pokémon in your party to half HP.
#     Luminescent Lantern key item: while it's in your bag, half as many wild
#                         Pokémon in caves.
#     Sporechime          key item: chimes when a trainer on this map still
#                         wants to battle you.
#     Auroral Mote        a treasure: sells for 2,500.
#     Frostshard Sigil    key item: one of the three that find and wake the White
#                         Vault's door (Alberica's pendant opens it: 047c).
#===============================================================================
module FrostThaw
  # id => [name, plural, pocket, price, description, field_use, battle_use, type]
  # pockets: 1 Items, 2 Medicine, 8 Key Items. type 6 = key item.
  RELIC_ITEMS = {
    FT_VERDANTBLADE: ["Verdant Blade", "Verdant Blades", 1, 0,
      "Meat Meat's relic: a goblin-sized dagger of mirrored steel. A held item that doubles the damage of the holder's not very effective moves.", 0, 0, 0],
    FT_HEARTWARDENSTAFF: ["Heartwarden's Staff", "Heartwarden's Staffs", 1, 0,
      "Reptin's relic, grown from the World Tree's roots. The holder takes half damage from Fire and Ice moves, and once a battle heals when badly hurt.", 0, 0, 0],
    FT_RIMEMANTLE: ["Rime Mantle", "Rime Mantles", 1, 0,
      "Alerion's Mantle of Returning Winter. Boosts the holder's Ice-type moves, and the holder can't be frozen or hurt by hail.", 0, 0, 0],
    FT_WHISPERKEY: ["Whisper Key", "Whisper Keys", 1, 0,
      "Alberica's Key of Whispering Memory, a tuning-key of silver and frost glass. Boosts the power of the holder's sound-based moves.", 0, 0, 0],
    FT_SAPSALVE: ["Sap-Skin Salve", "Sap-Skin Salves", 2, 700,
      "A sticky ointment of Hyphora's sap. Restores 60 HP and thaws out a frozen Pokémon.", 1, 1, 0],
    FT_RENEWALSEED: ["Seed of Renewal", "Seeds of Renewal", 2, 0,
      "A thumb-sized seed that glows from within. Plant it to revive every fainted Pokémon in your party to half HP.", 2, 0, 0],
    FT_SPORELANTERN: ["Luminescent Lantern", "Luminescent Lanterns", 8, 0,
      "A fist-sized puffball full of glowing spores. While you carry it, half as many wild Pokémon find you in caves.", 0, 0, 6],
    FT_SPORECHIME: ["Sporechime", "Sporechimes", 8, 0,
      "A wind chime grown from chitin. It tinkles when someone nearby still wants to battle you.", 0, 0, 6],
    FT_AURORALMOTE: ["Auroral Mote", "Auroral Motes", 1, 5000,
      "A bottled mote of the northern lights from the Aerie Markets. Collectors pay well for one.", 0, 0, 0],
    FT_FROSTSIGIL: ["Frostshard Sigil", "Frostshard Sigils", 8, 0,
      "A crystal that hums near the Heartroot. One of three sigils that find the White Vault's door, far in the north, and wake it.", 0, 0, 6]
  }
  RELIC_ITEM_NUMBER = 9100

  module_function

  def register_relic_items
    n = RELIC_ITEM_NUMBER
    RELIC_ITEMS.each do |id, (name, plural, pocket, price, desc, field, battle, type)|
      it = GameData::Item.new(id: id, id_number: n, name: name, name_plural: plural, pocket: pocket,
                              price: price, description: desc, field_use: field, battle_use: battle, type: type)
      it.define_singleton_method(:name) { name }
      it.define_singleton_method(:name_plural) { plural }
      it.define_singleton_method(:description) { desc }
      GameData::Item::DATA[id] = it
      GameData::Item::DATA[n] = it
      n += 1
    end
  end

  def blessing?(key) = flag?(:"blessing_#{key}")

  def grant_blessing(key, title, effect)
    return if blessing?(key)
    set_flag(:"blessing_#{key}")
    pbSEPlay("Saint7") rescue nil
    pbMessage(_INTL("\\me[Item get]You received the {1}!", title)) rescue nil
    pbMessage(_INTL("({1})", effect)) rescue nil
  end

  # Gives a relic, a goods item or a treasure, with the usual jingle.
  def give(item, qty = 1)
    pbReceiveItem(item, qty)
  rescue StandardError => e
    log("give(#{item}) failed: #{e.message}")
  end

  def ft_player_side?(battler)
    return battler.pbOwnedByPlayer? rescue false
  end
end

module GameData
  class << self
    alias ft_relics_load_all load_all unless method_defined?(:ft_relics_load_all)
    def load_all
      ft_relics_load_all
      begin
        FrostThaw.register_relic_items
      rescue StandardError => e
        FrostThaw.log("Relic items failed: #{e.message}")
      end
    end
  end
end

#-------------------------------------------------------------------------------
# The relics in battle
#-------------------------------------------------------------------------------
if defined?(BattleHandlers::DamageCalcUserItem)
BattleHandlers::DamageCalcUserItem.add(:FT_VERDANTBLADE,
  proc { |item, user, target, move, mults, baseDmg, type|
    mults[:final_damage_multiplier] *= 2 if Effectiveness.resistant?(target.damageState.typeMod)
  }
)

BattleHandlers::DamageCalcTargetItem.add(:FT_HEARTWARDENSTAFF,
  proc { |item, user, target, move, mults, baseDmg, type|
    mults[:base_damage_multiplier] /= 2 if type == :FIRE || type == :ICE
  }
)

BattleHandlers::EORHealingItem.add(:FT_HEARTWARDENSTAFF,
  proc { |item, battler, battle|
    next if !battler.canHeal? || battler.hp > battler.totalhp / 2
    used = (battle.instance_variable_get(:@ft_pulse_used) || {})
    key = battler.pokemon.personalID rescue battler.index
    next if used[key]
    used[key] = true
    battle.instance_variable_set(:@ft_pulse_used, used)
    battle.pbCommonAnimation("UseItem", battler)
    battler.pbRecoverHP(battler.totalhp / 4)
    battle.pbDisplay(_INTL("{1}'s {2} sent a Verdant Pulse through the ground!", battler.pbThis, battler.itemName))
  }
)

BattleHandlers::DamageCalcUserItem.add(:FT_RIMEMANTLE,
  proc { |item, user, target, move, mults, baseDmg, type|
    mults[:base_damage_multiplier] *= 1.2 if type == :ICE
  }
)

BattleHandlers::DamageCalcUserItem.add(:FT_WHISPERKEY,
  proc { |item, user, target, move, mults, baseDmg, type|
    mults[:base_damage_multiplier] *= 1.3 if move.soundMove?
  }
)

end

if defined?(PokeBattle_Battler) && PokeBattle_Battler.method_defined?(:takesHailDamage?)
class PokeBattle_Battler
  alias ft_relic_takesHailDamage? takesHailDamage? unless method_defined?(:ft_relic_takesHailDamage?)
  def takesHailDamage?
    return false if hasActiveItem?(:FT_RIMEMANTLE)
    return ft_relic_takesHailDamage?
  end

  # The Rime Mantle and the Blessing of Warmth keep the cold out.
  alias ft_relic_pbCanFreeze? pbCanFreeze? unless method_defined?(:ft_relic_pbCanFreeze?)
  def pbCanFreeze?(user, showMessages, move = nil)
    warm = hasActiveItem?(:FT_RIMEMANTLE) ||
           (FrostThaw.active? && FrostThaw.blessing?(:warmth) && FrostThaw.ft_player_side?(self))
    if warm && !fainted?
      @battle.pbDisplay(_INTL("{1} is kept warm! It won't freeze!", pbThis)) if showMessages
      return false
    end
    return ft_relic_pbCanFreeze?(user, showMessages, move)
  end
end

end

#-------------------------------------------------------------------------------
# Hyphora's Blessing: Plant Speech makes wild Grass and Bug Pokémon trust you
#-------------------------------------------------------------------------------
if defined?(PokeBattle_Battle) && PokeBattle_Battle.method_defined?(:pbCaptureCalc)
class PokeBattle_Battle
  alias ft_relic_pbCaptureCalc pbCaptureCalc unless method_defined?(:ft_relic_pbCaptureCalc)
  def pbCaptureCalc(pkmn, battler, catch_rate, ball)
    if FrostThaw.active? && FrostThaw.blessing?(:hyphora) && pkmn
      catch_rate ||= pkmn.species_data.catch_rate
      if pkmn.hasType?(:GRASS) || pkmn.hasType?(:BUG)
        catch_rate = [(catch_rate * 1.5).floor, 255].min
      end
    end
    return ft_relic_pbCaptureCalc(pkmn, battler, catch_rate, ball)
  end
end

end

#-------------------------------------------------------------------------------
# Goods
#-------------------------------------------------------------------------------
if defined?(ItemHandlers::UseOnPokemon)
ItemHandlers::UseOnPokemon.add(:FT_SAPSALVE, proc { |item, pkmn, scene|
  if pkmn.fainted? || (pkmn.hp == pkmn.totalhp && pkmn.status != :FROZEN)
    scene.pbDisplay(_INTL("It won't have any effect."))
    next false
  end
  thawed = pkmn.status == :FROZEN
  pkmn.heal_status if thawed
  healed = pbItemRestoreHP(pkmn, 60)
  scene.pbRefresh
  scene.pbDisplay(_INTL("{1}'s HP was restored by {2} points.", pkmn.name, healed)) if healed > 0
  scene.pbDisplay(_INTL("{1} was thawed out.", pkmn.name)) if thawed
  next true
})

ItemHandlers::BattleUseOnPokemon.add(:FT_SAPSALVE, proc { |item, pokemon, battler, choices, scene|
  if battler && battler.status == :FROZEN
    battler.pbCureStatus(false)
    scene.pbDisplay(_INTL("{1} was thawed out.", battler.pbThis))
  elsif !battler && pokemon.status == :FROZEN
    pokemon.heal_status
  end
  pbBattleHPItem(pokemon, battler, 60, scene)
  next true
})

ItemHandlers::CanUseInBattle.add(:FT_SAPSALVE, proc { |item, pokemon, battler, move, firstAction, battle, scene, showMessages|
  if !pokemon.able? || (pokemon.hp == pokemon.totalhp && pokemon.status != :FROZEN)
    scene.pbDisplay(_INTL("It won't have any effect.")) if showMessages
    next false
  end
  next true
}) if defined?(ItemHandlers::CanUseInBattle)

ItemHandlers::UseInField.add(:FT_RENEWALSEED, proc { |item|
  fainted = $Trainer.party.select { |pk| pk.fainted? }
  if fainted.empty?
    pbMessage(_INTL("It won't have any effect."))
    next 0
  end
  pbMessage(_INTL("You press the Seed of Renewal into the earth. Green light spreads out from it like ripples."))
  fainted.each do |pk|
    pk.hp = [(pk.totalhp / 2).floor, 1].max
    pk.heal_status
  end
  pbMessage(_INTL("Your fainted Pokémon got back up!"))
  next 3
})

end

#-------------------------------------------------------------------------------
# The Luminescent Lantern: half as many wild Pokémon in caves
#-------------------------------------------------------------------------------
if defined?(PokemonEncounters) && PokemonEncounters.method_defined?(:encounter_triggered?)
class PokemonEncounters
  alias ft_relic_encounter_triggered? encounter_triggered? unless method_defined?(:ft_relic_encounter_triggered?)
  def encounter_triggered?(enc_type, repel_active = false, triggered_by_step = true)
    ret = ft_relic_encounter_triggered?(enc_type, repel_active, triggered_by_step)
    if ret && triggered_by_step && FrostThaw.active? && $PokemonBag &&
       ($PokemonBag.pbHasItem?(:FT_SPORELANTERN) rescue false) &&
       (GameData::EncounterType.get(enc_type).type == :cave rescue enc_type.to_s.start_with?("Cave"))
      return false if rand(2) == 0
    end
    return ret
  end
end

end

#-------------------------------------------------------------------------------
# The Sporechime: someone here still wants a battle
#-------------------------------------------------------------------------------
module FrostThaw
  module_function

  def sporechime_check
    return if !active? || !$PokemonBag || !$game_map
    return if !($PokemonBag.pbHasItem?(:FT_SPORECHIME) rescue false)
    waiting = $game_map.events.values.count do |ev|
      ev.name.to_s.start_with?("Trainer(") && !$game_self_switches[[$game_map.map_id, ev.id, "A"]]
    end
    return if waiting == 0
    state[:chime_seen] ||= {}
    return if state[:chime_seen][$game_map.map_id] == waiting
    state[:chime_seen][$game_map.map_id] = waiting
    pbSEPlay("Saint1") rescue nil
    pbMessage(_INTL(waiting == 1 ? "The Sporechime tinkles: one trainer here still wants a battle." :
                                   "The Sporechime tinkles: {1} trainers here still want a battle.", waiting))
  end
end

# Checked on your first step on each map (not during the fade-in).
if Events.respond_to?(:onStepTaken) && Events.respond_to?(:onMapChange)
Events.onMapChange += proc { |_sender, _e| FrostThaw.instance_variable_set(:@chime_pending, true) }
Events.onStepTaken += proc { |_sender, _e|
  begin
    if FrostThaw.instance_variable_get(:@chime_pending)
      FrostThaw.instance_variable_set(:@chime_pending, false)
      FrostThaw.sporechime_check
    end
  rescue StandardError => err
    FrostThaw.log("Sporechime failed: #{err.message}")
  end
}
end

#-------------------------------------------------------------------------------
# The Blessing of Still Sky: you keep your footing on ice and snow (rootspire.md
# 1861: "ignore difficult terrain of ice/snow"). Not on the Heartroot's slick
# sap (H7, SAP_SLICK_MAPS): that isn't ice, and the channel still slides.
#-------------------------------------------------------------------------------
if defined?(pbSlideOnIce)
  alias ft_relic_pbSlideOnIce pbSlideOnIce unless defined?(ft_relic_pbSlideOnIce)
  def pbSlideOnIce
    on_sap = (defined?(FrostThaw::SAP_SLICK_MAPS) && $game_map && FrostThaw::SAP_SLICK_MAPS.include?($game_map.map_id)) rescue false
    return if FrostThaw.active? && FrostThaw.blessing?(:still_sky) && !on_sap
    ft_relic_pbSlideOnIce
  end
end
