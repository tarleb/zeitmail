{% set domain = salt['grains.get']('domain', 'example.com') %}

opendkim:
  pkg.installed:
    - pkgs:
      - opendkim
      - opendkim-tools
  service.running:
    - enable: True
    - restart: True
    - require:
      - pkg: opendkim
      - file: /etc/default/opendkim
      - file: /etc/opendkim.conf

/etc/default/opendkim:
  file.managed:
    - source: salt://{{slspath}}/files/default-opendkim
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: opendkim
    - watch_in:
      - service: opendkim

/etc/opendkim.conf:
  file.managed:
    - source: salt://{{slspath}}/files/opendkim.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: opendkim
      - file: /etc/opendkim/internal-hosts
      - file: /etc/opendkim/signing-table
      - file: /etc/opendkim/key-table
    - require_in:
      - service: opendkim
    - watch_in:
      - service: opendkim

/etc/opendkim/internal-hosts:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - contents: |
        127.0.0.1
        ::1
        localhost
        {{ domain }}
        *.{{ domain }}
    - watch_in:
      - service: opendkim

/etc/opendkim/signing-table:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - contents: |
        *@{{domain}} mail._domainkey.{{domain}}
    - watch_in:
      - service: opendkim

/etc/opendkim/key-table:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - contents: |
        mail._domainkey.{{domain}} {{domain}}:mail:/etc/opendkim/keys/{{domain}}/mail.private
    - require:
      - cmd: /etc/opendkim/keys/{{domain}}/mail.private
    - watch_in:
      - service: opendkim

# Generate a public/private key pair for signing
/etc/opendkim/keys/{{domain}}/mail.private:
  cmd.run:
    - name: opendkim-genkey -s mail -d {{domain}}
    - cwd: /etc/opendkim/keys/{{domain}}
    - umask: "077"
    - creates: /etc/opendkim/keys/{{domain}}/mail.private
    - require:
      - pkg: opendkim
      - file: /etc/opendkim/keys/{{domain}}
    - watch_in:
      - service: opendkim

  # Ensure proper file permissions
  file.managed:
    - user: opendkim
    - group: opendkim
    - mode: 600
    - replace: False

# Create OpenDKIM signing keys directory
/etc/opendkim/keys/{{domain}}:
  file.directory:
    - user: opendkim
    - group: opendkim
    - mode: 755
    - makedirs: True
    - require:
      - pkg: opendkim
