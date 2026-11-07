# Act II scene pass: audit after the build (0.7.8, 2026-11-07)

Built on `scene2_d` (06 Rootspire and the Rift, 07 the Requiem, Road B and the Deep Labyrinth), `scene2_e` (08 the
Forge and the Heart, 09 the flight and Bryn Shander), `scene2_f` (10 the trial week, 11 the Shrine) and `scene2_h`
(15, Rootspire's side content), merged on `act2_merge` to the brief in `BUILD_ACT2.md`. Then a second round in
which each builder built what the others had listed for its files, and a box pass at the merge.

## Checks

- Smoke test 235/235. All 159 maps pass the builder's map checks (two new: 2214 and 2215, the Boreal Requiem's
  deck and hold).
- Full games re-recorded on fresh test copies (`traces_078/`): New Journey 244/245; Herald Alberica, Reptin and
  Meat Meat 236/237; Wyn 235/236. The one miss is the postgame sigil merge, as on every baseline. Rootspire's 20
  side beats play in every mode; builder h's side-quest test passes 54/54.
- Act II as played (Act I's end to Chapter 11's end), 0.7.7 → 0.7.8:

  | Measure | Journey 0.7.7 | Journey 0.7.8 | Wyn 0.7.7 | Wyn 0.7.8 | Meat Meat 0.7.7 | Meat Meat 0.7.8 |
  | --- | --- | --- | --- | --- | --- | --- |
  | Boxes | 3729 | 3984 | 3761 | 4032 | 3697 | 3945 |
  | Boxes over 90 characters | 722 | 4 | 723 | 3 | 715 | 4 |
  | Lines spoken off screen | 176 | 43 | 174 | 43 | 174 | 43 |
  | Choices | 242 | 290 | 255 | 308 | 257 | 304 |
  | Staging events | 1400 | 1687 | 1298 | 1576 | 1242 | 1476 |

  Alberica and Reptin (no 0.7.7 trace kept) end at 4 boxes over 90 each, 321 and 316 choices.
- **Over 90:** the four left are lines protected word for word in the dialogue reviews (Meat Meat's "could have
  caught his hand", Ivo's "past the wards", and Wyn's two spores lines; each runs long only by its stage direction).
  The base game's own strings ("You scurry back to a Pokémon Center", the bag's "awayin") aren't counted.
- **Speakers:** nobody has four boxes in a row in any mode.
- **Runs without input:** one in each mode, the rest-day coffee scene (6.23), 35 boxes plus the trial-week morning
  lines after it (43 in Journey, 32 as Alberica, who gets the toast). It is protected whole (it's the voices.md
  sample), so it stays as written; see "For the owner".
- **Off screen:** the 43 are voices by design: the sending-stone (Kelyn), Hyphora and the tree, the sigils, the
  compass, the Shard, people behind the burning mead-hall door, a Rootwarden in an amber pod, the girl inside the
  mirror.
- Each builder checked its added and changed lines as played in its own traces (every one plays, in order, apart
  from a few on branches the driver never takes: Hew's defeat line, the V-7 line, the Amber Vault camp).

## What was built

- **d (06–07):** the dragons land on screen and Lumin names them; festival night at the Hall with its crowd and
  music; Eline's exit, the Lecture's crack, the orb visions one at a time, the Rift staged. Six new inputs (the
  Council's walls-or-roots vote, the stew, resting, the journal, Glimmer's return, Wyn's offer). Gym 6 now plays
  aboard the Boreal Requiem; the saboteurs, the mirror girl, Selrae's wardens and Yarro are drawn; Hew's
  confession ends in a choice; Selrae hands over the key; a rest camp in the Vault of Amber Dreams. Round 2: the
  Deep Labyrinth's creatures stay gone, Hew names both locks, a Rootwarden at the Echo Gate, the lift-keeper and
  Razzilith after Chapter 9.
- **e (08–09):** the Forge and the Heart Chamber staged; Chapter 9's flight and squares played; a player choice on
  each decisive beat; Meat Meat's bridge choice read back on the walk south. Round 2: Var's vision keeps the
  Chapter 8 twist, the catalogue and lab notes cut down, the arrest's line order.
- **f (10–11):** a seven-day clock for the trial week; a challenge's right answer no longer sits in one place;
  staging for the wall wolves, the debate, Anduin, the root-cells, the wardens, the hearings, Talion, the escort
  and Gym 8; witnesses called in court; the vote's reasons; Chapter 11 and the Shrine fight with music. Round 2:
  Eira's pointers to open side stories, Faria's 10% once her amulets are home, the maze wraith's level, Kelyn and
  Meat Meat read the bridge flags.
- **h (15):** givers who walk up to you; each master's watcher shown and owned up to; Wynsnow's anchor; Kelyn at
  night; the festival hunt; Selrae at the back door; city news; passers-by who walk on to speak. Round 2: the
  dream before dawn, one Spring basket, Summer's quarters dressed, the Shard of Stillness explained, Kelyn's
  election line, omens spaced three maps apart.

## Fixed at the merge

- "I sneezed." (protected, dialogue 09 §6) was lost when the context pass moved Alberica's charge to the Bryn
  Shander night. It's back in the spores hearing, as her answer to the spores.
- Meat Meat asks you on the walk south to say at the trial that you held the child; the trial now lets you.
- Box pass from the first merged trace: the dawn line's lean in its own box; Eline at the Rift and Rheven at the
  blight no longer four deep; five long boxes trimmed; the Mycolith hoard in three boxes instead of twenty-two; an
  input in the root-cells night and at the Chasm wolf's morning.
- Two merge conflicts (the test driver's event names; the flag lists), resolved keeping both sides.

## Not built

- **Engine strings:** "awayin" and "mYou scurry back…" are the base game's.
- Tamsin can't use the player's full name: the game has no surname.
- A second Eline trainer (notes 10 E17) would clash: trainers are keyed by type, name and number.
- The Chapter 9 partner battle (notes 09 E10) stays narration with Frostina beside you.
- The loop's fallback flag lists (`041_LoopFlags.rb`) lag a full playthrough (they did before this pass too); they
  are only used for a save with no loop snapshot of its own.
- **Art** the builders asked for is in Art List 2, "From the Act II scene pass".

## For the owner

- **The coffee scene** is the one long run left (35 boxes, no input outside Herald Mode). It's protected whole.
  Keep it, or allow one cheap choice in it (e.g. which pot you pour from)?
- **Rootspire's cut-and-merge verdicts** (story/15): Glimmer's rite down to two days, Meat Meat's days merged, the
  portal and Eira's market cut. Builder h left them because the smoke test expects those days.
- **The Umbound's name** is still undecided (Chapter 9).
