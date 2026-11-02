# Chapter 9 (script SC 9.01-9.07) re-dresses places you've been: it adds its
# events to maps the earlier builders made (run after them):
#   2050 Rootspire: the leaves fall (9.01); walking back in with the refugees (9.07)
#   2031 Good Mead, burning: the mead hall door; your dragon in the square (9.03-9.04)
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

gm = reopen(2031)
gm.event(15, 11, "Mead hall door (burning)", [
  { graphic: "", through: true },
  { switch: SW_CH9_GOODMEAD, trigger: 1, script: "FT.mead_hall_door(@event_id)" },
  { switch: SW_CH9_MEADSAFE, graphic: "", through: true }
])
gm.event(19, 12, "Your dragon", [
  { graphic: "", through: true },
  { switch: SW_CH9_GOODMEAD, graphic: "FT_razzilith", direction: 4, step_anime: true, script: "FT.your_dragon(@event_id)" },
  { switch: SW_CH9_GOODMEAD, switch2: 3953, graphic: "FT_frostina", direction: 4, step_anime: true, script: "FT.your_dragon(@event_id)" }
])
resave(gm, 2031)

bs = reopen(2012)
autorun(bs, 1, 0, "Cutscene bryn_trap", SW_CH9_BRYN, "FT.scene_bryn_trap")
[[13, 11, "BW (29)"], [21, 12, "BW (37)"], [12, 16, "BW (30)"], [22, 16, "BWParasolLady"], [15, 18, "BW (38)"]].each_with_index do |(x, y, g), i|
  bs.event(x, y, "Refugee #{i + 1}", [
    { graphic: "", through: true },
    { switch: SW_CH9_BRYN, graphic: g, direction: 2, script: "FT.talk(:refugee, @event_id)" },
    { switch: SW_CH9_AFTER, graphic: g, direction: 2, script: "FT.talk(:refugee, @event_id)" }
  ])
end
bs.event(19, 11, "Anduin", [
  { graphic: "", through: true },
  { switch: SW_CH9_AFTER, graphic: "FT_anduin", direction: 4, script: "FT.anduin_ch9(@event_id)" }
])
bs.event(24, 12, "Hooded woman", [
  { graphic: "", through: true },
  { switch: SW_CH9_AFTER, graphic: "FT_phildendrin_hooded", direction: 4, script: "FT.talk(:hooded_woman, @event_id)" }
])
resave(bs, 2012)
puts "chapter 9 events added to 2050, 2031, 2012"
