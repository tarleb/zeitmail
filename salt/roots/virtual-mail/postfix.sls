{% from slspath ~ '/settings.jinja' import virtual_mail with context %}
{% set pgsql = virtual_mail.postgresql %}

include:
  - postfix

postfix-pgsql:
  pkg.installed:
    - require_in:
      - service: postfix


{% for virtual_conf in ['aliases', 'domains', 'users']%}
/etc/postfix/pgsql/virtual-{{virtual_conf}}.cf:
  file.managed:
    - source: salt://{{slspath}}/files/postfix/virtual-{{virtual_conf}}.cf
    - template: jinja
    - makedirs: yes
    - user: root
    - group: root
    - file_mode: "0644"
    - dir_mode: "0755"
    - defaults:
        user: {{pgsql.user}}
        database: {{pgsql.database}}
    - watch:
      - service: postfix
{% endfor %}
