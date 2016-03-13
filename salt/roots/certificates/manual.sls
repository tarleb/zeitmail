# Manually managed SSL certificates
{%- from "zeitmail.jinja" import zeitmail with context %}

# Public key
{{zeitmail.ssl.certificate.file}}:
  file.exists

# Private key
{{zeitmail.ssl.certificate.key_file}}:
  file.exists
