The dialogue feels disjointed less because of what is said than because of who seems to say it, and when. In most scenes the speakers aren't on the map. When a Herald's tag isn't found, `say()` drops the line into the bubble of whoever you talked to, so Naerth appears to say "Sephek" and then answer himself. Under that, the chapter tables (648 rows across parts 00-15) keep finding the same faults:
- lines that answer something nobody said;
- Herald-mode thoughts that other people answer;
- big lines that nobody answers;
- names and facts used before the player has them;
- clock and compass slips;
- the same joke or box twice;
- Alberica's pet names everywhere, including in grief and in Reptin's mouth;
- pronouns that point at nobody;
- about 1,600 boxes over the 90-character limit.

Most lines are in voice. Fix the staging and these habits, and the story reads as one piece.

## Why it feels disjointed

Counts are rows in the chapter notes' dialogue tables, unless a line says otherwise. A row can show two faults. Rule references are to docs/WRITING_GUIDE.md.

### 1. The speaker isn't there, or the line comes out of someone else

**About 1,150 boxes in the eight parts that counted them:**
- 02: 39 of 70 spoken boxes
- 04: about 100
- 05: 102 off-stage boxes
- 06: about 400 lines
- 07: 145 absent, plus 25 on the wrong sprite
- 08: about 200
- 09: 72 of 85
- 12: 65 of 71

Parts 01, 03, 10, 11, 13, 14 and 15 report the same problem without a total. This is the biggest single cause of the "disjointed" feeling. A reply that comes out of the wrong mouth reads as nonsense, even when the words are right.

- 1.05: "SHIMMER: Sephek." plays in Naerth's bubble, and then "NAERTH: ...You know his name. Interesting." (007_Story.rb:344).
- 1.04: "REPTIN: (setting the medallion down very gently) Of course. So sorry. Is the floor also cursed?" appears to come from Epheris (017_TargosExtras.rb:66).
- 15.24: "Archivist Eirwen Solglass is waiting, barefoot on the polished root floor." Then she speaks seven boxes with no sprite on the map (026_Rootspire.rb:1026).

**Rule:** §9a, "Everyone who speaks is on screen" (checklist 41). Fall back to the talked-to event in `say()` only when the tag matches that event's name (007_Story.rb:26-30).

### 2. Lines that answer something nobody said

**17 rows.**

- 2.07: "ALBERICA: ...Something's pulling me north. Don't make a thing of it." / "ALERION: You're not fine." Nobody said "fine" (014_Chapter2.rb:625-626).
- 0.03: "TAMSIN: Yes, it's always first light. That's not the point. The point is POKÉMON." Nobody raised it (030_Prologue.rb:134).
- 15.24: "EIRWEN: The Canticle. Yes. The oldest case is unlocked." Nobody has asked her (048_Rootspire_H_Faithful.rb:288).

**Rule:** §4, "Every line is said for something". Read each box aloud with the one before it (§2.7). In Herald mode, a line that someone replies to must be in both the loud and the quiet option (§5).

### 3. Thoughts that get answered

**6 rows** (four in 03, one each in 05 and 11), plus the three that WRITING_GUIDE §12 already lists.

- 3.19: "ALBERICA: A laughing hag who wants our jewellery. I've dated worse." In Herald mode this is a thought, and Alerion answers it (015_Chapter3.rb:715).
- 3.08: "ALBERICA: Shade. Look at me. We go together. Nobody goes alone." A thought, addressed to Shade (015_Chapter3.rb:409).
- 11.01, the other way round: "MEAT MEAT: Meat Meat is making a thing of it." It answers words that only the Herald-mode quiet option says (037_Chapter11.rb:74).

**Rule:** §5, "A line another character answers is spoken, not thought": use `speak()` (checklist 16).

### 4. Big lines nobody answers

**16 rows.** A Herald hears their dead sister named, or the villain's face, or a cruelty, and the next box moves on.

- 4.22: Thredra names Shimmer ("She already carried a door."), and Shade says nothing (022_Chapter4.rb:554).
- 9.07: Avarice's face shows in the glass. The only line after it is "MEAT MEAT: No.", and nobody says she's alive (035_Chapter9.rb:396).
- 12.08: "AVARICE: (to Wyn) Little shadow. You'd make a lovely lens." She talks for nine boxes, and not one Herald answers (047c_WhiteVault.rb:322).
- 10.22: "KETHAN: Reprimanded. The post is yours, Rootwarden, if you want it." Wyn, the accused, never replies (036_Chapter10.rb:1150).

**Rule:** Voices house rule 3 and §3: "one reacts to another Herald, not to the plot". §6: choices are "acknowledged afterwards".

### 5. Names and facts used before the player has them

**About 50 rows**, the largest group after length.

- 2.10: "MISHANN: There you are. I've been looking for your wolf-friend since the draw." Reptin's bite doesn't happen until Chapter 4 (014_Chapter2.rb:699).
- 6.04: "KELYN: Growth, Memory, Balance. Reptin's legacy, Alberica's line, Glimmer's faith." Shade hasn't become Glimmer yet (024_Chapter6.rb:619).
- 7B.34: "You've seen that sigil. Etched in the glass half of the door at the bottom of Hew's last ladder." In this order, you haven't (046_DeepLabyrinth.rb:863).
- 8.11: "You can see her from the rail. White hair. Red-gold eyes." Avarice is wearing Var. Nobody has seen this face (046_ForgeRooms.rb:124).

**Rule:**
- §8: "At most one new proper noun per beat, explained the first time it appears".
- §6: "Every line that refers to a past event checks that event's flag."
- §9a rule 1: introduce before you use.

### 6. Clock, calendar and compass slips

**About 35 rows.**

- 2.05: "In the square, a board lists every name in town. Tomorrow is the new moon." The next box is "GUARD: Draw's at sundown." (014_Chapter2.rb:490-491).
- 2.01: "GOAL: Follow the road south-east to Bryn Shander." The road, and the screen, go north (014_Chapter2.rb:386).
- 7B.09: "ALERION: Six. We've done two." You've done one (046_DeepLabyrinth.rb:168).
- 15.32: "That night, for the first time in thirty years, Rootspire's dawn shifts: gold, then the faintest hint of green." No night passes, and the next dawn doesn't show it (048_Rootspire_D_Quests.rb:659).

**Rule:** §3 already asks for a purpose comment at the top of each scene function. Add the scene's time and place to it, and every cut "establishes where and when" (§9). Use one age for the summer everywhere: thirty years (15 E15).
