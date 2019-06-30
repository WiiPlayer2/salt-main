{% set data = pillar['dns-server'] %}

bind9:
  pkg.installed

/etc/bind/zones:
  file.directory

bind9-named-conf:
  file.managed:
    - name: /etc/bind/named.conf.local
    - group: bind
    - template: jinja
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

{% macro zoneConfig(isStage) %}
'dns-server-zone-{{ zone }}{{ '-stage' if isStage else '' }}'
  file.managed:
    - name: /etc/bind/zones/db.{{ zone }}{{ '.stage' if isStage else '' }}
    - template: jinja
    - source:
      - salt://roles/dns-server/db.zone{{ '.stage' if isStage else '' }}
    - context:
        fqdn: {{ zone }}
        parent: {{ zData['parent'] }}
        data:
{% for k, v in zData['records'].items() %}
          - name: '{{ k }}'
            type: {{ v['type'] }}
            record: {{ v['record'] }}
{% endfor %}
{% endmacro %}

{{ zoneConfig(true) }}

{{ zoneConfig(false) }}
    - onchanges:
      - file: 'dns-server-zone-{{ zone }}-stage'

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
