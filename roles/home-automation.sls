hassio_packages:
  pkg.installed:
    - pkgs:
      - python3
      - python3-venv
      - python3-pip
      - mosquitto
      - apache2
      - python-certbot-apache

/etc/letsencrypt/cli.ini:
  file.managed:
    - source:
      - salt://roles/home-automation/cli.ini

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

/srv/homeassistant:
  file.directory:
    - user: homeassistant
    - group: homeassistant
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
    - watch:
      - module: home-assistant-unit
