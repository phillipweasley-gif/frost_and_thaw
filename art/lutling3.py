"""Lutling, drawn with the clean pipeline."""
import math
from PIL import Image
from clean import *
from lutling2 import lute_body, fin

WOOD = [(132, 74, 38), (176, 108, 56), (214, 150, 84), (242, 196, 128)]
SPRUCE = [(214, 178, 116), (232, 202, 146), (246, 224, 176), (254, 240, 206)]
EBONY = [(30, 20, 18), (50, 36, 30), (74, 56, 44), (100, 80, 64)]
PEG = [(150, 96, 50), (192, 134, 72), (228, 174, 106), (248, 212, 152)]


def pegs(cx):
    """Three pairs of tuning pegs, square to the bent-back pegbox."""
    p0, p1 = (cx + 1.5, 26.5), (cx + 11.5, 18)
    dx, dy = p1[0] - p0[0], p1[1] - p0[1]
    ln = math.hypot(dx, dy)
    ux, uy = dx / ln, dy / ln
    nx, ny = -uy, ux
    out = []
    for t in (0.25, 0.55, 0.85):
        x, y = p0[0] + dx * t, p0[1] + dy * t
        for side in (-1, 1):
            out.append(ellipse_pts(x + side * nx * 4.4, y + side * ny * 4.4, 2.0, 2.0, 20))
    return out


def lutling():
    cx, top, w, h = 48, 38, 40, 48
    layers = [
        Layer([fin(cx, 66, 18, -1), fin(cx, 66, 18, 1)], WOOD, depth=4, outline=(86, 42, 18)),
        Layer([lute_body(cx, top, w, h)], WOOD, depth=6, outline=(86, 42, 18)),
        Layer([lute_body(cx, top, w, h, inset=2.4)], SPRUCE, depth=9, outline=(176, 128, 70), cuts=(-0.2, 0.3, 0.8)),
        Layer(pegs(cx), [PEG[1], PEG[2], PEG[3], PEG[3]], depth=2, outline=(110, 60, 26), threshold=0.45, clean=False),
        Layer([ribbon([(cx, 41), (cx, 27)], 2.6, 2.2), ribbon([(cx, 28.5), (cx + 5, 21.5), (cx + 11.5, 18)], 2.7, 2.4)], EBONY, depth=2, outline=(10, 4, 4)),
    ]
    img = compose(layers)
    # frets, rosette, bridge, strings, face
    for y in (31, 34, 37):
        paint(img, {(cx - 1, y), (cx, y), (cx + 1, y)}, (176, 156, 120))
    rose = to_mask(smooth_poly_mask([ellipse_pts(cx, 67, 6.4, 6.4)]))
    paint(img, rose, (78, 44, 24))
    paint(img, line_mask(ellipse_pts(cx, 67, 4.4, 4.4), 1.0), (214, 170, 104))
    paint(img, line_mask(ellipse_pts(cx, 67, 6.4, 6.4), 1.0), (120, 70, 34))
    paint(img, {(cx, 67), (cx - 2, 65), (cx + 2, 69), (cx + 2, 65), (cx - 2, 69)}, (210, 166, 100))
    paint(img, {(x, y) for x in range(cx - 7, cx + 8) for y in (79, 80)}, (70, 38, 20))
    for xb, xt in ((-4, -1.5), (0, 0), (4, 1.5)):
        paint(img, line_mask([(cx + xb + 0.5, 79), (cx + xt + 0.5, 30)], 0.9), (238, 228, 206))
    for ex in (cx - 9.5, cx + 9.5):
        paint(img, line_mask(ellipse_pts(ex, 50.5, 3.2, 2.6, 24, 200, 340), 1.4), (46, 22, 26))
    paint(img, {(x, y) for x in range(cx - 14, cx - 10) for y in (55,)} | {(x, y) for x in range(cx + 11, cx + 15) for y in (55,)}, (240, 132, 132))
    mouth = to_mask(smooth_poly_mask([ellipse_pts(cx, 55, 5.6, 4.4, 32, 0, 180)]), 0.45)
    paint(img, mouth, (78, 22, 32))
    paint(img, {(x, y) for (x, y) in mouth if y >= 57}, (236, 112, 132))
    for (x, y, c) in ((14, 30, (236, 130, 180)), (78, 34, (176, 120, 220))):
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(x + 1.8, y + 7, 2.0, 1.6)]), 0.4), c)
        paint(img, {(x + 3, yy) for yy in range(y, y + 7)} | {(x + 4, y), (x + 5, y + 1), (x + 6, y + 1)}, c)
    return drop_to_ground(img, 88)


if __name__ == "__main__":
    from lutling2 import lutling as old
    s = Image.new("RGBA", (200, 100), (66, 74, 96, 255))
    s.alpha_composite(old(), (2, 2)); s.alpha_composite(lutling(), (102, 2))
    s.resize((800, 400), Image.NEAREST).save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/lutling_clean.png")
