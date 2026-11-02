#===============================================================================
# Frost & Thaw - battle screen fixes
#
# The opposing Pokémon's info box is drawn on a canvas only as tall as its
# background picture (62 pixels), but its status icon (burn, sleep, freeze...)
# is drawn at 56-72, so all you see is a sliver. Make the canvas tall enough
# for the icon. Nothing else moves.
#===============================================================================
if defined?(PokemonDataBox)
  class PokemonDataBox
    FT_MIN_CANVAS_HEIGHT = 76      # status icon: y 56 + 16 tall, with room to spare

    alias ft_initializeOtherGraphics initializeOtherGraphics unless method_defined?(:ft_initializeOtherGraphics)
    def initializeOtherGraphics(viewport)
      ft_initializeOtherGraphics(viewport)
      return if @contents.height >= FT_MIN_CANVAS_HEIGHT
      old = @contents
      @contents = BitmapWrapper.new(old.width, FT_MIN_CANVAS_HEIGHT)
      self.bitmap = @contents
      pbSetSystemFont(self.bitmap)
      old.dispose
    rescue StandardError => e
      FrostThaw.log("databox canvas fix skipped: #{e.message}") rescue nil
    end
  end
end
