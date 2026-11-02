"""Hauntello v5 (clean pipeline): a cello with a violet spirit inside, peeking out of a
broken chip in its upper bout, Polteageist-style; its tentacle holds the bow."""
import math
from PIL import Image
from clean import *
from hires import bezier, spiral
from orchestra import cello_body

VARNISH = [(70, 20, 34), (104, 34, 50), (142, 58, 70), (184, 100, 104)]
MAPLE = [(122, 60, 34), (162, 88, 48), (198, 124, 66), (226, 164, 98)]
EBONY = [(26, 18, 16), (44, 32, 28), (66, 50, 42), (92, 74, 60)]
GOLD = (222, 180, 92)
GHOST = [(74, 34, 104), (110, 56, 148), (148, 92, 190), (190, 140, 226)]
GHOST_OUT = (40, 14, 60)
INSIDE = (28, 8, 34)
BOW = [(78, 44, 22), (106, 64, 32), (138, 88, 46), (168, 116, 64)]


def tilt(pts, ang, ox, oy):
    c, s = math.cos(ang), math.sin(ang)
    return [(ox + (x - ox) * c - (y - oy) * s, oy + (x - ox) * s + (y - oy) * c) for x, y in pts]


def chip_poly(cx, top):
    """A jagged break in the upper-left bout."""
    return [(cx - 13.5, top + 6), (cx - 9, top + 3), (cx - 6, top + 6.5), (cx - 3, top + 4.5), (cx - 1.5, top + 9),
            (cx - 4, top + 13), (cx - 8, top + 12), (cx - 11, top + 15), (cx - 14.5, top + 12)]


def hauntello(back=False):
    cx, top, h = 46, 30, 52
    ang = math.radians(-8)
    T = lambda pts: tilt(pts, ang, cx, top + h / 2)
    body = T(cello_body(cx, top, h, 14.5, 18.5, 10))
    inner = T(cello_body(cx, top + 1.7, h - 3.4, 12.8, 16.8, 8.4))
    chip = T(chip_poly(cx, top))
    neck = T([(cx, top + 3), (cx, top - 13)])
    sc = T([(cx + 2.4, top - 16.5)])[0]
    endpin = T([(cx, top + h - 1), (cx, top + h + 6)])
    # the spirit's tentacle leaves the right f-hole, curls up and holds the bow
    fh = T([(cx + 8.5, top + 30)])[0]
    tent = bezier(fh, (fh[0] + 14, fh[1] - 2), (fh[0] + 18, fh[1] - 18), (fh[0] + 12, fh[1] - 24), 24)
    grip = tent[-1]
    bow_a, bow_b = (grip[0] - 8, grip[1] + 34), (grip[0] + 9, grip[1] - 14)
    # a snapped string curling loose from the pegbox
    peg = T([(cx - 2, top - 9)])[0]
    loose = bezier(peg, (peg[0] - 10, peg[1] - 4), (peg[0] - 16, peg[1] + 6), (peg[0] - 12, peg[1] + 12), 20)
    loose += spiral(loose[-1][0] + 2.2, loose[-1][1], 2.2, 0.75, 180, shrink=0.5, n=14)[1:]
    wisp = bezier(endpin[1], (endpin[1][0] - 4, endpin[1][1] + 3), (endpin[1][0] + 3, endpin[1][1] + 6), (endpin[1][0] - 1, endpin[1][1] + 9), 14)
    layers = []
    layers.append(Layer([ribbon(wisp, 1.6, 0.5)], GHOST, depth=1, outline=GHOST_OUT, clean=False, threshold=0.4))
    layers.append(Layer([ribbon(endpin, 0.8, 0.6)], EBONY, depth=1, outline=(8, 4, 4), clean=False, threshold=0.4))
    layers.append(Layer([body], MAPLE if back else VARNISH, depth=10, outline=(40, 8, 18), holes=[chip]))
    layers.append(Layer([ribbon(neck, 2.3, 2.0), ribbon(spiral(sc[0], sc[1], 3.6, 0.9, 180, shrink=0.6, n=30), 1.9, 1.0)],
                        EBONY, depth=2, outline=(8, 4, 4)))
    pegs = []
    for dy, side in ((-6, -1), (-8, 1), (-10, -1), (-12, 1)):
        a, b = T([(cx + side * 2.2, top + dy), (cx + side * 5.2, top + dy - 0.6)])
        pegs.append(ellipse_pts(b[0], b[1], 1.6, 1.4, 16))
    layers.append(Layer(pegs, [(150, 110, 50), (200, 156, 72), (232, 196, 110), (250, 226, 160)], depth=1, outline=(90, 60, 20), clean=False, threshold=0.45))
    if not back:
        layers.append(Layer([ribbon(loose, 0.7, 0.6)], [(200, 190, 170)] * 4, depth=1, outline="none", flat=True, clean=False, threshold=0.35))
    img = compose(layers)
    px = img.load()
    bmask, imask = layers[2].mask, to_mask(smooth_poly_mask([inner]))
    chip_m = to_mask(smooth_poly_mask([chip]), 0.5, False)
    # purfling and the dark hollow inside the chip
    for (x, y) in bmask:
        if (x, y) not in imask and all((x + dx, y + dy) in bmask for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
            px[x, y] = ((44, 10, 22) if not back else (100, 50, 26)) + (255,)
    paint(img, chip_m, INSIDE)
    paint(img, outline_of(chip_m) - set(), (150, 120, 96))          # raw broken wood edge
    if not back:
        # fingerboard, strings, gilded swirl inlay, f-holes glowing, bridge, tailpiece
        fb = T([(cx - 2.2, top - 1), (cx + 2.2, top - 1), (cx + 2.8, top + 24), (cx - 2.8, top + 24)])
        paint(img, to_mask(smooth_poly_mask([fb]), 0.5, False), (24, 14, 12))
        for k in (-1.5, -0.5, 0.5, 1.5):
            paint(img, line_mask(T([(cx + k * 1.5, top + h - 7), (cx + k * 0.6, top - 9)]), 0.8), (176, 166, 150))
        for side in (-1, 1):
            f = T([(cx + side * 8.5, top + 25), (cx + side * 10, top + 28.5), (cx + side * 8.5, top + 32), (cx + side * 10, top + 35.5)])
            paint(img, line_mask(f, 1.3), (190, 120, 230))
            for p in (f[0], f[-1]):
                paint(img, to_mask(smooth_poly_mask([ellipse_pts(p[0], p[1], 1.0, 1.0, 12)]), 0.3, False), (190, 120, 230))
        for side in (-1, 1):   # gilded swirls on the lower bout
            sw = T(spiral(cx + side * 10, top + 43, 3.4, 1.0, 90 if side > 0 else 270, shrink=0.75, n=30, clockwise=side > 0))
            paint(img, line_mask(sw, 0.8), GOLD)
        paint(img, line_mask(T([(cx - 5.5, top + 37), (cx + 5.5, top + 37)]), 1.2), (214, 180, 120))
        tp = T([(cx - 2.6, top + 40), (cx + 2.6, top + 40), (cx + 1.5, top + h - 6), (cx - 1.5, top + h - 6)])
        paint(img, to_mask(smooth_poly_mask([tp]), 0.5, False), (24, 14, 12))
    else:
        for (x, y) in bmask:   # flamed maple
            if (x, y) in imask and (2 * y + x) % 9 == 0 and px[x, y][:3] in (MAPLE[2], MAPLE[3]):
                px[x, y] = MAPLE[1] + (255,)
    # the spirit peeking out of the chip, with little hands on the broken edge
    cc = T([(cx - 8, top + 7)])[0]
    head = ellipse_pts(cc[0], cc[1] - 3, 5.6, 5.0, 40)
    hands = [ellipse_pts(cc[0] - 6, cc[1] + 2.5, 1.8, 1.6, 16), ellipse_pts(cc[0] + 4.5, cc[1] + 3, 1.8, 1.6, 16)]
    over = [Layer([head], GHOST, depth=4, outline=GHOST_OUT), Layer(hands, GHOST, depth=1, outline=GHOST_OUT, clean=False, threshold=0.4),
            Layer([ribbon(tent, 1.4, 2.0)], GHOST, depth=2, outline=GHOST_OUT),
            Layer([ribbon([bow_a, bow_b], 0.7, 0.7)], BOW, depth=1, outline=(40, 20, 10), clean=False, threshold=0.4),
            Layer([ellipse_pts(grip[0], grip[1], 2.2, 2.0, 18)], GHOST, depth=1, outline=GHOST_OUT, clean=False, threshold=0.4)]
    top_img = compose(over)
    img.alpha_composite(top_img)
    if not back:
        # swirl eyes and a small smile (Polteageist-style)
        for ex in (cc[0] - 2.4, cc[0] + 2.0):
            paint(img, line_mask(spiral(ex, cc[1] - 3.6, 1.6, 1.0, 0, shrink=0.7, n=16), 0.7), (255, 214, 140))
        paint(img, line_mask([(cc[0] - 1.2, cc[1] - 0.6), (cc[0] + 0.8, cc[1] - 0.4)], 0.8), (255, 214, 140))
    if back:
        img = img.transpose(Image.FLIP_LEFT_RIGHT)
    return drop_to_ground(img, 94)


if __name__ == "__main__":
    s = Image.new("RGBA", (200, 100), (66, 74, 96, 255))
    s.alpha_composite(hauntello(False), (2, 2)); s.alpha_composite(hauntello(True), (102, 2))
    s.resize((800, 400), Image.NEAREST).save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/cello5.png")
