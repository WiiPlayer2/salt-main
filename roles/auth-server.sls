{% set data = pillar['auth-server'] %}

auth-server-packages:
  pkg.installed:
    - pkgs:
      - slapd

auth-server-db:
  file.directory:
    - name: {{ data['db-directory'] }}
    - dir_mode: 700
    - user: openldap
    - group: openldap
    - makedirs: True

auth-server-slapd-config:
  file.managed:
    - name: /etc/ldap/slapd.conf
    - template: jinja
    - mode: 600
    - user: openldap
    - group: openldap
    - source:
      - salt://roles/auth-server/slapd.conf
    - require:
      - file: auth-server-db

auth-server-slapd-service:
  service.running:
    - name: slapd
    - enable: True
    - watch:
      - file: auth-server-slapd-config
