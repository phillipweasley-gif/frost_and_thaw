# Final audit A: sources/drive/session_log.md (all 2,681 lines)

I read the source in full, in nine chunks of about 300 lines. I then traced each element to the code that plays it, the map event that calls that code, and the flags that let it run. I did this before reading docs/audit or docs/reaudit. Afterwards I compared my results with docs/reaudit/A_session_log.md: most of the earlier findings are now fixed, and every bug below is new.

All paths below are under `/home/claude/frost-thaw/game/Data/Scripts/998_FrostThaw/` unless they say otherwise.

**Main code checked:**
- `023_Chapter5.rb`, `044_ChasmFaithful.rb`, `022_Chapter4.rb`, `045_HoledUp.rb`, `014_Chapter2.rb`, `015_Chapter3.rb`
- `026_Rootspire.rb` (`twin_orb`, `bloom_guard_visions`), `048_Rootspire_E_Nights.rb` (the omens)
- `037_Chapter11.rb` (the Whisper), `029_Glimmer.rb`, `039_Chapter13.rb` (`start_loop`, the epilogue), `047d_FixRound.rb` (the wolf messenger)

**Builders and maps checked:**
- `tools/build_ch5.rb`: every event on the Chasm maps (2041-2046 and 2100). I confirmed these events are in the compiled maps under `build/maps`.
- `tools/build_ch6b.rb:124-127`: the twin orb.
- `tools/build_act3.rb:46`: the autorun that plays the Whisper.

## 1. Summary

| Verdict | Tab 1 (visions, Whisper, omens) | Tab 2 (Cackling Chasm) | Total |
|---|---|---|---|
| Full | 9 | 107 | **116** |
| Compressed | 0 | 3 | **3** |
| Changed | 4 | 14 | **18** |
| Missing | 0 | 1 | **1** |
| Unreachable | 0 | 0 | **0** |
| Rows | 13 | 125 | **138** |

One more row (C17) is not counted because it doesn't apply to the game. I also found 7 bugs; none of them blocks play.

**Judgement: this slice is faithfully covered.**

The Cackling Chasm module is in the game almost beat for beat:
- **The seven areas:** every keyed area and every boxed-text beat.
- **Every optional encounter:**
  - the pit and its ghouls
  - the rift floor and the gnoll ghost (you only reach them if you fall)
  - the coldlight walker
  - the coven sister (Hard difficulty only)
- **The ghost:** her full lore dump, every boon, and every tip.
- **The hag:** her lair actions, flight, illusions, and her last lunge at the cub.
- **All three endings, and everything after them:** the loot, the legacy and the epilogue tokens.

Every Chasm event in `tools/build_ch5.rb` calls a function that exists, and its switch conditions can come true. I ran a BFS over the feast hall: the "Yeti wakes" trigger row can't be walked around, so the mother yeti can't be skipped by accident.

Tab 1 is complete too:
- All five Bloom Guard visions are there, each with its setting, its memory and both fates. They play at the twin orb, which is reachable.
- All five omens are there, in three tiers that get harsher.
- Auril's Whisper plays from an autorun at the Hearth in Ch11.

The previous audits' main findings are fixed:
- The sanctum now opens only after the Gate.
- "Who was Glimmer?" is answered (`029_Glimmer.rb:127-139`).
- Reptin fights Kanan.
- The Whisper's lines are restored.
- The ghost's warning now comes before the falling ice.
- The omens now stop at the Whisper.
- The vow has its payoffs.

The owner and fix-round decisions are implemented correctly:
- **The mother yeti lives or dies by the player's choice:** sing to her, back away, or fight her to the death.
- **Only an explicit "...Do it." plus a confirmation leads to the loop:** the lunge can wound the cub but never kills it.
- **Shade's face stays in the WAIT picture:** `023_Chapter5.rb:1093`.

None of the brief's four listed integration choices (Darrus, Pell, the Undercity, Razzy's scale) touch this slice.

The 18 Changed rows are all deliberate and coherent. Most come from three things:
- the campaign's Verdant Reversal and its time wheel,
- the Bloom Guard ghost becoming Alberica's future self,
- the pendant breaking in Ch3.

What still needs work is small. One vision line contradicts the game's own events (B1). Tier-1 and tier-2 Glimmer omens can still play after Glimmer is dead (B2). A few smaller continuity slips are listed under B3-B7.

## 2. Every row that is not Full, ranked by importance

### Bugs (ranked)

**B1. The Glimmer vision contradicts where Shimmer's heart went (contradiction, medium)**
- **Source:** L35, "the way her body became the Verdant Reversal's seed."
- **Game:** `026_Rootspire.rb:946-947` says: "The heart of ice that went down into the root the acorn woke, and became the Reversal's seed."
- **Why it's wrong:** In the game the heart of ice is turned into the Frost Egg in Ch3 (`015_Chapter3.rb:671-672`: `take_key(:FT_HEARTOFICE)`; `give_key(:FT_FROSTEGG)`). At the root, only the golden acorn goes in (`023_Chapter5.rb:1000-1001`). The Frost Egg hatches Frostina (`023:1031`). Nothing of Shimmer's goes "down into the root".
- **Fix:** "Shimmer's last breath. The rose. The heart of ice that became the Frost Egg, and hatched at the root the acorn woke, the morning of the Reversal."

**B2. Glimmer omens can still play after Glimmer's death (contradiction, medium)**
- **Where:** `048_Rootspire_E_Nights.rb:122-135`.
- **What happens:**
  - Once `:glimmer_gone` is set (`034_Chapter8.rb:655`), the spark omen no longer needs Glimmer in the party.
  - But `omen_check` still walks the tiers from 0. Any tier-1 or tier-2 spark omen not yet shown can play after his death, for example "Glimmer says Shimmer's name, very quietly..." or "Glimmer calls on Brightmane..." (`048_E:75-80`).
  - This is likely to happen: omens play one at a time, in key order (dark, light, memory, then spark). The Ch7-Ch8 descent spends little time on Rootspire maps, so spark's tier 2 is often still unseen when Glimmer dies at the Forge.
- **Fix:** inside the tier loop, add `next if key == :spark && flag?(:glimmer_gone) && t < 2 && (state[:omens][[key, t]] = true)`. That marks the tiers for a living Glimmer as seen and skips straight to "His grief burned too hot. I told you to watch him."

**B3. "Harsher if she strays" counts a flag that is always false (dead condition, low)**
- **Source:** L102. If Alberica strays, the omens turn harsher.
- **Game:** `alberica_strayed` counts `hag_bargain_taken` (`048_E:115-118`).
- **Why it's dead:**
  - The flag is set only in the bargain ending (`044:670`), which immediately calls `start_loop`.
  - `start_loop` deletes every flag (`039_Chapter13.rb:592-602`), so the flag can never be true by the time you reach Rootspire.
  - Only `state[:bargain_memory]` survives the loop.
- **Fix:** replace `hag_bargain_taken` in the list with a separate term, `((state[:bargain_memory] || 0) > 0 ? 1 : 0)`.

**B4. The wolf messenger ignores how little time has passed outside the Wall (continuity, low)**
- **Where:** `047d_FixRound.rb:452-470`. This is Reptin's vow paid off (Source L2424-2430, L2582-2586).
- **The problem:**
  - Outside the Auroral Wall only weeks have passed (`024_Chapter6.rb:237-238`, `333-335`). Yet the vision shows "A yeti and her grown cub".
  - It also shows "The ghost's candle, still lit, in the sanctum". But the ghost went to her rest and her body crumbled to dust (`023:779-781`), and the candles were already "melted-down" (`023:684`).
- **Fix:** "A yeti and her cub, fishing at the black water." and "Someone has lit fresh candles round the empty bier."

**B5. Wrong flag name in the Glimmer journal payoff (dead branch, low)**
- **Where:** `029_Glimmer.rb:129` checks `flag?(:glimmer_journal_read)`. That flag is never set; the journal sets `:read_glimmer_journal` (`023:403`).
- **Impact:** It works today only because the bag check comes first.
- **Fix:** `flag?(:read_glimmer_journal)`.

**B6. Dead `:failed` path in `chasm_dark_ending` (latent, low)**
- **Where:** `044:667-711` keeps an `else` branch for `:failed`. The comment says "or :failed (you let the knife fall)".
- **Impact:** Only `:agreed` is ever passed (`023:842`), which is correct under the fix-round decision. But the comment and the branch invite someone to reintroduce the old behaviour.
- **Fix:** remove the branch, or reword the comment to "agreed only (fix round)".

**B7. Two lines can never play, and taking the cub has no reaction (low)**
- **Two unreachable lines:** `mother_yeti_after` has variants for `:cub_home` and `:got_yeti_cub` (`023:99-100`). Both flags are set at the end of Act I, after which you fall through time and never stand in the feast hall again (and the loop clears them).
- **No reaction:** taking Yetot while its mother is alive (`044:791-797`) gets no line from her.
- **Fix:**
  - At `044:796`, when `mother_alive`, add: "The mother looks at you a long time. Then she touches the cub's head with one great finger, and lets it go."
  - Drop the two unreachable variants.

### Rows that are not Full (ranked)

| # | Element | Verdict | Source | Game evidence | Note or fix |
|---|---|---|---|---|---|
| T4 | Glimmer vision: Shimmer's sacrifice becomes the seed | Changed (+B1) | L35 | `026:946-947` | Fix as in B1. Also missing: "burn brighter because of that grief" (the hopeful fate). Add to the first flame: "...and the grief in his hands burns brighter for it." |
| C110 | Ending 2: the cub dies, the winter breaks, Reptin is cured | Changed (fix-round) | L2440-2474 | `044:669-723`, then `chasm_wheel_turns_back` (`044:738-749`) loops | The text is complete: the column of red light, the aurora goes out, sunrise, the howl, "Life for death". Then the time wheel loops the game. `bargain_memory` echoes later (`023:219-222`, `704-706`, `949-951`). Correct. |
| C109 | Ending 1: the cub is saved | Changed (campaign integration) | L2394-2436 | `023:985-1066`; `044:765-881` | The Heart goes dormant, Reptin's wolf calms, and the cub coos. Then the acorn and the mirrors trigger the Verdant Reversal in place of "winter persists". Sound. |
| C111 | Ending 3: TPK, the witch-queen | Compressed | L2478-2498 | Full text only at `044:726-735` (agree, then lose to the Winter-Crowned). Ordinary losses play it as a dream (`044:752-760`). | Missing: "a wise survivor will take up the cause". Add to `chasm_witch_queen_ending`: "Somewhere in Bryn Shander, a girl with a stolen druid's book starts reading." Fine for a Pokémon game. |
| C66 | The ghost names herself "Alberica, last guardian" | Changed (integration) | L1694, L1702 | `023:695-699`: a dwarf with Alberica's own face, older and unnamed. Paid off in the Ch13 epilogue. | Strong choice; it resolves the name clash with the Herald. Keep. |
| C34 | Glimmer's journal, from a dead adventurer | Changed (integration) | L852-874 | `023:393-408`, a skeleton with claws; `029:127-139`, Glimmer reads his own hand | Turned into a loop artifact of Shade/Glimmer. Coherent with the owner decision. Fix B5. |
| C39 | The illusory child calls itself "Glimmer" | Changed | L966-972 | `023:421-422`, `452`: "it's me... Shimmer" | Not a listed integration choice. It doesn't betray the source: it's crueller to Shade. But it drops the module's "Glimmer" bait. Optional: make the 4th "ask" answer "...Glimmer... I'm Glimmer... no... Shimmer..." so the name still echoes. |
| C73 | The ghost's alternative: "the blood of one cursed, or a willingly given life" | Changed | L1778-1781 | `023:765`: "a life freely given, or a life not yet begun" | Sets up the golden acorn. The "cursed blood" (Reptin) option is lost. Optional: "...or a warden's own blood, or a life not yet begun." |
| C103 | Reptin stays as guardian / sends word by wolf or raven | Changed (+B4) | L2310-2312, L2424-2430, L2582-2586 | Vow at `044:827-833`; wolf messenger at `047d:452-470`; epilogue at `039:648-651` | He can't stay (he's a Herald), so he vows and keeps the vow. Good. Fix B4. |
| C29 | The mother yeti fights to the death | Changed (owner decision) | L676-806 | `023:325-382`: sing (needs `stood_with_alberica`), back away, or fight to the death | Matches the decision. B7 for the cub. |
| C22 | Frozen locket with a stern human's portrait named Alberica | Changed (integration) | L562-576 | `023:277-293` (an older dwarf with Alberica's face; "as if someone still watches over it") | Consistent with C66. |
| C8 | Hook "A Hag's Bargain" (messenger or dream) | Changed (integration) | L202-208 | Made in person at the Twenty Stones (`022:561` calls `044:894-917`); the dream half is Reptin's vision (`023:209-218`) | Mandatory, because the mirrors need `hag_parley`. Sound. |
| C3 | Reptin's curse comes from a full-moon encounter | Changed (integration) | L136-140 | Bitten while feeding the starving pack (`045_HoledUp.rb:170-199`); first change under a full moon on the Laughing Waste (`023:183-192`) | Merges Tab 1's rations memory. Sound. |
| C50 | A fall from the bridge is likely fatal | Changed | L1314-1328 | `044:324-350`: you survive on a rift floor with a chute to climb back | The source asks for "a heroic out". Sensible. |
| C97 | The hag dies as the Heart backlashes through her | Changed (campaign) | L2242-2246 | Good path: she flees into the mirrors and is shattered (`023:878-883`, `1010-1012`). Bad path: the backlash itself (`044:706-711`). | From the Frost Hag notes. Sound. |
| C119 | Ten-Towns gets a brief respite | Changed | L2566-2570 | Superseded by the Reversal: the Dale thaws inside the Wall | Fine. |
| T6 | Auril's Whisper to Alberica | Changed | L47-69 | `037:52-67` | All five lines are present. "The spark carries grief, but grief burns brighter than love" becomes "The spark is spent" (Glimmer is dead by Ch11; owner decision). "Keys open as well as destroy" becomes "Keys open... they also lock" (the tier-3 omen keeps "destroy"). Staging changed: a visible Auril at the table, where the source has a pressure in her bones. Optional: add "Her voice isn't sound. It's a pressure in your bones." |
| T3 | Alberica's vision: the pendant pulses brightest | Changed | L25 | `026:932-935`: "where her pendant used to hang, something pulses" | Correct for the game: the pendant broke in Ch3 (`015:405-406`). |
| T9 | Alberica's omen: frost and warmth fight on the pendant | Changed | L79-80 | `048_E:63-73`: on her collarbone and rune | Same reason as T3. Correct. |
| C21 | Ice mephit ambush (3-5 mephits, one mimicking the hag's voice) | Compressed | L506-548 | `023:268-271`: two "Ice mephit" Snorunt; death burst shown | Missing the voice mimicry. Optional: "One of them shrieks in the crone's voice: \"Heehee! Mind your step!\"" |
| C93 | Free the cub during the fight (skill challenge) | Compressed | L2176-2188 | Only at the lunge: "Wrench the cub's chains free" (`044:565-567`, `584-588`) | Acceptable in a Pokémon battle frame. |
| C105 | Alberica's journal in the tomb | Missing | L2332 | none | Optional in the source ("perhaps"). Low. You could put a page on the codex shelf that the Lorn Scribe later recognises (`048_F:594-596`). |

## 3. Full table

Rows I've marked Full can still have small trims; where that matters, it's noted in the row.

### Tab 1

| # | Element (source lines) | Verdict | Game evidence |
|---|---|---|---|
| T1 | Alerion, Guardian of the Dark Half: the black forest, Frostina's eyes, the voice, Shimmer in another age, his shield, both fates (L7-11) | Full | `026:903-915`; reachable from `twin_orb` (`026:855-889`), `build_ch6b.rb:124-127` |
| T2 | Meat Meat, Guardian of the Light Half: the meadow, Razzilith, the voice, the acorns, flowers and laughter, both fates (L15-19) | Full | `026:916-926` |
| T3 | Alberica, Keeper of Memory: the Vault of the North, the rune, the pendant, Bryn Shander's square, both paths (L23-27) | Changed | `026:927-939` (the pendant is gone) |
| T4 | Glimmer, Sparkbearer: Brightmane, the voice, Shimmer's sacrifice, both fates (L31-35) | Changed (+B1) | `026:940-953` |
| T5 | Reptin, Warden of Life and Death: the graveyard, the wolves, the wound, the rations, both visions, the wheel (L39-43) | Full | `026:954-966` |
| T6 | Auril's Whisper to Alberica (L47-69) | Changed | `037:37-86`; `build_act3.rb:46` |
| T7 | Omen: frost on Alerion's shadow (L73-74) | Full | `048_E:41-51`, three tiers |
| T8 | Omen: Alberica's breath curling like vines when Meat Meat laughs (L76-77) | Full | `048_E:52-62` |
| T9 | Omen: frost and warmth on the pendant (L79-80) | Changed | `048_E:63-73` |
| T10 | Omen: a crackling like fire under snow; "His grief burns too hot. Watch him." (L82-84) | Full (+B2) | `048_E:74-84` |
| T11 | Omen: Alberica's heartbeat slows, then quickens (L86-87) | Full | `048_E:85-94` |
| T12 | Narrative use: every session, only she sees them, paranoia (L94-101) | Full | `hearth_night` / `rootspire_step` call `omen_check`; "(Something only Alberica sees.)" (`048_E:151`); Alberica's "just a chill" (`048_E:153-155`); the Whisper pays them off (`037:60-63`) |
| T13 | The omens turn harsher if she strays (L102) | Full (+B3) | `omen_tier` + `alberica_strayed` (`048_E:104-118`) |

### Tab 2: the Cackling Chasm

| # | Element (source lines) | Verdict | Game evidence |
|---|---|---|---|
| C1 | Background: the hag froze Dougan's Hole and survived (L122-130) | Full | Ch4 (`022:525-576`) |
| C2 | Her offer: end the winter and cure Reptin (L134-142) | Full | `044:894-917` |
| C3 | Reptin's curse origin (L136-140) | Changed | `045_HoledUp:170-199`; `023:180-192` |
| C4 | The Order of Life and Death; wolves as wardens; Reptin is one (L144-156) | Full | `023:718-732` |
| C5 | The Heart: drinks life to counter death (L158-168) | Full | `023:721-722`, `805-807` |
| C6 | The hag has a yeti baby to sacrifice (L170-174) | Full | `023:740`, `832`, `942` |
| C7 | The hag's secrets: only temporary, empowers her, removes the warden (L176-186) | Full | `023:737-743`, `808-812` |
| C8 | Hook: A Hag's Bargain (L202-208) | Changed | see the ranked table |
| C9 | Hook: Howling in the Dark (L210-216) | Full | `022:196` (new moon), `023:86-91`, `022:630-631` ("make sure she never comes back up out of it") |
| C10 | Hook: Reptin's Vision (L218-226) | Full | `023:191-192`, `209-218` |
| C11 | The chasm's name; the gnolls once laughed there (L230-238) | Full | `023:89-91`; `044:119-121` |
| C12 | General features: dark, cold, slick, echoes, scent, the hag's wards, names whispered (L240-298) | Full | `044:163-185` (four whispers, `build_ch5.rb:101,137,180,229`) |
| C13 | The horror escalates (L300-312) | Full | across the areas |
| C14 | Reptin anxious; the hag singles him out ("Poor boy...") (L326-336) | Full | `023:214-215`; `044:900-904`; `023:241-243` |
| C15 | Reptin nearly loses control in Area 2 (L336-340) | Full | `044:206-217` |
| C16 | The hag holds Reptin; "Take me instead!"; her scornful refusal (L342-352) | Full | `023:933-940`, `966-969` |
| C17 | If Reptin is absent, the hag uses a token of him (L354-360) | not counted | Reptin is always present |
| C18 | Area 1 box text and the illusory crone (L372-430) | Full | `023:231-256` |
| C19 | Seeing through the illusion (L432-462) | Full | `023:244-251` |
| C20 | The icefall trap; "Oops! Mind your heads!" (L464-504) | Full | `023:258-267` |
| C21 | The ice mephit ambush (L506-554) | Compressed | `023:268-271` |
| C22 | The frozen locket (L556-576) | Changed | `023:277-293` |
| C23 | The gnoll femur in the fallen ice (L590-600) | Full | `044:187-193`, `build_ch5:102-105` |
| C24 | The hag's voice flits in and out (L578-588) | Full | `044:175-185` |
| C25 | Area 2 box text: the feast hall (L604-628) | Full | `044:198-205` |
| C26 | Corpses: the trapper, the dwarf, gnolls (L640-646) | Full | `044:202-203` |
| C27 | The male yeti, heart cut out, frostbitten (L646-658) | Full | `023:295-304` |
| C28 | Blood runes, Yeenoghu, the defaced druidic sign (L658-674) | Full | `044:109-114`, `221-227` |
| C29 | The mother yeti (L676-796) | Changed (owner decision) | `023:325-382` |
| C30 | Her last lunge; she curls over her mate (L794-806) | Full | `023:367-370` |
| C31 | The tracks and the swaddling in the dead father's hand (L808-830) | Full | `023:305-316` |
| C32 | The moral weight; "an entire yeti family destroyed" (L832-838) | Full | `023:369-373` |
| C33 | Loot: the potion, 32 gp 18 sp, the greataxe, the necklace of ears (L840-850) | Full | `023:400`; `044:229-243` |
| C34 | Glimmer's journal (L852-874) | Changed | `023:393-408`; `044:922-933`; `029:127-139` |
| C35 | The hag's echo: "Ohhh, such violence..." (L892-896) | Full | `044:246-253` |
| C36 | Reptin shaken: "This isn't right"; "We won't let her do this to anyone else" (L898-906) | Full | `044:211-213`; `023:311-315` |
| C37 | Area 3: the fork; a child's voice and a light to the left, weeping to the right (L910-938) | Full | `023:412-427` |
| C38 | A reflection lingers, grinning (L946-954) | Full | `023:417` |
| C39 | The child answers "I'm Glimmer" (L966-972) | Changed | `023:422`, `452` |
| C40 | Clues: the breeze, the reflections, the sobbing on a loop, the Insight check (L986-1022) | Full | `023:430-458` |
| C41 | Going right: "Don't leave me! Please!" (L1030-1038) | Full | `023:513-517` |
| C42 | Going left: the dead end, the pit, the ghouls (L1040-1124) | Full | `023:460-486`; maps 2042/2043 |
| C43 | The pit's loot and the writing "SHE LIES / DON'T TRUST THE LIGHT" (L1126-1144) | Full | `023:104`, `488-498`; `build_ch5:154-158` |
| C44 | "Poor little lambs... did you stumble?" (L1150-1158) | Full | `023:481-482` |
| C45 | The right path: the sobbing stops, claw marks (L1160-1176) | Full | `023:519-521` |
| C46 | A small girl's reflection: "Why won't you help me?" (L1176-1186) | Full | `044:383-387` (moved to the rift) |
| C47 | Resolution: the hag plays on their emotions and has used the name (L1196-1208) | Full | `023:526-532` |
| C48 | Area 4 box text: the rift, the bridge, the railing, the lights, the chanting, the ice chunk (L1222-1262) | Full | `023:537-548` |
| C49 | The crossing: rope, slow or walk; slips; dangling; being hauled up (L1300-1334) | Full | `044:258-322` |
| C50 | The fall (L1314-1328) | Changed | `044:324-350`; map 2100 |
| C51 | Wind gusts (L1336-1342) | Full | `023:572-588` |
| C52 | Personal voices on the wind (L1354-1360) | Full | `044:364-388` |
| C53 | Glowing orbs rising from below (L1366-1370) | Full | `044:286`; rift-floor wisps |
| C54 | The ghostly gnoll (L1386-1388) | Full | `044:352-362` (only if you fall) |
| C55 | The ghostly woman points up before the ice falls (L1388-1400) | Full | `023:550-570` |
| C56 | The coldlight walker on the far ledge (L1408-1428) | Full | `044:391-413`; `build_ch5:181`, `187-190` |
| C57 | Bat-like creatures spook the crosser (L1430-1434) | Full | `044:287` |
| C58 | The far side: clearer chanting, a rest nook, disturbances (L1438-1462) | Full | `023:590-605` |
| C59 | Area 5 box text: the Gate and its whisper (L1464-1498) | Full | `023:607-613` |
| C60 | The runes: "Life for Death, Death for Life" (L1512-1518) | Full | `023:105-108` |
| C61 | The puzzle: blood; bone dust or silence; the stained bowls as clues (L1520-1580) | Full | `023:614-640`, `654-656`; `023:384-391` |
| C62 | Failure: a necrotic burst, skeleton guardians, "Give life... give death..." (L1582-1620) | Full | `023:641-659` |
| C63 | Opening: the runes glow; a vision of a robed woman with wolves (L1622-1636) | Full | `023:632-637` |
| C64 | The hidden seam (L1638-1656) | Full | `023:635`, `662-670` (needs `gate_open`) |
| C65 | Area 6 box text: the bier, the corpse rising (L1658-1700) | Full | `023:676-699` |
| C66 | The ghost's identity (L1702-1712) | Changed | `023:695-699` |
| C67 | The Order's history (L1712-1718) | Full | `023:718-722` |
| C68 | The Children of the Wolf; "a sacred charge" (L1718-1730) | Full | `023:727-732` |
| C69 | What happened: the gnolls, the sealing, her sacrifice (L1730-1738) | Full | `023:723-726` |
| C70 | The hag's scheme; "a blight upon both life and death" (L1740-1750) | Full | `023:734-739` |
| C71 | The yeti baby; "soul-debt" (L1750-1762) | Full | `023:740`, `804-807` |
| C72 | Reptin's cure is his choice; he keeps it; her blessing (L1762-1774) | Full | `023:742-753`, `808-812` |
| C73 | Knowledge of an alternative to the sacrifice (L1776-1792) | Changed | `023:764-765` |
| C74 | Boons: cold charm, healing, the locket as a talisman, the silver dagger (L1794-1822) | Full | `023:755-760`, `784-785`; the battle effects in `044:486-532` |
| C75 | "Child of the wolf... a gift, not a curse" (L1824-1830) | Full | `023:752-753` |
| C76 | She absolves their guilt (L1832-1834) | Full | `023:816-819` |
| C77 | Her final urging, fading, the prophecy, the body crumbling to dust (L1834-1856) | Full | `023:770-781` |
| C78 | Her tips: the black staff, flame for the troll (L1868-1870, L2170) | Full | `023:762-768` |
| C79 | The Druidic Codex (L2538-2546) | Full | `044:418-431`, `935-941`; `build_ch5:214-217` |
| C80 | Area 7 box text: the Heart, the pillars, the cub, the cauldron (L1874-1918) | Full | `023:827-835`; `044:127-130` |
| C81 | The hag in full (L1900-1912) | Full | `023:916-922` |
| C82 | The minions: winter wolf and ice troll (Kanan, from Dougan's Hole) (L1920-1926, L1992-2004) | Full | `023:921-922` |
| C83 | Her greeting, the tug at Reptin's curse, "A life for a life", "honour our deal?" (L1928-1962) | Full | `023:923-948` |
| C84 | "Okay, do it" (L2024-2028) | Full | `023:952-962` (with confirmation) then `044:669` |
| C85 | Someone offers themselves in the baby's place (L2030-2036) | Full | `023:966-969` |
| C86 | "The new Winter", "How precious. How weak", "Then be damned!", "Don't take another step!" (L2040-2054) | Full | `023:929-931`, `974-979`, `845` |
| C87 | She flies on her staff; illusions; three of her (L2062-2078) | Full | `044:486-528` |
| C88 | The optional coven: a sister disguised as an ice statue (L1980-1990, L2082-2084, L2138-2144) | Full | `044:622-634` (Hard only, as the source's "hard mode") |
| C89 | The winter wolf: "Warm blood!" (L2086-2090) | Full | `044:457`; `023:846` |
| C90 | The troll regenerates unless burned (L2092-2096, L2160-2172) | Full | `044:470-483` |
| C91 | Reptin fights: wolf against wolf (L2006-2020) | Full | `044:458-469` |
| C92 | The baby's peril; the Heart's lair actions (necrotic wave, death visions, life pulse) (L2100-2126) | Full | `044:497-532` |
| C93 | Freeing the baby mid-fight (L2176-2188) | Compressed | `044:584-588` |
| C94 | Her mid-fight offer: "Still time to reconsider" (L2200-2204) | Full | `044:533-536` |
| C95 | At low HP she lunges: "If I can't have victory..."; her flight (L2206-2230) | Full | `044:540-613`, `648-658` (never kills the cub, per the fix round) |
| C96 | The ghost or Reptin's wolf intervenes (L2148-2154, L2232-2236) | Full | `044:596-610`; `023:888-900` |
| C97 | How the hag ends (L2242-2246) | Changed | see the ranked table |
| C98 | The Heart goes dormant (L2248-2254) | Full | `044:806`; `023:113-114` |
| C99 | The cub approaches and coos for its lost parents (L2266-2268, L2400-2408) | Full | `044:783-790` |
| C100 | Reptin's lycanthropy calmed; the Heart recognises its warden (L2284-2292) | Full | `044:806-811` |
| C101 | The cub's fate: keep it, return it to the wild, or a sanctuary (L2294-2302) | Full (+B7) | `044:791-803` |
| C102 | "Leave it. It must remain here..." (L2304-2308) | Full | `044:819-826` |
| C103 | Reptin as guardian; word by wolf or raven (L2310-2312, L2424-2430, L2582-2586) | Changed (+B4) | `044:827-833`; `047d:452-470`; `039:648-651` |
| C104 | Treasure: the staff, the black ice ring, the scroll, the potion, the pelt, the Order's chest, a Heart fragment (L2314-2332) | Full | `044:837-865` |
| C105 | Alberica's journal in the tomb (L2332) | Missing | none |
| C106 | The journal's hidden line: "Balance must be kept. Spare the innocent." (L2374-2376) | Full | `044:929-932` |
| C107 | Two spectral figures, Glimmer and Alberica (L2378-2382) | Full | `044:879-880` |
| C108 | Reptin says a few words over her resting place (L2372) | Full | `044:812-818` |
| C109 | Conclusion 1: the cub saved (L2394-2436) | Changed | see the ranked table |
| C110 | Conclusion 2: the cub dead (L2440-2474) | Changed | see the ranked table |
| C111 | Conclusion 3: failure, the witch-queen (L2478-2498) | Compressed | see the ranked table |
| C112 | The Black Ice Staff and its taint (L2512-2518) | Full | `044:43-44` |
| C113 | Cauldron spoils: three opals, the counterspell scroll, the cold-resistance potion (L2518-2526) | Full | `044:843-852` |
| C114 | The winter wolf pelt (L2526-2530) | Full | `044:854-857` |
| C115 | The locket: her portrait now smiling, and a daily bless (L2530-2538) | Full | `044:958-988` |
| C116 | The Codex's recharge ritual, "best left untouched" (L2544-2546) | Full | `044:424-427` |
| C117 | The Heart fragment that never melts, and its dreams (L2546-2554) | Full | `044:860-864`, `953-956` |
| C118 | Legacy: a wildflower; watchful wolf howls (L2556-2564) | Full | `044:870-871`, `831-833` |
| C119 | Ten-Towns gets a respite (L2566-2570) | Changed | the Reversal |
| C120 | Speaker Durmoot thanks them (L2572-2576) | Full | `044:873`; `022:627-631` |
| C121 | The song "Glimmer in the Chasm" (L2576-2582) | Full | `044:874-876` |
| C122 | The Order rekindled; Reghed wardens (L2586-2592) | Full | `044:872` (`order_wardens`) |
| C123 | Auril's black owl feather (L2592-2602) | Full | `044:884-887`, `719-721` |
| C124 | The epilogue dream: a silver-haired woman and a glowing child; "Balance is restored... for now" (L2604-2616) | Full | `044:879-880` |
| C125 | The wolf-and-bloom carving in a pack (L2618-2626) | Full | `044:888-890`, `943-946` |
| C126 | The "Heroes of the Cackling Chasm" legend; a child's giggle and a wolf's howl (L2642-2652) | Full | `044:877-878` |

Optional variants in the source that the game doesn't use, and doesn't need to:
- giant spiders in the pit (L1100)
- a specter on the bridge (L1372-1384)
- the cauldron belching adds (L2096-2100)
- Reptin turning on a would-be sacrificer (L2018-2020)
- the coven sister disguised as the troll or the wolf (L1984-1988)

The source offers each of these as an alternative or an "optional" extra, so I haven't counted them as Missing.
