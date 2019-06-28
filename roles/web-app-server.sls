{% if 'web-apps' in pillar %}
{% set commonData = pillar['web-apps'] %}

web-apps-http-server-package:
  pkg.installed:
    - pkgs:
      - apache2
      {# - libapache2-mod-ssl
      - libapache2-mod-rewrite #}

web-apps-config:
  apache.configfile:
    - name: /etc/apache2/sites-available/000-default.conf
    - config:
      - VirtualHost:
        this: '*:*'
        RequestHeader:
          - set "X-Forwarded-Proto" expr=%{REQUEST_SCHEME}

{% set apps = commonData['apps'] %}
{% for name, data in apps.items() %}

{# web-app-{{ name }}-certificate:
  acme.cert:
    - name: {{ data['fqdn'] }}
    - email: {{ commonData['email'] }}
    - test_cert: true
    - renew: 14 #}

web-app-{{ name }}-config:
  apache.configfile:
    - name: /etc/apache2/sites-available/{{ name }}.conf
    - config:
      - VirtualHost:
        this: '*:80'
        ServerName:
          - {{ data['fqdn'] }}
        ProxyPreserveHost: 'on'
        ProxyPass: / http://127.0.0.1:{{ data['port'] }}/
        ProxyPassReverse: / http://127.0.0.1:{{ data['port'] }}/

{# web-app-{{ name }}-site:
  apache_site.{{ 'enabled' if data['enabled'] else 'disabled' }}:
    - name: {{ name }} #}

{% endfor %}
{% endif %}
