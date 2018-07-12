{% from 'apt.jinja' import ppa_present, repo_data %}
{% set data = pillar['workstation'] if 'workstation' in pillar else {} %}
{% set data = data or {} %}
{% set comps = data['packages'] if 'packages' in data else {} %}
{% set comps = comps or {} %}

{% macro check(pkg, latest=False, local=None) %}
{% if pkg not in comps or comps[pkg] %}
{% if latest %}
workstation-pkg-{{ pkg }}:
  pkg.latest:
    - name: {{ pkg }}
{% else %}
workstation-pkg-{{ pkg }}:
  pkg.installed:
    - name: {{ pkg }}
{% if local != None %}
    - sources:
      - {{ local }}
{% endif %}
{% endif %}
{% endif %}
{% endmacro %}

{% macro cfg(pkg) %}
{% if pkg not in comps or comps[pkg] %}
{{ caller() }}
{% endif %}
{% endmacro %}

{{ check('build-essential', True) }}
{{ check('chromium-browser', True) }}
{{ check('cmake', True) }}
{{ check('default-jdk', True) }}
{{ check('default-jre', True) }}
{{ check('ffmpeg', True) }}
{{ check('firefox', True) }}
{{ check('inkscape', True) }}
{{ check('k4dirstat', True) }}
{{ check('krita', True) }}
{{ check('obs-studio', True) }}
{{ check('streamlink', True) }}
{{ check('telegram-desktop', True) }}
{{ check('texstudio', True) }}
{{ check('thunderbird', True) }}
{{ check('virtualbox', True) }}
{{ check('vlc', True) }}
{{ check('x2goclient', True) }}

# Missing:
# dropbox
# teamviewer

{{ check('discord', local='https://discordapp.com/api/download?platform=linux&format=deb') }}

{% call cfg('code') %}
{{ repo_data('vscode', 'deb [arch=amd64] https://packages.microsoft.com/repos/vscode stable main', 'microsoft') }}
{{ check('code', True) }}
{% endcall %}

{% call cfg('keepass') %}
{{ ppa_present('keepass-plugins', 'dlech/keepass2-plugins') }}
{{ check('keepass2', True) }}
{{ check('keepass2-plugin-keeagent', True) }}
{{ check('keepass2-plugin-ubuntu', True) }}
{{ check('keepasshttp', True) }}
{% endcall %}

{% call cfg('texlive') %}
{{ check('texlive', True) }}
{{ check('texlive-latex-extra', True) }}
{{ check('texlive-science', True) }}
{{ check('texlive-lang-german', True) }}
{% endcall %}
