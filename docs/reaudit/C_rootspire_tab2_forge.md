# Re-audit C: rootspire.md Tab 2 (lines 3809-7088): downtime week, festival, GM outline, Chapter 3 "The Rootsun Forge"

Every line of the slice was read in ~300-line chunks. The game side was checked in these files:
- 048_Rootspire_F_Downtime.rb (all of it): downtime days, festival pieces, Eirwen's audience
- 048_Rootspire_E_Nights.rb:144-266: hearth_night, investigation_night, scorch_marks, TAVERN_RUMOURS
- 024_Chapter6.rb:330-472: the Hellen rest, festival_ready?, scene_festival_night
- 034_Chapter8.rb (all of it): Barricade, kitchen, pens, Autumn, Dragonforge, Heart Chamber, coat, launch
- 046_ForgeRooms.rb (all of it): A2-A37 room by room
- tools/build_ch8.rb and tools/build_ch8_deep.rb (all of it), plus the placements in build_ch6.rb, build_ch6b.rb and build_rootspire_life.rb

Every Forge function used for an Area is placed on a compiled map (build/maps/Map2072-2076, 2146-2155 exist). `ruby tools/reach.rb` on all 15 Forge maps reports "everything reachable". Switch chains checked:
- traitor -> lever / passphrase -> SW_BARRICADE_OPEN
- golems -> SW_GOLEMS
- Rootwatch trainers -> Rootbreaker -> SW_ROOTWATCH / SW_SAPLIFT
- root-keep trainers -> SW_L3_GATE
- devil-priest -> SW_FORGE_CLEARED -> stair
- mechs -> SW_MECHS
- Antechapel -> SW_ANTECHAPEL
- Heart Chamber autorun -> circle -> fight -> engine_dead -> launch -> Veins

## 1. Summary

| Rating | Count |
|---|---|
| Full | 81 |
| Compressed | 5 |
| Changed | 7 (3 follow owner decisions or integration; 4 are reorderings or adaptations, judged below) |
| Missing | 0 |
| Unreachable | 0 |
| Bugs / contradictions (separate list) | 11 |

**Honest judgement.** This slice is covered very faithfully. All 37 Forge Areas are in the game, Area 7 included (`root_archives`, 2146 (31,4)), and each sits in its own room with its read-aloud mostly word for word. All five Heralds' downtime days are playable scenes. Brightmane's three answers, the "Chard...alyn" vision, the Memory Codex fragments, Arvik's Loop-Band speech, the potions, the rumours, the festival beats and GM-outline steps 1-6 are all there, reachable and placed.

The real weaknesses are not missing content. They are about **sequencing**:
- the "seventh-night" festival isn't tied to the seven days;
- the downtime days and GM-outline steps 1-6 have no "before the Forge" gate, so they can play after Avarice is "dead";
- the outline's beats can come after Kelyn has already given the mission, which makes the summons redundant.

There are also a handful of continuity slips:
- after the Forge, the golden dagger is both in your bag and lying on the stone;
- two lines refer to scenes that don't exist or are worded differently;
- three rust-feasters are announced but two are fought;
- one duergar repeats the same line.

Nothing here betrays the source. The integration choices touching this slice look sound:
- Thredra stands in for "Mother Thruuna";
- the Lorn Scribe hands Alberica her journal pages;
- the boss fight moves into the Heart Chamber (H23/H24);
- Razzy's first scale is in the root-vault.

## 2. Every row that is not Full, ranked by importance

### Bugs and contradictions (ranked)

**B1. Downtime and GM-outline beats have no "before the Forge" gate. They can play after Avarice's "death".** (High)
- **Source:** 3809-5386 (the downtime week happens *before* the festival); 5643-5684 (the outline leads *into* Chapter 3).
- **Evidence:**
  - `048_Rootspire_E_Nights.rb:149`: `hearth_night` runs until `ch11_started`.
  - `:177-178`: `investigation_night` only needs `ch7_started` and `!rootwardens_at_door`.
  - `048_Rootspire_F_Downtime.rb:25`: `dt_ready?` only checks `rs_day`.
  - `:56`: Meat Meat's days only need `twins_met`.
  - `:64-77`: Arvik and Alerion's desk have no chapter gate. Lumin's rite stops only at `glimmer_gone` (`:318`).
- **Effect:** A player who goes straight down after the festival and rests at the Hearth after Ch8 or Ch9 can get any of these after the Forge:
  - "A patrol's missing... heat pulses" plus the chardalyn scorch marks;
  - Eirwen's "There's a passage... begun humming";
  - the Council summons "Something awakens below";
  - Razzilith's Day-2 "No one sees Summer... Summer missing";
  - Alerion's Day-2 "SEE THE FIRST MAPS".
- **Fix:**
  - Add `&& !flag?(:barricade_entered)` (or `!flag?(:engine_dead)`) to `investigation_night`, `eirwen_audience_due?`, `dt_ready?` and `meat_meat_day`.
  - Better still: make the Ch7 roads (SW 3937 / the two road gates) wait for `chardalyn_found`, so outline steps 1-6 always play between the festival and the descent, as the source orders them.

**B2. The "seventh night" festival isn't tied to the seven days.** (High)
- **Source:** 5545-5560 and 5784-5792 ("on the seventh day", "The seventh night breaks warm").
- **Evidence:**
  - `024_Chapter6.rb:361-363`: `festival_ready?` = `rite_stopped && glimmer_joined && badge_hearth && !festival_night`. No `rs_day` check, and no downtime count (`add_counter(:downtime_days)` at `048_F:29` is never read).
- **Effect:** The festival can happen with the whole downtime week unplayed. The week then either never happens or (B1) happens afterwards. If the player skips it, Glimmer's rite and the "Chard...alyn" vision are lost for good once Glimmer dies at the Forge (`048_F:318`).
- **Fix:**
  - Gate `festival_ready?` on `rs_day >= 7`.
  - Or have Hellen warn "the festival's the seventh night" until then, and point the player to Arvik, Alerion's desk, Lumin and the Lorn Scribe through `state[:goal]`.

**B3. The golden dagger is in two places at once after the engine dies.** (Medium)
- **Source:** 6712-6733 (the launch).
- **Evidence:**
  - `034_Chapter8.rb:600`: the golden dagger lies on the stone.
  - `:609/:615`: Meat Meat picks it up and holds it.
  - `:620`: `give_key(:FT_DAWNFANG)`.
  - `:651, :666`: you lay or drive it into the Shard.
  - Then `:769` in `scene_launch`: "On the stone where Glimmer knelt, the golden dagger hums, and won't stop."
- **Fix:** Change `:769` to "In Meat Meat's hands, the golden dagger hums, and won't stop." (in Herald mode as Meat Meat: "In your hands..."), or "In your pack, Dawnfang hums..."

**B4. GM step 6 (the Council summons) repeats a mission already given.** (Medium)
- **Source:** 5675-5684.
- **Evidence:**
  - `024_Chapter6.rb:450-451`: Kelyn already says "Something is waking below. Find our Summer Marshal. And stop whatever is burning the roots." at the festival.
  - `048_F:688-689`: later, Eirwen's audience ends with a runner: "Heralds. Something awakens below."
- **Fix:** Pick one.
  - Either move Kelyn's mission line out of the festival into the runner's summons, which keeps the source order (festival -> door -> scorch -> Eirwen -> Razzy -> summons -> mission);
  - or reword the runner as "The Council says: go now."

**B5. A16 points at a scene that doesn't exist.** (Low)
- **Evidence:** `046_ForgeRooms.rb:436`, Alerion: "Those were the claw-marks at the Underdark mouth."
- No scene anywhere has claw-marks at an "Underdark mouth". The only claw marks are `023_Chapter5.rb:520`, in the Cackling Chasm.
- **Fix:** Reword to "Something big's been digging up through the roots for weeks." Or add a claw-mark sign at the Ch7 Underdark-door side.

**B6. A11 quotes the Ch7 overlook as "the same words", but they differ.** (Low)
- **Evidence:**
  - `046_ForgeRooms.rb:316`: "The same words. Carved on the overlook."
  - The mirror says "Don't let her take the heart..." (`:314`).
  - The overlook (`025_Chapter7.rb:63`, placed `build_ch7.rb:66`, optional) says "SHE WILL TAKE THE HEART IF WE DON'T."
- **Fix:** Use "Nearly the same words as the overlook." Or gate the line on having read the overlook (set a flag in `talk(:warden_overlook)`).

**B7. A17 announces three rust-feasters but you fight two.** (Low)
- **Evidence:** `046_ForgeRooms.rb:442` says "Three rust-feasters look up..."; `:443` fights two `named_mon`s.
- **Fix:** Say "Two", or add a third mon.

**B8. A3: Kord says the same line twice, and the line is used four times in all.** (Low)
- **Evidence:**
  - `034_Chapter8.rb:64` (Kord's lose text) and `:74` (Kord's intro) are both "Xardorok said you'd come. The failures always return."
  - It is also in `scene_barricade` (`:139`) and in Ruk's intro (`046_ForgeRooms.rb:87`).
  - The source gives it once, in A3.
- **Fix:**
  - Keep it in Ruk's intro (A3 proper) and in `scene_barricade`.
  - Give Kord a new intro ("Back to the sap! The engine's hungry!") and lose text ("The fire's in my head. Quieter now.").

**B9. The passphrase is always on offer at the Rootgate.** (Low; arguably a shortcut)
- **Source:** 5861-5868 (Knock, the A6 lever, or "extracting the infernal passphrase from captured guards").
- **Evidence:** `034_Chapter8.rb:151` always lists "\"Rimebound. Rise unbroken.\"" as an option. `:156-158` even covers it: "(You're not sure where you heard it. It works anyway.)"
- **Fix:** Offer the option only if `flag?(:read_ledger)` or Hild has been beaten (her lose text gives the phrase). Otherwise only "Let us through" / "Say nothing", plus the A6 lever route.

**B10. A6: the traitor's "Ask me after" is never answered.** (Low)
- **Evidence:** `046_ForgeRooms.rb:267`, "I had one. Before the sigils. Ask me after." His later lines (`:246-247`) never give a name. Nothing else mentions him (grep "sooty" / `traitor_met`).
- **Fix:** After `engine_dead`, have him give a name: "Bram. It's Bram again."

**B11. Minor wording and continuity slips.** (Low)
- `048_F:433`: "She said I'd know the fire when I saw it." Elsewhere the speaker is Brightmane (`048_Rootspire_B_People.rb:645`, `034_Chapter8.rb:343`), and Brightmane is never "she". Fix: "Brightmane said...".
- `046_ForgeRooms.rb:569`: Reptin calls the Frostfire Flask "Evidence... The Council likes evidence." But the Trials only take the Ledger (`036_Chapter10.rb:135`). Fix: add the flask as a Summer exhibit, or drop the line.
- `vantage_west` (`046:589`) has the dragon "thrash once, and the whole chamber trembles". Minutes later `scene_dragonforge` (`034:338`) shows it with "Its eyes are dark". Fix: "Its eyes are dark now, but its chains are still swinging."
- `alerion_potions` (`048_F:261-265`): Alerion's Days 6-7 (the Dale before Auril, the deepest leaves, the golden key, "Winter returns...") are locked until you pay $4,400 for six potions. In the source the purchase is optional flavour. Fix: let the desk move on to Day 6 if he declines or can't pay.

### Changed (ranked)

**C1. Finding the Forge: the source's entrance is replaced by the Ch7 door.** (Medium; integration with other tabs; acceptable, but leaves a loose end)
- **Source:** 5731-5759 (a sealed passage in the Heartroot is opened) and 5662-5667 (Eirwen: "a sealed passage... begun humming").
- **Game:**
  - The way in is the Ch7 "door of iron and glass" at the bottom of Hew's Guild Dig (`032_Chapter7A.rb:25`, `033_Chapter7B.rb:23`, `034_Chapter8.rb:48`).
  - Eirwen's line "There's a passage. Sealed since the Reversal. Under the Root-Gate." (`048_F:680`) never pays off.
- **Lost:** "Glimmer hears hammering in the deep roots" is reduced to Glimmer's "Something under us is burning" and Meat Meat's hammers (`024:430-432`). "Razzy and Frostina grow restless" has no Frostina beat.
- **Fix:** Change Eirwen's line to "Sealed since the Reversal. Its far end comes out under the Guild Dig: a door of iron and glass." Give Glimmer the hammering line, and add one Frostina-restless line to `investigation_night`.

**C2. GM outline steps 1-6 come after the mission, and are optional.** (Medium; covered under B1/B4)
- **Source:** 5647-5684.
- **Game:** All six beats exist and are placed:
  - `investigation_night` (E_Nights:177);
  - the scorch-marks event (build_ch6.rb:133 -> `scorch_marks`, E_Nights:198);
  - `eirwen_audience` (F:674, via `eirwen` D_Quests:560);
  - Razzy clawing (E_Nights:187-191, only if Meat Meat is with you).
- But they fire only if the player rests at the Hearth after the festival, which already gave the mission and the "Two ways down" goal.
- **Fix:** As B1/B4.

**C3. A26 (the Dragonforge proper and the boss) is split across two maps.** (Medium; integration with Tab 1/3 H23/H24 and the Var owner decision)
- **Source:** 6437-6514.
- **Game:**
  - 2075 `scene_dragonforge` (`034:328-347`) has the heat wall, the cathedral womb, the molten sap, the mechanical arms, the Stones and the chained dragon.
  - 2076 `scene_heart_chamber` (`034:385-442`) has the heart-engine "refusing to die", Avarice's white hair, sigils and red-gold eyes, "my little failures", "You survived my early prototypes... womb that birthed you", and her Xardorok alias.
  - The combat features are there: lair actions (`:446-461`), the mechs in round two (`:432-440`), and the tower bolts if A25 isn't cleared.
- **Lost or changed:**
  - "She wears no disguise": she's in Var's body (owner decision).
  - "The dragon thrashes against its chains behind her": the dragon is a map away.
  - "Mechanical Dragon strains harder each round" is reduced to one line ("my dragon wakes a little more", `:469`).
- **Fix (optional):** Add one Heart Chamber lair line per circle action, e.g. "Far below, chains groan; the dragon pulls again."

**C4. Avarice's escape is changed to the faked death.** (Owner decision)
- **Source:** 6737-6757 and 6904-6908.
- **Game** (`034:719-750`): Hell's Veil and its pillar of red-black flame are there, and so is "We will speak again in the White Womb, little failures."
- **Changed:** The mirror *refuses* her (`:723`) and a body is left behind. A careful player can catch the lie (Vessel IX, the bare arms, the fogging mirror shard).
- Consistent with the owner's "Avarice fakes her death at the Forge". It fires when the engine dies, not at 25% HP. No fix needed.

**C5. A8: Mother Thruuna's dining hall becomes Thredra in the mirror.** (Low; integration, using the established hag name)
- **Source:** 5993-6012.
- **Game** (`034:181-212`; 2073 (12,8) and (12,4)): the tea table set for six; "My, my. The children come back to mother's kitchen"; an echo, not the hag resurrected ("Mirrors always remember"); "Burn her forge, dearies, and I'll whisper you a secret".
- **Changed:**
  - She is a voice in a cracked mirror, not a spectral hag sipping phantom tea with "one dead eye and one burning ember".
  - Her price is pre-paid: the secret comes at once, with `wheel(-1)`.
- "Mother Thruuna" is never named, here or at A35 (`046:716-729`, where the silhouette says "Mother's stones. Mother's kitchen").
- **Fix (optional):** Add the dead-eye/ember line to `tea_table`, e.g. "In the glass, a hag at the table, one dead eye and one burning ember, sipping tea that isn't there."

**C6. Glimmer Day 4: the horn.** (Low; continuity adaptation)
- **Source:** 3881. His horn falls off and a new, firmly fixed one grows.
- **Game** (`048_F:364-365`): the horn Brightmane gave back (which he has carried since the Rift, `029_Glimmer.rb:102`) sets itself to his brow and grows in for good.
- Same result, adapted to the Shade -> Glimmer owner decision. No fix needed.

**C7. Festival location.** (Low)
- **Source:** "Festival Circle" / "Council Hall of Seasons" (5564, 5792).
- **Game:** It happens in the market (`024:412-472`, transfer to 2050). "On the Hall's roof, Razzilith stiffens" (`048_F:658`) still works. Acceptable.

### Compressed (ranked)

**P1. Reactions to the launched dragon.** (Medium)
- **Source:** 7075-7082.
- **Game** (`034:763-770`): Razzy panics; Alerion recognises frostcraft; Alberica's threads scream; Reptin feels the spike.
- **Lost:** "Meat Meat will rage" goes to Razzilith ("and then pure rage"). "Glimmer's shard will resonate violently" can't happen, because he has just died (owner decision); it lives on at A24 (`046:597-599`).
- **Fix:** Give Meat Meat a rage line, e.g. "MEAT MEAT: (through her teeth) She put RAZZY'S work in that. Meat Meat is going to take it back apart."

**P2. A4: the flight-path root model.** (Low-medium)
- **Source:** 5920-5936.
- **Game** (`034:87-88`, sign at 2072 (20,7), also played in `scene_barricade`): "A black dragon circles ten little towns on a frozen lake... lights go out."
- **Lost:** The living root-model diorama; the "mechanical dragon of frost and fire" with "eyes burning hell-red"; any later "you know its path" payoff.
- **Fix:** Rewrite the text as "A model of the Dale grows out of a root platform; over it an illusion flares: a mechanical dragon of frost and fire, eyes hell-red, circling Ten-Towns". Set `:flight_path_seen` and use it in Ch9's chase.

**P3. The festival mural of past deeds.** (Low)
- **Source:** 5564: a mural carved in living bark at the circle, its figures shifting when nobody looks.
- **Game:** Only Reptin's "They carved us. We owe them the faces." (`024:422`). Also dropped: "the children of the Reversal" from Kelyn's line (`024:420`).
- **Fix:** One line in `festival_opening`.

**P4. Meat Meat's day bonuses.** (Low; mostly mechanics)
- **Source:** 4956-4996 and 5150-5156.
- **Game:** "First cut, true cut" plus a Quick Claw and Razor Claw (`048_F:527-529`). The Razzy-reflection centring is in the prose (`:520-521`).
- **Lost:** The Day-6 "Heightened Summer-Sense". Acceptable.

**P5. The 11/25 narrative recap.** (Low)
- **Source:** 5388-5396.
- **Game:** There is no recap as such. Its content arrives through the days and rumours.
- **Lost:** "icy glimmers beneath the Glasswater and green sparks flickering like fireflies in the depths"; "the faint scent of frost where none should exist".
- **Fix:** One Hearth rumour or dawn line.

## 3. Full table

Map ids are in brackets. Unless a row says otherwise, "evidence" means the function and its placement.

| # | Source element (lines) | Rating | Game evidence / note |
|---|---|---|---|
| 1 | Glimmer D2 Severance of Frost (3819-3837) | Full | `glimmer_day2` F:332; Lumin via `twin_orb` -> `lumin_rite` (026:887; build_ch6b.rb:114) |
| 2 | Glimmer D3 Dawn Ember (3841-3859) | Full | F:350 |
| 3 | Glimmer D4 Suncall Purification, horn (3863-3881) | Changed | F:359-366 (C6) |
| 4 | Glimmer D5 Litany, mane-braid pendant (3885-3905) | Full | F:369; FT_MANEBRAID |
| 5 | Glimmer D6 Dawnstride (3913-3933) | Full | F:383 |
| 6 | Glimmer D7 Brightmane Acceptance (3937-3959) | Full | F:392-411 |
| 7 | Glimmer's 3 questions, Brightmane's answers, "Chard...alyn" vision (3963-4001) | Full | F:413-436 (pronoun slip B11) |
| 8 | Reptin D2 root-sense, Blind Walk, black eye (4009-4031) | Full | F:79; F:36-43; Arvik placed build_rootspire_life.rb:165 |
| 9 | Reptin D3 Split Dock gauntlet, renewed faith (4035-4059) | Full | F:103 (+ `arvik_spar`) |
| 10 | Reptin D4 Aurora-Climb, moonbeam (4063-4085) | Full | F:118 |
| 11 | Reptin D5 Quiet Step (4089-4107) | Full | F:131 |
| 12 | Reptin D6 ambush; teaches spell concentration (4115-4139) | Full | F:146-158 |
| 13 | Reptin D7 Silent Circuit (part noticed), wild-shape healing, Loop-Band speech (4143-4199) | Full | F:160-188 |
| 14 | Alerion D2 first 100 years; no Twenty Stones (4211-4229) | Full | F:211; desk build_ch6b.rb:153 |
| 15 | Alerion D3 hag mirrors, echoes backward (4233-4251) | Full | F:224 |
| 16 | Alerion D4 wyrmlings, guides, Dragon Warriors (4255-4285) | Full | F:236 |
| 17 | Alerion D5 six potions at Run & Bloom, Nivva (4289-4475) | Full | F:250; via `nivva_shop` B_People:120 (gating slip B11) |
| 18 | Alerion D6 Dale before Auril (4481-4497) | Full | F:273 |
| 19 | Alerion D7 visions, golden key, "Winter returns...", nat-1 misbelief (4501-4537) | Full | F:288-312; misbelief on D6 (F:279-284) |
| 20 | Meat Meat D2 Razzilith: Summer missing, tiefling, no face (4543-4619) | Full | F:456-469 |
| 21 | Meat Meat D2 first flight, first rider (4625-4681) | Full | F:470-479 |
| 22 | Meat Meat undercity: 7 encounters + following presence (4685-4919) | Full | F:487-516 |
| 23 | Rootwarden rumours: blue lights, silent warden, forged decrees (4923-4951) | Full | F:518-526 |
| 24 | Meat Meat bonuses / wyrmling centring (4956-4996, 5150-5156) | Compressed | P4 |
| 25 | Summer–growth imbalance, 8 signs + takeaway (4998-5146) | Full | F:533-548 |
| 26 | Alberica wakes: "Remember..." (5160-5180) | Full | F:44-53 |
| 27 | Alberica's Memory Codex, 4 fragments, day lost (5184-5322) | Full | F:575-611; Lorn Scribe build_ch6b.rb:148 (integration) |
| 28 | Alberica's 7 market rumours (5326-5382) | Full | F:613-623; E_Nights:251-259 |
| 29 | Session log 11/25 recap (5388-5396) | Compressed | P5 |
| 30 | Truth of the Forge: under Rootspire, Dougan's Hole, hag lair, Stones, Reversal (5398-5428) | Full | 034:333-337; 046:295-299 |
| 31 | Duergar tunnelled in; Avarice slaughtered their leaders (5450-5458) | Full | 046:258-262 |
| 32 | Dragon bound to the Stones; the "holy wound" (5460-5476) | Full | 034:335-338 |
| 33 | Layout: sap-flow lift; Grandolpha as hag echo (5484-5541) | Full | 046:360-377; 034:184-190 |
| 34 | Festival opening: lanterns, pipes, children, honour guard, wyrmling effigies (5560-5562, 5794) | Full | F:628-633 via 024:417 |
| 35 | Festival mural of deeds (5564) | Compressed | P3 |
| 36 | Kelyn: "Rootspire remembers"; chalice, "Four hundred years..." (5566, 5798-5800) | Full | 024:420; F:635-637 |
| 37 | Summer Throne: dry vines, charred strand, warm sap, Solglass watching (5573-5584, 5804-5806) | Full | F:638-639; 024:419 |
| 38 | Glimmer's shard flare; Razzy stiffens toward the roots (5585-5588, 5808-5810) | Full | F:656-661 |
| 39 | Eirwen whisper / Stormbranch / Lirielle (5593-5606) | Full | F:663-667; 024:434 (Rheven speaks to all; "he" = Var, owner decision) |
| 40 | Disturbance: shudder, threads tremble, MM & Razzy know the forge, aurora pulses "designed" (5610-5639, 5812-5822) | Full | 024:424-441 |
| 41 | GM 1-2: Rootwardens at the door, missing patrol, warm scorch marks (5647-5655) | Changed | E_Nights:177-195 (C2, B1) |
| 42 | GM 3: chardalyn fragment with infernal sigils (5657-5660) | Full | E_Nights:198-212; event build_ch6.rb:133 (B1 caveat) |
| 43 | GM 4: Eirwen's private audience, maps, Stones beneath, passage humming (5662-5667) | Full | F:674-692 (C1 loose end, B1 caveat) |
| 44 | GM 5: Razzilith claws the floor; dragon, heart, "the woman who hurt him" (5669-5673) | Full | E_Nights:187-191 (needs Meat Meat) |
| 45 | GM 6: Council summons (5675-5677) | Changed | F:688-689 (B4: redundant) |
| 46 | GM 7: mission: descend, hag lair, Summer Marshal, stop the burning (5679-5684) | Full | 024:450-452 |
| 47 | Running this chapter: Avarice as Xardorok; her goal (Ten-Towns, souls, supplant Auril, the Hells) (5697-5723) | Full | 034:403-407; 046:258-262 |
| 48 | Finding the Forge: hooks; sealed Heartroot passage (5727-5759) | Changed | C1 |
| 49 | A1 Rootgate: read-aloud; 3 ways in; passphrase (5838-5868) | Full | 034:130-171; lever 046:271-286 (B9) |
| 50 | A2 Echo Hall: wrong reflections, disorientation (5873-5891) | Full | 046:167-183 [2146] |
| 51 | A3 Duergar guardhold: sap-pool, "Xardorok said you'd come", enthralled (5896-5915) | Full | 046:127-128; Ruk/Varn [2146]; Kord/Brask/Hild [2072] (B8) |
| 52 | A4 Flight-path root model (5920-5936) | Compressed | P2 |
| 53 | A5 Avarice's quarters: smell, bed, mural, journal (3 excerpts), mirror-root effigy trap (5940-5961) | Full | 046:129, 186-241 (+ the Ledger, integration) |
| 54 | A6 Traitor and lever: "Kill the Forge-Mistress", Great Unchaining, opens the gate (5966-5982) | Full | 046:244-286 (B10) |
| 55 | A7 Root Archives: maps of the understructure (5987-5989) | Full | `talk(:root_archives)` 046:130-132; [2146] (31,4) |
| 56 | A8 Mother Thruuna's dining hall (5993-6012) | Changed | 034:181-212 (C5) |
| 57 | Level 2 intro read-aloud (6018-6024) | Full | 046:291-302 |
| 58 | A9 Deep Root Shaft: 40 ft, rootbone, infernal rib-supports, webbing, heartbeat (6028-6053) | Full | 046:133-135, 295-299 [2147] |
| 59 | A10 Guest quarters: ticking dragon limb, runework, notes, MM tie (6058-6082) | Full | 046:321-339 |
| 60 | A11 Warden's bunker: lagging mirror, future self "Don't let her take the heart" (6086-6109) | Full | 046:136, 305-318 (B6) |
| 61 | A12 Training hall: dummies become sap golems, heat haze (6114-6132) | Full | 046:342-357 [2148] |
| 62 | A13 Sap-lift: Root / Deep / Forge (6137-6157) | Full | 046:360-377; consoles [2072]/[2148]/[2150] |
| 63 | A14 Rootwatch: 3 duergar + Infernal Rootbreaker, molten-sap burst (6162-6178) | Full | Ord/Ysk/Brod + 046:380-400 |
| 64 | A15 Sap-gate controls: frost-blue vs red, "a winter altar... rewriting it" (6183-6200) | Full | 046:403-418 |
| 65 | A16 Umbound Chasm: scratching, floor explodes, pale blind hulk, duergar flee invisible (6205-6223) | Full | 046:421-437 [2149] (B5) |
| 66 | A17 Rust-feast tunnels: gnawed struts, iron-laced hag-blood roots (6228-6240) | Full | 046:138-139, 440-445 (B7) |
| 67 | A18 Root-keep gate: boiling sap, 4 crossbow duergar (6245-6257) | Full | Hrem/Vosh/Dagna/Turl [2149]; root-bridge |
| 68 | Level 3 intro: womb of iron, "something trying to be born" (6280-6291) | Full | 046:490-500 [2150] |
| 69 | A19 Root-Throne: mirror-stone dais, quaggoth, tortured myconid "let me die", spores animate constructs (6295-6319) | Full | 046:140-141, 503-540 |
| 70 | A20 Broken root-works: hiding enslaved duergar, "Even the roots obey her" (6324-6339) | Full | 046:543-552 |
| 71 | A21 Heart-fuel flasks; touching hurts (6344-6357) | Full | 046:555-570 (B11 flask note) |
| 72 | A22 Root-shaft elevator + Rootbreaker (6363-6374) | Full | 046:380-400 (`:elevator`); console [2150] |
| 73 | A23 Root-keep gate: fearful crossbowmen, molten sap (6380-6394) | Full | 046:573-582; Kell/Morn/Sharl/Ulf [2150] |
| 74 | A24 West vantage: first sight of the dragon; Razzy reacts (6400-6414) | Full | 046:585-602 [2151] |
| 75 | A25 East vantage: bolts on the boss fight; clearing helps (6420-6432) | Full | 046:605-619; 034:453-459 |
| 76 | A26 Dragonforge proper, read-aloud + Avarice reveal (6437-6463) | Changed | C3 |
| 77 | A26 boss: dialogue, lair actions, mechs round 2, dragon strains (6500-6513) | Full | 034:397-399, 432-461 (strain only one line: C3) |
| 78 | A27 Rootbeast pens: failed Razzy prototypes (6518-6530) | Full | 046:450-465 [2074] |
| 79 | A28 Prison cocoons: Rootwarden "burning the seasons away" (6535-6544) | Full | 046:467-485 [2074] |
| 80 | A29 Mind-flayer corpse: brain taken for the engine (6548-6560) | Full | 046:622-630 [2151] |
| 81 | A30 Lower elevator (6565-6568) | Full | 046:633-637 |
| 82 | A31 False priest / barbed devil, serves willingly, flees if outnumbered (6572-6588) | Full | 034:349-372 [2075] |
| 83 | A32 Mirror-hall trap: wrong reflections, "She will take your heart", root-thorns (6593-6606) | Full | 046:650-663 [2152] |
| 84 | A33 Barracks: vacant duergar chanting "Fire replaces frost" (6611-6627) | Full | 046:666-681 |
| 85 | A34 Tortured captain: "Kill her...", tactics, dies unless healed (6632-6646) | Full | 046:684-713 (hints feed the circle, 034:471-473) |
| 86 | A35 Thruuna's residual chamber: phantom laughter, lore on the Stones and Mirror Rites (6651-6663) | Full | 046:716-729 (name unused: C5) |
| 87 | A36 Rootbound mech guards (6668-6676) | Full | 046:732-739 |
| 88 | A37 Root-vault: journal "Tomorrow, the dragon flies..."; loot; frost-mirror, MM note, Razzy's scale, frozen rose (6681-6707) | Full | 046:742-804 (+ Marshal badge) |
| 89 | Dragon launch read-aloud: heart-engine, chains, roof, Heartroot, toward Ten-Towns (6712-6733) | Full | 034:755-779 (trigger moves after the boss; B3) |
| 90 | Avarice's escape: Hell's Veil, mirror, "White Womb" (6737-6757, 6904-6908) | Changed | 034:719-750 (C4, owner decision) |
| 91 | Avarice flavour: tiefling, Sigils of Domination (sees through duergar), Frostfire Soul (6771-6825) | Full | F:465 "a tiefling"; 046:67, 546; 034:396 (mechanics skipped) |
| 92 | Mechanical dragon lore: soul-echo techniques, stolen corrupted heart, mirror-glass, sigils, soul-harvest (7058-7073) | Full | 046:601; 034:761, 404-405; 034:338 |
| 93 | PC reactions to the dragon (7075-7082) | Compressed | P1 |

Stat blocks, DCs, spell lists, tactical notes and prices (6759-7056 and so on) are GM mechanics with no story weight, so they are not rated. Their story flavour is covered by rows 77, 91 and 92.

## Memory note
The owner's stated preference (from memory, `preferences`) is "never use shortcuts; audit when a build-out is done". B9 (a free passphrase) and B2 (a festival that skips the week) are the two places in this slice that read as shortcuts.
