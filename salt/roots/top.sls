base:
  'mail*':
    - postgresql
    - postfix
    - postfix.config
    - dovecot
  'testing*':
    - python3
