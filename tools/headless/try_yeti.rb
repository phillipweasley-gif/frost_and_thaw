# Yeti fusions in the real game code: species exist, names, types, front and back pictures come from
# our folder, evolution of a fused Yetot, and a battle with a yeti fusion on each side.
require_relative "driver"
HL.start_up
HL.quiet = true
HL.answers = [[/Which adventure/, 1], [/How would you like to play/, 0], [/Choose a difficulty/, 1]]
HL.new_game
HL.frames(100)
FrostThaw.apply_species_patches(true)
probs = []
pairs = [[587, 580], [580, 587], [588, 582], [582, 588], [587, 41], [41, 588], [588, 204], [204, 587], [587, 153], [588, 7]]
pairs.each do |h, b|
  sym = "B#{b}H#{h}".to_sym
  pk = Pokemon.new(sym, 30) rescue (probs << "#{sym}: can't create (#{$!.message})"; next)
  d = pk.species_data
  front = (GameData::Species.sprite_bitmap_from_pokemon(pk, false) rescue (probs << "#{sym} front: #{$!.message}"; nil))
  back = (GameData::Species.sprite_bitmap_from_pokemon(pk, true) rescue (probs << "#{sym} back: #{$!.message}"; nil))
  fp = (front.path.to_s + front.filename.to_s) rescue nil
  bp = (back.path.to_s + back.filename.to_s) rescue nil
  want_b = FrostThaw.fusion_back_sprite_path(h, b)
  has_back = File.exist?(want_b + ".png")
  puts format("%-10s %-14s %-16s front=%s back=%s", sym, pk.name, [d.type1, d.type2].uniq.join("/"), fp.to_s.sub(/.*FrostThaw\//, ""), bp.to_s.sub(/.*FrostThaw\//, ""))
  probs << "#{sym}: back picture exists but not used" if has_back && !bp.to_s.include?("back/fusions/#{h}/#{h}.#{b}")
end
# a fused Yetot evolves into a fused Yetitan at 32
pk = Pokemon.new(:B225H587, 31)
ev = pk.check_evolution_on_level_up(false) rescue nil
pk.level = 32
ev = pk.check_evolution_on_level_up(false)
puts "B225H587 at 32 evolves into #{ev.inspect}"
probs << "fused Yetot doesn't evolve" unless ev.to_s.include?("588")
# battles
$Trainer.party.clear
mine = Pokemon.new(:B580H587, 32); HL.sensible_moves(mine, nil) rescue nil; $Trainer.party << mine
$game_switches[Settings::NO_MONEY_LOSS] = true rescue nil
r = (pbWildBattle(:B588H41, 28) rescue (probs << "battle: #{$!.class}: #{$!.message}"; nil))
puts "wild battle vs B588H41 result: #{r.inspect}"
puts "problems: #{probs.size}"
probs.each { |p| puts "  " + p }
