# Generating Diffie-Hellman parameters is a resource intensive operation.  It
# should be executed only once.

{% set dh_group_bits = [2048] %}
{% set dh_safe_group_files = [] %}

{%- for bits in dh_group_bits %}
{% set candidates_file = "/etc/ssh/moduli-" ~ bits ~ ".all" -%}
{% set safe_groups_file = "/etc/ssh/moduli-" ~ bits ~ ".safe" -%}
{% do dh_safe_group_files.append(safe_groups_file) -%}
generate Diffie-Hellman {{bits}} moduli candidates:
  cmd.run:
    - name: ssh-keygen -G {{ candidates_file }} -b {{bits}}
    - creates: {{ candidates_file }}
    - user: root

generate Diffie-Hellman {{bits}} moduli:
  cmd.run:
    - name: ssh-keygen -T {{ safe_groups_file }} -f {{ candidates_file }}
    - creates: {{ safe_groups_file }}
    - user: root
    - umask: 022
    - require:
      - cmd: generate Diffie-Hellman {{bits}} moduli candidates
{%- endfor %}

generate Diffie-Hellman moduli:
  cmd.wait:
    - name: cat {{ dh_safe_group_files|join(" ") }} > /etc/ssh/moduli
    - require:
      {%- for bits in dh_group_bits %}
      - cmd: generate Diffie-Hellman {{bits}} moduli
      {%- endfor %}
    - watch:
      {%- for bits in dh_group_bits %}
      - cmd: generate Diffie-Hellman {{bits}} moduli
      {%- endfor %}
