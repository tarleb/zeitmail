include:
  - php
  - .apt-preferences

roundcube:
  pkg.installed:
    - pkgs:
      - roundcube
      - roundcube-pgsql
    - require:
      - file: /etc/apt/preferences.d/roundcube.pref
      - pkg: php
