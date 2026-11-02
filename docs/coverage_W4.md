# Coverage: worker W4 (Chapter 7A's remainder; Chapter 10 to the ending)

Every row of W4's slice of `docs/audit/D_rootspire_tabs3to8.md`, plus the White
Vault and sigil rows the brief added. Branch `worktree-agent-a3bc497bfb971910e`.

**Tests** (run from the test game, `PIF_DIR=/home/claude/pifrun_W4`):

- **S**: `tests/smoke_test.rb`, 175/175.
- **T7A**: `tools/headless/try_w4_7a.rb`, 24/24 beats. It covers the Undercanopy, the rifts and the Mycolith.
- **T10**: `tools/headless/try_w4.rb`, 51/51 beats. It runs from the end of Ch9 through the trial week, Ch11, the Vault, Ch12–13 and an ending.
- **TP**: `tools/headless/try_w4_paths.rb`, all paths ok. It covers the other branches.
- **M**: `tools/check_all.rb` on the rebuilt maps, all map checks passed (100 maps).
- **SR**: `tools/headless/story_run.rb`, the full play-through under the heavy lock: 182/182 beats, from a new game to an ending. It now plays the new trial week, Ch11's sigils and relics, and the Vault. Its remaining notes aren't from W4's slice: the prologue's 2001→2091 route, Thredra moving away, and a retry after the ending.
- **L**: `tools/headless/try_loop.rb`, all ok.

The code is in `game/Data/Scripts/998_FrostThaw/` and the maps are in `tools/build_w4.rb`. The file abbreviations in the tables are:

| Short | File |
|---|---|
| 032 | `032_Chapter7A.rb` |
| 036 | `036_Chapter10.rb` |
| 037 | `037_Chapter11.rb` |
| 039 | `039_Chapter13.rb` |
| 047a | `047a_Undercanopy.rb` |
| 047b | `047b_TrialWeek.rb` |
| 047c | `047c_WhiteVault.rb` |

## Tab 4: Sephek, the character quests in W4's slice, and the group quests

| # | Row | Status now | Where | Test |
|---|---|---|---|---|
| 35 | Sephek's staged escalation: Minor Avatar with two frost druids and mephits, weakening as followers fall; Auril pours herself in; the Major Avatar with winter wolves and a coldlight walker | Full | 047c `sephek_minor_avatar` (Ch11 Shrine, from 037 `scene_frost_saint_walks`); 047c `sephek_major_fight` (Ch13 Crown, from 039) | T10 (`:sigil_sephek`, `:frostina_freed`) |
| 36 | Divine Rejuvenation while an Auril relic in the Heartroot stands | Full | 047c `auril_relic` ×3 (2057 seal circle, 2058 wells, 2067 bone-heap; SW 4138); the rematch in `sephek_major_fight`; Selrae explains it in 037 `scene_three_hearts` | T10 (`:auril_relics_destroyed`) |
| 38 | A1 Echoes at the Auroral Wall (Alerion): the frost patterns, the whispers, the reflection that steps away, the mirror maze, the reflection reclaimed | Full | 047b `echo_frost` → 2161 The Mirror Maze (three junctions, the pane, the ring of wraiths); blessing *Alerion's Reflection* (no confusion) | T10 |
| 43 | B2 The Stolen Leaf: Eirwen's request, the missing Rootwarden, across Glasswater, the frozen warden, the chronal leaf or its pieces | Full | 047b `chronal_shelf` (2062, SW 4141), `glasswater_boat`, `frozen_rootwarden` (2163) | T10 (`:leaf_restored`) |
| 44 | R1 Verdant Sickness: black sap; Rheven asks Reptin to cleanse or cut; follow the sap; the ritual; the spore blight on failure | Full | 047a `verdant_sickness_ritual`, called from 032 `yarro_blight`; Rheven at the blight (2068, SW 4121) | T7A (`:blight_cleansed`) |
| 45 | R2 Pulse of the Blooming Fields: the summer and winter spirits (Razzilith's and Frostina's), the social challenge, the token | Full | 047b `field_spirits` (2060, SW 4146); *The Fields' Two Spirits* blessing; Seasons' Token | T10 |
| 46 | W1 Shadows in the Undercity: the dockworker, the spore trail, the eyed colony; a memory, a bargain, or burn it (angers the Rootwardens) | Full | 047b `scene_smugglers_run`, `spore_trail`, `undercity_colony`; 2160 The Smuggler's Run (hatch on 2055, SW 4127) | T10 |
| 47 | W2 The Mirror Lake Ghost: a drowned cultist with a Mirror Mother shard at the new moon; rest or bind her | Full | 047b `lake_ghost` on 2078 Glasswater (Mirror-Blade, Shard of the Mirror Mother) | T10 |
| 48 | GQ1 Closing the Frostfell Rifts: the storm at the Celestial Rift, angels with Avarice's mark, three rifts in six rounds, the Lumen Shard | Full | 047a `frostfell_rifts` on 2061 (SW 4120, while Glimmer lives); *Rift-Warden's Light* (accuracy can't drop) | T7A |
| 52 | GQ4 Beyond the Auroral Wall: frozen time, suspended snow, Dougan's Hole under ice, time hazards, the Temporal Guardian, the third map fragment | Full | 2163 Beyond the Auroral Wall, 2164 The Drowned Hall; 047b `time_hazard`, `drowned_hall_ice`, `temporal_guardian` (`:vault_map_3`), `beyond_return` | T10 |
| 53 | GQ5 Trial of the Four Seasons: the Winter Matron's martial-law bid, the Council debate, the four-season dream, the Canopy's fate | Full | 036 `selrae_bid` (2054, SW 4135) → 2166 The Crystals' Dream (`season_quarter` ×4, winter last) → `seasons_outcome` (free / watched / martial law) | T10, TP |

## The White Vault, the sigils, the vault map (Tab 3 rows and the B audit's rows)

| Row | Status now | Where | Test |
|---|---|---|---|
| Three Frostshard Sigils merge, with the read-aloud ("wings spread over a frozen eye") | Full | 047c `try_merge_sigils`. The sigils come from the Echo sigil (the old Echo Gate wraiths, or the Mirror Maze's ring), Eirwen (037 `scene_four_chairs` → `eirwen_sigil`) and Sephek (dropped by the Minor Avatar). | S, T10 (`:sigils_merged`) |
| A real White Vault | Full | 2168 The White Vault (door of wings, Mirror Sentinels) → 2169 The Mirror Circuits (three circuits) → 2170 The Seraph Cradle (Avarice Reforged); reached by the path of glass north of 2163 (SW 4139) | T10 |
| Row 9, the Vault Map in three fragments | Full for W4's part | `:vault_map_3` from the Temporal Guardian. `:vault_map_1` already exists; `:vault_map_2` is W3's. Holding all three fragments explains the circuits. | T10 |
| Row 32, the third sigil (H26 Echo Vault) | Changed (by the owner's brief) | The brief: sigil 3 comes from Sephek. He drops it at the Ch11 Shrine (the notes say his defeat drops a sigil, and he can't die in Rootspire), and Ch13 gives it if it's still missing. | T10 |

## Tab 5: Hyphora's Undercanopy

| # | Row | Status now | Where | Test |
|---|---|---|---|---|
| 54–56, 58–62, 70, 73, 75, 78, 79, 81 | (Full in the audit) | unchanged | — | SR |
| 57 | Luminara won't help until the lake is cleansed and loyalty proven | Full | 032 `leader_luminara`: after the badge she holds out until the lake is clean | T7A |
| 63 | Myr: memory swap; dreamwalk | Full | 047a `myr_after` → `memory_trade`, `dream_request` (from 032 `myr`) | T7A |
| 64 | H1 Spore Gardens: Secret Nursery, Yarro's lake-errand ambush, the root-tremor collapse | Full | 047a `secret_nursery` (the moss curtain on 2068; *Sporeling's Wonder*: no flinching), `yarro_errand` (Carrion Crawler), `garden_tremor` | T7A |
| 65 | H2 Fungal Bazaar: spore games, the kobolds' theft of rapport amulets, the market duel | Full | 047a `spore_games`, `faria_theft` → 2172 The Disused Root (`kobold_nest`) → `amulets_home` (Faria's stall: `faria_stall`), `market_duel` (mediate / spar / the law from the niche) | T7A |
| 66 | H3 Council Fane: the sap pool and the Vision Table, the eight thrones, the memory niche, the Rootwarden delegation, the cultist poisoner | Full | 047a `sap_pool` (six visions: `VISION_TABLE`), `root_thrones`, `memory_niche`, `sap_delegation` (SW 4122), `fane_poisoner` (SW 4123) | T7A |
| 68 | H5 Mnemosyne's Chamber: the ritual circle, the archive, the tether threads and the shadows, the Memory Heist | Full | 047a `ritual_circle`, `memory_archive`, `tether_threads` (Shadow Demons; Hyphora's Circlet), `memory_heist` (SW 4124) | T7A |
| 69 | Undercanopy items: Rootwrap Cloak, Hyphora's Circlet, Spore-Spear | Full | 047a `RELIC_ITEMS` with battle effects; given by Eira's trial, the threads and the duel | T7A, S |
| 71 | Hook: Memory Trade | Full | 047a `memory_trade` (the memory comes back after the Dream Rescue) | T7A |
| 72 | Hook: Rootwarden Diplomacy | Full | 047a `sap_delegation` (`:rootwarden_diplomacy` / `:sap_grudge`) | T7A |
| 74 | Long-term impact | Compressed (as before) | — | — |
| 76 | Eira's development: stalkers and wraiths, the missing patrols at the Wall, the spore-guard's trial | Full | 047a `eira_development` (the patrols lead into B2's frozen warden) | T7A |
| 77 | The Shadow Mycolith's hoard | Full | 047a `mycolith_hoard`: sellable treasures, Elixir of Clear Mind, coins | T7A |
| 80 | The lake minions: Shadow Quipper Swarms, Spore-Lash Creepers dragging heroes in, before and between phases | Full | 047a `mycolith_minions(1/2)`, from 032 `shadow_mycolith` | T7A |

## Tab 8: Chapter X, Trials of the Roots (game Chapter 10)

| # | Row | Status now | Where | Test |
|---|---|---|---|---|
| 82 | Premise: Summer/Avarice's death | Full | Everyone believes she's dead (W3 sets `:avarice_faked_death`). She appears only in mirrors until the Vault or the Throne. | T10 |
| 83, 85, 88, 105, 108, 109, 114, 116, 120, 123 | (Full in the audit) | kept, reworked into the new flow | 036 | T10 |
| 84 | Aftermath: cloaks, mirrored charms, walls of root-timber and ice, refugees and traders through the Echo Gate | Full | 036 TEXT `trial_gossip_*`, `trial_trader`; the wall in the Fields (`wall_crew`, `wall_rubble`); the refugee camp (SW 4143) | T10 |
| 86 | The Verdant Tribunal: seasonal wardens, crystals, witnesses; service / exile / binding; appeal to Hyphora in the Heartroot | Full | 036 `scene_tribunal`, `scene_verdict` (acquitted / service / fine / geas; Meat Meat commuted / service / outlaw), `hyphora_appeal` (2057, SW 4150) | T10, TP |
| 87 | Social attitudes: the hushed Hearth, gossip, children's ghost stories, Candlekeep scholars | Full | 2053 Hearth hush; 2050 gossip ×3, children, scholar | M, SR sweep |
| 89 | Q1 Anduin comes to Rootspire: "what have you become?" | Full | 036 `anduin_trial` | T10 |
| 90 | Q1 Reconciliation challenge (several checks, shared memories) | Full | 036 `anduin_trial`: honesty, the cedar charm or a shared memory, what the power is for (a score) | T10 |
| 91 | Q1 The Heartroot's Test: skill challenge; the vision; Anduin stays or leaves | Full | 2165 The Attunement Way: `attunement_station` ×3, `attunement_leaf`, `attunement_finish` (6 successes before 3 failures) | T10 |
| 92 | Q1 Outcome: stewards of the Heartroot; the heart-root treant | Full | 036 `attunement_finish` (Heartwood, `:anduin_reconciled`). Anduin's outcome no longer depends on the always-set `:hyphora_sworn` (smoke check). | T10, S |
| 93 | Q1 Evidence: cedar charm, a Leaf of Hyphora, Eirwen as witness to restraint | Full | 047b `reptin_pack` / `fallen_leaves`; 036 `attunement_leaf`; `eirwen_shrine` (2056, SW 4136) | T10 |
| 94 | Q2 Arrest and root-cell; escape option | Full | 036 `root_cells` (stay / slip out / break out) | T10, TP |
| 95 | Q2 Meat Meat's mother returns; reconcile through apology | Full (Phildendrin's name kept, as the owner decided) | 036 `root_cells` | T10 |
| 96 | Q2 Trial of Redemption: the cursed mirror | Full | 036 `autumn_mirror` (2058) | T10 |
| 97 | Q2 Evidence: Rheven on Autumn's sacrifices | Full | 036 `rheven_wall` (2060). His testimony now counts: `WITNESSES` `:rheven_testimony` (smoke check). | T10, S |
| 98 | Q2 Evidence: Autumn's secret labs | Full on W4's side | `WITNESSES` reads `:autumn_labs_seen`, which W3 sets | — (W3) |
| 99 | Q2 Evidence: Mira commissioned... the cursed mirror; her favour | Full | 036 `mira_trials` (Mira's page on 2055), `mira_cursed_mirror` (2057, SW 4142), `mira_mirror_return` | T10, TP |
| 100 | Q2 Evidence: refugees on extortion and forced labour | Full | 036 `refugee_voice` (Easthaven, Bryn Shander, Termalaine) | T10 |
| 101 | Q2 Outcome: commuted, or outlaw | Full | 036 `scene_verdict` | T10, TP |
| 102 | Q3 Summoned by an emissary at the Echo Gate | Full | 036 `wyn_emissary` (Sorrel, 2050) | T10 |
| 103 | Q3 The hearing | Full | 036 `wyn_hearing` (2054, SW 4152) | T10, TP |
| 104 | Q3 The Underdark Door crawl with escorts; quippers, creepers, an invisible stalker | Full | 2077 rebuilt; `scene_underdark_crawl`, `underdark_ambush` ×3, `underdark_door` | T10 |
| 106 | Q3 Evidence: the junior Rootwarden who saw disguised cultists | Changed (the notes' Darrus is the dead Autumn Warden, so he's replaced by Pell) | 036 `pell` (2055, SW 4153) | T10 |
| 107 | Q3 Evidence: a Mirror Wraith shows the cultists | Full | 047b `maze_witness` (`:wraith_witness_door`; needs a memory vial or Wyn) | T10 |
| 110 | Q4 Talion appears in the Blooming Fields | Full | 2060 Talion (SW 4131); foreshadowed at the Echo Gate (047b `echo_frost` sets `:talion_foreshadowed` if W5 hasn't already) | T10 |
| 111 | Q4 Investigation; wraiths call him a reflection | Full | 036 `talion` (pulse, listen); 047b `maze_witness` (`:wraith_called_reflection`), `talion_lake_inquiry` | T10 |
| 112 | Q4 "This isn't real"; the shattering mirror; the Mirror-Blade Specter | Full | 036 `talion` (embrace), `talion_resolve` (hold on → specter) | TP |
| 113 | Q4 The night ritual at the Mirror-Lake, or accept the fade | Full | 036 `talion_ritual` on 2078 (SW 3990): frost-glass from Mira, Mira's advice, the carved whistle | TP |
| 115 | Q4 Outcome: closure, or a vengeful specter later | Full | 039 `test_isolation`: Talion's Echo fight if he's haunted or chased (`:talion_laid`); an alive line if restored | T10, TP |
| 117 | Q5 Debate before the Council | Full | 036 `spores_debate` (2054 "Spring and Winter") | T10 |
| 118 | Q5 Escort through the caverns; the Mirror Wraith warning | Full | 036 `councillors_undercanopy` | T10 |
| 119 | Q5 The verdict: persuade, or the myconids leave | Full | 036 `councillors_undercanopy` (score: `:colony_recognised` / `:colony_exiled`) | T10 |
| 121 | Q5 Evidence: Luminara's blessed leaf; Winter's fear and the frostbite tincture; history scrolls; Wyn and Reptin | Full | 036 `luminara_blessing` and `yarro_tincture` (reached through 032's Luminara and Blight events during the debate); 047b `old_alliances` (2062) | T10 |
| 122 | Q6 The town criers; the carpenter needs help with the wall | Full | 036 `scene_trial_morning` (2050 autorun, SW 4151) | T10 |
| 124 | Q6 Slaudi on the diverted caravans | Full | 047b `slaudi` (Bryn Shander 2012, SW 4144) | M |
| 125 | Q6 The memory bubble | Full | 036 `memory_bubble_offer` | T10 |
| 126 | Q6 A Mirror Wraith's echo of Avarice ordering the sacrifices | Full | 047b `maze_witness` (`:wraith_echo_avarice`) | — (offered in the maze) |
| 127 | Q6 The Ledger; Rheven's sigil-horns; the civic layer (walls, wolves, electioneering, debates, mud-slinging, platforms, petitions) | Full | `WITNESSES` reads `:ledger_found` (W3); `rheven_wall` horns; 036 `wall_crew`, `refugee_blankets`, `wall_wolves`, `debate_stage`, `mud_slinging`, `start_petition`, `petition_signer` (seven factions on five maps), `scene_vote` | T10, TP |

## Bugs the brief listed

| Bug | Fixed | Test |
|---|---|---|
| Anduin's outcome keyed on the always-set `:hyphora_sworn` | 036: it comes from the reconciliation score and the Test | S |
| Rheven's testimony not counted | `WITNESSES` `:rheven_testimony` | S |
| Eirwen's Naerth ledger never used | 036 `eirwen_shrine` (2056, trial week): Eirwen brings it to the court (`:naerth_ledger`, a summer witness) | S, T10 |
| Talion never foreshadowed, and in the wrong place | Echo Gate whisper (047b), and he moves to the Fields and the Glasswater | T10 |
| Evidence leads | `:ledger_found` and `:autumn_labs_seen` are read; W3 sets them | — |

## Owner decisions, as implemented

- **Avarice faked her death.** She is believed dead through Ch10, appearing only in the mirrors (the Autumn mirror's white-haired woman, the wraiths' echo, the memory bubble). The reveal comes in the optional White Vault, or at the Throne of Frost if the Vault is skipped. Both endings end with her (`:avarice_revealed`, `:avarice_ended`).
- **The coat twist** is unchanged (W3 restores Var's story). `:var_story_known` is a Ch10 witness.
- **Phildendrin** keeps her name.

## Merge notes and overlaps

- **Rebuild after merging.** `tools/build_all.sh` runs `build_w4.rb` after `build_act3.rb`. The `build/maps` binaries will conflict between workers: take either side, then rebuild.
- **`build_ch10.rb` is slimmed.** 2077 and 2078 moved to `build_w4.rb`. The old Root-Tier→Glasswater tunnel and the Shrine's Selrae (the bid is in the Council Hall now) are removed.
- **`check_all.rb`'s switch range** is widened to 3900–4199, to match `STORY_SWITCHES`.
- **W5 overlap.** W5 may also set `:talion_foreshadowed` and `:sigil_eirwen`. W4's code checks both flags first, so whichever comes first wins and nothing is given twice. The 2160 Guild vault door is a hook for W5's M1 heist, if wanted.
- **Story driver.** `story_run.rb`'s main block is now under `if __FILE__ == $0`, so the focused tests can load `Story`.
