"""Fusion sprite generator for Frost & Thaw's new Pokemon (Japeal / Infinite Fusion autogen style).

A fusion = the BODY's sprite, recoloured in the HEAD's colours, with the HEAD's head pasted
where the body's head is.  Head zones and head pictures for the base Pokemon are measured
from Infinite Fusion's own autogen spritesheets: on a sheet, every body is recoloured by a
fixed colour map, so the pixels that break that map are the pasted head.

Pure PIL; runs on the player's computer (python3) as well as here.
"""
import colorsys, math
import numpy as np
from PIL import Image

S = 96
AUTOGEN_MAX = 576          # Graphics/Battlers/spritesheets_autogen/<head>.png, cell = body


class Sheets:
    def __init__(self, autogen_dir, base_dir=None):
        self.dirs = {"autogen": autogen_dir.rstrip("/"), "base": (base_dir or "").rstrip("/")}
        self.cache = {}

    def sheet(self, kind, n):
        key = (kind, n)
        if key not in self.cache:
            try:
                self.cache[key] = Image.open(f"{self.dirs[kind]}/{n}.png").convert("RGBA")
            except (FileNotFoundError, IsADirectoryError):
                self.cache[key] = None
            if len(self.cache) > 40:                       # keep memory small (sample heads stay)
                for k in list(self.cache):
                    if k[1] not in FACE_REFS + [BALL]:
                        self.cache.pop(k); break
        return self.cache[key]

    def cell(self, kind, n, i):
        sh = self.sheet(kind, n)
        if sh is None:
            return None
        x, y = (i % 10) * S, (i // 10) * S
        if y + S > sh.height:
            return None
        c = sh.crop((x, y, x + S, y + S))
        return c if c.getbbox() else None

    def autogen(self, head, body):
        if head > AUTOGEN_MAX or body > AUTOGEN_MAX:
            return None
        return self.cell("autogen", head, body)



# --- masks ---------------------------------------------------------------------------
def opaque(img):
    a = img.getchannel("A").load()
    return {(x, y) for y in range(S) for x in range(S) if a[x, y] > 127}


def bbox_of(m):
    xs = [p[0] for p in m]; ys = [p[1] for p in m]
    return min(xs), min(ys), max(xs) + 1, max(ys) + 1


def components(m):
    m = set(m); out = []
    while m:
        st = [m.pop()]; comp = set(st)
        while st:
            x, y = st.pop()
            for d in ((1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (1, -1), (-1, 1)):
                q = (x + d[0], y + d[1])
                if q in m:
                    m.discard(q); comp.add(q); st.append(q)
        out.append(comp)
    return sorted(out, key=len, reverse=True)


def close(m, r=1, inside=None):
    grow = {(x + dx, y + dy) for (x, y) in m for dx in range(-r, r + 1) for dy in range(-r, r + 1)}
    if inside is not None:
        grow &= inside
    shrink = {p for p in grow if all((p[0] + dx, p[1] + dy) in grow or (inside is not None and (p[0] + dx, p[1] + dy) not in inside)
                                     for dx in range(-r, r + 1) for dy in range(-r, r + 1))}
    return shrink | set(m)


def fill_holes(m):
    outside = set(); st = [(-1, -1)]
    while st:
        p = st.pop()
        if p in outside or p in m or not (-1 <= p[0] <= S and -1 <= p[1] <= S):
            continue
        outside.add(p)
        st += [(p[0] + 1, p[1]), (p[0] - 1, p[1]), (p[0], p[1] + 1), (p[0], p[1] - 1)]
    return {(x, y) for y in range(S) for x in range(S) if (x, y) not in outside}


# --- the pasted head on an autogen fusion ----------------------------------------------
# On Infinite Fusion's autogen sheets a head keeps its own pixels exactly; only its position
# changes from body to body.  So the head of Pokemon n is the pixel pattern that two of its
# fusions share after a shift.
def keys(img):
    a = np.asarray(img, dtype=np.int64)
    k = (a[..., 0] << 16) | (a[..., 1] << 8) | a[..., 2]
    k[a[..., 3] <= 127] = -1
    return k


def best_shift(k1, k2, limit=48):
    """Shift (dx, dy) that lays k2 over k1 with the most identical pixels; and the mask (in k1)."""
    v1, c1 = np.unique(k1[k1 >= 0], return_counts=True)
    v2, c2 = np.unique(k2[k2 >= 0], return_counts=True)
    n1, n2 = dict(zip(v1.tolist(), c1.tolist())), dict(zip(v2.tolist(), c2.tolist()))
    common = [c for c in n1 if c in n2]
    common.sort(key=lambda c: n1[c] * n2[c])
    votes = {}
    budget = 0
    for c in common:
        y1, x1 = np.nonzero(k1 == c); y2, x2 = np.nonzero(k2 == c)
        if len(x1) * len(x2) > 4000:
            continue
        dx = (x1[:, None] - x2[None, :]).ravel(); dy = (y1[:, None] - y2[None, :]).ravel()
        for s_ in zip(dx.tolist(), dy.tolist()):
            votes[s_] = votes.get(s_, 0) + 1
        budget += len(dx)
        if budget > 60000:
            break
    cands = sorted(votes, key=votes.get, reverse=True)[:8] or [(0, 0)]
    best = None
    for dx, dy in cands:
        if abs(dx) > limit or abs(dy) > limit:
            continue
        sh = np.full_like(k2, -2)
        ys, ye = max(0, dy), min(S, S + dy); xs, xe = max(0, dx), min(S, S + dx)
        sh[ys:ye, xs:xe] = k2[ys - dy:ye - dy, xs - dx:xe - dx]
        m = (k1 >= 0) & (k1 == sh)
        n = int(m.sum())
        if best is None or n > best[0]:
            best = (n, (dx, dy), m)
    return best


def mask_set(m):
    ys, xs = np.nonzero(m)
    return set(zip(xs.tolist(), ys.tolist()))


# A Voltorb "body" turns any head into a round head piece: F(n, Voltorb) is n's face and
# colours on a ball.  A Voltorb "head" marks where a body keeps its face: F(Voltorb, n).
BALL = 100
FACE_REFS = [25, 1, 7, 39, 52, 4]


def violations(f1, f2):
    """Pixels of f1 not explained by a colour map from f2 (same body, different heads)."""
    k1, k2 = keys(f1), keys(f2)
    both = (k1 >= 0) & (k2 >= 0)
    pairs = {}
    for a, b in zip(k1[both].tolist(), k2[both].tolist()):
        d = pairs.setdefault(b, {})
        d[a] = d.get(a, 0) + 1
    cmap = {b: max(d, key=d.get) for b, d in pairs.items()}
    out = set()
    ys, xs = np.nonzero(k1 >= 0)
    for x, y in zip(xs.tolist(), ys.tolist()):
        b = int(k2[y, x])
        if b < 0 or cmap.get(b) != int(k1[y, x]):
            out.add((x, y))
    return out


def head_piece(sheets, n):
    """Head of base Pokemon n as a round head piece (cropped)."""
    f = sheets.autogen(n, BALL) if n != BALL else sheets.autogen(BALL, BALL)
    if f is None:
        f = sheets.cell("base", n, 0)
        cx, cy, w, h = guess_head_zone(f)
        m = {p_ for p_ in opaque(f) if abs(p_[0] - cx) <= w / 2 and abs(p_[1] - cy) <= h / 2 + 2}
        c = Image.new("RGBA", (S, S), (0, 0, 0, 0)); fp, op = f.load(), c.load()
        for p_ in m:
            op[p_] = fp[p_]
        f = c
    return f.crop(f.getbbox())


def body_info(sheets, body):
    """(body picture, face mask to paint over, (cx, cy, w, h) of the face zone)."""
    if body <= AUTOGEN_MAX:
        h0 = BALL if body != BALL else 52
        f = sheets.autogen(h0, body)
        refs = [sheets.autogen(r, body) for r in FACE_REFS if r not in (h0, body)]
        refs = [r for r in refs if r is not None][:3]
        if f is not None and len(refs) >= 2:
            v = violations(f, refs[0])
            for r in refs[1:]:
                v &= violations(f, r)
            if len(v) >= 6:
                comps = components(close(v, 1, opaque(f)))
                main = set(comps[0])
                bx = bbox_of(main)
                for c in comps[1:]:
                    cb = bbox_of(c)
                    if len(c) >= 3 and cb[0] < bx[2] + 3 and cb[2] > bx[0] - 3 and cb[1] < bx[3] + 3 and cb[3] > bx[1] - 3:
                        main |= c
                bb = bbox_of(main)
                if (bb[2] - bb[0]) <= 40 and (bb[3] - bb[1]) <= 40:
                    return f, main, ((bb[0] + bb[2]) / 2, (bb[1] + bb[3]) / 2, bb[2] - bb[0], bb[3] - bb[1])
    img = sheets.cell("base", body, 0) if body > AUTOGEN_MAX else (sheets.autogen(BALL, body) or sheets.cell("base", body, 0))
    z = guess_head_zone(img)
    return img, set(), z


def guess_head_zone(img):
    """No autogen data: assume the head is the top of the figure."""
    m = opaque(img)
    x0, y0, x1, y1 = bbox_of(m)
    h = min(34, max(16, (y1 - y0) * 0.42))
    band = [p for p in m if p[1] < y0 + h]
    cx = sum(p[0] for p in band) / len(band)
    w = min(34, max(16, (x1 - x0) * 0.55))
    return cx, y0 + h / 2, w, h


# --- palettes and recolouring ---------------------------------------------------------
def lum(c):
    return 0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2]


def hsv(c):
    return colorsys.rgb_to_hsv(c[0] / 255, c[1] / 255, c[2] / 255)


def hue_dist(a, b):
    d = abs(a - b) % 1.0
    return min(d, 1 - d)


def colour_groups(img, protect=None, ignore=None):
    """Colour families of a sprite, biggest first: [(hue, sat, [colours dark->light], count)]."""
    counts = {}
    px = img.load()
    for y in range(img.height):
        for x in range(img.width):
            p = px[x, y]
            if p[3] > 127:
                counts[p[:3]] = counts.get(p[:3], 0) + 1
    groups = []
    for c, n in sorted(counts.items(), key=lambda kv: -kv[1]):
        if protect and protect(c):
            continue
        if ignore and (x for x in ()) and False:
            pass
        L = lum(c)
        if L < 40:                      # outlines
            continue
        h, s, v = hsv(c)
        neutral = s < 0.16
        for g in groups:
            if g["neutral"] == neutral and (neutral or hue_dist(g["hue"], h) < 0.07):
                g["cols"].append(c); g["n"] += n
                break
        else:
            groups.append({"hue": h, "sat": s, "neutral": neutral, "cols": [c], "n": n})
    groups.sort(key=lambda g: -g["n"])
    for g in groups:
        g["cols"].sort(key=lum)
    return groups


def ramp_pick(ramp, t):
    return ramp[max(0, min(len(ramp) - 1, int(round(t * (len(ramp) - 1)))))]


def recolour(body, body_groups, head_groups, outline=None, protect=None):
    """Japeal-style: each colour family of the body takes the matching family of the head,
    keeping its light/dark position."""
    if not head_groups:
        return body.copy()
    targets = [g for g in head_groups if not g["neutral"]] or head_groups
    m = {}
    k = 0
    for g in body_groups:
        if g["neutral"] and g is not body_groups[0]:
            continue                          # whites/greys (eyes, shells) stay
        tgt = targets[min(k, len(targets) - 1)]
        k += 1
        cols = g["cols"]
        lo, hi = lum(cols[0]), lum(cols[-1])
        for c in cols:
            t = 0.5 if hi - lo < 1 else (lum(c) - lo) / (hi - lo)
            m[c] = ramp_pick(tgt["cols"], t)
    dark = outline or darken(targets[0]["cols"][0], 0.45)
    out = body.copy(); px = out.load()
    for y in range(S):
        for x in range(S):
            p = px[x, y]
            if p[3] <= 127:
                continue
            if protect and protect(p[:3]):
                continue
            if p[:3] in m:
                px[x, y] = m[p[:3]] + (p[3],)
            elif lum(p[:3]) < 40:
                px[x, y] = dark + (p[3],)
    return out


def darken(c, k):
    return tuple(int(v * k) for v in c)


# --- assembling a fusion ------------------------------------------------------------
def scaled(img, k):
    if abs(k - 1) < 0.04:
        return img
    w, h = max(1, round(img.width * k)), max(1, round(img.height * k))
    return img.resize((w, h), Image.NEAREST)


def paste_head(body_img, head_img, zone, max_grow=1.15, min_scale=0.55):
    cx, cy, w, h = zone
    hw, hh = head_img.size
    k = min(1.0, max(min_scale, min(w * max_grow / hw, h * max_grow / hh)))
    hi = scaled(head_img, k)
    x = int(round(cx - hi.width / 2))
    y = int(round(cy - hi.height / 2))
    y = max(0, min(S - hi.height, y)); x = max(0, min(S - hi.width, x))
    out = body_img.copy()
    out.alpha_composite(hi, (x, y))
    return out


def fuse(head, body):
    """head / body: dicts with 'sprite', 'zone', 'head', 'groups', and optional 'protect', 'outline'."""
    img = recolour(body["sprite"], body["groups"], head["groups"], head.get("outline"), body.get("protect"))
    return paste_head(img, head["head"], body["zone"])
