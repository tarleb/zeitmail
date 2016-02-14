base:
  'mail*':
    - apt
    - spamassassin
    - amavis
    - postfix
    - postfix.config
    - dovecot
    - nginx
  'staging*':
    - apt
    - spamassassin
    - amavis
    - postfix
    - postfix.config
    - dovecot
    - nginx
  'testing*':
    - python3
