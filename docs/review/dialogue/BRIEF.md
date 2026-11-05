# Brief: the dialogue review, redone against the craft books (one part per writer)

The owner asked for the game's dialogue to be evaluated "so it makes sense", because what plays "feels disjointed
and doesn't quite make sense". A first dialogue review exists (`docs/review/dialogue_review.md` and section 3 of
each `docs/review/notes/NN.md`). It was written before the owner gave us his game-narrative skill, and it mostly
checks mechanics: box length, wrong speaker, pronouns, continuity. The owner has asked for it to be **redone with
the skill**. That means judging the lines as dialogue, against William C. Martell's *Dialogue Secrets* (and Seger's
dialogue chapter): do the voices differ, is it a fight where each line bounces, is it on the nose, is exposition
hidden in conflict, do lines follow what was said, does it play aloud.

You are reviewing one part. A final pass (not yours) builds the game-wide review and the voice sheets from all
parts, so give it accurate, evidenced material.

## Read first

1. The skill: `/root/.claude/skills/synced/1556c241-e28f-415b-8fca-680e29cc978c_064a5ade-1ff6-42b2-b2f3-0520d38a8860/game-narrative-writing/SKILL.md`,
   then `references/martell-dialogue-secrets.md` in full (the polish checklist in its §2 is your method), and the
   dialogue parts of `references/seger-making-a-good-script-great.md` (§1 "Images & dialogue", checklist L).
   Cite like "(Martell, p. 15)". For an exact detail, grep `sources/text/` and cite the `=== PAGE n ===` marker.
   Never paste long passages from the books.
2. The owner's voices: `docs/story/voices.md` (the voice sheets, pairs, house rules, the two samples). This is the
   yardstick for every character. Also `docs/story/story_bible.md` "Characters" (wants, pronouns) and
   `docs/WRITING_GUIDE.md` §2 (box rules: about 90 characters per box including `NAME: `, one beat per box,
   no more than three boxes in a row from one speaker) and §4 (voice).
3. **The as-played script for your part(s)**: `docs/review/script/NN.md`. This is what the player reads.
4. The existing dialogue findings for your part: section 3 ("Dialogue") of `docs/review/notes/NN.md`, and
   `docs/review/dialogue_review.md`. Don't repeat their mechanical findings (box length, wrong bubble, pronouns)
   unless the fix they propose is itself bad dialogue. Do audit their **rewrites**: some are on the nose, out of
   voice, or flatten a good line.
5. The code, to give each line's `file:line`: `game/Data/Scripts/998_FrostThaw/*.rb` (grep for the quoted text).

## What to write: `docs/review/dialogue/NN.md` (one file per part you own)

Quote exactly, short. Every finding names the scene number and title from the script.

1. **In one paragraph**: how the dialogue in this part reads, as dialogue. What works, what goes wrong most.
2. **Voices** (Martell pp. 29–36, 73; voices.md). For each character who speaks more than a few boxes in your part:
   - **Cover-the-names test**: take three or four of their lines from your part with the name removed. Could a
     reader who knows the cast tell who it is? Say yes or no, with the lines.
   - Where they sound right (one line), where they drift from voices.md (quote, and say which lever is off:
     attitude, background, sentence shape, pet word, vocabulary, humour style), and whether two characters
     share a tic, a pet word or a joke style.
   - Their versions of yes / no / hello / goodbye if your part shows them (they feed the voice sheets).
   - A table is fine: `| Character | Cover-the-names | Sounds right | Drifts | Shared with |`.
3. **Scene by scene** (Martell's scene-level checks, §2 items 1–5): for each scene with real dialogue, one line
   each on: who wants what (is it a fight, or people agreeing?); exposition (which of the five kinds, p. 11–14);
   a Prompter (p. 15); a recap or "talking about it instead of doing it"; speeches over three lines (p. 69); and
   whether anything live is in the room (p. 21, 144). Use a table:
   `| Scene | Wants / conflict | Exposition | Prompter / recap / speech | Pressure | Verdict |`.
   Also mark **lines that don't follow**: a line that answers something nobody said, ignores the line before,
   knows what the speaker can't know (Martell's no psychic characters, p. 18), or changes the subject with no
   reason. These are the owner's "doesn't make sense" complaint; find all of them in your part.
4. **Line notes**: a table `| Scene | Line (as is) | Problem (Martell's term, page) | Rewrite | file:line |`.
   Problems to look for: on the nose (p. 15); see & say (p. 27, 37); "let me tell you what I'm feeling" (p. 11);
   "as you know" (p. 12); flat lines with no bounce (p. 17); cliché (p. 40); generic where a detail would do
   (p. 41); stinger buried mid-line (p. 67); throat-clearing first words (p. 55); wrylies propping up a line
   (p. 74); lines that don't play aloud (p. 78). Rewrites: in the character's voice per voices.md, at most about
   90 characters including `NAME: `, one beat. Mark new invented content as *(suggestion)*. Aim for the 20–40
   lines that would most improve the part, not every line.
5. **The old rewrites**: the rows of the existing dialogue table for your part (notes §3) whose proposed rewrite
   is itself a problem under Martell, with a better one. Say "all hold up" if they do.
6. **Lines to protect**: the best lines in your part (quotable lines, echo lines that change meaning, good banter,
   good subtext), so a rewrite doesn't flatten them (Martell pp. 48–51, 104–119).
7. **Top 5**: the five dialogue changes that would help this part most, in order, each with a cite.

Aim for 10,000–20,000 characters per part. Plain, direct English.

## Rules

- Read-only on the game, the maps and the design docs. Your only output is your file(s) in `docs/review/dialogue/`.
- Don't publish to the review doc; the final pass does that.
- Save early: write each section to the file as you finish it, so a container restart doesn't lose the work.
- Finish with a short report (under 250 words): files written, how many line notes, the cover-the-names results
  in one line per character, and your top 5.
