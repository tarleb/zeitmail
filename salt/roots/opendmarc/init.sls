opendmarc:
  pkg.installed: []
  service.running:
    - restart: True
    - require:
      - pkg: opendmarc
    - watch:
      - file: /etc/default/opendmarc
      - file: /etc/opendmarc.conf

/etc/default/opendmarc:
  file.managed:
    - source: salt://{{slspath}}/files/default-opendmarc
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: opendmarc

/etc/opendmarc.conf:
  file.managed:
    - source: salt://{{slspath}}/files/opendmarc.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: opendmarc
