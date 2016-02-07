base:
  'mail*':
    - postfix
    - postfix.config
    - dovecot
  'staging*':
    - postfix
    - postfix.config
    - dovecot
  'testing*':
    - python3
