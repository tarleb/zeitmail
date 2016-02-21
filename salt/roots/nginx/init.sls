nginx:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: nginx

/etc/nginx/sites-available/{{grains['domain']}}.conf:
  file.managed:
    - source: salt://{{slspath}}/files/domain.conf
    - replace: False
    - user: root
    - group: root
    - mode: 644
