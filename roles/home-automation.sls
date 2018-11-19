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
    - renew: 15
    - webroot: /var/www/html
    - onlyif:
      - "true"

homeassistant:
  user.present:
    - system: True
    - groups:
      - dialout

github.com-homeassistant:
  ssh_known_hosts.present:
    - name: github.com
    - user: homeassistant
    - key: AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==
    - enc: ssh-rsa

gitlab.com-homeassistant:
  ssh_known_hosts.present:
    - name: gitlab.com
    - user: homeassistant
    - key: AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9
    - enc: ssh-rsa

{{ pillar['git_repo_hassio'] }}:
  git.latest:
    - target: /home/homeassistant/.homeassistant
    - branch: master
    - user: homeassistant
    - force_checkout: True
    - force_fetch: True
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
    - pip_upgrade: True
    - pip_pkgs:
      - wheel
      - homeassistant
      - pip

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
      - git: {{ pillar['git_repo_hassio'] }}

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
