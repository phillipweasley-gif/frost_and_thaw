"""Cinderwright line, built the way the creature-design books teach (Whitlatch, Fantastic Creatures,
Corriero, Academy of Art notes):

  1. a simplified posing skeleton first: an egg-shaped rib cage, a smaller tilted pelvis, one continuous
     spine arc from the skull to the tail tip, limb joints where they really are (elbow at the bottom of
     the rib cage, knee tucked up by the belly, hock = the heel, plantigrade mustelid feet)
  2. the basic masses hung on it (head, neck, chest, waist, haunch, limb segments) with narrowing between
  3. a black-silhouette check, then colour: value and saturation concentrated on the head, legs muted

Faces are pixel-placed the way the hand-made 96px sprites do them: a small dark eye with one white
highlight and a lit iris at the bottom, sitting in a socket on the nose-to-ear line, a lid line that sets
the expression together with the ears and the mouth."""
import math
from PIL import Image, ImageDraw
from clean import paint, to_mask, smooth_poly_mask, ellipse_pts, outline_of, thin_line_mask, selout, cleanup_clusters, ribbon, N
from hires import bezier
from sculpt import Part, render
from cinder_anatomy import E, tube, claws
from cinder3 import RUSSET, CREAM, SOOT, PORC, STEEL, COPPER, COBALT, COBALT_LT, glaze, ember_line
from cinder import EMBER, CLAY, CLAY_O
import final_line as F

CUTS5 = (-0.25, 0.1, 0.42, 0.72)
CUTS4 = (-0.2, 0.3, 0.68)
FUR_LINE = (84, 32, 20)
SOOT_LINE = (14, 10, 12)
STEEL_CUTS = (-0.3, 0.05, 0.38, 0.7)
# muted leg fur: the russet ramp pulled toward soot, so the head keeps the strongest colour
UMBER = [(60, 32, 24), (90, 50, 34), (120, 72, 48), (152, 98, 66), (182, 128, 90)]   # wolverine's dark underside
CHAR = [(30, 24, 26), (50, 40, 40), (74, 60, 56), (102, 86, 78)]          # charcoal fur: soot legs with readable form
BONE = [(150, 134, 112), (206, 192, 168), (244, 236, 218)]                    # claws
RUSSET_MUTE = [(70, 32, 26), (108, 52, 36), (146, 80, 52), (180, 112, 76), (206, 146, 108)]


# ----------------------------------------------------------------------------------------------- geometry
def lerp(a, b, t):
    return (a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t)


def seg(a, b, r, over=0.0, shift=0.0):
    """A muscle mass along a bone a->b: an ellipse r wide, overlapping the joints by `over`,
    pushed sideways by `shift` (positive = to the left of a->b)."""
    dx, dy = b[0] - a[0], b[1] - a[1]
    L = math.hypot(dx, dy) or 1
    nx, ny = dy / L, -dx / L
    cx, cy = (a[0] + b[0]) / 2 + nx * shift, (a[1] + b[1]) / 2 + ny * shift
    return E(cx, cy, L / 2 + over, r, math.degrees(math.atan2(dy, dx)))


def fore_limb(scap, sh, el, wr, paw, r, paw_len=None, toes=4, claw_len=0.0, back=1, paw_dir=None):
    """Shoulder blade -> shoulder joint -> elbow -> wrist -> paw. back=+1 if 'behind' is to the right."""
    paw_len = paw_len or r * 1.3
    up = [seg(scap, sh, r * 1.25, r * 0.4), seg(sh, el, r * 1.05, r * 0.3, shift=-back * r * 0.25)]
    lo = tube([el, wr], [r * 0.9, r * 0.58]) + [seg(el, lerp(el, wr, 0.6), r * 0.85, r * 0.2)]
    ang = math.atan2(paw[1] - wr[1], paw[0] - wr[0]) if paw_dir is None else math.radians(paw_dir)
    pc = (paw[0], paw[1])
    pw = [E(pc[0], pc[1], paw_len, r * 0.68, math.degrees(ang))] + tube([wr, paw], [r * 0.58, r * 0.62])
    tip = (pc[0] + math.cos(ang) * paw_len * 0.85, pc[1] + math.sin(ang) * paw_len * 0.85)
    cl = claws(tip[0], tip[1], toes, claw_len, 18, math.degrees(ang)) if claw_len else []
    return {"up": up, "lo": lo, "paw": pw, "claws": cl, "joints": [scap, sh, el, wr, paw], "tip": tip, "ang": ang}


def hind_limb(hip, knee, hock, toe, r, back=1):
    """Hip -> knee (tucked forward by the belly) -> hock (the heel) -> toes; the foot is long and flat."""
    thigh = [seg(hip, knee, r * 1.45, r * 0.55, shift=back * r * 0.15), E(hip[0], hip[1], r * 1.35, r * 1.3)]
    shank = tube([knee, hock], [r * 0.8, r * 0.48]) + [seg(knee, lerp(knee, hock, 0.55), r * 0.72, r * 0.2, shift=-back * r * 0.2)]
    ang = math.atan2(toe[1] - hock[1], toe[0] - hock[0])
    foot = tube([hock, toe], [r * 0.46, r * 0.55]) + [E(toe[0] - math.cos(ang) * r * 0.3, toe[1] - math.sin(ang) * r * 0.3,
                                                          r * 0.75, r * 0.52, math.degrees(ang))]
    return {"up": thigh, "lo": shank, "paw": foot, "joints": [hip, knee, hock, toe], "ang": ang}


def head3q(cx, cy, s, tilt=0.0, yaw=0.55, ears=(0.0, 0.0), jaw=1.0, snout=1.0):
    """A 3/4 mustelid head facing the viewer's left. s = cranium radius.
    Flattened wedge skull, wide cheeks, short muzzle; small round ears set low and wide."""
    t = math.radians(tilt)

    def P(dx, dy):
        return (cx + dx * math.cos(t) - dy * math.sin(t), cy + dx * math.sin(t) + dy * math.cos(t))
    mx = -s * (0.42 + 0.62 * (1 - yaw)) * snout
    g = {"s": s, "P": P, "tilt": tilt}
    g["cranium"] = E(*P(0, -s * 0.05), s * 1.0, s * 0.82, tilt)
    g["muzzle"] = E(*P(mx, s * 0.36), s * 0.62 * snout, s * 0.44, tilt - 4)
    g["cheek"] = E(*P(-s * 0.08, s * 0.42), s * 0.86 * jaw, s * 0.5, tilt + 4)
    g["chin"] = E(*P(mx + s * 0.25, s * 0.66), s * 0.48, s * 0.26, tilt)
    en, ef = (s * 0.78 + ears[0], -s * 0.5 + ears[1]), (-s * 0.3 + ears[0] * 0.5, -s * 0.74 + ears[1])
    g["ear_near"] = E(*P(*en), s * 0.38, s * 0.34, tilt - 20)            # low and wide on the skull
    g["ear_far"] = E(*P(*ef), s * 0.3, s * 0.28, tilt)
    g["ear_near_c"], g["ear_far_c"] = P(*en), P(*ef)
    g["nose"] = P(mx - s * 0.56 * snout, s * 0.2)
    ear_base = P(s * 0.55, -s * 0.38)
    g["eye_near"] = lerp(g["nose"], ear_base, 0.62)          # the socket sits on the nose-to-ear line
    g["eye_far"] = P(mx + s * 0.02, -s * 0.16)               # across the bridge, just above the muzzle
    g["lip"] = E(*P(mx - s * 0.05, s * 0.52), s * 0.6 * snout, s * 0.26, tilt - 4)      # stoat: cream upper lip
    g["throat"] = E(*P(s * 0.1, s * 0.8), s * 0.62, s * 0.34, tilt)
    g["mouth_l"] = P(mx - s * 0.44 * snout, s * 0.55)
    g["mouth_r"] = P(mx + s * 0.3, s * 0.62)
    g["brow"] = (P(mx + s * 0.06, -s * 0.38), P(s * 0.5, -s * 0.4))
    return g


# ----------------------------------------------------------------------------------------------- the face
EYE_DARK, EYE_WHITE = (28, 14, 14), (255, 255, 255)
IRIS = (196, 112, 36)
# eye templates, front of the face to the LEFT. K dark, W highlight, I lit iris, L lid line (fur shadow), . skip
EYES = {
    "kit": [".KK.",
            "KWKK",
            "KWKK",
            "KKIK",
            ".II."],
    "open": ["LLL.",
             "KWKL",
             "KKKK",
             ".IK."],
    "set": ["LL..",      # a determined lid: the line drops toward the nose
            "KLLL",
            "KWKK",
            ".IK."],
    "heavy": ["L...",
              "KLLL",
              "KWKK",
              ".IKK"],
    "far": [".K",
            "KK",
            "WK",
            "KI"],
    "far_set": ["L.",
                "KL",
                "WK",
                "I."],
}


def stamp(img, tpl, x, y, lid):
    px = img.load()
    cols = {"K": EYE_DARK, "W": EYE_WHITE, "I": IRIS, "L": lid}
    for j, row in enumerate(tpl):
        for i, ch in enumerate(row):
            if ch in cols and 0 <= x + i < N and 0 <= y + j < N and px[x + i, y + j][3]:
                px[x + i, y + j] = cols[ch] + (255,)


def face(img, g, eye="open", far="far", mouth="smile", lid=FUR_LINE, brow=None):
    ex, ey = g["eye_near"]
    tpl = EYES[eye]
    stamp(img, tpl, int(round(ex - len(tpl[0]) / 2 + 0.5)), int(round(ey - len(tpl) / 2)), lid)
    fx, fy = g["eye_far"]
    if far:
        tf = EYES[far]
        stamp(img, tf, int(round(fx - 1)), int(round(fy - len(tf) / 2)), lid)
    if brow:
        paint(img, thin_line_mask(brow, 0.7), lid)
    nx, ny = g["nose"]
    nx, ny = int(round(nx)), int(round(ny))
    paint(img, {(nx, ny), (nx + 1, ny), (nx + 1, ny - 1), (nx, ny + 1)}, (34, 16, 16))
    paint(img, {(nx + 1, ny - 1)}, (120, 80, 76))
    ml, mr = g["mouth_l"], g["mouth_r"]
    if mouth == "smile":            # open, happy: corners up, a little tongue
        a, b = (ml[0] + 0.5, ml[1] - 0.6), mr
        mid = lerp(a, b, 0.45)
        pts = [a, (mid[0], mid[1] + 1.6), (b[0], b[1] - 1.2)]
        m = to_mask(smooth_poly_mask([[a, (mid[0] - 1, mid[1] + 2.6), (mid[0] + 1.5, mid[1] + 2.2), (b[0], b[1] - 1.2), (mid[0], mid[1])]]), 0.45, False)
        paint(img, m, (92, 28, 30))
        paint(img, {(x, y) for (x, y) in m if y >= mid[1] + 1.4}, (226, 104, 104))
        paint(img, thin_line_mask(pts, 0.6), (44, 16, 14))
    elif mouth == "set":            # closed, determined: a firm line with a slight downturn at the corner
        paint(img, thin_line_mask([ml, lerp(ml, mr, 0.6), (mr[0], mr[1] + 0.6)], 0.6), (60, 26, 20))
    elif mouth == "grin":           # closed smile, corner up
        paint(img, thin_line_mask([ml, lerp(ml, mr, 0.55), (mr[0] + 0.4, mr[1] - 1.2)], 0.6), (60, 26, 20))
    elif mouth == "snarl":          # a wolverine's working grimace: lip up, a canine showing
        a, b = ml, mr
        m = to_mask(smooth_poly_mask([[a, (lerp(a, b, 0.5)[0], lerp(a, b, 0.5)[1] + 1.8), b, lerp(a, b, 0.5)]]), 0.45, False)
        paint(img, m, (80, 26, 24))
        t = (int(round(lerp(a, b, 0.3)[0])), int(round(lerp(a, b, 0.3)[1])))
        paint(img, {t, (t[0], t[1] + 1)}, (250, 244, 228))
        paint(img, thin_line_mask([a, lerp(a, b, 0.5), b], 0.6), (44, 16, 14))


def inner_ear(img, centre, r, ear_mask, tones=CREAM[1], dx=0.4, dy=0.5):
    m = to_mask(smooth_poly_mask([ellipse_pts(centre[0] + dx, centre[1] + dy, r, r * 0.9, 16)]), 0.4, False) & ear_mask
    paint(img, m - outline_of(ear_mask), tones)


def flame_notch(img, centre, r):
    """The round ear's flame-shaped notch: a small V cut at the top of the ear."""
    px = img.load()
    x = int(round(centre[0]))
    col = [y for y in range(int(centre[1] - r - 2), int(centre[1] + 1)) if 0 <= y < N and px[x, y][3]]
    if col:
        t = min(col)
        for p in ((x, t), (x, t + 1)):
            px[p] = (0, 0, 0, 0)


def shell(cx, cy, rx, ry, rot=0.0, under=0.35, n=28):
    """A plate that wraps a mass: a domed outer edge over the top of the form and a shallow lower edge,
    like a shoulder cap - not a flat disc."""
    c, s_ = math.cos(math.radians(rot)), math.sin(math.radians(rot))
    pts = []
    for i in range(n + 1):
        a = math.pi + math.pi * i / n
        pts.append((rx * math.cos(a), ry * math.sin(a)))
    for i in range(n + 1):
        a = math.pi * i / n
        pts.append((rx * math.cos(a), ry * under * math.sin(a)))
    return [(cx + x * c - y * s_, cy + x * s_ + y * c) for x, y in pts]


def draw_claws(img, L, n, length, spread=22, width=0.75):
    """Pale, non-retractable claws: drawn as short strokes from the toe tips, darker at the point."""
    x, y, ang = L["tip"][0], L["tip"][1], L["ang"]
    for i in range(n):
        a = ang + math.radians((i - (n - 1) / 2) * spread * 0.6)
        bx, by = x + math.cos(a) * -0.6 + (i - (n - 1) / 2) * -math.sin(ang) * 1.6, y + math.sin(a) * -0.6 + (i - (n - 1) / 2) * math.cos(ang) * 1.6
        tx, ty = bx + math.cos(a + 0.35) * length, by + math.sin(a + 0.35) * length
        m = thin_line_mask([(bx, by), (tx, ty)], width)
        paint(img, m, BONE[1])
        paint(img, {min(m, key=lambda p: (p[0] - tx) ** 2 + (p[1] - ty) ** 2)}, BONE[0])


def shell_arcs(cx, cy, rx, ry, rot, fracs, n=20):
    """The overlapping bands of a segmented plate: smaller copies of the dome's upper edge."""
    c, s_ = math.cos(math.radians(rot)), math.sin(math.radians(rot))
    out = []
    for f in fracs:
        pts = []
        for i in range(n + 1):
            a = math.pi + math.pi * i / n
            x, y = rx * math.cos(a) * (0.55 + 0.45 * f), ry * f * math.sin(a)
            pts.append((cx + x * c - y * s_, cy + x * s_ + y * c))
        out.append(pts)
    return out


def steel(img, mask, arcs, shine_path):
    """Burnished steel plate: band lines (dark, with a lit lip under each), a white highlight stripe
    along the lit top, the plate's lower edge kept dark."""
    inner = mask - outline_of(mask)
    for arc in arcs:
        line = thin_line_mask(arc, 0.6) & inner
        paint(img, line, STEEL[0])
        paint(img, {(x, y + 1) for (x, y) in line if (x, y + 1) in inner and (x, y + 1) not in line}, STEEL[3])
    hl = thin_line_mask(shine_path, 0.6) & inner
    paint(img, hl, STEEL[4])
    paint(img, set(sorted(hl)[len(hl) // 3: len(hl) // 3 + 2]), (255, 255, 255))


def porcelain(img, mask, path):
    """A glazed white plate with a cobalt band painted along it (blue-and-white ware), a darker cobalt
    dot pattern in the band, and one hard gloss highlight at the lit top edge."""
    px = img.load()
    mask = {p for p in mask if px[p][3] and px[p][:3] in PORC}
    if not mask:
        return
    edge = outline_of(mask)
    band = thin_line_mask(path, 0.7) & (mask - edge)
    paint(img, band, COBALT_LT)
    pts = sorted(band, key=lambda p: (p[1], p[0]))
    paint(img, set(pts[1::3]), COBALT)
    top = sorted(mask - edge - band, key=lambda p: p[0] + 1.6 * p[1])[:2]
    paint(img, set(top), (255, 255, 255))


PORC_O = (26, 38, 92)            # porcelain outline: deep cobalt, not black


def delft(img, mask, arcs=(), motifs=(), rim=True, gloss=2):
    """Blue-and-white ware painted on a porcelain plate (the plate is rendered in the PORC ramp first):
      - a cobalt border band just inside the rim, beaded with darker cobalt dots
      - the lapped edges of a layered plate as cobalt lines, each with a white glazed lip below it
      - little four-petal flowers as the central motif
      - a hard white gloss where the light hits the top of the dome"""
    px = img.load()
    mask = {p for p in mask if px[p][3]}
    if not mask:
        return
    ol = outline_of(mask)
    inner = mask - ol
    ring = outline_of(inner) if len(inner) > 18 else set()
    if rim and ring:
        paint(img, ring, COBALT_LT)
    for arc in arcs:
        line = thin_line_mask(arc, 0.6) & inner
        paint(img, line, COBALT)
        paint(img, {(x, y + 1) for (x, y) in line if (x, y + 1) in inner - ring and (x, y + 1) not in line}, PORC[3])
    for (mx, my) in motifs:
        c = (int(round(mx)), int(round(my)))
        petals = {(c[0] + dx, c[1] + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))}
        paint(img, petals & inner, COBALT_LT)
        paint(img, {c} & inner, COBALT)
    if gloss:
        free = [p for p in inner - ring if px[p][:3] in PORC]
        top = sorted(free, key=lambda p: p[0] * 0.6 + p[1])[:gloss]
        paint(img, set(top), (255, 255, 255))


def plates_along(path, ts, rx, ry, under=0.45, lift=0.0):
    """Overlapping plates following a spine: each a shell turned to the path's direction."""
    out = []
    n = len(path) - 1
    for t in ts:
        i = min(int(t * n), n - 1)
        a, b = path[i], path[i + 1]
        ang = math.degrees(math.atan2(b[1] - a[1], b[0] - a[0]))
        nx, ny = math.sin(math.radians(ang)), -math.cos(math.radians(ang))
        cx, cy = a[0] + nx * lift, a[1] + ny * lift
        out.append(((cx, cy, rx, ry, ang), shell(cx, cy, rx, ry, ang, under)))
    return out


def rings_along(path, ts, radii, w=1.9):
    """Porcelain bands around a tail: thin ellipses across the tube."""
    out = []
    n = len(path) - 1
    for t, r in zip(ts, radii):
        i = min(int(t * n), n - 1)
        a, b = path[i], path[i + 1]
        ang = math.degrees(math.atan2(b[1] - a[1], b[0] - a[0]))
        out.append(E(a[0], a[1], w, r, ang))
    return out


# ----------------------------------------------------------------------------------------------- skeleton record
class Build:
    """Keeps the skeleton and the named masses, so the development sheet can show the construction."""
    def __init__(self, name):
        self.name, self.bones, self.eggs, self.masses = name, [], [], []

    def bone(self, pts):
        self.bones.append(pts); return pts

    def egg(self, poly):
        self.eggs.append(poly); return poly

    def mass(self, label, polys):
        self.masses.append((label, polys)); return polys


def limb_bones(B, L):
    B.bone(L["joints"])


# =============================================================================================== WICKIT
def form_line(img, mass, within, colour, keep=None):
    """A soft interior line where a muscle mass (shoulder, haunch) turns away inside the silhouette:
    one tone darker than the fur, never the black outline."""
    inner = within - outline_of(within)
    line = outline_of(mass) & inner
    if keep:
        line = {p for p in line if keep(p)}
    paint(img, line, colour)


def mask_of(polys, th=0.5):
    return to_mask(smooth_poly_mask(polys), th, False)


def centroid(m):
    return (sum(x for x, _ in m) / len(m), sum(y for _, y in m) / len(m))


def xf_tree(obj, f):
    """Apply a point transform to every (x, y) in nested lists / dicts of geometry."""
    if isinstance(obj, tuple) and len(obj) == 2 and all(isinstance(v, (int, float)) for v in obj):
        return f(obj)
    if isinstance(obj, list):
        return [xf_tree(o, f) for o in obj]
    if isinstance(obj, tuple):
        return tuple(xf_tree(o, f) for o in obj)
    if isinstance(obj, dict):
        return {k: (xf_tree(v, f) if k not in ("P", "s", "tilt", "ang") else v) for k, v in obj.items()}
    return obj


def rotator(cx, cy, deg):
    c, s_ = math.cos(math.radians(deg)), math.sin(math.radians(deg))
    return lambda p: (cx + (p[0] - cx) * c - (p[1] - cy) * s_, cy + (p[0] - cx) * s_ + (p[1] - cy) * c)


def wickit(build=None):
    """Stoat kit taking off on a bound: the whole body a rising diagonal, hind legs straight out behind
    from the push, one foreleg folded to the chest and the other reaching, the tail streaming back with its
    wick-flame tip. Head turned to us, ears up and forward, open happy mouth.
    Juvenile proportions: big head, big eyes, round shapes."""
    B = build or Build("Wickit")
    R = rotator(46, 62, 13)                                     # the line of action: a rising diagonal
    spine = bezier((30, 55), (40, 53), (50, 55), (58, 58), 20) + bezier((58, 58), (68, 59), (77, 56), (83, 49), 16)[1:]
    rib, pel = E(39, 61, 8.6, 7.4, -8), E(54, 62, 6.8, 6.2, 14)
    body = tube(bezier((33, 60), (40, 59), (48, 61.5), (55, 62), 16), [7.8, 7.6, 6.4, 7.0])
    neck = tube([(34, 58), (28, 53)], [6.4, 5.8])
    fn = fore_limb((40, 55), (34, 63), (31, 70), (24, 76.5), (21.0, 79.4), 3.6, paw_len=2.6)    # reaching for the landing
    ff = fore_limb((42, 56), (38, 64), (37, 71), (31.5, 70), (29.6, 73.2), 3.1, paw_len=2.4)    # folded to the chest
    hn = hind_limb((55, 62), (61, 67.5), (69, 70), (77, 71.5), 4.4)                              # straight out from the push
    hf = hind_limb((53, 63), (58, 69.5), (65, 73.5), (71, 76.5), 3.6)
    belly = [[(30, 60), (36, 66), (44, 69), (50, 69), (56, 67), (52, 73), (42, 75), (34, 71), (28, 64)]]
    spine, rib, pel, body, neck, fn, ff, hn, hf, belly = xf_tree([spine, rib, pel, body, neck, fn, ff, hn, hf, belly], R)
    tail_path = bezier((57, 62.5), (68, 66.5), (79, 62), (83, 49), 24)          # dips, then sweeps up: an S against the body
    tail = tube(tail_path, [3.8, 3.4, 2.9, 2.5])
    spine = spine[:20] + tail_path
    g = head3q(22, 45, 10.0, tilt=-4, yaw=0.6, ears=(0.4, -0.6))          # the head levels off: it looks where it goes
    tip = tail[-1][0]
    tip = (sum(x for x, _ in tail[-1]) / len(tail[-1]), sum(y for _, y in tail[-1]) / len(tail[-1]))
    cup_c = (tip[0] + 0.6, tip[1] - 1.6)
    cup = shell(*cup_c, 5.0, 4.6, 196, 0.32)                   # the first porcelain: a little glazed cup holding the wick
    fb = (cup_c[0] - 0.4, cup_c[1] - 1.0)
    wick = [[(fb[0] + 7.5, fb[1] - 15), (fb[0] + 5.6, fb[1] - 9), (fb[0] + 4, fb[1] - 4), (fb[0] + 2.6, fb[1] + 0.6),
             (fb[0] - 2.6, fb[1] + 0.2), (fb[0] - 2.4, fb[1] - 5), (fb[0] + 1.2, fb[1] - 9)]]
    B.bone(spine); B.bone([spine[0], (22, 45)]); B.egg(rib); B.egg(pel)
    for L in (fn, ff, hn, hf):
        B.bone(L["joints"])
    for lab, p in (("rib cage", [rib]), ("pelvis", [pel]), ("body", body), ("neck", neck),
                   ("head", [g["cranium"], g["cheek"]]), ("muzzle", [g["muzzle"]]), ("ears", [g["ear_near"], g["ear_far"]]),
                   ("shoulder", fn["up"]), ("near foreleg", fn["lo"] + fn["paw"]), ("far foreleg", ff["up"] + ff["lo"] + ff["paw"]),
                   ("haunch", hn["up"]), ("near hind leg", hn["lo"] + hn["paw"]), ("far hind leg", hf["up"] + hf["lo"] + hf["paw"]),
                   ("tail", tail)):
        B.mass(lab, p)
    cream_head = [g["lip"], g["chin"], g["throat"]]
    parts = [
        Part(ff["up"] + ff["lo"] + ff["paw"], RUSSET_MUTE, outline=FUR_LINE, depth=2, cuts=CUTS5, regions=[(ff["paw"], SOOT)], shadow=None),
        Part(hf["up"] + hf["lo"] + hf["paw"], RUSSET_MUTE, outline=FUR_LINE, depth=2, cuts=CUTS5, regions=[(hf["paw"], SOOT)], shadow=None),
        Part(tail, RUSSET, outline=FUR_LINE, depth=3, cuts=CUTS5, shadow=None),
        Part([g["ear_far"]], RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, shadow=None),
        Part(body + neck + fn["up"] + hn["up"], RUSSET, outline=FUR_LINE, depth=7, cuts=CUTS5, regions=[(belly, CREAM)], shadow=(1, 1)),
        Part(hn["lo"] + hn["paw"], RUSSET_MUTE, outline=FUR_LINE, depth=3, cuts=CUTS5, regions=[(hn["paw"], SOOT)], shadow=(1, 1)),
        Part(fn["lo"] + fn["paw"], RUSSET_MUTE, outline=FUR_LINE, depth=3, cuts=CUTS5, regions=[(fn["paw"], SOOT)], shadow=(1, 1)),
        Part([g["cranium"], g["cheek"], g["muzzle"], g["chin"]], RUSSET, outline=FUR_LINE, depth=7, cuts=CUTS5,
             regions=[(cream_head, CREAM)], shadow=(1, 2)),
        Part([g["ear_near"]], RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, shadow=None),
        Part(wick, EMBER, depth=3, cuts=(0.0, 0.45, 0.85), outline=(156, 72, 14), shadow=None),
        Part([cup], PORC, depth=3, cuts=CUTS4, outline=PORC_O, shadow=None),
    ]
    img = render(parts)
    body_m = parts[4].mask
    sh, hh = mask_of(fn["up"]), mask_of(hn["up"])
    cs, ch = centroid(sh), centroid(hh)
    form_line(img, sh, body_m, RUSSET[1], keep=lambda p: p[0] > cs[0] - 1 and p[1] > cs[1] - 3)
    form_line(img, hh, body_m, RUSSET[1], keep=lambda p: p[0] < ch[0] + 1 and p[1] > ch[1] - 4)
    img = cleanup_clusters(img)
    inner_ear(img, g["ear_near_c"], g["s"] * 0.2, parts[8].mask)
    inner_ear(img, g["ear_far_c"], g["s"] * 0.15, parts[3].mask)
    face(img, g, eye="kit", far="far", mouth="smile")
    F.halo(img, parts[-2].mask, EMBER[2], 150)
    fm = parts[-2].mask; fin = fm - outline_of(fm)
    paint(img, fin, EMBER[1])
    paint(img, {p for p in fin if p[1] > fb[1] - 9 and abs(p[0] - (fb[0] + 1 + (fb[1] - p[1]) * 0.35)) <= 1.2}, EMBER[2])
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(fb[0] + 1.2, fb[1] - 3.6, 1.4, 2.0, 12)]), 0.35, False), EMBER[3])
    for (dx, dy) in ((7, -6), (3, -18), (8, -12)):
        paint(img, {(int(fb[0] + dx), int(fb[1] + dy))}, EMBER[2])
    cm = parts[-1].mask
    paint(img, thin_line_mask([(cup_c[0] - 4.4, cup_c[1] + 0.6), (cup_c[0] + 4.4, cup_c[1] + 1.8)], 0.6) & (cm - outline_of(cm)), COBALT_LT)
    delft(img, cm, motifs=[(cup_c[0] + 0.6, cup_c[1] + 3.2)], rim=False, gloss=2)
    flame_notch(img, g["ear_near_c"], g["s"] * 0.38)
    return selout(img), B


# =============================================================================================== STOKETAIL
def stoketail(build=None):
    """Adolescent stoat rising to work: the tripod of two hind feet and the tail, pelvis tilted under,
    the spine an S from the tail up through the chest to a long neck. The weight leg is straight under the
    body, the other foot steps forward. Both forepaws work a glowing lump of clay at different heights -
    the near paw pressing from above, the far paw cupping from below. Head turned to us, focused."""
    B = build or Build("Stoketail")
    spine = bezier((40, 34), (44, 42), (52, 50), (53, 60), 14) + bezier((53, 60), (54, 70), (60, 76), (64, 78), 12)[1:]
    rib = E(47, 55, 9.6, 8.0, -62)
    pel = E(56, 75, 8.0, 7.4, 64)
    body = tube(bezier((45, 46), (51, 54), (52, 64), (56, 74), 18), [7.6, 8.6, 6.8, 8.6])
    neck = tube([(46, 45), (41, 37)], [6.0, 5.4])
    g = head3q(36, 29, 9.4, tilt=-2, yaw=0.64, ears=(0.2, -0.6))
    hn = hind_limb((55, 76), (49, 80), (55, 87), (45, 89.4), 5.0)          # weight leg, under the body
    hf = hind_limb((59, 77), (55, 82.5), (52, 87.6), (42, 87.4), 4.0)      # stepping forward
    fn = fore_limb((49, 47), (44, 52), (46, 60), (37, 57.5), (32.5, 54.8), 3.6, paw_len=2.8, claw_len=2.2)   # pressing
    ff = fore_limb((52, 46), (48, 51), (49, 58), (40, 52), (35.5, 51.2), 3.1, paw_len=2.4)                   # cupping
    clay = E(31.0, 50.0, 5.2, 4.4, -10)
    tail_path = bezier((60, 74), (70, 80), (73, 88), (80, 88), 16) + bezier((80, 88), (86, 88), (90, 84), (91, 77), 12)[1:]
    tail = tube(tail_path, [6.4, 5.4, 4.6, 4.2, 3.8])
    paddle = [[(82, 86), (84, 79), (87, 72), (91, 67.5), (94.5, 70), (95.4, 77), (93.5, 84), (88, 89.6)]]   # the flattened, flanged otter end
    belly = [[(28, 34), (36, 37), (42, 44), (46, 52), (47, 62), (49, 70), (54, 79), (47, 81), (41, 70), (38, 58), (35, 46), (29, 40)]]
    SH = (47.2, 51.2, 7.4, 7.0, -38)
    guard_sh = shell(*SH, 0.45)                            # porcelain shells wrap the forms: a lapped cap over the shoulder
    HP = (60.5, 75.5, 6.6, 7.0, 58)
    guard_hip = shell(*HP, 0.4)                            # one over the haunch
    guard_fa = shell(41.5, 59.4, 3.4, 3.0, -12, 0.5)      # a cuff at the wrist
    BR = (*g["P"](g["s"] * 0.05, -g["s"] * 0.62), g["s"] * 0.42, g["s"] * 0.26, g["tilt"])
    guard_brow = shell(*BR, 0.5)                           # a small plate on the brow
    tail_ring = rings_along(tail_path, [0.18], [6.0])
    B.bone(spine + tail_path); B.egg(rib); B.egg(pel)
    for L in (fn, ff, hn, hf):
        B.bone(L["joints"])
    for lab, p in (("rib cage", [rib]), ("pelvis", [pel]), ("body", body), ("neck", neck),
                   ("head", [g["cranium"], g["cheek"]]), ("muzzle", [g["muzzle"]]), ("ears", [g["ear_near"], g["ear_far"]]),
                   ("shoulder", fn["up"]), ("near foreleg", fn["lo"] + fn["paw"]), ("far foreleg", ff["up"] + ff["lo"] + ff["paw"]),
                   ("haunch", hn["up"]), ("near hind leg", hn["lo"] + hn["paw"]), ("far hind leg", hf["up"] + hf["lo"] + hf["paw"]),
                   ("tail", tail), ("paddle", paddle), ("clay", [clay])):
        B.mass(lab, p)
    cream_head = [g["lip"], g["chin"], g["throat"]]
    parts = [
        Part(hf["up"] + hf["lo"] + hf["paw"], RUSSET_MUTE, outline=FUR_LINE, depth=3, cuts=CUTS5, regions=[(hf["paw"], SOOT)], shadow=None),
        Part(tail + paddle, RUSSET, outline=FUR_LINE, depth=4, cuts=CUTS5, shadow=None),
        Part(tail_ring, PORC, depth=2, cuts=CUTS4, outline=PORC_O, shadow=None),
        Part(ff["up"] + ff["lo"] + ff["paw"], RUSSET_MUTE, outline=FUR_LINE, depth=2, cuts=CUTS5, regions=[(ff["paw"], SOOT)], shadow=None),
        Part([g["ear_far"]], RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, shadow=None),
        Part(body + neck + hn["up"] + fn["up"], RUSSET, outline=FUR_LINE, depth=8, cuts=CUTS5, regions=[(belly, CREAM)], shadow=(1, 1)),
        Part([clay], CLAY, depth=3, cuts=CUTS4, outline=CLAY_O, shadow=(1, 1)),
        Part(hn["lo"] + hn["paw"], RUSSET_MUTE, outline=FUR_LINE, depth=4, cuts=CUTS5, regions=[(hn["paw"], SOOT)], shadow=(1, 1)),
        Part([guard_hip], PORC, depth=3, cuts=CUTS4, outline=PORC_O, shadow=(1, 1)),
        Part([guard_sh], PORC, depth=3, cuts=CUTS4, outline=PORC_O, shadow=(1, 1)),
        Part(fn["lo"] + fn["paw"], RUSSET, outline=FUR_LINE, depth=3, cuts=CUTS5, regions=[(fn["paw"], CHAR)], shadow=(1, 1)),
        Part([guard_fa], PORC, depth=2, cuts=CUTS4, outline=PORC_O, shadow=None),
        Part([g["cranium"], g["cheek"], g["muzzle"], g["chin"]], RUSSET, outline=FUR_LINE, depth=7, cuts=CUTS5,
             regions=[(cream_head, CREAM)], shadow=(1, 2)),
        Part([g["ear_near"]], RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, shadow=None),
        Part([guard_brow], PORC, depth=2, cuts=CUTS4, outline=PORC_O, shadow=(0, 1)),
    ]
    img = render(parts)
    body_m = parts[5].mask
    hh = mask_of(hn["up"]); ch = centroid(hh)
    form_line(img, hh, body_m, RUSSET[1], keep=lambda p: p[1] > ch[1] - 2)
    img = cleanup_clusters(img)
    delft(img, parts[9].mask, arcs=shell_arcs(*SH, (0.5,)), motifs=[(SH[0] - 1, SH[1] + 0.6)])
    delft(img, parts[8].mask, arcs=shell_arcs(*HP, (0.5,)), motifs=[(HP[0] + 0.6, HP[1])])
    delft(img, parts[11].mask, rim=False, motifs=[(41.5, 59.0)], gloss=1)
    delft(img, parts[14].mask, rim=False, motifs=[(BR[0], BR[1] - 0.6)], gloss=1)
    delft(img, parts[2].mask, rim=False, gloss=1)
    inner_ear(img, g["ear_near_c"], g["s"] * 0.2, parts[13].mask)
    inner_ear(img, g["ear_far_c"], g["s"] * 0.15, parts[4].mask)
    face(img, g, eye="open", far="far", mouth="grin")
    # the clay glows where the paws have warmed it
    ember_line(img, [(27.5, 48.5), (30, 50), (33.5, 48.8)], 0.7)          # the lump is kiln-hot inside: cracks glow
    ember_line(img, [(30, 50), (29.4, 53)], 0.6)
    F.halo(img, parts[6].mask, EMBER[1], 80)
    # the paddle: a ridge down its middle and the kiln seam glowing along its edge
    paint(img, thin_line_mask(bezier((86, 86), (87.5, 80), (89.5, 74), (92, 70), 8), 0.6), RUSSET[1])
    ember_line(img, bezier((94.4, 71), (95.0, 77), (93.6, 83), (89.5, 88), 10), 0.8)
    flame_notch(img, g["ear_near_c"], g["s"] * 0.38)
    return selout(img), B


# =============================================================================================== FORGEL
def forgel(build=None):
    """Wolverine build, the anvil tail mid-swing. A compressed spring: shoulders hunched high above the hips
    (attack), head carried below the shoulder line, forelegs braced wide - the near one forward, the far one
    planted - hind legs bunched under and pushing, back arched, the thick otter tail swinging the anvil up
    and over. Blocky shapes; restrained but tense. Dark wolverine legs, pale side band; porcelain plates -
    blue-and-white ware - large on the shoulder and haunch, lapped down the back, small on the brow; heat in the anvil's face."""
    B = build or Build("Forgel")
    DY = 5.0                      # the body rides low: legs as long as the body is deep, no more
    def D(*p):
        return (p[0], p[1] + DY)
    spine = (bezier(D(16, 58), D(26, 50), D(36, 40), D(46, 38), 12) + bezier(D(46, 38), D(55, 39), D(61, 47), D(65, 57), 12)[1:])
    rib = E(*D(41, 54), 14.5, 12.5, -22)
    pel = E(*D(62, 62), 9.6, 9.2, 50)                                                               # tucked low: the back arches
    body = tube(bezier(D(36, 50), D(46, 46), D(56, 52), D(62, 62), 18), [14.0, 13.0, 10.2, 11.0])   # chest > waist < haunch
    hump = E(*D(45, 43), 11.0, 7.0, -8)                                                              # the shoulder hump
    neck = tube([D(33, 52), D(25, 60)], [10.5, 9.6])
    g = head3q(*D(15.0, 56), 13.0, tilt=4, yaw=0.62, ears=(-1.8, -2.2), jaw=1.25, snout=0.88)        # broad, blocky
    fn = fore_limb(D(46, 40), D(36, 57), D(37, 68), (27, 80), (22.0, 86.2), 7.4, paw_len=6.2, toes=4, claw_len=4.0, paw_dir=172)   # braced forward
    ff = fore_limb(D(50, 41), D(46, 58), D(49, 68), (48, 80.5), (44.0, 87.0), 6.4, paw_len=5.4, toes=4, claw_len=3.4, paw_dir=178)  # planted under
    hn = hind_limb(D(62, 62), D(55, 71), (68, 81), (59, 88.8), 7.4)       # bunched under, heel up, pushing
    hf = hind_limb(D(66, 59), D(64, 69), (76, 80), (70, 87.8), 6.0)
    tail_path = bezier(D(65, 57), D(82, 56), D(88, 40), D(82, 25), 20)
    tail = tube(tail_path, [10.0, 8.6, 7.6, 6.8])
    # the anvil, bound to the tail by its foot: flat face, horn, waist, flared foot - tilted forward mid-swing
    base = tail_path[-1]
    d = (tail_path[-1][0] - tail_path[-3][0], tail_path[-1][1] - tail_path[-3][1])
    a = math.atan2(d[1], d[0]) + math.pi / 2           # local -y (the face) points along the tail
    ca, sa = math.cos(a), math.sin(a)
    def A(x, y, k=1.22):
        x, y = x * k, y * k
        return (base[0] + x * ca - y * sa, base[1] + x * sa + y * ca)
    anvil = [[A(*p) for p in ((11, -16.5), (-6, -16.5), (-13, -16), (-18, -15), (-12, -12.6), (-6, -11.4), (-4.4, -11),
                              (-2.6, -5.5), (-8, -1.6), (-8, 0.6), (8, 0.6), (8, -1.6), (2.6, -5.5), (4.4, -11), (11, -11))]]
    face_line = [A(-16, -15.4), A(-6, -16), A(10, -16)]
    collar = E(*A(0, 1.2), 6.6, 3.0, math.degrees(a))
    band_path = bezier(D(34, 48), D(46, 42), D(56, 46), D(64, 56), 18)
    under = [[D(20, 66)] + [(px_, py_ + 2.5) for px_, py_ in band_path] + [(70, 99), (20, 99)]]   # below the band: dark umber
    side_band = [ribbon(bezier(D(34, 48), D(46, 42), D(56, 46), D(64, 56), 18), 3.8, 3.0)]      # wolverine's pale band
    belly = [[D(14, 70), D(22, 72), D(30, 70), D(34, 66), D(32, 74), D(24, 78), D(16, 76)]]
    SH, HP = (*D(43.5, 44.5), 11.2, 8.2, -12), (*D(62, 57), 8.6, 7.6, 50)
    plate_sh = shell(*SH, 0.5)          # large, hugging the shoulder hump
    plate_hip = shell(*HP, 0.45)        # large over the haunch
    s_ = g["s"]; P = g["P"]
    BR = (*P(s_ * 0.05, -s_ * 0.62), s_ * 0.62, s_ * 0.3, g["tilt"] - 4)   # the wolverine's pale brow band, hardened to porcelain
    plate_brow = shell(*BR, 0.5)                                         # small on the brow
    dorsal = plates_along(bezier(D(46, 38), D(55, 39), D(61, 47), D(65, 57), 20), [0.42, 0.72], 5.6, 5.2, 0.5, lift=-1.0)
    FA = (32.0, 75.6, 6.2, 4.2, -35)
    plate_fa = shell(*FA, 0.5)                                           # a guard down the braced forearm
    rings = rings_along(tail_path, [0.58, 0.8, 0.96], [8.0, 7.4, 7.0], w=1.8)
    headband = [ribbon([P(-s_ * 0.55, -s_ * 0.52), P(s_ * 0.1, -s_ * 0.6), P(s_ * 0.7, -s_ * 0.28)], s_ * 0.17, s_ * 0.2)]   # wolverine's pale brow band
    B.bone(spine + tail_path); B.egg(rib); B.egg(pel); B.bone([spine[0], D(15.5, 58)])
    for L in (fn, ff, hn, hf):
        B.bone(L["joints"])
    for lab, p in (("rib cage", [rib]), ("pelvis", [pel]), ("body", body), ("hump", [hump]), ("neck", neck),
                   ("head", [g["cranium"], g["cheek"]]), ("muzzle", [g["muzzle"]]), ("ears", [g["ear_near"], g["ear_far"]]),
                   ("shoulder", fn["up"]), ("near foreleg", fn["lo"] + fn["paw"]), ("far foreleg", ff["up"] + ff["lo"] + ff["paw"]),
                   ("haunch", hn["up"]), ("near hind leg", hn["lo"] + hn["paw"]), ("far hind leg", hf["up"] + hf["lo"] + hf["paw"]),
                   ("tail", tail), ("anvil", anvil)):
        B.mass(lab, p)
    cream_head = [g["lip"], g["chin"]]
    STEEL_O = (24, 22, 30)
    CL = (24, 18, 18)
    parts = [
        Part(hf["up"] + hf["lo"] + hf["paw"], CHAR, outline=SOOT_LINE, depth=4, cuts=CUTS4, shadow=None),
        Part(ff["up"] + ff["lo"] + ff["paw"], CHAR, outline=SOOT_LINE, depth=4, cuts=CUTS4, shadow=None),
        Part(tail, RUSSET, outline=FUR_LINE, depth=6, cuts=CUTS5, shadow=None),
        Part(rings, PORC, depth=2, cuts=CUTS4, outline=PORC_O, shadow=None),
        Part([collar], STEEL, depth=3, cuts=STEEL_CUTS, outline=STEEL_O, shadow=None),
        Part(anvil, STEEL, depth=4, cuts=STEEL_CUTS, outline=STEEL_O, shadow=None),
        Part([g["ear_far"]], RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, shadow=None),
        Part(body + [hump] + neck + fn["up"] + hn["up"], RUSSET, outline=FUR_LINE, depth=11, cuts=CUTS5,
             regions=[(under, UMBER), (side_band, CREAM)], shadow=(1, 1)),
        Part([dorsal[1][1]], PORC, depth=3, cuts=CUTS4, outline=PORC_O, shadow=(1, 1)),
        Part([plate_hip], PORC, depth=4, cuts=CUTS4, outline=PORC_O, shadow=(1, 1)),
        Part([dorsal[0][1]], PORC, depth=3, cuts=CUTS4, outline=PORC_O, shadow=(1, 1)),
        Part(hn["lo"] + hn["paw"], CHAR, outline=SOOT_LINE, depth=5, cuts=CUTS4, shadow=(1, 1)),
        Part([plate_sh], PORC, depth=5, cuts=CUTS4, outline=PORC_O, shadow=(1, 1)),
        Part(fn["lo"] + fn["paw"], CHAR, outline=SOOT_LINE, depth=5, cuts=CUTS4, shadow=(1, 1)),
        Part([plate_fa], PORC, depth=3, cuts=CUTS4, outline=PORC_O, shadow=(1, 1)),
        Part([g["cranium"], g["cheek"], g["muzzle"], g["chin"]], RUSSET, outline=FUR_LINE, depth=8, cuts=CUTS5,
             regions=[(cream_head, CREAM)], shadow=(1, 2)),
        Part([g["ear_near"]], RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, shadow=None),
        Part([plate_brow], PORC, depth=2, cuts=CUTS4, outline=PORC_O, shadow=(0, 1)),
    ]
    I = {"rings": 3, "anvil": 5, "body": 7, "d1": 8, "hip": 9, "d0": 10, "sh": 12, "fa": 14, "head": 15, "ear": 16, "brow": 17}
    img = render(parts)
    body_m = parts[I["body"]].mask
    hh = mask_of(hn["up"]); ch = centroid(hh)
    form_line(img, hh, body_m, RUSSET[1], keep=lambda p: p[1] > ch[1] - 3)
    sh = mask_of(fn["up"]); cs = centroid(sh)
    form_line(img, sh, body_m, RUSSET[1], keep=lambda p: p[0] > cs[0] and p[1] > cs[1])
    img = cleanup_clusters(img)
    # hard shine on steel: a white highlight stripe along each plate's lit upper edge
    # blue-and-white porcelain armour: lapped bands on the big plates, flowers, gloss
    delft(img, parts[I["sh"]].mask, arcs=shell_arcs(*SH, (0.34, 0.68)), motifs=[(SH[0] - 4, SH[1] - 1.5), (SH[0] + 4, SH[1] - 1)], gloss=3)
    delft(img, parts[I["hip"]].mask, arcs=shell_arcs(*HP, (0.5,)), motifs=[(HP[0], HP[1] - 1)])
    for k in ("d0", "d1"):
        geo = dorsal[0 if k == "d0" else 1][0]
        delft(img, parts[I[k]].mask, motifs=[(geo[0], geo[1] - 1.8)])
    delft(img, parts[I["fa"]].mask, motifs=[(FA[0], FA[1] - 1)], gloss=2)
    delft(img, parts[I["brow"]].mask, rim=False, motifs=[(BR[0], BR[1] - 1)], gloss=1)
    delft(img, parts[I["rings"]].mask, rim=False, gloss=0)
    steel(img, parts[I["anvil"]].mask, [], face_line)
    inner_ear(img, g["ear_near_c"], g["s"] * 0.18, parts[I["ear"]].mask)
    draw_claws(img, ff, 3, 3.0)
    draw_claws(img, fn, 4, 3.6)
    face(img, g, eye="heavy", far="far_set", mouth="set")
    # kiln heat: the seam under the shoulder plate, the anvil's face, sparks
    ember_line(img, bezier(D(33, 46.5), D(38, 50), D(48, 50.5), D(54, 48.5), 12), 0.8)    # kiln heat in the gap under the pauldron
    ember_line(img, [A(-3.6, -9.0), A(3.6, -9.0)], 0.8)              # heat glowing at the anvil's waist
    for (x, y) in ((A(-19, -16)), A(-14, -19), A(-21, -11), A(-9, -20)):
        paint(img, {(int(x), int(y))}, EMBER[2])
    flame_notch(img, g["ear_near_c"], g["s"] * 0.36)
    return selout(img), B


# =============================================================================================== preview
def dev_sheet(fns, path, scale=3):
    """Per creature: skeleton -> basic masses -> black silhouette -> colour."""
    cells = []
    for fn in fns:
        img, B = fn()
        w = 96 * scale
        sk = Image.new("RGBA", (w, w), (236, 236, 240, 255))
        d = ImageDraw.Draw(sk)
        for poly in B.eggs:
            d.polygon([(x * scale, y * scale) for x, y in poly], outline=(80, 110, 190, 255), width=2)
        for pts in B.bones:
            d.line([(x * scale, y * scale) for x, y in pts], fill=(200, 60, 50, 255), width=3)
            for x, y in ([] if len(pts) > 6 else pts):
                d.ellipse([x * scale - 4, y * scale - 4, x * scale + 4, y * scale + 4], fill=(40, 40, 40, 255))
        fm = Image.new("RGBA", (w, w), (236, 236, 240, 255))
        d2 = ImageDraw.Draw(fm)
        palette = [(200, 90, 60), (70, 120, 200), (60, 150, 90), (180, 120, 40), (140, 70, 170), (40, 150, 160)]
        fpx = fm.load()
        for i, (lab, polys) in enumerate(B.masses):
            c = palette[i % len(palette)] + (255,)
            for (x, y) in outline_of(mask_of(polys)):
                if 0 <= x < 96 and 0 <= y < 96:
                    for k in range(scale):
                        for j in range(scale):
                            fpx[x * scale + k, y * scale + j] = c
        sil = Image.new("RGBA", (w, w), (236, 236, 240, 255))
        a = img.split()[3].resize((w, w), Image.NEAREST)
        sil.paste((20, 18, 24, 255), (0, 0), a)
        col = Image.new("RGBA", (w, w), (72, 80, 104, 255))
        col.alpha_composite(img.resize((w, w), Image.NEAREST))
        cells.append((sk, fm, sil, col))
    W = 4 * 96 * scale + 50
    H = len(cells) * (96 * scale + 10) + 10
    out = Image.new("RGBA", (W, H), (250, 250, 252, 255))
    for r, row in enumerate(cells):
        for c, im in enumerate(row):
            out.alpha_composite(im, (10 + c * (96 * scale + 10), 10 + r * (96 * scale + 10)))
    out.save(path)


SCR = "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/"

if __name__ == "__main__":
    import sys
    dev_sheet([wickit, stoketail, forgel], SCR + "rig_w.png")
    for nm, fn_, box in (("wface", wickit, (6, 26, 58, 78)), ("sface", stoketail, (22, 14, 98, 94)), ("fface", forgel, (0, 4, 96, 94))):
        img, _ = fn_()
        c = img.crop(box)
        bg = Image.new("RGBA", c.size, (72, 80, 104, 255)); bg.alpha_composite(c)
        bg.resize((c.width * 6, c.height * 6), Image.NEAREST).save(SCR + nm + ".png")
