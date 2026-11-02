# The three starters' pictures resolve to real files (the opened-ball view on Wynsnow's table).
require_relative "driver"
HL.start_up
HL.quiet = true
bad = 0
FrostThaw::STARTERS.each do |s|
  data = GameData::Species.get(s[:species])
  loader = BattleSpriteLoader.new
  sp = FrostThaw.new_species?(data.id_number) ? loader.ft_claim(PIFSprite.new(:BASE, data.id_number, nil, "")) : loader.get_pif_sprite_from_species(s[:species])
  path = sp.local_path || (loader.load_pif_sprite_directly(sp) && sp.local_path) rescue nil
  file = path && (pbResolveBitmap(path) || (File.exist?(path) ? path : nil))
  ok = file && File.exist?(file.to_s.end_with?(".png") ? file : "#{file}.png")
  # an ordinary fusion is cut from Infinite Fusion's own sprite sheets, as in battle
  ok ||= %i[CUSTOM AUTOGEN].include?(sp.type) && File.exist?("Graphics/Battlers/spritesheets_autogen/#{sp.head_id}.png")
  bad += 1 unless ok
  puts "#{ok ? 'OK ' : 'BAD'} #{s[:species]} (#{data.name}, dex #{data.id_number}) -> #{path.inspect}"
end
puts bad.zero? ? "all three starter pictures found" : "#{bad} starter picture(s) missing"
