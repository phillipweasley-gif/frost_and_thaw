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

    python3 tools/web/pack_web.py <InfiniteFusion folder> <out folder> --mod-tree game/ --version 0.9.0

Upload everything in `<out folder>` to the site's `packs/` folder. Pack names are their
content hashes, so old packs can stay until every player has updated.

## What the host must do

- Serve the page with cross-origin isolation (the bundled `coi-serviceworker.min.js`
  does this on hosts that can't set headers), or set
  `Cross-Origin-Opener-Policy: same-origin` and `Cross-Origin-Embedder-Policy: require-corp`.
- Serve `.wasm` as `application/wasm`.
- Allow files of ~64 MB (packs) and ~42 MB (the engine).

## What players need to know

- First load downloads the whole game (about 3 GB). Use Wi-Fi and keep the page open.
- **iPhone/iPad:** use Safari and add the page to the Home Screen (Share → Add to Home
  Screen). Safari can clear a website's stored data after 7 days without a visit;
  a Home Screen app is kept.
- Private/incognito windows don't have room for the game.
