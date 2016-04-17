dogfish:
  file.managed:
    - name: /usr/local/bin/dogfish
    - source: salt://{{slspath}}/files/dogfish
    - user: root
    - group: root
    - mode: "0755"
