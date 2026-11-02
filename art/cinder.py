"""The Cinderwright line, rendered: Wickit (spark) -> Stoketail (practice) -> Forgel (mastery).
A weasel whose tail is its tool. Same bright eyes, round ears (one with a flame-shaped notch),
cream muzzle, soot-dark forepaws and tail-led pose in every stage.
Studio palette: charcoal, warm copper, kiln-fired orange, cream, a little luminous gold."""
import math
from PIL import Image
from clean import *
from hires import bezier
from cinder_thumbs import tube, flat, E, Tube
import final_line as F

RUSSET = [(104, 42, 28), (156, 70, 40), (198, 104, 56), (232, 148, 92)];  RUSSET_O = (66, 24, 16)
CREAM = [(196, 160, 118), (228, 200, 158), (246, 226, 190), (255, 244, 220)]; CREAM_O = (132, 96, 62)
SOOT = [(28, 24, 28), (48, 40, 42), (70, 60, 58), (96, 84, 78)];           SOOT_O = (14, 10, 12)
KILN = [(122, 50, 24), (178, 84, 38), (214, 120, 58), (240, 164, 98)];      KILN_O = (58, 22, 10)
PORCELAIN = [(168, 178, 196), (208, 216, 230), (234, 239, 247), (252, 253, 255)]; PORCELAIN_O = (70, 80, 108)
COBALT, COBALT_LT = (34, 62, 150), (84, 120, 206)
IRON = [(46, 48, 60), (72, 74, 90), (108, 110, 126), (156, 156, 170)];       IRON_O = (20, 18, 26)
COPPER = [(118, 58, 30), (176, 96, 50), (218, 140, 80), (246, 190, 132)]
EMBER = [(214, 110, 28), (255, 164, 48), (255, 212, 104), (255, 246, 206)]
CLAY = [(110, 70, 52), (150, 100, 74), (182, 132, 100), (212, 168, 132)];    CLAY_O = (62, 36, 26)
IRIS = (236, 150, 40)


class St:
    def __init__(self, k, ground):
        self.k, self.g = k, ground

    def p(self, pts):
        return [(48 + (x - 48) * self.k, self.g + (y - self.g) * self.k) for x, y in pts]

    def ps(self, parts):
        return [self.p(q) for q in flat(parts)]

    def r(self, v):
        return v * self.k


def flame(x, y, r, lean=0.0):
    tip = (x + lean * r, y - r * 2.0)
    side = ellipse_pts(x, y, r, r * 0.95, 32, -10, 190)
    return [tip] + side[::-1]


def notch_hole(S, x, y, r):
    """A small flame-shaped notch cut into the top of one ear."""
    pts = [(x - r * 0.7, y - r * 1.5), (x - r * 0.15, y - r * 0.9), (x + r * 0.05, y - r * 1.8), (x + r * 0.7, y - r * 1.2), (x, y + r * 0.25)]
    return S.p(pts)


def glow(img, mask, colour=EMBER[2], strength=110):
    F.halo(img, mask, colour, strength)


def ember_line(img, pts, width=1.0):
    m = thin_line_mask(pts, width)
    F.halo(img, m, EMBER[1], 100)
    paint(img, m, EMBER[2])
    return m


def bright_eye(img, cx, cy, w, h):
    """A dark, shining weasel eye: deep brown, an amber glow low in it, a white highlight."""
    m = to_mask(smooth_poly_mask([ellipse_pts(cx, cy, w, h, 24)]), 0.42, False)
    paint(img, m, (44, 22, 16))
    low = {(x, y) for (x, y) in m if y >= cy + h * 0.25 and abs(x - cx) < w * 0.75}
    paint(img, low, IRIS)
    paint(img, outline_of(m), (24, 10, 8))
    hx, hy = int(round(cx - w * 0.35)), int(round(cy - h * 0.35))
    paint(img, {(hx, hy)} | ({(hx, hy + 1)} if h >= 2.4 else set()), (255, 255, 255))


def notch(img, x, y):
    """Cut a small flame-shaped notch into the top of an ear at about (x, y)."""
    px = img.load()
    x, y = int(round(x)), int(round(y))
    col = [yy for yy in range(N) if px[x, yy][3] > 0]
    if not col:
        return
    top = min(col)
    for (dx, dy) in ((0, 0), (0, 1), (1, 0), (-1, 0) if False else (0, 0)):
        if 0 <= x + dx < N:
            px[x + dx, top + dy] = (0, 0, 0, 0)


def toe_centres(cx, cy, rx, ry, rot=0.0, toes_up=True):
    a0 = math.radians(rot - 90 if toes_up else rot + 90)
    out = []
    for t in (-0.75, -0.25, 0.25, 0.75):
        ang = a0 + t * 1.1
        out.append((cx + math.cos(ang) * rx * 0.86, cy + math.sin(ang) * ry * 0.86, rx * 0.3))
    return out


def paw_detail(img, S, cx, cy, rx, ry, rot=0.0, toes_up=True, pads=None):
    """Split the toes with dark lines; optionally light the pads (palm and toe beans)."""
    for (x, y, r) in toe_centres(cx, cy, rx, ry, rot, toes_up):
        m = to_mask(smooth_poly_mask([S.p(E(x, y, r, r))]), 0.45, False)
        c = S.p([(x, y)])[0]
        inner = {q for q in outline_of(m) if (q[0] - c[0]) * math.cos(math.radians(rot + (90 if toes_up else -90))) +
                 (q[1] - c[1]) * math.sin(math.radians(rot + (90 if toes_up else -90))) > -0.2}
        paint(img, inner, SOOT_O)
        if pads:
            paint(img, to_mask(smooth_poly_mask([S.p(E(x, y, r * 0.55, r * 0.55))]), 0.35, False), pads)
    if pads:
        palm = S.p(E(cx, cy + (ry * 0.15 if toes_up else -ry * 0.15), rx * 0.42, ry * 0.36, rot))
        paint(img, to_mask(smooth_poly_mask([palm]), 0.4, False), pads)


def blue_and_white(img, mask, motif=True):
    """Hand-painted porcelain: a cobalt band just inside the rim and, room permitting, a little flower."""
    px = img.load()
    mask = {p for p in mask if px[p][:3] in PORCELAIN or px[p][:3] == PORCELAIN_O}
    edge = outline_of(mask)
    ring = {(x, y) for (x, y) in mask if (x, y) not in edge and any((x + dx, y + dy) in edge for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))}
    if len(mask) >= 60:
        core = mask - edge - ring
        paint(img, {p for p in ring if (p[0] + p[1]) % 3 != 0}, COBALT_LT)      # a painted band, brush-broken
    else:
        core = mask - edge
    if motif and len(core) >= 12:
        cx = sum(x for x, _ in core) / len(core); cy = sum(y for _, y in core) / len(core)
        c = (int(round(cx)), int(round(cy)))
        petals = {(c[0] + dx, c[1] + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))} & core
        paint(img, petals, COBALT_LT)
        paint(img, {c}, COBALT)
        if len(core) >= 30:                       # a curling vine either side
            for sgn in (-1, 1):
                v = {(c[0] + sgn * 2, c[1] - 1), (c[0] + sgn * 3, c[1]), (c[0] + sgn * 3, c[1] + 1)} & core
                paint(img, v, COBALT)
    elif len(core) >= 3:
        cx = sum(x for x, _ in core) / len(core); cy = sum(y for _, y in core) / len(core)
        paint(img, {(int(round(cx)), int(round(cy)))}, COBALT)


def paw(cx, cy, rx, ry, rot=0.0, toes_up=True):
    """A soot paw: a soft pad with four toe bumps along its leading edge."""
    parts = [E(cx, cy, rx, ry, rot)]
    a0 = math.radians(rot - 90 if toes_up else rot + 90)
    for i, t in enumerate((-0.75, -0.25, 0.25, 0.75)):
        ang = a0 + t * 1.1
        parts.append(E(cx + math.cos(ang) * rx * 0.86, cy + math.sin(ang) * ry * 0.86, rx * 0.3, rx * 0.3))
    return parts


def head_parts(cx, cy, rx, ry):
    """Wide weasel head turned 3/4 to the left: skull, cream muzzle, two round ears."""
    skull = E(cx, cy, rx, ry)
    muzzle = E(cx - rx * 0.5, cy + ry * 0.38, rx * 0.52, ry * 0.42, -8)
    ear_l = E(cx - rx * 0.68, cy - ry * 0.8, rx * 0.36, rx * 0.36)
    ear_r = E(cx + rx * 0.58, cy - ry * 0.86, rx * 0.4, rx * 0.4)
    return skull, muzzle, (ear_l, (cx - rx * 0.68, cy - ry * 0.8, rx * 0.36)), (ear_r, (cx + rx * 0.58, cy - ry * 0.86, rx * 0.4))


def face(img, S, cx, cy, rx, ry, eye_w, nose=True, mouth="smile"):
    """Bright amber eyes, a dark nose and a small mouth, placed from the head's design-space geometry."""
    e1 = S.p([(cx - rx * 0.36, cy - ry * 0.08)])[0]
    e2 = S.p([(cx + rx * 0.22, cy - ry * 0.14)])[0]
    w = S.r(eye_w) * 0.62; h = w * 1.3
    bright_eye(img, e1[0], e1[1], w * 0.88, h)
    bright_eye(img, e2[0], e2[1], w, h)
    if nose:
        n = S.p([(cx - rx * 0.92, cy + ry * 0.22)])[0]
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(n[0], n[1], S.r(rx * 0.11) + 0.6, S.r(ry * 0.08) + 0.5, 16)]), 0.4, False), (40, 22, 20))
    m0 = S.p([(cx - rx * 0.78, cy + ry * 0.5), (cx - rx * 0.62, cy + ry * 0.6), (cx - rx * 0.45, cy + ry * 0.54)])
    paint(img, thin_line_mask(m0, 0.8), (90, 44, 30))


def inner_ears(img, S, ears, notch_ear=1):
    for i, (_, (x, y, r)) in enumerate(ears):
        m = to_mask(smooth_poly_mask([S.p(E(x + r * 0.08, y + r * 0.12, r * 0.52, r * 0.52))]), 0.45, False)
        paint(img, m, CREAM[1])


# ===============================================================================================
def wickit():
    """W1: sitting up, holding its glowing tail beside its face like a task lamp; a warm stone in its paws."""
    S = St(0.64, 90)
    hx, hy, rx, ry = 44, 34, 19, 16
    skull, muzzle, earL, earR = head_parts(hx, hy, rx, ry)
    tail = tube(bezier((58, 72), (82, 78), (84, 48), (70, 38), 26), [4.6, 5.2, 4.0])
    tuft = flame(68, 34, 6.2, lean=-0.25)
    holes = [notch_hole(S, earR[1][0] + 1.2, earR[1][1] - 1.5, 3.6)]
    layers = [
        Layer(S.ps([tail]), RUSSET, depth=3, outline=RUSSET_O),
        Layer([S.p(E(57, 79, 7.5, 3.6)), S.p(E(40, 79, 8.5, 3.8))], SOOT, depth=2, outline=SOOT_O),   # hind feet
        Layer([S.p(E(48, 63, 12.5, 15.5))], RUSSET, depth=6, outline=RUSSET_O),
        Layer([S.p(E(45, 65, 7.5, 11))], CREAM, depth=4, outline="none"),                            # belly
        Layer([S.p(earL[0]), S.p(earR[0])], RUSSET, depth=3, outline=RUSSET_O, holes=holes),
        Layer([S.p(skull)], RUSSET, depth=8, outline=RUSSET_O, cuts=(-0.1, 0.3, 0.72)),
        Layer([S.p(muzzle)], CREAM, depth=4, outline=CREAM_O),
        Layer([S.p(q) for q in paw(37, 58, 6.0, 5.0, -15) + paw(51, 59, 6.0, 5.0, 15)], SOOT, depth=3, outline=SOOT_O),   # big soot paws
        Layer([S.p(E(44, 51.5, 5.0, 4.0, -8))], CLAY, depth=2, outline=CLAY_O),                     # the warm stone, held up
        Layer([S.p(tuft)], EMBER, depth=4, outline=(150, 70, 14), cuts=(-0.3, 0.2, 0.6)),
    ]
    img = cleanup_clusters(compose(layers))
    inner_ears(img, S, [earL, earR])
    face(img, S, hx, hy, rx, ry, 3.6)
    paw_detail(img, S, 37, 58, 6.0, 5.0, -15); paw_detail(img, S, 51, 59, 6.0, 5.0, 15)
    # the stone glows faintly where the paws warm it; the tuft glows like a candle behind paper
    st = S.p([(42.5, 52.5)])[0]
    paint(img, {(int(st[0]), int(st[1])), (int(st[0]) + 1, int(st[1]))}, EMBER[1])
    glow(img, to_mask(smooth_poly_mask([S.p(E(44, 51.5, 5.0, 4.0, -8))]), 0.5, False), EMBER[1], 60)
    glow(img, layers[-1].mask, EMBER[2], 150)
    core = S.p(E(68, 33, 2.4, 2.8))
    paint(img, to_mask(smooth_poly_mask([core]), 0.4, False), EMBER[3])
    n = S.p([(earR[1][0] + 1, earR[1][1])])[0]
    notch(img, n[0], n[1])
    return F.finish(img, 90)


# ===============================================================================================
def stoketail():
    """S2: risen onto its hind legs to work with both paws; the paddle tail braced on the ground behind,
    a glowing seam along its underside. Ceramic guards above the wrists; one shoulder plate (still growing)."""
    S = St(0.84, 91)
    hx, hy, rx, ry = 40, 24, 13.5, 11.5
    skull, muzzle, earL, earR = head_parts(hx, hy, rx, ry)
    holes = [notch_hole(S, earR[1][0] + 1.0, earR[1][1] - 1.2, 3.0)]
    body = tube(bezier((44, 32), (45, 44), (48, 58), (52, 68), 22), [8.5, 10.0, 11.5])
    neck = tube([(42, 30), (44, 36)], [7.0, 8.0])
    arm_far = tube([(50, 40), (44, 50), (38, 54)], [4.2, 3.8, 3.6])
    arm_near = tube([(42, 40), (34, 47), (29, 50)], [4.8, 4.2, 4.0])
    leg_far = tube([(56, 66), (60, 80)], [5.0, 3.4])
    leg_near = tube([(48, 68), (45, 80)], [6.0, 3.8])
    tail = tube(bezier((56, 66), (70, 70), (78, 76), (82, 78), 22), [5.2, 4.6, 4.0])
    pad = E(86, 78, 12, 4.8, -2)
    layers = [
        Layer(S.ps([leg_far]), RUSSET, depth=3, outline=RUSSET_O),
        Layer([S.p(E(61, 81, 6, 3))], SOOT, depth=2, outline=SOOT_O),
        Layer(S.ps([tail]), RUSSET, depth=3, outline=RUSSET_O),
        Layer([S.p(pad)], RUSSET, depth=3, outline=RUSSET_O, cuts=(-0.1, 0.35, 0.7)),
        Layer(S.ps([arm_far]), RUSSET, depth=3, outline=RUSSET_O),
        Layer([S.p(q) for q in paw(36, 55, 5.0, 4.0, 60)], SOOT, depth=2, outline=SOOT_O),
        Layer(S.ps([body, neck]), RUSSET, depth=7, outline=RUSSET_O),
        Layer([S.p(E(43, 52, 5.5, 13, -8))], CREAM, depth=4, outline="none"),                         # chest and belly
        Layer(S.ps([leg_near]), RUSSET, depth=4, outline=RUSSET_O),
        Layer([S.p(E(44, 81, 7, 3.4))], SOOT, depth=2, outline=SOOT_O),
        Layer([S.p(E(53, 38, 9.0, 6.6, 25))], PORCELAIN, depth=3, outline=PORCELAIN_O, cuts=(-0.15, 0.3, 0.7)),  # the one shoulder plate
        Layer(S.ps([arm_near]), RUSSET, depth=3, outline=RUSSET_O),
        Layer([S.p(E(35.5, 46, 6.0, 4.4, -40)), S.p(E(43, 50, 4.4, 3.4, -30))], PORCELAIN, depth=2, outline=PORCELAIN_O),  # wrist guards
        Layer([S.p(q) for q in paw(27, 51, 5.6, 4.6, 70)], SOOT, depth=2, outline=SOOT_O),
        Layer([S.p(earL[0]), S.p(earR[0])], RUSSET, depth=3, outline=RUSSET_O, holes=holes),
        Layer([S.p(skull)], RUSSET, depth=7, outline=RUSSET_O, cuts=(-0.1, 0.3, 0.72)),
        Layer([S.p(muzzle)], CREAM, depth=4, outline=CREAM_O),
    ]
    img = cleanup_clusters(compose(layers))
    inner_ears(img, S, [earL, earR])
    face(img, S, hx, hy, rx, ry, 2.9)
    paw_detail(img, S, 27, 51, 5.6, 4.6, 70); paw_detail(img, S, 36, 55, 5.0, 4.0, 60)
    n = S.p([(earR[1][0] + 1, earR[1][1])])[0]
    notch(img, n[0], n[1])
    # the paddle: a glowing seam along its underside, and a few cooling sparks
    seam = S.p(bezier((76, 80.6), (82, 82), (90, 82), (97, 80), 16))
    ember_line(img, seam, 0.9)
    # dark joins between the guard panels
    for i in (10, 12):                                   # hand-painted blue on the white plates
        blue_and_white(img, layers[i].mask)
    for (x, y) in ((92, 70), (98, 74)):
        q = S.p([(x, y)])[0]
        paint(img, {(int(q[0]), int(q[1]))}, EMBER[3])
    return F.finish(img, 91)


# ===============================================================================================
def forgel():
    """F2: sitting tall like an otter at rest, one enormous glowing forepaw raised for a tiny adjustment;
    the heavy tail curled forward as its workbench, and on it the lopsided bowl it made as a Wickit."""
    S = St(1.0, 93)
    hx, hy, rx, ry = 40, 20, 12, 10
    skull, muzzle, earL, earR = head_parts(hx, hy, rx, ry)
    holes = [notch_hole(S, earR[1][0] + 0.8, earR[1][1] - 1.0, 2.6)]
    body = tube(bezier((44, 28), (44, 44), (48, 62), (54, 74), 24), [10.0, 13.5, 16.0])
    neck = tube([(41, 26), (44, 34)], [7.5, 9.5])
    arm_far = tube([(48, 40), (42, 52), (38, 58)], [5.2, 4.8, 4.4])
    arm_near = tube([(38, 36), (28, 40), (22, 34)], [6.2, 5.6, 5.0])
    tail = tube(bezier((62, 76), (86, 80), (80, 94), (40, 88), 28), [7.4, 6.8, 6.0])
    bench = E(32, 87, 13, 5.2, 1)
    shoulder = ribbon(bezier((45, 29), (54, 30), (60, 37), (60, 45), 16), 4.6, 3.6)
    hip = ribbon(bezier((58, 56), (64, 60), (66, 68), (64, 75), 16), 4.2, 3.4)
    layers = [
        Layer([S.p(q) for q in paw(64, 86, 9, 4.4, 0, toes_up=False)], SOOT, depth=2, outline=SOOT_O),   # far hind foot
        Layer(S.ps([tail]), RUSSET, depth=4, outline=RUSSET_O),
        Layer([S.p(bench)], IRON, depth=3, outline=COPPER[1], cuts=(-0.2, 0.25, 0.65)),               # the steel tail-end
        Layer(S.ps([arm_far]), RUSSET, depth=3, outline=RUSSET_O),
        Layer([S.p(q) for q in paw(36, 60, 6.5, 5.0, 80)], SOOT, depth=2, outline=SOOT_O),
        Layer(S.ps([body, neck]), RUSSET, depth=9, outline=RUSSET_O),
        Layer([S.p(E(45, 54, 6.5, 15, -6))], CREAM, depth=5, outline="none"),                          # chest and belly
        Layer([S.p(q) for q in paw(48, 85, 10, 5, 0, toes_up=False)], SOOT, depth=2, outline=SOOT_O),   # near hind foot
        Layer([S.p(shoulder), S.p(hip)], IRON, depth=4, outline=COPPER[1], cuts=(-0.2, 0.25, 0.65)),     # few, large plates
        Layer(S.ps([arm_near]), RUSSET, depth=4, outline=RUSSET_O),
        Layer([S.p(ribbon([(33, 39), (26, 40)], 4.0, 3.6))], IRON, depth=3, outline=COPPER[1]),          # forearm plate
        Layer([S.p(q) for q in paw(19, 31, 8.0, 6.8, -30)], SOOT, depth=4, outline=SOOT_O),              # the enormous raised paw
        Layer([S.p(earL[0]), S.p(earR[0])], RUSSET, depth=3, outline=RUSSET_O, holes=holes),
        Layer([S.p(skull)], RUSSET, depth=7, outline=RUSSET_O, cuts=(-0.1, 0.3, 0.72)),
        Layer([S.p(muzzle)], CREAM, depth=4, outline=CREAM_O),
        Layer([S.p(E(30, 81, 5.0, 3.0, -6))], CLAY, depth=2, outline=CLAY_O),                        # the little bowl
    ]
    img = cleanup_clusters(compose(layers))
    inner_ears(img, S, [earL, earR])
    face(img, S, hx, hy, rx, ry, 2.5)
    n = S.p([(earR[1][0] + 1, earR[1][1])])[0]
    notch(img, n[0], n[1])
    # furnace glow showing through the narrow gap between plate and fur
    ember_line(img, bezier((44, 33), (50, 34.5), (55, 39), (56, 46), 12), 0.8)
    # the blue painting of its porcelain days survives as a small cobalt inlay on the shoulder plate
    for (x, y, c) in ((54, 33, COBALT), (55, 33, COBALT_LT), (53, 33, COBALT_LT), (54, 32, COBALT_LT), (54, 34, COBALT_LT)):
        paint(img, {(x, y)}, c)
    # the small bright chest seam: Wickit's original ember
    seam = [(43, 44), (44, 48), (43, 52)]
    ember_line(img, seam, 0.9)
    # the raised paw, palm out, glowing at its pads for the delicate work
    paw_detail(img, S, 19, 31, 8.0, 6.8, -30, pads=EMBER[1])
    glow(img, layers[11].mask, EMBER[1], 70)
    paw_detail(img, S, 48, 85, 10, 5, 0, toes_up=False); paw_detail(img, S, 64, 86, 9, 4.4, 0, toes_up=False)
    # the bowl is lopsided and well loved: a dark hollow, a lighter rim, one glint
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(30.5, 79.6, 3.4, 1.2, 16)]), 0.4, False), CLAY_O)
    paint(img, thin_line_mask([(26.5, 78.6), (30, 78.2), (34, 79.2)], 0.8), CLAY[3])
    return F.finish(img, 93)


if __name__ == "__main__":
    s = Image.new("RGBA", (300, 100), (72, 80, 104, 255))
    for i, fn in enumerate((wickit, stoketail, forgel)):
        s.alpha_composite(fn(), (i * 100 + 2, 2))
    s.resize((900, 300), Image.NEAREST).save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/cinder1.png")
