#!/usr/bin/env python3
"""The dragons' cutscene sheets (K-*), made from their own walking sheets (2026-11-09), as tools/posegen.py makes the
cast's poses: the same pixels moved, squashed, recoloured, with the base game's outline on anything new.

    python3 tools/dragongen.py [--out build/Characters] [--preview OUT.png] [IDS...]

Sheets are 512x512 like the dragons' own: 4 rows (facing down, left, right, up) x 4 frames, each 64x64 native
drawn at 2x. Every row is made, so a scene can play any facing; the art list's facing is the one designed for.
  Frostina    K-FRO-01 lands like snow, -02 lowers her head and hums, -03 takes off, -04 breathes frost,
              -05 the crystal closes over her, -06 tumbles out of it and shakes, -07 flying
  Razzilith   K-RAZ-01 lands hard (the cobbles crack), -02 takes off, -03 roars at the sky, -04 breathes leaves and
              light, -06 flying
  The chained dragon (FT_chardalyn)  K-CHD-01 its eyes light gold, -02 tears free, -03 dives and breathes a line
              of light, -04 lands and roars, -05 shatters into black crystal, -06 flying
The flying sheets carry no riders: at the dragons' scale a cast sprite on the back reads as a giant head.
Wired in: 024 (the market landing and take-off), 034 (the chains), 035 (take-off, Good Mead, the square), 037 (the
crystal), 039 (out of the crystal, through the roof, the song)."""
import os, sys, math, random
from PIL import Image

D = "build/Characters/"
N = 64
OUT = (6, 6, 8)
SNOW = [(214, 228, 244), (250, 252, 255)]
DUST = [(120, 100, 76), (168, 146, 112)]
FROST = [(150, 200, 240), (210, 236, 255), (255, 255, 255)]
LEAF = [(70, 140, 60), (130, 190, 70), (240, 220, 110), (255, 250, 210)]
LIGHT = [(200, 170, 90), (255, 230, 140), (255, 255, 230)]
GOLD = [(200, 150, 40), (255, 220, 100)]
GLASS = [(20, 20, 28), (60, 66, 84), (130, 140, 170)]

def load(name):
    return Image.open(D + name + ".png").convert("RGBA").resize((N * 4, N * 4), Image.NEAREST)

def cell(sheet, row, col=0):
    return sheet.crop((col * N, row * N, col * N + N, row * N + N))

def blank():
    return Image.new("RGBA", (N, N), (0, 0, 0, 0))

def save(rows, path):
    out = Image.new("RGBA", (N * 4, N * 4), (0, 0, 0, 0))
    for r, frames in enumerate(rows):
        for c, fr in enumerate(frames):
            out.alpha_composite(fr, (c * N, r * N))
    out.resize((N * 8, N * 8), Image.NEAREST).save(path)
    return out

def bounds(fr):
    return fr.getbbox()

def shift(fr, dx, dy):
    out = blank()
    out.alpha_composite(fr.crop((max(0, -dx), max(0, -dy), N - max(0, dx), N - max(0, dy))), (max(0, dx), max(0, dy)))
    return out

def stamp(fr, pts):
    out = fr.copy()
    px = out.load()
    for (x, y), c in pts.items():
        if 0 <= x < N and 0 <= y < N:
            px[x, y] = (c + (255,)) if len(c) == 3 else c
    return out

def under(fr, pts):
    """Pixels drawn behind the figure (a shadow, dust on the ground)."""
    out = stamp(blank(), pts)
    out.alpha_composite(fr)
    return out

def squash(fr, k):
    """Crouch: k rows out of the legs, the body comes down onto the feet."""
    x0, y0, x1, y1 = bounds(fr)
    legs = list(range(y1 - 2 - k, y1 - 2))
    out = blank()
    rows = [y for y in range(N) if y not in legs]
    for i, y in enumerate(rows):
        out.paste(fr.crop((0, y, N, y + 1)), (0, i + k))
    return out

def shadow(fr, scale=1.0):
    x0, y0, x1, y1 = bounds(fr)
    cx, w = (x0 + x1) / 2, (x1 - x0) * 0.4 * scale
    pts = {}
    for x in range(int(cx - w), int(cx + w) + 1):
        for dy in (0, 1):
            if abs(x - cx) < w - dy * 2:
                pts[(x, 61 + dy)] = (0, 0, 0, 70)
    return pts

def puff(cx, y, colours, spread, seed):
    rnd = random.Random(seed)
    pts = {}
    for _ in range(spread * 3):
        dx = rnd.randint(-spread, spread)
        dy = -rnd.randint(0, max(1, spread // 3))
        pts[(int(cx + dx), y + dy)] = colours[rnd.randrange(len(colours))]
    return pts

def ground_y(fr):
    return bounds(fr)[3] - 1

def outline(pts):
    out = dict(pts)
    for (x, y) in pts:
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            if (x + dx, y + dy) not in pts:
                out.setdefault((x + dx, y + dy), OUT)
    return out

# --- actions -----------------------------------------------------------------------------------------------------
def land(fr, gentle, seed):
    g = ground_y(fr)
    cx = (bounds(fr)[0] + bounds(fr)[2]) / 2
    high = under(shift(fr, 0, -22), shadow(fr, 0.5))
    low = under(shift(fr, 0, -8), shadow(fr, 0.8))
    if gentle:                                          # snow lifts round her, softly
        touch = under(squash(fr, 2), puff(cx, g, SNOW, 12, seed))
        settle = under(fr, puff(cx, g, SNOW[1:], 7, seed + 1))
    else:                                               # he hits hard: cracks and a burst of grit
        cracks = {}
        for sgn in (-1, 1):
            x, y = int(cx), g
            for i in range(9):
                x += sgn * (1 if i % 3 else 2)
                y += (1 if i % 4 == 1 else 0)
                cracks[(x, y)] = (40, 34, 30)
        touch = under(squash(fr, 4), {**cracks, **puff(cx, g - 1, DUST, 16, seed)})
        settle = under(squash(fr, 1), cracks)
    return [high, low, touch, settle]

def takeoff(fr):
    return [squash(fr, 3), under(shift(fr, 0, -7), shadow(fr, 0.8)), under(shift(fr, 0, -18), shadow(fr, 0.55)),
            under(shift(fr, 0, -32), shadow(fr, 0.3))]

def head_rows(fr):
    x0, y0, x1, y1 = bounds(fr)
    return y0, y0 + (y1 - y0) // 3

def lower_head(fr, k, tilt=0):
    """The head (top third) drawn k rows lower over the neck, sheared by tilt."""
    y0, y1 = head_rows(fr)
    head = fr.crop((0, y0, N, y1))
    out = fr.copy()
    out.paste(Image.new("RGBA", (N, k), (0, 0, 0, 0)), (0, y0))
    if tilt:
        sheared = blank().crop((0, 0, N, y1 - y0))
        for y in range(y1 - y0):
            sheared.paste(head.crop((0, y, N, y + 1)), (tilt if y < (y1 - y0) // 2 else 0, y))
        head = sheared
    out.alpha_composite(head, (0, y0 + k))
    return out

def raise_head(fr, k, dx=0):
    y0, y1 = head_rows(fr)
    head = fr.crop((0, y0, N, y1))
    out = fr.copy()
    out.alpha_composite(head, (dx, y0 - k))
    return out

def mouth(fr, row):
    """Where the breath comes from: the head's leading edge for the facing."""
    x0, y0, x1, y1 = bounds(fr)
    hy0, hy1 = head_rows(fr)
    px = fr.load()
    if row == 1:
        xs = [(x, y) for y in range(hy0, hy1 + 4) for x in range(N) if px[x, y][3]]
        x, y = min(xs)
        return x, y + 2, -1, 0
    if row == 2:
        xs = [(x, y) for y in range(hy0, hy1 + 4) for x in range(N) if px[x, y][3]]
        x, y = max(xs)
        return x, y + 2, 1, 0
    if row == 0:
        return (x0 + x1) // 2, hy1 + 2, 0, 1
    return (x0 + x1) // 2, hy0, 0, -1

def breath(fr, row, colours, length, seed, line=False):
    mx, my, dx, dy = mouth(fr, row)
    rnd = random.Random(seed)
    pts = {}
    for i in range(1, length):
        spread = 0 if line else i // 4
        for _ in range(1 if line else 2):
            ox = rnd.randint(-spread, spread)
            p = (mx + dx * i + (ox if dy else 0), my + dy * i + (ox if dx else 0))
            pts[p] = colours[min(len(colours) - 1, (i * len(colours)) // length)] if line else colours[rnd.randrange(len(colours))]
        if line:
            pts[(mx + dx * i + (1 if dy else 0), my + dy * i + (1 if dx else 0))] = colours[-1]
    return stamp(fr, pts)

def breathe(fr, row, colours, seed, line=False):
    rear = raise_head(fr, 1)
    return [fr, rear, breath(fr, row, colours, 14, seed, line), breath(fr, row, colours, 22, seed + 1, line)]

def roar(fr, row):
    up = raise_head(fr, 2)
    return [fr, up, raise_head(fr, 3, 1), raise_head(fr, 3, -1)]

def crystal_close(fr, crystal):
    x0, y0, x1, y1 = bounds(crystal)
    h = y1 - y0
    frames = [fr]
    for k in (1, 2):
        cut = y1 - h * k // 3
        part = crystal.copy()
        part.paste(Image.new("RGBA", (N, cut), (0, 0, 0, 0)), (0, 0))
        f = fr.copy()
        f.alpha_composite(part)
        frames.append(f)
    frames.append(crystal)
    return frames

def tumble(fr, crystal, seed):
    rnd = random.Random(seed)
    melt = crystal.copy()
    px = melt.load()
    for y in range(N):
        for x in range(N):
            if px[x, y][3] and rnd.random() < 0.45 + (N - y) / N * 0.3:
                px[x, y] = (0, 0, 0, 0)
    melted = fr.copy()
    melted.alpha_composite(melt)
    g = ground_y(fr)
    cx = (bounds(fr)[0] + bounds(fr)[2]) / 2
    drops = lambda s: {(int(cx + rnd.randint(-16, 16)), rnd.randint(bounds(fr)[1], g)): FROST[rnd.randrange(3)] for _ in range(10)}
    down = under(squash(fr, 4), puff(cx, g, [(170, 210, 240), (210, 236, 255)], 12, seed))
    return [melted, down, stamp(shift(fr, -2, 0), drops(1)), stamp(shift(fr, 2, 0), drops(2))]

def flying(fr, rider, f, row):
    bob = [0, -2, -3, -1][f]
    body = shift(fr, 0, -16 + bob)
    if rider is not None:
        body = seat(body, rider, row)
    return under(body, shadow(fr, 0.6))

def seat(body, rider, row):
    """The rider's upper half on the dragon's back (behind the head facing down, over it facing up)."""
    x0, y0, x1, y1 = bounds(body)
    rb = rider.crop(rider.getbbox())
    top = rb.crop((0, 0, rb.width, int(rb.height * 0.62)))
    cx = (x0 + x1) // 2 + {1: 4, 2: -4}.get(row, 0)
    y = y0 + (y1 - y0) // 3 - top.height + 4
    out = body.copy()
    if row == 0:                                        # facing us: the rider behind the head
        back = blank()
        back.alpha_composite(top, (cx - top.width // 2, y - 3))
        back.alpha_composite(body)
        return back
    out.alpha_composite(top, (cx - top.width // 2, y))
    return out

def eyes(fr):
    x0, y0, x1, y1 = bounds(fr)
    cx = (x0 + x1) // 2
    ey = y0 + 9
    return [(cx - 3, ey), (cx - 2, ey), (cx + 2, ey), (cx + 3, ey)]

def darken(fr, k):
    out = fr.copy()
    px = out.load()
    for y in range(N):
        for x in range(N):
            r, g, b, a = px[x, y]
            if a:
                px[x, y] = (int(r * k), int(g * k), int(b * k), a)
    return out

def eyes_gold(fr):
    dark = darken(fr, 0.55)
    lit = lambda f, c: stamp(f, {p: c for p in eyes(fr)})
    return [dark, lit(dark, GOLD[0]), dark, lit(fr, GOLD[1])]

def chains(fr, taut):
    x0, y0, x1, y1 = bounds(fr)
    pts = {}
    for i, (ax, ay, bx, by) in enumerate(((x0 - 6, y0 + 12, x0 + 8, y0 + 18), (x1 + 6, y0 + 12, x1 - 8, y0 + 18),
                                          (x0 - 6, y1 - 4, x0 + 10, y1 - 8), (x1 + 6, y1 - 4, x1 - 10, y1 - 8))):
        n = max(abs(bx - ax), abs(by - ay))
        for t in range(n + 1):
            x = ax + (bx - ax) * t // n
            y = ay + (by - ay) * t // n + (0 if taut else int(2 * math.sin(math.pi * t / n)))
            pts[(x, y)] = (110, 96, 70) if t % 2 else (70, 60, 44)
    return pts

def tear_free(fr, seed):
    rnd = random.Random(seed)
    held = stamp(fr, chains(fr, False))
    strain = stamp(shift(fr, 0, -1), chains(fr, True))
    links = {(rnd.randint(4, 60), rnd.randint(10, 58)): (110, 96, 70) for _ in range(14)}
    burst = stamp(shift(fr, 0, -4), links)
    return [held, strain, burst, under(shift(fr, 0, -24), shadow(fr, 0.5))]

def dive_breathe(fr, row, seed):
    return [under(shift(fr, 0, -26), shadow(fr, 0.4)), under(shift(fr, 0, -12), shadow(fr, 0.7)),
            breath(under(shift(fr, 0, -12), shadow(fr, 0.7)), row, LIGHT, 26, seed, line=True),
            breath(under(shift(fr, 0, -10), shadow(fr, 0.7)), row, LIGHT, 34, seed, line=True)]

def shatter(fr, seed):
    rnd = random.Random(seed)
    x0, y0, x1, y1 = bounds(fr)
    cx = (x0 + x1) // 2
    crack = {}
    x = cx
    for y in range(y0 + 2, y1 - 2):
        x += rnd.choice((-1, 0, 0, 1))
        if fr.getpixel((x, y))[3]:
            crack[(x, y)] = (220, 230, 255)
    cracked = stamp(fr, crack)
    left = fr.crop((0, 0, cx, N)); right = fr.crop((cx, 0, N, N))
    split = blank(); split.alpha_composite(left, (-3, 1)); split.alpha_composite(right, (cx + 3, 0))
    px = fr.load()
    pix = [(x, y) for y in range(y0, y1) for x in range(x0, x1) if px[x, y][3]]
    burst = blank(); bp = burst.load()
    for (x, y) in rnd.sample(pix, len(pix) // 3):
        nx, ny = x + (x - cx) // 2 + rnd.randint(-2, 2), y + rnd.randint(-6, 4)
        if 0 <= nx < N and 0 <= ny < N:
            bp[nx, ny] = px[x, y]
    shards = blank(); sp = shards.load()
    for _ in range(26):
        x, y = rnd.randint(x0 - 8, x1 + 8), rnd.randint(y1 - 8, y1 + 2)
        if 0 <= x < N and 0 <= y < N:
            sp[x, y] = GLASS[rnd.randrange(3)] + (255,)
    return [cracked, split, burst, shards]

# --- jobs ------------------------------------------------------------------------------------------------------------
def per_row(src, fn):
    sh = load(src)
    return [fn(cell(sh, r), r) for r in range(4)]

def riders(name):
    return Image.open(D + name + ".png").convert("RGBA").resize((160, 160), Image.NEAREST)

def rider_cell(name, row):
    return riders(name).crop((0, row * 40, 40, row * 40 + 40))

def flying_sheet(src, rider_name):
    sh = load(src)
    return [[flying(cell(sh, r, f), rider_cell(rider_name, r) if rider_name else None, f, r) for f in range(4)] for r in range(4)]

JOBS = {
    "K-FRO-01": lambda: per_row("FT_frostina", lambda fr, r: land(fr, True, 10 + r)),
    "K-FRO-02": lambda: per_row("FT_frostina", lambda fr, r: [fr, lower_head(fr, 2), lower_head(fr, 2, 1), lower_head(fr, 2)]),
    "K-FRO-03": lambda: per_row("FT_frostina", lambda fr, r: takeoff(fr)),
    "K-FRO-04": lambda: per_row("FT_frostina", lambda fr, r: breathe(fr, r, FROST, 40 + r)),
    "K-FRO-05": lambda: [crystal_close(cell(load("FT_frostina"), r), cell(load("FT_frostina_crystal"), r)) for r in range(4)],
    "K-FRO-06": lambda: [tumble(cell(load("FT_frostina"), r), cell(load("FT_frostina_crystal"), r), 60 + r) for r in range(4)],
    "K-FRO-07": lambda: flying_sheet("FT_frostina", None),     # (riders left off: at the dragons' scale a cast sprite reads as a giant head)
    "K-RAZ-01": lambda: per_row("FT_razzilith", lambda fr, r: land(fr, False, 20 + r)),
    "K-RAZ-02": lambda: per_row("FT_razzilith", lambda fr, r: takeoff(fr)),
    "K-RAZ-03": lambda: per_row("FT_razzilith", lambda fr, r: roar(fr, r)),
    "K-RAZ-04": lambda: per_row("FT_razzilith", lambda fr, r: breathe(fr, r, LEAF, 70 + r)),
    "K-RAZ-06": lambda: flying_sheet("FT_razzilith", None),
    "K-CHD-01": lambda: per_row("FT_chardalyn", lambda fr, r: eyes_gold(fr) if r == 0 else [darken(fr, 0.55), fr, darken(fr, 0.55), fr]),
    "K-CHD-02": lambda: per_row("FT_chardalyn", lambda fr, r: tear_free(fr, 80 + r)),
    "K-CHD-03": lambda: per_row("FT_chardalyn", lambda fr, r: dive_breathe(fr, r, 90 + r)),
    "K-CHD-04": lambda: per_row("FT_chardalyn", lambda fr, r: land(fr, False, 100 + r)[:3] + [raise_head(fr, 3)]),
    "K-CHD-05": lambda: per_row("FT_chardalyn", lambda fr, r: shatter(fr, 110 + r)),
    "K-CHD-06": lambda: flying_sheet("FT_chardalyn", None),
}

def main():
    args = sys.argv[1:]
    out = args[args.index("--out") + 1] if "--out" in args else D
    prev = args[args.index("--preview") + 1] if "--preview" in args else None
    ids = [a for a in args if a.startswith("K-")] or list(JOBS)
    os.makedirs(out, exist_ok=True)
    made = []
    for k in ids:
        made.append((k, save(JOBS[k](), os.path.join(out, k + ".png"))))
        print(k)
    if prev:
        pv = Image.new("RGBA", (N * 4 * 2 + 8, (N * 4 + 8) * ((len(made) + 1) // 2)), (150, 168, 150, 255))
        for i, (_, sh) in enumerate(made):
            pv.alpha_composite(sh, ((i % 2) * (N * 4 + 8), (i // 2) * (N * 4 + 8)))
        pv.save(prev)

if __name__ == "__main__":
    main()
