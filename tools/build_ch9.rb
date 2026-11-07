# Chapter 9 (script SC 9.01-9.07) re-dresses places you've been: it adds its
# events to maps the earlier builders made (run after them):
#   2050 Rootspire: the leaves fall (9.01); walking back in with the refugees (9.07)
#   2031 Good Mead, burning: the mead hall door; your dragon in the square; the
#        townsfolk's lines and the held roads while it burns (9.03-9.04)
#   2033 the cooperage: Olivessa isn't there while the mead hall burns
#   2012 Bryn Shander, packed: the trap (9.05); Anduin and the hooded woman after (9.06)
require_relative "ft_common"

SW_CH9_MARKET, SW_CH9_GOODMEAD, SW_CH9_MEADSAFE, SW_CH9_BRYN, SW_CH9_AFTER, SW_CH9_RETURN = 3982, 3983, 3984, 3985, 3986, 3987

def autorun(b, x, y, name, switch, script)
  b.event(x, y, name, [{ graphic: "", through: true }, { switch: switch, trigger: 3, script: script }])
end

rs = reopen(2050)
autorun(rs, 2, 0, "Cutscene leaves_fall", SW_CH9_MARKET, "FT.scene_leaves_fall")
autorun(rs, 3, 0, "Cutscene slayers_of_summer", SW_CH9_RETURN, "FT.scene_slayers_of_summer")
resave(rs, 2050)

# An extra page on an event an earlier builder made (a townsperson who has
# something else to say while the town burns).
def add_page(b, name, pd)
  evs = b.map.events.values.select { |e| e.name == name }
  raise "no event #{name}" if evs.empty?
  evs.each { |e| e.pages << b.build_page(e.pages[0], pd) }
end

gm = reopen(2031)
gm.event(15, 11, "Mead hall door (burning)", [
  { graphic: "", through: true },
  { switch: SW_CH9_GOODMEAD, trigger: 1, script: "FT.mead_hall_door(@event_id)" },
  { switch: SW_CH9_MEADSAFE, graphic: "", through: true },
  { switch: SW_CH9_GOODMEAD, switch2: SW_CH9_MEADSAFE, trigger: 1, script: "FT.mead_hall_smoke(@event_id)" }   # (shut while it burns)
])
gm.event(19, 12, "Your dragon", [
  { graphic: "", through: true },
  { switch: SW_CH9_GOODMEAD, graphic: "FT_razzilith", direction: 4, step_anime: true, script: "FT.your_dragon(@event_id)" },
  { switch: SW_CH9_GOODMEAD, switch2: 3953, graphic: "FT_frostina", direction: 4, step_anime: true, script: "FT.your_dragon(@event_id)" }
])
# Good Mead burning (notes 09 E7): the townsfolk know it
{ "NPC gm_beekeeper" => :gm_burning_beekeeper, "Shandar Froth" => :gm_burning_shandar,
  "NPC gm_townsfolk" => :gm_burning_townsfolk, "Gossip" => :gm_burning_gossip, "Fef Moryn" => :gm_burning_fef }.each do |name, key|
  e = gm.map.events.values.find { |ev| ev.name == name } or raise "no #{name}"
  g = e.pages[0].graphic
  add_page(gm, name, { switch: SW_CH9_GOODMEAD, graphic: g.character_name, direction: g.direction, script: "FT.talk(:#{key}, @event_id)" })
end
# ...and the roads out are held while the dragon is overhead (notes 09 E8)
[[16, 1], [17, 1], [20, 30], [21, 30], [1, 27], [1, 28]].each do |x, y|
  gm.event(x, y, "Militia (the roads)", [{ graphic: "", through: true },
                                         { switch: SW_CH9_GOODMEAD, graphic: "BWPoliceman", direction: 2, script: "FT.talk(:gm_militia, @event_id)" }])
end
resave(gm, 2031)

# Olivessa is in the mead hall while it burns, not at her cooperage
co = reopen(2033)
add_page(co, "Olivessa Untapoor", { switch: SW_CH9_GOODMEAD, graphic: "", through: true })
resave(co, 2033)

bs = reopen(2012)
autorun(bs, 1, 0, "Cutscene bryn_trap", SW_CH9_BRYN, "FT.scene_bryn_trap")
# (notes 09 E17: five refugees, five lines)
[[13, 11, "BW (29)"], [21, 12, "BW (37)"], [12, 16, "BW (30)"], [22, 16, "BWParasolLady"], [15, 18, "BW (38)"]].each_with_index do |(x, y, g), i|
  bs.event(x, y, "Refugee #{i + 1}", [
    { graphic: "", through: true },
    { switch: SW_CH9_BRYN, graphic: g, direction: 2, script: "FT.talk(:refugee_#{i + 1}, @event_id)" },
    { switch: SW_CH9_AFTER, graphic: g, direction: 2, script: "FT.talk(:refugee_#{i + 1}, @event_id)" }
  ])
end
bs.event(14, 12, "Olivessa (with her bees)", [
  { graphic: "", through: true },
  { switch: SW_CH9_AFTER, graphic: "BW (56)", direction: 2, script: "FT.talk(:olivessa_refugee, @event_id)" }
])
bs.event(19, 11, "Anduin", [
  { graphic: "", through: true },
  { switch: SW_CH9_AFTER, graphic: "FT_anduin", direction: 4, script: "FT.anduin_ch9(@event_id)" }
])
bs.event(24, 12, "Hooded woman", [
  { graphic: "", through: true },
  { switch: SW_CH9_AFTER, graphic: "FT_phildendrin_hooded", direction: 4, script: "FT.hooded_woman_ch9(@event_id)" }
])
# The way out is the south road (notes 09 E5): Duvessa by it, the road asks;
# the other gates are held so the refugees aren't left in the square
bs.event(8, 41, "Duvessa (the south road)", [
  { graphic: "", through: true },
  { switch: SW_CH9_AFTER, graphic: "FT_speaker_duvessa_shane", direction: 6, script: "FT.duvessa_square(@event_id)" }
])
(8..11).each do |x|
  bs.event(x, 44, "South road (the refugees)", [{ graphic: "", through: true },
                                               { switch: SW_CH9_AFTER, trigger: 1, through: true, script: "FT.south_road(@event_id)" }])
end
[[22, 1], [23, 1], [48, 22], [48, 23]].each do |x, y|
  bs.event(x, y, "Militia (the gates)", [{ graphic: "", through: true },
                                         { switch: SW_CH9_AFTER, graphic: "BWPoliceman", direction: 2, script: "FT.talk(:militia_hold, @event_id)" },
                                         { switch: SW_CH9_BRYN, graphic: "BWPoliceman", direction: 2, script: "FT.talk(:militia_hold, @event_id)" }])
end
resave(bs, 2012)
puts "chapter 9 events added to 2050, 2031, 2033, 2012"
