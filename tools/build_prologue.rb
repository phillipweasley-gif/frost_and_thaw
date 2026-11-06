# Builds the Prologue's maps (script SC 0.01-0.04): festival-morning copies of
# the Rooted Hearth, Rootspire's market and the College of Auroral Arts, so the
# New Journey prologue never touches Act II's Rootspire. Run after build_ch6b.rb
# (it copies maps 2050, 2053 and 2063).
#
# Staged like a Pokémon game's opening (WRITING_GUIDE §9a): everyone who talks
# is standing where you can see them, Tamsin leads you from place to place, and
# your first Pokémon waits in a Poké Ball on Professor Wynsnow's table.
require_relative "ft_common"

P_HEARTH = 2090
P_MARKET = 2091
P_COLLEGE = 2092
SW_PRO_STARTER = 3960   # the battle's done: Tamsin ran back to the Hearth (and waits in the market)
SW_PRO_MURAL = 3962     # you've seen the sixth figure: Tamsin is at the lantern stall
SW_PRO_LECTURE = 3956   # Tamsin has led you to Wynsnow's lecture room
SW_PRO_LED = 3957       # Tamsin has led you from the lift to the Hearth
SW_PRO_MORNING = 3958   # breakfast's done, no starter yet: Tamsin leads you to the lift (context 00, notes E10)

def copy_of(id)
  b = reopen(id)
  b.map.events.clear
  b
end

def closed(b, x, y)
  b.event(x, y, "Closed", [{ trigger: 1, script: "FT.talk(:pro_closed, @event_id)" }])
end

# Someone who is only there between two story switches.
def tamsin_between(b, x, y, on, off, key, dir: 2)
  pages = [{ graphic: "", through: true },
           { switch: on, graphic: "FT_tamsin", direction: dir, script: "FT.talk(:#{key}, @event_id)" }]
  pages << { switch: off, graphic: "", through: true } if off
  b.event(x, y, "Tamsin", pages)
end

def autorun_when(b, x, y, switch, key)
  b.event(x, y, "Cutscene #{key}", [{ switch: switch, trigger: 3, script: "FT.scene(:#{key}, @event_id)" },
                                    { self_switch: "A" }])
end

# --- the Rooted Hearth, festival morning ---------------------------------------
# You start on the stool at the corner table (13,5); Tamsin bursts in from the
# street door, and Hellen is behind the bar.
h = copy_of(2053)
h.cutscene(0, 0, :pro_morning)
autorun_when(h, 1, 0, SW_PRO_STARTER, :pro_mural)      # back from the College: Tamsin calls you to the wall
h.event(3, 6, "Hellen", [{ graphic: "FT_hellen", direction: 6, script: "FT.talk(:pro_hellen, @event_id)" }])
h.npc(7, 10, "BW (62)", :pro_bard, dir: 8, name: "Bard")
h.npc(10, 8, "BW (54)", :pro_drinker, dir: 4, name: "Drinker")
tamsin_between(h, 15, 7, SW_PRO_STARTER, SW_PRO_MURAL, :pro_tamsin_wall, dir: 6)
h.event(16, 8, "Mural", [{ script: "FT.pro_mural(@event_id)" }])
[4, 5, 6, 7].each { |x| h.door(x, 12, P_MARKET, 31, 28, 2, name: "Exit") }
save_map(h, P_HEARTH)

# --- the market: everything is shut for the festival but the Hearth and the lift --
m = copy_of(2050)
m.door(31, 27, P_HEARTH, 5, 11, 8, name: "Door Rooted Hearth")
# The lift-keeper in a worker's uniform: a role you have to find, so not the bard's sprite (notes/00 E18).
m.event(16, 11, "Lift-keeper", [{ graphic: "BW (75)", direction: 2, script: "FT.pro_lift(@event_id)" }])
[[24, 18], [34, 16], [20, 28], [14, 9], [44, 16], [45, 16]].each { |x, y| closed(m, x, y) }
crowd = ["BW (29)", "BWParasolLady", "BW (37)", "BW (30)"]
[[7, 22], [58, 28], [58, 29], [58, 30], [58, 31]].each_with_index do |(x, y), i|
  m.npc(x, y, crowd[i % crowd.size], :pro_crowd, dir: x < 30 ? 6 : 4, name: "Festival crowd")
end
m.npc(16, 23, "BWParasolLady", :pro_festival_goer, dir: 2, name: "Festival-goer")
m.npc(13, 25, "BW (29)", :pro_mural_kid, dir: 6, name: "Kid")
m.npc(28, 29, "BW (30)", :pro_lantern_seller, dir: 6, name: "Lantern seller")
# Tamsin waits by the lift after the battle and leads you to the Hearth...
tamsin_between(m, 17, 12, SW_PRO_STARTER, SW_PRO_LED, :pro_tamsin_wall, dir: 4)
autorun_when(m, 1, 0, SW_PRO_STARTER, :pro_market_lead)
# ...and the first time out of the Hearth, she's outside the door and leads you up to the lift.
autorun_when(m, 2, 0, SW_PRO_MORNING, :pro_market_up)
# ...and after the mural, haggles at the lantern stall.
tamsin_between(m, 29, 29, SW_PRO_MURAL, nil, :pro_tamsin_stall, dir: 4)
autorun_when(m, 0, 0, SW_PRO_MURAL, :pro_lantern)
save_map(m, P_MARKET)

# --- the College: Professor Wynsnow's three Pokémon ------------------------------
# The east lecture room (x 17-23, y 3-7, door at x 19-20, y 8) is cleared for the
# festival: the desks are gone, and one table holds three Poké Balls (the same
# glass table Professor Oak keeps his on, Infinite Fusion map 77). Wynsnow
# writes at the blackboard behind it.
c = copy_of(2063)
(17..23).each do |x|
  c.set(x, 2, 1, 0) if c.get(x, 2, 1) == 8915                 # the teacher's chair back
  (3..7).each { |y| [1, 2].each { |z| c.set(x, y, z, 0) } }
end
[[19, 1648], [20, 1649], [21, 1651]].each { |x, t| c.set(x, 4, 1, t) }   # the table top
[[19, 1656], [20, 1657], [21, 1659]].each { |x, t| c.set(x, 5, 1, t) }   # its front (a counter: talk across it)
[17, 23].each { |x| c.set(x, 4, 2, 8898); c.set(x, 5, 2, 8906) }          # two potted plants (as in Oak's lab)
c.cutscene(0, 0, :pro_college_arrive)
c.event(20, 3, "Professor Wynsnow", [{ graphic: "BW (55)", direction: 8, script: "FT.talk(:pro_wynsnow, @event_id)" }])
3.times do |i|
  c.event(19 + i, 4, "Starter ball #{i + 1}", [{ graphic: "BW153", direction: 2, script: "FT.pro_ball(#{i}, @event_id)" },
                                              { self_switch: "A", graphic: "", through: true }])
end
tamsin_between(c, 22, 5, SW_PRO_LECTURE, SW_PRO_STARTER, :pro_tamsin_table, dir: 4)
[19, 20].each do |x|
  c.event(x, 8, "Lecture room door", [{ trigger: 1, through: true, script: "FT.pro_lecture_door(@event_id)" }])
end
c.npc(7, 5, "BW (17)", :pro_student_west, dir: 8, name: "Student")
c.npc(5, 12, "BW (29)", :pro_student_hall, dir: 6, name: "Student")
closed(c, 13, 2)
[12, 13, 14].each { |x| c.door(x, 19, P_MARKET, 16, 12, 2, name: "Exit") }
save_map(c, P_COLLEGE)

merge_infos(P_HEARTH => "The Rooted Hearth", P_MARKET => "Rootspire", P_COLLEGE => "College of Auroral Arts")
puts "built 3 prologue maps into #{OUT}"
