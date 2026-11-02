"""Cinderwright silhouettes rebuilt from real mustelid anatomy.

What the animals actually are (stoat / weasel, otter, wolverine):
  - a TUBE with legs: long, straight, flexible body; the back does not arch like a cat's
  - long slim neck (weasels) or short thick neck (otters, wolverines); head small and flattened,
    wedge-shaped, short muzzle; head barely wider than the neck
  - ears small and rounded, set LOW and wide on the sides of the skull (not on top)
  - short legs; five toes; non-retractable claws; hind feet plantigrade (long, flat on the ground)
  - stand upright on the hind feet to look around ("sentinel"/tripod stance), forepaws tucked to the
    chest, the tail resting on the ground as a prop
  - stoat tail ~1/3 of body length, thin, with a dark tip; otter tail thick at the base, muscular,
    tapering (giant otter: flattened, with a flange each side)
Objects: an anvil has a flat hardened FACE and a pointed HORN; porcelain is a glazed shell with a
rim and a hard gloss; a kiln seam glows from inside.

Mapping:  Wickit   = stoat kit: sentinel stance, the dark tail tip becomes the glowing wick
          Stoketail = adolescent stoat/polecat: upright, working with its forepaws; tail thick at the
                      base, flattening into an otter's flanged paddle
          Forgel   = wolverine build (broad, heavy forequarters, big clawed paws) + giant otter tail
                      whose flattened end is an anvil: flat face, pointed horn
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


def claws(x, y, n, length, spread, ang):
    polys = []
    for i in range(n):
        a = math.radians(ang + (i - (n - 1) / 2) * spread)
        bx, by = x + math.cos(a) * 1.0, y + math.sin(a) * 1.0
        tx, ty = x + math.cos(a) * length, y + math.sin(a) * length
        nx, ny = -math.sin(a) * 0.6, math.cos(a) * 0.6
        polys.append([(bx + nx, by + ny), (tx, ty), (bx - nx, by - ny)])
    return polys


def sil(parts, colour=(24, 22, 30)):
    m = to_mask(smooth_poly_mask(parts), 0.5)
    img = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    px = img.load()
    for p in m:
        px[p] = colour + (255,)
    return img


# --- Wickit: stoat kit in the sentinel stance ------------------------------------------------
def wickit_parts():
    feet = [E(43, 89, 6.5, 2.2), E(53, 89, 5.5, 2.0)]                         # long flat hind feet
    hips = [E(48, 82, 7.5, 6.5)]
    body = tube(bezier((48, 82), (49, 72), (47, 64), (45, 58), 16), [6.8, 6.0, 5.4])   # an upright tube
    neck = tube([(45, 58), (43, 52)], [4.6, 4.2])                              # long and slim
    skull = [E(42, 47, 8.4, 7.2, -8)]                                          # kit: a big, round-topped head
    muzzle = [E(34.5, 49.5, 4.6, 3.4, -10)]                                    # short muzzle
    ears = [E(48.5, 42.5, 2.8, 2.8), E(37.5, 41.2, 2.4, 2.4)]                  # small, low, wide
    arms = tube([(44, 59), (41, 63), (39, 64)], [2.2, 2.0, 1.8]) + [E(38.6, 64.6, 2.2, 1.8)]   # tucked to the chest
    tail = tube(bezier((54, 86), (70, 92), (76, 74), (62, 52), 30), [2.6, 2.6, 2.3, 2.0])      # ~half body, thin
    wick = [E(61.5, 51, 2.6, 3.2)]                                             # the dark tip -> the wick
    return feet + hips + body + neck + skull + muzzle + ears + arms + tail + wick


# --- Stoketail: adolescent stoat risen to work; otter-paddle tail ------------------------------
def stoketail_parts():
    feet = [E(40, 89, 8.0, 2.4), E(53, 89, 7.0, 2.2)]
    hips = [E(47, 79, 9.0, 8.0)]
    body = tube(bezier((47, 79), (48, 66), (46, 54), (42, 45), 18), [8.2, 7.4, 6.6])
    neck = tube([(42, 45), (38, 37)], [5.0, 4.6])
    skull = [E(36, 31, 7.6, 6.2, -12)]
    muzzle = [E(28.5, 34, 4.4, 3.0, -14)]
    ears = [E(41.5, 26.5, 2.6, 2.6), E(32.5, 25.5, 2.2, 2.2)]
    arm_n = tube([(41, 48), (35, 53), (29, 51)], [3.6, 3.2, 2.8]) + [E(27, 50.5, 3.0, 2.4, -20)] + claws(25.5, 50.5, 3, 3.0, 22, 190)
    arm_f = tube([(46, 50), (40, 56), (34, 56)], [3.2, 2.9, 2.6]) + [E(32.5, 56, 2.8, 2.2)] + claws(31, 56, 3, 2.6, 22, 180)
    tail = tube(bezier((54, 84), (64, 90), (70, 89), (76, 88), 20), [5.0, 4.4, 3.6])            # thick at the base
    paddle = [[(72, 86.2), (80, 85.0), (88, 85.6), (93, 87.6), (88, 90.0), (80, 90.6), (72, 90.0)]]  # flattened, flanged
    return feet + hips + body + neck + skull + muzzle + ears + arm_n + arm_f + tail + paddle


# --- Forgel: wolverine build, otter sitting, giant-otter tail ending in an anvil ------------------
def forgel_parts():
    feet = [E(42, 90, 9.5, 3.0), E(62, 90, 8.5, 2.8)]                           # broad plantigrade feet
    hips = [E(52, 76, 15.0, 13.0)]
    body = tube(bezier((52, 76), (52, 60), (49, 48), (46, 40), 18), [14.0, 13.0, 12.0])  # heavy, still a tube
    neck = tube([(46, 40), (43, 31)], [9.5, 8.8])                                # short and thick
    skull = [E(41, 24, 10.5, 8.0, -6)]                                           # broad, flattened
    muzzle = [E(31, 27, 5.2, 4.0, -8)]
    ears = [E(48.5, 18.5, 3.2, 3.2), E(35.5, 17.5, 2.8, 2.8)]
    arm_n = tube([(40, 44), (28, 50), (17, 46)], [6.4, 5.8, 5.2]) + [E(14, 42, 6.8, 6.0, -25)] + claws(10.5, 37.5, 4, 4.4, 20, 235)
    arm_f = tube([(50, 46), (46, 56), (42, 61)], [5.6, 5.0, 4.6]) + [E(40.5, 63, 5.4, 4.2)] + claws(37, 65, 4, 3.4, 20, 150)
    tail = tube(bezier((64, 86), (82, 88), (78, 96), (46, 90), 26), [8.0, 7.0, 6.0])  # thick, muscular
    anvil = [[(18, 84.5), (36, 84.0), (40, 85.0), (40, 90.6), (24, 91.0), (14, 88.2), (6, 86.6), (16, 86.4)]]  # flat face + horn
    return feet + hips + body + neck + skull + muzzle + ears + arm_n + arm_f + tail + anvil


if __name__ == "__main__":
    import cinder_thumbs as T
    old = [T.wickit_lamp(), T.stoke_rise(), T.forgel_bench()]
    new = [sil(wickit_parts()), sil(stoketail_parts()), sil(forgel_parts())]
    sheet = Image.new("RGBA", (3 * 100 + 8, 2 * 100 + 8), (226, 228, 234, 255))
    for i, im in enumerate(old):
        sheet.alpha_composite(im, (8 + i * 100, 4))
    for i, im in enumerate(new):
        sheet.alpha_composite(im, (8 + i * 100, 104))
    big = sheet.resize((sheet.width * 3, sheet.height * 3), Image.NEAREST)
    d = ImageDraw.Draw(big)
    d.text((10, 8), "before", fill=(120, 60, 60, 255)); d.text((10, 312), "after: real mustelid anatomy", fill=(40, 100, 60, 255))
    big.save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/anatomy.png")
