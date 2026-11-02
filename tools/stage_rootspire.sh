#!/bin/bash
# Stages the Rootspire expansion for install: every file must match the tested copy in pifrun.
set -e
ST=/home/claude/frost-thaw/build/$1
mkdir -p $ST/Data/Scripts/998_FrostThaw $ST/Data/FrostThaw $ST/Graphics/Items
cd /home/claude/frost-thaw
for f in 007_Story 023_Chapter5 024_Chapter6 025_Chapter7 026_Rootspire 027_Relics 028_Heartroot 029_Glimmer; do cp game/Data/Scripts/998_FrostThaw/$f.rb $ST/Data/Scripts/998_FrostThaw/; done
for i in $(seq 2050 2068); do [ -f build/maps/Map$i.rxdata ] && cp build/maps/Map$i.rxdata $ST/Data/FrostThaw/; done
cp build/items/FT_*.png $ST/Graphics/Items/
cd $ST
python3 - <<'PY'
import hashlib, json, os
out = {}
for root, _, files in os.walk('.'):
    for f in files:
        if f == 'md5.json': continue
        p = os.path.join(root, f)[2:]
        out[p] = hashlib.md5(open(p, 'rb').read()).hexdigest()
bad = [p for p in out if hashlib.md5(open('/home/claude/pifrun/' + p, 'rb').read()).hexdigest() != out[p]] if True else []
json.dump(out, open('md5.json', 'w'), indent=0)
print(len(out), "files; differ from tested pifrun copy:", bad)
PY
