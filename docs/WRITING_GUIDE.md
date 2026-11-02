# Frost & Thaw — Writing Guide

The standard every line, scene, quest and art request in the game is written and reviewed against. It combines the
owner's Voices tab and Story Bible with three craft books the owner supplied:

- *Game Writing: Narrative Skills for Videogames* (ed. Bateman): detail in docs/craft/game_writing_guide.md
- *Professional Techniques for Video Game Writing* (ed. Despain): detail in docs/craft/pro_techniques_guide.md
- *Comics Creator Prep* (Nordling): detail in docs/craft/comics_guide.md

Page references below are to those books. Where this guide and the Voices tab disagree, the Voices tab wins on how a
character sounds; this guide wins on mechanics (length, Herald mode, flags, staging).

## 1. Canon to write from

- **Sources of truth, in order:** the owner's decisions (docs/BUILD_OUT.md, docs/FIX_ROUND.md, docs/LAST_ROUND.md),
  the Story Bible (docs/story/story_bible.md), the Voices tab (docs/story/voices.md), the campaign notes
  (sources/drive), then the published books (sources/rotf.txt, sources/cc.txt). Every departure from the notes is
  written into the Story Bible (Despain pp. 32, 186-188).
- **You, in Journey mode:** a Rootspire kid who errands for Professor Wynsnow's College and grew up on Herald stories.
  You fall back 400 years through a Reversal-glass lantern. Silent; your choices are your voice. Never give the
  Journey player an opinion they didn't choose (Despain p. 239). Arc: fan to peer.
- **Herald mode:** you ARE Alberica, Reptin, Alerion, Meat Meat or Wyn (the only playable Heralds). You start on the
  ship north holding your relic. Shade, Shimmer and Glimmer are companions, never playable.
- **Pronouns and names:** Shade they/them; Glimmer he; Wyn they/them; Tamsin they; Eirwen they/them; Meat Meat
  she/her; everyone else as the Story Bible lists. One spelling per name (keep the canonical list in the Story
  Bible). No two different people share a name.
- **Settled story facts** (Story Bible, plus this build-out): Shimmer's sacrifice; Shade becomes Glimmer at the Rift
  and dies at the Forge; Alerion and Meat Meat are Dragoons; Avarice wore Var and faked her death; Meat Meat's
  mother is Phildendrin; the mother yeti lives or dies by the player's handling.

## 2. House rules for the message box

1. **One box holds about 90 characters, counting `NAME: ` and any stage direction.** Over that, split at a sentence
   boundary or cut. Never split one sentence across two boxes (Bateman p. 146; Despain pp. 15, 162, 225).
2. **One beat per box.** No one speaks more than three boxes in a row; a speech longer than four boxes gets an
   interjection (Voices rule 1; Bateman p. 146).
3. **More than about 25 boxes without player input is too long:** trim, or give the player an action, a choice or a
   battle. More than about 6 boxes of pure narration in a row is a sign the scene needs a panel or staging instead
   (Bateman pp. 49-50; Despain p. 172).
4. **The narrator writes only what the sprites, effects and panels can't show,** one present-tense line at a time
   (Voices rule 2; Nordling: pictures first, words second).
5. **Spine information goes first in its line, in plain words.** The joke comes after the instruction, never instead
   of it (Bateman pp. 51-52, 211).
6. **Punctuation:** a dash is a cut-off, an ellipsis a pause, a box of just "..." is silence or a time gap. Stage
   directions in parentheses at the start of a line, lower case, short.
7. **Read it aloud.** If it can't be said in a breath, it's two lines (Despain pp. 34, 92, 148).

## 3. Scenes

- **Purpose in one sentence:** what changes (a goal, a relationship, what the player knows)? Write it in a comment
  at the top of the scene function. If it can't be said in three sentences, the scene is two scenes (Despain p. 80;
  Bateman ch. 3).
- **Open on the change, not a recap.** End on a push or pull and an updated `state[:goal]` (Despain pp. 80-82).
- **The player does the decisive thing** in every climax: a battle, a choice, an item. A companion lands the blow only
  if the player set it up (Bateman pp. 9, 137).
- **Losses play where the player can't act** (a panel, a vision, locked movement), leave room for a farewell, and are
  followed by updated party chat and NPC lines. Departures are confirmed the same way arrivals are ("X left the
  party." mirrors "X joined the party.") (Bateman pp. 128-139).
- **No joke right after grief,** except one line from a character whose way of coping is joking (Alberica)
  (Bateman p. 153; Despain p. 174).
- **Every story scene gives at least two Heralds a line, and one reacts to another Herald, not to the plot**
  (Voices rule 3). In a major scene, every Herald who can be present gets a beat.
- **Rest points, arrivals and big battles** get a short banter (3-6 boxes) from whoever is in the party (Voices
  rule 4).

## 4. Voice

- Write each character from the Voices tab: core, how they talk, running bits, under pressure, never. With the
  speaker names covered, a reader who knows the cast must still tell who's talking (Despain pp. 212, 233).
- **Signature tics at most once per beat, and rarely.** Alberica's pet names in particular: at most one per scene,
  and not in grief. Meat Meat's third person is constant; her catchphrases are not (Despain App. C).
- **Feelings are shown or implied, not named.** Climaxes run on subtext (Despain pp. 172, 252-253).
- **Every line is said for something** — the speaker wants something from the listener (Despain pp. 69, 176).
- **Villains make a case.** Avarice, Thredra, Sephek and Auril each believe they are right; let them say why
  (Despain pp. 240-241).
- **Write from what the speaker knows now.** Loop-aware and time-travel lines carry a comment saying what the speaker
  remembers and how (Bateman pp. 230-231).

## 5. Herald mode

- **Narration about the Herald you are says "you/your", never "he/she/they".** A stage direction on your own line
  becomes narration in the second person ("You lower your voice."), not "Under his breath." Check every `as()` line
  with a pronoun in its direction.
- **A line another character answers is spoken, not thought.** Use `speak()` (loud and quiet versions, both in
  character), not `as()` producing a "(thought)". Don't follow a thought with the same words as a choice.
- **Heralds never explain their own backstory to themselves;** lore goes to the newcomer, an NPC or another Herald.
- **Never script a Herald into a betrayal, cruelty or loss the player hasn't been led toward** (Bateman pp. 136-137).
- **Scenes must read correctly in Journey mode and as every Herald who can be present.** `cl()` lines drop out when
  that companion is absent; the scene must still make sense without them (`.compact`).

## 6. Choices, flags and continuity

- **Every flag a choice sets is read back at least once later** — in a line, a reaction, a reward or an ending. A
  flag set and never read is a choice thrown away (Bateman pp. 61-65, 77-79).
- **Every line that refers to a past event checks that event's flag.** Never assume the route (Bateman pp. 74, 80).
- **A scene can't fire twice,** unless it's written to be heard twice. A trigger row must make sense from every way
  onto that tile, and must not be walkable round.
- **Irreversible steps are hinted before and confirmed after,** the same way every time.
- **Party chat and NPC repeat lines are updated after each beat.** A character must not talk about someone as present
  after they've gone.
- **Choices are few and short** (under ~38 characters each), and acknowledged afterwards (Despain pp. 34, 60).

## 7. Quests and optional content

- **The spine is plain and certain; side content may be cryptic** (Bateman p. 89). Spine information never lives
  only in an optional NPC, a repeat line, a sign or a book (Bateman pp. 93-94).
- **Every spine fact appears three times:** in a line in the scene, in `state[:goal]` (one short sentence naming the
  next concrete step), and in one source the player can revisit (an NPC's repeat line, party chat, a sign)
  (Bateman p. 212).
- **A quest-giver's reason — why us, why now — is in the same box as the request** (Bateman pp. 91-92).
- **Optional content is optional:** removable without breaking a spine line; never placed right before a boss;
  rewards are minor (Bateman pp. 44, 49, 66, 156). Each side quest's header comment names its thematic echo
  ("debt", "what winter takes").
- **Order-independence:** in a hub (Ten-Towns, the Dale, Rootspire's week), every fact a side quest relies on must
  make sense whichever order the player does things in (Bateman p. 83; Despain pp. 31, 209).
- **Adapting the book:** find the heart of each location first (Nordling) — the one feeling or choice it exists to
  deliver — and build the scene around that, rather than transcribing every room.

## 8. Exposition and the world

- **Backstory only where it changes what someone does now,** in one or two boxes ("kill the backstory", Despain p. 86).
- **At most one new proper noun per beat,** explained the first time it appears (Despain pp. 70, 252).
- **Exposition carries the speaker's attitude** (Despain pp. 236-237).
- **Signs, notes and journals have an author, a reader and a reason to be there** (Despain pp. 260-261).
- **At least one detail per area reflects history or a past choice** (Despain pp. 207, 210; Bateman pp. 77-79).
- **Campaign references land for players who never sat at the table** (Swallow, Bateman ch. 9).

## 9. Panels, staging and art requests

- **A panel is a frozen moment.** Every line under it must be true of that instant; nothing describes what happens
  after it (Nordling).
- **A panel shows the setup or the reveal, never both,** and comes after the box that sets it up. It must not spoil
  the climax it introduces.
- **Don't repeat the panel in words** (keep one establishing line); name things in the order the eye meets them,
  left to right, payoff on the right.
- **All depictions of one place agree** (panel, map, text), and staging doesn't flip left/right between panel and map.
- **Every cut or vision (`Stage.visit`, O-03) establishes where and when.** Signifiers keep one meaning: O-03 means a
  vision or memory; O-01 the aurora; balloons land on the current speaker before their box.
- **The words still work if a panel fails to load.** Showpiece moments get a panel, pose or effect, not a stack of
  narration.
- **Art requests are scripts for the artist:** a frozen moment in state verbs, left to right, with "the player should
  conclude...", the canon text it must match, the lines it plays under, and what must stay legible and clear of the
  message box (bottom quarter of the screen). Never ask for what can't be seen in game.

## 10. Review method

1. Run the checklist below on every new or changed scene.
2. Run it headless (the story driver and a focused test) in Journey mode and as at least one Herald.
3. Before a chapter ships, someone who hasn't read the Story Bible plays its spine scenes and explains back what
   happened and where to go next (Bateman pp. 218-219; Despain pp. 33, 40).
4. Log every departure from the notes in the Story Bible.

## 11. Scene checklist

**Box and line**
1. Every string fits ~90 characters including `NAME: ` and directions.
2. One beat per box; no sentence split across boxes.
3. Spine information first, in plain words.
4. Read aloud: no tongue-twisters or stacked clauses.
5. Voices recognisable with names covered; tics at most once per beat.
6. Feelings implied, not named.

**Scene**
7. Purpose in one sentence, in a comment at the top.
8. Opens on the change; ends on a hook and an updated goal.
9. The player does or earns something; no more than ~25 boxes without input.
10. No speech over four boxes without an interjection.
11. Every recurring element was set up earlier, or is set up here.
12. At most one joke in a grief beat, from the right character.
13. At least two Heralds speak; one reacts to another Herald.

**Modes**
14. Correct in Journey mode and as every Herald who can be present.
15. Herald narration in second person; no third-person stage directions about the player.
16. Lines others answer are `speak()`, not thoughts.
17. Scenes still make sense when `cl()` lines drop out.

**Choice and state**
18. Every flag set here is read somewhere later.
19. Every past event referred to is checked with its flag.
20. The scene can't fire twice; its trigger can't be walked round.
21. Irreversible steps hinted before and confirmed after.
22. Party chat and repeat lines updated after the beat.

**Guidance**
23. `state[:goal]` is one short sentence naming the next step.
24. Each spine fact is in a scene line, the goal, and one revisitable source.
25. A quest-giver's reason is in the same box as the request.
26. Spine steps plain; cryptic hints only for optional content.

**World**
27. Backstory only where it changes what someone does now.
28. At most one new proper noun per beat, explained on first use.
29. Signs and notes have an author, a reader and a reason.
30. Names, pronouns and terms match the Story Bible and Voices tab.
31. Campaign references make sense to a newcomer.

**Panels and staging**
32. Lines under a panel are true of its frozen instant.
33. The panel doesn't spoil what it introduces, and matches the text and the map.
34. No left/right flip between panel and staging; balloons on the right speaker.
35. Cuts and visions establish where and when; signifiers keep one meaning.
36. The scene works if a panel fails to load.
37. Every pose, panel, effect and balloon the text implies exists or is requested.

**Optional content**
38. Removable without breaking the spine; minor rewards only.
39. Makes sense in any order relative to other optional content.
40. Its header comment names its thematic echo.

## 12. Known problems to fix (from the three books' scene reviews)

- Lines over the box limit: about 16 in `glimmer_arrives`, 11 in the tribunal, 3 in `scene_falling` (one 158 chars).
- `as()` turns stage directions into third-person narration about the player in Herald mode (~65 candidates).
- Herald lines others answer that come out as thoughts (e.g. Alberica's "...Shade?" in 029; "Shade. Look at me." in
  015; the Reptin/Meat Meat exchange in 036).
- Alberica's pet names: "darling" ~59, "sweetheart" ~45, "sugar" ~13 across the script.
- Silent Heralds in major scenes (Reptin and Meat Meat at Shimmer's loss; Wyn at the tribunal).
- `:told_shade_go` is set and never read.
- The Ch10 goal line (~245 characters) prints before every conversation that week.
- Shimmer leaves the party with no system message.
- Panels vs text: S-04 (vision) shows an interior and the raised knife under "a stone circle in the birches"; S-08b's
  lead Wennen is brown, not moon-white, and its second box describes events after the frozen moment; S-08d's six
  equal figures contradict the small faceless sixth figure; Sephek's side of the slab flips between panel and map;
  `glimmer_arrives` has ~25 narration boxes of pure visuals and no panel.
- `scene_falling`'s text-only glimpses come after S-08e and jump back in time; Wyn mode has no bookend.
- In `scene_third_way`, the B-05 balloon plays on the white wyrmling just before Razzilith (the green one) speaks.
- The Story Bible still says Avarice "flees into the mirrors"; update it for the faked death and the other
  build-out decisions.
