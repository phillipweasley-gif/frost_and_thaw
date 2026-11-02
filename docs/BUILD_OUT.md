# Faithful build-out (Nov 2026)

Goal: every story element in the owner's notes and sources is in the game, faithfully.
The five audits in docs/audit/ list each element as Full / Compressed / Changed / Missing.
Every Compressed, Missing and unapproved Changed row in a worker's slice gets built in full.
No shortcuts: no "rumour only" stand-ins, no one-line summaries of scenes the notes play out,
no dropped choices, no unreachable content. Locations the notes describe get real maps.

## Owner decisions
- Approved earlier: Shade -> Glimmer at the Rift (Ch6), Glimmer dies at the Forge (final);
  no brother; Alerion and Meat Meat are Dragoons (Frostina / Razzilith), Shade/Glimmer never;
  Meat Meat she/her, long white hair, violet eyes.
- Var/Avarice: KEEP the coat twist (Avarice has worn Var's body 30 years), and ADD BACK Var's
  own story from the notes as the man whose body she took (ancestor who served Naerth, the
  Corsair arms deal, the mirror-shard glaive, wanting to test Alerion).
- Avarice FAKES HER DEATH at the Forge. Ch10 runs on everyone believing she is dead; she is
  revealed alive later (White Vault thread, Ch11-13).
- Meat Meat's mother is Phildendrin (keep).
- The mother yeti lives or dies depending on how the player handles her fight.
- Everything else the audits flag as Changed: follow the notes.

## Workers, files, ranges
| Worker | Slice | Owns | New maps | Switches |
|---|---|---|---|---|
| W1 | Act I: Cackling Chasm, Sephek, hag's bargain, Thredra, Chasm aftermath | 015, 022, 023, build_ch3/4/5 | 2100-2119 | 4000-4039 |
| W2 | Act I: Ten-Towns (Targos, Bryn Shander, Lonelywood towns, Good Mead, Dougan's Hole), RotF side quests, geography fixes | 005, 014, 016, 017, 030, build_targos, build_act1, build_ch2, build_prologue | 2120-2139 | 4040-4079 |
| W3 | Heartroot Labyrinth zones III-VI, the Rootsun Forge (all rooms), Avarice fake death, Var's story, Ch7B, Ch8, Ch9 | 025, 028, 033, 034, 035, build_ch7, build_ch7b, build_ch8, build_ch9 | 2140-2159 | 4080-4119 |
| W4 | Ch7A remainder, Ch10 trials and civic layer, Ch11-13, White Vault, Sephek avatar, Wyn's quests, Beyond the Wall, rifts | 032, 036, 037, 038, 039, 040, build_ch7a, build_ch10, build_act3 | 2160-2179 | 4120-4159 |
| W5 | Rootspire city and Ch6: Bloom Guard visions, Auril's Omens, downtime week, factions, NPCs, night events, shops, Darrus/Verdant Heist, Kelyn, Rheven, Eren, Corsairs, chronal quests, Glimmer intrigue, unreachable scenes | 024, 026, 027, 029, build_ch6, build_ch6b | 2180-2199 | 4160-4199 |

New scripts go in new files numbered 044+ (W1: 044_*, W2: 045_*, W3: 046_*, W4: 047_*, W5: 048_*).
Shared files (001-013, 018-021, 031, 041-043, check_all.rb, smoke_test.rb): small, local edits only.
Register new maps/flags/items with the existing merge!/list patterns, ideally from your own file.

## Cross-worker flag contract
- :avarice_faked_death (W3 sets at the Forge) / :avarice_revealed (W4)
- :var_story_known (W3)
- :ledger_found (W3, Ledger of Corruption / "Project Rime"), :autumn_labs_seen (W3)
- :heist_delivered / :heist_exposed / :heist_destroyed (W5) -> Ch10 witness (W4)
- :oath_of_roots (W5, Rheven's trial) -> Ch10 (W4)
- :talion_foreshadowed (W5, Echo Gate / Frozen Hunter) -> Ch10 (W4)
- :sigil_echo (exists), :sigil_eirwen (W5), :sigil_sephek (W4); :vault_map_1 (exists) / :vault_map_2 (W3) / :vault_map_3 (W4)
- :hag_bargain_offered / :hag_bargain_taken (W1) -> later callbacks anyone may use
- :omens_seen counter (W5)

## Testing
- Own test copy: tools/make_testgame.sh /home/claude/pifrun_<W>; sync with tools/sync_testgame.sh.
- Run headless with PIF_DIR=/home/claude/pifrun_<W>. Machine has 2 CPUs / 7 GB:
  wrap every story_run in `flock /tmp/ft_heavy.lock` (one at a time across workers).
- Smoke test must stay green; add checks for what you build.
- Art: reuse existing sprites; log every new art need in docs/art_requests_<W>.md.
