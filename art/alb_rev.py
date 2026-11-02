"""The other direction: a partner's HEAD on one of Alberica's instrument BODIES, hand-made the same way -
the partner's head and its head-features reshape the instrument, rather than a head pasted on top.

  partner head + Lutling body    the head comes up out of the lute's rose, the rim's lower lip in front of
                                 it; the lute's leaf-flaps take the head's own leaves / fur / wings
  partner head + Hauntello body  the face bursts out of the smashed hole; the varnish takes the head's
                                 colour; head-spikes / ears break out of the splintered wood
  partner head + Chorumbra body  the head sits under the harp-hat; the ghost body and its tail take the
                                 head's colours (a gown-like tail stays a tail)"""
import numpy as np
from PIL import Image
from alb_ops import *


def body(name):
    return Px(Image.open(f"{PROTO}/{name}.png"))


def head_piece(name, box_, keep=None, ellipse=None):
    """Cut the partner's head out of its sprite: a box, optionally limited to the pixels `keep` accepts or
    to an ellipse (cx, cy, rx, ry)."""
    src = Image.open(f"{PROTO}/{name}.png").convert("RGBA")
    x0, y0, x1, y1 = box_
    piece = Image.new("RGBA", (x1 - x0 + 1, y1 - y0 + 1), (0, 0, 0, 0))
    sp, pp = src.load(), piece.load()
    for y in range(y0, y1 + 1):
        for x in range(x0, x1 + 1):
            c = sp[x, y]
            if not c[3]:
                continue
            if keep and not keep(x, y, c[:3]):
                continue
            if ellipse:
                cx, cy, rx, ry = ellipse
                if ((x + 0.5 - cx) / rx) ** 2 + ((y + 0.5 - cy) / ry) ** 2 > 1:
                    continue
            pp[x - x0, y - y0] = c
    return piece


def emerge(P, piece, at, hole_c, r_in, r_lip, lip_from=0.25):
    """Set the head in the hole: paste it with its anchor at `at`, then bring the lower lip of the rim back
    in front so the head comes up out of the instrument."""
    before = P.img.copy()
    P.img.alpha_composite(piece, at)
    P.p = P.img.load()
    bp = before.load()
    cx, cy = hole_c
    W, H = P.img.size
    for y in range(H):
        for x in range(W):
            rr = ((x + 0.5 - cx) ** 2 + (y + 0.5 - cy) ** 2) ** 0.5
            if r_in <= rr <= r_lip and y + 0.5 > cy + r_in * lip_from and bp[x, y][3]:
                P.p[x, y] = bp[x, y]


def outline_piece(piece, col=INK):
    """Close the piece's open (cut) edges with an outline."""
    a = piece.load()
    W, H = piece.size
    m = {(x, y) for y in range(H) for x in range(W) if a[x, y][3]}
    for (x, y) in m:
        if any((x + dx, y + dy) not in m for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))) and lum(a[x, y][:3]) > 60:
            a[x, y] = tuple(col) + (255,)
    return piece


# ------------------------------------------------------------------------ Bulbasaur head + Lutling
def bulbasaur_lutling():
    """Bulbasaur's head comes up out of the lute's rose - ears, eyes and grin - with the lower lip of the
    rose in front of its chin; the lute's two leaf-flaps become Bulbasaur's leaves (its bulb's leaves,
    veined), and its spots dapple the bowl like inlay."""
    P = body("lutling_body")
    teal = [(73, 158, 134), (43, 94, 79), (98, 213, 180), (138, 223, 199)]
    head = head_piece("bulbasaur", (26, 33, 52, 56), keep=lambda x, y, c: not (x >= 41 and y <= 48 and c in
                      [(187, 223, 113), (164, 213, 65), (122, 158, 48), (72, 94, 28)]) and y <= 55)
    emerge(P, head, (45 - 13, 66 - 15), (44.8, 65.9), 8.0, 15.0, lip_from=0.45)
    # the flaps become leaves: Bulbasaur's leaf greens by the flap's own shading, a vein down each
    flaps = region(P, lambda x, y, c: ((x <= 29 and 63 <= y <= 84) or (x >= 64 and 63 <= y <= 80))
                   and c[0] > c[2] + 40)
    recolour_ramp(P, flaps, [(72, 94, 28), (122, 158, 48), (164, 213, 65), (187, 223, 113)])
    P.line([(20, 69), (25, 72), (29, 76)], (72, 94, 28), cond=lambda x, y: (x, y) in flaps)
    P.line([(75, 68), (69, 72), (63, 76)], (72, 94, 28), cond=lambda x, y: (x, y) in flaps)
    # Bulbasaur's spots, inlaid in the bowl
    for (x, y) in ((36, 48), (37, 48), (53, 45), (54, 46), (33, 80), (34, 80), (56, 82)):
        if P.get(x, y)[3] and lum(P.get(x, y)[:3]) > 120:
            P.put(x, y, (43, 94, 79))
    return P.img


# ------------------------------------------------------------------------ Gengar head + Hauntello
def gengar_hauntello():
    """Gengar's eyes and grin burst out of the cello's smashed hole; the varnish takes Gengar's purple;
    the splintered wood around the hole breaks into Gengar's spikes."""
    P = body("hauntello_body")
    wood = region(P, lambda x, y, c: c[0] > c[2] + 25 and not (c[0] > 200 and c[1] > 140))   # reds, not gold
    recolour_ramp(P, wood, [(61, 32, 61), (110, 85, 134), (148, 115, 180), (175, 150, 199)])
    face = head_piece("gengar", (26, 36, 54, 59), ellipse=(40, 48.5, 14, 11))
    outline_piece(face, (61, 32, 61))
    emerge(P, face, (46 - 14, 64 - 13), (46.1, 63.9), 7.6, 13.5, lip_from=0.55)
    for (x, y, h) in ((37, 52, 4), (43, 50, 5), (50, 50, 5), (56, 52, 4)):       # spikes breaking out
        for k in range(h):
            w = max(0, (h - k) // 2)
            for dx in range(-w, w + 1):
                c = (175, 150, 199) if dx < 0 else (110, 85, 134)
                P.put(x + dx, y - k, c)
            P.put(x - w - 1, y - k, INK); P.put(x + w + 1, y - k, INK)
        P.put(x, y - h, INK)
    return P.img


# ------------------------------------------------------------------------ Gardevoir head + Chorumbra
def gardevoir_chorumbra():
    """Gardevoir's head - the swept green hair and pale face - under the harp-hat; the ghost body becomes
    Gardevoir's: green arms, and the wisp of a tail is her white gown."""
    P = body("chorumbra_body")
    viol = lambda x, y, c: c[2] > c[1] + 20 and c[2] > 120 and not (c[0] > 180 and c[1] > 150 and c[2] < 140)
    ghost = region(P, viol)
    arms = {p for p in ghost if (p[0] < 38 and 44 <= p[1] <= 72) or (p[0] > 58 and p[1] >= 50)}
    gown = ghost - arms
    recolour_ramp(P, arms, [(61, 101, 61), (103, 171, 103), (139, 230, 139), (168, 236, 168)])
    recolour_ramp(P, gown, [(152, 152, 171), (205, 205, 230), (217, 217, 236), (240, 240, 250)])
    import alb2
    hat = Image.open(f"{PROTO}/chorumbra_hat.png").convert("RGBA") if False else None
    head = head_piece("gardevoir", (23, 10, 50, 33), keep=lambda x, y, c: True)
    # Gardevoir's face centre is about (41, 23); Chorumbra's face is at (48, 43)
    before_hat = P.img.copy()
    for y in range(36, 52):                                   # clear Chorumbra's face first
        for x in range(38, 60):
            if ((x + 0.5 - 48) / 9.5) ** 2 + ((y + 0.5 - 43.5) / 7.5) ** 2 <= 1:
                c = P.get(x, y)
                if c[3] and not (c[0] > 120 and c[1] < 90):   # keep the hat's lacquer
                    P.clear(x, y)
    P.img.alpha_composite(head, (48 - 18, 43 - 13))
    P.p = P.img.load()
    # the harp-hat back in front of the hair
    bp = before_hat.load()
    for y in range(0, 42):
        for x in range(25, 80):
            c = bp[x, y]
            if c[3] and (c[0] > c[2] + 20 or (c[0] > 200 and c[1] > 150)):        # lacquer and gold
                P.p[x, y] = c
    return P.img


if __name__ == "__main__":
    S = "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/"
    out = []
    for f, name in ((bulbasaur_lutling, "1.577"), (gengar_hauntello, "94.578"), (gardevoir_chorumbra, "287.579")):
        im = f(); im.save(f"{PROTO}/{name}.png"); out.append(im)
    show(out, ["Bulbasaur head + Lutling", "Gengar head + Hauntello", "Gardevoir head + Chorumbra"], S + "rev.png", z=5)


# =========================================================================== the party, generalised
HEADS = {
    # name: (crop box, keep(x, y, c), face anchor in the partner's own sprite coords)
    "bulbasaur": ((26, 33, 52, 56), lambda x, y, c: not (x >= 41 and y <= 48 and c in
                  [(187, 223, 113), (164, 213, 65), (122, 158, 48), (72, 94, 28)]), (39, 48)),
    "sableye": ((33, 26, 65, 47), None, (46, 42)),
    "zorua": ((28, 23, 56, 57), lambda x, y, c: not (x >= 49 and y >= 44), (41, 47)),
    "noibat": ((33, 22, 63, 55), lambda x, y, c: not ((x < 37 or x > 58) and y >= 41), (47, 46)),
    "wickit": ((21, 42, 51, 68), lambda x, y, c: not (x >= 40 and y >= 62), (33, 57)),
    "stoketail": ((49, 7, 81, 37), lambda x, y, c: not porcelain(x, y, c), (63, 24)),
    "forgel": ((63, 34, 94, 53), lambda x, y, c: not porcelain(x, y, c), (75, 44)),
}
# each partner's own colours, light to dark order not needed (ramps are sorted by lightness)
RAMPS = {
    "bulbasaur": [(43, 94, 79), (73, 158, 134), (98, 213, 180), (138, 223, 199)],
    "sableye": [(61, 50, 94), (79, 65, 121), (103, 85, 158), (139, 115, 213)],
    "zorua": [(32, 32, 49), (67, 67, 85), (90, 90, 115), (120, 120, 145)],
    "noibat": [(64, 45, 85), (108, 76, 143), (146, 103, 193), (173, 141, 208)],
    "wickit": [(146, 77, 45), (172, 91, 53), (237, 130, 70), (244, 142, 80)],
    "stoketail": [(146, 77, 45), (180, 92, 51), (233, 129, 71), (239, 135, 74)],
    "forgel": [(142, 72, 39), (168, 85, 46), (230, 126, 68), (236, 133, 73)],
}
PORC = [(24, 44, 120), (44, 86, 192), (219, 209, 205), (249, 247, 245)]
ACCENT = {   # what the partner gives the instrument besides its head: flaps / splinters / limbs
    "bulbasaur": [(72, 94, 28), (122, 158, 48), (164, 213, 65), (187, 223, 113)],     # its leaves
    "sableye": [(57, 86, 94), (97, 146, 158), (131, 197, 213), (162, 211, 223)],      # its gems
    "zorua": [(128, 11, 48), (172, 16, 65), (200, 40, 90), (230, 90, 130)],            # its red tuft
    "noibat": [(64, 45, 85), (108, 76, 143), (146, 103, 193), (173, 141, 208)],       # its wings
    "wickit": PORC, "stoketail": PORC, "forgel": PORC,                                  # its porcelain
}


ELLIPSES = {}


def partner_head(name):
    box_, keep, (ax, ay) = HEADS[name]
    piece = head_piece(name, box_, keep=keep, ellipse=ELLIPSES.get(name))
    if name in ELLIPSES:
        outline_piece(piece, RAMPS[name][0])
    return piece, (ax - box_[0], ay - box_[1])


def lutling_with(name):
    """The partner's head comes up out of the lute's rose; the lute's flaps take its accent (leaves,
    gem-crystal, red fur, wing membrane, porcelain)."""
    P = body("lutling_body")
    piece, (ax, ay) = partner_head(name)
    emerge(P, piece, (round(44.8 - ax), round(65.0 - ay)), (44.8, 65.9), 8.0, 15.0, lip_from=0.45)
    flaps = region(P, lambda x, y, c: ((x <= 29 and 63 <= y <= 84) or (x >= 64 and 63 <= y <= 80)) and c[0] > c[2] + 40)
    recolour_ramp(P, flaps, ACCENT[name])
    if name == "noibat":                                   # wing bones across the membrane
        P.line([(19, 68), (24, 74), (29, 80)], (64, 45, 85), cond=lambda x, y: (x, y) in flaps)
        P.line([(76, 67), (70, 72), (65, 77)], (64, 45, 85), cond=lambda x, y: (x, y) in flaps)
    elif name == "bulbasaur":
        P.line([(20, 69), (25, 72), (29, 76)], (72, 94, 28), cond=lambda x, y: (x, y) in flaps)
        P.line([(75, 68), (69, 72), (63, 76)], (72, 94, 28), cond=lambda x, y: (x, y) in flaps)
    return P.img


def hauntello_with(name):
    """The partner's face bursts out of the smashed cello; the varnish takes its colour; its accent breaks
    out of the splintered wood round the hole (leaves, gem shards, red tufts, wing-claws, porcelain shards)."""
    P = body("hauntello_body")
    wood = region(P, lambda x, y, c: c[0] > c[2] + 25 and not (c[0] > 200 and c[1] > 140))
    recolour_ramp(P, wood, RAMPS[name])
    piece, (ax, ay) = partner_head(name)
    emerge(P, piece, (round(46.1 - ax), round(63.0 - ay)), (46.1, 63.9), 7.6, 13.5, lip_from=0.55)
    acc = ACCENT[name]
    for (x, y, h, lean) in ((34, 56, 4, -1), (58, 56, 4, 1), (36, 72, 3, -1), (57, 71, 3, 1)):   # shards round the rim
        for k in range(h):
            P.put(x + lean * k // 2, y - k if y < 64 else y + k, acc[2] if k < h - 1 else acc[3])
            P.put(x + lean * k // 2 + 1, y - k if y < 64 else y + k, acc[1])
    return P.img


def chorumbra_with(name):
    """The partner's head under the harp-hat; the ghost body takes the partner's colours (arms in its
    accent, the wisp of a tail in its main colour)."""
    P = body("chorumbra_body")
    viol = lambda x, y, c: c[2] > c[1] + 20 and c[2] > 120 and not (c[0] > 180 and c[1] > 150 and c[2] < 140)
    ghost = region(P, viol)
    arms = {p for p in ghost if (p[0] < 38 and 44 <= p[1] <= 72) or (p[0] > 58 and p[1] >= 50)}
    recolour_ramp(P, arms, ACCENT[name] if name not in ("wickit", "stoketail", "forgel") else RAMPS[name])
    recolour_ramp(P, ghost - arms, RAMPS[name])
    before_hat = P.img.copy()
    for y in range(34, 52):
        for x in range(36, 62):
            if ((x + 0.5 - 48) / 10) ** 2 + ((y + 0.5 - 43.5) / 8) ** 2 <= 1:
                c = P.get(x, y)
                if c[3] and not (c[0] > 120 and c[1] < 90):
                    P.clear(x, y)
    piece, (ax, ay) = partner_head(name)
    P.img.alpha_composite(piece, (round(48 - ax), round(44 - ay)))
    P.p = P.img.load()
    bp = before_hat.load()
    for y in range(0, 41):
        for x in range(25, 80):
            c = bp[x, y]
            if c[3] and (c[0] > c[2] + 20 or (c[0] > 200 and c[1] > 150)) and c[:3] not in [tuple(v) for v in RAMPS[name] + ACCENT[name]]:
                P.p[x, y] = c
    if name in ("wickit", "stoketail", "forgel"):          # the tail ends in its porcelain paddle
        for (x, y) in P.ellipse(47, 87, 6, 3.5, rot=-10):
            if P.get(x, y)[3]:
                P.put(x, y, PORC[3] if (x + y) % 3 else PORC[1])
    return P.img


PARTY = ["bulbasaur", "sableye", "zorua", "noibat", "wickit", "stoketail", "forgel"]
NUM = {"bulbasaur": 1, "sableye": 421, "zorua": 399, "noibat": 440, "wickit": 582, "stoketail": 583, "forgel": 584}


# ------------------------------------------------------------------------------- the evolutions
def _not(*tests):
    return lambda x, y, c: not any(t(x, y, c) for t in tests)


HEADS.update({
    "ivysaur": ((18, 50, 52, 74), _not(is_leaf, is_pink), (37, 62)),
    "venusaur": ((20, 50, 70, 74), _not(is_leaf, is_pink), (45, 62)),
    "zoroark": ((16, 16, 52, 50), None, (30, 37)),
    "noivern": ((16, 13, 52, 46), None, (33, 34)),
    "sporeye": ((24, 16, 72, 56), None, (50, 46)),
    "myconarch": ((30, 12, 64, 36), None, (47, 26)),
})
TEAL3 = [(30, 90, 80), (50, 140, 120), (80, 190, 160), (130, 220, 190)]
RAMPS.update({
    "ivysaur": RAMPS["bulbasaur"], "venusaur": TEAL3,
    "zoroark": [(32, 32, 49), (60, 60, 80), (90, 90, 115), (120, 120, 145)],
    "noivern": [(40, 34, 50), (70, 60, 84), (110, 84, 140), (150, 112, 190)],
    "sporeye": [(44, 26, 72), (68, 44, 106), (92, 66, 140), (118, 94, 170)],
    "myconarch": [(44, 26, 72), (68, 44, 106), (92, 66, 140), (118, 94, 170)],
})
MINT = [(46, 120, 96), (92, 186, 142), (150, 232, 184), (214, 255, 230)]
ACCENT.update({
    "ivysaur": ACCENT["bulbasaur"],
    "venusaur": [(150, 60, 60), (210, 100, 100), (240, 140, 130), (250, 190, 170)],     # its petals
    "zoroark": ACCENT["zorua"],
    "noivern": [(40, 90, 80), (60, 140, 120), (90, 190, 160), (150, 230, 200)],        # its teal chest
    "sporeye": MINT, "myconarch": MINT,                                                 # glowcaps
})
EVOS = ["ivysaur", "venusaur", "zoroark", "noivern", "sporeye", "myconarch"]
NUM.update({"ivysaur": 2, "venusaur": 3, "zoroark": 338, "noivern": 441, "sporeye": 585, "myconarch": 586})

ELLIPSES.update({
    "ivysaur": (37, 62, 17, 12), "venusaur": (45, 62, 22, 11.5), "zoroark": (32, 33, 17, 16),
    "noivern": (33, 30, 16, 16.5), "sporeye": (48, 40, 23, 19), "myconarch": (47, 25, 15, 10),
})
