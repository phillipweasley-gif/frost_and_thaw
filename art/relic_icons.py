"""Item icons for the Rootspire relics and goods (48x48, Infinite Fusion's item style).
Most are recoloured from Infinite Fusion's own icons (outlines kept); the dagger and
the staff are drawn, since the game has no icon shaped like them."""
import colorsys
from PIL import Image, ImageDraw
SRC = "/home/claude/pif-682/Graphics/Items/"
OUT = "/home/claude/frost-thaw/build/items/"

def recolour(name, fn):
    im = Image.open(SRC + name + ".png").convert("RGBA")
    px = im.load()
    for y in range(im.height):
        for x in range(im.width):
            r, g, b, a = px[x, y]
            if a == 0:
                continue
            h, l, s = colorsys.rgb_to_hls(r / 255, g / 255, b / 255)
            if l < 0.16:            # outline: keep
                continue
            h2, l2, s2 = fn(h, l, s)
            rr, gg, bb = colorsys.hls_to_rgb(h2 % 1, max(0, min(1, l2)), max(0, min(1, s2)))
            px[x, y] = (int(rr * 255), int(gg * 255), int(bb * 255), a)
    return im

def to_hue(hue, sat=None, light=0.0):
    return lambda h, l, s: (hue, l + light, s if sat is None else sat * (0.4 + s))

def outline(img):
    """1-px dark outline round every opaque pixel, like the game's icons."""
    w, h = img.size
    src = img.load()
    out = img.copy(); o = out.load()
    for y in range(h):
        for x in range(w):
            if src[x, y][3]:
                continue
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                xx, yy = x + dx, y + dy
                if 0 <= xx < w and 0 <= yy < h and src[xx, yy][3] and src[xx, yy][:3] != (40, 32, 40):
                    o[x, y] = (40, 32, 40, 255); break
    return out

def dagger():
    im = Image.new("RGBA", (48, 48)); d = ImageDraw.Draw(im)
    # blade: mirrored steel, a green crystal vein down the middle (a goblin-sized curve)
    blade = [(30, 9), (34, 11), (24, 27), (19, 31), (17, 29), (22, 23)]
    d.polygon(blade, fill=(196, 212, 222))
    d.line([(31, 11), (21, 28)], fill=(236, 246, 250), width=1)
    d.line([(29, 13), (21, 25)], fill=(72, 190, 104), width=2)
    d.line([(30, 13), (22, 25)], fill=(150, 236, 150), width=1)
    # guard and grip
    d.line([(13, 26), (22, 35)], fill=(120, 96, 64), width=3)
    d.line([(13, 26), (22, 35)], fill=(170, 140, 90), width=1)
    d.line([(17, 31), (10, 38)], fill=(90, 70, 52), width=4)
    d.line([(16, 31), (11, 36)], fill=(130, 104, 74), width=1)
    d.ellipse([7, 37, 12, 42], fill=(72, 190, 104))
    return outline(im)

def staff():
    im = Image.new("RGBA", (48, 48)); d = ImageDraw.Draw(im)
    # gnarled root bound in wolf hide, a gem flickering emerald and pearl
    d.line([(9, 41), (33, 13)], fill=(104, 72, 44), width=4)
    d.line([(10, 39), (32, 14)], fill=(150, 108, 66), width=1)
    for t in (0.35, 0.5):
        x, y = 9 + (33 - 9) * t, 41 + (13 - 41) * t
        d.line([(x - 3, y - 2), (x + 3, y + 3)], fill=(222, 214, 200), width=2)   # hide strips
    d.line([(31, 15), (27, 9)], fill=(104, 72, 44), width=2)                      # root prongs
    d.line([(33, 13), (39, 10)], fill=(104, 72, 44), width=2)
    d.ellipse([30, 6, 40, 16], fill=(70, 200, 130))
    d.pieslice([30, 6, 40, 16], 200, 360, fill=(236, 240, 232))
    d.ellipse([33, 8, 35, 10], fill=(255, 255, 255))
    return outline(im)

icons = {
    "FT_VERDANTBLADE": dagger(),
    "FT_HEARTWARDENSTAFF": staff(),
    "FT_RIMEMANTLE": recolour("SILKSCARF", lambda h, l, s: (0.56, l * 0.9 + 0.08, 0.45)),
    "FT_WHISPERKEY": recolour("CAPTAINSKEY", lambda h, l, s: (0.55, l + 0.12, 0.35)),
    "FT_SAPSALVE": recolour("SUPERPOTION", lambda h, l, s: (0.11, l + 0.02, 0.85)),
    "FT_RENEWALSEED": recolour("MIRACLESEED", lambda h, l, s: (0.22, l + 0.05, 0.75)),
    "FT_SPORELANTERN": recolour("TINYMUSHROOM", lambda h, l, s: (0.42, l + 0.1, 0.6)),
    "FT_SPORECHIME": recolour("SOOTHEBELL", lambda h, l, s: (0.08, l * 0.85, 0.35)),
    "FT_AURORALMOTE": recolour("COMETSHARD", lambda h, l, s: (0.38 if l > 0.5 else 0.85, l, 0.7)),
    "FT_FROSTSIGIL": recolour("ICESTONE", lambda h, l, s: (0.58, l + 0.05, 0.55)),
}
for k, im in icons.items():
    im.save(OUT + k + ".png")
sheet = Image.new("RGBA", (len(icons) * 56, 56), (255, 255, 255, 255))
for i, im in enumerate(icons.values()):
    sheet.paste(im, (i * 56 + 4, 4), im)
sheet.resize((sheet.width * 2, sheet.height * 2), Image.NEAREST).save(
    "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/x2/relics.png")
print("ok", len(icons))
