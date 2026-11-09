#!/usr/bin/env python3
"""The cast reference sheet for painted panels (2026-11-09): each character's installed sprite, front and side, with
the traits a panel must keep. Panels must show the cast as the sprites do (owner: S-02 "doesn't look like our characters").

    python3 tools/castref.py OUT.png"""
import sys, textwrap
from PIL import Image, ImageDraw, ImageFont

D = "build/Characters/"
CAST = [
    ("Alberica", "FT_alberica", "Dwarf bard, a woman: short and broad. Red hair in braids, a purple cap, an orange tunic. "
                                 "Her pendant (a relic). Loud and warm. Later: Auril's rune scarred on her chest."),
    ("Reptin", "FT_reptin", "Elf moon druid. Slim, fair, short brown hair, a cream shirt and green trousers. "
                             "Married to Anduin. Partner: Bulbasaur."),
    ("Alerion", "FT_alerion", "Eladrin ranger. Dark brown skin, slate-blue hair, purple eyes, a blue-grey cloak "
                               "with a gold clasp. Frost on his hands. Frostina's rider."),
    ("Meat Meat", "FT_meat_meat", "Goblin, a woman. Green skin, long white twisted hair, brass goggles pushed up, "
                                   "violet eyes, purple clothes. Small. Razzilith's rider."),
    ("Wyn", "FT_wyn", "Spore druid, they/them. Dark brown skin, white hair, a purple cap and purple tunic."),
    ("Shade", "FT_shade", "Tan skin, messy near-black hair, a grey-green hooded cloak. Carries the Rimefang, a pale "
                           "dagger smoking with cold. Becomes Glimmer."),
    ("Shimmer", "FT_shimmer", "Pale, white hair, a sage-grey dress. A frost stone under her ribs. Auril's first vessel."),
    ("Glimmer", "FT_glimmer", "Shade after the Rift: a tabaxi (cat-folk). Silver-grey fur, amber eyes, a midnight-blue "
                               "coat. Carries Brightmane's unicorn horn IN HIS HAND; no horn on his head."),
    ("Razzy", "FT_razzy", "Small goblin, voiceless. Olive-grey skin, big pointed ears, dark hair, a ragged brown tunic, "
                           "a few green scales on cheek and forearm."),
    ("Razzilith", "FT_razzilith", "Spring dragon: moss-green scales, cream belly, gold wing webs, horns. Big and gentle."),
    ("Frostina", "FT_frostina", "Winter dragon: white and ice-blue, crystal spines, pale wings."),
    ("Sephek", "FT_sephek", "Auril's Chosen, a drowned sailor. Blue-grey skin, black hair, no coat in the snow, "
                             "dark clothes. His heart glows with frost-light."),
    ("Auril", "FT_auril_furs", "The Frostmaiden. Pale, long white hair, dark furs. Cold and still."),
    ("Anduin", "FT_anduin", "Reptin's husband. Brown hair, a blue-and-gold tunic."),
]
NOTE = ("Iskra (no sprite): Auril's roc, a giant white bird with aurora trailing from her wings. "
        "Every human-shaped panel figure keeps these skin tones, hair colours and clothes.")

def frame(name, row):
    im = Image.open(D + name + ".png").convert("RGBA")
    w, h = im.width // 4, im.height // 4
    fr = im.crop((0, row * h, w, (row + 1) * h))
    return fr.crop(fr.getbbox())

def main(out):
    big = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf", 22)
    small = ImageFont.truetype("/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf", 15)
    cw, ch, cols = 560, 230, 2
    rows = (len(CAST) + cols - 1) // cols
    sheet = Image.new("RGBA", (cw * cols, ch * rows + 60), (232, 234, 238, 255))
    d = ImageDraw.Draw(sheet)
    for i, (nm, f, txt) in enumerate(CAST):
        x, y = (i % cols) * cw + 14, (i // cols) * ch + 14
        sx = x
        for r in (0, 1):
            fr = frame(f, r)
            k = max(1, min(4, 190 // fr.height))
            fr = fr.resize((fr.width * k, fr.height * k), Image.NEAREST)
            sheet.alpha_composite(fr, (sx, y + 200 - fr.height))
            sx += fr.width + 10
        tx = max(sx + 10, x + 250)
        d.text((tx, y), nm, font=big, fill=(20, 22, 30))
        for j, line in enumerate(textwrap.wrap(txt, max(22, (x + cw - 24 - tx) // 8))):
            d.text((tx, y + 34 + j * 19), line, font=small, fill=(40, 44, 56))
    for j, line in enumerate(textwrap.wrap(NOTE, 140)):
        d.text((14, ch * rows + 8 + j * 19), line, font=small, fill=(40, 44, 56))
    sheet.convert("RGB").save(out)

if __name__ == "__main__":
    main(sys.argv[1])
