from PIL import Image, ImageDraw, ImageFont
import os
import csv
import zipfile

cardlist_file = "cardlist.csv"
outpath = "current_cards/"
zipped_fn = "current_cards"

# color files
red_card_fpath = "card_bases/red_base_card.png"
orange_card_fpath = "card_bases/orange_base_card.png"
yellow_card_fpath = "card_bases/yellow_base_card.png"
green_card_fpath = "card_bases/green_base_card.png"
blue_card_fpath = "card_bases/blue_base_card.png"
purple_card_fpath = "card_bases/purple_base_card.png"
gray_card_fpath = "card_bases/gray_base_card.png"

# icon files
instant_fpath = "icons/instant.png"
enchantment_fpath = "icons/enchantment.png"
curse_fpath = "icons/curse.png"
ward_fpath = "icons/ward.png"
component_fpath = "icons/knife.png"

font_fpath = "fonts/Verdana.ttf"
bold_font_fpath = "fonts/Verdana-Bold.ttf"
viner_font_fpath = "fonts/VINERITC.TTF"

# Positions
name_pos = (105, 42)
name_font = ImageFont.truetype(viner_font_fpath, 15)

cost_height = 20
activate_pos = (27, cost_height)
upkeep_pos = (183, cost_height)
cost_font = ImageFont.truetype(bold_font_fpath, 11)

tier_pos = (105, 21)
tier_font = ImageFont.truetype(bold_font_fpath, 16)

overview_pos = (105, 63)
overview_font = ImageFont.truetype(bold_font_fpath, 9)
effect_pos = (12, 185)
desc_font = ImageFont.truetype(font_fpath, 9)

def zipdir(path, ziph):
    # ziph is zipfile handle
    for root, dirs, files in os.walk(path):
        for file in files:
            ziph.write(os.path.join(root, file), 
                       os.path.relpath(os.path.join(root, file), 
                                       os.path.join(path, '..')))

def wrap_text(text, font, max_width, draw):
    """
    Wraps text to fit within the max_width.
    """
    words = text.split()
    lines = "" # Holds each line in the text box
    current_line = [] # Holds each word in the current line under evaluation.

    for word in words:
        # Check the width of the current line with the new word added
        test_line = ' '.join(current_line + [word])
        width = draw.textlength(test_line, font=font)
        if width <= max_width:
            current_line.append(word)
        else:
            # If the line is too wide, finalize the current line and start a new one
            lines += ' '.join(current_line) + '\n'
            current_line = [word]

    # Add the last line
    if current_line:
        lines += ' '.join(current_line)

    return lines

def line_wrap(text: str, font, max_width, draw):
    lines = text.splitlines()

    output = ""

    for line in lines:
        output+= wrap_text(line, font, max_width, draw) + '\n'

    return output
    

if __name__ == "__main__":

    with open(cardlist_file, newline='') as f:
        cards = csv.reader(f)
        next(cards, None)

        #load color images
        red_img: Image.Image = Image.open(red_card_fpath)
        orange_img: Image.Image = Image.open(orange_card_fpath)
        yellow_img: Image.Image = Image.open(yellow_card_fpath)
        green_img: Image.Image = Image.open(green_card_fpath)
        blue_img: Image.Image = Image.open(blue_card_fpath)
        purple_img: Image.Image = Image.open(purple_card_fpath)
        gray_img: Image.Image = Image.open(gray_card_fpath)

        icon_size = (80,80)
        #load icon images
        instant_img: Image.Image = Image.open(instant_fpath).resize(icon_size)
        enchantment_img: Image.Image = Image.open(enchantment_fpath).resize(icon_size)
        curse_img: Image.Image = Image.open(curse_fpath).resize(icon_size)
        ward_img: Image.Image = Image.open(ward_fpath).resize(icon_size)
        component_img: Image.Image = Image.open(component_fpath).resize(icon_size)

        if not os.path.exists(outpath):
            os.makedirs(outpath)
        else:
            #delete all old cards from the outpath
            for filename in os.listdir(outpath):
                file_path = os.path.join(outpath, filename)
                if os.path.isfile(file_path):
                    os.remove(file_path)


        for card in cards:
            name = card[0]
            color = card[1]
            field = card[2]
            spell_type = card[3]
            tier = card[4]
            activation_cost = card[5]
            upkeep = card[6]
            keywords = card[7]
            effect = card[8]

            spell_overview = '-- ' + color + ' (' + field + ') -- ' + spell_type + ' --'

            fn_name = name.replace(" ", "_").lower()

            #select correct color background
            match color:
                case "Red":
                    img = red_img
                case "Orange":
                    img = orange_img
                case "Yellow":
                    img = yellow_img
                case "Green":
                    img = green_img
                case "Blue":
                    img = blue_img
                case "Purple":
                    img = purple_img
                case "":
                    img = gray_img

            tier_text = ''

            #set tier text to Roman numeral
            match tier:
                case '1':
                    tier_text = "I"
                case '2':
                    tier_text = "II"
                case '3':
                    tier_text = "III"

            #set icon image correctly
            match spell_type:
                case 'Instant':
                    icon = instant_img
                case 'Enchantment':
                    icon = enchantment_img
                case 'Curse':
                    icon = curse_img
                case 'Ward':
                    icon = ward_img
                case 'Component':
                    icon = component_img

            out_img: Image.Image = img.copy()
            out_draw: ImageDraw = ImageDraw.Draw(out_img)

            out_draw.text(name_pos, name, anchor="ms", fill=(0,0,0), font=name_font) #add card name
            out_draw.text(activate_pos, activation_cost, anchor="ms", fill=(0,0,0), font=cost_font) #add activation cost
            out_draw.text(upkeep_pos, upkeep, anchor="ms", fill=(0,0,0), font=cost_font) #add upkeep

            out_draw.text(tier_pos, tier_text, anchor="ms", fill=(0,0,0), font=tier_font) #add upkeep

            out_draw.text(overview_pos, spell_overview, anchor="ms", fill=(0,0,0), font=overview_font) #add overview

            effect_lined = line_wrap(effect, desc_font, 188, out_draw) #format effect description for multiline
            out_draw.multiline_text(effect_pos, effect_lined, anchor="ls", fill=(0,0,0), font=desc_font, spacing=2) #add effect description
            
            bound_box = (65, 75, 145, 155)
            out_img.paste(icon, bound_box, icon)

            out_img.save(outpath + fn_name + ".png")

        with zipfile.ZipFile(zipped_fn + ".zip", 'w', zipfile.ZIP_DEFLATED) as zipf:
            zipdir(outpath, zipf)

        print("Card Creation Complete")