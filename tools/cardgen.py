#!/usr/bin/env python3
"""The act title cards S-25a-c, generated (2026-11-09).

    python3 tools/cardgen.py [--out build/gfx/Pictures]

512x384 panels drawn at 256x192 native and scaled exactly 2x; under 64 colours; opaque. A night sky in bands, the
act's own aurora, a snowy horizon, falling snow, and the act's name in the game's own pixel font (power green),
rendered without smoothing. Act I, The Rime: blue and frozen. Act II, The Thaw: Rootspire's green and gold.
Act III, The Frostmaiden: violet and white."""
import os, sys, math, random
from PIL import Image, ImageDraw, ImageFont

W, H = 256, 192
FONT = "/home/claude/pif-682/Fonts/power green.ttf"

ACTS = {
    "a": ("ACT I", "THE RIME", [(8, 12, 30), (14, 22, 48), (22, 34, 68), (30, 48, 88)], [(60, 160, 200), (150, 220, 240)],
          (210, 230, 250)),
    "b": ("ACT II", "THE THAW", [(10, 18, 16), (16, 30, 24), (24, 44, 32), (34, 60, 40)], [(110, 190, 80), (240, 210, 110)],
          (250, 236, 190)),
    "c": ("ACT III", "THE FROSTMAIDEN", [(14, 8, 26), (24, 14, 44), (36, 22, 62), (50, 32, 84)], [(150, 110, 220), (230, 220, 255)],
          (240, 236, 255)),
}

def card(small, big, sky, aur, text):
    rnd = random.Random(sum(map(ord, big)))
    im = Image.new("RGB", (W, H), sky[0])
    px = im.load()
    for y in range(H):                                   # the sky in four bands, dithered where they meet
        band = min(3, y * 4 // 130)
        for x in range(W):
            b = band
            if y % 32 in (0, 1) and (x + y) % 2 == 0 and band > 0:
                b -= 1
            px[x, y] = sky[b]
    for k in range(2):                                   # two aurora ribbons, waving
        for x in range(W):
            yc = 46 + k * 16 + 10 * math.sin(x / 34 + k * 1.7) + 4 * math.sin(x / 11 + k)
            for dy in range(-3, 4):
                y = int(yc + dy)
                if 0 <= y < H and (abs(dy) < 2 or (x + y) % 2 == 0):
                    px[x, y] = aur[1] if abs(dy) == 0 else aur[0]
    for _ in range(90):                                  # stars, above the ribbons
        x, y = rnd.randrange(W), rnd.randrange(40)
        px[x, y] = text if rnd.random() < 0.3 else aur[0]
    hill = [150 + 8 * math.sin(x / 23) + 5 * math.sin(x / 7.3) for x in range(W)]
    for x in range(W):                                   # a snowy horizon
        for y in range(int(hill[x]), H):
            px[x, y] = (226, 236, 246) if y < hill[x] + 2 else (176, 196, 220) if y < hill[x] + 8 else (140, 160, 190)
    for _ in range(70):                                  # falling snow
        x, y = rnd.randrange(W), rnd.randrange(H)
        px[x, y] = (240, 244, 250)
    d = ImageDraw.Draw(im)
    d.fontmode = "1"                                     # no smoothing: pixel-exact letters
    f_small = ImageFont.truetype(FONT, 16)
    f_big = ImageFont.truetype(FONT, 32 if len(big) < 12 else 24)
    for (s, f, y) in ((small, f_small, 78), (big, f_big, 94)):
        w = d.textlength(s, font=f)
        x = int((W - w) / 2)
        for dx, dy in ((1, 1), (-1, 0), (1, 0), (0, -1), (0, 1)):   # a dark outline, then the letters
            d.text((x + dx, y + dy), s, font=f, fill=sky[0])
        d.text((x, y), s, font=f, fill=text)
    return im.resize((W * 2, H * 2), Image.NEAREST)

def main():
    out = "build/gfx/Pictures"
    if "--out" in sys.argv:
        out = sys.argv[sys.argv.index("--out") + 1]
    os.makedirs(out, exist_ok=True)
    for k, (small, big, sky, aur, text) in ACTS.items():
        card(small, big, sky, aur, text).save(os.path.join(out, "S-25%s.png" % k))
        print("S-25" + k)

if __name__ == "__main__":
    main()
