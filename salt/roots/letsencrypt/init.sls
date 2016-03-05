{%- set domain = salt['grains.get']('domain') %}
{%- set email = salt['grains.get'](
        'letsencrypt:email',
        'postmaster@' ~ domain) -%}
{%- set subdomains = [domain, 'mail.' ~ domain, 'www.' ~ 'domain'] -%}
{%- set domain_config_file = '/etc/letsencrypt/config-{{domain}}.ini' -%}
{%- set agree_tos = salt['grains.get']('letsencrypt:agree_tos', False) -%}

include:
  - apt

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
        --test-cert
        --standalone
        --email {{email}}
        {{'--agree-tos' if agree_tos else '' }}
    - creates: /etc/letsencrypt/live/{{domain}}/fullchain.pem
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
    - mode: 600
    - makedirs: True

renew letsencrypt certificates for {{domain}}:
  cron.present:
    - name: /etc/letsencrypt/renew-webroot.sh {{domain}} {{'agree_tos' if agree_tos else ''}}
    - user: root
    - hour: 3
    - minute: random
    - identifier: LETSENCRYPT CERTIFICATE UPDATE
