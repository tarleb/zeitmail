dovecot-core:
  pkg.installed: []

dovecot-imapd:
  pkg.installed

dovecot:
  service.running:
    - enable: True
    - require:
      - pkg: dovecot-core
      - pkg: dovecot-imapd

{# Config Files #}
{% for file in ['10-master', '10-ssl', '15-mailboxes'] %}
/etc/dovecot/conf.d/{{file}}.conf:
  file.managed:
    - source: salt://dovecot/files/{{file}}.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: dovecot-core
    - watch_in:
      - service: dovecot
{% endfor %}
