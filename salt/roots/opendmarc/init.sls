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
      - file: /etc/opendmarc/ignore.hosts

/etc/opendmarc/ignore.hosts:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        127.0.0.1/8
        ::1/128
    - require:
      - file: /etc/opendmarc
    - watch_in:
      - service: opendmarc

/etc/opendmarc:
  file.directory:
    - user: root
    - group: root
    - mode: 755
