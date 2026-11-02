"""Cinderwright sprites from the master concept, reduced by MATERIAL rather than by colour.

Why: averaging the painting down and clustering its colours makes in-between colours - a dark line
averaged with orange fur gives brown-grey, whisker strokes give grey, the glow under the paddle gives
mauve. Those are the grey spots and stray pixels. Here every pixel of the painting is first labelled
as one material (fur, cream, soot, porcelain, cobalt, kiln glow, mouth, line). Each sprite pixel takes
one material by vote, and its shade comes from a short ramp belonging to that material only, so no
colour can appear that is not part of the design. Then: clusters cleaned, selective outline, hand-placed
eyes, nose and mouth."""
import numpy as np
import cv2
from PIL import Image
from scipy import ndimage as ndi
import from_concept as FC

SCR = FC.SCR
MATS = ["line", "fur", "cream", "soot", "porc", "cobalt", "glow", "mouth"]
M = {m: i for i, m in enumerate(MATS)}
TONES = {"fur": 4, "cream": 3, "soot": 3, "porc": 3, "cobalt": 2, "glow": 3, "mouth": 2, "line": 1}


def prepare(name):
    """Cut the creature out, paint out whiskers, find the eyes, flip to face left (as from_concept.make)."""
    x0, y0, x1, y1 = FC.BOXES[name]
    src = np.asarray(Image.open(FC.SRC).convert("RGB"))[y0:y1, x0:x1]
    fg = FC.cut_out(src)
    ys, xs = np.nonzero(fg)
    src, fg = src[ys.min():ys.max() + 1, xs.min():xs.max() + 1], fg[ys.min():ys.max() + 1, xs.min():xs.max() + 1]
    im16 = src.astype(np.int16)
    lumv = src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
    grey = ((im16.max(2) - im16.min(2)) < 40) & (lumv > 70) & (lumv < 222) & fg
    thin = grey & ~ndi.binary_opening(grey, iterations=2)
    outside = thin & ~ndi.binary_opening(fg & ~thin, iterations=2)
    fg = fg & ~outside
    src = cv2.inpaint(np.ascontiguousarray(src), (thin & fg).astype(np.uint8) * 255, 3, cv2.INPAINT_TELEA)
    lumv = src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
    darkb = (lumv < 70) & fg
    hl0 = (src.min(2) > 235) & (ndi.uniform_filter(darkb.astype(np.float32), 9) > 0.4) & fg
    eyes = []
    lab, n = ndi.label(ndi.binary_dilation(darkb, iterations=2) | hl0)
    r_, g_, b_ = src[..., 0].astype(int), src[..., 1].astype(int), src[..., 2].astype(int)
    for i in set(np.unique(lab[hl0])) - {0}:              # an eye holds a white highlight
        yy, xx = np.nonzero((lab == i) & (darkb | hl0))
        reg = ndi.binary_dilation(lab == i, iterations=2)
        iris = reg & (r_ > 110) & (g_ > 45) & (g_ < 130) & (b_ < 70) & (r_ - b_ > 70)
        if 30 < len(yy) < 4000 and iris.sum() > 25 and (yy.max() - yy.min()) < 70:
            eyes.append((xx.mean(), yy.mean(), xx.max() - xx.min() + 1, yy.max() - yy.min() + 1, lab == i))
    # noses: dark blobs at the snout with a small highlight but no iris
    src, fg = src[:, ::-1], fg[:, ::-1]
    W_ = src.shape[1]
    eyes = [(W_ - 1 - x, y, w_, h_, m[:, ::-1]) for (x, y, w_, h_, m) in eyes]
    return src, fg, eyes


def classify(src, fg):
    """One material per painting pixel."""
    hsv = cv2.cvtColor(np.ascontiguousarray(src), cv2.COLOR_RGB2HSV).astype(int)
    H, Sa, V = hsv[..., 0], hsv[..., 1], hsv[..., 2]
    r, g, b = src[..., 0].astype(int), src[..., 1].astype(int), src[..., 2].astype(int)
    lum = 0.3 * r + 0.59 * g + 0.11 * b
    mat = np.full(src.shape[:2], M["fur"], np.int8)
    mat[(Sa < 95) & (V < 140)] = M["soot"]                                   # charcoal socks, ear rims
    mat[(Sa < 45) & (V >= 140)] = M["porc"]                                  # glazed white and its grey shading
    mat[(H >= 95) & (H <= 130) & (Sa >= 45) & (V >= 150) & (Sa < 110)] = M["porc"]   # porcelain's blue-grey shade
    mat[(H >= 95) & (H <= 135) & (Sa >= 110)] = M["cobalt"]
    mat[(H >= 8) & (H <= 32) & (Sa >= 25) & (Sa < 115) & (V >= 170)] = M["cream"]
    mat[((H >= 17) & (H <= 32) & (Sa >= 110) & (V >= 245)) | ((H >= 135) & (H < 165) & (Sa > 40))] = M["glow"]
    mat[((H >= 165) | (H <= 3)) & (Sa > 70) & (V > 90) & (V < 250)] = M["mouth"]
    mat[lum < 62] = M["line"]
    near_porc = ndi.distance_transform_edt(~np.isin(mat, [M["porc"], M["cobalt"], M["glow"]])) < 18
    mat[(mat == M["mouth"]) & near_porc] = M["glow"]
    mat[~fg] = -1
    # small islands of soot or white are not design (whisker roots, inpaint residue, paper specks, the
    # mouth line's soft edge): they take the nearest real material around them
    bad = np.zeros(mat.shape, bool)
    for m_, limit in (("soot", 700), ("porc", 120), ("glow", 40), ("mouth", 25)):
        lab, n = ndi.label(mat == M[m_])
        if n:
            sizes = ndi.sum(np.ones_like(lab), lab, range(1, n + 1))
            small = np.isin(lab, [i + 1 for i, s_ in enumerate(sizes) if s_ < limit])
            bad |= small
    good = (mat >= 0) & ~bad & (mat != M["line"])
    if bad.any() and good.any():
        _, (iy, ix) = ndi.distance_transform_edt(~good, return_indices=True)
        mat[bad] = mat[iy[bad], ix[bad]]
    return mat, lum


def ramps(src, mat):
    """A short ramp per material, from that material's own pixels in the painting."""
    out = {}
    for m, k in TONES.items():
        px = src[mat == M[m]].astype(np.float32)
        if len(px) < k * 5:
            continue
        lum = px @ np.array([0.3, 0.59, 0.11], np.float32)
        qs = np.quantile(lum, np.linspace(0, 1, k + 1))
        cols = []
        for i in range(k):
            sel = (lum >= qs[i]) & (lum <= qs[i + 1])
            cols.append(np.median(px[sel], 0) if sel.any() else px.mean(0))
        out[m] = np.array(cols)
    out["glow"] = np.array([(214, 92, 30), (248, 146, 48), (255, 208, 104)], float)     # kiln glow stays orange
    return out


def reduce(name, size=None, ground=90, canvas=96):
    src, fg, eyes = prepare(name)
    mat, lum = classify(src, fg)
    R = ramps(src, mat)
    h, w = fg.shape
    k = (size or FC.SIZE[name]) / max(h, w)
    tw, th = max(1, round(w * k)), max(1, round(h * k))
    cov = cv2.resize(fg.astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA)
    on = cov >= 0.5
    lab_, n_ = ndi.label(~on)                       # pin-holes inside the body are not see-through
    if n_:
        sizes = ndi.sum(np.ones_like(lab_), lab_, range(1, n_ + 1))
        edge_ids = set(np.unique(np.concatenate([lab_[0], lab_[-1], lab_[:, 0], lab_[:, -1]])))
        for i, s_ in enumerate(sizes):
            if s_ <= 4 and (i + 1) not in edge_ids:
                on[lab_ == i + 1] = True
    frac = np.stack([cv2.resize((mat == i).astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA) for i in range(len(MATS))], 2)
    mlum = np.stack([cv2.resize(np.where(mat == i, lum, 0).astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA) for i in range(len(MATS))], 2)
    mlum = mlum / np.maximum(frac, 1e-4)
    # a pixel's material: thin accents win when they hold enough of the block
    body = frac.copy(); body[..., M["line"]] = 0
    choice = body.argmax(2)
    for m, th_ in (("cobalt", 0.3), ("mouth", 0.35), ("glow", 0.4), ("line", 0.42)):
        choice = np.where(frac[..., M[m]] >= th_, M[m], choice)
    choice[~on] = -1
    # tidy the material map: a lone material pixel joins its neighbours (lines and accents kept if 2+ long)
    for _ in range(2):
        c2 = choice.copy()
        for y in range(th):
            for x in range(tw):
                c = choice[y, x]
                if c < 0:
                    continue
                nb = [choice[y + dy, x + dx] for dy in (-1, 0, 1) for dx in (-1, 0, 1)
                      if (dx or dy) and 0 <= y + dy < th and 0 <= x + dx < tw and choice[y + dy, x + dx] >= 0]
                same = sum(1 for q in nb if q == c)
                if same == 0 and len(nb) >= 3:
                    c2[y, x] = max(set(nb), key=nb.count)
        choice = c2
    # little islands (up to 4 px) of fur, cream, soot or white sealed inside another material join it
    for m_ in ("fur", "cream", "soot", "porc"):
        lab_, n_ = ndi.label(choice == M[m_])
        for i in range(1, n_ + 1):
            comp = lab_ == i
            if comp.sum() > 4:
                continue
            ring = ndi.binary_dilation(comp) & ~comp
            vals = choice[ring]
            if (vals < 0).any():
                continue
            vals = vals[vals != M["line"]]
            if len(vals):
                choice[comp] = np.bincount(vals).argmax()
    # tones: each material's own ramp, by the luminance of that material inside the block
    tone = np.zeros((th, tw), int)
    for y in range(th):
        for x in range(tw):
            c = choice[y, x]
            if c < 0:
                continue
            m = MATS[c]
            if m not in R:
                continue
            rl = R[m] @ np.array([0.3, 0.59, 0.11])
            tone[y, x] = int(np.abs(rl - mlum[y, x, c]).argmin())
    # tone clusters: a lone tone joins its same-material neighbours
    for _ in range(2):
        t2 = tone.copy()
        for y in range(th):
            for x in range(tw):
                c = choice[y, x]
                if c < 0:
                    continue
                nb = [tone[y + dy, x + dx] for dy in (-1, 0, 1) for dx in (-1, 0, 1)
                      if (dx or dy) and 0 <= y + dy < th and 0 <= x + dx < tw and choice[y + dy, x + dx] == c]
                n4 = [tone[y + dy, x + dx] for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1))
                      if 0 <= y + dy < th and 0 <= x + dx < tw and choice[y + dy, x + dx] == c]
                if len(nb) >= 4 and (nb.count(tone[y, x]) == 0 or (len(n4) >= 3 and n4.count(tone[y, x]) == 0)):
                    t2[y, x] = max(set(nb), key=nb.count)
        tone = t2
    out = np.zeros((canvas, canvas, 4), np.uint8)
    ox, oy = (canvas - tw) // 2, ground - th
    N4 = ((1, 0), (-1, 0), (0, 1), (0, -1))
    for y in range(th):
        for x in range(tw):
            c = choice[y, x]
            if c < 0:
                continue
            m = MATS[c]
            # line pixels (and the silhouette edge) take a deep version of the material beside them
            edge = any(not (0 <= y + dy < th and 0 <= x + dx < tw) or choice[y + dy, x + dx] < 0 for dy, dx in N4)
            if m == "line" or edge:
                if m == "line":
                    nb = [choice[y + dy, x + dx] for dy in (-1, 0, 1) for dx in (-1, 0, 1)
                          if 0 <= y + dy < th and 0 <= x + dx < tw and choice[y + dy, x + dx] >= 0 and MATS[choice[y + dy, x + dx]] != "line"]
                    base = MATS[max(set(nb), key=nb.count)] if nb else "soot"
                else:
                    base = m
                dk = {"porc": (24, 44, 120), "cobalt": (14, 28, 84), "glow": (150, 60, 20)}.get(base)
                col = np.array(dk) if dk else R.get(base, R["soot"])[0] * (0.45 if base in ("fur", "cream", "mouth") else 0.6)
            else:
                col = R[m][tone[y, x]]
            out[oy + y, ox + x, :3] = np.clip(col, 0, 255)
            out[oy + y, ox + x, 3] = 255
    img = Image.fromarray(out, "RGBA").copy()
    drop_specks(img)
    selout_light(img, R, choice, ox, oy)
    lone_pixels(img, [(ox + e[0] * k, oy + e[1] * k) for e in eyes])
    for (ex, ey, ew, eh, _) in eyes:
        cx, cy = ox + ex * k, oy + ey * k
        clean_muzzle(img, cx, cy, R)
        clean_eye(img, cx, cy, ew * k, eh * k, R)
        nose_and_mouth(img, cx, cy, MOUTH[name], R)
    return img


MOUTH = {"wickit": "open", "stoketail": "open", "forgel": "smile"}


def selout_light(img, R, choice, ox, oy):
    """Derek Yu's selective outline, applied to the silhouette:
       - one pixel thick: where the outline doubles up (a dark pixel behind another dark edge pixel,
         both touching the outside), the inner one returns to the fill colour
       - lit side lighter: edge pixels facing the light (open space up or to the left) take the
         material's shadow tone instead of the deep outline colour; underside and back stay deep"""
    px = img.load()
    W_, H_ = img.size
    def opaque(x, y):
        return 0 <= x < W_ and 0 <= y < H_ and px[x, y][3] > 0
    def lum(p):
        return 0.3 * p[0] + 0.59 * p[1] + 0.11 * p[2]
    edge = {(x, y) for y in range(H_) for x in range(W_) if opaque(x, y) and
            any(not opaque(x + dx, y + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))}
    for (x, y) in edge:
        cx, cy = x - ox, y - oy
        if not (0 <= cy < choice.shape[0] and 0 <= cx < choice.shape[1]) or choice[cy, cx] < 0:
            continue
        m = MATS[choice[cy, cx]]
        if m not in ("fur", "cream", "porc", "soot"):
            continue
        lit = (not opaque(x, y - 1) or not opaque(x - 1, y)) and opaque(x, y + 1) and opaque(x + 1, y)
        if lit:
            tone = R[m][0] if m != "porc" else np.array((60, 86, 168))
            px[x, y] = tuple(int(v) for v in np.clip(tone * (0.85 if m in ("fur", "cream") else 1.0), 0, 255)) + (255,)
    # thin doubled outline
    for (x, y) in edge:
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            ix, iy = x + dx, y + dy
            if (ix, iy) in edge or not opaque(ix, iy):
                continue
            p, q = px[x, y], px[ix, iy]
            if lum(q) < 45 and lum(p) < 60:
                around = [px[ix + a, iy + b] for a, b in ((1, 0), (-1, 0), (0, 1), (0, -1)) if opaque(ix + a, iy + b)
                          and lum(px[ix + a, iy + b]) > 70]
                if len(around) >= 2:
                    px[ix, iy] = max(set(around), key=around.count)


def lone_pixels(img, keep_near=()):
    """A pixel whose colour none of its eight neighbours shares is a stray: it takes the majority."""
    px = img.load()
    W_, H_ = img.size
    for y in range(1, H_ - 1):
        for x in range(1, W_ - 1):
            p = px[x, y]
            if not p[3] or any((x - a) ** 2 + (y - b) ** 2 < 64 for a, b in keep_near):
                continue
            nb = [px[x + dx, y + dy] for dy in (-1, 0, 1) for dx in (-1, 0, 1) if dx or dy]
            if any(q[3] == 0 for q in nb):
                continue
            if all(q[:3] != p[:3] for q in nb):
                px[x, y] = max(set(nb), key=nb.count)


def drop_specks(img, limit=8):
    """Bits of the painting that came loose from the body (a porcelain flick, a stray tuft) go, and so do
    one-pixel spurs sticking out of the outline."""
    for _ in range(3):
        a = np.asarray(img)[..., 3] > 0
        nbc = ndi.convolve(a.astype(int), np.ones((3, 3), int), mode="constant") - a
        spur = a & (nbc <= 1)
        if not spur.any():
            break
        px = img.load()
        for y, x in zip(*np.nonzero(spur)):
            px[int(x), int(y)] = (0, 0, 0, 0)
    a = np.asarray(img)[..., 3] > 0
    lab, n = ndi.label(a, structure=np.ones((3, 3)))
    if n <= 1:
        return
    sizes = ndi.sum(a, lab, range(1, n + 1))
    px = img.load()
    for i, s_ in enumerate(sizes):
        if s_ < limit:
            for y, x in zip(*np.nonzero(lab == i + 1)):
                px[int(x), int(y)] = (0, 0, 0, 0)


def colourful(p):
    """Fur, cream, cobalt: anything but the greys and olives the whiskers leave."""
    lum = 0.3 * p[0] + 0.59 * p[1] + 0.11 * p[2]
    return max(p[:3]) - min(p[:3]) > 60 or lum > 185


def clean_muzzle(img, cx, cy, R):
    """Below and in front of the eye: greys and olives left by whiskers and the nose's soft edge take
    the cream or fur around them (the outline pixels at the silhouette are left alone)."""
    px = img.load()
    W_, H_ = img.size
    for _ in range(3):
        for y in range(int(cy) + 1, min(H_ - 1, int(cy) + 9)):
            for x in range(max(1, int(cx) - 10), min(W_ - 1, int(cx) + 4)):
                p = px[x, y]
                if not p[3] or colourful(p):
                    continue
                nb = [px[x + dx, y + dy] for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (1, -1), (-1, 1))]
                if any(q[3] == 0 for q in nb[:4]):
                    continue                                   # silhouette outline stays
                warm = [q for q in nb if q[3] and colourful(q)]
                if len(warm) >= 3:
                    px[x, y] = max(set(warm), key=warm.count)


def nose_and_mouth(img, cx, cy, kind, R):
    """A clean nose at the snout tip and a short mouth under it, placed from the eye."""
    px = img.load()
    rows = range(int(round(cy)) + 1, int(round(cy)) + 5)
    tips = []
    for y in rows:
        xs = [x for x in range(max(0, int(cx) - 13), int(cx)) if px[x, y][3]]
        if xs:
            tips.append((min(xs), y))
    if not tips:
        return
    tx, ty = min(tips)
    nose = (26, 14, 16, 255)
    px[tx, ty] = nose
    px[tx + 1, ty] = nose
    if px[tx + 1, ty - 1][3]:
        px[tx + 1, ty - 1] = (120, 92, 92, 255)
    line = (70, 26, 22, 255)
    my = ty + 2
    if kind == "open":
        for x in range(tx + 1, tx + 4):
            if px[x, my][3]:
                px[x, my] = line
        for x in range(tx + 2, tx + 4):
            if px[x, my + 1][3]:
                px[x, my + 1] = (214, 96, 104, 255)
        if px[tx + 4, my - 1][3]:
            px[tx + 4, my - 1] = line
    else:
        for x in range(tx + 1, tx + 4):
            if px[x, my][3]:
                px[x, my] = line
        if px[tx + 4, my - 1][3]:
            px[tx + 4, my - 1] = line


EYE = {5: [".KKK.", "KWWKK", "KWKKK", "KIIIK", ".KIK."],
       4: [".KK.", "KWKK", "KKIK", ".KI."],
       3: [".K.", "KWK", "KIK"],
       2: ["KK", "WK"]}


def clean_eye(img, cx, cy, w, h, R):
    px = img.load()
    size = max(2, min(5, int(round(max(w, h) + 0.3))))
    t = EYE[size]
    x0, y0 = int(round(cx - len(t[0]) / 2)), int(round(cy - len(t) / 2))
    fur = tuple(int(v) for v in R["fur"][2]) + (255,)
    # whatever dark smudge the reduction left round the eye becomes fur first
    for yy in range(y0 - 1, y0 + len(t) + 1):
        for xx in range(x0 - 1, x0 + len(t[0]) + 1):
            p = px[xx, yy]
            l_ = 0.3 * p[0] + 0.59 * p[1] + 0.11 * p[2]
            if p[3] and (l_ < 110 or min(p[:3]) > 205):
                nb = [px[xx + dx, yy + dy] for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))]
                if all(q[3] for q in nb):
                    px[xx, yy] = fur
    cols = {"K": (26, 14, 16), "W": (255, 255, 255), "I": (168, 82, 30)}
    for j, row in enumerate(t):
        for i, ch in enumerate(row):
            if ch in cols and px[x0 + i, y0 + j][3]:
                px[x0 + i, y0 + j] = cols[ch] + (255,)


def debug_materials(name):
    src, fg, _ = prepare(name)
    mat, _ = classify(src, fg)
    pal = np.array([(0, 0, 0), (234, 130, 70), (252, 232, 194), (90, 76, 72), (246, 242, 239), (39, 80, 185), (255, 200, 60), (230, 100, 130)])
    out = np.zeros(src.shape, np.uint8) + 60
    for i in range(len(MATS)):
        out[mat == i] = pal[i]
    return Image.fromarray(out)


if __name__ == "__main__":
    import sys
    names = sys.argv[1:] or ["wickit", "stoketail", "forgel"]
    BG = (72, 80, 104, 255)
    big = Image.new("RGBA", (96 * 6 * len(names), 96 * 6), BG)
    for i, n in enumerate(names):
        sp = reduce(n)
        sp.save(SCR + f"fc2_{n}_96.png")
        debug_materials(n).save(SCR + f"fc2_{n}_mat.png")
        b = Image.new("RGBA", (96, 96), BG); b.alpha_composite(sp)
        big.alpha_composite(b.resize((576, 576), Image.NEAREST), (i * 576, 0))
    big.save(SCR + "fc2_zoom.png")


def export(root="/home/claude/frost-thaw/build/concept/sprites"):
    """96px sprites, 288px battlers and 128x64 party icons, all from the material reduction."""
    import os
    os.makedirs(root, exist_ok=True)
    num = {"wickit": 582, "stoketail": 583, "forgel": 584}
    for n, k in num.items():
        sp = reduce(n)
        sp.save(f"{root}/{n}_96.png")
        sp.resize((288, 288), Image.NEAREST).save(f"{root}/{k}.png")
        ic = reduce(n, size={"wickit": 44, "stoketail": 54, "forgel": 62}[n], ground=60, canvas=64)
        icon = Image.new("RGBA", (128, 64), (0, 0, 0, 0))
        icon.alpha_composite(ic, (0, 0))
        icon.alpha_composite(ic, (64, -2))
        icon.save(f"{root}/{n.upper()}.png")
