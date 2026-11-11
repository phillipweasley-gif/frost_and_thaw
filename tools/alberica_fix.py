#!/usr/bin/env python3
"""Alberica's walking sheet, three fixes (2026-11-11, owner: "the Alberica sprite looks weird").

1. The beret was a helmet: seven or eight rows of purple down to the eyebrows, more than half her head. It's cut
   to its top four rows and a brim, and the rows under it become her red hair, a fringe over the forehead (front)
   and hair over the ear (sides). The back view's beret shrinks the same way.
2. Side-on her face was all the skin's shadow colour, so she turned tan whenever she walked left or right. The
   face is the light skin now, the shadow kept on the back edge and under the chin, as from the front.
3. Side-on the cream front panel of her tunic ran the whole width of her body, like an apron worn sideways. A
   panel on the front of a tunic doesn't show side-on: those rows are the tunic's orange.

4. (owner, 11 Nov) Her tunic and trousers are a short red dress: the bodice and skirt red, the front panel a
   lighter red, bare shoulders and a low neckline from the front, a dark red hem above bare legs, red shoes.
   The beret stays.

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

RED, RED_L, RED_D = (196, 28, 44), (226, 64, 76), (132, 16, 32)
TROUSERS, SHOES, SHOULDER, SHOULDER2 = (52, 48, 59), (195, 139, 80), (166, 166, 166), (78, 51, 54)

def dress(fr, row):
    px = fr.load()
    tun = rows_with(px, ORANGE)
    if not tun:
        return fr
    t0 = tun[0]
    trows = [y for y in range(t0, N) if any(px[x, y][3] and px[x, y][:3] == TROUSERS for x in range(N))]
    hem = trows[0] if trows else None
    for y in range(N):
        for x in range(N):
            p = px[x, y]
            if not p[3]:
                continue
            c = p[:3]
            if c == ORANGE:
                px[x, y] = RED + (255,)
            elif c == CREAM:                              # the bodice's front panel; plain red at the back
                px[x, y] = (RED if row == 3 else RED_L) + (255,)
            elif c == TROUSERS and hem is not None and y >= hem:
                px[x, y] = (RED_D if y == hem else SKIN) + (255,)
            elif c == SHOES and hem is not None and y > hem:
                px[x, y] = RED_D + (255,)
            elif c in (SHOULDER, SHOULDER2) and t0 - 1 <= y <= t0 + 1 and row in (0, 3):
                px[x, y] = SKIN + (255,)                  # bare shoulders
    if row == 0:                                          # a low neckline
        xs = [x for x in range(N) if px[x, t0][3] and px[x, t0][:3] in (RED, RED_L)]
        if xs:
            cx = (min(xs) + max(xs)) // 2
            for x in range(cx - 2, cx + 2):
                if px[x, t0][:3] in (RED, RED_L):
                    px[x, t0] = SKIN + (255,)
            for x in (cx - 1, cx):
                if px[x, t0 + 1][:3] in (RED, RED_L):
                    px[x, t0 + 1] = SKIN + (255,)
    return fr

def main():
    src = sys.argv[1] if len(sys.argv) > 1 else "build/Characters/FT_alberica.png"
    dest = sys.argv[2] if len(sys.argv) > 2 else src
    im = Image.open(src).convert("RGBA").resize((N * 4, N * 4), Image.NEAREST)
    out = Image.new("RGBA", im.size, (0, 0, 0, 0))
    for r in range(4):
        for c in range(4):
            box = (c * N, r * N, c * N + N, r * N + N)
            out.alpha_composite(dress(fix_frame(im.crop(box), r), r), box[:2])
    out.resize((N * 8, N * 8), Image.NEAREST).save(dest)

if __name__ == "__main__":
    main()
