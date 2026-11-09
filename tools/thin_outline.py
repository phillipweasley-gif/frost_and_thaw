#!/usr/bin/env python3
"""Give one-pixel-thin lines a dark underside (2026-11-09), as the base game's tails carry: in the given rows of a
sheet, every opaque pixel with nothing above and nothing below it gets the outline under it. Used for Glimmer's tail
(side rows), which read as dotted at game scale.

    python3 tools/thin_outline.py SHEET.png ROWS   (in place; ROWS e.g. 12)"""
import sys
from PIL import Image

def fix(path, rows):
    im = Image.open(path).convert("RGBA").resize((160, 160), Image.NEAREST)
    src = im.copy().load()
    px = im.load()
    n = 0
    for r in rows:
        for y in range(r * 40 + 1, r * 40 + 39):
            for x in range(160):
                p = src[x, y]
                if p[3] and max(p[:3]) >= 40 and not src[x, y - 1][3] and not src[x, y + 1][3]:
                    px[x, y + 1] = (14, 8, 13, 255)
                    n += 1
    im.resize((320, 320), Image.NEAREST).save(path)
    return n

if __name__ == "__main__":
    print(fix(sys.argv[1], [int(c) for c in sys.argv[2]]), "pixels")
