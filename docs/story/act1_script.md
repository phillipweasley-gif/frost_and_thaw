# Act I: The Rime

Scene scripts for the Prologue and Chapters 1–5, Ten-Towns, two years into the Everlasting Rime.

## How to read these scripts

Each scene has an ID, its fields, then dialogue. The ID becomes the scene's function name and TEXT key in the game, so no two scenes can share one. Sharing one is what made the Chapter 5 hag play in Chapter 2.

- **Scene ID:** `SC 1.03` is chapter 1, scene 3. Line IDs inside it run `1.03.010`, `1.03.020`, and so on, leaving gaps for inserted lines.
- **Fields:**
  - *Map*: the map the scene is on.
  - *Trigger*: what starts the scene, including the flags it needs.
  - *Present*: who is on screen.
  - *Music*: the cue.
  - *Goal*: what the player is trying to do.
  - *Flow*: what happens after the scene, and the flags it sets.
  - *Notes*: anything for the person building it.
- **Speakers.** **NAME** *(direction)* then the line. Direction is one or two words for tone, never a feeling the line already says.
- **Companion lines.** A line from a Herald plays only if that Herald is with you; this is the existing `cl()` helper. If you are playing that Herald in Herald Mode, the line becomes your inner thought (the `as()` helper). Write each scene so it still reads with any companion missing.
- **Conditions.** Written in brackets before a line or block:
  - `[mode: journey]`, `[mode: herald]`, `[herald: Alberica]`
  - `[flag: twins_met]`, `[not: shade_keeps_watch]`
  - `[version: frost]`, `[council: Mira]`, `[ending: third_way]`, `[loop: 1+]` (only on a second or later pass through the time loop), `[herald: not Wyn]`
- **Choices.** `▸ YOU:` lists the options. Each option names the flag it sets and where the flag pays off.
- **Length.** One message box holds two lines of about 45 characters. Write in short beats. No speech runs past four boxes without a break for action.
- **The player.** You never speak a feeling. Your choices are your voice.
- **Music.** Cues are moods. Map them to existing tracks when you build: *Rime* (cold ambient), *Hearth* (warm town), *Hunt* (tension), *Requiem* (grief), *Thaw* (wonder), *Forge* (industrial menace), *Frostmaiden* (Auril's theme), *Heralds* (the party's theme).

## Prologue: The Lantern

### SC 0.01 — Festival morning `[mode: journey]`

- **Map:** 2090 (the prologue's Rooted Hearth). **Trigger:** new game. **Present:** you, Tamsin, Hellen. **Music:** *Hearth*.
- **Purpose:** meet Tamsin and Hellen on screen; leave with the goal (the College, by the root-lift).
- **Staging:** you start on the stool at the corner table (13,5). Tamsin comes in by the street door, walks up and
  talks to you, then tows you to the bar ("Follow me"), where Hellen is. Tamsin leaves by the door at the end.

Gold light through the tavern's knot-window. It's been gold every morning of your life.

You fell asleep at the corner table again, somewhere in the middle of last night's stories.

**TAMSIN** Up! UP! \[Name\]! Wynsnow said first light, and first light was an hour ago!

*Tamsin walks up to you and hops.* Tamsin Brightrun: Hellen's kid, about your age, and set on being a Rootwarden since birth.

**TAMSIN** Yes, it's always first light. That's not the point. The point is POKÉMON.

*Tamsin leads you to the bar.* Hellen Brightrun keeps the Rooted Hearth, and nobody has ever left it hungry.

**HELLEN** *(sliding a plate over)* Eat first. Heralds didn't save the Dale on an empty stomach.

**TAMSIN** They saved it on pine-mead and spite. You told us!

**HELLEN** And I'll tell you again, with toast. Eat. Then College.

*Tamsin hops and runs out of the door.* Tamsin's gone, toast in their teeth.

*(The College of Auroral Arts is at the top of the tree. Take the root-lift from the market.)*

- **Goal:** "Get to the College at the top of the tree. Take the root-lift from the market."
- **Hellen, if you talk to her before the College:** "Eat that on the way. College. Go." / "Wynsnow won't hold a Pokémon for anybody, and you know it."
- **Lift-keeper:** "Up to the Canopy-Tier? The College is right at the top. Hold on to the rail."
- **Festival crowd** (holding the edges of town): the parade is coming through; they say where to go next (the
  lift before the College, the Hearth after the battle, the lantern stall after the mural).

* **Flow:** `intro_started`. Everything in the market is shut for the festival but the Hearth and the lift.
* **Notes:** the mural of five heroes and the small sixth figure is on the tavern's east wall. Examinable from the start (see SC 0.03).

### SC 0.02 — Three Pokémon `[mode: journey]`

- **Map:** 2092 (the prologue's College). **Present:** Tamsin, Wynsnow. **Music:** *Thaw*; Wynsnow's theme when
  you meet him; the rival's theme when Tamsin squares up.
- **Purpose:** meet Professor Wynsnow; choose your first Pokémon from his table; your first battle, against Tamsin.
- **Staging:** the east lecture room is cleared for the festival: one table with three Poké Balls (as in Oak's lab),
  Wynsnow at the blackboard behind it, potted plants either side.

*Arriving (the hall):* Tamsin, waiting in the hall, turns and sees you (!).

**TAMSIN** THERE you are! He's put them out already, \[Name\]. All three!

**TAMSIN** Wynsnow's lecture room, the east one. Come on, follow me!

*Tamsin leads you up the hall and goes in to wait by the table. Goal: "Go into Professor Wynsnow's lecture room."*

*In the doorway:* Wynsnow turns from the blackboard (!).

Professor Aldric Wynsnow, Dean of the College. You've run his errands for years.

**WYNSNOW** Ah. The errand-runner and the future Rootwarden.

**TAMSIN** I'm the future Rootwarden. \[Name\]'s the errand-runner. For now.

**WYNSNOW** Three Pokémon, three futures. Choose before I start measuring them.

**WYNSNOW** Look in each Poké Ball first, then pick one. I'll be writing all of it down.

▸ YOU: walk up to each ball. Each shows the Pokémon in its opened ball, with its cry, and Wynsnow's note:
**Switle** (Ice/Water) "Slow to get going, and nothing knocks it over." **Chikoiard** (Grass/Steel) "Leaf on top,
blades below. Mind your fingers." **Wickit** (Fire) "It will set your sleeve alight at least once. Plan for twice."
**WYNSNOW** So! You want \[it\], the \[type\] Pokémon? Yes takes it (Pokémon get, nickname); no: "Take your time.
Not all of it, mind. The lanterns go up at dusk." Leaving the room first: **WYNSNOW** (!) "Not yet! A Pokémon
first. They're on the table, errand-runner." Sets `starter`, `got_starter`.

*Tamsin (!), the rival's theme.*

**TAMSIN** Then I'll take the one that beats yours. Obviously.

*Tamsin walks to that ball and takes it. Its cry. "Tamsin received \[it\]!"*

**WYNSNOW** Obviously. Battle in the hall. Not in my lecture room. Never in my lecture room.

*Tamsin squares up in the hall; Wynsnow watches from his doorway.*

**TAMSIN** Rootwarden against errand-runner. Ready? Doesn't matter. GO!

*Battle: Tamsin (loss allowed).*

`[won]` **TAMSIN** ...Best of three. Later. That one didn't count, \[Name\]. It was practice!

`[lost]` *Tamsin hops twice.* **TAMSIN** Ha! HA! Rootwarden material. I told you. I told everyone.

*Wynsnow walks over; the party is healed (healing jingle).*

**WYNSNOW** There. Patched up. Off you go, both of you. I have measuring to do.

**TAMSIN** Hearth! Hellen's got festival cake.

**TAMSIN** And there's something on the wall I want to show you.

**TAMSIN** Come ON, \[Name\]!

*Tamsin runs down the hall and out. Goal: "Tamsin's run back to the Rooted Hearth. Take the root-lift down to the market."*

- **In a loop** (the Still Keeper's wheel; you already have your partner): your ball is gone from the table.
  **WYNSNOW** Three Pokémon, three futures. And... two balls. I counted three this morning. / **TAMSIN** *(staring at
  your belt)* Where'd you get that? You didn't have it at breakfast. Then Tamsin takes the counter and battles you.
- **Flow:** `met_wynsnow`, `got_starter`, `pro_battle_done`. The taken balls stay gone (self switch A).

### SC 0.02c — Back to the Hearth `[mode: journey]`

- **Map:** 2091 market (Tamsin waits by the lift). **Purpose:** nobody has to hunt for the way on.

**TAMSIN** *(!)* Too slow! The Hearth's this way. Follow me!

*Tamsin leads you across the market to the Hearth and goes in ahead. Sets `pro_led`. Goal: "Tamsin's at the mural in the Rooted Hearth."*

### SC 0.03 — The sixth figure `[mode: journey]`

- **Map:** 2090, the mural wall. **Trigger:** coming into the Hearth after the battle (the camera finds Tamsin at the
  far wall). **Music:** *Heralds*.

**TAMSIN** *(!)* Over here! Quick, before the cake goes.

*You walk to the wall.*

**TAMSIN** Look. Every festival I check if it moved.

Five heroes, carved in the living wood. One wreathed in snow, one in flame, one with a lute.

One with a wolf. One half in shadow, with a knife. Two dragons coil above them.

In the corner, half-hidden by a root, a small sixth figure. No face.

`[after the loop]` And a seventh: a dwarf woman made of ice, hands over her heart. / Nobody remembers carving it.

**TAMSIN** Hellen says nobody's ever known who that is. Not even the carver.

*The camera pans to the bar.* **HELLEN** *(from the bar)* The carver was my great-great-something. She said the wood grew it.

**TAMSIN** Lanterns! The stall's right outside. Come on, before they sell the good ones.

*Tamsin runs out. Goal: "Tamsin's at the lantern stall, just outside the Hearth."*

- **Hellen, after:** "There it is. Your first. Here, it can have a crust. Everyone eats in my house." / "Don't let Tamsin tell you it was a fair fight, whichever way it went." / "They're at the wall. They check it every festival."
* **Flow:** sets `saw_sixth_figure` (pays off in Chapter 6 and the epilogue).

### SC 0.04 — Reversal glass `[mode: journey]`

- **Map:** 2091 market, outside the Hearth. **Trigger:** coming out of the Hearth after the mural. **Present:**
  Tamsin (haggling at the stall), the lantern seller. **Music:** *Hearth*, then silence.
- **Goal:** none. It's a gift.

**LANTERN SELLER** Real Reversal glass! Dug out of the deep roots, where the old hag's mirrors broke!

*Tamsin turns to you.* **TAMSIN** It's not real. Everybody knows it's not real.

*Tamsin buys it anyway (the shop chime), then walks over.*

**TAMSIN** Here. For your first Pokémon day, \[Name\].

`[after the loop]` **TAMSIN** Weird. I already bought you this. Didn't I? / ...Here.

*Item get: "Tamsin gave you a lantern of Reversal glass!"*

The glass in the lantern is old, with a crack like frost.

*(Screen shake.)* The ground shudders. Once. Every lantern in the market swings. Nobody else notices.

*(Story panel S-01.)* The crack in the glass widens. Inside it, it's night.

A dock in a blizzard. Five figures coming down a gangplank.

*Panel off. Tamsin (!).* **TAMSIN** Hey... \[Name\]? What are you...

- **Flow:** fade to white; your Pokémon goes with you. Teleport to 2001 Targos pier. Sets `fell_through`.
- **Notes:** the shudder is the forge's first heat-pulse. Keep the same sound effect for every pulse in Chapter 6.

### Choosing a Herald `[mode: herald]`

Each Herald is introduced with a line about them and a line in their voice:

- **Alberica:** Dwarf bard, the Dwarf of Song. Her Pendant of Black Ice will not stay lost. "I sing, I drink, and I'm told I'm a terrible influence."
- **Reptin:** Elf druid, exile of the Sacred Flame. His Medallion of Everfrost hums near frost magic. "Leave the talking to me. Everybody loves me, eventually."
- **Alerion:** Eladrin ranger, once frozen outside of time. His Frostbound Ring knows this place. "It's cold. That's all I know."
- **Meat Meat:** Goblin rogue. Long white hair, violet eyes, other people's pockets. Hiding in Targos for weeks, running from dreams of a cold table. "Meat Meat will bite you. Fondly."
- **Wyn:** Spores druid and Rootwarden of Rootspire, 400 years after the Heralds. On watch at the Sap Gate, Wyn falls through an old mirror shard into the Heralds' own time. "...Um. Hello. Sorry. Hello."

### SC 0.05 — Wyn's watch `[herald: Wyn]`

- **Map:** 2055 Root-Tier, the Sap Gate. **Trigger:** new game as Wyn. **Music:** *Rime*.

The festival is somebody else's tonight.

You have the Sap Gate, the hum of the spores, and Sableye snoring on your boot.

**WYN** *(inner)* It's nice. Quiet. ...Um. Happy festival, everyone.

The ground shudders. The spores go silent all at once.

**WYN** *(inner)* Oh. Oh, no. They never go quiet.

In the bark of the gate is a shard of old mirror you've walked past a thousand times.

It's showing a dock in a blizzard.

**WYN** *(inner)* That's not ours. That's—

- **Flow:** same as SC 0.04; Wyn arrives with Sableye.

### SC 0.06 — The ship north `[mode: herald]` (Alberica, Reptin, Alerion)

- **Map:** ship deck backdrop. **Trigger:** new game as that Herald. **Music:** *Rime*.

`[herald: Alberica]` Karkoloch, three weeks ago. You threw the Pendant of Black Ice into the sea.

You woke with it on the pillow beside you. Most things you throw out don't come back.

*(inner)* Men, mostly.

The ship scrapes ice. Blue lanterns drift on the water.

Something too tall stands at the edge of the lamplight. When you look again, it's gone.

*(inner)* Drink first. Panic later. That's the order.

`[herald: Reptin]` The Medallion of Everfrost came wrapped in cloth. "Left for you." No name, no note.

*(inner)* Rude, frankly.

The captain watches it like it might bite. "It knows," he says, and won't say what.

*(inner)* He'll tell you by the third drink. Everybody does, eventually.

`[herald: Alerion]` You woke calling out in a voice that wasn't yours. Ice on your knuckles again.

The Frostbound Ring gets colder every mile north.

*(inner)* It's cold. That's all you know.

- **Flow:** step onto the pier, then SC 1.01. Your partner Pokémon is with you.

### SC 0.07 — Hiding in the hay `[herald: Meat Meat]`

- **Map:** 2001 Targos, behind the hay bales. **Music:** *Hunt*.

Three weeks out of the lab. Three weeks in the hay with Razzy.

Razzy can't talk any more. Razzy holds your hand all night anyway.

*(inner)* Meat Meat holds back. Meat Meat promised.

Tonight Razzy is gone. Small footprints in the snow, going north.

On the dock, five strangers come down a gangplank.

Something on them is cold. Cold like the lab.

*(inner)* Strangers have food. Maybe coffee. Meat Meat will follow them. Fondly.

- **Flow:** Meat Meat watches the Convergence from hiding and joins the party early, at the start of Chapter 2 (SC 2.01 variant). This replaces the Chapter 3 Glade meeting in this mode.

## Chapter 1: The Convergence

**Chapter goal:** meet the Heralds, learn the relics are lures, and earn Naerth's seal to leave Targos.

### SC 1.01 — Out of the air

- **Map:** 2001 Targos pier, night, blizzard. **Trigger:** arrival (autorun). **Present:** you; Alberica, Reptin, Alerion, Shade, Shimmer coming off three ships. **Music:** *Rime*.
- **Goal:** get out of the cold.

`[mode: journey]` You land on frozen planks. Snow, everywhere. The sky has no sun in it at all.

**ALERION** You fell out of the air.

**ALERION** ...Nobody else saw. Keep it that way.

**SHIMMER** Tavern's up the hill. Whatever you are, you'll freeze the same as us.

**ALBERICA** *(passing with a sea-bag)* Pretty boy's found a stray! Bring them up the hill, they'll freeze.

`[herald: Wyn]` Same, but Alberica: "Pretty boy's found someone! Bring them up the hill, darling."

`[mode: herald]` Five travellers come down three gangplanks on the same night. None of you planned it. All of you look up at the same moment, as if something called your names. Warm light spills from a tavern along the docks: Three Flags Sailing.

`[mode: herald]` **ALBERICA** Is that a tavern? That's a tavern. Out of my way, I want the stool by the fire.

`[mode: herald]` **REPTIN** *(watching the dwarf go)* First sensible thing anyone's said in Targos.

`[herald: Meat Meat]` From behind the hay bales you watch the docks. Strangers are coming up from the ships: a dwarf, an elf, an eladrin whose ring glitters like frost, two smugglers who walk like they own the place. One by one, they all head for the same warm light. *(Cold things in their pockets. Cold like the lab. Meat Meat follows cold things.) (Also, taverns have coffee. Probably. Meat Meat will find out.)*

- **Flow:** free movement; Three Flags Sailing is lit. Sets `arrived_targos`.
- **Notes:** in Journey Mode, Alerion is the first to touch you on purpose. His ring is the coldest relic and it doesn't react to you at all. That pays off in Ch13 ("you aren't on her wheel").

### SC 1.02 — The woman in frost-furs

- **Map:** 2002 Three Flags Sailing. **Trigger:** enter (autorun). **Present:** the five, you, the barkeep, the woman. **Music:** *Rime*, then *Frostmaiden* for her.
- **Goal:** none (cutscene).

A fire that barely warms. Five strangers at five tables.

*The door opens (flash, door sound).* The door opens and lets the night in. A woman in furs that shine with frost.

*She walks up between the tables (P-AUR-01).* She doesn't go to the bar. She doesn't go to the fire.

*A chill (B-06) over each Herald as she turns to them.* She looks at each of them in turn. Alberica's hand goes to her throat. Reptin's medallion fogs. Alerion's ring cracks with rime. Shimmer stops breathing.

`[mode: journey]` Then she looks at you. She tilts her head, like you're a word in a language she almost knows.

`[mode: herald]` She looks at you last, and longest.

She smiles. Not warm. Not kind.

*Frost spreads where she stood (E-01) and she's gone (P-AUR-04).* The frost stays on the floor where she stood. The door swings shut on nothing.

**BARKEEP** Drinks are on the house. Please leave tomorrow.

**ALBERICA** Free drinks. See? The night's turning around already.

**REPTIN** *(to the barkeep)* That's very generous, thank you. We'll be gone by noon.

**REPTIN** Probably. Ask me again after the drinks.

`[herald: X]` When you play one of the five, "your hand / your medallion / your ring" in the narration.

- **Flow:** SC 1.03 follows immediately.
- **Notes:** this is Auril. Nobody names her until Ch2's lottery, when Alberica sees her again and Duvessa's priest says what she is.

### SC 1.03 — Five cold things

- **Map:** 2002. **Trigger:** follows 1.02. **Present:** the party. **Music:** *Heralds* (quiet).
- **Goal:** introductions, and the first shared question.

`[herald: Meat Meat]` You slip in behind them and find a shadow by the wall. Nobody notices a goblin in a shadow. **SHADE** ...Except me. Hands where I can see them, little one. Sit. You're shaking worse than we are. *(The smuggler smells like the sea. Meat Meat decides not to bite the smuggler. Yet.)*

**SHADE** Well. That was a terrible omen. I'm Shade. This is my sister, Shimmer. We're in shipping.

**SHIMMER** Smuggling.

**SHADE** Smuggling is a kind of shipping.

**ALBERICA** Alberica. I sing, I drink, and I'm told I'm a terrible influence.

`[herald: Alberica, quiet]` "...Alberica. I sing."

She sets a pendant of black ice on the table.

**ALBERICA** I threw this in the sea three weeks ago. It came back.

**ALBERICA** Most things I throw out don't come back. Men, mostly.

**REPTIN** Reptin. I talk us into places and, now and then, out of them.

A frost-etched medallion, beside the pendant.

**REPTIN** Someone left this for me. No name, no note. Rude, frankly.

A silver ring, rimed white, beside that.

**ALERION** Alerion. It was on a dock rail. It's cold. That's all I know.

**ALBERICA** That's all? Pretty boy, you have to give us more than that.

**ALERION** No I don't.

`[herald: Alerion, quiet]` "...That's all I have. Sorry."

**SHADE** And this turned up in my boot. I don't own boots this nice.

A pale dagger, smoking with cold.

**SHIMMER** I've got a stone. It's under my ribs. Don't ask.

**ALBERICA** Oh, now I have to ask.

**SHIMMER** Don't.

*A chill (B-06) over all five at once.* Four relics on the table, and the stone under Shimmer's ribs makes five. They hum together, like a chord.

**REPTIN** They know each other. That's either very good news or the start of a ghost story.

**ALERION** Ghost story.

**ALBERICA** I don't need it to make sense. I need it to stop.

**ALBERICA** ...And I need another drink.

`[mode: journey]` **SHADE** *(to you)* And you? You came off no ship I saw.

> **Choice: "What do you do?"** Show your Pokémon / "I'm from somewhere else." / Say nothing
>
> - **Show your Pokémon.** REPTIN: "Good instinct. Nobody distrusts someone with a Pokémon that cute." *(to your Pokémon)* "Hello, little ambassador." Sets `told_nothing`.
> - **Somewhere else.** ALERION: "Clearly." ALBERICA: "Ignore him, he's like that with everyone. It's part of the charm. Allegedly." Sets `told_somewhere`.
> - **Say nothing.** SHIMMER: "Good. Keep doing that." ALBERICA: "She likes you. That's how you can tell." Sets `told_nothing`, `shimmer_warm`.

**SHADE** There's a relic dealer down by the water. Epheris. If anyone knows what these are, he does.

**REPTIN** Leave the talking to me. Epheris will love me. Everybody does, eventually.

`[herald: Reptin, quiet]` "I'll talk to him. Politely."

**ALERION** Everybody leaves eventually, too.

**ALBERICA** *(raising her mug)* To bad omens and free drinks.

Shimmer touches her mug to Alberica's without looking up. Alerion, after a moment, does too.

- **Flow:** sets `met_party`. Companions: Alberica, Reptin, Alerion, Shade, Shimmer (minus your Herald). The tavern NPCs of the five are removed. Shows the "Heralds" chat tip after the scene, not during.

### SC 1.04 — Made to be found

- **Map:** 2006 Thornweald's Relics. **Trigger:** talk to Epheris with `met_party`. **Present:** Epheris, party. **Music:** *Hunt*.
- **Goal:** find out what the relics are.

**EPHERIS** Put those down. Not on the counter. On the floor.

**REPTIN** *(setting the medallion down very gently)* Of course. So sorry. Is the floor also cursed?

**EPHERIS** Five people. Five cold trinkets. All found where you'd find them, right when you'd find them.

**EPHERIS** That's not luck. That's bait.

**ALBERICA** Bait for what?

**EPHERIS** For you. Somebody wanted you here.

He holds a compass needle over the pendant. It swings south-east, and stays there.

**EPHERIS** And they want you closer still. South-east is Dougan's Hole.

**EPHERIS** Nothing in Dougan's Hole but ice, and people who don't like you.

**ALERION** Someone went to a lot of trouble.

**ALBERICA** Pretty boy's right. Nobody leaves me presents unless they want something.

**SHIMMER** Then that's where it is.

**EPHERIS** Take this. I used to catalogue relics for men in towers.

**EPHERIS** Catalogue something alive, for a change.

*You received the Pokédex!*

**EPHERIS** It lives in your pack now. Open it from your menu whenever you like.

- **Flow:** gives the Pokédex. Sets `relics_are_lures`, `got_pokedex`. Opens the party's goal line in the Heralds menu: "Find who's calling us. South-east."

### SC 1.05 — Everyone owes me something

- **Map:** 2004 Luskan Arms. **Trigger:** try the south gate, then visit Naerth. **Present:** Naerth, Skath. **Music:** *Hunt*.
- **Goal:** get permission to leave Targos.

**GUARD** Lottery season. Nobody leaves Targos without the Speaker's seal.

**GUARD** He's at the Luskan Arms most nights. Doing business.

**GUARD** Ask him nicely. He likes nicely.

**NAERTH** My honoured guests. Five strangers in a blizzard. Shall we speak plainly?

**NAERTH** Here is how Targos works. Everyone owes me something.

**NAERTH** Each new moon, Ten-Towns draws a name. Whoever's drawn walks out onto the tundra.

**REPTIN** *(under his breath)* And everyone thanks him for the privilege. Charming.

**NAERTH** People who run before the draw get found. By a man who doesn't feel the cold.

**SHIMMER** Sephek.

**NAERTH** ...You know his name. Interesting.

**NAERTH** My seal says you aren't running. Earn it. Town Hall. I'll be waiting.

**ALBERICA** Men like him are always waiting. It's the only exercise they get.

`[before met_party]` **NAERTH** Strangers. I see a great many strangers, and they all want something from me. Go and get warm first. Then we'll talk.

- **Flow:** opens Town Hall (Gym 1). Sets `naerth_terms`.

### SC 1.06 — Gym 1: Speaker Naerth

- **Map:** 2005 Town Hall. **Trainers:** Zhentarim Ilsa, Corrin, Mara; then Naerth (Grimer, Murkrow, Houndour-Koffing fusion). **Music:** gym theme.

`[herald: Reptin]` **NAERTH** Reptin of the Sacred Flame. I hear things about you. Useful things.

**NAERTH** Everyone in this town fights for me. Let's see who you fight for.

**ALBERICA** Knock his crown off, sweetheart. I'll sing about it after.

`[herald: Alberica]` *(Knock his crown off. Then write a song about it. A rude one.)*

`[herald: Reptin]` *(Diplomacy is just threatening people politely. Time to be very polite.)*

*Battle: Speaker Naerth.*

**NAERTH** Fine. You're not running. You're walking toward something. That's worse.

**NAERTH** Here. My seal. Any guard on the lake will let you pass.

*You received the Speaker's Seal! (TM46)*

**NAERTH** That TM teaches Thief. Fitting, for this town.

**REPTIN** Thank you, Speaker. We'll treasure it. *(under his breath)* Right up to the gate.

**NAERTH** One more thing, free. A lady in a tower pays very well for cold trinkets like yours.

**NAERTH** Pale. Books and bones. If you meet her, you never met me.

**ALERION** We never met you. That part's easy.

**NAERTH** Since you're going out into the Dale, take these. DNA Splicers.

**NAERTH** Two Pokémon in, one comes out. Twinning, the traders call it. You've seen what mine can do.

**NAERTH** Splice again to pull them apart. Triglio's shop stocks them now. He'll still charge you.

`[after]` **NAERTH** You have my seal. Don't make me regret it. And mind the north road. There's a killer in the Dale. Auril's own, some say. Sephek Kaltro. If you meet him, you never had my seal.

- **Flow:** Speaker's Seal (`badge_targos`), TM46 Thief, 3 DNA Splicers ("Twinning, the traders call it"). The south gate opens (switch 3910). Marts sell Splicers.
- **Notes:** "books and bones" is Avarice. Meat Meat says it again in Ch3, and it's her lab in Ch8.

### SC 1.07 — The one we lost

- **Map:** 2002, night, after the gym. **Trigger:** rest at the tavern. **Present:** Shade, Shimmer, you. **Music:** *Hearth* (low).
- **Goal:** none. Character.

**BARKEEP** You've the Speaker's seal and the look of people leaving at first light.

**BARKEEP** One more night by the fire?

▸ *Rest at Three Flags Sailing?* (Yes heals the party.)

Late. The fire's down to coals.

**ALBERICA** *(stretched out along a bench)* Night, pretty boy. Dream of me.

**ALERION** I don't dream.

**ALBERICA** Then think of me. Same thing, done awake.

**REPTIN** *(face in his cloak)* Goodnight, everyone. Please. Goodnight.

Across the hearth, Shimmer turns a little carved wooden cat over and over in her fingers.

**SHADE** She does that when she's scared.

**SHIMMER** I'm not scared. I'm counting.

**SHIMMER** Shade carved it, when we were kids. Terrible cats. They always wanted to be one.

**SHADE** I still do. Cats land on their feet.

**SHIMMER** Cats get nine lives. You've used about six.

**SHADE** *(quietly)* Saltmarsh was one of them. Yours, not mine.

**SHIMMER** ...Go to sleep, Shade.

`[after]` **BARKEEP** Leaving tomorrow, I hope. For your sakes, not mine.

- **Flow:** sets `heard_of_glimmer`. Pays off in Ch3 (Luna Carver: "your house has a spark that isn't out") and Ch6, when Shade steps through Brightmane's mirror and comes back as Glimmer, a cat-man, holding up this same carved cat.
- **Notes:** there is no brother. The carved cat is the foreshadowing: Shade always wanted to be a cat, and becomes one. "Saltmarsh... yours, not mine" is the first hint of the night Shade pulled Shimmer out of the white (and found the unicorn's horn). Don't explain it here.

### SC 1.08 — The widow's light (optional)

- **Map:** 2008 Fisher's Cottage. **Trigger:** talk to the widow. **Music:** *Requiem*.

**WIDOW** He went fishing near Dougan's Hole. They heard laughing out on the ice. Then nothing.

**WIDOW** Take his Spheal. It sits by the door every night. It shouldn't have to wait alone.

`[party full]` **WIDOW** Oh... you've no room for her. Come back when you do.

`[after]` **WIDOW** My husband's Spheal... is she well? Good. He'd have liked you.

`[flag: husband_thawed]` **WIDOW** ...Alive? He's alive? Out on the ice at Dougan's Hole, all this time? He said to keep the lamp lit. He always says that. He always says that. *She's laughing and crying at once. By the door, the little Spheal wriggles. It would be wagging, if it had a tail.*

- **Flow:** gives Spheal Lv 6. Sets `widow_spheal`. Pays off in SC 4.09 (the husband thaws) and Ch9 (he's among the refugees).

## Chapter 2: Lottery Night

**Chapter goal:** reach Bryn Shander and earn Duvessa's seal. On the way the party saves Razzy, and in town the party learns that Auril has marked one of them.

### SC 2.01 — The north road

- **Map:** 2010 Bryn Shander Road. **Trigger:** enter (autorun). **Present:** party. **Music:** *Rime*.

The road north is a white line between black pines.

Behind you, the lanterns of Targos shrink to sparks.

**ALERION** Single file. The drifts hide holes.

`[herald: Alerion, quiet]` "...Single file."

**SHIMMER** My stone's humming. It never hums.

**SHADE** You hum all the time.

**SHIMMER** I'm in tune. It isn't.

**ALBERICA** Darling, nobody's in tune at this temperature.

`[herald: Meat Meat]` You've followed Razzy's footprints all night. The strangers from the dock are on the same road. They have food. Razzy would want you to ask.

`[herald: Meat Meat]` **SHADE** A goblin. Following us. Hungry, or friendly?

`[herald: Meat Meat]` ▸ YOU: *"Both. Meat Meat is looking for Razzy."* (the only option) **SHADE** ...Fair answer. Walk with us, then. Nobody should be out here alone. **REPTIN** Who's Razzy? *(Small. Green. Can't talk any more. Holds Meat Meat's hand at night. Meat Meat doesn't say any of that. Meat Meat just walks.)* **ALBERICA** Sweetheart, you're blue. Here. Scarf. Don't argue. Meat Meat joins here instead of in Chapter 3. Sets `meat_meat_joined`.

### SC 2.02 — A voiceless goblin

- **Map:** 2010, trigger row at y = 42. **Present:** party, Razzy. **Music:** *Hunt*.
- **Goal:** follow him.

A small goblin bursts out of the snow. Thin. A pale scar across his throat.

Green light moves under his skin, like veins.

He grabs Reptin's sleeve and pulls.

**REPTIN** Hello, little one. You're freezing. Here, take my...

`[herald: Reptin, quiet]` "You're freezing. Here..."

He opens his mouth. No sound comes out.

He points east, at a crack in the snow glowing blue-white. Then he runs.

**SHADE** That's either a trap or a kid. Those look the same from here.

**ALERION** Kid. Traps don't shiver.

`[herald: Meat Meat]` *(Razzy. Razzy! Razzy, no, not that way...)*

- **Flow:** sets `met_razzy`. `razzy_block` turns you back at y = 33 until the egg is taken: Reptin says "We can't leave him down there."
- **Notes:** the green light under his skin is the wyrm-blood Avarice put in him. Hold the explanation for Ch3 (Meat Meat) and Ch8 (the lab).

### SC 2.03 — Frost-light *(unique ID: `scene_frostlight_enter`)*

- **Map:** 2011 Frost-Light Chasm. **Trigger:** enter. **Present:** party; Aurilite harvesters Siv and Orla. **Music:** *Frostmaiden* (faint).

Blue light seeps out of the ice like breath.

Two figures in white robes chip at it with bone picks.

**SIV** Her light. Every crumb belongs to her. You don't.

**REPTIN** *(under his breath)* Zealots with picks. My favourite.

**ALBERICA** Sugar, nobody belongs to anybody. Step aside.

- **Flow:** trainer battles Siv and Orla.
- **Notes:** this must not share a function or cutscene key with SC 5.02. Rename the Chapter 2 version and keep the Chapter 5 one as `scene_cackling_enter`.

### SC 2.04 — Shell of light

- **Map:** 2011, event "Frost-light". **Trigger:** reach the glow. **Present:** party, Razzy. **Music:** *Requiem*.
- **Goal:** save him.

*Razzy at the lip of the crack (K-RZY-02).* Razzy stands at the lip of the crack, where the light is brightest.

He looks back at you. Almost smiling.

*Shake.* Then the ice gives.

*The light closes into a shell (E-03).* He doesn't fall far. The light catches him and closes, like hands.

When it stops, a shell of frost sits in the crack. Inside it, slow and green, something beats.

**REPTIN** He's alive. The light's... keeping him.

**ALBERICA** Then we get him back. Tell me how, and I'll do it.

The medallion on Reptin's chest pulls toward the shell.

**REPTIN** It wants blood. Mine. Of course it does.

`[herald: Reptin, quiet]` "...It wants my blood."

> **Choice: "What do you say?"** "Do it." / "Wait..."
>
> - **"Do it."** Sets `razzy_bloodwarm`.
> - **"Wait..."** REPTIN: "There's no waiting in this cold." He does it anyway.

*Reptin's palm to the shell (P-REP-02).* Reptin cuts his palm and presses it to the shell. The frost drinks it.

The shell softens. It isn't enough.

**SHADE** *(digging in a pack)* I've carried this since the Saltmarsh job. A unicorn's horn.

**SHADE** Never knew why I kept it.

*Shade holds it out (P-SHA-02); green flash; the shell rounds into an egg (K-EGG-01).* Shade lays the horn against the shell. It melts in, like snow into a hand.

The shell rounds into an egg, warm and green-gold.

**REPTIN** One more thing. The old rhymes want a name, spoken as a promise.

**ALBERICA** And none of us knows his.

**ALERION** Then we find someone who does.

`[herald: Meat Meat]` *(Razzy. His name is Razzy. Meat Meat promises.)* You say it out loud, to the egg. The egg warms against your chest. **ALBERICA** *(very softly)* ...Oh, sweetheart.

- **Flow:** receive the Moon-Touched Egg (key item). Sets `razzy_egg`. In Meat Meat mode also sets `razzy_named`.
- **Notes:** the horn is used up here. Later lines that mention it (Ch6) must say it's gone into Razzy.

### SC 2.05 — The board in the square

- **Map:** 2012 Bryn Shander. **Trigger:** enter (autorun). **Present:** party, townsfolk. **Music:** *Rime*.

New walls of raw log. Zhentarim gold, everyone says. Nobody says it loudly.

In the square, a board lists every name in town. Tomorrow is the new moon.

**GUARD** Draw's at sundown. Speaker says nobody leaves on a draw night. Nobody.

**SHIMMER** They've added travellers.

**ALBERICA** We're on it?

**SHIMMER** Everyone's on it.

**REPTIN** How democratic.

`[flag: kip_list]` **ALBERICA** ...Kip's list. Three names on this board have never once been drawn. Not in two years. **SHADE** Funny how luck works. **REPTIN** Luck and bribery. Same family. Different hats. Sets `lottery_rigged`.

- **The Northlook's keeper:** "The Northlook. Warmest beds in Bryn Shander. Coldest company." / "You'll want to be off the street before the draw. Or on it. Some folk watch." ▸ *Rest until sundown?* (Yes heals, and goes out to the square for the draw.)
- **Duvessa, before the draw:** "It's a draw night. The hall's closed until it's done. Come back after. If you still want to." Without Naerth's seal: "Bryn Shander's seal doesn't go to strangers with no name in the Dale. Get Naerth's first. Then come back."

* **Flow:** sets `bryn_arrived`. Duvessa's Town Hall is closed until after the draw: "Come back after. If you still want to."
* **Optional:** with Kip's list from Targos (`kip_list`), Alberica notes three names that are never drawn. Sets `lottery_rigged`.

### SC 2.06 — Lottery night

- **Map:** 2012, night, new moon. **Trigger:** rest at the Northlook, or talk to the guard at dusk. **Present:** party, Duvessa, crowd, Weaver Brenna and her daughter Ilda, Mishann, the woman in frost-furs. **Music:** *Rime*, then *Frostmaiden*, then *Heralds*.
- **Goal:** none at first. Then, whether to stand with Alberica.

*Night tint; Duvessa, the crowd, Ilda and her mother, the party all on stage.* The square at sundown. Torches. A bowl of wooden tokens.

**DUVESSA** Ilda Weaverson.

*A chill (B-06) over her mother.* A girl of twelve. Her mother makes a sound like something breaking.

*The crowd backs away.* The crowd steps back from them. Nobody looks up.

**ALBERICA** No. Absolutely not.

`[herald: Alberica, quiet]` "...No."

*Alberica walks up two steps and turns to the crowd.* Alberica climbs up where the whole square can see her.

She pulls the Pendant of Black Ice out of her coat.

**ALBERICA** Look at me. All of you. You remember the last summer.

**ALBERICA** The trout jumping. Bread you didn't have to count.

**ALBERICA** Your kids asleep in a warm room. Remember it. Hold on to it.

*White flash; warmer tint; a balloon over every face in the crowd.* The pendant burns white-hot and cold at once.

The square fills with things that aren't there: cut grass, a lullaby, somebody's laugh.

Every face in the crowd changes.

`[flag: lottery_rigged]` **ALBERICA** And three of you have never once been drawn. Ask yourselves why.

> **Choice: "What do you do?"** Stand beside Alberica / Watch the crowd's edge *(as Alberica: Keep singing / Look for her at the crowd's edge)*
>
> - **Stand beside Alberica.** +1 Wheel. You climb up beside her. The crowd moves toward Ilda instead of away. Sets `stood_with_alberica`.
> - **Watch the crowd's edge.** At the back of the crowd, where the torchlight gives out: a woman in frost-furs. She isn't watching Ilda, or the Speaker. She's watching Alberica. Sets `saw_auril_bryn`.

*The crowd closes in.* The crowd closes around Ilda and her mother. Nobody gives her up.

**DUVESSA** ...No walk tonight. Go home. All of you.

**REPTIN** *(quietly)* Remind me never to argue with you in public.

**SHADE** Too late. You already have.

At the edge of the torchlight, the woman in frost-furs. She looks only at Alberica.

`[after the loop]` **ALBERICA** *(a hand on her chest before anything happens)* I know this part. I hate this part.

*The rune (E-02) on Alberica's chest; she clutches it (P-ALB-04).* Alberica gasps and claws at her chest.

Through her coat, a mark glows blue: a snowflake, cut by a crown.

**MISHANN** That's Her. The Frostmaiden. Auril.

*Frost (E-01) and the woman is gone (P-AUR-04).*

**ALBERICA** ...Something's pulling me north. Don't make a thing of it.

`[herald: Alberica, quiet]` "...I'm fine. Don't look at me like that."

**ALERION** You're not fine.

**ALBERICA** Pretty boy, I'm gorgeous. Fine is a step down.

- **Flow:** sets `lottery_stand`, `alberica_marked`, `auril_named`. The rune is a permanent overworld detail on Alberica's sprite if art allows.
- **Notes:** the crowd must be visibly saved. No death on screen. If `lottery_rigged`, Alberica adds: "And three of you have never once been drawn. Ask yourselves why."

### SC 2.07 — Like weather

- **Map:** 2012. **Trigger:** follows 2.06. **Present:** party, Sephek. **Music:** *Frostmaiden*.

*Sephek walks down into the square.* A man walks into the square in shirtsleeves. No coat.

Snow doesn't settle on him. His footprints don't stay.

**SEPHEK** A town that keeps its name owes her one. I'm sorry. She'll take what's hers.

*A chill (B-06) over Shimmer.* He looks past Ilda. Past Alberica. At Shimmer.

**SEPHEK** The Frostmaiden sends her regards. To the girl with the stone.

**SHIMMER** Tell her I said no. Again.

**SEPHEK** Tell her yourself. I'll be in Lonelywood.

**SEPHEK** Come before the next moon, or I choose someone from this square instead.

*He walks back out the way he came.* He walks out through the north gate. The guards step aside for him like he's weather.

**SHADE** *(very quiet)* ...Shimmer.

**SHIMMER** I know.

- **Flow:** sets `seen_sephek_bryn`. The party's goal line updates: "Sephek. Lonelywood. Before the next moon."

### SC 2.08 — Gym 2: Speaker Duvessa Shane

- **Map:** 2015 Town Hall. **Trigger:** morning after the lottery. **Trainers:** Fenn, Corvin, Isolde; Duvessa (Steel/Normal fusions). **Music:** gym theme.

**DUVESSA** I made a bad bargain to keep this town alive.

**DUVESSA** Last night you made me break it. Show me it was worth it.

**REPTIN** *(under his breath)* That was a compliment. Probably.

*Battle: Speaker Duvessa.*

**DUVESSA** Take the seal. Go after him.

**DUVESSA** And if you can end this, I'll owe you every name on that board.

*You received the Palisade Seal! (TM118)*

**DUVESSA** That TM teaches Steel Wing. Fitting for a town that's all walls and debts.

`[after]` **DUVESSA** You have the town's seal. Go after him. The north gate's open.

- **Flow:** Palisade Seal (`badge_bryn`), TM118. The north gate opens (switch 3913).

### SC 2.09 — The Morninglord's acorn

- **Map:** 2019 House of the Morninglord. **Trigger:** talk to Mishann after the gym. **Present:** Mishann, Reptin. **Music:** *Thaw* (faint).

`[flag: razzy_egg]` **MISHANN** You gave blood to something the cold had taken. It's still on your hand.

She presses something into Reptin's palm: a golden acorn.

**MISHANN** A priest in the south gave this to our order, long ago.

**MISHANN** "Carry it north," he said. "It was always meant to go north."

**MISHANN** I think he meant you.

**REPTIN** That's very generous. Thank you. ...What does it do?

**MISHANN** I don't know. Plant it somewhere the sun can't reach.

**MISHANN** See what it does out of spite.

**ALBERICA** Oh, I like her.

- **Mishann, any other time (heals you):** "Come in out of the dark. The Morninglord turns no one away. Sit by the fire a moment. Your Pokémon too." / "There. The dawn comes back, you know. Even here. It always comes back."

* **Flow:** Golden Acorn (key item). Sets `golden_acorn`.
* **Notes:** in your notes this acorn came from a Lathander temple. Mishann serves Amaunator, the Morninglord, and bristles at being mistaken for Lathander's priest. Keep her line about the priest "in the south" so both fit.

## Chapter 3: Shimmer's Requiem

**Chapter goal:** reach Sephek before the next moon. Instead, Shimmer goes alone, and the party has to live with what she chooses.

### SC 3.01 — What she carried

- **Map:** 2020 Lonelywood Road. **Trigger:** enter (autorun). **Present:** party. **Music:** *Rime*.

Bare footprints in the snow. They don't sink.

**SHIMMER** Those are his. Aren't they.

**SHIMMER** You should know why he wants me.

**SHIMMER** Saltmarsh. A job. A stone in a box. I opened the box, and she came in.

**SHIMMER** One night, she wore me like a coat. A ship froze solid around us.

**SHADE** *(quietly)* You told me it was a storm.

**SHIMMER** It was a storm. Hers. You came into it after me anyway. Dragged me out by the hair.

**SHIMMER** I got out. The stone didn't. It's still in here. A door she left open.

**SHADE** Why didn't you tell me?

**SHIMMER** You'd have tried to fix it.

**ALBERICA** So she wants a coat again. And she's trying me on for size.

**REPTIN** Then she'll find out what we all know. Nobody's ever made you fit anything.

- **Flow:** sets `shimmer_confessed`. The Heralds menu adds a note: "Auril wears people. She calls them vessels."

### SC 3.02 — Nimsy's attic

- **Map:** 2027 Speaker Huddle's House. **Trigger:** talk to Nimsy. **Present:** Nimsy, party. **Music:** *Hearth*.

`[arriving in Lonelywood]` Lonelywood: timber houses in a crescent on the shore of Maer Dualdon. Four piers run out into the ice. The forest presses in behind. Smoke rises from a green-roofed house. Someone in there is baking. **ALBERICA** Is that... cinnamon? In Icewind Dale? Somebody marry me. **ALERION** No. **REPTIN** He means congratulations. **SHIMMER** He means no.

**NIMSY** Oh! Visitors! Come in, come in, mind the little ones.

**NIMSY** Cookie? They're shaped like halflings. That's the joke.

**NIMSY** I'm Nimsy Huddle. I speak for Lonelywood, for all the good it does us.

**ALBERICA** Darling, you've just become my favourite Speaker in the Dale.

**NIMSY** The attic's yours. House rule in Lonelywood: nobody asks about anybody's past.

**SHIMMER** Perfect.

**SHADE** She means it. That's the first time I've heard her mean it.

▸ *Rest in Nimsy's attic?*

`[later rests]` **NIMSY** Sleep well! Mind the low beam.

`[first rest after 3.03, once]` **MEAT MEAT** Attic is warm. Meat Meat approves. Where is the coffee? **ALBERICA** Asleep, sweetheart. Like you should be. **MEAT MEAT** Meat Meat does not sleep. Meat Meat waits for coffee. **ALERION** She's asleep. **SHADE** *(by the window)* ...Go to sleep, all of you. I'll watch. Sets `attic_banter`.

- **Flow:** rest point. Resting starts SC 3.03.

### SC 3.03 — The empty bedroll

- **Map:** 2027, night. **Trigger:** rest. **Present:** party, minus Shimmer. **Music:** *Requiem* (quiet).

The attic is warm. Below, the fire ticks as it cools.

One by one, the party falls asleep.

...

Morning. Shimmer's bedroll is empty.

On the pillow: a note, and the carved wooden cat.

**SHADE** *(reading)* "He said before the next moon, or he picks someone else."

**SHADE** "I'm not letting him pick. Don't follow. Keep the cat. S."

**SHADE** *(very quiet)* ...She always does this.

- **Flow:** SC 3.04 starts at once.

### SC 3.04 — The third way (vision)

- **Map:** vision backdrop: the Glade of the Unmade, full moon. **Trigger:** follows 3.03. Alberica's pendant pulls everyone into it. **Present:** Shimmer, Sephek; the party as watchers who can't act. **Music:** *Requiem*.
- **Goal:** none. You watch.

Alberica's pendant flares and cracks.

The room goes white. Then you're all somewhere else, and none of you can move.

A stone circle in the birches. Snow falling without a sound.

Shimmer lies on a slab older than names, bound in cords of living ice.

Above her floats a sphere of ice veined with black: the Heart of Winter.

It beats to someone else's pulse.

**SEPHEK** She forgives, Shimmer. Take her back into you. Let the Dale breathe.

**SEPHEK** You won't be a prison this time. You'll be a queen.

**SHIMMER** I've carried her once. I watched the world burn white because of it.

**SHIMMER** This isn't salvation. It's surrender.

**SEPHEK** Then you leave her no choice.

**SHIMMER** You gave me two paths, Sephek. Damnation, or servitude.

**SHIMMER** You forgot. There's always a third way.

She closes her eyes. In her chest, something cracks like ice on a lake: the stone.

Above her, the Heart of Winter screams.

**SHIMMER** Do it. If she needs blood, let it be mine. But not for her.

**SHIMMER** For them.

The blade falls. White fire. When it fades, there is no body.

Only a rose, frozen in bloom, growing out of the stone.

Beside it, a heart of ice beats once, and breathes out mist.

Sephek falls to his knees. He's weeping.

**SHIMMER** *(from nowhere, very softly)* Not all fire dies. Some of it just learns to freeze.

You're back in the attic. Alberica's pendant is gone. The rune on her chest isn't.

**SHADE** ...No. No, no, no.

**ALERION** East. The vision was east. The old logging road.

`[herald: Alerion, quiet]` "...The logging road. East."

**ALBERICA** Shade. Look at me. We go together. Nobody goes alone.

Outside, under the window, a tall figure with long ears and a lantern waits in the snow.

- **Flow:** Shimmer leaves the companions. Sets `shimmer_taken`. Alberica's pendant is gone. Her rune stays.
- **Notes:** this is the emotional centre of Act I. No battle music for at least the next two scenes. Every Herald's echo of Shimmer (warmth where there shouldn't be) begins here. Show them as small overworld effects later: Alerion's cloak never frosts; Reptin leaves dry footprints.

### SC 3.05 — The Glade

- **Map:** 2026 Glade of the Unmade. **Trigger:** enter. **Present:** party; Meat Meat (all modes except Meat Meat Herald Mode); Jet Sentry. **Music:** *Requiem*.
- **Goal:** take Shimmer's heart; meet Meat Meat.

The rose. And beside it, the heart of ice, beating once a minute.

You touch it. For a moment you see a girl in the wind with her arms open, smiling.

**SHADE** I'm not leaving her here.

*You take Shimmer's Heart of Ice.* Sets `heart_of_ice`.

Behind the altar, a bundle of furs sneezes.

A goblin, half frozen, chewing mushroom jerky. Long white hair stiff with frost.

Cracked goggles. Violet eyes. A pack bigger than she is.

**MEAT MEAT** Meat Meat dreamed Razzy fell into cold light.

**MEAT MEAT** Meat Meat followed the dream. Dream was wrong place. Rude dream.

She sees the egg in Reptin's arms and goes very still.

**MEAT MEAT** ...Razzy?

The egg warms so suddenly it nearly slips.

**MEAT MEAT** That is Razzy. Razzy not dead. Just very cold. Meat Meat promises.

**REPTIN** "A name, spoken as a promise." ...That's it. That's the rite.

`[herald: Reptin, quiet]` "...A name, spoken as a promise."

**MEAT MEAT** Razzy and Meat Meat ran away together. From a cold table.

**MEAT MEAT** From the lady with books and bones. She took Razzy's voice.

**ALERION** Naerth's "pale lady".

**MEAT MEAT** Meat Meat comes with you now. Meat Meat is not asking.

**ALBERICA** Oh, I love her. Can we keep her?

**MEAT MEAT** Meat Meat will bite you. Fondly.

**REPTIN** She's saying she's grateful.

**MEAT MEAT** Meat Meat is saying the other thing. Also: who has coffee?

`[herald: Meat Meat, or Meat Meat already joined in 2.01]` Under your coat, the egg's heartbeat answers the heart of ice, beat for beat. **MEAT MEAT** Razzy can hear her. Razzy is being very brave.

**JET SENTRY** I tracked the cold man here. I was too late for her.

**JET SENTRY** The Circle wants that heart.

**JET SENTRY** And the man who took her waits at our Moon Temple for it.

- **Flow:** Meat Meat joins. Sets `meat_meat_joined`, `razzy_named`. Remove the Glade's Meat Meat event.
- **Notes:** her full origin, Subject V-7, is the secret kept for Act II: the driftwood chest in Rootspire, then the lab in Chapter 8.

### SC 3.06 — Boss: Sephek at the Moon Temple

- **Map:** 2023 Moon Temple. **Trigger:** enter with `heart_of_ice`. **Present:** party, Sephek. **Music:** *Frostmaiden*, then boss theme.

`[arriving at the Moon Temple grounds]` The path climbs to a shrine of old stone arches, half buried in snow. Spirals glow faintly on every post. Below the arches, a timber lodge with a root-grown door breathes out warm air. Mint, and earth. **MEAT MEAT** Rabbit Lords live here. Meat Meat will be very polite. Very. **REPTIN** Leave the talking to me. Rabbits love me. Everybody does, eventually. **SHADE** Talk later. He's here. I can feel it.

The wind stops. Between the arches, a man in a thin linen shirt is waiting.

His eyes are still red.

**SEPHEK** Give me the heart, and the Frostmaiden forgets your names.

**SHADE** You killed my sister.

**SEPHEK** *(quietly)* She killed herself. I only held the knife. I'm sorry. Give it to me.

**ALBERICA** *(a hand on Shade's arm)* Not alone, sweetheart. Not this time.

- **Battle:** Sephek (fusions, Lv 22–25). Losing re-arms the fight on the temple map.

**SEPHEK** ...So cold. Why is it so cold? The cold never touched me...

Ice closes over him where he kneels.

In his chest, a sliver of blue light still beats. Slow as a sleeper.

**ALERION** He's not dead. He's waiting.

`[herald: Alerion, quiet]` "...He's waiting."

**SHADE** Then let him wait. Forever, if it's up to me.

- **Flow:** sets `sephek_frozen`. The Wennen haul his frozen body south on a sledge (SC 3.08), and inside the Wall it becomes the Halo's "Frost Saint" relic (Ch6).

### SC 3.07 — The Moon Requiem

- **Map:** 2022 Wennen Warren, the Undying Rose chamber. **Trigger:** speak to Zenith Abbott with `heart_of_ice` and `sephek_frozen`. **Present:** party, Zenith, Luna Carver, Wennen chorus. **Music:** *Requiem* into *Thaw*.

`[entering the Warren]` The tunnel widens as it goes down: round halls of pressed clay, ribbed with white roots. Fungal veins glow along the walls. Driftwood lanterns burn amber. It's warm. Tall figures with long ears watch you pass. The Circle of Thirteen. Waiting. Judging. **MEAT MEAT** Meat Meat smells coffee. Rabbit coffee. Meat Meat will find it. **REPTIN** Please don't steal from the moon-keepers. **MEAT MEAT** Meat Meat borrows.

`[before the heart]` **ZENITH** Moon above, roots below, what was given, the rose will know. *(The tall Wennen in green robes speaks only in verse. You think she means: bring what Shimmer left at the Glade.)* `[before Sephek]` **ZENITH** The hand that struck still seeks the heart. Meet him under the moon. Then come back to me.

**ZENITH** A heart that chose. A rose that would not close.

**ZENITH** An egg that fell when winter first arose.

**LUNA CARVER** The night the Rime began, the Frostmaiden's roe flew over us.

**LUNA CARVER** Something fell. An egg, cold all through. It never woke. We kept it anyway.

**LUNA CARVER** It needed a heart. Now one has come.

Shade lays Shimmer's heart beneath the Rose, beside a pale-blue egg.

The Wennen thump a slow beat with their feet. The false moon in the ceiling brightens.

The egg doesn't crack. It warms.

Frost-white light moves under the shell.

Something inside turns over, the way someone used to in her sleep.

Then, from inside the shell, a hum. Four notes.

**SHADE** *(breaking)* That's... that's her song.

**ZENITH** Not her vessel. Her answer.

**ALERION** ...Frostina.

`[herald: Alerion]` The ring on your hand warms for the first time. *(...Frostina.)*

**ALBERICA** *(softly)* Frostina. She'd have hated that. She'd have loved it.

**LUNA CARVER** It has a heart now. It needs time, and the world hasn't got enough.

*(Shade carries the Frost Egg from here on.)*

**MEAT MEAT** Razzy is jealous. Look. Razzy's egg is sulking.

`[herald: Meat Meat, quiet]` "...Razzy's egg is sulking."

- **Flow:** sets `requiem_done`, `frost_egg`. Shade carries the Frost Egg (key item) from here on. Luna: "It has a heart now. It needs time, and the world hasn't got enough." The Moon-Touched Egg stirs: "Razzy is jealous," says Meat Meat.
- **Notes:** Alerion names her before she hatches. His ring warms near the egg, and later near her, for the rest of the game. That's the Dark Half bond.

### SC 3.08 — One, two, three

- **Map:** 2022. **Trigger:** talk to Luna Carver after the Requiem. **Music:** *Rime*.

**LUNA CARVER** One heart of ice is grief. Two is a burden. Three is a summons.

**LUNA CARVER** Hers was the first. The cold man's still beats in his chest.

**LUNA CARVER** Bring a third to the other two, and the Frostmaiden gets a body to walk in.

**REPTIN** Then we make very sure nobody brings a third.

**LUNA CARVER** *(turning to Shade)* And you. Your house has a spark in it that isn't out.

**LUNA CARVER** I can see it on you. It's waiting somewhere bright.

**SHADE** My house is one smuggler and a carved cat. But thanks.

**LUNA CARVER** The cold man can't stay at our temple with his heart beating.

**LUNA CARVER** We'll take him south on a sledge, and follow you. At a distance.

**LUNA CARVER** We keep what the cold leaves. We kept an egg for two years.

`[after]` **LUNA CARVER** Go on. We'll be behind you, at a distance. We're good at distance.

`[optional: Zenith after the Requiem]` **ZENITH** What grows from a choice? ▸ *A rose. / A winter. / Nothing.* — A rose: "A rose. Then carry one." *(Zenith cuts a sprig from the Undying Rose and folds it into your hands. It's warm.)* Sets `rose_cutting`. Otherwise: "Not yet. Ask the rose again."

- **Flow:** sets `knows_three_hearts`. Pays off in Ch11 and Ch13. Also sets `wennen_follow`: Luna won't leave a beating piece of Auril unwatched, so she and a dozen Wennen haul Sephek's ice south behind the party and camp on the shore at Dougan's Hole (a tent on map 2035 from Ch4; Luna: "We keep what the cold leaves. We kept an egg for two years.").
- **Optional:** Zenith gives a cutting of the Undying Rose if you answer her verse ("What grows from a choice?" → "A rose."). Sets `rose_cutting` (turns Sephek in Ch13).

### SC 3.09 — The laughing is the calling

- **Map:** 2021 Lonelywood. **Trigger:** leave the Warren. **Present:** Jet Sentry, Zenith. **Music:** *Hunt*.

**ZENITH** South of the Hole where the ice stands still,

**ZENITH** a crone laughs low, and the laughing is the calling.

**JET SENTRY** Plain words: a hag lives in a chasm south of Dougan's Hole.

**JET SENTRY** The Circle has heard her for two winters. Your trinkets pull toward her.

**JET SENTRY** I'll run ahead to Bryn Shander. The east gate will be open for you.

**ALBERICA** A laughing hag who wants our jewellery. I've dated worse.

**ALERION** You have.

- **Flow:** sets `hag_named`. Switch 3914 (Bryn Shander's east gate) opens on this flag, with Jet Sentry waiting beside it.

## Chapter 4: Dougan's Hole

**Chapter goal:** find the one who's calling them. The town has to be saved first.

### SC 4.01 — Good Mead

- **Map:** 2030 Eastway, 2031 Good Mead, 2032 Mead Hall. **Trigger:** arrive at Good Mead. **Present:** party, Olivessa Untapoor, the Brewmistress. **Music:** *Hearth*.

`[the Eastway, first time]` Past Bryn Shander's east gate, the Eastway runs out across open snowfields. South-east, past Good Mead, is Dougan's Hole. Zenith said a hag laughs in a chasm there. **SHADE** A laughing hag. In a chasm. Is anything in this Dale just a nice lake? **ALERION** Then let's go and find out what's so funny. **ALBERICA** Look at that, pretty boy made a joke. Mark the date, somebody.

Good Mead: squat houses carved with serpents, and a mead hall with eaves painted like wyverns.

Bees hum somewhere in a heated hall. The whole town smells of honey.

**OLIVESSA** Headed to the Hole? Eat first. Nobody comes back from there fat.

**ALBERICA** A woman who feeds strangers on sight. I think I'm in love.

**MEAT MEAT** Meat Meat smells honey. Meat Meat does not smell coffee. Suspicious town.

`[resting in the mead hall]` **BREWMISTRESS** Come in, come in! Sit by the hive fire. No mead to sell, but warmth's free in Good Mead. Some nights you hear it from here. Laughing, out on Redwaters. The bees go quiet when it starts. *(heal)* **BREWMISTRESS** There. Listen to them hum. Sounds like summer, doesn't it? **ALBERICA** A mead hall with no mead. It's like a bed with no company. Technically works. **MEAT MEAT** Meat Meat asked for coffee. Lady gave Meat Meat hot honey water. Meat Meat is not angry. Meat Meat is disappointed. Three bees out of ten. **REPTIN** Thank you, it's lovely. She's saying it's lovely. **ALERION** She isn't.

- **Flow:** rest point. Sets `good_mead_met`. Olivessa is the person you pull from the burning hall in Ch9.

### SC 4.02 — The still ones on the ice

- **Map:** 2035 Dougan's Hole. **Trigger:** enter (autorun). **Present:** party, townsfolk (chorus). **Music:** *Rime* (thin).

Dougan's Hole huddles on the shore of Redwaters.

Out on the frozen lake, dark figures stand over fishing holes. Snow has drifted against their legs.

Between them, panes of ice stand upright, like mirrors.

**REPTIN** Those aren't fishers. Fishers fidget.

`[herald: Reptin, quiet]` "...Those aren't fishers."

**ALERION** They're people. Stopped.

**ALBERICA** Stopped how, pretty boy?

**ALERION** Like I was.

"Don't go out there." "Wolves took the Dejarr kids." "Nobody leaves." "Speaker's orders."

*(Speaker Edgra Durmoot's lodge is up the hill.)*

- **Flow:** sets `dh_arrived`. The ice figures can be examined: "A man with a fishing line, mid-cast. His breath is frozen in the air in front of him."
- **Notes:** these are Thredra's mirror-victims (World rule 1). One of them is the Targos widow's husband; give him a lantern and a Spheal-shaped float on his line.

### SC 4.03 — Either lost or stupid

- **Map:** 2036 Durmoot's Lodge. **Trigger:** enter. **Present:** Speaker Edgra Durmoot. **Music:** *Rime*.

**DURMOOT** Strangers. In Dougan's Hole. In winter. Either you're lost or you're stupid.

**DURMOOT** Wolves took Hilda's kids. Silja and Finn. They're dead.

**DURMOOT** Wolves don't keep prisoners. They keep dinner.

**REPTIN** Speaker, you're clearly a practical woman. So humour me. And if they aren't dead?

`[herald: Reptin, quiet]` "And if they aren't?"

**DURMOOT** ...Then bring them home, and I'll fight you for my seal myself.

**MEAT MEAT** Lady Speaker. Meat Meat likes her. Meat Meat would still bite her.

**REPTIN** *(aside)* Please don't.

**DURMOOT** The west way's open to you. Freeze where you like. I've told the militia.

`[before the children are home]` **DURMOOT** Still here? The west way's open. Bring them back, or don't come back.

- **Hilda:** "My Sil. My Finn. The Speaker says they're gone. Everyone says they're gone." / "They're not. A mother knows. I keep their bowls on the table." / "If you're going out there... please. Please." ALBERICA *(taking both her hands)*: "Keep the bowls out, love. We'll fill them."

* **Flow:** sets `met_durmoot`. Opens the west road (switch 3918).

### SC 4.04 — The limping wolf

- **Map:** 2035 edge of town. **Trigger:** first time on the west road. **Present:** Koran (winter wolf). **Music:** *Hunt*.

A white wolf lies in the snow, licking a paw.

**KORAN** Help me. My leg. My brother's gone mad. He has the children.

**KORAN** I'll show you.

> **Choice: "What do you do?"** "Show us." / "Which leg was it, again?"
>
> - **"Show us."** KORAN: "This way. This way. Quickly, before the snow fills my tracks." REPTIN *(quietly)*: "There's two of them. I can smell the other one." MEAT MEAT: "Meat Meat will walk next to the doggy. Close. Very friendly." Sets `followed_koran`.
> - **"Which leg was it, again?"** Koran blinks. He was limping on the left leg. Now he's limping on the right. SHADE: "Ha! Oh, I like this one. Terrible liar. Great coat." ALERION: "Told you. Liars forget." KORAN: "...Clever. Follow anyway. You need me." Sets `caught_koran`. The ambush in 4.07 starts one turn early in your favour.

Koran trots off west into the white.

`[the tundra, first time]` West of Dougan's Hole, everything is white. The blizzard comes in sideways. The wolves' tracks run ahead, west, filling with snow almost as fast as you find them. **SHADE** Thirteen miles of this. Wonderful. **ALBERICA** Think of it as a long, cold walk with excellent company. **SHADE** I am. That's the problem.

### SC 4.05 — The starving pack

- **Map:** 2039 The Western Tundra. **Trigger:** enter. **Present:** party, a pack of ordinary wolves, all ribs. **Music:** *Requiem*.
- **Goal:** get past them.

Not winter wolves. Ordinary ones, so thin you can count their ribs.

They don't attack. They just watch the packs on your backs.

**REPTIN** *(already unbuckling his food bag)* The Dale isn't sparing them. We can.

> **Choice: "What do you do?"** Help him / Hold him back *(as Reptin: Share it all / Share only your own)*
>
> - **Help him.** You both put out the rations. MEAT MEAT: "...Meat Meat gives the jerky. Not the coffee beans. Wolves don't deserve the beans." +1 Wheel. Sets `fed_pack`.
> - **Hold him back.** You put a hand on his arm. "We need that food." REPTIN: "I know. I'm sorry." He shares his own anyway. Sets `fed_pack_reptin_only`.

The pack eats. One lean she-wolf comes close enough to touch.

Reptin reaches out, and she bites: fast, deep, then gone.

**REPTIN** Fair. I'd bite me too. I'm very bitable.

`[herald: Reptin, quiet]` "...Fair. I'd bite me too."

The bite doesn't bleed. It burns like fire under snow.

**ALBERICA** Let me see that, sweetheart.

**REPTIN** I'm fine. Don't look at it. I'm fine.

- **Flow:** sets `reptin_bitten`. This is his lycanthropy (it shows in SC 5.01). `fed_pack` pays off in Ch6, where Rheven's direwolf is of this pack's line, and in the Ch13 Test of Endurance.

### SC 4.06 — Garagai's lodge

- **Map:** 2040 Garagai's Ice Lodge. **Trigger:** enter. **Present:** Norsu the mammoth; kobolds Holgi, Snorp and Zilbo; Silja and Finn in a cage. **Music:** *Requiem*.

Out of the tundra rises a dome of solid ice, three times the height of anything in Ten-Towns.

Inside, icicles hang overhead, their points sharp as daggers.

From deeper in comes a sound like a bellows: something enormous, breathing slowly.

And under it, very faintly, a child coughing.

**REPTIN** *(one word, flat)* Quiet.

**MEAT MEAT** *(very quiet, very fast)* Meat Meat hears it. Meat Meat is going.

A frost giant sits frozen on his throne, an axe-shaped gap in his grip.

A woolly mammoth stands guard over him.

**NORSU** You did this! You took his axe! You took his breath!

> **Choice: "What do you say?"** "We were his friends." / "We'll find who took the axe." / Stand your ground
>
> - **"We were his friends."** NORSU: "...Friends. Garagai had friends. Giants, who sat at his table. Never small ones. But you came to his tomb. His friends never came to his tomb." The mammoth's head lowers, slowly.
> - **"We'll find who took the axe."** NORSU: "The ones who killed him took his axe, and left him for me to watch. ...Swear it. On his ice." REPTIN: "I swear it. Whoever took his axe will answer for it, and the axe comes back to him." *(herald quiet: "I swear it. It comes back to him.")* MEAT MEAT: "Meat Meat swears too. Meat Meat bites whoever took it." Sets `garagai_vow`.
> - **Stand your ground.** Norsu charges: boss battle (Mamoswine, Lv 28). After: "...Take what you came for. Leave us be." Sets `norsu_beaten`.

**NORSU** Honour him, then. And go.

▸ *Say a few words over Garagai?* You say what you can about someone you never met. **ALBERICA** *(softly, after you)* He kept a whale in his kitchen and a mammoth who loved him. That's a good life. Norsu listens to every word.

`[whale oil]` A foul smell fills the room: barrels of whale oil, rendered from Garagai's catches. You fill an empty flask. It reeks, and it's slick as anything. **SHADE** Lovely. Now we smell like a dead giant's pantry. Very stealthy.

`[kobolds]` **HOLGI** Don't hurt! Don't hurt! We not mean to kill little stone thing! It startle us! **SNORP** We think house empty! House not empty! House have BIG HAIRY ANGRY! **ZILBO** And wolves outside! Wolves everywhere! Help us get out? We very small and very sorry. **MEAT MEAT** Little lizards! Meat Meat will not bite. Meat Meat promises. **REPTIN** She means you're safe. Mostly. ▸ *Help the kobolds escape?* **HOLGI** Kind big ones! Take shiny! Shiny cold! Never melts! We find it, now we give it! *(Never-Melt Ice)*

`[the cage]` A huge slatted animal cage stands against the wall. Its gate hangs on rusty hinges as big as your head. Inside, two shivering teenagers look out at you. **SILJA** Are you real? Are you from town? Did Mama send you? *Silja is spindly, with pointy teeth and snow in her long braids. Her brother works at the slats with frostbitten hands.* **FINN** The slats won't bend. Too cold. And the gate screams if you open it. The hinges scream. Then HE comes. **ALBERICA** Hey. Look at me. Big breath, all the way in. There you go. We're getting you out. **SHADE** *(already looking at the hinges)* Screaming hinges. I've opened worse. Give me a minute.

`[oiled]` You work the whale oil into the great rusty hinges, slowly, until they're black and dripping. The gate swings open without a sound. `[forced]` The hinges SHRIEK. **NORSU** THIEVES! You would rob his tomb too?! *(boss battle, unless Norsu is already beaten)*

**SILJA** The wolves watch the big doors. They always watch the big doors. But there's a tunnel in the oil room. The big worm dug it.

**FINN** I c-could've got out myself.

**SILJA** He couldn't.

**SHADE** Stay behind us. All the way home. Whatever happens.

**ALBERICA** And if Finn wants to carry something heroic, he can carry my bag. It's very heroic.

- **Flow:** the whale-oil flask is on the shelf. Oiling the hinges frees the children (`kids_freed`); forcing the cage starts a Norsu fight. The kobolds give Never-Melt Ice.

### SC 4.07 — Two wolves

- **Map:** 2039. **Trigger:** leave the lodge with the children. **Present:** Koran, Kanan. **Music:** boss.

Two white shapes rise out of the blizzard ahead of you, side by side.

**KANAN** You're bringing back our dinner.

**KORAN** *(no limp at all)* Nothing personal. The Dale is very hungry.

`[flag: caught_koran]` *(You saw it coming. You're ready before they are.)* **ALERION** Right leg.

**REPTIN** *(to the kids, not looking back)* Behind me. Now.

`[won]` Kanan yelps and bolts south, toward the chasm. Koran stands a moment longer, looking at you. Then he follows his brother. **SILJA** ...Can we go home now?

`[lost]` *(Silja and Finn fled back to the ice lodge to hide. Koran and Kanan are still waiting out on the tundra.)*

- **Battle:** double boss Koran and Kanan. `[flag: caught_koran]` You get a free first turn. Sets `wolves_beaten`. Kanan flees toward the south, toward the Chasm.

### SC 4.08 — Homecoming, and Gym 3

- **Map:** 2035, then 2036. **Trigger:** return with the children. **Present:** Hilda, Silja, Finn, Durmoot. **Music:** *Hearth*.

Silja doesn't wait for anyone. She's off down the street, braids flying, Finn stumbling after her.

Hilda runs out barefoot into the snow. She doesn't say anything. She doesn't have to.

**HILDA** ...Take these. They were my brother's. He'd want them used. *(2 Revives)*

**ALBERICA** *(sniffing loudly)* I'm not crying. It's the wind. Somebody give me a drink for the wind.

**MEAT MEAT** Meat Meat is also not crying. That is snow.

**DURMOOT** *(from her door, after a while)* ...Lodge. Now. I said I'd fight you myself.

**DURMOOT** ...I said I'd fight you myself.

**DURMOOT** Dougan's Hole keeps its word. Even when it's sorry it gave it.

- **Battle:** trappers Brann, Holt and Ysa, then Durmoot (Ice/Ground).

**DURMOOT** Thruun Seal. Don't lose it.

*You received the Thruun Seal! (TM79)*

**DURMOOT** That TM's Frost Breath. Every hit's a deep one. Like a Dougan's Hole winter.

**DURMOOT** ...Stay in tonight.

**ALBERICA** Was that concern? I think that was concern. She likes us.

**ALERION** She told the wolves to stay in too.

`[resting at the smokehouse]` **SMOKER** Sit, sit. You brought back Hilda's young'uns. You'll never pay for a trout in this town again. *(heal)* The racks drip. Everything in here smells of smoke and fish. **SHADE** Shimmer liked smoked trout. Hated the smell. Ate it anyway. **ALBERICA** *(quietly)* Then we'll eat it anyway too, sugar. For her. **MEAT MEAT** Meat Meat will eat two. One for Shimmer. One for Meat Meat. **ALERION** That's three you've eaten.

- **Hilda, after:** "Every time I look at them I have to count. One, two. One, two." / "Whatever you need from Dougan's Hole, you come to this door first."

* **Flow:** Thruun Seal (`badge_dougans`), TM79. Hilda gives 2 Revives. Sets `kids_home`. Nightfall (night tint).

### SC 4.09 — Night of the hag

- **Map:** 2035, night, the Twenty Stones. **Trigger:** try to rest. **Present:** party, Granny Thredra, three ice mirrors. **Music:** *Frostmaiden*, then boss.
- **Goal:** find who's calling.

*Night tint.* Laughter on the ice. It comes from everywhere at once. Your relics go so cold they burn.

Among the Twenty Stones, south-west of town, stand three tall mirrors of ice.

In each one, an old woman in a patchwork cloak is smiling.

**ALBERICA** Durmoot told us to stay in.

**SHADE** Durmoot tells everyone to stay in.

**MEAT MEAT** Meat Meat never stays in. Meat Meat is already outside.

`[the centre stone]` **THREDRA** Come in, dearies. Mind the cold. Mind your step.

**THREDRA** Did you like my little trinkets? A pendant for the daughter of song.

**THREDRA** A medallion for the wolf of seasons. A ring for the boy outside time.

**ALERION** ...Boy.

**THREDRA** A dagger for the one who hides in shadow.

**THREDRA** And the one who'd been worn before needed no gift from me. She already carried a door.

**ALBERICA** You sent them. You sent me that pendant, you dried-up old...

`[herald: Alberica, quiet]` "...You sent them."

**THREDRA** I sent them. My watchers watched you aboard.

**THREDRA** She wants a new coat to wear, you see. I'm only her seamstress.

`[mode: journey]` **THREDRA** *(squinting at you)* And this one isn't anywhere at all. Interesting. Very interesting.

**REPTIN** *(aside)* Seamstress. Lovely. Let's not let her take our measurements.

**THREDRA** Let's dance upon the glass, and see who shatters first.

**THREDRA** Break my mirrors, dearies. If you can bear to look in them.

`[each mirror]` You look into the mirror. Your reflection grins back with someone else's teeth. The glass bulges, and something climbs out of it! *(Mirror-wight battle.)* The mirror cracks top to bottom and falls into the snow in a hundred laughing pieces. Behind you, the crone stops laughing, just for a moment.

`[before all three]` **THREDRA** Heh-heh. One of three. The wheel turns so slowly, doesn't it?

The last mirror lies in pieces. The crone stops laughing.

- **Battle:** Granny Thredra.

**THREDRA** Clever. Clever, clever. You broke them. Do you know how long it takes to grow a mirror?

**THREDRA** Come and find me in the chasm, dearies. Bring your wolf.

She splits into shards and blows away south.

Out on the lake, the frozen figures breathe. One by one they sag, gasp, and fall to their knees.

**REPTIN** *(hand closing over the bite)* ...Bring your wolf. She means me.

**ALERION** She means all of us. She just said your name first.

A fisherman with a Spheal-shaped float on his line looks up at you, shaking.

**FISHERMAN** Targos. Tell my wife I'm coming home. Tell her not to give the Spheal away.

`[flag: widow_spheal]` *(You already have it. You let it out of its ball.)* He laughs until he cries.

- **Flow:** sets `hag_fled`, `husband_thawed`. The widow's husband speaks: "Tell her I'm coming home. Tell her not to give the Spheal away." `[flag: widow_spheal]` You already have it. He laughs until he cries.
- **Notes:** her trainer name is "Granny Thredra" (fixes "Bheur Hag Hag"). The "seamstress" line plants that she serves Auril, but Chapter 5 shows she wants more.

### SC 4.10 — Don't tell anyone

- **Map:** 2035, morning. **Trigger:** wake. **Present:** Durmoot. **Music:** *Hearth*.

Morning. Speaker Durmoot comes down the hill carrying a lantern she doesn't need any more.

**DURMOOT** Thank you.

**DURMOOT** ...Don't tell anyone I said that.

**ALBERICA** Oh, sugar, I'm writing a song about it.

**DURMOOT** Chasm's south. Take this. It's the only thing in this town that cuts the wind. *(TM95)*

`[after]` **DURMOOT** You've got my seal. Don't make a fuss about it. And if that crone comes back... you'll hear her before you see her. You always do.

- **Flow:** opens the south road (switch 3922). Sets `dh_morning`.

## Chapter 5: The Cackling Chasm

**Chapter goal:** stop Thredra before she feeds the Chasm's heart a life. Shimmer's lesson, the third way, is how they do it.

### SC 5.01 — Full moon on the Laughing Waste

- **Map:** 2041 The Laughing Waste, night, full moon. **Trigger:** enter. **Present:** party. **Music:** *Hunt*.

South of Dougan's Hole the land breaks into ice hills and black stone.

A full moon. The wind sounds like someone laughing.

Reptin stops walking. His shoulders roll wrong.

For one breath there's a wolf where he stood, grey and enormous. Then Reptin again, on his knees.

**REPTIN** The bite. It's the bite.

**REPTIN** Every night since, I've dreamed of a chained wolf. And a crone: "Abandon your bond and be free."

**ALERION** Then don't listen to her.

**MEAT MEAT** Doggy Reptin. Meat Meat is not scared. Meat Meat will still sit next to him.

**REPTIN** *(standing)* I wasn't planning to. I'm fine. Don't look at me.

`[herald: Reptin]` The same beats in your own head *(The bite. It's the bite.)*, then **REPTIN** "I'm fine. Don't look at me. I'm fine." *(quiet: "...I'm fine.")* **ALERION** Then don't listen to her. **ALBERICA** Up you get, sugar. Lean on me. I'm sturdier than I look. Which is very sturdy. *(You stand up. You weren't planning to stay down.)*

- **Flow:** sets `reptin_wolf`. Reptin's overworld follower swaps to a wolf for the rest of the chapter, if art allows.

### SC 5.02 — An old woman's home *(unique ID: `scene_cackling_enter`)*

- **Map:** 2042 Cackling Chasm entrance. **Trigger:** enter. **Present:** party; Thredra as an illusion. **Music:** *Frostmaiden*.

The chasm laughs. Not echoing: laughing, out of the rock itself.

A kindly old woman stands at the cave mouth with a lantern.

**THREDRA** So good of you to visit an old woman in her home.

**THREDRA** I smell the wolf among you. Good. I asked for the wolf.

She flickers and is gone. The lantern stays, hanging from nothing.

**REPTIN** She's lovely. Really. Somebody remind me to never visit again.

**SHADE** Free lantern, though.

`[the icefall]` A crack, high overhead. Then the ceiling comes down: jagged icicles and chunks of heavy ice! Your Pokémon throw themselves in front of you. The crash echoes away, deeper and deeper. Somewhere ahead, delighted, the crone: "Oops! Mind your heads, dearies!" Out of the crevices near the roof swoop small shapes made of ice, shrieking with laughter: ice mephits! *(double battle)* The last mephit cracks and bursts into a spray of shards. The tunnel goes quiet. **MEAT MEAT** Laughing ice. Meat Meat laughed last. Meat Meat wins.

- **Flow:** sets `cackling_entered`. Icefall trap ahead, then two ice mephits (Snorunt bosses).

### SC 5.03 — The Order's locket

- **Map:** 2042, rubble past the icefall. **Trigger:** examine. **Present:** Alberica. **Music:** *Rime*.

A silver locket, half sun, half moon. Inside, a portrait of a stern, older dwarf woman.

Under it, a name.

**ALBERICA** *(very still)* That's my name. That's my face. Older.

**ALBERICA** I've never been here.

`[herald: Alberica]` *(That's your name. That's your face. Older.)* **ALBERICA** "Well. I age beautifully. That's something. ...I've never been here." *(quiet: "...I've never been here.")*

**ALERION** You're sure?

**ALBERICA** Pretty boy, I'd remember a place this miserable.

- **Flow:** the Order's Locket (key item). Sets `order_locket`.

### SC 5.04 — The feast hall

- **Map:** 2042, the feast hall. **Trigger:** enter. **Present:** party, mother yeti, the dead father. **Music:** *Requiem*, then boss.

A great white yeti lies dead, chest opened, heart gone.

His hand still clutches a scrap of baby swaddling.

Over him stands his mate, roaring.

> **Choice: "What do you do?"** Ask Alberica to sing *(as Alberica: Sing.)* / Fight.
>
> - **Sing.** Alberica sings the lullaby from Bryn Shander's square. No jokes in it. Not one. `[flag: stood_with_alberica]` The mother stops, shaking. She looks at the swaddling. Then she points, deeper into the chasm, to where her cub was taken. Sets `yeti_calmed`. `[otherwise]` The song catches. Nobody stood beside it that night in the square, and it hasn't learned to carry yet. The yeti roars over it and charges.
> - **Fight.** Boss battle (Yetitan, Lv 31). She collapses over her mate. Then she gets up, and limps after you at a distance. Sets `yeti_fought`.

`[the dead yeti, after]` You work the frozen fingers open. Inside: a tuft of soft white fur tied with sinew. A baby's swaddling. Drag marks lead away into the far tunnel. Booted footprints beside them. **REPTIN** They had a child. She took the child. **SHADE** *(very quiet)* Then we take it back.

`[bone pile]` A pile of gnawed bones: goat, fox, gnoll. The oldest have crumbled to grey dust. On an impulse you can't explain, you fold a pinch of the dust into a scrap of cloth and keep it. Sets `bone_dust`.

On the bone pile: a backpack and a journal. Inside the pack, a healing draught, still intact.

"Granny Thredra is kind. Granny Thredra says she can bring my sister back."

The last page says only: *SHE LIES.*

- **Notes:** the journal's owner is never named. Don't reuse "Glimmer" here; the hag uses that name as bait in 5.05.

### SC 5.05 — The split path

- **Map:** 2042, the hall of illusions. **Trigger:** reach the fork. **Present:** party; illusions. **Music:** *Rime*, distorted.
- **Goal:** pick the true path.

Two tunnels of glassy ice. From the left, warm light and a child's voice.

From the right, an old woman weeping.

**CHILD'S VOICE** Shade? Shade, it's me. Shimmer. I'm lost. I'm so cold.

**SHADE** *(already moving)* That's...

**ALERION** *(grabbing their arm)* Your sister's gone, Shade. And she was never that small.

`[herald: Alerion, quiet]` *(grabbing their arm)* "Shade. She was never that small."

> **Choose a tunnel.**
>
> - **Left (the light).** You follow the light into a little cave. The child's voice is just ahead: "This way... hurry..." Then the floor isn't there any more. You land hard on jagged rock and old bones, fifteen feet down. The light above goes out. Something in the dark is moving. Two shapes, starved thin, eyes shining with hunger. *(Ghouls, double battle.)* The ghouls collapse into rags and dust. Far above, the crone's laughter rolls through the caves: "Poor little lambs... did you stumble? Heehee!" Among the bones: a belt pouch with a healing draught, and a little scrimshaw carving of a smiling halfling. You climb the old rope, hand over hand, back up to the fork. Sets `took_left`, `pit_done`.
> - **Right (the weeping).** The weeping is real: the cub's mother, or her echo, somewhere ahead in the dark. This is the true way. Claw marks on the walls go the same way you are. Sets `took_right`.

**SHADE** *(after, either way)* She knew her name. How did she know her name?

**MEAT MEAT** Hags know everything you're scared of. That is their whole job.

**ALBERICA** *(an arm around Shade's shoulders, just for a moment)* And it's a rotten job, sugar.

### SC 5.06 — The bridge, and the Gate

- **Map:** 2044 The Frozen Rift; the Guardian's Gate. **Trigger:** cross the bridge. **Present:** party; a green-robed ghost. **Music:** *Hunt*.

The passage ends at a ledge over nothing. A chasm cuts down so deep your light gives up.

Across it runs a long, narrow bridge, slick with ice, its old rope railing limp and frayed.

The wind howls up out of the dark, and the cackling is louder here, rising, fading to a moan.

Under it, from beyond the far side, very faint: chanting.

**ALBERICA** Lovely. Who's first? Not me. I'm the morale.

**ALERION** Me.

`[on the bridge]` CRACK! A chunk of ice breaks from the roof and shatters on the bridge, one step ahead of you. The whole span shudders. Pebbles skitter off the edge, and you never hear them land. The laughter on the wind rises, as if mocking you.

`[further on]` A gust tears up out of the abyss. You drop to your knees on the ice, gripping the stone. For a moment, on the far ledge, a ghostly woman in dark green robes stands pointing at you. Then she's gone. The gust passes. You get up. You keep going.

`[the warm fissure: rest point]` A fissure in the rock breathes warm air up from somewhere very deep. Out of the wind, it's almost cosy. You rest a while. The laughing sounds further away from here. **MEAT MEAT** Warm crack. Meat Meat could make coffee on this crack. Meat Meat has no coffee. Meat Meat is going to cry. Fondly. **ALBERICA** Here, darling. Last of the Good Mead honey cake. Don't tell anyone. **SHADE** Everyone's watching you hand it over. **ALBERICA** Then nobody tell anyone.

A massive door of ancient granite, carved in two halves.

On one, a great wolf curled round a full moon. On the other, a reaper's scythe cradling a newborn.

In the centre of each half, a shallow bowl. The life bowl is stained brown; the death bowl, grey.

A whisper in your mind, many voices at once: "Only by the blood of living life...

"...only by the stillness of death... shall the passage open."

▸ *Make an offering?* *What do you give the wolf and moon?* (your own blood / a handful of snow / a coin) — *What do you give the scythe and child?* (bone dust, if you have it / a handful of snow / stand in silence / a coin)

`[blood, and bone dust or silence]` Reptin holds his bitten hand over the life bowl before you can. The stone drinks the blood as if it were thirsty. You tip the grey dust into the death bowl. It settles, and does not stir. *(or: You stand before the death bowl and say nothing at all. The silence goes on, and the stone listens.)* The runes glow: red on the wolf's side, dull grey on the reaper's. The two halves grind apart. Stale, cold air rushes out, and for a moment you see something that isn't there: a robed dwarf woman performing this same rite, long ago, great wolves at her side. The vision fades. Off to one side of the passage, a hairline seam has opened in the ice wall. **REPTIN** Wolves. Standing with her. Not chained. **ALERION** Noted.

`[wrong offering]` The offering lies in the bowl. Nothing happens. Then the skulls on the arch begin to clatter. Bones pull themselves out of the walls: the Order's dead guardians, come to drive you off! *(double battle)* The guardians crumble back into the walls. The door stays shut. The whisper again, patient: "Give life... give death..."

`[the hollow wall]` The ice here sounds hollow. The locket in your pocket grows warm. You put your shoulder to it, and a sheet of ice falls away. Behind it, a narrow crevice.

- **Puzzle:** blood in the Life bowl (Reptin offers his bitten hand), bone dust or silence in the Death bowl. A wrong offering starts a Guardian fight.
- **Flow:** sets `gate_open`.

### SC 5.07 — The ghost with her face

- **Map:** 2045 Hidden Sanctum. **Trigger:** enter. **Present:** party; the ghost of an older Alberica, in green. **Music:** *Thaw* (very quiet).

The green-robed ghost is waiting. When she turns, she has Alberica's face, decades older.

**ALBERICA** You have my face.

**GHOST** I borrowed it. I'll give it back when you're done.

`[after the loop]` **GHOST** *(quieter)* You held her still. I know. I'm the one who held her. Holding isn't keeping. Find the song.

**GHOST** Listen, because I only get to say this once.

**GHOST** Under this chasm is a root. The last living root of the World Tree the Frostmaiden cut down.

**GHOST** The hag means to drain it and become winter herself.

**ALBERICA** ...Why does that sound like something I already knew?

**GHOST** *(to Reptin)* And you. Your wolf isn't a curse.

**GHOST** The wolves were the wardens of this place, once. It's a charge.

**GHOST** You can put it down, or you can carry it.

**REPTIN** I'll keep it. The wolf. The watch. All of it. Not because I can't put it down.

`[herald: Reptin, quiet]` "...I'll keep it."

**REPTIN** Because somebody has to hold it.

**GHOST** *(smiling)* I know. I remember.

**ALBERICA** Who are you?

**GHOST** Time is a wheel, dear. Go. She's started.

**MEAT MEAT** Ghost lady is singing lady. Meat Meat says nothing. Meat Meat is very good at secrets.

*A soft silver light settles over you and your Pokémon. (It will be there again when you need it most.)*

- **Flow:** the Order's blessing (full heal between the boss phases in 5.08). Sets `ghost_blessing`.
- **Notes:** the ghost is Alberica's future self (the epilogue). Never confirm it in Act I.

### SC 5.08 — The Heart of the Chasm

- **Map:** 2046. **Trigger:** enter. **Present:** party; Thredra; the yeti cub in chains; Kanan; an ice troll; a dais of four ice spires around a red orb, with a living root showing through the floor beneath it. **Music:** *Frostmaiden*, then final boss.
- **Goal:** stop the sacrifice.

The passage climbs into a great cavern.

On a dais in its centre, four spires of ice cradle an orb of blood-red ice.

It pulses with a faint light, like a slow heartbeat. Veins of crimson and cobalt crackle through it.

Between the pillars, a yeti cub hangs in black iron chains, gagged, white fur matted with tears.

All around the cavern stand tall mirrors of frost-rimmed ice. In every one, a crone is smiling.

Beside the Heart stands the hag, no longer hiding.

At her right hand, a winter wolf: Kanan.

At her left, an ice troll with crystal growing through its flesh.

**THREDRA** There you are. My little seamstress's samples.

**THREDRA** Do you know what this is? *(the root, pulsing under the ice)*

**THREDRA** The last living piece of the old World Tree.

**SHADE** She talks a lot for someone who's about to lose.

**THREDRA** It remembers every winter there ever was. Feed it a life, and it gives me all of them.

**THREDRA** Not her winter. Mine. I'll be the new Winter, dearies. Not so fickle as Auril.

**THREDRA** *(a claw on the chained cub's head)* A life for a life. This sweet one, I think.

> **Choice: "What do you do?"** "Never." / Let Reptin step forward / Hold up the golden acorn *(if you have it)*
>
> - **"Never."** THREDRA: "Then I'll take one of yours." MEAT MEAT *(very quiet)*: "Touch baby yeti and Meat Meat takes your face."
> - **Let Reptin step forward.** REPTIN: "Take me instead." THREDRA: "Oh, I'll take you all, wolf. In order."
> - **Hold up the golden acorn.** THREDRA *(laughing)*: "A seed? You'd feed a god a seed?" Sets `offered_acorn`.

**KANAN** Warm blood!

The winter wolf and the ice troll lunge!

`[flag: yeti_calmed]` Behind you, a roar. The mother yeti comes down the tunnel like an avalanche and slams into the troll.

Kanan yelps and slinks behind a pillar. The troll crashes to the ice and lies there, steaming.

**THREDRA** Useless, the both of them. Let's dance upon the glass, and see who shatters first.

Her staff cracks across. The hag shrieks and leaps backward into the largest mirror.

The glass takes her like water.

**THREDRA** Clever, clever! But I am the mirror, dearies. Break me, if you can bear to look!

Out of the grand mirror steps her reflection, made of frost and spite.

`[flag: ghost_blessing]` For one moment, a dwarf woman in dark green robes stands at your side, silver light spilling from her hands. Then she's gone, and your Pokémon are on their feet again.

- **Battles:** Kanan and the ice troll (with the mother yeti on your side if `yeti_calmed`); then Thredra; then **Thredra's Reflection**. The ghost's blessing heals you between phases.

### SC 5.09 — The third way, again

- **Map:** 2046. **Trigger:** defeat the Reflection. **Present:** everyone. **Music:** silence, then *Thaw*.

Thredra's Reflection cracks. The last mirror.

You're the one who breaks it.

The Heart pulses hard. It's still hungry. The root under the ice opens like a mouth.

**REPTIN** *(stepping toward it)* It wants a life.

**ALBERICA** No. Shimmer showed us. There's always a third way.

`[herald: Alberica, quiet]` "...There's always a third way."

`[flag: offered_acorn]` Alberica takes the golden acorn from your hand.

`[not: offered_acorn]` Alberica takes the golden acorn from Reptin's pack.

**ALBERICA** A life that hasn't started yet.

She presses the acorn into the root.

Every mirror in the chasm shatters at once.

Thredra screams, stretched across a thousand shards:

laughing in one, weeping in another, silent in a third.

Out of the shards pours everything she stole: hours, nights, whole winters, frozen moments.

A flood of time, with nowhere to go but down into the root. Into the seed.

The seed drinks it.

In Reptin's arms the Moon-Touched Egg cracks, and in Shade's the Frost Egg answers it.

Two wyrmlings tumble out together.

One is moss-green flecked with silver, gold-eyed. It grabs a fistful of Meat Meat's long white hair.

The other is white as new frost, with wings like leaves of ice.

She looks at Shade, tilts her head the way someone used to, and hums four notes.

**SHADE** *(very quietly)* ...Hi.

**RAZZILITH** *(no voice; a picture in all your heads, of flying)* ...Fly?

**MEAT MEAT** *(sobbing and laughing)* RAZZY. Meat Meat is not crying. That is sap. RAZZY.

`[herald: Meat Meat, quiet]` *(very quietly)* "...Razzy."

`[flag: yeti_calmed]` The mother yeti breaks the cub's chains with her hands. The cub looks at you. Then it comes to you.

`[not: yeti_calmed]` The cub's chains snap in the flood. It runs to its mother, limping in from the feast hall. Then it looks back at you.

▸ *Take Yetot with you?* Yes: Yetot Lv 25 joins. Sets `got_yetot`.

Alberica's hand is still on the root. She looks up, and her eyes are full of light.

**ALBERICA** I can see it. A sapling. A forest. A city. Four hundred years, all at once.

**THREDRA** *(from every shard, fading)* You think you've won? Mirrors remember, dearies.

**THREDRA** Mirrors always remember.

Time comes loose. The floor of the world tips. You all fall into the shards.

- **Flow:** sets `reversal`, `razzilith_hatched`, `frostina_hatched`. Year 0 of the Verdant Reversal.
- **Notes:** this replaces the current "hold up the shard when you're ready" gate. The fall goes straight into the Act I epilogue, then Act II.

### SC 5.10 — Falling (Act I epilogue)

- **Map:** vision sequence. **Trigger:** follows 5.09. **Music:** *Heralds*, the full theme for the first time.

You fall through moments.

A sapling bursts from thawed soil above a frozen town.

Moon-white Wennen drag a sledge to the sapling: a man frozen in a block of ice.

They kneel among the roots, and stay. Settlers lay walkways between the roots.

Two young dragons, one green and one white, circle a tree that pierces the aurora.

A tavern-keeper carves heroes into living wood. Her chisel hesitates over a small sixth figure.

`[mode: journey]` A festival. A lantern. Your own face, looking in.

**ALERION** *(somewhere close, in the fall)* Hold on to something.

**ALBERICA** I'm holding on to you, pretty boy. Don't make it weird.

**MEAT MEAT** Holding Razzy! Meat Meat is holding... Razzy? RAZZY!

`[herald: Meat Meat, quiet]` "...Razzy?"

Both wyrmlings are pulled out of your arms, back toward the root.

One picture comes from both of them, fading: Meat Meat's face, Shade's face, and the word WAIT.

*END OF ACT I: THE RIME*

- **Notes:** Both wyrmlings hatched from stolen time, so the root keeps them. They stay behind in the Reversal while the party falls forward, and grow up inside the Wall. The Wennen who followed the party south (SC 3.08) are camped at Dougan's Hole when the bubble forms, so they end up inside it too, with Sephek's ice. That is why they're waiting in Chapter 6, why the Wennen live in Rootspire, and why Meat Meat's reunion with Razzy is the first beat of Act II.

* **Flow:** end of Act I. Save prompt. Act II begins at SC 6.01.
