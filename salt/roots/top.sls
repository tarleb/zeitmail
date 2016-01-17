base:
  'mail*':
    - postgresql
    - postfix
    - postfix.config
    - dovecot
    - powerdns
  'testing*':
    - python3
