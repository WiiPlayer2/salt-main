{% if 'accounts' in pillar %}
{% for data in pillar['accounts'] %}

{% if 'passwd' in data %}
account-{{ data['user'] }}:
  user.present:
    - name: {{ data['user'] }}
    - password: {{ data['passwd'] }}
{% if grains['os_family'] != 'Windows' and not data['passwd'].startswith('$') %}
    - hash_password: True
{% endif %}
{% endif %}

{% if 'ssh-auth' in data %}
account-{{ data['user'] }}-ssh-auth:
  ssh_auth.present:
    - name: {{ data['ssh-auth'] }}
    - user: {{ data['user'] }}
{% endif %}

{% endfor %}
{% endif %}
