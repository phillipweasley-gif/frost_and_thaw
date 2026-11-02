# Audit E: Act I versus the published adventures (The Cackling Chasm and Rime of the Frostmaiden)

Scope: Act I, Chapters 1 to 5 of *Pokémon Frost & Thaw*. I checked the story code in `game/Data/Scripts/998_FrostThaw/` and the map builders in `tools/build_*.rb` against two sources:
- `sources/cc.txt`: *The Cackling Chasm*. I read all 1,330 lines.
- `sources/rotf.txt`: *Rime of the Frostmaiden*. I read only the sections for Targos, Bryn Shander, Lonelywood, Good Mead and Dougan's Hole, the Sacrifices to Auril rules and the Cold-Hearted Killer quest.

I didn't change any game files.

Line numbers in the Source column point to `cc.txt` (prefix **CC**) or `rotf.txt` (prefix **R**). Code locations are `file:line`, relative to `game/Data/Scripts/998_FrostThaw/` unless they start with `tools/`.

The Moon Temple, the Glade of the Unmade, the Wennen, Zenith Abbott, the Heart of Ice, Razzy, Frostina, the golden acorn and Thredra's mirrors don't appear anywhere in RotF or CC (I grepped both; 0 hits). They come from the campaign's own notes, so I don't count them below. They show up only where they replace something published.

---

## 1. Summary

### Counts

Totals are for the 144 rows in the full table (section 3).

| | Full | Compressed | Changed | Missing | Total |
|---|---|---|---|---|---|
| The Cackling Chasm | 29 | 20 | 13 | 18 | 80 |
| RotF towns and quests used | 27 | 12 | 14 | 11 | 64 |
| **Overall** | **56** | **32** | **27** | **29** | **144** |

How the categories split:
- **Changed (CC, 13):** 10 are clearly the campaign's own rewrites:
  - the hag freezing Dougan's Hole, turned into the night at the Twenty Stones
  - the hag's summons
  - the Heart becoming a World-Tree root
  - Alberica's face in the locket
  - Shimmer as the illusion's voice
  - the ghost as Alberica's future self
  - the hag's scheme
  - the golden-acorn third way
  - the mirror ending
  - the fall into Rootspire replacing the treasure and epilogue

  The other 3 are the adaptation's own changes: a mother yeti you can calm and who survives, an unsigned journal, and the weeping on the right path made real.
- **Missing (CC, 18):** 3 are optional in the book.
- **Changed (RotF, 14):** 5 are deliberate: the lottery-night scene, Sephek's motive, his regeneration becoming the frozen-in-ice ending, the Shimmer and Glade storyline, and the starving-pack bite.
- **Missing (RotF, 11):** 8 are "Missing (optional in book)", meaning a town's side quest or a flavour NPC. The 3 that aren't optional are all part of Sephek's starting quest: Hlin Trollbane, Torrga and her caravan, and his possessed-mariner origin.

### My overall judgement: The Cackling Chasm (Chapter 5, with its setup in Chapter 4)

**Very faithful room by room, but the moral core of the module was dropped.**

Every keyed area is built and played in order:
- the Laughing Entrance (illusion, icefall, mephits, locket)
- the Frozen Feast Hall (dead yeti with its heart cut out, swaddling, tracks, the mother yeti, backpack and journal)
- the Hall of Illusions (left light and pit with ghouls, "SHE LIES / DON'T TRUST THE LIGHT", right weeping path)
- the Frozen Rift (bridge, frayed rope, falling ice, gust, a ghostly woman pointing, a sheltered rest spot)
- the Guardian's Gate (carvings, whisper riddle, stained bowls, a blood / bone-dust / silence puzzle, skeleton guardians on a wrong offering, a vision, a hidden seam)
- the Hidden Sanctum (the guardian's ghost, the werewolf-wardens reveal, a blessing that returns in the final fight)
- the Heart (dais, cub in chains, a winter wolf and an ice troll, "a life for a life", "the new Winter, not so fickle as Auril", Reptin's "Take me instead")

Many lines are taken word for word. Tying the winter wolf to Kanan from Dougan's Hole follows a suggestion the module itself makes (CC 975-976). This isn't a shortcut adaptation of the dungeon.

The shortcut is in the **temptation**:
- **The hag never makes her bargain.** Nowhere in Act I does she offer to end Auril's winter and cure Reptin (CC 13-18, 31-34, 49-52). The only trace is a party-chat line from Reptin: "She promised to take it away..." (`023_Chapter5.rb:135`). It refers to a promise the player never sees.
- **The final choice is safe.** The player can't accept the sacrifice. She never tries to kill the cub mid-fight. The ghost never warns about the cub or about what using the Heart would cost.

So the module's central "terrible moral choice under life-or-death pressure" (CC 105-106, 960-963) is reduced to a confrontation with no real dilemma.

Smaller losses:
- the Order's history (the gnoll / Yeenoghu fall, Alberica sealing the sanctum)
- the hag's look and cauldron
- all of the module's treasure
- its epilogue, which was knowingly replaced by the fall into Rootspire

### My overall judgement: RotF towns (Targos, Bryn Shander, Lonelywood, Good Mead, Dougan's Hole)

**Town flavour is faithful. Of the five towns' quests, only one is played.**

**Dougan's Hole and *Holed Up*: close to a full adaptation.** Fidelity is very high:
- the townsfolk chorus, nearly word for word
- the Twenty Stones of Thruun
- Durmoot believing the children are dead
- the limp-leg tell
- a starving pack
- the flensing chamber, the cage with its squealing hinges and the whale oil
- Norsu calmed by claiming friendship or vowing vengeance
- the kobolds and the chwinga statuette
- thrym and the remorhaz tunnel
- the wolves' ambush on the way home

One real gap: Koran's lie that Garagai is alive, and Norsu as the mastermind behind the extortion, were dropped. The chapter header still promises the lie (`022_Chapter4.rb:14-15`).

**The other four towns are set dressing for the campaign's own plot.** Their named NPCs and buildings are present and accurate:
- Naerth, Skath, the Luskan Arms, Three Flags Sailing, Triglio
- Duvessa, Mishann and the House of the Morninglord, the Northlook, Blackiron Blades
- Nimsy, Scoop, the attic, the halfling cookies, the Lucky Liar with Danae, the Happy Scrimshander with Iriskree, Ramshackle
- Kendrick's body in the shrine, the verbeeg theft, Fef Moryn and the fox, Olivessa, Shandar

But four of the towns' quests appear only as rumours or not at all:
- *Mountain Climb* (Targos)
- *Foaming Mugs* (Bryn Shander)
- *The White Moose* (Lonelywood)
- *The Mead Must Flow* and the speaker election (Good Mead)

These are optional in the book, so that's acceptable for a Pokémon structure, but it is thin.

**Sephek / *Cold-Hearted Killer*: deliberately rewritten, and it works.** But everything around him from the book is gone:
- Hlin Trollbane
- Torrga Icevein and Torg's caravan
- the three ice-dagger murders of people who cheated the lottery
- his origin as a drowned mariner possessed by a frost druid's spirit

There are also some accuracy slips, all minor:
- Every town is said to draw a lottery name. In the book only Bryn Shander, Easthaven and Targos do (R 1040-1060).
- Duvessa is turned into a Zhentarim debtor.
- Lonelywood is reached from Bryn Shander's north gate. In the book it connects only to Termalaine (R 4513-4518).
- Bryn Shander is placed "north" of Targos.

---

## 2. Biggest gaps (ranked)

1. **The hag's bargain is never offered.** She should promise to end Auril's winter and cure Reptin's lycanthropy in exchange for a task (CC 13-18, 31-34, 49-52). Her final line "Will you honor our deal?" (CC 943-957) and the moment where the curse is half pulled from Reptin (CC 943-946) both depend on it. Today the only trace is Reptin's chat line at `023_Chapter5.rb:135`.
   *Where it could go:* make the offer during the Twenty Stones parley (`022_Chapter4.rb:810-828`) or in Reptin's dream at `023_Chapter5.rb:188`. Then pay it off in `thredra()` (`023_Chapter5.rb:563-572`) with "I always keep my end of a bargain" and the curse-tug.

2. **The player can't take the dark path in the final choice.** The module's climax is a real temptation: let the cub die, and the winter ends and Reptin is cured. It treats this as a valid, if dark, ending (CC 988-1007, 1198-1215). The game's menu (`023_Chapter5.rb:573-585`) offers only "Never", "Reptin steps forward" and the acorn.
   *Where it could go:* add a "Let her" option in `thredra()`. It could lead to a short bad ending, or feed the Still Keeper loop (`040_Loop.rb`), which already exists for exactly this kind of branch.

3. **The ghost never warns about the yeti cub or the cost of the Heart, and the Order's history is cut.** In the module she should:
   - warn that the innocent is a yeti child and beg them to stop it (CC 844-850)
   - explain that using the Heart leaves a "soul-debt" (CC 847-850)
   - tell how gnolls of Yeenoghu attacked and she sealed the sanctum by sacrificing herself (CC 835-839)
   - give the prophecy of the wolf, the innocent and the crone (CC 892-896)

   The Feast Hall's Yeenoghu blood runes, which set this up, are missing too (CC 283-290).
   *Where it could go:* add lines in `order_ghost()` (`023_Chapter5.rb:520-527`), and a "blood runes" sign in the feast hall in `tools/build_ch5.rb` near line 111.

4. **Sephek's *Cold-Hearted Killer* framework is missing.** That means Hlin Trollbane as quest-giver (R 1090-1207), Torrga and Torg's caravan (R 1214-1289), and the three ice-dagger murders of lottery cheats (R 1118-1124, 1164-1170, 1266-1271). His true nature, a shipwrecked mariner possessed by a frost druid's spirit (R 1255-1265), is never revealed anywhere in the game (I grepped all scripts).
   *Where it could go:* put Hlin in Three Flags Sailing (`tools/build_act1.rb:168`). Make Kip's "three names never drawn" (`017_TargosExtras.rb:228-235`) into Sephek's victims, and reveal the backstory at the Moon Temple (`015_Chapter3.rb:516-541`) or when he returns in Act III.

5. **The hag never tries to kill the cub mid-fight, and the cub is never at risk.** At low HP she should lunge to cut the cub's throat to feed the Heart, so the party has to stop her (CC 1046-1050, 1086-1092). Stray attacks and freeing the chains during the fight are also part of the scene (CC 1030-1034, 1071-1077). The game frees the cub only after the fighting is over (`023_Chapter5.rb:695-700`).
   *Where it could go:* add a scripted beat between the Thredra battle and the Reflection battle (`023_Chapter5.rb:600-623`), with a timed choice, or a battle that fails if the cub is hit.

6. **Koran's Garagai lie and Norsu's role as master are gone (*Holed Up*).**
   - In the book Koran claims Garagai kicked him and is holding the prisoners (R 3164-3172). Kanan plays the "bad wolf" (R 3173-3182).
   - The wolves extort the town on Norsu's behalf, and Norsu enjoys killing (R 3108-3125).
   - The wolves won't go inside because they expect Norsu to kill the party (R 3210-3222).

   In the game Koran says "My brother's gone mad" (`022_Chapter4.rb:510`). This contradicts the chapter's own header (`022_Chapter4.rb:14-15`).
   *Where it could go:* restore the lie in `koran()` (`022_Chapter4.rb:509-511`), and add a beat where the wolves nudge the party in at the lodge door (`tools/build_ch4.rb:445`).

7. **The Mead Must Flow (Good Mead): Missing (optional in book).** The full quest is the trail to the five militia corpses, the chwinga and the fox, and the verbeeg's lair: Duhg, the ogre "Friend", the cave bear Yogobor, the named livestock, the Silvanus pool, a cursed chieftain's tomb, and Gahg's basket of metal fragments (R 4157-4459). The game has only the setup (`022_Chapter4.rb:147-149, 165-176`).
   *Where it could go:* an optional forest map east of Good Mead (`tools/build_ch4.rb`, map 2031), reached by following Fef's tracks. Returning the casks would unlock the mead hall's mead.

8. **The White Moose (Lonelywood): Missing (optional in book).** That's the awakened moose, Ravisin the frost druid, the elven tomb and the moon-mirror sundial (R 4587-4900). The game only seeds rumours (`015_Chapter3.rb:78, 136, 164, 184`).
   *Where it could go:* an optional woods map off the Lonelywood road (`tools/build_ch3.rb:57-65`). Ravisin also connects to the Frost Druid thread later.

9. **Foaming Mugs (Bryn Shander): Missing (optional in book).** Hruna, Korux and Storn ask for their abandoned iron sled. It involves a yeti, a blizzard, and Izobai's goblins with a polar-bear wagon (R 1842-1963). Blackiron Blades exists only as a shop (`tools/build_ch2.rb:240, 295`).
   *Where it could go:* a side branch off the Bryn Shander Road (`tools/build_ch2.rb:155-171`), with a shop discount as the reward.

10. **Good Mead's speaker election and Shandar's Zhentarim plot: Compressed.** In the book Olivessa asks a PC to run; Shandar is blackmailed by Naerth, who sends thugs for a staged "rescue" (R 4109-4131, 4398-4459). The game only hints at it (`022_Chapter4.rb:156, 161-164`).
    *Where it could go:* an event in Good Mead after Chapter 4 (after `dh_morning`). It ties into Naerth's thread from Chapter 1.

11. **The hag's look, cauldron and treasure are missing.** That covers:
    - her description: bruise-coloured skin, necklace of frozen baby teeth, black staff hung with frozen sprites (CC 925-931)
    - the iron cauldron of ritual brew (CC 932-934)
    - flying on her staff (CC 1016-1018)
    - the loot: Graystaff / Staff of Frost, opals, a scroll of counterspell, the winter-wolf pelt, the Druidic Codex, a shard of the Heart, and the locket becoming a Bless charm (CC 1133-1145, 1236-1257)

    *Where it could go:* add description lines in `scene_heart_enter` / `thredra()` (`023_Chapter5.rb:551-571`), a cauldron event in `tools/build_ch5.rb` near line 199, and a key item (a Heart shard or the staff) that Act II can use.

12. **Mountain Climb (Targos): Missing (optional in book).** That's the sled dog Boy, Keegan Velryn, and Garret's expedition up Kelvin's Cairn (R 4977-5050). The Commons and the Sparring Ring fill Targos instead.
    *Where it could go:* Boy running through the Targos streets (`tools/build_act1.rb:136-142`) as an optional hook. It could be short: find Garret's sled on the road.

13. **Several Bryn Shander NPCs are missing:**
    - Sheriff Markham Southwell (R 1756)
    - Copper Knobberknocker in Mishann's attic, with the Black Cabin / Macreadus hook (R 1787-1805)
    - Scramsax and Ol' Bitey at the Northlook (R 1807-1840)
    - Garn and Elza at Blackiron Blades (R 1759-1763)

    Duvessa is also rewritten as a Zhentarim debtor, which isn't in the book (`014_Chapter2.rb:128-129, 202-205`).
    *Where it could go:* NPCs in House of the Morninglord (`tools/build_ch2.rb:282-283`) and the Northlook (`tools/build_ch2.rb:302-306`).

14. **The chasm's tension and the hag's taunting are flattened.** The book's version has:
    - the bridge as a real skill challenge with slips and falls (CC 606-623)
    - personal voices on the wind (CC 635-638)
    - the "Don't leave me!" guilt when walking away from the fork (CC 465-466, 538-542)
    - the hag's running taunts: "such violence... time is ticking" (CC 389-392), "You'd let winter's night continue... to spare one little monster?" (CC 1001-1003)
    - Reptin's eyes flashing amber at the blood (CC 120-122, 393-397)

    *Where it could go:* add one-line taunts in `dead_yeti`, `scene_weeping_dark` and `thredra()`, plus an optional slip on the bridge in `bridge_gust` (`023_Chapter5.rb:422`).

---

## 3. Full table

Status is one of: **Full**, **Compressed** (with what was lost), **Changed** (how; *deliberate* = clearly the campaign's own rewrite), **Missing**, or **Missing (optional in book)**.

### 3a. The Cackling Chasm

| # | Item | Source lines | Status | Where in game | Notes |
|---|---|---|---|---|---|
| C1 | Background: the hag deep-froze Dougan's Hole; the heroes foiled her and she survived | CC 9-12 | Changed (deliberate, expanded) | `022_Chapter4.rb:413-426, 789-897`; `tools/build_ch4.rb:299-313` | Turned into Chapter 4's night at the Twenty Stones: people frozen on the ice, three ice mirrors, the hag flees laughing toward the chasm. A good use of the backstory. |
| C2 | The hag's bargain: end Auril's curse and cure Reptin | CC 13-18, 31-34, 49-52 | **Missing** | Only `023_Chapter5.rb:135` (Reptin: "She promised to take it away") | The offer is never made on screen. That chat line refers to an event that doesn't exist. See gap 1. |
| C3 | Order of Life and Death; werewolves as wardens; Reptin's curse marks him as one | CC 20-25 | Compressed | `023_Chapter5.rb:95-96` (Odda), `:524-533` (ghost) | The core reveal is kept. The "bound by blood to the Order" lineage isn't. |
| C4 | Heart of the Chasm: absorbs life to counter death; the hag's hidden truths (only a temporary fix, makes her stronger, losing Reptin removes a warden) | CC 26-43 | Changed (deliberate) | `023_Chapter5.rb:521-523, 567-571` | Becomes "the last living root of the World Tree". Feeding it makes the hag "the new Winter". Same structure, campaign cosmology. |
| C5 | Hook: the hag's messenger or a chilling dream invites them to parley | CC 49-52 | Changed (deliberate) | `022_Chapter4.rb:813-828, 873` | Done through the relic "lures" (`017_TargosExtras.rb:65-78`) and "Come and find me in the chasm, dearies. Bring your wolf." The invitation has no bargain attached. |
| C6 | Hook: hunters' rumours of cackling south of Dougan's Hole | CC 53-56 | Full | `023_Chapter5.rb:86-91`; `022_Chapter4.rb:196, 216-221`; `006_Dialogue.rb:33-34`; `014_Chapter2.rb:131` | Seeded from Targos onward. |
| C7 | Hook: Reptin's vision of a chained wolf and "Abandon your bond..." | CC 57-61 | Full | `023_Chapter5.rb:128-129, 188-189, 199-200` | Near verbatim. |
| C8 | General features: dark, cold exhaustion, slick floors, echoes, smell, faint whispers of names | CC 69-101 | Compressed | Music `tools/build_ch5.rb:14-17`; laughing lines throughout Chapter 5 | No cold or slip mechanics, no names whispered. Fine for the medium. |
| C9 | Escalating horror toward a terrible moral choice | CC 102-108 | Compressed | Chapter 5 overall | The horror escalates. The moral choice doesn't (see C2, C67, C78). |
| C10 | Reptin's role: anxious, singled out by the hag, nearly loses control at the blood in Area 2 | CC 115-122, 393-397 | Compressed | `023_Chapter5.rb:130, 220, 270` | "The wolf in me doesn't care how old" is kept. The amber-eyes / fangs moment and his vow are missing. |
| C11 | Reptin: "Take me instead!" and the hag's scornful refusal | CC 125-128, 996-998 | Full | `023_Chapter5.rb:577-578` | "Oh, I'll take you all, wolf. In order." |
| C12 | The hag uses Reptin in the finale (threatens or paralyses him) | CC 123-125, 981-987 | Missing | – | – |
| C13 | Area 1: the hag's illusory greeting ("Come in, dearies... So good of you to visit an old woman", "I smell the wolf among you") | CC 142-169 | Full | `023_Chapter5.rb:213-224`; also `022_Chapter4.rb:813` | Verbatim lines. Lantern added. |
| C14 | Area 1: detecting the illusion (Insight / Detect Magic) | CC 170-179 | Compressed | `023_Chapter5.rb:221` ("She flickers and is gone") | Shown, not tested. |
| C15 | Area 1: icefall trap and "Oops! Mind your heads, dearies!" | CC 180-200 | Full | `023_Chapter5.rb:226-235`; `tools/build_ch5.rb:96` | Damage to the party is applied. |
| C16 | Area 1: ice mephit ambush and their exploding death | CC 201-226 | Full | `023_Chapter5.rb:236-241` | Two Snorunt named "Ice mephit". |
| C17 | Area 1: frozen locket (half sun / half moon), portrait, the name "Alberica" | CC 227-237 | Changed (deliberate) | `023_Chapter5.rb:245-260`; `tools/build_ch5.rb:97-101` | The portrait is Alberica's own face, older (a dwarf, not a human). Given as key item FT_ORDERLOCKET. |
| C18 | Area 1: gnoll femur frozen into the fallen ice | CC 244-249 | Compressed | Bone tiles in `tools/build_ch5.rb:92`; trapper `023_Chapter5.rb:89-91` | The gnoll history survives only as a line of rumour. |
| C19 | Area 2: Frozen Feast Hall carnage (goats, foxes, a human arm, a trapper, a dwarf) | CC 252-276 | Compressed | `023_Chapter5.rb:283-285, 315` | Bone pile of goat, fox and gnoll. No human remains. |
| C20 | Area 2: dead male yeti, heart deliberately cut out | CC 276-282 | Full | `023_Chapter5.rb:263-265` | "Not bitten out. Cut." |
| C21 | Area 2: blood runes, Yeenoghu defiling a druidic emblem | CC 283-290 | Missing | – | Sets up the Order's fall (C51). |
| C22 | Area 2: enraged, grieving mother yeti who fights to the death | CC 291-345 | Changed | `023_Chapter5.rb:281-309`; returns `:590-592, 695-698` | Can be calmed with the Bryn Shander lullaby (if you stood with Alberica). Survives either way and later fights the troll. A kinder take than the book's (where a DC 15 Animal Handling check only distracts her). |
| C23 | Area 2: humanoid footprints and drag marks | CC 346-351 | Full | `023_Chapter5.rb:269` | – |
| C24 | Area 2: swaddling clutched in the dead father's hand | CC 352-357 | Full | `023_Chapter5.rb:265-271` | – |
| C25 | Area 2: backpack with a healing potion and "Glimmer's" journal ("Granny Thredra... desperate to save Alberica") | CC 365-381 | Changed | `023_Chapter5.rb:320-327`; `tools/build_ch5.rb:112-115` | Journal unsigned: "Granny Thredra says she can bring my sister back... SHE LIES." The Glimmer name was reworked (Glimmer is Shade's later self, `029_Glimmer.rb`). Alberica's name is dropped from the journal. |
| C26 | Area 2: coins (32 gp, 18 sp), gnoll greataxe, necklace of ears | CC 367-370 | Missing | – | Minor. |
| C27 | Area 2: the hag's echo "Ohhh, such violence... time is ticking" | CC 389-392 | Missing | – | – |
| C28 | Area 3: glassy mirror corridor; reflections that linger and grin | CC 400-424 | Compressed | `023_Chapter5.rb:333` ("Two tunnels of glassy ice") | Odd, since mirrors become the hag's main motif. |
| C29 | Area 3, left: false light and a child's voice ("I'm Glimmer... I'm lost") | CC 425-434 | Changed (deliberate) | `023_Chapter5.rb:330-339` | The voice says it's Shimmer, calling Shade. Strong reuse. Alerion stops Shade. |
| C30 | Area 3, right: weeping old woman (an illusion), the true path | CC 434-442 | Changed | `023_Chapter5.rb:382-389` | Recast as "real: the cub's mother, or her echo". Loses the "both directions are tricks" design. |
| C31 | Area 3: clues (breeze from the right, looped sobs, Insight) | CC 440-460 | Compressed | `023_Chapter5.rb:387` (claw marks) | – |
| C32 | Area 3: pit trap in the dead end, two ghouls | CC 469-513 | Full | `023_Chapter5.rb:341-364`; `tools/build_ch5.rb:118, 126-139` | Duskull and Banette named "Ghoul". Climbing back out by rope is present. |
| C33 | Area 3: pit treasure (gnoll dagger, 15 gp and agate; potion and scrimshaw halfling) | CC 514-519 | Compressed | `023_Chapter5.rb:366-371` | The scrimshaw halfling and the potion are kept. |
| C34 | Area 3: "SHE LIES" / "DON'T TRUST THE LIGHT" in blood | CC 519-523 | Full | `023_Chapter5.rb:101`; `tools/build_ch5.rb:133` | – |
| C35 | Area 3: the hag laughs, "Poor little lambs... did you stumble? Heehee!" | CC 526-529 | Full | `023_Chapter5.rb:360` | Verbatim. |
| C36 | Area 3: guilt on the right path ("Don't leave me!", a girl's reflection) | CC 465-466, 538-542 | Missing | Shade's chat line at `023_Chapter5.rb:147` only | – |
| C37 | Area 4: rift, five-foot bridge, frayed rope, rising cackle, chanting beyond | CC 564-584 | Full | `023_Chapter5.rb:403-411` | – |
| C38 | Area 4: chunk of ice cracks onto the bridge | CC 580-583 | Full | `023_Chapter5.rb:413-420` | – |
| C39 | Area 4: crossing as a skill challenge (slips, falls, ropes, plans) | CC 606-623 | Compressed | Scripted triggers `tools/build_ch5.rb:159-160` | No way to fail. Alerion's "grab the rope" chat line is the only nod. |
| C40 | Area 4: wind gusts knock you to your knees | CC 623-627 | Full | `023_Chapter5.rb:422-425` | – |
| C41 | Area 4: laughter on the wind becomes personal voices | CC 635-638 | Missing | – | – |
| C42 | Area 4: a ghostly woman on the far side points a warning | CC 652-658 | Full | `023_Chapter5.rb:426-436` | – |
| C43 | Area 4: optional threats (will-o'-wisps, specter, coldlight walker, bats) | CC 639-675 | Missing (optional in book) | – | – |
| C44 | Area 4: sheltered nook for a short rest | CC 687-690 | Full | `023_Chapter5.rb:440-450` | Also becomes the point where you respawn after losing. |
| C45 | Area 5: the Guardian's Gate (wolf and moon / scythe and infant, skulls and blossoms, whisper "Only by the blood of living life...") | CC 693-722 | Full | `023_Chapter5.rb:102-105, 452-458` | Verbatim. |
| C46 | Area 5: the offering puzzle (fresh blood; bone or ash, or silence; stained bowls as hints) | CC 723-752 | Full | `023_Chapter5.rb:459-473` | Even includes the "stand in silence" reading. Bone dust is picked up in the feast hall (`:311-318`). |
| C47 | Area 5: wrong offering brings skeleton guardians; necrotic burst | CC 753-775 | Compressed | `023_Chapter5.rb:484-490` | Guardians are present and fights repeat. No necrotic burst. |
| C48 | Area 5: door opens; vision of a robed figure doing the rite with werewolf guardians | CC 776-783 | Full | `023_Chapter5.rb:475-480` | The figure is a dwarf (fits C50). |
| C49 | Area 5: hairline seam to the hidden sanctum | CC 784-793 | Full | `023_Chapter5.rb:478, 494-501` | The locket warms near it. |
| C50 | Area 6: the bier, a preserved corpse, green robes, lichen, the ghost rising | CC 795-819 | Compressed | `023_Chapter5.rb:507-515`; `tools/build_ch5.rb:180-183` | The ghost is simply waiting. The corpse rising and the vigil offerings aren't described. |
| C51 | Area 6: the Order's history (Yeenoghu gnolls attacked; Alberica sealed the sanctum and gave her life to the wards) | CC 835-839 | Missing | – | See gap 3. |
| C52 | Area 6: the ghost is Alberica, last guardian of the Order | CC 815-824 | Changed (deliberate) | `023_Chapter5.rb:513-518, 533-535` | She has the PC Alberica's face, decades older ("I borrowed it"). Never confirmed in Act I. |
| C53 | Area 6: werewolf wardens ("the curse... is a sacred charge"); Reptin's choice | CC 828-834, 850-856, 884-887 | Full | `023_Chapter5.rb:524-533` | Reptin chooses to keep his charge. |
| C54 | Area 6: the hag's scheme (sacrifice an innocent at the Heart, become a blight on life and death) | CC 839-844 | Changed (deliberate) | `023_Chapter5.rb:521-523` | "Drain the root and become winter herself." |
| C55 | Area 6: warns that the innocent is a yeti child; the Heart's "soul-debt" | CC 844-850 | Missing | – | The ghost never mentions the cub. See gap 3. |
| C56 | Area 6: an alternative (cursed or freely given blood might satisfy the Heart) | CC 861-868 | Changed (deliberate) | `023_Chapter5.rb:636-646` | The third way is the golden acorn, "a life that hasn't started yet". The ghost doesn't hint at it. |
| C57 | Area 6: boons (healing; the locket or talisman against illusions; a sacred weapon) | CC 868-883 | Compressed | `023_Chapter5.rb:539-540` | A heal now, plus a one-time return in the fight. The locket only opens the wall. No weapon. |
| C58 | Area 6: the ghost speaks to Reptin almost like a mother ("Child of the wolf... a gift") | CC 884-887 | Compressed | `023_Chapter5.rb:524-527` | "Your wolf isn't a curse. It's a charge." |
| C59 | Area 6: prophecy ("When the howl of the wolf meets the cry of the innocent under the crone's shadow...") | CC 892-896 | Missing | `023_Chapter5.rb:535` ("Time is a wheel, dear") instead | – |
| C60 | Area 6: the ghost fades; the body crumbles to dust; lichen dims | CC 896-899 | Full | `023_Chapter5.rb:106-107` (bier_after) | – |
| C61 | Area 6 / finale: hint about the troll's weakness ("only flame...") | CC 1066-1068 | Missing (optional in book) | – | – |
| C62 | Area 7: the Heart (four ice spires, an orb of blood-red ice, a heartbeat, crimson and cobalt veins) | CC 912-920 | Full | `023_Chapter5.rb:108-109, 551-553` | Verbatim. |
| C63 | Area 7: yeti cub chained between pillars, gagged, eyes pleading | CC 921-924 | Full | `023_Chapter5.rb:112, 554`; `tools/build_ch5.rb:199-202` | – |
| C64 | Area 7: the hag's look (bruise-coloured skin, necklace of baby teeth, black staff with frozen sprites) | CC 925-931 | Compressed | `023_Chapter5.rb:563, 605` | Only "no longer hiding" and "her staff". |
| C65 | Area 7: iron cauldron of ritual brew on blue flames | CC 932-934 | Missing | – | – |
| C66 | Area 7: winter wolf (possibly one of the Dougan's Hole wolves) and an ice troll | CC 935-938, 974-979 | Full | `023_Chapter5.rb:563-565, 588-596`; `tools/build_ch5.rb:207-214` | The wolf is Kanan from *Holed Up*, following the module's own suggestion. |
| C67 | Area 7: greeting and ultimatum ("A life for a life... I always keep my end of a bargain... will you honor our deal?") | CC 939-959 | Compressed | `023_Chapter5.rb:566-572` | "A life for a life" is kept. The deal can't be referenced because none was made (C2). |
| C68 | Area 7: the hag shows her power by half pulling Reptin's curse out | CC 943-946 | Missing | – | – |
| C69 | Area 7: the choice (refuse, offer yourself, or agree) | CC 988-1007 | Compressed | `023_Chapter5.rb:573-585` | Refuse, Reptin offers himself, or show the acorn. You can't agree. See gap 2. |
| C70 | Area 7: "I shall be the new Winter, not so fickle as Auril!"; taunting their morals | CC 1000-1003 | Compressed | `023_Chapter5.rb:571` | The first line is verbatim. The "one little monster" taunt is missing. |
| C71 | Area 7: the hag's tactics (spells from range, flying on her staff, illusions) | CC 1010-1022 | Missing | – | It's a standard trainer battle. |
| C72 | Area 7: the Heart's lair actions (necrotic wave, visions of the dead, life pulse) | CC 1035-1046 | Missing (optional in book) | – | – |
| C73 | Area 7: the cub in danger; freeing it mid-fight | CC 1030-1034, 1071-1077 | Compressed | `023_Chapter5.rb:695-700` (freed afterward) | – |
| C74 | Area 7: at low HP the hag lunges to kill the cub | CC 1046-1050, 1086-1092 | Missing | – | See gap 5. |
| C75 | Area 7: Alberica's ghost intervenes once in the fight | CC 1057-1060 | Full | `023_Chapter5.rb:610-622` | Heals the party. |
| C76 | Area 7: the hag dies; the Heart goes dormant or cracks | CC 1099-1106 | Changed (deliberate) | `023_Chapter5.rb:599-713` | She is caught in her shattering mirrors ("Mirrors always remember"). The Heart goes pale and warm, with a seed of light. Follows the Rootspire timeline (`drive/rootspire.md:28`). |
| C77 | Aftermath: the cub is saved and needs a home (yeti den or druids) | CC 1111-1128, 1194-1196 | Full | `023_Chapter5.rb:695-707` | Reunited with its mother, or kept as a Yetot. |
| C78 | Aftermath: dark ending (cub dies, winter breaks, Reptin cured) | CC 1147-1152, 1198-1215 | Missing | – | Can't be reached. See gap 2. |
| C79 | Aftermath: Reptin embraces his guardianship and may stay as warden | CC 1119-1124, 1190-1194 | Full | `023_Chapter5.rb:530-533, 134` | "I'll keep watch." |
| C80 | Treasure and epilogue (Staff of Frost, opals, scroll, pelt, Codex, a shard of the Heart, the locket as Bless; dawn, a wildflower, wolf howls; Speaker Dermot thanks them; the song "Glimmer in the Chasm"; Auril's feather) | CC 1133-1145, 1153-1324 | Changed (deliberate) | `023_Chapter5.rb:708-762` | All loot dropped. The epilogue is replaced by the fall through time (Verdant Reversal). Durmoot's thanks come earlier (`022_Chapter4.rb:889-893`). |

### 3b. Rime of the Frostmaiden: towns and quests the game uses

| # | Item | Source lines | Status | Where in game | Notes |
|---|---|---|---|---|---|
| **Targos** | | | | | |
| R1 | Walled town; wall runs into the lake; frozen harbour; biggest fishing fleet | R 4911-4925 | Full | `tools/build_act1.rb:55-125`; `006_Dialogue.rb:31-32` | – |
| R2 | Naerth Maxildanarr: Luskan rogue, Zhentarim, bought his way to speaker at the Luskan Arms | R 4926-4953 | Changed | `007_Story.rb:298-380`; `006_Dialogue.rb:105-135` | Accurate background. Becomes Gym 1 and the lottery enforcer ("Everyone owes me something"). |
| R3 | Skath, tiefling Zhent mercenary and militia leader | R 4951-4953 | Full | `006_Dialogue.rb:114-115`; `tools/build_act1.rb:194` | – |
| R4 | Luskan Arms: oldest inn, rotten floors, rats, Owenn Tarsenel, Naerth's flying snakes | R 4947-4971 | Compressed | `tools/build_act1.rb:188-198` | A Zhent den with Marek. Proprietor, rats and snakes gone. |
| R5 | Three Flags Sailing: "Ma" Ethen Yarbroul fussing over fishers; rumours | R 4975-4997 | Compressed | `007_Story.rb:136-208, 271-296`; `006_Dialogue.rb:57-64` | Used for the party meeting. The barkeep is generic. |
| R6 | Triglio, general store (Jestin Hunrae; sells snowshoes) | R 4999-5021 | Compressed | `tools/build_act1.rb:116, 130`; snowshoes from a trapper `017_TargosExtras.rb:97-113` | – |
| R7 | Sacrifice to Auril: humanoid lottery in Bryn Shander, Easthaven and Targos only | R 1040-1060, 4959 | Changed | `006_Dialogue.rb:28-30` ("each of the Ten-Towns draws a name"); `007_Story.rb:306` | Over-generalised. The book's food and warmth sacrifices for the smaller towns never appear. |
| R8 | *Mountain Climb* (Boy the sled dog, Keegan and Garret Velryn, Kelvin's Cairn) | R 4977-5050+ | Missing (optional in book) | – | See gap 12. |
| **Bryn Shander** | | | | | |
| R9 | Walled hill town; gates shut when it's dark ("more often than not") | R 1727-1746 | Full | `014_Chapter2.rb:117` ("Gates close at dark. It is always dark.") | – |
| R10 | Speaker Duvessa Shane: lawful good, young, head of the Council | R 1752-1756 | Changed | `014_Chapter2.rb:128-129, 202-205, 657-688` | Turned into a cornered Zhentarim debtor and Gym 2. Not in the book. |
| R11 | Sheriff Markham Southwell | R 1756 | Missing (optional in book) | – | – |
| R12 | Council of Speakers meets at the Council Hall | R 1028-1035 | Changed | `014_Chapter2.rb:153-154` | "Doors chained; hasn't met since the Rime began." |
| R13 | Blackiron Blades (Garn the Hammer, Elza) | R 1754-1768 | Compressed | `tools/build_ch2.rb:240, 295` | A shop only. |
| R14 | House of the Morninglord: Mishann, Amaunator | R 1770-1786 | Full | `014_Chapter2.rb:314-336`; `tools/build_ch2.rb:282` | The golden acorn is a campaign addition. |
| R15 | Copper Knobberknocker and the Black Cabin / Macreadus hook | R 1787-1805 | Missing (optional in book) | – | – |
| R16 | The Northlook (Scramsax; credit at interest; Ol' Bitey) | R 1807-1840 | Compressed | `014_Chapter2.rb:200-201, 498-510`; `tools/build_ch2.rb:302-306` | An inn with a Zhent "back table". Scramsax and the fish are gone. |
| R17 | *Foaming Mugs* (Hruna, Korux, Storn; Oobok; a yeti; a blizzard; Izobai's goblins and polar bears) | R 1842-1963 | Missing (optional in book) | – | See gap 9. |
| R18 | Humanoid lottery: drawn at sundown before the new moon; the victim stripped and left to die | R 1040-1049, 1764 | Changed (deliberate) | `014_Chapter2.rb:479-651` | Played as lottery night: Ilda Weaverson, and Alberica's pendant memory breaks the crowd's despair (matches `drive/session_log.md:27`). Auril marks Alberica. |
| R19 | "Accusations of rigged lotteries are common" | R 1048-1049 | Full | `017_TargosExtras.rb:228-235`; `014_Chapter2.rb:487-492, 564-566` | Kip's list of names never drawn. Nicely done. |
| **Cold-Hearted Killer (Sephek)** | | | | | |
| R20 | Hlin Trollbane hires the party (100 gp) | R 1090-1207 | Missing | – | `Hlin` doesn't appear in any script. See gap 4. |
| R21 | Torrga Icevein and the Torg's caravan (stolen goods, a corpse with a bounty) | R 1214-1289 | Missing | – | – |
| R22 | Three ice-dagger murders (Easthaven trapper, Targos shipbuilder, Bryn Shander glassblower) | R 1118-1124 | Compressed | `006_Dialogue.rb:83-85, 100-101`; `014_Chapter2.rb:179-180` | Only rumours of a shirtsleeved killer. |
| R23 | Motive: kills people who bribe their names out of the lottery | R 1164-1170, 1266-1271 | Changed (deliberate) | `007_Story.rb:308-310`; `014_Chapter2.rb:621-637` | Auril's agent hunting Shimmer as her "vessel". Kip's rigged list is never tied to him. |
| R24 | Appearance: no coat, no body hair, eyes like a frozen lake, unbothered by cold | R 1176-1177, 1215-1232, 1254-1256 | Full | `014_Chapter2.rb:623-625`; `015_Chapter3.rb:138-140, 516-517` | Snow doesn't settle on him and his footprints don't stay. |
| R25 | True nature: shipwrecked mariner possessed by a frost druid's spirit | R 1257-1265 | Missing | – | Never revealed anywhere in the game. |
| R26 | Cold Regeneration ("dies only if he starts his turn at 0 HP and doesn't regenerate"); ice weapons | R 1185-1208 | Changed (deliberate) | `015_Chapter3.rb:531-541, 211-212` | Frozen in ice, not dead, and returns in Act III. Fits the spirit of his regeneration. |
| R27 | Sephek, Shimmer and the Glade sacrifice ("For them") | campaign (not in RotF) | Changed (deliberate) | `015_Chapter3.rb:349-410, 508-549` | The campaign's rewrite, as the brief describes. |
| **Lonelywood** | | | | | |
| R28 | A town of shady pasts; "don't dredge up anyone's past" | R 4475-4485 | Full | `015_Chapter3.rb:309` (Nimsy's house rule) | – |
| R29 | Speaker Nimsy Huddle: heated attic, halfling-shaped cookies | R 4492-4498, 4521-4525 | Full | `015_Chapter3.rb:302-324`; `tools/build_ch3.rb:150` | – |
| R30 | Scoop and four halfling children with wooden swords | R 4554-4571 | Full | `015_Chapter3.rb:152-162`; `tools/build_ch3.rb:132, 151-152` | – |
| R31 | Happy Scrimshander: Iriskree Harrowhill, retired assassin | R 4493-4502 | Full | `015_Chapter3.rb:191`; `tools/build_ch3.rb:167` | Runs the town shop. Her past is hinted at. |
| R32 | Lucky Liar: tall tales; Danae Xotal, a Thayan spy for Szass Tam | R 4504-4525 | Full | `015_Chapter3.rb:185-190, 257-258, 268` | Thay hinted at through Alerion. |
| R33 | Ramshackle: closed inn; DeGrootz "hanged himself" | R 4575-4585 | Full | `015_Chapter3.rb:150-151` | – |
| R34 | *The White Moose* (awakened moose, Ravisin the frost druid, elven tomb, moon mirror) | R 4587-4900 | Missing (optional in book) | Rumours only: `015_Chapter3.rb:78, 136, 164, 184` | See gap 8. |
| R35 | Getting there: Lonelywood connects only to Termalaine | R 4513-4518 | Changed | `014_Chapter2.rb:163`; `015_Chapter3.rb:133` | Reached from Bryn Shander's north gate. Termalaine is skipped. |
| **Good Mead** | | | | | |
| R36 | Chultan and Vilhon founders; carvings of dinosaurs and serpents; wyvern eaves; bees in a heated hall | R 4071-4078, 4097-4107 | Full | `022_Chapter4.rb:158-160, 177-178, 405-406` | Dinosaurs dropped. |
| R37 | Verbeeg steals three casks; Speaker Kendrick killed; five militia missing | R 4080-4093, 4160-4164 | Full | `022_Chapter4.rb:147-149, 165-166` | – |
| R38 | Shrine of the Flaming Sword (Tempus), Kendrick's body on the table | R 4138-4155 | Full | `022_Chapter4.rb:167-169` | – |
| R39 | Redwaters named for the old Good Mead / Dougan's Hole feud | R 4149-4152 | Full | `022_Chapter4.rb:187, 223`; `016_TrainerLines.rb:55` | – |
| R40 | Fef Moryn: trapper with a fox in his trap; militia clubbed (by the ogre) | R 4191-4203 | Full | `022_Chapter4.rb:171-174`; `tools/build_ch4.rb:131-132` | You can't buy the fox. |
| R41 | *The Mead Must Flow* (trail, chwinga and fox, the verbeeg lair with Duhg, the ogre "Friend", the bear Yogobor, livestock, the Silvanus pool, a cursed tomb, Gahg's basket) | R 4157-4459 | Missing (optional in book) | – | See gap 7. |
| R42 | New town speaker: Olivessa versus Shandar; Olivessa asks a PC to run | R 4109-4131, 4398-4444 | Compressed | `022_Chapter4.rb:161-164, 179-181` | Both are there. No election. |
| R43 | Shandar blackmailed by Naerth's Zhentarim; staged thug "rescue" | R 4121-4127, 4445-4459 | Compressed | `022_Chapter4.rb:156, 161-162` | Hinted at only. |
| **Dougan's Hole and *Holed Up*** | | | | | |
| R44 | Insular, inbred, misshapen ears and pointed teeth; ~50 people; an unsafe pier | R 3069-3087 | Full | `022_Chapter4.rb:198-208, 228, 283-284, 337, 705` | – |
| R45 | Dark humanoid shapes standing still on the ice | R 3085-3087 | Changed | `022_Chapter4.rb:416-422, 216-221, 258-271, 875` | Ambience in the book. Here they're the hag's frozen victims, who thaw. The Targos widow's husband is one of them (`017_TargosExtras.rb:31-37`). A good invention that uses CC's backstory. |
| R46 | Speaker Edgra Durmoot: stubborn, believes the teens are dead, gives no help | R 3094-3100, 3141-3146 | Full | `022_Chapter4.rb:437-457` | Also made Gym 3, and given a husband lost to the ice (an invention). |
| R47 | Twenty Stones of Thruun (nineteen menhirs and a centre stone; Thruun's legend) | R 3093-3105, 3126-3137 | Full | `022_Chapter4.rb:199-200, 194`; `tools/build_ch4.rb:327` | Becomes the hag's arena. |
| R48 | Townsfolk chorus ("big as horses... a mighty vocab'lary... By Thruun's Stones... king's ransom") | R 3183-3202 | Full | `022_Chapter4.rb:202-208` | Near verbatim. |
| R49 | Militia: nobody leaves town | R 3102-3104, 3201-3202 | Full | `022_Chapter4.rb:209-215` | – |
| R50 | Koran and Kanan: good wolf / bad wolf, Garagai lie, the leg he forgets he's limping on | R 3148-3196 | Changed | `022_Chapter4.rb:508-529` | The limp tell is kept. The Garagai lie becomes "my brother's gone mad". No bad-wolf threat. The header at `:14-15` still promises a frost-giant story. See gap 6. |
| R51 | Norsu: awakened, evil, the master behind the extortion; the wolves expect him to kill the party | R 3108-3125, 3210-3222 | Changed | `022_Chapter4.rb:612-658` | Only grieving. The extortion is the wolves' own hunger ("The Dale is very hungry"). |
| R52 | Crossing the tundra: blizzard; a starving pack of ordinary wolves | R 3198-3218 | Changed (deliberate) | `022_Chapter4.rb:531-569` | Feeding the pack, and the she-wolf's bite as the origin of Reptin's lycanthropy (`drive/session_log.md:41-43`). |
| R53 | Approaching the lodge: three entrances; the wolves nudge the party toward L4 and wait outside | R 3220-3238 | Compressed | `tools/build_ch4.rb:445-446`; `022_Chapter4.rb:596-605` | Main door and the remorhaz tunnel only. No nudging. |
| R54 | L2 flensing chamber: whale, giant paring knife, stone chest with a scrimshaw goat | R 3243-3260 | Full | `022_Chapter4.rb:248-250, 671-676` | – |
| R55 | L3 cage: Silja and Finn as described; slats, lock, squealing hinges, oil | R 3243-3272 | Full | `022_Chapter4.rb:698-745` | Heating the slats and picking the lock are missing. |
| R56 | L4 icicle-choked corridor (Stealth) | R 3276-3291 | Compressed | `022_Chapter4.rb:599-601` | Description only. |
| R57 | L5 Garagai's tomb: Norsu calmed by claiming friendship (Deception) or vowing vengeance (Persuasion); a prayer | R 3293-3313 | Full | `022_Chapter4.rb:612-658` | Both routes and the prayer are present. |
| R58 | Ice throne with the Giant rune for "ice" (summons a blizzard) | R 3301-3335 | Compressed | `022_Chapter4.rb:246-247` | Flavour only. |
| R59 | L6 war room: chwinga turned to stone; kobolds Holgi, Snorp and Zilbo | R 3336-3362 | Full | `022_Chapter4.rb:251-252, 678-696` | – |
| R60 | L7 Garagai's bedroll | R 3368-3378 | Missing (optional in book) | – | Trivial. |
| R61 | L8 whale oil, remorhaz tunnel, thrym | R 3318-3335 | Full | `022_Chapter4.rb:253-255, 660-669, 740` | – |
| R62 | Sneaking out; the wolves attack on the way home; kill one and the other flees | R 3336-3351 | Changed | `022_Chapter4.rb:748-767` | Both flee south to the chasm, which sets up Kanan as the hag's minion (C66). |
| R63 | Reunion with Hilda; boots of the winterlands (her husband was her older brother) | R 3353-3369 | Compressed | `022_Chapter4.rb:489-502` | Two Revives, "my brother's". The joke and the boots are gone. |
| R64 | Sacrifice to Auril: warmth (Dougan's Hole, Good Mead), food (Lonelywood) | R 1050-1059, 3111, 4107, 4508 | Missing (optional in book) | – | Merged into R7's generalisation. |

### Internal inconsistencies noticed while auditing

These matter because the owner asked me to look for shortcuts:
- `022_Chapter4.rb:14-15`: the header says Koran tells a story about a cruel frost giant. The dialogue at `:510` doesn't.
- `023_Chapter5.rb:135`: Reptin refers to a promise the hag never made (C2).
- `014_Chapter2.rb:151-152, 167-168`: the Bryn Shander east guards say Easthaven comes before Dougan's Hole. The Eastway sign (`022_Chapter4.rb:143`) and RotF (R 4110-4113) route through Good Mead, and the game closes the Easthaven road anyway.
- `007_Story.rb:368`: says Bryn Shander is "north along the road" from Targos. In RotF it lies south-east, 2 hours away (R 4940, 5061). The Targos gate guard also says "north" (`014_Chapter2.rb:110`).
- `006_Dialogue.rb:25` ("the sun crawls over the mountains for a few minutes a day") contradicts `007_Story.rb:118` ("the sky has no sun in it at all") and RotF's "the sun no longer appears above the mountains" (R 1080).
