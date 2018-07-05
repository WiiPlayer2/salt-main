{% if 'mounts' in pillar %}
{% for name, data in pillar['mounts'] %}

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
