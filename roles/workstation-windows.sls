{% from 'choco.jinja' import installed, upgraded %}
{% set data = pillar['workstation'] if 'workstation' in pillar else {} %}
{% set comps = data['packages'] if 'packages' in data else {} %}

{% macro check(pkg, latest=False) %}
{% if pkg not in comps or comps[pkg] %}
{% if latest %}
{{ upgraded(pkg) }}
{% else %}
{{ installed(pkg) }}
{% endif %}
{% endif %}
{% endmacro %}

{{ check('x2go', True) }}
{{ check('adobereader', True) }}
{{ check('obs-studio', True) }}
{{ check('javaruntime', True) }}
{{ check('cmake', True) }}
{{ check('texstudio', True) }}
{{ check('miktex', True) }}
{{ check('pidgin', True) }}
{{ check('wincdemu', True) }}

{{ check('dropbox') }}
{{ check('unity') }}
{{ check('Office365ProPlus') }}
