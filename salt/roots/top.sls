base:
  'mail*':
    - postgresql
    - postfix
    - postfix.config
    - dovecot
    - powerdns
    - powerdns.postgres
  'testing*':
    - python3
