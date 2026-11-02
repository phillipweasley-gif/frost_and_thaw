# Final audit C: rootspire.md Tab 2 (lines 3809-7088): downtime week, session log, Truth of the Forge, festival, GM outline, Chapter 3 "The Rootsun Forge"

## How this was checked

**Source.** I read every line of 3809-7088 in chunks of about 300 lines.

**Game files read in full:**
- `034_Chapter8.rb`: Barricade, kitchen, pens, Autumn, Dragonforge, Heart Chamber, coat, launch
- `046_ForgeRooms.rb`: A2-A37 room by room
- `048_Rootspire_F_Downtime.rb`: every downtime day, the festival pieces, Eirwen's audience

**Game files read in part:**
- `024_Chapter6.rb:340-523`: Hellen's rest, `FESTIVAL_NIGHT`, `scene_festival_night`, `council_summons`
- `048_Rootspire_E_Nights.rb:158-291`: `hearth_night`, `investigation_night`, `scorch_marks`, `TAVERN_RUMOURS`
- `029_Glimmer.rb`
- `035_Chapter9.rb`: the hand-off at 1-67 and 245-262

**Builders read in full:**
- `tools/build_ch8.rb`
- `tools/build_ch8_deep.rb`

**Placements spot-checked:**
- `build_ch6.rb`: scorch event (133), Nivva (107), festival autorun (99)
- `build_ch6b.rb`: Eirwen (157), Lorn Scribe (158), Alerion's desk (163), twin orb / Lumin (124-127)
- `build_rootspire_life.rb`: Arvik (165), Nivva's annex stand (147)

**Reachability.**
- The compiled event lists in `build/maps/Map2072-2076, 2146-2155.json` match the builders.
- `ruby tools/reach.rb` on all 15 Forge maps reports "everything reachable".
- Every fusion ID used in the Forge files is at most NB_POKEMON (576).

**Switch and flag chains I traced:**
- festival (`rs_day >= 7`) -> Hearth night -> `investigation_night` -> SW_SCORCH -> `scorch_marks` -> `chardalyn_found` -> `eirwen_audience` -> `council_summons` -> `ch7_started` / SW 3937. This chain is mandatory: `ch7_started` is set only there.
- Inside the Forge:
  - passphrase or A6 lever -> SW_BARRICADE_OPEN
  - golems -> SW_GOLEMS
  - Rootwatch trainers -> Rootbreaker -> SW_ROOTWATCH / SW_SAPLIFT
  - root-keep trainers -> SW_L3_GATE
  - devil-priest -> SW_FORGE_CLEARED -> the stair
  - mechs -> SW_MECHS
  - Antechapel -> SW_ANTECHAPEL
  - Heart autorun -> opening -> mechs -> circle -> `avarice_fight` -> `scene_better_fire` -> `scene_coat_falls` -> `scene_launch` -> Veins

I compared against the previous audits only after finishing my own pass. Most of the earlier re-audit's bugs are now fixed:
- the festival is tied to the seventh day;
- downtime is gated on `!barricade_entered`;
- the mission has moved into the summons;
- there are now three rust-feasters;
- Kord has his own lines;
- Bram now gives his name;
- the dagger continuity is fixed;
- Frostina is restless and Glimmer hears the hammers;
- Eirwen's passage line is fixed;
- Thredra has her ember eye;
- the dragon strains a little more with every spire you work.

The findings below are new, or still open.

---

## 1. Summary

| Rating | Count |
|---|---|
| Full | 95 |
| Compressed | 3 |
| Changed | 7 (4 owner decisions or integration choices; 3 small adaptations) |
| Missing | 0 |
| Unreachable | 0 |
| **Total story rows** | **105** |
| Bugs / contradictions (separate list) | 10 (none high; 2 medium-low) |

**Honest judgement.** This slice is faithfully and fully in the game.

- **Every Forge area is present.** All 37 Areas are there, each checked one by one. Each sits on a placed event with its read-aloud mostly word for word, and every gate between them can be opened.
- **Every downtime day is playable.** Glimmer's seven-day rite, Reptin's six days with Arvik, Alerion's six library days and the potions, Meat Meat's four mornings and Alberica's Codex and rumours are all reachable scenes in the source order.
- **The festival beats and all seven GM-outline steps are in.** They now run in a forced, correct order between the festival and the descent.
- **The changes are the expected ones.** Avarice wears Var. She fakes her death. The boss fight moves into the Heart Chamber. These follow owner decisions or the Tab 1/3 Heartroot integration, and none of them betrays the source.

What's left is small:
- one real logic bug: you can clear the vantage towers and still get shot from them;
- a few lines that contradict the map layout or the fake death;
- some voice and duplication slips;
- some foreshadowing flags that nothing reads.

I found nothing missing and nothing unreachable.

---

## 2. Every row that is not Full, ranked by importance

### Bugs and contradictions

**B1. Beating the vantage-tower guards doesn't stop their bolts in the boss fight.** (Medium-low; a logic bug)
- **Source:** 6420-6433 (A25: "Guards attempt to rain bolts onto intruders in Area 26. Removing them makes fight safer.")
- **Evidence:**
  - `vantage_cleared` is set only in `vantage_east`, i.e. only if the player also *examines* the "Bolt-slits" event after beating Grik and Nall (`046_ForgeRooms.rb:613-627`; the event is at `build_ch8_deep.rb:224`, map 2151 (28,3)).
  - `heart_lair_actions` checks only that flag (`034_Chapter8.rb:499-505`).
  - So a player who beats both guards but never touches the slits still takes "red-hot bolts ... from the vantage towers" every time.
  - That contradicts Nall's own lose line, "No more bolts" (`046:125`), and the captain's hint "Clear them" (`046:705`).
- **Fix:** In `heart_lair_actions`, treat the towers as cleared when both trainers are beaten. On compiled map 2151 they are events 4 and 5 (Grik (26,5), Nall (30,5)):
  ```ruby
  cleared = flag?(:vantage_cleared) || ($game_self_switches[[2151, 4, "A"]] && $game_self_switches[[2151, 5, "A"]])
  ```
  Or set `:vantage_cleared` from the trainers' after-battle.

**B2. Avarice's parting promise is heard by everyone, then nobody doubts her death.** (Medium-low; a contradiction inside an owner-decision scene)
- **Source:** 6753-6757 (the whisper); owner decision: she fakes her death, and Ch10 runs on everyone believing it.
- **Evidence:**
  - `034_Chapter8.rb:799-800`: "From inside the fire, her voice ... We will speak again in the White Womb, little failures."
  - Then `:804-808`: the body, Alerion's "Dead. Nothing in her", Alberica's "She doesn't get to come back from that", and Meat Meat's "...Good."
  - No one so much as mentions that she has just promised to come back.
- **Fix:** Pick one.
  - Have someone dismiss it: Reptin, "Last words. She always did want the last word."
  - Or move the whisper into the fogging splinter at `:818`, so only the player hears it: "On the floor, a last splinter of the hag's mirror fogs once ... and, very faintly: 'We will speak again in the White Womb.'"

**B3. A tower guard says you can see Avarice over the forge, but she is never there.** (Low-medium)
- **Source:** 6449-6457 (Avarice stands openly in A26 with the dragon behind her). In the game she is instead at the engine in the Heart Chamber (2076), in Var's body.
- **Evidence:**
  - `046_ForgeRooms.rb:124`, Grik: "You can see her from the rail. White hair. Red-gold eyes."
  - `:80`: "You can SEE HER. I don't look."
  - The balcony overlooks the Dragonforge, 2075 (`vantage_west`, `046:595-598`). Avarice never appears there, and she doesn't show white hair until Var's face cracks in 2076 (`034:442`).
- **Fix:**
  - Grik's after-text: "From the rail you can see what she built. She comes down to look at it sometimes. White hair, red-gold eyes. I told you I don't look."
  - Grik's lose text: "You can see IT. I don't look."

**B4. Where is the engine? It hangs over the dragon on one map and over the silver pool on another.** (Low)
- **Evidence:**
  - `034_Chapter8.rb:385`, 2075: "Chained among them ... a dragon. ... Above it hangs the engine, a cage of chardalyn and roots."
  - `034:436`, 2076, reached by stair, sanctum (2152) and Antechapel (2153): "Over the pool hangs the engine."
  - The launch then says the engine's pulse runs "down" into the chains (`:832`). That part works if the engine is above.
- **Fix:** In `scene_dragonforge`, say: "High above, the dragon's chains run up through a shaft in the roof, toward the Heart, and a red-blue glow beats at the top of it: the engine."

**B5. Alerion's Day-5 note sends you to the wrong Nivva.** (Low)
- **Evidence:**
  - `048_Rootspire_F_Downtime.rb:208`: "DAY 5. RUN & BLOOM. SIX POTIONS. (Nivva Sunwick, Trunk-Tier.)"
  - The potions fire only at the Run & Bloom annex stand: `nivva_shop`, `048_B:121-124`, placed `build_rootspire_life.rb:147`, map 2181 in the Verdant Halls.
  - The Nivva in the Trunk-Tier market (`build_ch6.rb:107` -> `FT.nivva`, `026_Rootspire.rb:712-715`) only opens a shop.
  - So two Nivvas exist at once, and the one you'd find first does nothing.
- **Fix:** Pick one.
  - Call `(alerion_potions || alerion_held_potions)` from `nivva` too.
  - Or change the note to "(Nivva Sunwick, Run & Bloom, in the Verdant Halls.)"

**B6. Reptin calls someone "darling".** (Low; voice)
- **Evidence:** `046_ForgeRooms.rb:578`: `cl(:reptin, "Evidence, darling. The Council likes evidence. Wrap it in something.")`. "Darling" is Alberica's tic everywhere else.
- **Fix:** Give the line to Alberica, or drop "darling".

**B7. The festival toast and the Summer Throne each happen twice in a row.** (Low)
- **Evidence:**
  - `024_Chapter6.rb:451-452`: "the Summer Throne ... empty, and scorched black." / "KELYN: (raising a glass) Heralds of Dawn and Dusk. Tonight, Rootspire remembers."
  - Then straight away, `festival_toast` (`048_F:666-671`): "KELYN: (raising a chalice of glowing sap) Four hundred years..." and "Beside the empty Summer Throne, the golden vines are dry..."
- **Fix:** Delete the two lines at `024:451-452`, and open `festival_toast` with "KELYN: (raising a chalice of glowing sap) Heralds of Dawn and Dusk. Tonight, Rootspire remembers. Four hundred years have cracked like ice behind us..."

**B8. "Xardorok said you'd come. The failures always return." is still said twice.** (Low)
- **Source:** 5904 (said once, in A3).
- **Evidence:**
  - `scene_barricade`, `034_Chapter8.rb:146`, at the 2072 entry autorun;
  - Ruk's intro in A3, `046_ForgeRooms.rb:87`, in 2146.
- **Fix:** Keep the line in Ruk's intro (A3 proper). In `scene_barricade`, use something else: "DUERGAR: Topsiders. She said. She always says."

**B9. A condition that can never be true.** (Trivial)
- **Evidence:** `034_Chapter8.rb:185` checks `flag?(:heard_passphrase)`, but no file sets it. Harmless: the ledger and Hild still teach the words.
- **Fix:** Delete it, or set it when a beaten Barricade duergar repeats the phrase.

**B10. Foreshadowing that nothing reads.** (Low; check against later tabs)
- **Evidence:** These flags are set and never read anywhere:
  - `:golden_key_tunnels` and `:winter_returns_leaf` (`048_F:322-323`): Alerion's golden key in a frost-sealed door, and "Winter returns through those who do not fear the cold";
  - `:alerion_misbelief` (`:303`);
  - `:chardalyn_vision` (`:452`);
  - `:dragon_warriors_read` (`:247`).
- **Assessment:** Not a fault against this slice, since the source only foreshadows here. The Dragon Warriors pay off in Ch9 (the Dragoons), and the chardalyn vision pays off in Glimmer's "I'd know the fire" at `034:389`. The golden key and the misbelief have no follow-up anywhere. Whoever audits the later tabs should confirm whether the source pays them off.
- **Also:** the header comment at `046_ForgeRooms.rb:7-9` still says the Ledger of Corruption is under the floorboard. The code correctly leaves only a note (`:217-226`, as the fix-round decision says). The stale comment is cosmetic.

### Changed (ranked)

**C1. A26: the Dragonforge proper and the boss are split across two maps, and Avarice is in Var's body.** (Owner decision + integration with the Heartroot's H23/H24; sound)
- **Source:** 6437-6514, and 5707 ("openly appearing in her own pale, infernal-touched form").
- **Game:**
  - 2075 `scene_dragonforge` (`034:374-393`): the heat wall, the cathedral womb, the molten sap, the mechanical arms, the Twenty Stones, the altar as a "holy wound", the chained dragon.
  - 2076 `scene_heart_chamber` (`034:431-488`): the engine "refusing to die"; Var turns and cracks; white hair, sigils and red-gold eyes; "my little failures"; the full A26 dialogue; the Xardorok alias.
  - The combat features are all there: lair actions (`:492-507`), two Rootbreaker mechs in round two (`:478-486`), and the dragon straining with every spire you work (`:555-561`).
- **Lost:** "She wears no disguise", and the dragon thrashing *behind her*. Both are owner-decision consequences.
- **Fix:** None needed, apart from B3 and B4.

**C2. Avarice's escape becomes the faked death.** (Owner decision)
- **Source:** 6737-6757, 6904-6908.
- **Game** (`034:793-824`):
  - Hell's Veil, the red-black pillar and the parting whisper are kept.
  - Changed: the cracked mirror *refuses* her, and a decoy body is left. A careful player can catch the lie: the Vessel IX clue, the bare arms, the fogging splinter.
- **Fix:** Implemented correctly, apart from B2.

**C3. The Summer Marshal is "he", not "she".** (Owner decision: Var's story restored)
- **Source:** 5596 ("she has not returned").
- **Game:** `048_F:691-692` ("He has not returned"). This is consistent with Var Rime-Breaker at `024:586` and the Heart Chamber at `034:438`.
- **Fix:** None.

**C4. Finding the Forge: the sealed passage becomes the Chapter 7 roads to the door of iron and glass.** (Integration; sound)
- **Source:** 5753-5759.
- **Game:** Eirwen's audience (`048_F:707-709`) now says the passage "runs from under the Root-Gate down past the Guild Dig ... ends at a door. Iron and glass." `council_summons` gives two ways down (`024:514`), and the Forge entrance is that door (`034:48`, `build_ch8.rb:5-6`).
- **Fix:** None.

**C5. The festival is held in the market, at the Festival Circle by the Hall's steps.** (Low adaptation)
- **Source:** 5792 ("The Council Hall of Seasons pulses with gold, green, white, and red").
- **Game:** `048_F:658`, transfer to 2050 (`024:350`). Every beat survives: effigies, honour guard, mural, chalice, the throne, the shudder, the aurora pulse.
- **Fix:** None. Optional: a line that the Hall's four crystals glow through its open doors.

**C6. Glimmer Day 4: the horn.** (Low adaptation; follows the Shade -> Glimmer owner decision)
- **Source:** 3881 (his horn falls off, and a new one grows in, fixed for good).
- **Game:** `048_F:384-385`: the unicorn horn Brightmane gave back, which he has carried since the Rift (`029:102`), sets itself to his brow and grows in.
- **Fix:** None. The end result is the same.

**C7. Glimmer's rite place names.** (Trivial)
- **Source:** 3829, 3889, 3941 (the Artisan Promenade, the chapel arch, Brightmane's Chapel).
- **Game:**
  - The Lightfall Promenade (`048_F:361`, the game's existing district, `048_A:43`).
  - The rite is begun and resumed at Lumin's twin orb (`026:891-893`), though the text still names the chapel arch and the chapel.
- **Fix:** None.

### Compressed (ranked)

**P1. A3, the Duergar Guardhold: nine duergar become five.** (Low)
- **Source:** 5896-5915.
- **Game:**
  - Ruk and Varn fight in the guardhold (`build_ch8_deep.rb:86-87`); Kord, Brask and Hild fight at the Barricade (`build_ch8.rb:42-44`).
  - The sap-pool and the rune-etched armour are described (`046:127-128`).
  - The "enthralled by sigils" reveal is carried by Varn's "The runes on my arms are cooling" and Ruk's "We've never seen him. We've only seen her."
- **Lost:** The numbers only.

**P2. A18, the Root-Keep Gate on Level 2: no room text.** (Low)
- **Source:** 6245-6257 ("Burning sap rivers run beneath a root-bridge ... Four duergar take aim from alcoves ... crossbows glowing red-hot").
- **Game:**
  - The four trainers Hrem, Vosh, Dagna and Turl are on the far bank of a bridge over the sap (`build_ch8_deep.rb:161-171`; `046:72-75, 92-95, 116-119`).
  - The scene comes only through their lines: "Loose! Over the sap!", "The bolts were red-hot", "The sap below us boils".
- **Lost:** The read-aloud. There's no boiling-sap hazard on the bridge.
- **Fix:** Add a one-time step trigger at the bridge's west end (2149, (35,22)) that plays the read-aloud.

**P3. Meat Meat's Day-4 combat bonuses become two held items.** (Low; mostly game mechanics)
- **Source:** 4956-4994 (+1 initiative, advantage on stealth, "First Cut, True Cut", Emotional Centering).
- **Game:** `048_F:539-549`. The drills and the "the fear sits down beside her" centering beat are there. "First cut, true cut" is said in the text, and she receives a Quick Claw and a Razor Claw.
- **Lost:** Nothing story-bearing.

**Sequencing note (not rated).** The festival waits for `rs_day >= 7` (`024:372-376`). Glimmer can only start his six-day rite after he joins at the Rift, though, so his "Day 7, the Brightmane Acceptance" can land after the "end of Day 7" festival. It is still reachable until `barricade_entered` (`048_F:27`). That's acceptable, but if he joins late the source order is lost. Optional fix: let Lumin run two rite days per sun while the festival is still to come.

### Integration choices touching this slice
- **Razzy's first scale in Avarice's root-vault** (`046:772`). This is exactly the source's A37 relic (6705): faithful.
- **Darrus or Maera Vell at the Forge** (`034:313-321`). Autumn's fall isn't in this slice. Maera's "crowning robes scorched" ties neatly to Alberica's rumour 5 (5362-5366; `048_E:281`), which is a nice touch, not a betrayal.
- **Thredra as Mother Thruuna** (A8 at `034:220-258`; A35 at `046:725-738`). It uses the established hag. The A8 text names her "Mother Thruuna" (`034:230`), and the secret is paid off in the boss fight and the coat-fall. Sound.

---

## 3. Full table

Status key: F = Full, C = Changed, P = Compressed. File references are `file:line` in `game/Data/Scripts/998_FrostThaw/` unless they name a tool.

### Downtime week and the session log (3809-5396)
| # | Source element (lines) | Status | Game evidence |
|---|---|---|---|
| 1 | Glimmer Day 2, the Severance of Frost (3819-3837) | F | 048_F:352-368 (via Lumin, 026:893; twin orb placed build_ch6b:124-127) |
| 2 | Glimmer Day 3, the Dawn Ember (3841-3859) | F | 048_F:370-377 |
| 3 | Glimmer Day 4, the Suncall; the horn (3863-3881) | C (C6) | 048_F:379-387 |
| 4 | Glimmer Day 5, the Litany of the Mane; the pendant (3885-3905) | F | 048_F:389-401, FT_MANEBRAID |
| 5 | Glimmer Day 6, the Dawnstride (3913-3933) | F | 048_F:403-410 |
| 6 | Glimmer Day 7, the Brightmane Acceptance (3937-3959) | F | 048_F:412-431 |
| 7 | Brightmane's three questions and answers; the "Chard...alyn" vision (3963-4001) | F | 048_F:433-456 |
| 8 | Reptin Day 2, Pulse-Listening; the black eye (4009-4031) | F | 048_F:81-103, 38-45 (Arvik placed build_rootspire_life:165) |
| 9 | Reptin Day 3, the Split Dock gauntlet; renewed faith (4035-4059) | F | 048_F:105-118 |
| 10 | Reptin Day 4, Aurora-Climb; the moonbeam (4063-4085) | F | 048_F:120-131 |
| 11 | Reptin Day 5, the Quiet Step (4089-4107) | F | 048_F:133-146 |
| 12 | Reptin Day 6, ambushes; he teaches spell-concentration (4115-4139) | F | 048_F:148-160 |
| 13 | Reptin Day 7, the Silent Circuit; the wild-shape healing; the Loop-Band and its meaning (4143-4199) | F | 048_F:162-190 |
| 14 | Alerion Day 2, early history; no Twenty Stones in the books (4211-4229) | F | 048_F:213-224 (desk placed build_ch6b:163) |
| 15 | Alerion Day 3, the timestream fracture; remembered across centuries (4233-4251) | F | 048_F:226-236 |
| 16 | Alerion Day 4, wyrmlings; guides; Dragon Warriors (4255-4285) | F | 048_F:238-249 |
| 17 | Alerion Day 5, six potions from Nivva (4289-4473) | F | 048_F:252-291 (see B5) |
| 18 | Alerion Day 6, the Dale before Auril (4481-4497) | F | 048_F:293-298 |
| 19 | Alerion Day 7, the possibility leaves; the visions; the golden key; the tunnels under Dugan's Hole (4501-4533) | F | 048_F:308-332 (see B10) |
| 20 | Alerion's nat-1 misbelief about the seasons (4537) | F | 048_F:299-304 (moved to Day 6) |
| 21 | Meat Meat Day 2, Razzilith's warning about Summer (4543-4619) | F | 048_F:476-489 |
| 22 | Meat Meat Day 2, the first flight; "the first rider" (4625-4681) | F | 048_F:490-505 |
| 23 | The undercity walk: Echo Gate, warm planks, stalker, infernal ore (Jorik), shadow, Still Sky Shrine, "the missing ones", the follower (4685-4919) | F | 048_F:507-536 |
| 24 | Rumours: blue lights, the silent warden, forged decrees (4923-4951) | F | 048_F:542-546 |
| 25 | Meat Meat's four bonuses (4956-4994) | P (P3) | 048_F:547-549 |
| 26 | The summer-growth imbalance: 8 signs and the takeaway (4998-5146) | F | 048_F:553-566 |
| 27 | Heightened Summer-Sense (5150-5156) | F | 048_F:567-576 (used in 048_H) |
| 28 | Alberica wakes: "Remember..." (5160-5180) | F | 048_F:46-55 |
| 29 | The Memory Codex: four fragments; starving (5184-5322) | F | 048_F:583-639 (Lorn Scribe placed build_ch6b:158) |
| 30 | Alberica's seven tavern rumours (5326-5382) | F | 048_F:641-651; 048_E:276-284 |
| 31 | Session log 11/25, the narrative recap (5388-5396) | F | covered by rows 1-30; Glasswater glimmers at 048_H:74 |

### The Truth of the Forge and the dungeon layout (5398-5541)
| # | Source element | Status | Game evidence |
|---|---|---|---|
| 32 | The Forge is beneath Rootspire in Dougan's Hole: the hag's lair, the 20 Stones, where the Reversal began; a "holy wound" (5398-5478) | F | 034:379-384; 046:504-508 |
| 33 | The duergar tunnelled into the hag-warrens; Avarice slaughtered their leaders (5454-5456) | F | 046:262-264 (the traitor) |
| 34 | The dragon is bound to the 20 Stones circle (5458) | F | 034:383-384, 832; build_ch8:109-119 |
| 35 | Level 1: the sap-flow lift; Grandolpha becomes a hag echo (5484-5492) | F | 046:365-382; 034:220-258 |
| 36 | Level 2: rot, runes, mirror shards, memory pools, the Stones' remnants (5495-5511) | F | 046:170-183, 299-306, 735 |
| 37 | Level 3: sap-wells, the altar core, the root-basin, sigils in the tree's memory (5513-5541) | F | 034:379-385; 046:408-423 |
| 38 | Avarice present as "Xardorok" in her own form (5516, 5707) | C (C1) | 034:438-449; 046:111 |

### The end-of-Day-7 celebration (5545-5639) and the pre-delve ceremony (5784-5822)
| # | Source element | Status | Game evidence |
|---|---|---|---|
| 39 | Read-aloud: lanterns, rootwood pipes, children, honour guard, the shifting mural (5560-5564) | F | 048_F:656-664 |
| 40 | Kelyn: "Heralds of Dawn and Dusk... Rootspire remembers"; "Four hundred years..." (5566-5567, 5798-5800) | F | 024:452; 048_F:666-669 (see B7) |
| 41 | The Summer Throne: dry vines, a charred strand, warm sap, Solglass watching (5573-5584, 5804-5806) | F | 048_F:670-671 |
| 42 | Glimmer's shard flares; Razzy stiffens and growls at the roots (5585-5589, 5808-5810) | F | 048_F:683-688 |
| 43 | Eirwen: "Something burns beneath us... the Summer Marshal... has not returned" (5593-5596) | C (C3) | 048_F:690-692 |
| 44 | Stormbranch: "The tree dreams of fire" (5598-5601) | F | 024:466 (said to everyone, not only to Reptin) |
| 45 | Lirielle: "someone trying to rewrite the season" (5603-5606) | F | 048_F:693 |
| 46 | The shudder; Alberica's threads; Meat Meat and Razzy know the forge (5612-5625) | F | 024:456-465; 048_F:686-687 |
| 47 | The aurora's mechanical pulse; the cheering resumes; the heroes know better (5627-5639, 5812-5822) | F | 024:460-461, 473 |
| 48 | The ceremony in the Council Hall of Seasons; the twin-wyrmling effigies (5792-5794) | C (C5) | 048_F:658-659 |

### The GM outline (5643-5684)
| # | Source element | Status | Game evidence |
|---|---|---|---|
| 49 | Step 1: Rootwardens at the door; a patrol missing at the Echo Gate | F | 048_E:196-205 (mandatory, after the festival) |
| 50 | Step 2: warm scorch marks; a metallic, infernal smell | F | 048_E:223-229 (placed build_ch6:133, SW 4174) |
| 51 | Step 3: a chardalyn fragment with infernal sigils, linked to Avarice | F | 048_E:227-231 |
| 52 | Step 4: Eirwen's private audience; the maps; the Stones beneath; the humming sealed passage | F | 048_F:699-713 (via `eirwen`, 048_D:572) |
| 53 | Step 5: Razzilith claws the floor; he senses the dragon, the heart, "the woman who hurt him" | F | 048_E:206-211 (with Meat Meat in the party) |
| 54 | Step 6: the Verdant Council's formal summons | F | 048_F:716-719 -> 024:508-523 |
| 55 | Step 7: the mission: descend, the hag lair, the Summer Marshal, stop the burning | F | 024:511-514 |

### Chapter 3: The Rootsun Forge (5689-7088)
| # | Source element | Status | Game evidence |
|---|---|---|---|
| 56 | Running This Chapter: Avarice's goal (seasons, Ten-Towns, souls, Auril, the Hells) | F | 034:449-453 |
| 57 | Finding the Forge hooks: the trembling, hot sap, Razzy and Frostina restless, Glimmer hears hammering | F | 048_E:206-217; 024:461-462 |
| 58 | A sealed passage opens onto the entrance (5753-5759) | C (C4) | 048_F:707-708; 034:48 |
| 59 | A1 Rootgate: read-aloud; Knock / the A6 lever / "Rimebound. Rise unbroken." | F | 034:142-145, 179-215; 046:275-290 |
| 60 | A2 Echo Hall | F | 046:167-183; 2146 (17,16), (20,14) |
| 61 | A3 Duergar Guardhold | P (P1) | 2146 Ruk and Varn; 046:87-88, 111-112, 127 |
| 62 | A4 the flight-path root model | F | 034:87-90, 147-148; payoff 035:252-256 |
| 63 | A5 Avarice's quarters: the mural, the journal ("Raz-MKIII", "Alberica", "Fire must replace the rime"), the effigy trap | F | 046:186-240; 2146 (20,3), (23,5), (21,7) |
| 64 | A6 the traitor and the lever; the Great Unchaining | F | 046:243-290; 2146 (32,15), (35,18) |
| 65 | A7 the root archives | F | 046:130-132; 2146 (31,4) |
| 66 | A8 Mother Thruuna's dining hall: the echo; "Burn her forge" and the secret | F | 034:220-258; 2073 (12,8), (12,4) |
| 67 | Level 2 introduction | F | 046:295-306 |
| 68 | A9 the Deep Root Shaft: ribs, webbing, the thump | F | 046:133-135, 299-303; 2147 |
| 69 | A10 the guest quarters: the dragon limb, "the goblin sample failed" | F | 046:326-344; 2147 (30,21), (26,25) |
| 70 | A11 the Warden's bunker: the lagging mirror, "Don't let her take the heart" | F | 046:309-323; 2147 (18,18) |
| 71 | A12 the training hall: sap golems, heat haze | F | 046:347-362; 2148 |
| 72 | A13 the sap-lift: Root, Deep, Forge | F | 046:365-382; 2072 (28,15), 2148 (28,11), 2150 (34,15) |
| 73 | A14 the Rootwatch: 3 duergar and the Infernal Rootbreaker (its molten-sap burst) | F | 046:385-405; 2148 |
| 74 | A15 the sap-gate controls: "once a winter altar; someone is rewriting it" | F | 046:408-423; 2148 (30,21) |
| 75 | A16 the Umbound Chasm: the blind, root-burrowed umber hulk; the duergar flee invisible | F | 046:426-444; 2149 |
| 76 | A17 the rust-feast tunnels: iron-laced roots from the blood-rites | F | 046:138-139, 447-454; 2149 |
| 77 | A18 the root-keep gate over boiling sap: 4 crossbow duergar | P (P2) | 2149 trainers; 046:72-75 |
| 78 | Level 3 introduction: "a womb of iron, flame, and frost" | F | 046:499-509; 2150 autorun |
| 79 | A19 the Root-Throne: the quaggoth, the myconid "let me die", its spores animating the constructs | F | 046:512-549; 2150 |
| 80 | A20 the broken root-works: the terrified duergar, "Even the roots obey her" | F | 046:552-561 |
| 81 | A21 heart-fuel: frostfire flasks, the touch hazard | F | 046:564-579 (see B6) |
| 82 | A22 the root-shaft elevator and its Rootbreaker | F | 046:385-405 (merged with the sap-lift's Forge stop) |
| 83 | A23 the root-keep gate: 4 fearful crossbowmen, the molten sap river | F | 046:76-79, 98-101, 582-591; 2150 |
| 84 | A24 the west vantage: first sight of the dragon; Razzy reacts | F | 046:594-611; 2151 (13,3) |
| 85 | A25 the east vantage: the bolts on the boss fight | F (bug B1) | 046:614-628; 034:499-505 |
| 86 | A26 the Dragonforge proper: read-aloud, Avarice, "My little failures", the boss | C (C1) | 034:374-393, 431-488 |
| 87 | Avarice's dialogue: "You survived my early prototypes..." | F | 034:444-445 |
| 88 | Combat features: lair actions, mechs in round 2, the dragon straining | F | 034:478-507, 555-561 |
| 89 | A27 the rootbeast pens: failed prototypes for Razzy | F | 046:459-474; 2074 (10,17) |
| 90 | A28 the prison root-cocoons: the Rootwarden's plea | F | 046:476-494; 2074 |
| 91 | A29 the mind-flayer corpse | F | 046:631-639; 2151 (16,17) |
| 92 | A30 the lower elevator | F | 046:642-646; 2151 (28,18) |
| 93 | A31 the false priest: a barbed devil, serves willingly, flees if outnumbered | F | 034:395-418; 2075 (26,6) |
| 94 | A32 the mirror-hall trap: "She will take your heart"; root-thorns | F | 046:659-672; 2152 |
| 95 | A33 the duergar barracks: "Fire replaces frost" | F | 046:675-690 |
| 96 | A34 the tortured captain: hints; dies unless healed | F | 046:693-722 |
| 97 | A35 Mother Thruuna's residual chamber: the lore of the 20 Stones and the mirror rites | F | 046:725-738 |
| 98 | A36 the rootbound mech guards | F | 046:741-748; 2152 |
| 99 | A37 the root-vault: the journal, the loot, the broken frost-mirror, the charred note about Meat Meat, Razzy's scale, the frozen rose | F | 046:751-813; 2152 |
| 100 | The dragon launch sequence and its read-aloud | F | 034:829-860 |
| 101 | Avarice's escape: Hell's Veil, "We will speak again in the White Womb" | C (C2) | 034:793-824 (see B2) |
| 102 | The story traits in her stat block: tiefling; Sigils of Domination; Hell's Veil | F | 048_F:485; 046:111, 260, 555; 034:798 |
| 103 | How the dragon is built: Razzy and Meat Meat techniques, a stolen corrupted heart, mirror-glass, her sigils, the Ten-Towns soul-harvest | F | 046:610; 034:835, 383, 450-451 |
| 104 | Reactions: Razzy panics, Meat Meat rages, Alerion's frostcraft, Alberica's threads, Glimmer's shard, Reptin's spike | F | 034:837-851; Glimmer's at A24 (046:606-608), since he dies before the launch (owner decision) |
| 105 | The hand-off into Chapter 4, Destruction's Light | F | 046:1094-1101 -> 035:1-67 |

**Cross-slice note (outside this slice, trivial):** in Ch9, `035_Chapter9.rb:250` calls the dragon "a black dragon with burning gold eyes". The A4 model (`034:88`) and the source (5927) give it hell-red eyes. Pick one.
