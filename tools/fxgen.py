#!/usr/bin/env python3
"""Frost & Thaw map effects, generated pixel-exact (2026-11-09).

    python3 tools/fxgen.py E-13 [E-16 ...] [--out build/gfx/Animations] [--preview PREVIEW.png]

Format (as Stage.fx reads it and as E-01..E-14 are drawn): 960 px wide, 192x192 cells, 5 per row, drawn at
96x96 native and scaled exactly 2x; alpha 0/255; at most 12 colours (16 for E-08, E-18, E-19); every shape gets a
1-px native outline in the darkest tone of its own ramp, and a bright core. The cell's centre (96, 96) is the
spot Stage.fx places on the character or tile, so ground effects sit on the centre row.
Each effect is a function that draws one native frame from t in 0..1. Randomness is seeded, so a rebuild gives
the same pixels."""
import math, random, sys, os
from PIL import Image

N = 96            # native cell
CX, CY = 48, 48   # the anchor

def blank():
    return [[None] * N for _ in range(N)]

def put(g, x, y, c):
    x, y = int(round(x)), int(round(y))
    if 0 <= x < N and 0 <= y < N:
        g[y][x] = c

def outline(g, edge_of):
    """Outline every shape: a transparent pixel next to an opaque one takes the darkest tone of that pixel's ramp."""
    out = [row[:] for row in g]
    for y in range(N):
        for x in range(N):
            if g[y][x] is not None:
                continue
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                nx, ny = x + dx, y + dy
                if 0 <= nx < N and 0 <= ny < N and g[ny][nx] is not None:
                    out[y][x] = edge_of(g[ny][nx])
                    break
    return out

def render(frames, edge_of):
    rows = math.ceil(len(frames) / 5)
    sheet = Image.new("RGBA", (960, 192 * rows), (0, 0, 0, 0))
    for i, g in enumerate(frames):
        g = outline(g, edge_of)
        cell = Image.new("RGBA", (N, N), (0, 0, 0, 0))
        px = cell.load()
        for y in range(N):
            for x in range(N):
                if g[y][x] is not None:
                    px[x, y] = g[y][x] + (255,)
        sheet.alpha_composite(cell.resize((192, 192), Image.NEAREST), ((i % 5) * 192, (i // 5) * 192))
    return sheet

def ramp_edge(ramps):
    """Map any colour to the darkest tone of the ramp it belongs to."""
    lookup = {}
    for r in ramps:
        for c in r:
            lookup[c] = r[0]
    return lambda c: lookup.get(c, ramps[0][0])

def blob(g, x, y, c, size=2):
    """A chunky particle: size x size native pixels."""
    for dx in range(size):
        for dy in range(size):
            put(g, x + dx, y + dy, c)

def star(g, x, y, c, core):
    """A small twinkle: a plus with a bright centre (as on E-01)."""
    for dx, dy in ((0, 0), (1, 0), (-1, 0), (0, 1), (0, -1)):
        put(g, x + dx, y + dy, c)
    put(g, x, y, core)

def ring(g, cx, cy, r, th, squash, shade, skip=None):
    for y in range(N):
        for x in range(N):
            dx, dy = x - cx, (y - cy) / squash
            d = math.hypot(dx, dy)
            if abs(d - r) <= th:
                if skip and skip(x, y, math.atan2(dy, dx)):
                    continue
                g[y][x] = shade(1 - abs(d - r) / th, y < cy)

# ---------------------------------------------------------------- E-13: the engine vents, a ring of heat rolls outward
FIRE = [(92, 22, 18), (178, 52, 26), (232, 112, 40), (250, 184, 72), (255, 236, 168)]

def e13(n=10):
    rnd = random.Random(13)
    tongues = [rnd.uniform(0, 2 * math.pi) for _ in range(14)]
    embers = [(rnd.uniform(0, 2 * math.pi), rnd.uniform(0.6, 1.1), rnd.uniform(4, 14)) for _ in range(12)]
    frames = []
    for i in range(n):
        t = i / (n - 1)
        g = blank()
        r = 6 + 38 * (1 - (1 - t) ** 1.7)
        th = max(1.5, 7 * (1 - t) + 1.5)
        shade = lambda k, back: FIRE[4] if k > 0.75 and t < 0.5 else FIRE[3] if k > 0.45 else FIRE[2] if k > 0.15 else FIRE[1]
        skip = (lambda x, y, a: int((a + 3.2) * 6) % 3 == 0) if t > 0.6 else None
        ring(g, CX, CY, r, th, 0.42, shade, skip)
        # flame tongues licking up off the ring, shorter as it cools
        hmax = 9 * (1 - t) ** 0.8
        for a in tongues:
            if t > 0.75 and int(a * 10) % 2:
                continue
            bx, by = CX + math.cos(a) * r, CY + math.sin(a) * r * 0.42
            h = hmax * (0.6 + 0.4 * math.sin(a * 5 + i))
            for k in range(int(h)):
                w = max(0, int((h - k) / h * 2.2))
                for dx in range(-w, w + 1):
                    put(g, bx + dx, by - k, FIRE[4] if k < h * 0.3 and dx == 0 and t < 0.5 else FIRE[3] if k < h * 0.6 else FIRE[2])
        if t < 0.3:                                  # the vent's burst at the centre
            fr = 8 * (1 - t / 0.3)
            for y in range(N):
                for x in range(N):
                    d = math.hypot(x - CX, (y - CY) / 0.5)
                    if d < fr:
                        g[y][x] = FIRE[4] if d < fr * 0.5 else FIRE[3]
        for a, sp, lift in embers:                   # embers flung out and rising
            if t < 0.9:
                ex = CX + math.cos(a) * r * sp
                ey = CY + math.sin(a) * r * sp * 0.42 - lift * t * 2
                blob(g, ex, ey, FIRE[3] if t < 0.55 else FIRE[2])
        frames.append(g)
    return frames, ramp_edge([FIRE])

# ---------------------------------------------------------------- E-16: a wave of cold rolls off Sephek
ICE = [(28, 40, 82), (62, 104, 168), (122, 172, 222), (192, 226, 248), (246, 252, 255)]

def e16(n=10):
    rnd = random.Random(16)
    spikes = [rnd.uniform(0, 2 * math.pi) for _ in range(18)]
    chunks = [(rnd.uniform(0, 2 * math.pi), rnd.uniform(0.7, 1.15), rnd.uniform(3, 10)) for _ in range(16)]
    frames = []
    for i in range(n):
        t = i / (n - 1)
        g = blank()
        r = 5 + 41 * (1 - (1 - t) ** 1.9)
        th = max(1.5, 6 * (1 - t) + 1.5)
        shade = lambda k, back: ICE[4] if k > 0.75 and t < 0.45 else ICE[3] if k > 0.4 else ICE[2]
        skip = (lambda x, y, a: (x * 7 + y * 3) % 4 == 0) if t > 0.7 else None
        ring(g, CX, CY + 6, r, th, 0.38, shade, skip)
        # ice spikes thrown up along the front, pointing outward and up
        hmax = 8 * (1 - t) ** 0.7
        for a in spikes:
            bx, by = CX + math.cos(a) * r, CY + 6 + math.sin(a) * r * 0.38
            h = hmax * (0.5 + 0.5 * abs(math.sin(a * 3)))
            lean = math.cos(a) * 0.5
            for k in range(int(h)):
                w = int((h - k) / h * 1.6)
                for dx in range(-w, w + 1):
                    put(g, bx + dx + lean * k, by - k, ICE[4] if dx == 0 and k > h * 0.5 else ICE[3])
        if False:                                    # (a dithered frost fill read as a dark disc once outlined)
            for y in range(N):
                for x in range(N):
                    d = math.hypot(x - CX, (y - CY - 6) / 0.38)
                    if d < r - th - 1 and (x + y) % 2 == 0 and (x * 3 + y) % 7 < 2 and g[y][x] is None:
                        g[y][x] = ICE[2]
        for a, sp, lift in chunks:                   # snow and ice chunks blown outward
            if t < 0.95:
                cx_ = CX + math.cos(a) * r * sp
                cy_ = CY + 6 + math.sin(a) * r * sp * 0.38 - lift * math.sin(t * math.pi)
                blob(g, cx_, cy_, ICE[4] if sp > 0.9 else ICE[3])
        frames.append(g)
    return frames, ramp_edge([ICE])

# ---------------------------------------------------------------- E-33: a soft column of light going up and fading
LIGHT = [(110, 88, 44), (200, 166, 92), (238, 214, 150), (252, 244, 210), (255, 255, 250)]

def e33(n=6):
    rnd = random.Random(33)
    motes = [(rnd.uniform(-1, 1), rnd.uniform(0, 1)) for _ in range(12)]
    widths = [2, 6, 10, 11, 8, 4]
    tops = [44, 20, 0, 0, 0, 0]
    frames = []
    for i in range(n):
        g = blank()
        w, top, base = widths[i], tops[i], CY + 4
        for y in range(top, base + 1):
            for x in range(N):
                d = abs(x - CX)
                if d <= w:
                    k = 1 - d / w
                    halo = k < 0.35
                    if halo and (x + y) % 2 == 0:
                        continue                     # dithered soft edge
                    if i >= 4 and k < 0.6 and (x + y) % 2 == 1:
                        continue                     # fading: the body thins to a dither
                    g[y][x] = LIGHT[4] if k > 0.75 else LIGHT[3] if k > 0.45 else LIGHT[2]
        if 1 <= i <= 4:                              # the pool of light at the foot
            for y in range(base - 2, base + 4):
                for x in range(N):
                    rr = (w + 8) * (1 - abs(y - base - 1) / 4)
                    if abs(x - CX) <= rr and g[y][x] is None and (x + y) % 2 == 0:
                        g[y][x] = LIGHT[2]
        for mx, my in motes:                         # twinkles rising beside the beam
            x = CX + mx * (w + 7)
            y = base - (my * 44 + i * 7) % 52
            if i < 5 and top <= y < base - 2:
                star(g, x, y, LIGHT[3], LIGHT[4])
        frames.append(g)
    return frames, ramp_edge([LIGHT])

EFFECTS = {"E-13": e13, "E-16": e16, "E-33": e33}

def main():
    args = sys.argv[1:]
    out_dir, preview, ids = "build/gfx/Animations", None, []
    i = 0
    while i < len(args):
        if args[i] == "--out":
            out_dir = args[i + 1]; i += 2
        elif args[i] == "--preview":
            preview = args[i + 1]; i += 2
        else:
            ids.append(args[i]); i += 1
    sheets = []
    for e in ids:
        frames, edge = EFFECTS[e]()
        sheet = render(frames, edge)
        os.makedirs(out_dir, exist_ok=True)
        sheet.save(os.path.join(out_dir, e + ".png"))
        sheets.append(sheet)
        print(e, sheet.size, len({p for p in sheet.getdata() if p[3]}), "colours")
    if preview and sheets:
        h = sum(s.height for s in sheets)
        p = Image.new("RGBA", (960, h), (58, 66, 78, 255))
        y = 0
        for s in sheets:
            p.alpha_composite(s, (0, y)); y += s.height
        p.save(preview)

if __name__ == "__main__":
    main()
