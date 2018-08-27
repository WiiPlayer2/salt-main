{% set data = pillar['auth-server'] %}

auth-server-packages:
  pkg.installed:
    - pkgs:
      - slapd
      - ldap-utils

auth-server-db:
  file.directory:
    - name: {{ data['db-directory'] }}
    - dir_mode: 700
    - user: openldap
    - group: openldap
    - makedirs: True

auth-server-slapd-config:
  file.managed:
    - name: /etc/ldap/slapd.d/cn=config/olcDatabase{1}mdb.ldif
    - template: jinja
    - mode: 600
    - user: openldap
    - group: openldap
    - source:
      - salt://roles/auth-server/olcDatabase%7B1%7Dmdb.ldif
    - require:
      - file: auth-server-db

auth-server-user:
  user.present:
    - name: openldap
    - groups:
      - root
    - require:
      - pkg: auth-server-packages

auth-server-slapd-service:
  service.running:
    - name: slapd
    - enable: True
    - require:
      - user: auth-server-user
    - watch:
      - file: auth-server-slapd-config

