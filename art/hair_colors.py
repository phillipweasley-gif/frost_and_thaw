"""Adds new hair colours to every hairstyle by recolouring the blonde version (1).

Versions 1-4 are the game's (blonde, light brown, dark brown, black); some styles
also have a 5 (that character's own colour). The game finds versions by counting
up from 1 and stopping at the first gap, so:
  5 = Ice Blue  (only made for styles that don't already have a 5)
  6 = Red, 7 = Auburn, 8 = White   (made for every style)
Usage: python3 hair_colors.py <game hair folder> <output hair folder>"""
import os, sys, colorsys
from PIL import Image

# luminance stops measured from the blonde palette -> target colours
STOPS = [0.40, 0.69, 0.78, 0.89]
PALETTES = {
    "red":    [(112, 28, 24), (178, 44, 34), (212, 66, 44), (240, 118, 84)],
    "auburn": [(86, 34, 22), (146, 62, 36), (178, 84, 48), (214, 128, 82)],
    "white":  [(150, 154, 170), (214, 218, 228), (234, 236, 242), (252, 252, 255)],
    "ice":    [(52, 92, 150), (110, 166, 214), (146, 196, 232), (204, 234, 250)],
}
NEW = {6: "red", 7: "auburn", 8: "white"}
FILL_5 = "ice"


def lum(r, g, b):
    return (0.299 * r + 0.587 * g + 0.114 * b) / 255.0


def ramp(pal, L):
    if L <= STOPS[0]:
        f = L / STOPS[0]
        return tuple(int(c * (0.55 + 0.45 * f)) for c in pal[0])
    for i in range(len(STOPS) - 1):
        a, b = STOPS[i], STOPS[i + 1]
        if L <= b:
            t = (L - a) / (b - a)
            return tuple(int(pal[i][k] + (pal[i + 1][k] - pal[i][k]) * t) for k in range(3))
    t = min(1.0, (L - STOPS[-1]) / (1 - STOPS[-1]))
    return tuple(int(pal[-1][k] + (255 - pal[-1][k]) * t * 0.5) for k in range(3))


def is_hair(r, g, b):
    h, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
    return 0.03 <= h <= 0.17 and s >= 0.12 and v >= 0.25


def recolor(img, pal):
    img = img.copy()
    px = img.load()
    for y in range(img.height):
        for x in range(img.width):
            r, g, b, a = px[x, y]
            if a and is_hair(r, g, b):
                px[x, y] = ramp(pal, lum(r, g, b)) + (a,)
    return img


def main(src, dst):
    made = 0
    for name in sorted(os.listdir(src)):
        d = os.path.join(src, name)
        if not os.path.isdir(d):
            continue
        walk1 = os.path.join(d, f"hair_1_{name}.png")
        tr1 = os.path.join(d, f"hair_trainer_1_{name}.png")
        if not (os.path.exists(walk1) and os.path.exists(tr1)):
            continue
        walk, tr = Image.open(walk1).convert("RGBA"), Image.open(tr1).convert("RGBA")
        out = os.path.join(dst, name)
        os.makedirs(out, exist_ok=True)
        versions = dict(NEW)
        if not os.path.exists(os.path.join(d, f"hair_5_{name}.png")):
            versions[5] = FILL_5
        for v, colour in versions.items():
            pal = PALETTES[colour]
            recolor(walk, pal).save(os.path.join(out, f"hair_{v}_{name}.png"))
            recolor(tr, pal).save(os.path.join(out, f"hair_trainer_{v}_{name}.png"))
            made += 2
    print(f"{made} files written")


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
