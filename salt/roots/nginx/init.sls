{%- set domains = [grains['domain'],
  'mail.' ~ grains['domain'],
  'www.' ~ grains['domain']
] -%}
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
    - watch_in:
      - service: nginx
    - require:
      - file: /etc/ssl/dh/params.pem

# Backup site config files.  May be overwritten later.
{% for domain in domains %}
/etc/nginx/sites-available/{{domain}}.conf:
  file.managed:
    - source: salt://{{slspath}}/files/domain.conf
    - template: jinja
    - replace: False
    - context:
        server_name: {{domain}}
    - use:
      - file: /etc/nginx/nginx.conf

/etc/nginx/sites-enabled/{{domain}}.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/{{domain}}.conf
    - require:
      - file: /etc/nginx/sites-available/{{domain}}.conf
    - watch_in:
      - service: nginx
{% endfor %}
