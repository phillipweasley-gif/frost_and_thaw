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
    pbMessage(_INTL("Four hundred years ago, a winter that would not end gripped Icewind Dale..."))

    # Version
    loop do
      v = pbMessage(_INTL("Which version?"),
                    [_INTL("Pokémon Frost"), _INTL("Pokémon Thaw"), _INTL("What's the difference?")], -1)
      if v == 2
        pbMessage(_INTL("Both tell the whole story."))
        pbMessage(_INTL("Frost follows Auril and her faithful most closely, and Frostina is on its cover."))
        pbMessage(_INTL("Thaw follows Avarice most closely, and Razzilith is on its cover."))
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
                    [_INTL("New Journey"), _INTL("Herald Mode"), _INTL("What's the difference?")], -1)
      if m == 2
        pbMessage(_INTL("New Journey: you're a kid from Rootspire, four hundred years after the Heralds."))
        pbMessage(_INTL("On the festival night, you fall back through time into their story."))
        pbMessage(_INTL("Herald Mode: you play one of the Heralds of Dawn and Dusk, living their own story."))
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
      choose_appearance
    end
    if herald?
      $Trainer.name = HERALDS[herald][:name]
    end
    apply_herald_switches

    # Difficulty
    d = pbMessage(_INTL("Choose a difficulty."), [_INTL("Easy"), _INTL("Normal"), _INTL("Hard")], 1)
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

    pbReceiveItem(:POKEBALL, 5) rescue nil
    pbReceiveItem(:POTION, 2) rescue nil

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
    pbMessage(_INTL("Rootspire, the city under the World Tree. The year 400 of the Verdant Reversal."))
    pbMessage(_INTL("This morning is the Festival of Returning Light."))
    pbMessage(_INTL("Every lantern in the city is lit for the Heralds of Dawn and Dusk."))
  end

  # SC 0.06 - The ship north (Alberica, Reptin, Alerion)
  def herald_prologue
    h = HERALDS[herald]
    case herald
    when :meat_meat then return meat_meat_prologue(h)
    when :wyn       then return wyn_prologue
    end
    pbMessage(_INTL("Icewind Dale. The Everlasting Rime has held it for two years."))
    case herald
    when :alberica
      pbMessage(_INTL("Karkoloch, three weeks ago. You threw the Pendant of Black Ice into the sea."))
      pbMessage(_INTL("You woke with it on the pillow beside you. Most things you throw out don't come back."))
      pbMessage(_INTL("(Men, mostly.)"))
      pbMessage(_INTL("The ship scrapes ice. Blue lanterns drift on the water."))
      pbMessage(_INTL("Something too tall stands at the edge of the lamplight. When you look again, it's gone."))
      pbMessage(_INTL("(Drink first. Panic later. That's the order.)"))
    when :reptin
      pbMessage(_INTL("The Medallion of Everfrost came wrapped in cloth. \"Left for you.\" No name, no note."))
      pbMessage(_INTL("(Rude, frankly.)"))
      pbMessage(_INTL("The captain watches it like it might bite. \"It knows,\" he says, and won't say what."))
      pbMessage(_INTL("(He'll tell you by the third drink. Everybody does, eventually.)"))
    when :alerion
      pbMessage(_INTL("You woke calling out in a voice that wasn't yours. Ice on your knuckles again."))
      pbMessage(_INTL("The Frostbound Ring gets colder every mile north."))
      pbMessage(_INTL("(It's cold. That's all you know.)"))
    end
    pbMessage(_INTL("Ahead, the lanterns of Targos flicker on the shore of Maer Dualdon."))
    if h[:starter]
      pkmn = starter_pokemon(h[:starter])
      pbAddPokemonSilent(pkmn)
      pbMessage(_INTL("Your partner, {1}, is with you, as always.", pkmn.speciesName))
    else
      pbMessage(_INTL("Your partner travels with you. Which one is it?"))
      choose_starter
    end
  end

  # SC 0.07 - Hiding in the hay. Meat Meat doesn't arrive by ship: she's already in Targos.
  def meat_meat_prologue(h)
    pbMessage(_INTL("Targos. The Everlasting Rime has held Icewind Dale for two years."))
    pbMessage(_INTL("Three weeks out of the lab. Three weeks in the hay with Razzy."))
    pbMessage(_INTL("Razzy can't talk any more. Razzy holds your hand all night anyway."))
    pbMessage(_INTL("(Meat Meat holds back. Meat Meat promised.)"))
    pbMessage(_INTL("Tonight Razzy is gone. Small footprints in the snow, going north."))
    pbMessage(_INTL("On the dock, five strangers come down a gangplank."))
    pbMessage(_INTL("Something on them is cold. Cold like the lab."))
    pbMessage(_INTL("(Strangers have food. Maybe coffee. Meat Meat will follow them. Fondly.)"))
    pkmn = starter_pokemon(h[:starter])
    pbAddPokemonSilent(pkmn)
    pbMessage(_INTL("Your {1} chirps from the rafters. It found you the night you ran, and it never left.", pkmn.speciesName))
  end

  # SC 0.05 - Wyn's watch. Wyn starts four hundred years later, at the Sap Gate,
  # and falls through a mirror shard into the Targos of the Heralds' own time.
  def wyn_prologue
    backdrop(:rootspire)
    pbMessage(_INTL("Rootspire. The year 400 of the Verdant Reversal. The Festival of Returning Light."))
    if HERALDS[:wyn][:starter]
      pkmn = starter_pokemon(HERALDS[:wyn][:starter])
      pbAddPokemonSilent(pkmn)
    else
      choose_starter
    end
    pbMessage(_INTL("The festival is somebody else's tonight."))
    pbMessage(_INTL("You have the Sap Gate, the hum of the spores, and Sableye snoring on your boot."))
    pbMessage(_INTL("(It's nice. Quiet. ...Um. Happy festival, everyone.)"))
    pbMessage(_INTL("The ground shudders. The spores go silent all at once."))
    pbMessage(_INTL("(Oh. Oh, no. They never go quiet.)"))
    backdrop(:mirror)
    pbMessage(_INTL("In the bark of the gate is a shard of old mirror you've walked past a thousand times."))
    pbMessage(_INTL("It's showing a dock in a blizzard."))
    pbMessage(_INTL("(That's not ours. That's...)"))
    backdrop(:dale)
    pbMessage(_INTL("The cold comes in, and the dark, and then the snow."))
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
