# The Herald back sprite and the ball tracking its hand (no drawing: checks the numbers).
require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 1], [/Which Herald|Who will you be|Which of the Heralds/, ->(t, c) { c.index { |x| x.to_s =~ /#{ENV['HL_HERALD'] || 'Alberica'}/i } || 0 }]]
HL.new_game; HL.frames(200)
ok = ->(c, m) { puts "#{c ? 'ok  ' : 'FAIL'} #{m}" }
FT = FrostThaw unless defined?(FT)
puts "herald: #{FT.herald.inspect}  file: #{FT.herald_back_file.inspect}"
ok.(FT.herald_back_file, "Herald Mode finds the back sprite")
sc = PokeBattle_Scene.allocate
sc.instance_variable_set(:@viewport, Viewport.new(0, 0, 512, 384))
sc.instance_variable_set(:@sprites, {})
sc.pbCreateTrainerBackSprite(0, :POKEMONTRAINER_Red, 1)
sp = sc.instance_variable_get(:@sprites)["player_1"]
ok.(sp && sp.bitmap && sp.bitmap.width == 800 && sp.bitmap.height == 160, "player_1 is the 800x160 strip (#{sp&.bitmap&.width}x#{sp&.bitmap&.height})")
ok.(sp && sp.src_rect.width == 160 && sp.ox == 80 && sp.oy == 160, "one 160 frame, bottom-centre origin (src #{sp&.src_rect&.width}, ox #{sp&.ox}, oy #{sp&.oy})")
ok.(sp.bitmap.width >= sp.bitmap.height * 2, "wide enough that the slide-off animates its frames")
class FakeAnim; include PokeBattle_BallAnimationMixin; def initialize; @trainer = nil; end; end
s2 = Sprite.new(sc.instance_variable_get(:@viewport)); s2.bitmap = Bitmap.new(32, 32)
ball = PictureEx.new(10)
x, y = FakeAnim.new.ballTracksHand(ball, sp)
ok.(ball.totalDuration == 7, "ball leaves the hand at tick 7 (#{ball.totalDuration})")
puts "  release point #{x},#{y}"
ok.(y.between?(150, 300), "release height sits at the hand (y #{y})")
# Journey Mode: Infinite Fusion's own sprite
FT.state[:herald] = nil
ok.(FT.herald_back_file.nil?, "Journey Mode keeps the outfit sprite")
