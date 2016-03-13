{%- from "zeitmail.jinja" import zeitmail with context -%}
{%- set domains = [
    zeitmail.domain.mail,
    zeitmail.domain.webmail
] + zeitmail.domain.additional -%}
include:
  - certificates
  - diffie-hellman-parameters

nginx:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: nginx
      - file: {{zeitmail.ssl.certificate.file}}
      - file: {{zeitmail.ssl.certificate.key_file}}

/etc/nginx/nginx.conf:
  file.managed:
    - source: salt://{{slspath}}/files/nginx.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - dir_mode: 755
    - context:
        certificate_file: {{zeitmail.ssl.certificate.file}}
        certificate_key_file: {{zeitmail.ssl.certificate.key_file}}
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
    - makedirs: True
    - dir_mode: 755
    - watch_in:
      - service: nginx

/etc/nginx/sites-enabled/default:
  file.symlink:
    - target: /etc/nginx/sites-available/default
    - require:
      - file: /etc/nginx/sites-available/default
    - makedirs: True
    - dir_mode: 755
    - watch_in:
      - service: nginx

# Placeholder site-config files.  May be overwritten later.
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
    - watch_in:
      - service: nginx

/etc/nginx/sites-enabled/{{domain}}.conf:
  file.symlink:
    - target: /etc/nginx/sites-available/{{domain}}.conf
    - require:
      - file: /etc/nginx/sites-available/{{domain}}.conf
    - makedirs: True
    - dir_mode: 755
    - watch_in:
      - service: nginx
{% endfor %}
