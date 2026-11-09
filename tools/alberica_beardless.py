#!/usr/bin/env python3
"""Alberica beardless (owner, 2026-11-09). The front row's red beard and black moustache become her chin and a small
mouth, the cheeks narrowing to the jaw, her braids left as they are; on the side rows the brown and dark red stubble in the face
becomes skin.

    python3 tools/alberica_beardless.py IN.png OUT.png"""
import sys
from PIL import Image

B, G, A, E = (247, 207, 182), (207, 150, 111), (0, 0, 0), (116, 42, 45)
C = (113, 72, 45)
CAP = (121, 73, 166)
# the face from x 15 to 24, rows 20-24 of the first frame (its cap's first purple row is the anchor); None leaves
# a pixel alone
FACE = {
    20: [B, B, B, B, G, G, B, B, B, G],
    21: [B, B, B, B, B, B, B, B, B, G],
    22: [A, B, B, B, E, E, B, B, G, A],
    23: [E, A, B, B, B, B, B, B, A, E],
    24: [E, E, A, A, A, A, A, A, E, E],
}

def build(src):
    im = Image.open(src).convert("RGBA").resize((160, 160), Image.NEAREST)
    px = im.load()
    def cap_top(fx):
        return next(y for y in range(40) for x in range(fx, fx + 40) if px[x, y][3] and px[x, y][:3] == CAP)
    top0 = cap_top(0)
    for c in range(4):                                  # the front row: each frame against the first's cap, then paint
        fx = c * 40
        dy = cap_top(fx) - top0
        for y, row in FACE.items():
            for i, col in enumerate(row):
                if col is not None:
                    px[fx + 15 + i, y + dy] = col + (255,)
    for r in (1, 2):                                    # side rows: stubble to skin
        for c in range(4):
            fx, fy = c * 40, r * 40
            for y in range(fy + 16, fy + 25):
                for x in range(fx + 1, fx + 39):
                    if px[x, y][:3] not in (C, E) or not px[x, y][3]:
                        continue
                    skin = sum(1 for dx, dy2 in ((1, 0), (-1, 0), (0, 1), (0, -1)) if px[x + dx, y + dy2][:3] in (G, B))
                    if skin >= 2:
                        px[x, y] = G + (255,)
    return im.resize((320, 320), Image.NEAREST)

if __name__ == "__main__":
    build(sys.argv[1]).save(sys.argv[2])
