"""Draws the AccessWatch launcher icon and writes the Android mipmaps.

Usage (from accesswatch_mobile/): python ../tools/make_icon.py android/app/src/main/res assets_src/app_icon_1024.png
"""
import sys
from pathlib import Path

from PIL import Image, ImageDraw

BG = (8, 13, 18)
TEAL = (53, 201, 208)
BLUE = (49, 130, 189)
LIGHT = (158, 202, 225)
S = 1024

img = Image.new("RGBA", (S, S), BG + (255,))
d = ImageDraw.Draw(img)
c = S // 2
# Radar rings, as in the app's header mark.
for r, w in ((330, 34), (220, 34)):
    d.ellipse((c - r, c - r - 60, c + r, c + r - 60), outline=TEAL, width=w)
d.ellipse((c - 70, c - 130, c + 70, c + 10), fill=TEAL)
# Floodwater across the lower part, in the depth palette.
for i, (colour, top) in enumerate(((LIGHT, 640), (BLUE, 700), ((8, 48, 107), 770))):
    points = []
    for x in range(0, S + 1, 16):
        import math
        points.append((x, top + 26 * math.sin((x / S) * 2 * math.pi * 2 + i)))
    d.polygon(points + [(S, S), (0, S)], fill=colour)

res = Path(sys.argv[1])
for folder, size in (("mipmap-mdpi", 48), ("mipmap-hdpi", 72), ("mipmap-xhdpi", 96), ("mipmap-xxhdpi", 144), ("mipmap-xxxhdpi", 192)):
    img.resize((size, size), Image.LANCZOS).convert("RGB").save(res / folder / "ic_launcher.png", optimize=True)
img.convert("RGB").save(Path(sys.argv[2]), optimize=True)
print("ok")
