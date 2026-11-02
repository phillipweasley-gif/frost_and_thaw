"""Alberica's line hand-fused with the party partners. Each function draws one fusion on the partner's own
sprite with the operations in alb_ops (the agreed anatomical rules). Coordinates were read off each
partner's sprite (see the ASCII dumps used while drawing)."""
from alb_ops import *

PURPLE_SABLEYE = [(103, 85, 158), (139, 115, 213), (61, 50, 94), (168, 150, 223), (79, 65, 121)]
GEM_SABLEYE = [(162, 211, 223), (131, 197, 213), (97, 146, 158), (57, 86, 94)]
PORCELAIN = [(33, 72, 178), (24, 44, 120), (48, 91, 197), (247, 243, 239), (250, 248, 247), (60, 86, 168),
             (14, 28, 84), (228, 219, 218), (44, 86, 192), (35, 71, 171), (219, 209, 205), (249, 247, 245),
             (246, 242, 238), (43, 85, 191), (35, 75, 181), (245, 241, 237), (248, 245, 242), (219, 210, 207)]


# =============================================================================== LUTLING (577)
def lut_sableye():
    """Sableye's big round head is the lute's bowl, ribbed to a block at its chin; the tall ear is the
    fretted neck with its pegbox bent back; the chest gem is the rose; the gem eyes glow violet."""
    P = load("sableye")
    head = region(P, both(box(33, 26, 64, 47), colours_in(PURPLE_SABLEYE)))
    lute_bowl(P, head, block=(48, 49))
    lute_neck(P, (38, 37), (37, 27), pegbox=-1)
    violet_eyes(P, region(P, colours_in(GEM_SABLEYE)))
    rose(P, 49, 53, 5)
    wisp(P, 50, 48)
    return P.img


def lut_zorua():
    """Zorua's fluffy tail is the lute's bowl (ribbed, a rose facing us), and the neck grows from the tail's
    tip with the pegbox bent back; strings run from the neck over the rose to a bridge; violet eye."""
    P = load("zorua")
    tail = region(P, both(box(58, 41, 68, 59), not_dark(25)))
    lute_bowl(P, tail, block=(61, 60), step=14)
    lute_neck(P, (64, 42), (68, 31), pegbox=+1)
    rose(P, 63, 50, 5)
    lute_strings(P, (65, 43), (63, 55))
    violet_eyes(P, region(P, colours_in([(24, 180, 180), (49, 131, 131)])))
    return P.img


def lut_noibat():
    """Noibat's great ears are two hollow lute bowls: ribbed wood outside, the inner ear opened into a
    gold-lipped hollow with strings across it and the haunting glowing inside; the ear tips bend back into
    pegboxes."""
    P = load("noibat")
    outer = [(146, 103, 193), (108, 76, 143), (173, 141, 208)]
    inner = [(105, 88, 105), (178, 149, 179), (136, 114, 136), (134, 130, 130), (79, 77, 77)]
    for (x0, x1, block) in ((33, 47, (44, 41)), (48, 63, (50, 41))):
        ear = region(P, both(box(x0, 22, x1, 40), colours_in(outer)))
        lute_bowl(P, ear, block=block, step=13)
        hollow = region(P, both(box(x0, 22, x1, 39), colours_in(inner)))
        rim = set(edge(list(hollow)))
        top_y = min(y for (x, y) in hollow)
        for (x, y) in hollow:
            P.put(x, y, ((110, 56, 24) if y < top_y + 3 else (246, 198, 124)) if (x, y) in rim else HOLE)
        ys = sorted({y for (x, y) in hollow})
        low = [p for p in hollow if p not in rim and p[1] >= ys[-1] - 3]
        for (x, y) in low:
            P.put(x, y, SPIRIT[1] if (x + y) % 2 else SPIRIT[2])
        cx = sorted(x for (x, y) in hollow)[len(hollow) // 2]
        for dx in (-1, 1):
            P.line([(cx + dx, ys[0] + 1), (cx + dx, ys[-1] - 1)], GOLD[3], cond=lambda x, y: (x, y) in hollow and (x, y) not in rim)
    stamp(P, 36, 21, [".g#.", "#BbB#", ".#g."])
    stamp(P, 60, 22, [".#g.", "#BbB#", ".g#."])
    return P.img


def lut_paddle(name, paddle_box, block, rose_at, neck, pegbox, string, eye_box, step=12):
    P = load(name)
    paddle = region(P, both(box(*paddle_box), porcelain))
    lute_bowl(P, paddle, block=block, step=step)
    lute_neck(P, neck[0], neck[1], pegbox=pegbox)
    lute_strings(P, string[0], string[1])
    rose(P, *rose_at, 7)
    violet_eyes(P, region(P, both(box(*eye_box), lambda x, y, c: lum(c) < 60 or c[0] > c[2] + 60 and c[1] < 120)))
    return P.img


def lut_wickit():
    """Wickit's porcelain tail-paddle becomes the lute: a ribbed bowl with the rose in it, the neck growing
    from the paddle's narrow tip with its pegbox bent back, strings to a bridge; violet eye."""
    return lut_paddle("wickit", (53, 31, 73, 51), (68, 50), (62, 41), ((55, 33), (49, 25)), -1,
                      ((56, 34), (65, 47)), (30, 55, 37, 60), step=18)


def lut_stoketail():
    return lut_paddle("stoketail", (9, 20, 36, 51), (13, 49), (22, 34), ((33, 23), (40, 15)), +1,
                      ((32, 24), (16, 44)), (60, 18, 66, 24), step=16)


def lut_forgel():
    return lut_paddle("forgel", (0, 66, 32, 81), (30, 72), (12, 72), ((31, 68), (40, 60)), -1,
                      ((30, 69), (4, 72)), (69, 38, 75, 44), step=14)


LUT = {421: lut_sableye, 399: lut_zorua, 440: lut_noibat, 582: lut_wickit, 583: lut_stoketail, 584: lut_forgel}

if __name__ == "__main__":
    import sys
    S = "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/"
    imgs, labs = [], []
    for n, f in LUT.items():
        im = f()
        im.save(f"{PROTO}/577.{n}.png")
        imgs.append(im); labs.append(f"Lutling x {f.__name__[4:]}")
    show(imgs, labs, S + "lut_batch.png", z=4)


# ============================================================================= HAUNTELLO (578)
GREEN_BULB = [(187, 223, 113), (164, 213, 65), (122, 158, 48), (72, 94, 28)]
RED_BULBA = [(159, 0, 39), (229, 25, 46), (247, 93, 85)]


def hau_bulbasaur():
    """Bulbasaur's bulb is the cello's body - varnished wood, purfling, an f-hole, the bridge with strings
    rising - and its tip curls into the scroll with pegs. Its grin is the soundhole; violet eyes."""
    P = load("bulbasaur")
    bulb = region(P, colours_in(GREEN_BULB))
    cello_body(P, bulb, purfle=2)
    f_hole(P, 58, 38, 5)
    bridge_tailpiece(P, 53, 44, strings=3, rise=3)
    cello_neck(P, (55, 35), (57, 31), small=True)
    mouth = region(P, both(box(28, 49, 46, 53), colours_in(RED_BULBA)))
    mouth_soundhole(P, mouth, glow_at=(38, 51))
    violet_eyes(P, region(P, both(box(26, 40, 50, 48), colours_in(RED_BULBA))))
    return P.img


def hau_sableye():
    """Sableye's big head is the cello's body (purfling just inside its edge, f-holes either side); its
    grin is the splintered soundhole; the tall ear is the ebony neck ending in the scroll; a bridge and
    tailpiece stand on its chest, an endpin between its legs; strings run out along its arms and fray
    past the claws. Gem eyes glow violet."""
    P = load("sableye")
    head = region(P, both(box(33, 26, 64, 47), colours_in(PURPLE_SABLEYE)))
    cello_body(P, head, purfle=2)
    body = region(P, both(box(26, 47, 70, 70), colours_in(PURPLE_SABLEYE)))
    cello_body(P, body, purfle=0)
    violet_eyes(P, region(P, colours_in(GEM_SABLEYE)))
    grin = {(x, 45) for x in range(46, 58)} | {(x, 46) for x in range(47, 57)}
    mouth_soundhole(P, grin, glow_at=(51, 46))
    f_hole(P, 42, 36, 4); f_hole(P, 58, 36, 4, flip=True)
    cello_neck(P, (38, 37), (37, 30), small=True)
    bridge_tailpiece(P, 48, 54, strings=3, rise=2)
    endpin(P, 48, 61, 5)
    fray(P, [(40, 49), (35, 50), (31, 51)], tips=[[(29, 51), (26, 49), (25, 46)], [(30, 52), (27, 54)]])
    fray(P, [(58, 49), (62, 50), (66, 50)], tips=[[(68, 49), (71, 47), (72, 44)], [(68, 51), (71, 53)]])
    return P.img


def hau_zorua():
    """Zorua's dark body is the cello (varnished almost to ebony, purfling, f-holes, bridge and tailpiece on
    its chest, an endpin beneath); its red tuft is the neck and scroll; strings fray from its tail; violet eye."""
    P = load("zorua")
    body = region(P, both(box(40, 44, 64, 66), lambda x, y, c: 20 < lum(c) < 60))
    recolour_ramp(P, body, [(60, 18, 16), (96, 30, 24), (140, 50, 36), (178, 72, 50)], dark_keep=20)
    W, H = P.img.size
    f_hole(P, 44, 54, 5); f_hole(P, 58, 52, 5, flip=True)
    bridge_tailpiece(P, 51, 56, strings=3, rise=2)
    endpin(P, 51, 63, 5)
    cello_neck(P, (42, 35), (43, 28), small=True)
    violet_eyes(P, region(P, colours_in([(24, 180, 180), (49, 131, 131)])))
    fray(P, [(60, 50), (64, 45)], tips=[[(65, 43), (67, 39), (66, 36)], [(66, 44), (70, 42)]])
    return P.img


def hau_noibat():
    """Noibat's fluffy chest is the cello's body (purfling, f-holes, bridge and tailpiece); one great ear
    is the neck and scroll; the bones of its wings are strings, fraying loose past the wing-tips."""
    P = load("noibat")
    chest = region(P, both(box(36, 39, 58, 56), lambda x, y, c: lum(c) > 150 and c[0] > c[1]))
    cello_body(P, chest, purfle=2)
    f_hole(P, 41, 45, 5); f_hole(P, 53, 45, 5, flip=True)
    bridge_tailpiece(P, 47, 51, strings=3, rise=2)
    cello_neck(P, (55, 38), (58, 28), small=True)
    fray(P, [(36, 47), (26, 47), (18, 50)], tips=[[(17, 50), (14, 49), (12, 46)], [(17, 51), (14, 53)]])
    fray(P, [(58, 47), (70, 48), (82, 50)], tips=[[(83, 50), (86, 48), (87, 45)], [(83, 51), (86, 53)]])
    return P.img


def hau_ferret(name, body_box, f_holes, bridge, end_pin, tail_path, paddle_box, scroll_at, mouth_box, eye_box, fray_paths):
    """The Cinderwright ferrets: the torso is the cello's body (purfling, f-holes, bridge and tailpiece,
    endpin), the tail is the long ebony neck, its porcelain paddle curls into the scroll; the mouth is the
    splintered soundhole, strings fray from the forepaws; violet eye."""
    P = load(name)
    fur = lambda x, y, c: c[0] > c[2] + 60 and c[0] > 150
    body = region(P, both(box(*body_box), fur))
    cello_body(P, body, purfle=3)
    for (x, y, flip) in f_holes:
        f_hole(P, x, y, 6, flip=flip)
    bridge_tailpiece(P, *bridge, strings=4, rise=2)
    endpin(P, *end_pin, 5)
    paddle = region(P, both(box(*paddle_box), porcelain))
    recolour_ramp(P, paddle, CELLO[1:5])
    sx, sy, r = scroll_at
    for k in range(int(r * 6)):
        a = k * 0.35
        rr = r * (1 - k / (r * 6))
        P.put(round(sx + math.cos(a) * rr), round(sy + math.sin(a) * rr), INK)
    for i in range(len(tail_path) - 1):
        cello_neck(P, tail_path[i], tail_path[i + 1], scroll=False)
    mouth = region(P, both(box(*mouth_box), lambda x, y, c: lum(c) < 60 or (c[0] > 200 and c[1] < 120)))
    mouth_soundhole(P, mouth)
    violet_eyes(P, region(P, both(box(*eye_box), lambda x, y, c: lum(c) < 60)))
    for path, tips in fray_paths:
        fray(P, path, tips)
    return P.img


def hau_wickit():
    return hau_ferret("wickit", (38, 62, 74, 80), [(46, 67, False), (64, 66, True)], (55, 71), (55, 80),
                      [(69, 66), (70, 58), (67, 51)], (53, 31, 73, 51), (62, 41, 7), (23, 59, 30, 63),
                      (30, 55, 37, 60), [([(30, 74), (24, 76)], [[(23, 77), (20, 79)], [(23, 75), (20, 74)]])])


def hau_stoketail():
    return hau_ferret("stoketail", (40, 30, 80, 80), [(46, 60, False), (70, 58, True)], (58, 64), (58, 74),
                      [(39, 72), (25, 60), (22, 48)], (9, 20, 36, 51), (22, 35, 9), (51, 26, 56, 29),
                      (60, 18, 66, 24), [])


def hau_forgel():
    return hau_ferret("forgel", (36, 55, 66, 80), [(42, 62, False), (60, 62, True)], (52, 68), (52, 77),
                      [(45, 63), (31, 69)], (0, 66, 32, 81), (14, 72, 7), (64, 43, 70, 46),
                      (69, 38, 75, 44), [])


HAU = {1: hau_bulbasaur, 421: hau_sableye, 399: hau_zorua, 440: hau_noibat, 582: hau_wickit, 583: hau_stoketail,
       584: hau_forgel}


# ============================================================================= CHORUMBRA (579)
TEAL_BULBA = [(73, 158, 134), (43, 94, 79), (98, 213, 180), (138, 223, 199)]


def cho_bulbasaur():
    """Bulbasaur's bulb is a harp: its outer curve becomes the lacquered neck with gold pins, strings run
    down inside it; its body takes Chorumbra's spirit-violet; beaded string-hair falls down its back."""
    P = load("bulbasaur")
    spirit_violet(P, region(P, colours_in(TEAL_BULBA)))
    bulb = region(P, colours_in(GREEN_BULB))
    lacquer(P, bulb)
    harp_arc(P, bulb)
    inner_strings(P, bulb, step=3)
    violet_eyes(P, region(P, both(box(26, 40, 50, 48), colours_in(RED_BULBA))))
    beads(P, [[(61, 44), (63, 50), (64, 55)], [(59, 46), (60, 52)]])
    return P.img


def cho_sableye():
    """Sableye's two tall ears are a pair of harp arcs (lacquer with gold pins, strings inside); its body
    is spirit-violet, its chest gem a gold rose; beaded strings hang from its ears."""
    P = load("sableye")
    spirit_violet(P, region(P, colours_in(PURPLE_SABLEYE)))
    for b in ((34, 26, 41, 38), (58, 28, 66, 39)):
        ear = region(P, both(box(*b), lambda x, y, c: lum(c) > 40))
        lacquer(P, ear)
        harp_arc(P, ear, pin_every=3)
        inner_strings(P, ear, step=2)
    violet_eyes(P, region(P, colours_in(GEM_SABLEYE)))
    lacquer(P, region(P, colours_in([(190, 55, 67), (255, 74, 90), (255, 120, 132)])), rose_at=(48, 53))
    beads(P, [[(35, 38), (31, 44), (30, 48)], [(65, 39), (69, 44), (70, 47)]])
    return P.img


def cho_zorua():
    """Zorua's red tuft is a harp arc (lacquer neck with gold pins, its streaks are the strings); its fur
    turns spirit-violet; beaded string-hair streams back from the tuft along its body."""
    P = load("zorua")
    tuft = region(P, colours_in([(128, 11, 48), (172, 16, 65)]))
    head_tuft = {p for p in tuft if p[1] < 36}
    spirit_violet(P, region(P, lambda x, y, c: 40 < lum(c) < 130 and abs(c[0] - c[1]) < 30))
    lacquer(P, head_tuft)
    harp_arc(P, head_tuft, pin_every=3)
    inner_strings(P, head_tuft, step=2)
    lacquer(P, tuft - head_tuft)
    violet_eyes(P, region(P, colours_in([(24, 180, 180), (49, 131, 131)])))
    solid = region(P, lambda x, y, c: True)
    beads(P, [[(47, 28), (54, 31), (60, 36), (66, 41)], [(48, 31), (55, 35), (62, 41)]], avoid=solid)
    return P.img


def cho_noibat():
    """Noibat's great curved ears are two harps: lacquer rims with gold pins, strings strung down through
    the ear; its purple turns spirit-violet; beaded string-hair from the ear-tips."""
    P = load("noibat")
    spirit_violet(P, region(P, colours_in([(146, 103, 193), (108, 76, 143), (173, 141, 208), (64, 45, 85)])))
    for b in ((33, 22, 47, 40), (48, 22, 63, 40)):
        ear = region(P, both(box(*b), lambda x, y, c: lum(c) > 40))
        lacquer(P, [p for p in ear if lum(P.get(*p)[:3]) > 40 and P.get(*p)[2] > P.get(*p)[1]])
        harp_arc(P, ear, pin_every=3)
        inner_strings(P, ear, step=3)
    beads(P, [[(36, 24), (32, 28), (30, 33)], [(61, 25), (65, 29), (67, 34)]])
    return P.img


def cho_ferret(name, paddle_box, gap, eye_box, frame=True):
    """The Cinderwright ferrets: the curving tail and its paddle make the harp's frame - the paddle is the
    lacquered neck with a gold rose, the tail the pillar, the back the soundbox - and the strings hang in
    the open space between; the fur turns spirit-violet."""
    P = load(name)
    paddle = region(P, both(box(*paddle_box), porcelain))
    fur = region(P, lambda x, y, c: not porcelain(x, y, c) and lum(c) > 60 and (c[0] > c[2] + 30 or min(c) > 180))
    spirit_violet(P, fur)
    lacquer(P, paddle)
    harp_arc(P, paddle, pin_every=3)
    if frame and gap:
        xs, y0, y1 = gap
        strings_across_gap(P, xs, y0, y1)
    else:
        inner_strings(P, paddle, step=3)
    violet_eyes(P, region(P, both(box(*eye_box), lambda x, y, c: lum(c) < 60)))
    return P.img


def cho_wickit():
    return cho_ferret("wickit", (53, 31, 73, 51), (range(54, 67, 2), 40, 70), (30, 55, 37, 60))


def cho_stoketail():
    return cho_ferret("stoketail", (9, 20, 36, 51), (range(14, 38, 3), 30, 80), (60, 18, 66, 24))


def cho_forgel():
    return cho_ferret("forgel", (0, 66, 32, 81), None, (69, 38, 75, 44), frame=False)


CHO = {1: cho_bulbasaur, 421: cho_sableye, 399: cho_zorua, 440: cho_noibat, 582: cho_wickit, 583: cho_stoketail,
       584: cho_forgel}


# ================================================================================ EVOLUTIONS
# --- Lutling as head
def lut_ivysaur():
    """Ivysaur's bud is the lute's bowl (ribbed to the base, rose facing us) with its tip grown into the neck and
    bent-back pegbox; violet eyes."""
    P = load("ivysaur")
    bud = region(P, both(box(36, 18, 58, 46), is_pink))
    lute_bowl(P, bud, block=(46, 47), step=14)
    lute_neck(P, (47, 24), (52, 14), pegbox=+1)
    lute_strings(P, (48, 25), (45, 41))
    rose(P, 45, 35, 5)
    violet_eyes(P, region(P, both(box(36, 55, 52, 66), is_red)))
    return P.img


def lut_venusaur():
    """Venusaur's flower is a lute seen from above: the brown heart of the flower is the bowl with the rose in
    it, the yellow crown its bent pegbox, the petals still petals round it; violet eyes."""
    P = load("venusaur")
    heart = region(P, both(box(36, 20, 62, 40), is_brown))
    lute_bowl(P, heart, block=(49, 40), step=16)
    rose(P, 49, 32, 7)
    lute_neck(P, (49, 26), (49, 17), pegbox=+1)
    violet_eyes(P, region(P, both(box(20, 52, 68, 64), is_red)))
    return P.img


def lut_zoroark():
    """Zoroark's tail-mane is the lute's bowl (rose facing us), its neck growing from the mane's tip; strings
    from neck to bridge; violet eye."""
    P = load("zoroark")
    tail = region(P, both(box(62, 49, 84, 64), lambda x, y, c: is_red(x, y, c) or 25 < lum(c) < 120))
    lute_bowl(P, tail, block=(62, 60), step=12)
    lute_neck(P, (81, 53), (88, 44), pegbox=-1)
    lute_strings(P, (80, 54), (68, 60))
    rose(P, 73, 57, 5)
    violet_eyes(P, region(P, both(box(22, 30, 40, 42), lambda x, y, c: c[2] > c[0] + 30 or (c[1] > c[0] + 30))))
    return P.img


def lut_noivern():
    """Noivern's speaker-ears are hollow lute bowls: ribbed wood, the opening dark with strings across and
    the haunting glowing inside, the tips bent back into pegboxes."""
    P = load("noivern")
    for b, block in (((18, 14, 34, 38), (30, 38)), ((34, 14, 52, 40), (40, 40))):
        ear = region(P, both(box(*b), lambda x, y, c: lum(c) > 35))
        lute_bowl(P, ear, block=block, step=13)
        cx, cy = (b[0] + b[2]) // 2, (b[1] + b[3]) // 2 + 2
        hole = [p for p in P.ellipse(cx, cy, 4, 5) if p in ear]
        for (x, y) in hole:
            P.put(x, y, HOLE)
        for (x, y) in edge(hole):
            P.put(x, y, (110, 56, 24) if y < cy else (246, 198, 124))
        P.put(cx, cy + 2, SPIRIT[2]); P.put(cx - 1, cy + 3, SPIRIT[1]); P.put(cx + 1, cy + 3, SPIRIT[1])
        P.line([(cx - 1, cy - 4), (cx - 1, cy + 4)], GOLD[3], cond=lambda x, y: (x, y) in hole)
        P.line([(cx + 1, cy - 4), (cx + 1, cy + 4)], GOLD[2], cond=lambda x, y: (x, y) in hole)
    return P.img


def lut_sporeye():
    """Sporeye's glowcaps are little lutes: each cap is a ribbed honey bowl, the head-cap with a rose, its
    stem the neck; the gem eyes glow violet."""
    P = load("sporeye")
    caps = region(P, is_mint)
    lute_bowl(P, caps, block=(50, 40), step=15)
    rose(P, 50, 27, 5)
    violet_eyes(P, region(P, lambda x, y, c: c[2] > c[0] + 50 and lum(c) > 120))
    return P.img


def lut_myconarch():
    """Myconarch's great cap is a lute's bowl seen from beneath: honey wood, its gills become the ribs, the
    crown crystal is the rose; violet crystals."""
    P = load("myconarch")
    cap = region(P, both(box(0, 0, 95, 36), lambda x, y, c: is_mint(x, y, c) or (g := c[1]) > 200))
    lute_bowl(P, cap, block=(47, 40), step=9)
    rose(P, 46, 8, 7)
    violet_eyes(P, region(P, both(box(30, 18, 60, 48), lambda x, y, c: c[1] > c[0] + 40 and c[2] > c[0] + 20)))
    return P.img


LUT_EVO = {2: lut_ivysaur, 3: lut_venusaur, 338: lut_zoroark, 441: lut_noivern, 585: lut_sporeye, 586: lut_myconarch}


# --- Hauntello as head
def hau_ivysaur():
    """Ivysaur's body is the cello (varnish, purfling, f-holes, bridge and tailpiece); the bud's stalk is the
    neck and the bud curls into the scroll; its grin is the soundhole; violet eyes."""
    P = load("ivysaur")
    eyes = region(P, both(box(36, 55, 52, 63), is_red))
    mouth = region(P, both(box(30, 63, 50, 69), is_red))
    body = region(P, both(box(18, 44, 76, 75), is_teal))
    cello_body(P, body, purfle=3)
    f_hole(P, 52, 56, 6); f_hole(P, 68, 54, 6, flip=True)
    bridge_tailpiece(P, 60, 62, strings=3, rise=2)
    bud = region(P, both(box(36, 18, 58, 46), is_pink))
    recolour_ramp(P, bud, CELLO[1:5])
    cello_neck(P, (46, 40), (46, 26), small=False)
    mouth_soundhole(P, mouth)
    violet_eyes(P, eyes)
    return P.img


def hau_venusaur():
    """Venusaur's great body is the cello's (purfling, f-holes either flank, bridge and tailpiece on its
    chest); the palm trunk is the neck rising through the flower to the scroll; its wide mouth is the
    soundhole; violet eyes."""
    P = load("venusaur")
    eyes = region(P, both(box(20, 52, 68, 62), is_red))
    mouth = region(P, both(box(30, 62, 66, 72), is_red))
    body = region(P, both(box(8, 40, 88, 82), is_teal))
    cello_body(P, body, purfle=3)
    f_hole(P, 18, 62, 7); f_hole(P, 78, 62, 7, flip=True)
    bridge_tailpiece(P, 48, 74, strings=4, rise=2)
    cello_neck(P, (49, 38), (49, 20))
    mouth_soundhole(P, mouth)
    violet_eyes(P, eyes)
    return P.img


def hau_zoroark():
    """Zoroark's torso is the cello (purfling, f-holes, bridge and tailpiece, endpin); its mane-crest is
    the neck and scroll; strings run out its arms and fray past the claws; violet eye."""
    P = load("zoroark")
    torso = region(P, both(box(36, 38, 66, 66), lambda x, y, c: 30 < lum(c) < 140 and not is_red(x, y, c)))
    cello_body(P, torso, purfle=2, dark_keep=25)
    f_hole(P, 42, 48, 5); f_hole(P, 58, 46, 5, flip=True)
    bridge_tailpiece(P, 50, 54, strings=3, rise=2)
    endpin(P, 50, 61, 5)
    cello_neck(P, (44, 30), (46, 19), small=True)
    violet_eyes(P, region(P, both(box(22, 30, 40, 42), lambda x, y, c: c[2] > c[0] + 30 or (c[1] > c[0] + 30))))
    fray(P, [(38, 50), (28, 54), (20, 56)], tips=[[(18, 56), (15, 54), (14, 51)], [(18, 57), (15, 59)]])
    return P.img


def hau_noivern():
    """Noivern's body is the cello; one speaker-ear is the neck and scroll; the bones of its wings are
    strings that fray loose past the wing-tips."""
    P = load("noivern")
    body = region(P, both(box(30, 38, 70, 75), lambda x, y, c: 40 < lum(c) < 170))
    cello_body(P, body, purfle=2)
    f_hole(P, 38, 52, 5); f_hole(P, 60, 52, 5, flip=True)
    bridge_tailpiece(P, 49, 60, strings=3, rise=2)
    cello_neck(P, (30, 32), (27, 18), small=True)
    fray(P, [(30, 42), (15, 40), (4, 30)], tips=[[(3, 28), (1, 24)], [(4, 31), (1, 32)]])
    fray(P, [(66, 44), (80, 36), (92, 22)], tips=[[(93, 20), (95, 16)], [(93, 23), (95, 25)]])
    return P.img


def hau_sporeye():
    """Sporeye's head is the cello's body (purfling, f-holes); its toothy grin is the splintered soundhole;
    a bridge and tailpiece on its chest; its ear is the neck and scroll; strings fray from its claws."""
    P = load("sporeye")
    head = region(P, both(box(24, 17, 72, 56), is_violet))
    cello_body(P, head, purfle=2)
    body = region(P, both(box(24, 56, 72, 92), is_violet))
    cello_body(P, body, purfle=0)
    grin = region(P, both(box(40, 48, 60, 54), lambda x, y, c: lum(c) > 170 or lum(c) < 45))
    mouth_soundhole(P, {p for p in grin if p[1] >= 49}, glow_at=(50, 51))
    f_hole(P, 34, 34, 5); f_hole(P, 64, 34, 5, flip=True)
    cello_neck(P, (30, 32), (28, 20), small=True)
    bridge_tailpiece(P, 50, 70, strings=3, rise=2)
    return P.img


def hau_myconarch():
    """Myconarch's slender torso is the cello's body (purfling, f-holes, bridge and tailpiece); its
    reaching arm carries strings fraying past the claws; the cap stays a cap."""
    P = load("myconarch")
    torso = region(P, both(box(30, 40, 62, 75), is_violet))
    cello_body(P, torso, purfle=2)
    f_hole(P, 38, 54, 5); f_hole(P, 54, 54, 5, flip=True)
    bridge_tailpiece(P, 46, 60, strings=3, rise=2)
    fray(P, [(36, 50), (24, 54), (14, 56)], tips=[[(12, 55), (9, 53), (8, 50)], [(12, 57), (9, 59)]])
    return P.img


HAU_EVO = {2: hau_ivysaur, 3: hau_venusaur, 338: hau_zoroark, 441: hau_noivern, 585: hau_sporeye, 586: hau_myconarch}


# --- Chorumbra as head
def cho_ivysaur():
    P = load("ivysaur")
    spirit_violet(P, region(P, is_teal))
    bud = region(P, both(box(36, 18, 58, 46), is_pink))
    lacquer(P, bud); harp_arc(P, bud, pin_every=3); inner_strings(P, bud, step=3)
    violet_eyes(P, region(P, both(box(36, 55, 52, 66), is_red)))
    beads(P, [[(56, 38), (60, 44), (61, 50)], [(54, 40), (57, 47)]])
    return P.img


def cho_venusaur():
    """Venusaur's petals are a ring of harp arcs: lacquer with gold pins along each petal's edge, strings
    strung down through them; its body turns spirit-violet."""
    P = load("venusaur")
    spirit_violet(P, region(P, is_teal))
    petals = region(P, both(box(8, 10, 90, 40), is_pink))
    lacquer(P, petals); harp_arc(P, petals, pin_every=3); inner_strings(P, petals, step=3)
    violet_eyes(P, region(P, both(box(20, 52, 68, 64), is_red)))
    return P.img


def cho_zoroark():
    P = load("zoroark")
    mane = region(P, both(box(18, 16, 72, 52), is_red))
    spirit_violet(P, region(P, lambda x, y, c: is_greyish(x, y, c) and lum(c) > 50))
    lacquer(P, mane); harp_arc(P, mane, pin_every=4); inner_strings(P, mane, step=3)
    violet_eyes(P, region(P, both(box(22, 30, 40, 42), lambda x, y, c: c[2] > c[0] + 30 or (c[1] > c[0] + 30))))
    beads(P, [[(66, 40), (72, 46), (74, 52)], [(62, 44), (66, 52)]], avoid=region(P, lambda x, y, c: True))
    return P.img


def cho_noivern():
    """Noivern's ears are harp arcs, and its great wings are harps: the wing's leading edge is the
    lacquered neck, and strings hang down through the membrane."""
    P = load("noivern")
    spirit_violet(P, region(P, lambda x, y, c: is_violet(x, y, c)))
    for b in ((18, 14, 34, 38), (34, 14, 52, 40)):
        ear = region(P, both(box(*b), lambda x, y, c: lum(c) > 35))
        lacquer(P, ear); harp_arc(P, ear, pin_every=3)
    for b in ((0, 14, 26, 70), (64, 14, 96, 70)):
        wing = region(P, both(box(*b), lambda x, y, c: lum(c) > 35))
        inner_strings(P, wing, step=3)
    return P.img


def cho_sporeye():
    P = load("sporeye")
    caps = region(P, is_mint)
    lacquer(P, caps); harp_arc(P, caps, pin_every=3); inner_strings(P, caps, step=3)
    violet_eyes(P, region(P, lambda x, y, c: c[2] > c[0] + 50 and lum(c) > 120))
    beads(P, [[(30, 40), (26, 48), (25, 54)], [(66, 40), (70, 48), (71, 54)]])
    return P.img


def cho_myconarch():
    """Myconarch's great cap is the harp: its rim the lacquered neck with gold pins, its gills the strings."""
    P = load("myconarch")
    cap = region(P, both(box(0, 0, 95, 36), lambda x, y, c: is_mint(x, y, c) or c[1] > 200))
    lacquer(P, cap)
    harp_arc(P, cap, pin_every=4)
    inner_strings(P, cap, step=3)
    return P.img


CHO_EVO = {2: cho_ivysaur, 3: cho_venusaur, 338: cho_zoroark, 441: cho_noivern, 585: cho_sporeye, 586: cho_myconarch}
