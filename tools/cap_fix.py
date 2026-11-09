#!/usr/bin/env python3
"""A hat on every facing (2026-11-09), for sheets whose down row has a hat that the side and back rows lack (the base
sheet was bareheaded and only the front was repainted). In the side and back rows, the top ROWS native rows of each
figure take the swaps given (skin or hair to the hat's own colours, the head's outline to black), and the row after
them becomes a black brim, as the front's is.

    python3 tools/cap_fix.py IN.png OUT.png ROWS 'r,g,b>r,g,b' ... [back:K 'back:r,g,b>r,g,b' ...]

On the back row, back:K more rows under the brim take the back: swaps (the back of the head is hair, not face).

Used for Master Hew Talmire:
    python3 tools/cap_fix.py hew.png out.png 5 '247,207,182>188,151,107' '207,150,111>141,133,129' '113,72,45>0,0,0' \
        back:6 'back:247,207,182>141,133,129' 'back:207,150,111>113,107,104'"""
import sys
from PIL import Image

def parse(s):
    a, b = s.split(">")
    return tuple(map(int, a.split(","))), tuple(map(int, b.split(",")))

def build(src, rows, swap, back_rows=0, back=None):
    im = Image.open(src).convert("RGBA").resize((160, 160), Image.NEAREST)
    px = im.load()
    brim_from = set(swap) | set(swap.values())
    for r in (1, 2, 3):
        for c in range(4):
            fx, fy = c * 40, r * 40
            top = fy + im.crop((fx, fy, fx + 40, fy + 40)).getbbox()[1]
            for y in range(top, top + rows + 1):
                for x in range(fx, fx + 40):
                    p = px[x, y]
                    if not p[3]:
                        continue
                    if y < top + rows:
                        if p[:3] in swap:
                            px[x, y] = swap[p[:3]] + (255,)
                    elif p[:3] in brim_from:
                        px[x, y] = (0, 0, 0, 255)
            if r == 3 and back:
                for y in range(top + rows + 1, top + rows + 1 + back_rows):
                    for x in range(fx, fx + 40):
                        p = px[x, y]
                        if p[3] and p[:3] in back:
                            px[x, y] = back[p[:3]] + (255,)
    return im.resize((320, 320), Image.NEAREST)

if __name__ == "__main__":
    rest = sys.argv[4:]
    k = next((int(a[5:]) for a in rest if a.startswith("back:") and ">" not in a), 0)
    back = dict(parse(a[5:]) for a in rest if a.startswith("back:") and ">" in a)
    swap = dict(parse(a) for a in rest if not a.startswith("back:"))
    build(sys.argv[1], int(sys.argv[3]), swap, k, back).save(sys.argv[2])
