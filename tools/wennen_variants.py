#!/usr/bin/env python3
"""The generic Wennen and the jet sentry on the rebuilt Wennen (2026-11-09), so the Warren's crowd matches Pip, Luna,
Zenith and Lumin (the old pair were in a taller, painted style). Palette swaps of the designer's sheets:
FT_wennen_generic is Zenith's build in grey-white fur and a brown homespun robe; FT_wennen_jet_sentry is Lumin's in
jet fur, keeping her blue and gold, with amber eyes so they read on the dark fur.

    python3 tools/wennen_variants.py [--out build/Characters]"""
import os, sys
from PIL import Image

GENERIC = ("FT_wennen_zenith", {
    (196, 181, 155): (168, 168, 174), (229, 213, 182): (206, 206, 212), (244, 230, 207): (236, 236, 242),
    (143, 130, 112): (120, 120, 130), (55, 107, 78): (112, 84, 58), (37, 75, 61): (78, 56, 40),
    (111, 155, 105): (152, 120, 84)})
SENTRY = ("FT_wennen_lumin", {
    (234, 215, 189): (86, 84, 98), (255, 240, 223): (116, 114, 130), (255, 246, 237): (146, 144, 160),
    (188, 168, 143): (60, 58, 70), (48, 43, 53): (236, 196, 84)})

def build(src, swap):
    im = Image.open(os.path.join("build/Characters", src + ".png")).convert("RGBA")
    px = im.load()
    for y in range(im.height):
        for x in range(im.width):
            p = px[x, y]
            if p[3] and p[:3] in swap:
                px[x, y] = swap[p[:3]] + (255,)
    return im

if __name__ == "__main__":
    out = sys.argv[sys.argv.index("--out") + 1] if "--out" in sys.argv else "build/Characters"
    build(*GENERIC).save(os.path.join(out, "FT_wennen_generic.png"))
    build(*SENTRY).save(os.path.join(out, "FT_wennen_jet_sentry.png"))
    print("FT_wennen_generic FT_wennen_jet_sentry")
