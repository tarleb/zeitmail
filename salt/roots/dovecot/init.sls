dovecot-core:
  pkg.installed: []

dovecot:
  service.running:
    - enable: True
    - require:
      - pkg: dovecot-core

/etc/dovecot/conf.d/10-master.conf:
  file.managed:
    - source: salt://dovecot/files/10-master.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: dovecot-core
    - watch_in:
      - service: dovecot
