#!/usr/bin/env python3
"""What a line points at should be there (owner, 11 Nov 2026; docs/craft/game_writing_guide.md G5).

Reads playthrough traces (tools/headless/script_trace.rb's SCRIPT_TRACE files) and lists every line that points at
something ("there it is", "look at that", "that one", "is that...") with the staging and lines just before it, so
each can be checked: is the thing on screen (an actor, an event, a panel) or named? Run after writing a scene.

    python3 tools/presence_audit.py TRACE.txt [TRACE.txt ...] > report.txt"""
import re, sys
PAT = re.compile(r"\b(there (it|she|he|they) (is|are|goes)|here (it|she|he|they) (is|are)|look at (that|this|it|him|her|them|those|these)|see (that|this|those|these)\b|that one\b|this one\b|over there|over here|this thing|that thing|what'?s that|watch this|look!|look\.|look,|there!|this is (it|the one)|right there|right here|that's (him|her|it)\b|is that\b|are those|is this\b|these (are|ones)|those (are|ones))", re.I)
seen = {}
for f in sys.argv[1:]:
    lines = open(f, errors="ignore").read().split("\n")
    mp = "?"
    for i, l in enumerate(lines):
        if l.startswith("[map]"):
            mp = l[6:60]
        if l.startswith("[msg]") and PAT.search(l) and l not in seen:
            ctx = [x[:150] for x in lines[max(0, i - 7):i] if x.startswith(("[msg]", "[stage]", "[scene]", "[map]", "[talk]"))]
            seen[l] = (mp, ctx)
for l, (mp, ctx) in seen.items():
    print("=== " + mp)
    for c in ctx[-6:]:
        print("    " + c)
    print(" >> " + l[:200])
print("%d lines point at something" % len(seen), file=sys.stderr)
