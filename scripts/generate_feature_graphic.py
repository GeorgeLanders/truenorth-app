"""Generate TrueNorth feature graphic (1024x500) for Google Play Store."""
from PIL import Image, ImageDraw, ImageFont
import math, random, os

random.seed(42)
w, h = 1024, 500
img = Image.new('RGBA', (w, h), (11, 11, 43, 255))
draw = ImageDraw.Draw(img)

# Background gradient deep space purple
for y in range(h):
    t = y / h
    r = int(11 + (27 - 11) * t)
    g = int(11 + (10 - 11) * t)
    b = int(43 + (46 - 43) * t)
    draw.line([(0, y), (w, y)], fill=(r, g, b, 255))

def draw_glow_circle(draw, cx, cy, r, color, steps=40):
    for i in range(steps):
        alpha = int(color[3] * (1 - i / steps))
        cur_r = r + i * 3
        draw.ellipse([cx - cur_r, cy - cur_r, cx + cur_r, cy + cur_r],
                     fill=(color[0], color[1], color[2], alpha))

# Ambient glow circles
draw_glow_circle(draw, 200, 350, 100, (139, 92, 246, 35))
draw_glow_circle(draw, 850, 150, 90, (255, 51, 102, 30))
draw_glow_circle(draw, 512, 250, 70, (0, 245, 255, 20))

# Compass Rose / North Star
cx, cy = 512, 230

def draw_star_point(draw, cx, cy, angle, length, color):
    ang = math.radians(angle)
    x1 = cx + math.cos(ang) * length
    y1 = cy + math.sin(ang) * length
    x2 = cx + math.cos(ang + math.radians(22)) * length * 0.32
    y2 = cy + math.sin(ang + math.radians(22)) * length * 0.32
    x3 = cx + math.cos(ang - math.radians(22)) * length * 0.32
    y3 = cy + math.sin(ang - math.radians(22)) * length * 0.32
    for i in range(4):
        s = 1 + i * 1.5
        draw.polygon([(cx, cy),
                      (cx + (x1-cx)*s, cy + (y1-cy)*s),
                      (cx + (x2-cx)*s, cy + (y2-cy)*s)],
                     fill=(color[0], color[1], color[2], 25 - i * 5))
    draw.polygon([(cx, cy), (x1, y1), (x2, y2)], fill=(color[0], color[1], color[2], 200))
    draw.polygon([(cx, cy), (x1, y1), (x3, y3)], fill=(color[0], color[1], color[2], 200))

# 4 main compass points
for angle, color in [(0, (139, 92, 246)), (90, (255, 51, 102)),
                     (180, (139, 92, 246)), (270, (255, 51, 102))]:
    draw_star_point(draw, cx, cy, angle, 90, color)
    ang_r = math.radians(angle)
    tx = cx + math.cos(ang_r) * 90
    ty = cy + math.sin(ang_r) * 90
    draw.ellipse([tx - 5, ty - 5, tx + 5, ty + 5], fill=(255, 184, 0, 220))

# 4 minor points
for angle, color in [(45, (0, 245, 255)), (135, (0, 245, 101)),
                     (225, (0, 245, 255)), (315, (0, 245, 101))]:
    draw_star_point(draw, cx, cy, angle, 40, color)

# Center
draw_glow_circle(draw, cx, cy, 16, (255, 255, 255, 50))
draw.ellipse([cx - 10, cy - 10, cx + 10, cy + 10], fill=(255, 255, 255, 200))

# Fonts
font_dir = "C:\\Windows\\Fonts"
title_font = ImageFont.truetype(os.path.join(font_dir, "segoeuib.ttf"), 70)
tag_font = ImageFont.truetype(os.path.join(font_dir, "segoeui.ttf"), 28)
sub_font = ImageFont.truetype(os.path.join(font_dir, "segoeui.ttf"), 18)

# "TRUENORTH" title
text = "TRUENORTH"
bbox = draw.textbbox((0, 0), text, font=title_font)
tw = bbox[2] - bbox[0]
tx = (w - tw) // 2
for dx, dy in [(-2, -2), (2, -2), (-2, 2), (2, 2)]:
    draw.text((tx + dx, 55 + dy), text, fill=(139, 92, 246, 50), font=title_font)
draw.text((tx, 55), text, fill=(255, 255, 255, 255), font=title_font)

# Tagline
tagline = "Wellness Without Judgment"
bbox2 = draw.textbbox((0, 0), tagline, font=tag_font)
tw2 = bbox2[2] - bbox2[0]
tx2 = (w - tw2) // 2
draw.text((tx2, 355), tagline, fill=(255, 184, 0, 220), font=tag_font)

# Subtitle
sub = "Movement  \u00b7  Nourishment  \u00b7  Mindfulness  \u00b7  Community"
bbox3 = draw.textbbox((0, 0), sub, font=sub_font)
tw3 = bbox3[2] - bbox3[0]
tx3 = (w - tw3) // 2
draw.text((tx3, 405), sub, fill=(255, 255, 255, 100), font=sub_font)

# Decorative particles
for _ in range(50):
    x = random.randint(0, w)
    y = random.randint(0, h)
    s = random.randint(1, 3)
    a = random.randint(20, 70)
    draw.ellipse([x - s, y - s, x + s, y + s], fill=(255, 255, 255, a))

# Accent lines
draw.rectangle([(0, h - 2), (w, h - 1)], fill=(0, 245, 255, 50))
draw.rectangle([(0, 0), (w, 2)], fill=(139, 92, 246, 35))

# Save
out_dir = os.path.join("C:\\Users\\George\\Desktop\\truenorth_app", "store_assets")
os.makedirs(out_dir, exist_ok=True)

png_path = os.path.join(out_dir, "feature_graphic.png")
img.save(png_path)
print(f"Saved: {png_path} ({img.size})")

jpg_path = os.path.join(out_dir, "feature_graphic.jpg")
rgb = Image.new('RGB', img.size, (11, 11, 43))
rgb.paste(img, mask=img.split()[3] if img.mode == 'RGBA' else None)
rgb.save(jpg_path, "JPEG", quality=95)
print(f"Saved: {jpg_path}")
