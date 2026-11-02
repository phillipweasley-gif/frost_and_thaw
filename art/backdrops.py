"""Pixel-art backdrops for Frost & Thaw's story scenes (drawn at 256x192, saved 512x384).
python3 backdrops.py <out folder>"""
import sys, os, math, random
from PIL import Image, ImageDraw

W, H = 256, 192


def lerp(a, b, t):
    return tuple(int(a[i] + (b[i] - a[i]) * t) for i in range(3))


def sky(img, top, bottom, horizon):
    d = ImageDraw.Draw(img)
    bands = 10
    for y in range(horizon):
        t = y / horizon
        # banded gradient with a 2x2 dither between bands
        f = t * bands
        lo, hi = int(f), int(f) + 1
        c1, c2 = lerp(top, bottom, lo / bands), lerp(top, bottom, min(hi, bands) / bands)
        frac = f - lo
        for x in range(W):
            use_hi = frac > 0.5 and ((x + y) % 2 == 0 or frac > 0.8)
            img.putpixel((x, y), c2 if use_hi else c1)


def stars(img, n, horizon, rnd):
    for _ in range(n):
        x, y = rnd.randrange(W), rnd.randrange(horizon - 20)
        c = rnd.choice([(255, 255, 255), (200, 220, 255), (255, 240, 200)])
        img.putpixel((x, y), c)
        if rnd.random() < 0.08:
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                if 0 <= x + dx < W and 0 <= y + dy < H:
                    img.putpixel((x + dx, y + dy), lerp(c, img.getpixel((x + dx, y + dy)), 0.5))


def aurora(img, base_y, colours, amp, phase, width=14):
    px = img.load()
    for x in range(W):
        cy = base_y + amp * math.sin(x / 23.0 + phase) + amp * 0.5 * math.sin(x / 9.0 + phase * 2)
        for k in range(width * 3):
            y = int(cy - k)
            if not (0 <= y < H):
                continue
            t = k / (width * 3)
            strength = (1 - t) ** 1.4 * (0.7 + 0.3 * math.sin(x / 19.0 + phase))
            if strength < 0.08:
                continue
            c = colours[0] if t < 0.35 else colours[1]
            # dithered transparency
            if strength < 0.35 and (x + y) % 2:
                continue
            px[x, y] = lerp(px[x, y], c, min(0.75, strength))


def mountains(img, base, peak, colour, snow, rnd, rough=6, step=4):
    d = ImageDraw.Draw(img)
    pts = []
    y = base - rnd.randint(0, peak)
    for x in range(-step, W + step * 2, step):
        y += rnd.randint(-rough, rough)
        y = max(base - peak, min(base - 4, y))
        pts.append((x, y))
    d.polygon(pts + [(W + step * 2, H), (-step, H)], fill=colour)
    # snow caps: a lighter band below each ridge point
    for (x1, y1), (x2, y2) in zip(pts, pts[1:]):
        for x in range(x1, x2):
            yy = int(y1 + (y2 - y1) * (x - x1) / max(1, x2 - x1))
            depth = max(1, (base - yy) // 5)
            for k in range(depth):
                if 0 <= x < W and 0 <= yy + k < H and (k < depth - 1 or x % 2):
                    img.putpixel((x, yy + k), snow)


def snowfall(img, n, rnd):
    for _ in range(n):
        x, y = rnd.randrange(W), rnd.randrange(H)
        img.putpixel((x, y), (235, 240, 255))
        if rnd.random() < 0.3 and x + 1 < W:
            img.putpixel((x + 1, y), (200, 210, 235))


def dale():
    rnd = random.Random(7)
    img = Image.new("RGB", (W, H))
    horizon = 132
    sky(img, (8, 12, 34), (34, 58, 92), horizon)
    stars(img, 140, horizon, rnd)
    aurora(img, 58, [(90, 240, 180), (70, 140, 220)], 10, 0.4)
    aurora(img, 74, [(150, 255, 210), (120, 90, 210)], 7, 2.1, width=10)
    mountains(img, 128, 46, (46, 58, 92), (170, 190, 220), rnd, rough=7)
    mountains(img, 134, 26, (32, 40, 70), (130, 150, 190), rnd, rough=5, step=6)
    d = ImageDraw.Draw(img)
    # frozen lake (Maer Dualdon) with reflected aurora streaks
    for y in range(horizon, H):
        t = (y - horizon) / (H - horizon)
        for x in range(W):
            c = lerp((40, 66, 104), (16, 26, 52), t)
            if (y % 6 == 0 and (x // 8 + y) % 5 == 0):
                c = lerp(c, (110, 200, 190), 0.35)
            img.putpixel((x, y), c)
    # Targos: palisade, roofs and warm lanterns on the left shore
    d.polygon([(0, 138), (96, 134), (110, 142), (0, 146)], fill=(26, 30, 50))
    for x in range(4, 92, 6):
        h = rnd.randint(6, 12)
        d.rectangle([x, 134 - h, x + 4, 138], fill=(36, 34, 52))
        d.polygon([(x - 1, 134 - h), (x + 2, 130 - h), (x + 5, 134 - h)], fill=(200, 210, 230))
    for x in range(0, 96, 3):
        d.line([(x, 136), (x, 132)], fill=(22, 22, 36))
    for _ in range(14):
        x, y = rnd.randrange(6, 92), rnd.randrange(126, 136)
        img.putpixel((x, y), (255, 200, 110))
        img.putpixel((x, y + 1), (200, 120, 60))
        # reflection on the ice
        for k in range(3):
            yy = 146 + (x * 7 + k * 5) % 20
            if yy < H:
                img.putpixel((x, yy), lerp(img.getpixel((x, yy)), (255, 190, 100), 0.45))
    # a ship locked in the ice
    d.polygon([(150, 150), (190, 150), (184, 158), (156, 158)], fill=(30, 22, 26))
    d.line([(170, 150), (170, 120)], fill=(30, 22, 26))
    d.polygon([(171, 122), (186, 140), (171, 140)], fill=(190, 196, 214))
    img.putpixel((158, 152), (255, 200, 110))
    snowfall(img, 220, rnd)
    return img


def rootspire():
    rnd = random.Random(11)
    img = Image.new("RGB", (W, H))
    horizon = 150
    sky(img, (12, 10, 36), (60, 48, 96), horizon)
    stars(img, 90, horizon, rnd)
    aurora(img, 40, [(255, 210, 120), (120, 220, 170)], 6, 1.3, width=8)
    mountains(img, 150, 30, (40, 36, 74), (150, 150, 200), rnd, rough=5, step=6)
    d = ImageDraw.Draw(img)
    # the World Tree: canopy, trunk and roots
    cx = 128
    # trunk first (canopy overlaps it), flaring at the base, lit windows of the city
    for y in range(40, 171):
        half = 15 + max(0, (y - 120)) ** 1.5 / 14
        d.line([(cx - half, y), (cx + half, y)], fill=(62, 42, 40))
        d.line([(cx - half, y), (cx - half + 3, y)], fill=(44, 30, 32))
        d.line([(cx + half - 5, y), (cx + half, y)], fill=(86, 60, 50))
    for x in range(cx - 12, cx + 12, 6):
        d.line([(x, 60), (x + (x - cx) // 4, 170)], fill=(78, 54, 46))
    for _ in range(26):
        x, y = cx + rnd.randint(-11, 10), rnd.randint(66, 160)
        d.rectangle([x, y, x + 1, y + 2], fill=(255, 200, 110))
    # canopy: clusters of leaf-balls, dark underneath, lit from the upper left
    clusters = [(cx + rnd.randint(-92, 92), rnd.randint(-6, 58), rnd.randint(16, 28)) for _ in range(26)]
    clusters.sort(key=lambda c: c[1])
    for x, y, r in clusters:
        d.ellipse([x - r, y - r, x + r, y + r], fill=(26, 56, 46))
    for x, y, r in clusters:
        d.ellipse([x - r + 2, y - r, x + r - 2, y + r - 5], fill=(40, 84, 62))
        d.ellipse([x - r + 5, y - r + 2, x + r - 9, y + r - 14], fill=(58, 116, 78))
        d.ellipse([x - r // 2, y - r + 4, x, y - r // 3], fill=(84, 150, 96))
    for _ in range(200):
        x, y = rnd.randrange(cx - 110, cx + 110), rnd.randrange(0, 86)
        if img.getpixel((x, y))[1] > 50 and img.getpixel((x, y))[1] < 160:
            img.putpixel((x, y), rnd.choice([(110, 180, 110), (36, 70, 52), (150, 210, 140)]))
    for side in (-1, 1):
        for k in range(3):
            x0 = cx + side * (20 + k * 8)
            d.line([(x0, 150 + k * 4), (cx + side * (60 + k * 26), 176 + k * 5)], fill=(70, 48, 42), width=3)
    # ground
    d.rectangle([0, 170, W, H], fill=(36, 44, 54))
    for x in range(0, W, 2):
        img.putpixel((x, 170), (200, 210, 230))
    # lantern strings with mirror shards hanging among them
    for i, (y0, sag) in enumerate(((96, 18), (120, 14), (142, 10))):
        pts = [(x, int(y0 + sag * math.sin(math.pi * x / W))) for x in range(0, W, 2)]
        d.line(pts, fill=(60, 50, 50))
        for j, (x, y) in enumerate(pts[::9]):
            if abs(x - cx) < 22:
                continue
            if (i + j) % 5 == 0:
                d.polygon([(x, y + 2), (x + 2, y + 5), (x, y + 8), (x - 2, y + 5)], fill=(190, 230, 255))
                img.putpixel((x, y + 4), (255, 255, 255))
            else:
                colour = rnd.choice([(255, 190, 90), (255, 140, 80), (250, 230, 130), (150, 230, 160)])
                d.rectangle([x - 1, y + 2, x + 1, y + 5], fill=colour)
                img.putpixel((x, y + 6), lerp(colour, (0, 0, 0), 0.4))
    for _ in range(40):
        x, y = rnd.randrange(W), rnd.randrange(60, 168)
        img.putpixel((x, y), (255, 230, 150))
    return img


def mirror():
    """The hag's mirror shard: a pale crack of light on black."""
    rnd = random.Random(3)
    img = Image.new("RGB", (W, H), (4, 6, 14))
    pts = [(128, 18), (156, 64), (142, 98), (166, 150), (118, 178), (98, 124), (114, 82), (96, 44)]
    # inside the shard: the frozen harbour of Targos, seen as a memory
    scene = dale()
    mask = Image.new("L", (W, H), 0)
    ImageDraw.Draw(mask).polygon(pts, fill=255)
    tinted = Image.blend(scene, Image.new("RGB", (W, H), (60, 90, 150)), 0.35)
    img.paste(tinted, (0, 0), mask)
    d = ImageDraw.Draw(img)
    d.line(pts + [pts[0]], fill=(220, 240, 255))
    d.line([(118, 40), (126, 60)], fill=(255, 255, 255))
    d.line([(150, 120), (156, 140)], fill=(255, 255, 255))
    for _ in range(120):
        a = rnd.random() * 6.283
        r = rnd.randint(70, 140)
        x, y = int(128 + r * math.cos(a)), int(96 + r * math.sin(a) * 0.7)
        if 0 <= x < W and 0 <= y < H:
            img.putpixel((x, y), (180, 210, 255))
    snowfall(img, 90, rnd)
    return img


if __name__ == "__main__":
    out = sys.argv[1] if len(sys.argv) > 1 else "."
    os.makedirs(out, exist_ok=True)
    for name, fn in (("dale", dale), ("rootspire", rootspire), ("mirror", mirror)):
        fn().resize((W * 2, H * 2), Image.NEAREST).save(os.path.join(out, f"scene_{name}.png"))
    print("ok")
