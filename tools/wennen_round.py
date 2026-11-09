#!/usr/bin/env python3
"""Round the back of the Wennen's heads (2026-11-09). In the up row the skull's top was one straight outline from ear
to ear, which read as a box from behind. Between the ears it now arcs up one pixel (the outline moves up, the fur
fills in under it), and the outer corners step in.

    python3 tools/wennen_round.py SHEET.png [...]     (in place)"""
import sys
from PIL import Image

def is_out(p):
    return p[3] and max(p[:3]) < 40

def fix(path):
    im = Image.open(path).convert("RGBA").resize((160, 160), Image.NEAREST)
    px = im.load()
    for c in range(4):
        fx, fy = c * 40, 120
        # the skull's top: the first row with a run of 10+ outline pixels
        top = None
        for y in range(fy, fy + 30):
            run = best = 0
            for x in range(fx, fx + 40):
                run = run + 1 if is_out(px[x, y]) else 0
                best = max(best, run)
            if best >= 10:
                top = y
                break
        if top is None:
            continue
        xs = [x for x in range(fx, fx + 40) if is_out(px[x, top])]
        gap = [x for x in range(min(xs), max(xs) + 1) if not px[x, top - 1][3]]   # open sky between the ears
        if len(gap) < 3:
            continue
        inner = gap[1:-1]
        for x in inner:
            px[x, top - 1] = (14, 8, 13, 255)
            px[x, top] = px[x, top + 1]                  # fur, from the row under it
        left = min(xs)
        if not px[left, top + 1][3] is False and is_out(px[left, top]) and px[left, top - 1][3] == 0:
            px[left, top] = (0, 0, 0, 0)                 # the outer corner steps in
    im.resize((320, 320), Image.NEAREST).save(path)

for p in sys.argv[1:]:
    fix(p)
    print(p)
