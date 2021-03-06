{%- from "zeitmail.jinja" import zeitmail with context -%}
{%- set subdomains = [
    zeitmail.domain.mail,
    zeitmail.domain.webmail
] + zeitmail.domain.additional -%}
{%- set domain = zeitmail.domain.mail -%}
{%- set domain_config_file = '/etc/letsencrypt/config-' ~ zeitmail.domain.mail ~ '.ini' -%}
include:
  - apt

# Public key
{{zeitmail.ssl.certificate.file}}:
  file.symlink:
    - target: /etc/letsencrypt/live/{{domain}}/fullchain.pem
    - require:
      - cmd: get letsencrypt certificate

# Private key
{{zeitmail.ssl.certificate.key_file}}:
  file.symlink:
    - target: /etc/letsencrypt/live/{{domain}}/privkey.pem
    - require:
      - cmd: get letsencrypt certificate

/etc/apt/preferences.d/10-python-cryptography.pref:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        Package: python-cryptography python-cffi* python-pyasn1 python-openssl
        Pin: release n=stretch
        Pin-Priority: 850
    - require:
      - pkgrepo: stretch

letsencrypt:
  pkg.installed:
    - require:
      - file: /etc/apt/preferences.d/10-python-cryptography.pref

letsencrypt config:
  file.managed:
    - name: {{domain_config_file}}
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - contents: |
        webroot-path = /var/www/letsencrypt
        domains = {{subdomains|join(',')}}
        rsa-key-size = 4096

get letsencrypt certificate:
  cmd.run:
    - name: >
        letsencrypt certonly
        --config {{domain_config_file}}
        --non-interactive
        --standalone
        --email {{zeitmail.letsencrypt.email}}
        {{'--agree-tos' if zeitmail.letsencrypt.agree_tos else '' }}
    - creates: /etc/letsencrypt/live/{{zeitmail.domain.mail}}/fullchain.pem
    - require:
      - file: letsencrypt config
      - file: /var/www/letsencrypt

/var/www/letsencrypt:
  file.directory:
    - user: root
    - group: root
    - mode: 755
    - makedirs: True

/etc/letsencrypt/renew-webroot.sh:
  file.managed:
    - source: salt://{{slspath}}/files/renew-webroot.sh
    - user: root
    - group: root
    - mode: 700
    - makedirs: True

renew letsencrypt certificates for {{domain}}:
  cron.present:
    - name: /etc/letsencrypt/renew-webroot.sh -q {{zeitmail.domain.mail}} {{'agree_tos' if zeitmail.letsencrypt.agree_tos else ''}}
    - user: root
    - hour: 3
    - minute: random
    - identifier: LETSENCRYPT CERTIFICATE UPDATE
