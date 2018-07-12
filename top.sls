base:
  '*':
    - cfg.accounts

  'G@os_family:Debian':
    - cfg.common.debian
    - cfg.mounts
  'G@os_family:Windows':
    - cfg.common.windows

  'G@roles:salt-master':
    - roles.salt-master
  'G@roles:home-automation':
    - roles.home-automation
  'G@roles:dns-server':
    - roles.dns-server
  'G@roles:nas-server':
    - roles.nas-server
  'G@roles:ambient-light':
    - roles.ambient-light
  'G@roles:workstation and G@os_family:Windows':
    - roles.workstation-windows
  'G@roles:workstation and G@os_family:Ubuntu':
    - roles.workstation-ubuntu

