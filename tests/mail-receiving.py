#!/usr/bin/env python3

import email.message
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

    def assertMailboxContains(self, *args, **kwds):
        time.sleep(1)
        self.assertTrue(self.mailbox.contains_all(*args, **kwds))

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

    def test_auth_not_possible_on_port_25(self):
        """Tests that the AUTH feature is not provided for normal SMTP"""
        params = SMTPParameters()
        with SMTPTester(params) as smtp:
            smtp.ehlo()
            smtp.starttls()
            self.assertFalse(smtp.authenticate())

    def test_submission_receiving(self):
        """Tests that the server accepts mail via submission"""
        params = SMTPParameters()
        params.port = 587
        params.authenticate = True
        with SMTPTester(params) as smtp:
            smtp.send()
            self.assertMailboxContains(smtp.messages)

    def test_submission_auth_requires_tls(self):
        """Tests that the AUTH feature is not provided for normal SMTP"""
        params = SMTPParameters()
        params.port = 587
        with SMTPTester(params) as smtp:
            smtp.ehlo()
            smtp.starttls()
            self.assertTrue(smtp.authenticate())
        with SMTPTester(params) as smtp:
            smtp.ehlo()
            self.assertFalse(smtp.authenticate())

    def test_virtual_aliases(self):
        """Test that virtual domain aliases are working"""
        msggen = TestMessageGenerator(recipient="john@eggs.test")
        params = SMTPParameters()
        with SMTPTester(params, message_generator=msggen) as smtp:
            smtp.send()
            self.assertMailboxContains(smtp.messages)

    def test_spamassassin_spam_recognition(self):
        """Test that spamassassin correctly marks spam mails"""
        def is_marked_as_spam(msg):
            spamflag = msg["X-Spam-Flag"]
            return spamflag == "YES"
        msggen = TestMessageGenerator(gtube=True)
        params = SMTPParameters()
        with SMTPTester(params, message_generator=msggen) as smtp:
            smtp.send()
            self.assertMailboxContains(
                smtp.messages,
                additional_test=is_marked_as_spam
            )

if __name__ == '__main__':
    unittest.main()
