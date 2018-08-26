{% set data = pillar['database-server'] %}

database-server-packages:
  pkg.installed:
    - pkgs:
      - mysql-server

database-server-pip:
  pip.installed:
    - name: PyMySQL
    - reload_modules: True

database-server-config:
  file.managed:
    - name: /etc/mysql/mariadb.conf.d/50-server.cnf
    - source:
      - salt://roles/database-server/50-server.cnf

database-server-service:
  service.running:
    - name: mysql
    - enable: True
    - watch:
      - file: database-server-config

database-server-admin:
  mysql_user.present:
    - name: root
    - host: '%'
    - password: {{ data['admin-password'] }}
    - connection_unix_socket: /var/run/mysqld/mysqld.sock
    - require:
      - pkg: database-server-packages
      - pip: database-server-pip
      - service: database-server-service
  mysql_grants.present:
    - grant: all
    - grant_option: True
    - database: '*.*'
    - user: root
    - host: '%'
    - connection_unix_socket: /var/run/mysqld/mysqld.sock
    - require:
      - mysql_user: database-server-admin
