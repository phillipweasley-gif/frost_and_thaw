#!/bin/bash
# Copies the working scripts and built maps into the headless test copy of the game.
set -e
D=/home/claude/pifrun/Data/Scripts/998_FrostThaw
rm -f $D/*.rb
cp /home/claude/frost-thaw/game/Data/Scripts/998_FrostThaw/*.rb $D/
cp /home/claude/frost-thaw/build/maps/Map*.rxdata /home/claude/pifrun/Data/FrostThaw/
echo "pifrun synced: $(ls $D | wc -l) scripts, $(ls /home/claude/pifrun/Data/FrostThaw/*.rxdata | wc -l) maps"
