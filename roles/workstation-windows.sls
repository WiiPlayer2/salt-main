{% from 'choco.jinja' import installed, upgraded, check, cfg %}
{% set data = pillar['workstation'] if 'workstation' in pillar else {} %}
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

{{ check('adobereader', True) }}
{{ check('cmake', True) }}
{{ check('crystaldiskinfo', True) }}
{{ check('crystaldiskmark', True) }}
{{ check('ffmpeg', True) }}
{{ check('HxD', True) }}
{{ check('ilspy', True) }}
{{ check('inkscape', True) }}
{{ check('JabRef', True) }}
{{ check('javaruntime', True) }}
{{ check('krita', True) }}
{{ check('obs-studio-wiiplayer2-scripts', True) }}
{{ check('obs-studio', True) }}
{{ check('pidgin', True) }}
{{ check('python3', True) }}
{{ check('teamviewer', True) }}
{{ check('texstudio', True) }}
{{ check('virtualbox', True) }}
{{ check('vmware-workstation-player', True) }}
{{ check('wincdemu', True) }}
{{ check('x2go', True) }}

{{ check('dropbox') }}
{{ check('GoogleChrome') }}
{{ check('miktex') }}
{{ check('Office365ProPlus') }}
{{ check('resilio-sync-home') }}
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

{% call cfg('keepass') %}
{% include 'cfg/keepass.sls' %}
{% endcall %}
