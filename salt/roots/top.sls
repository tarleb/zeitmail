base:
  'mail*':
    - apt
    - opendkim
    - spamassassin
    - amavis
    - postfix
    - postfix.config
    - dovecot
    - roundcube
  'staging*':
    - apt
    - opendkim
    - spamassassin
    - amavis
    - postfix
    - postfix.config
    - dovecot
    - roundcube
  'testing*':
    - python3
