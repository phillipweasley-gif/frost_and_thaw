#!/usr/bin/env python3
"""Animated props, generated (2026-11-09): A-01 hanging lanterns, A-02 season banners, A-03 ice twinkles,
A-04 sap drips, A-13 laundry, A-05 glowing spore beds (rows: teal, violet, amber), A-07 bees over a hive, A-08 snow
birds pecking (rows: four placings), A-16 a Wennen peeking out of a burrow (hidden, ears, looking, ducking), A-14
snow sliding off a roof (rows: nothing, falling, landing, the puff; the event's route turns through them every
few seconds, so the slide happens now and then, not on a loop).

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

# --- A-05 glowing spore beds -----------------------------------------------------------------------------------
SPORE = {"teal": [(20, 70, 76), (40, 140, 140), (110, 220, 210), (210, 255, 246)],
         "violet": [(54, 30, 80), (110, 66, 170), (180, 130, 240), (240, 220, 255)],
         "amber": [(80, 46, 14), (170, 104, 30), (240, 180, 70), (255, 240, 190)]}
STALK = [(150, 140, 120), (200, 192, 170)]

def spore_bed(ramp, pulse):
    """Three caps on the floor, their glow pulsing (pulse 0..2)."""
    pts = {}
    for (cx, cy, r) in ((15, 33, 3), (22, 31, 4), (27, 34, 2)):
        for y in range(cy, 37):                           # the stalk
            pts[(cx, y)] = STALK[0] if y > cy + 1 else STALK[1]
        for dy in range(-r // 2 - 1, 1):
            for dx in range(-r, r + 1):
                if dx * dx / (r * r + 0.5) + (dy * dy) / ((r / 2 + 1) ** 2) <= 1:
                    pts[(cx + dx, cy + dy)] = ramp[1 + (1 if dy < -r // 3 else 0)]
        pts[(cx - r // 2, cy - r // 2 - 1)] = ramp[2 + (pulse == 2)]         # the glow spot
        for dx in (-1, 1):
            if pulse:
                pts[(cx + dx * (r - 1), cy - 1)] = ramp[2]
    out = outlined(pts)
    if pulse:                                             # a halo on the floor when it's bright
        for (cx, cy, r) in ((15, 33, 3), (22, 31, 4), (27, 34, 2)):
            for dx in range(-r - 1, r + 2):
                if (cx + dx, 37) not in out:
                    out[(cx + dx, 37)] = ramp[1 if pulse == 1 else 2]
    return out

def spore_beds():
    rows = []
    for name in ("teal", "violet", "amber", "teal"):
        rows.append([spore_bed(SPORE[name], p) for p in (0, 1, 2, 1)])
    return sheet(rows)

# --- A-07 bees circling a hive -----------------------------------------------------------------------------------
BEE = [(40, 30, 10), (240, 190, 40), (250, 250, 255)]

def bees(phase):
    """Five bees on a loose loop above the hive box the event stands on (they hover at rows 8-24)."""
    import math
    pts = {}
    for i in range(5):
        a = (phase / 4 + i / 5) * 2 * math.pi
        x = round(20 + 11 * math.cos(a))
        y = round(16 + 5 * math.sin(a) + (2 if i % 2 else 0))
        pts[(x, y)] = BEE[1]; pts[(x + 1, y)] = BEE[0]
        pts[(x, y - 1)] = BEE[2]                          # a wing glint
    return pts                                            # tiny: no outline, as the base game's

# --- A-08 snow birds pecking ------------------------------------------------------------------------------------
BIRD = [(70, 50, 40), (150, 110, 80), (236, 236, 240), (240, 170, 60)]

def bird(pts, x, y, peck, hop):
    y -= hop
    for dx in range(4):
        pts[(x + dx, y)] = BIRD[2] if dx < 3 else BIRD[1]          # white breast, brown back
        pts[(x + dx, y - 1)] = BIRD[1] if dx else BIRD[2]
    hx, hy = (x - 1, y) if peck else (x - 1, y - 2)
    pts[(hx, hy)] = BIRD[2]; pts[(hx + 1, hy)] = BIRD[1]
    pts[(hx - 1, hy + (1 if peck else 0))] = BIRD[3]               # beak
    pts[(x + 4, y - 2)] = BIRD[0]                                  # tail
    pts[(x + 1, y + 1)] = BIRD[0]; pts[(x + 2, y + 1)] = BIRD[0]   # feet

def birds(variant, f):
    pts = {}
    a = [(1, 0), (0, 0), (0, 1), (0, 0)][f]
    b = [(0, 0), (1, 0), (0, 0), (0, 1)][f]
    spots = [((12, 33), (24, 35)), ((16, 35), (26, 32)), ((10, 34), (22, 33)), ((14, 32), (25, 35))][variant]
    bird(pts, *spots[0], *a)
    bird(pts, *spots[1], *b)
    return outlined(pts)

# --- A-16 a Wennen peeking out of a burrow -----------------------------------------------------------------------
EARTH = [(40, 28, 20), (90, 64, 40), (130, 96, 60)]

def wennen_peek(head, k):
    pts = {}
    for dx in range(-6, 7):                               # the burrow mouth and its rim of earth
        for dy in range(-1, 2):
            if dx * dx / 36 + dy * dy / 2.2 <= 1:
                pts[(20 + dx, 34 + dy)] = EARTH[0]
    for dx in (-7, -6, 6, 7):
        pts[(20 + dx, 34)] = EARTH[2]
    for dx in range(-5, 6, 2):
        pts[(20 + dx, 36)] = EARTH[1]
    out = outlined(pts)
    show = [0, 7, 20, 6][k]                               # rows of the head above the hole: ears, then eyes
    if show:
        part = head.crop((0, 0, head.width, show))      # the top `show` rows: the hole hides the rest
        x0 = 20 - head.width // 2
        for y in range(part.height):
            for x in range(part.width):
                p = part.getpixel((x, y))
                if p[3]:
                    out[(x0 + x, 34 - show + y)] = p[:3]
    return out

def wennen_peeks():
    src = Image.open("build/Characters/FT_wennen_generic.png").convert("RGBA").resize((160, 160), Image.NEAREST)
    rows = []
    for r in range(4):
        fr = src.crop((0, 0, N, N))                       # facing out of the burrow, every row
        head = fr.crop(fr.getbbox())
        rows.append([wennen_peek(head, k) for k in range(4)])
    return sheet(rows)

# --- A-14 snow sliding off a roof edge --------------------------------------------------------------------------
SNOWC = [(150, 170, 196), (214, 228, 244), (250, 252, 255)]

def snow_slide(stage):
    """One state per row (the event's route turns through them now and then): 0 nothing, 1 a clump just off the
    eave, 2 near the ground, trailing powder, 3 the puff where it lands."""
    pts = {}
    if stage == 1:
        for (x, y) in ((19, 6), (20, 6), (21, 6), (18, 7), (19, 7), (20, 7), (21, 7), (22, 7), (19, 8), (20, 8), (21, 8)):
            pts[(x, y)] = SNOWC[2] if y == 6 else SNOWC[1]
        out = outlined(pts)
        for (x, y) in ((17, 4), (23, 3), (20, 3)):
            out[(x, y)] = SNOWC[2]
        return out
    if stage == 2:
        for (x, y) in ((19, 27), (20, 27), (21, 27), (18, 28), (19, 28), (20, 28), (21, 28), (22, 28), (19, 29), (20, 29), (21, 29), (20, 30)):
            pts[(x, y)] = SNOWC[1] if y > 27 else SNOWC[2]
        out = outlined(pts)
        for y in range(10, 25, 3):                        # the powder it trails
            out[(20 + (y % 2), y)] = SNOWC[2]
        return out
    if stage == 3:
        for dx in range(-6, 7):
            y = 36 - (2 if abs(dx) < 3 else 1 if abs(dx) < 5 else 0)
            pts[(20 + dx, y)] = SNOWC[1]
            pts[(20 + dx, 37)] = SNOWC[0]
        out = outlined(pts)
        for (x, y) in ((12, 32), (28, 31), (15, 30), (25, 29), (20, 31)):
            out[(x, y)] = SNOWC[2]
        return out
    return {}

def ambient_props(out):
    sheet([[snow_slide(st)] * 4 for st in (0, 1, 2, 3)]).save(os.path.join(out, "FT_prop_snowslide.png"))
    spore_beds().save(os.path.join(out, "FT_prop_spores.png"))
    sheet([[bees(p) for p in range(4)]] * 4).save(os.path.join(out, "FT_prop_bees.png"))
    sheet([[birds(r, f) for f in range(4)] for r in range(4)]).save(os.path.join(out, "FT_prop_birds.png"))
    wennen_peeks().save(os.path.join(out, "FT_prop_wennen.png"))

def main():
    out = "build/Characters"
    if "--out" in sys.argv:
        out = sys.argv[sys.argv.index("--out") + 1]
    os.makedirs(out, exist_ok=True)
    lanterns().save(os.path.join(out, "FT_prop_lantern.png"))
    banners().save(os.path.join(out, "FT_prop_banner.png"))
    more_props(out)
    ambient_props(out)
    print("FT_prop_lantern FT_prop_banner FT_prop_laundry FT_prop_sapdrip FT_prop_twinkle FT_prop_spores FT_prop_bees "
          "FT_prop_birds FT_prop_wennen FT_prop_snowslide")

if __name__ == "__main__":
    main()
