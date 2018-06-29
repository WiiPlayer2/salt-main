include:
  - comps.6tunnel-aas

hassio_packages:
  pkg.installed:
    - pkgs:
      - python3
      - python3-venv
      - python3-pip
      - mosquitto
      - apache2
      - python-certbot-apache
      - libatlas-base-dev

/etc/letsencrypt/cli.ini:
  file.managed:
    - source:
      - salt://roles/home-automation/cli.ini

/etc/letsencrypt/live:
  file.directory:
    - dir_mode: 755

/etc/letsencrypt/archive:
  file.directory:
    - dir_mode: 755

{{ pillar['hassio_fqdn'] }}:
  acme.cert:
    - email: {{ pillar['email'] }}
    - owner: homeassistant
    - group: homeassistant
    - webroot: /var/www/html

homeassistant:
  user.present:
    - system: True
    - groups:
      - dialout

{{ pillar['git_repo_hassio'] }}:
  git.latest:
    - target: /home/homeassistant/.homeassistant
    - branch: master
    - user: homeassistant
    - force_clone: True
    - force_reset: True
    - submodules: True

/home/homeassistant/.homeassistant/secrets.yaml:
  file.managed:
    - user: homeassistant
    - group: homeassistant
    - contents_pillar: hassio_secrets

/srv/homeassistant:
  file.directory:
    - user: homeassistant
    - group: homeassistant
    - recurse:
      - user
      - group
  virtualenv.managed:
    - venv_bin: pyvenv
    - user: homeassistant
    - pip_pkgs:
      - wheel
      - homeassistant

home-assistant-unit:
  file.managed:
    - name: /etc/systemd/system/home-assistant.service
    - source:
      - salt://roles/home-automation/home-assistant.service
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: home-assistant-unit

mosquitto:
  service.running:
    - enable: True

home-assistant:
  service.running:
    - enable: True
    - watch_any:
      - module: home-assistant-unit
      - acme: {{ pillar['hassio_fqdn'] }}

home-assistant-map:
  file.managed:
    - name: /etc/6tunnel-aas/home-assistant.map
    - template: jinja
    - source:
      - salt://roles/home-automation/home-assistant.map

hassio-6tunnel-aas:
  service.running:
    - name: 6tunnel-aas
    - enable: True
    - watch:
      - file: home-assistant-map
