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

## Later on 9–10 November
- **Panels in:** S-24a–d (the Test's four doors), S-03 (the lottery pendant, Alberica's cap recoloured purple by
  the designer), S-06 (the Moon Requiem, Zenith's robe recoloured green and her rose by the designer), and S-00
  (the Heralds' carving on Hellen's wall). Every `Stage.panel` call now has its picture.
- **Wennen arms** (`tools/wennen_arms.py`): the robed Wennen's stick arms, held straight out, are now sleeves
  that hang down the robe and swing with the step. This covers the warren, Zenith, the jet sentry and Luna (from
  the front and back only; side-on her plait shows). Pip keeps his cape.
- **Four older poses redrawn from the cast's own sheets** (`posegen.py`):
  - P-GHO-01: the Order's ghost rises out of her body on the bier.
  - P-GHO-02: she lies back down, and the body ages to parchment, then dust.
  - P-THR-03: Thredra sits on her staff and rises.
  - P-THR-05: three of her, the two copies spectral.
- **Mother yeti** (K-YET-03): her white fur's bare edges are outlined so she reads against snow.
- **Value spacing** (`tools/value_fix.py`): two fixes, each where one material's two shades touched but sat too
  close to read.
  - Alerion's tunic shadow is a step darker, so the folds show.
  - Thredra's grey skin is darker than her white hair, so her face no longer melts into it.

  The other pairs the audit flagged are different hues, which read apart on their own.
- **Named minor NPCs whose stand-ins contradicted their lines** (`tools/npcgen.py`, wired by name in the last
  build step, `tools/npc_graphics.rb`):
  - The dwarves Hruna, Korux (bald and bandaged), Storn (red beard), Shandar Froth (red-bearded logger) and Tarin
    Goldlash.
  - Copper Knobberknocker, a rock gnome with copper hair.
  - The half-orcs Oarus Masthew and Rilka Dawnshard.
  - Kethan Vale, the goliath captain with grey skin.

  Each starts from a base-game sheet, given the person's colours and build. The scripts' Stage actors for them
  use the new sheets too. Human NPCs whose base sprite fits their description keep it.
- **Razzilith's roar** (Ch11): he rears and roars on the Shrine (K-RAZ-03) as Iskra leaves.
- **Story flags:** of 1,154 flags, 131 are set but never read (`tools/flag_audit.py`). All are records of a choice
  that plays out in its own scene, and none gates anything. They are listed in `docs/review/FLAGS_UNREAD.md`.
