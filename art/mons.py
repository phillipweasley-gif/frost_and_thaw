"""Original Frost & Thaw Pokémon, drawn with pixelkit (96x96 battle sprites).
python3 mons.py <out folder>"""
import os, sys, math
from PIL import Image, ImageDraw
from pixelkit import *


# --- Alberica's line: the bell whose song darkens ---------------------------------
def bell_mask(cx, top, w, h, flare):
    """A handbell: rounded crown, straight-ish waist, flared lip."""
    pts = []
    for i in range(0, 181, 6):            # crown (half circle)
        a = math.radians(180 + i)
        pts.append((cx + (w * 0.42) * math.cos(a), top + h * 0.32 + (h * 0.32) * math.sin(a)))
    pts += [(cx + w * 0.44, top + h * 0.55), (cx + w * 0.5 + flare, top + h), (cx - w * 0.5 - flare, top + h),
            (cx - w * 0.44, top + h * 0.55)]
    return polygon(pts)


def chimelet():
    gold = (232, 190, 92)
    s = []
    s.append(Shape(tube([(48, 22), (48, 30)], 3, 3), (150, 96, 58)))                     # handle
    s.append(Shape(ellipse(48, 20, 4, 4), (170, 112, 66)))                                # knob
    clap = tube([(48, 60), (49, 66), (51, 71), (55, 73), (58, 71), (57, 68)], 3, 2)          # one curly clapper
    s.append(Shape(clap, (176, 150, 214)))
    s.append(Shape(bell_mask(48, 29, 40, 40, 4), gold,
                   highlight={(37 + i, 40 + i // 2) for i in range(4)} | {(36, 43), (37, 44)}))
    s.append(Shape(polygon([(26, 66), (70, 66), (69, 70), (27, 70)]), (214, 160, 70)))    # lip band
    img = render(s)
    eye(img, 40, 47, 3, 5, white=None); eye(img, 53, 47, 3, 5)
    d = ImageDraw.Draw(img)
    d.rectangle([35, 55, 37, 56], fill=(240, 140, 150, 255)); d.rectangle([58, 55, 60, 56], fill=(240, 140, 150, 255))
    d.line([(46, 57), (48, 59), (50, 57)], fill=(90, 50, 40, 255))                        # smile
    # music notes
    for (x, y) in ((70, 24), (22, 30)):
        d.ellipse([x, y + 6, x + 3, y + 9], fill=(120, 90, 170, 255)); d.line([(x + 3, y), (x + 3, y + 7)], fill=(120, 90, 170, 255))
        d.line([(x + 3, y), (x + 6, y + 2)], fill=(120, 90, 170, 255))
    return drop_to_ground(img, 84)


def dirgebell():
    plum = (86, 66, 112)
    s = []
    # tentacles behind and below the bell, curling like fingers on strings
    for i, (x, ph, dr) in enumerate([(34, 0.0, -6), (42, 1.2, -2), (50, 2.1, 2), (58, 3.0, 6), (46, 4.0, 0)]):
        s.append(Shape(tube(wave(x, 60, 26, 3, 1.1, phase=ph, drift=dr, steps=14), 4, 1.5), (62, 44, 88),
                       light=(140, 104, 184)))
    s.append(Shape(tube([(48, 12), (49, 18), (48, 23)], 3, 3), (60, 50, 60)))             # handle
    s.append(Shape(tube(wave(48, 8, 6, 3, 0.5, steps=6), 2.5, 2), (70, 60, 72)))           # scroll, like a lute peg
    s.append(Shape(bell_mask(48, 20, 48, 46, 5), plum))
    s.append(Shape(polygon([(19, 63), (77, 63), (76, 67), (20, 67)]), (190, 150, 70), outline=(70, 50, 20)))   # tarnished gold lip
    img = render(s)
    d = ImageDraw.Draw(img)
    d.line([(55, 26), (58, 33), (54, 38), (59, 45)], fill=(206, 150, 255, 255))           # glowing crack
    d.line([(56, 26), (59, 33), (55, 38), (60, 45)], fill=(120, 80, 170, 255))
    # narrowed, sorrowful eyes
    for x in (37, 52):
        d.polygon([(x, 44), (x + 7, 42), (x + 6, 46), (x + 1, 46)], fill=(255, 230, 120, 255))
        d.point([(x + 3, 44), (x + 4, 44)], fill=(40, 20, 40, 255))
    d.line([(45, 54), (51, 54)], fill=(40, 26, 50, 255))
    # suckers on the tentacles
    px = img.load()
    for y in range(64, 92, 3):
        for x in range(20, 76):
            if px[x, y][3] and px[x, y][:3] == (62, 44, 88) and (x + y) % 4 == 0:
                px[x, y] = (150, 120, 190, 255)
    return drop_to_ground(img, 92)


def chorumbra():
    ice = (34, 38, 70)
    s = []
    # a curtain of long trailing tentacles
    for i, x in enumerate(range(22, 76, 6)):
        ph = i * 0.9
        s.append(Shape(tube(wave(x, 48, 42, 4, 0.9, phase=ph, drift=(x - 48) * 0.25, steps=18), 4, 1.2),
                       (40, 30, 64), light=(150, 110, 210), dark=(24, 18, 40)))
    # two long arm tentacles that "play" like a conductor
    s.append(Shape(tube([(20, 48), (8, 52), (3, 42), (6, 32), (12, 30)], 3.5, 1.5), (52, 38, 82), light=(170, 130, 230)))
    s.append(Shape(tube([(76, 48), (88, 52), (93, 42), (90, 32), (84, 30)], 3.5, 1.5), (52, 38, 82), light=(170, 130, 230)))
    # the black-ice bell, wide like a jellyfish
    dome = mask_from(lambda d: d.pieslice([10, 4, 86, 78], 180, 360, fill=1)) | polygon([(10, 41), (86, 41), (82, 50), (14, 50)])
    s.append(Shape(dome, ice, light=(70, 96, 150), dark=(14, 14, 30), outline=(6, 6, 14), rim=3, shadow=4,
                   highlight={(24 + i, 18 - i // 2) for i in range(6)} | {(22, 21), (23, 22), (30, 13), (31, 13)}))
    s.append(Shape(polygon([(12, 46), (84, 46), (80, 52), (16, 52)]), (120, 200, 240), outline=(30, 60, 90)))   # frosted rim
    img = render(s)
    d = ImageDraw.Draw(img)
    # swirls inside the translucent black ice
    for k, (cx, cy, r) in enumerate(((34, 22, 9), (62, 20, 8), (48, 12, 6))):
        d.arc([cx - r, cy - r, cx + r, cy + r], 200, 330, fill=(60, 74, 128, 255))
    # fairy sparkles drifting off it
    for (x, y) in ((6, 12), (90, 10), (8, 70), (88, 74)):
        d.point([(x, y), (x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)], fill=(255, 190, 235, 255))
    # the Pendant of Black Ice set into the bell
    d.polygon([(48, 28), (53, 34), (48, 40), (43, 34)], fill=(190, 150, 255, 255), outline=(60, 30, 100, 255))
    d.point([(47, 31), (46, 33)], fill=(255, 255, 255, 255))
    # glowing eyes, wide apart
    for x in (30, 60):
        d.ellipse([x, 30, x + 6, 36], fill=(255, 120, 200, 255)); d.point([(x + 2, 32)], fill=(255, 255, 255, 255))
    # frost glints
    for (x, y) in ((70, 14), (76, 22), (18, 30)):
        d.point([(x, y), (x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)], fill=(200, 240, 255, 255))
    return drop_to_ground(img, 94)


# --- final forms built on an existing sprite: new colours plus new details -----
AUTOGEN = "/home/claude/pif-682/Graphics/Battlers/spritesheets_autogen"


def base_sprite(dex):
    sheet = Image.open(f"{AUTOGEN}/{dex}.png").convert("RGBA")
    x, y = (dex % 10) * 96, (dex // 10) * 96
    return sheet.crop((x, y, x + 96, y + 96))


def recolour(img, table):
    img = img.copy(); px = img.load()
    for y in range(img.height):
        for x in range(img.width):
            p = px[x, y]
            if p[3] and p[:3] in table:
                px[x, y] = table[p[:3]] + (p[3],)
    return img


def sparkle(d, x, y, c=(235, 250, 255), big=False):
    pts = [(x, y), (x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)]
    if big:
        pts += [(x - 2, y), (x + 2, y), (x, y - 2), (x, y + 2)]
    d.point(pts, fill=c + (255,))


def rimirage():
    """Alerion's final form: Zoroark wrapped in frost and illusion."""
    img = recolour(base_sprite(338), {
        (128, 11, 48): (88, 168, 220), (172, 16, 65): (150, 220, 250), (75, 7, 28): (40, 92, 150),
        (205, 74, 90): (225, 248, 255),
        (98, 98, 106): (48, 54, 92), (73, 73, 79): (33, 38, 68), (138, 138, 144): (84, 96, 140),
        (49, 131, 131): (150, 90, 230), (24, 180, 180): (205, 150, 255),
    })
    px = img.load(); d = ImageDraw.Draw(img)
    # frost crystals on the tips of the mane: the topmost light-blue pixel of each column
    for x in range(0, 96, 3):
        for y in range(96):
            if px[x, y][3] and px[x, y][:3] in ((150, 220, 250), (88, 168, 220)):
                if (x // 3) % 3 == 0:
                    sparkle(d, x, max(1, y - 2))
                break
    # an illusory twin: a faint mirrored afterimage behind it
    ghost = img.transpose(Image.FLIP_LEFT_RIGHT)
    ghost.putalpha(ghost.getchannel("A").point(lambda a: 60 if a else 0))
    out = Image.new("RGBA", img.size, (0, 0, 0, 0))
    out.alpha_composite(ghost, (-6, -3))
    out.alpha_composite(img)
    for (x, y) in ((8, 20), (86, 30), (14, 70)):
        sparkle(ImageDraw.Draw(out), x, y, (190, 230, 255), big=True)
    return drop_to_ground(out, 92)


def gloamcap():
    """Wyn's final form: the mushroom has taken the husk; shadow and spore."""
    img = recolour(base_sprite(47), {
        (238, 49, 49): (112, 72, 172), (177, 36, 36): (78, 48, 130), (105, 21, 21): (44, 26, 82),
        (242, 101, 101): (152, 112, 212),
        (165, 79, 36): (118, 114, 140), (97, 46, 21): (70, 66, 92), (222, 106, 49): (168, 164, 190),
        (230, 144, 101): (206, 200, 222),
        (255, 213, 82): (120, 255, 210), (255, 223, 126): (196, 255, 236), (191, 161, 68): (70, 190, 160),
    })
    bb = img.getbbox()
    cx = (bb[0] + bb[2]) // 2
    # a second, wider cap growing behind the first, and a veil of shadow under it
    back = []
    for i, x in enumerate(range(bb[0] - 2, bb[2] + 3, 5)):
        back.append(Shape(tube(wave(x, bb[1] + 30, 34, 2, 0.8, phase=i * 1.3, steps=12), 3, 1),
                          (40, 30, 66), light=(90, 70, 130), dark=(24, 18, 40)))
    cap = mask_from(lambda dd: dd.pieslice([bb[0] - 10, bb[1] - 14, bb[2] + 10, bb[1] + 46], 180, 360, fill=1))
    back.append(Shape(cap, (92, 58, 150), light=(150, 112, 212), dark=(54, 34, 96), outline=(26, 14, 48), rim=3))
    under = render(back)
    ud = ImageDraw.Draw(under)
    for (x, y) in ((bb[0] - 4, bb[1] + 4), (bb[2] + 2, bb[1] + 2), (cx - 18, bb[1] - 6), (cx + 14, bb[1] - 8)):
        ud.ellipse([x, y, x + 3, y + 2], fill=(120, 255, 210, 255))
    under.alpha_composite(img)
    img = under
    # glowing eyes instead of white ones
    px = img.load()
    for y in range(96):
        for x in range(96):
            if px[x, y][3] and px[x, y][:3] in ((247, 238, 247), (213, 213, 213)):
                px[x, y] = (120, 255, 210, 255)
    d = ImageDraw.Draw(img)
    # drifting spore-lights and ghost wisps
    for (x, y, r) in ((14, 30, 3), (82, 22, 2), (76, 52, 3), (20, 60, 2), (48, 8, 2)):
        d.ellipse([x - r, y - r, x + r, y + r], fill=(120, 255, 210, 200))
        d.point([(x, y - r - 1), (x, y - r - 2)], fill=(196, 255, 236, 160))
    return drop_to_ground(img, 92)


import lute_line
SPECIES_ART = {"LUTLING": lute_line.lutling, "FRETSHADE": lute_line.fretshade, "CHORUMBRA": lute_line.chorumbra,
               "RIMIRAGE": rimirage, "GLOAMCAP": gloamcap}


def sheet(out, names):
    ims = [Image.open(os.path.join(out, f"{n}.png")) for n in names]
    s = Image.new("RGBA", (len(ims) * 100, 100), (66, 74, 96, 255))
    for i, im in enumerate(ims):
        s.alpha_composite(im, (i * 100 + 2, 2))
    return s.resize((s.width * 3, s.height * 3), Image.NEAREST)


if __name__ == "__main__":
    out = sys.argv[1]
    os.makedirs(out, exist_ok=True)
    for n, fn in SPECIES_ART.items():
        fn().save(os.path.join(out, f"{n}.png"))
    sheet(out, list(SPECIES_ART)).save(os.path.join(out, "_sheet.png"))
    print("ok")
