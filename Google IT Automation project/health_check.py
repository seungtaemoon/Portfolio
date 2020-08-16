#!/usr/bin/env python3

import psutil
import emails
import socket
import time, threading

# Generates and sends an email based on a number of monitoring conditions
# If any of the conditions is met, a message with the relevant error information is sent out as an email to the recipient
# If no condition is met, it means the system is healthy and therefore no email is sent out
# Executes the entire checking process for every 1 minute

def main():
    print(time.ctime())

    # sending email
    sender = "automation@example.com"
    recipient = "username@example.com"

    # if CPU usage over 80%:
    case_1 = psutil.cpu_percent()
    print(case_1)
    if case_1 > 80:
        subject = "Error - CPU usage is over 80%"
        body = "Please check your system and resolve the issue as soon as possible."
        message = emails.generate_error(sender=sender, recipient=recipient, subject=subject, body=body)
        print(message)
        emails.send_email(message=message)

    # if available disk space < 20%
    case_2 = psutil.virtual_memory().available * 100 / psutil.virtual_memory().total
    print(case_2)
    if case_2 < 20:
        subject = "Error - Available disk space is less than 20%"
        body = "Please check your system and resolve the issue as soon as possible."
        message = emails.generate_error(sender=sender, recipient=recipient, subject=subject, body=body)
        print(message)
        emails.send_email(message=message)

    # if available memory < 500MB
    case_3 = psutil.virtual_memory().available
    print(case_3)
    if case_3 < 500:
        subject = "Error - Available memory is less than 500MB"
        body = "Please check your system and resolve the issue as soon as possible."
        message = emails.generate_error(sender=sender, recipient=recipient, subject=subject, body=body)
        print(message)
        emails.send_email(message=message)

    # if hostname "localhost" != "127.0.0.1"
    case_4 = socket.gethostbyname('localhost')
    print(case_4)
    if case_4 != "127.0.0.1":
        subject = "Error - localhost cannot be resolved to 127.0.0.1"
        body = "Please check your system and resolve the issue as soon as possible."
        message = emails.generate_error(sender=sender, recipient=recipient, subject=subject, body=body)
        print(message)
        emails.send_email(message=message)

    threading.Timer(60, main).start()

if __name__ == "__main__":
    main()
