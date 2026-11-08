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
| `Items/*` (94) | The bag (84, then 10 more the same afternoon) | `build/gfx/Items` |

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

## Batch 05 (2026-11-06, 0.7.7)

| File (designer's name) | In the game as | Where |
| --- | --- | --- |
| `Characters/FT_speaker_naerth` + `Trainers/FT_SPEAKER_NAERTH_TR` | same OW name; trainer `FT_SPEAKER` | Targos (his hall, the gym), the Council of Speakers |
| `Characters/FT_speaker_duvessa_shane` + `..._TR` | same; `FT_SPEAKER_F` | Bryn Shander (the gym, the square), Ch9 on the wall, the Council of Speakers |
| `Characters/FT_speaker_edgra_durmoot` + `..._TR` | same; `FT_SPEAKER_DH` | Dougan's Hole (the gym; after the hag), the Holed Up lodge |
| `Characters/FT_matron_eline` + `Trainers/FT_MATRON_ELINE_TR` | same; `FT_HALO_MATRON` | the Shrine (Ch6), Ch11, the coda; the White Vault fight |
| `Characters/FT_winter_matron_selrae_vorn` + `..._TR` | same; `FT_WINTER_MATRON` | the Council Hall, the Sap Wells, the pens, Ch10–11 |
| `Characters/FT_halo_disciple_male` + `..._MALE_TR` | same; `FT_HALO` | every Halo brother, the masked trader, Brother Vosk |
| `Characters/FT_halo_disciple_female` + `..._FEMALE_TR` | same; new class `FT_HALO_F` | Sisters Wenna, Ilse, Odile and Ren, Oda the Silent, Eira Voss (her battle picture; her own OW is still on the list) |
| `Characters/Followers/FT_koran`, `FT_kanan` | same | Dougan's Hole, the ambush on the way home; Kanan at the Heart |
| `Items/*` (6) | same | Medicine: Clear Mind, Emberleaf, Hyphora Seed, Renewal Draught, Frostbite Tincture, Sanguine Tonic |

Notes:

- The Halo had one trainer class for brothers and sisters, so the sisters now battle as `FT_HALO_F` (same name,
  "Fractured Halo"); the map builder pairs each class with its overworld sprite, so their map sprites follow.
- `tools/check_all.rb` now also checks the Speakers', Eline's and Selrae's map sprites match their battle pictures.

Checks: smoke test 233/233 (a check that the Speakers', Matrons' and Halo classes use their own pictures);
map checks 157/157 including the new sprite-matches-picture pairs. Full games as New Journey (244/245), Wyn
(235/236) and Meat Meat (236/237), the same beats as before; all seven new trainer pictures meet the player in
battle, and the new sprites play in their scenes (`traces_077/`). The driver's new misses on 2053 and 2072 are
first tries it retried and passed, and Meat Meat's Koran miss came after a lost battle.

## Batch 05, late (2026-11-06, 0.7.7)

| File | In the game as | Where |
| --- | --- | --- |
| `Characters/FT_hlin_trollbane` | same | the Lucky Liar, Lonelywood (Ch3), replacing the old-woman stand-in |

## Batch 05, last (2026-11-06, 0.7.7)

| File (designer's name) | In the game as | Where |
| --- | --- | --- |
| `Characters/FT_master_hew_talmire` + `Trainers/FT_MASTER_HEW_TALMIRE_TR` | same; trainer `FT_GUILDMASTER` | Rootspire (by the Guild ladder, the festival, the Hearth doorway), the Guild annex gym |
| `Characters/FT_mira_of_the_north_wind` + `Trainers/FT_MIRA_OF_THE_NORTH_WIND_TR` | same; trainer `FT_CORSAIR_CAPT` | the mirror stall, the docks, the trial week, the Council (platforms, the four chairs) |
| `Items/*` (4) | same | the last medicine: Sapstone, Spore Dream, Vitality Phial, Spore Charm (104 icons in all) |

Mira's mirror stall still uses her own sprite while she's possessed; her possessed variant hasn't come in.
A New Journey run (244/245) meets both in battle and shows both sprites.
| `Characters/FT_mira_possessed` | same | the mirror stall (before Gym 6), and every later Mira if you leave her possessed (a `Game_Event#refresh` swap in 033, so map events and scene actors both follow); checked by a probe on the docks |

## Batch 06 (2026-11-06, 0.7.7)

| File (designer's name) | In the game as | Where |
| --- | --- | --- |
| `Trainers/FT_MIRA_POSSESSED_TR` | `Trainers/FT_CORSAIR_CAPT_possessed` | Gym 6, if you leave her possessed (004 picks it by `:mira_left_possessed`; probe-checked) |
| `Characters/FT_torrga_icevein` | same | Torg's camp, Lonelywood (2021) |
| `Characters/FT_coldlight_walker` | same (full opacity now) | the Frozen Rift ledge (2044) |
| `Characters/FT_captain_rheven_stormbranch` | same | the square, the festival, the Armory, the Wall, the blight, Ch6 and Ch9 scenes, the Council platforms and chairs, the crossing |
| `Characters/FT_high_speaker_kelyn_of_spring` | same | the Council Hall, the orb, the Undercanopy, the spores debate, Ch6/9/10 scenes |

Rheven's direwolf is still the Mightyena stand-in (its own follower hasn't come in).

## Batch 07 (2026-11-06, 0.7.7)

| File | Where |
| --- | --- |
| `FT_professor_wynsnow` | the prologue, the College |
| `FT_eirwen_solglass` | the Library, the Shrine (trial week), Ch6 cast, the Council platforms and chairs |
| `FT_darrus_fell` | the Council Hall, the Dragonforge (Autumn falls) |
| `FT_darrus_fell_corsair_coat` | hiding on the Smuggler's Run (after he's exposed) |
| `FT_prototype_3` | the Guild dig (replaces the Golett) |
| `FT_wennen_generic` | every Wennen in Ch3 (the Warren, guards, bearers, the driver, the Nova Keeper), the Wennen scholar, the Wennen bell |
| `FT_wennen_zenith`, `FT_wennen_luna`, `FT_wennen_jet_sentry`, `FT_wennen_lumin` | Zenith Abbott; Luna (the Warren, Dougan's Hole camp); Jet Sentry (Nimsy's window, the Warren, the gate, the sledge); Lumin at the twin orb |
| `FT_myconid_eira` | Eira Shadebloom |
| `FT_myconid_generic` | Yarro, Korun, Mnemosyne Myr, Zym, the Accountancy, the market duel, the signers, the tortured myconid (the small sporelings and Faria keep Shroomish) |

Checks: smoke 233/233, maps 157/157 (named sprites matched in check_all), New Journey 244/245 and Alberica
236/237 (the misses are lost-battle retries).

## Batch 08 (2026-11-06, 0.7.7)

| File (designer's name) | In the game as | Where |
| --- | --- | --- |
| `FT_myconid_myr`, `FT_myconid_yarro` | same | Mnemosyne Myr; Yarro (the Undercanopy) |
| `FT_duergar_guard` | same; every `FT_DUERGAR` trainer's map sprite | the Barricade (gate and the guard who speaks), all duergar trainers |
| `FT_duergar_worker` | same | the sooty traitor, the hiding duergar |
| `FT_duergar_sleeper` | same | the chanting duergar in the barracks |
| `FT_duergar_bound_captain` | same | the bound captain |
| `FT_talion` | same | at the lake ritual, in the Fields |
| `FT_var_echo` | same | stands in the liquid mirror for Var's story and fight (046), gone when the glass goes still |
| `Followers/FT_rheven_direwolf` | same | beside Rheven in the square and at the festival |
| `Pictures/S-hyphora` | same | Hyphora's leave in the root chapel (Ch7A), for the whole speech |
| `Battlers/.../proposals/FT_*_BATTLE` (8) | `Battlers/FrostThaw/bosses/FT_*` | the Shadow Mycolith and its enraged form, Sephek's Minor and Major Avatars, Avarice's Reflection, the Brittle Maiden, Winter's Womb (`BOSS_PICTURES` in 022, read in 013's sprite hook), and Avarice's crystal body (the last of her party, set when her party loads) |
| `FT_AVARICE_REFORGED_BATTLE` | `Trainers/FT_AVARICE_R` | her trainer picture: the art is drawn at 3x on a 96-pixel canvas, so it was cropped to its 80-pixel figure and set at 2x (no resampling) |
| `Pictures/S-brightmane` | **not used** | it shows a lion; Brightmane is a unicorn in the script. A redraw is on Art List 2 |

Checks: smoke 234/234 (new: every boss picture is in the art), maps 157/157, New Journey 244/245 and Reptin
236/237; a probe built each boss and Avarice's party and read back their pictures.

## Batch 09 (2026-11-07, 0.7.9)

Checked against the Art Style Guide: every file is on the 2x grid with hard edges; the walk sheets keep the feet on
row 73. Colour counts (26–45) run over the guide's 24, as every sheet in the game already does.

| File (designer's name) | In the game as | Where |
| --- | --- | --- |
| `FT_avarice_mirror_crystal_with_brass_ribs` | `FT_avarice_reforged` | her cradle in the Seraph Cradle (2170), in place of `FT_avarice` at opacity 200; 34 of its 45 colours are her Reforged battle picture's |
| `FT_avarice_duergar_priest` | `FT_devil_priest` | Vexmortis at the Dragonforge altar (2075), before he turns; afterwards the stand-in stays (he's a devil by then) |
| `FT_keegan_velryn` | same | Keegan in the Velryn house, Targos (2124) |
| `Trainers/FT_VAR_ECHO_BATTLE` | **taken out again** | against the owner's Var sheet (P1 17): grey all over, it loses his dark skin, black-and-silver hair and gold coat; the echo battle keeps Var's own picture |
| `Trainers/FT_STILL_KEEPER_ICE_ALBERICA_TR` | **taken out again** | against the owner's Alberica sheet (P1 01): she's a short, stocky dwarf with long red hair; this one is slim and tall with ginger hair |
| `Trainers/FT_AVARICE_DUERGAR_PRIEST_BATTLE` | **not used** | the battle starts after "a devil all hooks and barbs" turns round; a duergar priest there would contradict it. A devil picture is on Art List 2 |
| `FT_avarice_half_dropped_disguise` | **not used** | the four frames are speckle over a hooded shape: no face shows through and no wings unfold (the scene: "wings unfold … a devil all hooks and barbs"). A redraw is on Art List 2 |
| `Pictures/S-brightmane` (redraw) | **not used yet** | now a unicorn, as asked, but the figure at the mirror has a pale braid and a teal fur cloak; Shade wears a black hood and a green scarf. Owner's call |

The designer then put every Character Proposal and Art List 2 draft on hold (`ART-DELIVERY-HOLD.md`, Nov 7):
none is approved until checked against the owner's P1 reference sheets. Batch 09 was checked against them
here; earlier batches are the owner's call.

Checks: smoke 235/235, maps 159/159, New Journey 244/245.

## Repair 1 (2026-11-08): the template's small fixes

The first repair from the art list's "small fix" rows, against the owner's Nov 8 template (the one closest to the main
games' sprites).

| File | In the game as | Checked |
| --- | --- | --- |
| `FT_tamsin` | same (replaces it) | only the 6,544 pure-black outline pixels changed, to #0E080D; every other pixel and all alpha identical; 17 colours; exact 2x grid; feet and height unchanged. At game scale it reads as before, with the cast's tinted outline |
| `FT_shade` | same (replaces it) | only the 3,672 pure-black outline pixels changed, to #0E080D; every other visible pixel and all alpha identical (some fully transparent pixels carry different hidden colour values, which never show); 19 colours; exact 2x grid |

Held by the designer: `FT_alerion` (88 of its 2x2 blocks are off the 2x grid in the game's own sheet, so an
outline-only swap isn't enough). A grid check of every character sheet finds the same in `FT_philodendra` (935
blocks) and `FT_pip` (851); all three are added to the art list's small fixes.

## Repair 3 (2026-11-08): the mechanical fixes, done here (owner: "fix the existing sprites if that's faster")

Each fix is mechanical and was checked beside the original at game scale and close up, in every facing.

| File | Fix | Result |
| --- | --- | --- |
| `FT_alerion` | 88 off-grid blocks snapped; pure black to #0E080D | 22 colours, exact 2x, looks unchanged |
| `FT_pip` | 851 off-grid blocks snapped; pure black; 29 to 24 colours | looks unchanged |
| `FT_meat_meat` | pure black; light edges outlined (the goggles' strap, the hair's rim); 28 to 24 colours | white hair kept (owner, Nov 8) |
| `FT_shimmer`, `FT_auril_furs`, `FT_avarice`, `FT_luminara` | light silhouette edges outlined in #0E080D (Avarice also 26 to 24 colours) | full outline, nothing else changed |
| Battle: `FT_HAG`, `FT_HAG_NIGHT`, `FT_SOVEREIGN`, `FT_AVARICE`, `FT_SEPHEK`, `FT_FROST_SAINT` | 39 to 45 colours cut to 32 (the rarest merged into their nearest) | visually identical |
| Battle: `FT_TAMSIN_F`, `_G`, `_I`; `FT_HERALD_MEAT_MEAT_back` | 20 off-grid blocks snapped (Tamsin); pure black to #0E080D | visually identical |

Tried and **not** used (a hand fix or a redraw instead): `FT_philodendra` (her dress's hem and pattern are 1-pixel
details; snapping erases them; she isn't on a map yet), `FT_glimmer` (outlining eats his cream paws and the light
edge of his face), `FT_alberica_old` (35 colours across the sheet: a November draft, redrawn with the rest),
`FT_thredra_cauldron` (its steam is an effect and takes no outline), `FT_sephek` and `FT_sephek_frozen` (the head
needs redrawing). Hellen's sprite and battle picture stay as they are (owner's decision).
