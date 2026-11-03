# Brief: the as-played script and review (one chapter per writer)

The owner played New Journey mode into Targos and found the game disjointed: pacing, animation, how NPCs
and side quests engage you, and dialogue that doesn't hang together. They asked for **the FULL script, written
out (animations, camera movements, characters, dialogue), then evaluated as an editor, then critiqued as a
player with no experience of this kind of game, and the dialogue checked so it makes sense.** No shortcuts:
every message box, in order, nothing summarised away. You are writing one part of it.

## What you have

- **The as-played log** for your part: `/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/script/parts/NN.txt`
  (a cut of a full headless playthrough of New Journey mode; see "Reading the log"). If a sweep log part
  exists (`.../parts/NN_sweep.txt`) it adds what every person on every map says when you talk to them.
- **The code** that plays it: `game/Data/Scripts/998_FrostThaw/*.rb` (your chapter's files are listed in your
  prompt; grep for anything else). Maps are built by `tools/build_*.rb` (who stands where, what's on each map).
  Text tables are `TEXT.merge!(...)` / `lines_for(:key)`; scenes are `scene_*` methods; `say([...])` shows
  boxes; `Stage.*` calls are the staging (see `043_Stage.rb`'s header for what each does).
- **The design**: `docs/story/story_bible.md` (canon, characters, pronouns), `docs/story/voices.md` (how each
  character speaks), `docs/story/act1_script.md` / `act2_script.md` / `act3_script.md` (the intended script),
  `docs/WRITING_GUIDE.md` (the house rules, especially §2 box rules, §3 scenes, §9 panels and **§9a staging
  like a Pokémon game: every speaker on screen**).

Read the log first. It is the truth about what plays. The design docs are what was intended; where they
differ, the log wins for the script and the difference is a finding.

## Reading the log

One event per line, in order:
- `[map] Name [id] at (x,y)` you arrive on a map. `[scene] key` a cutscene starts (code: `scene_<key>`).
- `[msg] TEXT` one message box (a `NAME: ` prefix is a speaker). `[ask]` a yes/no; `[pick] X (of A | B)` the
  choice the test took and the options. `[offstage] NAME absent|off_camera` the speaker of the next box is not
  on the map / not on screen (a staging bug unless the story means it).
- `[stage] ...` staging: actors appearing, walking, "!"/"?" bubbles, hops, turns, camera pans, PANEL/OVERLAY
  (full-screen art), effects, poses, balloons (B-xx), themes, jingles, cries.
- `[music]`, `[me]` (jingle), `[se]` (sound), `[screen]` (tone = fade, shake, flash).
- `[battle] start vs ...` a battle. `[goal]` the pause menu's Goal changes. `[flag]` a story flag is set.
- `[talk] Name at (x,y) on Map` the test walked up to someone and pressed A (in sweeps, everyone).
- `[ui] ...` a shop/PC opened. `[note]` driver notes.

The test answers choices with a fixed rule (usually the first option); where the code offers other options,
write the other branches out from the code too.

## What to write

### 1. The script (`docs/review/script/NN.md`)

Write it as a game shooting script, scene by scene, in play order. Every message box appears, verbatim, in
order. Nothing is summarised ("they talk about X" is not allowed). Format:

```
## 1.03 · The Three Flags: the Heralds meet            (scene_tavern_convergence)
**Where:** Three Flags Sailing, Targos [2002] · **Trigger:** walking in after the pier · **Music:** Ecruteak City
**On the map:** Alberica (bar, 6,4), Reptin (table, 9,5), Shade, Shimmer, barkeep · **You:** at the door (5,11)

> CAMERA: holds on you at the door; the room is in view.
> ACTION: Alberica turns from the bar ("!" bubble). Shade walks up to you.

**ALBERICA:** Well, look what the snow dragged in.
**SHADE** *(to you)*: There's always room.
*Narration line, in italics.*
> CHOICE: "Who are you?" / "Leave me alone." (the test picked the first) → branch notes
> BATTLE: Shade (Sneasel L12, ...) — music: ...
> GOAL → "Win Speaker Naerth's seal at the Town Hall."
> FLAGS: met_party
```

- `CAMERA:` lines describe where the camera is and when it moves (pans, cuts, fades, panels), as staged by the
  code. If the speaker is off screen, say so: `> CAMERA: (Alberica is off screen for the next 6 boxes)`.
- `ACTION:` lines describe what moves on screen (from `[stage]` and from the code's move routes), what
  appears, effects, bubbles. If nothing moves during a long run of dialogue, say so (that's an animation
  finding).
- Speakers in bold caps. Stage directions in the line as the game shows them.
- Side quests and NPC lines in your part: write them out too, as their own scenes ("Side: The Widow's
  Spheal"), every line, every branch. Townsfolk: a compact table `| Who | Where | Lines (in order) | When it changes |`.
  Content the log didn't reach: write it from the code and mark the heading *(from the code, not played)*.
- Herald mode: where a scene plays differently for a Herald, add one line `> HERALD MODE: ...` saying what
  changes (you don't need to write out every Herald variant).

### 2. The notes (`docs/review/notes/NN.md`)

After the script, as its own file, four sections. Every finding names the scene and quotes the line or
describes the moment, says why it's a problem, and gives the fix (for dialogue, the rewritten line, keeping
the character's voice from voices.md and the box limit of ~90 characters including `NAME: `).

1. **Editor** — structure and pacing (boxes in a row without player input, scenes that open on a recap, a
   scene that doesn't change anything, a goal you can't find, backtracking, long stretches with nothing to
   do), staging and animation (speakers off screen or absent, people who appear or vanish, long talk with
   nothing moving, effects that don't match the words, panels that contradict the map), continuity (names,
   pronouns, who knows what when, things referred to before they're introduced), and side-quest engagement
   (does the NPC pull you in, is the ask clear, the reward, the follow-up, does anyone react after).
   Give each a severity: **High** (confuses or blocks the player, breaks the story), **Medium** (weakens it),
   **Low** (polish).
2. **First-time player** — read the script as someone who has never played a Pokémon game and doesn't know
   D&D or the campaign. What would you not understand? Who is this person, why should I care, where do I go,
   what does this word mean, why did that just happen? Write each as the question the player would ask, then
   the fix.
3. **Dialogue** — lines that don't make sense, don't follow the previous line, answer something nobody said,
   repeat, contradict, sound wrong for the character, are too long for the box, or are thoughts that others
   answer. Table: `| Scene | Line (as is) | Problem | Rewrite | file:line |`.
4. **Top 5** — the five changes that would help this part most, in order.

### 3. Publish to the review doc

Your part has a tab in the owner's review doc. Publish there as you go (the owner may be watching): the
script first, a few scenes per call, then the notes. Use the Claude Docs tools (load
`mcp__Claude_Docs__update` / `mcp__Claude_Docs__read` with ToolSearch if they're deferred; read
`guide(items=["topic.index"])` once). Ids are in `.../script/doc_ids.txt`: replace your tab's pending block
with your first chunk (`"as":"markdown"`), then insert each later chunk after the last block you wrote (the
ack's xml gives block ids) or at the end of the tab (`{"kind":"root"}` + `"side":"end"`). Keep each call under
about 12,000 characters. Docs markdown supports headings, bold/italics, `>` quotes, pipe tables, lists.
Don't touch any other tab.

## Rules

- Do not change the game, the maps or the design docs. This is a read-only review; your outputs are the two
  files and your tab.
- Quote exactly. If you're inferring staging from code rather than the log, say "(code)".
- Be complete before being clever: the full script first, then the critique.
- Finish with a short report: the files written, how many scenes and boxes, how many findings by severity,
  and your top 5.
