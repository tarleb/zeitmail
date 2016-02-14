/etc/apt/sources.list:
  file.managed:
    - user: root
    - group: root
    - mode: 644
    - contents: "# See /etc/apt/sources.list.d/ for configured sources"

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
