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

    python3 tools/web/pack_web.py <InfiniteFusion folder> <site>/packs --mod-list <list> --version 0.9.1 --pack-mb 24

Only Game.ini and the Audio, Data, Fonts and Graphics folders go in, minus working files
(psd, docx, logs). `--pack-mb 24` keeps every file under Cloudflare Pages' 25 MiB cap; the
two ~29 MB message files are split into pieces that the player joins back together.
Pack names are content hashes, so an update re-uploads only the packs that changed.

## Where it's hosted: Cloudflare Pages (free)

weasleystudios.com is on Elementor's own hosting (nginx, no `.htaccess`, 10-275 GB of
downloads a month, and its terms bar file storage and large files), so the game lives on
a free Cloudflare Pages project, linked from a hidden page on the site.

The site folder (`_ft_web_upload/frost-thaw-cloudflare` on Phil's Mac, ~3.2 GB, 164 files):

    index.html, assets/, coi-serviceworker.min.js      the player page (fork, branch ft-web, `vite build`)
    _headers                                           cross-origin isolation and caching (Pages reads it)
    manifest.webmanifest, icon-*.png, apple-touch-icon.png   Home Screen app
    mkxp-z_libretro.js, mkxp-z_libretro.wasm.gz        the engine (fork, branch ft-dist); gzipped to fit
                                                       under 25 MiB, unpacked by the player as it downloads
    packs/manifest.json, packs/p-*.zip                 the game

Deploy: Workers & Pages > the project > Create deployment > drag the folder in.
Login: Cloudflare Access (Zero Trust, free up to 50 people) on `<project>.pages.dev`, one
emailed code per player; see "Enable Access on your *.pages.dev domain" in the Pages docs.

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
