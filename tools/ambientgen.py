#!/usr/bin/env python3
"""Ambient overlays, generated (2026-11-09): A-11 drifting spores, A-12 forge embers.

    python3 tools/ambientgen.py [--out build/gfx/Pictures/Overlays]

Format (Stage.overlay, as O-01): 512x384, drawn at 256x192 native and scaled exactly 2x, alpha 0/255, at most
12 colours, tileable both ways (motes wrap at the edges), so a Plane can scroll it for ever. The drift comes from
the scroll speed the map gives it (Stage.overlay(..., scroll_y:)), not from frames."""
import os, sys, random
from PIL import Image

W, H = 256, 192

def put(px, x, y, c):
    px[x % W, y % H] = c + (255,)

def mote(px, x, y, ramp, size):
    """A glowing mote: a bright core with its colour around it (a plus at size 2, a dot at 1)."""
    if size >= 2:
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            put(px, x + dx, y + dy, ramp[1])
    put(px, x, y, ramp[2] if size >= 2 else ramp[1])

def spores():
    """A-11: spores in the Undercanopy's three glows (teal, violet, amber), sparse and soft."""
    rnd = random.Random(11)
    ramps = [((20, 70, 70), (70, 200, 190), (200, 255, 246)),
             ((60, 30, 100), (170, 110, 230), (236, 214, 255)),
             ((90, 60, 20), (230, 170, 60), (255, 236, 176))]
    im = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    px = im.load()
    for _ in range(70):
        r = rnd.choice(ramps)
        mote(px, rnd.randrange(W), rnd.randrange(H), r, 2 if rnd.random() < 0.3 else 1)
    return im

def embers():
    """A-12: forge embers rising: short bright streaks (the motion blur of something rising fast) and sparks."""
    rnd = random.Random(12)
    ramp = ((150, 40, 20), (240, 120, 40), (255, 220, 120))
    im = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    px = im.load()
    for _ in range(60):
        x, y = rnd.randrange(W), rnd.randrange(H)
        kind = rnd.random()
        if kind < 0.35:                      # a streak: bright head on top, cooling tail below
            put(px, x, y, ramp[2]); put(px, x, y + 1, ramp[1]); put(px, x, y + 2, ramp[0])
        elif kind < 0.55:
            mote(px, x, y, ramp, 2)
        else:
            put(px, x, y, ramp[1] if rnd.random() < 0.6 else ramp[2])
    return im

def main():
    out = "build/gfx/Pictures/Overlays"
    if "--out" in sys.argv:
        out = sys.argv[sys.argv.index("--out") + 1]
    os.makedirs(out, exist_ok=True)
    for name, fn in (("A-11", spores), ("A-12", embers)):
        fn().resize((W * 2, H * 2), Image.NEAREST).save(os.path.join(out, name + ".png"))
        print(name)

if __name__ == "__main__":
    main()
