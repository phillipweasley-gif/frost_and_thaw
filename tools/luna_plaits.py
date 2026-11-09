#!/usr/bin/env python3
"""Luna's braids as plaits (2026-11-09): they were one pixel wide beside her face and barely read. In the front and
side rows each braid is widened a pixel outward (the outline moves out with it) and banded light and dark down its
length, so it reads as a plait.

    python3 tools/luna_plaits.py SHEET.png   (in place)"""
import sys
from PIL import Image

BRAID = [(104, 129, 141), (163, 201, 200), (154, 217, 229)]
OUT = (14, 8, 13, 255)

def fix(path):
    im = Image.open(path).convert("RGBA").resize((160, 160), Image.NEAREST)
    src = im.copy().load()
    px = im.load()
    for r in (0, 1, 2):
        for c in range(4):
            fx, fy = c * 40, r * 40
            bb = im.crop((fx, fy, fx + 40, fy + 40)).getbbox()
            cx = fx + (bb[0] + bb[2]) / 2
            for y in range(fy, fy + 40):
                for x in range(fx + 1, fx + 39):
                    p = src[x, y]
                    if not p[3] or p[:3] not in BRAID:
                        continue
                    d = -1 if x < cx else 1
                    band = BRAID[1] if (y // 2) % 2 else BRAID[0]
                    px[x, y] = band + (255,)
                    o = src[x + d, y]
                    if (not o[3]) or max(o[:3]) < 40:
                        px[x + d, y] = (BRAID[0] if (y // 2) % 2 else BRAID[1]) + (255,)
                        if not src[x + 2 * d, y][3]:
                            px[x + 2 * d, y] = OUT
    im.resize((320, 320), Image.NEAREST).save(path)

for p in sys.argv[1:]:
    fix(p)
