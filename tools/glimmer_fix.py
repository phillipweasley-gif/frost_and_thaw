#!/usr/bin/env python3
"""Glimmer against the base game (2026-11-09).
1. The coat: its three blues were so close in value that in the side views the coat's tail-flap (BW (26)'s own coat)
   read as a black ring. From the shoulders down the two lighter blues go a step lighter, as the base game's coat
   ramps are spaced.
2. The tail: a one-pixel line reads as dotted; the base game draws nothing thinner than two pixels inside an outline.
   Every stretch one pixel thick (with its dark underside) gains a fur pixel and the outline above it.
3. The outline: the base game closes every shape; Glimmer's face and muzzle met the background bare on their
   leading edge (read as a bandage, side on). Every edge pixel without an outline gets one.
4. The eyes: single orange pixels read as blank; the base game's eyes are two pixels tall. Each gets a dark pupil
   under its orange.

    python3 tools/glimmer_fix.py IN.png OUT.png"""
import sys
from PIL import Image

COAT = {(52, 77, 122): (66, 98, 152), (82, 97, 120): (104, 126, 170)}
FUR = (133, 148, 171)
OUT = (14, 8, 13, 255)

def is_out(p):
    return p[3] and max(p[:3]) < 45

def build(src):
    im = Image.open(src).convert("RGBA").resize((160, 160), Image.NEAREST)
    px = im.load()
    for r in range(4):
        for c in range(4):
            fx, fy = c * 40, r * 40
            bb = im.crop((fx, fy, fx + 40, fy + 40)).getbbox()
            top = fy + bb[1]
            body = top + 17                                     # from the shoulders down
            for y in range(body, fy + 40):
                for x in range(fx, fx + 40):
                    p = px[x, y]
                    if p[3] and p[:3] in COAT:
                        px[x, y] = COAT[p[:3]] + (255,)
            if r in (1, 2):                                     # the tail, side on
                src = im.copy().load()
                for y in range(body, fy + 38):
                    for x in range(fx + 1, fx + 39):
                        p = src[x, y]
                        if not p[3] or is_out(p):
                            continue
                        if not src[x, y - 1][3] and not src[x, y - 2][3] and is_out(src[x, y + 1]) and not src[x, y + 2][3]:
                            px[x, y - 1] = FUR + (255,)
                            if not src[x, y - 3][3] or True:
                                px[x, y - 2] = OUT
    # 3. close the outline (4-neighbours of colour that touch nothing)
    src2 = im.copy().load()
    for y in range(160):
        for x in range(160):
            if src2[x, y][3]:
                continue
            fx, fy = x // 40 * 40, y // 40 * 40
            if any(fx <= x + dx < fx + 40 and fy <= y + dy < fy + 40 and src2[x + dx, y + dy][3] and not is_out(src2[x + dx, y + dy])
                   for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                px[x, y] = OUT
    # 4. eyes: the orange iris pixels in the head get a dark pupil under them
    EYE = (216, 157, 84)
    for r in range(4):
        for c in range(4):
            fx, fy = c * 40, r * 40
            top = fy + im.crop((fx, fy, fx + 40, fy + 40)).getbbox()[1]
            for y in range(top, top + 16):
                for x in range(fx, fx + 40):
                    if px[x, y][3] and px[x, y][:3] == EYE and px[x, y + 1][:3] != EYE:
                        px[x, y + 1] = (27, 30, 52, 255)
    return im.resize((320, 320), Image.NEAREST)

if __name__ == "__main__":
    build(sys.argv[1]).save(sys.argv[2])
