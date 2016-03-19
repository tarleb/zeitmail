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

/etc/dovecot/conf.d/10-ssl.conf:
  file.managed:
    - source: salt://dovecot/files/10-ssl.conf
    - use: /etc/dovecot/conf.d/10-master.conf
    - template: jinja
    - context:
        certificate_file: {{zeitmail.ssl.certificate.file}}
        certificate_key_file: {{zeitmail.ssl.certificate.key_file}}
    - require:
      - pkg: dovecot-core
    - watch_in:
      - service: dovecot

{# Config Files #}
{% for file in ['10-mail', '15-lda', '15-mailboxes', '90-sieve'] %}
/etc/dovecot/conf.d/{{file}}.conf:
  file.managed:
    - source: salt://dovecot/files/{{file}}.conf
    - use: /etc/dovecot/conf.d/10-master.conf
    - require:
      - pkg: dovecot-core
    - watch_in:
      - service: dovecot
{% endfor %}

/etc/dovecot/sieve/quarantine-spam.sieve:
  file.managed:
    - source: salt://{{slspath}}/files/quarantine-spam.sieve
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - dir_mode: 755
    - watch_in:
      - cmd: Compile sieve scripts

Compile sieve scripts:
  cmd.wait:
    # The `sleep` hack prevents dovecot from trying to recompile the
    # script. Dovecot seems to think the source file is newer than the
    # compiled file if both have the same timestamp.
    - name: sleep 1 && /usr/bin/sievec /etc/dovecot/sieve
    - user: root
    - group: root
    - umask: "022"
    - require_in:
      - file: /etc/dovecot/conf.d/90-sieve.conf
