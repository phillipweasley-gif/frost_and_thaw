#===============================================================================
# Frost & Thaw - more hair colours
#
# Every hairstyle now also comes in Red (6), Auburn (7) and White (8), plus
# Ice Blue (5) on styles that didn't already have a fifth colour. The pictures
# live in Graphics/Characters/player/hair like the game's own, so the hair
# salon offers them too. This adds them to the new-game character menu.
#===============================================================================
if defined?(CharacterSelectMenuPresenter)
  class CharacterSelectMenuPresenter
    FT_EXTRA_HAIR = [[6, _INTL("Red")], [7, _INTL("Auburn")], [8, _INTL("White")]]
    FT_EXTRA_HAIR.each do |id, name|
      next if HAIR_COLOR_IDS.include?(id)
      HAIR_COLOR_IDS.push(id)
      HAIR_COLOR_NAMES.push(name)
    end
  end
end
