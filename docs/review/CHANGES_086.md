# 0.8.6 (2026-11-09): sprite audit, three ending panels

## Sprite audit (`tools/sprite_audit.py`)
Every FT_ sheet was measured against the base game's 205 overworld sheets (320x320) for five faults: bare
edges (colour touching the background with no outline), one-pixel unoutlined lines, stray pieces, colours too
close in value, and front-only hats.

- **Bare edges.** The base game's median is 9% of the silhouette's edge and its 90th percentile 41%.
  - Twenty-two sheets sat at 20–80% and were outlined all round: Shimmer, Hlin, Matron Eline, Selrae, Thredra,
    Var, Iskra, the four myconids, the four duergar, the halo disciples, the devil priest, the coldlight walker,
    possessed Mira, Avarice reforged and Prototype 3.
  - Twenty-three more had only their white or pale edges (hair, fur, ears) closed, because those vanish against
    snow: Meat Meat, Hellen, Pip, the Wennen, Wynsnow, Reptin, Alerion, Sephek, the Speakers and others.
- **Stray pieces.** Myconid Eira's walk frames had broken into floating bits. Outlining rejoined them.
- **Derived sheets regenerated:** P-MM-01/02/03, P-SEP-02/05/06, P-SHI-02/03/04, P-THR-02/04, FT_thredra_echo,
  FT_var_cracked and FT_sephek_frozen.
- **Hats:** none are front-only. The checks it flagged were hair shading.
- **Left alone:**
  - Value spacing is reported but not changed, because it needs an eye.
  - Props and effects (fire, steam, spores, bees, the fishing line, Sephek's ice) are meant to have no outline.
  - The P- and K- sheets that are mostly effect (ice, breath, glow) were also left as they are.

## Old Alberica (`FT_alberica_old`, Ch13 coda)
The batch-04 sheet had a different face and a grey chin that read as a beard. It's now Alberica's own sheet
(`posegen.py v_alberica_old`): beardless, braids gone white with their edges outlined, the cap and tunic faded.

## Panels
- **S-21** (Hellen's wall, the new carving): installed as delivered.
- **S-22** (the Hearth, a year later): Meat Meat's face, ears and hand recoloured goblin green, and three
  near-black duplicates merged to stay at 64 colours.
- **S-23** (Old Alberica in the Chasm): the tiny figure was all cave-blue, so her cap was given a faded purple and
  her tunic a muted orange. She's recognisable in the last picture of the game.
- **S-16** dropped: S-12b already shows Grimskalle out of the fog and now plays under those lines.

## Cast reference
Old Alberica, Hellen, Tamsin, Zenith, Luna and the Wennen were added for the remaining panels.
