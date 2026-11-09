#!/usr/bin/env python3
"""Reaction balloons, generated (2026-11-09): B-02 heart, B-03 anger mark, B-04 sweat drop, B-08 Zzz, B-09 sparkle,
B-10 light bulb.

    python3 tools/balloongen.py [--out build/gfx/Pictures/Balloons]

The bubble is the approved B-01's, pixel for pixel (its "..." taken out); each icon is drawn at native size (16x16
frames, scaled exactly 2x) in frames 3 and 4, which Stage.balloon alternates after the bubble pops in (frames 1-2)."""
import os, sys
from PIL import Image

OUT = (14, 8, 13)
WHITE = (255, 255, 255)
COL = {
    "D": (120, 20, 40), "R": (226, 54, 72), "P": (255, 168, 180),           # heart and anger
    "B": (64, 140, 222), "L": (200, 232, 255), "N": (40, 52, 110),          # drop and Zzz
    "Y": (248, 206, 60), "W": (255, 250, 220), "O": (214, 136, 30),         # sparkle and bulb
    "G": (150, 150, 160), "K": (14, 8, 13),                                  # the bulb's screw base: grey, outline
}

ICONS = {
    "B-02": ([".DD.DD.", "DRPRRRD", "DRRRRRD", ".DRRRD.", "..DRD..", "...D..."],
             [".DD.DD.", "DRPRRRD", "DRRRRRD", ".DRRRD.", "..DRD..", "...D..."], (0, -1)),
    "B-03": (["..R.R..", ".RR.RR.", "RR...RR", ".......", "RR...RR", ".RR.RR.", "..R.R.."],
             [".......", "..R.R..", ".RR.RR.", ".......", ".RR.RR.", "..R.R..", "......."], (0, 0)),
    "B-04": (["..N..", ".NBN.", "NBLBN", "NBBBN", ".NNN."],
             ["..N..", ".NBN.", "NBLBN", "NBBBN", ".NNN."], (1, 1)),
    "B-08": (["......", "......", "NNN...", "..N...", ".N....", "NNN..."],
             ["..NNNN", "....N.", "NNN.N.", "..NNNN", ".N....", "NNN..."], (0, 0)),
    "B-09": (["...Y.....", "..YWY....", ".YWWWY...", "..YWY..Y.", "...Y...Y.", ".......Y."],
             [".........", "......Y..", ".Y...YWY.", "YWY...Y..", ".Y.......", "........."], (0, 0)),
    "B-10": ([".OYYO.", "OYWWYO", "OYWYYO", "OYYYYO", ".OYYO.", "..GG..", "..KK.."],
             ["Y.OYYO.Y", ".OYWWYO.", "YOYWYYOY", ".OYYYYO.", "..OYYO..", "...GG...", "...KK..."], (0, 0)),
}

def bubble_frames():
    here = os.path.dirname(os.path.abspath(__file__))
    src = os.path.join(here, "..", "build", "gfx", "Pictures", "Balloons", "B-01.png")
    im = Image.open(src).convert("RGBA").resize((64, 16), Image.NEAREST)
    frames = []
    for f in range(4):
        fr = im.crop((f * 16, 0, f * 16 + 16, 16))
        px = fr.load()
        # the outside: flood from the edges through transparent pixels
        outside, stack = set(), [(x, y) for x in range(16) for y in (0, 15)] + [(x, y) for y in range(16) for x in (0, 15)]
        while stack:
            x, y = stack.pop()
            if (x, y) in outside or not (0 <= x < 16 and 0 <= y < 16) or px[x, y][3]:
                continue
            outside.add((x, y))
            stack += [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
        # an outline-coloured pixel that doesn't touch the outside is content ("..."): make it white
        for y in range(16):
            for x in range(16):
                if px[x, y][3] and px[x, y][:3] == OUT:
                    edge = any((x + dx, y + dy) in outside or not (0 <= x + dx < 16 and 0 <= y + dy < 16)
                               for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))
                    if not edge:
                        px[x, y] = WHITE + (255,)
        frames.append(fr)
    return frames

def stamp(fr, rows, centre, shift=(0, 0)):
    px = fr.load()
    h, w = len(rows), max(len(r) for r in rows)
    x0 = int(round(centre[0] - w / 2)) + shift[0]
    y0 = int(round(centre[1] - h / 2)) + shift[1]
    for j, r in enumerate(rows):
        for i, ch in enumerate(r):
            if ch != ".":
                px[x0 + i, y0 + j] = COL[ch] + (255,)

def main():
    out_dir = "build/gfx/Pictures/Balloons"
    if "--out" in sys.argv:
        out_dir = sys.argv[sys.argv.index("--out") + 1]
    os.makedirs(out_dir, exist_ok=True)
    for name, (a, b, shift) in ICONS.items():
        frames = [f.copy() for f in bubble_frames()]
        stamp(frames[2], a, (7, 7.5))
        stamp(frames[3], b, (7.5, 7), shift)
        sheet = Image.new("RGBA", (64, 16), (0, 0, 0, 0))
        for f in range(4):
            sheet.paste(frames[f], (f * 16, 0))
        sheet.resize((128, 32), Image.NEAREST).save(os.path.join(out_dir, name + ".png"))
        print(name)

if __name__ == "__main__":
    main()
