"""Three directions for Gloamcap (Wyn's final partner) without the crescent cap.
All keep Parasect's shape, so its fusions (built from Parasect's) still match."""
import math
from PIL import Image, ImageDraw
import mons
from clean import (Layer, compose, paint, to_mask, smooth_poly_mask, ellipse_pts, outline_of, ribbon, thin_line_mask,
                   drop_to_ground, N)

DUSK = {(238, 49, 49): (112, 72, 172), (177, 36, 36): (78, 48, 130), (105, 21, 21): (44, 26, 82),
        (242, 101, 101): (152, 112, 212),
        (165, 79, 36): (118, 114, 140), (97, 46, 21): (70, 66, 92), (222, 106, 49): (168, 164, 190),
        (230, 144, 101): (206, 200, 222),
        (255, 213, 82): (120, 255, 210), (255, 223, 126): (196, 255, 236), (191, 161, 68): (70, 190, 160)}
CAP = {(112, 72, 172), (78, 48, 130), (44, 26, 82), (152, 112, 212), (120, 255, 210), (196, 255, 236), (70, 190, 160)}
GLOW, GLOW_HI, GLOW_LO = (120, 255, 210), (214, 255, 242), (60, 170, 150)
PALE = [(150, 190, 180), (190, 228, 214), (226, 250, 240), (250, 255, 252)]


def base():
    img = mons.recolour(mons.base_sprite(47), DUSK)
    px = img.load()
    for y in range(N):
        for x in range(N):
            if px[x, y][3] and px[x, y][:3] in ((247, 238, 247), (213, 213, 213)):
                px[x, y] = GLOW + (255,)          # its eyes: the fungus looks out now
    return img


def cap_rim(img):
    """For each column, the lowest cap pixel (the cap's underside edge)."""
    px = img.load(); rim = {}
    for x in range(N):
        ys = [y for y in range(N) if px[x, y][3] and px[x, y][:3] in CAP]
        if ys:
            rim[x] = max(ys)
    return rim


def spores(img, pts):
    d = ImageDraw.Draw(img)
    for (x, y, r) in pts:
        d.ellipse([x - r, y - r, x + r, y + r], fill=GLOW + (220,))
        d.point([(x, y - r - 1)], fill=GLOW_HI + (170,))


def funnel(cx, by, w, h, lean=0.0):
    """A small ghost-fungus: a short stem and a funnel cap, open to the sky."""
    stem = ribbon([(cx, by), (cx + lean * h * 0.4, by - h * 0.45)], max(0.8, w * 0.12), max(0.8, w * 0.1))
    tx = cx + lean * h * 0.55
    cup = [(tx - w * 0.5, by - h), (tx + w * 0.5, by - h * 1.02), (tx + w * 0.16, by - h * 0.5), (tx - w * 0.16, by - h * 0.5)]
    top = ellipse_pts(tx, by - h, w * 0.5, w * 0.16, 24)
    return [stem, cup, top]


def option_a():
    """Ghost fungus: its gills glow, lighting the husk from above; pale glowing funnels sprout from it."""
    img = base()
    rim = cap_rim(img)
    px = img.load()
    # glowing gills: a lit band under the cap edge, with gill lines
    for x, y in rim.items():
        for k, c in ((1, GLOW_HI), (2, GLOW), (3, GLOW_LO)):
            if y + k < N and px[x, y + k][3] and px[x, y + k][:3] not in CAP and px[x, y + k][:3] != GLOW:
                if k == 1 and x % 3 == 0:
                    px[x, y + k] = GLOW_LO + (255,)
                else:
                    r, g, b, a = px[x, y + k]
                    t = 0.75 if k == 1 else 0.45 if k == 2 else 0.25
                    px[x, y + k] = (int(r + (c[0] - r) * t), int(g + (c[1] - g) * t), int(b + (c[2] - b) * t), a)
    bb = img.getbbox()
    cx = (bb[0] + bb[2]) / 2
    # three ghost fungi growing out of the cap
    tops = sorted(((x, y) for x, y in ((x, min(y for y in range(N) if px[x, y][3])) for x in range(bb[0], bb[2]) if any(px[x, y][3] for y in range(N)))))
    def top_at(x):
        return min(range(N), key=lambda y: (0 if px[int(x), y][3] else 1, y)) if any(px[int(x), y][3] for y in range(N)) else bb[1]
    shapes = []
    for fx, w, h, lean in ((cx - 8, 9, 9, -0.35), (cx + 5, 7, 7, 0.3), (cx + 15, 6, 6, 0.5)):
        y = top_at(fx) + 2
        shapes += funnel(fx, y, w, h, lean)
    fungi = compose([Layer(shapes, PALE, depth=3, outline=(46, 110, 100), cuts=(-0.1, 0.35, 0.7))])
    halo = Image.new("RGBA", fungi.size, (0, 0, 0, 0))
    fm = {(x, y) for y in range(N) for x in range(N) if fungi.getpixel((x, y))[3]}
    hp = halo.load()
    for (x, y) in fm:
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            q = (x + dx, y + dy)
            if q not in fm and 0 <= q[0] < N and 0 <= q[1] < N:
                hp[q] = GLOW + (90,)
    out = Image.new("RGBA", img.size, (0, 0, 0, 0))
    out.alpha_composite(img); out.alpha_composite(halo); out.alpha_composite(fungi)
    spores(out, ((bb[0] - 4, bb[1] + 14, 2), (bb[2] + 3, bb[1] + 8, 2), (bb[2] + 1, bb[3] - 22, 1), (bb[0] - 2, bb[3] - 30, 1), (cx + 2, bb[1] - 14, 1)))
    return drop_to_ground(out, 92)


def option_b():
    """Veiled: a lacy veil hangs from the cap's rim to the ground, like the real veiled-lady mushroom."""
    img = base()
    rim = cap_rim(img)
    px = img.load()
    bb = img.getbbox()
    xs = sorted(rim)
    x0, x1 = xs[0] + 1, xs[-1] - 1
    ground = bb[3] + 1
    veil = Image.new("RGBA", img.size, (0, 0, 0, 0)); vp = veil.load()
    for x in range(x0 - 2, x1 + 3):
        xr = min(max(x, x0), x1)
        top = rim.get(xr, rim[min(rim, key=lambda k: abs(k - xr))]) + 1
        flare = abs(x - (x0 + x1) / 2) / ((x1 - x0) / 2 + 1)
        bottom = ground - int(3 * (1 - flare) ** 2) - (x % 4 == 0)
        for y in range(top, bottom):
            lattice = ((x + y) % 4 == 0) or ((x - y) % 4 == 0)
            if lattice:
                vp[x, y] = (226, 250, 240, 230)
            elif (x, y) not in ():
                vp[x, y] = (196, 230, 222, 70)
        if bottom < N:
            vp[x, bottom] = (226, 250, 240, 200)
    out = Image.new("RGBA", img.size, (0, 0, 0, 0))
    out.alpha_composite(img); out.alpha_composite(veil)
    # the cap and its glow sit over the veil's top
    cp = out.load(); ip = img.load()
    for y in range(N):
        for x in range(N):
            if ip[x, y][3] and ip[x, y][:3] in CAP:
                cp[x, y] = ip[x, y]
    spores(out, ((bb[0] - 4, bb[1] + 10, 2), (bb[2] + 3, bb[1] + 6, 2), (bb[0] - 3, bb[3] - 20, 1), (bb[2] + 2, bb[3] - 26, 1)))
    return drop_to_ground(out, 92)


def option_c():
    """Hollow husk: only the mushroom is solid now; the bug beneath has faded to a ghost."""
    img = base()
    px = img.load()
    for y in range(N):
        for x in range(N):
            p = px[x, y]
            if p[3] and p[:3] not in CAP and p[:3] != GLOW:
                l = (p[0] * 3 + p[1] * 6 + p[2]) / 10
                c = (int(150 + l * 0.35), int(170 + l * 0.33), int(200 + l * 0.2))
                px[x, y] = c + (150 if l > 40 else 210,)
    bb = img.getbbox()
    spores(img, ((bb[0] - 4, bb[1] + 10, 2), (bb[2] + 3, bb[1] + 6, 2), (bb[0] - 3, bb[3] - 20, 1), (bb[2] + 2, bb[3] - 26, 1)))
    return drop_to_ground(img, 92)


if __name__ == "__main__":
    opts = [option_a(), option_b(), option_c()]
    s = Image.new("RGBA", (300, 100), (72, 80, 104, 255))
    for i, im in enumerate(opts):
        s.alpha_composite(im, (i * 100 + 2, 2))
    s.resize((900, 300), Image.NEAREST).save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/gloam_opts.png")
