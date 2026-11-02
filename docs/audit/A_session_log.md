# Audit A: `sources/drive/session_log.md` vs. Pokémon Frost & Thaw

Source: `/home/claude/frost-thaw/sources/drive/session_log.md` (2,681 lines, all read).
Game: `game/Data/Scripts/998_FrostThaw/*.rb` and `tools/build_*.rb` (read only; nothing modified).

## 0. What this file actually is (read first)

The file is **not a session-by-session log**. It has two tabs:

- **Tab 1 (lines 1–104): "Dream Visions of the Bloom Guard".** Narrative prep: one vision per Herald (Alerion, Meat Meat, Alberica, Glimmer, Reptin), "Auril's Whisper to Alberica", and a set of recurring "Omens of Auril's Claim on Alberica", with GM notes on how to use them.
- **Tab 2 (lines 108–2681): "The Cackling Chasm".** A prewritten, *branching* dungeon module: seven keyed areas, optional encounters, and three alternative endings. It reads as AI-drafted; line 2386 even says "Now let's assemble all that into a flowing conclusion." It was written for a different party framing: Reptin is an "NPC ally" (l.326), and **Alberica is a dead human High Priestess ghost** (l.1694, 1702), even though Tab 1 makes Alberica a living PC.

So this file can't show which branches were actually played at the table. I audited every story element it *describes*. Where the module offers options ("optional", "DM's choice", alternative endings), I mark that in Notes and don't count an un-adapted optional branch as a serious gap. The game's Chapter 5 header (`023_Chapter5.rb:1-24`) also cites other sources this file doesn't contain ("Frost Hag boss notes" and the Rootspire timeline's Verdant Reversal). Several "Changed" items below (the mirrors, the acorn, the Reversal) come from those, not from invention.

## 1. Summary

| Status | Count |
|---|---|
| Full | 56 |
| Compressed | 25 |
| Changed | 23 (1 of them approved) |
| Missing | 44 (1 is a play-order risk; about 12 are loot or one-line atmosphere) |
| N/A (alternative branch not taken / mechanics) | 6 |
| **Total rows** | **154** |

Of the 148 rows that can be judged, 104 (about 70%) are in the game in some form, and 56 (about 38%) are fully faithful.

**Overall judgement.**

- **Tab 2, the Cackling Chasm (the bulk of the file), is adapted very thoroughly.** It is not a shortcut adaptation.
  - Chapter 5 (`023_Chapter5.rb`, maps in `tools/build_ch5.rb`) walks all seven keyed areas in order, and each has a physical map and events.
  - Its encounters are all there: the illusory crone at the mouth, the icefall, the ice mephits, the locket, the feast hall (dead yeti with heart cut out, swaddling in his fist, tracks), and the split path (light and child's voice left, weeping right).
  - So are the set pieces: the pit with ghouls and "SHE LIES / DON'T TRUST THE LIGHT", the bridge (frayed rope, chanting, falling ice, gust), the ghost on the far ledge, and the warm nook.
  - The Guardian's Gate works as a real life/death offering puzzle, with skeleton guardians when you get it wrong. A seam leads to a hidden sanctum, where the ghost explains the werewolf wardens and Reptin chooses to keep his charge.
  - The Heart chamber has the crystal, the cub in chains, and the hag with her winter wolf and ice troll. The winter wolf is cleverly made Kanan from Ch4, which the module itself suggests (l.1994-1996). "A life for a life", Reptin's "Take me instead", "the new Winter, not so fickle as Auril", and the cub joining as a party Pokémon are all in.
  - Much boxed text is used almost verbatim.
- **What Tab 2 lost** is mostly lore and consequence, not set pieces:
  - The hag's actual *bargain* (cure Reptin and end winter) is never offered on-screen, and one line in the game refers to that unshown promise.
  - The Order's history (the gnoll/Yeenoghu fall, the ghost's self-sacrifice) is gone.
  - The ghost's warnings and prophecy, the hag's last-ditch try at the cub, and the whole legacy/epilogue section are gone.
  - The mother yeti's tragedy is softened.
- **Tab 1 is covered much more thinly.**
  - Every vision exists, in `026_Rootspire.rb:887-918`, and Auril's Whisper is in `037_Chapter11.rb:37-80`.
  - But each vision is cut to one to three lines: the title and the setting. What's gone is what makes them personal: each Herald's two possible fates, Alerion's past life as Shimmer's shield, Meat Meat feeding Razzy acorns and flowers, Alberica reliving Bryn Shander's square, and Reptin's mercy to the wolves.
  - The five recurring **Omens of Auril's Claim**, written as a device for every session, are entirely absent.
  - The Glimmer vision can also be skipped by play order (see gap 4).

Counting rows, about 70% of the slice is in the game in some form. For Tab 2 alone the figure is higher; for Tab 1 it is lower. Weighted by story importance, the Tab 1 losses matter more than their line count suggests, because they carry each Herald's personal arc.

## 2. Biggest gaps (ranked)

1. **The hag's bargain is never offered.**
   - Source: l.132-142, 202-208, 1936-1962, 2022-2046.
   - In the module, the whole adventure turns on her offer to end the Everlasting Rime and cure Reptin. At the Heart she tugs at the curse, says "I always keep my end of a bargain", and asks "will you honor our deal?".
   - In the game she never makes the offer (Ch4 `022_Chapter4.rb:808-839` and Ch5 `023_Chapter5.rb:559-586`). Yet Reptin's chat says "She promised to take it away. The hunger, the moon" (`023_Chapter5.rb:135`), which points to a promise the player never saw. The moral temptation is also gone.
   - *Suggestion:* add the offer to the Twenty Stones parley (`022_Chapter4.rb:813-826`) or to Reptin's dream at `scene_waste_start` (`023_Chapter5.rb:188-189`). Then add a curse-tug and "honor our deal?" beat to the parley at `023_Chapter5.rb:563-572`.
2. **Omens of Auril's Claim on Alberica are entirely missing.**
   - Source: l.71-103.
   - There are five recurring signs only Alberica perceives: frost along Alerion's shadow, steam curling like vines when Meat Meat laughs, her pendant split between frost and warmth, crackling when Glimmer grieves, and her heartbeat stuttering when Reptin balances life and death. The GM notes add rising paranoia that "turns harsher" if she strays.
   - The game has none of them. The closest is "Nobody else can see her" at `037_Chapter11.rb:52`.
   - *Suggestion:* add Alberica-only one-liners to PARTY_CHAT/`cl(:alberica…)` across Ch6-Ch10 (for example after Alerion's protective choices, or in Meat Meat's Hearth jokes). Escalate them into the Ch11 whisper.
3. **The Bloom Guard visions are cut to titles.**
   - Source: l.7-43.
   - Each vision in the source has a personal memory and two possible fates. The game (`026_Rootspire.rb:888-918`) keeps only the setting and the epithet. Lost:
     - **Alerion:** Shimmer in another age, him as her shield in a past life, Frostina carrying her eyes and the echo of her soul; the fates "sentinel of silence" vs. "buried beneath her wings, name forgotten" (l.11).
     - **Meat Meat:** feeding Razzy acorns and flowers; the fates of a roar cracking mountains vs. cradling his muzzle in flames (l.19).
     - **Alberica:** the Auril rune and the pendant; reliving Bryn Shander's square; the fates of locking the Dale vs. shattering the vault (l.25-27).
     - **Reptin:** the rations to the starving wolves; guiding the living and the dying vs. the beast tearing free (l.43). The events this vision recalls already exist in the game (wolves fed, the bite "burns like fire under snow", `022_Chapter4.rb:540-567`), so the callback is free.
   - *Suggestion:* expand each branch of `bloom_guard_visions` by two to four lines.
4. **The Glimmer/Sparkbearer vision can be skipped, and it is thin.**
   - Source: l.31-35.
   - `bloom_guard_visions` only plays the Brightmane branch when `with_or_is?(:shade)` (`026_Rootspire.rb:913`). There is no `:glimmer` branch.
   - The Rift (`lumen_shard` → `glimmer_arrives`) and Lumin's orb (`twin_orb`) are both on the Canopy map (`build_ch6b.rb:102-107`), and both open on `twins_met`. A player who goes to the Rift first swaps `:shade` for `:glimmer` (`029_Glimmer.rb:129`) and never sees this vision.
   - Even when it plays, it has lost "my light is yours", the grief-as-flame theme, and both fates (igniting the wyrmlings vs. the torch guttering to ash).
   - *Suggestion:* add a `with_or_is?(:glimmer)` branch, and use the fuller text.
5. **The Order of Life and Death's history is missing.**
   - Source: l.658-674, 1708-1738, 1632-1634.
   - Lost: the Order's purpose, the gnolls of Yeenoghu defiling the site, the guardian sealing the sanctum and giving her life to the wards, the "Children of the Wolf", and the feast hall's blood runes (Yeenoghu's sign over a druidic emblem).
   - The game keeps only "old druids… kept something that keeps the world turning" (`023_Chapter5.rb:95-96`) and "the wolves were the wardens" (`023_Chapter5.rb:524-527`).
   - *Suggestion:* add an inspectable blood-rune wall in the feast hall (`build_ch5.rb` near the bone pile at 11,21), plus two or three ghost lines in `order_ghost` (`023_Chapter5.rb:520-527`).
6. **The ghost's warnings and prophecy are missing, so the solution isn't foreshadowed.**
   - Source: l.1750-1792, 1834-1850.
   - Lost: her plea to save the yeti child; "soul-debt, death unbalanced"; the hint that "blood of one cursed or willingly given life" could satisfy the Heart; "only flame can quell the ice-eater"; and the prophecy "When the howl of the wolf meets the cry of the innocent under the crone's shadow, the Wheel… turns anew."
   - In the game, the acorn "third way" is justified only by "Shimmer showed us" (`023_Chapter5.rb:636`), with no hint inside the chasm.
   - *Suggestion:* give the ghost one cryptic line pointing at "a life not yet begun" and the prophecy (`023_Chapter5.rb:535`).
7. **The hag's finale is cut down.**
   - Source: l.1910-1918, 2042-2046, 2126-2136, 2212-2228.
   - Missing: the cauldron of ritual brew; her staff hung with frozen sprites and her necklace of baby teeth; the morality taunt ("spare one little monster? How… precious. How weak."); and her spiteful last lunge to cut the cub's throat. The mirror retreat replaces the lunge.
   - *Suggestion:* add the taunt to the parley (`023_Chapter5.rb:569-572`). Add a "she goes for the cub" beat between the trainer battle and the Reflection (`023_Chapter5.rb:603-609`).
8. **The Cackling Chasm's aftermath and legacy are missing.**
   - Source: l.2556-2626.
   - Lost: the wildflower at the chasm mouth, watchful wolf howls, the Speaker of Dougan's Hole thanking them *for the chasm*, the Bryn Shander song "Glimmer in the Chasm", Reptin sending word by wolf or raven, the party as new Order wardens, Auril's snowy-owl feather marking them, the shared dream of Alberica and a glowing child saying "Balance is restored… for now", and the wolf-and-bloom ice carving.
   - All of it is pre-empted by the Verdant Reversal fall (`023_Chapter5.rb:726-762`). Only "Many years later. The Cackling Chasm" (`039_Chapter13.rb:592-605`) echoes the legacy.
   - *Suggestion:* add one or two "falling" panels, or Act II arrival lines: the wildflower, the owl feather on a sill, the carving found in a pack.
9. **Reptin's resolution as warden is compressed.**
   - Source: l.2266-2312, 2422-2430, 2582-2586.
   - In the source, the Heart recognises Reptin and frees him of the involuntary rage while he keeps the power. He may stay behind to guard it, and the party decides to *leave the Heart intact*.
   - In the game he says "I'll keep it… somebody has to hold it" (`023_Chapter5.rb:530-532`) and "I'll keep watch" (`:134`), but nothing reacts to him. The payoff comes only much later, when he becomes a steward of the Heartroot (`036_Chapter10.rb:154`).
   - *Suggestion:* add a line in `scene_third_way` where the quieted Heart glows toward Reptin and the wolf in him goes calm.
10. **The hag's temptation of Reptin through the dungeon is compressed.**
    - Source: l.330-336, 422-424.
    - Lost: "Poor boy… all that rage and pain inside you. Give it to me. Let me take it away…" and "Come warm yourself by Granny's fire."
    - The game keeps "I smell the wolf among you. I asked for the wolf" (`023_Chapter5.rb:220`) and "Bring your wolf" (`022_Chapter4.rb:873`).
    - *Suggestion:* whisper lines at the rift or the bridge gust (`023_Chapter5.rb:422-425`), or in Reptin's PARTY_CHAT.
11. **The mother yeti's tragedy is softened (Changed, but it costs the emotional point).**
    - Source: l.676-686, 750-766, 798-806, 832-838.
    - In the module she fights to the death and dies curled over her mate: "an entire yeti family destroyed."
    - In the game she can be calmed by Alberica's lullaby (`023_Chapter5.rb:286-299`, gated on `stood_with_alberica`). Either way she survives, later helps against the troll, and is reunited with her cub.
    - That is a valid choice, but nothing in the game marks it as a deliberate change.
    - *Suggestion:* if fidelity matters, let the *fight* path end in her death, so the cub's reunion only happens on the lullaby path.
12. **The hall of illusions lost its mind games.**
    - Source: l.946-954, 1030-1036, 1180-1186, 1354-1360, 292-296.
    - Lost: reflections in the glass walls that linger and grin; the child crying "Don't leave me! Please!" as you choose right; a small girl's reflection beside you later; the chasm laughing in each character's own loved voices; your name whispered.
    - *Suggestion:* add one line each in `scene_weeping_dark` (`023_Chapter5.rb:386`) and `bridge_crack`.
13. **Treasure that carries story is missing.**
    - Source: l.2512-2554, 1806-1822.
    - Lost: the hag's Black Ice "Graystaff" (with cackling dreams), Alberica's locket whose portrait now *smiles, at peace*, the Druidic Codex (holding the ritual to recharge the Heart), and a never-melting fragment of the Heart.
    - In the game, the locket's description never changes after the ghost rests (`031_StoryItems.rb:21-22`).
    - *Suggestion:* change the locket text once `ghost_blessing` is set, and drop the staff as a key item after `thredra_beaten`.
14. **The locket is never shown to the ghost.**
    - Source: l.574-576, 1708-1710, 1810-1814.
    - In the module, the ghost recognises the locket and it earns her trust, and she enchants it as a talisman.
    - In the game it only warms at the hollow wall (`023_Chapter5.rb:498`). `order_ghost` never checks `order_locket`.
    - *Suggestion:* add an `if flag?(:order_locket)` exchange in `order_ghost` (`023_Chapter5.rb:513-515`).

## 3. Full table

Status key: **Full** / **Compressed** / **Changed** / **Missing** / **N/A**. "(opt)" means the module offers this only as an option or alternative.

### Tab 1: Dream Visions, Auril's Whisper, Omens

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Framing: "Dream Visions of the Bloom Guard" (shared prophetic dreams) | 3 | Changed | 026_Rootspire.rb:849-880, 887-918 | Delivered as visions from Lumin's twin orb in Rootspire, not dreams. "Bloom Guard" name not used; Lumin says "Dragon Warriors". |
| Alerion: black forest, sky without dawn, Frostina's moon-eyes, "Guardian of the dark half… keeper of stillness, of endings that prepare the wheel to turn" | 9 | Full | 026_Rootspire.rb:891-895 | Near-verbatim. |
| Alerion: past life as Shimmer's shield; bond reborn through Frostina, who "carried Shimmer's eyes and the echo of her soul" | 11 | Compressed | 037_Chapter11.rb:163; 038_Chapter12.rb:261; 029_Glimmer.rb:33 | Frostina-holds-Shimmer is in the game (heart, four-note hum). Alerion's *past-life* bond with Shimmer is missing. |
| Alerion: two fates (sentinel at the ruins of the north, sword in the snow, vs. buried beneath her wings, name forgotten) | 11 | Missing | — | |
| Meat Meat: meadow through ice; Razzy reborn as Razzilith; "Guardian of the light half… renewal, flame, and song. Without you, the wheel rots" | 17 | Full | 026_Rootspire.rb:897-902 | Verbatim. |
| Meat Meat: tenderness of feeding him acorns and flowers; the laughter she gave him | 19 | Missing | — | No acorn/flower feeding of Razzy anywhere (the golden acorn is Reptin's, 014_Chapter2.rb:315-329). |
| Meat Meat: two futures (thawed earth and roar vs. cradling his muzzle as flames consume the meadow) | 19 | Missing | — | |
| Alberica: Vault of the North, half rime, half gold; faces crying to be remembered; "Keeper of memory… without memory, the wheel does not turn" | 25 | Full | 026_Rootspire.rb:903-906 | |
| Alberica: Auril's rune burning on her chest, pendant pulsing brightest at the vault | 25 | Compressed | 037_Chapter11.rb:46-47; 015_Chapter3.rb:403-404 | Rune exists elsewhere; pendant is lost in Ch3 in the game, so absent from the vision. |
| Alberica: relives Bryn Shander's square, pouring warmth and memory from the pendant into the crowd | 27 | Compressed | 014_Chapter2.rb:552-562; 023_Chapter5.rb:289 | The square event is played in Ch2 and called back by the lullaby, but not in the vision. |
| Alberica: two paths (bear Auril's mark and lock the Dale vs. shatter the vault with memory) | 27 | Missing | — | |
| Glimmer: Brightmane on a plain of stars, mane aflame, horn like dawn | 33 | Changed (approved) | 026_Rootspire.rb:913-916; 029_Glimmer.rb:69-81 | Approved: Shade/Glimmer via Brightmane's mirror. Vision appears in both places. |
| Glimmer: Brightmane's hooves shatter frost and flowers spring up; "Sparkbearer… my light is yours" | 33 | Compressed | 029_Glimmer.rb:2, 109 | "Sparkbearer" only in a header comment; "She says I'm a fire now". |
| Glimmer: "Shimmer gave the ice of her heart so that others might live; carry her torch" | 33 | Full | 026_Rootspire.rb:915; 029_Glimmer.rb:122-124 | |
| Glimmer: Shimmer's body became the Verdant Reversal's seed | 35 | Changed | 023_Chapter5.rb:636-663; 031_StoryItems.rb:13-16 | The seed is the golden acorn; Shimmer's heart goes into the Frost Egg and Frostina. Shimmer stays the *inspiration* ("Shimmer showed us"). |
| Glimmer: fate one, igniting the wyrmlings with the spark of life | 35 | Compressed | 029_Glimmer.rb:8, 78-81 | Shade gave Brightmane's horn to the egg in Act I, but it's only told, not shown as this fate. |
| Glimmer: fate two, despair dims the torch; grief burning brighter than love | 35 | Missing | — | (Glimmer's final death at the Forge is approved.) |
| Glimmer vision can be skipped by play order | 31-35 | Missing (risk) | 026_Rootspire.rb:913; 029_Glimmer.rb:129; build_ch6b.rb:102-107 | Only `:shade` gets this branch, with no `:glimmer` branch; Rift-before-orb skips it. |
| Reptin: graveyard, roots, blood-red flowers, wolves "neither cruel nor kind"; "Warden… stillness is the true enemy of the wheel" | 41 | Full | 026_Rootspire.rb:907-912 | |
| Reptin: wolf-claw wound "seared anew, fire beneath snow" | 41 | Compressed | 022_Chapter4.rb:562-567 ("burns like fire under snow") | Present as the Ch4 event, not recalled in the vision. |
| Reptin: offered his rations to the starving wolves; bound to mercy | 43 | Compressed | 022_Chapter4.rb:540-559 | Played as a choice in Ch4; vision omits it. |
| Reptin: two visions (guiding the living and dying vs. the beast tearing free and wyrmlings trembling) | 43 | Missing | — | |
| Auril's Whisper to Alberica (frozen moment; the wheel and the ones who bind it; five couplets; "You are my vessel… the wheel turns for me") | 47-69 | Compressed | 037_Chapter11.rb:37-80 | Strong scene. "The spark carries grief…" becomes "The spark is spent" (consequence of the approved Glimmer death). "They cannot escape their fates" becomes "Come and be beautiful forever". |
| Omen: frost blooming along Alerion's shadow | 73-74 | Missing | — | |
| Omen: Alberica's breath steams like vines when Meat Meat laughs | 76-77 | Missing | — | |
| Omen: pendant split frost/warm, normal when others look | 79-80 | Missing | — | Pendant gone after Ch3 in the game. |
| Omen: crackling like fire smothered in snow; "His grief burns too hot. Watch him." | 82-84 | Missing | — | Similar wording "Watch him" at 026_Rootspire.rb:423 is about a different stranger. |
| Omen: Alberica's heartbeat slows and quickens when Reptin balances life and death | 86-87 | Missing | — | |
| Omens' narrative use: constant Auril presence, paranoia, harsher omens if she strays | 92-103 | Missing | — | No escalating Auril-sign system before Ch11. |

### Tab 2: The Cackling Chasm (background, hooks, framing)

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Hag (Bheur, servant of Auril) once deep-froze Dougan's Hole; heroes thwarted her and she survived | 124-130 | Full | 022_Chapter4.rb:6-22, 790-897 | Night at the Twenty Stones; frozen victims thaw; she flees south. |
| Hag's offer: break Auril's curse **and** cure Reptin | 132-142 | Missing | 023_Chapter5.rb:135 (dangling reference) | Gap 1. |
| Order of Life and Death; werewolves as sworn wardens; Reptin's curse marks him as one | 144-156 | Full | 023_Chapter5.rb:95-96, 524-532 | |
| Heart of the Chasm absorbs life to counter death; needs an innocent's blood; hag procured a yeti baby | 158-174 | Changed | 023_Chapter5.rb:521-522, 567-572 | Heart becomes "the last living root of the World Tree"; the hag would drain it to *become winter*. The yeti-baby sacrifice is kept. |
| Hag's hidden truths (cure removes a warden; the altar only weakens the curse temporarily and empowers her) | 176-186 | Compressed | 023_Chapter5.rb:522, 524-527 | "Become winter herself" and "a charge" are conveyed; "temporary" and "empowers her" are not. |
| Hook: A Hag's Bargain (messenger or dream offering a parley) | 202-208 | Changed | 022_Chapter4.rb:808-826, 872-873 | Replaced by her relic "trinkets" and mirror confrontation; "Come and find me in the chasm… Bring your wolf." |
| Hook: Howling in the Dark (hunters' rumours of cackling south of Dougan's Hole) | 210-216 | Full | 022_Chapter4.rb:395, 220; 023_Chapter5.rb:86-91; build_ch5.rb:65,70 | Trapper, sign "TURN BACK. SHE HEARS YOU." |
| Hook: Reptin's Vision (great wolf chained in ice; crone: "Abandon your bond… be free") | 218-226 | Full | 023_Chapter5.rb:186-203 | Near-verbatim, plus an on-screen transformation. |
| Chasm named for gnolls' cackling; hag drove them out | 230-238 | Full | 023_Chapter5.rb:89-91 | "…and the gnolls stopped laughing." |
| Atmosphere: darkness, cold, echoing laughter "from everywhere", scent of rot | 240-288 | Full | 023_Chapter5.rb:217, 405-408; build_ch5.rb:14-17 (music) | |
| Hag's wards: watchful shadows, your name whispered | 288-298 | Missing | — | |
| Tone: escalating horror (King) and mythic gravitas (Jordan) | 300-312 | Compressed | throughout Ch5 | Horror is there; the tone is lighter (lots of banter). |
| Party composition / balance notes | 314-324 | N/A | — | Mechanics. |
| Reptin anxious and guilt-ridden, senses the place calls to his beast | 326-332 | Full | 023_Chapter5.rb:128-131, 190 | "I'm fine. Don't look at me." |
| Hag singles out Reptin and tempts him ("Poor boy… Give it to me") | 332-336 | Compressed | 023_Chapter5.rb:220, 578 | Gap 10. |
| Reptin briefly loses control (fangs, glowing eyes), steadied by the party | 336-342 | Full | 023_Chapter5.rb:184-193, 130 | Becomes a wolf for a breath; Alberica helps him up. |
| Reptin's "Take me instead!" in the finale | 346-352 | Changed | 023_Chapter5.rb:573-578 | A player choice. Hag answers "I'll take you all, wolf. In order" instead of a scornful refusal. |
| If Reptin absent: hag holds a token of him | 354-360 | N/A | — | Branch for an absent Reptin; the game handles Reptin as herald or companion. |

### Area 1: Cave Mouth

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Illusory crone greets them ("So good of you to visit an old woman in her home"), beckons, fades | 384-396 | Full | 023_Chapter5.rb:213-224; 022_Chapter4.rb:813 ("Come in, dearies… Mind your step") | Lantern hanging from nothing is a nice touch. |
| "I smell the wolf among you…" | 422-424 | Full | 023_Chapter5.rb:220 | "Granny's fire" half missing. |
| "Right this way… the cure for all your troubles lies ahead" | 428-430 | Missing | — | Tied to the missing bargain. |
| Icefall trap; "Oops! Mind your head, dearies!" | 464-504 | Full | 023_Chapter5.rb:226-235 | Damage modelled with `hurt_party`. |
| Ice mephit ambush; death burst of shards | 506-548 | Full | 023_Chapter5.rb:236-242 | 2 Snorunt "Ice mephit". |
| Frozen locket: half-sun/half-moon, stern woman's portrait, name "Alberica", faint warmth | 556-576 | Changed | 023_Chapter5.rb:245-260; 031_StoryItems.rb:21 | Portrait is *Alberica herself, older*. A good fix for the module's ghost/PC contradiction. |
| Gnoll femur / frozen corpse in the fallen ice | 590-600 | Compressed | build_ch5.rb:92 (bone tiles); 023_Chapter5.rb:139 | "Bones in the ice"; no reveal. |

### Area 2: Frozen Feast Hall

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Carnage: gnawed bones (goat, fox, human), bloody handprints | 606-618 | Full | 023_Chapter5.rb:315; build_ch5.rb:102-115 | |
| Dead male yeti, chest torn, heart *cut* out | 646-656 | Full | 023_Chapter5.rb:263-264, 283 | "Not bitten out. Cut." |
| Blood runes: "Hunger", "Feast", Yeenoghu's sign over a druidic emblem | 658-674 | Missing | — | Gap 5. |
| Mother yeti, grief-maddened, attacks | 620-628, 676-686 | Full | 023_Chapter5.rb:281-309 | Boss battle (Yetitan). |
| Tears frozen on her fur; calming is "nearly impossible" | 750-766 | Changed | 023_Chapter5.rb:286-302 | Alberica's lullaby *can* calm her (gated on `stood_with_alberica`). Meat Meat: "sad, not mean" (:155). |
| She dies collapsed over her mate; "an entire yeti family destroyed" | 798-806, 832-838 | Changed | 023_Chapter5.rb:304, 98-100, 591, 695-699 | She always survives, helps vs. the troll, and reunites with the cub. Gap 11. |
| Booted footprints and drag marks to the far tunnel | 808-818 | Full | 023_Chapter5.rb:269 | |
| Swaddling (tuft of white fur tied with sinew) in the father's fist | 820-830 | Full | 023_Chapter5.rb:265-271, 284 | |
| Backpack: healing potion | 840-842 | Full | 023_Chapter5.rb:320-324 | Super Potion. |
| Coins, greataxe, necklace of ears | 844-850 | Missing | — | Loot only; low importance. |
| Journal by "Glimmer": met Granny Thredra, deal, "desperate to save Alberica", children's laughter | 852-874 | Changed | 023_Chapter5.rb:320-327 | Unnamed author: "Granny Thredra says she can bring my sister back… SHE LIES." Names the hag. The Glimmer and Alberica names are dropped (both are PCs in the game). |
| Hag's voice after the fight: "such violence… tsk tsk… time is ticking" | 890-896 | Missing | — | |
| Reptin shaken by the blood; "We won't let her do this to anyone else." | 898-906 | Compressed | 023_Chapter5.rb:130, 270-271 | His vow is given to Shade ("Then we take it back"). |
| Bone dust as a takeable "death" offering | 1540-1554 | Full | 023_Chapter5.rb:311-318, 463 | Nicely set up early. |

### Area 3: Hall of Illusions

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Glassy ice corridor; fork; warm light and child's voice left, old woman sobbing right | 912-938 | Full | 023_Chapter5.rb:330-336; build_ch5.rb:116-123 | |
| Reflections that linger and grin | 946-954 | Missing | — | Gap 12. |
| Child's voice says "Glimmer… I'm Glimmer. I'm lost…" | 964-972 | Changed | 023_Chapter5.rb:335-338 | Becomes Shimmer's voice calling Shade. Stronger personal hook; Alerion stops Shade. |
| Clues: colder breeze from the right, looped sobbing, reflections misaligned | 986-1022 | Compressed | 023_Chapter5.rb:387 (claw marks) | Investigation clues not offered; it's a free walk. |
| "Don't leave me! Please!" guilt when choosing right | 1030-1036 | Missing | — | |
| Left path: dead end, gnoll nest, floor collapses into a pit | 1040-1076 | Full | 023_Chapter5.rb:341-348; map 2043 | |
| Ghouls in the pit (or spiders) | 1086-1124 | Full | 023_Chapter5.rb:350-364 | Duskull/Banette "Ghoul". |
| Pit loot: scrimshaw halfling, healing potion | 1126-1136 | Full | 023_Chapter5.rb:366-371 | |
| Blood on the pit wall: "SHE LIES", "DON'T TRUST THE LIGHT" | 1136-1144 | Full | 023_Chapter5.rb:101; build_ch5.rb:133 | |
| Climb out by rope; hag: "Poor little lambs… did you stumble? Heehee!" | 1146-1158 | Full | 023_Chapter5.rb:359-360, 373-380 | |
| Right path: sobbing illusion stops; claw marks show the main route | 1160-1176 | Changed | 023_Chapter5.rb:382-389 | "The weeping is real: the cub's mother, or her echo" (not an illusion). |
| Later hallucination of a small girl's reflection, "Why won't you help me?" | 1178-1186 | Missing | — | |
| Lessons: hag uses emotion; the "Glimmer" name invoked | 1196-1204 | Changed | 023_Chapter5.rb:392-398 | "She knew her name… Hags know everything you're scared of." |

### Area 4: The Frozen Rift

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Ledge over the abyss; narrow icy stone bridge; frayed rope railing; laughter rising to a moan | 1224-1246 | Full | 023_Chapter5.rb:403-411; build_ch5.rb:142-160 | Near-verbatim. |
| Faint chanting beyond | 1248-1252 | Full | 023_Chapter5.rb:408 | |
| CRACK: ice chunk shatters on the bridge, span trembles, laughter mocks | 1254-1262 | Full | 023_Chapter5.rb:413-420 | |
| Crossing tension: roping up, slips, someone nearly falls | 1300-1334 | Compressed | 023_Chapter5.rb:140, 156 | Alerion: "Single file… grab the rope." No slip or near-fall moment. |
| Wind gust forces someone to their knees | 1336-1342 | Full | 023_Chapter5.rb:422-425 | |
| Laughter as personal voices (a mother's laugh, children giggling) | 1354-1360 | Missing | — | |
| Ghostly woman on the far side points urgently, then vanishes (Alberica's spirit warning) | 1388-1400 | Full | 023_Chapter5.rb:426-436 | |
| Optional threats: will-o'-wisps / specter / Coldlight Walker / bats | 1362-1436 | N/A (opt) | 023_Chapter5.rb:58-60 (wild ghosts) | Module says "use sparingly"; not adapted as set pieces. |
| Sheltered nook to rest out of the wind | 1438-1462 | Full | 023_Chapter5.rb:440-450 | A warm fissure; also a respawn point. |

### Area 5: Guardian's Gate

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Arch of skulls and blossoms; door halves carved with wolf and moon / scythe and infant; bowls | 1466-1484 | Full | 023_Chapter5.rb:102-105, 454-456 | |
| Runes "Life for Death, Death for Life"; mind-whisper "Only by the blood of living life…" | 1486-1498, 1512-1516 | Full | 023_Chapter5.rb:104-105, 457-458 | |
| Puzzle: fresh blood in the life bowl, ash/bone (or silence) in the death bowl; stained residue clues | 1520-1580 | Full | 023_Chapter5.rb:459-473 | Supports bone *and* silence; Reptin's bitten hand. |
| Wrong offering: skeleton guardians animate; "Give life… give death…" | 1582-1620 | Full | 023_Chapter5.rb:484-490 | |
| Door opens; vision of a robed woman performing the rite with werewolves | 1622-1636 | Full | 023_Chapter5.rb:475-480 | A *dwarf* woman; "Wolves. Standing with her. Not chained." |
| Hidden seam in the wall leads to the sanctum | 1638-1656 | Full | 023_Chapter5.rb:478, 494-501 | The locket warms near it. |

### Area 6: Hidden Sanctum of Alberica

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Carved chamber, silver lichen, stone bier, preserved corpse in dark green robes | 1662-1680 | Compressed | build_ch5.rb:174-185; 023_Chapter5.rb:106-107, 512-513 | Ghost "waiting" by the bier; the corpse's eyes opening and the spirit rising are cut. |
| Ghost's identity: "I am Alberica, last guardian of the Order" (human High Priestess) | 1692-1706 | Changed | 023_Chapter5.rb:506-536; 039_Chapter13.rb:592-605 | Ghost is Alberica's *future self* (dwarf), revealed by a time-loop bootstrap at the end. A clever resolution of the source's contradiction. |
| Order's history and the Heart's purpose as a last resort | 1712-1716 | Compressed | 023_Chapter5.rb:521-522 | Only "a root of the World Tree". |
| Werewolf wardens ("Children of the Wolf"); "the curse in his blood is no curse… a sacred charge" | 1718-1730 | Full | 023_Chapter5.rb:524-527, 132-133 | "Children of the Wolf" phrase missing. |
| Order's fall: Yeenoghu's gnolls attacked; Alberica sealed the sanctum and sacrificed herself into the wards | 1730-1738 | Missing | — | Gap 5. |
| Hag's scheme: she'll end winter but become "a blight upon both life and death" | 1740-1750 | Changed | 023_Chapter5.rb:522 | "Drain it and become winter herself." |
| Warning that the innocent is a yeti child; plea to "prevent this atrocity"; soul-debt / calamity | 1750-1762 | Missing | — | Gap 6. |
| Reptin's cure vs. duty: his choice, gently given; he chooses to endure | 1762-1774 | Full | 023_Chapter5.rb:524-533 | "You can put it down, or you can carry it." |
| Hint at an alternative: cursed or willingly given blood | 1776-1792 | Missing | — | The acorn third way is not foreshadowed here. |
| Boon: heal / blessing / one-time aid | 1794-1802, 2148-2154 | Full | 023_Chapter5.rb:539-540, 610-622 | Heals now and returns once in the final fight, as the module's option suggests. |
| Locket recognised and enchanted as a talisman ("shine true in the face of illusion") | 1804-1814, 574-576 | Missing | — | Gap 14. |
| Sacred weapon (silver dagger by the bier) | 1816-1822 | Missing | — | Optional loot. |
| Motherly words to Reptin: "Child of the wolf… I am sorry… a gift, not a curse" | 1824-1830 | Compressed | 023_Chapter5.rb:524-533 | |
| "Confront the witch. Save the innocent." / "Go. She's started." | 1834-1836 | Full | 023_Chapter5.rb:535 | "Time is a wheel, dear. Go. She's started." |
| Prophecy: "When the howl of the wolf meets the cry of the innocent under the crone's shadow…" | 1844-1850 | Missing | — | Gap 6. |
| Ghost lies down; body crumbles to dust; lichen dims | 1850-1856 | Full | 023_Chapter5.rb:106-107 | |
| Tips: "destroy her black staff", "only flame can quell the ice-eater" | 1868-1870, 2170-2172 | Missing | — | |

### Area 7: The Heart of the Chasm

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Domed cavern; dais; four ice spires cradling a blood-red orb that beats; crimson/cobalt veins | 1876-1890 | Full | 023_Chapter5.rb:108-111, 550-555 | |
| Yeti cub bound and gagged in black iron chains between pillars, pleading blue eyes | 1892-1898 | Full | 023_Chapter5.rb:112, 554 | |
| Hag's true form: bruise-coloured skin, black talons, ember eyes, patchwork cloak, baby-teeth necklace, staff hung with frozen sprites | 1900-1912 | Compressed | 023_Chapter5.rb:563; 022_Chapter4.rb:797 | "No longer hiding"; patchwork cloak (Ch4); staff only when it breaks. |
| Cauldron of ritual brew on blue flames | 1914-1918 | Missing | — | Gap 7. |
| Hag's name "Granny Thredra" | 858, 1974 | Full | 022_Chapter4.rb:86; 023_Chapter5.rb:78, 322 | |
| Winter wolf and ice troll minions; "Warm blood!" | 1920-1926, 2088-2096 | Full | 023_Chapter5.rb:564-565, 587-597 | |
| Winter wolf as one of the Dougan's Hole extortionists | 1994-1996 | Full | 023_Chapter5.rb:564; 022_Chapter4.rb:747-767 | Kanan. |
| "Ssooo, my dearies, you made it after all… grand finale" | 1928-1934 | Compressed | 023_Chapter5.rb:566 | "There you are. My little seamstress's samples." |
| Curse-tug; "A life for a life… One cut… I always keep my end of a bargain"; "will you honor our deal?" | 1936-1962 | Compressed | 023_Chapter5.rb:572 | Only "A life for a life. This sweet one, I think." Gap 1. |
| "I shall be the new Winter – not so fickle as Auril!" | 2040-2042 | Full | 023_Chapter5.rb:571 | Verbatim. |
| Morality taunt ("spare one little monster? How… precious. How weak.") | 2042-2046 | Missing | — | |
| The choice before battle (refuse / offer self / stall) | 2022-2054 | Full | 023_Chapter5.rb:573-585 | Adds a third option: hold up the golden acorn. |
| Coven option (second hag) | 1980-1990, 2138-2144 | N/A (opt) | — | Optional hard mode. |
| Heart lair actions (necrotic waves, visions of the dead) | 2110-2124 | Missing | — | Atmospheric; could be battle flavour. |
| Hag at low HP tries to cut the cub's throat to feed the Heart | 2126-2136, 2212-2228 | Changed | 023_Chapter5.rb:603-609 | She flees into her mirror and sends a Reflection instead. Gap 7. |
| Freeing the cub (chains) | 2178-2188 | Changed | 023_Chapter5.rb:695-699 | Mother breaks the chains, or they snap in the time flood. |
| Hag's death: killing blow or the Heart's backlash | 2242-2248 | Changed | 023_Chapter5.rb:655-657, 712-713; 034_Chapter8.rb:168-181 | Trapped in shattered mirrors, survives as an echo (from the "Frost Hag" notes, not this file). |
| Heart denied, falls dormant | 2248-2252 | Full | 023_Chapter5.rb:110-111, 634 | Plus the seed's green light. |
| Winter persists; moral victory only; maybe a single ray of sun | 2272-2282, 2410-2420 | Changed | 023_Chapter5.rb:655-723 | The acorn and the time flood cause the Verdant Reversal (Rootspire timeline). |
| Reptin keeps his curse; the Heart recognises him and grants control | 2284-2292, 2422-2424 | Compressed | 023_Chapter5.rb:530-532, 134 | No Heart reaction. Gap 9. |
| Cub approaches a kind PC, nuzzles; "yeti cub as party pet" | 2266-2268, 2294-2302, 2406-2410 | Full | 023_Chapter5.rb:695-706 | Optional Yetot joins the party. |
| Leave the Heart (destroying it would be catastrophic); Reptin volunteers to watch | 2304-2312 | Compressed | 023_Chapter5.rb:134; 036_Chapter10.rb:154 | No choice offered; stewardship comes later, at the Heartroot. |
| Reptin stays behind as the chasm's guardian, parting with a vow | 2424-2430 | Changed | — | He stays in the party. |
| Dark ending (baby dies; curse broken; Reptin cured, grief-howl) | 2338-2350, 2440-2474 | N/A (opt) | — | Alternative branch, not taken. |
| TPK ending (hag becomes witch-queen) | 2478-2498 | N/A (opt) | — | Counted with the row above in the N/A total. |

### Rewards, Legacy, Epilogue

| Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|
| Black Ice Staff / "Graystaff of the Crone" (cackling dreams) | 2314-2318, 2512-2518 | Missing | — | Gap 13. |
| Cauldron opals, Counterspell scroll, cold-resistance potion, Black Ice Ring | 2318-2324, 2518-2526 | Missing | 023_Chapter5.rb:79 (Hyper Potion/Full Heal reward) | Loot. |
| Winter wolf pelt / cloak | 2322-2324, 2526-2530 | Missing | — | Kanan escapes instead. |
| Alberica's locket: portrait now smiles at peace; daily Bless | 2530-2538 | Missing | 031_StoryItems.rb:21-22 | Gap 13. |
| Druidic Codex (Order lore; ritual to recharge the Heart) | 2538-2546 | Missing | — | |
| Never-melting Heart fragment focus | 2546-2554 | Missing | — | |
| Legacy: wildflower at the chasm mouth; watchful wolf howls at night | 2556-2564 | Missing | — | Gap 8. |
| Ten-Towns' brief respite | 2566-2572 | Changed | 023_Chapter5.rb:726-737 | Replaced by the Reversal's sapling and thaw. |
| Speaker of Dougan's Hole publicly thanks them | 2572-2576 | Changed | 022_Chapter4.rb:889-893 | Speaker *Edgra Durmoot* thanks them after the Ch4 hag night, before the chasm. |
| "Glimmer in the Chasm" tavern song in Bryn Shander; Glimmer and Alberica pass into legend | 2576-2582 | Missing | — | Hellen's Hearth song and carvings exist (037_Chapter11.rb:41-42; 039_Chapter13.rb:549-550), but not this. |
| Reptin sends messages via wolf or raven | 2582-2586 | Missing | — | |
| Order rekindled; the party as new wardens | 2586-2592 | Compressed | 036_Chapter10.rb:154 | Reptin and Anduin as Heartroot stewards. |
| Auril's wrath: rime-coated snowy-owl feather on the sill | 2592-2602 | Missing | — | |
| Epilogue dream: Alberica and a glowing spectral child, "Thank you… Balance is restored… for now" | 2604-2616, 2368-2382 | Changed | 039_Chapter13.rb:592-605 | Final scene: Old Alberica in the chasm, "Hello again", greeting the incoming party. Different, but it honours "an old guardian watching". |
| Strange token: a wolf-and-bloom carving of warm ice | 2618-2626 | Missing | — | |
| Legend of the "Heroes of the Cackling Chasm"; laughter now a child's giggle and a wolf's howl | 2642-2652 | Compressed | 023_Chapter5.rb:150, 158 | "Did you hear the cub laugh?" / "Meat Meat taught it a better laugh." |

### Additions in the game not in this file (not counted)

- Party banter throughout (023_Chapter5.rb:116-160), the Laughing Waste trainers and NPCs (69-96), the mother yeti charging the troll (590-593), the golden acorn and the Verdant Reversal (630-762), and the egg hatchings of Razzilith and Frostina (666-694). These come from other campaign documents. None of them contradicts the approved changes.
- Minor continuity note found while auditing: `mother_yeti_after` shows "The mother yeti lies curled around her cub" whenever `cub_home` is set (023_Chapter5.rb:98), even if the player took Yetot (`got_yeti_cub`). It is likely unreachable, because the Reversal moves the player straight to Act II, but it is wrong on a loop replay unless loop resets clear it.
