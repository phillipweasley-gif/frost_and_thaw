# Dialogue review: the whole game, against the craft books

This review was redone on 5 November using your game-narrative skill. The first version mostly checked mechanics:

- box length;
- the wrong speaker;
- pronouns;
- continuity.

This one judges the lines **as dialogue**, against William C. Martell's *Dialogue Secrets* and your voice sheets in `voices.md`. Nine readers each took a slice of the as-played script. Each ran Martell's polish checklist scene by scene, and the cover-the-names test character by character. The per-chapter reviews are the sub-tabs under this one. Together they hold about 520 line notes, each with a rewrite in the character's voice (90 characters or less per box) and where the line lives in the code.

## In short

**The voices are mostly there. What breaks is how the lines connect.**

Almost every Herald passes the cover-the-names test most of the time. That means the voice sheets work. What fails is the exchange around the lines:

- **Lines that don't follow.** Answers to things nobody said. People who know what they can't know. An "it" that points at nothing. The readers found about 150 of these, and they are what you meant by "doesn't quite make sense".
- **Information without conflict.** Characters ask leading questions so someone else can recite. People explain what you just saw. Speeches run on with nobody pushing back.
- **Tics that have spread.** Alberica's pet names, "four hundred years", Meat Meat's catchphrases, and Reptin's "(under his breath)" joke shape. Each started as a voice and has become filler.

Martell's first rule is that dialogue is a fight. Every line should bounce off the one before and change the direction of the exchange (p. 17). Most of the fixes below do that one thing.

## What's working

These are the lines to protect, so a rewrite doesn't flatten them:

- **Theme lines that land.** "There's always a third way." "Nothing that is still can grieve." / "I'd rather grieve. It means I had something." "Time is a wheel, dear."
- **Coat lines that change meaning each time.** "Summer is a coat." becomes Avarice's "Names are coats too." That becomes "He was a coat." in Chapter 9. This is Martell's echo line: a phrase that changes meaning each time it returns (pp. 48–49).
- **Understatement at the right moment.** Reptin: "Let's all be very reasonable. Especially the people with spears." Alerion: "I didn't apply." Alberica, after Auril shatters: "...Well. That's one way to end a party." (p. 63).
- **Villains who make a case.** Thredra offers to end the winter and take the wolf out of Reptin. Sephek's "I only held the knife. I'm sorry." Both carry subtext under menace (p. 26).
- **The tavern.** It plays almost box for box like voices.md Sample 1, so the house style works when it's followed.
- **Supporting voices that pass cleanly:** Hellen, Tamsin, Durmoot, Naerth, Sephek, Thredra, Selrae (Act II), Kethan, Anduin and Owenn.

## The seven dialogue problems, game-wide

### 1. Lines that don't follow (about 150)

These are the owner's "doesn't make sense" lines. They come in four kinds:

- **Psychic characters** (Martell p. 18) know things they can't know:
  - Alerion names Frostina before anyone has.
  - Eira says "Hyphora" before the name is sworn.
  - Kelyn recites Eirwen's private maps.
  - Wyn knows about the heart.
  - Shade says "vessel".
  - Alberica quotes the charter before anyone has read it.
- **Answers to nothing:**
  - "You're not fine", when nobody said "I'm fine".
  - Shade's "Too late. You already have."
  - "Yes, it's always first light".
  - Reptin's seal joke, placed after the TM line.
  - Koran's "So is he".
- **Pronouns and references with nothing behind them:**
  - Shimmer's "it".
  - The cat in 1.07.
  - Sephek's turn, where one "she" points at three different women.
- **Lines that contradict what you were shown:**
  - Kelyn's "Var? thank the seasons" over a sending-stone that carries no faces. Fixed in 0.7.2.
  - The Tribunal conceding that Var was Avarice.
  - Brightmane's "you'll know the fire", which Glimmer quotes three times and she never says.

**Fix.** Each chapter tab lists its own as "lines that don't follow", with a rewrite. Do them first in each act's pass. They're the cheapest changes with the biggest effect on whether the game makes sense.

### 2. Prompters and recitals (Martell pp. 15, 126–127)

Many scenes deliver their facts through a character whose only job is to ask:

- **The Trials.** Eight witnesses follow the same frame: "ASK: Ask X...", a past-tense account, then "I'll say it to the crystals". The Verdict then prints only a list of 26 names. The code already holds a testimony line for every witness, in their own voice (`WITNESSES`, 036_Chapter10.rb:106–149). They just never play.
- **Reptin as interviewer.** He is cast as the prompter again and again: "(gently) Go on, Matron. We're listening.", plus his interpreter gag "She's saying..." four times in Chapters 3–4.
- **Lore-givers with nothing at stake.** Luna, Jet, the ghost in the Chasm, Phildendrin's mission brief, and the Balanus lore.

**Fix.** Give every recital someone who doesn't want it said. Examples:

- A hostile councillor in the Trials.
- Shade arguing with Luna.
- Reptin arguing with the ghost.

Better still, play the event instead of retelling it (Martell's "present tense", pp. 16, 20–21). For the Trials, play each witness's testimony in the courtroom, with one opponent and the accused Herald's defence line (Ch10 tab, top 1).

### 3. Explaining what you just saw (See & Say, Martell pp. 27, 37)

Alerion has become the party's explainer. He reads out every document and decodes every vision. He even says "Places like this always ask" twice, word for word (Ch7, Ch10, Ch14, Ch15). Narration does the same with what the sprites already show: "She looks at each of them in turn" and "Not warm. Not kind." (1.03).

**Fix.** Cut the line, or make it clash with the picture. Give Alerion back his voice sheet: flat, literal, one devastating line, and silence otherwise. When a document needs reading, let the character who cares about it read it, and let someone else react.

### 4. Tics that have spread (Martell pp. 35, 80)

A pet word should be rare, like a running gag. These have become constant:

| Tic | How often | Rule |
| --- | --- | --- |
| Alberica's pet names (darling, sweetheart, sugar, pretty boy) | 35 of her 50 lines in the Rootspire side content; 18 of 42 in Ch7; 24 in the Ten-Towns quests; about 19 in Ch6; used over the dead and in grief | **One per scene at most, at the end of the line, never in grief.** "Pretty boy" stays hers for Alerion |
| Reptin borrowing "darling" | Ch7, Ch8, Ch10, Ch12 | Never. His warmth is "dear" and polish |
| Reptin's polite line plus "(under his breath)" sting | three times in Ch1 alone; again in every chapter | Once per chapter |
| "Four hundred years" | 18 times in Ch6 | Twice per chapter. Use a detail instead ("before the coffee was invented") |
| Meat Meat's "Fondly", "not crying", "smells like", "from the cold table" | Fondly ×5; "not crying" shared with Alberica; "smells like" ×4 in the side quests | Each once or twice in the whole game. "Not crying" is Meat Meat's alone |
| Meat Meat's third person | shared by Izobai, Trex and Duhg | Hers alone. Give the monsters another speech pattern |
| Alerion's "my ring's cold" | four times as a sense-the-dead prop | Once per act |
| Gym leaders' "Fitting for a town..." and "keeps its word. Even..." | most Speakers | Each leader gets their own challenge line |
| Tamsin saying your name | 7 boxes in the prologue | About 3: the wake-up, the gift, the last cut-off |
| "Eat first" | Ma Yarbroul and Hellen | Hellen's alone, as a deliberate echo of the first warm room in each era, or cut it from Ma |
| "Hello again" | Avarice and Old Alberica | Avarice's alone |

### 5. Speeches with no one to interrupt (Martell pp. 69–70)

These speeches run past three lines with no listener who wants something:

- **Act I:** Naerth (six boxes), Keegan's backstory, Scramsax, Mishann's acorn.
- **Act II:** Hellen's Wall-rule speech, Phildendrin's mission brief, Avarice in the Heart Chamber.
- **Act III:** Auril's eleven-box Hearth vision, and about six explaining boxes in the epilogue.

**The rule.** Break each speech with someone who pushes back. Keep a speech only where it earns its length; the endings' speeches do. Examples from the chapter tabs:

- Reptin asks Naerth to let them leave, so Naerth's terms answer someone.
- Hellen's Wall rule becomes her answer to Reptin's fear for Anduin.
- Avarice gets Reptin's question, the lottery arithmetic and one design line, instead of a monologue.
- Auril's Hearth vision drops to five boxes, and Alberica answers it once: "I don't sing for you."

### 6. Jokes over grief (voices.md: sad moments get one quiet beat)

The house rule is "sad moments get one quiet beat and no speeches". It breaks in these places:

- **Ch4.** Shade jokes the day after Shimmer dies, and says nothing when Thredra names her.
- **Ch3.** Reptin says nothing at the loss.
- **The Foaming Mugs.** Alberica's sarcasm lands on the dwarves' grief.
- **The White Moose.** The ask comes straight after "Shimmer's bedroll is empty" and never mentions her.
- **Act III.** Alberica uses pet names in grief.

**Fix.** One quiet line in the character's own voice at each loss, then the joke can come back a scene later. Examples from the chapter tabs:

- Shade: "Her name was Shimmer."
- Shade: "She'd have liked you."
- Alberica: "No. Memory's for remembering."

### 7. Quest briefings with nothing live in the room (Martell p. 144)

The side quests explain their asks well, but nothing is at stake while they do. Martell's fix is to add a "weapon": something in the room that could go off. Most quests already have one in the scene:

- **Ten-Towns:**
  - Boy at the door;
  - Korux's silence;
  - Marta's dying father;
  - Nimsy's untouched plate.
- **Rootspire:**
  - the Lorn Scribe;
  - Kethan;
  - Ivran;
  - Eirwen at the pillar;
  - Kelyn within earshot of Darrus.

**Fix.** Build each briefing around that thing (Ten-Towns and Rootspire tabs, top 1). The rumour-tellers also need an attitude each. Ravisin needs a case for what she does. The ten seers each speak in their own way, but all fall back on the same phrases ("something below", dreams "every night", "screaming"). Give each seer a warning only they could give.

## Voices: the cover-the-names test

"Yes" means a reader who knows the cast could name the speaker with the names covered.

| Character | Result | Sounds right | Where it drifts | The fix |
| --- | --- | --- | --- | --- |
| **Alberica** | Yes for her jokes, half for her plot lines | "Oh, I like her." / "Welcome to being a person, sweetheart." | Pet names as filler; explaining; Meat Meat's "not crying" | The pet-name rule above; give her one song (she never sings in the Ten-Towns quests) |
| **Reptin** | Yes when polished; no when explaining or comforting | "That's a promise, not a pleasantry." / "Is the floor also cursed?" | Takes Alberica's "darling"; flat statements like Alerion's (Ch5); stock comfort lines; tracker and coroner lines; Avarice's word "arithmetic" | Give him back his polish; let him argue (with the ghost, with Naerth) rather than prompt |
| **Alerion** | Yes on his own lines; partly in Act II side content | "I didn't apply." / "She's right. He was a coat." | Has become the explainer; recaps; stock quips ("Someone went to a lot of trouble.", "Keep it safe.") | One line per scene, literal, and let silence work; tracking lines go back to him, not Shade |
| **Meat Meat** | Yes, every chapter | "Meat Meat owes you NOTHING." | Catchphrase repetition; "No more deals with mirrors." copied from Ch8 | Ration the catchphrases; keep her third person hers alone |
| **Wyn** | Yes when soft; no on information lines | Trailing, gentle sentences | Clipped info lines in Alerion's shape; "wrong" worn out; "My post... was set to guard this" | Give back the trailing sentence shape |
| **Shade** | Half | Bets and negotiates | Plain info lines; Reptin's either/or joke shape; party tracker; explains others' subtext; jokes after grief | Shade bets ("Trap or kid. Out here I'd bet trap."), negotiates (give Shade a voice in Thredra's bargain), and grieves once |
| **Shimmer** | Yes on the road; no in the vision (3.07) | The best-kept voice in Act I | The vision speaks like narration | Rewrite the vision in her voice |
| **Glimmer** | Yes in party chat; partly at his death | | His death speech is plot logic | "Neither." should answer Avarice's "Your move"; end on "Mind the dragon." |
| **Tamsin** | Yes | "Up! UP!" / "...I KNEW it." | Uses your name too often; never your full name in Ch6 | About three uses of your name in the prologue |
| **Hellen** | Yes | "Sit. All of you. Eat." | One speech (the Wall rule) | Make it an answer to Reptin |
| **Thredra** | Yes | "Come in, dearies. Mind the cold. Mind your step." | Stock "Interesting. Very interesting."; telling people what they lived through | Fixed in 0.7.2 for the player ("this one fell through my glass"); have her top Alberica's insult instead of agreeing |
| **Avarice** | Yes in short lines; no in her 8.19 speech | "Variables that refused to die." | Monologue; shares "darlings" and "Hello again" | Break the speech; give her the case ("The Frostmaiden wants the world still. I want it running. On my schedule.") |
| **Auril** | Yes; drifts in her long Hearth speech | "Hear the wheel, and the ones who bind it." | "I loved the world"; "DEFILERS!" | The bible: she "speaks rarely and never begs". Five boxes, then let someone answer |
| **Sephek** | Yes | "I only held the knife." / "Next solstice." | A psychic "notes" line; repeats Ch11 at the Crown | Keep the bible's turn line, or "She died saying no. I won't make her say yes." |
| **Kelyn** | Half | "Four hundred years late. Or right on time." | Shouts "ENOUGH." against her sheet; recites Eirwen's maps | Quiet authority; she never shouts |
| **Selrae** | Yes in Act II; no in Act III | "People who swear oaths in their first hour swear them to anyone." | Generic in Ch11–13 | Keep her dry and mild throughout |
| **Darrus, Razzilith, Luna, Phildendrin (as quest-giver), Keegan (backstory)** | No | | Generic lore and briefings | Darrus: a velvet voice and a secret. Razzilith: fewer words, more painted thoughts. Phildendrin: keep her a mother, and cut the five-box brief |

## Voice sheet additions

Martell's drill is to give every character their own yes, no, hello and goodbye, because that's where voices blur first (p. 36). The readers collected these from the lines that already work. They should go into `voices.md`:

| Character | Yes | No | Hello | Goodbye |
| --- | --- | --- | --- | --- |
| Alberica | "Oh, I like her." | "No. Memory's for remembering." | "Welcome to being a person, sweetheart." | "Let's go home." |
| Reptin | "That's a promise, not a pleasantry." | (a polite refusal with a sting) | "What my colleague means is: thank you, Pip." | "Rest now, friend." |
| Alerion | "They were." / "It was." | "Break it." / "That's not how tests work." | "I'm here." | (he doesn't say goodbye; he leaves) |
| Shade | (a bet: "Out here I'd bet yes.") | "Next time we run. That's not a suggestion." | | |
| Tamsin | "...I KNEW it." | | "Up! UP!" / "THERE you are!" | "Come back and tell me everything. Every single thing. In order." |
| Hellen | | | "Sit. All of you. Eat." | "And come back for supper. I'm not asking." |
| Wynsnow | | "Not yet! A Pokémon first." | "Ah." | "Off you go, both of you. I have measuring to do." |
| Durmoot | | | "Strangers. In Dougan's Hole. In winter. Either you're lost or you're stupid." | "...Stay in tonight." |
| Thredra | | | "Come in, dearies. Mind the cold." | "Come and find me in the chasm, dearies." |
| Kelyn | | "No." | "Four hundred years late. Or right on time." | "Come back up. All of you. Please." |
| Avarice | "Done? Good." | | "Variables that refused to die." | "...Recalculating..." |
| Auril | | | "Hear the wheel, and the ones who bind it." | "Everything I loved, I kept." |
| Sephek | "Oh. So that's what it feels like." | | "I held the knife." | "Next solstice." |

## The first review's rewrites

About ninety of the first review's suggested rewrites don't hold up under Martell, and each chapter tab lists its own with a better one. The worst kinds were:

- **Canon slips:**
  - "Her ice dragon".
  - Avarice's "my little experiments" in place of her own phrase, "my little failures".
  - "since before I was born" for Alberica, who is 400 years older than the Council.
- **Wrong pronouns:** Tamsin and Eirwen are *they*.
- **Rewrites that flatten a good line:**
  - cutting Scramsax's "Coldest company.";
  - dropping Hellen's "on an empty stomach" hook;
  - removing the "No face." reveal.
- **Rewrites that are themselves on the nose:**
  - Sephek's turn line;
  - Grik's fix, which swapped a contradiction for a spoiler.
- **One rewrite that was backwards:** Brisa's original line should stay, because autumn did come back in Chapter 9.

## How to use this

Fold each chapter's dialogue notes into its act's pass (fix-plan steps 4–6), after the story review's setup pass and before the staging. In each scene:

1. Fix the lines that don't follow.
2. Turn recitals into fights.
3. Cut See & Say and the explainer lines.
4. Ration the tics by the table above.
5. Break the speeches.
6. Give each loss one quiet beat.

Then read the scene aloud (Martell p. 78).

Already done in 0.7.2:

- every line that gave away "Summer is Avarice" before Chapter 8;
- Kelyn's sending-stone line;
- Thredra's line to the player;
- the Vault's lines that assumed Auril was alive;
- the Ten-Towns reward lines.

---

*Sources:* William C. Martell, *Dialogue Secrets*; Linda Seger, *Making a Good Script Great*. Page numbers are the PDF pages in the skill's references.
