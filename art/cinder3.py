"""Cinderwright stand-ins, coloured on the anatomy silhouettes (cinder_anatomy.py).
Stoat colouring: russet above, cream throat-to-belly with a clean side line; soot paws.
Porcelain = glazed white shell with a rim, cobalt underglaze, a hard gloss streak.
Steel = burnished, cool highlights, copper edges; the anvil has a bright flat face and a horn."""
import math
from PIL import Image
from clean import paint, to_mask, smooth_poly_mask, ellipse_pts, outline_of, thin_line_mask, selout, cleanup_clusters, drop_to_ground, N
from hires import bezier
from sculpt import Part, render
from cinder_anatomy import E, tube, claws
from cinder import EMBER, CLAY, CLAY_O, IRIS
import final_line as F

RUSSET = [(88, 34, 24), (134, 58, 34), (178, 90, 48), (214, 126, 72), (238, 166, 112)]
CREAM = [(204, 168, 124), (230, 204, 162), (246, 228, 194), (255, 246, 222)]
SOOT = [(24, 20, 24), (44, 36, 38), (66, 56, 54), (92, 80, 74)]
PORC = [(160, 170, 190), (204, 212, 228), (232, 238, 246), (252, 253, 255)]
COBALT, COBALT_LT = (32, 60, 148), (82, 118, 204)
STEEL = [(36, 38, 50), (60, 62, 78), (94, 96, 114), (140, 142, 158), (196, 200, 214)]
COPPER = [(112, 54, 28), (170, 92, 48), (214, 136, 78), (244, 188, 130)]
CUTS5 = (-0.25, 0.1, 0.42, 0.72)
CUTS4 = (-0.2, 0.3, 0.68)


def eye(img, cx, cy, w, h):
    m = to_mask(smooth_poly_mask([ellipse_pts(cx, cy, w, h, 24)]), 0.42, False)
    paint(img, m, (34, 16, 12))
    paint(img, {(x, y) for (x, y) in m if y >= cy + h * 0.35 and abs(x - cx) <= w * 0.6}, IRIS)
    paint(img, outline_of(m), (18, 6, 4))
    hx, hy = int(round(cx - w * 0.3)), int(round(cy - h * 0.3))
    paint(img, {(hx, hy)} | ({(hx, hy + 1)} if h >= 2.6 else set()), (255, 255, 255))


def nose(img, x, y):
    paint(img, {(int(x), int(y)), (int(x) + 1, int(y)), (int(x), int(y) + 1)}, (40, 20, 18))


def whiskers(img, x, y, n=2, length=4, colour=(250, 236, 214)):
    for i in range(n):
        paint(img, thin_line_mask([(x, y + i * 1.5), (x - length, y - 0.6 + i * 2.2)], 0.6), colour)


def notch(img, x, y):
    px = img.load()
    col = [yy for yy in range(N) if px[int(x), yy][3] > 0]
    if col:
        t = min(col)
        for p in ((int(x), t), (int(x), t + 1), (int(x) + 1, t)):
            px[p] = (0, 0, 0, 0)


def ember_line(img, pts, w=0.9):
    m = thin_line_mask(pts, w)
    F.halo(img, m, EMBER[1], 110)
    paint(img, m, EMBER[2])
    return m


def glaze(img, mask):
    """Porcelain: a cobalt band inside the rim, a little painted flower, a hard gloss streak."""
    px = img.load()
    mask = {p for p in mask if px[p][3] and px[p][:3] in PORC}
    if not mask:
        return
    edge = {p for p in mask if any((p[0] + dx, p[1] + dy) not in mask for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))}
    core = mask - edge
    if len(mask) >= 40:
        paint(img, {p for p in edge if (p[0] * 2 + p[1]) % 5 != 0}, COBALT_LT)
    if core:
        cx = sum(x for x, _ in core) / len(core); cy = sum(y for _, y in core) / len(core)
        c = (int(round(cx)), int(round(cy)))
        paint(img, {(c[0] + dx, c[1] + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))} & core, COBALT_LT)
        paint(img, {c} & core, COBALT)
        top = min(core, key=lambda p: p[0] + p[1])
        paint(img, {top, (top[0] + 1, top[1])} & core, (255, 255, 255))     # the gloss


# =================================================================================================
def wickit():
    feet = [E(43, 89, 6.5, 2.2), E(53, 89, 5.5, 2.0)]
    hips = [E(48, 82, 7.5, 6.5)]
    body = tube(bezier((48, 82), (49, 72), (47, 64), (45, 58), 16), [6.8, 6.0, 5.4])
    neck = tube([(45, 58), (43, 52)], [4.6, 4.2])
    skull = [E(42, 47, 8.4, 7.2, -8)]
    muzzle = [E(34.5, 49.5, 4.6, 3.4, -10)]
    ear_far, ear_near = [E(48.5, 42.5, 2.8, 2.8)], [E(37.5, 41.2, 2.4, 2.4)]
    arms = tube([(44, 59), (41, 63), (39, 64)], [2.2, 2.0, 1.8])
    paws = [E(38.6, 64.6, 2.2, 1.8)]
    tail = tube(bezier((54, 86), (70, 92), (76, 74), (62, 52), 30), [2.6, 2.6, 2.3, 2.0])
    wick = [E(61.5, 51, 2.6, 3.4)]
    belly = [[(36, 52), (44, 54), (46, 60), (46, 70), (47, 80), (42, 84), (38, 76), (38, 62)]]
    chin = [E(36, 52, 5, 3), E(40, 54, 4, 3)]
    parts = [
        Part(tail, RUSSET, depth=3, cuts=CUTS5, shadow=None),
        Part(ear_far, RUSSET, depth=2, cuts=CUTS5, shadow=None),
        Part(hips + body + neck, RUSSET, depth=7, cuts=CUTS5, regions=[(belly, CREAM)], shadow=None),
        Part(feet, SOOT, depth=2, cuts=CUTS4, shadow=(0, -1)),
        Part(arms + paws, RUSSET, depth=2, cuts=CUTS5, regions=[(paws + tube([(40, 63), (39, 64)], [1.9, 1.8]), SOOT)], shadow=(1, 1)),
        Part(skull + muzzle, RUSSET, depth=7, cuts=CUTS5, regions=[(muzzle + chin, CREAM)], shadow=(0, 2)),
        Part(ear_near, RUSSET, depth=2, cuts=CUTS5, shadow=None),
        Part(wick, EMBER, depth=3, cuts=(-0.3, 0.2, 0.6), outline=(150, 70, 14), shadow=None),
    ]
    img = cleanup_clusters(render(parts))
    for (x, y, r) in ((37.6, 41.6, 1.2), (48.6, 43, 1.4)):
        paint(img, to_mask(smooth_poly_mask([E(x, y, r, r)]), 0.4, False), CREAM[1])
    eye(img, 37.6, 46.6, 1.7, 2.2)
    eye(img, 44.2, 45.6, 1.9, 2.5)
    nose(img, 30, 48)
    paint(img, thin_line_mask([(31.5, 51.2), (34, 51.6)], 0.7), (110, 56, 34))
    whiskers(img, 33, 50.2, 2, 4)
    F.halo(img, parts[-1].mask, EMBER[2], 150)
    paint(img, to_mask(smooth_poly_mask([E(61.4, 50.4, 1.2, 1.8)]), 0.35, False), EMBER[3])
    notch(img, 49, 0)
    return drop_to_ground(selout(img), 90)


def stoketail():
    feet = [E(40, 89, 8.0, 2.4), E(53, 89, 7.0, 2.2)]
    hips = [E(47, 79, 9.0, 8.0)]
    body = tube(bezier((47, 79), (48, 66), (46, 54), (42, 45), 18), [8.2, 7.4, 6.6])
    neck = tube([(42, 45), (38, 37)], [5.0, 4.6])
    skull = [E(36, 31, 7.6, 6.2, -12)]
    muzzle = [E(28.5, 34, 4.4, 3.0, -14)]
    ear_far, ear_near = [E(41.5, 26.5, 2.6, 2.6)], [E(32.5, 25.5, 2.2, 2.2)]
    arm_f = tube([(46, 50), (40, 56), (34, 56)], [3.2, 2.9, 2.6])
    paw_f = [E(32.5, 56, 2.8, 2.2)] + claws(31, 56, 3, 2.6, 22, 180)
    arm_n = tube([(41, 48), (35, 53), (29, 51)], [3.6, 3.2, 2.8])
    paw_n = [E(27, 50.5, 3.0, 2.4, -20)] + claws(25.5, 50.5, 3, 3.0, 22, 190)
    tail = tube(bezier((54, 84), (64, 90), (70, 89), (76, 88), 20), [5.0, 4.4, 3.6])
    paddle = [[(72, 86.2), (80, 85.0), (88, 85.6), (93, 87.6), (88, 90.0), (80, 90.6), (72, 90.0)]]
    belly = [[(31, 36), (40, 38), (44, 46), (44, 62), (46, 76), (40, 84), (37, 72), (37, 50)]]
    chin = [E(31, 36, 4.6, 2.8), E(36, 38, 4, 3)]
    shoulder = [E(45.5, 46.5, 6.6, 5.2, 30)]
    guard_n = [E(33.2, 51.6, 4.0, 3.0, -25)]
    guard_f = [E(37.8, 55.6, 3.4, 2.6, 0)]
    parts = [
        Part(tail + paddle, RUSSET, depth=3, cuts=CUTS5, shadow=None),
        Part(ear_far, RUSSET, depth=2, cuts=CUTS5, shadow=None),
        Part(arm_f + paw_f, RUSSET, depth=2, cuts=CUTS5, regions=[(paw_f, SOOT)], shadow=None),
        Part(guard_f, PORC, depth=2, cuts=CUTS4, outline=(70, 80, 108), shadow=None),
        Part(hips + body + neck, RUSSET, depth=7, cuts=CUTS5, regions=[(belly, CREAM)], shadow=(0, 1)),
        Part(feet, SOOT, depth=2, cuts=CUTS4, shadow=(0, -1)),
        Part(shoulder, PORC, depth=3, cuts=CUTS4, outline=(70, 80, 108), shadow=(1, 1)),
        Part(arm_n + paw_n, RUSSET, depth=2, cuts=CUTS5, regions=[(paw_n, SOOT)], shadow=(1, 1)),
        Part(guard_n, PORC, depth=2, cuts=CUTS4, outline=(70, 80, 108), shadow=None),
        Part(skull + muzzle, RUSSET, depth=6, cuts=CUTS5, regions=[(muzzle + chin, CREAM)], shadow=(0, 2)),
        Part(ear_near, RUSSET, depth=2, cuts=CUTS5, shadow=None),
    ]
    img = cleanup_clusters(render(parts))
    for i in (3, 6, 8):
        glaze(img, parts[i].mask)
    for (x, y, r) in ((32.6, 25.9, 1.1), (41.6, 27, 1.3)):
        paint(img, to_mask(smooth_poly_mask([E(x, y, r, r)]), 0.4, False), CREAM[1])
    eye(img, 32, 30.4, 1.6, 2.1)
    eye(img, 38.4, 29.4, 1.8, 2.4)
    nose(img, 24, 32.5)
    paint(img, thin_line_mask([(25.6, 35.6), (28.6, 36)], 0.7), (110, 56, 34))
    whiskers(img, 27, 34.4, 2, 4)
    # the paddle: darker flanges, a glowing seam along the underside, cooling sparks
    paint(img, thin_line_mask([(74, 87.4), (82, 86.6), (90, 87.4)], 0.7), RUSSET[1])
    ember_line(img, [(73, 90.0), (80, 90.6), (88, 90.0), (92, 88.4)], 0.8)
    for (x, y) in ((86, 82), (91, 80)):
        paint(img, {(x, y)}, EMBER[3])
    notch(img, 42, 0)
    return drop_to_ground(selout(img), 91)


def forgel():
    feet = [E(42, 90, 9.5, 3.0), E(62, 90, 8.5, 2.8)]
    hips = [E(52, 76, 15.0, 13.0)]
    body = tube(bezier((52, 76), (52, 60), (49, 48), (46, 40), 18), [14.0, 13.0, 12.0])
    neck = tube([(46, 40), (43, 31)], [9.5, 8.8])
    skull = [E(41, 24, 10.5, 8.0, -6)]
    muzzle = [E(31, 27, 5.2, 4.0, -8)]
    ear_far, ear_near = [E(48.5, 18.5, 3.2, 3.2)], [E(35.5, 17.5, 2.8, 2.8)]
    arm_f = tube([(50, 46), (46, 56), (42, 61)], [5.6, 5.0, 4.6])
    paw_f = [E(40.5, 63, 5.4, 4.2)] + claws(37, 65, 4, 3.4, 20, 150)
    arm_n = tube([(40, 44), (28, 50), (17, 46)], [6.4, 5.8, 5.2])
    paw_n = [E(14, 42, 6.8, 6.0, -25)] + claws(10.5, 37.5, 4, 4.4, 20, 235)
    tail = tube(bezier((64, 86), (82, 88), (78, 96), (46, 90), 26), [8.0, 7.0, 6.0])
    anvil = [[(18, 84.5), (36, 84.0), (40, 85.0), (40, 90.6), (24, 91.0), (14, 88.2), (6, 86.6), (16, 86.4)]]
    belly = [[(32, 30), (44, 34), (46, 46), (44, 62), (48, 82), (40, 86), (38, 70), (36, 48)]]
    chin = [E(32, 30, 5.6, 3.4), E(38, 33, 5, 3.4)]
    plate_sh = [ribbon_poly(bezier((44, 33), (54, 33), (60, 40), (60, 48), 14), 4.6, 3.6)]
    plate_hip = [ribbon_poly(bezier((60, 60), (66, 64), (67, 72), (64, 80), 14), 4.2, 3.4)]
    plate_arm = [ribbon_poly([(33, 47), (23, 48)], 3.8, 3.4)]
    bowl = [E(26, 82.2, 4.2, 2.4, -6)]
    parts = [
        Part(feet[1:], SOOT, depth=2, cuts=CUTS4, shadow=None),
        Part(tail, RUSSET, depth=4, cuts=CUTS5, shadow=None),
        Part(anvil, STEEL, depth=3, cuts=(-0.25, 0.1, 0.4, 0.7), outline=COPPER[0], shadow=None),
        Part(ear_far, RUSSET, depth=2, cuts=CUTS5, shadow=None),
        Part(arm_f + paw_f, RUSSET, depth=3, cuts=CUTS5, regions=[(paw_f, SOOT)], shadow=None),
        Part(hips + body + neck, RUSSET, depth=10, cuts=CUTS5, regions=[(belly, CREAM)], shadow=(0, 1)),
        Part(plate_sh + plate_hip, STEEL, depth=3, cuts=(-0.25, 0.1, 0.4, 0.7), outline=COPPER[1], shadow=(1, 1)),
        Part(feet[:1], SOOT, depth=2, cuts=CUTS4, shadow=(0, -1)),
        Part(arm_n + paw_n, RUSSET, depth=4, cuts=CUTS5, regions=[(paw_n, SOOT)], shadow=(1, 1)),
        Part(plate_arm, STEEL, depth=2, cuts=(-0.25, 0.1, 0.4, 0.7), outline=COPPER[1], shadow=None),
        Part(skull + muzzle, RUSSET, depth=7, cuts=CUTS5, regions=[(muzzle + chin, CREAM)], shadow=(0, 2)),
        Part(ear_near, RUSSET, depth=2, cuts=CUTS5, shadow=None),
        Part(bowl, CLAY, depth=2, cuts=CUTS4, outline=CLAY_O, shadow=(0, 1)),
    ]
    img = cleanup_clusters(render(parts))
    for (x, y, r) in ((35.6, 18, 1.4), (48.6, 19, 1.6)):
        paint(img, to_mask(smooth_poly_mask([E(x, y, r, r)]), 0.4, False), CREAM[1])
    eye(img, 34.6, 22.6, 1.9, 2.4)
    eye(img, 42.2, 21.6, 2.1, 2.7)
    nose(img, 26, 25.5)
    paint(img, thin_line_mask([(27.6, 29.4), (31, 29.8)], 0.7), (110, 56, 34))
    whiskers(img, 29, 28.2, 3, 5)
    # copper inner edge on the plates, furnace glow in the gap under the shoulder plate
    ember_line(img, bezier((43, 37.6), (51, 38), (56, 43), (56, 50), 12), 0.8)
    # the bright flat face of the anvil, and the small chest seam: Wickit's original ember
    paint(img, thin_line_mask([(17, 84.6), (36, 84.2), (39.4, 85.2)], 0.7), STEEL[4])
    ember_line(img, [(40, 44), (41, 48), (40, 52)], 0.9)
    # the raised paw glows at its pads for the delicate work
    for (x, y, r) in ((14.6, 43, 2.2), (11, 39, 1.0), (14, 37.4, 1.0), (17.6, 38, 1.0)):
        paint(img, to_mask(smooth_poly_mask([E(x, y, r, r * 0.85)]), 0.35, False), EMBER[1])
    F.halo(img, parts[8].regions[0][0], EMBER[1], 60)
    # the lopsided bowl: dark hollow, light rim, one glint
    paint(img, to_mask(smooth_poly_mask([E(26.4, 80.9, 3.2, 1.0)]), 0.4, False), CLAY_O)
    paint(img, {(23, 81), (28, 80)}, CLAY[3])
    # a memory of porcelain: one tiny cobalt flower inlaid in the shoulder plate
    for (x, y, c) in ((54, 38, COBALT), (55, 38, COBALT_LT), (53, 38, COBALT_LT), (54, 37, COBALT_LT), (54, 39, COBALT_LT)):
        paint(img, {(x, y)}, c)
    notch(img, 50, 0)
    return drop_to_ground(selout(img), 93)


def ribbon_poly(pts, r0, r1):
    from clean import ribbon
    return ribbon(pts, r0, r1)


if __name__ == "__main__":
    out = Image.new("RGBA", (3 * 288 + 40, 300), (72, 80, 104, 255))
    for i, fn in enumerate((wickit, stoketail, forgel)):
        out.alpha_composite(fn().resize((288, 288), Image.NEAREST), (10 + i * 298, 6))
    out.save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/cinder3.png")
