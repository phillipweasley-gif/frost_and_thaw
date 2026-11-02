#!/bin/bash
# Rebuilds every Frost & Thaw map from scratch, in dependency order, into
# build/maps, then runs the whole-game map checks.
set -e
cd "$(dirname "$0")"
ACT3=build_act3; [ -n "$SKIP_ACT3" ] && ACT3=""
for b in build_act1 build_ch2 build_ch3 build_ch4 build_ch5 build_ch6 build_ch6b build_ch7 build_ch7b build_ch7_deep build_ch7a build_ch8 build_ch8_deep build_ch9 build_ch10 $ACT3 build_w4 build_prologue; do
  echo "== $b"
  ruby $b.rb | tail -2
done
ruby check_all.rb
