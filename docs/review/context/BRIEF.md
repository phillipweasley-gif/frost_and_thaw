# Brief: the context pass (one part per writer)

The owner read the as-played script and says it still feels disjointed: "there's still parts missing or a presumed
understanding of events... We need to approach this as though the person playing, Herald or not, is given
everything for context." Your job is to find every place where the game assumes the player knows something it
never showed them, or skips an event and only talks about it afterwards, and to write the fix as something
that plays.

Assume the player has never played a Pokémon game, never heard of Dungeons & Dragons or *Rime of the
Frostmaiden*, and has not read the story bible. Everything they know comes from what plays on screen, in order.

## Read first

1. The skill: `/root/.claude/skills/synced/1556c241-e28f-415b-8fca-680e29cc978c_064a5ade-1ff6-42b2-b2f3-0520d38a8860/game-narrative-writing/SKILL.md`,
   and in `references/`: `seger-making-a-good-script-great.md` (exposition: show it, scatter it, put it in
   conflict, give it to an interesting character; setups), `berger-dramatic-storytelling-narrative-design.md`
   (delivery methods; critical beats on the spine; repeat key facts through different methods),
   `despain-professional-techniques-game-writing.md` (openings: cut the backstory, teach in the order tell, show,
   do, feel), and §1 of `martell-dialogue-secrets.md` (the five kinds of bad exposition). Cite like "(Seger, p. 136)".
2. What plays, in order: `docs/review/script/NN.md` for your parts (the as-played script, with staging), and
   `docs/review/context/journey_log.txt` (the whole New Journey run as one ordered log; grep it to find what the
   player has seen *before* a given point). `docs/review/context/terms_journey.md` lists every capitalised name or
   term with the first line of the log where it appears: use it to check "was this ever introduced?", but judge
   for yourself whether that first mention actually *explains* the thing.
3. Herald Mode, Act I: `/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/trace_herald_alberica.txt`
   and `trace_herald_meat_meat.txt` (same log format; may still be running when you start; check again later).
   In Herald Mode the player *is* a Herald: the game must tell them who they are, who the others are to them, and
   why they're on the ship, without assuming they read the bible.
4. What it is meant to be: `docs/story/story_bible.md` ("The story in one page", "World bible", "Characters", your
   chapters), `docs/story/voices.md`, `docs/WRITING_GUIDE.md` §2 (box rules), §3a (story standard), §9a (staging).
5. What's already been found, so you build on it rather than repeat it: `docs/review/notes/NN.md` §2 (the first-time
   player's questions), `docs/review/story/NN.md` (the story review), `docs/review/dialogue/NN.md` (dialogue).
6. The code, for where each fix goes: `game/Data/Scripts/998_FrostThaw/*.rb` (scenes are `scene_*` methods; `say`
   shows boxes; `Stage.*` is the staging toolkit, see the header of `043_Stage.rb`). Maps: `tools/build_*.rb`.

The owner has decided (2026-11-05, already built): the player has their own goal (the lantern glass from the hag's
mirrors leads to Dougan's Hole; at the last mirror they choose; then a second goal, to bring the Wall down); "Summer
is Avarice" stays Chapter 8's twist; the White Vault is postgame; the Ten-Towns quests have rewards. Keep to these.

### Added for Acts II and III (the skill's five newer books)

The skill's SKILL.md now distils five more books (Bell, the *Game Narrative Toolbox*, Nicklin, the Conflict and
Trope thesauri). Read its "Five newer sources" section, and `docs/WRITING_GUIDE.md` §3b, which turns them into
rules for this pass. Apply these on top of the method below:

- **Three questions per beat** (Toolbox p. 9): your §2 table gets a column "Can the player say what happened /
  what next / why it matters?".
- **The skip test** (Toolbox p. 229): mark every fact in your §2 that the player only gets from optional content
  (party chat, the Heralds menu, side NPCs, signs, Ten-Towns favours). Those are High if the plot needs them.
- **The adhesive** (Bell pp. 87–89): say, for your act, why the player stays and why the Heralds stay, and where
  the game says so. Missing is High.
- **Secrets** (Trope Thesaurus pp. 47–48; Bell pp. 106–113): for Summer/Avarice, Alberica's bargain and the White
  Vault, and Selrae, add a §8 "who knows what, when" table for your chapters: each clue, where it plays, who sees
  it, and whether it's on the spine.
- **The outsider** (Toolbox p. 101): prefer fixes where someone explains something *to the player* because they
  fell in from outside and need telling.
- **Ten-Towns favours** (Toolbox pp. 130–132, 180–185): for the side-quest part, check each favour against the
  quest-giving structure (hook in the middle of the problem, a real stance, a skip, "not now" doesn't lock it,
  four or five steps, ties to the main stakes) and that its reward is said up front.

## What to write: `docs/review/context/NN.md` (one file per part you own)

1. **What the player knows coming in** (both modes): a short bulleted list, from the log, not the bible.
2. **Scene by scene**: a table `| Scene | What the player needs to know here | Shown before? (where, or "never") |
   Gap | Fix |`. Cover every scene. "Needs to know" means: who these people are and what they want, where we are and
   how we got here, what a word means, why something is happening, what the stakes are. Mark the scenes where the
   gap would confuse a newcomer as **High**.
3. **Missing scenes**: every event the story refers to but never shows: things that happen between scenes, off
   the map, in someone's past that the plot depends on, or "told, not shown" at a turn. For each, say whether it
   should be (a) shown as a new scene, (b) shown as a short beat inside an existing scene, or (c) left told but
   told better. For (a) and (b), **write it**: a beat sheet with every box (each about 90 characters or less,
   including `NAME: `, in the character's voice per voices.md, no more than 25 boxes in a row without an input),
   who is on screen and where, what moves, the camera, the music, any player choice, and where it goes in the
   code (file, function, trigger). Mark invented material *(suggestion)*, but keep to the bible's canon.
4. **Words, names and rules used before they're explained**: from the ledger and your read. For each, where it
   should first be explained, and the line or beat that does it (in conflict, by showing, or by someone who has a
   reason to say it, never a lecture).
5. **Bridges**: between each pair of scenes, can the player tell how they got from one to the next, how much time
   passed, and who decided to go? Where not, the fix (a travel beat, a goal line, a one-box bridge, a fade card).
6. **Herald Mode**: what a Herald player is never told (their own past, their relic, their relationships, what the
   others know about them), and the fixes, for each Herald where your part differs.
7. **Priority list**: the ten fixes that would most help a newcomer follow this part, in order.

Quality bar: a fix that dumps exposition is not a fix (Martell's five kinds, Seger on exposition). Prefer showing,
a line in conflict, or an object. Respect the box rules. Don't remove existing good lines; add to or replace them.
Aim for 15,000–30,000 characters per part.

## Rules

- Read-only on the game, the maps and the design docs. Your only output is your file(s) in `docs/review/context/`.
- Save early: write each section to the file as you finish it, so a restart doesn't lose the work.
- Finish with a short report (under 250 words): files written, the number of gaps by severity, the missing scenes
  you wrote, and your top 5.
