"""Brings a designer batch in line with the Style guide (Cutscene Art & Effects List, Style guide tab):
- action sheets: body colours snapped to the character's walking sheet; glows and props kept, reduced
  to a few extra colours; total within the limit
- effects, balloons and creature sheets: reduced to their colour limit (k-means in Lab, hard alpha)
- E-02 (Alberica's rune): enlarged to 2x and given a flare that grows, then a loop
- FT_meat_meat.png: step frames shifted back onto the 2x grid
Usage: python3 fix_batch.py <in Graphics dir> <out Graphics dir> <walking sheets dir>
"""
import sys, os, shutil
import numpy as np, cv2
from PIL import Image

SRC, OUT, WALK = sys.argv[1:4]

def lab(px):
    return cv2.cvtColor(px.reshape(-1, 1, 3).astype(np.uint8), cv2.COLOR_RGB2LAB).reshape(-1, 3).astype(np.float32)

def load(p):
    a = np.array(Image.open(p).convert('RGBA'))
    a[..., 3] = np.where(a[..., 3] >= 128, 255, 0)
    a[a[..., 3] == 0] = 0
    return a

def kmeans(px, k):
    k = min(k, len(np.unique(px.reshape(-1, 3), axis=0)))
    Z = lab(px)
    crit = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 60, 0.3)
    cv2.setRNGSeed(7)
    _, lbl, _ = cv2.kmeans(Z, k, None, crit, 4, cv2.KMEANS_PP_CENTERS)
    lbl = lbl.ravel()
    # the most common real colour of each cluster (keeps crisp, existing colours)
    pal = []
    for i in range(k):
        m = px[lbl == i]
        if len(m) == 0:
            pal.append([0, 0, 0]); continue
        u, c = np.unique(m, axis=0, return_counts=True)
        pal.append(u[np.argmax(c)])
    return np.array(pal, np.uint8), lbl

def reduce(a, k):
    m = a[..., 3] > 0
    px = a[m][:, :3]
    pal, lbl = kmeans(px, k)
    a = a.copy(); a[m, :3] = pal[lbl]
    return a

def snap_to(a, walk, extra=6, thresh=14.0):
    w = load(walk)
    wp = np.unique(w[w[..., 3] > 0][:, :3], axis=0)
    m = a[..., 3] > 0
    px = a[m][:, :3]
    L, P = lab(px), lab(wp)
    d = ((L[:, None, :] - P[None, :, :]) ** 2).sum(-1)
    idx = d.argmin(1); dist = np.sqrt(d.min(1))
    out = px.copy()
    near = dist < thresh
    out[near] = wp[idx[near]]
    far = ~near
    if far.any():
        epal, lbl = kmeans(px[far], extra)
        out[far] = epal[lbl]
    a = a.copy(); a[m, :3] = out
    return a

def ncolours(a):
    return len(np.unique(a[a[..., 3] > 0][:, :3], axis=0))

def on_grid(a):
    return (a[0::2, 0::2] == a[1::2, 0::2]).all() and (a[0::2, 0::2] == a[0::2, 1::2]).all()

def regrid(a):
    """Force 2x2 blocks: each block takes its most common pixel."""
    h, w = a.shape[:2]
    out = a.copy()
    for y in range(0, h, 2):
        for x in range(0, w, 2):
            blk = a[y:y + 2, x:x + 2].reshape(-1, 4)
            u, c = np.unique(blk, axis=0, return_counts=True)
            out[y:y + 2, x:x + 2] = u[np.argmax(c)]
    return out

def save(a, rel):
    p = os.path.join(OUT, rel); os.makedirs(os.path.dirname(p), exist_ok=True)
    Image.fromarray(a).save(p)
    print(f"{rel}: {ncolours(a)} colours, 2x grid {'ok' if on_grid(a) else 'BROKEN'}")

ACTIONS = {'P-ALB-04': 'FT_alberica_rune', 'P-REP-02': 'FT_reptin', 'P-SHA-02': 'FT_shade',
           'K-RZY-02': 'FT_razzy', 'P-AUR-04': 'FT_auril_furs'}
LIMIT = {'E-01': 12, 'E-03': 16, 'B-06': 8, 'K-EGG-01': 24}

for name, walk in ACTIONS.items():
    a = load(f"{SRC}/Characters/{name}.png")
    a = regrid(snap_to(a, f"{WALK}/{walk}.png"))
    save(a, f"Characters/{name}.png")
for name, k in LIMIT.items():
    rel = {'E-01': 'Animations/E-01.png', 'E-03': 'Animations/E-03.png', 'B-06': 'Pictures/Balloons/B-06.png',
           'K-EGG-01': 'Characters/K-EGG-01.png'}[name]
    save(regrid(reduce(load(f"{SRC}/{rel}"), k)), rel)

# E-02: the rune, 2x bigger, with a flare that grows then a pulse that loops (frames 4 to 7)
a = load(f"{SRC}/Animations/E-02.png")
cell = lambda i: a[(i // 5) * 192:(i // 5) * 192 + 192, (i % 5) * 192:(i % 5) * 192 + 192]
base = reduce(cell(3), 10)                           # the brightest designed frame
ys, xs = np.nonzero(base[..., 3]); y0, y1, x0, x1 = ys.min(), ys.max() + 1, xs.min(), xs.max() + 1
rune = base[y0:y1, x0:x1]                            # native-on-2x, e.g. 16x20 screen px
def scaled(img, f):
    return np.array(Image.fromarray(img).resize((img.shape[1] * f, img.shape[0] * f), Image.NEAREST))
def brighten(img, amt):
    out = img.copy(); m = out[..., 3] > 0
    out[m, :3] = np.clip(out[m, :3].astype(int) + amt, 0, 255).astype(np.uint8)
    return out
def ring(size, colour, r_out, r_in):
    g = np.zeros((size, size, 4), np.uint8)
    yy, xx = np.mgrid[:size, :size]; c = (size - 1) / 2
    d = np.sqrt((yy - c) ** 2 + (xx - c) ** 2)
    m = (d <= r_out) & (d >= r_in)
    g[m] = list(colour) + [255]
    return regrid(g)
def place(dst, img):
    h, w = img.shape[:2]; oy, ox = (192 - h) // 2, (192 - w) // 2
    oy -= oy % 2; ox -= ox % 2
    reg = dst[oy:oy + h, ox:ox + w]; m = img[..., 3] > 0; reg[m] = img[m]
frames = []
big = scaled(rune, 2)
plan = [(rune, None), (big, (44, (198, 235, 248), 22, 18)), (brighten(big, 40), (44, (255, 255, 255), 26, 22)),
        (big, (48, (138, 205, 251), 28, 26)), (big, None), (brighten(big, 25), None), (brighten(big, 45), None), (brighten(big, 25), None)]
sheet = np.zeros((384, 960, 4), np.uint8)
for i, (img, rg) in enumerate(plan):
    c = np.zeros((192, 192, 4), np.uint8)
    if rg:
        r = ring(rg[0] * 2, rg[1], rg[2], rg[3]); place(c, r)
    place(c, img)
    sheet[(i // 5) * 192:(i // 5) * 192 + 192, (i % 5) * 192:(i % 5) * 192 + 192] = c
save(regrid(reduce(sheet, 12)), "Animations/E-02.png")

# S-01: already in limits; copy as is
for rel in ["Pictures/S-01.png"]:
    os.makedirs(os.path.dirname(f"{OUT}/{rel}"), exist_ok=True); shutil.copy(f"{SRC}/{rel}", f"{OUT}/{rel}")

# FT_meat_meat.png: put each frame back on the 2x grid (the step frames sit 1px off)
w = load(f"{WALK}/FT_meat_meat.png")
fixed = w.copy()
for fy in range(4):
    for fx in range(4):
        fr = w[fy * 80:fy * 80 + 80, fx * 80:fx * 80 + 80]
        best = None
        for dy in (0, 1, -1):
            for dx in (0, 1, -1):
                s = np.roll(np.roll(fr, dy, 0), dx, 1)
                bad = (s[0::2, 0::2] != s[1::2, 0::2]).any(-1).sum() + (s[0::2, 0::2] != s[0::2, 1::2]).any(-1).sum()
                if best is None or bad < best[0]:
                    best = (bad, s)
        fixed[fy * 80:fy * 80 + 80, fx * 80:fx * 80 + 80] = regrid(best[1])
save(fixed, "Characters/FT_meat_meat.png")

# E-02, redrawn: the rune as Alberica's mark, a six-armed snowflake under a three-point crown,
# 15 native px wide, drawn here pixel by pixel (the batch's 8x10 version doesn't survive enlarging).
RUNE = [
    "...#...#...#...",
    "...##..#..##...",
    "....#######....",
    ".......#.......",
    "..#....#....#..",
    "...#..#o#..#...",
    "....#.#o#.#....",
    ".##..#ooo#..##.",
    "..####oOo####..",
    ".##..#ooo#..##.",
    "....#.#o#.#....",
    "...#..#o#..#...",
    "..#....#....#..",
    ".......#.......",
    ".......#.......",
]
RIME = {'edge': (47, 95, 168), 'mid': (94, 158, 226), 'light': (138, 205, 251), 'pale': (198, 235, 248), 'white': (255, 255, 255)}
def rune_img(level):
    """level 0..3: how far the rune has drawn itself in, and how bright it is."""
    h, w = len(RUNE), len(RUNE[0]); c = (w - 1) / 2
    img = np.zeros((h, w, 4), np.uint8)
    for y, row in enumerate(RUNE):
        for x, ch in enumerate(row):
            if ch == '.':
                continue
            r = max(abs(x - c), abs(y - 7))
            if level == 0 and r > 2: continue
            if level == 1 and r > 5: continue
            col = {'#': ['edge', 'mid', 'light', 'mid'][level], 'o': ['mid', 'light', 'white', 'pale'][level], 'O': 'white'}[ch]
            img[y, x] = list(RIME[col]) + [255]
    return img
def ring2(r_out, r_in, colour):
    size = r_out * 2 + 2
    g = np.zeros((size, size, 4), np.uint8); yy, xx = np.mgrid[:size, :size]; cc = (size - 1) / 2
    d = np.sqrt((yy - cc) ** 2 + (xx - cc) ** 2)
    g[(d <= r_out) & (d >= r_in)] = list(colour) + [255]
    return g
sheet = np.zeros((384, 960, 4), np.uint8)
plan = [(0, None), (1, None), (2, (10, 9, RIME['pale'])), (3, (12, 11, RIME['light'])),
        (1, None), (3, None), (2, None), (3, None)]          # 0-3 flare, 4-7 the pulse that loops
for i, (lvl, rg) in enumerate(plan):
    nat = np.zeros((96, 96, 4), np.uint8)
    def put(img):
        h, w = img.shape[:2]; oy, ox = (96 - h) // 2, (96 - w) // 2
        reg = nat[oy:oy + h, ox:ox + w]; m = img[..., 3] > 0; reg[m] = img[m]
    if rg:
        put(ring2(*rg))
    put(rune_img(lvl))
    big = np.array(Image.fromarray(nat).resize((192, 192), Image.NEAREST))
    sheet[(i // 5) * 192:(i // 5) * 192 + 192, (i % 5) * 192:(i % 5) * 192 + 192] = big
save(sheet, "Animations/E-02.png")
