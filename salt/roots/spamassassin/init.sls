{%- from "zeitmail.jinja" import zeitmail with context -%}
spamassassin:
  pkg.installed: []
  service.dead:
    - enable: False
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
    - context:
        # The regex_escape filter is not a default filter, so we have to
        # replace critical chars by hand.
        mailname_regex: {{zeitmail.domain.mail|replace('.','\\.')}}
    - watch_in:
      - service: spamassassin
