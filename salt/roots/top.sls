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
    - letsencrypt
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
    - letsencrypt
  'testing*':
    - python3
