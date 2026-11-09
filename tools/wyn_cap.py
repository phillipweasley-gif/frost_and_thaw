#!/usr/bin/env python3
"""Wyn's purple cap on every facing (2026-11-09). As with Alberica, the sheet had the cap in the down row only; the
side and back rows showed bare white hair on top. Side and back rows: the top 7 native rows of the figure become the
cap (the down row's purple and highlight, outlined black) and the 8th its black brim, as the down row has.

    python3 tools/wyn_cap.py IN.png OUT.png"""
import sys
from PIL import Image

WHITE, BRIGHT, GREY = (217, 218, 234), (250, 247, 238), (164, 164, 182)
CAP, CAP_HI, BLACK = (77, 59, 145), (166, 107, 208), (0, 0, 0)
CAP_ROWS = 7

def build(src):
    im = Image.open(src).convert("RGBA").resize((160, 160), Image.NEAREST)
    px = im.load()
    for r in (1, 2, 3):
        for c in range(4):
            fx, fy = c * 40, r * 40
            top = fy + im.crop((fx, fy, fx + 40, fy + 40)).getbbox()[1]
            for y in range(top, top + CAP_ROWS + 1):
                swap = ({WHITE: CAP, BRIGHT: CAP_HI, GREY: BLACK} if y < top + CAP_ROWS
                        else {WHITE: BLACK, BRIGHT: BLACK, GREY: BLACK})
                for x in range(fx, fx + 40):
                    p = px[x, y]
                    if p[3] and p[:3] in swap:
                        px[x, y] = swap[p[:3]] + (255,)
    return im.resize((320, 320), Image.NEAREST)

if __name__ == "__main__":
    build(sys.argv[1]).save(sys.argv[2])
