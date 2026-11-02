"""Yetot and Yetitan sprites from the user's watercolour concept sheet (build/concept/yeti_sheet.png).
The cream fur is nearly paper-coloured, so the creature is cut out by texture and shading (fur strokes),
not colour; the snowy ground is cut away below the feet, keeping only the blue-grey soles."""
import numpy as np, cv2
from PIL import Image
from scipy import ndimage as ndi

SHEET = "/home/claude/frost-thaw/build/concept/yeti_sheet.png"
SCR = "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/"
BOX = {"yetot": (40, 270, 620, 860), "yetitan": (620, 15, 1536, 885)}
GROUND = {"yetot": 690, "yetitan": 655}          # sheet y below which only the feet are kept


def disk(r):
    return np.hypot(*np.mgrid[-r:r + 1, -r:r + 1]) <= r


BACK_SHEET = "/home/claude/frost-thaw/build/concept/yeti_back_sheet.png"
BOX.update({"yetot_back": (70, 300, 610, 905), "yetitan_back": (640, 15, 1510, 905)})


def load(name):
    x0, y0, x1, y1 = BOX[name]
    src = np.asarray(Image.open(BACK_SHEET if name.endswith("_back") else SHEET).convert("RGB"))[y0:y1, x0:x1].copy()
    return src, x0, y0


# hand-placed cut-outs (sheet coordinates): plants, snow and paper between and below the feet
EXCLUDE = {
    "yetot": [[(40, 700), (140, 700), (135, 760), (122, 790), (110, 800), (110, 870), (40, 870)],
              [(440, 706), (620, 706), (620, 870), (472, 870), (472, 770), (430, 770), (430, 720)],
              [(40, 846), (620, 846), (620, 870), (40, 870)],
              [(258, 768), (335, 768), (335, 870), (258, 870)],
              [(335, 818), (480, 818), (480, 870), (335, 870)]],
    "yetitan": [[(620, 640), (790, 640), (800, 670), (797, 700), (778, 742), (735, 742), (735, 885), (620, 885)],
                [(735, 798), (1170, 798), (1170, 885), (735, 885)],
                [(938, 742), (1168, 742), (1168, 812), (938, 812)],
                [(1005, 668), (1035, 655), (1060, 668), (1085, 675), (1110, 690), (1135, 690), (1150, 740), (1160, 800), (1045, 800), (1040, 740), (1030, 700)],
                [(1432, 770), (1536, 770), (1536, 885), (1432, 885)],
                [(1160, 862), (1536, 862), (1536, 885), (1160, 885)]],
}


GAP_BOXES = {"yetot_back": [[(455, 680), (500, 680), (500, 770), (455, 770)]],
             "yetitan_back": [[(858, 470), (905, 470), (915, 500), (895, 560), (880, 615), (858, 615)],
                              [(1165, 465), (1222, 465), (1228, 560), (1262, 615), (1272, 665), (1250, 665), (1210, 590), (1172, 515)]]}


def cut(name):
    src, x0, y0 = load(name)
    f = src.astype(np.float32)
    lum = f @ np.array([0.3, 0.59, 0.11], np.float32)
    dark = ndi.gaussian_filter(np.maximum(0, 238 - lum), 1.5)
    mean = ndi.uniform_filter(lum, 7); sq = ndi.uniform_filter(lum * lum, 7)
    tex = np.sqrt(np.maximum(0, sq - mean * mean))
    r, g, b = f[..., 0], f[..., 1], f[..., 2]
    blue = (b - r) > 12                                    # skin, ice and shadowed snow
    fg = (dark > 10) | (tex > 9) | blue
    ex = Image.new("L", (src.shape[1], src.shape[0]), 0)
    from PIL import ImageDraw
    d = ImageDraw.Draw(ex)
    for poly in EXCLUDE.get(name, []):
        d.polygon([(x - x0, y - y0) for x, y in poly], fill=255)
    ex = np.asarray(ex) > 0
    fg &= ~ex
    fg = ndi.binary_closing(fg, structure=disk(6))
    fg = ndi.binary_fill_holes(fg)
    fg &= ~ex
    # paper showing through the narrow gaps between an arm and the body: inside each hand-placed box,
    # the flat (brush-free) paper-coloured patches are background
    if GAP_BOXES.get(name):
        paper_col = np.median(f[:40, :40].reshape(-1, 3), 0)
        m7 = ndi.uniform_filter(lum, 7); sd7 = np.sqrt(np.maximum(0, ndi.uniform_filter(lum * lum, 7) - m7 * m7))
        flat = (sd7 < 3.5) & (np.abs(f - paper_col).max(-1) < 12)
        bim = Image.new("L", (fg.shape[1], fg.shape[0]), 0)
        from PIL import ImageDraw as _D
        for poly in GAP_BOXES[name]:
            _D.Draw(bim).polygon([(px_ - x0, py_ - y0) for px_, py_ in poly], fill=255)
        box = np.asarray(bim) > 0
        gap = ndi.binary_dilation(flat & box & fg, iterations=2) & box
        fg &= ~gap
    fg = ndi.binary_opening(fg, structure=disk(3))
    lab, n = ndi.label(fg)
    if n > 1:
        sz = ndi.sum(fg, lab, range(1, n + 1)); main = lab == (np.argmax(sz) + 1)
        near = ndi.binary_dilation(main, structure=disk(8))
        fg = np.isin(lab, [i for i in range(1, n + 1) if sz[i - 1] > 300 and (near & (lab == i)).any()])
    return src, fg


if __name__ == "__main__":
    for nm in BOX:
        src, fg = cut(nm)
        v = src.copy(); v[~fg] = (255, 0, 255)
        Image.fromarray(v).save(SCR + nm + "_fg.png")


# ---------------------------------------------------------------------------------- reduction
def classify(src, fg):
    f = src.astype(int)
    r, g, b = f[..., 0], f[..., 1], f[..., 2]
    lum = 0.3 * r + 0.59 * g + 0.11 * b
    names = ["line", "fur", "skin", "ice"]
    mat = np.full(fg.shape, 1, int)
    blue = (b - r) > 22
    mat[blue & ((b - r) < 62) & (lum < 188)] = 2
    mat[blue & (((b - r) >= 62) | (lum >= 188))] = 3
    mat[lum < 72] = 0
    mat[~fg] = -1
    return mat, names


def sprite(name, size, ground=92, simplify=1.0, smooth=1.6, tones=None):
    import from_sheet as FS
    src, fg = cut(name)
    if tones is None:
        tones = FS.concept_tones(src, fg, classify, n=4)
    return FS.reduce_semantic(src, fg, size, classify, tones, ground=ground, simplify=simplify, smooth=smooth,
                              inner_lines=False), tones


def show(imgs, path, z=4, bg=(72, 80, 104, 255)):
    W = sum(i.width for i in imgs) * z + 10 * (len(imgs) + 1)
    out = Image.new("RGBA", (W, 96 * z + 20), bg)
    x = 10
    for im in imgs:
        out.alpha_composite(im.resize((im.width * z, im.height * z), Image.NEAREST), (x, 10)); x += im.width * z + 10
    out.save(path)


def pixelate(name, size, ground=92, colours=18, sharpen=1.0, contrast=1.0, canvas=96):
    """Area-average the painting down to sprite size, then snap to a small palette."""
    src, fg = cut(name)
    ys, xs = np.nonzero(fg)
    src, fg = src[ys.min():ys.max() + 1, xs.min():xs.max() + 1], fg[ys.min():ys.max() + 1, xs.min():xs.max() + 1]
    h, w = fg.shape
    s = size / max(h, w)
    tw, th = max(1, round(w * s)), max(1, round(h * s))
    f = src.astype(np.float32) * fg[..., None]
    if contrast != 1.0:
        f = np.clip((f - 200) * contrast + 200, 0, 255) * fg[..., None]
    cov = cv2.resize(fg.astype(np.float32), (tw, th), interpolation=cv2.INTER_AREA)
    col = cv2.resize(f, (tw, th), interpolation=cv2.INTER_AREA) / np.maximum(cov[..., None], 1e-4)
    if sharpen:
        blur = cv2.GaussianBlur(col, (0, 0), 1.0)
        col = np.clip(col + sharpen * (col - blur), 0, 255)
    on = cov >= 0.5
    out = np.zeros((canvas, canvas, 4), np.uint8)
    ox, oy = (canvas - tw) // 2, ground - th
    out[oy:oy + th, ox:ox + tw, :3] = col.astype(np.uint8)
    out[oy:oy + th, ox:ox + tw, 3] = np.where(on, 255, 0)
    img = Image.fromarray(out, "RGBA")
    from clean import limit_palette
    T = lambda X, Y: (ox + (X - BOX[name][0] - xs.min()) * s, oy + (Y - BOX[name][1] - ys.min()) * s)
    return limit_palette(img, colours), T


# ---------------------------------------------------------------------------------- faces, by hand
SKIN = [(96, 110, 146), (124, 138, 170), (150, 164, 194), (176, 190, 216)]
EYE = (22, 30, 64)
IRIS = (52, 92, 160)
NOSE = [(44, 50, 78), (70, 78, 110), (128, 140, 176)]
MOUTH = (58, 66, 100)

FACE = {
    "yetot": dict(oval=(350, 492, 74, 62), eyes=[((311, 466), 3, 4), ((375, 471), 2, 4)],
                  nose=((362, 492), 6, 4), mouth=[(316, 500), (334, 512), (362, 518), (390, 515), (406, 504)]),
    "yetitan": dict(oval=(1096, 222, 52, 42), eyes=[((1075, 194), 2, 2), ((1139, 205), 2, 2)],
                    nose=((1115, 218), 4, 3), mouth=[(1056, 226), (1084, 240), (1118, 245), (1140, 240)],
                    brows=[[(1060, 180), (1088, 188)], [(1150, 192), (1128, 198)]]),
}


def face_fix(img, T, spec):
    from clean import pixel_path
    px = img.load()
    cx, cy, rx, ry = spec["oval"]
    (X, Y), (X2, _) = T(cx, cy), T(cx + rx, cy)
    k = (X2 - X) / rx
    RX, RY = rx * k, ry * k
    # the bare face: blue pixels inside the oval get clean skin bands, lit from the upper left
    for y in range(96):
        for x in range(96):
            p = px[x, y]
            if p[3] < 255:
                continue
            u, v = (x + 0.5 - X) / RX, (y + 0.5 - Y) / RY
            lum = 0.3 * p[0] + 0.59 * p[1] + 0.11 * p[2]
            if u * u + v * v > 1.0 or (p[2] - p[0] < -2 and lum > 110):
                continue
            d = -0.55 * u - 0.75 * v
            band = 3 if d > 0.35 else 2 if d > -0.25 else 1 if d > -0.75 else 0
            px[x, y] = SKIN[band] + (255,)
    for (ex, ey), w, h in spec["eyes"]:
        x0, y0 = T(ex, ey)
        x0, y0 = int(round(x0 - w / 2)), int(round(y0 - h / 2))
        for j in range(h):
            for i in range(w):
                px[x0 + i, y0 + j] = (IRIS if (j >= h - 2 and h >= 4 and i > 0) else EYE) + (255,)
        px[x0, y0] = (240, 248, 255, 255)                          # catch-light
    (nx, ny), w, h = spec["nose"]
    x0, y0 = T(nx, ny)
    x0, y0 = int(round(x0 - w / 2)), int(round(y0 - h / 2))
    for j in range(h):
        for i in range(w):
            corner = (i in (0, w - 1)) and (j in (0, h - 1))
            if corner and w > 2:
                continue
            px[x0 + i, y0 + j] = (NOSE[0] if j == h - 1 or i == w - 1 else NOSE[1]) + (255,)
    px[x0 + 1, y0] = NOSE[2] + (255,)
    for (x, y) in pixel_path([T(*p) for p in spec["mouth"]]):
        px[x, y] = MOUTH + (255,)
    for b in spec.get("brows", []):
        for (x, y) in pixel_path([T(*p) for p in b]):
            px[x, y] = (88, 80, 84, 255)
    return img


def build(name, size, colours=20, contrast=1.3, sharpen=0.6):
    from clean import selout, cleanup_clusters
    im, T = pixelate(name, size, colours=colours, sharpen=sharpen, contrast=contrast)
    im = cleanup_clusters(im, 1)
    im = face_fix(im, T, FACE[name])
    return selout(im), T


FUR = [(196, 186, 188), (226, 214, 206), (244, 234, 220), (253, 247, 235)]
CHEST = {"yetot": (270, 575, 380, 670), "yetitan": (925, 320, 1115, 475)}


def despeck(img, max_size=3):
    """Tiny near-black blots inside the figure (pen dots in the painting) take their surroundings' colour."""
    import numpy as np
    from scipy import ndimage as ndi
    a = np.asarray(img).copy()
    lum = a[..., :3].astype(float) @ [0.3, 0.59, 0.11]
    dark = (a[..., 3] == 255) & (lum < 35)
    lab, n = ndi.label(dark)
    for i in range(1, n + 1):
        m = lab == i
        if m.sum() > max_size:
            continue
        ring = ndi.binary_dilation(m) & ~m
        if (a[ring][:, 3] < 255).any():
            continue                                   # on the outline: leave it
        cols = [tuple(c) for c in a[ring][:, :3]]
        a[m, :3] = max(set(cols), key=cols.count)
    return Image.fromarray(a, "RGBA")


def back(name, size):
    """From the user's back-view sheet, reduced exactly like the fronts. Saved mirrored, because the
    game mirrors back sprites when it shows them (so in battle it appears as drawn)."""
    from clean import selout, cleanup_clusters
    # the same scale as the front: size relative to each picture's own extent
    import numpy as np
    _, f = cut(name); _, b = cut(name + "_back")
    ext = lambda m: max(np.ptp(np.nonzero(m.any(0))[0]), np.ptp(np.nonzero(m.any(1))[0])) + 1
    bsize = min(90, int(round(size * ext(b) / ext(f))))
    im, _ = pixelate(name + "_back", bsize, colours=20, sharpen=0.6, contrast=1.3)
    im = despeck(selout(cleanup_clusters(im, 1)))
    return im


def export(root="/home/claude/frost-thaw/build/concept/yeti_sprites"):
    import os
    os.makedirs(root, exist_ok=True)
    for name, size in SIZES.items():
        f, _ = build(name, size)
        f.save(f"{root}/{name}_96.png")
        bk = back(name, size)
        bk.save(f"{root}/{name}_back_view_96.png")                       # as drawn (for previews)
        bk.transpose(Image.FLIP_LEFT_RIGHT).save(f"{root}/{name}_back_96.png")   # as stored for the game


SIZES = {"yetot": 74, "yetitan": 94}


def icons(root="/home/claude/frost-thaw/build/yeti_stage/Graphics/Pokemon/Icons"):
    """Party icons: two 64px frames, the second a pixel higher (the game alternates them)."""
    import os
    from clean import selout
    os.makedirs(root, exist_ok=True)
    for name, key, size in (("yetot", "YETOT", 46), ("yetitan", "YETITAN", 60)):
        im, _ = pixelate(name, size, ground=76, colours=14, sharpen=0.8, contrast=1.35)   # drawn at 96, cut to 64
        im = selout(im).crop((16, 16, 80, 80))
        icon = Image.new("RGBA", (128, 64), (0, 0, 0, 0))
        icon.alpha_composite(im, (0, 0)); icon.alpha_composite(im, (64, -2))
        icon.save(f"{root}/{key}.png")
