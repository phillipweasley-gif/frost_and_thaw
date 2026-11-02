"""Cinderwright line, posed with a line of action.
  Wickit    - mid-lope: a weasel's bounding gait humps the back high between strides; front paws landing,
              hind leg pushing off, the tail whipping up behind with its glowing tip, head up toward us.
  Stoketail - rearing to work: a diagonal from the planted hind feet up through the chest; one paw pressing
              clay flat, the other lifting a glowing lump to inspect; the paddle tail swinging out as counterweight.
  Forgel    - the forging blow: low on all fours like a wolverine, shoulders hunched high, one glowing forepaw
              lifted mid-step, head low and forward, the tail arched over its back with the anvil end up high.
Faces: a 3/4 head - skull, a short muzzle pointing at the viewer's left, small low ears at the back of the
skull, the near eye on the side of the face behind the muzzle, the far eye smaller, half-hidden by the bridge."""
import math
from PIL import Image, ImageDraw
from clean import paint, to_mask, smooth_poly_mask, ellipse_pts, outline_of, thin_line_mask, selout, cleanup_clusters, drop_to_ground, ribbon, N
from hires import bezier
from sculpt import Part, render
from cinder_anatomy import E, tube, claws
from cinder3 import RUSSET, CREAM, SOOT, PORC, STEEL, COPPER, COBALT, COBALT_LT, glaze, ember_line
from cinder import EMBER, CLAY, CLAY_O
import final_line as F

CUTS5 = (-0.25, 0.1, 0.42, 0.72)
FUR_LINE = (96, 38, 24)
CUTS4 = (-0.2, 0.3, 0.68)
EYE_DARK, EYE_RIM, AMBER = (30, 14, 10), (16, 6, 4), (214, 132, 40)


def limb(joints, radii):
    """A jointed limb: a tube through each joint, radius per joint."""
    out = []
    for (a, b), (ra, rb) in zip(zip(joints, joints[1:]), zip(radii, radii[1:])):
        out += tube([a, b], [ra, rb])
    return out


def head3q(cx, cy, s, tilt=0.0):
    """A 3/4 weasel head facing the viewer's left. s = skull radius. Returns geometry for parts and the face."""
    t = math.radians(tilt)
    def P(dx, dy):
        return (cx + dx * math.cos(t) - dy * math.sin(t), cy + dx * math.sin(t) + dy * math.cos(t))
    skull = E(*P(0, 0), s * 1.05, s * 0.86, tilt)
    mc = P(-s * 0.95, s * 0.36)
    muzzle = E(mc[0], mc[1], s * 0.62, s * 0.46, tilt - 8)
    cheek = E(*P(-s * 0.35, s * 0.55), s * 0.6, s * 0.38, tilt)          # cream upper lip / cheek
    ear_back = E(*P(s * 0.62, -s * 0.72), s * 0.34, s * 0.34)
    ear_front = E(*P(-s * 0.18, -s * 0.84), s * 0.28, s * 0.28)
    g = {"skull": skull, "muzzle": muzzle, "cheek": cheek, "ear_back": ear_back, "ear_front": ear_front,
         "eye_near": P(-s * 0.32, -s * 0.06), "eye_far": P(-s * 0.98, -s * 0.18), "nose": P(-s * 1.52, s * 0.18),
         "mouth": [P(-s * 1.38, s * 0.6), P(-s * 1.06, s * 0.72), P(-s * 0.74, s * 0.62)], "s": s,
         "notch": P(s * 0.62, -s * 1.02)}
    return g


def face(img, g, eye_scale=1.0):
    s = g["s"]
    for key, w, h in (("eye_near", 0.27, 0.31), ("eye_far", 0.18, 0.27)):
        cx, cy = g[key]
        ew, eh = max(1.2, s * w * eye_scale), max(1.5, s * h * eye_scale)
        m = to_mask(smooth_poly_mask([ellipse_pts(cx, cy, ew, eh, 24)]), 0.42, False)
        paint(img, m, EYE_DARK)
        paint(img, {(x, y) for (x, y) in m if y > cy + eh * 0.3}, AMBER)
        paint(img, outline_of(m), EYE_RIM)
        hx, hy = int(round(cx - ew * 0.25)), int(round(cy - eh * 0.3))
        if (hx, hy) in m:
            paint(img, {(hx, hy)}, (255, 255, 255))
    nx, ny = g["nose"]
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(nx, ny, max(1.1, s * 0.15), max(0.9, s * 0.12), 16)]), 0.4, False), (36, 18, 16))
    paint(img, thin_line_mask(g["mouth"], 0.7), (104, 52, 32))


def inner_ears(img, g, mask):
    for key, k in (("ear_back", 0.55), ("ear_front", 0.5)):
        pts = g[key]
        cx = sum(x for x, _ in pts) / len(pts); cy = sum(y for _, y in pts) / len(pts)
        r = g["s"] * (0.34 if key == "ear_back" else 0.28) * k
        m = to_mask(smooth_poly_mask([ellipse_pts(cx + 0.3, cy + 0.3, r, r, 16)]), 0.4, False) & mask
        paint(img, m - outline_of(mask), CREAM[1])


def notch(img, x, y):
    px = img.load()
    x = int(round(x))
    col = [yy for yy in range(N) if px[x, yy][3] > 0 and abs(yy - y) < 6]
    if col:
        t = min(col)
        for p in ((x, t), (x, t + 1), (x + 1, t)):
            px[p] = (0, 0, 0, 0)


def glow_tip(img, mask, core_at):
    F.halo(img, mask, EMBER[2], 150)
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(core_at[0], core_at[1], 1.3, 1.8, 12)]), 0.35, False), EMBER[3])


# ===============================================================================================
def wickit():
    spine = bezier((64, 78), (56, 62), (42, 62), (34, 72), 24)               # the hump of the bounding gait
    body = tube(spine, [6.4, 7.4, 7.0, 6.4])
    neck = tube([(35, 71), (30, 66)], [5.0, 4.6])
    g = head3q(26, 61, 8.6, tilt=-6)
    fore_near = limb([(36, 74), (32, 80), (29, 85)], [3.6, 3.0, 2.6]) + [E(27.5, 86.2, 3.8, 2.0)]
    fore_far = limb([(41, 74), (41, 80), (38, 83)], [3.0, 2.6, 2.2]) + [E(37, 83.6, 3.0, 1.8, -20)]
    hind_near = limb([(60, 76), (65, 81), (70, 85)], [5.0, 3.4, 2.6]) + [E(73, 86.4, 5.0, 2.0, 8)]
    hind_far = limb([(57, 78), (53, 83), (52, 86)], [4.0, 2.8, 2.2]) + [E(50, 86.6, 3.8, 1.8)]
    tail = tube(bezier((64, 76), (76, 70), (80, 54), (74, 44), 28), [3.0, 2.8, 2.4, 2.2])
    tip = [[(73.5, 35.0), (76.5, 40.5), (76.6, 44.0), (73.8, 46.6), (70.8, 44.6), (70.6, 41.2)]]
    belly = [[(30, 68), (36, 72), (44, 76), (52, 80), (58, 84), (50, 82), (40, 78), (32, 74)]]
    parts = [
        Part(hind_far + fore_far, RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, regions=[(hind_far[-1:] + fore_far[-1:], SOOT)], shadow=None),
        Part(tail, RUSSET, outline=FUR_LINE, depth=3, cuts=CUTS5, shadow=None),
        Part([g["ear_back"]], RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, shadow=None),
        Part(body + neck, RUSSET, outline=FUR_LINE, depth=6, cuts=CUTS5, regions=[(belly, CREAM)], shadow=(1, 1)),
        Part(hind_near, RUSSET, outline=FUR_LINE, depth=3, cuts=CUTS5, regions=[(hind_near[-1:], SOOT)], shadow=(1, 1)),
        Part(fore_near, RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, regions=[(fore_near[-1:] + tube([(29, 80), (27, 83)], [2.0, 2.0]), SOOT)], shadow=(1, 1)),
        Part([g["skull"], g["muzzle"]], RUSSET, outline=FUR_LINE, depth=6, cuts=CUTS5, regions=[([g["cheek"], g["muzzle"]], CREAM)], shadow=(1, 2)),
        Part([g["ear_front"]], RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, shadow=None),
        Part(tip, EMBER, depth=3, cuts=(-0.3, 0.2, 0.6), outline=(150, 70, 14), shadow=None),
    ]
    img = cleanup_clusters(render(parts))
    inner_ears(img, g, parts[2].mask | parts[7].mask)
    face(img, g)
    glow_tip(img, parts[-1].mask, (73.6, 42.6))
    notch(img, *g["notch"])
    return drop_to_ground(selout(img), 90)


def stoketail():
    spine = bezier((56, 78), (52, 64), (46, 52), (40, 45), 24)              # a forward-leaning diagonal
    body = tube(spine, [8.0, 6.6, 7.6, 7.0])
    neck = tube([(40, 45), (35, 38)], [5.2, 4.6])
    g = head3q(31, 31, 7.0, tilt=-10)
    hind_near = limb([(52, 78), (46, 84), (47, 88)], [6.4, 3.4, 2.6]) + [E(43, 89.4, 6.4, 2.0)]
    hind_far = limb([(60, 80), (64, 86)], [5.0, 2.6]) + [E(65, 89.2, 5.2, 1.8)]
    arm_press = limb([(40, 52), (33, 60), (26, 66)], [3.6, 3.0, 2.6]) + [E(23.5, 67.5, 3.8, 2.0, 8)] + claws(20.5, 68.5, 3, 2.6, 18, 175)
    arm_lift = limb([(45, 52), (39, 50), (33, 47)], [3.2, 2.8, 2.4]) + [E(31, 46.5, 2.8, 2.4, -30)]
    clay = [E(27.5, 45.0, 3.2, 2.6, -15)]
    slab = [E(23, 70.2, 6.5, 1.8)]
    tail = tube(bezier((58, 76), (70, 80), (78, 72), (82, 62), 24), [5.4, 4.6, 3.8, 3.2])
    paddle = [E(84.5, 55.5, 4.4, 8.6, 18)]
    belly = [[(31, 38), (38, 44), (44, 54), (48, 66), (52, 78), (46, 76), (40, 62), (34, 50)]]
    shoulder = [E(43.5, 51, 6.2, 4.6, 35)]
    guard_press = [E(32.5, 61, 3.8, 2.8, -40)]
    guard_lift = [E(37.5, 49.2, 3.2, 2.4, 20)]
    parts = [
        Part(hind_far, RUSSET, outline=FUR_LINE, depth=3, cuts=CUTS5, regions=[(hind_far[-1:], SOOT)], shadow=None),
        Part(tail + paddle, RUSSET, outline=FUR_LINE, depth=3, cuts=CUTS5, shadow=None),
        Part([g["ear_back"]], RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, shadow=None),
        Part(arm_lift, RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, regions=[(arm_lift[-1:], SOOT)], shadow=None),
        Part(guard_lift, PORC, depth=2, cuts=CUTS4, outline=(70, 80, 108), shadow=None),
        Part(body + neck, RUSSET, outline=FUR_LINE, depth=7, cuts=CUTS5, regions=[(belly, CREAM)], shadow=(1, 1)),
        Part(hind_near, RUSSET, outline=FUR_LINE, depth=4, cuts=CUTS5, regions=[(hind_near[-1:], SOOT)], shadow=(1, 1)),
        Part(shoulder, PORC, depth=3, cuts=CUTS4, outline=(70, 80, 108), shadow=(1, 1)),
        Part(slab, CLAY, depth=2, cuts=CUTS4, outline=CLAY_O, shadow=None),
        Part(arm_press, RUSSET, outline=FUR_LINE, depth=3, cuts=CUTS5, regions=[(arm_press[-4:], SOOT)], shadow=(1, 1)),
        Part(guard_press, PORC, depth=2, cuts=CUTS4, outline=(70, 80, 108), shadow=None),
        Part([g["skull"], g["muzzle"]], RUSSET, outline=FUR_LINE, depth=6, cuts=CUTS5, regions=[([g["cheek"], g["muzzle"]], CREAM)], shadow=(1, 2)),
        Part([g["ear_front"]], RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, shadow=None),
        Part(clay, CLAY, depth=2, cuts=CUTS4, outline=CLAY_O, shadow=None),
    ]
    img = cleanup_clusters(render(parts))
    for i in (4, 7, 10):
        glaze(img, parts[i].mask)
    inner_ears(img, g, parts[2].mask | parts[12].mask)
    face(img, g)
    # the lump of clay glows where its paw has warmed it
    paint(img, {(26, 44), (27, 44)}, EMBER[1])
    F.halo(img, parts[-1].mask, EMBER[1], 60)
    # paddle: a ridge down each side and the glowing seam along its underside
    paint(img, thin_line_mask(bezier((81.5, 50), (82.5, 54), (83.5, 58), (84, 62), 8), 0.7), RUSSET[1])
    ember_line(img, bezier((87.6, 49.5), (89.4, 54), (89.4, 58), (87.4, 63), 10), 0.8)
    for (x, y) in ((91, 47), (93, 52)):
        paint(img, {(x, y)}, EMBER[3])
    notch(img, *g["notch"])
    return drop_to_ground(selout(img), 91)


def forgel():
    spine = bezier((70, 70), (62, 54), (48, 48), (36, 58), 24)              # hips low, shoulders hunched high
    body = tube(spine, [12.5, 13.0, 14.5, 14.5])
    neck = tube([(36, 58), (29, 63)], [10.0, 9.0])
    g = head3q(21, 64, 10.4, tilt=-4)
    fore_near = limb([(34, 70), (30, 78), (22, 80)], [8.0, 6.6, 5.6]) + [E(18.5, 80.5, 6.0, 4.4, -25)] + claws(13.5, 82.5, 4, 3.6, 16, 165)   # lifted mid-step
    fore_lift = limb([(46, 70), (44, 80), (42, 86)], [6.8, 5.6, 4.8]) + [E(39.5, 88.6, 7.0, 2.6)] + claws(33.5, 89.2, 4, 3.0, 16, 180)       # planted
    hind_near = limb([(66, 70), (73, 78), (70, 84), (67, 88)], [11.0, 7.0, 5.4, 4.4]) + [E(65, 89.4, 8.4, 2.8)]
    hind_far = limb([(58, 72), (56, 81), (54, 87)], [8.0, 5.4, 4.2]) + [E(51.5, 89.0, 6.6, 2.4)]
    tail = tube(bezier((72, 64), (90, 54), (90, 28), (70, 16), 28), [8.6, 7.8, 7.0, 6.4])
    anvil = [[(54, 7.6), (74, 7.0), (78, 8.4), (78, 15.0), (62, 15.4), (52, 12.6), (44, 10.6), (54, 10.4)]]
    belly = [[(14, 68), (24, 70), (34, 72), (44, 74), (56, 78), (66, 80), (60, 84), (46, 82), (32, 80), (20, 74)]]
    side_band = [ribbon(bezier((38, 62), (48, 54), (60, 56), (70, 66), 18), 3.4, 2.6)]      # a wolverine's pale side stripe
    plate_hump = [ribbon(bezier((32, 50), (40, 40), (52, 40), (61, 48), 16), 5.4, 4.6)]
    plate_fore = [ribbon([(31, 76), (24, 79)], 5.0, 4.4)]
    plate_hip = [ribbon(bezier((63, 58), (69, 60), (74, 64), (76, 70), 12), 4.4, 3.6)]
    parts = [
        Part(hind_far, RUSSET, outline=FUR_LINE, depth=4, cuts=CUTS5, regions=[(hind_far[len(hind_far) // 2:], SOOT)], shadow=None),
        Part(fore_lift, RUSSET, outline=FUR_LINE, depth=4, cuts=CUTS5, regions=[(fore_lift[len(fore_lift) // 2:], SOOT)], shadow=None),
        Part(tail, RUSSET, outline=FUR_LINE, depth=5, cuts=CUTS5, shadow=None),
        Part(anvil, STEEL, depth=3, cuts=(-0.25, 0.1, 0.4, 0.7), outline=COPPER[0], shadow=None),
        Part([g["ear_back"]], RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, shadow=None),
        Part(body + neck, RUSSET, outline=FUR_LINE, depth=10, cuts=CUTS5, regions=[(belly, CREAM), (side_band, CREAM)], shadow=(1, 1)),
        Part(plate_hump + plate_hip, STEEL, depth=3, cuts=(-0.25, 0.1, 0.4, 0.7), outline=COPPER[1], shadow=(1, 1)),
        Part(hind_near, RUSSET, outline=FUR_LINE, depth=6, cuts=CUTS5, regions=[(hind_near[len(hind_near) * 2 // 3:], SOOT)], shadow=(1, 1)),
        Part(fore_near, RUSSET, outline=FUR_LINE, depth=5, cuts=CUTS5, regions=[(fore_near[len(fore_near) // 2:], SOOT)], shadow=(1, 1)),
        Part(plate_fore, STEEL, depth=3, cuts=(-0.25, 0.1, 0.4, 0.7), outline=COPPER[1], shadow=None),
        Part([g["skull"], g["muzzle"]], RUSSET, outline=FUR_LINE, depth=7, cuts=CUTS5, regions=[([g["cheek"], g["muzzle"]], CREAM)], shadow=(1, 2)),
        Part([g["ear_front"]], RUSSET, outline=FUR_LINE, depth=2, cuts=CUTS5, shadow=None),
    ]
    img = cleanup_clusters(render(parts))
    inner_ears(img, g, parts[4].mask | parts[11].mask)
    face(img, g, eye_scale=0.9)
    # furnace glow along the gap under the hump plate, the chest ember, the lifted paw's glowing pads
    ember_line(img, bezier((34, 55), (42, 46), (52, 46), (60, 53), 14), 0.8)
    ember_line(img, [(31, 69), (33, 72), (32, 75)], 0.9)
    for (x, y, r) in ((19.0, 82.4, 1.9), (14.8, 83.2, 0.9), (16.8, 84.4, 0.9), (19.8, 84.8, 0.9)):
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(x, y, r, r * 0.8, 12)]), 0.35, False), EMBER[1])
    F.halo(img, parts[8].regions[0][0], EMBER[1], 70)
    # the anvil: a bright flat striking face, and heat building in it for the blow
    paint(img, thin_line_mask([(54, 7.4), (74, 6.8), (77.4, 8)], 0.7), STEEL[4])
    ember_line(img, [(60, 15.2), (68, 15.2), (76, 14.6)], 0.8)
    for (x, y, c) in ((65, 11, COBALT), (66, 11, COBALT_LT), (64, 11, COBALT_LT), (65, 10, COBALT_LT), (65, 12, COBALT_LT)):
        paint(img, {(x, y)}, c)
    notch(img, *g["notch"])
    return drop_to_ground(selout(img), 93)


def line_of_action(img, pts, colour=(230, 60, 60, 255)):
    d = ImageDraw.Draw(img)
    d.line([(x * 3, y * 3) for x, y in pts], fill=colour, width=3)


if __name__ == "__main__":
    out = Image.new("RGBA", (3 * 288 + 40, 300), (72, 80, 104, 255))
    for i, fn in enumerate((wickit, stoketail, forgel)):
        out.alpha_composite(fn().resize((288, 288), Image.NEAREST), (10 + i * 298, 6))
    out.save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/pose1.png")
