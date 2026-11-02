"""Makes every fusion sprite involving Frost & Thaw's new Pokemon.

python3 fusegen.py <autogen dir> <parts dir> <out dir> [--only N,N] [--preview file]

Writes <out>/base/<n>.png and <out>/fusions/<head>/<head>.<body>.png (288x288)."""
import json, os, sys
from multiprocessing import Pool
from PIL import Image
from fusegen_core import *

PARTS = None
SHEETS = None


def nearest_named(c, named):
    best = None
    for group, cols in named.items():
        for k in cols:
            d = sum((a - b) ** 2 for a, b in zip(c, k))
            if best is None or d < best[0]:
                best = (d, group)
    return best[1]


def make_protect(meta):
    named = {**{f"W{k}": v for k, v in meta["wood"].items()}, **{f"K{k}": v for k, v in meta["keep"].items()}}
    named = {k: [tuple(c) for c in v] for k, v in named.items()}
    cache = {}

    def protect(c):
        if c not in cache:
            cache[c] = lum(c) >= 40 and nearest_named(c, named).startswith("K")
        return cache[c]
    return protect


def fill_over(img, mask):
    """Paint the old face away with the colours around it."""
    if not mask:
        return img
    img = img.copy(); px = img.load(); todo = set(mask)
    for _ in range(12):
        if not todo:
            break
        done = {}
        for (x, y) in todo:
            votes = {}
            for dx in (-1, 0, 1):
                for dy in (-1, 0, 1):
                    q = (x + dx, y + dy)
                    if q in todo or not (0 <= q[0] < S and 0 <= q[1] < S):
                        continue
                    c = px[q]
                    if c[3] > 127 and lum(c[:3]) >= 40:
                        votes[c] = votes.get(c, 0) + 1
            if votes:
                done[(x, y)] = max(votes, key=votes.get)
        for p_, c in done.items():
            px[p_] = c
        todo -= set(done)
    return img


class Mon:
    pass


def base_mon(n):
    m = Mon(); m.n = n; m.ours = False
    m.head = head_piece(SHEETS, n)
    m.head_groups = colour_groups(m.head)
    img, face, zone = body_info(SHEETS, n)
    m.body, m.face, m.zone = img, face, zone
    m.body_groups = colour_groups(img)
    m.protect = None
    return m


def our_mon(key):
    d = PARTS["species"][key]; root = PARTS["_dir"]
    m = Mon(); m.n = d["number"]; m.ours = True; m.key = key
    sprite = Image.open(f"{root}/{d['sprite']}").convert("RGBA")
    m.faces = {int(k): Image.open(f"{root}/{v}").convert("RGBA") for k, v in d["faces"].items()}
    m.protect = make_protect(PARTS) if d["protect"] else None
    m.body, m.face = sprite, set()
    cx, cy, size = d["anchor"]
    m.zone = (cx, cy, size, size)
    m.max_face = d.get("max_face", 28)
    m.body_groups = colour_groups(sprite, protect=m.protect)
    if d["families"]:
        m.head_groups = [{"cols": [tuple(c) for c in f["cols"]], "neutral": False} for f in d["families"]]
    else:
        m.head_groups = colour_groups(sprite)
    return m


def face_for(head, zone):
    cx, cy, w, h = zone
    if head.ours:
        sizes = sorted(head.faces)
        if sizes == [0]:
            return head.faces[0], True
        want = max(10, min(head.max_face, int(round(max(w, h) + 2))))
        want += want % 2
        return head.faces[min(sizes, key=lambda s_: abs(s_ - want))], False
    return head.head, True


def fusion(head, body):
    img = recolour(body.body, body.body_groups, head.head_groups, protect=body.protect)
    img = fill_over(img, body.face)
    piece, may_scale = face_for(head, body.zone)
    cx, cy, w, h = body.zone
    if may_scale:
        k = min(1.0, max(0.5, max(w, h) * 1.3 / max(piece.size)))
        piece = scaled(piece, k)
    x = int(round(cx - piece.width / 2)); y = int(round(cy - piece.height / 2))
    x = max(0, min(S - piece.width, x)); y = max(0, min(S - piece.height, y))
    img.alpha_composite(piece, (x, y))
    return img


def big(img):
    return img.resize((S * 3, S * 3), Image.NEAREST)


def init(autogen_dir, parts_dir):
    global SHEETS, PARTS
    SHEETS = Sheets(autogen_dir)
    PARTS = json.load(open(f"{parts_dir}/parts.json"))
    PARTS["_dir"] = parts_dir


OURS = None


def ours():
    global OURS
    if OURS is None:
        OURS = {k: our_mon(k) for k in PARTS["species"]}
    return OURS


def job(args):
    n, out = args
    try:
        mons = ours()
        b = base_mon(n)
        for o in mons.values():
            for head, body in ((o, b), (b, o)):
                d = f"{out}/fusions/{head.n}"
                os.makedirs(d, exist_ok=True)
                big(fusion(head, body)).save(f"{d}/{head.n}.{body.n}.png", optimize=True)
        return n, None
    except Exception as e:                     # keep going; report at the end
        return n, f"{type(e).__name__}: {e}"


def main():
    autogen_dir, parts_dir, out = sys.argv[1:4]
    only = None
    if "--only" in sys.argv:
        only = [int(x) for x in sys.argv[sys.argv.index("--only") + 1].split(",")]
    init(autogen_dir, parts_dir)
    os.makedirs(f"{out}/base", exist_ok=True)
    mons = ours()
    for o in mons.values():
        big(o.body).save(f"{out}/base/{o.n}.png", optimize=True)
        for o2 in mons.values():
            d = f"{out}/fusions/{o.n}"; os.makedirs(d, exist_ok=True)
            big(fusion(o, o2)).save(f"{d}/{o.n}.{o2.n}.png", optimize=True)
    numbers = only or list(range(1, AUTOGEN_MAX + 1))
    errors = []
    with Pool(initializer=init, initargs=(autogen_dir, parts_dir)) as pool:
        for i, (n, err) in enumerate(pool.imap_unordered(job, [(n, out) for n in numbers], chunksize=4)):
            if err:
                errors.append((n, err))
            if i % 50 == 0:
                print(f"{i}/{len(numbers)}", flush=True)
    print("errors:", errors)


if __name__ == "__main__":
    main()
