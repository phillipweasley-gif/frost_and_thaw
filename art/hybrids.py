"""The Alberica hybrids from the user's example sheets: each partner keeps its own sprite (silhouette,
colours, face); a whole, recognizable instrument takes the place of one body part, drawn as clean pixel
art (instruments.py) where the sheet puts it. Layering: the partner (minus the replaced part) behind, the
instrument, then whatever of the partner sits in front of it on the sheet."""
import math
import numpy as np
from PIL import Image
from instruments import *

PROTO = "/home/claude/frost-thaw/build/proto"


def sprite(name):
    return Image.open(f"{PROTO}/{name}.png").convert("RGBA")


def mask_of(img, test):
    a = np.asarray(img)
    H, W = a.shape[:2]
    m = np.zeros((H, W), bool)
    for y in range(H):
        for x in range(W):
            if a[y, x, 3] and test(x, y, tuple(int(v) for v in a[y, x, :3])):
                m[y, x] = True
    return m


def cut(img, m):
    a = np.asarray(img).copy()
    a[m] = 0
    return Image.fromarray(a, "RGBA")


def only(img, m):
    a = np.asarray(img).copy()
    a[~m] = 0
    return Image.fromarray(a, "RGBA")


def compose(*layers):
    out = Image.new("RGBA", layers[0].size, (0, 0, 0, 0))
    for l in layers:
        out.alpha_composite(l)
    return out


def lum(c):
    return 0.3 * c[0] + 0.59 * c[1] + 0.11 * c[2]


def recolour_outline(inst, col):
    a = np.asarray(inst).copy()
    m = (a[..., 3] > 0) & (np.abs(a[..., :3].astype(int) - np.array(INK)).sum(2) < 10)
    a[m, :3] = col
    return Image.fromarray(a, "RGBA")


def violet_eyes(img, test):
    """Recolour the partner's iris pixels (picked by test) into the haunting's violet, light for light."""
    a = np.asarray(img).copy()
    pts = [(x, y) for y in range(a.shape[0]) for x in range(a.shape[1]) if a[y, x, 3] and test(x, y, tuple(int(v) for v in a[y, x, :3]))]
    if not pts:
        return img
    ls = sorted({lum(tuple(int(v) for v in a[y, x, :3])) for (x, y) in pts})
    lo, hi = ls[0], ls[-1]
    for (x, y) in pts:
        t = 0 if hi == lo else (lum(tuple(int(v) for v in a[y, x, :3])) - lo) / (hi - lo)
        a[y, x, :3] = GLOW[min(3, int(t * 3.99))]
    return Image.fromarray(a, "RGBA")


# ------------------------------------------------------------------------------------- the pairings
def bulbasaur_lutling():
    b = sprite("bulbasaur")
    green = [(187, 223, 113), (164, 213, 65), (122, 158, 48), (72, 94, 28)]
    bulb = mask_of(b, lambda x, y, c: c in green)
    head = mask_of(b, lambda x, y, c: x <= 44 and y >= 34)
    cv = Canvas()
    lute(cv, Frame((46.5, 48.5), 38, 0.27), bowl_len=100, bowl_w=66, neck_len=44, pegbox_side=-1)
    inst = cv.image()
    lv = Canvas()
    BULB = ((72, 94, 28), (122, 158, 48), (164, 213, 65), (187, 223, 113))
    for (bx, by, ang, ln) in ((47, 48, -40, 8), (61, 48, 40, 7)):         # the bulb's leaves cupping the bowl
        leaf(lv, (bx, by), ang, ln, ramp=BULB)
    peek = only(b, bulb & ~np.asarray(inst)[..., 3].astype(bool))
    return compose(cut(b, bulb), peek, inst, lv.image(), only(b, head))


def is_red(c):
    return c[0] > 100 and c[0] > c[1] + 60 and c[0] > c[2] + 20


def is_pink(c):
    return c[0] > 170 and c[0] > c[1] + 40 and c[0] > c[2] + 30


def is_teal(c):
    return c[1] > c[0] + 25 and c[2] > c[0] + 15 and c[2] >= c[1] - 45


def porcelain(c):
    r, g, b = c
    return b > r + 40 or (min(c) > 200 and max(c) - min(c) < 28) or (b > r + 10 and lum(c) < 70 and b > 60)


def ivysaur_hauntello():
    """The cello lies along Ivysaur's back between the leaves, scroll up and back; the bud stays behind it."""
    b = sprite("ivysaur")
    face = mask_of(b, lambda x, y, c: x <= 50 and y >= 52)
    cv = Canvas()
    cello(cv, Frame((40, 66), 42, 0.29), body_len=100, body_w=62, neck_len=56, strings=2, endpin=False,
          cracks=[[(0.2, 0.1), (0.3, 0.2), (0.38, 0.12)]])
    return compose(b, cv.image(), only(b, face))


def venusaur_chorumbra():
    """The palm trunk under Venusaur's flower is the harp: pillar where the trunk stands, the soundbox
    sloping back, the neck under the petals, strings between; the petals stay over it."""
    b = sprite("venusaur")
    petals = mask_of(b, lambda x, y, c: is_pink(c) or (y < 24 and c[0] > 200 and c[1] > 150))
    trunk = mask_of(b, lambda x, y, c: 36 <= x <= 62 and 20 <= y <= 40 and c[0] > c[1] + 15 and c[1] > c[2] + 5 and c[0] < 200)
    cv = Canvas()
    harp(cv, Frame((50, 50), 0, 0.33), height=100, depth=100)
    return compose(cut(b, trunk), cv.image(), only(b, petals))


def zorua_lutling():
    """Zorua's tail is the lute: the bowl where the brush was (rose facing us), the neck rising from it and
    the pegbox bent back, tipped with the tail's red."""
    b = sprite("zorua")
    tail = mask_of(b, lambda x, y, c: x >= 58 and 40 <= y <= 60)
    body_front = mask_of(b, lambda x, y, c: x < 60)
    cv = Canvas()
    lute(cv, Frame((65, 61), -8, 0.21), bowl_len=100, bowl_w=74, neck_len=50, pegbox_side=-1)
    return compose(cut(b, tail), cv.image(), only(b, body_front & ~tail))


def zoroark_hauntello():
    """A cello rides in Zoroark's mane, its body down the back, its scroll up out of the mane; loose
    strings trail from its claws."""
    b = sprite("zoroark")
    front = mask_of(b, lambda x, y, c: x <= 44 or y >= 56)
    cv = Canvas()
    cello(cv, Frame((58, 60), 14, 0.33), body_len=100, body_w=60, neck_len=56, endpin=False,
          cracks=[[(0.15, -0.1), (0.3, 0.0), (0.4, -0.12)]])
    ln = Canvas()
    for path in ([(20, 55), (16, 60), (19, 66), (15, 72)], [(22, 56), (24, 62), (21, 68)]):
        for p0, p1 in zip(path, path[1:]):
            ln.line(p0, p1, GOLD[2], part=30)
    return compose(b, cv.image(), only(b, front), ln.image())


def noibat_lutling():
    """Noibat's great ears are two lutes: each ear the bowl (its membrane the ribbed back, the inner ear the
    soundboard with the rose), the tip carrying on into a short neck and a bent-back pegbox."""
    b = sprite("noibat")
    ears = mask_of(b, lambda x, y, c: y <= 41 and 32 <= x <= 64)
    cv = Canvas()
    lute(cv, Frame((41, 44), -20, 0.21), bowl_len=100, bowl_w=72, neck_len=42, pegbox_side=-1)
    cv2 = Canvas()
    lute(cv2, Frame((55, 44), 20, 0.21, flip=True), bowl_len=100, bowl_w=72, neck_len=42, pegbox_side=1)
    rim = (108, 76, 143)
    return compose(cut(b, ears), recolour_outline(cv.image(), rim), recolour_outline(cv2.image(), rim),
                   only(b, mask_of(b, lambda x, y, c: y >= 40 and 36 <= x <= 60)))


def noivern_chorumbra():
    """Noivern's speaker-ears are two narrow harps: each ear's leading edge the pillar, its rim the neck,
    strings between."""
    b = sprite("noivern")
    ears = mask_of(b, lambda x, y, c: y <= 34 and 16 <= x <= 54)
    cv = Canvas()
    harp(cv, Frame((26, 36), -18, 0.24, flip=True), height=100, depth=70)
    cv2 = Canvas()
    harp(cv2, Frame((42, 36), 14, 0.24), height=100, depth=70)
    return compose(cut(b, ears), cv.image(), cv2.image())


def wickit_lutling():
    """Wickit's porcelain tail-paddle is the lute's bowl - the ribbed back glazed blue-and-white, the
    soundboard and rose in front - with the neck rising from its tip."""
    b = sprite("wickit")
    paddle = mask_of(b, lambda x, y, c: 52 <= x <= 74 and 30 <= y <= 52 and porcelain(c))
    cv = Canvas()
    lute(cv, Frame((67, 51), -30, 0.24), bowl_len=100, bowl_w=70, neck_len=48, pegbox_side=1, porcelain_rim=True)
    return compose(cut(b, paddle), cv.image())


def stoketail_hauntello():
    """Stoketail's tail ends in a cello instead of a paddle: the body rimmed in its blue-and-white porcelain,
    standing at its side, scroll up high; the tail curls into the cello's foot."""
    b = sprite("stoketail")
    paddle = mask_of(b, lambda x, y, c: x <= 37 and y <= 52 and porcelain(c))
    cv = Canvas()
    cello(cv, Frame((20, 58), -8, 0.36), body_len=100, body_w=62, neck_len=52, porcelain_rim=True, endpin=False)
    return compose(cut(b, paddle), cv.image())


def forgel_chorumbra():
    """Forgel's long tail ends in a harp instead of a paddle: porcelain-glazed neck and pillar, the strings
    hung between; it stands up off the tail's tip."""
    b = sprite("forgel")
    paddle = mask_of(b, lambda x, y, c: x <= 33 and y >= 64 and porcelain(c))
    cv = Canvas()
    harp(cv, Frame((16, 80), 0, 0.42, flip=True), height=100, depth=72, porcelain=True)
    return compose(cut(b, paddle), cv.image())


def sableye_lutling():
    """Sableye's round belly is the lute's bowl, held like a body: the chest gem set in it as the rose,
    strings over it to a bridge low down."""
    b = sprite("sableye")
    cv = Canvas()
    lute(cv, Frame((49, 64), 0, 0.17), bowl_len=100, bowl_w=82, neck_len=0, show_neck=False, rose=False)
    a = cv.image()
    gem = mask_of(b, lambda x, y, c: c in [(190, 55, 67), (255, 74, 90), (255, 120, 132)])
    arms = mask_of(b, lambda x, y, c: (x <= 41 or x >= 58) and 46 <= y <= 56)
    return compose(b, a, only(b, gem), only(b, arms))


def sporeye_hauntello():
    """The cello is Sporeye's torso: its body from the chest down between the legs (endpin to the ground),
    the neck up behind the head to the scroll among the glowcaps."""
    b = sprite("sporeye")
    front = mask_of(b, lambda x, y, c: y <= 52 or (y >= 54 and (x <= 38 or x >= 62)))
    cv = Canvas()
    cello(cv, Frame((49, 86), 0, 0.33), body_len=100, body_w=60, neck_len=80, endpin=True,
          cracks=[[(0.3, 0.12), (0.42, 0.22), (0.5, 0.1)]])
    return compose(b, cv.image(), only(b, front))


def myconarch_chorumbra():
    """Myconarch holds a harp at its side under the cap, its hand on the strings."""
    b = sprite("myconarch")
    cv = Canvas()
    harp(cv, Frame((62, 86), 6, 0.42), height=100, depth=70)
    hand = mask_of(b, lambda x, y, c: 56 <= x <= 72 and 44 <= y <= 60 and c[2] > c[1] + 20)
    return compose(b, cv.image(), only(b, hand))


def gengar_hauntello():
    """Gengar's belly is the cello's resonating chamber: varnished wood with f-holes either side, cracks
    glowing violet, strings from under the grin down to a tailpiece; no neck."""
    b = sprite("gengar")
    belly = mask_of(b, lambda x, y, c: 29 <= x <= 58 and 52 <= y <= 68)
    cv = Canvas()
    cello(cv, Frame((43, 69), 0, 0.2), body_len=100, body_w=110, neck=False, endpin=False, strings=3,
          cracks=[[(0.2, 0.32), (0.32, 0.4), (0.45, 0.3)]])
    inst = cv.image()
    grin = mask_of(b, lambda x, y, c: y <= 57)
    return compose(b, inst, only(b, grin & ~mask_of(b, lambda x, y, c: y >= 56)))


def gardevoir_chorumbra():
    """Gardevoir's crest sweeps round into a harp's curved frame behind her; strings fall from it and follow
    the line of her body down to the gown."""
    b = sprite("gardevoir")
    fr = Canvas()
    pts = [(36, 11), (46, 8), (55, 12), (60, 22), (60, 34), (56, 44)]
    for p0, p1 in zip(pts, pts[1:]):
        for o in (-1, 0, 1):
            fr.line((p0[0] + o * 0.6, p0[1]), (p1[0] + o * 0.6, p1[1]), LACQ[2] if o < 1 else LACQ[1], part=1)
    fr.outline({1}, INK, lit=(110, 66, 36))
    for (x, y) in pts[1:-1]:
        fr.put(x, y, GOLD[2], 7)
    for (x0, y0, x1, y1) in ((50, 11, 47, 40), (54, 14, 52, 46), (57, 20, 57, 52), (59, 28, 62, 58)):
        fr.line((x0, y0), (x1, y1), GOLD[3], part=8)
    head = mask_of(b, lambda x, y, c: y <= 33 and x <= 50)
    return compose(fr.image(), b, only(b, head))


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
    show([PAIRS[k]() for k in keys], keys, S + "hyb.png", z=5)
