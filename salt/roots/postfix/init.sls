{%- from "zeitmail.jinja" import zeitmail with context -%}
include:
  - .policyd-spf
  - amavis
  - certificates
  - diffie-hellman-parameters
  - opendkim
  - opendmarc

postfix:
  pkg.installed:
    - pkgs:
      - postfix
      - postfix-pcre
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: postfix
      - pkg: postfix-policyd-spf
      - service: amavis
      - service: opendkim
      - service: opendmarc
      - file: /etc/ssl/dh/params.pem
      - file: {{zeitmail.ssl.certificate.file}}
      - file: {{zeitmail.ssl.certificate.key_file}}

/etc/aliases:
  file.managed:
    - source: salt://postfix/files/aliases
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - context:
        admin_mail: {{zeitmail.admin_mail if zeitmail.admin_mail else ''}}
    - require:
      - pkg: postfix

newaliases:
  cmd.wait:
    - cwd: /
    - watch:
      - file: /etc/aliases

/etc/postfix/virtual:
  file.managed:
    - source: salt://postfix/files/virtual
    - user: root
    - group: root
    - mode: 644
    - template: jinja

postmap /etc/postfix/virtual:
  cmd.wait:
    - cwd: /
    - watch:
      - file: /etc/postfix/virtual

##
## Config files
##
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
    - context:
        certificate_file: {{zeitmail.ssl.certificate.file}}
        certificate_key_file: {{zeitmail.ssl.certificate.key_file}}
        dkim_sign: {{zeitmail.dkim.sign}}
        fqdn: {{salt['grains.get']('fqdn')}}
        mailname: {{zeitmail.domain.mail}}
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
    - context:
        dkim_sign: {{zeitmail.dkim.sign}}
    - require:
      - pkg: postfix
    - watch_in:
      - service: postfix

# This file is a Debian-specific to specify the domain from which mail should
# appear to be sent.  This isn't used in the configs, but is edited for
# consistency.
/etc/mailname:
  file.managed:
    - contents: {{zeitmail.domain.mail}}
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
