"""High-detail painting engine: render a creature at 8x (768px) as a finished illustration, then
simplify it down to a 96px sprite.

Each Layer is a set of anatomical masses (polygons in 96-space). At high resolution:
  * every mass becomes a dome (circular profile from its distance field); masses blend with a smooth max,
    so a shoulder or haunch bulges and creases where it meets the next mass
  * the union is smoothed so masses flow into each other like muscle under fur
  * normals from that height field give wrap-around light, a warm kiln rim light from behind, and
    specular gloss for porcelain and steel
  * colour comes from hue-shifted material ramps; regions (cream throat, umber underside) are colour only
  * fur gets flow strokes along the form and small tufts breaking the silhouette
  * each layer casts a soft shadow on what is behind it and gets a weighted outline (heavier in shadow)
"""
import math
import numpy as np
import cv2
from scipy import ndimage as ndi

S = 8
W = 96 * S
RNG = np.random.default_rng(7)

RAMPS = {
    "fur":    [(62, 20, 30), (108, 36, 34), (156, 64, 40), (198, 100, 56), (228, 142, 86), (246, 186, 132)],
    "cream":  [(140, 92, 84), (190, 142, 114), (224, 190, 154), (246, 224, 192), (255, 246, 226)],
    "umber":  [(44, 22, 26), (72, 40, 36), (102, 62, 48), (134, 90, 66), (164, 122, 92)],
    "char":   [(18, 14, 22), (34, 26, 34), (56, 44, 50), (86, 70, 72), (122, 104, 100)],
    "porc":   [(112, 124, 168), (168, 180, 212), (212, 220, 238), (238, 242, 252), (255, 255, 255)],
    "cobalt": [(10, 20, 78), (22, 44, 134), (40, 78, 186), (78, 120, 222), (136, 168, 240)],
    "steel":  [(26, 28, 42), (52, 54, 72), (88, 92, 112), (134, 138, 156), (188, 192, 208), (238, 240, 248)],
    "ember":  [(196, 72, 20), (240, 124, 32), (255, 172, 54), (255, 214, 110), (255, 246, 210)],
    "clay":   [(76, 40, 32), (116, 70, 52), (156, 104, 78), (192, 142, 108), (220, 182, 146)],
    "bone":   [(112, 96, 84), (168, 152, 132), (216, 204, 182), (246, 238, 222)],
    "mouth":  [(60, 16, 24), (110, 34, 40), (176, 70, 76), (222, 112, 112)],
    "ear":    [(120, 66, 62), (160, 100, 88), (196, 140, 120), (222, 176, 154)],
}
MATS = list(RAMPS)
MID = {m: i for i, m in enumerate(MATS)}
FUR_MATS = {"fur", "cream", "umber", "char", "ear"}
LIGHT = np.array([-0.46, -0.66, 0.6]); LIGHT /= np.linalg.norm(LIGHT)
RIM = np.array([0.62, 0.42, -0.1]); RIM /= np.linalg.norm(RIM)
KILN = np.array([255, 150, 60], float)


# ------------------------------------------------------------------------------------------- rasterising
XF = [1.0, (50.0, 90.0), (0.0, 0.0), 0.0]     # global framing: scale and turn about a pivot, then offset


def xp(p):
    k, (px_, py_), (ox, oy), ang = XF
    dx, dy = (p[0] - px_) * k, (p[1] - py_) * k
    if ang:
        c, s_ = math.cos(math.radians(ang)), math.sin(math.radians(ang))
        dx, dy = dx * c - dy * s_, dx * s_ + dy * c
    return (dx + px_ + ox, dy + py_ + oy)


def framing(k=1.0, pivot=(50.0, 90.0), off=(0.0, 0.0), ang=0.0):
    XF[0], XF[1], XF[2], XF[3] = k, pivot, off, ang

def _polys(obj):
    """Accept a polygon, or a list of polygons; return a list of polygons."""
    if obj and isinstance(obj[0], tuple) and isinstance(obj[0][0], (int, float)):
        return [obj]
    return list(obj)


def fill(polys, aa=True):
    """Anti-aliased coverage (0..1) of polygons given in 96-space."""
    im = np.zeros((W, W), np.uint8)
    pts = [np.round(np.array([xp(q) for q in p], float) * S * 16).astype(np.int32) for p in _polys(polys) if len(p) >= 3]
    for q in pts:                          # one at a time: fillPoly with several contours XORs overlaps
        cv2.fillPoly(im, [q], 255, cv2.LINE_AA if aa else cv2.LINE_8, shift=4)
    return im.astype(np.float32) / 255.0


def line(pts, width, aa=True):
    im = np.zeros((W, W), np.uint8)
    p = np.round(np.array([xp(q) for q in pts], float) * S * 16).astype(np.int32)
    cv2.polylines(im, [p], False, 255, max(1, int(round(width * XF[0] * S))), cv2.LINE_AA, shift=4)
    return im.astype(np.float32) / 255.0


def blur(a, sigma):
    return ndi.gaussian_filter(a, sigma) if sigma > 0 else a


def soft(a, k=3.0):
    return np.clip((a - 0.5) * k + 0.5, 0, 1)


# ------------------------------------------------------------------------------------------- layers
class Layer:
    def __init__(self, name, masses, mat="fur", regions=(), depth=1.0, kind="matte", gloss=0.0, tufts=0.0,
                 outline=True, cast=True, smooth=0.6, line_col=None, design=None, strokes=True, flat=False, rim=1.0, dim=0.0,
                 follow=None, clip=None, ao=True, ow=1.0, wrap=0.12, sheen=0.0, hsmooth=0.45):
        self.name, self.masses, self.mat, self.regions = name, masses, mat, list(regions)
        self.depth, self.kind, self.gloss, self.tufts = depth, kind, gloss, tufts
        self.outline, self.cast, self.smooth, self.line_col = outline, cast, smooth, line_col
        self.design, self.strokes, self.flat, self.rim, self.dim = design, strokes, flat, rim, dim
        self.follow, self.clip = follow, clip
        self.ao, self.ow, self.wrap, self.sheen, self.hsmooth = ao, ow, wrap, sheen, hsmooth


def build_height(L):
    hs, cover = [], np.zeros((W, W), np.float32)
    for m in L.masses:
        a = fill(m)
        cover = np.maximum(cover, a)
        b = a > 0.5
        if not b.any():
            continue
        d = ndi.distance_transform_edt(b).astype(np.float32)
        R = d.max()
        hs.append(np.sqrt(np.clip(2 * R * d - d * d, 0, None)))          # a circular dome over each mass
    if not hs:
        return None, None
    k = 0.09
    stack = np.stack(hs)
    mx = stack.max(0)
    H = mx + np.log(np.exp(k * (stack - mx)).sum(0)) / k                # smooth max: masses blend with a crease
    H[mx <= 0] = 0
    U = soft(blur(cover, L.smooth * S), 4.0)                            # masses flow into each other
    U = np.maximum(U, ndi.binary_fill_holes(U > 0.5).astype(np.float32))
    H = blur(np.where(U > 0.02, np.maximum(H, ndi.grey_dilation(H, size=5) * 0.9), 0), L.hsmooth * S) * U
    return H * L.depth, U


def add_tufts(L, H, U, amount):
    """Fur clumps breaking the silhouette: small flame-like triangles leaning along the fur."""
    if amount <= 0:
        return H, U
    b = (U > 0.5).astype(np.uint8)
    cs, _ = cv2.findContours(b, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_NONE)
    gy, gx = np.gradient(blur(U, S))
    T = np.zeros((W, W), np.uint8)
    for c in cs:
        c = c[:, 0, :]
        step = int(S * 2.2)
        for i in range(0, len(c), step):
            if RNG.random() > amount:
                continue
            x, y = c[i]
            nx, ny = -gx[y, x], -gy[y, x]
            ln = math.hypot(nx, ny) or 1
            nx, ny = nx / ln, ny / ln
            if ny > 0.35:                      # fur breaks the outline on top and behind, not underneath
                continue
            tx, ty = -ny, nx
            lean = 1.1
            Lg = S * RNG.uniform(0.6, 1.1)
            tip = (x + (nx + tx * lean) * Lg, y + (ny + ty * lean) * Lg)
            mid = (x + nx * Lg * 0.55 + tx * Lg * 0.2, y + ny * Lg * 0.55 + ty * Lg * 0.2)
            base1 = (x - tx * S * 1.1 - nx * S * 0.5, y - ty * S * 1.1 - ny * S * 0.5)
            base2 = (x + tx * S * 0.9 - nx * S * 0.5, y + ty * S * 0.9 - ny * S * 0.5)
            cv2.fillPoly(T, [np.round(np.array([base1, mid, tip, base2]) * 16).astype(np.int32)], 255, cv2.LINE_AA, shift=4)
    t = T.astype(np.float32) / 255
    U2 = np.maximum(U, t)
    H2 = np.maximum(H, ndi.grey_dilation(H, size=int(S * 2)) * 0.55 * t)
    return H2, U2


def normals(H):
    gy, gx = np.gradient(H)
    n = np.dstack([-gx, -gy, np.ones_like(H)])
    return n / np.linalg.norm(n, axis=2, keepdims=True)


def ramp_lookup(matmap, s):
    out = np.zeros((W, W, 3), np.float32)
    for m, ramp in RAMPS.items():
        sel = matmap == MID[m]
        if not sel.any():
            continue
        r = np.array(ramp, np.float32)
        t = np.clip(s[sel], 0, 1) * (len(r) - 1)
        i = np.clip(np.floor(t).astype(int), 0, len(r) - 2)
        f = (t - i)[:, None]
        out[sel] = r[i] * (1 - f) + r[i + 1] * f
    return out


def fur_strokes(H, U, n_per_px=1 / 90):
    """Short value strokes along the form (perpendicular to the height gradient)."""
    off = np.zeros((W, W), np.float32)
    gy, gx = np.gradient(blur(H, S * 0.8))
    ys, xs = np.nonzero(U > 0.6)
    if len(xs) == 0:
        return off
    n = int(len(xs) * n_per_px)
    idx = RNG.choice(len(xs), n, replace=False) if n < len(xs) else np.arange(len(xs))
    for j in idx:
        x, y = xs[j], ys[j]
        dx, dy = -gy[y, x], gx[y, x]
        ln = math.hypot(dx, dy)
        if ln < 1e-3:
            continue
        dx, dy = dx / ln, dy / ln
        Lg = S * RNG.uniform(1.6, 2.8)
        v = -0.04 if RNG.random() < 0.6 else 0.035
        tmp = np.zeros((1,), np.float32)
        cv2.line(off, (int(x * 16), int(y * 16)), (int((x + dx * Lg) * 16), int((y + dy * Lg) * 16)), float(v), 1, cv2.LINE_AA, shift=4)
    return off


def render_layer(L, base_H=None, clip_U=None):
    H, U = build_height(L)
    if H is None:
        return None
    if clip_U is not None:                 # armour cut to the body it covers, standing just proud of the fur
        cu = soft(blur(ndi.binary_dilation(clip_U > 0.5, iterations=int(S * 0.45)).astype(np.float32), S * 0.15), 4)
        U = U * cu
        H = H * (U > 0.02)
    if L.tufts:
        H, U = add_tufts(L, H, U, L.tufts)
    if base_H is not None:                 # a plate that wraps a form: the form's surface plus a thin shell
        bH = blur(ndi.grey_dilation(base_H, size=int(S * 3)), S * 0.8)
        H = bH * (U > 0.02) + H * 0.22
    n = normals(H)
    matmap = np.full((W, W), MID[L.mat], np.int16)
    for polys, mat in L.regions:
        rm = soft(blur(fill(polys), 0.3 * S), 3) > 0.5
        matmap[rm] = MID[mat]
    if L.design:
        for mat, mask in L.design(U):
            matmap[mask > 0.5] = MID[mat]
    ndl = n @ LIGHT
    if L.flat:
        s = np.full((W, W), 0.75, np.float32)
    else:
        s = np.clip((ndl + L.wrap) / (1 + L.wrap), 0, 1) * 0.92 + 0.04
        s = s - 0.2 * np.clip(1 - n[..., 2], 0, 1) ** 2 * (ndl < 0.25)      # turning edges fall into core shadow
        if L.ao:
            ao = np.clip((blur(H, S * 2.5) - H) / (S * 1.5), 0, 1)           # creases between masses
            s = s - 0.22 * ao
    shade = np.clip(s * 0.92 - L.dim, 0, 1)
    if L.strokes and L.mat in FUR_MATS:
        s = s + fur_strokes(H, U)
    s = s * 0.92 - L.dim
    rgb = ramp_lookup(matmap, s)
    if L.rim:
        rim = np.clip(n @ RIM, 0, 1) ** 2 * np.clip(1 - n[..., 2], 0, 1) * L.rim
        rgb = rgb + rim[..., None] * (KILN - rgb) * 0.55                   # warm kiln light from behind
    if L.sheen:                            # the soft satin sheen of the official renders
        V = np.array([0, 0, 1.0]); Hv = (LIGHT + V) / np.linalg.norm(LIGHT + V)
        sp = np.clip(n @ Hv, 0, 1) ** 14 * L.sheen
        rgb = rgb + sp[..., None] * (255 - rgb)
    if L.kind in ("gloss", "metal"):
        V = np.array([0, 0, 1.0]); Hv = (LIGHT + V) / np.linalg.norm(LIGHT + V)
        sp = np.clip(n @ Hv, 0, 1) ** (60 if L.kind == "gloss" else 24) * L.gloss
        rgb = rgb + sp[..., None] * (255 - rgb)
        if L.kind == "metal":                                              # chrome: a dark horizon band
            band = np.exp(-((n[..., 1] - 0.05) / 0.16) ** 2) * 0.45
            rgb = rgb * (1 - band[..., None])
    # weighted outline: thicker on the shadow side
    if L.outline:
        b = U > 0.5
        d = ndi.distance_transform_edt(b)
        w = S * (0.32 + 0.3 * np.clip(0.4 - ndl, 0, 1)) * L.ow
        edge = np.clip((w - d) / 1.2 + 0.5, 0, 1) * b
        lc = np.array(L.line_col if L.line_col else [v * 0.42 for v in RAMPS[L.mat][0]], np.float32)
        rgb = rgb * (1 - edge[..., None]) + lc * edge[..., None]
    rimv = rim if L.rim else np.zeros_like(U)
    edge_ = edge if L.outline else np.zeros_like(U)
    return {"rgb": np.clip(rgb, 0, 255), "a": U, "mat": matmap, "H": H, "n": n, "name": L.name, "shade": shade,
            "rim": rimv, "edge": edge_}


class Canvas:
    def __init__(self):
        self.rgb = np.zeros((W, W, 3), np.float32)
        self.a = np.zeros((W, W), np.float32)
        self.mat = np.full((W, W), -1, np.int16)
        self.lid = np.full((W, W), -1, np.int16)
        self.shade = np.zeros((W, W), np.float32)
        self.rim = np.zeros((W, W), np.float32)
        self.edge = np.zeros((W, W), np.float32)
        self.layers = {}
        self.order = []

    def add(self, L):
        R = render_layer(L, self.layers[L.follow]["H"] if L.follow else None,
                         self.layers[L.clip]["a"] if L.clip else None)
        if R is None:
            return
        if L.cast:
            sh = blur(ndi.shift(R["a"], (S * 1.1, S * 0.7), order=1), S * 1.1)
            k = 0.32 * sh * (1 - R["a"]) * (self.a > 0)
            self.rgb *= (1 - k[..., None])
        a = R["a"][..., None]
        self.rgb = self.rgb * (1 - a) + R["rgb"] * a
        self.a = np.maximum(self.a, R["a"])
        self.mat = np.where(R["a"] > 0.5, R["mat"], self.mat)
        self.lid = np.where(R["a"] > 0.5, len(self.order), self.lid)
        on = R["a"] > 0.5
        self.shade = np.where(on, R["shade"], self.shade)
        self.rim = np.where(on, R["rim"], self.rim)
        self.edge = np.where(on, R["edge"], self.edge)
        self.order.append(L)
        self.layers[L.name] = R

    def glow(self, mask, colour=(255, 150, 50), sigma=1.6, strength=0.7):
        g = blur(mask, sigma * S) * strength
        self.rgb = self.rgb + g[..., None] * (np.array(colour, np.float32) - self.rgb) * (self.a[..., None] > 0)
        halo = g * (1 - self.a)
        self.rgb = self.rgb * (1 - halo[..., None]) + np.array(colour, np.float32) * halo[..., None]
        self.a = np.maximum(self.a, np.clip(halo * 0.9, 0, 1))

    def paint(self, mask, colour, mat=None):
        m = np.clip(mask, 0, 1)[..., None]
        self.rgb = self.rgb * (1 - m) + np.array(colour, np.float32) * m
        self.a = np.maximum(self.a, mask)
        if mat:
            self.mat = np.where(mask > 0.5, MID[mat], self.mat)

    def image(self, bg=None):
        from PIL import Image
        rgba = np.dstack([np.clip(self.rgb, 0, 255), self.a[..., None] * 255]).astype(np.uint8)
        im = Image.fromarray(rgba, "RGBA")
        if bg:
            b = Image.new("RGBA", im.size, bg); b.alpha_composite(im); return b
        return im


# ------------------------------------------------------------------------------------------- porcelain
def delft(U, geom, motifs=(), arcs=(), border=True, scallop=True, sprigs=True):
    """Blue-and-white decoration in a plate's own frame: a band inside the rim with scalloped lace,
    a fine inner line, flowers with leaves, and the lapped edges of a layered plate."""
    b = U > 0.5
    d = ndi.distance_transform_edt(b) / S                  # distance from the plate edge, in sprite pixels
    out = np.zeros((W, W), np.float32)
    light = np.zeros((W, W), np.float32)
    if border:
        out = np.maximum(out, ((d > 0.45) & (d < 1.05)).astype(np.float32))
        if scallop:
            ring = (np.abs(d - 1.05) < 0.08) & b
            ys, xs = np.nonzero(ring)
            pts = list(zip(xs, ys))
            pts.sort(key=lambda p: math.atan2(p[1] - ys.mean(), p[0] - xs.mean()))
            sc = np.zeros((W, W), np.uint8)
            for i in range(0, len(pts), int(S * 1.6)):
                cv2.circle(sc, (int(pts[i][0]), int(pts[i][1])), int(S * 0.45), 255, -1, cv2.LINE_AA)
            out = np.maximum(out, sc.astype(np.float32) / 255 * b)
        light = np.maximum(light, ((d > 1.7) & (d < 1.9)).astype(np.float32))
    if motifs == "auto":
        ys, xs = np.nonzero(b)
        if len(xs) == 0:
            return [("cobalt", out)]
        area = len(xs) / (S * S)
        motifs = [(xs.mean() / S, ys.mean() / S, max(0.8, min(2.0, math.sqrt(area) * 0.17)))]
    else:
        motifs = [(*xp((mx, my)), r * XF[0]) for (mx, my, r) in motifs]
    for (mx, my, r) in motifs:
        f = np.zeros((W, W), np.uint8)
        for k in range(6):
            a = k * math.pi / 3
            c = (mx + math.cos(a) * r * 0.55, my + math.sin(a) * r * 0.55)
            cv2.ellipse(f, (int(c[0] * S * 16), int(c[1] * S * 16)), (int(r * 0.5 * S * 16), int(r * 0.3 * S * 16)),
                        math.degrees(a), 0, 360, 255, -1, cv2.LINE_AA, shift=4)
        out = np.maximum(out, f.astype(np.float32) / 255)
        cv2.circle(f, (int(mx * S), int(my * S)), int(r * 0.22 * S), 0, -1, cv2.LINE_AA)
        if sprigs:
            for sgn in (-1, 1):
                p0 = (mx + sgn * r * 0.9, my + r * 0.4)
                p1 = (mx + sgn * r * 1.9, my + r * 0.1)
                out = np.maximum(out, line([p0, p1], 0.18))
                leaf = np.zeros((W, W), np.uint8)
                cv2.ellipse(leaf, (int(p1[0] * S * 16), int(p1[1] * S * 16)), (int(r * 0.45 * S * 16), int(r * 0.2 * S * 16)),
                            -20 * sgn, 0, 360, 255, -1, cv2.LINE_AA, shift=4)
                out = np.maximum(out, leaf.astype(np.float32) / 255)
        light = np.maximum(light, blur((np.hypot(*np.meshgrid(np.arange(W) - mx * S, np.arange(W) - my * S)) < r * 0.2 * S).astype(np.float32), 1))
    for arc in arcs:
        out = np.maximum(out, line(arc, 0.32))
    return [("cobalt", out * b)]


# ------------------------------------------------------------------------------------------- eyes and face
def disc(cx, cy, rx, ry, rot=0.0):
    im = np.zeros((W, W), np.uint8)
    cx, cy = xp((cx, cy)); rx, ry = rx * XF[0], ry * XF[0]
    cv2.ellipse(im, (int(cx * S * 16), int(cy * S * 16)), (max(1, int(rx * S * 16)), max(1, int(ry * S * 16))), rot + XF[3], 0, 360,
                255, -1, cv2.LINE_AA, shift=4)
    return im.astype(np.float32) / 255


def eye(C, cx, cy, w, h, lid=0.0, look=(-0.15, 0.05), iris=(204, 116, 34), far=False, lid_col=(40, 16, 18)):
    """A painted eye: dark rim, amber iris lit from below, black pupil, two catchlights, a heavy upper lid
    with a flick at the back corner; `lid` (0..1) lowers the lid for a determined look."""
    E_ = disc(cx, cy, w / 2, h / 2)
    C.paint(E_, (34, 16, 18), "char")
    ir = disc(cx + look[0] * w, cy + look[1] * h + h * 0.06, w * 0.38, h * 0.4) * E_
    C.paint(ir * 0.95, iris)
    lo = disc(cx + look[0] * w, cy + look[1] * h + h * 0.24, w * 0.3, h * 0.2) * ir
    C.paint(lo, (250, 196, 96))
    C.paint(disc(cx + look[0] * w, cy + look[1] * h + h * 0.04, w * 0.2, h * 0.24) * E_, (14, 6, 10))
    C.paint(disc(cx - w * 0.16, cy - h * 0.2, w * 0.15, h * 0.14), (255, 255, 255))
    C.paint(disc(cx + w * 0.12, cy + h * 0.18, w * 0.07, h * 0.06) * 0.85, (255, 240, 220))
    # upper lid: a heavy line over the top of the eye, flicking back
    t = np.linspace(math.pi * 1.05, math.pi * 1.95, 20)
    top = [(cx + w / 2 * math.cos(a) * 1.04, cy + h / 2 * math.sin(a) * 1.02 + lid * h * 0.35 * (1 - abs(math.cos(a)))) for a in t]
    if lid > 0:
        cover = np.zeros((W, W), np.uint8)
        poly = top + [(cx + w * 0.6, cy - h * 0.7), (cx - w * 0.6, cy - h * 0.7)]
        cv2.fillPoly(cover, [np.round(np.array([xp(q) for q in poly]) * S * 16).astype(np.int32)], 255, cv2.LINE_AA, shift=4)
        cov = cover.astype(np.float32) / 255 * soft(blur(E_, 0.6), 2)
        fy_, fx_ = xp((cx, cy - h * 0.9))[1], xp((cx, cy))[0]
        fur = C.rgb[int(fy_ * S), int(fx_ * S)].copy()
        C.rgb = C.rgb * (1 - cov[..., None]) + fur * cov[..., None]
    C.paint(line(top + ([] if far else [(cx + w * 0.62, cy - h * 0.22)]), 0.34 if not far else 0.24), lid_col)


def img_to_np(im):
    return np.asarray(im).astype(np.float32)
