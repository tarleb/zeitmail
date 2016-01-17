include:
  - postgresql

powerdns-server:
  pkg.installed:
    - name: pdns-server

powerdns-recursor:
  pkg.installed:
    - name: pdns-recursor

powerdns-postgresql-backend:
  pkg.installed:
    - name: pdns-backend-pgsql
    - require:
      - sls: postgresql
