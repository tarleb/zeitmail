opendkim:
  pkg.installed:
    - pkgs:
      - opendkim
      - opendkim-tools
  service.running:
    - enable: True
    - reload: True
    - require:
      - pkg: opendkim
