{%- from "zeitmail.jinja" import zeitmail with context -%}
include:
  - spamassassin

amavis:
  pkg.installed:
    - name: amavisd-new
  service.running:
    - enable: True
    - require:
      - pkg: amavis
      - pkg: spamassassin
    - watch:
      - file: spamassassin config

/etc/amavis/conf.d/50-user:
  file.managed:
    - source: salt://amavis/files/50-user
    - template: jinja
    - context:
        domain: {{zeitmail.domain.mail}}
    - require:
      - pkg: amavis
    - watch_in:
      - service: amavis
