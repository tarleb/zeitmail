base:
  'mail*':
    - apt
    - opendkim
    - opendmarc
    - spamassassin
    - amavis
    - postfix-policyd-spf
    - postfix
    - postfix.config
    - dovecot
    - roundcube
  'staging*':
    - apt
    - opendkim
    - opendmarc
    - spamassassin
    - amavis
    - postfix-policyd-spf
    - postfix
    - postfix.config
    - dovecot
    - roundcube
  'testing*':
    - python3
