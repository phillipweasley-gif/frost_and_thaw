#!/usr/bin/env python3
"""Meat Meat, kitbashed from the base game (2026-11-09): every pixel is BW (66)'s, recoloured by region, plus her
brass goggles stamped into the hair. White hair (owner), green myconid skin, purple clothes (owner).

    python3 tools/meatmeat_build.py BASE_SHEET OUT.png

Recolouring is by region because BW (66) uses the same tones for its hair and its clothes, and its green iris is its shirt's green: inside the head
(the top 15 native rows of each frame's figure) they become white hair; below it they are clothes."""
import sys
from PIL import Image

SKIN = {(213, 172, 132): (176, 214, 150), (195, 139, 80): (120, 170, 104), (144, 113, 72): (58, 96, 58)}
HAIR = {(109, 101, 43): (250, 251, 255), (75, 67, 43): (190, 198, 216), (70, 45, 70): (104, 110, 140),   # strong steps,
        (72, 142, 77): (186, 128, 236), (52, 108, 47): (118, 66, 176)}   # so the twists show; the green iris goes violet (bible)
BODY = {(72, 142, 77): (150, 108, 196), (52, 108, 47): (92, 58, 132), (85, 181, 86): (200, 172, 232),   # shirt (purple, owner)
        (70, 45, 70): (52, 58, 72), (75, 67, 43): (70, 70, 80), (109, 101, 43): (150, 154, 166),
        # (under the 20-colour limit: the base's shorts and belt take the shirt's and the goggles' tones)
        (104, 129, 141): (150, 108, 196), (86, 108, 117): (92, 58, 132), (166, 133, 46): (140, 96, 36), (196, 165, 76): (214, 160, 64)}
BRASS = [(140, 96, 36), (214, 160, 64)]
LENS = [(52, 58, 72), (255, 255, 255)]            # dark slate glass (her trousers' tone), white for the glint
HEAD_ROWS = 16

def build(src):
    im = Image.open(src).convert("RGBA").resize((160, 160), Image.NEAREST)
    px = im.load()
    for row in range(4):
        for col in range(4):
            fx, fy = col * 40, row * 40
            fr = im.crop((fx, fy, fx + 40, fy + 40))
            bb = fr.getbbox()
            if not bb:
                continue
            top = fy + bb[1]
            for y in range(fy, fy + 40):
                for x in range(fx, fx + 40):
                    p = px[x, y]
                    if not p[3]:
                        continue
                    c = p[:3]
                    if c in SKIN:
                        px[x, y] = SKIN[c] + (255,)
                    elif y < top + HEAD_ROWS and c in HAIR:
                        px[x, y] = HAIR[c] + (255,)
                    elif c in BODY:
                        px[x, y] = BODY[c] + (255,)
            # the goggles: a brass strap round the hair, lenses on the front
            band = top + 6
            xs = [x for x in range(fx, fx + 40) if px[x, band][3] and px[x, band][:3] in HAIR.values()]
            if not xs:
                continue
            for x in xs:
                px[x, band] = BRASS[0] + (255,)
            x0, x1 = min(xs), max(xs)
            cx = (x0 + x1) // 2
            lenses = {0: [cx - 3, cx + 2], 1: [x0 + 1], 2: [x1 - 2], 3: []}[row]   # down, left, right, up
            for lx in lenses:
                for dx in (0, 1):
                    px[lx + dx, band - 1] = BRASS[1] + (255,)
                    px[lx + dx, band] = LENS[0] + (255,)
                    px[lx + dx, band + 1] = BRASS[1] + (255,)
                px[lx, band] = LENS[1] + (255,)              # a glint
    return im.resize((320, 320), Image.NEAREST)

if __name__ == "__main__":
    build(sys.argv[1]).save(sys.argv[2])
