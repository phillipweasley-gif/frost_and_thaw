# Re-audit E: Act I (Chapters 1-5) against The Cackling Chasm and Rime of the Frostmaiden

Scope and method:
- **The Cackling Chasm** (`sources/cc.txt`): I read all 1,330 lines, in chunks of about 300.
- **Rime of the Frostmaiden** (`sources/rotf.txt`): I read these sections in full:
  - the Ten-Towns overview and the Ten-Towns Rumors table (R 820-1080)
  - Sacrifices to Auril and the Council of Speakers (R 1028-1060)
  - Cold-Hearted Killer: Hlin, Torg's, Torrga and Sephek (R 1083-1315)
  - Bryn Shander and Foaming Mugs (R 1726-1963)
  - Dougan's Hole and Holed Up (R 3068-3384)
  - Easthaven routing (R 3385-3444)
  - Good Mead, The Mead Must Flow and New Town Speaker (R 4070-4459)
  - Lonelywood and The White Moose (R 4462-4905)
  - Targos and Mountain Climb (R 4910-5264)
  - Termalaine and A Beautiful Mine (R 5268-5708)
- **What counts as "in the game":** I dumped every event page from the compiled maps (`build/maps/Map*.rxdata`) with its conditions and script calls. That's 3,221 pages, 1,648 of them on Act I maps (2000-2046, 2100, 2120-2137). For each row, I checked that the function exists, that a placed event (or a scene it calls) reaches it, and that its switch or flag conditions can become true.
- **Map checks:** `tools/check_all.rb` passes on all 155 maps.
- **Read-only:** I changed no files under `/home/claude/frost-thaw`.

Citation conventions:
- **CC n** is a line in `cc.txt`. **R n** is a line in `rotf.txt`.
- Code is cited as `file:line`, relative to `game/Data/Scripts/998_FrostThaw/` unless the path starts with `tools/`.
- Map events are cited as `MapID E<event>` from my dump.

---

## 1. Summary

### Counts (242 rows in section 3)

| Source | Full | Compressed | Changed | Missing | Unreachable | Total |
|---|---|---|---|---|---|---|
| The Cackling Chasm | 77 | 2 | 10 | 0 | 0 | 89 |
| RotF: towns, quests and NPCs the game uses | 126 | 8 | 15 | 4 (2 optional in book) | 0 | 153 |
| **Overall** | **203** | **10** | **25** | **4** | **0** | **242** |

How the Changed rows break down:
- **CC: 10 rows.** 8 are the campaign's own rewrites or owner decisions: the Twenty Stones night, the Heart as a World-Tree root, Alberica's face on the locket and the ghost, Shimmer's voice at the fork, the mother yeti who can live, the hag's scheme, and the mirror ending. The other 2 are integration choices that I judge in section 2:
  - Reptin can't stay behind as warden.
  - **The dark ending turns the whole story back to the start.**
- **RotF: 15 rows.** 10 are deliberate: Gyms 1-3 on the three speakers, lottery night, Sephek's Shimmer story, his frozen non-death, the shapes on the ice, the starving pack's bite, and the wolves fleeing to the chasm. 5 are neither:
  - Hlin has moved to Lonelywood.
  - The Targos-Termalaine road is closed.
  - The Easthaven road is closed.
  - Three accounts of Sephek's victims disagree.
  - Garret's father yeti is calmed by your Yetot instead of the Littlest Yeti secret.

### Honest judgement

**The build-out did what the last audit asked.** Every gap ranked in the previous `docs/audit/E_act1_published.md` is now in the game and reachable:
- the hag's bargain
- the dark path
- the ghost's history, warnings, prophecy and boons
- the hag in full, with her cauldron, flight, lair magic and lunge
- Hlin, Torg's and Sephek's true nature
- Koran's lie and Norsu as master
- all five missing town quests (Mountain Climb, Foaming Mugs, The White Moose, The Mead Must Flow with the election, A Beautiful Mine) and the missing Bryn Shander NPCs

The geography and lottery slips are fixed:
- Bryn Shander is south-east of Targos.
- Only three towns hold the lottery.
- Lonelywood is reached through Termalaine.
- The Easthaven routing is right.
- Duvessa is honest again.

**Room by room, both sources are now adapted almost completely,** often near-verbatim. That includes the optional material: coven sister on Hard, coldlight walker, wisps, the gnoll ghost on the rift floor, the chieftain's curse, the Mirror of the Full Moon, the psi crystal. I found no cut corner in the content itself. The 10 Compressed rows are small, for example:
- the cub is in danger only after the hag's battle, not during it
- Torrga has one named thug instead of four
- no dinosaur carvings in Good Mead
- the father yeti is calmed by a Pokémon instead of a character secret

**What is not finished is robustness.** Seven bugs matter:
- **The starving-pack bite can be skipped.** It is the campaign's origin for Reptin's lycanthropy, and every later scene says "the bite".
- **The new dark path ends in `start_loop`, which doesn't reset Act I's side quests.** Their map self switches and state counters survive the loop, so Good Mead's election can "happen" in Targos on loop 2.
- **The canonical third way assumes an optional golden acorn.**
- **The Council of Speakers scene can play after Kendrick is dead.**
- **Oarus goes on chatting after the grell has killed him.**
- **Garret can be rescued before Keegan ever asks.**
- **Hlin hires you for a man you have already frozen.**

None of these is hard to fix (section 2). Until they are, Act I is faithful in content but not yet bulletproof.

---

## 2. Every row that is not Full, plus the bugs, ranked by importance

### 1. BUG: The starving-pack bite, origin of Reptin's lycanthropy, can be skipped (DH11)

- **Campaign and source:** the she-wolf's bite gives Reptin his lycanthropy. RotF R 3212-3218 has only a starving pack.
- **In the game:** the bite happens only if you press A on one of the four "Starving wolf" events (`2039 E9-E12`, trigger 0, action button; built in `tools/build_tentowns.rb:319-320`). It sets `:reptin_bitten` (`045_HoledUp.rb:151-179`).
- **The bypass:** I ran a flood fill on Map 2039 from the tundra entrance (57,16) to the lodge front (21,12) with the wolves as obstacles. The lodge is reachable, so a player can walk round the pack.
- **What then breaks:** these scenes refer to a bite that never happened:
  - `022_Chapter4.rb:608` ("hand closing over the bite")
  - `044_ChasmFaithful.rb:810` (the hag's bargain)
  - `023_Chapter5.rb:191` and `:202` ("The bite. It's the bite.")
  - `023_Chapter5.rb:612-613` ("bitten hand")
- **Fix:** make it a trigger row across the tundra (trigger 1, like the "Ambush" row at x 26), or an autorun when the pack comes into view. Or, as a safety net, call `starving_pack` from `scene_lodge_approach_step` if `!flag?(:reptin_bitten)`.

### 2. The dark ending restarts the whole story (C84), and the loop it starts leaks Act I state (BUG)

**The source (CC 1147-1152, 1198-1215).** The module calls its dark ending "a valid, if dark, ending": the winter breaks, Reptin is cured, and the party lives with it.

**How the game plays it.** The ending is played in full, and you can reach it two ways:
- answer "...Do it." (`023_Chapter5.rb:933-940`, which leads to `044_ChasmFaithful.rb:594-648`)
- choose "Stay where you are" at the hag's lunge without the sanctum's talisman or blessing (`044_ChasmFaithful.rb:582-584`)

Then `chasm_wheel_turns_back` (`044:663-674`) calls `start_loop` (`039_Chapter13.rb:557-579`). That clears every story flag and sends you back to the Prologue or Targos.

**Judgement.** Using the Still Keeper's loop fits the campaign's "time is a wheel" theme, and the previous audit suggested it. But one wrong pick among four options in the lunge prompt now wipes a whole act with no warning, and the module never punishes that way. *Fix:* keep the loop for "...Do it.", but on the lunge failure offer "go round again from the warm fissure". Or at least confirm before starting the loop.

**BUG: `start_loop` resets only part of Act I.**
- It clears self switches only for maps 2001-2099 (`039_Chapter13.rb:570`). Every Act I side-quest map (2100 and 2120-2137) keeps its self switches. Examples: Duhg stays gone (`2133 E27`), the toppled statues stay toppled, and the mountain goats stay beaten.
- It also leaves these story counters in `state`: `:gm_election_day`, `:baskets`, `:treasure_basket`, `:mirror_asked`, `:mirror_topics`, `:statues_down`, `:track_sets`, `:forest_hours`, `:chwinga_charges`, `:throne_day` and `:scramsax_tab`.
- **Concrete failure:**
  1. Ask Olivessa in loop 1, which starts the election clock.
  2. Take the dark path.
  3. In loop 2, the first rest at Three Flags (`007_Story.rb:282`) calls `long_rest_taken`, which calls `election_day_passes` (`045_MeadMustFlow.rb:722-748`).
  4. That prints "eight thugs stormed the mead hall" and "A rider from Good Mead... The town has voted", and sets Good Mead's speaker, before you have even left Targos.
- *Fix:* in `start_loop`, clear self switches for every story map (`m >= 2001`). Delete the Act I quest keys listed above, and reset `$game_variables` too if any are used.

### 3. BUG: The canonical "third way" assumes a golden acorn you may never have picked up

- **Where the acorn comes from:** Mishann gives it only if you talk to her after winning Duvessa's seal (`014_Chapter2.rb:316-328`). Nothing forces that visit. Duvessa's goal text only hints at it (`014_Chapter2.rb:688`).
- **Where it is assumed:** the third way always says "Alberica takes the golden acorn from Reptin's pack" and presses it into the root (`023_Chapter5.rb:970-979`). If you skipped Mishann, the act's ending rests on an item you were never given.
- *Fix:* give the acorn unconditionally when the seal is won, or make Mishann's scene an autorun on the way out of the north gate.

### 4. BUG: The Council of Speakers can meet after Kendrick is dead (T4)

- **The gate is too loose:** `council_enter` checks only `lottery_stand && !council_session` (`045_TenTowns.rb:368-371`).
- **What the scene assumes:** it opens with "Last night Bryn Shander drew a name" and seats a living Kendrick Rielsbarrow with his mead. He invites you to Good Mead (`045_TenTowns.rb:386-415`).
- **When it can actually play:** whenever you first walk into the Council Hall. That can be after Chapter 4, when Kendrick lies dead in the shrine (`022_Chapter4.rb:165-169`). It can also be after Oarus has died in the mine.
- *Fix:* gate the session on `!flag?(:rested_lonelywood)` (it is meant to happen the day after the draw). Otherwise, play a later version without Kendrick and with "the night of the draw".

### 5. BUG: Oarus keeps talking after the grell kills him (BM16)

- **What should happen:** if the grell survives, `mine_report` says Oarus "doesn't come out... Termalaine has no speaker". It sets `:oarus_dead` and switch 4066 (`045_Termalaine.rb:534-541`).
- **What happens instead:** no map page reads switch 4066. Oarus (`2120 E24`, one page) still stands outside the Blue Clam and says "The mine's open, the miners are back..." (`045_Termalaine.rb:142-143`). Shaelen's line doesn't change either.
- *Fix:* add a `{ switch: 4066, graphic: "", through: true }` page to Oarus in `tools/build_tentowns.rb`. Give Shaelen a grief variant.

### 6. Sephek's victims: three accounts that don't agree (K15, Changed, neither)

The book's account (Hlin, R 1164-1170, 1266-1271) is that he kills people who bribed their names out of the lottery. The game tells it three ways:
- Hlin and Sephek give the book's version (`044_ChasmFaithful.rb:942-945, 977-979`).
- Naerth says he finds "people who run before the draw" (`007_Story.rb:306-307`).
- The Targos lantern mother says "Auril's chosen came for her himself" about her sister, who was drawn (`006_Dialogue.rb:102-103`).

*Fix:* change Naerth's line to cheats who "pay to keep their names off the board". Make the lantern sister someone who bought her way out.

### 7. The yeti cub is never at risk during the fight (C77 and C79, Compressed)

**Source:**
- the cub can be hit by stray attacks and freed mid-fight (CC 1030-1034, 1071-1077)
- at low HP the hag lunges for its throat (CC 1046-1050, 1086-1092)

**Game:**
- the cub only "cries louder" during the lair-action rounds (`044_ChasmFaithful.rb:484`)
- freeing the chains and the lunge both happen in a four-way prompt after her battle (`044:544-590`), not at low HP mid-fight

*Fix (optional):* in `thredra_round`, trigger `hag_lunge` when her last Pokémon drops below 25% HP, by ending the battle early with a scripted interrupt.

### 8. BUG: Mountain Climb can be done before Keegan asks (TG14)

- **The missing gate:** switch 4044 (`SW_MC_TAKEN`) is never read by a map page. Garret (`2126 E38`), Perilou and Astrix are on the mountain from the moment the tundra opens. Foaming Mugs sends you to that same tundra.
- **The contradiction:** if you send Garret home first (`045_MountainClimb.rb:333-335`), he appears in the Velryn house (`2124 E5`, switch 4054). Meanwhile Keegan, at the door, still asks you to go and find him (`045_MountainClimb.rb:168-205`).
- *Fix:* give Garret's p0 a switch 4044 condition, or teach `keegan()` about `:garret_found`.

### 9. BUG: Hlin hires you after you have already frozen Sephek (K12)

- **What happens:** if you first meet Hlin after the Moon Temple, `hlin()` (`044_ChasmFaithful.rb:909-956`) gives the full hiring speech. That includes "Torg's is camped here... Sephek's the one in his shirtsleeves", though he left on Shimmer's night (`2021 E27` p1, switch 3916). You have to talk to her again to be paid.
- *Fix:* when `sephek_defeated && !hlin_hired`, run a short "I heard what happened at the temple" intro, then pay at once.

### 10. Dougan's Hole flavour and the blizzard crossing (DH1 and DH10, Compressed)

**DH1, what's lost (R 3069-3085, 3183-3195):**
- The book's townsfolk are introduced by their misshapen ears and pointed teeth. The chorus NPCs are named for them (`dh_chorus_ears/teeth`), but their lines never say so (`022_Chapter4.rb:202-208`).
- The buckled pier and the two icebound keelboats are absent.

**DH10, what's lost (R 3198-3211):**
- The 50% blizzard is only map weather.
- Koran and Kanan don't shield the party from it when they travel with you.

*Fix:*
- Add "says a local with small, misshapen ears" style lead-ins to the chorus.
- Add a pier sign.
- Add a one-line shelter beat in `scene_tundra_start` when `:followed_koran` is set.

### 11. Torrga's crew and her grudge (K6 Compressed, K13 Missing)

- **K6 (R 1277-1279):** she has four bandit drivers. The game has one named hand (Brannig) and one idle hand (`044_ChasmFaithful.rb:76-78`; `2021 E30`).
- **K13 (R 1303-1315):** if Torrga survives, the book has her freeze the party out of Ten-Towns shops. That is absent.
- *Fix:* add two more hands to her battle. Set a `:torrga_grudge` flag if you defeat Sephek but leave Torrga alone, and use it for a "not serving you" line at one or two marts.

### 12. BUG: Fef's fox never leaves (MM2)

- **The dead page:** the fox event (`2031 E22`) has a hide page that waits on self switch A, which nothing sets (`tools/build_tentowns.rb:1036-1038`). The fox stands at Fef's feet after you buy it.
- **The re-sale:** after it rides off with the chwinga, `SW_GM_FOX_BOUGHT` is set back to off (`045_MeadMustFlow.rb:234`), so Fef offers to sell it again (`:183-190`).
- *Fix:* condition the hide page on switch 4076 or on `:fox_with_chwinga`, and keep a separate "fox gone" flag.

### 13. BUG: Meat Meat's pronoun (owner decision: she/her)

- `045_WhiteMoose.rb:398` says: "(drawing himself up to his full height, and roaring) MEAT MEAT IS NOT FOOD."
- *Fix:* change it to "herself" and "her".

### 14. Routes the book has but the game closes (TG7, TM6, EH1, Changed, neither)

- **Targos to Termalaine:** the path round the east of Maer Dualdon (R 4962-4965, 5314-5326) is "buried in drifts" (`006_Dialogue.rb:48`). Termalaine has no exit to Targos (map 2120).
- **Easthaven:** the Eastway leads there (R 3438-3444), but a slide closes the road (`022_Chapter4.rb:143-146`).

Both are harmless for a Pokémon route. Easthaven's own quests stay out (EH2).

### 15. Small Compressed or Missing flavour

| Row | What's lost (source) | Fix |
|---|---|---|
| LW4 | Iriskree is a bare mart (`2028 E4`). Her past is hinted only by a customer (`015_Chapter3.rb:191`) (R 4499-4502). | Give her one talk line that speaks fondly of the dead. |
| LW2 | Lonelywood's Sembian founders and chimera carvings (R 4462-4468) are missing. | Add a town sign line. |
| GM1 | Good Mead's dinosaur carvings are missing (R 4073-4074, 934). | Add one word to `scene_good_mead_arrival`. |
| FM8 | Izobai's two potions of animal friendship are missing (R 1948-1949). | Add them to the drop at `045_FoamingMugs.rb:174-181`. |
| BM15 | Interrogating a captured kobold (R 5411-5422) is reduced to the saboteurs' "Trex say". | Add a "question the kobold" option in `mine_grek`. |
| TG10 | The Caer-Konig / Frozenfar route (R 5057-5082) is mentioned only (`045_MountainClimb.rb:200`). | Fine as is: Caer-Konig isn't in the game. |
| TG19 | The father yeti is calmed by a Yetot in your party instead of the Littlest Yeti secret or trading the tyke (R 5233-5240) (`045_MountainClimb.rb:460-466`). | A sensible adaptation. You can't take the tyke, so no fix is needed. |

The two Missing rows that are optional in the book:
- **T7 "Nature Spirits"** (R 1316-1335): the alternative starting quest. The book uses only one starting quest, and the game uses "Cold-Hearted Killer".
- **EH2 Easthaven's quests:** the town isn't visited.

### 16. Minor bugs and polish

| Problem | Evidence | Fix |
|---|---|---|
| Chasm whisper 3 sits behind the arrival point, so it fires only when you walk back out. | Row y=30 (`tools/build_ch5.rb:180`). You arrive at y=28 from Map 2042, and the exit is at y=32. | Move it to y=26. |
| The cancel key picks the wrong option in two chasm menus. In Essentials, `cmdIfCancel > 0` returns `cmdIfCancel - 1`, which is the last clue or question, not "Choose a way" or "Tell us how to stop her". | `023_Chapter5.rb:434, 783` | Pass `opts.size`. |
| Cancelling the Guardian's Gate life menu (-1) counts as an "insulting" wrong offering and summons the guardians. | `023_Chapter5.rb:603, 628` | Return early on cancel. |
| Refusing Hruna says "you don't see them again for days", but switch 4049 hides the dwarves for good. Faithful to R 1902-1905 in effect, but the text promises a return. | `045_FoamingMugs.rb:101-103` | Fix the text, or bring them back. |
| After "Stand firm" in `bad_wolf` (both wolves revealed and bolting), `koran()` still narrates "something else white trots after him, just out of sight". | `045_HoledUp.rb:102-109` | Skip that line when `:refused_wolves` is set. |
| Reused names. "Pell" is a Bryn Shander militia trainer (`045_TenTowns.rb:239`) and a Lonelywood bug catcher (`015_Chapter3.rb:67`), and it is also the Rootwarden who stands in for the notes' junior warden in the Mirror Maze (integration choice). "Rhosk" is used twice (`045_TenTowns.rb:240`; `023_Chapter5.rb:70`). | as cited | Rename the two Act I trainers. |
| Dead code: `scene_verbeeg_lair_outside` (`045_MeadMustFlow.rb:246`) and the text keys `gm_thug_after` and `elza_after_mugs` are never reached. The thug locked in the cooperage and Elza after the quest have no lines. | as cited | Wire them up or delete them. |

### Deliberate changes I accept (no fix needed)

These are the campaign's own rewrites, owner decisions, or Pokémon-structure integrations, and none of them betrays the source:
- C1 (the hag's freeze becomes the Twenty Stones night)
- C4 and C54 (the Heart is a World-Tree root; the hag would "drain the root")
- C17 and C51 (Alberica's face; the ghost is her future self)
- C22 (the mother yeti can live: owner decision)
- C29 (the child's voice says "Shimmer")
- C81 (the mirrors shatter; Verdant Reversal)
- C83 (Reptin can't stay as warden because he has to fall through time; he vows to return, `044:736-742`)
- K1 (Hlin sits in the Lucky Liar, where Torg's is)
- K11 and K14 (Sephek is frozen, not killed; his Shimmer story)
- TG2, BS2 and DH3 (the speakers as Gyms 1-3)
- BS10 (lottery night)
- DH2 (the shapes on the ice are the hag's victims)
- DH11 (the bite; but see bug 1)
- DH21 (both wolves flee to the chasm, and Kanan becomes the hag's winter wolf, as CC 975-976 suggests)

---

## 3. Full table

Status: **Full**, **Compressed** (what's lost), **Changed** (how; *deliberate* means the campaign's or owner's own, *integration* means a build choice, *neither* means it is neither), **Missing**, **Missing (optional in book)**, or **Unreachable**.

### 3a. The Cackling Chasm

| # | Element | CC lines | Status | Where in game | Notes |
|---|---|---|---|---|---|
| C1 | Backstory: the hag froze Dougan's Hole; the heroes foiled her | 9-12 | Changed (deliberate) | `022_Chapter4.rb:520-629`; Map 2035 E29-E33 | Played live at the Twenty Stones. |
| C2 | The hag's bargain: end the winter, cure Reptin, for a task | 13-18, 31-34, 49-52 | Full | `044_ChasmFaithful.rb:802-825`, called at `022_Chapter4.rb:556` | Unmissable: it runs in the first `hag()` talk. |
| C3 | Order of Life and Death; werewolf wardens; Reptin bound by blood | 20-25 | Full | `023_Chapter5.rb:711-716` | "Found the warden already in your blood." |
| C4 | Heart: absorbs life; hidden truths (only temporary, empowers her, curing Reptin removes a warden) | 26-43 | Changed (deliberate) | `023_Chapter5.rb:704-705, 718-729` | The Heart is a World-Tree root. All three truths are told. |
| C5 | Hook: messenger or dream invites them to parley | 49-52 | Full | `022_Chapter4.rb:539-560`; `023_Chapter5.rb:209-218` | |
| C6 | Hook: hunters' rumours of cackling south of the Hole | 53-56 | Full | `006_Dialogue.rb:33-34`; `023_Chapter5.rb:86-91`; Map 2035 E21-E22 | |
| C7 | Hook: Reptin's vision ("Abandon your bond...") | 57-61 | Full | `023_Chapter5.rb:186-218` | |
| C8 | General features: dark, cold, slick ice, echoes, smells, whispered names | 69-101 | Full | `044_ChasmFaithful.rb:154-176`; 4 whisper rows | Exhaustion is a GM mechanic, skipped. Whisper 3 is misplaced (minor bug). |
| C9 | Escalating horror toward a terrible moral choice | 102-108 | Full | `023_Chapter5.rb:930-942` | The "...Do it." choice is real. |
| C10 | Reptin's role: anxious; amber eyes at the blood; "We won't let her..." | 115-122, 393-397 | Full | `044_ChasmFaithful.rb:197-208`; `023_Chapter5.rb:310-315` | |
| C11 | "Take me instead!"; her scornful refusal | 125-128, 996-998 | Full | `023_Chapter5.rb:944-947` | Verbatim. |
| C12 | The hag uses Reptin (holds or paralyses him) | 123-125, 981-987 | Full | `023_Chapter5.rb:911-919, 958` | Frost holds him to the knees. |
| C13 | Area 1: illusory greeting, "I smell the wolf..." | 142-169 | Full | `023_Chapter5.rb:231-255` | |
| C14 | Area 1: detecting the illusion | 170-179 | Full | `023_Chapter5.rb:244-251` | "Watch her closely" option. |
| C15 | Area 1: icefall; "Oops! Mind your heads" | 180-200 | Full | `023_Chapter5.rb:258-267`; Map 2042 E7-E10 | |
| C16 | Area 1: ice mephits; their death burst | 201-226 | Full | `023_Chapter5.rb:268-273` | |
| C17 | Area 1: locket, half sun / half moon, "Alberica" | 227-237 | Changed (deliberate) | `023_Chapter5.rb:277-292` | The face is Alberica's own, older. |
| C18 | Area 1: gnoll femur in the fallen ice | 244-249 | Full | `044_ChasmFaithful.rb:97-99, 178-184`; Map 2042 E15 | |
| C19 | Area 2: carnage (goats, foxes, human arm, trapper, dwarf) | 252-276 | Full | `044_ChasmFaithful.rb:189-196` | |
| C20 | Area 2: dead male yeti, heart cut out | 276-282 | Full | `023_Chapter5.rb:294-303` | |
| C21 | Area 2: blood runes, Yeenoghu over the druidic emblem | 283-290 | Full | `044_ChasmFaithful.rb:100-105, 212-218`; Map 2042 E21 | |
| C22 | Area 2: grieving mother yeti who fights to the death | 291-345 | Changed (owner decision) | `023_Chapter5.rb:324-381` | Sing, back away, or fight. If you fight, she dies curled over her mate, as in the book. |
| C23 | Area 2: humanoid tracks and drag marks | 346-351 | Full | `023_Chapter5.rb:304-309` | |
| C24 | Area 2: swaddling in the father's fist | 352-357 | Full | `023_Chapter5.rb:301-309` | |
| C25 | Area 2: backpack, potion, "Glimmer's" journal | 365-381 | Full | `023_Chapter5.rb:392-408`; `044_ChasmFaithful.rb:830-841` | Signed Glimmer; names Alberica. Readable key item. |
| C26 | Area 2: coins, gnoll greataxe, necklace of ears | 367-370 | Full | `044_ChasmFaithful.rb:220-234` | |
| C27 | Area 2: "Ohhh, such violence... time is ticking" | 389-392 | Full | `044_ChasmFaithful.rb:237-244` | |
| C28 | Area 3: glassy corridor; a reflection that lingers and grins | 400-424 | Full | `023_Chapter5.rb:414-416` | |
| C29 | Area 3, left: false light; child says "Glimmer" | 425-434 | Changed (deliberate) | `023_Chapter5.rb:418-424, 451-454` | The voice says "Shimmer". |
| C30 | Area 3, right: weeping old woman, also an illusion | 434-442 | Full | `023_Chapter5.rb:446-449, 518-520` | "Both ways are tricks." |
| C31 | Area 3: clues (breeze, reflections, loop, insight) | 440-460 | Full | `023_Chapter5.rb:429-457` | Cancel key picks the wrong option (minor bug). |
| C32 | Area 3: pit trap, two ghouls, rope out | 469-513 | Full | `023_Chapter5.rb:459-506`; Map 2043 | |
| C33 | Area 3: pit treasure | 514-519 | Full | `023_Chapter5.rb:487-497` | |
| C34 | Area 3: "SHE LIES / DON'T TRUST THE LIGHT" | 519-523 | Full | Map 2043 E2 | |
| C35 | Area 3: "Poor little lambs... did you stumble?" | 526-529 | Full | `023_Chapter5.rb:480-481` | |
| C36 | Area 3: guilt on the right path ("Don't leave me!", a girl's reflection) | 465-466, 538-542 | Full | `023_Chapter5.rb:512-516`; `044_ChasmFaithful.rb:374-378` | |
| C37 | Area 4: rift, five-foot bridge, frayed rope, chanting | 564-584 | Full | `023_Chapter5.rb:536-547` | |
| C38 | Area 4: ice chunk cracks the bridge | 580-583, 633-635 | Full | `023_Chapter5.rb:549-557` | |
| C39 | Area 4: crossing as a skill challenge; falls; rope plans | 606-623 | Full | `044_ChasmFaithful.rb:249-341`; Map 2100 | You can fall to the rift floor. |
| C40 | Area 4: wind gusts | 623-627 | Full | `023_Chapter5.rb:559-575` | |
| C41 | Area 4: personal voices on the wind | 635-638 | Full | `044_ChasmFaithful.rb:356-379` | |
| C42 | Area 4: ghostly woman on the far side points | 652-658 | Full | `023_Chapter5.rb:563-573` | |
| C43 | Area 4: optional threats (wisps, specter / gnoll ghost, coldlight walker, bats) | 639-675 | Full | `044_ChasmFaithful.rb:277-278, 343-353, 382-404`; Map 2044 E18; Map 2100 E2 | |
| C44 | Area 4: sheltered nook; uneasy rest | 687-690 | Full | `023_Chapter5.rb:577-592` | |
| C45 | Area 5: the gate (carvings, arch, whisper) | 693-722 | Full | `023_Chapter5.rb:594-600`; Map 2044 E23 | |
| C46 | Area 5: offering puzzle (blood; bone, ash or silence; stained bowls) | 723-752 | Full | `023_Chapter5.rb:601-626` | |
| C47 | Area 5: wrong offering brings skeletons, a necrotic burst, repeat waves | 753-775 | Full | `023_Chapter5.rb:626-644` | Cancel counts as an insult (minor bug). |
| C48 | Area 5: vision of the rite with werewolves | 776-783 | Full | `023_Chapter5.rb:617-620` | |
| C49 | Area 5: hidden seam (optional sanctum) | 784-793 | Full | `023_Chapter5.rb:647-654`; Map 2044 E24 | |
| C50 | Area 6: bier, preserved corpse, vigil, the corpse rises | 795-819 | Full | `023_Chapter5.rb:665-672` | |
| C51 | Area 6: "I am Alberica, last guardian" | 815-824 | Changed (deliberate) | `023_Chapter5.rb:679-683` | She has Alberica's face. "I borrowed it." |
| C52 | Area 6: the Order's history; Yeenoghu's gnolls; sealed from inside | 825-839 | Full | `023_Chapter5.rb:702-710` | |
| C53 | Area 6: Children of the Wolf; "a sacred charge" | 828-834 | Full | `023_Chapter5.rb:711-716` | |
| C54 | Area 6: the hag's scheme | 839-844 | Changed (deliberate) | `023_Chapter5.rb:718-723` | "Drain the root." Same structure. |
| C55 | Area 6: the innocent is a yeti child; soul-debt | 844-850 | Full | `023_Chapter5.rb:724, 788-790` | Soul-debt comes with the "end the winter?" question. |
| C56 | Area 6: the cure means cutting the bond; Reptin's choice | 850-856 | Full | `023_Chapter5.rb:726-737, 792-795` | |
| C57 | Area 6: an alternative (a life freely given) | 861-868 | Full | `023_Chapter5.rb:748-749` | "...or a life not yet begun" sets up the acorn (bug 3). |
| C58 | Area 6: boons (heal, locket talisman, sacred weapon) | 868-883 | Full | `023_Chapter5.rb:739-745, 768-769` | Silver dagger as a held item. |
| C59 | Area 6: motherly words to Reptin | 884-887 | Full | `023_Chapter5.rb:735-737` | |
| C60 | Area 6: "Confront the witch... I cannot leave this crypt" | 888-889 | Full | `023_Chapter5.rb:754-756` | |
| C61 | Area 6: the prophecy | 892-896 | Full | `023_Chapter5.rb:757-758` | Verbatim. |
| C62 | Area 6: fades; body to dust; lichen dims | 896-899 | Full | `023_Chapter5.rb:763-765` | |
| C63 | Tips: break her staff; "Only flame can quell the ice-eater" | 909, 1066-1068 | Full | `023_Chapter5.rb:746-747`; `044_ChasmFaithful.rb:459, 561` | |
| C64 | Area 7: the Heart (spires, blood-red orb, heartbeat) | 912-920 | Full | `023_Chapter5.rb:806-813` | |
| C65 | Area 7: cub chained, gagged | 921-924 | Full | `023_Chapter5.rb:811`; Map 2046 E10 | |
| C66 | Area 7: the hag in full (bruise skin, baby-teeth necklace, sprite-hung staff) | 925-931 | Full | `023_Chapter5.rb:894-898` | |
| C67 | Area 7: iron cauldron of ritual brew | 932-934 | Full | `023_Chapter5.rb:812`; `044_ChasmFaithful.rb:118-121`; Map 2046 E8 | |
| C68 | Area 7: winter wolf (a Dougan's Hole wolf) and ice troll | 935-938, 974-979 | Full | `023_Chapter5.rb:899-900, 823-842` | Kanan. |
| C69 | Area 7: greeting, ultimatum, "honour our deal?" | 939-959 | Full | `023_Chapter5.rb:901-926` | |
| C70 | Area 7: the curse half pulled out | 943-946 | Full | `023_Chapter5.rb:911-919` | |
| C71 | Area 7: the choice (refuse, offer yourself, agree) | 988-1007 | Full | `023_Chapter5.rb:930-942` | Agreeing asks you to confirm. |
| C72 | "The new Winter"; "one little monster"; "Then be damned"; a spiteful lunge | 1000-1007 | Full | `023_Chapter5.rb:909, 952-957` | |
| C73 | The hag's tactics: flight on the staff, illusions | 1010-1022 | Full | `044_ChasmFaithful.rb:465-516` | Evasion, decoys, confusion. |
| C74 | Coven option (a second hag) | 968-973, 1052-1056 | Full | `044_ChasmFaithful.rb:518-530` | Hard difficulty only. |
| C75 | Minions: "Warm blood!"; troll regenerates unless burned | 1023-1028, 1062-1068 | Full | `044_ChasmFaithful.rb:447-463` | |
| C76 | The Heart's lair actions (necrotic wave, visions, life pulse) | 1035-1046 | Full | `044_ChasmFaithful.rb:476-504` | |
| C77 | The cub in danger during the fight; freeing its chains | 1030-1034, 1071-1077 | Compressed | `044_ChasmFaithful.rb:484, 567-570` | It only cries during the battle. Freeing comes after (gap 7). |
| C78 | Mid-fight "Still time to reconsider!" | 1078-1080 | Full | `044_ChasmFaithful.rb:505-508` | |
| C79 | At low HP she lunges for the cub | 1046-1050, 1086-1092 | Compressed | `044_ChasmFaithful.rb:544-590` | It comes after her battle, as a four-way prompt (gap 7). |
| C80 | The ghost intervenes once | 1057-1060 | Full | `023_Chapter5.rb:866-878`; `044_ChasmFaithful.rb:576-580` | |
| C81 | The hag dies; the Heart goes dormant | 1099-1106 | Changed (deliberate) | `023_Chapter5.rb:854-861, 963-1044` | The mirrors break; Verdant Reversal. |
| C82 | Aftermath: cub's home; Reptin's wolf calmed; leave the Heart, don't break it | 1111-1133, 1176-1197 | Full | `044_ChasmFaithful.rb:689-743` | |
| C83 | Reptin stays behind as guardian | 1119-1124, 1190-1194 | Changed (integration) | `044_ChasmFaithful.rb:736-742` | He vows to return. |
| C84 | Dark ending: the cub dies, the winter breaks, Reptin is cured | 1147-1152, 1198-1215 | Changed (integration) | `044_ChasmFaithful.rb:594-648, 663-674`; `039_Chapter13.rb:557` | Played in full, then the loop restarts the story (gap 2; loop bug). |
| C85 | Failure: the witch-queen ending | 1219-1229 | Full | `044_ChasmFaithful.rb:651-660, 677-684` | Reached by losing to the Winter-Crowned hag. Other losses give a nightmare. |
| C86 | Treasure (staff, opals, scroll, cold potion, ring, pelt, Order chest, Codex, Heart shard, locket as Bless) | 1133-1145, 1236-1257 | Full | `044_ChasmFaithful.rb:746-774, 409-422, 866-896` | |
| C87 | Legacy and epilogue (wildflower, watchful wolves, the Speaker's thanks, "Glimmer in the Chasm", owl feather, the dream, wolf-and-bloom token, legend) | 1258-1323 | Full | `044_ChasmFaithful.rb:777-799` | Told inside the fall through time. |
| C88 | The journal's hidden line, "Balance must be kept" | 1163-1165 | Full | `044_ChasmFaithful.rb:837-840` | |
| C89 | The Order rekindled; the party as wardens | 1276-1279 | Full | `023_Chapter5.rb:750, 753` | |

### 3b. Rime of the Frostmaiden

**Ten-Towns in general**

| # | Element | R lines | Status | Where in game | Notes |
|---|---|---|---|---|---|
| T1 | Ten-Towns Rumors table, told in taverns | 861-921 | Full | `045_TenTowns.rb:49-70, 148-154`; Maps 2002 E14, 2016 E9, 2024 E12, 2120 E28, 2122 E8 | Done quests drop off the table. |
| T2 | Human lottery only in Bryn Shander, Easthaven and Targos | 1040-1049 | Full | `006_Dialogue.rb:28-30`; `007_Story.rb:306` | Fixed since the last audit. |
| T3 | Food (Lonelywood) and warmth (Good Mead, Dougan's Hole, Termalaine) | 1050-1059 | Full | `045_TenTowns.rb:110-122`; Maps 2021 E31, 2031 E25, 2035 E48; `045_TenTowns.rb:401` | |
| T4 | Council of Speakers in the Council Hall; "necessary evils" | 1028-1035, 1055-1058 | Full | `045_TenTowns.rb:96-108, 368-419`; Map 2134 | Bug 4: timing. |
| T5 | Cold open: no sun above the mountains for two years | 1076-1090 | Full | `006_Dialogue.rb:24-25` | Fixed. |
| T7 | "Nature Spirits" (Dannika), the alternative starting quest | 1316-1335 | Missing (optional in book) | none | The book uses one starting quest. |

**Cold-Hearted Killer**

| # | Element | R lines | Status | Where in game | Notes |
|---|---|---|---|---|---|
| K1 | Hlin Trollbane, a scarred dwarf with a pipe, hires the party for 100 gp | 1090-1207 | Changed (integration) | `044_ChasmFaithful.rb:909-956`; Map 2024 E11 | She sits in the Lucky Liar, near Torg's. |
| K2 | Three ice-dagger murders | 1118-1124 | Full | `044_ChasmFaithful.rb:937-938` | |
| K3 | Victims from the lottery towns; cheating theory | 1164-1170 | Full | `044_ChasmFaithful.rb:942-945` | Ties in Kip's list. |
| K4 | Sephek's look: vest, no coat, frozen-lake eyes | 1215-1232 | Full | `044_ChasmFaithful.rb:963-966`; `014_Chapter2.rb:625-626` | |
| K5 | Torg's: three sleds, gold paw flag, goods at double price | 1250-1263 | Full | `044_ChasmFaithful.rb:125-131, 1011-1013, 1040-1054`; Map 2021 E25-E29 | |
| K6 | Torrga Icevein, four bandit hands, strongbox | 1273-1289 | Compressed | `044_ChasmFaithful.rb:1005-1036`; Map 2021 E26, E30 | One named hand instead of four (gap 11). |
| K7 | Bounty corpse in a sack | 1266-1272 | Full | `044_ChasmFaithful.rb:992-1003` | |
| K8 | "Born on Midwinter"; doesn't hide his guilt | 1254-1257, 1271-1274 | Full | `044_ChasmFaithful.rb:974-980` | |
| K9 | Isolate him from Torrga | 1233-1249 | Full | `044_ChasmFaithful.rb:984-989` | He won't fight at the camp. |
| K10 | True nature: drowned mariner, frost druid's spirit | 1257-1265 | Full | `044_ChasmFaithful.rb:1057-1067`, from `015_Chapter3.rb:538` | |
| K11 | Cold Regeneration; dies only at 0 HP | 1185-1196 | Changed (deliberate) | `015_Chapter3.rb:539-543` | Frozen in ice; returns in Act III. |
| K12 | Return to Hlin; paid; takes your word | 1280-1289 | Full | `044_ChasmFaithful.rb:913-927` | Bug 9. |
| K13 | Torrga's grudge if she survives | 1303-1315 | Missing | none | Gap 11. |
| K14 | Sephek as Auril's agent for Shimmer (campaign) | (campaign) | Changed (deliberate) | `014_Chapter2.rb:625-640`; `015_Chapter3.rb:349-410` | |
| K15 | Who his victims are | 1164-1170 | Changed (neither) | `007_Story.rb:306-307`; `006_Dialogue.rb:102-103` | Contradicts Hlin (gap 6). |

**Targos and Mountain Climb**

| # | Element | R lines | Status | Where in game | Notes |
|---|---|---|---|---|---|
| TG1 | Walled harbour, ice-locked boats, biggest fleet | 4910-4925 | Full | `tools/build_act1.rb`; `006_Dialogue.rb:31-32` | |
| TG2 | Naerth: Luskan rogue, Zhentarim, bought his way in, spies | 4926-4940 | Changed (integration) | `007_Story.rb:298-380`; `045_TenTowns.rb:79-82` | Gym 1. |
| TG3 | Skath | 4951-4953 | Full | `006_Dialogue.rb:116-117` | |
| TG4 | Luskan Arms: rot, rats, Owenn's despair, Naerth's suite and flying snakes | 4947-4971 | Full | `045_TenTowns.rb:74-82, 161-178`; Map 2004 E7-E10 | |
| TG5 | Three Flags Sailing: Ma Yarbroul; rumours | 4975-4997 | Full | `006_Dialogue.rb:57-65`; Map 2002 E7, E14 | |
| TG6 | Triglio: chantey; Jestin's crushed hand; no fishing gear | 4999-5021 | Full | `045_TenTowns.rb:84-85, 181-191` | |
| TG7 | Overland: Bryn Shander 2 h south-east; path to Termalaine | 4962-4970 | Changed (neither) | `014_Chapter2.rb:107-108`; `006_Dialogue.rb:48` | The Termalaine road is closed (gap 14). |
| TG8 | Boy the sled dog leads you home | 4977-5024 | Full | `045_MountainClimb.rb:148-162`; Map 2001 E10 | |
| TG9 | Keegan: cider, story, the ask, rewards, Frozenfar, take Boy | 5027-5090 | Full | `045_MountainClimb.rb:168-206` | |
| TG10 | Journey via Caer-Konig, or across the tundra and Dwarven Valley | 5050-5112 | Compressed | `045_MountainClimb.rb:211-224`; Map 2125 | The Caer-Konig route is only mentioned. |
| TG11 | Base camp: tents, five dogs, crates | 5099-5119 | Full | `045_MountainClimb.rb:238-256` | |
| TG12 | Mountain goats | 5131-5144 | Full | `045_MountainClimb.rb:258-270` | |
| TG13 | Avalanche | 5146-5170 | Full | `045_MountainClimb.rb:273-291` | |
| TG14 | Garret face down; Boy; crag cats; the missing three; persuade him home | 5172-5190, 5131-5157 | Full | `045_MountainClimb.rb:294-346` | Bug 8: not gated on Keegan's quest. |
| TG15 | Perilous climb: three group checks | 5158-5165 | Full | `045_MountainClimb.rb:350-378` | |
| TG16 | F1: chasm, bridge, ice sheet | 5167-5212 | Full | `045_MountainClimb.rb:383-402` | |
| TG17 | F2: trophies (Mokingo; Oobok's and Barthoom's heads) | 5213-5225 | Full | `045_MountainClimb.rb:405-416` | Oobok can be taken home to Hruna. |
| TG18 | F3: yeti den (Perilou batted about; peaceful option) | 5200-5229 | Full | `045_MountainClimb.rb:419-451` | |
| TG19 | Father yeti returns with a goat | 5233-5240 | Changed (neither) | `045_MountainClimb.rb:454-474` | Calmed by your Yetot (gap 15). |
| TG20 | Ruined camp: Astrix, blue boots, Barthoom, spellbook, invisibility potion | 5241-5264 | Full | `045_MountainClimb.rb:479-510` | |
| TG21 | Reunion; scrimshaw box ("BIG LOVE"); free rooms; Perilou retires | 5249-5262 | Full | `045_MountainClimb.rb:516-548`; `045_TenTowns.rb:161-170` | |

**Bryn Shander and Foaming Mugs**

| # | Element | R lines | Status | Where in game | Notes |
|---|---|---|---|---|---|
| BS1 | Walls, lanterns, gates shut in the dark | 1726-1746 | Full | `014_Chapter2.rb:116, 155-156`; `045_TenTowns.rb:87-90` | |
| BS2 | Duvessa Shane: honest, young, head of the Council | 1752-1756 | Changed (integration) | `014_Chapter2.rb:659-692, 200-208` | Gym 2. The Zhentarim-debtor rewrite is gone. |
| BS3 | Sheriff Southwell and the militia | 1756-1760 | Full | `045_TenTowns.rb:196-207`; Map 2012 E34-E35 | |
| BS4 | Heraldry | 1761-1763 | Full | Map 2012 E36 | |
| BS5 | Blackiron Blades: Garn, Elza, the joke | 1754-1768 | Full | `045_TenTowns.rb:211-247`; Map 2014 | |
| BS6 | House of the Morninglord: Mishann; Amaunator versus Lathander | 1770-1786 | Full | `014_Chapter2.rb:314-336`; `045_TenTowns.rb:255-260` | The acorn is a campaign addition (bug 3). |
| BS7 | Copper Knobberknocker; Macreadus and the Black Cabin hook | 1787-1805 | Full | `045_TenTowns.rb:251-277`; Map 2019 E5 | A hook only. The Black Cabin is in RotF chapter 2. |
| BS8 | Northlook: Scramsax, credit with interest, leads | 1807-1828 | Full | `045_TenTowns.rb:281-337` | |
| BS9 | Ol' Bitey snaps and sings | 1794-1813 | Full | `045_TenTowns.rb:341-360` | |
| BS10 | Lottery at sundown before the new moon | 1040-1047 | Changed (deliberate) | `014_Chapter2.rb:510-651` | |
| BS11 | "Rigged lotteries are common" | 1048-1049 | Full | `017_TargosExtras.rb:228-235`; `014_Chapter2.rb:487-492` | |
| BS12 | Overland: Eastway to Easthaven; paths to Good Mead, Targos, Termalaine | 1769-1786 | Full | `014_Chapter2.rb:107, 161-163`; Map 2121 | |
| FM1 | Three frostbitten dwarves, described | 1836-1873 | Full | `045_FoamingMugs.rb:66-84`; Map 2012 E38-E40 | |
| FM2 | Hruna's ask; a gemstone each; dwarves' friendship; snowshoes | 1878-1901 | Full | `045_FoamingMugs.rb:76-100` | |
| FM3 | Refuse and they leave in a huff | 1902-1905 | Full | `045_FoamingMugs.rb:101-103` | Text mismatch (minor bug). |
| FM4 | Blizzard: wait, or press on and get lost | 1918-1932 | Full | `045_FoamingMugs.rb:112-127` | |
| FM5 | Oobok's remains; fresh goblin tracks heading south | 1871-1900 | Full | `045_FoamingMugs.rb:129-135` | |
| FM6 | Goblins, the 20-ft wagon, polar bears, Izobai with torch and hawk, archers inside | 1902-1940 | Full | `045_FoamingMugs.rb:137-182`; Map 2125 E4-E12 | |
| FM7 | Truce, kindness, or freeing the bears | 1937-1951 | Full | `045_FoamingMugs.rb:184-232` | |
| FM8 | Izobai fires the wagon and flees; her treasure | 1948-1961 | Compressed | `045_FoamingMugs.rb:174-181` | Her potions are missing. |
| FM9 | 300 stamped ingots; gems; 10% discount; dwarves' favour | 1953-1963, 5109-5112 | Full | `045_FoamingMugs.rb:247-264`; `045_TenTowns.rb:236-243`; `045_MountainClimb.rb:222` | |

**Termalaine and A Beautiful Mine**

| # | Element | R lines | Status | Where in game | Notes |
|---|---|---|---|---|---|
| TM1 | Most picturesque town; carvings; the north wind | 5268-5281 | Full | `045_Termalaine.rb:188-195` | |
| TM2 | Mine sealed when Underdark things come up | 5282-5290 | Full | `045_Termalaine.rb:211-238` | |
| TM3 | Oarus: half-orc, Shaelen's adopted son, close election, militia against him | 5296-5303 | Full | `045_Termalaine.rb:106-110, 211-238` | |
| TM4 | Blue Clam: Vernon, chowder, Lonelywood hunters, rumours | 5296-5313 | Full | Map 2122 E7-E9 | |
| TM5 | Eastside: Marta, Clyde, the song, the red-cloaked woman, ring of warmth | 5315-5394 | Full | `045_Termalaine.rb:240-286` | |
| TM6 | Overland: Lonelywood 2 h; Targos 4 h | 5313-5326 | Changed (neither) | Maps 2020, 2120, 2121 | No road to Targos (gap 14). |
| BM1 | Darmo Mazlu on his box | 5352-5368 | Full | `045_Termalaine.rb:197-209` | |
| BM2 | Oarus's offer; the missing miner; the militia's hidden refusal | 5414-5449 | Full | `045_Termalaine.rb:211-238`; `045_Termalaine.rb:109` | |
| BM3 | Approach; "Kobolds only!" in fine calligraphy | 5451-5469 | Full | `045_Termalaine.rb:120`; Map 2135 E2 | |
| BM4 | M1 tracks; M2 gems and the mining table | 5430-5480 | Full | `045_Termalaine.rb:290-319` | |
| BM5 | M3 giant rats and the river | 5482-5504 | Full | `045_Termalaine.rb:321-328` | |
| BM6 | M4 stone dog figurine | 5506-5524 | Full | `045_Termalaine.rb:330-337` | |
| BM7 | M5 saboteurs Scorp and Thwip | 5526-5558 | Full | `045_Termalaine.rb:339-361` | |
| BM8 | M6 and M7 bucket lift; tracks going east | 5536-5559 | Full | `045_Termalaine.rb:363-376` | |
| BM9 | M8 grell | 5561-5592 | Full | `045_Termalaine.rb:379-396` | |
| BM10 | M9 Grek and Smol | 5593-5608 | Full | `045_Termalaine.rb:398-409` | |
| BM11 | M10 bucket shuttle | 5610-5641 | Full | `045_Termalaine.rb:411-427` | |
| BM12 | M11 Trex, Vott and Zurk; Janth's ghost; the satchel | 5583-5655 | Full | `045_Termalaine.rb:431-500` | |
| BM13 | M12 mind flayer skull and psi crystal | 5657-5691 | Full | `045_Termalaine.rb:502-516` | |
| BM14 | M13 geodes | 5693-5707 | Full | `045_Termalaine.rb:290-298` | |
| BM15 | Questioning captured kobolds | 5411-5422 | Compressed | `045_Termalaine.rb:346-352` | Gap 15. |
| BM16 | Return to Oarus: inspection, the three outcomes, kobolds as workers | 5679-5708 | Full | `045_Termalaine.rb:518-586` | Bug 5: he talks after dying. |

**Lonelywood and The White Moose**

| # | Element | R lines | Status | Where in game | Notes |
|---|---|---|---|---|---|
| LW1 | Shady pasts; don't dredge them up | 4475-4485 | Full | `015_Chapter3.rb:307-309` | |
| LW2 | Sembian founders; chimera carvings | 4462-4468 | Missing | none | Gap 15. |
| LW3 | Nimsy: heated attic; cookies at Council meetings | 4492-4498, 4521-4525 | Full | `015_Chapter3.rb:302-322`; `045_TenTowns.rb:392` | |
| LW4 | Happy Scrimshander: Iriskree, retired assassin | 4493-4502 | Compressed | Map 2028 E4; `015_Chapter3.rb:191` | Gap 15. |
| LW5 | Lucky Liar: tall tales, rumours, Danae the Thayan spy | 4504-4525 | Full | `015_Chapter3.rb:185-190, 268`; Map 2024 E12 | |
| LW6 | Ramshackle: closed, DeGrootz "hanged himself", offered as an investment | 4575-4594 | Full | `015_Chapter3.rb:150-151`; `045_WhiteMoose.rb:234-255, 666` | |
| LW7 | Connects only to Termalaine | 4513-4518 | Full | Maps 2020, 2120, 2121 | Fixed. |
| WM1 | Nimsy's quest (Scoop, cookies, 100-125 gp, butcher, Ramshackle) | 4553-4594 | Full | `045_WhiteMoose.rb:153-195` | |
| WM2 | The moose is awakened by Ravisin and scries with the mirror | 4536-4551, 4598-4603 | Full | `045_WhiteMoose.rb:654-660` | |
| WM3 | Tracking: an hour, a d6, ordinary moose | 4596-4619 | Full | `045_WhiteMoose.rb:257-329` | Guaranteed find by the sixth set of tracks. |
| WM4 | Forest encounter table | 4617-4648 | Full | `045_WhiteMoose.rb:350-417` | Bug 13 (pronoun). |
| WM5 | Elven misdirection; topple all ten statues | 4650-4683 | Full | `045_WhiteMoose.rb:341-348, 451-468` | 7 statues outside, 3 under the hill. |
| WM6 | Watch: the moose stands in the dial | 4645-4652 | Full | `045_WhiteMoose.rb:584-592` | |
| WM7 | E2 barrow door opens only from inside | 4685-4710 | Full | `045_WhiteMoose.rb:616-623`; Map 2131 E2-E3 | |
| WM8 | E3 brazier: twig, pinecone, feather, hand | 4712-4729 | Full | `045_WhiteMoose.rb:470-494` | |
| WM9 | E4 sarcophagus; Sahnar, the pumpkin-spice mummy | 4733-4768 | Full | `045_WhiteMoose.rb:496-521` | |
| WM10 | E5 moon dial; inscriptions; moonbeam | 4750-4804 | Full | `045_WhiteMoose.rb:523-571` | |
| WM11 | E6 barrow, sleeping animals, the moose | 4806-4827 | Full | `045_WhiteMoose.rb:574-582` | |
| WM12 | E7 Mirror of the Full Moon: seven questions | 4829-4798 | Full | `045_WhiteMoose.rb:625-682` | |
| WM13 | E8 bow, arrowheads, winged-fish cup | 4786-4850 | Full | `045_WhiteMoose.rb:684-696` | |
| WM14 | E9 Ravisin, berry shrub, Vurnis, potions | 4852-4893 | Full | `045_WhiteMoose.rb:698-746` | |
| WM15 | Completion; if Ravisin lives, more awakened beasts | 4895-4905 | Full | `045_WhiteMoose.rb:197-232, 430-440` | |

**Good Mead, The Mead Must Flow and the speaker election**

| # | Element | R lines | Status | Where in game | Notes |
|---|---|---|---|---|---|
| GM1 | Chultan and Vilhon founders; dinosaur and serpent carvings; wyvern eaves; bees | 4071-4107 | Compressed | `022_Chapter4.rb:158-160, 405-406` | No dinosaurs. |
| GM2 | Verbeeg theft; Kendrick killed; five militia missing | 4080-4093 | Full | `022_Chapter4.rb:147-149, 165-166` | |
| GM3 | Shrine of the Flaming Sword; Kendrick's body; Redwaters feud | 4138-4155 | Full | `022_Chapter4.rb:167-169, 187` | |
| GM4 | Overland: to the Eastway; to Dougan's Hole | 4110-4130 | Full | Maps 2030, 2034 | |
| MM1 | The quest: lodging and drink for a tenday | 4181-4187 | Full | `045_MeadMustFlow.rb:158-170` | |
| MM2 | Fef Moryn and his trapped fox (1 gp or more) | 4190-4203, 4179-4183 | Full | `045_MeadMustFlow.rb:172-191` | Bug 12 (the fox). |
| MM3 | Carnage in the woods; the ogre's tracks | 4185-4209 | Full | `045_MeadMustFlow.rb:196-215`; Map 2132 | |
| MM4 | Fox, chwinga, snowball, charm | 4211-4235 | Full | `045_MeadMustFlow.rb:217-243` | |
| MM5 | V1 three caves; V2 mammoth bones | 4220-4264 | Full | `045_MeadMustFlow.rb:252-259`; Map 2132 E5 | |
| MM6 | V3 bonfire, Artin on the spit, named livestock, crates; intimidation | 4266-4306 | Full | `045_MeadMustFlow.rb:283-306` | |
| MM7 | V4 refuse pit | 4308-4320 | Full | Map 2133 E13 | |
| MM8 | V5 "ME FRIEND!", six baskets, treasure, casks (one empty) | 4321-4302 | Full | `045_MeadMustFlow.rb:308-381` | |
| MM9 | V6 and V7: Yogobor, Artin's bones, Silvanus's pool | 4304-4362 | Full | `045_MeadMustFlow.rb:383-425` | |
| MM10 | V8 niches; V9 Duhg with his knife; he whistles for help | 4364-4389, 4248-4254 | Full | `045_MeadMustFlow.rb:427-447` | |
| MM11 | V10 chieftain's tomb, pearl and wand, nightmare curse | 4362-4402 | Full | `045_MeadMustFlow.rb:449-516` | |
| MM12 | Gahg arrives; her basket of nautiloid bits | 4404-4451 | Full | `045_MeadMustFlow.rb:518-600` | |
| MM13 | Home with the mead; fear of verbeeg left alive | 4453-4459, 4394-4397 | Full | `045_MeadMustFlow.rb:603-622` | |
| EL1 | Olivessa versus Shandar; Shandar's Mirabar murder and Zhent blackmail | 4109-4131 | Full | `022_Chapter4.rb:161-164`; `045_MeadMustFlow.rb:684-686` | |
| EL2 | Olivessa asks the party leader to run | 4398-4420 | Full | `045_MeadMustFlow.rb:625-660` | |
| EL3 | Inquiries about the candidates | 4426-4444 | Full | `045_MeadMustFlow.rb:662-669` | |
| EL4 | Hike to Targos; eight thugs; staged rescue; Naerth exposed | 4445-4456 | Full | `045_MeadMustFlow.rb:671-748` | Bug 2: the clock survives the loop. |
| EL5 | Shandar elected unless exposed | 4457-4459 | Full | `045_MeadMustFlow.rb:757-786` | |

**Dougan's Hole and Holed Up**

| # | Element | R lines | Status | Where in game | Notes |
|---|---|---|---|---|---|
| DH1 | Inbred townsfolk (ears, teeth); 50 people; buckled pier, icebound keelboats | 3069-3085 | Compressed | `045_HoledUp.rb:387`; `022_Chapter4.rb:337` | Gap 10. |
| DH2 | Dark shapes standing still on the ice | 3085-3087 | Changed (deliberate) | `022_Chapter4.rb:216-222, 413-424`; Map 2035 E34-E38 | The hag's victims. |
| DH3 | Speaker Durmoot believes the children are dead and gives no help | 3094-3100, 3141-3146 | Changed (integration) | `022_Chapter4.rb:431-472` | Gym 3. |
| DH4 | Twenty Stones of Thruun | 3093-3105, 3126-3137 | Full | `022_Chapter4.rb:199-200`; Map 2035 E41 | |
| DH5 | Warmth sacrifice | 3111 | Full | Map 2035 E48 | |
| DH6 | Townsfolk chorus | 3183-3202 | Full | `022_Chapter4.rb:202-208` | Their descriptions are dropped (gap 10). |
| DH7 | Militia: nobody leaves | 3102-3104, 3201 | Full | `022_Chapter4.rb:209-215` | |
| DH8 | Good wolf, bad wolf: limp, Garagai lie, threat, conscience | 3148-3196 | Full | `045_HoledUp.rb:87-138` | |
| DH9 | Norsu: awakened, grieving, the master of the extortion; the wolves expect him to kill you | 3108-3125, 3210-3222 | Full | `045_HoledUp.rb:244-249, 186-197, 477` | |
| DH10 | Blizzard on the crossing; the wolves shield you | 3198-3211 | Compressed | Map 2039 weather | Gap 10. |
| DH11 | Starving pack | 3212-3218 | Changed (deliberate) | `045_HoledUp.rb:151-179` | Bug 1: skippable. |
| DH12 | Lodge approach: three east openings, remorhaz tunnel, "Garagai isn't home", the nudge to L4, the wait at L1 | 3220-3238 | Full | `045_HoledUp.rb:186-204`; Map 2039 E13-E35 | |
| DH13 | L2 flensing chamber; stone chest; scrimshaw goat | 3243-3260 | Full | Map 2040 E24-E26; `045_HoledUp.rb:333-338` | |
| DH14 | L3 cage: Silja and Finn; heat the slats; pick the lock; screaming hinges; oil | 3243-3272 | Full | `045_HoledUp.rb:380-461` | |
| DH15 | L4 icicle corridor | 3276-3291 | Full | `045_HoledUp.rb:217-231` | |
| DH16 | L5 Norsu calmed by friendship or vengeance; prayer or gift; otherwise he charges | 3293-3313 | Full | `045_HoledUp.rb:240-293` | |
| DH17 | Ice throne rune calls a blizzard | 3301-3335 | Full | `045_HoledUp.rb:297-320` | |
| DH18 | L6 chwinga statuette; Holgi, Snorp, Zilbo | 3336-3362 | Full | `045_HoledUp.rb:340-358`; Map 2040 E33 | |
| DH19 | L7 bedroll | 3368-3378 | Full | Map 2040 E34 | |
| DH20 | L8 whale oil; remorhaz tunnel; thrym | 3318-3335 | Full | `045_HoledUp.rb:322-331`; Map 2040 E36 | Thrym is flavour only. |
| DH21 | Wolves ambush on the way home; kill one and the other flees | 3336-3351 | Changed (deliberate) | `045_HoledUp.rb:466-498` | Both flee to the chasm. |
| DH22 | Hilda; boots of the winterlands; her husband was also her brother | 3353-3369 | Full | `045_HoledUp.rb:62-81` | |

**Easthaven**

| # | Element | R lines | Status | Where in game | Notes |
|---|---|---|---|---|---|
| EH1 | Eastway routing to Easthaven (7½ h) | 3385-3444, 1769 | Changed (neither) | `022_Chapter4.rb:143-146` | The road is closed by a slide. |
| EH2 | Easthaven's quests (Toil and Trouble, Cauldron Caper) | 3420, 3831-3846 | Missing (optional in book) | none | The town isn't visited. |

---

### Things to remember (from this audit)
- The game's Act I maps are 2000-2046, 2100 and 2120-2137. The new Act I build-out lives in `044_ChasmFaithful.rb` and `045_*.rb`, with switches 4000-4079.
- `docs/coverage_W1.md` and `docs/coverage_W2.md` are the builders' own claims. They report Full on rows that this audit finds buggy: bugs 1, 3, 4 and 5.
