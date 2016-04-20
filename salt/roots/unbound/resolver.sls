{% from slspath ~ "/settings.jinja" import unbound with context %}
{% set resolver = unbound.resolver %}
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
