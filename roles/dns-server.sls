bind9:
  pkg.installed

/etc/bind/zones:
  file.directory

bind9-named-conf:
  file.managed:
    - name: /etc/bind/named.conf.local
    - group: bind
    - source:
      - salt://roles/dns-server/named.conf.local

bind9-db-domain-stage:
  file.managed:
    - name: /etc/bind/zones/db.{{ grains['domain'] }}.stage
    - template: jinja
    - source:
      - salt://roles/dns-server/db.domain.stage

bind9-db-domain:
  file.managed:
    - name: /etc/bind/zones/db.{{ grains['domain'] }}
    - template: jinja
    - source:
      - salt://roles/dns-server/db.domain
    - onchanges:
      - file: bind9-db-domain-stage


bind9-service:
  service.running:
    - name: bind9
    - enable: True
    - watch_any:
      - file: bind9-named-conf
      - file: bind9-db-domain
