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

auth-server-ldap:
  ldap.managed:
    - name: ldapi:///
    - entries:
      - '{{ data['admin-user'] }}'
        - replace:
            description:
              - LDAP administrator
            objectClass:
              - simpleSecurityObject
              - organizationalRole
            userPassword:
            - {{ data['admin-password'] }}
    - require:
      - service: auth-server-slapd-service
