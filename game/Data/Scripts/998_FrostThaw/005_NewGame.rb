#===============================================================================
# Frost & Thaw - starting a new game
#
# "New Game" now asks which adventure to start. Infinite Fusion starts exactly
# as before; Frost & Thaw starts on its own intro map, where an autorun event
# runs FrostThaw.intro (choices, appearance, first Pokémon), then moves on.
#===============================================================================
module Game
  class << self
    alias ft_orig_start_new start_new unless method_defined?(:ft_orig_start_new)
    def start_new(*args)
      choice = 0
      begin
        choice = pbMessage(_INTL("Which adventure would you like to begin?"),
                           [_INTL("Pokémon Infinite Fusion"), _INTL("Pokémon Frost & Thaw")], 0)
      rescue StandardError => e
        FrostThaw.log("Adventure choice failed, starting Infinite Fusion: #{e.message}")
        choice = 0
      end
      return ft_orig_start_new(*args) if choice != 1
      FrostThaw.start_new_game
    end
  end
end

module FrostThaw
  module_function

  def start_new_game
    if $game_map && $game_map.events
      $game_map.events.each_value { |event| event.clear_starting }
    end
    $game_temp.common_event_id = 0 if $game_temp
    $PokemonTemp.begunNewGame = true
    pbMapInterpreter&.clear rescue nil
    pbMapInterpreter&.setup(nil, 0, 0) rescue nil
    $scene = Scene_Map.new
    SaveData.load_new_game_values
    $PokemonGlobal.frost_thaw = {
      active: true, flags: {}, counters: {}, bag_limit: BAG_START_LIMIT,
      mod_version: VERSION
    }
    set_first_center
    apply_species_patches(true)
    map_id, x, y = INTRO_START
    $MapFactory = PokemonMapFactory.new(map_id)
    $game_player.moveto(x, y)
    $game_player.refresh
    $PokemonEncounters = PokemonEncounters.new
    $PokemonEncounters.setup($game_map.map_id)
    $game_map.autoplay
    $game_map.update
    begin
      onStartingNewGame()
    rescue StandardError => e
      log("onStartingNewGame skipped: #{e.message}")
    end
    log("New Frost & Thaw game started (#{VERSION}).")
  end

  # Runs on the intro map. Every choice the story needs before Targos.
  def intro
    begin
      pbChangePlayer(0)
      pbShuffleItems rescue nil
      pbShuffleTMs rescue nil
      Kernel.initRandomTypeArray() rescue nil
    rescue StandardError => e
      log("Base intro setup: #{e.message}")
    end

    $game_player.transparent = true      # no placeholder outfit on screen
    backdrop(:dale)
    pbMessage(_INTL("POKÉMON FROST & THAW"))
    pbMessage(_INTL("Four hundred years ago, a winter that would not end gripped Icewind Dale."))
    pbMessage(_INTL("A few strangers walked into it. They came out the other side with spring."))

    # Version
    loop do
      v = pbMessage(_INTL("Which version?"),
                    [_INTL("Pokémon Frost"), _INTL("Pokémon Thaw"), _INTL("What's the difference?")], -1)
      if v == 2
        pbMessage(_INTL("Both tell the whole story."))
        pbMessage(_INTL("Frost follows Auril, the goddess of winter. Its cover: Frostina, an ice dragon."))
        pbMessage(_INTL("Thaw follows Avarice, a mage with her own plans. Its cover: Razzilith, a spring dragon."))
        pbMessage(_INTL("Some wild Pokémon appear in only one version."))
        next
      end
      next if v < 0
      state[:version] = (v == 0) ? :frost : :thaw
      break
    end

    # Mode
    loop do
      m = pbMessage(_INTL("How would you like to play?"),
                    [_INTL("New Journey (start here)"), _INTL("Herald Mode"), _INTL("What's the difference?")], -1)
      if m == 2
        pbMessage(_INTL("New Journey: you're a Rootspire kid, and a festival lantern throws you back 400 years."))
        pbMessage(_INTL("Herald Mode: you ARE one of the legends, from their first night in the Dale."))
        next
      end
      next if m < 0
      state[:mode] = (m == 0) ? :journey : :herald
      break
    end

    if herald?
      choose_herald
    end

    # Appearance and name
    if herald?
      apply_herald_look
    else
      pbMessage(_INTL("You're a kid from Rootspire, and today you get your first Pokémon. Who are you?"))
      choose_appearance
    end
    if herald?
      $Trainer.name = HERALDS[herald][:name]
    end
    apply_herald_switches

    # Difficulty
    d = 1
    loop do
      d = pbMessage(_INTL("Choose a difficulty."),
                    [_INTL("Easy"), _INTL("Normal"), _INTL("Hard"), _INTL("What's the difference?")], 1)
      break if d != 3
      pbMessage(_INTL("Normal is the game as it's meant to be played. Easy plays much the same, for now."))
      pbMessage(_INTL("Hard: other trainers' Pokémon are a tenth higher in level, and one boss brings a friend."))
    end
    d = 1 if d < 0
    $game_switches[SWITCH_GAME_DIFFICULTY_EASY] = (d == 0)
    $game_switches[SWITCH_GAME_DIFFICULTY_HARD] = (d == 2)
    begin
      $Trainer.selected_difficulty = d
      $Trainer.lowest_difficulty = d if !$Trainer.lowest_difficulty
      $Trainer.game_mode = 0          # classic rules
    rescue StandardError => e
      log("Difficulty setup: #{e.message}")
    end

    # The Pokédex comes from Epheris Thornweald, the running shoes (snowshoes)
    # from the trapper in the Pokémon Center - both in Targos.
    $Trainer.has_pokedex = false rescue nil
    $Trainer.has_running_shoes = false rescue nil

    if journey?
      journey_prologue
    else
      herald_prologue
    end

    # (New Journey: Wynsnow hands these over after your first battle, 030_Prologue.rb.)
    if !journey?
      pbReceiveItem(:POKEBALL, 5) rescue nil
      pbReceiveItem(:POTION, 2) rescue nil
    end

    set_flag(:intro_done)
    clear_backdrop
    $game_player.transparent = false
    start = if journey?
              PROLOGUE_START
            else
              (herald? && HERALDS[herald][:start]) || TARGOS_START
            end
    transfer(*start)
  end

  def choose_appearance
    without_backdrop do
      begin
        menu = CharacterSelectionMenuView.new
        menu.start
        setupStartingOutfit()
      rescue StandardError => e
        log("Character menu skipped: #{e.message}")
        pbTrainerName
      end
    end
  end

  # Herald Mode: you look like the Herald, no character menu needed.
  def apply_herald_look
    look = HERALD_LOOKS[herald]
    pbSet(VAR_TRAINER_GENDER, look[:female] ? GENDER_FEMALE : GENDER_MALE) rescue nil
    begin
      setupStartingOutfit()
    rescue StandardError => e
      log("Starting outfit: #{e.message}")
    end
    $Trainer.skin_tone     = look[:skin]
    $Trainer.hair          = look[:hair]
    $Trainer.hair_color    = 0
    $Trainer.clothes       = look[:clothes]
    $Trainer.clothes_color = look[:clothes_color] || 0
    $Trainer.hat           = look[:hat]
    $Trainer.hat_color     = look[:hat_color] || 0
    $Trainer.hat2          = nil
    [[:unlock_clothes, look[:clothes]], [:unlock_hat, look[:hat]]].each do |m, id|
      $Trainer.send(m, id, true) if id rescue nil
    end
    $game_player.refresh rescue nil
  rescue StandardError => e
    log("Herald look failed: #{e.message}")
  end

  def choose_herald
    keys = HERALDS.keys
    pbMessage(_INTL("The Heralds of Dawn and Dusk. Strangers, once, who met in that winter."))
    loop do
      labels = keys.map { |k| HERALDS[k][:chapter_ready] ? HERALDS[k][:name] : _INTL("{1} (later chapter)", HERALDS[k][:name]) }
      i = pbMessage(_INTL("Which Herald are you?"), labels, -1)
      next if i < 0
      key = keys[i]
      h = HERALDS[key]
      Array(h[:blurb]).each { |l| pbMessage(_INTL(l)) }
      if !h[:chapter_ready]
        pbMessage(_INTL("{1}'s story starts in a part of the game that isn't built yet. Choose another Herald for now.", h[:name]))
        next
      end
      next if !pbConfirmMessage(_INTL("Play as {1}?", h[:name]))
      state[:herald] = key
      break
    end
  end

  # New Journey: a short title card, then you wake at the Rooted Hearth on the
  # festival morning (030_Prologue.rb takes it from there). Your first Pokémon
  # comes from Professor Wynsnow at the College.
  def journey_prologue
    backdrop(:rootspire)
    pbMessage(_INTL("Rootspire, the city under the World Tree. Year 400 since the tree grew, all in one night."))
    pbMessage(_INTL("This morning is the Festival of Returning Light."))
    pbMessage(_INTL("Every lantern in the city is lit for the Heralds of Dawn and Dusk."))
  end

  # SC 0.06 - The ship north (Alberica, Reptin, Alerion). Each opening gives
  # the Herald's want in their own voice, shows the partner doing something, and
  # saves the tavern's punchlines for 1.03 (context/00.md H1-H3).
  RIME_BOX = "Icewind Dale. Two years now the winter hasn't let go. They call it the Everlasting Rime."
  SHIP_AHEAD = "Ahead, Targos, the biggest town on the lake. Its lanterns are the only warmth for miles."

  def herald_prologue
    h = HERALDS[herald]
    case herald
    when :meat_meat then return meat_meat_prologue(h)
    when :wyn       then return wyn_prologue
    end
    pbMessage(_INTL(RIME_BOX))
    pkmn = nil
    if h[:starter]
      pkmn = starter_pokemon(h[:starter])
      pbAddPokemonSilent(pkmn)
    end
    mon = pkmn ? pkmn.speciesName : nil
    partner = lambda do |line|
      Stage.cry(pkmn.species) if pkmn
      pbMessage(_INTL(line))
    end
    case herald
    when :alberica
      pbMessage(_INTL("The ship scrapes ice. Blue lanterns drift on the water."))
      pbMessage(_INTL("Three weeks ago, in Karkoloch, you threw a pendant of black ice into the sea."))
      pbMessage(_INTL("You woke with it on the pillow beside you, cold as the day you found it."))
      pbMessage(_INTL("(It pulls north, like a dog on a lead. Fine. North it is. North has taverns.)"))
      pbMessage(_INTL("(The family's bargain with Auril. This thing's part of it. Nobody ever said the price.)"))
      pbMessage(_INTL("(I'd like to know what we paid before somebody comes to collect.)"))
      partner.call("Your #{mon} twangs one sour note on its own strings. It hates the cold more than you do.") if mon
      pbMessage(_INTL("Something too tall stands at the edge of the lamplight. When you look again, it's gone."))
      pbMessage(_INTL("(Drink first. Panic later. That's the order.)"))
    when :reptin
      pbMessage(_INTL("The Medallion of Everfrost came to your door wrapped in cloth. \"Left for you.\" No name."))
      pbMessage(_INTL("(Someone with excellent taste and no manners at all.)"))
      pbMessage(_INTL("It fogs near frost magic. On this ship it hasn't cleared since the coast."))
      pbMessage(_INTL("The captain watches it like it might bite. \"It knows,\" he says, and won't say what."))
      pbMessage(_INTL("(The Sacred Flame cast me out for fixing something. They called it breaking. Same thing.)"))
      partner.call("Your #{mon} sneezes at the snow and burrows deeper into your coat.") if mon
    when :alerion
      pbMessage(_INTL("You woke calling out in a voice that wasn't yours. Ice on your knuckles again."))
      pbMessage(_INTL("(The name was Talion. Talion's dead. Dreams don't change that.)"))
      pbMessage(_INTL("The Frostbound Ring was on the dock rail when you boarded. It's colder every mile north."))
      partner.call("Your #{mon} sleeps against your boots, wearing the shape of a snowdrift.") if mon
    end
    pbMessage(_INTL(SHIP_AHEAD))
    if !pkmn
      pbMessage(_INTL("Your partner travels with you. Which one is it?"))
      choose_starter
    end
  end

  # SC 0.07 - Hiding in the hay. Meat Meat doesn't arrive by ship: she's already
  # in Targos. The strangers on the dock are shown on the map in 1.01, not here.
  def meat_meat_prologue(h)
    pbMessage(_INTL("Targos. Two years now the winter hasn't let go. They call it the Everlasting Rime."))
    pbMessage(_INTL("Three weeks out of the lab. Three weeks in the hay with Razzy."))
    pbMessage(_INTL("Razzy was in the next cage at the lab. Smaller than you. He used to talk."))
    pbMessage(_INTL("Razzy can't talk any more. Razzy holds your hand all night anyway."))
    pbMessage(_INTL("(Meat Meat doesn't cry. Meat Meat promised Razzy.)"))
    pbMessage(_INTL("Tonight Razzy is gone. Small footprints in the snow, going toward the south gate."))
    pbMessage(_INTL("The gate's shut. Speaker's guards. Nobody leaves Targos in lottery season."))
    pkmn = starter_pokemon(h[:starter])
    pbAddPokemonSilent(pkmn)
    Stage.cry(pkmn.species)
    pbMessage(_INTL("Your {1} chirps from the rafters. It found you the night you ran, and it never left.", pkmn.speciesName))
    side_goal(:razzy, "Meat Meat's own: Razzy's footprints, out past the south gate.", done: :met_razzy)
  end

  # SC 0.05 - Wyn's watch. Wyn starts four hundred years later, at the Sap Gate,
  # and falls through a mirror shard into the Targos of the Heralds' own time.
  # Sableye grabs a sliver of the shard on the way (Epheris reads it in 1.04).
  def wyn_prologue
    backdrop(:rootspire)
    pbMessage(_INTL("Rootspire. The year 400 of the Verdant Reversal. The Festival of Returning Light."))
    pkmn = nil
    if HERALDS[:wyn][:starter]
      pkmn = starter_pokemon(HERALDS[:wyn][:starter])
      pbAddPokemonSilent(pkmn)
    else
      choose_starter
    end
    pbMessage(_INTL("The festival is somebody else's tonight."))
    pbMessage(_INTL("(Everyone's up top singing about the Heralds. Somebody has to mind the door.)"))
    Stage.cry(pkmn.species) if pkmn
    pbMessage(_INTL("You have the Sap Gate, the hum of the spores, and Sableye snoring on your boot."))
    pbMessage(_INTL("(Nothing comes up through the Sap Gate on my watch. Nothing's ever tried.)"))
    pbMessage(_INTL("(It's nice. Quiet. ...Um. Happy festival, everyone.)"))
    pbMessage(_INTL("The ground shudders. The spores go silent all at once."))
    pbMessage(_INTL("(Oh. Oh, no. They never go quiet.)"))
    backdrop(:mirror)
    pbMessage(_INTL("In the bark of the gate is a shard of old mirror you've walked past a thousand times."))
    pbMessage(_INTL("It's showing a dock in a blizzard."))
    pbMessage(_INTL("(That's not ours. That's...)"))
    Stage.cry(pkmn.species) if pkmn
    pbMessage(_INTL("Sableye wakes and grabs at the shard. Something bright. It won't let go."))
    backdrop(:dale)
    pbMessage(_INTL("The cold comes in, and the dark, and then the snow. Sableye's claws stay shut."))
    set_flag(:fell_through)
  end

  def choose_starter
    loop do
      labels = STARTERS.map { |s| s[:label] }
      i = pbMessage(_INTL("Which Pokémon?"), labels, -1)
      next if i < 0
      s = STARTERS[i]
      name = (GameData::Species.get(s[:species]).name rescue s[:label])
      begin
        without_backdrop { show_starter(s[:species], name) }
      rescue StandardError => e
        log("Starter preview failed: #{e.message}")
      end
      pbMessage(_INTL("{1}: {2}.", name, s[:note]))
      next if !pbConfirmMessage(_INTL("Choose {1}?", name))
      pkmn = starter_pokemon(s[:species])
      pbAddPokemonSilent(pkmn)
      state[:starter] = s[:species]
      pbMessage(_INTL("\\me[Pkmn get]{1} received {2}!", $Trainer.name, name))
      break
    end
  end

  # Full-screen scene art behind the story text (Graphics/Pictures/FrostThaw).
  SCENE_MUSIC = {
    dale:      "mountsilver",                        # the frozen Dale
    rootspire: "fullmoonIsland",                     # the festival, 400 years later
    mirror:    "newmoonIsland"                       # falling through the glass
  }

  def backdrop(name)
    pbBGMPlay(SCENE_MUSIC[name]) if SCENE_MUSIC[name] rescue nil
    clear_backdrop
    @backdrop_vp = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @backdrop_vp.z = 10
    @backdrop = Sprite.new(@backdrop_vp)
    @backdrop.bitmap = RPG::Cache.load_bitmap("Graphics/Pictures/FrostThaw/", "scene_#{name}")
  rescue StandardError => e
    log("Backdrop #{name} failed: #{e.message}")
  end

  def clear_backdrop
    @backdrop.dispose if @backdrop && !@backdrop.disposed?
    @backdrop_vp.dispose if @backdrop_vp && !@backdrop_vp.disposed?
    @backdrop = @backdrop_vp = nil
  end

  def without_backdrop
    @backdrop_vp.visible = false if @backdrop_vp && !@backdrop_vp.disposed?
    yield
  ensure
    @backdrop_vp.visible = true if @backdrop_vp && !@backdrop_vp.disposed?
  end

  # Same as an event's Transfer Player command (with fade): the map changes as
  # soon as the current event finishes.
  def transfer(map_id, x, y, dir = 2)
    $game_temp.player_transferring   = true
    $game_temp.player_new_map_id     = map_id
    $game_temp.player_new_x          = x
    $game_temp.player_new_y          = y
    $game_temp.player_new_direction  = dir
    Graphics.freeze
    $game_temp.transition_processing = true
    $game_temp.transition_name       = ""
  end
end
