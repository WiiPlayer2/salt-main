{%- if 'roles' in grains and grains['roles'] | length > 0 -%}
include:
{%- for role in grains['roles'] %}
  - roles.{{ role }}
{% endfor -%}
{%- endif %}
