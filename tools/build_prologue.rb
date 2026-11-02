# Builds the Prologue's maps (script SC 0.01-0.04): festival-morning copies of
# the Rooted Hearth, Rootspire's market and the College of Auroral Arts, so the
# New Journey prologue never touches Act II's Rootspire. Run after build_ch6.rb
# (it copies maps 2050, 2053 and 2063).
require_relative "ft_common"

P_HEARTH = 2090
P_MARKET = 2091
P_COLLEGE = 2092
SW_PRO_STARTER = 3960   # you have your first Pokémon
SW_PRO_MURAL = 3962     # you've seen the sixth figure: the lantern stall is waiting

def copy_of(id)
  b = reopen(id)
  b.map.events.clear
  b
end

def closed(b, x, y)
  b.event(x, y, "Closed", [{ trigger: 1, script: "FT.talk(:pro_closed, @event_id)" }])
end

# --- the Rooted Hearth, festival morning ---------------------------------------
h = copy_of(2053)
h.cutscene(0, 0, :pro_morning)
h.event(3, 6, "Hellen", [{ graphic: "FT_hellen", direction: 6, script: "FT.talk(:pro_hellen, @event_id)" }])
h.npc(7, 10, "BW (62)", :pro_bard, dir: 8, name: "Bard")
h.npc(10, 8, "BW (54)", :pro_drinker, dir: 4, name: "Drinker")
# Tamsin waits by the mural once you've got your Pokémon, then runs ahead to the lantern stall.
h.event(15, 7, "Tamsin", [{ graphic: "", through: true },
                          { switch: SW_PRO_STARTER, graphic: "FT_tamsin", direction: 2, script: "FT.pro_mural(@event_id)" },
                          { switch: SW_PRO_MURAL, graphic: "", through: true }])
h.event(16, 8, "Mural", [{ script: "FT.pro_mural(@event_id)" }])
[4, 5, 6, 7].each { |x| h.door(x, 12, P_MARKET, 31, 28, 2, name: "Exit") }
save_map(h, P_HEARTH)

# --- the market: everything is shut for the festival but the Hearth and the lift --
m = copy_of(2050)
m.door(31, 27, P_HEARTH, 5, 11, 8, name: "Door Rooted Hearth")
m.event(16, 11, "Lift-keeper", [{ graphic: "BW (62)", direction: 2, script: "FT.pro_lift(@event_id)" }])
[[24, 18], [34, 16], [20, 28], [14, 9], [44, 16], [45, 16]].each { |x, y| closed(m, x, y) }
crowd = ["BW (29)", "BWParasolLady", "BW (37)", "BW (30)"]
[[7, 22], [58, 28], [58, 29], [58, 30], [58, 31]].each_with_index do |(x, y), i|
  m.npc(x, y, crowd[i % crowd.size], :pro_crowd, dir: x < 30 ? 6 : 4, name: "Festival crowd")
end
m.npc(16, 23, "BWParasolLady", :pro_festival_goer, dir: 2, name: "Festival-goer")
m.npc(13, 25, "BW (29)", :pro_mural_kid, dir: 6, name: "Kid")
m.npc(28, 29, "BW (30)", :pro_lantern_seller, dir: 6, name: "Lantern seller")
m.event(0, 0, "Cutscene pro_lantern", [{ switch: SW_PRO_MURAL, trigger: 3, script: "FT.scene(:pro_lantern, @event_id)" },
                                       { self_switch: "A" }])
save_map(m, P_MARKET)

# --- the College: Professor Wynsnow's three Pokémon ------------------------------
c = copy_of(2063)
c.cutscene(0, 0, :pro_college)
c.event(13, 4, "Professor Wynsnow", [{ graphic: "BW (55)", direction: 2, script: "FT.talk(:pro_wynsnow, @event_id)" }])
c.event(14, 5, "Tamsin", [{ graphic: "FT_tamsin", direction: 4 },
                          { switch: SW_PRO_STARTER, graphic: "", through: true }])
closed(c, 13, 2)
[12, 13, 14].each { |x| c.door(x, 19, P_MARKET, 16, 12, 2, name: "Exit") }
save_map(c, P_COLLEGE)

merge_infos(P_HEARTH => "The Rooted Hearth", P_MARKET => "Rootspire", P_COLLEGE => "College of Auroral Arts")
puts "built 3 prologue maps into #{OUT}"
