# 0.8.8 (2026-11-11): every line read for sense, and the Cup of Seasons

Owner's ask: "Don't forget actually checking the dialogue to be sure it makes sense. Some of your verbiage and
content feels just so odd to a human." and "What about all the lines already established?" The choice was
"Dialogue first": read every line in play order, main story first, then side content, then build new things.

## 1. The dialogue pass

What was read:
- **The main story, in play order.** That covers the New Journey route and all five Herald modes (Alberica,
  Reptin, Alerion, Meat Meat, Wyn), plus all three endings (Shatter, the third way and the Still Keeper). The
  lines came from headless traces, so each one was read where it shows up in play.
- **Branch lines no route reaches.** These are lines from choices the routes don't take, and lines for parties
  the routes don't have. About 2,900 of them are in the main-story chapters.
- **Side content.** That means every speaker-tagged line in the Ten-Towns quests, Rootspire's people, quests
  and nights, the Undercanopy, the trial week, the White Vault, grafting and the coffee scenes. About 2,800
  lines in all.

About 130 lines were rewritten. The rule for each fix was whether a person would say it, and whether a player
would follow it on first read. Typical problems and fixes:

| Was | Now | Why |
|---|---|---|
| "Everyone always is." (Emissary, after "they'll hand you something cold") | "...and you'll take it." / "Everyone always does." | The "is" pointed back at nothing. |
| "Hold both against me, and the guard will have you." (Eira) | "Show me both, and the guard will have you." | It read as a threat. She means "show me mercy and fury". |
| "The tree knows bought gold's smell." | "The tree can smell bought gold." | The word order was knotted. |
| "Griffons. Dawn." (Kethan) | "The griffons fly at dawn." | A fragment you had to decode. |
| "The Requiem's been provisioned for thirty years. It's about time." (Mira) | "...sat in port, fully stocked, for thirty years. About time she sailed." | It wasn't clear what "it" was. |
| "Hold still, displaced centuries!" (Halden) | "Hold still! You're centuries out of place..." | Nobody calls a person "centuries". |
| "Gone, and not coming back, the frost." (Hellen) | "The frost's gone, and it's not coming back." | Yoda word order. |
| "The tree felt that. Again." (Rheven, oath) | "...Try again." | "Again" read as "it happened again", not "do it again". |
| "Be unkind, if they are." (Reptin to Eirwen) | "If they're unkind, tell me anyway." | The meaning was the reverse of what he asks. |
| "This is ours, the Oath of Roots. Founders too." | "...Even founders swear it." | A fragment. |
| "The leaves have never shuddered." | "...never shuddered like this." | Without "like this", it said the leaves weren't shuddering. |
| "Lit a candle at your shrine. In daylight. Loudly." | "In broad daylight, where everyone could see." | You can't light a candle loudly. |
| "not a postcard" (Copper, in the Forgotten Realms) | "not a letter" | Postcards don't exist there. |
| "(The last before the engine beats.)" | "(The last one. Then the engine.)" | |

The main-story rewrites listed in the session (Prologue, Hellen, the Naerth lines, Shimmer and Shade, Zenith,
Luna, the Kelyn, Lumin, Pip, Cornipus, Seer, Var and Alerion lines, Darrus, Ch9-13 and every Herald's own
thought-lines) are in this version too. The smoke test's F2 needles follow the new text.

What was left alone: deliberate voice. That includes Meat Meat's third person, Zenith's verse, Korun's
bracketed thoughts, the Wraiths' riddles, Hellen's "You get used to them. You don't get used to them." and Avarice
calling the party "failures". Odd *on purpose* stays.

## 2. Fixes found on the way

- **talk() gifts arrived before the lines that hand them over.** `talk` now holds any `give` made while its lines
  are built, and pays them out after the lines are said (`007 talk`, `027 give`).
- **"You received the Alerion's Blessing!"** `grant_blessing` drops the article before a name in the possessive
  (Alerion's, Hyphora's, Glimmer's, and so on) and before "The".
- **Herald names in dialogue.** `player_display_name` gives a Herald's first name ("Alerion", not "Alerion
  Froststride"). Meat Meat is unchanged.

## 3. New: the Cup of Seasons (postgame)

A Champion Cup in the spirit of Sword and Shield (`052_SeasonsCup.rb`). After the credits, if you've beaten Tamsin,
she runs a tournament in the Hall of Seasons ("I seeded myself. It's allowed. I made the rules.").

- **Three rounds and a final.** The three opponents are drawn at random from whoever's still in the city:
  - Duvessa, Hellen, Hew and Kethan are always there.
  - Mira, unless she was left possessed and never freed.
  - Luminara, unless the colony was exiled.
  - Selrae, unless she was sentenced.
- **Teams and levels.** Each opponent brings six Pokémon: their own team grown up, plus their own kind. Round 1 is
  Lv 66-69, and each round after it adds two levels.
- **The final is Tamsin.** Her team is Furret, Noctowl (for the Hoothoot she grafted), Jumpluff, Ampharos, Lanturn
  (she loves a lantern) and her starter at Lv 72.
- **Rules.** Your team is healed between rounds. Lose once and you're out. The Cup can be entered again as often
  as you like.
- **Rewards.** The first win gives 3 Rare Candy, 2 PP Max and a Master Ball. You get the title and a mug Hellen
  made, and Hellen has a new line about it. Later wins give one of Rare Candy, PP Up, Full Restore or Max Revive.
- **Flags and counters.** `cup_invited`, `cup_champion`, `cup_wins` and `cup_losses`.
- **Smoke test.** There are four new checks: every Cup Pokémon and trainer class exists, the pool follows the
  story's flags, and one run with wins makes a champion while a loss puts you out.
- **Real battles.** `tools/headless/try_cup.rb` runs the Cup with real battles. Every opponent loaded six
  Pokémon at the right levels. A Lv 80 test team reached the final twice in three runs, and every run ended
  cleanly with the team healed.

## 4. New: in-game trades

Three of Rootspire's people will trade once you know them (`053_Trades.rb`), like the townsfolk in X/Y and
Sword and Shield do. Each wants something that lives near the city and gives something you can't catch there,
under a name they chose. Each trade happens once, and the offer stands until you take it.

| Who | When | Wants | Gives |
|---|---|---|---|
| Talwyn | after she tells you her secret | Delibird ("They deliver things. That's basically guarding.") | Swinub, "Frostina" ("He's a boy. He doesn't mind.") |
| Dathra | after the Deepfire talk | Swablu ("Nobody below has ever seen a cloud.") | Kabuto, "Grudge" (the "very rude fossil" from her stall) |
| Gurk | after the cellar hint | Magcargo ("A living forge.") | Scyther, "Whetstone" |

You get the Pokémon at the level of the one you trade away. The trade sets `trade_<who>` and the counter
`trades`. One smoke check covers the trades.

The smoke test is now 246/246.
