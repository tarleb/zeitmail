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

openssh-server:
  pkg.installed: []
  service.running:
    - name: ssh
    - require:
      - pkg: openssh-server
      - cmd: generate RSA ssh key
      - cmd: generate ED25519 ssh key
    - watch:
      - pkg: openssh-server
      - cmd: generate RSA ssh key
      - cmd: generate ED25519 ssh key
