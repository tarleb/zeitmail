virtual-mail:
{% if salt['grains.get']('testing:load_test_data') %}
  domains:
    - eggs.test
  aliases:
    john@eggs.test: vagrant
{% else %}
  domains: []
  aliases: {}
{% endif %}
