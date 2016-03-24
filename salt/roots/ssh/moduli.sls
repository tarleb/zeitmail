{%- from "zeitmail.jinja" import zeitmail with context %}
include:
  - .client

{%- set bits = zeitmail.bits_security -%}
{# Determine the estimate group bits required to reach a certain level of
 # security.  We are using recommendations by the Network Working Group
 # RFC3766.  These are close to the estimates by NIST as specified in SP800-57
 # Part 1. #}
{% if bits <= 103 %}
{% set dh_bits =  2048%}
{% elif bits <= 125 %}
{% set dh_bits = 3072 %}
{% elif bits <= 143 %}
{% set dh_bits = 4096 %}
{% elif bits <= 171 %}
{% set dh_bits = 6144 %}
{% elif bits <= 194 %}
{% set dh_bits = 8192 %}
{% endif %}

# Generating Diffie-Hellman parameters is a resource intensive operation.
{% set candidates_file = "/etc/ssh/moduli-" ~ dh_bits ~ ".all" -%}
{% set safe_groups_file = "/etc/ssh/moduli-" ~ dh_bits ~ ".safe" -%}
{% set candidates_cmd =
    "ssh-keygen -G " ~ candidates_file ~ " -b " ~ dh_bits %}
{% set safe_groups_cmd =
    "ssh-keygen -T " ~ safe_groups_file ~ " -f " ~ candidates_file %}

generate Diffie-Hellman {{dh_bits}} moduli candidates:
  cmd.run:
    - name: {{candidates_cmd}}
    - creates: {{ candidates_file }}
    - user: root
    - required:
      - pkg: openssh-client

generate Diffie-Hellman {{dh_bits}} moduli:
  cmd.run:
    - name: {{safe_groups_cmd}}
    - creates: {{ safe_groups_file }}
    - user: root
    - umask: 022
    - require:
      - pkg: openssh-client
      - cmd: generate Diffie-Hellman {{dh_bits}} moduli candidates

generate Diffie-Hellman moduli:
  cmd.wait:
    - name: "cat /etc/ssh/moduli-*.safe > /etc/ssh/moduli"
    - watch:
      - cmd: generate Diffie-Hellman {{dh_bits}} moduli

regenerate Diffie-Hellman SSH moduli perodically:
  cron.present:
    - name: nice -n19 {{candidates_cmd}} && nice -n19 {{safe_groups_cmd}}
    - user: root
    - minute: random
    - hour: random
    - daymonth: random
    - month: random
    - identifier: REGENERATE CUSTOM {{dh_bits}}-BIT DH PARAMS FOR SSH
    - require:
      - pkg: openssh-client
