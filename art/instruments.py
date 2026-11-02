"""Whole, recognizable instruments drawn as clean pixel art, for the Alberica hybrids (the user's example
sheets: the partner keeps its own sprite; the instrument takes the place of a body part, whole).

Each instrument is drawn in its own frame - an origin, an axis pointing from its foot towards its head
(the neck end), and a scale - so it can lie at any angle, at any size. Shapes come from the real things:

  LUTE   pear-shaped bowl, widest about two-thirds of the way down; seen a little from the side, so the
         flat spruce soundboard (with its rose high up and the bridge low down) fills most of the front and
         the ribbed back shows as a strip on the far side; a short fretted neck; the pegbox bent sharply
         back with pegs down both sides.
  CELLO  hourglass body - upper bout, C-bout waist with corners, wider lower bout; varnished top with
         purfling just inside the edge; f-holes either side of the waist, the bridge between them; ebony
         tailpiece below, endpin at the foot; long ebony fingerboard up the neck; pegbox with pegs either
         side; the scroll at the very top.
  HARP   seen from the side: a sloping soundbox (widening towards its foot, a rose on it), the curved
         neck across the top with tuning pins, the pillar standing at the front; strings from the soundbox
         up to the neck, longest by the pillar."""
import math
import numpy as np
from PIL import Image

INK = (24, 14, 12)
HONEY = [(110, 56, 24), (172, 100, 44), (214, 146, 74), (242, 190, 118)]
RIBS = [(84, 40, 16), (130, 70, 30), (170, 102, 48), (204, 140, 72)]
SPRUCE = [(196, 146, 84), (226, 182, 118), (244, 210, 152), (254, 234, 190)]
VARNISH = [(70, 18, 14), (118, 36, 24), (162, 58, 36), (204, 96, 60), (232, 144, 104)]
EBONY = [(20, 14, 14), (44, 32, 30), (70, 54, 50)]
LACQ = [(58, 22, 18), (98, 52, 30), (140, 84, 46), (184, 124, 72)]
GOLD = [(122, 78, 22), (196, 144, 40), (240, 198, 78), (255, 238, 160)]
STRING = (244, 226, 176)
GLOW = [(52, 22, 84), (110, 60, 180), (176, 128, 244), (226, 200, 255)]
HOLE = (30, 12, 40)
PORC = [(24, 44, 120), (44, 86, 192), (200, 196, 204), (238, 236, 240), (252, 252, 252)]
LIGHT = (-0.55, -0.83)                      # light from the upper left, as on the sprites


class Frame:
    def __init__(self, origin, angle_deg, scale=1.0, flip=False):
        """origin: the instrument's foot (sprite px); angle: direction from foot to head, degrees, 0 = up,
        clockwise positive; scale: sprite px per unit (units are roughly the instrument's own size / 100);
        flip mirrors the across-axis (which side the bowl's ribs / harp pillar show on)."""
        a = math.radians(angle_deg)
        self.o = origin
        self.up = (math.sin(a), -math.cos(a))
        self.n = (math.cos(a), math.sin(a)) if not flip else (-math.cos(a), -math.sin(a))
        self.s = scale

    def local(self, x, y):
        dx, dy = x + 0.5 - self.o[0], y + 0.5 - self.o[1]
        return (dx * self.up[0] + dy * self.up[1]) / self.s, (dx * self.n[0] + dy * self.n[1]) / self.s

    def pt(self, u, v):
        return (self.o[0] + (self.up[0] * u + self.n[0] * v) * self.s, self.o[1] + (self.up[1] * u + self.n[1] * v) * self.s)

    def bbox(self, umin, umax, vmin, vmax, W, H):
        pts = [self.pt(u, v) for u in (umin, umax) for v in (vmin, vmax)]
        xs, ys = [p[0] for p in pts], [p[1] for p in pts]
        return max(0, int(min(xs)) - 2), max(0, int(min(ys)) - 2), min(W, int(max(xs)) + 3), min(H, int(max(ys)) + 3)


class Canvas:
    """An RGBA layer the size of the sprite, with a part map so outlines can be drawn between parts."""
    def __init__(self, W=96, H=96):
        self.W, self.H = W, H
        self.rgb = np.zeros((H, W, 3), np.uint8)
        self.a = np.zeros((H, W), bool)
        self.part = np.full((H, W), -1, int)

    def put(self, x, y, c, part=0):
        if 0 <= x < self.W and 0 <= y < self.H:
            self.rgb[y, x] = c[:3]
            self.a[y, x] = True
            self.part[y, x] = part

    def get(self, x, y):
        return tuple(self.rgb[y, x]) if self.a[y, x] else None

    def line(self, p0, p1, c, part=9, only=None):
        n = int(max(abs(p1[0] - p0[0]), abs(p1[1] - p0[1])) * 2) + 1
        last = None
        for i in range(n + 1):
            t = i / n
            q = (int(math.floor(p0[0] + (p1[0] - p0[0]) * t)), int(math.floor(p0[1] + (p1[1] - p0[1]) * t)))
            if q == last or not (0 <= q[0] < self.W and 0 <= q[1] < self.H):
                continue
            if only is not None and self.part[q[1], q[0]] not in only:
                continue
            self.put(q[0], q[1], c, part)
            last = q

    def outline(self, parts, col=INK, lit=None):
        """A 1px outline round the union of `parts`, drawn on their own edge pixels."""
        m = np.isin(self.part, list(parts)) & self.a
        from scipy import ndimage as ndi
        e = m & ~ndi.binary_erosion(m, border_value=0)
        ys, xs = np.nonzero(e)
        for y, x in zip(ys, xs):
            up = y == 0 or not m[y - 1, x]
            left = x == 0 or not m[y, x - 1]
            self.rgb[y, x] = (lit if (lit and (up or left)) else col)[:3]

    def edges_between(self, a_parts, b_parts, col):
        """A line where part set a meets part set b (drawn on a's side)."""
        A = np.isin(self.part, list(a_parts)) & self.a
        B = np.isin(self.part, list(b_parts)) & self.a
        from scipy import ndimage as ndi
        e = A & ndi.binary_dilation(B)
        self.rgb[e] = col[:3]

    def image(self):
        out = np.zeros((self.H, self.W, 4), np.uint8)
        out[..., :3] = self.rgb
        out[..., 3] = self.a * 255
        return Image.fromarray(out, "RGBA")


def shade(ramp, nx, ny, extra=0.0):
    """Pick a tone by how much a surface with normal (nx, ny) faces the light."""
    d = -(nx * LIGHT[0] + ny * LIGHT[1]) * -1
    k = (d + 1) / 2 + extra
    return ramp[max(0, min(len(ramp) - 1, int(k * len(ramp))))]


def fill(cv, fr, inside, umin, umax, vmin, vmax, colour, part):
    """Rasterise a shape given in the frame: inside(u, v) -> bool; colour(u, v) -> rgb."""
    x0, y0, x1, y1 = fr.bbox(umin, umax, vmin, vmax, cv.W, cv.H)
    for y in range(y0, y1):
        for x in range(x0, x1):
            u, v = fr.local(x, y)
            if inside(u, v):
                cv.put(x, y, colour(u, v, x, y), part)


def screen_normal(fr, nu, nv):
    """A normal given in the frame (along up, along across) turned into screen space."""
    return (fr.up[0] * nu + fr.n[0] * nv, fr.up[1] * nu + fr.n[1] * nv)


# ===================================================================================== LUTE
def lute(cv, fr, bowl_len=100, bowl_w=62, neck_len=48, rose=True, porcelain_rim=False, glow=True,
         strings=3, pegbox_side=+1, show_neck=True, rib_ramp=None, rose_scale=1.0, rim_col=None, rose_gem=None,
         side=0.18, tip=None):
    """Units: the bowl is bowl_len long (foot at u=0, neck joint at u=bowl_len), bowl_w wide."""
    L, Wd = bowl_len, bowl_w
    def hw(u):                                     # half-width of the bowl along its length (pear)
        t = u / L
        if t < 0 or t > 1:
            return 0
        widest = 0.36
        if t <= widest:
            return Wd / 2 * math.sqrt(max(0, 1 - ((widest - t) / widest) ** 2))
        k = (t - widest) / (1 - widest)
        return Wd / 2 * (1 - k ** 1.6 * 0.82)
    def board_hw(u):
        return hw(u) * (1 - side)
    def in_bowl(u, v):
        return 0 <= u <= L and abs(v) <= hw(u)
    def in_board(u, v):
        c = -hw(u) * side                           # the soundboard is shifted towards the near side
        return 0.02 * L <= u <= 0.985 * L and abs(v - c) <= board_hw(u) - 0.6 / fr.s
    def bowl_col(u, v, x, y):
        w = max(1e-3, hw(u))
        nv = v / w
        nx, ny = screen_normal(fr, 0.15, nv)
        if in_board(u, v):
            k = 2 if nv < 0.25 else 1
            if (u / L) > 0.9 or (u / L) < 0.08:
                k -= 1
            return (PORC if porcelain_rim and False else SPRUCE)[max(0, min(3, k + (1 if nv < -0.4 else 0)))]
        rib = int((nv + 1) * 7) % 2
        ramp = RIBS if rib else HONEY
        if porcelain_rim:
            ramp = PORC[1:]
        if rib_ramp:
            ramp = rib_ramp
        return shade(ramp, nx, ny)
    fill(cv, fr, in_bowl, 0, L, -Wd / 2, Wd / 2, bowl_col, 1)
    # binding round the soundboard
    x0, y0, x1, y1 = fr.bbox(0, L, -Wd / 2, Wd / 2, cv.W, cv.H)
    for y in range(y0, y1):
        for x in range(x0, x1):
            if cv.part[y, x] != 1:
                continue
            u, v = fr.local(x, y)
            if in_board(u, v):
                nb = [fr.local(x + dx, y + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))]
                if any(in_bowl(*q) and not in_board(*q) for q in nb):
                    cv.put(x, y, (110, 62, 28) if not porcelain_rim else PORC[0], 2)
    # the rose
    if rose:
        ru, rr = 0.55 * L, (0.2 if Wd * fr.s > 22 else 0.25) * Wd * rose_scale
        rc = -hw(0.55 * L) * side
        def in_rose(u, v):
            return math.hypot(u - ru, v - rc) <= rr
        def rose_col(u, v, x, y):
            d = math.hypot(u - ru, v - rc) / rr
            if d > 0.78:
                return GOLD[2] if v - rc < 0 else GOLD[1]
            ang = math.atan2(u - ru, v - rc)
            lattice = (abs(math.sin(ang * 4)) > 0.86 or 0.38 < d < 0.52)
            if lattice and rr * fr.s >= 3.5:
                return GOLD[1]
            if rose_gem:
                return rose_gem[0] if d < 0.45 and v - rc < 0 else rose_gem[1] if d < 0.6 else HOLE
            if glow:
                return GLOW[2] if d < 0.3 else GLOW[1] if u < ru else HOLE
            return HOLE
        fill(cv, fr, in_rose, ru - rr, ru + rr, rc - rr, rc + rr, rose_col, 3)
    # the bridge, low on the soundboard
    bu = 0.14 * L
    bc = -hw(bu) * side
    for v in np.linspace(-0.22 * Wd, 0.22 * Wd, 24):
        x, y = fr.pt(bu, bc + v)
        cv.put(int(x), int(y), (88, 46, 20), 4)
        x, y = fr.pt(bu + 0.6 / fr.s, bc + v)
        cv.put(int(x), int(y), (150, 96, 50), 4)
    # neck, fretted, and the pegbox bent back
    nw = 0.13 * Wd
    if show_neck:
        def in_neck(u, v):
            return L * 0.96 <= u <= L + neck_len and abs(v) <= nw
        fret_step = max(2.6, 3.0 / fr.s)
        def neck_col(u, v, x, y):
            if u > L + 1.5 / fr.s and ((u - L) % fret_step) < 0.9 / fr.s:
                return (226, 196, 140)                           # a tied gut fret, right across
            return (70, 40, 20) if v < 0 else (98, 58, 28)
        fill(cv, fr, in_neck, L * 0.96, L + neck_len, -nw, nw, neck_col, 5)
        # pegbox: from the nut, bent back ~ 100 degrees to one side
        if tip:
            tip(cv, fr.pt(L + neck_len, 0), fr)
        a = math.radians(100) * pegbox_side
        ux, uy = math.cos(a), math.sin(a)          # in the (u, v) plane: (u along up, v across)
        pl, pw = 0.34 * neck_len + 4, nw * 0.8
        base = (L + neck_len, 0)
        def in_peg(u, v):
            du, dv = u - base[0], v - base[1]
            along = du * ux + dv * uy
            across = -du * uy + dv * ux
            return 0 <= along <= pl and abs(across) <= pw
        def peg_col(u, v, x, y):
            du, dv = u - base[0], v - base[1]
            across = -du * uy + dv * ux
            return (70, 36, 18) if across > 0 else (120, 66, 30)
        if not tip:
            fill(cv, fr, in_peg, L + neck_len - pl - 2, L + neck_len + pl + 2, -pl - 2, pl + 2, peg_col, 6)
        n_pegs = 0 if tip else max(2, int(pl * fr.s / 2.0))
        for i in range(n_pegs):
            t = (i + 0.6) / n_pegs * pl
            s_ = 1 if i % 2 else -1
            for k, col in ((1.2, (60, 30, 14)), (2.4, GOLD[2])):
                pu = base[0] + ux * t - uy * s_ * (pw + k / fr.s)
                pv = base[1] + uy * t + ux * s_ * (pw + k / fr.s)
                x, y = fr.pt(pu, pv)
                cv.put(int(x), int(y), col, 7)
    # strings: bridge -> over the rose -> joint -> up the neck -> nut
    for k in range(strings):
        off = (k - (strings - 1) / 2) * min(nw * 0.9, 2.2 / fr.s)
        p0 = fr.pt(bu, bc + off)
        p1 = fr.pt(L, off * 0.8)
        p2 = fr.pt(L + neck_len, off * 0.6)
        cv.line(p0, p1, (176, 128, 52), part=8, only={1, 2, 3, 4})
    cv.outline({1, 2, 3, 4, 5, 6, 7, 8}, rim_col or INK, lit=(96, 52, 26) if not rim_col else None)


# ===================================================================================== CELLO
def cello(cv, fr, body_len=100, body_w=60, neck_len=58, glow_cracks=True, porcelain_rim=False, endpin=True,
          strings=2, scroll=True, cracks=(), neck=True):
    """Units: the body runs from u=0 (foot) to u=body_len; the neck carries on to the scroll."""
    L, Wd = body_len, body_w
    def hw(u):                                     # lower bout, C-bout waist, upper bout
        t = u / L
        if t < 0 or t > 1:
            return 0
        lower = 0.5 * Wd * math.sqrt(max(0, 1 - ((t - 0.27) / 0.27) ** 2)) if t <= 0.54 else 0
        upper = 0.41 * Wd * math.sqrt(max(0, 1 - ((t - 0.77) / 0.23) ** 2)) if t >= 0.54 else 0
        waist = 0.3 * Wd if 0.42 <= t <= 0.64 else 0
        return max(lower, upper, waist)
    def in_body(u, v):
        return abs(v) <= hw(u)
    def body_col(u, v, x, y):
        w = max(1e-3, hw(u))
        nv = v / w
        nx, ny = screen_normal(fr, 0.0, nv)
        c = shade(VARNISH[1:], nx, ny)
        # a soft highlight streak down the lit side of the top
        if -0.65 < nv < -0.35 and (0.1 < u / L < 0.42 or 0.66 < u / L < 0.9):
            c = VARNISH[4]
        return c
    fill(cv, fr, in_body, 0, L, -Wd / 2, Wd / 2, body_col, 1)
    # purfling just inside the edge
    x0, y0, x1, y1 = fr.bbox(0, L, -Wd / 2, Wd / 2, cv.W, cv.H)
    inset = 1.6 / fr.s
    for y in range(y0, y1):
        for x in range(x0, x1):
            if cv.part[y, x] != 1:
                continue
            u, v = fr.local(x, y)
            w = hw(u)
            if w - inset - 0.9 / fr.s <= abs(v) <= w - inset and 0.03 * L < u < 0.97 * L:
                cv.put(x, y, PORC[1] if porcelain_rim else VARNISH[0], 2)
    if porcelain_rim:                                # a ceramic rim round the body (the Cinderwright paddle)
        for y in range(y0, y1):
            for x in range(x0, x1):
                if cv.part[y, x] not in (1, 2):
                    continue
                u, v = fr.local(x, y)
                if abs(v) > hw(u) - 1.4 / fr.s:
                    cv.put(x, y, PORC[3] if v < 0 else PORC[2], 2)
    # f-holes at the waist, either side; bridge between them
    fu = 0.5 * L
    flen = 0.22 * L
    for s in (-1, 1):
        fv = s * 0.17 * Wd
        n = max(4, int(flen * fr.s * 1.5))
        for i in range(n + 1):
            t = i / n
            u = fu - flen / 2 + flen * t
            v = fv + s * 0.04 * Wd * math.sin((t - 0.5) * math.pi * 2) * -1
            x, y = fr.pt(u, v)
            cv.put(int(x), int(y), (24, 6, 6), 3)
        for t, dv in ((0.0, -s), (1.0, s)):                 # the round eyes at each end
            x, y = fr.pt(fu - flen / 2 + flen * t, fv + dv * 0.035 * Wd)
            cv.put(int(x), int(y), (24, 6, 6), 3)
        x, y = fr.pt(fu, fv - s * 0.04 * Wd)                # the notch
        cv.put(int(x), int(y), (24, 6, 6), 3)
    # cracks with the haunting glowing through them
    for crack in cracks:
        pts = [fr.pt(u * L, v * Wd) for (u, v) in crack]
        for p, q in zip(pts, pts[1:]):
            cv.line(p, q, (30, 8, 20), part=3, only={1, 2})
        for p in pts[1:-1]:
            cv.put(int(p[0]) + 1, int(p[1]), GLOW[2], 3)
    # tailpiece and endpin
    tu0, tu1 = 0.08 * L, 0.36 * L
    def in_tail(u, v):
        return tu0 <= u <= tu1 and abs(v) <= 0.035 * Wd + (u - tu0) / (tu1 - tu0) * 0.045 * Wd
    fill(cv, fr, in_tail, tu0, tu1, -0.1 * Wd, 0.1 * Wd, lambda u, v, x, y: EBONY[1] if v < 0 else EBONY[0], 4)
    if endpin:
        for k in range(1, int(0.12 * L * fr.s) + 2):
            x, y = fr.pt(-k / fr.s, 0)
            cv.put(int(x), int(y), (176, 176, 186) if k > 1 else INK, 9)
    # fingerboard from above the bridge up the neck; the neck, pegbox and scroll
    if not neck:
        neck_len, scroll = 0, False
    fb0, fb1 = 0.56 * L, L + neck_len * 0.78
    def in_fb(u, v):
        half = 0.055 * Wd + (u - fb0) / (fb1 - fb0) * -0.012 * Wd
        return fb0 <= u <= fb1 and abs(v) <= max(1.0 / fr.s, half)
    fill(cv, fr, in_fb, fb0, fb1, -0.1 * Wd, 0.1 * Wd, lambda u, v, x, y: EBONY[1] if v < 0 else EBONY[0], 5)
    pb0, pb1 = fb1, L + neck_len
    def in_pb(u, v):
        return pb0 <= u <= pb1 and abs(v) <= max(1.1 / fr.s, 0.06 * Wd)
    fill(cv, fr, in_pb, pb0, pb1, -0.1 * Wd, 0.1 * Wd, lambda u, v, x, y: VARNISH[2] if v < 0 else VARNISH[1], 6)
    n_pegs = 2
    for i in range(n_pegs):
        u = pb0 + (i + 0.5) / n_pegs * (pb1 - pb0)
        for s in (-1, 1):
            x, y = fr.pt(u + s * 0.01 * L, s * (0.05 * Wd + 2.0 / fr.s))
            cv.put(int(x), int(y), (60, 30, 20), 7)
            x2, y2 = fr.pt(u + s * 0.01 * L, s * (0.05 * Wd + 3.0 / fr.s))
            cv.put(int(x2), int(y2), GOLD[2], 7)
    if scroll:
        sc_r = max(2.4 / fr.s, 0.12 * Wd)
        su = pb1 + sc_r * 0.8
        def in_sc(u, v):
            return math.hypot(u - su, v) <= sc_r
        def sc_col(u, v, x, y):
            d = math.hypot(u - su, v) / sc_r
            ang = math.atan2(u - su, v)
            spiral = abs(((ang / (2 * math.pi)) + d * 1.6) % 1 - 0.5) < 0.16
            return VARNISH[0] if spiral else (VARNISH[3] if v < 0 else VARNISH[2])
        fill(cv, fr, in_sc, su - sc_r, su + sc_r, -sc_r, sc_r, sc_col, 6)
    # strings over the bridge, tailpiece to pegbox
    offs = np.linspace(-max(0.6 / fr.s, 0.03 * Wd), max(0.6 / fr.s, 0.03 * Wd), strings) if strings > 1 else [0]
    for o in offs:
        cv.line(fr.pt(tu1, o), fr.pt(pb0, o * 0.7), (214, 196, 160), part=8, only={1, 2, 3, 4})
    cv.line(fr.pt(fb0, 0.25 / fr.s), fr.pt(pb0, 0.25 / fr.s), (150, 136, 112), part=8, only={5})
    # the bridge (drawn over the strings): pale maple, standing on two feet
    for v in np.linspace(-0.09 * Wd, 0.09 * Wd, 18):
        x, y = fr.pt(fu - 0.01 * L, v)
        cv.put(int(x), int(y), (246, 226, 186), 4)
    for s in (-1, 1):
        x, y = fr.pt(fu - 0.04 * L, s * 0.07 * Wd)
        cv.put(int(x), int(y), (150, 104, 60), 4)
    cv.outline({1, 2, 3, 4, 5, 6, 7, 8}, INK, lit=(110, 40, 26))


# ====================================================================================== HARP
def harp(cv, fr, height=100, depth=64, porcelain=False, rose=True, n_strings=None, pillar=True, frame_ramp=None,
         box_ramp=None, outline_col=None):
    """Side view. Frame: u up, v across (towards the soundbox at +v). The soundbox runs from the foot (u=0,
    v=depth*0.7) up and back to the neck's end (u=height*0.82, v=depth*0.1); the pillar stands at v=-depth*0.3;
    the neck curves across the top joining them."""
    H, D = height, depth
    sb0 = (0.0, -0.12 * D)                           # soundbox foot, beside the pillar's foot
    sb1 = (0.74 * H, 0.62 * D)                        # soundbox head, up at the back, where the neck meets it
    def sb_axis(u, v):
        ax, ay = sb1[0] - sb0[0], sb1[1] - sb0[1]
        Lsb = math.hypot(ax, ay)
        t = ((u - sb0[0]) * ax + (v - sb0[1]) * ay) / Lsb ** 2
        d = (-(u - sb0[0]) * ay + (v - sb0[1]) * ax) / Lsb
        return t, d, Lsb
    def in_sb(u, v):
        t, d, Lsb = sb_axis(u, v)
        w = (0.2 - 0.12 * t) * D
        return 0 <= t <= 1 and -w <= d <= w * 0.3
    ramp = PORC[1:] if porcelain else LACQ
    fr_ramp = frame_ramp or ramp
    ramp = box_ramp or ramp
    def sb_col(u, v, x, y):
        t, d, _ = sb_axis(u, v)
        w = (0.2 - 0.12 * t) * D
        return ramp[3] if d > -w * 0.3 else ramp[2] if d > -w * 0.75 else ramp[1]
    fill(cv, fr, in_sb, -2, H, -D, D, sb_col, 1)
    # the neck: a curve from the soundbox head over to the pillar top (harmonic curve, a gentle S)
    pil_v = -0.36 * D
    def neck_u(v):                                   # the neck's centre line: high at the pillar, dipping, rising to the soundbox
        t = (v - pil_v) / (sb1[1] - pil_v)           # 0 at the pillar, 1 at the soundbox
        return H - (H - sb1[0]) * t - 0.07 * H * math.sin(t * math.pi) + 0.05 * H * math.sin(t * math.pi * 2)
    nw = 0.06 * H
    def in_neck(u, v):
        if not (pil_v - nw <= v <= sb1[1] + nw):
            return False
        return abs(u - neck_u(min(max(v, pil_v), sb1[1]))) <= nw
    fill(cv, fr, in_neck, sb1[0] - nw * 2, H + nw * 2, pil_v - nw * 2, sb1[1] + nw * 2,
         lambda u, v, x, y: fr_ramp[3] if u > neck_u(min(max(v, pil_v), sb1[1])) else fr_ramp[2], 2)
    # pillar
    if pillar:
        def in_pil(u, v):
            return 0.02 * H <= u <= neck_u(pil_v) and abs(v - pil_v + 0.03 * D * math.sin(u / H * math.pi)) <= max(1.0 / fr.s, 0.045 * D)
        fill(cv, fr, in_pil, 0, H, pil_v - 0.1 * D, pil_v + 0.1 * D,
             lambda u, v, x, y: fr_ramp[3] if v < pil_v else fr_ramp[1], 3)
        for uu in (0.06 * H, neck_u(pil_v) - 0.04 * H):        # gold collars at foot and crown
            x, y = fr.pt(uu, pil_v)
            for dx in (-1, 0, 1):
                cv.put(int(x) + dx, int(y), GOLD[2], 3)
    # strings: from the soundbox's centre line up to the neck, vertical in the harp's own frame
    ns = n_strings or max(4, int(D * fr.s / 2.4))
    for i in range(ns):
        t = (i + 0.6) / (ns + 0.4)
        su = sb0[0] + (sb1[0] - sb0[0]) * t
        sv = sb0[1] + (sb1[1] - sb0[1]) * t
        if sv <= pil_v + 0.08 * D:
            continue
        top = neck_u(min(max(sv, pil_v), sb1[1])) - nw
        if top - su < 2 / fr.s:
            continue
        cv.line(fr.pt(su + 0.01 * H, sv), fr.pt(top, sv), STRING if i % 2 else GOLD[3], part=8)
        x, y = fr.pt(top + nw * 0.6, sv)
        cv.put(int(x), int(y), GOLD[2], 7)                    # its tuning pin
    if rose:
        t = 0.3
        rc = (sb0[0] + (sb1[0] - sb0[0]) * t, sb0[1] + (sb1[1] - sb0[1]) * t - 0.05 * D)
        rr = 0.07 * D
        fill(cv, fr, lambda u, v: math.hypot(u - rc[0], v - rc[1]) <= rr, rc[0] - rr, rc[0] + rr, rc[1] - rr, rc[1] + rr,
             lambda u, v, x, y: GOLD[2] if math.hypot(u - rc[0], v - rc[1]) > rr * 0.6 else GLOW[2], 4)
    cv.outline({1, 2, 3, 4, 7}, outline_col or INK, lit=(110, 66, 36) if not porcelain else (60, 80, 140))


def test():
    S = "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/"
    imgs = []
    for f, fr in ((lute, Frame((30, 80), 30, 0.42)), (cello, Frame((48, 90), 0, 0.42)), (harp, Frame((30, 88), 0, 0.8))):
        cv = Canvas(96, 96)
        f(cv, fr)
        imgs.append(cv.image())
    imgs2 = []
    for f, fr in ((lute, Frame((30, 80), 30, 0.28)), (cello, Frame((48, 90), -20, 0.3)), (harp, Frame((30, 88), 10, 0.5))):
        cv = Canvas(96, 96)
        f(cv, fr)
        imgs2.append(cv.image())
    import sys
    sys.path.insert(0, ".")
    from alb_ops import show
    show(imgs + imgs2, ["lute", "cello", "harp", "lute small", "cello small", "harp small"], S + "inst.png", z=4)


if __name__ == "__main__":
    test()


def leaf(cv, base, angle_deg, length, width=None, ramp=((40, 92, 40), (72, 140, 56), (110, 180, 72), (160, 214, 104)), part=20):
    """A pointed leaf from `base`, pointing along angle (0 = up, clockwise), with a midrib."""
    fr = Frame(base, angle_deg, 1.0)
    w = width or length * 0.32
    def inside(u, v):
        if not (0 <= u <= length):
            return False
        t = u / length
        return abs(v) <= w * math.sin(math.pi * t ** 0.8)
    def col(u, v, x, y):
        if abs(v) < 0.5 and 0.15 * length < u < 0.9 * length:
            return ramp[1]
        return ramp[3] if v < 0 else ramp[2]
    fill(cv, fr, inside, 0, length, -w, w, col, part)
    cv.outline({part}, ramp[0])
