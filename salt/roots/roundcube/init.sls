{%- set fqdn = salt['grains.get']('domain', 'mail.test') -%}
include:
  - php
  - nginx
  - .apt-preferences

roundcube:
  pkg.installed:
    - pkgs:
      - roundcube
      - roundcube-pgsql
    - require:
      - file: /etc/apt/preferences.d/roundcube.pref
      - pkg: php

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
    - name: /etc/nginx/sites-available/mail.{{fqdn}}.conf
    - source: salt://{{slspath}}/files/nginx-mail-site.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: nginx

enable roundcube site:
  file.symlink:
    - name: /etc/nginx/sites-enabled/mail.{{fqdn}}.conf
    - target: /etc/nginx/sites-available/mail.{{fqdn}}.conf
    - require:
      - file: roundcube nginx site
    - watch_in:
      - service: nginx
