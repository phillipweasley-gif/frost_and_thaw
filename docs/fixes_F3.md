# Fix round: F3 (the Heartroot Labyrinth, Chapter 7B, the Forge, Chapter 9)

Every item docs/FIX_ROUND.md assigned to F3, what was done, and the test that shows it.
Focused test: `PIF_DIR=/home/claude/pifrun_F3 ruby tools/headless/try_f3.rb` (31 checks, all ok).
Also: `ruby tools/syntax_all.rb` (new: checks every file one at a time; `ruby -c a b c` only checks `a`).

## Re-audit C (rootspire.md Tab 2: the Forge)

| Item | What was done | Where | Test |
|---|---|---|---|
| B3 the golden dagger in two places | It hums where it is: Meat Meat's hands (yours as her Herald), or your pack | 034_Chapter8.rb scene_launch (~:845) | try_f3 "B3" |
| B5 A16 claw-marks at a scene that didn't exist | The H17 claw-marks sign now sets `:saw_claw_marks`; Alerion names them only if you saw them, otherwise "digging up through the roots for weeks" | build_ch7_deep.rb:131; 046_ForgeRooms.rb umber_hulk (:434) | map checks; source check |
| B6 A11 "the same words" | The overlook sets `:read_overlook`; Alerion says "Nearly the same words" and quotes it only if you read it | build_ch7.rb:66; 046_ForgeRooms.rb bunker_mirror (:310) | try_f3 "B6/B7" |
| B7 three rust-feasters, two fought | A third rust-feaster joins after the pair | 046_ForgeRooms.rb rust_feasters (:448) | try_f3 "B7: all three" |
| B8 Kord's repeated line | Kord gets his own intro ("Back to the sap! The engine's hungry!") and lose text; "Xardorok said you'd come" stays in A3 (Ruk) and the Barricade | 034_Chapter8.rb TRAINERS / TRAINER_INTROS / TEXT | smoke |
| B9 the passphrase always on offer | Offered only once learned: the duergar ledger (`:read_ledger`), Hild beaten, or `:heard_passphrase`. Otherwise the voice refuses and the game hints where the words are; the A6 lever still opens it from inside | 034_Chapter8.rb barricade_gate (:179) | try_f3 "B9" x2 |
| B10 the traitor's name | After the engine dies, he is Bram Coalhand of Thane Ostra's hold | 046_ForgeRooms.rb traitor_duergar (:244) | try_f3 "B10" |
| B11 Frostfire Flask as evidence | Left to F4 (the trial's exhibits are F4's, per FIX_ROUND); the flask still sets `:frostfire_flask` and gives FT_FROSTFIREFLASK | 046_ForgeRooms.rb heart_fuel | (F4) |
| B11 dragon "thrashes" then "eyes dark" | "Its eyes are dark now, but its chains are still swinging from the last time it pulled." | 034_Chapter8.rb:384 | source |
| C1 the way into the Forge | Eirwen's sealed passage now runs "from under the Root-Gate down past the Guild Dig... The old maps end it at a door. Iron and glass." (the Ch7 door); Glimmer hears the hammering at the festival; Frostina grows restless too on the investigation night (Alerion feels it) | 048_Rootspire_F_Downtime.rb:680; 024_Chapter6.rb:430; 048_Rootspire_E_Nights.rb investigation_night (:194) | smoke; story run |
| C3 A26's dragon straining each round | One line per Breaking Circle action, escalating from groaning chains to Avarice's smile | 034_Chapter8.rb circle action (:556) | source |
| C5 Thredra / Mother Thruuna | The hag at the table in the glass, one dead eye and one burning ember; she names herself Mother Thruuna; the price comes first (swear to burn her forge, then the secret: `:sworn_to_thredra`); once the engine is dead the mirror calls it "Paid in full" | 034_Chapter8.rb hag_tea_table (:220), TEXT tea_table | try_f3 "C5" x3 |
| P1 reactions to the launch | Meat Meat's own rage line ("She put RAZZY'S work in that...") after the others react | 034_Chapter8.rb scene_launch | try_f3 "P1" |
| P2 A4 the flight-path root model | The living root-model of the Dale, the frost-and-fire dragon with hell-red eyes circling the ten towns in order ("Good Mead first. Then Bryn Shander."); sets `:flight_path_seen`, which pays off in the Ch9 chase (Alerion and Meat Meat know its path) | 034_Chapter8.rb TEXT barricade_illusion (:87), scene_barricade; 035_Chapter9.rb sky_chase (:242) | try_f3 "A4" |

## Re-audit B (rootspire.md Tab 1)

| Item | What was done | Where | Test |
|---|---|---|---|
| B4 the Mira contradiction (her missing child; the boy and the girl unconnected) | Mira's stall: "My daughter's at home. We- I put her to bed. She's... somewhere wet." (until she's found). The boy's reflection names the girl: "There's a girl in my other half already. Mira's girl. She looked too long." | 048_Rootspire_C_Folk.rb mira_stall (:635), rs_mirror_child | try_f3 "Mira's stall", "names the girl" |
| Missing 6: Mira left possessed becomes Avarice's new body | On the Requiem, the possessed Mira offers to keep the core; you can leave it (`:mira_left_possessed`). She still gives a two-voiced Tide Seal battle, but no naval aid (`:corsair_favour` unset), no testimony (`:mira_witness` unset), her vault stays hers, her crew turn away. In the White Vault, Avarice is wearing Mira; defeated, Mira lives, crystal to the elbows, and never sails again (`:mira_freed_late`). At the Throne (if the Vault was skipped), Avarice speaks in Mira's voice. | 033_Chapter7B.rb boreal_requiem / mira_left_possessed (:359); 048_Rootspire_D_Quests.rb requiem_vault (:481); 048_Rootspire_C_Folk.rb corsair_sailor; 047c_WhiteVault.rb scene_vault_cradle, avarice_at_the_throne | try_f3 "Mira can be left possessed" x3 |
| Missing 3: Hew's gift | After Gym 5 Hew gives the Guild Root-Compass (built from Prototype 3's spare parts; usable from the bag: it points to the current goal). At the Barricade siege it wakes: comic ("Father, is that you?") then horror ("Prototype accepted. Hello, little failures."), grows root-legs and is fought; it leaves a Burnt-Out Compass | 033_Chapter7B.rb leader_hew; 034_Chapter8.rb hew_compass_wakes (:158); 046_ForgeRooms.rb items + bag handler | try_f3 "Hew's gift" x2 |
| B6 Still Sky vs the H7 slide | The blessing covers ice and snow, as the notes say ("ignore difficult terrain of ice/snow", rootspire.md 1861), not the Heartroot's slick sap (SAP_SLICK_MAPS); its text says so | 027_Relics.rb pbSlideOnIce (:322); 026_Rootspire.rb blessing text | try_f3 "B6" |

## Re-audit D (rootspire.md Tabs 3-8)

| Item | What was done | Where | Test |
|---|---|---|---|
| 12 M2 "The Whispering Mirror" | As the notes have it, and Meat Meat's: in the Bazaar, read the reflection as a trapped spirit and calm the boy so Meat Meat can take the mirror (a wrong answer makes the spirit lash out at your lead Pokémon; try again). In the Heartroot, a Mirror Sentinel (helmed horror) guards the twin; it won't open without its other half; Meat Meat presses the mirrors together and must hold them steady; failing releases a Mirror Wraith to fight before trying again; success catches the fragment in a crystal lattice (FT_MIRRORLATTICE) and frees the girl (and the boy). The scene is Meat Meat's, not Alberica's. | 048_Rootspire_C_Folk.rb boy_mirror_exorcism (:692), mirror_lash (:727); 033_Chapter7B.rb twin_mirror (:237); items in 046_ForgeRooms.rb; story_run takes the boy's mirror first | try_f3 "M2" x7 |
| 14 GQ2 "Purifying the Heartroot" | The Blessing of Verdant Fire now comes from sanctifying the Shard: tend it (Medicine) and talk the echo of Sephek into accepting Verdant Fire (Persuasion); success grants the blessing (`:shard_sanctified`); failure wakes the Frost Saint Echo (wraith) to fight: no blessing, but the corruption's out. Destroying it gives no blessing, and Sephek can't come back whole from it: wired back from splinters, his Minor Avatar starts at 60% (on top of the existing Ch11/Ch13 splinter lines). The Mirror-Root Vault now takes three successes (three threads), each failure animating a Mirror Sentinel you fight while the work goes on; progress survives a lost fight; the Mirror Shard Focus counts for two. The wells still give one Vault Map fragment, not three: the three fragments are spread across the Overflow Channel, the wells and Beyond the Wall (W3/W4's structure), so the count of three is kept. | 034_Chapter8.rb scene_heart_choice (:688); 047c_WhiteVault.rb sephek_minor_avatar (:171); 046_DeepLabyrinth.rb mirror_root_wards (:976) | try_f3 "GQ2" x5 |
| 10 the Ledger of Corruption | Not removed. F4 adds the trial-week break-in to Avarice's tower quarters (giving the ledger if it wasn't found). The re-audit's own fix says "also", and removing the Forge pickup now would leave `:ledger_found` unreachable until F4's work is merged. If F4 wants the Forge copy gone, it's one event in build_ch8_deep / 046_ForgeRooms.rb:214. | - | - |

## Shared-file and cross-fixer edits (for the merge)

- 024_Chapter6.rb (F2's): one line, Glimmer's festival line now hears hammering.
- 026_Rootspire.rb (F2's): one string, the Still Sky blessing's text.
- 048_Rootspire_C_Folk.rb (F2's): mira_stall's daughter line; rs_mirror_child's girl line and the call to boy_mirror_exorcism; new boy_mirror_exorcism and mirror_lash; corsair_sailor's possessed branch.
- 048_Rootspire_D_Quests.rb (F2's): requiem_vault's possessed branch.
- 048_Rootspire_E_Nights.rb (F2's): investigation_night gets Frostina's restless line (after the existing lines; F2 is changing its gate at the top).
- 048_Rootspire_F_Downtime.rb (F2's): Eirwen's passage line.
- 047c_WhiteVault.rb (F4's): sephek_minor_avatar weakened by `:shard_destroyed`; scene_vault_cradle and avarice_at_the_throne when `:mira_left_possessed`.
- 031_StoryItems.rb (shared): new `has_key?(item)`.
- tools/build_ch7.rb, tools/build_ch7_deep.rb: the overlook and claw-marks signs set flags.
- tools/headless/story_run.rb: before the twin mirror, take the boy's mirror in the Bazaar.

## New flags
`:saw_claw_marks`, `:read_overlook`, `:flight_path_seen`, `:sworn_to_thredra`, `:hew_gift`, `:hew_compass_woke`,
`:boy_mirror_taken`, `:mirror_sentinel_down`, `:avarice_fragment_kept`, `:mira_left_possessed`, `:mira_freed_late`,
`:shard_sanctified`, `:heard_passphrase` (read only). Items: FT_ROOTCOMPASS, FT_DEADCOMPASS, FT_BOYSMIRROR, FT_MIRRORLATTICE.

## Found while testing (also fixed)
- **The story driver couldn't reach Auril's Overflow relic** once the Still Sky blessing stopped covering sap: the relic stands mid-flow at (13,14) and is only reachable by sliding (a player stops at (13,13) above it; verified by solver). The driver now has `slide_to_event`, a BFS over slide stops, and uses it there. `tools/headless/try_slide.rb` checks it (ok).
- **A base-game battle crash:** Quash walks every battler slot, and an empty slot in an uneven double battle (the Forge's rust-feasters) is nil (`NoMethodError: effects for nil`, 007_Move_Effects_100-17F.rb:809). Guarded in 046_ForgeRooms.rb (end of file) by running Quash's check over the non-empty slots. The full runs after the fix logged no game errors.
- **A prompt collided with the driver's preset answers:** "What do you say to him?" matched the driver's `/What do you say/` rule and picked the wrong line. Reworded to "How do you calm the boy?"; the driver also retries the boy (`until_flag(:boy_mirror_taken, 3)`). One more Herald-mode line fixed ("You put your palm on the glass" as Meat Meat).
- **`ruby -c a b c` only checks `a`.** New `tools/syntax_all.rb` checks every file on its own; it caught a quoting error in the mirror boy's scene that a multi-file `ruby -c` had passed.

## Test results
- `ruby tools/syntax_all.rb`: 156 files OK.
- Map checks (`tools/build_all.sh`): all 155 maps pass.
- Smoke test: 206/211 in the worktree; the 5 failures are the gitignored cup-game and Grass-starter pictures, which pass in the full checkout.
- `tools/headless/try_f3.rb`: 31/31 ok. `tools/headless/try_slide.rb`: ok.
- Full story runs (under the heavy lock): Journey 234/234, no game errors; Herald Meat Meat 229/230, the one miss being Good Mead in Act I (the known Meat Meat run quirk, not in this slice), no game errors.
