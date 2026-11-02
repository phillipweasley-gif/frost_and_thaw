# Craft guide: *Professional Techniques for Video Game Writing* (ed. Wendy Despain, 2nd ed., 2020)

Distilled for **Pokémon Frost & Thaw**. Page numbers are the book's printed page numbers (PDF page = book page + 21).
Quotes are kept to a sentence or less; everything else is paraphrase.

---

## 1. Overview

**What the book is.** It's an anthology of 19 chapters by working game writers. It's practical and not theoretical: jobs, script
formats, documentation, help text, tutorials, productivity, collaboration, AAA vs indie, remote and staff work,
localization, voice recording, licensed and new IP, script doctoring, character writing, hiring, and narrative tropes.
Four appendices give real samples: a *Call of Juarez: Gunslinger* script whose cutscenes are dime-novel illustrations
with narration over gameplay, a modified-screenplay task script from *Bratz*, per-character bark pools, and casting
specs.

**What matters most for Frost & Thaw.** About a third of the book is career advice, studio politics, VO casting
and localization pipelines, which mostly don't apply here. The useful core is:

- **Ch. 5, Writing Tutorials (Walsh).** This is the best chapter for this game. It covers the "golden ingredients" a player must
  learn, central conflict, aligning the player with the protagonist, show/do/feel vs. tell, the newcomer and
  expert-character problems, and "kill the backstory". It maps directly onto Journey mode (a newcomer) and Herald mode
  (playing an expert who already knows the world).
- **Ch. 17, Writing Compelling Game Characters (Harms).** Covers what each character wants, worldview flavouring exposition,
  strength = weakness, the player and player-character agreement, the PC driving the story, and an antagonist who
  is the hero of their own story.
- **Ch. 15, New IP (Pratchett), and Ch. 14, Existing Licenses (McDonald).** This game is both: a new world built from the
  owner's D&D campaign (Rootspire / *Rime of the Frostmaiden*), which works like a licence whose "fans" are the
  table. These chapters cover ambient dialogue as feedback, story webs for any-order content, distinct voices in a
  large cast, canon discipline, and giving fans "what they expect and what they do not expect".
- **Ch. 16, Script Doctoring (Dansky), Ch. 13, Recording Studio (Orkin), and Ch. 18 (Abernathy).** Line-level craft:
  shortness, the one-breath test, subtext, motivation behind every line, and consistent voice.
- **Ch. 2, 3, 8 and 11.** Working method: formats, character folios, relationship matrices, plot guides, bibles, table
  reads, and narrative pillars.
- **Ch. 19, Tropes (Suckling).** Covers amnesia, audio logs (our signs, notes and items), breadcrumbing, the
  "walkie-talkie" helper voice (our party chat), and the danger of making the hero fetch on command.

The book's recurring message fits a game told in two-line message boxes: **say less, mean more, let the
player do and feel instead of being told, and keep every voice and fact consistent across a huge, non-linear
script.**

---

## 2. Principles

Each entry gives the principle, why it matters here, a **Rule** a writer on this game can follow, and the page
reference.

### A. Story structure and pacing

**A1. Every story point has to earn its place.** Before scripting, list the beats and ask of each one what makes
it compelling, how it moves the story forward, what it adds to the central conflict, and whether there is room for it.
If a beat can't answer, change it or cut it (p. 80). Start with plain beats and voice them afterwards
(p. 97).
*Why here:* chapters are long and each beat costs several message boxes.
*Rule:* every scene function starts as a 3-8 line beat list in a comment (`# beat: Shimmer leaves a note`).
Delete any beat that doesn't change a goal, a relationship or the player's knowledge.

**A2. Give the player a push or a pull at every step.** Narrative drive pushes the player away from something
(fire, an accusation) or pulls them toward something (a cry for help, a mystery). Each completed step should open the
next one (p. 80).
*Why here:* a hub chapter (Ch. 10's trial week) can go slack without urgency.
*Rule:* every scene ends by setting `state[:goal]` *and* with a last line that pushes or pulls: a figure waiting
in the snow, a bell ringing, a deadline spoken aloud.

**A3. Start where things change.** Stories begin at a moment of change that has happened, is happening, or is about to
happen (pp. 80-81). Big-bang openings have to avoid cliché (p. 81). A slow burn is about the pace of
*action*, not room for exposition (p. 82).
*Rule:* open each chapter on the change itself, not on a recap. A slow open still needs a visible question or
threat inside its first five boxes.

**A4. Structure controls the emotion.** The same events read as suspense if the player knows the secret, or as
mystery if they don't. Decide which one each reveal is (pp. 79-80).
*Why here:* Frost & Thaw carries big secrets (Avarice wearing Var, the faked death at the Forge, Glimmer's time
loop).
*Rule:* for every secret, write in the plot guide who knows what by which chapter, and whether the player is
meant to be *ahead of* or *level with* the party.

**A5. Any-order content needs self-contained nodes.** *Overlord*'s domains could be played in different orders, so
each one carried its own mini-tale plus loose pieces of the main plot (p. 209). A nodal plot guide records
each location's stages over time: who is there, what the player can change, what they learn, and how it ties to
other nodes (p. 31).
*Rule:* in hub chapters, no node's dialogue may assume another optional node has been done unless it checks a flag.
Keep a per-location stage table (before, during and after the trial, for example).

**A6. Cutting is allowed.** You don't have to walk the player through every step between two interesting moments
(p. 267). The story can play out slower than the gameplay (p. 82).
*Rule:* use a fade or a one-line narration ("Morning.") instead of scripting travel or sleep. *scene_shimmer_taken*
does this well.

### B. Character and voice

**B1. Know what each character wants, why, and how they mean to get it.** Characters are defined by their goals
(p. 69). Background has to shape their worldview, not just explain a skill (pp. 236-237). Every line,
even "Hello", is said *for* something (p. 176).
*Rule:* before writing a scene, note for each speaker *wants / why / tactic* in a comment. If a line serves none of
these, cut it or give it a purpose.

**B2. Greatest strength = greatest weakness.** Loyalty that blinds, patriotism that excuses horror (p. 238).
Introduce characters with three adjectives, two of which conflict (p. 70).
*Why here:* five Heralds, plus Shade/Glimmer, Shimmer and Wyn, need arcs that come out of who they are.
*Rule:* each Voices entry names one strength/weakness. Every major scene for that character should press on it.

**B3. Distinct voices in a big cast.** Big casts tend to blur into one voice. Small casts let each voice sharpen (p. 212).
Fully realised characters "write their own dialog" (p. 92). Exercises: list ten words or phrases a character always
uses and ten they would never use, then write them happy, angry, with a friend and with someone who dislikes them
(p. 233). Character traits change even the smallest phrase: "of course" becomes "totally" or "certainly" depending on who
speaks (p. 155).
*Rule:* blind test. Hide speaker names on a party-chat exchange. A reader who knows the cast should
identify every speaker. Where two companions could swap a line, rewrite one of them.

**B4. Verbal tics are spice, not wallpaper.** The *Bratz* bark pools (Appendix C, pp. 291-299) show how quickly
characters converge on the same exclamations ("Woo!", "No way!", "Sweet!" recur across different girls).
*Rule:* ration signature tics (Alberica's *darling / sweetheart / sugar*; Meat Meat's third person; Reptin's
diplomat's understatement). At most one pet name per Alberica beat, and never in a line about grief unless the
tic is the point.

**B5. Consistency is a promise.** Players notice when a character slips (pp. 238-239). If one character's
contractions are removed, remove them everywhere (p. 231). Track how relationships change, because scenes get written out
of order (p. 175).
*Rule:* keep a "definitive lines" sheet per character (p. 232) and a relationship matrix with one or two words per
pair (pp. 29, 110). Update it the moment a scene shifts a relationship.

**B6. The antagonist is the hero of their own story** and needs real interactions with the player all the way
through, not just at the end (pp. 240-241).
*Why here:* Sephek, Avarice/Var, Auril and the hag.
*Rule:* every antagonist gets at least one scene per act in which they make a case the player could half-agree
with. *scene_shimmer_taken* does this when Sephek offers salvation and then weeps.

**B7. Love all the characters, and profile them before writing a line** (pp. 201, 212). The *Overlord* bio
template (keywords, background, role in the game, voice, example lines, postmortem; pp. 212-216) suits our Voices
doc. Note the postmortem warning: players misread Rose as "the good sister" because the evidence came too late (p. 214).
*Rule:* if a character's key trait only shows up in optional content, put one hint of it on the main path.

### C. Dialogue (line level)

**C1. Short, punchy, one breath.** Small spreadsheet cells push writers toward short sound bites (p. 15). If you can't
say a line in one breath, it's suspect (p. 225). When in doubt, cut words (p. 226). Players skip soliloquies
(p. 172). Lore isn't story, and more lore isn't better (p. 252).
*Why here:* a box holds about two lines of about 45 characters (~90). Anything longer scrolls into a third line or a second box.
*Rule:* hard cap of 90 characters per string including the `NAME: ` prefix. A beat runs at most 6 boxes before the
player gets an input (a choice, movement or battle).

**C2. Subtext over statement.** Don't write "You make me so angry". Put the anger in "Supplies have arrived" (p. 172).
Most of what good dialogue means sits in the subtext (pp. 252-253). Emotion lives in the gaps between words and
events (p. 78).
*Rule:* no character names their own emotion in a climactic beat. Show it in an action stage direction or in what
they *don't* say ("...She always does this.").

**C3. Read it aloud, then play it in game.** Reading aloud finds fluff and awkward wording (pp. 34-35, 92). A line that
works on the page can fall flat in play (p. 148). Table reads test voice, tone and concision (pp. 142-143).
*Rule:* no scene is done until it has been read aloud *and* played in its real box size, in Journey and at least
one Herald mode.

**C4. Don't make characters recite controls.** Use on-screen text for controls, dialogue for objectives and world
information, and mechanics for anything that can be shown in play (p. 77). Briefings can say the objective
plainly ("Get up the mountain") (p. 77).
*Rule:* UI hints go in `pbMessage("(...)")` system lines, as Ch. 10 does with "(The Heralds menu now keeps...)".
Characters never say button names.

### D. Player agency, choice and branching

**D1. Align the player with the protagonist.** The player's aim should match, run parallel to, or complement the
protagonist's (pp. 66-69). Aim for the least possible "I wouldn't do that" dissonance (p. 239). Decide early whether
the PC is the player's avatar or a defined character, and keep to that agreement. Breaking it feels false (p. 239).
*Why here:* Journey mode is the avatar case and Herald mode is the defined-character case, so the agreement differs by mode.
*Rule:* a Journey player character never gets a scripted opinion they didn't choose. A Herald's thoughts must
sound like that Herald (see the Voices doc), never like a generic player.

**D2. The PC drives the story; quest-givers help.** Mission-givers should reinforce a goal the PC already holds, not
issue orders (p. 240). The helper voice in your ear risks turning even a god into a fetching dog (pp. 263-264).
*Why here:* in Herald mode you *are* a hero. Party chat that bosses you around shrinks the hero you're playing.
*Rule:* companions suggest and react ("East. The vision was east."). They don't command the Herald ("Go to X").
Goals in `state[:goal]` are phrased as the party's intent.

**D3. The more important the choice, the fewer the options.** Build the golden path first and branch from it (p. 34).
Big decisions should be focused and simple. If the player needs information first, put a "gatekeeper" NPC who has it
*before* the decision-maker (p. 34). Branches are written out linearly *and* mapped visually (p. 17).
*Rule:* a story-changing choice gets two or three options, each a short phrase under about 38 characters (speak()
truncates at 40). Every branch has its flag, its follow-up lines and a map entry.

**D4. Respect the participant.** Story verbs must exist in the gameplay. "Press Y to feel inner torment" fails
(p. 59). Narrative fails if it doesn't respect the player's choices (p. 60).
*Rule:* if a choice was offered (Go / Come back; yeti lives or dies), a later scene must acknowledge it, even if
only in one line of party chat.

### E. Quests and side content

**E1. Justify odd quests through character, not plot.** A red key opens a blue door because the installer was
lazy, not because of a security conspiracy (p. 101). Character is the language the whole team shares, and plot
beats are less memorable than characters (p. 101 n.3). A writer can give designers' fun ideas a narrative reason (p. 100).
*Rule:* each side quest's premise fits in one sentence about a person who wants something ("Widow wants someone to
take her husband's Spheal").

**E2. Side content gives feedback on the player's path.** Ambient dialogue colours the world and reflects the player's
choices, and almost every player hears it, even the ones who skip cutscenes (p. 210).
*Rule:* every major choice flag should change at least one ambient NPC or party-chat line somewhere.

**E3. Pay off optional content in the main path, without depending on it.** Seed characters and threads that can
grow later, but keep the main experience complete on its own (p. 119).
*Rule:* conditional callbacks (`if flag?(...)`) add a beat. They never carry information the main path needs.

### F. Exposition and lore delivery

**F1. Kill the backstory.** The player wants to experience the *now*. If the backstory is more interesting than the
present, the story is set in the wrong time. Backstory also eats space the golden ingredients need (p. 86).
*Why here:* a D&D campaign arrives with years of table history.
*Rule:* backstory is delivered only when it changes what someone does *in this scene*, and in one or two boxes
(Shimmer's Saltmarsh confession in SC 3.01 is the model).

**F2. Tell, show, do, feel.** Showing beats telling, doing beats showing, and feeling beats doing. For every
non-interactive story point, ask whether it's necessary, whether action, emotion or an image could replace the
exposition, and what it costs (p. 74). Players infer a great deal from setting and design (pp. 74-75). "A
feeling is worth ten thousand" words (p. 79).
*Rule:* cut any narration that describes what a panel or pose already shows.

**F3. Flavour exposition with worldview.** A mission-giver who dislikes the locals turns a briefing into
characterisation (pp. 236-237).
*Rule:* when a character delivers information, the line also shows their attitude to it.

**F4. Narration must not shoehorn in plot.** A narrator is cheap but tempts writers into telling. Put narration
in the world where possible: a DJ, a PA system, chatter, graffiti (pp. 76-77).
*Rule:* narration lines describe what is seen, heard or felt *now*, in present tense, at most two per beat before a
character speaks.

**F5. Introduce what the player needs, in the order they need it.** A good opening teaches purpose, freedoms and
limits (p. 58) and establishes setting, conflict, protagonist, antagonist and goals before story detail (pp. 60-61).
Details that serve none of these are clutter (p. 70). The *newcomer* protagonist is the classic fix: they ask what the
player would ask (pp. 83-84).
*Rule:* no more than one new proper noun per beat. Any name reused later needs a one-line anchor the first time.

### G. Environmental storytelling

**G1. Let players tell the story to themselves.** Environmental details carry the story through self-narration
(empty playgrounds, macabre arrangements) (p. 207). Narrative lives in letters, signs and broadcasts too (p. 202).
*Rule:* every new map gets at least one sign, object or NPC detail that hints at its history without a speaker
explaining it.

**G2. Diegetic justification for found text.** Audio logs raise awkward questions: why was this recorded, and why was
it left here? Tie found text to plausible places and owners (pp. 260-261, 264).
*Rule:* every note or journal item answers who wrote it, for whom, and why it's here. Keep it under four boxes.

**G3. Guide without leashing.** Breadcrumbs inside the fiction (footprints, blood trails) guide without breaking
immersion, but too many make players feel like rats following cheese. Leave room to speculate (p. 262).
*Rule:* direction-giving clues come from the world ("Bare footprints in the snow. They don't sink."), and companions
confirm rather than dictate.

### H. Consistency and continuity

**H1. Keep a bible and treat canon as law.** A series bible keeps canon history and groups consistent (p. 32).
Loremasters are a resource, not a nuisance (p. 186). Professional work follows established conventions, unlike fan
fiction (p. 187). Keep a running list of questions for the canon-holder (p. 188).
*Why here:* the owner is the canon-holder for the Rootspire notes. The memory notes say the game should follow the
campaign notes faithfully, apart from a short list of deliberate changes.
*Rule:* any deviation from the campaign notes is logged in the Story Bible with a reason. Open questions go on a
list for the owner, not into guesses.

**H2. Give fans the expected and the unexpected.** Learn what fans love and stay true to it (p. 193). Give them
"what they expect and what they do not expect" (p. 193). Use fan service only when it makes sense (p. 194). Old
precedent is a gift for throwbacks (p. 192).
*Rule:* each chapter includes at least one recognisable campaign moment, rendered faithfully, and one new turn the table
never saw.

**H3. Tone must not jump.** Tone shifts pull the audience out of the story. The writer guards the tone (p. 174). A
team's game can't swing wildly in style (p. 142).
*Rule:* a joke beat never immediately follows a death or sacrifice beat in the same scene. Put at least a scene
change or a rest point between them.

**H4. Same thing, same words.** Use the same name, format and wording for the same thing every time. "Health" in one
place and "Healing" in another confuses players (p. 42). Check for conflicting boss names (p. 6) and keep spelling
and capitalisation consistent (p. 231). Names shouldn't spoil the ending (p. 156).
*Rule:* one canonical spelling list (Rimefang, Lumen Shard, Heart of Winter, Rootwarden...). Item, quest and map
names are checked for spoilers.

**H5. Don't write what the engine can't stage.** Hidden restrictions, such as a motion set without a cigarette animation,
limit what scenes can show (p. 223). Don't assume best-case resources (pp. 86-87). Rework existing assets instead of
demanding new ones (pp. 222-223, 229).
*Rule:* every stage direction that implies a pose, panel, effect or balloon must exist in the art list or be filed as
an art request before the scene ships.

### I. Working method: bibles, scripts, review

**I1. Character folios.** Include art, a personality sketch, a relationship grid, an emotion-response grid (what they say
when surprised, hurt or excited) to check voices don't match, named possessions and how they treat them, and history
(pp. 29-30). One-page sheets with quirks make even barks easy (p. 92). Casting-spec one-liners capture a minor NPC in a
sentence and a quirk, such as the veteran who talks to his rifle and calls it Lucy (Appendix D, p. 303).
*Rule:* every named NPC gets a one-line spec (age, manner, one quirk) before their lines are written.

**I2. Plot guides per chapter and per cutscene.** Note how the last chapter left off, where this one starts, what must be
achieved, and the major and minor beats. For each cutscene, note the participants' motivations (pp. 30-31). Keep a
one-page outline of the whole game (p. 109) and a visual "murder board", which catches holes and out-of-the-blue twists
(p. 111).
*Rule:* each chapter file's header comment is its plot guide, as the 036 header already is. Add the "left off / starts"
lines.

**I3. Write triggers and notes with the line.** Write the condition, context and intent alongside the dialogue, not
afterwards (p. 16). Give random lines a "not too often" rule (p. 16, Fig. 2.1). Note pronunciation for invented
words (p. 35).
*Rule:* lambdas and `{ if: }` variants carry a short comment on why the variant exists.

**I4. Feedback is about the work.** Describe the problem, not your rewrite ("I don't feel her sorrow"). Point out what
works. Critique the script, not the writer (pp. 145-146). When you raise a problem, bring a possible solution
(p. 113). Without a story editor, trusted readers have to catch plot holes and clichés (p. 124).
*Rule:* review notes name the checklist item and the line, and give one possible fix.

**I5. Test in place.** Many embarrassing mistakes ship because nobody checked a misspelling or a swapped line
(p. 33). Check text for cut-offs, missing font glyphs and wrong indices (p. 42). Watch a newcomer play,
because developers forget what they know (pp. 38, 40).
*Rule:* each scene is run headless (tools/headless) and played once by someone who hasn't read the script.

**I6. Narrative pillars.** Set and publish narrative pillars so every department can test content against them
(pp. 143-144).
*Suggested pillars for Frost & Thaw:* "Warmth against the cold" (found family resisting Auril), "The wheel turns"
(loops, return, renewal), "Finish the table's story" (recognisable campaign beats, resolved).

---

## 3. Scene checklist (run this over any scene)

**Structure**
1. Can the scene's purpose be said in one sentence (what changes: a goal, a relationship or the player's knowledge)? (p. 80)
2. Does it open at the moment of change rather than with a recap? (pp. 80-82)
3. Does it end with a push or pull and an updated `state[:goal]`? (p. 80)
4. Is every beat necessary? Could any be cut without loss? (pp. 80, 226)
5. If it's in a hub or any-order chapter, does it avoid assuming other optional nodes are done (or check flags)? (pp. 31, 209)

**Character and voice**
6. Do you know, for each speaker, what they want in this scene and why? Is each line said *for* something? (pp. 69, 176)
7. Blind test: with names hidden, could a cast-literate reader tell who's talking? (pp. 212, 233)
8. Is each signature tic used at most once per beat? (Appendix C; p. 233)
9. Is it consistent with the Voices doc, the definitive lines and the relationship matrix as of this chapter? (pp. 175, 231-232)
10. Does the antagonist (if present) make a case, rather than just twirl a moustache? (pp. 240-241)

**Lines**
11. Is every string ≤ 90 characters including `NAME: `? (pp. 15, 162, 225)
12. Do no more than about 6 boxes pass without player input? (p. 172)
13. Do climactic beats run on subtext and action, with no one naming their own feeling? (pp. 172, 252-253)
14. Does no character state controls? Are UI hints in system lines? (p. 77)
15. Has it been read aloud and played in its real box? (pp. 34, 92, 148)

**Agency**
16. In Journey mode, does the player character avoid opinions they didn't choose? (p. 239)
17. In every Herald mode, do the Herald's own lines read as that Herald, in the right person, and is any line others react to delivered with speak() rather than as a thought? (pp. 231, 239)
18. Do companions suggest and react rather than order the PC about? (pp. 240, 263-264)
19. Are choices few, short (under about 38 characters) and acknowledged later? (pp. 34, 60)
20. Is the story verb something the player actually does? (pp. 59, 203)

**Exposition and world**
21. Is backstory used only where it changes action in this scene, in one or two boxes? (p. 86)
22. Is there at most one new proper noun per beat, each anchored on first use? (pp. 70, 252)
23. Does narration describe only the present moment, without repeating what the panel shows? (pp. 74-77)
24. Does exposition carry the speaker's attitude? (pp. 236-237)
25. Does found text (signs, notes, journals) have an author, an audience and a reason to be here? (pp. 260-261)
26. Is there at least one environmental or ambient detail that reflects a past choice or history? (pp. 207, 210)

**Consistency and staging**
27. Do names and terms match the canonical spelling list, and do titles or names avoid spoilers? (pp. 6, 42, 156)
28. Do deviations from the campaign notes appear in the Story Bible? (pp. 32, 186-188)
29. Is there no tonal whiplash (a joke right after grief)? (p. 174)
30. Does every pose, panel, effect and balloon the text implies exist, or has it been requested? (p. 223)
31. Do conditional callbacks add flavour without carrying required information? (p. 119)
32. Has it been run headless and played once by someone who hadn't read it? (pp. 33, 40)

---

## 4. What this means for Frost & Thaw

1. **The 90-character box is the spreadsheet cell.** The book's push for brevity (pp. 15, 225-226, 252) is a hard
   limit here. In the three scenes sampled below, SC 3.03/3.04 has **0** strings over 90 characters, SC 6.08 (Glimmer)
   has **14** real ones (up to ~136), and SC 10.01 (Tribunal) has about **8** (up to ~125, not counting goal strings).
   *Failure mode:* the later acts are drifting toward prose-fiction paragraphs. Split on the full stop. Each box should be
   one image or one idea.

2. **Herald stage directions keep third-person pronouns.** `as()` turns "(under his breath) ..." into the narration
   "Under his breath." when you *are* that Herald. A grep finds about 60 Herald-capable `as/cl` lines with pronoun stage
   directions. Some pronouns refer to others, which is fine, but ones like Reptin's "(under his breath)" (about 11×) and
   Alberica's "(wiping her eyes)" become third-person narration about the player character. This breaks the
   player/PC agreement (p. 239) and voice consistency (p. 231). *Rule:* write Herald-capable stage directions without
   pronouns ("(under the breath)", "(wiping wet eyes)"), or have `as()` swap to "your".

3. **Spoken lines become thoughts.** In Herald mode `as()`/`cl()` renders the Herald's line as "(thought)". When an
   NPC then *answers* it (Alberica's "(...Shade?)" followed by "GLIMMER: Glimmer, now."), the player can't tell whether they
   spoke. *Rule:* use `speak()` for any Herald line someone reacts to, and keep `as()`/`cl()` for true asides. Also
   check for echoes: in Alerion's Herald mode, SC 6.08 shows "(Go.)" and then immediately offers the choice "Go." /
   "Come back."

4. **Journey mode is the book's newcomer device. Use it.** The newcomer asks the questions the player would ask,
   and the player learns as they do (pp. 83-84). Give the Journey player choice-lines that *ask*, and let companions
   answer in their own voices (F3). *Continuity flag:* the brief describes the Journey traveller as "from our
   world", but 030_Prologue.rb frames them as from Rootspire 400 years in the future, falling through Reversal glass.
   The Story Bible should state which is canon (p. 32).

5. **Herald mode is the expert-character problem.** The player controls someone who knows Saltmarsh, Brightmane
   and the Brotherhood, but the player doesn't (p. 84). The book's fixes include a moment of change that makes the expert
   a newcomer (Lonelywood, Rootspire), stripped powers, or the expert teaching someone else (p. 85). *Rule:* Herald
   thoughts are the place to put what the Herald knows, one fact at a time and coloured by feeling, rather than a
   companion explaining it *to* the Herald.

6. **Party chat is the walkie-talkie voice plus ambient dialogue.** It's the most-heard writing in the game
   (p. 210). That makes it the best place for worldview-flavoured exposition (pp. 236-237) and for reflecting choices
   (`{ if: { flag: } }` variants). *Failure modes:* voice blur across seven or more companions (p. 212), tic fatigue
   (across the scripts, "darling" appears about 59×, "sweetheart" about 45× and "sugar" about 13×), and companions giving
   orders (pp. 263-264).

7. **The D&D campaign behaves like a licence, and the table are the fans.** Follow the canon-holder's notes (ch. 14).
   Make the hag, the Cackling Chasm and the Ten-Towns recognisable, then give one unexpected turn per chapter (p. 193).
   *Failure mode:* campaign backstory crowding the present (p. 86). Players who weren't at the table only have
   what's on screen.

8. **Optional content pays off, and must stay optional.** SC 6.08's callbacks (the Chasm journal, Luna's
   "spark", the Moon Temple dream) are exactly the "story web" and ambient feedback the book praises (pp. 209-210).
   *Rule:* the unconditional lines must make sense to a player who skipped everything (p. 119).

9. **Story panels are the *Call of Juarez* dime-novel illustrations.** Illustrated cutscenes with narration over them
   (Appendix A, p. 271) are a proven format. Cutscenes are justified when the game can't stage the action or the
   player *must* know something (pp. 75-76). *Rule:* a panel replaces description, so the text over a panel adds sound,
   speech or inner reaction, never "You see a stone circle" when the 512×384 image already shows it.

10. **Signs, notes and story items are our audio logs.** They let the story happen without stopping play, and players
    feel like active interpreters (pp. 260-261). They still need a reason to exist (G2), and they're good real estate
    for patching a plot hole late (p. 261).

11. **Hub weeks need nodal plot guides.** Ch. 10's trial week (any order, seven days, civic layer) is the
    book's open-world node structure (p. 31). Each node needs its stages (before trial, mid-week, verdict) and must
    survive being played first or last (p. 209).

12. **Battles are story verbs.** Ludonarrative harmony (pp. 4-5) and "gameplay losses mirrored in story losses"
    (p. 203) mean win/lose variants should both be written, as Hellen's "whichever way it went" already does, and a battle's
    stakes should be stated in the fiction before it starts.

13. **Repeat lines should rotate and stay short.** First-meeting lines can characterise. Repeat lines should cycle
    and not repeat too often (p. 16). Iriskree's rotating memories of dead acquaintances (015) are a model: each repeat
    adds to her character instead of repeating it.

14. **Exposition-heavy NPC officials need worldview.** Councillors, Speakers and criers deliver rules and stakes.
    Without an attitude (pp. 236-237) they become a readout, like Kelyn's charge list in SC 10.01.

15. **A solo, indie-scale project has no story editor** (p. 124). The owner playtesting chapter by chapter *is* the
    user test (p. 113). Make reviews structured: the checklist above, a blind voice test, and one "fresh eyes" playthrough
    per chapter.

---

## 5. Scene critiques

### 5.1 SC 3.03/3.04, `scene_shimmer_taken` (015_Chapter3.rb, Act I)

**What works**
- *Brevity (11, 12):* every string is under 90 characters. Narration is short and in the present tense ("Morning. Shimmer's
  bedroll is empty."). This is the best model in the sample.
- *Cutting (A6):* sleep is handled in three boxes and a "...". The vision is framed honestly ("none of you can
  move"), which justifies a non-interactive cutscene (pp. 75-76).
- *Subtext (13):* Shade's "(very quiet) ...She always does this." carries years of history in four words (p. 172).
- *Earned loss (p. 240):* the player has spent three chapters with Shimmer (party chat, the SC 3.01 confession),
  so the sacrifice lands. The carved cat on the pillow does the emotional work an explanation would otherwise do (p. 79).
- *Antagonist (10):* Sephek offers salvation and weeps afterwards. He's the hero of his own story (p. 241).
- *Push/pull (3):* the scene closes on a goal and "a tall figure with long ears and a lantern waits in the snow".
- *Herald-awareness (17):* the pendant lines switch on `herald?(:alberica)`, and Alerion's line uses `speak()` with a quiet
  variant.

**Issues**
- *17 (Herald thought vs speech):* `cl(:alberica, "Shade. Look at me. We go together. Nobody goes alone.")` is said
  *to* Shade, but in Alberica's Herald mode it becomes an unspoken thought. Use `speak(:alberica, ..., quiet)`.
- *13:* "SHIMMER: This isn't salvation. It's surrender." and the closing "Not all fire dies. Some of it just learns to
  freeze." lean aphoristic. One epigram per scene is plenty, so consider cutting the first.
- *22:* "Heart of Winter" is introduced and explained in the same box ("It beats to someone else's pulse"), which is good.
  "The stone" was anchored in SC 3.01 ("A door she left open"), so its cracking pays off. "The third way" is new
  here, so make sure Shimmer's two-paths line comes first (it does).
- *23:* "Shimmer lies on a slab..." describes what panel S-04 and the posed actor already show. Keep the cords of living ice
  (detail the art may not carry) and drop the rest.

### 5.2 SC 6.08, `glimmer_arrives` (029_Glimmer.rb, Act II)

**What works**
- *Callbacks as feedback (26, 31):* the horn given to an egg, the four hummed notes (sung off-key "the way Shade always
  did"), the carved cat, and the optional Chasm journal all pay off the player's path (p. 210). Humming off-key is pure
  show-don't-tell identity proof (p. 74).
- *Choice (19):* "Go." / "Come back." is short and is recorded as a flag.
- *Good conditional craft:* `with_or_is?(:meat_meat) ? "GLIMMER: Please don't." : nil` avoids a reply to a line that
  never appeared.

**Issues**
- *11 (length):* 14 strings exceed 90 characters. The worst are the shadow line (about 134), the journal line ("(hoarse)
  That's my hand...", about 136) and the Rift inscription (about 108, in capitals). Split them. The inscription could be its own
  box or panel caption in two halves.
- *12 (box count):* the opening runs five narration boxes before anyone speaks, and the transformation block runs about 17
  boxes without input. Cut the mirror description (the O-01 overlay shows it) and break the middle with the choice.
- *17:* in Alerion's Herald mode, `cl(:alerion, "Go.")` thinks "(Go.)" right before the player is offered "Go." as a
  choice. Make Alerion's line conditional on `!herald?(:alerion)`. In Alberica's Herald mode, "(...Shade?)" gets
  answered as though spoken, so use `speak()`. "(not quite managing her voice)" becomes third-person self-narration (see
  §4.2).
- *22 (proper-noun density):* Brightmane, Lumen Shard, Saltmarsh, Wennen/Luna, Moon Temple, Rimefang, Auril and
  Frostina all appear in one scene. Most were seeded earlier, but "Lumen Shard" and the inscription's "Spark" lore arrive
  together. Let the image carry it and keep one line of lore.
- *21 (backstory):* Glimmer's last block explains Brightmane's metaphor ("that's what torches are like") and then the
  Rimefang's whole curse. It works best as two beats, the torch now and the dagger at the next rest point, so the scene
  can end on the image of the hum.
- *Note (not a defect):* Shade is "they", Glimmer is "he". It's intentional, so record it in the Story Bible and the
  Voices doc (H1, H4) so later writers don't "fix" it.

### 5.3 SC 10.01, `scene_tribunal` (036_Chapter10.rb, Act II)

**What works**
- *Show the split, don't tell it (26):* the child shouting "Murderers!" and the refugee mother hushing her ("They
  brought us out of the snow") stage the city's divided opinion in two lines (p. 74).
- *Comic relief that characterises (7):* Alberica's "(under her breath) I sneezed." and Reptin's
  "Especially not you." are distinct voices, and they come at a point of tension, not grief (29).
- *Clear stakes and a deadline (3):* seven days, possible sentences, an appeal route, and two chairs to fill. That's strong
  push (p. 80). The UI hint goes in a system line (14).
- *Hub structure:* the header comment works as a nodal plot guide (I2, p. 31).

**Issues**
- *11 (length):* about 8 strings exceed 90 characters. The plaza description is about 124. The sentencing line ("Our justice:
  service in the sap-channels...") is about 125. Split or trim them.
- *24 and 21 (exposition without worldview):* Kelyn and Selrae read out the four charges and the justice code like
  a docket. This is exactly where the book says to give the briefer an attitude (pp. 236-237). Is Kelyn sympathetic,
  and is Selrae eager (she's angling for martial law in 10.07)? Let each charge be read in the voice of someone who
  wants something from it. Several charges could also move into the criers' scene or the Heralds menu.
- *22:* "You slew Summer, who was Avarice, who wore our Marshal thirty years" stacks three identities in one clause. A
  player returning after a break may lose track. Give the anchor first ("You killed our Summer Marshal. You say it was
  Avarice, wearing the Marshal like a coat."), then the charge.
- *17 (Herald person):* `as(:alberica, "(under her breath) I sneezed.")` becomes "Under her breath. (I sneezed.)" in
  Alberica's Herald mode, and Reptin's "(under his breath)" lines do the same. See §4.2.
- *16 (Journey):* Kelyn addresses "The Heralds", and the Journey traveller's legal status isn't stated (accused, witness
  or bystander?). One line acknowledging the newcomer would keep the Journey player inside the scene (p. 239).
- *3:* the closing `state[:goal]` lists eight destinations in about 245 characters. Shown in the menu that may be
  fine, but if it's ever echoed in a box, it fails item 11. Consider a short goal plus the Heralds-menu list.
