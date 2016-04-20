base:
  '*':
    - apt
    - ssh
    - unbound
    - postfix
    - dovecot
    - roundcube
  'zeitmail:mailboxes:virtual_users:True':
    - match: pillar
    - virtual-mail
