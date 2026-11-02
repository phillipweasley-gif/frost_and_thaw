"""Cinderwright line, painted large first (768px) and then simplified to the 96px sprite.
Poses and skeletons come from cinder_rig (the approved construction); here each creature is built
as anatomical masses for the high-detail painter in hd.py."""
import math
import numpy as np
import cv2
from PIL import Image, ImageDraw
from scipy import ndimage as ndi
import hd
from hd import Layer, Canvas, S, W, RAMPS, MID, fill, line, blur, disc, eye, delft, soft
from hires import bezier
from cinder_anatomy import E, tube
from cinder_rig import (head3q, fore_limb, hind_limb, shell, shell_arcs, rings_along, plates_along, rotator, xf_tree, lerp, ribbon)

SCR = "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/"


# =============================================================================================== face helpers
def nose(C, x, y, r):
    C.paint(disc(x, y, r * 1.1, r * 0.8, -10), (30, 14, 18), "char")
    C.paint(disc(x - r * 0.3, y - r * 0.35, r * 0.4, r * 0.22, -10), (150, 110, 110))


def mouth_smile(C, a, b, tongue=True):
    mid = lerp(a, b, 0.45)
    poly = [a, (mid[0] - 1.0, mid[1] + 2.4), (mid[0] + 1.6, mid[1] + 2.2), (b[0], b[1] - 1.2), (mid[0], mid[1] + 0.2)]
    m = fill(poly)
    C.paint(m, (88, 24, 32), "mouth")
    if tongue:
        C.paint(disc(mid[0] + 0.4, mid[1] + 1.9, 1.5, 0.8) * m, (222, 108, 112), "mouth")
    C.paint(line([a, (mid[0], mid[1] + 0.3), (b[0], b[1] - 1.2), (b[0] + 0.7, b[1] - 1.9)], 0.3), (46, 16, 18))


def mouth_line(C, a, b, up=0.0):
    m = lerp(a, b, 0.55)
    C.paint(line([a, m, (b[0], b[1] - up), (b[0] + 0.6, b[1] - up - 0.6 * (1 if up > 0 else -1))], 0.3), (54, 22, 22))


def whiskers(C, base, n=3, length=6.0, col=(250, 236, 214)):
    for i in range(n):
        a = math.radians(196 + i * 9)
        p0 = (base[0] - i * 0.3, base[1] + i * 0.7)
        p1 = (p0[0] + math.cos(a) * length, p0[1] + math.sin(a) * length * 0.6 + i * 0.6)
        C.paint(line([p0, lerp(p0, p1, 0.5), p1], 0.12) * 0.7, col)


def flame(C, base, height, width, lean=0.35):
    """An emissive flame: a teardrop of nested ember colours, then a glow."""
    bx, by = base
    def tear(sc):
        pts = []
        for i in range(41):
            t = i / 40
            a = math.pi * 2 * t
            r = width * sc * 0.5
            x = math.sin(a) * r * (1 - 0.65 * max(0, -math.cos(a)))
            y = -(1 - math.cos(a)) / 2 * height * sc
            pts.append((bx + x + lean * (-y), by + y + r * 0.35))
        return fill(pts)
    outer, mid_, core = tear(1.0), tear(0.72), tear(0.42)
    C.glow(outer, (255, 140, 40), 2.2, 0.75)
    C.paint(outer, (238, 108, 28), "ember")
    C.paint(mid_, (255, 178, 58), "ember")
    C.paint(core, (255, 238, 190), "ember")
    return outer


def cream_mask(g, back=0.9):
    """A stoat's clean upper-lip line: cream below a line from the nose back under the eye, then down the
    cheek into the throat."""
    P, s_ = g["P"], g["s"]
    return [[P(-2.0 * s_, 0.12 * s_), P(-1.1 * s_, 0.2 * s_), P(-0.45 * s_, 0.32 * s_), P(0.2 * s_, 0.42 * s_),
             P(back * s_, 0.72 * s_), P(back * s_ * 0.8, 1.6 * s_), P(-2.0 * s_, 1.6 * s_)]]


def small_ears(g, k=0.8):
    for key in ("ear_near", "ear_far"):
        c = g[key + "_c"]
        pts = g[key]
        rx = (max(x for x, _ in pts) - min(x for x, _ in pts)) / 2 * k
        ry = (max(y for _, y in pts) - min(y for _, y in pts)) / 2 * k
        g[key] = E(c[0] + 0.3, c[1] + 0.6, rx, ry)
        g[key + "_c"] = (c[0] + 0.3, c[1] + 0.6)


# =============================================================================================== WICKIT
def toes(L, n, r, spread=1.0, hind=False):
    """Toe pads across the front of a paw: small round masses that give the paw its shape."""
    if hind:
        tip = L["joints"][-1]
    else:
        tip = L["tip"]
    a = L["ang"]
    px_, py_ = -math.sin(a), math.cos(a)
    out = []
    for i in range(n):
        k = (i - (n - 1) / 2) * r * 1.35 * spread
        cx = tip[0] + px_ * k - math.cos(a) * r * 0.2
        cy = tip[1] + py_ * k - math.sin(a) * r * 0.2
        out.append(E(cx, cy, r, r * 0.9))
    return out


def wickit_geo():
    R = rotator(46, 62, 13)
    spine = bezier((30, 55), (40, 53), (50, 55), (58, 58), 20)
    rib, pel = E(39, 61, 8.6, 7.4, -8), E(54, 62, 6.8, 6.2, 14)
    chest = E(37, 61, 7.6, 7.4, -10)
    belly_m = E(46, 62.5, 7.0, 6.2, 0)
    haunch = E(54, 61.5, 7.2, 6.8, 10)
    neck = tube([(34, 58), (28, 53)], [6.4, 5.8])
    fn = fore_limb((40, 55), (34, 63), (31, 70), (24, 76.5), (21.0, 79.4), 3.6, paw_len=2.6)
    ff = fore_limb((42, 56), (38, 64), (37, 71), (31.5, 70), (29.6, 73.2), 3.1, paw_len=2.4)
    hn = hind_limb((55, 62), (61, 67.5), (69, 70), (77, 71.5), 4.4)
    hf = hind_limb((53, 63), (58, 69.5), (65, 73.5), (71, 76.5), 3.6)
    belly = [[(27, 55), (31, 61), (37, 66), (44, 68.6), (50, 68.6), (56, 67), (53, 73), (42, 75), (33, 71), (26, 62)]]
    (spine, chest, belly_m, haunch, neck, fn, ff, hn, hf, belly) = xf_tree([spine, chest, belly_m, haunch, neck, fn, ff, hn, hf, belly], R)
    tail_path = bezier((57, 62.5), (68, 66.5), (79, 62), (83, 49), 24)
    g = head3q(22, 45, 10.0, tilt=-4, yaw=0.6, ears=(0.4, -0.6))
    small_ears(g, 0.88)
    return locals()


def wickit_hd(face=True):
    G = wickit_geo()
    g, fn, ff, hn, hf = G["g"], G["fn"], G["ff"], G["hn"], G["hf"]
    tp = G["tail_path"]
    tail = [tube(tp[:9], [3.9, 3.6]), tube(tp[8:17], [3.6, 3.1]), tube(tp[16:], [3.1, 2.6])]
    tip = tp[-1]
    cup_c = (tip[0] + 0.6, tip[1] - 1.6)
    cup = shell(*cup_c, 5.0, 4.6, 196, 0.32)
    C = Canvas()
    tf, th_f, tn, th_n = toes(ff, 3, 1.0), toes(hf, 3, 1.05, hind=True), toes(fn, 3, 1.15), toes(hn, 3, 1.2, hind=True)
    C.add(Layer("far fore", [ff["up"], ff["lo"], ff["paw"]] + [[t] for t in tf], "fur", regions=[(ff["paw"] + tf, "char")], depth=0.8, dim=0.14, tufts=0.2))
    C.add(Layer("far hind", [hf["up"], hf["lo"], hf["paw"]] + [[t] for t in th_f], "fur", regions=[(hf["paw"] + th_f, "char")], depth=0.8, dim=0.14, tufts=0.2))
    C.add(Layer("tail", tail, "fur", depth=0.9, tufts=0.35))
    C.add(Layer("far ear", [g["ear_far"]], "fur", regions=[([E(*g["ear_far_c"], g["s"] * 0.17, g["s"] * 0.16)], "ear")], depth=0.5))
    C.add(Layer("body", [[G["chest"]], [G["belly_m"]], [G["haunch"]], G["neck"], fn["up"], hn["up"]], "fur",
                regions=[(G["belly"], "cream")], depth=1.0, tufts=0.3))
    C.add(Layer("near hind", [hn["lo"], hn["paw"]] + [[t] for t in th_n], "fur", regions=[(hn["paw"] + th_n, "char")], depth=0.8, tufts=0.25))
    C.add(Layer("near fore", [fn["lo"], fn["paw"]] + [[t] for t in tn], "fur", regions=[(fn["paw"] + tn, "char")], depth=0.8, tufts=0.2))
    head = [[g["cranium"]], [g["cheek"]], [g["muzzle"]], [g["chin"]]]
    C.add(Layer("head", head, "fur", regions=[(cream_mask(g), "cream")], depth=1.0, tufts=0.4, smooth=0.5))
    C.add(Layer("near ear", [g["ear_near"]], "fur", regions=[([E(*g["ear_near_c"], g["s"] * 0.22, g["s"] * 0.2)], "ear")], depth=0.5, tufts=0.2))
    geom = (*cup_c, 5.0, 4.6, 196)
    C.add(Layer("cup", [cup], "porc", kind="gloss", gloss=1.0, depth=1.2, rim=0.4, line_col=(20, 32, 86),
                design=lambda U: delft(U, geom, motifs=[(cup_c[0] + 0.4, cup_c[1] + 2.6, 1.3)], border=True, scallop=True)))
    flame(C, (cup_c[0] - 0.2, cup_c[1] - 1.0), 15, 6.4, lean=0.38)
    if not face:
        return C, G
    # face
    ex, ey = g["eye_near"]
    eye(C, ex + 0.2, ey + 0.2, 4.2, 4.8)
    fx, fy = g["eye_far"]
    eye(C, fx + 0.9, fy + 0.2, 2.6, 4.2, far=True)
    nose(C, *g["nose"], 1.3)
    mouth_smile(C, (g["mouth_l"][0] + 0.5, g["mouth_l"][1] - 0.6), g["mouth_r"])
    whiskers(C, (g["nose"][0] + 3.0, g["nose"][1] + 1.6))
    return C, G


# =============================================================================================== simplify
# =============================================================================================== STOKETAIL
def plate(name, poly, geom=None, motifs="auto", arcs=(), border=True, depth=1.1, gloss=1.0, follow="body", clip="body"):
    """A porcelain armour plate: the region `poly` cut to the part it covers (so its outer edge is the
    creature's own outline), riding that part's surface, glazed blue-and-white."""
    return Layer(name, [poly], "porc", kind="gloss", gloss=gloss, depth=depth, rim=0.35, line_col=(18, 30, 84), tufts=0,
                 design=lambda U: delft(U, geom, motifs=motifs, arcs=arcs, border=border), follow=follow, clip=clip, smooth=0.25)


def band_across(path, t, width, reach=14):
    """A strip crossing a tube (a tail, a forearm) at parameter t; cut to the tube it becomes a ring."""
    n = len(path) - 1
    i = min(int(t * n), n - 1)
    a, b = path[i], path[i + 1]
    dx, dy = b[0] - a[0], b[1] - a[1]
    L = math.hypot(dx, dy) or 1
    dx, dy = dx / L, dy / L
    nx, ny = -dy, dx
    hw = width / 2
    return [(a[0] - dx * hw + nx * reach, a[1] - dy * hw + ny * reach), (a[0] + dx * hw + nx * reach, a[1] + dy * hw + ny * reach),
            (a[0] + dx * hw - nx * reach, a[1] + dy * hw - ny * reach), (a[0] - dx * hw - nx * reach, a[1] - dy * hw - ny * reach)]


def stoketail_hd(face=True):
    g = head3q(36, 29, 9.4, tilt=-2, yaw=0.64, ears=(0.2, -0.6))
    small_ears(g, 0.8)
    hn = hind_limb((55, 76), (49, 80), (55, 87), (45, 89.4), 5.0)
    hf = hind_limb((59, 77), (55, 82.5), (52, 87.6), (42, 87.4), 4.0)
    fn = fore_limb((49, 47), (44, 52), (46, 60), (37, 57.5), (32.5, 54.8), 3.6, paw_len=2.8, claw_len=2.2)
    ff = fore_limb((52, 46), (48, 51), (49, 58), (40, 52), (35.5, 51.2), 3.1, paw_len=2.4)
    chest = E(46.5, 52, 8.4, 8.0, -62)
    waist = E(51, 63, 6.8, 6.6, -80)
    haunch = E(56, 74, 8.6, 8.0, 64)
    spine_body = tube(bezier((45, 46), (51, 54), (52, 64), (56, 74), 18), [7.4, 8.2, 6.6, 8.2])
    neck = tube([(46, 45), (41, 37)], [6.0, 5.4])
    clay = E(31.0, 50.0, 5.2, 4.4, -10)
    tail_path = bezier((60, 74), (70, 80), (73, 88), (80, 88), 16) + bezier((80, 88), (86, 88), (90, 84), (91, 77), 12)[1:]
    tail = [tube(tail_path[:12], [6.6, 5.4]), tube(tail_path[11:], [5.0, 4.0])]
    paddle = [(82, 86), (84, 79), (87, 72), (91, 67.5), (94.5, 70), (95.4, 77), (93.5, 84), (88, 89.6)]
    belly = [[(28, 34), (36, 37), (42, 44), (46, 52), (47, 62), (49, 70), (54, 79), (47, 81), (41, 70), (38, 58), (35, 46), (29, 40)]]
    SH = (47.2, 51.2, 7.4, 7.0, -38); HP = (60.5, 75.5, 6.6, 7.0, 58); FA = (41.5, 59.4, 3.4, 3.0, -12)
    BR = (*g["P"](g["s"] * 0.05, -g["s"] * 0.62), g["s"] * 0.42, g["s"] * 0.26, g["tilt"])
    ring = band_across(tail_path, 0.2, 3.2)
    tn, tf_ = toes(hn, 3, 1.35, hind=True), toes(hf, 3, 1.1, hind=True)
    tfn, tff = toes(fn, 3, 1.0), toes(ff, 3, 0.9)
    C = Canvas()
    C.add(Layer("far hind", [hf["up"], hf["lo"], hf["paw"]] + [[t] for t in tf_], "fur", regions=[(hf["paw"] + tf_, "char")], depth=0.8, dim=0.14))
    C.add(Layer("tail", tail + [[paddle]], "fur", depth=0.9, tufts=0.3))
    C.add(plate("tail ring", ring, motifs=(), follow="tail", clip="tail"))
    C.add(Layer("far fore", [ff["up"], ff["lo"], ff["paw"]] + [[t] for t in tff], "fur", regions=[(ff["paw"] + tff, "char")], depth=0.8, dim=0.14))
    C.add(Layer("far ear", [g["ear_far"]], "fur", regions=[([E(*g["ear_far_c"], g["s"] * 0.17, g["s"] * 0.16)], "ear")], depth=0.5))
    C.add(Layer("body", [[chest], [waist], [haunch], spine_body, neck, fn["up"], hn["up"]], "fur", regions=[(belly, "cream")], depth=1.0, tufts=0.3))
    C.add(Layer("clay", [[clay]], "clay", depth=1.0, rim=1.4, strokes=False))
    C.add(Layer("near hind", [hn["lo"], hn["paw"]] + [[t] for t in tn], "fur", regions=[(hn["paw"] + tn, "char")], depth=0.9, tufts=0.2))
    hip_reg = [(57, 65), (64, 64), (70, 70), (70, 82), (63, 83.5), (58.5, 80), (56.5, 74), (56, 69)]
    sh_reg = [(43, 42.5), (51, 41), (58, 46), (58, 58), (52, 59.5), (47.5, 57.5), (44, 53), (42.5, 47.5)]
    C.add(plate("hip plate", hip_reg, arcs=[bezier((58.4, 70), (60, 73.5), (62, 76.5), (66, 78.5), 10)]))
    C.add(plate("shoulder plate", sh_reg, arcs=[bezier((45, 47), (47, 51.5), (50.5, 54.5), (56, 55), 10)]))
    C.add(Layer("near fore", [fn["lo"], fn["paw"]] + [[t] for t in tfn], "fur", regions=[(fn["paw"] + tfn, "char")], depth=0.8))
    C.add(plate("cuff", band_across([fn["joints"][2], fn["joints"][3]], 0.5, 3.4, 6), motifs=(), border=True,
                follow="near fore", clip="near fore"))
    C.add(Layer("head", [[g["cranium"]], [g["cheek"]], [g["muzzle"]], [g["chin"]]], "fur",
                regions=[(cream_mask(g), "cream")], depth=1.0, tufts=0.35, smooth=0.5))
    C.add(Layer("near ear", [g["ear_near"]], "fur", regions=[([E(*g["ear_near_c"], g["s"] * 0.22, g["s"] * 0.2)], "ear")], depth=0.5))
    # kiln heat: cracks in the clay, the paddle's glowing seam
    cracks = np.maximum(line([(27.5, 48.5), (30, 50), (33.5, 48.8)], 0.35), line([(30, 50), (29.4, 53)], 0.3))
    C.glow(cracks, (255, 150, 50), 1.2, 0.6); C.paint(cracks, (255, 200, 90), "ember")
    seam = line(bezier((94.4, 71), (95.0, 77), (93.6, 83), (89.5, 88), 12), 0.45)
    C.glow(seam, (255, 150, 50), 1.4, 0.6); C.paint(seam, (255, 196, 84), "ember")
    G = {"g": g}
    if not face:
        return C, G
    ex, ey = g["eye_near"]
    eye(C, ex + 0.2, ey + 0.2, 3.6, 4.2)
    fx, fy = g["eye_far"]
    eye(C, fx + 0.8, fy + 0.2, 2.3, 3.8, far=True)
    nose(C, *g["nose"], 1.2)
    mouth_line(C, g["mouth_l"], g["mouth_r"], up=1.2)
    whiskers(C, (g["nose"][0] + 3.0, g["nose"][1] + 1.6))
    return C, G


# =============================================================================================== FORGEL
def forgel_hd(face=True):
    DY = 5.0
    def D(*p):
        return (p[0], p[1] + DY)
    rib_m = E(*D(40, 53), 13.6, 12.6, -22)
    hump = E(*D(45, 43), 11.0, 7.0, -8)
    waist = E(*D(53, 52), 9.4, 9.0, 20)
    haunch = E(*D(62, 61), 10.2, 9.8, 50)
    body = tube(bezier(D(36, 50), D(46, 46), D(56, 52), D(62, 62), 18), [13.6, 12.6, 10.0, 10.8])
    neck = tube([D(33, 52), D(25, 60)], [10.5, 9.6])
    g = head3q(*D(15.0, 56), 13.0, tilt=4, yaw=0.62, ears=(-0.6, 0.6), jaw=1.25, snout=0.88)
    for k in ("ear_near", "ear_far"):          # wolverine ears: small, round, set wide and low
        c = g[k + "_c"]
        g[k] = E(c[0], c[1], g["s"] * (0.3 if k == "ear_near" else 0.24), g["s"] * (0.27 if k == "ear_near" else 0.22))
    fn = fore_limb(D(46, 40), D(36, 57), D(37, 68), (27, 80), (22.0, 86.2), 7.4, paw_len=6.2, toes=4, claw_len=4.0, paw_dir=172)
    ff = fore_limb(D(50, 41), D(46, 58), D(49, 68), (48, 80.5), (44.0, 87.0), 6.4, paw_len=5.4, toes=4, claw_len=3.4, paw_dir=178)
    hn = hind_limb(D(62, 62), D(55, 71), (68, 81), (59, 88.8), 7.4)
    hf = hind_limb(D(66, 59), D(64, 69), (76, 80), (70, 87.8), 6.0)
    tail_path = bezier(D(65, 57), D(82, 56), D(88, 40), D(82, 25), 20)
    tail = [tube(tail_path[:8], [10.2, 9.0]), tube(tail_path[7:15], [9.0, 7.8]), tube(tail_path[14:], [7.8, 6.8])]
    base = tail_path[-1]
    d = (tail_path[-1][0] - tail_path[-3][0], tail_path[-1][1] - tail_path[-3][1])
    a = math.atan2(d[1], d[0]) + math.pi / 2
    ca, sa = math.cos(a), math.sin(a)
    def A(x, y, k=1.22):
        x, y = x * k, y * k
        return (base[0] + x * ca - y * sa, base[1] + x * sa + y * ca)
    anvil_face = [A(*p) for p in ((11, -16.5), (-6, -16.5), (-13, -16), (-18, -15), (-12, -12.6), (-6, -11.4), (11, -11))]
    anvil_waist = [A(*p) for p in ((-4.4, -11.4), (-2.6, -5.5), (2.6, -5.5), (4.4, -11.4))]
    anvil_foot = [A(*p) for p in ((-3, -6), (-8, -1.6), (-8, 0.6), (8, 0.6), (8, -1.6), (3, -6))]
    collar = E(*A(0, 1.2), 6.6, 3.0, math.degrees(a))
    band_path = bezier(D(34, 48), D(46, 42), D(56, 46), D(64, 56), 18)
    under = [[D(20, 66)] + [(x, y + 2.5) for x, y in band_path] + [(70, 99), (20, 99)]]
    side_band = [ribbon(band_path, 3.6, 2.8)]
    SH, HP = (*D(43.5, 44.5), 11.2, 8.2, -12), (*D(62, 57), 8.6, 7.6, 50)
    s_ = g["s"]; P = g["P"]
    BR = (*P(s_ * 0.05, -s_ * 0.62), s_ * 0.62, s_ * 0.3, g["tilt"] - 4)
    dorsal = plates_along(bezier(D(46, 38), D(55, 39), D(61, 47), D(65, 57), 20), [0.42, 0.72], 5.6, 5.2, 0.5, lift=-1.0)
    FA = (32.0, 75.6, 6.2, 4.2, -35)
    rings = rings_along(tail_path, [0.58, 0.8, 0.96], [8.4, 7.8, 7.2], w=1.9)
    tfn, tff = toes(fn, 4, 1.7), toes(ff, 4, 1.45)
    thn, thf = toes(hn, 4, 1.7, hind=True), toes(hf, 4, 1.4, hind=True)
    C = Canvas()
    C.add(Layer("far hind", [hf["up"], hf["lo"], hf["paw"]] + [[t] for t in thf], "char", depth=0.9, dim=0.08, tufts=0.2))
    C.add(Layer("far fore", [ff["up"], ff["lo"], ff["paw"]] + [[t] for t in tff], "char", depth=0.9, dim=0.08, tufts=0.2))
    C.add(Layer("tail", tail, "fur", depth=1.0, tufts=0.3))
    for k, t in enumerate((0.56, 0.76, 0.93)):
        C.add(plate("tail ring %d" % k, band_across(tail_path, t, 3.0, 16), motifs=(), follow="tail", clip="tail"))
    C.add(Layer("collar", [[collar]], "steel", kind="metal", gloss=0.8, depth=0.8, rim=0.6, strokes=False))
    C.add(Layer("anvil", [[anvil_face], [anvil_waist], [anvil_foot]], "steel", kind="metal", gloss=1.0, depth=0.7, smooth=0.25,
                rim=0.8, strokes=False))
    C.add(Layer("far ear", [g["ear_far"]], "fur", regions=[([E(*g["ear_far_c"], g["s"] * 0.15, g["s"] * 0.14)], "ear")], depth=0.5))
    C.add(Layer("body", [[rib_m], [hump], [waist], [haunch], body, neck, fn["up"], hn["up"]], "fur",
                regions=[(under, "umber"), (side_band, "cream")], depth=1.0, tufts=0.3))
    # armour regions; cut to the body, their top edges are the creature's own back line
    paul = [D(24, 30), D(58, 26), D(58, 44), D(54, 48.5), D(46, 50.5), D(38, 50), D(31, 47.5), D(26, 43)]
    dors1 = [D(55, 28), D(66, 32), D(64.5, 47.5), D(60, 51), D(56, 49.5)]
    dors2 = [D(63, 36), D(76, 42), D(71, 55.5), D(66, 57.5), D(62.5, 53)]
    hipr = [D(66, 46), D(80, 52), D(76, 66), D(70, 69), D(65, 66), D(62.5, 59)]
    C.add(plate("hip plate", hipr, arcs=[bezier(D(64, 57), D(67, 62), D(71, 64.5), D(75, 63), 10)]))
    C.add(plate("dorsal 2", dors2))
    C.add(plate("dorsal 1", dors1))
    C.add(Layer("near hind", [hn["lo"], hn["paw"]] + [[t] for t in thn], "char", depth=1.0, tufts=0.2))
    C.add(plate("pauldron", paul, motifs=[(*D(37, 41.5), 1.7), (*D(48, 40.5), 1.7)],
                arcs=[bezier(D(28, 42), D(36, 46.5), D(46, 47.5), D(55, 44), 14), bezier(D(30, 37.5), D(38, 42), D(47, 43), D(56, 39.5), 14)],
                depth=1.3))
    C.add(Layer("near fore", [fn["lo"], fn["paw"]] + [[t] for t in tfn], "char", depth=1.0, tufts=0.2))
    fa_reg = [(28, 67), (40, 69), (37, 75), (31.5, 80.5), (25.5, 79)]
    C.add(plate("forearm guard", fa_reg, follow="near fore", clip="near fore"))
    C.add(Layer("head", [[g["cranium"]], [g["cheek"]], [g["muzzle"]], [g["chin"]]], "fur",
                regions=[(cream_mask(g, 0.5), "cream")], depth=1.0, tufts=0.35, smooth=0.5))
    C.add(Layer("near ear", [g["ear_near"]], "fur", regions=[([E(*g["ear_near_c"], g["s"] * 0.18, g["s"] * 0.17)], "ear")], depth=0.5))
    brow_reg = [P(-s_ * 0.7, -s_ * 1.2), P(s_ * 0.9, -s_ * 1.2), P(s_ * 0.85, -s_ * 0.42), P(s_ * 0.2, -s_ * 0.36),
                P(-s_ * 0.35, -s_ * 0.42), P(-s_ * 0.72, -s_ * 0.5)]
    C.add(plate("brow plate", brow_reg, border=True, follow="head", clip="head"))
    # claws, heat
    for L_, n_, ln_ in ((ff, 4, 3.0), (fn, 4, 3.6)):
        tip, ang = L_["tip"], L_["ang"]
        for i in range(n_):
            off = (i - (n_ - 1) / 2) * 1.7
            b0 = (tip[0] - math.sin(ang) * off, tip[1] + math.cos(ang) * off)
            b1 = (b0[0] + math.cos(ang + 0.6) * ln_, b0[1] + math.sin(ang + 0.6) * ln_)
            nx_, ny_ = -math.sin(ang), math.cos(ang)
            mid = lerp(b0, b1, 0.5); mid = (mid[0] - nx_ * 0.35, mid[1] - ny_ * 0.35)
            claw = [(b0[0] + nx_ * 0.55, b0[1] + ny_ * 0.55), mid, b1, (b0[0] - nx_ * 0.55, b0[1] - ny_ * 0.55)]
            C.paint(fill(claw), (222, 210, 186), "bone")
            C.paint(fill([lerp(b0, b1, 0.55), mid, b1]) * 0.8, (120, 104, 90), "bone")
    seam = line(bezier(D(33, 46.5), D(38, 50), D(48, 50.5), D(54, 48.5), 12), 0.5)
    C.glow(seam, (255, 150, 50), 1.4, 0.7); C.paint(seam, (255, 196, 84), "ember")
    heat = line([A(-3.6, -9.0), A(3.6, -9.0)], 0.6)
    C.glow(heat, (255, 150, 50), 1.6, 0.8); C.paint(heat, (255, 210, 110), "ember")
    for (x, y) in (A(-19, -16), A(-14, -19), A(-21, -11), A(-9, -20)):
        C.paint(disc(x, y, 0.45, 0.45), (255, 196, 84), "ember")
    G = {"g": g}
    if not face:
        return C, G
    ex, ey = g["eye_near"]
    eye(C, ex + 0.2, ey + 0.3, 3.6, 3.8, lid=0.45)
    fx, fy = g["eye_far"]
    eye(C, fx + 0.6, fy + 0.3, 2.2, 3.4, lid=0.45, far=True)
    nose(C, *g["nose"], 1.6)
    mouth_line(C, g["mouth_l"], g["mouth_r"], up=-0.4)
    whiskers(C, (g["nose"][0] + 3.6, g["nose"][1] + 2.0), length=7)
    return C, G


EYE_TPL = {
    "kit": [".KKK.",
            "KWWKK",
            "KWKKK",
            "KKIIK",
            ".KII."],
    "open": [".KK.",
             "KWKK",
             "KKKK",
             "KIIK",
             ".II."],
    "set": ["LLLL",
            "KWKK",
            "KKKK",
            ".IIK"],
    "heavy": ["LLL..",
              "KLLLL",
              "KWKKK",
              ".KIIK"],
    "far": [".K",
            "KK",
            "WK",
            "KI"],
    "far_set": ["L.",
                "KL",
                "WK",
                "KI"],
}


def stamp_eye(img, tpl, cx, cy, lid=(84, 30, 22)):
    t = EYE_TPL[tpl]
    x0, y0 = int(round(cx - len(t[0]) / 2)), int(round(cy - len(t) / 2))
    cols = {"K": (26, 12, 14), "W": (255, 255, 255), "I": (226, 140, 44), "L": lid}
    px = img.load()
    for j, row in enumerate(t):
        for i, ch in enumerate(row):
            if ch in cols and px[x0 + i, y0 + j][3]:
                px[x0 + i, y0 + j] = cols[ch] + (255,)


def simplify(C, eyes=(), interior=True, skip_lines=()):
    """768px painting -> 96px sprite, the way a pixel artist reduces a concept:
       coverage decides the silhouette; each pixel takes its block's material (small accents like the
       cobalt designs, embers and the mouth win when they cover enough of the block); colour snaps to that
       material's ramp; clusters are cleaned (no lone tones); a selective outline round the silhouette and
       wherever a nearer part overlaps a farther one; the eyes are hand-placed pixels."""
    rgb = C.rgb * C.a[..., None]
    small = cv2.resize(rgb, (96, 96), interpolation=cv2.INTER_AREA)
    a = cv2.resize(C.a, (96, 96), interpolation=cv2.INTER_AREA)
    col = small / np.maximum(a[..., None], 1e-4)
    on = a >= 0.5

    def block_mode(arr, n):
        blocks = arr.reshape(96, S, 96, S).transpose(0, 2, 1, 3).reshape(96, 96, S * S)
        counts = np.stack([(blocks == i).sum(2) for i in range(n)], 2)
        return counts
    mc = block_mode(C.mat, len(RAMPS))
    choice = mc.argmax(2)
    for m, th in (("cobalt", 0.22), ("ember", 0.3), ("mouth", 0.3), ("bone", 0.3)):
        i = MID[m]
        choice = np.where(mc[..., i] >= th * S * S, i, choice)
    nl = max(1, len(C.order))
    lc = block_mode(C.lid, nl)
    lid = lc.argmax(2)
    tone = np.full((96, 96), -1, int)
    sh = cv2.resize(C.shade * C.a, (96, 96), interpolation=cv2.INTER_AREA) / np.maximum(a, 1e-4)
    rim = cv2.resize(C.rim * C.a, (96, 96), interpolation=cv2.INTER_AREA) / np.maximum(a, 1e-4)
    SHADED = {"fur": 0.0, "cream": 0.0, "umber": 0.0, "char": 0.05, "porc": 0.22, "clay": 0.0, "ear": 0.0}
    for y in range(96):
        for x in range(96):
            if not on[y, x]:
                continue
            m = hd.MATS[choice[y, x]]
            ramp = np.array(RAMPS[m], float)
            if m in SHADED:
                t = int(np.clip((sh[y, x] + SHADED[m]) * len(ramp), 0, len(ramp) - 1))
                if rim[y, x] > 0.22 and m in ("fur", "umber", "char"):
                    t = min(len(ramp) - 1, t + 1)
                tone[y, x] = t
            else:
                dist = ((ramp - col[y, x]) ** 2 * np.array([0.3, 0.59, 0.11])).sum(1)
                tone[y, x] = dist.argmin()
    # clusters: a tone that disagrees with most of its same-material neighbours joins them
    for _ in range(2):
        t2 = tone.copy()
        for y in range(1, 95):
            for x in range(1, 95):
                if tone[y, x] < 0:
                    continue
                nb = [(tone[y + dy, x + dx]) for dy in (-1, 0, 1) for dx in (-1, 0, 1) if (dx or dy)
                      and choice[y + dy, x + dx] == choice[y, x] and tone[y + dy, x + dx] >= 0]
                if len(nb) >= 5 and nb.count(tone[y, x]) <= 1:
                    t2[y, x] = max(set(nb), key=nb.count)
        tone = t2
    out = np.zeros((96, 96, 4), np.uint8)
    for y in range(96):
        for x in range(96):
            if tone[y, x] >= 0:
                out[y, x, :3] = RAMPS[hd.MATS[choice[y, x]]][tone[y, x]]
                out[y, x, 3] = 255
    img = Image.fromarray(out, "RGBA").copy()
    px = img.load()
    N4 = ((1, 0), (-1, 0), (0, 1), (0, -1))
    def dark(m, k=0.55):
        return tuple(int(v * k) for v in RAMPS[m][0]) + (255,)
    lines = []
    for y in range(96):
        for x in range(96):
            if not px[x, y][3]:
                continue
            m = hd.MATS[choice[y, x]]
            if m in ("ember",):
                continue
            outer = any(not (0 <= x + dx < 96 and 0 <= y + dy < 96) or px[x + dx, y + dy][3] == 0 for dx, dy in N4)
            if outer:
                lines.append((x, y, dark(m)))
            elif interior and C.order[lid[y, x]].name not in skip_lines and C.order[lid[y, x]].outline:
                behind = any(0 <= x + dx < 96 and 0 <= y + dy < 96 and px[x + dx, y + dy][3] and lid[y + dy, x + dx] < lid[y, x]
                             and C.order[lid[y + dy, x + dx]].name not in skip_lines for dx, dy in N4)
                if behind:
                    lines.append((x, y, tuple(int(v * 0.8) for v in RAMPS[m][0]) + (255,)))
    for x, y, c in lines:
        px[x, y] = c
    for (tpl, cx, cy) in eyes:
        stamp_eye(img, tpl, cx, cy)
    return img


def pixel_face(img, g, near="open", far="far", mouth="smile", near_dx=0.2, far_dx=0.0, dy=0.2):
    """The 96px face, placed by hand from the painting's anchors: eyes, nose, mouth."""
    from clean import thin_line_mask, paint
    stamp_eye(img, near, g["eye_near"][0] + near_dx, g["eye_near"][1] + dy)
    if far:
        stamp_eye(img, far, g["eye_far"][0] + far_dx, g["eye_far"][1] + dy)
    nx, ny = int(round(g["nose"][0])), int(round(g["nose"][1]))
    paint(img, {(nx, ny), (nx + 1, ny), (nx, ny + 1), (nx + 1, ny - 1)}, (30, 14, 18))
    paint(img, {(nx + 1, ny - 1)}, (130, 96, 96))
    ml, mr = g["mouth_l"], g["mouth_r"]
    if mouth == "smile":
        a, b = (ml[0] + 0.5, ml[1] - 0.6), mr
        mid = lerp(a, b, 0.45)
        paint(img, thin_line_mask([a, (mid[0], mid[1] + 1.2), (b[0], b[1] - 1.0)], 0.6), (46, 16, 18))
        paint(img, {(int(round(mid[0])), int(round(mid[1] + 2))), (int(round(mid[0])) + 1, int(round(mid[1] + 2)))}, (214, 98, 104))
        paint(img, {(int(round(mid[0])) - 1, int(round(mid[1] + 1.5)))}, (88, 24, 32))
    elif mouth == "grin":
        paint(img, thin_line_mask([ml, lerp(ml, mr, 0.55), (mr[0] + 0.4, mr[1] - 1.2)], 0.6), (60, 24, 22))
    elif mouth == "set":
        paint(img, thin_line_mask([ml, lerp(ml, mr, 0.6), (mr[0], mr[1] + 0.6)], 0.6), (60, 24, 22))


def show(C, sprite, path, label=""):
    big = C.image((72, 80, 104, 255))
    sp = Image.new("RGBA", (96, 96), (72, 80, 104, 255)); sp.alpha_composite(sprite)
    out = Image.new("RGBA", (W * 2 + 30, W + 20), (60, 66, 88, 255))
    out.alpha_composite(big, (10, 10))
    out.alpha_composite(sp.resize((W, W), Image.NEAREST), (W + 20, 10))
    out.save(path)


SPECS = {
    "wickit": (wickit_hd, dict(near="kit", far="far", mouth="smile", far_dx=0.2), ("cup",)),
    "stoketail": (stoketail_hd, dict(near="open", far="far", mouth="grin", far_dx=0.0), ()),
    "forgel": (forgel_hd, dict(near="heavy", far="far_set", mouth="set", far_dx=-0.2), ("collar",)),
}


FRAME = {"wickit": (1.0, (50, 90), (0, 0)), "stoketail": (1.0, (50, 90), (0, 0)), "forgel": (0.9, (50, 91), (2.5, 0))}


def make(name):
    fn, face_kw, skip = SPECS[name]
    hd.framing(*FRAME[name])
    C, G = fn()
    C0, _ = fn(face=False)
    sp = simplify(C0, skip_lines=skip)
    g = dict(G["g"])
    for k in ("eye_near", "eye_far", "nose", "mouth_l", "mouth_r"):
        g[k] = hd.xp(g[k])
    pixel_face(sp, g, **face_kw)
    hd.framing()
    return C, sp


if __name__ == "__main__":
    import sys
    for nm in (sys.argv[1:] or ["wickit", "stoketail", "forgel"]):
        C, sp = make(nm)
        show(C, sp, SCR + "hd_" + nm + ".png")
        C.image().save(SCR + "hd_" + nm + "_768.png")
        sp.save(SCR + "hd_" + nm + "_96.png")
