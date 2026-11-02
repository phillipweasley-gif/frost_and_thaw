"""Sprite painting closer to hand-made game sprites:
  * a Part is shaded as ONE volume (its pieces are unioned before lighting: no pillow shading per blob)
  * colour regions inside a part (a cream muzzle, a belly) share that part's light, so forms stay whole
  * each part casts a soft shadow (one band darker) onto the parts behind it
  * outlines are per part, so overlaps get a clean interior line"""
import math
from PIL import Image
from clean import smooth_poly_mask, to_mask, lighting, outline_of, N


def darker(c, k=0.5):
    return tuple(int(v * k) for v in c)


class Part:
    def __init__(self, polys, tones, depth=8, cuts=(-0.05, 0.35, 0.75), outline=None, regions=(), shadow=(1, 2),
                 holes=(), light=(-0.55, -0.75, 0.55), threshold=0.5, clean=True, no_outline_edges=None):
        self.mask = to_mask(smooth_poly_mask(polys, holes), threshold, clean)
        self.tones, self.depth, self.cuts, self.light = tones, depth, cuts, light
        self.outline = outline or darker(tones[0], 0.55)
        self.regions = [(to_mask(smooth_poly_mask(p), 0.5, False) & self.mask, t) for p, t in regions]
        self.shadow = shadow


def band_of(v, cuts):
    i = 0
    while i < len(cuts) and v > cuts[i]:
        i += 1
    return i


def render(parts):
    img = Image.new("RGBA", (N, N), (0, 0, 0, 0))
    px = img.load()
    owner = {}                                  # pixel -> (tones, band, is_outline, outline colour)
    for P in parts:
        m = P.mask
        if not m:
            continue
        val = lighting(m, P.depth, P.light)
        band = {p: band_of(v, P.cuts) for p, v in val.items()}
        # merge lone pixels into their neighbours' band
        for p in list(band):
            nb = [band.get((p[0] + dx, p[1] + dy)) for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1))]
            nb = [b for b in nb if b is not None]
            if nb and all(b != band[p] for b in nb):
                band[p] = max(set(nb), key=nb.count)
        ol = outline_of(m)
        # cast shadow onto what is already there
        if P.shadow:
            dx, dy = P.shadow
            for (x, y) in m:
                q = (x + dx, y + dy)
                if q in m or q not in owner:
                    continue
                tones, b, is_ol, oc = owner[q]
                if is_ol or b == 0:
                    continue
                owner[q] = (tones, b - 1, False, oc)
                px[q] = tones[b - 1] + (255,)
        for p in m:
            x, y = p
            if not (0 <= x < N and 0 <= y < N):
                continue
            tones = P.tones
            for rm, rt in P.regions:
                if p in rm:
                    tones = rt
            if p in ol:
                px[p] = P.outline + (255,)
                owner[p] = (tones, band[p], True, P.outline)
            else:
                b = min(band[p], len(tones) - 1)
                px[p] = tones[b] + (255,)
                owner[p] = (tones, b, False, P.outline)
    return img
