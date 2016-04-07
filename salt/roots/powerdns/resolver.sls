/etc/resolv.conf:
  file.managed:
    - source: salt://{{slspath}}/files/resolv.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 6444
    - defaults:
        domain: {{salt['pillar.get']('powerdns:resolver:domain', salt['grains.get']('domain'))}}
        nameservers: {{salt['pillar.get']('powerdns:resolver:nameservers', ['::1'])}}
        searchpaths: {{salt['pillar.get']('powerdns:resolver:searchpaths', [])}}
