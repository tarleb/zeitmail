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

Zeitmail is a tool to setup and manage mail servers. It secures the proper
installation of software packages.  It configures the services in order to
quickly and securely provision a new machine.

The design goal of zeitmail is to give system administrators all the freedom
and power required to keep them safe, secure, and happy.  If at some point you
decide that you'd rather manage the server manually or with a different tool,
there is nothing tying you to zeitmail.  We take great care to prevente any
kind of lock-in, so sysadmins are always in full control.

Users should be aware that zeitmail isn't a panacea.  Security is more than
running a single command and then forgetting about the machine.  The most
secure environments are the well-managed ones.  Zeitmail is here to offer a
very good head-start, the rest is up to you.


## Features Overview

With zeitmail, one can

  - receive and send mail with Postfix,
  - filter spam with Amavis and SpamAssassin,
  - access IMAP mailboxes with IMAP Dovecot, and
  - read mail online with Roundcube webmail.

Automatic deployment is currently limited to servers running Debian Jessie.

### Mail sending and receiving

At the heard of the system, the Postfix MTA is setup to send and receive mail.
It uses sane defaults suitable for most single-server installations and
ensures a heightened level of mail encryption in transit.  Forged mail is
detected using SPF, DKIM, and DMARC; this helps to establish the
trustworthyness of incoming mail.  Spam-clients are deflected by the
*postscreen* service, while ensuring prompt delivery of legitimate mail by
using whitelist serivces.  Mail is also scanned for spam using the fast and
flexible services Amavis and SpamAssassin; Dovecot Sieve filters mail and
keeps spam out of your inbox.  The received mail can be accessed and managed
using IMAP.

### Webmail

Roundcube running on Nginx and PostgreSQL.  The webserver is configured with a
strong focus on security.  The [SSLLabs test](https://www.ssllabs.com/ssltest/)
rates the server at *A+* if the `letsencrypt` option has been enabled.  The
webmail site receives an *A* rating on <https://securityheaders.io>.

### Security

Secure settings and strong encryption for all services.

### Virtual Mail

Virtual mail addresses can be enabled via a simple config option.  Virtual
addresses and accounts can be added and managed using entries in PostgreSQL
tables.  The underlying database schema can easily be adapted using SQL
migrations.  Migrations are performed using
[dogfish](https://github.com/dwb/dogfish).


## Installation

The recommended way to use this is to fork the directory and to start a new
branch containing all custom settings.  This allows for easy customization of
all functionalities, even when there are no configuration options build into
zeitmail.  When a new release is made available, the updated upstream branch
can simply be merged into the code base.

    # Grab the code
    git clone https://github.com/tarleb/zeitmail

    # Optional: Configure via salt pillars (YAML syntax)
    edit zeitmail/salt/pillar/zeitmail.sls
    # Optional: Load changed configs
    edit zeitmail/salt/pillar/top.sls

    # Specify details of your (soon-to-be) mail server
    edit zeitmail/salt/roster
    # Provision the server
    salt-ssh NAME-GIVEN-IN-ROSTER-FILE state.highstate

The `salt-ssh` command has to be re-run every time config changes have been
made.


## References and Acknowledgments

This project would not be possible without the many, many helpful resources
available on the net.  Great thanks to all the authors of the great software
packages used by zeitmail.  Many thanks also to authors of the following
articles, and all the others I forgot to mention here.

  - The [ISPMail tutorial](https://workaround.org/ispmail/jessie) by Christoph
    Haas is a great place to learn about mail server basics.
  - [BetterCrypto](https://bettercrypto.org) is a good starting point for
    admins seeking to harden they servers.
  - DMARC spam filter configs were inspired by an
    [article by Skelleton](https://www.skelleton.net/2015/03/21/how-to-eliminate-spam-and-protect-your-name-with-dmarc/)
  - [Postfix](https://postfix.org) has great documentation and many good
    READMEs.


## License

Zeitmail – secure mail made easy.
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
