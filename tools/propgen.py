#!/usr/bin/env python3
"""Animated props, generated (2026-11-09): A-01 hanging lanterns, A-02 season banners, A-03 ice twinkles,
A-04 sap drips, A-13 laundry.

    python3 tools/propgen.py [--out build/Characters]

Format: a character sheet (320x320, 4x4 frames of 80x80, drawn at 40x40 native and scaled exactly 2x), so a map
event shows it with step animation and a fixed direction: the four columns are the loop, and the row is the variant.
  FT_prop_lantern: row 1 (down) a Rootspire paper lantern, row 2 (left) a Ten-Towns iron lamp; rows 3-4 repeat them.
  FT_prop_banner:  rows 1-4 (down, left, right, up) the spring, summer, autumn and winter banners.
A prop hangs on the wall tile its event stands on: the tile's bottom is native row 36, its top row 20, so these
hang from a bracket at about row 13 and sit on the wall above head height."""
import os, sys
from PIL import Image

OUT = (14, 8, 13)
N = 40

def sheet(rows):
    im = Image.new("RGBA", (160, 160), (0, 0, 0, 0))
    px = im.load()
    for r, frames in enumerate(rows):
        for c, pts in enumerate(frames):
            for (x, y), col in pts.items():
                if 0 <= x < N and 0 <= y < N:
                    px[c * N + x, r * N + y] = col + (255,)
    return im.resize((320, 320), Image.NEAREST)

def outlined(pts):
    """Close every shape with the near-black outline (4-neighbour)."""
    out = dict(pts)
    for (x, y) in pts:
        for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            if (x + dx, y + dy) not in pts:
                out[(x + dx, y + dy)] = OUT
    return out

# --- A-01 lanterns ------------------------------------------------------------------------------------------
PAPER = [(150, 40, 30), (210, 80, 40), (246, 160, 70), (255, 222, 140), (255, 250, 220)]
IRON = [(40, 40, 50), (80, 80, 96)]
FLAME = [(240, 140, 40), (255, 210, 90), (255, 250, 220)]
WOOD = [(90, 60, 36), (130, 92, 54)]

def bracket(pts, cx):
    """A wooden arm from the wall, and the cord or chain down to the lamp."""
    for x in range(cx - 5, cx + 1):
        pts[(x, 12)] = WOOD[1]
    pts[(cx - 5, 13)] = WOOD[0]

def paper_lantern(sway, flick):
    pts = {}
    cx = 22
    bracket(pts, cx)
    top = 15
    lx = cx + sway                                      # the lantern swings from its cord
    pts[(cx, 13)] = IRON[1]; pts[(cx + (sway > 0), 14)] = IRON[1]
    rows = [3, 5, 6, 6, 6, 5, 3]                        # a round paper lantern, ribbed
    for i, half in enumerate(rows):
        y = top + i
        for x in range(lx - half // 2 - 1, lx + half // 2 + 1):
            d = abs(x - lx)
            c = PAPER[4] if d == 0 and 2 <= i <= 4 and flick else PAPER[3] if d <= 1 and 1 <= i <= 5 else PAPER[2] if d <= 2 else PAPER[1]
            if i in (1, 5) and d > 1:
                c = PAPER[1]                            # the ribs
            pts[(x, y)] = c
    for x in range(lx - 1, lx + 2):
        pts[(x, top - 1)] = PAPER[0]; pts[(x, top + len(rows))] = PAPER[0]   # the caps
    pts[(lx, top + len(rows) + 1)] = PAPER[1]           # the tassel
    return outlined(pts)

def iron_lamp(sway, flick):
    pts = {}
    cx = 22
    bracket(pts, cx)
    lx = cx + sway
    pts[(cx, 13)] = IRON[0]; pts[(cx + (sway > 0), 14)] = IRON[0]
    for x in range(lx - 3, lx + 4):                     # the hood
        pts[(x, 15)] = IRON[1]
    for x in range(lx - 2, lx + 3):
        pts[(x, 14 + (0 if abs(x - lx) < 2 else 1))] = IRON[1]
    for y in range(16, 22):                             # the cage: glass panes with iron ribs
        for x in range(lx - 2, lx + 3):
            if abs(x - lx) == 2:
                pts[(x, y)] = IRON[0]
            else:
                pts[(x, y)] = FLAME[2] if (x == lx and 18 <= y <= 19 and flick) else FLAME[1] if abs(x - lx) <= 1 and 17 <= y <= 20 else FLAME[0]
    for x in range(lx - 3, lx + 4):
        pts[(x, 22)] = IRON[1]
    return outlined(pts)

def lanterns():
    loop = [(0, True), (1, False), (0, True), (-1, False)]     # swing and flicker
    paper = [paper_lantern(s, f) for s, f in loop]
    iron = [iron_lamp(s, f) for s, f in loop]
    return sheet([paper, iron, paper, iron])

# --- A-02 banners --------------------------------------------------------------------------------------------
SEASONS = [
    [(30, 80, 40), (70, 150, 60), (140, 210, 100), (230, 250, 200)],     # spring
    [(130, 90, 10), (220, 170, 30), (250, 220, 90), (255, 250, 210)],    # summer
    [(110, 30, 20), (190, 70, 30), (240, 140, 60), (255, 220, 170)],     # autumn
    [(40, 60, 110), (110, 150, 210), (190, 220, 250), (250, 252, 255)],  # winter
]

def banner(ramp, phase):
    pts = {}
    for x in range(12, 29):                             # the pole
        pts[(x, 6)] = WOOD[1]
    pts[(11, 6)] = WOOD[0]; pts[(29, 6)] = WOOD[0]
    for y in range(7, 31):
        u = (y - 7) / 23                                # the lower it hangs, the more the wind moves it
        wave = round([0, 1, 0, -1][(phase + (y // 6)) % 4] * u * 1.6)
        for x in range(14, 27):
            if y == 30 and 18 <= x <= 22:
                continue                                # the swallow-tail notch
            if y == 29 and 19 <= x <= 21:
                continue
            c = ramp[1]
            if x in (14, 26):
                c = ramp[0]                             # the hem
            elif 17 <= x <= 23 and 11 <= y <= 18:      # the season's sigil: a diamond
                if abs(x - 20) + abs(y - 14.5) <= 3.5:
                    c = ramp[3] if abs(x - 20) + abs(y - 14.5) <= 1.5 else ramp[2]
            elif x == 15:
                c = ramp[2]                             # the light side of the cloth
            pts[(x + wave, y)] = c
    return outlined(pts)

def banners():
    return sheet([[banner(r, p) for p in range(4)] for r in SEASONS])

# --- A-13 laundry on a line, A-04 sap drip, A-03 ice twinkle -----------------------------------------------
ROPE = (200, 190, 160)
CLOTH = [((40, 80, 150), (90, 140, 210)), ((200, 200, 210), (250, 250, 255)), ((150, 40, 40), (220, 80, 70))]

def laundry(phase):
    pts = {}
    for y in range(18, 37):                              # two posts
        pts[(5, y)] = WOOD[1]; pts[(34, y)] = WOOD[1]
    sag = lambda x: 19 + round(2 * (1 - ((x - 19.5) / 14.5) ** 2))
    for x in range(6, 34):
        pts[(x, sag(x))] = ROPE
    # a shirt, a sheet and a pair of socks, their hems moving with the wind
    for (x0, x1, h, ci) in ((8, 14, 8, 0), (16, 25, 11, 1), (27, 31, 5, 2)):
        dark, light = CLOTH[ci]
        for x in range(x0, x1):
            top = sag(x) + 1
            swing = [0, 1, 0, -1][(phase + x // 3) % 4]
            for y in range(top, top + h + (1 if (x + phase) % 3 == 0 else 0)):
                pts[(x + (swing if y > top + h // 2 else 0), y)] = light if x == x0 or y == top else dark
    return outlined(pts)

AMBER = [(110, 60, 10), (200, 130, 30), (250, 200, 90)]

def sap_drip(k):
    pts = {}
    for x in range(16, 25):                              # the root it drips from, high on the wall
        pts[(x, 6 + abs(x - 20) // 2)] = WOOD[0] if abs(x - 20) > 2 else WOOD[1]
    pts[(20, 9)] = WOOD[1]
    for x in range(17, 24):                              # the little pool on the floor
        pts[(x, 35)] = AMBER[1] if 18 <= x <= 22 else AMBER[0]
    pts[(19, 34)] = AMBER[2]
    if k == 0:
        pts[(20, 10)] = AMBER[2]                         # a drop forms
    elif k == 1:
        pts[(20, 10)] = AMBER[1]; pts[(20, 11)] = AMBER[2]; pts[(19, 11)] = AMBER[1]; pts[(21, 11)] = AMBER[1]
    elif k == 2:
        pts[(20, 22)] = AMBER[2]; pts[(20, 23)] = AMBER[1]   # it falls
    else:
        for x, y in ((18, 33), (22, 33), (17, 32), (23, 32), (20, 32)):
            pts[(x, y)] = AMBER[2]                       # and splashes
    return outlined(pts)

ICE_T = [(120, 172, 222), (192, 226, 248), (255, 255, 255)]

def twinkle(on):
    pts = {}
    if on:
        cx, cy = 20, 31
        for dx, dy in ((0, -2), (0, 2), (-2, 0), (2, 0)):
            pts[(cx + dx, cy + dy)] = ICE_T[0]
        for dx, dy in ((0, -1), (0, 1), (-1, 0), (1, 0)):
            pts[(cx + dx, cy + dy)] = ICE_T[1]
        pts[(cx, cy)] = ICE_T[2]
    return pts                                           # light, so no outline: it should read as a glint

def more_props(out):
    sheet([[laundry(p) for p in range(4)]] * 4).save(os.path.join(out, "FT_prop_laundry.png"))
    sheet([[sap_drip(k) for k in range(4)]] * 4).save(os.path.join(out, "FT_prop_sapdrip.png"))
    # four rows, each glinting on a different frame, so neighbours don't flash together
    sheet([[twinkle(c == r) for c in range(4)] for r in range(4)]).save(os.path.join(out, "FT_prop_twinkle.png"))

def main():
    out = "build/Characters"
    if "--out" in sys.argv:
        out = sys.argv[sys.argv.index("--out") + 1]
    os.makedirs(out, exist_ok=True)
    lanterns().save(os.path.join(out, "FT_prop_lantern.png"))
    banners().save(os.path.join(out, "FT_prop_banner.png"))
    more_props(out)
    print("FT_prop_lantern FT_prop_banner FT_prop_laundry FT_prop_sapdrip FT_prop_twinkle")

if __name__ == "__main__":
    main()
