dovecot-core:
  pkg.installed: []

dovecot:
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: dovecot-core
