#!/usr/bin/env python3
"""Cutscene poses and variant sprites, derived from each character's installed walking sheet (2026-11-09).

The P-* pose sheets were drawn on the retired chibi template, so they no longer matched the rebuilt cast. Every pose
here is made from the character's own sheet: the same pixels, palette and outline, rearranged (rows taken out of
the legs to kneel, the figure turned to lie down, the arms redrawn in the sheet's own sleeve and skin colours with
the base game's black outline), so a pose can never drift off model.

    python3 tools/posegen.py [--out build/Characters] [--preview OUT.png] [IDS...]

A sheet is 320x320: 4 rows (facing down, left, right, up) x 4 frames, each 40x40 native drawn at 2x.
Pose frames (the code picks rows and frames; see 024 HERALD_SHEET and each Stage.pose call):
  -01 kneel     0 stand, 1 crouch, 2 kneel, 3 kneel with head bowed
  -02 reach     0 stand, 1 arm half up, 2 and 3 arm up (row 3, back to camera, is the one used)
  -03 down      0 stand, 1 stagger, 2 on the knees, 3 lying (Alerion plays it 3-2-1-0 to get up)
Specials: ALB-04 clutches the rune (it glows on 3), SHA-02 holds out the horn (it glows on 3), SHI-02 arms out with
the hair blowing, SHI-03 lying bound in ice cords, SHI-04 an ice statue, SEP-02 kneels as ice climbs him, AUR-04
dissolves into frost, REP-04 elf / half wolf / wolf / an elf again on his knees, REP-05 the wolf flashes and is
caught, REP-06 held to the knees in frost (the wolf tugged at), SEP-05 misty step (frost swirls up, he's gone; played
back to reappear), SEP-06 the second voice (head tilts, frost-light in the eyes), THR-02 Thredra leaps, THR-04 her
lunge with the black ice knife, THR-03 sat on her staff
rising, THR-05 three of her. GHO-01 the Order's ghost rises out of her body on the bier, GHO-02 lies back into it and
the body ages to dust.
Variants: FT_alberica_rune (the rune glowing on her chest), FT_sephek_frozen (in ice), FT_var_cracked (glass
cracks), FT_thredra_echo (a spectral reflection)."""
import os, sys, random
from collections import Counter
from PIL import Image

D = "build/Characters/"
N = 40                                              # native cell
BLACK = (0, 0, 0, 255)
ICE = [(28, 52, 92), (58, 102, 156), (104, 156, 208), (166, 208, 240), (226, 242, 255)]
SPECTRE = [(40, 30, 64), (78, 62, 118), (124, 106, 168), (176, 160, 214), (226, 218, 246)]
RUNE = [(90, 190, 240), (210, 246, 255)]


# --- sheet and frame helpers ------------------------------------------------------------------------------------
def load(name):
    return Image.open(D + name + ".png").convert("RGBA").resize((N * 4, N * 4), Image.NEAREST)

def cell(sheet, row, col=0):
    return sheet.crop((col * N, row * N, col * N + N, row * N + N))

def save_sheet(rows, path):
    out = Image.new("RGBA", (N * 4, N * 4), (0, 0, 0, 0))
    for r, frames in enumerate(rows):
        for c, fr in enumerate(frames):
            out.alpha_composite(fr, (c * N, r * N))
    out.resize((N * 8, N * 8), Image.NEAREST).save(path)
    return out

def opaque(fr, x, y):
    return 0 <= x < N and 0 <= y < N and fr.getpixel((x, y))[3] > 0

def is_outline(p):
    return p[3] and max(p[:3]) < 40

def bounds(fr):
    return fr.getbbox()

def widths(fr):
    out = {}
    for y in range(N):
        xs = [x for x in range(N) if opaque(fr, x, y)]
        if xs:
            out[y] = (min(xs), max(xs))
    return out


class Marks:
    """Landmarks of a standing frame: top, feet, neck, shoulders, the arms' columns and colours."""
    def __init__(self, fr):
        x0, y0, x1, y1 = bounds(fr)
        self.top, self.bot = y0, y1 - 1                 # first and last opaque rows
        w = widths(fr)
        h = self.bot - self.top
        self.neck = self.top + round(h * 0.55)          # the base game's chibi: the head is a little over half
        self.sh = self.neck + 1                          # first torso row
        self.cx = (x0 + x1 - 1) / 2
        rows = range(self.sh + 2, self.bot - 4)
        self.L = min(w[y][0] for y in rows)
        self.R = max(w[y][1] for y in rows)
        self.head_L = min(w[y][0] for y in range(self.top, self.neck))
        self.head_R = max(w[y][1] for y in range(self.top, self.neck))
        px = fr.load()
        arm = Counter()
        hand = Counter()
        for y in rows:
            for x in (self.L + 1, self.L + 2, self.R - 1, self.R - 2):
                p = px[x, y]
                if p[3] and max(p[:3]) >= 90:            # not the outline nor its dark shading tones
                    (hand if y >= self.bot - 7 else arm)[p[:3]] += 1
        self.sleeve = (arm.most_common(1) or hand.most_common(1))[0][0]
        # the hand is the lightest colour in the arms' last rows (skin), else the sleeve
        self.hand = max(hand, key=lambda c: sum(c)) if hand else self.sleeve


# --- operations on one 40x40 frame ------------------------------------------------------------------------------
def drop_rows(fr, rows):
    """Take rows out (the legs): everything above them moves down, the feet stay."""
    rows = sorted(set(rows))
    src = [y for y in range(N) if y not in rows]
    out = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    k = len(rows)
    for i, y in enumerate(src):
        out.paste(fr.crop((0, y, N, y + 1)), (0, i + k))
    return out

def kneel(fr, m, k):
    legs = list(range(m.bot - 1 - k, m.bot - 1))        # shins, just above the feet
    out = drop_rows(fr, legs)
    return spread(out, m) if k >= 3 else out

def spread(fr, m):
    """Knees out: the last three rows' halves pushed one pixel apart, so a kneel reads wider at the base."""
    out = fr.copy()
    cx = int(round(m.cx))
    for y in range(m.bot - 2, m.bot + 1):
        left = fr.crop((0, y, cx, y + 1))
        right = fr.crop((cx, y, N, y + 1))
        out.paste(Image.new("RGBA", (N, 1), (0, 0, 0, 0)), (0, y))
        out.paste(left, (-1, y))
        out.paste(right, (cx + 1, y))
        px = out.load()
        if px[cx - 1, y][3] and px[cx + 1, y][3]:     # close the gap the push opened
            px[cx, y] = BLACK
    return out

def bow(fr, m, k):
    """Head down one pixel over the shoulders (drawn on top)."""
    out = fr.copy()
    head = fr.crop((0, 0, N, m.neck + k + 1))
    clear = Image.new("RGBA", (N, 1), (0, 0, 0, 0))
    out.paste(clear, (0, m.top + k))                     # the top row it leaves behind
    out.alpha_composite(head.crop((0, m.top + k, N, m.neck + k + 1)), (0, m.top + k + 1))
    return out

def lie(fr, m, ccw=True):
    """The figure turned to lie on the ground, its back on the feet line."""
    fig = fr.crop(bounds(fr))
    fig = fig.transpose(Image.ROTATE_90 if ccw else Image.ROTATE_270)
    out = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    x = int(round(m.cx - fig.width / 2))
    out.alpha_composite(fig, (max(0, min(N - fig.width, x)), m.bot + 1 - fig.height))
    return out

def shift_x(fr, dx):
    out = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    out.alpha_composite(fr, (dx, 0)) if dx >= 0 else out.alpha_composite(fr.crop((-dx, 0, N, N)), (0, 0))
    return out

def erase_arm(fr, m, side):
    """Take out one hanging arm (front and back views): its columns from the shoulder down; the body's edge gets
    the outline back."""
    out = fr.copy()
    px = out.load()
    for y in range(m.sh + 2, m.bot - 3):
        xs = [x for x in range(N) if px[x, y][3]]
        if not xs:
            continue
        if side == "L":
            edge = min(xs)
            for x in range(edge, edge + 3):
                px[x, y] = (0, 0, 0, 0)
            if px[edge + 3, y][3]:
                px[edge + 3, y] = BLACK
        else:
            edge = max(xs)
            for x in range(edge - 2, edge + 1):
                px[x, y] = (0, 0, 0, 0)
            if px[edge - 3, y][3]:
                px[edge - 3, y] = BLACK
    return out

def line(a, b):
    (x0, y0), (x1, y1) = a, b
    n = max(abs(x1 - x0), abs(y1 - y0), 1)
    return [(round(x0 + (x1 - x0) * i / n), round(y0 + (y1 - y0) * i / n)) for i in range(n + 1)]

def draw_arm(fr, m, start, end, hand=True, item=None, via=None):
    """An arm 2 px thick in the sheet's sleeve colour from the shoulder to the hand, a 2x2 hand in skin, the
    game's black outline round it (over the body too, so it reads in front). item: extra pixels {(x, y): rgb}."""
    out = fr.copy()
    px = out.load()
    mask = {}
    pts = line(start, via) + line(via, end) if via else line(start, end)
    for (x, y) in pts:
        for dx in (0, 1):
            mask[(x + dx, y)] = m.sleeve
    if hand:
        ex, ey = end
        for dx in (0, 1):
            for dy in (0, 1):
                mask[(ex + dx, ey + dy)] = m.hand
    if item:
        mask.update(item)
    for (x, y) in list(mask):
        for nx, ny in ((x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)):
            if (nx, ny) not in mask and 0 <= nx < N and 0 <= ny < N:
                px[nx, ny] = BLACK
    for (x, y), c in mask.items():
        if 0 <= x < N and 0 <= y < N:
            px[x, y] = c + (255,)
    return out

def recolour_ramp(fr, ramp, below=None, outline=None):
    """Each colour to a ramp by lightness (the sheet's shading kept); rows from `below` down only."""
    out = fr.copy()
    px = out.load()
    for y in range(N):
        if below is not None and y < below:
            continue
        for x in range(N):
            p = px[x, y]
            if not p[3]:
                continue
            if is_outline(p):
                if outline:
                    px[x, y] = outline + (255,)
                continue
            lum = (p[0] * 3 + p[1] * 6 + p[2]) / 10
            i = min(len(ramp) - 1, int(lum / 256 * len(ramp) + 0.35))
            px[x, y] = ramp[i] + (255,)
    return out

def ring(fr, colour):
    """A 1 px ring outside the figure (a crystal's edge)."""
    out = fr.copy()
    px = out.load()
    src = fr.load()
    for y in range(N):
        for x in range(N):
            if src[x, y][3]:
                continue
            if any(0 <= x + dx < N and 0 <= y + dy < N and src[x + dx, y + dy][3]
                   for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))):
                px[x, y] = colour + (255,)
    return out

def stamp(fr, pts):
    out = fr.copy()
    px = out.load()
    for (x, y), c in pts.items():
        if 0 <= x < N and 0 <= y < N:
            px[x, y] = c + (255,)
    return out


# --- poses --------------------------------------------------------------------------------------------------------
def rows_of(sheet):
    return [cell(sheet, r) for r in range(4)]

def p_kneel(sheet):
    out = []
    for fr in rows_of(sheet):
        m = Marks(fr)
        k2 = kneel(fr, m, 2)
        k4 = kneel(fr, m, 4)
        m4 = Marks(k4)
        out.append([fr, k2, k4, bow(k4, m4, 0)])
    return out

def reach_frames(fr, m, row):
    if row in (0, 3):
        side = "R" if row == 3 else "L"
        body = erase_arm(fr, m, side)
        mid = (m.top + m.neck) // 2                      # ear height: a chibi arm is short
        if side == "R":
            sx, sy = m.R - 2, m.sh + 1
            half = draw_arm(body, m, (sx, sy), (m.R + 1, m.sh - 2))
            up = draw_arm(body, m, (sx, sy), (m.head_R, mid))
        else:
            sx, sy = m.L + 1, m.sh + 1
            half = draw_arm(body, m, (sx, sy), (m.L - 2, m.sh - 2))
            up = draw_arm(body, m, (sx, sy), (m.head_L - 1, mid))
        return [fr, half, up, up]
    # side views: the near arm out in front, from the torso's front edge (never across the face)
    fwd = 1 if row == 2 else -1
    w = widths(fr)
    front = max(w[y][1] for y in range(m.sh + 1, m.sh + 4)) if fwd > 0 else min(w[y][0] for y in range(m.sh + 1, m.sh + 4))
    sx = front - fwd * 2
    half = draw_arm(fr, m, (sx, m.sh + 3), (front + fwd * 3, m.sh + 3))
    up = draw_arm(fr, m, (sx, m.sh + 3), (front + fwd * 3, m.sh))
    return [fr, half, up, up]

def p_reach(sheet):
    return [reach_frames(fr, Marks(fr), r) for r, fr in enumerate(rows_of(sheet))]

def p_down(sheet):
    out = []
    for r, fr in enumerate(rows_of(sheet)):
        m = Marks(fr)
        stagger = shift_x(kneel(fr, m, 1), 1 if r != 1 else -1)
        knees = kneel(fr, m, 4)
        out.append([fr, stagger, knees, lie(fr, m, ccw=(r != 2))])
    return out

def clutch(fr, m, glow=False):
    body = erase_arm(erase_arm(fr, m, "L"), m, "R")
    cy = m.sh + 3
    cx = int(m.cx)
    elbow = m.sh + 4                                     # down from the shoulder, then in to the chest
    a = draw_arm(body, m, (m.L + 2, m.sh + 1), (cx - 2, cy), via=(m.L + 2, elbow))
    a = draw_arm(a, m, (m.R - 3, m.sh + 1), (cx, cy), via=(m.R - 3, elbow))
    if glow:
        a = stamp(a, {(cx - 1, cy - 1): RUNE[1], (cx, cy - 1): RUNE[0], (cx - 2, cy - 1): RUNE[0],
                      (cx - 1, cy - 2): RUNE[0]})
    return a

def p_alb04(sheet):
    out = []
    for r, fr in enumerate(rows_of(sheet)):
        m = Marks(fr)
        if r == 0:
            c = clutch(fr, m)
            out.append([fr, c, kneel(c, m, 3), kneel(clutch(fr, m, glow=True), m, 3)])
        else:
            k = kneel(fr, m, 3)
            out.append([fr, kneel(fr, m, 1), k, bow(k, Marks(k), 0)])
    return out

def horn(x, y, glow):
    c0, c1 = ((120, 220, 140), (220, 255, 224)) if glow else ((206, 200, 184), (250, 248, 238))
    return {(x, y): c1, (x + 1, y - 1): c1, (x + 2, y - 2): c0, (x + 3, y - 3): c0}

def p_sha02(sheet):
    out = []
    for r, fr in enumerate(rows_of(sheet)):
        m = Marks(fr)
        if r == 0:
            body = erase_arm(fr, m, "R")
            end = (int(m.cx) + 1, m.sh + 5)
            f1 = draw_arm(body, m, (m.R - 2, m.sh + 2), end, item=horn(end[0] + 2, end[1], False))
            f2 = draw_arm(body, m, (m.R - 2, m.sh + 2), (end[0] + 1, end[1] + 1), item=horn(end[0] + 3, end[1] + 1, False))
            f3 = draw_arm(body, m, (m.R - 2, m.sh + 2), (end[0] + 1, end[1] + 1), item=horn(end[0] + 3, end[1] + 1, True))
            out.append([fr, f1, f2, f3])
        elif r == 3:
            body = erase_arm(fr, m, "R")
            end = (m.R, m.sh - 3)
            f1 = draw_arm(body, m, (m.R - 2, m.sh + 2), end, item=horn(end[0] + 1, end[1] - 1, False))
            f3 = draw_arm(body, m, (m.R - 2, m.sh + 2), end, item=horn(end[0] + 1, end[1] - 1, True))
            out.append([fr, f1, f1, f3])
        else:
            rr = reach_frames(fr, m, r)
            out.append(rr)
    return out

def flutter(fr, m, d):
    """Hair blowing: the head's outer edge pulled one pixel downwind, rows alternating."""
    out = fr.copy()
    px = out.load()
    src = fr.load()
    for y in range(m.top + 2, m.neck):
        if (y + (d > 0)) % 2:
            continue
        xs = [x for x in range(N) if src[x, y][3]]
        if not xs:
            continue
        if d < 0:
            e = min(xs)
            if e - 1 >= 0:
                px[e - 1, y] = src[e, y]
                px[e, y] = src[e + 1, y]
        else:
            e = max(xs)
            if e + 1 < N:
                px[e + 1, y] = src[e, y]
                px[e, y] = src[e - 1, y]
    return out

def p_shi02(sheet):
    out = []
    for r, fr in enumerate(rows_of(sheet)):
        m = Marks(fr)
        if r in (0, 3):
            body = erase_arm(erase_arm(fr, m, "L"), m, "R")
            y = m.sh + 2
            a = draw_arm(draw_arm(body, m, (m.L + 1, y), (m.L - 4, y + 1)), m, (m.R - 2, y), (m.R + 3, y + 1))
            b = draw_arm(draw_arm(body, m, (m.L + 1, y), (m.L - 4, y - 1)), m, (m.R - 2, y), (m.R + 3, y - 1))
            out.append([a, flutter(b, m, -1), a, flutter(b, m, 1)])
        else:
            out.append([fr, flutter(fr, m, -1), fr, flutter(fr, m, 1)])
    return out

def cords(fr):
    """Two bands of living ice across a lying figure."""
    x0, y0, x1, y1 = bounds(fr)
    pts = {}
    for cx in (x0 + (x1 - x0) // 3, x0 + 2 * (x1 - x0) // 3):
        ys = [y for y in range(N) if fr.getpixel((cx, y))[3] or fr.getpixel((cx + 1, y))[3]]
        for y in range(min(ys), max(ys) + 1):          # over the body only, edge to edge
            pts[(cx, y)] = ICE[3]
            pts[(cx + 1, y)] = ICE[2]
    return stamp(fr, pts)

def p_shi03(sheet):
    fr = cell(sheet, 0)
    m = Marks(fr)
    lying = cords(lie(fr, m))
    x0, y0, x1, y1 = bounds(lying)
    glint = stamp(lying, {(x0 + (x1 - x0) // 3, y0): ICE[4]})
    return [[lying, glint, lying, glint] for _ in range(4)]

def p_shi04(sheet):
    out = []
    for fr in rows_of(sheet):
        s = recolour_ramp(fr, ICE, outline=ICE[0])
        out.append([s, s, s, s])
    return out

def p_sep02(sheet):
    out = []
    for fr in rows_of(sheet):
        m = Marks(fr)
        k = kneel(fr, m, 4)
        km = Marks(k)
        h = km.bot - km.top
        f1 = recolour_ramp(k, ICE, below=km.bot - h // 3)
        f2 = recolour_ramp(k, ICE, below=km.bot - 2 * h // 3)
        f3 = ring(recolour_ramp(k, ICE, outline=ICE[0]), ICE[3])
        out.append([k, f1, f2, f3])
    return out

def p_aur04(sheet):
    out = []
    for r, fr in enumerate(rows_of(sheet)):
        rnd = random.Random(40 + r)
        x0, y0, x1, y1 = bounds(fr)
        pix = [(x, y) for y in range(y0, y1) for x in range(x0, x1) if fr.getpixel((x, y))[3]]
        def frost(share, gone, flakes):
            f = fr.copy()
            px = f.load()
            for (x, y) in pix:
                t = rnd.random() + (y1 - y) / (y1 - y0) * 0.25        # the top goes first
                if t < gone:
                    px[x, y] = (0, 0, 0, 0)
                elif t < gone + share:
                    px[x, y] = (ICE[4] if rnd.random() < 0.5 else ICE[3]) + (255,)
            for _ in range(flakes):
                x, y = rnd.randrange(x0 - 3, x1 + 3), rnd.randrange(max(0, y0 - 6), y1)
                if 0 <= x < N and not px[x, y][3]:
                    px[x, y] = ICE[4] + (255,)
            return f
        out.append([fr, frost(0.35, 0.0, 4), frost(0.45, 0.55, 10), frost(0.1, 1.1, 14)])
    return out

def p_rep04(sheet, wolf):
    out = []
    for r in range(4):
        elf, wf = cell(sheet, r), cell(wolf, r)
        m = Marks(elf)
        half = elf.copy()                                   # the wolf flickering through: his top half goes wolf
        half.paste(Image.new("RGBA", (N, m.neck + 2), (0, 0, 0, 0)), (0, 0))
        top = wf.crop((0, 0, N, m.neck + 2))
        half.alpha_composite(top, (0, 0))
        k = kneel(elf, m, 4)
        out.append([elf, half, wf, bow(k, Marks(k), 0)])
    return out


def p_rep05(sheet, wolf):
    out = []
    for r in range(4):
        elf, wf = cell(sheet, r), cell(wolf, r)
        m = Marks(elf)
        half = elf.copy()
        half.paste(Image.new("RGBA", (N, m.neck + 2), (0, 0, 0, 0)), (0, 0))
        half.alpha_composite(wf.crop((0, 0, N, m.neck + 2)), (0, 0))
        if r in (1, 2):                                   # side on, a wolf's head on him doesn't read: the wolf
            half = wf
        caught = kneel(elf, m, 1)
        out.append([elf, half, caught, caught])
    return out

def p_rep06(sheet, wolf):
    out = []
    for r in range(4):
        elf, wf = cell(sheet, r), cell(wolf, r)
        m = Marks(elf)
        k = kneel(elf, m, 4)
        km = Marks(k)
        held = recolour_ramp(k, ICE, below=km.bot - (km.bot - km.top) // 3)
        half = k.copy()
        half.paste(Image.new("RGBA", (N, km.neck + 2), (0, 0, 0, 0)), (0, 0))
        half.alpha_composite(shift_down(wf, 4).crop((0, 0, N, km.neck + 2)), (0, 0))
        half = recolour_ramp(half, ICE, below=km.bot - (km.bot - km.top) // 3)
        if r in (1, 2):
            half = held
        out.append([held, half, held, half])
    return out

def shift_down(fr, k):
    out = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    out.alpha_composite(fr.crop((0, 0, N, N - k)), (0, k))
    return out

def shift_up(fr, k):
    out = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    out.alpha_composite(fr.crop((0, k, N, N)), (0, 0))
    return out

def mist(fr, seed):
    """Frost swirls up round him and he's gone: 0 him, 1 frosting over, 2 mostly gone, 3 flakes."""
    rnd = random.Random(seed)
    x0, y0, x1, y1 = bounds(fr)
    pix = [(x, y) for y in range(y0, y1) for x in range(x0, x1) if fr.getpixel((x, y))[3]]
    def step(share, gone, flakes):
        f = fr.copy()
        px = f.load()
        for (x, y) in pix:
            t = rnd.random() + (y - y0) / (y1 - y0) * 0.25          # swirls up from the feet
            if t < gone:
                px[x, y] = (0, 0, 0, 0)
            elif t < gone + share:
                px[x, y] = (ICE[4] if rnd.random() < 0.5 else ICE[3]) + (255,)
        for _ in range(flakes):
            x, y = rnd.randrange(x0 - 4, x1 + 4), rnd.randrange(max(0, y0 - 4), y1)
            if 0 <= x < N and not px[x, y][3]:
                px[x, y] = ICE[4] + (255,)
        return f
    return [fr, step(0.4, 0.0, 6), step(0.4, 0.6, 12), step(0.05, 1.2, 16)]

def p_sep05(sheet):
    return [mist(cell(sheet, r), 50 + r) for r in range(4)]

def eyes(fr, m):
    """The eye pixels: dark, inside the face (not on its edge), in the head's lower half."""
    px = fr.load()
    out = []
    for y in range(m.top + (m.neck - m.top) // 2, m.neck):
        for x in range(N):
            p = px[x, y]
            if not p[3] or max(p[:3]) >= 90:
                continue
            if all(px[x + dx, y][3] and max(px[x + dx, y][:3]) >= 120 for dx in (-2, 2)) and abs(x - m.cx) <= 6:
                out.append((x, y))
    return out

def p_sep06(sheet):
    out = []
    for r in range(4):
        fr = cell(sheet, r)
        m = Marks(fr)
        tilt = fr.copy()                                  # the head tips one pixel aside
        head = fr.crop((0, 0, N, m.neck + 1))
        tilt.paste(Image.new("RGBA", (N, m.neck + 1), (0, 0, 0, 0)), (0, 0))
        tilt.alpha_composite(head, (1, 0))
        tilt.alpha_composite(fr.crop((0, m.neck + 1, N, N)), (0, m.neck + 1))
        # frost-light behind the eyes: his pale eye pixels go a glowing cyan (Sephek's eyes are already pale)
        px = fr.load()
        glow = {(x + 1, y): RUNE[0] for y in range(m.neck - 6, m.neck - 3) for x in range(N)
                if px[x, y][3] and min(px[x, y][:3]) >= 225 and abs(x - m.cx) <= 6}
        lit = stamp(tilt, glow) if r != 3 else tilt
        out.append([tilt, lit, tilt, lit])
    return out

def p_leap(sheet):
    out = []
    for r in range(4):
        fr = cell(sheet, r)
        m = Marks(fr)
        out.append([kneel(fr, m, 2), shift_up(fr, 3), shift_up(fr, 6), shift_up(fr, 8)])
    return out

def p_lunge(sheet):
    out = []
    knife = (40, 50, 90)
    for r in range(4):
        fr = cell(sheet, r)
        m = Marks(fr)
        fwd = {0: 0, 1: -1, 2: 1, 3: 0}[r]
        crouch = kneel(fr, m, 2)
        lean = shift_x(kneel(fr, m, 1), fwd * 2)
        lm = Marks(lean)
        w = widths(lean)
        if fwd:
            front = max(w[y][1] for y in range(lm.sh + 1, lm.sh + 4)) if fwd > 0 else min(w[y][0] for y in range(lm.sh + 1, lm.sh + 4))
            end = (front + fwd * 4, lm.sh + 2)
            blade = {(end[0] + fwd * (2 + i), end[1] - i // 2): (knife if i < 2 else ICE[2]) for i in range(3)}
            lunge = draw_arm(shift_x(lean, fwd * 2), lm, (front - fwd, lm.sh + 2), end, item=blade)
        else:
            lunge = shift_down(lean, 1)
        out.append([crouch, lean, lunge, lunge])
    return out


# --- the Order's ghost (Ch5: Alberica's own ghost, old, in the Order's green) and Thredra's battle tricks -------------
MINT = [(30, 74, 66), (62, 138, 116), (118, 204, 170), (188, 246, 214), (232, 255, 242)]

def alpha(fr, a):
    out = fr.copy()
    px = out.load()
    for y in range(N):
        for x in range(N):
            if px[x, y][3]:
                px[x, y] = px[x, y][:3] + (min(px[x, y][3], a),)
    return out

def clip_below(fr, y0):
    out = fr.copy()
    px = out.load()
    for y in range(max(0, y0), N):
        for x in range(N):
            px[x, y] = (0, 0, 0, 0)
    return out

def ghost_scene(sheet):
    """The body laid on the bier (her own sheet turned to lie), the spirit (the same figure in mint, see-through)."""
    fr = cell(sheet, 0)
    side = cell(sheet, 2)                                   # laid on her back: the profile turned, face up
    body = lie(side, Marks(side), ccw=True)
    spirit = recolour_ramp(fr, MINT, outline=MINT[0])
    bx0, by0, bx1, by1 = bounds(body)
    return body, spirit, (by0 + by1) // 2

def rising(body, spirit, mid, k, a=180):
    """The spirit k pixels up out of the body (its lower part hidden in the body), behind nothing."""
    out = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    sx0, sy0, sx1, sy1 = bounds(spirit)
    up = sy0 - mid + k                                      # k = 0: the spirit's head at the body's middle line
    s = shift_up(spirit, up) if up > 0 else shift_down(spirit, -up)
    out.alpha_composite(body)
    out.alpha_composite(alpha(clip_below(s, mid), a))
    return out

def p_gho01(sheet):
    """The body on the bier, then the spirit rising out of it and standing clear (the ghost actor takes over)."""
    body, spirit, mid = ghost_scene(sheet)
    sx0, sy0, sx1, sy1 = bounds(spirit)
    h = sy1 - sy0
    row = [body, rising(body, spirit, mid, h // 3 + 2), rising(body, spirit, mid, h * 2 // 3 + 2), rising(body, spirit, mid, h + 2)]
    return [row] * 4

def aged(fr, seed, dust=0.0):
    """Skin to parchment, robes to grey; with dust, most of it gone and the rest settled."""
    rnd = random.Random(seed)
    out = recolour_ramp(fr, [(70, 64, 58), (118, 108, 96), (166, 154, 136), (206, 196, 176), (232, 224, 208)],
                        outline=(48, 42, 38))
    if dust:
        px = out.load()
        for y in range(N):
            for x in range(N):
                if px[x, y][3] and rnd.random() < dust:
                    px[x, y] = (0, 0, 0, 0)
        out = shift_down(out, 1)
    return out

def p_gho02(sheet):
    """The spirit lies back down into the body; the body ages to parchment, then dust."""
    body, spirit, mid = ghost_scene(sheet)
    sx0, sy0, sx1, sy1 = bounds(spirit)
    h = sy1 - sy0
    row = [rising(body, spirit, mid, h // 2 + 2, 150), rising(body, spirit, mid, h // 5, 90), aged(body, 7), aged(body, 7, 0.7)]
    return [row] * 4

STAFF = (84, 87, 99)

def no_staff(fr):
    """Thredra without her staff: its colour gone, and the outline left standing on its own beside it."""
    out = fr.copy()
    px = out.load()
    for y in range(N):
        for x in range(N):
            if px[x, y][3] and px[x, y][:3] == STAFF:
                px[x, y] = (0, 0, 0, 0)
    for _ in range(2):
        for y in range(N):
            for x in range(N):
                if px[x, y][3] and is_outline(px[x, y]):
                    near = [px[x + dx, y + dy] for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))
                            if 0 <= x + dx < N and 0 <= y + dy < N]
                    if not any(q[3] and not is_outline(q) for q in near):
                        px[x, y] = (0, 0, 0, 0)
    return out

def staff_across(fr, y, x0, x1, hook_left=True):
    """Her black staff laid across under her, two pixels thick and outlined, its hook curling up at one end."""
    pts = {}
    for x in range(x0, x1 + 1):
        pts[(x, y)] = STAFF; pts[(x, y + 1)] = (58, 60, 70)
    hx = x0 if hook_left else x1
    d = -1 if hook_left else 1
    for i, (dx, dy) in enumerate(((0, -1), (0, -2), (-d, -3), (-2 * d, -3))):
        pts[(hx + dx, y + dy)] = STAFF
    out = fr.copy()
    px = out.load()
    for (x, yy) in pts:
        for ex, ey in ((1, 0), (-1, 0), (0, 1), (0, -1)):
            q = (x + ex, yy + ey)
            if q not in pts and 0 <= q[0] < N and 0 <= q[1] < N and not px[q][3]:
                px[q] = BLACK
    for (x, yy), c in pts.items():
        if 0 <= x < N and 0 <= yy < N:
            px[x, yy] = c + (255,)
    return out

def p_thr03(sheet):
    """Thredra seats herself on her staff and rises: sat, then up 3, 6 and 9 pixels."""
    out = []
    for r in range(4):
        fr = no_staff(cell(sheet, r))
        m = Marks(fr)
        sat = kneel(fr, m, 4)
        sm = Marks(sat)
        x0, y0, x1, y1 = bounds(sat)
        seat = staff_across(sat, y1 - 5, max(1, x0 - 5), min(N - 2, x1 + 4), hook_left=(r != 2))
        seat = shift_up(seat, 2)
        out.append([seat, shift_up(seat, 3), shift_up(seat, 6), shift_up(seat, 9)])
    return out

def p_thr05(sheet):
    """There are three of her: one, then two spectral copies flicker out to either side (behind her), and shimmer."""
    out = []
    for r in range(4):
        fr = cell(sheet, r)
        echo = recolour_ramp(fr, SPECTRE, outline=SPECTRE[0])
        frames = []
        for f, (d, a) in enumerate(((0, 0), (11, 200), (12, 140), (11, 200))):
            im = Image.new("RGBA", (N, N), (0, 0, 0, 0))
            if d:
                im.alpha_composite(alpha(shift_x(echo, -d), a))
                im.alpha_composite(alpha(shift_x(echo, d), a))
            im.alpha_composite(fr)
            frames.append(im)
        out.append(frames)
    return out


# --- variants (walking sheets) ------------------------------------------------------------------------------------
OLD_ALB = {(189, 73, 50): (196, 192, 206), (116, 42, 45): (128, 124, 142),      # the red braids gone white
           (121, 73, 166): (124, 102, 150),                                    # the cap, faded
           (229, 110, 22): (196, 128, 82), (255, 242, 227): (234, 224, 206)}   # the tunic, worn

def v_alberica_old(sheet):
    """Alberica many years later (Ch13's coda): her own sprite, so she's still beardless and still herself, with the
    braids gone white and the cap and tunic faded. Replaces the batch-04 sheet, which had a different face and a
    grey chin that read as a beard."""
    out = []
    for r in range(4):
        frames = []
        for c in range(4):
            fr = cell(sheet, r, c).copy()
            px = fr.load()
            for y in range(fr.height):
                for x in range(fr.width):
                    p = px[x, y]
                    if p[3] and p[:3] in OLD_ALB:
                        px[x, y] = OLD_ALB[p[:3]] + (p[3],)
            frames.append(fr)
        out.append(frames)
    return out

def close_light_edges(path):
    """White hair vanishes against snow: outline its bare edges (tools/sprite_audit.py's fix, light colours only)."""
    import sprite_audit
    sprite_audit.fix(path, path, 150)

def v_alberica_rune(sheet):
    out = []
    for r in range(4):
        frames = []
        for c in range(4):
            fr = cell(sheet, r, c)
            m = Marks(fr)
            cx, cy = int(m.cx), m.sh + 2
            if r == 0:
                fr = stamp(fr, {(cx, cy): RUNE[1], (cx - 1, cy): RUNE[0], (cx + 1, cy): RUNE[0],
                                (cx, cy - 1): RUNE[0], (cx, cy + 1): RUNE[0]})
            elif r in (1, 2):
                x = cx + (2 if r == 2 else -2)
                fr = stamp(fr, {(x, cy): RUNE[1], (x, cy + 1): RUNE[0]})
            frames.append(fr)
        out.append(frames)
    return out

def v_sephek_frozen(sheet):
    return [[ring(recolour_ramp(cell(sheet, r, c), ICE, outline=ICE[0]), ICE[3]) if c == 0 else
             ring(recolour_ramp(cell(sheet, r, 0), ICE, outline=ICE[0]), ICE[3]) for c in range(4)] for r in range(4)]

def v_var_cracked(sheet):
    out = []
    for r in range(4):
        frames = []
        for c in range(4):
            fr = cell(sheet, r, c)
            m = Marks(fr)
            rnd = random.Random(7 + r)                      # the same cracks on every frame of a row
            pts = {}
            x, y = int(m.cx) + rnd.choice((-3, 2)), m.top + 3
            for _ in range(m.bot - m.top - 4):
                if fr.getpixel((x, y))[3] and not is_outline(fr.getpixel((x, y))):
                    pts[(x, y)] = (236, 246, 255)
                y += 1
                x += rnd.choice((-1, 0, 0, 1))
            frames.append(stamp(fr, pts))
        out.append(frames)
    return out

def v_thredra_echo(sheet):
    return [[recolour_ramp(cell(sheet, r, c), SPECTRE, outline=SPECTRE[0]) for c in range(4)] for r in range(4)]


HERALDS = {"ALB": "FT_alberica", "REP": "FT_reptin", "ALE": "FT_alerion", "MM": "FT_meat_meat", "WYN": "FT_wyn"}
JOBS = {}
for code, src in HERALDS.items():
    JOBS["P-%s-01" % code] = (src, p_kneel)
    JOBS["P-%s-02" % code] = (src, p_reach)
    JOBS["P-%s-03" % code] = (src, p_down)
JOBS.update({
    "P-ALB-04": ("FT_alberica", p_alb04),
    "P-SHA-02": ("FT_shade", p_sha02),
    "P-SHI-02": ("FT_shimmer", p_shi02),
    "P-SHI-03": ("FT_shimmer", p_shi03),
    "P-SHI-04": ("FT_shimmer", p_shi04),
    "P-SEP-02": ("FT_sephek", p_sep02),
    "P-AUR-04": ("FT_auril_furs", p_aur04),
    "P-REP-04": ("FT_reptin", lambda s: p_rep04(s, load("FT_reptin_wolf"))),
    "P-REP-05": ("FT_reptin", lambda s: p_rep05(s, load("FT_reptin_wolf"))),
    "P-REP-06": ("FT_reptin", lambda s: p_rep06(s, load("FT_reptin_wolf"))),
    "P-SEP-05": ("FT_sephek", p_sep05),
    "P-SEP-06": ("FT_sephek", p_sep06),
    "P-THR-02": ("FT_thredra", p_leap),
    "P-THR-04": ("FT_thredra", p_lunge),
    "P-THR-03": ("FT_thredra", p_thr03),
    "P-THR-05": ("FT_thredra", p_thr05),
    "P-GHO-01": ("FT_green_ghost", p_gho01),
    "P-GHO-02": ("FT_green_ghost", p_gho02),
    "FT_alberica_rune": ("FT_alberica", v_alberica_rune),
    "FT_alberica_old": ("FT_alberica", v_alberica_old),
    "FT_sephek_frozen": ("FT_sephek", v_sephek_frozen),
    "FT_var_cracked": ("FT_var", v_var_cracked),
    "FT_thredra_echo": ("FT_thredra", v_thredra_echo),
})

def main():
    args = sys.argv[1:]
    out = D
    prev = None
    if "--out" in args:
        i = args.index("--out"); out = args[i + 1]; del args[i:i + 2]
    if "--preview" in args:
        i = args.index("--preview"); prev = args[i + 1]; del args[i:i + 2]
    ids = args or list(JOBS)
    os.makedirs(out, exist_ok=True)
    made = []
    for pid in ids:
        src, fn = JOBS[pid]
        sheet = save_sheet(fn(load(src)), os.path.join(out, pid + ".png"))
        if pid == "FT_alberica_old":
            close_light_edges(os.path.join(out, pid + ".png"))
            sheet = Image.open(os.path.join(out, pid + ".png")).convert("RGBA")
        made.append((pid, sheet))
        print(pid)
    if prev:
        bg = (150, 168, 150, 255)
        pv = Image.new("RGBA", (N * 4 * 2 + 8, (N * 4 + 12) * ((len(made) + 1) // 2)), bg)
        for i, (pid, sh) in enumerate(made):
            x, y = (i % 2) * (N * 4 + 8), (i // 2) * (N * 4 + 12)
            pv.alpha_composite(sh, (x, y + 12))
        pv.resize((pv.width * 2, pv.height * 2), Image.NEAREST).save(prev)

if __name__ == "__main__":
    main()
