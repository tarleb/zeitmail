base:
  'mail*':
    - apt
    - spamassassin
    - amavis
    - postfix
    - postfix.config
    - dovecot
    - roundcube
  'staging*':
    - apt
    - spamassassin
    - amavis
    - postfix
    - postfix.config
    - dovecot
    - roundcube
  'testing*':
    - python3
