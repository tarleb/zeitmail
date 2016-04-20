{% from "powerdns/settings.jinja" import powerdns with context %}
{% set resolver = powerdns.resolver %}
/etc/resolv.conf:
  file.managed:
    - source: salt://{{slspath}}/files/resolv.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 6444
    - defaults:
        domain: {{resolver.domain}}
        nameservers: {{resolver.nameservers|yaml}}
        searchpaths: {{resolver.searchpaths|yaml}}
