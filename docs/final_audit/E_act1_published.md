# Final audit E: Act I (Chapters 1-5) against The Cackling Chasm and Rime of the Frostmaiden

## How I checked

- **The Cackling Chasm** (`sources/cc.txt`): I read all 1,330 lines, in chunks of about 300.
- **Rime of the Frostmaiden** (`sources/rotf.txt`): I read these sections in full:
  - Starting Town, the Ten-Towns Rumors, Sacrifices to Auril and the Council of Speakers (R 800-1080)
  - Cold-Hearted Killer: Hlin, Torg's, Torrga and Sephek (R 1080-1315)
  - Bryn Shander and Foaming Mugs (R 1726-1963)
  - Dougan's Hole and Holed Up (R 3068-3384)
  - Easthaven, down to its routing (R 3385-3440)
  - Good Mead, The Mead Must Flow and the speaker election (R 4070-4459)
  - Lonelywood and The White Moose (R 4462-4905)
  - Targos and Mountain Climb (R 4910-5264)
  - Termalaine and A Beautiful Mine (R 5268-5708)
- **Code:** I read every Act I script in full: 006, 007, 014, 015, 017, 022, 023, 044 and all seven 045_* files. I also read the helpers they rely on: 026 `cl`/`sayc`, 031, 039 `start_loop`, 040 loop, and 029's journal payoff.
- **Event dump:** I loaded every compiled map (`build/maps/Map*.rxdata`) with `tools/rgss_stub.rb` and dumped every event page: conditions, trigger and scripts. That is 3,344 pages, 1,735 of them on Act I maps (2000-2046, 2100, 2101, 2120-2137).
- **Wiring:** every `FT.scene(:key)` placed on an Act I map has a `scene_key` method. Every story function defined in the Act I files is called by an event or by another reachable function.
- **Bypass checks:** I flood-filled (Ruby, same passability rule as `tools/reach.rb`) the trigger rows a story beat depends on, to see whether a player can walk round them.
- **Read-only:** I changed nothing under `/home/claude/frost-thaw`. I read the earlier `docs/reaudit/E_act1_published.md` only after finishing my own pass, to see which of its bugs are still open.

**Citations:**
- **CC n** is a line in `cc.txt`. **R n** is a line in `rotf.txt`.
- Code is `file:line` in `game/Data/Scripts/998_FrostThaw/` unless the path starts with `tools/`.
- **Map E n** is an event id in my dump.

---

## 1. Summary

### Counts (261 rows in section 3)

| Source | Full | Compressed | Changed | Missing | Unreachable | Total |
|---|---|---|---|---|---|---|
| The Cackling Chasm | 79 | 1 | 11 | 2 | 0 | 93 |
| RotF: places, NPCs and quests the game uses or touches | 146 | 4 | 13 | 5 | 0 | 168 |
| **All** | **225** | **5** | **24** | **7** | **0** | **261** |

Bugs are listed separately in section 2 (B1-B8). Three of them sit under rows marked Full, because the content is there but a player can miss it or see it broken.

How the 24 Changed rows break down:

- **Campaign rewrites or owner and fix-round decisions (14):**
  - the hag's earlier freeze, played live at the Twenty Stones
  - the Heart as the World Tree's last root
  - the mother yeti can live
  - the bargain leads to the loop
  - the mirror ending and the Verdant Reversal
  - Sephek's Shimmer story, and his freezing instead of death
  - the speakers as Gyms
  - the lottery-night stand
  - the shapes on the ice as the hag's victims
  - the bite on the tundra
  - both winter wolves fleeing to become Kanan at the Heart
- **Integration choices made during the build that the brief doesn't list (8).** I judge each in section 2:
  - Alberica's future self as the Order's ghost, on the locket and in the gate's vision (3 rows)
  - the Glimmer skeleton with claws
  - "Shimmer" instead of "Glimmer" at the false light
  - Reptin vowing to return instead of staying
  - Hlin in Lonelywood
  - the father yeti calmed by your own Yetot
- **Neither (2):**
  - Easthaven is closed by a rockslide.
  - Turning Olivessa down leaves Shandar unopposed.

The 7 Missing rows are all optional or minor:

| Source | Missing row |
|---|---|
| CC | the banshee fight if you attack the ghost (the book calls it unnecessary) |
| CC | Reptin's wolf-and-raven messages (impossible once he falls 400 years) |
| RotF | Nature Spirits (the book's alternative starting quest) |
| RotF | Easthaven's own content |
| RotF | Sephek's ice blades melting in other hands |
| RotF | the option to hand Sephek to the authorities |
| RotF | the reward-for-Garret's-body branch (Garret can't die) |

### Honest judgement

**Both sources are now adapted almost room by room, and often word for word.** I looked for corners cut in the content itself and found almost none:
- **The Cackling Chasm:**
  - every keyed area, its optional threats (wisps, bats, gnoll ghost, coldlight walker)
  - the coven sister on Hard
  - the lair actions, the in-battle lunge and "Still time to reconsider"
  - the full treasure list, the dark path, the witch-queen loss and every epilogue image
- **Rime of the Frostmaiden:** every quest the game touches is built to the book's map keys:
  - Mountain Climb (base camp to ruined camp)
  - Foaming Mugs (all three goblin solutions)
  - Holed Up (L1-L8, with whale oil, slats and lock)
  - The Mead Must Flow (V1-V10, Gahg, the curse and the election)
  - The White Moose (E1-E9, forest table, mirror)
  - A Beautiful Mine (M1-M13, Janth, outcomes)
  - Cold-Hearted Killer (Hlin, Torg's, Torrga's crew, the sack, Sephek's true nature)

Most of the previous re-audit's bugs are fixed: the acorn, the Council timing, Oarus's page, Hlin, the fox, Keegan, the menu cancels, the whisper row, the pronoun, the loop's state leak, and Naerth's account of the victims.

**What still stops Act I being bulletproof is a handful of logic bugs, two of them new:**
1. **B2:** the Glade's Heart-of-Ice scene can be walked round, and when it does fire it can replay. Replaying hands back a Heart of Ice after the Requiem has used it, and resets the goal to "The Moon Temple".
2. **B1:** the fix for the skippable starving-pack bite is incomplete. One tile at the south end of the row is still open, so Reptin's curse can still be skipped.
3. **B3:** Good Mead's election clock and the chieftain's curse are never switched off when Act I ends:
   - A rest in Rootspire, 400 years later, can bring "a rider from Good Mead".
   - A pearl taken from the tomb curses every rest for the rest of the game, and the tomb can never be revisited.
4. **B4:** after the hag's bargain loops you back, Targos offers "skip ahead to the fall". That replays Act I's static flags, `:reversal` among them. You can skip the very third way the ghost tells you to go back and find.

None of these is large. Content: about 95% faithful. Robustness: four bugs worth fixing before calling Act I done.

---

## 2. Every row that is not Full, and every bug, ranked by importance

### B2 (BUG, high). The Glade's Heart of Ice scene can be bypassed, and it replays

- **What the campaign needs:** at the Glade you take Shimmer's heart (and meet Meat Meat). That sets switch 3917, which arms Sephek at the Moon Temple (`2023 E6` p1).
- **Bypass:**
  - The scene is a four-tile trigger row at x 13-16, y 18 (`tools/build_ch3.rb:295-301`; `2026 E5-E8`).
  - The Glade is open from x 8 to x 21 on that line.
  - Flood fill: from the entrance (14,26) you can reach the altar (14,12) without touching the row.
  - The altar's own action page only prints `:undying_rose` (`2026 E3` p1), so a player who walks round has no heart and no way on.
- **Replay:**
  - `scene_glade_aftermath` (`015_Chapter3.rb:474`) has no guard.
  - Each of the four tiles has its own self switch, so crossing the row at a second column plays the scene again.
  - On a replay after the Requiem, which took the heart (`015_Chapter3.rb:671`), `give_key(:FT_HEARTOFICE)` (`:491`) gives you a second heart.
  - It also replays the Jet Sentry lines and resets the goal to "The Moon Temple... Sephek is waiting for the heart" (`:525`).
- **Fix:**
  - Add `return if flag?(:heart_of_ice)` at the top of `scene_glade_aftermath`.
  - Either widen the row to x 8-21, or make the altar's switch-3916 page call `FT.scene(:glade_aftermath, @event_id)`.

### B1 (BUG, high). The starving-pack bite, origin of Reptin's curse, can still be skipped

- **The fix that was made:** a "The pack watches" trigger row at x 35, y 4-30 (`tools/build_tentowns.rb:326-331`; `2039 E13-E39`).
- **Why it fails:** the map is 34 tiles high, and (35,31) is passable, with (34,31) and (36,31) open on either side. Flood fill from the tundra entrance (58,16) reaches all three lodge doors (18,15), (17,10) and (17,20), and the remorhaz tunnel (10,25), without touching the row.
- **What then breaks:** these lines assume the bite happened, and none of them is conditional:
  - "the bite on your hand throbs" (`044_ChasmFaithful.rb:902`)
  - "(hand closing over the bite)" (`022_Chapter4.rb:613`)
  - "The bite. It's the bite." (`023_Chapter5.rb:191, 202`)
  - "your bitten hand" at the Gate (`023_Chapter5.rb:627`)
  - the ghost's "That bite didn't find you by chance" (`023:730`)
- **Fix:**
  - Extend the row to y 31, i.e. `(4..31)` in `tools/build_tentowns.rb:326`.
  - As a safety net, call `starving_pack` from `scene_lodge_approach_step` (`045_HoledUp.rb:221`) when `!flag?(:reptin_bitten)`.

### B3 (BUG, medium-high). The Good Mead election clock and the chieftain's curse outlive Act I

**The mechanism:**
- `long_rest_taken` (`045_MeadMustFlow.rb:500-503`) runs the chieftain's nightmare (R 4396-4402) and advances the election (`:717-742`).
- It is hooked into `set_rest_at` (`:483-486`) and `set_rest_point`, so every rest calls it.
- Act II and later rest points call `set_rest_at`: `024_Chapter6.rb:365`, `026_Rootspire.rb:1240`, `034_Chapter8.rb:141, 867`, `038_Chapter12.rb`.
- Nothing checks `:act1_done`.

**Failure 1: the election follows you into the future.**
1. Talk to Olivessa, which starts the eight-rest clock.
2. Head for the chasm without resting eight times.
3. A rest by the warm fissure, or a rest in Rootspire four centuries later, prints "(A rider from Good Mead finds you on the road. The town has voted.)" (`:739`) and runs `election_result`.

**Failure 2: the curse can never be lifted.**
- Take the pearl and wand (`:444-467`), then finish Act I.
- Every rest for the rest of the game halves your healing (`:505-510`).
- The only cure is to put them back in the tomb, which can't be reached again. The book also allows *remove curse*, which the game doesn't offer.

**Fix:**
- In `long_rest_taken`, `return if flag?(:act1_done)`.
- In `scene_falling` (`023_Chapter5.rb:1069`), resolve a pending election off-screen ("word reaches you as you fall...").
- Either lift the curse at the Verdant Reversal, or have the Order's ghost or the Heart lift it.

### B4 (BUG, medium). After the bargain loop, you can skip the chasm you were sent back to redo

- **The setup:** "...Do it." leads to `chasm_dark_ending`, then `chasm_wheel_turns_back`, then `start_loop` (`044_ChasmFaithful.rb:669-749`). The ghost says "Go round again. Find the third way." (`:742`)
- **The skip:** on the next pass, `scene_targos_arrival` calls `loop_skip(:act1)` (`007_Story.rb:110`; `040_Loop.rb:52-73`), which offers "Skip ahead to the fall, at the end of Act I?"
- **Why that's wrong:** no `:act1` snapshot exists yet, because `loop_snapshot(:act1)` runs only in `scene_falling`. So the skip uses the static `LOOP_ACT1_FLAGS`, which include `:reversal`, `:act1_done` and `:razzy_hatched` (`041_LoopFlags.rb`). The player lands in Act II as if they had found the third way.
- **Fix:** in `loop_skip`, refuse (or skip only to Dougan's Hole's morning, before the Laughing Waste) when `state[:bargain_memory].to_i > 0` and `state[:loop_snap]` has no `:act1` entry.

### HU2 / B5 (BUG, medium-low). Koran's "good wolf, bad wolf" scene can be walked past

- **Source:** R 3148-3196 has the winter wolves approach the party.
- **In the game:** Koran is an action-button NPC at (5,22) beside the open west road (`tools/build_ch4.rb:292`; `2035 E28` p1). The flood fill reaches the west exit without his tile.
- **What you lose if you skip him:**
  - the limp, the lie, Kanan's threat and the appeal to your conscience (`045_HoledUp.rb:87-140`)
  - the wolves meeting you at the lodge (`scene_lodge_approach` needs `:met_wolves`)
  - the tundra shielding
- The ambush still fires, so the quest completes.
- **Fix:** make it a trigger-1 row across the west road (y 19-22 at x 3), calling `koran` once.

### BM16 / B6 (BUG plus Compressed, low-medium). The mine's outcomes contradict each other after the grell kills Oarus

- **Source (R 5687-5697):**
  - grell left alive: Oarus is killed, miners vanish, and the mine closes for good
  - Trex left in the mine with the ghost loose: Oarus comes back possessed
  - kobolds brought to town with the ghost loose: the ghost possesses *someone*, and Trex reverts
- **The bug:**
  - The grell branch sets `:mine_done` (`045_Termalaine.rb:558-560`).
  - Every `:mine_done` line then says the mine is open and safe:
    - Darmo: "The gemstone mine is OPEN! Speaker Masthew says it's SAFE!" (`:204`)
    - the miner: "Back to work! Picks in the walls again." (`:103`)
    - Jory: "Back to work tomorrow! Thanks to you." (`:154`)
- **Compression:** grell-alive always means Oarus dies, even if kobolds remain. The loose ghost always takes Oarus.
- **Fix:**
  - Give those three lines an `:oarus_dead` variant ("closed for good, and nobody goes near it").
  - Optionally, put the grell in Shaelen's mouth as the reason.

### MM21 (Changed, neither; low). Turning Olivessa down means nobody stands against Shandar

- **Source:** two contenders already exist; Olivessa is "a leading candidate herself" (R 4111-4131, 4417-4420).
- **In the game:** "It's not our town" sets `:no_challenger`, and Shandar wins by a show of hands (`045_MeadMustFlow.rb:638-643, 767-771`).
- **Fix:** keep Olivessa running unbacked. Let the thugs and the vote still happen, and decide it on `:shandar_exposed`.

### C29 (Changed, integration; judged acceptable). The false light says "Shimmer", not "Glimmer"

- **Source (CC 425-434):** asked its name, the voice answers "Glimmer... I'm Glimmer. I'm lost...". The name is meant to ring a bell after the journal.
- **In the game:** "It's me... it's Shimmer" (`023_Chapter5.rb:422, 452`). It's crueller and lands on Shade.
- **What's lost:** the light's tie to the name "Glimmer". The name survives through the journal (`023:393-409`), "Glimmer in the Chasm" (`044:874`) and Shade's line (`044:876`).
- **Suggestion (optional):** have the voice add "...they call me Glimmer, here" on the "Who are you?" clue.

### C17, C49, C52 (Changed, integration; judged fair)

- **Source:**
  - the locket holds a stern *human* woman's portrait (CC 233)
  - the gate vision shows a robed figure (CC 781)
  - the ghost names herself "Alberica, last guardian" (CC 815-816)
- **In the game:**
  - the portrait and vision are Alberica's own face, older (`023:278-285, 634`)
  - the ghost doesn't give her name: "I borrowed it" (`023:695-699`)
- This keeps the module's deliberate use of the player's name and pays it off in the campaign's time loop. It is not an error.

### C25 (Changed, integration; judged fair)

- **Source (CC 366, 371):** the journal lies by a *human* skeleton.
- **In the game:** the skeleton is "too long in the arm to be human, with claws on its fingers" (`023:394`). It is the cat-man Glimmer from an earlier turn of the wheel, and that is paid off when Glimmer recognises his own handwriting (`029_Glimmer.rb:127-140`).
- This is coherent with "Glimmer dies at the Forge" only as a loop echo, and the game says exactly that.

### C86 (Changed, integration; acceptable)

- **Source (CC 1132, 1191-1194):** Reptin may stay behind as the chasm's warden.
- **In the game:** he can't, because the fall takes everyone 400 years on. He vows to return (`044:827-829`), and the Reghed "new Order" glimpse (`:872`) covers the watch.
- **C92**, his wolf-and-raven messages (CC 1274-1276), is the Missing consequence.

### C70 (Changed, fix-round decision; implemented correctly)

- **Source (CC 1147-1152, 1198-1215):** a "valid, if dark" ending.
- **In the game:** it is played in full: the cub dies, the sun rises, Reptin is cured, he howls, and he fights the Winter-Crowned (`044:669-723`). Then it loops back (`:738-749`).
- This only happens after "...Do it." plus a confirmation (`023:958-964`). The lunge can never kill the cub (`044:570-612`). Both match the brief, apart from B4.

### K19 (Compressed, low). Torrga's grudge

- **Source (R 1303-1315):** she pressures Ten-Towners, so you can't buy what you need, or are refused lodging at an inn.
- **In the game:** only three marts refuse (`044:1188-1204`). Inns and rest points never do.
- **Fix:** have Marta (`045_Termalaine.rb:283`) or Owenn refuse a bed while `:torrga_grudge` is set.

### K18 and K14 (Missing, low). Cold-Hearted Killer details

- **K18:** handing Sephek to the authorities (and losing Hlin's reward) isn't offered (R 1289-1302). Sephek is frozen by the campaign, so this is mostly moot.
- **K14:** his ice weapons "melt and break like icicles in the hands of other creatures" (R 1276-1278).
- **Fix (optional):** after the Moon Temple fight, a line where his blade melts in Shade's hand.

### BM10 (Compressed, low). The grell never stalks a lone party member

- **Source (R 5575-5590):** the grell follows at 30 feet and picks off whoever is alone.
- **In the game:** "Back away" has no consequence (`045_Termalaine.rb:389-392`).
- **Fix (optional):** set `:grell_stalking`. The next time you take the bucket lift, which goes one at a time, it attacks.

### C32 (Compressed, low). The pit trap has no save

- **Source (CC 482-486):** a Dex save lets the lead character jump back.
- **In the game:** everyone always falls (`023:460-470`).
- **Fix (optional):** a "Jump back!" choice, so the party can rope down to the pit instead of falling into it.

### MC16, MC3, MC20 (Changed / Compressed / Missing, low). Mountain Climb edge cases

- **MC16:** the father yeti is calmed by a Yetot in your party (`045_MountainClimb.rb:493-498`), not by the Littlest Yeti secret or by trading the tyke (R 5233-5240). It's sensible, because you can't take the tyke.
- **MC3:** the Caer-Konig / Frozenfar route is only mentioned (`:192`). Caer-Konig isn't in the game.
- **MC20:** the book's reward-for-Garret's-body branch (R 5257-5259) can't happen. Garret can't die.

### EH1, EH2, T5 (Changed / Missing, low; out of the campaign's route)

- **EH1 (Changed):** the Eastway's Easthaven arm is buried by a slide (`022_Chapter4.rb:143-146`; R 3438-3444, 1769).
- **EH2 (Missing):** Easthaven's content isn't built. Danneth Waylen appears only at the Council.
- **T5 (Missing):** Nature Spirits (R 1316-1335) is the book's alternative to Cold-Hearted Killer, and the book uses only one.
- **Rumours of unbuilt quests:** the rumour table (`045_TenTowns.rb:60-81`) faithfully advertises quests that don't exist in the game: Bremen's lake monster, Caer-Dineval, Caer-Konig, and Easthaven's wizard. So does Copper's Black Cabin hook (`045_TenTowns.rb:279-305`). These are flavour, but they can never be resolved.
- **Fix (optional):** a closing clause for those rumours ("...but nobody's getting through to Bremen this winter").

### B7 (text bug, low)

The Mirror of the Full Moon calls Sephek "a man in a fine coat" (`045_WhiteMoose.rb:666`). The book (R 1221-1228) and the game's own Torg's scene ("No coat, no hat", `044:1065`) both say he wears none. Change it to "a man in shirtsleeves".

### B8 (dead condition, low)

`048_Rootspire_E_Nights.rb:116` counts `:hag_bargain_taken` toward an omen. That flag is set only in the dark ending, which always runs `start_loop`, and `start_loop` clears it. So it is never true in Act II. Use `state[:bargain_memory].to_i > 0` instead.

### C61 (Missing, optional in book)

If the party attacks the ghost, she becomes a banshee (CC 890-891, "unnecessary... off-track"). There's no attack option. Fine as is.

### Deliberate Changed rows I accept (no fix)

- **C1:** the hag's freeze of Dougan's Hole becomes the live night at the Twenty Stones (`022:503-635`).
- **C4/C55:** the Heart is the last root of the World Tree, and the hag wants to "drain the root" (`023:719-740`).
- **C22:** the mother yeti can live (owner decision; `023:325-382`).
- **C81:** the hag is caught in her mirrors, and the Verdant Reversal follows (`023:985-1066`).
- **K1:** Hlin is in the Lucky Liar, near Torg's, instead of the starting town's tavern. Allowed by R 1216-1229.
- **K15/K16:** Sephek's Shimmer story and the frozen non-death.
- **TG3/BS2/DH5:** the speakers as Gyms.
- **BS12:** the lottery-night stand.
- **DH1:** the shapes on the ice.
- **HU4:** the bite.
- **HU14:** both wolves flee south, and Kanan becomes the winter wolf at the Heart, as CC 975-976 suggests.

None of the build's listed integration choices (Darrus, Pell, the Undercity, Razzy's scale) touches Act I.

---

## 3. Full table

Status: **Full**, **Compressed** (what's lost), **Changed** (*campaign/owner* = the campaign's or owner's own; *integration* = a build choice; *neither*), **Missing**, **Unreachable**.

### 3a. The Cackling Chasm

| # | Element | CC | Status | Where in game |
|---|---|---|---|---|
| C1 | Backstory: the hag froze Dougan's Hole; she was thwarted | 9-12 | Changed (campaign) | `022:503-635`; 2035 E30-E33 |
| C2 | Her bargain: end the winter, cure Reptin, for a task | 13-18, 49-52 | Full | `044:894-917` (called at `022:561`) |
| C3 | Order of Life and Death; werewolf wardens; Reptin bound by blood | 20-25 | Full | `023:727-732` |
| C4 | The Heart; the hag's hidden truths | 26-43 | Changed (campaign: World-Tree root) | `023:719-740` |
| C5 | Hook: messenger or dream | 49-52 | Full | `022:549-565`; `023:208-218` |
| C6 | Hook: hunters hear cackling south of the Hole | 53-56 | Full | `006:33-34`; `022:196-197`; `023:89-91` |
| C7 | Hook: Reptin's vision ("Abandon your bond...") | 57-61 | Full | `023:180-225` |
| C8 | Features: dark, cold, slick ice, echoes, smells, whispered names | 69-101 | Full | `044:163-185`; whisper rows 2042/2044/2046 |
| C9 | Escalating horror toward a moral choice | 102-108 | Full | `023:952-964` |
| C10 | Reptin anxious; amber eyes at the blood; his vow | 115-122, 393-397 | Full | `044:198-219`; `023:305-316` |
| C11 | "Take me instead!" and her scorn | 125-128, 996-998 | Full | `023:966-969` |
| C12 | The hag holds or paralyses Reptin | 123-125, 981-987 | Full | `023:933-941, 980` |
| C13 | Area 1: illusory greeting; "I smell the wolf..." | 142-169 | Full | `023:231-256`; 2042 E6 |
| C14 | Area 1: seeing through the illusion | 170-179 | Full | `023:244-251` |
| C15 | Area 1: icefall; "Oops! Mind your heads" | 180-200 | Full | `023:258-267`; 2042 E7 row |
| C16 | Area 1: ice mephits; death burst | 201-226 | Full | `023:268-274` |
| C17 | Area 1: locket (Order symbol, "Alberica", warmth) | 227-237 | Changed (integration: Alberica's own face) | `023:277-293`; 2042 E16 |
| C18 | Area 1: gnoll femur in the fallen ice | 244-249 | Full | `044:187-193`; 2042 E15 |
| C19 | Area 2: carnage | 252-276 | Full | `044:198-205`; 2042 E17 |
| C20 | Area 2: dead male yeti, heart cut out | 276-282 | Full | `023:295-304` |
| C21 | Area 2: blood runes; Yeenoghu over the druidic emblem | 283-290 | Full | `044:109-114, 221-227`; 2042 E21 |
| C22 | Area 2: mother yeti fights to the death | 291-345 | Changed (owner: lives or dies) | `023:325-382` |
| C23 | Area 2: tracks and drag marks | 346-351 | Full | `023:305-310` |
| C24 | Area 2: swaddling in the father's fist | 352-357 | Full | `023:301-310` |
| C25 | Area 2: backpack, potion, Glimmer's journal | 365-381 | Changed (integration: clawed skeleton = Glimmer) | `023:393-409`; `044:922-933`; `029:127-140` |
| C26 | Area 2: coins, gnoll greataxe, necklace of ears | 365-370 | Full | `044:229-243` |
| C27 | Area 2: "Ohhh, such violence... time is ticking" | 389-392 | Full | `044:246-253` |
| C28 | Area 3: glassy corridor; a lingering reflection | 400-424 | Full | `023:415-417` |
| C29 | Area 3, left: false light; child says "Glimmer" | 425-434 | Changed (integration: "Shimmer") | `023:419-422, 452` |
| C30 | Area 3, right: weeping woman, also illusory; colder breeze | 434-442 | Full | `023:420, 440-449, 519-521` |
| C31 | Area 3: clues (reflections, loop, insight, detect) | 443-460 | Full | `023:430-458` |
| C32 | Area 3: pit trap | 469-489 | Compressed (no save to jump back) | `023:460-470`; 2042 E43 row |
| C33 | Area 3: two ghouls in the pit | 489-513 | Full | `023:472-486`; Map 2043 |
| C34 | Area 3: pit treasure (dagger, 15 gp, agate, potion, scrimshaw halfling) | 514-519 | Full | `023:488-498` |
| C35 | Area 3: "SHE LIES / DON'T TRUST THE LIGHT" | 519-523 | Full | 2043 E2 |
| C36 | Area 3: climbing out; "Poor little lambs..." | 523-529 | Full | `023:481-482, 500-507` |
| C37 | Area 3: guilt on the right path ("Don't leave me!", a girl's reflection) | 465-466, 530-542 | Full | `023:509-523`; `044:383-387` |
| C38 | Area 4: rift, narrow bridge, frayed rope, chanting | 564-599 | Full | `023:537-548` |
| C39 | Area 4: ice chunk cracks the bridge; next stretch worse | 580-583, 627-635 | Full | `023:550-570` |
| C40 | Area 4: crossing as a challenge; rope plans; falls | 606-623 | Full | `044:258-350`; Map 2100 |
| C41 | Area 4: gusts | 623-627 | Full | `023:572-588` |
| C42 | Area 4: personal voices on the wind | 635-638 | Full | `044:365-388` |
| C43 | Area 4: ghostly woman points up | 652-658 | Full | `023:561-563` |
| C44 | Area 4: optional threats (wisps, specter/gnoll ghost, coldlight walker, bats) | 639-675 | Full | `044:286-287, 352-362, 391-413`; 2044 E18; 2100 E2-E3 |
| C45 | Area 4: sheltered nook; uneasy rest | 687-690 | Full | `023:590-605` |
| C46 | Area 5: the gate (carvings, arch, whisper) | 693-722 | Full | `023:607-613`; 2044 E23 |
| C47 | Area 5: the offering puzzle (blood; bone, ash or silence; stained bowls) | 723-752 | Full | `023:614-641` |
| C48 | Area 5: wrong offering: necrotic burst, skeletons, repeat waves | 753-775 | Full | `023:641-659` |
| C49 | Area 5: vision of the rite with wolves | 776-783 | Changed (integration: a dwarf, Alberica's face) | `023:632-637` |
| C50 | Area 5: hidden seam to the sanctum | 784-793 | Full | `023:662-670`; 2044 E24 |
| C51 | Area 6: bier, preserved corpse, vigil, the corpse rises | 795-819 | Full | `023:676-694` |
| C52 | Area 6: "I am Alberica, last guardian" | 815-824 | Changed (integration: unnamed, her face "borrowed") | `023:695-699` |
| C53 | Area 6: the Order's history; Yeenoghu's gnolls; sealed from inside | 825-839 | Full | `023:718-726` |
| C54 | Area 6: Children of the Wolf; "a sacred charge" | 828-834 | Full | `023:727-732` |
| C55 | Area 6: the hag's scheme; a blight on life and death | 839-844 | Full | `023:734-739` |
| C56 | Area 6: a yeti child; soul-debt | 844-850 | Full | `023:740, 804-807` |
| C57 | Area 6: cure means cutting the bond; Reptin's choice | 850-856 | Full | `023:742-753, 808-812` |
| C58 | Area 6: an alternative (a life freely given) | 861-868 | Full | `023:765` (adds "a life not yet begun": the acorn) |
| C59 | Area 6: boons (heal, talisman locket, silver dagger) | 868-883 | Full | `023:755-761, 784-785`; `044:958-988` |
| C60 | Area 6: motherly words; "I cannot leave this crypt" | 884-889 | Full | `023:751-753, 770-771` |
| C61 | Area 6: attacked, she becomes a banshee | 890-891 | Missing (optional; book calls it unnecessary) | none |
| C62 | Area 6: the prophecy | 892-896 | Full | `023:773-774` |
| C63 | Area 6: fades; body to dust; lichen dims | 896-899 | Full | `023:779-781` |
| C64 | Druidic Codex on the shelf | 1250-1253 | Full | `044:418-431, 935-941`; 2045 E2 |
| C65 | Tips: break her staff; "Only flame can quell the ice-eater" | 909, 1066-1068 | Full | `023:762-763`; `044:477-481` |
| C66 | Area 7: the Heart (spires, blood-red orb, heartbeat) | 912-920 | Full | `023:827-835` |
| C67 | Area 7: cub chained between the pillars | 921-924 | Full | `023:832`; 2046 E10 |
| C68 | Area 7: the hag in full (bruise skin, teeth necklace, staff of frozen sprites) | 925-931 | Full | `023:916-920` |
| C69 | Area 7: cauldron, blue fire, caul of vapour | 932-934 | Full | `023:833`; `044:127-129`; 2046 E8 |
| C70 | Area 7: winter wolf and ice troll | 935-938, 974-980 | Full | `023:921-922`; Kanan from Holed Up (CC 975-976) |
| C71 | Area 7: "Ssooo, my dearies..."; chains hoist the cub; curse tug; "A life for a life" | 939-959 | Full | `023:923-948` |
| C72 | The choice: agree, and the dark path | 988-991 | Changed (fix round: leads to the loop) | `023:952-964`; `044:669-749` |
| C73 | Monologue ("the new Winter"), "How precious. How weak.", "Then be damned", spite lunge | 1000-1007 | Full | `023:929-931, 974-979` |
| C74 | Her tactics: flight on the staff, illusions, targeting | 1011-1022 | Full | `044:486-538` |
| C75 | The coven option | 967-973, 1052-1056 | Full | `044:622-634` (Hard: Ethel) |
| C76 | The Heart's lair actions (necrotic wave, visions, life pulse) | 1035-1045 | Full | `044:497-532` |
| C77 | The cub at risk mid-fight; freeing the chains | 1030-1034, 1071-1077 | Full | `044:505-511, 549-588` |
| C78 | "Still time to reconsider!" | 1078-1080 | Full | `044:533-536` |
| C79 | At low HP she lunges for the cub | 1046-1050, 1084-1093 | Full | `044:542-563, 648-665` |
| C80 | Alberica's ghost aids once | 1057-1060 | Full | `023:888-900`; `044:596-600` |
| C81 | Reptin vs the winter wolf | 981-985 | Full | `044:458-468` |
| C82 | The troll regenerates unless fire is used | 1026-1028, 1063-1068 | Full | `044:470-483` |
| C83 | The hag dies; the Heart goes dormant | 1099-1109 | Changed (campaign: the mirrors shatter, she survives) | `023:985-1066`; `023:113-114` |
| C84 | Victory: the cub approaches; its fate (keep, mother, sanctuary) | 1111-1128, 1194-1197 | Full | `044:765-804` |
| C85 | Reptin keeps his charge; the wolf calms | 1119-1124, 1190-1192 | Full | `044:806-811` |
| C86 | Don't destroy the Heart; Reptin stays as warden | 1129-1133, 1191-1194 | Changed (integration: he vows to return) | `044:819-829` |
| C87 | Words over Alberica's resting place | 1162-1163 | Full | `044:812-818` |
| C88 | Treasure: staff, opals, counterspell, cold potion, Black Ice Ring, pelt, Order's chest, Heart fragment, locket's daily bless | 1133-1146, 1236-1257 | Full | `044:837-865, 966-988` |
| C89 | Dark victory: the cub dies, Rime breaks, Reptin cured, his howl | 1147-1152, 1198-1215 | Full | `044:669-723` |
| C90 | Failure: witch-queen of the North | 1219-1229 | Full | `044:726-735, 752-760` |
| C91 | Legacy: wildflower, wolves, Speaker thanks, "Glimmer in the Chasm", Order rekindled, owl feather | 1258-1284 | Full | `044:868-891` |
| C92 | Reptin sends word by wolf or raven | 1274-1276 | Missing (impossible after the fall) | none |
| C93 | Epilogue: dream of Alberica and the glowing child; wolf-and-bloom carving; journal's hidden line | 1164-1169, 1286-1297 | Full | `044:877-891, 929-932` |

### 3b. Rime of the Frostmaiden

| # | Element | R | Status | Where in game |
|---|---|---|---|---|
| T1 | Ten-Towns Rumors table | 871-921 | Full | `045_TenTowns:60-81, 174-180`; 2002/2016/2024/2120/2122 |
| T2 | Sacrifices to Auril (people in three towns; food; warmth) | 1046-1060 | Full | `045_TenTowns:131-148`; `006:28-30` |
| T3 | Council of Speakers; "necessary evils... dealt with some other way" | 1028-1058 | Full | `045_TenTowns:126-134, 395-451`; Map 2134 |
| T4 | Cold open: the sun held down for two years | 1076-1090 | Full | `006:25-27` |
| T5 | Starting quest: Nature Spirits | 1316-1335 | Missing (optional in book) | none |
| K1 | Hlin Trollbane, scarred dwarf with a pipe, in a tavern | 1125-1151 | Changed (integration: Lucky Liar, Lonelywood) | `044:1001-1057`; 2024 E11 |
| K2 | Three ice-dagger murders (halfling, shipbuilder, glassblower) | 1118-1124 | Full | `044:1038-1039` |
| K3 | Lottery cheats; Sephek works for Torg's | 1158-1170, 1266-1271 | Full | `044:1041-1048` (+ Kip's list) |
| K4 | 100 gp, quietly | 1179-1183 | Full | `044:1049-1053` |
| K5 | Torg's: three sleds, gold paw flag, stolen goods at double price, dogs | 1250-1263 | Full | `044:134-140, 1157-1171`; 2021 E25-E33 |
| K6 | Torrga Icevein: racket, murders for profit | 1263-1282 | Full | `044:1106-1155` |
| K7 | The half-elf in the sack; 125 gp bounty | 1266-1272 | Full | `044:1093-1104`; 2021 E28 |
| K8 | Four bandit drivers | 1277-1279 | Full | `044:76-84, 1131-1142` |
| K9 | Strongbox, key at her neck | 1283-1289 | Full | `044:1143-1146` |
| K10 | Sephek's look (vest, ponytail, frozen-lake eyes, no coat) | 1215-1232 | Full | `044:1064-1066` |
| K11 | "Born on Midwinter" | 1254-1257 | Full | `044:1076` |
| K12 | True nature: drowned mariner, frost druid's spirit | 1257-1266 | Full | `044:1174-1184` |
| K13 | Admits guilt; misty step | 1272-1276 | Full | `044:1078-1090` |
| K14 | Ice weapons melt in others' hands | 1276-1278 | Missing (minor) | none |
| K15 | His death destroys the spirit | 1194-1196, 1264-1265 | Changed (campaign: frozen; returns later) | `015:537-579` |
| K16 | Sephek at the lottery; takes Shimmer | none | Changed (campaign) | `014:632-655`; `015:351-412` |
| K17 | Hlin pays; she trusts your word | 1281-1288 | Full | `044:1005-1021` |
| K18 | Hand him to the authorities (no reward) | 1289-1302 | Missing (minor) | none |
| K19 | Torrga's grudge (no sales, no lodging) | 1303-1315 | Compressed (marts only) | `044:1188-1209` |
| TG1 | Targos: walls, frozen harbour, fishing town | 4910-4925 | Full | `006:31-32`; Map 2001 |
| TG2 | Naerth: Zhentarim, lives at the Luskan Arms, flying snakes | 4926-4971 | Full | `007:301-318`; `045_TenTowns:103-106` |
| TG3 | Naerth as Gym 1 | none | Changed (owner/genre) | `007:337-372` |
| TG4 | Skath, the Zhent militia captain | 4951-4953 | Full | `006:116-117` |
| TG5 | Luskan Arms: Owenn's depression, rats, rotten floorboards | 4947-4965 | Full | `045_TenTowns:98-102, 187-204` |
| TG6 | Three Flags Sailing: "Ma" Yarbroul; rumours | 4975-4997 | Full | `006:59-68`; `007:139-144`; 2002 |
| TG7 | Triglio: Jestin Hunrae, the chantey, crushed hand | 4999-5021 | Full | `045_TenTowns:107-109, 207-217` |
| TG8 | Overland: Bryn Shander 2 h; the east-shore path to Termalaine 4 h | 4935-4965 | Full | Map 2101; `045_TenTowns:84-96` |
| MC1 | Boy, the sled dog, drags you to the house | 4977-5024 | Full | `045_MountainClimb:148-161`; 2001 E10 |
| MC2 | Keegan: cider, Garret's story, the reward | 5027-5090 | Full | `045_MountainClimb:168-207` |
| MC3 | Route through Caer-Konig / Frozenfar | 5057-5082 | Compressed (mentioned only) | `045_MountainClimb:192` |
| MC4 | Dwarven Valley refuge (better after Foaming Mugs) | 5095-5112 | Full | `045_MountainClimb:250-257`; 2125 E1 |
| MC5 | Base camp: five dogs, crates | 5099-5119 | Full | `045_MountainClimb:271-289`; 2126 |
| MC6 | Finding the camp with or without Boy | 5120-5127 | Full | `045_MountainClimb:262-269` |
| MC7 | Mountain goats | 5131-5144 | Full | `045_MountainClimb:291-303` |
| MC8 | Avalanche | 5146-5170 | Full | `045_MountainClimb:306-324` |
| MC9 | Garret face down; tended; his story | 5172-5191 | Full | `045_MountainClimb:327-339` |
| MC10 | Crag cats (one falls, the other flees) | 5131-5138, 5192-5196 | Full | `045_MountainClimb:340-351` |
| MC11 | Garret goes home only if healed and you vow | 5139-5156 | Full | `045_MountainClimb:352-378` |
| MC12 | Perilous climb: three checks, lost hours, exhaustion | 5158-5165 | Full | `045_MountainClimb:383-411` |
| MC13 | F1: chasm, stone bridge, ice sheet that can be smashed | 5191-5212 | Full | `045_MountainClimb:416-435`; 2128 |
| MC14 | F2: Mokingo's bones; heads in niches (Oobok, Barthoom) | 5213-5225 | Full | `045_MountainClimb:438-449` |
| MC15 | F3: mother, tyke and Perilou; no fight if you show peace | 5226-5229 | Full | `045_MountainClimb:452-484` |
| MC16 | The father yeti comes home with a goat | 5233-5240 | Changed (integration: your Yetot calms him) | `045_MountainClimb:487-507` |
| MC17 | Ruined camp: Astrix frozen, blue boots, Barthoom | 5242-5264 | Full | `045_MountainClimb:512-543` |
| MC18 | Astrix's potion and spellbook | 5241-5247 | Full | `045_MountainClimb:523-525` |
| MC19 | Reunion; four figurines; free rooms | 5256-5262 | Full | `045_MountainClimb:549-581`; `045_TenTowns:187-197` |
| MC20 | Reward even for Garret's body | 5257-5259 | Missing (no death branch) | none |
| MC21 | Perilou gives up adventuring | 5224-5225 | Full | `045_MountainClimb:92-93` |
| BS1 | Bryn Shander: lanterns, double palisade, gates shut in the dark | 1726-1746 | Full | `014:488-489`; `045_TenTowns:111-114` |
| BS2 | Duvessa Shane, honest head of the Council; Gym 2 | 1752-1756 | Changed (owner/genre: Gym) | `014:668-702` |
| BS3 | Sheriff Markham Southwell; 250 militia | 1756-1760 | Full | `045_TenTowns:115-116, 222-233` |
| BS4 | Heraldry (antlers over wheat) | 1761-1763 | Full | `045_TenTowns:111-112` |
| BS5 | Blackiron Blades: Garn's cheap blades and the joke; Elza's gear | 1754-1768 | Full | `045_TenTowns:237-275` |
| BS6 | House of the Morninglord: Mishann; Amaunator vs Lathander | 1770-1786 | Full | `014:315-344`; `045_TenTowns:284-288` |
| BS7 | Copper Knobberknocker; Macreadus at the Black Cabin | 1787-1805 | Full (hook only; cabin not built) | `045_TenTowns:279-305` |
| BS8 | Northlook: Scramsax's credit, interest and blade | 1807-1828 | Full | `045_TenTowns:309-365` |
| BS9 | Ol' Bitey snaps and sings; Kintyre and the Maverick | 1794-1806 | Full | `045_TenTowns:369-388` |
| BS10 | Northlook rumours | 1816-1818 | Full | 2016 |
| BS11 | Overland (Eastway; paths to Good Mead, Targos, Termalaine) | 1767-1786 | Full | Maps 2010, 2030, 2121 |
| BS12 | Lottery the afternoon before the new moon; stripped; rigging alleged | 1040-1049 | Changed (campaign: the crowd refuses Ilda) | `014:527-662`; `017:228-235` |
| FM1 | Hruna, Korux and Storn as written | 1836-1870 | Full | `045_FoamingMugs:75-79` |
| FM2 | Gem-each offer; snowshoes; Korux pays | 1876-1901 | Full | `045_FoamingMugs:80-91` |
| FM3 | Refused, they leave in a huff | 1902-1905 | Full | `045_FoamingMugs:100-105` |
| FM4 | Blizzard: wait or press on | 1918-1933 | Full | `045_FoamingMugs:112-127` |
| FM5 | Oobok's remains; fresh goblin tracks south | 1871-1900 | Full | `045_FoamingMugs:129-134` |
| FM6 | Six goblins, sled, wagon, polar bears, Izobai with hawk and torch, horn, archers | 1902-1940 | Full | `045_FoamingMugs:137-161` |
| FM7 | Truce once they're beaten | 1941-1945 | Full | `045_FoamingMugs:162-169` |
| FM8 | Kindness wins the sled | 1946-1952 | Full | `045_FoamingMugs:213-235` |
| FM9 | Free the bears | 1937-1947 | Full | `045_FoamingMugs:187-211` |
| FM10 | Izobai fires the wagon and flees; her potions, pouch and whistle | 1955-1961, 1948-1951 | Full | `045_FoamingMugs:174-184` |
| FM11 | Delivery; 10% off at Blackiron | 1953-1963 | Full | `045_FoamingMugs:250-269`; `045_TenTowns:237-275` |
| DH1 | Dougan's Hole: tiny, inbred (ears, teeth), buckled pier, keelboats, still shapes on the ice | 3068-3087 | Changed (campaign: the shapes are the hag's victims) | `022:199-226, 418-430` |
| DH2 | Edgra Durmoot, trapper; seldom at the Council | 3094-3100 | Full | `022:436-477`; `045_TenTowns:424` |
| DH3 | Twenty Stones of Thruun | 3125-3137 | Full | `022:200-201`; 2035 E42 |
| DH4 | Chorus of locals ("big as horses", "a king's ransom") | 3183-3202 | Full | `022:203-212` |
| DH5 | Durmoot thinks they're dead and won't help; Gym 3 | 3141-3146 | Changed (genre: Gym) | `022:445-477` |
| DH6 | Sacrifice: warmth | 3111 | Full | `045_TenTowns:139-140` |
| HU1 | Two winter wolves extort for Norsu, an awakened mammoth | 3108-3137 | Full | `045_HoledUp:1-25, 264-269` |
| HU2 | Good wolf, bad wolf (limp, lie, threat, appeal to conscience) | 3148-3196 | Full (skippable: see HU2/B5) | `045_HoledUp:87-140`; 2035 E28 |
| HU3 | Tundra crossing: blizzard, the wolves shield you | 3198-3211 | Full | `045_HoledUp:142-159` |
| HU4 | The starving pack (gaunt) | 3210-3218 | Changed (campaign: Reptin feeds them and is bitten; see B1) | `045_HoledUp:163-199` |
| HU5 | The lodge; "Garagai isn't home"; nudged to L4; the wolves wait outside | 3220-3238 | Full | `045_HoledUp:206-224` |
| HU6 | L2: whale, giant knife, stone chest with scrimshaw goat | 3243-3260 | Full | `022:252-254`; `045_HoledUp:353-358` |
| HU7 | L3: cage; Silja and Finn; heat the slats, pick the lock, oil the hinges | 3262-3272 | Full | `045_HoledUp:400-481` |
| HU8 | L4: icicle corridor stealth | 3276-3291 | Full | `045_HoledUp:237-251` |
| HU9 | L5: Norsu ("You are to blame..."), calming, honouring, charge | 3293-3313 | Full | `045_HoledUp:260-313` |
| HU10 | Ice throne's blizzard rune | 3318-3335 | Full | `045_HoledUp:317-340` |
| HU11 | L6: war room; Holgi, Snorp, Zilbo; the stone chwinga | 3336-3362 | Full | `045_HoledUp:360-378`; `022:255-256` |
| HU12 | L7: Garagai's bedroll | 3368-3378 | Full | `045_HoledUp:36-37` |
| HU13 | L8: whale oil; remorhaz tunnel; thrym | 3318-3335 | Full | `045_HoledUp:342-351`; `022:257-259` |
| HU14 | Sneaking out; wolves attack on the way home; kill one and the other flees | 3336-3352 | Changed (campaign: both flee to the chasm) | `045_HoledUp:486-518` |
| HU15 | Hilda; the boots of the winterlands; she married her brother | 3353-3369 | Full | `045_HoledUp:50-81` |
| EH1 | The Eastway reaches Easthaven | 3438-3444, 1769 | Changed (neither: slide closes it) | `022:143-146` |
| EH2 | Easthaven's own content | 3385-3440 | Missing (town not visited) | `045_TenTowns:423-430` (Danneth only) |
| GM1 | Good Mead: Chultan carvings, wyvern eaves, bees | 4070-4078 | Full | `022:409-411` |
| GM2 | Verbeeg took three casks; Kendrick stabbed | 4081-4093 | Full | `022:147-149, 165-166`; `045_MeadMustFlow:158-169` |
| GM3 | No speaker; two candidates | 4099-4131 | Full | `022:161-164`; `045_MeadMustFlow:620-663` |
| GM4 | Mead hall and its hive room | 4097-4107 | Full | `022:159-160, 177-178, 362-375` |
| GM5 | Shrine of the Flaming Sword; Kendrick's body; how Redwaters got its name | 4138-4155 | Full | `022:167-169, 187` |
| GM6 | Sacrifice: warmth | 4107 | Full | `045_TenTowns:136-138` |
| MM1 | Reward: a tenday's lodging and drink | 4183-4187 | Full | `045_MeadMustFlow:158-169, 610-612` |
| MM2 | Fef Moryn, his traps and the fox for 1 gp | 4176-4199 | Full | `045_MeadMustFlow:172-191` |
| MM3 | Five militia clubbed in the woods | 4185-4198 | Full | `045_MeadMustFlow:196-203` |
| MM4 | Ogre tracks; eight hours | 4203-4209 | Full | `045_MeadMustFlow:205-214, 250` |
| MM5 | Chwinga's snowball; fox and chwinga; charm of animal conjuring | 4211-4235 | Full | `045_MeadMustFlow:217-240` |
| MM6 | V1 three caves; V2 mammoth bones | 4220-4264 | Full | `045_MeadMustFlow:85-88, 247-254` |
| MM7 | V3 bonfire; named livestock (threaten them for a truce); Artin on the spit | 4266-4306 | Full | `045_MeadMustFlow:278-300` |
| MM8 | V4 refuse pit | 4308-4319 | Full | `045_MeadMustFlow:92` |
| MM9 | V5 "Friend" the ogre; six baskets; casks (one empty); treasure | 4295-4302, 4321-4352 | Full | `045_MeadMustFlow:303-375` |
| MM10 | V6 frozen stream | 4304-4318 | Full | `045_MeadMustFlow:93` |
| MM11 | V7 Yogobor; Silvanus under the ice | 4320-4361 | Full | `045_MeadMustFlow:378-419` |
| MM12 | V8 burial niches | 4364-4381 | Full | `045_MeadMustFlow:94-95` |
| MM13 | V9 Duhg; whistles for help | 4356-4360, 4383-4389 | Full | `045_MeadMustFlow:422-441` |
| MM14 | V10 chieftain's tomb; pearl and wand; the curse | 4362-4402 | Full (see B3: the curse outlives Act I) | `045_MeadMustFlow:444-510` |
| MM15 | Gahg arrives; stop her, run or hide; the survivor's revenge | 4404-4438 | Full | `045_MeadMustFlow:513-593`; `:99-100` |
| MM16 | Gahg's basket of nautiloid scrap | 4440-4451 | Full | `045_MeadMustFlow:67-68` |
| MM17 | Casks home; fear the verbeeg will return | 4453-4459, 4394-4397 | Full | `045_MeadMustFlow:598-615` |
| MM18 | Olivessa asks the leader to run; Shandar accuses; asking around town | 4398-4447 | Full | `045_MeadMustFlow:620-663` |
| MM19 | Zhentarim intervention: eight thugs; catch one and he names Naerth | 4445-4456 | Full | `045_MeadMustFlow:666-697` |
| MM20 | Not exposed, Shandar wins and the Zhentarim gain a foothold | 4457-4459 | Full | `045_MeadMustFlow:772-776` |
| MM21 | Olivessa runs regardless | 4111-4131 | Changed (neither: decline means unopposed) | `045_MeadMustFlow:638-643` |
| LW1 | Lonelywood: Sembian founders, chimera crest, loggers and fishers, a refuge for the shady | 4462-4485 | Full | `015:147-149` |
| LW2 | Nimsy Huddle: heated attic, cookies to the Council | 4492-4498 | Full | `015:304-326`; `045_TenTowns:424` |
| LW3 | The Happy Scrimshander: Iriskree, fond of the dead | 4493-4502 | Full | `015:416-439` |
| LW4 | The Lucky Liar: tall tales; Danae Xotal, Thayan spy | 4504-4525 | Full | `015:187-192`; `015:270` |
| LW5 | Ramshackle: DeGrootz "hanged himself" | 4575-4585 | Full | `015:152-153`; `045_WhiteMoose:122-125, 671-672` |
| LW6 | Sacrifice: food on racks a mile out | 4508, 1050-1054 | Full | `045_TenTowns:146-148` |
| LW7 | The two-hour path to Termalaine | 4513-4518 | Full | Map 2020 |
| WM1 | Nimsy's offer (Scoop, cookies, 100/125 gp, Ramshackle, "if our hunters...") | 4553-4594 | Full | `045_WhiteMoose:159-195` |
| WM2 | Tracking: an hour, d6 white moose, ordinary moose | 4596-4617 | Full | `045_WhiteMoose:272-338` |
| WM3 | Forest encounters (banshee, bears, chwingas, fox and hare, wolves) | 4617-4647 | Full | `045_WhiteMoose:370-416` |
| WM4 | The tomb's misdirection ward | 4650-4658 | Full | `045_WhiteMoose:341-347` |
| WM5 | E1/E6: ten statues; topple them to end the ward | 4660-4683, 4823-4827 | Full | `045_WhiteMoose:451-467` |
| WM6 | E2: door opens only from inside | 4703-4710 | Full | `045_WhiteMoose:616-622` |
| WM7 | E3 brazier (twig, cone, feather, hand) and E4 Sahnar, who smells of pumpkin spice | 4712-4748 | Full | `045_WhiteMoose:470-520` |
| WM8 | E5 moon dial and its inscriptions | 4750-4804 | Full | `045_WhiteMoose:523-568` |
| WM9 | Watch, and the moose comes out; or fight it in E6 among the sleeping beasts | 4645-4652, 4806-4822 | Full | `045_WhiteMoose:574-604` |
| WM10 | E7 Mirror of the Full Moon (seven questions; moose attuned) | 4829-4840, 4773-4784 | Full (see B7) | `045_WhiteMoose:625-681` |
| WM11 | E8 the first half-moon tomb (bow, arrowheads, cup) | 4786-4850 | Full | `045_WhiteMoose:684-695` |
| WM12 | E9 Ravisin, her shrub, Vurnis, the potions | 4852-4893 | Full | `045_WhiteMoose:698-744` |
| WM13 | Proof; if Ravisin lives, more awakened beasts | 4895-4905 | Full | `045_WhiteMoose:197-229, 430-437` |
| TM1 | Termalaine: Calishite carvings; the north wind | 5268-5290 | Full | `045_Termalaine:192-199` |
| TM2 | Oarus Masthew; Shaelen; the close election; a disloyal militia | 5296-5303 | Full | `045_Termalaine:106-115, 216-243` |
| TM3 | Heraldry (fish swallowing a tourmaline) | 5306-5309 | Full | `045_Termalaine:95` |
| TM4 | The Blue Clam: Vernon; rumours | 5296-5313 | Full | `045_Termalaine:116-119`; 2122 |
| TM5 | The Eastside: Marta, Clyde, the song, the ring of warmth | 5315-5394 | Full | `045_Termalaine:245-287` |
| TM6 | Sacrifice: warmth | 5310 | Full | `045_TenTowns:433` |
| BM1 | Darmo Mazlu on his box | 5352-5401 | Full | `045_Termalaine:202-213` |
| BM2 | Oarus's 50 gp; the militia refusal he hides; Naerth's officers | 5418-5449 | Full | `045_Termalaine:113-115, 223-243` |
| BM3 | Entrance: "Kobolds only!" in fine hand | 5452-5469 | Full | `045_Termalaine:124-125` |
| BM4 | M1 tools and tracks | 5430-5449 | Full | `045_Termalaine:126-127` |
| BM5 | M2/M8/M13 mining table; geodes | 5464-5480, 5693-5707 | Full | `045_Termalaine:293-323` |
| BM6 | M3 river cavern and giant rats | 5482-5504 | Full | `045_Termalaine:326-332` |
| BM7 | M4 the little stone dog | 5506-5524 | Full | `045_Termalaine:335-341` |
| BM8 | M5 saboteurs Scorp and Thwip | 5526-5558 | Full | `045_Termalaine:344-365` |
| BM9 | M6/M7 bucket lift and landing tracks | 5539-5576 | Full | `045_Termalaine:368-381` |
| BM10 | M8 the grell stalks a lone member | 5561-5590 | Compressed (backing away costs nothing) | `045_Termalaine:384-400` |
| BM11 | M9 Grek and Smol flee when hurt; a captured kobold talks | 5593-5609, 5411-5422 | Full | `045_Termalaine:403-426` |
| BM12 | M10 the bucket shuttle | 5610-5641 | Full | `045_Termalaine:430-447` |
| BM13 | M11 Trex, Vott and Zurk; his proposition; Insight | 5583-5626 | Full | `045_Termalaine:450-484` |
| BM14 | Janth's ghost; destroy the satchel to free him | 5627-5655 | Full | `045_Termalaine:486-518, 588-601` |
| BM15 | M12 mind flayer skull; psi crystal | 5657-5691 | Full | `045_Termalaine:521-532` |
| BM16 | Return: payment; Oarus possessed; Oarus killed and the mine closed for good; kobolds given jobs | 5679-5708 | Compressed + bug (see BM16/B6) | `045_Termalaine:541-606` |

Per-source counts are in section 1.
