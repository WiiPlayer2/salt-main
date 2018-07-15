{% from 'choco.jinja' import installed, upgraded, check, cfg %}
{% set data = pillar['gaming'] if 'gaming' in pillar else {} %}
{% set data = data or {} %}
{% set comps = data['packages'] if 'packages' in data else {} %}
{% set comps = comps or {} %}

{% macro check(pkg, latest=False) %}
{% if pkg not in comps or comps[pkg] %}
{% if latest %}
{{ upgraded(pkg) }}
{% else %}
{{ installed(pkg) }}
{% endif %}
{% endif %}
{% endmacro %}

{% macro cfg(pkg) %}
{% if pkg not in comps or comps[pkg] %}
{{ caller() }}
{% endif %}
{% endmacro %}

{{ check('logitechgaming', True) }}
{{ check('gamesavemanager', True) }}

{{ check('geforce-experience') }}
{{ check('geforce-game-ready-driver') }}
