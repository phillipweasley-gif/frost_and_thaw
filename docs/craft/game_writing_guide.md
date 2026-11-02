# Game Writing: Narrative Skills for Videogames (ed. Chris Bateman, 2007): a guide for Frost & Thaw

Source: `sources/craft/game_writing.txt` (OCR of the Charles River Media first edition), read in full, preface to
index. Page numbers are the printed book pages. Short quotes are a sentence or less; everything else is paraphrase.

---

## 1. Overview

The book collects fourteen practical chapters by members of the IGDA Game Writers' SIG. It isn't really about
literary theory. It's about the jobs a game writer actually does: deciding what the player must know and where
they'll learn it, keeping the player on the path, building characters whose personality hides their game
function, deciding when to take control away, writing lines that will be triggered out of order and repeated, and
handing the team a script they can build. Its argument comes back to one question, Dansky's "how will this play?"
(p.17): a technique from novels or film is only useful if it still works when the player is holding the controller.

The book was written for voiced, 3D, mid-2000s games, so about a fifth of it (voice casting, warm-ups, audio
stitching, lip-sync) doesn't apply to a text-only fan mod. What applies to Frost & Thaw, in order of value:

1. **Ch.5 Keeping the Player on Track (Bateman)**: the spine and the golden path, breadcrumbs that come with a reason,
   funnelling characters, warning before an irreversible step, plain language on the spine. This is the toolkit for
   Rootspire's hub weeks, the goal line, and party chat.
2. **Ch.7 Cut Scenes and Scripted Events (Dansky)**: when to take control, and what it costs (forced failure,
   stolen rewards, the avatar acting against the player's idea of them). Herald mode is exactly the situation
   Dansky warns about: the game speaks *as* the player.
3. **Ch.6 Game Characters (Walsh)**: purpose and personality, governing and conflicting traits, NPCs that change
   as the plot moves, a balanced cast, subtext, verbal tics.
4. **Ch.3 Writing for Games (Boon)** and **Ch.4 Nonlinear Narrative (DeMarle)**: progress structure tells you where
   story can go; reflecting small player actions creates a sense of agency; give each detail a relevance rating and
   reinforce the important ones in more than one place.
5. **Ch.14 Dialogue Engines (Bateman)**: the game's own engine is event-driven with character scripts (lambdas
   keyed on flags), and party chat is a banter engine. The chapter covers how many line variants to write, lines
   that play only once, defaults, and inserted text.
6. **Ch.9 Writing for Licenses (Swallow)**: Frost & Thaw adapts two pieces of existing IP, the owner's D&D campaign
   and Pokémon. The rule is "serve the IP" without shutting out a player who never sat at the table.
7. **Ch.12 (Seifert), Ch.8 (comedy) and Ch.11 (localization)**: what's left that applies is read-aloud testing,
   putting the essential information first, adding redundancy, picking a consistent comic register, and not building
   sentences out of fragments.

---

## 2. Principles

Each entry gives the principle, why it matters here, a **rule** for this game, and the page reference.

### A. Story structure and pacing

**A1. Narrative is "what happens", and it comes out of play.** Story, character and cut scenes are tools; the
narrative is what the player experiences through challenges and rewards (p.2). *Here:* a scene isn't done when its
lines are written. It's done when the battle, item, panel or choice it hangs on is in place. **Rule:** for every
scene, write one sentence that says what the *player* does or earns in it. If the answer is "watches", keep the
scene short (see C1).

**A2. Story should be a reward.** When chunks of narrative arrive after a boss or a hard challenge, the player
comes to expect them, and a cliffhanger at the end of each chunk pulls them forward (p.6; Boon p.54). *Here:* gym
badges, trial verdicts and dungeon ends are where the big beats belong. **Rule:** put major reveals and panels
*after* a win, not before a fight, and end each chapter with an open question (Pratchett recommends TV-style
"narrative questions", p.197).

**A3. Rising climaxes that the story has built toward.** Long games need a series of climaxes. The last one must
use what the player has learned and connect to the threads already running. A climax that brings in an unrelated
new enemy weakens the whole game (p.14). **Rule:** every boss or finale must have been named, seen or foreshadowed
at least one chapter earlier. Its stakes should be personal to a party member, not just "the world".

**A4. The player sets the pace. Use the progress structure.** Free exploration means the writer can't schedule
beats by time. Instead, attach story to the keys and barriers the design already has (badges, items, switches).
A trigger tied to a key is guaranteed to be seen (Boon p.48). In a hub ("domain") structure, put the core story in
the hub and give repeat visits fresh lines (p.60). In open areas, use game-state triggers rather than location
triggers (p.61). *Here:* Rootspire is a hub, and Ten Towns and the Act II weeks are domains. **Rule:** spine beats
fire on a flag or switch that the player cannot avoid setting, never on wandering into one tile.

**A5. Models are tools, not laws.** Freytag, the Hero's Journey and three-act structure explain conventional
shapes, and a story can break them on purpose (p.32). The Hero's Journey's archetypes (Threshold Guardian,
Trickster, Herald, Shapeshifter, Shadow) are signposts that tell the audience where they are. A character can move
between roles (pp.36-39). *Here:* the book's "Herald" archetype brings news, sets the hero moving, and may join the
party (p.37). That is the Heralds' own role in Rootspire's myth. **Rule:** when a character changes role (an ally
becomes a Shapeshifter, a mentor dies), mark the change in a scene. Don't let it happen between chapters.

**A6. Don't let exposition crunch.** Never let so much required information pile up in one place that a scene runs
past the player's patience (p.55). If the core of what a non-interactive sequence must say can't fit in three
sentences, it's too complex, over-decorated, or doing the work of two scenes (p.137). **Rule:** before scripting a
scene, write its required information as at most three sentences at the top of the method, in a comment. If you
need a fourth, split the scene or move the extra into an optional source (signs, NPCs, items).

### B. Character and voice

**B1. Every character has a game purpose and a personality, and the personality hides the purpose.** Purpose is what
the character does for the gameplay (blocks a door, sells potions, gives directions). Personality is what makes the
player believe they do it by choice (pp.104-105). God of War's frightened man at the bridge is a "talking rope"
(p.110), but his fear makes him memorable and tells you who Kratos is. **Rule:** for each NPC event, note its
purpose (quest gate, hint, shop, color). Then give it one want or fear that explains that purpose in the fiction.

**B2. Governing trait plus conflicting trait, then secondary traits for texture.** A character's main drive meets an
opposing streak. The conflict deepens them and can supply their arc. Secondary traits (stern or comic) decide *how*
they talk. If two characters share the same traits, cut one or change one (pp.118-119). **Rule:** the Voices doc
should give each Herald and major NPC a governing trait, a conflicting trait and a register. Check new lines against
it: "is this the trait talking, or me?"

**B3. Change, but stay true to the core.** An arc should change a character without breaking what they essentially
are (p.35). With franchise characters, the writer is a caretaker. Fans expect the established identifiers to keep
showing up (p.16; Swallow p.171). *Here:* Shade's change into Glimmer, and Alberica's bravado over grief, are this
kind of arc. **Rule:** after any transformation, keep at least one familiar tic (Glimmer humming Frostina's four
notes off-key, the way Shade did, is exactly right).

**B4. Show, then tell, and use subtext.** Villains are villains because they do villainous things (p.123). Plain
exposition kills characters. Good dialogue says what it means without saying it, like "She's very cute. If you
like blonde and brainless" (p.124). *Here:* the note and carved cat on Shimmer's pillow do more than any
explanation could. **Rule:** if a line names the feeling ("I'm scared", "this is surrender"), try cutting it and
letting the action or a sideways remark carry it.

**B5. Each voice is recognisable without its name tag.** Give each character a tic: word choice, contractions,
pronoun habits (third person), rhythm, sentence length (p.124). Write accents and dialect as plain language plus one
or two colloquialisms (Boon p.52; Seifert p.217). Forms of address carry relationship and period (Adams
pp.249-250). *Here:* Meat Meat's third person, Alberica's "sugar/sweetheart/darling", Reptin's courtly irony.
**Rule:** cover the speaker labels on a page of a scene. If you can't tell who's talking, revise.

**B6. Mute characters need a translator.** A character who can't talk can only express the broadest motives. Give
their exposition to someone who can speak (pp.124-125). *Here:* Pokémon, Razzy/Razzilith ("painted thoughts"),
Frostina's four notes. **Rule:** each wordless character gets a consistent device (a painted thought, a hummed
motif), plus a companion who reads it aloud when it carries plot.

**B7. Antagonists need a visible motive and a visible effect.** Being "bad" isn't enough. The player must see what
the villain wants and feel what the villain does even when they're offscreen (pp.114-115). Faceless groups get
personality through barks. Bosses stand in for their whole side (pp.115-116). **Rule:** every recurring villain
(Sephek, Auril, Avarice, the Still Keeper) leaves a mark in each chapter they're absent from: a rumor, a casualty,
an item, a sign.

**B8. Minor characters need only four things:** a look, a tone, a place in the world, and sometimes one piece of
information (p.15). Make even single-use NPCs memorable, like Grim Fandango's balloon-twister (p.36). Stock types
are fine for a few seconds of screen time, and good for subverting (p.122). Don't put the whole bible on screen
(pp.15, 123). **Rule:** a one-off NPC gets at most three boxes on first meeting and one on repeat, and at least one
of those boxes should be specific to Icewind Dale or Rootspire, not generic fantasy.

### C. Dialogue and the message box

**C1. Text stops play; length and frequency decide whether it engages or irritates.** A player reading text is not
playing (Boon pp.49-50). People read faster than they speak, so writers overwrite. Write everything that must be
said, then edit repeatedly. The usual problem is not having the nerve to cut (Dansky pp.135, 146). Cut unnecessary
backstory first, then one-liners. Keep sentence structure simple (p.146). **Rule:** one beat per box. No sentence
should overflow the ~90-character box (about 2×45, *including* the `NAME: ` prefix). If it does, split at a
sentence boundary or cut.

**C2. Essential information goes first, and gets said twice.** Players skip and skim. Put the essential information
at the front of a line or scene (the inverted pyramid, Seifert p.211) and back up plot points elsewhere (p.212).
Vital information should be replayable, for example by talking to an NPC again (Boon p.51). In an RPG engine,
players mash A. **Rule:** every spine fact (where to go, who has the thing) appears in (1) a line in the scene,
(2) `state[:goal]`, and (3) one replayable source: an NPC's repeat line, party chat or a sign.

**C3. Lines do several jobs, but game information is never hidden by color.** Each game line may need to carry
exposition, character, setting and play advice at once. The player must never lose the instruction because it's
wrapped in a joke (pp.51-52). **Rule:** in a hint line, the place or action name is literal and up front; the joke
comes after it.

**C4. Read it aloud and test it cold.** Read lines out, have someone else read them, even read the script
backwards line by line to check each one stands on its own (Seifert p.210). Run script QA with someone who doesn't
know it (pp.218-219). Group read-throughs show what works (comedy chapter pp.160-161). **Rule:** before a chapter
ships, one person who hasn't read the Story Bible reads its spine scenes in-game and explains back what happened
and where to go next.

**C5. Rapid back-and-forth and interruptions only work under control.** Witty volleys and cut-offs need a controlled
scene (p.145). In live play they come out stilted (comedy chapter pp.163-164). Break up monologues with short
interjections (p.146). **Rule:** banter volleys go in `say()` blocks inside a scene, never across separate
event triggers. A monologue longer than four boxes gets a one-box interruption from someone.

**C6. Write each line from what the character knows at that moment** (Clement, quoted p.230-231). The writer knows
the whole plot. The speaker doesn't. *Here:* this is critical with the Still Keeper's loop, the time travel, and the
Glimmer journal. **Rule:** for loop-aware lines (`counter(:loop_count) > 0`), state in a comment what the speaker
remembers and how.

**C7. One comic register per character, and ham with care.** Pick the kind of humor and stick to it (p.153). Comedy
that works on paper can grate in play (p.217). The best humor sits in interaction and eavesdropping, not in cut
scenes (pp.157-158). **Rule:** a joke in a grief scene comes only from the character whose way of coping is joking
(Alberica). One quip per tragic scene at most.

### D. Player agency, choice and branching (Herald mode)

**D1. The player is the star, so the narrative must support the fantasy.** Players shouldn't watch NPCs fight the
big battles (p.9). When the game starts *telling* the player what their character has achieved instead of letting
them achieve it, treat that as a serious warning (p.137). Unrelieved misery isn't a fantasy anyone signs up for
(the Book of Job, p.9). **Rule:** in every chapter, the decisive action of each climax is the player's: a battle,
a choice, an item used. A companion may land the blow only if the player set it up.

**D2. Taking control has costs: forced failure, stolen rewards, removed choice, teasing.** Forced failure punishes
success (pp.18, 135). Taking hard-won items away in a cut scene feels like punishment (p.136). When the avatar acts
in a scene the way the player wouldn't, the game and the player end up in conflict (p.136). If the avatar does
things the player can never make them do, that's teasing (p.137). *Here:* in Herald mode **the player is a named
party member**, so every `as()` line and stage direction makes that character act for the player. **Rule:** a
Herald's scripted actions must fit the Voices doc. Where the scene can bear it, offer `speak()` (loud or soft, but
always in character). Never script a Herald into a betrayal, a cruelty or a loss the player hasn't been led toward.

**D3. When a death or loss is unavoidable, stage it where the player can't act.** A cut scene is the right place to
kill a supporting character. The player sees nothing could have been done, and doesn't spend hours trying to save
someone the design has already doomed (pp.128, 130, 138-139). Leave room for a farewell. Avoid the "Nooooo" cliché
(p.139). Players can tell a meaningful death from a plot sacrifice (p.117). **Rule:** losses (Shimmer, Glimmer at
the Forge) play under a panel or vision with movement locked. Afterwards, update party chat and NPC lines to
acknowledge the loss.

**D4. Reflect small player actions; it makes the game feel like it notices.** The immediate-level story (what *this*
player did) can matter more than the plot (pp.77-78). Someone complaining about water pressure after the player
flushed every toilet, or the girl furious about her escaped beetles, makes players feel seen (pp.78-79). Anything
that helps the illusion that the game understands the player is valuable (Boon p.65). NPCs can keep count ("Wow,
you sure hate Orcs", p.61; troll tally, p.64). **Rule:** every player choice (`pbMessage` options, `speak()`
picks) that sets a flag must be read back at least once later. A flag that's set and never read is a choice that
was thrown away.

**D5. Branches cost a lot and must really differ.** Branching multiplies content without limit, and players
usually play once (p.76). Parallel paths that rejoin are the workable compromise, but each branch must feel
significantly different, otherwise the choice is meaningless (p.76). Dialogue "trees" are mostly linear with
small detours (pp.277-278). **Rule:** prefer one scene with flag-gated *inserts* (the Glimmer journal block is the
model) over separate branches. Where a branch exists, write down in a comment what the player feels differently
afterward.

**D6. Rejoined paths make the game state ambiguous.** After branches merge, dialogue can assume something that
didn't happen (p.80). This is the San Andreas failure: a cut scene says the hero needs money while he has
$2 million in the bank (p.74). **Rule:** a line that refers to a past event checks the flag for that event. Never
assume the route.

### E. Quests and side content

**E1. The spine is plain and certain; the golden path is signposted more subtly.** The spine (what must happen)
must be impossible to miss. The golden path (best rewards) can hide a little. "Solving the puzzle should be the
challenge, not working out what to do next" (p.89). If something is mandatory, give it a narrative reason or put it
at a choke point (p.88). **Rule:** a side quest may be cryptic. A spine step may not.

**E2. Breadcrumbs need a reason the character would act on.** "If you need something to keep you busy" (Jak) is
weaker than a grandmother asking you to fetch your sister. Same instruction, but the relationship justifies it
(pp.91-92). Archetypal situations (a kidnapped friend) tell players what to do without exposition (p.93). **Rule:**
each quest hand-off answers "why would *this* person ask *us*, and why now?" in the same box as the request.

**E3. Don't hide the spine in optional topics.** Players who know RPGs exhaust every dialogue option; others won't.
Put spine dialogue at the start or end of a conversation, or give the player a second chance to learn it if they
missed it (pp.93-94). **Rule:** spine info never sits only in a repeat-talk branch, an optional NPC, a sign or a
book.

**E4. Choke points and functional choke points.** Trigger spine events where the player must pass (a single
corridor, the only exit), or where play will send them anyway, like shops and healing (pp.94-95). Using a funnelling
character at a functional choke point is the ideal (Mina in Castlevania, p.97). *Here:* resting at an inn or the
Hearth is a functional choke point. The game already uses it (Nimsy's attic, Hearth rest banter, trial days).
**Rule:** if a rest triggers a story beat, make the prompt or the lead-up hint at it, so the player doesn't rest
just to heal and find themselves in Act I's worst night.

**E5. Optional material is optional, well placed, and resonates with the theme.** In-game texts deepen the world but
must never be required reading (Boon p.49). Don't place them right before a boss; after is better (p.66). Side
quests can echo the spine thematically (p.44). Self-contained mini-plots can be cut without leaving holes
(p.156). **Rule:** each side quest states its thematic echo in its header comment (e.g. "debt", "what winter
takes"), and can be removed without breaking a spine line.

**E6. Layer details by relevance.** Rate each story detail from 1 (needed to follow the plot) to 6 (garnish). Put the
1s in vehicles everyone sees and say them more than once in more than one way. The 5s and 6s can live in optional
corners (DeMarle p.82). Test the story by shuffling its pieces, as if on index cards, to see if it still makes
sense in any order (p.83). **Rule:** in a hub week, each rating-1 fact must make sense whichever order the player
does the sub-quests in.

### F. Exposition and lore delivery

**F1. The player and the character know different things.** Players arrive knowing nothing. Characters know their
world. The writer has to bridge the gap, and "only so many games can use amnesia" (pp.10-11). Fantasy needs more
exposition than realism (pp.3, 33). *Here:* the Journey newcomer is a built-in bridge: someone can believably
explain things to them. A Herald can't believably explain their own life to themselves. **Rule:** route basic lore
through the newcomer in Journey mode, and through NPCs or companions in Herald mode. A Herald's thought never
explains something the Herald already knows.

**F2. Keep gameplay in the writing.** Ask of every passage: does it reward the player, advance the action, or add
depth without slowing play? The essay on dwarven tiddlywinks belongs in a book the player can choose to read, not in
a speech they're forced to sit through (p.10). Internal monologue should be short, functional reminders, like Sam
Fisher's notes to himself, not long reflections (p.10). **Rule:** Herald thoughts are short reminders or reactions,
one box, and usually point toward the next action. Long reflection goes into an optional item or a rest-point
scene.

**F3. Choose the vehicle for the information.** Cut scenes give certainty and focus (p.132), but cost the player
control. In-game artifacts are cheap and suit character revelation and hints (pp.129-130, 138, 140). A negative
example is a hint too: let an NPC fail at the dangerous thing (p.140). Clear communication with the player can
matter more than strict immersion (p.130). **Rule:** a rating-1 fact goes in a scene. Rating 3-4 goes to an NPC or
a sign. Rating 5-6 goes in a book, an item description or a scrimshaw tooth.

**F4. Foreshadow close to the payoff.** In a long game, foreshadowing twenty hours ahead is forgotten. Repeat it, or
place it closer (p.134). Warning the player about a future irreversible event is foreshadowing a *game* element
(p.100). **Rule:** any setup for a payoff more than one chapter away gets a reminder in the chapter just before.

### G. Environmental storytelling, panels and staging

**G1. Every element of the world can tell story.** Buildings decaying toward the city center, fog thickening near
the source of corruption, a family crest on an object (p.81). Signs, posters and storefronts can carry jokes and
story (comedy chapter p.158). Density, like overheard guards, news and NPC chatter, makes a world feel bigger than
the slice the player touches (Pratchett p.198). **Rule:** for every new map, give the art and map builder at least
one visual story detail (frost patterns, a draped chair, a lantern for the dead), and one sign or eavesdrop.

**G2. Static images can stage what the engine can't.** Static art with pans and fades, comic-strip panels, and
camera cases (p.53) are cheap. Use them for spectacle or for events the engine can't animate. Cover a scene cut
with them instead of loading a map just for narrative (p.54). Showing off a striking asset is a legitimate reason to
take control (p.134). If you can't depict something, suggest it with framing and dialogue (p.55). **Rule:** a panel
should show what the text *doesn't* say. Don't caption the art. The boxes under a panel add sound, speech and
consequence, not a description of the picture.

**G3. Scripted events only work where the player is looking** (p.56). **Rule:** when a scene uses map actors
(`Stage.actor`, `walk`, balloons), lock or turn the player first. Never rely on a player noticing movement during
free control.

**G4. Know your resources, and write scalable scenes.** Find out what assets, poses, panels and effects exist before
writing. Write a fallback version. Know which parts of the scene can be cut and which can't (pp.21-22, 142-143).
**Rule:** each scene that requests new art lists the request in `art_requests_W*.md` *and* has a fallback in the
code: text-only narration if the panel is missing (the existing `rescue nil` pattern).

### H. Consistency and continuity

**H1. Inconsistency unravels a story that the player can explore.** In a static medium, gaps can hide. In a game the
player has time to find them, and once found they pull at everything (pp.72, 80). Every character, line and branch
must be consistent (p.80). Seams break immersion. Usage and tone must stay consistent (pp.16-17). Coherence and
credibility are the writer's share of realism (Pratchett pp.198-199). **Rule:** a single glossary for proper nouns
and objects (the mark, the rune, the Rimefang, the Heart of Winter, the Lumen Shard), with one name each. Pronouns
for every character go in the Voices doc.

**H2. Serve the IP: tone, world, characters.** A licensed game fails when a familiar character acts out of type or
known facts are contradicted (p.171). The IP comes down to tone, world and characters. Minor NPCs set the tone as
much as the leads do (pp.172-173). "Kisses with continuity", small nods to the source, please fans, as long as they
don't get in the way of casual players (pp.172-173). Additions must serve the core story, not upstage it
(pp.176-177). Don't over-connect: a scene that hinges on an obscure detail fails people who don't know it (p.178).
*Here:* the campaign record and Story Bible are the IP, and the owner's table are the fans. Pokémon conventions
(gyms, starters, the Center) are the second IP. **Rule:** a nod to the campaign must also make sense, and land, for
someone who never played it. A Pokémon convention must be justified inside the world (Mishann's healing at the
Morninglord's house does this well).

**H3. Tabletop is not a videogame.** At a table, a GM improvises. A game has to anticipate everything the player
could do, and is a closed system (pp.7-8). "Because he can": players will try what you didn't plan for (p.71).
Moments that worked at the table (captures, confiscations, a GM's dramatic fiat) can feel like forced failure in a
game (pp.18, 135-136). **Rule:** when adapting a campaign beat in which the players were helpless, keep the outcome
but stage it as a cut scene. Afterwards, give the player something new to make up for what was lost.

**H4. Triggered lines must make sense whatever route the player took.** A ship's boarding line on the gangplank is
wrong if the player came aboard from a crane (p.269). Writing dialogue that always makes sense, whatever came
before, is a core game-writing skill (p.269). **Rule:** for each location-triggered line, list in a comment every
way the player can reach that tile. Check warps and backtracking, and whether the line can fire twice.

### I. Working method: bibles, scripts, review

**I1. The bible is a reference, not a quota.** Bibles and character sheets let the whole team picture the cast.
Markers help, like Poirot's porcelain cup set against a detective's polystyrene one (pp.122-123). Never feel you
have to use every fact you've recorded (p.123). Short character bios for performers (p.126) work here as one-line
reminders at the top of each character's lines in the Voices doc.

**I2. Plan the narrative design before writing lines.** Decide which information goes in scenes and which in play,
what is spine and what is optional. Keep the flowchart of the game's structure in view ("nail it to the nearest
wall", p.61). Tag gameplay information separately from story information (p.62; process pp.67-69). **Rule:** each
chapter file's header comment lists its spine beats, their triggers, and the flags they set and read (036's header
is close to this already).

**I3. Plan line counts for repeated content.** For an event that recurs, write enough variants that a player rarely
hears a repeat. A frequent event needs a short line; a rare one can be long. Long lines play once, then fall back
to a shorter version (pp.242-244). Bateman's rule of thumb: count how often the line plays per session (the
minimum) and per game (the maximum), keep doubling the minimum, and take the middle value of that sequence (pp.271-272).
Catchphrases are the exception (p.271). Cycle through variants without repeating (p.243). **Rule:** repeat-talk
NPCs cycle through variants (Iriskree's three dead friends is the model). Party chat for an area the player revisits
often needs at least 3 variants per companion, or variants keyed to chapter or flags.

**I4. Banter lines must stand alone.** Commentary and banter scripts are written so each section makes sense even
when other dialogue plays in between (pp.279-283). A talk button must always answer, never with silence (Boon p.65),
and players shouldn't hear minutes of chatter followed by minutes of silence (p.66). **Rule:** every party chat
entry makes sense on its own, in any order, in any chapter that area is reachable. The "Nothing to say about this
place. Yet." fallback should be rare.

**I5. Keep dynamic logic simple; use defaults.** Flags and once-only flags handle small variations, such as the
barrels line that plays once (pp.285-286). Deeply nested conditions turn into spaghetti; leave the logic to the code
where possible (pp.287-288). Case statements need a Default (pp.288-289). NPC moods (friendly, neutral, hostile)
are cheap in text (p.289). Text strings (`$name`, gendered `$he`) are a text-only engine's big advantage (p.290). Don't build
sentences from interchangeable verbs. Write a separate whole line for each case instead (p.256). Avoid gluing
fragments together if the text may ever be translated (p.204). **Rule:** a lambda branch has a final `else` that
is a full, sensible line. Pronoun swaps for "you" versus a name go through one helper, not ad-hoc string
interpolation.

**I6. Prototype early, test in place, keep a change log.** Get placeholder text into the game early (p.216). Test
the script in place, looking for lines that clash, fire in the wrong spot, or don't fit their context, especially
where one set of lines serves several situations (p.69). Never duplicate material inside a script (p.68). After a
round, compare what was intended with what's on screen (pp.234-235). **Rule:** each writing round ends with a
headless or in-game pass over its scenes in Journey and in every Herald mode that can reach them, logged in
`docs/coverage_*.md`.

**I7. Stay part of the team.** Fit your ambitions to what the team and engine can build, provide the connective
narrative when content is cut (pp.19-22), and get buy-in by showing the work to the team (p.22). The writer makes
the final call on their own lines (pp.160, 219), and their name goes on the result (p.159).

---

## 3. Scene checklist (34 items)

Run this over any scene: a `scene_*` method, an NPC lambda, a party chat block.

**Box and line**
1. No message overflows one ~90-char box (2×45), counting the `NAME: ` prefix and `(...)` stage directions.
2. One beat per box. A box doesn't split mid-sentence into the next one.
3. Spine information is at the *front* of its line, in plain words (place names spelled as on the map/sign).
4. Read aloud: no tongue-twisters, no stacked subordinate clauses, no line that only works on paper.
5. Cover the speaker labels: each voice is still identifiable (tic, register, forms of address).
6. Feelings shown or implied, not announced, unless the speaker is the kind who announces (B4).

**Scene shape**
7. The scene's required information fits in ≤3 sentences, written in a comment at the top.
8. The player does or earns something in or right after the scene (battle, item, choice, badge, panel).
9. Non-interactive stretch: count the boxes. More than ~25 without input means trim, or add a choice or action.
10. Exposition is broken up. No monologue runs longer than 4 boxes without an interjection.
11. Every recurring element (villain, object, place) used here was set up earlier, or is set up now for later.
12. Jokes come from a character whose comic register fits, and there's at most one in a grief beat.

**Herald mode and Journey mode**
13. Run the scene in your head in Journey *and* as each Herald who can be present. Does the text still make sense?
14. Herald narration uses "you/your" (the `me ? ... : ...` pattern). No third-person stage direction about
    the player (`as()` turns "(under her breath)" into narration *about you*).
15. A line that another character *answers* is spoken aloud (`speak()` or a plain line), not a `(thought)`.
16. Every Herald who could be present gets at least one beat, thought or choice in a major scene. Nobody is a
    silent spectator to their own story.
17. The scene doesn't make a Herald do something out of character, or something the player would refuse,
    without a `speak()` choice or a clear lead-up.
18. A Herald's thoughts never explain their own backstory to themselves. Lore goes to the newcomer or to NPCs.
19. Mode-specific lines (`herald?`, `cl`, `with_or_is?`) fall back to a full sentence when the character is
    absent; `.compact` is applied, so no stray `nil`s.

**Choice and state**
20. Every flag the scene sets is read somewhere later (`grep` the flag name). Choices echo at least once.
21. Every past event the scene refers to is checked with a flag. No assumed route (D6).
22. The scene can't fire twice, or it's written to be heard twice (once-only flags, `return if flag?`).
23. A location trigger makes sense from every way onto that tile, including warps and backtracking (H4).
24. Irreversible steps (a party member leaves, an area closes, an item is taken) are hinted before they happen
    and confirmed after, the same way every time (e.g. "X left the party." to mirror "X joined the party.").
25. If something is taken from the player, the scene or the next one gives something back.

**Guidance**
26. `state[:goal]` is updated, is one short sentence, and names the next concrete place or action.
    (Party chat prints it in a box, so it must fit.)
27. The next step is in a scene line, in the goal, and in one replayable source (C2).
28. A quest-giver's reason (why us, why now) is in the same box as the request.
29. Spine steps use plain language; cryptic hints only for optional and golden-path content.

**World, aftermath and continuity**
30. Party chat and NPC repeat lines for affected areas are updated after the beat (the dead aren't mentioned as
    present; hostile NPCs turn hostile).
31. Proper nouns, object names and pronouns match the glossary and Voices doc (mark/rune, Shade/Glimmer).
32. Campaign references land for a player who never sat at the table (H2).
33. Panels show what the text doesn't say; the boxes under a panel don't caption it. Missing art falls back cleanly.
34. Map actors and effects run only while the player is locked or facing them (G3).

---

## 4. What this means for Frost & Thaw

1. **The message box is the unit of writing, and of pacing.** At ~90 characters a box, the book's "short and sweet"
   is a hard limit, not a style choice. Overlong strings don't break the engine. Essentials continues them in a new
   box, but the split falls wherever the wrap lands, often mid-clause, and the speaker label disappears from the
   continuation. In the three scenes checked below, `scene_shimmer_taken` keeps every string at or under 89
   characters; `glimmer_arrives` has 16 of 64 strings over 90 (longest 136); the Chapter 10 tribunal block has
   11 over 90 (longest dialogue line 125). *Failure mode:* the most emotional lines get the longest, so climaxes
   are where boxes split badly.

2. **Herald mode is the "removing player choice" problem made permanent.** Dansky's warning (p.136) is about a
   cut scene making the avatar act against the player's idea of them. In Herald mode, every `as()` line is the
   player's own character speaking or thinking. `speak()` (loud or quiet, always in character) is the right tool
   and follows the Voices doc. Use it whenever a Herald's line is a decision, a declaration or a confrontation.

3. **`as()` produces two systematic POV slips.** (a) A stage direction like `"(under her breath) I sneezed."`
   becomes the narration `"Under her breath. (I sneezed.)"`, third person about *you*, when the rest of Herald
   narration says "you/your". A pattern search finds **65** `as`/`cl` calls on Herald keys whose stage direction
   has a third-person pronoun (some refer to someone else, e.g. Meat Meat "poking his arm" at Glimmer, so not all
   65 are wrong). Examples: `007_Story.rb:288` "(face in his cloak)", `024_Chapter6.rb:535` "(wiping her eyes)",
   `036_Chapter10.rb` tribunal "(under her breath)". (b) `as()` turns the Herald's line into a `(thought)`, yet
   scenes then have other characters *answer* it. As Alberica, "(Shade. Look at me. We go together.)" is addressed
   to Shade but never said aloud. As Alberica, "(...Shade?)" gets the answer "Glimmer, now." As Reptin,
   "(Let me do the talking...)" gets a reply from Meat Meat, and Reptin's "(Especially not you.)" answers her
   in thought. *Fix direction (not applied, read-only round):* either have `as()` map
   her/his→your in Herald stage directions, or document that a parenthesised Herald line is *said*, and use
   true thoughts only where nobody reacts. Then audit the 65.

4. **Silent Heralds at their own big moments.** In `scene_shimmer_taken`, Reptin and Meat Meat get no beat; a
   Reptin player watches Act I's defining loss with no thought or line. In the tribunal, Wyn is charged
   ("abandoning the Underdark door") and gets no reaction in any mode. `glimmer_arrives` has no Wyn line (whether Wyn can be present there depends on festival order; check it). The book's
   group protagonist (pp.112-113) and the "player at the center" rule (p.9) both point to the same rule: every
   Herald who can be present gets a beat. It can be a single `cl()`.

5. **Choices that are never read back.** `glimmer_arrives` asks "Shade looks at you last": "Go." or "Come back."
   It sets `:told_shade_go`, and no file ever reads it. DeMarle's beetles (p.79) show how cheap a single echo is:
   Glimmer could say "You said go. I went." at the Forge. Run checklist item 20 across the whole script: grep every
   `set_flag` that comes after a `pbMessage` choice or a `speak()` return value.

6. **The goal line is the pause-screen funnel, and it is shown in a box.** `party_chat` opens with
   "Where we're headed: {goal}" every time. Bateman calls pause-screen objectives crude but "instantly
   understandable" and recommends them for a wide audience (p.97). The Chapter 10 goal is a ~245-character list of
   seven destinations, so every party chat in the trial week opens with three or four boxes of itinerary. Keep the
   goal to one sentence (the most urgent or nearest item) and leave the full list in the witnesses menu.

7. **Party chat is a banter engine; treat it like one.** It works area by area, companion by companion, with flag
   conditions (Lonelywood's post-Shimmer lines are well done: "I should have been awake."). Two risks:
   (a) **staleness**: areas that can be revisited keep lines that refer to people who are gone. Shade's Targos and
   tavern lines still talk about Shimmer as present ("Shimmer's usually right."), with no `shimmer_taken`
   condition. Check whether Targos can be revisited after Chapter 3. (b) **repetition**: one fixed pair of lines per
   area per companion. Add variants for hub areas (Rootspire tiers) using Bateman's doubling rule.

8. **The Journey newcomer is your exposition bridge; Heralds are not.** The book's player/character knowledge gap
   (pp.10-11) splits along the modes. Journey players need the Dale and Rootspire explained, and the time-travelling
   newcomer is a legitimate person to explain things to. A Herald explaining their own pendant or curse to
   themselves rings false. Mode-specific variants should give *lore* to the newcomer and *reaction* to Heralds.

9. **Losses and transformations: stage them where you can't act, then pay back.** The game already does this well:
   Shimmer's sacrifice plays in a vision where "none of you can move" (Dansky p.138). The weak spot is the
   bookkeeping afterwards. `glimmer_arrives` ends with "Glimmer joined the party.", but `scene_shimmer_taken`
   removes Shimmer silently. Use the same system message for every departure, and make sure something is given in
   return (the cat, the rose, a new lead) so the scene doesn't read as stolen reward (p.136).

10. **Rest is a functional choke point, so use it honestly.** Nimsy's attic, Hearth rests and trial days all hang
    story on resting (Bateman pp.94-95). That's good design. But a player resting only to heal can trigger an
    irreversible beat. Make the lead-up say plainly that the night matters ("Sephek said before the next moon"),
    and give the prompt a flavour line on the irreversible night.

11. **Panels are static-image cut scenes; write for them, not over them.** Boon's advice on static images (p.53)
    and on covering cuts instead of loading maps for narrative (p.54) is what `Stage.panel` and `Stage.visit` do
    (S-04 and S-05 covering the Glade cut is a clean example). The text under a panel should carry what the
    512×384 image can't: sound, speech, aftermath. "A stone circle in the birches" can stay as orientation, but
    don't describe what's already painted.

12. **Optional content: hub weeks must survive any order.** Chapter 10's week (Anduin, Phildendrin, Wyn, Talion,
    Alberica's debate, the civic layer) is DeMarle's "gated story" (pp.74-75). Use her index-card test (p.83):
    every witness line and verdict line must make sense whichever sub-trials came first. The `witness_line`
    substitution (`{MAERA_KEPT}`) is the right kind of state check (D6). Extend it wherever a line names who did
    what.

13. **Two IPs to serve, one player who knows neither.** The campaign is the canon. Its "kisses with continuity"
    (Rootspire's festival, Hellen's wall, the sixth figure) delight the owner's table. Swallow's warning against
    over-connecting (p.178) applies: a reveal that depends on remembering a session the player never saw (or a
    flag from an optional dungeon) must still read as a complete beat without it. The Glimmer journal insert is
    the model: it's an extra layer, and the scene works without it.

14. **One name per thing, one pronoun per person.** With time travel, a loop and transformations, internal
    consistency (DeMarle p.80) is under unusual strain. Examples to settle in the Story Bible and glossary:
    Alberica's chest "mark" (Chapter 2: "a snowflake, cut by a crown") becomes a "rune" in Chapter 3. Shade is
    "they" ("their own empty hands") until stepping through the mirror, and Glimmer is "he" from then on. If that's
    intended, say so in the Voices doc so later writers don't "fix" it either way.

15. **Likely failure modes, summarized:** box overflow at climaxes; Herald third-person slips; Heralds who think
    replies nobody should hear; silent Heralds; flags set and never read; stale party chat after a death; an
    itinerary-length goal line; spine information only in an optional NPC; rest-triggered irreversible beats with
    no hint; and campaign in-jokes that need the table to make sense.

---

## 5. Three scenes against the checklist

### 5.1 `015_Chapter3.rb` `scene_shimmer_taken` (Act I, SC 3.03–3.04)

*What works.* This is the strongest of the three. It's well within the boxes: all 35 strings are ≤89 characters,
one beat per box (items 1-2). It opens on show-don't-tell: the empty bedroll, the note, the carved cat. Shade's
"...She always does this." holds a whole relationship in subtext (6, B4). The death is staged where the player
can't move, framed as a vision, with a farewell and no "Nooooo" (D3, pp.138-139). Panels S-04 and S-05 cover the
map cut, with an overlay frame and effects that sit in a locked scene (33-34). The Alberica-Herald narration is
handled properly with `me ? "Your pendant…" : "Alberica's pendant…"` (14). The next step is said three times: in
Alerion's `speak()` ("East. The old logging road."), in the goal line, and in the lantern-bearer waiting under the
window as a hook (26-27).

*Problems.*
- **Item 16:** Reptin and Meat Meat get no beat. For a Reptin or Meat Meat player, Shimmer's loss passes with no
  interior moment. One `cl(:reptin, …)` and one `cl(:meat_meat, …)` after "No. No, no, no." would fix it.
- **Item 15:** As Alberica, "Shade. Look at me. We go together. Nobody goes alone." becomes a thought, though
  it's spoken *to* Shade. It should go through `speak()`.
- **Item 24:** Shimmer leaves the party with no system message, while Glimmer's arrival gets "Glimmer joined the
  party." It's inconsistent bookkeeping for an irreversible change.
- **Item 6 / B4:** the vision dialogue states its theme outright ("This isn't salvation. It's surrender.",
  "Damnation, or servitude."). The book would trim one of these and trust "There's always a third way."
- **Item 31:** "The rune on your chest" picks up the Chapter 2 "mark". Settle on one word.
- **Item 24 / E4:** the beat fires on the first accepted rest at Nimsy's. A player resting only to heal walks into
  it. Sephek's deadline is set up, but the rest prompt doesn't hint that this night is different.

### 5.2 `029_Glimmer.rb` `glimmer_arrives` (Act II, SC 6.08)

*What works.* The scene layers flag-gated inserts: `luna_spark`, `heard_of_glimmer` (the carved cat beside his
face, "I hate that she was right."), `sanctum_dream`, and the Chasm journal ("That's how I make my G."). That is
DeMarle's reflection of the player's own exploration (pp.78-79, 82), done without branching (D5), and the scene is
complete without any of the inserts (H2). The Brightmane shadow test ("Will you bear hope when even the sun
freezes?" / "...Yes. Somebody has to.") is a strong, short character-defining beat. The off-key hum carries
continuity through the transformation (B3). The Alberica-Herald variant inside the journal block ("to you") is
handled (14), and the absent-Alberica fallback narration is a full sentence (19). The scene gives a reward and
announces it clearly ("Shade is Glimmer now. Glimmer joined the party.") (24).

*Problems.*
- **Item 1:** 16 of 64 strings run past 90 characters (136, 134, 122, 121, 108...). The inscription in capitals is
  108 characters. The transformation narration ("He reaches for the Lumen Shard. As his hand closes, a shadow of
  him forms…") will split mid-clause. Split these at sentence boundaries.
- **Item 9 / A6:** the scene is long (well over 40 boxes on a full-flag run before the end message) and finishes on a
  run of explanation from Glimmer: Brightmane's torch, the Rimefang's curse, "Still killing me slowly, since
  Saltmarsh". Dansky's trimming order (p.146) says cut backstory first. The Rimefang could get one line, and the
  torch exchange could move to a later rest scene.
- **Item 20 / D4:** "Shade looks at you last." sets `:told_shade_go`, which nothing ever reads. Either pay it off
  later or drop the choice.
- **Item 15:** as Alberica, the `cl(:alberica, "...Shade?")` thought is answered by Glimmer.
- **Item 16 (check):** no Wyn line in any mode. Wyn joins at the end of Chapter 6's festival (`024_Chapter6.rb:498`),
  and this scene belongs to "the festival's business", so confirm the order. If Wyn can be present (or is the Herald), add a beat.
- **Item 31:** Shade is "they" ("their own empty hands"), and Glimmer is "he". If intended, document it.

### 5.3 `036_Chapter10.rb` `scene_tribunal` + `scene_trial_morning` (Act II, SC 10.01)

*What works.* The scene shows before it tells: the child shouting "Murderers!" and the refugee mother hushing her
show the city divided before Kelyn says "Some call you liberators. Some call you murderers." (B4, and redundancy
used on purpose, C2). The two gold and red chairs draped in white are a good symbolic artifact (p.4). The
Reptin/Meat Meat aside ("Let me do the talking. Please." / "Especially not you.") is a well-built duo exchange
(p.112) and relieves the pressure without undercutting the stakes (12). The mechanic is explained in a plain
system line ("The Heralds menu now keeps a list of your witnesses and evidence."), Boon's tutorial-text advice
(p.50). The next morning's carpenter gives a breadcrumb with its reason in the same box: "People remember who
lifted something." (28). Underneath, the trial week's opinion, day and neglect counters are interactive narrative
of the kind the book praises (Boon pp.46-47, 64).

*Problems.*
- **Item 1:** 11 strings over 90 characters, including Kelyn's list of sentences (125) and the plaza narration
  (124).
- **Item 7 / A6:** the scene's core is four things: you're charged, seven days, bring witnesses, two chairs will
  be filled. But it also delivers four separate charges, three kinds of sentence and the appeal route. The
  sentences and appeal (rating 3-4 facts) could move to the witnesses menu, the town crier, or a Council clerk NPC.
- **Item 26 / §4.6:** the goal set here is the ~245-character itinerary, and every party chat that week opens by
  printing it.
- **Item 16:** Wyn is charged here ("abandoning the Underdark door") and gets no reaction in any mode, and a Wyn
  player is silent at their own indictment.
- **Item 14:** as Alberica, `as(:alberica, "(under her breath) I sneezed.")` shows as "Under her breath. (I
  sneezed.)", third person about you.
- **Item 15:** as Reptin, the "(Let me do the talking...)" / "(Especially not you.)" pair are thoughts that Meat
  Meat answers.
- **Item 13 (check):** in Meat Meat mode, Kelyn says "Meat Meat is charged separately. The Autumn Warden died by
  her hand." to your face, which works as formal court speech. But nobody addresses the Journey newcomer, who is
  also one of "the Heralds of Dawn and Dusk". A single line ("And you, the stranger on Hellen's wall…") would
  include them.
