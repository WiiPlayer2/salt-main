{% if 'mounts' in pillar %}
{% for name in pillar['mounts'] %}
{% set data = pillar['mounts'][name] %}

mounts-{{ name }}:
  mount.mounted:
    - name: {{ data['path'] }}
    - device: {{ data ['device'] }}
    - mkmnt: True
    - options: {{ data['options'] }}
    - fstype: {{ data['fstype'] }}
{% if 'pass' in data %}
    - pass_num: {{ data['pass'] }}
{% endif %}

{% endfor %}
{% endif %}
