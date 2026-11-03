"""Tamsin and Hellen, redrawn in the game's own style: palette swaps of
Infinite Fusion's Black/White-style sprites, so the outlines, proportions,
shading and walk cycles are the base game's. Shared palettes keep each
character's overworld and battle pictures the same colours (Tamsin and Hellen
share the Brightrun chestnut hair and brown skin).
  Tamsin:  overworld BW (90) (bob, jacket)      battle CAMPER (outdoorsy, pack)
  Hellen:  overworld BW (73) (bonnet, apron)    battle POKEMONBREEDER (apron)
Usage: python3 recolor_tamsin_hellen.py <game dir> <out dir>"""
import sys, os
from PIL import Image
GAME, OUT = sys.argv[1], sys.argv[2]
H = lambda s: tuple(int(s[i:i + 2], 16) for i in (0, 2, 4))

AUBURN = {"hi": "b0703e", "lt": "8a5030", "md": "6b3b24", "dk": "4a2616", "dd": "2e160c"}   # chestnut, as first drawn
FOREST = {"lt": "7fc07a", "md": "2f7a3e", "dk": "1d4a2a"}
BROWN = {"lt": "8a6a48", "md": "5c3f28", "dk": "3a2a1c"}
# The Brightruns are brown-skinned (as the first drawings of them were); the base sprites' skin ramps map to this.
SKIN = {"lt": "c48a5c", "md": "a46a40", "dk": "7d4a2c", "dd": "5a3020"}
OW_SKIN = {"f7cfb6": SKIN["lt"], "cf966f": SKIN["dk"]}
WINE = {"lt": "c25a4a", "md": "9a3a3a", "dk": "6a2a2e", "dd": "3e1a20"}

def swap(src, dst, table, regions=None):
    """table: {hex: hex}; regions: [(where, {hex: hex})] applied first, for colours
    a sprite reuses in two places (hair and trousers, a vest and a pack). where is
    a fraction of the frame's height (above it), or a test f(x, y) on the
    pixel's place in its frame, 0..1."""
    im = Image.open(src).convert("RGBA")
    px = im.load()
    t = {H(k): H(v) for k, v in table.items()}
    regs = [(f, {H(k): H(v) for k, v in m.items()}) for f, m in (regions or [])]
    fw, fh = im.width // (4 if "Characters" in src else 1), im.height // (4 if "Characters" in src else 1)
    for y in range(im.height):
        fy = (y % fh) / fh
        for x in range(im.width):
            fx = (x % fw) / fw
            r, g, b, a = px[x, y]
            if a == 0:
                continue
            c = (r, g, b)
            done = False
            for f, m in regs:
                inside = f(fx, fy) if callable(f) else fy < f
                if inside and c in m:
                    px[x, y] = m[c] + (a,)
                    done = True
                    break
            if not done and c in t:
                px[x, y] = t[c] + (a,)
    os.makedirs(os.path.dirname(dst), exist_ok=True)
    im.save(dst)
    print("wrote", dst)

C, T = f"{GAME}/Graphics/Characters", f"{GAME}/Graphics/Trainers"
# --- Tamsin --------------------------------------------------------------------------
swap(f"{C}/BW (90).png", f"{OUT}/Characters/FT_tamsin.png", {
    "4d1812": AUBURN["dk"], "6d2f2b": AUBURN["md"], "89502f": AUBURN["lt"], "ac6c46": AUBURN["hi"],
    "297081": FOREST["md"], "114f51": FOREST["dk"], "6bc0de": FOREST["lt"],
    "b5986e": BROWN["lt"], "4b432b": BROWN["dk"],
    "6e6e6e": "3f6b2a", "bbc3ce": "8fc46a", **OW_SKIN})   # the headset becomes a leaf clip
tam_battle = {                                                               # the vest: Rootwarden green
    "52a494": "4f9a52", "5a6294": FOREST["md"], "8b8bb4": FOREST["lt"], "314162": FOREST["dk"],
    "5a7b7b": BROWN["lt"],
    "414a52": BROWN["md"], "393139": BROWN["dk"],                            # trousers, boots
    "ffd5bd": SKIN["lt"], "dea47b": SKIN["md"], "bd7b62": SKIN["dk"], "7b4a5a": SKIN["dd"]}
tam_pack = {"52a494": "c8a070", "5a6294": "a07a48", "8b8bb4": "d8b888", "314162": "6a4a2a"}   # the pack: tan leather
tam_head = {"414a52": AUBURN["md"], "393139": AUBURN["dk"]}                  # the same two greys are hair up top
for k in ("FT_TAMSIN_I", "FT_TAMSIN_G", "FT_TAMSIN_F"):
    swap(f"{T}/CAMPER.png", f"{OUT}/Trainers/{k}.png", tam_battle, [(0.30, tam_head), (lambda x, y: x >= 0.59, tam_pack)])
# --- Hellen --------------------------------------------------------------------------
swap(f"{C}/BW (73).png", f"{OUT}/Characters/FT_hellen.png", {
    "559262": WINE["md"], "68818d": WINE["dk"], "2d4966": WINE["dd"],
    "a3c9c8": "d8ccb4",                                                      # apron and bonnet shade: warm linen
    "907148": AUBURN["md"], "4b432b": AUBURN["dk"], "2e2212": AUBURN["dd"], **OW_SKIN})
swap(f"{T}/POKEMONBREEDER.png", f"{OUT}/Trainers/FT_HEARTH_LEADER.png", {
    "ad4a4a": WINE["md"], "de6b6b": WINE["lt"],                               # dress
    "84ad6b": "eeeef7", "4a635a": "b8ae98",                                   # headscarf: linen white
    "ffd6bd": SKIN["lt"], "dea57b": SKIN["md"], "bd7b63": SKIN["dk"]},
    [(0.32, {"846b52": AUBURN["md"], "423121": AUBURN["dd"]})])               # hair (the same browns are boots below)
