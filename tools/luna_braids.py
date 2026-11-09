#!/usr/bin/env python3
"""Luna's braids back to her ice-blue (her identity from the earlier sprite), her dress a step darker so fur, braids
and dress read as three values. Braid pixels are found by flooding the dress tones from the head down.

    python3 tools/luna_braids.py IN.png OUT.png"""
import sys
from PIL import Image

F, J, K = (157, 138, 181), (186, 167, 208), (114, 96, 132)
BRAID = {F: (163, 201, 200), J: (154, 217, 229), K: (104, 129, 141)}
DRESS = {F: (130, 121, 161), J: (157, 138, 181), K: (80, 69, 109)}
HEAD = 21                                            # native rows from the ear tips that are head

def build(src):
    im = Image.open(src).convert("RGBA").resize((160, 160), Image.NEAREST)
    px = im.load()
    for row in range(4):
        for col in range(4):
            fx, fy = col * 40, row * 40
            bb = im.crop((fx, fy, fx + 40, fy + 40)).getbbox()
            if not bb:
                continue
            top = fy + bb[1]
            seen = set()
            stack = [(x, y) for y in range(top, top + HEAD) for x in range(fx, fx + 40) if px[x, y][3] and px[x, y][:3] in BRAID]
            while stack:
                x, y = stack.pop()
                if (x, y) in seen or not (fx <= x < fx + 40 and fy <= y < fy + 40):
                    continue
                p = px[x, y]
                if not p[3] or p[:3] not in BRAID:
                    continue
                seen.add((x, y))
                stack += [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
            for y in range(fy, fy + 40):
                for x in range(fx, fx + 40):
                    p = px[x, y]
                    if p[3] and p[:3] in BRAID:
                        px[x, y] = ((BRAID if (x, y) in seen else DRESS)[p[:3]]) + (255,)
    return im.resize((320, 320), Image.NEAREST)

if __name__ == "__main__":
    build(sys.argv[1]).save(sys.argv[2])
