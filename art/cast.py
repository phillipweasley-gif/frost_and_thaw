"""The Frost & Thaw cast: builds each character's overworld sheet (320x320, 4x4
frames of 80px) and trainer picture (160x160) from Infinite Fusion's outfit
layers, then adds what the layers can't: goblin and tabaxi skin, pointed
ears, eye colour, and shorter builds for dwarves, goblins and halflings.
python3 cast.py <out folder> [name ...]"""
import os, sys, colorsys
from PIL import Image
import compose as C

HAIR_EXTRA = "/home/claude/frost-thaw/build/hair"   # our red/auburn/white/ice hair


def hair_layer(hair, kind):
    img = C.hair_layer(hair, kind)
    if img: return img
    version, name = hair.split("_", 1)
    p = f"{HAIR_EXTRA}/{name}/hair_{version}_{name}.png" if kind == "walk" else \
        f"{HAIR_EXTRA}/{name}/hair_trainer_{version}_{name}.png"
    return Image.open(p).convert("RGBA") if os.path.exists(p) else None


# --- colour helpers -----------------------------------------------------------
def map_pixels(img, fn):
    img = img.copy(); px = img.load()
    for y in range(img.height):
        for x in range(img.width):
            p = px[x, y]
            if p[3]: px[x, y] = fn(p)
    return img


def skin_shift(hue_deg, sat=1.0, val=1.0):
    """Recolour skin tones (warm hues) only, keeping outlines and eye whites."""
    def fn(p):
        r, g, b, a = p
        h, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
        if s < 0.12 or v < 0.12 or not (h < 0.14 or h > 0.95):
            return p
        r2, g2, b2 = colorsys.hsv_to_rgb((h + hue_deg / 360) % 1, min(1, s * sat), min(1, v * val))
        return (int(r2 * 255), int(g2 * 255), int(b2 * 255), a)
    return fn


SKINS = {
    "goblin": skin_shift(78, 0.85, 0.95),
    "tabaxi": skin_shift(14, 1.25, 1.05),
    "stone":  skin_shift(190, 0.25, 0.95),
}


def eye_colour(img, rgb, box):
    """Recolour the iris pixels (cool, mid-dark) inside box."""
    px = img.load(); x0, y0, x1, y1 = box
    for y in range(y0, y1):
        for x in range(x0, x1):
            r, g, b, a = px[x, y]
            if a and b > r + 8 and 40 < b < 200:
                k = b / 255
                px[x, y] = (int(rgb[0] * k * 1.3), int(rgb[1] * k * 1.3), int(rgb[2] * k * 1.3), a)


# --- pointed ears ---------------------------------------------------------------
EARS = {
    # trainer picture (left ear; the right one is mirrored), then overworld size
    "elf": (["X...",
             "XX..",
             "XsX.",
             ".XsX",
             ".XsX",
             "..XX"],
            ["X.",
             "XX",
             "Xs"]),
    "goblin": (["XX.....",
                "XsXX...",
                ".XssXXX",
                "..Xsssd",
                "...XXXX"],
               ["XX..",
                "XsXX",
                ".XXX"]),
}


def skin_palette(spec):
    """Light and shadow skin colours for this character's skin tone."""
    base = C.base(spec.get("skin", "default"), "trainer")
    light, dark = base.getpixel((80, 70)), base.getpixel((84, 100))
    if spec.get("skin_fx"):
        fx = SKINS[spec["skin_fx"]]
        light, dark = fx(light), fx(dark)
    return light[:3], dark[:3]


def stamp(img, pattern, x, y, light, dark, mirror=False):
    for j, row in enumerate(pattern):
        for i, ch in enumerate(row):
            if ch == ".": continue
            xx = x - i if mirror else x + i
            if 0 <= xx < img.width and 0 <= y + j < img.height:
                img.putpixel((xx, y + j), {"X": (28, 18, 18), "s": light, "d": dark}[ch] + (255,))


def add_ears(img, kind, ear, light, dark):
    big, small = EARS[ear]
    w = len(big[0])
    if kind == "trainer":
        stamp(img, big, 70 - w, 40, light, dark)
        stamp(img, big, 97 + w, 42, light, dark, mirror=True)
        return
    ws = len(small[0])
    for f in range(4):
        ox, oy = f * 80, (-2 if f % 2 else 0)
        for row in (0, 3):                      # facing down / up: both ears
            y = row * 80 + 36 + oy
            stamp(img, small, ox + 23 - ws, y, light, dark)
            stamp(img, small, ox + 56 + ws, y, light, dark, mirror=True)
        stamp(img, small, ox + 53 + ws, 80 + 36 + oy, light, dark, mirror=True)   # facing left
        stamp(img, small, ox + 27 - ws, 160 + 36 + oy, light, dark)               # facing right


# --- shorter builds ---------------------------------------------------------------
def remove_rows(img, rows, top=0, bottom=None):
    """Delete the given rows (inside top..bottom) and drop everything above them
    down to close the gap, so feet stay on the ground."""
    bottom = img.height if bottom is None else bottom
    out = img.copy()
    region = img.crop((0, top, img.width, bottom))
    keep = [y for y in range(region.height) if (y + top) not in rows]
    new = Image.new("RGBA", region.size, (0, 0, 0, 0))
    n = len(keep)
    for i, y in enumerate(keep):
        new.paste(region.crop((0, y, region.width, y + 1)), (0, region.height - n + i))
    out.paste(new, (0, top))
    # clear the strip that was pasted over with transparency first
    return out


def shorten(walk, trainer, every):
    """Shorter build: drop every Nth row between the shoulders and the ankles."""
    trainer = remove_rows(trainer, set(range(64, 150, every)))
    for row in range(4):
        walk = remove_rows(walk, set(range(row * 80 + 47, row * 80 + 70, every)), row * 80, row * 80 + 80)
    return walk, trainer


# --- the cast -----------------------------------------------------------------------
CAST = {
    # The Heralds
    "alerion":     dict(skin="1", hair="4_lady", clothes="iceoutfit", ears="elf", eyes=(150, 90, 230),
                        note="Eladrin ranger. Dark skin, long black hair, violet eyes with a frost glow."),
    "alberica":    dict(skin="4", hair="6_boxbraids", clothes="fantasyadventurersoutfit", hat="beret", hat_hue=-60,
                        short=5, note="Dwarf bard. Red braids, travelling performer's coat, a plum beret."),
    "reptin":      dict(skin="5", hair="2_wavy", clothes="grassexpert", ears="elf",
                        note="Elf druid under a werewolf curse. Plain woodland greens, an herb satchel."),
    "meat_meat":   dict(skin="3", skin_fx="goblin", hair="8_lady", clothes="gothhoodie", hat="goggles",
                        ears="goblin", short=4, eyes=(150, 90, 230),
                        note="Goblin rogue. Green skin, long white hair, violet eyes, dark hoodie, goggles."),
    "wyn":         dict(skin="2", hair="8_shortcut", clothes="ghostoutfit", hat="parashroom", hat_hue=230,
                        note="Circle of Spores druid, God of Shadow. White hair, shadow robes, a dusk-purple mushroom cap."),
    # Act I companions
    "shade":       dict(skin="3", hair="4_emo", clothes="cloak", hat="kogascarf", hat_hue=150,
                        note="Smuggler. Dark cloak, a long sea-green scarf, leather gloves, a cursed dagger."),
    "shimmer":     dict(skin="5", hair="8_highpony", clothes="adventurer_f",
                        note="Shade's partner. Silver ponytail, sharp eyes, hand on her blade."),
    "glimmer":     dict(skin="4", skin_fx="tabaxi", hair="1_short1", clothes="psyshaman", hat="cutecatears", hat_hue=10,
                        note="Tabaxi warlock, the Dagger Reborn. Golden fur, acolyte robes."),
    # Rootspire
    "philodendra": dict(skin="3", skin_fx="goblin", hair="4_highbun", clothes="floraldress", clothes_hue=-25,
                        hat="laurelwreath", hat_hue=-70, ears="goblin", short=4,
                        note="Goblin, Meat Meat's mother, the Autumn seat. Autumn-leaf dress and wreath."),
    "anduin":      dict(skin="4", hair="3_short1", clothes="dragonconqueror", clothes_hue=180,
                        note="Reptin's husband, the Summer seat. A sun-gold ceremonial coat."),
    "pip":         dict(skin="5", hair="6_bob", clothes="fossilseeker", hat="smallbarrette", short=4,
                        note="Cocoon spinner who sews pockets into everything. A vest made of pockets."),
}


def build(name, spec):
    s = dict(spec)
    out = {}
    for kind in ("walk", "trainer"):
        img = C.base(s.get("skin", "default"), kind).copy()
        if s.get("skin_fx"):
            img = map_pixels(img, SKINS[s["skin_fx"]])
        c = C.clothes_layer(s["clothes"], kind)
        if c: img.alpha_composite(C.hue(c, s.get("clothes_hue", 0)))
        if kind == "trainer" and s.get("eyes"):
            eye_colour(img, s["eyes"], (70, 40, 96, 52))
        hr = hair_layer(s["hair"], kind) if s.get("hair") else None
        if hr: img.alpha_composite(C.hue(hr, s.get("hair_hue", 0)))
        if s.get("ears"):
            add_ears(img, kind, s["ears"], *skin_palette(s))
        for key in ("hat2", "hat"):
            ht = C.hat_layer(s.get(key), kind)
            if not ht: continue
            ht = C.hue(ht, s.get(key + "_hue", 0))
            if kind == "walk": C.paste_hat_overworld(img, ht)
            else: img.alpha_composite(ht)
        out[kind] = img
    walk, trainer = out["walk"], out["trainer"]
    if s.get("short"):
        walk, trainer = shorten(walk, trainer, s["short"])
    return walk, trainer


def main(dest, names):
    os.makedirs(dest, exist_ok=True)
    for n in names or CAST:
        walk, trainer = build(n, CAST[n])
        walk.save(os.path.join(dest, f"{n}_walk.png"))
        trainer.save(os.path.join(dest, f"{n}_trainer.png"))
    print("built", len(names or CAST))


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2:])
