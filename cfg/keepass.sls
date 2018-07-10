{% if 'keepass' in pillar %}
{% set data = pillar['keepass'] or {} %}
{% set config = data['config'] %}

{% macro cfg(path, value) %}
'keepass-cfg-{{ path }}':
  xml.set:
    name: {{ path }}
    file: {{ config }}
    value: {{ value }}
{% endmacro %}

{{ cfg('Application/Start/MinimizedAndLocked', 'true') }}
{{ cfg('Application/FileClosing/AutoSave', 'true') }}
{{ cfg('MainWindow/CloseButtonMinimizesWindow', 'true') }}
{{ cfg('MainWindow/EscMinimizesToTray', 'true') }}
{{ cfg('MainWindow/MinimizeToTray', 'true') }}
{{ cfg('MainWindow/DropToBackAfterClipboardCopy', 'true' }}
{{ cfg('MainWindow/CopyUrlsInsteadOfOpening', 'true') }}
{{ cfg('Security/WorkspaceLocking/LockOnSessionSwitch', 'true') }}
{{ cfg('Security/WorkspaceLocking/LockAfterTime', '0') }}
{{ cfg('Security/WorksapceLocking/LockAfterGlobalTime', '300') }}
{{ cfg("Custom/Item[Key='firstinstall_shown']/Value", 'true') }}
{{ cfg("Custom/Item[Key='KeeAgent.AlwaysConfirm']/Value", 'false') }}
{{ cfg("Custom/Item[Key='KeeAgent.ShowBalloon']/Value", 'true') }}
{{ cfg("Custom/Item[Key='KeeAgent.UnlockOnActivity']/Value", 'true') }}
{{ cfg("Custom/Item[Key='KeeAgent.UserPicksKeyOnRequestIdentities']/Value", 'false') }}

{% endif %}
