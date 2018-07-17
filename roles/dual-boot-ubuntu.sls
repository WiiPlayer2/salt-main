dual-boot-grub-config:
  file.managed:
    - name: /etc/default/grub
    - source:
      - salt://roles/dual-boot/grub

dual-boot-update-grub:
  cmd.run:
    - name: update-grub
    - onchanges:
      - file: dual-boot-grub-config

dual-boot-set-local-time:
  cmd.run:
    - name: timedatectl set-local-rtc 1 --adjust-system-clock