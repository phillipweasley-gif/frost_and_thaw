# Audit D: `rootspire.md` lines 7089–10436 (Tabs 3–8) vs. *Pokémon Frost & Thaw*

Source: `/home/claude/frost-thaw/sources/drive/rootspire.md`, lines 7089–10436, all read in full.
Game: `/home/claude/frost-thaw/game/Data/Scripts/998_FrostThaw/*.rb` (code paths below are relative to that folder) and `/home/claude/frost-thaw/tools/build_*.rb`.
I skipped stat blocks and pure mechanics (DCs, CRs, damage, god-point sums) unless they carried story. Where a mechanic was turned into a story beat in the game (for example "capture it alive" becoming "catch it in a ball"), I counted it.

## 1. Summary

**Counts (127 story-bearing items):**

| Status | Count |
|---|---|
| Full | 37 |
| Compressed | 27 |
| Changed | 24 |
| Changed (approved) | 1 |
| Missing | 38 |

**Overall judgement.** Coverage is uneven, and the owner's worry about shortcuts is justified for parts of this slice.

- **Well covered.** These three parts are the strongest:
  - **Hyphora's Undercanopy (Tab 5):** all eight named myconid NPCs, the Hyphora/Erato/Balanus lore, the lake monster, the Balanus seed, the masked spy and Eira's opening ("Halt. Declare your purpose") are in, many of them nearly word for word.
  - **The Shadow Mycolith (Tab 6):** the Five Domains door, the icy platforms, the enraged second phase and Wyn's god-spark are in.
  - **Chapter X / Ch10 (Tab 8):** it has a real structure: the five personal trials, the Tribunal, witnesses, the Verdict and the Vote.
- **Ch10 is the skeleton, not the meat.**
  - Each trial's skill challenge and evidence list is cut down to one or two lines or a single binary choice.
  - The civic layer (building walls, electioneering, nomination petitions, debates) is gone.
  - I found two logic problems:
    - The Anduin failure branch can never be reached.
    - Rheven's testimony is spoken but never counted as a witness.
- **The Heartroot Labyrinth (Tab 3) is about one-third adapted.**
  - Zones I–II (Root Gate, Sap Wells, Overflow Channel) are faithful and well built.
  - Zones III–VI are mostly gone: the Mirror Garden, the Hollow Core, the Vault of Amber Dreams, and the Heart Chamber's Frost Saint Shard climax with its purify/preserve/destroy choice.
  - The Rootsun Forge (Ch8) is a different design. It reuses the cocoons, the devil and the Heart Chamber name, but the player's moral choice and the Vault's lore drop are lost.
- **Tab 4's character quests are mostly missing.** Of the ten personal quests:
  - Recognisably adapted: 3 (A2 as the Rime Stalker, M2 as the mirror child, B1 as the Cycle Canticle).
  - Partly folded into other content: 2 (A1, R1).
  - Missing entirely: 5 (M1 Verdant Heist, B2 Stolen Leaf, R2 Pulse of the Blooming Fields, W1 Shadows in the Undercity, W2 Mirror Lake Ghost).
  - **Wyn gets neither of their two quests.**
- **Tab 4's group quests are thin.** None of the five survives intact. The Cycle Day Conspiracy and Purifying the Heartroot are compressed, the Trial of the Four Seasons became a single gym battle, and Closing the Frostfell Rifts and Beyond the Auroral Wall are missing.
- **Dangling threads.** The game sets up things from this slice and never pays them off:
  - Rootwardens and the Bough circle "going missing beyond the Wall" is mentioned five times and never resolved.
  - Only one of three Vault Map fragments exists, and only one of three Frostshard Sigils, with the "White Vault" never reached.
  - The "ghost on the lake with a sword of mirrors" survives only as a rumour.

**Logic problems found** (the owner asked for these to be caught proactively):

1. **The Anduin failure branch can't be reached.**
   - `036_Chapter10.rb:151` decides the Heartroot's Test with `flag?(:hyphora_sworn)`.
   - `032_Chapter7A.rb:277` sets `:hyphora_sworn` unconditionally, whichever answer you give Myr.
   - Road A is required to reach the Forge (`032_Chapter7A.rb:482`), so every player reaches Ch10 with the flag set.
   - Result: `:anduin_doubtful` and the line "he walks back to the refugee camp alone" never happen.
2. **Rheven's testimony doesn't count.**
   - `036_Chapter10.rb:201-202` has Rheven say "I'll say what we saw" and sets `:rheven_saw_pens`.
   - That flag is not in `WITNESSES` (`036_Chapter10.rb:36-48`), so it never counts toward the verdict.
3. **Avarice doesn't die.**
   - Tab 8's whole premise is "the death of Summer/Avarice" (10255, 10261).
   - In the game Avarice escapes into a mirror (`034_Chapter8.rb:426-431`); only Var's body dies.
   - The trial is consistent with this (the charge is the Summer Marshal's death), but the change isn't on the approved list.

## 2. Biggest gaps (ranked)

1. **The Heart Chamber's moral climax: Changed, and the choice is lost.**
   - Source 7342–7374 (H22–H24), 7586–7592 and 8471–8492 (Purifying the Heartroot, step 4): the Frost Saint Shard can be purified, preserved or destroyed. The Breaking Circle runes change the epilogue, and sanctifying grants the Blessing of Verdant Fire.
   - In the game (`034_Chapter8.rb:376-424`) Glimmer resolves the engine himself, and the player chooses nothing.
   - *Suggestion:* before Glimmer's sacrifice in `scene_better_fire`, let the player choose what happens to Sephek's heart (sanctify, preserve or destroy), and carry the result into Ch11's "three hearts" and Ch13's Sephek scene.
2. **The Mirror Garden (H9–H12): Missing.**
   - Source 7176–7219, 7483–7499, 7956–7974.
   - The "worst selves" mirror trial with its Mirror Clones, the Shattered Bed where a shard lets Avarice scry through you, and Lirielle's Perfume Grotto rest-niche are all absent. This was the labyrinth's most personal set piece.
   - *Suggestion:* a room between the Sap Wells (2058) and the Overflow Channel (2067). Each Herald fights a mirror clone of their own team, and the reward is a Verdant Seed. Lirielle could appear in the grotto.
3. **The Vault of Amber Dreams lore (H18–H21, H28–H29): Missing or Compressed.**
   - Source 7290–7338, 7558–7564, 8021–8061.
   - Missing: the Homunculus Core; the lab notes on Avarice's "dragon/divine essence plan"; the Dissectory notes on binding Auril's essence ("the Frost Saint Shard is an experiment gone too right"); the Mirror Scriptory with Avarice's flight plans and infernal allies; the Guest Seed Nests.
   - What survives is the one-line journal in the pens (`034_Chapter8.rb:93-96`).
   - *Suggestion:* add a scriptory lectern and a Mirror-Ink Wraith fight to the Cocoon Pens (2074). That would give Ch8 its lore drop and could foreshadow Grimskalle.
4. **Wyn's personal quests (W1 Shadows in the Undercity, W2 Mirror Lake Ghost): Missing.**
   - Source 8406–8440.
   - W1 is the memory-eating spore colony in the Smuggler's Run, which Wyn can bargain with or burn. W2 is the drowned cultist's ghost carrying a shard of the Mirror Mother.
   - The ghost survives only as a Hearth rumour (`024_Chapter6.rb:490`).
   - *Suggestion:* put W1 under the Root-Tier docks (2055) and W2 on the Glasswater Shore (2078, already built) on a new-moon night, during Ch7 or the Ch10 trial week.
5. **Meat Meat's M1 "Verdant Heist": Missing.**
   - Source 8300–8315.
   - Darrus Fell recruits Meat Meat to steal a reliquary ("part of the Mirror Mother's heart") from the Guild of Roots and Stone. She can deliver it to him, expose him to the Council, or destroy it.
   - It would have set up Darrus's corruption long before he falls at the Forge.
   - *Suggestion:* a Ch6/Ch7 side quest that starts with Darrus in the Council Hall (2054) and runs through the Guild Dig (2066). Exposing him could become a Ch10 witness.
6. **The Ch10 civic layer: Missing or Compressed.**
   - Source 10267, 10406–10424, 10257.
   - Missing: public outreach and wall building (root-timber and ice walls), electioneering, mud-slinging, the winter wolves attacking a work crew, nomination petitions, and asking candidates questions in debate.
   - The election is two menu picks (`036_Chapter10.rb:429-445`).
   - *Suggestion:* add a few trial-week tasks in the market (2050) and the Blooming Fields (2060) that each add support for a candidate, alongside witnesses.
7. **Roots of Love (Reptin and Anduin) is predetermined and thin.**
   - Source 10285–10296.
   - The reconciliation challenge is one choice. The Heartroot's Test always passes because of the `:hyphora_sworn` problem above.
   - The evidence is missing: the cedar charm, plucking a golden Leaf of Hyphora, and Eirwen's "witness to restraint". So is the heart-root treant reward.
   - *Suggestion:* decide the outcome from the choice plus how much evidence was gathered, not from `:hyphora_sworn`. Add the leaf and charm as interactions in the Heartroot (2058).
8. **Brother from Beyond (Alerion and Talion): Compressed and unforeshadowed.**
   - Source 10344–10363.
   - Talion is never mentioned before Ch10. He appears as a "boy" at an underground lake instead of an older youth in the Blooming Fields.
   - Missing: the investigation, visiting the Mirror-Lake or Echo Gate, Mira's frost-glass mirror ritual, the memento, and the option to "fully restore" him. The choice is let go or keep.
   - *Suggestion:* plant Talion earlier, for example a whisper at the Echo Gate wraiths (`026_Rootspire.rb:1115`) or the Frozen Hunter. Add a Mira step and a memento before the choice at 2078.
9. **Trial evidence leads: Missing or Changed.**
   - Source 10316–10321 and 10398–10405.
   - Missing: Slaudi the Ten-Towns fisherman; the Ledger of Corruption raid on Avarice's quarters ("Project Rime: reforge the Everlasting Summer"); Autumn's secret labs under the Council Hall; refugee testimony; Rheven's sigil-horn beasts. Rheven's spoken testimony doesn't count (problem 2 above).
   - Eirwen's Naerth ledger (`026_Rootspire.rb:348-349`) is set up and never used at the trial.
   - *Suggestion:* add the ledger raid (the Council tower) and Slaudi in the refugee camp, add `:rheven_saw_pens` to `WITNESSES`, and let the Naerth ledger count.
10. **The Beyond-the-Wall thread (B2 The Stolen Leaf, Beyond the Auroral Wall, and the missing Rootwardens): Missing.**
    - Source 8353–8368 and 8515–8536.
    - Missing: the chronal leaf torn from Alberica's timeline, the Rootwarden frozen beyond the Wall, the frozen ruins of Dougan's Hole, the Temporal Guardian, and the Draconic Vault Map fragment.
    - The game raises "Rootwardens going missing past the Wall" five times (`024_Chapter6.rb:136`, `024_Chapter6.rb:493`, `026_Rootspire.rb:209`, `026_Rootspire.rb:239`) and never resolves it.
    - *Suggestion:* a Ch10 trial-week excursion through the now-thin Wall (`echo_gate`, `024_Chapter6.rb:239`) to find the Bough patrol and the leaf.
11. **Reptin's R2 "Pulse of the Blooming Fields": Missing.**
    - Source 8389–8404.
    - Reptin brokers peace between summer and winter spirits who embody Razzilith and Frostina, and earns a once-per-battle elemental resistance. This was the seasonal-balance theme in miniature.
    - *Suggestion:* the Blooming Fields (2060) after the twins have landed, as a double-spirit encounter that grants a blessing.
12. **Sephek's two-stage avatar: Compressed or Changed.**
    - Source 8136–8254.
    - Missing: the Minor Avatar fought with frost druids and mephits, Auril pouring her essence in to make a Major Avatar, and Divine Rejuvenation tied to Auril's relics in the Heartroot (destroy the relics to stop him reviving).
    - The game has one trainer battle or a talk-down at the Crown (`039_Chapter13.rb:286-327`).
    - *Suggestion:* make the Crown fight two stages (minions first, then the transformation). Put "Auril's relics" in the Heartroot as optional destroyables that remove a revive.
13. **The Trial of the Four Seasons: Changed.**
    - Source 8538–8568.
    - Lost: the Winter Matron's bid to put the Canopy under martial law "to protect the Rift", the Council debate, and the four-season dream trial (spring vines, summer drought, autumn whispers, winter blizzard).
    - It became Selrae's single Gym 8 battle (`036_Chapter10.rb:362-384`).
    - *Suggestion:* stage the gym at the Still Sky Shrine (2056) as four seasonal rooms before Selrae, and give her a political stake in the Tribunal.
14. **The Council Fane and Mnemosyne side content: Missing.**
    - Source 9269–9337, 9409–9473, 9659–9669, 9811–9817.
    - Missing: the sap-pool Vision Table (twin wyrmlings, Sephek in a cracked mirror, a tree on fire); the Rootwarden delegation demanding sap; the Auril cultist poisoning the sap pool; Memory Trade; Dream Rescue; defending Myr's tether threads from shadow demons; the Secret Nursery; and Eira's later trials and missing-patrol requests.
    - The Fane is only Luminara's gym room.
    - *Suggestion:* add a sap pool you can drink from in the Fane (2068, around (45,17)) using the Vision Table, and a Dream Rescue for Myr.
15. **Closing the Frostfell Rifts: Missing.**
    - Source 8450–8468.
    - The ice-angels from Auril's planar reflection, sealing three rifts during an auroral storm, and the Lumen Shard bearer having an edge.
    - The Celestial Rift exists only for Glimmer's (approved) transformation.
    - *Suggestion:* a post-Glimmer event at the Celestial Rift (2061). Glimmer's Lumen Shard seals the rifts, which ties his new power to a deed before the Forge.

## 3. Full table

Status key: **Full** = in the game and recognisably faithful; **Compressed** = present but cut down; **Changed** = present but altered; **Missing** = not in the game.

### Tab 3: the Heartroot Labyrinth (H1–H37), monster index, homebrew

| # | Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|---|
| 1 | H1 Root-Spiral Approach: living-wood stair, sap like sweat, aurora through hairline cracks, distant heartbeat | 7095–7102, 7441–7443 | Full | 025_Chapter7.rb:124-138, 58-59 | "Faint aurora trickles down through hairline cracks"; door knocks "like a heartbeat". Map 2057. |
| 2 | H2 Runic Seal Circle: align four seasonal runes to tonight's aurora; failure births the Sap Wraith; vision of Avarice's experiments on its death | 7104–7109, 7445–7447, 7876–7916, 8483 | Full | 025_Chapter7.rb:140-219 | Random aurora hue each save; Sap Wraith boss; death vision of "a white room under the ice... something in the glass that has your faces". |
| 3 | H3 Warden's Overlook: tally marks, "She will take the heart if we don't" | 7111–7118, 7449–7451 | Full | 025_Chapter7.rb:60-63 | Verbatim. |
| 4 | H4 Rootguard Post: bark bunks, warm sap brazier, infernal tools; enthralled guards (reskinned as corrupted Rootspire defenders) | 7120–7127, 7453–7455, 7715 | Full | 025_Chapter7.rb:45-50, 64-68; 028_Heartroot.rb:7, 43-46 | Four enthralled Rootwardens (Oren, Mae, Bryce, Ulla) instead of duergar. Fits the reskin advice. |
| 5 | H35 Captain's Alcove: captain's nook, glyph-maps of the Heartroot | 7457–7459 | Missing | — | |
| 6 | H5 Threshold of Dripping Gold: golden sap rains into basins, some glowing with aurora, "honey left too long in the sun" | 7133–7140, 7465–7467 | Full | 025_Chapter7.rb:224-232 | Near-verbatim. |
| 7 | H6 Central Wells: drink to heal; visions; Vault Map fragments; psychic backlash | 7142–7147, 7469–7471, 8485 | Changed | 033_Chapter7B.rb:304-329 | Heals and gives three visions (Auril's island, a mirror hand 30 years ago, the white vault). The visions don't give map fragments and there's no backlash. |
| 8 | H7 Overflow Channel: slippery slope, bone-like failed constructs, a map fragment in congealed sap | 7149–7162, 7473–7475 | Full | 028_Heartroot.rb:37-39, 100-102, 107, 142-152, 167-179; 025_Chapter7.rb:235-246 | Slick sap acts like ice tiles; brass "A" plate on the bones; fragment present. Map 2067. |
| 9 | Vault Map (three fragments needed to progress) | 7144, 7161, 8485 | Compressed | 025_Chapter7.rb:235-246 | Only one fragment (`:vault_map_1`) exists and it is never used again. |
| 10 | H8 Whispering Attendant: sap-homunculus with a face of mouths; Avarice's, Auril's and the PCs' voices; answers 1–2 questions for "burn the forge / free the heart" | 7164–7172, 7477–7479, 7920–7952 | Full | 033_Chapter7B.rb:331-351 | Faithful description; three answers (Summer is a coat; the heart is in the engine; "you aren't on her wheel"). The bargain is dropped. |
| 11 | H9 Petaled Threshold: dull mirror-flowers, reflections that lag a heartbeat | 7178–7185, 7485–7487 | Missing | — | The whole Mirror Garden zone is missing. |
| 12 | H10 Reflection Ring: mirror-petals show the heroes' worst selves; Mirror Clones; a Verdant Seed | 7187–7189, 7489–7491, 7956–7974 | Missing | — | The labyrinth's central personal trial. |
| 13 | H11 Shattered Bed: melted mirror-glass floor; a lodged shard lets Avarice scry; Mirror Shard Focus | 7191–7204, 7493–7495 | Missing | — | |
| 14 | H12 Perfume Grotto: Lirielle Mossdancer's rest niche, a scent from the surface markets | 7206–7219, 7497–7499 | Missing | (Lirielle only in the market: 026_Rootspire.rb:162-180) | |
| 15 | H13/H14/H16 Hollow Core: root bridges over frozen sap, sap bursts, frost vines, frozen drop, time-lapse field | 7223–7247, 7264–7275, 7505–7524 | Missing | — | Mainly hazard set pieces, but this is the labyrinth's "heartbeat" spectacle. |
| 16 | H15 Cocoon Gallery: amber cocoons with old hag experiments and newer Avarice projects side by side; a captive to bargain with or warn | 7249–7262, 7513–7520 | Changed | 034_Chapter8.rb:201-235 | Moved to the Cocoon Pens in the hag's domain and repurposed as Meat Meat's origin (RAZ-MKI.., V-7). Selrae's cocoon is the captive. |
| 17 | H17 Underdark Mouth: duergar stragglers, a back door to the Underdark | 7277–7286, 7526–7528 | Changed | 034_Chapter8.rb:116-160; 036_Chapter10.rb:252-269 | Duergar appear at the Rootward Barricade; the "Underdark door" is reused for Wyn's Ch10 trial. |
| 18 | H27 Root-Kin Barracks; H34 Lizard Nursery (root-drakes) | 7530–7536 | Missing | — | |
| 19 | H18–H19 Amber Threshold / Stasis Gallery: pods with frozen silhouettes, twisted chant to Auril; Homunculus Core; lab notes on Avarice's dragon/divine-essence plan; Temporal Surge | 7294–7308, 7542–7548, 8021–8061 | Compressed | 034_Chapter8.rb:93-96, 298-313 | Lab notes are cut to one journal ("Raz-MKIII... wyrm-essence holding"); the chardalyn dragon carries the dragon plan. No Homunculus Core and no chant. |
| 20 | H20 Dissectory Annex: notes on failed attempts to bind Auril; the Frost Saint Shard is "an experiment gone too right" | 7310–7323, 7550–7552 | Missing | — | Key lore about what the Frost Saint Shard is. |
| 21 | H21 Mirror Scriptory: Avarice's war room, flight plans, infernal allies; Mirror-Ink Wraith | 7325–7338, 7554–7556, 7978–8017 | Missing | — | |
| 22 | H28 Suffering Pods: torture pods, helpless prisoners as moral anchors | 7558–7560 | Compressed | 034_Chapter8.rb:223-235, 248-293 | Folded into Selrae's cocoon and the child Darrus drags to the forge. |
| 23 | H29 Guest Seed Nests: evidence of outside allies (Muzgardt, infernal cultists), hidden assassin | 7562–7564 | Missing | — | |
| 24 | H30 Root-Lift Node: organic elevator set piece | 7566–7568 | Missing | (the city root-lift at 026_Rootspire.rb:607 is unrelated) | |
| 25 | H31 Devil's Bloom: infernal emissary bound in a black-glass flower, a social test first | 7570–7572 | Changed | 034_Chapter8.rb:315-326 | Vexmortis, a barbed devil-priest at the Forge; fight only, no negotiation. |
| 26 | H33 Hammer-Heart Workshop: half-formed root-golems hanging like meat | 7594–7596 | Changed | 033_Chapter7B.rb:154-177 | Closest analogue is Prototype 3, the Guild construct praying to "Father". Different tone. |
| 27 | H22 Auroral Antechapel: ghost-images of the Frost Saint Shard to speak to; the moral stakes understood | 7344–7357, 7578–7580 | Missing | — | |
| 28 | H32 Thorn-Run Hall: thorn and time-lapse gauntlet | 7582–7584 | Missing | — | |
| 29 | H23 Heart Chamber: the Frost Saint Shard boss (a reduced Sephek avatar), Auril's whispers, moral multi-ending (purify, preserve, destroy) | 7359–7361, 7586–7588, 8065–8116 | Changed | 034_Chapter8.rb:331-424 | "The Heart Chamber" exists, but the boss is Avarice wearing Var, at an engine burning Sephek's heart. Glimmer destroys it (approved death). The player gets no purify/preserve/destroy choice. |
| 30 | H24 Breaking Circle: twelve root-spires with Auril runes under Avarice's; flipping them changes the epilogue | 7363–7374, 7590–7592 | Missing | (the Twenty Stones are flavour only: 034_Chapter8.rb:101) | |
| 31 | H25 Sloughing Veins: escape under pressure | 7376–7383, 7598–7600 | Missing | (replaced by the dragon launch: 034_Chapter8.rb:445-460) | |
| 32 | H26 Echo Vault: third Frostshard Sigil, a higher Verdant Seed, a World-Tree prophecy about the wyrmlings and the seasons | 7385–7399, 7602–7604 | Missing | (only one Sigil in the game: 026_Rootspire.rb:1133) | The White Vault key set is never completed. |
| 33 | H36 Aurora Treasury | 7606–7608 | Missing | — | |
| 34 | H37 Silent Chapel of the Patron: Auril's and Avarice's sigils fighting; an echo offers a last cryptic bargain | 7610–7617 | Changed | 034_Chapter8.rb:165-196 | Nearest analogue is Thredra's mirror bargain at the tea table ("Burn her forge, dearies, and I'll whisper you a secret"). |

### Tab 4: revised Sephek encounters

| # | Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|---|
| 35 | Sephek's staged escalation: Minor Avatar (2.0) with two frost druids and mephits, weakening as they fall; then Auril pours her essence in and he reforms as a crystalline Major Avatar (2.5) with coldlight walker and winter wolves | 8136–8254 | Compressed | 039_Chapter13.rb:286-327; 037_Chapter11.rb:85-158 | Sephek rises in Ch11 (Eline restores his heart) and is one trainer battle (or a talk-down) at the Crown. No minion phase, no transformation. |
| 36 | Divine Rejuvenation: he can't die while one of Auril's relics in the Heartroot remains intact | 8216 | Missing | — | |
| 37 | Sephek's voice echoing through the roots and the lake ("The lake remembers") | 8266, 8619–8620, 9343–9344 | Full | 032_Chapter7A.rb:304-315; 026_Rootspire.rb:1119; 024_Chapter6.rb:109 | Explained as his heart burning below. |

### Tab 4: character-focused quests

| # | Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|---|
| 38 | A1 Echoes at the Auroral Wall (Alerion): the Echo Gate whispers "The lake remembers"; his reflection steps away; a mirror maze with Mirror Wraiths; reabsorbing a lost soul-fragment | 8262–8277 | Changed | 026_Rootspire.rb:1115-1136, 1196-1214 | Split into the Echo Gate wraith fight (whispers, "The lake remembers", gives the Sigil) and the Frozen Hunter at the Wall ("A me that didn't come back"). No maze, no soul-fragment arc. |
| 39 | A2 The Still Beast (Alerion): Rheven at the Spire Armory asks him to capture alive a construct bearing Avarice's sigils in the Blooming Fields; can it be redeemed? | 8279–8296 | Changed | 026_Rootspire.rb:1216-1240 | The Rime Stalker in the Blooming Fields must be caught, not killed, to earn the Mantle. No Rheven, no Avarice sigils, no redemption question. |
| 40 | M1 The Verdant Heist (Meat Meat): Darrus Fell asks her to steal a Guild reliquary ("part of the Mirror Mother's heart"); deliver it to him, expose him, or destroy it to free a soul | 8300–8315 | Missing | — | Darrus's corruption is never set up this way. |
| 41 | M2 The Whispering Mirror (Meat Meat): a child's frost-glass mirror from Mira holds a fragment of Avarice; the twin is in the Heartroot; reunite or break; Mirror Sentinel | 8317–8332 | Changed | 028_Heartroot.rb:62-89; 033_Chapter7B.rb:224-299; 024_Chapter6.rb:119-121 | Present and expanded: the girl is pulled into the twin mirror in the Overflow Channel, and Mira is possessed (Gym 6). Not Meat Meat-led; Alberica comforts the child. |
| 42 | B1 Canticle of Seasons (Alberica): Eirwen asks her to sing the Cycle Canticle in the Council Hall; research in the Wind-Glass Library; spectral bards on failure; a prophecy leaf | 8336–8351 | Full | 026_Rootspire.rb:366-369, 923-982; 039_Chapter13.rb:234-237, 402-407 | Library note, sub-vault key, sung at the four-crystal pillar; failure brings "spectral voices... other bards". Reward is the Whisper Key, not a prophecy leaf; Eirwen isn't the quest-giver. Pays off at Grimskalle ("Hope, loss, endurance"). |
| 43 | B2 The Stolen Leaf (Alberica): a chronal leaf torn from her timeline; a missing Rootwarden beyond the Wall; crossing Glasswater; a frozen Rootwarden; a time wight | 8353–8368 | Missing | (rumour only: 024_Chapter6.rb:136, 493) | The Temporal Wight in the College lecture (026_Rootspire.rb:821-842) is a separate beat. |
| 44 | R1 Verdant Sickness (Reptin): black sap; Rheven asks him to cleanse it; ritual to soothe the root spirit; spore blight | 8372–8387 | Changed | 032_Chapter7A.rb:175-210, 317-355 | Split into Yarro's blight (burned with any Fire move, not Reptin-specific) and Reptin calling rain to clean the Tainted Lake. |
| 45 | R2 Pulse of the Blooming Fields (Reptin): summer and winter spirits who are Razzilith and Frostina; social challenge; reward is calling on them for resistance | 8389–8404 | Missing | — | The Blooming Fields host the Still Ones instead (026_Rootspire.rb:1160-1194). |
| 46 | W1 Shadows in the Undercity (Wyn): a memory-eating spore colony in the Smuggler's Run; offer a memory, bargain, or burn it (angers the Rootwardens) | 8408–8423 | Missing | — | |
| 47 | W2 The Mirror Lake Ghost (Wyn): a drowned Auril cultist carrying a shard of the Mirror Mother walks Glasswater each new moon; lay her to rest or bind her | 8425–8440 | Missing | (rumour only: 024_Chapter6.rb:490) | |

### Tab 4: group quests

| # | Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|---|
| 48 | GQ1 Closing the Frostfell Rifts: auroral storm at the Celestial Rift; ice-angels with Avarice's mark; seal three rifts; Lumen Shard helps | 8450–8468 | Missing | (the Rift is used for Glimmer: 029_Glimmer.rb:59-139) | |
| 49 | Shade receives the Lumen Shard at the Celestial Rift and becomes Glimmer | (context 8466; 8452) | Changed (approved) | 029_Glimmer.rb:66-139 | Approved change. |
| 50 | GQ2 Purifying the Heartroot: (1) root-gate puzzle, (2) sap wells with three map fragments, (3) disable the mirror-root vault against Mirror Sentinels, (4) destroy or sanctify the Frost Saint Shard (Blessing of Verdant Fire, or a Frost Saint Echo) | 8471–8492 | Compressed | 025_Chapter7.rb:161-219; 033_Chapter7B.rb:304-329; 034_Chapter8.rb:376-424 | Steps 1–2 are in; step 3 is missing; step 4 is replaced (see #29). |
| 51 | GQ3 The Cycle Day Conspiracy: festival night; masked devotees in the crowd; runes on lanterns channel the aurora; Auril's Icy Avatar at the Still Sky shrine | 8494–8513 | Compressed | 024_Chapter6.rb:405-461, 571-615 | The Festival of Returning Light and the Rite of Stillness at the Still Sky Shrine (Halo Matron Eline) carry the idea. No lantern-rune investigation, no crowd-shadowing, no avatar. |
| 52 | GQ4 Beyond the Auroral Wall: frozen time, suspended snow, the ruins of Dougan's Hole under ice, time anomalies, Temporal Guardian, Chronal Leaf or Vault Map, Blessing of Still Sky | 8515–8536 | Missing | 024_Chapter6.rb:239-254; 026_Rootspire.rb:1187-1193 | The suspended-snow imagery is used, but the Wall can't be crossed until Ch9, and Dougan's Hole is under Rootspire in the game. The Blessing of Still Sky is earned from the Still Ones instead. |
| 53 | GQ5 Trial of the Four Seasons: the Winter Matron wants martial law over the Canopy; Council debate; four-season dream trial; the Canopy's fate | 8538–8568 | Changed | 036_Chapter10.rb:362-384 | Became Selrae's Gym 8, "Trial of Winter", one battle. The political stake and the four seasonal tests are gone. |

### Tab 5: Hyphora's Undercanopy

| # | Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|---|
| 54 | Hyphora lore: god-sapling, one of Erato's last seeds, memories of Balanus, name known only to the myconids, "the thread that binds", tended since Year 120 VR | 8597–8605 | Full | 026_Rootspire.rb:408-413; 032_Chapter7A.rb:257-287; 026_Rootspire.rb:298-305 | Lysella and Myr give it almost verbatim; Cornipus adds Balanus. |
| 55 | Myconid society: castes (sovereign, tender, scribe, smith, merchant, sentry, Mnemosyne), root networks | 8607–8613 | Full | build_ch6b.rb:173-186 | All castes have an NPC on map 2068. |
| 56 | Undercanopy tensions: lake monster tainting the water, cultists through the Echo Gate, Avarice's constructs, Sephek's voice | 8615–8621 | Full | 032_Chapter7A.rb:52-66, 304-315; 026_Rootspire.rb:417-425, 1065-1082 | |
| 57 | Sovereign Luminara: voice of Hyphora, speaks "like wind through reeds"; reluctant; won't help until the lake is cleansed and loyalty proven | 8633–8719 | Changed | 032_Chapter7A.rb:215-252 | Gym 7 leader; her precondition is Yarro's blight, not the lake. Voice and character are faithful. |
| 58 | Spore Tender Yarro: healer and gardener, "voice like warm rain", scolds trampling, lullabies, remembers the first loggers | 8721–8793 | Full | 026_Rootspire.rb:398-407, 1084-1110; 032_Chapter7A.rb:175-210 | "Every step is a hand you're standing on." Rest point. |
| 59 | Spore Scribe Lysella: shelf-fungi cap, stories and secrets, trades words | 8795–8861 | Full | 026_Rootspire.rb:408-413 | "Teach me a word... 'Herald'." |
| 60 | Shroomsmith Korun: blunt, makes things, scornful puff at neglected gear | 8863–8933 | Full | 026_Rootspire.rb:414-416 | One line, but faithful. |
| 61 | Mushroom Merchant Faria: toadstool cap, gossip, barter in stories and favours, discount if amused | 8935–8985 | Full | 026_Rootspire.rb:426-428, 81; build_ch6b.rb:181 | Includes a shop. |
| 62 | Sentry Zym: acid scars from the lake monster, terse, distrusts newcomers | 8987–9053 | Full | 026_Rootspire.rb:417-425, 1079-1081 | |
| 63 | Mnemosyne Myr: ancient, many voices, keeps Hyphora's memories, reveals the name only if they swear to protect it; memory swap; dreamwalk | 9055–9137 | Full | 032_Chapter7A.rb:257-287 | The swear-to-learn-the-name beat is faithful. Memory swap and dreamwalk are not used. |
| 64 | H1 Spore Gardens: sporelings, the necrotic blight burned by fire, Secret Nursery, Yarro's lake errand ambush, root-tremor collapse | 9149–9205 | Compressed | 032_Chapter7A.rb:175-210; 036_Chapter10.rb:337-340; build_ch6b.rb:175 | Blight is Full. The collapse is reused in Alberica's Ch10 escort. Nursery and ambush missing. |
| 65 | H2 Fungal Bazaar: barter culture, spore games, outsider stall "Whispers of the Echo Gate" (Auril spy), theft of rapport amulets (kobolds), market duel | 9207–9267 | Compressed | 026_Rootspire.rb:1065-1082, 426-428 | Masked spy is Full, down to the sign. Games, theft and duel are missing. |
| 66 | H3 Council Fane: sap pool divinations and the Vision Table (wyrmlings, Sephek's mirror, tree on fire...); eight root thrones; memory niche; Rootwarden sap delegation; cultist poisoner | 9269–9337 | Missing | (the Fane is Luminara's throne room: 032_Chapter7A.rb:221) | |
| 67 | H4 Tainted Lake: iridescent slime, the monster angry at being woken by auroral warmth, acid slicks, fossilised seed of Balanus, purification ritual with Yarro, Hyphora's blessing | 9339–9407 | Full | 032_Chapter7A.rb:304-355; 026_Rootspire.rb:298-305 | "Furious at the heat that woke it." Reptin's rain replaces Yarro's ritual. Blessing granted. |
| 68 | H5 Mnemosyne's Chamber: ritual circle, memory archive tablets, silver tether threads to other planes, shadow creatures cutting threads; Memory Heist; Dream Rescue | 9409–9473 | Compressed | 032_Chapter7A.rb:261; 026_Rootspire.rb:429-430 | Stone tablets and humming threads are flavour; none of the encounters exist. |
| 69 | Undercanopy magic items and market goods (Lantern, Sap-Skin Salve, Sporechime, Seed of Renewal, Liquid Sunlight / Tarin Goldlash, Rootwrap Cloak, Hyphora's Circlet, Spore-Spear...) | 9475–9623, 9821–9848 | Compressed | 027_Relics.rb:27-36, 59-75; 032_Chapter7A.rb:206-208; 026_Rootspire.rb:1080; 024_Chapter6.rb:291-304 | The four most useful are adapted; the rest are absent (low story weight). |
| 70 | Hook: Cleanse the Lake (Luminara's request) | 9659 | Full | 032_Chapter7A.rb:317-355 | Motivated by Myr rather than Luminara. |
| 71 | Hook: Memory Trade (Myr trades lore on Auril's cult for a cherished memory) | 9663 | Missing | — | |
| 72 | Hook: Rootwarden Diplomacy (the Council demands more sap) | 9667 | Missing | — | |
| 73 | Hook: Echo Gate Shadows (Sephek's name whispered; an Auril spy in the Bazaar) | 9671 | Full | 026_Rootspire.rb:1065-1136 | |
| 74 | Long-term impact: cleansing strengthens the tree; root threads, the seed and the secret name shape the Dale | 9675–9683 | Compressed | 032_Chapter7A.rb:351; 039_Chapter13.rb:410-412 | Hyphora's Blessing, plus a later heal if Anduin is on the council. |
| 75 | Eira Shadebloom's introduction: violet-veined cap, mirror-glass spear, "cold creek over stones" voice, "Halt... Declare your purpose" | 9685–9729 | Full | 032_Chapter7A.rb:142-170 | Verbatim; she also confronts Wyn about leaving the post (a nice tie to Ch10). |
| 76 | Eira's development: lore of invisible stalkers and mirror-wraiths; missing patrols near the Auroral Wall; Fractured Halo at the Still Sky Shrine; trials for the spore-guard | 9763–9767, 9811–9817 | Missing | (one thank-you line: 032_Chapter7A.rb:164-165) | |
| 77 | The Shadow Mycolith's hoard: fungoid art, opals, Elixir of Clear Mind, reagents | 9852–9893 | Missing | — | Low story weight. |

### Tab 5/6: the Shadow Mycolith

| # | Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|---|
| 78 | The Puzzle of the Five Domains opens the encounter | 10001 | Full | 032_Chapter7A.rb:360-399 | Five carvings, one per Herald's domain (Illusion, Force, Time, Wild, Shadow). |
| 79 | Arena and boss: icy platforms over a dark lake, auroral crack, spores and shadow; half-HP enraged phase | 9897–9927, 9995–10026, 10201–10236 | Full | 032_Chapter7A.rb:401-416 | Two consecutive boss battles (base, then "Mycolith, Enraged"). |
| 80 | Lake minions: Shadow Quipper Swarms, Spore-Lash Creepers dragging heroes into the water | 9929–9993, 10008–10014 | Missing | — | Also meant to reappear in Wyn's Underdark crawl (10332). |
| 81 | Wyn receives the God-Spark of Shadow from the fallen Mycolith | 10247 | Full | 032_Chapter7A.rb:417-433 | |

### Tab 8: Chapter X, Trials of the Roots (game Ch10, with Ch9 setup)

| # | Item | Source lines | Status | Where in game (file:line) | Notes |
|---|---|---|---|---|---|
| 82 | Premise: the death of Summer/Avarice upsets the balance | 10255, 10261 | Changed | 034_Chapter8.rb:426-438 | Avarice escapes through a mirror; only Var's body dies. Not an approved change. |
| 83 | Aftermath: perpetual summer ends, the Wall thins, Hyphora's leaves brown and fall | 10255–10257 | Full | 035_Chapter9.rb:72-96 | |
| 84 | Aftermath: wool cloaks, mirrored charms against frost spirits, walls of root-timber and ice, refugees and traders arriving through the Echo Gate | 10257 | Compressed | 035_Chapter9.rb:395-407; 036_Chapter10.rb:71-72 | Refugees present (the Heralds lead them from Bryn Shander). No wall-building, charms or cloaks. |
| 85 | A divided populace: liberators vs. murderers | 10261 | Full | 035_Chapter9.rb:424-428; 036_Chapter10.rb:59-60, 117-118 | |
| 86 | The Verdant Tribunal: four seasonal wardens, crystals, witnesses; punishments (service, exile, root-binding); appeal to Hyphora's spirit in the Heartroot | 10263 | Compressed | 036_Chapter10.rb:102-124, 402-427 | Tribunal, service sentence and geas are in; exile and root-binding aren't. The appeal survives as Hyphora testifying through the crystals. |
| 87 | Social attitudes: hushed Hearth, gossip in every stall, children's ghost stories of Mirror Wraiths punishing murderers, Candlekeep scholars | 10265 | Compressed | 036_Chapter10.rb:59-60 | Two gallery lines only. |
| 88 | Election setup: two vacant seats, vote in one week; candidates Rheven, Mira, Eirwen | 10267 | Full | 036_Chapter10.rb:50-56, 115-116 | |
| 89 | Q1 Roots of Love: Anduin comes to Rootspire, fears Reptin's divinity will eclipse the tree; "what have you become?" | 10275–10283 | Changed | 035_Chapter9.rb:321-325, 354-361; 036_Chapter10.rb:129-138 | Met in Bryn Shander in Ch9 ("What have you become?") and walks south with the refugees. The fear about the tree is faithful. |
| 90 | Q1 Reconciliation role-play challenge (multiple checks, shared memories) | 10287 | Compressed | 036_Chapter10.rb:139-144 | One two-option choice ("Show him" / "Tell him about the acorn"). |
| 91 | Q1 The Heartroot's Test: skill challenge in the labyrinth; a vision of protecting vs. eclipsing; Anduin stays or leaves | 10288 | Compressed | 036_Chapter10.rb:145-165; 032_Chapter7A.rb:277 | Vision only. The outcome is keyed to `:hyphora_sworn`, which is always set, so the failure branch can't happen (logic problem 1). |
| 92 | Q1 Outcome: stewards of the Heartroot; heart-root treant wild shape | 10290 | Compressed | 036_Chapter10.rb:154-156; 039_Chapter13.rb:566-567 | Stewardship and the epilogue planting are in; no reward. |
| 93 | Q1 Evidence: cedar charm memento, plucking a golden Leaf of Hyphora, Eirwen as a witness to restraint | 10292–10296 | Missing | — | |
| 94 | Q2 Assassin's Reckoning: arrested in the Council Hall for killing Autumn; root-cell; escape option | 10300–10310 | Full | 035_Chapter9.rb:412-428; 036_Chapter10.rb:107-108, 171-185 | Arrest happens on return (with the whole party); Darrus's fall (034_Chapter8.rb:248-293) makes it her doing. The escape/outlaw option is missing. |
| 95 | Q2 Vasha's return: a hooded figure revealed as Meat Meat's mother, thought dead; pleads mercy; reconcile through apology | 10300, 10311 | Changed | 035_Chapter9.rb:45-46, 374-378; 036_Chapter10.rb:186-194 | Renamed Phildendrin (not in the sources; check with the owner). Well foreshadowed as the hooded goblin woman in Ch9; reunion at the bars, no apology beat. |
| 96 | Q2 Trial of Redemption: retrieve the cursed frost-glass mirror from the Heartroot Vault and cleanse it to commute the sentence | 10312 | Full | 036_Chapter10.rb:204-235; build_ch10.rb:67-70 | Autumn's spying mirror in the Sap Wells; Mirror Wraith; the faces are freed. |
| 97 | Q2 Evidence: Rheven admits Autumn meant to make refugees into sacrifices | 10318 | Changed | 036_Chapter10.rb:201-202 | Rheven talks about the pens instead. His flag isn't counted in `WITNESSES` (logic problem 2). |
| 98 | Q2 Evidence: Autumn's secret labs under the Council Hall (blood vials, knives, Mirror Wraith samples) | 10319 | Missing | — | |
| 99 | Q2 Evidence: Mira reveals Autumn commissioned the cursed mirror; asks a favour | 10320 | Changed | 036_Chapter10.rb:39, 200 | Mira testifies that "Darrus shipped crates to the Forge every week". |
| 100 | Q2 Evidence: refugees from Easthaven and Bryn Shander on extortion and forced labour | 10321 | Changed | 036_Chapter10.rb:41, 196-199 | Replaced by the rescued child's parents. |
| 101 | Q2 Outcome: sentence commuted, or outlaw; Vasha stays | 10314 | Compressed | 036_Chapter10.rb:409-425; 039_Chapter13.rb:561-564 | Verdict tiers (acquitted, service, geas); Phildendrin stays and can win a seat. No outlaw path. |
| 102 | Q3 Absent Watcher: Wyn accused of abandoning the Underdark post; summoned by an emissary at the Echo Gate | 10325–10327 | Changed | 036_Chapter10.rb:109, 240-250; 032_Chapter7A.rb:151-153 | Captain Kethan Vale (a source NPC from elsewhere) at the guard tunnels; Eira raises it first in Ch7. |
| 103 | Q3 Hearing: explain the absence; witnesses; Persuasion or Religion | 10331 | Compressed | 036_Chapter10.rb:109, 254-256 | The charge is read; Wyn explains at the door. No hearing scene. |
| 104 | Q3 The Underdark Door: a short dungeon crawl with Rootwarden escorts, shadow predators and invisible stalkers (quippers and creepers) | 10332 | Compressed | build_ch10.rb:25-31; 036_Chapter10.rb:252-269 | A 20×16 room with one event and no encounters. |
| 105 | Q3 Revelation: an Auril ritual circle proves cultists broke in anyway | 10333, 10339 | Full | 036_Chapter10.rb:62-63, 257-259 | Adds the Halo crown and Alberica's rune. |
| 106 | Q3 Evidence: junior Rootwarden Darrus Fell saw cultists disguised as Rootwardens | 10340 | Missing | — | Can't work as written: the source uses Darrus as both Autumn Warden (8304) and a junior Rootwarden. |
| 107 | Q3 Evidence: a Mirror Wraith at the Echo Gate shows the cultists chanting | 10341 | Missing | — | |
| 108 | Q3 Alibi from Hyphora through the crystals: "Shadow answered my call" | 10342 | Full | 036_Chapter10.rb:44, 261-263 | Verbatim. |
| 109 | Q3 Outcome: reprimand, post kept | 10335 | Full | 036_Chapter10.rb:61, 264-267 | |
| 110 | Q4 Brother from Beyond: Talion, thought dead, appears in the Blooming Fields; older; vacant; repeats phrases like a mirror echo | 10346–10348 | Changed | 036_Chapter10.rb:274-282; build_ch10.rb:33-43 | A "boy" at a cave lake under the roots (map 2078, "the Glasswater Shore"), unlocked after another trial. Talion is never mentioned earlier in the game. |
| 111 | Q4 Investigation: no pulse, skin cold as Glasswater, recited speech; Mirror Wraiths at the lake or Echo Gate call him a "reflection" | 10352 | Compressed | 036_Chapter10.rb:277-282 | Given as narration; no investigation. |
| 112 | Q4 Confrontation: "This isn't real"; memories of Alerion's resurrection attempt and a shattering mirror; Mirror-Blade Specter fight | 10353 | Compressed | 036_Chapter10.rb:281-282, 305-318 | "You touched the water when you tried to bring us all back." The fight happens only on the "keep" branch. |
| 113 | Q4 Resolution: a night ritual at the Mirror-Lake with Alerion's necromancy, Mira's frost-glass mirror and a memento, or accept the fade; he may become fully alive | 10354, 10360–10362 | Compressed | 036_Chapter10.rb:288-318 | Binary choice: let go or keep. No ritual, no Mira, no memento, no restoration. |
| 114 | Q4 Mirror Wraith riddle: "Echoes fade when embraced; reflections devour when chased" | 10363 | Full | 036_Chapter10.rb:285-287 | Verbatim. |
| 115 | Q4 Outcome: closure, or a vengeful specter later | 10356 | Compressed | 039_Chapter13.rb:204; 039_Chapter13.rb:576 | Released Talion gives a warm voice in the Test of Isolation. No later specter on the other branch. |
| 116 | Q5 Spores of Contention: Winter and Spring charge Alberica with bringing myconid spores up | 10367–10369 | Full | 036_Chapter10.rb:110-111, 328-329 | "(under her breath) I sneezed." |
| 117 | Q5 Debate before the Council | 10373 | Missing | — | |
| 118 | Q5 Journey: escort the councillors to the colony through glowing caverns; Mirror Wraith warning | 10374 | Compressed | 036_Chapter10.rb:332-341 | Two wild battles plus the ceiling collapse. No wraith warning. |
| 119 | Q5 The Verdict: Luminara explains the spores nourish Hyphora; persuade the councillors or the myconids must leave | 10375, 10377 | Changed | 036_Chapter10.rb:342-357 | Luminara forgives and shows the memory bubble of Var. Can't fail; no exodus. |
| 120 | Q5 Outcome: the colony is recognised; Alberica becomes Fungal Liaison | 10377 | Full | 036_Chapter10.rb:349-356 | |
| 121 | Q5 Evidence: Luminara blesses a fallen leaf; Winter's fear of blight and a frostbite potion; History scrolls; Wyn and Reptin testify | 10379–10384 | Missing | — | |
| 122 | Q6 Summons: town criers in the Rooted Hearth, a carpenter needing help with the wall | 10388–10390 | Compressed | 036_Chapter10.rb:102-124 | The Tribunal opens directly. |
| 123 | Q6 Read-aloud: snow in the plaza, a child crying "Murderers!" and hushed, four chairs with two empty | 10392–10394 | Full | 036_Chapter10.rb:105-106, 117-118 | |
| 124 | Q6 Evidence: Slaudi, the two-fingered fisherman, on diverted caravans | 10400 | Missing | — | |
| 125 | Q6 Evidence: the myconid memory bubble of Avarice fusing Mirror Wraith essence with spores | 10401 | Changed | 036_Chapter10.rb:45, 342-354 | The bubble shows Var "peeling his own face back like a mask". |
| 126 | Q6 Evidence: a Mirror Wraith echo of Avarice ordering them to watch Ten-Towns for sacrifices | 10402 | Changed | 036_Chapter10.rb:43, 297-298, 313-315 | Replaced by Talion's (or the wraith's) lake-mirror testimony: "The tall gold man had no reflection." |
| 127 | Q6 Evidence: the Ledger of Corruption in Avarice's council-tower quarters ("Project Rime – reforge the Everlasting Summer"); Rheven's sigil-horns; civic outreach, wall building, electioneering, nominations and debates; Trial and Verdict; election results | 10403–10431 | Compressed | 036_Chapter10.rb:36-48, 402-466; 037_Chapter11.rb:184-221; 026_Rootspire.rb:348-349 | **Missing:** the ledger raid (Hew's ledgers stand in; Eirwen's Naerth ledger is set up and never used at the trial), Rheven's horns, outreach and wall building, the winter-wolf defence, petitions and debate questions. **Changed:** platforms for Mira ("Free water") and Eirwen ("The truth, published"). **Full:** the five candidates, the verdict tiers by witness count, the winners shaping the Act III voyage (ship, griffons, whale, bell). |

*Row 127 groups the end of Quest 6. Splitting it out would add about six Missing rows and two Full rows to the counts in section 1.*
