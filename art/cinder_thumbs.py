"""The Cinderwright line - two-value silhouette thumbnails, three poses per stage.
Wickit (spark) -> Stoketail (practice) -> Forgel (mastery). A weasel whose tail is its tool."""
import math
from PIL import Image, ImageDraw
from clean import smooth_poly_mask, ellipse_pts, ribbon, to_mask, N
from hires import bezier


class Tube(list):
    """A body part along a path, as a chain of overlapping circles (robust on tight curves)."""


def tube(path, radii):
    n = len(path)
    k = len(radii) - 1
    out = Tube()
    dense = []
    for i in range(n - 1):
        (x0, y0), (x1, y1) = path[i], path[i + 1]
        steps = max(1, int(math.hypot(x1 - x0, y1 - y0) * 2))
        for j in range(steps):
            t = j / steps
            dense.append(((x0 + (x1 - x0) * t, y0 + (y1 - y0) * t), (i + t) / (n - 1)))
    dense.append((path[-1], 1.0))
    for (x, y), u in dense:
        t = u * k
        j = min(int(t), k - 1)
        r = radii[j] + (radii[j + 1] - radii[j]) * (t - j)
        out.append(ellipse_pts(x, y, r, r, 20))
    return out


def flat(parts):
    """Flatten tubes into plain polygon lists."""
    res = []
    for p in parts:
        if isinstance(p, Tube):
            res.extend(p)
        else:
            res.append(p)
    return res


def E(cx, cy, rx, ry, rot=0.0):
    pts = ellipse_pts(0, 0, rx, ry, 40)
    c, s = math.cos(math.radians(rot)), math.sin(math.radians(rot))
    return [(cx + x * c - y * s, cy + x * s + y * c) for x, y in pts]


def flame_tuft(x, y, r, lean=0.0):
    """A candle-flame tuft: round below, pointed above."""
    tip = (x + lean * r, y - r * 1.9)
    return E(x, y, r, r * 0.95) + [tip]


def ears(cx, cy, gap, r, notch_side=1):
    """Two round ears; one has a small flame-shaped notch (cut later)."""
    return [E(cx - gap, cy, r, r), E(cx + gap, cy, r, r)], (cx + notch_side * gap + r * 0.1, cy - r * 0.75)


def head(cx, cy, rx, ry, muzzle_dx=-1, ear_gap=None, ear_r=None):
    eg = ear_gap or rx * 0.66
    er = ear_r or rx * 0.4
    e, notch = ears(cx - muzzle_dx * 1.0, cy - ry * 0.82, eg, er, notch_side=-muzzle_dx)
    parts = [E(cx, cy, rx, ry), E(cx + muzzle_dx * rx * 0.62, cy + ry * 0.3, rx * 0.5, ry * 0.42)] + e
    return parts, notch


def render(parts, notches=(), k=1.0, ground=92):
    sc = [[(48 + (x - 48) * k, ground + (y - ground) * k) for x, y in p] for p in flat(parts)]
    holes = []
    for (nx, ny, r) in notches:
        nx, ny = 48 + (nx - 48) * k, ground + (ny - ground) * k
        rr = r * k
        holes.append([(nx - rr * 0.7, ny - rr * 1.4), (nx + rr * 0.1, ny - rr * 1.9), (nx + rr * 0.7, ny - rr * 1.3), (nx, ny + rr * 0.2)])
    m = to_mask(smooth_poly_mask(sc, holes), 0.5)
    img = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    px = img.load()
    for p in m:
        px[p] = (24, 22, 30, 255)
    bb = img.getbbox()
    out = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    out.alpha_composite(img, (48 - (bb[0] + bb[2]) // 2, ground - bb[3]))
    return out


# --- Wickit ---------------------------------------------------------------------------------
def wickit_lamp():
    """Sitting up, holding its glowing tail beside its face like a task lamp."""
    h, notch = head(44, 36, 18, 15.5, muzzle_dx=-1)
    body = [E(48, 62, 11, 14)]
    feet = [E(40, 77, 7, 3.4), E(56, 77, 6, 3.2)]
    paws = [E(41, 58, 5.5, 4.5), E(53, 60, 5.5, 4.5)]
    tail = tube(bezier((58, 72), (78, 74), (78, 50), (66, 40), 24), [4.0, 4.6, 3.6])
    tuft = flame_tuft(65, 38, 5.4, lean=-0.2)
    return render(h + body + feet + paws + [tail, tuft], [(notch[0], notch[1], 3.0)], k=0.62, ground=90)


def wickit_inspect():
    """Crouched low, nose to the ground, tail curled over its back with the glow above."""
    h, notch = head(32, 60, 17, 14.5, muzzle_dx=-1)
    body = [tube(bezier((42, 66), (50, 62), (62, 62), (70, 70), 20), [8.5, 9.5, 8.5])]
    legs = [E(36, 77, 6, 3.4), E(48, 77, 5, 3), E(66, 78, 6, 3.2), E(74, 78, 5, 3)]
    tail = tube(bezier((72, 66), (88, 56), (80, 34), (62, 34), 24), [4.2, 4.8, 3.6])
    tuft = flame_tuft(58, 33, 5.4, lean=-0.4)
    return render(h + body + legs + [tail, tuft], [(notch[0], notch[1], 3.0)], k=0.62, ground=90)


def wickit_bound():
    """Bounding toward its next idea: stretched mid-leap, tail streaming up behind."""
    h, notch = head(28, 46, 17, 14.5, muzzle_dx=-1)
    body = [tube(bezier((38, 54), (46, 50), (58, 52), (66, 62), 20), [9.0, 9.5, 8.0])]
    legs = [tube([(34, 60), (26, 68)], [3.4, 3.0]), E(25, 70, 5, 3.2),
            tube([(66, 66), (78, 72)], [3.6, 3.0]), E(80, 73, 5.5, 3.2)]
    tail = tube(bezier((68, 58), (82, 54), (84, 38), (76, 28), 24), [4.0, 4.4, 3.4])
    tuft = flame_tuft(75, 26, 5.4, lean=-0.3)
    return render(h + body + legs + [tail, tuft], [(notch[0], notch[1], 3.0)], k=0.66, ground=90)


# --- Stoketail -----------------------------------------------------------------------------
def paddle(x, y, w, h, rot):
    return E(x, y, w, h, rot)


def stoke_lean():
    """On all fours, leaning forward with confidence; paddle tail held up in an S."""
    h, notch = head(24, 40, 12, 10, muzzle_dx=-1)
    body = [tube(bezier((30, 50), (40, 46), (56, 48), (66, 56), 20), [10.5, 10.0, 9.0])]
    plate = [E(38, 45, 7, 5, -15)]                                  # one shoulder plate only: still figuring itself out
    fore = [tube([(32, 56), (28, 66), (28, 76)], [5.0, 4.6, 4.0]), E(26, 78, 6.5, 3.5),
            tube([(40, 58), (40, 68), (42, 77)], [4.4, 4.0, 3.6]), E(42, 78, 5.5, 3.2)]
    guard = [E(29, 64, 5.4, 3.6, -80)]
    hind = [tube([(62, 60), (66, 70), (64, 77)], [6.0, 4.2, 3.4]), E(63, 78, 5.5, 3.2),
            tube([(56, 62), (56, 77)], [4.0, 3.2]), E(55, 78, 5, 3)]
    tail = tube(bezier((66, 56), (80, 58), (72, 36), (84, 28), 24), [4.4, 4.0, 3.4])
    pad = [paddle(86, 24, 10, 6, -35)]
    return render(h + body + plate + fore + guard + hind + [tail] + pad, [(notch[0], notch[1], 2.6)], k=0.82, ground=91)


def stoke_rise():
    """Rising onto its hind legs to work with both paws; paddle tail braced on the ground."""
    h, notch = head(40, 26, 12, 10, muzzle_dx=-1)
    body = [tube(bezier((44, 34), (46, 46), (48, 58), (52, 68), 20), [9.0, 10.0, 11.0])]
    plate = [E(52, 38, 6, 5, 20)]
    arms = [tube([(42, 40), (34, 48), (30, 52)], [4.6, 4.2, 3.8]), E(28, 53, 5.5, 4.5),
            tube([(50, 42), (44, 52), (38, 56)], [4.2, 3.8, 3.6]), E(36, 57, 5, 4)]
    guard = [E(36, 47, 5, 3.4, -40)]
    legs = [tube([(48, 68), (44, 78)], [5.5, 3.6]), E(42, 80, 6.5, 3.2), tube([(56, 68), (58, 78)], [5.0, 3.4]), E(60, 80, 6, 3)]
    tail = tube(bezier((56, 66), (70, 70), (78, 76), (82, 78), 20), [5.0, 4.4, 3.8])
    pad = [paddle(84, 77, 11, 4.6, 0)]
    return render(h + body + plate + arms + guard + legs + [tail] + pad, [(notch[0], notch[1], 2.6)], k=0.82, ground=91)


def stoke_prowl():
    """Long and low, polishing a mark with the paddle curled forward beside it."""
    h, notch = head(22, 54, 12, 10, muzzle_dx=-1)
    body = [tube(bezier((28, 60), (40, 54), (58, 54), (70, 62), 20), [9.0, 9.5, 9.5])]
    plate = [E(60, 55, 6.5, 4.6, 10)]
    fore = [tube([(32, 64), (30, 77)], [4.8, 3.8]), E(28, 78, 6.5, 3.4), tube([(40, 64), (40, 77)], [4.0, 3.4]), E(41, 78, 5, 3)]
    guard = [E(31, 70, 5, 3.4, -85)]
    hind = [tube([(66, 66), (68, 77)], [5.5, 3.4]), E(67, 78, 5.5, 3)]
    tail = tube(bezier((72, 60), (90, 58), (88, 80), (60, 80), 24), [4.4, 4.0, 3.6])
    pad = [paddle(52, 78, 10, 4.4, 8)]
    return render(h + body + plate + fore + guard + hind + [tail] + pad, [(notch[0], notch[1], 2.6)], k=0.82, ground=91)


# --- Forgel -----------------------------------------------------------------------------------
def forgel_brace():
    """Grounded on all fours, head raised and watchful; the heavy tail planted behind as a brace."""
    h, notch = head(18, 44, 12, 10, muzzle_dx=-1)
    neck = [tube([(22, 50), (30, 56)], [7.5, 10.0])]
    body = [tube(bezier((30, 60), (44, 48), (62, 50), (74, 62), 24), [14.5, 12.5, 10.5])]
    plates = [E(36, 52, 10, 6.5, -25), E(56, 50, 7.5, 5, 5)]
    fore = [tube([(28, 68), (26, 84)], [7.4, 5.8]), E(24, 86, 9, 4.4),
            tube([(40, 70), (40, 84)], [6.2, 5.0]), E(41, 86, 7, 3.8)]
    hind = [tube([(70, 68), (72, 84)], [8.4, 5.0]), E(71, 86, 7.5, 3.6), tube([(62, 70), (60, 84)], [6.0, 4.4]), E(59, 86, 6, 3.4)]
    tail = tube(bezier((74, 62), (86, 62), (90, 74), (88, 82), 24), [7.4, 6.6, 6.0])
    pad = [paddle(86, 85, 12, 4.6, 0)]
    return render(h + neck + body + plates + fore + hind + [tail] + pad, [(notch[0], notch[1], 2.4)], k=1.0, ground=93)


def forgel_bench():
    """Sitting tall like an otter at rest, one huge forepaw raised; tail curled forward as its workbench."""
    h, notch = head(40, 20, 11.5, 9.5, muzzle_dx=-1)
    body = [tube(bezier((44, 30), (44, 46), (48, 62), (54, 74), 20), [11.0, 13.0, 15.0])]
    plates = [E(52, 34, 8, 6, 25), E(36, 40, 6, 5, -30)]
    arm1 = [tube([(38, 36), (28, 42), (22, 36)], [5.6, 5.0, 4.6]), E(20, 33, 7.5, 6.5)]     # the raised, glowing paw
    arm2 = [tube([(46, 40), (40, 52), (36, 60)], [5.4, 4.8, 4.4]), E(34, 62, 6.5, 5)]
    legs = [E(46, 84, 9, 4.6), E(62, 84, 8, 4.2)]
    tail = tube(bezier((60, 74), (82, 80), (76, 92), (36, 86), 26), [7.0, 6.4, 5.4])
    pad = [paddle(30, 84, 11, 4.4, 0)]
    return render(h + body + plates + arm1 + arm2 + legs + [tail] + pad, [(notch[0], notch[1], 2.4)], k=1.0, ground=93)


def forgel_strike():
    """Low, wide stance, the tail arched high overhead to bring its flat steel end down."""
    h, notch = head(14, 52, 12, 10, muzzle_dx=-1)
    neck = [tube([(18, 58), (26, 62)], [7.5, 10.0])]
    body = [tube(bezier((26, 64), (40, 54), (58, 56), (70, 66), 24), [13.5, 12.0, 10.0])]
    plates = [E(32, 58, 9.5, 6.5, -20), E(52, 55, 7, 5, 0)]
    fore = [tube([(24, 72), (18, 84)], [7.0, 5.6]), E(16, 86, 9, 4.2), tube([(36, 74), (38, 84)], [6.0, 5.0]), E(39, 86, 7, 3.8)]
    hind = [tube([(66, 72), (70, 84)], [8.0, 5.0]), E(70, 86, 7, 3.6)]
    tail = tube(bezier((70, 64), (94, 60), (92, 22), (62, 18), 28), [7.4, 6.8, 6.0])
    pad = [paddle(56, 20, 7.5, 12, 70)]
    return render(h + neck + body + plates + fore + hind + [tail] + pad, [(notch[0], notch[1], 2.4)], k=1.0, ground=93)


ROWS = [("Wickit", [wickit_lamp, wickit_inspect, wickit_bound]),
        ("Stoketail", [stoke_lean, stoke_rise, stoke_prowl]),
        ("Forgel", [forgel_brace, forgel_bench, forgel_strike])]

if __name__ == "__main__":
    W = 96 * 3
    sheet = Image.new("RGBA", (3 * 104 + 8, 3 * 104 + 8), (226, 228, 234, 255))
    for r, (name, fns) in enumerate(ROWS):
        for c, fn in enumerate(fns):
            sheet.alpha_composite(fn(), (8 + c * 104, 8 + r * 104))
    big = sheet.resize((sheet.width * 3, sheet.height * 3), Image.NEAREST)
    d = ImageDraw.Draw(big)
    for r, (name, _) in enumerate(ROWS):
        for c in range(3):
            d.text((8 * 3 + c * 312 + 6, 8 * 3 + r * 312 + 4), f"{name[0]}{c + 1}", fill=(90, 90, 110, 255))
    big.save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/cinder_thumbs.png")
