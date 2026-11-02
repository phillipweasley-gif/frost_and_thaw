"""Instrument anatomy, done properly (the user's corrections):

LUTE  - the BACK of the bowl is the ribbed part: narrow staves of two woods, running lengthwise from the neck
        joint to the bottom block; from the front you only see them round the edges.
      - the FRONT is a flat soundboard of pale spruce, edged with dark binding. On it: the carved rose in the
        upper part (towards the neck), and the bridge glued low down towards the bottom.
      - the strings run from the bridge, over the rose, to the neck at the bowl's NARROW end, along a fretted
        fingerboard (tied gut frets) to the nut, and into a pegbox bent sharply back, set with a row of pegs
        down both sides.
CELLO - everything lies on one line, the instrument's axis: the endpin spike at the bottom, the tailpiece
        above it, the bridge standing at the WAIST between the two f-holes (each f-hole notched level with
        the bridge), then the fingerboard running up over the top and the neck to a straight pegbox with
        pegs either side and the scroll at the very top. The strings run unbroken from tailpiece to pegbox.
        (Hauntello's smashed soundhole stays as damage, off that line.)"""
import math
from alb_ops import *

SPRUCE = [(206, 160, 100), (230, 194, 134), (246, 220, 166), (255, 238, 198)]
RIB_A = [(110, 56, 24), (172, 100, 44), (224, 152, 76), (246, 198, 124)]
RIB_B = [(86, 40, 16), (140, 76, 32), (192, 118, 54), (226, 166, 96)]
BINDING = (96, 52, 26)
FRET = (236, 196, 140)
STRING = (240, 226, 186)          # gut / wound strings: pale, thin
FB = [(54, 30, 16), (84, 48, 24)]           # lute fingerboard
PEGBOX = [(70, 36, 18), (112, 62, 30)]


class Axis:
    def __init__(self, a, b):
        self.a = a
        self.L = max(1e-6, math.hypot(b[0] - a[0], b[1] - a[1]))
        self.u = ((b[0] - a[0]) / self.L, (b[1] - a[1]) / self.L)
        self.n = (-self.u[1], self.u[0])

    def tn(self, x, y):
        dx, dy = x + 0.5 - self.a[0], y + 0.5 - self.a[1]
        return (dx * self.u[0] + dy * self.u[1]) / self.L, dx * self.n[0] + dy * self.n[1]

    def at(self, t, d=0.0):
        return (self.a[0] + self.u[0] * self.L * t + self.n[0] * d, self.a[1] + self.u[1] * self.L * t + self.n[1] * d)


def half_widths(ax, pts):
    """The mass's half-width across the axis, along its length: the run of the mass that the axis passes
    through (so limbs sticking out sideways don't count)."""
    pts = set(pts)
    cache = {}
    def W(t):
        k = round(t * ax.L * 2) / 2
        if k not in cache:
            sides = []
            for s in (-1, 1):
                d = 0.0
                while d < 60:
                    x, y = ax.at(k / ax.L, s * (d + 0.5))
                    if (int(math.floor(x)), int(math.floor(y))) not in pts:
                        break
                    d += 0.5
                sides.append(d)
            cache[k] = sum(sides) / 2
        return cache[k]
    return W


def bar(P, centre, direction, half, col, cond=None):
    cx, cy = centre
    dx, dy = direction
    P.line([(cx - dx * half, cy - dy * half), (cx + dx * half, cy + dy * half)], col, cond=cond)


def ring(P, cx, cy, r):
    inner = set(P.ellipse(cx, cy, r, r))
    return inner, edge(list(inner))


# =========================================================================================== LUTE
def lute(P, mass, joint, block, neck_end, side=+1, n_strings=2, rose_t=0.36, bridge_t=0.8, front=0.68,
         rib_lines=None, pegs=5, rose_r=None, bridge_half=None, board=None, rose=None, bridge=None, back_view=False):
    """`mass` becomes the lute: `joint` is where the neck leaves the bowl (its narrow end), `block` the
    bottom of the bowl; the neck runs from `joint` to `neck_end`; the pegbox bends back to `side`."""
    mass = set(mass)
    ax = Axis(joint, block)
    W = half_widths(ax, mass)
    for (x, y) in mass:                                     # the outline darkens to wood
        if lum(P.get(x, y)[:3]) < 50:
            P.put(x, y, (70, 34, 14))
    body = [p for p in mass if P.get(*p)[:3] != (70, 34, 14)]
    # 1. ribs over the whole bowl, lengthwise stripes of the two woods
    cols = sorted({P.get(*p)[:3] for p in body}, key=lum)
    lo, hi = (lum(cols[0]), lum(cols[-1])) if cols else (0, 1)
    tone = lambda c: min(3, int((lum(c) - lo) / max(1, hi - lo) * 3.99))
    board_shape, board_set = board, set()
    for (x, y) in body:
        t, d = ax.tn(x, y)
        w = max(1.0, W(t))
        k = tone(P.get(x, y)[:3])
        band = int(abs(d) / w * 5) % 2
        P.put(x, y, (RIB_B if band else RIB_A)[k])
        if not back_view and board_shape is None and abs(d) <= front * w and 0.04 <= t <= 0.98:
            board_set.add((x, y))
    if board_shape is not None and not back_view:
        board_set |= {p for p in P.ellipse(*board_shape) if p in mass and p in set(body)}
    board = board_set
    big = max((W(t / 10) for t in range(11)), default=0) >= 6
    if rib_lines if rib_lines is not None else big:
        for (x, y) in body:
            if (x, y) in board:
                continue
            t, d = ax.tn(x, y)
            t2, d2 = ax.tn(x + 1, y)
            w = max(1.0, W(t))
            if int(abs(d) / w * 5) != int(abs(d2) / w * 5) and (x + 1, y) in mass:
                P.put(x, y, (140, 76, 32))
    # 2. the soundboard: flat pale spruce in front, dark binding round its edge
    for (x, y) in board:
        t, d = ax.tn(x, y)
        P.put(x, y, SPRUCE[min(3, tone(P.get(x, y)[:3]) + (1 if abs(d) < 0.35 * max(1, W(t)) else 0))])
    for (x, y) in edge(list(board)):
        if any((x + dx, y + dy) in mass and (x + dx, y + dy) not in board for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
            P.put(x, y, BINDING)
    # 3. the rose, in the upper part of the soundboard
    if back_view:
        return lute_neck_only(P, joint, neck_end, side, pegs)
    rc = rose[:2] if rose else ax.at(rose_t)
    r = rose[2] if rose else (rose_r or max(1.8, min(3.6, 0.38 * W(rose_t))))
    hole, rim = ring(P, rc[0], rc[1], r)
    for (x, y) in hole:
        P.put(x, y, HOLE)
    for (x, y) in rim:
        P.put(x, y, GOLD[2] if y < rc[1] else GOLD[1])
    for (x, y) in hole:
        if (x, y) not in rim and y + 0.5 > rc[1] + r * 0.2:
            P.put(x, y, SPIRIT[1] if (x + y) % 2 else SPIRIT[2])
    # 4. the bridge, low on the soundboard, across the strings
    bc = bridge[:2] if bridge else ax.at(bridge_t)
    hb = bridge[2] if bridge else (bridge_half or max(1.5, min(5.0, 0.5 * W(bridge_t))))
    bar(P, bc, ax.n, hb, BINDING)
    bar(P, (bc[0] - ax.u[0], bc[1] - ax.u[1]), ax.n, hb - 0.5, FRET)
    ex, ey, nx_ = lute_neck_only(P, joint, neck_end, side, pegs)
    # 7. the strings, unbroken: bridge -> over the rose -> joint -> up the neck -> nut
    offs = [-0.6, 0.6] if n_strings == 2 else [-1.0, 0.0, 1.0]
    for o in offs:
        s0 = (bc[0] + ax.n[0] * o, bc[1] + ax.n[1] * o)
        s1 = (joint[0] + ax.n[0] * o, joint[1] + ax.n[1] * o)
        s2 = (ex + nx_.n[0] * o, ey + nx_.n[1] * o)
        P.line([s0, s1], (186, 136, 44))
    # along the neck the courses lie together over the fingerboard: one bright line beside the frets
    P.line([(joint[0] + nx_.n[0] * 0.6, joint[1] + nx_.n[1] * 0.6), (ex + nx_.n[0] * 0.6, ey + nx_.n[1] * 0.6)], STRING)




def lute_neck_only(P, joint, neck_end, side, pegs):
    # 5. the neck from the bowl's narrow end: fingerboard, tied frets, nut
    nx_ = Axis(joint, neck_end)
    for k in range(int(nx_.L) + 1):
        x, y = nx_.at(k / nx_.L)
        for o, c in ((-1.6, INK), (-0.6, FB[0]), (0.6, FB[1]), (1.6, INK)):
            P.put(round(x + nx_.n[0] * o), round(y + nx_.n[1] * o), c)
        if k % 2 == 1 and k < nx_.L - 1:
            P.put(round(x - nx_.n[0] * 0.6), round(y - nx_.n[1] * 0.6), FRET)        # a tied fret
    ex, ey = neck_end
    for o in (-0.6, 0.6):
        P.put(round(ex + nx_.n[0] * o), round(ey + nx_.n[1] * o), FRET)       # the nut
    # 6. the pegbox, bent sharply back, pegs down both sides
    ang = math.atan2(nx_.u[1], nx_.u[0]) + side * math.radians(105)
    pv = (math.cos(ang), math.sin(ang))
    pn = (-pv[1], pv[0])
    for k in range(1, pegs + 2):
        x, y = ex + nx_.u[0] + pv[0] * k, ey + nx_.u[1] + pv[1] * k
        P.put(round(x), round(y), PEGBOX[k % 2])
        P.put(round(x + pn[0]), round(y + pn[1]), PEGBOX[(k + 1) % 2])
        if k <= pegs:
            s_ = 1 if k % 2 else -1
            off = 2.2 if s_ > 0 else -1.2
            P.put(round(x + pn[0] * off), round(y + pn[1] * off), GOLD[2] if k % 2 else GOLD[3])
    x, y = ex + nx_.u[0] + pv[0] * (pegs + 2), ey + nx_.u[1] + pv[1] * (pegs + 2)
    P.put(round(x), round(y), INK)
    return ex, ey, nx_


# ========================================================================================== CELLO
def cello(P, chamber, bottom, top, scroll_at, waist_t=0.5, n_strings=2, purfle=2, keep_off=(), endpin=True,
          scroll=True, flen=None):
    """`chamber` becomes the cello's body: its axis runs from `bottom` (where the endpin leaves it) to `top`
    (where the neck leaves it); the neck carries on to the pegbox and scroll at `scroll_at`."""
    chamber = set(chamber)
    cello_body(P, chamber, purfle=purfle)
    ax = Axis(bottom, top)
    W = half_widths(ax, chamber)
    off = set(keep_off)
    ok = lambda x, y: (x, y) not in off
    # bridge at the waist, standing on two feet
    bc = ax.at(waist_t)
    # f-holes either side of the bridge, notched level with it
    wf = max(3.0, W(waist_t) * 0.55)
    flen = flen or max(3, min(8, int(ax.L * 0.28)))
    for s in (-1, 1):
        for k in range(-flen // 2, flen // 2 + 1):
            x, y = ax.at(waist_t + k / ax.L, s * wf)
            hx, hy = ax.at(waist_t + k / ax.L, s * wf + 1)
            if ok(round(x), round(y)):
                P.put(round(x), round(y), (24, 4, 4))
            if ok(round(hx), round(hy)) and P.get(round(hx), round(hy))[:3] in CELLO:
                P.put(round(hx), round(hy), CELLO[4])           # the lit edge of the cut
        for k in (-flen // 2 - 1, flen // 2 + 1):           # the round eyes at each end, turned outward/inward
            x, y = ax.at(waist_t + k / ax.L, s * wf + (s if k < 0 else -s))
            if ok(round(x), round(y)):
                P.put(round(x), round(y), CRACK)
        x, y = ax.at(waist_t, s * (wf - 1))                 # the notch
        if ok(round(x), round(y)):
            P.put(round(x), round(y), CRACK)
    # tailpiece from below the bridge down towards the endpin, tapering
    for k in range(2, int(ax.L * waist_t) - 1):
        t = waist_t - k / ax.L
        half = 1.2 if k < (ax.L * waist_t) * 0.6 else 0.4
        x, y = ax.at(t)
        for o in ([-1, 0, 1] if half > 1 else [0]):
            if ok(round(x + ax.n[0] * o), round(y + ax.n[1] * o)):
                P.put(round(x + ax.n[0] * o), round(y + ax.n[1] * o), (34, 22, 22) if o else (70, 52, 50))
    # the endpin, out through the bottom
    if endpin:
        for k in range(1, 6):
            x, y = bottom[0] - ax.u[0] * k, bottom[1] - ax.u[1] * k
            P.put(round(x), round(y), (214, 214, 224) if k == 4 else (150, 150, 162) if k < 5 else INK)
    # fingerboard from above the bridge, up over the top and along the neck
    sx, sy = scroll_at
    nk = Axis(ax.at(waist_t + 2.5 / ax.L), (sx, sy))
    nlen = nk.L - 4
    for k in range(int(nlen) + 1):
        x, y = nk.at(k / nk.L)
        for o, c in ((-1.4, INK), (-0.5, EBONY), (0.5, EBONY), (1.4, INK)):
            if ok(round(x + nk.n[0] * o), round(y + nk.n[1] * o)):
                P.put(round(x + nk.n[0] * o), round(y + nk.n[1] * o), c)
    # straight pegbox with pegs either side, scroll at the very end
    for k in range(int(nlen) + 1, int(nk.L) + 1):
        x, y = nk.at(k / nk.L)
        P.put(round(x), round(y), CELLO[1])
        P.put(round(x + nk.n[0]), round(y + nk.n[1]), CELLO[0])
        P.put(round(x - nk.n[0] * 1.2), round(y - nk.n[1] * 1.2), INK)
        P.put(round(x + nk.n[0] * 2.2), round(y + nk.n[1] * 2.2), INK)
    for k, s in ((nlen + 1, -1), (nlen + 2, 1), (nlen + 3, -1), (nlen + 3, 1)):
        x, y = nk.at(k / nk.L)
        P.put(round(x + nk.n[0] * (2.6 * s + 0.5)), round(y + nk.n[1] * (2.6 * s + 0.5)), GOLD[2])
    ex, ey = nk.at(1.0)
    ex, ey = ex + nk.u[0] * 1.5, ey + nk.u[1] * 1.5
    for (dx, dy, c) in () if not scroll else ((0, 0, CELLO[3]), (1, 0, CELLO[2]), (-1, 0, INK), (2, 0, INK), (0, -1, INK), (1, -1, INK),
                        (0, 1, CELLO[2]), (1, 1, INK), (-1, 1, INK), (0, 2, INK)):
        P.put(round(ex) + dx, round(ey) + dy, c)
    if scroll:
        P.put(round(ex), round(ey), INK); P.put(round(ex) + 1, round(ey), CELLO[3])
    # the strings, unbroken from the tailpiece over the bridge to the pegbox
    for o in ([0.5] if n_strings < 2 else [-0.5, 0.5]):
        p0 = ax.at(waist_t - min(0.25, 3 / ax.L), o)
        p1 = (bc[0] + ax.n[0] * o, bc[1] + ax.n[1] * o)
        P.line([p0, p1], STRING, cond=ok)
    p1 = (bc[0] + ax.n[0] * 0.5, bc[1] + ax.n[1] * 0.5)
    P.line([p1, nk.at(nlen / nk.L, 0.5)], STRING, cond=ok)
    # the bridge, standing over the strings at the waist on its two feet
    bar(P, bc, ax.n, 3.0, (250, 232, 196), cond=ok)
    bar(P, (bc[0] - ax.u[0], bc[1] - ax.u[1]), ax.n, 2.4, (196, 150, 96), cond=ok)
    for o in (-2.0, 2.0):
        x, y = bc[0] + ax.n[0] * o - ax.u[0] * 2, bc[1] + ax.n[1] * o - ax.u[1] * 2
        if ok(round(x), round(y)):
            P.put(round(x), round(y), (120, 80, 50))
