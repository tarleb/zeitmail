#!/usr/bin/env python3 

import smtplib
import time
from SMTPTester import SMTPTester
from SMTPParameters import SMTPParameters
from TesterMailbox import TesterMailbox
from TestMessageGenerator import TestMessageGenerator

def test_for_open_relay():
    """Verifies that the server isn't an open-relay"""
    msggen = TestMessageGenerator(recipient="open-relay@testing.zeitmail.net")
    smtp = SMTPTester(message_generator=msggen)
    try:
        smtp.send()
        tester.quit()
        return False
    except smtplib.SMTPRecipientsRefused:
        return True
    
def test_normal_mail_receiving():
    """Checks if normal, unencrypted mail delivery is possible"""
    mailbox = TesterMailbox()
    params = SMTPParameters()
    params.enable_starttls = False
    tester = SMTPTester(params)
    tester.send()
    tester.quit()
    time.sleep(1)
    assert(mailbox.contains_all(tester.messages))

def test_receiving_via_starttls():
    """Checks if the server can receive Mail via STARTTLS"""
    mailbox = TesterMailbox()
    params = SMTPParameters()
    params.force_starttls = True
    tester = SMTPTester(params)
    tester.send()
    tester.quit()
    time.sleep(1)
    assert(mailbox.contains_all(tester.messages))

def test_submission_receiving():
    """Tests that the server accepts mail via submission"""
    mailbox = TesterMailbox()
    params = SMTPParameters()
    params.port = 587
    params.authenticate = True
    tester = SMTPTester(params)
    tester.send()
    tester.quit()
    time.sleep(1)
    assert(mailbox.contains_all(tester.messages))

def main():
    """Executes all tests for mail receiving."""
    test_normal_mail_receiving()
    test_for_open_relay()
    test_receiving_via_starttls()
    test_submission_receiving()

if __name__ == '__main__':
    main()
