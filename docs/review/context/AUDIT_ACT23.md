# Acts II–III context pass: audit after the build (0.7.4, 2026-11-06)

Built on `context2_d` (06–07), `context2_e` (08–09), `context2_f` (10–11), `context2_g` (12–13) and `context2_h`
(14–15, the side quests), merged into main, to the owner's decisions of 2026-11-06 (`DECISIONS_ACT23.md`): Selrae in
the dock; Alberica's charge is the Bryn Shander night; the bargain hinted in Ch11 and told on the Ch12 dock; the sigils
wake the White Vault's door and her pendant opens it; Aerix's tribe song; the ghost is Alberica; Anduin said briefly in
Ch9; Var's seventh-night oath.

## Checks

- Smoke test 231/231 (two new checks: the rite clock; the Vault's key items stay clear of the relics' numbers).
- Full games re-recorded (`traces_074/`): Herald Reptin, Wyn, Meat Meat and Alberica 236/237 (Wyn 235/236, which has
  one beat fewer); New Journey in its own row below. The one miss in every mode is the postgame merge of the three sigils,
  which misses on the 0.7.3 baseline too. Meat Meat now plays the whole game with `HL_STARTER=1`; with her default team
  the driver loses Act I battles (Ranger Hadd, Good Mead) and reruns vary.
- Postgame Glasswater crossing (builder f, untested by f): no Wall prompt, no time-freeze, lands on "Where the Wall
  Stood" with its own arrival lines (scratch test).
- Anduin on screen through the Heartroot's Test, and Herald Reptin's hand is "your" hand (scratch test).
- Off-screen speakers: 379 in 0.7.3's Herald Alberica run, 224 now; the rest are voices with a reason (Kelyn's
  sending-stone, Hyphora, Auril's whispers, mirrors, the ghost) or gym leaders staged by their gym (Mira).

## Found during the audit, and fixed

- **Two traps a real player could not walk out of** (0.7.3 had the first; the driver had been training its way out):
  1. A scene's companions, left standing after it, were solid once their walk ended. After the orb's visions on the
     Canopy-Tier they closed the orb's nook; after the Canticle they cut off the statues' aisle in the Council Hall.
     Stage now keeps its actors walk-through whenever they aren't walking.
  2. After the spores debate (Ch10) Selrae walked up beside you in the Hall's side aisle and stayed, with Darrus's
     event beside her. Stage now remembers who walked up to you and, once you have control, sends them back to their
     places only if they cut you off from ground you could otherwise reach (so Luna still waits to talk after the
     Requiem). Darrus's event leaves the Hall once he's fallen (notes/09 E6).
- **The Vault's pendant on item number 9190**, one of the relics' numbers (they run 9100–9233). Moved to 9600.
- **Rootspire's clock:** rests before the rite burned Var's week while the rite stayed "tonight" (notes/06 E12); inside
  a night, dawn came before "past midnight" (E13). No night passes before the rite now, and a night runs rest, the
  night's beat, dawn, morning. Meat Meat's dawn walk no longer repeats the dawn line.
- **Herald Alberica's omens** ended "You don't tell anyone", a choice the player never made: now "(Tell someone?)"
  Not yet / Never, read back by Auril in Ch11; and the first omen about the key meets the family's bargain.
- **A night in the root-cells** between the arrest and the Tribunal, then a Chapter 10 card (notes/09 E5); Kelyn's
  charge no longer concedes the defence; Alberica names Glimmer at the trial.
- **The finished builders' cross-file items** (f's in g's and h's files, e's in d's and f's, d's in h's): the pilgrim
  and "Prototype Verdant"; the faction baskets name the season; the ledger line spoken; the Canopy watch and the Halo;
  Sephek's reason ("while her relics stand"); the well showed a map; the roots know Hyphora's leave; Alerion says whom
  the Halo means.
- **Over-long boxes:** 19 the new round put over 90 characters, trimmed or split. Across a whole game about 90 fewer
  boxes are over the limit than in 0.7.3; about 800 remain for the long-box pass.

## Not built yet (by part)

- **06–07 (d):** none left in d's files; d's items in other files were applied above.
- **08–09 (e):** 10.md's Part 9 plant (it belongs to the option decision 2 didn't choose); the refugee village line
  (**needs a village name from the owner**); the Great Unchaining; the F5 tag.
- **10–11 (f):** the trial week's day clock (notes/10 E2); E17 (Alerion's mode only); Project Rime; the 10.13 shard.
- **12–13 (g):** staging for the test shades (visions); the Root-Gate stair box (Low); dialogue §4 lines outside §3;
  panels S-12a and S-12b (art; the crossing works without them).
- **14–15 (h):** the dialogue reworks (Keegan's clock, Korux, Marta, the Codex split, the Prompters); notes/14 E13
  (rewards that promise what the game doesn't do); Kelyn's "deny first".
- **Still open from Act I:** the long-box pass; Koran's five boxes; item icons; Hadd's balance for a two-Pokémon team.
- **Driver only** (beats complete): the driver's first try at some named events fails on the wrong map (the Captain's
  root-desk, the Root-keep gate) and Thredra moves away while it walks to her; the 2050→2089 route; none is a block.
