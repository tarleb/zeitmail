{% from slspath ~ '/settings.jinja' import virtual_mail with context %}
{% set pgsql = virtual_mail.postgresql %}

include:
  - postgresql
  - dogfish

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

/etc/zeitmail:
  file.directory:
    - user: root
    - group: root
    - dir_mode: "0755"

virtual mail postgres migrations:
  file.recurse:
    - name: /etc/zeitmail/postgres-migrations
    - source: salt://{{slspath}}/files/postgres-migrations
    - clean: yes
    - exclude_pat: schema.sql
    - user: postgres
    - group: postgres
    - file_mode: "0640"
    - dir_mode: "0750"
    - template: jinja
    - defaults:
        vmail_user: {{pgsql.user}}
    - require:
      - file: /etc/zeitmail

run migrations:
  cmd.wait:
    - name: dogfish migrate {{pgsql.database}}
    - user: postgres
    - group: postgres
    - umask: "027"
    - cwd: /etc/zeitmail
    - watch:
      - file: virtual mail postgres migrations
      # Ensure correct database/relations permissions
      - postgres_user: {{pgsql.user}}
      - postgres_database: {{pgsql.database}}
