#!/usr/bin/env python3
"""Luna and Zenith on base-game bodies (2026-11-09). Their robes were bells as wide as the head and twelve rows
tall, with no arms and the feet hidden: against the base game (a body of nine or ten rows, arms at the sides, legs
that step) they read as a head on a blob and slid when they walked. Lumin and Pip already stand on base bodies.

Each frame keeps the designer's rabbit head (everything down to the outline under the chin) and takes the body,
arms, legs and walk of a base-game sheet, frame for frame, recoloured into the character's own colours. Luna's
braids, which were thin lines floating outside her head, now hang over her shoulders as two-pixel plaits inside
the outline. Zenith keeps her rose, on her chest.

    python3 tools/wennen_body.py [--out build/Characters] [--preview OUT.png]"""
import os, sys
from PIL import Image

BASE = "/home/claude/pif-682/Graphics/Characters/"
OUT = (14, 8, 13, 255)

LUNA = {
    "src": "FT_wennen_luna", "body": None,
    "swap": {(176, 198, 224): (196, 184, 222), (128, 152, 232): (150, 134, 190), (96, 96, 168): (104, 90, 146),
             (247, 207, 182): (232, 223, 237), (207, 150, 111): (179, 169, 196), (45, 73, 102): (70, 60, 96),
             (211, 76, 70): (120, 104, 150), (141, 49, 50): (80, 68, 108), (113, 72, 45): (104, 129, 141),
             (73, 48, 40): (70, 60, 96)},
    "braids": [(104, 129, 141), (163, 201, 200), (154, 217, 229)],
    "strip": [(104, 129, 141), (163, 201, 200), (154, 217, 229)],     # the old floating braid lines, cleared
}
ZENITH = {
    "src": "FT_wennen_zenith", "body": "BW (69)",
    "swap": {(22, 35, 45): (55, 107, 78), (70, 45, 70): (37, 75, 61), (98, 102, 65): (37, 75, 61),
             (109, 47, 43): (55, 107, 78), (230, 77, 40): (111, 155, 105), (149, 140, 143): (143, 130, 112),
             (238, 238, 247): (244, 230, 207), (207, 150, 111): (196, 181, 155), (227, 179, 143): (229, 213, 182),
             (137, 80, 47): (143, 130, 112)},
    "rose": [(215, 140, 148), (170, 90, 110)],
}

def is_out(p):
    return p[3] and max(p[:3]) < 45

def head_bottom(fr):
    """The outline row under the chin: the lowest row in the top three-quarters with a run of 8+ outline pixels."""
    px = fr.load()
    x0, y0, x1, y1 = fr.getbbox()
    best = None
    for y in range(y0 + 8, y0 + (y1 - y0) * 3 // 4):
        run = top = 0
        for x in range(40):
            run = run + 1 if is_out(px[x, y]) else 0
            top = max(top, run)
        if top >= 8:
            best = y
    return best

def torso_top(fr):
    x0, y0, x1, y1 = fr.getbbox()
    return y0 + round((y1 - 1 - y0) * 0.55) + 1          # as tools/posegen.py's Marks: the head is a little over half

def strip(img, colours):
    """Clear the old braid lines (their colours) and any outline left standing on its own next to them."""
    px = img.load()
    w, h = img.size
    gone = set()
    for y in range(h):
        for x in range(w):
            if px[x, y][3] and px[x, y][:3] in colours:
                px[x, y] = (0, 0, 0, 0)
                gone.add((x, y))
    near_gone = {(x + dx, y + dy) for (x, y) in gone for dx in (-2, -1, 0, 1, 2) for dy in (-2, -1, 0, 1, 2)}
    for _ in range(2):
        for (x, y) in near_gone:
            if 0 <= x < w and 0 <= y < h:
                if not is_out(px[x, y]):
                    continue
                near = [(x + dx, y + dy) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)) if 0 <= x + dx < w and 0 <= y + dy < h]
                if not any(px[a, b][3] and not is_out(px[a, b]) for a, b in near):
                    px[x, y] = (0, 0, 0, 0)

def frame(cfg, w, b, row):
    hb = head_bottom(w)
    if b is None:                                         # keep the character's own body
        b, tt = w, hb + 1
    else:
        tt = torso_top(b)
    out = Image.new("RGBA", (40, 40), (0, 0, 0, 0))
    body = b.crop((0, tt, 40, 40))
    bp = body.load()
    for y in range(body.height):
        for x in range(40):
            p = bp[x, y]
            if p[3] and p[:3] in cfg.get("swap", {}):
                bp[x, y] = cfg["swap"][p[:3]] + (255,)
    if cfg.get("strip"):
        strip(body, cfg["strip"])
    out.alpha_composite(body, (0, tt))
    head = w.crop((0, 0, 40, hb + 1))
    if cfg.get("strip"):
        strip(head, cfg["strip"])
    out.alpha_composite(head, (0, tt - 1 - hb))
    px = out.load()
    x0, y0, x1, y1 = out.getbbox()
    cx = (x0 + x1) // 2
    if cfg.get("braids") and row != 3:                    # two plaits over the shoulders, banded
        light, mid = cfg["braids"][1], cfg["braids"][0]
        sides = {0: (-5, 4), 1: (2,), 2: (-3,)}[row]
        for s in sides:
            bx = cx + s
            for i in range(6):
                y = tt - 2 + i
                for dx in (0, 1):
                    px[bx + dx, y] = (light if (i + dx) % 2 == 0 else mid) + (255,)
                px[bx - 1, y] = OUT if not px[bx - 1, y][3] or is_out(px[bx - 1, y]) else px[bx - 1, y]
                px[bx + 2, y] = OUT if not px[bx + 2, y][3] or is_out(px[bx + 2, y]) else px[bx + 2, y]
            px[bx, tt + 4] = OUT; px[bx + 1, tt + 4] = OUT
    # bits the braids used to join to the body (a sleeve tip in the walk frames) would float: they go
    seen, comps = set(), []
    for y in range(40):
        for x in range(40):
            if px[x, y][3] and (x, y) not in seen:
                stack, comp = [(x, y)], []
                while stack:
                    a, b2 = stack.pop()
                    if (a, b2) in seen or not (0 <= a < 40 and 0 <= b2 < 40) or not px[a, b2][3]:
                        continue
                    seen.add((a, b2)); comp.append((a, b2))
                    stack += [(a + 1, b2), (a - 1, b2), (a, b2 + 1), (a, b2 - 1)]
                comps.append(comp)
    comps.sort(key=len)
    for comp in comps[:-1]:
        if len(comp) <= 8:
            for a, b2 in comp:
                px[a, b2] = (0, 0, 0, 0)
    if cfg.get("rose") and row == 0:                      # her rose, pinned on the chest
        r1, r2 = cfg["rose"]
        for (dx, dy, c) in ((1, 1, r1), (2, 1, r2), (1, 2, r2), (2, 2, r1)):
            px[cx + dx, tt + dy] = c + (255,)
    return out

def build(cfg):
    w = Image.open(os.path.join("build/Characters", cfg["src"] + ".png")).convert("RGBA").resize((160, 160), Image.NEAREST)
    b = Image.open(BASE + cfg["body"] + ".png").convert("RGBA").resize((160, 160), Image.NEAREST) if cfg["body"] else None
    sheet = Image.new("RGBA", (160, 160), (0, 0, 0, 0))
    for r in range(4):
        for c in range(4):
            box = (c * 40, r * 40, c * 40 + 40, r * 40 + 40)
            sheet.alpha_composite(frame(cfg, w.crop(box), b.crop(box) if b else None, r), box[:2])
    return sheet.resize((320, 320), Image.NEAREST)

if __name__ == "__main__":
    args = sys.argv[1:]
    out = args[args.index("--out") + 1] if "--out" in args else "build/Characters"
    for cfg in (LUNA,):
        build(cfg).save(os.path.join(out, cfg["src"] + ".png"))
        print(cfg["src"])
