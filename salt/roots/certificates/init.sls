{%- from "zeitmail.jinja" import zeitmail with context -%}
include:
{%- if zeitmail.ssl.certificate.ca == 'letsencrypt' %}
  - .letsencrypt
{%- elif zeitmail.ssl.certificate.ca == 'self-signed' %}
  - .snakeoil
{%- else %}
  - .manual
{%- endif -%}
