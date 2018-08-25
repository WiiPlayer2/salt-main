{% set data = pillar['auth-server'] %}

auth-server-packages:
  pkg.installed:
    - pkgs:
      - openldap

auth-server-db-user:
  mysql_user.present:
    - name: {{ data['db-user'] }}
    - password: {{ data['db-password'] }}

auth-server-db-database:
  mysql_database.present:
    - name: {{ data['db-name'] }}

auth-server-db-grants:
  mysql_grants.present:
    - grant: all privileges
    - database: {{ data['db-name'] }}.*
    - user: {{ data['db-user'] }}

auth-server-slapd-config:
  file.managed:
    - name: /etc/ldap/slapd.conf
    - template: jinja
    - source:
      - salt://roles/auth-server/slapd.conf

auth-server-slapd-service:
  service.running:
    - name: slapd
    - enable: True
    - watch:
      - file: auth-server-slapd-config
