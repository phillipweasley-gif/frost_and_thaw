"""The Alberica hybrids, after the user's final sheet ("The Alberica Fusions", merge_examples_4-6): chunky,
readable instruments nestled into each partner as one of its own parts, the partner keeping its sprite.
Gengar and Gardevoir follow the first sheet (merge_examples_1)."""
import math
import numpy as np
from PIL import Image
from instruments import *
from hybrids import sprite, mask_of, cut, only, compose, lum, is_red, is_pink, is_teal, porcelain, recolour_outline

BULB_G = ((72, 94, 28), (122, 158, 48), (164, 213, 65), (187, 223, 113))
LEAF_G = ((40, 92, 40), (72, 140, 56), (110, 180, 72), (160, 214, 104))
NOIBAT_P = [(64, 45, 85), (108, 76, 143), (146, 103, 193), (173, 141, 208)]
GOLD_BOARD = [(170, 120, 40), (214, 166, 70), (240, 204, 110), (252, 230, 160)]


def layer(fn):
    cv = Canvas()
    fn(cv)
    return cv.image()


def solid(img):
    return np.asarray(img)[..., 3] > 0


# ------------------------------------------------------------------------------------- Bulbasaur line
def bulbasaur_lutling():
    """The bulb is a lute, standing up out of Bulbasaur's back among its leaves, neck up and back."""
    b = sprite("bulbasaur")
    bulb = mask_of(b, lambda x, y, c: c in BULB_G)
    head = mask_of(b, lambda x, y, c: x <= 44 and y >= 34)
    inst = layer(lambda cv: lute(cv, Frame((49.5, 49), 30, 0.25), bowl_w=78, neck_len=40, pegbox_side=-1,
                                  rose_scale=1.25, strings=2))
    lv = Canvas()
    for (bx, by, ang, ln) in ((45, 49, -50, 9), (47, 50, -15, 8), (62, 49, 45, 8), (60, 51, 80, 7)):
        leaf(lv, (bx, by), ang, ln, ramp=BULB_G)
    return compose(cut(b, bulb), inst, lv.image(), only(b, head))


def ivysaur_hauntello():
    """A round, chunky cello sits on Ivysaur's back beside the bud, scroll up and back; leaves in front."""
    b = sprite("ivysaur")
    face = mask_of(b, lambda x, y, c: x <= 52 and y >= 52)
    leaves_front = mask_of(b, lambda x, y, c: y >= 46 and c[1] > c[0] + 15 and c[1] > c[2] + 25)
    inst = layer(lambda cv: cello(cv, Frame((58, 58), 24, 0.31), body_w=74, neck_len=44, endpin=False))
    return compose(b, inst, only(b, leaves_front), only(b, face))


def venusaur_chorumbra():
    """A harp stands at Venusaur's back under the great flower - pillar and neck in wood, the strings
    gold, a rose on the soundbox - the petals arching over it."""
    b = sprite("venusaur")
    petals = mask_of(b, lambda x, y, c: is_pink(c) or (y < 24 and c[0] > 200 and c[1] > 150))
    face = mask_of(b, lambda x, y, c: x <= 66 and y >= 50)
    inst = layer(lambda cv: harp(cv, Frame((70, 70), 4, 0.42), height=100, depth=72))
    return compose(b, inst, only(b, petals), only(b, face))


# ------------------------------------------------------------------------------------------ Zorua line
def flame_tip(cv, at, fr):
    """Zorua's red tail-tip, crowning the lute's neck in place of a pegbox."""
    x, y = at
    for (dx, dy, c) in ((0, -1, (172, 16, 65)), (1, -2, (172, 16, 65)), (-1, -2, (128, 11, 48)), (0, -3, (200, 40, 90)),
                        (2, -4, (172, 16, 65)), (-1, -4, (172, 16, 65)), (1, -5, (230, 90, 130)), (0, -2, (200, 40, 90)),
                        (1, -3, (200, 40, 90)), (-2, -3, (128, 11, 48))):
        cv.put(int(x) + dx, int(y) + dy, c, 6)


def zorua_lutling():
    """Zorua's tail is a lute: the bowl round at its rump, the neck rising up and back, tipped with the
    tail's red tuft."""
    b = sprite("zorua")
    tail = mask_of(b, lambda x, y, c: x >= 58 and 40 <= y <= 60)
    front = mask_of(b, lambda x, y, c: x < 58)
    inst = layer(lambda cv: lute(cv, Frame((63, 62), 28, 0.23), bowl_w=80, neck_len=46, rose_scale=1.25, strings=2,
                                  tip=flame_tip))
    return compose(cut(b, tail), inst, only(b, front))


def zoroark_hauntello():
    """A great red cello rides on Zoroark's back inside the mane, scroll up over its shoulder; the mane
    falls round it."""
    b = sprite("zoroark")
    front = mask_of(b, lambda x, y, c: x <= 44 or y >= 60)
    mane_tufts = mask_of(b, lambda x, y, c: is_red(c) and (x >= 66 or y <= 26))
    inst = layer(lambda cv: cello(cv, Frame((58, 64), 22, 0.38), body_w=74, neck_len=40, endpin=False))
    return compose(b, inst, only(b, mane_tufts), only(b, front))


# ----------------------------------------------------------------------------------------- Noibat line
def noibat_lutling():
    """Noibat's ears are two round lutes seen face-on: gold soundboards with a rose and strings, rimmed in
    the ear's own purple."""
    b = sprite("noibat")
    ears = mask_of(b, lambda x, y, c: y <= 41 and 32 <= x <= 64)
    l1 = layer(lambda cv: lute(cv, Frame((40, 42), -16, 0.2), bowl_w=96, show_neck=False, rose_scale=1.15, strings=2,
                                rib_ramp=NOIBAT_P, side=0.12, rim_col=(64, 45, 85)))
    l2 = layer(lambda cv: lute(cv, Frame((56, 42), 16, 0.2, flip=True), bowl_w=96, show_neck=False, rose_scale=1.15,
                                strings=2, rib_ramp=NOIBAT_P, side=0.12, rim_col=(64, 45, 85)))
    face = mask_of(b, lambda x, y, c: y >= 40 and 36 <= x <= 60)
    return compose(cut(b, ears), l1, l2, only(b, face))


def noivern_chorumbra():
    """Noivern's great ears are harps: the purple rim of each ear is the frame, a gold neck-rail inside it,
    and strings strung down across the teal of the ear."""
    b = sprite("noivern")
    out = b.copy()
    a = np.asarray(out).copy()
    from scipy import ndimage as ndi
    for bx in ((18, 14, 34, 38), (34, 14, 52, 40)):
        x0, y0, x1, y1 = bx
        m = np.zeros(a.shape[:2], bool)
        m[y0:y1 + 1, x0:x1 + 1] = a[y0:y1 + 1, x0:x1 + 1, 3] > 0
        inner = ndi.binary_erosion(m, iterations=2)
        rail = inner & ~ndi.binary_erosion(inner, iterations=1)
        core = ndi.binary_erosion(inner, iterations=1)
        a[core, :3] = (60, 140, 120)
        a[rail, :3] = GOLD[2]
        ys, xs = np.nonzero(core)
        for x in range(xs.min() + 1, xs.max(), 2):
            col = ys[xs == x]
            if len(col):
                a[col.min():col.max() + 1, x, :3] = [GOLD[3] if (x // 2) % 2 else STRING][0]
        ring = m & ~inner
        a[ring, :3] = [tuple(v) for v in [(110, 84, 140)]][0]
    return Image.fromarray(a, "RGBA")


# -------------------------------------------------------------------------------------- Cinderwright line
def wickit_lutling():
    """The lute sits in Wickit's porcelain tail-paddle like a cup: the blue-and-white glaze curls round its
    back, the bowl and rose in front, the neck up to a curled head."""
    b = sprite("wickit")
    inst = layer(lambda cv: lute(cv, Frame((61, 50), 8, 0.21), bowl_w=82, neck_len=40, pegbox_side=-1,
                                  rose_scale=1.2, strings=2))
    return compose(b, inst)


def stoketail_hauntello():
    """A red cello at Stoketail's side, its tail's porcelain curling round the cello's back; scroll high."""
    b = sprite("stoketail")
    inst = layer(lambda cv: cello(cv, Frame((24, 54), 6, 0.33), body_w=76, neck_len=46, endpin=False))
    return compose(b, inst)


def forgel_chorumbra():
    """A harp rises from Forgel's tail: the porcelain arch of the tail is the harp's neck and pillar,
    the soundbox is wood with a rose, gold strings between."""
    b = sprite("forgel")
    paddle = mask_of(b, lambda x, y, c: x <= 33 and y >= 64 and porcelain(c))
    inst = layer(lambda cv: harp(cv, Frame((20, 80), 0, 0.44, flip=True), height=100, depth=80,
                                 frame_ramp=[PORC[1], PORC[2], PORC[3], PORC[4]], box_ramp=LACQ,
                                 outline_col=(24, 44, 120)))
    return compose(cut(b, paddle), inst)


# ------------------------------------------------------------------------------------------- Wyn line
def sableye_lutling():
    """Sableye hugs a round lute to its belly; the chest gem is set in the soundboard as the rose."""
    b = sprite("sableye")
    gem = ((255, 120, 132), (190, 55, 67))
    inst = layer(lambda cv: lute(cv, Frame((49, 65), 0, 0.17), bowl_w=96, show_neck=False, rose_scale=1.2,
                                  strings=2, side=0.08, rose_gem=gem))
    arms = mask_of(b, lambda x, y, c: (x <= 41 or x >= 57) and 46 <= y <= 57)
    return compose(b, inst, only(b, arms))


def sporeye_hauntello():
    """The cello is Sporeye's torso, from the chest down to the endpin between its feet; the neck runs up
    behind its head to the scroll among the glowcaps."""
    b = sprite("sporeye")
    front = mask_of(b, lambda x, y, c: y <= 52 or (y >= 54 and (x <= 38 or x >= 62)))
    inst = layer(lambda cv: cello(cv, Frame((49, 86), 0, 0.34), body_w=66, neck_len=80))
    return compose(b, inst, only(b, front))


def myconarch_chorumbra():
    """Myconarch stands with a harp at its side under the cap, a hand on the strings."""
    b = sprite("myconarch")
    inst = layer(lambda cv: harp(cv, Frame((62, 88), 4, 0.46), height=100, depth=74))
    hand = mask_of(b, lambda x, y, c: 56 <= x <= 72 and 44 <= y <= 60 and c[2] > c[1] + 20)
    cap = mask_of(b, lambda x, y, c: y <= 34)
    return compose(b, inst, only(b, hand), only(b, cap))


# ------------------------------------------------------------------------------------------ sheet 1
def gengar_hauntello():
    """Gengar's belly is the cello's chamber: varnished wood with its f-holes, cracks glowing violet,
    strings from under the grin down to the tailpiece; no neck."""
    b = sprite("gengar")
    inst = layer(lambda cv: cello(cv, Frame((44, 70), 0, 0.2), body_len=100, body_w=125, neck=False, endpin=False,
                                  strings=3, cracks=[[(0.2, 0.3), (0.32, 0.38), (0.45, 0.28)]]))
    grin = mask_of(b, lambda x, y, c: y <= 55)
    arms = mask_of(b, lambda x, y, c: x <= 30 or x >= 60)
    return compose(b, inst, only(b, grin), only(b, arms))


def gardevoir_chorumbra():
    """Gardevoir's crest sweeps back into a wooden harp frame behind her; strings fall from it beside her
    body."""
    b = sprite("gardevoir")
    inst = layer(lambda cv: harp(cv, Frame((56, 60), 8, 0.5), height=100, depth=58, rose=False,
                                 frame_ramp=LACQ, box_ramp=LACQ))
    return compose(inst, b)


PAIRS = {"577.1": bulbasaur_lutling, "578.2": ivysaur_hauntello, "579.3": venusaur_chorumbra,
         "577.399": zorua_lutling, "578.338": zoroark_hauntello, "577.440": noibat_lutling,
         "579.441": noivern_chorumbra, "577.582": wickit_lutling, "578.583": stoketail_hauntello,
         "579.584": forgel_chorumbra, "577.421": sableye_lutling, "578.585": sporeye_hauntello,
         "579.586": myconarch_chorumbra, "578.94": gengar_hauntello, "579.287": gardevoir_chorumbra}

if __name__ == "__main__":
    import sys
    sys.path.insert(0, ".")
    from alb_ops import show
    S = "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/"
    keys = sys.argv[1:] or list(PAIRS)
    show([PAIRS[k]() for k in keys], keys, S + "hyb2.png", z=4)
