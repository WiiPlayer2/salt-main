{% if 'docker-apps' in pillar and pillar['docker-apps'] %}

include:
  - comps.docker

docker-apps-repo-directory:
  file.directory:
    - name: /docker-apps

{% for name, data in pillar['docker-apps'].items() %}

docker-app-{{ name }}-repo:
  git.latest:
    - name: {{ data['repo'] }}
    - target: /docker-apps/{{ name }}

docker-app-{{ name }}-compose:
  module.run:
    - dockercompose.up
      - path: /docker-apps/{{ name }}
    - watch:
      - git: docker-app-{{ name }}-repo

{% endfor %}
{% endif %}
