"""Generate TrueNorth Play Store screenshots (phone mockups of app screens)."""
from PIL import Image, ImageDraw, ImageFont, ImageFilter
import os, math, random

random.seed(42)
out_dir = os.path.join("C:\\Users\\George\\Desktop\\truenorth_app", "store_assets")
os.makedirs(out_dir, exist_ok=True)

font_dir = "C:\\Windows\\Fonts"
title_font = ImageFont.truetype(os.path.join(font_dir, "segoeuib.ttf"), 42)
header_font = ImageFont.truetype(os.path.join(font_dir, "segoeuib.ttf"), 28)
body_font = ImageFont.truetype(os.path.join(font_dir, "segoeui.ttf"), 20)
small_font = ImageFont.truetype(os.path.join(font_dir, "segoeui.ttf"), 16)
badge_font = ImageFont.truetype(os.path.join(font_dir, "segoeuib.ttf"), 14)

PHONE_W, PHONE_H = 540, 1170
STATUS_H = 50

# Colors
DEEP_BG = (15, 15, 46)
PURPLE = (139, 92, 246)
CORAL = (255, 51, 102)
GOLD = (255, 184, 0)
CYAN = (0, 245, 255)
GREEN = (0, 245, 101)
WHITE = (255, 255, 255)
CARD_BG = (30, 30, 70, 200)
TEXT_SECONDARY = (180, 180, 200)
GLASS = (255, 255, 255, 25)

def round_rect(draw, xy, radius, fill=None, outline=None, width=1):
    x0, y0, x1, y1 = xy
    r = radius
    draw.rounded_rectangle(xy, radius=r, fill=fill, outline=outline, width=width)

def draw_phone_bg(draw):
    """Draw dark gradient background for phone screen"""
    for y in range(PHONE_H):
        t = y / PHONE_H
        r = int(15 + (22 - 15) * t)
        g = int(15 + (10 - 15) * t)
        b = int(46 + (50 - 46) * t)
        draw.line([(0, y), (PHONE_W, y)], fill=(r, g, b, 255))

def draw_status_bar(draw, time="9:41"):
    draw.text((20, 15), time, fill=(200, 200, 220, 180), font=ImageFont.truetype(os.path.join(font_dir, "segoeui.ttf"), 14))
    # battery/wifi icons (simple)
    draw.rectangle([(PHONE_W - 70, 18), (PHONE_W - 45, 28)], outline=(200, 200, 220, 150), width=1)

def draw_bottom_nav(draw, active_idx=0):
    y = PHONE_H - 50
    draw.rectangle([(0, y), (PHONE_W, PHONE_H)], fill=(20, 20, 55, 255))
    draw.line([(0, y), (PHONE_W, y)], fill=(255, 255, 255, 10))
    items = ["Home", "Coach", "Move", "Profile"]
    icons_code = [None, None, None, None]
    spacing = PHONE_W // 4
    for i, item in enumerate(items):
        x = spacing * i + spacing // 2
        color = PURPLE if i == active_idx else (150, 150, 170)
        icon = "●" if i == active_idx else "○"
        draw.text((x - len(icon) * 7, y + 6), icon, fill=color, font=small_font)
        draw.text((x - len(item) * 5, y + 24), item, fill=color, font=ImageFont.truetype(os.path.join(font_dir, "segoeui.ttf"), 11))

# ---------- SCREENSHOT 1: Dashboard ----------
img = Image.new('RGBA', (PHONE_W, PHONE_H), (15, 15, 46, 255))
draw = ImageDraw.Draw(img)
draw_phone_bg(draw)
draw_status_bar(draw)

# Header
draw.text((20, 60), "Good morning, George!", fill=WHITE, font=header_font)
draw.text((20, 95), "Let's make today great", fill=TEXT_SECONDARY, font=body_font)

# Stats row
for i, (label, val) in enumerate([("Steps", "4,230"), ("Calories", "312"), ("Mindful", "12m")]):
    x = 20 + i * 175
    round_rect(draw, (x, 130, x + 165, 195), 16, fill=(255, 255, 255, 12))
    draw.text((x + 15, 140), label, fill=TEXT_SECONDARY, font=small_font)
    draw.text((x + 15, 160), val, fill=CYAN, font=title_font)

# "Today's Inspiration" card
round_rect(draw, (20, 215, PHONE_W - 20, 290), 16, fill=(PURPLE[0], PURPLE[1], PURPLE[2], 40))
draw.text((35, 230), "\u2728 Daily Inspiration", fill=GOLD, font=badge_font)
draw.text((35, 255), '"Your body is your ally, not your enemy."', fill=WHITE, font=ImageFont.truetype(os.path.join(font_dir, "segoeui.ttf"), 16))

# Recent activity
draw.text((20, 310), "Recent Activity", fill=WHITE, font=badge_font)
for i, (icon, title, sub) in enumerate([
    ("\U0001F3C3", "Morning Walk", "20 min \u00b7 1,200 steps"),
    ("\U0001F9D8", "Mindful Breathing", "5 min \u00b7 Relaxation"),
    ("\U0001F34E", "Apple + Peanut Butter", "Snack logged"),
]):
    y = 340 + i * 65
    round_rect(draw, (20, y, PHONE_W - 20, y + 55), 14, fill=(255, 255, 255, 8))
    draw.text((35, y + 8), icon, fill=WHITE, font=ImageFont.truetype(os.path.join(font_dir, "seguiemj.ttf"), 24) if os.path.exists(os.path.join(font_dir, "seguiemj.ttf")) else body_font)
    draw.text((75, y + 6), title, fill=WHITE, font=body_font)
    draw.text((75, y + 30), sub, fill=TEXT_SECONDARY, font=small_font)

draw_bottom_nav(draw, 0)
img.save(os.path.join(out_dir, "screenshot_01_dashboard.png"))
print("Saved screenshot_01_dashboard.png")

# ---------- SCREENSHOT 2: AI Coach ----------
img2 = Image.new('RGBA', (PHONE_W, PHONE_H), (15, 15, 46, 255))
draw2 = ImageDraw.Draw(img2)
draw_phone_bg(draw2)
draw_status_bar(draw2)

# Coach header
round_rect(draw2, (20, 55, PHONE_W - 20, 100), 14, fill=(PURPLE[0], PURPLE[1], PURPLE[2], 30))
draw2.text((35, 65), "AI Coach", fill=WHITE, font=header_font)
draw2.text((35, 92), "DeepSeek V4 \u00b7 Connected", fill=CYAN, font=small_font)

# Chat bubbles
# Bot bubble
round_rect(draw2, (20, 125, 360, 190), 16, fill=(255, 255, 255, 12))
draw2.text((35, 135), "Hi George! \U0001F44B Great to see you.", fill=WHITE, font=body_font)
draw2.text((35, 160), "How are you feeling today?", fill=WHITE, font=body_font)

# User bubble
round_rect(draw2, (200, 210, PHONE_W - 20, 270), 16, fill=(PURPLE[0], PURPLE[1], PURPLE[2], 180))
draw2.text((215, 220), "I'm feeling a bit", fill=WHITE, font=body_font)
draw2.text((215, 245), "overwhelmed today", fill=WHITE, font=body_font)

# Bot response
round_rect(draw2, (20, 290, 400, 380), 16, fill=(255, 255, 255, 12))
draw2.text((35, 298), "That's completely okay \u2764\ufe0f", fill=WHITE, font=body_font)
draw2.text((35, 322), "Let's take it one breath at a", fill=WHITE, font=body_font)
draw2.text((35, 346), "time. What feels most", fill=WHITE, font=body_font)
draw2.text((35, 370), "manageable right now?", fill=WHITE, font=body_font)

# Quick prompts
draw2.text((20, 405), "Try asking:", fill=TEXT_SECONDARY, font=small_font)
prompts = ["I need motivation", "Suggest a movement", "Help with food"]
for i, p in enumerate(prompts):
    x = 20 + i * 178
    round_rect(draw2, (x, 430, x + 168, 465), 20, fill=(255, 255, 255, 10))
    draw2.text((x + 15, 440), p, fill=WHITE, font=small_font)

# Input bar
round_rect(draw2, (20, PHONE_H - 100, PHONE_W - 70, PHONE_H - 60), 24, fill=(255, 255, 255, 12))
draw2.text((35, PHONE_H - 88), "Ask me anything...", fill=TEXT_SECONDARY, font=body_font)
# Send button
draw2.ellipse([PHONE_W - 55, PHONE_H - 100, PHONE_W - 20, PHONE_H - 60], fill=(PURPLE[0], PURPLE[1], PURPLE[2], 200))

draw_bottom_nav(draw2, 1)
img2.save(os.path.join(out_dir, "screenshot_02_ai_coach.png"))
print("Saved screenshot_02_ai_coach.png")

# ---------- SCREENSHOT 3: Movement Library ----------
img3 = Image.new('RGBA', (PHONE_W, PHONE_H), (15, 15, 46, 255))
draw3 = ImageDraw.Draw(img3)
draw_phone_bg(draw3)
draw_status_bar(draw3)

draw3.text((20, 60), "Movement Library", fill=WHITE, font=header_font)

# Tab bar
tabs = ["Seated", "Low Impact", "Joyful"]
for i, t in enumerate(tabs):
    x = 20 + i * 175
    col = PURPLE if i == 0 else TEXT_SECONDARY
    draw3.text((x + 20, 100), t, fill=col, font=body_font)
    if i == 0:
        draw3.rectangle([(x, 128), (x + 140, 131)], fill=PURPLE)

# Video cards
videos = [
    ("Seated Leg Lifts", "1 min", PURPLE),
    ("Seated Torso Twist", "2 min", CORAL),
    ("Seated Arm Circles", "3 min", CYAN),
    ("Seated Forward Fold", "4 min", GOLD),
    ("Body Scan Relaxation", "10 min", GREEN),
]
for i, (name, dur, accent) in enumerate(videos):
    y = 145 + i * 105
    round_rect(draw3, (20, y, PHONE_W - 20, y + 92), 16, fill=(255, 255, 255, 8))
    # Play button
    draw3.ellipse([(35, y + 20), (65, y + 50)], fill=accent)
    draw3.polygon([(45, y + 28), (45, y + 42), (58, y + 35)], fill=WHITE)
    # Text
    draw3.text((85, y + 18), name, fill=WHITE, font=body_font)
    draw3.text((85, y + 48), f"{dur} \u00b7 {accent[0]},{accent[1]},{accent[2]}", fill=TEXT_SECONDARY, font=small_font)
    # Duration tag
    round_rect(draw3, (PHONE_W - 90, y + 15, PHONE_W - 30, y + 38), 12, fill=(accent[0], accent[1], accent[2], 60))
    draw3.text((PHONE_W - 80, y + 20), dur, fill=WHITE, font=small_font)

draw_bottom_nav(draw3, 2)
img3.save(os.path.join(out_dir, "screenshot_03_movement.png"))
print("Saved screenshot_03_movement.png")

# ---------- SCREENSHOT 4: Journal ----------
img4 = Image.new('RGBA', (PHONE_W, PHONE_H), (15, 15, 46, 255))
draw4 = ImageDraw.Draw(img4)
draw_phone_bg(draw4)
draw_status_bar(draw4)

draw4.text((20, 60), "Journal", fill=WHITE, font=header_font)

# Journal prompt card
round_rect(draw4, (20, 95, PHONE_W - 20, 195), 20, fill=(PURPLE[0], PURPLE[1], PURPLE[2], 40))
draw4.text((35, 110), "\U0001F4AD Today's Prompt", fill=GOLD, font=badge_font)
draw4.text((35, 140), '"What made you smile today,', fill=WHITE, font=body_font)
draw4.text((35, 165), 'even just a little?"', fill=WHITE, font=body_font)

# Journal entries
entries = [
    ("Feeling grateful", "Today I walked for 15 minutes without...", "2h ago"),
    ("Mindful moment", "Took 5 deep breaths this morning...", "Yesterday"),
    ("Small win", "Chose water instead of soda at lunch!", "Yesterday"),
]
for i, (title, preview, time) in enumerate(entries):
    y = 215 + i * 95
    round_rect(draw4, (20, y, PHONE_W - 20, y + 80), 14, fill=(255, 255, 255, 8))
    draw4.text((35, y + 12), title, fill=WHITE, font=badge_font)
    draw4.text((35, y + 36), preview, fill=TEXT_SECONDARY, font=small_font)
    draw4.text((35, y + 58), time, fill=(150, 150, 170), font=ImageFont.truetype(os.path.join(font_dir, "segoeui.ttf"), 12))

# New entry button
round_rect(draw4, (140, PHONE_H - 130, PHONE_W - 140, PHONE_H - 85), 24, fill=CORAL)
draw4.text((PHONE_W // 2 - 35, PHONE_H - 118), "+ New Entry", fill=WHITE, font=badge_font)

draw_bottom_nav(draw4, 0)
img4.save(os.path.join(out_dir, "screenshot_04_journal.png"))
print("Saved screenshot_04_journal.png")

# ---------- SCREENSHOT 5: Nourish ----------
img5 = Image.new('RGBA', (PHONE_W, PHONE_H), (15, 15, 46, 255))
draw5 = ImageDraw.Draw(img5)
draw_phone_bg(draw5)
draw_status_bar(draw5)

draw5.text((20, 60), "Nourish Log", fill=WHITE, font=header_font)
draw5.text((20, 95), "No judgment. Just awareness.", fill=TEXT_SECONDARY, font=body_font)

# Meal cards
meals = [
    ("\U0001F953 Breakfast", "Oatmeal with berries \u00b7 320 cal", "8:30 AM", CORAL),
    ("\U0001F34B Lunch", "Grilled chicken salad \u00b7 450 cal", "12:15 PM", GOLD),
    ("\U0001F372 Dinner", "Salmon with roasted veggies \u00b7 520 cal", "7:00 PM", PURPLE),
]
for i, (icon, desc, time, accent) in enumerate(meals):
    y = 120 + i * 90
    round_rect(draw5, (20, y, PHONE_W - 20, y + 75), 14, fill=(255, 255, 255, 8))
    draw5.text((30, y + 12), icon, fill=WHITE, font=ImageFont.truetype(os.path.join(font_dir, "seguiemj.ttf"), 28) if os.path.exists(os.path.join(font_dir, "seguiemj.ttf")) else body_font)
    draw5.text((80, y + 10), desc, fill=WHITE, font=body_font)
    draw5.text((80, y + 35), time, fill=TEXT_SECONDARY, font=small_font)
    round_rect(draw5, (PHONE_W - 100, y + 12, PHONE_W - 30, y + 32), 10, fill=(accent[0], accent[1], accent[2], 50))
    draw5.text((PHONE_W - 90, y + 15), "Logged", fill=accent, font=small_font)

# Water tracker
round_rect(draw5, (20, 395, PHONE_W - 20, 455), 16, fill=(CYAN[0], CYAN[1], CYAN[2], 25))
draw5.text((35, 408), "\U0001F4A7 Water: 4 of 8 glasses", fill=WHITE, font=body_font)
# Water progress
for i in range(4):
    draw5.rectangle([(35 + i * 55, 435), (80 + i * 55, 445)], fill=(CYAN[0], CYAN[1], CYAN[2], 80))

# Log meal button
round_rect(draw5, (140, PHONE_H - 130, PHONE_W - 140, PHONE_H - 85), 24, fill=(PURPLE[0], PURPLE[1], PURPLE[2], 200))
draw5.text((PHONE_W // 2 - 45, PHONE_H - 118), "+ Log Meal", fill=WHITE, font=badge_font)

draw_bottom_nav(draw5, 0)
img5.save(os.path.join(out_dir, "screenshot_05_nourish.png"))
print("Saved screenshot_05_nourish.png")

# ---------- SCREENSHOT 6: SOS / Grounding ----------
img6 = Image.new('RGBA', (PHONE_W, PHONE_H), (15, 15, 46, 255))
draw6 = ImageDraw.Draw(img6)
draw_phone_bg(draw6)
draw_status_bar(draw6)

draw6.text((20, 60), "Grounding Tools", fill=WHITE, font=header_font)
draw6.text((20, 95), "Pause. Breathe. Reset.", fill=TEXT_SECONDARY, font=body_font)

# SOS breathing circle
cx, cy = PHONE_W // 2, 310
for r in range(120, 0, -15):
    alpha = 80 - r
    draw6.ellipse([cx - r, cy - r, cx + r, cy + r], 
                  outline=(PURPLE[0], PURPLE[1], PURPLE[2], max(30, alpha)), width=2)

draw6.ellipse([cx - 12, cy - 12, cx + 12, cy + 12], fill=(PURPLE[0], PURPLE[1], PURPLE[2], 150))
draw6.text((cx - 30, cy - 7), "Breathe", fill=WHITE, font=body_font)

# Grounding techniques
techniques = [
    ("\U0001F33F 5-4-3-2-1", "See 5, touch 4, hear 3..."),
    ("\U0001F30A Deep Breathing", "Inhale 4, hold 4, exhale 6"),
    ("\U0001F3AF Body Scan", "Notice each part gently"),
]
for i, (name, sub) in enumerate(techniques):
    y = 400 + i * 80
    round_rect(draw6, (20, y, PHONE_W - 20, y + 65), 14, fill=(255, 255, 255, 8))
    draw6.text((35, y + 12), name, fill=WHITE, font=badge_font)
    draw6.text((35, y + 36), sub, fill=TEXT_SECONDARY, font=small_font)

draw_bottom_nav(draw6, 0)
img6.save(os.path.join(out_dir, "screenshot_06_grounding.png"))
print("Saved screenshot_06_grounding.png")

print("\nAll 6 screenshots generated!")
