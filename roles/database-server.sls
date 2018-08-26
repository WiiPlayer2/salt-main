{% set data = pillar['database-server'] %}

database-server-packages:
  pkg.installed:
    - pkgs:
      - mysql-server

database-server-pip:
  pip.installed:
    - name: PyMySQL
    - reload_modules: True
    - bin_env: /usr/bin/pip3

database-server-admin:
  mysql_user.present:
    - name: root
    - password: {{ data['admin-password'] }}
    - require:
      - pkg: database-server-packages
      - pip: database-server-pip
