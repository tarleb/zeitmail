include:
  - postgresql

powerdns-server:
  pkg.installed:
    - name: pdns-server
  service.running:
    - name: pdns
    - enable: True
    - require:
      - pkg: powerdns-server

powerdns-recursor:
  pkg.installed:
    - name: pdns-recursor

powerdns-postgresql-backend:
  pkg.installed:
    - name: pdns-backend-pgsql
    - require:
      - sls: postgresql
