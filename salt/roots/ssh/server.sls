{%- from "zeitmail.jinja" import zeitmail with context %}
{% if zeitmail.dh.custom_parameters_ssh %}
include:
  - .moduli
{% endif %}

# Generate RSA and ED25519 keys (unless already present)
generate RSA ssh key:
  cmd.run:
    - name: ssh-keygen -t rsa -b 4096 -N '' -f /etc/ssh/ssh_host_rsa_key
    - creates: /etc/ssh/ssh_host_rsa_key
    - user: root

generate ED25519 ssh key:
  cmd.run:
    - name: ssh-keygen -t ed25519 -N '' -f /etc/ssh/ssh_host_ed25519_key
    - creates: /etc/ssh/ssh_host_ed25519_key
    - user: root

/etc/ssh/sshd_config:
  file.managed:
    - source: salt://ssh/files/sshd_config
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: openssh-server

openssh-server:
  pkg.installed: []
  service.running:
    - name: ssh
    - reload: True
    - require:
      - pkg: openssh-server
      - file: /etc/ssh/sshd_config
      - cmd: generate RSA ssh key
      - cmd: generate ED25519 ssh key
      {%- if zeitmail.dh.custom_parameters_ssh %}
      - cmd: generate Diffie-Hellman moduli
      {%- endif %}
    - watch:
      - pkg: openssh-server
      - file: /etc/ssh/sshd_config
      - cmd: generate RSA ssh key
      - cmd: generate ED25519 ssh key
