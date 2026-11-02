"""The user's example sheets of Alberica hybrids (build/concept/merge_examples_*.png) turned into fusion sprites,
the same way as the other concept sheets: cut the creature from the paper, reduce the painting to a few clean
materials (found automatically by colour), shade each from its own ramp, outline, then hand-place what has to
read at sprite size."""
import numpy as np
import cv2
from PIL import Image
from scipy import ndimage as ndi
import from_sheet as F

SHEETS = {k: f"/home/claude/frost-thaw/build/concept/merge_examples_{k}.png" for k in (1, 2, 3)}

# (sheet, crop box, sprite size, materials, file name)
PAIRS = {
    "577.1": (2, (30, 128, 462, 472), 66, 8),       # Bulbasaur x Lutling
    "578.2": (2, (448, 82, 882, 472), 78, 9),       # Ivysaur x Hauntello
    "579.3": (2, (905, 62, 1532, 476), 92, 10),     # Venusaur x Chorumbra
    "577.399": (2, (8, 578, 332, 958), 64, 8),      # Zorua x Lutling
    "578.338": (2, (340, 512, 762, 962), 86, 9),    # Zoroark x Hauntello
    "577.440": (2, (768, 608, 1082, 958), 72, 9),   # Noibat x Lutling
    "579.441": (2, (1042, 512, 1536, 962), 94, 10),  # Noivern x Chorumbra
    "577.582": (3, (38, 98, 432, 432), 72, 9),      # Wickit x Lutling
    "578.583": (3, (458, 52, 902, 428), 86, 9),     # Stoketail x Hauntello
    "579.584": (3, (888, 28, 1518, 432), 94, 10),   # Forgel x Chorumbra
    "577.421": (3, (72, 552, 372, 948), 66, 8),     # Sableye x Lutling
    "578.585": (3, (528, 478, 882, 952), 84, 9),    # Sporeye x Hauntello
    "579.586": (3, (912, 472, 1528, 952), 94, 10),  # Myconarch x Chorumbra
    "578.94": (1, (508, 152, 1002, 652), 78, 9),    # Gengar x Hauntello
    "579.287": (1, (1058, 168, 1532, 662), 84, 9),  # Gardevoir x Chorumbra
}


def auto_classify(k):
    """Materials found by colour: 'line' for the ink, then k colour families (LAB k-means)."""
    def classify(src, fg):
        lum = src.astype(np.float32) @ np.array([0.3, 0.59, 0.11], np.float32)
        line = (lum < 52) & fg
        body = fg & ~line
        lab = cv2.cvtColor(np.ascontiguousarray(src), cv2.COLOR_RGB2LAB).reshape(-1, 3).astype(np.float32)
        Z = lab[body.ravel()].copy()
        Z[:, 0] *= 0.55                                   # hue and chroma decide the material more than light
        crit = (cv2.TERM_CRITERIA_EPS + cv2.TERM_CRITERIA_MAX_ITER, 60, 0.5)
        _, labels, _ = cv2.kmeans(Z, k, None, crit, 4, cv2.KMEANS_PP_CENTERS)
        mat = np.full(fg.shape, -1, int)
        mat.ravel()[np.flatnonzero(body.ravel())] = labels.ravel() + 1
        mat[line] = 0
        return mat, ["line"] + [f"m{i}" for i in range(k)]
    return classify


_CACHE = {}


def punch(ramp, sat=1.25, spread=1.25):
    """Sprite ramps need more contrast than painting medians: push saturation up and spread the light values
    apart around the ramp's middle (darkest a little darker, lightest a little lighter)."""
    import colorsys
    ramp = [np.array(c, float) for c in ramp]
    mid = np.mean([F_lum(c) for c in ramp])
    out = []
    for c in ramp:
        h, l, s_ = colorsys.rgb_to_hls(*(c / 255))
        l2 = min(0.97, max(0.06, 0.5 * 0 + (l - mid / 255) * spread + mid / 255))
        s2 = min(1.0, s_ * sat)
        out.append(tuple(int(round(v * 255)) for v in colorsys.hls_to_rgb(h, l2, s2)))
    return out


def F_lum(c):
    return 0.3 * c[0] + 0.59 * c[1] + 0.11 * c[2]


def convert(key, size=None, post=None, simplify=1.1, smooth=1.6, n=4, canvas=96, ground=93, inner=True):
    sheet, (x0, y0, x1, y1), sz, k = PAIRS[key]
    src = np.asarray(Image.open(SHEETS[sheet]).convert("RGB"))[y0:y1, x0:x1]
    fg = F.cut_main(src)
    ys, xs = np.nonzero(fg)
    bx, by = xs.min(), ys.min()
    src = np.ascontiguousarray(src[by:ys.max() + 1, bx:xs.max() + 1])
    fg = fg[by:ys.max() + 1, bx:xs.max() + 1]
    if key not in _CACHE:
        # fix the materials once (k-means is random), so every size of this sprite agrees
        np.random.seed(0); cv2.setRNGSeed(0)
        mat, names = auto_classify(k)(src, fg)
        _CACHE[key] = (mat, names)
    mat, names = _CACHE[key]
    classify = lambda s, f: (mat, names)
    tones = F.concept_tones(src, fg, classify, n=n)
    tones = {nm: v for nm, v in tones.items() if v and not any(np.isnan(np.array(c)).any() for c in v)}
    tones = {nm: punch(v) if nm != "line" else v for nm, v in tones.items()}
    return F.reduce_semantic(src, fg, size or sz, classify, tones, ground=ground, canvas=canvas, simplify=simplify,
                             smooth=smooth, inner_lines=inner, guide_box=(x0 + bx, y0 + by), post=post)


if __name__ == "__main__":
    import sys
    sys.path.insert(0, ".")
    from alb_ops import show
    S = "/tmp/claude-0/-home-claude/afa09e9e-912d-533c-960b-db337877363e/scratchpad/"
    keys = sys.argv[1:] or list(PAIRS)
    imgs = [convert(k) for k in keys]
    show(imgs, keys, S + "merge_conv.png", z=3)
