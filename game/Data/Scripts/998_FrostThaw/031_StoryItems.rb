#===============================================================================
# Frost & Thaw - story key items (script: Systemic text, item table)
#
# Registered with the relics (027_Relics.rb), so their numbers follow on.
# Also the Wheel: a hidden count of the times the party kept things moving
# rather than freezing or breaking them. It never locks anything; at 4 or more
# the Third Way's epilogue gains its last scene.
#===============================================================================
module FrostThaw
  RELIC_ITEMS.merge!(
    FT_MOONEGG: ["Moon-Touched Egg", "Moon-Touched Eggs", 8, 0,
      "A warm green-gold egg. It needs a name to wake. It hums when Reptin speaks.", 0, 0, 6],
    FT_FROSTEGG: ["Frost Egg", "Frost Eggs", 8, 0,
      "An egg of pale ice with Shimmer's heart inside it. It won't hatch. Sometimes it hums four notes.", 0, 0, 6],
    FT_GOLDENACORN: ["Golden Acorn", "Golden Acorns", 8, 0,
      "An acorn of real gold, warm as a hand. \"It was always meant to go north.\"", 0, 0, 6],
    FT_HEARTOFICE: ["Heart of Ice", "Hearts of Ice", 8, 0,
      "Shimmer's heart of ice. It beats once a minute, and breathes out mist.", 0, 0, 6],
    FT_UNDYINGROSE: ["Undying Rose", "Undying Roses", 8, 0,
      "A cutting of a rose frozen mid-bloom. It never wilts. Warm to the touch.", 0, 0, 6],
    FT_ORDERLOCKET: ["Order's Locket", "Order's Lockets", 8, 0,
      "Half sun, half moon. A portrait of Alberica, older. She's never been here.", 0, 0, 6],
    FT_BALANUSSEED: ["Seed of Balanus", "Seeds of Balanus", 8, 0,
      "A fossilised seed from the bottom of the Tainted Lake. Heavy as a stone, and very faintly warm.", 0, 0, 6],
    FT_ROOTKEY: ["Root-Key", "Root-Keys", 8, 0,
      "A key of black ice. Summer gave Winter a copy, to keep her quiet. It opens a door of iron and glass.", 0, 0, 6],
    FT_DAWNFANG: ["Dawnfang", "Dawnfangs", 8, 0,
      "The Rimefang, reforged in a better fire. Gold now, not blue. Warm, like a hand.", 0, 0, 6],
    FT_GARAGAIAXE: ["Garagai's Axe-head", "Garagai's Axe-heads", 8, 0,
      "The head of a giant's axe, rimed with old frost. Reptin swore to bring it home.", 0, 0, 6]
  )

  module_function

  # One more turn of the Wheel (or one less).
  def wheel(amount = 1)
    add_counter(:wheel, amount)
  end

  # Gives a story key item quietly if you already have it, with the jingle if not.
  def give_key(item)
    return if ($PokemonBag.pbHasItem?(item) rescue false)
    pbReceiveItem(item)
  rescue StandardError => e
    log("give_key(#{item}) failed: #{e.message}")
  end

  def has_key?(item)
    ($PokemonBag.pbHasItem?(item) rescue false) ? true : false
  end

  def take_key(item)
    $PokemonBag.pbDeleteItem(item) if ($PokemonBag.pbHasItem?(item) rescue false)
  rescue StandardError => e
    log("take_key(#{item}) failed: #{e.message}")
  end
end
