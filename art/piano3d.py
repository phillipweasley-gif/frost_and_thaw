"""A small polygon renderer for the grand piano, so its silhouette is true:
curved case, lid propped open, keyboard, three legs. Draws at 4x into masks
that the pixel kit can shade."""
import math
from PIL import Image, ImageDraw

S4 = 4


def plan_outline():
    """Top view of a grand piano (keyboard edge along y=0, x 0..14)."""
    pts = [(0, 0), (14, 0), (14, 4)]
    # the bentside curve sweeping in toward the tail
    for i in range(1, 13):
        t = i / 12
        x = 14 - 7.5 * (1 - math.cos(t * math.pi / 2)) - 2.0 * t
        y = 4 + 21 * t
        pts.append((x, y))
    pts += [(3.0, 27.0), (0.6, 27.0), (0, 26)]
    return pts


class Cam:
    def __init__(self, yaw, pitch, scale, ox, oy):
        self.cy, self.sy = math.cos(math.radians(yaw)), math.sin(math.radians(yaw))
        self.cp, self.sp = math.cos(math.radians(pitch)), math.sin(math.radians(pitch))
        self.scale, self.ox, self.oy = scale, ox, oy

    def project(self, p):
        x, y, z = p
        sx = x * self.cy - y * self.sy
        depth = x * self.sy + y * self.cy
        sy = -z * self.cp - depth * self.sp
        return ((self.ox + sx * self.scale) * S4, (self.oy + sy * self.scale) * S4), depth * self.cp - z * self.sp


def lid_point(p, angle, hinge_x=0.0, z0=11.0):
    """Rotate a plan point (at the lid's closed height) up around the straight side."""
    x, y = p
    dx = x - hinge_x
    a = math.radians(angle)
    return (hinge_x + dx * math.cos(a), y, z0 + dx * math.sin(a))


def piano_faces(lid_angle=38):
    out = plan_outline()
    faces = []              # (name, [3d points])
    zb, zt = 8.0, 11.0
    # case sides
    for a, b in zip(out, out[1:] + out[:1]):
        faces.append(("side", [(a[0], a[1], zb), (b[0], b[1], zb), (b[0], b[1], zt), (a[0], a[1], zt)]))
    faces.append(("rim", [(x, y, zt) for x, y in out]))
    # inside of the case seen past the open lid: soundboard with strings
    inner = [(x * 0.92 + 0.5, y * 0.94 + 0.8, zt - 0.4) for x, y in out]
    faces.append(("inside", inner))
    # keyboard slab and the fallboard / music stand
    faces.append(("keys_top", [(0.6, -3.2, 9.6), (13.4, -3.2, 9.6), (13.4, 0, 9.6), (0.6, 0, 9.6)]))
    faces.append(("keys_front", [(0.6, -3.2, 8.6), (13.4, -3.2, 8.6), (13.4, -3.2, 9.6), (0.6, -3.2, 9.6)]))
    faces.append(("cheek", [(0, -3.4, 8.2), (0.6, -3.4, 8.2), (0.6, -3.4, 10.4), (0, -3.4, 10.4)]))
    faces.append(("cheek", [(13.4, -3.4, 8.2), (14, -3.4, 8.2), (14, -3.4, 10.4), (13.4, -3.4, 10.4)]))
    faces.append(("stand", [(2.5, 1.2, 11.0), (11.5, 1.2, 11.0), (11.5, 2.6, 14.0), (2.5, 2.6, 14.0)]))
    # the lid, hinged on the straight side, propped open
    faces.append(("lid", [lid_point(p, lid_angle) for p in out]))
    # prop stick from the rim to the lid
    tip = lid_point((13.0, 10.0), lid_angle)
    faces.append(("prop", [(12.6, 10, zt), (13.0, 10, zt), (tip[0] + 0.2, 10, tip[2]), (tip[0] - 0.2, 10, tip[2])]))
    # three legs
    for (lx, ly) in ((1.2, 1.0), (12.6, 1.0), (2.0, 24.5)):
        faces.append(("leg", [(lx - 0.5, ly, 0.8), (lx + 0.5, ly, 0.8), (lx + 0.6, ly, zb), (lx - 0.6, ly, zb)]))
    return faces


def render_masks(cam, lid_angle=38, size=96):
    """Returns {name: 'L' image at 4x} drawn in depth order (far first)."""
    faces = piano_faces(lid_angle)
    proj = []
    for name, pts in faces:
        pp = [cam.project(p) for p in pts]
        depth = sum(d for _, d in pp) / len(pp)
        proj.append((depth, name, [xy for xy, _ in pp]))
    proj.sort(key=lambda t: -t[0])                       # far to near
    # the open lid always sits over the case top and interior, the prop over the lid
    order = {"lid": 1, "prop": 2}
    proj.sort(key=lambda t: order.get(t[1], 0))
    layers = []
    for depth, name, poly in proj:
        im = Image.new("L", (size * S4, size * S4), 0)
        ImageDraw.Draw(im).polygon(poly, fill=255)
        layers.append((name, im, poly))
    return layers
