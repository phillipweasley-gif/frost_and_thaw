"""Storyboard from a stage trace: one camera-sized frame per message box, with
the map, everyone on it, you (magenta), and the line. Shows at a glance whether
the speaker is on screen.
Usage: storyboard.py trace.json maps_dir out_prefix [first] [last]"""
import json, os, subprocess, sys, textwrap
from PIL import Image, ImageDraw
trace = json.load(open(sys.argv[1])); maps = sys.argv[2]; out = sys.argv[3]
a = int(sys.argv[4]) if len(sys.argv) > 4 else 0; b = int(sys.argv[5]) if len(sys.argv) > 5 else len(trace)
GAME = os.environ.get("GAME", "/home/claude/pifrun")
HERE = os.path.dirname(os.path.abspath(__file__)); tmp = out + "_maps"; os.makedirs(tmp, exist_ok=True)
cache = {}
def mapimg(mid):
    if mid not in cache:
        js = f"{tmp}/{mid}.json"; png = f"{tmp}/{mid}.png"
        if not os.path.exists(png):
            subprocess.run(["ruby", f"{HERE}/map2json.rb", f"{maps}/Map{mid}.rxdata", js], check=True)
            d = json.load(open(js)); d["events"] = []; json.dump(d, open(js, "w"))
            subprocess.run(["python3", f"{HERE}/render.py", js, png, "1"], check=True, env=dict(os.environ, GAME=GAME))
        cache[mid] = Image.open(png).convert("RGBA")
    return cache[mid]
def sheet(name):
    for ext in (".png", ".PNG"):
        p = f"{GAME}/Graphics/Characters/{name}{ext}"
        if os.path.exists(p): return Image.open(p).convert("RGBA")
ROW = {2: 0, 4: 1, 6: 2, 8: 3}
frames = []
for i, t in enumerate(trace[a:b], a):
    m = mapimg(t["map"]); W, H = 512, 384
    fx, fy = t["dx"] // 4, t["dy"] // 4
    f = Image.new("RGBA", (W, H + 70), (0, 0, 0, 255)); f.alpha_composite(m.crop((fx, fy, fx + W, fy + H)), (0, 0))
    d = ImageDraw.Draw(f)
    people = sorted(t["chars"], key=lambda c: c["real_y"])
    for c in people:
        s = sheet(c["g"])
        if s is None: continue
        fw, fh = s.width // 4, s.height // 4
        cell = s.crop((0, ROW.get(c["d"], 0) * fh, fw, ROW.get(c["d"], 0) * fh + fh))
        sx = c["real_x"] // 4 - fx + 16 - fw // 2; sy = c["real_y"] // 4 - fy + 32 - fh
        if -fw < sx < W and -fh < sy < H: f.alpha_composite(cell, (sx, sy))
    px = t["player"]["x"] * 32 - fx; py = t["player"]["y"] * 32 - fy
    d.rectangle((px + 6, py - 10, px + 26, py + 30), outline=(255, 0, 255), width=3); d.text((px + 4, py - 22), "YOU", fill=(255, 0, 255))
    d.rectangle((0, H, W, H + 70), fill=(250, 250, 250))
    d.text((6, H + 4), f"#{i}  map {t['map']}", fill=(120, 120, 120))
    for k, l in enumerate(textwrap.wrap(t["line"], 78)[:3]): d.text((6, H + 18 + k * 16), l, fill=(0, 0, 0))
    frames.append(f.convert("RGB"))
# contact sheets of 6 frames (2 x 3) at full size
for n in range(0, len(frames), 6):
    grp = frames[n:n + 6]; cols = 2; rows = (len(grp) + 1) // 2
    sheet_img = Image.new("RGB", (cols * 512 + 8, rows * 454 + 8 * rows), (60, 60, 60))
    for k, fr in enumerate(grp): sheet_img.paste(fr, ((k % 2) * 520, (k // 2) * 462))
    sheet_img.save(f"{out}_{n // 6:02d}.png")
print(f"{len(frames)} frames -> {(len(frames) + 5) // 6} sheets")
