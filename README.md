# Pokémon Frost & Thaw

An Infinite Fusion (Essentials v19) mod built from the Rootspire campaign.

## Layout
- `game/Data/Scripts/998_FrostThaw/` – the mod's Ruby scripts (module `FrostThaw`).
- `tools/build_*.rb` – map builders; `tools/build_all.sh` builds every map into `build/maps/`.
- `tools/headless/` – headless playthroughs (`story_run.rb`) and focused checks (`try_*.rb`).
- `tests/smoke_test.rb` – the quick checks.
- `art/` – scripts that generate or convert sprites.
- `build/Characters`, `build/gfx`, `build/items`, `build/maps`, `build/music` – everything that ships.

## Install
A release zip copies `Data/` and `Graphics/` into the InfiniteFusion game folder
(`_ft_tools/install_zip.py` backs up anything it replaces and checks md5s).
