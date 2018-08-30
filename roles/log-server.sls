log-server-packages:
  pkg.installed:
    - pkgs:
      - rsyslog

log-server-config:
  file.managed:
    - name: /etc/rsyslog.d/55-server.conf
    - source:
      - salt://roles/log-server/55-server.conf
    - require:
      - pkg: log-server-packages

log-server-service:
  service.running:
    - name: rsyslog
    - enabled: True
    - watch_any:
      - file: log-server-config
