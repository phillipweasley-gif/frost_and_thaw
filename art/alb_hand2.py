"""Lutling- and Hauntello-headed merges redrawn with the instruments' real anatomy (alb_anat).
Lute: ribbed back seen only at the edges, pale soundboard in front with the rose high and the bridge low,
strings bridge -> rose -> narrow end -> fretted neck -> pegbox bent back with a row of pegs.
Cello: one axis - endpin, tailpiece, bridge at the waist between notched f-holes, fingerboard, straight
pegbox with pegs either side, scroll - strings unbroken along it. Coordinates read off each partner's sprite."""
from alb_anat import *
from alb_hand import PURPLE_SABLEYE, GEM_SABLEYE, GREEN_BULB, RED_BULBA

GENGAR = [(175, 150, 199), (148, 115, 180), (110, 85, 134), (61, 32, 61)]
GRIN_G = ((247, 238, 247), (93, 85, 109), (177, 159, 177), (212, 203, 212))


def eyes_violet(P, test):
    violet_eyes(P, region(P, test))


# ================================================================================ LUTLING (577)
def L_bulbasaur():
    P = load("bulbasaur")
    eyes = region(P, both(box(26, 40, 50, 48), colours_in(RED_BULBA)))
    lute(P, region(P, colours_in(GREEN_BULB)), joint=(57, 31), block=(54, 48), neck_end=(63, 22), side=-1,
         board=(54.5, 39.5, 5.2, 8.5, -12), rose=(55.2, 36.2, 2.4), bridge=(53.8, 44.2, 2.8))
    violet_eyes(P, eyes)
    return P.img


def L_sableye():
    """The head is the bowl; its face is the soundboard, the rose on the brow between the gem eyes, the
    bridge at the chin; the left ear is the neck, its tip the pegbox."""
    P = load("sableye")
    gems = region(P, colours_in(GEM_SABLEYE))
    head = region(P, both(box(33, 26, 64, 47), colours_in(PURPLE_SABLEYE)))
    lute(P, head, joint=(41, 31), block=(44, 47), neck_end=(37, 23), side=-1,
         board=(43.5, 39.5, 3.4, 8.0, 0), rose=(43.2, 35.5, 1.8), bridge=(43.6, 44.6, 2.2))
    violet_eyes(P, gems)
    return P.img


def L_zorua():
    P = load("zorua")
    eyes = region(P, colours_in([(24, 180, 180), (49, 131, 131)]))
    tail = region(P, both(box(58, 41, 68, 59), not_dark(25)))
    lute(P, tail, joint=(64, 42), block=(61, 59), neck_end=(68, 32), side=+1,
         board=(62.4, 51, 3.4, 7, 10), rose=(63.2, 48, 1.8), bridge=(61.6, 55.5, 2.0))
    violet_eyes(P, eyes)
    return P.img


def L_noibat():
    """Each great ear is a lute seen from the front: the inner ear its soundboard with a rose and a bridge,
    the ribbed back showing round the rim, the ear-tip its narrow end, neck and pegbox rising from it."""
    P = load("noibat")
    outer = [(146, 103, 193), (108, 76, 143), (173, 141, 208)]
    inner = [(105, 88, 105), (178, 149, 179), (136, 114, 136), (134, 130, 130), (79, 77, 77)]
    for b, joint, block, neck, side, board, rose_, bridge_ in (
            ((33, 22, 47, 40), (39, 24), (43, 40), (35, 17), -1, (41, 32, 3.6, 7, -12), (40.4, 29.5, 1.8), (42.2, 36.5, 2.2)),
            ((48, 22, 63, 40), (59, 24), (52, 40), (63, 17), +1, (55.5, 32, 3.6, 7, 14), (56.6, 29.5, 1.8), (53.6, 36.5, 2.2))):
        ear = region(P, both(box(*b), colours_in(outer + inner)))
        lute(P, ear, joint=joint, block=block, neck_end=neck, side=side, board=board, rose=rose_, bridge=bridge_, pegs=4)
    return P.img


def _paddle(name, box_, joint, block, neck_end, side, board, rose_, bridge_, eye_box):
    P = load(name)
    eyes = region(P, both(box(*eye_box), lambda x, y, c: lum(c) < 60))
    paddle = region(P, both(box(*box_), porcelain))
    lute(P, paddle, joint=joint, block=block, neck_end=neck_end, side=side, board=board, rose=rose_, bridge=bridge_)
    violet_eyes(P, eyes)
    return P.img


def L_wickit():
    return _paddle("wickit", (53, 31, 73, 51), (55, 33), (68, 49), (49, 25), -1,
                   (61.5, 41, 7.5, 4.6, 51), (59.7, 38.8, 2.2), (65.4, 45.8, 2.6), (30, 55, 37, 60))


def L_stoketail():
    return _paddle("stoketail", (9, 20, 36, 51), (33, 23), (13, 49), (40, 15), +1,
                   (23, 36, 10, 6, 127.6), (25.8, 32.4, 3.0), (17, 43.8, 4), (60, 18, 66, 24))


def L_forgel():
    """The paddle is the bowl lying along the ground, the tail its neck back up to the hip, where the pegbox
    bends back."""
    return _paddle("forgel", (0, 66, 32, 81), (31, 70), (2, 71), (43, 62), -1,
                   (16, 71, 11, 3.6, 0), (21.5, 70.5, 2.4), (7.5, 71, 2.6), (69, 38, 75, 44))


def L_ivysaur():
    P = load("ivysaur")
    eyes = region(P, both(box(36, 55, 52, 66), is_red))
    bud = region(P, both(box(36, 18, 58, 46), is_pink))
    lute(P, bud, joint=(47, 22), block=(46, 44), neck_end=(52, 13), side=+1,
         board=(45.5, 34, 4.4, 9, 0), rose=(45.8, 30, 2.2), bridge=(46, 40.5, 3.0))
    violet_eyes(P, eyes)
    return P.img


def L_venusaur():
    """The heart of the flower is the bowl seen face-on: soundboard, rose and bridge; the neck rises from
    its top through the crown of the flower to the bent-back pegbox."""
    P = load("venusaur")
    eyes = region(P, both(box(20, 52, 68, 62), is_red))
    heart = region(P, both(box(36, 20, 62, 40), is_brown))
    lute(P, heart, joint=(49, 24), block=(49, 39), neck_end=(49, 13), side=+1,
         board=(49, 32, 6.5, 5.5, 0), rose=(49, 29.5, 2.4), bridge=(49, 35.8, 4))
    violet_eyes(P, eyes)
    return P.img


def L_zoroark():
    P = load("zoroark")
    eyes = region(P, both(box(22, 30, 40, 42), lambda x, y, c: c[2] > c[0] + 30 or c[1] > c[0] + 30))
    tail = region(P, both(box(62, 49, 84, 64), lambda x, y, c: is_red(x, y, c) or 25 < lum(c) < 120))
    lute(P, tail, joint=(81, 54), block=(63, 58), neck_end=(88, 45), side=-1,
         board=(72, 56.5, 8.5, 3.6, 8), rose=(74.6, 55.6, 2.0), bridge=(66.5, 57.2, 2.4))
    violet_eyes(P, eyes)
    return P.img


def L_noivern():
    P = load("noivern")
    for b, joint, block, neck, side, board, rose_, bridge_ in (
            ((18, 14, 34, 38), (24, 16), (30, 38), (20, 8), -1, (27, 27, 3.4, 8, -14), (26, 22.5, 1.8), (28.8, 33.5, 2.2)),
            ((34, 14, 52, 40), (45, 16), (40, 39), (49, 8), +1, (42.5, 28, 3.4, 8, 12), (43.6, 23.5, 1.8), (41, 34.5, 2.2))):
        ear = region(P, both(box(*b), lambda x, y, c: lum(c) > 35))
        lute(P, ear, joint=joint, block=block, neck_end=neck, side=side, board=board, rose=rose_, bridge=bridge_, pegs=4)
    return P.img


def L_sporeye():
    """As with Sableye: the head is the bowl and its face the soundboard - the rose on the brow, the bridge
    above the grin - and the tall right ear is the neck, its tip the bent-back pegbox. The glowcaps stay."""
    P = load("sporeye")
    gems = region(P, both(box(36, 40, 62, 53), lambda x, y, c: c[2] > c[0] + 50 and lum(c) > 120))
    head = {p for p in region(P, both(box(24, 17, 72, 56), is_violet))
            if ((p[0] + 0.5 - 50.5) / 13.5) ** 2 + ((p[1] + 0.5 - 43) / 12) ** 2 <= 1}
    lute(P, head, joint=(61, 33), block=(50, 52), neck_end=(67, 22), side=+1,
         board=(50.5, 43.5, 9.5, 9.5, 0), rose=(51.5, 38.5, 2.2), bridge=(50.5, 49.3, 3.0), pegs=4)
    violet_eyes(P, gems)
    return P.img


def L_myconarch():
    """The giant cap is the bowl seen from beneath - the ribbed back, its gills the ribs - and the cap's
    horn is the neck, ending in the bent-back pegbox."""
    P = load("myconarch")
    cap = region(P, both(box(0, 0, 95, 36), lambda x, y, c: is_mint(x, y, c) or c[1] > 200))
    lute(P, cap, joint=(74, 12), block=(14, 22), neck_end=(84, 6), side=-1, back_view=True, pegs=5)
    return P.img


LUT2 = {1: L_bulbasaur, 421: L_sableye, 399: L_zorua, 440: L_noibat, 582: L_wickit, 583: L_stoketail,
        584: L_forgel, 2: L_ivysaur, 3: L_venusaur, 338: L_zoroark, 441: L_noivern, 585: L_sporeye, 586: L_myconarch}


# ============================================================================== HAUNTELLO (578)
def H_gengar():
    P = load("gengar")
    grin = {(x, y) for y in range(48, 57) for x in range(28, 52) if P.get(x, y)[3] and P.get(x, y)[:3] in GRIN_G}
    eyes = region(P, colours_in([(247, 77, 77), (247, 134, 134)]))
    body = region(P, colours_in(GENGAR))
    cello(P, body, bottom=(45, 68), top=(59, 30), scroll_at=(64, 16), waist_t=0.24, keep_off=grin | eyes)
    mouth_soundhole(P, grin, glow_at=(40, 54))
    violet_eyes(P, eyes)
    # loose strings out along the arms, fraying past the fingers (kept from the approved version)
    fray(P, [(29, 45), (24, 42), (20, 40), (17, 38)], tips=[[(16, 37), (14, 35), (13, 32)], [(16, 40), (13, 41)]])
    fray(P, [(61, 46), (65, 43), (70, 39), (73, 37)], tips=[[(74, 36), (76, 33), (78, 31)], [(75, 38), (78, 38)]])
    return P.img


def H_bulbasaur():
    P = load("bulbasaur")
    eyes = region(P, both(box(26, 40, 50, 48), colours_in(RED_BULBA)))
    mouth = region(P, both(box(28, 49, 46, 53), colours_in(RED_BULBA)))
    bulb = region(P, colours_in(GREEN_BULB))
    cello(P, bulb, bottom=(53, 48), top=(57, 31), scroll_at=(59, 23), waist_t=0.45, flen=4)
    mouth_soundhole(P, mouth, glow_at=(38, 51))
    violet_eyes(P, eyes)
    return P.img


def H_sableye():
    P = load("sableye")
    gems = region(P, colours_in(GEM_SABLEYE))
    head = region(P, both(box(33, 26, 64, 47), colours_in(PURPLE_SABLEYE)))
    body = region(P, both(box(26, 47, 70, 70), colours_in(PURPLE_SABLEYE)))
    grin = {(x, 45) for x in range(46, 58)} | {(x, 46) for x in range(47, 57)}
    cello_body(P, body, purfle=0)
    cello(P, head, bottom=(43, 47), top=(41, 30), scroll_at=(37, 22), waist_t=0.28, keep_off=gems | grin, flen=4,
          endpin=False)
    mouth_soundhole(P, grin, glow_at=(51, 46))
    violet_eyes(P, gems)
    return P.img


def H_zorua():
    P = load("zorua")
    eyes = region(P, colours_in([(24, 180, 180), (49, 131, 131)]))
    body = region(P, both(box(40, 44, 64, 66), lambda x, y, c: 20 < lum(c) < 60))
    recolour_ramp(P, body, [(60, 18, 16), (96, 30, 24), (140, 50, 36), (178, 72, 50)], dark_keep=20)
    cello(P, body, bottom=(41, 58), top=(61, 51), scroll_at=(67, 41), waist_t=0.45, purfle=0, flen=4)
    violet_eyes(P, eyes)
    return P.img


def H_noibat():
    P = load("noibat")
    chest = region(P, both(box(36, 39, 58, 56), lambda x, y, c: lum(c) > 150 and c[0] > c[1]))
    cello(P, chest, bottom=(46, 56), top=(52, 40), scroll_at=(59, 25), waist_t=0.42, flen=5, endpin=True)
    fray(P, [(36, 47), (26, 47), (18, 50)], tips=[[(17, 50), (14, 49), (12, 46)], [(17, 51), (14, 53)]])
    fray(P, [(58, 47), (70, 48), (82, 50)], tips=[[(83, 50), (86, 48), (87, 45)], [(83, 51), (86, 53)]])
    return P.img


def _ferret(name, paddle_box, bottom, top, scroll_at, waist, mouth_box, eye_box):
    """The Cinderwright ferrets: the porcelain paddle is the cello's body (it is already a cello's
    teardrop-and-waist shape) - endpin at the paddle's tip, tailpiece, bridge between the f-holes - and the
    tail is the neck, running straight down to the pegbox and scroll at the tail's root."""
    P = load(name)
    eyes = region(P, both(box(*eye_box), lambda x, y, c: lum(c) < 60))
    mouth = region(P, both(box(*mouth_box), lambda x, y, c: lum(c) < 60 or (c[0] > 200 and c[1] < 120)))
    paddle = region(P, both(box(*paddle_box), porcelain))
    for (x, y) in paddle:
        if lum(P.get(x, y)[:3]) < 60:
            P.put(x, y, CELLO[0])
    cello(P, [p for p in paddle if P.get(*p)[:3] != CELLO[0]], bottom=bottom, top=top, scroll_at=scroll_at,
          waist_t=waist, flen=5, purfle=2)
    mouth_soundhole(P, mouth)
    violet_eyes(P, eyes)
    return P.img


def H_wickit():
    return _ferret("wickit", (53, 31, 73, 51), (55, 33), (67, 49), (69, 64), 0.55, (23, 59, 30, 63), (30, 55, 37, 60))


def H_stoketail():
    return _ferret("stoketail", (9, 20, 36, 51), (33, 23), (13, 49), (6, 59), 0.55, (51, 26, 56, 29), (60, 18, 66, 24))


def H_forgel():
    return _ferret("forgel", (0, 66, 32, 81), (2, 71), (31, 70), (41, 64), 0.5, (64, 43, 70, 46), (69, 38, 75, 44))


def H_ivysaur():
    P = load("ivysaur")
    eyes = region(P, both(box(36, 55, 52, 63), is_red))
    mouth = region(P, both(box(30, 63, 50, 69), is_red))
    body = region(P, both(box(18, 44, 76, 75), is_teal))
    bud = region(P, both(box(36, 18, 58, 46), is_pink))
    recolour_ramp(P, bud, CELLO[1:5])
    cello(P, body, bottom=(55, 74), top=(51, 47), scroll_at=(47, 22), waist_t=0.5, keep_off=eyes | mouth)
    mouth_soundhole(P, mouth)
    violet_eyes(P, eyes)
    return P.img


def H_venusaur():
    P = load("venusaur")
    eyes = region(P, both(box(20, 52, 68, 62), is_red))
    mouth = region(P, both(box(30, 62, 66, 72), is_red))
    body = region(P, both(box(8, 40, 88, 82), is_teal))
    cello(P, body, bottom=(60, 81), top=(60, 44), scroll_at=(56, 12), waist_t=0.25, keep_off=eyes | mouth, purfle=3)
    mouth_soundhole(P, mouth)
    violet_eyes(P, eyes)
    return P.img


def H_zoroark():
    P = load("zoroark")
    eyes = region(P, both(box(22, 30, 40, 42), lambda x, y, c: c[2] > c[0] + 30 or c[1] > c[0] + 30))
    torso = region(P, both(box(36, 38, 66, 66), lambda x, y, c: 30 < lum(c) < 140 and not is_red(x, y, c)))
    cello(P, torso, bottom=(52, 66), top=(47, 40), scroll_at=(44, 19), waist_t=0.45, purfle=2, flen=5)
    violet_eyes(P, eyes)
    fray(P, [(38, 50), (28, 54), (20, 56)], tips=[[(18, 56), (15, 54), (14, 51)], [(18, 57), (15, 59)]])
    return P.img


def H_noivern():
    P = load("noivern")
    body = region(P, both(box(30, 38, 70, 76), lambda x, y, c: 40 < lum(c) < 170))
    cello(P, body, bottom=(42, 74), top=(56, 44), scroll_at=(66, 25), waist_t=0.45, purfle=2, flen=5)
    fray(P, [(30, 42), (15, 40), (4, 30)], tips=[[(3, 28), (1, 24)], [(4, 31), (1, 32)]])
    return P.img


def H_sporeye():
    P = load("sporeye")
    gems = region(P, both(box(36, 40, 62, 53), lambda x, y, c: c[2] > c[0] + 50 and lum(c) > 120))
    grin = region(P, both(box(40, 48, 60, 54), lambda x, y, c: lum(c) > 170 or lum(c) < 45))
    grin = {p for p in grin if p[1] >= 49}
    head = region(P, both(box(24, 17, 72, 56), is_violet))
    body = region(P, both(box(24, 56, 72, 92), is_violet))
    cello_body(P, body, purfle=0)
    cello(P, head, bottom=(51, 56), top=(64, 26), scroll_at=(68, 15), waist_t=0.3, keep_off=gems | grin, flen=4,
          endpin=False)
    mouth_soundhole(P, grin, glow_at=(50, 51))
    violet_eyes(P, gems)
    return P.img


def H_myconarch():
    """The slender torso is the cello's body; the fingerboard runs up to the throat, where the pegbox sits
    with its pegs under the head (the head itself takes the scroll's place)."""
    P = load("myconarch")
    torso = region(P, both(box(30, 40, 62, 76), is_violet))
    cello(P, torso, bottom=(46, 75), top=(46, 41), scroll_at=(46, 33), waist_t=0.45, purfle=2, flen=5, scroll=False)
    fray(P, [(36, 50), (24, 54), (14, 56)], tips=[[(12, 55), (9, 53), (8, 50)], [(12, 57), (9, 59)]])
    return P.img


HAU2 = {94: H_gengar, 1: H_bulbasaur, 421: H_sableye, 399: H_zorua, 440: H_noibat, 582: H_wickit, 583: H_stoketail,
        584: H_forgel, 2: H_ivysaur, 3: H_venusaur, 338: H_zoroark, 441: H_noivern, 585: H_sporeye, 586: H_myconarch}
