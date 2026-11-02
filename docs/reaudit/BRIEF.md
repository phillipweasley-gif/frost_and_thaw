# Re-audit brief (shared by all five re-auditors)

You are auditing whether a Pokémon fan game now faithfully covers its source material. The owner's rule:
no shortcuts. Be skeptical and thorough. Read only; do not modify any file under /home/claude/frost-thaw.

## The game
"Pokémon Frost & Thaw", an Infinite Fusion (Ruby, Essentials v19) mod adapted from the owner's D&D campaign
"Rootspire" (which began in Rime of the Frostmaiden + The Cackling Chasm). Player characters ("Heralds"):
Alberica (dwarf bard), Reptin (wolf-touched elf druid), Alerion, Meat Meat (goblin; she/her), Shade (becomes
Glimmer), Wyn (Rootwarden). NPC Shimmer is Shade's companion who sacrifices herself.

- Story code: /home/claude/frost-thaw/game/Data/Scripts/998_FrostThaw/*.rb (all files, incl. 044_*-048_*).
  Dialogue is in say([...]), sayc, speak, as(...), cl(...), lines_for/talk keys.
- Map builders: /home/claude/frost-thaw/tools/build_*.rb (build_all.sh lists the order). An event exists in the
  game only if a builder places it on a map with a script calling the function. Compiled maps are in
  /home/claude/frost-thaw/build/maps/MapNNNN.rxdata (Marshal; json previews beside them).
- Something counts as "in the game" only if a player can actually reach it: the function exists AND a map event
  (or another reachable scene) calls it AND its switch/flag conditions can become true. Check this for every row.

## Owner decisions (do not flag these as errors)
- Shade -> Glimmer at the Rift (Ch6); Glimmer dies at the Forge (final). No brother. Alerion and Meat Meat are
  Dragoons (Frostina/Razzilith); Shade/Glimmer never. Meat Meat she/her, long white hair, violet eyes.
- Var/Avarice: keep the twist that Avarice has worn Var's body 30 years, but Var's own story is restored.
- Avarice fakes her death at the Forge; Ch10 runs on everyone believing she is dead; revealed alive later.
- Meat Meat's mother is Phildendrin. The mother yeti lives or dies depending on the player.

## Integration choices made during the build (judge these; say if you think they betray the source)
- If Darrus is exposed in the Verdant Heist he flees to the Corsairs, and Maera Vell takes Autumn's place at the Forge.
- A Rootwarden called Pell stands in for the notes' junior warden in the Mirror Maze (notes name Darrus).
- Wyn's spore colony is "the Undercity", the deep end of the one Smuggler's Run.
- Razzy's first scale is in Avarice's Forge root-vault; Mira's Corsair vault holds a "wyrmling scale core".

## Report
For EVERY story-bearing element in your slice: Full / Compressed (what's lost) / Changed (how; owner-decision or
integration-choice or neither) / Missing / Unreachable (code exists but no player can get to it). Skip pure GM
mechanics (stat blocks, DCs, prices) unless they carry story. Also list bugs you find (logic that can't trigger,
contradictions between scenes, text that refers to things that never happened).
Write markdown to the path your prompt gives: (1) summary with counts and an honest judgement, (2) every row that
is NOT Full, ranked by importance, each with source lines, file:line evidence and a concrete fix, (3) the full table.
Your final message: the summary and the not-Full list.
