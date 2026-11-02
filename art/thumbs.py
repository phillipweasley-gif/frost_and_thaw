"""Two-value silhouette thumbnails for Hauntello and Pianocturne (step 1 of the design guide)."""
import math
from PIL import Image, ImageDraw
from clean import ellipse_pts, ribbon, smooth_poly_mask, to_mask, N, K
from hires import bezier, spiral
from orchestra import cello_body
import piano3d as P3


def rot(pts, ang, ox, oy):
    c, s = math.cos(ang), math.sin(ang)
    return [(ox + (x - ox) * c - (y - oy) * s, oy + (x - ox) * s + (y - oy) * c) for x, y in pts]


def hand(cx, cy, ang, size):
    a = math.radians(ang); polys = [ellipse_pts(cx, cy, 3.2 * size, 3.2 * size, 20)]
    for off in (-1.5, -0.5, 0.5, 1.5):
        fa = a + off * 0.33
        b = (cx + math.cos(fa) * 2.6 * size, cy + math.sin(fa) * 2.6 * size)
        t = (b[0] + math.cos(fa) * 6 * size, b[1] + math.sin(fa) * 6 * size)
        polys.append(ribbon([b, t], 1.2 * size, 0.7 * size))
    ta = a - 1.3
    polys.append(ribbon([(cx + math.cos(ta) * 2.6 * size, cy + math.sin(ta) * 2.6 * size),
                         (cx + math.cos(ta + 0.4) * 6.5 * size, cy + math.sin(ta + 0.4) * 6.5 * size)], 1.1 * size, 0.7 * size))
    return polys


def cello(cx, top, h, ang=0.0, scale=1.0):
    pts = cello_body(cx, top, h, 14 * scale, 18 * scale, 9.5 * scale)
    neck = [(cx, top + 2), (cx, top - 14 * scale)]
    sc = spiral(cx + 2.5 * scale, top - 17 * scale, 3.6 * scale, 0.9, 180, shrink=0.6, n=24)
    oy = top + h / 2
    return [rot(pts, ang, cx, oy), rot(ribbon(neck, 2.2 * scale, 2.0 * scale), ang, cx, oy), rot(ribbon(sc, 2.0 * scale, 1.0 * scale), ang, cx, oy)]


# ---- Hauntello ideas -----------------------------------------------------------
def h_peek():
    p = cello(46, 30, 52, math.radians(-8))
    p.append(ellipse_pts(36, 34, 6.5, 6, 30))                          # spirit's head out of the chip
    p += [ribbon(bezier((56, 58), (72, 56), (76, 38), (70, 30), 20), 1.6, 2.4), ribbon([(66, 64), (80, 16)], 0.8, 0.8)]
    return p


def h_hands():
    p = cello(48, 32, 48)
    for (x0, y0, x1, y1, ang, s) in ((48, 20, 76, 12, -60, 1.6), (48, 20, 16, 18, 230, 1.7), (48, 78, 18, 80, 200, 1.5), (48, 78, 80, 82, -20, 1.5)):
        p.append(ribbon(bezier((x0, y0), ((x0 + x1) / 2, y0 - 10), (x1, y1 - 6), (x1, y1), 16), 0.7, 2.6))
        p += hand(x1, y1, ang, s)
    return p


def h_cellist():
    # the scroll bends forward like a head; the body is a torso; strings are arms; endpin a leg
    p = [cello_body(48, 34, 46, 12, 16, 8.5)]
    p.append(ribbon(bezier((48, 36), (48, 22), (54, 14), (62, 16), 16), 2.4, 2.0))
    p.append(ellipse_pts(64, 17, 6, 5, 24))                            # scroll as a head
    p.append(ribbon(bezier((40, 44), (26, 40), (20, 52), (24, 62), 16), 1.6, 1.2))
    p.append(ribbon(bezier((56, 44), (70, 48), (74, 40), (78, 30), 16), 1.6, 1.2))
    p.append(ribbon([(78, 30), (60, 90)], 0.8, 0.8))                   # the bow held like a rapier
    p.append(ribbon([(48, 80), (46, 94)], 1.2, 0.6))
    return p


def h_manta():
    # the cello glides on its side; C-bouts flare into fins (Mantyke nod), scroll leads
    p = []
    body = rot(cello_body(48, 34, 46, 13, 17, 9), math.radians(-70), 48, 57)
    p.append(body)
    p.append(rot(ribbon([(48, 36), (48, 20)], 2.2, 2.0), math.radians(-70), 48, 57))
    p.append(ellipse_pts(26, 46, 4, 4, 20))
    for side in (-1, 1):
        p.append([(46, 57), (40 + side * 4, 57 + side * 26), (56 + side * 2, 57 + side * 10)])
    p.append(ribbon(bezier((70, 62), (80, 66), (86, 74), (92, 70), 14), 1.6, 0.6))
    return p


# ---- Pianocturne ideas ---------------------------------------------------------
def piano_polys(yaw, pitch, lid, ox, oy, sc):
    cam = P3.Cam(yaw, pitch, sc, ox, oy)
    out = []
    for name, mask, poly in P3.render_masks(cam, lid):
        out.append([(x / P3.S4, y / P3.S4) for x, y in poly])
    return out


def p_jaw():
    p = piano_polys(-78, 14, 60, 20, 84, 2.6)
    return p


def p_manta():
    # seen from the front, flying: the open lid and the case spread like Mantine's wings
    p = [[(48, 34), (90, 22), (80, 42), (60, 48)], [(48, 34), (6, 22), (16, 42), (36, 48)]]
    p.append(ellipse_pts(48, 44, 14, 10, 30))
    p.append([(34, 50), (62, 50), (58, 58), (38, 58)])               # keyboard as a grin under the body
    p.append(ribbon(bezier((48, 54), (52, 70), (40, 80), (50, 94), 18), 2.0, 0.6))
    for side in (-1, 1):
        p.append(ribbon(bezier((48 + side * 8, 52), (48 + side * 16, 66), (48 + side * 10, 76), (48 + side * 18, 86), 14), 1.2, 0.5))
    return p


def p_spirit():
    p = piano_polys(-78, 14, 50, 22, 90, 2.4)
    p.append(ellipse_pts(50, 40, 8, 7, 30))                             # spirit rising under the lid
    p.append(ribbon(bezier((44, 44), (30, 40), (26, 30), (30, 24), 14), 1.4, 2.0))
    p.append(ribbon(bezier((56, 44), (68, 38), (72, 28), (68, 22), 14), 1.4, 2.0))
    p.append(ribbon([(68, 22), (82, 14)], 0.6, 0.6))                  # baton
    return p


def p_legs():
    p = piano_polys(-78, 14, 50, 22, 74, 2.3)
    for (x, y, dx) in ((14, 66, -8), (30, 68, -4), (62, 66, 8), (76, 64, 6)):
        p.append(ribbon(bezier((x, y), (x + dx, y + 8), (x + dx * 2, y + 14), (x + dx * 1.2, y + 22), 16), 2.4, 0.8))
    return p


IDEAS = [("Hauntello A: spirit peeks out", h_peek), ("B: four shadow hands", h_hands),
         ("C: the cellist (scroll head)", h_cellist), ("D: gliding manta cello", h_manta),
         ("Pianocturne A: lid as open jaws", p_jaw), ("B: manta grand (Mantine nod)", p_manta),
         ("C: spirit conducts from inside", p_spirit), ("D: tentacle legs", p_legs)]

if __name__ == "__main__":
    cell = 150
    sheet = Image.new("RGB", (cell * 4, (cell + 22) * 2), (236, 232, 222))
    d = ImageDraw.Draw(sheet)
    for i, (label, fn) in enumerate(IDEAS):
        m = to_mask(smooth_poly_mask(fn()), 0.5)
        im = Image.new("RGB", (N, N), (236, 232, 222))
        for (x, y) in m:
            if 0 <= x < N and 0 <= y < N:
                im.putpixel((x, y), (28, 24, 34))
        x0, y0 = (i % 4) * cell, (i // 4) * (cell + 22)
        sheet.paste(im.resize((cell - 6, cell - 6), Image.NEAREST), (x0 + 3, y0 + 3))
        d.text((x0 + 6, y0 + cell + 2), label, fill=(40, 30, 40))
    sheet = sheet.resize((sheet.width * 2, sheet.height * 2), Image.NEAREST)
    sheet.save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/thumbs.png")
