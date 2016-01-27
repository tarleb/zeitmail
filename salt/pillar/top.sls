base:
  'mail*':
    - mail
    {% if salt['grains.get']('testing:load_data') -%}
    - test-data
    {%- endif %}


