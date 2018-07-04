{% if 'accounts' in pillar %}
{% for data in pillar['accounts'] %}
account-{{ data['user'] }}:
  user.present:
    - name: {{ data['user'] }}
    - password: {{ data['passwd'] }}
{% if grains['os_family'] != 'Windows' %}
    - hash_password: True
{% endif %}
{% endfor %}
{% endif %}
