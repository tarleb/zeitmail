{%- from "zeitmail.jinja" import zeitmail with context -%}

include:
  - certificates

dovecot-core:
  pkg.installed: []

{% for extension in ['imapd', 'sieve', 'lmtpd'] %}
dovecot-{{extension}}:
  pkg.installed:
    - require_in:
      - service: dovecot
{% endfor %}

dovecot:
  service.running:
    - enable: True
    - require:
      - pkg: dovecot-core
      - file: {{zeitmail.ssl.certificate.file}}
      - file: {{zeitmail.ssl.certificate.key_file}}

{# Config Files #}
{% for file in ['10-mail.conf', '10-master.conf', '10-ssl.conf',
                '15-lda.conf', '15-mailboxes.conf', '20-lmtp.conf',
                '90-sieve.conf'] %}
/etc/dovecot/conf.d/{{file}}:
  file.managed:
    - source: salt://dovecot/files/{{file}}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        certificate_file: {{zeitmail.ssl.certificate.file}}
        certificate_key_file: {{zeitmail.ssl.certificate.key_file}}
        postmaster: postmaster@{{zeitmail.domain.mail}}
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
