#===============================================================================
# Frost & Thaw - the loop's fallback skip lists
#
# What a full Journey playthrough has set by the end of Act I and of Act II
# (dumped by tools/headless/story_run.rb with LOOP_DUMP). Only used if a save
# has no snapshot of its own (040_Loop.rb's loop_snapshot normally records yours).
#===============================================================================
module FrostThaw
  LOOP_ACT1_FLAGS.replace(%i[
    act1_done alberica_marked arrived_targos auril_named badge_bryn badge_dougans badge_targos
    bone_dust bridge_cracked bridge_gusted bryn_arrived cackling_entered chasm_entered cub_home
    cub_is_yetot dh_arrived dh_morning eastway_started fed_pack fell_through followed_koran
    fork_talked found_swaddling frost_egg frostina_hatched garagai_vow gate_open ghost_blessing
    golden_acorn good_mead_arrived good_mead_met got_pokedex got_snowshoes got_splicers
    got_starter got_yeti_cub got_yetot hag_defeated hag_fled hag_mirror_1 hag_mirror_2
    hag_mirror_3 hag_named hag_parley heart_entered heart_of_ice husband_thawed icefall_fell intro_done
    intro_started kids_freed kids_home knows_three_hearts kobolds_freed lodge_entered
    lonelywood_arrived lottery_stand meat_meat_joined mephits_done met_durmoot met_kids
    met_nimsy met_party met_razzy met_wolves minions_down naerth_terms norsu_calmed norsu_met
    order_locket pit_done razzilith_hatched razzy_egg razzy_hatched razzy_named relics_are_lures
    reptin_bitten reptin_charge reptin_wolf requiem_done rested_lonelywood reversal rift_arrived
    rootspire_arrived saw_sixth_figure seen_illusion_fork seen_sephek_bryn seen_weeping_dark
    sephek_defeated sephek_frozen shimmer_confessed shimmer_taken stood_with_alberica
    thredra_beaten thredra_named thredra_parley thredra_sent_relics told_nothing took_left
    waste_started wennen_follow whale_oil widow_spheal wolves_beaten yeti_calmed yeti_faced
  ])
  LOOP_ACT2_FLAGS.replace(%i[
    act1_done air_pursuit air_seams alberica_marked anduin_found anduin_reconciled
    arrived_targos attendant_spoke auril_named auril_whisper autumn_fell avarice_fled badge_bryn
    badge_dougans badge_hearth badge_hew badge_luminara badge_mira badge_selrae badge_targos
    badge_undercanopy balanus_explained barricade_entered barricade_passed beat_digger_gant
    beat_digger_hobb beat_tamsin blade_found blade_seed blessing_hyphora blessing_still_sky
    blessing_warmth blight_burned blight_cleared bone_dust bridge_cracked bridge_gusted
    bryn_arrived cache_1_safe cache_2_safe cackling_entered candidate_phildendrin
    canticle_learned ch10_done ch7_started chasm_entered child_parents child_saved
    colony_recognised corsair_favour council_mira council_rheven crypt_guardian_down crypt_open
    cub_home cub_is_yetot dh_arrived dh_morning diggers_found domain_fist domain_hourglass
    domain_mask domain_paw domain_shadow domains_open dragon_down dragon_launched
    eastway_started eline_spoke engine_dead engine_dead_heart fed_pack fell_through
    festival_night followed_koran forge_reached forge_seen fork_talked found_swaddling frost_egg
    forge_camp_met summer_unmasked frostina_hatched frostina_taken fungal_liaison garagai_axe garagai_vow gate_open
    ghost_blessing glimmer_gone glimmer_has_rimefang glimmer_joined godspark_shadow golden_acorn
    good_mead_arrived good_mead_met good_mead_saved got_pokedex got_snowshoes got_splicers
    got_starter got_yeti_cub got_yetot grafting grafting_licence guild_dig_entered
    guild_ladder_down hag_defeated hag_fled hag_mirror_1 hag_mirror_2 hag_mirror_3
    hag_mirror_done hag_named hag_parley halo_orb_cleared heard_wall_rule heart_given_summer
    heart_entered heart_of_ice heartroot_entered heralds_arrested hew_confessed hew_down hew_thanked
    hollow_entered hunter_seen husband_thawed hyphora_leave hyphora_named hyphora_sworn
    icefall_fell intro_done intro_started key_attuned key_found kids_freed kids_home
    knows_rewritten knows_summer_coat knows_three_hearts kobolds_freed lake_clean lake_cleansed
    lake_entered lecture_done lirielle_dream lodge_entered lonelywood_arrived lottery_stand
    mantle_found meat_meat_joined memory_bubble mephits_done met_cornipus met_durmoot met_eirwen
    met_hellen met_kids met_nimsy met_party met_pip met_razzy met_tarin met_wolves
    minions_down mira_core_broken mira_freed mira_witness mirror_child_free mm_atoned
    mm_origin_seen mm_turned mounted_up dragoons_bound guardians_sworn mycolith_down naerth_terms norsu_calmed norsu_met
    orb_visions order_locket overflow_entered pens_seen phildendrin_found pit_done
    razzilith_hatched razzy_egg razzy_hatched razzy_named read_ledger refugees_follow
    relics_are_lures reptin_bitten reptin_charge reptin_wolf requiem_done rested_lonelywood
    reversal rheven_saw_pens rides_frostina rift_arrived rite_stopped road_a_done road_b_done
    root_key root_tier_arrived rootspire_arrived sap_gate_open sap_wells_entered saw_hooded_woman
    saw_sixth_figure seal_open seen_illusion_fork seen_sephek_bryn seen_weeping_dark seer_motes
    selrae_faced selrae_home selrae_witness sephek_defeated sephek_frozen sephek_risen
    shade_curse_broken shade_keeps_watch shimmer_confessed shimmer_taken shrine_entered
    spy_unmasked staff_found still_balance still_faith still_hope still_love stood_with_alberica
    summer_dead summer_ended talion_released thredra_beaten thredra_named thredra_parley
    thredra_sent_relics told_nothing took_hag_secret took_left trials_open twin_broken twins_met
    undercanopy_entered verdict_acquitted wall_thinning wardens_emeritus wardens_sworn
    waste_started well_vision_1 well_vision_2 well_vision_3 wells_seen wennen_follow whale_oil
    widow_spheal wolves_beaten wyn_cleared wyn_joined yarro_witness yeti_calmed yeti_faced
  ])
end

# The player's own goals (2026-11-05)
module FrostThaw
  LOOP_ACT1_FLAGS.concat(%i[glass_read broke_last_mirror]).uniq!
  LOOP_ACT2_FLAGS.concat(%i[glass_read broke_last_mirror their_time_known promised_their_time]).uniq!
end
