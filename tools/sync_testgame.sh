#!/bin/bash
# Like sync_pifrun.sh, for a worker's own test copy and worktree.
# Usage: tools/sync_testgame.sh /home/claude/pifrun_NAME   (run from the worktree root)
set -e
T=$1; R=$(cd "$(dirname "$0")/.." && pwd)
D=$T/Data/Scripts/998_FrostThaw
rm -f $D/*.rb; cp $R/game/Data/Scripts/998_FrostThaw/*.rb $D/
cp --remove-destination $R/build/maps/Map*.rxdata $T/Data/FrostThaw/
[ -d $R/build/Characters ] && cp --remove-destination $R/build/Characters/*.png $T/Graphics/Characters/ 2>/dev/null || true
# build/gfx mirrors the game's Graphics folder (Pictures, Animations, Trainers, Characters/Followers, Battlers...)
(cd $R/build/gfx && find . -type f -name '*.png' | while read f; do mkdir -p "$T/Graphics/$(dirname "$f")"; cp --remove-destination "$f" "$T/Graphics/$f"; done)
echo "synced $T: $(ls $D | wc -l) scripts, $(ls $T/Data/FrostThaw/*.rxdata | wc -l) maps"
