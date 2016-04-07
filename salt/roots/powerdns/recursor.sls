powerdns-recursor:
  pkg.installed:
    - name: pdns-recursor

  service.running:
    - name: pdns-recursor
    - enable: yes
    - require:
      - pkg: powerdns-recursor
    - watch:
      - file: /etc/powerdns/recursor.conf

/etc/powerdns/recursor.conf:
  file.managed:
    - source: salt://{{slspath}}/files/recursor.conf
    - user: root
    - group: root
    - mode: 644
    - dir_mode: 755
    - makedirs: yes
