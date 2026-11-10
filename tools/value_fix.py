#!/usr/bin/env python3
"""Value spacing (2026-11-10): where two touching colours of one material sit under 7 apart in lightness, the
shading vanishes. tools/sprite_audit.py lists them; these are the ones that were the same hue as well (different
hues read apart on their own). The shade is moved a step darker. Idempotent: it only swaps the old colour.

  Alerion  his tunic's shadow (89,107,131) beside its face colour (101,112,128): the folds didn't show
  Thredra her grey skin (187,184,177) beside her white hair (185,185,193): the face melted into the hair

    python3 tools/value_fix.py"""
import os
from PIL import Image

SWAPS = {
    "FT_alerion": {(89, 107, 131): (70, 87, 113)},
    "FT_thredra": {(187, 184, 177): (166, 158, 148)},
}

for name, sw in SWAPS.items():
    p = os.path.join("build/Characters", name + ".png")
    im = Image.open(p).convert("RGBA")
    px = im.load()
    n = 0
    for y in range(im.height):
        for x in range(im.width):
            q = px[x, y]
            if q[3] and q[:3] in sw:
                px[x, y] = sw[q[:3]] + (q[3],); n += 1
    if n:
        im.save(p)
    print(name, n)
