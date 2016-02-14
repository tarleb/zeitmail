base:
  'mail*':
    - apt
    - spamassassin
    - amavis
    - postfix
    - postfix.config
    - dovecot
    - nginx
    - roundcube
  'staging*':
    - apt
    - spamassassin
    - amavis
    - postfix
    - postfix.config
    - dovecot
    - nginx
    - roundcube
  'testing*':
    - python3
