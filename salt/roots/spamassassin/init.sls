spamassassin:
  pkg.installed: []
  service.running:
    - enable: True
    - require:
      - pkg: spamassassin

spamassassin-client:
  pkg.installed:
    - name: spamc

/etc/spamassassin/local.cf:
  file.managed:
    - source: salt://spamassassin/files/local.cf
    - watch_in:
      - service: spamassassin
