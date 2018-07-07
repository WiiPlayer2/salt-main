common-windows-choco-bootstrap:
  module.run:
    - name: chocolatey.bootstrap
  win_path.exists:
    - name: 'C:\ProgramData\chocolatey\bin'
    - require:
      - module: common-windows-choco-bootstrap

{% from 'choco.jinja' import installed, upgraded %}

{{ upgraded('chocolatey') }}
{{ upgraded('keepass') }}
{{ upgraded('keepass-plugin-quickunlock') }}
{{ upgraded('keepass-plugin-keeagent') }}
{{ upgraded('keepass-plugin-traytotp') }}
{{ upgraded('vlc') }}
{{ upgraded('winscp') }}
{{ upgraded('putty') }}
{{ upgraded('flashplayerplugin') }}
{{ upgraded('flashplayerppapi') }}
{{ upgraded('openvpn') }}
{{ upgraded('XnViewMP') }}
{{ upgraded('visualstudiocode') }}
{{ upgraded('7zip') }}
{{ upgraded('streamlink') }}
{{ upgraded('git') }}
{{ upgraded('sudo') }}
{{ upgraded('windirstat') }}
{{ upgraded('gitextensions') }}

{{ installed('Firefox') }}
{{ installed('discord') }}
{{ installed('telegram') }}
