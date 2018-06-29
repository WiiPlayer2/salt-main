6tunnel-aas-packages:
  pkg.installed:
    - pkgs:
      - 6tunnel

/etc/6tunnel-aas:
  file.directory:
    - dir_mode: 755

/var/run/6tunnel-aas:
  file.directory:
    - dir_mode: 755

/usr/bin/6tunnel-aas:
  file.managed:
    - mode: 774
    - source:
      - salt://comps/6tunnel-aas/6tunnel-aas.py

6tunnel-aas-unit:
  file.managed:
    - name: /etc/systemd/system/6tunnel-aas.service
    - source:
      - salt://comps/6tunnel-aas/6tunnel-aas.service
  module.run:
    - name: service.systemctl_reload
    - onchanges:
      - file: 6tunnel-aas-unit

6tunnel-aas:
  service.running:
    - enable: True
    - watch_any:
      - module: 6tunnel-aas-unit
