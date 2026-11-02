"""Yeti fusions that keep both parents (the user's "preserve both parents" sheet).

  yeti HEAD on X's body: X keeps its own body - shape, colours, wings, bulb, tail - and its head is
      replaced by the yeti's head (white mane, blue-grey face). Yeti touches on the body: the blue V
      on the chest and blue-grey soles.
  X's HEAD on a yeti body: the yeti keeps its body - white fur, blue-grey hands and feet, ice plates
      - and X's head (with its ears, horns, crest) sits on the yeti's shoulders.

Where X's head is: Infinite Fusion's own automatic fusions show it. Every automatic fusion onto body
X pastes the head's face in the same place, so the pixels that change from head to head mark X's
face (fusegen_core.body_info). The head is the face zone grown out to the ears and horns above it.
"""
import os, math
import numpy as np
from PIL import Image
from scipy import ndimage as ndi
from fusegen_core import Sheets, body_info, opaque, components, lum, hsv, S, AUTOGEN_MAX

AUTOGEN = "/home/claude/pifrun/Graphics/Battlers/spritesheets_autogen"
OURS_BASE = "/home/claude/pifrun/Graphics/Battlers/FrostThaw/base"
YDIR = "/home/claude/frost-thaw/build/concept/yeti_sprites"
SCR = "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/"
YT, YN = 587, 588

SKIN = [(84, 98, 136), (118, 134, 170), (152, 172, 206), (190, 210, 234)]
SKIN_OL = (44, 52, 80)


def arr(img):
    return np.asarray(img.convert("RGBA")).copy()


def ellipse_mask(cx, cy, rx, ry):
    yy, xx = np.mgrid[0:S, 0:S]
    return ((xx + 0.5 - cx) / rx) ** 2 + ((yy + 0.5 - cy) / ry) ** 2 <= 1


# ------------------------------------------------------------------------------- the yeti's parts
YETI = {
    # head mask pieces (sprite px), face centre and width, the neck (where a head sits on the body)
    YT: dict(file="yetot", head=[("ell", 51, 38, 20, 19), ("ell", 54, 22, 12, 9)], not_head=[("rect", 0, 44, 37, 96)],
             hole=[("ell", 52, 37, 16, 17), ("ell", 54, 22, 12, 9)],
             neck_y=56, face=(54, 44), face_w=18, chest=(51, 63)),
    YN: dict(file="yetitan", head=[("ell", 50, 19, 15, 15), ("ell", 50, 6, 10, 7)], not_head=[("rect", 0, 24, 35, 96)],
             hole=[("ell", 51, 18, 12, 13), ("ell", 50, 6, 10, 7)],
             neck_y=34, face=(51, 23), face_w=12, chest=(49, 42)),
}


def region(spec):
    m = np.zeros((S, S), bool)
    yy, xx = np.mgrid[0:S, 0:S]
    for s in spec:
        if s[0] == "ell":
            m |= ellipse_mask(*s[1:])
        else:
            x0, y0, x1, y1 = s[1:]
            m |= (xx >= x0) & (xx < x1) & (yy >= y0) & (yy < y1)
    return m


def yeti_parts(n):
    d = YETI[n]
    a = arr(Image.open(f"{YDIR}/{d['file']}_96.png"))
    on = a[..., 3] > 127
    yy = np.mgrid[0:S, 0:S][0]
    blue = (a[..., 2].astype(int) - a[..., 0].astype(int)) > 12
    head = on & region(d["head"]) & ~(region(d["not_head"]) & blue) & (yy < d["neck_y"])
    hole = on & region(d["hole"]) & ~(region(d["not_head"]) & blue)
    return a, head, hole


def drop_scraps(a, keep_min=14):
    """After a cut: loose bits (the tip of an ear, a stray outline pixel) go."""
    on = a[..., 3] > 127
    lab, n = ndi.label(on, structure=np.ones((3, 3)))
    if n > 1:
        sizes = ndi.sum(on, lab, range(1, n + 1))
        for i, sz in enumerate(sizes):
            if sz < sizes.max() and (sz < keep_min or sz < 0.15 * sizes.max()):
                a[lab == i + 1] = 0
    return a


def outline_cut(a, was_edge):
    """Pixels that became edge pixels after a cut get a dark outline of their own colour."""
    on = a[..., 3] > 127
    edge = on & ~ndi.binary_erosion(on)
    new = edge & ~was_edge
    for y, x in zip(*np.nonzero(new)):
        a[y, x, :3] = (a[y, x, :3] * 0.4).astype(np.uint8)
    return a


# ------------------------------------------------------------------------------- X's parts
SHEETS = None


def sheets():
    global SHEETS
    if SHEETS is None:
        SHEETS = Sheets(AUTOGEN)
    return SHEETS


def base_of(x):
    if x <= AUTOGEN_MAX:
        return sheets().autogen(x, x)
    p = f"{OURS_BASE}/{x}.png"
    if x in YETI:
        p = f"{YDIR}/{YETI[x]['file']}_96.png"
        return Image.open(p).convert("RGBA")
    return Image.open(p).convert("RGBA").resize((S, S), Image.NEAREST) if os.path.exists(p) else None


_ZONES = {}
# faces of Frost & Thaw's own Pokemon, read off their pictures (cx, cy, w, h)
OUR_ZONES = {577: (44, 66, 14, 12), 578: (44, 59, 16, 12), 579: (46, 40, 14, 12), 580: (26, 49, 16, 12),
             581: (48, 58, 30, 16), 582: (34, 54, 18, 16), 583: (63, 26, 18, 18), 584: (63, 41, 16, 14),
             585: (52, 54, 16, 12), 586: (48, 42, 18, 14)}


def head_zone(x):
    """(cx, cy, w, h) of X's face in its own picture. Infinite Fusion's automatic fusions find the face
    on their own (slightly simplified) body picture; that is laid over the real picture by matching the
    two silhouettes."""
    if x in _ZONES:
        return _ZONES[x]
    from fusegen_core import guess_head_zone
    b = base_of(x)
    if x in YETI:
        d = YETI[x]
        z = (d["face"][0], d["face"][1], d["face_w"], d["face_w"])
    elif x in OUR_ZONES:
        z = OUR_ZONES[x]
    elif x > AUTOGEN_MAX:
        z = guess_head_zone(b)
    else:
        img, _m, z = body_info(sheets(), x)
        A = (np.asarray(img)[..., 3] > 127).astype(np.float32)
        B = (np.asarray(b)[..., 3] > 127).astype(np.float32)
        best = None
        for dy in range(-12, 13):
            for dx in range(-12, 13):
                sh = np.roll(np.roll(A, dy, 0), dx, 1)
                sc = (sh * B).sum() - 0.5 * (sh * (1 - B)).sum()
                if best is None or sc > best[0]:
                    best = (sc, dx, dy)
        z = (z[0] + best[1], z[1] + best[2], z[2], z[3])
    _ZONES[x] = z
    return z


def head_mask_of(x, a, z):
    """X's head: the face zone grown out, plus ears / horns / crests connected above it; cut at the neck."""
    cx, cy, w, h = z
    on = a[..., 3] > 127
    yy, xx = np.mgrid[0:S, 0:S]
    core = on & ellipse_mask(cx, cy - h * 0.1, max(7, w * 0.65), max(7, h * 0.72))
    above = on & (yy < cy - h * 0.4) & (abs(xx - cx) < max(9, w * 0.95))
    lab, n = ndi.label(above | core)
    keep = np.isin(lab, np.unique(lab[core]))
    head = keep & ((yy <= cy + h * 0.65) | core)
    # keep the head in one piece
    lab, n = ndi.label(head)
    if n > 1:
        sizes = ndi.sum(head, lab, range(1, n + 1))
        head = lab == (np.argmax(sizes) + 1)
    return head


def crop(a, m):
    ys, xs = np.nonzero(m)
    x0, y0, x1, y1 = xs.min(), ys.min(), xs.max() + 1, ys.max() + 1
    piece = a[y0:y1, x0:x1].copy()
    piece[~m[y0:y1, x0:x1]] = 0
    return piece, (x0, y0)


def scale_piece(piece, k):
    if abs(k - 1) < 0.04:
        return piece
    im = Image.fromarray(piece, "RGBA")
    w, h = max(1, round(im.width * k)), max(1, round(im.height * k))
    if k < 1:
        # shrink: average, then snap back to the piece's own colours
        from fusegen2 import shrink
        return np.asarray(shrink(im, k)).copy()
    return np.asarray(im.resize((w, h), Image.NEAREST)).copy()


def paste(a, piece, x, y):
    h, w = piece.shape[:2]
    for j in range(h):
        for i in range(w):
            if piece[j, i, 3] > 127 and 0 <= y + j < S and 0 <= x + i < S:
                a[y + j, x + i] = piece[j, i]
    return a


# ------------------------------------------------------------------------------- yeti marks
def chest_v(a, cx, top, w=7):
    """The yeti's blue V on the chest, drawn only onto the body itself."""
    pts = []
    for i in range(w):
        dx = i - (w - 1) / 2
        y = top + int(round(abs(dx) * -0.6 + (w - 1) / 2 * 0.6))
        pts += [(int(round(cx + dx)), y), (int(round(cx + dx)), y + 1)]
    pts.append((int(round(cx)), top + int(round((w - 1) / 2 * 0.6)) + 2))
    on = a[..., 3] > 127
    inner = ndi.binary_erosion(on, iterations=2)
    if not all(0 <= x < S and 0 <= y < S and inner[y, x] for x, y in pts):
        return a
    for x, y in pts:
        a[y, x, :3] = SKIN[2] if y == min(p[1] for p in pts if p[0] == x) else SKIN[1]
    return a


def soles(a):
    """Blue-grey soles: the lowest pixels of every foot on the ground (the outline stays)."""
    on = a[..., 3] > 127
    ys, xs = np.nonzero(on)
    if not len(ys):
        return a
    bottom = ys.max()
    for x in range(xs.min(), xs.max() + 1):
        col = np.nonzero(on[:, x])[0]
        if not len(col) or col.max() < bottom - 2:
            continue
        y = col.max()
        for dy, c in ((1, SKIN[1]), (2, SKIN[2])):
            q = y - dy
            if q >= 0 and on[q, x] and lum(tuple(int(v) for v in a[q, x, :3])) >= 45:
                a[q, x, :3] = c
    return a


# ------------------------------------------------------------------------------- the two fusions
def yeti_head_on(yeti, x):
    """The yeti's head on X's body."""
    base = base_of(x)
    if base is None:
        return None
    a = arr(base)
    on0 = a[..., 3] > 127
    was_edge = on0 & ~ndi.binary_erosion(on0)
    z = head_zone(x)
    cx, cy, w, h = z
    hm = head_mask_of(x, a, z)
    ya, yhead, _ = yeti_parts(yeti)
    yon = ya[..., 3] > 127
    ha = ya.copy(); ha[~yhead] = 0
    ha = outline_cut(ha, yon & ~ndi.binary_erosion(yon))
    piece, (px0, py0) = crop(ha, yhead)
    d = YETI[yeti]
    hw = piece.shape[1]
    k = float(np.clip(max(w, h) * 1.75 / hw, 0.4, 1.0))
    piece = scale_piece(piece, k)
    fx, fy = (d["face"][0] - px0) * k, (d["face"][1] - py0) * k
    # erase X's head (what the yeti's head won't cover: ears, horns, crests), then the yeti's head
    # goes where X's face was
    yy = np.mgrid[0:S, 0:S][0]
    before = a.copy()
    a[hm & (yy < cy + h * 0.35)] = 0
    a = drop_scraps(a)
    if (a[..., 3] > 127).sum() < 0.4 * on0.sum():          # a Pokemon that is mostly head keeps its body
        a = before
        k = float(np.clip(max(w, h) * 1.3 / hw, 0.35, 1.0))
        piece, (px0, py0) = crop(ha, yhead)
        piece = scale_piece(piece, k)
        fx, fy = (d["face"][0] - px0) * k, (d["face"][1] - py0) * k
    a = outline_cut(a, was_edge)
    ox, oy = int(round(cx - fx)), int(round(cy - fy))
    ph = piece.shape[0]
    oy = min(oy, S - ph)
    a = paste(a, piece, ox, oy)
    a = chest_v(a, cx, oy + ph + 1, w=max(5, int(round(7 * k + 0.5)) | 1))
    a = soles(a)
    return Image.fromarray(a, "RGBA")


def head_on_yeti(x, yeti):
    """X's head on the yeti's body."""
    base = base_of(x)
    if base is None:
        return None
    xa = arr(base)
    z = head_zone(x)
    hm = head_mask_of(x, xa, z)
    on = xa[..., 3] > 127
    was_edge = on & ~ndi.binary_erosion(on)
    hx = xa.copy(); hx[~hm] = 0
    hx = outline_cut(hx, was_edge & hm)
    piece, (px0, py0) = crop(hx, hm)
    ya, yhead, yhole = yeti_parts(yeti)
    d = YETI[yeti]
    a = ya.copy()
    on_y = a[..., 3] > 127
    was_edge_y = on_y & ~ndi.binary_erosion(on_y)
    a[yhole] = 0
    yhw = np.ptp(np.nonzero(yhole.any(0))[0]) + 1
    k = float(np.clip(yhw * 1.1 / piece.shape[1], 0.5, 1.3))
    piece = scale_piece(piece, k)
    ph, pw = piece.shape[:2]
    fx = (z[0] - px0) * k
    ox = int(round(d["face"][0] - fx))
    hole_bottom = np.nonzero(yhole.any(1))[0].max()
    oy = hole_bottom + 2 - ph
    oy = max(0, oy)
    a = paste(a, piece, ox, oy)
    headpix = np.zeros((S, S), bool)
    hh, ww = piece.shape[:2]
    sub = piece[max(0, -oy):min(hh, S - oy), max(0, -ox):min(ww, S - ox), 3] > 127
    headpix[max(0, oy):max(0, oy) + sub.shape[0], max(0, ox):max(0, ox) + sub.shape[1]] = sub
    a = outline_cut(a, was_edge_y | headpix)                # only the hole's edge left showing gets a line
    return Image.fromarray(a, "RGBA")


def sheet(pairs, path, z=2):
    out = Image.new("RGBA", (len(pairs) * (S * z + 6) + 6, 2 * (S * z + 6) + 6), (150, 176, 206, 255))
    for i, (yeti, x) in enumerate(pairs):
        for r, fn in enumerate((lambda: yeti_head_on(yeti, x), lambda: head_on_yeti(x, yeti))):
            im = fn()
            if im is not None:
                out.alpha_composite(im.resize((S * z, S * z), Image.NEAREST), (6 + i * (S * z + 6), 6 + r * (S * z + 6)))
    out.save(path)


def fusion(h, b):
    if h == b:
        return base_of(h)
    if b in YETI:
        return head_on_yeti(h, b)
    return yeti_head_on(h, b)


def job(n):
    out = "/home/claude/frost-thaw/build/ft_yeti2"
    errs = []
    for y in (YT, YN):
        for h, b in ((y, n), (n, y)):
            if n in (YT, YN) and (h, b) != (y, n):
                continue
            try:
                im = fusion(h, b)
                if im is None:
                    errs.append((h, b, "none")); continue
                os.makedirs(f"{out}/fusions/{h}", exist_ok=True)
                im.resize((S * 3, S * 3), Image.NEAREST).save(f"{out}/fusions/{h}/{h}.{b}.png", optimize=True)
            except Exception as e:
                errs.append((h, b, f"{type(e).__name__}: {e}"))
    return errs


def generate():
    from multiprocessing import Pool
    errs = []
    with Pool() as pool:
        for e in pool.imap_unordered(job, list(range(1, 589)), chunksize=4):
            errs += e
    print("problems:", len(errs))
    for e in errs[:30]:
        print(" ", e)


if __name__ == "__main__" and len(__import__("sys").argv) > 1 and __import__("sys").argv[1] == "all":
    generate()
elif __name__ == "__main__":
    sheet([(YT, 1), (YN, 6), (YT, 25), (YN, 94), (YT, 143), (YN, 7), (YT, 338), (YN, 220)], SCR + "yf1.png")
