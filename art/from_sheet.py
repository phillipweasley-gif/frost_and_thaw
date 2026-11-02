"""Sprites from any concept sheet, by material reduction (the method that worked for Cinderwright),
with the materials found automatically: the painting's colours are clustered into families, each
family keeps a short ramp of its own, every sprite pixel takes one family by vote, thin accents
(gold strings, cobalt swirls) win when they hold enough of a block, dark line art survives as line.
Then the same clean-up: pin-holes, islands, lone pixels, spurs, one-pixel outline lit on the light side."""
import numpy as np
import cv2
from PIL import Image
from scipy import ndimage as ndi

SCR = "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/"
N4 = ((1, 0), (-1, 0), (0, 1), (0, -1))


def cut_main(rgb):
    """Paper (and soft ground shadow) flood-filled from the border; only the creature's main body is
    kept, so loose notes, flame wisps and title letters fall away."""
    im = rgb.astype(np.int16)
    mx, mn = im.max(2), im.min(2)
    tint = im[..., 1] - im[..., 0]
    paperish = (((mn > 200) & ((mx - mn) < 30)) | ((mn > 170) & ((mx - mn) < 40) & (np.abs(im[..., 0] - im[..., 2]) < 25))) & (tint < 14)
    lab, n = ndi.label(paperish)
    border = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    fg = ~np.isin(lab, list(border))
    # paper seen through gaps (between strings, inside the harp frame) is background too
    for i in range(1, n + 1):
        if i in border:
            continue
        comp = lab == i
        if comp.sum() > 250:
            m = im[comp].mean(0)
            if abs(m[1] - m[0]) < 9 and abs(m[2] - m[0]) < 12:      # truly neutral paper, not a pale gill or glaze
                fg[comp] = False
    fg = ndi.binary_opening(fg, iterations=1)
    lab2, n2 = ndi.label(ndi.binary_closing(fg, iterations=2), structure=np.ones((3, 3)))
    if n2:
        sizes = ndi.sum(fg, lab2, range(1, n2 + 1))
        fg = fg & (lab2 == (np.argmax(sizes) + 1))
    return fg


def families(src, fg, k):
    lum = src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
    line = (lum < 58) & fg
    body = fg & ~line
    lab = cv2.cvtColor(np.ascontiguousarray(src), cv2.COLOR_RGB2LAB).reshape(-1, 3).astype(np.float32)
    Z = lab[body.ravel()]
    crit = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 60, 0.5)
    _, labels, centres = cv2.kmeans(Z, k, None, crit, 5, cv2.KMEANS_PP_CENTERS)
    fam = np.full(fg.shape, -1, int)
    fam.ravel()[np.flatnonzero(body.ravel())] = labels.ravel()
    fam[line] = k                                   # family k = line art
    # islands of a family smaller than a speck take their surroundings
    for f in range(k):
        l_, n_ = ndi.label(fam == f)
        if not n_:
            continue
        sizes = ndi.sum(np.ones_like(l_), l_, range(1, n_ + 1))
        small = np.isin(l_, [i + 1 for i, s in enumerate(sizes) if s < 30])
        if small.any():
            good = (fam >= 0) & ~small & (fam != k)
            _, (iy, ix) = ndi.distance_transform_edt(~good, return_indices=True)
            fam[small] = fam[iy[small], ix[small]]
    return fam, lum


def ramps(src, fam, k, tones=2):
    out = {}
    for f in range(k + 1):
        px = src[fam == f].astype(np.float32)
        if len(px) == 0:
            continue
        lum = px @ np.array([0.3, 0.59, 0.11], np.float32)
        t = 1 if f == k else tones
        qs = np.quantile(lum, np.linspace(0, 1, t + 1))
        out[f] = np.array([np.median(px[(lum >= qs[i]) & (lum <= qs[i + 1])], 0) for i in range(t)])
    return out


def find_eyes(src, fg):
    """Eyes in the painting: dark shapes holding a white highlight. Returns centre, size and iris colour."""
    lum = src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
    dark = (lum < 75) & fg
    hl = (src.min(2) > 232) & (ndi.uniform_filter(dark.astype(np.float32), 7) > 0.3) & fg
    lab, n = ndi.label(ndi.binary_dilation(dark, iterations=1) | hl)
    hsv = cv2.cvtColor(np.ascontiguousarray(src), cv2.COLOR_RGB2HSV).astype(int)
    eyes = []
    for i in set(np.unique(lab[hl])) - {0}:
        comp = lab == i
        yy, xx = np.nonzero(comp)
        if not (25 < len(yy) < 3000) or (yy.max() - yy.min()) > 70 or (xx.max() - xx.min()) > 70:
            continue
        reg = ndi.binary_dilation(comp, iterations=3) & fg
        iris = reg & (hsv[..., 1] > 70) & (lum > 60) & (lum < 175)
        col = np.median(src[iris], 0) if iris.sum() > 5 else np.array([120, 70, 140])
        eyes.append((xx.mean(), yy.mean(), xx.max() - xx.min() + 1, yy.max() - yy.min() + 1, col))
    return eyes


EYES = {5: [".KKK.", "KWWKK", "KWKKK", "KIIIK", ".KIK."],
        4: [".KK.", "KWKK", "KKIK", ".KI."],
        3: [".K.", "KWK", "KIK"],
        2: ["WK", "KI"]}


def stamp_eyes(img, eyes, s, ox, oy):
    px = img.load()
    for (ex, ey, ew, eh, col) in eyes:
        size = max(2, min(5, int(round(max(ew, eh) * s + 0.3))))
        t = EYES[size]
        cx, cy = ox + ex * s, oy + ey * s
        x0, y0 = int(round(cx - len(t[0]) / 2)), int(round(cy - len(t) / 2))
        cols = {"K": (24, 12, 22), "W": (255, 255, 255), "I": tuple(int(v) for v in col)}
        for j, row in enumerate(t):
            for i, ch in enumerate(row):
                if ch in cols and 0 <= x0 + i < img.width and 0 <= y0 + j < img.height and px[x0 + i, y0 + j][3]:
                    px[x0 + i, y0 + j] = cols[ch] + (255,)


def reduce_sheet(src, fg, size, k=12, ground=90, canvas=96, flip=False, accent_share=0.05, body_strings=True,
                 eyes=None, mouths=(), gems=()):
    """eyes / mouths: hand-placed features in the crop's own coordinates (x, y, w, h, iris) / (x, y, kind)."""
    ys, xs = np.nonzero(fg)
    bx, by = xs.min(), ys.min()
    src, fg = src[ys.min():ys.max() + 1, xs.min():xs.max() + 1], fg[ys.min():ys.max() + 1, xs.min():xs.max() + 1]
    if eyes is not None:
        eyes = [(x - bx, y - by, w, h, np.array(c)) for (x, y, w, h, c) in eyes]
    mouths = [(x - bx, y - by, kd) for (x, y, kd) in mouths]
    gems = [(x - bx, y - by, w, h, r) for (x, y, w, h, r) in gems]
    if flip:
        src, fg = src[:, ::-1], fg[:, ::-1]
    src = np.ascontiguousarray(src)
    fam, lum = families(src, fg, k)
    R = ramps(src, fam, k)
    h, w = fg.shape
    s = size / max(h, w)
    tw, th = max(1, round(w * s)), max(1, round(h * s))
    cov = cv2.resize(fg.astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA)
    on = cov >= 0.5
    l_, n_ = ndi.label(~on)
    if n_:
        edge_ids = set(np.unique(np.concatenate([l_[0], l_[-1], l_[:, 0], l_[:, -1]])))
        sizes = ndi.sum(np.ones_like(l_), l_, range(1, n_ + 1))
        for i, sz in enumerate(sizes):
            if sz <= 4 and (i + 1) not in edge_ids:
                on[l_ == i + 1] = True
    F = k + 1
    frac = np.stack([cv2.resize((fam == f).astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA) for f in range(F)], 2)
    lum_s = ndi.gaussian_filter(lum, 0.9 / s)          # wood grain and brush texture are not shading
    flum = np.stack([cv2.resize(np.where(fam == f, lum_s, 0).astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA) for f in range(F)], 2)
    flum /= np.maximum(frac, 1e-4)
    share = np.array([(fam == f).mean() for f in range(F)]) / max(1e-6, fg.mean())
    body = frac.copy(); body[..., k] = 0
    choice = body.argmax(2)
    # accents: chromatic minority families (gold strings, cobalt, flame) win at 30% of a block
    for f in range(k):
        if f in R and share[f] < accent_share:
            c = R[f].mean(0)
            if c.max() - c.min() > 60:
                choice = np.where(frac[..., f] >= 0.3, f, choice)
    choice = np.where(frac[..., k] >= 0.42, k, choice)
    choice[~on] = -1
    # islands up to 2 px inside another family join it (line kept)
    for f in range(k):
        l2, n2 = ndi.label(choice == f)
        for i in range(1, n2 + 1):
            comp = l2 == i
            if comp.sum() > 2:
                continue
            ring = ndi.binary_dilation(comp) & ~comp
            vals = choice[ring]
            if (vals < 0).any():
                continue
            vals = vals[vals != k]
            if len(vals):
                choice[comp] = np.bincount(vals).argmax()
    out = np.zeros((canvas, canvas, 4), np.uint8)
    ox, oy = (canvas - tw) // 2, ground - th
    for y in range(th):
        for x in range(tw):
            c = choice[y, x]
            if c < 0:
                continue
            if c == k or any(not (0 <= y + dy < th and 0 <= x + dx < tw) or choice[y + dy, x + dx] < 0 for dy, dx in N4):
                nb = [choice[y + dy, x + dx] for dy in (-1, 0, 1) for dx in (-1, 0, 1)
                      if 0 <= y + dy < th and 0 <= x + dx < tw and 0 <= choice[y + dy, x + dx] < k]
                base = max(set(nb), key=nb.count) if nb else None
                col = (R[base][0] * 0.42) if base is not None else R[k][0]
                if c == k and base is not None and R[base][0].max() < 70:
                    col = R[k][0]
            else:
                r = R[c]
                rl = r @ np.array([0.3, 0.59, 0.11])
                col = r[int(np.abs(rl - flum[y, x, c]).argmin())]
            out[oy + y, ox + x, :3] = np.clip(col, 0, 255)
            out[oy + y, ox + x, 3] = 255
    img = Image.fromarray(out, "RGBA").copy()
    tidy(img)
    strings(img, src, fg, s, ox, oy, body_strings)
    stamp_mouths(img, mouths, s, ox, oy)
    stamp_eyes(img, find_eyes(src, fg) if eyes is None else eyes, s, ox, oy)
    for (gx, gy, gw, gh, ramp) in gems:
        gem(img, ox + gx * s, oy + gy * s, gw * s, gh * s, ramp)
    return img


def gem(img, cx, cy, w, h, ramp):
    """A cut gem, drawn as pixel art: a hexagon with a dark rim, a lit upper-left facet, a darker
    lower-right facet and a mid-tone table, plus one white glint. ramp = (rim, dark, mid, light)."""
    px = img.load()
    rim, dark, mid, light = [tuple(int(v) for v in c) + (255,) for c in ramp]
    rx, ry = max(1.5, w / 2), max(1.8, h / 2)
    def inside(x, y, k=1.0):
        dx, dy = abs(x - cx) / (rx * k), abs(y - cy) / (ry * k)
        return dx <= 1 and dy + 0.5 * dx <= 1          # pointy-top hexagon
    pts = [(x, y) for y in range(int(cy - ry - 1), int(cy + ry + 2)) for x in range(int(cx - rx - 1), int(cx + rx + 2))
           if inside(x + 0.5, y + 0.5) and 0 <= x < img.width and 0 <= y < img.height]
    S_ = set(pts)
    for (x, y) in pts:
        edge = any((x + dx, y + dy) not in S_ for dx, dy in N4)
        if edge:
            c = rim
        elif inside(x + 0.5, y + 0.5, 0.55):
            c = mid
        elif (x + 0.5 - cx) / rx + (y + 0.5 - cy) / ry < 0:
            c = light
        else:
            c = dark
        px[x, y] = c
    inner = [p for p in pts if inside(p[0] + 0.5, p[1] + 0.5, 0.55)]
    if inner:
        g = min(inner, key=lambda p: p[0] + p[1])
        px[g] = (255, 255, 255, 255)


def stamp_mouths(img, mouths, s, ox, oy):
    px = img.load()
    for (mx, my, kind) in mouths:
        cx, cy = int(round(ox + mx * s)), int(round(oy + my * s))
        if kind == "open":            # a little open mouth: dark with a pink tongue
            for dx, dy, c in ((-1, 0, (52, 20, 50)), (0, 0, (52, 20, 50)), (1, 0, (52, 20, 50)), (0, 1, (214, 110, 150)), (-1, 1, (90, 34, 74)), (1, 1, (90, 34, 74))):
                if px[cx + dx, cy + dy][3]:
                    px[cx + dx, cy + dy] = c + (255,)
        elif kind == "grin":          # a wide sly grin
            for dx, dy in ((-2, -1), (-1, 0), (0, 0), (1, 0), (2, -1)):
                if px[cx + dx, cy + dy][3]:
                    px[cx + dx, cy + dy] = (52, 20, 50, 255)
            if px[cx, cy + 1][3]:
                px[cx, cy + 1] = (120, 50, 100, 255)
        elif kind == "teeth":         # Sableye's jagged grin: a dark mouth line with white teeth along it
            for dx in range(-3, 4):
                if px[cx + dx, cy][3]:
                    px[cx + dx, cy] = (236, 236, 244, 255) if dx % 2 == 0 else (40, 20, 50, 255)
                if px[cx + dx, cy + 1][3]:
                    px[cx + dx, cy + 1] = (40, 20, 50, 255)
            for dx in (-4, 4):
                if px[cx + dx, cy - 1][3]:
                    px[cx + dx, cy - 1] = (40, 20, 50, 255)
        elif kind == "smile":         # a small closed smile
            for dx, dy in ((-1, -1), (0, 0), (1, 0), (2, -1)):
                if px[cx + dx, cy + dy][3]:
                    px[cx + dx, cy + dy] = (84, 40, 92, 255)


def strings(img, src, fg, s, ox, oy, on_body=True):
    """Thin gold strings (too thin to survive the vote) are redrawn as clean one-pixel lines along their
    skeleton, ending in a bead where the painting has one."""
    from skimage.morphology import skeletonize
    hsv = cv2.cvtColor(np.ascontiguousarray(src), cv2.COLOR_RGB2HSV).astype(int)
    gold = fg & (hsv[..., 0] >= 16) & (hsv[..., 0] <= 30) & (hsv[..., 1] > 150) & (hsv[..., 2] > 175)
    thin = gold & ~ndi.binary_opening(gold, iterations=3)
    l_, n_ = ndi.label(thin, structure=np.ones((3, 3)))
    if n_:                                         # only real strings: long runs, not flecks in the wood grain
        sizes = ndi.sum(thin, l_, range(1, n_ + 1))
        thin = np.isin(l_, [i + 1 for i, z in enumerate(sizes) if z > 120])
    sk = skeletonize(thin)
    if not sk.any():
        return
    px = img.load()
    W_, H_ = img.size
    hit = {}
    for y, x in zip(*np.nonzero(sk)):
        X, Y = int(ox + x * s), int(oy + y * s)
        hit[(X, Y)] = hit.get((X, Y), 0) + 1
    lit, dark = (236, 196, 84, 255), (150, 104, 30, 255)
    for (X, Y), c in hit.items():
        if c < 2 or not (0 <= X < W_ and 0 <= Y < H_) or (not on_body and px[X, Y][3]):
            continue
        px[X, Y] = lit if px[X, Y][3] == 0 or (0.3 * px[X, Y][0] + 0.59 * px[X, Y][1] + 0.11 * px[X, Y][2]) < 150 else dark


def tidy(img):
    """Spurs off, specks off, lone pixels into their neighbours, lit-side outline lighter."""
    px = img.load()
    W_, H_ = img.size
    for _ in range(3):
        a = np.asarray(img)[..., 3] > 0
        nbc = ndi.convolve(a.astype(int), np.ones((3, 3), int), mode="constant") - a
        spur = a & (nbc <= 1)
        for y, x in zip(*np.nonzero(spur)):
            px[int(x), int(y)] = (0, 0, 0, 0)
    a = np.asarray(img)[..., 3] > 0
    lab, n = ndi.label(a, structure=np.ones((3, 3)))
    if n > 1:
        sizes = ndi.sum(a, lab, range(1, n + 1))
        for i, s in enumerate(sizes):
            if s < 8:
                for y, x in zip(*np.nonzero(lab == i + 1)):
                    px[int(x), int(y)] = (0, 0, 0, 0)
    for y in range(1, H_ - 1):
        for x in range(1, W_ - 1):
            p = px[x, y]
            if not p[3]:
                continue
            nb = [px[x + dx, y + dy] for dy in (-1, 0, 1) for dx in (-1, 0, 1) if dx or dy]
            if all(q[3] for q in nb) and all(q[:3] != p[:3] for q in nb):
                px[x, y] = max(set(nb), key=nb.count)


def show(imgs, path, z=6, bg=(72, 80, 104, 255)):
    out = Image.new("RGBA", (96 * z * len(imgs), 96 * z), bg)
    for i, im in enumerate(imgs):
        b = Image.new("RGBA", (96, 96), bg); b.alpha_composite(im)
        out.alpha_composite(b.resize((96 * z, 96 * z), Image.NEAREST), (i * 96 * z, 0))
    out.save(path)


# --------------------------------------------------------------------------------------------- Alberica
ALB = "/home/claude/frost-thaw/build/concept/alberica_concept.png"
ALB_BOX = {"lutling": (90, 190, 400, 606), "hauntello": (536, 0, 962, 620), "chorumbra": (982, 0, 1524, 614)}
ALB_SIZE = {"lutling": 66, "hauntello": 88, "chorumbra": 90}


# hand-placed faces, in sheet coordinates: eyes (x, y, w, h, iris) and mouths (x, y, kind)
ALB_FACE = {
    "lutling": ([(213, 462, 16, 18, (96, 40, 92)), (252, 468, 18, 20, (96, 40, 92))], [(232, 492, "open")]),
    "hauntello": ([(697, 425, 16, 18, (110, 46, 104)), (751, 425, 22, 16, (110, 46, 104))], [(735, 452, "grin")]),
    "chorumbra": ([(1225, 272, 18, 16, (140, 46, 120)), (1276, 259, 24, 18, (140, 46, 120))], [(1264, 304, "smile")]),
}


def alberica(name, size=None, ground=90, canvas=96):
    x0, y0, x1, y1 = ALB_BOX[name]
    src = np.asarray(Image.open(ALB).convert("RGB"))[y0:y1, x0:x1]
    fg = cut_main(src)
    eyes, mouths = ALB_FACE[name]
    eyes = [(x - x0, y - y0, w, h, c) for (x, y, w, h, c) in eyes]
    mouths = [(x - x0, y - y0, kd) for (x, y, kd) in mouths]
    return reduce_sheet(src, fg, size or ALB_SIZE[name], ground=ground if size else 92, canvas=canvas,
                        body_strings=(name != "lutling"), eyes=eyes, mouths=mouths, k=9)


if __name__ == "__main__":
    imgs = [alberica(n) for n in ("lutling", "hauntello", "chorumbra")]
    for n, im in zip(("lutling", "hauntello", "chorumbra"), imgs):
        im.save(SCR + f"alb_{n}_96.png")
    show(imgs, SCR + "alb_zoom.png")


# --------------------------------------------------------------------------------------------- Wyn
WYN = "/home/claude/frost-thaw/build/concept/wyn_concept.png"
WYN_BOX = {"sableye": (110, 180, 470, 618), "sporeye": (580, 140, 880, 622), "myconarch": (985, 8, 1500, 622)}
WYN_SIZE = {"sableye": 62, "sporeye": 76, "myconarch": 93}


def wyn(name, size=None, ground=92, canvas=96):
    x0, y0, x1, y1 = WYN_BOX[name]
    src = np.asarray(Image.open(WYN).convert("RGB"))[y0:y1, x0:x1]
    fg = cut_main(src)
    gems = [(x - x0, y - y0, w, h, r) for (x, y, w, h, r) in WYN_GEMS.get(name, [])]
    mouths = [(x - x0, y - y0, kd) for (x, y, kd) in WYN_MOUTH.get(name, [])]
    return reduce_sheet(src, fg, size or WYN_SIZE[name], k=8, ground=ground, canvas=canvas, eyes=[], body_strings=False,
                        gems=gems, mouths=mouths)


WYN_MOUTH = {"sporeye": [(748, 392, "teeth")]}


ICE = ((40, 70, 120), (92, 150, 206), (150, 200, 238), (214, 240, 255))          # Sableye's pale-blue gem eyes
JADE = ((24, 90, 70), (60, 170, 130), (120, 226, 178), (200, 255, 226))           # Myconarch's jade crystal
WYN_GEMS = {
    "sporeye": [(712, 340, 58, 60, ICE), (800, 363, 42, 52, ICE)],
    "myconarch": [(1148, 172, 30, 36, JADE), (1213, 158, 40, 40, JADE), (1185, 262, 36, 46, JADE)],
}


# --------------------------------------------------------------------------------------------- semantic reduction
def reduce_semantic(src, fg, size, classify, tones, ground=92, canvas=96, gems=(), mouths=(), simplify=1.3, smooth=1.8,
                    rims=(), inner_lines=True, line_len=3, line_hits=None, guide=None, guide_box=(0, 0), parts=(),
                    caps=(), restyle=False, fold=True, post=None):
    """Like reduce_sheet, but with named materials and clean shading bands:
       - the material map is simplified at painting scale (a majority filter about one sprite pixel wide),
         so thin strands and flecks that can't survive at 96px are gone before the vote
       - each material is shaded in a few bands from a heavily smoothed light value (form, not texture),
         with thresholds at that material's own quantiles"""
    ys, xs = np.nonzero(fg)
    bx, by = xs.min(), ys.min()
    src, fg = src[ys.min():ys.max() + 1, xs.min():xs.max() + 1], fg[ys.min():ys.max() + 1, xs.min():xs.max() + 1]
    src = np.ascontiguousarray(src)
    gems = [(x - bx, y - by, w, h, r) for (x, y, w, h, r) in gems]
    mouths = [(x - bx, y - by, kd) for (x, y, kd) in mouths]
    h, w = fg.shape
    s = size / max(h, w)
    # strands thinner than about half a sprite pixel can't be drawn: the silhouette is opened first
    r_ = max(1, int(round(0.5 / s)))
    disk = np.hypot(*np.mgrid[-r_:r_ + 1, -r_:r_ + 1]) <= r_
    fg = ndi.binary_opening(fg, structure=disk)
    lab_, n_ = ndi.label(fg)
    if n_ > 1:
        sz = ndi.sum(fg, lab_, range(1, n_ + 1))
        fg = lab_ == (np.argmax(sz) + 1)
    mat, names = classify(src, fg)                    # mat: int map (-1 outside), names: list of material names
    win = max(3, int(round(simplify / s)) | 1)
    # majority filter on materials (lines excepted: they are thin by nature)
    M = len(names)
    votes = np.stack([ndi.uniform_filter((mat == i).astype(np.float32), win) for i in range(M)], 2)
    line_i = names.index("line") if "line" in names else -1
    major = votes.argmax(2)
    keep_line = (mat == line_i) & (votes[..., line_i] > 0.18) if line_i >= 0 else np.zeros_like(fg)
    mat2 = np.where(fg, np.where(keep_line, line_i, major), -1)
    lum = src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
    lum_s = ndi.gaussian_filter(lum, smooth / s)
    tw, th = max(1, round(w * s)), max(1, round(h * s))
    cov = cv2.resize(fg.astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA)
    on = cov >= 0.5
    frac = np.stack([cv2.resize((mat2 == i).astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA) for i in range(M)], 2)
    flum = np.stack([cv2.resize(np.where(mat2 == i, lum_s, 0).astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA) for i in range(M)], 2)
    flum /= np.maximum(frac, 1e-4)
    body = frac.copy()
    if line_i >= 0:
        body[..., line_i] = 0
    choice = body.argmax(2)
    if line_i >= 0:
        choice = np.where(frac[..., line_i] >= 0.45, line_i, choice)
    choice[~on] = -1
    # band thresholds per material from the painting's own (smoothed) light values
    bands = {}
    for i, nm in enumerate(names):
        if nm == "line" or nm not in tones:
            continue
        v = lum_s[mat2 == i]
        if len(v):
            bands[i] = np.quantile(v, np.linspace(0, 1, len(tones[nm]) + 1)[1:-1])
    tone = np.zeros((th, tw), int)
    for y in range(th):
        for x in range(tw):
            c = choice[y, x]
            if c in bands:
                tone[y, x] = int(np.searchsorted(bands[c], flum[y, x, c]))
    for _ in range(3):                                # bands into clean clusters
        t2 = tone.copy()
        for y in range(th):
            for x in range(tw):
                c = choice[y, x]
                if c not in bands:
                    continue
                nb = [tone[y + dy, x + dx] for dy, dx in N4 if 0 <= y + dy < th and 0 <= x + dx < tw and choice[y + dy, x + dx] == c]
                if len(nb) >= 2 and nb.count(tone[y, x]) == 0:
                    t2[y, x] = max(set(nb), key=nb.count)
        tone = t2
    out = np.zeros((canvas, canvas, 4), np.uint8)
    ox, oy = (canvas - tw) // 2, ground - th
    for y in range(th):
        for x in range(tw):
            c = choice[y, x]
            if c < 0:
                continue
            nm = names[c]
            edge = any(not (0 <= y + dy < th and 0 <= x + dx < tw) or choice[y + dy, x + dx] < 0 for dy, dx in N4)
            if nm == "line" or edge:
                nb = [names[choice[y + dy, x + dx]] for dy in (-1, 0, 1) for dx in (-1, 0, 1)
                      if 0 <= y + dy < th and 0 <= x + dx < tw and choice[y + dy, x + dx] >= 0 and names[choice[y + dy, x + dx]] != "line"]
                base = max(set(nb), key=nb.count) if nb else nm
                col = np.array(tones.get(base, tones.get("line"))[0]) * (0.55 if base != "line" else 1.0)
                lit = edge and (y == 0 or choice[y - 1, x] < 0 or x == 0 or choice[y, x - 1] < 0) and nm != "line"
                if lit and base in tones:
                    col = np.array(tones[base][0])
            else:
                col = np.array(tones[nm][min(tone[y, x], len(tones[nm]) - 1)])
                # an inner rim where one material sits on another (each mushroom against the skin)
                for (a_, b_) in rims:
                    if nm == a_ and any(0 <= y + dy < th and 0 <= x + dx < tw and choice[y + dy, x + dx] >= 0
                                        and names[choice[y + dy, x + dx]] == b_ for dy, dx in N4):
                        col = np.array(tones[a_][0]) * 0.8
            out[oy + y, ox + x, :3] = np.clip(col, 0, 255)
            out[oy + y, ox + x, 3] = 255
    img = Image.fromarray(out, "RGBA").copy()
    tidy(img)
    if inner_lines:
        draw_inner_lines(img, src, fg, s, ox, oy, choice, names, tones)
    if guide:                                         # hand-chosen contour lines, in sheet coordinates
        draw_guides(img, guide, s, ox - (guide_box[0] + bx) * s, oy - (guide_box[1] + by) * s, choice, names, tones, ox, oy)
    T = lambda X, Y: (ox + (X - guide_box[0] - bx) * s, oy + (Y - guide_box[1] - by) * s)
    for c_ in caps:
        myco_cap(img, T, s, skin=tones.get("skin"), **c_)
    if restyle:
        keep = np.zeros(img.size[::-1], bool)
        for c_ in caps:
            keep |= part_mask(img, T, c_["cap"])
        small = cv2.resize(np.ascontiguousarray(src), (tw, th), interpolation=cv2.INTER_AREA)
        paint = np.zeros((img.size[1], img.size[0], 3), np.uint8)
        y0_, x0_ = max(0, oy), max(0, ox)
        y1_, x1_ = min(paint.shape[0], oy + th), min(paint.shape[1], ox + tw)
        paint[y0_:y1_, x0_:x1_] = small[y0_ - oy:y1_ - oy, x0_ - ox:x1_ - ox]
        restyle_fungus(img, keep, paint=paint)
    if parts:
        if fold:
            fold_green(img, T, parts)
        for part in parts:
            mushroom(img, T, s, **part)
    if post:
        post(img, T, s)
    stamp_mouths(img, mouths, s, ox, oy)
    for (gx, gy, gw, gh, ramp) in gems:
        gem(img, ox + gx * s, oy + gy * s, gw * s, gh * s, ramp)
    return img


def draw_inner_lines(img, src, fg, s, ox, oy, choice, names, tones, min_len=6.0, **_):
    """The painting's major interior ink lines - where an arm crosses the body, a cap meets its stem, a
    brow, a limb against the cloak. Ink is found as strokes darker than their neighbourhood, joined across
    small breaks, thinned to a centre line; only LONG strokes are kept (at least `min_len` sprite pixels:
    contours, not texture or hatching). Each is redrawn as a continuous one-pixel line, made pixel-perfect,
    in the painting's ink colour on dark skin or a deep shade of a lighter material."""
    from skimage.morphology import skeletonize
    lum = src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
    k = max(5, int(round(1.0 / s)) | 1)
    closed = ndi.grey_closing(lum, size=(k, k))
    ink = (((closed - lum) > 45) | (lum < 52)) & ndi.binary_erosion(fg, iterations=max(2, int(round(0.8 / s))))
    ink = ndi.binary_closing(ink, iterations=2)
    sk = skeletonize(ink)
    lab, n = ndi.label(sk, structure=np.ones((3, 3)))
    if n:
        sizes = ndi.sum(sk, lab, range(1, n + 1))
        sk = np.isin(lab, [i + 1 for i, z in enumerate(sizes) if z * s >= min_len])
    th, tw = choice.shape
    want = np.zeros((th, tw), bool)
    ys, xs = np.nonzero(sk)
    want[np.clip((ys * s).astype(int), 0, th - 1), np.clip((xs * s).astype(int), 0, tw - 1)] = True
    # hatching (gill ribs) crowds many strokes together: thin those areas out
    dens = ndi.uniform_filter(want.astype(np.float32), 3) * 9
    want &= dens <= 4.5
    for _ in range(2):                                   # pixel-perfect: no doubled L corners
        for y in range(1, th - 1):
            for x in range(1, tw - 1):
                if not want[y, x]:
                    continue
                for (ay, ax), (by_, bx_), (cy_, cx_) in (((-1, 0), (0, -1), (-1, -1)), ((-1, 0), (0, 1), (-1, 1)),
                                                         ((1, 0), (0, -1), (1, -1)), ((1, 0), (0, 1), (1, 1))):
                    if want[y + ay, x + ax] and want[y + by_, x + bx_] and not want[y + cy_, x + cx_]:
                        want[y, x] = False
                        break
    lab, n = ndi.label(want, structure=np.ones((3, 3)))
    if n:
        sizes = ndi.sum(want, lab, range(1, n + 1))
        want = np.isin(lab, [i + 1 for i, z in enumerate(sizes) if z >= 3])
    px = img.load()
    for y, x in zip(*np.nonzero(want)):
        c = choice[y, x]
        X, Y = int(ox + x), int(oy + y)
        if c < 0 or not px[X, Y][3] or names[c] == "line":
            continue
        nm = names[c]
        col = np.array(tones["line"][0]) if (nm == "skin" and "line" in tones) else np.array(tones[nm][0]) * 0.55
        px[X, Y] = tuple(int(v) for v in np.clip(col, 0, 255)) + (255,)
    return int(want.sum())


def draw_guides(img, guides, s, tx, ty, choice, names, tones, ox, oy):
    """Lines a pixel artist would decide on: polylines picked from the painting (sheet coordinates),
    drawn one pixel wide with no doubled corners, in ink on skin or a deep shade on lighter parts."""
    px = img.load()
    pts = set()
    for poly in guides:
        P = [(tx + x * s, ty + y * s) for (x, y) in poly]
        for (x0_, y0_), (x1_, y1_) in zip(P, P[1:]):
            n = int(max(abs(x1_ - x0_), abs(y1_ - y0_)) * 2) + 1
            for i in range(n + 1):
                t = i / n
                pts.add((int(round(x0_ + (x1_ - x0_) * t)), int(round(y0_ + (y1_ - y0_) * t))))
    keep = set(pts)
    for (x, y) in pts:                                    # pixel-perfect
        for (ax, ay), (bx_, by_) in (((-1, 0), (0, -1)), ((1, 0), (0, -1)), ((-1, 0), (0, 1)), ((1, 0), (0, 1))):
            if (x + ax, y + ay) in keep and (x + bx_, y + by_) in keep and (x + ax + bx_, y + ay + by_) not in keep:
                keep.discard((x, y))
                break
    for (x, y) in keep:
        if not (0 <= x < img.width and 0 <= y < img.height) or not px[x, y][3]:
            continue
        cy, cx = y - oy, x - ox
        nm = names[choice[cy, cx]] if (0 <= cy < choice.shape[0] and 0 <= cx < choice.shape[1] and choice[cy, cx] >= 0) else "skin"
        col = np.array(tones["line"][0]) if nm in ("skin", "line") else np.array(tones[nm][0]) * 0.55
        px[x, y] = tuple(int(v) for v in np.clip(col, 0, 255)) + (255,)


WYN_LINES = {"sporeye": [
    [(630, 472), (657, 480), (683, 477), (702, 474)],                      # left forearm, top edge
    [(612, 503), (640, 506), (667, 502), (692, 494)],                      # left forearm, underside
    [(700, 537), (730, 541), (763, 531), (790, 528), (812, 520)],          # right forearm over the thigh
    [(748, 502), (770, 516), (790, 526)],                                  # right forearm, top edge
    [(700, 538), (690, 548), (672, 562), (660, 574)],                      # left thigh, inner
    [(752, 560), (735, 576), (724, 588)],                                  # right knee
    [(672, 368), (690, 378), (712, 386), (730, 393)],                      # jaw, left
    [(778, 394), (796, 387), (812, 376)],                                  # jaw, right
],
    "myconarch": [
    [(1180, 322), (1184, 350), (1190, 380)],                               # the midline of the chest and belly
    [(1168, 372), (1184, 392), (1199, 406)],                               # groin, left
    [(1224, 378), (1212, 394), (1202, 406)],                               # groin, right
    [(1200, 410), (1190, 445), (1182, 480), (1172, 515)],                  # the front leg against the back one
]}

LILAC = ((50, 38, 92), (112, 104, 186), (166, 162, 226), (226, 226, 255))
CAP = {"out": (22, 64, 56), "out_lit": (34, 96, 80), "dark": (60, 162, 126), "mid": (116, 218, 170),
       "light": (176, 246, 206), "spot": (236, 255, 242), "under": (214, 240, 168), "gill": (150, 190, 112),
       "stem": (200, 230, 160), "stem_dark": (150, 190, 120)}


def part_mask(img, T, poly):
    from PIL import ImageDraw
    m = Image.new("L", img.size, 0)
    ImageDraw.Draw(m).polygon([T(x, y) for (x, y) in poly], fill=1)
    return np.asarray(m).astype(bool)


def fold_green(img, T, parts, grow=1):
    """Every painting-derived green pixel outside the hand-drawn mushrooms goes back to the nearest skin
    colour: the mushrooms are drawn as whole shapes, so leftovers are only noise."""
    U = np.zeros(img.size[::-1], bool)
    for p in parts:
        U |= part_mask(img, T, p["cap"])
        if p.get("stem"):
            U |= part_mask(img, T, p["stem"])
    U = ndi.binary_dilation(U, iterations=grow)
    arr = np.asarray(img).copy()
    rgb = arr[..., :3].astype(int)
    op = arr[..., 3] > 0
    green = (rgb[..., 1] > rgb[..., 0] + 10) & op
    skin = op & ~green & ~U & (rgb[..., 2] > rgb[..., 1])
    if not skin.any():
        return
    idx = ndi.distance_transform_edt(~skin, return_distances=False, return_indices=True)
    for (y, x) in zip(*np.nonzero(green & ~U)):
        arr[y, x] = arr[idx[0][y, x], idx[1][y, x]]
    img.paste(Image.fromarray(arr, "RGBA"))


def mushroom(img, T, s, cap, stem=None, crystal=None, spots=3, pal=CAP):
    """A glowcap drawn as pixel art from hand-traced shapes (sheet coordinates): a crystal at its root,
    a pale ribbed stem, a mint cap with a lit crown, white spots and a pale gill underside, the stem in
    shadow just under the cap, and a dark 1px outline around the whole mushroom. Painting-derived greens
    left around it are folded back into the skin so the shape reads cleanly."""
    from PIL import ImageDraw
    W, H = img.size
    px = img.load()
    mask = lambda poly: part_mask(img, T, poly)
    C = mask(cap)
    St = mask(stem) & ~C if stem else np.zeros_like(C)
    U = C | St
    px = img.load()
    P = lambda k: tuple(pal[k]) + (255,)
    ys, xs = np.nonzero(U)
    if not len(ys):
        return
    cys, cxs = np.nonzero(C)
    top, bot, left, right = cys.min(), cys.max(), cxs.min(), cxs.max()
    for (y, x) in zip(ys, xs):
        inU = lambda yy, xx: 0 <= yy < H and 0 <= xx < W and U[yy, xx]
        edge = not all(inU(y + dy, x + dx) for dy, dx in N4)
        if edge:
            lit = not inU(y - 1, x) and (x - left) < (right - left) * 0.6
            px[x, y] = P("out_lit" if lit else "out")
            continue
        if C[y, x]:
            below_out = not inU(y + 1, x) or (St[y + 1, x] if y + 1 < H else False)
            u = (x - left) / max(1, right - left)
            v = (y - top) / max(1, bot - top)
            if below_out or not C[min(H - 1, y + 2), x] and not St[min(H - 1, y + 2), x]:
                c = "under"                               # gill underside, the pale band at the cap's lip
            elif (not inU(y - 2, x) or not inU(y - 3, x) and u < 0.6) or (u < 0.35 and v < 0.5):
                c = "light"
            elif u + v > 1.35:
                c = "dark"
            else:
                c = "mid"
            px[x, y] = P(c)
        else:
            if inU(y - 1, x) and C[y - 1, x]:
                c = "gill"                                # shadow right under the cap
            elif not inU(y, x + 1) or not inU(y, x - 1) or (x % 3 == 0 and y - top < (bot - top) + 4):
                c = "stem_dark"
            else:
                c = "stem"
            px[x, y] = P(c)
    # spots on the crown
    w = right - left
    for k in range(spots):
        sx = int(left + w * (0.3 + 0.25 * k))
        col = np.nonzero(C[:, sx])[0]
        if len(col) < 4:
            continue
        sy = col.min() + 2 + (k % 2)
        if C[sy, sx] and px[sx, sy][:3] in (pal["mid"], pal["light"]):
            px[sx, sy] = P("spot")
    if crystal:                                           # the crystal sits in front of the stem's root
        cx, cy = T(crystal[0], crystal[1])
        gem(img, cx, cy, crystal[2] * s, crystal[3] * s, crystal[4] if len(crystal) > 4 else LILAC)


def is_purple(c):
    return c[3] > 0 and c[2] > c[1] + 4


def myco_cap(img, T, s, cap, dome, centre, crystals=(), skin=None, pal=CAP):
    """Myconarch's great cap, drawn by hand from traced shapes: a purple dome with a lit crown, a mint brim
    under it, the pale gill underside with gills radiating from the stalk, a mint lip and a dark outline -
    and the head and horns (left as painted) inked where they cross the gills."""
    W, H = img.size
    px = img.load()
    C, D = part_mask(img, T, cap), part_mask(img, T, dome)
    D &= C
    cx, cy = T(*centre)
    skin = [tuple(int(v) for v in c) for c in (skin or [(44, 26, 72), (68, 44, 106), (92, 66, 140), (118, 94, 170)])]
    ink = (26, 14, 36, 255)
    P = lambda k: tuple(pal[k]) + (255,)
    orig = {(x, y): px[x, y] for y in range(H) for x in range(W)}
    inC = lambda x, y: 0 <= x < W and 0 <= y < H and C[y, x]
    inD = lambda x, y: 0 <= x < W and 0 <= y < H and D[y, x]
    head = lambda x, y: inC(x, y) and not inD(x, y) and is_purple(orig[(x, y)])
    ys, xs = np.nonzero(C)
    for (y, x) in zip(ys, xs):
        if head(x, y):
            continue
        outer = not all(inC(x + dx, y + dy) for dx, dy in N4)
        if inD(x, y):
            if outer:
                px[x, y] = tuple(skin[0]) + (255,) if not inC(x, y - 1) and x < cx else ink
            elif not inD(x, y - 1) or not inD(x, y - 2) and x < cx:
                px[x, y] = tuple(skin[3]) + (255,)
            elif not inD(x, y + 1):
                px[x, y] = tuple(skin[1]) + (255,)
            else:
                px[x, y] = tuple(skin[2]) + (255,)
            continue
        if outer:
            px[x, y] = P("out")
        elif any(inD(x, y - k) for k in (1, 2)):
            px[x, y] = P("light") if inD(x, y - 1) else P("mid")         # the brim under the dome
        elif not inC(x, y + 2):
            px[x, y] = P("mid")                                          # mint lip along the bottom
        elif not inC(x, y + 4) or not inC(x - 3, y) or not inC(x + 3, y):
            px[x, y] = P("light")                                        # mint toward the rim
        else:
            px[x, y] = P("under")
    # gills: clean one-pixel rays fanning from the stalk to the rim
    gill_ok = lambda x, y: inC(x, y) and px[x, y] in (P("under"), P("light"))
    for a in np.arange(3, 180, 12):
        t = np.radians(a)
        dx_, dy_ = np.cos(t), np.sin(t)
        last = None
        for k in range(8, 400):
            X, Y = int(cx + dx_ * k * 0.5), int(cy + dy_ * k * 0.5)
            if (X, Y) == last:
                continue
            last = (X, Y)
            if not (0 <= X < W and 0 <= Y < H):
                break
            if gill_ok(X, Y):
                px[X, Y] = P("gill")
    # ink where the head and horns cross the gills
    for (y, x) in zip(ys, xs):
        if head(x, y) and any(inC(x + dx, y + dy) and not head(x + dx, y + dy) and not inD(x + dx, y + dy) for dx, dy in N4):
            px[x, y] = ink
    for (gx, gy, gw, gh, ramp) in crystals:
        X, Y = T(gx, gy)
        gem(img, X, Y, gw * s, gh * s, ramp)


def restyle_fungus(img, keep=None, pal=CAP, paint=None):
    """Bright, clean greens for every leftover painting-derived fungus pixel (the cloak of gills): a dark
    green outline wherever it meets skin or the background, then tones read from the painting itself
    (white-yellow gill skirts, mint caps, deeper green in shadow) and the skirt's ribs where the painting
    has a darker stroke than its surroundings."""
    W, H = img.size
    arr = np.asarray(img).copy()
    rgb = arr[..., :3].astype(int)
    op = arr[..., 3] > 0
    G = op & (rgb[..., 1] > rgb[..., 0] + 10)
    if keep is not None:
        G &= ~keep
    src = paint.astype(int) if paint is not None else rgb
    lum = src @ np.array([0.3, 0.59, 0.11])
    loc = ndi.uniform_filter(lum, 3)
    out = arr.copy()
    for (y, x) in zip(*np.nonzero(G)):
        nb = [(y + dy, x + dx) for dy, dx in N4]
        bad = [not (0 <= yy < H and 0 <= xx < W) or not op[yy, xx] or (not G[yy, xx] and not (keep is not None and keep[yy, xx]))
               for (yy, xx) in nb]
        r_, g_, b_ = src[y, x]
        mint = b_ > r_ + 25
        if any(bad):
            c = pal["out"]
        elif lum[y, x] < 125:
            c = pal["dark"]
        elif lum[y, x] < loc[y, x] - 14 and not mint:
            c = pal["gill"]                               # a rib
        elif mint:
            c = pal["light"] if lum[y, x] > 185 else pal["mid"]
        elif lum[y, x] > 175:
            c = pal["under"]
        else:
            c = pal["gill"]
        out[y, x, :3] = c
    img.paste(Image.fromarray(out, "RGBA"))


MYCO_CAP = dict(
    cap=[(995, 153), (1015, 128), (1045, 108), (1075, 83), (1110, 58), (1150, 28), (1185, 18), (1215, 23), (1245, 45),
         (1285, 58), (1325, 68), (1360, 93), (1385, 118), (1400, 143), (1403, 168), (1388, 194), (1347, 212), (1300, 220),
         (1260, 220), (1230, 212), (1150, 212), (1110, 212), (1060, 204), (1018, 188), (998, 172)],
    dome=[(998, 152), (1015, 128), (1045, 108), (1075, 83), (1110, 58), (1150, 28), (1185, 18), (1215, 23), (1245, 45),
          (1285, 58), (1325, 68), (1360, 92), (1378, 110), (1360, 92), (1310, 80), (1260, 72), (1210, 80), (1180, 82),
          (1135, 95), (1100, 105), (1065, 110), (1035, 120), (1010, 140)],
    centre=(1195, 30),
    crystals=[(1180, 75, 62, 92, JADE)])


SPOREYE_PARTS = [
    dict(cap=[(680, 233), (690, 225), (703, 218), (717, 207), (730, 198), (747, 195), (767, 195), (783, 203), (797, 217),
              (810, 233), (823, 250), (827, 263), (822, 272), (810, 272), (797, 267), (783, 260), (767, 257), (747, 255),
              (730, 252), (720, 249), (703, 247), (690, 244), (680, 240)],
         stem=[(728, 250), (776, 250), (768, 270), (762, 290), (740, 290), (734, 270)],
         crystal=(740, 292, 58, 58), spots=4),
    dict(cap=[(587, 397), (590, 380), (598, 365), (610, 355), (627, 352), (643, 355), (657, 362), (665, 373), (662, 383),
              (647, 386), (630, 388), (617, 396), (607, 404), (593, 407)],
         stem=[(622, 386), (648, 384), (645, 404), (626, 406)],
         crystal=(636, 422, 50, 44), spots=3),
    dict(cap=[(794, 403), (798, 393), (810, 388), (827, 389), (840, 395), (847, 407), (848, 424), (842, 434),
              (830, 431), (820, 425), (806, 420), (796, 413)],
         stem=[(810, 421), (826, 425), (824, 440), (812, 440)],
         crystal=(800, 434, 34, 40), spots=2),
    dict(cap=[(680, 443), (683, 430), (693, 420), (707, 412), (723, 408), (740, 410), (753, 417), (767, 427), (775, 440),
              (777, 456), (770, 463), (753, 459), (733, 457), (713, 457), (697, 457), (683, 453)],
         stem=[(703, 455), (753, 455), (748, 472), (744, 488), (712, 488), (707, 472)],
         crystal=(724, 500, 40, 42), spots=4),
]


def wyn_classify(src, fg):
    """Purple skin; the fungus split into its parts - mint caps and pale yellow-green gills and stems -
    so each part can be outlined against the next; lilac crystal; dark line."""
    r, g, b = [src[..., i].astype(int) for i in range(3)]
    lum = 0.3 * r + 0.59 * g + 0.11 * b
    hsv = cv2.cvtColor(np.ascontiguousarray(src), cv2.COLOR_RGB2HSV).astype(int)
    H = hsv[..., 0]
    names = ["line", "skin", "fungus"]
    mat = np.full(fg.shape, 1, int)
    green = (g > r + 12) & (g >= b - 25) | ((lum > 200) & (g >= r))
    mat[green] = 2
    mat[lum < 46] = 0
    mat[~fg] = -1
    return mat, names


WYN_TONES = {"line": [(26, 14, 36)],
             "skin": [(44, 26, 72), (68, 44, 106), (92, 66, 140), (118, 94, 170)],
             "fungus": [(46, 120, 96), (92, 186, 142), (150, 232, 184), (214, 255, 230)]}


def concept_tones(src, fg, classify, n=4):
    """Each material's ramp straight from the painting: the median colour of each light band."""
    mat, names = classify(src, fg)
    lum = src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
    out = {}
    for i, nm in enumerate(names):
        px, l = src[mat == i].astype(np.float32), lum[mat == i]
        if nm == "line":
            out[nm] = [tuple(np.median(px, 0))]
            continue
        qs = np.quantile(l, np.linspace(0, 1, n + 1))
        out[nm] = [tuple(np.median(px[(l >= qs[j]) & (l <= qs[j + 1])], 0)) for j in range(n)]
    return out


WYN_STYLE = {"sporeye": dict(simplify=1.6, smooth=3.0, n=3, inner=False), "myconarch": dict(simplify=1.2, smooth=2.0, n=4, inner=False, restyle=True, fold=False)}


MYCO_PARTS = [
    dict(cap=[(1118, 240), (1130, 228), (1150, 224), (1170, 228), (1180, 238), (1172, 247), (1145, 247), (1122, 247)], spots=2),
    dict(cap=[(1092, 276), (1100, 264), (1118, 257), (1140, 258), (1152, 268), (1150, 281), (1120, 283), (1095, 285)], spots=2),
    dict(cap=[(1255, 250), (1265, 236), (1290, 230), (1315, 236), (1332, 250), (1330, 261), (1300, 259), (1262, 259)], spots=2),
    dict(cap=[(1232, 232), (1240, 218), (1262, 210), (1285, 212), (1296, 226), (1290, 236), (1260, 236), (1236, 238)], spots=2),
]
WYN_PARTS = {"sporeye": SPOREYE_PARTS, "myconarch": MYCO_PARTS}
WYN_CAPS = {"myconarch": [MYCO_CAP]}


def wyn2(name, size=None, ground=92, canvas=96, simplify=None, smooth=None, own_tones=True):
    st = WYN_STYLE.get(name, {})
    simplify = simplify or st.get("simplify", 0.9)
    smooth = smooth or st.get("smooth", 1.3)
    x0, y0, x1, y1 = WYN_BOX[name]
    src = np.asarray(Image.open(WYN).convert("RGB"))[y0:y1, x0:x1]
    fg = cut_main(src)
    gems = [(x - x0, y - y0, w, h, r) for (x, y, w, h, r) in WYN_GEMS.get(name, [])]
    mouths = [(x - x0, y - y0, kd) for (x, y, kd) in WYN_MOUTH.get(name, [])]
    tones = concept_tones(src, fg, wyn_classify, n=st.get("n", 4)) if own_tones else WYN_TONES
    return reduce_semantic(src, fg, size or WYN_SIZE[name], wyn_classify, tones, ground=ground, canvas=canvas,
                           gems=gems, mouths=mouths, simplify=simplify, smooth=smooth,
                           rims=(("fungus", "skin"),), guide=WYN_LINES.get(name), guide_box=(x0, y0),
                           parts=WYN_PARTS.get(name, ()), inner_lines=st.get("inner", True),
                           caps=WYN_CAPS.get(name, ()), restyle=st.get("restyle", False),
                           fold=st.get("fold", True))
