#!/usr/bin/env python3

import smtplib
import ssl

class SMTPParameters:
    """Parameters to be used in a SMTP connection."""

    def __init__(
            self,
            port=25,
            host="zeitmail.local",
            enable_starttls=True,
            force_starttls=False
        ):
        self.debug_level = 0
        self.local_hostname = None
        self.port = port
        self.host = host
        self.enable_starttls = enable_starttls
        self.force_starttls = force_starttls

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
