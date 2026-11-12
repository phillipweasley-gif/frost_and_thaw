#===============================================================================
# Frost & Thaw - your cup at the Hearth (owner's call, 2026-11-07)
#
# The rest-day coffee scene (024 hearth_coffee) asks what you drink. Each cup
# gives your team a small lift for the next few battles: every Pokemon of yours
# that comes out starts with one stat raised one stage.
#===============================================================================
module FrostThaw
  COFFEE_BATTLES = 3
  # key => [menu label, stat, what you see, what it does]
  COFFEES = {
    black:    ["Hellen's black, strong", :SPEED,
               "Hellen slides you a mug from a second pot she keeps under the bar. It could strip paint.",
               "Speed"],
    mushroom: ["Wyn's mushroom coffee", :SPECIAL_ATTACK,
               "It tastes of earth and rain, and for a moment the lanterns look a little brighter.",
               "Sp. Atk"],
    honey:    ["Honey and cream", :DEFENSE,
               "HELLEN: Honey and cream. Somebody at this table was raised right.",
               "Defense"],
    salt:     ["Corsair-style, with salt", :ATTACK,
               "Black, with a pinch of salt, the way the Corsairs drink it on the night watch.",
               "Attack"]
  }

  module_function

  def pick_coffee
    keys = COFFEES.keys
    c = (pbMessage(_INTL("(What kind of coffee for you?)"), keys.map { |k| _INTL(COFFEES[k][0]) }, -1) rescue 0)
    c = 0 if !c || c < 0
    key = keys[c]
    label, _stat, seen, word = COFFEES[key]
    lines = [seen]
    lines << "WYN: ...You picked mine." if key == :mushroom && !herald?(:wyn)
    say(lines)
    state[:coffee] = [key, COFFEE_BATTLES]
    set_flag(:"coffee_#{key}")
    pbMessage(_INTL("(For your next {1} battles, each of your Pokémon comes out with its {2} raised.)", COFFEE_BATTLES, word)) rescue nil
    log("Coffee: #{label}")
  rescue StandardError => e
    log("pick_coffee: #{e.message}")
  end

  # [stat, battles left] while the coffee lasts, else nil
  def coffee_active
    key, left = state[:coffee]
    return nil if !key || !left || left <= 0 || !COFFEES[key]
    [COFFEES[key][1], left]
  rescue StandardError
    nil
  end

  def coffee_battle_done
    key, left = state[:coffee]
    return if !key || !left || left <= 0
    left -= 1
    state[:coffee] = [key, left]
    pbMessage(_INTL("(The coffee's worn off.)")) if left == 0 rescue nil
  rescue StandardError => e
    log("coffee_battle_done: #{e.message}")
  end
end

class PokeBattle_Battle
  # (guarded: the smoke test's stub battle class has none of these)
  if method_defined?(:pbOnActiveAll)
    alias ft_coffee_pbOnActiveAll pbOnActiveAll unless method_defined?(:ft_coffee_pbOnActiveAll)
    def pbOnActiveAll
      ret = ft_coffee_pbOnActiveAll
      eachBattler { |b| ft_coffee_lift(b) }
      ret
    end
  end

  if method_defined?(:pbOnActiveOne)
    alias ft_coffee_pbOnActiveOne pbOnActiveOne unless method_defined?(:ft_coffee_pbOnActiveOne)
    def pbOnActiveOne(battler)
      ret = ft_coffee_pbOnActiveOne(battler)
      ft_coffee_lift(battler)
      ret
    end
  end

  # once per Pokemon per battle, and only for yours
  def ft_coffee_lift(battler)
    return if !FrostThaw.active? || !battler || battler.fainted? || !battler.pbOwnedByPlayer?
    stat, _left = FrostThaw.coffee_active
    return if !stat
    @ft_coffee_done ||= {}
    key = battler.pokemon.personalID rescue battler.index
    return if @ft_coffee_done[key]
    @ft_coffee_done[key] = true
    battler.pbRaiseStatStage(stat, 1, battler) if battler.pbCanRaiseStatStage?(stat, battler)
  rescue StandardError => e
    FrostThaw.log("coffee lift: #{e.message}")
  end

  if method_defined?(:pbEndOfBattle)
    alias ft_coffee_pbEndOfBattle pbEndOfBattle unless method_defined?(:ft_coffee_pbEndOfBattle)
    def pbEndOfBattle
      ret = ft_coffee_pbEndOfBattle
      FrostThaw.coffee_battle_done if FrostThaw.active? && @ft_coffee_done && !@ft_coffee_done.empty?
      ret
    end
  end
end
