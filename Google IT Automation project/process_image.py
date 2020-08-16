#!/usr/bin/env python3

from PIL import Image
import os

# Processes raw images to JPEG format
cwd = os.getcwd()
path = os.listdir(cwd + "/images/raw_images/")
for file in path:
    if ".tiff" in file:
        im = Image.open(file)
        file_name = im.filename
        im = im.convert("RGB")
        im = im.resize((600, 400))
        new_image = im.save(cwd + "/images/processed_images/" +  "pictures" + file_name.replace(".tiff", ".jpeg"))
    else:
        pass





