#!/usr/bin/env python3
"""Townsfolk at work (2026-11-09): A-09 fishing at an ice hole, A-10 warming hands at a brazier, A-17 shovelling
snow, made from the base game's own townsfolk sheets with tools/posegen.py's operations (so they look like every
other villager), and the brazier itself.

    python3 tools/townsfolkgen.py [--out build/Characters] [--preview OUT.png]

Each is a 320x320 sheet shown with step animation and a fixed facing: the row is the facing (down, left, right, up),
the four frames the loop. The side rows carry the action; the front and back rows are a quieter version of it.
  FT_town_warm_a / _b   hands out to the fire, rubbing (two villagers)     BW (72), BW (62)
  FT_town_shovel        scoop, lift, throw (a puff of snow), back           BW (75)
  FT_town_fish_a / _b   sat on the ice, rod out, the line bobbing in a hole BW (54), BW (40)
  FT_prop_brazier       an iron brazier, its fire flickering (a prop, solid)"""
import os, sys
from PIL import Image
sys.path.insert(0, os.path.dirname(__file__))
import posegen as pg

BASE = "/home/claude/pif-682/Graphics/Characters/"
N = pg.N
WOOD = [(90, 60, 36), (130, 92, 54)]
IRON = [(40, 40, 50), (80, 80, 96), (120, 120, 136)]
STEEL = [(120, 130, 146), (186, 196, 210)]
FIRE = [(200, 60, 20), (240, 140, 40), (255, 210, 90), (255, 250, 220)]
SNOW = [(214, 228, 244), (250, 252, 255)]
HOLE = [(18, 30, 52), (40, 70, 110), (110, 160, 210)]

def base(name):
    return Image.open(BASE + name + ".png").convert("RGBA").resize((N * 4, N * 4), Image.NEAREST)

def side_front(fr, m, fwd):
    w = pg.widths(fr)
    rows = range(m.sh + 1, m.sh + 4)
    return max(w[y][1] for y in rows) if fwd > 0 else min(w[y][0] for y in rows)

def line_pts(a, b, col):
    return {p: col for p in pg.line(a, b)}

# --- A-10 warming hands -----------------------------------------------------------------------------------------
def warm(sheet):
    out = []
    for r in range(4):
        fr = pg.cell(sheet, r)
        m = pg.Marks(fr)
        frames = []
        for f in range(4):
            dy = (0, -1, 0, 1)[f]                         # rubbing: the hands go up and down a pixel
            if r in (1, 2):
                fwd = 1 if r == 2 else -1
                front = side_front(fr, m, fwd)
                frames.append(pg.draw_arm(fr, m, (front - fwd * 2, m.sh + 3), (front + fwd * 3, m.sh + 2 + dy)))
            elif r == 3:                                  # back to us: elbows out a little, hands hidden
                body = pg.erase_arm(pg.erase_arm(fr, m, "L"), m, "R")
                a = pg.draw_arm(body, m, (m.L + 1, m.sh + 2), (m.L, m.sh + 1 + dy), hand=False)
                frames.append(pg.draw_arm(a, m, (m.R - 2, m.sh + 2), (m.R - 1, m.sh + 1 - dy), hand=False))
            else:                                         # facing us: both hands held out in front of the chest
                body = pg.erase_arm(pg.erase_arm(fr, m, "L"), m, "R")
                cx = int(m.cx)
                a = pg.draw_arm(body, m, (m.L + 2, m.sh + 1), (cx - 3, m.sh + 3 + dy), via=(m.L + 2, m.sh + 4))
                frames.append(pg.draw_arm(a, m, (m.R - 3, m.sh + 1), (cx + 1, m.sh + 3 - dy), via=(m.R - 3, m.sh + 4)))
        out.append(frames)
    return out

def brazier():
    rows = []
    for r in range(4):
        frames = []
        for f in range(4):
            pts = {}
            for x in range(14, 27):                       # the bowl
                for y in range(26, 30):
                    if abs(x - 20) <= 6 - (y - 26):
                        pts[(x, y)] = IRON[1] if y == 26 else IRON[0]
            for x in (15, 20, 25):                        # three legs
                for y in range(30, 37):
                    pts[(x + (1 if x == 15 and y > 33 else -1 if x == 25 and y > 33 else 0), y)] = IRON[0]
            for x in range(15, 26):                       # coals
                pts[(x, 25)] = FIRE[0] if (x + f) % 3 else FIRE[1]
            h = [9, 11, 8, 10][(f + r) % 4]               # the flames, flickering
            for i in range(h):
                y = 24 - i
                half = max(0, 4 - i // 2)
                sway = [0, 1, 0, -1][(f + i // 3) % 4]
                for dx in range(-half, half + 1):
                    c = FIRE[1] if abs(dx) == half else FIRE[2] if i < h - 2 else FIRE[3]
                    pts[(20 + dx + sway, y)] = c
            out = {}
            for p, c in pts.items():                      # outline the iron only; fire is light
                out[p] = c
            for (x, y), c in list(pts.items()):
                if c in IRON:
                    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                        if (x + dx, y + dy) not in pts:
                            out[(x + dx, y + dy)] = (14, 8, 13)
            frames.append(out)
        rows.append(frames)
    im = Image.new("RGBA", (N * 4, N * 4), (0, 0, 0, 0))
    px = im.load()
    for r, frames in enumerate(rows):
        for c, pts in enumerate(frames):
            for (x, y), col in pts.items():
                if 0 <= x < N and 0 <= y < N:
                    px[c * N + x, r * N + y] = col + (255,)
    return im

# --- A-17 shovelling --------------------------------------------------------------------------------------------
def shovel(sheet):
    out = []
    for r in range(4):
        fr = pg.cell(sheet, r)
        m = pg.Marks(fr)
        fwd = {0: 1, 1: -1, 2: 1, 3: -1}[r]
        frames = []
        for f in range(4):
            body = fr if f != 1 else pg.kneel(fr, m, 1)   # bends to scoop
            bm = m if f != 1 else pg.Marks(body)
            front = side_front(body, bm, fwd) if r in (1, 2) else (bm.R if fwd > 0 else bm.L)
            hand = (front + fwd * 2, bm.sh + 3)
            blade_at = [(front + fwd * 7, bm.bot), (front + fwd * 6, bm.bot - 1), (front + fwd * 6, bm.sh - 2),
                        (front + fwd * 7, bm.bot - 5)][f]
            item = line_pts(hand, blade_at, WOOD[1])
            bx, by = blade_at
            for dx in range(-2, 3):                       # a broad flat blade, 5 wide, its lip darker
                for dy in (-1, 0, 1):
                    if abs(dx) == 2 and dy == -1:
                        continue
                    item[(bx + dx, by + dy)] = STEEL[1] if dy < 1 else STEEL[0]
            if f in (1, 2):                               # snow on the blade
                item[(bx, by - 2)] = SNOW[1]; item[(bx - 1, by - 2)] = SNOW[0]; item[(bx + 1, by - 2)] = SNOW[0]
            a = pg.draw_arm(body, bm, (front - fwd * 2, bm.sh + 2), hand, item=item)
            if f == 3:                                    # the throw: a puff off to the side
                a = pg.stamp(a, {(bx + fwd * 2, by - 3): SNOW[1], (bx + fwd * 3, by - 2): SNOW[0],
                                 (bx + fwd * 1, by - 4): SNOW[1], (bx + fwd * 4, by - 4): SNOW[0]})
            frames.append(a)
        out.append(frames)
    return out

# --- A-09 fishing at an ice hole ----------------------------------------------------------------------------------
def fish(sheet):
    out = []
    for r in range(4):
        fr = pg.cell(sheet, r)
        m = pg.Marks(fr)
        sat = pg.kneel(fr, m, 4)
        sm = pg.Marks(sat)
        fwd = {0: 1, 1: -1, 2: 1, 3: 1}[r]
        frames = []
        for f in range(4):
            front = side_front(sat, sm, fwd) if r in (1, 2) else sm.R
            hand = (front + fwd * 2, sm.sh + 3)
            bob = (0, 1, 0, 2)[f]
            tip = (hand[0] + fwd * 9, hand[1] - 7 + (bob > 1))
            hole_x = tip[0]
            item = line_pts(hand, tip, WOOD[0])
            for y in range(tip[1] + 1, sm.bot - 1 + bob // 2):
                item[(tip[0], y)] = (210, 214, 224)       # the line, down into the hole
            img = pg.draw_arm(sat, sm, (front - fwd * 2, sm.sh + 2), hand, item=item)
            hole = {}
            for dx in range(-3, 4):
                for dy in (0, 1):
                    if abs(dx) < 3 or dy == 0:
                        hole[(hole_x + dx, sm.bot - 1 + dy)] = HOLE[0] if abs(dx) < 2 else HOLE[1]
            if f == 3:                                    # a ripple
                hole[(hole_x - 2, sm.bot - 1)] = HOLE[2]; hole[(hole_x + 2, sm.bot - 1)] = HOLE[2]
            img2 = pg.stamp(Image.new("RGBA", (N, N), (0, 0, 0, 0)), hole)
            img2.alpha_composite(img)
            frames.append(img2)
        out.append(frames)
    return out

JOBS = {"FT_town_warm_a": ("BW (72)", warm), "FT_town_warm_b": ("BW (62)", warm),
        "FT_town_shovel": ("BW (75)", shovel), "FT_town_fish_a": ("BW (54)", fish), "FT_town_fish_b": ("BW (40)", fish)}

def main():
    args = sys.argv[1:]
    out = args[args.index("--out") + 1] if "--out" in args else "build/Characters"
    prev = args[args.index("--preview") + 1] if "--preview" in args else None
    os.makedirs(out, exist_ok=True)
    sheets = []
    for name, (src, fn) in JOBS.items():
        sheets.append(pg.save_sheet(fn(base(src)), os.path.join(out, name + ".png")))
        print(name)
    b = brazier()
    b.resize((N * 8, N * 8), Image.NEAREST).save(os.path.join(out, "FT_prop_brazier.png"))
    sheets.append(b)
    print("FT_prop_brazier")
    if prev:
        pv = Image.new("RGBA", (N * 4 * 2 + 8, (N * 4 + 8) * ((len(sheets) + 1) // 2)), (196, 206, 216, 255))
        for i, sh in enumerate(sheets):
            pv.alpha_composite(sh, ((i % 2) * (N * 4 + 8), (i // 2) * (N * 4 + 8)))
        pv.resize((pv.width * 2, pv.height * 2), Image.NEAREST).save(prev)

if __name__ == "__main__":
    main()
