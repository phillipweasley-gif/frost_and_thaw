"""Smoky shadow arms and hands (Cofagrigus / Runerigus style) for possessed objects."""
import math
from hires import Part, bezier

SHADOW = [(34, 28, 46), (56, 48, 72), (84, 76, 104), (124, 116, 148)]
SHADOW_OUT = (12, 8, 20)


def hand(part, wrist, angle, size=1.0, spread=1.0, curl=0.0):
    """A shadow hand: palm and four fingers fanned out, plus a thumb."""
    wx, wy = wrist
    a = math.radians(angle)
    dx, dy = math.cos(a), math.sin(a)
    px, py = -dy, dx
    palm_c = (wx + dx * 3.2 * size, wy + dy * 3.2 * size)
    part.ellipse(palm_c[0], palm_c[1], 3.4 * size, 3.4 * size)
    for k, off in enumerate((-1.5, -0.5, 0.5, 1.5)):
        fa = a + off * 0.32 * spread
        base = (palm_c[0] + math.cos(fa) * 2.4 * size, palm_c[1] + math.sin(fa) * 2.4 * size)
        ln = (6.8 if off in (-0.5, 0.5) else 5.8) * size
        mid = (base[0] + math.cos(fa) * ln * 0.55, base[1] + math.sin(fa) * ln * 0.55)
        ca = fa + curl
        tip = (mid[0] + math.cos(ca) * ln * 0.5, mid[1] + math.sin(ca) * ln * 0.5)
        part.stroke([base, mid, tip], 1.3 * size, 0.7 * size)
    ta = a - 1.25 * spread
    tb = (palm_c[0] + math.cos(ta) * 2.6 * size, palm_c[1] + math.sin(ta) * 2.6 * size)
    part.stroke([tb, (tb[0] + math.cos(ta + 0.5) * 4.2 * size, tb[1] + math.sin(ta + 0.5) * 4.2 * size)], 1.2 * size, 0.7 * size)


def arm(part, root, ctrl1, ctrl2, wrist, r_root=0.8, r_wrist=2.0, wisps=True):
    """A smoky arm: thin and wispy where it leaves the object, fuller at the hand."""
    pts = bezier(root, ctrl1, ctrl2, wrist, 24)
    part.stroke(pts, r_root, r_wrist)
    if wisps:     # a second, thinner smoke strand alongside, like Cofagrigus's arms
        off = [(x + 1.6 * math.sin(i * 0.7), y + 1.6 * math.cos(i * 0.9)) for i, (x, y) in enumerate(pts[:14])]
        part.stroke(off, 0.5, 0.9)
    return pts
