amavis:
  pkg.installed:
    - name: amavisd-new
  service.running:
    - enable: True
    - require:
      - pkg: amavis

/etc/amavis/conf.d/50-user:
  file.managed:
    - source: salt://amavis/files/50-user
    - require:
      - pkg: amavis
    - watch_in:
      - service: amavis
