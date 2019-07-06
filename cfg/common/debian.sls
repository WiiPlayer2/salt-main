common-tools:
  pkg.installed:
    - pkgs:
      - git
      - tmux
      - htop
      - tree
      - python3
      - python3-pip
      - nmap
      - lsof

common-ssh-service:
  service.running:
    - name: ssh
    - enable: true
