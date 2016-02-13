base:
  'mail*':
    - spamassassin
    - amavis
    - postfix
    - postfix.config
    - dovecot
  'staging*':
    - spamassassin
    - amavis
    - postfix
    - postfix.config
    - dovecot
  'testing*':
    - python3
