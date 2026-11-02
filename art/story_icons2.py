"""Act II story key-item icons (48x48), recoloured from Infinite Fusion's own icons."""
import sys
sys.path.insert(0, "/home/claude/frost-thaw/art")
from relic_icons_lib import recolour, dagger, OUT
from PIL import Image
import colorsys

def gold(im):
    px = im.load()
    for y in range(im.height):
        for x in range(im.width):
            r, g, b, a = px[x, y]
            if not a or (r, g, b) == (40, 32, 40): continue
            h, l, s = colorsys.rgb_to_hls(r / 255, g / 255, b / 255)
            rr, gg, bb = colorsys.hls_to_rgb(0.12, min(1, l * 0.95 + 0.05), 0.85)
            px[x, y] = (int(rr * 255), int(gg * 255), int(bb * 255), a)
    return im

icons = {
    "FT_BALANUSSEED": recolour("ROOTFOSSIL", lambda h, l, s: (0.16, l * 0.9 + 0.05, 0.45)),
    "FT_ROOTKEY": recolour("CAPTAINSKEY", lambda h, l, s: (0.6, l * 0.55, 0.35)),
    "FT_DAWNFANG": gold(dagger()),
    "FT_GARAGAIAXE": recolour("PICKAXE", lambda h, l, s: (0.55, l * 0.9 + 0.1, 0.3)),
}
for k, im in icons.items():
    im.save(OUT + k + ".png")
print("ok", list(icons))
