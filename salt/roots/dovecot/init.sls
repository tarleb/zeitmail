{%- from "zeitmail.jinja" import zeitmail with context -%}

include:
  - certificates

dovecot-core:
  pkg.installed: []

dovecot-imapd:
  pkg.installed:
    - require_in:
      - service: dovecot

dovecot-sieve:
  pkg.installed:
    - require_in:
      - service: dovecot

dovecot:
  service.running:
    - enable: True
    - require:
      - pkg: dovecot-core
      - file: {{zeitmail.ssl.certificate.file}}
      - file: {{zeitmail.ssl.certificate.key_file}}

{# Config Files #}
{% for file in ['10-master', '10-mail', '10-ssl', '15-lda', '15-mailboxes', '90-sieve'] %}
/etc/dovecot/conf.d/{{file}}.conf:
  file.managed:
    - source: salt://dovecot/files/{{file}}.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
        certificate_file: {{zeitmail.ssl.certificate.file}}
        certificate_key_file: {{zeitmail.ssl.certificate.key_file}}
    - require:
      - pkg: dovecot-core
    - watch_in:
      - service: dovecot
{% endfor %}
