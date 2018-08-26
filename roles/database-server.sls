{% set data = pillar['database-server'] %}

database-server-packages:
  pkg.installed:
    - pkgs:
      - mysql-server

database-server-pip:
  pip.installed:
    - name: PyMySQL
    - reload_modules: True

database-server-admin:
  mysql_user.present:
    - name: root
    - host: localhost
    - password: '{{ data['admin-password'] }}'
    - unix_socket: True
    - require:
      - pkg: database-server-packages
      - pip: database-server-pip
