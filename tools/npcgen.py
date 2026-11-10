#!/usr/bin/env python3
"""Minor named NPCs on their own sprites (2026-11-10).

The named one-offs (shopkeepers, speakers, dwarves at the bar) walked about in the base game's townsfolk sheets,
which often contradicted their own lines: a red-bearded dwarf drawn as a tall man in a sun hat, a half-orc with a
human face. Each one here starts from a base-game sheet (so it moves and reads like every other villager) and is
made into the person the writing describes:

  hair / clothes / clothes2 / skin   the colour families found in the sheet are moved to the person's colours,
                                     each shade kept in its place (hue and saturation taken, lightness offset)
  race   dwarf     legs shortened 3 rows (stocky, the head the same size)
         small     gnome or halfling: legs shortened 5 rows
         halforc   grey-green skin, two small tusks
         elf       pointed ears
  beard  a beard in the hair colour over the chin and chest (front and sides)

Roles are found, not listed: skin is the commonest colour in the middle of the face (and its shades); hair is
whatever else the back view's head is made of; clothes are the torso's colours, grouped by hue, largest group first.

    python3 tools/npcgen.py [--out build/Characters] [--preview OUT.png] [IDS...]
The map builders put the stand-ins on the maps; tools/npc_graphics.rb (the last build step) swaps in these sheets
by event name (NPCS below, written to build/npc_graphics.json)."""
import os, sys, json, colorsys
from collections import Counter
from PIL import Image

BASE = "/home/claude/pif-682/Graphics/Characters/"
OUTLINE = (0, 0, 0)

def find(name):
    for f in os.listdir(BASE):
        if os.path.splitext(f)[0].lower() == name.lower():
            return BASE + f
    raise FileNotFoundError(name)

def load(name):
    """The sheet at native size (a 320 sheet is drawn at 2x, so halved; older 256/272x288 sheets are 1x already)."""
    im = Image.open(find(name)).convert("RGBA")
    k = 2 if im.size == (320, 320) else 1
    return (im.resize((im.width // 2, im.height // 2), Image.NEAREST) if k == 2 else im), k

def lum(c):
    return 0.299 * c[0] + 0.587 * c[1] + 0.114 * c[2]

def hls(c):
    return colorsys.rgb_to_hls(*(v / 255 for v in c[:3]))

def dark(c):
    return lum(c) < 46

def frames(sheet):
    fw, fh = sheet.width // 4, sheet.height // 4
    return [[sheet.crop((c * fw, r * fh, c * fw + fw, r * fh + fh)) for c in range(4)] for r in range(4)]

def opaque_rows(fr):
    px = fr.load()
    return [y for y in range(fr.height) if any(px[x, y][3] > 128 for x in range(fr.width))]

def figure(fr):
    """Top, bottom (of the figure, not its shadow) and the neck row (the base game's heads are about 55%)."""
    px = fr.load()
    ys = [y for y in range(fr.height) if any(px[x, y][3] > 200 for x in range(fr.width))]
    top, bot = ys[0], ys[-1]
    return top, bot, top + round((bot - top) * 0.55)

# --- roles ----------------------------------------------------------------------------------------------------------
def roles(sheet):
    F = frames(sheet)
    front, back = F[0][0], F[3][0]
    fw = front.width
    top, bot, neck = figure(front)
    px = front.load()
    xs = [x for y in range(top, neck) for x in range(fw) if px[x, y][3] > 200]
    cx = (min(xs) + max(xs)) // 2
    face = Counter()
    for y in range(top + round((neck - top) * 0.45), top + round((neck - top) * 0.72)):   # eye level: not a beard
        for x in range(cx - 4, cx + 5):
            p = px[x, y]
            if p[3] > 200 and not dark(p):
                face[p[:3]] += 1
    anchor = face.most_common(1)[0][0]
    ah, al, as_ = hls(anchor)
    def skinlike(c):
        h, l, s = hls(c)
        dh = min(abs(h - ah), 1 - abs(h - ah))
        return dh < 0.045 and abs(s - as_) < 0.35 and l > 0.25
    allc = Counter(p[:3] for p in sheet.getdata() if p[3] > 200)
    skin = {c for c in allc if skinlike(c) and not dark(c)}
    beardc = Counter()                                  # a beard the base already has: the lower face, not skin
    for y in range(top + round((neck - top) * 0.78), neck + 1):
        for x in range(cx - 4, cx + 5):
            p = px[x, y]
            if p[3] > 200 and not dark(p) and p[:3] not in skin:
                beardc[p[:3]] += 1
    btop, bbot, bneck = figure(back)
    bp = back.load()
    hair = Counter()
    for y in range(btop, bneck):
        for x in range(back.width):
            p = bp[x, y]
            if p[3] > 200 and not dark(p) and p[:3] not in skin:
                hair[p[:3]] += 1
    hairset = {c for c, n in hair.items() if n >= 2} | {c for c, n in beardc.items() if n >= 2}
    torso = Counter()
    for r in (0, 1, 2):
        fr = F[r][0]
        t, b, n = figure(fr)
        fp = fr.load()
        for y in range(n + 1, b - 1):
            for x in range(fr.width):
                p = fp[x, y]
                if p[3] > 200 and not dark(p) and p[:3] not in skin and p[:3] not in hairset:
                    torso[p[:3]] += 1
    # group the torso's colours by hue (greys on their own), biggest group first
    groups = []
    for c, n in torso.most_common():
        h, l, s = hls(c)
        key = None
        for g in groups:
            gh, gs = g["h"], g["s"]
            grey, ggrey = s < 0.12, gs < 0.12
            if (grey and ggrey) or (not grey and not ggrey and min(abs(h - gh), 1 - abs(h - gh)) < 0.06):
                key = g
                break
        if key:
            key["cols"].add(c); key["n"] += n
        else:
            groups.append({"h": h, "s": s, "cols": {c}, "n": n})
    groups.sort(key=lambda g: -g["n"])
    return {"skin": skin, "hair": hairset, "clothes": [g["cols"] for g in groups]}

def shift(cols, target):
    """Each colour of a family to the target's hue and saturation, lightness kept relative to the family's middle."""
    th, tl, ts = hls(target)
    ls = sorted(hls(c)[1] for c in cols)
    mid = ls[len(ls) // 2]
    sat = [hls(c)[2] for c in cols]
    smid = sorted(sat)[len(sat) // 2] or 1
    out = {}
    for c in cols:
        h, l, s = hls(c)
        nl = max(0.04, min(0.96, tl + (l - mid)))
        ns = max(0, min(1, ts * (s / smid if smid > 0.05 else 1)))
        r, g, b = colorsys.hls_to_rgb(th, nl, ns)
        out[c] = (round(r * 255), round(g * 255), round(b * 255))
    return out

# --- body changes -----------------------------------------------------------------------------------------------------
def shorten(fr, k):
    """Take k rows out of the shins (feet kept on the ground line), everything above coming down."""
    top, bot, neck = figure(fr)
    legs = list(range(bot - 1 - k, bot - 1))
    src = [y for y in range(fr.height) if y not in legs]
    out = Image.new("RGBA", fr.size, (0, 0, 0, 0))
    for i, y in enumerate(src):
        out.paste(fr.crop((0, y, fr.width, y + 1)), (0, i + k))
    # the shadow under the feet, if the sheet has one, stays where it was
    sp = fr.load()
    op = out.load()
    for y in range(bot + 1, fr.height):
        for x in range(fr.width):
            op[x, y] = sp[x, y]
    return out

def beard(fr, row, colour, skin):
    """A beard over the chin and the top of the chest, in the hair's colours, outlined."""
    if row == 3:
        return fr
    top, bot, neck = figure(fr)
    px = fr.load()
    fw = fr.width
    xs = [x for y in range(top, neck) for x in range(fw) if px[x, y][3] > 200]
    cx = (min(xs) + max(xs)) // 2
    if row == 0:
        cols = range(cx - 3, cx + 4)
        y0, y1 = neck - 3, neck + 3
    else:
        fwd = 1 if row == 2 else -1
        edge = max(xs) if fwd > 0 else min(xs)
        cols = range(edge - 4, edge) if fwd > 0 else range(edge + 1, edge + 5)
        y0, y1 = neck - 3, neck + 2
    cells = set()
    for y in range(y0, y1 + 1):
        w = 3 - max(0, y - (y1 - 2)) if row == 0 else 2
        for x in cols:
            if px[x, y][3] > 200 and (px[x, y][:3] in skin or y >= neck) and (row != 0 or abs(x - cx) <= w):
                cells.add((x, y))
    if row == 0:                                          # keep the eyes and nose clear: only below the mouth line
        cells = {(x, y) for (x, y) in cells if y >= neck - 2}
    light, mid, shade = colour
    for (x, y) in cells:
        px[x, y] = (mid if (x + y) % 3 else shade) + (255,)
        if y == min(c[1] for c in cells):
            px[x, y] = light + (255,)
    for (x, y) in cells:
        for dx, dy in ((1, 0), (-1, 0), (0, 1)):
            q = (x + dx, y + dy)
            if q not in cells and 0 <= q[0] < fw and 0 <= q[1] < fr.height and (not px[q][3] or q[1] > y):
                if q[1] > y and q not in cells:
                    px[q] = OUTLINE + (255,)
    return fr

def bandage(fr, row):
    """A strip of white bandage round the crown, slanting (Korux: bald and bandaged)."""
    top, bot, neck = figure(fr)
    px = fr.load()
    for x in range(fr.width):
        for k in (0, 1):
            y = top + 2 + k + (x * 3) // fr.width
            if px[x, y][3] > 200 and not dark(px[x, y]):
                px[x, y] = ((236, 232, 220) if k == 0 else (196, 190, 178)) + (255,)
    return fr

def tusks(fr, row):
    if row != 0:
        return fr
    top, bot, neck = figure(fr)
    px = fr.load()
    xs = [x for y in range(top, neck) for x in range(fr.width) if px[x, y][3] > 200]
    cx = (min(xs) + max(xs)) // 2
    for x in (cx - 2, cx + 2):
        px[x, neck - 2] = (240, 236, 220, 255)
    return fr

def ears(fr, row, skin_col):
    """Pointed ears: two pixels out and one up from the side of the head at eye level (the near one side-on)."""
    top, bot, neck = figure(fr)
    px = fr.load()
    y = top + round((neck - top) * 0.62)
    w = {yy: [x for x in range(fr.width) if px[x, yy][3] > 200] for yy in (y - 2, y - 1, y)}
    if not w[y]:
        return fr
    L, R = min(w[y]), max(w[y])
    sides = {0: (-1, 1), 3: (-1, 1), 1: (1,), 2: (-1,)}[row]
    for d in sides:
        x0 = L if d < 0 else R
        pts = [(x0 + d, y), (x0 + 2 * d, y - 1)]
        for (x, yy) in pts:
            if 0 <= x < fr.width:
                px[x, yy] = skin_col + (255,)
        for (x, yy) in pts:
            for dx, dy in ((d, 0), (0, -1), (0, 1)):
                q = (x + dx, yy + dy)
                if 0 <= q[0] < fr.width and not px[q][3] and q not in pts:
                    px[q] = OUTLINE + (255,)
    return fr

# --- one person ---------------------------------------------------------------------------------------------------------
def build(spec):
    sheet, k = load(spec["base"])
    swap = {}
    body_swap = {}
    for item in spec.get("recolour", []):                  # each family of the base's colours to the person's
        cols, target = item[0], item[1]
        (body_swap if len(item) > 2 and item[2] == "body" else swap).update(shift(cols, target))
    if spec.get("race") == "halforc":
        swap.update(shift(BASE_SKIN[spec["base"]], (134, 152, 118)))
    if spec.get("skin"):
        swap.update(shift(BASE_SKIN[spec["base"]], spec["skin"]))
    R = {"skin": BASE_SKIN.get(spec["base"], [])}
    px = sheet.load()
    for y in range(sheet.height):
        for x in range(sheet.width):
            p = px[x, y]
            if p[3] > 200 and p[:3] in swap:
                px[x, y] = swap[p[:3]] + (p[3],)
    skin_main = max((swap.get(c, c) for c in R["skin"]), key=lum) if R["skin"] else (230, 190, 160)
    hc = spec.get("hair") or (120, 90, 60)
    th, tl, ts = hls(hc)
    ramp = tuple(tuple(round(v * 255) for v in colorsys.hls_to_rgb(th, max(0.05, min(0.95, tl + d)), ts)) for d in (0.12, 0, -0.14))
    F = frames(sheet)
    out = Image.new("RGBA", sheet.size, (0, 0, 0, 0))
    fw, fh = F[0][0].size
    shrink = {"dwarf": 3, "small": 5}.get(spec.get("race"), 0) + spec.get("shorter", 0)
    for r in range(4):
        for c in range(4):
            fr = F[r][c]
            if body_swap:                                  # colours the head also uses (its outline's shading)
                t, b, n = figure(fr)
                fp = fr.load()
                for y in range(n - 1, fr.height):
                    for x in range(fr.width):
                        q = fp[x, y]
                        if q[3] > 200 and q[:3] in body_swap:
                            fp[x, y] = body_swap[q[:3]] + (q[3],)
            if shrink:
                fr = shorten(fr, shrink)
            if spec.get("beard"):
                fr = beard(fr, r, ramp, {swap.get(s, s) for s in R["skin"]})
            if spec.get("race") == "halforc":
                fr = tusks(fr, r)
            if spec.get("bandage"):
                fr = bandage(fr, r)
            if spec.get("race") == "elf":
                fr = ears(fr, r, skin_main)
            out.alpha_composite(fr, (c * fw, r * fh))
    if k == 2:
        out = out.resize((out.width * 2, out.height * 2), Image.NEAREST)
    return out

# --- the base sheets' colours, by what they are (read off each sheet's palette) -------------------------------------
BASE_SKIN = {"BW (39)": [(247, 207, 182), (207, 150, 111)], "BW (36)": [(247, 207, 182), (207, 150, 111)],
             "BW (40)": [(247, 207, 182), (207, 150, 111)], "BW (21)": [(247, 207, 182), (207, 150, 111)],
             "BW (34)": [(247, 207, 182), (207, 150, 111)], "BW (71)": [(195, 139, 80), (213, 172, 132)],
             "BW (80)": [(247, 207, 182), (207, 150, 111)]}
B39_BEARD = [(109, 101, 43), (163, 111, 49), (211, 172, 114)]
B39_TUNIC = [(113, 72, 45), (73, 48, 40)]                 # (also the head's edge shading: body rows only)
B36_SHIRT = [(76, 105, 86), (96, 176, 144)]
B36_JEANS = [(45, 73, 102), (79, 111, 143)]
B40_HAIR = [(73, 73, 77), (144, 136, 115), (166, 166, 166)]
B40_DRESS = [(102, 56, 100), (162, 69, 138)]
B21_HAIR = [(163, 111, 49), (113, 72, 45), (195, 139, 80), (73, 48, 40)]
B21_SUIT = [(200, 200, 212), (171, 152, 199), (105, 80, 105)]
B34_HAIR = [(70, 45, 70), (109, 75, 80)]
B34_TOP = [(236, 228, 114), (177, 138, 76)]

# --- who ------------------------------------------------------------------------------------------------------------------
# id: base sheet, the event names it replaces, and the person (from the art requests, docs/art_requests_W*.md)
NPCS = {
    # the Foaming Mugs dwarves (W2): frostbitten, iron-shod; Hruna braided and stern, Korux bald and bandaged,
    # Storn young and red-bearded
    "FT_npc_hruna": dict(names=["Hruna"], base="BW (40)", race="dwarf",
                         recolour=[(B40_HAIR, (150, 84, 48)), (B40_DRESS, (96, 104, 116))]),
    "FT_npc_korux": dict(names=["Korux"], base="BW (39)", race="dwarf", bandage=True,
                         recolour=[(B39_BEARD, (90, 62, 44)), (B39_TUNIC, (110, 116, 124), "body")]),
    "FT_npc_storn": dict(names=["Storn"], base="BW (39)", race="dwarf",
                         recolour=[(B39_BEARD, (128, 52, 34)), (B39_TUNIC, (70, 92, 126), "body")]),
    # Good Mead's logger (W2): red-bearded shield dwarf, axe on the shoulder
    "FT_npc_shandar_froth": dict(names=["Shandar Froth"], base="BW (39)", race="dwarf",
                                 recolour=[(B39_BEARD, (210, 96, 40)), (B39_TUNIC, (62, 92, 64), "body")]),
    # Rootspire's sap-smith ("Tarin Goldlash, dwarf sap-smith"): a golden beard, an amber apron
    "FT_npc_tarin_goldlash": dict(names=["Tarin Goldlash"], base="BW (36)", race="dwarf",
                                  recolour=[(B36_SHIRT, (196, 132, 44)), (B36_JEANS, (96, 70, 50))]),
    # the Morninglord's tinkerer (W2): rock gnome, wild copper hair
    "FT_npc_copper": dict(names=["Copper Knobberknocker"], base="BW (21)", race="small",
                          recolour=[(B21_HAIR, (206, 104, 44)), (B21_SUIT, (122, 102, 74))]),
    # Termalaine's speaker (W2): broad half-orc, sharp tired face, speaker's chain over furs
    "FT_npc_oarus_masthew": dict(names=["Oarus Masthew"], base="BW (36)", race="halforc",
                                 recolour=[(B36_SHIRT, (110, 90, 68)), (B36_JEANS, (70, 66, 62))]),
    # the half-orc monk (W5): sunburst and snowflake tattoos
    "FT_npc_rilka_dawnshard": dict(names=["Rilka Dawnshard"], base="BW (34)", race="halforc",
                                   recolour=[(B34_HAIR, (44, 40, 48)), (B34_TOP, (214, 146, 56))]),
    # the Skytower goliath (W5): very tall, grey skin
    "FT_npc_kethan_vale": dict(names=["Captain Kethan Vale", "Captain Kethan Vale (hearing)"], base="BW (80)",
                               skin=(150, 156, 164)),
}

def main():
    args = sys.argv[1:]
    out = args[args.index("--out") + 1] if "--out" in args else "build/Characters"
    prev = args[args.index("--preview") + 1] if "--preview" in args else None
    ids = [a for i, a in enumerate(args) if not a.startswith("--") and (i == 0 or args[i - 1] not in ("--out", "--preview"))]
    os.makedirs(out, exist_ok=True)
    made = []
    for nid, spec in NPCS.items():
        if ids and nid not in ids:
            continue
        im = build(spec)
        im.save(os.path.join(out, nid + ".png"))
        made.append((nid, spec, im))
        print(nid)
    json.dump({nid: {"names": s["names"], "base": s["base"]} for nid, s in NPCS.items()},
              open("build/npc_graphics.json", "w"), indent=1)
    if prev:
        cols = 6
        sh = Image.new("RGBA", (cols * 2 * 90, ((len(made) + cols - 1) // cols) * 90), (196, 210, 200, 255))
        for i, (nid, spec, im) in enumerate(made):
            base = Image.open(find(spec["base"])).convert("RGBA")
            for j, s in enumerate((base, im)):
                f = s.crop((0, 0, s.width // 4, s.height // 4))
                f = f.resize((80, 80), Image.NEAREST) if f.width != 80 else f
                sh.alpha_composite(f, ((i % cols) * 180 + j * 85, (i // cols) * 90))
        sh.resize((sh.width * 2, sh.height * 2), Image.NEAREST).save(prev)

if __name__ == "__main__":
    main()
