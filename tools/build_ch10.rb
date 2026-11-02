# Chapter 10: Trials of the Roots (script SC 10.01-10.09): the trial week's
# first people, added to the maps the earlier builders made. The chapter's
# new places (the Underdark Door, 2077; Glasswater Lake, 2078; the Attunement
# Way; the Crystals' Dream) and the rest of the week's people are built by
# build_w4.rb, which runs after Act III's builder.
require_relative "ft_common"

SW_TRIBUNAL, SW_TRIALS, SW_PHIL_MIRROR, SW_TALION = 3991, 3988, 3989, 3990

def during_trials(b, x, y, name, graphic, script, dir: 2, switch: SW_TRIALS)
  b.event(x, y, name, [{ graphic: "", through: true },
                       { switch: switch, graphic: graphic, direction: dir, script: script }])
end

# 2054: the Council Hall (the Tribunal, the root-cells, the gallery)
ch = reopen(2054)
ch.event(1, 1, "Cutscene tribunal", [{ graphic: "", through: true }, { switch: SW_TRIBUNAL, trigger: 3, script: "FT.scene_tribunal" }])
ch.event(17, 5, "Root-cells", [{ graphic: "", through: true }, { switch: SW_TRIALS, graphic: "FT_phildendrin_hooded", direction: 8, script: "FT.root_cells(@event_id)" }])
during_trials(ch, 9, 7, "Gallery", "BW (30)", "FT.talk(:trial_gallery, @event_id)")
during_trials(ch, 16, 12, "Gallery 2", "BW (38)", "FT.talk(:trial_gallery, @event_id)")
resave(ch, 2054)

# 2050: Anduin by the Bazaar fountain
rs = reopen(2050)
during_trials(rs, 20, 24, "Anduin", "FT_anduin", "FT.anduin_trial(@event_id)")
resave(rs, 2050)

# 2055: Captain Kethan Vale, at the mouth of the old guard tunnels
rt = reopen(2055)
during_trials(rt, 10, 19, "Captain Kethan Vale", "BW029", "FT.kethan_tunnels(@event_id)")
resave(rt, 2055)

# 2058: Autumn's spying mirror, in the Sap Wells
sw = reopen(2058)
sw.event(17, 18, "Autumn's mirror", [{ graphic: "", through: true }, { switch: SW_PHIL_MIRROR, tile_id: 809, script: "FT.autumn_mirror(@event_id)" }])
resave(sw, 2058)

# 2068: Kelyn and Selrae in the Undercanopy, to be taken to the Fane
uc = reopen(2068)
during_trials(uc, 11, 41, "Kelyn and Selrae", "BW (30)", "FT.councillors_undercanopy(@event_id)", dir: 4)
resave(uc, 2068)

puts "added the trial week to 2050, 2054, 2055, 2058, 2068"
