#!/usr/bin/env python3
"""Pack an Infinite Fusion + Frost & Thaw folder into packs for the browser player.

    python3 tools/web/pack_web.py GAME_DIR OUT_DIR [--mod-tree game/ | --mod-list FILE] [--version X]
                                  [--pack-mb N] [--state FILE --time-budget SECONDS]

--pack-mb caps each pack, zip overhead included (default 64; Cloudflare Pages needs 24 or
less, since it refuses files over 25 MiB). A game file bigger than that is split across
packs as pieces named "<path>#ftpart:<offset>:<total size>", which the player puts back together.

With --state and --time-budget it stops after about that many seconds and picks up
where it left off on the next run (for shells that can't run for long); the
manifest is written once every pack is done.

Writes OUT_DIR/manifest.json and OUT_DIR/p-<hash>.zip packs: uncompressed zips of
up to --pack-mb. Packs are named by their contents, so after an update only the
changed packs are new. Frost & Thaw's own files (everything under the repo's
game/ folder, plus Data/Scripts) go in their own packs, so a mod update doesn't
reshuffle the 3 GB of base-game packs.
"""
import hashlib, io, json, os, sys, time, unicodedata, zipfile

PACK_LIMIT = 64 * 1024 * 1024
GAME_DIRS = {"Audio", "Data", "Fonts", "Graphics"}
SKIP_EXT = {".exe", ".dll", ".bat", ".command", ".log", ".lnk", ".pdf", ".zip", ".md", ".txt"}
KEEP_TOP = {"Game.ini"}
FIXED_TIME = (2026, 1, 1, 0, 0, 0)   # same bytes for the same files, so pack names stay stable


# Browsers' private storage refuses some accented file names, so those files are stored
# under plain ASCII names; 056_WebShim.rb folds the names the game asks for the same way.
WEB_FOLD = dict(zip("áàâäãåéèêëíìîïóòôöõúùûüçñÁÀÂÄÃÅÉÈÊËÍÌÎÏÓÒÔÖÕÚÙÛÜÇÑ",
                    "aaaaaaeeeeiiiiooooouuuucnAAAAAAEEEEIIIIOOOOOUUUUCN"))


def web_fold(name):
    name = unicodedata.normalize("NFC", name)
    name = "".join(c for c in name if not 0x300 <= ord(c) <= 0x36f)
    return "".join(c if ord(c) < 128 else WEB_FOLD.get(c, "_") for c in name)


def walk(src):
    for root, dirs, files in os.walk(src):
        rel = os.path.relpath(root, src)
        # Only the folders the game reads: nothing else in the game folder (backups, reports,
        # reference material, tools) may end up on a web server
        dirs[:] = sorted(d for d in dirs if (rel != "." or d in GAME_DIRS) and not d.startswith("."))
        if rel != "." and not dirs and not [f for f in files if not f.startswith(".")]:
            # An empty folder the game expects to exist (it lists or writes into it)
            yield os.path.normpath(rel).replace(os.sep, "/") + "/", None
            continue
        for f in sorted(files):
            arc = os.path.normpath(os.path.join(rel, f)).replace(os.sep, "/")
            if f.startswith("."):
                continue
            if rel == "." and f not in KEEP_TOP and os.path.splitext(f)[1].lower() in SKIP_EXT | {".ini", ".rxproj"}:
                continue
            if os.path.splitext(f)[1].lower() in SKIP_EXT and rel != ".":
                if not arc.startswith(("Data/", "Graphics/", "Audio/", "Fonts/")):
                    continue
            yield arc, os.path.join(root, f)


def entry_cost(arc, length):
    # what an entry takes in a stored zip: local header + central directory record + data
    n = len(arc.encode("utf-8"))
    return 30 + n + 46 + n + length


def split_big(items, limit):
    """Whole files as (arc, path, None, None); a file over the limit as pieces (arc#ftpart:off:total, path, off, len)."""
    out = []
    for arc, path in items:
        size = os.path.getsize(path) if path else 0
        if path is None or entry_cost(arc, size) <= limit:
            out.append((arc, path, None, None))
            continue
        piece = limit - 2 * (len(arc.encode("utf-8")) + 40) - 200
        for off in range(0, size, piece):
            out.append((f"{arc}#ftpart:{off}:{size}", path, off, min(piece, size - off)))
    return out


def build_pack(items):
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_STORED, allowZip64=False) as z:
        for arc, path, off, length in items:
            if path is None:            # empty folder
                info = zipfile.ZipInfo(arc, FIXED_TIME)
                info.external_attr = (0o40755 << 16) | 0x10
                z.writestr(info, b"")
                continue
            info = zipfile.ZipInfo(arc, FIXED_TIME)
            info.compress_type = zipfile.ZIP_STORED
            info.external_attr = 0o644 << 16
            with open(path, "rb") as fh:
                if off is None:
                    z.writestr(info, fh.read())
                else:
                    fh.seek(off)
                    z.writestr(info, fh.read(length))
    data = buf.getvalue()
    return data, hashlib.sha256(data).hexdigest()


def main():
    args = sys.argv[1:]
    src, out = args[0], args[1]
    mod_tree = args[args.index("--mod-tree") + 1] if "--mod-tree" in args else None
    version = args[args.index("--version") + 1] if "--version" in args else "dev"
    limit = int(float(args[args.index("--pack-mb") + 1]) * 1024 * 1024) if "--pack-mb" in args else PACK_LIMIT
    limit -= 22                  # the zip's end record
    os.makedirs(out, exist_ok=True)
    mod_files = set()
    if "--mod-list" in args:     # one path per line, relative to the game folder (Frost & Thaw's own files)
        with open(args[args.index("--mod-list") + 1], encoding="utf-8") as fh:
            mod_files.update(web_fold(l.strip()) for l in fh if l.strip())
    if mod_tree:
        for root, _d, files in os.walk(mod_tree):
            for f in files:
                mod_files.add(web_fold(os.path.relpath(os.path.join(root, f), mod_tree).replace(os.sep, "/")))
    files, seen = [], set()
    for arc, path in walk(src):
        arc = web_fold(arc)
        if arc in seen:          # the same name stored twice (composed and decomposed accents)
            continue
        seen.add(arc)
        files.append((arc, path))
    # The browser engine's settings (modern Ruby, no syntax rewrite) ship with the web build only
    extra = os.path.join(os.path.dirname(os.path.abspath(__file__)), "mkxp.json")
    if os.path.exists(extra) and "mkxp.json" not in seen:
        files.append(("mkxp.json", extra))
        mod_files.add("mkxp.json")
    mod = [(a, p) for a, p in files if a in mod_files or a.startswith("Data/Scripts/") or a == "Game.ini"]
    base = [(a, p) for a, p in files if not (a in mod_files or a.startswith("Data/Scripts/") or a == "Game.ini")]
    state_path = args[args.index("--state") + 1] if "--state" in args else None
    budget = float(args[args.index("--time-budget") + 1]) if "--time-budget" in args else None
    state = {}
    if state_path and os.path.exists(state_path):
        with open(state_path, encoding="utf-8") as fh:
            state = json.load(fh)
    started = time.time()
    groups = []
    for group in (mod, base):
        cur, cur_size = [], 0
        for item in split_big(group, limit):
            arc, path, off, length = item
            sz = entry_cost(arc, length if off is not None else (os.path.getsize(path) if path else 0))
            if cur and cur_size + sz > limit:
                groups.append(cur)
                cur, cur_size = [], 0
            cur.append(item)
            cur_size += sz
        if cur:
            groups.append(cur)
    packs, total, pending = [], 0, 0
    for items in groups:
        # Same files, sizes and dates -> same pack, so a resumed run can reuse it
        key = hashlib.sha256("\n".join(
            f"{a}|{os.path.getsize(p) if p else -1}|{int(os.path.getmtime(p)) if p else 0}|{o}|{n}" for a, p, o, n in items
        ).encode("utf-8")).hexdigest()
        rec = state.get(key)
        if rec and os.path.exists(os.path.join(out, rec["name"])) and os.path.getsize(os.path.join(out, rec["name"])) == rec["size"]:
            packs.append(rec)
            total += rec["size"]
            continue
        if budget is not None and time.time() - started > budget:
            pending += 1
            continue
        data, h = build_pack(items)
        name = "p-" + h[:20] + ".zip"
        path = os.path.join(out, name)
        if not os.path.exists(path) or os.path.getsize(path) != len(data):
            with open(path + ".part", "wb") as fh:
                fh.write(data)
            os.replace(path + ".part", path)
        rec = {"name": name, "size": len(data), "sha256": h, "files": len(items)}
        packs.append(rec)
        total += len(data)
        state[key] = rec
        if state_path:
            with open(state_path, "w", encoding="utf-8") as fh:
                json.dump(state, fh)
    if pending:
        print(f"{len(packs)} of {len(groups)} packs done ({total / 1e9:.2f} GB); run again to continue")
        return
    manifest = {"version": version, "launch": "Game.ini", "packs": packs}
    with open(os.path.join(out, "manifest.json"), "w") as fh:
        json.dump(manifest, fh, indent=1)
    print(f"{len(files)} files ({len(mod)} Frost & Thaw) -> {len(packs)} packs, {total / 1e9:.2f} GB, manifest {version}")


if __name__ == "__main__":
    main()
