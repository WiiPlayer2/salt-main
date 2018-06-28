base:
  '*':
{%- if 'roles' in grains -%}
{%- for role in grains['roles'] %}
    - roles.{{ role }}
{% endfor -%}
{%- endif %}
