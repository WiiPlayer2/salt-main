{% if 'accounts' in pillar %}
{% for data in pillar['accounts'] %}

{% if 'passwd' in data %}
account-{{ data['user'] }}:
  user.present:
    - name: {{ data['user'] }}
{% if grains['os_family'] != 'Windows' %}
    - password: {{ salt['cmd.run']("openssl passwd -1 pass:{{ data['passwd'] }}") }}
{% else %}
    - password: {{ data['passwd'] }}
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
