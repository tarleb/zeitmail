postgresql:
  pkg.installed: []
  service.running:
    - enable: True
    - require:
      - pkg: postgresql
