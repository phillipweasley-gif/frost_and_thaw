"""Cinderwright line, second pass: organic shapes, whole-form shading, cast shadows, fur tufts."""
import math
from PIL import Image
from clean import paint, to_mask, smooth_poly_mask, ellipse_pts, outline_of, thin_line_mask, selout, cleanup_clusters, N
from hires import bezier
from sculpt import Part, render
from cinder import RUSSET, CREAM, SOOT, EMBER, CLAY, CLAY_O, IRIS, PORCELAIN, PORCELAIN_O, COBALT, COBALT_LT, IRON, COPPER, blue_and_white
import final_line as F

RUSSET5 = [(92, 36, 26), (138, 60, 36), (182, 92, 50), (216, 128, 74), (240, 170, 116)]
CREAM4 = [(206, 170, 126), (232, 206, 164), (248, 230, 196), (255, 246, 224)]
SOOT4 = [(26, 22, 26), (46, 38, 40), (68, 58, 56), (94, 82, 76)]


def E(cx, cy, rx, ry, rot=0.0, n=40):
    c, s = math.cos(math.radians(rot)), math.sin(math.radians(rot))
    return [(cx + x * c - y * s, cy + x * s + y * c) for x, y in ellipse_pts(0, 0, rx, ry, n)]


def tube(path, radii, step=0.5):
    """Chain of circles along a path, radius interpolated; robust for curls."""
    k = len(radii) - 1
    total = sum(math.hypot(b[0] - a[0], b[1] - a[1]) for a, b in zip(path, path[1:]))
    out, run = [], 0.0
    for a, b in zip(path, path[1:]):
        seg = math.hypot(b[0] - a[0], b[1] - a[1])
        n = max(1, int(seg / step))
        for j in range(n):
            t = j / n
            u = (run + seg * t) / total
            i = min(int(u * k), k - 1)
            r = radii[i] + (radii[i + 1] - radii[i]) * (u * k - i)
            out.append(ellipse_pts(a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t, r, r, 16))
        run += seg
    return out


def tufts(points):
    """Little triangular fur tufts: (base_x, base_y, tip_x, tip_y, half_width)."""
    polys = []
    for (bx, by, tx, ty, w) in points:
        dx, dy = tx - bx, ty - by
        ln = math.hypot(dx, dy) or 1
        nx, ny = -dy / ln * w, dx / ln * w
        polys.append([(bx + nx, by + ny), (tx, ty), (bx - nx, by - ny)])
    return polys


def eye(img, cx, cy, w, h):
    m = to_mask(smooth_poly_mask([ellipse_pts(cx, cy, w, h, 24)]), 0.42, False)
    paint(img, m, (40, 20, 14))
    paint(img, {(x, y) for (x, y) in m if y >= cy + h * 0.2 and abs(x - cx) <= w * 0.7}, IRIS)
    paint(img, {(x, y) for (x, y) in m if y >= cy + h * 0.55 and abs(x - cx) <= w * 0.4}, (255, 196, 90))
    paint(img, outline_of(m), (22, 8, 6))
    hx, hy = int(round(cx - w * 0.3)), int(round(cy - h * 0.35))
    paint(img, {(hx, hy), (hx, hy + 1)} if h > 2.4 else {(hx, hy)}, (255, 255, 255))


def toe_lines(img, cx, cy, rx, up=True, n=3, colour=SOOT4[0]):
    for i in range(n):
        x = cx - rx * 0.5 + rx * i / max(1, n - 1)
        y0 = cy - (rx * 0.55 if up else -rx * 0.55)
        paint(img, {(int(round(x)), int(round(y0))), (int(round(x)), int(round(y0 + (1 if up else -1))))}, colour)


def flame(x, y, r, lean=0.0):
    return [(x + lean * r, y - r * 2.0)] + ellipse_pts(x, y, r, r * 0.95, 32, -10, 190)[::-1]


# ===============================================================================================
def wickit():
    # tail: from behind the right hip, out and up, curling in beside the face
    tail_path = bezier((58, 84), (80, 90), (82, 62), (68, 50), 30)
    tail = tube(tail_path, [3.6, 4.8, 4.6, 3.4])
    fluff = tufts([(76, 70, 80, 69, 1.4), (77, 63, 81, 61, 1.3), (74, 57, 77, 54, 1.2), (72, 80, 76, 82, 1.4)])
    body = [[(41, 60), (38, 66), (36, 76), (38, 84), (43, 89), (52, 89), (57, 84), (59, 74), (57, 65), (54, 60)]]
    chest_fluff = tufts([(39, 64, 36, 66, 1.4), (38, 69, 35, 71, 1.3)])
    belly = [E(46, 76, 6.2, 10)]
    thigh = [E(56, 81, 6.6, 7)]
    head = [E(46, 50, 14, 11.5), E(35, 55, 7.2, 5.2, -6)] + tufts([(57, 55, 63, 58, 2.2), (58, 50, 63, 50, 1.8), (36, 59, 33, 62, 1.6)])
    muzzle = [E(36.5, 56, 8.0, 5.4, -6), E(44, 59, 6, 2.6)]
    ears = [E(35, 40, 4.6, 4.6), E(56, 39.5, 5.0, 5.0)]
    notch = [[(55.6, 33.5), (57.2, 34.0), (56.2, 36.4)]]
    arms = tube([(43, 64), (41, 70)], [2.8, 2.6]) + tube([(51, 65), (52, 71)], [2.8, 2.6])
    paws = [E(41, 72, 4.0, 3.2, -10), E(52.5, 72.5, 4.0, 3.2, 10)]
    feet = [E(40, 88.5, 5.6, 2.6), E(55, 89, 6.4, 2.8)]
    stone = [E(47, 69.5, 3.4, 2.6, -8)]
    tuft = [flame(67, 47, 4.4, lean=-0.15)]
    parts = [
        Part(tail + fluff, RUSSET5, depth=4, cuts=(-0.25, 0.1, 0.4, 0.7), shadow=None),
        Part(body + chest_fluff, RUSSET5, depth=9, cuts=(-0.25, 0.1, 0.4, 0.7), regions=[(belly, CREAM4)], shadow=None),
        Part(thigh, RUSSET5, depth=5, cuts=(-0.25, 0.1, 0.4, 0.72), shadow=(-1, 1)),
        Part(feet, SOOT4, depth=2, cuts=(-0.2, 0.3, 0.7), shadow=(0, -1)),
        Part(arms + paws, RUSSET5, depth=3, cuts=(-0.25, 0.1, 0.4, 0.7), regions=[(paws + tube([(42, 68), (41, 70)], [2.6, 2.6]) + tube([(52, 69), (52, 71)], [2.6, 2.6]), SOOT4)], shadow=(1, 1)),
        Part(stone, CLAY, depth=2, cuts=(-0.2, 0.3, 0.7), outline=CLAY_O, shadow=(0, 1)),
        Part(ears, RUSSET5, depth=3, cuts=(-0.25, 0.1, 0.4, 0.7), holes=notch, shadow=None),
        Part(head, RUSSET5, depth=8, cuts=(-0.25, 0.1, 0.4, 0.72), regions=[(muzzle, CREAM4)], shadow=(0, 2)),
        Part(tuft, EMBER, depth=3, cuts=(-0.3, 0.2, 0.6), outline=(150, 70, 14), shadow=None),
    ]
    img = render(parts)
    img = cleanup_clusters(img)
    # inner ears
    for (x, y, r) in ((35.4, 40.6, 2.4), (56.3, 40.4, 2.6)):
        m = to_mask(smooth_poly_mask([E(x, y, r, r)]), 0.45, False) & parts[6].mask
        paint(img, m - outline_of(parts[6].mask), CREAM4[1])
    # face
    eye(img, 40.5, 50, 2.0, 2.6)
    eye(img, 49.5, 49.2, 2.3, 2.9)
    paint(img, to_mask(smooth_poly_mask([E(28.8, 54.2, 1.6, 1.2)]), 0.4, False), (38, 20, 18))
    paint(img, thin_line_mask([(31, 57.6), (33.5, 58.4), (36, 58)], 0.8), (112, 56, 34))
    # cheek blush of warmth
    paint(img, {(52, 54), (53, 54)}, RUSSET5[4])
    # toes on paws and feet
    toe_lines(img, 41, 72, 4.0); toe_lines(img, 52.5, 72.5, 4.0)
    toe_lines(img, 55, 89, 6.0, up=True, n=3)
    # the stone glows where the paws warm it; the tuft glows like a candle behind paper
    paint(img, {(46, 69), (47, 69)}, EMBER[1])
    F.halo(img, parts[-1].mask, EMBER[2], 150)
    paint(img, to_mask(smooth_poly_mask([E(66.6, 46, 1.8, 2.4)]), 0.4, False), EMBER[3])
    img = selout(img)
    return F.drop_to_ground(img, 90) if hasattr(F, "drop_to_ground") else img


if __name__ == "__main__":
    import cinder
    out = Image.new("RGBA", (96 * 2 * 4 + 30, 96 * 4 + 10), (72, 80, 104, 255))
    out.alpha_composite(cinder.wickit().resize((384, 384), Image.NEAREST), (10, 5))
    out.alpha_composite(wickit().resize((384, 384), Image.NEAREST), (20 + 384, 5))
    out.save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/w2.png")
