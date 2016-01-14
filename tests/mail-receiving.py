#!/usr/bin/env python3 

import smtplib
import time
import unittest
from SMTPTester import SMTPTester
from SMTPParameters import SMTPParameters
from TesterMailbox import TesterMailbox
from TestMessageGenerator import TestMessageGenerator

class TestSMTP(unittest.TestCase):

    def setUp(self):
        self.mailbox = TesterMailbox()

    def tearDown(self):
        self.mailbox.close()

    def assertMailboxContains(self, messages):
        time.sleep(1)
        self.assertTrue(self.mailbox.contains_all(messages))
    
    def test_normal_mail_receiving(self):
        """Checks if normal, unencrypted mail delivery is possible"""
        params = SMTPParameters()
        params.enable_starttls = False
        with SMTPTester(params) as smtp:
            smtp.send()
            self.assertMailboxContains(smtp.messages)

    def test_for_open_relay(self):
        """Verifies that the server isn't an open-relay"""
        msggen = TestMessageGenerator(recipient="open-relay@not-our-server.test")
        with SMTPTester(message_generator=msggen) as smtp:
            with self.assertRaises(smtplib.SMTPRecipientsRefused):
                smtp.send()

    def test_receiving_via_starttls(self):
        """Checks if the server can receive Mail via STARTTLS"""
        params = SMTPParameters()
        params.force_starttls = True
        with SMTPTester(params) as smtp:
            smtp.send()
            self.assertMailboxContains(smtp.messages)

    def test_submission_receiving(self):
        """Tests that the server accepts mail via submission"""
        params = SMTPParameters()
        params.port = 587
        params.authenticate = True
        with SMTPTester(params) as smtp:
            smtp.send()
            self.assertMailboxContains(smtp.messages)

if __name__ == '__main__':
    unittest.main()
