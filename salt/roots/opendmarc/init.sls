opendmarc:
  pkg.installed: []
  service.running:
    - restart: True
    - require:
      - pkg: opendmarc
