#!/usr/bin/env python3

import mailbox
import smtplib
import ssl
from email.message import EmailMessage
import time

class SMTPParameters:
    def __init__(self):
        self.debug_level = 0
        self.helo_name = 'tester.example.com'
        self.host = 'zeitmail.local'
        self.use_starttls = False
        self.force_starttls = False

    def create_connection(self):
        """Creates a connection using these parameters."""
        conn = smtplib.SMTP(self.host)
        conn.set_debuglevel(self.debug_level)
        if self.helo_name is not None:
            conn.ehlo(self.helo_name)
        if self.use_starttls and (conn.has_extn("STARTTLS") or self.force_starttls):
            conn.starttls(context=self.create_insecure_ssl_context())
            conn.ehlo(self.helo_name)
        return conn

    def create_insecure_ssl_context(self):
        ctx = ssl.SSLContext(ssl.PROTOCOL_TLSv1)
        ctx.check_hostname = False
        ctx.verify_mode = ssl.CERT_NONE
        return ctx

class LocalMailbox:
    def __init__(self, path, reset = True):
        self.path = path
        if reset:
            self.reset()

    def reset(self):
        f = open(self.path, 'w')
        f.truncate()
        f.close()

    def mailbox(self):
        return mailbox.mbox(self.path)

def get_test_mailbox():
    return LocalMailbox("./mail-mnt/test.mbox")

def send_message_with_params(msg, smtp_params):
    """Send a message using specific SMTP parameters."""
    with smtp_params.create_connection() as smtp:
        smtp.send_message(msg)
        smtp.quit()

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
    params = SMTPParameters()
    #params.debug_level = 1
    params.host = "zeitmail.local"
    send_message_with_params(msg, params)

def check_mail_delivery(local_mailbox, msg_id):
    for msg in local_mailbox.mailbox():
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
    mb = get_test_mailbox()
    test_msg_id1 = "testing.mail@example.zeitmail.invalid"
    msg1 = create_test_mail(test_msg_id1)
    send_message(msg1)
    time.sleep(1)
    assert(check_mail_delivery(mb, test_msg_id1))

def test_starttls_mail_delivery():
    mb = get_test_mailbox()
    test_msg_id = "testing.mail@example.zeitmail.invalid"
    msg = create_test_mail(test_msg_id)
    smtp_params = SMTPParameters()
    smtp_params.use_starttls = True
    smtp_params.force_starttls = True
    smtp_params.debug_level = 1
    send_message_with_params(msg, smtp_params)
    time.sleep(2)
    assert(check_mail_delivery(mb, test_msg_id))

def main():
    test_default_mail_delivery()
    test_open_relay()
    test_starttls_mail_delivery()

if __name__ == "__main__":
    main()
