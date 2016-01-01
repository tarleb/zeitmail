#!/usr/bin/env python3

import smtplib
from smtplib import SMTP
from mailbox import mbox
from email.message import EmailMessage
import time

def create_test_mail(msg_id):
    recipient = "root@zeitmail.local"
    sender = "testing@example.com"
    msg = EmailMessage()
    msg.add_header("From", sender)
    msg.add_header("To", recipient)
    msg.add_header("Subject", "zeitmail test")
    msg.add_header("Message-Id", msg_id)
    msg.set_content("Hello, World!")
    return msg

def send_message(msg):
    with SMTP("zeitmail.local") as smtp:
        smtp.ehlo("tester.example.com")
        smtp.send_message(msg)
        smtp.quit()

def check_mail_delivery(mbox_path, msg_id):
    for msg in mbox(mbox_path):
        cur_msg_id = msg["Message-Id"]
        if cur_msg_id == msg_id:
            return True
        else:
            print(cur_msg_id)
    return False

def truncate_file(path):
    f = open(path, 'w')
    f.truncate()
    f.close()

def test_open_relay():
    test_msg_id2 = "open-relay.mail@exampe.zeitmail.invalid"
    msg2 = create_test_mail(test_msg_id2)
    msg2.replace_header("To", "open-relay@example.com")
    try:
        send_message(msg2)
        return False
    except smtplib.SMTPRecipientsRefused:
        return True

def test_default_mail_delivery():
    mbox_path = "./mail-mnt/test.mbox"
    test_msg_id1 = "testing.mail@example.zeitmail.invalid"
    msg1 = create_test_mail(test_msg_id1)
    truncate_file(mbox_path)
    send_message(msg1)
    time.sleep(1)
    assert(check_mail_delivery(mbox_path, test_msg_id1))

def main():
    test_default_mail_delivery()
    test_open_relay()

if __name__ == "__main__":
    main()
