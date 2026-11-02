# Coverage W1: Act I's Cackling Chasm and Sephek

Every row of W1's slice of the audits (`docs/audit/E_act1_published.md`: the
Cackling Chasm rows C1-C80 and the "Cold-Hearted Killer" rows R20-R27;
`docs/audit/A_session_log.md`: every Tab 2 row, the Chasm module), with where
it is now and the test that plays it.

Paths: scripts are in `game/Data/Scripts/998_FrostThaw/` (044 = `044_ChasmFaithful.rb`,
023 = `023_Chapter5.rb`, 022 = `022_Chapter4.rb`, 015 = `015_Chapter3.rb`);
maps are built by `tools/build_ch5.rb` (2041-2046, and the new 2100) and
`tools/build_ch3.rb` (2021 Lonelywood, 2024 the Lucky Liar).

Tests:
- **T** = `tools/headless/try_w1_act1.rb` (58 checks, all passing), quoted by its check label.
- **S** = `tests/smoke_test.rb` (180/180 with the ignored test pictures present).
- **R** = `tools/headless/story_run.rb` with `STOP_AT=5` (63/63 story beats).

Status: **Full** = in the game and faithful; **Changed (deliberate)** = the
campaign's own rewrite, kept; **Owner decision** = what the owner decided on
Nov 1; **N/A** = a module mechanic or a branch for a party the game doesn't have.
No row is left Compressed or Missing.

## E: The Cackling Chasm (C1-C80)

| # | Item | Status now | Where | Test |
|---|---|---|---|---|
| C1 | The hag froze Dougan's Hole; foiled, she survived | Changed (deliberate), kept | 022:790-897 | R |
| C2 | The hag's bargain: end Auril's winter and cure Reptin | Full: offered at the Twenty Stones in her words, with a choice to ask the task; called in at the Heart | 044:802 `hag_bargain_offer` (from 022:825); 023:892 `thredra_parley` | T "the hag offers her bargain…", "…the winter and Reptin's wolf"; S "the hag makes her bargain…" |
| C3 | Order of Life and Death; werewolf wardens; Reptin's curse marks him, bound by blood | Full: the lineage is now said ("It found the warden already in your blood") | 023:660 `order_ghost` | T "the ghost: … the Order's fall, the wardens…" |
| C4 | The Heart; the hag's hidden truths (temporary, empowers her, removes a warden) | Changed (deliberate: World-Tree root), and the three hidden truths are now told | 023:660 `order_ghost` | T "…the questions: the winter, the cure" |
| C5 | Hook: a parley invitation with a bargain | Full: the Stones parley carries the bargain; "Granny keeps her bargains" | 022:825, 022:874 | T, R |
| C6 | Hook: hunters' rumours of cackling | Full (unchanged) | 023 TEXT `waste_trapper`, `dh_south_block` | R |
| C7 | Reptin's vision: chained wolf, "Abandon your bond…" | Full, now with the crone's offer in the dream | 023:180 `scene_waste_start` | T "Reptin's dream carries the crone's offer" |
| C8 | General features: dark, cold, slick floors, echoes, smell, names whispered | Full: four whisper points (names, shadows like hands, a slip on glazed ice, smoke and herbs, frost on every buckle) | 044:166 `chasm_whisper`; events "Whisper" on 2042, 2044, 2046 | T "names are whispered once"; S "every chasm whisper speaks once" |
| C9 | Escalating horror toward a terrible moral choice | Full: the choice is now real (agree is possible) | 023:892 `thredra_parley` | T "you can agree to her bargain" |
| C10 | Reptin anxious; nearly loses control at the blood | Full: amber eyes and fangs in the feast hall, steadied by the party | 044:189 `scene_feast_hall_enter` | T "the feast hall: Reptin's eyes go amber…" |
| C11 | "Take me instead!" and her scornful refusal | Full: the module's refusal ("none of you reek of innocence") | 023:892 | R (story run picks it) |
| C12 | She uses Reptin in the finale (threatens, holds him) | Full: the curse-tug, then frost holds him to the knees through the parley | 023:892 | T "the hag in full…" |
| C13 | Her illusory greeting | Full: silhouette, embers for eyes, "This way… if you dare" | 023:231 | T "…after Granny's fire and the cure ahead" |
| C14 | Detecting the illusion | Full: "Watch her closely" shows it's a projection | 023:231 | T "watching the crone closely shows she's an illusion" |
| C15 | Icefall trap | Full (unchanged) | 023:258 | R |
| C16 | Ice mephits | Full (unchanged) | 023:258 | R |
| C17 | The frozen locket, Alberica's portrait | Changed (deliberate), kept; it now becomes a talisman and a daily blessing | 023:277; 044:866-898 | S "the Order's locket is only a portrait…", "…then it smiles, and blesses" |
| C18 | Gnoll femur frozen in the fallen ice | Full: "Fallen ice" event after the icefall | 044:178; 2042 (15,31) | T "the gnoll femur in the fallen ice" |
| C19 | Feast-hall carnage incl. a human arm, a trapper, a dwarf | Full | 044:189 | T "…the carnage and the runes in full" |
| C20 | Dead male yeti, heart cut out | Full, plus the frostbitten wound | 023:294 | R |
| C21 | Blood runes: Hunger, Feast, Yeenoghu over a druidic emblem | Full: read from the entry scene or the wall | 044:212; 2042 (9,22) | T "…the Yeenoghu runes are read" |
| C22 | The grieving mother yeti who fights to the death | Owner decision: she lives or dies by how you handle her. Sing (if you stood with Alberica): calmed, helps against the troll. Back away: lives, guarding her mate. Fight: she fights to the death and dies curled over him | 023:324 `mother_yeti`; 2042 page on 4003 | T "backing away…", "the lullaby…", "fighting her: she fights to the death…", "…and stays dead" |
| C23 | Footprints and drag marks | Full | 023:294 | T "the swaddling, and Reptin's vow" |
| C24 | Swaddling in the father's fist | Full | 023:294 | T (same) |
| C25 | Backpack, potion, Glimmer's journal ("…desperate to save Alberica…") | Full: the journal's lines as written, signed "Glimmer", kept as a readable key item; its last line appears after the Reversal | 023:392; 044:830 | T "Glimmer's journal, as written" |
| C26 | Coins, gnoll greataxe, necklace of ears | Full: coins (₽1,250), the axe can be taken, the ears are left | 044:220, 226; 2042 (21,25), (12,25) | T "the scattered coins…", "the gnoll's greataxe…" |
| C27 | Her echo: "such violence… time is ticking" | Full | 044:237 `yeti_after_echo` | T "…and the hag's echo: time is ticking" |
| C28 | Glassy mirror corridor, reflections that linger and grin | Full | 023:411 | T "the fork: grinning reflections…" |
| C29 | False light and a child's voice | Changed (deliberate: Shimmer's voice), kept, now with "Please… it hurts… Mama…?" | 023:411, 429 | T |
| C30 | The weeping old woman is an illusion; the right path is true | Full (now follows the notes): the weeping stops dead, there was nobody there | 023:508 | T "the dark way: … the weeping was never there" |
| C31 | Clues: breeze from the right, looped sobs, misaligned reflections | Full: a menu of clues to examine, each once | 023:429 `illusion_fork_study` | T "…every clue (air, reflections, the looped weeping)" |
| C32 | The pit trap and two ghouls | Full (unchanged), with the gnoll nest and the rot | 023:459 | R |
| C33 | Pit treasure: gnoll dagger, 15 gp and agate; potion and scrimshaw | Full | 023:487 | R |
| C34 | "SHE LIES" / "DON'T TRUST THE LIGHT" | Full (unchanged) | 2043 sign | R |
| C35 | "Poor little lambs…" | Full (unchanged) | 023:471 | R |
| C36 | Guilt on the right path; a girl's reflection later | Full: "Don't leave me! Please!" as you go, and "Why won't you help me?" in the ice at the rift | 023:508; 044:356 | T "the dark way…", "voices on the wind… and the girl's reflection" |
| C37 | The rift, bridge, frayed rope, chanting | Full | 023:536 | R |
| C38 | Ice chunk cracks onto the bridge | Full, and the cracks make the next stretch worse | 023:549 | R |
| C39 | Crossing as a skill challenge (slips, falls, ropes, plans) | Full: choose how to cross; roped, a slip dangles; slow, you go down on your belly; walking, you can go over and fall to the rift floor (new map 2100) and climb back by the ice chute | 044:253, 274, 315; map 2100 | T "you choose how to cross", "walking it… you fall to the rift floor", "roped up, a slip leaves you dangling", "the ice chute climbs back" |
| C40 | Wind gusts knock you to your knees | Full (unchanged) | 023:559 | R |
| C41 | Laughter becomes personal voices | Full: each of you hears someone | 044:356 `rift_voices` | T "voices on the wind, one each…" |
| C42 | A ghostly woman points a warning | Full (unchanged) | 023:559 | R |
| C43 | Optional threats: wisps, specter, coldlight walker, bats | Full: wisp lights and bats on the bridge; the coldlight walker on the far ledge (eyes ignite as you cross; optional fight); the cackling gnoll ghost on the rift floor; wisps there too | 044:274, 382, 390, 343; 2044 (36,15); 2100 | T "the coldlight walker's eyes ignite…", "…can be laid to rest", "the gnoll ghost on the rift floor…" |
| C44 | Sheltered nook to rest | Full, with the module's disturbances (screams, rumbling, the hum through the stone) | 023:577 | R |
| C45 | The Guardian's Gate carvings and whisper | Full (unchanged) | 023:594 | R |
| C46 | The offering puzzle | Full (unchanged) | 023:594 | T "the right offering opens the gate" |
| C47 | Wrong offering: skeleton guardians; necrotic burst | Full: an insulting offering gets the burst, then the guardians; after a failure Alerion and Reptin read the stains | 023:594 | T "an insulting offering: the necrotic burst…" |
| C48 | Door opens; vision of the rite | Full (unchanged) | 023:594 | R |
| C49 | Hairline seam to the sanctum | Full (unchanged) | 023:647 | R |
| C50 | The bier, the corpse, the vigil, the ghost rising | Full: candles and dead flowers, the air warming, the eyes opening, the spirit stepping out of the body | 023:660; 2045 bier | T "…the corpse rising" |
| C51 | The Order's fall: Yeenoghu's gnolls; she sealed the sanctum and gave herself to the wards | Full | 023:660 | T "…the Order's fall…" |
| C52 | The ghost is Alberica, last guardian | Changed (deliberate: Alberica's future self), kept | 023:660 | R |
| C53 | Werewolf wardens; Reptin's choice | Full | 023:660 | R |
| C54 | Her scheme | Changed (deliberate), kept, plus "a blight upon both life and death" | 023:660 | T |
| C55 | Warning: the innocent is a yeti child; the soul-debt | Full | 023:660, 777 `ghost_questions` | T "…the warning about the cub…", "…the winter…" |
| C56 | An alternative: cursed or freely given blood | Full: she hints at "a life freely given, or a life not yet begun" (the acorn) | 023:660 | T |
| C57 | Boons: heal; the locket as talisman; a sacred weapon | Full: heal and her one return; the locket becomes a talisman (it reveals her illusions and shields you from the Heart's lair magic in the fight); her silver dagger (a held item, ×1.25 against Ghost and Fairy) | 023:660; 044 battle hooks | T "the ghost: blessing, talisman, silver dagger…" |
| C58 | Motherly words to Reptin | Full ("Child of the wolf… a gift to this world, not a curse") | 023:660 | T |
| C59 | Prophecy of the wolf, the innocent and the crone | Full | 023:660 | T "…the prophecy" |
| C60 | Ghost fades, body crumbles, lichen dims | Full | 023:660 | R |
| C61 | Tip: only flame quells the ice-eater | Full, and it's real: the ice troll regenerates every round unless fire hit it | 023:660; 044:447 `minions_round` | T "the ice troll's flesh knits back…", "…unless fire hit it" |
| C62 | The Heart | Full (unchanged) | 023:806 | R |
| C63 | The cub in chains | Full (unchanged) | 023:806 | R |
| C64 | Her look: bruise skin, baby-teeth necklace, staff of frozen sprites | Full | 023:892 | T "the hag in full…" |
| C65 | Iron cauldron of ritual brew on blue flames | Full: in the scene, the parley, and an event | 023:806, 892; 2046 (10,7) | T, R |
| C66 | Winter wolf (Kanan) and ice troll | Full (unchanged) | 023:817 | R |
| C67 | "A life for a life… I always keep my end of a bargain… will you honour our deal?" | Full, in her words | 023:892 | T "…her bargain called in…" |
| C68 | She half pulls Reptin's curse out | Full | 023:892 | T |
| C69 | The choice: refuse, offer yourself, or agree | Full: "Never", Reptin's offer, the acorn, or "…Do it" (with a confirm) | 023:892 | T "you can agree to her bargain" |
| C70 | "The new Winter… not so fickle"; "one little monster? How weak" | Full | 023:892 | T "…and her taunt" |
| C71 | Her tactics: spells, flight on the staff, illusions | Full: she rides her staff into the air (evasion up); she splits into three (evasion again, unless the locket shows the true one) | 044:465 `thredra_round` | T "her battle: the flight on the staff…" |
| C72 | The Heart's lair actions | Full: a draining grey wave, visions of the dead (confusion), a pulse of life that heals everyone | 044:465 | T "…the Heart's lair magic" |
| C73 | The cub in danger; freeing it mid-fight | Full: the cub cries as the Heart drains; you can wrench its chains free in the lunge | 044:465, 544 | T |
| C74 | At low HP she lunges to kill the cub | Full: four answers; doing nothing without the ghost's help lets the knife fall | 044:544 `hag_lunge` | T "her lunge at the cub is stopped…", "holding still without the ghost's help: the knife falls…" |
| C75 | The ghost intervenes once | Full (unchanged), and she can catch the knife | 023:817; 044:544 | R |
| C76 | The hag dies; the Heart goes dormant | Changed (deliberate: the mirrors), kept; the Heart's backlash is used on the dark path | 023:963; 044:594 | T |
| C77 | The cub saved; a home | Full: with its mother if she lives; orphaned, it comes to you, or Reptin calls the wolves to keep it | 044:689 | T |
| C78 | The dark ending | Full: agree (or let the knife fall) and the cub dies, the sun rises, Reptin is cured and howls; she turns on you (win: a tragic victory; lose: the witch-queen ending); the wheel turns back to the start, and the next loop remembers | 044:594-677 | T "you can agree…", "…the cub dies, the winter breaks…", "…the wheel turns back", "…remembered next time round", "losing to her after the bargain: the witch-queen ending" |
| C79 | Reptin embraces his guardianship | Full: the Heart turns to him, the wolf lies down, his vow to come back | 044:689 | T "the Heart knows its warden; Reptin's vow" |
| C80 | Treasure and epilogue | Changed (deliberate: the fall) kept, and the module's treasure and legacy restored: staff, opals, scroll, cold draught, ring, pelt, Order's chest, Heart shard; wildflower, howls, the Speaker's toast, the song, the dream, the owl feather, the carving | 044:746 `chasm_spoils`, 767 `chasm_falling_glimpses`, 782 `chasm_keepsakes` | T "the spoils and the keepsakes…", "the legacy glimpses as you fall" |

## E: Cold-Hearted Killer (R20-R27)

| # | Item | Status now | Where | Test |
|---|---|---|---|---|
| R20 | Hlin Trollbane hires the party (100 gp) | Full: in the Lucky Liar, her pitch in the book's words; she pays when the murders stop | 044:909 `hlin`; 2024 (15,9) | T "Hlin Trollbane hires you…", "Hlin pays out…" |
| R21 | Torrga Icevein and Torg's caravan | Full: camped in Lonelywood's clearing; sleds, flag, dogs, a hand; her double-price shop of fenced goods; the frozen half-elf with a Luskan bounty in her sack; confront her (a fight), her strongbox | 044:992-1055; 2021 (35-37,17-23), (29,18) | T "the frozen half-elf…", "confronting Torrga…" |
| R22 | Three ice-dagger murders (Easthaven trapper, Targos shipbuilder, Bryn Shander glassblower) | Full: Hlin tells them; the glassblower ties to Kip's list | 044:909 | T "…three ice-dagger murders" |
| R23 | Motive: he kills lottery cheats | Full alongside the campaign's motive: at Torg's he admits it ("She is owed. I collect.") | 044:958 `sephek_torgs` | T "Sephek at Torg's: he admits the murders…" |
| R24 | His appearance | Full, now also at Torg's (no coat, the frozen-lake eyes, born at Midwinter) | 044:958 | T |
| R25 | His true nature: a drowned mariner possessed by a frost druid's spirit | Full: revealed in two voices when he falls at the Moon Temple | 044:1057; 015:538 | T "what Sephek really is…" |
| R26 | Cold Regeneration | Changed (deliberate: frozen, returns in Act III), kept; the spirit "can't leave him" now explains it | 015:508 | R |
| R27 | Sephek, Shimmer and the Glade | Changed (deliberate), kept | 015 | R |

## A: The Cackling Chasm module (Tab 2)

### Background, hooks, framing
| Item | Status now | Where | Test |
|---|---|---|---|
| The hag froze Dougan's Hole and survived | Full | 022:790 | R |
| Her offer: break the curse and cure Reptin | Full | 044:802 | T |
| Order; werewolf wardens; Reptin marked by blood | Full | 023:660 | T |
| The Heart; needs innocent blood; a yeti baby | Changed (deliberate root), kept | 023:660, 892 | T |
| Her hidden truths | Full | 023:660, 777 | T |
| Hook: A Hag's Bargain (parley) | Full | 022:825 | T |
| Hook: Howling in the Dark | Full | 023 TEXT | R |
| Hook: Reptin's Vision | Full, with the offer in the dream | 023:180 | T |
| Named for the gnolls' cackling | Full, and the gnolls' remains are on the rift floor | 023 TEXT; 2100 | T |
| Atmosphere | Full | throughout; 044:166 | T |
| Her wards: watchful shadows, your name whispered | Full | 044:166 | T |
| Tone: King's horror, Jordan's gravitas | Full: the horror beats are restored (carnage, guilt, voices, the corpse rising, the dark path) and the prophecy; the party's banter is the game's established voice | throughout | T |
| Party composition notes | N/A (D&D balance notes) | – | – |
| Reptin anxious, guilt-ridden | Full | 023:180 | T |
| She singles him out ("Poor boy… Give it to me") | Full | 023:180; 044:802 | T |
| He briefly loses control, steadied | Full | 023:180; 044:189 | T |
| "Take me instead!" | Full, with the module's refusal | 023:892 | R |
| If Reptin is absent, she holds a token | N/A: in this game Reptin is always with you or is you | – | – |

### Area 1
| Item | Status now | Where | Test |
|---|---|---|---|
| The illusory crone | Full | 023:231 | T |
| "I smell the wolf… Granny's fire" | Full | 023:231 | T |
| "Right this way… the cure for all your troubles…" | Full | 023:231 | T |
| Icefall | Full | 023:258 | R |
| Mephits | Full | 023:258 | R |
| The locket | Changed (deliberate), kept and extended | 023:277; 044:866 | S |
| Gnoll femur in the ice | Full | 044:178 | T |

### Area 2
| Item | Status now | Where | Test |
|---|---|---|---|
| Carnage | Full | 044:189 | T |
| Dead male yeti, heart cut out | Full | 023:294 | R |
| Blood runes | Full | 044:212 | T |
| Mother yeti attacks | Full | 023:324 | T |
| Tears frozen on her fur; calming nearly impossible | Owner decision: three ways to handle her | 023:324 | T |
| She dies over her mate | Owner decision: she does if you fight her | 023:324 | T |
| Footprints and drag marks | Full | 023:294 | T |
| Swaddling | Full | 023:294 | T |
| Healing potion | Full | 023:392 | R |
| Coins, greataxe, necklace of ears | Full | 044:220, 226 | T |
| Glimmer's journal | Full | 023:392; 044:830 | T |
| Her voice: "such violence… time is ticking" | Full | 044:237 | T |
| Reptin shaken; "We won't let her do this to anyone else" | Full | 044:189; 023:294 | T |
| Bone dust for the death bowl | Full | 023:383 | T |

### Area 3
| Item | Status now | Where | Test |
|---|---|---|---|
| Glassy corridor, the fork, light and weeping | Full | 023:411 | T |
| Reflections that linger and grin | Full | 023:411 | T |
| The child's voice | Changed (deliberate: Shimmer), kept | 023:411 | T |
| Clues | Full | 023:429 | T |
| "Don't leave me! Please!" | Full | 023:508 | T |
| Left: dead end, gnoll nest, pit | Full | 023:459 | R |
| Ghouls | Full | 023:471 | R |
| Pit loot | Full | 023:487 | R |
| "SHE LIES" | Full | 2043 | R |
| Climb out; "Poor little lambs…" | Full | 023:471, 499 | R |
| Right: the weeping stops; claw marks | Full (now an illusion, as written) | 023:508 | T |
| A girl's reflection: "Why won't you help me?" | Full | 044:356 | T |
| Lessons: emotion; the name invoked | Changed (deliberate: Shimmer), kept; the name "Glimmer" now comes through the journal | 023:392 | T |

### Area 4
| Item | Status now | Where | Test |
|---|---|---|---|
| Ledge, bridge, frayed rope, laughter | Full | 023:536 | R |
| Chanting | Full | 023:536 | R |
| The ice chunk | Full | 023:549 | R |
| Crossing: roping up, slips, near falls | Full | 044:253-322 | T |
| Gust | Full | 023:559 | R |
| Personal voices | Full | 044:356 | T |
| Ghostly woman points | Full | 023:559 | R |
| Optional threats | Full | 044:274, 382, 390, 343 | T |
| Sheltered nook | Full | 023:577 | R |

### Area 5
| Item | Status now | Where | Test |
|---|---|---|---|
| Arch, carvings, bowls | Full | 023:594 | R |
| Runes and whisper | Full | 023:594 | R |
| The puzzle | Full | 023:594 | T |
| Wrong offering: guardians, "Give life… give death…", the burst | Full | 023:594 | T |
| Door opens, vision | Full | 023:594 | R |
| Hidden seam | Full | 023:647 | R |

### Area 6
| Item | Status now | Where | Test |
|---|---|---|---|
| Chamber, lichen, bier, corpse, the spirit rising | Full | 023:660 | T |
| Her identity | Changed (deliberate), kept | 023:660 | R |
| The Order's history and the Heart as last resort | Full | 023:660 | T |
| Werewolf wardens, "Children of the Wolf", "a sacred charge" | Full | 023:660 | T |
| The Order's fall | Full | 023:660 | T |
| Her scheme: "a blight upon both life and death" | Full | 023:660 | T |
| The yeti child; "prevent this atrocity"; soul-debt | Full | 023:660, 777 | T |
| Reptin's cure vs duty | Full | 023:660, 777 | T |
| Hint: cursed or freely given blood | Full | 023:660 | T |
| Boon: heal, return | Full | 023:660, 817 | R |
| Locket recognised and enchanted | Full | 023:660; 044:465, 544 | T |
| Sacred weapon (silver dagger) | Full | 023:660; 044 `FT_ORDERDAGGER` | T |
| Motherly words to Reptin | Full | 023:660 | T |
| "Confront the witch. Save the innocent." | Full | 023:660 | T |
| Prophecy | Full | 023:660 | T |
| She lies down; dust; lichen dims | Full | 023:660 | T |
| Tips: the staff, the flame | Full | 023:660; 044:447, 544 | T |
| The Druidic Codex on the shelf | Full | 044:409; 2045 (8,3) | T "the Druidic Codex from the shelf" |

### Area 7
| Item | Status now | Where | Test |
|---|---|---|---|
| Domed cavern, dais, the Heart | Full | 023:806 | R |
| The cub in chains | Full | 023:806 | R |
| Her true form | Full | 023:892 | T |
| Cauldron | Full | 023:806, 892; 2046 | T |
| "Granny Thredra" | Full | 023 | R |
| Winter wolf and ice troll; "Warm blood!" | Full | 023:817; 044:447 | T |
| The winter wolf is a Dougan's Hole extortionist (Kanan) | Full | 023:817 | R |
| "Ssooo, my dearies… grand finale!" | Full | 023:892 | T |
| Curse-tug; "I always keep my end of a bargain"; "will you honour our deal?" | Full | 023:892 | T |
| "The new Winter, not so fickle as Auril" | Full | 023:892 | T |
| The morality taunt | Full | 023:892 | T |
| The choice | Full (with agreeing) | 023:892 | T |
| Coven option | Full: on Hard, her sister Ethel steps out of the ice and fights beside her | 044:518 `thredra_battle` | T "on Hard, her coven sister…" |
| Lair actions | Full | 044:465 | T |
| At low HP she goes for the cub | Full | 044:544 | T |
| Freeing the cub | Full | 044:544, 689 | T |
| Her death | Changed (deliberate: the mirrors), kept; the Heart's backlash on the dark path | 023:963; 044:594 | T |
| The Heart dormant | Full | 023 TEXT `heart_crystal_after` | R |
| Winter persists; a moral victory | Changed (deliberate: the Reversal), kept | 023:963 | R |
| Reptin keeps the wolf; the Heart recognises him | Full | 044:689 | T |
| Cub to a kind PC; party pet | Full | 044:689 | R |
| Leave the Heart; destroying it would be catastrophic; Reptin volunteers | Full: you choose; her voice warns you off | 044:689 | T |
| Reptin stays behind as guardian | Changed (cannot be done): the campaign's own Rootspire timeline has Reptin fall through time with the party at this moment and needs him in Acts II and III. He swears to come back, and answers the wardens' howl ("Keep the watch till I'm back") | 044:689 | T |
| Dark ending | Full | 044:594 | T |
| TPK ending (witch-queen) | Full: losing after the bargain plays it; losing in her lair plays it as a nightmare before you wake by the fissure | 044:651, 677 | T "…the witch-queen ending", "losing in her lair: the witch-queen nightmare" |

### Rewards, legacy, epilogue
| Item | Status now | Where | Test |
|---|---|---|---|
| Black Ice Staff (cackling dreams) | Full: a held item (Ice moves ×1.2) | 044:746 | T "the spoils…" |
| Opals, counterspell scroll, cold-resistance potion, Black Ice Ring | Full: three Hag's Opals, the scroll (works like a Guard Spec), the draught (an Ice Heal), the ring | 044:746 | T |
| Winter wolf pelt | Full: the hank Kanan leaves (held: halves Ice damage) | 044:746 | T |
| The locket smiles; daily Bless | Full: the description changes; usable once a day (heals a quarter, cures status) | 044:866-898 | S |
| Druidic Codex | Full | 044:409, 843 | T |
| Never-melting Heart fragment | Full (optional to take) | 044:746, 861 | T |
| Wildflower; wolf howls | Full | 044:777; 044:689 | T |
| Ten-Towns' brief respite | Changed (deliberate: the Reversal), kept; the dark path gives the module's sunrise | 044:594 | T |
| The Speaker thanks them | Full: Durmoot's toast | 044:777 | T |
| "Glimmer in the Chasm" | Full | 044:777 | T |
| Reptin sends word by wolf | Full: he answers the wardens' howl | 044:689 | T |
| The Order rekindled; the party as wardens | Full: the ghost names them wardens | 023:660 | T |
| Auril's owl feather | Full: it settles on your collar (a key item) | 044:792 | T |
| The dream: Alberica and a glowing child, "Balance is restored… for now" | Full | 044:777 | T |
| The wolf-and-bloom carving | Full (a key item) | 044:792 | T |
| The legend of the Heroes of the Cackling Chasm | Full | 044:777 | T |

## Also fixed
- `023_Chapter5.rb:135`: Reptin's "She promised to take it away" now refers to a promise the player has seen.
- `023_Chapter5.rb:98`: the mother yeti is no longer shown curled round a cub you took, and lies dead if she fought to the death.
- `tools/check_all.rb`: switch range 3900-4199 (matches `019_Switches.rb`).
