# Brief: publish the story review to the owner's review doc

The owner's review doc is a Claude Docs project: container `{"kind":"project","id":"959540e3-5f5d-4634-ac0b-55099080781a"}`.
It already has a top-level tab **"Story review"**: file id `531f671f-32ea`, body node `a38070cb-aea7`
(engine `prose`). Its first part is already there (title, "In short", "What's working, game-wide").

Tools: load `mcp__Claude_Docs__batch`, `mcp__Claude_Docs__update`, `mcp__Claude_Docs__read` and
`mcp__Claude_Docs__guide` with ToolSearch (`select:` them in one call). Read `guide(items=["topic.index","topic.tabs","topic.editing"])` once before you start.

## What to publish

Copy the markdown files **verbatim** (don't edit, summarise or reflow the text; it has been reviewed). Each
call's inline markdown must stay under about 11,000 characters, so split each file at `## ` or `### ` headings
(or, inside a long section, between table rows or paragraphs; when you split a pipe table, repeat its header row
and separator at the top of the next chunk). Insert chunks in order, each at the end of the tab
(`{"op":"insert","target":{"kind":"root"},"side":"end","source":{"as":"markdown","from":{"kind":"inline","content":"..."}}}`).
Escape the content correctly as a JSON string.

**Per-chapter sub-tabs.** For each file `docs/review/story/NN.md` you own, create one sub-tab under "Story review"
in a single `batch` (topic.tabs ex.1): create the file (`birthName` like `Story 03.ldoc`), create its prose node
with the file's first chunk, set the file's content to the node, and place it with a project patch
`{"op":"set","path":["tabs","$lid:f"],"value":{"name":"<NAME>","order":"bNN","subtabOf":"531f671f-32ea"}}`.
Then append the rest of the file's chunks to that new node. Names (use exactly):

00 "00 Prologue" · 01 "01 Ch 1: Targos" · 02 "02 Ch 2: Lottery Night" · 03 "03 Ch 3: Shimmer's Requiem" ·
04 "04 Ch 4: Dougan's Hole" · 05 "05 Ch 5: The Cackling Chasm" · 06 "06 Ch 6: Festival of Returning Light" ·
07 "07 Ch 7: Two Roads Down" · 08 "08 Ch 8: The Rootsun Forge" · 09 "09 Ch 9: Destruction's Light" ·
10 "10 Ch 10: Trials of the Roots" · 11 "11 Ch 11: The Frost Saint Walks" · 12 "12 Ch 12: The Sea of Moving Ice" ·
13 "13 Ch 13: Grimskalle and the endings" · 14 "14 Side: Ten-Towns quests" · 15 "15 Side: Rootspire quests"

Don't touch any other tab. If a call is refused, read the refusal, fix the call, and retry; never create a
second copy of a tab (read the project first to check whether your tab already exists, e.g. after a restart:
if it does, read its body to see how far it got and continue from there).

Finish with a short report: the tabs you created (name, file id, node id), and the number of chunks per tab.
