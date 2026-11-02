# Re-audit A: sources/drive/session_log.md (all 2,681 lines)

Source: `/home/claude/frost-thaw/sources/drive/session_log.md`. Tab 1 (L1-106): Bloom Guard dream visions, Auril's Whisper, Omens, Narrative Use. Tab 2 (L108-2681): The Cackling Chasm module.

Main game code checked (all paths are under `/home/claude/frost-thaw/`):
- `game/Data/Scripts/998_FrostThaw/023_Chapter5.rb`: the Chasm, Ch5
- `game/Data/Scripts/998_FrostThaw/044_ChasmFaithful.rb`: the Chasm build-out
- `game/Data/Scripts/998_FrostThaw/022_Chapter4.rb`: the hag at Dougan's Hole and the bargain
- `game/Data/Scripts/998_FrostThaw/045_HoledUp.rb`: the starving pack and the bite
- `game/Data/Scripts/998_FrostThaw/026_Rootspire.rb:891-956`: the visions
- `game/Data/Scripts/998_FrostThaw/048_Rootspire_E_Nights.rb:35-142`: the omens
- `game/Data/Scripts/998_FrostThaw/037_Chapter11.rb:37-80`: the Whisper
- `game/Data/Scripts/998_FrostThaw/039_Chapter13.rb:630-645`: the ghost payoff
- Builders: `tools/build_ch5.rb` (every Chasm event), `tools/build_ch6b.rb:114-122` (the twin orb), `tools/build_act3.rb:46` (the Whisper autorun)

## 1. Summary

I audited 151 table rows: 150 story elements, plus one row that records only a bug.

| Verdict | Count |
|---|---|
| Full | 118 |
| Compressed | 13 |
| Changed | 17 |
| Missing | 2 |
| Bug-only row | 1 (#38, the omen gate) |

No whole element is unreachable. One branch is: the ghost catching the knife (row 10). Three more small lines are missing but sit inside Full rows (listed in row 32).

**Judgement:** this slice is in very good shape. The Cackling Chasm module is adapted almost line for line:
- every keyed area, every boxed-text beat and every optional encounter (pit, rift floor, coldlight walker, coven sister on Hard)
- the ghost's full lore dump, every boon, all three endings, the loot, the legacy and the epilogue tokens

Every builder event in `tools/build_ch5.rb` calls a function that exists, and its switch conditions can come true.

Tab 1 is also present. All five visions have their setting, their memory and both fates. All five omens are there, with three tiers that turn harsher. The Whisper exists and an autorun reaches it.

What is not right:
- **One real sequencing bug.** The hidden sanctum opens before the Guardian's Gate, so the ghost talks about "the same rite you used" when you haven't used it.
- **One promised payoff never comes.** The ghost tells you who Glimmer was with "You'll see. Not yet", and the game never comes back to it.
- **Reptin's aftermath arc is changed.** He doesn't stay behind as guardian or send word by wolf or raven, and his vow to come back is never picked up.
- **Several Tab 1 lines are trimmed.** The Whisper loses three clauses. Glimmer's memory loses "her body became the Verdant Reversal's seed".
- **A handful of small continuity bugs.** The pendant is "still there" after it broke. There are wyrmling and mirror timing slips. The omens' stop-gate flags are never set.

None of this blocks play.

## 2. Every row that is not Full, ranked by importance

### 1. BUG: the hidden sanctum can be entered before the Gate is opened. The ghost then talks about a rite you never did. (Unreachable-order / contradiction)
- **Source:** L1638-1656. The seam is found as the door opens or during the door puzzle.
- **What the code does:**
  - `023_Chapter5.rb:647-653`: `hollow_wall` lets you in when `flag?(:gate_open) || flag?(:order_locket)`.
  - The locket is picked up in Area 1 (`023:277-292`), which almost every player does.
  - The hollow wall sits on the approach passage before the gate (`tools/build_ch5.rb:200`, x34,y8; the gate is at y4).
  - So most players meet the ghost first, and she says "I sealed the doors from the inside, with the same rite you used" (`023:708`).
  - The gate's flashback ("a robed dwarf woman performing this same rite", `023:619`) then plays after you've already met her.
- **Fix (either one):**
  - Gate the wall on `gate_open` only, and keep the locket's warmth as a hint ("The locket grows warm. Something is behind this ice.").
  - Or branch line 708: `flag?(:gate_open) ? "...with the same rite you used." : "...with the rite on that door. You'll see."`

### 2. Missing payoff: who Glimmer was (Changed + dangling)
- **Source:**
  - L852-874: the journal signed "Glimmer", "desperate to save Alberica".
  - L2368-2382: wrap-up threads for Glimmer.
- **Game:**
  - The journal is in (`023:392-407`; `044:830-841`).
  - The ghost's answer to "Who was Glimmer?" is "You'll see. Not yet." (`023:796-798`).
  - Shade says in the fall: "Glimmer. That name again." (`044:784`).
- **The problem:**
  - Nothing after Ch5 reads `read_glimmer_journal` or the journal item. `029_Glimmer.rb:112-117` reacts only to `heard_of_glimmer` (the carved cat).
  - Shade becoming Glimmer never touches the dead Glimmer's journal.
  - The corpse is "a half-chewed human skeleton" (`023:393`), while Glimmer is a cat-man.
- **Fix:**
  - In `glimmer_arrives` (`029:112`), add a branch for `$PokemonBag.pbHasItem?(:FT_GLIMMERJOURNAL)`. Glimmer reads the journal, recognises his own hand from a turn of the wheel ("desperate to save Alberica... I'm still trying"), and the ghost's "You'll see" is paid off.
  - Change "human skeleton" to "a skeleton too long in the arm to be human, with claws".

### 3. Reptin's aftermath: stays as guardian, and sends word by wolf or raven (Changed / Missing)
- **Source:**
  - L2424-2430: he may stay as guardian and part with a vow.
  - L2582-2586: he becomes the region's protector and sends messages by wolf or raven.
  - L2310-2312: he volunteers to watch the Heart.
- **Game:**
  - `044:736-738`: "If I could stay, I'd stay. I'll come back. I swear I'll come back." It sets `:reptin_warden_vow`.
  - `044:740-742`: he answers the wolves.
  - `:reptin_warden_vow`, `:reptin_wolf_calm` and `:order_wardens` are never read anywhere (grep).
  - Changing it is a reasonable integration choice (Reptin is a Herald and has to stay in the party). But the vow is never kept and the wolves are never heard from again.
- **Fix:** add one Act II or III beat that reads `reptin_warden_vow`. For example, a wolf or raven arrives at the Hearth with news of the Chasm (a Rootspire night event in `048_Rootspire_E_Nights.rb`), or Reptin's line in the Ch13 epilogue (`039:620ff`) has him going back to the Chasm.

### 4. Reptin fighting at the Heart (Missing)
- **Source:**
  - L2006-2020: he fights as a werewolf ally, wolf against winter wolf, or turns on anyone who tries the sacrifice.
  - L2232-2236: his inner wolf surges to help.
- **Game:** he is only frozen to the knee by the hag (`023:911-919`) and freed at `023:958`. He takes no part in the Kanan/troll fight or the hag fight (`023:823-852`).
- **Fix:** in `minions_round` (`044:447`), round 2: "Reptin tears free of the frost and goes for Kanan, wolf against wolf" (a small damage chip on Kanan, the same pattern as the mother yeti's `lv = 3`). Optionally, an extra `hag_lunge` option, "Let the wolf out", when `reptin_charge` is set.

### 5. Auril's Whisper to Alberica (Compressed)
- **Source:** L47-69. Five lines, and a close: "they cannot escape their fates, and the wheel turns for me".
- **Game (`037_Chapter11.rb:53-62`):**
  - "dark half guards silence": "a sentinel chained to frost" is dropped.
  - "Life and death march only as long as they move": "stop them, and all is mine" is dropped. (The tier-3 omen has it, `048_E:93`.)
  - "The spark carries grief, but grief burns brighter than love" becomes "The spark is spent". That change is fine, because Glimmer is dead by Ch11 (owner decision).
  - The close becomes "Come and be beautiful forever". The fates and wheel line is gone.
  - The Whisper is reachable: `037:30` sets SW_CH11_HEARTH, and `tools/build_act3.rb:46` holds the autorun.
- **Fix:** restore "a sentinel chained to frost", "stop them, and all is mine", and "Guard them if you must. They cannot escape their fates, and the wheel turns for me", before "Come and be beautiful forever".

### 6. Glimmer's vision memory (Changed) and its two timing slips (bugs)
- **Source:** L35. Shimmer's last breath, "the way her body became the Verdant Reversal's seed"; he weeps, and in the tears he sees fire.
- **Game (`026_Rootspire.rb:937-938`):** "Something in your chest is grief, and it burns. It's been burning since the mirror." The seed idea is dropped (in the game the seed is the golden acorn, and Shimmer's death leaves a rose and a heart of ice, `015:392-394`). The weeping and the fire in the tears are dropped too.
- **Timing slip 1:**
  - Both `twin_orb` (`026:850-856`) and `lumen_shard` (`029:61-63`) only need `twins_met`.
  - So you can see the orb before Shade has gone through the Rift mirror, and the vision then says "since the mirror" about something that hasn't happened.
  - The vision also treats Shade as Sparkbearer before Brightmane has called them.
- **Timing slip 2:** the fates say "the wyrmlings wake" (`026:940`) and "two wyrmlings tremble" (`026:953`), but at the orb the dragons are already grown and "bigger than houses" (`024:480`).
- **Fixes:**
  - Restore "He weeps, and in the tears he sees fire." Tie Shimmer's gift to the seed: "her heart of ice in the root the acorn woke".
  - Branch "since the mirror" on `flag?(:glimmer_joined)` (otherwise use "since the Glade").
  - Change "wyrmlings wake" to "the dragons blaze with life", and "two wyrmlings tremble" to "two dragons cower".

### 7. BUG: the pendant is "still there" (contradiction)
- `026_Rootspire.rb:456`, a college party-chat line: "I'm checking my neck for the pendant anyway. ...Still there. Shame."
- But the pendant broke and was lost in Ch3 (`015:403-404`: "The pendant is gone"), and the vision and omens are built on "where her pendant used to hang" (`026:923`, `048_E:64`).
- **Fix:** "...Still gone. Of course it is."

### 8. BUG: the omens' stop-gates are dead, and "harsher if she strays" became "harsher by chapter" (bug + Changed)
- **Source:** L94-102. The omens are present every session, and turn harsher *if Alberica strays*.
- **Game:**
  - The three tiers are keyed to chapter (`048_E:101-105`), not to anything Alberica does. That is Changed.
  - `omen_check` returns early on `flag?(:ch11_whisper)` (`048_E:109`), and `hearth_night` on `flag?(:ch11_started)` (`048_E:149`). Neither flag is set anywhere; the Whisper sets `:auril_whisper` (`037:72`). So omens keep firing after the Whisper that was meant to cap them.
  - The header says `:omens_seen` "counts them for the Ch11 whisper" (`048_E:14`), but `037` never reads it.
- **Fixes:**
  - Change both gates to `flag?(:auril_whisper)`.
  - In `scene_auril_whisper`, add a line when `counter(:omens_seen) >= 3`: "AURIL: You've seen them. Every sign. You told no one."
  - Optionally move a tier forward when Alberica makes Auril-leaning choices (for example `saw_auril_bryn`, which is set at `014:568` and never read).

### 9. The ghostly woman's warning on the bridge (Compressed)
- **Source:** L1394-1400. She points *upward just before* the ice chunk falls, to warn them.
- **Game:** the order along the bridge is crack (x13), slip (x16), then gust and ghost (x19) (`tools/build_ch5.rb:182-184`). At `023:571` she appears after the crack and "stands pointing at you". The warning is lost.
- **Fix:** have `bridge_crack` show the green ghost pointing up a beat before "CRACK!", with "you throw yourself flat; the ice hits where you were" (the Stage code from `023:563-574` can be reused).

### 10. Unreachable branch: the ghost catches the knife
- `044:576-580`: if you stay put, `elsif flag?(:ghost_blessing)` lets the ghost catch the knife.
- But `:locket_talisman` (checked first, `044:572`) is always set in the same scene as `:ghost_blessing` (`023:743`, `023:771`). So the branch can never run.
- **Fix:** check `ghost_caught_knife` first when `ghost_blessing` is set and `!flag?(:ghost_helped)`, or drop the duplicate.

### 11. Alerion's vision memory (Changed)
- **Source:** L11. Shimmer in another age, "her breath silver in the night, her gaze locked with his"; he was her shield.
- **Game (`026:901`):** this becomes "A unicorn of white fire walking through snow, and beside her, a man with a shield." That invents a unicorn image (it echoes Brightmane) that the source doesn't have, and loses the silver breath and the locked gaze.
- "Frostina's cry echoing across the void" and "both paths belonged to him" are also dropped.
- **Fix:** replace the line with "Shimmer, in another age, her breath silver in the night, her eyes locked on a man with a shield. Him." Add "Both roads are his."

### 12. Reptin's vision, second fate (Compressed)
- **Source:** L43. "...yet still the wheel turned, for even ruin was motion. His charge was not to choose one over the other, but to ensure both kept moving." Also "the curse bound him to hunger".
- **Game (`026:950-953`):** ends at "two wyrmlings tremble". "Mercy bound him then" keeps the mercy half only.
- **Fix:** add "Even so, the wheel turns. Even ruin is motion. Both have to keep moving." and "...as the curse bound him to hunger."

### 13. BUG: Reptin's bite moves around
- The vision says "the old wolf-bite in your arm" (`026:948`).
- Everywhere else it's his hand (`022:608`, `023:612-613`, `044:810`).
- The source says "his wound from the wolf's claw" (L41).
- **Fix:** "in your hand" at `026:948`.

### 14. BUG: hardcoded "SHADE:" lines ignore Shade as the Herald
- `023:422` ("SHADE: (already moving) That's...") and `023:528` ("SHADE: She knew her name...") are raw strings inside `say`, not `as(:shade, ...)`.
- When you are Shade, they print as if an NPC were speaking.
- **Fix:** wrap both in `as(:shade, ...)`.

### 15. BUG: the loss nightmare's wake-up location
- `044:683` says "You wake by the warm fissure".
- But the rest point (`CHASM_REST`) is only set if you used the campfire (`023:581`). If you skipped it, the whiteout sends you to your last rest elsewhere.
- **Fix:** call `set_rest_at(CHASM_REST)` in `scene_rift_arrive` (`023:536`), or make the line conditional.

### 16. The wyrmlings' WAIT picture (Changed, possible conflict with an owner decision)
- `023:1071`: "Meat Meat's face, Shade's face, and the word WAIT."
- Frostina is Alerion's (owner decision; `024:483-486`, where she bows to Alerion), and Alerion's vision is all about that bond.
- Showing Shade's face as Frostina's partner pulls against the decision that Shade/Glimmer is never a Dragoon.
- **Fix:** "Meat Meat's face, Alerion's face, and the word WAIT". Keep the four-note hum to Shade as the echo of Shimmer.

### 17. The ending where the cub is saved (Changed: integration with the Verdant Reversal)
- **Source:** L2394-2436. The winter persists, with perhaps one ray of sun; the Heart goes dormant.
- **Game:**
  - The Heart goes dormant and warm and turns toward Reptin, and the wolf lies down (`044:722-727`). Full.
  - The mirrors and the golden acorn then set off the Verdant Reversal (`023:963-1044`), from the Frost Hag notes, which thaws the Dale.
- This is an integration choice and a sound one: the module itself allows "Auril's power has weakened at least a bit".

### 18. The ending where the cub dies (Changed: it loops)
- **Source:** L2440-2474. A grim, valid ending.
- **Game:** `044:594-648` plays it in full (sun up, aurora out, Reptin cured, the howl, "Life for death"). Then `chasm_wheel_turns_back` (`044:663-674`) calls `start_loop`, and `state[:bargain_memory]` carries echoes into later turns of the wheel (`023:219`, `023:688`, `023:927`).
- This is an integration choice in keeping with the campaign's time wheel. It holds.

### 19. The failure (TPK) ending (Changed)
- **Source:** L2478-2498, the witch-queen.
- **Game:**
  - Full text at `044:651-660`, but only after you agree to the sacrifice and then lose to the Winter-Crowned hag.
  - Ordinary losses play it as a nightmare (`044:677-684`) and let you try again.
- Reasonable for a Pokémon game.

### 20. The hag's bargain hook (Changed: integration)
- **Source:** L202-208. She sends a messenger or a dream and offers a parley at the Chasm.
- **Game:** she makes the offer in person at the Twenty Stones on the Dougan's Hole night (`022:556` calls `044:802-825`). It is mandatory: the mirrors can't be broken without `hag_parley`.
- Sound. Reptin's dream hook carries the "dream" half (`023:209-218`).

### 21. "Howling in the Dark" hook (Compressed)
- **Source:** L210-216. Hunters' rumours, cackling at the new moon, and townsfolk asking you to make sure the hag can't threaten them again.
- **Game:** the lines are spread around: `022:196` (channeler), `022:395`, `023:86-91` (trapper and sign), and `022:628` (Durmoot's goal). The new-moon detail and the town's actual plea are missing.
- **Fix:** add "...on the new moon" to `channeler_mag_after`, and have Durmoot add "Make sure she never comes back up out of it."

### 22. Reptin's curse origin (Changed: integration)
- **Source:** L136-140. "A fateful encounter under a full moon."
- **Game:** he is bitten while feeding the starving pack (`045_HoledUp.rb:150-178`), which merges in Tab 1's rations memory. It shows its effect on the Laughing Waste under a full moon (`023:183-192`).
- Sound.

### 23. The locket and the ghost's identity (Changed: integration)
- **Source:** L562-576 and L1694. A *human* woman named Alberica, the last High Priestess.
- **Game:** a dwarf with the player character Alberica's own face, older and never named in Act I (`023:278-288`, `023:679-683`). She is paid off in the Ch13 epilogue as "OLD ALBERICA" (`039:635-641`).
- A strong integration choice that solves the name clash. Lost: "a brief warmth from the metal, as if someone still watches over it" (L572-574).
- **Fix (optional):** add that line to `chasm_locket`.

### 24. The child's name in the hall of illusions (Changed: integration)
- **Source:** L966-972. "Glimmer... I'm Glimmer. I'm lost."
- **Game:** "it's me... it's Shimmer" (`023:421`, `023:451`).
- Justified, since Glimmer is Shade's later name. A side effect: the false light no longer carries the name "Glimmer", which weakens the module's Glimmer thread (see row 2).

### 25. Mother yeti (Changed: owner decision)
- **Source:** L676-806. She fights to the death and is almost impossible to calm.
- **Game:** you can sing to calm her (only if you stood with Alberica in Ch2), back away, or fight to the death (`023:324-381`). If calmed, she joins the fight at the Heart (`023:826-829`).
- This matches the owner's decision (the mother lives or dies by the player).

### 26. Alberica's vision: vault name and voice line (Compressed)
- **Source:** L25. The **Vault of the North**; "the laughter, the sorrow, the betrayals and the bonds. Hold them all." Second path: "both the tender and the terrible".
- **Game (`026:921-929`):** "A vault"; the voice keeps only its first and last sentences; the second path is "she sings, and the vault shatters".
- The pendant change is correct for the game (it broke in Ch3).
- **Fix:** "the Vault of the North"; restore "The laughter, the sorrow, the betrayals, the bonds. Hold them all."; "she sings the tender and the terrible both".

### 27. Brightmane's voice (Compressed)
- **Source:** L33. "...You must carry her torch into the dark, for her spark alone is not enough."
- **Game (`026:936`):** "Her torch is yours to carry."
- **Fix:** append "Her spark alone is not enough."

### 28. The ghost absolving guilt (Compressed)
- **Source:** L1832-1834.
- **Game:** only the line about the bargain in an earlier turn of the wheel (`023:688-690`). There is no general "choose the light now".
- Minor.

### 29. The Order rekindled and the party as wardens (Compressed)
- **Source:** L2586-2592.
- **Game:** the ghost says "That's you, now. All of you." (`023:750`) and sets `:order_wardens`, which is never read again.
- **Fix:** read it in one Rootspire scene (for example the Wennen moon-charm "for wardens").

### 30. The Black Ice Staff's taint (Compressed)
- **Source:** L2512-2518. Pangs of hunger in extreme cold, and cackling in dreams.
- **Game (`044:43-44`):** "dreams of cackling" only.
- **Fix:** add "and goes hungry in the cold" to the description.

### 31. Speaker thanks the party publicly (Changed)
- **Source:** L2572-2576. A mistrustful town hails them.
- **Game:** "Don't tell anyone I said that" (`022:621-623`, `044:781`). In keeping with Durmoot's character. Fine.

### 32. Smaller dropped lines (Missing)
- Reptin saying a few words over Alberica's resting place (L2372). Not in the game.
- The hag's "Don't take another step!" (L2050). Absent; replaced by the spiteful lunge.
- "Forsake your curse" in Reptin's vision (L222). The game has "Abandon your bond and be free" (`023:192`).
- **Fix:** one line each if wanted.

## 3. Full table

Status key: **F** Full, **C** Compressed, **Ch** Changed, **M** Missing, **U** Unreachable. All file references are under `game/Data/Scripts/998_FrostThaw/`.

### Tab 1: the visions (twin orb, `026_Rootspire.rb:891-956`)

Reachable: the orb event is at `tools/build_ch6b.rb:114`. All five Heralds are in the party at Ch6 (`024:262`). The visions are optional.

| # | Element | Src | Status | Evidence / note |
|---|---|---|---|---|
| 1 | Alerion setting: black forest, Frostina's eyes, voice | 9 | F | 026:898-900 |
| 2 | Alerion memory: Shimmer in another age, her shield, Frostina carries her eyes and soul | 11 | Ch | 026:901-903 (unicorn image invented; row 11) |
| 3 | Alerion fate: sentinel at the ruins of the north | 11 | F | 026:905 |
| 4 | Alerion fate: buried beneath wings, name forgotten | 11 | F | 026:906 |
| 5 | "Both paths belonged to him"; Frostina's cry | 11 | C | dropped (row 11) |
| 6 | Meat Meat setting: meadow, Razzilith reborn, voice | 17 | F | 026:910-912 |
| 7 | Meat Meat memory: acorns, flowers, laughter | 19 | F | 026:913-914 |
| 8 | Meat Meat fate: thawed earth, roar cracks mountains | 19 | F | 026:916 |
| 9 | Meat Meat fate: cradling his muzzle as the meadow burns | 19 | F | 026:917 |
| 10 | Alberica setting: Vault of the North, faces, rune, pendant | 25 | C | 026:921-924 (row 26) |
| 11 | Alberica memory: Bryn Shander square, the pendant | 27 | F | 026:925-926, backed by 014:545-590 |
| 12 | Alberica fate: Auril's mark locks the Dale | 27 | F | 026:928 |
| 13 | Alberica fate: shatters the vault | 27 | C | 026:929 |
| 14 | Glimmer setting: Brightmane, flowers from frost, voice | 33 | C | 026:933-936 (row 27) |
| 15 | Glimmer memory: Shimmer's sacrifice, body as seed, tears of fire | 35 | Ch | 026:937-938 (row 6) |
| 16 | Glimmer fate: ignites the wyrmlings | 35 | F | 026:940 (timing slip, row 6) |
| 17 | Glimmer fate: despair gutters the torch | 35 | F | 026:941 |
| 18 | Reptin setting: graveyard, wolves, voice, wound | 41 | F | 026:945-949 (arm/hand, row 13) |
| 19 | Reptin memory: rations to the starving wolves | 43 | F | 026:948-950; event at 045_HoledUp:150-178 |
| 20 | Reptin fate: guides the living and the dying | 43 | F | 026:952 |
| 21 | Reptin fate: the beast tears free, and the wheel still turns | 43 | C | 026:953 (row 12) |

### Tab 1: the Whisper (`037_Chapter11.rb:37-80`) and the Omens (`048_Rootspire_E_Nights.rb:40-142`)

The Whisper is reached by the autorun at `tools/build_act3.rb:46`. The omens fire from hearth nights and map steps (`048_E:159`, `048_E:605`), and every trigger flag is set somewhere.

| # | Element | Src | Status | Evidence / note |
|---|---|---|---|---|
| 22 | Whisper framing: wind dies, pressure, frost | 49 | Ch | 037:51-55: Auril sits at the table, the room goes white (fine) |
| 23 | Whisper: dark half | 53 | C | 037:54 (row 5) |
| 24 | Whisper: light half, flame consumes | 56 | F | 037:54-55 |
| 25 | Whisper: memory keeps the key | 59 | Ch | 037:58: "they also lock"; original in the tier-3 omen 048_E:71 |
| 26 | Whisper: the spark | 62 | Ch | "The spark is spent" (owner-decision consequence) |
| 27 | Whisper: life and death | 65 | C | 037:57 (row 5) |
| 28 | Whisper: "my vessel... the wheel turns for me" | 69 | C | 037:60-61 (row 5) |
| 29 | Omen: Alerion, frost on his shadow, melts when she blinks | 74 | F | 048_E:41-51, three tiers |
| 30 | Omen: Meat Meat, breath curling like vines | 77 | F | 048_E:52-62 |
| 31 | Omen: Alberica, frost and warmth fighting | 80 | F | 048_E:63-73 (the throat, since the pendant is gone) |
| 32 | Omen: Glimmer, crackling, "His grief burns too hot. Watch him." | 83 | F | 048_E:74-84 |
| 33 | Omen: Reptin, heartbeat slows then quickens | 87 | F | 048_E:85-94 |
| 34 | Narrative use: Auril present every session | 96 | F | omen_check on each night and step |
| 35 | Narrative use: watcher and agent of the goddess | 98 | F | the tiers' lines |
| 36 | Narrative use: paranoia (does anyone else see?) | 100 | F | "Nobody else is looking" and similar |
| 37 | Narrative use: harsher if she strays | 102 | Ch | harsher by chapter, not by her choices (row 8) |
| 38 | Omen gate after the Whisper | - | bug | flags never set (row 8) |

### Tab 2: background and hooks

| # | Element | Src | Status | Evidence / note |
|---|---|---|---|---|
| 39 | Hag froze Dougan's Hole; the heroes thwarted her; she survived | 124-130 | F | 022:520-628 |
| 40 | Bheur hag serving Auril | 128 | F | 022:552 ("her seamstress") |
| 41 | Offer: break the curse and cure Reptin | 132-142 | F | 044:805-812 |
| 42 | Reptin's curse origin | 136-140 | Ch | the bite at the pack (row 22) |
| 43 | The Order; werewolves as wardens; Reptin a warden by blood | 146-156 | F | 023:711-716 |
| 44 | Heart absorbs life to counter death | 158-164 | F | 023:705 |
| 45 | Price: an innocent child; the yeti baby | 170-174 | F | 023:724, 811 |
| 46 | Hag's secrets: temporary, empowers her, the cure removes a warden | 176-186 | F | 023:721-723, 792-795 |
| 47 | Hook: A Hag's Bargain | 202-208 | Ch | in person at the Stones (row 20) |
| 48 | Hook: Howling in the Dark | 210-216 | C | row 21 |
| 49 | Hook: Reptin's Vision, chained wolf, crone, pull south | 218-226 | F | 023:185-218 ("forsake your curse" dropped, row 32) |
| 50 | Chasm named for the gnolls, whom the hag drove out | 230-238 | F | 023:89-91; 044:110-112 |
| 51 | Atmosphere: light, cold, ice, echoes, scent, names whispered | 240-298 | F | 044:154-176, four whisper triggers in build_ch5 |
| 52 | Escalating horror | 300-312 | F | throughout |

### Tab 2: Reptin's role

| # | Element | Src | Status | Evidence / note |
|---|---|---|---|---|
| 53 | Anxious and guilt-ridden, dreads the place | 328-332 | F | 023:131-138, 186-206 |
| 54 | Hag tempts him: "Poor boy... all that rage" | 332-336 | F | 023:210-215; 044:808 |
| 55 | Loses control in Area 2: fangs, glowing eyes | 338-342 | F | 044:197-208 |
| 56 | Hag paralyses him at the climax | 342-346 | F | 023:911-919 |
| 57 | "Take me instead!" and her scornful refusal | 346-352 | F | 023:944-947 |
| 58 | Fights as a werewolf ally; wolf against wolf; berserk surge | 2006-2020, 2232 | M | row 4 |

### Tab 2: Area 1, the Laughing Entrance

| # | Element | Src | Status | Evidence / note |
|---|---|---|---|---|
| 59 | Boxed text and the hag's illusory greeting | 374-396 | F | 023:231-243 |
| 60 | Taunts: "I smell the wolf", "the cure lies ahead" | 422-430 | F | 023:241-243 |
| 61 | Seeing through the illusion | 432-438 | F | 023:244-251 |
| 62 | Icefall trap, "Mind your head, dearies!" | 464-504 | F | 023:258-267 |
| 63 | Ice mephit ambush and death burst | 506-554 | F | 023:268-272 |
| 64 | Frozen locket: Order motif, portrait, name, warmth | 556-576 | Ch | row 23 |
| 65 | Gnoll femur in the fallen icicle | 590-600 | F | 044:97-99, 178-184 |

### Tab 2: Area 2, the Frozen Feast Hall

| # | Element | Src | Status | Evidence / note |
|---|---|---|---|---|
| 66 | Carnage: animals, trapper, dwarf, smell | 606-646 | F | 044:189-196 |
| 67 | Yeti corpse, heart cut out post-mortem | 646-658 | F | 023:299-302 |
| 68 | Blood runes: Hunger, Feast, Yeenoghu, druidic emblem defiled | 658-674 | F | 044:100-105, 212-218 |
| 69 | Mother yeti: grief, wounds, clouded eye, fights to the death | 676-796 | Ch | owner decision (row 25) |
| 70 | Collapses over her mate | 798-806 | F | 023:366-369 |
| 71 | Tracks and drag marks | 808-818 | F | 023:307 |
| 72 | Swaddling in the father's hand | 820-830 | F | 023:302-309 |
| 73 | Moral weight | 832-838 | F | 023:366-372 |
| 74 | Treasure: potion, 32gp 18sp, greataxe, ears | 840-850 | F | 023:393-399; 044:220-234 |
| 75 | Glimmer's journal | 852-874 | F | 023:392-407 (payoff missing, row 2) |
| 76 | Hag's echo: "such violence... time is ticking" | 892-896 | F | 044:237-244 |
| 77 | Reptin shaken, amber eyes; "We won't let her do this to anyone else" | 898-906 | F | 044:197-205; 023:310-314 |

### Tab 2: Area 3, the Hall of Illusions

| # | Element | Src | Status | Evidence / note |
|---|---|---|---|---|
| 78 | Glassy corridor; a reflection lingers, grinning | 910-954 | F | 023:414-416 |
| 79 | Fork: child's voice and light; weeping in the dark | 916-938 | F | 023:417-420 |
| 80 | The child names itself Glimmer | 966-972 | Ch | Shimmer (row 24) |
| 81 | Clues: air, reflections, sobbing loop, insight | 986-1022 | F | 023:429-456 |
| 82 | Left path: dead end, gnoll nest, pit, ghouls | 1040-1124 | F | 023:459-485 |
| 83 | Pit loot; "SHE LIES" / "DON'T TRUST THE LIGHT" | 1126-1144 | F | 023:487-497; build_ch5:154 |
| 84 | Hag: "Poor little lambs... did you stumble?" | 1152-1158 | F | 023:481 |
| 85 | Right path: "Don't leave me!", the sobbing stops, claw marks | 1160-1176 | F | 023:508-521 |
| 86 | Girl's reflection: "Why won't you help me?" | 1176-1186 | F | 044:374-378 (moved to the bridge) |

### Tab 2: Area 4, the Frozen Rift

| # | Element | Src | Status | Evidence / note |
|---|---|---|---|---|
| 87 | Boxed text: ledge, bridge, railing, lights, chanting, CRACK | 1224-1262 | F | 023:536-557 |
| 88 | Crossing: plans, slips, dangling, rescue, the fall | 1300-1334 | F | 044:249-322 |
| 89 | Wind gusts | 1336-1344 | F | 023:559-562 |
| 90 | Personal voices: mother's laugh, children | 1354-1360 | F | 044:356-379 |
| 91 | Ghost lights and bat-like creatures | 1366-1372, 1430 | F | 044:277-278; build_ch5:280 |
| 92 | Ghostly woman warns them (points up) | 1388-1400 | C | row 9 |
| 93 | Ghostly cackling gnoll | 1386 | F | 044:343-353 (rift floor, only if you fall) |
| 94 | Coldlight walker | 1414-1428 | F | 044:382-404 (optional) |
| 95 | Rest nook, disturbances, droning chant | 1446-1460 | F | 023:577-592 |
| 96 | 80-foot floor of the chasm | 1274-1276 | F | 044:324-341, map 2100 |

### Tab 2: Area 5, the Guardian's Gate

| # | Element | Src | Status | Evidence / note |
|---|---|---|---|---|
| 97 | Door carvings and riddle whisper; runes "Life for Death" | 1468-1518 | F | 023:596-600; 023:105-108 |
| 98 | Puzzle: blood plus bone or silence; stained bowls as clues | 1520-1580 | F | 023:601-626 |
| 99 | Wrong offering: skeleton guardians, necrotic burst, whisper repeats | 1582-1620 | F | 023:627-643 |
| 100 | Door opens: runes glow, vision of her with the wolves | 1622-1636 | F | 023:617-622 |
| 101 | Hidden seam to the sanctum | 1638-1656 | F | 023:647-653 (order bug, row 1) |

### Tab 2: Area 6, the Hidden Sanctum

| # | Element | Src | Status | Evidence / note |
|---|---|---|---|---|
| 102 | Tomb: the corpse rises, the spirit steps out | 1662-1690 | F | 023:665-683 |
| 103 | Identity: "I am Alberica" | 1694 | Ch | row 23 |
| 104 | Locket recognised, or given if not found | 1708-1710, 1808-1814 | F | 023:692-700 |
| 105 | The Order's history | 1712-1718 | F | 023:702-706 (plus the World Tree root) |
| 106 | Werewolf wardens, "Children of the Wolf" | 1718-1730 | F | 023:711-716 |
| 107 | What happened: gnolls, the seal, she gave herself to the wards | 1730-1738 | F | 023:707-710 |
| 108 | The hag's scheme | 1738-1750 | F | 023:718-723 |
| 109 | The yeti baby; "soul-debt" | 1750-1762 | F | 023:724, 788-790 |
| 110 | Reptin's cure means losing the bond; his choice; her blessing | 1762-1774 | F | 023:726-737, 791-795 |
| 111 | An alternative: a life freely given | 1776-1792 | F | 023:748-749 |
| 112 | Protective charm: illusion, cold; healing | 1794-1802 | F | 023:739-743, 768-769 |
| 113 | Silver dagger | 1816-1824 | F | 023:742-745 |
| 114 | "Child of the wolf... I am sorry" | 1826-1830 | F | 023:735-737 |
| 115 | Absolving guilt | 1832-1834 | C | row 28 |
| 116 | Final urging; tied to the crypt | 1834-1836 | F | 023:754-755 |
| 117 | Fades; prophecy; body to dust | 1842-1856 | F | 023:756-765 |
| 118 | Tips: break the staff; fire for the troll | 1870, 2094, 2170 | F | 023:746-747 |

### Tab 2: Area 7, the Heart of the Chasm

| # | Element | Src | Status | Evidence / note |
|---|---|---|---|---|
| 119 | Chamber, crystal, pillars, chained cub | 1876-1898 | F | 023:806-814 |
| 120 | The hag's full appearance and staff | 1900-1912 | F | 023:894-898 |
| 121 | Cauldron and brew | 1914-1918 | F | 044:118-120 |
| 122 | Winter wolf (Kanan) and ice troll | 1920-1926, 1992-2004 | F | 023:899-900, 823-841 |
| 123 | Greeting, cub hoisted, curse tug, "a life for a life", "honour our deal?" | 1928-1962 | F | 023:901-926 |
| 124 | Choice: agree, refuse, offer self; monologue; "Then be damned"; spiteful lunge | 2022-2054 | F | 023:930-959 ("Don't take another step!" missing, row 32) |
| 125 | Tactics: flight on the staff, illusions, Heart lair actions, troll regenerates, mid-fight offer | 2056-2134 | F | 044:429-515 |
| 126 | Coven sister disguised as an ice statue | 1980-1986, 2138-2142 | F | 044:518-530 (Hard only) |
| 127 | Ghost intervenes once | 2148-2154 | F | 023:866-878 (knife branch U, row 10) |
| 128 | Cub in peril; freeing the chains | 2100-2188 | F | 044:484, 566-570 |
| 129 | Hag's last lunge at the cub | 2126-2130, 2216-2230 | F | 044:544-590 |
| 130 | Mirrors, Reflection, acorn third way | - | Ch | from other notes; integration (row 17) |

### Tab 2: endings

| # | Element | Src | Status | Evidence / note |
|---|---|---|---|---|
| 131 | Cub saved: Heart dormant, Reptin's purpose, cub cooing | 2394-2414 | F | 044:689-727 |
| 132 | Cub saved: winter persists | 2410-2420 | Ch | the Verdant Reversal (row 17) |
| 133 | Reptin stays as guardian, vow | 2424-2430 | Ch | row 3 |
| 134 | Cub to safety: mother, wolves, or your team | 2430-2434, 2294-2302 | F | 044:709-719 |
| 135 | "Leave it": the Heart must not be destroyed | 2304-2308 | F | 044:728-735 |
| 136 | Cub died: sun rises, Reptin cured, the howl, "life for death" | 2440-2470 | F | 044:594-648; loops (row 18) |
| 137 | Failure: the witch-queen of the North | 2478-2498 | Ch | 044:651-660 (row 19) |

### Tab 2: rewards and legacy

| # | Element | Src | Status | Evidence / note |
|---|---|---|---|---|
| 138 | Black Ice Staff and its taint | 2512-2518 | C | row 30 |
| 139 | Cauldron: opals, counterspell scroll, cold potion, black ice ring | 2518-2526 | F | 044:752-762 |
| 140 | Winter wolf pelt | 2526-2530 | F | 044:763-766 |
| 141 | Locket: portrait now smiling, Bless once a day | 2530-2538 | F | 044:866-896 |
| 142 | Druidic Codex, with the recharge ritual | 2538-2546 | F | 044:409-422, 843-849 |
| 143 | Heart fragment | 2546-2554 | F | 044:769-773 |
| 144 | The Order's chest of ritual tools | 2326-2332 | F | 044:767-768 |
| 145 | Wildflower; watchful wolves | 2556-2564 | F | 044:779-780, 740-742 |
| 146 | Brief respite for Ten-Towns; the Speaker's thanks | 2566-2576 | Ch | row 31; the Reversal |
| 147 | "Glimmer in the Chasm" song | 2576-2582 | F | 044:782-783 |
| 148 | Reptin as protector; wolf or raven messages | 2582-2586 | M | row 3 |
| 149 | The Order rekindled; the party as wardens | 2586-2592 | C | row 29 |
| 150 | Auril's wrath: the rimed owl feather | 2592-2602 | F | 044:644-646, 792-795 |

### Tab 2: epilogue

| # | Element | Src | Status | Evidence / note |
|---|---|---|---|---|
| 151 | Dream of Alberica and the glowing child; the wolf-and-bloom carving; legend; laughter and howl; the journal's hidden line | 2604-2678, 2368-2382 | F | 044:785-799, 837-840 (in the fall; Reptin's words over her grave missing, row 32) |

## Other observations (not counted)
- Every function that `tools/build_ch5.rb` calls exists in `023` or `044`, and the switch-gated pages (3927-3932, 4002-4005) all have flag syncs (`023:1115-1123`; `044:1070-1078`).
- The rift floor is reached only by falling: choose "Just walk across", then "Grab for the old railing". `044:290-296` confirms the rescue always finds a companion otherwise.
- `give_key` refuses duplicates (`031_StoryItems.rb:41-43`), so the owl feather given in both the dark ending and the keepsakes, and key items kept across loops, do not stack.
- Memory used: none. Nothing in the user's memory bore on this slice beyond the general audit preference ("no shortcuts... audit to confirm nothing was cut short", from the preferences block), which this report follows.
