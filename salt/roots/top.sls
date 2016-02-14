base:
  'mail*':
    - spamassassin
    - amavis
    - postfix
    - postfix.config
    - dovecot
    - nginx
  'staging*':
    - spamassassin
    - amavis
    - postfix
    - postfix.config
    - dovecot
    - nginx
  'testing*':
    - python3
