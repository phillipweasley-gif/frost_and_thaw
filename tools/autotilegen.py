#!/usr/bin/env python3
"""Animated autotiles (2026-11-09): A-06 the Auroral Wall, A-15 a flowing sap channel.

    python3 tools/autotilegen.py [--out build/gfx/Autotiles] [--preview OUT.png]

FT_sap_flow[6]: a full 48-shape autotile for the Cave tileset's empty slot 7 (tile ids 336-383), 32 frames, each
frame lasting 6/20 s. It is the game's own "water-murky-SHOREy" with its water and foam recoloured, frame by frame,
to amber sap and its pale gold skin; the earthen banks are the original pixels, so every edge and corner shape is
the game's.
FT_aurora_edge[2], FT_aurora_wall[2], FT_aurora_wall_b[2]: single-tile animated autotiles (PIF's EXTRA_AUTOTILES, on two blank tiles of
the Outdoor tileset): 8 frames of 32x32, each 2/20 s. The curtain's rays run straight up, so tiles stack seamlessly
in both directions; drawn at 16x16 and doubled, like every sprite. The edge tile fades from the full curtain on its
right to nothing on its left; the wall's two tiles are the halves of a 64 px period, so the folds don't repeat every
tile. Which tiles, passages and priorities: game/Data/Scripts/998_FrostThaw/002_TilesetPatch.rb."""
import os, sys, math
from PIL import Image

BASE = "/home/claude/pif-682/Graphics/Autotiles/"
AMBER = [(96, 50, 8), (150, 88, 18), (200, 132, 32), (236, 180, 64), (252, 222, 130)]
SKIN = [(232, 196, 112), (252, 236, 186)]

def sap_flow():
    src = Image.open(BASE + "water-murky-SHOREy.png").convert("RGBA")
    out = src.copy()
    px, sp = out.load(), src.load()
    for y in range(src.height):
        for x in range(src.width):
            r, g, b, a = sp[x, y]
            if not a:
                continue
            lum = (r * 3 + g * 6 + b) / 10
            if b > r + 12 and lum < 175:                     # water
                i = min(len(AMBER) - 1, int(lum / 150 * len(AMBER)))
                px[x, y] = AMBER[i] + (a,)
            elif b >= r - 6 and lum >= 175:                  # foam on the water's edge
                px[x, y] = SKIN[1 if lum > 215 else 0] + (a,)
    return out

AURORA = [(70, 220, 160), (110, 240, 190), (90, 190, 235), (170, 130, 240), (230, 255, 245)]

def aurora_frame(t, part):
    """part: "edge" (fades in from nothing on the left), "a" or "b" (two halves of a 64 px period, so the folds don't
    repeat every tile)."""
    n = 16
    im = Image.new("RGBA", (n, n), (0, 0, 0, 0))
    px = im.load()
    off = {"edge": 0, "a": 0, "b": n}[part]
    for x in range(n):
        u = (x + off) / (2 * n)                           # 0..1 across the two-tile period
        ray = (0.45 + 0.3 * math.sin(2 * math.pi * (u * 3 + t / 8)) + 0.15 * math.sin(2 * math.pi * (u * 5 - t / 8))
               + 0.1 * math.sin(2 * math.pi * (u * 2 + t / 4)))
        hue = 0.5 + 0.5 * math.sin(2 * math.pi * (u * 2 + t / 16))
        fade = (x / (n - 1)) if part == "edge" else 1.0
        for y in range(n):
            shimmer = 0.85 + 0.15 * math.sin(2 * math.pi * (y / n - t / 8))     # a soft pulse running up the folds
            v = ray * shimmer
            if hue < 0.55:
                col = AURORA[0] if v < 0.6 else AURORA[1]
            elif hue < 0.85:
                col = AURORA[2]
            else:
                col = AURORA[3] if v < 0.6 else AURORA[2]
            if v >= 0.92:
                col = AURORA[4]
            a = 36 if v < 0.4 else 70 if v < 0.58 else 115 if v < 0.76 else 165   # a faint wash everywhere, brighter folds
            a = int(a * fade)
            if a >= 12:
                px[x, y] = col + (a,)
    return im.resize((32, 32), Image.NEAREST)

def aurora(part):
    sheet = Image.new("RGBA", (32 * 8, 32), (0, 0, 0, 0))
    for t in range(8):
        sheet.alpha_composite(aurora_frame(t, part), (t * 32, 0))
    return sheet

def main():
    args = sys.argv[1:]
    out = args[args.index("--out") + 1] if "--out" in args else "build/gfx/Autotiles"
    prev = args[args.index("--preview") + 1] if "--preview" in args else None
    os.makedirs(out, exist_ok=True)
    sap = sap_flow()
    sap.save(os.path.join(out, "FT_sap_flow[6].png"))
    wall, wall_b, edgeim = aurora("a"), aurora("b"), aurora("edge")
    wall.save(os.path.join(out, "FT_aurora_wall[2].png"))
    wall_b.save(os.path.join(out, "FT_aurora_wall_b[2].png"))
    edgeim.save(os.path.join(out, "FT_aurora_edge[2].png"))
    print("FT_sap_flow[6] FT_aurora_wall[2] FT_aurora_wall_b[2] FT_aurora_edge[2]")
    if prev:
        bg = (34, 40, 52, 255)
        pv = Image.new("RGBA", (96 * 4 + 40, 128 + 40 + 96), bg)
        for i in range(4):
            pv.alpha_composite(sap.crop((i * 8 * 96, 0, i * 8 * 96 + 96, 128)), (i * 106, 0))
        for i in range(4):                                # a 3x3 patch of the wall (edge column first), four frames
            for yy in range(3):
                pv.alpha_composite(edgeim.crop((i * 2 * 32, 0, i * 2 * 32 + 32, 32)), (i * 106, 168 + yy * 32))
                for xx, w in ((1, wall), (2, wall_b)):
                    pv.alpha_composite(w.crop((i * 2 * 32, 0, i * 2 * 32 + 32, 32)), (i * 106 + xx * 32, 168 + yy * 32))
        pv.resize((pv.width * 2, pv.height * 2), Image.NEAREST).save(prev)

if __name__ == "__main__":
    main()
