"""Extra player skin tones made from the game's own base bodies, so a Herald who
isn't human can wear any outfit and still look right walking, running, biking,
surfing, fishing and in battle.
  7 = goblin green (from tone 3)
python3 skins.py <output player/base folder>"""
import os, sys
from PIL import Image
import compose as C
from cast import map_pixels, SKINS

EXTRA = {7: ("3", "goblin")}
ACTIONS = ["walk", "run", "bike", "surf", "dive", "fish"]


def main(out):
    for tone, (src, fx) in EXTRA.items():
        d = os.path.join(out, "overworld", str(tone))
        os.makedirs(d, exist_ok=True)
        for a in ACTIONS:
            p = f"{C.P}/base/overworld/{src}/{a}_{src}.png"
            if os.path.exists(p):
                map_pixels(Image.open(p).convert("RGBA"), SKINS[fx]).save(os.path.join(d, f"{a}_{tone}.png"))
        os.makedirs(os.path.join(out, "trainer"), exist_ok=True)
        t = Image.open(f"{C.P}/base/trainer/trainer_{src}.png").convert("RGBA")
        map_pixels(t, SKINS[fx]).save(os.path.join(out, "trainer", f"trainer_{tone}.png"))
    print("ok")


if __name__ == "__main__":
    main(sys.argv[1])
