#!/usr/bin/env python3

import datetime
import email.message
import uuid

class TestMessageGenerator:

    def __init__(
            self,
            sender="sender@testing.test",
            recipient="root@mail.test",
            subject="zeitmail test",
            gtube=False
        ):
        self.sender = sender
        self.recipient = recipient
        self.subject = subject
        self.gtube = gtube

    def generate_message(self):
        """Creates a new message using the current settings."""
        msg = email.message.EmailMessage()
        msg["From"] = self.sender
        msg["To"] = self.recipient
        msg["Subject"] = "zeitmail test"
        msg["Date"] = datetime.datetime.utcnow()
        msg["Message-ID"] = "<%s>" % self.generate_message_id()
        if self.gtube:
            msg.set_content("XJS*C4JDBQADN1.NSBN3*2IDNEN*GTUBE-STANDARD-ANTI-UBE-TEST-EMAIL*C.34X")
        else:
            msg.set_content("Hello! This is a test message.")
        return msg

    def generate_message_id(self):
        return ("%s@testing.test" % uuid.uuid4())
