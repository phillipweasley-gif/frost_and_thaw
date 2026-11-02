"""Render a region of an exported map at full size with a 1-tile grid.
Usage: crop.py map.json out.png x y w h"""
import json, sys
from PIL import Image, ImageDraw
sys.path.insert(0, "/home/claude/frost-thaw/tools")
import render
m = json.load(open(sys.argv[1])); x0, y0, w, h = map(int, sys.argv[3:7])
W, H = m["w"], m["h"]
sub = dict(m); sub["w"], sub["h"] = w, h
data = []
for z in range(3):
    for y in range(y0, y0 + h):
        for x in range(x0, x0 + w):
            data.append(m["data"][x + y * W + z * W * H] if x < W and y < H else 0)
sub["data"] = data
sub["events"] = [dict(e, x=e["x"] - x0, y=e["y"] - y0) for e in m["events"] if x0 <= e["x"] < x0 + w and y0 <= e["y"] < y0 + h]
render.render(sub, "/tmp/_crop.png")
img = Image.open("/tmp/_crop.png").convert("RGBA")
pad = 18
out = Image.new("RGBA", (img.width + pad, img.height + pad), (30, 30, 30, 255))
out.paste(img, (pad, pad)); d = ImageDraw.Draw(out)
for i in range(w + 1):
    d.line([(pad + i * 32, pad), (pad + i * 32, pad + h * 32)], fill=(255, 0, 0, 110))
    if i < w: d.text((pad + i * 32 + 10, 3), str(x0 + i), fill=(255, 255, 0, 255))
for j in range(h + 1):
    d.line([(pad, pad + j * 32), (pad + w * 32, pad + j * 32)], fill=(255, 0, 0, 110))
    if j < h: d.text((1, pad + j * 32 + 10), str(y0 + j), fill=(255, 255, 0, 255))
out.convert("RGB").save(sys.argv[2])
