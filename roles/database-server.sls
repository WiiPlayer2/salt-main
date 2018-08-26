{% set data = pillar['database-server'] %}

database-server-packages:
  pkg.installed:
    - pkgs:
      - mysql-server

database-server-admin:
  mysql_user.present:
    - name: root
    - password: {{ data['admin-password'] }}
