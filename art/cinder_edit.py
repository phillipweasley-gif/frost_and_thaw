"""The Cinderwright line, refined: hand-drawn Infinite Fusion sprites as the anatomy, repainted.
Wickit  <- Furret's head on Sentret's body (sits up, big round head, curled tail)
Stoketail <- Furret's head on Zangoose's body (lanky, upright, strong forearms)
Forgel  <- Furret's head on Typhlosion's body (big, upright, powerful)
Each is recoloured into the studio palette and given the line's own features."""
import math
from PIL import Image, ImageDraw
from clean import (paint, to_mask, smooth_poly_mask, ellipse_pts, outline_of, thin_line_mask, Layer, compose, ribbon, N)
import final_line as F
from cinder import (RUSSET, CREAM, SOOT, EMBER, PORCELAIN, PORCELAIN_O, COBALT, COBALT_LT, IRON, COPPER, CLAY, CLAY_O,
                    blue_and_white, E)

BASES = "/home/claude/frost-thaw/build/mustelids"
OUTLINE = (44, 20, 14)


def lum(c):
    return 0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2]


def load(name):
    return Image.open(f"{BASES}/{name}.png").convert("RGBA")


def remap(img, table, region=None):
    """Swap exact colours (optionally only inside a region test)."""
    out = img.copy(); px = out.load()
    for y in range(N):
        for x in range(N):
            p = px[x, y]
            if p[3] and p[:3] in table and (region is None or region(x, y)):
                px[x, y] = table[p[:3]] + (p[3],)
    return out


def ramp_map(cols, ramp):
    """Map a family of colours onto a ramp by brightness order."""
    cols = sorted(cols, key=lum)
    return {c: ramp[min(len(ramp) - 1, round(i * (len(ramp) - 1) / max(1, len(cols) - 1)))] for i, c in enumerate(cols)}


def mask_of(img, test):
    px = img.load()
    return {(x, y) for y in range(N) for x in range(N) if px[x, y][3] and test(x, y, px[x, y][:3])}


def ember_tuft(img, x, y, r, lean=-0.2):
    """A candle-flame tuft glowing at a tail tip."""
    tip = (x + lean * r, y - r * 2.0)
    shape = [tip] + ellipse_pts(x, y, r, r * 0.95, 32, -10, 190)[::-1]
    L = Layer([shape], EMBER, depth=4, outline=(150, 70, 14), cuts=(-0.3, 0.2, 0.6))
    piece = compose([L])
    F.halo(img, L.mask, EMBER[2], 140)
    img.alpha_composite(piece)
    paint(img, to_mask(smooth_poly_mask([ellipse_pts(x, y - r * 0.2, r * 0.4, r * 0.5, 16)]), 0.4, False), EMBER[3])
    return L.mask


def soot(img, region_mask):
    """Soot-dark paws: fur in these pixels takes the charcoal ramp, keeping its light and shade."""
    px = img.load()
    cols = sorted({px[p][:3] for p in region_mask if lum(px[p][:3]) > 45}, key=lum)
    m = ramp_map(cols, SOOT[1:]) if cols else {}
    for p in region_mask:
        c = px[p][:3]
        if c in m:
            px[p] = m[c] + (255,)
        elif lum(c) <= 45:
            px[p] = (14, 10, 12, 255)


# =================================================================================================
def wickit():
    img = load("162.161c")
    brown = [(158, 101, 77), (125, 69, 60), (85, 44, 36)]
    cream = [(255, 255, 199), (239, 215, 166), (215, 182, 109)]
    tan = [(199, 158, 69), (174, 134, 44)]
    R = [(92, 36, 26), (138, 60, 36), (182, 92, 50), (216, 128, 74), (240, 170, 116)]
    C = [(206, 170, 126), (232, 206, 164), (248, 230, 196), (255, 246, 224)]
    belly = lambda x, y: ((x - 50) / 9.5) ** 2 + ((y - 43) / 8.5) ** 2 <= 1 and y >= 36
    face = lambda x, y: y < 37 and x < 60 and y > 26
    # fur everywhere except the face and belly turns russet; the tail's bands even out into one curl
    fur = {cream[0]: R[4], cream[1]: R[3], cream[2]: R[2], tan[0]: R[1], tan[1]: R[1],
           brown[0]: R[2], brown[1]: R[1], brown[2]: R[0]}
    img = remap(img, fur, lambda x, y: not belly(x, y) and not face(x, y))
    img = remap(img, {brown[0]: R[2], brown[1]: R[1], brown[2]: R[0],
                      cream[0]: C[3], cream[1]: C[2], cream[2]: C[1], tan[0]: C[0], tan[1]: (176, 132, 92),
                      (16, 16, 16): OUTLINE, (36, 36, 44): (60, 34, 30)})
    img = remap(img, {(16, 16, 16): OUTLINE, (36, 36, 44): (60, 34, 30)})
    soot(img, mask_of(img, lambda x, y, c: 50 <= y <= 57 and 41 <= x <= 61))
    soot(img, mask_of(img, lambda x, y, c: 36 <= y <= 42 and (x <= 44 or x >= 64)))
    px = img.load()
    for p in ((63, 19), (64, 19), (63, 20)):
        px[p] = (0, 0, 0, 0)
    ember_tuft(img, 33.5, 47, 4.6, lean=0.1)
    st = compose([Layer([E(53, 46, 3.6, 2.8, -10)], CLAY, depth=2, outline=CLAY_O)])
    img.alpha_composite(st)
    paint(img, {(52, 45)}, EMBER[2])
    F.halo(img, mask_of(st, lambda x, y, c: True), EMBER[1], 50)
    return img


def preview(fns, path, scale=3):
    out = Image.new("RGBA", (len(fns) * 96 * scale + 20, 96 * scale + 10), (72, 80, 104, 255))
    for i, fn in enumerate(fns):
        out.alpha_composite(fn().resize((96 * scale, 96 * scale), Image.NEAREST), (10 + i * 96 * scale, 5))
    out.save(path)


if __name__ == "__main__":
    preview([wickit], "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/ce1.png", 5)
