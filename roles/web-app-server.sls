{% if 'web-apps' in pillar %}
{% set commonData = pillar['web-apps'] %}
{% set apps = commonData['apps'] %}

web-apps-packages:
  pkg.installed:
    - pkgs:
      - apache2
      {# - libapache2-mod-ssl
      - libapache2-mod-rewrite #}

web-apps-config:
  file.managed:
    - name: /etc/apache2/sites-available/000-default.conf
    - source:
      - salt://roles/web-app-server/default.conf

web-apps-service:
  service.running:
    - name: apache2
    - enabled: true
    - reload: true
    - watch_any:
      - file: web-apps-config
{% for name in apps %}
      - file: web-app-{{ name }}-config
{% endfor %}

{% for name, data in apps.items() %}

{# web-app-{{ name }}-certificate:
  acme.cert:
    - name: {{ data['fqdn'] }}
    - email: {{ commonData['email'] }}
    - test_cert: true
    - renew: 14 #}

web-app-{{ name }}-config:
  file.managed:
    - name: /etc/apache2/sites-available/{{ name }}.conf
    - source:
      - salt://roles/web-app-server/site-config.conf
    - template: jinja
    - context:
        fqdn: {{ data['fqdn'] }}
        port: {{ data['port'] }}

web-app-{{ name }}-site:
  apache_site.{{ 'enabled' if data['enabled'] else 'disabled' }}:
    - name: {{ name }}.conf

{% endfor %}
{% endif %}
