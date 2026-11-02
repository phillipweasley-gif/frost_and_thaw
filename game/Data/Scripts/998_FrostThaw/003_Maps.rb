#===============================================================================
# Frost & Thaw - maps
#
# Frost & Thaw's maps are kept in Data/FrostThaw (Map2000.rxdata and up) so the
# base game's Data folder is never touched. Loading "Data/Map2001.rxdata" is
# quietly redirected there, and the maps get names, weather and healing spots.
#===============================================================================
module FrostThaw
  module_function

  def own_map_path(path)
    return nil if !path.is_a?(String)
    m = path.match(/Data[\/\\]Map(\d+)\.rxdata\z/i)
    return nil if !m || m[1].to_i < FIRST_MAP_ID
    return sprintf("%s/Map%04d.rxdata", MAP_FOLDER, m[1].to_i)
  end

  def map_infos_with_ours(infos)
    return infos if !infos.is_a?(Hash)
    MAP_NAMES.each do |id, name|
      next if infos[id]
      info = RPG::MapInfo.new
      info.name = name
      info.parent_id = 0
      info.order = id
      infos[id] = info
    end
    return infos
  end

  # Map properties (the game's map_metadata.dat doesn't know our maps).
  MAP_METADATA = {
    2001 => { outdoor_map: true, announce_location: true, weather: [:Snow, 100],
              battle_environment: :Snow },
    2003 => { teleport_destination: [2001, 14, 28] }    # the Pokémon Center heals you here
  }

  def register_map_metadata
    MAP_METADATA.each do |id, props|
      hash = { id: id }.merge(props)
      begin
        GameData::MapMetadata::DATA[id] = GameData::MapMetadata.new(hash)
      rescue StandardError => e
        log("Map metadata for #{id} skipped: #{e.message}")
      end
    end
  end
end

alias ft_orig_load_data load_data unless defined?(ft_orig_load_data)
def load_data(path, *args)
  own = FrostThaw.own_map_path(path)
  return ft_orig_load_data(own, *args) if own
  data = ft_orig_load_data(path, *args)
  if path.is_a?(String) && path =~ /MapInfos\.rxdata\z/i
    data = FrostThaw.map_infos_with_ours(data)
  end
  return data
end

alias ft_orig_pbRgssExists? pbRgssExists? unless defined?(ft_orig_pbRgssExists?)
def pbRgssExists?(path)
  own = FrostThaw.own_map_path(path)
  return ft_orig_pbRgssExists?(own) if own
  return ft_orig_pbRgssExists?(path)
end

module GameData
  class << self
    alias ft_orig_load_all load_all unless method_defined?(:ft_orig_load_all)
    def load_all
      ft_orig_load_all
      begin
        FrostThaw.register_map_metadata
        FrostThaw.register_trainer_data
        FrostThaw.register_species
        FrostThaw.register_encounters if FrostThaw.respond_to?(:register_encounters)
      rescue StandardError => e
        FrostThaw.log("Data registration failed: #{e.message}")
      end
    end
  end
end
