# Frost & Thaw in the browser (phones and computers)

The browser build runs the same game files as the PC install, inside a web page:

- **Engine.** mkxp-z compiled for the web (libretro core, Ruby 3.3 in a sandbox), in a
  small player page (Nostalgist) with touch buttons. The player is built from
  `phillipweasley-gif/mkxp-z-libretro-emscripten`, branch `ft-web`.
- **Game files.** `tools/web/pack_web.py` cuts an Infinite Fusion + Frost & Thaw folder
  into ~64 MB uncompressed zips ("packs") plus `manifest.json`. On first visit the page
  downloads every pack, checks its SHA-256, and unpacks it into the browser's private
  storage (OPFS). Later visits download only packs that changed, so a Frost & Thaw
  update is usually one or two packs (~10–60 MB), not the whole game.
- **Saves** live in the same private storage, under `/Save`.
- **Script changes for the web** are in `998_FrostThaw/056_WebShim.rb`. They put back
  what Ruby 3.2+ removed, fold accented file names to plain ASCII (private storage
  refuses some of them), and write a boot trace (`ft_web_trace.txt`) in the save
  folder. All of it is a no-op on a normal PC install.

## Making the packs

    python3 tools/web/pack_web.py <InfiniteFusion folder> <out folder> --mod-tree game/ --version 0.9.1

Upload everything in `<out folder>` to the site's `packs/` folder. Pack names are their
content hashes, so old packs can stay until every player has updated.

## The upload folder

Everything the site serves sits in one folder:

    index.html, assets/, coi-serviceworker.min.js      the player page (fork, branch ft-web, `vite build`)
    manifest.webmanifest, icon-*.png, apple-touch-icon.png   Home Screen app
    mkxp-z_libretro.js, mkxp-z_libretro.wasm           the engine (fork, branch ft-dist)
    packs/manifest.json, packs/p-*.zip                 the game (pack_web.py)
    .htaccess                                          from tools/web/htaccess.txt

## What the host must do

- Apache or LiteSpeed hosting (reads `.htaccess`): it sets cross-origin isolation
  (`Cross-Origin-Opener-Policy: same-origin`, `Cross-Origin-Embedder-Policy:
  require-corp`), serves `.wasm` as `application/wasm`, lets phones cache the packs
  for good and keeps the page and pack list fresh. If the host ignores the headers,
  `coi-serviceworker.min.js` supplies isolation instead (one extra reload on first visit).
- Allow files of ~64 MB (packs) and ~42 MB (the engine).
- Login: the host's "Directory Privacy" / "Password Protect Directories" tool on the
  folder (one shared username and password; the browser asks once and remembers).

## Known engine quirk

The threaded web engine sometimes stalls for good right after mounting the browser's
storage (about half of starts in testing, no user action involved). The page watches
for it and reloads itself after 10 seconds; a healthy start passes that point at once.

## What players need to know

- First load downloads the whole game (about 3 GB). Use Wi-Fi and keep the page open.
- **iPhone/iPad:** use Safari and add the page to the Home Screen (Share → Add to Home
  Screen). Safari can clear a website's stored data after 7 days without a visit;
  a Home Screen app is kept.
- Private/incognito windows don't have room for the game.
