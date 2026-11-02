"""Fusion sprites for Frost & Thaw's new Pokemon, built on Infinite Fusion's hand-drawn sprites.

Infinite Fusion's artists have drawn thousands of fusions. Three kinds are all we need:
  * Voltorb's head on every body  -> that body redrawn with a plain round face and two colours,
                                      ready to take a new face and new colours;
  * every head on Voltorb's body  -> that Pokemon's head drawn as a round head;
  * Zoroark's and Parasect's fusions -> Rimirage and Gloamcap are those two, transformed.
Where no hand-drawn fusion exists, Infinite Fusion's automatic one is used in its place.

  Lutling / Hauntello / Chorumbra as HEAD: the body takes the instrument's wood colours, its
      face (soundhole, burst hole or spirit face) carved where the eyes were, and the curled
      pegbox on top of the head.
  ...as BODY: the other Pokemon's head becomes the spirit possessing the instrument: it peeks
      from Lutling's rosette, bursts from Hauntello's hole, or is Chorumbra's floating head.
  Rimirage / Gloamcap: Zoroark / Parasect fusions in frost or dusk colours, with their marks.

python3 fusegen2.py <customs dir> <autogen dir> <parts dir> <out dir> [--only 1,2,3] [--ours]
"""
import json, math, os, sys
from multiprocessing import Pool
from PIL import Image, ImageDraw
from fusegen_core import (Sheets, S, colour_groups, lum, hsv, components, opaque, bbox_of, fill_holes,
                          body_info, AUTOGEN_MAX)
import final_line as F
from clean import (Layer, compose, paint, to_mask, smooth_poly_mask, ellipse_pts, outline_of, ribbon,
                   thin_line_mask, selout)
from silhouettes import curl
import ft_fusion_parts as P

L, H, C, R, G = 577, 578, 579, 580, 581
W, ST, FG = 582, 583, 584                 # the Cinderwright line (stand-in art)
CINDER = (W, ST, FG)
SP, MY = 585, 586                         # Wyn's line: Sableye -> Sporeye -> Myconarch (stand-in art)
MYCO = (SP, MY)
OURS = (L, H, C, R, G) + CINDER + MYCO
LINE = (L, H, C)
SOURCE = {R: 338, G: 47,             # Rimirage is a Zoroark, Gloamcap a Parasect
          W: 161, ST: 162, FG: 157,  # stand-ins: the mustelid-shaped Sentret, Furret and Typhlosion
          SP: 421, MY: 355}          # Sporeye is a Sableye, Myconarch a Breloom, both turned to glowing spore-violet
VOLTORB = 100

CUSTOMS = None
SHEETS = None
PARTS = None
OUR = {}


# --- pictures to start from ---------------------------------------------------------------
def src(n):
    return SOURCE.get(n, n)


def custom(h, b):
    p = f"{CUSTOMS}/{h}.{b}.png"
    return Image.open(p).convert("RGBA") if os.path.exists(p) else None


def drawn(h, b):
    """The hand-drawn fusion if there is one, else Infinite Fusion's automatic one."""
    return custom(h, b) or SHEETS.autogen(h, b)


# --- colours ------------------------------------------------------------------------------
def families(img, protect=None):
    return [g for g in colour_groups(img, protect=protect)]


def map_families(img, src_groups, targets, protect=None, outline=None):
    """Each source colour family takes a target ramp, keeping its light/dark position."""
    m = {}
    for i, g in enumerate(src_groups):
        tgt = targets[min(i, len(targets) - 1)]
        cols = g["cols"]; lo, hi = lum(cols[0]), lum(cols[-1])
        for c in cols:
            t = 0.5 if hi - lo < 1 else (lum(c) - lo) / (hi - lo)
            m[c] = tuple(tgt[max(0, min(len(tgt) - 1, int(round(t * (len(tgt) - 1)))))])
    dark = outline or tuple(int(v * 0.42) for v in targets[0][0])
    out = img.copy(); px = out.load()
    for y in range(S):
        for x in range(S):
            p = px[x, y]
            if p[3] <= 127 or (protect and protect(p[:3])):
                continue
            if p[:3] in m:
                px[x, y] = m[p[:3]] + (p[3],)
            elif lum(p[:3]) < 40:
                px[x, y] = dark + (p[3],)
    return out


def ramps_of(img):
    gs = [g for g in colour_groups(img) if len(g["cols"]) >= 2] or colour_groups(img)
    chromatic = [g for g in gs if not g["neutral"]]
    gs = chromatic + [g for g in gs if g["neutral"]]
    return [g["cols"] for g in gs[:3]] or [[(128, 128, 128)]]


FROST = {"hot": [(40, 92, 150), (88, 168, 220), (150, 220, 250), (225, 248, 255)],
         "grey": [(24, 28, 52), (33, 38, 68), (48, 54, 92), (84, 96, 140), (130, 146, 190)],
         "teal": [(110, 60, 190), (150, 90, 230), (205, 150, 255)]}
DUSK = {"cap": [(44, 26, 82), (78, 48, 130), (112, 72, 172), (152, 112, 212)],
        "body": [(70, 66, 92), (118, 114, 140), (168, 164, 190), (206, 200, 222)],
        "spot": [(70, 190, 160), (120, 255, 210), (196, 255, 236)]}


def classify_recolour(img, rules):
    """Recolour by hue class: rules = [(test(h, s, v), ramp)], light/dark kept within each class."""
    px = img.load()
    cls = {}
    for y in range(S):
        for x in range(S):
            p = px[x, y]
            if p[3] > 127 and p[:3] not in cls:
                h, s, v = hsv(p[:3])
                for i, (test, _) in enumerate(rules):
                    if lum(p[:3]) >= 30 and test(h, s, v):
                        cls[p[:3]] = i
                        break
    by = {}
    for c, i in cls.items():
        by.setdefault(i, []).append(c)
    m = {}
    for i, cols in by.items():
        ramp = rules[i][1]
        lo, hi = min(map(lum, cols)), max(map(lum, cols))
        for c in cols:
            t = 0.5 if hi - lo < 1 else (lum(c) - lo) / (hi - lo)
            m[c] = ramp[int(round(t * (len(ramp) - 1)))]
    out = img.copy(); po = out.load()
    for y in range(S):
        for x in range(S):
            p = po[x, y]
            if p[3] > 127 and p[:3] in m:
                po[x, y] = m[p[:3]] + (p[3],)
    return out


def frost_colours(img):
    return classify_recolour(img, [
        (lambda h, s, v: s > 0.28 and (h < 0.07 or h > 0.88), FROST["hot"]),
        (lambda h, s, v: 0.40 < h < 0.58 and s > 0.25, FROST["teal"]),
        (lambda h, s, v: s < 0.22, FROST["grey"])])


def dusk_colours(img):
    return classify_recolour(img, [
        (lambda h, s, v: s > 0.35 and (h < 0.035 or h > 0.93), DUSK["cap"]),
        (lambda h, s, v: s > 0.3 and 0.035 <= h < 0.105, DUSK["body"]),
        (lambda h, s, v: s > 0.3 and 0.105 <= h < 0.19, DUSK["spot"])])


# --- the marks of Rimirage and Gloamcap -----------------------------------------------------
def sparkle(img, x, y, c, big=False):
    pts = [(x, y), (x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]
    if big:
        pts += [(x - 2, y), (x + 2, y), (x, y - 2), (x, y + 2)]
    px = img.load()
    for p in pts:
        if 0 <= p[0] < S and 0 <= p[1] < S:
            px[p] = c + (255,)


def frost_marks(img):
    """Frost crystals on the topmost edge, an illusory afterimage, drifting sparkles."""
    px = img.load()
    tops = []
    for x in range(S):
        for y in range(S):
            if px[x, y][3] > 127:
                tops.append((x, y)); break
    for i, (x, y) in enumerate(tops):
        if i % 7 == 3:
            sparkle(img, x, max(1, y - 2), (225, 248, 255))
    ghost = img.transpose(Image.FLIP_LEFT_RIGHT)
    ghost.putalpha(ghost.getchannel("A").point(lambda a: 34 if a > 127 else 0))
    out = Image.new("RGBA", img.size, (0, 0, 0, 0))
    out.alpha_composite(ghost, (-4, -2)); out.alpha_composite(img)
    bb = img.getbbox()
    for (x, y) in ((bb[0] - 4, bb[1] + 6), (bb[2] + 3, bb[1] + 14), (bb[0] - 2, bb[3] - 12)):
        if 2 <= x < S - 2 and 2 <= y < S - 2:
            sparkle(out, x, y, (190, 230, 255), big=True)
    return out


def dusk_marks(img, glow_eyes=True):
    """Glowing spore-lights around it; white eyes turn to glow."""
    px = img.load()
    if glow_eyes:
        for c in components({(x, y) for y in range(S) for x in range(S)
                             if px[x, y][3] > 127 and lum(px[x, y][:3]) > 205 and hsv(px[x, y][:3])[1] < 0.15}):
            if len(c) <= 30:
                for p in c:
                    px[p] = (120, 255, 210, 255)
    bb = img.getbbox()
    d = ImageDraw.Draw(img)
    for (x, y, r) in ((bb[0] - 5, bb[1] + 8, 2), (bb[2] + 4, bb[1] + 4, 2), (bb[2] + 2, bb[3] - 20, 1), (bb[0] - 3, bb[3] - 26, 1)):
        if r + 1 <= x < S - r - 1 and r + 3 <= y < S - r - 1:
            d.ellipse([x - r, y - r, x + r, y + r], fill=(120, 255, 210, 220))
            d.point([(x, y - r - 1)], fill=(196, 255, 236, 170))
    return img


def gloam_cap(img):
    """Gloamcap's second, wider cap growing behind whatever wears it, with glowing spores."""
    bb = img.getbbox()
    rm = ramps_of(img)[0]
    k = [0.45, 0.65, 0.85, 1.0]
    tones = [tuple(max(0, min(255, int(v * f))) for v in rm[min(len(rm) - 1, len(rm) // 2)]) for f in k]
    w, hgt = bb[2] - bb[0], bb[3] - bb[1]
    cx = (bb[0] + bb[2]) / 2
    rx, ry = min(47, w * 0.62 + 8), max(14, min(30, hgt * 0.42))
    cy = bb[1] + ry * 0.75
    dome = ellipse_pts(cx, cy, rx, ry, 64, 180, 360)
    back = compose([Layer([dome], tones, depth=5, outline=tuple(int(v * 0.35) for v in tones[0]), cuts=(-0.2, 0.3, 0.75))])
    d = ImageDraw.Draw(back)
    for i, (fx, fy) in enumerate(((-0.7, -0.3), (-0.35, -0.75), (0.1, -0.85), (0.5, -0.6), (0.78, -0.25))):
        x, y = cx + fx * rx, cy + fy * ry
        r = 2 if i % 2 else 1.5
        d.ellipse([x - r, y - r * 0.7, x + r, y + r * 0.7], fill=(120, 255, 210, 255))
    back.alpha_composite(img)
    return back


EMBERS = [(150, 70, 14), (214, 110, 28), (255, 164, 48), (255, 212, 104), (255, 246, 206)]
RUSSET5 = [(70, 26, 18), (110, 46, 28), (154, 74, 40), (196, 108, 60), (230, 150, 98)]
CREAM5 = [(176, 140, 100), (206, 170, 126), (232, 206, 164), (248, 230, 196), (255, 246, 222)]


MYC = {"body": [(34, 20, 58), (60, 36, 96), (92, 60, 138), (128, 94, 176)],
       "cap": [(62, 26, 84), (104, 50, 128), (150, 86, 172), (194, 140, 210)],
       "glow": [(36, 140, 130), (74, 204, 184), (146, 250, 224), (222, 255, 246)],
       "pale": [(140, 124, 164), (184, 168, 204), (220, 210, 234), (244, 240, 252)]}


def myco_colours(img):
    """Sableye / Breloom turned to the myconid court: spore-violet bodies, mauve caps, gems and spots that
    glow sea-green, pale parts gone lilac."""
    return classify_recolour(img, [
        (lambda h, s, v: s > 0.3 and (h < 0.06 or h > 0.92 or 0.45 < h < 0.6), MYC["glow"]),     # gems: red and cyan
        (lambda h, s, v: s > 0.2 and 0.6 <= h <= 0.92, MYC["body"]),                                # Sableye's purple
        (lambda h, s, v: s > 0.25 and 0.2 <= h <= 0.45, MYC["cap"]),                                # Breloom's green
        (lambda h, s, v: 0.06 <= h < 0.2 and v > 0.5, MYC["pale"])])                                # cream, tan


def cinder_colours(img):
    """Sentret / Furret / Typhlosion colours turned to the studio palette: russet fur, cream, embers."""
    return classify_recolour(img, [
        (lambda h, s, v: s > 0.7 and v > 0.85 and (h < 0.15 or h > 0.97), EMBERS),
        (lambda h, s, v: 0.5 < h < 0.75 and s > 0.2, RUSSET5),
        (lambda h, s, v: (h < 0.11 or h > 0.95) and s > 0.2 and v < 0.8, RUSSET5),
        (lambda h, s, v: 0.06 <= h < 0.2 and v >= 0.7, CREAM5)])


def ember_sparks(img):
    bb = img.getbbox()
    px = img.load()
    for (x, y, c) in ((bb[2] + 2, bb[1] + 10, EMBERS[3]), (bb[0] - 3, bb[1] + 18, EMBERS[2]), (bb[2] + 1, bb[3] - 14, EMBERS[4])):
        if 0 <= x < S and 0 <= y < S and px[x, y][3] == 0:
            px[x, y] = c + (255,)
    return img


def head_marks(n, img):
    if n in MYCO:
        return dusk_marks(myco_colours(img))
    if n in CINDER:
        return ember_sparks(cinder_colours(img))
    if n == R:
        return frost_marks(frost_colours(img))
    if n == G:
        return dusk_marks(dusk_colours(img))
    return img


PADDLES = {}


def porcelain_paddle(n, img):
    """A Cinderwright body keeps its signature: the glazed porcelain tail paddle rising behind it."""
    if n not in PADDLES:
        k = {W: "w", ST: "st", FG: "fg"}[n]
        PADDLES[n] = Image.open(f"/home/claude/frost-thaw/build/concept/sprites/paddle_{k}.png").convert("RGBA")
    pd = PADDLES[n]
    bb = img.getbbox()
    if not bb:
        return img
    px = img.load()
    y0, y1 = bb[1] + (bb[3] - bb[1]) * 2 // 5, bb[3] - (bb[3] - bb[1]) // 5
    best = None
    for y in range(y0, max(y0 + 1, y1)):
        xs = [x for x in range(bb[0], bb[2]) if px[x, y][3]]
        if xs and (best is None or max(xs) > best[0]):
            best = (max(xs), y)
    if best is None:
        return img
    x, y = best[0] - 3, best[1] - pd.height + 4
    x = min(x, S - pd.width); y = max(0, y)
    out = Image.new("RGBA", img.size, (0, 0, 0, 0))
    out.alpha_composite(pd, (x, y))
    out.alpha_composite(img)
    return out


SRC_PAL = {}


def cinder_body_colours(n, img):
    """The stand-in body (Sentret / Furret / Typhlosion) takes the Cinderwright palette; only colours that
    belong to that stand-in's own sprite change, so the partner's head keeps its colours."""
    if n not in SRC_PAL:
        base = drawn(src(n), src(n))
        SRC_PAL[n] = {p[:3] for p in base.getdata() if p[3]} if base is not None else set()
    pal = SRC_PAL[n]
    rec = cinder_colours(img.copy())
    a, b = img.load(), rec.load()
    out = img.copy(); o = out.load()
    for y in range(img.height):
        for x in range(img.width):
            if a[x, y][3] and a[x, y][:3] in pal:
                o[x, y] = b[x, y]
    return out


def body_marks(n, img):
    if n in MYCO:
        return dusk_marks(myco_colours(img), glow_eyes=False)
    if n in CINDER:
        return ember_sparks(porcelain_paddle(n, cinder_body_colours(n, img)))
    if n == R:
        return frost_marks(img)
    if n == G:
        return dusk_marks(img, glow_eyes=False)
    return img


# --- a head as a round "spirit" head -----------------------------------------------------------
def spirit_head(n, size):
    """Head n drawn round (its fusion onto Voltorb), at about `size` pixels."""
    if n in LINE:
        if n in NEW:
            if n == C:                                   # her face alone, not the hat
                d = NEW[n]; fc = d["face_c"]
                f = d["face"].crop((int(fc[0] - d["rx"] - 1), int(fc[1] - d["ry"] - 2), int(fc[0] + d["rx"] + 2), int(fc[1] + d["ry"] * 0.9)))
                f = f.crop(f.getbbox())
                return shrink(f, size / max(f.size))
            return face_piece(n, size)[0]
        face = {L: P.lute_face, H: P.cello_face, C: P.harp_face}[n]
        return face(size)
    img = drawn(src(n), VOLTORB)
    if img is None:
        return None
    if n in (R, G):
        img = (frost_colours if n == R else dusk_colours)(img)
    elif n in CINDER:
        img = cinder_colours(img)
    img = img.crop(img.getbbox())
    return shrink(img, size / max(img.size))


def shrink(img, k):
    """Downscale pixel art cleanly: average, then snap back to the sprite's own colours."""
    if k >= 0.97:
        return img
    w, h = max(1, round(img.width * k)), max(1, round(img.height * k))
    pal = sorted({p[:3] for p in img.getdata() if p[3] > 127})
    small = img.resize((w, h), Image.BOX)
    out = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    sp, op = small.load(), out.load()
    cache = {}
    for y in range(h):
        for x in range(w):
            p = sp[x, y]
            if p[3] < 110:
                continue
            c = p[:3]
            if c not in cache:
                cache[c] = min(pal, key=lambda q: (q[0] - c[0]) ** 2 + (q[1] - c[1]) ** 2 + (q[2] - c[2]) ** 2)
            op[x, y] = cache[c] + (255,)
    # restore a dark outline around the shrunken shape
    darkest = min(pal, key=lum)
    m = {(x, y) for y in range(h) for x in range(w) if op[x, y][3]}
    for (x, y) in m:
        if any((x + dx, y + dy) not in m for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
            op[x, y] = darkest + (255,)
    return out


def glow_ring(img, mask, colour, strength=90):
    F.halo(img, mask, colour, strength)


# --- Lutling / Hauntello / Chorumbra as the HEAD -------------------------------------------------
LINE_RAMPS = {L: [F.HONEY, F.SPRUCE, F.HONEY], H: [F.WINE, F.SPIRIT, F.WINE], C: [F.SPIRIT, F.LACQ, F.SPIRIT]}


def find_eyes(img):
    """The two eyes of a Voltorb-headed fusion: two small light shapes side by side."""
    px = img.load()
    light = {(x, y) for y in range(S) for x in range(S)
             if px[x, y][3] > 127 and lum(px[x, y][:3]) > 185 and hsv(px[x, y][:3])[1] < 0.28}
    def outlined(c):
        ring = grow(c, 1) - c
        dark = sum(1 for q in ring if px[q][3] > 127 and lum(px[q][:3]) < 75)
        return dark >= 0.35 * len(ring)
    comps = [c for c in components(light) if 3 <= len(c) <= 80 and outlined(c)]
    bb = img.getbbox()
    top, hgt = bb[1], max(1, bb[3] - bb[1])
    best = None
    for i in range(len(comps)):
        for j in range(i + 1, len(comps)):
            a, b = comps[i], comps[j]
            ca = (sum(p[0] for p in a) / len(a), sum(p[1] for p in a) / len(a))
            cb = (sum(p[0] for p in b) / len(b), sum(p[1] for p in b) / len(b))
            dx, dy = abs(ca[0] - cb[0]), abs(ca[1] - cb[1])
            ym = (ca[1] + cb[1]) / 2
            if 4 <= dx <= 30 and dy <= 5 and ym < top + hgt * 0.62:
                score = -abs(len(a) - len(b)) - dy * 3 - (ym - top) / hgt * 30
                if best is None or score > best[0]:
                    best = (score, sorted([ca, cb]), a | b)
    return best


def grow(m, r=1):
    return {(x + dx, y + dy) for (x, y) in m for dx in range(-r, r + 1) for dy in range(-r, r + 1)
            if 0 <= x + dx < S and 0 <= y + dy < S}


def fill_over(img, mask):
    img = img.copy(); px = img.load(); todo = set(mask)
    for _ in range(14):
        if not todo:
            break
        done = {}
        for (x, y) in todo:
            votes = {}
            for dx in (-1, 0, 1):
                for dy in (-1, 0, 1):
                    q = (x + dx, y + dy)
                    if q in todo or not (0 <= q[0] < S and 0 <= q[1] < S):
                        continue
                    c = px[q]
                    if c[3] > 127 and lum(c[:3]) >= 45:
                        votes[c] = votes.get(c, 0) + 1
            if votes:
                done[(x, y)] = max(votes, key=votes.get)
        for p_, c in done.items():
            px[p_] = c
        todo -= set(done)
    return img


def carve(img, piece, cx, cy, body_mask):
    """Lay a face piece into the body, cut to the body's own outline."""
    x0, y0 = int(round(cx - piece.width / 2)), int(round(cy - piece.height / 2))
    pp, px = piece.load(), img.load()
    for y in range(piece.height):
        for x in range(piece.width):
            q = (x0 + x, y0 + y)
            if pp[x, y][3] > 127 and q in body_mask:
                px[q] = pp[x, y][:3] + (255,)


def crest(img, n, x, y, scale):
    """The lute's curled pegbox (or the cello's scroll) growing from the top of the head."""
    r = max(2.6, min(5.0, scale))
    stem = ribbon([(x, y + 2), (x + r * 0.3, y - r * 0.9)], max(1.2, r * 0.42), max(1.1, r * 0.38))
    cl = curl(x + r * 0.9, y - r * 1.5, r, 200, w=max(1.5, r * 0.5))
    tones = F.EBONY if n != C else F.EBONY
    piece = compose([Layer([stem, cl], tones, depth=2, outline=F.EBONY_O)])
    for (gx, gy) in ((x + r * 0.2, y - r * 1.2), (x + r * 1.8, y - r * 2.3)):
        paint(piece, to_mask(smooth_poly_mask([ellipse_pts(gx, gy, 1.2, 1.2, 12)]), 0.3, False), F.GOLD[2])
    out = piece.copy(); out.alpha_composite(img)          # the crest sits behind the head
    top = Image.new("RGBA", img.size, (0, 0, 0, 0)); top.alpha_composite(piece)
    # keep the upper part of the crest (above the head line) in front
    tp = top.load(); op = out.load()
    for yy in range(S):
        for xx in range(S):
            if tp[xx, yy][3] > 127 and yy < y:
                op[xx, yy] = tp[xx, yy]
    return out


def face_clutter(img, e1, e2, erased):
    """Other light, outlined marks (teeth, a mouth, extra eyes) around the face."""
    px = img.load()
    D = max(4.0, e2[0] - e1[0]); cx, cy = (e1[0] + e2[0]) / 2, (e1[1] + e2[1]) / 2
    light = {(x, y) for y in range(S) for x in range(S)
             if (x, y) not in erased and abs(x - cx) <= 1.6 * D and cy - D <= y <= cy + 1.8 * D
             and px[x, y][3] > 127 and lum(px[x, y][:3]) > 185 and hsv(px[x, y][:3])[1] < 0.28}
    n = 0
    for c in components(light):
        if 2 <= len(c) <= 60:
            ring = grow(c, 1) - c
            dark = sum(1 for q in ring if px[q][3] > 127 and lum(px[q][:3]) < 75)
            if dark >= 0.35 * len(ring):
                n += 1
    return n


def line_head(n, body_n):
    """Lutling, Hauntello or Chorumbra as the head on body `body_n`."""
    base = custom(VOLTORB, src(body_n))
    eyes = find_eyes(base) if base is not None else None
    if eyes is not None:
        _, (e1, e2), eye_mask = eyes
        eye_mask = grow(fill_holes(eye_mask), 1)
        if face_clutter(base, e1, e2, eye_mask) > 0:
            eyes = None                     # this artist drew more of a face than we can paint over
    if eyes is None:
        if src(body_n) > AUTOGEN_MAX:
            return None
        base, face_mask, zone = body_info(SHEETS, src(body_n))
        if base is None:
            return None
        cx, cy, w, h = zone
        e1, e2 = (cx - max(3, w * 0.25), cy), (cx + max(3, w * 0.25), cy)
        eye_mask = grow(set(face_mask), 1) if face_mask else set()
    groups = colour_groups(base)
    img = map_families(base, groups, LINE_RAMPS[n])
    img = fill_over(img, eye_mask)
    body_mask = opaque(img)
    D = max(4.0, e2[0] - e1[0])
    cx, cy = (e1[0] + e2[0]) / 2, (e1[1] + e2[1]) / 2
    if n in NEW:
        # the instrument becomes the head: estimate the round head this body was drawn with ...
        col = [t for t in (min((y for y in range(S) if (x, y) in body_mask), default=None)
                           for x in range(int(cx - 1), int(cx + 2))) if t is not None]
        top = min(col) if col else cy - D
        rb = max(D * 0.75, min(D * 1.8, (cy - top) * 1.2))
        bx, by = cx, top + rb
        # ... clear its upper half, and set the instrument there, its face where the head's face was
        ip = img.load()
        for y in range(S):
            for x in range(S):
                if y < by - 1 and (x + 0.5 - bx) ** 2 + (y + 0.5 - by) ** 2 <= (rb + 1.2) ** 2:
                    ip[x, y] = (0, 0, 0, 0)
        piece, (fx, fy) = inst_head(n, rb)
        img.alpha_composite(piece, (int(round(bx - fx)), int(round(cy + 1 - fy))))
        return img
    elif n == L:
        size = int(round(min(24, max(10, D + 7)))); size += size % 2
        carve(img, P.lute_face(size), cx, cy + 0.5, body_mask)
    elif n == H:
        size = int(round(min(24, max(12, D + 9)))); size += size % 2
        carve(img, P.cello_face(size), cx, cy + 1, body_mask)
    else:
        ew, eh = max(1.6, min(3.2, D * 0.2)), max(1.9, min(3.6, D * 0.23))
        F.eye(img, e1[0], e1[1], ew, eh, (255, 140, 210), lid=0.2, look=(0.4, 0.2), outline=(40, 10, 60))
        F.eye(img, e2[0], e2[1] - 0.5, ew, eh, (255, 140, 210), lid=0.12, look=(0.4, 0.2), outline=(40, 10, 60))
        gw = max(2.5, D * 0.42)
        F.grin(img, F.Stage(1.0, 94), cx + 0.4, cy + eh + 1.2, gw, max(2.0, gw * 0.7), (40, 10, 60), teeth=(255, 250, 255))
    # the crest on top of the head, above the face
    tops = [min((y for y in range(S) if (x, y) in body_mask), default=None) for x in range(int(cx - D), int(cx + D) + 1)]
    cols = [(x, t) for x, t in zip(range(int(cx - D), int(cx + D) + 1), tops) if t is not None]
    if cols:
        x, t = min(cols, key=lambda q: q[1] + abs(q[0] - (cx + D * 0.25)) * 0.35)
        img = crest(img, n, x, t + 1, D * 0.32 + 1.5)
    return img


# --- Lutling / Hauntello / Chorumbra as the BODY ------------------------------------------------
ANCHOR = {L: (48, 70, 26), H: (45.5, 76, 24), C: (25.5, 22, 26)}


def possess(body_n, head_n):
    if body_n in NEW:
        return possess_new(body_n, head_n)
    return possess_old(body_n, head_n)


def possess_new(body_n, head_n):
    """head_n's head becomes the spirit in the new designs: peeking out of Lutling's rosette, bursting out
    of Hauntello's smashed cello, or wearing Chorumbra's harp-hat on her ghostly body."""
    o, d = OUR[body_n], NEW[body_n]
    cx, cy = d["cx"], d["cy"]
    size = {L: 2 * d.get("r_out", 10) * 1.25, H: 2 * d.get("r_out", 10) * 1.45, C: 2 * d.get("rx", 7) * 1.55}[body_n]
    size = int(round(size))
    head = spirit_head(head_n, size)
    if head is None:
        return None
    targets = LINE_RAMPS[head_n] if head_n in LINE else ramps_of(head)
    img = map_families(o["sprite"], o["groups"], targets, protect=o["protect"])
    glow = targets[min(1, len(targets) - 1)][-1]
    hx, hy = int(round(cx - head.width / 2)), int(round(cy - head.height / 2))
    if body_n in (L, H):
        # the head comes up out of the hole, bigger than it, with the lower rim of the hole in front
        before = img.copy()
        img.alpha_composite(head, (hx, hy - (1 if body_n == L else 2)))
        bp, ip = before.load(), img.load()
        r_in = d["r_hole"] - 0.3 if body_n == L else d["r_out"] * 0.62
        r_lip = d["r_out"] * 1.1
        for y in range(S):
            for x in range(S):
                rr = ((x + 0.5 - cx) ** 2 + (y + 0.5 - cy) ** 2) ** 0.5
                if r_in <= rr <= r_lip and y + 0.5 > cy + r_in * 0.25 and bp[x, y][3]:
                    ip[x, y] = bp[x, y]
        F.halo(img, opaque(head_layer(head, hx, hy - 1)), glow, 60)
    else:
        hat = d["hat"]; hp = hat.load(); ip = img.load()
        hat_rec = Image.new("RGBA", (S, S), (0, 0, 0, 0)); rp = hat_rec.load()
        for y in range(S):
            for x in range(S):
                if hp[x, y][3]:
                    rp[x, y] = ip[x, y]                       # the hat as recoloured with the body
        rx, ry = d["rx"] + 1.5, d["ry"] + 2.0
        for y in range(S):
            for x in range(S):
                if ((x + 0.5 - cx) / rx) ** 2 + ((y + 0.5 - cy) / ry) ** 2 <= 1 and not hp[x, y][3]:
                    ip[x, y] = (0, 0, 0, 0)
        hy = int(round(cy - head.height * 0.42))
        img.alpha_composite(head, (hx, hy))
        img.alpha_composite(hat_rec)
        F.halo(img, opaque(head_layer(head, hx, hy)), glow, 60)
    return img


def possess_old(body_n, head_n):
    """head_n's head becomes the spirit inside the instrument body_n."""
    o = OUR[body_n]
    cx, cy, size = ANCHOR[body_n]
    head = spirit_head(head_n, size)
    if head is None:
        return None
    if head_n in LINE:
        targets = LINE_RAMPS[head_n]
    else:
        targets = ramps_of(head)
    img = map_families(o["sprite"], o["groups"], targets, protect=o["protect"])
    r = max(head.size) / 2
    hx, hy = int(round(cx - head.width / 2)), int(round(cy - head.height / 2))
    glow = targets[min(1, len(targets) - 1)][-1]
    if body_n == L:
        # the gold rosette becomes a collar the spirit's head peeks out of
        R_ = r + 2.5
        petals = [ellipse_pts(cx + math.cos(math.radians(a)) * R_ * 0.9, cy + 2 + math.sin(math.radians(a)) * R_ * 0.75,
                              R_ * 0.26, R_ * 0.26, 14) for a in range(0, 360, 30)]
        ring = to_mask(smooth_poly_mask(petals), 0.45, False)
        paint(img, ring, F.GOLD[2]); paint(img, outline_of(ring), F.GOLD[0])
        hole = to_mask(smooth_poly_mask([ellipse_pts(cx, cy + 2, R_ * 0.8, R_ * 0.62, 32)]), 0.45, False)
        paint(img, hole, (30, 12, 40))
        img.alpha_composite(head, (hx, hy - 2))
        # the lower lip of the soundhole in front: the head sinks into the lute
        lip = {(x, y) for (x, y) in ring if y > cy + 2 + R_ * 0.35}
        paint(img, lip, F.GOLD[2]); paint(img, {p for p in outline_of(ring) if p in lip}, F.GOLD[0])
        F.halo(img, opaque(head_layer(head, hx, hy - 2)), glow, 70)
    elif body_n == H:
        img.alpha_composite(head, (hx, hy))
        # splintered wood at the lower rim: it is bursting out of the hole
        for k in range(9):
            a = math.radians(20 + k * 17.5)
            x0, y0 = cx + math.cos(a) * r * 0.9, cy + math.sin(a) * r * 0.8
            x1, y1 = cx + math.cos(a) * (r + 2.4), cy + math.sin(a) * (r * 0.8 + 2.4)
            paint(img, thin_line_mask([(x0, y0), (x1, y1)], 0.8), targets[0][-1] if k % 2 else targets[0][max(0, len(targets[0]) - 2)])
        for a in (210, 320):
            fx, fy = cx + math.cos(math.radians(a)) * (r + 1), cy + math.sin(math.radians(a)) * (r * 0.8 + 1)
            paint(img, to_mask(smooth_poly_mask([ellipse_pts(fx, fy, 1.3, 1.3, 12)]), 0.35, False), F.GOLD[2])
        F.halo(img, opaque(head_layer(head, hx, hy)), glow, 70)
    else:
        img.alpha_composite(head, (hx, hy))
        if head_n not in LINE:                    # Chorumbra's crown, now on the new head
            img = crest(img, C, int(cx + r * 0.25), hy + 1, r * 0.33 + 1.5)
        F.halo(img, opaque(head_layer(head, hx, hy)), glow, 60)
    return img


def head_layer(head, x, y):
    l = Image.new("RGBA", (S, S), (0, 0, 0, 0)); l.alpha_composite(head, (x, y)); return l


# --- any pair ------------------------------------------------------------------------------------
HAND = "/home/claude/frost-thaw/build/hand_fusions"     # individually drawn fusions (alb_proto.py) win


def fusion(h, b):
    hp = f"{HAND}/{h}.{b}.png"
    if os.path.exists(hp):
        return Image.open(hp).convert("RGBA")
    if h in LINE:
        return line_head(h, b) if b not in LINE else possess(b, h)
    if b in LINE:
        return possess(b, h)
    img = drawn(src(h), src(b))                    # Rimirage / Gloamcap with a base Pokemon or each other
    if img is None:
        return None
    return body_marks(b, head_marks(h, img))


NEWP = "/home/claude/frost-thaw/build/alb_parts"
NEW = {}
INFO_NEW = json.load(open(f"{NEWP}/info.json")) if os.path.exists(f"{NEWP}/info.json") else {}


def face_piece(n, size):
    """The new design's face (the spirit in its rosette / bursting from the cello / Chorumbra under her
    harp-hat), scaled so its face is about `size` pixels across. Returns (piece, face centre in piece)."""
    d = NEW[n]
    k = min(1.0, size / d["face_w"])
    piece = shrink(d["face"], k) if k < 0.97 else d["face"]
    kx, ky = piece.width / d["face"].width, piece.height / d["face"].height
    return piece, (d["face_c"][0] * kx, d["face_c"][1] * ky)


_HEADS = {}


def inst_head(n, r):
    """The instrument itself as a head about the size of a round head of radius r, drawn fresh at that
    size from the concept sheet (alb2), so the face and strings stay crisp. Returns (piece, face point)."""
    import alb2
    if n == L:
        size = int(round(min(72, max(26, 3.8 * r))))
        key = (n, size)
        if key not in _HEADS:
            im = alb2.alb2("lutling", size=size, ground=94, canvas=96)
            I = alb2.INFO["lutling"]; bb = im.getbbox()
            _HEADS[key] = (im.crop(bb), (I["cx"] - bb[0], I["cy"] - bb[1]))
    elif n == H:
        size = int(round(min(88, max(40, 6.6 * r))))
        key = (n, size)
        if key not in _HEADS:
            im = alb2.alb2("hauntello", size=size, ground=94, canvas=96)
            I = alb2.INFO["hauntello"]
            # the spirit in its rosette, with the cello's neck and scroll rising behind: a cello head
            a = im.load()
            (x0, y0), (x1, y1) = I["neck"]
            sx, sy, sr = I["scroll"]
            keep = I["mask"]
            hx_, hy_ = I["cx"], I["cy"]
            dx, dy = sx - hx_, sy - hy_
            Ln = (dx * dx + dy * dy) ** 0.5
            t_max = min(1.0, I["r_out"] * 2.1 / Ln)                 # a short neck, then the scroll
            tipx, tipy = hx_ + dx * t_max, hy_ + dy * t_max
            def near_neck(x, y):
                t = ((x - hx_) * dx + (y - hy_) * dy) / (Ln * Ln)
                if not (0 <= t <= t_max):
                    return False
                # distance to the neck line (the fingerboard runs from the face to the scroll)
                nx, ny = x0 + (x1 - x0) * 0, 0
                d = abs((x - hx_) * dy - (y - hy_) * dx) / Ln
                return d <= I["r_out"] * 0.36 and y < hy_
            out = Image.new("RGBA", im.size, (0, 0, 0, 0)); op = out.load()
            for y in range(im.height):
                for x in range(im.width):
                    if a[x, y][3] and (keep[y, x] or near_neck(x + 0.5, y + 0.5)):
                        op[x, y] = a[x, y]
            ox_, oy_ = int(round(tipx - sx)), int(round(tipy - sy))
            for y in range(im.height):
                for x in range(im.width):
                    if a[x, y][3] and ((x + 0.5 - sx) ** 2 + (y + 0.5 - sy) ** 2) ** 0.5 <= sr + 2.5:
                        q = (x + ox_, y + oy_)
                        if 0 <= q[0] < im.width and 0 <= q[1] < im.height:
                            op[q] = a[x, y]
            # the neck's sides get the outline the cello body gave them
            m = {(x, y) for y in range(out.height) for x in range(out.width) if op[x, y][3]}
            for (x, y) in m:
                if any((x + dx, y + dy) not in m for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))) and not keep[y, x]:
                    op[x, y] = (40, 12, 12, 255)
            bb = out.getbbox()
            _HEADS[key] = (out.crop(bb), (I["cx"] - bb[0], I["cy"] - bb[1]))
    else:
        size = int(round(min(120, max(46, 7.0 * r))))
        key = (n, size)
        if key not in _HEADS:
            im = alb2.alb2("chorumbra", size=size, ground=196, canvas=200)
            I = alb2.INFO["chorumbra"]; bb = I["box"]
            piece = im.crop(bb)
            _HEADS[key] = (piece, (I["cx"] - bb[0], I["cy"] - bb[1]))
    return _HEADS[key]


def init(customs, autogen, parts):
    global CUSTOMS, SHEETS, PARTS, OUR
    CUSTOMS, SHEETS = customs, Sheets(autogen)
    PARTS = json.load(open(f"{parts}/parts.json"))
    protect_keep = make_protect()
    for key, d in PARTS["species"].items():
        n = d["number"]
        if n in LINE:
            if os.path.exists(f"{NEWP}/{key}_body.png"):         # the concept-sheet designs (alb2.export_parts)
                sp = Image.open(f"{NEWP}/{key}_body.png").convert("RGBA")
                NEW[n] = dict(INFO_NEW[key], face=Image.open(f"{NEWP}/{key}_face.png").convert("RGBA"))
                if n == C:
                    NEW[n]["hat"] = Image.open(f"{NEWP}/{key}_hat.png").convert("RGBA")
            else:
                sp = Image.open(f"{parts}/{d['sprite']}").convert("RGBA")
            OUR[n] = {"sprite": sp, "protect": protect_keep, "groups": colour_groups(sp, protect=protect_keep)}


def make_protect():
    keep = [tuple(c) for v in PARTS["keep"].values() for c in v if v is not PARTS["keep"]["SPIRIT"]]
    keep = [tuple(c) for k, v in PARTS["keep"].items() if k in ("EBONY", "GOLD", "CREAM") for c in v]
    others = [tuple(c) for k, v in PARTS["wood"].items() for c in v] + [tuple(c) for c in PARTS["keep"]["SPIRIT"]] + \
             [tuple(c) for c in PARTS["keep"]["GLOW"]]
    cache = {}

    def protect(c):
        if c not in cache:
            if lum(c) < 40:
                cache[c] = False
            else:
                dk = min(sum((a - b) ** 2 for a, b in zip(c, k)) for k in keep)
                do = min(sum((a - b) ** 2 for a, b in zip(c, k)) for k in others)
                cache[c] = dk < do
        return cache[c]
    return protect


def save(img, path):
    os.makedirs(os.path.dirname(path), exist_ok=True)
    img.resize((S * 3, S * 3), Image.NEAREST).save(path, optimize=True)


def job(args):
    n, out = args
    errs = []
    for o in (CINDER if os.environ.get("CINDER_ONLY") else MYCO if os.environ.get("MYCO_ONLY") else
              LINE if os.environ.get("ALB_ONLY") else OURS):
        for h, b in ((o, n), (n, o)):
            try:
                img = fusion(h, b)
                if img is not None:
                    save(img, f"{out}/fusions/{h}/{h}.{b}.png")
                else:
                    errs.append((h, b, "no picture"))
            except Exception as e:
                errs.append((h, b, f"{type(e).__name__}: {e}"))
    return n, errs


def main():
    customs, autogen, parts, out = sys.argv[1:5]
    init(customs, autogen, parts)
    ours = {"CINDER_ONLY": CINDER, "MYCO_ONLY": MYCO, "ALB_ONLY": LINE}
    ours = next((v for k, v in ours.items() if os.environ.get(k)), OURS)
    stand_ins = {}
    if any(o in CINDER for o in ours):
        sd = "/home/claude/frost-thaw/build/concept/sprites"     # from the user's concept sheet (from_concept.py)
        stand_ins = {W: Image.open(f"{sd}/wickit_96.png").convert("RGBA"), ST: Image.open(f"{sd}/stoketail_96.png").convert("RGBA"),
                     FG: Image.open(f"{sd}/forgel_96.png").convert("RGBA")}
    if any(o in MYCO for o in ours):
        wd = "/home/claude/frost-thaw/build/concept/wyn_sprites"          # from the user's Wyn-line concept sheet (from_sheet.py)
        stand_ins[SP] = Image.open(f"{wd}/sporeye_96.png").convert("RGBA")
        stand_ins[MY] = Image.open(f"{wd}/myconarch_96.png").convert("RGBA")
    for o in ours:
        if o in stand_ins:
            sp = stand_ins[o]
        else:
            sp = Image.open(f"{parts}/{PARTS['species'][[k for k, d in PARTS['species'].items() if d['number'] == o][0]]['sprite']}").convert("RGBA")
        save(sp, f"{out}/base/{o}.png")
        for o2 in ours:
            img = fusion(o, o2)
            if img is not None:
                save(img, f"{out}/fusions/{o}/{o}.{o2}.png")
    group = MYCO if os.environ.get("MYCO_ONLY") else LINE if os.environ.get("ALB_ONLY") else None
    if group:                                        # the line with every other Frost & Thaw Pokemon, both ways
        for o in group:
            for o2 in OURS:
                if o2 in group:
                    continue
                for h, b in ((o, o2), (o2, o)):
                    img = fusion(h, b)
                    if img is not None:
                        save(img, f"{out}/fusions/{h}/{h}.{b}.png")
    if "--ours" in sys.argv:
        return
    only = [int(x) for x in sys.argv[sys.argv.index("--only") + 1].split(",")] if "--only" in sys.argv else range(1, AUTOGEN_MAX + 1)
    errors = []
    with Pool(initializer=init, initargs=(customs, autogen, parts)) as pool:
        for i, (n, errs) in enumerate(pool.imap_unordered(job, [(n, out) for n in only], chunksize=2)):
            errors += errs
            if i % 50 == 0:
                print(f"{i}/{len(only)}", flush=True)
    print("problems:", len(errors))
    for e in errors[:40]:
        print(" ", e)


if __name__ == "__main__":
    main()
