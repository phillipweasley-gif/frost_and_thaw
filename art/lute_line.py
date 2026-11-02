"""Alberica's line: Lutling -> Fretshade -> Chorumbra.
A lute creature whose strings slowly become tentacles. Drawn at 4x and reduced."""
import math
from PIL import Image, ImageDraw
from pixelkit import Solid, render_solids, drop_to_ground, SIZE
from hires import Part, bezier, spiral, S

WOOD = [(120, 66, 34), (166, 100, 50), (208, 144, 78), (240, 192, 122)]
WOOD_OUT = (66, 32, 16)
DARK_WOOD = [(40, 22, 36), (66, 40, 60), (96, 64, 88), (132, 98, 124)]
DARK_OUT = (16, 6, 16)
STRING = [(36, 20, 54), (66, 40, 96), (110, 72, 150), (168, 128, 206)]
STRING_OUT = (14, 6, 26)
SHELL = [(14, 12, 28), (30, 26, 54), (54, 50, 92), (96, 98, 152)]
SHELL_OUT = (4, 2, 10)
ICE = [(10, 16, 34), (24, 40, 72), (56, 98, 150), (160, 220, 250)]
ICE_OUT = (2, 4, 14)
RIBBON = [(120, 20, 40), (168, 34, 56), (210, 64, 82), (240, 120, 130)]
RIBBON_OUT = (60, 8, 20)
FRILL = [(120, 60, 140), (170, 96, 186), (220, 146, 220), (250, 200, 240)]
FRILL_OUT = (60, 20, 70)


def closed(beziers):
    pts = []
    for b in beziers:
        pts += bezier(*b)
    return pts


def pear_outline(cx, top, w, h, tilt=0.0):
    """A lute bowl: narrow shoulders, round full bottom."""
    hw = w / 2
    pts = closed([
        ((cx, top), (cx + hw * 0.55, top), (cx + hw * 0.7, top + h * 0.22), (cx + hw * 0.85, top + h * 0.42)),
        ((cx + hw * 0.85, top + h * 0.42), (cx + hw * 1.08, top + h * 0.7), (cx + hw * 0.8, top + h), (cx, top + h)),
        ((cx, top + h), (cx - hw * 0.8, top + h), (cx - hw * 1.08, top + h * 0.7), (cx - hw * 0.85, top + h * 0.42)),
        ((cx - hw * 0.85, top + h * 0.42), (cx - hw * 0.7, top + h * 0.22), (cx - hw * 0.55, top), (cx, top)),
    ])
    if tilt:
        ox, oy = cx, top + h / 2
        c, s = math.cos(tilt), math.sin(tilt)
        pts = [(ox + (x - ox) * c - (y - oy) * s, oy + (x - ox) * s + (y - oy) * c) for x, y in pts]
    return pts


def ribs(img, body_mask, cx, top, w, h, colour, n=5, tilt=0.0):
    """The staves of a lute bowl: curved lines from shoulder to base."""
    part = Part()
    for k in range(1, n):
        f = (k / n - 0.5) * 2              # -1..1 across the bowl
        x_mid = cx + f * w * 0.42
        pts = bezier((cx + f * w * 0.18, top + h * 0.12), (x_mid, top + h * 0.35), (x_mid, top + h * 0.8), (cx + f * w * 0.3, top + h * 0.98))
        if tilt:
            ox, oy = cx, top + h / 2
            c, s = math.cos(tilt), math.sin(tilt)
            pts = [(ox + (x - ox) * c - (y - oy) * s, oy + (x - ox) * s + (y - oy) * c) for x, y in pts]
        part.stroke(pts, 0.35)
    px = img.load()
    for (x, y) in part.mask(90):
        if (x, y) in body_mask and all((x + dx, y + dy) in body_mask for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
            px[x, y] = colour + (255,)


def eyes(d, pts, w=4, h=6, iris=(28, 18, 30), glint=(255, 255, 255), sparkle=(150, 120, 220)):
    for (x, y) in pts:
        d.ellipse([x, y, x + w, y + h], fill=iris + (255,))
        d.rectangle([x + 1, y + 1, x + 2, y + 2], fill=glint + (255,))
        d.point([(x + w - 1, y + h - 2)], fill=sparkle + (255,))


def wing_pts(cx, cy, span, lift, droop, side):
    """A manta wing seen from the front: a swept leading edge rising to a sharp,
    upturned tip, then a curved trailing edge with a rear lobe."""
    sx = side
    tip = (cx + sx * span, cy - lift)
    lobe = (cx + sx * span * 0.42, cy + droop)
    return closed([
        ((cx + sx * 6, cy - 9), (cx + sx * span * 0.4, cy - lift * 0.55 - 5), (cx + sx * span * 0.78, cy - lift * 0.95), tip),
        (tip, (cx + sx * span * 0.86, cy - lift * 0.25), (cx + sx * span * 0.62, cy + droop * 0.25), lobe),
        (lobe, (cx + sx * span * 0.28, cy + droop * 0.7), (cx + sx * 14, cy + 11), (cx + sx * 6, cy + 9)),
    ])


STRING_TONES = [(150, 120, 200), (196, 172, 236), (232, 220, 252), (255, 250, 255)]
STRING_EDGE = (90, 64, 140)


def happy_eyes(d, cx, y, gap, w=5):
    """Closed, smiling eyes: little upside-down U's."""
    for ex in (cx - gap - w, cx + gap):
        d.arc([ex, y, ex + w, y + 5], 200, 340, fill=(40, 20, 30, 255), width=2)


def open_mouth(d, cx, y, w=6, h=4):
    d.chord([cx - w // 2, y - h, cx + w // 2, y + h], 0, 180, fill=(70, 20, 30, 255))
    d.chord([cx - w // 2 + 2, y + 1, cx + w // 2 - 2, y + h - 1], 0, 180, fill=(236, 110, 130, 255))


def belly_strings(d, xs, top, bridge, colour=(250, 244, 226)):
    for x in xs:
        d.line([(x, top), (x, bridge)], fill=colour + (255,))


def lutling():
    cx, cy = 48, 62
    body = Part().ellipse(cx, cy, 15, 14)
    wings = Part().poly(wing_pts(cx, cy, 31, 15, 9, -1)).poly(wing_pts(cx, cy, 31, 15, 9, 1))
    belly = Part().ellipse(cx, cy + 3, 10.5, 9.5)
    pegs = Part().stroke(spiral(cx - 8, cy - 18, 3.6, 0.8, 30, shrink=0.6, clockwise=False), 2.2, 1.2) \
                 .stroke([(cx - 6, cy - 12), (cx - 8, cy - 16)], 2.2) \
                 .stroke(spiral(cx + 8, cy - 18, 3.6, 0.8, 150, shrink=0.6), 2.2, 1.2) \
                 .stroke([(cx + 6, cy - 12), (cx + 8, cy - 16)], 2.2)
    tail = Part().stroke(bezier((cx + 6, cy + 10), (cx + 18, cy + 22), (cx + 30, cy + 18), (cx + 32, cy + 10), 16), 2.4, 1.6)
    tail_scroll = Part().stroke(spiral(cx + 31, cy + 7, 3.2, 0.8, 90, shrink=0.6, clockwise=False), 1.8, 1.0)
    bow = Part().ellipse(cx + 12, cy - 9, 2.6, 2.0).ellipse(cx + 16, cy - 10, 2.6, 2.0)
    shapes = [
        Solid(tail.mask() | tail_scroll.mask(), [(84, 46, 24), (120, 72, 38), (160, 104, 56), (200, 146, 90)], WOOD_OUT, depth=2),
        Solid(wings.mask(), WOOD, WOOD_OUT, depth=6, spec={(20, 52), (21, 51), (22, 51)}),
        Solid(pegs.mask(), [(84, 46, 24), (120, 72, 38), (160, 104, 56), (200, 146, 90)], WOOD_OUT, depth=2),
        Solid(body.mask(), WOOD, WOOD_OUT, depth=9, spec={(39, 51), (40, 50), (41, 50)}),
        Solid(belly.mask(), [(200, 160, 110), (226, 192, 140), (244, 218, 170), (252, 238, 206)], (120, 80, 40), depth=6),
        Solid(bow.mask(), RIBBON, RIBBON_OUT, depth=1),
    ]
    img = render_solids(shapes)
    ribs(img, shapes[1].mask, cx, cy - 12, 70, 22, (176, 108, 54), n=9)
    d = ImageDraw.Draw(img)
    d.ellipse([cx - 4, cy + 3, cx + 4, cy + 11], fill=(70, 34, 18, 255))                   # rosette on the soundboard
    d.ellipse([cx - 2, cy + 5, cx + 2, cy + 9], outline=(214, 168, 100, 255))
    d.rectangle([cx - 4, cy + 12, cx + 4, cy + 12], fill=(100, 60, 30, 255))                # bridge
    belly_strings(d, [cx - 3, cx - 1, cx + 1, cx + 3], cy + 3, cy + 12)
    happy_eyes(d, cx, cy - 8, 4)
    open_mouth(d, cx, cy - 1, 6, 3)
    d.rectangle([cx - 14, cy - 2, cx - 11, cy - 1], fill=(240, 128, 128, 255)); d.rectangle([cx + 11, cy - 2, cx + 14, cy - 1], fill=(240, 128, 128, 255))
    for x in (cx - 13, cx + 13):                       # strings vibrating as it sings
        d.point([(x - 1, cy + 6), (x + 1, cy + 8), (x - 1, cy + 10)], fill=(250, 240, 214, 255))
    for (x, y, c) in ((12, 34, (236, 130, 180)), (78, 30, (176, 120, 220))):
        d.ellipse([x, y + 5, x + 3, y + 8], fill=c + (255,)); d.line([(x + 3, y), (x + 3, y + 6)], fill=c + (255,))
        d.line([(x + 3, y), (x + 6, y + 2)], fill=c + (255,))
    return drop_to_ground(img, 86)


def frayed(part, pts, r0, r1):
    """A string-tentacle whose tip splits into two strands."""
    part.stroke(pts, r0, r1 + 0.6)
    (x0, y0), (x1, y1) = pts[-2], pts[-1]
    dx, dy = x1 - x0, y1 - y0
    ln = math.hypot(dx, dy) or 1
    nx, ny = -dy / ln, dx / ln
    for side in (-1, 1):
        part.stroke([(x1, y1), (x1 + dx / ln * 5 + nx * side * 3, y1 + dy / ln * 5 + ny * side * 3)], r1, 0.5)


def string_tentacles(part, xs, top, length, curl, sway=2.0, r0=1.5, r1=0.9):
    """Strings that leave the bridge and keep going, curling at the ends like tentacles."""
    for i, x in enumerate(xs):
        side = -1 if x < 48 else 1
        pts = [(x + sway * math.sin(i * 1.3 + j * 0.8), top + length * j / 8) for j in range(9)]
        end = pts[-1]
        pts += spiral(end[0] + side * curl, end[1], curl, 0.7, 180 if side > 0 else 0, shrink=0.5, n=12,
                      clockwise=side < 0)[1:]
        part.stroke(pts, r0, r1)


def fretshade():
    cx, cy = 48, 44
    body = Part().ellipse(cx, cy, 16, 15)
    wings = Part().poly(wing_pts(cx, cy, 42, 22, 12, -1)).poly(wing_pts(cx, cy, 42, 22, 12, 1))
    belly = Part().ellipse(cx, cy + 4, 11, 10)
    horns = Part()
    for side in (-1, 1):                     # peg fins grown into jaunty curled horns
        horns.stroke(bezier((cx + side * 7, cy - 12), (cx + side * 10, cy - 22), (cx + side * 18, cy - 24), (cx + side * 16, cy - 30), 12), 2.6, 1.2)
        horns.ellipse(cx + side * 16, cy - 31, 2.4, 2.4)
    strings = Part()
    string_tentacles(strings, [cx - 6, cx - 2, cx + 2, cx + 6], cy + 14, 30, 3.5, sway=2.2)
    tail = Part().stroke(bezier((cx - 8, cy + 10), (cx - 26, cy + 26), (cx - 40, cy + 20), (cx - 40, cy + 8), 18), 2.4, 1.4)
    tail_scroll = Part().stroke(spiral(cx - 39, cy + 5, 3.6, 0.85, 90, shrink=0.6), 2.0, 1.0)
    scarf = Part().stroke([(cx - 12, cy - 10), (cx, cy - 13), (cx + 12, cy - 10)], 1.8).stroke(bezier((cx + 10, cy - 10), (cx + 20, cy - 12), (cx + 24, cy - 4), (cx + 30, cy - 6), 10), 1.6, 0.8)
    shapes = [
        Solid(tail.mask() | tail_scroll.mask(), DARK_WOOD, DARK_OUT, depth=2),
        Solid(wings.mask(), DARK_WOOD, DARK_OUT, depth=7, spec={(12, 26), (13, 25), (14, 25)}),
        Solid(horns.mask(), [(60, 40, 44), (96, 66, 66), (136, 100, 92), (180, 150, 130)], DARK_OUT, depth=2),
        Solid(body.mask(), DARK_WOOD, DARK_OUT, depth=10),
        Solid(belly.mask(), [(150, 110, 92), (180, 140, 112), (206, 170, 136), (230, 200, 166)], (70, 40, 30), depth=6),
        Solid(strings.mask(), STRING_TONES, STRING_EDGE, depth=1),
        Solid(scarf.mask(), RIBBON, RIBBON_OUT, depth=1),
    ]
    img = render_solids(shapes)
    ribs(img, shapes[1].mask, cx, cy - 20, 88, 30, (54, 32, 50), n=11)
    d = ImageDraw.Draw(img)
    d.ellipse([cx - 4, cy + 3, cx + 4, cy + 11], fill=(30, 10, 30, 255), outline=(170, 120, 80, 255))   # rosette
    d.rectangle([cx - 8, cy + 13, cx + 8, cy + 14], fill=(90, 50, 30, 255))                          # bridge
    belly_strings(d, [cx - 6, cx - 2, cx + 2, cx + 6], cy + 1, cy + 13, (238, 228, 252))
    # mischievous grin and a wink
    d.arc([cx - 11, cy - 9, cx - 5, cy - 4], 200, 340, fill=(250, 220, 120, 255), width=2)          # winking eye
    d.ellipse([cx + 4, cy - 10, cx + 9, cy - 4], fill=(250, 220, 120, 255), outline=(40, 16, 20, 255))
    d.rectangle([cx + 6, cy - 8, cx + 7, cy - 6], fill=(40, 8, 30, 255))
    d.chord([cx - 6, cy - 5, cx + 6, cy + 3], 0, 180, fill=(40, 10, 24, 255))
    d.polygon([(cx - 3, cy - 1), (cx - 1, cy - 1), (cx - 2, cy + 1)], fill=(255, 255, 255, 255))     # fang
    for (x, y) in ((cx - 24, cy - 2), (cx + 26, cy - 4)):
        d.line([(x, y), (x + 2, y + 3), (x, y + 6)], fill=(240, 150, 230, 255))                       # fairy-glow cracks
    for (x, y, c) in ((10, 20, (240, 150, 230)), (82, 16, (190, 160, 255))):
        d.ellipse([x, y + 5, x + 3, y + 8], fill=c + (255,)); d.line([(x + 3, y), (x + 3, y + 6)], fill=c + (255,))
        d.line([(x + 3, y), (x + 6, y + 2)], fill=c + (255,))
    return drop_to_ground(img, 95)


def chorumbra():
    cx, cy = 48, 40
    body = Part().ellipse(cx, cy, 16, 15)
    wings = Part().poly(wing_pts(cx, cy, 46, 26, 11, -1)).poly(wing_pts(cx, cy, 46, 26, 11, 1))
    belly = Part().ellipse(cx, cy + 4, 11, 10)
    horns = Part()
    for side in (-1, 1):
        horns.stroke(bezier((cx + side * 7, cy - 12), (cx + side * 12, cy - 24), (cx + side * 8, cy - 30), (cx + side * 16, cy - 36), 12), 3.0, 0.6)
    gem = Part().ellipse(cx, cy - 15, 4, 4)
    frill = Part()
    for side in (-1, 1):
        for k in range(7):
            t = k / 6
            frill.ellipse(cx + side * (12 + t * 22), cy + 9 + (2 if k % 2 else 0), 3.0, 2.6)
    strings = Part()
    string_tentacles(strings, [cx - 9, cx - 5, cx - 1, cx + 3, cx + 7], cy + 14, 38, 4.0, sway=3.0, r0=1.8, r1=1.0)
    # two outer strings swept up like a conductor's arms
    for side in (-1, 1):
        strings.stroke(bezier((cx + side * 10, cy + 12), (cx + side * 30, cy + 26), (cx + side * 44, cy + 14), (cx + side * 40, cy + 2), 16), 1.8, 1.0)
    shapes = [
        Solid(frill.mask(), FRILL, FRILL_OUT, depth=2),
        Solid(wings.mask(), SHELL, SHELL_OUT, depth=7, spec={(10, 20), (11, 19), (12, 19)}),
        Solid(horns.mask(), ICE, ICE_OUT, depth=2),
        Solid(body.mask(), SHELL, SHELL_OUT, depth=9),
        Solid(belly.mask(), [(70, 60, 110), (96, 86, 140), (126, 116, 170), (160, 150, 200)], SHELL_OUT, depth=6),
        Solid(strings.mask(), STRING_TONES, STRING_EDGE, depth=1),
        Solid(gem.mask(), [(140, 40, 110), (200, 80, 170), (250, 140, 210), (255, 220, 245)], (60, 10, 50), depth=2),
    ]
    img = render_solids(shapes)
    ribs(img, shapes[1].mask, cx, cy - 22, 96, 32, (40, 38, 74), n=13)
    d = ImageDraw.Draw(img)
    d.ellipse([cx - 4, cy + 3, cx + 4, cy + 11], fill=(20, 8, 30, 255), outline=(206, 168, 104, 255))
    d.rectangle([cx - 10, cy + 13, cx + 10, cy + 14], fill=(206, 168, 104, 255))           # gilded bridge
    belly_strings(d, [cx - 9, cx - 5, cx - 1, cx + 3, cx + 7], cy + 1, cy + 13, (238, 228, 252))
    happy_eyes(d, cx, cy - 8, 4)
    d.arc([cx - 5, cy - 4, cx + 5, cy + 2], 20, 160, fill=(255, 190, 220, 255), width=1)   # serene smile
    for (x, y, c) in ((8, 14, (255, 190, 235)), (84, 12, (190, 160, 255)), (6, 74, (160, 210, 255)), (86, 78, (255, 190, 235))):
        d.ellipse([x, y + 5, x + 3, y + 8], fill=c + (255,)); d.line([(x + 3, y), (x + 3, y + 6)], fill=c + (255,))
        d.line([(x + 3, y), (x + 6, y + 2)], fill=c + (255,))
    return drop_to_ground(img, 95)
