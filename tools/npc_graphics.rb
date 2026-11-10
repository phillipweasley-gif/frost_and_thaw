# The last build step (2026-11-10): the named minor NPCs whose stand-ins contradicted their own lines (dwarves drawn
# as tall men, half-orcs with human faces, the goliath captain) wear their own sheets, made by tools/npcgen.py.
# build/npc_graphics.json says which sheet replaces which event, by event name; only a base-game graphic is
# replaced (a page that's blank, or already an FT_ sheet, is left alone).
require_relative "ft_common"
require_relative "rgss_stub"
require "json"

spec = JSON.parse(File.read(File.expand_path("../build/npc_graphics.json", __dir__)))
by_name = {}
spec.each { |id, s| s["names"].each { |n| by_name[n] = id } }
changed = 0
Dir[File.join(OUT, "Map2*.rxdata")].sort.each do |f|
  id = File.basename(f)[/\d+/].to_i
  b = reopen(id)
  hit = false
  b.map.events.each_value do |e|
    sheet = by_name[e.name]
    next if !sheet
    e.pages.each do |pg|
      g = pg.graphic.character_name.to_s
      next if g.empty? || g.start_with?("FT_")
      pg.graphic.character_name = sheet
      pg.graphic.character_hue = 0
      hit = true
      changed += 1
    end
  end
  resave(b, id) if hit
end
puts "npc_graphics: #{changed} pages on their own sheets"
