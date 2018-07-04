{%- if 'roles' in grains and len(grains['roles']) > 0 -%}
include:
{%- for role in grains['roles'] %}
  - roles.{{ role }}
{% endfor -%}
{%- endif %}
