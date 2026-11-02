"""Alberica's line, refined: Lutling (lute) -> Hauntello (cello) -> Harp final.
Sizes grow through the line (lute ~60%, cello ~80%, harp ~100% of the frame)."""
import math
from PIL import Image, ImageDraw
from clean import *
from hires import bezier, spiral
from lutling2 import lute_body, fin
from orchestra import cello_body
from silhouettes import curl
from story_line import pinched

# --- palettes (4 tones dark->light) -------------------------------------------------
HONEY = [(128, 66, 30), (196, 122, 58), (230, 164, 86), (250, 206, 134)];  HONEY_O = (92, 44, 18)
SPRUCE = [(214, 174, 112), (234, 202, 146), (248, 224, 178), (255, 242, 210)]; SPRUCE_O = (166, 118, 62)
WINE = [(70, 18, 34), (124, 42, 56), (166, 70, 78), (204, 116, 108)];          WINE_O = (44, 8, 20)
LACQ = [(28, 18, 38), (48, 32, 62), (76, 54, 96), (120, 94, 144)];            LACQ_O = (10, 4, 16)
EBONY = [(30, 22, 20), (50, 38, 32), (74, 58, 48), (104, 84, 70)];             EBONY_O = (12, 6, 6)
GOLD = [(164, 114, 42), (210, 160, 64), (238, 202, 108), (255, 238, 174)];     GOLD_O = (98, 60, 18)
SPIRIT = [(88, 40, 150), (146, 90, 214), (188, 140, 242), (230, 204, 255)];  SPIRIT_O = (56, 20, 100)
GLOW, CORE = (206, 150, 255), (255, 238, 255)
CREAM = (246, 236, 214)


def finish(img, ground):
    img = selout(img)
    img = limit_palette(img, 40)
    return drop_to_ground(img, ground)


class Stage:
    """Draw in the 96px design space, then scale about (48, ground)."""
    def __init__(self, k, ground=92):
        self.k, self.g = k, ground

    def p(self, pts):
        return [(48 + (x - 48) * self.k, self.g + (y - self.g) * self.k) for x, y in pts]

    def r(self, v):
        return v * self.k


def halo(img, mask, colour, strength=110):
    """Soft one-pixel glow around a glowing shape."""
    px = img.load()
    ring = {(x + dx, y + dy) for (x, y) in mask for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))} - set(mask)
    for (x, y) in ring:
        if 0 <= x < N and 0 <= y < N:
            r, g, b, a = px[x, y]
            if a == 0:
                px[x, y] = colour + (strength,)
            else:
                t = strength / 255
                px[x, y] = (int(r + (colour[0] - r) * t), int(g + (colour[1] - g) * t), int(b + (colour[2] - b) * t), a)


def glow_line(img, pts, width=1.2):
    m = thin_line_mask(pts, width)
    halo(img, m, GLOW, 90)
    paint(img, m, GLOW)
    return m


def rosette(img, S, cx, cy, r, petal=GOLD, centre_glow=True):
    pts = S.p([(cx, cy)])[0]; r = S.r(r)
    petals = [ellipse_pts(pts[0] + math.cos(math.radians(a)) * r * 0.56, pts[1] + math.sin(math.radians(a)) * r * 0.56, r * 0.42, r * 0.42, 16)
              for a in range(0, 360, 45)]
    pm = to_mask(smooth_poly_mask(petals), 0.45, False)
    paint(img, outline_of(pm), GOLD[0])
    paint(img, pm - outline_of(pm), petal[2])
    paint(img, {(x, y) for (x, y) in pm if (x - pts[0]) + (y - pts[1]) < -r * 0.3} - outline_of(pm), petal[3])
    cm = to_mask(smooth_poly_mask([ellipse_pts(pts[0], pts[1], r * 0.45, r * 0.45, 16)]), 0.4, False)
    if centre_glow:
        halo(img, cm, GLOW, 140)
        paint(img, cm, GLOW)
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(pts[0], pts[1], r * 0.2, r * 0.2, 12)]), 0.3, False), CORE)
    else:
        paint(img, cm, (40, 24, 20))


def happy_eyes(img, S, cx, y, gap, w, colour, width=1.4):
    for ex in (cx - gap - w, cx + gap):
        c = S.p([(ex + w / 2, y)])[0]
        paint(img, line_mask(ellipse_pts(c[0], c[1] + S.r(1.2), S.r(w / 2), S.r(w * 0.42), 20, 200, 340), width), colour)


def grin(img, S, cx, y, w, h, dark, tongue=None, teeth=None, outline=None):
    c = S.p([(cx, y)])[0]
    m = to_mask(smooth_poly_mask([ellipse_pts(c[0], c[1], S.r(w), S.r(h), 32, 0, 180)]), 0.45, False)
    paint(img, m, dark)
    if tongue:
        paint(img, {(x, yy) for (x, yy) in m if yy >= c[1] + S.r(h) * 0.55}, tongue)
    if teeth:
        paint(img, {(x, yy) for (x, yy) in m if yy <= c[1] + 0.5 and (x % 2 == 0)}, teeth)
    if outline:
        paint(img, outline_of(m), outline)


def eye(img, cx, cy, w, h, iris, lid=0.0, look=(0.3, 0.1), sclera=(250, 246, 255), lid_colour=None, outline=(30, 10, 40)):
    """A Gen-5-style eye: outline, white, iris, pupil, highlight; `lid` (0..1) closes the top for attitude."""
    m = to_mask(smooth_poly_mask([ellipse_pts(cx, cy, w, h, 24)]), 0.42, False)
    if lid > 0:
        cut = cy - h + 2 * h * lid
        m = {(x, y) for (x, y) in m if y >= cut}
    paint(img, m, sclera)
    ix, iy = cx + look[0] * w * 0.6, cy + look[1] * h * 0.4 + h * lid * 0.4
    im = to_mask(smooth_poly_mask([ellipse_pts(ix, iy, w * 0.62, h * 0.72, 18)]), 0.4, False) & m
    paint(img, im, iris)
    pm = to_mask(smooth_poly_mask([ellipse_pts(ix + 0.3, iy + 0.3, w * 0.3, h * 0.38, 12)]), 0.4, False) & m
    paint(img, pm, outline)
    paint(img, outline_of(m), outline)
    if lid > 0:
        top = min(y for (_, y) in m)
        paint(img, {(x, y) for (x, y) in m if y == top}, lid_colour or outline)
    hx, hy = int(round(ix - w * 0.25)), int(round(iy - h * 0.35))
    if (hx, hy) in m:
        paint(img, {(hx, hy)}, (255, 255, 255))


def smirk(img, pts, colour, fang_at=None, fang=(255, 250, 255)):
    paint(img, line_mask(pts, 1.1), colour)
    if fang_at:
        x, y = fang_at
        paint(img, {(int(x), int(y) + 1), (int(x), int(y) + 2)}, fang)


def sparkle(img, x, y, c=(255, 214, 246)):
    paint(img, {(x, y), (x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)}, c)
    paint(img, {(x, y)}, (255, 255, 255))


# =================================================================================
def lutling():
    S = Stage(0.68, 90)
    cx = 48
    body = pinched(lute_body(cx, 38, 40, 48), cx, 62, 0.12)
    board = pinched(lute_body(cx, 38, 40, 48, inset=2.6), cx, 62, 0.12)
    bow = [(68, 86), (82, 56)]
    layers = [
        Layer([ribbon(S.p(bow), 0.75, 0.75)], GOLD, depth=1, outline=GOLD_O, clean=False, threshold=0.38),
        Layer([S.p(fin(cx, 66, 18, -1)), S.p(fin(cx, 66, 18, 1))], HONEY, depth=3, outline=HONEY_O),
        Layer([S.p(body)], HONEY, depth=6, outline=HONEY_O),
        Layer([S.p(board)], SPRUCE, depth=9, outline=SPRUCE_O, cuts=(-0.25, 0.25, 0.8)),
        Layer([ribbon(S.p([(cx, 41), (cx, 27)]), S.r(2.8), S.r(2.4)), ribbon(S.p([(cx, 28.5), (cx + 4, 22)]), S.r(2.8), S.r(2.6)),
               [(x, y) for x, y in S.p(curl(cx + 7, 19, 4.6, 200))]], EBONY, depth=2, outline=EBONY_O),
    ]
    img = cleanup_clusters(compose(layers))
    rim_light(img, layers[3].mask, SPRUCE[3])
    # fin ribs (manta), gold pegs on the curl, frets
    for side in (-1, 1):
        for k in (0.45, 0.75):
            a = S.p([(cx + side * (15 + 18 * k * 0.6), 60 - 4 * k), (cx + side * (15 + 18 * k), 64 - 8 * k)])
            paint(img, thin_line_mask(a, 0.8), HONEY[0])
    for (px_, py_) in ((cx + 3, 23), (cx + 9.5, 15.5), (cx + 11.5, 21)):
        c = S.p([(px_, py_)])[0]
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(c[0], c[1], 1.3, 1.3, 12)]), 0.3, False), GOLD[2])
    # bridge, strings (over the board, leaving the soundhole clear), the rosette as a ring
    b0, b1 = S.p([(cx - 7, 81.5), (cx + 7, 81.5)])
    paint(img, line_mask([b0, b1], 1.6), (86, 46, 22))
    for xb, xt in ((-3.0, -1.6), (3.0, 1.6)):
        paint(img, thin_line_mask(S.p([(cx + xb, 81), (cx + xb * 0.9, 74)]), 0.7), CREAM)
        paint(img, thin_line_mask(S.p([(cx + xb * 0.8, 53), (cx + xt, 42)]), 0.7), CREAM)
    rc = S.p([(cx, 63.5)])[0]
    R = S.r(10.5)
    petals = [ellipse_pts(rc[0] + math.cos(math.radians(a_)) * R * 0.86, rc[1] + math.sin(math.radians(a_)) * R * 0.86, R * 0.3, R * 0.3, 14)
              for a_ in range(0, 360, 30)]
    ring = to_mask(smooth_poly_mask(petals), 0.45, False)
    paint(img, ring, GOLD[2]); paint(img, outline_of(ring), GOLD[0])
    hole = to_mask(smooth_poly_mask([ellipse_pts(rc[0], rc[1], R * 0.78, R * 0.78, 28)]), 0.45, False)
    paint(img, hole, (34, 12, 44))
    # the spirit inside: a soft violet glow at the bottom of the hole, and its eyes looking out
    paint(img, {(x, y) for (x, y) in hole if y > rc[1] + R * 0.25}, SPIRIT[0])
    eye(img, rc[0] - 2.6, rc[1] - 0.4, 1.9, 2.4, (190, 130, 250), look=(0.4, 0.2), sclera=(244, 232, 255), outline=(20, 6, 30))
    eye(img, rc[0] + 2.6, rc[1] - 0.4, 1.9, 2.4, (190, 130, 250), look=(0.4, 0.2), sclera=(244, 232, 255), outline=(20, 6, 30))
    halo(img, hole, GLOW, 50)
    # the f-shaped crack (the cello to come)
    glow_line(img, S.p([(cx + 12, 66), (cx + 13.5, 69.5), (cx + 12, 73), (cx + 13.5, 76.5)]), 1.0)
    sparkle(img, *map(int, S.p([(16, 30)])[0])); sparkle(img, *map(int, S.p([(80, 36)])[0]), (226, 196, 255))
    return finish(img, 90)


# =================================================================================
def hauntello():
    S = Stage(0.86, 92)
    cx, top, h = 44, 34, 50
    body = cello_body(cx, top, h, 14.5, 18.5, 10)
    inner = cello_body(cx, top + 1.8, h - 3.6, 12.8, 16.8, 8.4)
    neck = [(cx, top + 2), (cx, top - 10)]
    bow = [(cx - 22, top + 48), (cx - 4, top - 6)]
    tendril = bezier((cx - 9, top + 30), (cx - 16, top + 30), (cx - 18, top + 24), (cx - 14, top + 18), 14)
    bulge = ellipse_pts(cx + 15, top + 17, 4.2, 6.8, 30)
    layers = [
        Layer([ribbon(S.p(bow), 0.8, 0.8)], [(96, 56, 26), (130, 80, 38), (164, 108, 56), (196, 140, 80)], depth=1, outline=(50, 26, 10), clean=False, threshold=0.38),
        Layer([S.p(body)], WINE, depth=11, outline=WINE_O, cuts=(-0.1, 0.3, 0.72)),
        Layer([S.p(bulge)], SPIRIT, depth=4, outline=SPIRIT_O),
        Layer([ribbon(S.p(tendril), S.r(1.4), S.r(1.0))], SPIRIT, depth=1, outline=SPIRIT_O, clean=False, threshold=0.4),
        Layer([ribbon(S.p(neck), S.r(2.5), S.r(2.3)), [(x, y) for x, y in S.p(curl(cx + 3.6, top - 14, 4.6, 200))]], EBONY, depth=2, outline=EBONY_O),
    ]
    img = cleanup_clusters(compose(layers))
    rim_light(img, layers[1].mask, WINE[3])
    px = img.load()
    bm, im = layers[1].mask, to_mask(smooth_poly_mask([S.p(inner)]))
    for (x, y) in bm:           # purfling
        if (x, y) not in im and all((x + dx, y + dy) in bm for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
            px[x, y] = (54, 14, 26, 255)
    # varnish sheen: a light streak down the upper-left bout
    paint(img, thin_line_mask(S.p(bezier((cx - 9, top + 4), (cx - 12, top + 10), (cx - 12, top + 16), (cx - 9, top + 20), 12)), 0.9), WINE[3])
    # fingerboard, strings, bridge, tailpiece
    fb = S.p([(cx - 2.2, top - 1), (cx + 2.2, top - 1), (cx + 2.8, top + 23), (cx - 2.8, top + 23)])
    paint(img, to_mask(smooth_poly_mask([fb]), 0.5, False), EBONY[1])
    for k in (-1, 1):
        paint(img, thin_line_mask(S.p([(cx + k * 1.6, top + 40), (cx + k * 1.2, top - 8)]), 0.6), (214, 204, 186))
    paint(img, line_mask(S.p([(cx - 5, top + 40), (cx + 5, top + 40)]), 1.4), GOLD[2])
    tp = S.p([(cx - 2.6, top + 42), (cx + 2.6, top + 42), (cx + 1.6, top + 48), (cx - 1.6, top + 48)])
    paint(img, to_mask(smooth_poly_mask([tp]), 0.5, False), EBONY[1])
    for (pxx, pyy) in ((cx + 5.5, top - 17), (cx - 1, top - 15), (cx + 6.5, top - 11)):
        c = S.p([(pxx, pyy)])[0]
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(c[0], c[1], 1.4, 1.4, 12)]), 0.3, False), GOLD[2])
    # f-holes and a split seam leaking light
    for side in (-1, 1):
        glow_line(img, S.p([(cx + side * 9, top + 14), (cx + side * 10.5, top + 18), (cx + side * 9, top + 22), (cx + side * 10.5, top + 26)]), 1.3)
    glow_line(img, S.p([(cx + 12, top + 6), (cx + 14.5, top + 10)]), 1.2)
    halo(img, layers[2].mask, GLOW, 120)
    # the rosette has burst: a jagged hole in the lower bout, the spirit's face pushing out of it
    hc = S.p([(cx, top + 34)])[0]
    jag = []
    for k in range(18):
        a_ = math.radians(k * 20)
        rr = S.r(9.0 + (2.2 if k % 2 else 0))
        jag.append((hc[0] + math.cos(a_) * rr, hc[1] + math.sin(a_) * rr * 0.85))
    hole = to_mask(smooth_poly_mask([jag]), 0.5, False)
    paint(img, hole, (40, 12, 50))
    paint(img, outline_of(hole), (176, 130, 92))                                     # raw splintered wood
    # rosette fragments clinging to the rim
    for a_ in (200, 250, 330, 20):
        r_ = S.r(10.5)
        fx, fy = hc[0] + math.cos(math.radians(a_)) * r_, hc[1] + math.sin(math.radians(a_)) * r_ * 0.85
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(fx, fy, 1.4, 1.4, 12)]), 0.35, False), GOLD[2])
    face = ellipse_pts(hc[0] + 0.5, hc[1] + 1.0, S.r(8.4), S.r(7.2), 40)
    spill = [ellipse_pts(hc[0] - S.r(7), hc[1] + S.r(7), S.r(3.0), S.r(2.2), 16), ellipse_pts(hc[0] + S.r(8), hc[1] + S.r(6), S.r(2.6), S.r(2.0), 16)]
    over = compose([Layer([face] + spill, SPIRIT, depth=6, outline=SPIRIT_O, cuts=(-0.1, 0.35, 0.72))])
    halo(over, layers[2].mask, GLOW, 0)
    img.alpha_composite(over)
    halo(img, to_mask(smooth_poly_mask([face]), 0.5, False), GLOW, 100)
    # sly, half-lidded eyes and a crooked fanged grin
    eye(img, hc[0] - 3.6, hc[1] - 1.0, 2.4, 2.6, (255, 206, 96), lid=0.35, look=(0.5, 0.2), outline=(40, 10, 50))
    eye(img, hc[0] + 3.4, hc[1] - 1.4, 2.4, 2.6, (255, 206, 96), lid=0.25, look=(0.5, 0.2), outline=(40, 10, 50))
    smirk(img, [(hc[0] - 3.5, hc[1] + 3.2), (hc[0] - 0.5, hc[1] + 4.6), (hc[0] + 2.5, hc[1] + 4.2), (hc[0] + 4.5, hc[1] + 2.8)], (40, 10, 50),
          fang_at=(hc[0] + 1.5, hc[1] + 4.0))
    # the slipped strings arcing out: the harp's triangle to come
    for k, off in enumerate((0.0, 4.0)):
        arc = bezier((cx + 6, top - 12), (cx + 34 + off, top - 6 + off), (cx + 38 + off, top + 34), (cx + 8, top + h + 4), 44)
        paint(img, thin_line_mask(S.p(arc), 0.6), CREAM if k == 0 else (214, 204, 186))
    end = S.p([(cx + 11, top + h + 1)])[0]
    paint(img, thin_line_mask(spiral(end[0], end[1], 2.4, 0.9, 180, shrink=0.6, n=20), 0.9), CREAM)
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(end[0], end[1] - 2.6, 1.6, 1.6, 12)]), 0.3, False), GOLD[2])
    sparkle(img, *map(int, S.p([(14, 26)])[0])); sparkle(img, *map(int, S.p([(86, 70)])[0]), (226, 196, 255))
    return finish(img, 92)


# =================================================================================
def harp():
    S = Stage(1.0, 94)
    pillar = bezier((40, 90), (28, 72), (24, 46), (28, 26), 24)
    neck_path = bezier((28, 24), (44, 40), (60, 6), (80, 14), 34)
    spine_out = bezier((80, 14), (84, 40), (76, 66), (60, 90), 24)
    spine_in = bezier((50, 88), (64, 66), (72, 40), (74, 16), 24)
    box = spine_out + [(56, 94), (48, 93)] + spine_in
    foot = bezier((36, 91), (44, 95), (54, 95), (60, 91), 12)
    lock1 = bezier((18, 22), (0, 26), (-2, 46), (8, 58), 30)
    lock2 = bezier((20, 28), (6, 42), (12, 64), (2, 80), 30)
    head = ellipse_pts(26, 20, 10.5, 9.5, 48)
    layers = [
        Layer([ribbon(lock2, 3.4, 1.0)], SPIRIT, depth=2, outline=SPIRIT_O),
        Layer([box], LACQ, depth=6, outline=LACQ_O),
        Layer([ribbon(pillar, 3.1, 2.7), ribbon(neck_path, 2.9, 3.1), ribbon(foot, 2.4, 2.6)], LACQ, depth=3, outline=LACQ_O),
        Layer([curl(84, 12, 4.0, 270, w=2.6)], GOLD, depth=2, outline=GOLD_O),
        Layer([ribbon(lock1, 4.3, 1.3)], SPIRIT, depth=3, outline=SPIRIT_O),
        Layer([head], SPIRIT, depth=8, outline=SPIRIT_O, cuts=(-0.15, 0.3, 0.7)),
        Layer([curl(30, 9.5, 5.4, 200, w=3.0)], EBONY, depth=2, outline=EBONY_O),
    ]
    img = cleanup_clusters(compose(layers))
    rim_light(img, layers[5].mask, SPIRIT[3])
    rim_light(img, layers[4].mask, SPIRIT[3])
    # gold trim inlaid along the pillar and neck
    paint(img, thin_line_mask(pillar[5:21], 0.6), GOLD[1])
    paint(img, thin_line_mask(neck_path[8:30], 0.6), GOLD[1])
    # strings: clean, parallel verticals from the neck down to the soundbox (two snapped - they became the hair)
    def y_on(path, x):
        best = min(path, key=lambda q: abs(q[0] - x))
        return best[1]
    px_ = img.load()
    for i, x in enumerate(range(43, 74, 3)):
        y0 = y_on(neck_path, x) + 3
        y1 = y0 + 1
        while y1 < N - 1 and px_[x, y1 + 1][3] < 200:   # run down until the string meets the frame
            y1 += 1
        if y1 - y0 < 4:
            continue
        col = GOLD[2] if i % 3 == 0 else (214, 200, 230)
        if i in (3, 7):                              # snapped: a short curled stub hanging from the neck
            paint(img, thin_line_mask([(x, y0), (x, y0 + 5), (x - 1, y0 + 7)], 0.6), col)
            continue
        paint(img, {(x, y) for y in range(int(y0), int(y1) + 1)}, col)
    # the soundbox: rosette glowing from inside and cracks of light
    rosette(img, S, 70, 60, 6.0)
    glow_line(img, [(79, 28), (75, 38), (79, 46)], 1.2)
    glow_line(img, [(67, 72), (63, 79), (66, 85)], 1.2)
    glow_line(img, [(28, 30), (30, 36), (27, 41)], 1.2)          # where the spirit burst out of the pillar
    # gold pegs on the crown curl (the lute's old pegbox)
    for (gx, gy) in ((25, 9), (35, 4), (36, 12)):
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(gx, gy, 1.4, 1.4, 12)]), 0.3, False), GOLD[2])
    # the spirit glows: halo, lighter core, gold string-tips on the hair
    for L in (layers[0], layers[4], layers[5]):
        halo(img, L.mask, GLOW, 90)
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(23, 17, 4.0, 3.0, 20)]), 0.4, False), SPIRIT[3])
    for (x, y) in (lock1[-1], lock2[-1]):
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(x, y, 2.0, 2.0, 14)]), 0.3, False), GOLD[2])
        paint(img, {(int(x) - 1, int(y) - 1)}, GOLD[3])
    # the painted face, now glowing on the spirit itself
    eye(img, 21.8, 17.6, 2.9, 3.3, (255, 140, 210), lid=0.2, look=(0.4, 0.2), outline=(40, 10, 60))
    eye(img, 30.4, 17.0, 2.9, 3.3, (255, 140, 210), lid=0.12, look=(0.4, 0.2), outline=(40, 10, 60))
    grin(img, S, 26.4, 22.4, 5.6, 4.2, (40, 10, 60), teeth=(255, 250, 255))
    paint(img, {(22, 23), (22, 24), (31, 23), (31, 24)}, (255, 250, 255))            # two little fangs
    for (x, y, c) in ((8, 10, None), (90, 30, (226, 196, 255)), (12, 88, None), (88, 86, (226, 196, 255))):
        sparkle(img, x, y, c or (255, 214, 246))
    return finish(img, 94)


if __name__ == "__main__":
    s = Image.new("RGBA", (300, 100), (72, 80, 104, 255))
    for i, fn in enumerate((lutling, hauntello, harp)):
        s.alpha_composite(fn(), (i * 100 + 2, 2))
    s.resize((900, 300), Image.NEAREST).save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/final1.png")
