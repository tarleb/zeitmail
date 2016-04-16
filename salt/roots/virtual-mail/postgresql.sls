include:
  - postgresql

virtual mail postgres user:
  postgres_user.present:
    - name: vmail
    - createdb: no
    - createuser: no
    - encrypted: no
    - superuser: no
    - replication: no
    - require:
      - service: postgresql

virtual mail postgres database:
  postgres_database.present:
    - name: virtual_mail
    - owner: vmail
    - owner_recurse: yes
    - encoding: UTF8
    - lc_ctype: en_US.UTF-8
    - lc_collate: en_US.UTF-8
    - require:
      - service: postgresql
      - postgres_user: vmail
