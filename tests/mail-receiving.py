#!/usr/bin/env python3 

import smtplib
import time
import unittest
from SMTPTester import SMTPTester
from SMTPParameters import SMTPParameters
from TesterMailbox import TesterMailbox
from TestMessageGenerator import TestMessageGenerator

class TestSMTP(unittest.TestCase):
    
    def test_normal_mail_receiving(self):
        """Checks if normal, unencrypted mail delivery is possible"""
        mailbox = TesterMailbox()
        params = SMTPParameters()
        params.enable_starttls = False
        tester = SMTPTester(params)
        tester.send()
        tester.quit()
        time.sleep(2)
        self.assertTrue(mailbox.contains_all(tester.messages))
        mailbox.close()

    def test_for_open_relay(self):
        """Verifies that the server isn't an open-relay"""
        msggen = TestMessageGenerator(recipient="open-relay@not-our-server.test")
        smtp = SMTPTester(message_generator=msggen)
        with self.assertRaises(smtplib.SMTPRecipientsRefused):
          smtp.send()
        smtp.quit()

    def test_receiving_via_starttls(self):
        """Checks if the server can receive Mail via STARTTLS"""
        mailbox = TesterMailbox()
        params = SMTPParameters()
        params.force_starttls = True
        tester = SMTPTester(params)
        tester.send()
        tester.quit()
        time.sleep(1)
        self.assertTrue(mailbox.contains_all(tester.messages))
        mailbox.close()

    def test_submission_receiving(self):
        """Tests that the server accepts mail via submission"""
        mailbox = TesterMailbox()
        params = SMTPParameters()
        params.port = 587
        params.authenticate = True
        tester = SMTPTester(params)
        tester.send()
        tester.quit()
        time.sleep(1)
        self.assertTrue(mailbox.contains_all(tester.messages))
        mailbox.close()

if __name__ == '__main__':
    unittest.main()
