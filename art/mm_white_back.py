"""Meat Meat's battle back: black hood-hair -> long white hair (the user's
canon: long white hair, violet eyes). Recolours the hair on the head and
draws it falling down her back, frame by frame.
python3 mm_white_back.py <in png> <out png>"""
import sys
import numpy as np
from PIL import Image

SRC, OUT = sys.argv[1:3]
a = np.array(Image.open(SRC).convert('RGBA'))
OUTL = np.array([40, 38, 52, 255], np.uint8)          # soft outline for white hair
DARK, MID, LIGHT, HI = (151, 155, 171), (199, 203, 216), (226, 229, 238), (248, 249, 252)
greys = {(39, 39, 44): DARK, (55, 54, 62): MID, (60, 59, 67): MID, (70, 69, 76): LIGHT,
         (81, 80, 89): LIGHT, (114, 114, 122): HI}
HEAD_BOTTOM = 68   # native rows: everything above this on the sprite is head

for f in range(a.shape[1] // 160):
    fr = a[:, f * 160:(f + 1) * 160]
    # 1. recolour the hair on the head
    for y in range(HEAD_BOTTOM):
        for x in range(160):
            p = tuple(int(v) for v in fr[y, x, :3])
            if fr[y, x, 3] and p in greys:
                fr[y, x, :3] = greys[p]
    # 2. long hair down her back, hung from under the dome. The dome's centre
    #    is the goggle strap's centre (the floppy sides are pigtail-length hair).
    strap = ((fr[..., :3] == (126, 58, 33)).all(-1) | (fr[..., :3] == (206, 94, 3)).all(-1)) & (fr[..., 3] > 0)
    ys, xs = np.where(strap[:HEAD_BOTTOM])
    if not len(xs): continue
    cx = int(round(xs.mean()))
    top, bottom, half0, half1 = HEAD_BOTTOM - 4, 90, 13, 9
    for y in range(top, bottom + 1):
        t = (y - top) / (bottom - top)
        w = int(round(half0 + (half1 - half0) * t))
        for x in range(cx - w, cx + w + 1):
            d = x - (cx - w)
            if y >= bottom - 3 and d % 5 in (0, 4) and y - (bottom - 3) >= (1 if d % 5 == 0 else 2):
                continue                               # strand tips
            if y == bottom and d % 5 != 2:
                continue
            if x in (cx - w, cx + w):
                fr[y, x] = OUTL; continue
            rel = abs(x - cx) / max(w, 1)
            if rel > 0.75: c = DARK
            elif (x - cx) % 6 in (0, 1) and rel < 0.6: c = HI if y < top + 8 else LIGHT
            else: c = MID if t > 0.5 else LIGHT
            fr[y, x, :3] = c; fr[y, x, 3] = 255
    # outline under the tips
    for x in range(cx - half1 - 1, cx + half1 + 2):
        col = np.where((fr[top:bottom + 1, x, 3] > 0) & ~((fr[top:bottom + 1, x, :3] == OUTL[:3]).all(-1)))[0]
        if len(col):
            yb = top + col.max() + 1
            if yb < 160: fr[yb, x] = OUTL
    a[:, f * 160:(f + 1) * 160] = fr
Image.fromarray(a).save(OUT)
print('ok', a.shape)
