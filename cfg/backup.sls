{% set paths = salt['pillar.get']('backup:paths', {}) %}
{% for name, path in paths.items() %}

backup-{{ name }}:
  backup.managed:
    - name: {{ name }}
    - path: {{ path }}

{% endfor %}
