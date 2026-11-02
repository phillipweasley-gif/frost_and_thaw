"""Yeti line: first silhouettes, built from real animal anatomy.

The D&D yeti (Icewind Dale): a large bipedal beast covered in shaggy white fur, sharp claws,
a chilling, fear-freezing gaze; runs and climbs fast; afraid of fire. Cubs are stolen for rituals.

What the real animals actually are:
  GORILLA (build)      - arms LONGER than legs; knuckle-walks on the backs of the middle finger
                         joints; massive shoulders and trapezius so the head sits LOW, almost no
                         neck; males have a sagittal crest (a peaked skull); barrel chest and
                         belly; short, slightly bowed legs; broad flat feet.
  POLAR BEAR (feet)    - huge plantigrade paws, furred soles, short thick black claws; black skin
                         under white guard hairs (the shadows in the fur read blue-grey).
  JAPANESE MACAQUE     - thick fur heaviest on the crown, cheeks and shoulders (a mane/hood);
  (face, young)          bare face set in a ring of fur; short tail; infants have big heads and
                         eyes, wispy fur, and CLING to the mother's belly or back.
  MOUNTAIN GOAT (coat) - shaggy white coat that hangs into a beard under the chin and
                         "pantaloons" on the upper legs; short black dagger horns curving back.
  (Rime's yetis are drawn with short horns and a blue-grey face: kept here.)

Mapping:
  baby  = macaque infant proportions (head ~ 45% of height), a fur ball with stubby limbs,
          horn nubs, a bare blue-grey face disc, big dark eyes; reaching up to be carried
  adult = gorilla build with a goat's beard and pantaloons and short black horns; bare blue-
          grey face in a hood of fur; polar-bear paws and black claws
"""
import math
from PIL import Image, ImageDraw
from clean import smooth_poly_mask, ellipse_pts, to_mask, N
from hires import bezier


def E(cx, cy, rx, ry, rot=0.0, n=40):
    c, s = math.cos(math.radians(rot)), math.sin(math.radians(rot))
    return [(cx + x * c - y * s, cy + x * s + y * c) for x, y in ellipse_pts(0, 0, rx, ry, n)]


def tube(path, radii, step=0.5):
    k = len(radii) - 1
    total = sum(math.hypot(b[0] - a[0], b[1] - a[1]) for a, b in zip(path, path[1:])) or 1
    out, run = [], 0.0
    for a, b in zip(path, path[1:]):
        seg = math.hypot(b[0] - a[0], b[1] - a[1])
        n = max(1, int(seg / step))
        for j in range(n):
            t = j / n
            u = (run + seg * t) / total
            i = min(int(u * k), k - 1)
            r = radii[i] + (radii[i + 1] - radii[i]) * (u * k - i)
            out.append(ellipse_pts(a[0] + (b[0] - a[0]) * t, a[1] + (b[1] - a[1]) * t, r, r, 16))
        run += seg
    return out


def claws(x, y, n, length, spread, ang, w=0.8):
    polys = []
    for i in range(n):
        a = math.radians(ang + (i - (n - 1) / 2) * spread)
        bx, by = x, y
        tx, ty = x + math.cos(a) * length, y + math.sin(a) * length
        nx, ny = -math.sin(a) * w, math.cos(a) * w
        polys.append([(bx + nx, by + ny), (tx, ty), (bx - nx, by - ny)])
    return polys


def tufts(cx, cy, r, a0, a1, n, length, w=3.0):
    """Shaggy fur: pointed locks around an arc (angles in degrees, 0 = right, 90 = down)."""
    polys = []
    for i in range(n):
        a = math.radians(a0 + (a1 - a0) * (i + 0.5) / n)
        bx, by = cx + math.cos(a) * r, cy + math.sin(a) * r
        tx, ty = cx + math.cos(a) * (r + length), cy + math.sin(a) * (r + length)
        nx, ny = -math.sin(a) * w, math.cos(a) * w
        polys.append([(bx + nx, by + ny), (tx, ty), (bx - nx, by - ny)])
    return polys


def horn(x, y, length, ang, curve, w=1.8):
    """A short dagger horn sweeping back (mountain goat)."""
    a = math.radians(ang)
    pts = []
    for i in range(9):
        t = i / 8
        aa = a + math.radians(curve) * t
        pts.append((x + math.cos(aa) * length * t, y + math.sin(aa) * length * t))
    return tube(pts, [w, w * 0.8, 0.9])


def sil(parts, colour=(24, 22, 30)):
    m = to_mask(smooth_poly_mask(parts), 0.5)
    img = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    px = img.load()
    for p in m:
        px[p] = colour + (255,)
    return img


# ---------------------------------------------------------------- babies ----------------------
def baby_a():
    """Macaque infant, sitting, arms up to be carried."""
    body = [E(48, 74, 15, 14)]
    fluff = tufts(48, 74, 11, 20, 160, 7, 6)
    head = [E(48, 50, 15, 13)]
    hood = tufts(48, 50, 10, 190, 350, 8, 5)
    feet = [E(38, 88, 6, 3.4), E(58, 88, 6, 3.4)]
    arm_l = tube([(36, 66), (28, 54), (26, 44)], [4.6, 4.0, 3.6]) + [E(26, 42, 4, 3.6)]
    arm_r = tube([(60, 66), (68, 54), (70, 44)], [4.6, 4.0, 3.6]) + [E(70, 42, 4, 3.6)]
    nubs = horn(40, 42, 11, -120, -20, 2.6) + horn(56, 42, 11, -60, 20, 2.6)
    return body + fluff + head + hood + feet + arm_l + arm_r + nubs


def baby_b():
    """A fur ball: almost round, stubby limbs, face disc peeking out."""
    ball = [E(48, 66, 24, 22)]
    shag = tufts(48, 66, 18, 0, 360, 18, 7, 3.0)
    feet = [E(36, 89, 6.5, 3.4), E(60, 89, 6.5, 3.4)]
    paws = [E(23, 70, 4.6, 4.0), E(73, 70, 4.6, 4.0)]
    nubs = horn(38, 50, 14, -125, -20, 2.8) + horn(58, 50, 14, -55, 20, 2.8)
    return ball + shag + feet + paws + nubs


def baby_c():
    """Toddler upright (gorilla infant), one hand grabbing at something, belly round."""
    legs = tube([(42, 88), (43, 78)], [4.6, 5.0]) + tube([(55, 88), (54, 78)], [4.6, 5.0])
    feet = [E(40, 89, 6, 3.0), E(57, 89, 6, 3.0)]
    body = [E(48, 70, 13, 13)]
    belly = tufts(48, 70, 9, 30, 150, 5, 6)
    head = [E(47, 47, 13.5, 12)]
    crown = tufts(47, 46, 8, 200, 340, 6, 6)
    arm_l = tube([(37, 64), (31, 72), (30, 80)], [4.4, 4.0, 3.6]) + [E(30, 82, 3.8, 3.4)]
    arm_r = tube([(59, 62), (68, 56), (76, 52)], [4.4, 4.0, 3.6]) + [E(78, 51, 4.2, 3.6)] + claws(81, 50, 3, 3, 25, -20, 0.7)
    nubs = horn(40, 40, 10, -125, -20, 2.6) + horn(54, 40, 10, -55, 20, 2.6)
    return legs + feet + body + belly + head + crown + arm_l + arm_r + nubs


# ---------------------------------------------------------------- adults ----------------------
def adult_a():
    """Gorilla knuckle-walk, three-quarter view; goat beard and pantaloons; short horns."""
    torso = [E(56, 52, 24, 19, -14)]                                   # barrel chest, shoulders high
    rump = [E(72, 64, 13, 12)]
    shoulder_mane = tufts(54, 50, 15, 200, 320, 8, 9, 3.2)
    neck = [E(32, 54, 7, 8)]
    head = [E(20, 54, 10, 9)]                                         # low, thrust ahead of the shoulders
    crest = [E(22, 46, 5, 4)]                                         # sagittal crest
    beard = tufts(19, 59, 5, 60, 140, 4, 8, 2.8)
    horns = horn(18, 47, 13, -110, 70, 2.8) + horn(26, 47, 12, -80, 70, 2.6)
    arm_f = tube([(38, 56), (30, 72), (28, 86)], [8.5, 7.5, 6.5]) + [E(27, 88, 7.5, 4.2)] + claws(21, 90, 3, 4, 22, 180)
    arm_b = tube([(58, 58), (56, 72), (56, 85)], [7.0, 6.2, 5.6]) + [E(56, 88, 6.2, 3.8)]
    leg = tube([(76, 70), (80, 80), (78, 88)], [8.0, 7.0, 6.4]) + [E(77, 90, 8.5, 3.2)]
    pants = tufts(77, 76, 5, 0, 130, 5, 7, 2.8)
    return torso + rump + shoulder_mane + neck + head + crest + beard + horns + arm_f + arm_b + leg + pants


def adult_b():
    """Upright brute, front-facing: a hood of fur shrouding the face, yak skirt, huge paws."""
    body = [E(48, 58, 22, 25)]
    skirt = tufts(48, 64, 17, 20, 160, 9, 10, 3.0)
    head = [E(48, 30, 12, 11)]
    hood = tufts(48, 32, 8, 170, 370, 10, 6, 3.0)
    horns = horn(40, 24, 16, -150, 50, 3.0) + horn(56, 24, 16, -30, -50, 3.0)
    arm_l = tube([(29, 44), (18, 58), (16, 74)], [8, 7, 6]) + [E(15, 78, 7.5, 6.5)] + claws(12, 84, 4, 4.5, 18, 110)
    arm_r = tube([(67, 44), (78, 58), (80, 74)], [8, 7, 6]) + [E(81, 78, 7.5, 6.5)] + claws(84, 84, 4, 4.5, 18, 70)
    legs = tube([(38, 80), (36, 88)], [8, 7]) + tube([(58, 80), (60, 88)], [8, 7])
    feet = [E(34, 90, 9, 3.4), E(62, 90, 9, 3.4)]
    return body + skirt + head + hood + horns + arm_l + arm_r + legs + feet


def adult_c():
    """Hunched charger: enormous arms raised to slam, small crested head buried in a mane."""
    torso = [E(50, 58, 24, 21)]
    mane = tufts(50, 52, 16, 200, 340, 10, 9, 3.2)
    head = [E(50, 40, 9, 8.5)]
    horns = horn(44, 36, 17, -160, 40, 3.0) + horn(56, 36, 17, -20, -40, 3.0)
    arm_l = tube([(30, 52), (16, 38), (14, 22)], [9, 8, 7]) + [E(14, 18, 8, 7)] + claws(10, 12, 4, 5, 20, -110)
    arm_r = tube([(70, 52), (82, 38), (84, 22)], [9, 8, 7]) + [E(84, 18, 8, 7)] + claws(88, 12, 4, 5, 20, -70)
    legs = tube([(40, 76), (36, 86)], [9, 7.5]) + tube([(60, 76), (64, 86)], [9, 7.5])
    feet = [E(33, 89, 9.5, 3.4), E(67, 89, 9.5, 3.4)]
    pants = tufts(50, 70, 14, 20, 160, 7, 8, 3.0)
    return torso + mane + head + horns + arm_l + arm_r + legs + feet + pants


if __name__ == "__main__":
    import sys
    from PIL import ImageFont
    S = 3
    items = [("A. sitting, arms up", baby_a), ("B. fur ball", baby_b), ("C. toddler, grabbing", baby_c),
             ("A. gorilla walk + goat coat", adult_a), ("B. upright, hooded, yak skirt", adult_b), ("C. hunched, arms raised", adult_c)]
    cell = N * S
    sheet = Image.new("RGB", (cell * 3 + 40, (cell + 40) * 2 + 60), (236, 232, 222))
    d = ImageDraw.Draw(sheet)
    try:
        f = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 18)
        f2 = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 14)
    except Exception:
        f = f2 = None
    d.text((20, 8), "Yeti line - silhouettes. Top: baby. Bottom: adult.", fill=(30, 30, 30), font=f)
    for i, (label, fn) in enumerate(items):
        r, c = divmod(i, 3)
        img = sil(fn()).resize((cell, cell), Image.NEAREST)
        x, y = 20 + c * cell, 40 + r * (cell + 40)
        sheet.paste(img, (x, y), img)
        d.text((x + 6, y + cell + 4), label, fill=(30, 30, 30), font=f2)
    sheet.save(sys.argv[1] if len(sys.argv) > 1 else "yeti_silhouettes.png")
