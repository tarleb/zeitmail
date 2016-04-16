{% from slspath ~ '/settings.jinja' import virtual_mail with context %}
{% set pgsql = virtual_mail.postgresql %}

include:
  - postgresql

virtual mail postgres user:
  postgres_user.present:
    - name: {{pgsql.user}}
    - createdb: no
    - createuser: no
    - encrypted: no
    - superuser: no
    - replication: no
    - require:
      - service: postgresql

virtual mail postgres database:
  postgres_database.present:
    - name: {{pgsql.database}}
    - owner: vmail
    - owner_recurse: yes
    - encoding: UTF8
    - lc_ctype: en_US.UTF-8
    - lc_collate: en_US.UTF-8
    - require:
      - service: postgresql
      - postgres_user: {{pgsql.user}}
