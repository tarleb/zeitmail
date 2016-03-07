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

# Reply with empty answer unless a host exists
/etc/nginx/sites-available/default:
  file.managed:
    - contents: |
        # Drop requests to unknown hosts
        #
        # If no default server is defined, nginx will use the first matching
        # server.  To prevent host header attacks, or other potential problems,
        # the request is dropped returning 444 "no response".
        server {
        	listen 80 default_server;
        	listen [::]:80 default_server;
        	return 444;
        }
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: nginx

/etc/nginx/sites-enabled/default:
  file.symlink:
    - target: /etc/nginx/sites-available/default
    - require:
      - file: /etc/nginx/sites-available/default
    - watch_in:
      - service: nginx

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
    - watch_in:
      - service: nginx

/etc/nginx/sites-enabled/{{subdomain}}.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/{{subdomain}}.conf
    - require:
      - file: /etc/nginx/sites-available/{{subdomain}}.conf
    - watch_in:
      - service: nginx
{% endfor %}
