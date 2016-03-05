{%- set domains = [grains['domain'],
  'mail.' ~ grains['domain'],
  'www.' ~ grains['domain']
] -%}
include:
  - letsencrypt

nginx:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: nginx
      - cmd: get letsencrypt certificate

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
