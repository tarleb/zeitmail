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
            gtube=False,
            fakeReceived=False
        ):
        self.sender = sender
        self.recipient = recipient
        self.subject = subject
        self.gtube = gtube
        self.fakeReceived=fakeReceived

    def generate_message(self):
        """Creates a new message using the current settings."""
        msg = email.message.EmailMessage()
        if self.fakeReceived:
            rcvd = "from funny.test (elite-mail.test [10.0.13.37]) by \
              testing.test (Postfix) with ESMTPS for root@mail.test; \
              Tue, 26 Jan 2016 09:36:49 +0000 (GMT)"
            msg.add_header("Received", rcvd)
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
