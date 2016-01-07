postfix:
  pkg.installed: []
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: postfix
