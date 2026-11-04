# Brief: the story review (one part per writer)

The owner asked for the full as-played script, an editor's review, a first-time player's critique and a
dialogue check. Those are done (`docs/review/script/NN.md`, `docs/review/notes/NN.md`). They work at the level
of lines, staging and bugs. What is missing is the **story-level** review: does the plot have a spine, do the
characters have arcs the player can see, are setups paid off, does each scene earn its place. The owner has
given us a skill built from eight craft books he owns; this review judges the game against them.

You are reviewing one part. A final pass (not yours) assembles the whole-game spine from all parts, so your
job is to give it accurate, evidenced material for your chapters.

## Read first

1. The skill: `/root/.claude/skills/synced/1556c241-e28f-415b-8fca-680e29cc978c_064a5ade-1ff6-42b2-b2f3-0520d38a8860/game-narrative-writing/SKILL.md`
   and these references in its `references/` folder: `seger-making-a-good-script-great.md` (structure, scenes,
   setups/payoffs, character spine and functions), `mills-dance-of-character-and-plot.md` (the four scene
   questions and the 1–10 rating, scene/sequel), `berger-dramatic-storytelling-narrative-design.md` (the five
   game milestones, delivery methods, meaningful choice). Skim `martell-dialogue-secrets.md` only if you need it.
   Cite books like "(Seger, p. 88)" using the page numbers in those files. For an exact detail, grep
   `sources/text/<book>.txt` and cite the `=== PAGE n ===` marker. Never paste long passages from the books.
2. The design: `docs/story/story_bible.md`: "The story in one page", "World bible / The five rules",
   "Characters", and your chapters' sections under "Chapter by chapter" (and "Quests and side content" if
   you have a side part). This is what the story is meant to be.
3. **The as-played script for your part(s)**: `docs/review/script/NN.md`. This is what the player actually
   gets. It wins over the design. Where they differ, that is a finding.
4. The existing notes for your part(s): `docs/review/notes/NN.md`. Don't repeat their line, staging or bug
   findings; refer to them in one phrase where a story problem rests on one ("the off-stage party, notes §1").

## What to write: `docs/review/story/NN.md` (one file per part you own; NN = the part number)

Evidence everything: name the scene (its number and title from the script) and quote the line, short.

1. **The chapter in one line**: the question this chapter asks and the answer it gives, as the player would
   state them from the script alone. Then: does the game ever *say* the question? (quote it, or "never").
   The bible says each chapter answers a question the last one raised: does it, as played?
2. **Spine** (Seger's nested three acts, pp. 34–62): a table `| Slot | Scene | What happens | Lands? |` for
   opening image, catalyst, Act-1 development, turning point 1, midpoint (if any), turning point 2 (dark
   moment + new stimulus), climax, resolution. Mark empty slots. Say which slots are carried by gameplay
   (a battle, a puzzle) and which by text. If a game-wide milestone (Berger: inciting incident, point of no
   return, midpoint/low point, ticking clock, climax) falls in your part, name it and say if it lands.
3. **Scene ratings** (Mills's four questions): table `| Scene | Whose goal / what they want | What is learned |
   Backstory revealed | Stakes raised? | Emotional shift (Seger p.144) | Score /10 | Keep / rework / cut / merge |`.
   Every scene in your script, including side scenes (townsfolk tables can be one row per town). Be honest:
   under 8 means rework. Score from the as-played version, not the design.
4. **Characters**: for each named character who speaks in your part: what they want here, and is it shown by
   an action in the present or only told (Seger p. 224–231); which arc beat from the bible lands here and
   whether the player can see it; their function (Seger ch. 13) and any overlap with another character; does
   their voice survive the cover-the-names test (one example). Then the **player character**: list every
   decision the player makes in your part (choices, battles they could lose, places they pick) vs the things
   done *to* them. Is the player active or a passenger (Seger p. 232; Berger on meaningful choice)?
5. **Setups and payoffs** (Seger pp. 148–161): table `| Thread | Set up (scene, quote) | Paid off (scene) |
   Status |`. Status: paid / set up here, pays later (say where, from the bible) / orphan (never pays) /
   payoff with no setup / set up only off the golden path. Include every object, name, rule, promise or
   mystery your part introduces or resolves, and every one the bible claims for your chapters.
   Note motifs (three or more appearances).
6. **Theme and tone**: which of the bible's pillars (small warmth vs vast cold; found family across time;
   every mirror lies a little; change over stillness) your scenes actually serve, with an example each, and
   any scene that serves none. Does the tone match "cosy, then cold"?
7. **Game fit** (Berger, Despain/IGDA via the skill): does story come as a reward for play or as a wall
   before it; scene/sequel rhythm (Mills: gameplay = goal/conflict/disaster, cutscene = reaction/dilemma/
   decision); does the story's conflict match the gameplay challenge; are the choices meaningful.
8. **Verdict**: what's working (2–4 points), then the **top 3 story problems**, each with why it hurts, the
   fix, and a book cite. Then a **rewrite sketch** for your weakest important scene: a beat outline (5–10
   beats, with who is on screen, what the player does, what changes), not full dialogue. Keep the owner's
   world, names and voices (`docs/story/voices.md`); mark any new invention as a suggestion.

Aim for 12,000–25,000 characters per part. Plain, direct English; tables where the content is a list.

## Rules

- Read-only on the game, the maps and the design docs. Your only output is your file(s) in `docs/review/story/`.
- Don't publish to the review doc; the final pass does that.
- Save early: write section 1–2 to the file as soon as you have them, then add sections as you go, so a
  container restart doesn't lose the work.
- Finish with a short report (under 300 words): files written, the chapter's question, the average scene
  score, the three problems, and any milestone that falls in your part.
