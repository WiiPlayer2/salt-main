voip-server-packages:
  pkg.installed:
    - pkgs:
      - php5-ldap

voip-server-web-service:
  service.running:
    - name: apache2
    - watch:
      - pkg: voip-server-packages
