"""Pianocturne: a happily possessed floating grand piano (front and back views)."""
import math
from PIL import Image, ImageDraw
import piano3d as P3
from hires import Part, bezier, spiral
from pixelkit import Solid, render_solids, drop_to_ground

LAC = [(12, 10, 22), (26, 22, 44), (44, 40, 74), (78, 76, 124), (150, 150, 200)]   # black-violet lacquer
OUT = (2, 0, 6)
STR = [(150, 120, 200), (196, 172, 236), (232, 220, 252), (255, 250, 255)]
STR_OUT = (80, 56, 130)
WISP = [(70, 40, 110), (110, 70, 160), (160, 120, 210), (210, 180, 245)]
WISP_OUT = (40, 16, 70)


def face_tone(name, poly):
    if name in ("keys_top",):
        return (244, 240, 230)
    if name == "keys_front":
        return (196, 190, 184)
    if name == "inside":
        return (168, 126, 64)
    if name == "prop":
        return (214, 172, 80)
    if name == "lid":
        return LAC[2]
    if name == "rim":
        return LAC[2]
    if name == "stand":
        return LAC[1]
    if name == "leg":
        return LAC[1]
    if name == "cheek":
        return LAC[0]
    # case sides: lighter the more they face the viewer's left/front
    (x0, y0), (x1, y1) = poly[0], poly[1]
    nx = (y1 - y0)
    ln = math.hypot(x1 - x0, y1 - y0) or 1
    f = nx / ln
    return LAC[1] if f < -0.3 else LAC[2] if f < 0.3 else LAC[3]


def draw_piano(yaw, pitch, lid_angle, ox, oy, scale):
    cam = P3.Cam(yaw, pitch, scale, ox, oy)
    img = Image.new("RGBA", (96, 96), (0, 0, 0, 0))
    px = img.load()
    owner = {}
    for name, mask4, poly in P3.render_masks(cam, lid_angle):
        small = mask4.resize((96, 96), Image.BOX).load()
        tone = face_tone(name, poly)
        for y in range(96):
            for x in range(96):
                if small[x, y] >= 120:
                    px[x, y] = tone + (255,)
                    owner[(x, y)] = name
    # panel edges and outline
    edge = {}
    for (x, y), n in owner.items():
        for dx, dy in ((1, 0), (0, 1), (-1, 0), (0, -1)):
            m = owner.get((x + dx, y + dy))
            if m is None:
                edge[(x, y)] = OUT
                break
            if m != n and n in ("side", "rim", "lid") and m in ("side", "rim", "lid"):
                edge.setdefault((x, y), (90, 70, 40) if "rim" in (m, n) else LAC[0])
    for p, c in edge.items():
        px[p] = c + (255,)
    return img, cam, owner


def proj(cam, p):
    (x, y), _ = cam.project(p)
    return (x / P3.S4, y / P3.S4)


def pianocturne(back=False):
    if not back:
        yaw, pitch, lid, ox, oy, sc = -38, 26, 50, 36, 92, 2.6
    else:
        yaw, pitch, lid, ox, oy, sc = 150, 24, 50, 58, 88, 2.5
    img, cam, owner = draw_piano(yaw, pitch, lid, ox, oy, sc)
    detail = Image.new("RGBA", (96, 96), (0, 0, 0, 0))
    d = ImageDraw.Draw(detail)
    clip = {}
    # gold harp and strings inside the open case
    if not back:
        for k in range(9):
            x = 1.5 + k * 1.3
            a, b = proj(cam, (x, 1.8, 10.7)), proj(cam, (x * 0.45 + 0.8, 22 - k * 0.6, 10.7))
            d.line([a, b], fill=(236, 214, 160, 255))
        clip["inside"] = detail.copy(); detail = Image.new("RGBA", (96, 96), (0, 0, 0, 0)); d = ImageDraw.Draw(detail)
        # black keys on the keyboard: a grin of teeth
        for k in range(26):
            x = 0.9 + k * 0.48
            if k % 7 in (2, 6):
                continue
            a, b = proj(cam, (x, -3.0, 9.65)), proj(cam, (x, -1.8, 9.65))
            d.line([a, b], fill=(20, 14, 26, 255))
        clip["keys_top"] = detail.copy(); detail = Image.new("RGBA", (96, 96), (0, 0, 0, 0)); d = ImageDraw.Draw(detail)
        # happy glowing eyes on the music stand
        for ex in (4.8, 9.2):
            c = proj(cam, (ex, 2.0, 12.7))
            d.arc([c[0] - 3, c[1] - 2, c[0] + 3, c[1] + 3], 200, 340, fill=(255, 150, 225, 255), width=2)
        clip["stand"] = detail.copy()
    px, owner_px = img.load(), owner
    for surface, layer in clip.items():
        lp = layer.load()
        for y in range(96):
            for x in range(96):
                if lp[x, y][3] and owner_px.get((x, y)) == surface:
                    px[x, y] = lp[x, y]
    # string-tentacles curling out from under the lid, and wisps instead of feet
    extra = Part()
    hinge_side = [(13.5, 6, 11.2), (11.5, 13, 11.2), (9.0, 19, 11.2)] if not back else [(13.5, 6, 11.2), (11.0, 14, 11.2), (8.5, 20, 11.2)]
    for i, p in enumerate(hinge_side):
        sx, sy = proj(cam, p)
        side = 1 if not back else -1
        pts = bezier((sx, sy), (sx + side * 6, sy - 4 - i * 2), (sx + side * 12, sy + 1), (sx + side * 9, sy + 6), 14)
        extra.stroke(pts + spiral(pts[-1][0] - side * 1.6, pts[-1][1], 1.6, 0.75, 0 if side > 0 else 180, shrink=0.5, n=10, clockwise=side < 0)[1:], 1.5, 0.6)
    wisps = Part()
    for (lx, ly) in ((1.2, 1.0), (12.6, 1.0), (2.0, 24.5)):
        sx, sy = proj(cam, (lx, ly, 0.8))
        wisps.stroke(bezier((sx, sy - 1), (sx - 3, sy + 4), (sx + 3, sy + 7), (sx - 1, sy + 11), 10), 2.2, 0.5)
    layer = render_solids([Solid(wisps.mask(), WISP, WISP_OUT, depth=2), Solid(extra.mask(), STR, STR_OUT, depth=1)])
    out = Image.new("RGBA", (96, 96), (0, 0, 0, 0))
    out.alpha_composite(layer)
    out.alpha_composite(img)
    # tentacles over the case edge should sit in front
    out.alpha_composite(render_solids([Solid(extra.mask(), STR, STR_OUT, depth=1)]))
    d = ImageDraw.Draw(out)
    for (x, y) in ((8, 10), (88, 14), (6, 60), (90, 70)):
        d.point([(x, y), (x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)], fill=(255, 200, 240, 255))
    return drop_to_ground(out, 94)


if __name__ == "__main__":
    s = Image.new("RGBA", (200, 100), (66, 74, 96, 255))
    s.alpha_composite(pianocturne(False), (2, 2)); s.alpha_composite(pianocturne(True), (102, 2))
    s.resize((800, 400), Image.NEAREST).save("/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/piano2.png")
