#!/usr/bin/env python3
"""Wennen arms (2026-11-09). The robed Wennen (the warren folk, Zenith, the jet sentry, Luna) were drawn with their
arms as one-pixel sticks held straight out from the shoulders, flung four to seven pixels wide in the walk frames:
scarecrows, beside base-game townsfolk whose arms hang at their sides and swing a pixel as they step.

Each frame keeps the head, the robe and the feet as drawn. The stick arms go, and two sleeves hang down the sides of
the robe (one, on the near side, in the side views; not on Luna side-on, where her plait hangs), drawn over the robe's edge so the figure grows a pixel at most:
the robe's darker shade, outlined, ending in a paw of the character's fur, swinging a pixel with the step. Pip keeps
his cape, which covers his arms. Then the outline is closed all round (tools/sprite_audit.py).

    python3 tools/wennen_arms.py [NAMES...] [--out build/Characters]"""
import os, sys
from collections import Counter
from PIL import Image
sys.path.insert(0, os.path.dirname(__file__))
import sprite_audit as sa

N = 40
DEFAULT = ["FT_wennen_generic", "FT_wennen_zenith", "FT_wennen_jet_sentry", "FT_wennen_luna"]

def lum(c):
    return 0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2]

def neck_row(fr, out):
    """The outline row under the chin: the lowest row in the top three-quarters with a run of 7+ outline pixels."""
    px = fr.load()
    x0, y0, x1, y1 = fr.getbbox()
    best = None
    for y in range(max(y0 + 8, 20), min(y0 + (y1 - y0) * 3 // 4, 30)):      # below the ears' roots
        run = top = 0
        for x in range(N):
            run = run + 1 if (px[x, y][3] and px[x, y][:3] == out) else 0
            top = max(top, run)
        if top >= 7:
            best = y
    return best

def span(px, y):
    xs = [x for x in range(N) if px[x, y][3]]
    return (min(xs), max(xs)) if xs else None

def colours(fr, nb):
    px = fr.load()
    head = Counter(px[x, y][:3] for y in range(nb - 7, nb - 2) for x in range(N) if px[x, y][3] and lum(px[x, y]) >= 40)
    body = Counter(px[x, y][:3] for y in range(nb + 3, nb + 8) for x in range(N) if px[x, y][3] and lum(px[x, y]) >= 40)
    fur = head.most_common(1)[0][0]
    main = body.most_common(1)[0][0]
    shades = [c for c, n in body.items() if n >= 2 and lum(c) < lum(main) - 8]
    shade = min(shades, key=lum) if shades else tuple(max(0, v - 40) for v in main)
    return fur, main, shade

def body_span(fr, nb):
    px = fr.load()
    xs = [x for y in range(nb + 3, nb + 7) for x in range(N) if px[x, y][3]]
    return min(xs), max(xs)

def frame(fr, row, f, out_col, fallback=None, plaits=False):
    fr = fr.copy()
    px = fr.load()
    nb = neck_row(fr, out_col) or fallback
    if nb is None:
        return fr
    fur, main, shade = colours(fr, nb)
    L, R = body_span(fr, nb)
    O = out_col + (255,)
    # the shoulders are rebuilt: the head kept to its own width down to the chin line, the stick arms gone, and the
    # top of the robe drawn again from the chin's width out to the robe's
    hl, hr = span(px, nb - 2)
    r3 = span(px, nb + 3)
    if plaits:                                         # Luna: no stick arms to clear, and her plaits hang
        if row in (0, 3):                              # down the front, so her sleeves hang at the sides only
            pass
        else:
            return fr
    for y in (nb - 1, nb) if not plaits else ():
        for x in range(N):
            if px[x, y][3] and not (hl <= x <= hr):
                px[x, y] = (0, 0, 0, 0)
    for y in (nb + 1, nb + 2) if not plaits else ():
        t = (y - nb) / 3.0
        a = round(hl + (r3[0] - hl) * t)
        b = round(hr + (r3[1] - hr) * t)
        for x in range(N):
            if x < a or x > b:
                if px[x, y][3]:
                    px[x, y] = (0, 0, 0, 0)
            elif x in (a, b):
                px[x, y] = O
            elif not px[x, y][3] or px[x, y][:3] != main and lum(px[x, y]) >= 40 and px[x, y][:3] != shade:
                px[x, y] = main + (255,)
    for x in (range(hl, hr + 1) if not plaits else ()):  # the chin line, whole
        if px[x, nb][3] or hl < x < hr:
            px[x, nb] = O
    def put(x, y, c):
        if 0 <= x < N and 0 <= y < N:
            px[x, y] = c + (255,) if len(c) == 3 else c
    def sleeve(x0, top, length, dx_low=0, side=False):
        """A 2-wide sleeve hanging from (x0, top), the lower half shifted dx_low, a paw at the end, outlined."""
        cells = []
        for i in range(length):
            dx = dx_low if i >= length // 2 else 0
            cells.append((x0 + dx, top + i)); cells.append((x0 + 1 + dx, top + i))
        dx = dx_low
        paw = [(x0 + dx, top + length), (x0 + 1 + dx, top + length)]
        allc = set(cells + paw)
        for (x, y) in allc:
            for ex, ey in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                q = (x + ex, y + ey)
                if q not in allc:
                    put(q[0], q[1], O)
        for (x, y) in cells:
            if side:                                   # seen side-on: the sleeve in the robe's own colour, shaded behind
                put(x, y, shade if (x - x0 - (dx_low if y - top >= length // 2 else 0)) == (1 if fwd_s < 0 else 0) else main)
            else:
                put(x, y, shade if (x - x0 - dx_low) % 2 == 0 or (y - top) < 1 else main)
        for (x, y) in paw:
            put(x, y, fur)
    swing = (0, 1, 0, -1)[f]
    fwd_s = 1 if row == 2 else -1
    if row in (0, 3):                                  # front and back: both arms down the robe's sides
        sleeve(r3[0], nb + 1, 5 + (swing == 1), 0)
        sleeve(r3[1] - 1, nb + 1, 5 + (swing == -1), 0)
    else:                                              # side: the near arm over the body, swinging
        fwd = 1 if row == 2 else -1
        cx = (r3[0] + r3[1]) // 2 - (1 if fwd < 0 else 0)
        sleeve(cx, nb + 1, 5, swing * fwd, side=True)
    return fr

def build(name, src_dir, out_dir):
    im = Image.open(os.path.join(src_dir, name + ".png")).convert("RGBA").resize((N * 4, N * 4), Image.NEAREST)
    out_col = sa.outline_colour(im.load(), *im.size)
    sheet = Image.new("RGBA", (N * 4, N * 4), (0, 0, 0, 0))
    for r in range(4):
        for c in range(4):
            box = (c * N, r * N, c * N + N, r * N + N)
            front = im.crop((c * N, 0, c * N + N, N))           # the facing-us frame of the same step: its chin line
            sheet.alpha_composite(frame(im.crop(box), r, c, out_col, neck_row(front, out_col), name == "FT_wennen_luna"), box[:2])
    dest = os.path.join(out_dir, name + ".png")
    sheet.resize((N * 8, N * 8), Image.NEAREST).save(dest)
    sa.fix(dest, dest, 0)                              # close the outline all round
    return dest

if __name__ == "__main__":
    args = sys.argv[1:]
    out = args[args.index("--out") + 1] if "--out" in args else "build/Characters"
    names = [a for i, a in enumerate(args) if not a.startswith("--") and (i == 0 or args[i - 1] != "--out")] or DEFAULT
    os.makedirs(out, exist_ok=True)
    for n in names:
        print(build(n, "build/Characters", out))
