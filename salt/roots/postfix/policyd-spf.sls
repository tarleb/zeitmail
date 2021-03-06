include:
  - postfix

postfix-policyd-spf:
  pkg.installed:
    - name: postfix-policyd-spf-python
    - require:
      - pkg: postfix

/etc/postfix-policyd-spf-python/policyd-spf.conf:
  file.managed:
    - source: salt://{{slspath}}/files/policyd-spf.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: postfix-policyd-spf
