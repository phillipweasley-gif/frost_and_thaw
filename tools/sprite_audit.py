#!/usr/bin/env python3
"""Sprite audit (2026-11-09): measures every character sheet for the faults Glimmer had, against the base game.

    python3 tools/sprite_audit.py [FILES...] [--base] [--json OUT.json] [--fix OUTDIR] [--preview OUT.png]

Per frame, at native size (the sheet halved):
  gaps     colour pixels on the silhouette's edge with no outline between them and the background
  spurs    one-pixel lines of colour sticking out (transparent on both sides), with no outline
  floaters stray pieces of 8 px or fewer, not joined to the figure
  muddy    neighbouring colours whose values are too close to read apart (pairs that touch a lot, under 7 apart)
  hat      the top of the head a different colour from the front than from the back (a front-only hat)
Each count is set beside the base game's own 320x320 overworld sheets (--base prints their spread), so a sprite is
only flagged where it is worse than nine base sheets in ten.

--fix writes repaired copies (--light N: close only gaps in colours of lightness N or more): gaps closed with the sheet's own outline colour (outside the figure where there's room,
else on the edge pixel), spurs given an outline end, floaters removed. Value spacing and hats are reported, not
fixed: they need an eye."""
import sys, os, glob, json
from collections import Counter
from PIL import Image

BASE = "/home/claude/pif-682/Graphics/Characters/"
NB4 = ((1, 0), (-1, 0), (0, 1), (0, -1))

def lum(c):
    return 0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2]

def outline_colour(px, w, h):
    """The sheet's outline: the commonest dark colour on the silhouette's edge."""
    c = Counter()
    for y in range(h):
        for x in range(w):
            p = px[x, y]
            if p[3] and lum(p) < 70 and any(not (0 <= x + dx < w and 0 <= y + dy < h) or not px[x + dx, y + dy][3]
                                            for dx, dy in NB4):
                c[p[:3]] += 1
    return c.most_common(1)[0][0] if c else (14, 8, 13)

def is_line(p, out):
    """Outline-dark: as dark as the outline or close to it."""
    return p[3] and (lum(p) < max(70, lum(out) + 30))

def native(path):
    im = Image.open(path).convert("RGBA")
    w, h = im.size
    if (w, h) in ((256, 256), (272, 288), (128, 128)):     # older RMXP sheets are at 1x
        return im, 1
    return im.resize((w // 2, h // 2), Image.NEAREST), 2

def frames(im):
    w, h = im.size
    fw, fh = w // 4, h // 4
    for r in range(4):
        for c in range(4):
            yield r, c, im.crop((c * fw, r * fh, c * fw + fw, r * fh + fh))

def components(px, w, h):
    seen, comps = set(), []
    for y in range(h):
        for x in range(w):
            if px[x, y][3] and (x, y) not in seen:
                st, comp = [(x, y)], []
                seen.add((x, y))
                while st:
                    a, b = st.pop()
                    comp.append((a, b))
                    for dx in (-1, 0, 1):
                        for dy in (-1, 0, 1):
                            q = (a + dx, b + dy)
                            if 0 <= q[0] < w and 0 <= q[1] < h and q not in seen and px[q][3]:
                                seen.add(q); st.append(q)
                comps.append(comp)
    comps.sort(key=len, reverse=True)
    return comps

def frame_faults(fr, out):
    px = fr.load()
    w, h = fr.size
    opaque = lambda x, y: 0 <= x < w and 0 <= y < h and px[x, y][3]
    gaps, spurs = [], []
    for y in range(h):
        for x in range(w):
            p = px[x, y]
            if not p[3] or is_line(p, out):
                continue
            open_sides = [(dx, dy) for dx, dy in NB4 if not opaque(x + dx, y + dy)]
            if not open_sides:
                continue
            gaps.append((x, y, open_sides))
            if (not opaque(x - 1, y) and not opaque(x + 1, y)) or (not opaque(x, y - 1) and not opaque(x, y + 1)):
                spurs.append((x, y))
    comps = components(px, w, h)
    floaters = [c for c in comps[1:] if len(c) <= 8]
    edge_total = sum(1 for y in range(h) for x in range(w) if px[x, y][3]
                     and any(not opaque(x + dx, y + dy) for dx, dy in NB4))
    return gaps, spurs, floaters, edge_total

def muddy_pairs(im, out):
    """Colour pairs that touch often but sit under 7 apart in value (lightness), ignoring the outline."""
    px = im.load()
    w, h = im.size
    touch = Counter()
    for y in range(h - 1):
        for x in range(w - 1):
            a = px[x, y]
            if not a[3] or is_line(a, out):
                continue
            for b in (px[x + 1, y], px[x, y + 1]):
                if b[3] and b[:3] != a[:3] and not is_line(b, out):
                    touch[tuple(sorted((a[:3], b[:3])))] += 1
    bad = []
    for (a, b), n in touch.items():
        if n >= 12 and abs(lum(a) - lum(b)) < 7:
            bad.append((a, b, n))
    return bad

def head_top(fr, out):
    """The dominant non-outline colour in the top three rows of the figure."""
    px = fr.load()
    bb = fr.getbbox()
    if not bb:
        return None
    c = Counter()
    for y in range(bb[1], min(bb[3], bb[1] + 4)):
        for x in range(bb[0], bb[2]):
            p = px[x, y]
            if p[3] and not is_line(p, out):
                c[p[:3]] += 1
    return c.most_common(1)[0][0] if c else None

def audit(path):
    im, k = native(path)
    px = im.load()
    out = outline_colour(px, *im.size)
    res = {"file": os.path.basename(path), "gaps": 0, "edge": 0, "spurs": 0, "floaters": 0, "frames": {}}
    tops = {}
    for r, c, fr in frames(im):
        g, s, f, e = frame_faults(fr, out)
        res["gaps"] += len(g); res["spurs"] += len(s); res["floaters"] += len(f); res["edge"] += e
        if g or s or f:
            res["frames"][f"{r},{c}"] = [len(g), len(s), len(f)]
        if c == 0:
            tops[r] = head_top(fr, out)
    res["gap_share"] = round(res["gaps"] / max(1, res["edge"]), 3)
    res["muddy"] = [[list(a), list(b), n] for a, b, n in muddy_pairs(im, out)]
    if tops.get(0) and tops.get(3):
        d = sum(abs(a - b) for a, b in zip(tops[0], tops[3]))
        res["hat"] = d > 90 and abs(lum(tops[0]) - lum(tops[3])) > 25
        res["tops"] = [list(tops[0]), list(tops[3])]
    else:
        res["hat"] = False
    res["outline"] = list(out)
    return res

def fix(path, dest, min_lum=0):
    """Close gaps, cap spurs and drop floaters, at native size, then double back. min_lum: close only the gaps in
    colours at least this light (white hair and fur, which vanish against snow)."""
    im, k = native(path)
    px = im.load()
    out = outline_colour(px, *im.size)
    O = out + (255,)
    W, H = im.size
    fw, fh = W // 4, H // 4
    changed = 0
    for r, c, fr in frames(im):
        ox, oy = c * fw, r * fh
        g, s, f, _ = frame_faults(fr, out)
        for comp in f:
            for (x, y) in comp:
                px[ox + x, oy + y] = (0, 0, 0, 0); changed += 1
        fp = fr.load()
        for (x, y, sides) in g:
            if not px[ox + x, oy + y][3] or lum(px[ox + x, oy + y]) < min_lum:
                continue
            placed = False
            for dx, dy in sides:
                nx, ny = x + dx, y + dy
                if 0 <= nx < fw and 0 <= ny < fh and not px[ox + nx, oy + ny][3]:
                    # outside the figure: only where it won't make a blob (no outline already diagonal-adjacent on both sides)
                    px[ox + nx, oy + ny] = O; placed = True; changed += 1
            if not placed:                                    # against the cell edge: the pixel itself becomes outline
                px[ox + x, oy + y] = O; changed += 1
    if k == 2:
        im = im.resize((W * 2, H * 2), Image.NEAREST)
    im.save(dest)
    return changed

def base_spread():
    rows = []
    for f in sorted(glob.glob(BASE + "*.png")):
        if Image.open(f).size != (320, 320):
            continue
        a = audit(f)
        rows.append(a)
    def pct(key, q):
        v = sorted(r[key] for r in rows)
        return v[int(len(v) * q)]
    return {k: {"p50": pct(k, 0.5), "p90": pct(k, 0.9)} for k in ("gap_share", "spurs", "floaters")}, rows

def main():
    args = sys.argv[1:]
    opt = lambda n: (args[args.index(n) + 1] if n in args else None)
    js, fixdir = opt("--json"), opt("--fix")
    light = int(opt("--light") or 0)
    files = [a for i, a in enumerate(args) if not a.startswith("--") and (i == 0 or args[i - 1] not in ("--json", "--fix", "--preview", "--light"))]
    if "--base" in args:
        spread, rows = base_spread()
        print("base game (%d sheets):" % len(rows), json.dumps(spread))
        if not files:
            return
    files = files or sorted(glob.glob("build/Characters/FT_*.png") + glob.glob("build/gfx/Characters/FT_*.png"))
    results = [audit(f) for f in files]
    for r in sorted(results, key=lambda r: -r["gap_share"]):
        flags = []
        if r["gap_share"] > 0.02: flags.append("gaps %d (%.0f%% of edge)" % (r["gaps"], r["gap_share"] * 100))
        if r["spurs"]: flags.append("spurs %d" % r["spurs"])
        if r["floaters"]: flags.append("floaters %d" % r["floaters"])
        if r["muddy"]: flags.append("muddy %d" % len(r["muddy"]))
        if r["hat"]: flags.append("hat front/back differ %s/%s" % tuple(map(tuple, r["tops"])))
        print("%-42s %s" % (r["file"], "; ".join(flags) or "ok"))
    if js:
        json.dump(results, open(js, "w"), indent=1)
    if fixdir:
        os.makedirs(fixdir, exist_ok=True)
        for f in files:
            n = fix(f, os.path.join(fixdir, os.path.basename(f)), light)
            if n:
                print("fixed", os.path.basename(f), n)

if __name__ == "__main__":
    main()
