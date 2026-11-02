#===============================================================================
# Frost & Thaw - the Heralds' battle backs
#
# Infinite Fusion draws the player in battle as their own outfit, seen from the
# front and mirrored. In Herald Mode you are the Herald, so you get their back:
# Graphics/Trainers/FT_HERALD_<KEY>_back.png, five 160x160 frames (idle with the
# ball raised, two wind-up frames, release and follow-through), drawn at 2x and
# shown at zoom 2 like the outfit sprite, bottom-centre at (100, 410).
# Journey Mode keeps Infinite Fusion's own sprite (you are you).
#===============================================================================
module FrostThaw
  # the ball's centre in each frame, in native pixels of the 80x80 frame
  # (written by build/p1_sprites/tools/herald_backs.py)
  HERALD_BACK_HANDS = {
    alberica: [[57.5, 31.8], [55.5, 32.8], [54.5, 33.8], [59.5, 30.8], [58.5, 31.8]],
    reptin: [[61.7, 29.5], [59.7, 30.5], [58.7, 31.5], [63.7, 28.5], [62.7, 29.5]],
    alerion: [[58.1, 28.1], [56.1, 29.1], [55.1, 30.1], [60.1, 27.1], [59.1, 28.1]],
    meat_meat: [[59.1, 46.3], [18.0, 37.6], [26.5, 19.1], [74.5, 37.0], [72.5, 48.0]],   # batch 02 redraw
    wyn: [[56.9, 29.8], [54.9, 30.8], [53.9, 31.8], [58.9, 28.8], [57.9, 29.8]],
  }

  module_function

  def herald_back_file
    return nil if !active? || !herald
    file = "Graphics/Trainers/FT_HERALD_#{herald.to_s.upcase}_back"
    pbResolveBitmap(file) ? file : nil
  rescue StandardError
    nil
  end
end

if defined?(PokeBattle_Scene)
class PokeBattle_Scene
  alias ft_orig_pbCreateTrainerBackSprite pbCreateTrainerBackSprite unless method_defined?(:ft_orig_pbCreateTrainerBackSprite)

  def pbCreateTrainerBackSprite(idxTrainer, trainerType, numTrainers = 1)
    file = idxTrainer == 0 ? FrostThaw.herald_back_file : nil
    return ft_orig_pbCreateTrainerBackSprite(idxTrainer, trainerType, numTrainers) if !file
    sprite = IconSprite.new(100, 410, @viewport)
    sprite.setBitmap(file)
    sprite.zoom_x = 2
    sprite.zoom_y = 2
    sprite.z = 100 + idxTrainer
    sprite.src_rect.x = 0
    sprite.src_rect.width = sprite.bitmap.width / 5
    sprite.ox = sprite.src_rect.width / 2
    sprite.oy = sprite.bitmap.height
    $ft_herald_hands = FrostThaw::HERALD_BACK_HANDS[FrostThaw.herald]
    @sprites["player_#{idxTrainer + 1}"] = sprite
  rescue StandardError => e
    FrostThaw.log("Herald back failed: #{e.message}") rescue nil
    ft_orig_pbCreateTrainerBackSprite(idxTrainer, trainerType, numTrainers)
  end
end

end

if defined?(PokeBattle_BallAnimationMixin)
module PokeBattle_BallAnimationMixin
  alias ft_orig_ballTracksHand ballTracksHand unless method_defined?(:ft_orig_ballTracksHand)

  # The ball follows the Herald's raised hand while the sprite slides away
  # (32 px a tick: Infinite Fusion's player slide lasts 8 ticks), and leaves it
  # on the release frame.
  def ballTracksHand(ball, traSprite, safariThrow = false)
    hands = $ft_herald_hands
    return ft_orig_ballTracksHand(ball, traSprite, safariThrow) if !hands || safariThrow || !FrostThaw.herald_back_file
    at = lambda do |t, f|
      [traSprite.x - 32 * t + ((hands[f][0] - 40) * 4).round, traSprite.y + ((hands[f][1] - 80) * 4).round]
    end
    ball.setZ(0, traSprite.z + 1)
    ball.setVisible(0, true)
    x, y = at.call(0, 1); ball.setXY(0, x, y)
    ball.moveDelta(0, 5, -32 * 5, 0)
    x, y = at.call(5, 2); ball.setXY(5, x, y)
    ball.moveDelta(5, 2, -32 * 2, 0)
    x, y = at.call(7, 2); ball.setXY(7, x, y)
    ball.setZ(7, traSprite.z - 1)
    return x, y
  rescue StandardError
    ft_orig_ballTracksHand(ball, traSprite, safariThrow)
  end
end
end
