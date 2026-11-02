"""Cleaner pixel art from smooth shapes.
  - shapes are drawn as smooth polygons at 8x and reduced by area coverage
  - silhouettes are smoothed (no 1-pixel bumps or notches)
  - 1px outlines are made 'pixel perfect' (no doubled L-corners)
  - shading is flat cel bands (no dither), with tiny islands merged away
  - outlines take a dark version of the colour beside them (selective outline)"""
import math
from PIL import Image, ImageDraw

N = 96
K = 8                      # supersampling factor


def smooth_poly_mask(polys, holes=()):
    im = Image.new("L", (N * K, N * K), 0)
    d = ImageDraw.Draw(im)
    for p in polys:
        d.polygon([(x * K, y * K) for x, y in p], fill=255)
    for p in holes:
        d.polygon([(x * K, y * K) for x, y in p], fill=0)
    return im


def ellipse_pts(cx, cy, rx, ry, n=64, a0=0, a1=360):
    return [(cx + rx * math.cos(math.radians(a0 + (a1 - a0) * i / n)), cy + ry * math.sin(math.radians(a0 + (a1 - a0) * i / n))) for i in range(n + 1)]


def ribbon(pts, r0, r1):
    """A smooth tapered stroke as one polygon (left side out, right side back)."""
    L, R = [], []
    n = len(pts)
    for i, (x, y) in enumerate(pts):
        a = pts[min(i + 1, n - 1)]; b = pts[max(i - 1, 0)]
        dx, dy = a[0] - b[0], a[1] - b[1]
        ln = math.hypot(dx, dy) or 1
        nx, ny = -dy / ln, dx / ln
        r = r0 + (r1 - r0) * i / (n - 1)
        L.append((x + nx * r, y + ny * r)); R.append((x - nx * r, y - ny * r))
    cap_end = ellipse_pts(pts[-1][0], pts[-1][1], r1, r1, 12)
    return L + cap_end + R[::-1] + ellipse_pts(pts[0][0], pts[0][1], r0, r0, 12)


def to_mask(im, threshold=0.5, clean=True):
    small = im.resize((N, N), Image.BOX).load()
    m = {(x, y) for y in range(N) for x in range(N) if small[x, y] >= threshold * 255}
    return tidy(m) if clean else m


def tidy(m, rounds=2):
    """Remove 1-pixel spurs and fill 1-pixel notches."""
    for _ in range(rounds):
        add, rem = set(), set()
        for y in range(N):
            for x in range(N):
                n4 = sum((x + dx, y + dy) in m for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))
                if (x, y) in m and n4 <= 1:
                    rem.add((x, y))
                elif (x, y) not in m and n4 >= 3:
                    add.add((x, y))
        m = (m - rem) | add
    return m


def outline_of(m):
    """Pixel-perfect 1px boundary: boundary pixels minus redundant L-corners."""
    b = {p for p in m if any((p[0] + dx, p[1] + dy) not in m for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))}
    out = set(b)
    for (x, y) in b:
        for (hx, vy) in ((1, 1), (1, -1), (-1, 1), (-1, -1)):
            if (x + hx, y) in out and (x, y + vy) in out and (x + hx, y + vy) not in m:
                # an L-corner bulging outward: drop it if the two neighbours connect diagonally
                if (x - hx, y) not in out and (x, y - vy) not in out:
                    out.discard((x, y))
                    break
    return out


def lighting(m, depth=8, light=(-0.55, -0.75, 0.55)):
    """Height from distance to edge -> normals -> lambert value per pixel."""
    dist = {}
    frontier = {p for p in m if any((p[0] + dx, p[1] + dy) not in m for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))}
    seen = set(frontier); d = 1
    for p in frontier: dist[p] = 1
    while frontier:
        d += 1; nxt = set()
        for (x, y) in frontier:
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                q = (x + dx, y + dy)
                if q in m and q not in seen:
                    seen.add(q); nxt.add(q); dist[q] = d
        frontier = nxt
    h = {p: math.sqrt(max(0.0, 1 - (1 - min(dist[p], depth) / depth) ** 2)) for p in m}
    lx, ly, lz = light; ln = math.sqrt(lx * lx + ly * ly + lz * lz)
    val = {}
    for (x, y) in m:
        gx = h.get((x + 1, y), 0) - h.get((x - 1, y), 0)
        gy = h.get((x, y + 1), 0) - h.get((x, y - 1), 0)
        nx, ny, nz = -gx * 2.0, -gy * 2.0, 1.0
        nn = math.sqrt(nx * nx + ny * ny + nz * nz)
        val[(x, y)] = (nx * lx + ny * ly + nz * lz) / (nn * ln)
    return val


def bands(m, val, tones, cuts):
    """Posterize into tones (darkest..lightest) at the given cut values, then merge tiny islands."""
    idx = {}
    for p, v in val.items():
        i = 0
        while i < len(cuts) and v > cuts[i]:
            i += 1
        idx[p] = i
    # merge islands smaller than 3 pixels into their most common neighbour band
    for _ in range(2):
        for p in list(idx):
            same = sum(idx.get((p[0] + dx, p[1] + dy)) == idx[p] for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))
            if same == 0:
                nb = [idx.get((p[0] + dx, p[1] + dy)) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))]
                nb = [n for n in nb if n is not None]
                if nb:
                    idx[p] = max(set(nb), key=nb.count)
    return {p: tones[i] for p, i in idx.items()}


def darker(c, k=0.45):
    return tuple(int(v * k) for v in c)


class Layer:
    """One part of a creature: a smooth shape, its tones, and how it's lit."""
    def __init__(self, polys, tones, depth=8, cuts=(-0.05, 0.35, 0.75), outline=None, holes=(), flat=False, light=None,
                 threshold=0.5, clean=True):
        self.mask = to_mask(smooth_poly_mask(polys, holes), threshold, clean)
        self.tones, self.depth, self.cuts, self.outline, self.flat = tones, depth, cuts, outline, flat
        self.light = light


def compose(layers, sel_out=True):
    """Paint layers back to front; each gets its own selective outline."""
    img = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    px = img.load()
    for L in layers:
        m = L.mask
        if not m:
            continue
        if L.flat:
            col = {p: L.tones[min(1, len(L.tones) - 1)] for p in m}
        else:
            val = lighting(m, L.depth, L.light or (-0.55, -0.75, 0.55))
            col = bands(m, val, L.tones, L.cuts)
        ol = set() if L.outline == "none" else outline_of(m)
        for p, c in col.items():
            x, y = p
            if not (0 <= x < N and 0 <= y < N):
                continue
            if p in ol:
                c = L.outline or darker(L.tones[0], 0.55)
            px[x, y] = c + (255,)
    return img


def paint(img, mask, colour):
    px = img.load()
    for (x, y) in mask:
        if 0 <= x < N and 0 <= y < N:
            px[x, y] = colour + (255,)


def line_mask(pts, width=1.0):
    """A clean 1px (or wider) line from smooth points."""
    im = Image.new("L", (N * K, N * K), 0)
    ImageDraw.Draw(im).line([(x * K, y * K) for x, y in pts], fill=255, width=max(1, int(width * K)), joint="curve")
    small = im.resize((N, N), Image.BOX).load()
    return {(x, y) for y in range(N) for x in range(N) if small[x, y] >= 0.42 * 255}


def drop_to_ground(img, ground=92):
    bb = img.getbbox()
    if not bb:
        return img
    out = Image.new("RGBA", img.size, (0, 0, 0, 0))
    out.alpha_composite(img, (48 - (bb[0] + bb[2]) // 2, ground - bb[3]))
    return out


# --- refinement passes ---------------------------------------------------------------
def perfect_line(m):
    """Remove redundant corner pixels from a 1px line (no doubled L-steps)."""
    out = set(m)
    for (x, y) in sorted(m):
        if (x, y) not in out:
            continue
        for hx, vy in ((1, 1), (1, -1), (-1, 1), (-1, -1)):
            if (x + hx, y) in out and (x, y + vy) in out:
                n = sum((x + dx, y + dy) in out for dx in (-1, 0, 1) for dy in (-1, 0, 1)) - 1
                if n == 2:
                    out.discard((x, y))
                    break
    return out


def pixel_path(pts):
    """A continuous 1px line through the points (dense sampling, then pixel-perfect)."""
    out = set()
    for (x0, y0), (x1, y1) in zip(pts, pts[1:]):
        n = max(1, int(max(abs(x1 - x0), abs(y1 - y0)) * 4))
        for i in range(n + 1):
            t = i / n
            out.add((int(round(x0 + (x1 - x0) * t - 0.5)), int(round(y0 + (y1 - y0) * t - 0.5))))
    return perfect_line({(x, y) for x, y in out if 0 <= x < N and 0 <= y < N})


def thin_line_mask(pts, width=1.0):
    if width <= 1.0:
        return pixel_path(pts)
    return line_mask(pts, width)


def cleanup_clusters(img, rounds=2):
    """Merge lone pixels into the colour that surrounds them (opaque interior only)."""
    px = img.load()
    for _ in range(rounds):
        changes = {}
        for y in range(1, N - 1):
            for x in range(1, N - 1):
                c = px[x, y]
                if c[3] < 255:
                    continue
                nb = [px[x + dx, y + dy] for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))]
                if any(n[3] < 255 for n in nb):
                    continue
                if all(n[:3] != c[:3] for n in nb):
                    best = max(set(n[:3] for n in nb), key=lambda col: sum(n[:3] == col for n in nb))
                    if sum(n[:3] == best for n in nb) >= 3:
                        changes[(x, y)] = best + (255,)
        for p, c in changes.items():
            px[p] = c
    return img


def selout(img, k_dark=0.38, k_lit=0.6):
    """Outer outline = a dark tint of the colour just inside it; lighter on the lit (upper-left) side."""
    px = img.load()
    edge = []
    for y in range(N):
        for x in range(N):
            if px[x, y][3] < 200:
                continue
            outside = [(dx, dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))
                       if not (0 <= x + dx < N and 0 <= y + dy < N) or px[x + dx, y + dy][3] < 200]
            if outside:
                edge.append((x, y, outside))
    edge_set = {(x, y) for x, y, _ in edge}
    new = {}
    for x, y, outside in edge:
        inner = [px[x + dx, y + dy] for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1), (1, 1), (-1, -1), (1, -1), (-1, 1))
                 if 0 <= x + dx < N and 0 <= y + dy < N and px[x + dx, y + dy][3] >= 200 and (x + dx, y + dy) not in edge_set]
        base = max(inner, key=lambda c: sum(c[:3])) if inner else px[x, y]
        lit = any(d in outside for d in ((-1, 0), (0, -1)))
        k = k_lit if lit else k_dark
        new[(x, y)] = tuple(int(v * k) for v in base[:3]) + (255,)
    for p, c in new.items():
        px[p] = c
    return img


def rim_light(img, mask, colour):
    """A crisp highlight just inside the lit (upper-left) edge of a shape."""
    px = img.load()
    for (x, y) in mask:
        if (x - 1, y) not in mask or (x, y - 1) not in mask:
            continue
        if ((x - 2, y) not in mask or (x, y - 2) not in mask) and (x + 1, y) in mask and (x, y + 1) in mask:
            if 0 <= x < N and 0 <= y < N and px[x, y][3] == 255:
                px[x, y] = colour + (255,)


def limit_palette(img, n=40):
    """Snap every opaque pixel to a limited palette (no muddy in-between colours)."""
    rgb = Image.new("RGB", img.size, (0, 0, 0)); rgb.paste(img, mask=img.split()[3].point(lambda a: 255 if a >= 200 else 0))
    q = rgb.quantize(colors=n, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE).convert("RGB")
    out = img.copy(); po, pq, pi = out.load(), q.load(), img.load()
    for y in range(N):
        for x in range(N):
            if pi[x, y][3] >= 200:
                po[x, y] = pq[x, y] + (255,)
    return out
