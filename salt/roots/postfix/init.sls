include:
  - opendkim

postfix:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: postfix
      - service: opendkim

/etc/aliases:
  file.managed:
    - source: salt://postfix/files/aliases
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: postfix

newaliases:
  cmd.wait:
    - cwd: /
    - watch:
      - file: /etc/aliases

/etc/postfix/virtual:
  file.managed:
    - source: salt://postfix/files/virtual
    - user: root
    - group: root
    - mode: 644
    - template: jinja

postmap /etc/postfix/virtual:
  cmd.wait:
    - cwd: /
    - watch:
      - file: /etc/postfix/virtual
