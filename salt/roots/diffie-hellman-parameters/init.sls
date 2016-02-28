# Diffie-Hellman Parameters

/etc/ssl/dh:
  file.directory:
    - user: root
    - group: root
    - mode: 755

##
## Diffie-Hellman group parameters as defined in RFC 3526
##
##
## Sizes:
##   group14: 2048-bit
##   group15: 3072-bit
##   group16: 4096-bit
##   group17: 6144-bit
##   group18: 8192-bit
#
{% for num in [14, 15, 16, 17, 18] %}
/etc/ssl/dh/group{{num}}.pem:
  file.managed:
    - source: salt://{{slspath}}/files/group{{num}}.pem
    - user: root
    - group: root
    - mode: 644
{% endfor %}

/etc/ssl/dh/params.pem:
  file.symlink:
    - target: /etc/ssl/dh/group16.pem
    - use:
      - file: /etc/ssl/dh/group16.pem
    - require:
      - file: /etc/ssl/dh/group16.pem
