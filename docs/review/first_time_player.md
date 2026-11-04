From a newcomer's seat, Frost & Thaw is a good story told as if I already knew it. The prologue never says who the Heralds are or that the lantern sends me four hundred years back. From Targos on, most of the talk comes from people who aren't on the screen, using names nobody has explained: Auril, Avarice, Frostina and Razzilith arrive in the version menu before I've even picked my name. The sixteen parts' notes ask 266 newcomer questions, and nine kinds of question cover almost all of them, so a handful of game-wide habits would clear most of the confusion.

## The questions a newcomer asks, all game

Counts are the chapter notes' own first-time-player questions (266 across parts 00-15). Some questions fit two themes, so the counts add up to more than 266.

### 1. "Who's talking? Why can't I see what the words describe?"

**19 questions in 11 parts.** The editor notes find the cause in every part, 00-15: the speakers aren't on the map.

- Ch 1, the pier: "ALERION: You fell out of the air." is the first line anyone says to you, and nobody is on screen. The player asks: "Who's talking? I'm alone on a pier."
- Ch 1, the Luskan Arms: "SHIMMER: Sephek." plays in Naerth's bubble. Then Naerth answers "...You know his name. Interesting.", so he seems to be talking to himself.
- Ch 2: "What goblin? I didn't see anything." Razzy never appears on the road.
- Ch 6: "Who's talking? I can see one person and five voices."
- Ch 9 and 12: "Am I flying? Why am I still standing on the leaves?" / "Am I flying? I'm standing in a tree." The flights are told in text over a map that doesn't change.
- Ch 14: "Why does the text say the dog tackled me? I walked up to it."

**Fix, game-wide:** one party helper (`Stage.herald` / `Stage.party`) at the start of every spine scene, so the travelling Heralds stand round you. Stop `say()` from putting an unmatched speaker's line in the bubble of whoever you talked to (007_Story.rb:26-30). After that, if the narration says someone moves, the sprite moves (WRITING_GUIDE §9a).

### 2. "Who are these people?"

**52 questions, in every part.** Eight of them are "Who is 'she'?" (or "he", or "him"), where the pronoun has nothing to point at.

- Ch 1: "Who is Alerion? Who's 'pretty boy'? Who are these people?" The Heralds' names arrive as speaker tags, with no name and role on first sight.
- Ch 3: "Who is 'she'? What's Saltmarsh?" Shimmer's confession, "I opened the box, and she came in.", never names Auril.
- Ch 4 and 5: "Who's Kanan?" He's named before you meet him. Two chapters later he stands beside the hag and nobody recognises him.
- Ch 6 and 9: "Who's Anduin?" "REPTIN: (very quietly) Anduin is out there." Nobody ever says he's Reptin's husband.
- Ch 7: "Who is Luna, Talion, Lirielle, Thredra, Darrus Fell, Naerth, Kelyn?" Each is named once, mid-line, as if you know them.
- Ch 15: "Who is 'she'? 'The hag's girl'? 'The Mirror Mother'? 'The lady at the forge'?" Avarice goes by six names before anyone says who she is.

**Fix, game-wide:** the first time anyone appears, one line gives their name and role (§9a rule 1). When they come back chapters later, add a three-word reminder ("Luna Carver, the Wennen seer"). Auril is never just "she" until the scene has named her.

### 3. "Where am I, and when?"

**11 questions in 8 parts** (00, 01, 03, 04, 05, 06, 09, 11). There are only three time jumps in the story, and every one of them confuses.

- Prologue to Ch 1: the screen goes white on "TAMSIN: What are you..." and Chapter 1 opens "You land on frozen planks." Nothing says you fell into the glass, that this is Targos, or that it's four hundred years earlier.
- Ch 3: "Where am I? Is this a dream? What attic?" The vision panel shows a cathedral under "a stone circle in the birches". Then "You're back in the attic." But you were never in an attic.
- Ch 5 to 6: "What just happened? Where am I? What's the Verdant Reversal?" Then, in Ch 6: "Where am I, and why is it four hundred years later?"
- Ch 9: "What's the Rime, and how has it only been a month?"
- Ch 4: "why is it suddenly night outside the gym?"

**Fix, game-wide:** every cut, vision and time skip opens on one plain where-and-when line (§9, "Every cut or vision establishes where and when"). The time rule is said once in Ch 6, "HELLEN: An hour for her. Four hundred years for the city.", and said again once in Ch 9: "REPTIN: (shouting back) Four hundred years in there, a month out here! Lovely!"

### 4. "What does that word mean?"

**71 questions, in every part.** 56 are about the story's own words. 15 are D&D words that a Pokémon player has no picture for.

- The story's words: "What are 'the Heralds'? The tip says to open 'Heralds'." (Ch 1); "Why does beating him give me a 'seal'?" (Ch 1); "What's the difference between the Heart of Winter, a heart of ice and the Heart of Ice?" (Ch 3); "What is the White Womb, the White Vault, Ithryn Athis, the Frostshard Sigil?" (Ch 7); "What are V-7, Razzy, the cold table, the variables?" (Ch 7); "Who is Avarice? Who's Var? Who's the Marshal? Who's 'the tall gold man'?" (Ch 10).
- D&D words: "Who's Zenith, and what's a hag?" (Ch 4); "What's a mephit? What's a ghoul? Is that a Pokémon?" (Ch 5); "What is a duergar, and who is Xardorok?" (Ch 8); "What are an umber hulk, a quaggoth, a myconid, a mind flayer, a barbed devil? Why are they Pokémon?" (Ch 8); "What's an eladrin? An aasimar? A goliath? A drow? A dragonborn? A tiefling?" (Ch 15).

**Fix, game-wide:** one name per thing, explained in the box where it first appears (the glossary below lists them). D&D creatures and races get described by what you see before the word: "a small dog-faced lizard-man: a kobold" (§8, §11 item 31).

### 5. "Where do I go?"

**27 questions, in every part.**

- Ch 1: "Where is Naerth?" Every pointer in town sends you to the Town Hall, but Naerth is at the Luskan Arms.
- Ch 2: "Which way is Bryn Shander? The text says north, the goal says south-east."
- Ch 6: "Is the cellar a gym? Where's the fourth badge?"
- Ch 10: "Where do I go first, and what's left?" The goal is one sentence of about 245 characters, and then it disappears.
- Ch 12: "My Goal says the griffon roost. Why am I climbing down a well?"
- Ch 14: "What am I supposed to be doing? The menu says to bring iron to Hruna, but I did." A side quest put back a stale goal.
- Ch 15: "Where do I go now? I've finished the spine bit and there's a whole city."

**Fix, game-wide:** every spine step sets a one-sentence goal that names a place and a direction, and the last person you talked to says the same thing (§9a rule 3). Side quests get their own list under the Goal. They never write into `state[:goal]`, so they can't overwrite it or restore a stale one (14 E4, 15 E2).

### 6. "Why did that just happen?"

**52 questions, in every part.** Each of these is a turn in the story whose cause the player never saw, or never had said to them.

- Ch 3: "Wait, I just said yes to sleeping and my friend died?" The bed prompt sets off Shimmer's death, with no warning beforehand. The villain the goal promised was never met in Lonelywood.
- Ch 3: "Why are we taking the heart to the man who wants it?" The reason (the Warren is under the Moon Temple) is only in an optional line.
- Ch 4: "Why should I break her mirrors? What happens if I don't?" Thredra asks you to break her own power and never says why you'd want to.
- Ch 8: "Why did Glimmer have to die? Did I do something wrong?" His death is told in narration, with no Glimmer on screen. The curse it rests on is never restated.
- Ch 8 and 9: "Avarice said she'll see us again. Why does everyone say she's dead?" / "That face in the glass was the villain. Isn't she dead?" Her last line, "We will speak again in the White Womb", undoes her faked death.
- Ch 9: "Why am I being arrested? I just saved everyone." The charge names "Summer Marshal Var Rime-Breaker", the body you watched turn out to be Avarice.
- Ch 15: "I beat the Rime Stalker. Why didn't I get the cloak?" The rule ("Catch it") is said once, before the battle.

**Fix, game-wide:** give every turn its cause in a line the player hears before it. Shade can say before the bed, "SHADE: We sleep in shifts. He's out there." After the turn, one Herald reacts to it (WRITING_GUIDE §3: losses are "followed by updated party chat and NPC lines").

### 7. "What does this choice change?"

**15 questions in 8 parts** (06, 07, 08, 09, 10, 13, 14, 15). The editor notes find the other half of the problem in 01, 02, 06, 08 and 15: choices that set a flag nothing ever reads. Part 15 alone has 52 unread flags.

- Ch 6: "What was the orb telling me? Do I choose one of the two roads?" 44 boxes of prophecy, and no choice.
- Ch 7: "What happens if I say the wrong thing at the attendant?" The promise is read six times later. The player has no idea what either option means yet.
- Ch 8: "What do the spires do? Scour or break?" / "What's the difference between Sanctify, Leave it whole and Destroy?"
- Ch 10: "What did choosing a speaker do?" Nothing visible happens.
- Ch 13: "What happens if I pick each of these?" This is the game's biggest choice. It has no confirm, and pressing B picks the Third Way.
- Ch 14: "Did anything I did out there matter?" Nobody outside each quest's town ever mentions it.
- Ch 15: "What's the Wheel? Why does the game keep saying +1 to something I can't see?" / "Did I just make Winter angry?"

**Fix, game-wide:** under every choice that matters, one plain line in parentheses says what it does. After it, one line acknowledges what you picked. Every flag a choice sets is read back at least once (§6). The cheapest reader is Hellen's rest greeting, keyed to the last thing you finished (15 E5).

### 8. Pokémon basics nobody teaches

**22 questions in 11 parts.** None of these is in the story. They're the game assuming you've played Pokémon before.

- Prologue: "What is a Pokémon? What do I do with it?" / "Why did I lose my first fight? Was I meant to?" / "What do Easy, Normal and Hard change?"
- Ch 1: "Why is the Town Hall full of people who want to fight me? Why does beating him give me a 'seal'?" Nobody says what a gym is. Also: "What are DNA Splicers? How do I use them?" and "What's a Pokédex, and why does a relic dealer have one?"
- Ch 5: "Why did my Pokémon just lose health?" HP drops with no message.
- Ch 7: "What are Kecgar, Sablass, Sudogela, Gloocap, Tentabat, Swibat?" These are fusions, and nothing says which two Pokémon made each one.
- Ch 7, 8 and 13: "I lost. Why am I back at the start of the dungeon, and why does it say Pokémon Center?" The engine's blackout text names a building that isn't in this game.
- Ch 13: "Why do my special moves do nothing?" The rule is hidden in a riddle.
- Ch 15: "What's that faint Gengar doing in the tavern? Is my game broken?"

**Fix, game-wide:** teach each mechanic in one line, from a character, the first time it matters:
- "WYNSNOW: A Pokémon in each ball. Raise it well and it'll fight beside you."
- "GUIDE: Beat his three people, then the Speaker. Win, and his seal gets you through any gate."
- "NAERTH: Use them from your Bag on two of your Pokémon."

Add a Frost & Thaw blackout line, and show both halves the first time a fusion appears ("A fusion of [head] and [body].").

### 9. "Who am I in this story?"

**7 questions in 7 parts** (00, 07, 09, 10, 12, 13, 15). This theme is small, but it's the question under all the others: the New Journey player is a Rootspire kid, not a Herald.

- Prologue: "I'm choosing a look and a name. Who am I?"
- Ch 7: "why am I seeing what Alberica sees?" The chapter opens on "(Something only Alberica sees.)" twice.
- Ch 9: "What's a Dragoon, and why does Alerion get one and not me?"
- Ch 10: "Am I on trial? I'm not one of the Heralds."
- Ch 13: "Who's the old woman? 'Hello again'?" The loop never says that the stranger is you.
- Ch 15: "Why does everyone call me 'Herald'? I'm the kid from the College."

**Fix, game-wide:** say your place once per act, in someone's voice:
- "You're a kid in Rootspire, about to get your first Pokémon." (prologue)
- "NAERTH: Six strangers in a blizzard." (Ch 1)
- "MEAT MEAT: Ice Prince is Frostina's. Meat Meat is Razzy's. [Name] rides with us." (Ch 9)
- "KELYN: And you. You travel with them. You'll speak for them, or against them." (Ch 10)
- "The stranger is you." (Ch 13)

Lines that call the Journey player "Herald" become "Herald's friend", or your name (15 F1, E18).

## Chapter by chapter

For each part, the one moment where a newcomer is most lost. The other questions are in each chapter's notes.

| Part | The moment a newcomer is most lost | Why | Fix |
| --- | --- | --- | --- |
| 00 Prologue | The white screen after "TAMSIN: What are you..." | Nothing says the lantern is a door to the Heralds' time. Your sprite doesn't move, and no line says you fall in. The mural never says the five carvings are the Heralds. | The seller says "That glass saw the Heralds' winter. It remembers." Then: "The crack pulls at you like a door in a gale. You fall into the glass." The mural says "TAMSIN: Look. The Heralds." (00 E2, E3) |
| 01 Targos | The pier: "ALERION: You fell out of the air." | Four voices and nobody on screen. No line says this is Targos, four hundred years back. The names arrive as speaker tags. | Alerion stands in front of you: "A pale elf catches your arm." Add a second box: "Targos, in the Icewind Dale of Hellen's stories. Four hundred years before you were born." (01 E1) |
| 02 Lottery Night | The road: "What goblin? I didn't see anything." | Razzy, the chapter's heart, never appears. The goal then says south-east while you walk north. | Stage Razzy: he bursts out, tugs Reptin, runs, and the camera follows him to the glow. The goal says "north". (02 E2, E19) |
| 03 Shimmer's Requiem | Saying yes to the bed, then Shimmer is gone | The bed is the story trigger, with no warning. The vision panel contradicts its words. "You're back in the attic" names a room you never saw. | Meet Sephek in Lonelywood before the attic. Before the prompt: "SHADE: We sleep in shifts. He's out there." Then: "You're back by Nimsy's hearth." (03 E1, E7) |
| 04 Dougan's Hole | Thredra's riddle: "Daughter of song, wolf of seasons, boy outside time..." | Five epithets, and two of them get a reaction. "She wants a new coat" doesn't name Auril. Nothing says why you'd break the mirrors. | Each Herald gets a beat. "THREDRA: Auril wants a new coat to wear." / "Each mirror holds one of them out on the ice." (04 E15, rows 29-36) |
| 05 The Cackling Chasm | The fall that ends Act I | Tree, city, dragons, your own face, then Rootspire. "Verdant Reversal" isn't said. | Before "END OF ACT I": "You fall a long way. Four hundred years, the light says. Then the ground." Add the Heralds theme. (05 F16, E16) |
| 06 Festival of Returning Light | Arriving: "TAMSIN: ...You were gone an HOUR." | It's four hundred years later for the city, but the rule is in two Hellen lines a newcomer reads past. Then the Council brings in eight new proper nouns. | "HELLEN: An hour for her. Four hundred years for the city." Split the Council, and gloss Selrae's names. (06 F2, F3) |
| 07 Two Roads Down | Hew's door: "You've seen that sigil." | You haven't, in this order. The door has a keyhole, then needs a crystal, then is "locked from the other side". | Show the sigil the first time you look at the door. Goal: "Hew's door: a keyhole and a glass sigil. Someone below has both." (07 E16, F7) |
| 08 The Rootsun Forge | Glimmer's death | It's told in narration, with no Glimmer on screen. The curse it rests on was last stated chapters ago, and the player does nothing. | At the forge rest: "GLIMMER: The Rimefang's colder every day." Stage him walking to the engine, and give the player one input there. (08 E2, F9) |
| 09 Destruction's Light | The arrest: "For the deaths of Summer Marshal Var Rime-Breaker" | You watched Var turn out to be Avarice. Then the whole charge is read again nine boxes later. | "KELYN: (arriving, white-faced) The city saw its Marshal fall. Not what was inside him." Rheven only arrests. (09 E14) |
| 10 Trials of the Roots | The trial week's first goal | One line of about 245 characters. Nothing says what you are to the court, what witnesses win, or how many days are left. | "KELYN: And you. You travel with them. You'll speak for them, or against them." Then a short hub goal and "Day n of 7". (10 E2, E4) |
| 11 The Frost Saint Walks | Auril at the Hearth table | "Nobody else can see her", but you can. "Dark half, light half, spark, wheel" are never decoded. | "...Nobody else can see her. Except you: you were never on her wheel." / "ALBERICA: The dark half's you, pretty boy. The light half's Meat Meat." (11 F) |
| 12 The Sea of Moving Ice | Avarice in every mirror of the Vault | "You watched a coat burn" leans on a Ch 8 metaphor. She talks nine boxes in a row, and nobody answers. | "AVARICE: You watched a borrowed body burn, Alberica. Did you think I only had one?" Each Herald answers one whisper. (12 E4, rows 14-21) |
| 13 Grimskalle and the endings | The coda in the Cackling Chasm: "Hello again" | 55 boxes with no input, in silence, on the throne map. The loop is left for you to work out. | Move the epilogue to Rootspire with music. End the coda on "The stranger is you." (13 E1, E10) |
| 14 Ten-Towns side quests | Boy running about Targos | He reads as a wild Pokémon. The text says he tackles you after you've chased him down. | A sled-dog sprite that barks, shows a "!", and runs to you. Then the narration is true. (14 E2) |
| 15 Rootspire side quests | A faint Gengar by Hellen's bar, all week | It looks like a bug. Touching it says only "Something was there." Nobody says what the watchers are or who sent them. | The first one you touch plays a two-box explanation: "ALERION: Something's watching us. It's waiting for whoever sent it to be near." (15 E4) |

## A glossary the game needs

These are the terms a newcomer meets without an explanation, in the order they first appear. Each comes with one line the game could say the first time, in a character's voice where that fits. Where a chapter's notes already wrote the line, it's used here as they wrote it.

| Term | First appears | What the game could say, first time |
| --- | --- | --- |
| Icewind Dale | 0.01, the opening card | "Four hundred years ago, a winter that would not end gripped Icewind Dale." Then a second box: "Ten small towns on three frozen lakes, under the mountains." |
| Auril, the Frostmaiden | 0.01, the version menu (Ch 1 for "Frostmaiden") | "Frost leans toward Auril, goddess of winter." In Ch 1: "NAERTH: A gift for Auril, the winter goddess." |
| Avarice | 0.01, the version menu | "Thaw leans toward Avarice, a mage with her own plans." |
| Frostina, Razzilith | 0.01, the version menu | "Her ice dragon, Frostina, is on the cover." / "Razzilith, a green dragon, is on the cover." |
| Heralds of Dawn and Dusk | 0.01-0.02 | "Five strangers stood against it. Rootspire calls them the Heralds of Dawn and Dusk." |
| Verdant Reversal, the World Tree | 0.02 | "Where the ice broke, a great tree grew in a single night." / "The city in its roots is Rootspire. It counts its years from that night." |
| Rooted Hearth | 0.03 | "Hellen Brightrun, Tamsin's mum, keeps the Rooted Hearth. Nobody has ever left it hungry." |
| Rootwarden | 0.03 | "TAMSIN: I'm the future Rootwarden. Tree guard. [Name]'s the errand-runner. For now." |
| Canopy-Tier, the College | 0.05 | "LIFT-KEEPER: Up to the College? Right at the top of the tree. Hold on to the rail." |
| Pokémon, Poké Ball | 0.07 | "WYNSNOW: A Pokémon in each ball. Raise it well and it'll fight beside you." |
| The sixth figure | 0.11, the mural | "TAMSIN: Look. The Heralds. Every festival I check if the little one moved." At the payoff (12.13): "TAMSIN: That's you. On Hellen's wall. The sixth Herald, the one nobody could name." |
| Reversal glass, "the old hag's mirrors" | 0.12 | "LANTERN SELLER: Laugh all you like. That glass saw the Heralds' winter. It remembers." |
| Targos | 1.01 | "Targos, in the Icewind Dale of Hellen's stories. Four hundred years before you were born." |
| Relic | 1.03 | "Old things, cold things. Relics, the Dale calls them." |
| Pokédex | 1.04 | "EPHERIS: It records every Pokémon you meet. It's in your pack. Open it from your menu." |
| Arcane Brotherhood | 1.04 | "EPHERIS: The Brotherhood. Wizards in a tower in Luskan. They'd kill for this." |
| Speaker | 1.04, the gate | "GUARD: Speaker Naerth runs Targos. Nobody leaves without his seal." |
| The lottery | 1.05 | "NAERTH: Whoever's drawn walks out onto the tundra. A gift for Auril, the winter goddess." |
| The Rime | Ch 1, Targos townsfolk (earlier in Herald mode's ship opening) | "TOWNSPERSON: Two years of night. The Rime, folk call it. Her winter, the one that won't end." |
| Sephek, "a man who doesn't feel the cold" | 1.05 | At the lottery (2.08): "SHIMMER: (very still) Sephek. Don't. Nobody move." Later (11.02): "Sephek Kaltro, Auril's Chosen." |
| Seal (the gym badge) | 1.06, the Town Hall | "GUIDE: Beat his three people, then the Speaker. Win, and his seal gets you through any gate." |
| DNA Splicers, Twinning | 1.06 | "NAERTH: Two Pokémon in, one comes out. Twinning, the traders call it." / "NAERTH: Use them from your Bag on two of your Pokémon." |
| Saltmarsh | 1.07 | "SHADE: I pulled my sister out of the snow in Saltmarsh. This was lying there." (02 F7) |
| Black Network, Zhentarim | 1.05 (trainers' titles) and Ch 2 | Use one name: Black Network (02 E31). "SHADE: The Black Network. Smugglers, with better books than ours." |
| Aurilites, frost-light | 2.03 | "SIV: The Frostmaiden's light. Every crumb belongs to her. You don't." |
| Morninglord | 2.10 | "MISHANN: The Morninglord is the dawn. I keep its fire lit." |
| Halfling | 3.05 (first heard in Ch 2) | "NIMSY: Cookie? They're shaped like halflings. Like me. That's the joke." |
| Heart of ice | 3.07 | Drop "Heart of Winter". At 3.18: "LUNA CARVER: Hers is the first, sung into the egg. The cold man's beats in his chest." |
| Wennen, Circle of Thirteen | 3.13 | "Tall figures with long ears watch you pass: the Wennen, the moon-keepers. Thirteen of them sit in council." |
| Iskra, "her great white roe" | 3.17 | "LUNA CARVER: The night the Rime began, Iskra, her great white roe, ran over our sky." First decide which animal she is: 11 E14 points out that a female roe has no antlers. |
| Hag, Thredra, "Granny" | 4.01 (the word first in 0.12) | "SHADE: A hag. A witch out of the stories. In a chasm. Is anything here just a nice lake?" |
| Kobold | 4.16 | "...three small white-scaled kobolds, lizard folk no bigger than children..." |
| Ice mephit | 5.04 | "small imps of living ice, shrieking with laughter: ice mephits!" / "MEAT MEAT: Ice goblins. Not real goblins. Meat Meat checked." |
| Gnolls, Yeenoghu | Ch 5, the Laughing Waste | "ALERION: Gnoll writing. Hyena-men. They broke in here and defiled whatever this was." |
| Glimmer | 5.08, the journal | Keep it a hook in Ch 5. When he arrives, and again in the epilogue: "Glimmer, who was Shade." |
| Order of Life and Death | Ch 5, the Waste, then the gate | "ALERION: Druids. An order of them, keeping something here. Life and death, in balance." |
| Auroral Wall | 6.02, Hellen | "HELLEN: The Wall's a ring of light round the city. Outside it, time hardly moves." (06 E18; 12 F4) |
| Anduin | 6.02 | "REPTIN: (very quietly) My husband's out there. Anduin." |
| Summer, Var, the Marshal | 6.04 | Call the body "the Marshal" and the woman inside it "Avarice" (10 F3). "RAZZILITH: Summer wears the Marshal like a coat. Inside: a woman. Horns." |
| Rimefang | 6.04 (a name in Ch 1) | "ALERION: The Rimefang. The dagger from your boot, Shade. It's been cold since Saltmarsh." |
| White Womb, White Vault, Draconic Vault, Ithryn Athis | 6.04 | One name for the door: "WYNSNOW: The White Vault, under the glacier. Selrae calls it the White Womb. Same door." (15 F7). Keep Ithryn Athis for Act III. |
| Fractured Halo | 6.04 | "KELYN: The Fractured Halo. Auril's last faithful. They pray for the cold to come back." |
| Grafting | 6.x, Wynsnow | "WYNSNOW: Splicers fuse two for a while. A graft is for keeps." |
| Frostshard Sigil | 6.26, the Echo Gate | "(A Frostshard Sigil: one of three keys to the White Vault.)" |
| Hyphora | 6.22 | "WYN: Captain Rheven... the Sap Gate spores went quiet. The tree-god's... afraid." In Ch 10: "ANDUIN: This tree is a god, Reptin. A young one." |
| Myconids | 6.22 | "WYN: ...Through the myconids. The mushroom folk. I can take you." |
| Talion | 6.26, the Echo Gate | "ALERION: That voice. Talion. My brother. The lake took him." |
| V-7, Prototype Verdant, the cold table | 7B.13 | "MEAT MEAT: (very still) V-7. That's what she called Meat Meat. On the cold table." |
| Duergar, Xardorok | 7B.25 (the word), 8.01 | "Grey dwarves, duergar, wearing Avarice's sigils..." / "ALERION: Xardorok. Their king's name. She took that too." |
| Dragoon | 9.03 | The carving's "NOT RIDERS. DRAGOONS. GUIDES TO YOUNG DRAGONS.", then "MEAT MEAT: Ice Prince is Frostina's. Meat Meat is Razzy's. [Name] rides with us." |
| The Rift, ice-angels, the Frostfell | 10.x (the Rift named in 6.04) | "SELRAE: There's a tear in the sky over the Canopy. Things come through it. Ice-angels." The Frostfell: "ALERION: Auril's own country. The cold behind the cold." |
| The wheel, the Wheel | 11.01 (Auril); hidden "+1 Wheel" from Ch 2 | Say it the first time it moves: "(Something old turns, once. The Wheel of the seasons noticed.)" (15 F10) |
| Watchers | Ch 6 onward (part 15) | "ALERION: Something's watching us. It's waiting for whoever sent it to be near." |
| Still Ones | 12.05 (met in part 15) | "The Still Ones' blessing holds you. On the far side of the Wall, time stands still." |
| Goliath, tiefling, eladrin, aasimar, drow, dragonborn | Ch 1 rumours; Ch 14-15 | Say what you see before the word: "Mokingo, a goliath: a mountain man, seven feet tall." / "Astrix, a tiefling. Horns. Swears a lot." (14 F5, 15 F4) |
