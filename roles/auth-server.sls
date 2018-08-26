{% set data = pillar['auth-server'] %}
{% set db = data['db'] %}

auth-server-packages:
  pkg.installed:
    - pkgs:
      - openldap
      - slapd

auth-server-pip:
  pip.installed:
    - name: PyMySQL
    - reload_modules: True

auth-server-db:
  mysql_user.present:
    - name: {{ data['db-user'] }}
    - password: {{ data['db-password'] }}
    - connection_host: {{ data['db-host'] }}
    - connection_user: {{ db['user'] }}
    - connection_pass: {{ db['password'] }}
    - require:
      - pip: auth-server-pip
  mysql_database.present:
    - name: {{ data['db-name'] }}
    - connection_host: {{ data['db-host'] }}
    - connection_user: {{ db['user'] }}
    - connection_pass: {{ db['password'] }}
    - require:
      - pip: auth-server-pip
  mysql_grants.present:
    - grant: all privileges
    - database: {{ data['db-name'] }}.*
    - user: {{ data['db-user'] }}
    - connection_host: {{ data['db-host'] }}
    - connection_user: {{ db['user'] }}
    - connection_pass: {{ db['password'] }}
    - require:
      - mysql_user: auth-server-db
      - mysql_database: auth-server-db
      - pip: auth-server-pip

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
