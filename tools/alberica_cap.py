#!/usr/bin/env python3
"""Alberica's purple cap on every facing (2026-11-09). The sheet had it in the down row only, so the side and back
rows showed a bald scalp. Side and back rows: the scalp (top 8 native rows of the figure) becomes the cap, outlined
in black as the down row's is; on the back row the skin below the cap becomes her red hair.

    python3 tools/alberica_cap.py IN.png OUT.png"""
import sys
from PIL import Image

SKIN_L, SKIN_S, BROWN, OUT_RED = (247, 207, 182), (207, 150, 111), (113, 72, 45), (116, 42, 45)
CAP, CAP_S, BLACK = (121, 73, 166), (121, 73, 166), (0, 0, 0)   # flat, as the down row's cap is
HAIR, HAIR_S = (189, 73, 50), (116, 42, 45)
CAP_ROWS, HAIR_ROWS = 8, 6

def build(src):
    im = Image.open(src).convert("RGBA").resize((160, 160), Image.NEAREST)
    px = im.load()
    for r in (1, 2, 3):
        for c in range(4):
            fx, fy = c * 40, r * 40
            top = fy + im.crop((fx, fy, fx + 40, fy + 40)).getbbox()[1]
            for y in range(top, top + CAP_ROWS + (HAIR_ROWS if r == 3 else 0)):
                for x in range(fx, fx + 40):
                    p = px[x, y]
                    if not p[3]:
                        continue
                    k = p[:3]
                    if y < top + CAP_ROWS:
                        new = {SKIN_L: CAP, SKIN_S: CAP_S, BROWN: CAP_S, OUT_RED: BLACK}.get(k)
                    else:
                        new = {SKIN_L: HAIR, SKIN_S: HAIR_S}.get(k)
                    if new:
                        px[x, y] = new + (255,)
    return im.resize((320, 320), Image.NEAREST)

if __name__ == "__main__":
    build(sys.argv[1]).save(sys.argv[2])
