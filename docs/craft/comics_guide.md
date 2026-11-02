# Comics craft for Frost & Thaw
### Distilled from Lee Nordling, *Comics Creator Prep* (About Comics, 2016)

Page numbers are the book's printed page numbers. Quotes are a sentence or less; everything else is
paraphrase.

---

## 1. Overview

*Comics Creator Prep* is a course for comics writers and artists, set out as classroom lectures with
homework. The first half (Part One, "Working With Intention") covers the craft. The second half
(Part Two, "Working With Others") covers script formats, collaboration, ownership, pitching, editors
and adapting comics to film. One idea runs through all of it, the "Comics Creator's Creed" (p. 18):
use every tool the medium has so that the finished work is *perceived the way you intended*. You
judge the work by what the reader actually takes from it, not by what the writer meant.

Nordling keeps coming back to four points:

- **Comics are not film** (ch. 3–5). A panel holds one or more frozen moments, and the reader sets
  the pace. A writer who chops film action into smaller bits gets panels that can't be drawn, or
  that can be drawn several ways.
- **What happens between panels** (ch. 6–7). The gap can jump any distance in time or space. The
  reader has to know how far it jumped, unless you are confusing them on purpose.
- **Pictures first, words second** (ch. 8, 11). This is Mamet's "silent movie" discipline. Dialogue
  written first, with pictures attached afterwards, is a crutch that gives you a "talky" comic.
- **The script is a message to a collaborator** (ch. 1, 8, 11, 17). If something matters, write it
  so the artist can draw it and the reader can see it, in the order you want it seen. A note that
  only the script's reader can see is not in the comic.

**Why this matters for Frost & Thaw.** The game *is* a comic as far as reading goes. Cutscenes are a
reader-paced run of message boxes, played over full-screen story panels (S-, 512x384), map staging
with action sheets (P-, K-), effects (E-), emote balloons (B-) and screen overlays (O-). The player
presses a button to go on, so the player sets the pace the way a comics reader does. The art list
(the Cutscene Art & Effects List, plus the `docs/art_requests_W*.md` files) is a comics script: a
writer describes frozen images for an artist who isn't in the room. Every failure Nordling lists
turns up here:

- words that describe something the picture contradicts
- a panel that gives away its own reveal
- a cut that leaves the player unsure where they landed
- art notes the player can never see
- lines too long for the box

Part Two's business chapters (13, 16, 18) don't apply. Three pieces of Part Two do: the
format/"dialect" thinking in ch. 11, the agreed-vision yardstick in ch. 17, and "find the heart of
the story" from the adaptation chapter (ch. 19). The last one matters because the game is itself an
adaptation of a D&D campaign.

---

## 2. Principles

Each entry has four parts: the principle, why it matters here, a rule a writer on this game can
follow, and the page reference.

### A. Writing with intention (the yardstick)

**A1. Judge the scene by what the player perceives.**
*Principle:* the Creed. A writer has to step away from the work and read it as a stranger. The
standard case is an artist who draws exactly what the script says, which isn't what the writer
thought it said.
*Here:* scenes are written in Ruby arrays and played through Stage calls that fail quietly. The
writer sees `Stage.panel("S-08b")` and a line of text. The player sees a picture and a box, and
nobody checks that the two agree.
*Rule:* review every cutscene with the panel images open beside the script, or in a headless run.
Read each box against the picture under it. "What I meant" never settles an argument; "what's on
screen" does.
*Ref:* p. 18, 22–24, 47.

**A2. Make every visual choice on purpose.**
*Principle:* a writer who gets a good result by accident can't repeat it. Pacing, reading order,
location and time jumps are always being decided. The only question is whether you decided them.
*Here:* each `say([...])` array is a pacing decision (how many beats). Each Stage call adds or
removes a beat of attention.
*Rule:* for each scene, write a one-line note at the top: what the player should feel, and roughly
how many boxes it should take. Then check the scene against it.
*Ref:* p. 48, 70, 273.

**A3. Settle "good enough".**
*Principle:* "the perfect is the enemy of the good" (p. 47). Recognising that something works is a
skill as much as spotting faults.
*Rule:* a reviewer marks a beat PASS or FAIL with a reason, and doesn't rewrite a beat that passes
just to make it different.
*Ref:* p. 47–48, 62.

### B. Time: frozen moments, beats and the reader's control

**B1. A panel is a frozen moment, not a shot.**
*Principle:* a picture holds one instant, or a few instants read left to right. Words take time to
read, so a panel with several lines of dialogue covers several spans of time laid over one image.
*Here:* `Stage.panel(id)` holds one image while any number of message boxes go past under it. Each
box is a span of time and the picture stays fixed. Everything said under the panel has to be true of
that one frozen instant. The exceptions are lines that add what a picture can't show: sound, smell,
thought, a name, a duration.
*Rule:* while a panel is up, a line must not describe an action that happens *after* the instant
drawn (people kneeling, settlers arriving, years passing). For that, take the panel down or show the
next one.
*Ref:* p. 40, 55–56.

**B2. Turn action into frozen moments. Don't chop it into smaller actions.**
*Principle:* "leaps a fence" could be drawn at take-off, in mid-air or on landing. Action verbs leave
it open. Wording such as "has just broken off" or "is in mid-leap" pins the instant down. One frame
also can't show a figure busy with two physical things (Nordling's "third hand" example).
*Here:* this applies to the art list (panels and action-sheet frames) and to narration over a
panel.
*Rule:* in art requests, write the moment in state verbs ("has just stepped out", "is half through
the glass"). Give each figure one thing it is concentrating on per frame.
*Ref:* p. 42–45, 60, 123–124.

**B3. Each element the player has to take in adds a beat. More things means a slower read.**
*Principle:* characters, objects, compositions that lead the eye, balloons, captions and signs each
cost a moment of attention. Lots of implied action does *not* make a panel quick: "added complication
compounds consideration" (p. 70). Splitting one balloon into two adds a beat. Separate balloons read
slower than balloons joined by a stem.
*Here:* each message box is a beat, and a panel or effect adds one. The player decides how long each
beat lasts. A line too long for two lines of ~45 characters spills into an extra page of the box, so
you get a beat you didn't plan.
*Rule:* count boxes. A sequence meant to feel fast has fewer, shorter boxes. Split a line into two
boxes only when you want the pause (`"...Don't tell anyone I said that."` gets a box of its own).
Keep lines to about 90 characters.
*Ref:* p. 64–66, 70, 72.

**B4. Decide how much time passes between beats, and show it when it matters.**
*Principle:* between panels you can move a second or a million years. Usually the size of the gap
doesn't matter, but when it does, the reader has to be able to read it. Nordling's sixteen-seconds
exercise shows four ways to stretch the same gap, each suited to a different editorial goal.
*Here:* the "..." box in Ch3 (night to morning), the lantern burst (four hundred years), "Seven years
on her side of the glass. About a minute on yours."
*Rule:* when the size of a jump matters, carry it in something the player perceives: a line, a
changed picture, the same subject grown older. A date in a comment or a map name doesn't count.
*Ref:* p. 74–80.

**B5. The most common mistake is telling the script's reader instead of the game's reader.**
*Principle:* "1920" in a panel description tells the artist the period. No reader looking at the
drawing will know it's 1920. The same goes for a finger covering a button labelled ON.
*Here:* this happens in art requests (an NPC who "smells of pumpkin spice", a song's title, a
character's name), in code comments, and in flags.
*Rule:* for every art note, ask whether the player can see it. If not, and it matters, the words in
the game have to carry it.
*Ref:* p. 82–83, 120–121, 128–129.

### C. Reading order and staging

**C1. The eye reads left to right. Put the payoff on the right.**
*Principle:* books, spreads, pages, panels and balloons all read left to right. The earliest span of
time goes on the left and the latest on the right, and the last thing seen is the punch line.
*Here:* panels follow this (S-07 has the green wyrmling left and the white right, in the order the
text names them). Map staging matters too: when two actors face each other, the one on the left is
read first.
*Rule:* in a panel request, describe the elements left to right in the order you want them seen,
and put the reveal or reaction you want remembered on the right. In narration over a panel, name
things in the same order the eye meets them.
*Ref:* p. 49–53, 56–58, 114.

**C2. Action then reaction, or reaction then action: choose.**
*Principle:* showing the reaction first (a face, then its cause) makes the reader ask "why?". That
adds a beat. Either order works, but the words have to follow whichever order the picture uses.
*Rule:* if the panel shows the reaction on the left, the line either answers it or names it first.
Don't make the line describe the right-hand cause first and then send the eye back.
*Ref:* p. 57–58, 116–117, 125.

**C3. A flip moves everyone. Watch reverse angles.**
*Principle:* a reverse angle puts the speakers on the opposite sides, and the reading order breaks.
*Here:* when a panel lifts to show the map staging (or the other way round), the player's mental
layout carries over. If the panel has Sephek on the left and the map puts him on the right, the
scene silently flips.
*Rule:* match screen sides between a panel and the map staging that comes before or after it. If a
flip is unavoidable, cover it with a full cut (fade or flash).
*Ref:* p. 53, 59.

**C4. Just because it can be written doesn't mean it can be drawn.**
*Principle:* staging in a real room is limited (a bed against a wall, a TV that can't move).
Lighting choices commit the rest of the story (dark under a bed means you can't show a missing
battery). If you can't draw, diagram.
*Here:* the game shows a fixed overhead camera on a map built of tiles, and panels are one picture
at a fixed size.
*Rule:* before asking for staging, sketch the tiles (who stands where, which way they face) and
check the order of speakers against it. For panels, state the lighting where it matters ("lit by
the Heart's glow only", "night, the face must be readable").
*Ref:* p. 115–118, 126–128.

**C5. Avoid crosstalk.**
*Principle:* when A speaks, then B, then A again inside one panel, it can't be ballooned cleanly,
and it slows the read. Split it into panels.
*Here:* our boxes are sequential, so crosstalk can't tangle balloons. It can still tangle *staging*:
a pose or emote balloon meant for A appears while B's line is up.
*Rule:* an emote balloon (B-) or pose belongs to the character whose line or reaction is on screen.
Fire it just before that character's box, never during someone else's.
*Ref:* p. 250–252.

### D. Words and pictures: dividing the work

**D1. Write the silent version first.**
*Principle:* Mamet tells TV writers to pretend the characters can't speak and write a silent movie.
Starting from dialogue is the crutch that gives you a talky comic. Comics can use words better than
film, but the pictures should be planned first.
*Here:* the biggest visual moments in the script are often told in a stack of narration boxes over
the plain map (see the Glimmer critique below).
*Rule:* for each showpiece beat, first list the images it needs, one line each. Decide which of them
get a panel, a pose, an effect or nothing. Only then write the boxes, and give the words what the
images can't do.
*Ref:* p. 97–100, 160–162.

**D2. Juxtaposition: show A, J, R, Z and let the player connect them.**
*Principle:* a run of plain images in a deliberate order makes the reader do the connecting, and
that involves them. A constant subject across changing backgrounds (Nordling's rock across
geological ages) makes time legible without a word. Holding the same framing while one thing
changes makes that change the point.
*Here:* this is exactly what a panel montage like 5.10 can do, and what the S-01/S-08e lantern pair
already does.
*Rule:* in a panel sequence, keep one anchor across the panels (the tree, the lantern, the
wyrmlings) so the player reads time passing from its change. When a later panel calls back to an
earlier one, keep the frame and change one thing.
*Ref:* p. 99, 101–103, 106–109, 130.

**D3. Words do what pictures can't, and shouldn't repeat what they show.**
*Principle:* the line and the picture each carry part of the meaning. Nordling's Hansel line ("that
was a snap") only works if the art shows the siding *already* broken. Word and picture have to agree
on the moment.
*Here:* panel narration tends to describe what's in the panel ("Gold light. A tree so tall..."). Under
a panel, words earn their place with sound, smell, temperature, a name, a duration, a meaning, or a
voice.
*Rule:* under a panel, cut any clause that only describes what's visible. Keep one establishing
line, because the panel may be missing (Stage is best-effort), and give the rest to the other
senses and to meaning.
*Ref:* p. 60, 97–99.

**D4. Punctuation is visual. Pick conventions and keep them.**
*Principle:* comics punctuation grew up to fit the pictures. `?!` is a shouted question. A dash is
an interruption and an ellipsis is a pause. The number of periods can stand for the length of a
pause, and a balloon holding only dots is a character lost for words. Colour-coding captions tells
the reader who is speaking. "Clarity is king" (p. 144).
*Here:* lines use "NAME:" as the speaker pointer, "(...)" for stage directions and Herald thoughts,
`...` alone as a silence, and capitals for shouting.
*Rule:* `--`/em-dash means cut off and `...` means trailing off or a pause. A box that is only "..."
is a deliberate beat of silence. Use it, but rarely. Don't stack `!!!`. Write the house rules down
once (the Voices doc is the natural home) and hold to them.
*Ref:* p. 135–148.

### E. Sequences, cuts and reveals

**E1. The page turn: set up on one beat, reveal on the next.**
*Principle:* the first panel after a page turn is the only one the reader can't glimpse early. Put
the setup on the last panel before the turn and the reveal after it. A reveal can be verbal ("Will
you marry me?" / "Not a chance."). A stray ad page can wreck a planned reveal, so watch the details.
Nordling gives three patterns: the same setting changed dramatically; a new place tied to the old by
an idea; and an expectation left hanging while the scene cuts away.
*Here:* our "page turn" happens when a panel fades in, when a flash or fade ends, when a new box
opens, or when a `???:` speaker is named. A panel that already shows the outcome spoils the reveal
the words are building toward.
*Rule:* a panel shows the setup or the reveal, never both. If it is the reveal, the box before it
does the setup. Close scenes on a one-line hook ("Outside, under the window, a tall figure with long
ears...").
*Ref:* p. 149–156.

**E2. Don't leave the player lost. Only confuse on purpose.**
*Principle:* when you cut to a new place, the reader has to know where they landed, unless the
mystery is deliberate. Without famous landmarks, label the place. A sign drawn small or far off
labels nothing. Captions can build an idea that bridges two places.
*Here:* `Stage.visit` cuts to vision maps and panels cover the cuts, so nothing on screen names the
destination unless the words or the art do. Three depictions of one place (panel, panel, map) that
don't match will read as three places.
*Rule:* after every cut, the first box or the panel must establish where we are (and when, if that
changed). Every picture of one location has to agree with the others: same slab, same trees, same
sky.
*Ref:* p. 86–95.

**E3. Plan the images before the breaks. Break at the reveals.**
*Principle:* when Nordling had too much story for 24 pages, he listed only the images he absolutely
needed, then put page breaks where scenes ended and where reveals could follow a page turn. The
climax read "like a speeding bullet".
*Rule:* for a montage or climax, write the image list first, cut it to the minimum, then decide
where the panels go. Speed comes from fewer, stronger images, not from adding more of them.
*Ref:* p. 161–162.

### F. The art list is a script

**F1. Write for the designer's "dialect".**
*Principle:* there's no single right script format. Full script, plot method, thumbnails and the
hybrids are dialects you choose for your collaborator. Nordling's *Bramble* format reads like prose,
one paragraph per panel, with no camera directions, so the artist interprets but the pacing is kept.
It also has a mood line ("Not even Charlie Brown had it so bad") that sets the goal without
dictating the image, so the art can be checked against the goal later. A "storytelling note" at the
top of a page tells the artist what the page is *for*.
*Here:* our designer gets table rows (W1–W5) and the Cutscene Art & Effects List with its Style guide
tab. Rows tend to list contents; they rarely say what the player must take away.
*Rule:* every panel request has five parts:
1. The frozen moment, in state verbs.
2. The elements, left to right.
3. One "the player should conclude..." line.
4. What has to stay legible above the message box.
5. The lines it plays under, with their IDs, plus the canon text it must agree with.

*Ref:* p. 159–172, 173, 185–186.

**F2. Say how much freedom the designer has.**
*Principle:* describing a pose exactly ("legs crossed") ties the artist down and gives no grounds for
review when the mood is wrong. "The husband lies comfortably in bed" gives the goal and leaves room.
Notes on intention ("one of the batteries is missing!") are good: they tell the artist what the
reader should conclude.
*Rule:* give the demeanour and the dramatic point ("Sephek has just broken: on his knees, empty"),
and specify detail only where the story needs it.
*Ref:* p. 118–122, 124.

**F3. The art has to match the words already shipped.**
*Principle:* if the story already says it, the art can't contradict it. Several versions of the same
page (plot, full script, thumbnails) are only correct if no one of them contradicts another.
*Here:* the prologue text describes the tavern carving in detail, and the 5.10 line names a "small"
sixth figure. The Story Bible says the Wennen are lunar rabbitfolk.
*Rule:* each request quotes the established text it has to honour, and the reviewer checks the
delivered art against that text before it is wired in.
*Ref:* p. 178–179.

**F4. Use the agreed vision as the yardstick in review.**
*Principle:* a good editor defines the vision with the creator first. Review then becomes "that's not
what we agreed to", not "I don't like it".
*Rule:* review incoming art against the request's "player should conclude" line and the canon quote,
not against taste.
*Ref:* p. 191, 247–248.

### G. Theme, endings and the heart of the story

**G1. The ending proves the theme.**
*Principle:* a theme takes a position ("love conquers all", not "love"). The ending shows what the
story believes. Anything that cuts against the theme gets cut, changed, or kept knowingly, or else
the theme has to change.
*Here:* Act I ends with the acorn planted: "There's always a third way", against Thredra's trade of
one life for another. The Crone's Bargain ending argues the opposite and has to *look* like the
opposite (S-16, S-17).
*Rule:* write each act's theme as a full sentence that takes a position. Check that its last panel
or box shows it, and that no glimpse after the ending dilutes it.
*Ref:* p. 25–29, 35–37.

**G2. The hook sentence keeps scenes and quests on their spine.**
*Principle:* the form is "This is the story about a ___ who ___, only for ___ to discover ___." Give
away the good part. Write in arcs, not events. For a team, treat the team as the protagonist.
*Here:* for example, "This is the story about a cursed elf who's offered his cure at the price of an
innocent life, only for him to discover there's always a third way."
*Rule:* every chapter and major quest gets one of these at the top of its file, and the art list's
panels for that chapter should illustrate its two halves.
*Ref:* p. 227–231, 234, 238.

**G3. In an adaptation, find the heart and cut what doesn't serve it.**
*Principle:* look at where the story begins and where it ends, and name the moral. Use that to decide
what to keep. Too much story in too little space is cured by cutting to the theme.
*Here:* the campaign has far more events than a cutscene can hold, and the 5.10 epilogue is a good
example of campaign closing notes carried over line for line.
*Rule:* when a cutscene runs long, rank the source beats by how much they serve the act's theme, and
make the low-ranked ones optional (an NPC line, a book, a sign) rather than montage boxes.
*Ref:* p. 266–270.

### H. Consistency and conventions

**H1. Set your ground rules early and stick to them.**
*Principle:* readers learn a creator's conventions. Change them without notice and they trip.
"Consistency is your pal" (p. 148).
*Here:* the game already has a visual vocabulary:

| Signifier | Meaning |
|---|---|
| O-03 frost frame | a vision or memory |
| E-06 | a mirror cracks |
| O-07 | falling through time |
| O-01 | the aurora |
| B-01 | silence |
| B-07 | a tear |

*Rule:* keep a register with one meaning per signifier. A new use either matches the meaning or gets
its own asset.
*Ref:* p. 143–144, 148.

### I. Working method

**I1. Put distance between you and your draft. Write the verdict down.**
*Principle:* wait a day before reviewing. Write down your verdict so you can't wriggle out of it.
Critique other people's work before your own. Be as hard on your own work as on work you dislike.
*Rule:* reviewers run the checklist below in writing, beat by beat, with PASS or FAIL and a reason.
*Ref:* p. 22–23, 30, 39, 47.

**I2. Collaboration is a show-and-tell cycle with a stated end.**
*Principle:* writer shows, artist shows back, notes, revision, repeat. Each side needs to understand
what the other needs. Goals decide what you need.
*Rule:* send the designer rough layouts or stand-in screenshots of a panel in context (with the
message box on screen) before final art.
*Ref:* p. 191–192, 214.

---

## 3. Checklist (run over any cutscene)

**Time and pacing**
1. Count the boxes. Does the count match the feeling the scene is after (fast or lingering)?
2. Is any line over ~90 characters (it will spill into another page of the box)?
3. Is every split of a line into two boxes a pause you wanted?
4. Where time jumps, can the player perceive how far, through a line, a changed picture or a grown
   subject?
5. Does any run of boxes claim speed ("too fast to hold") while being long?

**Panels**
6. Is everything said under each panel true of the single frozen instant drawn?
7. Does any line under a panel describe what happens *after* that instant?
8. Does any line just repeat what the panel shows? Cut it, unless it's the one establishing line.
9. Is the focal content in the upper three-quarters, clear of the message box?
10. Is the payoff on the right, and does the narration name things in the order the eye meets them?
11. Does the panel show the setup *or* the reveal, not both? Is it placed after the box that sets it
    up?
12. Does the panel match the established text and bible (colours, counts, sizes, places, who is
    there)?
13. If the panel fails to load, do the words alone still carry the essential beat?
14. In a montage, is there one anchor carried across panels, and is the chronology clear and
    deliberate?
15. Does an overlay above the panel (O-07, O-03 with `above_panels`) cross a face or the focal point?

**Staging on the map**
16. Do the screen sides of actors match the panel before or after (no silent flip)?
17. Is each emote balloon or pose on the character whose line or reaction is current, and fired
    before that box?
18. Does the picture do what the words say *while* they say it (a fade that is a fade, not a pop
    after the line)?
19. Is each actor doing one thing per pose?
20. If you sketch the tiles (who stands where, facing which way), can it actually be staged?

**Place and continuity**
21. After every cut or `Stage.visit`, does the first box or panel say where (and when) we are?
22. Do all depictions of one location (panels, map, text) agree?
23. Is each signifier (O-03, E-06, O-01, B-01...) used with its registered meaning?
24. Is any information that matters only in a comment, flag, map name or art note?

**Modes**
25. In each Herald mode, does every panel still make sense when "you" are one of the figures in it?
26. Are mode-specific panels gated (`journey?`, `herald?(:x)`), and does each mode that needs a
    bookend get one (Wyn)?
27. Do `cl()` lines that vanish leave the remaining boxes coherent?

**Words and pictures**
28. Have you read the scene with all words removed? Do the images alone tell the shape of it?
29. Is each showpiece visual moment given a panel, pose or effect rather than three or more
    narration boxes?
30. Is punctuation consistent with the house rules (dash = cut, ellipsis = pause, "..." box =
    silence)?

**Theme and ending**
31. Does the scene's last image or box prove the act's theme, and does nothing after it undercut
    that?
32. Does the scene end on a hook for the next beat?

**Art requests**
33. Is each request a frozen moment in state verbs, left to right, with a "player should conclude"
    line?
34. Does it quote the canon text it must match and name the lines it plays under?
35. Does it say what must stay legible, and give the lighting where the story depends on it?

---

## 4. What this means for Frost & Thaw

1. **The message box is the balloon, and the player turns the page.** Pacing is set by the number
   and length of boxes, not by how much happens. A montage of fifteen short events is slow. Two
   strong boxes over one panel are fast. Count beats when you plan, not just events.

2. **A panel is a held frame under a moving caption.** `Stage.panel` stays up while lines go past.
   The most common failure in the current script is a second or third line that moves on in time
   (people kneel, settlers arrive, a hand grabs hair) while the picture stays where it was. Either
   change the panel or let the narration step out of it ("Later...", panel off).

3. **The message box hides roughly the bottom quarter of every panel.** Faces, the reveal and any
   readable detail belong in the upper three-quarters. Say so in every panel request. The current
   S- panels mostly respect this, with dark foregrounds at the bottom. Keep it a stated rule rather
   than luck.

4. **Speakers have no pointers.** "NAME:" is the only attribution in the box. Emote balloons and
   poses are the only *spatial* pointers, so they have to land on the right character at the right
   moment. A balloon on one wyrmling while the other one's line is up says the wrong one spoke.

5. **Map staging is film inside a comic.** `Stage.walk`, `pose` and `fx` run in real time, but the
   player reads at their own speed. Put movement *between* boxes, and make the picture do what the
   line says while it is on screen. A sprite that pops out after "he fades like breath on glass"
   contradicts the line (Talion, Ch10).

6. **Herald mode changes the words, not the pictures.** Panels are drawn from outside. In Herald
   mode the text turns into "you" and "(thoughts)", but the same panel shows that Herald in the third
   person. That's fine as long as nothing in the panel contradicts the interior framing. Bookends
   for the newcomer (S-01 and S-08e, "your own face") are rightly Journey-only. Wyn, who also fell
   through a mirror from four hundred years on and saw "a dock in a blizzard" in it, has no
   equivalent in either place.

7. **Stage is best-effort, so the words must stand alone.** A missing panel logs and the scene plays
   on. Keep one establishing line per panel so the beat survives without art. Mark the description
   lines that the art makes redundant, and trim them when the art lands. Otherwise word and picture
   end up saying the same thing twice.

8. **Long lines add beats nobody planned.** Several lines in 5.10 and 6.08 run to 100–160
   characters (the Rift inscription, the Reghed-tents glimpse, Glimmer reading his own handwriting),
   so the box turns a page partway through a sentence. Nordling's "million word balloons in a
   teeny-weenie panel" (p. 160–161) is the same problem.

9. **The signifier vocabulary is the game's best visual asset. Guard it.** O-03 (frosted frame)
   means "vision or memory" in Ch3, Ch7B's well, Ch10's attunement and Luminara's bubble, Ch13's
   tests, the Deep Labyrinth's liquid mirror and Eirwen's ritual. That's a strong convention. There
   are two drifts:
   - O-03 frames Talion's release (a real event, not a vision).
   - Brightmane's answer in Downtime ("There's no answer in words. There's a vision.") uses O-01
     with the hard pulse, the signifier Ch6 set up for "something built" hammering under the roots,
     instead of O-03.

   Register each signifier's meaning, and give a new meaning a new asset.

10. **Reuse panels as callbacks.** S-01 and S-08e are the best piece of visual storytelling in the
    game: the same lantern-globe frame, first showing the party on the dock, then your own face
    looking in. Holding the frame and changing one thing is exactly the tool on p. 130. More
    callbacks cost nothing:
    - S-01 in Wyn's prologue, where the text already describes that dock in the shard.
    - S-08a under Alberica's Memory Codex fragment ("A sapling splitting frost").
    - S-07 when the wyrmlings are remembered.

11. **Optional content is told in words, and that's correct. Watch for main-path showpieces left as
    narration.** Side quests (signs, NPCs, books) rightly carry their lore in text. But the Act II
    transformation (Glimmer), Ch10's attunement vision (Reptin between a burning machine and a
    sapling) and Luminara's memory (a man's face peeling back to show a woman) are among the
    strongest images in the story. They play as three to twenty-five narration boxes over the
    ordinary map. A pose, effect or panel would carry them in one beat.

12. **Time travel is the story's engine, so legible time jumps are a core skill.** The game jumps
    four hundred years by lantern, seven years in a minute through Brightmane's glass, thirty years
    through the liquid mirror. Each jump needs something the player perceives: a line naming the
    span, or a constant subject that visibly aged (the sapling becomes the tree, the wyrmlings become
    dragons). A montage that runs forward to the far future and then drops back to "the next dawn"
    with no signpost leaves the player lost in time.

13. **One place, one look.** `Stage.visit` vision maps, the panels that cover their cuts and the
    narration all depict the same place. If the panel shows a cathedral and the text says "a stone
    circle in the birches", the player thinks they've seen two places (p. 86–87).

14. **The art list is the script, and it has to match the canon.** Requests that contradict shipped
    text or the bible get drawn as written and then contradict the game:
    - W3 #20 calls the Wennen "fox-eared forest folk". The bible says lunar rabbitfolk, and S-08b
      shows rabbits.
    - The prologue's carving ("a small sixth figure... No face", "half-hidden by a root", two dragons
      above, five heroes with snow, flame, lute, wolf, knife) is not what S-08d shows.

    Requests also carry notes no player will ever see: a mummy who "smells of pumpkin spice",
    "breath that doesn't fog" on a walking sprite, a song title, a Speaker's name. Each of those has
    to be carried by a game line or it's lost (p. 82–83).

15. **The likely failure modes, ranked by how often they appear now:**
    1. Words under a panel moving past its frozen moment.
    2. Showpiece visuals told in narration stacks.
    3. Panels that disagree with text, bible or each other.
    4. Overlong boxes.
    5. Montage chronology that loses the player.
    6. A panel that reveals what the words are still setting up.
    7. Signifier drift.
    8. Balloons or poses landing on the wrong character.

---

## 5. Scene critiques

### 5.1 SC 5.09–5.10, the third way and "Falling" (`023_Chapter5.rb` `scene_third_way` tail and `scene_falling`; `044_ChasmFaithful.rb` `chasm_falling_glimpses`, `chasm_keepsakes`). Act I ending.

**What works**

- **The device is set up before it's used.** O-07 (mirror shards with tiny lantern, root, tree and
  egg icons, drifting up over the panels) goes up with the single line "You fall through moments."
  before any panel. The player knows what kind of space this is (time, not place) before the first
  cut (items 21, E2). The shard icons quietly anticipate the panels' subjects, acting as a bridge
  between them.
- **One frozen moment, one short line.** S-08a, S-08c, S-08d and S-08e each take one box. That's
  the fast "speeding bullet" climax Nordling describes (p. 162), and the panels carry the weight.
- **Time reads from a growing subject.** S-07 (wyrmlings hatching) → S-08a (sapling) → S-08c (two
  *young* dragons circling a full-grown tree) uses the constant-subject trick (p. 101–103). The
  player sees centuries go by without being told a number.
- **S-08e is a model callback.** It holds S-01's lantern-globe frame (party on the dock, a frost
  crack) and changes one thing: a hooded face and a hand on the glass, looking in. The figure is
  hooded, so it works for any player avatar. It's gated to `journey?`, correctly, because it's "your
  own face" (p. 130).
- **Left-to-right holds in S-07 and S-08c.** Green is on the left, white on the right, and the text
  names them in that order (C1). In S-08b the frozen man in ice, the reveal, sits on the right.

**What fails, and the fixes**

1. **S-08b: words outrun and contradict the picture (items 6–7, 12).**
   - The first line says "Moon-white Wennen", but the lead rabbit in the panel is brown.
   - The second box ("They kneel among the roots, and stay. Settlers lay walkways between the
     roots.") describes two later moments, decades apart, under a panel of a frozen street with no
     roots or sapling in it.

   *Fix:* recolour the lead Wennen or change the text to "Two Wennen". Then either drop the second
   line, or turn the founding into its own panel and move the line there.

2. **S-08d: the art doesn't match the carving the Journey player has already read about (item
   12).** The prologue (`030_Prologue.rb` `pro_mural`, the step before the lantern) says:
   - five heroes, identifiable by snow, flame, lute, wolf, and shadow with a knife
   - two dragons coiling above them
   - "In the corner, half-hidden by a root, a small sixth figure. No face."

   The panel shows six figures of the same size in a row, no attributes and no dragons. The sixth
   is a pale, unfinished outline at the right end of the row, not small and not in a corner, and the
   chisel sits between the fifth and sixth rather than clearly over it. The 5.10 line itself says
   "small sixth figure".

   *Fix:* revise the art to the prologue description (sixth figure small, in the corner, faceless,
   chisel over it). This is the beat the whole Journey prologue pays off.

3. **The glimpses after the panels reverse the chronology and undercut the ending (items 5, 14,
   31).** The panels run forward to four hundred years later and end on the strongest image, your
   own face in the lantern. Then `chasm_falling_glimpses` jumps back to the chasm mouth "at dawn",
   the wolves, Durmoot's toast, a bard, "Years on...", and the silver-haired woman. That's 9–10
   boxes of text only, opened by "More moments fall past you, too fast to hold". The line promises
   speed, and this is the slowest stretch of the scene.

   *Fix:* move the near-term glimpses *before* S-08a, so the sequence runs days, then years, then
   centuries, then your face. Give each glimpse one short line (wire up S-08f–j from the W1 request
   when they land). Cut the summarising "Years on, travellers in Dougan's Hole whisper..." box, and
   put Durmoot's "...Don't tell anyone I said that." in a box of its own for the pause. End the
   montage on S-08e in Journey mode and on S-08d in Herald modes.

4. **The 158-character Reghed-tents line and two other 100+ character lines spill past one box**
   (item 2). Split them, or trim them to the image.

5. **No bookend for Wyn (items 25–26).** Wyn fell through an old mirror shard showing "a dock in a
   blizzard". In Wyn mode the montage has no beat for Wyn's own fall.

   *Fix (needs art):* a Wyn variant of S-08e, with the Sap Gate's mirror shard and Wyn's face, gated
   `herald?(:wyn)`. Cheaper alternative: show S-01 under Wyn's prologue line, so the dock image is
   shared.

6. **The balloon lands on the wrong wyrmling (item 17).** In `scene_third_way`, right after S-07
   comes off, `Stage.balloon(white, "B-05")` plays over the *white* wyrmling, and the very next box
   is "RAZZILITH: ... Fly?". Razzilith is the green one, so the player reads the white one as the
   speaker.

   *Fix:* put B-05 on `green`, or fire it before the "SHADE: ...Hi." box as the white one's reaction.

7. **S-07 under the Meat Meat box (item 7).** "It grabs a fistful of Meat Meat's long white hair"
   plays under a panel where the green wyrmling sits facing its sibling. Keep the hair line for after
   `panel_off`, or ask for the panel to show the grab.

**Theme check (item 31).** The act's theme is "there's always a third way: refuse the trade of one
life for another". The acorn, "a life that hasn't started yet", proves it, and the sapling-to-city
panels show what the third way grew into. With the reordering above, nothing after the last panel
dilutes it.

### 5.2 SC 3.03–3.04, the empty bedroll and the vision (`015_Chapter3.rb` `scene_shimmer_taken`). Act I, middle.

**What works**

- **The "..." box is the gutter between night and morning** (p. 74–76). "One by one, the party falls
  asleep." / "..." / "Morning." is a clean time jump made with one silent beat.
- **The vision convention is used well.** O-03 frosted frame plus a panel covers the `Stage.visit`
  cut. A panel covers the jump back too. The player always knows this is a vision (H1).
- **Words carry what pictures can't:** "It beats to someone else's pulse", "Snow falling without a
  sound". That's the right split (D3).
- **The flash is the page turn.** "The blade falls. White fire. When it fades, there is no body." is
  followed by a white flash, then S-05 (aftermath). The setup is one box and the reveal comes after
  the cut (E1).
- **The scene ends on a hook:** "a tall figure with long ears and a lantern waits in the snow." That
  is the third kind of page turn, an expectation left open (p. 153).

**What fails, and the fixes**

1. **S-04 shows the ending and the wrong place (items 11, 22).** It comes up under "A stone circle
   in the birches. Snow falling without a sound." What it shows is:
   - an interior with Gothic arches, candles and a city in the window, not a stone circle or birches
   - Sephek already standing with the knife
   - a body laid out under the black-veined Heart

   So the panel contradicts the line, and it gives away the climax the next fifteen boxes build to.

   *Fix:* redraw or re-brief S-04 as the establishing frame the line describes: a stone circle,
   birches, silent snow, Shimmer bound but alive, the Heart above, no knife. Alternatively, move the
   current art to the moment of "The blade falls" and add a new establishing panel.

2. **Three looks for one place (item 22).** S-04 is a cathedral. S-05 is open ruins under a moon
   with a city on the hills. The Glade map is a third look. The player can reasonably think the
   aftermath happens somewhere else.

   *Fix:* one brief for the Glade's slab that every panel and the map honour.

3. **Silent flip between panel and map (item 16).** S-04 and S-05 both put Sephek on the *left* of
   the slab. The map staging puts Shimmer at x14 and Sephek at x16 facing left, so Sephek is on the
   *right*. The scene reverses when the panel lifts and reverses back when S-05 comes up.

   *Fix:* stage Sephek at x12 facing right (and walk him Right for the blade), or flip both panels.

4. **S-05's line order runs against the eye (item 10, C2).** The picture shows Sephek kneeling on
   the left and the rose and the small heart on the slab on the right. The lines go rose, then
   heart, then "Sephek falls to his knees".

   *Fix:* reorder: "Sephek is on his knees, weeping." / "On the stone, only a rose, frozen in bloom."
   / "Beside it, a heart of ice beats once, and breathes out mist." Also "falls" says he's still
   moving while the picture shows him already down, so use the state verb.

5. **Minor.** The eight-box Sephek/Shimmer exchange runs over a static map. Shimmer holds one
   P-SHI-03 pose from the start of the vision. A second pose or a small effect on "She closes her
   eyes... something cracks" would give the turning point a picture of its own.

### 5.3 SC 6.08, the spark that wasn't out (`029_Glimmer.rb` `glimmer_arrives`). Act II.

**What works**

- **O-01 aurora pours in as the scene opens.** It's the right signifier, used consistently with the
  Rift elsewhere.
- **The verbal reveal is well built.** The newcomer speaks as `???:` for two lines, then Alberica
  says "...Shade?", then "GLIMMER: Glimmer, now." The name lands like a page turn (p. 150–151).
- **The time jump is legible in words:** "Seven years on her side of the glass. About a minute on
  yours." (B4)
- **The choice ("Go." / "Come back.") comes right before the effect and flash.** The player's word
  is the last beat before the cut.

**What fails, and the fixes**

1. **The biggest transformation in Act II is told as radio (items 28–29, D1).** About 25 narration
   boxes describe pure visuals:
   - the sky going smooth as a mirror
   - a plain of ember stars
   - a unicorn with a mane of fire at the glass
   - the glass bulging
   - a tall cat-man stepping out with stars caught in his fur
   - his shadow forming in the aurora with void-black eyes
   - the Shard sinking into his chest
   - letters lighting up round the ring

   The only images are a generic E-07 and a flash.

   *Fix:* two panels and one effect.
   - (a) Brightmane at the edge of the glass over the plain of stars. This replaces three or four
     boxes; keep "a voice like a bell, heard through warm water", which a picture can't carry.
   - (b) The reveal panel after "Then the glass bulges.": the cat-man half-stepped out, stars in his
     fur, horn in hand, Rimefang at the hip, shown left to right so the horn, the payoff, is on the
     right.
   - An effect or overlay for the shadow in the aurora.

   Then cut the narration down to sound, meaning and the shadow's question.

2. **Overlong boxes (item 2).** Five lines run 107–138 characters:
   - the shadow line
   - the Rift inscription (110)
   - "That's my hand. That's how I make my G..." (138)
   - Glimmer's line to Alberica (123)
   - the Rimefang line

   The inscription is better split into its two sentences, each its own beat, which is the way the
   letters "light up".

3. **Conditional blocks make the scene sprawl (items 1, 5).** With the journal, the cat carving and
   the Moon Temple dream all present, the scene runs past 45 boxes. The journal beat is strong.
   Consider moving the carving or the Moon Temple line into party chat at the next rest point, so the
   reveal keeps its speed (G3).

4. **Signifier check (item 23).** O-01 here (aurora) is consistent. The Brightmane vision in
   Downtime, which uses O-01 with the "built" hard pulse, is the drift to fix (§4 item 9).

---

*Related source files:*
- `/home/claude/frost-thaw/game/Data/Scripts/998_FrostThaw/043_Stage.rb`: the staging API
- `/home/claude/frost-thaw/build/gfx/Pictures/`: S- panels, O- overlays, B- balloons
- `/home/claude/frost-thaw/docs/art_requests_W1.md` … `W5.md`: open art requests
