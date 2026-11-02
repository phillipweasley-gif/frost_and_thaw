#===============================================================================
# Frost & Thaw - keeping you inside Frost & Thaw
#
# Losing a battle sends you to the last Pokémon Center you used. A new Frost &
# Thaw game starts with the Targos Pokémon Center as that place, so you never
# wake up in Infinite Fusion's Pallet Town. And if a Frost & Thaw save ever
# finds itself on an Infinite Fusion map anyway, it is carried back to Targos.
#===============================================================================
module FrostThaw
  module_function

  def set_first_center
    map_id, x, y, dir = FIRST_CENTER
    $PokemonGlobal.pokecenterMapId     = map_id
    $PokemonGlobal.pokecenterX         = x
    $PokemonGlobal.pokecenterY         = y
    $PokemonGlobal.pokecenterDirection = dir
  end

  def own_map?(map_id)
    return map_id && map_id >= FIRST_MAP_ID
  end

  def center_ok?
    return own_map?($PokemonGlobal.pokecenterMapId)
  end

  # Called whenever a map scene starts (moving between maps, loading a save).
  def rescue_if_lost
    return if !active? || !$game_map || own_map?($game_map.map_id)
    return if $game_temp.player_transferring
    set_first_center if !center_ok?
    log("Found a Frost & Thaw save on Infinite Fusion map #{$game_map.map_id}; returning to Targos.")
    $game_temp.player_transferring  = true
    $game_temp.player_new_map_id    = $PokemonGlobal.pokecenterMapId
    $game_temp.player_new_x         = $PokemonGlobal.pokecenterX
    $game_temp.player_new_y         = $PokemonGlobal.pokecenterY
    $game_temp.player_new_direction = $PokemonGlobal.pokecenterDirection
    $Trainer.heal_party rescue nil
  end
end

module FrostThaw
  module_function

  # True if the tile itself can be stood on (same rule the map checks use).
  def tile_walkable?(x, y)
    m = $game_map
    return false if !m || !m.valid?(x, y)
    pas = m.instance_variable_get(:@passages)
    pri = m.instance_variable_get(:@priorities)
    return true if !pas || !pri
    [2, 1, 0].each do |z|
      id = m.data[x, y, z]
      next if !id || id == 0
      return false if pas[id] & 0x0f == 0x0f
      return true if pri[id] == 0
    end
    return true
  end

  # Where older versions of rebuilt maps put the player, and where that place is
  # now. A door from a map still in memory (or an old save) may use the old spot.
  LEGACY_ARRIVALS = {
    2001 => { [36, 14] => [8, 13], [11, 26] => [15, 18], [9, 14] => [14, 28], [33, 26] => [25, 31],
              [16, 12] => [4, 35], [18, 26] => [4, 27], [42, 12] => [34, 35], [40, 25] => [16, 38],
              [24, 35] => [33, 21], [24, 1] => [8, 42], [25, 1] => [9, 42] },
    2012 => { [9, 13] => [10, 22], [34, 11] => [17, 16], [9, 28] => [17, 11], [32, 28] => [34, 32],
              [39, 28] => [39, 30], [22, 11] => [31, 20], [22, 37] => [9, 43], [23, 37] => [10, 43],
              [22, 4] => [22, 2], [23, 4] => [23, 2] }
  }

  def remap_legacy_arrival
    return if !active? || !$game_map || !$game_player
    x, y = $game_player.x, $game_player.y
    to = (LEGACY_ARRIVALS[$game_map.map_id] || {})[[x, y]]
    return if !to
    return if tile_walkable?(x, y) && walkable_area(x, y) >= 40     # still a fine place to stand
    $game_player.moveto(to[0], to[1])
    log("Old arrival point on map #{$game_map.map_id} moved to (#{to[0]},#{to[1]}).")
  end

  # Size of the walkable area reachable from (x, y), counted up to `limit`.
  def walkable_area(x, y, limit = 80)
    seen = { [x, y] => true }
    queue = [[x, y]]
    count = 0
    until queue.empty?
      cx, cy = queue.shift
      count += 1
      return count if count >= limit
      [[0, 1], [1, 0], [-1, 0], [0, -1]].each do |dx, dy|
        n = [cx + dx, cy + dy]
        next if seen[n] || !tile_walkable?(*n)
        seen[n] = true
        queue << n
      end
    end
    return count
  end

  # When a map is rebuilt between versions, a save (or a door from a map that
  # was still in memory) may put the player on water, inside a wall, or on a
  # little island cut off from the town. Move them to the nearest tile that is
  # part of a real walkable area.
  def unstick_player
    return if !active? || !$game_map || !$game_player || !own_map?($game_map.map_id)
    return if $game_temp && $game_temp.player_transferring
    x, y = $game_player.x, $game_player.y
    return if tile_walkable?(x, y) && walkable_area(x, y) >= 40
    taken = {}
    $game_map.events.each_value { |e| taken[[e.x, e.y]] = true if e.character_name.to_s != "" && !e.through }
    seen = { [x, y] => true }
    queue = [[x, y]]
    until queue.empty?
      cx, cy = queue.shift
      [[0, 1], [1, 0], [-1, 0], [0, -1]].each do |dx, dy|
        n = [cx + dx, cy + dy]
        next if seen[n] || !$game_map.valid?(*n)
        seen[n] = true
        if tile_walkable?(*n) && !taken[n] && walkable_area(*n) >= 40
          $game_player.moveto(n[0], n[1])
          $game_player.straighten rescue nil
          log("Moved the player from (#{x},#{y}) to (#{n[0]},#{n[1]}) on map #{$game_map.map_id}: the map changed.")
          return
        end
        queue << n if (n[0] - x).abs + (n[1] - y).abs < 40
      end
    end
  end
end

alias ft_orig_pbStartOver pbStartOver unless defined?(ft_orig_pbStartOver)
def pbStartOver(*args)
  if FrostThaw.active? && !FrostThaw.center_ok?
    FrostThaw.set_first_center
  end
  ft_orig_pbStartOver(*args)
end

Events.onMapSceneChange += proc { |_sender, e|
  begin
    FrostThaw.remap_legacy_arrival if e.is_a?(Array) && e[1]
    FrostThaw.rescue_if_lost
    FrostThaw.unstick_player
    # Infinite Fusion's own intro starts these lists; ours skips it, and a hat
    # found after a wild battle (or the trainer card) would crash on nil
    if $Trainer
      $Trainer.unlocked_hats = [] if $Trainer.respond_to?(:unlocked_hats=) && !$Trainer.unlocked_hats
      $Trainer.unlocked_clothes = [] if $Trainer.respond_to?(:unlocked_clothes=) && !$Trainer.unlocked_clothes
    end
  rescue StandardError => err
    FrostThaw.log("Rescue check failed: #{err.message}")
  end
}
