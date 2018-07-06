{% from 'choco.jinja' import installed, upgraded %}
{% set data = pillar['workstation'] if 'workstation' in pillar else {} %}
{% set comps = data['packages'] if 'packages' in data else {} %}

{% macro check(pkg) %}
{% if pkg not in comps or comps[pkg] %}
{{ installed(pkg) }}
{% endif %}
{% endmacro %}

{{ check('x2go') }}
{{ check('dropbox') }}
{{ check('unity') }}
{{ check('Office365ProPlus') }}
