# Self-signed SSL certificates
{%- from "zeitmail.jinja" import zeitmail with context %}

ssl-cert:
  pkg.installed: []

/etc/ssl/private:
  file.directory:
    - user: root
    - group: ssl-cert
    - mode: 710

generate default snakeoil:
  cmd.run:
    - name: /usr/sbin/make-ssl-cert generate-default-snakeoil
    - creates:
      - /etc/ssl/certs/ssl-cert-snakeoil.pem
      - /etc/ssl/private/ssl-cert-snakeoil.key
    - require:
      - file: /etc/ssl/private

/etc/ssl/certs/ssl-cert-snakeoil.pem:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - require:
      - cmd: generate default snakeoil

/etc/ssl/private/ssl-cert-snakeoil.key:
  file.managed:
    - user: root
    - group: ssl-cert
    - mode: 640
    - require:
      - file: /etc/ssl/private
      - cmd: generate default snakeoil

# Public key
{{zeitmail.ssl.certificate.file}}:
  file.symlink:
    - target: /etc/ssl/certs/ssl-cert-snakeoil.pem
    - require:
      - file: /etc/ssl/certs/ssl-cert-snakeoil.pem

# Private key
{{zeitmail.ssl.certificate.key_file}}:
  file.symlink:
    - target: /etc/ssl/private/ssl-cert-snakeoil.key
    - require:
      - file: /etc/ssl/private/ssl-cert-snakeoil.key
