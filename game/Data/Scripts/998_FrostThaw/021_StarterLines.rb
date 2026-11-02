#===============================================================================
# Frost & Thaw - starter lines evolve like a regular starter
#
# A fusion normally evolves whenever either half would (Chikorita's head at 16,
# Bayleef's at 32, Pawniard's body at 52), which gives odd levels. The Grass
# and Ice starters instead each follow one fixed path:
#
#   Chikoiard (Lv 5) -> Bayiard at 16 -> Megasharp at 36
#   Switle    (Lv 5) -> Pilotle at 16 -> Pilotoise at 36
#
# At 16 only the head grows up; at 36 both halves do.
# An Everstone still stops it, as usual.
#===============================================================================
module FrostThaw
  # species => [level, evolves into]; nil means it doesn't evolve any further
  STARTER_EVOLUTIONS = {
    B330H152: [16, :B330H153],   # Chikoiard -> Bayiard (only the head grows up)
    B330H153: [36, :B331H154],   # Bayiard -> Megasharp (both halves)
    B331H154: nil,               # Megasharp is the final form
    B7H220:   [16, :B7H221],     # Switle -> Pilotle (Swinub head becomes Piloswine)
    B7H221:   [36, :B9H221],     # Pilotle -> Pilotoise (Squirtle body becomes Blastoise)
    B8H220:   [36, :B9H221],     # Switortle (from saves made before this rule) -> Pilotoise
    B9H221:   nil                # Pilotoise is the final form (no Mamoswine)
  }

  # Its two regular abilities, the same at every stage: Defiant first (what a
  # new starter gets), Overgrow with an Ability Capsule.
  STARTER_ABILITIES = { B330H152: [:DEFIANT, :OVERGROW], B330H153: [:DEFIANT, :OVERGROW], B331H154: [:DEFIANT, :OVERGROW] }

  # Pictures we ship for these fusions so the game always shows the designs
  # that were chosen (Graphics/Battlers/FrostThaw/fusions/<head>/<head>.<body>.png).
  OWN_FUSION_SPRITES = [[152, 330], [153, 330], [154, 331]]

  module_function

  def own_fusion_sprite?(head, body)
    OWN_FUSION_SPRITES.include?([head, body])
  end

  # Saves that picked the old Grass starter (Chikomite: Chikorita head on a
  # Magnemite body) get the new line instead, at the stage that fits its level.
  # Its level, experience, nickname, held item and stats training are kept;
  # Electric moves it no longer suits become Steel/Grass moves.
  OLD_GRASS_HEADS  = [:CHIKORITA, :BAYLEEF, :MEGANIUM]
  OLD_GRASS_BODIES = [:MAGNEMITE, :MAGNETON, :MAGNEZONE]

  def repair_grass_starter
    return if !active? || !$Trainer
    return if state[:starter] != :B81H152 || state[:grass_line_v2]
    mons = $Trainer.party.dup
    if $PokemonStorage
      ($PokemonStorage.maxBoxes rescue 0).times do |b|
        ($PokemonStorage.maxPokemon(b) rescue 0).times { |i| mons << $PokemonStorage[b, i] }
      end
    end
    pk = mons.compact.find do |m|
      d = m.species_data
      d.is_a?(GameData::FusedSpecies) &&
        OLD_GRASS_HEADS.include?(d.head_pokemon.species) && OLD_GRASS_BODIES.include?(d.body_pokemon.species) &&
        (m.owner.id == $Trainer.id rescue true)
    end
    if pk
      old_name, lv = pk.name, pk.level
      pk.species = lv >= 36 ? :B331H154 : (lv >= 16 ? :B330H153 : :B330H152)
      pk.level = lv if pk.level != lv     # same level even if the new line grows at another rate
      pk.ability_index = 0                # Defiant
      pk.pif_sprite = nil if pk.respond_to?(:pif_sprite=)    # forget the old picture
      replacements = [:METALCLAW, :VINEWHIP, :RAZORLEAF, :FURYCUTTER].reject { |mv| pk.hasMove?(mv) }
      pk.moves.each_with_index do |mv, i|
        next if !mv || GameData::Move.get(mv.id).type != :ELECTRIC
        rep = replacements.shift or next
        pk.moves[i] = Pokemon::Move.new(rep)
      end
      pk.calc_stats
      log("Grass starter #{old_name} is now #{pk.name} (#{pk.species}).")
    end
    state[:starter] = :B330H152
    state[:grass_line_v2] = true
  end
end

if defined?(Pokemon) && Pokemon.method_defined?(:ability_id) && Pokemon.method_defined?(:check_evolution_on_level_up)
class Pokemon
  alias ft_orig_ability_id ability_id unless method_defined?(:ft_orig_ability_id)
  def ability_id
    list = FrostThaw::STARTER_ABILITIES[@species]
    if list && (FrostThaw.active? rescue false) && ability_index < 2
      return list[ability_index] || list[0]
    end
    ft_orig_ability_id
  end

  alias ft_orig_check_evolution_on_level_up check_evolution_on_level_up unless method_defined?(:ft_orig_check_evolution_on_level_up)
  def check_evolution_on_level_up(prompt_choice = true)
    if FrostThaw::STARTER_EVOLUTIONS.key?(@species) && (FrostThaw.active? rescue false)
      rule = FrostThaw::STARTER_EVOLUTIONS[@species]
      return nil if !rule || hasItem?(:EVERSTONE)
      return level >= rule[0] ? rule[1] : nil
    end
    ft_orig_check_evolution_on_level_up(prompt_choice)
  end
end
end

Events.onMapSceneChange += proc { |_sender, _e|
  begin
    FrostThaw.repair_grass_starter
  rescue StandardError => err
    FrostThaw.log("Grass starter repair failed: #{err.message}")
  end
}
