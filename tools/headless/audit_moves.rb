require_relative "driver"
HL.start_up
sp = FrostThaw::STARTERS.map { |s| s[:species] } + FrostThaw::HERALDS.values.map { |h| h[:starter] }
sp.uniq.each do |s|
  d = GameData::Species.get(s)
  puts "== #{d.name} (#{s}) types #{[d.type1, d.type2].uniq.join('/')}"
  [5, 10, 15, 20, 25].each do |lv|
    pk = Pokemon.new(s, lv)
    mv = pk.moves.map { |m| md = GameData::Move.get(m.id); "#{md.name}(#{md.type}#{md.base_damage > 1 ? ' ' + md.base_damage.to_s : ''})" }
    dmg = pk.moves.select { |m| GameData::Move.get(m.id).base_damage > 1 }
    stab = dmg.select { |m| [d.type1, d.type2].include?(GameData::Move.get(m.id).type) }
    puts "  L#{lv}: #{mv.join(', ')}#{stab.empty? ? '   <- no attack of its own type' : ''}"
  end
end
