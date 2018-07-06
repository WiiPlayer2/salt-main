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

{{ check('adobereader', True) }}
{{ check('cmake', True) }}
{{ check('crystaldiskinfo', True) }}
{{ check('crystaldiskmark', True) }}
{{ check('ffmpeg', True) }}
{{ check('HxD', True) }}
{{ check('ilspy', True) }}
{{ check('inkscape', True) }}
{{ check('javaruntime', True) }}
{{ check('miktex', True) }}
{{ check('obs-studio-wiiplayer2-scripts', True) }}
{{ check('obs-studio', True) }}
{{ check('pidgin', True) }}
{{ check('teamviewer', True) }}
{{ check('texstudio', True) }}
{{ check('virtualbox', True) }}
{{ check('vmware-workstation-player', True) }}
{{ check('wincdemu', True) }}
{{ check('x2go', True) }}

{{ check('dropbox') }}
{{ check('Office365ProPlus') }}
{{ check('sharex') }}
{{ check('unity') }}
{{ check('visualstudio2017enterprise') }}
{{ check('visualstudio2017-workload-manageddesktop') }}
{{ check('visualstudio2017-workload-managedgame') }}
{{ check('visualstudio2017-workload-netcorebuildtools') }}
{{ check('visualstudio2017-workload-netcoretools') }}
{{ check('visualstudio2017-workload-netcrossplat') }}
{{ check('visualstudio2017-workload-netweb') }}
{{ check('visualstudio2017-workload-universal') }}
{{ check('visualstudio2017-workload-visualstudioextension') }}
{{ check('visualstudio2017-workload-webcrossplat') }}
