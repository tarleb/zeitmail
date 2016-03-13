{%- from "zeitmail.jinja" import zeitmail with context -%}
include:
  - postgresql
  - php
  - nginx
  - .apt-preferences

roundcube:
  pkg.installed:
    - pkgs:
      - roundcube
      - roundcube-pgsql
    - require:
      - file: /etc/apt/preferences.d/10-roundcube.pref
      - pkg: nginx
      - pkg: php
      - service: postgresql

# The des_key config file is generated in a two-step process.  First the file
# is generated, readable by nobody but root.  Then the proper permissions are
# assigned.  We cannot combine this into one step as root is not a member of
# group www-data.
{% set config_file_des_key = "/etc/roundcube/config-des-key.inc.php" -%}
{{config_file_des_key}}:
  cmd.script:
    - name: salt://{{slspath}}/files/create-des-key-config.sh
    - user: root
    - group: root
    - umask: "077"
    - args: {{config_file_des_key}}
    - creates: {{config_file_des_key}}
    - require:
      - pkg: roundcube
  file.managed:
    - user: root
    - group: www-data
    - mode: 640
    - require:
      - cmd: {{config_file_des_key}}

/etc/roundcube/config.inc.php:
  file.managed:
    - source: salt://{{slspath}}/files/config.inc.php
    - template: jinja
    - user: root
    - group: www-data
    - mode: 640
    - require:
      - pkg: roundcube

roundcube nginx site:
  file.managed:
    - name: /etc/nginx/sites-available/{{zeitmail.domain.webmail}}.conf
    - source: salt://{{slspath}}/files/nginx-mail-site.conf
    - template: jinja
    - context:
        webmail_domain: "{{zeitmail.domain.webmail}}"
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - watch_in:
      - service: nginx

enable roundcube site:
  file.symlink:
    - name: /etc/nginx/sites-enabled/{{zeitmail.domain.webmail}}.conf
    - target: /etc/nginx/sites-available/{{zeitmail.domain.webmail}}.conf
    - require:
      - file: roundcube nginx site
    - watch_in:
      - service: nginx
