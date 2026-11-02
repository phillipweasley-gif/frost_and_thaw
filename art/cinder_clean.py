"""Cinderwright line, restyled after the official renders (Buizel / Floatzel as the benchmark):
  - anatomy decides joints, lengths and proportions, but the surface is a few SMOOTH TAPERED SHAPES
  - soft clean shading with a satin sheen; no fur texture, no tufts, light outlines
  - three or four colours per creature; character comes from a few BOLD MARKINGS
    (cream muzzle and belly stripe, soot paws, soot cheek streaks, the wolverine's pale side band)
  - porcelain is bold and graphic: white glazed shell with ONE solid cobalt band
  - appendages make the silhouette: wick-cup tail, paddle tail, anvil tail, notched round ears
  - long smooth wedge heads, simple black eyes with a white highlight
Painted at 768px, then simplified to the 96px sprite (hd.py / cinder_hd.simplify)."""
import math
import numpy as np
from PIL import Image, ImageDraw
import hd
from hd import Layer, Canvas, S, W, fill, line, disc
from hires import bezier
from cinder_anatomy import E, tube
from cinder_rig import shell, lerp, ribbon
import cinder_hd as CH

SCR = CH.SCR
CLEAN = dict(strokes=False, tufts=0, ao=False, ow=0.6, wrap=0.4, sheen=0.16, smooth=0.9, hsmooth=0.9, rim=0.7)


def chaikin(pts, n=3):
    for _ in range(n):
        out = [pts[0]]
        for a, b in zip(pts, pts[1:]):
            out += [lerp(a, b, 0.25), lerp(a, b, 0.75)]
        out.append(pts[-1])
        pts = out
    return pts


def limb(joints, radii, paw, soot_from=0.55):
    """One smooth tapered shape through the joints, ending in a rounded paw; the soot 'sock' covers
    the end of the limb from `soot_from` along it."""
    path = chaikin(joints)
    body = tube(path, radii)
    k = int(len(path) * soot_from)
    sock = tube(path[k:], [radii[-1] * 1.6, radii[-1] * 1.25]) + [E(*paw)]
    j = int(len(path) * 0.38)
    rj = radii[0] + (radii[-1] - radii[0]) * 0.38
    upper = tube(path[:j + 1], [radii[0], rj])
    lower = tube(path[j:], [rj, radii[-1]]) + [E(*paw)]
    return {"shape": body + [E(*paw)], "sock": sock, "path": path, "upper": upper, "lower": lower}


def cap(cx, cy, rx, ry, rot=0.0, band_at=0.66, band_w=1.2):
    """A rounded porcelain shell (an ellipse, later cut to the form it sits on) and one cobalt band
    running parallel to its lower edge."""
    c, s_ = math.cos(math.radians(rot)), math.sin(math.radians(rot))
    arc = []
    for i in range(25):
        a = math.radians(10 + 160 * i / 24)
        x, y = rx * band_at * math.cos(a), ry * band_at * math.sin(a)
        arc.append((cx + x * c - y * s_, cy + x * s_ + y * c))
    return E(cx, cy, rx, ry, rot), [ribbon(arc, band_w, band_w)]


def wedge_head(cx, cy, s, snout, tilt=0.0, jaw=1.0):
    """A long smooth wedge: cranium, a tapering muzzle, a cheek/jaw mass; returns shapes and anchors."""
    t = math.radians(tilt)
    def P(dx, dy):
        return (cx + dx * math.cos(t) - dy * math.sin(t), cy + dx * math.sin(t) + dy * math.cos(t))
    g = {"P": P, "s": s}
    g["cranium"] = E(*P(0, 0), s, s * 0.84, tilt)
    m0, m1 = P(-s * 0.45, s * 0.24), P(-s * 0.45 - snout, s * 0.36)
    g["muzzle"] = tube([m0, m1], [s * 0.62, s * 0.3])
    g["jaw"] = E(*P(-s * 0.3, s * 0.42), s * 0.8 * jaw, s * 0.5, tilt)
    g["nose"] = P(-s * 0.45 - snout - s * 0.2, s * 0.26)
    g["eye_near"] = P(-s * 0.3, -s * 0.12)
    g["eye_far"] = P(-s * 0.95, -s * 0.14)
    g["mouth_l"] = P(-s * 0.45 - snout * 0.8, s * 0.56)
    g["mouth_r"] = P(-s * 0.5, s * 0.62)
    g["cream"] = [[P(-s * 3.0, s * 0.22), P(-s * 1.2, s * 0.28), P(-s * 0.5, s * 0.36), P(s * 0.1, s * 0.48), P(s * 0.75, s * 0.8),
                   P(s * 0.75, s * 1.8), P(-s * 3.0, s * 1.8)]]
    g["streaks"] = [ribbon([P(s * 0.15, s * 0.16), P(s * 0.52, s * 0.08)], s * 0.08, s * 0.05),
                    ribbon([P(s * 0.2, s * 0.36), P(s * 0.6, s * 0.32)], s * 0.08, s * 0.05)]
    g["eye_far"] = P(-s * 0.88, -s * 0.16)
    return g


def ears(g, near, far, r_near, r_far):
    P, s = g["P"], g["s"]
    g["ear_near"], g["ear_far"] = E(*P(*near), r_near, r_near * 0.95), E(*P(*far), r_far, r_far * 0.95)
    g["ear_near_c"], g["ear_far_c"] = P(*near), P(*far)
    g["inner_near"] = E(*P(near[0] - 0.4, near[1] + 0.3), r_near * 0.5, r_near * 0.45)
    g["inner_far"] = E(*P(far[0] - 0.3, far[1] + 0.3), r_far * 0.45, r_far * 0.4)
    # the flame notch at the top of each ear (spec): a small V cut, kept as a hole polygon
    g["notch_near"] = [P(near[0] - 0.9, near[1] - r_near - 0.6), P(near[0] + 0.1, near[1] - r_near * 0.55), P(near[0] + 0.9, near[1] - r_near - 0.6)]
    return g


def fur(name, shapes, regions=(), **kw):
    o = dict(CLEAN); o.update(kw)
    return Layer(name, shapes, "fur", regions=regions, **o)


def porcelain(name, region, bands, follow="body", clip="body", depth=1.0):
    """Bold glazed porcelain: white shell cut to the form it covers, one solid cobalt band."""
    return Layer(name, [region], "porc", kind="gloss", gloss=1.0, depth=depth, rim=0.3, line_col=(18, 30, 84), tufts=0,
                 strokes=False, ao=False, ow=0.7, wrap=0.3, follow=follow, clip=clip, smooth=0.3,
                 regions=[(bands, "cobalt")])


def ear_layers(C, g, which):
    k = "ear_" + which
    C.add(fur(k, [g[k]], regions=[([g["inner_" + which]], "ear")], depth=0.5, sheen=0.1))
    # cut the flame notch
    if which == "near":
        cut = fill(g["notch_near"])
        C.a = C.a * (1 - cut * (hd.np.asarray(C.lid) == len(C.order) - 1))


def face(C, g, eye_w, eye_h, far_w, lid=0.0, mouth="smile"):
    ex, ey = g["eye_near"]; fx, fy = g["eye_far"]
    for (x, y, w_, h_, fr) in ((ex, ey, eye_w, eye_h, False), (fx, fy, far_w, eye_h * 0.88, True)):
        E_ = disc(x, y, w_ / 2, h_ / 2)
        C.paint(E_, (20, 12, 16), "char")
        C.paint(disc(x - w_ * 0.16, y - h_ * 0.2, w_ * 0.17, h_ * 0.15), (255, 255, 255))
        C.paint(disc(x + w_ * 0.14, y + h_ * 0.2, w_ * 0.07, h_ * 0.06) * 0.8, (230, 230, 240))
        if lid:
            P = [(x - w_ * 0.62, y - h_ * 0.5 + lid * h_ * 0.5), (x + w_ * 0.62, y - h_ * 0.5 + lid * h_ * 0.15)]
            cover = fill([P[0], P[1], (x + w_ * 0.7, y - h_ * 0.9), (x - w_ * 0.7, y - h_ * 0.9)]) * hd.soft(hd.blur(E_, 0.5), 2)
            fy_, fx_ = hd.xp((x, y - h_ * 0.95))[1], hd.xp((x, y))[0]
            col = C.rgb[int(fy_ * S), int(fx_ * S)].copy()
            C.rgb = C.rgb * (1 - cover[..., None]) + col * cover[..., None]
            C.paint(line(P, 0.35), (40, 14, 16))
    nx, ny = g["nose"]
    C.paint(disc(nx, ny, g["s"] * 0.17, g["s"] * 0.13), (24, 12, 16), "char")
    C.paint(disc(nx - g["s"] * 0.05, ny - g["s"] * 0.06, g["s"] * 0.06, g["s"] * 0.035), (150, 120, 120))
    a, b = g["mouth_l"], g["mouth_r"]
    if mouth == "smile":
        mid = lerp(a, b, 0.5)
        C.paint(line([a, (mid[0], mid[1] + 0.9), (b[0], b[1] - 0.8)], 0.3), (46, 16, 18))
    else:
        C.paint(line([a, lerp(a, b, 0.6), (b[0], b[1] + 0.3)], 0.3), (46, 16, 18))


def flame(C, base, height, width, lean=0.38):
    return CH.flame(C, base, height, width, lean)


# =============================================================================================== WICKIT
def wickit(face_on=True):
    g = wedge_head(25, 45, 10.0, 6.0, tilt=-6)
    ears(g, (6.6, -5.2), (-2.2, -7.6), 3.0, 2.4)
    body = tube(bezier((31, 52), (38, 58), (46, 61), (54, 61), 20), [6.0, 8.0, 7.0, 7.4])
    fn = limb([(37, 60), (31, 64.5), (24, 65.5)], [4.0, 3.2, 2.8], (21.5, 65.6, 3.3, 2.6, -4))      # reaching ahead
    ff = limb([(40, 62), (39.5, 67), (35.5, 68.6)], [3.4, 2.8, 2.4], (33.5, 69, 2.7, 2.2, -10))     # tucked to the chest
    hn = limb([(53, 61), (59, 66), (65, 68.5)], [5.4, 3.8, 3.0], (68, 69, 3.4, 2.5, 4))
    hf = limb([(51, 63), (55, 68), (60, 72)], [4.4, 3.2, 2.6], (62.5, 72.6, 3.0, 2.2, 6))
    tail_path = bezier((56, 60), (66, 62), (75, 57), (79, 46.5), 24)
    tail = tube(tail_path, [4.2, 3.6, 3.0, 2.6])
    belly = [ribbon(bezier((23, 55), (33, 62), (43, 66), (55, 65), 16), 3.0, 2.2)]
    cup_c = (79.6, 44.2)
    cup = shell(*cup_c, 4.8, 4.4, 196, 0.32)
    cup_band = [ribbon([(cup_c[0] - 6, cup_c[1] + 1.8), (cup_c[0] + 6, cup_c[1] + 2.8)], 1.0, 1.0)]
    C = Canvas()
    C.add(fur("far fore", [ff["shape"]], regions=[(ff["sock"], "char")], depth=0.8, dim=0.12))
    C.add(fur("far hind", [hf["shape"]], regions=[(hf["sock"], "char")], depth=0.8, dim=0.12))
    C.add(fur("tail", [tail], depth=0.9))
    ear_layers(C, g, "far")
    C.add(fur("body", [body], regions=[(belly, "cream")], depth=1.0))
    C.add(fur("near hind", [hn["shape"]], regions=[(hn["sock"], "char")], depth=0.9))
    C.add(fur("near fore", [fn["shape"]], regions=[(fn["sock"], "char")], depth=0.9))
    C.add(fur("head", [[g["cranium"]], g["muzzle"], [g["jaw"]]], regions=[(g["cream"], "cream"), (g["streaks"], "umber")],
              depth=1.0, smooth=0.6))
    ear_layers(C, g, "near")
    C.add(porcelain("cup", cup, cup_band, follow=None, clip=None, depth=1.2))
    flame(C, (cup_c[0] - 0.2, cup_c[1] - 1.2), 15, 6.6)
    G = {"g": g}
    if face_on:
        face(C, g, 3.8, 4.6, 1.9, mouth="smile")
    return C, G


# =============================================================================================== STOKETAIL
def stoketail(face_on=True):
    g = wedge_head(37, 29, 8.6, 7.6, tilt=-3)
    ears(g, (5.4, -5.6), (-1.0, -6.8), 2.6, 2.1)
    body = tube(bezier((56, 76), (52, 64), (49, 54), (43, 39), 20), [9.4, 7.6, 8.4, 5.6])
    hn = limb([(55, 77), (49, 82), (51, 88)], [6.0, 4.2, 3.4], (45.5, 89.2, 6.0, 2.3, 0), 0.6)
    hf = limb([(59, 78), (55, 84), (55, 88)], [4.6, 3.4, 2.8], (50, 88.4, 5.0, 1.9, 0), 0.6)
    fn = limb([(48.5, 46), (47.5, 55), (39.5, 56.5), (34.5, 54.5)], [3.8, 3.2, 2.6, 2.4], (33, 54, 2.8, 2.4, -20))
    ff = limb([(49.5, 47), (49.5, 54), (42.5, 51), (38, 49.5)], [3.2, 2.8, 2.3, 2.1], (37, 49.3, 2.4, 2.0, -20))
    clay = E(30.6, 50.4, 4.6, 4.0, -10)
    tail_path = bezier((60, 77), (70, 88), (80, 88.5), (86, 82), 20)
    tail = tube(tail_path, [6.6, 5.2, 4.4, 3.8])
    paddle = [(83, 85), (85, 78), (88, 71), (92, 66), (95, 69), (95.5, 76), (93, 83), (88, 88)]
    belly = [ribbon(bezier((32, 35), (41, 45), (46, 60), (51, 75), 18), 3.4, 2.8)]
    sh_reg, sh_band = cap(54, 45, 8.4, 7.6, -25, 0.84, 1.1)
    C = Canvas()
    C.add(fur("far hind", [hf["shape"]], regions=[(hf["sock"], "char")], depth=0.8, dim=0.12))
    C.add(fur("tail", [tail, [paddle]], depth=0.9))
    ring_c = tail_path[5]
    ring = CH.band_across(tail_path, 0.24, 3.2)
    C.add(porcelain("tail ring", ring, [CH.band_across(tail_path, 0.24, 1.1)], follow="tail", clip="tail"))
    C.add(fur("far fore", [ff["shape"]], regions=[(ff["sock"], "char")], depth=0.8, dim=0.12))
    ear_layers(C, g, "far")
    C.add(fur("body", [body, hn["upper"]], regions=[(belly, "cream")], depth=1.0))
    C.add(Layer("clay", [[clay]], "clay", strokes=False, ao=False, ow=0.6, wrap=0.4, sheen=0.1, rim=1.2))
    C.add(fur("near hind", [hn["lower"]], regions=[(hn["sock"], "char")], depth=0.9))
    C.add(fur("near fore", [fn["shape"]], regions=[(fn["sock"], "char")], depth=0.9))
    C.add(porcelain("shoulder cap", sh_reg, sh_band))
    C.add(fur("head", [[g["cranium"]], g["muzzle"], [g["jaw"]]], regions=[(g["cream"], "cream"), (g["streaks"], "umber")],
              depth=1.0, smooth=0.6))
    ear_layers(C, g, "near")
    cracks = np.maximum(line([(27.5, 49), (30.2, 50.6), (33.5, 49.2)], 0.4), line([(30.2, 50.6), (29.6, 53.4)], 0.35))
    C.glow(cracks, (255, 150, 50), 1.2, 0.6); C.paint(cracks, (255, 206, 96), "ember")
    seam = line(bezier((94.4, 70), (95.4, 76), (93.8, 83), (89.5, 87.6), 12), 0.5)
    C.glow(seam, (255, 150, 50), 1.4, 0.6); C.paint(seam, (255, 196, 84), "ember")
    G = {"g": g}
    if face_on:
        face(C, g, 3.2, 4.0, 2.0, mouth="smile")
    return C, G


# =============================================================================================== FORGEL
def forgel(face_on=True):
    DY = 12.0                     # the body rides low on short, heavy legs
    def D(x, y):
        return (x, y + DY)
    g = wedge_head(*D(16, 55), 11.6, 8.4, tilt=6, jaw=1.25)
    ears(g, (8.0, -6.0), (-1.4, -8.8), 3.0, 2.4)
    body = tube(bezier(D(30, 57), D(40, 43), D(55, 43), D(64, 58), 24), [10.0, 13.6, 11.4, 11.6])
    fn = limb([D(37, 52), D(35, 60), (28, 80), (24, 85)], [8.8, 7.2, 6.0, 5.6], (21, 86.8, 7.2, 3.6, -6), 0.32)
    ff = limb([D(46, 53), D(48, 61), (47, 81), (44, 85.8)], [7.4, 6.0, 5.0, 4.6], (42, 87.3, 6.2, 3.0, 0), 0.32)
    hn = limb([D(60, 57), D(55, 64), (66, 82), (61, 86.8)], [9.8, 6.8, 5.6, 5.0], (58, 88.3, 7.0, 3.2, 0), 0.4)
    hf = limb([D(66, 55), D(65, 62), (75, 81), (71, 86.4)], [7.8, 5.6, 4.6, 4.2], (69, 87.8, 5.8, 2.8, 0), 0.4)
    tail_path = bezier(D(64, 57), D(81, 56), D(88, 40), D(82, 25), 24)
    tail = tube(tail_path, [10.0, 8.6, 7.6, 6.8])
    base = tail_path[-1]
    d = (tail_path[-1][0] - tail_path[-3][0], tail_path[-1][1] - tail_path[-3][1])
    a = math.atan2(d[1], d[0]) + math.pi / 2
    ca, sa = math.cos(a), math.sin(a)
    def A(x, y, k=1.22):
        x, y = x * k, y * k
        return (base[0] + x * ca - y * sa, base[1] + x * sa + y * ca)
    anvil = [[A(*p) for p in ((11, -16.5), (-6, -16.5), (-13, -16), (-18, -15), (-12, -12.6), (-6, -11.4), (11, -11))],
             [A(*p) for p in ((-4.4, -11.4), (-2.6, -5.5), (2.6, -5.5), (4.4, -11.4))],
             [A(*p) for p in ((-3, -6), (-8, -1.6), (-8, 0.6), (8, 0.6), (8, -1.6), (3, -6))]]
    side = [ribbon(bezier(D(32, 58), D(42, 52), D(54, 52), D(64, 61), 18), 2.6, 2.2)]          # the pale side band
    paul, paul_band = cap(*D(44, 38.5), 17.0, 12.6, -6, 0.86, 1.4)     # reaches past the back: cut, its top IS the back line
    hip, hip_band = cap(*D(67, 49), 10.6, 9.6, 30, 0.84, 1.2)
    fa, fa_band = cap(28.5, 77.5, 7.0, 6.0, -40, 0.72, 0.9)
    C = Canvas()
    CHAR = dict(CLEAN); CHAR.update(sheen=0.12)
    C.add(fur("far hind", [hf["shape"]], regions=[(hf["sock"], "char")], depth=0.9, dim=0.08))
    C.add(fur("far fore", [ff["shape"]], regions=[(ff["sock"], "char")], depth=0.9, dim=0.08))
    C.add(fur("tail", [tail], depth=1.0))
    for k, t in enumerate((0.6, 0.82)):
        C.add(porcelain("tail ring %d" % k, CH.band_across(tail_path, t, 3.2, 16), [CH.band_across(tail_path, t, 1.1, 16)],
                        follow="tail", clip="tail"))
    C.add(Layer("anvil", anvil, "steel", kind="metal", gloss=1.0, depth=0.7, smooth=0.25, rim=0.8, strokes=False, ao=False, ow=0.7))
    ear_layers(C, g, "far")
    C.add(fur("body", [body, fn["upper"], hn["upper"]], regions=[(side, "cream")], depth=1.0))
    C.add(porcelain("hip plate", hip, hip_band))
    C.add(fur("near hind", [hn["lower"]], regions=[(hn["sock"], "char")], depth=1.0))
    C.add(porcelain("pauldron", paul, paul_band, depth=1.2))
    C.add(fur("near fore", [fn["lower"]], regions=[(fn["sock"], "char")], depth=1.0))
    C.add(porcelain("forearm guard", fa, fa_band, follow="near fore", clip="near fore"))
    C.add(fur("head", [[g["cranium"]], g["muzzle"], [g["jaw"]]], regions=[(g["cream"], "cream"), (g["streaks"], "umber")],
              depth=1.0, smooth=0.6))
    ear_layers(C, g, "near")
    for L_ in (ff, fn):                         # three bold pale claws on each forepaw
        x, y, rx, ry, rot = L_["paw_geo"] if "paw_geo" in L_ else (None,) * 5
    for (px_, py_, rx) in ((21, 86.4, 6.8), (42, 87, 5.8)):
        for i in range(3):
            bx = px_ - rx * 0.85 + i * 1.7
            claw = [(bx - 0.7, py_ - 0.4), (bx - 2.6 - i * 0.2, py_ + 1.9), (bx + 0.6, py_ + 0.6)]
            C.paint(fill(claw), (232, 222, 200), "bone")
    seam = line(bezier(D(30, 45.5), D(38, 50.5), D(48, 50.8), D(57, 46), 12), 0.5)
    C.glow(seam, (255, 150, 50), 1.4, 0.7); C.paint(seam, (255, 196, 84), "ember")
    heat = line([A(-3.6, -9.0), A(3.6, -9.0)], 0.6)
    C.glow(heat, (255, 150, 50), 1.6, 0.8); C.paint(heat, (255, 210, 110), "ember")
    G = {"g": g}
    if face_on:
        face(C, g, 3.2, 3.8, 2.0, lid=0.45, mouth="set")
    return C, G


# =============================================================================================== sprites
EYES = {
    "kit": [".KKK.", "KWWKK", "KWKKK", "KKKKK", ".KKK."],
    "open": [".KK.", "KWKK", "KKKK", "KKKK", ".KK."],
    "set": ["LLLL", "KWKK", "KKKK", ".KK."],
    "far": [".K", "KK", "KK", ".K"],
    "far_set": ["LL", "WK", "KK", ".K"],
}


def stamp(img, tpl, cx, cy):
    t = EYES[tpl]
    x0, y0 = int(round(cx - len(t[0]) / 2)), int(round(cy - len(t) / 2))
    cols = {"K": (22, 12, 16), "W": (255, 255, 255), "L": (70, 26, 22)}
    px = img.load()
    for j, row in enumerate(t):
        for i, ch in enumerate(row):
            if ch in cols and 0 <= x0 + i < 96 and 0 <= y0 + j < 96 and px[x0 + i, y0 + j][3]:
                px[x0 + i, y0 + j] = cols[ch] + (255,)


def sprite_face(img, g, near, far, mouth):
    from clean import thin_line_mask, paint
    stamp(img, near, *g["eye_near"])
    stamp(img, far, *g["eye_far"])
    nx, ny = int(round(g["nose"][0])), int(round(g["nose"][1]))
    paint(img, {(nx, ny), (nx + 1, ny), (nx, ny + 1), (nx + 1, ny + 1)}, (24, 12, 16))
    paint(img, {(nx, ny)}, (120, 96, 100))
    a, b = g["mouth_l"], g["mouth_r"]
    if mouth == "smile":
        mid = lerp(a, b, 0.5)
        paint(img, thin_line_mask([a, (mid[0], mid[1] + 0.9), (b[0], b[1] - 0.8)], 0.6), (60, 22, 22))
    else:
        paint(img, thin_line_mask([a, lerp(a, b, 0.6), (b[0], b[1] + 0.3)], 0.6), (60, 22, 22))


SPECS = {
    "wickit": (wickit, ("kit", "far", "smile"), (1.04, (50, 60), (-5, 4), 14)),
    "stoketail": (stoketail, ("open", "far", "smile"), (1.0, (50, 90), (0, 0))),
    "forgel": (forgel, ("set", "far_set", "set"), (0.9, (50, 91), (2.5, 0))),
}


def make(name):
    fn, (near, far, mouth), frame = SPECS[name]
    hd.framing(*frame)
    C, G = fn()
    C0, _ = fn(face_on=False)
    sp = CH.simplify(C0, skip_lines=())
    g = dict(G["g"])
    for k in ("eye_near", "eye_far", "nose", "mouth_l", "mouth_r"):
        g[k] = hd.xp(g[k])
    sprite_face(sp, g, near, far, mouth)
    hd.framing()
    return C, sp


if __name__ == "__main__":
    import sys
    for nm in (sys.argv[1:] or ["wickit", "stoketail", "forgel"]):
        C, sp = make(nm)
        C.image().save(SCR + "cl_" + nm + "_768.png")
        sp.save(SCR + "cl_" + nm + "_96.png")
        CH.show(C, sp, SCR + "cl_" + nm + ".png")
