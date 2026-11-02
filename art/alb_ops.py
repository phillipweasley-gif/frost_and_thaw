"""Reusable operations for Alberica's hand-made fusions. Each one turns a part of the partner's anatomy into
the matching part of the real instrument (the rules agreed with the user):

  Lutling     the partner's rounded mass -> a lute bowl of alternating ribs, with a rose soundhole facing us;
              a sprout / tuft / tail / ear -> the fretted neck, ending in a pegbox bent sharply back;
              the haunting glows violet through the soundhole and the eyes.
  Hauntello   the torso -> a varnished cello body with purfling just inside its edge and f-holes;
              the mouth -> the soundhole, splintered where the teeth were; a tall ear / spike / tail ->
              the ebony neck and scroll with pegs; bridge, tailpiece and endpin; strings run out
              along the limbs and fray past the fingers.
  Chorumbra   the crest / ears / hair -> a small harp arc (lacquer neck with gold pins, streaks become
              strings); an outstretched limb -> the harp's neck, with a pillar and soundbox completing the
              frame and strings hung between; the partner's main colour turns spirit-violet.

All coordinates are sprite pixels on the partner's own 96x96 sprite."""
import math
import numpy as np
from PIL import Image
from scipy import ndimage as ndi
from alb_proto import Px, stamp, edge, GOLD, SPIRIT, HOLE, PROTO

INK = (11, 11, 11)
HONEY = [(110, 56, 24), (172, 100, 44), (224, 152, 76), (246, 198, 124), (252, 224, 166)]
YEW = [(96, 46, 20), (148, 82, 34), (198, 124, 58), (230, 172, 100), (240, 200, 140)]
CELLO = [(72, 20, 18), (128, 44, 34), (178, 72, 50), (214, 108, 74), (236, 150, 108)]
LACQ = [(58, 16, 30), (98, 32, 48), (140, 54, 66), (180, 86, 92), (214, 130, 130)]
VIOLET = [(52, 24, 92), (100, 62, 170), (150, 112, 226), (194, 162, 250), (230, 210, 255)]
EBONY = (30, 20, 20)
PALE = (236, 196, 140)
SPLINTER = (244, 206, 168)
CRACK = (52, 12, 12)


def lum(c):
    return 0.3 * c[0] + 0.59 * c[1] + 0.11 * c[2]


def load(name):
    return Px(Image.open(f"{PROTO}/{name}.png"))


def porcelain(x, y, c):
    """The Cinderwright line's blue-and-white porcelain (paddles, plates)."""
    r, g, b = c
    return b > r + 40 or (min(c) > 200 and max(c) - min(c) < 28) or (b > r + 10 and lum(c) < 70 and b > 60)


def region(P, test):
    """All opaque pixels for which test(x, y, rgb) holds."""
    W, H = P.img.size
    return {(x, y) for y in range(H) for x in range(W) if P.get(x, y)[3] and test(x, y, P.get(x, y)[:3])}


def box(x0, y0, x1, y1):
    return lambda x, y, c: x0 <= x <= x1 and y0 <= y <= y1


def poly(pts):
    from matplotlib.path import Path
    path = Path(pts)
    return lambda x, y, c: path.contains_point((x + 0.5, y + 0.5))


def not_dark(t=40):
    return lambda x, y, c: lum(c) > t


def both(*tests):
    return lambda x, y, c: all(t(x, y, c) for t in tests)


def colours_in(cols):
    cols = {tuple(c) for c in cols}
    return lambda x, y, c: tuple(c) in cols


def recolour_ramp(P, pts, ramp, dark_keep=40, outline=None):
    """Map the pixels to a ramp by their own lightness: the partner's shading carries over, light for light.
    Near-black outline pixels stay (or take `outline`)."""
    pts = list(pts)
    cols = sorted({P.get(x, y)[:3] for (x, y) in pts if lum(P.get(x, y)[:3]) > dark_keep}, key=lum)
    if not cols:
        return
    lo, hi = lum(cols[0]), lum(cols[-1])
    m = {}
    for c in cols:
        t = 0 if hi == lo else (lum(c) - lo) / (hi - lo)
        m[c] = ramp[min(len(ramp) - 1, int(t * (len(ramp) - 0.01)))]
    for (x, y) in pts:
        c = P.get(x, y)[:3]
        if c in m:
            P.put(x, y, m[c])
        elif outline is not None:
            P.put(x, y, outline)


# ------------------------------------------------------------------------------------- Lutling
def lute_bowl(P, pts, block, step=11, ramp=HONEY, alt=YEW, lines=False, outline=(70, 34, 14)):
    """A lute bowl over these pixels: honey wood by the partner's own shading, every other rib (running to
    the bottom block at `block`) in the darker wood (with a fine line between ribs on big bowls)."""
    pts = set(pts)
    for (x, y) in pts:
        if lum(P.get(x, y)[:3]) < 60:
            P.put(x, y, outline)
    recolour_ramp(P, [p for p in pts if P.get(*p)[:3] != outline], ramp[:4])
    bx, by = block
    band = lambda x, y: int((math.degrees(math.atan2(y + 0.5 - by, x + 0.5 - bx)) + 360) // step) % 2
    swap = dict(zip(ramp[:4], alt[:4]))
    for (x, y) in pts:
        c = P.get(x, y)[:3]
        if c in swap and band(x, y):
            P.put(x, y, swap[c])
    woods = set(ramp[:4]) | set(alt[:4])
    for (x, y) in (pts if lines else ()):
        if (x + 1, y) in pts and band(x, y) != band(x + 1, y) and P.get(x, y)[:3] in woods and P.get(x + 1, y)[:3] in woods:
            P.put(x, y, (140, 76, 32))


ROSE = {5: [".ggg.", "gHgHg", "gVwVg", ".gGg."],
        7: ["..ggg..", ".gHgHg.", "gHgVgHg", "gHVwVHg", ".gVgVg.", "..GGG.."]}


def rose(P, cx, cy, size=7):
    """A lute's rose: a gold-lipped soundhole with fretwork across it and the violet glow behind."""
    t = ROSE[size]
    stamp(P, int(cx - len(t[0]) // 2), int(cy - len(t) // 2), t)


def lute_neck(P, start, end, pegbox=+1, frets=True):
    """A fretted neck from `start` to `end` (2px fingerboard, outlined, a gold string up it) and the pegbox
    bent back at the end: pegbox=+1 bends clockwise from the neck's direction, -1 the other way."""
    (x0, y0), (x1, y1) = start, end
    n = max(abs(x1 - x0), abs(y1 - y0))
    dx, dy = (x1 - x0) / n, (y1 - y0) / n
    nx, ny = -dy, dx                                           # the neck's side
    pts = [(x0 + dx * k, y0 + dy * k) for k in range(n + 1)]
    for (x, y) in pts:
        P.put(round(x - nx), round(y - ny), INK)
        P.put(round(x + nx * 2), round(y + ny * 2), INK)
    for i, (x, y) in enumerate(pts):
        P.put(round(x), round(y), (96, 52, 26))
        P.put(round(x + nx), round(y + ny), (128, 72, 34))
        if frets and i % 2 == 1 and i < n - 1:
            P.put(round(x), round(y), PALE)
    P.line([(x0 + nx * 0.5, y0 + ny * 0.5), (x1 + nx * 0.5, y1 + ny * 0.5)], GOLD[2])
    # the pegbox: bent back almost square to the neck
    bx, by = pegbox * nx, pegbox * ny
    ex, ey = x1 + dx, y1 + dy
    for k in range(4):
        X, Y = ex + bx * k + dx * 0.5, ey + by * k + dy * 0.5
        P.put(round(X), round(Y), (70, 36, 18) if k % 2 else (112, 62, 30))
        P.put(round(X + dx), round(Y + dy), INK)
        P.put(round(X - dx), round(Y - dy), GOLD[2] if k in (1, 3) else INK)
    P.put(round(ex + bx * 4 + dx * 0.5), round(ey + by * 4 + dy * 0.5), INK)


def lute_strings(P, start, end, bridge=True):
    P.line([start, end], GOLD[3], cond=lambda x, y: P.get(x, y)[3] and lum(P.get(x, y)[:3]) > 30)
    if bridge:
        x, y = end
        stamp(P, x - 2, y, ["#lhl#", ".###."], pal={"#": INK, "l": PALE, "h": (252, 224, 166)})


def violet_eyes(P, pts):
    """The haunting in the eyes: the iris colours turn violet, light for light; white glints stay."""
    pts = [p for p in pts if lum(P.get(*p)[:3]) < 235]
    recolour_ramp(P, pts, VIOLET[:4], dark_keep=20)


def wisp(P, x, y):
    stamp(P, x, y, ["..V", ".w.", "V.."])


# ------------------------------------------------------------------------------------ Hauntello
def cello_body(P, pts, purfle=3, highlight=None, dark_keep=40):
    """Varnished cello wood over these pixels, with the purfling line `purfle` pixels inside the edge."""
    pts = set(pts)
    recolour_ramp(P, pts, CELLO[1:5], outline=None, dark_keep=dark_keep)
    W, H = P.img.size
    m = np.zeros((H, W), bool)
    for (x, y) in pts:
        m[y, x] = True
    full = np.zeros((H, W), bool)
    for y in range(H):
        for x in range(W):
            full[y, x] = P.get(x, y)[3] > 0
    dist = ndi.distance_transform_cdt(full, metric="taxicab")
    if purfle:
        for (x, y) in pts:
            if dist[y, x] == purfle and P.get(x, y)[:3] in CELLO:
                P.put(x, y, (88, 26, 20))
    if highlight:
        cx, cy, rx, ry = highlight
        for (x, y) in P.ellipse(cx, cy, rx, ry, rot=-15):
            if (x, y) in pts and P.get(x, y)[:3] == CELLO[3]:
                P.put(x, y, CELLO[4])


def f_hole(P, x, y, length=5, flip=False):
    rows = ["." + "k", "k."] + ["k."] * (length - 3) + ["kk"]
    if flip:
        rows = [r[::-1] for r in rows][::-1]
    stamp(P, x, y, rows, pal={"k": CRACK})


def mouth_soundhole(P, pts, glow_at=None):
    """The mouth becomes the soundhole: dark inside, a splinter of pale wood where each tooth was, the
    violet glow in the depths."""
    pts = set(pts)
    top = {}
    for (x, y) in pts:
        top[x] = min(top.get(x, 999), y)
    for (x, y) in pts:
        P.put(x, y, HOLE)
    for x, y in top.items():
        if x % 3 != 1:
            P.put(x, y, SPLINTER)
    if glow_at:
        gx, gy = glow_at
        for (dx, dy, c) in ((-1, 0, SPIRIT[2]), (0, 0, SPIRIT[3]), (1, 0, SPIRIT[2]), (-2, 0, SPIRIT[1]),
                            (2, 0, SPIRIT[1]), (0, 1, SPIRIT[1])):
            if (gx + dx, gy + dy) in pts:
                P.put(gx + dx, gy + dy, c)


def bridge_tailpiece(P, x, y, strings=4, rise=2):
    """The front of a cello: strings rising over a bridge on two feet, an ebony tailpiece below."""
    w = strings * 2 + 1
    rows = ["".join("s" if i % 2 == 1 else "." for i in range(w))] * rise
    rows += ["#" + "b" * (w - 2) + "#", ".#b#" + "." * (w - 8) + "#b#." if w >= 8 else ".#b#b#."]
    k = w - 4
    rows += ["." * 2 + "e" * k + "." * 2, "." * 2 + "e" + "E" * (k - 2) + "e" + "." * 2, "." * 3 + "e" * (k - 2) + "." * 3]
    stamp(P, x - w // 2, y - rise, rows, pal={"s": GOLD[3], "b": PALE, "#": CELLO[0], "e": (34, 22, 22), "E": (70, 52, 50)})


def endpin(P, x, y, length=4):
    stamp(P, x, y, ["e"] + ["m"] * (length - 2) + ["M", "e"], pal={"e": INK, "m": (150, 150, 162), "M": (214, 214, 224)})


SCROLL_S = [".eee.", "eLMMe", "eMeLe", ".eMe.", "geMeg"]


def cello_neck(P, start, end, scroll=True, small=False):
    """An ebony fingerboard from `start` to `end` with a string along it, and the scroll and pegs at the end."""
    (x0, y0), (x1, y1) = start, end
    n = max(abs(x1 - x0), abs(y1 - y0))
    for k in range(n + 1):
        x, y = round(x0 + (x1 - x0) * k / n), round(y0 + (y1 - y0) * k / n)
        P.put(x - 1, y, INK); P.put(x, y, EBONY); P.put(x + 1, y, GOLD[2] if k % 3 else GOLD[3])
    if scroll and small:
        stamp(P, x1 - 2, y1 - 4, SCROLL_S, pal={"e": INK, "L": CELLO[4], "M": CELLO[2], "g": GOLD[2]})
    elif scroll:
        stamp(P, x1 - 3, y1 - 7, [
            ".eeee..",
            "eLLMMe.",
            "eLeeeMe",
            "eMeLeMe",
            ".eMMeMe",
            "..eeMe.",
            "gge#Mgg",
        ], pal={"e": INK, "L": CELLO[4], "M": CELLO[2], "#": EBONY, "g": GOLD[2]})


def fray(P, path, tips=()):
    """A string running out along a limb (drawn only over the body) and fraying loose past its end."""
    P.line(path, GOLD[2], cond=lambda x, y: P.opaque(x, y))
    for t in tips:
        P.line(t, GOLD[2])


# ------------------------------------------------------------------------------------ Chorumbra
def harp_arc(P, pts, out_test=None, strings=None, pin_every=4):
    """A crest / ear / tuft becomes a small harp arc: two pixels of lacquer just inside its outer edge with
    gold pins along it; `strings` (a set of pixels, e.g. the part's own streaks) become gold strings."""
    pts = set(pts)
    out = lambda x, y: not P.get(x, y)[3] or (out_test is not None and out_test(x, y))
    band = []
    for (x, y) in pts:
        ring = [(x + dx, y + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))]
        ring2 = [(x + dx * 2, y + dy * 2) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))]
        if any(out(*q) for q in ring):
            continue                                            # the outline itself stays
        if any(out(*q) for q in ring2):
            band.append((x, y))
    band.sort(key=lambda p: (p[1], p[0]))
    for i, (x, y) in enumerate(band):
        P.put(x, y, GOLD[2] if i % pin_every == 0 else LACQ[2])
    for (x, y) in (strings or ()):
        if (x, y) not in band:
            P.put(x, y, GOLD[2])


def harp_frame(P, neck_pts, rail, pillar_x, string_xs):
    """An outstretched limb becomes the harp's neck (lacquer, gold pins along its underside); `rail` maps
    x -> y for the soundbox edge below; the pillar stands at pillar_x; strings hang at string_xs."""
    recolour_ramp(P, neck_pts, LACQ[:4])
    under = {}
    for (x, y) in neck_pts:
        under[x] = max(under.get(x, 0), y)
    for x, y in rail.items():
        P.put(x, y, LACQ[1]); P.put(x, y + 1, LACQ[2])
        if x % 4 == 0:
            P.put(x, y + 1, GOLD[2])
    for x in string_xs:
        if x in under and x in rail:
            P.line([(x, under[x] + 2), (x, rail[x] - 1)], GOLD[2] if x % 2 else GOLD[3],
                   cond=lambda xx, yy: not P.get(xx, yy)[3] or P.get(xx, yy)[:3] in GOLD)
            P.put(x, under[x] + 1, GOLD[1])
    top, bot = under.get(pillar_x, min(under.values())) + 1, rail.get(pillar_x, max(rail.values())) - 1
    for y in range(top, bot + 1):
        P.put(pillar_x - 1, y, INK); P.put(pillar_x, y, LACQ[2]); P.put(pillar_x + 1, y, LACQ[1]); P.put(pillar_x + 2, y, INK)
    for y in (top, bot, (top + bot) // 2):
        P.put(pillar_x, y, GOLD[3]); P.put(pillar_x + 1, y, GOLD[2])


def spirit_violet(P, pts):
    recolour_ramp(P, pts, VIOLET[1:5])


def beads(P, paths, avoid=None):
    for path in paths:
        P.line(path, GOLD[2], cond=(lambda x, y: (x, y) not in avoid) if avoid else None)
        x, y = path[-1]
        stamp(P, x, y, ["gG", "gg"], pal={"g": GOLD[1], "G": GOLD[3]})


def show(imgs, labels, out, z=4):
    from PIL import ImageDraw
    W = 96 * z
    cols = min(4, len(imgs))
    rows = (len(imgs) + cols - 1) // cols
    c = Image.new("RGB", (cols * (W + 10), rows * (W + 26)), "white")
    d = ImageDraw.Draw(c)
    for i, (im, lab) in enumerate(zip(imgs, labels)):
        x, y = (i % cols) * (W + 10), (i // cols) * (W + 26)
        d.text((x + 4, y + 4), lab, fill=(30, 30, 30))
        bg = Image.new("RGBA", im.size, (238, 238, 242, 255)); bg.alpha_composite(im)
        c.paste(bg.resize((W, W), Image.NEAREST), (x, y + 20))
    c.save(out)


def strings_across_gap(P, xs, y_from, y_to, pin=True):
    """Harp strings hung across an open gap in the partner's shape (between a curving tail and the back,
    say): for each x, the first gap below an opaque run between y_from and y_to is strung in gold."""
    for x in xs:
        y = y_from
        while y < y_to and not P.opaque(x, y):
            y += 1
        while y < y_to and P.opaque(x, y):
            y += 1
        top = y
        while y < y_to and not P.opaque(x, y):
            y += 1
        if y >= y_to or y - top < 2:
            continue
        P.line([(x, top), (x, y - 1)], GOLD[2] if x % 2 else GOLD[3])
        if pin:
            P.put(x, top - 1, GOLD[1])


def lacquer(P, pts, rose_at=None):
    recolour_ramp(P, pts, LACQ[1:5])
    if rose_at:
        stamp(P, rose_at[0] - 1, rose_at[1] - 1, [".g.", "gHg", ".g."], pal={"g": GOLD[2], "H": (40, 12, 30)})


def inner_strings(P, pts, step=3, avoid=()):
    """Gold strings running down through a part (the harp's strings inside a crest or a paddle)."""
    pts = set(pts)
    xs = sorted({x for (x, y) in pts})
    for x in xs[1:-1:step]:
        col = sorted(y for (xx, y) in pts if xx == x)
        inside = [y for y in col if (x, y - 1) in pts and (x, y + 1) in pts and (x, y) not in avoid]
        for y in inside[1:-1]:
            P.put(x, y, GOLD[2] if x % 2 else GOLD[3])


# ------------------------------------------------------------------------------ colour families
def is_pink(x, y, c):
    r, g, b = c
    return r > 170 and r > g + 40 and r > b + 30


def is_leaf(x, y, c):
    r, g, b = c
    return g > r + 15 and g > b + 25


def is_teal(x, y, c):
    r, g, b = c
    return g > r + 25 and b > r + 15 and b >= g - 45


def is_red(x, y, c):
    r, g, b = c
    return r > 100 and r > g + 60 and r > b + 20


def is_mint(x, y, c):
    r, g, b = c
    return g > r + 25 and lum(c) > 110


def is_violet(x, y, c):
    r, g, b = c
    return b > g + 20 and b > 60 and r < b + 10


def is_brown(x, y, c):
    r, g, b = c
    return r > g + 15 and g > b + 5 and r < 200 and lum(c) > 50


def is_greyish(x, y, c):
    r, g, b = c
    return max(c) - min(c) < 40 and 40 < lum(c) < 200


def in_box(*b):
    return box(*b)
