voip-server-packages:
  pkg.installed:
    - pkgs:
      - php5-ldap

voip-server-php-config:
  ini.options_present:
    - name: /etc/php5/apache2/php.ini
    - sections:
        PHP:
          max_execution_time: 60

voip-server-web-service:
  service.running:
    - name: apache2
    - watch_any:
      - pkg: voip-server-packages
      - ini: voip-server-php-config
