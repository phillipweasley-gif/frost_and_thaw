"""Draw shapes at 4x, then shrink to clean 96x96 pixel masks."""
import math
from PIL import Image, ImageDraw
from pixelkit import SIZE

S = 4


class Part:
    def __init__(self):
        self.im = Image.new("L", (SIZE * S, SIZE * S), 0)
        self.d = ImageDraw.Draw(self.im)

    def ellipse(self, cx, cy, rx, ry, fill=255):
        self.d.ellipse([(cx - rx) * S, (cy - ry) * S, (cx + rx) * S, (cy + ry) * S], fill=fill); return self

    def poly(self, pts, fill=255):
        self.d.polygon([(x * S, y * S) for x, y in pts], fill=fill); return self

    def stroke(self, pts, r0, r1=None, fill=255):
        """A tapering stroke along a path (points in 96-space)."""
        r1 = r0 if r1 is None else r1
        total = sum(math.hypot(b[0] - a[0], b[1] - a[1]) for a, b in zip(pts, pts[1:])) or 1
        acc = 0
        for a, b in zip(pts, pts[1:]):
            seg = math.hypot(b[0] - a[0], b[1] - a[1])
            n = max(2, int(seg * S))
            for i in range(n + 1):
                t = (acc + seg * i / n) / total
                r = r0 + (r1 - r0) * t
                x, y = a[0] + (b[0] - a[0]) * i / n, a[1] + (b[1] - a[1]) * i / n
                self.d.ellipse([(x - r) * S, (y - r) * S, (x + r) * S, (y + r) * S], fill=fill)
            acc += seg
        return self

    def cut(self, other):
        self.im.paste(0, mask=other.im); return self

    def mask(self, threshold=128):
        small = self.im.resize((SIZE, SIZE), Image.BOX)
        px = small.load()
        return {(x, y) for y in range(SIZE) for x in range(SIZE) if px[x, y] >= threshold}


def bezier(p0, p1, p2, p3, n=24):
    out = []
    for i in range(n + 1):
        t = i / n
        a = (1 - t) ** 3; b = 3 * (1 - t) ** 2 * t; c = 3 * (1 - t) * t ** 2; d = t ** 3
        out.append((a * p0[0] + b * p1[0] + c * p2[0] + d * p3[0], a * p0[1] + b * p1[1] + c * p2[1] + d * p3[1]))
    return out


def spiral(cx, cy, r0, turns, start_ang, shrink=0.75, n=40, clockwise=True):
    pts = []
    for i in range(n + 1):
        t = i / n
        a = math.radians(start_ang) + (1 if clockwise else -1) * turns * 2 * math.pi * t
        r = r0 * (1 - shrink * t)
        pts.append((cx + r * math.cos(a), cy + r * math.sin(a)))
    return pts
