{% set data = pillar['dns-server'] %}

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

{% for zone, zData in data['zones'].items() %}

'dns-server-zone-{{ zone }}-stage':
  file.managed:
    - name: /etc/bind/zones/db.{{ zone }}.stage
    - template: jinja
    - source:
      - salt://roles/dns-server/db.zone.stage
    - context:
        data:
{% for k, v in zData.items() %}
          - name: '{{ k }}'
            type: {{ v['type'] }}
            record: {{ v['record'] }}
{% endfor %}

'dns-server-zone-{{ zone }}':
  file.managed:
    - name: /etc/bind/zones/db.{{ zone }}
    - template: jinja
    - source:
      - salt://roles/dns-server/db.zone
    - context:
        fqdn: {{ zone }}
        data:
{% for k, v in zData.items() %}
          - name: '{{ k }}'
            type: {{ v['type'] }}
            record: {{ v['record'] }}
{% endfor %}

{% endfor %}

bind9-service:
  service.running:
    - name: bind9
    - enable: True
    - watch_any:
      - file: bind9-named-conf
      - file: bind9-db-domain
{% for zone in data['zones'] %}
      - file: dns-server-zone-{{ zone }}
{% endfor %}
