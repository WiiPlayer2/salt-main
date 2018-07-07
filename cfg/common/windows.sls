common-windows-choco-bootstrap:
  module.run:
    - name: chocolatey.bootstrap
  win_path.exists:
    - name: 'C:\ProgramData\chocolatey\bin'
    - require:
      - module: common-windows-choco-bootstrap

{% from 'choco.jinja' import installed, upgraded %}

{{ upgraded('7zip') }}
{{ upgraded('chocolatey') }}
{{ upgraded('flashplayerplugin') }}
{{ upgraded('flashplayerppapi') }}
{{ upgraded('git') }}
{{ upgraded('gitextensions') }}
{{ upgraded('keepass') }}
{{ upgraded('keepass-plugin-keeagent') }}
{{ upgraded('keepass-plugin-quickunlock') }}
{{ upgraded('keepass-plugin-traytotp') }}
# openvpn packages seems to be broken
#{# {{ upgraded('openvpn') }} #}
{{ upgraded('putty') }}
{{ upgraded('streamlink') }}
{{ upgraded('sudo') }}
{{ upgraded('visualstudiocode') }}
{{ upgraded('vlc') }}
{{ upgraded('windirstat') }}
{{ upgraded('winscp') }}
{{ upgraded('XnViewMP') }}

{{ installed('Firefox') }}
{{ installed('discord') }}
{{ installed('telegram') }}
