#!/bin/bash
# Makes a private headless test copy of the game for one worker: hard-links the
# big read-only parts of /home/claude/pifrun, real-copies the parts we write to.
# Usage: tools/make_testgame.sh /home/claude/pifrun_NAME
set -e
DST=$1; [ -z "$DST" ] && { echo "usage: $0 DEST"; exit 1; }
[ -e "$DST" ] && { echo "$DST exists"; exit 0; }
SRC=/home/claude/pifrun
mkdir -p "$DST"
for e in "$SRC"/* "$SRC"/.[!.]*; do
  n=$(basename "$e"); [ "$n" = ".git" ] && continue
  cp -al "$e" "$DST/$n"
done
# break the hard links where the game or our tools write
for d in Data/Scripts/998_FrostThaw Data/FrostThaw Graphics/Characters Graphics/Pictures Graphics/Battlers/FrostThaw Graphics/Pokemon/Icons Graphics/Items Graphics/Trainers; do
  [ -d "$DST/$d" ] && { rm -rf "$DST/$d"; cp -r "$SRC/$d" "$DST/$d"; }
done
for f in FrostThaw.log CocoonFusion.log; do rm -f "$DST/$f"; : > "$DST/$f"; done
echo "test game at $DST"
