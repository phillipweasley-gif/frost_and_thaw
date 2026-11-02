"""Bring new yeti fusion sheets from the user's "Pokemon fusions/Yeti Fusion Sheets" folder into the game.

    python3 yeti_sync.py <stage name> <sheet file> [<sheet file> ...]

Sheet files are the names in the folder ("46-Chikorita-palette-corrected.png"); they must already be
staged into /mnt/user-data/uploads/Pokemon fusions/Yeti Fusion Sheets. The species comes from the
name ("-corrected" / "-palette-corrected" suffixes ignored). Writes a review picture to the scratchpad,
the sprites to build/<stage name>, and a zip with md5.json to the outputs folder for installing.
"""
import sys, os, re, json, shutil, hashlib, zipfile
sys.path.insert(0, "/home/claude/frost-thaw/art")
from PIL import Image

U = "/mnt/user-data/uploads/Pokemon fusions/Yeti Fusion Sheets"
ROOT = "/home/claude/frost-thaw"
OUR = {"rimirage": 580, "wickit": 582, "stoketail": 583, "forgel": 584, "lutling": 577, "hauntello": 578,
       "chorumbra": 579, "sporeye": 585, "myconarch": 586, "gloamcap": 581}


def key_of(fname):
    m = re.match(r"\d+-(.+?)(?:-palette-corrected|-corrected)?\.png$", fname)
    return m.group(1).lower() if m else None


def main():
    stage, files = sys.argv[1], sys.argv[2:]
    import yeti_mock as M
    names = {v.lower(): int(k) for k, v in json.load(open(f"{ROOT}/build/fusion_names.json"))["species"].items()}
    sj = f"{M.MOCK}/sheets.json"
    sheets = json.load(open(sj))
    new = {}
    for f in files:
        k = key_of(f)
        num = OUR.get(k) or names.get(k)
        if num is None:
            print("unknown species:", f); continue
        shutil.copy(f"{U}/{f}", f"{M.MOCK}/{k}.png")
        new[k] = num
    sheets.update(new)
    json.dump(sheets, open(sj, "w"), indent=0)
    M.SHEETS.update({k: [v] * 4 for k, v in new.items()})
    cache = {}
    for k in new:
        try:
            cache[k] = M.convert(k)
        except Exception as e:
            print("FAILED", k, e)
    ok = list(cache)
    if not ok:
        return
    out = Image.new("RGBA", (8 * 98, len(ok) * 98), (60, 70, 100, 255))
    for r, k in enumerate(ok):
        for i, im in enumerate(cache[k]):
            out.alpha_composite(im, (i * 98, r * 98))
    out.resize((out.width * 3 // 2, out.height * 3 // 2), Image.NEAREST).save(M.SCR + f"review_{stage}.png")
    root = f"{ROOT}/build/{stage}"
    M.export(ok, root=root)
    md5 = {}
    for r_, _, fs in os.walk(root):
        for fn in fs:
            if fn == "md5.json":
                continue
            p = os.path.join(r_, fn)
            md5[os.path.relpath(p, root)] = hashlib.md5(open(p, "rb").read()).hexdigest()
    json.dump(md5, open(f"{root}/md5.json", "w"), indent=0)
    zp = f"/mnt/user-data/outputs/frost-thaw/0.2.1/{stage}.zip"
    with zipfile.ZipFile(zp, "w", zipfile.ZIP_DEFLATED) as z:
        for rel in list(md5) + ["md5.json"]:
            z.write(f"{root}/{rel}", rel)
    shutil.copytree(f"{root}/Graphics", "/home/claude/pifrun/Graphics", dirs_exist_ok=True)
    print("converted", ok, "files", len(md5), "zip", zp, "review", M.SCR + f"review_{stage}.png")


if __name__ == "__main__":
    main()
