{% from 'choco.jinja' import installed, upgraded %}
{% set data = pillar['windows'] if 'windows' in pillar else {} %}
{% set data = data or {} %}

common-windows-choco-bootstrap:
  module.run:
    - name: chocolatey.bootstrap
  win_path.exists:
    - name: 'C:\ProgramData\chocolatey\bin'
    - require:
      - module: common-windows-choco-bootstrap

common-windows-powershell-executionpolicy:
  cmd.run:
    - name: 'Set-ExecutionPolicy -Scope LocalMachine RemoteSigned'
    - shell: powershell

{% if 'users' in data %}

{% set users = data['users'] or [] %}
{% for user in users %}
{% set user_id = grains['user_ids'][user] %}

commmon-windows-{{ user }}-hidden-files
  reg.present:
    - name: 'HKU\\{{ user_id }}\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced'
    - vname: Hidden
    - vdata: 1
    - vtype: REG_DWORD

commmon-windows-{{ user }}-file-extensions
  reg.present:
    - name: 'HKU\\{{ user_id }}\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced'
    - vname: HideFileExt
    - vdata: 0
    - vtype: REG_DWORD

commmon-windows-{{ user }}-explorer-launch
  reg.present:
    - name: 'HKU\\{{ user_id }}\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced'
    - vname: LaunchTo
    - vdata: 1
    - vtype: REG_DWORD

commmon-windows-{{ user }}-mouse-acceleration
  reg.present:
    - name: 'HKU\\{{ user_id }}\\Control Panel\\Mouse'
    - vname: MouseSpeed
    - vdata: 0
    - vtype: REG_DWORD

{% endfor %}
{% endif %}

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
