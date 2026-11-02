# Coverage: W2 (Act I, Ten-Towns)

Every row of `docs/audit/E_act1_published.md` section 3b in W2's slice (R1-R64, without
R20-R27, which are Sephek's *Cold-Hearted Killer* rows and belong to W1), plus the audit's
"gaps" 6-10, 12, 13 and its internal inconsistencies that touch Ten-Towns.

Status now: **Built** (was Compressed/Missing, now made in full), **Fixed** (was a
contradiction or an unapproved Changed row, now follows the book), **Full** (was already
Full; untouched or only checked), **Changed (approved)** (the campaign's deliberate rewrite,
kept).

Where: file:line is `game/Data/Scripts/998_FrostThaw/` unless it starts with `tools/`.
Maps are by id. Builders: `tools/build_tentowns.rb` (all maps 2120-2137, and the patches
to older maps), plus small edits in `build_act1.rb`, `build_ch2.rb`, `build_ch4.rb`.

Tests:
- **check_all**: `ruby tools/check_all.rb` (every built map: walkable arrivals, reachability,
  edges, switch range, invisible signs; 107 maps, all pass). W2 widened it: script arrivals
  on 21xx maps are now read (the regex only knew 20xx), a gate a story switch opens no longer
  counts as a wall, and two doors on one tile to different maps is now an error (it caught
  build_ch3's old Bryn-to-Lonelywood warps lying under the new Termalaine ones).
- **smoke**: `ruby tests/smoke_test.rb /home/claude/pifrun_W2` (174/174). The Ten-Towns
  checks are: "every FT method a map event calls exists", "the Ten-Towns quests' switches are
  all 4040-4079, and distinct", "the Ten-Towns maps are built and named", "every Pokémon the
  Ten-Towns quests send at you exists", "every Frost & Thaw item the Ten-Towns quests give or
  take is registered", "Lonelywood is reached through Termalaine". The older "every map
  event's dialogue/trainer/scene exists" and "every door leads to a map that exists" cover
  the new maps too.
- **try_w2**: `PIF_DIR=/home/claude/pifrun_W2 SCEN=<s> BRANCH=<b> ruby tools/headless/try_w2.rb`
  (the real game, headless; walks the doors, talks to the people, fights the battles). Every
  scenario and branch below passed in full; counts are checks passed.
- **story_run**: `flock /tmp/ft_heavy.lock` + `STOP_AT=5 tools/headless/story_run.rb`
  (results at the end of this file).

## Targos

| Row | Item | Status now | Where | Test |
|---|---|---|---|---|
| R1 | Walled town on the lake | Full | `tools/build_act1.rb:55-125` | story_run (Targos beats) |
| R2 | Naerth Maxildanarr's background | Changed (approved: Gym 1). His Luskan Arms snakes and his seat at the Council added | `045_TenTowns.rb:79-82` (flying snakes), `:380-390` (council) | try_w2 targos 6/6, council 3/3 |
| R3 | Skath | Full | `006_Dialogue.rb:114-115` | smoke (dialogue exists) |
| R4 | Luskan Arms: oldest inn, rotten floors, rats, Owenn Tarsenel, Naerth's flying snakes | Built | `045_TenTowns.rb:74-82, 161-178`; `tools/build_act1.rb:204-208` (map 2004) | try_w2 targos |
| R5 | Three Flags Sailing: Ma Yarbroul, rumours | Built | `007_Story.rb` (MA YARBROUL); `045_TenTowns.rb:148-154` (d10 rumour table); `tools/build_act1.rb:187` | try_w2 targos ("the Three Flags fisher passes on a rumour") |
| R6 | Triglio, Jestin Hunrae | Built | `045_TenTowns.rb:180-193`; `tools/build_act1.rb:293-295` (map 2007) | try_w2 targos ("Jestin Hunrae at Triglio") |
| R7 | Lottery only in Bryn Shander, Easthaven and Targos | Fixed | `006_Dialogue.rb:28`; `007_Story.rb:306` | smoke (dialogue) |
| R64 | Sacrifices: warmth (Good Mead, Dougan's Hole), food (Lonelywood) | Built | `045_TenTowns.rb:110-124`; NPCs patched in by `tools/build_tentowns.rb` "Small patches" (maps 2021, 2031, 2035) | check_all (people stand on floor), smoke (dialogue) |
| R8 | *Mountain Climb*: Boy, Keegan, Garret, Kelvin's Cairn, the yeti family, Perilou, Astrix | Built | `045_MountainClimb.rb:148-545`; maps 2124 (Velryn house), 2125 (open tundra), 2126 (Kelvin's Cairn), 2127 (heights), 2128 (yeti cave), `tools/build_tentowns.rb:71-276`; Boy and the Velryn door `tools/build_act1.rb:121, 136-142` | try_w2 climb peace 18/18 (mother yeti left in peace, Garret comes along), climb fight 18/18 (mother yeti fought, Garret sent home) |

## Bryn Shander

| Row | Item | Status now | Where | Test |
|---|---|---|---|---|
| R9 | Walled hill town, gates shut at dark | Full (arrival text now from the book: two log rings, rubble, lanterns) | `014_Chapter2.rb:478-484` | story_run |
| R10 | Speaker Duvessa Shane, young, lawful good, head of the Council | Fixed (the Zhentarim debtor story is gone) | `014_Chapter2.rb:6, 125, 182, 655-688`; broker `:200-209` ("sends our coin back unopened") | story_run (Duvessa's badge) |
| R11 | Sheriff Markham Southwell | Built | `045_TenTowns.rb:195-208`; `tools/build_ch2.rb:280` | try_w2 bryn 14/14 |
| R12 | Council of Speakers meets at the Council Hall | Built (the session the morning after the lottery) | `045_TenTowns.rb:360-417`; map 2134 `tools/build_ch2.rb:409-426`; door `:250` | try_w2 council 3/3 |
| R13 | Blackiron Blades: Garn the Hammer and Elza | Built | `045_TenTowns.rb:210-248`; `tools/build_ch2.rb:313-314` | try_w2 bryn, mugs (Elza's discount) |
| R14 | House of the Morninglord | Full | `014_Chapter2.rb:314-336` | story_run (acorn) |
| R15 | Copper Knobberknocker and the Black Cabin | Built | `045_TenTowns.rb:250-280`; `tools/build_ch2.rb:301` | try_w2 bryn ("Copper and the Black Cabin") |
| R16 | The Northlook: Scramsax, credit at interest, Ol' Bitey | Built | `045_TenTowns.rb:282-358`; `014_Chapter2.rb:498-510` (rest on credit); `tools/build_ch2.rb:321-322` | try_w2 bryn ("Scramsax offers credit", "collects his tab", "Ol' Bitey"); story_run (rest until sundown) |
| R17 | *Foaming Mugs*: Hruna, Korux, Storn; Oobok; the blizzard; Izobai's goblins and polar bears | Built | `045_FoamingMugs.rb:66-270`; dwarves `tools/build_ch2.rb:284-290`; map 2125 `tools/build_tentowns.rb:87-145` | try_w2 mugs fight 10/10, bears 11/11, kindness 11/11 |
| R18 | The lottery drawing | Changed (approved: the campaign's lottery night, matches the session log) | `014_Chapter2.rb:479-651` | story_run (lottery beats) |
| R19 | Rigged lotteries | Full | `017_TargosExtras.rb:228-235` | smoke |

## Lonelywood and Termalaine

| Row | Item | Status now | Where | Test |
|---|---|---|---|---|
| R28-R33 | Lonelywood's people and places | Full | `015_Chapter3.rb` (W1's file) | story_run |
| R33 | Ramshackle | Full, and now usable once the moose is dead | `045_WhiteMoose.rb:234-255`; map 2137; door patched in Lonelywood (`tools/build_tentowns.rb` "Lonelywood: the logging road...") | try_w2 moose ("Ramshackle's door opens for you") |
| R34 | *The White Moose*: Nimsy's offer, the tracks (an hour per search, a Survival roll, a d6 per set of tracks: only a 6 is the white moose; a pity floor makes the 6th set always his; failed searches turn up a snare's berry, a hunter's cache, a wolf pack, a wrong turn, or a brazier ingredient), the forest encounters table every three hours, the elven tomb E1-E9, the moon dial, the Mirror of the Full Moon (seven questions), Sahnar, Ravisin, the berry bush, Vurnis, the reward and Ramshackle | Built | `045_WhiteMoose.rb` (tracks `:272-340`); maps 2129 (Lonelywood forest), 2130 (tomb), 2131 (barrow), 2137 (Ramshackle) `tools/build_tentowns.rb:720-921` | try_w2 moose barrow 44/44, outside 46/46 (watch from the trees; 6 sets, the pity floor), cookies 44/44 (no fee), spare 36/36 (Ravisin left alive: the awakened bear); try_w2 searches 2/2 (all six failed-search outcomes) |
| R35 | Lonelywood connects only to Termalaine | Fixed | Bryn's north gate goes to the Termalaine Path (2121), Termalaine (2120), then the Lonelywood Road (2020); `tools/build_ch2.rb:253`; `tools/build_tentowns.rb:483-719`; guard text `015_Chapter3.rb:133` | try_w2 route 10/10; smoke ("Lonelywood is reached through Termalaine") |
| (Termalaine) | The town (RotF pp. 93-99): Oarus, Shaelen, Darmo, Vernon and the Blue Clam, Marta, Clyde and the Eastside, the ring of warmth, the militia's disloyalty | Built (needed for R35) | `045_Termalaine.rb:1-260`; maps 2120-2123 | try_w2 termalaine 12/12 |
| (Termalaine) | *A Beautiful Mine*: M1-M13, the saboteurs, the bucket lift and shuttle, the grell, Grek and Smol, Trex and Janth's ghost, the psi crystal, the geodes; the three outcomes | Built | `045_Termalaine.rb:280-590`; maps 2135, 2136 | try_w2 mine clean, ghost, grell, town (all pass) |

## Good Mead

| Row | Item | Status now | Where | Test |
|---|---|---|---|---|
| R36-R39 | Founders, bees, Kendrick, the shrine, Redwaters | Full | `022_Chapter4.rb` (W1's file) | story_run |
| R40 | Fef Moryn and the fox (now for sale) | Built | `045_MeadMustFlow.rb:143-165`; Good Mead patch in `tools/build_tentowns.rb` | try_w2 mead ("you buy Fef's fox") |
| R41 | *The Mead Must Flow*: the carnage, the chwinga and the fox, and the chwinga's **Charm of Animal Conjuring** (a battle item: three uses, conjured beasts strike every foe for a quarter of its health, then it fades), the ogre's tracks, the lair V1-V10 (Friend, the baskets, the casks, Artin, the named livestock, Yogobor, the Silvanus pool, Duhg, the cursed chieftain: no benefit from any night's rest until you put her things back), Gahg and her basket (stand aside, stop her, run, or **hide back in the cave**: she finds Duhg, then hunts for you; sneak past, or fight her, or both verbeeg), home with the mead | Built | `045_MeadMustFlow.rb` (charm `:120-160` and its battle handlers at the end of the file; Gahg `:518-600`; the long-rest hook `:488-512`); maps 2132 (woods), 2133 (lair) `tools/build_tentowns.rb:922-1060`; the woods path `tools/build_ch4.rb` Good Mead section | try_w2 mead run 37/37, back 37/37, letgo 36/36, decline 31/31, away 33/33, curse 42/42, hide 34/34 and hidealive 34/34 (each run with and without Shade, so both "missed you" and "found you" happen); try_w2 charm 8/8 |
| R42 | The new town speaker: Olivessa asks the leader to run; the vote a week or two later | Built | `045_MeadMustFlow.rb:625-670, 700-790`: each night's rest anywhere is a day (`long_rest_taken`, called from every inn and attic rest); the vote is on the 8th day, in the shrine if you're in Good Mead, or by rider if you're away; declining leaves Shandar unopposed | try_w2 mead run (you win), back (Olivessa wins), decline (Shandar unopposed, by rider), each checking "no vote before the week is out" |
| R43 | Shandar blackmailed; he hikes to Targos and is back the next day; a day later the staged thug "rescue"; interrogating a thug | Built | `045_MeadMustFlow.rb:671-760`; the mead hall's evening news (map 2032 patch: the thugs, then the vote) | try_w2 mead run/back (exposed: the thug is kept in the cooperage until the vote), letgo (Shandar wins), away (the rescue happens without you) |

## Dougan's Hole and *Holed Up*

| Row | Item | Status now | Where | Test |
|---|---|---|---|---|
| R44-R49 | The town, Durmoot, the Stones, the chorus, the militia | Full | `022_Chapter4.rb` | story_run |
| R50 | Koran's Garagai lie, the limp, Kanan the bad wolf | Fixed | `045_HoledUp.rb:87-138` | try_w2 holed follow, lie, bad (19/19 each) |
| R51 | Norsu: evil, the master behind the extortion | Fixed | `045_HoledUp.rb:233-295` | try_w2 holed ("Norsu, the master behind it all") |
| R52 | The tundra and the starving pack | Changed (approved: Reptin's bite, now as the notes play it) | `045_HoledUp.rb:151-184` | try_w2 holed; story_run (the starving pack) |
| R53 | Three entrances; the wolves nudge you in and wait outside | Built | `045_HoledUp.rb:186-215`; maps 2039/2040 rebuilt `tools/build_tentowns.rb:277-463` | try_w2 holed ("the wolves nudge you") |
| R54 | L2 flensing chamber | Full | `045_HoledUp.rb` (whale_oil, lodge_chest) | try_w2 holed ("whale oil") |
| R55 | L3 cage: oil, heat the slats, pick the lock | Built | `045_HoledUp.rb:380-464` | try_w2 holed (pick the lock) |
| R56 | L4 icicle corridor (creep or hurry) | Built | `045_HoledUp.rb:217-231` | try_w2 holed ("the icicle corridor") |
| R57 | L5 Norsu calmed by friendship or a vow; a prayer | Full | `045_HoledUp.rb:240-295` | try_w2 holed |
| R58 | The ice throne's blizzard | Built | `045_HoledUp.rb:297-320` | try_w2 holed ("the ice throne's blizzard") |
| R59 | L6 war room, the kobolds | Full | `045_HoledUp.rb:340-360` | story_run (the kobolds) |
| R60 | L7 Garagai's bedroll | Built | `045_HoledUp.rb` TEXT garagai_bedroll; map 2040 | smoke (dialogue) |
| R61 | L8 whale oil, the remorhaz tunnel | Full | map 2040 | try_w2 holed |
| R62 | The wolves' ambush on the way home | Changed (approved: both flee to the chasm, for W1's Chapter 5) | `045_HoledUp.rb:466-499` | try_w2 holed ("the wolves' ambush") |
| R63 | Hilda's boots of the winterlands ("he was my older brother too") | Built | `045_HoledUp.rb:24-31, 62-85` | try_w2 holed ("the boots of the winterlands") |

## The audit's inconsistencies

| Item | Status now | Where | Test |
|---|---|---|---|
| Bryn Shander is south-east of Targos, not north | Fixed | `007_Story.rb` goal text; `014_Chapter2.rb:377, 467`; `006_Dialogue.rb:15` | smoke (dialogue) |
| Easthaven routing (the Eastway runs to Easthaven; Good Mead and Dougan's Hole are off it to the south) | Fixed | `014_Chapter2.rb:165` (bryn_east_guard) | smoke |
| The sun ("hasn't cleared the mountains since the Rime set in") | Fixed | `006_Dialogue.rb:25` | smoke |
| The Holed Up header promised a frost-giant story the dialogue didn't tell | Fixed (the lie is told) | `045_HoledUp.rb:87-114` | try_w2 holed |

## Story runs (STOP_AT=5, under `flock /tmp/ft_heavy.lock`)

- After the four follow-up changes (d6 tracks, the charm, Gahg's hide option, the week-long
  election and its rest hook): Journey **63/63** (79 s), Herald (Shade) **59/59** (63 s).
- Before them: Journey **63/63** story beats (68 s, 2 retries after lost battles). The way north now runs
  Bryn Shander, the Termalaine Path, Termalaine, the Lonelywood Road; the Northlook's
  "Rest until sundown? ($300, or on credit)" prompt still starts lottery night.
- Herald (Reptin): **59/59** story beats (77 s, 2 retries).
- One earlier Journey run lost to Duvessa and then reported her as unreachable for every
  retry (20/63). The next run passed 63/63, and a focused repro found a route to her both
  before and after a loss, so I'm treating it as harness flakiness after a whiteout, not a
  map fault. Worth watching.
- The harness (`tools/headless/story_run.rb:271`) now talks to `/Innkeeper|Scramsax/`, because
  the Northlook's keeper is Scramsax.
