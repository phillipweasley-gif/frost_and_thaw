#===============================================================================
# Frost & Thaw - new Pokémon and rebalanced Herald partner lines
#
# Every Herald's partner line is a three-stage, starter-strength line
# (about 315 -> 410 -> 530 total base stats, evolving at levels 16 and 36).
#
#   Alberica  Lutling -> Hauntello -> Chorumbra          (all new)
#   Alerion   Zorua -> Zoroark -> Rimirage               (Rimirage is new)
#   Wyn       Sableye -> Sporeye -> Myconarch           (Sporeye and Myconarch are new)
#   Paras -> Parasect -> Gloamcap stays in the game as a wild line (Gloamcap is new)
#   Yetot -> Yetitan, the yetis of Icewind Dale (both new, evolving at level 32)
#
# The new Pokémon are numbers 577-591 in the Pokédex, right after Infinite
# Fusion's last one, so they fuse with every Pokémon like any other: DNA
# Splicers, the Cocoon Chamber, wild and trainer fusions. Their own pictures
# and every fusion picture involving them live in Graphics/Battlers/FrostThaw.
#
# Infinite Fusion saves never see any of this: there the Pokédex keeps its
# usual 576 Pokémon and Zorua, Zoroark, Paras, Parasect and Sableye are unchanged.
#===============================================================================
module FrostThaw
  BASE_DEX_SIZE = 576                 # Infinite Fusion 6.8's Pokédex
  NEW_SPECIES_FIRST = BASE_DEX_SIZE + 1
  SPRITE_FOLDER = "Graphics/Battlers/FrostThaw/"

  # stats: HP, Attack, Defense, Sp. Atk, Sp. Def, Speed
  NEW_SPECIES = {
    LUTLING: {
      n: 0, template: :JIGGLYPUFF, name: "Lutling", split: ["Lut", "ling"], category: "Lute",
      types: [:NORMAL, :FAIRY],
      stats: [50, 35, 45, 60, 60, 65], evs: { SPECIAL_DEFENSE: 1 }, exp: 62,
      abilities: [:SOUNDPROOF, :CUTECHARM], hidden: [:LEVITATE], gender: :Female50Percent,
      evolves: [:HAUNTELLO, 16], cry: :JIGGLYPUFF,
      moves: [[1, :POUND], [1, :GROWL], [4, :SING], [8, :ASTONISH], [12, :DISARMINGVOICE], [16, :ROUND],
              [20, :CHARM], [24, :ECHOEDVOICE], [28, :DRAININGKISS], [32, :UPROAR], [36, :HYPERVOICE]],
      dex: "A bard's lute that something small and cheerful has moved into. It peeks out of the soundhole and strums its own strings to greet travellers."
    },
    HAUNTELLO: {
      n: 1, template: :MISDREAVUS, name: "Hauntello", split: ["Haunt", "ello"], category: "Possessed Cello",
      types: [:DARK, :FAIRY],
      stats: [65, 50, 60, 80, 75, 80], evs: { SPECIAL_ATTACK: 1, SPECIAL_DEFENSE: 1 }, exp: 142,
      abilities: [:SOUNDPROOF, :LEVITATE], hidden: [:CURSEDBODY], gender: :Female50Percent,
      prevo: [:LUTLING, 16], evolves: [:CHORUMBRA, 36], cry: :MISDREAVUS,
      moves: [[1, :WRAP], [1, :POUND], [1, :GROWL], [1, :SING], [16, :SNARL], [20, :BITE], [24, :DRAININGKISS],
              [28, :FEINTATTACK], [32, :NIGHTSHADE], [36, :HEX], [40, :DARKPULSE], [44, :PERISHSONG]],
      dex: "The spirit outgrew its lute and stretched it into a cello. It grins out of the hole it burst through, and its slipped strings reach for anyone who listens."
    },
    CHORUMBRA: {
      n: 2, template: :TENTACRUEL, name: "Chorumbra", split: ["Chor", "umbra"], category: "Black Harp",
      types: [:DARK, :FAIRY],
      stats: [85, 60, 75, 115, 95, 100], evs: { SPECIAL_ATTACK: 3 }, exp: 236,
      abilities: [:SOUNDPROOF, :LEVITATE], hidden: [:CURSEDBODY], gender: :Female50Percent,
      prevo: [:HAUNTELLO, 36], cry: :TENTACRUEL,
      moves: [[1, :WRAP], [1, :SNARL], [1, :DRAININGKISS], [1, :NASTYPLOT], [36, :CONSTRICT], [40, :DARKPULSE],
              [44, :HYPERVOICE], [48, :PERISHSONG], [52, :MOONBLAST], [56, :SPARKLINGARIA], [60, :NIGHTDAZE]],
      dex: "The spirit has burst free and wears the harp it became like a crown. Its snapped strings are its hair. Those who hear its whole song swear an oath they cannot remember making."
    },
    RIMIRAGE: {
      n: 3, template: :ZOROARK, name: "Rimirage", split: ["Rimi", "rage"], category: "Frost Mirage",
      types: [:DARK, :ICE],
      stats: [70, 88, 70, 120, 72, 110], evs: { SPECIAL_ATTACK: 2, SPEED: 1 }, exp: 236,
      abilities: [:ILLUSION], hidden: [:SNOWCLOAK],
      prevo: [:ZOROARK, 36], cry: :ZOROARK,
      moves: [[1, :ICESHARD], [1, :NIGHTDAZE], [1, :FOULPLAY], [1, :HONECLAWS], [36, :ICYWIND], [40, :AURORABEAM],
              [44, :NASTYPLOT], [48, :FREEZEDRY], [54, :ICEBEAM], [60, :BLIZZARD]],
      dex: "It wraps itself in frost-light to show its foes a winter that isn't there. Its true form is said to leave no footprints in the snow."
    },
    GLOAMCAP: {
      n: 4, template: :PARASECT, name: "Gloamcap", split: ["Gloam", "cap"], category: "Dusk Fungus",
      types: [:GRASS, :GHOST],
      stats: [85, 120, 105, 80, 105, 35], evs: { ATTACK: 2, DEFENSE: 1 }, exp: 236,
      abilities: [:EFFECTSPORE, :DRYSKIN], hidden: [:CURSEDBODY],
      prevo: [:PARASECT, 36], cry: :PARASECT,
      moves: [[1, :SHADOWSNEAK], [1, :SPORE], [1, :XSCISSOR], [1, :CURSE], [36, :HEX], [40, :SEEDBOMB],
              [44, :OMINOUSWIND], [48, :SHADOWBALL], [54, :PHANTOMFORCE], [60, :GIGADRAIN]],
      dex: "The mushroom has fully claimed its host. At dusk the husk walks the deep roots, scattering spores that glow like distant lanterns."
    },
    # The Cinderwright line: the Fire starter. A stoat whose inner furnace shapes clay, then porcelain, then metal.
    WICKIT: {
      n: 5, template: :CYNDAQUIL, name: "Wickit", split: ["Wick", "it"], category: "Spark-Tail",
      types: [:FIRE], height: 3, weight: 32,
      stats: [50, 62, 50, 42, 45, 60], evs: { SPEED: 1 }, exp: 62,
      abilities: [:BLAZE], hidden: [:TEMPERED],
      evolves: [:STOKETAIL, 16], cry: :SENTRET,
      moves: [[1, :SCRATCH], [1, :GROWL], [4, :EMBER], [8, :QUICKATTACK], [11, :SMOKESCREEN], [14, :FURYSWIPES],
              [17, :FLAMECHARGE], [20, :BITE], [24, :FLAMEWHEEL], [28, :WORKUP], [32, :FIREFANG], [36, :SLASH], [40, :FLAREBLITZ]],
      dex: "Wickit brings warm stones to people it trusts. If a stone is returned, it assumes the gift needs improvement and spends the night reshaping it."
    },
    STOKETAIL: {
      n: 6, template: :QUILAVA, name: "Stoketail", split: ["Stoke", "tail"], category: "Kiln",
      types: [:FIRE], height: 8, weight: 160,
      stats: [65, 85, 70, 50, 60, 75], evs: { ATTACK: 1, SPEED: 1 }, exp: 142,
      abilities: [:BLAZE], hidden: [:TEMPERED],
      prevo: [:WICKIT, 16], evolves: [:FORGEL, 36], cry: :FURRET,
      moves: [[1, :METALCLAW], [1, :SCRATCH], [1, :GROWL], [1, :EMBER], [1, :QUICKATTACK], [11, :SMOKESCREEN], [14, :FURYSWIPES],
              [16, :METALCLAW], [19, :FLAMECHARGE], [22, :BITE], [26, :FLAMEWHEEL], [30, :IRONDEFENSE], [34, :FIREFANG],
              [38, :HONECLAWS], [42, :SLASH], [46, :FLAREBLITZ]],
      dex: "Stoketail patches cracks in its den with kiln-fired clay. Researchers can estimate its age by counting how many times it has redesigned the entrance."
    },
    FORGEL: {
      n: 7, template: :TYPHLOSION, name: "Forgel", split: ["Forg", "el"], category: "Hearthsmith",
      types: [:FIRE, :STEEL], height: 15, weight: 780,
      stats: [85, 115, 100, 60, 80, 90], evs: { ATTACK: 2, DEFENSE: 1 }, exp: 240,
      abilities: [:BLAZE], hidden: [:TEMPERED],
      prevo: [:STOKETAIL, 36], cry: :TYPHLOSION,
      moves: [[1, :HEARTHFORGE], [1, :SCRATCH], [1, :EMBER], [1, :METALCLAW], [1, :FIREFANG], [36, :HEARTHFORGE],
              [40, :IRONDEFENSE], [44, :IRONHEAD], [48, :HEATCRASH], [52, :HEAVYSLAM], [56, :FLAREBLITZ]],
      dex: "Forgel builds warm shelters that endure for generations. A small, uneven bowl is often found at the centre of its den, carefully preserved from its days as a Wickit."
    },
    # Wyn's line: Sableye -> Sporeye -> Myconarch. Underdark imps taken in by the myconid courts beneath Rootspire.
    SPOREYE: {
      n: 8, template: :SABLEYE, name: "Sporeye", split: ["Spor", "eye"], category: "Glowcap",
      types: [:DARK, :GHOST], height: 6, weight: 140,
      stats: [65, 75, 75, 70, 70, 55], evs: { ATTACK: 1, SPECIAL_DEFENSE: 1 }, exp: 142,
      abilities: [:KEENEYE, :EFFECTSPORE], hidden: [:PRANKSTER],
      prevo: [:SABLEYE, 16], evolves: [:MYCONARCH, 36, :FTGodspark], cry: :SABLEYE,   # (only once Wyn holds the shadow's godspark, SC 7A.06)
      moves: [[1, :LEER], [1, :SCRATCH], [1, :ASTONISH], [1, :ABSORB], [16, :STUNSPORE], [19, :SHADOWSNEAK],
              [22, :MEGADRAIN], [26, :CONFUSERAY], [30, :POWERGEM], [34, :HEX], [38, :GIGADRAIN], [42, :SHADOWBALL]],
      dex: "Spores drifting up from the Underdark settled in its gems and sprouted. It tends the little glowing caps as jealously as it once hoarded jewels."
    },
    MYCONARCH: {
      n: 9, template: :BRELOOM, name: "Myconarch", split: ["Myco", "narch"], category: "Sovereign",
      types: [:GHOST, :GRASS], height: 16, weight: 620,
      stats: [85, 80, 90, 110, 105, 60], evs: { SPECIAL_ATTACK: 2, SPECIAL_DEFENSE: 1 }, exp: 240,
      abilities: [:EFFECTSPORE, :TELEPATHY], hidden: [:PRANKSTER],
      prevo: [:SPOREYE, 36], cry: :BRELOOM,
      moves: [[1, :SPORE], [1, :POWERGEM], [1, :HEX], [1, :GIGADRAIN], [36, :CALMMIND], [40, :SHADOWBALL],
              [44, :ENERGYBALL], [48, :LEECHSEED], [52, :PSYCHIC], [58, :PHANTOMFORCE]],
      dex: "A sovereign of the myconid courts beneath Rootspire. It speaks through a haze of rapport spores; those who breathe it share its thoughts, and sometimes its memories, while the haze lingers."
    },
    # The yeti line of Icewind Dale: Yetot -> Yetitan (designed from the user's concept sheet).
    YETOT: {
      n: 10, template: :TEDDIURSA, name: "Yetot", split: ["Ye", "tot"], category: "Snow Cub",
      types: [:ICE, :NORMAL], height: 7, weight: 290,
      stats: [60, 65, 50, 30, 45, 50], evs: { ATTACK: 1 }, exp: 66,
      abilities: [:ICEBODY, :PICKUP], hidden: [:IRONFIST], gender: :Female50Percent,
      evolves: [:YETITAN, 32], cry: :TEDDIURSA,
      moves: [[1, :SCRATCH], [1, :GROWL], [4, :POWDERSNOW], [8, :FURYSWIPES], [12, :ICESHARD], [16, :ICYWIND],
              [20, :FAKEOUT], [24, :AVALANCHE], [28, :THRASH], [32, :ICEPUNCH], [36, :BODYSLAM], [40, :BLIZZARD]],
      dex: "Yetot cubs pack snowballs before they can walk properly and throw them at anything that moves, mostly to see it move again. A cub that is lost cries in a voice that carries for miles across the tundra, and the whole family answers."
    },
    YETITAN: {
      n: 11, template: :URSARING, name: "Yetitan", split: ["Yeti", "tan"], category: "Yeti",
      types: [:ICE, :FIGHTING], height: 26, weight: 3600,
      stats: [100, 125, 85, 45, 70, 75], evs: { ATTACK: 2 }, exp: 175,
      abilities: [:INTIMIDATE, :ICEBODY], hidden: [:IRONFIST], gender: :Female50Percent,
      prevo: [:YETOT, 32], cry: :URSARING,
      moves: [[1, :ICEPUNCH], [1, :SCRATCH], [1, :GROWL], [1, :POWDERSNOW], [1, :FURYSWIPES], [12, :ICESHARD],
              [16, :ICYWIND], [20, :FAKEOUT], [24, :AVALANCHE], [28, :THRASH], [32, :ICEPUNCH], [36, :SCARYFACE],
              [40, :BRICKBREAK], [44, :BODYSLAM], [48, :HAMMERARM], [52, :ICEHAMMER], [58, :SUPERPOWER]],
      dex: "Ice grows over its forearms in plates harder than stone, and one look from its eyes can freeze a hunter where he stands. It fears only fire. A Yetitan will cross a whole mountain range to bring back a cub that was taken."
    },
    # Act III's bosses (never caught: they're here so they can have their own pictures)
    CHARDALYN: {
      n: 12, template: :DRAGONITE, name: "Chardalyn", split: ["Charda", "lyn"], category: "Black Crystal",
      types: [:DRAGON, :STEEL], height: 90, weight: 9999,
      stats: [120, 125, 120, 115, 95, 80], evs: { ATTACK: 3 }, exp: 300,
      abilities: [:PRESSURE, :FILTER], hidden: [:INTIMIDATE], gender: :Genderless, cry: :DRAGONITE,
      moves: [[1, :DRAGONCLAW], [1, :IRONTAIL], [1, :SCARYFACE], [20, :FLASHCANNON], [30, :DRAGONBREATH],
              [40, :DRAGONPULSE], [50, :IRONHEAD], [55, :HYPERBEAM], [60, :OUTRAGE]],
      dex: "A dragon of black chardalyn crystal and mirror glass, built in a forge under the roots. Its breath is a line of light. It was always meant to fly on its own."
    },
    AURIL_CRONE: {
      n: 13, template: :NOCTOWL, name: "Cold Crone", split: ["Cold", "Crone"], category: "Frostmaiden",
      types: [:ICE, :DARK], height: 21, weight: 600,
      stats: [110, 95, 100, 115, 110, 90], evs: { SPECIAL_ATTACK: 3 }, exp: 300,
      abilities: [:PRESSURE, :SNOWWARNING], hidden: [:INSOMNIA], gender: :AlwaysFemale, cry: :NOCTOWL,
      moves: [[1, :ICEBEAM], [1, :DARKPULSE], [1, :HYPNOSIS], [1, :BLIZZARD], [40, :NIGHTSLASH], [50, :HAIL], [60, :SHEERCOLD]],
      dex: "The Frostmaiden as the Dale's oldest stories tell her: an old woman in furs who is an owl, a wolf and a goat at once, and none of them kindly."
    },
    AURIL_REWRITTEN: {
      n: 14, template: :FROSLASS, name: "Rewritten Auril", split: ["Rewrit", "ten"], category: "Frostmaiden",
      types: [:ICE, :GHOST], height: 19, weight: 400,
      stats: [130, 90, 110, 130, 120, 100], evs: { SPECIAL_ATTACK: 3 }, exp: 340,
      abilities: [:PRESSURE, :CURSEDBODY], hidden: [:SNOWWARNING], gender: :AlwaysFemale, cry: :FROSLASS,
      moves: [[1, :ICEBEAM], [1, :SHADOWBALL], [1, :BLIZZARD], [1, :WILLOWISP], [50, :HEX], [60, :SHEERCOLD], [65, :DESTINYBOND]],
      dex: "A woman made of three hearts of ice: for a moment Shimmer's face, then Alberica's, then no one's. Everything she loved, she kept."
    }
  }

  # A new ability and a new move for the Cinderwright line.
  NEW_ABILITIES = {
    TEMPERED: { template: :BLAZE, name: "Tempered",
                description: "The first time it's hit by a Fire-type move after entering battle, its Defense rises." }
  }
  NEW_MOVES = {
    HEARTHFORGE: { template: :IRONHEAD, name: "Hearthforge", function_code: "FTHearthforge", type: :STEEL,
                   base_damage: 80, accuracy: 100, total_pp: 10, effect_chance: 0,
                   description: "Heats its tail, braces, and strikes with a forging blow. In harsh sunlight it also raises the user's Defense." }
  }

  # Names used by test builds, kept so those saves still load.
  OLD_SPECIES_NAMES = { CHIMELET: :LUTLING, DIRGEBELL: :HAUNTELLO, FRETSHADE: :HAUNTELLO }

  # Existing Pokémon reshaped into starter-strength lines (Frost & Thaw saves only).
  SPECIES_PATCHES = {
    ZORUA:    { stats: [45, 55, 40, 75, 40, 60], evolutions: [[:ZOROARK, :Level, 16, false]] },
    ZOROARK:  { stats: [58, 72, 55, 92, 55, 78],
                evolutions: [[:RIMIRAGE, :Level, 36, false], [:ZORUA, :Level, 16, true]] },
    PARAS:    { stats: [50, 75, 60, 50, 55, 25], evolutions: [[:PARASECT, :Level, 16, false]] },
    PARASECT: { stats: [65, 95, 80, 60, 80, 30],
                evolutions: [[:GLOAMCAP, :Level, 36, false], [:PARAS, :Level, 16, true]] },
    SABLEYE:  { stats: [50, 60, 60, 50, 55, 40], evolutions: [[:SPOREYE, :Level, 16, false]] }
  }

  STAT_KEYS = [:HP, :ATTACK, :DEFENSE, :SPECIAL_ATTACK, :SPECIAL_DEFENSE, :SPEED]

  module_function

  def new_species_number(key)
    NEW_SPECIES_FIRST + NEW_SPECIES[key][:n]
  end

  def new_species_by_number(num)
    return nil if !num.is_a?(Integer) || num < NEW_SPECIES_FIRST
    NEW_SPECIES.each_key { |k| return k if new_species_number(k) == num }
    nil
  end

  def new_species?(num)
    !new_species_by_number(num).nil?
  end

  def stat_hash(list)
    STAT_KEYS.each_with_index.map { |k, i| [k, list[i]] }.to_h
  end

  # New abilities and moves, built from similar real ones (numbers above the game's own).
  def register_moves_and_abilities
    next_num = (GameData::Ability::DATA.values.map(&:id_number).max || 0) + 1
    NEW_ABILITIES.each do |key, d|
      next if GameData::Ability::DATA[key]
      a = GameData::Ability.get(d[:template]).clone
      { id: key, id_number: next_num, real_name: d[:name], real_description: d[:description] }.each { |k, v| a.instance_variable_set("@#{k}", v) }
      GameData::Ability::DATA[key] = a; GameData::Ability::DATA[next_num] = a
      next_num += 1
    end
    next_num = (GameData::Move::DATA.values.map(&:id_number).max || 0) + 1
    NEW_MOVES.each do |key, d|
      next if GameData::Move::DATA[key]
      m = GameData::Move.get(d[:template]).clone
      { id: key, id_number: next_num, real_name: d[:name], function_code: d[:function_code], type: d[:type],
        base_damage: d[:base_damage], accuracy: d[:accuracy], total_pp: d[:total_pp], effect_chance: d[:effect_chance],
        real_description: d[:description] }.each { |k, v| m.instance_variable_set("@#{k}", v) }
      GameData::Move::DATA[key] = m; GameData::Move::DATA[next_num] = m
      next_num += 1
    end
  rescue StandardError => e
    log("New moves/abilities failed to register: #{e.class}: #{e.message}")
  end

  def our_ability_or_move?(id)
    NEW_ABILITIES.key?(id) || NEW_MOVES.key?(id)
  end

  # Sporeye only becomes a Myconarch once the Shadow Mycolith's godspark has
  # settled on Wyn (SC 7A.06): level 36 or more, and the spark.
  if defined?(GameData::Evolution) && !(GameData::Evolution.exists?(:FTGodspark) rescue false)
    GameData::Evolution.register({
      id: :FTGodspark,
      parameter: Integer,
      level_up_proc: proc { |pkmn, parameter| next pkmn.level >= parameter && FrostThaw.flag?(:godspark_shadow) }
    })
  end

  # Builds the new species from a similar real one, then registers them.
  def register_species
    register_moves_and_abilities
    NEW_SPECIES.each do |key, d|
      tmpl = GameData::Species.get(d[:template])
      sp = tmpl.clone
      num = new_species_number(key)
      evs = STAT_KEYS.map { |k| [k, 0] }.to_h.merge(d[:evs] || {})
      evos = []
      evos << [d[:evolves][0], d[:evolves][2] || :Level, d[:evolves][1], false] if d[:evolves]
      evos << [d[:prevo][0], :Level, d[:prevo][1], true] if d[:prevo]
      {
        id: key, id_number: num, species: key, form: 0,
        real_name: d[:name], real_form_name: nil, real_category: d[:category], real_pokedex_entry: d[:dex],
        type1: d[:types][0], type2: d[:types][1] || d[:types][0],
        base_stats: stat_hash(d[:stats]), evs: evs, base_exp: d[:exp],
        growth_rate: :Parabolic, catch_rate: 45, happiness: 70,
        moves: d[:moves], tutor_moves: (tmpl.tutor_moves || []).dup, egg_moves: [],
        abilities: d[:abilities], hidden_abilities: d[:hidden], evolutions: evos,
        gender_ratio: d[:gender] || tmpl.gender_ratio
      }.each { |ivar, v| sp.instance_variable_set("@#{ivar}", v) }
      sp.instance_variable_set(:@height, d[:height]) if d[:height]
      sp.instance_variable_set(:@weight, d[:weight]) if d[:weight]
      GameData::Species::DATA[key] = sp
      GameData::Species::DATA[num] = sp
    end
    OLD_SPECIES_NAMES.each { |old, new| GameData::Species::DATA[old] = GameData::Species::DATA[new] }
    register_split_names
    log("Registered #{NEW_SPECIES.size} new Pokémon.")
  rescue StandardError => e
    log("New Pokémon failed to register: #{e.class}: #{e.message}")
  end

  # Fusion names are built from a front half and a back half of each name.
  def register_split_names
    return if !defined?(GameData::SPLIT_NAMES) || !defined?(GameData::NAT_DEX_MAPPING)
    lists = [:SPLIT_NAMES, :SPLIT_NAMES_FRENCH, :SPLIT_NAMES_CHINESE].map { |c|
      GameData.const_defined?(c) ? GameData.const_get(c) : nil }.compact
    NEW_SPECIES.each do |key, d|
      num = new_species_number(key)
      next if GameData::NAT_DEX_MAPPING[num]
      index = GameData::SPLIT_NAMES.length
      lists.each { |l| l[index] = d[:split] }
      GameData::NAT_DEX_MAPPING[num] = index
    end
  rescue StandardError => e
    log("Fusion names failed to register: #{e.class}: #{e.message}")
  end

  # The Pokédex grows by the new Pokémon only while a Frost & Thaw save is being played.
  def set_dex_size(size)
    return if Settings::NB_POKEMON == size
    [Settings, Object].each do |owner|
      owner.send(:remove_const, :NB_POKEMON) if owner.const_defined?(:NB_POKEMON, false)
      owner.const_set(:NB_POKEMON, size)
    end
    if Object.const_defined?(:CONST_NB_POKE, false)
      Object.send(:remove_const, :CONST_NB_POKE)
      Object.const_set(:CONST_NB_POKE, size)
    end
    log("Pokédex size is now #{size}.")
  end

  # Applies (or undoes) everything Frost & Thaw changes about Pokémon, to match the save in play.
  def apply_species_patches(on)
    set_dex_size(on ? BASE_DEX_SIZE + NEW_SPECIES.size : BASE_DEX_SIZE)
    @species_originals ||= {}
    return if @species_patched == on
    SPECIES_PATCHES.each do |key, patch|
      sp = GameData::Species.try_get(key) rescue nil
      next if !sp
      @species_originals[key] ||= { base_stats: sp.base_stats, evolutions: sp.evolutions }
      if on
        sp.instance_variable_set(:@base_stats, stat_hash(patch[:stats]))
        sp.instance_variable_set(:@evolutions, patch[:evolutions])
      else
        orig = @species_originals[key]
        sp.instance_variable_set(:@base_stats, orig[:base_stats])
        sp.instance_variable_set(:@evolutions, orig[:evolutions])
      end
    end
    @species_patched = on
    rename_old_species if on
    ($Trainer.party.each { |pk| pk.calc_stats rescue nil } if $Trainer) rescue nil
    log("Herald partner lines #{on ? 'rebalanced' : 'restored'}.")
  rescue StandardError => e
    log("Species patch failed: #{e.class}: #{e.message}")
  end

  # Pokémon caught in test builds under an older name get their final name.
  def rename_old_species
    mons = []
    mons.concat($Trainer.party) if $Trainer
    if $PokemonStorage
      ($PokemonStorage.maxBoxes rescue 0).times do |b|
        ($PokemonStorage.maxPokemon(b) rescue 0).times { |i| mons << $PokemonStorage[b, i] }
      end
    end
    mons.compact.each do |pk|
      sp = pk.instance_variable_get(:@species)
      pk.instance_variable_set(:@species, OLD_SPECIES_NAMES[sp]) if OLD_SPECIES_NAMES[sp]
    end
  rescue StandardError => e
    log("Rename failed: #{e.class}: #{e.message}")
  end

  # Where the pictures are.
  def base_sprite_path(num)
    "#{SPRITE_FOLDER}base/#{num}"
  end

  # Seen from behind, for your own Pokémon in battle (stored mirrored: the game flips it back).
  def back_sprite_path(num)
    "#{SPRITE_FOLDER}back/#{num}"
  end

  def fusion_sprite_path(head, body)
    "#{SPRITE_FOLDER}fusions/#{head}/#{head}.#{body}"
  end

  def our_sprite_path(pif_sprite)
    return nil if !pif_sprite
    head, body = pif_sprite.head_id, pif_sprite.body_id
    if body.nil? || pif_sprite.type == :BASE
      return new_species?(head) ? base_sprite_path(head) : nil
    end
    return nil if !new_species?(head) && !new_species?(body) &&
                  !(defined?(OWN_FUSION_SPRITES) && OWN_FUSION_SPRITES.include?([head, body]))
    fusion_sprite_path(head, body)
  end
end

# Every picture of a new Pokémon, or of a fusion with one, comes from our folder.
class BattleSpriteLoader
  def ft_claim(pif_sprite)
    path = FrostThaw.our_sprite_path(pif_sprite)
    if path
      path = pbResolveBitmap(path) || path
      pif_sprite.local_path = path
      pif_sprite.alt_letter = ""
    end
    pif_sprite
  end

  alias ft_orig_select_new_pif_base_sprite select_new_pif_base_sprite unless method_defined?(:ft_orig_select_new_pif_base_sprite)
  def select_new_pif_base_sprite(dex_number)
    ft_claim(ft_orig_select_new_pif_base_sprite(dex_number))
  end

  alias ft_orig_select_new_pif_fusion_sprite select_new_pif_fusion_sprite unless method_defined?(:ft_orig_select_new_pif_fusion_sprite)
  def select_new_pif_fusion_sprite(head_id, body_id)
    ft_claim(ft_orig_select_new_pif_fusion_sprite(head_id, body_id))
  end

  alias ft_orig_load_pif_sprite_directly load_pif_sprite_directly unless method_defined?(:ft_orig_load_pif_sprite_directly)
  def load_pif_sprite_directly(pif_sprite)
    ft_orig_load_pif_sprite_directly(ft_claim(pif_sprite))
  end

  alias ft_orig_obtain_fusion_pif_sprite obtain_fusion_pif_sprite unless method_defined?(:ft_orig_obtain_fusion_pif_sprite)
  def obtain_fusion_pif_sprite(head_id, body_id)
    ft_claim(ft_orig_obtain_fusion_pif_sprite(head_id, body_id))
  end

  alias ft_orig_load_base_sprite load_base_sprite unless method_defined?(:ft_orig_load_base_sprite)
  def load_base_sprite(dex_number)
    if FrostThaw.new_species?(dex_number)
      path = pbResolveBitmap(FrostThaw.base_sprite_path(dex_number))
      return AnimatedBitmap.new(path) if path
    end
    ft_orig_load_base_sprite(dex_number)
  end
end

# Names and descriptions of the new ability and move (the game's text files don't have them).
module GameData
  [Ability, Move].each do |klass|
    klass.class_eval do
      alias_method :ft_orig_name, :name unless method_defined?(:ft_orig_name)
      def name
        return @real_name if FrostThaw.our_ability_or_move?(@id)
        ft_orig_name
      end
      alias_method :ft_orig_description, :description unless method_defined?(:ft_orig_description)
      def description
        return @real_description if FrostThaw.our_ability_or_move?(@id)
        ft_orig_description
      end
    end
  end
end

# Tempered: the first Fire-type hit after it enters battle raises its Defense.
if defined?(BattleHandlers)
  BattleHandlers::AbilityOnSwitchIn.add(:TEMPERED,
    proc { |ability, battler, battle|
      battler.instance_variable_set(:@ft_tempered_used, false)
    }
  )
  BattleHandlers::TargetAbilityOnHit.add(:TEMPERED,
    proc { |ability, user, target, move, battle|
      next if move.calcType != :FIRE
      next if target.instance_variable_get(:@ft_tempered_used)
      target.instance_variable_set(:@ft_tempered_used, true)
      target.pbRaiseStatStageByAbility(:DEFENSE, 1, target, true, GameData::Ability.get(ability).name)
    }
  )
end

# Hearthforge: a Steel-type forging blow; in harsh sunlight it also raises the user's Defense.
if defined?(PokeBattle_Move)
  class PokeBattle_Move_FTHearthforge < PokeBattle_Move
    def pbEffectAfterAllHits(user, target)
      return if user.fainted?
      return unless [:Sun, :HarshSun].include?(@battle.pbWeather)
      user.pbRaiseStatStage(:DEFENSE, 1, user) if user.pbCanRaiseStatStage?(:DEFENSE, user, self)
    end
  end
end

# Your own Pokémon is shown from behind in battle when we have drawn its back: our new Pokémon,
# and fusions with a drawn back (the yeti fusions). Everything else keeps the mirrored front.
module FrostThaw
  def self.fusion_back_sprite_path(head, body)
    "#{SPRITE_FOLDER}back/fusions/#{head}/#{head}.#{body}"
  end

  def self.our_back_path(pkmn)
    d = pkmn.species_data
    if defined?(GameData::FusedSpecies) && d.is_a?(GameData::FusedSpecies)
      h = d.head_pokemon.id_number; b = d.body_pokemon.id_number
      return nil if !new_species?(h) && !new_species?(b)
      return pbResolveBitmap(fusion_back_sprite_path(h, b))
    end
    num = d.id_number
    new_species?(num) ? pbResolveBitmap(back_sprite_path(num)) : nil
  rescue StandardError
    nil
  end
end

module GameData
  class Species
    class << self
      alias ft_orig_sprite_bitmap_from_pokemon sprite_bitmap_from_pokemon unless method_defined?(:ft_orig_sprite_bitmap_from_pokemon)
      def sprite_bitmap_from_pokemon(pkmn, back = false, species = nil)
        # a boss with its own picture (FrostThaw.named_mon, Avarice's last body)
        if !back && pkmn && !species && (pic = (pkmn.instance_variable_get(:@ft_picture) rescue nil))
          path = (pbResolveBitmap("Graphics/Battlers/FrostThaw/bosses/#{pic}") rescue nil)
          return AnimatedBitmap.new(path) if path
        end
        if back && pkmn && !species && !(pkmn.egg? rescue false)
          num = (pkmn.species_data.id_number rescue nil)
          path = num && FrostThaw.our_back_path(pkmn)
          if path
            bmp = AnimatedBitmap.new(path)
            bmp.shiftAllColors(num, pkmn.body_shiny, pkmn.head_shiny) if pkmn.shiny? rescue nil
            bmp.scale_bitmap(pkmn.sprite_scale) rescue nil
            return bmp
          end
        end
        ft_orig_sprite_bitmap_from_pokemon(pkmn, back, species)
      end
    end
  end
end

# The Pokédex "shared bodies" pairs are the four special Pokémon at 573-576,
# wherever the end of the Pokédex is.
if defined?(PokemonPokedexInfo_Scene) && PokemonPokedexInfo_Scene.method_defined?(:get_shared_bodies)
  class PokemonPokedexInfo_Scene
    alias ft_orig_get_shared_bodies get_shared_bodies unless method_defined?(:ft_orig_get_shared_bodies)
    def get_shared_bodies
      b = FrostThaw::BASE_DEX_SIZE
      sp = ->(n) { GameData::Species.get(n).species }
      { sp[b - 3] => sp[b - 1], sp[b - 1] => sp[b - 3], sp[b - 2] => sp[b], sp[b] => sp[b - 2] }
    end
  end
end

# Cries: the new Pokémon borrow the cry of the Pokémon they were shaped from.
module GameData
  class Species
    class << self
      alias ft_orig_check_cry_file check_cry_file unless method_defined?(:ft_orig_check_cry_file)
      def check_cry_file(species, form)
        data = (GameData::Species.get(species) rescue nil)
        if data
          head = data.is_fusion ? (GameData::Species.get(getHeadID(data)) rescue nil) : data
          d = head && FrostThaw::NEW_SPECIES[head.id]
          return ft_orig_check_cry_file(d[:cry], form) if d
        end
        ft_orig_check_cry_file(species, form)
      end
    end
  end
end

# Infinite Fusion saves keep Cocoon Fusion's donors to the usual Pokédex.
if defined?(CocoonFusion::Trainers) && CocoonFusion::Trainers.respond_to?(:max_donor_dex)
  module CocoonFusion
    module Trainers
      class << self
        alias ft_orig_max_donor_dex max_donor_dex unless method_defined?(:ft_orig_max_donor_dex)
        def max_donor_dex
          return FrostThaw::BASE_DEX_SIZE if !FrostThaw.active?
          ft_orig_max_donor_dex
        end
      end
    end
  end
end

Events.onMapSceneChange += proc { |_sender, _e|
  FrostThaw.apply_species_patches(FrostThaw.active?)
}

# Loading a save switches everything over before anything is shown.
if defined?(SaveData) && SaveData.respond_to?(:load_all_values)
  module SaveData
    class << self
      alias ft_orig_load_all_values load_all_values unless method_defined?(:ft_orig_load_all_values)
      def load_all_values(save_data)
        ft_orig_load_all_values(save_data)
        FrostThaw.apply_species_patches(FrostThaw.active?)
      end
    end
  end
end

# The Continue screen shows the save's party: size the Pokédex for that save first.
if defined?(PokemonLoadScreen) && PokemonLoadScreen.method_defined?(:load_save_file)
  class PokemonLoadScreen
    alias ft_orig_load_save_file load_save_file unless method_defined?(:ft_orig_load_save_file)
    def load_save_file(file_path)
      data = ft_orig_load_save_file(file_path)
      g = data.is_a?(Hash) ? data[:global_metadata] : nil
      ft = g.respond_to?(:frost_thaw) ? g.frost_thaw : nil
      FrostThaw.set_dex_size(ft.is_a?(Hash) && ft[:active] ? FrostThaw::BASE_DEX_SIZE + FrostThaw::NEW_SPECIES.size : FrostThaw::BASE_DEX_SIZE) rescue nil
      data
    end
  end
end
