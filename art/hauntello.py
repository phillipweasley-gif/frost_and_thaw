"""Hauntello: a happily possessed cello. The cello stays clean and ornate with a sly
face carved into its upper bout; its strings run off the pegbox and tailpiece and
become four big smoky shadow arms (Cofagrigus-style), one holding the bow."""
import math
from PIL import Image, ImageDraw
from hires import Part, bezier, spiral
from pixelkit import Solid, render_solids, drop_to_ground
from orchestra import cello_body, CELLO, CELLO_OUT, GOLD, GOLD_OUT, sparkles
from lutling2 import EBONY
from shadow import SHADOW, SHADOW_OUT, hand, arm

MAPLE = [(110, 52, 32), (150, 76, 42), (186, 108, 58), (214, 146, 84)]
GLOW = (255, 120, 210)


def build(back):
    cx, top, h = 48, 30, 46
    shapes = []
    arms = Part()
    # roots: strings leave the pegbox (top) and the tailpiece (bottom)
    peg_l, peg_r = (cx - 3, top - 12), (cx + 3, top - 13)
    tail_l, tail_r = (cx - 2, top + h - 4), (cx + 2, top + h - 4)
    s = -1 if back else 1      # the back view is mirrored, so the bow hand stays on the same side of the creature
    a1 = arm(arms, peg_r, (cx + 12, top - 20), (cx + 22, top - 18), (cx + 26, top - 8), 0.6, 2.8)
    hand(arms, a1[-1], -80, 1.55, 0.8, curl=0.6)
    a2 = arm(arms, peg_l, (cx - 14, top - 18), (cx - 26, top - 8), (cx - 30, top + 4), 0.6, 2.8)
    hand(arms, a2[-1], 205, 1.7, 1.15, curl=-0.25)
    a3 = arm(arms, tail_l, (cx - 8, top + h + 6), (cx - 20, top + h + 4), (cx - 26, top + h - 6), 0.6, 2.6)
    hand(arms, a3[-1], 235, 1.45, 1.0, curl=-0.35)
    a4 = arm(arms, tail_r, (cx + 10, top + h + 8), (cx + 22, top + h + 6), (cx + 28, top + h - 4), 0.6, 2.6)
    hand(arms, a4[-1], -45, 1.45, 1.0, curl=0.35)
    body = Part().poly(cello_body(cx, top, h, 13, 17, 9))
    inner = Part().poly(cello_body(cx, top + 1.5, h - 3, 11.6, 15.6, 7.8))
    neck = Part().stroke([(cx, top + 2), (cx, top - 12)], 2.3, 2.0)
    scroll = Part().stroke(spiral(cx + 2.4, top - 15, 3.6, 0.9, 180, shrink=0.6), 2.1, 1.0)
    pegs = Part()
    for dy, side in ((-9, -1), (-7, 1), (-11, 1), (-12.5, -1)):
        pegs.stroke([(cx, top + dy), (cx + side * 4.2, top + dy - 1)], 1.1)
    bow_hand = a1[-1]
    bh = (bow_hand[0] + 1, bow_hand[1] - 5)
    bow = Part().stroke([(bh[0] - 10, bh[1] + 34), (bh[0] + 4, bh[1] - 6)], 0.8)
    hair = Part().stroke([(bh[0] - 8.5, bh[1] + 35), (bh[0] + 5.5, bh[1] - 5)], 0.5)
    endpin = Part().stroke([(cx, top + h), (cx, top + h + 5)], 0.8, 0.5)
    body_tones = MAPLE if back else CELLO
    shapes = [
        Solid(endpin.mask(), EBONY, (8, 4, 4), depth=1),
        Solid(body.mask(), body_tones, CELLO_OUT, depth=9, spec=set() if back else {(38, 36), (39, 35), (40, 35), (38, 37)}),
        Solid(neck.mask() | scroll.mask(), EBONY, (8, 4, 4), depth=2),
        Solid(pegs.mask(), GOLD, GOLD_OUT, depth=1),
        Solid(bow.mask(), [(70, 40, 20), (100, 60, 30), (130, 84, 44), (160, 110, 60)], (40, 20, 10), depth=1),
        Solid(hair.mask(), [(214, 208, 196), (230, 224, 212), (244, 240, 232), (255, 255, 250)], (170, 160, 140), depth=1),
        Solid(arms.mask(), SHADOW, SHADOW_OUT, depth=3),
    ]
    img = render_solids(shapes)
    px = img.load()
    bmask, imask = shapes[1].mask, inner.mask()
    for (x, y) in bmask:       # purfling
        if (x, y) not in imask and all((x + dx, y + dy) in bmask for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
            px[x, y] = ((40, 10, 20) if not back else (96, 46, 26)) + (255,)
    d = ImageDraw.Draw(img)
    # the strings: light where they leave the cello, fading into the shadow arms
    for root, path in ((peg_r, a1), (peg_l, a2), (tail_l, a3), (tail_r, a4)):
        d.line([root, path[3]], fill=(214, 204, 186, 255))
    if not back:
        d.polygon([(cx - 2, top - 1), (cx + 2, top - 1), (cx + 2.6, top + 20), (cx - 2.6, top + 20)], fill=(26, 16, 14, 255))
        for k in (-1.5, -0.5, 0.5, 1.5):
            d.line([(cx + k * 1.4, top + h - 6), (cx + k * 0.6, top - 10)], fill=(150, 140, 128, 255))
        # the sly face carved into the upper bout
        for side in (-1, 1):
            ex = cx + side * 7
            d.polygon([(ex - side * 4, top + 9), (ex + side * 3, top + 7), (ex + side * 4, top + 11), (ex - side * 3, top + 12)],
                      fill=(20, 4, 14, 255))
            d.polygon([(ex - side * 2, top + 9), (ex + side * 2, top + 8), (ex + side * 2, top + 10), (ex - side * 1, top + 11)],
                      fill=GLOW + (255,))
            d.point([(ex, top + 9)], fill=(255, 230, 250, 255))
        d.chord([cx - 9, top + 10, cx + 9, top + 22], 10, 170, fill=(20, 4, 14, 255))
        for x in range(cx - 6, cx + 7, 3):
            d.polygon([(x, top + 17), (x + 2, top + 17), (x + 1, top + 19)], fill=(246, 236, 220, 255))
        # f-holes glowing below, bridge and tailpiece
        for side in (-1, 1):
            f = [(cx + side * 8, top + 26), (cx + side * 9.4, top + 29), (cx + side * 8, top + 32), (cx + side * 9.4, top + 35)]
            d.line(f, fill=GLOW + (255,))
        d.line([(cx - 5, top + 33), (cx + 5, top + 33)], fill=(214, 180, 120, 255))
        d.polygon([(cx - 2.4, top + 36), (cx + 2.4, top + 36), (cx + 1.4, top + 42), (cx - 1.4, top + 42)], fill=(24, 14, 12, 255))
    else:
        for (x, y) in bmask:   # flamed maple, subtle
            if (x, y) in imask and (y * 2 + x) % 9 == 0 and px[x, y][:3] in (MAPLE[2], MAPLE[3]):
                px[x, y] = MAPLE[1] + (255,)
        d.ellipse([cx - 2, top - 1, cx + 2, top + 2], fill=(150, 80, 44, 255), outline=(60, 24, 12, 255))
    sparkles(d, [(8, 30), (88, 26), (10, 86), (86, 88)], (255, 190, 235))
    if back:
        img = img.transpose(Image.FLIP_LEFT_RIGHT)
    return drop_to_ground(img, 94)


def hauntello(back=False):
    return build(back)


if __name__ == "__main__":
    s = Image.new("RGBA", (200, 100), (66, 74, 96, 255))
    s.alpha_composite(hauntello(False), (2, 2)); s.alpha_composite(hauntello(True), (102, 2))
    s.resize((800, 400), Image.NEAREST).save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/cello3.png")
