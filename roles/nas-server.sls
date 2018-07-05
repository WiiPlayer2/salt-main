{% set nas = pillar['nas-server'] %}
{% if 'samba' in nas %}

nas-server-samba-package:
  pkg.installed:
    - name: samba

nas-server-samba-conf:
  file.managed:
    - name: /etc/samba/smb.conf
    - template: jinja
    - source:
      - salt://roles/nas-server/smb.conf
    - require:
      - pkg: nas-server-samba-package

nas-server-samba-service:
  service.running:
    - name: samba
    - enable: True
    - watch:
      - file: nas-server-samba-conf

{% endif %}

{% if 'exports' in nas %}

nas-server-nfs-package:
  pkg.installed:
    - name: nfs-kernel-server

{% for export in nas['exports'] }
{% endfor %}
{% endif %}
