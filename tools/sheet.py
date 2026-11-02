"""Show part of a tileset with tile ids. Usage: sheet.py tileset row0 nrows out.png"""
import sys
from PIL import Image, ImageDraw
sys.path.insert(0, "/home/claude/frost-thaw/tools")
import render
ts = Image.open(render.find("Tilesets", sys.argv[1])).convert("RGBA")
r0, n = int(sys.argv[2]), int(sys.argv[3])
pad = 4; cw = 32 + pad
out = Image.new("RGBA", (8 * cw + 40, n * (cw + 10)), (40, 40, 40, 255)); d = ImageDraw.Draw(out)
for r in range(n):
    for c in range(8):
        tile = ts.crop((c * 32, (r0 + r) * 32, c * 32 + 32, (r0 + r) * 32 + 32))
        x, y = 40 + c * cw, r * (cw + 10) + 10
        out.alpha_composite(tile, (x, y))
        d.text((x, y - 10), str(384 + (r0 + r) * 8 + c), fill=(255, 255, 0, 255))
    d.text((2, r * (cw + 10) + 20), str(r0 + r), fill=(200, 200, 200, 255))
out.convert("RGB").save(sys.argv[4])
