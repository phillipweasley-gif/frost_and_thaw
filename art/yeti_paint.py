"""Painted (4x) back views for Yetot and Yetitan, reduced to 96px with the same steps as the fronts
(area average -> small palette -> clean-up -> selective outline), so front and back match.

Anatomy notes are in yeti_back.py. Painting method:
  - each part is a smooth mask (organic edges); fur parts get pointed locks along their edges
  - light: a soft height field from each part's distance-to-edge -> normals -> lit from the upper left,
    mapped onto that material's colour ramp; parts in front cast a soft shadow on parts behind
  - fur: hundreds of short strokes following the fall of the fur, a shade lighter or darker than the
    local light, which reduce to the same speckled fur as the fronts
"""
import math, random
import numpy as np
from PIL import Image, ImageDraw
from scipy import ndimage as ndi

K = 4
W = 96 * K
SCR = "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/"

# ramps sampled from the front sprites (dark -> light)
FUR = [(132, 122, 146), (178, 168, 184), (214, 202, 204), (238, 228, 218), (252, 246, 236)]
SKIN = [(70, 82, 120), (104, 120, 160), (138, 156, 194), (170, 190, 220)]
ICE = [(84, 128, 192), (132, 182, 228), (190, 222, 246), (236, 248, 255)]
SNOW = [(186, 196, 218), (222, 230, 244), (244, 248, 255), (255, 255, 255)]
LIGHT = np.array([-0.5, -0.7, 0.62]); LIGHT /= np.linalg.norm(LIGHT)


def poly_mask(polys):
    im = Image.new("L", (W, W), 0)
    d = ImageDraw.Draw(im)
    for p in polys:
        d.polygon([(x * K, y * K) for x, y in p], fill=255)
    return np.asarray(im) > 127


def E(cx, cy, rx, ry, rot=0, n=48):
    c, s = math.cos(math.radians(rot)), math.sin(math.radians(rot))
    return [(cx + rx * math.cos(2 * math.pi * i / n) * c - ry * math.sin(2 * math.pi * i / n) * s,
             cy + rx * math.cos(2 * math.pi * i / n) * s + ry * math.sin(2 * math.pi * i / n) * c) for i in range(n)]


def limb(path, radii):
    """A tapering limb as overlapping circles along a path (96px coordinates)."""
    out = []
    pts = []
    for (a, b) in zip(path, path[1:]):
        n = max(2, int(math.hypot(b[0] - a[0], b[1] - a[1]) * 2))
        pts += [(a[0] + (b[0] - a[0]) * t / n, a[1] + (b[1] - a[1]) * t / n) for t in range(n)]
    pts.append(path[-1])
    for i, (x, y) in enumerate(pts):
        u = i / max(1, len(pts) - 1) * (len(radii) - 1)
        j = min(int(u), len(radii) - 2)
        r = radii[j] + (radii[j + 1] - radii[j]) * (u - j)
        out.append(E(x, y, r, r, n=24))
    return out


def locks(cx, cy, r, a0, a1, n, length, w=2.4, jitter=0.25, rng=None, curl=12):
    """Pointed fur locks radiating from an arc (degrees; 0 = right, 90 = down)."""
    rng = rng or random.Random(1)
    out = []
    for i in range(n):
        a = math.radians(a0 + (a1 - a0) * (i + 0.5 + rng.uniform(-jitter, jitter)) / n)
        L = length * rng.uniform(0.7, 1.15)
        bx, by = cx + math.cos(a) * r, cy + math.sin(a) * r
        pts_l, pts_r = [], []
        for k in range(8):
            t = k / 7
            aa = a + math.radians(curl) * t * t
            x, y = bx + math.cos(aa) * L * t, by + math.sin(aa) * L * t
            ww = w * (1 - t) ** 0.9
            nx, ny = -math.sin(aa), math.cos(aa)
            pts_l.append((x + nx * ww, y + ny * ww)); pts_r.append((x - nx * ww, y - ny * ww))
        out.append(pts_l + pts_r[::-1])
    return out


def flame(x, y, ang, length, w, curl=22):
    """A flame-shaped crest lock (like the tuft on the front)."""
    a = math.radians(ang)
    L_, R_ = [], []
    for k in range(10):
        t = k / 9
        aa = a + math.radians(curl) * t * t
        px_, py_ = x + math.cos(aa) * length * t, y + math.sin(aa) * length * t
        ww = w * (1 - t) ** 0.8 * min(1.0, t * 3 + 0.45)
        nx, ny = -math.sin(aa), math.cos(aa)
        L_.append((px_ + nx * ww, py_ + ny * ww)); R_.append((px_ - nx * ww, py_ - ny * ww))
    return [L_ + R_[::-1]]


class Part:
    def __init__(self, polys, ramp, kind="fur", depth=10, flow=90, soft=1.2, cut=None):
        m = poly_mask(polys)
        if soft:
            m = ndi.gaussian_filter(m.astype(np.float32), soft * K / 2) > 0.5
        if cut is not None:
            m &= ~cut
        self.mask, self.ramp, self.kind, self.depth, self.flow = m, ramp, kind, depth, flow


def shade(mask, depth):
    d = ndi.distance_transform_edt(mask) / (depth * K)
    h = np.sqrt(np.clip(1 - (1 - np.clip(d, 0, 1)) ** 2, 0, 1))
    h = ndi.gaussian_filter(h, 2.0)
    gy, gx = np.gradient(h)
    n = np.stack([-gx * 6, -gy * 6, np.ones_like(h)], -1)
    n /= np.linalg.norm(n, axis=-1, keepdims=True)
    return np.clip(n @ LIGHT, 0, 1)


def ramp_at(ramp, v):
    r = np.array(ramp, np.float32)
    x = np.clip(v, 0, 1) * (len(r) - 1)
    i = np.clip(x.astype(int), 0, len(r) - 2)
    f = (x - i)[..., None]
    return r[i] * (1 - f) + r[i + 1] * f


def paint(parts, seed=1, strokes=2600):
    rng = random.Random(seed)
    col = np.zeros((W, W, 3), np.float32)
    alpha = np.zeros((W, W), bool)
    owner = np.full((W, W), -1, int)
    vals = np.zeros((W, W), np.float32)
    for i, p in enumerate(parts):
        v = shade(p.mask, p.depth)
        # a part in front shadows what is behind it, just below and right of its edge
        if alpha.any():
            sh = ndi.shift(p.mask.astype(np.float32), (3 * K / 2, 2 * K / 2), order=0)
            sh = ndi.gaussian_filter(sh, K * 1.2)
            vals = np.where(alpha & ~p.mask, vals * (1 - 0.35 * sh), vals)
            col = np.where((alpha & ~p.mask)[..., None], ramp_at(parts[0].ramp, 0) * 0 + col * (1 - 0.18 * sh[..., None]), col)
        tone = 0.42 + 0.72 * v
        c = ramp_at(p.ramp, tone)
        # where this part lies over something already painted, its edge is a soft dark contour
        edge = p.mask & ~ndi.binary_erosion(p.mask, iterations=int(K * 0.6))
        over = edge & ndi.binary_dilation(alpha & ~p.mask, iterations=int(K * 0.6))
        c = np.where(over[..., None], ramp_at(p.ramp, np.full_like(tone, 0.3)), c)
        tone = np.where(over, 0.3, tone)
        col = np.where(p.mask[..., None], c, col)
        vals = np.where(p.mask, tone, vals)
        owner = np.where(p.mask, i, owner)
        alpha |= p.mask
    # fur strokes
    img = Image.fromarray(np.clip(col, 0, 255).astype(np.uint8), "RGB")
    d = ImageDraw.Draw(img)
    ys, xs = np.nonzero(alpha)
    for _ in range(strokes):
        j = rng.randrange(len(xs))
        x, y = int(xs[j]), int(ys[j])
        i = owner[y, x]
        p = parts[i]
        if p.kind != "fur":
            continue
        a = math.radians(p.flow + rng.uniform(-18, 18))
        L = rng.uniform(5, 11) * K / 2
        x2, y2 = x + math.cos(a) * L, y + math.sin(a) * L
        if not (0 <= int(x2) < W and 0 <= int(y2) < W) or owner[int(y2), int(x2)] != i:
            continue
        t = vals[y, x] + (0.1 if rng.random() < 0.5 else -0.16)
        cc = tuple(int(v) for v in ramp_at(p.ramp, np.array(t)))
        d.line([(x, y), (x2, y2)], fill=cc, width=max(1, int(K * 0.6)))
    out = np.dstack([np.asarray(img), np.where(alpha, 255, 0).astype(np.uint8)])
    return Image.fromarray(out, "RGBA")


def reduce(big, colours=20, ground=92):
    """The fronts' reduction: area average to 96, snap to a small palette, clean, outline."""
    from clean import limit_palette, cleanup_clusters, selout
    a = np.asarray(big).astype(np.float32)
    al = a[..., 3:] / 255.0
    rgb = a[..., :3] * al
    small_rgb = rgb.reshape(96, K, 96, K, 3).mean((1, 3))
    small_a = al.reshape(96, K, 96, K, 1).mean((1, 3))
    c = small_rgb / np.maximum(small_a, 1e-4)
    out = np.zeros((96, 96, 4), np.uint8)
    out[..., :3] = np.clip(c, 0, 255).astype(np.uint8)
    out[..., 3] = np.where(small_a[..., 0] >= 0.5, 255, 0)
    img = limit_palette(Image.fromarray(out, "RGBA"), colours)
    img = cleanup_clusters(img, 1)
    bb = img.getbbox()
    if bb and bb[3] != ground:
        moved = Image.new("RGBA", img.size, (0, 0, 0, 0)); moved.alpha_composite(img, (0, ground - bb[3])); img = moved
    return selout(img)


# ------------------------------------------------------------------------------------------ Yetot
def yetot():
    r = random.Random(587)
    P = []
    # far hand and snowball are drawn first only where they are behind; here both arms are at the sides
    P.append(Part([E(38, 88, 8, 4), E(59, 88, 8, 4)], SKIN, "skin", depth=3))                       # heels
    P.append(Part([E(38, 81, 8, 8), E(58, 81, 8, 8)] + locks(38, 80, 6, 60, 150, 3, 5, rng=r) +
                  locks(58, 80, 6, 30, 120, 3, 5, rng=r), FUR, depth=6, flow=95))                    # legs
    P.append(Part([E(48, 64, 20, 19)] + locks(48, 64, 17, 15, 165, 11, 7, rng=r, curl=8) +
                  locks(48, 60, 18, 160, 210, 3, 6, rng=r) + locks(48, 60, 18, -30, 20, 3, 6, rng=r),
                  FUR, depth=14, flow=92))                                                            # body
    P.append(Part([E(30, 42, 3.6, 3.4), E(66, 42, 3.6, 3.4)], SKIN, "skin", depth=2))                # ears
    P.append(Part([E(48, 40, 18, 16)] + locks(48, 42, 15, 120, 240, 6, 6, rng=r) +
                  locks(48, 42, 15, -60, 60, 6, 6, rng=r) + locks(48, 48, 13, 55, 125, 6, 8, rng=r, curl=6) +
                  flame(43, 28, -108, 13, 4.2) + flame(49, 27, -84, 16, 4.6) + flame(55, 29, -58, 11, 3.8) +
                  flame(38, 31, -140, 8, 3.2),
                  FUR, depth=13, flow=100))                                                           # head / mane
    # the raised arm: back of the upper arm, then the back of the hand with the fingers above it
    P.append(Part(limb([(35, 57), (29, 50), (25, 45)], [6.2, 5.4, 4.8]) + locks(30, 51, 4, 60, 160, 3, 4, rng=r),
                  FUR, depth=5, flow=110))
    P.append(Part([E(24, 41, 5.6, 5.2)] + [E(19.5 + i * 3.1, 35.8 + abs(i - 1.5) * 0.7, 1.7, 2.6) for i in range(4)],
                  SKIN, "skin", depth=3))
    # the snowball arm: out to the side, the hand cupped round the back of the ball
    P.append(Part([E(76, 56, 6.6, 6.3)], SNOW, "snow", depth=5))
    P.append(Part(limb([(61, 60), (68, 63), (72, 64)], [6, 5.2, 4.8]) + locks(66, 64, 4, 50, 140, 3, 4, rng=r),
                  FUR, depth=5, flow=80))
    P.append(Part([E(74.5, 61.5, 5.4, 4.6)] + [E(70 + i * 2.8, 58.2 - abs(i - 1) * 0.6, 1.5, 2.2) for i in range(3)],
                  SKIN, "skin", depth=3))
    big = paint(P, seed=587, strokes=2200)
    return reduce(big)


# ---------------------------------------------------------------------------------------- Yetitan
def yetitan():
    r = random.Random(588)
    P = []
    P.append(Part([E(28, 88.5, 11, 4.2), E(69, 88.5, 11, 4.2)], SKIN, "skin", depth=3))             # heels
    P.append(Part([E(32, 77, 12, 11, -15), E(65, 77, 12, 11, 15)] + locks(32, 80, 9, 40, 150, 5, 7, rng=r) +
                  locks(65, 80, 9, 30, 140, 5, 7, rng=r), FUR, depth=9, flow=95))                    # thighs
    # the back: a hump of trapezius sloping from the low head down to the shoulders, broad lats,
    # narrowing to the hips under a skirt of long fur
    trap = [[(38, 12), (62, 12), (78, 24), (86, 36), (12, 36), (20, 24)]]
    back = [E(49, 42, 29, 19), E(49, 58, 21, 15)]
    P.append(Part(trap + back + locks(49, 60, 18, 25, 155, 9, 9, rng=r, curl=6),
                  FUR, depth=20, flow=95))
    # arms: the backs of the upper arms, elbows out, forearms coming forward and in; long fur hangs
    # from the undersides
    arms = {-1: ([(19, 30), (12, 42), (9, 52)], [(9, 50), (10, 62), (15, 71)], (16, 74)),
            1: ([(79, 30), (86, 42), (89, 52)], [(89, 50), (89, 62), (84, 72)], (83, 77))}
    for side, (up, fore, hand) in arms.items():
        hang = locks(up[-1][0], up[-1][1] + 2, 6, 90 - side * 10 - 50, 90 - side * 10 + 50, 4, 8, rng=r, curl=4)
        P.append(Part(limb(up, [11.5, 10.5, 9.5]) + hang, FUR, depth=10, flow=88 + side * 6))
        P.append(Part(limb(fore, [10, 9.5, 8]) + locks(fore[1][0], fore[1][1], 7, 90 - side * 80, 90 + side * 20, 5, 7, rng=r),
                      FUR, depth=9, flow=92))
    # faceted ice plates along the outer forearms, overlapping like scales, points outward
    for side, (_, fore, _h) in arms.items():
        plates = []
        for k in range(4):
            t = (k + 0.3) / 4
            x = fore[0][0] + (fore[2][0] - fore[0][0]) * t + side * 7.5
            y = fore[0][1] + (fore[2][1] - fore[0][1]) * t
            s_ = 5.4 - abs(k - 1.4) * 0.6
            plates.append([(x - side * 4, y - s_ * 1.1), (x + side * s_ * 0.9, y - s_ * 0.5),
                           (x + side * s_ * 0.5, y + s_ * 0.9), (x - side * 3, y + s_ * 1.0)])
        P.append(Part(plates, ICE, "ice", depth=3, soft=0))
    P.append(Part([E(16, 75, 7.5, 6)], SKIN, "skin", depth=4))                                        # left fist
    P.append(Part([E(83, 78, 8, 6)] + [E(77 + i * 3.8, 83, 2, 2.4) for i in range(4)], SKIN, "skin", depth=4))
    P.append(Part([E(38, 21, 3.4, 3.2), E(62, 21, 3.4, 3.2)], SKIN, "skin", depth=2))                # ears
    P.append(Part([E(50, 19, 12, 10.5)] + locks(50, 23, 9, 25, 155, 7, 8, rng=r, curl=6) +
                  flame(45, 12, -110, 11, 3.8) + flame(50, 11, -86, 14, 4.2) + flame(56, 12, -60, 10, 3.6),
                  FUR, depth=8, flow=100))                                                            # head
    big = paint(P, seed=588, strokes=4200)
    return reduce(big)


if __name__ == "__main__":
    import sys
    from yeti_back import show
    rdir = "/home/claude/frost-thaw/build/concept/yeti_sprites/"
    a, b = yetot(), yetitan()
    fa = Image.open(rdir + "yetot_96.png"); fb = Image.open(rdir + "yetitan_96.png")
    show([fa, a, fb, b], sys.argv[1] if len(sys.argv) > 1 else SCR + "yb2.png", z=4)
