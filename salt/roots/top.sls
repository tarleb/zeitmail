base:
  '*':
    - apt
    - letsencrypt
    - postfix
    - dovecot
    - roundcube
  'testing*':
    - python3
