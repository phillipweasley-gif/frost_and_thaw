"""Back views of Alberica's line, as the player sees their own Pokemon: from behind, turned toward
the opponent (up and to the right). The same instrument, its back is real-instrument detail:
  Lutling   - a lute's bowl back of alternating wooden staves; the spirit's light leaks through a seam
  Hauntello - a cello's two-piece flamed-maple back, split by a glowing crack; the spirit bulges at a seam
  Chorumbra - a harp's soundbox back with its three oval sound-ports, the spirit's head seen from behind
The geometry is the front view mirrored (we see it from the other side)."""
import math
from PIL import Image
from clean import *
from hires import bezier, spiral
from lutling2 import lute_body, fin
from orchestra import cello_body
from silhouettes import curl
from story_line import pinched
import final_line as F

HONEY, SPRUCE, WINE, LACQ, EBONY, GOLD, SPIRIT = F.HONEY, F.SPRUCE, F.WINE, F.LACQ, F.EBONY, F.GOLD, F.SPIRIT
GLOW, CORE = F.GLOW, F.CORE


def M(pts):
    """Mirror left-right: seen from behind."""
    return [(96 - x, y) for x, y in pts]


def staves(img, mask, cx_of, halfw_of, n, tones, seam):
    """Paint a bowl back of n vertical staves, alternating two woods, shaded round."""
    px = img.load()
    for (x, y) in mask:
        hw = halfw_of(y)
        if hw <= 0.5:
            continue
        u = max(-0.999, min(0.999, (x - cx_of(y)) / hw))
        a = (math.asin(u) / (math.pi / 2) + 1) / 2          # 0..1 across the bowl
        i = min(n - 1, int(a * n))
        wood = tones[i % 2]
        shade = 1.0 - 0.55 * abs(u) ** 1.6 + (0.18 if u < -0.15 else 0) - 0.06 * ((y - 50) / 40)
        k = max(0, min(len(wood) - 1, int(round(shade * (len(wood) - 1)))))
        c = wood[k]
        if abs(a * n - round(a * n)) < 0.5 / max(1.0, hw / 3.5) and 0 < round(a * n) < n:
            c = seam
        px[x, y] = c + (255,)


def lutling_back():
    S = F.Stage(0.68, 90)
    cx = 48
    body = pinched(lute_body(cx, 38, 40, 48), cx, 62, 0.12)
    bow = [(96 - 68, 86), (96 - 82, 56)]
    layers = [
        Layer([ribbon(S.p(bow), 0.75, 0.75)], GOLD, depth=1, outline=F.GOLD_O, clean=False, threshold=0.38),
        Layer([S.p(M(fin(cx, 66, 18, -1))), S.p(M(fin(cx, 66, 18, 1)))], [HONEY[0], HONEY[1], HONEY[1], HONEY[2]], depth=3, outline=F.HONEY_O),
        Layer([S.p(body)], HONEY, depth=6, outline=F.HONEY_O),
        Layer([ribbon(S.p([(cx, 41), (cx, 25)]), S.r(2.8), S.r(2.4)), ribbon(S.p([(cx, 26.5), (cx - 4, 20)]), S.r(2.8), S.r(2.6)),
               [(x, y) for x, y in S.p(M(curl(cx + 7, 17, 4.6, 200)))]], EBONY, depth=2, outline=F.EBONY_O),
    ]
    img = cleanup_clusters(compose(layers))
    # the bowl: seven staves of honey and pale spruce, with dark seams
    bm = layers[2].mask
    rows = {}
    for (x, y) in bm:
        rows.setdefault(y, []).append(x)
    cxo = {y: (min(xs) + max(xs)) / 2 for y, xs in rows.items()}
    hwo = {y: (max(xs) - min(xs)) / 2 + 0.5 for y, xs in rows.items()}
    inner = bm - outline_of(bm)
    staves(img, inner, lambda y: cxo[y], lambda y: hwo[y], 7, [HONEY, [(112, 54, 26), (164, 92, 44), (196, 124, 62), (226, 164, 98)]], (92, 44, 18))
    # the cap-strip where the neck joins the bowl, and a little end-button at the bottom
    top = min(rows); bot = max(rows)
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(cxo[top + 2], top + 2.5, 3.2, 1.6, 16)]), 0.4, False), EBONY[1])
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(cxo[bot - 2], bot - 1.5, 1.6, 1.3, 12)]), 0.4, False), GOLD[2])
    # fin ribs (the manta underside)
    for side in (-1, 1):
        for k in (0.45, 0.75):
            a = S.p(M([(cx + side * (15 + 18 * k * 0.6), 60 - 4 * k), (cx + side * (15 + 18 * k), 64 - 8 * k)]))
            paint(img, thin_line_mask(a, 0.8), HONEY[0])
    # gold pegs on the curl
    for (px_, py_) in ((cx - 3, 21), (cx - 9.5, 13.5), (cx - 11.5, 19)):
        c = S.p([(px_, py_)])[0]
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(c[0], c[1], 1.3, 1.3, 12)]), 0.3, False), GOLD[2])
    # the spirit's light leaking out of one seam low on the bowl (the cracks to come)
    seam_x = lambda y: cxo[y] + hwo[y] * math.sin((2 / 7 - 0.5) * math.pi) * 0.98
    ys = [y for y in sorted(rows) if top + (bot - top) * 0.45 < y < bot - 3]
    pts = [(seam_x(y), y) for y in ys]
    if len(pts) > 2:
        F.glow_line(img, pts, 1.0)
    F.sparkle(img, *map(int, S.p([(80, 30)])[0])); F.sparkle(img, *map(int, S.p([(16, 36)])[0]), (226, 196, 255))
    return F.finish(img, 90)


def hauntello_back():
    S = F.Stage(0.86, 92)
    cx, top, h = 52, 34, 50                       # mirrored about the middle of the frame
    body = cello_body(cx, top, h, 14.5, 18.5, 10)
    inner = cello_body(cx, top + 1.8, h - 3.6, 12.8, 16.8, 8.4)
    neck = [(cx, top + 2), (cx, top - 10)]
    bow = [(cx + 22, top + 48), (cx + 4, top - 6)]
    bulge = ellipse_pts(cx - 15, top + 17, 4.2, 6.8, 30)
    tendril = bezier((cx + 9, top + 30), (cx + 16, top + 30), (cx + 18, top + 24), (cx + 14, top + 18), 14)
    layers = [
        Layer([ribbon(S.p(bow), 0.8, 0.8)], [(96, 56, 26), (130, 80, 38), (164, 108, 56), (196, 140, 80)], depth=1, outline=(50, 26, 10), clean=False, threshold=0.38),
        Layer([S.p(bulge)], SPIRIT, depth=4, outline=F.SPIRIT_O),
        Layer([S.p(body)], WINE, depth=11, outline=F.WINE_O, cuts=(-0.1, 0.3, 0.72)),
        Layer([ribbon(S.p(tendril), S.r(1.4), S.r(1.0))], SPIRIT, depth=1, outline=F.SPIRIT_O, clean=False, threshold=0.4),
        Layer([ribbon(S.p(neck), S.r(2.6), S.r(2.4)), [(x, y) for x, y in S.p(M(curl(96 - cx + 3.6, top - 14, 4.6, 200)))]], WINE, depth=2, outline=F.WINE_O),
    ]
    img = cleanup_clusters(compose(layers))
    F.rim_light(img, layers[2].mask, WINE[3])
    px = img.load()
    bm, im = layers[2].mask, to_mask(smooth_poly_mask([S.p(inner)]))
    for (x, y) in bm:                             # purfling round the edge
        if (x, y) not in im and all((x + dx, y + dy) in bm for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
            px[x, y] = (54, 14, 26, 255)
    # flamed maple: soft diagonal stripes across the back plate
    for (x, y) in im:
        if px[x, y][:3] in (WINE[1], WINE[2]) and ((x * 3 + y * 2) // 8) % 3 == 0:
            px[x, y] = (WINE[2] if px[x, y][:3] == WINE[1] else WINE[3]) + (255,)
    # the centre joint of the two-piece back, and the button where the neck meets it
    jc = S.p([(cx, top + 3), (cx, top + h - 2)])
    paint(img, {(int(round(jc[0][0])), y) for y in range(int(jc[0][1]) + 2, int(jc[1][1]))} & im, (98, 30, 44))
    b = S.p([(cx, top + 1.5)])[0]
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(b[0], b[1], 2.4, 1.6, 16)]), 0.4, False), WINE[3])
    # gold pegs on the scroll
    for (pxx, pyy) in ((cx - 5.5, top - 17), (cx + 1, top - 15), (cx - 6.5, top - 11)):
        c = S.p([(pxx, pyy)])[0]
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(c[0], c[1], 1.4, 1.4, 12)]), 0.3, False), GOLD[2])
    # the back plate has split: a jagged glowing crack down the lower bout
    crack = S.p([(cx + 4, top + 22), (cx + 7, top + 27), (cx + 4, top + 31), (cx + 8, top + 36), (cx + 5, top + 41), (cx + 8, top + 45)])
    F.glow_line(img, crack, 1.3)
    F.glow_line(img, S.p([(cx - 12, top + 6), (cx - 14.5, top + 10)]), 1.2)
    F.halo(img, layers[1].mask, GLOW, 120)
    # the slipped strings arcing out on this side too
    for k, off in enumerate((0.0, 4.0)):
        arc = bezier((cx - 6, top - 12), (cx - 34 - off, top - 6 + off), (cx - 38 - off, top + 34), (cx - 8, top + h + 4), 44)
        paint(img, thin_line_mask(S.p(arc), 0.6), F.CREAM if k == 0 else (214, 204, 186))
    end = S.p([(cx - 11, top + h + 1)])[0]
    paint(img, thin_line_mask(spiral(end[0], end[1], 2.4, 0.9, 0, shrink=0.6, n=20), 0.9), F.CREAM)
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(end[0], end[1] - 2.6, 1.6, 1.6, 12)]), 0.3, False), GOLD[2])
    F.sparkle(img, *map(int, S.p([(82, 26)])[0])); F.sparkle(img, *map(int, S.p([(10, 70)])[0]), (226, 196, 255))
    return F.finish(img, 92)


def harp_back():
    S = F.Stage(1.0, 94)
    pillar = M(bezier((40, 90), (28, 72), (24, 46), (28, 26), 24))
    neck_path = M(bezier((28, 24), (44, 40), (60, 6), (80, 14), 34))
    spine_out = M(bezier((80, 14), (84, 40), (76, 66), (60, 90), 24))
    spine_in = M(bezier((50, 88), (64, 66), (72, 40), (74, 16), 24))
    box = spine_out + [(96 - 56, 94), (96 - 48, 93)] + spine_in
    foot = M(bezier((36, 91), (44, 95), (54, 95), (60, 91), 12))
    lock1 = M(bezier((18, 22), (0, 26), (-2, 46), (8, 58), 30))
    lock2 = M(bezier((20, 28), (6, 42), (12, 64), (2, 80), 30))
    head = ellipse_pts(96 - 26, 20, 10.5, 9.5, 48)
    layers = [
        Layer([box], LACQ, depth=6, outline=F.LACQ_O),
        Layer([ribbon(pillar, 3.1, 2.7), ribbon(neck_path, 2.9, 3.1), ribbon(foot, 2.4, 2.6)], LACQ, depth=3, outline=F.LACQ_O),
        Layer([M(curl(84, 12, 4.0, 270, w=2.6))], GOLD, depth=2, outline=F.GOLD_O),
        Layer([head], SPIRIT, depth=8, outline=F.SPIRIT_O, cuts=(-0.15, 0.3, 0.7)),
        Layer([ribbon(lock2, 3.4, 1.0)], SPIRIT, depth=2, outline=F.SPIRIT_O),
        Layer([ribbon(lock1, 4.3, 1.3)], SPIRIT, depth=3, outline=F.SPIRIT_O),
        Layer([M(curl(30, 9.5, 5.4, 200, w=3.0))], EBONY, depth=2, outline=F.EBONY_O),
    ]
    img = cleanup_clusters(compose(layers))
    F.rim_light(img, layers[3].mask, SPIRIT[3])
    F.rim_light(img, layers[5].mask, SPIRIT[3])
    # strings seen from behind: the same verticals, between neck and soundbox
    px_ = img.load()
    def y_on(path, x):
        return min(path, key=lambda q: abs(q[0] - x))[1]
    for i, x in enumerate(range(96 - 43, 96 - 74, -3)):
        y0 = y_on(neck_path, x) + 3
        y1 = y0 + 1
        while y1 < N - 1 and px_[x, y1 + 1][3] < 200:
            y1 += 1
        col = GOLD[2] if i % 3 == 0 else (214, 200, 230)
        if i in (3, 7):
            paint(img, thin_line_mask([(x, y0), (x, y0 + 5), (x + 1, y0 + 7)], 0.6), col)
            continue
        paint(img, {(x, y) for y in range(int(y0), int(y1) + 1)}, col)
    # the soundbox back: three oval sound-ports, glowing with the spirit inside, and a centre seam
    for t in (0.3, 0.5, 0.7):
        a = spine_out[int(t * (len(spine_out) - 1))]; b = spine_in[int((1 - t) * (len(spine_in) - 1))]
        ox, oy = (a[0] * 0.55 + b[0] * 0.45), (a[1] * 0.55 + b[1] * 0.45)
        port = to_mask(smooth_poly_mask([ellipse_pts(ox, oy, 2.0, 3.4, 20)]), 0.4, False)
        F.halo(img, port, GLOW, 120)
        paint(img, port, GLOW)
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(ox, oy, 0.9, 1.8, 12)]), 0.3, False), CORE)
    # gold trim along the pillar and the neck
    paint(img, thin_line_mask(pillar[5:21], 0.6), GOLD[1])
    paint(img, thin_line_mask(neck_path[8:30], 0.6), GOLD[1])
    # the back of the spirit's head: no face, just its crown, a glow, and the hair hanging down
    for (gx, gy) in ((96 - 25, 9), (96 - 35, 4), (96 - 36, 12)):
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(gx, gy, 1.4, 1.4, 12)]), 0.3, False), GOLD[2])
    for L in (layers[3], layers[4], layers[5]):
        F.halo(img, L.mask, GLOW, 90)
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(96 - 23, 16, 3.6, 2.6, 20)]), 0.4, False), SPIRIT[3])
    for (x, y) in (lock1[-1], lock2[-1]):
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(x, y, 2.0, 2.0, 14)]), 0.3, False), GOLD[2])
    for (x, y, c) in ((88, 10, None), (6, 30, (226, 196, 255)), (84, 88, None), (8, 86, (226, 196, 255))):
        F.sparkle(img, x, y, c or (255, 214, 246))
    return F.finish(img, 94)


if __name__ == "__main__":
    s = Image.new("RGBA", (300, 200), (72, 80, 104, 255))
    for i, (f, b) in enumerate(((F.lutling, lutling_back), (F.hauntello, hauntello_back), (F.harp, harp_back))):
        s.alpha_composite(f(), (i * 100 + 2, 2))
        s.alpha_composite(b(), (i * 100 + 2, 102))
    s.resize((900, 600), Image.NEAREST).save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/backs1.png")
