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
# Rootspire's beacon, seen from Bryn Shander (Ch9): a green-gold light, the tree's colour
LIGHT = [(52, 92, 40), (130, 180, 80), (200, 230, 140), (240, 250, 200), (255, 255, 240)]

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

# ================================================================ batch 2 (2026-11-09)
SMOKE = [(40, 38, 44), (84, 80, 88), (132, 128, 136), (180, 176, 184)]
SILVER = [(52, 60, 84), (124, 136, 168), (196, 206, 228), (246, 248, 255)]
GREEN = [(22, 70, 40), (52, 140, 70), (120, 206, 110), (214, 250, 190)]
DARK = [(14, 8, 13), (48, 22, 58), (96, 44, 110), (168, 96, 186), (236, 200, 246)]
HELL = [(40, 6, 10), (110, 14, 18), (186, 36, 26), (236, 96, 48), (255, 196, 120)]
LEAF = [(24, 62, 30), (58, 118, 50), (118, 182, 70), (206, 236, 140)]

def lines_from(g, x0, y0, n, length, c, rnd, jitter=0.6):
    """Crack lines: n random walks out from a point."""
    for k in range(n):
        a = rnd.uniform(0, 2 * math.pi)
        x, y = x0, y0
        for s in range(int(length)):
            a += rnd.uniform(-jitter, jitter)
            x += math.cos(a); y += math.sin(a)
            put(g, x, y, c)

def capsule(x, y, cx, top, bot, w):
    """Inside a person-sized upright capsule."""
    if y < top or y > bot:
        return False
    r = w / 2
    if y < top + r:
        return math.hypot(x - cx, y - (top + r)) <= r
    if y > bot - r:
        return math.hypot(x - cx, y - (bot - r)) <= r
    return abs(x - cx) <= r

# ---------------------------------------------------------------- E-05: ice cracks and falls away from a body
def e05(n=10):
    rnd = random.Random(5)
    top, bot, w = 30, 66, 20
    cracks = []
    cr = random.Random(55)
    for k in range(7):
        a = cr.uniform(0, 2 * math.pi); x, y = CX, 46; path = []
        for s in range(22):
            a += cr.uniform(-0.7, 0.7); x += math.cos(a); y += math.sin(a) * 1.3; path.append((x, y))
        cracks.append(path)
    # the shell breaks into chunks: each pixel of the shell belongs to the nearest of these seeds
    seeds = [(rnd.uniform(CX - w / 2, CX + w / 2), rnd.uniform(top, bot)) for _ in range(9)]
    vel = [((sx - CX) * 0.18 + rnd.uniform(-0.6, 0.6), rnd.uniform(-1.6, -0.4)) for sx, sy in seeds]
    frames = []
    for i in range(n):
        g = blank()
        t = i
        for y in range(N):
            for x in range(N):
                if not capsule(x, y, CX, top, bot, w):
                    continue
                if (x - CX) % 7 == 0 and (y % 3 == 0):
                    pass
                if i < 4:
                    shade = ICE[4] if x < CX - w / 2 + 4 and y < top + 14 else ICE[3] if x < CX + 2 else ICE[2]
                    if (x + y) % 2 == 0 and x > CX + 4:
                        continue                         # the shell is clear ice: the body shows through
                    g[y][x] = shade
                else:
                    k = min(range(len(seeds)), key=lambda q: (x - seeds[q][0]) ** 2 + (y - seeds[q][1]) ** 2)
                    tt = i - 3
                    vx, vy = vel[k]
                    nx, ny = x + vx * tt * 2.2, y + vy * tt + 0.45 * tt * tt   # thrown out, then falling
                    if ny < 70 and (i < 8 or (x + y + i) % 2 == 0):
                        put(g, nx, ny, ICE[3] if (x + y) % 3 else ICE[4])
        upto = min(len(cracks[0]), (i + 1) * 6)
        if i < 4:
            for path in cracks:
                for (x, y) in path[:upto]:
                    if capsule(int(x), int(y), CX, top, bot, w):
                        put(g, x, y, ICE[1])
        if i >= 6:                                       # shards settling on the ground at the feet
            for k in range(10):
                put(g, CX - 18 + k * 4 + (i % 2), 69, ICE[3]); put(g, CX - 17 + k * 4, 69, ICE[4])
        if i in (3, 4):
            for k in range(6):
                star(g, CX + rnd.randint(-14, 14), rnd.randint(top, bot), ICE[3], ICE[4])
        frames.append(g)
    return frames, ramp_edge([ICE])

# ---------------------------------------------------------------- E-17: dragon breath, three rows of 8, facing right
def breath(ramp, rnd, kind):
    frames = []
    for i in range(8):
        g = blank()
        head = min(94, 6 + i * 18)                       # the front of the breath races right
        tail = 4 + max(0, i - 5) * 26                    # and the back lets go at the end
        for x in range(int(tail), int(head)):
            u = (x - 4) / 90
            half = 1.5 + 13 * u ** 0.8                    # a cone, widening away from the mouth
            wob = math.sin(x * 0.11 + i * 0.9) * 1.2      # a slight sway, not a wave
            for y in range(N):
                off = y - (CY + wob)
                # a ragged, turbulent edge: the reach differs above and below and churns frame to frame
                edge = half * (0.75 + 0.25 * math.sin(x * 0.9 + i * 2.3 + (1 if off > 0 else 4)) * math.sin(x * 0.37 - i * 1.1))
                d = abs(off)
                if d <= edge:
                    k = 1 - d / max(edge, 0.5)
                    if k < 0.3 and (x + y + i) % 2 == 0:
                        continue                          # the spray thins to a dither at its edge
                    if kind == "leaves" and (x * 5 + y * 3 + i) % 6 == 0:
                        continue
                    g[y][x] = ramp[-1] if k > 0.7 else ramp[-2] if k > 0.4 else ramp[-3]
        for _ in range(int(6 + 2 * i)):                  # what it carries
            x = rnd.uniform(tail, head); y = CY + rnd.uniform(-10, 10) * (x / 96)
            if kind == "frost":
                star(g, x, y, ICE[3], ICE[4])
            elif kind == "leaves":
                blob(g, x, y, LEAF[2] if rnd.random() < 0.5 else LEAF[3])
            else:
                put(g, x, y, ramp[-1])
        frames.append(g)
    return frames

def e17():
    rnd = random.Random(17)
    f1 = breath(ICE, rnd, "frost")
    f2 = breath(LEAF + [(250, 246, 200)], rnd, "leaves")
    f3 = breath(DARK, rnd, "dark")
    return f1 + f2 + f3, ramp_edge([ICE, LEAF + [(250, 246, 200)], DARK])

# ---------------------------------------------------------------- E-18: Auril's diamond: 6-frame spin, then a 10-frame crack
DIA = [(30, 44, 92), (70, 120, 196), (140, 196, 240), (206, 236, 255), (255, 255, 255)]

def diamond(g, cx, cy, h, wface, phase, crack=0, rnd=None):
    """An octahedron seen side-on, its width turning with phase."""
    w = max(2, abs(math.cos(phase)) * wface + 2)
    for y in range(int(cy - h), int(cy + h) + 1):
        span = w * (1 - abs(y - cy) / h)
        for x in range(int(cx - span), int(cx + span) + 1):
            left = (x - cx) < math.sin(phase) * span * 0.4
            top = y < cy
            c = DIA[4] if top and left and abs(x - cx) < 2 else DIA[3] if top and left else DIA[2] if top or left else DIA[1]
            g[y][x] = c

def e18():
    frames = []
    for i in range(6):                                   # the spin loop, humming
        g = blank()
        diamond(g, CX, CY - 4, 16, 11, i * math.pi / 6)
        r = 18 + (i % 3) * 3                              # the hum: a faint ring pulsing
        for a in range(0, 360, 12):
            if (a // 12 + i) % 2 == 0:
                put(g, CX + math.cos(math.radians(a)) * r, CY - 4 + math.sin(math.radians(a)) * r * 0.5, DIA[2])
        frames.append(g)
    rnd = random.Random(18)
    strands = [-2.6, -0.5, math.pi / 2]                   # three strands of frost: left, right, down
    for i in range(10):
        g = blank()
        if i < 4:
            diamond(g, CX, CY - 4, 16, 11, 0.3)
            lines_from(g, CX, CY - 4, 2 + i, 6 + i * 3, DIA[0], random.Random(80 + i))
            if i == 3:
                for y in range(N):
                    for x in range(N):
                        if math.hypot(x - CX, y - CY + 4) < 10:
                            g[y][x] = DIA[4]
        else:
            tt = i - 4
            for k in range(8):                            # the shards fly apart
                a = k / 8 * 2 * math.pi + 0.3
                d = 6 + tt * 6
                bx, by = CX + math.cos(a) * d, CY - 4 + math.sin(a) * d * 0.7 + tt * tt * 0.3
                if tt < 5:
                    for dx in range(-1, 2):
                        put(g, bx + dx, by, DIA[3]); put(g, bx, by - 1, DIA[4])
            for s, a in enumerate(strands):               # the strands reach out
                length = min(46, 8 + tt * 9)
                x, y = CX, CY - 4
                for k in range(int(length)):
                    a2 = a + math.sin(k * 0.25 + s) * 0.25
                    x += math.cos(a2); y += math.sin(a2) * 0.8
                    put(g, x, y, DIA[3]); put(g, x, y + 1, DIA[2])
                    if k % 7 == 3:
                        star(g, x, y - 2, DIA[3], DIA[4])
        frames.append(g)
    return frames, ramp_edge([DIA])

# ---------------------------------------------------------------- E-22: falling ice: icicles and chunks (row of 8), a spear shattering (8)
def e22():
    rnd = random.Random(22)
    frames = []
    pieces = [(rnd.uniform(24, 72), rnd.uniform(-30, 0), rnd.choice((0, 1))) for _ in range(7)]
    for i in range(8):
        g = blank()
        for px0, py0, kind in pieces:
            y = py0 + i * i * 1.6 + i * 3
            if y < CY + 10:
                if kind == 0:                             # an icicle, point down
                    for k in range(9):
                        w = int((9 - k) / 4)
                        for dx in range(-w, w + 1):
                            put(g, px0 + dx, y + k, ICE[4] if dx < 0 else ICE[3])
                else:                                     # a chunk
                    for dy in range(4):
                        for dx in range(-2, 3):
                            put(g, px0 + dx, y + dy, ICE[3] if dx > 0 else ICE[4])
            else:                                         # it shatters where it lands
                tt = (y - CY - 10) / 6
                if tt < 3:
                    for k in range(5):
                        a = math.pi + k * math.pi / 4
                        put(g, px0 + math.cos(a) * tt * 3, CY + 10 + math.sin(a) * tt * 2, ICE[3])
        frames.append(g)
    for i in range(8):                                    # the spear
        g = blank()
        if i < 4:
            y = -20 + i * 18
            for k in range(26):
                w = 2 if k < 20 else int((26 - k) / 2)
                for dx in range(-w, w + 1):
                    put(g, CX + dx, y + k, ICE[4] if dx < 0 else ICE[3] if dx == 0 else ICE[2])
        else:
            tt = i - 3
            for k in range(12):
                a = math.pi + (k / 11) * math.pi
                d = tt * 5
                put(g, CX + math.cos(a) * d, CY + 10 + math.sin(a) * d * 0.6 + tt * tt * 0.4, ICE[4] if k % 2 else ICE[3])
                put(g, CX + math.cos(a) * d + 1, CY + 10 + math.sin(a) * d * 0.6 + tt * tt * 0.4, ICE[3])
            for x in range(CX - 10 - tt * 2, CX + 11 + tt * 2):   # the crack in the bridge
                if (x + tt) % 3 and i < 7:
                    put(g, x, CY + 11, ICE[1])
        frames.append(g)
    return frames, ramp_edge([ICE])

# ---------------------------------------------------------------- fire: E-23 roof (6-loop), E-34 wagon and E-31 Hell's Veil (8, loop the last 4)
def flames(g, x0, x1, base, height, i, ramp, rnd_seed, dark_core=False):
    for x in range(int(x0), int(x1)):
        h = height * (0.55 + 0.45 * math.sin(x * 0.7 + i * 2.1 + rnd_seed) * math.sin(x * 0.23 - i * 1.3))
        h = max(2, h)
        for k in range(int(h)):
            y = base - k
            u = k / h
            c = ramp[-1] if u < 0.25 else ramp[-2] if u < 0.55 else ramp[-3] if u < 0.85 else ramp[1]
            if dark_core and u < 0.3 and (x - x0) % 5 in (1, 2):
                c = ramp[1]
            g[y][x] = c

def smoke(g, cx, base, i, n=5, spread=20):
    rnd = random.Random(99)
    for k in range(n):
        ph = (i + k * 6 / n) % 6
        x = cx + rnd.uniform(-spread, spread) + ph * 1.5
        y = base - 6 - ph * 6
        r = 2 + ph * 0.8
        for yy in range(int(y - r), int(y + r) + 1):
            for xx in range(int(x - r), int(x + r) + 1):
                if math.hypot(xx - x, yy - y) <= r and g[yy][xx] is None if 0 <= yy < N and 0 <= xx < N else False:
                    g[yy][xx] = SMOKE[3] if yy < y - r / 2 else SMOKE[2]

def e23(n=6):
    frames = []
    for i in range(n):
        g = blank()
        smoke(g, CX, CY - 6, i, n=6, spread=26)
        flames(g, CX - 32, CX + 32, CY + 4, 14, i, FIRE, 1.0)
        frames.append(g)
    return frames, ramp_edge([FIRE, SMOKE])

def e34(n=8):
    frames = []
    for i in range(n):
        g = blank()
        grow = min(1.0, (i + 1) / 4)
        smoke(g, CX, CY - 4, i % 6, n=4, spread=12)
        flames(g, CX - 18 * grow, CX + 18 * grow, CY + 8, 16 * grow, i, FIRE, 2.0, dark_core=True)
        frames.append(g)
    return frames, ramp_edge([FIRE, SMOKE])

def e31(n=8):
    frames = []
    for i in range(n):
        g = blank()
        grow = min(1.0, (i + 1) / 4)
        h = 60 * grow
        for x in range(CX - 13, CX + 14):
            front = abs(x - CX) < 7                       # the pillar's front, over the figure: a lattice of flame
            hh = h * (0.8 + 0.2 * math.sin(x * 0.9 + i * 2))
            for k in range(int(hh)):
                y = CY + 12 - k
                u = k / max(hh, 1)
                if front and (x + y + i) % 3 != 0 and u > 0.12:
                    continue                              # (the figure shows through the front)
                g[y][x] = HELL[4] if u < 0.15 else HELL[3] if u < 0.4 else HELL[2] if u < 0.75 else HELL[1]
            # tongues flicking off the top
            tip = CY + 12 - hh
            if (x * 3 + i) % 5 == 0:
                for k in range(int(4 * grow)):
                    put(g, x, tip - k, HELL[2] if k < 2 else HELL[3])
        for k in range(6):
            y = CY + 12 - ((i * 7 + k * 11) % int(max(h, 10)))
            put(g, CX + (k % 2 and -15 or 15), y, HELL[3])
        frames.append(g)
    return frames, ramp_edge([HELL])

# ---------------------------------------------------------------- E-24: rain from the roots on the lake (8-frame loop, wide)
RAIN = [(30, 54, 84), (90, 140, 190), (170, 210, 240), (236, 248, 255)]

def e24(n=8):
    rnd = random.Random(24)
    drops = [(rnd.uniform(0, N), rnd.uniform(0, N)) for _ in range(40)]
    frames = []
    for i in range(n):
        g = blank()
        for x0, y0 in drops:
            y = (y0 + i * 12) % N
            x = (x0 - i * 1.5) % N
            for k in range(4):
                put(g, x - k * 0.4, y - k, RAIN[3] if k == 0 else RAIN[2])
            if y > 84:
                put(g, x - 1, 90, RAIN[2]); put(g, x + 1, 90, RAIN[2])
        frames.append(g)
    return frames, ramp_edge([RAIN])

# ---------------------------------------------------------------- E-35: the black-veined sphere pulsing (6-frame loop)
def e35(n=6):
    rnd = random.Random(35)
    veins = []
    for k in range(6):
        a = rnd.uniform(0, 2 * math.pi); x, y = CX, CY; p = []
        for s in range(14):
            a += rnd.uniform(-0.6, 0.6); x += math.cos(a); y += math.sin(a); p.append((x, y))
        veins.append(p)
    frames = []
    for i in range(n):
        g = blank()
        r = 12 + 2 * math.sin(i / n * 2 * math.pi)
        for y in range(N):
            for x in range(N):
                d = math.hypot(x - CX, y - CY)
                if d <= r:
                    lit = (x - CX) + (y - CY) < -r * 0.7
                    g[y][x] = DARK[3] if lit and d > r - 3 else DARK[2] if d > r - 2 else DARK[1]
        for p in veins:
            for (x, y) in p:
                if math.hypot(x - CX, y - CY) < r - 1:
                    put(g, x, y, DARK[0])
        glow = r + 4 + 2 * math.sin(i / n * 2 * math.pi)
        for a in range(0, 360, 10):                       # a ring of violet light that breathes
            if (a // 10 + i) % 3 == 0:
                put(g, CX + math.cos(math.radians(a)) * glow, CY + math.sin(math.radians(a)) * glow, DARK[4])
        frames.append(g)
    return frames, ramp_edge([DARK])

# ---------------------------------------------------------------- E-21: soft silver light settles over the team (10)
def e21(n=10):
    rnd = random.Random(21)
    motes = [(rnd.uniform(-40, 40), rnd.uniform(-46, 0), rnd.uniform(0.7, 1.3)) for _ in range(26)]
    frames = []
    for i in range(n):
        g = blank()
        for mx, my, sp in motes:
            y = CY + my + i * 4.2 * sp
            if y < CY + 10:
                star(g, CX + mx, y, SILVER[2], SILVER[3])
            elif i > 5 and (int(mx) + i) % 2 == 0:
                put(g, CX + mx, CY + 10, SILVER[2])
        if i >= 6:                                        # a soft sheen on the ground, dithered
            for y in range(CY + 8, CY + 13):
                for x in range(CX - 38, CX + 39):
                    if (x + y + i) % 3 == 0 and abs(x - CX) / 38 + abs(y - CY - 10) / 3 < 1:
                        g[y][x] = g[y][x] or SILVER[2]
        frames.append(g)
    return frames, ramp_edge([SILVER])

# ---------------------------------------------------------------- E-32: green bond sparkle rising off a Pokémon and its trainer (6)
def e32(n=6):
    rnd = random.Random(32)
    motes = [(rnd.uniform(-22, 22), rnd.uniform(0, 30)) for _ in range(14)]
    frames = []
    for i in range(n):
        g = blank()
        for mx, my in motes:
            y = CY + 10 - my - i * 6
            if CY - 40 < y < CY + 12:
                if (int(my) + i) % 3 == 0:
                    star(g, CX + mx + math.sin(y * 0.3) * 2, y, GREEN[2], GREEN[3])
                else:
                    blob(g, CX + mx + math.sin(y * 0.3) * 2, y, GREEN[2] if i < 4 else GREEN[1], 1)
        frames.append(g)
    return frames, ramp_edge([GREEN])

# ================================================================ batch 3 (2026-11-09)
AUR = [(14, 18, 44), (30, 70, 96), (52, 160, 140), (120, 236, 180), (220, 255, 236)]
VIO = [(60, 30, 110), (150, 100, 230), (226, 200, 255)]
GOLD = [(110, 70, 20), (210, 150, 50), (250, 214, 110), (255, 248, 210)]
BEE = [(30, 22, 10), (200, 150, 30), (250, 210, 70)]

def e10(n=12):
    """The rift (6.08): a turning shard of light over an aurora gone smooth as a mirror full of stars. Loops."""
    rnd = random.Random(10)
    stars = [(rnd.uniform(-30, 30), rnd.uniform(-12, 12), rnd.randint(0, 11)) for _ in range(22)]
    frames = []
    for i in range(n):
        g = blank()
        ph = i / n * 2 * math.pi
        # the mirror: a smooth dark oval, rimmed with aurora light that ripples round it
        for y in range(N):
            for x in range(N):
                e = ((x - CX) / 36) ** 2 + ((y - (CY + 6)) / 15) ** 2
                if e <= 1:
                    rim = e > 0.78
                    if rim:
                        a = math.atan2(y - CY - 6, x - CX)
                        g[y][x] = AUR[3] if math.sin(a * 3 - ph * 2) > 0.3 else AUR[2]
                    else:
                        g[y][x] = AUR[0] if e < 0.45 else AUR[1]
        for sx, sy, k in stars:                           # stars in the mirror, twinkling in turn
            x, y = CX + sx, CY + 6 + sy
            if ((x - CX) / 34) ** 2 + ((y - CY - 6) / 13) ** 2 < 0.7:
                if (k + i) % 4 == 0:
                    star(g, x, y, AUR[3], AUR[4])
                else:
                    put(g, x, y, AUR[3] if (k + i) % 4 == 2 else AUR[2])
        # the shard: a tall diamond, turning (its width breathes with the spin), over the mirror's centre
        w = 2 + abs(math.cos(ph)) * 7
        top, bot, mid = CY - 34, CY + 2, CY - 14
        for y in range(top, bot + 1):
            span = w * (1 - abs(y - mid) / (mid - top if y < mid else bot - mid))
            for x in range(int(CX - span), int(CX + span) + 1):
                lit = (x - CX) < math.sin(ph) * span * 0.5
                g[y][x] = AUR[4] if lit and abs(x - CX) <= 1 else VIO[2] if lit else VIO[1]
        frames.append(g)
    return frames, ramp_edge([AUR, VIO])

def e11(n=12):
    """Glimmer's light rises out of him and up through the roots (8.07)."""
    rnd = random.Random(11)
    motes = [(rnd.uniform(0, 2 * math.pi), rnd.uniform(10, 22)) for _ in range(14)]
    frames = []
    for i in range(n):
        g = blank()
        if i < 5:                                         # light gathers out of him into his chest
            t = i / 4
            for a, r in motes:
                rr = r * (1 - t)
                star(g, CX + math.cos(a + t) * rr, CY + math.sin(a + t) * rr * 1.2, GOLD[2], GOLD[3])
            rad = 1 + 4 * t
            for y in range(N):
                for x in range(N):
                    d = math.hypot(x - CX, y - CY)
                    if d <= rad:
                        g[y][x] = GOLD[3] if d < rad * 0.5 else GOLD[2]
        else:                                             # then it rises, trailing light, and goes up out of sight
            t = (i - 5) / (n - 6)
            oy = CY - t * 70
            for y in range(N):
                for x in range(N):
                    d = math.hypot(x - CX, y - oy)
                    if d <= 5 and oy > -6:
                        g[y][x] = GOLD[3] if d < 2.5 else GOLD[2]
                    elif oy + 5 < y < CY and abs(x - CX) <= 2 * (1 - (y - oy) / max(1, CY - oy)) + 0.5:
                        if (x + y + i) % 2 == 0:
                            g[y][x] = GOLD[2]             # the trail, dithered so it reads as light
            for k in range(5):
                put(g, CX + (k - 2) * 4, oy + 10 + k * 5 + (i % 2), GOLD[3])
        frames.append(g)
    return frames, ramp_edge([GOLD])

def e25(n=8):
    """A cloud of furious bees bursting out of a door (9.03)."""
    rnd = random.Random(25)
    bees = [(rnd.uniform(-1, 1), rnd.uniform(-1, 0.2), rnd.uniform(0.5, 1.2), rnd.uniform(0, 6)) for _ in range(34)]
    frames = []
    for i in range(n):
        g = blank()
        t = (i + 1) / n
        for dx, dy, sp, ph in bees:
            x = CX + dx * 40 * t * sp + math.sin(i * 1.7 + ph) * 3
            y = CY + 14 + dy * 40 * t * sp + math.cos(i * 1.3 + ph) * 3
            put(g, x, y, BEE[2]); put(g, x + 1, y, BEE[0])     # a bee: gold and a black stripe
            if (i + int(ph)) % 2 == 0:
                put(g, x, y - 1, (240, 240, 255))              # a wing catching the light
        frames.append(g)
    return frames, ramp_edge([BEE, [(30, 22, 10), (240, 240, 255)]])

EFFECTS = {"E-13": e13, "E-16": e16, "E-33": e33, "E-05": e05, "E-17": e17, "E-18": e18, "E-21": e21,
           "E-22": e22, "E-23": e23, "E-24": e24, "E-31": e31, "E-32": e32, "E-34": e34, "E-35": e35,
           "E-10": e10, "E-11": e11, "E-25": e25}

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
