"""Alberica's line, v3: Lutling (lute) -> Hauntello (cello) -> Pianocturne (floating grand piano).
Happily possessed instruments; strings that come loose and curl like tentacles."""
import math
from PIL import Image, ImageDraw
from pixelkit import Solid, render_solids, drop_to_ground
from hires import Part, bezier, spiral
from lute_line import closed, happy_eyes
from lutling2 import lutling, EBONY

CELLO = [(54, 18, 30), (86, 32, 46), (124, 52, 66), (166, 88, 96)]        # wine-dark varnish
CELLO_OUT = (22, 4, 12)
LACQUER = [(10, 8, 18), (24, 20, 40), (44, 38, 72), (88, 84, 132)]
LACQUER_OUT = (2, 0, 6)
GOLD = [(120, 84, 30), (170, 124, 50), (214, 172, 80), (246, 218, 140)]
GOLD_OUT = (60, 36, 10)
STR = [(150, 120, 200), (196, 172, 236), (232, 220, 252), (255, 250, 255)]
STR_OUT = (80, 56, 130)
WISP = [(70, 40, 110), (110, 70, 160), (160, 120, 210), (210, 180, 245)]
WISP_OUT = (40, 16, 70)


def sparkles(d, pts, c=(255, 190, 235)):
    for (x, y) in pts:
        d.point([(x, y), (x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)], fill=c + (255,))


def notes(d, items):
    for (x, y, c) in items:
        d.ellipse([x, y + 5, x + 3, y + 8], fill=c + (255,)); d.line([(x + 3, y), (x + 3, y + 6)], fill=c + (255,))
        d.line([(x + 3, y), (x + 6, y + 2)], fill=c + (255,))


def cello_body(cx, top, h, w_up, w_low, waist):
    """Upper bout, C-bout waist, lower bout."""
    y_up, y_w, y_low, bot = top + h * 0.22, top + h * 0.5, top + h * 0.74, top + h
    pts = []
    for side in (1, -1):
        seq = closed([
            ((cx, top), (cx + side * w_up * 0.6, top), (cx + side * w_up, top + h * 0.08), (cx + side * w_up, y_up)),
            ((cx + side * w_up, y_up), (cx + side * w_up, y_up + h * 0.12), (cx + side * waist, y_w - h * 0.08), (cx + side * waist, y_w)),
            ((cx + side * waist, y_w), (cx + side * waist, y_w + h * 0.08), (cx + side * w_low, y_low - h * 0.12), (cx + side * w_low, y_low)),
            ((cx + side * w_low, y_low), (cx + side * w_low, bot - h * 0.06), (cx + side * w_low * 0.6, bot), (cx, bot)),
        ])
        pts += seq if side == 1 else list(reversed(seq))
    return pts


def hauntello():
    cx, top, h = 44, 30, 54
    body = Part().poly(cello_body(cx, top, h, 15, 19, 10))
    neck = Part().stroke([(cx, top + 2), (cx, 12)], 2.8, 2.4)
    scroll = Part().stroke(spiral(cx + 3, 9, 4.0, 0.9, 180, shrink=0.6), 2.4, 1.2)
    pegs = Part().stroke([(cx - 1, 13), (cx - 6, 11)], 1.4).stroke([(cx + 1, 15), (cx + 6, 15)], 1.4)
    endpin = Part().stroke([(cx, top + h), (cx, top + h + 6)], 1.0, 0.6)
    # two strings come loose from the pegs and curl like arms; one waves the bow
    arms = Part()
    arms.stroke(bezier((cx - 5, 12), (cx - 24, 8), (cx - 30, 30), (cx - 22, 40), 18), 2.4, 1.6)
    arms.stroke(spiral(cx - 25, 42, 3.4, 0.85, 300, shrink=0.5, n=14), 1.6, 0.9)
    arms.stroke(bezier((cx + 6, 15), (cx + 24, 12), (cx + 32, 24), (cx + 28, 35), 18), 2.4, 1.8)
    bow = Part().stroke([(cx + 26, 36), (cx + 44, 14)], 1.1)
    bow_hair = Part().stroke([(cx + 27, 38), (cx + 46, 17)], 0.6)
    frog = Part().ellipse(cx + 27, 37, 2.2, 1.8)
    shapes = [
        Solid(endpin.mask(), EBONY, (8, 4, 4), depth=1),
        Solid(arms.mask(), STR, STR_OUT, depth=1),
        Solid(body.mask(), CELLO, CELLO_OUT, depth=9, spec={(32, 36), (33, 35), (34, 35), (31, 38)}),
        Solid(neck.mask() | scroll.mask(), EBONY, (8, 4, 4), depth=2),
        Solid(pegs.mask(), GOLD, GOLD_OUT, depth=1),
        Solid(bow.mask(), [(70, 40, 20), (100, 60, 30), (130, 84, 44), (160, 110, 60)], (40, 20, 10), depth=1),
        Solid(bow_hair.mask(), [(220, 214, 200)] * 2 + [(245, 240, 230)] * 2, (180, 170, 150), depth=1),
        Solid(frog.mask(), EBONY, (8, 4, 4), depth=1),
    ]
    img = render_solids(shapes)
    d = ImageDraw.Draw(img)
    # fingerboard down the front
    d.polygon([(cx - 2, top), (cx + 2, top), (cx + 3, top + 26), (cx - 3, top + 26)], fill=(30, 20, 18, 255))
    # f-holes glowing, with big happy eyes above them
    for side in (-1, 1):
        ex = cx + side * 9
        d.line([(ex, top + 24), (ex + side, top + 28), (ex, top + 32)], fill=(255, 150, 220, 255), width=2)
        d.arc([ex - 4, top + 14, ex + 4, top + 22], 200, 340, fill=(255, 170, 230, 255), width=2)
        d.rectangle([ex + side * 3 - 1, top + 21, ex + side * 3 + 1, top + 22], fill=(255, 120, 160, 255))
    # a toothy grin where the bridge stands
    d.chord([cx - 9, top + 32, cx + 9, top + 44], 0, 180, fill=(30, 6, 24, 255))
    for x in range(cx - 7, cx + 8, 3):
        d.rectangle([x, top + 38, x + 1, top + 39], fill=(250, 244, 230, 255))
    d.line([(cx - 5, top + 46), (cx + 5, top + 46)], fill=(200, 160, 90, 255))           # bridge
    d.polygon([(cx - 2, 14), (cx + 2, 14), (cx + 3, top + 26), (cx - 3, top + 26)], fill=(30, 20, 18, 255))
    for xb, xt in ((-3, -1), (3, 1)):
        d.line([(cx + xb, top + 46), (cx + xt, 14)], fill=(236, 226, 204, 255))      # strings
    sparkles(d, [(12, 20), (78, 8), (10, 70), (84, 60)])
    notes(d, [(70, 44, (240, 150, 230)), (14, 46, (190, 160, 255))])
    return drop_to_ground(img, 92)


def pianocturne():
    # ghost wisps where the legs should be
    wisps = Part()
    for x, ln in ((24, 22), (48, 26), (72, 20)):
        wisps.stroke(bezier((x, 60), (x - 4, 60 + ln * 0.4), (x + 6, 60 + ln * 0.7), (x - 2, 60 + ln), 14), 4.0, 0.6)
    case_side = Part().poly([(10, 48), (86, 48), (86, 58), (10, 58)])
    case_top = Part().poly(closed([((10, 48), (10, 34), (22, 22), (40, 24)), ((40, 24), (58, 26), (70, 30), (86, 30)),
                                   ((86, 30), (86, 36), (86, 42), (86, 48)), ((86, 48), (60, 48), (30, 48), (10, 48))]))
    lid = Part().poly([(14, 34), (40, 20), (86, 28), (74, 2), (40, 0), (18, 14)])
    prop = Part().stroke([(70, 30), (66, 10)], 0.9)
    tentacles = Part()
    for i, (sx, sy, path) in enumerate((
            (30, 26, [(22, 14), (12, 12), (8, 20), (12, 24)]),
            (44, 24, [(40, 12), (34, 6), (28, 8)]),
            (62, 28, [(70, 16), (80, 12), (88, 16), (86, 22)]),
            (78, 30, [(90, 30), (94, 38), (90, 44)]))):
        tentacles.stroke([(sx, sy)] + path, 2.8, 1.1)
    keybed = Part().poly(closed([((14, 49), (40, 51), (56, 51), (82, 49)), ((82, 49), (80, 56), (62, 62), (48, 62)),
                                 ((48, 62), (34, 62), (16, 56), (14, 49))]))
    stand = Part().poly([(36, 40), (60, 40), (58, 46), (38, 46)])
    shapes = [
        Solid(wisps.mask(), WISP, WISP_OUT, depth=3),
        Solid(tentacles.mask(), STR, STR_OUT, depth=1),
        Solid(lid.mask(), LACQUER, LACQUER_OUT, depth=6, spec={(30, 12), (31, 11), (32, 11), (33, 10)}),
        Solid(prop.mask(), GOLD, GOLD_OUT, depth=1),
        Solid(case_top.mask(), LACQUER, LACQUER_OUT, depth=6),
        Solid(case_side.mask(), LACQUER, LACQUER_OUT, depth=4),
        Solid(stand.mask(), LACQUER, LACQUER_OUT, depth=2),
        Solid(keybed.mask(), [(200, 196, 190), (226, 222, 214), (244, 240, 232), (255, 255, 250)], (60, 50, 50), depth=2),
    ]
    img = render_solids(shapes)
    d = ImageDraw.Draw(img)
    d.line([(10, 47), (86, 47)], fill=(214, 172, 80, 255))                               # gold trim
    # the grin: white keys as teeth following the curve, black keys between
    for x in range(16, 82, 3):
        depth = 56 + round(5 * math.sin(math.pi * (x - 14) / 68))
        d.line([(x, 51), (x, depth)], fill=(150, 140, 140, 255))
    for x in (18, 21, 27, 30, 33, 39, 42, 48, 51, 54, 60, 63, 69, 72, 75):
        d.rectangle([x, 51, x + 1, 54], fill=(20, 14, 26, 255))
    # glowing happy eyes on the fallboard above the keys
    for ex in (32, 58):
        d.arc([ex - 6, 38, ex + 6, 47], 200, 340, fill=(255, 160, 225, 255), width=2)
        d.rectangle([ex - 1, 46, ex + 1, 46], fill=(255, 120, 160, 255))
    sparkles(d, [(6, 40), (92, 52), (14, 86), (82, 88), (52, 66)])
    notes(d, [(4, 8, (240, 150, 230)), (88, 2, (190, 160, 255)), (60, 70, (160, 210, 255))])
    return drop_to_ground(img, 95)


if __name__ == "__main__":
    ims = [lutling(), hauntello(), pianocturne()]
    s = Image.new("RGBA", (300, 100), (66, 74, 96, 255))
    for i, im in enumerate(ims):
        s.alpha_composite(im, (i * 100 + 2, 2))
    s.resize((900, 300), Image.NEAREST).save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/orch1.png")
