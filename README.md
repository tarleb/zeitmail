> Security only works if the secure way also happens to be the easy way.
>
> – <cite>[Second Immutable Law of Security Administration](https://technet.microsoft.com/en-us/library/cc722488)</cite>

# ZeitMail

The mail system pushing the zeitgeist of secure communication.

Setting up a mail server on Linux systems is easy.  Setting up a *secure* mail
server is *hard*.  Consequently, many small sites (and some big) use weak
security settings and reduce the security of mail sent through these servers
and sometimes even of the whole system.  This project offers an easy way to
setup a feature-full mail server with good defaults and decent security.

Zeitmail is a tool to manage mail servers. It is a collection of installation
scripts and settings to quickly provision a new machine.  If at some point you
decide that you'd rather manage the server manually or with a different tool,
there is nothing tying you to zeitmail, preventing any kind of lock-in.  If
you like zeitmail and continue using it, it will help to keep you safe.

This isn't a panacea, security is more than running a single command and then
forgetting about the machine.  The most secure environments are the
well-managed ones.  Zeitmail is here to offer a very good head-start, the rest
is up to you.


## Features

With zeitmail, one can

  - receive and send mail with Postfix,
  - filter spam with Amavis and SpamAssassin,
  - access IMAP mailboxes with IMAP Dovecot, and
  - read mail online with Roundcube webmail.

Automatic deployment is currently limited to servers running Debian Jessie.

### Mail sending and receiving

Postfix with sane defaults and decent encryption.  Checker for SPF, DKIM, and
DMARC policies help to determine the trustworthyness of mail; Amavis and
SpamAssassin help to mark spam; Dovecot Sieve makes it easy to filter on mail.
IMAP mailboxes via Dovecot.

### Webmail

Roundcube running on Nginx and PostgreSQL.

### Security

Secure settings and strong encryption for all services.


## Installation

The recommended way to use this is to fork the directory and to start a new
branch containing all custom settings.  This allows for easy customization of
all functionalities, even when there are no configuration options build into
zeitmail.  When a new release is made available, the updated upstream branch
can simply be merged into the code base.

    # Grab the code
    git clone https://github.com/tarleb/zeitmail

    # Use default config as starting point
    cd zeitmail
    cp salt/pillar/zeitmail-defaults.sls salt/pillar/zeitmail.sls

    # Update settings
    edit zeitmail/salt/pillar/zeitmail.sls
    edit zeitmail/salt/roster

    # Provision the server
    salt-ssh name-given-in-roster-file state.highstate

The `salt-ssh` command has to be run every config changes have been made.


## References and Acknowledgments

This project would not be possible without the many, many helpful resources
available on the net.  Great thanks to the authors of the following articles,
and all the others I haven't mentioned.

  - The [ISPMail tutorial](https://workaround.org/ispmail/jessie) by Christoph
    Haas is a great place to learn about mail server basics.
  - [BetterCrypto](https://bettercrypto.org) is a good starting point for
    admins seeking to harden they servers.
  - DMARC spam filter configs were inspired by an
    [article by Skelleton](https://www.skelleton.net/2015/03/21/how-to-eliminate-spam-and-protect-your-name-with-dmarc/)
  - [Postfix](https://postfix.org) has great documentation and many good
    READMEs.


## License

ZeITMail – secure mail made easy.
Copyright (C) 2016  Albert Krewinkel

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
