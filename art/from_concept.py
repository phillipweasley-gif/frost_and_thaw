"""Cinderwright sprites from the user's master concept sheet (build/concept/cinderwright_concept.png).
Each creature is cut out of the paper background, flipped to face left (front-sprite convention),
reduced to 96px by area, its colours clustered to a small palette, cleaned of stray pixels, and
given a one-pixel selective outline."""
import numpy as np
import cv2
from PIL import Image
from scipy import ndimage as ndi

SRC = "/home/claude/frost-thaw/build/concept/cinderwright_concept.png"
SCR = "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/"
BOXES = {"wickit": (50, 192, 404, 552), "stoketail": (456, 86, 914, 564), "forgel": (917, 80, 1768, 568)}
SIZE = {"wickit": 58, "stoketail": 82, "forgel": 95}       # longest side in the 96px frame
COLOURS = {"wickit": 22, "stoketail": 26, "forgel": 30}


def cut_out(rgb, gaps=True):
    """Alpha for one creature: paper and its soft ground shadow are flood-filled from the border; paper
    showing through enclosed gaps (inside a tail loop) is found by what surrounds it - porcelain whites
    are ringed by cobalt line, paper gaps by brown or dark line."""
    im = rgb.astype(np.int16)
    mx, mn = im.max(2), im.min(2)
    paperish = ((mn > 196) & ((mx - mn) < 34)) | ((mn > 165) & ((mx - mn) < 52) & (im[..., 0] >= im[..., 2]))   # paper + warm grey shadow
    lab, n = ndi.label(paperish)
    border = set(np.unique(np.concatenate([lab[0], lab[-1], lab[:, 0], lab[:, -1]]))) - {0}
    bg = np.isin(lab, list(border))
    for i in range(1, n + 1 if gaps else 1):
        if i in border:
            continue
        comp = lab == i
        if comp.sum() < 1500:                             # small pale patches are highlights in the fur, not gaps
            continue
        ring = ndi.binary_dilation(comp, iterations=3) & ~comp & ~paperish
        if not ring.any():
            continue
        rr = im[ring]
        blue = ((rr[:, 2] - rr[:, 0]) > 40).mean()
        if blue < 0.35:                                   # not porcelain: a gap in the silhouette
            bg |= comp
    fg = ~bg
    fg = ndi.binary_opening(fg, iterations=1)
    lab2, n2 = ndi.label(fg)
    if n2:
        sizes = ndi.sum(fg, lab2, range(1, n2 + 1))
        keep = [i + 1 for i, s in enumerate(sizes) if s > 400]
        fg = np.isin(lab2, keep)
    return fg


def kmeans_palette(px, k):
    Z = cv2.cvtColor(px.reshape(-1, 1, 3).astype(np.uint8), cv2.COLOR_RGB2LAB).reshape(-1, 3).astype(np.float32)
    crit = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 60, 0.5)
    _, labels, centres = cv2.kmeans(Z, k, None, crit, 6, cv2.KMEANS_PP_CENTERS)
    cent_rgb = cv2.cvtColor(centres.reshape(-1, 1, 3).astype(np.uint8), cv2.COLOR_LAB2RGB).reshape(-1, 3)
    return labels.ravel(), cent_rgb


def make(name, ground=90, size=None, canvas=96):
    x0, y0, x1, y1 = BOXES[name]
    src = np.asarray(Image.open(SRC).convert("RGB"))[y0:y1, x0:x1]
    fg = cut_out(src)
    ys, xs = np.nonzero(fg)
    src, fg = src[ys.min():ys.max() + 1, xs.min():xs.max() + 1], fg[ys.min():ys.max() + 1, xs.min():xs.max() + 1]
    # whiskers: thin grey strokes; at 96px they only make noise, so they are painted out first
    im16 = src.astype(np.int16)
    lumv = src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
    grey = ((im16.max(2) - im16.min(2)) < 40) & (lumv > 70) & (lumv < 222) & fg
    thin = grey & ~ndi.binary_opening(grey, iterations=2)
    outside = thin & ~ndi.binary_opening(fg & ~thin, iterations=2)
    fg = fg & ~outside
    src = cv2.inpaint(np.ascontiguousarray(src), (thin & fg).astype(np.uint8) * 255, 3, cv2.INPAINT_TELEA)
    # find the eyes: dark blobs holding a bright highlight
    lumv = src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
    darkb = (lumv < 70) & fg
    hl0 = (src.min(2) > 235) & (ndi.uniform_filter(darkb.astype(np.float32), 9) > 0.4) & fg
    eyes = []
    lab, n = ndi.label(ndi.binary_dilation(darkb, iterations=2) | hl0)
    for i in set(np.unique(lab[hl0])) - {0}:
        yy, xx = np.nonzero((lab == i) & (darkb | hl0))
        reg = ndi.binary_dilation(lab == i, iterations=2)
        r_, g_, b_ = src[..., 0].astype(int), src[..., 1].astype(int), src[..., 2].astype(int)
        iris = reg & (r_ > 110) & (g_ > 45) & (g_ < 130) & (b_ < 70) & (r_ - b_ > 70)
        if 30 < len(yy) < 4000 and iris.sum() > 8:           # an eye has an amber iris; the nose does not
            eyes.append((xx.mean(), yy.mean(), xx.max() - xx.min() + 1, yy.max() - yy.min() + 1))
    src, fg = src[:, ::-1], fg[:, ::-1]                   # face left, like every front sprite
    eyes = [(src.shape[1] - 1 - x, y, w_, h_) for (x, y, w_, h_) in eyes]
    h, w = fg.shape
    k = (size or SIZE[name]) / max(h, w)
    tw, th = max(1, round(w * k)), max(1, round(h * k))
    a = fg.astype(np.float32)
    pre = src.astype(np.float32) * a[..., None]
    small = cv2.resize(pre, (tw, th), interpolation=cv2.INTER_AREA)
    sa = cv2.resize(a, (tw, th), interpolation=cv2.INTER_AREA)
    col = small / np.maximum(sa[..., None], 1e-4)
    on = sa >= 0.5
    # keep the line art: where a block is largely dark line, the pixel takes the line colour, so outlines,
    # eyes and the toe lines survive the reduction instead of averaging away
    lum = src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
    dark = ((lum < 85) & fg).astype(np.float32)
    dfrac = cv2.resize(dark, (tw, th), interpolation=cv2.INTER_AREA)
    dcol = cv2.resize(src.astype(np.float32) * dark[..., None], (tw, th), interpolation=cv2.INTER_AREA) / np.maximum(dfrac[..., None], 1e-4)
    use = (dfrac > 0.3) & on
    col[use] = dcol[use]
    # eye highlights: tiny bright specks held inside dark eyes, mapped to their sprite pixel
    bright = (src.min(2) > 235)
    darkn = ndi.uniform_filter(dark, 9) > 0.45
    hl = bright & darkn & fg
    hls = cv2.resize(hl.astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA) > 0.04
    labels, pal = kmeans_palette(col[on], COLOURS[name])
    q = np.zeros((th, tw), int) - 1
    q[on] = labels
    # clean stray pixels: a pixel whose colour no 4-neighbour shares joins its neighbours' majority
    for _ in range(2):
        q2 = q.copy()
        for y in range(th):
            for x in range(tw):
                if q[y, x] < 0:
                    continue
                nb = [q[y + dy, x + dx] for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1))
                      if 0 <= y + dy < th and 0 <= x + dx < tw and q[y + dy, x + dx] >= 0]
                if len(nb) >= 3 and q[y, x] not in nb:
                    q2[y, x] = max(set(nb), key=nb.count)
        q = q2
    out = np.zeros((canvas, canvas, 4), np.uint8)
    ox, oy = (canvas - tw) // 2, ground - th
    lum = pal.astype(float) @ np.array([0.3, 0.59, 0.11])
    for y in range(th):
        for x in range(tw):
            if q[y, x] < 0:
                continue
            c = pal[q[y, x]]
            edge = any(not (0 <= y + dy < th and 0 <= x + dx < tw) or q[y + dy, x + dx] < 0
                       for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)))
            if edge:                                       # selective outline: a deep version of the colour
                c = (c.astype(float) * (0.42 if lum[q[y, x]] > 60 else 0.8)).astype(np.uint8)
            if hls[y, x] and not edge:
                c = np.array([255, 255, 255], np.uint8)
            out[oy + y, ox + x, :3] = c
            out[oy + y, ox + x, 3] = 255
    img = Image.fromarray(out, "RGBA").copy()
    # leftover whisker specks: greys sitting inside warm fur or cream take their neighbours' colour
    px = img.load()
    for _ in range(2):
        for y in range(1, canvas - 1):
            for x in range(1, canvas - 1):
                p = px[x, y]
                if not p[3]:
                    continue
                l_ = 0.3 * p[0] + 0.59 * p[1] + 0.11 * p[2]
                if max(p[:3]) - min(p[:3]) < 34 and 72 < l_ < 200:
                    nb = [px[x + dx, y + dy] for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (1, -1), (-1, 1))]
                    warm = [q for q in nb if q[3] and q[0] - q[2] > 40]
                    if len(warm) >= 5:
                        px[x, y] = max(set(warm), key=warm.count)
    for (ex, ey, ew, eh) in eyes:                          # hand-placed eyes at the painting's eye positions
        cx, cy = ox + ex * k, oy + ey * k
        place_eye(img, cx, cy, ew * k, eh * k)
    return img, Image.fromarray(np.dstack([src, fg.astype(np.uint8) * 255]), "RGBA")


EYE = {5: [".KKK.", "KWKKK", "KWKKK", "KKKIK", ".KII."],
       4: [".KK.", "KWKK", "KKIK", ".KI."],
       3: ["KKK", "WKK", "KIK"],
       2: ["KK", "WK"]}


def place_eye(img, cx, cy, w, h):
    px = img.load()
    size = max(2, min(5, int(round(max(w, h)))))
    t = EYE[size]
    x0, y0 = int(round(cx - len(t[0]) / 2)), int(round(cy - len(t) / 2))
    # clear the smudge the reduction left, using the fur colour around the eye
    ring = []
    for yy in range(y0 - 2, y0 + len(t) + 2):
        for xx in range(x0 - 2, x0 + len(t[0]) + 2):
            p = px[xx, yy]
            if p[3] and 0.3 * p[0] + 0.59 * p[1] + 0.11 * p[2] > 90:
                ring.append(p)
    fur = max(set(ring), key=ring.count) if ring else None
    for yy in range(y0 - 1, y0 + len(t) + 1):
        for xx in range(x0 - 1, x0 + len(t[0]) + 1):
            p = px[xx, yy]
            if fur and p[3] and 0.3 * p[0] + 0.59 * p[1] + 0.11 * p[2] < 80:
                nb = [px[xx + dx, yy + dy] for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))]
                if all(q[3] for q in nb):
                    px[xx, yy] = fur
    cols = {"K": (26, 14, 16), "W": (255, 255, 255), "I": (150, 72, 30)}
    for j, row in enumerate(t):
        for i, ch in enumerate(row):
            if ch in cols and px[x0 + i, y0 + j][3]:
                px[x0 + i, y0 + j] = cols[ch] + (255,)


def paddle(size):
    """The porcelain tail paddle on its own (from Stoketail's tail in the concept), for fusions."""
    src = np.asarray(Image.open(SRC).convert("RGB"))[156:330, 738:930]
    im = src.astype(np.int16)
    paper = ((im.min(2) > 196) & ((im.max(2) - im.min(2)) < 34))
    from skimage.morphology import convex_hull_image
    lab, n = ndi.label(ndi.binary_opening(~paper, iterations=1))
    big = lab == (np.argmax(ndi.sum(~paper, lab, range(1, n + 1))) + 1)
    fg = convex_hull_image(big)                      # the leaf-shaped paddle is convex; its glazed white fills the hull
    ys, xs = np.nonzero(fg)
    src, fg = src[ys.min():ys.max() + 1, xs.min():xs.max() + 1], fg[ys.min():ys.max() + 1, xs.min():xs.max() + 1]
    h, w = fg.shape
    k = size / max(h, w)
    tw, th = max(1, round(w * k)), max(1, round(h * k))
    a = fg.astype(np.float32)
    small = cv2.resize(src.astype(np.float32) * a[..., None], (tw, th), interpolation=cv2.INTER_AREA)
    sa = cv2.resize(a, (tw, th), interpolation=cv2.INTER_AREA)
    col = small / np.maximum(sa[..., None], 1e-4)
    on = sa >= 0.5
    pal = np.array([(16, 40, 140), (44, 92, 200), (232, 236, 246), (255, 255, 255), (150, 160, 190), (240, 150, 60)], float)
    out = np.zeros((th, tw, 4), np.uint8)
    for y in range(th):
        for x in range(tw):
            if on[y, x]:
                c = pal[((pal - col[y, x]) ** 2).sum(1).argmin()]
                edge = any(not (0 <= y + dy < th and 0 <= x + dx < tw) or not on[y + dy, x + dx]
                           for dy, dx in ((1, 0), (-1, 0), (0, 1), (0, -1)))
                out[y, x, :3] = (14, 30, 96) if edge else c
                out[y, x, 3] = 255
    return Image.fromarray(out, "RGBA")


def export(root="/home/claude/frost-thaw/build/concept/sprites"):
    """96px sprites, 288px battlers (x3, like every Infinite Fusion battler) and 128x64 party icons."""
    import os
    os.makedirs(root, exist_ok=True)
    num = {"wickit": 582, "stoketail": 583, "forgel": 584}
    for n, k in num.items():
        sp, _ = make(n)
        sp.save(f"{root}/{n}_96.png")
        sp.resize((288, 288), Image.NEAREST).save(f"{root}/{k}.png")
        ic, _ = make(n, ground=60, size={"wickit": 44, "stoketail": 54, "forgel": 62}[n], canvas=64)
        icon = Image.new("RGBA", (128, 64), (0, 0, 0, 0))
        icon.alpha_composite(ic, (0, 0))
        icon.alpha_composite(ic, (64, -2))
        icon.save(f"{root}/{n.upper()}.png")
    for k, sz in (("w", 19), ("st", 25), ("fg", 31)):
        paddle(sz).save(f"{root}/paddle_{k}.png")


if __name__ == "__main__":
    export()
    BG = (72, 80, 104, 255)
    sheet = Image.new("RGBA", (3 * 300 + 20, 620), (56, 62, 84, 255))
    for i, n in enumerate(("wickit", "stoketail", "forgel")):
        sp, cut = make(n)
        sp.save(SCR + "fc_%s_96.png" % n)
        cut.save(SCR + "fc_%s_cut.png" % n)
        c = cut.copy(); c.thumbnail((290, 290))
        b = Image.new("RGBA", c.size, BG); b.alpha_composite(c)
        sheet.alpha_composite(b, (10 + i * 300, 10))
        s = Image.new("RGBA", (96, 96), BG); s.alpha_composite(sp)
        sheet.alpha_composite(s.resize((288, 288), Image.NEAREST), (10 + i * 300, 320))
    sheet.save(SCR + "fc_sheet.png")
