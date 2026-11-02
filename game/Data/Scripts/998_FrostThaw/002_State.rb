#===============================================================================
# Frost & Thaw - save data
#
# Everything the story remembers lives in one hash on $PokemonGlobal, so it is
# saved with the game and old Infinite Fusion saves are untouched.
#===============================================================================
class PokemonGlobalMetadata
  attr_writer :frost_thaw

  def frost_thaw
    @frost_thaw ||= {}
    return @frost_thaw
  end
end

module FrostThaw
  module_function

  def state
    return {} if !$PokemonGlobal
    return $PokemonGlobal.frost_thaw
  end

  # True in a Frost & Thaw save.
  def active?
    return !!(state[:active])
  end

  def version;  state[:version];  end   # :frost or :thaw
  def mode;     state[:mode];     end   # :journey or :herald
  def herald;   state[:herald];   end   # Herald key in Herald Mode
  def journey?; mode == :journey;  end
  def herald?(key = nil)
    return mode == :herald if key.nil?
    return mode == :herald && herald == key
  end

  def flag?(name)
    return !!(state[:flags] && state[:flags][name])
  end

  def set_flag(name, value = true)
    state[:flags] ||= {}
    state[:flags][name] = value
  end

  def counter(name)
    return (state[:counters] && state[:counters][name]) || 0
  end

  def add_counter(name, amount = 1)
    state[:counters] ||= {}
    state[:counters][name] = counter(name) + amount
  end

  # Turns on the switch that hides the player's own Herald NPC.
  def apply_herald_switches
    HERALD_SWITCH.each { |key, sw| $game_switches[sw] = herald?(key) }
  end

  def player_display_name
    return $Trainer ? $Trainer.name : "you"
  end
end
