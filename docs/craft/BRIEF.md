# Writing-craft distillation brief

The owner supplied three craft books so the game's narrative is clear and cohesive. Your job: read ONE book in
full and distill it into an actionable guide for THIS game. Do not reproduce long passages (short quotes of a
sentence or less are fine, with page numbers); write the principles in your own words.

The game: "Pokémon Frost & Thaw", a Pokémon Infinite Fusion mod adapted from the owner's D&D campaign. Text is
shown in short message boxes (about two lines of ~45 characters each), one speaker per line ("NAME: text"), with
narration lines between. Six playable modes: the Journey (a newcomer from our world travelling with the party) and
five "Herald" modes where you ARE one party member, whose lines become "(thoughts)" or choices (speak()/as()).
Companions comment through party chat; NPCs have first-meeting and repeat lines; quests are told through scenes,
signs, items and battles. Cutscenes use full-screen story panels (512x384 illustrations), character poses, effects,
emote balloons and screen overlays. There is an existing Voices doc for each character's voice, and a Story Bible.
Script: /home/claude/frost-thaw/game/Data/Scripts/998_FrostThaw/*.rb (dialogue in say/sayc/speak/as/cl arrays).

## Output (markdown, at your output path)
1. A short overview of the book and what's most relevant to this game.
2. The principles, grouped (e.g. story structure and pacing; character and voice; dialogue; player agency, choice
   and branching; quests and side content; exposition and lore delivery; environmental storytelling; consistency
   and continuity; working method: bibles, scripts, review). For each: the principle, why it matters here, and
   a concrete rule a writer on this game can follow, with the book's page reference.
3. A checklist (20-40 items) a writer or reviewer can run over a scene in this game.
4. "What this means for Frost & Thaw": 10-15 specific observations about how the principles apply to this game's
   format (message boxes, Herald mode, party chat, optional content, panels), including likely failure modes to
   watch for.
Then read 2-3 real scenes from the script (pick from different acts, e.g. 015_Chapter3.rb scene_shimmer_taken,
029_Glimmer.rb glimmer_arrives, 036_Chapter10.rb) and give a short critique of each against your checklist.
Your final message: the overview and the checklist.
