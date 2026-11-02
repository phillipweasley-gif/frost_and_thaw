"""The Alberica fusions traced from the user's own illustrations (build/concept/merge_examples_*.png), so each
sprite keeps the drawing's composition and proportions.

  1. Materials are picked by sampling the painting itself: every material is named with a few sheet points
     where it occurs, and each painted pixel goes to the nearest sample colour (LAB).
     'drop' materials (paper, flowers, leaves, ground, floating notes) are cut out before reduction.
  2. from_sheet.reduce_semantic reduces the result to a 96px sprite with clean shading bands and an outline.
  3. Whatever has to read at sprite size is drawn crisply on top, in sheet coordinates: soundhole roses,
     strings, f-holes, scrolls, harp frames, gem eyes, mouths."""
import math
import numpy as np
import cv2
from PIL import Image
from scipy import ndimage as ndi
import from_sheet as F
from merge_sheet import punch

SHEET = {k: f"/home/claude/frost-thaw/build/concept/merge_examples_{k}.png" for k in range(1, 9)}
_IMG = {}


def sheet(k):
    if k not in _IMG:
        _IMG[k] = np.asarray(Image.open(SHEET[k]).convert("RGB"))
    return _IMG[k]


def sample(img, pts, r=3):
    out = []
    for (x, y) in pts:
        out.append(np.median(img[y - r:y + r + 1, x - r:x + r + 1].reshape(-1, 3), 0))
    return out


def lab(rgb):
    return cv2.cvtColor(np.ascontiguousarray(rgb.reshape(-1, 1, 3).astype(np.uint8)), cv2.COLOR_RGB2LAB).reshape(-1, 3).astype(np.float32)


# ------------------------------------------------------------------------------------------- pixel drawing
def P(img):
    return img.load()


def put(img, x, y, c, only_on=True):
    x, y = int(round(x)), int(round(y))
    if 0 <= x < img.width and 0 <= y < img.height:
        px = img.load()
        if only_on and px[x, y][3] == 0:
            return
        px[x, y] = tuple(int(v) for v in c[:3]) + (255,)


def line(img, p0, p1, c, only_on=True, skip=None):
    (x0, y0), (x1, y1) = p0, p1
    n = int(max(abs(x1 - x0), abs(y1 - y0))) + 1
    for i in range(n + 1):
        t = i / max(n, 1)
        x, y = x0 + (x1 - x0) * t, y0 + (y1 - y0) * t
        if skip and skip(int(round(x)), int(round(y))):
            continue
        put(img, x, y, c, only_on)


def disc(img, cx, cy, r, c, only_on=False):
    for y in range(int(cy - r - 1), int(cy + r + 2)):
        for x in range(int(cx - r - 1), int(cx + r + 2)):
            if (x + 0.5 - cx) ** 2 + (y + 0.5 - cy) ** 2 <= r * r:
                put(img, x, y, c, only_on)


def ring(img, cx, cy, r, c, only_on=True, w=1.0):
    for y in range(int(cy - r - 2), int(cy + r + 3)):
        for x in range(int(cx - r - 2), int(cx + r + 3)):
            d = math.hypot(x + 0.5 - cx, y + 0.5 - cy)
            if r - w <= d <= r:
                put(img, x, y, c, only_on)


ROSE_INK = (40, 22, 16)
GOLDS = [(122, 78, 22), (196, 144, 40), (240, 198, 78), (255, 238, 160)]
STR = (250, 236, 186)


def rose(img, cx, cy, r, ink=ROSE_INK, hub=GOLDS[2], face=None):
    """A soundhole rose: a dark ring with a lattice inside - spokes and a gold hub - legible down to r=3."""
    r = max(2.6, r)
    if face is not None:
        disc(img, cx, cy, r + 0.6, face, only_on=True)
    ring(img, cx, cy, r, ink, w=1.05)
    for k in range(8 if r >= 3.5 else 4):
        a = k * math.pi / (4 if r >= 3.5 else 2) + math.pi / 8
        for t in np.linspace(0.35, 0.9, 4):
            put(img, cx + math.cos(a) * r * t - 0.5, cy + math.sin(a) * r * t - 0.5, ink)
    if r >= 3.5:
        ring(img, cx, cy, r * 0.55, ink, w=0.8)
    put(img, cx - 0.5, cy - 0.5, hub)


def fhole(img, x, y, h, ink=(36, 14, 10), mirror=False):
    """A cello f-hole, h pixels tall: a stem with a dot at each end, the ends turned out."""
    h = max(4, int(round(h)))
    d = -1 if mirror else 1
    for i in range(h):
        put(img, x + (0 if 0 < i < h - 1 else (d if i == 0 else -d)), y + i, ink)
    put(img, x - 1 * d, y + 1, ink) if h >= 6 else None
    put(img, x + 1 * d, y + h - 2, ink) if h >= 6 else None


def spiral(img, cx, cy, r, ramp, ink=(40, 14, 10)):
    """A cello scroll seen from the side: a round head in the wood with a spiral line."""
    disc(img, cx, cy, r, ramp[2])
    disc(img, cx - r * 0.3, cy - r * 0.3, r * 0.45, ramp[3])
    ring(img, cx, cy, r + 0.9, ink, only_on=False, w=1.0)
    for t in np.linspace(0, 1.6 * math.pi, 14):
        rr = r * (0.75 - 0.4 * t / (1.6 * math.pi))
        put(img, cx + math.cos(t) * rr - 0.5, cy + math.sin(t) * rr - 0.5, ink)




def eye(img, cx, cy, iris, h=4, w=2, ink=(24, 16, 20)):
    """A small sprite eye: dark rim on top and sides, the iris below, a white glint upper-left."""
    x0, y0 = int(round(cx - w / 2)), int(round(cy - h / 2))
    for dy in range(h):
        for dx in range(w):
            c = ink if dy == 0 else (iris if dy < h - 1 else tuple(int(v * 0.6) for v in iris))
            put(img, x0 + dx, y0 + dy, c)
    put(img, x0, y0 + 1, (255, 255, 255))
    put(img, x0 - 1, y0 + 1, ink); put(img, x0 + w, y0 + 1, ink)


def strings_between(img, a0, a1, b0, b1, n, col=None, T=None):
    """n strings from the edge a0-a1 to the edge b0-b1 (sheet coordinates through T)."""
    col = col or STR
    for i in range(n):
        t = (i + 0.5) / n
        p = (a0[0] + (a1[0] - a0[0]) * t, a0[1] + (a1[1] - a0[1]) * t)
        q = (b0[0] + (b1[0] - b0[0]) * t, b0[1] + (b1[1] - b0[1]) * t)
        line(img, T(*p), T(*q), col)

# ------------------------------------------------------------------------------------------- tracing
def cut_paper(src, tol=14.0, hole_tol=9.0, holes=()):
    """Foreground = everything that isn't this sheet's paper: the paper colour is the median of the crop's
    border; paper-coloured pixels connected to the border go, and so do large paper-coloured pockets inside
    (between strings, under a harp's neck)."""
    L = lab(src).reshape(src.shape[0], src.shape[1], 3)
    border = np.concatenate([L[0], L[-1], L[:, 0], L[:, -1]])
    ref = np.median(border, 0)
    d = np.sqrt((((L - ref) * np.array([0.5, 1, 1])) ** 2).sum(-1))
    paper = d < tol
    lab_, n = ndi.label(paper)
    edge = set(np.unique(np.concatenate([lab_[0], lab_[-1], lab_[:, 0], lab_[:, -1]]))) - {0}
    bg = np.isin(lab_, list(edge))
    tight = d < hole_tol
    lab2, n2 = ndi.label(tight)
    for (hx, hy) in holes:                     # pockets of paper inside the creature (between harp strings)
        r = 6
        ids = set(np.unique(lab2[max(0, hy - r):hy + r, max(0, hx - r):hx + r])) - {0}
        bg |= np.isin(lab2, list(ids))
    fg = ~bg
    fg = ndi.binary_opening(fg, iterations=1)
    return fg



def trace1(key, sheet_no, box, size, mats, ramps=None, post=None, simplify=1.4, smooth=1.8, n=4, ground=93,
          inner=False, line_lum=52, keep=None, k=10, shapes=(), holes=(), floor=None,
          refine=True, ink=1.0):
    """mats: {name: [sheet points]}; names starting with 'drop' are cut away. ramps: hand ramps that replace
    the painting's own for some materials (instrument golds, strings)."""
    x0, y0, x1, y1 = box
    src = np.ascontiguousarray(sheet(sheet_no)[y0:y1, x0:x1])
    full = sheet(sheet_no)
    mats = {k: v for k, v in mats.items() if not k.startswith("drop")}
    names = ["line"] + list(mats)
    refs, idx = [], []
    for i, nm in enumerate(mats):
        for c in sample(full, mats[nm]):
            refs.append(c)
            idx.append(i + 1)
    if refs:
        R = lab(np.array(refs))
        L = lab(src).reshape(src.shape[0], src.shape[1], 3)
        d = ((L[:, :, None, :] - R[None, None]) ** 2 * np.array([0.6, 1, 1])).sum(-1)
        near = np.array(idx)[d.argmin(-1)]
    else:
        near = np.ones(src.shape[:2], int)
    fg = cut_paper(src, holes=[(x - x0, y - y0) for x, y in holes])
    lum = src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
    mat = np.where(lum < line_lum, 0, near)
    dropped = np.zeros(fg.shape, bool)
    if keep is not None:                       # a polygon (sheet coords) outside which everything goes
        km = np.zeros(fg.shape, np.uint8)
        cv2.fillPoly(km, [np.array([(x - x0, y - y0) for x, y in keep], np.int32)], 1)
        fg &= km.astype(bool)
    fg &= ~dropped
    if floor:
        fg[floor - y0:] = False
    # ink lines that only edge dropped things go too
    fg = ndi.binary_opening(fg, iterations=1)
    labs, nl = ndi.label(fg)
    if nl > 1:
        sz = ndi.sum(fg, labs, range(1, nl + 1))
        fg = labs == (np.argmax(sz) + 1)
    fg = ndi.binary_fill_holes(fg) & (fg | ~dropped)
    if k:                                      # automatic materials (LAB k-means), named by the nearest sample
        import merge_sheet as M
        np.random.seed(0); cv2.setRNGSeed(0)
        km, kn = M.auto_classify(k)(src, fg)
        mat = km
        names = kn
    # hand-placed parts, painted over the automatic materials: ('ellipse', cx, cy, rx, ry) or ('poly', pts),
    # in sheet coordinates; a material named here takes its ramp from `ramps`
    def purple(rgb):
        r, g, b = [rgb[..., i].astype(int) for i in range(3)]
        return (b > g + 25) & (r > g - 5) & (b > 70)
    for sh_ in shapes:
        nm, shp = sh_[0], sh_[1]
        skip = sh_[2] if len(sh_) > 2 else None
        if nm not in names:
            names = names + [nm]
        m = np.zeros(fg.shape, np.uint8)
        if shp[0] == "ellipse":
            _, cx, cy, rx, ry = shp[:5]
            ang = shp[5] if len(shp) > 5 else 0
            cv2.ellipse(m, (int(cx - x0), int(cy - y0)), (int(rx), int(ry)), ang, 0, 360, 1, -1)
        else:
            cv2.fillPoly(m, [np.array([(x - x0, y - y0) for x, y in shp[1]], np.int32)], 1)
        m = m.astype(bool) & fg
        if skip == "purple":
            sk = ndi.binary_opening(purple(src), iterations=2)
            m &= ~sk
        mat = np.where(m, names.index(nm), mat)
    mat = np.where(fg, mat, -1)
    ys, xs = np.nonzero(fg)
    by, bx = ys.min(), xs.min()
    srcc = np.ascontiguousarray(src[by:ys.max() + 1, bx:xs.max() + 1])
    fgc = fg[by:ys.max() + 1, bx:xs.max() + 1]
    matc = mat[by:ys.max() + 1, bx:xs.max() + 1]
    names_ = [nm for nm in names]
    classify = lambda s_, f_: (np.where(f_, matc, -1), names_)
    tones = {}
    lumc = srcc.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
    for i, nm in enumerate(names_):
        sel = (matc == i) & fgc
        if sel.sum() < 4:
            continue
        pxs, l = srcc[sel].astype(np.float32), lumc[sel]
        if nm == "line":
            tones[nm] = [tuple(np.median(pxs, 0))]
            continue
        qs = np.quantile(l, np.linspace(0, 1, n + 1))
        tones[nm] = [tuple(np.median(pxs[(l >= qs[j]) & (l <= qs[j + 1])], 0)) for j in range(n)]
    tones = {nm: (punch(v) if nm != "line" else v) for nm, v in tones.items()
             if v and not any(np.isnan(np.array(c)).any() for c in v)}
    for nm, r in (ramps or {}).items():
        if nm in tones:
            tones[nm] = r
    img = F.reduce_semantic(srcc, fgc, size, classify, tones, ground=ground, simplify=simplify, smooth=smooth,
                            inner_lines=inner, guide_box=(x0 + bx, y0 + by), post=None)
    h_, w_ = fgc.shape
    s_ = size / max(h_, w_)
    tw, th = max(1, round(w_ * s_)), max(1, round(h_ * s_))
    ox, oy = (96 - tw) // 2, ground - th
    if refine:
        clean_silhouette(img)
        despeckle(img)
        ink_lines(img, srcc, fgc, s_, ox, oy, strength=ink)
    dark_outline(img)
    if post:
        T = lambda X, Y: (ox + (X - x0 - bx) * s_, oy + (Y - y0 - by) * s_)
        post(img, T, s_)
    return img


def clean_silhouette(img, passes=2, min_part=8):
    """Sprite-scale silhouette clean-up: one-pixel spurs go, one-pixel notches fill, crumbs drop off."""
    a = np.asarray(img).copy()
    for _ in range(passes):
        on = a[..., 3] > 0
        n4 = sum(np.roll(np.roll(on, dy, 0), dx, 1) for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)))
        spur = on & (n4 <= 1)
        a[spur, 3] = 0
        on = a[..., 3] > 0
        n4 = sum(np.roll(np.roll(on, dy, 0), dx, 1) for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)))
        notch = ~on & (n4 >= 3)
        for y, x in zip(*np.nonzero(notch)):
            nb = [a[y + dy, x + dx] for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1))
                  if 0 <= y + dy < 96 and 0 <= x + dx < 96 and a[y + dy, x + dx, 3]]
            a[y, x] = max(nb, key=lambda c: int(c[:3].sum()))
    on = a[..., 3] > 0
    lab_, n = ndi.label(on, structure=np.ones((3, 3)))
    if n > 1:
        sz = ndi.sum(on, lab_, range(1, n + 1))
        for i, z in enumerate(sz):
            if z < min_part:
                a[lab_ == i + 1, 3] = 0
    a[a[..., 3] == 0] = 0
    img.paste(Image.fromarray(a, "RGBA"))


def despeckle(img, rounds=2):
    """A colour that appears on a pixel and none of its 8 neighbours, among neighbours mostly of one other
    colour, takes that colour: the painting's flecks and brush texture fall away, the shading bands stay."""
    a = np.asarray(img).copy()
    H, W = a.shape[:2]
    for _ in range(rounds):
        b = a.copy()
        for y in range(1, H - 1):
            for x in range(1, W - 1):
                if not a[y, x, 3]:
                    continue
                me = tuple(a[y, x, :3])
                nb = [tuple(a[y + dy, x + dx, :3]) for dy in (-1, 0, 1) for dx in (-1, 0, 1)
                      if (dy or dx) and a[y + dy, x + dx, 3]]
                if len(nb) < 7 or me in nb:
                    continue
                best = max(set(nb), key=nb.count)
                if nb.count(best) >= 4:
                    b[y, x, :3] = best
        a = b
    img.paste(Image.fromarray(a, "RGBA"))


def ink_lines(img, src, fg, s, ox, oy, strength=1.0):
    """The painting's own contour lines - where a leg crosses the body, an arm the chest, the instrument meets
    the creature - found as thin dark strokes (black-hat), thinned to a skeleton, and redrawn one pixel wide
    in each material's own deep shade. These are what keep the parts from melting into one blob."""
    from skimage.morphology import skeletonize
    lum = (src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)).astype(np.uint8)
    k = max(7, int(round(1.6 / s)) | 1)
    bh = cv2.morphologyEx(lum, cv2.MORPH_BLACKHAT, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (k, k)))
    ink = (bh > 28 / strength) & (lum < 150) & ndi.binary_erosion(fg, iterations=max(2, int(1.2 / s)))
    sk = skeletonize(ink)
    lab_, n = ndi.label(sk, structure=np.ones((3, 3)))
    if n:
        sz = ndi.sum(sk, lab_, range(1, n + 1))
        sk = np.isin(lab_, np.flatnonzero(sz >= 3.0 / s) + 1)
    ys, xs = np.nonzero(sk)
    cnt = np.zeros((96, 96), np.float32)
    X = np.floor(ox + xs * s).astype(int)
    Y = np.floor(oy + ys * s).astype(int)
    ok = (X >= 0) & (X < 96) & (Y >= 0) & (Y < 96)
    np.add.at(cnt, (Y[ok], X[ok]), 1)
    a = np.asarray(img).copy()
    on = a[..., 3] > 0
    inner = ndi.binary_erosion(on, iterations=1)
    m = (cnt >= 0.75 / s) & inner
    m = skeletonize(m) | (m & (cnt >= 2.0 / s))
    m = skeletonize(m)
    lab_, n = ndi.label(m, structure=np.ones((3, 3)))
    if n:
        sz = ndi.sum(m, lab_, range(1, n + 1))
        m = np.isin(lab_, np.flatnonzero(sz >= 3) + 1)
    c = a[..., :3].astype(float)
    mx = c.max(-1, keepdims=True)
    deep = np.clip(c * np.minimum(1.0, 92.0 / np.maximum(mx, 1)), 0, 255) * 0.8 + 8
    a[m, :3] = deep[m].astype(np.uint8)
    img.paste(Image.fromarray(a, "RGBA"))


def dark_outline(img):
    """Every pixel on the silhouette's edge becomes a dark, hue-keeping outline (the PIF look)."""
    a = np.asarray(img).copy()
    on = a[..., 3] > 0
    edge = on & ~ndi.binary_erosion(on, structure=np.array([[0, 1, 0], [1, 1, 1], [0, 1, 0]]))
    c = a[..., :3].astype(float)
    m = c.max(-1, keepdims=True)
    darker = np.clip(c * np.minimum(1.0, 70.0 / np.maximum(m, 1)), 0, 255) * 0.85 + 6
    a[edge, :3] = darker[edge].astype(np.uint8)
    img.paste(Image.fromarray(a, "RGBA"))


# ------------------------------------------------------------------------------------------- Wyn line
EYE = ((40, 60, 140), (110, 160, 230), (170, 214, 250), (232, 246, 255))


def sableye_lutling():
    RIM = [(110, 66, 20), (150, 98, 30), (186, 132, 50)]

    def post(img, T, s):
        cx, cy = T(303, 615)
        for x in (312, 322, 334):
            line(img, T(x, 575), T(x, 678), STR)
        line(img, T(306, 668), T(340, 668), GOLDS[0])
        rose(img, *T(323, 620), 32 * s, face=GOLDS[2])
        F.gem(img, *T(324, 556), 5, 6, ((90, 10, 20), (170, 20, 40), (230, 60, 70), (255, 170, 170)))
        F.gem(img, *T(278, 465), 62 * s, 72 * s, EYE)
        F.gem(img, *T(386, 464), 40 * s, 70 * s, EYE)
        F.stamp_mouths(img, [(0, 0, "open")], 1, *T(325, 514))
    return trace("577.421", 7, (95, 290, 475, 712), 66,
                 {}, ramps={"lute": GOLDS, "rim": RIM}, post=post,
                 shapes=[("rim", ("ellipse", 303, 615, 88, 82), "purple"), ("lute", ("ellipse", 303, 615, 80, 74), "purple")],
                 keep=[(140, 300), (470, 295), (470, 470), (440, 520), (430, 694), (150, 694), (165, 640), (120, 600), (170, 560)])


def sporeye_hauntello():
    VAR = [(92, 22, 16), (150, 44, 30), (196, 72, 48), (230, 120, 84)]

    def post(img, T, s):
        for x in (865, 874, 884, 893):
            line(img, T(x, 452), T(x, 610), GOLDS[2])
        line(img, T(858, 617), T(905, 617), GOLDS[1])
        fhole(img, *T(837, 515), 55 * s)
        fhole(img, *T(945, 528), 55 * s, mirror=True)
        F.gem(img, *T(844, 377), 55 * s, 65 * s, EYE)
        F.gem(img, *T(940, 377), 35 * s, 55 * s, EYE)
        F.stamp_mouths(img, [(0, 0, "open")], 1, *T(885, 425))
    return trace("578.585", 7, (600, 140, 1080, 712), 86, {}, ramps={"cello": VAR}, post=post,
                 keep=[(640, 300), (700, 210), (770, 160), (870, 140), (980, 200), (1010, 290), (1075, 280), (1078, 470),
                       (1030, 560), (1000, 600), (1000, 708), (640, 708), (650, 620), (610, 470), (640, 420)])


def myconarch_chorumbra():
    WOOD = [(70, 36, 16), (118, 70, 34), (164, 108, 58), (204, 150, 92)]

    def post(img, T, s):
        rose(img, *T(1680, 375), 24 * s, face=WOOD[2])
        F.gem(img, *T(1442, 260), 40 * s, 50 * s, EYE)
        F.gem(img, *T(1378, 295), 30 * s, 44 * s, EYE)
    return trace("579.586", 7, (1160, 20, 1880, 715), 96, {}, post=post,
                 keep=[(1165, 330), (1200, 220), (1300, 120), (1420, 60), (1560, 40), (1640, 70), (1700, 140), (1790, 140),
                       (1830, 190), (1790, 240), (1740, 470), (1660, 520), (1650, 690), (1600, 712), (1290, 712),
                       (1300, 600), (1290, 420), (1230, 400), (1165, 380)], min_part=2.4, k=6)


# ------------------------------------------------------------------------------------------- Noibat line
def noibat_lutling():
    def post(img, T, s):
        for (a, b) in (((205, 385), (310, 495)), ((525, 385), (440, 500))):
            dx, dy = b[0] - a[0], b[1] - a[1]
            L = math.hypot(dx, dy)
            for off in (-5, 0, 5):
                nx, ny = -dy / L * off, dx / L * off
                line(img, T(a[0] + nx, a[1] + ny), T(b[0] + nx, b[1] + ny), (150, 100, 30))
        rose(img, *T(265, 440), 30 * s, face=GOLDS[2])
        rose(img, *T(480, 450), 30 * s, face=GOLDS[2])
        eye(img, *T(342, 542), (240, 196, 60), h=4)
        eye(img, *T(432, 550), (240, 196, 60), h=4)
    return trace("577.440", 8, (55, 320, 590, 718), 76, {}, post=post, ramps={"lute": GOLDS},
                 shapes=[("lute", ("ellipse", 256, 436, 63, 68), None), ("lute", ("ellipse", 488, 447, 63, 65), None)],
                 keep=[(62, 545), (110, 520), (160, 330), (330, 340), (380, 330), (525, 320), (560, 330), (545, 480),
                       (530, 560), (532, 655), (450, 668), (380, 712), (190, 712), (170, 640), (110, 610), (70, 560)])


def noivern_chorumbra():
    def post(img, T, s):
        for poly in ([(905, 150), (990, 180), (1060, 240), (1085, 330), (1060, 350), (1000, 320), (940, 260), (910, 200)],
                     [(1440, 190), (1460, 210), (1420, 300), (1370, 360), (1320, 380), (1310, 330), (1350, 260), (1400, 210)]):
            P_ = [T(*p) for p in poly]
            xs = [p[0] for p in P_]
            m = np.zeros((96, 96), np.uint8)
            cv2.fillPoly(m, [np.array([(round(x), round(y)) for x, y in P_], np.int32)], 1)
            for x in range(int(min(xs)) + 1, int(max(xs)), 2):
                ys_ = np.nonzero(m[:, x])[0]
                if len(ys_):
                    for y in range(ys_.min(), ys_.max() + 1):
                        put(img, x, y, STR)
        eye(img, *T(1150, 366), (240, 196, 60), h=3)
        eye(img, *T(1230, 380), (240, 196, 60), h=3)
    return trace("579.441", 8, (603, 95, 1738, 705), 96, {}, floor=694, post=post, line_lum=46,
                 holes=[(960, 230), (1000, 260), (1380, 280), (1350, 320)],
                 keep=[(605, 650), (640, 420), (700, 300), (860, 100), (1100, 150), (1180, 190), (1290, 140), (1490, 95),
                       (1560, 250), (1680, 350), (1736, 640), (1650, 600), (1590, 702), (1300, 702), (1180, 690),
                       (1020, 702), (820, 702), (860, 640), (790, 560), (720, 520), (640, 650)])


PAIRS = {"577.421": sableye_lutling, "578.585": sporeye_hauntello, "579.586": myconarch_chorumbra,
         "577.440": noibat_lutling, "579.441": noivern_chorumbra}

# ------------------------------------------------------------------------------------------- Bulbasaur line
RED_EYE = (200, 40, 50)
HONEYS = [(110, 60, 24), (176, 112, 50), (226, 170, 90), (248, 214, 150)]
WOODS = [(70, 36, 16), (118, 70, 34), (164, 108, 58), (204, 150, 92)]
VARN = [(92, 22, 16), (150, 44, 30), (196, 72, 48), (232, 122, 84)]


def bulbasaur_lutling():
    def post(img, T, s):
        strings_between(img, (300, 455), (318, 468), (420, 292), (432, 302), 3, T=T)
        rose(img, *T(336, 398), 30 * s, face=HONEYS[2])
        eye(img, *T(125, 485), RED_EYE)
        eye(img, *T(238, 478), RED_EYE)
    return trace("577.1", 5, (85, 205, 525, 635), 70, {}, floor=622, post=post,
                 shapes=[("lute", ("ellipse", 333, 392, 95, 72, -42))], ramps={"lute": HONEYS},
                 keep=[(85, 520), (100, 400), (170, 330), (240, 290), (300, 250), (420, 210), (500, 215), (500, 320),
                       (520, 420), (500, 560), (470, 630), (100, 630)])


def ivysaur_hauntello():
    def post(img, T, s):
        strings_between(img, (880, 450), (910, 450), (1000, 170), (1015, 178), 3, T=T)
        fhole(img, *T(905, 290), 70 * s)
        fhole(img, *T(1010, 340), 70 * s, mirror=True)
        eye(img, *T(668, 462), RED_EYE)
        eye(img, *T(785, 452), RED_EYE)
    return trace("578.2", 5, (545, 115, 1180, 640), 86, {}, floor=626, post=post, ramps={"cello": VARN},
                 shapes=[("cello", ("ellipse", 960, 345, 110, 125, -30), None)],
                 keep=[(550, 470), (600, 290), (700, 250), (760, 150), (900, 160), (1000, 115), (1070, 140), (1080, 280),
                       (1170, 330), (1175, 450), (1130, 560), (1120, 630), (580, 630), (560, 540)])


def venusaur_chorumbra():
    def post(img, T, s):
        for k, x in enumerate(range(1585, 1735, 15)):
            yt = 215 + abs(x - 1650) * 0.25
            line(img, T(x, yt), T(x, 470 - (x - 1585) * 0.25), GOLDS[3] if k % 2 else GOLDS[2])
        rose(img, *T(1765, 490), 30 * s, face=HONEYS[2])
        eye(img, *T(1340, 455), (220, 90, 40))
        eye(img, *T(1478, 438), (220, 90, 40))
    return trace("579.3", 5, (1185, 120, 1925, 640), 96, {}, floor=626, post=post,
                 keep=[(1190, 470), (1230, 330), (1330, 200), (1450, 150), (1560, 130), (1700, 150), (1780, 200),
                       (1800, 260), (1880, 400), (1910, 540), (1880, 630), (1220, 630), (1200, 560)])


# ------------------------------------------------------------------------------------------- Cinderwright line
FOX_EYE = (40, 44, 60)


def wickit_lutling():
    def post(img, T, s):
        strings_between(img, (330, 545), (342, 548), (400, 395), (408, 398), 3, T=T)
        rose(img, *T(358, 500), 26 * s, face=HONEYS[2])
        eye(img, *T(222, 465), (70, 84, 110), h=4)
    return trace("577.582", 6, (40, 335, 470, 670), 72, {}, floor=664, post=post,
                 shapes=[("lute", ("ellipse", 352, 495, 50, 70, 30))], ramps={"lute": HONEYS},
                 keep=[(85, 650), (110, 500), (120, 380), (200, 370), (290, 400), (360, 380), (410, 335), (460, 350),
                       (465, 580), (380, 600), (370, 668), (85, 668)])


def stoketail_hauntello():
    def post(img, T, s):
        strings_between(img, (820, 520), (850, 520), (868, 250), (880, 250), 3, T=T)
        eye(img, *T(675, 252), (70, 84, 110), h=3)
        fhole(img, *T(797, 395), 60 * s)
        fhole(img, *T(882, 410), 60 * s, mirror=True)
    return trace("578.583", 6, (515, 155, 980, 680), 88, {}, floor=670, post=post,
                 keep=[(520, 420), (570, 160), (750, 160), (860, 190), (960, 190), (970, 330), (975, 590),
                       (880, 680), (530, 680), (540, 560)])


def forgel_chorumbra():
    def post(img, T, s):
        for k, x in enumerate(range(1420, 1590, 17)):
            line(img, T(x, 238 + (x - 1420) * 0.02), T(x - 5, 455 - (x - 1420) * 0.25), GOLDS[3] if k % 2 else GOLDS[2])
        rose(img, *T(1590, 485), 34 * s, face=HONEYS[2])
        eye(img, *T(1122, 440), (70, 84, 110), h=3)
    return trace("579.584", 6, (1010, 150, 1740, 690), 96, {}, floor=682, post=post,
                 keep=[(1015, 470), (1060, 330), (1200, 310), (1330, 250), (1380, 180), (1500, 160), (1640, 220),
                       (1725, 330), (1735, 600), (1660, 690), (1020, 690)])


PAIRS.update({"577.1": bulbasaur_lutling, "578.2": ivysaur_hauntello, "579.3": venusaur_chorumbra,
              "577.582": wickit_lutling, "578.583": stoketail_hauntello, "579.584": forgel_chorumbra})


# ------------------------------------------------------------------------------------------- Zorua line, sheet 4
BLUE_EYE = (60, 170, 210)


def zorua_lutling():
    def post(img, T, s):
        rose(img, *T(320, 484), 15 * s, face=HONEYS[2])
        strings_between(img, (300, 505), (308, 510), (362, 432), (368, 436), 2, T=T)
        eye(img, *T(216, 478), BLUE_EYE, h=3)
        eye(img, *T(254, 478), BLUE_EYE, h=3)
    return trace("577.399", 4, (162, 380, 420, 552), 68, {}, floor=548, post=post,
                 keep=[(165, 550), (170, 430), (200, 390), (260, 395), (300, 440), (360, 400), (395, 380), (418, 400),
                       (400, 470), (360, 530), (330, 550)])


def zoroark_hauntello():
    def post(img, T, s):
        strings_between(img, (818, 505), (842, 505), (835, 392), (850, 392), 3, T=T)
        fhole(img, *T(798, 440), 30 * s)
        fhole(img, *T(866, 452), 30 * s, mirror=True)
        spiral(img, *T(842, 368), 2.2, VARN)
        eye(img, *T(593, 440), BLUE_EYE, h=3)
    return trace("578.338", 4, (520, 325, 1035, 555), 96, {}, min_part=2.4, k=6, floor=550, post=post,
                 ramps={"cello": VARN}, shapes=[("cello", ("ellipse", 830, 452, 78, 60, -15))],
                 keep=[(525, 440), (560, 360), (640, 330), (800, 330), (900, 380), (1000, 430), (1032, 500),
                       (1000, 552), (530, 552)])


# ------------------------------------------------------------------------------------------- sheet 1
def gengar_hauntello():
    def post(img, T, s):
        for x in (782, 795, 808):
            line(img, T(x, 382), T(795 + (x - 795) * 0.3, 540), GOLDS[2])
        line(img, T(808, 382), T(1000, 340), GOLDS[2])
        fhole(img, *T(720, 455), 70 * s)
        fhole(img, *T(875, 460), 70 * s, mirror=True)
    return trace("578.94", 1, (510, 150, 1035, 560), 84, {}, post=post, k=10)


def gardevoir_chorumbra():
    def post(img, T, s):
        px = img.load()
        cx, cy, r = 1318, 268, 100
        for k, x in enumerate(range(1262, 1385, 14)):
            dy = math.sqrt(max(0, r * r - (x - cx) ** 2))
            for y in np.arange(cy - dy + 8, cy + dy - 8, 2):
                X, Y = [int(round(v)) for v in T(x, y)]
                c = px[X, Y] if 0 <= X < 96 and 0 <= Y < 96 else (0, 0, 0, 0)
                if c[3] and c[0] > 150 and c[1] > 150:          # over the pale gown / gaps, not the hair or wood
                    put(img, X, Y, GOLDS[2] if k % 2 else GOLDS[3])
        eye(img, *T(1210, 266), (210, 60, 80), h=3)
    return trace("579.287", 1, (1060, 150, 1515, 685), 90, {}, post=post, k=9)


PAIRS.update({"577.399": zorua_lutling, "578.338": zoroark_hauntello, "578.94": gengar_hauntello,
              "579.287": gardevoir_chorumbra})
ORDER = ["577.1", "578.2", "579.3", "577.399", "578.338", "577.440", "579.441", "577.582", "578.583", "579.584",
         "577.421", "578.585", "579.586", "578.94", "579.287"]



def compare(keys, path):
    """Each sprite at 4x beside the illustration it was traced from."""
    import inspect
    from PIL import ImageDraw
    rows = []
    for k in keys:
        spr = PAIRS[k]().resize((384, 384), Image.NEAREST)
        src = inspect.getsource(PAIRS[k])
        import re
        m = re.search(r'trace\("[^"]+", (\d+), \((\d+), (\d+), (\d+), (\d+)\)', src)
        sh, x0, y0, x1, y1 = map(int, m.groups())
        ill = Image.fromarray(sheet(sh)[y0:y1, x0:x1])
        ill.thumbnail((384, 384))
        row = Image.new("RGB", (790, 392), (236, 236, 242))
        row.paste(ill, (2, 4))
        bg = Image.new("RGBA", spr.size, (236, 236, 242, 255)); bg.alpha_composite(spr)
        row.paste(bg.convert("RGB"), (402, 4))
        ImageDraw.Draw(row).text((404, 4), k, fill=(0, 0, 0))
        rows.append(row)
    cols = 2
    W = Image.new("RGB", (790 * cols, 392 * ((len(rows) + cols - 1) // cols)), (255, 255, 255))
    for i, r in enumerate(rows):
        W.paste(r, (790 * (i % cols), 392 * (i // cols)))
    W.save(path)


# ------------------------------------------------------------------------------------------- part-based renderer
def lineart(src, fg, s):
    """The illustration's ink: strokes darker than their surroundings (black-hat) or simply very dark."""
    lum = (src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32))
    l8 = np.clip(lum, 0, 255).astype(np.uint8)
    k = max(9, int(round(2.2 / s)) | 1)
    bh = cv2.morphologyEx(l8, cv2.MORPH_BLACKHAT, cv2.getStructuringElement(cv2.MORPH_ELLIPSE, (k, k)))
    sat = src.max(-1).astype(int) - src.min(-1).astype(int)
    ink = ((bh > 34) & (lum < 130)) | (lum < 62)
    ink &= fg
    ink = ndi.binary_opening(ink, structure=np.ones((2, 2)))
    return ink


def ramp_of(px, n=4):
    """A part's own shading ramp from its pixels: quantile bands of light, median colour of each band,
    then spread so the bands read as separate tones."""
    l = px @ np.array([0.3, 0.59, 0.11])
    qs = np.quantile(l, np.linspace(0, 1, n + 1))
    out = []
    for j in range(n):
        sel = (l >= qs[j]) & (l <= qs[j + 1])
        out.append(np.median(px[sel], 0) if sel.any() else np.median(px, 0))
    return punch([tuple(c) for c in out], sat=1.15, spread=1.35)


def materials(src, fg, k, lw=0.3):
    """Colour families (LAB k-means, light weighted down so a material's shadow and highlight stay one family)."""
    L = lab(src).reshape(src.shape[0], src.shape[1], 3)
    Z = L[fg].copy()
    Z[:, 0] *= lw
    np.random.seed(0); cv2.setRNGSeed(0)
    crit = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 60, 0.5)
    _, lab_, cen = cv2.kmeans(Z.astype(np.float32), k, None, crit, 4, cv2.KMEANS_PP_CENTERS)
    mat = np.full(fg.shape, -1, int)
    mat[fg] = lab_.ravel()
    # a family map smoothed at a sprite pixel's scale, so brush texture doesn't make families
    return mat


def render_parts(src, fg, size, ground=93, canvas=96, shapes_mask=None, ramps_by_part=None, min_part=1.6,
                 bands=3, ink_frac=0.34, k=8, shape_ramps=None):
    """src/fg cropped to the creature. Returns (img, s, ox, oy).
    Parts are the regions the illustration's line art encloses; each part is filled with its own ramp in
    clean light bands; part borders and the ink become one-pixel lines in each part's deep shade."""
    h, w = fg.shape
    s = size / max(h, w)
    ink = lineart(src, fg, s)
    if shapes_mask is not None:                     # hand-placed parts get a border of their own
        for sm in shapes_mask:
            ink |= sm & ~ndi.binary_erosion(sm, iterations=max(2, int(0.6 / s)))
    mat = materials(src, fg, k)
    win = max(3, int(round(0.9 / s)) | 1)
    votes = np.stack([ndi.uniform_filter((mat == i).astype(np.float32), win) for i in range(k)], 2)
    mat = np.where(fg, votes.argmax(2), -1)
    regions = fg & ~ink
    lab_ = np.zeros(fg.shape, int); n = 0
    for i in range(k):
        l_, n_ = ndi.label(regions & (mat == i))
        lab_[l_ > 0] = l_[l_ > 0] + n
        n += n_
    # tiny regions are brush texture, not parts: they join the part around them
    sizes = ndi.sum(regions, lab_, range(1, n + 1))
    small_area = (min_part / s) ** 2
    big = np.zeros(n + 1, bool); big[1:] = sizes >= small_area
    part = np.where(big[lab_], lab_, 0)
    # every fg pixel (ink, small bits) takes the nearest big part
    idx = ndi.distance_transform_edt(part == 0, return_distances=False, return_indices=True)
    part_full = part[idx[0], idx[1]]
    part_full[~fg] = 0
    ramps_by_part = dict(ramps_by_part or {})
    if shapes_mask is not None:
        for i, sm in enumerate(shapes_mask):
            part_full[sm & fg] = n + 1 + i
            if shape_ramps and shape_ramps[i]:
                ramps_by_part[n + 1 + i] = list(shape_ramps[i])
    ids = np.unique(part_full[part_full > 0])
    lum = src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
    lum_s = ndi.gaussian_filter(lum, 1.8 / s)
    tw, th = max(1, round(w * s)), max(1, round(h * s))
    cov = cv2.resize(fg.astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA)
    on = cov >= 0.5
    # part vote per sprite cell
    best = np.zeros((th, tw), int); bestf = np.zeros((th, tw), np.float32)
    flum = np.zeros((th, tw), np.float32)
    ramps, thr = {}, {}
    for i in ids:
        m = part_full == i
        f = cv2.resize(m.astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA)
        better = f > bestf
        best[better] = i; bestf[better] = f[better]
        L_ = cv2.resize(np.where(m, lum_s, 0).astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA)
        flum = np.where(better, L_ / np.maximum(f, 1e-4), flum)
        body = m & ~ink
        pxs = src[body if body.sum() > 10 else m].astype(np.float32)
        ramps[i] = (ramps_by_part or {}).get(i) or ramp_of(pxs, bands + 1)
        v = lum_s[m]
        thr[i] = np.quantile(v, np.linspace(0, 1, bands + 1)[1:-1]) if len(v) else []
    best[~on] = 0
    inkf = cv2.resize(ink.astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA)
    # band per cell, then clean clusters
    tone = np.zeros((th, tw), int)
    for y in range(th):
        for x in range(tw):
            i = best[y, x]
            if i:
                tone[y, x] = int(np.searchsorted(thr[i], flum[y, x])) + 1
    for _ in range(3):
        t2 = tone.copy()
        for y in range(th):
            for x in range(tw):
                i = best[y, x]
                if not i:
                    continue
                nb = [tone[y + dy, x + dx] for dy, dx in N4_ if 0 <= y + dy < th and 0 <= x + dx < tw and best[y + dy, x + dx] == i]
                if len(nb) >= 3 and nb.count(tone[y, x]) == 0:
                    t2[y, x] = max(set(nb), key=nb.count)
        tone = t2
    # part borders: a cell whose right or lower neighbour is another part draws the line, on the side of the
    # part that is darker (behind); plus cells mostly covered by ink
    line = np.zeros((th, tw), bool)
    meanl = {i: float(np.mean(ramps[i][1]) if len(ramps[i]) else 0) for i in ids}
    for y in range(th):
        for x in range(tw):
            i = best[y, x]
            if not i:
                continue
            for dy, dx in ((0, 1), (1, 0), (0, -1), (-1, 0)):
                yy, xx = y + dy, x + dx
                if 0 <= yy < th and 0 <= xx < tw and best[yy, xx] and best[yy, xx] != i:
                    j = best[yy, xx]
                    if (sum(ramps[i][1]) < sum(ramps[j][1])) or (sum(ramps[i][1]) == sum(ramps[j][1]) and (dy > 0 or dx > 0)):
                        line[y, x] = True
    from skimage.morphology import skeletonize
    line |= skeletonize(inkf >= ink_frac)
    out = np.zeros((canvas, canvas, 4), np.uint8)
    ox, oy = (canvas - tw) // 2, ground - th
    for y in range(th):
        for x in range(tw):
            i = best[y, x]
            if not i:
                continue
            r = ramps[i]
            if line[y, x]:
                c = np.array(r[0], float)
                c = c * min(1.0, 96.0 / max(c.max(), 1)) * 0.85 + 6
            else:
                c = np.array(r[min(tone[y, x], len(r) - 1)], float)
            out[oy + y, ox + x, :3] = np.clip(c, 0, 255)
            out[oy + y, ox + x, 3] = 255
    img = Image.fromarray(out, "RGBA")
    return img, s, ox, oy


N4_ = ((1, 0), (-1, 0), (0, 1), (0, -1))


def trace(key, sheet_no, box, size, mats=None, ramps=None, post=None, ground=93, keep=None, shapes=(), holes=(),
           floor=None, bands=3, min_part=1.6, k=8, **_):
    """trace() with the part-based renderer."""
    x0, y0, x1, y1 = box
    src = np.ascontiguousarray(sheet(sheet_no)[y0:y1, x0:x1])
    fg = cut_paper(src, holes=[(x - x0, y - y0) for x, y in holes])
    if keep is not None:
        km = np.zeros(fg.shape, np.uint8)
        cv2.fillPoly(km, [np.array([(x - x0, y - y0) for x, y in keep], np.int32)], 1)
        fg &= km.astype(bool)
    if floor:
        fg[floor - y0:] = False
    fg = ndi.binary_opening(fg, iterations=1)
    labs, nl = ndi.label(fg)
    if nl > 1:
        sz = ndi.sum(fg, labs, range(1, nl + 1))
        fg = labs == (np.argmax(sz) + 1)
    fg = ndi.binary_fill_holes(fg) & fg | (ndi.binary_fill_holes(fg) & ~cut_paper_bg(src, fg, holes, x0, y0))
    ys, xs = np.nonzero(fg)
    by, bx = ys.min(), xs.min()
    srcc = np.ascontiguousarray(src[by:ys.max() + 1, bx:xs.max() + 1])
    fgc = fg[by:ys.max() + 1, bx:xs.max() + 1]
    masks, pr = [], {}
    for k_, sh_ in enumerate(shapes):
        nm, shp = sh_[0], sh_[1]
        m = np.zeros(fgc.shape, np.uint8)
        if shp[0] == "ellipse":
            _, cx, cy, rx, ry = shp[:5]
            ang = shp[5] if len(shp) > 5 else 0
            cv2.ellipse(m, (int(cx - x0 - bx), int(cy - y0 - by)), (int(rx), int(ry)), ang, 0, 360, 1, -1)
        else:
            cv2.fillPoly(m, [np.array([(x - x0 - bx, y - y0 - by) for x, y in shp[1]], np.int32)], 1)
        m = m.astype(bool) & fgc
        if len(sh_) > 2 and sh_[2] == "purple":
            r_, g_, b_ = [srcc[..., i].astype(int) for i in range(3)]
            m &= ~ndi.binary_opening((b_ > g_ + 25) & (r_ > g_ - 5) & (b_ > 70), iterations=2)
        masks.append(m)
    img, s_, ox, oy = render_parts(srcc, fgc, size, ground=ground, shapes_mask=masks or None, bands=bands,
                                   min_part=min_part, k=k,
                                   shape_ramps=[(ramps or {}).get(sh_[0]) for sh_ in shapes])
    if shapes and ramps:
        pass
    clean_silhouette(img)
    dark_outline(img)
    if post:
        T = lambda X, Y: (ox + (X - x0 - bx) * s_, oy + (Y - y0 - by) * s_)
        post(img, T, s_)
    return img


def cut_paper_bg(src, fg, holes, x0, y0):
    return ~fg


if __name__ == "__main__":
    import sys
    sys.path.insert(0, ".")
    from alb_ops import show
    S = "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/"
    keys = sys.argv[1:] or ORDER
    compare(keys, S + "trace.png")
