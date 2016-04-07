powerdns-recursor:
  pkg.installed:
    - name: pdns-recursor

  service.running:
    - name: pdns-recursor
    - enable: yes
    - require:
      - pkg: powerdns-recursor
