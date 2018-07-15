{% from 'choco.jinja' import installed, upgraded, check, cfg %}
{% set data = pillar['gaming'] if 'gaming' in pillar else {} %}
{% set data = data or {} %}
{% set comps = data['packages'] if 'packages' in data else {} %}
{% set comps = comps or {} %}

{{ check('logitechgaming', True) }}
{{ check('gamesavemanager', True) }}

{{ check('geforce-experience') }}
{{ check('geforce-game-ready-driver') }}
