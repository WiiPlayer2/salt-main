{% if 'keepass' in pillar %}
{% set data = pillar['keepass'] or {} %}
{% set config = data['config'] %}

{% macro cfg(path, value) %}
"keepass-cfg-{{ path }}":
  xml.set:
    - name: {{ path }}
    - file: {{ config }}
    - value: '{{ value }}'
{% endmacro %}

{{ cfg('Application/Start/MinimizedAndLocked', 'true') }}
{{ cfg('Application/FileClosing/AutoSave', 'true') }}
{{ cfg('MainWindow/CloseButtonMinimizesWindow', 'true') }}
{{ cfg('MainWindow/EscMinimizesToTray', 'true') }}
{{ cfg('MainWindow/MinimizeToTray', 'true') }}
{{ cfg('MainWindow/DropToBackAfterClipboardCopy', 'true') }}
{{ cfg('MainWindow/CopyUrlsInsteadOfOpening', 'true') }}
{{ cfg('Security/WorkspaceLocking/LockOnSessionSwitch', 'true') }}
{{ cfg('Security/WorkspaceLocking/LockAfterTime', '0') }}
{{ cfg('Security/WorksapceLocking/LockAfterGlobalTime', '300') }}
{{ cfg("Custom/Item[Key='firstinstall_shown']/Value", 'true') }}
{{ cfg("Custom/Item[Key='KeeAgent.AlwaysConfirm']/Value", 'false') }}
{{ cfg("Custom/Item[Key='KeeAgent.ShowBalloon']/Value", 'true') }}
{{ cfg("Custom/Item[Key='KeeAgent.UnlockOnActivity']/Value", 'true') }}
{{ cfg("Custom/Item[Key='KeeAgent.UserPicksKeyOnRequestIdentities']/Value", 'false') }}

{% if grains['os_family'] == 'Windows' %}

{% set ssh_auth = None %}
{% if 'msys' in data %}
{% set ssh_auth = data['msys'] %}
{{ cfg("Custom/Item[Key='KeeAgent.UseMsysSocket']/Value", 'true') }}
{{ cfg("Custom/Item[Key='KeeAgent.MsysSocketPath']/Value", data['msys']) }}
{% endif %}
{% if 'cygwin' in data %}
{% set ssh_auth = data['cygwin'] %}
{{ cfg("Custom/Item[Key='KeeAgent.UseCygwinSocket']/Value", 'true') }}
{{ cfg("Custom/Item[Key='KeeAgent.CygwinSocketPath']/Value", data['cygwin']) }}
{% endif %}

{% if ssh_auth != None %}
keepass-env-ssh-auth:
  environ.setenv:
    name: SSH_AUTH_SOCK
    value: {{ ssh_auth }}
    permanent: HKLM
{% endif %}

{% endif %}

{% endif %}
