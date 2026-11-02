## Flags and switches others can rely on

| Flag / value | Set when | For |
|---|---|---|
| `:heist_delivered` / `:heist_exposed` / `:heist_destroyed` | the reliquary's three endings (048_D `heist_delivery`) | W4's Ch10 witnesses |
| `:darrus_redeemed` | Darrus, hiding at the Run's moorings, offers to fund the voyage north | W4 (White Vault transport/funding) |
| `:oath_of_roots` | the Oath of Roots at the living pillar in Rootwarden Hall | W4 Ch10 |
| `:talion_foreshadowed` | the Echo Gate's boy's voice, or TALION frosted on the Frozen Hunter's lips | W4 Ch10 (Brother from Beyond) |
| `:sigil_echo`, `:sigil_eirwen` | the Echo Gate's sigil (now flagged), Eirwen's (a second FT_FROSTSIGIL) | W3/W4 (the third is `:sigil_sephek`) |
| counter `:omens_seen` | each of Auril's fifteen omens on Alberica (048_E) | W4's Ch11 whisper |
| `state[:favour]` `{spring:, winter:, autumn:, summer:}` | faction standing (Autumn's visit, vignettes, petitions) | W4's Vote |
| `:council_support`, `:rootspire_haven` | Council Petitions won; the Festival of Balance accepted (after `:engine_dead`) | W4 |
| `:scale_core_given` (key item FT_SCALECORE) | the Requiem's relic vault, after `:mira_freed` | W3/W4 (Avarice's Seraph-Draco plan) |
| `:chardalyn_found` (FT_CHARDALYN), `:chardalyn_vision` | after the festival; Brightmane's answer | W3 (the Forge) |
| `:ash_exposed`, `:still_beast_alive`, `:eren_pupil`, `:kelyn_secret`/`:kelyn_surge`, `:selrae_white_womb`, `:eline_named_selrae`, `:cellar_cleared`, `:souls_ledger_seen`, `:frozen_run_done`/`:corsair_favour`, `:glimmer_rite_done`, `:alerion_reflection`, `:codex_fragments` | the city's quests | anyone |

Switches: 4160-4177 (048_A, 048_E). Maps: 2180-2199.

## Merge notes

- **024_Chapter6.rb**: Hellen's rest now ends with `hearth_night` (a night in Rootspire); the festival scene calls
  `festival_opening`, `festival_toast` (the Frost Saint effigy attempt), `festival_shudder_extras`, `festival_voices`;
  Kelyn's first Council scene adds the motto, "A Season Too Long", Selrae's martial law and `selrae_court`; Eline's rite
  calls `eline_conversion`; the arrival read-aloud is in full.
- **026_Rootspire.rb**: `twin_orb` fights the Halo splinter first (`orb_halo_scene`); `bloom_guard_visions` rewritten
  (all five, with fates; a `:glimmer` branch); `echo_wraiths` sets `:sigil_echo`, foreshadows Talion and runs
  `echoes_at_the_wall`; `frozen_hunter` foreshadows Talion; `lumin` runs `lumin_rite`; `wynsnow` runs the Chronal Debt
  and the sigil research; Nivva no longer says she doesn't sell the muddled potions.
- **Builders**: `tools/build_rootspire_life.rb` is new and runs after `build_ch6b` in `build_all.sh`. `build_ch9`,
  `build_ch10` and `build_act3` reopen 2050/2053/2054/2055/2056/2061, so after rebuilding ch6/ch6b, rerun everything
  after them (build_all does). In `build_ch6.rb`, Darrus, Selrae, Ivran now call functions instead of `FT.talk`, and
  Ash's after-battle page calls `FT.warden_ash` (hidden on 4163). In `build_ch6b.rb`, Eirwen and the Lorn Scribe call
  functions; the Canopy has a door to the Promenade at (9,12).
- **tools/check_all.rb**: the switch check now accepts 3900-4199, matching `019_Switches.rb`.
- **Darrus**: if exposed in the heist he flees to the Corsairs (the Run's moorings) as the notes say. W3's Ch8 Darrus at
  the Forge (034) should check `:heist_exposed` / `:darrus_redeemed`.
- **New trainer types**: FT_ARVIK, FT_ARVIK2, FT_WATCHMAN, FT_TURNCOAT (Ash, unmasked), FT_DREAMER (Eren, frost-touched),
  so no [class, name] collides with Ch6's Ash or the Fields' Eren.
- **Smoke test**: 176/181; the five failures (Grass-starter pictures shipped, four cup-game pictures) fail the same way on
  the unmodified scripts, from pictures missing in this environment.
