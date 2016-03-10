spamassassin:
  pkg.installed: []
  service.running:
    - enable: True
    - require:
      - pkg: spamassassin

spamassassin-client:
  pkg.installed:
    - name: spamc

spamassassin config:
  file.managed:
    - name: /etc/spamassassin/local.cf
    - source: salt://spamassassin/files/local.cf
    - template: jinja
    - watch_in:
      - service: spamassassin
