hassio_packages:
  pkg.installed:
    - pkgs:
      - python3
      - python3-venv
      - python3-virtualenv
      - python3-pip
      - mosquitto

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
    - pip_pkgs:
      - wheel
      - homeassistant

/etc/systemd/system/home-assistant@homeassistant.service:
  file.managed:
    - source:
      - salt://roles/home-automation/home-assistant.service

home-assitant:
  service.running:
    - enable: True
