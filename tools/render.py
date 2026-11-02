"""Render an exported map JSON to PNG. Usage: render.py map.json out.png [scale] [grid]"""
import json, sys, os
from PIL import Image, ImageDraw
GAME = os.environ.get("GAME", "/home/claude/pif-682")
PAT = [
 [[27,28,33,34],[5,28,33,34],[27,6,33,34],[5,6,33,34],[27,28,33,12],[5,28,33,12],[27,6,33,12],[5,6,33,12]],
 [[27,28,11,34],[5,28,11,34],[27,6,11,34],[5,6,11,34],[27,28,11,12],[5,28,11,12],[27,6,11,12],[5,6,11,12]],
 [[25,26,31,32],[25,6,31,32],[25,26,31,12],[25,6,31,12],[15,16,21,22],[15,16,21,12],[15,16,11,22],[15,16,11,12]],
 [[29,30,35,36],[29,30,11,36],[5,30,35,36],[5,30,11,36],[39,40,45,46],[5,40,45,46],[39,6,45,46],[5,6,45,46]],
 [[25,30,31,36],[15,16,45,46],[13,14,19,20],[13,14,19,12],[17,18,23,24],[17,18,11,24],[41,42,47,48],[5,42,47,48]],
 [[37,38,43,44],[37,6,43,44],[13,18,19,24],[13,14,43,44],[37,42,43,48],[17,18,47,48],[13,18,43,48],[1,2,7,8]]]
def find(folder, name):
    for ext in (".png", ".PNG", ""):
        p = os.path.join(GAME, "Graphics", folder, name + ext)
        if os.path.isfile(p): return p
    return None
class Tiles:
    def __init__(self, tileset, autos):
        self.ts = Image.open(find("Tilesets", tileset)).convert("RGBA")
        self.autos = []
        for a in autos:
            p = find("Autotiles", a) if a else None
            self.autos.append(Image.open(p).convert("RGBA") if p else None)
        self.cache = {}
    def tile(self, tid):
        if tid in self.cache: return self.cache[tid]
        im = None
        if tid >= 384:
            i = tid - 384; x, y = (i % 8) * 32, (i // 8) * 32
            if y + 32 <= self.ts.height: im = self.ts.crop((x, y, x + 32, y + 32))
        elif tid >= 48:
            a = self.autos[tid // 48 - 1] if tid // 48 - 1 < len(self.autos) else None
            if a is not None:
                if a.height == 32:
                    im = a.crop((0, 0, 32, 32))
                else:
                    sc = 128 / a.height
                    if sc != 1: a = a.resize((max(96, int(a.width * sc)), 128))
                    frame = a.crop((0, 0, 96, 128))
                    im = Image.new("RGBA", (32, 32))
                    idx = tid % 48
                    for q, mini in enumerate(PAT[idx >> 3][idx & 7]):
                        mini -= 1
                        sx, sy = (mini % 6) * 16, (mini // 6) * 16
                        im.paste(frame.crop((sx, sy, sx + 16, sy + 16)), ((q % 2) * 16, (q // 2) * 16))
        self.cache[tid] = im
        return im
def render(m, out, scale=1.0, grid=False):
    W, H = m["w"], m["h"]
    t = Tiles(m["tileset"], m["autotiles"])
    img = Image.new("RGBA", (W * 32, H * 32), (0, 0, 0, 255))
    d = m["data"]
    for z in range(3):
        for y in range(H):
            for x in range(W):
                tid = d[x + y * W + z * W * H]
                if tid:
                    ti = t.tile(tid)
                    if ti: img.alpha_composite(ti, (x * 32, y * 32))
    for e in m.get("events", []):
        if e.get("char"):
            p = find("Characters", e["char"])
            if p:
                c = Image.open(p).convert("RGBA"); fw, fh = c.width // 4, c.height // 4
                row = {2: 0, 4: 1, 6: 2, 8: 3}.get(e.get("dir", 2), 0)
                fr = c.crop((0, row * fh, fw, row * fh + fh))
                img.alpha_composite(fr, (e["x"] * 32 + 16 - fw // 2, e["y"] * 32 + 32 - fh))
        elif e.get("tile"):
            ti = t.tile(e["tile"])
            if ti: img.alpha_composite(ti, (e["x"] * 32, e["y"] * 32))
    if grid:
        dr = ImageDraw.Draw(img)
        for x in range(0, W, 5):
            dr.line([(x * 32, 0), (x * 32, H * 32)], fill=(255, 0, 0, 90))
            dr.text((x * 32 + 2, 2), str(x), fill=(255, 255, 0, 255))
        for y in range(0, H, 5):
            dr.line([(0, y * 32), (W * 32, y * 32)], fill=(255, 0, 0, 90))
            dr.text((2, y * 32 + 2), str(y), fill=(255, 255, 0, 255))
    if scale != 1.0: img = img.resize((int(img.width * scale), int(img.height * scale)))
    img.convert("RGB").save(out)
if __name__ == "__main__":
    m = json.load(open(sys.argv[1]))
    render(m, sys.argv[2], float(sys.argv[3]) if len(sys.argv) > 3 else 1.0, len(sys.argv) > 4)
