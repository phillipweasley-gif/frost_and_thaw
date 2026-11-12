# 0.8.9 (2026-11-11): the editor's pass before launch

The owner asked for this after a critic's read of the story and dialogue: "Do all of these as an editor
doing a final game pass before launch."

The owner's calls:
- **Ten-Towns keeps its canon.** The game is for players who played the campaign and are Pokémon fans, so the
  originality item was dropped.
- **Auril is the spine.**
- **The New Journey player's stake is Tamsin and home.**

## 1. The spine: Auril

> Auril wants the world to stop changing. Everyone who hurts you either serves her stillness, steals from it,
> or is what it makes of people.

Each antagonist now says plainly how they relate to her.

| Antagonist | Relation to Auril | Where it's said |
|---|---|---|
| Sephek, Eline, the Halo, Thredra | Serve her | Already said in the story |
| Avarice | Steals from her | At the Vault: "You always thought I was the storm. I only ever sold her weather." |
| Summer's engine | Steals from her | At the Dragonforge, Reptin: "She's burning a piece of Auril to keep her summer going. When it burns out, Auril comes to take her winter back." |
| Naerth, the lottery | Avarice's tools, feeding Auril | Eirwen's ledger: "Auril's winter made Ten-Towns desperate. Avarice taught it to be cruel, and fed every name to Auril to buy her summer." This was "Avarice taught it", which made Avarice the root. |
| Eira Voss | Her stillness taken all the way | "Auril's stillness, all the way down. The rest of them stop halfway." |
| The Still Keeper | What her winter makes of people | "The Still Keeper: what Auril's winter makes of anyone who holds it too long." |

## 2. The New Journey stake: Tamsin and home

Home exists because that night broke. If Auril keeps it, there's no tree, so no Rootspire, no Hellen and no
Tamsin. It now comes up at four points (New Journey only):
- **The fall through four hundred years (Ch5).** "If it ends any other way, there's no tree. No Hearth, no
  festival, no Tamsin at the stall waiting for you."
- **Hellen's story of the tree (Ch6).** "(If that night had held, there'd be no tree. No Hearth. No Tamsin. No
  you.)"
- **Tamsin's send-off (Ch12).** "And come BACK. Mum says if she wins, the tree never grows. No tree, no Hearth.
  No Hearth, no me."
- **Auril's last offer (Ch13).** "Your city under its tree. Your friend at her lantern stall. I could keep them
  exactly as they are. Nobody there would ever leave, or change, or grow old. Isn't that what home is for?"
  This echoes the Still Keeper's "Isn't that what memory is for?"

## 3. Pokémon at the centre (`054_PartnerBeats.rb`)

In each of these, one of your own Pokémon comes out of its ball and carries the moment. None of them is a
battle.
- **The landing in Targos (New Journey).** Your first Pokémon climbs into your coat and keeps you alive in the
  snow until somebody comes.
- **Good Mead burning (Ch9).** The Pokémon that opens the mead hall door is shown, and what it does depends on
  what it is:
  - A Water type soaks the frame until it stops smoking.
  - A fighter breaks the door.
  - Otherwise your lead throws itself at the door with you.
- **Auril's offer (New Journey).** Your first Pokémon steps between you and her. If it has evolved: "On
  festival morning it fitted in your two hands. Look at it now." Auril: "...That one grew. They always do."
  The answer to "nothing ever changes" is a Pokémon that changed.

The game now remembers which Pokémon was your starter (`state[:starter_pid]`). Saves from before this version
fall back to your lead Pokémon.

## 4. Stage directions cut by about half

About 1,480 lines had a parenthetical in front, such as "(very quietly)" or "(a long breath)".
- **Cut: 602.** These only described manner, e.g. "(quietly)", "(very still)", "(not looking up)", "(gently)".
  Also cut: "(to you)" when the line already says "you".
- **Shortened: 104.** Compounds lost their manner part, e.g. "(to you, very quietly)" became "(to you)".
- **Kept:** who's being addressed; props and actions the line depends on; non-human voices like "(wind
  through reeds)" and "(many voices)"; character tics like "(snap)" and "(pop, pop)"; anything that names what
  a line is about; and every direction that triggers a reaction balloon ("delighted", "sheepish", "hugging"…),
  because those show on screen. Herald thought-lines are untouched.

## 5. Voice pass

- **New voice sheets.** `docs/story/voices.md` now has a sheet for the city cast: Hellen, Tamsin, Kelyn,
  Selrae, Mira, Hew, Kethan, Rheven, Darrus, Wynsnow, Duvessa and Eirwen. Each sheet gives one marker you can
  hear with the name covered, a pet word, their yes and no, and what they never do. There's also a
  cover-the-names test for every scene.
- **Selrae never uses contractions now.** She was the closest to everyone else's dry, clipped register. Her
  first line was already "Winter does not ask permission", and now every one of her 46 rewritten lines
  matches ("Winter does not ask to be rescued. It seems I do."). A smoke check holds the rule.
- **The rest already pass.** Reading every line from the others, each already has a clear marker: Hellen's food
  and "love", Tamsin's CAPS and score-keeping, Hew's "my lads", Kethan's verdicts, Rheven's creed, Wynsnow
  interrupting himself, Duvessa's counting.

## Checks

- Smoke test: 248/248. Two new checks: Selrae's rule, and the partner beats, stake and spine lines being in
  the game.
