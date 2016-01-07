postfix:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: postfix

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
