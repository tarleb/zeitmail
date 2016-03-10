include:
  - postfix

/etc/postfix:
  file.directory:
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 644
    - makedirs: True

/etc/postfix/main.cf:
  file.managed:
    - source: salt://postfix/files/main.cf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: postfix
    - watch_in:
      - service: postfix

/etc/postfix/master.cf:
  file.managed:
    - source: salt://postfix/files/master.cf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: postfix
    - watch_in:
      - service: postfix

/etc/mailname:
  file.managed:
    - contents: {{grains['fqdn']}}
    - user: root
    - group: root
    - mode: 644
    - watch_in:
      - service: postfix

/etc/postfix/submission_header_checks.pcre:
  file.managed:
    - source: salt://postfix/files/submission_header_checks.pcre
    - use:
      - file: /etc/postfix/main.cf
    - watch_in:
      - service: postfix
