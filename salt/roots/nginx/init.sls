{%- set domain = salt['grains.get']('domain') -%}
{%- set subdomains = [domain, 'mail.' ~ domain, 'www.' ~ domain] -%}
include:
  - diffie-hellman-parameters
  - letsencrypt

nginx:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: nginx
      - cmd: get letsencrypt certificate

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://{{slspath}}/files/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - context:
        certificate_file: /etc/letsencrypt/live/{{domain}}/fullchain.pem
        certificate_key_file: /etc/letsencrypt/live/{{domain}}/privkey.pem
    - watch_in:
      - service: nginx
    - require:
      - file: /etc/ssl/dh/params.pem

# Backup site config files.  May be overwritten later.
{% for subdomain in subdomains %}
/etc/nginx/sites-available/{{subdomain}}.conf:
  file.managed:
    - source: salt://{{slspath}}/files/domain.conf
    - template: jinja
    - replace: False
    - context:
        server_name: {{subdomain}}
    - use:
      - file: /etc/nginx/nginx.conf

/etc/nginx/sites-enabled/{{subdomain}}.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/{{domain}}.conf
    - require:
      - file: /etc/nginx/sites-available/{{domain}}.conf
    - watch_in:
      - service: nginx
{% endfor %}
