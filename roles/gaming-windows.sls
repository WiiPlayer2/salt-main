{% from 'choco.jinja' import installed, upgraded, check, cfg %}
{% set data = pillar['gaming'] if 'gaming' in pillar else {} %}
{% set data = data or {} %}
{% set comps = data['packages'] if 'packages' in data else {} %}
{% set comps = comps or {} %}

{{ cfg('logitechgaming', True) }}
{{ cfg('gamesavemanager', True) }}

{{ cfg('geforce-experience') }}
{{ cfg('geforce-game-ready-driver') }}
