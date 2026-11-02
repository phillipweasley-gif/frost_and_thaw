"""Frost & Thaw's new Pokemon as fusion parts: their sprites, the face piece each one brings
when it is the HEAD, and where a foreign head goes when it is the BODY.

python3 ft_fusion_parts.py <out folder>   writes parts.json + PNGs for the fusion generator."""
import json, math, os, sys
from PIL import Image
import final_line as F
import mons
from clean import (N, Layer, compose, paint, to_mask, smooth_poly_mask, ellipse_pts, outline_of, selout)
from silhouettes import curl

NUMBERS = {"LUTLING": 577, "HAUNTELLO": 578, "CHORUMBRA": 579, "RIMIRAGE": 580, "GLOAMCAP": 581}


def blank():
    return Image.new("RGBA", (N, N), (0, 0, 0, 0))


def crop(img):
    return img.crop(img.getbbox())


# --- face pieces (drawn at any size, so they never need resampling) ----------------------
def lute_face(d):
    """The gold rosette with the spirit peeking out: Lutling's face."""
    img = blank(); c = 48.0; R = d / 2
    petals = [ellipse_pts(c + math.cos(math.radians(a)) * R * 0.82, c + math.sin(math.radians(a)) * R * 0.82, R * 0.3, R * 0.3, 14)
              for a in range(0, 360, 30)]
    ring = to_mask(smooth_poly_mask(petals), 0.45, False)
    paint(img, ring, F.GOLD[2]); paint(img, outline_of(ring), F.GOLD[0])
    hole = to_mask(smooth_poly_mask([ellipse_pts(c, c, R * 0.74, R * 0.74, 28)]), 0.45, False)
    paint(img, hole, (34, 12, 44))
    paint(img, {(x, y) for (x, y) in hole if y > c + R * 0.25}, F.SPIRIT[0])
    ew, eh = max(1.4, R * 0.2), max(1.8, R * 0.26)
    for sx in (-1, 1):
        F.eye(img, c + sx * R * 0.3, c - R * 0.05, ew, eh, (190, 130, 250), look=(0.4, 0.2), sclera=(244, 232, 255), outline=(20, 6, 30))
    F.halo(img, hole, F.GLOW, 50)
    return crop(img)


def cello_face(d):
    """The spirit's face bursting through splintered wood: Hauntello's face."""
    img = blank(); c = 48.0; R = d / 2
    jag = []
    for k in range(18):
        a = math.radians(k * 20)
        rr = R * (1.0 if k % 2 else 0.86)
        jag.append((c + math.cos(a) * rr, c + math.sin(a) * rr * 0.9))
    hole = to_mask(smooth_poly_mask([jag]), 0.5, False)
    paint(img, hole, (40, 12, 50))
    paint(img, outline_of(hole), (176, 130, 92))
    over = compose([Layer([ellipse_pts(c + 0.4, c + R * 0.08, R * 0.8, R * 0.7, 40)], F.SPIRIT, depth=5,
                          outline=F.SPIRIT_O, cuts=(-0.1, 0.35, 0.72))])
    img.alpha_composite(over)
    ew, eh = max(1.6, R * 0.24), max(1.8, R * 0.27)
    F.eye(img, c - R * 0.36, c - R * 0.08, ew, eh, (255, 206, 96), lid=0.35, look=(0.5, 0.2), outline=(40, 10, 50))
    F.eye(img, c + R * 0.34, c - R * 0.12, ew, eh, (255, 206, 96), lid=0.25, look=(0.5, 0.2), outline=(40, 10, 50))
    F.smirk(img, [(c - R * 0.35, c + R * 0.34), (c - R * 0.05, c + R * 0.48), (c + R * 0.25, c + R * 0.44), (c + R * 0.45, c + R * 0.3)],
            (40, 10, 50), fang_at=(c + R * 0.15, c + R * 0.42))
    for a in (200, 330):
        fx, fy = c + math.cos(math.radians(a)) * R, c + math.sin(math.radians(a)) * R * 0.9
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(fx, fy, 1.3, 1.3, 12)]), 0.35, False), F.GOLD[2])
    return crop(img)


def harp_face(d):
    """The spirit's own head, crowned with the lute's old pegbox: Chorumbra's face."""
    img = blank(); c = 52.0; R = d / 2
    head = ellipse_pts(48, c, R, R * 0.9, 48)
    crown = curl(48 + R * 0.35, c - R * 1.0, max(3.0, R * 0.5), 200, w=max(2.0, R * 0.3))
    layers = [Layer([head], F.SPIRIT, depth=6, outline=F.SPIRIT_O, cuts=(-0.15, 0.3, 0.7)),
              Layer([crown], F.EBONY, depth=2, outline=F.EBONY_O)]
    img = compose(layers)
    F.rim_light(img, layers[0].mask, F.SPIRIT[3]) if hasattr(F, "rim_light") else None
    ew, eh = max(1.8, R * 0.28), max(2.0, R * 0.31)
    F.eye(img, 48 - R * 0.4, c - R * 0.22, ew, eh, (255, 140, 210), lid=0.2, look=(0.4, 0.2), outline=(40, 10, 60))
    F.eye(img, 48 + R * 0.42, c - R * 0.28, ew, eh, (255, 140, 210), lid=0.12, look=(0.4, 0.2), outline=(40, 10, 60))
    S = F.Stage(1.0, 94)
    F.grin(img, S, 48.4, c + R * 0.24, R * 0.53, R * 0.4, (40, 10, 60), teeth=(255, 250, 255))
    for (gx, gy) in ((48 + R * 0.1, c - R * 1.05), (48 + R * 0.75, c - R * 1.25)):
        paint(img, to_mask(smooth_poly_mask([ellipse_pts(gx, gy, 1.2, 1.2, 12)]), 0.3, False), F.GOLD[2])
    F.halo(img, layers[0].mask, F.GLOW, 80)
    return crop(selout(img))


def cut_face(sprite, cx, cy, rx, ry):
    """A face piece cut from a finished sprite (for the two recoloured lines)."""
    out = blank(); sp, op = sprite.load(), out.load()
    for y in range(N):
        for x in range(N):
            if sp[x, y][3] > 127 and ((x - cx) / rx) ** 2 + ((y - cy) / ry) ** 2 <= 1:
                op[x, y] = sp[x, y]
    return crop(out)


# --- palettes as colour families (for recolouring other Pokemon in these colours) ------------
def fam(ramp):
    return {"cols": [list(c) for c in ramp], "neutral": False}


WOOD = {"HONEY": F.HONEY, "SPRUCE": F.SPRUCE, "WINE": F.WINE, "LACQ": F.LACQ}
KEEP = {"EBONY": F.EBONY, "GOLD": F.GOLD, "SPIRIT": F.SPIRIT, "GLOW": [F.GLOW, F.CORE], "CREAM": [F.CREAM, (214, 204, 186)]}


def build(out):
    os.makedirs(out, exist_ok=True)
    rim, gloam = mons.rimirage(), mons.gloamcap()
    species = {
        "LUTLING":   {"sprite": F.lutling(), "face": lute_face, "anchor": [48, 71, 22], "families": [F.HONEY, F.SPRUCE]},
        "HAUNTELLO": {"sprite": F.hauntello(), "face": cello_face, "anchor": [45.5, 76, 20], "families": [F.WINE, F.SPIRIT]},
        "CHORUMBRA": {"sprite": F.harp(), "face": harp_face, "anchor": [25.5, 23, 22], "families": [F.LACQ, F.SPIRIT]},
        "RIMIRAGE":  {"sprite": rim, "face": cut_face(rim, 32, 41, 14, 13), "anchor": [29, 42, 22], "families": None},
        "GLOAMCAP":  {"sprite": gloam, "face": cut_face(gloam, 55, 32, 15, 11), "anchor": [55, 40, 22], "families": None},
    }
    meta = {"numbers": NUMBERS, "wood": {k: [list(c) for c in v] for k, v in WOOD.items()},
            "keep": {k: [list(c) for c in v] for k, v in KEEP.items()}, "species": {}}
    for key, d in species.items():
        d["sprite"].save(f"{out}/{key}.png")
        faces = {}
        if callable(d["face"]):
            for size in range(10, 31, 2):
                name = f"{key}_face{size}.png"
                d["face"](size).save(f"{out}/{name}")
                faces[size] = name
        else:
            d["face"].save(f"{out}/{key}_face.png")
            faces[0] = f"{key}_face.png"
        meta["species"][key] = {"number": NUMBERS[key], "sprite": f"{key}.png", "faces": faces, "anchor": d["anchor"],
                                "families": [fam(r) for r in d["families"]] if d["families"] else None,
                                "max_face": {"LUTLING": 20, "HAUNTELLO": 22}.get(key, 28),
                                "protect": key in ("LUTLING", "HAUNTELLO", "CHORUMBRA")}
    json.dump(meta, open(f"{out}/parts.json", "w"), indent=1)


if __name__ == "__main__":
    build(sys.argv[1])
