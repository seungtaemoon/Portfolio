#!/usr/bin/env python3

import reports
import emails
import os
from datetime import date

# Generates a report using "reports.py" module and sends it via email using "emails.py" module

def main():
        texts = []
        dict_list = []
        dict = {}
        data_list = []
        cwd = os.getcwd()
        path = os.listdir(cwd)
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
                    dict = {"name": texts[i], "weight": int(texts[i + 1].strip("lbs"))}
                dict_list.append(dict)
        print(texts)
        print(dict_list)

        for i in dict_list:
            this_list = ["\nname: " + i["name"] + "\nweight: " + str(i["weight"]) + " lbs"]
            data_list.append(this_list)

        print(data_list)
        return data_list


if __name__ == "__main__":

    # generating report
    cwd = os.getcwd()
    attachment = cwd + "/processed.pdf"
    today = date.today()
    today = today.strftime("%B %d, %Y")
    title = "Processed Update on " + str(today)
    paragraph = main()
    reports.generate_report(attachment=attachment, title=title, paragraph=paragraph)

    # sending email
    sender = "automation@example.com"
    recipient = "username@example.com"
    subject = "Upload Completed - Online Fruit Store"
    body = "All fruits are uploaded to our website successfully. A detailed list is attached to this email."
    attachment_path = cwd + "/processed.pdf"
    message = emails.generate_email(sender=sender, recipient=recipient, subject= subject, body=body, attachment_path=attachment_path)
    print(message)
    emails.send_email(message=message)