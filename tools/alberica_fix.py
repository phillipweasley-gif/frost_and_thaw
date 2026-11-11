#!/usr/bin/env python3
"""Alberica's walking sheet, three fixes (2026-11-11, owner: "the Alberica sprite looks weird").

1. The beret was a helmet: seven or eight rows of purple down to the eyebrows, more than half her head. It's cut
   to its top four rows and a brim, and the rows under it become her red hair, a fringe over the forehead (front)
   and hair over the ear (sides). The back view's beret shrinks the same way.
2. Side-on her face was all the skin's shadow colour, so she turned tan whenever she walked left or right. The
   face is the light skin now, the shadow kept on the back edge and under the chin, as from the front.
3. Side-on the cream front panel of her tunic ran the whole width of her body, like an apron worn sideways. A
   panel on the front of a tunic doesn't show side-on: those rows are the tunic's orange.

    python3 tools/alberica_fix.py [SRC] [DEST]   (default: build/Characters/FT_alberica.png in place)"""
import sys
from PIL import Image

CAP = (121, 73, 166)
OUT = (0, 0, 0)
HAIR, HAIR_D = (189, 73, 50), (116, 42, 45)
SKIN, SKIN_D = (247, 207, 182), (207, 150, 111)
CREAM, ORANGE = (255, 242, 227), (229, 110, 22)
N = 40

def rows_with(px, col, x0=0, x1=N):
    return [y for y in range(N) if sum(1 for x in range(x0, x1) if px[x, y][3] and px[x, y][:3] == col) >= 3]

def fix_frame(fr, row):
    px = fr.load()
    cap = rows_with(px, CAP)
    if not cap:
        return fr
    top, last = cap[0], cap[-1]
    keep = 4                                          # the beret: its top four rows
    brim = top + keep
    if last > brim:
        for y in range(brim, last + 1):
            for x in range(N):
                p = px[x, y]
                if not p[3]:
                    continue
                if y == brim and p[:3] == CAP:
                    px[x, y] = OUT + (255,)               # the beret's edge
                elif p[:3] == CAP:
                    if row == 3:
                        px[x, y] = (HAIR_D if y == last else HAIR) + (255,)
                    else:                                 # a fringe of her red hair
                        px[x, y] = HAIR + (255,)
    if row in (1, 2):
        fwd = 1 if row == 2 else -1
        # the face: the rows between the hair line and the neck where skin is
        face = [y for y in range(N) if sum(1 for x in range(N) if px[x, y][3] and px[x, y][:3] in (SKIN, SKIN_D)) >= 3]
        if face:
            f0, f1 = face[0], face[-1]
            for y in range(f0, f1):
                xs = [x for x in range(N) if px[x, y][3] and px[x, y][:3] in (SKIN, SKIN_D)]
                if not xs:
                    continue
                back = min(xs) if fwd > 0 else max(xs)
                for x in xs:
                    if px[x, y][:3] == SKIN_D and x != back:
                        px[x, y] = SKIN + (255,)
        # the tunic's cream panel is on its front: side-on it doesn't show
        for y in range(N):
            for x in range(N):
                if px[x, y][3] and px[x, y][:3] == CREAM:
                    px[x, y] = ORANGE + (255,)
    return fr

def main():
    src = sys.argv[1] if len(sys.argv) > 1 else "build/Characters/FT_alberica.png"
    dest = sys.argv[2] if len(sys.argv) > 2 else src
    im = Image.open(src).convert("RGBA").resize((N * 4, N * 4), Image.NEAREST)
    out = Image.new("RGBA", im.size, (0, 0, 0, 0))
    for r in range(4):
        for c in range(4):
            box = (c * N, r * N, c * N + N, r * N + N)
            out.alpha_composite(fix_frame(im.crop(box), r), box[:2])
    out.resize((N * 8, N * 8), Image.NEAREST).save(dest)

if __name__ == "__main__":
    main()
