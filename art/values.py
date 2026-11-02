"""Value pass on the approved silhouettes: greys for the instrument, violet for the
spirit (the only colour), the rosette glowing from inside, faces, strings."""
import math
from PIL import Image, ImageDraw
from clean import *
from hires import bezier, spiral
from lutling2 import lute_body, fin
from orchestra import cello_body
from silhouettes import curl
from story_line import (G, G_DARK, G_LIGHT, OUT, SPIRIT, SPIRIT_OUT, GLOW, GOLD,
                        rosette, gold_tip, painted_face, pinched)

STRING = (232, 232, 236)


def v1():
    cx = 48
    bow = ribbon([(66, 84), (80, 56)], 0.6, 0.6)
    L = [Layer([bow], G_DARK, depth=1, outline=OUT, clean=False, threshold=0.4),
         Layer([fin(cx, 66, 18, -1), fin(cx, 66, 18, 1)], G, depth=4, outline=OUT),
         Layer([pinched(lute_body(cx, 38, 40, 48), cx, 62, 0.12)], G, depth=6, outline=OUT),
         Layer([pinched(lute_body(cx, 38, 40, 48, inset=2.4), cx, 62, 0.12)], G_LIGHT, depth=9, outline=(110, 110, 116)),
         Layer([ribbon([(cx, 41), (cx, 27)], 2.6, 2.2), ribbon([(cx, 28.5), (cx + 4, 22)], 2.6, 2.4), curl(cx + 7, 19, 4.6, 200)],
               G_DARK, depth=2, outline=OUT)]
    img = compose(L)
    rosette(img, cx, 67, 7.0, centre=GLOW)
    for xb, xt in ((-4, -1.5), (0, 0), (4, 1.5)):
        paint(img, line_mask([(cx + xb + 0.5, 79), (cx + xt + 0.5, 30)], 0.9), STRING)
    paint(img, {(x, y) for x in range(cx - 7, cx + 8) for y in (79, 80)}, (50, 50, 56))
    painted_face(img, cx, 50.5, 1.0, 0.0)
    paint(img, line_mask([(cx + 11, 62), (cx + 12.5, 65), (cx + 11, 68), (cx + 12.5, 71)], 1.1), GLOW)
    return drop_to_ground(img, 88)


def v2():
    cx, top, h = 44, 34, 50
    sweep = bezier((cx + 6, top - 12), (cx + 34, top - 6), (cx + 38, top + 34), (cx + 8, top + h + 4), 30)
    end = sweep[-1]
    seam = [(cx + 12, top + 8), (cx + 15, top + 14), (cx + 12, top + 20), (cx + 16, top + 26)]
    L = [Layer([ribbon([(cx - 22, top + 46), (cx - 6, top - 4)], 0.9, 0.9)], G_DARK, depth=1, outline=OUT, clean=False, threshold=0.4),
         Layer([cello_body(cx, top, h, 14.5, 18.5, 10)], G, depth=10, outline=OUT),
         Layer([ellipse_pts(cx + 15, top + 17, 4.0, 6.5, 30)], SPIRIT, depth=3, outline=SPIRIT_OUT),     # pushing through the seam
         Layer([ribbon([(cx, top + 2), (cx, top - 10)], 2.4, 2.2), curl(cx + 3.6, top - 14, 4.6, 200)], G_DARK, depth=2, outline=OUT)]
    img = compose(L)
    # the slipped strings: a bold arc (the harp's triangle to come)
    for k, off in enumerate((0.0, 2.2, 4.4)):
        arc = bezier((cx + 6, top - 12), (cx + 34 + off, top - 6 + off), (cx + 38 + off, top + 34), (cx + 8, top + h + 4), 40)
        paint(img, line_mask(arc, 0.8), (96, 96, 104) if k != 1 else (130, 130, 138))
    paint(img, line_mask(spiral(end[0] + 3, end[1] - 1, 3.0, 0.9, 180, shrink=0.6, n=20), 1.0), (96, 96, 104))
    gold_tip(img, end[0] + 3, end[1] - 4)
    rosette(img, cx, top + 34, 8.5, centre=GLOW)
    for side in (-1, 1):
        f = [(cx + side * 9, top + 24), (cx + side * 10.5, top + 28), (cx + side * 9, top + 32), (cx + side * 10.5, top + 36)]
        paint(img, line_mask(f, 1.4), GLOW)
    paint(img, line_mask(seam, 1.3), GLOW)
    for k in (-1.5, 1.5):
        paint(img, line_mask([(cx + k * 1.6, top + 44), (cx + k * 0.6, top - 8)], 0.8), STRING)
    painted_face(img, cx, top + 12, 1.0, 0.45)
    return drop_to_ground(img, 92)


def v3():
    pillar = ribbon(bezier((40, 90), (28, 72), (24, 46), (28, 26), 24), 3.0, 2.6)
    neck_path = bezier((28, 24), (44, 40), (60, 6), (80, 14), 34)
    spine_out = bezier((80, 14), (84, 40), (76, 66), (60, 90), 24)
    spine_in = bezier((50, 88), (64, 66), (72, 40), (74, 16), 24)
    box = spine_out + [(56, 94), (48, 93)] + spine_in
    foot = ribbon(bezier((36, 91), (42, 95), (50, 95), (56, 92), 10), 2.4, 2.6)
    lock1 = bezier((18, 22), (0, 26), (-2, 46), (8, 58), 30)
    lock2 = bezier((20, 28), (6, 42), (12, 64), (2, 80), 30)
    L = [Layer([ribbon(lock2, 3.4, 0.9)], SPIRIT, depth=2, outline=SPIRIT_OUT),
         Layer([box], G, depth=5, outline=OUT),
         Layer([pillar, ribbon(neck_path, 2.8, 3.0), curl(84, 12, 4.0, 270, w=2.6), foot], G_DARK, depth=2, outline=OUT),
         Layer([ribbon(lock1, 4.2, 1.2)], SPIRIT, depth=2, outline=SPIRIT_OUT),
         Layer([ellipse_pts(26, 20, 10.5, 9.5, 48)], SPIRIT, depth=7, outline=SPIRIT_OUT),
         Layer([curl(30, 9.5, 5.4, 200, w=3.0)], G_DARK, depth=2, outline=OUT)]
    img = compose(L)
    # strings across the open frame: fine, so the triangle stays open; two snapped (they're the hair)
    for i in range(10):
        t = 0.12 + i * 0.085
        a = neck_path[int(t * (len(neck_path) - 1))]
        b = spine_in[int((1 - t) * (len(spine_in) - 1) * 0.92)]
        if i in (1, 5):
            continue
        paint(img, line_mask([a, b], 0.6), (160, 160, 168))
    # the rosette carved in the soundbox, glowing from inside; the box splitting with light
    rosette(img, 70, 60, 5.6, colour=GLOW, centre=(255, 240, 255))
    paint(img, line_mask([(78, 30), (74, 40), (78, 48)], 1.2), GLOW)
    paint(img, line_mask([(66, 74), (62, 80), (65, 86)], 1.2), GLOW)
    # glow cracks where the spirit bursts out of the top of the pillar
    paint(img, line_mask([(28, 30), (30, 36), (27, 40)], 1.2), GLOW)
    painted_face(img, 26, 18, 0.62, 0.6, colour=(40, 16, 56))
    for (x, y) in (lock1[-1], lock2[-1]):
        gold_tip(img, x, y)
    return drop_to_ground(img, 94)


if __name__ == "__main__":
    s = Image.new("RGB", (330, 116), (236, 232, 222))
    d = ImageDraw.Draw(s)
    for i, (fn, label) in enumerate(((v1, "1. lute"), (v2, "2. cello"), (v3, "3. harp"))):
        bg = Image.new("RGBA", (96, 96), (236, 232, 222, 255)); bg.alpha_composite(fn())
        s.paste(bg.convert("RGB"), (i * 110 + 6, 4))
        d.text((i * 110 + 8, 102), label, fill=(40, 30, 40))
    s.resize((s.width * 3, s.height * 3), Image.NEAREST).save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/values.png")
