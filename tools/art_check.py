#!/usr/bin/env python3
"""Frost & Thaw art checker: tests a PNG against the Nov 8 guide's technical rules.

    python3 art_check.py FILE.png [FILE2.png ...] [--kind human|goblin|big] [--walk WALKSHEET.png]

The kind of asset comes from the canvas (and name): 320x320 walking or pose sheet, 160x160 battle picture,
512x512 big creature, 960-wide effect, 512x384 panel or overlay, 128x32 balloon, 48x48 icon.
--kind sets the height range for a walking sheet (human 25-28 native px, the default; goblin 21-24; big up to 30).
--walk gives a pose sheet's walking sheet, to check that the pose uses its colours.

It checks what can be measured: size, the 2x grid, hard alpha, colour count, no pure black, the near-black
outline, feet line, centre and height. Passing it is NOT approval: identity, head size, pose and readability are
judged by eye against the P1 sheet and the approved walking sprite. Needs Pillow."""
import sys, os
from collections import Counter
from PIL import Image

OUTLINE = (14, 8, 13)

def pixels(im):
    return im.get_flattened_data() if hasattr(im, "get_flattened_data") else pixels(im)

def native(im):
    w, h = im.size
    return im.resize((w // 2, h // 2), Image.NEAREST)

def grid_breaks(px, w, h):
    n = 0
    for y in range(0, h - 1, 2):
        for x in range(0, w - 1, 2):
            b = (px[x, y], px[x + 1, y], px[x, y + 1], px[x + 1, y + 1])
            if len(set(b)) > 1 and any(p[3] for p in b):
                n += 1
    return n

def outline_share(fr):
    """Share of a native frame's silhouette edge that is near-black (each channel under 70)."""
    px = fr.load(); w, h = fr.size
    edge = dark = 0
    for y in range(h):
        for x in range(w):
            if not px[x, y][3]:
                continue
            if any(not (0 <= x + dx < w and 0 <= y + dy < h) or not px[x + dx, y + dy][3]
                   for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                edge += 1
                dark += max(px[x, y][:3]) < 70
    return dark / edge if edge else 1.0

def frames(im, size):
    w, h = im.size
    for fy in range(0, h, size):
        for fx in range(0, w, size):
            fr = im.crop((fx, fy, fx + size, fy + size))
            if fr.getbbox():
                yield (fx // size, fy // size), fr

def check(path, kind="human", walk=None):
    name = os.path.basename(path)
    raw = Image.open(path)
    im = raw.convert("RGBA")
    w, h = im.size
    px = im.load()
    fails, notes = [], []
    if raw.mode not in ("RGBA", "P", "LA"):
        notes.append(f"mode {raw.mode} (RGBA expected)")

    # the asset type, from canvas and name
    if (w, h) == (320, 320):
        t = "pose" if name.startswith("P-") else "walking"
        limit, frame, feet = 24, 80, 73
    elif (w, h) == (160, 160):
        t, limit, frame, feet = "battle", 32, None, 157
    elif (w, h) == (512, 512):
        t, limit, frame, feet = "big creature", 40, 128, 121
    elif w == 960 and h % 192 == 0:
        t, frame, feet = "effect", None, None
        limit = 16 if any(name.startswith(k) for k in ("E-08", "E-18", "E-19")) else 12
    elif (w, h) == (512, 384):
        t, frame, feet = ("overlay", None, None) if name.startswith("O-") else ("panel", None, None)
        limit = 12 if t == "overlay" else 64
    elif (w, h) == (128, 32):
        t, limit, frame, feet = "balloon", 8, None, None
    elif (w, h) == (48, 48):
        t, limit, frame, feet = "icon", None, None, None
    else:
        return name, "?", [f"canvas {w}x{h} is not one of the guide's formats"], notes

    # pixels
    soft = sum(1 for p in pixels(im) if p[3] not in (0, 255))
    if soft:
        fails.append(f"{soft} semi-transparent pixels (alpha must be 0 or 255)")
    if t != "icon":
        gb = grid_breaks(px, w, h)
        if gb:
            fails.append(f"{gb} 2x2 blocks off the 2x grid (draw at native size, scale exactly 2x)")
    cols = Counter(p[:3] for p in pixels(im) if p[3])
    if limit and len(cols) > limit:
        fails.append(f"{len(cols)} colours (limit {limit} for a {t})")
    black = cols.get((0, 0, 0), 0)
    if black and t in ("walking", "pose", "battle", "big creature"):
        fails.append(f"{black} pure #000000 pixels (use #0E080D or a tinted near-black)")

    # outline, feet, centre, height
    if t in ("walking", "pose", "big creature"):
        n = native(im)
        nf = frame // 2
        worst = []
        for (cx, cy), fr in frames(n, nf):
            share = outline_share(fr)
            if share < 0.75:
                worst.append(f"frame r{cy}c{cx} {int(share * 100)}%")
        if worst:
            fails.append("outline broken (under 75% of the edge near-black; the approved cast is 77-100%): " + ", ".join(worst[:6]) + (" ..." if len(worst) > 6 else ""))
        hs = []
        for (cx, cy), fr in frames(im, frame):
            x0, y0, x1, y1 = fr.getbbox()
            if t == "walking":
                # the standing frame (column 1) is on the line; walk frames may bob 2 px
                if (cx == 0 and y1 - 1 != feet) or abs(y1 - 1 - feet) > 2:
                    fails.append(f"frame r{cy}c{cx}: feet on row {y1 - 1}, not {feet}")
                mid = (x0 + x1) / 2
                if abs(mid - frame / 2) > 4:
                    notes.append(f"frame r{cy}c{cx}: centred at x {mid:.0f} (guide: {frame // 2}; fine if a tail or prop pulls it)")
                if cx == 0:
                    hs.append((y1 - y0) // 2)
        if t == "walking" and hs:
            lo, hi = {"human": (25, 28), "goblin": (21, 24), "big": (25, 30)}.get(kind, (25, 28))
            if max(hs) > hi + 1 or min(hs) < lo - 2:
                fails.append(f"standing height {min(hs)}-{max(hs)} native px (template {lo}-{hi} for {kind}; head over half of it)")
            elif max(hs) > hi:
                notes.append(f"standing height {max(hs)} native px, 1 over the template's {hi}: fine for a bun, a hat or ears, not for a body")
            else:
                notes.append(f"height {min(hs)}-{max(hs)} native px; now check by eye that the head is 14-17 px, over half")
    if t == "battle":
        bb = im.getbbox()
        if bb:
            fr = bb[3] - 1
            if abs(fr - feet) > 4:
                fails.append(f"feet on row {fr}, not {feet}")
            elif fr != feet:
                notes.append(f"feet on row {fr} (the guide's line is {feet})")
            ht = bb[3] - bb[1]
            if not 140 <= ht <= 150:
                fails.append(f"figure {ht} px tall (140-150)")
        share = outline_share(native(im))
        if share < 0.6:
            fails.append(f"outline broken ({int(share * 100)}% of the edge near-black; the base game's are about 63%, the cast's 70-99%)")
    if t == "pose" and walk:
        wc = Counter(p[:3] for p in pixels(Image.open(walk).convert("RGBA")) if p[3])
        new = [c for c in cols if c not in wc]
        if len(new) > 8:
            fails.append(f"{len(new)} colours not in the walking sheet (only an effect's glow may add colours)")
    return name, t, fails, notes

def main():
    args = sys.argv[1:]
    kind, walk, files = "human", None, []
    i = 0
    while i < len(args):
        if args[i] == "--kind":
            kind = args[i + 1]; i += 2
        elif args[i] == "--walk":
            walk = args[i + 1]; i += 2
        else:
            files.append(args[i]); i += 1
    if not files:
        print(__doc__); return 2
    bad = 0
    for f in files:
        name, t, fails, notes = check(f, kind, walk)
        print(f"{'PASS' if not fails else 'FAIL'}  {name}  ({t})")
        for x in fails:
            print(f"   x {x}")
        for x in notes:
            print(f"   - {x}")
        bad += bool(fails)
    print(f"\n{len(files) - bad}/{len(files)} pass the measurable rules. Then judge identity, head and pose by eye.")
    return 1 if bad else 0

if __name__ == "__main__":
    sys.exit(main())
