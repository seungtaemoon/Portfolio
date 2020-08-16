#! /usr/bin/env python3

import os
import requests
import json

# Upload the descriptions of the items to a specified URL
def main():
    texts = []
    dict_list = []
    dict = {}
    cwd = os.getcwd()
    path = os.listdir(cwd + "/descriptions/")
    path = sorted(path)
    print(path)
    for file in path:
        if ".txt" in file:
            infile = open(file, "rb")
            if infile.mode == "rb":
                outfile = infile.readlines()
                infile.close()
                for i in outfile:
                    string_outfile = i.decode("UTF-8-sig", errors="strict")
                    string_list = string_outfile.strip().split("\n")
                    texts.append("".join(string_list))
            for i in range(0, len(texts), 3):
                filename = file.replace(".txt", ".jpeg")
                dict = {"name": texts[i], "weight": int(texts[i+1].strip("lbs")), "description": texts[i+2], "image_name": filename}
            dict_list.append(dict)

    print(texts)
    print(dict_list)


#  use requests module to post the dictionary to the company website
# (use request.post() to make a POST request to http://<corpweb-external-IP>/feedback.)
    for i in dict_list:
        result_json = json.dumps(i, indent=2)
        print(result_json)
        url = "http://34.121.16.255/fruits/"
        headers = {'Content-type': 'application/json', 'Accept': 'application/json'}
        response = requests.post(url, data=result_json, headers = headers)
        response_body = response.request.body
        response_url = response.request.url
        print(response_url)

# print status_code and text of the response objects
# (use status_code 201) to see if the request is successful
        print(response.status_code)
        if response.ok:
            print("The POST method was successful")
        else:
            print("The POST method was NOT successful", response.raise_for_status())

if __name__ == "__main__":
    main()




