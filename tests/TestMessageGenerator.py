#!/usr/bin/env python3

import email.message
import uuid

class TestMessageGenerator:
    def __init__(
            self,
            sender="sender@testing.test",
            recipient="root@mail.test",
            subject="zeitmail test"
        ):
        self.sender = sender
        self.recipient = recipient
        self.subject = subject

    def generate_message(self):
        """Creates a new message using the current settings."""
        msg = email.message.EmailMessage()
        msg["From"] = self.sender
        msg["To"] = self.recipient
        msg["Subject"] = "zeitmail test"
        msg["Message-Id"] = self.generate_message_id()
        msg.set_content("Hello! This is a test message.")
        return msg

    def generate_message_id(self):
        return ("%s@testing.test" % uuid.uuid4())
