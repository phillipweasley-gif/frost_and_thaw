#!/usr/bin/env python3
"""Pack an Infinite Fusion + Frost & Thaw folder into packs for the browser player.

    python3 tools/web/pack_web.py GAME_DIR OUT_DIR [--mod-tree game/ | --mod-list FILE] [--version X]

Writes OUT_DIR/manifest.json and OUT_DIR/p-<hash>.zip packs: uncompressed zips of
up to ~64 MB. Packs are named by their contents, so after an update only the
changed packs are new. Frost & Thaw's own files (everything under the repo's
game/ folder, plus Data/Scripts) go in their own packs, so a mod update doesn't
reshuffle the 3 GB of base-game packs.
"""
import hashlib, io, json, os, sys, unicodedata, zipfile

PACK_LIMIT = 64 * 1024 * 1024
SKIP_DIRS = {"_ft_backups", "_ft_source_backup", "_ft_staging", "_ft_tools", "_ft_web_upload", "_to_delete",
             "Rootspire_Campaign_Export", "REQUIRED_BY_INSTALLER_UPDATER"}
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
        dirs[:] = sorted(d for d in dirs if not (rel == "." and d in SKIP_DIRS) and not d.startswith("."))
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


def build_pack(items):
    buf = io.BytesIO()
    with zipfile.ZipFile(buf, "w", zipfile.ZIP_STORED, allowZip64=False) as z:
        for arc, path in items:
            if path is None:            # empty folder
                info = zipfile.ZipInfo(arc, FIXED_TIME)
                info.external_attr = (0o40755 << 16) | 0x10
                z.writestr(info, b"")
                continue
            info = zipfile.ZipInfo(arc, FIXED_TIME)
            info.compress_type = zipfile.ZIP_STORED
            info.external_attr = 0o644 << 16
            with open(path, "rb") as fh:
                z.writestr(info, fh.read())
    data = buf.getvalue()
    return data, hashlib.sha256(data).hexdigest()


def main():
    args = sys.argv[1:]
    src, out = args[0], args[1]
    mod_tree = args[args.index("--mod-tree") + 1] if "--mod-tree" in args else None
    version = args[args.index("--version") + 1] if "--version" in args else "dev"
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
    packs, total = [], 0
    for group in (mod, base):
        cur, cur_size = [], 0
        def flush():
            nonlocal cur, cur_size, total
            if not cur:
                return
            data, h = build_pack(cur)
            name = "p-" + h[:20] + ".zip"
            path = os.path.join(out, name)
            if not os.path.exists(path):
                with open(path, "wb") as fh:
                    fh.write(data)
            packs.append({"name": name, "size": len(data), "sha256": h, "files": len(cur)})
            total += len(data)
            cur, cur_size = [], 0
        for arc, path in group:
            sz = os.path.getsize(path) if path else 0
            if cur and cur_size + sz > PACK_LIMIT:
                flush()
            cur.append((arc, path))
            cur_size += sz
        flush()
    manifest = {"version": version, "launch": "Game.ini", "packs": packs}
    with open(os.path.join(out, "manifest.json"), "w") as fh:
        json.dump(manifest, fh, indent=1)
    print(f"{len(files)} files ({len(mod)} Frost & Thaw) -> {len(packs)} packs, {total / 1e9:.2f} GB, manifest {version}")


if __name__ == "__main__":
    main()
