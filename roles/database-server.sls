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
    - host: '%'
    - password: {{ data['admin-password'] }}
    - unix_socket: True
    - connection_unix_socket: /var/run/mysqld/mysqld.sock
    - require:
      - pkg: database-server-packages
      - pip: database-server-pip
