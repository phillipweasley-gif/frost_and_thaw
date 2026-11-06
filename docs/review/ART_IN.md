# Art received, and where it plays

The designer's exports land in `Desktop/Pokemon fusions/Cutscene Game Assets/Graphics/`. They're copied into
`build/gfx/` (which mirrors the game's Graphics folder) and hooked up. Batch 03 is logged in
`scene/AUDIT_ACT1.md`.

## Batch 04 (2026-11-06, 0.7.6)

| File | Where it plays | How |
| --- | --- | --- |
| `Pictures/S-12a` | Ch12, the crossing: "the Sea of Moving Ice" (every route) | `Stage.panel`, 038 |
| `Pictures/S-12b` | Ch12, "The fog parts…": Grimskalle's skull | `Stage.panel`, 038 |
| `Pictures/FrostThaw/scene_rootspire_day` | Rootspire by day (already hooked in 005) | backdrop |
| `Characters/FT_iskra` (BIG) | Ch11, the roc takes Frostina; the Crown (2088) | 037 `iskra_graphic` (zoom 1.5, shadow 2.25, no tint); `build_act3.rb` |
| `Characters/FT_thredra_cauldron` | Ch5, the Heart: the cauldron, animated; held still once it's cold | `build_ch5.rb` |
| `Characters/FT_alberica_old` | The coda: old Alberica in the Chasm | 039 (the line now says beret, ghost's face, green robe over her arm) |
| `P-THR-03` | Ch5, Thredra rises on her staff (battle, round 1) | `Stage.battle_pose`, 044 |
| `P-THR-04` | Ch5, the lunge at the cub (on the map and in battle) | 044 `hag_lunge`, `hag_lunge_in_battle` |
| `P-THR-05` | Ch5, three of her (battle) | `Stage.battle_pose`, 044 |
| `P-GHO-01` | Ch5, the corpse's eyes open; the spirit rises and steps down | 023 `bier_body`, `order_ghost` |
| `P-GHO-02` | Ch5, she lies back down; the body goes to dust | 023 `order_ghost_blessing` |
| `P-REP-05` | Ch5, the feast hall: the wolf flashes at the mother yeti, and is caught | 023 `mother_yeti` (two new lines) |
| `P-REP-06` | Ch5, the Heart: held in frost to the knees | 023 `thredra_parley` |
| `K-YET-03` | Ch5, if you fight her: she drags herself to her mate and curls over him; stays there | 023, plus a "Her body" event at (16,21) in the feast hall (2042) |
| `P-SEP-05` | Ch3, Torg's: misty step across the sled | 044 `sephek_misty_step` |
| `P-SEP-06` | Ch3, the Moon Temple: the second voice | 044 `sephek_true_nature(seph)` |
| `Items/*` (84) | The bag | `build/gfx/Items` |

Notes:

- Every pose sheet came with its frames on the top row (the art list's "facing up/right" is in the drawing, not
  the row). The scripts play row 0.
- The cauldron came with 3 frames; frame 2 was copied into the empty 4th cell (a 0-1-2-1 loop) and the row
  repeated on all four rows, so step animation doesn't blink.
- `Stage.battle_pose` (043) plays a pose sheet over a battle, twice size, behind the foe's first Pokémon, and
  holds the last frame while its lines show.
- `mapkit.rb` takes `pattern:` for a page's starting frame (the yeti's curled body).
- The designer's folder also has 18 `FT_* 2.png` copies beside the icons; the plain names are the current ones.
- New request: a cold cauldron frame (Art List 2).

Checks: smoke test 232/232 (new: every pose sheet a scene plays is in the art). Full games as New Journey
(244/245), Reptin (236/237) and Alberica (236/237), the same beats as 0.7.5; an Act I run that fights the mother
yeti (70/70, `HL_PICK='What do you do=>^Fight'`, new in `story_run.rb`). Every new sheet plays where listed in
`traces_076/`. The battle poses and the overworld lunge don't show in traces (the driver's battles are
simulated, and its Thredra fight always ends in the in-battle lunge), so a probe ran both: the lunge plays
P-THR-04 on Thredra's event and puts her back; `battle_pose` draws on a stand-in battle scene and still shows
its lines with no scene at all.
