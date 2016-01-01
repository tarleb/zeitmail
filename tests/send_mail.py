#!/usr/bin/env python3

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

def test_mail_sending(msg_id = "testing.mail@example.zeitmail.invalid"):
    msg = create_test_mail(msg_id)
    with SMTP("zeitmail.local") as smtp:
        smtp.ehlo("tester.example.com")
        smtp.send_message(msg)
        smtp.quit()
    return msg_id

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

def main():
    mbox_path = "./mail-mnt/test.mbox"
    truncate_file(mbox_path)
    test_msg_id = test_mail_sending()
    time.sleep(1)
    assert(check_mail_delivery(mbox_path, test_msg_id))

if __name__ == "__main__":
    main()
