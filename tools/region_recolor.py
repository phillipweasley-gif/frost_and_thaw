#!/usr/bin/env python3
"""Recolour a walking sheet's head only (2026-11-09): the top N native rows of each frame's figure.
For when a sheet's hair shares tones with its clothes or shoes, so a plain palette swap would hit both.

    python3 tools/region_recolor.py IN.png OUT.png ROWS 'r,g,b>r,g,b' ['r,g,b>r,g,b' ...]

Example (Razzy's hair darkened so it reads apart from his grey-olive skin):
    python3 tools/region_recolor.py razzy.png out.png 14 '84,88,76>50,48,42' '106,112,94>72,70,58'"""
import sys
from PIL import Image

def parse(s):
    a, b = s.split(">")
    return tuple(map(int, a.split(","))), tuple(map(int, b.split(",")))

def build(src, rows, swap):
    im = Image.open(src).convert("RGBA").resize((160, 160), Image.NEAREST)
    px = im.load()
    for r in range(4):
        for c in range(4):
            fx, fy = c * 40, r * 40
            bb = im.crop((fx, fy, fx + 40, fy + 40)).getbbox()
            if not bb:
                continue
            top = fy + bb[1]
            for y in range(top, min(top + rows, fy + 40)):
                for x in range(fx, fx + 40):
                    p = px[x, y]
                    if p[3] and p[:3] in swap:
                        px[x, y] = swap[p[:3]] + (255,)
    return im.resize((320, 320), Image.NEAREST)

if __name__ == "__main__":
    build(sys.argv[1], int(sys.argv[3]), dict(parse(s) for s in sys.argv[4:])).save(sys.argv[2])
