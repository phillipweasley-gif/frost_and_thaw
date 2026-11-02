"""Lutling v2: a lute first, a creature second (manta fins as a nod to Mantyke)."""
import math
from PIL import Image, ImageDraw
from pixelkit import Solid, render_solids, drop_to_ground
from hires import Part, bezier
from lute_line import closed, ribs, WOOD, WOOD_OUT, happy_eyes, open_mouth

SPRUCE = [(206, 172, 112), (226, 196, 138), (242, 220, 168), (252, 238, 200)]   # the pale soundboard
EBONY = [(30, 20, 18), (48, 34, 28), (70, 52, 42), (96, 76, 62)]


def lute_body(cx, top, w, h, inset=0.0):
    hw = w / 2 - inset
    t, b = top + inset * 1.4, top + h - inset
    return closed([
        ((cx, t), (cx + hw * 0.35, t), (cx + hw * 0.75, t + h * 0.25), (cx + hw * 0.95, t + h * 0.5)),
        ((cx + hw * 0.95, t + h * 0.5), (cx + hw * 1.1, t + h * 0.78), (cx + hw * 0.6, b), (cx, b)),
        ((cx, b), (cx - hw * 0.6, b), (cx - hw * 1.1, t + h * 0.78), (cx - hw * 0.95, t + h * 0.5)),
        ((cx - hw * 0.95, t + h * 0.5), (cx - hw * 0.75, t + h * 0.25), (cx - hw * 0.35, t), (cx, t)),
    ])


def fin(cx, y, span, side):
    sx = side
    root_top, root_bot = (cx + sx * 14, y - 6), (cx + sx * 16, y + 8)
    tip = (cx + sx * (14 + span), y - 10)
    return closed([
        (root_top, (cx + sx * (14 + span * 0.4), y - 12), (cx + sx * (14 + span * 0.8), y - 13), tip),
        (tip, (cx + sx * (14 + span * 0.9), y - 2), (cx + sx * (14 + span * 0.5), y + 8), root_bot),
    ])


def lutling():
    cx, top, w, h = 48, 38, 40, 48          # body from y=38 to 86
    body = Part().poly(lute_body(cx, top, w, h))
    board = Part().poly(lute_body(cx, top, w, h, inset=2.2))
    fins = Part().poly(fin(cx, 66, 18, -1)).poly(fin(cx, 66, 18, 1))
    neck = Part().stroke([(cx, 40), (cx, 26)], 3.4, 3.0)
    # the pegbox, bent sharply back, with pegs out both sides like ears
    pegbox = Part().stroke([(cx, 27), (cx + 5, 21), (cx + 11, 18)], 3.6, 3.0)
    pegs = Part()
    for i, (px, py) in enumerate(((cx + 2, 23), (cx + 6, 20.5), (cx + 10, 18.5))):
        pegs.stroke([(px, py), (px - 4.5, py - 3.5)], 1.6, 1.3)
        pegs.stroke([(px, py), (px + 3.5, py + 4.0)], 1.6, 1.3)
    shapes = [
        Solid(fins.mask(), WOOD, WOOD_OUT, depth=4, spec={(22, 55), (23, 54)}),
        Solid(body.mask(), WOOD, WOOD_OUT, depth=6),
        Solid(board.mask(), SPRUCE, (150, 110, 60), depth=8, spec={(36, 52), (37, 51), (38, 51)}),
        Solid(pegs.mask(), [(150, 96, 50), (190, 132, 70), (226, 172, 104), (246, 210, 150)], WOOD_OUT, depth=1),
        Solid(neck.mask() | pegbox.mask(), EBONY, (12, 6, 6), depth=2),
    ]
    img = render_solids(shapes)
    ribs(img, shapes[0].mask, cx, 54, 76, 22, (176, 108, 54), n=7)
    d = ImageDraw.Draw(img)
    for y in (29, 32, 35, 38):                                   # frets on the neck
        d.line([(cx - 2, y), (cx + 2, y)], fill=(170, 150, 120, 255))
    # rosette: carved lattice
    d.ellipse([cx - 7, 60, cx + 7, 74], fill=(70, 40, 22, 255))
    for r, c in ((6, (196, 150, 90)), (3, (196, 150, 90))):
        d.ellipse([cx - r, 67 - r, cx + r, 67 + r], outline=c + (255,))
    for a in range(0, 360, 45):
        d.point([(cx + round(4.5 * math.cos(math.radians(a))), 67 + round(4.5 * math.sin(math.radians(a))))], fill=(220, 180, 120, 255))
    # bridge low on the board, strings up over the rosette to the neck
    d.rectangle([cx - 7, 78, cx + 7, 80], fill=(60, 32, 18, 255))
    for xb, xt in ((-4, -2), (0, 0), (4, 2)):
        d.line([(cx + xb, 78), (cx + xt, 28)], fill=(236, 226, 204, 255))
    # happy face on the upper board, either side of the strings
    happy_eyes(d, cx, 47, 5)
    d.rectangle([cx - 14, 54, cx - 11, 55], fill=(240, 128, 128, 255)); d.rectangle([cx + 11, 54, cx + 14, 55], fill=(240, 128, 128, 255))
    open_mouth(d, cx, 55, 10, 3)
    for (x, y, c) in ((14, 30, (236, 130, 180)), (76, 34, (176, 120, 220))):
        d.ellipse([x, y + 5, x + 3, y + 8], fill=c + (255,)); d.line([(x + 3, y), (x + 3, y + 6)], fill=c + (255,))
        d.line([(x + 3, y), (x + 6, y + 2)], fill=c + (255,))
    return drop_to_ground(img, 88)


if __name__ == "__main__":
    im = lutling()
    big = Image.new("RGBA", (100, 100), (66, 74, 96, 255)); big.alpha_composite(im, (2, 2))
    big.resize((400, 400), Image.NEAREST).save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/lutling_v2.png")
