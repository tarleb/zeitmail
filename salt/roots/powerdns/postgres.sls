{% from "powerdns/map.jinja" import powerdns with context %}
{% set postgres = powerdns.postgres %}
{% set psql_params = "-h 127.0.0.1 -U " ~ postgres.user ~ " -d " ~ postgres.database %}

include:
  - powerdns
  - postgresql

powerdns postgres user:
  postgres_user.present:
    - name: {{ postgres.user }}
    - password: "{{ postgres.password }}"
    - createdb: False
    - createroles: False
    - createuser: False
    - encrypted: True
    - superuser: False
    - replication: False
    - require:
      - pkg: postgresql 

powerdns postgres db:
  postgres_database.present:
    - name: {{ postgres.database }}
    - owner: {{ postgres.user }}
    - encoding: UTF8
    - lc_ctype: en_US.UTF-8
    - lc_collate: en_US.UTF-8
    - require:
      - pkg: postgresql
      - postgres_user: powerdns postgres user

{% if not salt['grains.get']('postgres:powerdns:initialized') %}
powerdns postgres dot pgpass:
  file.managed:
    - name: /root/.pgpass
    - contents: "*:*:{{postgres.database}}:{{postgres.user}}:{{postgres.password}}\n"
    - user: root
    - group: root
    - mode: 600

powerdns postgres relations:
  cmd.run:
    - name: psql {{psql_params}} -f {{postgres.schema_file}}
    - require:
      - postgres_user: powerdns postgres user
      - postgres_database: powerdns postgres db
      - file: powerdns postgres dot pgpass
    - watch:
      - postgres_database: powerdns postgres db
  grains.present:
    - name: postgres:powerdns:initialized
    - value: True

powerdns postgres test data:
  file.managed:
    - name: /home/vagrant/gpgsql-test-data.sql
    - source: salt://{{slspath}}/data/test-data.sql
  cmd.run:
    - name: psql {{psql_params}} -f /home/vagrant/gpgsql-test-data.sql
    - require:
      - cmd: powerdns postgres relations
      - file: powerdns postgres test data
{% endif %}

/etc/powerdns/pdns.d/pdns.local.conf:
  file.managed:
    - source: salt://{{slspath}}/conf/pdns.local.conf.jinja
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - watch_in:
      - service: powerdns-server

/etc/powerdns/pdns.d/pdns.local.gpgsql.conf:
  file.managed:
    - source: salt://{{slspath}}/conf/pdns.local.gpgsql.conf.jinja
    - user: root
    - group: root
    - mode: 600
    - template: jinja
    - watch_in:
      - service: powerdns-server
