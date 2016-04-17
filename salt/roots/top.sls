base:
  '*':
    - apt
    - ssh
    - postfix
    - dovecot
    - roundcube
    - powerdns.recursor
    - powerdns.resolver
  'zeitmail:mailboxes:virtual_users:True':
    - match: pillar
    - virtual-mail
