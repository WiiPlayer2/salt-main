base:
  '*':
    - roles
    - cfg.accounts

  'G@os_family:Debian':
    - cfg.common.debian
    - cfg.mounts
  'G@os_family:Windows':
    - cfg.common.windows
