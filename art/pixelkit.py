"""A tiny pixel-art kit for drawing original creatures at 96x96, Gen-5 style:
each shape gets a mid tone, a lit rim (upper left), a shaded rim (lower right)
and a dark outline, and shapes are layered back to front."""
import math
from PIL import Image, ImageDraw

SIZE = 96


def shade(rgb, k):
    return tuple(max(0, min(255, int(c * k))) for c in rgb)


def mix(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


class Shape:
    def __init__(self, mask, base, light=None, dark=None, outline=None, rim=2, shadow=3, highlight=None, flat=False):
        self.mask = mask                      # set of (x, y)
        self.base = base
        self.light = light or mix(base, (255, 255, 255), 0.30)
        self.dark = dark or shade(base, 0.68)
        self.outline = outline or shade(base, 0.32)
        self.rim, self.shadow, self.highlight, self.flat = rim, shadow, highlight, flat


def mask_from(draw_fn):
    img = Image.new("1", (SIZE, SIZE), 0)
    draw_fn(ImageDraw.Draw(img))
    px = img.load()
    return {(x, y) for y in range(SIZE) for x in range(SIZE) if px[x, y]}


def ellipse(cx, cy, rx, ry):
    return mask_from(lambda d: d.ellipse([cx - rx, cy - ry, cx + rx, cy + ry], fill=1))


def polygon(pts):
    return mask_from(lambda d: d.polygon(pts, fill=1))


def tube(points, r0, r1):
    """A tapering tentacle/tail through a list of points."""
    m = set()
    n = len(points)
    for i in range(n - 1):
        (x0, y0), (x1, y1) = points[i], points[i + 1]
        steps = max(1, int(math.hypot(x1 - x0, y1 - y0)))
        for s in range(steps + 1):
            t = (i + s / steps) / (n - 1)
            r = r0 + (r1 - r0) * t
            x, y = x0 + (x1 - x0) * s / steps, y0 + (y1 - y0) * s / steps
            m |= ellipse(x, y, r, r)
    return m


def wave(x0, y0, length, amp, freq, phase=0.0, drift=0.0, steps=14):
    return [(x0 + amp * math.sin(phase + freq * i / steps * math.pi * 2) + drift * i / steps,
             y0 + length * i / steps) for i in range(steps + 1)]


def render(shapes, outline_all=True):
    img = Image.new("RGBA", (SIZE, SIZE), (0, 0, 0, 0))
    px = img.load()
    for sh in shapes:
        m = sh.mask
        for (x, y) in m:
            if not (0 <= x < SIZE and 0 <= y < SIZE):
                continue
            c = sh.base
            if not sh.flat:
                if (x + sh.shadow, y + sh.shadow) not in m or (x + sh.shadow, y) not in m and (x, y + sh.shadow) not in m:
                    c = sh.dark
                if (x - sh.rim, y - sh.rim) not in m:
                    c = sh.light
            edge = any((x + dx, y + dy) not in m for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))
            if edge:
                c = sh.outline
            px[x, y] = c + (255,)
        if sh.highlight:
            for (x, y) in sh.highlight:
                if (x, y) in m and 0 <= x < SIZE and 0 <= y < SIZE:
                    px[x, y] = mix(sh.light, (255, 255, 255), 0.6) + (255,)
    return img


def dots(img, pts, rgb):
    px = img.load()
    for x, y in pts:
        if 0 <= x < SIZE and 0 <= y < SIZE:
            px[x, y] = rgb + (255,)


def eye(img, x, y, w=3, h=4, iris=(30, 24, 40), glint=(255, 255, 255), white=None):
    d = ImageDraw.Draw(img)
    if white:
        d.rectangle([x - 1, y - 1, x + w, y + h], fill=white + (255,))
    d.rectangle([x, y, x + w - 1, y + h - 1], fill=iris + (255,))
    img.putpixel((x, y), glint + (255,))


def drop_to_ground(img, ground=90):
    """Move the art so its lowest pixel sits at `ground` (battle sprites stand on the floor)."""
    bb = img.getbbox()
    if not bb:
        return img
    out = Image.new("RGBA", img.size, (0, 0, 0, 0))
    out.alpha_composite(img, (48 - (bb[0] + bb[2]) // 2, ground - bb[3]))
    return out


# --- rounder shading: light from the upper left, four tones with dithering ---
def distance_field(mask):
    """Steps from each pixel to the edge of its shape."""
    dist = {}
    frontier = {p for p in mask if any((p[0] + dx, p[1] + dy) not in mask for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))}
    d = 1
    seen = set(frontier)
    for p in frontier:
        dist[p] = 1
    while frontier:
        d += 1
        nxt = set()
        for (x, y) in frontier:
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                q = (x + dx, y + dy)
                if q in mask and q not in seen:
                    seen.add(q); nxt.add(q); dist[q] = d
        frontier = nxt
    return dist


BAYER = [[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]]


class Solid:
    """A shape lit like a solid object. tones: darkest..lightest (4 colours) + outline."""
    def __init__(self, mask, tones, outline, depth=8, light=(-0.6, -0.7, 0.6), spec=None, metal=False):
        self.mask, self.tones, self.outline = mask, tones, outline
        self.depth, self.light, self.spec, self.metal = depth, light, spec, metal


def render_solids(shapes, size=SIZE):
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    px = img.load()
    for sh in shapes:
        m = sh.mask
        dist = distance_field(m)
        R = sh.depth
        hgt = {p: math.sqrt(max(0.0, 1 - (1 - min(dist[p], R) / R) ** 2)) for p in m}
        lx, ly, lz = sh.light
        ln = math.sqrt(lx * lx + ly * ly + lz * lz)
        for (x, y) in m:
            if not (0 <= x < size and 0 <= y < size):
                continue
            if any((x + dx, y + dy) not in m for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                px[x, y] = sh.outline + (255,)
                continue
            gx = hgt.get((x + 1, y), 0) - hgt.get((x - 1, y), 0)
            gy = hgt.get((x, y + 1), 0) - hgt.get((x, y - 1), 0)
            nx, ny, nz = -gx * 2.2, -gy * 2.2, 1.0
            nn = math.sqrt(nx * nx + ny * ny + nz * nz)
            lum = (nx * lx + ny * ly + nz * lz) / (nn * ln)
            if sh.metal:      # metal: bands of reflection across the surface
                lum = lum * 0.6 + 0.4 * math.sin((x * 0.9 + y * 0.25) * 0.35)
            v = max(0.0, min(0.999, (lum + 0.25) / 1.15)) * (len(sh.tones) - 1)
            i = int(v)
            frac = v - i
            if frac * 16 > BAYER[y % 4][x % 4] + 4 and frac > 0.35:
                i = min(i + 1, len(sh.tones) - 1)
            px[x, y] = sh.tones[i] + (255,)
        if sh.spec:
            for (x, y) in sh.spec:
                if (x, y) in m and 0 <= x < size and 0 <= y < size:
                    px[x, y] = (255, 255, 255, 255)
    return img
