#!/usr/bin/env python3
"""Frost & Thaw art checker: tests a PNG against the Nov 8 guide's technical rules.

    python3 art_check.py FILE.png [FILE2.png ...] [--kind human|goblin|big] [--walk WALKSHEET.png] [--base BW.png]

The kind of asset comes from the canvas (and name): 320x320 walking or pose sheet, 160x160 battle picture,
512x512 big creature, 960-wide effect, 512x384 panel or overlay, 128x32 balloon, 48x48 icon.
--kind sets the height range for a walking sheet (human 25-28 native px, the default; goblin 21-24; big up to 30).
--walk gives a pose sheet's walking sheet, to check that the pose uses its colours.
--base gives the base game's sheet a walking sheet was built on (2026-11-08 standard: every sprite is built on one of
Infinite Fusion's own 320x320 overworld sheets), to check that the body, legs and walk cycle are still the base's.
Walking sheets are measured against the base game's 420 overworld sheets: height 24-31 native px (median 29),
14 colours a frame (median; 17 at p90), inside of the figure mostly colour, not outline.

It checks what can be measured: size, the 2x grid, hard alpha, colour count, no pure black, the near-black
outline, feet line, centre and height. Passing it is NOT approval: identity, head size, pose and readability are
judged by eye against the P1 sheet and the approved walking sprite. Needs Pillow."""
import sys, os
from collections import Counter
from PIL import Image

OUTLINE = (14, 8, 13)

def pixels(im):
    return im.get_flattened_data() if hasattr(im, "get_flattened_data") else im.getdata()

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

def value_stats(fr):
    """Mean lightness of a frame's figure, and the share of its inside (not edge) pixels that are near-black.
    Base game: lightness p10 0.29, median 0.37; dark inside median 17%, p90 34%."""
    import colorsys
    px = fr.load(); w, h = fr.size
    light, inner, dark = [], 0, 0
    for y in range(h):
        for x in range(w):
            p = px[x, y]
            if p[3] != 255:
                continue
            light.append(colorsys.rgb_to_hls(*[c / 255 for c in p[:3]])[1])
            if all(0 <= x + dx < w and 0 <= y + dy < h and px[x + dx, y + dy][3] == 255 for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                inner += 1
                dark += max(p[:3]) < 70
    return (sum(light) / len(light) if light else 1.0), (dark / inner if inner else 0.0)

def body_match(a, b, size=80):
    """Per frame: how much of the base's body below the neck (lower 55% of the figure) the new sheet keeps."""
    out = []
    for (cell, fa) in frames(a, size):
        fb = b.crop((cell[0] * size, cell[1] * size, cell[0] * size + size, cell[1] * size + size))
        bb = fb.getbbox()
        if not bb:
            continue
        top = bb[1] + int((bb[3] - bb[1]) * 0.45)
        pa, pb = fa.load(), fb.load()
        both = either = 0
        for y in range(top, bb[3]):
            for x in range(size):
                oa, ob = pa[x, y][3] > 0, pb[x, y][3] > 0
                both += oa and ob; either += oa or ob
        out.append((cell, both / either if either else 1.0))
    return out

def frames(im, size):
    w, h = im.size
    for fy in range(0, h, size):
        for fx in range(0, w, size):
            fr = im.crop((fx, fy, fx + size, fy + size))
            if fr.getbbox():
                yield (fx // size, fy // size), fr

def check(path, kind="human", walk=None, base=None):
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
        limit, frame, feet = 20, 80, 73
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
    if black and t in ("battle", "big creature"):
        fails.append(f"{black} pure #000000 pixels (use #0E080D or a tinted near-black)")

    # outline, feet, centre, height
    if t in ("walking", "pose", "big creature"):
        n = native(im)
        nf = frame // 2
        worst = []
        need = 0.42 if t == "walking" else 0.75   # walking: the base game's own sheets go down to 42% (p10)
        for (cx, cy), fr in frames(n, nf):
            share = outline_share(fr)
            if share < need:
                worst.append(f"frame r{cy}c{cx} {int(share * 100)}%")
        if worst:
            fails.append(f"outline broken (under {int(need * 100)}% of the edge near-black): " + ", ".join(worst[:6]) + (" ..." if len(worst) > 6 else ""))
        hs = []
        for (cx, cy), fr in frames(im, frame):
            x0, y0, x1, y1 = fr.getbbox()
            if t == "walking":
                # as the base game: standing frames on row 73 (or 75), walk frames 71-77
                fy = y1 - 1
                if (cx == 0 and fy not in (feet, feet + 2)) or not feet - 2 <= fy <= feet + 4:
                    fails.append(f"frame r{cy}c{cx}: feet on row {y1 - 1}, not {feet}")
                mid = (x0 + x1) / 2
                if abs(mid - frame / 2) > 4:
                    notes.append(f"frame r{cy}c{cx}: centred at x {mid:.0f} (guide: {frame // 2}; fine if a tail or prop pulls it)")
                if cx == 0:
                    hs.append((y1 - y0) // 2)
        if t == "walking":
            lt, dk = value_stats(im.crop((0, 0, frame, frame)))
            if dk > 0.34:
                fails.append(f"{int(dk * 100)}% of the figure's inside is near-black (base game: median 17%, 34% at most): "
                             "inner lines and shadows are a darker shade of the local colour, not outline")
            if lt < 0.29:
                fails.append(f"figure too dark: mean lightness {lt:.2f} (base game: median 0.37, 0.29 at least)")
            if base:
                bm = body_match(im, Image.open(base).convert("RGBA"))
                low = [f"r{c[1]}c{c[0]} {int(v * 100)}%" for c, v in bm if v < 0.75]
                if low:
                    fails.append("body and walk cycle differ from the base below the neck (under 75% shared): " + ", ".join(low[:6]))
                else:
                    notes.append(f"body kept from {os.path.basename(base)}: {int(min(v for _, v in bm) * 100)}% or more below the neck, every frame")
        if t == "walking" and hs:
            lo, hi = {"human": (24, 31), "goblin": (20, 24), "big": (26, 33)}.get(kind, (24, 31))
            if max(hs) > hi + 1 or min(hs) < lo:
                fails.append(f"standing height {min(hs)}-{max(hs)} native px (base game {lo}-{hi} for {kind})")
            elif max(hs) > hi:
                notes.append(f"standing height {max(hs)} native px, 1 over {hi}: fine for a hat or ears, not for a body")
            else:
                notes.append(f"height {min(hs)}-{max(hs)} native px; now compare the head and build by eye with the base sheet")
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
    kind, walk, base, files = "human", None, None, []
    i = 0
    while i < len(args):
        if args[i] == "--kind":
            kind = args[i + 1]; i += 2
        elif args[i] == "--walk":
            walk = args[i + 1]; i += 2
        elif args[i] == "--base":
            base = args[i + 1]; i += 2
        else:
            files.append(args[i]); i += 1
    if not files:
        print(__doc__); return 2
    bad = 0
    for f in files:
        name, t, fails, notes = check(f, kind, walk, base)
        print(f"{'PASS' if not fails else 'FAIL'}  {name}  ({t})")
        for x in fails:
            print(f"   x {x}")
        for x in notes:
            print(f"   - {x}")
        bad += bool(fails)
    print(f"\n{len(files) - bad}/{len(files)} pass the measurable rules. Then judge identity, build and face by eye beside the base sheet.")
    return 1 if bad else 0

if __name__ == "__main__":
    sys.exit(main())
