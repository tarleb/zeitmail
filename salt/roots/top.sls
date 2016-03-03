base:
  'mail*':
    - apt
    - opendkim
    - spamassassin
    - amavis
    - postfix
    - postfix.config
    - postfix-policyd-spf
    - dovecot
    - roundcube
  'staging*':
    - apt
    - opendkim
    - spamassassin
    - amavis
    - postfix
    - postfix.config
    - postfix-policyd-spf
    - dovecot
    - roundcube
  'testing*':
    - python3
