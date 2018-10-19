dhcp-server-packages:
  pkg.installed:
    - pkgs:
      - isc-dhcp-server

dhcp-server-default:
  file.managed:
    - name: /etc/default/isc-dhcp-server
    - template: jinja
    - source:
      - salt://roles/dhcp-server/isc-dhcp-server.default

dhcp-server-config-v4:
  file.managed:
    - name: /etc/dhcp/dhcpd.conf
    - template: jinja
    - source:
      - salt://roles/dhcp-server/dhcpd.conf

dhcp-server-config-v6:
  file.managed:
    - name: /etc/dhcp/dhcpd6.conf
    - template: jinja
    - source:
      - salt://roles/dhcp-server/dhcpd6.conf

dhcp-server-service:
  service.running:
    - name: isc-dhcp-server
    - enable: True
    - watch_any:
      - file: dhcp-server-default
      - file: dhcp-server-config-v4
      - file: dhcp-server-config-v6
