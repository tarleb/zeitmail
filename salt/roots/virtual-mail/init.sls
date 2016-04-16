# Configs for virtual mail

include:
  - .postgresql
  - .postfix
  - .dovecot

virtual mail user and group:
  group.present:
    - name: vmail
    - gid: 5000

  user.present:
    - name: vmail
    - uid: 5000
    - gid: 5000
    - shell: /usr/sbin/nologin
    - home: /var/vmail
    - require:
      - group: vmail

virtual mail directory:
  file.directory:
    - name: /var/vmail
    - user: vmail
    - group: vmail
    - dir_mode: 770
    - require:
      - user: vmail
      - group: vmail
