#===============================================================================
# Pokémon Frost & Thaw - settings
#
# A new story that runs inside Pokémon Infinite Fusion 6.8.x, alongside the
# Cocoon Fusion mod. Choose "Pokémon Frost & Thaw" when starting a New Game.
# Its maps live in Data/FrostThaw; nothing in the base game is changed.
#===============================================================================
module FrostThaw
  VERSION = "0.7.5"

  MAP_FOLDER   = "Data/FrostThaw"
  FIRST_MAP_ID = 2000          # every map id from here up belongs to Frost & Thaw

  MAPS = {
    intro: 2000, targos: 2001, tavern: 2002, center: 2003, luskan: 2004,
    gym: 2005, hut_a: 2006, mart: 2007, hut_b: 2008, hut_c: 2009
  }

  MAP_NAMES = {
    2000 => "Frost & Thaw", 2001 => "Targos", 2002 => "Three Flags Sailing",
    2003 => "Targos Pokémon Center", 2004 => "The Luskan Arms",
    2005 => "Targos Town Hall", 2006 => "Thornweald's Relics", 2007 => "Triglio",
    2008 => "Fisher's Cottage", 2009 => "Lantern House"
  }

  # Where a new game begins (the intro map), then where Targos begins.
  INTRO_START  = [2000, 9, 7]
  TARGOS_START = [2001, 33, 21, 2]   # at the end of the long pier, facing the town
  # Where you wake up after losing a battle, until you heal somewhere else:
  # the Targos Pokémon Center, in front of the nurse.
  FIRST_CENTER = [2003, 10, 7, 8]

  # Game switches turned on when the player IS that Herald (hides their NPC).
  HERALD_SWITCH = { alberica: 3901, reptin: 3902, alerion: 3903, meat_meat: 3904, wyn: 3905 }

  # Heralds. :chapter_ready marks whose Herald Mode start exists in this build.
  # Each Herald's signature partner (change the :NAME after "starter:" to swap one;
  # nil lets that Herald pick from the three starters instead):
  #   Alberica  Lutling   -> Hauntello -> Chorumbra   the haunted lute, cello and harp (new, see 013_Species)
  #   Reptin    Bulbasaur -> Ivysaur -> Venusaur
  #   Alerion   Zorua     -> Zoroark -> Rimirage      the illusion fox, wrapped in frost
  #   Meat Meat Noibat    -> Noivern
  #   Wyn       Sableye   -> Sporeye -> Myconarch     an Underdark imp taken in by the myconid courts
  HERALDS = {
    alberica:  { name: "Alberica",            gender: 1, starter: :LUTLING,       chapter_ready: true,
                 blurb: ["Dwarf bard, the Dwarf of Song. Her Pendant of Black Ice will not stay lost.",
                         "\"Write it down. No, sing it. Paper burns.\""] },
    reptin:    { name: "Reptin",              gender: 0, starter: :BULBASAUR, chapter_ready: true,
                 blurb: ["Elf druid, exile of the Sacred Flame. His Medallion of Everfrost hums near frost magic.",
                         "\"Winter has a place. Just not all of it.\""] },
    alerion:   { name: "Alerion Froststride", gender: 0, starter: :ZORUA,       chapter_ready: true,
                 blurb: ["Eladrin ranger, a fey elf, once frozen outside of time.",
                         "His Frostbound Ring knows this place.",
                         "\"No.\""] },
    meat_meat: { name: "Meat Meat",           gender: 1, starter: :NOIBAT,   chapter_ready: true,
                 start: [2001, 20, 23, 4],   # already in Targos, behind the hay bales
                 blurb: ["Goblin rogue. Long white hair, violet eyes, other people's pockets.",
                         "Hiding in Targos for weeks, running from dreams of a cold table.",
                         "\"Meat Meat will bite you. Fondly.\""] },
    wyn:       { name: "Wyn",                 gender: 2, starter: :SABLEYE,     chapter_ready: true,
                 blurb: ["Spores druid and Rootwarden of Rootspire, 400 years after the Heralds.",
                         "On watch at the Sap Gate, Wyn falls through an old mirror shard into the Heralds' time.",
                         "\"...Um. Hello. Sorry. Hello.\""] }
  }

  # How each Herald looks when you play as them (Infinite Fusion outfit pieces;
  # colours are hue shifts in degrees). Matches art/cast.py.
  HERALD_LOOKS = {
    alberica:  { female: true,  skin: 4, hair: "6_boxbraids", clothes: "fantasyadventurersoutfit", hat: "beret", hat_color: 300 },
    reptin:    { female: false, skin: 5, hair: "2_wavy", clothes: "grassexpert" },
    alerion:   { female: false, skin: 1, hair: "4_lady", clothes: "iceoutfit" },
    meat_meat: { female: true,  skin: 7, hair: "4_pigtails", clothes: "gothhoodie", hat: "goggles" },   # 7 = goblin green
    wyn:       { female: false, skin: 2, hair: "8_shortcut", clothes: "ghostoutfit", hat: "parashroom", hat_color: 230 }
  }

  # Ice, Grass and Fire starters forming a fair triangle: Ice/Water beats Fire,
  # Fire beats Grass/Steel, Grass/Steel beats Ice/Water. Ice and Grass are Twinning
  # fusions; Fire is Wickit, the first of the new Cinderwright line (013_Species).
  # Fusion ids are :B<body dex>H<head dex>.
  STARTERS = [
    { species: :B7H220,  label: "Ice",   note: "Ice / Water (Swinub head, Squirtle body; evolves into Pilotle, then Pilotoise)" },
    { species: :B330H152, label: "Grass", note: "Grass / Steel (Chikorita head, Pawniard body; evolves into Bayiard, then Megasharp)" },
    { species: :WICKIT,  label: "Fire",  note: "Fire (Wickit, the Spark-Tail Pokémon; evolves into Stoketail, then Fire/Steel Forgel)" }
  ]
  STARTER_LEVEL = 5

  # Opening moves for first partners whose level-5 moves have no attack of
  # their own type (found by playing the battles: Switle started with only
  # Normal and Ground moves). Each list is what they know when you get them.
  STARTER_MOVES = {
    B7H220:    [:TACKLE, :TAILWHIP, :WATERGUN, :POWDERSNOW],     # Switle
    B330H152:  [:SCRATCH, :LEER, :VINEWHIP, :METALCLAW],         # Chikoiard
    BULBASAUR: [:TACKLE, :GROWL, :VINEWHIP],                     # Reptin's partner
    NOIBAT:    [:TACKLE, :SUPERSONIC, :GUST, :ABSORB],           # Meat Meat's partner
    SABLEYE:   [:SCRATCH, :LEER, :ASTONISH]                      # Wyn's partner
  }

  def self.starter_pokemon(species)
    pkmn = Pokemon.new(species, STARTER_LEVEL)
    pkmn.ability_index = 0 if defined?(STARTER_ABILITIES) && STARTER_ABILITIES[species]   # the starter's signature ability
    moves = STARTER_MOVES[species]
    if moves
      begin
        pkmn.forget_all_moves
        moves.each { |m| pkmn.learn_move(m) }
      rescue StandardError => e
        log("Starter moves for #{species} skipped: #{e.message}")
      end
    end
    pkmn
  end

  BAG_START_LIMIT = 20         # kinds of item per pocket until Pip sews more room
  KEY_ITEMS_POCKET = 8         # never limited

  def self.log(message)
    line = "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} [Frost & Thaw] #{message}"
    echoln(line) rescue nil
    File.open("FrostThaw.log", "a") { |f| f.puts(line) } rescue nil
  end
end

FT = FrostThaw unless defined?(FT)
