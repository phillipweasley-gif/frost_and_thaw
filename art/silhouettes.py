"""Two-value silhouettes for the line, designed to read at a glance."""
import math
from PIL import Image, ImageDraw
from clean import ellipse_pts, ribbon, smooth_poly_mask, to_mask, N
from hires import bezier, spiral
from lutling2 import lute_body, fin
from orchestra import cello_body


def curl(x, y, r, start, cw=True, w=2.4):
    return ribbon(spiral(x, y, r, 0.9, start, shrink=0.6, n=30, clockwise=cw), w, w * 0.45)


def s1():
    cx = 48
    return [lute_body(cx, 38, 40, 48), fin(cx, 66, 18, -1), fin(cx, 66, 18, 1),
            ribbon([(cx, 41), (cx, 27)], 2.6, 2.2), ribbon([(cx, 28.5), (cx + 4, 22)], 2.6, 2.4), curl(cx + 7, 19, 4.6, 200)]


def s2():
    cx, top, h = 44, 34, 50
    body = cello_body(cx, top, h, 14.5, 18.5, 10)
    parts = [body, ribbon([(cx, top + 2), (cx, top - 10)], 2.4, 2.2), curl(cx + 3.6, top - 14, 4.6, 200)]
    # one bold sweep of slipped strings arching out to the right (the harp's triangle to come)
    sweep = bezier((cx + 6, top - 12), (cx + 34, top - 6), (cx + 38, top + 34), (cx + 8, top + h + 4), 30)
    parts.append(ribbon(sweep, 1.2, 1.2))
    parts.append(ribbon(sweep[6:24], 0.0 + 1.0, 1.0))
    end = sweep[-1]
    parts.append(curl(end[0] + 3, end[1] - 1, 3.0, 180, w=1.4))
    # the bow, held like a baton on the other side
    parts.append(ribbon([(cx - 22, top + 46), (cx - 6, top - 4)], 0.9, 0.9))
    return parts


def s3():
    # a Celtic harp: forepillar bowed outward, a deep swooping neck ending in a curl,
    # a soundbox curving like a bow and swelling at the base; triangle kept open
    pillar = ribbon(bezier((40, 90), (28, 72), (24, 46), (28, 26), 24), 3.0, 2.6)
    neck_path = bezier((28, 24), (44, 40), (60, 6), (80, 14), 34)
    neck = ribbon(neck_path, 2.8, 3.0)
    neck_curl = curl(84, 12, 4.0, 270, w=2.6)
    spine_out = bezier((80, 14), (84, 40), (76, 66), (60, 90), 24)
    spine_in = bezier((50, 88), (64, 66), (72, 40), (74, 16), 24)
    box = spine_out + [(56, 94), (48, 93)] + spine_in
    foot = ribbon(bezier((36, 91), (42, 95), (50, 95), (56, 92), 10), 2.4, 2.6)
    # the figurehead spirit at the top of the forepillar, crowned with the curl
    head = ellipse_pts(26, 20, 10.5, 9.5, 48)
    crown = curl(31, 4, 6.0, 200, w=3.0)
    # broad hair-locks (snapped strings) sweeping out to the left, long and asymmetric
    lock1 = ribbon(bezier((18, 22), (0, 26), (-2, 46), (8, 58), 30), 4.2, 1.2)
    lock2 = ribbon(bezier((20, 28), (6, 42), (12, 64), (2, 80), 30), 3.4, 0.9)
    tip = curl(11, 60, 3.0, 0, cw=False, w=1.6)
    return [pillar, neck, neck_curl, box, foot, head, crown, lock1, lock2, tip]


if __name__ == "__main__":
    cell = 120
    sheet = Image.new("RGB", (cell * 3, cell + 20), (236, 232, 222))
    d = ImageDraw.Draw(sheet)
    for i, (fn, label) in enumerate(((s1, "1. lute"), (s2, "2. cello"), (s3, "3. harp + figurehead spirit"))):
        m = to_mask(smooth_poly_mask(fn()), 0.5)
        im = Image.new("RGB", (N, N), (236, 232, 222))
        for (x, y) in m:
            if 0 <= x < N and 0 <= y < N:
                im.putpixel((x, y), (28, 24, 34))
        sheet.paste(im.resize((cell - 8, cell - 8), Image.NEAREST), (i * cell + 4, 4))
        d.text((i * cell + 8, cell + 2), label, fill=(40, 30, 40))
    sheet.resize((sheet.width * 3, sheet.height * 3), Image.NEAREST).save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/sil2.png")
