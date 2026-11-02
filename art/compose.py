"""Builds character sprites from Infinite Fusion's own outfit layers.
compose(spec) -> (overworld 320x320 RGBA, trainer 160x160 RGBA)"""
import os, colorsys
from PIL import Image
P = "/home/claude/pif-682/Graphics/Characters/player"

def load(path):
    for ext in (".png", ".PNG"):
        if os.path.exists(path + ext):
            return Image.open(path + ext).convert("RGBA")
    return None

def hue(img, degrees):
    if not img or not degrees: return img
    img = img.copy(); px = img.load(); w, h = img.size
    sh = (degrees % 360) / 360.0
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a == 0: continue
            hh, s, v = colorsys.rgb_to_hsv(r / 255, g / 255, b / 255)
            if s < 0.08: continue
            r2, g2, b2 = colorsys.hsv_to_rgb((hh + sh) % 1.0, s, v)
            px[x, y] = (int(r2 * 255), int(g2 * 255), int(b2 * 255), a)
    return img

def base(skin, kind):
    if kind == "walk": return load(f"{P}/base/overworld/{skin}/walk_{skin}") or load(f"{P}/base/overworld/default/walk_default")
    return load(f"{P}/base/trainer/trainer_{skin}") or load(f"{P}/base/trainer/trainer_default")

def hair_layer(hair, kind):
    if not hair: return None
    version, name = hair.split("_", 1)
    if kind == "walk": return load(f"{P}/hair/{name}/hair_{version}_{name}")
    return load(f"{P}/hair/{name}/hair_trainer_{version}_{name}")

def clothes_layer(c, kind):
    return load(f"{P}/clothes/{c}/clothes_{'walk' if kind=='walk' else 'trainer'}_{c}")

def hat_layer(h, kind):
    if not h: return None
    if kind == "walk": return load(f"{P}/hat/{h}/hat_{h}")
    return load(f"{P}/hat/{h}/hat_trainer_{h}")

def paste_hat_overworld(img, hat):
    # hat sheet is one 80px column (4 directions); copy into each of 4 frames,
    # odd frames 2px higher (the walking bob), like the game does
    fw = img.width // 4
    for i in range(4):
        img.alpha_composite(hat, (i * fw, -2 if i % 2 else 0)) if hat.width <= fw else None
    return img

def compose(spec):
    out = {}
    for kind in ("walk", "trainer"):
        img = base(spec.get("skin", "default"), kind).copy()
        c = clothes_layer(spec["clothes"], kind)
        if c: img.alpha_composite(hue(c, spec.get("clothes_hue", 0)))
        hr = hair_layer(spec.get("hair"), kind)
        if hr: img.alpha_composite(hue(hr, spec.get("hair_hue", 0)))
        for key in ("hat2", "hat"):
            ht = hat_layer(spec.get(key), kind)
            if not ht: continue
            ht = hue(ht, spec.get(key + "_hue", 0))
            if kind == "walk": paste_hat_overworld(img, ht)
            else: img.alpha_composite(ht)
        out[kind] = img
    return out["walk"], out["trainer"]
