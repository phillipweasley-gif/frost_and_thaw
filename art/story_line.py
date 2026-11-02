"""Value study: the possession grows; the instrument swells to hold it.
Lutling (lute) -> Hauntello (cello) -> final (harp). Greys only; the spirit is the one colour."""
import math
from PIL import Image, ImageDraw
from clean import *
from hires import bezier, spiral
from lutling2 import lute_body, fin
from orchestra import cello_body

G = [(70, 70, 76), (104, 104, 110), (140, 140, 146), (176, 176, 182)]      # wood, in value
G_DARK = [(40, 40, 46), (60, 60, 66), (84, 84, 90), (110, 110, 116)]
G_LIGHT = [(150, 150, 156), (178, 178, 184), (204, 204, 210), (226, 226, 230)]
OUT = (24, 24, 28)
SPIRIT = [(96, 44, 150), (140, 80, 200), (188, 130, 240), (230, 196, 255)]
SPIRIT_OUT = (52, 18, 84)
GLOW = (214, 160, 255)


def tilt(pts, ang, ox, oy):
    c, s = math.cos(ang), math.sin(ang)
    return [(ox + (x - ox) * c - (y - oy) * s, oy + (x - ox) * s + (y - oy) * c) for x, y in pts]


GOLD = (226, 184, 96)


def rosette(img, cx, cy, r, colour=GOLD, centre=None):
    """The line's iconic mark: an eight-petal rosette (a lute's carved soundhole)."""
    petals = []
    for k in range(8):
        a = math.radians(k * 45)
        petals.append(ellipse_pts(cx + math.cos(a) * r * 0.55, cy + math.sin(a) * r * 0.55, r * 0.42, r * 0.42, 16))
    paint(img, to_mask(smooth_poly_mask(petals), 0.45, False), colour)
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(cx, cy, r * 0.42, r * 0.42, 16)]), 0.4, False), centre or (40, 30, 46))


def gold_tip(img, x, y):
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(x, y, 1.8, 1.8, 14)]), 0.35, False), GOLD)


def painted_face(img, cx, y, scale=1.0, grin=0.0, colour=(40, 40, 44)):
    """The bard's painted face: arched happy eyes and a smile that stretches into a grin."""
    for ex in (cx - 9.5 * scale, cx + 9.5 * scale):
        paint(img, line_mask(ellipse_pts(ex, y, 3.2 * scale, 2.6 * scale, 24, 200, 340), 1.3), colour)
    w = 5.6 * scale * (1 + grin)
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(cx, y + 5 * scale, w, 4.2 * scale, 32, 0, 180)]), 0.45, False), colour)


# ---- stage 1: the lute, whole and happy; a seed of violet in the rosette ---------
def pinched(pts, cx, y_mid, amount):
    """Pull the sides in around y_mid: the lute starting to take a cello's waist."""
    out = []
    for x, y in pts:
        k = math.exp(-((y - y_mid) / 6.0) ** 2) * amount
        out.append((x - (x - cx) * k, y))
    return out


def stage1():
    cx, top, w, h = 48, 38, 40, 48
    bow = ribbon([(66, 84), (80, 56)], 0.6, 0.6)
    layers = [Layer([bow], G_DARK, depth=1, outline=OUT, clean=False, threshold=0.4),
              Layer([fin(cx, 66, 18, -1), fin(cx, 66, 18, 1)], G, depth=4, outline=OUT),
              Layer([pinched(lute_body(cx, top, w, h), cx, 62, 0.12)], G, depth=6, outline=OUT),
              Layer([pinched(lute_body(cx, top, w, h, inset=2.4), cx, 62, 0.12)], G_LIGHT, depth=9, outline=(110, 110, 116)),
              Layer([ribbon([(cx, 41), (cx, 27)], 2.6, 2.2), ribbon([(cx, 28.5), (cx + 5, 21.5), (cx + 11.5, 18)], 2.7, 2.4)], G_DARK, depth=2, outline=OUT)]
    img = compose(layers)
    rosette(img, cx, 67, 7.0, centre=GLOW)                                           # the seed, in the rosette
    for xb, xt in ((-4, -1.5), (0, 0), (4, 1.5)):
        paint(img, line_mask([(cx + xb + 0.5, 79), (cx + xt + 0.5, 30)], 0.9), (230, 230, 234))
    painted_face(img, cx, 50.5, 1.0, 0.0)
    # the first crack, already shaped like a cello's f-hole, with light inside
    paint(img, line_mask([(cx + 11, 62), (cx + 12.5, 65), (cx + 11, 68), (cx + 12.5, 71)], 1.1), GLOW)
    return drop_to_ground(img, 88)


# ---- stage 2: swollen into a cello that still has the lute's pegbox and rosette ---
def stage2():
    cx, top, h = 46, 32, 52
    ang = math.radians(-7)
    T = lambda p: tilt(p, ang, cx, top + h / 2)
    body = T(cello_body(cx, top, h, 15, 19.5, 10.5))
    seam = T([(cx + 12, top + 6), (cx + 15, top + 12), (cx + 12, top + 18), (cx + 16, top + 24)])
    neck = T([(cx, top + 3), (cx, top - 12)])
    pegbox = T([(cx, top - 11), (cx + 4, top - 19), (cx + 10, top - 22), (cx + 14, top - 19)])   # the lute's pegbox, curling like a harp's neck
    loose = []
    # strings that have slipped off: strung outside the body from the curling pegbox down to the endpin,
    # already making a harp's triangle on one side
    head = T([(cx + 13, top - 20)])[0]
    foot = T([(cx + 2, top + h + 2)])[0]
    for k in range(4):
        side_x = 20 + k * 3
        mid = T([(cx + side_x, top + 10 + k * 8)])[0]
        loose.append(ribbon(bezier(head, (head[0] + 8 + k * 2, head[1] + 8), mid, foot, 22), 0.6, 0.6))
    # one string still curling free
    r, a1, b1, e = T([(cx - 2, top - 12), (cx - 16, top - 14), (cx - 22, top + 4), (cx - 16, top + 14)])
    pts = bezier(r, a1, b1, e, 20)
    pts += spiral(pts[-1][0] + 2.2, pts[-1][1], 2.2, 0.75, 180, shrink=0.5, n=12)[1:]
    loose.append(ribbon(pts, 0.8, 0.9))
    bulge = [ellipse_pts(*T([(cx + 15, top + 16)])[0], 4.5, 7.5, 30)]
    pop = [ellipse_pts(*T([(cx + 13, top - 24)])[0], 1.6, 1.6, 12), ellipse_pts(*T([(cx - 6, top - 22)])[0], 1.4, 1.4, 12)]
    layers = [Layer([body], G, depth=10, outline=OUT),
              Layer(bulge, SPIRIT, depth=4, outline=SPIRIT_OUT),
              Layer(loose, [(70, 70, 78)] * 4, depth=1, outline="none", flat=True, clean=False, threshold=0.38),
              Layer([ribbon(neck, 2.4, 2.2), ribbon(pegbox, 2.6, 2.4)], G_DARK, depth=2, outline=OUT),
              Layer(pop, G_LIGHT, depth=1, outline=OUT, clean=False, threshold=0.4)]
    img = compose(layers)
    # the lute's rosette, stretched across the belly; glow leaking through it, the f-holes and a split seam
    rc = T([(cx, top + 34)])[0]
    rosette(img, rc[0], rc[1], 8.0, centre=GLOW)
    for side in (-1, 1):
        f = T([(cx + side * 9, top + 24), (cx + side * 10.5, top + 28), (cx + side * 9, top + 32), (cx + side * 10.5, top + 36)])
        paint(img, line_mask(f, 1.4), GLOW)
    paint(img, line_mask(seam, 1.6), GLOW)
    for k in (-1.5, 1.5):
        paint(img, line_mask(T([(cx + k * 1.6, top + 44), (cx + k * 0.6, top - 10)]), 0.8), (220, 220, 224))
    gold_tip(img, *pts[-1])
    face_c = T([(cx, top + 12)])[0]
    painted_face(img, face_c[0], face_c[1], 1.0, 0.45)                             # the painted smile, stretched
    return drop_to_ground(img, 92)


# ---- stage 3: a harp; the spirit has burst out and fills the frame -------------
def stage3():
    base_y = 88
    pillar = ribbon([(24, base_y - 2), (24, 14)], 2.6, 2.2)
    crown = ribbon([(24, 15), (28, 9), (34, 6)], 2.8, 2.4)                          # the lute's pegbox, now the crown
    neck = ribbon(bezier((24, 14), (40, 26), (54, 4), (78, 16), 30), 2.4, 2.8)
    box = [(70, 14), (82, 18), (66, base_y), (52, base_y)]                          # soundbox, wider at the bottom
    split = [(76, 22), (70, 40), (74, 52), (64, 72), (62, 84)]
    feet = ribbon([(18, base_y), (70, base_y)], 2.2, 2.2)
    # the spirit: a rounded body bursting up and out of the frame, tapering to a wisp below
    spirit = [closed_spirit()]
    tents, tips = [], []
    for root, c1, c2, end in (((38, 30), (28, 22), (12, 26), (8, 16)), ((62, 74), (78, 82), (90, 72), (88, 60)),
                              ((32, 62), (16, 66), (8, 58), (6, 68))):
        pts = bezier(root, c1, c2, end, 20)
        pts += spiral(pts[-1][0] + 2.2, pts[-1][1], 2.2, 0.75, 180, shrink=0.5, n=12)[1:]
        tents.append(ribbon(pts, 1.2, 0.9))
        tips.append(end)
    layers = [Layer(spirit, SPIRIT, depth=12, outline=SPIRIT_OUT),
              Layer(tents, SPIRIT, depth=1, outline=SPIRIT_OUT, clean=False, threshold=0.4),
              Layer([box], G, depth=5, outline=OUT),
              Layer([pillar, crown, neck], G_DARK, depth=2, outline=OUT),
              Layer([feet], G_DARK, depth=1, outline=OUT, clean=False, threshold=0.45)]
    img = compose(layers)
    paint(img, line_mask(split, 2.0), GLOW)
    # strings stretched over the spirit, from the neck down to the soundbox
    for i in range(9):
        t = (i + 1) / 10
        top_pt = bezier((24, 14), (40, 26), (54, 4), (78, 16), 30)[int(t * 30)]
        bx = 56 + 14 * (1 - t)
        by = base_y - 6 - 66 * t
        if i in (2, 6):
            continue                                                                  # snapped (they're the tentacles)
        paint(img, line_mask([top_pt, (bx, by)], 0.7), (232, 232, 236))
    # the rosette carved on the soundbox, and the painted face now huge on the spirit
    paint(img, line_mask(ellipse_pts(64, 70, 3.4, 3.4, 20), 1.0), (60, 50, 70))
    rosette(img, 46, 58, 9.0, colour=GOLD, centre=(255, 236, 255))                  # the rosette, now its heart
    painted_face(img, 46, 34, 1.15, 0.7, colour=(40, 16, 56))
    for (x, y) in tips:
        gold_tip(img, x, y)
    return drop_to_ground(img, 92)


def closed_spirit():
    """Spirit silhouette: a big round crown bulging above the harp's neck, a body filling the frame, a wisp tail."""
    from hires import bezier as bz
    pts = []
    pts += bz((46, 76), (24, 74), (18, 50), (26, 30), 16)
    pts += bz((26, 30), (26, -6), (68, -8), (66, 28), 16)[1:]
    pts += bz((66, 28), (72, 46), (66, 70), (52, 74), 16)[1:]
    pts += bz((52, 74), (50, 82), (56, 86), (50, 92), 10)[1:]
    pts += bz((50, 92), (44, 86), (48, 80), (46, 76), 10)[1:]
    return pts


if __name__ == "__main__":
    s = Image.new("RGB", (330, 120), (236, 232, 222))
    d = ImageDraw.Draw(s)
    for i, (fn, label) in enumerate(((stage1, "1. lute: a seed of light"), (stage2, "2. swollen into a cello"), (stage3, "3. bursts out: a harp"))):
        im = fn()
        bg = Image.new("RGBA", (96, 96), (236, 232, 222, 255)); bg.alpha_composite(im)
        s.paste(bg.convert("RGB"), (i * 110 + 6, 4))
        d.text((i * 110 + 6, 104), label, fill=(40, 30, 40))
    s.resize((s.width * 3, s.height * 3), Image.NEAREST).save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/story_values.png")
