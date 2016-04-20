# Unbound DNSSEC enabled recursor
include:
  - .resolver

unbound:
  pkg.installed: []
  service.running:
    - enable: yes
    - require:
      - pkg: unbound
