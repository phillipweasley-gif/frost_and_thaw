#===============================================================================
# Frost & Thaw - trainer classes and trainers
#
# New trainer classes borrow an existing class's battle sprite until art of
# their own exists. Trainers are added to the game's trainer list at startup.
#===============================================================================
module FrostThaw
  # id => [display name, class whose sprite/music to borrow, gender, base money]
  TRAINER_TYPES = {
    FT_ZHENTARIM:   ["Zhentarim",  :ROUGHNECK,    0, 40],
    FT_ZHENTARIM_F: ["Zhentarim",  :CRUSHGIRL,    1, 40],
    FT_SPEAKER:     ["Speaker",    :ROCKETBOSS,   0, 100, :LEADER_Brock]
  }

  # key => [trainer class, name, party, lose text, items]
  # Party entries: [species, level] or [species, level, [moves]]
  TRAINERS = {
    fisher_hob:      [:FISHERMAN,      "Hob",     [[:MAGIKARP, 4], [:GOLDEEN, 5]],
                      "The lake gives, the lake takes."],
    sailor_brannoc:  [:SAILOR,         "Brannoc", [[:TENTACOOL, 5]],
                      "Ice on the hull, ice in my luck."],
    tavern_brawler:  [:BIKER,          "Gorm",    [[:KOFFING, 5]],
                      "Fine. You can keep the stool."],
    zhent_thug_1:    [:FT_ZHENTARIM,   "Dask",    [[:RATTATA, 4]],
                      "Naerth hears about everything, you know."],
    zhent_thug_2:    [:FT_ZHENTARIM_F, "Vey",     [[:EKANS, 5]],
                      "Keep your coin purse close in Targos."],
    hall_enforcer_1: [:FT_ZHENTARIM,   "Corrin",  [[:KOFFING, 8]],
                      "The Speaker will want to meet you now."],
    hall_enforcer_2: [:FT_ZHENTARIM_F, "Ilsa",    [[:GRIMER, 7]],
                      "Huh. Not bad, stranger."],
    hall_dealer:     [:FT_ZHENTARIM_F, "Mara",    [[:MEOWTH, 8], [:MURKROW, 9]],
                      "The house always wins. Usually."],
    naerth:          [:FT_SPEAKER,     "Naerth",  [[:GRIMER, 10], [:MURKROW, 10], [:B109H228, 12]],
                      "Hmph. Targos remembers its debts, stranger. Both kinds.", [:POTION]]
  }

  module_function

  def register_trainer_data
    next_number = 950
    TRAINER_TYPES.each do |id, (name, borrow, gender, money, music_from)|
      base = GameData::TrainerType.try_get(borrow)
      music = GameData::TrainerType.try_get(music_from || borrow)
      hash = {
        id: id, id_number: next_number, name: name, base_money: money, gender: gender,
        battle_BGM: music&.battle_BGM, victory_ME: music&.victory_ME, intro_ME: base&.intro_ME,
        skill_level: money
      }
      next_number += 1
      tt = GameData::TrainerType.new(hash)
      tt.define_singleton_method(:name) { name }
      GameData::TrainerType::DATA[id] = tt
      GameData::TrainerType::DATA[tt.id_number] = tt
    end
    number = 9000
    TRAINERS.each do |key, (type, name, party, lose_text, items)|
      pokemon = party.map do |species, level, moves|
        p = { species: species, level: level }
        p[:moves] = moves if moves
        p
      end
      hash = { id: [type, name, 0], id_number: number, trainer_type: type, name: name,
               version: 0, items: items || [], lose_text: lose_text, pokemon: pokemon }
      number += 1
      GameData::Trainer::DATA[[type, name, 0]] = GameData::Trainer.new(hash)
    end
  end

  def borrowed_trainer_type(tr_type)
    entry = TRAINER_TYPES[tr_type.to_s.to_sym] rescue nil
    return entry ? entry[1] : nil
  end
end

module GameData
  class TrainerType
    class << self
      alias ft_orig_front_sprite_filename front_sprite_filename unless method_defined?(:ft_orig_front_sprite_filename)
      def front_sprite_filename(tr_type)
        own = "Graphics/Trainers/#{tr_type}"
        return own if FrostThaw.borrowed_trainer_type(tr_type) && (pbResolveBitmap(own) rescue nil)   # our own picture, if we've drawn one
        borrowed = FrostThaw.borrowed_trainer_type(tr_type)
        return ft_orig_front_sprite_filename(borrowed) if borrowed
        return ft_orig_front_sprite_filename(tr_type)
      end

      alias ft_orig_back_sprite_filename back_sprite_filename unless method_defined?(:ft_orig_back_sprite_filename)
      def back_sprite_filename(tr_type)
        borrowed = FrostThaw.borrowed_trainer_type(tr_type)
        return ft_orig_back_sprite_filename(borrowed) if borrowed
        return ft_orig_back_sprite_filename(tr_type)
      end
    end
  end
end
