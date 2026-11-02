"""Hand-made Alberica fusions where the instrument reshapes the partner's anatomy (the user's design
direction): each is drawn pixel by pixel on the partner's own sprite, starting from the anatomy of the
real instrument - a lute's bowl is built from bent wooden staves with a flat soundboard and rosette over a
hollow; a cello is a hollow spruce-and-maple box with purfling round its edge, f-holes either side, and
strings over a bridge; a harp is a curved neck over a soundbox with strings fanning between them."""
import math
import numpy as np
from PIL import Image

PROTO = "/home/claude/frost-thaw/build/proto"
GOLD = [(122, 78, 22), (196, 144, 40), (240, 198, 78), (255, 238, 160)]
SPIRIT = [(52, 22, 84), (110, 60, 180), (176, 128, 244), (226, 200, 255)]
HOLE = (30, 12, 40)


class Px:
    def __init__(self, img):
        self.img = img.convert("RGBA").copy()
        self.p = self.img.load()

    def get(self, x, y):
        return self.p[x, y] if 0 <= x < self.img.width and 0 <= y < self.img.height else (0, 0, 0, 0)

    def put(self, x, y, c):
        if 0 <= x < self.img.width and 0 <= y < self.img.height:
            self.p[x, y] = tuple(int(v) for v in c[:3]) + (255,)

    def clear(self, x, y):
        self.p[x, y] = (0, 0, 0, 0)

    def recolour(self, mapping, region=None):
        for y in range(self.img.height):
            for x in range(self.img.width):
                c = self.p[x, y]
                if c[3] and c[:3] in mapping and (region is None or region(x, y)):
                    self.p[x, y] = tuple(mapping[c[:3]]) + (255,)

    def line(self, pts, col, cond=None):
        for (x0, y0), (x1, y1) in zip(pts, pts[1:]):
            n = int(max(abs(x1 - x0), abs(y1 - y0)) * 2) + 1
            last = None
            for i in range(n + 1):
                t = i / n
                q = (int(round(x0 + (x1 - x0) * t)), int(round(y0 + (y1 - y0) * t)))
                if q != last and (cond is None or cond(*q)):
                    self.put(*q, col)
                last = q

    def ellipse(self, cx, cy, rx, ry, rot=0.0):
        r = math.radians(rot)
        out = []
        for y in range(int(cy - max(rx, ry) - 2), int(cy + max(rx, ry) + 3)):
            for x in range(int(cx - max(rx, ry) - 2), int(cx + max(rx, ry) + 3)):
                dx, dy = x + 0.5 - cx, y + 0.5 - cy
                u = dx * math.cos(r) + dy * math.sin(r)
                v = -dx * math.sin(r) + dy * math.cos(r)
                if (u / rx) ** 2 + (v / ry) ** 2 <= 1:
                    out.append((x, y))
        return out

    def opaque(self, x, y):
        return self.get(x, y)[3] > 0


def edge(pts):
    S = set(pts)
    return [p for p in pts if any((p[0] + dx, p[1] + dy) not in S for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)))]


# ------------------------------------------------------------------------- Lutling x Bulbasaur
PAL = {"#": (11, 11, 11), "D": (110, 56, 24), "d": (172, 100, 44), "m": (224, 152, 76), "l": (246, 198, 124),
       "h": (252, 224, 166), "H": HOLE, "v": SPIRIT[1], "V": SPIRIT[2], "w": SPIRIT[3], "g": GOLD[2],
       "G": GOLD[3], "b": (112, 62, 30), "B": (70, 36, 18), "s": (140, 76, 32)}


def stamp(P, x0, y0, rows, pal=PAL):
    """Hand-placed pixels: one string per row, '.' keeps what is there, '_' clears it."""
    for j, row in enumerate(rows):
        for i, ch in enumerate(row):
            if ch == ".":
                continue
            if ch == "_":
                P.clear(x0 + i, y0 + j)
            else:
                P.put(x0 + i, y0 + j, pal[ch])


def lutling_bulbasaur():
    """Bulbasaur whose bulb has grown into a hollow lute bowl. The bulb's leaves become the bowl's bent
    wooden staves (all running to the bottom block, as a lute's ribs do); its top opens into a hollow - dark
    far lip, lit near lip - with strings stretched across it; the bulb's tip bends back into a little
    pegbox with gold pegs; and the haunting glows inside the hollow and in its eyes."""
    P = Px(Image.open(f"{PROTO}/bulbasaur.png"))
    wood = {(187, 223, 113): PAL["l"], (164, 213, 65): PAL["m"], (122, 158, 48): PAL["d"], (72, 94, 28): PAL["D"]}
    P.recolour(wood)
    # ribs: a lute's bowl is glued up from narrow staves of two woods in turn, all running to the bottom
    # block - every other rib here is the darker wood, with a fine dark line between them
    yew = {PAL["l"]: (230, 172, 100), PAL["m"]: (198, 124, 58), PAL["d"]: (148, 82, 34), PAL["D"]: (96, 46, 20)}
    bx_, by_ = 58.0, 50.0
    band = lambda x, y: int((math.degrees(math.atan2(y + 0.5 - by_, x + 0.5 - bx_)) + 360) // 11) % 2
    for y in range(P.img.height):
        for x in range(P.img.width):
            c = P.get(x, y)[:3]
            if c in yew and band(x, y):
                P.put(x, y, yew[c])
    for y in range(P.img.height):
        for x in range(P.img.width):
            c = P.get(x, y)[:3]
            if (c in yew or c in yew.values()) and band(x, y) != band(x + 1, y) and P.get(x + 1, y)[:3] in list(yew) + list(yew.values()):
                P.put(x, y, PAL["s"])
    # the bulb's sprout grows into the lute's neck: a short fretted fingerboard rising from the tip of the
    # bowl, strings running up it, and the pegbox bent sharply back at the end, set with gold pegs
    neck = [(56, 30), (57, 29), (58, 28), (59, 27), (60, 26), (61, 25), (62, 24), (63, 23)]
    for i, (x, y) in enumerate(neck):
        P.put(x - 1, y, (11, 11, 11)); P.put(x, y - 1, (11, 11, 11))          # outline, upper-left side
        P.put(x, y, (96, 52, 26)); P.put(x + 1, y, (128, 72, 34))            # fingerboard and its lit edge
        P.put(x + 1, y + 1, (11, 11, 11)); P.put(x + 2, y, (11, 11, 11))      # outline, lower-right side
        if i % 2 == 1:
            P.put(x, y, (236, 196, 140))                                       # a fret
    P.line([(57, 30), (64, 23)], GOLD[2])
    stamp(P, 62, 19, [            # the pegbox, bent back almost square to the neck
        "..#g#.",
        ".#BbBg",
        "#bBbB#",
        "gBbB#.",
        ".##g..",
    ])
    # the soundhole, on the side of the bowl facing us: a gold-lipped opening into the hollow,
    # the haunting glowing in the bottom of it
    stamp(P, 50, 36, [           # the rose: gold fretwork across the hole, the glow behind it
        "..ggg..",
        ".gHgHg.",
        "gHgVgHg",
        "gHVwVHg",
        ".gVgVg.",
        "..GGG..",
    ])
    # strings: from the pegbox, down across the soundhole, to a little bridge on the bowl's belly
    P.line([(56, 31), (53, 46)], GOLD[3], cond=lambda x, y: P.get(x, y)[:3] != (11, 11, 11))
    P.line([(58, 32), (55, 46)], GOLD[2], cond=lambda x, y: P.get(x, y)[:3] != (11, 11, 11))
    stamp(P, 51, 45, ["#lhl#", ".###."], pal=dict(PAL, l=(236, 196, 140), h=(252, 224, 166)))   # the bridge
    # a wisp of the haunting rising out of the hole
    stamp(P, 48, 33, ["..V", ".w.", "V.."])
    # the haunting in its eyes: red irises turn the spirit's violet
    P.recolour({(159, 0, 39): SPIRIT[1], (229, 25, 46): SPIRIT[2], (247, 93, 85): SPIRIT[3]},
               region=lambda x, y: y <= 48)
    return P.img


# ------------------------------------------------------------------------- Hauntello x Gengar
CELLO = {"hi": (236, 150, 108), "light": (214, 108, 74), "mid": (178, 72, 50), "dark": (128, 44, 34),
         "edge": (72, 20, 18), "purfling": (88, 26, 20), "splinter": (244, 206, 168), "crack": (52, 12, 12)}


def hauntello_gengar():
    """Gengar's round body becomes the cello's resonating chamber: varnished red wood, a purfling line
    running round inside its edge as on a real cello, f-holes low on either side, a crack through the
    varnish. Its grin is the soundhole - splintered wood where the teeth were, the haunting glowing in the
    dark behind. A bridge sits under the soundhole, and its loose strings run out along the arms into its
    fingers and curl free beyond them. No cello neck."""
    P = Px(Image.open(f"{PROTO}/gengar.png"))
    W, H = P.img.size
    # the grin (white teeth and their grey shading, rows 48-56) is found before anything is recoloured
    grin = {(x, y) for y in range(48, 57) for x in range(28, 52)
            if P.get(x, y)[3] and P.get(x, y)[:3] in ((247, 238, 247), (93, 85, 109), (177, 159, 177), (212, 203, 212))}
    body = {(x, y) for y in range(H) for x in range(W) if P.get(x, y)[3]}
    # 1. purple flesh -> varnished wood, light for light
    P.recolour({(175, 150, 199): CELLO["light"], (148, 115, 180): CELLO["mid"], (110, 85, 134): CELLO["dark"],
                (61, 32, 61): CELLO["edge"], (247, 77, 77): SPIRIT[1], (247, 134, 134): SPIRIT[3]})
    # a little highlight where the varnish catches the light (upper left of the dome)
    for (x, y) in P.ellipse(37, 33, 5, 2.2, rot=-15):
        if P.get(x, y)[:3] == CELLO["light"]:
            P.put(x, y, CELLO["hi"])
    # 2. purfling: the inlaid line that follows a cello's edge, a few pixels in from the outline
    from scipy import ndimage as ndi
    m = np.zeros((H, W), bool)
    for (x, y) in body:
        m[y, x] = True
    dist = ndi.distance_transform_cdt(m, metric="taxicab")
    for y in range(H):
        for x in range(W):
            if (dist[y, x] == 3 and 30 <= x <= 61 and 31 <= y <= 66 and (x, y) not in grin
                    and P.get(x, y)[:3] in (CELLO["mid"], CELLO["dark"], CELLO["light"], CELLO["hi"])
                    and not (x < 32 and y < 48)):
                P.put(x, y, CELLO["purfling"])
    # 3. the grin becomes the soundhole
    top = {}
    for (x, y) in grin:
        top[x] = min(top.get(x, 99), y)
    for (x, y) in grin:
        P.put(x, y, HOLE)
    for x, y in top.items():                     # where each tooth was: a splinter of pale wood
        if x % 3 != 1:
            P.put(x, y, CELLO["splinter"])
    for (x, y, c) in ((38, 54, SPIRIT[1]), (39, 54, SPIRIT[2]), (40, 54, SPIRIT[3]), (41, 54, SPIRIT[2]),
                      (42, 54, SPIRIT[1]), (39, 55, SPIRIT[1]), (40, 55, SPIRIT[2]), (41, 55, SPIRIT[1]),
                      (36, 53, SPIRIT[1]), (45, 53, SPIRIT[1])):
        if (x, y) in grin:
            P.put(x, y, c)
    # 4. f-holes, low on either side
    stamp(P, 33, 57, [".k", "k.", "k.", "k.", "k.", "kk"], pal={"k": CELLO["crack"]})
    stamp(P, 57, 51, ["kk", ".k", ".k", ".k", ".k", "k."], pal={"k": CELLO["crack"]})
    # 5. a crack through the varnish, splintered pale along one side
    P.line([(48, 57), (50, 60), (49, 62), (51, 65)], CELLO["crack"])
    for (x, y) in ((49, 58), (51, 61), (50, 63)):
        P.put(x, y, CELLO["splinter"])
    # 6. the front of a cello on its belly: an ebony tailpiece, the bridge standing on two feet, and four
    #    strings rising over it into the soundhole
    stamp(P, 38, 57, [
        ".s.s.s.s.",
        ".s.s.s.s.",
        "#bbbbbbb#",
        ".#b#.#b#.",
        "..eeeee..",
        "..eEEEe..",
        "...eEe...",
        "...eee...",
        "....e....",
    ], pal={"s": GOLD[3], "b": (236, 196, 140), "#": CELLO["edge"], "e": (34, 22, 22), "E": (70, 52, 50)})
    # the endpin under it, a metal spike for standing on
    stamp(P, 42, 66, ["e", "m", "m", "M", "m", "e"], pal={"e": (11, 11, 11), "m": (150, 150, 162), "M": (214, 214, 224)})
    # its tall ear becomes the cello's neck: an ebony fingerboard runs up the ear with strings along it,
    # and the tip curls into a scroll with gold pegs either side of the pegbox
    for k in range(0, 10):
        x, y = int(round(55 + k * 0.75)), 31 - k
        P.put(x - 1, y, (11, 11, 11))                       # the fingerboard's edge
        P.put(x, y, (30, 20, 20))                           # ebony
        P.put(x + 1, y, GOLD[2] if k % 3 else GOLD[3])      # a string along it
    # the pegbox at the top of the ear with a peg out to each side, and the scroll curling over it
    stamp(P, 59, 13, [
        ".eeee..",
        "eLLMMe.",
        "eLeeeMe",
        "eMeLeMe",
        ".eMMeMe",
        "..eeMe.",
        "gge#Mgg",
        "..e#Me.",
    ], pal={"e": (11, 11, 11), "L": CELLO["hi"], "M": CELLO["mid"], "#": (30, 20, 20), "g": GOLD[2]})
    # gold knobs on the tips of its other spikes, like tuning pegs
    for (x, y) in ((34, 26), (37, 25), (46, 23)):
        stamp(P, x, y, ["gG", "gg"], pal={"g": GOLD[1], "G": GOLD[3]})
    # 7. its strings run out of the chamber along each arm and into the fingers, fraying loose past them
    P.line([(29, 45), (24, 42), (20, 40), (17, 38)], GOLD[2], cond=lambda x, y: P.opaque(x, y))
    P.line([(29, 44), (25, 41), (21, 38)], GOLD[1], cond=lambda x, y: P.opaque(x, y))
    P.line([(16, 37), (14, 35), (13, 32), (14, 30)], GOLD[2])
    P.line([(18, 37), (17, 34), (18, 32)], GOLD[3])
    P.line([(16, 40), (13, 41), (11, 39)], GOLD[2])
    P.line([(61, 46), (65, 43), (70, 39), (73, 37)], GOLD[2], cond=lambda x, y: P.opaque(x, y))
    P.line([(61, 45), (65, 42), (69, 38)], GOLD[1], cond=lambda x, y: P.opaque(x, y))
    P.line([(74, 36), (76, 33), (78, 31), (77, 29)], GOLD[2])
    P.line([(72, 35), (73, 32), (72, 30)], GOLD[3])
    P.line([(75, 38), (78, 38), (79, 36)], GOLD[2])
    return P.img


# ------------------------------------------------------------------------- Chorumbra x Gardevoir
LACQ = [(58, 16, 30), (98, 32, 48), (140, 54, 66), (180, 86, 92)]


def chorumbra_gardevoir():
    """Gardevoir whose hair-crest IS a small harp: the crest's outer sweep becomes the harp's curved neck in
    lacquered wood with gold tuning pegs along it, and the streaks that ran through the hair become the
    strings, following the hair's own flow. The green becomes Chorumbra's spirit-violet; the red chest fin
    turns lacquer and gold like the harp's soundbox; and long gold string-hair flows from the back of the
    crest down along the sweep of the gown, ending in beads. No harp stacked on top."""
    P = Px(Image.open(f"{PROTO}/gardevoir.png"))
    W, H = P.img.size
    G = {(168, 236, 168): "h", (139, 230, 139): "f", (103, 171, 103): "e", (61, 101, 61): "d"}
    hair = {(x, y) for y in range(H) for x in range(W) if y <= 32 and P.get(x, y)[3] and P.get(x, y)[:3] in G}
    streak = {(x, y) for (x, y) in hair if G[P.get(x, y)[:3]] == "e" and x < 37}
    # 1. green -> spirit violet everywhere (hair, arms, legs), light for light
    P.recolour({(168, 236, 168): (226, 204, 255), (139, 230, 139): (186, 148, 240), (103, 171, 103): (132, 94, 198),
                (61, 101, 61): (66, 34, 108)})
    # 2. the crest's outer sweep becomes the harp's curved neck: two pixels of lacquer just inside the
    #    outline along its top and back, gold pegs set into it
    out = lambda x, y: not P.get(x, y)[3]
    band = set()
    for (x, y) in hair:
        d = min([k for k in (1, 2, 3) if any(out(x + dx * k, y + dy * k) for dx, dy in ((-1, 0), (0, -1), (-1, -1)))] or [9])
        if d in (2, 3) and x < 44:
            band.add((x, y, d))
    for (x, y, d) in band:
        P.put(x, y, LACQ[2] if d == 2 else LACQ[1])
    pegs = sorted({(x, y) for (x, y, d) in band if d == 2}, key=lambda p: (p[1], p[0]))
    for i, (x, y) in enumerate(pegs):
        if i % 4 == 0:
            P.put(x, y, GOLD[2])
    # 3. the hair's streaks become the strings
    for (x, y) in streak:
        if (x, y, 2) not in band and (x, y, 3) not in band:
            P.put(x, y, GOLD[2] if y < 26 else GOLD[1])
    # 4. the chest fin as the harp's soundbox: lacquer with a gold edge; the eye takes Chorumbra's violet
    P.recolour({(94, 32, 50): LACQ[0], (213, 74, 115): LACQ[2], (223, 120, 150): GOLD[2]}, region=lambda x, y: y >= 31)
    P.recolour({(94, 32, 50): (60, 20, 70), (213, 74, 115): (140, 46, 160), (223, 120, 150): (220, 170, 255)},
               region=lambda x, y: y < 31)
    # 5. her body becomes a harp's frame: the outstretched arm is the curved neck (lacquer, with gold
    #    tuning pins along its underside), the sweep of the gown's upper edge is the soundbox, a pillar
    #    rises from the gown to her hand, and the strings hang between neck and soundbox - longest by the
    #    pillar, as on a real harp
    arm = {(x, y) for y in range(38, 48) for x in range(43, 64) if P.get(x, y)[3] and P.get(x, y)[:3] not in ((0, 0, 0),)}
    vio = {(226, 204, 255): LACQ[3], (186, 148, 240): LACQ[2], (132, 94, 198): LACQ[1], (66, 34, 108): LACQ[0]}
    for (x, y) in arm:
        if P.get(x, y)[:3] in vio:
            P.put(x, y, vio[P.get(x, y)[:3]])
    under = {}
    for (x, y) in arm:
        under[x] = max(under.get(x, 0), y)
    rail = {}
    for x in range(44, 77):
        for y in range(50, 72):
            c = P.get(x, y)
            if c[3] and c[:3] in ((152, 152, 171), (205, 205, 230), (217, 217, 236)):
                rail[x] = y
                break
    for x, y in rail.items():                       # the soundbox along the gown's upper edge
        P.put(x, y, LACQ[1]); P.put(x, y + 1, LACQ[2])
        if x % 4 == 0:
            P.put(x, y + 1, GOLD[2])
    for x in range(47, 61, 3):                      # strings, neck to soundbox
        if x in under and x in rail:
            P.line([(x, under[x] + 2), (x, rail[x] - 1)], GOLD[2] if x % 2 else GOLD[3],
                   cond=lambda xx, yy: not P.get(xx, yy)[3] or P.get(xx, yy)[:3] in GOLD)
            P.put(x, under[x] + 1, GOLD[1])       # its tuning pin
    px_ = 62
    top_, bot_ = under.get(61, 45) + 1, rail.get(63, 62) - 1
    for y in range(top_, bot_ + 1):                 # the pillar
        P.put(px_ - 1, y, (11, 11, 11)); P.put(px_, y, LACQ[2]); P.put(px_ + 1, y, LACQ[1]); P.put(px_ + 2, y, (11, 11, 11))
    for y in (top_, bot_, (top_ + bot_) // 2):
        P.put(px_, y, GOLD[3]); P.put(px_ + 1, y, GOLD[2])
    stamp(P, 30, 35, [".g.", "gHg", ".g."], pal={"g": GOLD[2], "H": (40, 12, 30)})   # a gold rose on the chest fin
    # the crest is topped with a gold finial, as a harp's pillar is
    top = min((p for p in hair), key=lambda p: (p[1], p[0]))
    stamp(P, top[0] - 1, top[1] - 2, [".G.", "ggg"], pal={"g": GOLD[1], "G": GOLD[3]})
    # 6. string-hair falling from the back of the crest over her shoulder, ending in beads
    for path in ([(47, 24), (49, 30), (50, 35)], [(48, 22), (51, 28), (53, 33)]):
        P.line(path, GOLD[2], cond=lambda x, y: not (x, y) in hair)
        x, y = path[-1]
        stamp(P, x, y, ["gG", "gg"], pal={"g": GOLD[1], "G": GOLD[3]})
    return P.img


if __name__ == "__main__":
    import sys
    lutling_bulbasaur().save(f"{PROTO}/577.1.png")
    hauntello_gengar().save(f"{PROTO}/578.94.png")
    chorumbra_gardevoir().save(f"{PROTO}/579.287.png")
