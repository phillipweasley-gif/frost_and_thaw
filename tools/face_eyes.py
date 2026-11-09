#!/usr/bin/env python3
"""Stamp the base game's eyes onto a walking sheet's down-facing frames (Frost & Thaw art direction, 2026-11-08).

    python3 face_eyes.py IN.png OUT.png [--row 12] [--gap 4] [--iris 3b5d7a] [--brow 4c474b] [--dx 0]

How the base game draws an open eye (measured on BW (44), BW (35), BW (90); native pixels, down frame):
  * Each eye is a 2x2 block. Left eye:  [iris][pupil]   Right eye (mirrored): [pupil][iris]
                                         [white][iris]                          [iris][white]
    pupil = near-black, iris = a mid colour clearly different from the hair and skin, white = the highlight,
    always on the OUTER lower corner.
  * The eyes sit `row` px below the top of the head (12 on the standard adult body: head top 8, eyes 20-21).
  * `gap` skin pixels between the two blocks (4 on the standard body), centred on the head.
  * --brow puts a 2-px brow in that colour on the row above each eye (a stern or older face).
The walk frames bob, so the head top is found per frame and the eyes move with it.
Only the four down frames (row 1 of the sheet) are changed; side frames keep their own one-eye profile.
Check the result at 10x with `--plate` before delivering."""
import sys
from PIL import Image

def hexc(s):
    s = s.lstrip("#")
    return tuple(int(s[i:i + 2], 16) for i in (0, 2, 4)) + (255,)

def stamp(im, row=12, gap=4, iris="3b5d7a", brow=None, dx=0):
    n = im.resize((im.width // 2, im.height // 2), Image.NEAREST)
    px = n.load()
    P, W, I = hexc("0e080d"), hexc("f8f8f8"), hexc(iris)
    B = hexc(brow) if brow else None
    for col in range(4):
        fx = col * 40
        fr = n.crop((fx, 0, fx + 40, 40))
        bb = fr.getbbox()
        if not bb:
            continue
        top = bb[1]
        # the head's centre: the middle of the widest opaque run on the eye row
        y = top + row
        xs = [x for x in range(40) if px[fx + x, y][3]]
        c = (min(xs) + max(xs) + 1) // 2 + dx
        lx = c - gap // 2 - 2          # left block's first column
        rx = c + (gap - gap // 2)      # right block's first column
        for (x0, mirror) in ((lx, False), (rx, True)):
            a, b = (I, P) if not mirror else (P, I)
            c2, d = (W, I) if not mirror else (I, W)
            for (xx, yy, colr) in ((x0, y, a), (x0 + 1, y, b), (x0, y + 1, c2), (x0 + 1, y + 1, d)):
                px[fx + xx, yy] = colr
            if B:
                px[fx + x0, y - 1] = B
                px[fx + x0 + 1, y - 1] = B
    return n.resize(im.size, Image.NEAREST)

def plate(before, after, out):
    """Down-frame faces before (top) and after (bottom), at 10x."""
    tiles = []
    for im in (before, after):
        n = im.resize((im.width // 2, im.height // 2), Image.NEAREST)
        row = Image.new("RGBA", (4 * 24, 20), (150, 170, 140, 255))
        for col in range(4):
            fr = n.crop((col * 40, 0, col * 40 + 40, 40)); bb = fr.getbbox()
            row.alpha_composite(fr.crop((8, bb[1] + 4, 32, bb[1] + 24)), (col * 24, 0))
        tiles.append(row)
    p = Image.new("RGBA", (96, 42), (150, 170, 140, 255))
    p.alpha_composite(tiles[0], (0, 0)); p.alpha_composite(tiles[1], (0, 22))
    p.resize((960, 420), Image.NEAREST).save(out)

if __name__ == "__main__":
    a = sys.argv[1:]
    if len(a) < 2:
        print(__doc__); sys.exit(2)
    src, dst, opts = a[0], a[1], a[2:]
    kw, pl = {}, None
    i = 0
    while i < len(opts):
        k = opts[i].lstrip("-")
        if k == "plate":
            pl = opts[i + 1]
        elif k in ("row", "gap", "dx"):
            kw[k] = int(opts[i + 1])
        else:
            kw[k] = opts[i + 1]
        i += 2
    im = Image.open(src).convert("RGBA")
    out = stamp(im, **kw)
    out.save(dst)
    if pl:
        plate(im, out, pl)
