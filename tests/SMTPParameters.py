#!/usr/bin/env python3

import smtplib
import ssl

class SMTPParameters:
    """Parameters to be used in a SMTP connection."""

    def __init__(self):
        self.debug_level = 0
        self.local_hostname = None
        self.port = 25
        self.host = "mail.test"
        self.enable_starttls = True
        self.force_starttls = False
        self.authenticate = False
        self.user = "vagrant"
        self.password = "vagrant"

    def create_connection(self):
        """Creates a connection using these parameters."""
        conn = smtplib.SMTP(self.host, self.port, self.local_hostname)
        conn.set_debuglevel(self.debug_level)
        return conn

    def create_ssl_context(self):
        ctx = ssl.SSLContext(ssl.PROTOCOL_TLSv1)
        ctx.check_hostname = False
        ctx.verify_mode = ssl.CERT_NONE
        return ctx
