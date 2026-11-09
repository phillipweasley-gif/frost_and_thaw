#!/usr/bin/env python3
"""Bring a panel painted at full 512x384 to the panels' pixel scale (2026-11-09): S-01 and S-02 are 256x192 doubled
exactly. Downsample (Lanczos), map back to the image's own 64 colours without dithering, double with nearest.

    python3 tools/panel2x.py IN.png OUT.png"""
import sys
from PIL import Image

def build(src):
    im = Image.open(src).convert("RGB")
    pal = im.quantize(colors=64, method=Image.Quantize.MEDIANCUT, dither=Image.Dither.NONE)
    small = im.resize((256, 192), Image.LANCZOS).quantize(palette=pal, dither=Image.Dither.NONE).convert("RGB")
    return small.resize((512, 384), Image.NEAREST)

if __name__ == "__main__":
    build(sys.argv[1]).save(sys.argv[2])
