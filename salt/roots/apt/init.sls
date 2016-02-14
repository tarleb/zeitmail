/etc/apt/sources.list:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: "# See /etc/apt/sources.list.d/ for configured sources"

/etc/apt/preferences:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: |
        Package: *
        Pin: release n=jessie
        Pin-Priority: 800

        Package: *
        Pin: release n=jessie-backports
        Pin-Priority: 700

jessie:
  pkgrepo.managed:
    - name: deb http://httpredir.debian.org/debian/ jessie main
    - file: /etc/apt/sources.list.d/jessie.list
    - comps: 'main'
    - refresh_db: False

jessie-updates:
  pkgrepo.managed:
    - name: deb http://security.debian.org/ jessie/updates main
    - file: /etc/apt/sources.list.d/jessie-updates.list
    - comps: 'main'
    - refresh_db: False

jessie-backports:
  pkgrepo.managed:
    - name: deb http://httpredir.debian.org/debian jessie-backports main
    - file: /etc/apt/sources.list.d/jessie-backports.list
    - comps: 'main'
    - refresh_db: False
