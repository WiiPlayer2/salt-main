ambient-light-packages:
  pkg.installed:
    - pkgs:
      - python3
      - python3-serial

ambient-light-etc:
  file.directory:
    - name: /etc/ambient-light
    - dir_mode: 755

ambient-light-config:
  file.managed:
    - name: /etc/ambient-light/config.json
    - template: jinja
    - source:
      - salt://roles/ambient-light/config.json

ambient-light-unit:
  file.managed:
    - name: /etc/systemd/system/ambient-light.service
    - source:
      - salt://roles/ambient-light/ambient-light.service
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: ambient-light-unit

ambient-light-script:
  file.managed:
    - name: /usr/bin/ambient-light
    - mode: 755
    - source:
      - salt://roles/ambient-light/ambient-light.py

ambient-light-service:
  service.running:
    - name: ambient-light
    - enable: True
    - watch_any:
      - file: ambient-light-config
      - module: ambient-light-unit
      - file: ambient-light-script
