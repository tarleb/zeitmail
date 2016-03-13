# Diffie-Hellman Parameters
{%- from "zeitmail.jinja" import zeitmail with context %}
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

{%- if not zeitmail.dh.custom_parameters -%}

{# Use a proper group for the required bits of security. #}
{% if dh_bits <= 2048 %}
{% set group = 14 %}
{% elif dh_bits <= 3072 %}
{% set group = 15 %}
{% elif dh_bits <= 4096 %}
{% set group = 16 %}
{% elif dh_bits <= 6144 %}
{% set group = 17 %}
{% elif dh_bits <= 8192 %}
{% set group = 18 %}
{% endif %}
/etc/ssl/dh/params.pem:
  file.symlink:
    - target: /etc/ssl/dh/group{{group}}.pem
    - use:
      - file: /etc/ssl/dh/group{{group}}.pem
    - require:
      - file: /etc/ssl/dh/group{{group}}.pem

{% else %}

{%- set custom_dh_file = '/etc/ssl/dh/custom' ~ dh_bits ~ '.pem' %}
{%- set gen_cmd = 'openssl dhparam -out ' ~ custom_dh_file ~ ' ' ~ dh_bits %}
Generate custom {{bits}}-bit DH parameters:
  cmd.run:
    - name: {{gen_cmd}}
    - user: root
    - creates: {{custom_dh_file}}

Custom {{dh_bits}}-bit DH parameters regeneration:
  cron.present:
    - name: nice -n19 {{gen_cmd}}
    - user: root
    - hour: 1
    - minute: random
    - daymonth: random
    - identifier: REGENERATE CUSTOM {{dh_bits}}-BIT DH PARAMS

/etc/ssl/dh/params.pem:
  file.symlink:
    - target: {{custom_dh_file}}
    - require:
      - cmd: Generate custom {{bits}}-bit DH parameters
{%- endif %}
