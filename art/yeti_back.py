"""Yetot and Yetitan seen from behind - drawn, not repainted from the front.

What you see of a great ape from behind (gorilla reference):
  - the head sits LOW and forward: from behind only the crown and the back of the skull show above a
    hump of trapezius muscle; no neck
  - the back is broad at the shoulders and narrows to the hips; the spine is a shallow furrow
  - the long arms hang forward of the body, so from behind they show as the backs of the upper arms
    and the outer forearms, with the knuckles/backs of the hands at the bottom
  - the legs are short and bowed; the heels and the backs of the soles show at the ground
Yeti specifics (from the concept sheet): crest of flame-shaped locks on the crown, round blue-grey
ears, white shaggy fur with lavender shadows, blue-grey hands and feet, and (Yetitan) faceted ice
plates along the outer forearms. Yetot keeps its pose from the front: one hand up, a snowball in the
other.

Drawn in the file's orientation: the game mirrors back sprites when it shows them.
"""
import math, random
from PIL import Image
from clean import Layer, compose, N, ellipse_pts, selout, cleanup_clusters
from yeti_anatomy import E, tube, tufts

FUR = [(146, 136, 156), (192, 182, 192), (228, 218, 212), (250, 244, 232)]
FUR_OL = (92, 82, 98)
SKIN = [(78, 92, 130), (112, 128, 166), (148, 166, 202), (178, 198, 226)]
SKIN_OL = (44, 50, 76)
ICE = [(90, 132, 194), (146, 192, 230), (204, 230, 250), (240, 250, 255)]
ICE_OL = (48, 70, 120)
SNOW = [(190, 200, 220), (226, 232, 244), (246, 250, 255), (255, 255, 255)]


def fur(polys, depth=8, cuts=(-0.15, 0.3, 0.7)):
    return Layer(polys, FUR, depth=depth, cuts=cuts, outline=FUR_OL)


def skin(polys, depth=4):
    return Layer(polys, SKIN, depth=depth, cuts=(-0.1, 0.35, 0.75), outline=SKIN_OL)


def lock(x, y, ang, length, w):
    """One flame-shaped lock of fur (base at x, y), curving a little at the tip."""
    a = math.radians(ang)
    pts = []
    for i in range(7):
        t = i / 6
        aa = a + math.radians(18) * t * t
        pts.append((x + math.cos(aa) * length * t, y + math.sin(aa) * length * t))
    return tube(pts, [w, w * 0.75, 0.4])


def streaks(img, rng, region=None, k=0.9):
    """Fur texture: short downward strokes one shade darker, in the fur only (never on the outline)."""
    px = img.load()
    fur_set = {c + (255,) for c in FUR[1:]}
    for y in range(1, N - 3):
        for x in range(1, N - 1):
            if region and not region(x, y):
                continue
            if px[x, y] in fur_set and rng.random() < 0.075 * k:
                i = FUR.index(px[x, y][:3])
                for dy in range(rng.choice((2, 3, 3, 4))):
                    q = (x, y + dy)
                    if px[q] in fur_set and FUR.index(px[q][:3]) == i:
                        px[q] = FUR[i - 1] + (255,)
    return img


def crystals(cx, cy, length, ang, n, size):
    """Faceted ice plates along a forearm: pointed diamonds leaning outward."""
    out = []
    a = math.radians(ang)
    for i in range(n):
        t = (i + 0.5) / n
        x, y = cx + math.cos(a) * length * (t - 0.5), cy + math.sin(a) * length * (t - 0.5)
        s = size * (0.75 + 0.5 * math.sin(t * math.pi))
        na = a - math.pi / 2
        tip = (x + math.cos(na) * s * 1.6, y + math.sin(na) * s * 1.6)
        out.append([(x - math.cos(a) * s * 0.7, y - math.sin(a) * s * 0.7), tip,
                    (x + math.cos(a) * s * 0.7, y + math.sin(a) * s * 0.7),
                    (x + math.cos(na) * -s * 0.35, y + math.sin(na) * -s * 0.35)])
    return out


# ------------------------------------------------------------------------------------------ Yetot
def yetot_back():
    rng = random.Random(587)
    L = []
    # snowball hand (behind the body on its far side? no: held out at the side, in front of the viewer)
    body = [E(48, 63, 18, 19)]
    body_locks = tufts(48, 63, 15, 10, 170, 9, 7, 2.8)                 # shaggy skirt round the hips
    side_locks = tufts(48, 60, 16, 150, 215, 3, 5, 2.4) + tufts(48, 60, 16, -35, 30, 3, 5, 2.4)
    legs = [E(39, 82, 7.5, 7), E(58, 82, 7.5, 7)]
    heels = [E(38, 88.5, 7.5, 3.6), E(59, 88.5, 7.5, 3.6)]
    L.append(skin(heels, depth=3))
    L.append(fur(legs, depth=5))
    # the raised arm (file left): the back of the upper arm, then the back of the hand, fingers up
    arm_up = tube([(36, 56), (29, 50), (25, 44)], [6.0, 5.2, 4.6])
    hand_up = [E(23, 40, 5.6, 5.2)] + [E(19 + i * 3.0, 34.5 + abs(i - 1.5) * 0.8, 1.7, 2.6) for i in range(4)]
    # the snowball arm (file right): forearm out to the side, hand cupped under the ball
    arm_ball = tube([(62, 60), (69, 63), (73, 64)], [5.6, 5.0, 4.6])
    ball = [E(76, 56, 6.5, 6.2)]
    hand_ball = [E(74, 63, 5.2, 4.2)]
    L.append(fur(body + body_locks + side_locks, depth=10))
    L.append(fur(arm_up, depth=4))
    L.append(skin(hand_up, depth=3))
    L.append(Layer([E(76, 56, 6.5, 6.2)], SNOW, depth=5, cuts=(-0.1, 0.3, 0.7), outline=(150, 160, 190)))
    L.append(fur(arm_ball, depth=4))
    L.append(skin(hand_ball, depth=3))
    # head from behind: a big round mane sunk into the shoulders, crest of locks on the crown
    ears = [E(30.5, 40, 3.6, 3.4), E(65.5, 40, 3.6, 3.4)]
    L.insert(2, skin(ears, depth=2))
    head = [E(48, 40, 17, 15)]
    mane = tufts(48, 42, 14, 115, 245, 5, 5, 2.6) + tufts(48, 42, 14, -65, 65, 5, 5, 2.6) + \
        tufts(48, 48, 12, 60, 120, 4, 6, 2.6)                          # locks spilling onto the back
    crest = lock(42, 28, -112, 11, 3.2) + lock(48, 27, -88, 14, 3.4) + lock(55, 28, -62, 10, 3.0) + \
        lock(38, 32, -140, 7, 2.6)
    L.append(fur(head + mane + crest, depth=9))
    img = compose(L)
    # the spine's parting and the shadow where the mane overhangs the back
    px = img.load()
    for y in range(52, 76):
        x = 48 + (1 if y > 66 else 0)
        if px[x, y][3] == 255 and px[x, y][:3] in FUR:
            px[x, y] = FUR[max(0, FUR.index(px[x, y][:3]) - 1)] + (255,)
    for x in range(36, 61):
        for y in range(53, 57):
            if px[x, y][3] == 255 and px[x, y][:3] in FUR[2:] and (y == 53 + (x * 7) % 3):
                px[x, y] = FUR[1] + (255,)
    # blue patches on the outer forearms (as on the front)
    for (x, y) in ((27, 47), (28, 46), (26, 48), (70, 62), (71, 61), (69, 63)):
        if px[x, y][3] == 255:
            px[x, y] = SKIN[2] + (255,)
    streaks(img, rng)
    return selout(cleanup_clusters(img, 1))


# ---------------------------------------------------------------------------------------- Yetitan
def yetitan_back():
    rng = random.Random(588)
    L = []
    # legs: short, bowed, crouched; heels and the backs of the soles on the ground
    heels = [E(27, 88.5, 10, 3.8), E(70, 88.5, 10, 3.8)]
    thighs = [E(31, 76, 11, 10, -15), E(66, 76, 11, 10, 15)]
    L.append(skin(heels, depth=3))
    L.append(fur(thighs + tufts(31, 79, 8, 40, 150, 4, 5, 2.6) + tufts(66, 79, 8, 30, 140, 4, 5, 2.6), depth=7))
    # the broad back: shoulders wide, narrowing to the hips, with the trapezius hump
    back = [[(10, 34), (16, 20), (30, 12), (48, 10), (66, 12), (80, 20), (86, 34), (78, 52), (70, 66),
             (48, 72), (26, 66), (18, 52)]]
    skirt = tufts(48, 60, 18, 25, 155, 7, 7, 2.8)
    L.append(fur(back + skirt, depth=14, cuts=(-0.2, 0.25, 0.65)))
    # arms hanging forward and out: backs of the upper arms, outer forearms with ice plates
    upper_l = tube([(20, 26), (13, 38), (11, 48)], [10, 9, 8])
    upper_r = tube([(76, 26), (83, 38), (85, 48)], [10, 9, 8])
    fore_l = tube([(11, 46), (9, 58), (10, 66)], [8.5, 8, 7])
    fore_r = tube([(85, 46), (87, 60), (85, 70)], [8.5, 8, 7])
    fist_l = [E(12, 70, 7, 5.5)]
    hand_r = [E(83, 75, 7.5, 5.5)] + [E(77 + i * 3.6, 79.5, 1.9, 2.2) for i in range(4)]
    L.append(fur(upper_l + upper_r, depth=7))
    L.append(fur(fore_l + fore_r, depth=6))
    L.append(Layer(crystals(5, 56, 22, 95, 4, 3.6) + crystals(92, 58, 24, 85, 4, 3.6),
                   ICE, depth=3, cuts=(-0.1, 0.35, 0.75), outline=ICE_OL))
    L.append(skin(fist_l + hand_r, depth=3))
    # head from behind, low between the shoulders: crown, crest of locks, ears at the sides
    ears = [E(38, 19, 3.2, 3), E(62, 19, 3.2, 3)]
    L.append(skin(ears, depth=2))
    head = [E(50, 18, 11.5, 10)]
    crest = lock(45, 11, -110, 9, 3.0) + lock(50, 10, -86, 12, 3.2) + lock(56, 11, -62, 9, 2.8)
    hump = tufts(50, 22, 9, 25, 155, 6, 6, 2.6)                       # mane falling onto the hump
    L.append(fur(head + crest + hump, depth=7))
    img = compose(L)
    px = img.load()
    # spine furrow and shoulder blades: shading drawn into the fur
    for y in range(30, 66):
        x = 48 + int(round(math.sin(y / 9) * 0.6))
        if px[x, y][3] == 255 and px[x, y][:3] in FUR:
            px[x, y] = FUR[max(0, FUR.index(px[x, y][:3]) - 1)] + (255,)
    for (cx, cy) in ((36, 34), (61, 34)):                             # shoulder-blade shadows below and inside
        for t in range(10):
            x, y = int(cx + (t - 5) * 0.9 * (1 if cx < 48 else -1)), int(cy + 6 + t * 0.4)
            if px[x, y][3] == 255 and px[x, y][:3] in FUR[2:]:
                px[x, y] = FUR[1] + (255,)
    streaks(img, rng)
    return selout(cleanup_clusters(img, 1))


def show(imgs, path, z=4, bg=(120, 150, 190, 255)):
    out = Image.new("RGBA", (len(imgs) * (N * z + 10) + 10, N * z + 20), bg)
    for i, im in enumerate(imgs):
        out.alpha_composite(im.resize((N * z, N * z), Image.NEAREST), (10 + i * (N * z + 10), 10))
    out.save(path)


if __name__ == "__main__":
    import sys
    r = "/home/claude/frost-thaw/build/concept/yeti_sprites/"
    a, b = yetot_back(), yetitan_back()
    a.save(r + "yetot_back_96.png"); b.save(r + "yetitan_back_96.png")
    fa = Image.open(r + "yetot_96.png"); fb = Image.open(r + "yetitan_96.png")
    show([fa, a, fb, b], sys.argv[1] if len(sys.argv) > 1 else "/tmp/yb.png", z=4)
