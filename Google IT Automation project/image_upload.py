
#!/usr/bin/env python3
import requests
import os
# Upload the images using Python Request Module

url = "http://localhost/upload/"

cwd = os.getcwd()
path = os.listdir(cwd + "/images/processed_images/")
for file in path:
    if ".jpeg" in file:
        with open(file, 'rb') as opened:
            r = requests.post(url, files={'file': opened})
