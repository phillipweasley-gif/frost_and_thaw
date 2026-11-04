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

### 7. Lines that contradict what the player saw

**About 40 rows.**

- 5.07: "The mother stops, shaking. She looks at the swaddling." The swaddling hasn't been found yet (023_Chapter5.rb:341).
- 5.07: "Alberica sings the lullaby from Bryn Shander's square. No jokes in it. Not one." She never sang there (023_Chapter5.rb:339).
- 8.23: "AVARICE: We will speak again in the White Womb, little failures." She says she'll be back, and then everyone treats her as dead (034_Chapter8.rb:800).
- 12.08: "AVARICE: (to Reptin) Your wolf howled at your birth. I heard it. I hear everything said in my laboratories." Reptin was bitten in Act I, and never in her labs (047c_WhiteVault.rb:321).

**Rule:** §1, "Sources of truth, in order", with the Story Bible above the scripts. §6: check the flag of any event a line refers to.

### 8. The same line or joke twice

**About 40 rows.**

- 6.05: "ALBERICA: Never pay for a drink again. Hellen, marry me." / "REPTIN: She's like that with everyone, Hellen. It's a compliment and a warning." The coffee scene in 6.23 then plays the same joke with Wyn, word for word (026_Rootspire.rb:782-783).
- Ch 9 has three in one chapter: "OLIVESSA: You! The honey-cake people!" (035_Chapter9.rb:275), "WIDOW: You! The Spheal people!" (035_Chapter9.rb:422), and Duvessa's "Where have you...".
- 8.02: "RUK: Xardorok said you'd come. The failures always return." This is the Barricade duergar's line, word for word (046_ForgeRooms.rb:87).
- 12.02-12.04: the three relic scenes play the same boxes three times (047c_WhiteVault.rb:219-224).

**Rule:** §6, "A scene can't fire twice, unless it's written to be heard twice." §4: signature tics at most once per beat.

### 9. Speech hidden in narration, and narration inside speech

**14 rows.** Spoken words with no tag get no bubble, and a stage direction inside a speech box reads as the speaker narrating.

- 7A.09: "Yarro comes padding down the root-tunnel with his jars, out of breath. "The lake! Don't let it scar!"" (032_Chapter7A.rb:413).
- 8.24: "MEAT MEAT: RAZZY! (Far above, Razzilith panics: a picture in all your heads of every scale on end, and then pure rage.)" (034_Chapter8.rb:838).
- Targos, the trapper: "There's a killer loose in the Dale. Walks through blizzards in his shirtsleeves." This comes untagged after three TRAPPER boxes (006_Dialogue.rb:84).

**Rule:** §2.4 and §2.6: stage directions go "in parentheses at the start of a line, lower case, short". Every spoken line carries its speaker's tag, so the bubble can find them (§9a).

### 10. Pronouns that point at nobody, or at the wrong person

**About 30 rows.**

- Auril as an unnamed "she":
    - "SHIMMER: Saltmarsh. A job. A stone in a box. I opened the box, and she came in." (015_Chapter3.rb:449)
    - "THREDRA: She wants a new coat to wear, you see." (022_Chapter4.rb:557)
    - "ALERION: (flat, wrong) ...Turn back. She's right. Let it burn." (035_Chapter9.rb:304)
- Wyn as "she", against canon:
    - "Wyn sees black water under the docks, and a colony with eyes, whispering her name." (046_ForgeRooms.rb:1046-1047)
    - "KETHAN: Whatever she did or didn't do at that door, she's going north for us now." (047d_FixRound.rb:804)
- One pronoun for every Herald: "#{name} throws themself flat and grabs your wrist." (044_ChasmFaithful.rb:310)
- **One fix in the notes goes the wrong way.** Part 06 marks "They don't say anything. Yet." (024_Chapter6.rb:330) as wrong and rewrites it to "She doesn't say anything. Yet." But Tamsin is "they" in the Story Bible ("Pronouns: they"). The "She" two boxes earlier is Hellen (024_Chapter6.rb:323). Keep the line as it is. Part 12 E23 does find a real slip: act3_script.md gives Tamsin "her".

**Rule:**
- §1: "Pronouns and names" (Shade, Wyn, Tamsin and Eirwen are they/them).
- Name the person the first time they're referred to in a scene.
- §5: Herald-mode narration is in the second person. §12 counts about 65 `as()` lines to check.

### 11. Lines that forget who the player is

**8 rows** (in parts 06, 07 and 15). In New Journey you're a Rootspire kid, not a Herald, and you remember none of their past.

- 15.29: "HALDEN: Ready! Sit, sit. A small reset. Back to your origin. Targos, four hundred years ago. You'll hardly notice." (048_Rootspire_C_Folk.rb:580).
- 15.29: "Torches. Faces you remember, younger than you remember them. Speaker Duvessa on the steps, her voice cracking." (048_Rootspire_D_Quests.rb:606).
- 7A.S: "The council is divided. Everyone looks at the Heralds." (047a_Undercanopy.rb:383).

**Rule:** §5, "Scenes must read correctly in Journey mode and as every Herald who can be present" (checklist 14).

### 12. Voice drift: pet names, and jokes after grief

The guide's §12 counts Alberica's pet names: "darling" about 59 times, "sweetheart" about 45, "sugar" about 13. **11 rows** flag them where they hurt:
- in grief (3.14, 6.08, 8.22, 13.12);
- given to Reptin (7B.01, 7B.16, 7B.17, 8.10, 15.26);
- flirting with a child, Tamsin (6.01).

**4 more rows** are jokes straight after a loss (3.17, 4.19, 8.22, 8.27). The Voices section below has the details.

**Rule:**
- §4: "Alberica's pet names in particular: at most one per scene, and not in grief."
- §3: "No joke right after grief, except one line from a character whose way of coping is joking (Alberica)."

### 13. One sentence split over two boxes

**20 rows.** The logs count 7 in part 07 and 9 in part 08.

- 5.08: "Beside a half-chewed skeleton, too long in the arm to be human, with claws on its fingers: a tattered backpack. Inside, a healing draught, still intact," The sentence then runs on into the next box (023_Chapter5.rb:394).
- 8.19: "AVARICE: A season that never ends has a god's worth of power in it. Mine. And when my dragon flies, / AVARICE: Ten-Towns melts, ..." (034_Chapter8.rb:450-451).

**Rule:** §2.1, "Never split one sentence across two boxes."

## Voices

Every main voice is recognisable most of the time, measured against voices.md. Drift clusters in three places:
- Alberica's pet names;
- silence from the Herald a moment belongs to;
- villains who don't make their case (WRITING_GUIDE §4, "Villains make a case").

| Character | Sounds right | Drifts | One rewrite |
| --- | --- | --- | --- |
| Alberica | Ch 9: "ALBERICA: (softly) Pretty boy. You're glowing." / "ALERION: I know." Warm, then plain when it matters. | Pet names in grief: "ALBERICA: (very quiet) No, sweetheart. Memory's for remembering." (039_Chapter13.rb:244) and "ALBERICA: Darling, whatever we do, we do it together." (034_Chapter8.rb:699). Flirting with a child, against voices.md's "loud, embarrassing big sister": "Hello, gorgeous." to Tamsin (024_Chapter6.rb:281). | "ALBERICA: (very quiet) No. Memory's for remembering." (13.12, 039_Chapter13.rb:244) |
| Reptin | Ch 9: "REPTIN: (hands up, smiling) Let's all be very reasonable. Especially the people with spears." / "REPTIN: ...Well. Congratulations on the new job titles. I assume there's no pay." | Takes Alberica's pet names: "REPTIN: We know, darling. You told us." (033_Chapter7B.rb:113), "Evidence, darling." (046_ForgeRooms.rb:578), "Everything here is under the Hearth, darling." (048_Rootspire_C_Folk.rb:435). Part 12's own rewrite adds "Then hear this, darling. No." (047c_WhiteVault.rb:321): drop the "darling" there too. Silent at Shimmer's loss (§12). | "REPTIN: (stepping between the girl and her mother) Behind me. Now." (7B.16, 033_Chapter7B.rb:318). This is voices.md's own "(a child in danger)" line. |
| Alerion | Ch 9: "REPTIN: ...I assume there's no pay." / "ALERION: I didn't apply." and "ALERION: She's right. He was a coat." Flat, literal, one devastating line. | Doesn't answer the literal question: to "Is that thing yours?" he says "ALERION: It's coming here. It always meant to come here." (035_Chapter9.rb:356). On the rope he volunteers to go first, then anchors the near end (044_ChasmFaithful.rb:269). | "ALERION: No. It's coming here. It always meant to." (9.07, 035_Chapter9.rb:356) |
| Meat Meat | Ch 9: "MEAT MEAT: Var was a coat! A coat!" and "MEAT MEAT: (delighted) He is warm. Inside Meat Meat. Like coffee." Third person, short, exact feelings. | Jokes straight after a death: "MEAT MEAT: Razzy is jealous. Look. Razzy's egg is sulking." (015_Chapter3.rb:675) and "MEAT MEAT: Meat Meat votes stab. Meat Meat always votes stab. ...Meat Meat will listen, this once." (034_Chapter8.rb:700). She rates Good Mead three bees in one place and four in another (022_Chapter4.rb:338). | "MEAT MEAT: (quietly) Meat Meat wants to stab it. ...Meat Meat will listen. For him." (8.22, 034_Chapter8.rb:700) |
| Wyn | Ch 9: "WYN: (cupping a dazed bee in both hands) ...You're all right. You're all right, little one." Easier with creatures than people. | Missing where their one brave line belongs: silent at the tribunal (§12), silent as the accused (036_Chapter10.rb:1150), no answer to Avarice's "Little shadow. You'd make a lovely lens." (047c_WhiteVault.rb:322). The same box three times in a row in 10.30 (047b_TrialWeek.rb:362). Called "her" (046_ForgeRooms.rb:1046-1047). | Add, after Avarice's line: "WYN: (very quietly) No. You'll stop." (12.08, 047c_WhiteVault.rb:322). It's voices.md's sample line, saved for this. |
| Shade (they), then Glimmer (he) | Shade, 1.03: "SHADE: Smuggling is a kind of shipping." Glimmer warms the same wry voice. | Shade is silent at the two moments that are theirs: when Thredra names Shimmer (022_Chapter4.rb:554), and when Frostina is revealed to carry Shimmer's eyes (026_Rootspire.rb:910). Glimmer stacks two beats in a 138-character box: "GLIMMER: (a hand on his chest, head cocked) Something under us is burning. ...And hammering. Deep in the roots. Can none of you hear that?" (024_Chapter6.rb:462). | Shade, after "She already carried a door.": "SHADE: (very quiet) Her name was Shimmer. You'll say it right next time." (4.22, 022_Chapter4.rb:554). Glimmer: "GLIMMER: (a hand on his chest) Something under us is burning." / "GLIMMER: And hammering. Deep in the roots. Can't you hear it?" (6.22, 024_Chapter6.rb:462) |
| Shimmer | 1.03: "SHIMMER: Smuggling." / "SHIMMER: Don't." Dry, says the true thing sideways. | So sideways that the spine fact is lost: "I opened the box, and she came in." (015_Chapter3.rb:449). "SHIMMER: Then that's where it is." has nothing for "it" to point at (017_TargosExtras.rb:77). People later call it "her song", but the player never hears her hum it. | "SHIMMER: Saltmarsh. A job. A stone in a box. I opened it, and the Frostmaiden came in." (3.02, 015_Chapter3.rb:449) |
| Tamsin (they) | 0.09: "TAMSIN: ...Best of three. Later." Fast and competitive, like Hop. | Never calls you by your full name, even at the farewell (038_Chapter12.rb:75). Answers nobody: "TAMSIN: Yes, it's always first light." (030_Prologue.rb:134). Contradicts themself: "I don't care that you were gone for months. You were gone an HOUR." (026_Rootspire.rb:729). | "TAMSIN: (cloak on crooked, planting their feet) Hold it. HOLD it, [Name]!" (12.13, 038_Chapter12.rb:75) |
| Hellen | 6.02: "HELLEN: Sit. All of you. Eat. You've snow in your hair that fell four hundred years ago." Feeds you before she lets you talk. | Her warmest prologue lines can never play: the prologue is on rails from the College to the fall (00 E7). She's at the Hearth in 11.01 with no line (11 E20). Uses digits in speech: "6 more nights, love." (024_Chapter6.rb:358). | At the mural: "HELLEN: (to your Pokémon) And you. Here's a crust. Everyone eats in my house." (0.11, 00 E7) |
| Avarice | 12.10: "AVARICE: (very small, very far) The Frostmaiden is a variable too, my failures. I'll see you at her throne." Smiling, and everything is arithmetic. | No case: "AVARICE: He likes his meals warm. I'll be the one who serves them." (034_Chapter8.rb:453). Undoes her own faked death (034_Chapter8.rb:800). Nine boxes in a row in 12.08 that nobody answers, one of them against canon (047c_WhiteVault.rb:321). | "AVARICE: The Frostmaiden wants the world still. I want it running. On my schedule. Forever." (8.19, 034_Chapter8.rb:453) |
| Auril | 13.16: "AURIL: (to you, almost fond) You answered me politely once. In a little shrine, under the Forge." The collector who loves you like a vase. | Off screen for her whole throne scene (13 E3). "AURIL: You broke my tests." assumes you won all four (039_Chapter13.rb:413). "You've seen them. Every sign." has no "them" to point at (037_Chapter11.rb:61). | "AURIL: You've seen my signs. Frost on his shadow. Vines on her breath. Your throat, cold." (11.01, 037_Chapter11.rb:61) |
| Sephek | Ch 11: "I'm sorry. I'm taking her home." Cold, lonely, quietly sorry. | No case at the Moon Temple: "SEPHEK: Give me the heart, and the Frostmaiden forgets your names." (015_Chapter3.rb:547). His turn hangs on a riddle: "SEPHEK: (looking at Frostina) Her silence honours her. Not her return." (039_Chapter13.rb:351). | "SEPHEK: That heart is hers. Give it back, and the Frostmaiden forgets your names." (3.14, 015_Chapter3.rb:547) |
| Thredra | 5.02: "THREDRA: I smell the wolf among you. Oh, child, are you cold? Come warm yourself by Granny's fire... heehee." Grandmotherly menace (cut it to fit the box). | Asks you to break her own power, with no reason given: "THREDRA: Break my mirrors, dearies." (022_Chapter4.rb:563). Repeats her Ch 4 lines in Ch 5: "Let's dance upon the glass" (023_Chapter5.rb:866), "if you can bear to look" (023_Chapter5.rb:882). | "THREDRA: Useless, the both of them. Fine. Granny will do it herself." (5.22, 023_Chapter5.rb:866) |

## The rewrites that matter most

These are the 40 rewrites that fix the story's sense, its continuity or its spine, chosen from the 648 rows in the chapter notes. The lines are quoted as the notes give them; " / " separates boxes. Every other rewrite (voice, polish, length) is in the chapter's own notes and tab.

| Part | Scene | Line as is | Rewrite | Why | file:line |
| --- | --- | --- | --- | --- | --- |
| 00 | 0.01 | Four hundred years ago, a winter that would not end gripped Icewind Dale... | Four hundred years ago, a winter that would not end gripped Icewind Dale. / Five strangers stood against it. Rootspire calls them the Heralds of Dawn and Dusk. | The game's first sentence trails off. Nothing says who stood against the winter. | 005_NewGame.rb:75 |
| 00 | 0.11 | TAMSIN: Look. Every festival I check if it moved. | TAMSIN: Look. The Heralds. Every festival I check if the little one moved. | The one picture of the Heralds never says it's them. | 030_Prologue.rb:410 |
| 00 | 0.13 | (none) | Add after Tamsin's line: The crack pulls at you like a door in a gale. You fall into the glass. | The fall is never said or shown, so Chapter 1 makes no sense. | 030_Prologue.rb:476 |
| 01 | 1.01 | You land on frozen planks. Snow, everywhere. The sky has no sun in it at all. | You land on frozen planks. Snow, everywhere, and no sun in the sky at all. / Targos, in the Icewind Dale of Hellen's stories. Four hundred years before you were born. | Nothing says where or when you landed. | 007_Story.rb:152 |
| 01 | 1.04 | GOAL: Find who's calling us. South-east. First, Naerth's seal to get out of Targos. | GOAL: Get Speaker Naerth's seal to leave Targos. He does business at the Luskan Arms. | Sends you to the wrong building for the next step. | 017_TargosExtras.rb:80 |
| 01 | 1.05 | NAERTH: Each new moon, Targos draws a name. So do Bryn Shander and Easthaven. Whoever's drawn walks out onto the tundra. | NAERTH: Each new moon, Targos draws a name. So do Bryn Shander and Easthaven. / NAERTH: Whoever's drawn walks out onto the tundra. A gift for Auril, the winter goddess. | The lottery is the act's engine, and the line never says it's an offering to Auril. | 007_Story.rb:341 |
| 02 | 2.01 | GOAL: Follow the road south-east to Bryn Shander. | GOAL: Follow the road north through the pines to Bryn Shander. | The goal contradicts the road on screen. | 014_Chapter2.rb:386 |
| 02 | 2.07 | ALBERICA: ...Something's pulling me north. Don't make a thing of it. / ALERION: You're not fine. | ALBERICA: ...I'm fine. Something's pulling me north. Don't make a thing of it. | Alerion answers a "fine" nobody said. | 014_Chapter2.rb:625-626 |
| 02 | 2.10 | MISHANN: There you are. I've been looking for your wolf-friend since the draw. I had a feeling. | MISHANN: There you are. I've looked for your druid since the draw. I had a feeling. | Refers to Reptin's bite two chapters early. | 014_Chapter2.rb:699 |
| 03 | 3.02 | SHIMMER: Saltmarsh. A job. A stone in a box. I opened the box, and she came in. | SHIMMER: Saltmarsh. A job. A stone in a box. I opened it, and the Frostmaiden came in. | The death's cause, Auril, is never named in the scene. | 015_Chapter3.rb:449 |
| 03 | 3.08 | You're back in the attic. Alberica's pendant is gone. ... | You're back by Nimsy's hearth. Alberica's pendant is gone. The rune on her chest isn't. | Names a room the player was never in. | 015_Chapter3.rb:406 |
| 03 | 3.11 | JET SENTRY: And the man who took her waits at our Moon Temple for it. | JET SENTRY: Our Warren lies under the Moon Temple. Zenith can keep the heart from him. / JET SENTRY: But the man who took her is waiting at the door. | The goal sends you to the enemy with no reason. | 015_Chapter3.rb:524 |
| 04 | 4.22 | THREDRA: She wants a new coat to wear, you see. I'm only her seamstress. | THREDRA: Auril wants a new coat to wear, you see. I'm only her seamstress. | "She" is never named; the hag's whole motive is lost. | 022_Chapter4.rb:557 |
| 04 | 4.22 | THREDRA: Break my mirrors, dearies. If you can bear to look in them. | THREDRA: Each mirror holds one of them out on the ice. Break one, if you can bear to look. | The villain asks you to undo her, and nobody says why you'd want to. | 022_Chapter4.rb:563 |
| 05 | 5.07 | The mother stops, shaking. She looks at the swaddling. | The mother stops, shaking. She looks at her mate's clenched hand. | The yeti reacts to something nobody has found yet. | 023_Chapter5.rb:341 |
| 05 | 5.20 | *(a reaction to Kanan)* | REPTIN: (very quietly) Kanan. So this is where you ran. | A guide from Ch 4 stands beside the hag, and no one knows him. | 044_ChasmFaithful.rb:921 |
| 06 | 6.04 | KELYN: Growth, Memory, Balance. Reptin's legacy, Alberica's line, Glimmer's faith. We were founded on you three. | KELYN: Growth, Memory, Balance. Reptin's, Alberica's, and the one the songs call Glimmer. / KELYN: Rootspire was founded on what you left behind. | Names Glimmer before Shade becomes him; "you three" said to five. | 024_Chapter6.rb:619 |
| 06 | 6.10 | TAMSIN: I don't care that you were gone for months. You were gone an HOUR. | TAMSIN: I don't care if it was months for you. For me it was an HOUR. | Contradicts itself in one breath, on the game's time rule. | 026_Rootspire.rb:729 |
| 06 | 6.02 | REPTIN: (very quietly) Anduin is out there. | REPTIN: (very quietly) My husband's out there. Anduin. | Reptin's husband is named and never explained. | 024_Chapter6.rb:337 |
| 07 | 7B.34 | You've seen that sigil. Etched in the glass half of the door at the bottom of Hew's last ladder. | That sigil. The same one is etched in the glass of Hew's door. | Points at a sigil the player hasn't seen. | 046_DeepLabyrinth.rb:863 |
| 07 | 7B.12 | SELRAE: She has a vault. Far north, under the glacier, where the goddess keeps what she can't bear to look at. | SELRAE: Avarice keeps a vault, far north under the glacier. / SELRAE: Where the goddess hides what she can't bear to look at. | "She" could be Avarice or Auril, on the act's main hook. | 033_Chapter7B.rb:474 |
| 08 | 8.01 | DUERGAR: Xardorok said you'd come. The failures always return. | DUERGAR: The Forge-Mistress said you'd come. The failures always return. | The first line of the chapter is an unexplained name. | 034_Chapter8.rb:146 |
| 08 | 8.23 | AVARICE: We will speak again in the White Womb, little failures. | AVARICE: (inside the fire, not laughing now) No. Not like th— | Undoes the faked death that Act III depends on. | 034_Chapter8.rb:800 |
| 08 | 8.11 | You can see her from the rail. White hair. Red-gold eyes. I told you I don't look. | You can see the Marshal from the rail. Big man. Never blinks. I told you I don't look. | Describes a face nobody has seen. | 046_ForgeRooms.rb:124 |
| 09 | 9.07 | REPTIN: (not able to move) ...Anduin. | REPTIN: (not able to move) ...Anduin. My husband. | The player never learns who Anduin is. | 035_Chapter9.rb:364 |
| 09 | 9.07 | MEAT MEAT: No. | Add: "ALERION: That was her face." / "ALBERICA: (very quietly) Mirrors keep things, pretty boy." | The villain's face appears and nobody says she's alive. | 035_Chapter9.rb:396 |
| 09 | 9.10 | KELYN: (arriving, white-faced) I can't stop this. The city saw the summer die. | KELYN: (arriving, white-faced) The city saw its Marshal fall. Not what was inside him. | Doesn't answer "Var was a coat!", so the arrest makes no sense. | 035_Chapter9.rb:474 |
| 10 | 10.42 | KELYN: ...was the death of a man feeding children to a fire. The sentence is commuted. She's free. | KELYN: ...was the death of a man feeding children to a fire. Not guilty. She's free. | No sentence was passed. "Commuted" means reduced, not freed. | 036_Chapter10.rb:1828 |
| 10 | 10.15 | During the first hearing, a hooded figure pushes through the crowd in the gallery. | Footsteps on the cell stair. A hooded figure pushes past the sleeping guard. | Describes a hearing and a gallery while you stand at the cells. | 036_Chapter10.rb:855 |
| 11 | 11.01 | ALBERICA: (hoarse) She's coming. No. She's already here. → MEAT MEAT: Meat Meat is making a thing of it. | ALBERICA: (hoarse) She's coming. No. She's already here. Don't make a thing of it. | Meat Meat answers words only the Herald-mode option says. | 037_Chapter11.rb:74 |
| 11 | 11.05 | SEPHEK: (almost sorry) Not here. Not in her garden. Here I come back. | SEPHEK: (almost sorry) Not while her relics stand under this tree. Here, I come back. | Gives the wrong reason he keeps getting up; the relics are the real one. | 047c_WhiteVault.rb:197 |
| 12 | 12.08 | AVARICE: You watched a coat burn, Alberica. Did you think I only had one? | AVARICE: You watched a borrowed body burn, Alberica. Did you think I only had one? | "Coat" leans on a Ch 8 metaphor a player won't hold. | 047c_WhiteVault.rb:315 |
| 12 | 12.08 | AVARICE: (to Reptin) Your wolf howled at your birth. I heard it. I hear everything said in my laboratories. | AVARICE: (to Reptin) And the wolf. I heard it bite, through a puddle. I hear everything. → add REPTIN: (smiling, very thin) Then hear this. No. (part 12 wrote "Then hear this, darling."; the pet name is dropped here, per voices.md) | Contradicts canon, and nobody answers it. | 047c_WhiteVault.rb:321 |
| 13 | 13.15 | ALERION: She told you there was a third way. You heard her. | ALERION: Shimmer told you there was a third way. You heard her. | "She" follows a line about Auril, but means Shimmer. | 039_Chapter13.rb:336 |
| 13 | 13.15 | SEPHEK: (looking at Frostina) Her silence honours her. Not her return. | SEPHEK: (looking at Frostina) I thought keeping her still honoured Shimmer. It doesn't. | The villain's turn hangs on a line nobody can parse. | 039_Chapter13.rb:351 |
| 13 | 13.23 | Five travellers and a stranger are about to come in out of the cold. | Five travellers and a stranger are about to come in out of the cold. / The stranger is you. | Leaves the game's last reveal for the player to guess. | 039_Chapter13.rb:689 |
| 14 | 14.03 rumour 9 | In Targos, a band of adventurers set off up Kelvin's Cairn, hunting Oyaminartok. / She's a goliath who turns into a polar bear. Hurry, you might catch them up! | In Targos, Keegan Velryn's man led some adventurers up Kelvin's Cairn. / Days ago. His dog came back alone. Keegan's beside himself. | The one quest in town, and it names nobody you can find. | 045_TenTowns.rb:77-78 |
| 14 | 14.04-2, walked in | A handsome man in his thirties opens the door. The dog races past him inside. | (without Boy) A man sits by the fire, a cup of cider going cold in his hands. / KEEGAN: My husband's dog came home without him. He won't stop running the streets. | Describes a door and a dog that aren't there. | 045_MountainClimb.rb:177 |
| 15 | 15.24 Eirwen | EIRWEN: The Canticle. Yes. The oldest case is unlocked. What's left of the verses is on crystal leaves, scattered through three centuries of catalogue. | EIRWEN: You found her key. Then you'll want the Canticle's verses. They're scattered through the leaves. / EIRWEN: How do you want to look? | Answers a question nobody asked, at the start of the part's biggest quest chain; 150 characters. | 048_Rootspire_H_Faithful.rb:288 |
| 15 | 15.35, echoed in Ch 10 | EIRWEN: (very still) I've kept it twelve years. I never knew who to show it to. | (published) EIRWEN: It's on the open shelves already. The court can read it there. / (sealed or Council) EIRWEN: It's sealed. For the court, I'll break the seal. | Ignores what the player decided about the ledger in part 15; "twelve years" for a ledger 400 years old. | 036_Chapter10.rb:777 |

The rest of each part's rewrites are in its own tab (00 Prologue to 15 Side: Rootspire quests and townsfolk).

**Over-length boxes:** about 1,600 boxes run over the ~90-character limit across the game. These are the per-part counts the notes give. The parts counted in different ways, some from the played log and some from the code, so treat the total as approximate.

- 00: 10
- 01: 34
- 02: 68
- 03: about 82
- 04: 41
- 05: 136
- 06: about 300
- 07: 171
- 08: 181
- 09: at least 28
- 10: 128
- 11: 21
- 12: 32
- 13: at least 21
- 14: 340
- 15: no total given; its table flags 5

Each chapter's notes list its long boxes, most of them with the split.
