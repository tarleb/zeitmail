{% from slspath ~ '/settings.jinja' import virtual_mail with context %}
{% set pgsql = virtual_mail.postgresql %}

include:
  - dovecot

dovecot-pgsql:
  pkg.installed:
    - require_in:
      - service: dovecot

/etc/dovecot/conf.d/auth-sql.conf.ext:
  file.managed:
    - source: salt://{{slspath}}/files/dovecot/auth-sql.conf.ext
    - use:
      - file: /etc/dovecot/conf.d/10-auth.conf
    - require:
      - pkg: dovecot-core
    - watch_in:
      - service: dovecot

/etc/dovecot/dovecot-sql.conf.ext:
  file.managed:
    - source: salt://{{slspath}}/files/dovecot/dovecot-sql.conf.ext
    - user: root
    - group: dovecot
    - mode: 640
    - template: jinja
    - defaults:
        pg_user: {{pgsql.user}}
        pg_database: {{pgsql.database}}
    - watch_in:
      - service: dovecot
