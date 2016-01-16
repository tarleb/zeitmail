base:
  'mail*':
    - spamassassin
    - postfix
    - postfix.config
    - dovecot
  'staging*':
    - spamassassin
    - postfix
    - postfix.config
    - dovecot
  'testing*':
    - python3
