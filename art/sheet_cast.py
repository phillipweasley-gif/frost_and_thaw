"""Contact sheet: each character's trainer picture plus their 4 facing frames.
python3 sheet_cast.py <sprite folder> <out.png> [scale]"""
import os, sys
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(__file__))
from cast import CAST

src, out = sys.argv[1], sys.argv[2]
scale = int(sys.argv[3]) if len(sys.argv) > 3 else 2
names = [n for n in CAST if os.path.exists(os.path.join(src, f"{n}_trainer.png"))]
cell_w, cell_h = 160 + 4 * 52, 150
cols = 2
rows = (len(names) + cols - 1) // cols
sheet = Image.new("RGBA", (cols * cell_w, rows * cell_h), (58, 70, 92, 255))
d = ImageDraw.Draw(sheet)
for i, n in enumerate(names):
    x0, y0 = (i % cols) * cell_w, (i // cols) * cell_h
    tr = Image.open(os.path.join(src, f"{n}_trainer.png"))
    sheet.alpha_composite(tr.crop((20, 10, 140, 160)), (x0, y0))
    walk = Image.open(os.path.join(src, f"{n}_walk.png"))
    for k, row in enumerate((0, 1, 2, 3)):
        fr = walk.crop((0, row * 80 + 18, 80, row * 80 + 78)).crop((14, 0, 66, 60))
        sheet.alpha_composite(fr, (x0 + 125 + k * 52, y0 + 60))
    d.text((x0 + 125, y0 + 8), n.replace("_", " ").title(), fill=(255, 240, 160))
sheet = sheet.resize((sheet.width * scale, sheet.height * scale), Image.NEAREST)
sheet.save(out)
print(out)
