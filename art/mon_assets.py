"""Game-ready files for the new Pokémon: 288x288 battle sprites (3x) and
128x64 two-frame party icons.  python3 mon_assets.py <mons folder> <out root>"""
import os, sys
from PIL import Image

src, out = sys.argv[1], sys.argv[2]
os.makedirs(f"{out}/Battlers/special", exist_ok=True)
os.makedirs(f"{out}/Pokemon/Icons", exist_ok=True)
for f in sorted(os.listdir(src)):
    if f.startswith("_") or not f.endswith(".png"):
        continue
    key = f[:-4]
    im = Image.open(os.path.join(src, f)).convert("RGBA")
    im.resize((288, 288), Image.NEAREST).save(f"{out}/Battlers/special/FT_{key}.png")
    bb = im.getbbox()
    art = im.crop(bb)
    scale = min(56 / art.width, 52 / art.height, 0.6)
    small = art.resize((max(1, round(art.width * scale)), max(1, round(art.height * scale))), Image.BOX)
    # crisp edges: snap alpha
    small.putalpha(small.getchannel("A").point(lambda a: 255 if a > 110 else 0))
    icon = Image.new("RGBA", (128, 64), (0, 0, 0, 0))
    x = 32 - small.width // 2
    icon.alpha_composite(small, (x, 60 - small.height))
    icon.alpha_composite(small, (64 + x, 58 - small.height))
    icon.save(f"{out}/Pokemon/Icons/{key}.png")
    print(key)
