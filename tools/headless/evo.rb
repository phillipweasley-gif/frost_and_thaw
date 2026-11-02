require_relative "driver"
HL.start_up
def chain(sp, lv = 5, maxlv = 60)
  out = []; cur = sp
  (lv..maxlv).each do |l|
    pk = Pokemon.new(cur, l)
    ns = pk.check_evolution_on_level_up rescue nil
    if ns
      out << "L#{l}: #{GameData::Species.get(cur).name} -> #{GameData::Species.get(ns).name}"
      cur = ns
    end
  end
  out
end
ENV["MONS"].split(",").each { |s| puts "== #{s} #{GameData::Species.get(s.to_sym).name}"; puts chain(s.to_sym).map { |l| "   " + l } }
