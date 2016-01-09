#!/usr/bin/env python3

import smtplib
import ssl
from SMTPParameters import SMTPParameters
from TestMessageGenerator import TestMessageGenerator

class SMTPTester:
    def __init__(self, params=SMTPParameters(),
                 message_generator=TestMessageGenerator()):
        self.message_generator = message_generator
        self.messages = []
        self.params = params
        self.connection = params.create_connection()

    def send(self):
        msg = self.generate_message()
        self.ehlo()
        self.starttls()
        self.authenticate()
        self.connection.send_message(msg)

    def ehlo(self):
        hostname = self.params.host
        if hostname is not None:
            self.connection.ehlo(hostname)

    def starttls(self):
        if self.use_starttls():
            ctx = self.params.create_ssl_context()
            self.connection.starttls(context=ctx)
            self.ehlo()

    def authenticate(self):
        """Trys to authenticate to the server"""
        if not self.connection.has_extn("AUTH"):
            return False
        user = self.params.user
        password = self.params.password
        self.connection.login(user, password)

    def use_starttls(self):
        return (
            (self.params.enable_starttls 
             and self.connection.has_extn("STARTTLS"))
            or self.params.force_starttls
        )

    def quit(self):
        """Closes the connection."""
        self.connection.quit()


    def generate_message(self):
        msg = self.message_generator.generate_message()
        self.messages.append(msg)
        return msg
