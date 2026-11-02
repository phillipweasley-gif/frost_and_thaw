"""Alberica's instrument line from the concept sheet, the hand-shaped way (as for Wyn's line):
the painting is reduced to clean materials for the shading, then the parts that define each
creature - strings, rosette, bridge, f-holes, the spirit's face and paws, the harp-hat - are drawn
by hand from shapes traced on the sheet (sheet coordinates), one pixel wide and outlined."""
import numpy as np
import cv2
from PIL import Image
from scipy import ndimage as ndi
import from_sheet as F

ALB, BOX = F.ALB, F.ALB_BOX
SIZE = {"lutling": 72, "hauntello": 88, "chorumbra": 90}

INK = (40, 16, 44)
GOLD = [(122, 78, 22), (196, 144, 40), (240, 198, 78), (255, 238, 160)]
GHOST = [(74, 40, 120), (130, 86, 196), (182, 142, 238), (226, 204, 255)]
GHOST_INK = (52, 22, 84)
HOLE = (34, 14, 44)


def alb_classify(src, fg):
    """line, wood (the instrument's own colour), board (the lute's pale soundboard), dark (neck,
    fingerboard, bridge), gold, ghost (the spirit)."""
    hsv = cv2.cvtColor(np.ascontiguousarray(src), cv2.COLOR_RGB2HSV).astype(int)
    H, S, V = hsv[..., 0], hsv[..., 1], hsv[..., 2]
    lum = src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
    names = ["line", "wood", "board", "dark", "gold", "ghost"]
    mat = np.full(fg.shape, 1, int)
    mat[(V >= 200) & (S < 125) & (H >= 12) & (H <= 34)] = 2
    mat[(V < 140) & ~((H >= 110) & (H <= 165))] = 3
    mat[(H >= 18) & (H <= 34) & (S >= 125) & (V >= 165)] = 4
    mat[(H >= 110) & (H <= 165) & (S >= 35) & (V >= 90)] = 5
    mat[lum < 50] = 0
    mat[~fg] = -1
    return mat, names


# ------------------------------------------------------------------ drawing in sprite space
def raster_line(P):
    pts = []
    for (x0, y0), (x1, y1) in zip(P, P[1:]):
        n = int(max(abs(x1 - x0), abs(y1 - y0)) * 2) + 1
        for i in range(n + 1):
            t = i / n
            q = (int(np.floor(x0 + (x1 - x0) * t)), int(np.floor(y0 + (y1 - y0) * t)))
            if not pts or pts[-1] != q:
                pts.append(q)
    keep = set(pts)
    for (x, y) in pts:                                    # pixel-perfect: no doubled corners
        for (ax, ay), (bx, by) in (((-1, 0), (0, -1)), ((1, 0), (0, -1)), ((-1, 0), (0, 1)), ((1, 0), (0, 1))):
            if (x + ax, y + ay) in keep and (x + bx, y + by) in keep and (x + ax + bx, y + ay + by) not in keep:
                keep.discard((x, y))
                break
    return [p for p in pts if p in keep]


def put(img, p, c):
    x, y = p
    if 0 <= x < img.width and 0 <= y < img.height:
        img.putpixel((x, y), tuple(int(v) for v in c[:3]) + (255,))


def line(img, T, pts, col, only_opaque=False, skip=None):
    px = img.load()
    for p in raster_line([T(*q) for q in pts]):
        if skip is not None and skip(p):
            continue
        if only_opaque and not (0 <= p[0] < img.width and 0 <= p[1] < img.height and px[p][3]):
            continue
        put(img, p, col)


def mask_poly(img, T, pts):
    from PIL import ImageDraw
    m = Image.new("L", img.size, 0)
    ImageDraw.Draw(m).polygon([T(*q) for q in pts], fill=1)
    return np.asarray(m).astype(bool)


def mask_ellipse(img, cx, cy, rx, ry):
    yy, xx = np.mgrid[0:img.height, 0:img.width]
    return ((xx + 0.5 - cx) / rx) ** 2 + ((yy + 0.5 - cy) / ry) ** 2 <= 1.0


def edge_of(m):
    return m & ~ndi.binary_erosion(m)


def paint(img, m, col):
    a = np.asarray(img).copy()
    a[m, :3] = col[:3]
    a[m, 3] = 255
    img.paste(Image.fromarray(a, "RGBA"))


def shade_fill(img, m, ramp, light=(-1, -1), outline=None, lit_outline=None):
    """Fill a mask with a ramp lit from `light` (upper-left by default): bands by position across the shape."""
    ys, xs = np.nonzero(m)
    if not len(ys):
        return
    cx, cy = xs.mean(), ys.mean()
    rx, ry = max(1, xs.max() - xs.min()) / 2, max(1, ys.max() - ys.min()) / 2
    a = np.asarray(img).copy()
    v = ((xs - cx) / rx * light[0] + (ys - cy) / ry * light[1]) / 2       # -1 dark side ... +1 lit side
    n = len(ramp)
    idx = np.clip(((v + 0.6) / 1.2 * n).astype(int), 0, n - 1)
    for k in range(n):
        sel = idx == k
        a[ys[sel], xs[sel], :3] = ramp[k][:3]
    a[ys, xs, 3] = 255
    img.paste(Image.fromarray(a, "RGBA"))
    if outline is not None:
        e = edge_of(m)
        if lit_outline is not None:
            up = e & ~np.roll(m, 1, 0)                                      # top edges
            paint(img, e & ~up, outline)
            paint(img, up, lit_outline)
        else:
            paint(img, e, outline)


EYE_T = {  # K ink lid, D dark iris, M lighter lower iris, W glint, . leave
    3: ["KKK", "WDD", "DDD", "MMD"],
    4: [".KK.", "KWDD", "DDDD", "DMMD", ".DD."],
    5: [".KKK.", "KWWDD", "DWDDD", "DDDDD", "DMMMD", ".DDD."],
}


def eye_t(img, cx, cy, size, flip=False, iris=(36, 10, 46), mid=(128, 60, 150)):
    """A cute cartoon eye from a pixel template (as a sprite artist would place it)."""
    t = EYE_T[size]
    h, w = len(t), len(t[0])
    x0, y0 = int(round(cx - w / 2)), int(round(cy - h / 2))
    col = {"K": INK, "D": iris, "M": mid, "W": (255, 255, 255)}
    for j, row in enumerate(t):
        for i, ch in enumerate(row[::-1] if flip else row):
            if ch in col:
                put(img, (x0 + i, y0 + j), col[ch])


def eye(img, cx, cy, w, h, iris=(70, 24, 84), mid=(150, 80, 170), look=(0, 0)):
    """A big, cute cartoon eye: dark iris with a lighter lower crescent, a bold upper lid and a
    white glint up and to the left."""
    m = mask_ellipse(img, cx, cy, w / 2, h / 2)
    ys, xs = np.nonzero(m)
    a = np.asarray(img).copy()
    for (y, x) in zip(ys, xs):
        a[y, x, :3] = iris
        a[y, x, 3] = 255
        if y + 0.5 > cy + h * 0.12 and abs(x + 0.5 - cx) < w * 0.35:
            a[y, x, :3] = mid
    top = ys.min()
    for x in set(xs):
        yt = ys[xs == x].min()
        a[yt, x, :3] = INK
    img.paste(Image.fromarray(a, "RGBA"))
    gx, gy = int(cx - w * 0.22 + look[0]), int(top + 1 + look[1])
    put(img, (gx, gy), (255, 255, 255))
    if w >= 4 and h >= 4:
        put(img, (gx + 1, gy), (255, 255, 255))
        put(img, (gx, gy + 1), (255, 255, 255))
        put(img, (int(cx + w * 0.2), int(cy + h * 0.25)), (255, 255, 255))


MOUTH_T = {"open": ["DWDDD", "DPPPD", ".DDD."], "grin": ["DWDWDD", ".DPPD."], "smile": ["D...D", ".DDD."]}


def mouth_t(img, cx, cy, kind="open", flip=False):
    t = MOUTH_T[kind]
    h, w = len(t), len(t[0])
    x0, y0 = int(round(cx - w / 2)), int(round(cy - h / 2))
    col = {"D": (44, 12, 40), "P": (238, 120, 156), "W": (255, 255, 255)}
    for j, row in enumerate(t):
        for i, ch in enumerate(row[::-1] if flip else row):
            if ch in col:
                put(img, (x0 + i, y0 + j), col[ch])


def open_mouth(img, cx, cy, w, h, ink=GHOST_INK, tongue=(238, 120, 156)):
    m = mask_ellipse(img, cx, cy, w / 2, h / 2)
    paint(img, m, HOLE)
    ys, xs = np.nonzero(m)
    if len(ys):
        low = m & (np.mgrid[0:img.height, 0:img.width][0] >= ys.max())
        low &= mask_ellipse(img, cx, cy, w / 2 - 0.6, h / 2)
        paint(img, low, tongue)
        put(img, (int(cx - w / 2 + 1), int(ys.min())), (255, 255, 255))   # a little fang


# ------------------------------------------------------------------ Lutling
def outline_all(img, col, lit=None):
    """A clean 1px outline on the silhouette: dark everywhere, a little lighter on the lit top-left."""
    a = np.asarray(img)
    op = a[..., 3] > 0
    e = op & ~ndi.binary_erosion(op, border_value=0)
    if lit is not None:
        up = e & ~np.vstack([np.zeros((1, op.shape[1]), bool), op[:-1]])
        left = e & ~np.hstack([np.zeros((op.shape[0], 1), bool), op[:, :-1]])
        paint(img, e & ~(up | left), col)
        paint(img, (up | left), lit)
    else:
        paint(img, e, col)


def spirit_face(img, cx, cy, R, s, eyes, mouth, paws, T):
    """The little spirit peeking out of a soundhole: a round lavender head filling the lower hole,
    big eyes, an open grin, two paws hooked over the rim."""
    hole_m = mask_ellipse(img, cx, cy, R, R)
    paint(img, hole_m, HOLE)
    head = mask_ellipse(img, cx, cy + R * 0.2, R * 1.0, R * 0.98) & hole_m
    shade_fill(img, head, GHOST[1:])
    paint(img, head & ~np.roll(head, 1, 0), GHOST_INK)               # the crown of the head against the dark
    for (ex, ey, size) in eyes:
        X, Y = T(ex, ey)
        eye_t(img, X, Y, size)
    mx, my, kind = mouth
    X, Y = T(mx, my)
    mouth_t(img, X, Y, kind)
    for (px_, py_, rx, ry) in paws:
        X, Y = T(px_, py_)
        pm = mask_ellipse(img, X, Y, rx, ry)
        shade_fill(img, pm, GHOST[2:], outline=GHOST_INK)
        put(img, (int(X), int(Y + ry - 0.5)), GHOST_INK)


def lutling_post(tones):
    def post(img, T, s):
        outline_all(img, (78, 40, 18), (128, 74, 30))
        cx, cy = T(227, 470)
        R_out, R_hole = 64 * s, 40 * s
        hole_zone = mask_ellipse(img, cx, cy, R_out * 0.95, R_out * 0.95)
        inz = lambda p: 0 <= p[0] < img.width and 0 <= p[1] < img.height and hole_zone[p[1], p[0]]
        # bridge
        bm = mask_poly(img, T, [(181, 541), (238, 545), (238, 562), (181, 558)])
        shade_fill(img, bm, [(96, 52, 26), (140, 86, 44)], outline=(54, 26, 14))
        # strings: bridge -> nut (darker gold on the pale board), then up the dark neck in light gold
        for bxx, nx in zip((196, 210, 224), (243, 256, 269)):
            line(img, T, [(bxx, 545), (nx, 352)], (150, 98, 30), skip=inz)
        for nx in (247, 265):
            line(img, T, [(nx, 352), (nx + 36, 262)], GOLD[2])
        # nut
        line(img, T, [(234, 352), (278, 352)], GOLD[0])
        # rosette: a petalled gold ring around the hole
        petals = np.zeros(img.size[::-1], bool)
        for k in range(10):
            a = np.radians(k * 36 + 18)
            petals |= mask_ellipse(img, cx + np.cos(a) * R_out * 0.8, cy + np.sin(a) * R_out * 0.8, R_out * 0.28, R_out * 0.28)
        ring = mask_ellipse(img, cx, cy, R_out * 0.84, R_out * 0.84) | petals
        shade_fill(img, ring, GOLD[1:3], outline=GOLD[0])
        paint(img, mask_ellipse(img, cx, cy, R_hole + 1.2, R_hole + 1.2), GOLD[0])
        INFO["lutling"] = dict(cx=cx, cy=cy, r_hole=R_hole, r_out=R_out)
        if OPTS["spirit"]:
            spirit_face(img, cx, cy, R_hole, s,
                        eyes=[(211, 462, 4), (251, 465, 4)],
                        mouth=(231, 492, "open"),
                        paws=[(186, 500, 2.6, 2.0), (266, 502, 2.6, 2.0)], T=T)
        else:
            paint(img, mask_ellipse(img, cx, cy, R_hole, R_hole), HOLE)
        # the scroll: a dark curl with one lit turn
        X, Y = T(300, 229)
        sm = mask_ellipse(img, X, Y, 17 * s, 15 * s)
        shade_fill(img, sm, [(70, 36, 18), (112, 62, 30), (150, 92, 46)], outline=(40, 18, 10))
        put(img, (int(X), int(Y)), (40, 18, 10)); put(img, (int(X) + 1, int(Y)), (40, 18, 10))
        # gold pegs
        for (gx, gy) in ((341, 227), (337, 263)):
            X, Y = T(gx, gy)
            shade_fill(img, mask_ellipse(img, X, Y, 2.0, 1.7), GOLD[2:], outline=GOLD[0])
    return post


# ------------------------------------------------------------------ Hauntello
EYE_T[("sly", 4)] = ["K...", "KKKK", "KWDD", "DDMD", ".DD."]


def eye_sly(img, cx, cy, flip=False):
    t = EYE_T[("sly", 4)]
    h, w = len(t), len(t[0])
    x0, y0 = int(round(cx - w / 2)), int(round(cy - h / 2))
    col = {"K": INK, "D": (36, 10, 46), "M": (150, 40, 90), "W": (255, 255, 255)}
    for j, row in enumerate(t):
        r = row[::-1] if flip else row
        for i, ch in enumerate(r):
            if ch in col:
                put(img, (x0 + i, y0 + j), col[ch])


def fold_colour(img, sel, keep):
    """Pixels picked by `sel` (outside `keep`) take the nearest colour that isn't picked."""
    a = np.asarray(img).copy()
    rgb = a[..., :3].astype(int)
    op = a[..., 3] > 0
    bad = op & sel(rgb) & ~keep
    good = op & ~sel(rgb) & ~keep
    if not good.any() or not bad.any():
        return
    idx = ndi.distance_transform_edt(~good, return_distances=False, return_indices=True)
    ys, xs = np.nonzero(bad)
    a[ys, xs] = a[idx[0][ys, xs], idx[1][ys, xs]]
    img.paste(Image.fromarray(a, "RGBA"))


def despeck(img, dark=70):
    """Painted texture lines (wood figuring, brush marks) leave lone dark pixels in the reduction: each
    dark pixel with at most one dark neighbour takes the most common neighbouring colour."""
    a = np.asarray(img).copy()
    rgb = a[..., :3].astype(int)
    op = a[..., 3] > 0
    lum = rgb @ np.array([0.3, 0.59, 0.11])
    D = op & (lum < dark)
    H_, W_ = D.shape
    out = a.copy()
    for (y, x) in zip(*np.nonzero(D)):
        nb = [(y + dy, x + dx) for dy in (-1, 0, 1) for dx in (-1, 0, 1) if (dy or dx) and 0 <= y + dy < H_ and 0 <= x + dx < W_]
        if any(not op[q] for q in nb):
            continue                                   # silhouette outline stays
        if sum(D[q] for q in nb) <= 1:
            cols = [tuple(a[q]) for q in nb if not D[q]]
            out[y, x] = max(set(cols), key=cols.count)
    img.paste(Image.fromarray(out, "RGBA"))


def beaded_string(img, T, pts, bead=True):
    line(img, T, pts, GOLD[2])
    if bead:
        globals()["bead"](img, *T(*pts[-1]))


def hauntello_post(tones):
    def post(img, T, s):
        despeck(img)
        outline_all(img, (64, 16, 14), (120, 40, 30))
        cx, cy = T(738, 426)
        R_out = 76 * s
        # ghost masks (hand-traced): head with two ear points, the reaching arm and hand, the right paw
        Z = lambda pts, k=1.18, c=(738, 428): [(c[0] + (x - c[0]) * k, c[1] + (y - c[1]) * k) for (x, y) in pts]
        head = mask_poly(img, T, Z([(694, 404), (697, 384), (706, 392), (720, 382), (740, 378), (760, 382), (774, 372),
                                    (778, 392), (784, 412), (782, 440), (772, 462), (752, 472), (726, 472), (706, 462),
                                    (695, 444), (692, 424)]))
        arm = mask_poly(img, T, [(700, 402), (684, 390), (664, 372), (648, 362), (630, 360), (616, 366), (608, 378),
                                 (606, 396), (612, 404), (616, 392), (622, 386), (626, 400), (632, 402), (634, 390),
                                 (644, 386), (660, 396), (690, 420)])
        paw = mask_ellipse(img, *T(781, 479), 19 * s, 12 * s)
        ghost = head | arm | paw
        if not OPTS["spirit"]:                             # no spirit: the hand reaching past the edge goes
            a_ = np.asarray(img).copy()
            hx0 = int(T(630, 0)[0])
            cut = arm.copy(); cut[:, hx0:] = False
            a_[cut] = 0
            img.paste(Image.fromarray(a_, "RGBA"))
        fold_colour(img, lambda c: (c[..., 2] > c[..., 1] + 30), keep=np.zeros_like(ghost))
        if not OPTS["spirit"]:
            outline_all(img, (64, 16, 14), (120, 40, 30))
        ys_, xs_ = np.nonzero(head | mask_ellipse(img, cx, cy, R_out, R_out))
        INFO["hauntello"] = dict(cx=cx, cy=cy, r_out=R_out, box=(int(xs_.min()), int(ys_.min()), int(xs_.max()) + 1, int(ys_.max()) + 1))
        # the smashed hole: dark, ringed with an orange-gold rosette, cracks running down
        petals = np.zeros(img.size[::-1], bool)
        for k in range(10):
            a_ = np.radians(k * 36)
            petals |= mask_ellipse(img, cx + np.cos(a_) * R_out * 0.82, cy + np.sin(a_) * R_out * 0.82, R_out * 0.24, R_out * 0.24)
        ring = mask_ellipse(img, cx, cy, R_out * 0.85, R_out * 0.85) | petals
        shade_fill(img, ring, [(214, 120, 40), (244, 170, 70)], outline=(110, 50, 16))
        INFO["hauntello"]["mask"] = head | ring
        hole = mask_ellipse(img, cx, cy, R_out * 0.66, R_out * 0.66)
        paint(img, hole, HOLE)
        line(img, T, [(776, 486), (782, 512), (776, 538), (788, 566)], INK, only_opaque=True)
        # f-holes
        line(img, T, [(642, 360), (634, 378), (630, 420), (627, 462), (616, 488)], INK, only_opaque=True)
        line(img, T, [(812, 344), (826, 362), (834, 410), (837, 462), (830, 504)], INK, only_opaque=True)
        for (fx, fy) in ((646, 360), (612, 490), (808, 342), (826, 508)):
            X, Y = T(fx, fy)
            put(img, (int(X), int(Y)), INK)
        # fingerboard
        fb = mask_poly(img, T, [(730, 312), (778, 314), (846, 110), (814, 104)])
        shade_fill(img, fb, [(30, 22, 24), (58, 44, 44)], outline=(18, 10, 12))
        # strings (not across the face)
        no = ndi.binary_dilation(hole | ghost, iterations=1)
        skip = lambda p: 0 <= p[0] < img.width and 0 <= p[1] < img.height and no[p[1], p[0]]
        for b0, m0, t0 in (((696, 586), (744, 305), (820, 106)), ((708, 586), (764, 305), (838, 106))):
            line(img, T, [b0, m0, t0], (214, 166, 70), skip=skip)
        # the spirit
        if OPTS["spirit"]:
            shade_fill(img, arm, GHOST[1:], outline=GHOST_INK)
            shade_fill(img, head, GHOST[1:], outline=GHOST_INK)
            shade_fill(img, paw, GHOST[2:], outline=GHOST_INK)
            X, Y = T(781, 484)
            put(img, (int(X), int(Y)), GHOST_INK)
            eye_sly(img, *T(*Z([(706, 423)])[0]))
            eye_sly(img, *T(*Z([(759, 420)])[0]), flip=True)
            mouth_t(img, *T(*Z([(732, 452)])[0]), "grin")
        # scroll and pegs
        X, Y = T(860, 45)
        INFO["hauntello"]["scroll"] = (X, Y, 26 * s)
        INFO["hauntello"]["neck"] = (T(754, 300), T(830, 105))
        shade_fill(img, mask_ellipse(img, X, Y, 24 * s, 26 * s), [(96, 26, 20), (150, 50, 34), (196, 86, 58)], outline=(54, 12, 10))
        put(img, (int(X), int(Y)), (54, 12, 10))
        for (gx, gy) in ((808, 72), (900, 62), (796, 92), (888, 96)):
            X, Y = T(gx, gy)
            shade_fill(img, mask_ellipse(img, X, Y, 1.8, 1.6), GOLD[2:], outline=GOLD[0])
        # loose strings with gold beads
        beaded_string(img, T, [(690, 272), (640, 285), (600, 312), (575, 355), (566, 410)])
        beaded_string(img, T, [(598, 322), (574, 380), (562, 440), (560, 476)])
        beaded_string(img, T, [(850, 110), (900, 128), (938, 186), (934, 236), (906, 272), (872, 288)], bead=False)
        beaded_string(img, T, [(866, 470), (888, 520), (894, 565), (882, 598)])
    return post


# ------------------------------------------------------------------ Chorumbra
LACQ = [(58, 16, 30), (98, 32, 48), (140, 54, 66), (180, 86, 92)]


def bead(img, X, Y):
    x, y = int(X), int(Y)
    for (dx, dy, c) in ((0, 0, GOLD[3]), (1, 0, GOLD[2]), (0, 1, GOLD[2]), (1, 1, GOLD[1])):
        put(img, (x + dx, y + dy), c)


def interp_y(edge, x):
    xs, ys = zip(*edge)
    return float(np.interp(x, xs, ys))


def chorumbra_post(tones):
    def post(img, T, s):
        despeck(img)
        a0 = np.asarray(img)
        body_op = a0[..., 3] > 0
        behind = lambda p: 0 <= p[0] < img.width and 0 <= p[1] < img.height and body_op[p[1], p[0]]
        outline_all(img, (46, 18, 56), (96, 60, 132))
        # hanging gold strands, behind the body, each ending in a bead
        for st in ([(1188, 252), (1168, 330), (1122, 420), (1104, 540)],
                   [(1204, 258), (1186, 340), (1140, 430), (1050, 498)],
                   [(1180, 250), (1110, 320), (1030, 420), (1004, 452)],
                   [(1312, 262), (1334, 330), (1376, 420), (1394, 552)],
                   [(1330, 256), (1372, 320), (1440, 396), (1488, 458)],
                   [(1300, 268), (1318, 360), (1346, 450), (1380, 508)]):
            line(img, T, st, GOLD[2], skip=behind)
            bead(img, *T(*st[-1]))
        # the harp: pillar, curved neck, soundbox hat
        neck_top = [(1146, 34), (1200, 50), (1262, 80), (1322, 106), (1386, 122), (1414, 140)]
        neck_bot = [(1150, 58), (1196, 72), (1256, 100), (1318, 126), (1378, 144), (1406, 160)]
        hat_top = [(1162, 228), (1220, 206), (1280, 184), (1330, 164), (1380, 146)]
        neck = mask_poly(img, T, neck_top + neck_bot[::-1])
        pillar = mask_poly(img, T, [(1136, 14), (1162, 14), (1168, 232), (1146, 236)])
        hat = mask_poly(img, T, [(1158, 236), (1164, 222), (1220, 204), (1280, 182), (1330, 162), (1384, 144), (1404, 160),
                                 (1376, 186), (1362, 226), (1344, 262), (1300, 252), (1250, 240), (1206, 244), (1170, 252)])
        # strings first (the frame is drawn over their ends)
        for x in range(1176, 1320, 18):
            y0 = interp_y(neck_bot, x) - 2
            y1 = interp_y(hat_top, x) + 2
            line(img, T, [(x, y0), (x, y1)], GOLD[2])
        shade_fill(img, neck, LACQ, light=(0, -1), outline=LACQ[0][:3] if False else (36, 8, 20))
        shade_fill(img, pillar, LACQ, light=(-1, 0), outline=(36, 8, 20))
        for (yy0, yy1) in ((38, 52), (88, 100)):
            band = mask_poly(img, T, [(1134, yy0), (1166, yy0), (1166, yy1), (1134, yy1)])
            shade_fill(img, band, GOLD[1:], light=(-1, 0), outline=GOLD[0])
        shade_fill(img, hat, LACQ, outline=(36, 8, 20))
        line(img, T, [(1166, 232), (1222, 212), (1282, 190), (1334, 170), (1386, 152)], GOLD[2])   # gold trim
        line(img, T, [(1172, 246), (1210, 238), (1252, 234), (1300, 246), (1342, 256)], GOLD[1])
        # rosette
        X, Y = T(1330, 196)
        ros = mask_ellipse(img, X, Y, 24 * s, 24 * s)
        shade_fill(img, ros, GOLD[1:], outline=GOLD[0])
        put(img, (int(X), int(Y)), (36, 8, 20))
        # pegs at the neck's tip
        for (gx, gy) in ((1392, 112), (1414, 122), (1424, 144), (1410, 166)):
            X, Y = T(gx, gy)
            shade_fill(img, mask_ellipse(img, X, Y, 1.6, 1.5), GOLD[2:], outline=GOLD[0])
        X, Y = T(1150, 14)
        shade_fill(img, mask_ellipse(img, X, Y, 2.0, 1.8), GOLD[2:], outline=GOLD[0])
        # face
        eye_t(img, *T(1226, 277), 4)
        eye_t(img, *T(1278, 268), 4, flip=True)
        mouth_t(img, *T(1258, 294), "smile")
        # what the fusions need: the hat as its own layer, and where the face is
        hat_all = neck | pillar | hat | mask_poly(img, T, neck_bot + hat_top[::-1])
        for (gx, gy) in ((1392, 112), (1414, 122), (1424, 144), (1410, 166), (1150, 14)):
            X, Y = T(gx, gy)
            hat_all |= mask_ellipse(img, X, Y, 2.2, 2.0)
        hat_all = ndi.binary_dilation(hat_all, iterations=1)
        a_ = np.asarray(img).copy()
        a_[~hat_all] = 0
        fx, fy = T(1252, 282)
        ys_, xs_ = np.nonzero(hat_all)
        INFO["chorumbra"] = dict(hat=Image.fromarray(a_, "RGBA"), cx=fx, cy=fy, rx=50 * s, ry=40 * s,
                                 box=(int(min(xs_.min(), T(1196, 0)[0])), int(ys_.min()), int(max(xs_.max() + 1, T(1310, 0)[0])),
                                      int(T(0, 312)[1])))
    return post


OPTS = {"spirit": True}
INFO = {}

POST = {"lutling": lutling_post, "hauntello": hauntello_post, "chorumbra": chorumbra_post}
STYLE = {"lutling": dict(simplify=1.6, smooth=3.0, n=3), "hauntello": dict(simplify=1.6, smooth=3.0, n=3),
         "chorumbra": dict(simplify=1.4, smooth=2.5, n=3)}


def alb2(name, size=None, ground=92, canvas=96):
    st = STYLE.get(name, {})
    x0, y0, x1, y1 = BOX[name]
    src = np.asarray(Image.open(ALB).convert("RGB"))[y0:y1, x0:x1]
    fg = F.cut_main(src)
    tones = F.concept_tones(src, fg, alb_classify, n=st.get("n", 3))
    tones = {k: v for k, v in tones.items() if v and not any(np.isnan(np.array(c)).any() for c in v)}
    return F.reduce_semantic(src, fg, size or SIZE[name], alb_classify, tones, ground=ground, canvas=canvas,
                             simplify=st.get("simplify", 1.4), smooth=st.get("smooth", 2.5), inner_lines=False,
                             guide_box=(x0, y0), post=POST[name](tones) if name in POST else None)


def export_parts(out="/home/claude/frost-thaw/build/alb_parts"):
    """Everything the fusion generator needs from the new designs: each instrument without its spirit
    (the partner's head goes in), the face pieces (for Alberica's line as the head of another body),
    Chorumbra's harp-hat as its own layer, and where the hole/face sits."""
    import json, os
    os.makedirs(out, exist_ok=True)
    info = {}
    for n, key in (("lutling", "LUTLING"), ("hauntello", "HAUNTELLO"), ("chorumbra", "CHORUMBRA")):
        OPTS["spirit"] = True
        full = alb2(n)
        I = dict(INFO[n])
        OPTS["spirit"] = False
        body = alb2(n)
        OPTS["spirit"] = True
        body.save(f"{out}/{key}_body.png")
        if n == "lutling":
            r = I["r_out"] + 1
            box = (int(I["cx"] - r), int(I["cy"] - r), int(I["cx"] + r) + 1, int(I["cy"] + r) + 1)
            face_c = (I["cx"] - box[0], I["cy"] - box[1]); face_w = 2 * r
        elif n == "hauntello":
            box = I["box"]
            face_c = (I["cx"] - box[0], I["cy"] - box[1]); face_w = box[2] - box[0]
        else:
            box = I["box"]
            I["hat"].save(f"{out}/{key}_hat.png")
            face_c = (I["cx"] - box[0], I["cy"] - box[1]); face_w = 2 * I["rx"]
        piece = np.asarray(full.crop(box)).copy()
        if n == "lutling":
            yy, xx = np.mgrid[0:piece.shape[0], 0:piece.shape[1]]
            keep = (xx + 0.5 - face_c[0]) ** 2 + (yy + 0.5 - face_c[1]) ** 2 <= (I["r_out"] * 1.08) ** 2
        elif n == "hauntello":
            keep = I["mask"][box[1]:box[3], box[0]:box[2]]
        else:
            keep = np.ones(piece.shape[:2], bool)
        piece[~keep] = 0
        Image.fromarray(piece, "RGBA").save(f"{out}/{key}_face.png")
        info[key] = {k: (float(v) if not isinstance(v, (tuple, list, Image.Image, np.ndarray)) else v) for k, v in I.items()
                     if k not in ("hat", "mask")}
        info[key].update(face_box=list(box), face_c=[float(face_c[0]), float(face_c[1])], face_w=float(face_w))
    json.dump(info, open(f"{out}/info.json", "w"), indent=1)
    return info


if __name__ == "__main__":
    print(export_parts())
