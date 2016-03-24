# SSH client

openssh-client:
  pkg.installed: []

/etc/ssh/ssh_config:
  file.managed:
    - source: salt://{{slspath}}/files/ssh_config
    - user: root
    - group: root
    - mode: 644
