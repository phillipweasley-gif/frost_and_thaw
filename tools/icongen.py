#!/usr/bin/env python3
"""Bag icons for the six story items that had none (2026-11-09): Bone Dust, Razzy's Blanket, Yeti Swaddling, a Lump
of Warm Ore, Viessa's Wax Map, a Flask of Whale Oil.

    python3 tools/icongen.py [--out build/gfx/Items] [--preview OUT.png]

As the other FT_ icons: 24x24 native drawn at 2x (48x48), a dark navy outline, each shape lit from the top left in a
3-4 step ramp of its own colour, a highlight or two."""
import os, sys, math
from PIL import Image

N = 24
OUT = (22, 24, 42)

def ramp_px(mask, ramp, light=(-1, -1)):
    """Shade a set of pixels with a ramp: lighter toward the top left of the shape, darker away from it."""
    xs = [x for x, y in mask]; ys = [y for x, y in mask]
    cx, cy = sum(xs) / len(xs), sum(ys) / len(ys)
    span = max(max(xs) - min(xs), max(ys) - min(ys), 1)
    out = {}
    for (x, y) in mask:
        t = ((x - cx) * -light[0] + (y - cy) * -light[1]) / span      # -0.7 (lit) .. 0.7 (shade)
        i = int((t + 0.55) / 1.1 * len(ramp))
        out[(x, y)] = ramp[max(0, min(len(ramp) - 1, len(ramp) - 1 - i))]
    return out

def ellipse(cx, cy, rx, ry):
    return {(x, y) for y in range(N) for x in range(N) if ((x + 0.5 - cx) / rx) ** 2 + ((y + 0.5 - cy) / ry) ** 2 <= 1}

def rect(x0, y0, x1, y1):
    return {(x, y) for y in range(y0, y1) for x in range(x0, x1)}

def poly(pts):
    from PIL import ImageDraw
    m = Image.new("L", (N, N), 0)
    ImageDraw.Draw(m).polygon(pts, fill=255)
    return {(x, y) for y in range(N) for x in range(N) if m.getpixel((x, y))}

def render(layers):
    """layers: [(pixels {xy: rgb})...] drawn in order; then the outline round the whole."""
    im = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    px = im.load()
    for layer in layers:
        for (x, y), c in layer.items():
            if 0 <= x < N and 0 <= y < N:
                px[x, y] = c + (255,)
    src = im.copy().load()
    for y in range(N):
        for x in range(N):
            if src[x, y][3]:
                continue
            if any(0 <= x + dx < N and 0 <= y + dy < N and src[x + dx, y + dy][3]
                   for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                px[x, y] = OUT + (255,)
    return im.resize((N * 2, N * 2), Image.NEAREST)

def flask(liquid, glass=((150, 186, 210), (196, 226, 240), (236, 248, 255))):
    body = ellipse(12, 15, 7, 6.5)
    neck = rect(10, 4, 14, 10)
    cork = rect(10, 2, 14, 5)
    fill = {p for p in body if p[1] >= 13}
    layers = [ramp_px(body | neck, glass), ramp_px(fill, liquid), ramp_px(cork, [(92, 58, 36), (140, 96, 58), (176, 128, 80)])]
    layers.append({(8, 12): (255, 255, 255), (8, 13): (236, 248, 255), (9, 11): (255, 255, 255)})
    return layers

def i_whaleoil():
    return render(flask([(150, 104, 24), (210, 160, 44), (244, 206, 96)]))

def i_bonedust():
    vial = rect(9, 6, 15, 20) | ellipse(12, 19.5, 3, 1.5)
    cork = rect(9, 3, 15, 6)
    dust = {p for p in vial if p[1] >= 12}
    grains = {(10, 11): (226, 220, 204), (13, 10): (226, 220, 204), (11, 9): (200, 194, 180)}
    return render([ramp_px(vial, [(150, 186, 210), (196, 226, 240), (236, 248, 255)]),
                   ramp_px(dust, [(160, 152, 140), (210, 202, 186), (240, 236, 224)]), grains,
                   ramp_px(cork, [(92, 58, 36), (140, 96, 58), (176, 128, 80)]),
                   {(10, 7): (255, 255, 255), (10, 8): (236, 248, 255)}])

def i_blanket():
    # a folded patchwork blanket: three stacked folds, rag tones, a stitched seam
    folds = []
    tones = [[(84, 74, 52), (120, 106, 74), (156, 140, 100)],      # olive rag
             [(104, 68, 44), (146, 98, 62), (184, 132, 86)],       # brown
             [(70, 84, 76), (100, 120, 104), (136, 156, 136)]]     # grey-green
    for k, t in enumerate(tones):
        y0 = 7 + k * 4
        folds.append(ramp_px(poly([(3, y0 + 1), (20, y0), (21, y0 + 4), (4, y0 + 5)]), t))
    seam = {(x, 9 + (x % 2)): (60, 48, 34) for x in range(6, 19, 3)}
    patch = ramp_px(rect(13, 12, 17, 15), [(150, 60, 50), (190, 90, 70), (220, 130, 100)])
    return render(folds + [patch, seam])

def i_swaddling():
    bundle = ellipse(12, 13, 8.5, 7.5)
    fur = ramp_px(bundle, [(150, 150, 160), (196, 198, 206), (228, 230, 236), (250, 250, 252)])
    tufts = {}
    for (x, y) in bundle:
        if (x * 7 + y * 3) % 9 == 0:
            tufts[(x, y)] = (176, 178, 188)
    cord = {(x, 13 + (1 if x in (8, 16) else 0)): (140, 96, 58) for x in range(5, 20)}
    knot = {(12, 14): (176, 128, 80), (12, 15): (92, 58, 36), (11, 16): (140, 96, 58), (13, 16): (140, 96, 58)}
    face = ellipse(12, 8.5, 2.6, 2.2)                     # a little fold where the baby goes
    return render([fur, tufts, ramp_px(face, [(120, 120, 132), (160, 160, 172)]), cord, knot])

def i_warmore():
    lump = poly([(5, 13), (8, 7), (14, 5), (19, 9), (20, 15), (16, 19), (9, 19)])
    rock = ramp_px(lump, [(46, 44, 52), (72, 68, 78), (102, 96, 106), (132, 124, 132)])
    veins = {}
    for (a, b) in (((8, 10), (13, 13)), ((13, 13), (17, 11)), ((13, 13), (12, 17))):
        n = max(abs(b[0] - a[0]), abs(b[1] - a[1]))
        for i in range(n + 1):
            veins[(round(a[0] + (b[0] - a[0]) * i / n), round(a[1] + (b[1] - a[1]) * i / n))] = (236, 128, 40)
    glow = {(13, 13): (255, 220, 120), (8, 10): (255, 190, 90), (17, 11): (255, 190, 90)}
    return render([rock, veins, glow])

def i_waxmap():
    roll = rect(4, 9, 20, 16)
    paper = ramp_px(roll, [(176, 150, 104), (214, 190, 140), (238, 222, 180)], light=(0, -1))
    ends = ramp_px(ellipse(4, 12.5, 1.8, 3.6) | ellipse(20, 12.5, 1.8, 3.6), [(150, 124, 82), (196, 170, 120)])
    lines = {(x, 11): (150, 124, 82) for x in range(7, 11)} | {(x, 14): (150, 124, 82) for x in range(14, 18)}
    seal = ramp_px(ellipse(12, 12.5, 3, 3), [(120, 24, 30), (176, 40, 44), (214, 72, 68)])
    seal[(12, 12)] = (250, 140, 120)
    ribbon = {(11, 16): (176, 40, 44), (11, 17): (120, 24, 30), (13, 16): (176, 40, 44), (14, 17): (120, 24, 30)}
    return render([paper, ends, lines, ribbon, seal])

ICONS = {"FT_BONEDUST": i_bonedust, "FT_RAZZYBLANKET": i_blanket, "FT_SWADDLING": i_swaddling,
         "FT_WARMORE": i_warmore, "FT_WAXMAP": i_waxmap, "FT_WHALEOIL": i_whaleoil}

def main():
    args = sys.argv[1:]
    out = "build/gfx/Items"
    prev = None
    if "--out" in args:
        i = args.index("--out"); out = args[i + 1]
    if "--preview" in args:
        i = args.index("--preview"); prev = args[i + 1]
    os.makedirs(out, exist_ok=True)
    ims = []
    for k, fn in ICONS.items():
        im = fn()
        im.save(os.path.join(out, k + ".png"))
        ims.append(im)
        print(k)
    if prev:
        pv = Image.new("RGBA", (48 * len(ims) + 8 * len(ims), 48), (200, 200, 200, 255))
        for i, im in enumerate(ims):
            pv.alpha_composite(im, (i * 56, 0))
        pv.resize((pv.width * 3, pv.height * 3), Image.NEAREST).save(prev)

if __name__ == "__main__":
    main()
