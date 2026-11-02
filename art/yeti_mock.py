"""The user's yeti fusion mockup sheets -> game sprites.

Every sheet has the same layout: four panels, each a FRONT and a BACK picture:
    top-left     Yetot head + X body        top-right     X head + Yetot body
    bottom-left  Yetitan head + X body      bottom-right  X head + Yetitan body
Labels, titles, and the decorative extras under a panel (Rimirage's ghost and sparkles) are not
figures: figures are big and drawn with a dark outline.

Pictures are cut out against the plain paper, reduced to 96px at one scale for the whole sheet (so
the yetis stay small and big relative to each other), and outlined. Backs are saved mirrored, as the
game mirrors back sprites when it shows them.
"""
import os, sys
import numpy as np
from PIL import Image
from scipy import ndimage as ndi

MOCK = "/home/claude/frost-thaw/build/concept/yeti_mockups"
SCR = "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/"
YT, YN = 587, 588
ORDER = [("YT_head", "front"), ("YT_head", "back"), ("YT_body", "front"), ("YT_body", "back"),
         ("YN_head", "front"), ("YN_head", "back"), ("YN_body", "front"), ("YN_body", "back")]


def figures(path, ground_shadows=False):
    src = np.asarray(Image.open(path).convert("RGB")).astype(np.int16)
    bg = np.median(src[:30, :30].reshape(-1, 3), 0)
    diff = np.abs(src - bg).max(-1)
    lum = src @ np.array([0.3, 0.59, 0.11])
    ink = diff > 22
    # panel frames (thin rounded boxes round each panel) are not figures: drop big, hollow line work
    lab0, n0 = ndi.label(ink, structure=np.ones((3, 3)))
    for i, sl in enumerate(ndi.find_objects(lab0), 1):
        hh, ww = sl[0].stop - sl[0].start, sl[1].stop - sl[1].start
        if hh > 250 and ww > 250 and (lab0[sl] == i).sum() < 0.08 * hh * ww:
            ink[sl] &= lab0[sl] != i
    # frame lines that touch a figure: long straight thin runs of ink (no creature has a 200px ruler edge)
    def long_runs(mask, axis):
        out = np.zeros_like(mask)
        a = mask if axis == 1 else mask.T
        o = out if axis == 1 else out.T
        for r in range(a.shape[0]):
            row = a[r]
            if row.sum() < 330:
                continue
            d = np.diff(np.concatenate([[0], row.astype(np.int8), [0]]))
            for s_, e_ in zip(np.nonzero(d == 1)[0], np.nonzero(d == -1)[0]):
                if e_ - s_ >= 330:
                    o[r, s_:e_] = True
        return out
    lines = long_runs(ink, 1) | long_runs(ink, 0)
    thick = ndi.binary_opening(ink, structure=np.ones((7, 7)))      # solid areas are not lines
    ink &= ~(ndi.binary_dilation(lines & ~thick, iterations=1) & ~thick)
    m = ndi.binary_closing(ink, structure=np.ones((5, 5)))
    filled = ndi.binary_fill_holes(m)
    # paper enclosed between legs (once a ground shadow is gone) is background, not white fur
    paper = filled & ~m & (diff < 9)
    lab_p, n_p = ndi.label(paper)
    if n_p:
        sz = ndi.sum(paper, lab_p, range(1, n_p + 1))
        filled &= ~np.isin(lab_p, [i + 1 for i, a in enumerate(sz) if a >= 120])
    m = filled
    lab, n = ndi.label(m)
    figs = []
    for i in range(1, n + 1):
        c = lab == i
        ys, xs = np.nonzero(c)
        h, w = np.ptp(ys) + 1, np.ptp(xs) + 1
        if c.sum() < 4000 or h < 110:
            continue
        dark = ((lum < 90) & c).sum() / c.sum()
        if dark < 0.02:                     # pale ghost images and sparkles have no outline
            continue
        # a soft grey ground shadow under the feet is not part of the figure
        y0_, y1_ = ys.min(), ys.max()
        band = np.zeros_like(c); band[y0_ + int((y1_ - y0_) * 0.82):y1_ + 1] = True
        shadow = c & band & (diff <= 75) & (np.abs(src[..., 0] - src[..., 2]) < 34) & (lum > 135) & (lum < 228)
        if ground_shadows and shadow.any():
            # only shadow lying outside the figure's ink outline: patches that reach the paper around it
            lab_s, n_s = ndi.label(shadow)
            outside = ndi.binary_dilation(~c, iterations=1)
            touch = np.unique(lab_s[outside & shadow])
            shadow = np.isin(lab_s, [t for t in touch if t])
            c = c & ~shadow
            lab_c, n_c = ndi.label(c)
            if n_c > 1:
                sz = ndi.sum(c, lab_c, range(1, n_c + 1))
                c = np.isin(lab_c, [i_ + 1 for i_, a_ in enumerate(sz) if a_ >= 0.02 * sz.max()])
            ys, xs = np.nonzero(c)
        figs.append((ys.mean(), xs.mean(), c))
    # two pictures drawn touching (a long tail reaching the next picture): split the extra-wide one
    # at its thinnest column
    while 0 < len(figs) < 8:
        widths = [np.ptp(np.nonzero(f[2].any(0))[0]) + 1 for f in figs]
        i = int(np.argmax(widths))
        if widths[i] < 1.5 * np.median(widths):
            break
        c = figs.pop(i)[2]
        cols = np.nonzero(c.any(0))[0]
        x0, x1 = cols.min(), cols.max()
        prof = c.sum(0)
        lo, hi = x0 + int((x1 - x0) * 0.3), x0 + int((x1 - x0) * 0.7)
        sx = lo + int(np.argmin(prof[lo:hi]))
        for part in (c.copy(), c.copy()):
            pass
        left = c.copy(); left[:, sx:] = False
        right = c.copy(); right[:, :sx] = False
        for part in (left, right):
            ys, xs = np.nonzero(part)
            figs.append((ys.mean(), xs.mean(), part))
    # two rows of four, left to right
    figs.sort(key=lambda f: f[0])
    rows = [figs[:4], figs[4:8]]
    out = []
    for r in rows:
        out += sorted(r, key=lambda f: f[1])
    return src.astype(np.uint8), [f[2] for f in out]


def reduce(src, mask, s, ground=92, colours=40):
    from clean import limit_palette, cleanup_clusters, selout
    ys, xs = np.nonzero(mask)
    y0, y1, x0, x1 = ys.min(), ys.max() + 1, xs.min(), xs.max() + 1
    c = src[y0:y1, x0:x1].astype(np.float32)
    m = mask[y0:y1, x0:x1].astype(np.float32)
    tw, th = max(1, round((x1 - x0) * s)), max(1, round((y1 - y0) * s))
    import cv2
    cov = cv2.resize(m, (tw, th), interpolation=cv2.INTER_AREA)
    col = cv2.resize(c * m[..., None], (tw, th), interpolation=cv2.INTER_AREA) / np.maximum(cov[..., None], 1e-4)
    out = np.zeros((96, 96, 4), np.uint8)
    ox, oy = (96 - tw) // 2, ground - th
    out[oy:oy + th, ox:ox + tw, :3] = np.clip(col, 0, 255).astype(np.uint8)
    out[oy:oy + th, ox:ox + tw, 3] = np.where(cov >= 0.5, 255, 0)
    img = limit_palette(Image.fromarray(out, "RGBA"), colours)
    return selout(cleanup_clusters(img, 1))


import json as _json
_SJ = f"{MOCK}/sheets.json"
SHEETS_FROM_FOLDER = {k: [v] * 4 for k, v in _json.load(open(_SJ)).items()} if os.path.exists(_SJ) else {}
SHEETS = {"rimirage": [580] * 4, "wickit": [582] * 4, "stoketail": [583] * 4, "forgel": [584] * 4, "lutling": [577] * 4, "hauntello": [578] * 4, "chorumbra": [579] * 4,
          "bulbasaur_charizard": [1, 1, 6, 6]}
SHEETS.update(SHEETS_FROM_FOLDER)


SHADOW_SHEETS = {"hoothoot", "houndour", "chikorita", "bayleef", "meganium", "pawniard", "bisharp", "swinub",
                 "piloswine", "squirtle", "wartortle", "blastoise"}     # drawn with grey ground shadows under the feet
# sheets already painted with the head's colours (the starter-piece batch): keep their colours as drawn
PRECOLOURED = {"chikorita", "bayleef", "meganium", "pawniard", "bisharp", "swinub", "piloswine",
               "squirtle", "wartortle", "blastoise"}


def convert(name, colours=True):
    src, masks = figures(f"{MOCK}/{name}.png", ground_shadows=name in SHADOW_SHEETS)
    if len(masks) != 8:
        raise ValueError(f"{name}: found {len(masks)} figures, expected 8")
    ext = max(max(np.ptp(np.nonzero(m.any(1))[0]), np.ptp(np.nonzero(m.any(0))[0])) + 1 for m in masks)
    s = 90 / ext
    imgs = [reduce(src, m, s) for m in masks]
    if colours and name not in PRECOLOURED:
        xs = SHEETS[name]
        imgs = [recolour(im, ORDER[i][0], xs[i // 2])[0] for i, im in enumerate(imgs)]
    return imgs


# ------------------------------------------------------------------------------------- colours
# In Infinite Fusion the HEAD gives a fusion its colours. So:
#   yeti head + X body: X's body takes the yeti's colours (snow-white fur, blue-grey skin, ice blue);
#   X head + yeti body: the yeti's body takes X's colours (fur -> X's main colour, hands and feet ->
#   X's dark colour, ice and the chest V -> X's accent).
# Light and dark keep their places within each colour.
import colorsys
FUR = [(122, 112, 136), (168, 158, 176), (208, 198, 204), (236, 228, 222), (252, 247, 238)]
SKIN = [(60, 72, 108), (92, 108, 148), (128, 146, 186), (166, 186, 218)]
ICE = [(70, 120, 190), (120, 170, 226), (180, 214, 244), (232, 246, 255)]


def L(c):
    return 0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2]


def H(c):
    return colorsys.rgb_to_hsv(*(v / 255 for v in c[:3]))


def yeti_family(c):
    """Which part of a yeti a colour belongs to: 'fur', 'skin', 'ice', or None (outline / not yeti)."""
    l = L(c)
    if l < 40:
        return None
    h, s_, v = H(c)
    blue = 0.52 <= h <= 0.75
    if blue and (s_ > 0.4 or (l > 165 and s_ > 0.14)):
        return "ice"
    if blue and s_ > 0.1:
        return "skin"
    if s_ < 0.36 and l > 120 and not (0.02 < h < 0.14 and s_ > 0.25):   # whites, creams, lavender shade
        return "fur"
    return None


def ramp(cols, n=5):
    """A smooth n-step ramp through a family's colours (dark -> light)."""
    cols = sorted(cols, key=L)
    if len(cols) == 1:
        c = np.array(cols[0], float)
        cols = [tuple(c * 0.55), tuple(c), tuple(np.minimum(255, c * 1.15 + 20))]
    xs = np.linspace(0, len(cols) - 1, n)
    arr = np.array(cols, float)
    return [tuple(int(v) for v in arr[int(np.floor(x))] * (1 - (x % 1)) + arr[min(len(cols) - 1, int(np.floor(x)) + 1)] * (x % 1)) for x in xs]


def families_of(pixels):
    from fusegen_core import colour_groups
    im = Image.new("RGBA", (max(1, len(pixels)), 1))
    im.putdata([tuple(p) + (255,) for p in pixels])
    return colour_groups(im)


_PAL = {}


def x_palette(x, a=None, head=None):
    """The colours X gives a yeti body: its main colour for the fur (the strong tones, not its creams),
    its common dark tones for the hands and feet, its second colour for the ice and the chest V.
    Taken from X's own picture, so all four pictures of a fusion agree."""
    if x in _PAL:
        return _PAL[x]
    from yeti_fuse import base_of
    from collections import Counter
    b = np.asarray(base_of(x).convert("RGBA"))
    base_px = [tuple(p[:3]) for p in b.reshape(-1, 4) if p[3] > 127]
    gs = [g for g in families_of([c for c in base_px if 60 <= L(c) <= 250]) if g["n"] >= 0.01 * len(base_px)]
    chrom = [g for g in gs if not g["neutral"]] or gs
    # a grey or black Pokemon (Poochyena, Duskull) is grey: a small coloured patch (red eyes) isn't its main colour
    main = chrom[0] if chrom[0]["n"] >= 0.3 * gs[0]["n"] else gs[0]
    strong = ([c for c in main["cols"] if H(c)[1] >= 0.3] if not main["neutral"] else []) or main["cols"]
    fur = ramp(strong, 5)
    dk = Counter(c for c in base_px if 42 <= L(c) < 105)
    dark = [c for c, _ in dk.most_common(4)] or [tuple(int(v * 0.5) for v in main["cols"][-1])]
    acc = [g for g in chrom if g is not main and not g["neutral"] and
           (main["neutral"] or min(abs(g["hue"] - main["hue"]), 1 - abs(g["hue"] - main["hue"])) > 0.08)]
    accent = acc[0]["cols"] if acc else [tuple(min(255, int(v * 1.2 + 30)) for v in c) for c in main["cols"]]
    _PAL[x] = {"fur": fur, "skin": ramp(dark, 4), "ice": ramp(accent, 4)}
    return _PAL[x]


def head_cut(a, head_is_yeti):
    """The row where the head ends: the first row (from the top of the figure) after which the other
    Pokemon's colours take over (yeti head) or the yeti's fur takes over (yeti body)."""
    on = a[..., 3] > 127
    rows = np.nonzero(on.any(1))[0]
    top, bot = rows.min(), rows.max()
    yeti_frac = []
    for y in range(top, bot + 1):
        cs = [tuple(c) for c in a[y][on[y]][:, :3]]
        fam = [yeti_family(c) for c in cs]
        yeti_frac.append(sum(f is not None for f in fam) / max(1, len(cs)))
    yf = np.convolve(yeti_frac, np.ones(3) / 3, mode="same")
    # first find where the head itself starts (its colours take over), then where it ends
    if head_is_yeti:
        starts = [i for i in range(len(yf)) if yf[i] > 0.5]
    else:
        starts = [i for i in range(len(yf)) if yf[i] < 0.5]
    start = (starts[0] if starts else 0) + max(2, int((bot - top) * 0.08))
    for i in range(start, len(yf) - 2):
        if head_is_yeti and max(yf[i:i + 3]) < 0.42:
            return top + i
        if not head_is_yeti and min(yf[i:i + 3]) > 0.72:
            return top + i
    return top + int((bot - top) * 0.4)


def quantile_map(counts, target, lo_t=0.0, hi_t=1.0):
    """Colours -> target ramp by rank (weighted by how many pixels use each), so the whole ramp is used
    the way the source used its own light and dark."""
    cols = sorted(counts, key=L)
    tot = sum(counts.values()) or 1
    run, out = 0, {}
    for c in cols:
        mid = (run + counts[c] / 2) / tot
        run += counts[c]
        t = lo_t + (hi_t - lo_t) * mid
        out[c] = target[min(len(target) - 1, int(t * len(target)))]
    return out


def head_mask(a, head_is_yeti):
    on = a[..., 3] > 127
    fam = np.zeros(on.shape, object)
    is_yeti = np.zeros(on.shape, bool)
    for y, x in zip(*np.nonzero(on)):
        f = yeti_family(tuple(a[y, x, :3]))
        is_yeti[y, x] = f is not None and not (head_is_yeti and f == "ice")
    cut = head_cut(a, head_is_yeti)
    rows = np.nonzero(on.any(1))[0]
    top, bot = rows.min(), rows.max()
    if head_is_yeti:
        # the yeti's head: the biggest patch of yeti colours above the cut (mane, face, ears)
        allowed = is_yeti.copy(); allowed[cut + int((bot - top) * 0.06):] = False
        lab, n = ndi.label(allowed, structure=np.ones((3, 3)))
        if n:
            sizes = ndi.sum(allowed, lab, range(1, n + 1))
            big = sizes.max()
            head = np.isin(lab, [i + 1 for i, a_ in enumerate(sizes) if a_ >= 0.3 * big])
        else:
            head = np.zeros_like(on)
    else:
        # the other Pokemon's head: its colours above the collar, closed up so its own pale parts
        # (a muzzle, a face) come with it, plus anything of its colours hanging below the collar
        xcol = on & ~is_yeti
        above = xcol.copy(); above[cut:] = False
        head = ndi.binary_closing(above, structure=np.ones((7, 7))) & on
        lab, n = ndi.label(xcol, structure=np.ones((3, 3)))
        touch = np.unique(lab[head])
        head |= np.isin(lab, [t for t in touch if t])
    head = ndi.binary_fill_holes(head)
    head = ndi.binary_dilation(head) & on                     # its own outline
    return head, cut


def recolour(img, kind, x):
    """kind: 'YT_head'/'YN_head' (yeti head on X) or 'YT_body'/'YN_body' (X head on a yeti)."""
    a = np.asarray(img).copy()
    head_is_yeti = kind.endswith("_head")
    head, cut = head_mask(a, head_is_yeti)
    on = a[..., 3] > 127
    body = on & ~head
    from collections import Counter
    cnt = Counter(tuple(c) for c in a[body][:, :3] if L(c) >= 40)
    cmap = {}
    if head_is_yeti:
        gs = families_of(list(cnt.elements()))
        chrom = [g for g in gs if not g["neutral"]]
        main_hue = chrom[0]["hue"] if chrom else None
        groups = {"fur": {}, "skin": {}, "ice": {}, "white": {}}
        for c, n in cnt.items():
            h, s_, v = H(c)
            if L(c) < 95:
                key = "skin"                                   # paws, dark markings -> blue-grey skin
            elif s_ < 0.18 and L(c) > 150:
                key = "white"
            elif main_hue is not None and min(abs(h - main_hue), 1 - abs(h - main_hue)) < 0.08:
                key = "fur"
            else:
                key = "ice"                                    # accents -> ice blue
            groups[key][c] = n
        cmap.update(quantile_map(groups["fur"], FUR, 0.3, 1.0))
        cmap.update(quantile_map(groups["white"], FUR, 0.75, 1.0))
        cmap.update(quantile_map(groups["skin"], SKIN, 0.0, 0.85))
        cmap.update(quantile_map(groups["ice"], ICE))
    else:
        pal = x_palette(x, a, head)
        groups = {"fur": {}, "skin": {}, "ice": {}}
        for c, n in cnt.items():
            f = yeti_family(c)
            if f:
                groups[f][c] = n
        cmap.update(quantile_map(groups["fur"], pal["fur"], 0.1, 1.0))
        cmap.update(quantile_map(groups["skin"], pal["skin"]))
        cmap.update(quantile_map(groups["ice"], pal["ice"]))
    for y, xx in zip(*np.nonzero(body)):
        c = tuple(a[y, xx, :3])
        if c in cmap:
            a[y, xx, :3] = cmap[c]
    return Image.fromarray(a, "RGBA"), head


def show(imgs, path, z=3, bg=(150, 176, 206, 255)):
    out = Image.new("RGBA", (4 * (96 * z + 8) + 8, (len(imgs) + 3) // 4 * (96 * z + 8) + 8), bg)
    for i, im in enumerate(imgs):
        out.alpha_composite(im.resize((96 * z, 96 * z), Image.NEAREST), (8 + (i % 4) * (96 * z + 8), 8 + (i // 4) * (96 * z + 8)))
    out.save(path)


if __name__ == "__main__":
    for nm in sys.argv[1:]:
        show(convert(nm, False) + convert(nm), SCR + f"mock_{nm}.png")


def export(names, root="/home/claude/frost-thaw/build/yeti_mock_stage"):
    """Fronts to fusions/<head>/<head>.<body>.png, backs (mirrored) to back/fusions/... , at 288px."""
    done = []
    for nm in names:
        imgs = convert(nm)
        for i, im in enumerate(imgs):
            kind, view = ORDER[i]
            x = SHEETS[nm][i // 2]
            yeti = YT if kind.startswith("YT") else YN
            h, b = (yeti, x) if kind.endswith("_head") else (x, yeti)
            sub = "fusions" if view == "front" else "back/fusions"
            if view == "back":
                im = im.transpose(Image.FLIP_LEFT_RIGHT)
            path = f"{root}/Graphics/Battlers/FrostThaw/{sub}/{h}/{h}.{b}.png"
            os.makedirs(os.path.dirname(path), exist_ok=True)
            im.resize((288, 288), Image.NEAREST).save(path, optimize=True)
            done.append(path)
    return done
